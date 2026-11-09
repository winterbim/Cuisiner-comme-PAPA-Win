# Mission Codex — Cuisiner comme Papa Win : finaliser les visuels, compiler avec CodeMagic et publier

Tu travailles directement dans le dépôt GitHub `winterbim/Cuisiner-comme-PAPA-Win`.

## Règle absolue : ne pas refaire l'application

- Ne refais pas le design.
- Ne modifies pas les couleurs, la typographie, les écrans, la navigation ou la structure.
- Ne réécris pas les recettes et ne changes pas les noms « Win ».
- Conserve la mascotte Papa Win basée sur le portrait fourni et l'asset `papa_win`. N'invente pas un autre personnage.
- Les images des plats doivent représenter le plat exact. Ne mets pas le personnage à la place d'un plat.
- Ne remplace pas les images par des emojis, des photos génériques, des images web non vérifiées ou des recadrages incorrects.
- Toute modification doit être ciblée, justifiée et testée.

## 1. Audit initial

1. Lire `README.md`, `VISUAL_ASSET_AUDIT.md` et ce document.
2. Vérifier la branche active et le dernier commit.
3. Examiner le projet Xcode, les cinq fichiers JSON de recettes, les `Assets.xcassets`, les scripts et les paramètres de signature.
4. Exécuter :

```bash
python3 scripts/validate_recipes.py
python3 scripts/validate_assets.py
```

5. Vérifier les 75 recettes, les 75 images, la mascotte `papa_win` et l'icône App Store.
6. Inspecter visuellement chaque image. Elle doit représenter le bon plat, sans texte parasite, sans recadrage d'une autre vignette et sans doublon involontaire.

## 2. Compléter les 26 images manquantes

L'audit confirme 75 recettes et 49 images de plats. Les 26 images manquantes sont listées dans `VISUAL_ASSET_AUDIT.md` : 15 Maghreb et 11 France.

- Rechercher d'abord des illustrations originales et autonomes dans le dépôt et dans les archives locales du projet.
- Les anciennes vignettes issues de planches ne sont pas fiables. Ne pas les importer telles quelles.
- Si les bonnes images n'existent pas, produire les 26 illustrations manquantes avec un outil de génération réellement disponible dans l'environnement.
- Style : illustration culinaire dessinée, chaleureuse, propre et cohérente avec l'identité Papa Win. Une image indépendante par plat. Pas de texte, pas de nom incrusté, pas de personnage dans l'assiette.
- Respecter la recette réelle et ses ingrédients. Ne pas inventer un plat ni réutiliser une image d'un autre plat.
- Vérifier les 26 images une par une, puis créer les imagesets Xcode avec les identifiants exacts.
- Ne pas désactiver ni contourner `scripts/validate_assets.py`.
- Si tu ne peux pas produire des images correctes, arrête la publication et donne la liste précise des fichiers manquants.

## 3. Icône et mascotte

- Vérifier que `papa_win.imageset` est chargé par `PapaWinAvatar`.
- Vérifier l'apparence sur l'accueil, l'écran de bienvenue et les autres écrans qui utilisent déjà `PapaWinAvatar`.
- Vérifier si l'icône App Store existante reprend bien le même personnage. Si elle ne le reprend pas, créer une icône 1024×1024 à partir de l'illustration haute résolution originale disponible. Ne pas inventer une nouvelle mascotte.
- L'icône App Store doit être opaque, en PNG 1024×1024, sans canal alpha.

## 4. Validation iOS

- Vérifier les `Contents.json` de tous les assets.
- Vérifier les noms d'assets référencés par `Recipe.imageName`.
- Exécuter les validateurs de recettes et d'images.
- Construire en configuration Release avec `xcodebuild` sur un environnement macOS compatible.
- Corriger uniquement les erreurs démontrées par les logs.
- Tester le lancement, l'accueil, les cinq cuisines, la recherche, une fiche recette, les quantités, les favoris et le profil.
- Ne pas déclarer le projet prêt si une image est incorrecte ou absente.

## 5. CodeMagic

1. Vérifier si `codemagic.yaml` existe. Sinon, créer une configuration minimale, documentée et adaptée à SwiftUI/Xcode.
2. Connecter le dépôt GitHub dans CodeMagic sans exposer de jeton dans Git.
3. Configurer un workflow iOS Release.
4. Utiliser l'intégration Apple Developer / App Store Connect de CodeMagic pour la signature automatique ou les certificats/profils gérés par CodeMagic.
5. Stocker les secrets dans les variables sécurisées CodeMagic. Ne jamais committer de clé privée, mot de passe, certificat ou jeton.
6. Si une API key App Store Connect est nécessaire, utiliser son Key ID, Issuer ID et sa clé privée dans le coffre sécurisé CodeMagic.
7. Vérifier le Bundle Identifier `com.papawin.cuisiner`, l'équipe Apple Developer, la version et le numéro de build. Ne pas modifier le Bundle ID sans vérifier l'application App Store Connect existante.
8. Produire un IPA signé et conserver les logs du build.

## 6. App Store Connect

- Vérifier le nom, le sous-titre, la description française, la catégorie, les mots-clés, l'âge, les informations de confidentialité, l'URL d'assistance et la politique de confidentialité.
- Vérifier les captures d'écran requises pour les tailles d'iPhone prises en charge.
- Vérifier les déclarations de confidentialité à partir du code réel. Ne rien déclarer sans preuve.
- Envoyer d'abord le build sur TestFlight.
- Vérifier l'installation et les fonctions essentielles sur un appareil réel.
- Ne pas soumettre à App Review tant que les 75 images, les métadonnées et les tests ne sont pas validés.
- Demander l'approbation explicite du propriétaire si l'interface Apple demande une confirmation finale.

## 7. Rapport final avec preuves

Fournir :
- branche et commit utilisés ;
- liste exacte des fichiers modifiés ;
- résultat des validateurs ;
- nombre d'images vérifiées ;
- résultat du build Release ;
- identifiant ou lien du build CodeMagic ;
- statut TestFlight ;
- statut App Store Connect ;
- blocages restants et logs utiles.

Ne jamais dire « publié » si le build n'est pas réellement disponible sur l'App Store. Ne jamais masquer un test en échec.