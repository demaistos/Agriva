> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Poulet de Chair

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : docs/research/reality-vs-simagri-elevage.md (§6 Volailles), ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop

### Intention de design

Le poulet de chair est **la filière absente n°1** de SimAgri alors qu'elle représente 70% de la production avicole française. Son ajout apporte une mécanique unique dans Agriva : le **cycle court par lot**.

**Plaisir procuré** : investissement rapide → résultat rapide → optimisation → réinvestissement. C'est la boucle la plus courte et la plus addictive de tout l'élevage. Un lot standard se boucle en 35-42 jours. Le joueur voit ses résultats en moins de 2 mois, contre 9-12 mois en bovin.

### Ce que SimAgri fait bien (à garder)

- ✅ Bâtiment dédié (poulailler) avec surface/animal
- ✅ Alimentation simple (aliment complet, quantité/jour)
- ✅ Semi-liberté avec parc extérieur (base pour Label Rouge/Bio)

### Ce que SimAgri fait mal (à corriger)

- ❌ Pas de filière chair du tout (uniquement pondeuse)
- ❌ Pas de gestion par lot (tout-plein/tout-vide)
- ❌ Pas d'IC (Indice de Consommation)
- ❌ Âge adulte à 180 jours vs 35 jours réels
- ❌ Pas de chauffage, pas de mortalité réaliste
- ❌ Pas de labels différenciés (Standard/Label Rouge/Bio)

### Gameplay loop

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CYCLE D'UN LOT (35-81 jours)                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ACHAT POUSSINS ──→ ENGRAISSEMENT ──→ VENTE LOT ──→ VIDE SANITAIRE │
│   (J0, 1 jour)      (J1 à J35-81)    (poids cible)   (15-21 jours) │
│        │                  │                │                │        │
│        ▼                  ▼                ▼                ▼        │
│   Choix souche      IC quotidien      Marge/lot       Nettoyage     │
│   Choix effectif    Mortalité         Bilan perf.     Désinfection  │
│   Coût poussins    Température        Classement      Prêt pour     │
│                    Alimentation        serveur         lot suivant   │
│                                                                      │
│  ◄──────────────── RÉPÉTER 6-7 FOIS/AN ────────────────────────────►│
└─────────────────────────────────────────────────────────────────────┘
```

**Boucle quotidienne** : vérifier la croissance du lot, ajuster (Expert).
**Boucle par lot** : acheter → engraisser → vendre → nettoyer → recommencer.
**Boucle annuelle** : 6-7 rotations, bilan financier, investissement bâtiment supplémentaire.

### Les décisions du joueur

| Moment | Décision | Impact |
|--------|----------|--------|
| Achat lot | Filière (Standard/Label/Bio) | Durée, marge, contraintes |
| Achat lot | Effectif (taille du lot) | Risque vs revenu |
| En cours | Alimentation (Normal : auto / Expert : multiphase) | IC, coût, croissance |
| En cours | Température bâtiment (Expert) | Mortalité, IC |
| Vente | Moment de vente (poids atteint ?) | Prix/kg optimal |
| Entre lots | Durée vide sanitaire | Risque sanitaire lot suivant |
| Stratégie | Nombre de bâtiments | Planification bandes |

### Différence Normal / Expert

| Aspect | Mode Normal | Mode Expert |
|--------|-------------|-------------|
| Alimentation | Automatique (aliment unique) | Multiphase (3 aliments, transitions manuelles) |
| Température | Gérée automatiquement | Réglage manuel (impact IC et mortalité) |
| IC | Affiché en fin de lot (info) | Suivi quotidien, levier d'optimisation |
| Mortalité | Taux fixe 3% | Variable selon conduite (2-8%) |
| Vide sanitaire | Automatique 18 jours | Choix durée (15-21j), impact sanitaire |
| Bandes | 1 lot à la fois par bâtiment | Planning multi-bâtiments, chevauchement |
| Grippe aviaire | Événement rare, perte limitée | Gestion active biosécurité, claustration |
| Charges | 12% forfaitaires | 28% détaillées (énergie, litière, véto) |



---

## 2. Le lot comme unité de gestion

### Concept fondamental

En poulet de chair, **l'animal individuel n'existe pas** pour le joueur. L'unité de gestion est le **lot** : un groupe de poussins achetés ensemble, élevés ensemble, vendus ensemble.

C'est fondamentalement différent du bovin (gestion individuelle) et c'est ce qui rend la filière unique dans Agriva.

### Cycle de vie du lot

| Phase | Durée | Événement |
|-------|-------|-----------|
| Achat poussins | J0 | Lot de N poussins d'1 jour livré dans le bâtiment |
| Démarrage | J1-J10 | Chauffage critique (32°C), mortalité élevée si mal géré |
| Croissance | J11-J25 | Phase rapide, IC optimal, consommation augmente |
| Finition | J26-J42 (Standard) / J26-J81 (Label/Bio) | Prise de poids finale, IC se dégrade |
| Vente | Poids cible atteint | Lot entier vendu à l'abattoir |
| Vide sanitaire | 15-21 jours | Bâtiment vide, nettoyage, désinfection |

### Achat des poussins

**Mode Normal** : le joueur choisit une filière et un effectif, le lot est livré instantanément.

| Paramètre | Valeur |
|-----------|--------|
| Prix poussin Standard | 0,45-0,55 €/poussin |
| Prix poussin Label Rouge | 0,80-1,00 €/poussin |
| Prix poussin Bio | 1,00-1,30 €/poussin |
| Effectif minimum | 1 000 poussins |
| Effectif maximum | 30 000 poussins (limité par bâtiment) |
| Poids à J0 | 42 g |

**Mode Expert** : choix de la souche (Ross 308, Cobb 500 pour Standard ; Cou Nu, JA 657 pour Label). La souche influence le GMQ potentiel et l'IC de base.

### Mortalité

```
mortalite_lot = mortalite_base × facteur_temperature × facteur_densite × facteur_sanitaire
```

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| Mortalité base (Standard) | 3% fixe sur le lot | 2-8% selon conduite |
| Mortalité base (Label/Bio) | 4% fixe sur le lot | 3-10% selon conduite |
| Facteur température | 1,0 (auto) | 0,8-2,0 selon écart au plan |
| Facteur densité | 1,0 (auto) | 0,9-1,5 selon surpopulation |
| Facteur sanitaire | 1,0 (sauf événement) | 0,7-3,0 selon biosécurité |

La mortalité se répartit : 60% en première semaine (démarrage), 30% en croissance, 10% en finition.

### Croissance du lot

Le poids du lot suit une courbe sigmoïde :

```
poids_moyen_jour_J = poids_final × (1 - e^(-k × J)) / (1 + e^(-(J - inflexion)/steepness))

Simplifié pour le calcul quotidien :
GMQ_jour_J = GMQ_base × courbe_croissance[J] × facteur_IC × facteur_temperature
poids_jour_J = poids_jour_J-1 + GMQ_jour_J
```

| Filière | GMQ moyen | Poids final | Durée |
|---------|-----------|-------------|-------|
| Standard | 55-65 g/jour | 2,0-2,5 kg | 35-42 jours |
| Label Rouge | 25-35 g/jour | 2,2-2,8 kg | 81-90 jours |
| Bio | 25-35 g/jour | 2,2-2,8 kg | 81-90 jours |

### Vente du lot

Le lot est vendu **en entier** à l'abattoir quand le poids cible est atteint (ou au choix du joueur après un minimum de jours).

```
revenu_lot = effectif_vivant × poids_moyen × prix_kg_vif × bonus_qualité
```

Le `bonus_qualité` (1,0-1,15) dépend de l'homogénéité du lot (écart-type des poids faible = prime).



---

## 3. Indice de Consommation (IC) — KPI central

### Définition

```
IC = kg d'aliment consommé par le lot / kg de poids gagné par le lot
```

L'IC est **LE** indicateur de performance en poulet de chair. C'est ce qui sépare un éleveur rentable d'un éleveur déficitaire. Un IC de 1,60 vs 1,90 sur un lot de 20 000 poulets représente **6 000 kg d'aliment** de différence = **2 100 € d'économie**.

### Valeurs de référence

| Filière | IC optimal | IC moyen | IC mauvais |
|---------|:----------:|:--------:|:----------:|
| Standard (35-42j) | 1,55 | 1,65-1,75 | >1,90 |
| Label Rouge (81j) | 2,80 | 3,00-3,20 | >3,50 |
| Bio (81j) | 2,90 | 3,10-3,30 | >3,60 |

### Facteurs influençant l'IC dans le jeu

```
IC_reel = IC_base × facteur_temperature × facteur_phase_alim × facteur_densite × facteur_sante

Où :
- IC_base = 1,60 (Standard), 2,80 (Label), 2,90 (Bio)
- facteur_temperature : 1,0 si optimal, 1,05-1,20 si trop froid/chaud
- facteur_phase_alim : 1,0 si multiphase correct, 1,08-1,15 si aliment unique
- facteur_densite : 1,0 si norme respectée, 1,05-1,15 si surdensité
- facteur_sante : 1,0 si sain, 1,10-1,30 si maladie
```

### Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| IC calculé | Oui (affiché en fin de lot) | Oui (suivi quotidien temps réel) |
| Facteurs actifs | Seul `facteur_sante` (événements) | Tous les facteurs |
| IC résultant | 1,70 fixe (Standard) | 1,55-1,95 selon conduite |
| Levier joueur | Aucun (c'est le mode simple) | Température, alimentation, densité |
| Impact économique | Charges forfaitaires 12% | Charges réelles basées sur IC |

### Affichage IC (Mode Expert)

```
┌─────────────────────────────────────────────────────────────┐
│  📊 SUIVI IC — Lot #47 (Standard, J28/42)                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  IC cumulé actuel : 1,68  [████████████░░░░] objectif: 1,65 │
│  IC journalier    : 1,72  (finition = IC naturellement ↑)   │
│                                                              │
│  Décomposition :                                             │
│  ├─ Température    : ✅ 1,00 (22°C, plan respecté)          │
│  ├─ Alimentation   : ✅ 1,00 (finition 18% MAT active)      │
│  ├─ Densité        : ⚠️ 1,03 (38 kg/m², limite haute)       │
│  └─ Santé          : ✅ 1,00 (pas d'incident)               │
│                                                              │
│  Consommation totale : 62 400 kg (3,12 kg/poulet à ce jour) │
│  Gain de poids total : 37 140 kg (1,86 kg/poulet à ce jour) │
│                                                              │
│  💡 Conseil : densité élevée (+3% IC). Le prochain lot      │
│     pourrait être réduit de 500 têtes pour optimiser.        │
└─────────────────────────────────────────────────────────────┘
```



---

## 4. Les trois filières

### Vue d'ensemble

| Paramètre | Standard | Label Rouge | Bio |
|-----------|:--------:|:-----------:|:---:|
| Durée élevage | 35-42 jours | 81 jours min | 81 jours min |
| Poids cible | 2,0-2,5 kg | 2,2-2,8 kg | 2,2-2,8 kg |
| Densité bâtiment | 20-24 poulets/m² | 11 poulets/m² | 10 poulets/m² |
| Densité poids | 33-42 kg/m² | max 25 kg/m² | max 21 kg/m² |
| Parcours extérieur | Non | 2 m²/poulet | 4 m²/poulet |
| Effectif max/bâtiment | 30 000 | 4 400 | 4 800 |
| Alimentation | Conventionnelle | Conventionnelle + 75% céréales | 100% bio |
| IC typique | 1,65-1,75 | 3,00-3,20 | 3,10-3,30 |
| Prix vente (€/kg vif) | 0,90-1,10 | 2,50-3,50 | 3,50-5,00 |
| Marge/lot (20 000 poulets) | 3 000-8 000 € | N/A (max 4 400) | N/A (max 4 800) |
| Marge/lot (effectif max) | 3 000-8 000 € | 2 500-5 000 € | 3 500-7 000 € |
| Lots/an | 6-7 | 3-4 | 3-4 |
| Souches | Ross 308, Cobb 500 | Cou Nu, JA 657, S77 | Cou Nu, JA 657 |

### Standard — Volume et efficacité

Le standard est la filière de la performance technique. Cycle ultra-court (35-42 jours), IC excellent (1,65), gros volumes. Le joueur gagne par l'optimisation de l'IC et la rotation rapide.

**Avantage gameplay** : retour sur investissement le plus rapide de tout l'élevage Agriva.
**Risque** : marge unitaire faible. Si l'IC dérape ou si le prix chute, la marge fond.

### Label Rouge — Qualité et patience

Le Label Rouge impose un temps d'élevage minimum de 81 jours, un parcours extérieur, et une densité réduite. Le poulet pousse lentement (souche à croissance lente), mais se vend 2,5× plus cher.

**Avantage gameplay** : marge/animal bien supérieure, moins de rotations = moins de micro-gestion.
**Risque** : capital immobilisé plus longtemps, besoin de surface (parcours), moins de lots/an.

**Conditions à respecter (vérifiées automatiquement)** :
- Bâtiment ≤ 4 400 poulets
- Parcours extérieur clôturé : 2 m²/poulet
- Durée ≥ 81 jours
- Souche à croissance lente (pas de Ross/Cobb)

### Bio — Premium et exigence

Le Bio combine les contraintes du Label Rouge avec une alimentation 100% bio (surcoût 30-50% sur l'aliment) et un parcours doublé (4 m²/poulet).

**Avantage gameplay** : prix de vente max, image, déblocage de circuits de vente premium.
**Risque** : coût alimentation élevé, surface parcours importante, rentabilité dépendante du prix bio.

**Conditions supplémentaires vs Label** :
- Parcours 4 m²/poulet (vs 2 m²)
- Aliment 100% bio (+40% coût)
- Densité max 10/m² intérieur



---

## 5. Conduite en bandes — Tout-plein / Tout-vide

### Principe

Un bâtiment accueille un lot complet (tout-plein), puis se vide intégralement (tout-vide), suivi d'un vide sanitaire avant le lot suivant. **Jamais de mélange d'âges** dans un même bâtiment.

### Calendrier type (Standard, 1 bâtiment)

| Lot | Entrée poussins | Vente | Vide sanitaire | Durée totale |
|:---:|:--------------:|:-----:|:--------------:|:------------:|
| 1 | J1 | J39 | J40-J57 | 57 jours |
| 2 | J58 | J96 | J97-J114 | 57 jours |
| 3 | J115 | J153 | J154-J171 | 57 jours |
| 4 | J172 | J210 | J211-J228 | 57 jours |
| 5 | J229 | J267 | J268-J285 | 57 jours |
| 6 | J286 | J324 | J325-J342 | 57 jours |
| 7 | J343 | J365 | — | Fin d'année |

→ **6-7 lots/an** en Standard (cycle 50-57 jours tout compris).

### Vide sanitaire

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| Durée | 18 jours (fixe) | 15-21 jours (choix joueur) |
| Effet 15 jours | — | Risque sanitaire lot suivant +15% |
| Effet 18 jours | Standard | Risque sanitaire normal |
| Effet 21 jours | — | Risque sanitaire lot suivant -20% |
| Coût | Inclus dans charges 12% | Chauffage bâtiment vide + produits désinfection |

### Multi-bâtiments (Mode Expert)

Un joueur Expert avec 3 bâtiments peut **décaler les lots** pour avoir un flux continu de revenus :

```
Bâtiment A : |███LOT 1███|░░VIDE░░|███LOT 2███|░░VIDE░░|███LOT 3███|
Bâtiment B : |░░░░|███LOT 1███|░░VIDE░░|███LOT 2███|░░VIDE░░|███LOT 3█|
Bâtiment C : |░░░░░░░░|███LOT 1███|░░VIDE░░|███LOT 2███|░░VIDE░░|███LO|

Semaine :     1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18
Revenus :              $        $        $        $        $        $
```

→ Revenu toutes les 3 semaines au lieu de toutes les 8 semaines.

### Planificateur de bandes (Expert uniquement)

Le joueur Expert dispose d'un outil de planification pour visualiser l'occupation de ses bâtiments et optimiser les décalages.



---

## 6. Bâtiment

### Types de poulaillers

| Type | Surface | Capacité Standard | Capacité Label | Investissement | Amortissement |
|------|:-------:|:-----------------:|:--------------:|:--------------:|:-------------:|
| Petit | 400 m² | 8 000-9 600 | 4 400 | 150 000 € | 15 ans |
| Moyen | 800 m² | 16 000-19 200 | 4 400 (limité) | 220 000 € | 15 ans |
| Grand | 1 200 m² | 24 000-28 800 | N/A (>4 400 interdit) | 300 000 € | 15 ans |
| XL | 1 500 m² | 30 000-36 000 | N/A | 380 000 € | 15 ans |

**Note** : en Label Rouge/Bio, l'effectif est plafonné à 4 400/bâtiment quel que soit la surface. Un bâtiment de 400 m² est optimal pour le Label.

### Densité

```
densite_kg_m2 = (effectif_vivant × poids_moyen) / surface_batiment

Contrainte Standard : densite_kg_m2 ≤ 42 (directive UE 2007/43)
Contrainte Label   : effectif ≤ 11 poulets/m² ET ≤ 4 400 total
Contrainte Bio     : effectif ≤ 10 poulets/m² ET ≤ 4 800 total
```

**Mode Normal** : la densité est calculée automatiquement à l'achat. Le jeu refuse un lot surdimensionné.
**Mode Expert** : le joueur peut pousser la densité (jusqu'à 42 kg/m²) mais subit une dégradation de l'IC.

### Chauffage — Plan de température

Le chauffage est **critique** en poulet de chair. Les poussins d'un jour meurent si la température n'est pas à 32°C.

| Jour | Température cible | Tolérance |
|:----:|:-----------------:|:---------:|
| J1-J3 | 32°C | ±1°C |
| J4-J7 | 30°C | ±1°C |
| J8-J14 | 27°C | ±2°C |
| J15-J21 | 24°C | ±2°C |
| J22-J28 | 22°C | ±2°C |
| J29+ | 20°C | ±3°C |

**Règle** : -3°C par semaine depuis J1 (32°C) jusqu'à stabilisation à 20°C.

**Mode Normal** : le chauffage suit automatiquement le plan. Coût intégré aux charges 12%.
**Mode Expert** : le joueur règle la température. Écarts = impacts sur mortalité et IC.

```
impact_temperature :
  Si écart > tolérance ET trop froid : mortalité ×1,5 + IC ×1,10
  Si écart > tolérance ET trop chaud : mortalité ×1,3 + IC ×1,08
  Si écart > 2× tolérance : mortalité ×3,0 + IC ×1,25 (catastrophe)
```

### Ventilation

| Saison | Besoin | Mode Normal | Mode Expert |
|--------|--------|-------------|-------------|
| Hiver | Renouvellement air (NH3, humidité) | Auto | Réglage min/max |
| Été | Refroidissement (>30°C externe = stress thermique) | Auto | Brumisation, tunnel |
| Canicule | Urgence (>35°C = mortalité massive) | Événement scripteur | Gestion active requise |

### Coût énergétique du bâtiment (Expert)

| Poste | Coût/lot (Standard, 20 000 poulets) |
|-------|:------------------------------------:|
| Chauffage (propane/gaz) | 1 500-2 500 € |
| Électricité (ventilation, éclairage) | 400-700 € |
| Litière (copeaux de bois, 8 cm) | 300-500 € |
| Eau | 100-200 € |
| Désinfection (vide sanitaire) | 200-400 € |
| **Total énergie+consommables** | **2 500-4 300 €/lot** |



---

## 7. Alimentation multiphase

### Principe

Le poulet de chair reçoit 3 aliments successifs adaptés à ses besoins changeants. L'alimentation est le **premier poste de charge** (60-65% du coût de production).

### Les 3 phases

| Phase | Période | MAT (%) | Énergie (EM kcal/kg) | Forme | Consommation/jour |
|-------|:-------:|:-------:|:--------------------:|:-----:|:-----------------:|
| Démarrage | J0-J10 | 22% | 3 050 | Miettes | 20-50 g |
| Croissance | J11-J25 | 20% | 3 100 | Granulés 2mm | 70-130 g |
| Finition | J26-abattage | 18% | 3 150 | Granulés 3mm | 140-190 g |

### Consommation totale sur le cycle (Standard, 1 poulet)

| Phase | Durée | Conso totale/poulet | Coût aliment/tonne | Coût/poulet |
|-------|:-----:|:-------------------:|:------------------:|:-----------:|
| Démarrage | 10 j | 0,35 kg | 420 €/t | 0,15 € |
| Croissance | 15 j | 1,50 kg | 370 €/t | 0,56 € |
| Finition | 17 j | 2,30 kg | 340 €/t | 0,78 € |
| **Total** | **42 j** | **4,15 kg** | — | **1,49 €** |

→ Pour un lot de 20 000 poulets : **83 tonnes d'aliment** = **29 800 €**

### Mode Normal

Le joueur achète de l'« aliment poulet de chair » unique. Le système applique automatiquement une consommation forfaitaire et un IC de 1,70. Pas de transition à gérer.

### Mode Expert

Le joueur achète les 3 types d'aliment séparément et **programme les transitions** :

```
┌─────────────────────────────────────────────────────────────────┐
│  🌾 PLAN ALIMENTAIRE — Lot #47 (Standard)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Phase actuelle : FINITION (J28)                                 │
│                                                                  │
│  J0────J10────J25────J42                                         │
│  ▓▓▓▓▓▓████████████████████░░░░░░░░░░░░░░░░░░                   │
│  DÉMAR.  CROISSANCE     FINITION                                 │
│  22%MAT   20%MAT        18%MAT                                   │
│                                                                  │
│  Stocks disponibles :                                            │
│  ├─ Démarrage : 0 kg restant (lot consommé) ✅                   │
│  ├─ Croissance : 250 kg restant (surplus reportable) ✅          │
│  └─ Finition : 18 400 kg restant (besoin estimé: 22 000 kg) ⚠️  │
│                                                                  │
│  ⚠️ ALERTE : stock finition insuffisant pour fin de lot !        │
│     Commande suggérée : 5 000 kg (livraison J+2)                 │
│                                                                  │
│  Transition J10→J11 : progressive (3 jours mélange) ✅           │
│  Transition J25→J26 : progressive (3 jours mélange) ✅           │
│                                                                  │
│  IC impact alimentation : 1,00 (multiphase correcte)             │
└─────────────────────────────────────────────────────────────────┘
```

### Impact sur l'IC

| Scénario alimentation | Facteur IC | Explication |
|-----------------------|:----------:|-------------|
| Multiphase correcte (3 aliments, transitions J10/J25) | 1,00 | Optimal |
| Multiphase avec mauvais timing (±3 jours) | 1,03 | Léger surcoût |
| Aliment unique (mode Normal) | 1,08 | Perte d'efficacité 8% |
| Rupture d'alimentation (stock = 0) | 1,25 + mortalité +2% | Catastrophe |

### Alimentation Label/Bio

| Contrainte | Label Rouge | Bio |
|-----------|-------------|-----|
| Céréales dans la ration | ≥ 75% | ≥ 65% |
| Origine aliment | Conventionnel OK | 100% bio |
| Surcoût vs Standard | +10-15% | +35-50% |
| Coût aliment/poulet | 2,80-3,20 € | 3,50-4,50 € |



---

## 8. Santé

### Maladies modélisées

| Maladie | Probabilité/lot | Déclencheur | Effet | Traitement |
|---------|:--------------:|-------------|-------|-----------|
| Grippe aviaire (IAHP) | 2-5%/an (événement serveur) | Saison oct-mai, proximité eau | **Abattage total du lot** | Aucun. Perte sèche. |
| Coccidiose | 8-15%/lot (Expert) | Litière humide, stress | Mortalité +3-5%, IC +0,15 | Anticoccidien (0,05€/poulet) |
| Newcastle | 1-3%/an | Non vacciné | Mortalité +10-20% | Vaccination préventive obligatoire |
| Stress thermique | Variable | Canicule (>35°C ext.) | Mortalité +5-15% en 24-48h | Ventilation, brumisation |

### Grippe aviaire — Enjeu majeur

La grippe aviaire est LE risque catastrophique de la filière. C'est un **événement de serveur** qui touche aléatoirement les joueurs de volaille pendant la saison à risque.

**Mécaniques** :

| Phase | Effet | Durée |
|-------|-------|-------|
| Alerte régionale | Claustration obligatoire (pas de parcours extérieur) | Oct-Mai |
| Foyer déclaré (zone 3 km) | Abattage préventif = lot perdu | Immédiat |
| Zone réglementée (10 km) | Interdiction de mouvement, pas de vente/achat | 21 jours |
| Levée restrictions | Retour à la normale | Après 21j sans cas |

**Mode Normal** : la grippe aviaire est un événement rare (1-2%/an de chances). Si le joueur est touché, il perd le lot en cours mais reçoit une indemnisation partielle (70% de la valeur du lot).

**Mode Expert** : la biosécurité réduit le risque. Investissement en mesures préventives :

| Mesure | Coût | Effet |
|--------|------|-------|
| Filets anti-oiseaux | 3 000-5 000 €/bâtiment | Risque -30% |
| Sas d'entrée | 2 000-4 000 € | Risque -20% |
| Pédiluve + protocole | 500 €/an | Risque -10% |
| Vaccination (depuis 2024) | 0,15 €/poulet | Risque -50% |
| Score biosécurité max | Cumul | Risque total -70% |

### Vaccination obligatoire

| Vaccin | Coût | Application | Effet |
|--------|------|-------------|-------|
| Newcastle | 0,03 €/poulet | Eau de boisson J1 | Évite Newcastle |
| Bronchite infectieuse | 0,02 €/poulet | Spray J1 | Réduction respiratoire |
| Gumboro | 0,03 €/poulet | Eau J14 | Protection immunitaire |
| **Total vaccins** | **0,08 €/poulet** | Auto (Normal) / Manuel (Expert) | Protection de base |

**Mode Normal** : vaccination automatique, coût inclus dans les 12% de charges.
**Mode Expert** : le joueur achète les vaccins et les planifie. Oublier = risque de maladie.

### Coccidiose (Expert uniquement)

Probabilité augmente si :
- Litière humide (pas de renouvellement)
- Densité élevée (>39 kg/m²)
- Stress thermique récent

Prévention : anticoccidien dans l'aliment (+0,02 €/poulet) ou vaccination coccidiose (+0,04 €/poulet, immunité lot entier).



---

## 9. Économie

### Structure des coûts (Standard, lot de 20 000 poulets, 42 jours)

| Poste | Coût | % du total |
|-------|:----:|:----------:|
| Poussins (20 000 × 0,50 €) | 10 000 € | 22% |
| Aliment (83 t × 360 €/t moy.) | 29 880 € | 65% |
| Chauffage + énergie | 2 200 € | 5% |
| Litière + eau | 500 € | 1% |
| Vaccins + santé | 1 600 € (0,08 €/poussin) | 3% |
| Désinfection vide sanitaire | 300 € | 1% |
| Assurance + divers | 500 € | 1% |
| **Total charges opérationnelles** | **44 980 €** | **100%** |

### Recette

```
Effectif vendu = 20 000 × (1 - mortalité 3%) = 19 400 poulets
Poids moyen = 2,3 kg
Prix Standard = 1,00 €/kg vif

Recette = 19 400 × 2,3 × 1,00 = 44 620 €
```

### Marge par lot

| Scénario | Recette | Charges | Marge brute |
|----------|:-------:|:-------:|:-----------:|
| Prix bas (0,90 €/kg) | 40 158 € | 44 980 € | **-4 822 €** ❌ |
| Prix moyen (1,00 €/kg) | 44 620 € | 44 980 € | **-360 €** ⚠️ |
| Prix bon (1,10 €/kg) | 49 082 € | 44 980 € | **+4 102 €** ✅ |
| IC optimisé (1,60) + prix bon | 49 082 € | 42 300 € | **+6 782 €** ✅✅ |

**Constat** : la marge Standard est **très serrée**. C'est réaliste. L'éleveur gagne sur le volume (6-7 lots/an) et l'optimisation de l'IC.

### Marge annuelle (1 bâtiment)

| Filière | Marge/lot | Lots/an | Marge annuelle brute |
|---------|:---------:|:-------:|:--------------------:|
| Standard (IC moyen, prix moyen) | 3 000-5 000 € | 6,5 | 19 500-32 500 € |
| Standard (IC optimisé, prix bon) | 6 000-8 000 € | 6,5 | 39 000-52 000 € |
| Label Rouge (4 400 poulets) | 2 500-5 000 € | 3,5 | 8 750-17 500 € |
| Bio (4 800 poulets) | 3 500-7 000 € | 3,5 | 12 250-24 500 € |

### Investissement et retour

| Investissement | Montant | Retour estimé |
|----------------|:-------:|:-------------:|
| Poulailler 400 m² (Standard) | 150 000 € | 5-8 ans |
| Poulailler 800 m² (Standard) | 220 000 € | 5-7 ans |
| Poulailler 1 200 m² (Standard) | 300 000 € | 5-7 ans |
| Parcours clôturé 2 ha (Label) | 15 000 € | Inclus dans marge Label |
| Équipement biosécurité complet | 10 000-15 000 € | Évite 1 perte grippe aviaire |

### Mode Normal — Charges simplifiées

En Mode Normal, le joueur ne voit pas les 10 lignes de charges. Il paie :
- **Poussins** : coût visible à l'achat
- **Aliment** : coût visible (achat au grossiste)
- **Charges forfaitaires 12%** : appliquées sur la recette (énergie + véto + divers)

Marge Normal = Recette × 0,88 - Poussins - Aliment

### Mode Expert — Charges détaillées (28%)

Le joueur Expert voit toutes les lignes et peut les optimiser individuellement :
- Chauffage réduit si bonne isolation
- Mortalité réduite si bonne conduite → moins de poussins "perdus"
- IC optimisé → moins d'aliment

Mais les charges de structure sont plus élevées (amortissement visible, assurances, compta).

---

## 9bis. Poules pondeuses — Production d'œufs

### 9bis.1 Intention de design

Les poules pondeuses sont le **pendant du poulet de chair** : un revenu quotidien régulier (comme le lait) plutôt qu'un lot vendu d'un coup. Le joueur pondeuses construit un revenu stable et gère la qualité des œufs.

### 9bis.2 Races de pondeuses

| Race | Production (œufs/an) | Poids œuf (g) | Couleur coquille | Durée exploitation | Prix/poule |
|------|:--------------------:|:-------------:|:----------------:|:-----------------:|:----------:|
| ISA Brown (hybride) | 300-320 | 60-65 | Brun | 72 semaines | 8 € |
| Lohmann Brown | 290-310 | 62-67 | Brun | 72 semaines | 9 € |
| Marans | 200-220 | 65-70 | Brun foncé (roux) | 72 semaines | 15 € |
| Leghorn (blanche) | 310-330 | 58-62 | Blanc | 72 semaines | 7 € |
| Sussex | 240-260 | 60-65 | Crème | 72 semaines | 12 € |
| Poule bleue de France | 250-270 | 62-68 | Brun | 72 semaines | 14 € |

### 9bis.3 Systèmes de production

| Système | Densité | Surface extérieure | Production | Prix œuf (×base) | Investissement |
|---------|:-------:|:------------------:|:----------:|:-----------------:|:--------------:|
| Cage aménagée | 750 cm²/poule | 0 m² | 100% | ×0,85 | 45 €/place |
| Au sol (barn) | 9 poules/m² | 0 m² | 95% | ×1,00 | 55 €/place |
| Plein air | 9 poules/m² intérieur | 4 m²/poule | 92% | ×1,20 | 65 €/place |
| Label Rouge | 9 poules/m² | 5 m²/poule | 88% | ×1,40 | 75 €/place |
| Bio | 6 poules/m² | 10 m²/poule | 85% | ×1,80 | 90 €/place |

### 9bis.4 Production et calibrage des œufs

#### Courbe de ponte

```
Semaine 18-20 : entrée en ponte (5% → 95% en 4 semaines)
Semaine 24-30 : pic de ponte (95-98% de taux de ponte)
Semaine 30-50 : plateau (90-95%)
Semaine 50-72 : déclin progressif (90% → 75%)
Semaine 72+   : réforme recommandée (ponte < 75%, coût alimentaire > recette)

Taux de ponte = œufs pondus / nombre de poules / jour
  Exemple : 3 000 poules × 93% = 2 790 œufs/jour
```

#### Calibrage des œufs

| Calibre | Poids | Proportion (ISA Brown) | Prix unitaire (base conventionnel) |
|---------|:-----:|:---------------------:|:---------------------------------:|
| S (petit) | < 53 g | 8% | 0,08 € |
| M (moyen) | 53-63 g | 35% | 0,12 € |
| L (gros) | 63-73 g | 45% | 0,14 € |
| XL (très gros) | > 73 g | 12% | 0,16 € |

Le calibre évolue avec l'âge de la poule : jeune = plus de S/M, vieille = plus de L/XL.

### 9bis.5 Équipement spécifique

| Équipement | Prix | Capacité | Effet |
|-----------|:----:|:--------:|-------|
| Nids automatiques (bande collecte) | 12 000 € | 3 000 poules | Collecte auto des œufs, -1 h/jour de ramassage |
| Robot de ramassage (tapis roulant → tri) | 28 000 € | 6 000 poules | Ramassage 100% auto, tri en entrée de calibreuse |
| Calibreuse-mireuse | 18 000 € | 5 000 œufs/h | Tri par poids + mirage (élimine fêlés/sales) — requis pour grossiste |
| Salle de conditionnement | 25 000 € | — | Emballage alvéoles, datage, étiquetage — requis pour vente directe > 500 œufs/semaine |
| Éclairage programmable | 3 500 € | Par bâtiment | Stimulation lumineuse 16h/jour → maintien taux de ponte |
| Chaîne d'alimentation automatique | 8 000 € | Par bâtiment | Distribution continue, -30 min/jour |
| Abreuvoir nipple (ligne) | 2 500 € | Par bâtiment | Eau propre en continu, -20% mortalité |

### 9bis.6 Temps de travail pondeuses (ADR-004)

```
Lot de 3 000 poules pondeuses au sol :

  Ramassage œufs (sans robot) :
    3 000 × 93% = 2 790 œufs/jour
    Temps : 2 790 ÷ 600 œufs/h = 4,6 h/jour (×365 = 1 679 h/an)

  Ramassage œufs (avec robot) :
    Surveillance + intervention : 0,5 h/jour (×365 = 182 h/an)

  Calibrage + conditionnement :
    2 790 ÷ 5 000 œufs/h = 0,6 h/jour (machine)
    Emballage : 0,8 h/jour
    Total : 1,4 h/jour (511 h/an)

  Alimentation (avec chaîne auto) : 0,3 h/jour (110 h/an)
  Nettoyage litière : 1 h/semaine (52 h/an)
  Vide sanitaire (entre lots) : 40 h par changement (1×/72 semaines)

  TOTAL ANNUEL (sans robot) : 2 352 h/an → 1,5 employé
  TOTAL ANNUEL (avec robot) : 855 h/an → 0,5 employé
```

### 9bis.7 Économie pondeuse

| Paramètre | Valeur (3 000 poules, plein air) |
|-----------|----------------------------------|
| CA œufs/an | 2 790 œufs/j × 0,14 €/œuf × 1,20 (plein air) × 365 = 171 730 €/an |
| Charges alimentaires | 3 000 × 120 g/j × 0,38 €/kg × 365 = 49 932 €/an |
| Charges amortissement poules | 3 000 × 9 € ÷ 1,4 an = 19 286 €/an |
| Charges bâtiment + énergie | 12 000 €/an |
| Charges MO (1 employé) | 26 000 €/an |
| **Bénéfice avant charges sociales** | **≈ 64 500 €/an** |
| Charges sociales (12% du bénéfice, ADR-002) | 64 500 × 0,12 = -7 740 €/an |
| **Résultat net** | **≈ 56 760 €/an** (18,9 €/poule/an) |

> ⚠️ **Note d'équilibrage** : le résultat net de 56 760 € dépasse la cible 38-50 k€.
> C'est justifié car ce scénario suppose 3 000 pondeuses plein-air = une exploitation
> spécialisée professionnelle (investissement bâtiment ≈ 200 000 €, 1 employé dédié).
> La rentabilité/poule reste modeste (18,9 €/poule/an) et le risque sanitaire (grippe
> aviaire) peut effacer une année entière de résultat.

### 9bis.8 Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Taux de ponte | Automatique selon race + âge | + alimentation, stress, éclairage, densité |
| Calibrage | Automatique (proportions fixes) | Influencé par nutrition (Ca, protéines) |
| Maladies | Jauge santé globale | Coccidiose, variole, mycoplasme — gestion individuelle |
| Réforme | Alerte « troupeau à renouveler » à 72 semaines | Choix de date (mue forcée possible pour +20 semaines) |
| Vide sanitaire | Automatique (14 jours) | Durée au choix (14-28 j), désinfection niveaux |
| DLC œufs | Non modélisée | 28 jours max — gestion rotation stock |


---

## 10. Équilibrage et scénarios

### Objectifs d'équilibrage

| Objectif | Cible | Garde-fou |
|----------|-------|-----------|
| Marge Standard/lot | 3 000-8 000 € | Jamais > 10 000 € (sinon trop facile) |
| Marge Standard/an (1 bât.) | 20 000-50 000 € | Cohérent avec revenu réel France |
| IC Standard jouable | 1,60-1,90 | Impossible d'aller sous 1,55 |
| Mortalité | 2-8% | Jamais 0% (irréaliste), jamais >15% sauf grippe |
| Retour investissement bât. | 5-8 ans | Pas < 3 ans (trop facile), pas > 12 ans (décourageant) |
| Serveur Expert internement équilibré | Expert ≈ Normal (comparaison informative) | Chaque serveur est viable en lui-même ; aucune équivalence de rentabilité n'est requise (ADR-005) |
| Avantage Expert | Variance réduite | Expert = résultats plus prévisibles, pas plus élevés |

### Équilibrage interne du serveur Expert (comparaison informative, cf. ADR-005)

| Métrique | Normal | Expert bien joué | Expert mal joué |
|----------|:------:|:----------------:|:---------------:|
| Marge/lot Standard | 4 000 € | 4 200 € | 1 500 € |
| Charges | 12% recette = 5 354 € | 28% détaillé ≈ 12 500 € | 28% = 12 500 € |
| Revenu net (recette - charges - intrants) | 4 000 € | 4 200 € | 1 500 € |
| Ratio max Expert/Normal | — | **1,05×** (informatif) | 0,37× (punitif) |

Les deux serveurs étant séparés (ADR-005), la comparaison ci-dessus est informative et non contraignante. L'essentiel est que le serveur Expert soit internement équilibré : l'Expert bien joué gagne correctement sa vie, et son avantage réel est la **résilience** (biosécurité, gestion active).

### Scénario chiffré complet : première année d'un joueur Standard (Normal)

**Investissement initial** :
- Poulailler 400 m² : 150 000 €
- (Financement : emprunt 15 ans, mensualité ≈ 1 000 €/mois = 12 000 €/an)

**Lot 1 (premier lot, apprentissage)** :

| Étape | Calcul | Montant |
|-------|--------|:-------:|
| Achat 8 000 poussins Standard | 8 000 × 0,50 € | -4 000 € |
| Aliment (IC 1,70, 42 jours) | 8 000 × 2,3 kg × 1,70 × 0,36 €/kg | -11 290 € |
| Mortalité 3% | 8 000 × 0,03 = 240 morts | -240 poulets |
| Effectif vendu | 8 000 - 240 = 7 760 | — |
| Poids moyen vente | 2,3 kg | — |
| Recette brute | 7 760 × 2,3 × 1,00 €/kg | +17 848 € |
| Charges forfaitaires 12% | 17 848 × 0,12 | -2 142 € |
| **Marge lot 1** | 17 848 - 2 142 - 4 000 - 11 290 | **+416 €** |

**Année complète (6,5 lots)** :

| Poste | Montant |
|-------|:-------:|
| Marge cumulée 6,5 lots (prix variable 0,95-1,05) | +2 700 à +18 000 € |
| Marge moyenne attendue (bénéfice avant charges sociales) | +10 400 € |
| Charges sociales (12% du bénéfice, ADR-002) | -1 248 € |
| Remboursement emprunt | -12 000 € |
| **Résultat année 1** | **-2 848 €** (normal, investissement) |
| **Résultat année 2+** (lots plus gros, meilleur prix) | **+4 000 à +13 200 €** |

**Verdict** : le joueur ne s'enrichit pas immédiatement (réaliste). La rentabilité vient avec :
1. L'augmentation de la taille des lots (remplir le bâtiment)
2. L'optimisation marginale de l'IC (Expert)
3. L'ajout d'un 2ème bâtiment (économie d'échelle)

### Scénario catastrophe : grippe aviaire (Expert)

| Événement | Impact |
|-----------|--------|
| Lot en cours : 20 000 poulets à J30 (quasi prêts) | Valeur lot ≈ 44 000 € investis |
| Abattage préventif imposé | Perte totale du lot |
| Indemnisation (Expert) | 50% valeur estimée = 22 000 € |
| Indemnisation (Normal) | 70% valeur = 30 800 € |
| Bâtiment bloqué | 21 jours zone réglementée + 18 jours vide = 39 jours perdus |
| Perte totale | -22 000 € (Expert) / -13 200 € (Normal) + 1 lot perdu |

→ L'Expert perd plus en € (indemnisation moindre) mais sa biosécurité réduit la probabilité d'être touché. Le Normal est protégé par une meilleure indemnisation (ADR-002 : pas de perte définitive disproportionnée).

### Scénario Label Rouge vs Standard (comparaison)

| Métrique | Standard (800 m², 16 000 poulets) | Label (400 m², 4 400 poulets) |
|----------|:---------------------------------:|:-----------------------------:|
| Investissement bâtiment | 220 000 € | 150 000 € |
| Investissement parcours | 0 € | 15 000 € (8 800 m² clôturés) |
| Coût poussins/lot | 8 000 € | 4 400 € |
| Coût aliment/lot | 22 000 € | 14 000 € (IC 3,0 mais petit lot) |
| Charges énergie/lot | 3 500 € | 1 800 € |
| Recette/lot (prix × poids × effectif) | 16 000 × 0,97 × 2,3 × 1,00 = 35 696 € | 4 400 × 0,96 × 2,5 × 3,00 = 31 680 € |
| Marge/lot | 4 500-6 000 € | 3 500-5 500 € |
| Lots/an | 6,5 | 3,5 |
| **Marge annuelle** | **29 000-39 000 €** | **12 000-19 000 €** |

→ Le Standard est plus rentable en volume. Le Label est moins risqué (marché plus stable, prix garanti) et demande moins de surface bâtiment. Choix stratégique légitime.

### Checklist playtest

| Test | Critère | Bloquant |
|------|---------|:--------:|
| Test recette SimAgri | Un joueur SimAgri dit « c'est SimAgri en mieux » | ✅ Oui |
| Progression fluide | Le 1er lot est rentable sans lecture de doc | ✅ Oui |
| Pas de faillite Normal | Impossible de perdre tout son argent en Normal | ✅ Oui |
| IC compréhensible | Le joueur comprend IC = aliment/gain en 1 phrase | ✅ Oui |
| Label = choix viable | Le Label n'est ni dominant ni inutile | ✅ Oui |
| Expert ≠ plus riche | Vérifier que Expert gagne max 5% de plus | ✅ Oui |
| Grippe aviaire pas punitive (Normal) | Indemnisation 70%, pas de faillite | ✅ Oui |
| Cycle satisfaisant | Le joueur ressent le « ding » de la vente du lot | ❌ Non (UX) |
| Multi-bâtiments engageant | 3 bâtiments décalés = flux continu | ❌ Non (UX) |



---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| **Achat lot** | Choix filière + effectif | + choix souche (Ross/Cobb/Cou Nu) |
| **Effectif** | 1 000-30 000 (selon bâtiment) | Idem + optimisation densité |
| **Prix poussin** | 0,45-1,30 € selon filière | Idem |
| **Alimentation** | Aliment unique, consommation auto | 3 phases (démarrage/croissance/finition) |
| **IC résultant** | 1,70 fixe (Standard) | 1,55-1,95 selon conduite |
| **Température** | Automatique (plan suivi) | Réglage manuel, impact IC/mortalité |
| **Mortalité** | 3% fixe (Standard), 4% (Label/Bio) | 2-8% selon conduite |
| **Densité** | Calculée auto, refus si surdimensionné | Réglable, pénalité IC si trop élevée |
| **Vide sanitaire** | 18 jours fixe | 15-21 jours, impact lot suivant |
| **Bandes** | 1 lot/bâtiment, séquentiel | Planning multi-bâtiments décalés |
| **Santé/vaccins** | Automatique, inclus dans 12% | Achat et planification manuelle |
| **Grippe aviaire** | Rare (1-2%/an), indemnisation 70% | Biosécurité réduit risque, indemn. 50% |
| **Coccidiose** | N'existe pas (simplifié) | Risque 8-15%/lot, prévention requise |
| **Charges** | 12% forfaitaire sur recette | 28% détaillées (énergie, litière, véto...) |
| **Marge/lot Standard** | ~4 000 € (stable) | 1 500-6 500 € (variable selon skill) |
| **Avantage Expert** | — | Résilience aux crises, variance réduite sur le long terme |
| **Risque max Normal** | 1 lot perdu (grippe) → -13 000 € | 1 lot perdu → -22 000 € |
| **Recette bâtiment/an** | 20 000-35 000 € | 18 000-50 000 € (amplitude plus large) |

---

## Mockup — Interface principale du lot (Mode Normal)

```
┌──────────────────────────────────────────────────────────────────────┐
│  🐔 POULAILLER A — Lot #12 (Standard)                     J28 / 42  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Effectif : 15 680 / 16 000   (mortalité 2,0% — en bonne voie)      │
│  Poids moyen : 1,72 kg        ████████████████░░░░  cible: 2,3 kg   │
│  Progression :                 ██████████████░░░░░░  66% du cycle    │
│                                                                       │
│  Aliment restant : 12 400 kg   ████████░░░░  (suffisant ✅)          │
│  Consommation/jour : 2 350 kg                                        │
│                                                                       │
│  Estimation vente :                                                   │
│  ├─ Date prévue : dans 14 jours                                      │
│  ├─ Recette estimée : 36 064 €  (15 680 × 2,3 kg × 1,00 €/kg)      │
│  └─ Marge estimée : ~3 800 €                                         │
│                                                                       │
│  [🛒 Acheter aliment]  [📊 Détails]  [⏩ Vendre maintenant]          │
│                                                                       │
│  💡 Tout se passe bien ! Votre lot sera prêt à la vente dans 14j.   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Filière absente de SimAgri, ajout prioritaire n°1 |
| 2026-08-04 | Ajout §9bis Poules pondeuses — Production d'œufs (complet) | Audit couverture fonctionnelle — système 5.9 partiel |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
