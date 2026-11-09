# Audit visuel — Cuisiner comme Papa Win

Dépôt : `winterbim/Cuisiner-comme-PAPA-Win`
Branche auditée : `claude/pensive-archimedes-5o2m55`
Commit audité : `e587e4f76ea453bdb660a144067b59f9be471632`

## Résultats

- 75 recettes sont présentes : 15 dans chacune des 5 cuisines.
- 49 images de recettes autonomes sont intégrées dans `Assets.xcassets`.
- 26 recettes n'ont pas d'image dédiée et affichent le fallback emoji.
- `PapaWinAvatar` avait un dessin SwiftUI provisoire. Il ne reprenait pas fidèlement le portrait fourni.
- L'archive historique contient 75 vignettes provisoires. Plusieurs sont des recadrages de planches avec du texte coupé, un plat voisin ou le personnage à la place du plat. Elles ne sont pas une source fiable pour compléter les 26 images manquantes.

## Correction ciblée

- Ajout de l'illustration dessinée de Papa Win issue du visuel créé à partir du portrait fourni.
- L'asset porte le nom `papa_win`, déjà attendu par `PapaWinAvatar`. Le composant l'utilise automatiquement dès que l'asset est présent.
- Aucun changement de navigation, de recette, de couleur, de typographie ou de mise en page.

## Publication

Les 26 images de recettes manquantes doivent être créées ou fournies comme illustrations autonomes et vérifiées. Ne pas importer les recadrages provisoires incorrects pour faire passer artificiellement le contrôle.

Exécuter :

```bash
python3 scripts/validate_assets.py
```

La publication App Store doit rester bloquée tant que le contrôle échoue.