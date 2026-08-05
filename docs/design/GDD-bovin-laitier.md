> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Élevage bovin laitier

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-elevage.md` §1, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`

---

## 1. Vision et gameplay loop élevage laitier

### 1.1 Intention de design

Le bovin laitier est **l'élevage emblématique** : une production quotidienne, un troupeau qu'on connaît, un revenu régulier. C'est l'opposé des cultures (revenu annuel unique).

**Ce qui rend l'élevage laitier plaisant** :
1. **Le revenu régulier** — le lait rentre tous les jours, pas une fois par an
2. **L'attachement au troupeau** — on nomme ses vaches, on suit leur carrière
3. **La sélection** — améliorer sa génétique sur des années
4. **La routine gratifiante** — traire, nourrir, voir les veaux naître

**Le problème de SimAgri** : la vache est un objet qui produit du lait si on la nourrit. Pas de lactation, pas de tarissement, pas de carrière. Une vache de 2 ans produit comme une vache de 8 ans.

**Ce qu'Agriva ajoute** : la **courbe de lactation** (le cœur du métier laitier) et le **cycle de vie de l'animal**. Une vache n'est pas une machine constante — elle vêle, monte en lactation, atteint un pic, décline, se tarit, et recommence.

### 1.2 Gameplay loop

```
┌──────────────────────────────────────────────────────────────┐
│  BOUCLE QUOTIDIENNE                                          │
└──────────────────────────────────────────────────────────────┘
  Traire (2×/jour ou robot automatique)
  Nourrir (distribution de la ration)
  Vérifier les alertes (santé, chaleurs, vêlages)
        ↓
  Le lait s'accumule dans le tank
        ↓
  Collecte tous les 2-3 jours → paiement mensuel

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE MENSUELLE                                            │
└──────────────────────────────────────────────────────────────┘
  Inséminer les vaches en chaleur
  Tarir les vaches en fin de lactation
  Suivre les vêlages
  Décider des réformes
        ↓
  Paie du lait (selon volume + TB/TP + qualité)

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE ANNUELLE                                             │
└──────────────────────────────────────────────────────────────┘
  Bilan du troupeau : production moyenne, taux de renouvellement
  Choix génétiques : quels taureaux ? semence sexée ?
  Décisions structurelles : agrandir ? robot de traite ?
        ↓
  Progression de la génétique du troupeau (long terme)
```

### 1.3 Cycle de vie d'une vache

```
NAISSANCE
    ↓  (0-3 mois : veau, lait puis sevrage)
GÉNISSE
    ↓  (3-15 mois : croissance)
PREMIÈRE INSÉMINATION (15 mois, 380 kg)
    ↓  (gestation 9 mois)
PREMIER VÊLAGE (24 mois)
    ↓
┌───────────────────────────────────┐
│  CYCLE DE LACTATION (répétable)   │
│                                    │
│  Vêlage → montée en lactation      │
│    ↓ (pic à 6-8 semaines)          │
│  Insémination (60-90 j post-vêlage)│
│    ↓                               │
│  Déclin progressif                 │
│    ↓ (7 mois de gestation)         │
│  TARISSEMENT (60 j avant vêlage)   │
│    ↓                               │
│  Vêlage suivant                    │
└───────────────────────────────────┘
    ↓  (après 3 à 6 lactations)
RÉFORME (vendue en viande)
```

**Durée de vie moyenne** : 5-7 ans (2,5 à 4 lactations en moyenne réelle française).

### 1.4 Différence Normal / Expert

| Aspect | Normal (recette SimAgri) | Expert |
|--------|--------------------------|--------|
| **Production** | Constante selon la race + alimentation | Courbe de lactation réaliste |
| **Traite** | 1 action = tout le troupeau | + cadence selon la salle, temps par vache |
| **Tarissement** | Automatique et transparent | À gérer (fenêtre, ration spécifique) |
| **Lait** | Volume seul | Volume + TB + TP + cellules → prix variable |
| **Alimentation** | 1 ration, quantité selon le stade | Ration calculée (UFL, PDI, fibres), TMR |
| **Reproduction** | Insémination quand on veut | Détection de chaleurs, IVV, fécondité |
| **Génétique** | Indices visibles, progression lente | Index détaillés, semence sexée, génomique |
| **Santé** | Jauge, vaccins | Mammites, boiteries, cellules, métrites |
| **Réforme** | Choix libre du joueur | Recommandations selon la carrière et la rentabilité |
| **Vêlages** | Toute l'année | Groupés ou étalés (choix stratégique) |
| **Bilan** | Litres produits, revenu | Marge/1000L, coût alimentaire, IVV, taux de réussite IA |

---

## 2. L'animal et le troupeau

### 2.1 Structure du troupeau

Un troupeau laitier n'est pas qu'un groupe de vaches. Il comporte plusieurs catégories :

```
TROUPEAU TYPE — 60 vaches laitières

  Vaches en lactation           50   (83%)
  Vaches taries                 10   (17%)
  ─────────────────────────────────
  Total vaches                  60

  Génisses 0-6 mois             12
  Génisses 6-15 mois            14
  Génisses 15-24 mois (gestantes)14
  ─────────────────────────────────
  Total génisses (renouvellement)40

  Veaux mâles (vendus à 15 j)    ~12/an

  TOTAL ANIMAUX PRÉSENTS        100
```

**Règle importante** : pour maintenir 60 vaches, il faut élever environ **40 génisses** (le renouvellement est un investissement de 2 ans avant le premier lait).

### 2.2 Races disponibles

| Race | Production | TB | TP | Longévité | Aptitude viande | Prix génisse |
|------|:----------:|:--:|:--:|:---------:|:---------------:|:------------:|
| **Prim'Holstein** | 9 200 L | 39,5 | 32,0 | ★★☆ | ★☆☆ | 1 800 € |
| **Montbéliarde** | 7 400 L | 38,8 | 34,2 | ★★★★ | ★★★ | 2 000 € |
| **Normande** | 6 800 L | 43,5 | 35,0 | ★★★★ | ★★★★ | 1 900 € |
| **Brune** | 7 800 L | 40,5 | 35,5 | ★★★★ | ★★☆ | 1 950 € |
| **Simmental** | 7 200 L | 40,0 | 34,5 | ★★★★ | ★★★★ | 2 100 € |
| **Jersiaise** | 5 800 L | 52,0 | 38,5 | ★★★ | ★☆☆ | 1 700 € |
| **Abondance** | 6 200 L | 37,5 | 33,0 | ★★★★ | ★★☆ | 1 850 € |
| **Croisée 3 voies** | 8 000 L | 41,0 | 34,0 | ★★★★★ | ★★★ | 1 750 € |

**Arbitrages de race** :
```
Prim'Holstein : volume maximal, mais fragile et moins longévive
                → optimal si on vend le lait au volume

Montbéliarde  : bon compromis, TP élevé (bon pour le fromage),
                réforme bien valorisée en viande
                → optimal en AOP fromagère ou système mixte

Normande      : TB très élevé (Camembert, beurre), excellente réforme
                → optimal en transformation fromagère

Jersiaise     : petit volume mais TB/TP exceptionnels, mange 20% de moins
                → optimal si le lait est payé aux taux (pas au volume)
```

### 2.3 Mode Normal — Fiche animal simple

```
┌─ Vache #142 "Marguerite" ─────────────────────────┐
│                                                    │
│  🐄 Prim'Holstein — 4 ans                          │
│  Née le 12/03/2023 (à la ferme)                    │
│                                                    │
│  Production actuelle : 28 L/jour                   │
│  Production totale : 24 850 L (3 lactations)       │
│                                                    │
│  État : 🟢 En lactation (mois 5)                   │
│  Santé : ████████░░  85%                           │
│  Alimentation : ✅ Ration complète                  │
│                                                    │
│  Gestante : ✅ Vêlage prévu le 18/11/2027           │
│                                                    │
│  Génétique : ★★★☆☆ (indice 108)                    │
│                                                    │
│  [ Tarir ]  [ Réformer ]  [ Renommer ]             │
└────────────────────────────────────────────────────┘
```

### 2.4 Mode Expert — Fiche animal détaillée

```
┌─ Vache #142 "Marguerite" — FR3512847291 ───────────────────────┐
│                                                                 │
│  🐄 Prim'Holstein — 4 ans 3 mois                                │
│  Née le 12/03/2023 — Mère : #98 — Père : Ravalier (IA)          │
│                                                                 │
│  ── Lactation en cours (3e) ──                                  │
│  Vêlage le 22/02/2027 (il y a 148 jours)                        │
│  Production du jour : 28,4 L                                     │
│  Cumul lactation : 4 620 L                                       │
│  Projection 305 j : 9 480 L                                      │
│                                                                 │
│  Courbe :                                                        │
│   42 ┤    ╭─╮                                                    │
│   35 ┤   ╱   ╰─╮                                                 │
│   28 ┤  ╱       ╰──╮  ← aujourd'hui                              │
│   21 ┤ ╱            ╰───╮                                        │
│   14 ┤╱                  ╰──                                     │
│      └──┬───┬───┬───┬───┬───┬───┬───┬───┬───┬                   │
│         1   2   3   4   5   6   7   8   9  10 (mois)             │
│                                                                 │
│  ── Qualité du lait ──                                          │
│  TB : 39,8 g/L ✅    TP : 32,4 g/L ✅                             │
│  Cellules : 145 000/mL ✅ (seuil 300 000)                        │
│  Urée : 245 mg/L ✅ (équilibre azote/énergie correct)            │
│                                                                 │
│  ── Reproduction ──                                             │
│  Inséminée le 14/05/2027 (J+81) — Ravalier                       │
│  Gestation confirmée ✅ — Vêlage prévu 18/11/2027                │
│  IVV précédent : 398 jours 🟡 (objectif < 390)                    │
│  Nombre d'IA par gestation : 1,6 ✅                              │
│                                                                 │
│  ── Carrière ──                                                 │
│  Lactation 1 : 7 850 L (305 j)                                   │
│  Lactation 2 : 8 940 L (312 j)                                   │
│  Lactation 3 : 9 480 L (en cours, projection)                    │
│  Total vie : 26 270 L                                            │
│                                                                 │
│  ── Santé ──                                                    │
│  Mammites : 1 (lactation 2, quartier AG guéri)                   │
│  Boiteries : 0                                                   │
│  Note d'état corporel : 2,8 ✅ (optimal 2,5-3,0)                 │
│  Parage : dernier le 08/01/2027 ✅                                │
│                                                                 │
│  ── Génétique (index officiels) ──                              │
│  ISU : 128 ✅   INEL : +38   Lait : +680 kg                       │
│  TB : +0,8   TP : +1,2   Morphologie : 105                        │
│  Cellules : 102   Fertilité : 98 🟡   Longévité : 104             │
│                                                                 │
│  💡 Bonne laitière avec une fertilité un peu juste.              │
│     Recommandation : IA avec un taureau à index fertilité > 105  │
│                                                                 │
│  [ Tarir ]  [ Réformer ]  [ Inséminer ]  [ Historique complet ]  │
└─────────────────────────────────────────────────────────────────┘
```

### 2.5 Gestion par lots (les deux modes)

Un troupeau de 60 vaches ne se gère pas animal par animal au quotidien. Le jeu propose des lots :

```
┌─ Mon troupeau — 60 VL + 40 génisses ──────────────────────────┐
│                                                                │
│  ── Lots de production ──                                      │
│  🥛 Fraîches vêlées (0-60 j)      8 vaches   36,2 L/j moy      │
│  🥛 Pleine lactation (60-200 j)   26 vaches  29,4 L/j moy      │
│  🥛 Fin de lactation (200-305 j)  16 vaches  18,8 L/j moy      │
│  💤 Taries                        10 vaches  —                  │
│                                                                │
│  Production totale du jour : 1 452 L                            │
│  Moyenne par vache en lactation : 29,0 L                        │
│                                                                │
│  ── Lots de renouvellement ──                                  │
│  🐮 Veaux (0-6 mois)              12                            │
│  🐮 Génisses (6-15 mois)          14                            │
│  🐮 Génisses gestantes (15-24 m)  14                            │
│                                                                │
│  ── Alertes ──                                                 │
│  ⚠️ 3 vaches à tarir cette semaine                              │
│  ⚠️ 5 vaches en chaleur détectées (à inséminer)                 │
│  🔴 1 vache avec cellules élevées (#87, 420 000/mL)             │
│  📅 2 vêlages prévus dans les 7 jours                           │
│                                                                │
│  [ Traire ]  [ Nourrir ]  [ Voir les alertes ]                 │
└────────────────────────────────────────────────────────────────┘
```

**En Normal** : le joueur agit sur les lots (« traire tout le troupeau »).
**En Expert** : il peut aussi agir animal par animal, et créer des lots personnalisés (par exemple un lot « hautes productrices » avec une ration plus riche).

### 2.6 Enclos d'attente

L'enclos d'attente est une zone de transit temporaire où les animaux sont placés **entre deux affectations** : à l'arrivée sur l'exploitation (achat), avant un départ (vente, transport), ou en attendant un bâtiment libre.

**Règle fondamentale** : un animal en enclos d'attente **ne produit pas** (pas de lait, pas de croissance comptabilisée) et subit des **pénalités accélérées**.

#### Paramètres de l'enclos d'attente

| Paramètre | Valeur |
|-----------|--------|
| Capacité | 20 UGB par enclos (1 enclos par défaut à la création de l'exploitation) |
| Coût de construction (enclos supplémentaire) | 3 500 € |
| Surface | 50 m² (non extensible) |
| Production laitière | 0 L/jour |
| Croissance (GMQ) | 0 g/jour |
| Durée maximale sans pénalité | 2 jours |

#### Pénalités au-delà de 2 jours

| Jour en enclos | Faim (/jour) | Santé (/jour) | Stress | Effet cumulatif |
|:--------------:|:------------:|:-------------:|:------:|-----------------|
| Jour 1-2 | 0 | 0 | 0 | Aucun — transit normal |
| Jour 3-4 | -10 pts | -5 pts | +10 | Production -5% pendant 3 jours après sortie |
| Jour 5-7 | -20 pts | -10 pts | +20 | Production -12% pendant 5 jours après sortie |
| Jour 8-14 | -20 pts | -15 pts | +30 | Production -20% pendant 7 jours, fertilité -15% |
| Jour 15+ | -25 pts | -20 pts | +40 | Risque de mortalité 3%/jour |

**Mode Normal** : alerte visuelle dès J+2 (« ⚠️ Vos animaux souffrent dans l'enclos d'attente ! Affectez-les à un bâtiment. »). L'animal ne meurt pas mais sa santé chute à 20% minimum.

**Mode Expert** : les pénalités s'appliquent intégralement. Un animal en enclos 15+ jours peut mourir. La valeur de revente chute de 5%/jour au-delà de J+7.

#### Interface enclos d'attente

```
┌─ Enclos d'attente — 4/20 UGB ─────────────────────────┐
│                                                        │
│  🐄 2 génisses Montbéliardes (achetées il y a 1 jour) │
│     État : ✅ Transit normal                           │
│     → [Affecter au bâtiment "Stabulation Nord"]       │
│                                                        │
│  🐄 2 vaches Prim'Holstein (en attente de vente)       │
│     État : 🟡 Jour 3 — pénalités en cours              │
│     Santé : 92% (-5/jour)                              │
│     → [Vendre maintenant]  [Affecter un bâtiment]     │
│                                                        │
│  💡 Conseil : affectez vos animaux sous 48h pour       │
│     éviter les pénalités de bien-être.                 │
└────────────────────────────────────────────────────────┘
```


---

## 3. Lactation et production laitière

### 3.1 Intention de design — l'ajout central

C'est **la mécanique qui manque totalement à SimAgri**. Dans SimAgri, une vache produit X litres par jour, toujours. Dans la réalité, la production suit une courbe :

```
Production journalière (L)

  45 ┤        ╭──╮
  40 ┤      ╱      ╰──╮
  35 ┤    ╱             ╰───╮
  30 ┤   ╱                   ╰────╮
  25 ┤  ╱                          ╰─────╮
  20 ┤ ╱                                  ╰──────╮
  15 ┤╱                                           ╰────╮
  10 ┤                                                  ╰──╮
   5 ┤                                                      ╰─ TARISSEMENT
   0 ┼──────────────────────────────────────────────────────────────
     0    1    2    3    4    5    6    7    8    9   10   11 (mois)
     ↑         ↑                                          ↑
   VÊLAGE     PIC                                    TARISSEMENT
```

**Conséquences de gameplay** :
- Le joueur doit **étaler ses vêlages** pour lisser sa production (ou les grouper s'il veut un pic saisonnier)
- Une vache fraîche vêlée vaut beaucoup plus qu'une vache en fin de lactation
- Le tarissement (2 mois sans lait) est un coût qu'il faut anticiper
- **Le troupeau devient un système dynamique à piloter**, pas un stock statique

### 3.2 Mode Normal — Courbe simplifiée

**Principe** : la courbe existe et est visible, mais le calcul est simple et pardonne.

```
production_jour = production_potentielle_race
                × f_stade_lactation
                × f_rang_lactation
                × f_alimentation
                × f_santé

f_stade_lactation (courbe en 4 paliers simples) :
  Mois 1        : 0,90  (montée en lactation)
  Mois 2-3      : 1,00  (pic)
  Mois 4-6      : 0,85
  Mois 7-8      : 0,65
  Mois 9-10     : 0,45
  Tarissement   : 0,00  (2 mois)

f_rang_lactation :
  1ère lactation : 0,80  (la génisse n'a pas fini de grandir)
  2e             : 0,92
  3e à 5e        : 1,00  (maturité)
  6e et +        : 0,95

f_alimentation :
  Ration complète et équilibrée : 1,00
  Ration insuffisante           : 0,75
  Pas de ration                 : 0,40 (+ perte de santé)

f_santé :
  Santé > 80% : 1,00
  Santé 50-80%: 0,88
  Santé < 50% : 0,70
```

**Exemple — Prim'Holstein 3e lactation, mois 3, bien nourrie** :
```
Potentiel race (Prim'Holstein) : 9 200 L/305 j = 30,2 L/j de moyenne
Production au pic = moyenne × 1,45 = 43,8 L/j

production = 43,8 × 1,00 (pic) × 1,00 (3e lact.) × 1,00 × 1,00 = 43,8 L/j
```

**Affichage Normal** :
```
┌─ Production du troupeau ──────────────────────────┐
│                                                    │
│  Aujourd'hui : 1 452 L                             │
│                                                    │
│  Répartition par stade :                           │
│  🟢 Fraîches (8 vaches)      290 L  (36 L/vache)   │
│  🟢 Pleine lactation (26)    764 L  (29 L/vache)   │
│  🟡 Fin de lactation (16)    398 L  (25 L/vache)   │
│  ⚪ Taries (10)                0 L                  │
│                                                    │
│  Moyenne troupeau : 29,0 L/vache en lactation      │
│                                                    │
│  📊 Évolution sur 30 jours   ▂▃▅▆▇▇▆▅▄▃            │
│                                                    │
│  💡 Vos vêlages sont concentrés en février-mars.    │
│     Étaler les vêlages lisserait votre production   │
│     et votre revenu sur l'année.                    │
└────────────────────────────────────────────────────┘
```

### 3.3 Mode Expert — Modèle de Wood

**Formule de Wood** (le standard zootechnique) :
```
Y(t) = a × t^b × e^(-c×t)

où :
  Y(t) = production au jour t de lactation
  a    = paramètre d'échelle (niveau de production, lié à la génétique)
  b    = paramètre de montée (rapidité d'atteinte du pic)
  c    = paramètre de persistance (vitesse de déclin)

Paramètres typiques (Prim'Holstein, 3e lactation) :
  a = 22, b = 0,22, c = 0,0035
  → pic à t = b/c = 63 jours, production au pic = 44 L
```

**Paramètres selon la race et le rang** :

| Race | Rang | a | b | c | Pic (j) | Pic (L) | Persistance |
|------|:----:|:-:|:-:|:-:|:-------:|:-------:|:-----------:|
| Prim'Holstein | 1 | 17,5 | 0,24 | 0,0032 | 75 | 35 | Bonne |
| Prim'Holstein | 3+ | 22,0 | 0,22 | 0,0035 | 63 | 44 | Moyenne |
| Montbéliarde | 1 | 15,0 | 0,22 | 0,0028 | 79 | 29 | Très bonne |
| Montbéliarde | 3+ | 18,5 | 0,20 | 0,0030 | 67 | 36 | Bonne |
| Normande | 3+ | 17,0 | 0,20 | 0,0029 | 69 | 33 | Bonne |
| Jersiaise | 3+ | 14,5 | 0,21 | 0,0031 | 68 | 28 | Bonne |

**Facteurs modulants (Expert)** :
```
Y_réel(t) = Y_Wood(t) × f_génétique × f_alimentation × f_santé × f_confort × f_saison

f_génétique   : index lait de l'animal (0,85 à 1,20)
f_alimentation: couverture des besoins UFL/PDI (0,60 à 1,05)
f_santé       : présence de mammite, boiterie (0,70 à 1,00)
f_confort     : logement, densité, chaleur (0,88 à 1,03)
f_saison      : stress thermique été (0,85 à 1,00)
```

**Stress thermique (Expert)** :
```
Si température > 25°C ET humidité > 60% :
  → THI (Temperature Humidity Index) > 72
  → production -8 à -25% selon l'intensité
  → ingestion réduite, TB en baisse
  
Solutions : ventilation (investissement), brumisation, pâturage de nuit
→ Le changement climatique devient un enjeu de gameplay
```

**Affichage Expert** :
```
┌─ Analyse de la production — Troupeau (50 VL en lactation) ──────┐
│                                                                  │
│  Production du jour : 1 452 L                                     │
│  Moyenne : 29,0 L/VL   |   Objectif : 31,5 L/VL   🟡              │
│                                                                  │
│  ── Décomposition de l'écart (-2,5 L/VL) ──                      │
│  Potentiel génétique du troupeau        32,8 L/VL                 │
│  - Déficit énergétique de la ration     -1,8 L  ⚠️ principal      │
│  - Stress thermique (THI 74)            -1,2 L                    │
│  - 3 vaches avec cellules élevées       -0,4 L                    │
│  + Bon confort de logement              +0,3 L                    │
│  - Répartition des stades défavorable   -0,7 L                    │
│  ────────────────────────────────────────────                    │
│  Réalisé                                29,0 L/VL                 │
│                                                                  │
│  ── Répartition des stades ──                                    │
│  Idéal      Actuel                                                │
│  0-60 j   : 20%   16%  🟡 (peu de fraîches vêlées)                │
│  60-200 j : 45%   52%  ✅                                          │
│  200-305 j: 20%   32%  ⚠️ (trop de fin de lactation)              │
│  Taries   : 15%   17%  ✅                                          │
│                                                                  │
│  💡 Actions prioritaires :                                        │
│  1. Augmenter la densité énergétique de la ration (+0,08 UFL/kg)  │
│     → gain estimé +1,5 L/VL = +75 L/jour = +32 €/jour             │
│  2. Ventilation du bâtiment (investissement 18 000 €)             │
│     → gain estimé +1,0 L/VL en été = +2 400 €/an                  │
│  3. Étaler les vêlages sur l'année (planification IA)             │
│                                                                  │
│  [ Ajuster la ration ]  [ Voir les vaches à problème ]           │
└──────────────────────────────────────────────────────────────────┘
```

### 3.4 Tarissement

**Mode Normal** :
```
Le jeu prévient 10 jours avant la date recommandée :
  "3 vaches sont à tarir cette semaine"
  
Le joueur clique « Tarir » → la vache passe en lot tari, ne produit plus.
Si le joueur oublie : le tarissement se fait automatiquement à J-50
avant vêlage (pas de pénalité, juste un rappel).
```

**Mode Expert** :
```
Durée optimale du tarissement : 55-65 jours

Si tarissement < 40 jours :
  → mamelle insuffisamment régénérée
  → lactation suivante -12% de production
  → risque de mammite au vêlage ×2

Si tarissement > 80 jours :
  → engraissement de la vache (NEC > 3,5)
  → risque de vêlage difficile
  → risque de cétose post-vêlage
  → lactation suivante -5%

Ration de tarissement spécifique :
  Faible énergie, riche en fibres
  Si on garde la ration de lactation : engraissement + problèmes métaboliques
  
Traitement au tarissement :
  Antibiotique intramammaire (préventif mammite) : 18 €/vache
  Obturateur seul (sans antibiotique) : 8 €/vache
  → Choix : sécurité sanitaire vs réduction des antibiotiques (label)
```

### 3.5 Qualité du lait et paie

**Mode Normal — prix simple** :
```
prix_lait = prix_base × f_qualité_globale

f_qualité_globale :
  Excellente (bonne alimentation, santé > 85%) : 1,08
  Bonne                                        : 1,00
  Moyenne (cellules élevées ou mauvaise ration): 0,92

Prix de base : 0,43 €/L
Bio : 0,52 €/L
```

**Mode Expert — grille de paiement réelle** :
```
prix_final = prix_base
           + prime_TB
           + prime_TP
           - pénalité_cellules
           - pénalité_butyriques
           + prime_qualité_sanitaire

PRIME MATIÈRE GRASSE (TB)
  Référence : 38 g/L
  Prime/malus : ±0,0035 €/L par point d'écart
  Ex : TB 42 g/L → +4 points → +0,014 €/L

PRIME PROTÉINE (TP)
  Référence : 32 g/L
  Prime/malus : ±0,0090 €/L par point d'écart  (le TP paie 2,5× plus que le TB !)
  Ex : TP 34,5 g/L → +2,5 points → +0,0225 €/L

PÉNALITÉ CELLULES SOMATIQUES
  < 250 000/mL   : 0 (+ prime qualité 0,008 €/L)
  250-300 000    : 0
  300-400 000    : -0,015 €/L
  400-500 000    : -0,030 €/L
  > 500 000      : -0,060 €/L + risque de refus de collecte

PÉNALITÉ BUTYRIQUES (si ensilage mal conservé)
  > 1000 spores/L : -0,020 €/L
  → Incite à bien conserver ses silos

Exemple de paie réelle :
  Base                    0,4300 €/L
  TB 41,2 (+3,2 pts)     +0,0112
  TP 34,1 (+2,1 pts)     +0,0189
  Cellules 168 000       +0,0080  (prime qualité)
  ──────────────────────────────
  PRIX FINAL              0,4681 €/L   (+8,9% vs base)

  Sur 450 000 L/an : +17 145 € par rapport au prix de base ✅
```

**Ceci est un levier d'optimisation majeur en Expert** : améliorer le TP de 2 g/L rapporte plus que produire 5% de lait en plus.

### 3.6 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Courbe de lactation | 5 paliers simples | Modèle de Wood (a, b, c) |
| Effet du rang de lactation | 3 niveaux | Paramètres a/b/c par rang |
| Durée de lactation | 305 j fixe | 280-380 j selon la fertilité |
| Tarissement | Automatique si oublié | Fenêtre optimale 55-65 j, pénalités |
| Ration de tarissement | Non | Oui (sinon engraissement) |
| Qualité du lait | 3 niveaux globaux | TB, TP, cellules, butyriques |
| Amplitude de prix | ±8% | -14% à +12% |
| Stress thermique | Non | Oui (THI, -8 à -25%) |
| Levier d'optimisation principal | Alimentation | TP + cellules + étalement des vêlages |


---

## 4. Traite — salle vs robot

### 4.1 Intention de design

La traite est **l'astreinte fondamentale** de l'éleveur laitier : deux fois par jour, 365 jours par an. Le robot de traite est **le principal saut technologique** du métier depuis 30 ans.

Le choix salle vs robot est un arbitrage classique : **capital vs temps de travail**.

### 4.2 Salle de traite

**Types disponibles** :

| Type | Postes | Vaches/h | Prix | Adapté à |
|------|:------:|:--------:|:----:|:--------:|
| Épi 2×4 | 8 | 40-50 | 55 000 € | 30-50 VL |
| Épi 2×6 | 12 | 55-70 | 78 000 € | 45-75 VL |
| Épi 2×8 | 16 | 70-90 | 105 000 € | 60-100 VL |
| Épi 2×12 | 24 | 100-130 | 165 000 € | 90-150 VL |
| Rotative 28 postes | 28 | 130-170 | 280 000 € | 130-250 VL |
| Rotative 40 postes | 40 | 180-240 | 420 000 € | 200-400 VL |

**Temps de traite** :
```
temps_traite = (nb_vaches / cadence_horaire) + temps_préparation

temps_préparation = 25 min (branchement, lavage, nettoyage)

Exemple — 50 VL avec une 2×6 (cadence 60 vaches/h) :
  50 / 60 = 0,83 h = 50 min
  + 25 min de préparation
  = 1 h 15 par traite
  × 2 traites/jour = 2 h 30 par jour
  × 365 jours = 912 h/an  ⚠️ soit la moitié d'un temps plein !
```

**En mode Normal** : la traite est **1 action** qui consomme du temps selon la salle et le nombre de vaches.

```
┌─ Traire — 50 vaches en lactation ─────────────────┐
│                                                    │
│  Salle de traite : Épi 2×6 (12 postes)             │
│  Cadence : 60 vaches/heure                         │
│                                                    │
│  ⏱️ Temps : 1 h 15                                  │
│  🥛 Production estimée : 726 L                      │
│                                                    │
│  Tank à lait : 1 240 / 3 000 L                      │
│  Après traite : 1 966 / 3 000 L ✅                  │
│                                                    │
│  ⚡ Électricité : 12 kWh                            │
│                                                    │
│  [ Traire ]                                        │
└────────────────────────────────────────────────────┘
```

**En mode Expert** : ajout de contraintes réalistes.
```
• Intervalle entre traites : si < 10 h ou > 14 h → production -5%
• Si une traite est manquée : production -25% + risque de mammite ×3
• Nombre de traites : 2× (standard) ou 3× (+12% de production, +50% de temps)
• Monotraite (1×/jour) : -30% de production, -50% de temps
  → stratégie viable en système extensif ou petite structure
```

### 4.3 Robot de traite

```
Prix : 165 000 € par robot (installation incluse)
Capacité : 55-65 vaches par robot
Consommables : 3 500 €/an (produits de lavage, filtres, maintenance)
Électricité : +40% vs salle de traite
Durée de vie : 10-12 ans
```

**Bénéfices** :
```
✅ Suppression de l'astreinte traite (912 h/an libérées !)
✅ 2,6 à 3,1 traites/vache/jour en moyenne → +8 à +12% de production
✅ Détection automatique des mammites (conductivité du lait)
✅ Suivi individuel automatique (production, poids, activité)
✅ Alimentation concentrée individualisée au robot
```

**Contraintes** :
```
⚠️ Investissement lourd (165 000 € pour 60 VL)
⚠️ Nécessite un bâtiment adapté (circulation libre des vaches)
⚠️ 3-5% des vaches ne s'adaptent pas → à réformer
⚠️ Panne = crise immédiate (les vaches doivent être traites !)
⚠️ Astreinte de surveillance (alertes à traiter, vaches à pousser)
```

**Comparaison économique (60 VL, mode Normal)** :
```
                          Salle 2×8        Robot (1 unité)
Investissement            105 000 €        165 000 €
Amortissement/an           8 750 €          15 000 €
Consommables/an            1 800 €           3 500 €
Électricité/an             2 400 €           3 400 €
─────────────────────────────────────────────────────
Charges annuelles         12 950 €          21 900 €

Temps de travail          912 h/an          180 h/an (surveillance)
Temps libéré              —                 732 h/an

Production                480 000 L         528 000 L (+10%)
Recette supplémentaire    —                 +20 640 €

BILAN                     —                 +20 640 - 8 950 = +11 690 €/an ✅
                                            + 732 h libérées
```

**Le robot est rentable** — mais il faut pouvoir financer les 165 000 €.

**En mode Expert** — contraintes additionnelles :
```
Taux de fréquentation du robot :
  Doit être entre 75% et 92% de sa capacité
  < 75% : sous-utilisé, l'investissement n'est pas rentabilisé
  > 92% : file d'attente, les vaches attendent, production -6%

Vaches "difficiles" :
  3-5% des vaches refusent le robot ou ont une mamelle mal placée
  → doivent être traites manuellement ou réformées

Panne du robot :
  Immobilisation > 12 h = crise majeure
  → traite manuelle d'urgence (location d'un bloc trayeur mobile)
  → ou perte de production + mammites
  → Contrat de maintenance 24/7 recommandé : 4 200 €/an
```

### 4.4 Tank à lait et collecte

```
Dimensionnement : capacité = production de 2,5 jours minimum

Exemple 60 VL × 29 L = 1 740 L/jour → tank de 4 500 L

Prix : 12 €/L de capacité (tank 4 500 L = 54 000 €)

Collecte :
  Tous les 2 ou 3 jours (choix du joueur en Expert)
  Si le tank est plein avant la collecte → lait perdu ⚠️
  
Refroidissement : le lait doit descendre à 4°C en 2 h
  Électricité : 1,2 kWh par 100 L
  Récupérateur de chaleur (option, 8 000 €) : -40% de coût énergie
```

---

## 5. Alimentation

### 5.1 Intention de design

L'alimentation représente **50 à 60% du coût de production du lait**. C'est le principal levier économique de l'éleveur.

**Ce qu'on garde de SimAgri** : la ration est distribuée automatiquement (tick quotidien), le joueur doit juste avoir du stock.
**Ce qu'on ajoute** : la ration influence la production, et en Expert, elle se calcule.

### 5.2 Mode Normal — Rations prédéfinies

**Trois niveaux de ration, le joueur choisit** :

```
┌─ Ration du troupeau — 50 VL en lactation ─────────────────────┐
│                                                                │
│  ○ ÉCONOMIQUE                                                  │
│    Foin 8 kg + Ensilage maïs 20 kg + Céréales 3 kg             │
│    Coût : 3,80 €/VL/jour                                       │
│    Production : -15% (25 L/VL)                                 │
│                                                                │
│  ● ÉQUILIBRÉE (recommandée)                                    │
│    Foin 4 kg + Ensilage maïs 30 kg + Concentré 7 kg + AMV      │
│    Coût : 5,20 €/VL/jour                                       │
│    Production : optimale (29 L/VL)                             │
│                                                                │
│  ○ INTENSIVE                                                   │
│    Foin 3 kg + Ensilage maïs 32 kg + Concentré 10 kg + AMV     │
│    Coût : 6,40 €/VL/jour                                       │
│    Production : +6% (31 L/VL)                                  │
│    ⚠️ Risque d'acidose si mal conduite                          │
│                                                                │
│  ── Analyse économique ──                                      │
│  Ration équilibrée : 5,20 €/VL × 50 = 260 €/jour               │
│  Recette lait : 29 L × 50 × 0,43 € = 623 €/jour                │
│  Marge sur coût alimentaire : 363 €/jour = 7,26 €/VL           │
│                                                                │
│  ── Stock disponible ──                                        │
│  Ensilage maïs : 285 t (57 jours) ✅                            │
│  Foin : 42 t (105 jours) ✅                                     │
│  Concentré : 8 t (23 jours) 🟡 à commander                      │
│                                                                │
│  [ Appliquer la ration équilibrée ]                            │
└────────────────────────────────────────────────────────────────┘
```

**Rations par catégorie d'animal (Normal)** :

| Catégorie | Ration | Coût/jour |
|-----------|--------|:---------:|
| VL en lactation (équilibrée) | Ensilage 30 + Foin 4 + Concentré 7 | 5,20 € |
| VL tarie | Foin 8 + Paille 3 + Minéraux | 1,60 € |
| Génisse 0-6 mois | Lait/poudre + Concentré 2 + Foin | 3,20 € |
| Génisse 6-15 mois | Ensilage 12 + Foin 3 + Concentré 1,5 | 2,10 € |
| Génisse 15-24 mois | Ensilage 18 + Foin 4 | 2,40 € |
| Vache au pâturage (été) | Herbe + Concentré 2 | 1,80 € |

**Pâturage (Normal)** : si le joueur met ses vaches au pré (avril-octobre), le coût alimentaire chute de 60%. Contrainte : surface disponible (35-45 ares/VL).

### 5.3 Mode Expert — Calcul de ration

**a) Besoins de la vache**
```
Besoins = entretien + production + gestation + croissance

ENTRETIEN (vache de 650 kg)
  Énergie : 5,2 UFL/jour
  Protéines : 400 g PDI/jour

PRODUCTION (par litre de lait à 38 TB / 32 TP)
  Énergie : 0,44 UFL/L
  Protéines : 48 g PDI/L

GESTATION (7e-9e mois)
  Énergie : +1,5 à +3,0 UFL/jour
  Protéines : +100 à +200 g PDI/jour

Exemple — vache à 32 L, 7e mois de gestation :
  Énergie : 5,2 + (32 × 0,44) + 1,5 = 20,8 UFL/jour
  Protéines : 400 + (32 × 48) + 100 = 2 036 g PDI/jour
```

**b) Capacité d'ingestion (la contrainte cachée)**
```
capacité_ingestion = 0,022 × poids_vif + 0,2 × production_lait  (kg MS/jour)

Exemple : vache 650 kg à 32 L
  = 0,022 × 650 + 0,2 × 32 = 14,3 + 6,4 = 20,7 kg MS/jour

⚠️ La vache ne peut pas manger plus que sa capacité !
→ Pour produire beaucoup, il faut une ration DENSE (plus d'UFL par kg de MS)
→ C'est le vrai défi de la nutrition laitière
```

**c) Construction de la ration (interface Expert)**
```
┌─ Calculer la ration — Lot "Pleine lactation" (26 VL à 32 L) ────┐
│                                                                  │
│  OBJECTIF                    Apporté      Écart                  │
│  Énergie    20,8 UFL         20,4 UFL     -0,4  🟡               │
│  Protéines  2 036 g PDI      2 105 g      +69   ✅                │
│  Ingestion  20,7 kg MS max   20,2 kg MS   ✅ (dans la limite)     │
│  Fibres     > 18% MS         19,4%        ✅                      │
│  Amidon     < 25% MS         23,8%        ✅ (pas d'acidose)      │
│                                                                  │
│  ── Composition ──                                               │
│  Aliment          kg brut  kg MS   UFL    PDI    Coût            │
│  ──────────────────────────────────────────────────────          │
│  Ensilage maïs      32,0    10,9   10,2   580    1,96 €          │
│  Ensilage herbe      8,0     2,8    2,4   310    0,50 €          │
│  Foin de luzerne     2,5     2,2    1,7   380    0,44 €          │
│  Blé aplati          2,0     1,8    2,1   130    0,42 €          │
│  Tourteau de colza   2,5     2,2    2,3   700    0,78 €          │
│  Pulpe de betterave  1,5     1,3    1,3     95   0,24 €          │
│  AMV (minéraux)      0,25    0,25    —      —    0,18 €          │
│  ──────────────────────────────────────────────────────          │
│  TOTAL              48,75   21,45  20,0  2 195   4,52 €/VL       │
│                                                                  │
│  🟡 Léger déficit énergétique (-0,4 UFL = -0,9 L de lait)         │
│  💡 Suggestions :                                                 │
│     • +0,5 kg de blé aplati (+0,10 €) → comble le déficit         │
│     • Ou remplacer 2 kg d'ensilage herbe par 2 kg de maïs         │
│                                                                  │
│  Coût de la ration : 4,52 €/VL/jour                              │
│  Coût par litre produit : 141 €/1000 L ✅ (référence 150-180)     │
│                                                                  │
│  [ Appliquer ]  [ Optimiser automatiquement ]  [ Sauvegarder ]    │
└──────────────────────────────────────────────────────────────────┘
```

**d) Risques nutritionnels (Expert)**
```
ACIDOSE (excès d'amidon, manque de fibres)
  Déclencheur : amidon > 28% MS ou fibres < 16% MS
  Effets : -15% production, TB en chute (< 35 g/L), boiteries, diarrhées
  Récupération : 2-3 semaines après correction

CÉTOSE (déficit énergétique en début de lactation)
  Déclencheur : bilan énergétique négatif > -3 UFL pendant 2 semaines
  Effets : -20% production, amaigrissement, risque de non-fécondation
  Prévention : ration de transition avant vêlage, propylène glycol

EXCÈS D'AZOTE
  Déclencheur : PDI > besoins + 15%
  Effets : urée du lait > 300 mg/L, gaspillage économique, fertilité -10%

TÉTANIE D'HERBAGE (carence en magnésium au printemps)
  Déclencheur : mise à l'herbe brutale sans complémentation
  Effets : mortalité possible
  Prévention : bolus de magnésium, transition progressive
```

**e) Autonomie alimentaire (Expert)**
```
┌─ Autonomie alimentaire ───────────────────────────────────┐
│                                                            │
│  Besoins annuels du troupeau (60 VL + 40 génisses) :       │
│    Ensilage maïs      680 t                                │
│    Ensilage herbe     180 t                                │
│    Foin               120 t                                │
│    Céréales            85 t                                │
│    Tourteaux           65 t                                │
│                                                            │
│  Production sur l'exploitation :                           │
│    Ensilage maïs      680 t  ✅ (42 ha à 16 t MS)          │
│    Ensilage herbe     180 t  ✅ (25 ha de prairie)         │
│    Foin               120 t  ✅ (20 ha)                     │
│    Céréales            85 t  ✅ (12 ha de blé)              │
│    Tourteaux            0 t  ❌ ACHAT (65 t × 340 € = 22 100 €)│
│                                                            │
│  Taux d'autonomie : 82% ✅ (référence 60-75%)               │
│  Dépendance : protéines (tourteaux importés)                │
│                                                            │
│  💡 Pistes pour améliorer :                                 │
│     • Cultiver 8 ha de luzerne (-30 t de tourteau)          │
│     • Cultiver 6 ha de féverole (-25 t de tourteau)          │
│     → Économie potentielle : 18 700 €/an                    │
└────────────────────────────────────────────────────────────┘
```

### 5.4 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Choix de ration | 3 niveaux prédéfinis | Calcul libre (UFL, PDI, MS, fibres, amidon) |
| Distribution | Automatique (tick) | Automatique + choix du nombre de repas |
| Coût/VL/jour | 3,80 à 6,40 € | 3,50 à 7,00 € (optimisable) |
| Coût/1000 L | ~180 € | 130 à 200 € |
| Capacité d'ingestion | Non modélisée | Oui (contrainte forte) |
| Risques nutritionnels | Non | Acidose, cétose, excès N, tétanie |
| Pâturage | -60% de coût | + gestion des paddocks, transition |
| Autonomie | Non affichée | Calculée, avec pistes d'amélioration |
| Mélangeuse | Optionnelle (gain de temps) | +4% de production (ration homogène) |

### 5.5 Robot d'alimentation (automatisation)

Le robot d'alimentation est un équipement haut de gamme qui **automatise la distribution des rations**, réduisant drastiquement le temps de travail quotidien lié à l'alimentation.

**Prérequis** : AgriPass actif (fonctionnalité premium confort — cf. GDD-endgame §8).

#### Catalogue robot d'alimentation

| Modèle | Capacité | Prix | Entretien/an | Espèces compatibles |
|--------|:--------:|:----:|:------------:|:-------------------:|
| Robot mono-couloir | 60 VL max | 185 000 € | 4 200 € | Bovin laitier uniquement |
| Robot bi-couloir | 120 VL max | 265 000 € | 5 800 € | Bovin laitier uniquement |
| Robot multi-espèces | 80 UGB max | 215 000 € | 4 800 € | Bovin laitier + allaitant |

#### Effets du robot d'alimentation

| Paramètre | Sans robot | Avec robot |
|-----------|:----------:|:----------:|
| Temps distribution/jour (60 VL) | 1 h 30 | 0 h 15 (surveillance uniquement) |
| Nombre de distributions/jour | 1-2 (mélangeuse manuelle) | 6-8 (micro-distributions) |
| Homogénéité de la ration | Standard | +6% de production (ration toujours fraîche) |
| Tri individuel | Non (par lot uniquement) | Oui (ration adaptée par vache, Expert) |
| Économie de temps annuelle | Référence | 456 h économisées/an (60 VL) |

#### Calcul du temps économisé (ADR-004)

```
Sans robot :
  Chargement mélangeuse        : 20 min
  Distribution (60 VL, 2 lots) : 2 × 25 min = 50 min
  Total/jour                   : 1 h 10 (×365 = 427 h/an)
  Si 2 distributions/jour      : 1 h 30/jour (×365 = 548 h/an)

Avec robot :
  Surveillance + remplissage trémie : 15 min/jour
  Maintenance hebdomadaire          : 30 min/semaine
  Total/an                          : 91 h + 26 h = 117 h/an

Économie nette : 548 - 117 = 431 h/an (≈ 1,2 h/jour)
```

#### Pannes et maintenance

| Événement | Fréquence | Immobilisation | Coût |
|-----------|:---------:|:--------------:|:----:|
| Maintenance préventive | Toutes les 2 000 h | 4 h | Inclus dans entretien annuel |
| Panne mineure (capteur, courroie) | 2-3×/an | 6 h | 350-800 € |
| Panne majeure (motoréducteur) | 1×/3 ans | 2 jours | 3 500-6 000 € |

**En cas de panne** : le joueur doit distribuer manuellement (retour au temps normal) jusqu'à réparation.

**Mode Normal** : le robot est un achat « plug & play ». Réduction de temps affichée clairement, pannes rares.

**Mode Expert** : le robot permet le tri individuel (chaque vache reçoit sa ration calculée au §5.3). Optimisation fine possible, mais maintenance plus exigeante.


---

## 6. Reproduction et renouvellement

### 6.1 Intention de design

**« Pas de veau, pas de lait »** — la reproduction est le moteur de l'élevage laitier. Une vache qui ne se reproduit pas ne produira plus de lait après sa lactation en cours.

C'est aussi le levier de **progression génétique** : chaque insémination est un choix d'amélioration du troupeau.

### 6.2 Mode Normal — Insémination simple

```
┌─ Inséminer — 5 vaches en chaleur ─────────────────────────────┐
│                                                                │
│  Vaches détectées en chaleur :                                 │
│  ☑ #142 Marguerite  (85 j post-vêlage) ✅ prête                │
│  ☑ #156 Blanchette  (72 j) ✅ prête                             │
│  ☑ #98 Étoile       (61 j) ✅ prête                             │
│  ☐ #187 Fleurette   (38 j) ⚠️ trop tôt (attendre 60 j)          │
│  ☑ #203 Douce       (94 j) ✅ prête                             │
│                                                                │
│  ── Choix du taureau ──                                        │
│  ● Ravalier      Lait +680  Morpho 105  Fertilité 108   32 €   │
│  ○ Nordique      Lait +920  Morpho 98   Fertilité 96    48 €   │
│  ○ Solide        Lait +410  Morpho 112  Fertilité 115   28 €   │
│  ○ Semence sexée (Ravalier) : 90% de femelles           68 €   │
│                                                                │
│  Taux de réussite estimé : 58%                                 │
│  Coût : 4 × 32 € = 128 €                                       │
│                                                                │
│  💡 La semence sexée garantit des génisses de renouvellement    │
│                                                                │
│  [ Inséminer les 4 vaches ]                                    │
└────────────────────────────────────────────────────────────────┘
```

**Paramètres Normal** :
```
Détection des chaleurs : automatique (le jeu signale les vaches prêtes)
Délai minimum post-vêlage : 60 jours
Taux de réussite : 55-65% (selon la santé de la vache)
Si échec : nouvelle chaleur 21 jours plus tard
Gestation : 283 jours
Résultat : 50% mâle / 50% femelle (ou 90% femelle en sexée)
```

### 6.3 Mode Expert — Fertilité et pilotage

**a) Détection des chaleurs**
```
Méthode                        Taux de détection    Coût
Observation visuelle           50-60%               0 € (temps)
Podomètres / colliers          85-92%               110 €/vache
Capteurs de rumination         88-94%               140 €/vache
Détecteur de chaleur (patch)   75-85%               8 €/vache/cycle
Dosage progestérone (lait)     95%                  4 €/test

→ Une chaleur non détectée = 21 jours perdus = +21 jours d'IVV
→ Chaque jour d'IVV au-delà de 380 coûte ~3 €/vache
```

**b) Facteurs de fertilité**
```
taux_réussite_IA = base_race
                 × f_état_corporel
                 × f_bilan_énergétique
                 × f_santé_utérine
                 × f_index_fertilité
                 × f_stress_thermique
                 × f_moment_insémination

base_race : Prim'Holstein 42%, Montbéliarde 52%, Normande 50%

f_état_corporel (NEC) :
  NEC < 2,0 (maigre)     : 0,70
  NEC 2,25-3,0 (optimal) : 1,00
  NEC > 3,75 (grasse)    : 0,78

f_bilan_énergétique :
  Positif                : 1,00
  Légèrement négatif     : 0,88
  Fortement négatif      : 0,65  ⚠️ vache qui perd du poids = ne se féconde pas

f_santé_utérine :
  Pas de métrite         : 1,00
  Métrite au vêlage      : 0,72

f_moment_insémination :
  12-18 h après le début des chaleurs : 1,00
  Trop tôt ou trop tard               : 0,70
  (uniquement si détection visuelle — les capteurs optimisent le moment)

f_stress_thermique (été, THI > 72) : 0,72  ⚠️ effet majeur
```

**c) Indicateurs de reproduction (Expert)**
```
┌─ Bilan reproduction — Troupeau ───────────────────────────────┐
│                                                                │
│  IVV moyen (Intervalle Vêlage-Vêlage)    402 j    🟡 (obj 385) │
│  Intervalle vêlage-1ère IA                78 j    ✅            │
│  Taux de réussite 1ère IA                 46%     🟡 (obj 50%) │
│  Nombre d'IA par gestation                2,1     🟡 (obj 1,8) │
│  Taux de détection des chaleurs           68%     🟠 (obj 85%) │
│  Taux de vaches non gestantes > 120 j     12%     🟡 (obj 8%)  │
│  Taux d'avortements                        3%     ✅            │
│  Âge au 1er vêlage (génisses)             26 m    🟡 (obj 24 m)│
│                                                                │
│  ── Coût de la sous-performance ──                             │
│  IVV de 402 j au lieu de 385 j = 17 jours × 60 VL × 3 €        │
│  = 3 060 €/an de manque à gagner                               │
│                                                                │
│  💡 Action prioritaire : améliorer la détection des chaleurs    │
│     Investissement colliers (60 × 110 € = 6 600 €)              │
│     Gain estimé : détection 68% → 90%                           │
│     IVV : 402 → 388 j → +2 520 €/an                             │
│     ROI : 2,6 ans ✅                                             │
│                                                                │
│  [ Voir les vaches à problème ]  [ Investir en colliers ]      │
└────────────────────────────────────────────────────────────────┘
```

**d) Génétique et progression**
```
Chaque animal a des index (échelle 100 = moyenne de la race) :
  ISU        : index de synthèse global
  INEL       : index économique laitier
  Lait (kg)  : potentiel de production
  TB / TP    : taux
  Morphologie: mamelle, aplombs
  Cellules   : résistance aux mammites
  Fertilité  : aptitude à se reproduire
  Longévité  : durée de carrière

Transmission : index_veau = (index_mère + index_père) / 2 + aléa(-8 à +8)

Progression réaliste : +1,5 à +2,5 points d'ISU par an avec une bonne sélection
→ Sur 10 ans : +20 points d'ISU = +400 kg de lait/vache
→ C'est un objectif de jeu long terme satisfaisant
```

**e) Semence sexée (stratégie Expert)**
```
Semence sexée : +36 € par dose, taux de réussite -8%, 90% de femelles

Stratégie optimale :
  • Génisses et meilleures vaches → semence sexée (produire les futures laitières)
  • Vaches moyennes → semence conventionnelle
  • Vaches à réformer → croisement viande (Charolais, Limousin)
    → veau croisé vendu 180 € au lieu de 95 € pour un veau laitier mâle

Exemple sur 60 VL :
  20 vaches en sexée (les meilleures)  → 18 génisses de qualité
  25 vaches en conventionnel           → 12 génisses + 13 mâles
  15 vaches en croisement viande       → 15 veaux croisés (+1 275 € de plus-value)
  
  Total génisses : 30 (besoin : 24 pour le renouvellement)
  → 6 génisses excédentaires à vendre (2 200 € chacune = 13 200 €)
```

### 6.4 Renouvellement du troupeau

**Taux de renouvellement** :
```
taux_renouvellement = nb_vaches_réformées / nb_vaches_total

Référence France : 32-38%
  → Pour 60 VL : 20-23 vaches réformées par an
  → Il faut donc 20-23 génisses qui vêlent chaque année

Un taux trop élevé (> 40%) :
  ❌ Coûteux (une génisse coûte 1 800 € à élever)
  ❌ Troupeau jeune = production plus faible
  
Un taux trop faible (< 25%) :
  ❌ Troupeau vieillissant = plus de problèmes de santé
  ❌ Progression génétique ralentie
```

**Décision de réforme (Expert)** :
```
┌─ Vaches candidates à la réforme ──────────────────────────────┐
│                                                                │
│  #87 Noisette — 8 ans, 6e lactation                            │
│    Production : 6 200 L (vs 8 900 moyenne troupeau) 🔴          │
│    Cellules : 480 000/mL 🔴 (pénalité -0,030 €/L)               │
│    Non gestante depuis 145 j 🔴                                 │
│    Valeur boucherie : 980 €                                     │
│    → RÉFORME RECOMMANDÉE (coûte plus qu'elle ne rapporte)       │
│                                                                │
│  #124 Perle — 6 ans, 4e lactation                              │
│    Production : 9 850 L ✅ (excellente)                          │
│    Cellules : 145 000/mL ✅                                      │
│    Boiterie chronique 🟡                                        │
│    → À CONSERVER (bonne productrice, traiter la boiterie)       │
│                                                                │
│  #201 Tulipe — 3 ans, 1re lactation                            │
│    Production : 5 800 L 🟡 (faible pour une primipare)          │
│    Index ISU : 88 🔴 (sous la moyenne)                          │
│    → RÉFORME À ENVISAGER (mauvaise génétique, n'améliorera pas) │
│                                                                │
│  [ Réformer la sélection ]  [ Voir le troupeau complet ]       │
└────────────────────────────────────────────────────────────────┘
```

**Valorisation des animaux** :

| Animal | Prix de vente |
|--------|:-------------:|
| Veau mâle laitier (15 j) | 85-110 € |
| Veau croisé viande (15 j) | 160-220 € |
| Génisse pleine (22 mois) | 1 900-2 400 € |
| Vache de réforme (bon état) | 950-1 300 € |
| Vache de réforme (maigre) | 600-850 € |
| Vache de réforme Montbéliarde/Normande | +15% (meilleure conformation) |

---

## 7. Santé et bien-être

### 7.1 Mode Normal — Jauge de santé + prévention

```
Santé : jauge 0-100%

Diminue si :
  Ration insuffisante        : -3%/jour
  Litière insuffisante       : -2%/jour
  Bâtiment surchargé         : -1%/jour
  Pas d'eau                  : -8%/jour

Remonte si :
  Conditions correctes       : +2%/jour
  Soins vétérinaires         : +25% (action, 45 €/vache)

Effets de la santé :
  > 80%  : production normale
  50-80% : production -12%
  < 50%  : production -30%, risque de mortalité 2%/mois
```

**Prévention (Normal)** :
```
Vaccination annuelle (BVD, IBR) : 28 €/vache → évite les épizooties
Parage des onglons (2×/an)      : 22 €/vache → évite les boiteries
Vermifugation (1×/an)           : 12 €/vache → maintient la santé
Visite vétérinaire annuelle     : 180 € forfait → obligatoire (réglementaire)
```

### 7.2 Mode Expert — Maladies spécifiques

**a) Les 4 maladies principales**

| Maladie | Fréquence | Coût/cas | Effet | Prévention |
|---------|:---------:|:--------:|-------|------------|
| **Mammite clinique** | 25-40 cas/100 VL/an | 220 € | Lait jeté 5 j, -8% lactation | Hygiène traite, litière propre |
| **Boiterie** | 20-30 cas/100 VL/an | 150 € | -15% production, fertilité -20% | Parage, pédiluve, sol non glissant |
| **Métrite** | 15-25 cas/100 VL/an | 130 € | Fertilité -28% | Hygiène au vêlage |
| **Cétose** | 10-20 cas/100 VL/an | 180 € | -20% production, amaigrissement | Ration de transition |

**b) Mammites et cellules somatiques**
```
Comptage cellulaire individuel (CCI) suivi mensuellement :

  < 100 000/mL  : ✅ vache saine
  100-250 000   : 🟡 infection latente
  250-500 000   : 🟠 infection subclinique (-5% production)
  > 500 000     : 🔴 infection installée (-12% production, pénalité de prix)

Le comptage du TANK est la moyenne pondérée du troupeau :
  Si > 300 000/mL → pénalité sur toute la collecte
  Si > 400 000/mL sur 3 mois → suspension de la collecte ⚠️

→ Une seule vache très infectée peut pénaliser tout le troupeau
→ Le joueur doit identifier et traiter (ou réformer) les vaches à problème

Facteurs de risque :
  Litière sale                  : ×2,5
  Traite mal réalisée           : ×2,0
  Surpopulation du bâtiment     : ×1,8
  Chaleur (été)                 : ×1,6
  Vache âgée (> 5e lactation)   : ×1,5
  Génétique (index cellules < 95): ×1,4
```

**c) Antibiotiques et labels**
```
Traitement antibiotique :
  Lait non commercialisable pendant 5-8 jours (délai d'attente)
  Coût : 45-90 € par traitement
  Si le lait traité est collecté par erreur → toute la collecte est refusée ⚠️

Réduction des antibiotiques :
  Compteur d'usage annuel affiché
  Label "élevage sans antibiotique" : +0,015 €/L (contrainte : 0 traitement/an)
  Bio : usage limité à 3 traitements/vache/an maximum
  
→ Arbitrage : soigner (coût + lait perdu) ou réformer (perte de la vache)
```

**d) Bien-être animal (Expert)**
```
Score de bien-être calculé sur 5 critères :

  Espace disponible     : 9-12 m²/VL (logette + aire d'exercice)
  Accès à l'eau         : 1 abreuvoir pour 15 VL max
  Confort de couchage   : logettes avec matelas > tapis > béton
  Accès à l'extérieur   : pâturage ou aire d'exercice
  Absence de mutilation : écornage précoce sous anesthésie

Score > 80% :
  ✅ Production +3%
  ✅ Longévité +0,5 lactation
  ✅ Accès aux labels bien-être (+0,020 €/L)

Score < 50% :
  ❌ Production -8%
  ❌ Mammites ×1,6
  ❌ Réformes précoces
  ❌ Risque de contrôle et de sanction
```

### 7.3 Équilibrage

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Modèle de santé | 1 jauge 0-100% | Jauge + 4 maladies spécifiques |
| Mammites | Non modélisées | Fréquence, cellules, coût, pénalité de prix |
| Cellules du tank | Non | Oui (pénalité collective) |
| Boiteries | Non | Oui (parage préventif) |
| Coût vétérinaire/VL/an | 62 € | 85-130 € |
| Antibiotiques | Non suivis | Compteur + labels |
| Bien-être | Non | Score 5 critères, impact production |
| Mortalité | 2%/mois si santé < 50% | 3-5%/an (réaliste) |

### 7.3 Catalogue des vaccinations

Le joueur peut (et devrait) vacciner son troupeau de façon préventive. Chaque vaccin protège contre une maladie spécifique pendant une durée déterminée.

#### Vaccins disponibles

| Vaccin | Maladie couverte | Coût/animal | Durée protection | Rappel | Catégories concernées |
|--------|-----------------|:-----------:|:----------------:|:------:|:---------------------:|
| BVD (diarrhée virale) | BVD | 12 € | 12 mois | Annuel | VL + génisses > 6 mois |
| IBR (rhinotrachéite) | IBR | 15 € | 12 mois | Annuel | Tout le troupeau |
| Fièvre catarrhale (FCO) | FCO sérotypes 4/8 | 8 € | 12 mois | Annuel | Tout le troupeau |
| Rotavirus/Coronavirus | Diarrhées néonatales | 18 € | Gestation en cours | Par gestation | Vaches gestantes (8e mois) |
| Entérotoxémies (Clostridies) | Entérotoxémie | 6 € | 6 mois | Semestriel | Veaux + génisses |
| Pasteurellose | Pneumonie | 10 € | 12 mois | Annuel | Veaux + jeunes bovins |

#### Effets de la vaccination

| Statut vaccinal | Effet sur la santé | Effet sur la production |
|:---------------:|:------------------:|:-----------------------:|
| Non vacciné | Risque épizootie 8%/an (BVD/IBR), -30% production si touché | Pertes potentielles : 2-5 vaches/an + 15 jours sans collecte |
| Vacciné (protocole complet) | Risque résiduel 0,5%/an | Production stable, pas de suspension de collecte |
| Vaccin expiré (retard > 30 j) | Protection dégradée (50% d'efficacité) | Risque intermédiaire |

#### Mécanique de vaccination

```
Action "Vacciner le troupeau" :
  Temps : (nb_animaux × 3 min) + 15 min préparation
  Exemple 60 VL + 40 génisses : (100 × 3 min) + 15 min = 5 h 15

  Coût total annuel (protocole BVD + IBR + FCO, 100 animaux) :
    = 100 × (12 + 15 + 8) = 3 500 €/an

  Coût si non-vacciné et épizootie BVD :
    = 8 vaches infectées × 220 €/traitement + 15 j sans collecte (1 452 L/j × 0,43 € × 15)
    = 1 760 + 9 375 = 11 135 € de perte
    → La vaccination est TOUJOURS rentable
```

**Mode Normal** : action « Vacciner » annuelle, forfait affiché, rappel automatique. Alerte si le vaccin expire.

**Mode Expert** : le joueur choisit quels vaccins administrer, peut cibler par lot. Un oubli de rappel expose le troupeau.

#### Vermifugation et parage (compléments sanitaires)

| Soin préventif | Fréquence | Coût/animal | Temps | Effet si négligé |
|----------------|:---------:|:-----------:|:-----:|-----------------|
| Vermifugation | 1×/an (rentrée bâtiment) | 12 € | 2 min/animal | Santé -8%/mois, production -6% |
| Parage des onglons | 2×/an | 22 € | 8 min/animal | Boiterie +15 cas/100 VL/an |
| Visite vétérinaire | 1×/an (obligatoire) | 180 € forfait | 2 h | Réglementaire — pas de vente sans certificat |


---

## 8. Bâtiments et équipements

### 8.1 Le bâtiment d'élevage

**Types de logement** :

| Type | Surface/VL | Prix/place | Litière | Effluent |
|------|:----------:|:----------:|---------|----------|
| **Logettes + matelas** | 9 m² | 5 200 € | Sciure (0,5 kg/j) | Lisier |
| **Logettes + paille** | 9 m² | 4 800 € | Paille (2 kg/j) | Fumier |
| **Aire paillée intégrale** | 12 m² | 4 200 € | Paille (12 kg/j) | Fumier |
| **Aire paillée + aire raclée** | 10 m² | 4 600 € | Paille (7 kg/j) | Mixte |
| **Stabulation libre caillebotis** | 6 m² | 5 800 € | Aucune | Lisier |

**Arbitrages** :
```
Logettes + matelas : confort maximal, peu de litière, mais investissement élevé
                     → optimal pour un grand troupeau performant

Aire paillée       : très bon confort, beaucoup de paille (coût + travail),
                     produit du fumier (excellent pour les cultures)
                     → optimal si le joueur a de la paille disponible

Caillebotis        : pas de litière, peu de travail, mais confort moindre
                     (boiteries ×1,5), lisier à gérer (plafond N)
                     → optimal en système intensif hors-sol
```

**Coût d'un bâtiment 60 VL** :
```
60 places en logettes + matelas         312 000 €
Salle de traite 2×8                     105 000 €
Tank à lait 4 500 L                      54 000 €
Fosse à lisier 1 200 m³                  72 000 €
Silos couloir (2 × 400 t)                58 000 €
Aire d'exercice + accès                  24 000 €
──────────────────────────────────────────────────
TOTAL                                   625 000 €
= 10 417 € par place de vache
```

### 8.2 Équipements

| Équipement | Prix | Bénéfice |
|-----------|:----:|----------|
| Racleur automatique | 18 000 € | -0,5 h/jour, propreté (mammites -20%) |
| Mélangeuse traînée 14 m³ | 42 000 € | Ration homogène (+4% production) |
| Robot d'alimentation | 165 000 € | 6-8 repas/jour (+6%), -1 h/jour |
| Ventilateurs (6 unités) | 18 000 € | Anti-stress thermique (+1 L/VL en été) |
| Brumisation | 12 000 € | Complément anti-chaleur |
| Récupérateur de chaleur | 8 000 € | -40% coût eau chaude |
| Pédiluve automatique | 6 500 € | Boiteries -35% |
| Colliers d'activité (60) | 6 600 € | Détection chaleurs 68% → 90% |
| Distributeur automatique de concentré | 14 000 € | Concentré individualisé (+3%) |
| Cornadis autobloquants | 150 €/place | Contention pour les soins |
| Brosse rotative | 1 800 € | Bien-être (+1% production) |

### 8.3 Le pâturage

**Mode Normal** :
```
Mettre les vaches au pré (avril-octobre) :
  ✅ Coût alimentaire -60%
  ✅ Bien-être +15%
  ✅ Éligible au label "pâturage" (+0,015 €/L)
  ⚠️ Production -8% (l'herbe est moins dense que l'ensilage de maïs)
  ⚠️ Nécessite 35-45 ares/VL accessibles depuis le bâtiment

Le joueur clique « Mettre au pré » / « Rentrer ».
```

**Mode Expert — pâturage tournant** :
```
Découpage en paddocks :
  Nombre optimal : 6-8 paddocks
  Surface/paddock : 60 VL × 40 ares / 7 = 3,4 ha
  Temps de séjour : 2-3 jours par paddock
  Temps de repos : 18-24 jours (repousse de l'herbe)

Croissance de l'herbe (kg MS/ha/jour) :
  Avril     : 45-70
  Mai       : 70-95   ← pic de croissance
  Juin      : 50-70
  Juillet   : 20-40   ⚠️ ralentissement estival
  Août      : 15-35   ⚠️ souvent sec
  Septembre : 30-50
  Octobre   : 20-35

Gestion Expert :
  • Mesurer la hauteur d'herbe (herbomètre) avant d'entrer dans un paddock
  • Entrée à 12-15 cm, sortie à 5-6 cm (ne pas surpâturer)
  • Faucher les refus si nécessaire
  • Complémenter en été quand l'herbe manque
  • Débrayer des paddocks au printemps pour faire du foin (excédent de croissance)

→ Le pâturage bien géré est le système le plus économique
→ Mal géré, il pénalise fortement la production
```

---

## 9. Équilibrage et scénarios

### 9.1 Objectifs d'équilibrage

| Objectif | Cible |
|----------|-------|
| Marge/1000 L (Normal) | 120-180 € |
| Marge/1000 L (Expert optimisé) | 160-230 € |
| Coût alimentaire | 45-60% du produit lait |
| Revenu pour 60 VL (Normal) | 38 000-45 000 € |
| Le robot de traite est rentable | Oui, dès 55 VL |
| Le pâturage est compétitif | Oui (moins de production mais bien moins de charges) |
| Progression génétique visible | +20 pts d'ISU sur 10 ans |

### 9.2 Scénario A — 60 VL en mode Normal, système maïs

```
TROUPEAU : 60 Prim'Holstein, 8 500 L/VL/an, ration équilibrée

PRODUITS
  Lait : 60 × 8 500 L × 0,43 €              219 300 €
  Veaux mâles (28 × 95 €)                     2 660 €
  Génisses excédentaires (6 × 2 100 €)       12 600 €
  Vaches de réforme (20 × 1 050 €)           21 000 €
  Aides PAC (105 ha × 150 € + 60 × 35 €)     17 850 €
  ──────────────────────────────────────────────────
  PRODUIT BRUT                              273 410 €

CHARGES OPÉRATIONNELLES
  Alimentation achetée (concentrés, tourteaux) -48 000 €
  Frais vétérinaires + repro                   -8 400 €
  Litière (paille achetée)                     -6 200 €
  Frais d'élevage (contrôle laitier, ID)       -4 100 €
  Cultures fourragères (semences, engrais)    -32 000 €
  Carburant                                   -14 500 €
  ──────────────────────────────────────────────────
  Total opérationnel                         -113 200 €

CHARGES DE STRUCTURE
  Amortissement bâtiment + matériel           -52 000 €
  Fermage (105 ha × 175 €)                    -18 375 €
  Électricité, eau                             -9 800 €
  Assurances                                   -6 400 €
  Frais financiers                             -8 900 €
  Entretien                                   -11 200 €
  ──────────────────────────────────────────────────
  Total structure                            -106 675 €

RÉSULTAT
  Bénéfice avant charges sociales              53 535 €
  Charges sociales (12%)                       -6 424 €
  ──────────────────────────────────────────────────
  BÉNÉFICE NET                                 47 111 €

INDICATEURS
  Marge/1000 L : (219 300 - 113 200) / 510 = 208 €/1000 L
  Coût alimentaire : 48 000 / 510 = 94 €/1000 L
  Temps de travail : 2 100 h/an (dont 912 h de traite)
```
✅ **Validé** : revenu confortable, cohérent avec la réalité (35-50 k€).

### 9.3 Scénario B — Même troupeau, mode Expert optimisé

```
Optimisations du joueur :
  • Ration calculée précisément (coût -12%, production +4%)
  • Colliers de détection (IVV 402 → 386 j)
  • Semence sexée sur les meilleures vaches
  • Ventilation installée (anti-stress thermique)
  • TP amélioré par la sélection génétique (32,0 → 33,8 g/L)
  • Cellules maîtrisées (185 000/mL → prime qualité)
  • Croisement viande sur les vaches à réformer

PRODUITS
  Lait : 60 × 8 950 L × 0,468 €              251 316 €  (+32 016 €)
    (prix majoré : TP +1,8 pts = +0,0162, cellules +0,008)
  Veaux croisés viande (15 × 190 €)            2 850 €
  Veaux mâles laitiers (8 × 95 €)                760 €
  Génisses excédentaires (8 × 2 200 €)        17 600 €
  Vaches de réforme (20 × 1 120 €)            22 400 €
  Aides PAC + éco-régime                      24 400 €
  ──────────────────────────────────────────────────
  PRODUIT BRUT                               319 326 €

CHARGES
  Alimentation (optimisée -12%)               -42 240 €
  Frais véto + repro (+ colliers amortis)      -9 800 €
  Litière                                      -6 200 €
  Frais d'élevage + génétique                  -6 400 €
  Cultures fourragères                        -32 000 €
  Carburant                                   -14 500 €
  Amortissements (+ ventilation, colliers)    -56 100 €
  Fermage                                     -18 375 €
  Électricité (+ ventilation)                 -11 200 €
  Assurances                                   -6 400 €
  Frais financiers                             -9 600 €
  Entretien                                   -11 200 €
  ──────────────────────────────────────────────────
  TOTAL CHARGES                              -224 015 €

RÉSULTAT
  EBE                                          95 311 €
  Revenu professionnel (après amortissements)  39 211 €
  MSA (28%)                                   -10 979 €
  IR                                           -3 100 €
  ──────────────────────────────────────────────────
  REVENU DISPONIBLE                            25 132 €
```

⚠️ **Analyse** : le produit brut Expert est bien supérieur (+45 916 €) mais les charges sociales (28% + IR) réduisent le revenu disponible sous celui du mode Normal (47 111 €).

**Contexte historique** : ce constat a initialement motivé l'ADR-003. Depuis l'ADR-005 (serveurs séparés), cette comparaison est informative et non contraignante. Chaque serveur doit être internement équilibré et plaisant. Le mode Expert apporte compréhension, contrôle et profondeur ; son avantage apparaît sur les grandes structures, le temps libéré, le long terme et la gestion de crise.

**Vérification avec le levier principal — le robot de traite** :
```
Le joueur Expert investit dans un robot (165 000 €) :
  + Production +10% (2,8 traites/jour) : 8 950 → 9 845 L/VL
  + 732 h libérées → il peut cultiver 40 ha de plus OU faire de la prestation ETA
  
  Lait : 60 × 9 845 × 0,468 €              276 488 €  (+25 172 €)
  Prestation ETA (300 h × 55 €/h)           16 500 €
  - Charges robot (amortissement + conso)   -18 500 €
  ────────────────────────────────────────────────
  Gain net                                  +23 172 €
  
  Revenu disponible : 22 387 + 23 172 × 0,53 (net de charges) = 34 668 €
```

**Comparaison finale** :
| Profil | Produit brut | Revenu net | Temps de travail |
|--------|:------------:|:----------:|:----------------:|
| Normal appliqué | 273 410 € | 47 111 € | 2 100 h |
| Expert optimisé (sans robot) | 319 326 € | 25 132 € | 2 100 h |
| Expert optimisé + robot | 361 326 € | 38 716 € | 1 670 h |

⚠️ **Le mode Normal reste plus rentable en net sur cette structure.** C'est structurellement dû à l'écart de charges sociales (12% vs 28% + IR). Cette comparaison est informative — les deux serveurs étant séparés (ADR-005), aucune équivalence de rentabilité n'est requise.

**Décision d'équilibrage historique (ADR-003, contrainte levée par ADR-005)** :
```
Ce constat s'est répété dans les 4 premiers GDD. Le problème était GLOBAL,
donc la solution devait être globale et non spécifique au bovin laitier.

Options examinées :
  A. Réduire les charges Expert de 35% à 28%        → RETENUE (partiellement)
  B. Augmenter les charges Normal de 12% à 18%      → REJETÉE (viole ADR-002)
  C. Ajouter un bonus de revenu Expert artificiel   → REJETÉE (factice)
  D. Assumer que Expert ≠ plus rentable             → RETENUE (principalement)

DÉCISION HISTORIQUE (ADR-003, désormais informative — serveurs séparés, cf. ADR-005) :
  1. Charges Expert ramenées à 28% — justification : la MSA réelle est de
     35-45% mais s'applique après de nombreuses déductions non modélisées
     (DEP, amortissements dégressifs, déficits reportables, statut sociétaire).
     28% représente le taux effectif réel d'un exploitant qui optimise.

  2. Chaque serveur doit être internement équilibré et plaisant.
     Le mode Expert apporte compréhension, contrôle et profondeur.
     Son avantage se manifeste sur :
       • les grandes structures (> 100 VL) où l'optimisation se démultiplie
       • le temps libéré (robot → diversification)
       • le long terme (progression génétique cumulative)
       • la gestion de crise (le joueur Expert sait réagir)
```

**Analyse du cas « Expert + robot »** :
```
Le robot de traite est le levier qui change la donne :
  + 10% de production (2,8 traites/jour au lieu de 2)
  + 732 h libérées → diversification possible (cultures, prestation ETA)
  
Revenu professionnel        62 383 €
MSA (28%)                  -17 467 €
IR                          -6 200 €
──────────────────────────────────
REVENU DISPONIBLE           38 716 €   (vs 47 111 € en Normal)
+ valorisation des 732 h libérées (prestation ETA à 55 €/h,
  300 h réalisables) : +16 500 € brut, soit +11 880 € net
──────────────────────────────────
TOTAL EXPERT + DIVERSIFICATION       50 596 €   ← dépasse Normal ✅
```

**Conclusion** : sur une structure de 60 VL, le mode Expert n'est rentable que si le joueur **valorise le temps libéré**. C'est exactement le raisonnement d'un éleveur qui investit dans un robot : il ne le fait pas pour produire plus, mais pour se libérer du temps.

**Conclusion d'équilibrage retenue** :
```
Le mode Expert n'est PAS toujours plus rentable en euros.
Il est plus rentable :
  ✅ Sur les grandes structures (> 100 VL)
  ✅ Quand le joueur valorise le temps libéré (diversification)
  ✅ Sur le long terme (progression génétique cumulative)
  ✅ En situation de crise (le joueur Expert sait réagir)

C'est un choix de STYLE DE JEU, pas une hiérarchie de performance.
Les serveurs étant séparés (ADR-005), cette analyse est informative.
L'essentiel est que chaque serveur soit internement équilibré et plaisant.
→ Cohérent avec ADR-001 : "Expert = profondeur, pas supériorité"
→ Cohérent avec ADR-002 : "Normal reste pleinement viable et gratifiant"
→ Cohérent avec ADR-005 : "Aucune comparaison de rentabilité inter-serveurs requise"
```

### 9.4 Scénario C — Système pâturant (60 VL, mode Normal)

```
TROUPEAU : 60 Montbéliardes, 6 800 L/VL, pâturage 7 mois

PRODUITS
  Lait : 60 × 6 800 × 0,43 €                175 440 €
  Veaux + génisses + réformes (mieux valorisées) 42 000 €
  Aides PAC (85 ha)                          14 600 €
  ──────────────────────────────────────────────────
  PRODUIT BRUT                              232 040 €

CHARGES
  Alimentation achetée (bien moindre)        -22 000 €
  Cultures fourragères (moins de maïs)       -14 000 €
  Frais véto (troupeau plus rustique)         -6 200 €
  Litière                                     -4 800 €
  Carburant (moins de mécanisation)           -9 200 €
  Amortissements (bâtiment plus simple)      -34 000 €
  Fermage (85 ha)                            -14 875 €
  Autres charges                             -28 400 €
  ──────────────────────────────────────────────────
  TOTAL                                     -133 475 €

RÉSULTAT
  Bénéfice avant charges                      98 565 €
  Charges sociales (12%)                     -11 828 €
  ──────────────────────────────────────────────────
  BÉNÉFICE NET                                86 737 €  ⚠️ TROP ÉLEVÉ
```

⚠️ **Le système pâturant est trop rentable.** Il faut le rééquilibrer :
```
Corrections :
  • Le pâturage nécessite plus de surface accessible (contrainte foncière)
  • Production réduite davantage : -12% au lieu de -8%
  • Risque de sécheresse estivale (production -20% en juillet-août certaines années)
  • Aléa climatique plus fort (dépendance à la pousse de l'herbe)

Recalcul : lait 60 × 6 200 L × 0,43 = 159 960 €
  → Bénéfice net : 72 300 €
  
Toujours élevé mais justifié par : moins de production, plus de dépendance
climatique, contrainte foncière forte (85 ha accessibles obligatoires).
```

### 9.5 Points à valider en playtest

**Recette SimAgri (ADR-002)**
- [ ] La traite quotidienne est-elle une routine agréable ou une corvée ?
- [ ] Le joueur s'attache-t-il à ses vaches (nommage, suivi) ?
- [ ] La courbe de lactation est-elle comprise sans explication ?
- [ ] Le joueur Normal peut-il gérer 60 VL sans se sentir dépassé ?
- [ ] Les alertes sont-elles utiles ou envahissantes ?

**Profondeur Expert**
- [ ] Le calcul de ration est-il satisfaisant ou fastidieux ?
- [ ] L'optimisation du TP est-elle un levier compris et exploité ?
- [ ] La gestion de la reproduction (IVV) crée-t-elle un objectif clair ?
- [ ] La progression génétique sur 10 ans est-elle motivante ?
- [ ] Le robot de traite est-il un palier de progression désirable ?

---

## Annexe — Récapitulatif des paramètres

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Courbe de lactation | 5 paliers | Modèle de Wood |
| Rang de lactation | 3 niveaux | Paramètres a/b/c par rang |
| Tarissement | Automatique | Fenêtre 55-65 j + ration spécifique |
| Qualité du lait | 3 niveaux (±8%) | TB/TP/cellules (-14% à +12%) |
| Stress thermique | Non | Oui (THI) |
| Ration | 3 choix prédéfinis | Calcul UFL/PDI/MS/fibres/amidon |
| Capacité d'ingestion | Non | Oui (contrainte) |
| Risques nutritionnels | Non | Acidose, cétose, excès N, tétanie |
| Traite | 1 action selon la salle | + intervalle, 2× ou 3×, monotraite |
| Robot de traite | Disponible (+10%) | + taux de fréquentation, vaches difficiles |
| Détection chaleurs | Automatique | 5 méthodes (50% à 95%) |
| Fertilité | Taux fixe 55-65% | 7 facteurs modulants |
| Indicateurs repro | Non | IVV, taux de réussite, 8 KPI |
| Génétique | Indice global | 8 index détaillés |
| Semence sexée | Disponible | + stratégie par catégorie |
| Maladies | Jauge de santé | 4 maladies spécifiques |
| Cellules du tank | Non | Oui (pénalité collective) |
| Bien-être | Non | Score 5 critères |
| Pâturage | Bouton, -60% de coût | Pâturage tournant, paddocks, herbomètre |
| Charges sociales | 12% | 28% (révisé, cf. §9.3) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | — |
| 2026-08-04 | Charges Expert 35% → 28% (à valider transversalement) | Le scénario B montrait un revenu Expert structurellement inférieur |
| 2026-08-04 | Production pâturage -8% → -12%, ajout aléa sécheresse | Le système pâturant était trop rentable (86 737 €) |
| 2026-08-04 | Clarification : Expert = style de jeu, pas supériorité économique | Cohérence avec ADR-001 et ADR-002 |
| 2026-08-04 | Ajout §2.6 Enclos d'attente, §5.5 Robot d'alimentation, §7.3 Catalogue vaccinations | Audit couverture fonctionnelle — complétion des systèmes partiels |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |