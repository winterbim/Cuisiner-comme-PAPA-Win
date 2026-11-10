"""Tests des scripts de contrôle (recettes, images, illustrations).

Lancement : python3 -m unittest discover -s scripts/tests -v
"""
import io
import json
import shutil
import struct
import sys
import tempfile
import unittest
import zlib
from contextlib import redirect_stdout
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPTS))

import asset_lib as A  # noqa: E402
import check_xcode_project as X  # noqa: E402
import illustrations  # noqa: E402
import validate_assets  # noqa: E402
import validate_recipes  # noqa: E402


def make_png(width, height, color_type=2, trns=False, truncate=False):
    channels = {0: 1, 2: 3, 4: 2, 6: 4}[color_type]

    def chunk(kind, payload):
        return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", zlib.crc32(kind + payload) & 0xFFFFFFFF)

    raw = b"".join(b"\x00" + b"\x80" * (width * channels) for _ in range(height))
    data = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, color_type, 0, 0, 0))
    if trns:
        data += chunk(b"tRNS", b"\x00\x00\x00\x00\x00\x00")
    data += chunk(b"IDAT", zlib.compress(raw))
    if not truncate:
        data += chunk(b"IEND", b"")
    return data


def quiet(func, *args):
    buffer = io.StringIO()
    with redirect_stdout(buffer):
        result = func(*args)
    return result, buffer.getvalue()


class ImageHeaderTests(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def write(self, name, data):
        path = self.tmp / name
        path.write_bytes(data)
        return path

    def test_png_rgb_sans_alpha(self):
        info = A.read_image(self.write("a.png", make_png(40, 30)))
        self.assertEqual((info.format, info.width, info.height, info.has_alpha, info.color_type), ("png", 40, 30, False, 2))
        self.assertIsNone(info.error)

    def test_png_rgba_detecte_alpha(self):
        self.assertTrue(A.read_image(self.write("b.png", make_png(8, 8, color_type=6))).has_alpha)

    def test_png_trns_detecte_transparence(self):
        self.assertTrue(A.read_image(self.write("c.png", make_png(8, 8, trns=True))).has_alpha)

    def test_png_tronque(self):
        self.assertIn("tronqué", A.read_image(self.write("d.png", make_png(8, 8, truncate=True))).error)

    def test_fichier_vide_et_format_inconnu(self):
        self.assertEqual(A.read_image(self.write("e.png", b"")).error, "fichier vide")
        self.assertIn("non reconnu", A.read_image(self.write("f.jpg", b"GIF89a....")).error)

    def test_jpeg_reel(self):
        path = A.ASSETS_DIR / "papa_win.imageset" / "papa_win.jpg"
        info = A.read_image(path)
        self.assertEqual((info.format, info.width, info.height, info.components), ("jpeg", 256, 256, 3))
        self.assertIsNone(info.error)

    def test_extension(self):
        self.assertTrue(A.extension_matches(Path("x.JPEG"), "jpeg"))
        self.assertFalse(A.extension_matches(Path("x.png"), "jpeg"))


class RepositoryAssetTests(unittest.TestCase):
    def test_icone_conforme(self):
        report = validate_assets.Report()
        validate_assets.check_icon(report, A.load_manifest())
        self.assertEqual(report.errors, [])

    def test_mascotte_conforme(self):
        report = validate_assets.Report()
        validate_assets.check_mascot(report, A.load_manifest())
        self.assertEqual(report.errors, [])

    def test_catalogue_sans_orphelin(self):
        report = validate_assets.Report()
        validate_assets.check_catalog(report)
        self.assertEqual(report.errors + report.warnings, [])

    def test_manifeste_couvre_les_75_recettes(self):
        manifest = A.load_manifest()
        ids = {r["id"] for r in A.load_recipes()}
        self.assertEqual(len(ids), 75)
        self.assertEqual(set(manifest["recettes"]), ids)

    def test_vignettes_provisoires_jamais_definitives(self):
        report = validate_assets.Report()
        summary = validate_assets.check_recipes(report, A.load_manifest())
        legacy = set(A.load_manifest()["empreintes_vignettes_provisoires"])
        for rid, status in summary["par_recette"].items():
            imageset = A.load_imageset(rid)
            if imageset.files and A.sha256(imageset.files[0]) in legacy:
                self.assertEqual(status, "provisoire", rid)


class ImporterTests(unittest.TestCase):
    """L'importeur travaille sur une copie du catalogue et du manifeste."""

    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.assets = self.tmp / "Assets.xcassets"
        shutil.copytree(A.ASSETS_DIR, self.assets)
        self.manifest = self.tmp / "manifest.json"
        shutil.copyfile(A.MANIFEST_PATH, self.manifest)
        self.saved = (A.ASSETS_DIR, A.MANIFEST_PATH)
        A.ASSETS_DIR, A.MANIFEST_PATH = self.assets, self.manifest
        self.incoming = self.tmp / "in"
        self.incoming.mkdir()

    def tearDown(self):
        A.ASSETS_DIR, A.MANIFEST_PATH = self.saved
        shutil.rmtree(self.tmp)

    def status(self, rid):
        return json.loads(self.manifest.read_text())["recettes"][rid]["statut"]

    def test_import_puis_validation(self):
        (self.incoming / "coq-au-win.png").write_bytes(make_png(1600, 1200))
        code, _ = quiet(illustrations.cmd_importer, self.incoming)
        self.assertEqual(code, 0)
        self.assertEqual(self.status("coq-au-win"), "a_verifier")
        self.assertTrue((self.assets / "coq-au-win.imageset" / "coq-au-win.png").is_file())
        code, _ = quiet(illustrations.cmd_valider, ["coq-au-win"])
        self.assertEqual(code, 0)
        self.assertEqual(self.status("coq-au-win"), "definitive")

    # Ces tests préparent eux-mêmes leur état de départ dans la copie du manifeste :
    # ils ne dépendent pas des images réellement présentes dans le dépôt.

    def set_status(self, rid, statut):
        data = json.loads(self.manifest.read_text())
        data["recettes"][rid] = {"statut": statut, "note": "test"}
        self.manifest.write_text(json.dumps(data))

    def test_refus_trop_petite_ou_transparente(self):
        before = {rid: self.status(rid) for rid in ("pot-au-win", "cassoulet-win")}
        (self.incoming / "pot-au-win.png").write_bytes(make_png(800, 600))
        (self.incoming / "cassoulet-win.png").write_bytes(make_png(1600, 1200, color_type=6))
        code, out = quiet(illustrations.cmd_importer, self.incoming)
        self.assertEqual(code, 1)
        self.assertIn("800×600", out)
        self.assertIn("transparence", out)
        for rid, statut in before.items():
            self.assertEqual(self.status(rid), statut)
            self.assertFalse((self.assets / f"{rid}.imageset" / f"{rid}.png").exists())

    def test_refus_ancienne_vignette(self):
        legacy = self.incoming / "lok-win.png"
        legacy.write_bytes(make_png(1600, 1200))
        data = json.loads(self.manifest.read_text())
        data["empreintes_vignettes_provisoires"].append(A.sha256(legacy))
        self.manifest.write_text(json.dumps(data))
        self.set_status("lok-win", "provisoire")
        code, out = quiet(illustrations.cmd_importer, self.incoming)
        self.assertEqual(code, 1)
        self.assertIn("ancienne vignette", out)
        self.assertEqual(self.status("lok-win"), "provisoire")

    def test_validation_refusee_sans_image_conforme(self):
        small = self.tmp / "petite.png"
        small.write_bytes(make_png(800, 600))
        A.write_imageset("lok-win", small, "lok-win.png")
        self.set_status("lok-win", "a_verifier")
        code, _ = quiet(illustrations.cmd_valider, ["lok-win"])
        self.assertEqual(code, 1)
        self.assertEqual(self.status("lok-win"), "a_verifier")


class RecipeValidatorTests(unittest.TestCase):
    def test_recettes_du_depot(self):
        code, out = quiet(validate_recipes.main, [])
        self.assertEqual(code, 0, out)
        self.assertIn("75 recettes", out)

    def test_recette_invalide(self):
        recipe = json.loads((A.DATA_DIR / "recipes_france.json").read_text())[0]
        recipe["name"] = "Bœuf bourguignon"
        recipe["tags"] = ["rapide"]
        recipe["steps"] = ["Une seule étape"]
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "recipes_test.json"
            path.write_text(json.dumps([recipe, recipe]), encoding="utf-8")
            code, out = quiet(validate_recipes.main, [str(path)])
        self.assertEqual(code, 1)
        for expected in ("doit contenir 'Win'", "tag 'rapide' interdit", "au moins 4 étapes", "id en double"):
            self.assertIn(expected, out)


class XcodeProjectTests(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.saved = (X.PBXPROJ, X.CODEMAGIC)

    def tearDown(self):
        X.PBXPROJ, X.CODEMAGIC = self.saved
        shutil.rmtree(self.tmp)

    def run_with(self, pbxproj_text=None, codemagic_text=None):
        if pbxproj_text is not None:
            X.PBXPROJ = self.tmp / "project.pbxproj"
            X.PBXPROJ.write_text(pbxproj_text, encoding="utf-8")
        if codemagic_text is not None:
            X.CODEMAGIC = self.tmp / "codemagic.yaml"
            X.CODEMAGIC.write_text(codemagic_text, encoding="utf-8")
        return quiet(X.main)

    def test_projet_du_depot_valide(self):
        code, out = quiet(X.main)
        self.assertEqual(code, 0, out)

    def test_syntaxe_cassee(self):
        text = self.saved[0].read_text(encoding="utf-8").replace("isa = PBXProject;", "isa = PBXProject", 1)
        code, out = self.run_with(pbxproj_text=text)
        self.assertEqual(code, 1)
        self.assertIn("illisible", out)

    def test_reference_cassee(self):
        text = self.saved[0].read_text(encoding="utf-8").replace(
            "targetProxy = A1B2C3D40000000000000108", "targetProxy = A1B2C3D4000000000000FFFF", 1)
        code, out = self.run_with(pbxproj_text=text)
        self.assertEqual(code, 1)
        self.assertIn("A1B2C3D4000000000000FFFF", out)

    def test_bundle_id_different_dans_codemagic(self):
        text = self.saved[1].read_text(encoding="utf-8").replace("com.papawin.cuisiner", "com.autre.app")
        code, out = self.run_with(codemagic_text=text)
        self.assertEqual(code, 1)
        self.assertIn("com.autre.app", out)

    def test_soumission_app_store_interdite(self):
        text = self.saved[1].read_text(encoding="utf-8").replace("submit_to_app_store: false", "submit_to_app_store: true")
        code, out = self.run_with(codemagic_text=text)
        self.assertEqual(code, 1)
        self.assertIn("interdite", out)


if __name__ == "__main__":
    unittest.main()
