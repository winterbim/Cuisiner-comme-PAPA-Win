# Images des plats avec ChatGPT : mode d'emploi strict

Objectif : **75 images, une par plat**, toutes rangées dans **un seul dossier**, que tu me donnes ensuite.
Je les contrôle (`scripts/validate_assets.py`), je les mets dans l'app et je lance le build TestFlight.

## Pourquoi ChatGPT se trompait

- Il ne connaît pas les noms « Win » (Lok Win, Tchèb Poulet Win…) : il invente un plat ou **écrit le nom sur l'image**.
- Les consignes ci-dessous ne lui donnent **jamais** le nom « Win » : seulement le **vrai plat**, son pays et **à quoi il ressemble dans l'assiette**.
- **Une image par message**, jamais plusieurs à la fois (sinon il mélange les plats).

## Étape 1 — Coller ce message une seule fois, au début d'une nouvelle conversation

```text
Tu vas créer 75 illustrations de plats pour une application de cuisine. Règles OBLIGATOIRES pour CHAQUE image :
1. Une seule image par réponse, au format paysage 4:3 (1536 × 1024 ou plus).
2. Le plat décrit EXACTEMENT, tel qu'il est servi traditionnellement dans son pays. Ne remplace jamais un ingrédient, n'invente pas de plat.
3. AUCUN texte, AUCUNE lettre, AUCUN chiffre, AUCUN logo, AUCUNE étiquette, nulle part sur l'image.
4. AUCUN personnage, AUCUNE main, AUCUN visage, AUCUN animal vivant.
5. Une seule assiette ou un seul plat de service, centré, vue légèrement plongeante (environ 45°), avec de la marge tout autour.
6. Même style pour les 75 images : illustration culinaire peinte, nette et détaillée (pas floue), couleurs chaudes et appétissantes, lumière douce, table en bois clair, fond de cuisine crème légèrement flou.
7. Après l'image, écris seulement : « Image n° X — fichier : NOM.png ». Rien d'autre.
8. Si une consigne n'est pas claire, demande-moi au lieu d'inventer.
Réponds « Compris » et attends la première consigne.
```

## Étape 2 — Pour chaque plat

1. Colle la consigne du plat (section « Consignes », plus bas).
2. **Vérifie l'image** avec la liste de contrôle ci-dessous. Si un point est faux, colle le message de correction.
3. Télécharge l'image et **renomme-la exactement** avec le nom de fichier indiqué (ex. `lok-win.png`). PNG, JPG ou WebP : je convertis si besoin.
4. Range-la dans ton dossier `images-papa-win`.

### Liste de contrôle (à chaque image)

- [ ] C'est bien le plat décrit (pas un autre plat qui lui ressemble).
- [ ] Aucun texte, lettre, chiffre ou logo, même petit, même sur un bol ou une nappe.
- [ ] Aucun personnage, main ou visage.
- [ ] L'image est nette, pas floue, et en format paysage.
- [ ] Le plat est centré avec de la marge (rien de coupé sur les bords).

### Message de correction (si l'image est fausse)

```text
Cette image ne respecte pas les règles : [écris le problème, ex. « il y a du texte », « ce n'est pas le bon plat », « c'est flou »].
Refais exactement la même consigne en corrigeant ce point, en respectant toutes les règles du début.
```

### Si ChatGPT commence à dériver (après 15-20 images)

Ouvre une **nouvelle conversation**, recolle le message de l'étape 1, puis reprends au plat suivant.

## Étape 3 — Me donner le dossier

Quand les 75 images sont dans `images-papa-win`, mets le dossier dans le projet (ou dis-moi où il est) et écris-moi « images prêtes ».
Je refuserai automatiquement une image trop petite, au mauvais nom ou en double, et je te dirai lesquelles refaire.

## Liste des 75 plats

| N° | Cuisine | Nom dans l'app | Plat réel | Pays | Nom du fichier |
|---|---|---|---|---|---|
| 1 | Portugal | Bacal'Win à Brás | Bacalhau à Brás | Portugal | `bacalwin-a-bras.png` |
| 2 | Portugal | Bacal'Win com Natas | Bacalhau com natas | Portugal | `bacalwin-com-natas.png` |
| 3 | Portugal | Frances'Win | Francesinha | Portugal | `franceswin.png` |
| 4 | Portugal | Cozido Win à Portuguesa | Cozido à portuguesa | Portugal | `cozido-win.png` |
| 5 | Portugal | Caldo Verde Win | Caldo verde | Portugal | `caldo-verde-win.png` |
| 6 | Portugal | Arroz de Pato Win | Arroz de pato | Portugal | `arroz-de-pato-win.png` |
| 7 | Portugal | Porco Alentej'Win | Carne de porco à alentejana | Portugal | `porco-alentejwin.png` |
| 8 | Portugal | Bifa'Win | Bifana | Portugal | `bifawin.png` |
| 9 | Portugal | Frango Piri-Win | Frango piri-piri | Portugal | `frango-piri-win.png` |
| 10 | Portugal | Feijo'Win Transmontana | Feijoada à transmontana | Portugal | `feijowin.png` |
| 11 | Portugal | Sardin'Win Grillées | Sardinhas assadas | Portugal | `sardinwin.png` |
| 12 | Portugal | Polvo Win à Lagareiro | Polvo à lagareiro | Portugal | `polvo-win.png` |
| 13 | Portugal | Arroz de Marisco Win | Arroz de marisco | Portugal | `arroz-de-marisco-win.png` |
| 14 | Portugal | Alheira Win de Mirandela | Alheira de Mirandela | Portugal | `alheira-win.png` |
| 15 | Portugal | Bitoque Win | Bitoque | Portugal | `bitoque-win.png` |
| 16 | Asie | Lok Win au Poulet | Lok lak (version poulet) | Cambodge | `lok-win.png` |
| 17 | Asie | Laap Win | Laap (larb) | Laos | `laap-win.png` |
| 18 | Asie | Khao Piak Win | Khao piak sen | Laos | `khao-piak-win.png` |
| 19 | Asie | Or Lam Win | Or lam | Laos | `or-lam-win.png` |
| 20 | Asie | Poulet Kung Pao Win | Poulet Kung Pao | Chine | `kung-pao-win.png` |
| 21 | Asie | Riz Cantonais Win | Riz cantonais | Chine | `riz-cantonais-win.png` |
| 22 | Asie | Porc Aigre-Doux Win | Porc aigre-doux | Chine | `aigre-doux-win.png` |
| 23 | Asie | Mapo Win Tofu | Mapo tofu | Chine | `mapo-win.png` |
| 24 | Asie | Poulet Teriyaki Win | Poulet teriyaki | Japon | `teriyaki-win.png` |
| 25 | Asie | Ramen Win | Shoyu ramen | Japon | `ramen-win.png` |
| 26 | Asie | Karaage Win | Karaage | Japon | `karaage-win.png` |
| 27 | Asie | Gyo'Win | Gyoza | Japon | `gyowin.png` |
| 28 | Asie | Phở Win | Phở bò | Vietnam | `pho-win.png` |
| 29 | Asie | Bo Bun Win | Bún bò Nam Bộ (bo bun) | Vietnam | `bo-bun-win.png` |
| 30 | Asie | Pad Win Thaï | Pad thaï | Thaïlande | `pad-win.png` |
| 31 | Afrique | Tchébou Win | Thiéboudienne (thiébou dieune) | Sénégal | `tchebou-win.png` |
| 32 | Afrique | Tchèb Poulet Win | Thiébou guinar (thiéb au poulet) | Sénégal | `tcheb-poulet-win.png` |
| 33 | Afrique | Maf'Win | Mafé | Mali | `mafwin.png` |
| 34 | Afrique | Poulet Yas'Win | Poulet yassa | Sénégal | `poulet-yaswin.png` |
| 35 | Afrique | Ravitoto Win | Ravitoto sy henakisoa | Madagascar | `ravitoto-win.png` |
| 36 | Afrique | Hena Ritra Win | Henan'omby ritra au gingembre (bœuf confit malgache) | Madagascar | `hena-ritra-win.png` |
| 37 | Afrique | Romaza'Win | Romazava | Madagascar | `romazawin.png` |
| 38 | Afrique | Foufou Win | Foufou (fufu) et sa sauce | RD Congo | `foufou-win.png` |
| 39 | Afrique | Pondou Win | Pondu (saka-saka) | RD Congo | `pondou-win.png` |
| 40 | Afrique | Poulet Moambé Win | Poulet à la moambe | RD Congo | `moambe-win.png` |
| 41 | Afrique | Tô Win Sauce Gombo | Tô à la sauce gombo | Mali | `to-win.png` |
| 42 | Afrique | Riz Gras Win | Riz gras (zamè) | Mali | `riz-gras-win.png` |
| 43 | Afrique | Dibi Win | Dibi (agneau grillé à la sénégalaise) | Sénégal | `dibi-win.png` |
| 44 | Afrique | Attiéké Win Poisson Braisé | Attiéké poisson braisé | Côte d'Ivoire | `attieke-win.png` |
| 45 | Afrique | Thiou Win | Thiou (ragoût sénégalais) | Sénégal | `thiou-win.png` |
| 46 | Maghreb | Couscous Win Royal | Couscous royal | Algérie | `couscous-win-royal.png` |
| 47 | Maghreb | Tajine Win au Poulet | Tajine de poulet au citron confit et aux olives | Maroc | `tajine-win-au-poulet.png` |
| 48 | Maghreb | Tajine Kefta Win | Tajine de kefta aux œufs | Maroc | `tajine-kefta-win.png` |
| 49 | Maghreb | Tajine Agneau Win | Tajine d'agneau aux pruneaux | Maroc | `tajine-agneau-win.png` |
| 50 | Maghreb | Chorba Win | Chorba frik | Algérie | `chorba-win.png` |
| 51 | Maghreb | Harira Win | Harira | Maroc | `harira-win.png` |
| 52 | Maghreb | Loubia Win | Loubia (haricots blancs en sauce) | Algérie | `loubia-win.png` |
| 53 | Maghreb | Chakchouka Win | Chakchouka | Tunisie | `chakchouka-win.png` |
| 54 | Maghreb | Zaalouk Win | Zaalouk d'aubergines | Maroc | `zaalouk-win.png` |
| 55 | Maghreb | Rfissa Win | Rfissa au poulet | Maroc | `rfissa-win.png` |
| 56 | Maghreb | Brik Win au Thon | Brik à l'œuf et au thon | Tunisie | `brik-win-au-thon.png` |
| 57 | Maghreb | Méchoui Win | Méchoui d'agneau (épaule au four, version maison) | Maroc | `mechoui-win.png` |
| 58 | Maghreb | M'derbel Win | M'derbel d'aubergines | Algérie | `mderbel-win.png` |
| 59 | Maghreb | Berkoukes Win | Berkoukes aux légumes | Algérie | `berkoukes-win.png` |
| 60 | Maghreb | Tajine Sardin'Win | Tajine de boulettes de sardines | Maroc | `tajine-sardinwin.png` |
| 61 | France | Bœuf Bourguignon Win | Bœuf bourguignon | France | `bourguignon-win.png` |
| 62 | France | Pot-au-Win | Pot-au-feu | France | `pot-au-win.png` |
| 63 | France | Coq au Win | Coq au vin | France | `coq-au-win.png` |
| 64 | France | Blanquette Win | Blanquette de veau | France | `blanquette-win.png` |
| 65 | France | Hachis Parmen'Win | Hachis parmentier | France | `hachis-parmenwin.png` |
| 66 | France | Gratin Dauphin'Win | Gratin dauphinois | France | `gratin-dauphinwin.png` |
| 67 | France | Cassoulet Win | Cassoulet | France | `cassoulet-win.png` |
| 68 | France | Tartiflette Win | Tartiflette | France | `tartiflette-win.png` |
| 69 | France | Ratatouille Win | Ratatouille | France | `ratatouille-win.png` |
| 70 | France | Choucroute Win | Choucroute garnie | France | `choucroute-win.png` |
| 71 | France | Navarin Win d'Agneau | Navarin d'agneau | France | `navarin-win.png` |
| 72 | France | Poulet Basquaise Win | Poulet basquaise | France | `poulet-basquaise-win.png` |
| 73 | France | Moules-Frites Win | Moules-frites | France | `moules-frites-win.png` |
| 74 | France | Croque-Win Monsieur | Croque-monsieur | France | `croque-win.png` |
| 75 | France | Quiche Win Lorraine | Quiche lorraine | France | `quiche-win.png` |

## Consignes (une par plat, à coller une par une)

### Portugal

#### 1. Bacal'Win à Brás → `bacalwin-a-bras.png`

```text
Image n° 1 — fichier : bacalwin-a-bras.png
Plat : Bacalhau à Brás, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Goûte avant de saler (la morue s'en charge souvent), parsème de persil haché, décore d'olives noires et sers immédiatement.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : morue dessalée, pommes de terre, oignons, ail, œufs, huile d'olive, huile de friture, persil plat, olives noires.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 2. Bacal'Win com Natas → `bacalwin-com-natas.png`

```text
Image n° 2 — fichier : bacalwin-com-natas.png
Plat : Bacalhau com natas, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Enfourne 25 minutes à 200 °C, jusqu'à ce que le dessus soit bien doré. Laisse reposer 5 minutes avant de servir, le temps de mettre la table et de cacher la cuillère de service aux gourmands.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : morue dessalée, pommes de terre, oignons, ail, lait, beurre, farine, crème liquide entière, noix de muscade râpée, fromage râpé, huile de friture, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 3. Frances'Win → `franceswin.png`

```text
Image n° 3 — fichier : franceswin.png
Plat : Francesinha, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Pose un œuf sur chaque francesinha, nappe généreusement de sauce bien chaude et sers avec des frites.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : pain de mie épais, steaks de bœuf fins, linguiça (saucisse fumée portugaise), saucisses fraîches, jambon blanc, fromage fondant (type flamengo ou edam), œufs, bière blonde, bouillon de bœuf, concentré de tomate, porto rouge, oignon, fécule de maïs, piment piri-piri.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 4. Cozido Win à Portuguesa → `cozido-win.png`

```text
Image n° 4 — fichier : cozido-win.png
Plat : Cozido à portuguesa, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Découpe les viandes et les enchidos en tranches et dresse le tout sur un grand plat avec les légumes, le riz à part. Sers avec un peu de bouillon et laisse la tablée se servir : c'est le moment où tout le monde découvre ses talents de négociateur pour le dernier morceau de chouriço.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : plat de côtes ou jarret de bœuf, poitrine de porc demi-sel, cuisses de poulet, chouriço, morcela (boudin noir portugais), farinheira, pommes de terre, carottes, navets, chou vert frisé, riz.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 5. Caldo Verde Win → `caldo-verde-win.png`

```text
Image n° 5 — fichier : caldo-verde-win.png
Plat : Caldo verde, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Pendant ce temps, fais dorer les rondelles de chouriço 2 minutes à la poêle sèche. Sers la soupe dans des bols avec une rondelle ou deux de chouriço et un filet d'huile d'olive.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : pommes de terre farineuses, couve galega (ou chou kale), oignon, ail, chouriço, eau, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 6. Arroz de Pato Win → `arroz-de-pato-win.png`

```text
Image n° 6 — fichier : arroz-de-pato-win.png
Plat : Arroz de pato, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Décore le dessus avec des rondelles fines de chouriço (le reste cru et la moitié cuite) et enfourne 20 à 25 minutes, jusqu'à ce que le dessus soit doré et croustillant. Attention, tout le monde va se battre pour les coins.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : canard entier (environ 2 kg) ou 4 cuisses, riz rond (type carolino), chouriço, lard fumé en tranches, oignons, carotte, ail, laurier, vin blanc, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 7. Porco Alentej'Win → `porco-alentejwin.png`

```text
Image n° 7 — fichier : porco-alentejwin.png
Plat : Carne de porco à alentejana, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Mélange avec les pommes de terre frites, parsème de coriandre ciselée et sers avec des quartiers de citron.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : échine de porc en cubes, palourdes, vin blanc, massa de pimentão (pâte de poivron rouge), ail, laurier, paprika doux, pommes de terre, coriandre fraîche, citron, huile d'olive, huile de friture.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 8. Bifa'Win → `bifawin.png`

```text
Image n° 8 — fichier : bifawin.png
Plat : Bifana, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Glisse une ou deux escalopes dans chaque pain, arrose d'une cuillère de sauce et sers aussitôt avec de la moutarde.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : escalopes de porc très fines, petits pains croustillants (papo-secos), ail, vin blanc, paprika doux, laurier, saindoux (ou huile d'olive), piment piri-piri.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 9. Frango Piri-Win → `frango-piri-win.png`

```text
Image n° 9 — fichier : frango-piri-win.png
Plat : Frango piri-piri, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Laisse reposer 5 minutes, découpe et sers avec le reste du citron en quartiers, des frites et une salade. Prévois des serviettes, beaucoup de serviettes.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier (environ 1,5 kg), piments piri-piri ou oiseau, ail, citrons, huile d'olive, paprika doux, laurier, whisky (facultatif), gros sel.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 10. Feijo'Win Transmontana → `feijowin.png`

```text
Image n° 10 — fichier : feijowin.png
Plat : Feijoada à transmontana, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Sers bien chaud avec du riz blanc et prévois une petite promenade digestive après. Non, la sieste ne compte pas comme une promenade.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : haricots rouges secs, travers de porc, jarret de porc demi-sel, lard fumé, chouriço, salpicão (saucisson fumé portugais), farinheira, chou vert, carottes, oignons, ail, laurier, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 11. Sardin'Win Grillées → `sardinwin.png`

```text
Image n° 11 — fichier : sardinwin.png
Plat : Sardinhas assadas, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Sers chaque sardine sur une tranche de pain, avec les pommes de terre arrosées d'un filet d'huile d'olive et la salade de poivrons. On mange avec les doigts, c'est la loi.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : sardines fraîches entières (environ 1,2 kg), gros sel, petites pommes de terre, poivrons rouges, oignon, ail, vinaigre de vin, huile d'olive, pain de campagne (ou broa de maïs).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 12. Polvo Win à Lagareiro → `polvo-win.png`

```text
Image n° 12 — fichier : polvo-win.png
Plat : Polvo à lagareiro, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Enfourne 15 à 20 minutes à 220 °C, jusqu'à ce que le poulpe soit doré sur les bords. Parsème d'herbes hachées, poivre et sers bien chaud, avec du pain pour saucer l'huile.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulpe (congelé puis décongelé), oignon, laurier, petites pommes de terre, gros sel, ail, huile d'olive, persil plat ou coriandre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 13. Arroz de Marisco Win → `arroz-de-marisco-win.png`

```text
Image n° 13 — fichier : arroz-de-marisco-win.png
Plat : Arroz de marisco, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Parsème de coriandre hachée et sers immédiatement, directement dans la cocotte. Ici, un riz qui attend est un riz qui boit toute la sauce, alors tout le monde à table !
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : crevettes crues entières, palourdes, moules, riz rond (type carolino), eau, oignon, ail, tomates mûres, vin blanc, laurier, piment piri-piri, huile d'olive, coriandre fraîche.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 14. Alheira Win de Mirandela → `alheira-win.png`

```text
Image n° 14 — fichier : alheira-win.png
Plat : Alheira de Mirandela, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Dresse chaque alheira avec un œuf au plat par-dessus, les frites et les grelos à côté. Perce le jaune à table : c'est le moment préféré de tout le monde, moi le premier.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : alheiras de Mirandela, œufs, pommes de terre, grelos (fanes de navet) ou brocoli-rave, ail, huile d'olive, huile de friture.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 15. Bitoque Win → `bitoque-win.png`

```text
Image n° 15 — fichier : bitoque-win.png
Plat : Bitoque, cuisine traditionnelle (Portugal).
Dans l'assiette, on doit voir : Dresse chaque steak nappé de sauce avec un œuf au plat par-dessus, les frites, le riz et quelques feuilles de laitue. Oui, frites ET riz : au Portugal, on ne choisit pas.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : steaks de bœuf fins (environ 150 g chacun), ail, laurier, vin blanc, beurre, œufs, pommes de terre, riz, laitue, huile d'olive, huile de friture.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

### Asie

#### 16. Lok Win au Poulet → `lok-win.png`

```text
Image n° 16 — fichier : lok-win.png
Plat : Lok lak (version poulet), cuisine traditionnelle (Cambodge).
Dans l'assiette, on doit voir : Dresse un lit de laitue, de tomates et d'oignon, pose le poulet bien chaud par-dessus et sers avec le riz. Chacun trempe ses bouchées dans la sauce citron vert-poivre.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : hauts de cuisse ou blancs de poulet, sauce huître, sauce soja claire, sucre, ail, huile neutre, riz jasmin, laitue, tomates, oignon rouge, citrons verts, poivre de Kampot (ou poivre noir) concassé, sel.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 17. Laap Win → `laap-win.png`

```text
Image n° 17 — fichier : laap-win.png
Plat : Laap (larb), cuisine traditionnelle (Laos).
Dans l'assiette, on doit voir : Saupoudre le reste de khao khua et sers tiède avec le riz gluant (cuit 25 min à la vapeur) et des feuilles de laitue pour faire des petites bouchées à la main.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet haché au couteau (ou porc haché), riz gluant cru (pour le khao khua), sauce poisson (nuoc-mâm), citrons verts, échalotes, oignons nouveaux, menthe, coriandre, piment en poudre (à ajuster), laitue (pour servir), riz gluant (pour servir, trempé la veille).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 18. Khao Piak Win → `khao-piak-win.png`

```text
Image n° 18 — fichier : khao-piak-win.png
Plat : Khao piak sen, cuisine traditionnelle (Laos).
Dans l'assiette, on doit voir : Remets le poulet, sers dans des bols et garnis d'ail frit avec un filet de son huile, d'oignons nouveaux, de coriandre, d'un quartier de citron vert et de piment pour les courageux.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : cuisses de poulet (environ 1 kg), eau, tiges de citronnelle, galanga (ou gingembre), échalotes, ail, huile neutre, sauce poisson (nuoc-mâm), farine de riz, fécule de tapioca (plus un peu pour fariner), oignons nouveaux, coriandre, citrons verts.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 19. Or Lam Win → `or-lam-win.png`

```text
Image n° 19 — fichier : or-lam-win.png
Plat : Or lam, cuisine traditionnelle (Laos).
Dans l'assiette, on doit voir : Hors du feu, ajoute l'aneth et le basilic grossièrement ciselés. Goûte, rectifie en sauce poisson et sers avec du riz gluant.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf à mijoter (paleron ou macreuse), eau, tiges de citronnelle, piments séchés, échalotes, ail, aubergines thaïes (ou 1 aubergine classique), haricots kilomètre (ou haricots verts), riz gluant cru, trempé 1 h, poivre de Sichuan (pour remplacer le bois de sakhan), sauce poisson (nuoc-mâm), aneth, basilic thaï.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 20. Poulet Kung Pao Win → `kung-pao-win.png`

```text
Image n° 20 — fichier : kung-pao-win.png
Plat : Poulet Kung Pao, cuisine traditionnelle (Chine).
Dans l'assiette, on doit voir : Remue la sauce, verse-la dans le wok et mélange 30 s jusqu'à ce qu'elle nappe le poulet d'un glaçage brillant. Hors du feu, ajoute les cacahuètes et sers aussitôt avec du riz blanc.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : hauts de cuisse de poulet désossés, sauce soja claire, vin de Shaoxing (ou xérès sec), fécule de maïs, vinaigre noir de Chinkiang (ou vinaigre balsamique), sucre, piments rouges séchés, poivre de Sichuan en grains, ail, gingembre frais, oignons nouveaux (parties blanches), cacahuètes grillées non salées, huile neutre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 21. Riz Cantonais Win → `riz-cantonais-win.png`

```text
Image n° 21 — fichier : riz-cantonais-win.png
Plat : Riz cantonais, cuisine traditionnelle (Chine).
Dans l'assiette, on doit voir : Remets les œufs et les crevettes, verse la sauce soja sur le bord brûlant du wok, ajoute l'huile de sésame, les verts d'oignons et un tour de poivre blanc. Mélange 30 s et sers.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : riz cuit de la veille (environ 250 g cru), œufs, jambon blanc ou porc laqué (char siu) en dés, crevettes décortiquées, petits pois surgelés, oignons nouveaux, sauce soja claire, huile de sésame, huile neutre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 22. Porc Aigre-Doux Win → `aigre-doux-win.png`

```text
Image n° 22 — fichier : aigre-doux-win.png
Plat : Porc aigre-doux, cuisine traditionnelle (Chine).
Dans l'assiette, on doit voir : Verse la sauce et laisse bouillonner 1 min jusqu'à ce qu'elle épaississe. Ajoute le porc, enrobe 30 s et sers immédiatement avec du riz.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : échine de porc, sauce soja claire, vin de Shaoxing (ou xérès sec), œuf, fécule de maïs, huile de friture, poivron rouge, poivron vert, oignon, ananas frais, ail, ketchup, vinaigre de riz, sucre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 23. Mapo Win Tofu → `mapo-win.png`

```text
Image n° 23 — fichier : mapo-win.png
Plat : Mapo tofu, cuisine traditionnelle (Chine).
Dans l'assiette, on doit voir : Sers bien chaud, parsemé de poivre de Sichuan moulu et d'oignons nouveaux émincés, avec beaucoup de riz blanc.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : tofu soyeux ferme, bœuf haché, doubanjiang (pâte de fèves pimentée), haricots noirs fermentés (douchi), hachés, piment en poudre (ou huile pimentée), poivre de Sichuan torréfié et moulu, ail, gingembre frais, bouillon de volaille, sauce soja claire, fécule de maïs, oignons nouveaux, huile neutre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 24. Poulet Teriyaki Win → `teriyaki-win.png`

```text
Image n° 24 — fichier : teriyaki-win.png
Plat : Poulet teriyaki, cuisine traditionnelle (Japon).
Dans l'assiette, on doit voir : Laisse reposer 2 min, coupe en tranches, nappe de sauce et sers sur le riz, parsemé de sésame et d'oignons nouveaux.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : hauts de cuisse de poulet désossés avec la peau (environ 700 g), sauce soja japonaise, mirin, saké, sucre, huile neutre, riz japonais, graines de sésame, oignons nouveaux.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 25. Ramen Win → `ramen-win.png`

```text
Image n° 25 — fichier : ramen-win.png
Plat : Shoyu ramen, cuisine traditionnelle (Japon).
Dans l'assiette, on doit voir : Montage : dans chaque bol chaud, mets 2 c. à soupe de tare, verse 400 ml de bouillon brûlant, ajoute les nouilles, puis le chashu, l'œuf, une feuille de nori et les oignons nouveaux.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : carcasses ou ailes de poulet, eau, carré de kombu (algue séchée, environ 10 cm), champignons shiitake séchés, gingembre frais, ail, oignons nouveaux, poitrine de porc sans os, sauce soja japonaise, mirin, saké, œufs, nouilles ramen fraîches, nori.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 26. Karaage Win → `karaage-win.png`

```text
Image n° 26 — fichier : karaage-win.png
Plat : Karaage, cuisine traditionnelle (Japon).
Dans l'assiette, on doit voir : Égoutte, sale légèrement et sers aussitôt avec des quartiers de citron et la mayonnaise japonaise.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : hauts de cuisse de poulet désossés avec la peau, sauce soja japonaise, saké, gingembre frais, ail, fécule de pomme de terre, huile de friture, citron, mayonnaise japonaise.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 27. Gyo'Win → `gyowin.png`

```text
Image n° 27 — fichier : gyowin.png
Plat : Gyoza, cuisine traditionnelle (Japon).
Dans l'assiette, on doit voir : Pour la sauce, mélange le reste de sauce soja, le vinaigre de riz et l'huile pimentée.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : porc haché, chou chinois (ou chou vert), sel, oignons nouveaux (ou ciboule chinoise), ail, gingembre frais, sauce soja japonaise, saké, huile de sésame, feuilles à gyoza, huile neutre, vinaigre de riz, huile pimentée (la-yu).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 28. Phở Win → `pho-win.png`

```text
Image n° 28 — fichier : pho-win.png
Plat : Phở bò, cuisine traditionnelle (Vietnam).
Dans l'assiette, on doit voir : Dans chaque bol : nouilles, jarret, tranches de bœuf cru, puis verse le bouillon bouillant qui cuit la viande. Sers avec les herbes, les pousses de soja et les quartiers de citron vert à ajouter à table.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : os de bœuf à moelle, jarret de bœuf (ou plat de côtes), oignons, gingembre frais, étoiles de badiane (anis étoilé), bâton de cannelle, clous de girofle, nuoc-mâm (sauce poisson), sucre (idéalement sucre candi), nouilles de riz plates (bánh phở), rumsteck de bœuf, herbes fraîches (basilic thaï, coriandre, oignons nouveaux), pousses de soja, citrons verts.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 29. Bo Bun Win → `bo-bun-win.png`

```text
Image n° 29 — fichier : bo-bun-win.png
Plat : Bún bò Nam Bộ (bo bun), cuisine traditionnelle (Vietnam).
Dans l'assiette, on doit voir : Dans chaque bol : laitue et pousses de soja au fond, vermicelles, bœuf bien chaud, herbes, cacahuètes et échalotes frites. Arrose généreusement de sauce et mélange au moment de manger.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : rumsteck de bœuf en fines lamelles, tiges de citronnelle, ail, échalotes, huile neutre, vermicelles de riz, laitue, pousses de soja, herbes fraîches (menthe, coriandre, basilic thaï), cacahuètes grillées, nuoc-mâm (sauce poisson), sucre, citrons verts, piment rouge frais.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 30. Pad Win Thaï → `pad-win.png`

```text
Image n° 30 — fichier : pad-win.png
Plat : Pad thaï, cuisine traditionnelle (Thaïlande).
Dans l'assiette, on doit voir : Sers avec les cacahuètes, des quartiers de citron vert, quelques pousses de soja crues et du piment en poudre pour ceux qui aiment quand ça pique.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : nouilles de riz plates (3 à 5 mm), crevettes crues décortiquées, tofu ferme, œufs, pâte de tamarin, nuoc-mâm (sauce poisson), sucre de palme (ou cassonade), échalotes, ail, pousses de soja, oignons nouveaux (ou ciboule chinoise), cacahuètes grillées, citrons verts, huile neutre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

### Afrique

#### 31. Tchébou Win → `tchebou-win.png`

```text
Image n° 31 — fichier : tchebou-win.png
Plat : Thiéboudienne (thiébou dieune), cuisine traditionnelle (Sénégal).
Dans l'assiette, on doit voir : Dresse sur un grand plat : le riz en dôme, le poisson au centre, les légumes tout autour, quelques quartiers de citron vert et le bol de bouillon pimenté à côté. Et n'oublie pas le xoon au fond de la marmite !
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poisson ferme en darnes (thiof, mérou, capitaine ou dorade), riz brisé (épicerie africaine ou asiatique), persil plat (pour le roff), ail, piments antillais (scotch bonnet), dont un pour le roff, oignons, concentré de tomate, morceau de guedj et un petit yet (poisson et mollusque fermentés séchés, épicerie africaine), chou vert, en 2 quartiers, carottes, coupées en deux, manioc frais ou surgelé, en tronçons, aubergine, en gros morceaux, navets, gombos, huile d'arachide.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 32. Tchèb Poulet Win → `tcheb-poulet-win.png`

```text
Image n° 32 — fichier : tcheb-poulet-win.png
Plat : Thiébou guinar (thiéb au poulet), cuisine traditionnelle (Sénégal).
Dans l'assiette, on doit voir : Cuis 25 à 30 minutes à feu doux, en remuant une ou deux fois, jusqu'à ce que le riz soit tendre et détaché. Sers le riz en dôme, le poulet et les légumes par-dessus.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier d'environ 1,5 kg, en 8 morceaux, riz brisé, oignons, ail, persil plat, concentré de tomate, carottes, coupées en deux, chou vert, en quartiers, aubergine, en gros morceaux, manioc ou patate douce, en tronçons, piment antillais entier, laurier, cube de bouillon, huile d'arachide.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 33. Maf'Win → `mafwin.png`

```text
Image n° 33 — fichier : mafwin.png
Plat : Mafé, cuisine traditionnelle (Mali).
Dans l'assiette, on doit voir : Le mafé est prêt quand la sauce est nappante et qu'un léger voile d'huile remonte en surface. Retire le piment, rectifie l'assaisonnement et sers bien chaud avec le riz blanc.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf à mijoter en cubes (paleron, gîte) ou un poulet en morceaux, pâte d'arachide 100 % arachide, non sucrée (épicerie africaine), oignons, émincés, ail, écrasées, concentré de tomate, tomates, concassées, carottes, en tronçons, patates douces, en gros cubes, chou vert, en quartiers, piment entier (facultatif), laurier, cube de bouillon, huile d'arachide, riz blanc, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 34. Poulet Yas'Win → `poulet-yaswin.png`

```text
Image n° 34 — fichier : poulet-yaswin.png
Plat : Poulet yassa, cuisine traditionnelle (Sénégal).
Dans l'assiette, on doit voir : Goûte : la sauce doit être acidulée, douce et un peu piquante. Rectifie avec un filet de citron ou une pincée de sel, puis sers bien chaud sur le riz blanc.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier d'environ 1,6 kg, en morceaux, oignons, émincés finement, citrons jaunes ou verts, pressés, moutarde forte, ail, écrasées, piment antillais (entier ou haché selon ton courage), huile d'arachide, laurier, cube de bouillon, olives vertes dénoyautées, riz blanc, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 35. Ravitoto Win → `ravitoto-win.png`

```text
Image n° 35 — fichier : ravitoto-win.png
Plat : Ravitoto sy henakisoa, cuisine traditionnelle (Madagascar).
Dans l'assiette, on doit voir : Sers sur du riz blanc, avec un petit sakay maison (piment pilé avec un peu d'ail, de gingembre, de sel et d'huile) pour ceux qui aiment que ça réveille.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : feuilles de manioc pilées surgelées (« ravitoto », « pondu » ou « saka-saka », épicerie africaine ou asiatique), poitrine ou échine de porc, avec un peu de gras, oignon, émincé, ail, gingembre frais, lait de coco (facultatif, version côtière), huile, petit piment (pour le sakay), riz blanc, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 36. Hena Ritra Win → `hena-ritra-win.png`

```text
Image n° 36 — fichier : hena-ritra-win.png
Plat : Henan'omby ritra au gingembre (bœuf confit malgache), cuisine traditionnelle (Madagascar).
Dans l'assiette, on doit voir : Rectifie l'assaisonnement, parsème de ciboule et sers avec du riz blanc bien chaud.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf à mijoter avec un peu de gras (paleron, jarret, plat de côtes), gingembre frais, ail, oignons, émincés, tomates bien mûres, concassées, huile, ciboule (oignon vert), ciselée, riz blanc, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 37. Romaza'Win → `romazawin.png`

```text
Image n° 37 — fichier : romazawin.png
Plat : Romazava, cuisine traditionnelle (Madagascar).
Dans l'assiette, on doit voir : Rectifie l'assaisonnement et sers dans des bols, avec le riz blanc à part : chacun arrose son riz de bouillon (le « ro ») et pioche viande et brèdes.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf à mijoter (jarret, plat de côtes), en morceaux, brèdes mafana (cresson de Para, épicerie asiatique ou réunionnaise ; sinon cresson), brèdes anamamy (morelle) ou épinards en branches, petsaï (chou chinois) ou bok choy, oignons, émincés, tomates, concassées, ail, gingembre frais, huile, riz blanc, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 38. Foufou Win → `foufou-win.png`

```text
Image n° 38 — fichier : foufou-win.png
Plat : Foufou (fufu) et sa sauce, cuisine traditionnelle (RD Congo).
Dans l'assiette, on doit voir : Façonne le foufou en boules dans un bol mouillé et sers-le avec la sauce bien chaude. Pour manger, prends une petite boule de la main droite, creuse-la avec le pouce et ramasse la sauce.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : farine de manioc pour foufou (ou mélange manioc-maïs), épicerie africaine, eau, pour le foufou, makayabu (poisson salé) ou morue salée, tomates, concassées, concentré de tomate, oignons, émincés, ail, écrasées, poivron vert, en lanières, piment pili-pili, huile de palme ou d'arachide, cube de bouillon.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 39. Pondou Win → `pondou-win.png`

```text
Image n° 39 — fichier : pondou-win.png
Plat : Pondu (saka-saka), cuisine traditionnelle (RD Congo).
Dans l'assiette, on doit voir : Goûte avant de saler (les poissons sont déjà salés), retire le piment et sers bien chaud avec de la chikwangue, du foufou ou du riz.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : feuilles de manioc pilées surgelées (pondu, épicerie africaine), poisson fumé (machoiron, silure ou maquereau fumé), poisson salé (makayabu ou morue), dessalé la veille, aubergines, en cubes, oignons, émincés, ail, écrasées, poivron vert, en dés, huile de palme rouge, piment pili-pili entier, bicarbonate de soude (facultatif, garde les feuilles bien vertes).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 40. Poulet Moambé Win → `moambe-win.png`

```text
Image n° 40 — fichier : moambe-win.png
Plat : Poulet à la moambe, cuisine traditionnelle (RD Congo).
Dans l'assiette, on doit voir : Retire le piment, rectifie l'assaisonnement et sers avec du riz blanc, de la chikwangue ou du foufou, et pourquoi pas un peu de pondu à côté.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier d'environ 1,5 kg, en morceaux, crème de noix de palme de 800 g (« moambe » ou « sauce graine », épicerie africaine), oignons, émincés, ail, écrasées, tomates, concassées, citron, pressé, piment pili-pili entier, laurier, cube de bouillon, huile, riz blanc ou chikwangue, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 41. Tô Win Sauce Gombo → `to-win.png`

```text
Image n° 41 — fichier : to-win.png
Plat : Tô à la sauce gombo, cuisine traditionnelle (Mali).
Dans l'assiette, on doit voir : Moule le tô dans une louche ou un bol mouillé et dépose les dômes dans les assiettes. Nappe de sauce gombo bien chaude et mange à la main droite, en pinçant un morceau de tô pour attraper la sauce.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : farine de mil ou de maïs (épicerie africaine), eau, pour le tô, jus de tamarin ou de citron (pour la tenue du tô), gombos frais ou surgelés, bœuf ou mouton, en morceaux, poisson fumé, émietté, soumbala (graines de néré fermentées, épicerie africaine), oignons, tomates, concassées, piment, bicarbonate de soude (ou potasse), huile d'arachide.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 42. Riz Gras Win → `riz-gras-win.png`

```text
Image n° 42 — fichier : riz-gras-win.png
Plat : Riz gras (zamè), cuisine traditionnelle (Mali).
Dans l'assiette, on doit voir : Sers le riz bien rouge en dôme, la viande et les légumes par-dessus.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf ou mouton en morceaux (ou un poulet), riz long grain ou riz brisé, oignons, émincés, ail, écrasées, concentré de tomate, tomates, concassées, carottes, en tronçons, aubergine, en gros cubes, chou vert, en quartiers, poivron, en lanières, piment entier, laurier, cube de bouillon, huile d'arachide.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 43. Dibi Win → `dibi-win.png`

```text
Image n° 43 — fichier : dibi-win.png
Plat : Dibi (agneau grillé à la sénégalaise), cuisine traditionnelle (Sénégal).
Dans l'assiette, on doit voir : Coupe l'agneau en morceaux, sale légèrement et sers-le sur du papier kraft avec la sauce oignon-moutarde et du pain, pour manger avec les doigts.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : agneau avec os (côtelettes, épaule ou gigot en morceaux), oignons (2 pour la marinade, 2 pour la sauce), ail, poivre noir moulu, cube de bouillon, piment antillais, huile d'arachide, moutarde forte, vinaigre blanc, baguette, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 44. Attiéké Win Poisson Braisé → `attieke-win.png`

```text
Image n° 44 — fichier : attieke-win.png
Plat : Attiéké poisson braisé, cuisine traditionnelle (Côte d'Ivoire).
Dans l'assiette, on doit voir : Sers chaque assiette avec un dôme d'attiéké, un morceau de poisson braisé, la garniture tomate-oignon et un peu de piment écrasé pour les courageux.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poissons entiers d'environ 600 g (tilapia, dorade ou capitaine), écaillés et vidés, attiéké frais ou surgelé (semoule de manioc, épicerie africaine), citrons verts, ail, gingembre frais, persil plat, oignons (1 pour la marinade, 2 pour la garniture), tomates, concombre, piment antillais, cube de bouillon, huile.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 45. Thiou Win → `thiou-win.png`

```text
Image n° 45 — fichier : thiou-win.png
Plat : Thiou (ragoût sénégalais), cuisine traditionnelle (Sénégal).
Dans l'assiette, on doit voir : Retire le piment, rectifie l'assaisonnement et sers sur du riz blanc, avec une bonne louche de sauce.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf à mijoter (paleron), en cubes, oignons, émincés, ail, persil plat (pour le roff), concentré de tomate, tomates, concassées, pommes de terre, en gros morceaux, carottes, en tronçons, poivron vert, en lanières, piment antillais entier, laurier, cube de bouillon, huile d'arachide, riz blanc, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

### Maghreb

#### 46. Couscous Win Royal → `couscous-win-royal.png`

```text
Image n° 46 — fichier : couscous-win-royal.png
Plat : Couscous royal, cuisine traditionnelle (Algérie).
Dans l'assiette, on doit voir : Délaie la harissa dans une louche de bouillon pour les amateurs de piquant. Sers la semoule en dôme, dispose viandes, merguez et légumes dessus, et le bouillon à part dans une soupière.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : semoule de couscous moyenne, hauts de cuisse de poulet, épaule d'agneau en morceaux, merguez, oignons, carottes, navets, courgettes, potiron ou courge butternut, pois chiches cuits (400 g), concentré de tomate, ras el hanout, beurre ou smen, huile d'olive, harissa.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 47. Tajine Win au Poulet → `tajine-win-au-poulet.png`

```text
Image n° 47 — fichier : tajine-win-au-poulet.png
Plat : Tajine de poulet au citron confit et aux olives, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Si la sauce est encore trop liquide, retire le poulet et fais-la réduire quelques minutes à feu vif. Parsème du reste des herbes et sers bien chaud avec du pain marocain (khobz).
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier d'environ 1,5 kg, coupé en 8 morceaux, oignons, ail, gros citron confit (ou 2 petits), olives vertes ou violettes, gingembre moulu, curcuma, pistils de safran, coriandre fraîche, persil plat, huile d'olive, beurre ou smen.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 48. Tajine Kefta Win → `tajine-kefta-win.png`

```text
Image n° 48 — fichier : tajine-kefta-win.png
Plat : Tajine de kefta aux œufs, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Parsème du reste des herbes et sers directement dans le plat, avec du pain pour attraper la sauce. Chacun son coin, chacun son œuf.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf haché (ou moitié bœuf, moitié agneau), oignons, ail, persil plat, coriandre fraîche, cumin moulu, paprika doux, piment de Cayenne, tomates bien mûres (ou 2 boîtes de tomates concassées), œufs, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 49. Tajine Agneau Win → `tajine-agneau-win.png`

```text
Image n° 49 — fichier : tajine-agneau-win.png
Plat : Tajine d'agneau aux pruneaux, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Dresse la viande, nappe-la de sauce, dispose les pruneaux et leur sirop par-dessus, puis parsème d'amandes et de sésame. Sers avec du pain.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : épaule d'agneau avec os, en gros morceaux, oignons, pruneaux dénoyautés, bâton de cannelle, cannelle moulue, gingembre moulu, pistils de safran, miel, amandes émondées, graines de sésame, beurre ou smen, huile d'olive, coriandre fraîche.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 50. Chorba Win → `chorba-win.png`

```text
Image n° 50 — fichier : chorba-win.png
Plat : Chorba frik, cuisine traditionnelle (Algérie).
Dans l'assiette, on doit voir : Sers bien chaud avec des quartiers de citron à presser au dernier moment.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : agneau (collier ou épaule) en petits cubes, frik (blé vert concassé), oignon, tomates mûres, concentré de tomate, pois chiches cuits (400 g), branche de céleri avec ses feuilles, coriandre fraîche, paprika, cannelle moulue, menthe séchée, huile d'olive, citron.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 51. Harira Win → `harira-win.png`

```text
Image n° 51 — fichier : harira-win.png
Plat : Harira, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Sale seulement maintenant, goûte et sers bien chaud avec un quartier de citron et, comme le veut la tradition, quelques dattes à côté.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : agneau ou bœuf en petits cubes, lentilles vertes ou brunes, pois chiches secs trempés la veille (ou 1 boîte de 400 g), oignon, branche de céleri, coriandre fraîche, persil plat, tomates mûres, concentré de tomate, vermicelles, farine, gingembre moulu, curcuma, smen ou beurre, citron.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 52. Loubia Win → `loubia-win.png`

```text
Image n° 52 — fichier : loubia-win.png
Plat : Loubia (haricots blancs en sauce), cuisine traditionnelle (Algérie).
Dans l'assiette, on doit voir : Ajoute le reste du cumin et les herbes ciselées, arrose d'un filet d'huile d'olive et sers avec du pain bien frais.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : haricots blancs secs (lingots ou cocos), oignon, ail, tomates concassées (400 g), concentré de tomate, cumin moulu, paprika, piment de Cayenne, laurier, huile d'olive, coriandre ou persil.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 53. Chakchouka Win → `chakchouka-win.png`

```text
Image n° 53 — fichier : chakchouka-win.png
Plat : Chakchouka, cuisine traditionnelle (Tunisie).
Dans l'assiette, on doit voir : Sers directement dans la poêle avec du pain pour saucer. Ici, la fourchette est facultative.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poivrons verts ou rouges, piment vert, oignon, ail, tomates mûres, concentré de tomate, harissa, carvi moulu (karwiya), paprika, œufs, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 54. Zaalouk Win → `zaalouk-win.png`

```text
Image n° 54 — fichier : zaalouk-win.png
Plat : Zaalouk d'aubergines, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Hors du feu, ajoute le jus de citron et le reste de l'huile d'olive. Sers tiède ou froid, avec du pain pour tartiner.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : grosses aubergines (environ 800 g), tomates mûres, ail, cumin moulu, paprika, piment de Cayenne, coriandre fraîche, persil plat, huile d'olive, citron (le jus).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 55. Rfissa Win → `rfissa-win.png`

```text
Image n° 55 — fichier : rfissa-win.png
Plat : Rfissa au poulet, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Étale les msemen dans un grand plat creux, arrose-les généreusement de bouillon, puis dépose le poulet, les oignons, les lentilles et le fenugrec par-dessus. Sers bien chaud, avec un bol de bouillon supplémentaire pour les gourmands.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier d'environ 1,5 kg, coupé en morceaux, oignons, ail, lentilles vertes ou brunes, graines de fenugrec (helba), ras el hanout, gingembre moulu, pistils de safran, coriandre et persil mélangés, msemen (crêpes feuilletées, faites maison ou achetées), smen ou beurre, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 56. Brik Win au Thon → `brik-win-au-thon.png`

```text
Image n° 56 — fichier : brik-win-au-thon.png
Plat : Brik à l'œuf et au thon, cuisine traditionnelle (Tunisie).
Dans l'assiette, on doit voir : Recommence avec les autres feuilles, une à une, et sers aussitôt avec des quartiers de citron.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : brick (malsouka), œufs, thon à l'huile (environ 160 g), pomme de terre cuite à l'eau, oignon, câpres, persil plat, harissa (facultatif), huile de friture, citron.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 57. Méchoui Win → `mechoui-win.png`

```text
Image n° 57 — fichier : mechoui-win.png
Plat : Méchoui d'agneau (épaule au four, version maison), cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Laisse reposer 10 minutes, puis effiloche la viande à la main ou à la fourchette. Sers avec le mélange cumin-sel pour tremper chaque bouchée, du pain et une salade de tomates.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : épaule d'agneau avec os (environ 2 kg), beurre mou ou smen, ail, cumin moulu, paprika doux, coriandre moulue, pistils de safran, eau, cumin et sel fin mélangés, pour servir.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 58. M'derbel Win → `mderbel-win.png`

```text
Image n° 58 — fichier : mderbel-win.png
Plat : M'derbel d'aubergines, cuisine traditionnelle (Algérie).
Dans l'assiette, on doit voir : Parsème de persil haché et sers chaud, tiède ou froid, avec du pain.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : aubergines, tomates mûres, ail, concentré de tomate, carvi moulu (karwiya), paprika, piment de Cayenne, vinaigre de vin, persil plat, huile de friture, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 59. Berkoukes Win → `berkoukes-win.png`

```text
Image n° 59 — fichier : berkoukes-win.png
Plat : Berkoukes aux légumes, cuisine traditionnelle (Algérie).
Dans l'assiette, on doit voir : Laisse reposer 5 minutes à couvert et sers bien chaud, avec un peu de harissa ou de piment pour ceux qui aiment.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : berkoukes (gros couscous, aussi appelé plombs), oignon, ail, carottes, courgettes, pomme de terre, tomates mûres, pois chiches cuits (400 g), concentré de tomate, paprika, ras el hanout, piment de Cayenne, menthe séchée, coriandre fraîche, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 60. Tajine Sardin'Win → `tajine-sardinwin.png`

```text
Image n° 60 — fichier : tajine-sardinwin.png
Plat : Tajine de boulettes de sardines, cuisine traditionnelle (Maroc).
Dans l'assiette, on doit voir : Sers directement dans le tajine avec du pain et quelques rondelles de citron.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : sardines fraîches (ou 600 g de filets), coriandre fraîche, persil plat, ail, cumin moulu, paprika doux, piment de Cayenne, citron, riz rond cuit, oignon, tomates mûres, huile d'olive.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

### France

#### 61. Bœuf Bourguignon Win → `bourguignon-win.png`

```text
Image n° 61 — fichier : bourguignon-win.png
Plat : Bœuf bourguignon, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Retire le bouquet garni, rectifie le sel et le poivre. Si la sauce est trop liquide, fais-la réduire quelques minutes à découvert. Sers avec des pommes de terre vapeur ou des pâtes fraîches.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : bœuf à braiser (paleron, macreuse ou joue), en cubes de 5 cm, vin rouge de Bourgogne (pinot noir), bouillon de bœuf, lardons fumés, champignons de Paris, oignons, carottes, ail, farine, huile neutre, beurre, garni (thym, laurier, persil).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 62. Pot-au-Win → `pot-au-win.png`

```text
Image n° 62 — fichier : pot-au-win.png
Plat : Pot-au-feu, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Dispose viandes et légumes dans un grand plat, arrose d'un peu de bouillon. Sers le bouillon filtré à part en entrée, avec la moutarde, les cornichons et le gros sel sur la table.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : plat de côtes de bœuf, paleron ou gîte de bœuf, tronçons d'os à moelle, carottes, poireaux, navets, branches de céleri, oignon piqué de 3 clous de girofle, garni (thym, laurier, persil), pommes de terre à chair ferme, gros sel, poivre en grains.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 63. Coq au Win → `coq-au-win.png`

```text
Image n° 63 — fichier : coq-au-win.png
Plat : Coq au vin, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Ajoute cette garniture dans la cocotte pour les 15 dernières minutes. Rectifie l'assaisonnement et fais réduire la sauce à découvert si elle est trop liquide. Sers avec des pommes vapeur ou des tagliatelles.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : coq ou gros poulet fermier (environ 2,5 kg), découpé en 8 morceaux, vin rouge corsé (bourgogne), lardons fumés, champignons de Paris, petits oignons grelots, carottes, oignon, ail, farine, cognac, beurre, garni (thym, laurier, persil).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 64. Blanquette Win → `blanquette-win.png`

```text
Image n° 64 — fichier : blanquette-win.png
Plat : Blanquette de veau, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Remets la viande, les carottes et les champignons dans la sauce, réchauffe doucement 5 min et rectifie sel et poivre. Sers avec du riz blanc.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : veau (épaule, tendron et flanchet), en morceaux, carottes, oignon piqué de 2 clous de girofle, blanc de poireau, garni (thym, laurier, persil), champignons de Paris, beurre, farine, jaunes d'œufs, crème fraîche épaisse, citron (le jus).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 65. Hachis Parmen'Win → `hachis-parmenwin.png`

```text
Image n° 65 — fichier : hachis-parmenwin.png
Plat : Hachis parmentier, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Parsème de gruyère et du reste de beurre en noisettes. Enfourne 20 min, puis passe 2 à 3 min sous le gril pour une croûte bien dorée.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : pommes de terre farineuses (type bintje), bœuf haché (ou restes de pot-au-feu effilochés), oignons, ail, concentré de tomate, persil plat, lait entier, beurre, gruyère râpé, huile, noix de muscade râpée.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 66. Gratin Dauphin'Win → `gratin-dauphinwin.png`

```text
Image n° 66 — fichier : gratin-dauphinwin.png
Plat : Gratin dauphinois, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Enfourne pour 1 h à 1 h 10, jusqu'à ce que le dessus soit bien doré et que la lame d'un couteau traverse sans effort. Laisse reposer 10 min avant de servir.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : pommes de terre (type bintje ou monalisa), lait entier, crème liquide entière, ail, beurre, noix de muscade râpée.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 67. Cassoulet Win → `cassoulet-win.png`

```text
Image n° 67 — fichier : cassoulet-win.png
Plat : Cassoulet, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Sers bien chaud, directement dans la cassole, avec une salade verte pour la bonne conscience.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : haricots lingots ou tarbais secs, cuisses de canard confites, coupées en deux, saucisse de Toulouse, échine de porc, couenne de porc, oignon, carottes, ail, garni (thym, laurier, persil), concentré de tomate, graisse de canard.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 68. Tartiflette Win → `tartiflette-win.png`

```text
Image n° 68 — fichier : tartiflette-win.png
Plat : Tartiflette, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Enfourne 20 à 25 min, jusqu'à ce que le fromage soit fondu et bien doré. Sers avec une salade verte et de la charcuterie, et prévois une petite marche digestive.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : pommes de terre à chair ferme, reblochon fermier (environ 450 g), lardons fumés, oignons, vin blanc sec de Savoie, crème fraîche épaisse (facultatif), gousse d'ail, beurre.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 69. Ratatouille Win → `ratatouille-win.png`

```text
Image n° 69 — fichier : ratatouille-win.png
Plat : Ratatouille, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Retire le thym et le laurier, rectifie sel et poivre, puis ajoute le basilic ciselé et un filet d'huile d'olive crue au moment de servir. Délicieuse chaude, tiède ou froide le lendemain.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : aubergines, courgettes, poivrons rouges, poivron jaune, oignons, tomates bien mûres, ail, huile d'olive, thym, laurier, basilic.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 70. Choucroute Win → `choucroute-win.png`

```text
Image n° 70 — fichier : choucroute-win.png
Plat : Choucroute garnie, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Dresse la choucroute en dôme sur un grand plat et entoure-la des viandes tranchées, des saucisses et des pommes de terre. Moutarde obligatoire.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : choucroute crue, palette de porc fumée, poitrine de porc fumée, saucisses de Montbéliard, saucisses de Strasbourg, pommes de terre à chair ferme, oignons, saindoux ou graisse d'oie, vin blanc sec d'Alsace (riesling ou sylvaner), baies de genièvre, laurier, clous de girofle, poivre en grains.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 71. Navarin Win d'Agneau → `navarin-win.png`

```text
Image n° 71 — fichier : navarin-win.png
Plat : Navarin d'agneau, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Ajoute les petits pois pour les 10 dernières minutes. Retire le bouquet garni, dégraisse la sauce à la cuillère, rectifie l'assaisonnement et sers directement dans la cocotte.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : agneau (épaule et collier), en morceaux, huile, oignon, ail, farine, concentré de tomate, bouillon de volaille ou fond brun, garni (thym, laurier, persil), carottes nouvelles, navets nouveaux, pommes de terre grenaille, petits pois (frais ou surgelés).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 72. Poulet Basquaise Win → `poulet-basquaise-win.png`

```text
Image n° 72 — fichier : poulet-basquaise-win.png
Plat : Poulet basquaise, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Retire le couvercle pour les 10 dernières minutes afin de faire réduire la sauce. Rectifie le sel et le piment, et sers avec du riz blanc.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : poulet fermier (environ 1,8 kg), découpé en 8 morceaux, poivrons (rouges et verts), oignons, tomates bien mûres (ou 1 boîte de 800 g de tomates pelées), ail, jambon de Bayonne, vin blanc sec, huile d'olive, piment d'Espelette, garni (thym, laurier, persil).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 73. Moules-Frites Win → `moules-frites-win.png`

```text
Image n° 73 — fichier : moules-frites-win.png
Plat : Moules-frites, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Sers les moules dans leur jus avec les frites à côté. Astuce de pro : utilise une coquille vide comme pince pour attraper les autres.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : moules de bouchot, échalotes, vin blanc sec, beurre, persil plat, thym, feuille de laurier, pommes de terre (type bintje), huile d'arachide (pour la friture).
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 74. Croque-Win Monsieur → `croque-win.png`

```text
Image n° 74 — fichier : croque-win.png
Plat : Croque-monsieur, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Enfourne 8 à 10 min, jusqu'à ce que le dessus soit gratiné et bien doré. Attention au premier coup de dent : le fromage fondu ne fait pas de cadeau.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : pain de mie, jambon blanc, comté ou emmental râpé, beurre mou (pour le pain), beurre (pour la béchamel), farine, lait, noix de muscade râpée.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```

#### 75. Quiche Win Lorraine → `quiche-win.png`

```text
Image n° 75 — fichier : quiche-win.png
Plat : Quiche lorraine, cuisine traditionnelle (France).
Dans l'assiette, on doit voir : Laisse tiédir 10 min avant de découper. Et pas de gruyère dedans : en Lorraine, c'est un sujet sensible, je ne veux pas d'histoires.
Ingrédients de la recette (montre seulement ceux qui se voient dans le plat fini) : farine, beurre froid, en dés, eau froide, sel, lardons fumés, œufs, crème fraîche épaisse, lait entier, noix de muscade râpée.
Rappel : aucun texte, aucun personnage, une seule assiette centrée, style identique aux autres images, image nette au format paysage.
```
