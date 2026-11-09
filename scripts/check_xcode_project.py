#!/usr/bin/env python3
"""Contrôle du projet Xcode et de sa cohérence avec codemagic.yaml.

Analyse réellement project.pbxproj (format plist OpenStep) et vérifie :
  • la syntaxe et toutes les références d'objets ;
  • les cibles app et tests, le scheme partagé et ses BlueprintIdentifier ;
  • le Bundle ID (identique dans le projet et codemagic.yaml), version, build,
    cible iOS, famille d'appareils, icône, couleur d'accent, Info.plist généré,
    déclaration de chiffrement, numérotation des builds (agvtool) ;
  • les dossiers synchronisés et la présence des ressources attendues.

Usage : python3 scripts/check_xcode_project.py
"""
from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PROJECT = ROOT / "CuisinerCommePapaWin.xcodeproj"
PBXPROJ = PROJECT / "project.pbxproj"
SCHEME = PROJECT / "xcshareddata" / "xcschemes" / "CuisinerCommePapaWin.xcscheme"
CODEMAGIC = ROOT / "codemagic.yaml"
APP_NAME = "CuisinerCommePapaWin"
TEST_NAME = "CuisinerCommePapaWinTests"
DEPLOYMENT_TARGET = "17.0"


# --------------------------------------------------------------------------- analyseur OpenStep

class ParseError(Exception):
    pass


_TOKEN = re.compile(r'\s+|//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"|[{}();=,]|[^\s{}();=,"]+', re.S)


def tokenize(text: str) -> list[str]:
    tokens, pos = [], 0
    while pos < len(text):
        match = _TOKEN.match(text, pos)
        if not match:
            raise ParseError(f"caractère inattendu à la position {pos}")
        tok = match.group(0)
        pos = match.end()
        if tok.isspace() or tok.startswith("//") or tok.startswith("/*"):
            continue
        tokens.append(tok)
    return tokens


def parse(text: str):
    tokens = tokenize(text)
    index = 0

    def value():
        nonlocal index
        if index >= len(tokens):
            raise ParseError("fin de fichier inattendue")
        tok = tokens[index]
        index += 1
        if tok == "{":
            result = {}
            while tokens[index] != "}":
                key = value()
                if tokens[index] != "=":
                    raise ParseError(f"« = » attendu après {key!r}")
                index += 1
                result[key] = value()
                if tokens[index] != ";":
                    raise ParseError(f"« ; » attendu après la valeur de {key!r}")
                index += 1
            index += 1
            return result
        if tok == "(":
            items = []
            while tokens[index] != ")":
                items.append(value())
                if tokens[index] == ",":
                    index += 1
                elif tokens[index] != ")":
                    raise ParseError("« , » ou « ) » attendu dans une liste")
            index += 1
            return items
        if tok.startswith('"'):
            return bytes(tok[1:-1], "utf-8").decode("unicode_escape").encode("latin-1").decode("utf-8")
        if tok in "{}();=,":
            raise ParseError(f"symbole inattendu « {tok} »")
        return tok

    root = value()
    if index != len(tokens):
        raise ParseError("contenu en trop après la racine")
    return root


# --------------------------------------------------------------------------- contrôles

def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []
    ok: list[str] = []

    try:
        project = parse(PBXPROJ.read_text(encoding="utf-8"))
    except (OSError, ParseError) as exc:
        print(f"ÉCHEC — project.pbxproj illisible : {exc}")
        return 1
    ok.append("project.pbxproj : syntaxe valide")
    objects = project["objects"]

    # Références : chaque identifiant à 24 caractères hexadécimaux doit exister.
    ids = set(objects)
    dangling = set()

    def walk(node):
        if isinstance(node, dict):
            for item in node.values():
                walk(item)
        elif isinstance(node, list):
            for item in node:
                walk(item)
        elif isinstance(node, str) and re.fullmatch(r"[0-9A-F]{24}", node) and node not in ids:
            dangling.add(node)

    walk(objects)
    walk(project["rootObject"])
    if dangling:
        errors.append("références vers des objets inexistants : " + ", ".join(sorted(dangling)))
    else:
        ok.append(f"{len(ids)} objets, aucune référence cassée")

    root = objects[project["rootObject"]]
    targets = {objects[t]["name"]: (t, objects[t]) for t in root["targets"]}
    for name in (APP_NAME, TEST_NAME):
        if name not in targets:
            errors.append(f"cible absente : {name}")
    if errors:
        return report(ok, warnings, errors)

    def configs(target):
        lst = objects[target["buildConfigurationList"]]
        return {objects[c]["name"]: objects[c]["buildSettings"] for c in lst["buildConfigurations"]}

    app_id, app = targets[APP_NAME]
    test_id, test = targets[TEST_NAME]
    if app.get("productType") != "com.apple.product-type.application":
        errors.append("la cible app n'est pas de type application")
    if test.get("productType") != "com.apple.product-type.bundle.unit-test":
        errors.append("la cible de tests n'est pas de type unit-test")

    # Dossiers synchronisés
    for target in (app, test):
        for group_id in target.get("fileSystemSynchronizedGroups", []):
            folder = ROOT / objects[group_id]["path"]
            if not folder.is_dir():
                errors.append(f"dossier synchronisé introuvable : {folder.relative_to(ROOT)}")
            else:
                ok.append(f"dossier synchronisé : {folder.relative_to(ROOT)}/")

    # Réglages de l'app (Debug et Release identiques sur les points critiques)
    app_cfgs = configs(app)
    project_cfgs = {objects[c]["name"]: objects[c]["buildSettings"]
                    for c in objects[root["buildConfigurationList"]]["buildConfigurations"]}
    if set(app_cfgs) != {"Debug", "Release"}:
        errors.append(f"configurations de l'app inattendues : {sorted(app_cfgs)}")
    expected = {
        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
        "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
        "GENERATE_INFOPLIST_FILE": "YES",
        "INFOPLIST_KEY_ITSAppUsesNonExemptEncryption": "NO",
        "INFOPLIST_KEY_UILaunchScreen_Generation": "YES",
        "TARGETED_DEVICE_FAMILY": "1",
        "VERSIONING_SYSTEM": "apple-generic",
        "CODE_SIGN_STYLE": "Automatic",
        "PRODUCT_NAME": "$(TARGET_NAME)",
    }
    bundle_ids = set()
    for cfg_name, settings in app_cfgs.items():
        for key, value in expected.items():
            if settings.get(key) != value:
                errors.append(f"app/{cfg_name} : {key} = {settings.get(key)!r}, attendu {value!r}")
        target_ios = settings.get("IPHONEOS_DEPLOYMENT_TARGET") or project_cfgs.get(cfg_name, {}).get("IPHONEOS_DEPLOYMENT_TARGET")
        if target_ios != DEPLOYMENT_TARGET:
            errors.append(f"app/{cfg_name} : iOS minimum {target_ios}, attendu {DEPLOYMENT_TARGET}")
        if not re.fullmatch(r"\d+\.\d+(\.\d+)?", str(settings.get("MARKETING_VERSION", ""))):
            errors.append(f"app/{cfg_name} : MARKETING_VERSION invalide")
        if not str(settings.get("CURRENT_PROJECT_VERSION", "")).isdigit():
            errors.append(f"app/{cfg_name} : CURRENT_PROJECT_VERSION doit être un entier")
        if not settings.get("INFOPLIST_KEY_CFBundleDisplayName"):
            errors.append(f"app/{cfg_name} : nom affiché (CFBundleDisplayName) manquant")
        if not settings.get("DEVELOPMENT_TEAM"):
            warnings.append(f"app/{cfg_name} : DEVELOPMENT_TEAM vide (normal : fourni par Codemagic "
                            "ou à choisir dans Xcode › Signing & Capabilities)")
        bundle_ids.add(settings.get("PRODUCT_BUNDLE_IDENTIFIER"))
    if len(bundle_ids) != 1:
        errors.append(f"Bundle ID différent entre Debug et Release : {bundle_ids}")
    bundle_id = next(iter(bundle_ids))
    if not re.fullmatch(r"[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+", bundle_id or ""):
        errors.append(f"Bundle ID mal formé : {bundle_id!r}")
    else:
        ok.append(f"Bundle ID de l'app : {bundle_id}")
    first = app_cfgs.get("Release", {})
    ok.append(f"version {first.get('MARKETING_VERSION')} (build {first.get('CURRENT_PROJECT_VERSION')}), "
              f"iOS {DEPLOYMENT_TARGET}+, iPhone, nom affiché « {first.get('INFOPLIST_KEY_CFBundleDisplayName')} »")

    # Cible de tests
    for cfg_name, settings in configs(test).items():
        host = settings.get("TEST_HOST", "")
        if f"/{APP_NAME}.app/" not in host:
            errors.append(f"tests/{cfg_name} : TEST_HOST ne pointe pas vers {APP_NAME}.app")
        if settings.get("BUNDLE_LOADER") != "$(TEST_HOST)":
            errors.append(f"tests/{cfg_name} : BUNDLE_LOADER doit valoir $(TEST_HOST)")
        if not str(settings.get("PRODUCT_BUNDLE_IDENTIFIER", "")).startswith(bundle_id + "."):
            errors.append(f"tests/{cfg_name} : Bundle ID des tests doit commencer par {bundle_id}.")
    deps = [objects[d].get("target") for d in test.get("dependencies", [])]
    if app_id not in deps:
        errors.append("la cible de tests ne dépend pas de l'app")
    if "Debug" in project_cfgs and project_cfgs["Debug"].get("ENABLE_TESTABILITY") != "YES":
        errors.append("ENABLE_TESTABILITY doit être YES en Debug (@testable import)")

    # Ressources
    assets = ROOT / APP_NAME / "Resources" / "Assets.xcassets"
    for needed in ("AppIcon.appiconset/Contents.json", "AccentColor.colorset/Contents.json"):
        if not (assets / needed).is_file():
            errors.append(f"ressource manquante : Assets.xcassets/{needed}")
    data_files = sorted((ROOT / APP_NAME / "Resources" / "Data").glob("recipes_*.json"))
    if len(data_files) != 5:
        errors.append(f"5 fichiers de recettes attendus, {len(data_files)} trouvés")
    else:
        ok.append("ressources : catalogue d'images, couleur d'accent, 5 fichiers de recettes")

    # Scheme partagé
    try:
        scheme = ET.parse(SCHEME).getroot()
        refs = {ref.get("BlueprintIdentifier"): ref.get("BlueprintName") for ref in scheme.iter("BuildableReference")}
        if refs.get(app_id) != APP_NAME:
            errors.append("le scheme ne référence pas la cible app avec le bon identifiant")
        if refs.get(test_id) != TEST_NAME:
            errors.append("le scheme ne référence pas la cible de tests avec le bon identifiant")
        archive = scheme.find("ArchiveAction")
        if archive is None or archive.get("buildConfiguration") != "Release":
            errors.append("l'archive du scheme doit utiliser la configuration Release")
        if not errors:
            ok.append("scheme partagé CuisinerCommePapaWin : build, tests, archive Release")
    except (OSError, ET.ParseError) as exc:
        errors.append(f"scheme partagé illisible : {exc}")

    # Cohérence avec codemagic.yaml
    if CODEMAGIC.is_file():
        text = CODEMAGIC.read_text(encoding="utf-8")
        cm_ids = set(re.findall(r"bundle_identifier:\s*([\w.\-]+)", text)) | set(re.findall(r"BUNDLE_ID:\s*([\w.\-]+)", text))
        if cm_ids != {bundle_id}:
            errors.append(f"codemagic.yaml utilise le(s) Bundle ID {sorted(cm_ids)}, le projet {bundle_id}")
        else:
            ok.append(f"codemagic.yaml : même Bundle ID ({bundle_id})")
        for needle in (f"XCODE_SCHEME: {APP_NAME}", f"XCODE_PROJECT: {APP_NAME}.xcodeproj"):
            if needle not in text:
                errors.append(f"codemagic.yaml : « {needle} » attendu")
        if re.search(r"submit_to_app_store:\s*true", text):
            errors.append("codemagic.yaml : la soumission automatique à l'App Store est interdite sans accord du propriétaire")
    else:
        errors.append("codemagic.yaml absent")

    return report(ok, warnings, errors)


def report(ok: list[str], warnings: list[str], errors: list[str]) -> int:
    print("=== Projet Xcode ===")
    for line in ok:
        print(f"✓ {line}")
    for line in warnings:
        print(f"! {line}")
    for line in errors:
        print(f"✗ {line}")
    if errors:
        print(f"\nÉCHEC — {len(errors)} problème(s) dans le projet Xcode.")
        return 1
    print("\nOK — projet Xcode cohérent.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
