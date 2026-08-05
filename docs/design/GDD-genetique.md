> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Sélection génétique animale

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-elevage.md` §9, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`, `decisions/ADR-003-expert-nest-pas-plus-rentable.md`

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

La génétique est **LE système de progression long terme** d'Agriva. Là où les cultures rapportent en quelques mois et le matériel s'achète en un clic, la génétique demande **5 à 10 ans de jeu** pour construire un troupeau d'élite. C'est l'équivalent d'un "endgame" pour l'éleveur.

**Ce qui rend la génétique gratifiante** :
1. **La patience récompensée** — chaque génération est un peu meilleure que la précédente
2. **L'identité du troupeau** — le joueur construit SES lignées, reconnaissables
3. **La fierté** — montrer son ISU moyen de troupeau, vendre des génisses d'élite
4. **La stratégie** — choisir entre production, santé, morphologie, longévité
5. **L'irréversibilité partielle** — les choix génétiques d'aujourd'hui se voient dans 3 ans

**Ce que SimAgri fait bien (IVRAD)** : indices génétiques par animal, objectifs collectifs par race, places limitées → compétition, concours d'élevage. Système apprécié, moteur de jeu long terme.

**Ce qu'Agriva améliore** : index réalistes (ISU, INEL, IVMAT), formule de transmission transparente, génomique comme outil expert, consanguinité modélisée, semence sexée, catalogue CIA avec profils variés.

### 1.2 Gameplay loop génétique

```
MENSUEL : Choisir taureau → Inséminer → Naissance (index parents/2 + aléa)
ANNUEL  : Évaluer troupeau → Réformer les pires → Garder les meilleurs veaux
          → ISU moyen +1,5 à +2,5 points/an
LONG TERME (3-10 ans) : Lignées d'élite → Vente génisses → Concours IVRAD
                        → Troupeau reconnu sur le serveur
```

### 1.3 Décisions du joueur

| Décision | Fréquence | Mode | Impact |
|----------|:---------:|:----:|--------|
| Choix du taureau (catalogue CIA) | Chaque IA | Normal + Expert | Oriente la génétique future |
| Garder ou vendre un veau femelle | Chaque naissance | Normal + Expert | Renouvellement vs revenu immédiat |
| Réformer une vache à faible index | Annuel | Normal + Expert | Libère une place pour une meilleure |
| Génotyper un animal | Ponctuel | Expert | Précision accrue de l'index |
| Utiliser de la semence sexée | Chaque IA | Expert | Maximise les femelles nées |
| Plan d'accouplement raisonné | Annuel | Expert | Évite consanguinité, optimise croisement |
| Participer au programme IVRAD | Annuel | Normal + Expert | Objectifs collectifs, concours |

### 1.4 Différence Normal / Expert

| Aspect | Mode Normal | Mode Expert |
|--------|-------------|-------------|
| Affichage génétique | Étoiles ★★★☆☆ (1-5) | Tous les index chiffrés (ISU, INEL, etc.) |
| Choix taureau | "Bon / Très bon / Excellent" | Index détaillés + profil |
| Transmission | "Votre veau est meilleur/moins bon" | Formule visible, aléa quantifié |
| Génomique | Indisponible | Génotypage 50€, précision 70-80% |
| Consanguinité | Alerte automatique si trop proche | Coefficient affiché, arbre généalogique |
| Accouplement | Automatique (meilleur taureau dispo) | Plan personnalisé, croisement raisonné |
| Semence sexée | Disponible (bouton simple) | Stratégie optimale expliquée |
| IVRAD | Objectifs simplifiés, concours | Objectifs détaillés par index, classement |

---

## 2. Les index génétiques

### 2.1 Principe général

Chaque animal possède des **index génétiques** qui quantifient son potentiel par rapport à la moyenne de sa race. L'échelle est centrée sur **100 = moyenne de la race**. Un animal à 120 en lait produit potentiellement 20% au-dessus de la moyenne raciale.

**En mode Normal** : un seul indice global visible sous forme d'étoiles.

| Étoiles | Plage d'index global | Signification |
|:-------:|:-------------------:|---------------|
| ★☆☆☆☆ | 70-84 | Faible |
| ★★☆☆☆ | 85-94 | Sous la moyenne |
| ★★★☆☆ | 95-104 | Moyenne |
| ★★★★☆ | 105-114 | Bon |
| ★★★★★ | 115+ | Excellent |

**En mode Expert** : tous les index détaillés sont visibles et manipulables.

### 2.2 Bovin laitier

| Index | Nom complet | Poids dans ISU | Ce qu'il mesure |
|-------|-------------|:--------------:|-----------------|
| **ISU** | Index Synthèse Unique | — (synthèse) | Performance globale de l'animal |
| **INEL** | Index Économique Laitier | 50% | Rentabilité laitière (lait + TB + TP) |
| **Lait** | Production laitière | — (dans INEL) | kg de lait supplémentaires/lactation |
| **TB** | Taux Butyreux | — (dans INEL) | g/L de matière grasse |
| **TP** | Taux Protéique | — (dans INEL) | g/L de protéines |
| **MO** | Morphologie | 15% | Aplombs, mamelle, format |
| **CEL** | Cellules somatiques | 10% | Résistance aux mammites |
| **FER** | Fertilité | 15% | Facilité de reproduction |
| **LGV** | Longévité | 10% | Durée de vie productive |

**Formule ISU** :
```
ISU = 0.50 × INEL + 0.15 × MO + 0.10 × CEL + 0.15 × FER + 0.10 × LGV
```

### 2.3 Bovin viande

| Index | Nom complet | Ce qu'il mesure |
|-------|-------------|-----------------|
| **IVMAT** | Index de Valeur Maternelle | Aptitudes maternelles globales |
| **ISEVR** | Index au Sevrage | Performance bouchère au sevrage |
| **CRO** | Croissance | GMQ (gain moyen quotidien) |
| **FNais** | Facilité de naissance | % de vêlages faciles |
| **DM** | Développement musculaire | Conformation bouchère |
| **ALait** | Aptitude laitière | Lait maternel pour le veau |

### 2.4 Porc

| Index | Nom complet | Ce qu'il mesure |
|-------|-------------|-----------------|
| **IC** | Indice de Consommation | kg aliment / kg gain |
| **GMQ** | Gain Moyen Quotidien | Vitesse de croissance (g/jour) |
| **TMP** | Taux de Muscle des Pièces | % de viande maigre dans la carcasse |
| **PROL** | Prolificité | Nombre de porcelets nés vivants/portée |

### 2.5 Ovin

| Index | Nom complet | Ce qu'il mesure |
|-------|-------------|-----------------|
| **PROL** | Prolificité | Agneaux nés/portée |
| **VL** | Valeur Laitière | Production laitière maternelle |
| **ABo** | Aptitudes Bouchères | Conformation + croissance agneau |

### 2.6 Caprin

| Index | Nom complet | Ce qu'il mesure |
|-------|-------------|-----------------|
| **LAIT** | Production laitière | kg de lait/lactation |
| **TB** | Taux Butyreux | g/L de matière grasse |
| **TP** | Taux Protéique | g/L de protéines |
| **MMA** | Morphologie Mamelle | Attaches, forme, traite facilitée |

---

## 3. Transmission génétique

### 3.1 Formule de base

```
index_descendant = (index_mère + index_père) / 2 + aléa
```

**Amplitude de l'aléa** : distribution normale (gaussienne) centrée sur 0.

```
aléa ~ N(0, σ²)
σ = 5 points d'index (écart-type)
```

**En pratique** :
- 68% des veaux : parent ± 5 points
- 95% des veaux : parent ± 10 points
- 99,7% des veaux : parent ± 15 points

### 3.2 Exemple chiffré

```
Mère ISU 112 + Père ISU 125 → Moyenne parentale = 118,5
Veau : 118,5 + aléa (σ=5) → résultat probable entre 113,5 et 123,5 (68%)
```

### 3.3 Transmission des sous-index (mode Expert)

Chaque sous-index (INEL, MO, CEL, FER, LGV) est transmis indépendamment avec le même aléa σ=5. L'ISU est recalculé à partir des sous-index selon la formule §2.2.

### 3.4 Modificateurs

| Condition | Effet sur l'aléa |
|-----------|:-----------------:|
| Consanguinité > 6,25% | σ passe de 5 à 7 (plus de variance) |
| Génotypage des 2 parents | σ passe de 5 à 3 (moins de variance, plus prévisible) |
| Croisement inter-races | σ passe de 5 à 8 (forte variance, vigueur hybride possible) |

### 3.5 Affichage en mode Normal

Le joueur voit : "Votre veau a hérité d'un bon potentiel ! ★★★★☆". Pas de formule, pas de chiffres — juste le résultat en étoiles avec un commentaire encourageant.


---

## 4. Catalogue de reproducteurs (CIA)

### 4.1 Principe

Le joueur accède à un **catalogue de taureaux** (Centre d'Insémination Artificielle) pour acheter des doses de semence. Chaque taureau a un profil d'index, un prix, et une disponibilité.

Le catalogue est **commun à tout le serveur** et rafraîchi mensuellement (rotation de 30% des taureaux).

### 4.2 Gammes de prix (bovin laitier)

| Gamme | Prix/dose | Profil | ISU typique |
|-------|:---------:|--------|:-----------:|
| Standard | 15-25 € | Taureaux confirmés, index moyens | 100-110 |
| Génomique | 30-60 € | Jeunes taureaux génotypés, prometteurs | 110-125 |
| Élite | 50-90 € | Top 5% national, index élevés | 125-145 |
| Sexée standard | 51-61 € | Standard + tri spermatique | 100-110 |
| Sexée élite | 86-156 € | Élite + tri spermatique | 125-145 |

### 4.3 Gammes de prix (autres espèces)

| Espèce | Standard | Génomique/Amélioré | Élite |
|--------|:--------:|:---------:|:-----:|
| Bovin viande | 10-20 € | 20-40 € | 40-80 € |
| Porc | 3-8 € | 10-20 € | 20-30 € |
| Ovin | 10-20 € | 20-35 € | 35-50 € |
| Caprin | 10-20 € | 20-35 € | 30-45 € |
| Cheval (saillie) | 200-2 000 € | 2 000-5 000 € | 5 000-15 000 € |

### 4.4 Mockup — Catalogue CIA (mode Expert)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🐄 CATALOGUE CIA — Holstein           [Filtrer ▼] [Trier par ISU ▼]   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─── SPOTLIGHT ────────────────────────────────────────────────────┐   │
│  │ 🏆 REDON (FR7712345678)          ISU 142 │ Élite │ 85€/dose     │   │
│  │    INEL +38  MO +1.2  CEL +1.8  FER +0.6  LGV +1.1             │   │
│  │    Lait +980 kg  TB -1.2 g/L  TP +1.8 g/L                      │   │
│  │    ⚠️ Consanguinité 4.2% avec votre troupeau                    │   │
│  │    [Voir fiche] [Acheter 1 dose] [Ajouter au plan]              │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  NOM              ISU   INEL   MO   CEL   FER   LGV   PRIX    STOCK   │
│  ─────────────────────────────────────────────────────────────────────  │
│  REDON            142   +38   +1.2  +1.8  +0.6  +1.1   85€    12     │
│  PACTOLE          138   +35   +1.5  +1.2  +1.0  +0.8   72€    18     │
│  IBERIC           131   +28   +2.1  +0.9  +0.4  +1.4   58€    25     │
│  JOYAU            125   +24   +1.0  +1.5  +1.2  +0.6   45€    30     │
│  MAESTRO          118   +20   +0.8  +0.6  +1.5  +1.0   32€    50     │
│  FESTIVAL         112   +16   +0.5  +0.4  +0.8  +0.9   22€    80     │
│  DELTA            105   +12   +0.3  +0.2  +0.5  +0.4   18€    99+    │
│  ─────────────────────────────────────────────────────────────────────  │
│  📋 7 taureaux disponibles │ Prochain renouvellement : 12 jours        │
│                                                                         │
│  [← Page 1/3 →]                    [Sexée +36€] [Mon historique]       │
└─────────────────────────────────────────────────────────────────────────┘
```

### 4.5 Mockup — Catalogue CIA (mode Normal)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🐄 CHOISIR UN TAUREAU               [Race: Holstein ▼]                │
├─────────────────────────────────────────────────────────────────────────┤
│  ⭐ RECOMMANDÉ pour votre troupeau :                                   │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  🥇 PACTOLE — Très bon taureau         72€/dose                 │   │
│  │     Qualité : ★★★★★   Points forts : Lait ++, Mamelle +         │   │
│  │     [Inséminer avec ce taureau]                                  │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│  🐂 JOYAU        ★★★★☆  Bon taureau          45€    [Choisir]        │
│  🐂 MAESTRO      ★★★★☆  Bon taureau          32€    [Choisir]        │
│  🐂 FESTIVAL     ★★★☆☆  Taureau correct      22€    [Choisir]        │
│  🐂 DELTA        ★★★☆☆  Taureau standard     18€    [Choisir]        │
│                                                                         │
│  💡 Plus cher = meilleure génétique = plus de lait à terme.            │
│  ☑️ Semence sexée (+36€, 90% de femelles)    [En savoir plus]          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Génomique (Expert)

### 5.1 Principe

Le **génotypage** est un test ADN qui permet de prédire les index d'un animal dès sa naissance, sans attendre ses performances réelles (lactation, descendance).

**Sans génomique** : l'index d'un veau est une estimation basée sur ses parents. Précision : **30-40%**.
**Avec génomique** : le test ADN révèle le potentiel réel de l'animal. Précision : **70-80%**.

### 5.2 Mécaniques

| Paramètre | Valeur |
|-----------|:------:|
| Coût génotypage | 50 € / animal |
| Âge minimum | Dès la naissance |
| Délai résultat | 7 jours in-game |
| Précision avant génotypage | 30-40% (estimation parentale) |
| Précision après génotypage | 70-80% (valeur ADN) |

### 5.3 Effet mécanique

Sans génomique, l'index affiché = moyenne parentale (précision 35%). L'index réel est caché jusqu'à la première lactation. Après génotypage, l'index affiché se rapproche du réel (précision 75%). Le joueur peut ainsi trier ses génisses à la naissance au lieu d'attendre 3 ans.

### 5.4 Stratégie d'utilisation

- Génotyper les **femelles** à la naissance pour choisir celles à garder
- Génotyper avant de **vendre** une génisse d'élite (justifie un prix premium)
- **Ne PAS** génotyper les mâles destinés à l'abattoir (inutile)
- Rentable si la différence de valeur garder/vendre > 50€

### 5.5 Disponibilité

- Mode Normal : indisponible (le joueur n'a que les étoiles)
- Mode Expert : accessible dès le début, mais coûteux pour un débutant

---

## 6. Semence sexée

### 6.1 Principe

La semence sexée est un tri spermatique permettant de choisir le sexe du veau. En bovin laitier, on veut des **femelles** (futures productrices). En bovin viande, on peut vouloir des **mâles** (meilleur GMQ).

### 6.2 Paramètres

| Paramètre | Semence conventionnelle | Semence sexée |
|-----------|:-----------------------:|:-------------:|
| Surcoût | — | +36 € / dose |
| Taux réussite IA | 40-50% | 32-42% (-8 points) |
| % femelles | 50% | 90% |
| % mâles | 50% | 10% |

### 6.3 Calcul de rentabilité (bovin laitier)

```
Sans sexée : dose 45€, réussite 45% → coût/gestation 100€ → 50% femelles → 200€/génisse
Avec sexée : dose 81€, réussite 37% → coût/gestation 219€ → 90% femelles → 243€/génisse

Surcoût par génisse : +43€
Veau mâle laitier ≈ 60€ vs génisse renouvellement ≈ 1200€
→ TOUJOURS rentable en laitier pour les meilleures vaches du troupeau.
```

### 6.4 Stratégie

Utiliser la sexée sur les **30-40% meilleures vaches** (renouvellement par le haut). Conventionnelle sur le reste. Éviter sur les primipares (taux réussite déjà faible).


---

## 7. Accouplement raisonné (Expert)

### 7.1 Principe

L'accouplement raisonné consiste à **choisir le taureau optimal pour chaque vache**, en tenant compte :
1. Des forces/faiblesses de la vache (compenser ses défauts)
2. De la consanguinité (éviter les ancêtres communs)
3. De l'objectif de sélection du joueur (production vs fonctionnel)

### 7.2 Mécanique

En mode Expert, le joueur peut créer un **plan d'accouplement** :

| Vache | ISU | Point faible | Taureau recommandé | Raison |
|-------|:---:|:------------:|:------------------:|--------|
| CAPUCINE | 108 | CEL -0.5 | REDON (CEL +1.8) | Compense les cellules |
| FLEURETTE | 115 | MO -0.8 | IBERIC (MO +2.1) | Améliore la morphologie |
| JADE | 102 | FER -1.2 | MAESTRO (FER +1.5) | Corrige la fertilité |

### 7.3 Algorithme de recommandation

Le jeu propose automatiquement un taureau si le joueur le demande :

```python
def recommander_taureau(vache, catalogue, troupeau):
    for taureau in catalogue:
        score = (vache.ISU + taureau.ISU) / 2           # potentiel du veau
        score -= penalite_consanguinite(vache, taureau)  # -20 si F>6.25%
        score += bonus_complementarite(vache, taureau)   # compense faiblesses
    return top_3_par_score
```

En mode Normal : le jeu affecte automatiquement le "meilleur taureau dans le budget" sans intervention du joueur.

---

## 8. Consanguinité (Expert)

### 8.1 Coefficient de consanguinité

Chaque animal possède un **coefficient de consanguinité (F)** calculé sur 5 générations d'ascendance. Plus deux animaux partagent d'ancêtres communs, plus le F de leur descendant est élevé.

**Exemples** : demi-frères = F descendant ~6,25%. Cousins germains = F ~3,12%. Aucun ancêtre commun = F 0%.

### 8.2 Seuils et effets

| Coefficient F | Signification | Effet in-game |
|:-------------:|:-------------:|---------------|
| 0-3% | Normal | Aucun effet |
| 3-6,25% | Surveillance | Avertissement affiché |
| 6,25-12,5% | Élevé | Pénalités modérées |
| >12,5% | Critique | Pénalités sévères |

### 8.3 Effet concret

Un animal avec F = 10% subit (10 - 6,25) = 3,75 points au-dessus du seuil → fertilité -7,5%, longévité -11%, production -5,6%. Très pénalisant.

### 8.4 Comment éviter la consanguinité

1. **Varier les taureaux** : ne pas utiliser le même taureau plus de 2-3 ans
2. **Acheter des génisses extérieures** : sang neuf provenant d'autres joueurs
3. **Consulter l'arbre** : le jeu affiche les ancêtres communs avant insémination
4. **Crossbreeding** : croiser 2 races (F = 0% garanti, mais perte d'index race pure)

### 8.5 Affichage

- **Mode Normal** : alerte rouge si le joueur tente un croisement consanguin (>6,25%). "⚠️ Ces deux animaux sont trop proches ! Choisissez un autre taureau."
- **Mode Expert** : coefficient F affiché sur chaque animal + prédiction F du futur veau avant validation de l'IA.

---

## 9. Le système IVRAD

### 9.1 Reprise et amélioration de SimAgri

L'IVRAD (Indexation et Valorisation des Races par l'Amélioration Durable) est le programme collectif de sélection génétique. Il donne un **objectif à long terme** à chaque éleveur en l'inscrivant dans un effort collectif d'amélioration de la race.

**Ce qui est repris de SimAgri** :
- Objectifs Génétiques (OG) par race
- Places IVRAD limitées (compétition entre joueurs)
- Concours d'élevage liés à la génétique
- Progression visible sur le long terme

**Ce qu'Agriva améliore** :
- Objectifs par INDEX (pas par indice abstrait) — ISU, IVMAT, etc.
- Récompenses progressives (pas binaire "atteint/pas atteint")
- Races à développer avec bonus pour les races menacées
- Concours avec classement permanent + événements saisonniers

### 9.2 Objectifs Génétiques par race

Chaque race a un **Objectif Génétique (OG)** fixé pour Année 5 et Année 10 du serveur. Atteindre l'OG débloque un bonus de +5% sur le prix de vente des génisses.

| Race (exemple laitier) | OG Année 5 | OG Année 10 |
|-------------------------|:----------:|:-----------:|
| Prim'Holstein | ISU 112 | ISU 122 |
| Montbéliarde | ISU 110 | ISU 118 |
| Normande | ISU 108 | ISU 115 |
| Races mineures | ISU 106 | ISU 112 |

### 9.3 Places IVRAD

Chaque race dispose d'un **nombre limité de places IVRAD** sur le serveur. Obtenir une place = être reconnu comme éleveur de référence de cette race.

| Taille serveur | Places/race (races majeures) | Places/race (races mineures) |
|:--------------:|:---------------------------:|:---------------------------:|
| <100 joueurs | 5 | 3 |
| 100-500 joueurs | 15 | 8 |
| >500 joueurs | 30 | 15 |

**Critères d'attribution** (réévaluation mensuelle) :
1. ISU moyen du troupeau dans la race (top N joueurs)
2. Minimum 10 femelles de la race en production
3. Participation active (au moins 5 naissances/an dans la race)

### 9.4 Races à développer

Les races menacées bénéficient de bonus pour encourager leur élevage :
- **Races régionales** (Abondance, Salers lait) : +10% valorisation génisses
- **Races menacées** (Vosgienne, Pie Rouge des Plaines) : +15% valorisation + subvention 200€/femelle/an
- **Races conservation** (Villard-de-Lans, Froment du Léon) : +20% valorisation + subvention 300€/femelle/an

### 9.5 Concours d'élevage

| Type | Fréquence | Critères | Récompense |
|------|:---------:|----------|:----------:|
| Concours mensuel (serveur) | Mensuel | ISU moyen troupeau | Badge + visibilité |
| Grand concours de race | Trimestriel | Meilleur animal présenté | 500-2000€ + titre |
| Championnat annuel | Annuel | Top 3 ISU toutes races | 5000€ + trophée permanent |
| Challenge IVRAD | Annuel | Progression ISU sur l'année | 3000€ + place IVRAD garantie 1 an |

### 9.6 Résumé IVRAD Normal/Expert

En Normal : le joueur voit "Améliorer vos étoiles", participe automatiquement aux concours, reçoit des encouragements. En Expert : OG chiffrés par index, classement détaillé, choix stratégique de l'animal présenté en concours, subventions races rares visibles.


---

## 10. Valorisation économique

### 10.1 Vendre des génisses d'élite

Le joueur qui améliore sa génétique peut **vendre ses excédents** à d'autres joueurs à prix premium.

| ISU de la génisse | Prix de vente marché joueur | Comparaison achat standard |
|:-----------------:|:---------------------------:|:--------------------------:|
| 95-104 (★★★☆☆) | 800-1 000 € | Prix normal |
| 105-114 (★★★★☆) | 1 200-1 800 € | +50% |
| 115-124 (★★★★★) | 2 000-3 500 € | ×2-3 |
| 125+ (★★★★★+) | 4 000-8 000 € | ×4-8 |

### 10.2 Vendre de la semence (Expert)

Un joueur possédant un mâle génotypé avec ISU > 125 et F < 5% peut le proposer au catalogue CIA du serveur. Prix fixé par le joueur (15-100€/dose), maximum 50 doses/mois, commission CIA 20%.

### 10.3 Concours et réputation

Les concours IVRAD rapportent argent (500-5 000€), visibilité (badge profil), et clients (joueurs cherchant des génisses de troupeaux primés).

### 10.4 Bilan économique de la génétique

| Poste | Investissement/an | Revenu potentiel/an (après 5 ans) |
|-------|:-----------------:|:---------------------------------:|
| Doses CIA | 660 € | — |
| Génotypage | 600 € | — |
| Semence sexée | 180 € | — |
| Lait supplémentaire | — | +3 000-6 000 € |
| Vente génisses élite | — | +4 000-10 000 € |
| Concours | — | +500-2 000 € |
| **Total** | **~1 440 €** | **+7 500-18 000 €** |

---

## 11. Progression attendue — Scénario chiffré sur 10 ans

### 11.1 Hypothèses

- Troupeau de départ : 40 vaches Holstein, ISU moyen = 100
- Renouvellement : 30%/an (12 génisses entrent, 12 vaches réformées)
- Taureau utilisé : ISU moyen 125 (gamme génomique/élite)
- Les vaches réformées sont celles avec le plus faible ISU
- Pas de génomique les 3 premières années, puis génomique sur les génisses

### 11.2 Calcul année par année

```
Année 0 : ISU = 100,0 │ 8 000 L   (départ)
Année 1 : ISU = 102,2 │ 8 090 L   (+90 L)    Sélection basique
Année 2 : ISU = 104,1 │ 8 165 L   (+75 L)
Année 3 : ISU = 106,0 │ 8 240 L   (+75 L)    ← Début génomique
Année 4 : ISU = 108,2 │ 8 330 L   (+90 L)
Année 5 : ISU = 110,5 │ 8 425 L   (+95 L)    ← Début sexée + pression
Année 6 : ISU = 112,8 │ 8 530 L   (+105 L)
Année 7 : ISU = 115,0 │ 8 640 L   (+110 L)
Année 8 : ISU = 117,1 │ 8 740 L   (+100 L)
Année 9 : ISU = 119,0 │ 8 835 L   (+95 L)    Rendements décroissants
Année 10: ISU = 120,8 │ 8 915 L   (+80 L)
```

**Progression moyenne** : +2,1 ISU/an → +92 L/vache/an.
Sur 40 vaches à l'an 10 : **+915 L × 40 × 0,42€ = +15 370€/an de revenu supplémentaire**.

### 11.4 Courbe de progression

```
ISU moyen du troupeau
  122 │                                              ╭──●
  120 │                                         ╭───╯
  118 │                                    ╭───╯
  116 │                               ╭───╯
  114 │                          ╭───╯
  112 │                     ╭───╯
  110 │                ╭───╯
  108 │           ╭───╯
  106 │      ╭───╯
  104 │  ╭──╯
  102 │╭─╯
  100 ●╯
      └──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──→ Années
         0  1  2  3  4  5  6  7  8  9  10
         
              ↑ Génomique     ↑ Sexée + pression
              (Année 3)       (Année 5)
```

### 11.4 ROI cumulé sur 10 ans

- **Investi** : ~11 700 € (doses + génotypage + sexée)
- **Gagné** : ~80 000 € (lait supplémentaire + ventes élite + concours)
- **ROI** : ×6,8 → la génétique est le meilleur investissement long terme du jeu.

---

## 12. Équilibrage — Anciens vs nouveaux joueurs

### 12.1 Le problème

Un joueur qui joue depuis 10 ans a un ISU moyen de 120. Un nouveau joueur démarre à 100. Écart = +20 ISU = +915 L/vache = avantage massif. Si on ne fait rien, le nouveau ne peut jamais rattraper.

### 12.2 Garde-fous

| Mécanisme | Effet | Justification |
|-----------|-------|---------------|
| **Dérive génétique de la race** | La base 100 se recalcule tous les 2 ans (inflation) | Comme en réalité : la base génétique progresse |
| **Plafond de rendement** | Au-delà d'ISU 130, les gains marginaux diminuent | Rendements décroissants biologiques |
| **Catalogue CIA évolutif** | Les taureaux du CIA s'améliorent avec le temps | Un nouveau en Année 5 achète des doses ISU 135 |
| **Achat de génisses élite** | Le nouveau peut ACHETER de la génétique | Court-circuite 5 ans de sélection (mais coûte cher) |
| **Charges Expert** | 28% de charges en Expert (vs 12% Normal) | L'avantage génétique est partiellement compensé |
| **Vigueur hybride** | Croisement = animaux à F=0%, robustes | Alternative au pur pour les nouveaux |

### 12.3 Mécanisme de recalibrage

Tous les 2 ans in-game, la base raciale = moyenne ISU de tous les animaux de la race sur le serveur. Si la moyenne passe de 100 à 106, un animal à ISU 120 affiche ISU 114. Effet : un nouveau joueur en Année 6 achète des doses "standard" qui valent l'ancien "génomique". Il part à égalité relative.

### 12.4 Rendements décroissants

Le gain de production par point d'ISU diminue aux hauts niveaux :

| Plage ISU | Gain lait/point |
|:---------:|:---------------:|
| 100-110 | +45 L |
| 110-120 | +40 L |
| 120-130 | +32 L |
| 130-140 | +22 L |
| 140+ | +12 L |

→ Un joueur à ISU 140 produit +1 640 L vs base, pas +1 800 L. L'écart se tasse naturellement.

### 12.5 Scénario de rattrapage (nouveau joueur)

Un nouveau rejoint en Année 5. Le catalogue CIA propose désormais des taureaux ISU 130+. Il achète 5 génisses élite (ISU 118) à un ancien joueur pour 3 000€ pièce. Son troupeau démarre à ISU ~112 — au même niveau que l'ancien (ISU 110,5 en Année 5).

**L'argent achète la génétique, mais pas la réputation IVRAD ni les lignées.**
→ Équilibre préservé : le nouveau rattrape vite, l'ancien garde son avance structurelle.

### 12.6 Checklist playtest (test recette SimAgri)

- ✅ Un joueur SimAgri reconnaît le système IVRAD → "C'est IVRAD en mieux"
- ✅ Le mode Normal ne nécessite aucune connaissance génétique
- ✅ La progression est visible même en Normal ("Vos veaux s'améliorent !")
- ✅ Pas de perte définitive liée à la génétique (mauvais veau ≠ ruine)
- ✅ Le serveur Expert est internement équilibré (ADR-005) : Expert = contrôle, pas +€/L (comparaison informative — serveurs séparés)
- ✅ Un nouveau peut rattraper en 2-3 ans avec du budget

---

## Annexe A — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| Affichage index | ★☆☆☆☆ à ★★★★★ | ISU, INEL, MO, CEL, FER, LGV chiffrés |
| Choix taureau | 3-5 taureaux "Bon/Très bon/Excellent" | Catalogue complet avec tous les index |
| Transmission | Message qualitatif | Formule visible + prédiction |
| Génomique | Indisponible | 50€/animal, précision 70-80% |
| Semence sexée | Disponible (bouton simple) | Stratégie optimisée |
| Consanguinité | Alerte auto si >6,25% | Coefficient F affiché, arbre 5 générations |
| Accouplement | Automatique (meilleur taureau budget) | Plan personnalisé, recommandations |
| IVRAD objectifs | "Améliorer vos étoiles" | OG chiffrés par index |
| Concours | Participation automatique | Choix animal + stratégie |
| Vente semence | Indisponible | Possible si mâle ISU>125 |
| Charges liées | 12% | 28% |

## Annexe B — Paramètres numériques clés

| Variable | Valeur |
|----------|:------:|
| σ aléa transmission (standard) | 5 points |
| σ avec génomique 2 parents | 3 points |
| σ avec consanguinité >6,25% | 7 points |
| Seuil consanguinité alerte/critique | 6,25% / 12,5% |
| Précision sans/avec génomique | 35% / 75% |
| Coût génotypage | 50 € |
| Surcoût semence sexée | +36 € |
| Pénalité réussite IA sexée | -8 points |
| % femelles en sexée | 90% |
| Progression ISU/an | +1,5 à +2,5 |
| Gain lait/point ISU (100-120) | 40-45 L |
| Recalibrage base raciale | tous les 2 ans |
| Pedigree stocké | 5 générations |
| Renouvellement catalogue CIA | 30%/mois |

## Annexe C — Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | GDD complet génétique |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
