> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Marché et Commercialisation

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : docs/research/reality-vs-simagri-economie.md (§1, §2, §9), ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop

### Intention de design

Le marché est le **système nerveux** d'Agriva. Il donne du sens à chaque tonne produite en posant au joueur trois questions permanentes :

| Question | Levier | Plaisir procuré |
|----------|--------|-----------------|
| **QUAND vendre ?** | Saisonnalité, stockage, tendance | Anticipation, spéculation maîtrisée |
| **À QUI vendre ?** | Canal (coop, négoce, joueurs, direct) | Optimisation, commerce social |
| **QUOI produire ?** | Prix relatifs, labels, contrats | Stratégie long terme, différenciation |

Sans marché dynamique, la production est une corvée répétitive. Avec un marché vivant, chaque récolte est un moment de décision.

### Ce que SimAgri fait bien (à garder)

- Tick offre/demande basé sur l'activité réelle des joueurs
- Marché entre joueurs (annonces, prix libre, commission)
- Coopérative comme canal sûr et permanent
- Historique des prix consultable

### Ce que SimAgri fait mal (à corriger)

- Pas de saisonnalité → aucune raison de stocker
- Pas de contrats anticipés → impossible de sécuriser ses revenus
- Coopérative = prix fixe+15% (en réalité la coop est MOINS chère en achat)
- Bio = +20% uniforme (en réalité +40-80% selon produit)
- Pas de labels (AOP, Label Rouge) → pas de différenciation qualité

### Gameplay loop

```
┌─────────────────────────────────────────────────────────────────┐
│                    LOOP QUOTIDIENNE                              │
│  Consulter prix → Décider vendre/stocker → Exécuter la vente    │
├─────────────────────────────────────────────────────────────────┤
│                    LOOP MENSUELLE                                │
│  Analyser tendances → Choisir canal → Négocier contrats         │
├─────────────────────────────────────────────────────────────────┤
│                    LOOP SAISONNIÈRE                              │
│  Planifier assolement → Évaluer labels → Ajuster la stratégie   │
├─────────────────────────────────────────────────────────────────┤
│                    LOOP ANNUELLE                                 │
│  Bilan marge/culture → Comparer canaux → Décider QUOI produire  │
└─────────────────────────────────────────────────────────────────┘
```

### Décisions du joueur

| Décision | Fréquence | Conséquence |
|----------|:---------:|-------------|
| Vendre maintenant vs stocker | Chaque récolte | +15-25% potentiel si patience, -0,5%/mois de perte |
| Coopérative vs négoce vs joueurs | Chaque vente | Sécurité vs marge vs social |
| Signer un contrat anticipé | Avant récolte (Expert) | Prix garanti vs pénalité si non-livré |
| Produire du conventionnel vs label | Annuelle | Volume vs marge unitaire |
| Acheter intrants en coop vs négoce | Chaque campagne | -5-10% via coop vs liberté négoce |

### Tableau Normal / Expert (vue d'ensemble)

| Élément | Normal | Expert |
|---------|--------|--------|
| Prix affiché | Prix final + tendance (↑↗→↘↓) | Décomposition 5 facteurs |
| Conseil du jeu | Oui (« le blé monte au printemps ») | Non (le joueur analyse seul) |
| Amplitude offre/demande | ±12% | ±25% |
| Contrats anticipés | Non disponible | Oui |
| Cycles pluriannuels | Non | Oui (porc 3,5 ans, lait 4 ans, céréales 3 ans) |
| Simulation de stockage | Non | Outil intégré |
| Historique visible | 6 mois | 5 ans + export |
| Charges sur ventes | 12% forfaitaire | 28% forfaitaire |

---

## 2. Formule de prix à 5 facteurs

### Formule générale

```
prix_final = prix_base × f_saison × f_offre_demande × f_tendance × f_qualité
```

| Facteur | Plage Normal | Plage Expert | Source |
|---------|:------------:|:------------:|--------|
| `prix_base` | Fixe par produit | Fixe par produit | Table de référence |
| `f_saison` | 0,90 – 1,10 | 0,85 – 1,20 | Calendrier agricole |
| `f_offre_demande` | 0,88 – 1,12 | 0,75 – 1,25 | Activité serveur |
| `f_tendance` | 0,95 – 1,05 | 0,80 – 1,20 | Cycle pluriannuel |
| `f_qualité` | 0,90 – 1,10 | 0,85 – 1,15 | Niveau de qualité (3 niveaux) |

### 2.1 Prix de base (référence France 2024)

| Produit | `prix_base` | Unité |
|---------|:-----------:|:-----:|
| Blé meunier | 220 | €/t |
| Orge fourragère | 195 | €/t |
| Maïs grain | 200 | €/t |
| Colza | 470 | €/t |
| Tournesol | 410 | €/t |
| Lait conventionnel | 0,43 | €/L |
| Porc (carcasse) | 1,75 | €/kg |
| Agneau (carcasse) | 7,50 | €/kg |
| Poulet (vif) | 1,00 | €/kg |
| Œuf plein-air | 0,18 | €/unité |

### 2.2 Saisonnalité (`f_saison`)

Chaque produit suit une courbe sinusoïdale propre calée sur le calendrier agricole réel.

**Céréales (blé, orge, maïs) :**

| Mois | Jan | Fév | Mar | Avr | Mai | Jun | Jul | Aoû | Sep | Oct | Nov | Déc |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `f_saison` | 1,06 | 1,08 | 1,10 | 1,08 | 1,04 | 0,98 | 0,90 | 0,92 | 0,95 | 0,98 | 1,00 | 1,03 |

Logique : creux à la moisson (juillet, offre massive), pic en mars (stocks bas).

**Agneau :**

| Mois | Jan | Fév | Mar | Avr | Mai | Jun | Jul | Aoû | Sep | Oct | Nov | Déc |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `f_saison` | 1,05 | 1,10 | 1,15 | 1,20 | 1,05 | 0,95 | 0,90 | 0,88 | 0,92 | 0,95 | 1,00 | 1,08 |

Logique : pic Pâques (+20%), creux été (faible demande).

**Volaille (poulet, dinde) :**

| Mois | Jan | Fév | Mar | Avr | Mai | Jun | Jul | Aoû | Sep | Oct | Nov | Déc |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `f_saison` | 0,95 | 0,95 | 0,97 | 1,00 | 1,00 | 1,00 | 1,00 | 1,02 | 1,03 | 1,05 | 1,10 | 1,20 |

Logique : pic Noël (+20%), relativement stable le reste de l'année.

**Porc :**

| Mois | Jan | Fév | Mar | Avr | Mai | Jun | Jul | Aoû | Sep | Oct | Nov | Déc |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `f_saison` | 0,96 | 0,95 | 0,97 | 1,00 | 1,03 | 1,05 | 1,06 | 1,05 | 1,02 | 0,98 | 0,96 | 0,97 |

Logique : pic barbecue été, creux hiver.

**Lait :**

| Mois | Jan | Fév | Mar | Avr | Mai | Jun | Jul | Aoû | Sep | Oct | Nov | Déc |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `f_saison` | 1,03 | 1,02 | 0,97 | 0,95 | 0,93 | 0,92 | 0,94 | 0,97 | 1,00 | 1,03 | 1,05 | 1,06 |

Logique : prix bas au printemps (pic de production = mise à l'herbe), haut en hiver.

### 2.3 Offre et demande (`f_offre_demande`)

Calculé chaque tick (1 tick = 1 jour in-game) sur l'activité réelle du serveur.

```
ratio = volume_vendu_7j / volume_moyen_historique_30j

Si ratio > 1 (forte demande / offre faible) :
  f_offre_demande = 1 + (ratio - 1) × sensibilité
Si ratio < 1 (faible demande / surproduction) :
  f_offre_demande = 1 - (1 - ratio) × sensibilité

Clamp : [1 - amplitude_max, 1 + amplitude_max]
```

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| `sensibilité` | 0,4 | 0,8 |
| `amplitude_max` | 0,12 | 0,25 |
| Fenêtre calcul | 7j / 30j | 7j / 30j |
| Mise à jour | Quotidienne | Quotidienne |

**Effet concret** : si beaucoup de joueurs vendent du blé en même temps (moisson), le ratio monte → le prix baisse. Si un serveur manque d'agneau avant Pâques, le prix grimpe.

### 2.4 Tendance pluriannuelle (`f_tendance`)

**Mode Normal** : `f_tendance = 1,00` (pas de cycle pluriannuel, stabilité).

**Mode Expert** : cycles longs inspirés de la réalité.

| Produit | Durée du cycle | Amplitude | Phase initiale (serveur) |
|---------|:--------------:|:---------:|:------------------------:|
| Porc | 3,5 ans | ±20% | Aléatoire |
| Lait | 4 ans | ±15% | Aléatoire |
| Céréales (blé, orge, maïs) | 3 ans | ±12% | Aléatoire |
| Colza/Tournesol | 2,5 ans | ±15% | Aléatoire |

```
f_tendance = 1 + amplitude × sin(2π × (mois_serveur + phase) / (durée_cycle × 12))
```

Le joueur Expert voit la tendance sur l'historique 5 ans et doit anticiper les retournements.

### 2.5 Qualité (`f_qualité`)

3 niveaux de qualité déterminés par les pratiques culturales / d'élevage.

| Niveau | `f_qualité` | Conditions d'obtention |
|:------:|:-----------:|------------------------|
| Standard | 0,95 | Pratiques minimales, rendement maximisé |
| Bon | 1,00 | Bonnes pratiques (rotation, doses ajustées) |
| Premium | 1,08 | Itinéraire optimisé (date, variété, sol) |

En Expert, des critères continus sont visibles (taux de protéines blé, teneur huile colza) mais le facteur reste discrétisé en 3 paliers pour la formule de prix.


---

## 3. Canaux de vente

Le joueur choisit **à qui** vendre. Chaque canal a un profil risque/marge/délai distinct.

### Vue d'ensemble

| Canal | Multiplicateur prix | Délai paiement | Disponibilité | Contrainte |
|-------|:-------------------:|:--------------:|:-------------:|------------|
| Coopérative | ×0,97 | Immédiat | Toujours | Aucune |
| Négoce | ×1,00 – ×1,03 | J+30 | Toujours | Quantité min 10t |
| Marché joueurs | Libre | À la transaction | Si acheteur existe | Commission 5% |
| Contrat anticipé | Fixé à la signature | J+7 après livraison | Expert uniquement | Engagement volume |
| Vente directe | ×1,50 – ×2,00 | Immédiat | Coûte du temps de travail | 30 min – 1 h 15 par lot |

### 3.1 Coopérative

Le canal sûr et sans friction. La coopérative achète tout, tout le temps.

| Paramètre | Valeur |
|-----------|--------|
| Prix | `prix_final × 0,97` |
| Paiement | Immédiat (crédit au solde) |
| Quantité min | 1 unité |
| Quantité max | Illimité |
| Avantage | Zéro risque, zéro attente |
| Inconvénient | -3% sur le prix du marché |

**En Normal** : bouton « Vendre à la coop » → vente instantanée avec conseil (« Vous pourriez gagner +8% en vendant en mars »).

**En Expert** : même mécanique, mais le joueur voit la décomposition du prix et le manque à gagner estimé.

### 3.2 Négoce

Prix légèrement supérieur, mais paiement différé.

| Paramètre | Valeur |
|-----------|--------|
| Prix | `prix_final × (1,00 à 1,03)` — tirage aléatoire quotidien |
| Paiement | J+30 (30 jours in-game après vente) |
| Quantité min | 10 tonnes (céréales) / 500 kg (viande) / 1000 L (lait) |
| Quantité max | Illimité |
| Avantage | Meilleur prix que la coop |
| Inconvénient | Délai de paiement, quantité minimum |

Le multiplicateur négoce est recalculé chaque jour : `1,00 + random(0, 0,03)`. Le joueur voit le prix du jour avant de vendre.

### 3.3 Marché entre joueurs

Le marché social : prix libre, offre et demande entre joueurs.

| Paramètre | Valeur |
|-----------|--------|
| Prix | Fixé librement par le vendeur |
| Commission | 5% prélevée sur le vendeur |
| Paiement | Immédiat à la transaction |
| Durée annonce | 7 jours (renouvelable) |
| Quantité | Libre |
| Filtres | Produit, distance, prix, qualité, réputation vendeur |

**Réputation** : score 1-5 étoiles basé sur les transactions passées (livraison dans les temps, qualité conforme). Visible par l'acheteur.

### 3.4 Contrat anticipé (Expert uniquement)

Voir section 4 dédiée.

### 3.5 Vente directe

Marge maximale mais coûte du temps de travail.

| Paramètre | Valeur |
|-----------|--------|
| Prix | `prix_final × 1,50` (marché local) à `× 2,00` (boutique ferme) |
| Paiement | Immédiat |
| Coût en temps | 30 min par lot (marché) / 1 h 15 par lot (boutique) |
| Quantité max/jour | 5 lots marché / 3 lots boutique |
| Investissement préalable | Marché = 0€ / Boutique = 15 000€ d'installation |
| Produits éligibles | Œufs, fromage, viande découpée, légumes, miel |

**Contrainte volontaire** : la vente directe est très rentable mais consomme le temps de travail du joueur. C'est un choix temps vs argent.

### Mockup ASCII — Interface de vente (Mode Normal)

```
┌─────────────────────────────────────────────────────────────────────┐
│ 🌾 VENDRE — Blé meunier (stock : 180 t)                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Prix actuel : 228,50 €/t   Tendance : ↗ (en hausse)              │
│                                                                     │
│  💡 Conseil : « Le blé monte au printemps. Stocker jusqu'en mars   │
│     pourrait rapporter +15 à 25 €/t. Coût de stockage : 0,50€/t/  │
│     mois. »                                                         │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │ Canal          │ Prix/t   │ Délai    │ Action               │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │ 🏪 Coopérative │ 221,65 € │ Immédiat │ [Vendre ▶]           │  │
│  │ 🏢 Négoce      │ 230,71 € │ J+30     │ [Vendre ▶]           │  │
│  │ 👥 Joueurs     │ Libre    │ Immédiat │ [Créer annonce ▶]    │  │
│  │ 🛒 Direct      │ 342,75 € │ Immédiat │ [Vendre (45 min) ▶] │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Quantité à vendre : [____100____] t    [Tout vendre]              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.6 Grossistes et centrales d'achat

Les grossistes et centrales d'achat sont des **canaux à volume élevé** qui achètent en grande quantité avec des conditions spécifiques. Ils complètent la coopérative (petit volume, prix bas) et le marché joueurs (volume libre, prix libre).

#### Catalogue des grossistes par type de produit

| Grossiste | Produits acceptés | Quantité min. | Multiplicateur prix | Délai paiement | Disponibilité serveur |
|-----------|-------------------|:-------------:|:-------------------:|:--------------:|:---------------------:|
| **Centrale céréalière** | Blé, orge, maïs, tournesol | 50 t | ×1,04 – ×1,08 | J+45 | 1 par serveur |
| **Négoce viande** | Carcasses bovines, porcines, ovines | 5 carcasses | ×1,06 – ×1,12 | J+21 | 2 par serveur |
| **Laiterie industrielle** | Lait cru (≥ 300 000 L/an contrat) | 1 000 L/jour | ×1,02 – ×1,05 | J+30 (mensuel) | 1 par serveur |
| **Centrale fruits & légumes** | Pommes, poires, PDT, légumes calibrés | 2 t | ×1,15 – ×1,30 | J+14 | 1 par serveur |
| **Grossiste œufs** | Œufs calibrés (min. M) | 5 000 œufs | ×1,05 – ×1,10 | J+14 | 1 par serveur |
| **Grossiste fromage** | Fromages affinés (DLC > 30 j) | 200 kg | ×1,10 – ×1,20 | J+30 | 1 par serveur |
| **Centrale bois** | Bois d'œuvre, bois énergie | 20 m³ | ×1,08 – ×1,15 | J+60 | 1 par serveur (si foresterie active) |

#### Conditions d'accès

| Condition | Détail |
|-----------|--------|
| Volume minimum | Obligatoire par livraison (voir tableau) |
| Contrat annuel | Facultatif : engagement volume annuel → multiplicateur +2% supplémentaire |
| Qualité requise | Standard minimum (pas de lot déclassé) |
| Transport | À la charge du vendeur (livraison au dépôt grossiste) |
| Distance dépôt | 30-80 km selon le serveur (coût transport à calculer) |
| Régularité | Bonus fidélité +1% après 6 livraisons consécutives (Expert) |

#### Calcul du prix grossiste

```python
prix_grossiste = prix_marche × multiplicateur_base × f_volume × f_qualite × f_fidelite

multiplicateur_base   : voir tableau (variable quotidienne dans la fourchette)
f_volume              : 1,00 (minimum) à 1,03 (×3 le volume minimum)
f_qualite             : 0,95 (standard) à 1,05 (premium/label)
f_fidelite (Expert)   : 1,00 (nouveau) à 1,02 (6+ livraisons)

Exemple — Vente de 120 t de blé meunier (qualité premium) à la centrale céréalière :
  Prix marché : 228,50 €/t
  Multiplicateur base : ×1,06 (tirage du jour)
  f_volume (120t, min 50t → ×2,4) : 1,02
  f_qualité (premium, prot > 11,5%) : 1,03
  f_fidélité : 1,01 (3e livraison)
  ─────────────────────
  Prix final : 228,50 × 1,06 × 1,02 × 1,03 × 1,01 = 257,12 €/t
  CA : 120 × 257,12 = 30 854 €
  (vs coopérative : 120 × 228,50 × 0,97 = 26 597 € → gain +4 257 €)
```

#### Interface grossiste (Mode Normal)

```
┌─ Grossistes disponibles ──────────────────────────────────────────┐
│                                                                    │
│  🏭 CENTRALE CÉRÉALIÈRE "AgriNord"                                 │
│     Distance : 45 km (coût transport : 8,50 €/t)                  │
│     Produits : Blé, Orge, Maïs, Tournesol                         │
│     Quantité min : 50 t                                            │
│     Prix du jour (blé) : 241,20 €/t (marché +5,6%)                │
│     Paiement : J+45                                                │
│                                                                    │
│     Mon stock éligible : 180 t de blé ✅                           │
│                                                                    │
│     Quantité : [___100___] t    Net (après transport) : 23 270 €   │
│     [ Livrer au grossiste ]                                        │
│                                                                    │
│  ── vs autres canaux ──                                            │
│  🏪 Coopérative : 221,65 €/t (immédiat) → 22 165 €                │
│  🏢 Négoce : 230,71 €/t (J+30) → 23 071 €                        │
│  💡 Le grossiste paie +8,8% vs coop mais à J+45 et transport 850 € │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**Mode Normal** : prix et disponibilité affichés clairement. Comparaison automatique avec les autres canaux.

**Mode Expert** : contrats annuels disponibles, bonus fidélité, négociation de prix plancher.

---

## 4. Contrats anticipés (Expert uniquement)

### Principe

Le joueur s'engage AVANT la récolte à livrer une quantité à un prix garanti. C'est l'outil de gestion du risque n°1 de l'agriculteur réel (60% des ventes céréalières se font en contrat).

### Mécaniques

| Paramètre | Valeur |
|-----------|--------|
| Disponibilité | Mode Expert uniquement |
| Moment de signature | 1 à 6 mois avant la date de livraison |
| Prix garanti | Prix du jour de la signature × (0,98 à 1,02) |
| Volume engagé | Le joueur choisit (5 à 100% de sa production estimée) |
| Date de livraison | Fixée au contrat (±7 jours de tolérance) |
| Paiement | J+7 après livraison effective |

### Calcul de la pénalité si non-livré

```
pénalité = (prix_marché_jour_livraison - prix_contrat) × quantité_manquante × 1,15

Si prix_marché < prix_contrat :
  pénalité = quantité_manquante × prix_contrat × 0,10  (pénalité plancher 10%)
```

**Explication** : si le joueur ne livre pas, l'acheteur doit acheter au prix du marché. Le joueur rembourse la différence + 15% de pénalité. Même si le marché a baissé, une pénalité plancher de 10% s'applique (rupture de contrat = toujours coûteux).

### Types de contrats disponibles

| Type | Description | Prime/Malus |
|------|-------------|:-----------:|
| Contrat ferme | Volume exact, prix exact | Prix × 1,00 |
| Contrat plancher | Prix minimum garanti, gain si hausse | Prix × 0,97 (prime payée) |
| Contrat tunnel | Prix entre un min et un max | Prix × 0,99 |

### Stratégie optimale

- Signer 30-50% de la production estimée en contrat ferme (sécurité)
- Garder 50-70% pour le marché spot (potentiel de hausse)
- Ne jamais signer 100% (risque de non-livraison si mauvaise récolte)

---

## 5. Stockage et spéculation

### Principe

Le joueur qui stocke sa récolte au lieu de vendre immédiatement parie sur une hausse future. Le stockage a un coût qui grignote la marge.

### Paramètres de stockage

| Paramètre | Valeur |
|-----------|--------|
| Perte physique | 0,5% du volume / mois (rongeurs, humidité, qualité) |
| Coût financier | 0,50 €/t/mois (énergie, entretien, assurance) |
| Capacité silo ferme | 200 t par silo (investissement : 35 000 €/silo) |
| Capacité cellule coop | Illimitée mais coût +0,30 €/t/mois supplémentaire |
| Durée max recommandée | 8-10 mois (au-delà, pertes > gains potentiels) |
| Produits stockables | Céréales, oléagineux (pas viande, pas lait) |

### Calcul du gain net de stockage

```
gain_net = (prix_vente_différé - prix_moisson) × quantité_restante
         - coût_stockage × mois × quantité_initiale
         - valeur_pertes_physiques

quantité_restante = quantité_initiale × (1 - 0,005)^mois
coût_stockage_total = 0,50 × mois × quantité_initiale
```

### Gain potentiel typique (blé)

| Stratégie | Prix vente | Stockage payé | Perte physique | Gain net vs moisson |
|-----------|:----------:|:-------------:|:--------------:|:-------------------:|
| Vente moisson (juillet) | 220 €/t | 0 € | 0% | Référence (0) |
| Vente octobre (+3 mois) | 232 €/t | 1,50 €/t | 1,5% | +9,2 €/t (+4,2%) |
| Vente janvier (+6 mois) | 243 €/t | 3,00 €/t | 3,0% | +18,3 €/t (+8,3%) |
| Vente mars (+8 mois) | 252 €/t | 4,00 €/t | 4,0% | +23,9 €/t (+10,9%) |

**Conclusion** : le stockage 8 mois rapporte environ +10-11% net. Le jeu récompense la patience sans être excessif.

### Interface stockage (Mode Expert)

```
┌─────────────────────────────────────────────────────────────────────┐
│ 📦 STOCKAGE — Simulation (Blé meunier, 150 t en silo)              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Stock actuel : 150,0 t (entrée : 1er juillet)                     │
│  Mois écoulés : 3       Pertes cumulées : 2,2 t (1,5%)            │
│  Coût stockage cumulé : 225,00 €                                   │
│                                                                     │
│  ┌────────────── Projection ──────────────────────────────────┐    │
│  │ Mois        │ Stock restant │ Prix estimé │ Gain net/t     │    │
│  ├─────────────────────────────────────────────────────────────┤    │
│  │ Maintenant  │ 147,8 t       │ 232 €/t     │ +9,2 €/t ✅   │    │
│  │ +3 mois     │ 145,6 t       │ 243 €/t     │ +18,3 €/t     │    │
│  │ +5 mois     │ 144,0 t       │ 252 €/t     │ +23,9 €/t 🎯  │    │
│  │ +8 mois     │ 141,9 t       │ 238 €/t     │ +12,1 €/t ⚠️  │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ⚠️ Attention : après mars, les prix redescendent (nouvelle        │
│     récolte approche). Fenêtre optimale : février-mars.            │
│                                                                     │
│  [Vendre maintenant ▶]  [Programmer vente en mars ▶]              │
└─────────────────────────────────────────────────────────────────────┘
```


---

## 6. Marché entre joueurs

### Principe

Le marché joueurs est l'espace social du commerce. Prix libre, négociation directe, réputation. C'est le canal qui différencie un MMO d'un jeu solo.

### Mécaniques

| Paramètre | Valeur |
|-----------|--------|
| Commission vendeur | 5% du montant de la transaction |
| Commission acheteur | 0% |
| Durée d'une annonce | 7 jours (renouvelable gratuitement) |
| Annonces actives max | 10 par joueur (Normal) / 25 par joueur (Expert) |
| Prix minimum | 50% du `prix_final` actuel |
| Prix maximum | 200% du `prix_final` actuel |
| Filtres disponibles | Produit, distance (km), prix, qualité, label, réputation |
| Livraison | Instantanée (même serveur) / Coût transport si distance >50 km |

### Système de réputation

| Score | Conditions | Effet |
|:-----:|-----------|-------|
| ★☆☆☆☆ | Nouveau vendeur (<5 transactions) | Badge « Nouveau » |
| ★★☆☆☆ | 5-19 transactions, <90% satisfaction | Aucun bonus |
| ★★★☆☆ | 20-49 transactions, ≥90% satisfaction | Annonces mieux classées |
| ★★★★☆ | 50-99 transactions, ≥95% satisfaction | Badge « Vendeur fiable » |
| ★★★★★ | 100+ transactions, ≥98% satisfaction | Badge « Vendeur d'élite », -1% commission |

**Satisfaction** = livraison dans les délais + qualité conforme à l'annonce.

### Marché privé (B2B)

| Paramètre | Valeur |
|-----------|--------|
| Commission | 2% (vs 5% marché public) |
| Visibilité | Transaction privée (entre 2 joueurs nommés) |
| Usage | Contrats récurrents entre partenaires, coopératives joueurs |

### Transport et distance

| Distance | Coût transport (céréales) | Coût transport (animaux) |
|:--------:|:-------------------------:|:------------------------:|
| 0-50 km | Gratuit | Gratuit |
| 50-150 km | 2 €/t | 0,05 €/kg |
| 150-300 km | 5 €/t | 0,12 €/kg |
| >300 km | 8 €/t | 0,20 €/kg |

---

## 7. Achat d'intrants

### Principe

Le marché n'est pas que la vente : l'achat d'intrants est un poste de charge majeur (40-60% du coût de production en grandes cultures). La coopérative offre un avantage prix grâce aux achats groupés.

### Canaux d'achat

| Canal | Prix | Disponibilité | Avantage |
|-------|:----:|:-------------:|----------|
| Coopérative | `prix_base × 0,92` | Toujours | -8% grâce aux achats groupés |
| Négoce | `prix_base × 1,00` | Toujours | Pas d'engagement |
| Marché joueurs | Libre | Si offre existe | Potentiellement moins cher |
| Achat groupé (coop joueurs) | `prix_base × 0,85` | Si coop joueurs organisée | -15% mais volume minimum |

### Prix des intrants de référence

| Intrant | `prix_base` | Unité | Coop (×0,92) | Négoce (×1,00) |
|---------|:-----------:|:-----:|:------------:|:--------------:|
| Semence blé | 80 | €/ha | 73,60 | 80,00 |
| Semence maïs | 180 | €/ha | 165,60 | 180,00 |
| Engrais azoté (ammonitrate) | 350 | €/t | 322,00 | 350,00 |
| Engrais composé (NPK) | 450 | €/t | 414,00 | 450,00 |
| Herbicide (céréales) | 45 | €/ha | 41,40 | 45,00 |
| Fongicide (céréales) | 55 | €/ha | 50,60 | 55,00 |
| Aliment porc (complet) | 320 | €/t | 294,40 | 320,00 |
| Aliment volaille | 380 | €/t | 349,60 | 380,00 |
| Aliment bovin (concentré) | 290 | €/t | 266,80 | 290,00 |

### Saisonnalité des intrants

Les intrants aussi ont une saisonnalité (demande saisonnière = hausse temporaire) :

| Intrant | Pic de demande | `f_saison` au pic | Creux | `f_saison` au creux |
|---------|:--------------:|:-----------------:|:-----:|:-------------------:|
| Semences | Sept-Oct (automne) | 1,05 | Été | 0,95 |
| Engrais azotés | Fév-Mar (sortie hiver) | 1,08 | Été | 0,93 |
| Phytosanitaires | Avr-Mai (traitements) | 1,06 | Hiver | 0,94 |
| Aliments animaux | Stable toute l'année | 1,00 | — | 1,00 |

**Stratégie** : acheter ses engrais en été (quand personne n'en veut) = -7% naturel + -8% coop = **-15% total**.

---

## 8. Labels et survaleur

### Principe

Les labels permettent une stratégie de différenciation : produire moins mais vendre beaucoup plus cher. C'est l'alternative au modèle « volume maximum ».

### Labels disponibles

| Label | Survaleur prix | Contraintes principales | Durée certification |
|-------|:--------------:|------------------------|:-------------------:|
| Agriculture Biologique | +40% à +80% | 0 phyto chimique, rotation 5 cultures min, 2 ans conversion | 2 ans |
| Label Rouge | +15% à +40% | Cahier des charges strict (race, alimentation, densité) | Immédiat si conforme |
| AOP (Appellation d'Origine) | +30% à +200% | Zone géographique, race/variété imposée, pratiques ancestrales | 1 an |

### Détail par produit et label

| Produit | Conventionnel | Bio | Label Rouge | AOP |
|---------|:------------:|:---:|:-----------:|:---:|
| Blé | 220 €/t | 352 €/t (+60%) | — | — |
| Lait | 0,43 €/L | 0,65 €/L (+51%) | — | 0,75 €/L (+74%) |
| Poulet | 1,00 €/kg | 1,60 €/kg (+60%) | 1,35 €/kg (+35%) | — |
| Œuf | 0,18 € | 0,29 € (+61%) | 0,25 € (+39%) | — |
| Agneau | 7,50 €/kg | 10,50 €/kg (+40%) | 9,75 €/kg (+30%) | 12,00 €/kg (+60%) |
| Fromage (vache, kg) | 8,00 € | 12,00 € (+50%) | 10,50 € (+31%) | 18,00 € (+125%) |

### Contraintes par label

**Agriculture Biologique :**
| Contrainte | Détail |
|-----------|--------|
| Phytosanitaires chimiques | Interdits (seuls produits bio autorisés, efficacité -30%) |
| Engrais chimiques | Interdits (fumier, compost uniquement) |
| Rotation | Minimum 5 cultures différentes sur 5 ans |
| Densité animale | Max 2 UGB/ha de surface fourragère |
| Conversion | 2 ans sans production bio reconnue (charges sans survaleur) |
| Rendement | -20 à -30% vs conventionnel |

**Label Rouge :**
| Contrainte | Détail |
|-----------|--------|
| Race/variété | Imposée (poulet : croissance lente min 81 jours) |
| Alimentation | Min 70% céréales, pas d'OGM |
| Densité | Max 11 poulets/m² (vs 22 conventionnel) |
| Accès extérieur | Obligatoire (2 m²/animal minimum) |
| Rendement | -30 à -50% en nombre d'animaux par bâtiment |

**AOP :**
| Contrainte | Détail |
|-----------|--------|
| Zone géographique | Parcelle dans la zone définie (pas de choix libre) |
| Race/variété | Imposée (ex : Comté = Montbéliarde ou Simmental) |
| Alimentation | 100% locale, pas d'ensilage (Comté) |
| Transformation | Sur place, méthodes traditionnelles |
| Rendement | Variable selon AOP |

### Équilibre labels vs conventionnel

**Philosophie de design** : un joueur bio/label ne doit PAS être plus riche qu'un joueur conventionnel optimisé. Il est différent — marge unitaire supérieure, volume inférieur, contraintes plus fortes.

| Stratégie | Revenu/ha estimé | Complexité | Risque |
|-----------|:----------------:|:----------:|:------:|
| Conventionnel optimisé | 800-1 000 €/ha | Faible | Moyen (prix volatile) |
| Bio | 750-1 100 €/ha | Élevée | Faible (prix stable) |
| Label Rouge (volaille) | 900-1 200 €/ha eq. | Élevée | Faible |
| AOP fromage | 1 000-2 500 €/ha eq. | Très élevée | Très faible |


---

## 9. Équilibrage et scénarios chiffrés

### Objectifs d'équilibrage

| Cible | Valeur | Justification |
|-------|:------:|---------------|
| Gain net du stockage 8 mois | +10-12% | Récompense la patience sans rendre la vente immédiate absurde |
| Avantage négoce vs coop | +3-6% | Justifie le délai de paiement J+30 |
| Avantage vente directe | +50-100% prix, -30 min à 1 h 15 | Le temps est la vraie monnaie |
| Amplitude saisonnière (Normal) | ±10% | Visible mais pas écrasant |
| Amplitude saisonnière (Expert) | ±20% | Récompense l'analyse |
| Marge bio vs conventionnel | Comparable (±15%) | Pas de stratégie dominante |
| Pénalité contrat non-livré | Supérieure au gain d'un contrat | Dissuasif, pas ruineux |

### Scénario 1 — Vendre à la moisson vs stocker 8 mois (blé, 150 t)

**Contexte** : Joueur Expert, récolte 150 t de blé en juillet, qualité Bon.

#### Option A : Vente immédiate à la coopérative (juillet)

```
prix_base = 220 €/t
f_saison (juillet) = 0,90
f_offre_demande = 0,96 (beaucoup de joueurs vendent en juillet)
f_tendance = 1,03 (cycle céréales en légère hausse)
f_qualité = 1,00 (Bon)

prix_final = 220 × 0,90 × 0,96 × 1,03 × 1,00 = 195,68 €/t
prix_coop = 195,68 × 0,97 = 189,81 €/t

Revenu total = 189,81 × 150 = 28 471,50 €
Charges vente (Expert 28%) = 0 € (charges sur le bénéfice annuel, pas par vente)
```

**Revenu brut Option A = 28 471,50 €**

#### Option B : Stockage 8 mois, vente au négoce en mars

```
Mois de stockage = 8
Pertes physiques = 150 × (1 - 0,995^8) = 150 × 0,0394 = 5,91 t perdues
Stock restant = 144,09 t
Coût stockage = 0,50 × 8 × 150 = 600,00 €

prix_base = 220 €/t
f_saison (mars) = 1,10
f_offre_demande = 1,05 (peu de joueurs vendent en mars)
f_tendance = 1,05 (cycle toujours en hausse 8 mois plus tard)
f_qualité = 1,00

prix_final_mars = 220 × 1,10 × 1,05 × 1,05 × 1,00 = 266,81 €/t
prix_negoce = 266,81 × 1,02 = 272,14 €/t

Revenu brut = 272,14 × 144,09 = 39 213,09 €
Coût stockage = - 600,00 €
Revenu net = 38 613,09 €
```

**Revenu net Option B = 38 613,09 €**

#### Comparaison

| | Option A (moisson) | Option B (stockage 8 mois) | Différence |
|-|:------------------:|:--------------------------:|:----------:|
| Prix/t obtenu | 189,81 € | 272,14 € | +82,33 €/t (+43%) |
| Volume vendu | 150,00 t | 144,09 t | -5,91 t |
| Coûts additionnels | 0 € | 600 € | +600 € |
| **Revenu total** | **28 471 €** | **38 613 €** | **+10 142 € (+36%)** |
| Capital immobilisé 8 mois | Non | Oui (28 471 €) | Coût d'opportunité |

**Analyse** : le stockage rapporte +36% sur cet exemple favorable (f_tendance en hausse + bonne saisonnalité). Dans un scénario défavorable (f_tendance = 0,95), le gain tomberait à +8-12%. Le risque est réel.

**Risque principal** : si un événement fait chuter `f_offre_demande` pendant le stockage (beaucoup de joueurs vendent en même temps), le gain peut être nul voire négatif.

### Scénario 2 — Contrat anticipé vs marché spot (Expert, colza 80 t)

**Contexte** : Joueur Expert, colza estimé 80 t, signe un contrat en avril pour livraison août.

#### Option A : Contrat signé en avril (prix garanti)

```
Prix avril : 470 × 1,04 × 1,02 × 1,00 × 1,00 = 498,16 €/t
Contrat ferme : 498,16 €/t pour 60 t (75% de la production estimée)
Reste : 20 t vendues au spot en août

Prix spot août : 470 × 0,92 × 0,94 × 1,00 × 1,00 = 407,02 €/t
Prix coop août : 407,02 × 0,97 = 394,81 €/t

Revenu contrat = 498,16 × 60 = 29 889,60 €
Revenu spot = 394,81 × 20 = 7 896,20 €
Revenu total = 37 785,80 €
```

#### Option B : Tout au spot en août

```
Prix spot août : 407,02 €/t
Prix coop : 394,81 €/t

Revenu total = 394,81 × 80 = 31 584,80 €
```

#### Comparaison

| | Contrat 75% + spot | Tout spot | Différence |
|-|:------------------:|:---------:|:----------:|
| **Revenu total** | **37 786 €** | **31 585 €** | **+6 201 € (+20%)** |
| Risque | Faible (75% garanti) | Élevé (prix moisson = creux) |
| Contrainte | Doit livrer 60 t | Aucune |

**Conclusion** : le contrat anticipé protège ET rapporte plus quand le prix moisson est bas. C'est le choix rationnel si le joueur peut livrer.

### Scénario 3 — Bio vs Conventionnel (blé, 100 ha, sur 1 an)

| Poste | Conventionnel | Bio |
|-------|:------------:|:---:|
| Rendement | 8 t/ha | 5,5 t/ha (-31%) |
| Prix de vente | 220 €/t | 352 €/t (+60%) |
| Recette brute | 176 000 € | 193 600 € |
| Semences | 8 000 € | 9 500 € (+19%) |
| Engrais | 35 000 € | 12 000 € (-66%, pas d'azote chimique) |
| Phytos | 12 000 € | 3 000 € (-75%, produits bio uniquement) |
| Charges totales | 55 000 € | 24 500 € |
| **Marge brute** | **121 000 €** | **169 100 €** |
| Marge/ha | 1 210 €/ha | 1 691 €/ha |

**Nuance** : le bio est plus rentable ICI car le prix est +60%. Mais :
- 2 ans de conversion sans survaleur (investissement initial)
- Rendement plus variable (pas de filet phyto)
- Rotation 5 cultures obligatoire (complexité)
- Risque adventices → perte récolte possible en Normal si mal géré

**Équilibre atteint** : le bio rapporte ~25% de plus en marge/ha mais nécessite plus de savoir-faire et l'investissement de 2 ans de conversion.

### Détection de problèmes et corrections

| Problème détecté | Correction |
|-----------------|-----------|
| Stockage trop rentable si f_tendance toujours favorable | f_tendance aléatoire → parfois le cycle descend pendant le stockage |
| Vente directe OP si beaucoup de temps disponible | Limiter à 5 lots/jour max + investissement boutique 15 000€ |
| Bio toujours meilleur | Rendement -31% + conversion 2 ans + risques sans phytos |
| Contrat sans risque | Pénalité sévère si non-livré (incite à ne pas s'engager à 100%) |
| Négoce toujours meilleur que coop | Délai J+30 = capital immobilisé, et multiplicateur variable (parfois ×1,00 = pas d'avantage) |

### Checklist playtest

| Test | Critère | Bloquant ? |
|------|---------|:----------:|
| Test recette SimAgri | Un joueur Normal peut vendre en 1 clic à la coop, sans calcul | ✅ Bloquant |
| Le conseil est utile | En Normal, le conseil « vendez en mars » est correct dans >80% des cas | ✅ Bloquant |
| Pas de perte définitive en Normal | Un joueur Normal ne peut pas perdre d'argent en vendant (prix coop > 0 toujours) | ✅ Bloquant |
| L'Expert n'est pas plus riche | À effort égal, l'Expert et le Normal arrivent au même revenu (±15%) | ✅ Bloquant |
| Le stockage est risqué | Dans 20-30% des cas, stocker rapporte MOINS que vendre immédiatement | Souhaité |
| Le marché joueurs est actif | Au moins 50 annonces actives à tout moment sur un serveur de 200 joueurs | Souhaité |
| Les labels ne sont pas dominants | Un joueur conventionnel optimisé rivalise avec un joueur bio | ✅ Bloquant |

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Charges forfaitaires | 12% | 28% |
| `f_saison` amplitude | ±10% | ±20% |
| `f_offre_demande` amplitude | ±12% | ±25% |
| `f_tendance` | 1,00 (désactivé) | Cycles actifs (±12-20%) |
| Contrats anticipés | Non | Oui |
| Simulation stockage | Non (conseil textuel) | Outil chiffré intégré |
| Historique prix visible | 6 mois | 5 ans + export CSV |
| Décomposition prix | Non (prix final seul) | Oui (5 facteurs visibles) |
| Annonces marché joueurs max | 10 | 25 |
| Vente directe disponible | Oui (marché local) | Oui (marché + boutique ferme) |
| Conseil automatique | Oui | Non |
| Labels disponibles | Bio, Label Rouge | Bio, Label Rouge, AOP |
| Achat intrants coop | -8% | -8% (identique) |
| Achat groupé (coop joueurs) | Non | Oui (-15%) |
| Prix minimum marché joueurs | 70% prix_final | 50% prix_final |
| Prix maximum marché joueurs | 150% prix_final | 200% prix_final |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | GDD marché et commercialisation — draft complet |
| 2026-08-04 | Ajout §3.6 Grossistes et centrales d'achat | Audit couverture fonctionnelle — système 7.8 partiel |
