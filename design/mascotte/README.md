# Mascotte Papa Win — référence graphique unique

**Référence validée :** `CuisinerCommePapaWin/Resources/Assets.xcassets/papa_win.imageset/papa_win.jpg`
(illustration fournie par Winter, 256 × 256). Ce fichier n'est jamais retouché.

| Asset | Fichier | Usage dans l'app |
|---|---|---|
| `papa_win` | `papa_win.jpg` (original, 256 × 256) | source unique ; secours si les déclinaisons manquent |
| `papa_win_hd` | `papa_win_hd.jpg` (1024 × 1024) | illustration complète (écran Profil) |
| `papa_win_round` | `papa_win_round.png` (1024 × 1024, fond transparent) | portrait rond : bienvenue, accueil, astuces, états vides |
| `AppIcon` | `AppIcon.png` (1024 × 1024, opaque) | icône iOS / App Store, construite avec `icone.html` |

Les déclinaisons sont **dérivées** de l'original : agrandissement Lanczos + légère accentuation,
et découpe circulaire centrée sur le visage. Le visage, la barbe, les proportions et le style ne sont pas modifiés.

⚠️ L'original ne fait que 256 × 256 : les versions 1024 sont **interpolées**, donc moins nettes qu'un vrai
fichier haute définition. Dès que l'illustration originale en haute définition (≥ 1024 × 1024) est disponible :

```bash
cp chemin/vers/original_hd.jpg CuisinerCommePapaWin/Resources/Assets.xcassets/papa_win.imageset/papa_win.jpg
python3 design/mascotte/generer_mascotte.py      # régénère papa_win_hd et papa_win_round (Pillow requis)
```

Puis régénérer l'icône : ouvrir `icone.html` dans un navigateur à côté d'une copie de `papa_win_round.png`
nommée `round.png`, capturer 1024 × 1024, enregistrer en PNG **sans transparence** dans
`AppIcon.appiconset/AppIcon.png`, et mettre `"source_hd": true` dans `docs/illustrations/manifest.json`.
