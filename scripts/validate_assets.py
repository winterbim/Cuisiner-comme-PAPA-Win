#!/usr/bin/env python3
"""Vérifie la couverture des images de l'application Cuisiner comme Papa Win."""
from __future__ import annotations

import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "CuisinerCommePapaWin" / "Resources" / "Data"
ASSETS_DIR = ROOT / "CuisinerCommePapaWin" / "Resources" / "Assets.xcassets"
RECIPE_FILES = sorted(DATA_DIR.glob("recipes_*.json"))


def png_size(path: Path) -> tuple[int, int] | None:
    try:
        with path.open("rb") as stream:
            header = stream.read(24)
        if len(header) < 24 or header[:8] != b"\x89PNG\r\n\x1a\n":
            return None
        return struct.unpack(">II", header[16:24])
    except OSError:
        return None


def main() -> int:
    errors: list[str] = []
    recipes: list[str] = []
    seen: set[str] = set()

    if not RECIPE_FILES:
        errors.append(f"Aucun fichier de recettes trouvé dans {DATA_DIR}")

    for path in RECIPE_FILES:
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"{path.name}: JSON illisible ({exc})")
            continue
        if not isinstance(data, list):
            errors.append(f"{path.name}: la racine JSON doit être un tableau")
            continue
        for recipe in data:
            recipe_id = recipe.get("id") if isinstance(recipe, dict) else None
            if not isinstance(recipe_id, str) or not recipe_id:
                errors.append(f"{path.name}: recette sans id texte valide")
                continue
            if recipe_id in seen:
                errors.append(f"ID de recette en double: {recipe_id}")
            seen.add(recipe_id)
            recipes.append(recipe_id)

    missing: list[str] = []
    invalid_sets: list[str] = []
    for recipe_id in recipes:
        asset_set = ASSETS_DIR / f"{recipe_id}.imageset"
        contents_path = asset_set / "Contents.json"
        if not contents_path.is_file():
            missing.append(recipe_id)
            continue
        try:
            contents = json.loads(contents_path.read_text(encoding="utf-8"))
            entries = contents.get("images", [])
            filenames = [
                entry.get("filename")
                for entry in entries
                if isinstance(entry, dict)
            ]
            if not filenames or not any(
                (asset_set / name).is_file()
                for name in filenames
                if isinstance(name, str)
            ):
                invalid_sets.append(recipe_id)
        except (OSError, json.JSONDecodeError, AttributeError):
            invalid_sets.append(recipe_id)

    mascot_set = ASSETS_DIR / "papa_win.imageset"
    if not (mascot_set / "papa_win.jpg").is_file() or not (mascot_set / "Contents.json").is_file():
        errors.append("Mascotte manquante: papa_win.imageset/papa_win.jpg")

    app_icon = ASSETS_DIR / "AppIcon.appiconset" / "AppIcon.png"
    if not app_icon.is_file():
        errors.append("Icône App Store manquante: AppIcon.appiconset/AppIcon.png")
    else:
        size = png_size(app_icon)
        if size != (1024, 1024):
            errors.append(f"Icône App Store: dimensions attendues 1024x1024, reçues {size}")

    print(f"Recettes contrôlées : {len(recipes)}")
    print(f"Images de recettes présentes : {len(recipes) - len(missing) - len(invalid_sets)}")
    print(f"Images manquantes : {len(missing)}")
    if missing:
        print("  " + ", ".join(missing))
    print(f"Assets invalides : {len(invalid_sets)}")
    if invalid_sets:
        print("  " + ", ".join(invalid_sets))

    errors.extend(f"Image de recette manquante: {recipe_id}" for recipe_id in missing)
    errors.extend(f"Asset de recette invalide: {recipe_id}" for recipe_id in invalid_sets)
    if errors:
        print("\nÉCHEC — publication bloquée :")
        for error in errors:
            print(f"- {error}")
        return 1

    print("\nOK — couverture des images validée.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
