#!/usr/bin/env bash
# Captures d'écran App Store sur le plus récent simulateur iPhone « Pro Max » (6,9 pouces).
# Compile en Debug (mode capture : voir CaptureScreen dans CuisinerCommePapaWinApp.swift),
# lance chaque écran avec des favoris et plats cuisinés d'exemple, puis enregistre un PNG.
set -euo pipefail

BUNDLE_ID="${BUNDLE_ID:-com.papawin.cuisiner}"
OUT=build/captures-ecran
mkdir -p "$OUT" build/logs

UDID=$(xcrun simctl list devices available --json | python3 -c '
import json, re, sys
best = None
for runtime, items in json.load(sys.stdin)["devices"].items():
    if ".iOS-" not in runtime:
        continue
    version = tuple(int(x) for x in re.findall(r"\d+", runtime.split(".iOS-")[-1]))
    for dev in items:
        if dev.get("isAvailable", True) and re.fullmatch(r"iPhone \d+ Pro Max", dev["name"]):
            key = (version, dev["name"])
            if best is None or key > best[0]:
                best = (key, dev["udid"], dev["name"], runtime)
if best is None:
    sys.exit("Aucun simulateur iPhone Pro Max disponible")
print(f"Simulateur choisi : {best[2]} ({best[3]})", file=sys.stderr)
print(best[1])
')

xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b

xcodebuild build \
  -project "$XCODE_PROJECT" -scheme "$XCODE_SCHEME" -configuration Debug \
  -destination "id=$UDID" -derivedDataPath build/captures \
  CODE_SIGNING_ALLOWED=NO 2>&1 | tee build/logs/xcodebuild_captures.log
xcrun simctl install "$UDID" build/captures/Build/Products/Debug-iphonesimulator/CuisinerCommePapaWin.app

# Barre d'état propre, comme sur les captures Apple.
xcrun simctl status_bar "$UDID" override --time 9:41 --dataNetwork wifi --wifiBars 3 \
  --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100

FAVORIS='<array><string>tajine-agneau-win</string><string>pho-win</string><string>bacalwin-a-bras</string><string>poulet-yaswin</string><string>bourguignon-win</string><string>couscous-win-royal</string></array>'
CUISINES='<dict><key>tajine-agneau-win</key><integer>2</integer><key>pho-win</key><integer>1</integer><key>bacalwin-a-bras</key><integer>3</integer><key>poulet-yaswin</key><integer>1</integer><key>bourguignon-win</key><integer>1</integer><key>lok-win</key><integer>1</integer><key>couscous-win-royal</key><integer>1</integer><key>coq-au-win</key><integer>2</integer><key>gyowin</key><integer>1</integer></dict>'

n=0
for ecran in bienvenue accueil recettes fiche favoris profil; do
  n=$((n + 1))
  xcrun simctl terminate "$UDID" "$BUNDLE_ID" 2>/dev/null || true
  xcrun simctl launch "$UDID" "$BUNDLE_ID" \
    -captureEcran "$ecran" -hasSeenWelcome YES -chefName "Chef Gourmand" \
    -favoriteRecipeIDs "$FAVORIS" -cookedRecipeCounts "$CUISINES"
  sleep 8
  xcrun simctl io "$UDID" screenshot --type=png "$OUT/0${n}-${ecran}.png"
done

# Contrôle : 6 captures au format portrait 6,9 pouces accepté par App Store Connect.
python3 - "$OUT" <<'PY'
import struct, sys
from pathlib import Path
ok = {(1320, 2868), (1290, 2796)}
files = sorted(Path(sys.argv[1]).glob("*.png"))
bad = []
for f in files:
    w, h = struct.unpack(">II", f.read_bytes()[16:24])
    print(f"{f.name} : {w} × {h}")
    if (w, h) not in ok:
        bad.append(f.name)
if len(files) != 6 or bad:
    sys.exit(f"Captures invalides : {len(files)} fichier(s), formats refusés : {bad}")
print("OK — 6 captures 6,9 pouces")
PY
