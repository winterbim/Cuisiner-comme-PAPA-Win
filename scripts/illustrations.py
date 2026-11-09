#!/usr/bin/env python3
"""Gestion des 75 illustrations de recettes (remplacement, validation, suivi).

Commandes :
  python3 scripts/illustrations.py importer DOSSIER
        Importe les fichiers DOSSIER/<id>.jpg|.jpeg|.png. Chaque image est contrôlée
        (format, dimensions, transparence, compression, ancienne vignette) puis passe
        au statut « a_verifier ». Une image non conforme est refusée.
        « papa_win.jpg|png » remplace l'illustration validée de la mascotte.
  python3 scripts/illustrations.py valider ID [ID ...]
        Après vérification visuelle (bon plat, sans texte, sans personnage), passe
        les recettes au statut « definitive ».
  python3 scripts/illustrations.py etat
        Régénère docs/illustrations/ETAT.md et docs/illustrations/BRIEF.md.
"""
from __future__ import annotations

import argparse
import datetime as dt
import sys
from pathlib import Path

import asset_lib as A

REGION_TITLES = {"portugal": "Portugal", "asie": "Asie", "afrique": "Afrique", "maghreb": "Maghreb", "france": "France"}
REGION_ORDER = ["portugal", "asie", "afrique", "maghreb", "france"]
SKIP_INGREDIENTS = ("sel", "poivre", "eau", "huile")


def technical_problems(path: Path, manifest: dict) -> list[str]:
    spec = manifest["specification"]["recettes"]
    info = A.read_image(path)
    problems = []
    if info.error:
        return [info.error]
    if info.format not in spec["formats"]:
        problems.append(f"format {info.format} non accepté")
    if not A.extension_matches(path, info.format):
        problems.append(f"extension {path.suffix} incohérente avec {info.format}")
    if info.width < spec["largeur_min"] or info.height < spec["hauteur_min"]:
        problems.append(f"{info.width}×{info.height} px < {spec['largeur_min']}×{spec['hauteur_min']}")
    if info.has_alpha and not spec["transparence"]:
        problems.append("transparence interdite (fond plein requis)")
    if info.format == "jpeg" and info.width and info.bits_per_pixel < spec["bits_par_pixel_min"]:
        problems.append(f"compression trop forte ({info.bits_per_pixel:.2f} bit/pixel)")
    if info.format == "jpeg" and info.components == 4:
        problems.append("JPEG CMJN, convertir en RVB")
    if A.sha256(path) in set(manifest.get("empreintes_vignettes_provisoires", [])):
        problems.append("ancienne vignette provisoire : refusée")
    return problems


def cmd_importer(folder: Path) -> int:
    manifest = A.load_manifest()
    ids = {r["id"] for r in A.load_recipes()}
    imported, refused, ignored = [], [], []
    for path in sorted(folder.iterdir()):
        ext = path.suffix.lower()
        if ext not in (".jpg", ".jpeg", ".png"):
            continue
        name = path.stem
        if name == "papa_win":
            info = A.read_image(path)
            if info.error or info.format not in ("png", "jpeg") or not A.extension_matches(path, info.format):
                refused.append(f"{path.name} : {info.error or 'format/extension invalide'}")
                continue
            A.write_imageset("papa_win", path, f"papa_win{'.png' if info.format == 'png' else '.jpg'}")
            manifest["mascotte"]["source_hd"] = info.width >= 1024 and info.height >= 1024
            imported.append("papa_win (relancer design/mascotte/generer_mascotte.py)")
            continue
        if name not in ids:
            ignored.append(path.name)
            continue
        problems = technical_problems(path, manifest)
        if problems:
            refused.append(f"{path.name} : " + " ; ".join(problems))
            continue
        target_name = f"{name}{'.png' if ext == '.png' else '.jpg'}"
        A.write_imageset(name, path, target_name)
        manifest["recettes"][name] = {
            "statut": "a_verifier",
            "note": f"Importée le {dt.date.today().isoformat()} depuis {path.name}, à vérifier visuellement.",
        }
        imported.append(name)
    A.save_manifest(manifest)
    print(f"Importées : {len(imported)}")
    for item in imported:
        print(f"  + {item}")
    if refused:
        print(f"Refusées : {len(refused)}")
        for item in refused:
            print(f"  ✗ {item}")
    if ignored:
        print("Ignorées (aucune recette de ce nom) : " + ", ".join(ignored))
    write_docs(manifest)
    return 1 if refused else 0


def cmd_valider(ids: list[str]) -> int:
    manifest = A.load_manifest()
    known = {r["id"] for r in A.load_recipes()}
    failures = 0
    for rid in ids:
        if rid not in known:
            print(f"✗ {rid} : recette inconnue")
            failures += 1
            continue
        imageset = A.load_imageset(rid)
        if not imageset.files:
            print(f"✗ {rid} : aucune image importée")
            failures += 1
            continue
        problems = technical_problems(imageset.files[0], manifest) + imageset.problems
        if problems:
            print(f"✗ {rid} : " + " ; ".join(problems))
            failures += 1
            continue
        manifest["recettes"][rid] = {
            "statut": "definitive",
            "note": f"Validée visuellement le {dt.date.today().isoformat()}.",
        }
        print(f"✓ {rid} : définitive")
    A.save_manifest(manifest)
    write_docs(manifest)
    return 1 if failures else 0


def key_ingredients(recipe: dict, limit: int = 6) -> str:
    names = []
    for ing in recipe["ingredients"]:
        name = ing["name"]
        if name.lower().startswith(SKIP_INGREDIENTS):
            continue
        names.append(name)
        if len(names) == limit:
            break
    return ", ".join(names)


def write_docs(manifest: dict) -> None:
    recipes = A.load_recipes()
    by_region: dict = {}
    for recipe in recipes:
        by_region.setdefault(recipe["region"], []).append(recipe)
    spec = manifest["specification"]["recettes"]
    counts: dict = {}
    for entry in manifest["recettes"].values():
        counts[entry["statut"]] = counts.get(entry["statut"], 0) + 1

    lines = [
        "# État des illustrations",
        "",
        "> Fichier généré par `python3 scripts/illustrations.py etat` — ne pas modifier à la main.",
        "",
        f"**{counts.get('definitive', 0)}/{len(recipes)} illustrations définitives.** "
        + " · ".join(f"{A.STATUS_LABELS[s]} : {counts.get(s, 0)}" for s in A.STATUSES),
        "",
    ]
    for region in REGION_ORDER:
        lines += [f"## {REGION_TITLES[region]}", "", "| # | Fichier attendu | Plat | Statut | Image actuelle |", "|---|---|---|---|---|"]
        for index, recipe in enumerate(by_region.get(region, []), start=1):
            rid = recipe["id"]
            status = manifest["recettes"].get(rid, {}).get("statut", "manquante")
            imageset = A.load_imageset(rid)
            current = "—"
            if imageset.files:
                info = A.read_image(imageset.files[0])
                current = f"{info.width}×{info.height} {info.format or '?'}"
            lines.append(f"| {index} | `{rid}.jpg` | {recipe['name']} | {A.STATUS_LABELS[status]} | {current} |")
        lines.append("")
    (A.MANIFEST_PATH.parent / "ETAT.md").write_text("\n".join(lines), encoding="utf-8")

    brief = [
        "# Brief des 75 illustrations de plats",
        "",
        "> Fichier généré par `python3 scripts/illustrations.py etat` à partir des recettes.",
        "",
        "## Règles communes",
        "",
        f"- **Format :** {spec['format_conseille']} ; minimum {spec['largeur_min']} × {spec['hauteur_min']} px ; "
        f"JPEG ou PNG sans transparence ; moins de {spec['poids_max_octets'] // 1_000_000} Mo.",
        "- **Nom du fichier :** exactement l'identifiant de la recette (colonne « Fichier »).",
        "- **Contenu :** une seule assiette du plat exact, vue légèrement plongeante, centrée, avec une marge "
        "autour (l'image est recadrée en carte 4:3 et en bandeau de fiche).",
        "- **Style :** illustration culinaire dessinée, chaleureuse et colorée, cohérente avec l'illustration "
        "Papa Win validée (contours propres, lumière douce, fond de cuisine crème/bois clair).",
        "- **Interdits :** texte ou nom incrusté, personnage ou mascotte dans l'image, plat d'une autre recette, "
        "réutilisation d'une même image, recadrage des anciennes planches, dessert.",
        "",
    ]
    for region in REGION_ORDER:
        brief += [f"## {REGION_TITLES[region]}", "", "| Fichier | Plat (nom Win) | Plat réel | Pays | Éléments à montrer |", "|---|---|---|---|---|"]
        for recipe in by_region.get(region, []):
            brief.append(
                f"| `{recipe['id']}.jpg` | {recipe['name']} | {recipe['originalName']} | "
                f"{recipe['flag']} {recipe['country']} | {key_ingredients(recipe)} |"
            )
        brief.append("")
    (A.MANIFEST_PATH.parent / "BRIEF.md").write_text("\n".join(brief), encoding="utf-8")


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="commande", required=True)
    p_imp = sub.add_parser("importer", help="importer un dossier d'illustrations")
    p_imp.add_argument("dossier", type=Path)
    p_val = sub.add_parser("valider", help="marquer des illustrations comme définitives")
    p_val.add_argument("ids", nargs="+")
    sub.add_parser("etat", help="régénérer ETAT.md et BRIEF.md")
    args = parser.parse_args(argv)

    if args.commande == "importer":
        if not args.dossier.is_dir():
            print(f"Dossier introuvable : {args.dossier}")
            return 2
        return cmd_importer(args.dossier)
    if args.commande == "valider":
        return cmd_valider(args.ids)
    write_docs(A.load_manifest())
    print("docs/illustrations/ETAT.md et BRIEF.md régénérés.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
