# Cuisiner comme Papa Win 👨‍🍳

Application iOS (SwiftUI, iOS 17+) : **75 plats salés revisités avec humour**, 15 par cuisine :
🇵🇹 Portugal · 🏯 Asie · 🌍 Afrique (Afrique de l'Ouest, Madagascar, Congo) · 🕌 Maghreb · 🇫🇷 France.
Chaque recette a « Win » dans son nom : Lok Win au Poulet, Poulet Yas'Win, Tchébou Win, Coq au Win…

## Fonctionnalités
- Écran d'accueil Papa Win, livre de recettes par cuisine, plat du jour
- Recherche (plat, ingrédient, pays) et filtres : Facile, Rapide, Épicé, Mijoté, Poisson, Végétarien
- Fiche recette : quantités ajustables au nombre de personnes, ingrédients et étapes à cocher,
  « L'astuce de Papa Win », partage, écran qui reste allumé pendant la cuisine
- Favoris ❤️ et profil avec grade de chef (Apprenti Win → Papa Win légendaire)

## Lancer l'app sur un Mac
1. Ouvrir `CuisinerCommePapaWin.xcodeproj` avec Xcode 16 ou plus récent.
2. Cible *CuisinerCommePapaWin* → *Signing & Capabilities* → choisir ton équipe Apple Developer.
3. Choisir un simulateur iPhone (ou ton iPhone) → ▶️.

## Organisation
```
CuisinerCommePapaWin/
  App/          point d'entrée + barre d'onglets
  Models/       Recipe, Region, Difficulty, tags
  Stores/       chargement des recettes, favoris et progression
  Theme/        couleurs, polices, boutons
  Views/        écrans (Accueil, Recettes, Fiche, Favoris, Profil)
  Resources/
    Data/recipes_<cuisine>.json   les 75 recettes
    Assets.xcassets               icône, mascotte, photos des plats
scripts/
  validate_recipes.py   vérifie les fichiers de recettes
  validate_assets.py    vérifie la couverture des images et la mascotte
  import_images.py      importe des images dans Assets.xcassets
docs/
  CODEX_RELEASE_PROMPT.md
VISUAL_ASSET_AUDIT.md
```

## Ajouter / remplacer des images
Nomme chaque image avec l'**id** de la recette (ex. `lok-win.jpg`, `coq-au-win.png`) et la mascotte
`papa_win.jpg`, mets-les dans un dossier puis :
```bash
python3 scripts/import_images.py chemin/vers/le/dossier
```
Le script indique les images encore manquantes. Sans image, l'app affiche une vignette provisoire
(emoji + couleurs de la cuisine). La mascotte dessinée issue du portrait fourni est utilisée par `PapaWinAvatar`.

Contrôle avant release :
```bash
python3 scripts/validate_recipes.py
python3 scripts/validate_assets.py
```

## Modifier les recettes
Édite `CuisinerCommePapaWin/Resources/Data/recipes_<cuisine>.json`, puis vérifie :
```bash
python3 scripts/validate_recipes.py
```
