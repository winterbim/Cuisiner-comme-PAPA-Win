# Mission Codex — Cuisiner comme Papa Win : validation, CodeMagic et App Store

Tu travailles directement dans le dépôt GitHub `winterbim/Cuisiner-comme-PAPA-Win`.

## Règle prioritaire : préserver le projet

- Ne refais pas le design.
- Ne remplaces pas la direction artistique, les couleurs, la typographie, les écrans ou la navigation.
- Ne réécris pas les recettes et ne changes pas les noms « Win ».
- Conserve la mascotte Papa Win basée sur le portrait fourni et l'asset `papa_win`. N'invente pas un autre personnage.
- Ne remplace pas les images par des emojis, des photos génériques, des images web non vérifiées ou des recadrages incorrects.
- Toute modification doit être ciblée, justifiée et validée par un test.

## 1. Audit initial obligatoire

1. Lire `README.md` et `VISUAL_ASSET_AUDIT.md`.
2. Vérifier la branche active et le dernier commit avant toute modification.
3. Examiner le projet Xcode, les 5 fichiers JSON de recettes, les `Assets.xcassets`, les scripts et les paramètres de signature.
4. Exécuter :

```bash
python3 scripts/validate_recipes.py
python3 scripts/validate_assets.py
```

5. Vérifier les 75 recettes, leurs identifiants, les 75 images, la mascotte `papa_win` et l'icône App Store.
6. Vérifier visuellement chaque image. Une image doit représenter le bon plat, sans texte parasite, recadrage d'une autre vignette ni doublon involontaire.

## 2. Images manquantes — ne pas contourner le contrôle

L'audit initial a trouvé 75 recettes et seulement 49 images de recettes intégrées. Les 26 images restantes ne doivent pas être remplacées par les vignettes provisoires incorrectes de l'ancien ZIP.

- Rechercher d'abord des illustrations originales et autonomes dans les ressources déjà présentes dans le dépôt et dans les archives locales du projet.
- Si les visuels corrects n'existent pas, préparer une liste exacte des 26 plats à illustrer et utiliser uniquement un outil de génération d'images réellement disponible dans l'environnement.
- Garder un style illustré homogène avec l'identité existante et des plats fidèles aux recettes.
- Ne pas inventer une photo, ne pas réutiliser une image d'un autre plat et ne pas déclarer une image comme validée sans inspection.
- Si l'environnement ne permet pas de produire ces 26 images de qualité, arrêter la publication et fournir la liste précise des fichiers manquants. Ne pas désactiver `validate_assets.py`.

## 3. Validation iOS

- Vérifier que `papa_win.imageset` est chargé par `PapaWinAvatar`.
- Vérifier l'icône App Store : PNG opaque 1024×1024.
- Vérifier les `Contents.json` de tous les assets.
- Vérifier les noms d'assets référencés par `Recipe.imageName`.
- Exécuter les validateurs de recettes et d'images.
- Construire le projet avec `xcodebuild` sur un environnement macOS compatible, avec la configuration Release.
- Corriger uniquement les erreurs de compilation ou de ressources démontrées par les logs.
- Tester au minimum le lancement, l'accueil, chaque région, la recherche, une fiche recette, les quantités, les favoris et le profil.

## 4. Configuration CodeMagic

1. Vérifier si `codemagic.yaml` existe. S'il n'existe pas, créer une configuration minimale et documentée adaptée au projet SwiftUI/Xcode.
2. Connecter le dépôt GitHub dans CodeMagic sans exposer de jeton dans les fichiers.
3. Configurer l'application iOS et le workflow Release.
4. Utiliser l'intégration Apple Developer / App Store Connect de CodeMagic pour la signature automatique ou les certificats/profils gérés par CodeMagic.
5. Utiliser des variables sécurisées CodeMagic pour les secrets. Ne jamais écrire de clé privée, mot de passe, certificat ou jeton dans Git.
6. Vérifier le Bundle Identifier `com.papawin.cuisiner`, la version marketing et le numéro de build. Ne pas modifier le Bundle ID sans vérifier l'existence de l'application dans App Store Connect.
7. Vérifier que l'équipe Apple Developer et l'accès App Store Connect correspondent bien au compte du propriétaire.
8. Produire un IPA signé et conserver les logs du build.

## 5. App Store Connect et publication

- Vérifier la fiche App Store Connect : nom, sous-titre, description française, catégorie, mots-clés, âge, confidentialité, URL d'assistance et URL de politique de confidentialité.
- Vérifier les captures d'écran requises pour les tailles d'iPhone prises en charge.
- Vérifier les déclarations de confidentialité et les usages de données. Ne rien déclarer sans preuve dans le code.
- Envoyer d'abord le build vers TestFlight.
- Vérifier l'installation et les fonctions essentielles sur un appareil réel.
- Ne pas soumettre automatiquement à la revue publique tant que les images des 75 recettes, les métadonnées et les tests ne sont pas validés.
- Demander l'approbation explicite du propriétaire avant la soumission finale à App Review si l'interface Apple demande une confirmation.

## 6. Rapport final obligatoire

Fournir des preuves, pas seulement des affirmations :

- commit et branche utilisés ;
- liste exacte des fichiers modifiés ;
- résultat des deux validateurs ;
- nombre de recettes et d'images vérifiées ;
- résultat du build Release ;
- lien ou identifiant du build CodeMagic ;
- statut TestFlight ;
- statut App Store Connect ;
- blocages restants, avec les logs utiles.

Ne jamais dire « publié » si le build n'est pas réellement disponible sur App Store. Ne jamais masquer un test en échec.