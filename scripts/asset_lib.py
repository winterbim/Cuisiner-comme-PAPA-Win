"""Outils communs aux scripts d'images de Cuisiner comme Papa Win.

Python 3.9+ pur, sans dépendance (pas de Pillow) : les scripts tournent aussi
sur les machines macOS de Codemagic.
"""
from __future__ import annotations

import hashlib
import json
import struct
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

ROOT = Path(__file__).resolve().parent.parent
APP_DIR = ROOT / "CuisinerCommePapaWin"
DATA_DIR = APP_DIR / "Resources" / "Data"
ASSETS_DIR = APP_DIR / "Resources" / "Assets.xcassets"
MANIFEST_PATH = ROOT / "docs" / "illustrations" / "manifest.json"

STATUSES = ("manquante", "provisoire", "a_verifier", "definitive")
STATUS_LABELS = {
    "manquante": "Manquante",
    "provisoire": "Provisoire (ancienne vignette)",
    "a_verifier": "Importée, à vérifier",
    "definitive": "Définitive",
}


# ---------------------------------------------------------------------------
# Lecture des en-têtes d'images


@dataclass
class ImageInfo:
    path: Path
    format: Optional[str] = None  # "png" | "jpeg" | None
    width: int = 0
    height: int = 0
    has_alpha: bool = False
    bit_depth: int = 0
    color_type: Optional[int] = None  # PNG uniquement
    interlaced: bool = False
    components: int = 0  # JPEG uniquement
    size_bytes: int = 0
    error: Optional[str] = None

    @property
    def bits_per_pixel(self) -> float:
        pixels = self.width * self.height
        return (self.size_bytes * 8 / pixels) if pixels else 0.0

    @property
    def ratio(self) -> float:
        return self.width / self.height if self.height else 0.0


def _read_png(data: bytes, info: ImageInfo) -> None:
    if len(data) < 33 or data[12:16] != b"IHDR":
        info.error = "PNG corrompu (IHDR absent)"
        return
    w, h, depth, ctype, _comp, _filt, interlace = struct.unpack(">IIBBBBB", data[16:29])
    info.width, info.height, info.bit_depth, info.color_type = w, h, depth, ctype
    info.interlaced = interlace == 1
    has_trns = False
    pos = 8
    while pos + 8 <= len(data):
        length = struct.unpack(">I", data[pos:pos + 4])[0]
        ctype_chunk = data[pos + 4:pos + 8]
        if ctype_chunk == b"tRNS":
            has_trns = True
        if ctype_chunk == b"IEND":
            break
        pos += 12 + length
    else:
        info.error = "PNG tronqué (IEND absent)"
    info.has_alpha = ctype in (4, 6) or has_trns


_SOF_MARKERS = {0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7, 0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF}


def _read_jpeg(data: bytes, info: ImageInfo) -> None:
    pos = 2
    while pos + 4 <= len(data):
        if data[pos] != 0xFF:
            pos += 1
            continue
        marker = data[pos + 1]
        if marker in (0xD8, 0x01) or 0xD0 <= marker <= 0xD7:
            pos += 2
            continue
        if marker == 0xFF:
            pos += 1
            continue
        length = struct.unpack(">H", data[pos + 2:pos + 4])[0]
        if marker in _SOF_MARKERS:
            depth, h, w, comps = struct.unpack(">BHHB", data[pos + 4:pos + 10])
            info.bit_depth, info.height, info.width, info.components = depth, h, w, comps
            break
        if marker == 0xDA:  # début des données sans SOF trouvé
            break
        pos += 2 + length
    if not info.width:
        info.error = "JPEG sans dimensions lisibles (SOF absent)"
    if b"\xff\xd9" not in data[-2048:]:
        info.error = info.error or "JPEG tronqué (marqueur de fin absent)"


def read_image(path: Path) -> ImageInfo:
    info = ImageInfo(path=path)
    try:
        data = path.read_bytes()
    except OSError as exc:
        info.error = f"illisible ({exc})"
        return info
    info.size_bytes = len(data)
    if not data:
        info.error = "fichier vide"
    elif data.startswith(b"\x89PNG\r\n\x1a\n"):
        info.format = "png"
        _read_png(data, info)
    elif data.startswith(b"\xff\xd8"):
        info.format = "jpeg"
        _read_jpeg(data, info)
    else:
        info.error = "format non reconnu (PNG ou JPEG attendu)"
    return info


def extension_matches(path: Path, fmt: Optional[str]) -> bool:
    ext = path.suffix.lower()
    return (fmt == "png" and ext == ".png") or (fmt == "jpeg" and ext in (".jpg", ".jpeg"))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


# ---------------------------------------------------------------------------
# Imagesets Xcode


@dataclass
class ImageSet:
    name: str
    folder: Path
    files: list = field(default_factory=list)  # chemins des images référencées et présentes
    problems: list = field(default_factory=list)

    @property
    def exists(self) -> bool:
        return self.folder.is_dir()


def load_imageset(name: str) -> ImageSet:
    folder = ASSETS_DIR / f"{name}.imageset"
    result = ImageSet(name=name, folder=folder)
    if not folder.is_dir():
        return result
    contents_path = folder / "Contents.json"
    try:
        contents = json.loads(contents_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        result.problems.append(f"Contents.json invalide ({exc})")
        return result
    entries = contents.get("images") if isinstance(contents, dict) else None
    if not isinstance(entries, list) or not entries:
        result.problems.append("Contents.json sans entrée « images »")
        return result
    referenced = set()
    for entry in entries:
        if not isinstance(entry, dict) or "filename" not in entry:
            continue
        filename = entry["filename"]
        referenced.add(filename)
        file_path = folder / filename
        if not file_path.is_file():
            result.problems.append(f"fichier référencé absent : {filename}")
        else:
            result.files.append(file_path)
    if not referenced:
        result.problems.append("aucun fichier référencé dans Contents.json")
    extras = sorted(p.name for p in folder.iterdir() if p.name != "Contents.json" and p.name not in referenced)
    if extras:
        result.problems.append("fichiers non référencés : " + ", ".join(extras))
    return result


def write_imageset(name: str, source: Path, filename: str) -> Path:
    folder = ASSETS_DIR / f"{name}.imageset"
    if folder.exists():
        for child in folder.iterdir():
            child.unlink()
    folder.mkdir(parents=True, exist_ok=True)
    target = folder / filename
    target.write_bytes(source.read_bytes())
    contents = {"images": [{"filename": filename, "idiom": "universal"}], "info": {"author": "xcode", "version": 1}}
    (folder / "Contents.json").write_text(json.dumps(contents, indent=2) + "\n", encoding="utf-8")
    return target


# ---------------------------------------------------------------------------
# Recettes et manifeste


def load_recipes() -> list:
    recipes = []
    for path in sorted(DATA_DIR.glob("recipes_*.json")):
        recipes.extend(json.loads(path.read_text(encoding="utf-8")))
    return recipes


def load_manifest() -> dict:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def save_manifest(manifest: dict) -> None:
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
