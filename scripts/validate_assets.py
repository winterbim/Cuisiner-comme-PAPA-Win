#!/usr/bin/env python3
"""Contrôle de publication des images de Cuisiner comme Papa Win.

Vérifie, sans dépendance externe :
  • les 75 illustrations de recettes : présence, Contents.json, format (PNG/JPEG),
    extension, dimensions, ratio, transparence, qualité (compression), poids,
    statut dans docs/illustrations/manifest.json, et refus des anciennes vignettes provisoires ;
  • la mascotte : illustration validée, version HD, portrait rond transparent ;
  • l'icône iOS : PNG 1024 × 1024, sans canal alpha, 8 bits, Contents.json conforme ;
  • la cohérence du catalogue (couleur d'accent, imagesets orphelins).

Usage :
  python3 scripts/validate_assets.py                  # contrôle bloquant (code 1 si erreur)
  python3 scripts/validate_assets.py --non-bloquant   # rapport seul (code 0), pour la CI de vérification
  python3 scripts/validate_assets.py --json rapport.json
"""
from __future__ import annotations

import argparse
import json
import sys
from collections import Counter

import asset_lib as A

MASCOT_NAMES = {"papa_win", "papa_win_hd", "papa_win_round"}


class Report:
    def __init__(self) -> None:
        self.errors: list[str] = []
        self.warnings: list[str] = []

    def error(self, msg: str) -> None:
        self.errors.append(msg)

    def warn(self, msg: str) -> None:
        self.warnings.append(msg)


def check_recipes(report: Report, manifest: dict) -> dict:
    spec = manifest["specification"]["recettes"]
    legacy = set(manifest.get("empreintes_vignettes_provisoires", []))
    entries = manifest.get("recettes", {})
    recipes = A.load_recipes()
    ids = [r["id"] for r in recipes]
    statuses: Counter = Counter()
    effective: dict = {}

    for unknown in sorted(set(entries) - set(ids)):
        report.error(f"[manifeste] « {unknown} » ne correspond à aucune recette")

    for recipe in recipes:
        rid = recipe["id"]
        label = f"[{rid}] {recipe['name']}"
        entry = entries.get(rid)
        if entry is None:
            report.error(f"{label} : absente du manifeste")
            entry = {"statut": "manquante"}
        status = entry.get("statut")
        if status not in A.STATUSES:
            report.error(f"{label} : statut inconnu « {status} »")
            status = "manquante"

        imageset = A.load_imageset(rid)
        if not imageset.exists:
            if status != "manquante":
                report.error(f"{label} : statut « {status} » mais aucune image dans Assets.xcassets")
            report.error(f"{label} : illustration manquante")
            statuses["manquante"] += 1
            effective[rid] = "manquante"
            continue
        for problem in imageset.problems:
            report.error(f"{label} : {problem}")
        if not imageset.files:
            statuses["manquante"] += 1
            effective[rid] = "manquante"
            continue

        path = imageset.files[0]
        info = A.read_image(path)
        if info.error:
            report.error(f"{label} : {path.name} {info.error}")
        if info.format and info.format not in spec["formats"]:
            report.error(f"{label} : format {info.format} non accepté")
        if info.format and not A.extension_matches(path, info.format):
            report.error(f"{label} : extension « {path.suffix} » incohérente avec le format {info.format.upper()}")

        is_legacy = A.sha256(path) in legacy
        if is_legacy:
            report.error(f"{label} : ancienne vignette provisoire (planche découpée, texte incrusté) — à remplacer")
            if status not in ("provisoire",):
                report.error(f"{label} : marquée « {status} » alors que c'est une vignette provisoire")
            status = "provisoire"

        if info.width and info.height:
            if info.width < spec["largeur_min"] or info.height < spec["hauteur_min"]:
                report.error(f"{label} : {info.width}×{info.height} px, minimum {spec['largeur_min']}×{spec['hauteur_min']}")
            if not (spec["ratio_min"] <= info.ratio <= spec["ratio_max"]):
                report.warn(f"{label} : ratio {info.ratio:.2f} hors de la plage conseillée "
                            f"{spec['ratio_min']}–{spec['ratio_max']} (4:3 conseillé)")
            if info.format == "jpeg" and info.bits_per_pixel < spec["bits_par_pixel_min"]:
                report.error(f"{label} : compression trop forte ({info.bits_per_pixel:.2f} bit/pixel)")
        if info.has_alpha and not spec["transparence"]:
            report.error(f"{label} : contient de la transparence (fond plein requis)")
        if info.size_bytes > spec["poids_max_octets"]:
            report.warn(f"{label} : fichier lourd ({info.size_bytes / 1_000_000:.1f} Mo), à optimiser")
        if info.format == "jpeg" and info.components == 4:
            report.error(f"{label} : JPEG CMJN, convertir en RVB")
        if info.format == "png" and info.bit_depth == 16:
            report.warn(f"{label} : PNG 16 bits, 8 bits suffisent")

        if status == "a_verifier":
            report.error(f"{label} : importée mais pas encore validée visuellement "
                         f"(python3 scripts/illustrations.py valider {rid})")
        elif status == "manquante":
            report.error(f"{label} : une image est présente mais le manifeste la dit manquante")
        statuses[status] += 1
        effective[rid] = status

    return {"total": len(ids), "statuts": dict(statuses), "par_recette": effective}


def check_mascot(report: Report, manifest: dict) -> None:
    spec = manifest["specification"]["mascotte"]
    original = A.load_imageset("papa_win")
    if not original.files:
        report.error("[mascotte] illustration validée papa_win absente — référence graphique unique obligatoire")
    for problem in original.problems:
        report.error(f"[mascotte] papa_win : {problem}")
    for path in original.files:
        info = A.read_image(path)
        if info.error or info.format not in ("png", "jpeg"):
            report.error(f"[mascotte] papa_win : {info.error or 'format non accepté'}")

    hd = A.load_imageset("papa_win_hd")
    if not hd.files:
        report.error("[mascotte] papa_win_hd absente (python3 design/mascotte/generer_mascotte.py)")
    for problem in hd.problems:
        report.error(f"[mascotte] papa_win_hd : {problem}")
    for path in hd.files:
        info = A.read_image(path)
        if info.error:
            report.error(f"[mascotte] papa_win_hd : {info.error}")
        elif info.width != info.height or info.width < spec["hd_cote_min"]:
            report.error(f"[mascotte] papa_win_hd : {info.width}×{info.height}, carré ≥ {spec['hd_cote_min']} attendu")

    rnd = A.load_imageset("papa_win_round")
    if not rnd.files:
        report.error("[mascotte] papa_win_round absent (python3 design/mascotte/generer_mascotte.py)")
    for problem in rnd.problems:
        report.error(f"[mascotte] papa_win_round : {problem}")
    for path in rnd.files:
        info = A.read_image(path)
        if info.error:
            report.error(f"[mascotte] papa_win_round : {info.error}")
            continue
        if info.format != "png":
            report.error("[mascotte] papa_win_round : PNG attendu")
        if spec["portrait_rond_transparent"] and not info.has_alpha:
            report.error("[mascotte] papa_win_round : fond transparent attendu autour du cercle")
        if info.width != info.height or info.width < spec["hd_cote_min"]:
            report.error(f"[mascotte] papa_win_round : {info.width}×{info.height}, carré ≥ {spec['hd_cote_min']} attendu")

    if not manifest["mascotte"].get("source_hd", False):
        report.warn("[mascotte] l'original validé fait 256 × 256 : papa_win_hd, papa_win_round et l'icône sont "
                    "interpolés. Fournir l'illustration originale en haute définition (voir design/mascotte/README.md)")


def check_icon(report: Report, manifest: dict) -> None:
    spec = manifest["specification"]["icone"]
    folder = A.ASSETS_DIR / "AppIcon.appiconset"
    try:
        contents = json.loads((folder / "Contents.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        report.error(f"[icône] Contents.json invalide ({exc})")
        return
    entries = [e for e in contents.get("images", []) if isinstance(e, dict)]
    marketing = [e for e in entries if e.get("size") == "1024x1024" and e.get("idiom") == "universal"
                 and e.get("platform") == "ios" and not e.get("appearances")]
    if len(marketing) != 1 or "filename" not in marketing[0]:
        report.error("[icône] une entrée universelle iOS 1024x1024 avec fichier est attendue dans Contents.json")
        return
    path = folder / marketing[0]["filename"]
    if not path.is_file():
        report.error(f"[icône] fichier absent : {path.name}")
        return
    info = A.read_image(path)
    if info.error:
        report.error(f"[icône] {info.error}")
        return
    if info.format != spec["format"]:
        report.error(f"[icône] PNG obligatoire (reçu : {info.format})")
    if (info.width, info.height) != (spec["taille"], spec["taille"]):
        report.error(f"[icône] {info.width}×{info.height}, {spec['taille']}×{spec['taille']} exigé")
    if info.has_alpha:
        report.error("[icône] canal alpha ou transparence interdits par l'App Store")
    if info.format == "png" and info.color_type not in (2,):
        report.error(f"[icône] PNG RVB 24 bits attendu (type de couleur {info.color_type})")
    if info.bit_depth != 8:
        report.error(f"[icône] profondeur {info.bit_depth} bits, 8 bits attendus")
    if info.interlaced:
        report.warn("[icône] PNG entrelacé, préférer non entrelacé")
    extras = [e for e in entries if e is not marketing[0]]
    for extra in extras:
        if "filename" in extra and not (folder / extra["filename"]).is_file():
            report.error(f"[icône] variante référencée absente : {extra['filename']}")


def check_catalog(report: Report) -> None:
    if not (A.ASSETS_DIR / "Contents.json").is_file():
        report.error("[catalogue] Assets.xcassets/Contents.json absent")
    if not (A.ASSETS_DIR / "AccentColor.colorset" / "Contents.json").is_file():
        report.error("[catalogue] AccentColor.colorset absent (référencé par le projet Xcode)")
    recipe_ids = {r["id"] for r in A.load_recipes()}
    for folder in sorted(A.ASSETS_DIR.glob("*.imageset")):
        name = folder.name[: -len(".imageset")]
        if name not in recipe_ids and name not in MASCOT_NAMES:
            report.warn(f"[catalogue] imageset orphelin (aucune recette) : {name}")


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--non-bloquant", action="store_true", help="toujours terminer avec le code 0")
    parser.add_argument("--json", metavar="FICHIER", help="écrire le rapport au format JSON")
    args = parser.parse_args(argv)

    report = Report()
    try:
        manifest = A.load_manifest()
    except (OSError, json.JSONDecodeError) as exc:
        print(f"ÉCHEC — manifeste illisible : {A.MANIFEST_PATH} ({exc})")
        return 0 if args.non_bloquant else 1

    summary = check_recipes(report, manifest)
    check_mascot(report, manifest)
    check_icon(report, manifest)
    check_catalog(report)

    st = summary["statuts"]
    print("=== Illustrations des recettes ===")
    print(f"Recettes contrôlées : {summary['total']}")
    for key in ("definitive", "a_verifier", "provisoire", "manquante"):
        print(f"  {A.STATUS_LABELS[key]:<32} {st.get(key, 0)}")
    print(f"Prêtes pour la publication : {st.get('definitive', 0)}/{summary['total']}")

    if report.warnings:
        print(f"\n=== Avertissements ({len(report.warnings)}) ===")
        for msg in report.warnings:
            print(f"- {msg}")
    if report.errors:
        print(f"\n=== Erreurs bloquantes ({len(report.errors)}) ===")
        for msg in report.errors:
            print(f"- {msg}")
        print("\nÉCHEC — publication bloquée tant que ces erreurs ne sont pas corrigées.")
    else:
        print("\nOK — images prêtes pour la publication.")

    if args.json:
        with open(args.json, "w", encoding="utf-8") as fh:
            json.dump({"resume": summary, "erreurs": report.errors, "avertissements": report.warnings},
                      fh, ensure_ascii=False, indent=2)

    if report.errors and not args.non_bloquant:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
