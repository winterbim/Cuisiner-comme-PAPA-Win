#!/usr/bin/env python3
"""Importe des images dans Assets.xcassets (raccourci de « illustrations.py importer »).

Usage : python3 scripts/import_images.py DOSSIER

Chaque fichier du DOSSIER doit s'appeler comme l'id d'une recette
(ex. « lok-win.jpg », « coq-au-win.png ») ou « papa_win.jpg|png » pour la mascotte.
Les images sont contrôlées (format PNG/JPEG, dimensions, transparence, compression,
anciennes vignettes refusées) puis passent au statut « a_verifier » dans
docs/illustrations/manifest.json. Après vérification visuelle :
  python3 scripts/illustrations.py valider <id> [<id> ...]
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import illustrations  # noqa: E402

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(illustrations.main(["importer", sys.argv[1]]))
