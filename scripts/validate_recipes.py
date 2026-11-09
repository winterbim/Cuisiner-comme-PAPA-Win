#!/usr/bin/env python3
"""Valide les fichiers de recettes JSON de l'app Cuisiner comme Papa Win.

Usage : python3 scripts/validate_recipes.py [fichier.json ...]
Sans argument, valide tous les fichiers recipes_*.json.
"""
import json
import sys
from pathlib import Path

DATA_DIR = Path(__file__).resolve().parent.parent / "CuisinerCommePapaWin" / "Resources" / "Data"
REGIONS = {"portugal", "asie", "afrique", "france", "maghreb"}
DIFFICULTIES = {"facile", "moyen", "difficile"}
TAGS = {"epice", "rapide", "mijote", "familial", "poisson", "vegetarien", "four"}
STR_FIELDS = ["id", "name", "originalName", "region", "country", "flag", "emoji", "difficulty", "pitch", "tip"]


def validate_recipe(r, errors, where):
    for f in STR_FIELDS:
        if not isinstance(r.get(f), str) or not r[f].strip():
            errors.append(f"{where}: champ '{f}' manquant ou vide")
    if "Win" not in r.get("name", ""):
        errors.append(f"{where}: le nom doit contenir 'Win'")
    if r.get("region") not in REGIONS:
        errors.append(f"{where}: région invalide {r.get('region')!r}")
    if r.get("difficulty") not in DIFFICULTIES:
        errors.append(f"{where}: difficulté invalide {r.get('difficulty')!r}")
    tags = r.get("tags")
    if not isinstance(tags, list) or any(t not in TAGS for t in tags):
        errors.append(f"{where}: tags invalides {tags!r}")
    for f in ("prepMinutes", "cookMinutes", "servings"):
        v = r.get(f)
        if not isinstance(v, int) or isinstance(v, bool) or v < 0:
            errors.append(f"{where}: '{f}' doit être un entier >= 0")
    if isinstance(r.get("servings"), int) and r["servings"] < 1:
        errors.append(f"{where}: 'servings' doit être >= 1")
    if isinstance(tags, list) and "rapide" in tags:
        total = (r.get("prepMinutes") or 0) + (r.get("cookMinutes") or 0)
        if total > 30:
            errors.append(f"{where}: tag 'rapide' interdit si prep+cuisson > 30 min ({total})")
    ings = r.get("ingredients")
    if not isinstance(ings, list) or len(ings) < 5:
        errors.append(f"{where}: au moins 5 ingrédients requis")
    else:
        for i, ing in enumerate(ings):
            if set(ing) != {"quantity", "unit", "name"}:
                errors.append(f"{where}: ingrédient {i} doit avoir exactement quantity/unit/name")
                continue
            q = ing["quantity"]
            if q is not None and (not isinstance(q, (int, float)) or isinstance(q, bool) or q <= 0):
                errors.append(f"{where}: ingrédient {i} quantité invalide {q!r}")
            if ing["unit"] is not None and (not isinstance(ing["unit"], str) or not ing["unit"].strip()):
                errors.append(f"{where}: ingrédient {i} unité invalide")
            if ing["unit"] is not None and q is None:
                errors.append(f"{where}: ingrédient {i} a une unité sans quantité")
            if not isinstance(ing["name"], str) or not ing["name"].strip():
                errors.append(f"{where}: ingrédient {i} nom vide")
    steps = r.get("steps")
    if not isinstance(steps, list) or len(steps) < 4 or any(not isinstance(s, str) or not s.strip() for s in steps):
        errors.append(f"{where}: au moins 4 étapes non vides requises")


def main(argv):
    files = [Path(a) for a in argv] or sorted(DATA_DIR.glob("recipes_*.json"))
    errors, ids, count = [], set(), 0
    for path in files:
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except Exception as e:  # noqa: BLE001
            errors.append(f"{path.name}: JSON invalide ({e})")
            continue
        if not isinstance(data, list):
            errors.append(f"{path.name}: la racine doit être un tableau")
            continue
        for idx, r in enumerate(data):
            where = f"{path.name}[{idx}] {r.get('id', '?')}"
            validate_recipe(r, errors, where)
            if r.get("id") in ids:
                errors.append(f"{where}: id en double")
            ids.add(r.get("id"))
            count += 1
    if errors:
        print("\n".join(errors))
        print(f"\n{len(errors)} erreur(s)")
        return 1
    print(f"OK : {count} recettes valides dans {len(files)} fichier(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
