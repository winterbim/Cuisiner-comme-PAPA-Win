# Cahier des charges — Cuisiner comme Papa Win

> **Document de référence unique.** Il remplace et fusionne `VISUAL_ASSET_AUDIT.md`,
> `docs/CODEX_RELEASE_PROMPT.md` et `docs/ASSET_AUDIT_CODEX.md` (branche `codex/visual-identity-refresh`).
> Toute personne ou tout agent (Claude, Codex…) qui travaille sur le projet suit ce document.
> En cas de doute, demander à Winter, le propriétaire, plutôt qu'interpréter.

Dépôt : `winterbim/Cuisiner-comme-PAPA-Win` · Branche de travail : `claude/pensive-archimedes-5o2m55`
· Sauvegarde de l'état avant finalisation : branche `sauvegarde/avant-finalisation-2026-11-09` (commit `411fd43`).

---

## 1. Le produit

Application iOS native en SwiftUI, pour iOS 17 et plus, sur iPhone. Elle propose **75 plats salés, sans dessert**,
répartis en 15 recettes pour chacune des 5 cuisines : Portugal, Asie, Afrique (Afrique de l'Ouest, Madagascar et Congo),
Maghreb et France. Chaque plat porte « Win » dans son nom, par exemple Lok Win au Poulet, Poulet Yas'Win ou Coq au Win.

Fonctionnalités existantes, **à conserver toutes** :
- écran de bienvenue ;
- accueil avec le livre de recettes par cuisine, le plat du jour et les idées « faciles » ;
- recherche par plat, ingrédient ou pays, sans tenir compte des accents ;
- filtres : Facile, Rapide, Épicé, Mijoté, Poisson, Végétarien ;
- fiche recette :
  - portions ajustables ;
  - ingrédients et étapes à cocher ;
  - « L'astuce de Papa Win » ;
  - partage ;
  - écran maintenu allumé ;
  - bouton « J'ai cuisiné ce plat » ;
- favoris ;
- profil avec nom de chef, grade et progression par cuisine.

## 2. Règles absolues

1. **On ne refait pas l'application.** On ne change pas :
   - le design ;
   - les couleurs et la typographie ;
   - les écrans et la navigation ;
   - l'architecture ;
   - les recettes et les noms « Win ».

   Seules les modifications ciblées, justifiées et testées sont admises.
2. **Une seule référence graphique : l'illustration Papa Win validée**
   (`CuisinerCommePapaWin/Resources/Assets.xcassets/papa_win.imageset/papa_win.jpg`).
   - Interdit : modifier le visage, la barbe, les proportions ou le style.
   - Interdit : créer un autre personnage, des variantes de pose ou des tenues.
3. **Images de plats :**
   - chaque image représente le plat exact ;
   - aucun texte incrusté ;
   - aucun personnage dans l'image ;
   - aucune image réutilisée pour un autre plat ;
   - aucun recadrage des anciennes planches ;
   - aucun emoji, clipart ou photo web non vérifiée en guise d'illustration finale.
4. **Ne pas contourner les contrôles.** `scripts/validate_assets.py` ne doit être ni désactivé ni contourné.
   Ne jamais marquer une image « définitive » sans l'avoir vérifiée visuellement.
5. **Aucun secret dans Git** : pas de clé, de certificat, de mot de passe ni de jeton.
6. **Aucune publication sur l'App Store sans l'accord explicite de Winter.**
   - Le workflow Codemagic s'arrête à TestFlight.
   - Ne jamais écrire « publié » si l'app n'est pas réellement disponible sur l'App Store.
7. **Ne jamais masquer un test en échec.** Ne jamais déclarer un build réussi sans les logs et l'artefact correspondants.

## 3. Mascotte et icône

| Asset | Fichier | Rôle |
|---|---|---|
| `papa_win` | `papa_win.jpg`, 256 × 256 | **Original validé**, jamais retouché |
| `papa_win_hd` | `papa_win_hd.jpg`, 1024 × 1024 | Illustration complète, affichée sur l'écran Profil |
| `papa_win_round` | `papa_win_round.png`, 1024 × 1024, transparent | Portrait rond centré sur le visage : bienvenue, accueil, astuces, états vides |
| `AppIcon` | `AppIcon.png`, 1024 × 1024, PNG RVB opaque | Icône construite à partir du portrait rond (`design/mascotte/icone.html`) |

- Le composant `PapaWinAvatar` a deux styles :
  - `.portrait` : rond, avec une bordure blanche ;
  - `.full` : illustration complète.
- Le dessin vectoriel du code ne sert que de secours si les images sont absentes du bundle.
- **Limite connue :** l'original ne fait que 256 × 256. Les versions 1024 et l'icône sont donc *interpolées*.
  Dès que l'original haute définition est disponible, suivre `design/mascotte/README.md` pour tout régénérer.

## 4. Les 75 illustrations de plats

**État actuel :** 0/75 définitive. Le détail, plat par plat, est dans `docs/illustrations/ETAT.md`.
- **26 manquantes :** les 15 plats du Maghreb et 11 plats français.
- **49 provisoires :** les vignettes de 450 × 340 découpées dans des planches, avec le nom du plat incrusté.
  Elles servent seulement à avoir un aperçu pendant le développement. **Elles ne seront jamais considérées comme définitives** :
  elles sont identifiées par leur empreinte SHA-256 et refusées automatiquement.

**Cahier de production :** `docs/illustrations/BRIEF.md` donne, pour chaque plat :
- le fichier attendu ;
- le plat réel ;
- le pays ;
- les éléments à montrer, tirés des ingrédients de la recette.

**Spécification technique**, contrôlée automatiquement et définie dans `docs/illustrations/manifest.json` :
- JPEG, ou PNG sans transparence ;
- 1600 × 1200 conseillé, au minimum 1200 × 900 ;
- ratio entre 1,2 et 1,6 (4:3 conseillé) ;
- moins de 4 Mo ;
- compression raisonnable : au moins 0,5 bit par pixel en JPEG ;
- couleurs RVB, pas de CMJN ;
- nom de fichier = l'identifiant exact de la recette.

**Procédure de remplacement**, pour chacune des 75 images :
1. Produire l'illustration selon le brief. Style : illustration culinaire dessinée, chaleureuse, cohérente avec l'illustration Papa Win.
2. Déposer les fichiers `<id>.jpg` dans un dossier, puis lancer `python3 scripts/illustrations.py importer DOSSIER`.
   Les images non conformes sont refusées. Les autres passent au statut « à vérifier ».
3. Vérifier visuellement chaque image : bon plat, sans texte, sans personnage, sans doublon.
4. Lancer `python3 scripts/illustrations.py valider <id> [<id> …]` pour passer au statut « définitive ».
5. Lancer `python3 scripts/validate_assets.py` : il doit afficher « OK » avant toute publication.

Le dégradé avec emoji affiché par l'app quand une image manque est un **secours de développement**. Il ne peut jamais
partir en production : le contrôle bloquant du workflow TestFlight l'empêche.

## 5. Contrôles et tests

```bash
python3 -m unittest discover -s scripts/tests -v   # 23 tests des scripts de contrôle
python3 scripts/validate_recipes.py                # 75 recettes : champs, « Win », tags, ingrédients, étapes
python3 scripts/check_xcode_project.py             # projet Xcode, scheme, Bundle ID, cohérence avec codemagic.yaml
python3 scripts/validate_assets.py                 # 75 illustrations + mascotte + icône (bloquant)
```

Tests XCTest de l'app, dans `CuisinerCommePapaWinTests/`, exécutés sur simulateur par Codemagic ou avec ⌘U dans Xcode :
- chargement des 75 recettes, 15 par cuisine ;
- noms « Win », Lok Win au poulet ;
- recherche sans accents et filtres ;
- quantités, portions et durées ;
- favoris et progression sauvegardés ;
- grades de chef ;
- mascotte et couleur d'accent présentes dans le bundle.

## 6. Codemagic

`codemagic.yaml` contient deux workflows :

| Workflow | Déclenchement | Ce qu'il fait |
|---|---|---|
| `verification-ios` | Automatique à chaque push et pull request | Contrôles et tests des scripts, tests XCTest sur simulateur iPhone, compilation **Release** pour simulateur et pour iPhone sans signature. Logs, `.xcresult` et rapport d'images en artefacts. Images : rapport non bloquant. |
| `testflight-ios` | **Manuel** uniquement | Contrôles, **contrôle des images bloquant**, tests, signature, numéro de build = dernier build TestFlight + 1, IPA Release signée, envoi **TestFlight**. `submit_to_app_store: false`. |

Le paramètre `AUTORISER_IMAGES_PROVISOIRES` vaut `false` par défaut. Le passer à `true` au lancement permet seulement un build
TestFlight **interne** pour tester sur un vrai iPhone. Jamais pour l'App Store.

**À faire une seule fois par Winter**, aucun agent ne peut le faire à sa place :
1. Sur codemagic.io, se connecter avec GitHub et ajouter le dépôt. Codemagic détecte `codemagic.yaml`.
2. Sur App Store Connect, aller dans *Utilisateurs et accès › Intégrations* et créer une clé API avec le rôle *App Manager*.
   Noter l'*Issuer ID* et le *Key ID*, et télécharger le `.p8`.
3. Dans Codemagic, aller dans *Team settings › Integrations › Developer Portal* et ajouter cette clé. Fait : la clé existante **`bimcheck-academy-apple`** (même équipe Apple F9B4GCT2HV) est réutilisée.
   Si tu choisis un autre nom, le reporter dans `codemagic.yaml`.
4. Vérifier le Bundle ID **`com.papawin.cuisiner`** :
   - sur developer.apple.com, aller dans *Certificates, Identifiers & Profiles › Identifiers* ;
   - l'enregistrer s'il n'existe pas ;
   - s'il est pris ou si tu préfères un autre identifiant, le changer **partout** : dans `project.pbxproj` (app et tests)
     et dans `codemagic.yaml`. `check_xcode_project.py` vérifie qu'ils sont identiques.
5. Sur App Store Connect, aller dans *Apps › +* et créer l'app avec ce Bundle ID.
   Noter son **Apple ID** numérique, visible dans *Informations sur l'app*.
6. Dans Codemagic, aller dans *Code signing identities* et générer ou importer un certificat *Apple Distribution*,
   puis récupérer le profil *App Store* de `com.papawin.cuisiner`.
7. Dans Codemagic, créer le groupe de variables **`papa_win_app_store`** avec la variable `APP_STORE_APPLE_ID`
   (l'Apple ID de l'étape 5).
8. Lancer d'abord `verification-ios`, puis `testflight-ios`.

## 7. App Store Connect (avant toute soumission)

Points à préparer et à faire valider par Winter :
- **Fiche :** nom « Cuisiner comme Papa Win », sous-titre, description en français, mots-clés,
  catégorie *Cuisine et boissons*, classification d'âge 4+.
- **Captures d'écran :** iPhone 6,9 pouces (1320 × 2868 ou 1290 × 2796) au minimum,
  réalisées sur l'app finale avec les 75 illustrations définitives.
- **URL d'assistance et URL de politique de confidentialité** : obligatoires.
- **Confidentialité :** le code n'utilise ni réseau, ni compte, ni publicité, ni outil de mesure.
  Les favoris et la progression restent sur l'appareil, dans `UserDefaults`. Déclaration proposée : *« Données non collectées »*.
  À revérifier si le code change.
- **Chiffrement :** `ITSAppUsesNonExemptEncryption = NO`, déjà déclaré dans le projet.
- **Ordre :** TestFlight, puis test sur un vrai iPhone (lancement, 5 cuisines, recherche, fiche recette, portions,
  favoris, profil), puis **accord de Winter**, puis soumission manuelle à la revue d'Apple.

## 8. Ressources manquantes (bloquantes pour la publication)

| Ressource | Fournie par | État |
|---|---|---|
| 75 illustrations définitives de plats (26 manquantes et 49 provisoires à remplacer) | Production graphique selon `BRIEF.md` | ❌ 0/75 |
| Illustration originale Papa Win en haute définition (≥ 1024 px) | Winter | ⚠️ seulement 256 px (versions interpolées en attendant) |
| Fichier `PapaWin_AppIcon_1024.png` cité par l'ancien brief Codex | Winter | ❌ absent du dépôt ; icône actuelle dérivée du portrait validé |
| Compte Apple Developer, clé API App Store Connect, certificat de distribution | Winter (section 6) | ❌ à configurer dans Codemagic |
| App créée sur App Store Connect et `APP_STORE_APPLE_ID` | Winter | ❌ |
| URL d'assistance et URL de politique de confidentialité | Winter | ❌ |
| Captures d'écran App Store | Après les illustrations définitives | ❌ |
| Relecture culinaire des 75 recettes (quantités, cuissons, sécurité alimentaire) | Winter ou un relecteur | ⚠️ recettes rédigées et validées techniquement, pas encore relues par un humain |

## 9. Contradictions des anciens documents et décisions retenues

| Ancienne consigne | Décision |
|---|---|
| « Créer une vraie mascotte, avec variantes de poses et de tenues » (brief Codex) | **Supprimé.** Seule l'illustration validée est utilisée, déclinée sans retouche : HD, portrait rond, icône. |
| « Remplacer l'icône par `PapaWin_AppIcon_1024.png` fourni séparément » (brief Codex) | Le fichier n'existe pas dans le dépôt. L'icône est **dérivée du portrait validé**. Si Winter fournit ce fichier, il le remplace après contrôle par `validate_assets.py`. |
| « Créer une illustration par cuisine » (brief Codex) | **Supprimé.** Hors périmètre : l'interface utilise déjà les drapeaux et les couleurs de chaque cuisine. |
| « Remplacer le secours emoji » (brief Codex) et « ne pas toucher aux composants » (consignes de publication) | Le secours reste pour le développement. **La publication est bloquée** tant qu'une image manque ou est provisoire. |
| « 26 images manquantes » (audit visuel) | **75 images à produire** : les 49 vignettes existantes sont provisoires, avec texte incrusté et en 450 × 340. |
| `papa_win.png` (README) et `papa_win.jpg` (contrôle) | Les deux formats sont acceptés pour l'original de la mascotte. |
| Travailler sur la branche `codex/visual-identity-refresh` | Branche fusionnée. Le travail continue sur `claude/pensive-archimedes-5o2m55`. |

## 10. Rapport attendu à la fin de chaque intervention

- Branche et commits (SHA).
- Liste exacte des fichiers modifiés.
- Sortie des 4 commandes de la section 5.
- Nombre d'illustrations vérifiées visuellement.
- Lien ou numéro du build Codemagic, résultat de `verification-ios`, puis de `testflight-ios`.
- Statut TestFlight et statut App Store Connect.
- Blocages restants, avec les logs utiles.
