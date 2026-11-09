#!/usr/bin/env bash
# Lance tous les contrôles disponibles hors Xcode et enregistre les logs dans build/logs/.
# Usage : scripts/ci/tout_valider.sh            (code 0 si tout ce qui est bloquant passe)
# Les images sont rapportées ; leur contrôle bloquant est fait par le workflow TestFlight.
set -uo pipefail
cd "$(dirname "$0")/../.."
mkdir -p build/logs
status=0
run() {
  local name=$1; shift
  echo "▶ $name"
  if "$@" > "build/logs/$name.log" 2>&1; then
    echo "  ✓ OK"
  else
    echo "  ✗ ÉCHEC (voir build/logs/$name.log)"
    status=1
  fi
}
run tests_scripts python3 -m unittest discover -s scripts/tests -v
run recettes python3 scripts/validate_recipes.py
run projet_xcode python3 scripts/check_xcode_project.py
python3 scripts/validate_assets.py --json build/rapport_images.json > build/logs/images.log 2>&1
if [ $? -eq 0 ]; then echo "▶ images"; echo "  ✓ OK (prêtes pour la publication)"; else
  echo "▶ images"; echo "  ! publication bloquée : $(grep -m1 'Prêtes pour la publication' build/logs/images.log)"; fi
if command -v xcodebuild >/dev/null 2>&1; then
  run xcodebuild_tests bash -c 'UDID=$(scripts/ci/simulateur_iphone.sh) && xcodebuild test -project CuisinerCommePapaWin.xcodeproj -scheme CuisinerCommePapaWin -destination "id=$UDID" CODE_SIGNING_ALLOWED=NO'
  run xcodebuild_release bash -c 'xcodebuild build -project CuisinerCommePapaWin.xcodeproj -scheme CuisinerCommePapaWin -configuration Release -destination "generic/platform=iOS" CODE_SIGNING_ALLOWED=NO'
else
  echo "▶ compilation Xcode : non disponible ici (macOS + Xcode requis) — faite par Codemagic"
fi
find scripts -name __pycache__ -prune -exec rm -rf {} +
exit $status
