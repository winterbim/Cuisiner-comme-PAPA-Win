# Rapport de validation — 2026-11-09

Commit contrôlé : `9e65cef` sur `claude/pensive-archimedes-5o2m55`.
Environnement : Linux, Python 3.13.18 — **sans Xcode** : la compilation et les tests XCTest sont faits par Codemagic (workflow `verification-ios`).

Régénérer : `scripts/ci/tout_valider.sh` (logs dans `build/logs/`).

## tests_scripts

```
test_reference_cassee (test_scripts.XcodeProjectTests.test_reference_cassee) ... ok
test_soumission_app_store_interdite (test_scripts.XcodeProjectTests.test_soumission_app_store_interdite) ... ok
test_syntaxe_cassee (test_scripts.XcodeProjectTests.test_syntaxe_cassee) ... ok

----------------------------------------------------------------------
Ran 23 tests in 0.212s

OK
```

## recettes

```
OK : 75 recettes valides dans 5 fichier(s)
```

## projet_xcode

```
=== Projet Xcode ===
✓ project.pbxproj : syntaxe valide
✓ 26 objets, aucune référence cassée
✓ dossier synchronisé : CuisinerCommePapaWin/
✓ dossier synchronisé : CuisinerCommePapaWinTests/
✓ Bundle ID de l'app : com.papawin.cuisiner
✓ version 1.0 (build 1), iOS 17.0+, iPhone, nom affiché « Papa Win »
✓ ressources : catalogue d'images, couleur d'accent, 5 fichiers de recettes
✓ scheme partagé CuisinerCommePapaWin : build, tests, archive Release
✓ codemagic.yaml : même Bundle ID (com.papawin.cuisiner)
! app/Debug : DEVELOPMENT_TEAM vide (normal : fourni par Codemagic ou à choisir dans Xcode › Signing & Capabilities)
! app/Release : DEVELOPMENT_TEAM vide (normal : fourni par Codemagic ou à choisir dans Xcode › Signing & Capabilities)

OK — projet Xcode cohérent.
```

## images

```
=== Illustrations des recettes ===
Recettes contrôlées : 75
  Définitive                       0
  Importée, à vérifier             0
  Provisoire (ancienne vignette)   49
  Manquante                        26
Prêtes pour la publication : 0/75

=== Avertissements (1) ===
- [mascotte] l'original validé fait 256 × 256 : papa_win_hd, papa_win_round et l'icône sont interpolés. Fournir l'illustration originale en haute définition (voir design/mascotte/README.md)

=== Erreurs bloquantes (124) ===
…
lignes de détail : 125
ÉCHEC — publication bloquée tant que ces erreurs ne sont pas corrigées.
```

## Relecture indépendante du code Swift et du projet Xcode

- Aucune erreur de compilation certaine ou probable, aucun test XCTest en échec, aucun plantage identifiés.
- 3 points mineurs corrigés dans le commit `9e65cef` (animation des coches, texte du profil, garde APP_STORE_APPLE_ID).

## Compilation iOS réelle

À relever dans Codemagic : build `verification-ios` déclenché par ce commit (tests XCTest sur simulateur, compilation Release simulateur + iPhone).
