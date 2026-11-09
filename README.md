# Cuisiner comme Papa Win 👨‍🍳

Application iOS (SwiftUI, iOS 17+, iPhone) : **75 plats salés revisités avec humour**, 15 par cuisine :
🇵🇹 Portugal · 🏯 Asie · 🌍 Afrique (Afrique de l'Ouest, Madagascar, Congo) · 🕌 Maghreb · 🇫🇷 France.
Chaque recette a « Win » dans son nom : Lok Win au Poulet, Poulet Yas'Win, Tchébou Win, Coq au Win…

📘 **Référence unique du projet : [`docs/CAHIER_DES_CHARGES.md`](docs/CAHIER_DES_CHARGES.md)**
(règles, mascotte, illustrations, contrôles, Codemagic, App Store, ressources manquantes).

## Fonctionnalités
- Écran de bienvenue avec Papa Win, livre de recettes par cuisine, plat du jour
- Recherche (plat, ingrédient, pays — sans accents) et filtres : Facile, Rapide, Épicé, Mijoté, Poisson, Végétarien
- Fiche recette : quantités ajustables au nombre de personnes, ingrédients et étapes à cocher,
  « L'astuce de Papa Win », partage, écran qui reste allumé pendant la cuisine, « J'ai cuisiné ce plat »
- Favoris ❤️ et profil avec grade de chef (Apprenti Win → Papa Win légendaire) et progression par cuisine

## Lancer l'app sur un Mac
1. Ouvrir `CuisinerCommePapaWin.xcodeproj` avec Xcode 16 ou plus récent.
2. Cible *CuisinerCommePapaWin* → *Signing & Capabilities* → choisir ton équipe Apple Developer.
3. Choisir un simulateur iPhone (ou ton iPhone) → ▶️. Tests : ⌘U.

## Organisation
```
CuisinerCommePapaWin/            code de l'app
  App/  Models/  Stores/  Theme/  Views/
  Resources/
    Data/recipes_<cuisine>.json  les 75 recettes
    Assets.xcassets              icône, mascotte (papa_win, papa_win_hd, papa_win_round), illustrations
CuisinerCommePapaWinTests/       tests XCTest de l'app
codemagic.yaml                   compilation, tests et TestFlight sur Codemagic
design/mascotte/                 génération des déclinaisons de la mascotte et de l'icône
docs/
  CAHIER_DES_CHARGES.md          référence unique
  illustrations/                 manifest.json (statuts), ETAT.md, BRIEF.md (75 plats à illustrer)
scripts/
  validate_recipes.py            contrôle des recettes
  validate_assets.py             contrôle des images (bloquant pour la publication)
  check_xcode_project.py         contrôle du projet Xcode et de codemagic.yaml
  illustrations.py               importer / valider les illustrations, régénérer ETAT et BRIEF
  import_images.py               raccourci de « illustrations.py importer »
  tests/                         tests des scripts
```

## Contrôles
```bash
python3 -m unittest discover -s scripts/tests -v
python3 scripts/validate_recipes.py
python3 scripts/check_xcode_project.py
python3 scripts/validate_assets.py
```

## Ajouter / remplacer des illustrations
Nomme chaque image avec l'**id** de la recette (voir `docs/illustrations/BRIEF.md`, ex. `lok-win.jpg`),
JPEG ou PNG sans transparence, 1600 × 1200 conseillé (minimum 1200 × 900), puis :
```bash
python3 scripts/illustrations.py importer chemin/vers/le/dossier
# vérification visuelle de chaque image, puis :
python3 scripts/illustrations.py valider lok-win coq-au-win
```
Sans image définitive, l'app affiche une vignette de secours, et la publication reste bloquée.

## Modifier les recettes
Édite `CuisinerCommePapaWin/Resources/Data/recipes_<cuisine>.json`, puis lance `python3 scripts/validate_recipes.py`.
