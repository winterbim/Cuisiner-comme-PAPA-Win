# Audit visuel et mission Codex — Cuisiner comme Papa Win

## État audité

Dépôt : https://github.com/winterbim/Cuisiner-comme-PAPA-Win  
Branche de travail : `codex/visual-identity-refresh`  
Commit de référence : `e587e4f76ea453bdb660a144067b59f9be471632`  
Projet : SwiftUI, cible iOS 17+, Xcode project.

### Constats vérifiés dans le code

1. `CuisinerCommePapaWin/Views/Components/PapaWinAvatar.swift`
   - La mascotte est dessinée par des formes SwiftUI très simplifiées.
   - Le code tente de charger `papa_win`, mais retombe sur ce dessin générique si l'asset est absent.
   - Le dessin actuel ne reproduit pas fidèlement la photo de référence de Winter.
2. `CuisinerCommePapaWin/Views/Components/RecipeComponents.swift`
   - `RecipeImage` charge une image dont le nom est l'ID de recette.
   - Si l'image est absente, l'écran affiche un dégradé et un emoji. Ce fallback est explicitement provisoire.
3. `CuisinerCommePapaWin/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json`
   - Référence `AppIcon.png`, taille universelle iOS 1024 × 1024.
   - Le fichier image existe dans le dépôt. Son rendu doit être comparé au nouvel asset fourni.
4. Le commit de référence annonce 75 recettes et 49 vignettes provisoires. Il reste donc 26 images de recettes à fournir au minimum, sous réserve d'un inventaire réel des assets.
5. L'interface utilise aussi des SF Symbols pour les actions et les badges. Ne pas remplacer les symboles système pertinents par des images décoratives illisibles.

## Direction artistique à respecter

- Conserver l'identité validée : livre de cuisine illustré, chaleureux, joyeux, coloré, légèrement humoristique.
- Le personnage Papa Win doit s'inspirer de la photo de référence fournie par Winter : homme chauve, barbe poivre et sel, visage souriant. Ne pas inventer une autre morphologie ni changer le personnage à chaque écran.
- Garder une identité faciale constante. Les vêtements, accessoires, poses et expressions peuvent varier selon la cuisine ou la recette.
- Style : illustration éditoriale de cuisine, contours propres, volumes chaleureux, couleurs riches, éclairage doux. Éviter les pictogrammes génériques, les emojis utilisés comme photos, les cliparts et les visuels incohérents.
- Les images de plats doivent représenter le vrai plat et sa présentation culinaire. Ne pas mettre le personnage à la place du plat.
- Pas de desserts. L'application présente des plats salés uniquement.
- Ne pas réécrire les recettes, renommer les plats, réorganiser la navigation ou refaire l'architecture fonctionnelle dans cette mission graphique.

## Mission

### A. Inventaire exhaustif avant modification
- Parcourir tout le dépôt et les 5 fichiers JSON de recettes.
- Établir la liste exacte des 75 IDs de recettes.
- Parcourir récursivement `Assets.xcassets` et relever chaque image, son format, ses dimensions, son poids et son usage.
- Vérifier chaque entrée `Contents.json`, chaque nom d'image et chaque référence SwiftUI.
- Produire `docs/ASSET_AUDIT.md` avec un tableau : ID recette, nom affiché, asset attendu, asset présent, dimensions, qualité, action requise.
- Vérifier les assets AppIcon, mascotte, illustrations de cuisine, boutons, badges et éventuels fonds.

### B. Refaire les assets
- Remplacer l'icône App Store par le fichier `PapaWin_AppIcon_1024.png` fourni séparément par Winter, après contrôle de ses dimensions et de son cadrage.
- Créer une vraie mascotte Papa Win cohérente avec la photo de référence. Prévoir des variantes de pose/vêtement sans altérer les traits du visage.
- Créer une illustration spécifique pour chaque cuisine : Portugal, Asie, Afrique, Maghreb et France.
- Fournir une image culinaire distincte pour chacun des 75 IDs de recettes. Aucune image générique répétée pour combler les manques.
- Respecter les noms d'assets : l'ID exact de recette, en minuscules et avec tirets, conformément à `Recipe.imageName`.
- Importer les images dans des dossiers `.imageset` avec leurs `Contents.json` valides.
- Préférer des images WebP/JPEG optimisées pour les photos/illustrations de recettes si la chaîne d'assets le permet ; utiliser PNG pour les éléments nécessitant transparence et pour AppIcon.
- Optimiser poids et résolution sans dégrader le rendu sur iPhone Retina.
- Ne pas intégrer de texte dans les images de plats. Les noms et libellés doivent rester du vrai texte SwiftUI, accessible et localisable.

### C. Refaire les composants graphiques
- Remplacer le fallback emoji/dégradé de `RecipeImage` par un état de secours discret et cohérent. En production, le contrôle de validation doit échouer si une image de recette manque.
- Remplacer le dessin géométrique générique de `PapaWinAvatar` par la mascotte illustrée. Prévoir des variantes de pose via des assets dédiés ou une composition contrôlée.
- Harmoniser les icônes de navigation, recherche, favoris, minuterie, portions, étapes et filtres. Garder SF Symbols lorsqu'ils sont exacts, lisibles et natifs iOS.
- Vérifier contraste, tailles tactiles, lisibilité, VoiceOver et affichage en petit format.
- Conserver le design des écrans et leurs comportements actuels. Toute modification de layout doit servir la cohérence visuelle et rester limitée.

### D. Contrôles automatiques obligatoires
Créer ou compléter un script qui :
- compare la liste des 75 IDs avec les images présentes ;
- échoue si une image est absente, vide, illisible ou mal nommée ;
- valide les dimensions minimales et les formats ;
- vérifie tous les `Contents.json` ;
- vérifie l'AppIcon 1024 × 1024 ;
- vérifie qu'aucun emoji n'est utilisé comme remplacement d'une image de plat en configuration Release.

Exécuter :
```bash
python3 scripts/validate_recipes.py
python3 scripts/validate_assets.py
```
Ajouter les tests unitaires nécessaires. Compiler avec Xcode sur simulateur iPhone. Vérifier au minimum l'accueil, les cinq cuisines, la grille, une fiche recette par cuisine, les favoris et le profil.

### E. Codemagic et App Store
- Vérifier le Bundle ID actuel `com.papawin.cuisiner` dans le projet et confirmer qu'il correspond à l'identifiant enregistré dans le compte Apple Developer. Ne pas le modifier sans preuve.
- Ne jamais inventer le Team ID, les certificats, les profils, les clés API ou les secrets.
- Ajouter ou corriger `codemagic.yaml` pour compiler le projet Xcode, signer l'application avec l'intégration App Store Connect configurée par le propriétaire, puis produire un artefact IPA et les symboles.
- Ajouter une étape de validation/TestFlight. L'upload App Store Connect peut être automatisé si les secrets et l'intégration sont déjà configurés.
- Ne pas déclencher une soumission en revue ni une publication publique sans approbation explicite de Winter.
- Documenter les variables et secrets attendus sans jamais afficher leurs valeurs.

## Livrables attendus

1. `docs/ASSET_AUDIT.md` : inventaire avant/après.
2. 75 images de plats individuelles et validées.
3. Mascotte Papa Win fidèle et variantes de poses/tenues.
4. Icône App Store finale.
5. Composants SwiftUI corrigés.
6. Script `scripts/validate_assets.py` et tests.
7. `codemagic.yaml` fonctionnel.
8. Rapport de compilation : commande, environnement, résultat, avertissements, artefact.
9. Liste claire des actions encore manuelles côté Apple.

## Règles impératives

- Travailler sur cette branche uniquement.
- Ne pas écraser ni supprimer les recettes ou fonctionnalités existantes.
- Ne pas remplacer les illustrations par des emojis.
- Ne pas déclarer les 75 images terminées tant que les 75 fichiers individuels n'existent pas et que le script ne passe pas.
- Ne pas déclarer la compilation ou l'upload réussis sans logs et artefact vérifiables.
- Faire des commits petits et explicites.
- À la fin, fournir le SHA des commits, les rapports de tests et les éventuels blocages.
