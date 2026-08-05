> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Espèces Secondaires d'Élevage

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : docs/research/reality-vs-simagri-elevage.md (§6-7), GDD-poulet-chair, ADR-001, ADR-002, ADR-003, ADR-004

---

## 1. Vision et positionnement

### Intention de design

Les espèces secondaires sont des **voies de diversification et de niche**. Chacune apporte une identité de gameplay propre, irréductible aux filières principales (bovin, porc, ovin, caprin, poulet de chair).

**Principe directeur** : une espèce secondaire ne doit PAS être un copier-coller d'une espèce principale avec des chiffres différents. Chacune a une mécanique centrale unique.

| Espèce | Identité de gameplay | Mécanique centrale |
|--------|---------------------|-------------------|
| Poule pondeuse | Flux quotidien régulier | Déclin de ponte → décision de réforme |
| Équins | Cycle très long, prestige | Génétique × temps = valorisation |
| Lapins | Cycle ultra-court, prolificité | Bandes rapides, risque sanitaire |
| Pintade | Niche saisonnière française | Timing de mise en marché (Noël) |
| Oie / Canard | Produits premium (foie gras, duvet) | Saisonnalité + transformation |
| Bison / Daim | Élevage passif, niche exotique | Investissement clôture vs temps minimal |

### Ce que SimAgri fait bien (à garder)

- ✅ Poule pondeuse existante avec calibres par âge
- ✅ Large catalogue de races équines (35+)
- ✅ Bisons et daims comme espèces exotiques de collection
- ✅ Robot de ramassage d'œufs

### Ce que SimAgri fait mal (à corriger)

- ❌ Pas de déclin de ponte ni de réforme des pondeuses
- ❌ Prix des doses IA équines irréalistes (30-120 € vs 200-15 000 € réels)
- ❌ Pas de lapins
- ❌ Pintades/oies/canards sans mécanique propre
- ❌ Bisons/daims = mêmes mécaniques que les bovins

---

## 2. Poule Pondeuse — Production d'Œufs

### Concept fondamental

La poule pondeuse est l'**anti-poulet de chair**. Pas de cycle d'abattage, pas de lot vendu en bloc. C'est un **flux quotidien** : chaque jour, le joueur récolte des œufs. La mécanique centrale est le **déclin de ponte** et la **décision de réforme**.

**Plaisir procuré** : revenu régulier et prévisible. Le joueur voit ses œufs s'accumuler chaque jour. C'est la « rente » de l'élevage — stable, rassurante, mais qui s'érode avec le temps.

### Gameplay loop

```
┌──────────────────────────────────────────────────────────────────────┐
│              CYCLE DE VIE D'UN LOT DE PONDEUSES                       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ACHAT POULETTES ──→ ENTRÉE EN PONTE ──→ PIC ──→ DÉCLIN ──→ RÉFORME │
│   (17 semaines)      (18-20 sem.)    (24-30s)  (30-72s)   (72-90s)  │
│        │                  │              │          │           │      │
│        ▼                  ▼              ▼          ▼           ▼      │
│   Choix système      Premiers œufs   95-97%    -0,5%/sem   Vendre ?  │
│   Choix effectif     Calibre S       Calibre M  Calibre L   Continuer│
│   Investissement     Revenu démarre  Revenu max Revenu ↓    ou stop? │
│                                                                       │
│  QUOTIDIEN : ramassage → conditionnement → stockage → vente          │
│  HEBDO : vérifier taux de ponte, ajuster alimentation                │
│  ANNUEL : décider réforme, commander lot suivant                     │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

### Les décisions du joueur

| Moment | Décision | Impact |
|--------|----------|--------|
| Installation | Système d'élevage (cage/sol/plein-air/bio) | Investissement, prix œuf, contraintes |
| Achat | Effectif du lot | Capacité bâtiment, revenu, charge travail |
| Quotidien | Ramassage manuel ou automatisé | Temps de travail vs investissement |
| Hebdomadaire | Vérifier stock aliment, DLC œufs | Continuité de production |
| Après 52 sem. | Continuer ou réformer le lot | Rentabilité marginale décroissante |
| Réforme | Timing de réforme (72-90 sem.) | Maximiser le nombre d'œufs total |

### Différence Normal / Expert

| Aspect | Mode Normal | Mode Expert |
|--------|-------------|-------------|
| Taux de ponte | Courbe automatique (pas de levier) | Influencé par lumière, stress, alimentation |
| Calibres | Évolution automatique avec l'âge | Optimisable (alimentation calcium) |
| Mortalité | 5% fixe sur le cycle | 3-10% selon conduite |
| Ramassage | Automatique (robot inclus) | Manuel ou robot (investissement séparé) |
| Réforme | Conseil affiché (« lot non rentable ») | Calcul coût marginal vs recette |
| Charges | 12% forfaitaires | 28% détaillées (aliment, énergie, véto) |
| Programme lumineux | Automatique | Réglable (impact ponte) |



### Les 4 systèmes d'élevage

| Paramètre | Cage aménagée | Sol / Volière | Plein-air | Bio |
|-----------|:------------:|:------------:|:---------:|:---:|
| Surface intérieure | 750 cm²/poule | 9 poules/m² | 9 poules/m² | 6 poules/m² |
| Parcours extérieur | Non | Non | 4 m²/poule | 4 m²/poule |
| Effectif max/bâtiment | 60 000 | 9 000 | 9 000 | 6 000 |
| Alimentation | Conventionnelle | Conventionnelle | Conventionnelle | 100% bio |
| Prix œuf (€/unité) | 0,08-0,12 | 0,10-0,15 | 0,15-0,22 | 0,25-0,35 |
| Investissement/place | 25-35 € | 35-50 € | 45-60 € | 55-75 € |
| Tendance marché | En déclin (fin 2030) | Stable | En hausse | En hausse |
| Code marquage | 3 | 2 | 1 | 0 |

**Cage aménagée** : volume pur, marge unitaire minimale. Gameplay : économie d'échelle.
**Sol/Volière** : compromis volume/bien-être. Pas de parcours = moins de surface.
**Plein-air** : le standard français en croissance. Parcours = investissement clôture.
**Bio** : prix premium, contraintes fortes (aliment bio +40%, densité réduite).

**Mode Normal** : le joueur choisit un système. Les contraintes sont appliquées automatiquement.
**Mode Expert** : le joueur gère la rotation des parcours (plein-air/bio) pour éviter la dégradation du sol.

### Performances de ponte

| Période (semaines) | Taux de ponte | Calibre dominant | Poids œuf moyen |
|:------------------:|:------------:|:---------------:|:---------------:|
| 18-20 (entrée en ponte) | 50-80% (montée) | S | 50-53 g |
| 20-24 (montée) | 80-95% | S/M | 53-58 g |
| 24-30 (pic) | 95-97% | M | 58-63 g |
| 30-52 (plateau) | 90-95% | M/L | 63-68 g |
| 52-65 (déclin) | 85-90% | L | 68-72 g |
| 65-72 (déclin avancé) | 78-85% | L/XL | 72-75 g |
| 72-90 (fin de cycle) | 65-78% | XL | 75-80 g |

**Production annuelle** : 300-330 œufs/poule/an (souches modernes Hy-Line, ISA Brown).

**Formule de calcul quotidien** :
```
oeufs_jour = effectif_vivant × taux_ponte(semaine) × facteur_stress × facteur_lumiere
calibre = f(age_poule) → S/M/L/XL
poids_oeuf = poids_base + (age_semaines - 18) × 0,35
```

### Le déclin — Mécanique centrale

Le déclin de ponte est ce qui **différencie** la pondeuse de toute autre espèce. Après le pic (semaine 24-30), le taux diminue de **0,3-0,5% par semaine**. C'est inexorable.

```
taux_ponte(semaine) :
  Si semaine < 20 : montée linéaire (50% → 95%)
  Si 20 ≤ semaine ≤ 30 : pic (95-97%)
  Si semaine > 30 : 97% - (semaine - 30) × 0,4%
  
  Plancher : 65% (une poule ne descend pas sous 65% tant qu'elle est en production)
```

**La question du joueur** : « Mon lot pond à 80%. L'aliment me coûte X €/jour. Chaque œuf me rapporte Y €. Est-ce que je continue ou je réforme ? »

C'est un **calcul de coût marginal** :
```
profit_quotidien = (oeufs × prix_moyen) - (effectif × cout_aliment_jour) - charges_fixes_jour

Quand profit_quotidien < seuil_reforme → il est temps de réformer
```

**Mode Normal** : le jeu affiche un indicateur vert/orange/rouge et un conseil (« Votre lot devient peu rentable, pensez à la réforme »).
**Mode Expert** : le joueur calcule lui-même. Pas de conseil automatique.

### Réforme et renouvellement

| Paramètre | Valeur |
|-----------|--------|
| Âge de réforme typique | 72-80 semaines (Normal), 72-90 semaines (Expert) |
| Valeur poule réforme | 0,50-1,00 €/poule (abattoir, viande de poule) |
| Coût poulette de renouvellement (17 sem.) | 5,00-7,00 € (conventionnel), 8,00-10,00 € (bio) |
| Délai entre lots | 2-4 semaines (nettoyage + vide sanitaire) |
| Durée avant pleine production nouveau lot | 4-6 semaines (montée en ponte) |

**Conséquence gameplay** : la réforme crée un « trou » de revenu de 6-10 semaines. Le joueur doit l'anticiper (trésorerie) ou décaler ses lots (multi-bâtiments).

### Ramassage des œufs

**Mode Normal** : ramassage automatique (robot/tapis inclus dans l'investissement initial). Le joueur ne gère pas cette étape.

**Mode Expert** :

| Méthode | Investissement | Temps de travail | Capacité |
|---------|:-----------:|:----------------:|:--------:|
| Manuel | 0 € | 1 min/40 poules/jour | Illimité |
| Tapis roulant semi-auto | 8 000-15 000 € | 1 min/200 poules/jour | 3 000 poules |
| Robot de ramassage | 20 000-35 000 € | 1 min/1 000 poules/jour | 9 000 poules |

**Temps de travail (ADR-004)** :
```
duree_ramassage = effectif / cadence_equipement
cadence_manuel = 40 poules/min
cadence_tapis = 200 poules/min
cadence_robot = 1 000 poules/min

Exemple 500 pondeuses plein-air (Expert, tapis) :
  500 / 200 = 2,5 min/jour de ramassage
```

### Conditionnement et stockage

| Paramètre | Valeur |
|-----------|--------|
| Salle de conditionnement | Obligatoire (investissement 10 000-25 000 €) |
| Capacité stockage | 7-14 jours de production |
| DLC des œufs | 28 jours après ponte |
| Température stockage | 5-20°C (pas de réfrigération obligatoire avant vente) |
| Fréquence de vente | 1-2×/semaine (grossiste) ou quotidien (vente directe) |

**Règle DLC** : les œufs non vendus sous 28 jours sont **détruits** (perte sèche). Le joueur doit vendre régulièrement.

**Mode Normal** : vente automatique hebdomadaire au grossiste (pas de DLC à gérer).
**Mode Expert** : le joueur choisit fréquence et circuit de vente. La DLC est un risque réel.

### Alimentation pondeuse

| Paramètre | Valeur |
|-----------|--------|
| Consommation | 110-130 g/jour/poule |
| Type aliment | Complet pondeuse (16-17% MAT, 3,5-4% calcium) |
| IC | 2,0-2,2 kg aliment / kg d'œuf produit |
| Coût aliment conventionnel | 320-370 €/tonne |
| Coût aliment bio | 450-550 €/tonne |
| Grit calcaire (complément) | Libre-service, 5-8 g/jour |

**Coût alimentaire quotidien** :
```
cout_aliment_jour = effectif × 0,120 kg × prix_tonne / 1000

Exemple 500 poules, aliment conventionnel 350 €/t :
  500 × 0,120 × 350 / 1000 = 21,00 €/jour
```

### Économie pondeuse

#### Structure des coûts (500 pondeuses plein-air, 1 cycle de 78 semaines)

| Poste | Coût | % du total |
|-------|:----:|:----------:|
| Poulettes (500 × 6,50 €) | 3 250 € | 12% |
| Aliment (500 × 0,120 kg × 546 j × 0,35 €/kg) | 11 466 € | 42% |
| Énergie + eau | 1 500 € | 6% |
| Véto + vaccins | 800 € | 3% |
| Litière | 600 € | 2% |
| Amortissement bâtiment (part cycle) | 4 500 € | 17% |
| Amortissement équipement | 2 000 € | 7% |
| Divers (emballage, assurance) | 1 500 € | 6% |
| Main d'œuvre (si Expert) | 1 400 € | 5% |
| **Total** | **27 016 €** | **100%** |

#### Recette (500 pondeuses plein-air, cycle de 78 semaines)

```
Effectif de départ        : 500 poulettes
Mortalité cumulée (5%)    : effectif moyen sur le cycle = 488 poules
Ponte moyenne             : 310 œufs/poule/an
Durée du cycle            : 78 semaines = 546 jours = 1,5 an

Production = 488 poules × 310 œufs/an × (546/365) an
           = 488 × 310 × 1,496
           = 226 300 œufs sur le cycle complet

⚠️ Correction : la ponte de 310 œufs/an est une moyenne SUR UNE ANNÉE de production
   pleine. Sur un cycle de 78 semaines incluant la montée en ponte (semaines 18-24)
   et le déclin final (semaines 65-78), la production réelle est de :

   Phase de montée (sem. 18-24, 7 sem.)   : 488 × 7 × 3,5 œufs/sem  =  11 956
   Phase de pic (sem. 25-45, 21 sem.)     : 488 × 21 × 6,6 œufs/sem =  67 637
   Phase de plateau (sem. 46-65, 20 sem.) : 488 × 20 × 5,8 œufs/sem =  56 608
   Phase de déclin (sem. 66-78, 13 sem.)  : 488 × 13 × 4,6 œufs/sem =  29 182
   ──────────────────────────────────────────────────────────────────────────
   PRODUCTION TOTALE DU CYCLE                                       = 165 383 œufs

   Soit 339 œufs par poule sur 1,5 an (cohérent avec 310/an en pleine production).

Répartition par calibre (le calibre grossit avec l'âge de la poule) :
  S  (10%) :  16 538 × 0,13 € =  2 150 €
  M  (40%) :  66 153 × 0,18 € = 11 908 €
  L  (35%) :  57 884 × 0,20 € = 11 577 €
  XL (15%) :  24 807 × 0,22 € =  5 458 €
  ─────────────────────────────────────────
  Recette œufs                = 31 093 €

Vente des poules de réforme : 488 × 0,75 € =    366 €
─────────────────────────────────────────────────────
RECETTE TOTALE DU CYCLE                     = 31 459 €
```

#### Marge du cycle (1,5 an)

**Mode Normal** — le joueur n'a pas de salarié dédié aux poules :
```
Recette                                      31 459 €
Charges d'exploitation (hors main d'œuvre)  -25 616 €
  (soit le total de 27 016 € moins les 1 400 € de MO Expert)
─────────────────────────────────────────────────────
Bénéfice avant charges sociales                5 843 €
Charges sociales (12% du bénéfice)              -701 €
─────────────────────────────────────────────────────
RÉSULTAT NET DU CYCLE                          5 142 €
Soit par an                                    3 428 €/an
```

**Mode Expert** — main d'œuvre valorisée, mais optimisation possible :
```
Recette (avec optimisation : +3% de ponte, calibres mieux valorisés)  32 400 €
Charges d'exploitation (dont MO, mais aliment optimisé -5%)          -26 443 €
─────────────────────────────────────────────────────────────────────────────
Bénéfice avant charges sociales                                        5 957 €
Charges sociales (28% du bénéfice)                                    -1 668 €
─────────────────────────────────────────────────────────────────────────────
RÉSULTAT NET DU CYCLE                                                  4 289 €
Soit par an                                                            2 859 €/an
```

#### Analyse d'équilibrage

| Scénario | Résultat net/an | Commentaire |
|----------|:---------------:|-------------|
| Normal, conduite correcte | 3 428 € | Revenu d'appoint |
| Expert bien optimisé | 2 859 € | Charges sociales plus lourdes (comparaison informative, cf. ADR-005) |
| Expert avec mortalité 10% | -1 240 € | Déficitaire — le sanitaire est critique |
| Normal, 2 000 pondeuses | 13 712 € | L'échelle change tout |

**Conclusion d'équilibrage** : un atelier de 500 pondeuses est un **revenu d'appoint** (3 400 €/an),
pas une activité principale. Pour atteindre la cible de 38-50 k€, il faut **5 000 à 6 000 pondeuses**
(bâtiment de 600 m², investissement 180 000 €).

C'est cohérent avec la réalité : les ateliers de ponte français comptent 3 000 à 40 000 poules.
Un atelier de 500 poules correspond à de la vente directe complémentaire.

**Note équilibrage serveur Expert (ADR-005)** : l'Expert gagne moins en euros (2 859 € contre 3 428 €) car ses charges sociales
sont plus lourdes. Cette comparaison est informative — les deux serveurs étant séparés, aucune équivalence de rentabilité n'est requise. L'avantage Expert réside dans la maîtrise du sanitaire (éviter le scénario à -1 240 €)
et dans le pilotage du calibre pour maximiser la valeur.



### Mockup — Interface Pondeuse (Mode Normal)

```
┌──────────────────────────────────────────────────────────────────────┐
│  🥚 POULAILLER PONDEUSES — Lot #3 (Plein-air)         Semaine 45/78 │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Effectif : 476 / 500          (mortalité cumulée 4,8%)              │
│  Taux de ponte : 91%           ████████████████████░░  pic: 97%      │
│  Tendance : ↘ lent déclin      (-0,4%/semaine)                       │
│                                                                       │
│  Production hier : 433 œufs                                          │
│  ├─ M : 152 (35%)  ├─ L : 195 (45%)  ├─ XL : 86 (20%)             │
│                                                                       │
│  Stock œufs : 2 840 œufs       ████████░░░░  (6,5 jours de stock)   │
│  DLC la plus ancienne : dans 21 jours  ✅                            │
│                                                                       │
│  Aliment restant : 1 200 kg    ████████████░░  (20 jours) ✅         │
│                                                                       │
│  Revenu ce mois : 2 410 €                                           │
│  Revenu cumulé cycle : 16 450 €                                     │
│                                                                       │
│  ⏱️ Temps de travail aujourd'hui : 12 min (ramassage + contrôle)     │
│                                                                       │
│  [🛒 Acheter aliment]  [📦 Vendre les œufs]  [📊 Courbe de ponte]   │
│                                                                       │
│  💡 Votre lot se porte bien. La ponte décline naturellement.         │
│     Réforme conseillée vers la semaine 75-80.                        │
└──────────────────────────────────────────────────────────────────────┘
```

### Mockup — Courbe de ponte et décision de réforme (Mode Expert)

```
┌──────────────────────────────────────────────────────────────────────┐
│  📊 ANALYSE ÉCONOMIQUE — Lot #3 (Plein-air, 500 places)   Sem. 68   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Taux de ponte (historique) :                                        │
│  100%│          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄                                    │
│   90%│      ▄▄▄▀               ▀▀▀▀▀▀▀▀▄                           │
│   80%│   ▄▄▀                             ▀▀▄▄  ← VOUS ÊTES ICI     │
│   70%│  ▄▀                                   ▀▀▄▄                   │
│   60%│▄▀                                         ▀▀▄ (projection)   │
│      └──┬────┬────┬────┬────┬────┬────┬────┬────┬────               │
│         20   30   40   50   60   70   80   90  sem.                  │
│                                                                       │
│  Taux actuel : 81,2%          Coût aliment/jour : 19,80 €           │
│  Œufs/jour : 371              Recette œufs/jour : 70,50 €           │
│  Calibre dominant : L/XL      Charges fixes/jour : 48,20 €          │
│                                                                       │
│  ┌─ BILAN QUOTIDIEN ──────────────────────────────────┐             │
│  │  Recette : 70,50 €  —  Charges : 68,00 €           │             │
│  │  MARGE QUOTIDIENNE : +2,50 €  ⚠️ seuil critique    │             │
│  └─────────────────────────────────────────────────────┘             │
│                                                                       │
│  ⚠️ Projection : marge nulle atteinte à la semaine 74.              │
│     Après sem. 74, chaque jour de retard = perte.                    │
│                                                                       │
│  Commander nouveau lot maintenant → arrivée sem. 72                  │
│  Réformer sem. 74 → transition sans trou de revenu                   │
│                                                                       │
│  [📋 Simuler réforme sem. 72]  [📋 Simuler sem. 78]  [📋 Sem. 84]  │
│  [🐔 Commander poulettes]      [🔪 Réformer maintenant]             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Équins — Élevage de Prestige

### Concept fondamental

L'élevage équin est le **jeu du temps long**. 11 mois de gestation, 3-4 ans avant valorisation, 1 seul poulain par an. C'est l'exact opposé du poulet (cycle court, volume). Le cheval est un **investissement à très long terme** dont la valeur dépend de la génétique et des performances.

**Plaisir procuré** : construire un élevage de renom sur plusieurs années. Voir un poulain né dans son élevage atteindre une valeur de 30 000 €. C'est un jeu de patience et de stratégie génétique.

### Gameplay loop

```
┌──────────────────────────────────────────────────────────────────────┐
│                CYCLE ÉQUIN (4+ ANS PAR GÉNÉRATION)                    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  SAILLIE/IA ──→ GESTATION ──→ POULINAGE ──→ ÉLEVAGE ──→ VALORISATION│
│  (fév-juil)    (11 mois)     (1 poulain)   (3-4 ans)    (vente/comp)│
│       │             │             │             │              │       │
│       ▼             ▼             ▼             ▼              ▼       │
│  Choix étalon   Attente       JAMAIS de     Débourrage     3 000 à   │
│  200-15000€     surveillance   jumeaux      alimentation   50 000 €  │
│  Génétique=clé  coût continu              soins continus             │
│                                                                       │
│  REVENUS INTERMÉDIAIRES :                                            │
│  └─ Pension (300-800 €/mois/cheval accueilli)                        │
│  └─ Monte (étalon valorisé = revenus récurrents)                     │
│                                                                       │
│  ◄──── PAS DE PRODUCTION DIRECTE (pas de lait, pas de viande) ────► │
└──────────────────────────────────────────────────────────────────────┘
```

### Filières et races

| Filière | Races principales | Valorisation poulain | Temps avant vente |
|---------|-------------------|:--------------------:|:-----------------:|
| Sport (CSO/CCE/Dressage) | Selle Français, Anglo-Arabe | 8 000-50 000 € | 3-4 ans |
| Course (trot) | Trotteur Français | 5 000-80 000 € | 2-3 ans |
| Course (galop) | Pur-Sang | 10 000-500 000 € | 1-2 ans (yearling) |
| Loisir | Poneys, croisés | 2 000-8 000 € | 3-4 ans |
| Trait | Percheron, Comtois, Breton | 1 500-5 000 € | 2-3 ans |

### Reproduction équine

| Paramètre | Valeur |
|-----------|--------|
| Gestation | 335-345 jours (11 mois) |
| Poulain par gestation | **1 — TOUJOURS** (jamais de jumeaux viables) |
| Saison de monte | Février-juillet (jours longs) |
| Taux de gestation/cycle | 60-70% |
| IA (% des saillies) | 70-80% (sport/trot), interdit en Pur-Sang galop |
| Puberté jument | 18-24 mois |
| Mise à la reproduction | 3-4 ans minimum |
| Carrière reproductrice | 10-15 poulains sur une vie |
| Sevrage | 6 mois |
| Débourrage | 3-4 ans |

### Prix des doses IA

| Catégorie étalon | Prix dose | Justification |
|-----------------|:---------:|---------------|
| Étalon local (loisir/trait) | 200-500 € | Monte courante |
| Étalon sport confirmé (CSO) | 800-3 000 € | Valorisation génétique |
| Étalon sport d'élite (international) | 3 000-8 000 € | Top 50 France |
| Étalon exceptionnel | 8 000-15 000 € | Champions olympiques, gagnants GP |
| Monte naturelle Pur-Sang | 5 000-50 000 € | Studbook fermé à l'IA |

**Mode Normal** : 3 gammes de doses (standard 300 €, qualité 1 500 €, élite 5 000 €). Choix simplifié.
**Mode Expert** : catalogue d'étalons avec indices génétiques détaillés. Prix variable selon la cote.

### Coûts d'entretien

| Poste | Coût annuel/cheval | Commentaire |
|-------|:------------------:|-------------|
| Alimentation (foin + concentré) | 1 500-2 500 € | 10-12 kg foin + 2-4 kg avoine/jour |
| Maréchal-ferrant | 500-900 € | Ferrage/parage toutes les 6-8 semaines |
| Vétérinaire (routine) | 400-800 € | Vaccins, vermifuges, dentiste |
| Litière + curage | 300-600 € | Paille 8-12 kg/jour/box |
| Assurance | 200-500 € | Mortalité + responsabilité civile |
| Divers (transport, concours) | 200-800 € | Variable |
| **Total** | **3 100-6 100 €** | Moyenne : 4 500 €/cheval/an |

**Conséquence gameplay** : un élevage de 8 juments + 1 étalon + 8 poulains = 17 chevaux × 4 500 € = **76 500 €/an** de charges d'entretien. Sans revenu intermédiaire, c'est un gouffre.

### Sources de revenus

| Source | Montant | Fréquence |
|--------|:-------:|:---------:|
| Vente poulain sport (3-4 ans) | 8 000-50 000 € | 1×/poulain (après 4 ans) |
| Pension | 300-800 €/mois/cheval | Mensuel (récurrent) |
| Monte étalon (revenus IA) | 200-15 000 €/saillie | Saisonnier (fév-juil) |
| Vente poulinière | 5 000-20 000 € | Occasionnel |
| Gains en compétition | Variable | Selon performances |

**Pension** : accueillir les chevaux d'autres joueurs. Revenu stable, nécessite boxes et pâture disponibles.
**Monte étalon** : si le joueur possède un étalon de valeur, il peut vendre des doses aux autres joueurs. C'est potentiellement le revenu le plus lucratif.

### Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Reproduction | IA avec 3 gammes de prix | Catalogue étalons + indices génétiques |
| Valorisation | Prix de vente = indices × multiplicateur | Marché joueur libre + enchères |
| Soins | Coûts forfaitaires | Maréchal, véto, dentiste séparés |
| Pension | Revenu fixe/cheval accueilli | Qualité pension = attractivité variable |
| Compétition | Bonus génétique automatique | Entraînement + préparation = performance |
| Charges | 12% forfaitaires | 28% détaillées |



---

## 4. Lapins — Cycle Ultra-Court et Prolificité

### Concept fondamental

Le lapin est le **turbo de l'élevage** : portées de 8-10 petits, 5-7 portées/an, engraissement en 70-80 jours. C'est un rythme frénétique. La contrainte n'est pas le temps (tout va vite) mais le **risque sanitaire** : une épidémie peut décimer un clapier en 48 heures.

**Plaisir procuré** : multiplication rapide, production intense. En 6 mois, un joueur passe de 10 lapines à 300 lapins en production. C'est l'espèce « turbo » pour les joueurs impatients.

### Gameplay loop

```
┌──────────────────────────────────────────────────────────────────────┐
│              CYCLE CUNICOLE (BANDE TOUTES LES 6 SEMAINES)             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  SAILLIE ──→ GESTATION ──→ MISE-BAS ──→ SEVRAGE ──→ ENGRAISSEMENT   │
│  (J0)        (31 jours)    (8-10 nés)   (J35)       (J35-J80)       │
│                                              │              │         │
│                                              ▼              ▼         │
│                                         Lapereaux      Abattage      │
│                                         7-9 sevrés     2,3-2,5 kg    │
│                                                                       │
│  RE-SAILLIE : J11 post-partum (rythme intensif)                      │
│  → une lapine produit 40-60 lapereaux/an                             │
│                                                                       │
│  ⚠️ RISQUE SANITAIRE PERMANENT : VHD, coccidiose, myxomatose        │
└──────────────────────────────────────────────────────────────────────┘
```

### Paramètres de production

| Paramètre | Valeur |
|-----------|--------|
| Gestation | 31 jours |
| Portée (nés vivants) | 8-10 lapereaux |
| Portée (sevrés) | 7-9 lapereaux |
| Sevrage | 35 jours |
| Engraissement | 35-45 jours post-sevrage |
| Poids abattage | 2,3-2,5 kg vif |
| Rendement carcasse | 55-60% |
| GMQ engraissement | 35-45 g/jour |
| IC | 3,2-3,6 |
| Portées/lapine/an | 5-7 (intensif 7, extensif 5) |
| Mortalité naissance-sevrage | 10-15% |
| Mortalité engraissement | 5-8% (hors épidémie) |
| Durée de carrière (lapine) | 12-18 mois (5-8 portées) |

### Conduite en bandes

Le lapin se gère en **bandes** avec un rythme de 42 jours (6 semaines) :

| Semaine | Événement |
|:-------:|-----------|
| S0 | Saillie de toutes les lapines de la bande |
| S4+3j | Mise-bas (31 jours de gestation) |
| S5 | Naissance des lapereaux |
| S10 | Sevrage (35 jours d'âge) |
| S10-S16 | Engraissement (cages collectives) |
| S16 | Abattage (80 jours d'âge, 2,4 kg) |

**Mode Normal** : une seule bande, tout automatique. Le joueur achète des lapines, les lapereaux apparaissent et grandissent.
**Mode Expert** : gestion de 2-3 bandes décalées + planning de saillie + gestion sanitaire active.

### Risque sanitaire — Mécanique distinctive

| Maladie | Probabilité/trimestre | Effet | Prévention |
|---------|:--------------------:|-------|-----------|
| VHD (Maladie Hémorragique Virale) | 5-10% (Expert) | Mortalité 80-95% du lot | Vaccination 0,50 €/lapin |
| Myxomatose | 3-8% | Mortalité 50-70% | Vaccination 0,40 €/lapin |
| Coccidiose | 15-25% | Mortalité +10-20%, IC +0,5 | Anticoccidien dans l'eau |
| Entéropathie | 10-20% | Mortalité +15% post-sevrage | Hygiène + alimentation |

**Mode Normal** : vaccination automatique (incluse dans les 12%). Risque épidémique très faible (2%/an).
**Mode Expert** : le joueur vaccine manuellement. Sans vaccination → risque réel d'épidémie catastrophique.

### Économie lapin

| Paramètre | Valeur |
|-----------|--------|
| Prix lapin vif (abattoir) | 1,80-2,20 €/kg vif |
| Prix vente (2,4 kg × 2,00 €) | 4,80 €/lapin |
| Coût aliment/lapin engraissé | 1,50-2,00 € (IC 3,4 × 2,4 kg × 0,25 €/kg) |
| Coût lapine reproductrice | 15-25 €/lapine |
| Marge/lapin engraissé | 1,50-2,50 € |
| Production/lapine/an | 45-55 lapins vendus |
| Marge brute/lapine/an | 70-130 € |
| Investissement cage | 80-120 €/cage mère |

---

## 5. Volailles Secondaires — Pintade, Oie, Canard

### 5.1 Pintade — Spécialité française

**Identité gameplay** : la France produit 50% de la pintade mondiale. C'est une **exclusivité de niche** avec une saisonnalité très marquée (demande ×3 à Noël).

| Paramètre | Valeur |
|-----------|--------|
| Durée d'élevage | 12-14 semaines (standard), 16-18 semaines (Label) |
| Poids abattage | 1,8-2,2 kg vif |
| IC | 2,8-3,2 |
| Densité | 13-15 pintades/m² (standard) |
| Effectif/bâtiment | 5 000-15 000 |
| Prix vente vif | 2,50-3,50 €/kg |
| Lots/an | 4-5 |
| Mortalité | 4-6% |
| Saisonnalité demande | ×2-3 en décembre (Noël) |

**Mécanique de gameplay** : le joueur doit **timer** ses lots pour que la vente coïncide avec le pic de Noël. Un lot prêt en décembre = prix ×2. Un lot prêt en mars = prix plancher.

**Mode Normal** : bonus de prix automatique en décembre (+50%).
**Mode Expert** : le joueur planifie ses bandes pour maximiser les ventes de Noël. Stockage froid possible (investissement) pour décaler la vente.

### 5.2 Oie et Canard — Produits Premium

**Identité gameplay** : l'oie et le canard sont les portes d'entrée vers le **foie gras** et les produits transformés de luxe. La mécanique de gavage est renvoyée au GDD-endgame (contenu tardif, polémique à encadrer).

| Paramètre | Canard (maigre, Barbarie) | Canard (gras, Mulard) | Oie |
|-----------|:-------------------------:|:---------------------:|:---:|
| Durée élevage | 10-12 semaines | 14 semaines + gavage 12j | 16-20 semaines |
| Poids abattage | 3,5-4,5 kg | 5,5-6,5 kg (gavé) | 5-7 kg |
| IC | 2,8-3,2 | 3,5-4,0 (hors gavage) | 3,5-4,0 |
| Prix vente vif | 2,00-2,80 €/kg | — (vendu gavé) | 3,00-4,00 €/kg |
| Foie gras | Non | 500-600 g/canard | 800-1000 g/oie |
| Prix foie gras | — | 35-50 €/kg | 45-65 €/kg |
| Plumes/duvet | Sous-produit | Sous-produit | 20-40 €/kg duvet |
| Saisonnalité | Modérée | Très forte (Noël) | Très forte (Noël) |

**Productions accessibles en V1** (sans gavage) :
- Canard maigre (Barbarie) : élevage similaire au poulet, cycle 10-12 semaines
- Oie : élevage long, valorisation viande + duvet

**Productions renvoyées au GDD-endgame** :
- Canard gras (gavage) : contenu tardif, nécessite salle de gavage
- Foie gras : transformation premium, saisonnalité Noël

**Mode Normal** : élevage de canards maigres uniquement. Simple et rentable.
**Mode Expert** : planification saisonnière + accès au gavage (si GDD-endgame débloqué).

### 5.3 Économie volailles secondaires comparée

| Métrique | Pintade (10 000) | Canard maigre (5 000) | Oie (1 000) |
|----------|:----------------:|:--------------------:|:-----------:|
| Investissement bâtiment | 180 000 € | 120 000 € | 80 000 € |
| Coût poussin/lot | 6 500 € | 4 500 € | 5 000 € |
| Coût aliment/lot | 18 000 € | 14 000 € | 12 000 € |
| Recette/lot (hors Noël) | 32 000 € | 25 000 € | 18 000 € |
| Recette/lot (Noël) | 48 000 € | 30 000 € | 28 000 € |
| Lots/an | 4,5 | 4 | 2,5 |
| Marge annuelle | 20 000-35 000 € | 15 000-25 000 € | 10 000-20 000 € |

---

## 6. Bisons et Daims — Niche Exotique

### Concept fondamental

Les bisons et daims sont l'**élevage passif** d'Agriva. Très peu d'intervention quotidienne, pas de bâtiment fermé, pas de traite, pas de soins intensifs. En contrepartie : investissement clôture très lourd, cycle long, et impossibilité d'utiliser l'IA.

**Plaisir procuré** : « observer son troupeau depuis la clôture ». C'est l'élevage zen pour le joueur qui veut diversifier sans ajouter de charge de travail. Un revenu passif avec un investissement initial conséquent.

### Paramètres communs

| Paramètre | Bison | Daim |
|-----------|:-----:|:----:|
| Gestation | 270-285 jours (9 mois) | 230 jours (7,5 mois) |
| Portée | 1 (jamais de jumeaux) | 1 (rarement 2) |
| Poids adulte mâle | 800-1000 kg | 80-100 kg |
| Poids adulte femelle | 400-550 kg | 40-60 kg |
| Poids abattage | 500-600 kg (mâle 2-3 ans) | 55-70 kg (mâle 18-24 mois) |
| Rendement carcasse | 50-55% | 55-60% |
| Prix viande | 15-25 €/kg (niche) | 12-20 €/kg (niche) |
| Reproduction | Monte naturelle UNIQUEMENT | Monte naturelle UNIQUEMENT |
| Ratio mâle/femelles | 1 pour 15-25 | 1 pour 20-30 |
| Chargement | 1-1,5 ha/bison | 0,3-0,5 ha/daim |
| Alimentation | Pâturage + foin hiver | Pâturage + foin hiver |
| Bâtiment intérieur | NON (toute l'année dehors) | NON (abri ouvert suffisant) |

### Contraintes spécifiques (gameplay)

| Contrainte | Détail | Coût |
|-----------|--------|:----:|
| Clôture 2 m minimum | Obligatoire (bison peut franchir 1,60 m) | 25-40 €/mètre linéaire |
| Double clôture (bison) | Recommandée (sécurité publique) | ×2 coût clôture |
| Corral de contention | Obligatoire pour manipulation | 15 000-30 000 € |
| Prairie boisée | Préférence (ombre, abri naturel) | Surface boisée requise |
| Pas de traite | Aucune production intermédiaire | — |
| Pas d'IA | Monte naturelle obligatoire | Achat taureau/mâle |
| Interventions minimales | Pas de soins quotidiens | Temps travail très faible |

### Économie bison/daim

**Investissement type (15 bisons = 12 femelles + 3 mâles + enclos 20 ha)** :

| Poste | Coût |
|-------|:----:|
| Clôture 2 m, 1 800 m linéaires (20 ha) | 54 000-72 000 € |
| Corral de contention | 20 000 € |
| Achat animaux (12F × 3 000 + 3M × 4 500) | 49 500 € |
| **Total investissement** | **123 500-141 500 €** |

**Revenus annuels (après 2 ans de montée en charge)** :

| Source | Calcul | Montant |
|--------|--------|:-------:|
| Vente mâles 2-3 ans (viande) | 5 mâles × 280 kg carcasse × 20 €/kg | 28 000 € |
| Vente femelles excédentaires | 2 femelles × 3 500 € | 7 000 € |
| **Recette annuelle** | | **35 000 €** |

**Charges annuelles** :

| Poste | Montant |
|-------|:-------:|
| Foin hivernal (4 mois) | 4 500 € |
| Vétérinaire (minimal) | 800 € |
| Entretien clôture | 1 500 € |
| Divers | 500 € |
| **Total charges** | **7 300 €** |

**Marge brute annuelle** : 35 000 - 7 300 = **27 700 €**
**Retour sur investissement** : 130 000 / 27 700 ≈ **4,7 ans**

### Temps de travail (ADR-004)

```
Temps quotidien bison (15 têtes) :
  - Vérification visuelle du troupeau : 15 min (tour de clôture en véhicule)
  - Distribution foin (hiver uniquement) : 30 min
  - Soins : 0 min (sauf urgence)
  
  Total été : 15 min/jour
  Total hiver : 45 min/jour
  
  Moyenne annuelle : ~25 min/jour = 150 h/an

Comparaison :
  - 60 vaches laitières : 2 500-3 000 h/an
  - 500 pondeuses : 400-600 h/an
  - 15 bisons : 150 h/an ← 10× moins que le laitier
```

**C'est l'élevage le plus « passif » du jeu.** Peu de temps de travail mais investissement clôture initial très lourd.

### Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Reproduction | Automatique (1 mâle suffit) | Gestion ratio mâle/femelle, rotation |
| Alimentation | Foin auto en hiver | Gestion pâturage + complémentation |
| Santé | Forfait, pas de maladie | Parasitisme au pâturage, tuberculose (rare) |
| Clôture | Coût fixe, jamais de problème | Entretien requis, risque évasion si négligence |
| Charges | 12% forfaitaires | 28% détaillées |



---

## 7. Tableau Comparatif — Toutes les Espèces du Jeu

### Vue d'ensemble stratégique

| Espèce | Investissement initial | Revenu annuel brut | Temps travail/an | Technicité | Cycle |
|--------|:---------------------:|:------------------:|:----------------:|:----------:|:-----:|
| **Bovin laitier** (60 VL) | 500 000-800 000 € | 180 000-250 000 € | 2 500-3 000 h | ★★★★☆ | Continu |
| **Bovin allaitant** (50 VA) | 200 000-400 000 € | 50 000-80 000 € | 1 200-1 800 h | ★★★☆☆ | Annuel |
| **Porc** (150 truies NE) | 600 000-1 000 000 € | 250 000-400 000 € | 2 200-2 800 h | ★★★★★ | 5-6 mois |
| **Ovin viande** (300 brebis) | 200 000-350 000 € | 60 000-100 000 € | 1 500-2 000 h | ★★★☆☆ | Annuel |
| **Caprin lait** (200 chèvres) | 250 000-400 000 € | 80 000-140 000 € | 1 800-2 400 h | ★★★☆☆ | Continu |
| **Poulet de chair** (2 bât.) | 350 000-500 000 € | 150 000-250 000 € | 800-1 200 h | ★★★☆☆ | 5-8 sem. |
| **Poule pondeuse** (500) | 50 000-80 000 € | 18 000-28 000 € | 400-600 h | ★★☆☆☆ | 78 sem. |
| **Équins** (8 juments) | 120 000-200 000 € | 40 000-90 000 € | 1 200-1 600 h | ★★★★☆ | 4+ ans |
| **Lapins** (50 lapines) | 15 000-30 000 € | 8 000-15 000 € | 400-700 h | ★★★☆☆ | 80 jours |
| **Pintade** (10 000/lot) | 180 000-250 000 € | 30 000-50 000 € | 600-900 h | ★★☆☆☆ | 12-14 sem. |
| **Oie/Canard** (5 000/lot) | 120 000-180 000 € | 20 000-35 000 € | 500-800 h | ★★☆☆☆ | 10-20 sem. |
| **Bison** (15 têtes) | 125 000-145 000 € | 30 000-38 000 € | 150 h | ★☆☆☆☆ | 2-3 ans |
| **Daim** (30 têtes) | 40 000-60 000 € | 12 000-20 000 € | 100 h | ★☆☆☆☆ | 18-24 mois |

### Profils de joueurs et espèces recommandées

| Profil joueur | Espèces adaptées | Raison |
|--------------|-------------------|--------|
| Débutant | Pondeuse, Poulet chair, Lapin | Cycles courts, investissement modéré |
| Stratège long terme | Équins, Bovin laitier | Patience, planification génétique |
| Optimisateur | Porc, Poulet chair | IC = performance mesurable |
| Passif/multi-activité | Bison, Daim, Bovin allaitant | Peu de temps quotidien |
| Saisonnier | Pintade, Oie, Canard | Timing = profit (Noël) |
| Collectionneur | Équins, Bison | Races, génétique, prestige |

### Matrice risque/rendement

```
Rendement ↑
    │
    │  ● Porc (150 truies)           ● Bovin laitier (60VL)
    │
    │      ● Poulet chair (2 bât.)
    │                                    ● Caprin fromager
    │  ● Équins (8 juments)
    │      ● Pintade (10k)           ● Ovin lait (AOP)
    │          ● Bison (15)
    │  ● Pondeuse (500)      ● Bovin allaitant
    │      ● Canard             ● Ovin viande
    │  ● Lapin (50)
    │      ● Daim (30)
    │
    └──────────────────────────────────── Risque →
       Faible                            Élevé
```

---

## 8. Équilibrage — Scénarios Chiffrés

### Scénario 1 : Atelier de 500 pondeuses plein-air (Mode Normal)

**Profil** : joueur intermédiaire, diversification depuis une exploitation céréalière.

#### Investissement initial

| Poste | Montant |
|-------|:-------:|
| Poulailler plein-air 500 places (60 m² + parcours 2 000 m²) | 35 000 € |
| Salle de conditionnement | 12 000 € |
| Clôture parcours | 5 000 € |
| Équipement (mangeoires, abreuvoirs, nids) | 8 000 € |
| **Total** | **60 000 €** |

#### Année 1 (premier lot, 78 semaines ≈ 1,5 an)

| Étape | Calcul | Montant |
|-------|--------|:-------:|
| Achat poulettes 17 sem. | 500 × 6,50 € | -3 250 € |
| Aliment | 546 j × 500 × 0,12 kg × 0,35 €/kg | -11 466 € |
| Énergie, eau, véto, litière, divers | cf. §2 | -4 400 € |
| Amortissement bâtiment + équipement | part du cycle | -6 500 € |
| Recette œufs (165 383 œufs, mix calibres plein-air) | cf. §2 | +31 093 € |
| Vente poules de réforme | 488 × 0,75 € | +366 € |
| **Bénéfice avant charges sociales** | | **+5 843 €** |
| Charges sociales (12% du bénéfice, ADR-002) | 5 843 × 0,12 | -701 € |
| **RÉSULTAT NET du cycle** | | **+5 142 €** |

#### Projection sur 5 ans

| Période | Lots | Recette | Charges | Résultat net | Cumul |
|:-------:|:----:|:-------:|:-------:|:------------:|:-----:|
| 0 → 1,5 an | Lot 1 | 31 459 € | -26 317 € | +5 142 € | +5 142 € |
| 1,5 → 1,6 an | Vide sanitaire | 0 € | -500 € | -500 € | +4 642 € |
| 1,6 → 3,1 an | Lot 2 | 31 459 € | -26 317 € | +5 142 € | +9 784 € |
| 3,1 → 3,2 an | Vide sanitaire | 0 € | -500 € | -500 € | +9 284 € |
| 3,2 → 4,7 an | Lot 3 | 31 459 € | -26 317 € | +5 142 € | +14 426 € |
| 4,7 → 5 an | Vide + démarrage lot 4 | 3 500 € | -4 200 € | -700 € | +13 726 € |

**Revenu moyen annuel** : 13 726 € / 5 ans = **2 745 €/an**

**Retour sur investissement** : 60 000 € / 2 745 €/an ≈ **22 ans** ⚠️

**Conclusion** : un atelier de 500 pondeuses ne rentabilise PAS un bâtiment neuf de 60 000 €.
Deux voies pour le rendre viable :
  • **Monter en taille** : 3 000 pondeuses dans le même bâtiment agrandi (120 000 €)
    → 16 470 €/an, ROI 7,3 ans ✅
  • **Vendre en circuit court** : œufs à 0,32 €/unité au lieu de 0,19 € moyen
    → recette 52 900 € par cycle, résultat net 23 300 €/an
    → ROI sur le bâtiment seul : 60 000 / 23 300 = 2,6 ans
    → MAIS le circuit court nécessite un investissement supplémentaire :
      - Salle de conditionnement mise aux normes vente directe : 8 000 €
      - Véhicule réfrigéré de livraison (utilitaire occasion) : 15 000 €
      - Matériel de vente (stand marché, présentoir, caisse) : 3 000 €
      - Communication (site web, panneaux, signalétique) : 2 000 €
      - Stock emballages (alvéoles, boîtes étiquetées) : 3 000 €
      - Total investissement supplémentaire : 31 000 €
    → Investissement total (bâtiment + circuit court) : 91 000 €
    → ROI réel : 91 000 / 23 300 = **3,9 ans** ✅
    (consomme aussi du temps de commercialisation : 3 h/semaine)

C'est exactement l'arbitrage réel de la filière œuf : soit du volume, soit de la vente directe.
Le petit atelier qui vend en gros n'est pas viable.

#### Temps de travail (ADR-004)

```
Temps quotidien (Normal, ramassage automatique) :
  - Contrôle visuel + collecte œufs robot : 10 min
  - Vérification aliment/eau : 5 min
  - Total : 15 min/jour

Temps hebdomadaire :
  - Conditionnement + préparation vente : 30 min
  - Entretien litière : 20 min
  - Total : 50 min/semaine

Temps annuel : (15 min × 365) + (50 min × 52) = 5 475 + 2 600 = 8 075 min ≈ 135 h/an

Capacité exploitant nécessaire : 135 h/an = 0,56 h/jour ouvrable
→ Compatible avec une activité principale (céréales, autre élevage)
```

**Verdict** : la pondeuse plein-air en Normal est une **rente** stable et peu chronophage. Idéale en complément. Retour lent (6-7 ans) mais risque quasi-nul.

---

### Scénario 2 : Élevage équin — 8 juments de sport (Mode Normal)

**Profil** : joueur expérimenté cherchant un élevage « prestige » à forte valorisation unitaire.

#### Investissement initial

| Poste | Montant |
|-------|:-------:|
| Écurie 10 boxes (8 juments + 2 poulains intérieur) | 100 000 € |
| Pâtures clôturées 15 ha (8 paddocks) | 25 000 € |
| Achat 8 juments Selle Français (indices moyens-hauts) | 8 × 12 000 € = 96 000 € |
| Manège/carrière (optionnel, valorisation) | 30 000 € |
| Corral, rond de longe | 8 000 € |
| **Total** | **259 000 €** |

#### Année 1 (mise en route, pas de vente)

| Poste | Calcul | Montant |
|-------|--------|:-------:|
| Entretien 8 juments | 8 × 4 500 €/an | -36 000 € |
| IA (8 juments × 1 500 € dose moyenne) | 8 × 1 500 € | -12 000 € |
| Taux de réussite 65% → 5 juments gestantes | | |
| Charges forfaitaires 12% | (sur recette future = 0 €) | 0 € |
| Recette | Pas de poulain vendable avant an 4 | 0 € |
| **Résultat année 1** | | **-48 000 €** |

#### Année 2 (naissances, pas encore de vente)

| Poste | Calcul | Montant |
|-------|--------|:-------:|
| Entretien 8 juments + 5 poulains | 13 × 3 800 € (poulains moins chers) | -49 400 € |
| IA 8 juments (2ème campagne) | 8 × 1 500 € × 0,65 = 5 gestantes | -12 000 € |
| Recette (pension possible : 3 boxes libres) | 3 × 500 €/mois × 12 | +18 000 € |
| **Résultat année 2** | | **-43 400 €** |

#### Année 4 (premières ventes)

| Poste | Calcul | Montant |
|-------|--------|:-------:|
| Entretien troupeau (8 jum. + 12 jeunes) | 20 × 4 000 € moy. | -80 000 € |
| IA | -12 000 € | -12 000 € |
| Vente 5 chevaux débourés (1ère génération) | 5 × 15 000 € (indices moyens) | +75 000 € |
| Pension (3 chevaux accueillis) | 3 × 500 € × 12 | +18 000 € |
| Charges 12% | 93 000 × 0,12 | -11 160 € |
| **Résultat année 4** | | **-10 160 €** |

#### Année 6 (croisière, étalons améliorés)

| Poste | Calcul | Montant |
|-------|--------|:-------:|
| Entretien | 20 × 4 000 € | -80 000 € |
| IA (doses élite 3 000 € maintenant) | 8 × 3 000 € | -24 000 € |
| Vente 5 chevaux (indices hauts, 2ème gen) | 5 × 25 000 € | +125 000 € |
| Pension | 3 × 600 × 12 | +21 600 € |
| Charges 12% | 146 600 × 0,12 | -17 592 € |
| **Résultat année 6** | | **+25 008 €** |

#### Bilan cumulé

| Année | Résultat annuel | Cumul | Commentaire |
|:-----:|:---------------:|:-----:|-------------|
| 1 | -48 000 € | -48 000 € | Pur investissement |
| 2 | -43 400 € | -91 400 € | Pensions compensent partiellement |
| 3 | -35 000 € | -126 400 € | Jeunes grandissent |
| 4 | -10 160 € | -136 560 € | Premières ventes |
| 5 | +12 000 € | -124 560 € | Montée en gamme |
| 6 | +25 008 € | -99 552 € | Croisière |
| 7 | +35 000 € | -64 552 € | Réputation = prix ↑ |
| 8 | +45 000 € | -19 552 € | Étalon propre possible |
| **9** | **+50 000 €** | **+30 448 €** | **Rentabilité atteinte** |

**Retour sur investissement total** : 259 000 € investis + pertes cumulées → retour positif **année 9**.

C'est le cycle le plus long d'Agriva. Le joueur doit **accepter 4-5 ans de pertes** avant de voir un retour. Mais une fois en croisière, la marge est excellente et surtout : un seul bon poulain (50 000 €) peut changer une année entière.

#### Temps de travail (ADR-004)

```
Temps quotidien (Normal, 8 juments + jeunes) :
  - Distribution foin + concentré : 45 min (20 chevaux × 2 min/tête + préparation)
  - Curage boxes : 60 min (10 boxes × 6 min)
  - Contrôle visuel paddocks : 15 min
  - Total : 2 h/jour

Temps hebdomadaire :
  - Soins (pieds, brossage, contrôle) : 1 h
  
Temps annuel : (120 min × 365) + (60 × 52) = 43 800 + 3 120 = 46 920 min ≈ 782 h/an

Capacité nécessaire : 782 / 300 jours = 2,6 h/jour ouvrable
→ Activité significative mais pas à plein temps
```

---

## 9. Annexe — Récapitulatif Normal vs Expert (Espèces Secondaires)

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| **PONDEUSE** | | |
| Taux de ponte | Courbe automatique | Modulable (lumière, stress, alimentation) |
| Ramassage | Automatique (inclus) | Manuel ou robot (investissement séparé) |
| DLC œufs | Pas de perte (vente auto) | 28 jours, perte si non vendu |
| Réforme | Conseil affiché | Calcul coût marginal |
| Calibres | Évolution auto avec l'âge | Optimisable (calcium, alimentation) |
| Mortalité | 5% fixe | 3-10% selon conduite |
| Charges | 12% forfaitaires | 28% détaillées |
| **ÉQUINS** | | |
| Reproduction | 3 gammes de doses | Catalogue étalons + indices |
| Valorisation | Prix = indices × formule | Marché libre entre joueurs |
| Soins | Forfait annuel | Maréchal + véto + dentiste séparés |
| Pension | Revenu fixe | Qualité = attractivité variable |
| Compétition | Bonus auto (génétique) | Entraînement → performance |
| Charges | 12% forfaitaires | 28% détaillées |
| **LAPINS** | | |
| Production | Automatique (lapines → lapereaux → vente) | Bandes, planning saillie |
| Santé | Vaccination auto, risque 2%/an | Vaccination manuelle, risque 15-25%/trim |
| IC | Fixe 3,4 | Variable 3,2-3,8 selon conduite |
| Charges | 12% forfaitaires | 28% détaillées |
| **PINTADE/OIE/CANARD** | | |
| Saisonnalité | Bonus prix Noël auto (+50%) | Planification bandes pour timing |
| Lots | 1 lot/bâtiment séquentiel | Multi-bâtiments décalés |
| Gavage (canard) | Non disponible | Disponible (GDD-endgame) |
| Charges | 12% forfaitaires | 28% détaillées |
| **BISON/DAIM** | | |
| Reproduction | Automatique (mâle présent) | Gestion ratio, rotation mâles |
| Clôture | Jamais de problème | Entretien requis, risque évasion |
| Alimentation | Foin auto hiver | Gestion pâturage + complémentation |
| Santé | Forfait | Parasitisme, tuberculose (rare) |
| Charges | 12% forfaitaires | 28% détaillées |

---

## 10. Checklist Playtest

| Test | Critère | Bloquant |
|------|---------|:--------:|
| Test recette SimAgri | Un joueur SimAgri dit « les pondeuses sont mieux qu'avant » | ✅ Oui |
| Pondeuse = flux régulier | Le joueur perçoit un revenu quotidien stable | ✅ Oui |
| Déclin de ponte perceptible | Le joueur remarque la baisse et comprend la réforme | ✅ Oui |
| Équins ≠ ruine immédiate | Le joueur en Normal ne fait pas faillite en 2 ans (pension compense) | ✅ Oui |
| Équins = patience récompensée | Première vente > 10 000 € = satisfaction | ✅ Oui |
| Lapin = multiplication visible | En 6 mois, le joueur a ×10 son effectif initial | ✅ Oui |
| Lapin = risque sanitaire réel (Expert) | Au moins 1 épidémie sur 4 trimestres | ✅ Oui |
| Pintade timing Noël | Le joueur comprend que décembre = meilleur moment de vente | ✅ Oui |
| Bison = passif | Le joueur passe < 30 min/jour sur ses bisons | ✅ Oui |
| Bison = investissement clôture | Le coût clôture est le frein n°1 (pas le cheptel) | ✅ Oui |
| Chaque serveur internement équilibré | Le serveur Expert est viable en lui-même pour chaque espèce (ADR-005) | ✅ Oui |
| Pas de faillite Normal | Aucune espèce ne peut ruiner un joueur Normal | ✅ Oui |
| Diversification viable | Un joueur avec 2-3 espèces secondaires = revenu stable | ❌ Non (UX) |
| Identité gameplay unique | Chaque espèce se « joue » différemment | ❌ Non (UX) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Audit de couverture : trou critique pondeuse + espèces secondaires non conçues |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
