# Audit visuel — Cuisiner comme Papa Win

Dépôt : `winterbim/Cuisiner-comme-PAPA-Win`
Branche auditée : `claude/pensive-archimedes-5o2m55`
Commit de départ : `e587e4f76ea453bdb660a144067b59f9be471632`

## Résultats vérifiés

- 75 recettes sont présentes : 15 dans chacune des 5 cuisines.
- 49 images de recettes autonomes étaient intégrées dans `Assets.xcassets`.
- 26 recettes n'ont pas d'image dédiée et affichent donc le fallback emoji.
- `PapaWinAvatar` utilisait un dessin SwiftUI provisoire. Il ne reprenait pas fidèlement le portrait fourni.
- L'archive historique contient 75 vignettes provisoires. Plusieurs sont des recadrages de planches avec du texte coupé, un plat voisin ou le personnage à la place du plat. Elles ne sont pas une source fiable pour compléter les images manquantes.

## Mascotte intégrée

- Ajout de l'illustration dessinée de Papa Win issue du visuel créé à partir du portrait fourni.
- Asset : `CuisinerCommePapaWin/Resources/Assets.xcassets/papa_win.imageset/papa_win.jpg`.
- Le nom `papa_win` correspond à celui déjà attendu par `PapaWinAvatar`. Le composant charge automatiquement cette illustration.
- Aucun changement de navigation, de recette, de couleur, de typographie ou de mise en page.
- L'icône App Store existante n'a pas été remplacée dans ce commit.

## Images de recettes encore manquantes

**Maghreb (15)**
- `couscous-win-royal` — Couscous Win Royal
- `tajine-win-au-poulet` — Tajine Win au Poulet
- `tajine-kefta-win` — Tajine Kefta Win
- `tajine-agneau-win` — Tajine Agneau Win
- `chorba-win` — Chorba Win
- `harira-win` — Harira Win
- `loubia-win` — Loubia Win
- `chakchouka-win` — Chakchouka Win
- `zaalouk-win` — Zaalouk Win
- `rfissa-win` — Rfissa Win
- `brik-win-au-thon` — Brik Win au Thon
- `mechoui-win` — Méchoui Win
- `mderbel-win` — M'derbel Win
- `berkoukes-win` — Berkoukes Win
- `tajine-sardinwin` — Tajine Sardin'Win

**France (11)**
- `bourguignon-win` — Bœuf Bourguignon Win
- `pot-au-win` — Pot-au-Win
- `coq-au-win` — Coq au Win
- `blanquette-win` — Blanquette Win
- `hachis-parmenwin` — Hachis Parmen'Win
- `gratin-dauphinwin` — Gratin Dauphin'Win
- `cassoulet-win` — Cassoulet Win
- `tartiflette-win` — Tartiflette Win
- `ratatouille-win` — Ratatouille Win
- `choucroute-win` — Choucroute Win
- `navarin-win` — Navarin Win d'Agneau

## Publication

Ne pas importer les recadrages provisoires incorrects pour faire passer artificiellement le contrôle. Les 26 images doivent être créées ou fournies comme illustrations autonomes, fidèles au bon plat et vérifiées visuellement.

Exécuter :

```bash
python3 scripts/validate_assets.py
```

La publication App Store doit rester bloquée tant que le contrôle échoue.