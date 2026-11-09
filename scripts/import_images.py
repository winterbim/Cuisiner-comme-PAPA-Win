#!/usr/bin/env python3
"""Importe des images dans Assets.xcassets.

Usage : python3 scripts/import_images.py DOSSIER

Chaque fichier du DOSSIER doit s'appeler comme l'id d'une recette
(ex. « lok-win.jpg », « coq-au-win.png ») ou « papa_win.png » pour la mascotte.
Formats acceptés : .jpg, .jpeg, .png. Une image existante du même nom est remplacée.
"""
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "CuisinerCommePapaWin" / "Resources" / "Assets.xcassets"
DATA = ROOT / "CuisinerCommePapaWin" / "Resources" / "Data"


def known_ids():
    ids = {"papa_win"}
    for f in DATA.glob("recipes_*.json"):
        ids |= {r["id"] for r in json.loads(f.read_text(encoding="utf-8"))}
    return ids


def main(argv):
    if len(argv) != 1:
        print(__doc__)
        return 2
    src = Path(argv[0])
    ids = known_ids()
    imported, unknown = [], []
    for img in sorted(src.iterdir()):
        if img.suffix.lower() not in {".jpg", ".jpeg", ".png"}:
            continue
        name = img.stem
        if name not in ids:
            unknown.append(img.name)
            continue
        target = ASSETS / f"{name}.imageset"
        if target.exists():
            shutil.rmtree(target)
        target.mkdir(parents=True)
        filename = f"{name}{img.suffix.lower()}"
        shutil.copyfile(img, target / filename)
        contents = {
            "images": [{"filename": filename, "idiom": "universal"}],
            "info": {"author": "xcode", "version": 1},
        }
        (target / "Contents.json").write_text(json.dumps(contents, indent=2) + "\n", encoding="utf-8")
        imported.append(name)
    print(f"{len(imported)} image(s) importée(s).")
    if unknown:
        print("Ignorées (nom qui ne correspond à aucune recette) : " + ", ".join(unknown))
    missing = sorted(ids - {p.name.removesuffix('.imageset') for p in ASSETS.glob('*.imageset')})
    print(f"Images encore manquantes ({len(missing)}) : " + ", ".join(missing))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
