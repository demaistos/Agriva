> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Spécialisations végétales

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `docs/design/GDD-cultures.md`, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`, `decisions/ADR-003-expert-nest-pas-plus-rentable.md`

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

Les spécialisations végétales sont des **voies de diversification** qui offrent des marges supérieures aux grandes cultures, en contrepartie de :
- Du matériel dédié (non mutualisable avec les grandes cultures)
- Du temps de travail supérieur (main d'œuvre, passages répétés)
- De la technicité (savoir-faire spécifique, risques d'échec en Expert)
- Des surfaces limitées (verger max 5 ha, PDT max 20% SAU)

Le joueur qui investit dans une spécialisation construit un avantage compétitif mais **concentre son risque**. Une grêle sur un verger = perte totale de la récolte.

### 1.2 Ce que SimAgri fait bien / mal

| SimAgri fait bien | SimAgri fait mal |
|-------------------|------------------|
| Arboriculture présente et rentable | Aucune différence entre espèces fruitières |
| PDT avec stockage spéculatif | Pas de mildiou ni de technicité |
| Bio accessible | Bio = juste un label, pas de contrainte réelle |
| — | Pas d'irrigation réaliste |
| — | Pas de haies ni d'agroforesterie |
| — | Pas de couverts ni CIPAN |

### 1.3 Gameplay loop des spécialisations

```
┌───────────────────────────────────────────────────────────────────┐
│  CYCLE ANNUEL DES SPÉCIALISATIONS                                 │
└───────────────────────────────────────────────────────────────────┘

  HIVER        Taille (verger, haies), compostage, stockage PDT
               ↓
  PRINTEMPS    Plantation, irrigation, traitements intensifs
               ↓
  ÉTÉ         Éclaircissage, récolte petits fruits, irrigation
               ↓
  AUTOMNE      Récolte (pommes, PDT), semis couverts, vente
               ↓
  TOUTE ANNÉE  Vente PDT (spéculation), conversion bio, entretien

TEMPO : les spécialisations ajoutent 3-6 actions/mois supplémentaires.
         Un joueur à 100% grandes cultures a 3-8 actions/mois.
         Un joueur diversifié (verger + PDT) monte à 8-14 actions/mois.
```

### 1.4 Décisions du joueur

| Décision | Quand | Impact |
|----------|-------|--------|
| Investir dans l'irrigation ? | Année 1-2 | Débloque maïs irrigué +50%, sécurise les cultures |
| Planter un verger de quoi ? | Automne | Engage 3-8 ans, espèce = créneau économique |
| Se lancer en PDT ? | Printemps | Matériel 150-250k€, marge volatile |
| Passer en bio ? | N'importe quand | 2 ans de transition difficile, puis marge supérieure |
| Planter des haies ? | Automne-hiver | Investissement lent, bonus cumulatifs |
| Stocker ou vendre les PDT ? | Oct → Juin | Spéculation : ×2 à ×8 d'écart de prix |

### 1.5 Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Irrigation | Bouton "irriguer", coût fixe | Bilan hydrique, restrictions sécheresse, quotas |
| Verger | Plantation → attente → récolte | Taille, éclaircissage, gel, calibre |
| PDT | Planter → récolter → stocker → vendre | Mildiou, défanage, taux de sucres, contrats |
| Bio | Label = prix ×1,5, rendement ×0,7 | Rotation allongée, désherbage méca, adventices |
| Haies | Bonus passif après plantation | Gestion sylvopastorale, bois énergie, biodiversité |
| Couverts | Obligation BCAE simple | Choix espèces, effet azote, CIVE méthanisation |
| Compostage | Fumier → compost (timer) | C/N ratio, retournements, qualité variable |

---

## 2. Irrigation

### 2.1 Source d'eau — Le forage

| Paramètre | Valeur |
|-----------|--------|
| Coût d'installation | 150 € |
| Niveaux | 1 à 10 |
| Débit niveau 1 | 100 000 L/jour (100 m³) |
| Débit niveau 10 | 1 000 000 L/jour (1 000 m³) |
| Upgrade | +100 m³/jour par niveau, coût progressif |
| Électricité | 0,15 €/m³ pompé |

```
Capacité d'irrigation par jour selon le niveau :
  Niveau 1  : 100 m³  → 3,3 ha à 30 mm/tour
  Niveau 3  : 300 m³  → 10 ha à 30 mm/tour
  Niveau 5  : 500 m³  → 16,7 ha à 30 mm/tour
  Niveau 7  : 700 m³  → 23,3 ha à 30 mm/tour
  Niveau 10 : 1 000 m³ → 33,3 ha à 30 mm/tour
```

### 2.2 Matériel d'irrigation

| Matériel | Prix | Surface couverte | Débit | Avantage |
|----------|:----:|:----------------:|:-----:|----------|
| Enrouleur 63 mm | 18 000 € | 8-12 ha | 25 m³/h | Flexible, déplaçable |
| Enrouleur 90 mm | 32 000 € | 15-25 ha | 50 m³/h | Gros débits |
| Enrouleur 110 mm | 45 000 € | 25-40 ha | 80 m³/h | Très grands champs |
| Pivot 4 tours | 60 000 € | 30 ha (cercle fixe) | 100 m³/h | Autonome, pas de MO |
| Pivot 6 tours | 95 000 € | 50 ha | 150 m³/h | Grandes surfaces |
| Pivot 8 tours | 150 000 € | 80 ha | 200 m³/h | Maximum du jeu |
| Rampe frontale | 40 000 € | 20-30 ha | 70 m³/h | Parcelles rectangulaires |

**Arbitrage joueur** :
- Enrouleur = flexible (déplaçable entre parcelles), mais demande de la main d'œuvre (1h pour repositionner)
- Pivot = autonome (0 action une fois installé), mais fixe sur une parcelle, perd les coins (78% de surface utile)
- Rampe = compromis, parcelles rectangulaires uniquement

### 2.3 Coût d'un tour d'eau

```
coût_tour_eau = (volume_m3 × prix_eau) + (volume_m3 × prix_énergie)

Exemple : 30 mm sur 20 ha
  Volume = 20 × 10 000 × 0,030 = 6 000 m³
  Eau    = 6 000 × 0,004 €/m³  = 24 €
  Énergie = 6 000 × 0,15 €/m³  = 900 €  ← (pompage)
  
  ERRATUM : prix énergie réel = 0,008 €/m³ (électricité pompage)
  Énergie = 6 000 × 0,008 = 48 €
  ─────────────────────────────
  Total = 72 € pour 20 ha = 3,60 €/ha/mm

COÛT PAR TOUR D'EAU (30 mm) :
  Petite parcelle (10 ha) : 36 €  → 3,60 €/ha
  Grande parcelle (30 ha) : 108 € → 3,60 €/ha
  
  COÛT SAISONNIER (maïs, 5 tours de 30 mm = 150 mm) :
  10 ha × 5 tours × 3,60 €/ha = 180 €
  30 ha × 5 tours × 3,60 €/ha = 540 €
  
  → Arrondi simplifié pour le jeu : 40-80 €/ha/tour d'eau (énergie + amortissement matériel)
```

### 2.4 Gains de rendement par l'irrigation

| Culture | Rendement sec | Rendement irrigué | Gain | Tours nécessaires |
|---------|:------------:|:-----------------:|:----:|:-----------------:|
| Maïs grain | 70 q/ha | 105 q/ha | **+35 q** (+50%) | 5-7 tours |
| Maïs ensilage | 10 t MS | 16 t MS | **+6 t** (+60%) | 5-7 tours |
| Pomme de terre | 32 t/ha | 48 t/ha | **+16 t** (+50%) | 6-8 tours |
| Betterave | 70 t/ha | 90 t/ha | **+20 t** (+29%) | 3-5 tours |
| Blé (année sèche) | 65 q/ha | 85 q/ha | **+20 q** (+31%) | 2-3 tours |
| Verger (pommier) | 28 t/ha | 40 t/ha | **+12 t** (+43%) | 8-10 tours |

### 2.5 Restrictions sécheresse (Expert uniquement)

```
4 niveaux d'interdiction — déclenchés par la météo régionale :

┌─────────────────────────────────────────────────────────────────┐
│  ⚠️ ARRÊTÉ SÉCHERESSE — Zone Sud-Ouest                          │
│                                                                 │
│  Niveau actuel : 🟠 ALERTE RENFORCÉE (niveau 3)                 │
│                                                                 │
│  Restrictions en vigueur :                                      │
│  • Irrigation interdite 3 jours/semaine (lun, mer, ven)         │
│  • Irrigation nocturne uniquement (20h-8h)                      │
│  • Cultures de printemps prioritaires (maïs, PDT, verger)       │
│  • Prairies : irrigation interdite                              │
│                                                                 │
│  Votre planning :                                               │
│  Mar 🟢  Jeu 🟢  Sam 🟢  Dim 🟢  (4 jours autorisés)            │
│  Lun 🔴  Mer 🔴  Ven 🔴          (3 jours interdits)            │
│                                                                 │
│  Débit forage disponible : 700 m³/jour                          │
│  Surface à irriguer : 45 ha (maïs 30 + PDT 15)                 │
│  Besoin théorique : 1 350 m³/jour                               │
│  ⚠️ Déficit de 650 m³/jour — prioriser les cultures !           │
│                                                                 │
│  [ Planifier l'irrigation ]  [ Voir l'arrêté complet ]          │
└─────────────────────────────────────────────────────────────────┘
```

| Niveau | Nom | Jours interdits | Horaires | Effet joueur |
|:------:|-----|:--------------:|----------|--------------|
| 1 | Vigilance | 0 | Libre | Information seulement |
| 2 | Alerte | 1/semaine | 8h-20h interdit | -14% capacité |
| 3 | Alerte renforcée | 3/semaine | Nuit uniquement | -43% capacité |
| 4 | Crise | 7/7 | **Interdit total** | 0% — culture sacrifiée |

**Fréquence** : niveau 2 = 30% des étés, niveau 3 = 15%, niveau 4 = 5%.

### 2.6 Retenue collinaire (collective)

| Paramètre | Valeur |
|-----------|--------|
| Capacité | 50 000 à 200 000 m³ |
| Coût | 150 000 à 400 000 € (projet collectif, 3-8 joueurs) |
| Remplissage | Hiver (pluie + ruissellement), interdit en été |
| Avantage | Pas de restriction sécheresse (eau stockée = eau propre) |
| Gouvernance | Vote des membres, quote-part proportionnelle à la SAU |

→ La retenue est le **seul moyen** d'irriguer sans restriction en Expert. Elle nécessite une coopération entre joueurs.



---

## 3. Arboriculture

### 3.1 Règles générales

- **Surface maximale par verger** : 5 ha
- **Nombre de vergers** : illimité (mais main d'œuvre = facteur limitant)
- **Monoespèce par parcelle** : obligatoire (un verger = une espèce)
- **Durée d'engagement** : 3 à 8 ans avant la première récolte, 15-40 ans de production

### 3.2 Les 11 espèces

| Espèce | Rendement (t/ha) | Prix (€/t) | Entrée prod. | Durée vie | Marge brute/ha |
|--------|:-----------------:|:-----------:|:------------:|:---------:|:--------------:|
| Pommier | 35-45 | 400-700 | 4 ans | 30 ans | 8 000-14 000 € |
| Poirier | 25-35 | 500-900 | 5 ans | 35 ans | 7 000-12 000 € |
| Pêcher | 20-30 | 600-1 100 | 3 ans | 18 ans | 7 500-13 000 € |
| Prunier | 15-25 | 500-800 | 5 ans | 30 ans | 4 500-9 000 € |
| Mirabellier | 10-18 | 800-1 400 | 6 ans | 35 ans | 5 000-11 000 € |
| Noyer | 2-4 | 2 500-4 500 | 8 ans | 40 ans | 4 000-10 000 € |
| Olivier | 4-8 | 1 800-3 500 | 6 ans | 40+ ans | 5 000-12 000 € |
| Cerisier | 8-14 | 1 500-3 000 | 5 ans | 25 ans | 8 000-16 000 € |
| Framboisier | 6-10 | 3 000-5 500 | 2 ans | 10 ans | 12 000-22 000 € |
| Groseillier | 5-8 | 2 500-4 000 | 2 ans | 12 ans | 8 000-14 000 € |
| Myrtillier | 4-7 | 4 000-7 000 | 3 ans | 15 ans | 12 000-25 000 € |

**Lecture** : les petits fruits (framboisier, myrtillier) offrent les meilleures marges mais nécessitent une chambre froide et une main d'œuvre très importante.

### 3.3 Itinéraire technique annuel

```
CYCLE ANNUEL D'UN VERGER (exemple : pommier en production)

  JANVIER      Taille (obligatoire)         [1 action, 40 h/ha MO]
  FÉVRIER      Traitement hiver (cuivre)    [1 action]
  MARS         Fertilisation                [1 action]
  AVRIL        Traitement floraison         [1 action]
  MAI          Éclaircissage (fruits)       [1 action, 80 h/ha MO]  ← critique
  JUIN         Irrigation + traitements     [2 actions]
  JUILLET      Irrigation + surveillance    [1 action]
  AOÛT-SEPT    RÉCOLTE                      [1 action, 150-300 h/ha MO]
  OCTOBRE      Amendement organique         [1 action]
  NOVEMBRE     Entretien inter-rangs        [1 action]

  TOTAL : 11-12 actions/an + MO considérable (300-500 h/ha/an)
```

### 3.4 Main d'œuvre — le facteur limitant

| Opération | Heures/ha | Mécanisable ? | Coût MO (15 €/h) |
|-----------|:---------:|:------------:|:-----------------:|
| Taille hivernale | 40-80 | Non | 600-1 200 €/ha |
| Éclaircissage | 60-120 | Non (sauf chimique) | 900-1 800 €/ha |
| Récolte (fruits à pépins) | 150-250 | Non | 2 250-3 750 €/ha |
| Récolte (noyer — vibreur) | 8-12 | **Oui** | 120-180 €/ha |
| Récolte (petits fruits) | 300-500 | Non | 4 500-7 500 €/ha |

→ Un verger de 5 ha de pommiers = **1 500-2 000 heures de MO/an** = 2 à 3 employés temps plein en saison.

### 3.5 Matériel spécifique

| Matériel | Prix | Usage |
|----------|:----:|-------|
| Tracteur ≤ 80 CV (fruitier) | 25 000-45 000 € | Seul tracteur passant dans les inter-rangs |
| Pulvérisateur arboriculture | 12 000-28 000 € | Face par face, confiné |
| Vibreur (noyer, prunier) | 35 000-55 000 € | Récolte mécanique noix/prunes |
| Ramasseuse | 18 000-30 000 € | Ramasse les fruits tombés |
| Plateforme de récolte | 8 000-15 000 € | Travail en hauteur (cerises, poires) |
| Broyeur inter-rangs | 5 000-12 000 € | Entretien de l'herbe |
| Chambre froide (100 t) | 45 000-80 000 € | Stockage petits fruits (obligatoire) |

**Contrainte** : le tracteur grandes cultures (120+ CV) **ne passe pas** dans un verger. Il faut un tracteur fruitier dédié.

### 3.6 Protection — Filet anti-grêle

| Paramètre | Valeur |
|-----------|--------|
| Coût installation | 12 000-18 000 €/ha |
| Durée de vie | 15 ans |
| Protection | 95% des dégâts de grêle évités |
| Sans filet + grêle | **Perte 60-100% de la récolte** |
| Probabilité grêle/an | 8% par parcelle (régional) |

**Calcul d'amortissement** :
```
Filet 15 000 €/ha, amortissement 15 ans = 1 000 €/ha/an
Espérance de perte sans filet = 8% × 12 000 €/ha (marge) = 960 €/ha/an
→ Le filet est rentable dès que la marge dépasse 12 500 €/ha
→ Obligatoire pour cerises, framboises, myrtilles (marges > 12 000 €)
→ Recommandé pour pommes, poires (marges 8-14 000 €)
```

### 3.7 Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Taille | 1 action "Tailler" (résultat automatique) | Choix : taille de formation / fructification / rajeunissement |
| Éclaircissage | 1 action automatique | Intensité au choix → calibre des fruits |
| Gel de printemps | Non modélisé | -20 à -80% récolte si gel pendant floraison |
| Calibre | Non | 3 catégories (prime +30% pour gros calibre) |
| Alternance | Non | Année forte / année faible naturelle (±20%) |
| Maladies | 1-2 traitements suffisent | Tavelure, moniliose, feu bactérien → gestion fine |

### 3.8 Matériel arboricole — Catalogue détaillé

Tout le matériel arboricole nécessite un **tracteur fruitier ≤ 80 CV** (inter-rang 3,5-5 m).

#### Catalogue complet

| Machine | Prix | Largeur/Capacité | Débit | CV requis | Heures de vie | Consommation |
|---------|-----:|:----------------:|:-----:|:---------:|:-------------:|:------------:|
| Tracteur fruitier (55-80 CV) | 25 000-45 000 € | Largeur 1,4-1,7 m | — | — | 8 000 h | 6-9 L/h |
| Pulvérisateur arbo face-par-face | 18 000 € | 3-4 rangs | 2,5 ha/h | 55 CV min | 2 500 h | — |
| Pulvérisateur arbo confiné (récupérateur) | 28 000 € | 2-3 rangs | 2,0 ha/h | 60 CV min | 2 500 h | — |
| Vibreur à olives/noix | 35 000 € | 1 arbre/passage | 25-40 arbres/h | 70 CV min | 3 000 h | 12 L/h |
| Ramasseuse à noix/olives | 18 000 € | Bande 2 m | 0,5 ha/h | 50 CV min | 2 000 h | — |
| Ramasseuse à pommes (au sol) | 22 000 € | Bande 1,5 m | 0,3 ha/h | 50 CV min | 2 000 h | — |
| Plateforme de récolte automotrice | 15 000 € | 2 postes cueilleurs | — (MO dépendant) | Électrique | 5 000 h | 2 L/h equiv. |
| Broyeur inter-rangs | 8 000 € | 1,5-2,5 m | 1,5 ha/h | 50 CV min | 3 000 h | — |
| Tondeuse inter-rangs | 5 000 € | 1,2-2,0 m | 2,0 ha/h | 45 CV min | 3 000 h | — |
| Épandeur localisé (petits volumes) | 6 500 € | 3-4 rangs | 1,5 ha/h | 50 CV min | 3 000 h | — |
| Écimeuse (haies fruitières) | 9 000 € | 2,5 m hauteur | 1,0 ha/h | 60 CV min | 2 500 h | — |
| Calibreuse (station de tri) | 45 000 € | 2-5 t/h | — | Électrique | 15 ans | 8 kWh/h |

#### Calcul du temps de travail arboricole (ADR-004)

```
VERGER DE POMMIERS — 5 HA, EN PRODUCTION

  Traitements (pulvé face-par-face, 8 passages/an) :
    5 ha ÷ 2,5 ha/h = 2 h/passage × 8 = 16 h/an

  Entretien inter-rangs (broyeur, 4 passages/an) :
    5 ha ÷ 1,5 ha/h = 3,3 h/passage × 4 = 13,3 h/an

  Taille (manuelle) :
    5 ha × 60 h/ha = 300 h (MO employés)

  Éclaircissage (manuel) :
    5 ha × 80 h/ha = 400 h (MO employés)

  Récolte (plateforme + MO) :
    5 ha × 200 h/ha = 1 000 h (MO saisonniers)

  Calibrage (station de tri) :
    175 t ÷ 3 t/h = 58 h

  TOTAL MÉCANISÉ (tracteur) : ≈ 30 h/an
  TOTAL MO NON MÉCANISABLE : ≈ 1 758 h/an → 3 employés en moyenne
```

#### Contraintes spécifiques matériel arboricole

| Contrainte | Effet gameplay |
|-----------|----------------|
| Tracteur > 80 CV | Ne passe pas dans les inter-rangs → dégâts aux arbres, action refusée |
| Vibreur sur fruits tendres (pommes, poires) | Interdit — fruits à pépins récoltés manuellement |
| Pulvé confiné obligatoire en bio | +10 000 € vs pulvé classique, -30% dérive |
| Récolte mécanisée (noix/olives uniquement) | Vibreur + ramasseuse combinés = 0,8 ha/h |
| Chambre froide obligatoire (petits fruits) | Sans chambre froide : vente sous 48h ou perte 100% |



---

## 4. Pomme de terre — filière spéculative

### 4.1 Intention de design

La PDT est **le produit le plus spéculatif du jeu**. Prix variant de 50 à 400 €/t selon la saison et l'offre/demande du serveur. Le joueur PDT est un trader autant qu'un agriculteur.

### 4.2 Itinéraire technique

```
CYCLE DE LA POMME DE TERRE

  MARS-AVR     Préparation (labour + herse)     [2 actions]
  AVRIL        PLANTATION (planteuse)            [1 action]
  MAI          Buttage                           [1 action]
  MAI-AOÛT     Traitements mildiou (5-8×)        [5-8 actions]  ← intensif
  JUIN-AOÛT    Irrigation (si équipé)            [3-5 actions]
  AOÛT-SEPT    Défanage                          [1 action]
  SEPT-OCT     ARRACHAGE                         [1 action]
  OCT→JUIN     Stockage + vente                  [0 action, décision prix]

  TOTAL : 14-18 actions + décisions commerciales
```

### 4.3 Matériel dédié

| Matériel | Prix | Indispensable ? |
|----------|:----:|:--------------:|
| Planteuse 4 rangs | 25 000-45 000 € | Oui |
| Butteuse | 8 000-15 000 € | Oui |
| Arracheuse 2 rangs | 80 000-150 000 € | Oui |
| Arracheuse intégrale (automotrice) | 350 000-500 000 € | Non (luxe) |
| Défaneuse (broyeur) | 6 000-12 000 € | Oui |
| Ligne de stockage (triage + calibrage) | 80 000-120 000 € | Oui pour vente directe |
| Entrepôt PDT (ventilation, froid) | 100 €/t de capacité | Oui |

**Investissement minimum pour démarrer** : 150 000-250 000 € (hors tracteur).

### 4.4 Stockage et spéculation

```
┌─ Entrepôt PDT — 800 t stockées ─────────────────────────────────┐
│                                                                   │
│  📦 Stock actuel : 800 t (capacité 1 000 t)                       │
│  📅 Récolté le : 18 septembre                                     │
│  🌡️ Température : 6°C ✅ (cible 4-8°C)                            │
│  Qualité : Bonne (taux sucres réducteurs : 0,12%)                 │
│                                                                   │
│  ── Historique des prix (serveur) ──                              │
│  Sept : ████░░░░░░░░░░░░  85 €/t  (offre abondante)              │
│  Oct  : █████░░░░░░░░░░░  110 €/t                                │
│  Nov  : ███████░░░░░░░░░  145 €/t                                │
│  Déc  : █████████░░░░░░░  190 €/t                                │
│  Jan  : ██████████░░░░░░  220 €/t  ← vous êtes ici               │
│  Fév  : ████████████░░░░  280 €/t  (estimation)                   │
│  Mars : █████████████░░░  310 €/t  (estimation)                   │
│  Avr  : ██████████████░░  350 €/t  (estimation)                   │
│  Mai  : ███████████████░  380 €/t  (estimation)                   │
│  Juin : ████████████████  400 €/t  (max historique)               │
│                                                                   │
│  ⚠️ Pertes en stock : 0,8%/mois (germination, respiration)        │
│  ⚠️ Coût stockage : 1,50 €/t/mois (ventilation + énergie)         │
│                                                                   │
│  ── Propositions de vente cette semaine ──                        │
│  🏪 Acheteur A : 500 t à 215 €/t (paiement immédiat)              │
│  🏪 Acheteur B : 300 t à 225 €/t (paiement 30 jours)              │
│  🏪 Acheteur C : 800 t à 205 €/t (tout le stock)                  │
│                                                                   │
│  [ Vendre à A ]  [ Vendre à B ]  [ Attendre ]                    │
└───────────────────────────────────────────────────────────────────┘
```

### 4.5 Volatilité des prix

| Période | Prix moyen (€/t) | Fourchette | Facteur |
|---------|:-----------------:|:----------:|---------|
| Septembre (récolte) | 80 | 50-120 | Offre maximale |
| Novembre | 140 | 90-200 | Premiers stockeurs vendent |
| Janvier | 210 | 140-300 | Stock diminue |
| Mars | 300 | 200-380 | Pénurie relative |
| Mai-Juin | 370 | 280-400 | Fin de campagne, raréfaction |

**Mécanique de prix** : le prix est fonction de l'offre/demande du serveur. Si beaucoup de joueurs stockent, le prix monte moins vite. Si tout le monde vend en septembre, le prix chute.

### 4.6 Mildiou — la menace permanente

```
Mode Normal :
  → Le jeu signale "traitement recommandé" 5 à 8 fois dans la saison
  → Chaque traitement raté = -8% de rendement
  → Si 0 traitement = -40% (mais récolte quand même)

Mode Expert :
  → Modèle épidémiologique : humidité + T° + inoculum
  → Délai max entre 2 traitements : 10-14 jours selon le produit
  → Si brèche dans la protection > 7 jours humides :
    contamination irréversible → perte 30-80% selon la précocité
  → Alternance des matières actives obligatoire (résistances)
  
  Coût moyen des traitements : 8 × 45 €/ha = 360 €/ha
```

### 4.7 Mode Normal vs Expert (PDT)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Plantation | Date auto, dose auto | Choix variété, écartement, prégermination |
| Mildiou | 5-8 rappels "traiter" | Modèle épidémiologique, timing critique |
| Défanage | 1 action obligatoire | Choix : chimique vs mécanique, timing |
| Rendement | 38-48 t/ha | 32-55 t/ha (plus variable) |
| Qualité | Non | Calibre, taux de sucres, défauts visuels |
| Stockage | Pertes automatiques 0,5%/mois | 0,8%/mois si mal ventilé, germination |
| Contrats | Non | Contrats industriels (prix fixe, volume garanti) |



---

## 5. Haies et agroforesterie

### 5.1 Plantation

| Paramètre | Valeur |
|-----------|--------|
| Coût par plant | 1,50 € |
| Densité | 3-5 plants/mètre linéaire |
| Coût/100 m de haie | 450-750 € (plants + paillage) |
| Mortalité | 2%/saison (remplacement nécessaire) |
| Croissance | Fonctionnelle après 3-5 ans |
| Aide PAC (éco-régime) | 20 €/100 m linéaire/an |

### 5.2 Entretien et valorisation

```
CYCLE ANNUEL DES HAIES

  HIVER (Déc-Fév)    Taille (obligatoire 1×/2 ans)     [1 action]
                      → Production de bois déchiqueté
  PRINTEMPS           Rien (croissance, nidification)
  ÉTÉ                Rien (effet brise-vent actif)
  AUTOMNE             Plantation de nouvelles haies      [1 action]
                      Remplacement des plants morts

  → 1-2 actions/an seulement — faible charge de travail
```

**Valorisation du bois** :
| Produit | Volume | Prix | Usage |
|---------|:------:|:----:|-------|
| Bois déchiqueté (plaquettes) | 15-25 m³/100 m/taille | 25-35 €/m³ | Chaufferie collective, litière |
| Bois bûche | 3-5 stères/100 m | 50-70 €/stère | Chauffage |

### 5.3 Bénéfices agronomiques

| Bénéfice | Effet | Distance d'effet |
|----------|:-----:|:----------------:|
| Brise-vent (rendement) | **+2 à +4%** sur cultures adjacentes | 10× hauteur de la haie |
| Réduction maladies | **-15%** pression fongique | Parcelles bordées |
| Biodiversité | Score biodiversité +5/haie | Exploitation |
| Éco-régime PAC | **+20 €/100 m/an** | — |
| Habitat auxiliaires | -10% ravageurs (Expert) | Parcelles bordées |

### 5.4 Mode Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Plantation | 1 action, effet automatique | Choix d'essences (caduques, persistantes, fruitières) |
| Bonus rendement | +3% forfaitaire | +2 à +4% variable (orientation, hauteur, espèces) |
| Bois | Revenu fixe par taille | Volume selon croissance, marché du bois énergie |
| Biodiversité | Score affiché | Impact sur auxiliaires, réduction insecticides |

---

## 6. Cultures intermédiaires et couverts

### 6.1 CIPAN obligatoires (BCAE)

**Obligation réglementaire** : toute parcelle sans culture entre le 15 août et le 15 novembre doit être couverte.

| Espèce | Coût semence (€/ha) | Semis | Destruction | Intérêt principal |
|--------|:-------------------:|-------|-------------|-------------------|
| Moutarde blanche | 25 | Août | Gel ou broyage nov. | Rapide, piège nitrates |
| Phacélie | 35 | Août | Gel | Mellifère, structure |
| Seigle | 30 | Sept | Broyage mars | Biomasse, structure |
| Ray-grass | 28 | Août-sept | Broyage | Couverture dense |
| Trèfle incarnat | 40 | Août | Broyage fév. | Azote (légumineuse) |
| Féverole | 65 | Sept | Gel | Azote ++, structure |
| Mélange (3-4 espèces) | 55 | Août-sept | Variable | Multiservice |

### 6.2 Bénéfices des couverts

```
Mode Normal :
  → Obligation BCAE = 1 action "semer un couvert" après la moisson
  → Bonus automatique : +2% rendement culture suivante
  → Pas de pénalité si le joueur choisit mal l'espèce

Mode Expert — effets détaillés :
  Piège à nitrates     : récupère 30-80 u N/ha (selon espèce et durée)
  Structure du sol     : +0,5% porosité/an si couvert racinaire (seigle, phacélie)
  Matière organique    : +0,02% MO/an (biomasse enfouie)
  Azote (légumineuses) : restitution 40-80 u N à la culture suivante
                         → économie directe de 50-100 € d'engrais/ha
  Adventices           : -20% stock semencier (couverture concurrentielle)
  
  MAIS :
  Destruction tardive  : -5% rendement si couvert mal détruit avant semis
  Eau consommée        : couvert en automne sec = -15 mm de réserve utile
```

### 6.3 CIVE — Culture Intermédiaire à Vocation Énergétique

| Paramètre | Valeur |
|-----------|--------|
| Espèces | Seigle, triticale, ray-grass italien |
| Rendement biomasse | 4-8 t MS/ha |
| Prix (méthaniseur) | 30-50 €/t MS |
| Période | Août → Mars (CIVE d'hiver) ou Juin → Sept (CIVE d'été) |
| Intérêt | Revenu supplémentaire + contrat méthanisation |

→ Nécessite un **méthaniseur** (voir `GDD-transformation.md` §3) ou un contrat de vente à une unité collective (voir `GDD-cooperatives-car.md` §4).

### 6.4 Normal vs Expert (couverts)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Obligation | Oui (BCAE, 1 action) | Oui + amende si non fait |
| Choix espèce | Indifférent | Impact réel (azote, structure, eau) |
| Durée | Automatique | Le joueur gère semis + destruction |
| Bonus | +2% forfaitaire | Variable (0 à +8% selon espèce et gestion) |
| CIVE | Non disponible | Débouché méthanisation |

---

## 7. Compostage

### 7.1 Processus

```
ENTRÉE → PROCESSUS → SORTIE

  3 t de fumier brut
       ↓
  [Mise en andain]           Jour 0
       ↓
  [1er retournement]         Jour 5     (température > 60°C)
       ↓
  [2e retournement]          Jour 10    (aération, homogénéisation)
       ↓
  [Compost mûr]              Jour 14
       ↓
  1 t de compost (matière sèche concentrée)
```

### 7.2 Paramètres

| Paramètre | Valeur |
|-----------|--------|
| Ratio entrée/sortie | 3:1 (volume) |
| Durée | 14 jours (2 retournements) |
| Main d'œuvre | 2 actions (retournements) par lot |
| Matériel | Retourneur d'andain (15 000-35 000 €) ou chargeur télescopique |
| Capacité | 1 andain = 50-200 t de fumier brut |
| Surface nécessaire | Aire bétonnée 500 m² minimum |

### 7.3 Valeur agronomique comparée

| Produit | N (u/t) | P (u/t) | K (u/t) | MO (kg/t) | Épandage |
|---------|:-------:|:-------:|:-------:|:---------:|----------|
| Fumier brut | 5 | 3 | 7 | 180 | Épandeur classique, odeurs |
| Compost | 12 | 8 | 15 | 450 | Épandeur, pas d'odeur, dosage précis |
| Lisier | 3/m³ | 1,5/m³ | 4/m³ | 20/m³ | Tonne à lisier, odeurs fortes |

**Avantages du compost vs fumier brut** :
- Valeur fertilisante **×2,5** par tonne (concentré)
- Pas d'odeurs (acceptabilité sociale)
- Dosage plus précis (homogène)
- Meilleur apport en matière organique stable (humus)
- Transport plus économique (3× moins de volume)

### 7.4 Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Processus | Timer 14 jours, automatique | 2 retournements manuels (oubli = mauvaise qualité) |
| Qualité | Toujours "bon" | Variable : C/N ratio, température, humidité |
| Usage | Remplacement 1:1 du fumier en fertilisation | Valeur N-P-K précise, bilan humique |

---

## 8. Agriculture biologique

### 8.1 La conversion — "la vallée de la mort"

```
TIMELINE DE CONVERSION BIO

  Année 0 (décision)
    → Rendement : conventionnel → baisse progressive
    → Prix de vente : CONVENTIONNEL (pas de prime bio)
    → Aides : 350 €/ha (aide conversion)
    → Contraintes : BIO (pas de chimie)
    ⚠️ MARGE NÉGATIVE POSSIBLE (la "vallée de la mort")

  Année 1 (C1)
    → Rendement : -15 à -25% (adaptation)
    → Prix : conventionnel
    → Aides : 350 €/ha
    → Mention : "en conversion"

  Année 2 (C2)
    → Rendement : -25 à -40% (nouvel équilibre)
    → Prix : conventionnel ou C2 (+10-15% si débouché)
    → Aides : 350 €/ha
    → Mention : "en conversion 2e année"

  Année 3+ (certifié AB)
    → Rendement : -30 à -40% (stabilisé)
    → Prix : BIO (+40 à +80%)
    → Aides : 100 €/ha (maintien)
    → Label AB affiché
```

### 8.2 Impact économique par culture

| Culture | Rdt conv. | Rdt bio | Prix conv. | Prix bio | Marge conv./ha | Marge bio/ha |
|---------|:---------:|:-------:|:----------:|:--------:|:--------------:|:------------:|
| Blé tendre | 85 q | 55 q | 220 €/t | 380 €/t | 1 555 € | 1 720 € |
| Maïs grain | 100 q | 60 q | 200 €/t | 350 €/t | 890 € | 1 050 € |
| Colza | 36 q | 22 q | 470 €/t | 780 €/t | 1 219 € | 1 200 € |
| Pomme de terre | 45 t | 28 t | 150 €/t | 350 €/t | 2 800 € | 5 100 € |
| Pommier | 40 t | 25 t | 550 €/t | 950 €/t | 11 000 € | 12 500 € |

### 8.3 Contraintes en jeu

| Contrainte | Détail |
|-----------|--------|
| Désherbage | **Mécanique uniquement** (herse étrille, bineuse, houe rotative) |
| Fertilisation | Organique uniquement (fumier, compost, engrais verts) |
| Traitements | Cuivre (4 kg/ha/an max), soufre, biocontrôle uniquement |
| Rotation | Allongée : minimum 5 cultures, dont 1 légumineuse |
| Semences | Bio ou non traitées |
| OGM | Interdit |

### 8.4 Mode Normal vs Expert (bio)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Conversion | 2 ans timer, rendement auto ajusté | Gestion des adventices, pression croissante an 1-2 |
| Rendement | ×0,65 automatique | Variable (0,55-0,75 selon la maîtrise) |
| Prix | ×1,60 automatique | Marché bio distinct (offre/demande) |
| Adventices | Non modélisées | Pression cumulative, banque de graines |
| Rotation | 5 cultures minimum | + couvert obligatoire + légumineuse 20% |
| Échec | Non (rendement plancher 40%) | Oui (parcelle envahie = rendement 20%) |

### 8.5 Aides PAC bio

| Type | Montant | Durée | Condition |
|------|:-------:|:-----:|-----------|
| Aide conversion (grandes cultures) | 350 €/ha | 5 ans | Engagement bio |
| Aide conversion (arbo) | 900 €/ha | 5 ans | Verger certifié |
| Aide maintien (grandes cultures) | 100 €/ha | Annuel | Certification AB |
| Aide maintien (arbo) | 450 €/ha | Annuel | Certification AB |
| Éco-régime (bonus bio) | 110 €/ha | Annuel | Cumulable |


---

## 8bis. Maraîchage

> 📌 **Le maraîchage fait l'objet d'un GDD dédié** : `GDD-maraichage.md` (840 lignes).
>
> Il a été extrait de ce document car il constitue un système à part entière, avec ses
> propres serres, son catalogue de 15 légumes, son matériel spécifique, ses circuits de
> commercialisation et une contrainte de main d'œuvre sans équivalent (5-15 UTH/ha contre
> 0,5 UTH/ha en grandes cultures).
>
> **Ce qu'il faut retenir ici** : le maraîchage est la spécialisation à marge maximale
> (30 000 à 150 000 €/ha de chiffre d'affaires) mais aussi la plus exigeante en temps.
> Il s'adresse au joueur qui dispose de peu de foncier et de beaucoup de temps de travail
> (ou de salariés). Il est le seul système où la main d'œuvre, et non la surface, constitue
> le facteur limitant.
>
> Voir `GDD-maraichage.md` pour : les 4 systèmes maraîchers, les types d'abris, le chauffage,
> le catalogue des légumes, le matériel, la commercialisation et les scénarios chiffrés.

---

---

## 9. Équilibrage et scénarios

### 9.1 Tableau comparatif des marges/ha (toutes spécialisations)

| Spécialisation | Investissement initial | Marge brute/ha | Temps/ha (actions) | Surface max | Risque |
|----------------|:---------------------:|:--------------:|:------------------:|:-----------:|:------:|
| Grandes cultures (référence) | 0 € (matériel partagé) | 1 200-1 600 € | 7-9/an | Illimité | Faible |
| Maïs irrigué | 18 000-150 000 € | 1 800-2 500 € | 10-14/an | Débit forage | Moyen (sécheresse) |
| Pomme de terre | 150 000-250 000 € | 2 500-8 000 € | 14-18/an | 20% SAU | **Élevé** (prix) |
| Verger (pommier) | 30 000-50 000 €/ha | 8 000-14 000 € | 11-12/an | 5 ha max | Élevé (grêle, gel) |
| Verger (petits fruits) | 40 000-70 000 €/ha | 12 000-25 000 € | 15-20/an | 3 ha max | Élevé |
| Bio (grandes cultures) | 0 € (conversion 2 ans) | 1 400-1 800 € | 9-12/an | Illimité | Moyen (adventices) |
| Haies (avec valorisation) | 500-750 €/100 m | 200-400 €/100 m | 1-2/an | — | Nul |
| CIVE (méthanisation) | 0 € | 150-350 €/ha | 2-3/an | — | Faible |
| Compostage | 15 000-35 000 € | Économie 50-100 €/ha | 2/lot | — | Nul |

**Lecture** : les spécialisations offrent des marges 2× à 10× supérieures aux grandes cultures, mais chacune est **contrainte** :
- PDT → matériel coûteux + prix volatile
- Verger → surface limitée + MO intensive + 4-8 ans d'attente
- Bio → 2 ans de "vallée de la mort" + technicité
- Irrigation → investissement + dépendance à la météo (Expert)

### 9.2 Scénario A — Verger de pommiers (5 ha, Normal)

```
INVESTISSEMENT INITIAL
  Plantation (1 200 arbres/ha × 5 ha × 8 €/arbre)     48 000 €
  Filet anti-grêle (15 000 €/ha × 5 ha)                75 000 €
  Tracteur fruitier 75 CV (occasion)                    32 000 €
  Pulvérisateur arbo                                    18 000 €
  Plateforme de récolte                                 12 000 €
  Chambre froide 200 t                                  60 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL INVESTISSEMENT                                 245 000 €

ANNÉES 1-4 : PAS DE RÉCOLTE
  Entretien annuel (taille, traitements, irrigation)    8 000 €/an
  Coût cumulé avant 1ère récolte                       32 000 €
  
  TOTAL ENGAGÉ avant le 1er euro de revenu             277 000 €

ANNÉE 5+ : PRODUCTION (rendement progressif)
  Année 5 :  20 t/ha  → 100 t × 550 €/t = 55 000 €
  Année 6 :  30 t/ha  → 150 t × 550 €/t = 82 500 €
  Année 7+ : 40 t/ha  → 200 t × 550 €/t = 110 000 €  (pleine production)

CHARGES ANNUELLES EN PLEINE PRODUCTION (5 ha)
  Main d'œuvre (taille + éclaircissage + récolte)
    400 h/ha × 5 ha × 15 €/h                          30 000 €
  Traitements (8 passages × 55 €/ha)                    2 200 €
  Fertilisation                                         1 500 €
  Irrigation (8 tours × 40 €/ha)                        1 600 €
  Carburant + entretien matériel                        2 500 €
  Amortissement filet (15 ans)                          5 000 €
  Amortissement matériel (10 ans)                       6 200 €
  Stockage froid (énergie)                              3 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL CHARGES                                        52 000 €

MARGE BRUTE ANNUELLE (pleine production)
  Produit : 110 000 €
  Charges : -52 000 €
  ─────────────────────
  BÉNÉFICE AVANT CHARGES SOCIALES = 58 000 €
  Charges sociales (12% Normal, ADR-002) : 58 000 × 0,12 = -6 960 €
  ─────────────────────
  RÉSULTAT NET = 51 040 €  →  10 208 €/ha  ✅

RETOUR SUR INVESTISSEMENT
  Investissement total : 277 000 €
  Résultat net annuel : 51 040 €
  Retour : 5,4 ans après la 1ère récolte = ANNÉE 9-10 au total

> ⚠️ Note d'équilibrage : le résultat net de 51 040 € est à la limite haute de la cible
> 38-50 k€. C'est justifié par l'investissement lourd (277 k€), les 4 ans d'attente
> avant la première récolte, et le risque grêle/gel qui peut effacer une année entière.

RISQUE
  Si grêle (sans filet) : perte 60-100% = 0-44 000 € de produit
  Si grêle (avec filet) : perte 5% = 104 500 € de produit (filet amorti)
  Si gel de printemps (Expert) : perte 30-80% selon intensité
```

✅ **Validé** : marge très supérieure aux grandes cultures (11 600 vs 1 555 €/ha) mais investissement lourd (277k€), attente (4 ans), MO intensive, et risque gel/grêle.

### 9.3 Scénario B — Pomme de terre sous contrat (15 ha, Expert)

```
INVESTISSEMENT MATÉRIEL
  Planteuse 4 rangs                                    35 000 €
  Butteuse                                             12 000 €
  Arracheuse 2 rangs                                  120 000 €
  Défaneuse                                             8 000 €
  Ligne de stockage (triage)                          100 000 €
  Entrepôt 600 t (15 ha × 45 t × 90% = 607 t)        60 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL INVESTISSEMENT                                 335 000 €

ITINÉRAIRE TECHNIQUE (Expert, 15 ha)
  Rendement cible : 48 t/ha (irrigué)
  Production totale : 720 t

CHARGES OPÉRATIONNELLES
  Plants (2,5 t/ha × 600 €/t)                         22 500 €
  Engrais (N-P-K adaptés, 400 €/ha)                    6 000 €
  Traitements mildiou (8 × 45 €/ha)                    5 400 €
  Herbicide + insecticide                               1 800 €
  Irrigation (7 tours × 50 €/ha)                        5 250 €
  Défanage                                               900 €
  Carburant (120 L/ha × 1,00 €)                        1 800 €
  Stockage (600 t × 6 mois × 1,50 €/t/mois)           5 400 €
  ─────────────────────────────────────────────────────────────
  TOTAL CHARGES OPÉRATIONNELLES                        49 050 €

STRATÉGIE A — Vente à la récolte (septembre, prix bas)
  720 t × 85 €/t                                      61 200 €
  - Charges                                           -49 050 €
  ─────────────────
  MARGE = 12 150 €  →  810 €/ha  ❌ (inférieur aux grandes cultures)

STRATÉGIE B — Stockage et vente en mars (prix moyen élevé)
  Pertes stock 6 mois (0,8%/mois × 6) = 4,8%
  Volume vendu : 720 × 0,952 = 685 t
  685 t × 300 €/t                                    205 500 €
  - Charges                                           -49 050 €
  - Amortissement matériel (335k / 10 ans)            -33 500 €
  ─────────────────
  BÉNÉFICE AVANT CHARGES SOCIALES = 122 950 €
  Charges sociales (28% Expert, ADR-003) : -34 426 €
  ─────────────────
  RÉSULTAT NET = 88 524 €  →  5 902 €/ha  ✅

> ⚠️ Note d'équilibrage : le résultat de 88 524 € dépasse la cible 38-50 k€.
> C'est justifié par : investissement très lourd (335 k€), risque prix volatil
> (le scénario C montre un prix fixe bien plus bas), et expertise de stockage requise.

STRATÉGIE C — Contrat industriel (prix fixe 180 €/t, 100% volume garanti)
  720 t × 180 €/t                                    129 600 €
  - Charges                                           -49 050 €
  ─────────────────
  BÉNÉFICE AVANT CHARGES SOCIALES = 80 550 €
  Charges sociales (28% Expert, ADR-003) : -22 554 €
  ─────────────────
  RÉSULTAT NET = 57 996 €  →  3 866 €/ha  ✅ (sécurisé)

> ⚠️ Note d'équilibrage : ce résultat de 57 996 € dépasse la cible car il couvre 15 ha
> spécialisés (investissement 335 k€) avec un engagement contractuel.

RISQUE (stratégie B — spéculation)
  Si prix mars = 150 €/t (année d'abondance) :
    685 t × 150 € = 102 750 € - 49 050 € - 33 500 € = 20 200 €
    Charges sociales (28%) : -5 656 €
    Résultat net = 14 544 €  →  970 €/ha  (correct mais faible)
  Si prix mars = 380 €/t (année de pénurie) :
    685 t × 380 € = 260 300 € - 49 050 € - 33 500 € = 177 750 €
    Charges sociales (28%) : -49 770 €
    Résultat net = 127 980 €  →  8 532 €/ha  🤑
```

✅ **Validé** : la PDT est le produit le plus rentable ET le plus risqué. Le joueur qui stocke et anticipe bien le marché gagne massivement. Celui qui se trompe ou vend en panique gagne peu.

### 9.4 Points à valider en playtest

**Recette SimAgri (ADR-002) — bloquant**
- [ ] Les spécialisations sont-elles accessibles sans doc externe en Normal ?
- [ ] Un joueur Normal peut-il gérer un verger sans frustration (fenêtres larges) ?
- [ ] La PDT en Normal est-elle jouable sans comprendre le mildiou ?
- [ ] Le bio en Normal est-il un simple switch rentable ?
- [ ] Les haies et couverts ne sont-ils pas perçus comme du "travail en plus sans gain" ?

**Profondeur Expert**
- [ ] Le système d'irrigation avec restrictions est-il stressant mais juste ?
- [ ] La spéculation PDT crée-t-elle des dynamiques de marché intéressantes entre joueurs ?
- [ ] Le gel de printemps en verger est-il un risque gérable (pas punitif) ?
- [ ] La conversion bio est-elle une vraie décision stratégique (pas un no-brainer) ?
- [ ] Les CIVE créent-elles un lien avec la filière méthanisation ?

**Équilibrage**
- [ ] Aucune spécialisation ne domine les autres à investissement égal
- [ ] Le verger n'est pas un "money printer" sans risque
- [ ] La PDT récompense la patience ET l'analyse de marché
- [ ] Le bio n'est pas strictement supérieur au conventionnel (marge/h de travail)

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| **Irrigation** | | |
| Déclenchement | Bouton (jauge basse) | Bilan hydrique, dose en mm |
| Restrictions sécheresse | Non | 4 niveaux d'interdiction |
| Retenue collinaire | Non | Projet collectif (vote) |
| **Arboriculture** | | |
| Espèces | 11 (même gameplay) | 11 (gameplay différencié) |
| Taille | 1 action auto | Choix type de taille |
| Gel printemps | Non | -20 à -80% |
| Calibre/qualité | Non | 3 catégories + primes |
| Alternance production | Non | ±20% naturel |
| **Pomme de terre** | | |
| Mildiou | Rappels "traiter" | Modèle épidémiologique |
| Prix | Volatil (50-400 €/t) | Idem + contrats industriels |
| Qualité | Non | Calibre, sucres, défauts |
| Pertes stockage | 0,5%/mois | 0,8%/mois si mal géré |
| **Haies** | | |
| Bonus | +3% forfaitaire | +2-4% variable |
| Biodiversité | Score | Impact auxiliaires/ravageurs |
| **Couverts** | | |
| Obligation BCAE | 1 action simple | Amende si non fait |
| Effet | +2% forfaitaire | 0-8% selon espèce/gestion |
| CIVE | Non | Débouché méthanisation |
| **Compostage** | | |
| Processus | Timer 14j | Retournements manuels |
| Qualité | Toujours bon | Variable (C/N, T°, humidité) |
| **Bio** | | |
| Conversion | Timer 2 ans | Gestion adventices progressive |
| Rendement | ×0,65 fixe | ×0,55-0,75 variable |
| Prix | ×1,60 fixe | Marché bio distinct |
| Échec | Non (plancher 40%) | Oui (envahissement) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | Création du GDD spécialisations végétales |
| 2026-08-04 | Ajout §3.8 Matériel arboricole détaillé + §8bis Maraîchage complet | Audit couverture fonctionnelle — systèmes 6.10 et 9.2 partiels |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
