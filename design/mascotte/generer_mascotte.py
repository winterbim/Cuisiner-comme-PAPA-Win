#!/usr/bin/env python3
"""Génère les déclinaisons de la mascotte à partir de l'illustration Papa Win validée.

Source unique (jamais modifiée) :
  CuisinerCommePapaWin/Resources/Assets.xcassets/papa_win.imageset/papa_win.jpg

Sorties :
  papa_win_hd.imageset/papa_win_hd.jpg       illustration complète 1024×1024 (agrandie)
  papa_win_round.imageset/papa_win_round.png portrait rond 1024×1024, fond transparent

Aucune retouche du dessin : seulement agrandissement (Lanczos + légère accentuation)
et découpe circulaire centrée sur le visage. Quand l'original haute définition sera
disponible, remplace papa_win.jpg par celui-ci et relance ce script.

Usage : python3 design/mascotte/generer_mascotte.py   (nécessite Pillow)
"""
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / "CuisinerCommePapaWin" / "Resources" / "Assets.xcassets"
SOURCE = ASSETS / "papa_win.imageset" / "papa_win.jpg"
OUT = 1024
# Cercle du portrait, en fraction de la largeur/hauteur de la source (centre x, centre y, rayon).
# Calé sur l'illustration validée : visage, oreilles et barbe entièrement inclus.
CIRCLE = (135 / 256, 108 / 256, 108 / 256)


def write_imageset(name: str, filename: str) -> None:
    contents = {"images": [{"filename": filename, "idiom": "universal"}],
                "info": {"author": "xcode", "version": 1}}
    (ASSETS / f"{name}.imageset" / "Contents.json").write_text(json.dumps(contents, indent=2) + "\n")


def upscale(img: Image.Image, size: int) -> Image.Image:
    out = img.resize((size, size), Image.LANCZOS)
    return out.filter(ImageFilter.UnsharpMask(radius=2, percent=60, threshold=2))


def main() -> None:
    src = Image.open(SOURCE).convert("RGB")
    w, h = src.size

    # 1. Illustration complète haute résolution
    (ASSETS / "papa_win_hd.imageset").mkdir(exist_ok=True)
    upscale(src, OUT).save(ASSETS / "papa_win_hd.imageset" / "papa_win_hd.jpg", quality=92, subsampling=0)
    write_imageset("papa_win_hd", "papa_win_hd.jpg")

    # 2. Portrait rond (fond transparent, bord anti-crénelé)
    cx, cy, r = CIRCLE[0] * w, CIRCLE[1] * h, CIRCLE[2] * min(w, h)
    box = (round(cx - r), round(cy - r), round(cx + r), round(cy + r))
    portrait = upscale(src.crop(box), OUT).convert("RGBA")
    ss = 4
    mask = Image.new("L", (OUT * ss, OUT * ss), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, OUT * ss - 1, OUT * ss - 1), fill=255)
    portrait.putalpha(mask.resize((OUT, OUT), Image.LANCZOS))
    (ASSETS / "papa_win_round.imageset").mkdir(exist_ok=True)
    portrait.save(ASSETS / "papa_win_round.imageset" / "papa_win_round.png", optimize=True)
    write_imageset("papa_win_round", "papa_win_round.png")
    print(f"Source {w}×{h} → papa_win_hd.jpg {OUT}×{OUT}, papa_win_round.png {OUT}×{OUT} (cercle {box})")


if __name__ == "__main__":
    main()
