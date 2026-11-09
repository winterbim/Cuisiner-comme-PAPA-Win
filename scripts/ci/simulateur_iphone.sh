#!/usr/bin/env bash
# Affiche l'UDID du simulateur iPhone disponible le plus récent (pour xcodebuild test).
set -euo pipefail
xcrun simctl list devices available --json | python3 -c '
import json, re, sys
devices = json.load(sys.stdin)["devices"]
best = None
for runtime, items in devices.items():
    if ".iOS-" not in runtime:
        continue
    version = tuple(int(x) for x in re.findall(r"\d+", runtime.split(".iOS-")[-1]))
    for dev in items:
        if dev.get("isAvailable", True) and dev["name"].startswith("iPhone"):
            key = (version, "Pro" not in dev["name"], dev["name"])
            if best is None or key > best[0]:
                best = (key, dev["udid"], dev["name"], runtime)
if best is None:
    sys.exit("Aucun simulateur iPhone disponible")
print(f"Simulateur choisi : {best[2]} ({best[3]})", file=sys.stderr)
print(best[1])
'
