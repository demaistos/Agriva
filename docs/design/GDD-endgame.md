> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Endgame et rétention long terme

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `foundation/PLAN-DIRECTEUR.md` Phase 10, ADR-001, ADR-002, ADR-003

---

## 1. Vision — Le problème du endgame

### 1.1 Le constat

Dans un jeu de gestion, le joueur optimise. En 1-2 ans, sa ferme tourne parfaitement : trésorerie solide, bâtiments complets, troupeau génétiquement excellent. **Pourquoi revient-il le jour 731 ?**

SimAgri répond à cette question depuis 20 ans. La réponse n'est PAS « plus de contenu » — c'est **un écosystème social où le joueur a un rôle**.

### 1.2 Les 5 piliers de la rétention long terme

| Pilier | Mécanisme | Exemple SimAgri |
|--------|-----------|-----------------|
| **Social** | Les relations humaines créent de l'obligation douce | Amis, coopérative, forum |
| **Compétition amicale** | Se mesurer sans enjeu destructif | Classements, génétique |
| **Prestige** | Être reconnu pour son expertise | Titres, hall of fame |
| **Nouvelles activités** | Recommencer une courbe d'apprentissage | Nouveau métier, nouvelle filière |
| **Mentorat** | Aider les nouveaux donne un sens à l'expérience acquise | Parrainage, conseils |

### 1.3 Principe fondamental

> **Le endgame donne du prestige, pas de la puissance.**
> Un joueur de 5 ans a des trophées, pas 10× plus de revenus qu'un joueur de 6 mois.

### 1.4 Gameplay loop endgame

```
┌──────────────────────────────────────────────────────────────┐
│  BOUCLE HEBDOMADAIRE (joueur vétéran)                        │
└──────────────────────────────────────────────────────────────┘
  Gérer sa ferme (routine optimisée, 10 min/jour)
  Suivre ses activités de prestige (vin, forêt)
  Participer au marché (spéculation, ventes premium)
  Aider un filleul / répondre sur le forum
        ↓
  Sentiment : expertise reconnue, rôle dans la communauté

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE SAISONNIÈRE                                          │
└──────────────────────────────────────────────────────────────┘
  Préparer un concours (animaux, produits)
  Vendanges / travaux forestiers
  Défi saisonnier du serveur
        ↓
  Sentiment : événement attendu, compétition stimulante

┌──────────────────────────────────────────────────────────────┐
│  BOUCLE ANNUELLE                                             │
└──────────────────────────────────────────────────────────────┘
  Salon agricole (événement serveur majeur)
  Bilan du domaine viticole (millésime)
  Objectifs de collection / records à battre
  Transmission de savoir (guides, mentorat)
        ↓
  Sentiment : accomplissement durable, héritage
```

### 1.5 Normal vs Expert — Principes endgame

| Aspect | Normal | Expert |
|--------|--------|--------|
| Viticulture | Cycle simplifié, qualité = terroir + technique | Vinification détaillée, assemblages, élevage fin |
| Foresterie | Plantation → attente → coupe → vente | Gestion sylvicole, éclaircies, qualité bois |
| Concours | Inscription + résultat automatique | Préparation active, stratégie de présentation |
| Monétisation | Identique | Identique |

---

## 2. Viticulture — Activité de prestige

### 2.1 Intention de design

La viticulture est le **contenu de prestige par excellence** : investissement lourd, revenus différés de 3-5 ans, mais marges potentiellement énormes. C'est l'activité qui dit « j'ai réussi, maintenant je fais du vin ».

**Pourquoi c'est du endgame** :
- Capital initial : 80 000-150 000 € (plantation + cave)
- Première récolte exploitable : année 3 après plantation
- Premier vin de qualité : année 5-8
- Spéculation sur les millésimes : horizon 10-20 ans

### 2.2 Le domaine viticole

| Élément | Détail |
|---------|--------|
| Surface min. | 1 ha (2 500 pieds) |
| Surface max. | 30 ha |
| Cépages disponibles | 12 (6 rouges, 4 blancs, 2 rosés) |
| Terroirs | 5 types (calcaire, argilo-calcaire, schiste, gravier, volcanique) |
| Rendement AOC | 45-60 hl/ha selon appellation |
| Durée de vie d'une vigne | 50 ans (qualité croissante jusqu'à 30 ans) |

#### Cépages

| Cépage | Couleur | Terroir idéal | Rendement | Qualité potentielle |
|--------|---------|---------------|:---------:|:-------------------:|
| Merlot | Rouge | Argilo-calcaire | 55 hl/ha | ★★★ |
| Cabernet Sauvignon | Rouge | Gravier | 45 hl/ha | ★★★★★ |
| Pinot Noir | Rouge | Calcaire | 40 hl/ha | ★★★★★ |
| Syrah | Rouge | Schiste | 50 hl/ha | ★★★★ |
| Grenache | Rouge | Volcanique | 50 hl/ha | ★★★ |
| Gamay | Rouge | Volcanique | 60 hl/ha | ★★ |
| Chardonnay | Blanc | Calcaire | 55 hl/ha | ★★★★★ |
| Sauvignon Blanc | Blanc | Calcaire | 60 hl/ha | ★★★ |
| Riesling | Blanc | Schiste | 50 hl/ha | ★★★★ |
| Viognier | Blanc | Gravier | 40 hl/ha | ★★★★ |
| Grenache gris | Rosé | Schiste | 55 hl/ha | ★★★ |
| Cinsault | Rosé | Volcanique | 60 hl/ha | ★★ |

### 2.3 Cycle annuel de la vigne

```
JANVIER-MARS : TAILLE
  → Décision : taille courte (rendement ↓, qualité ↑) ou longue (rendement ↑, qualité ↓)
  → Coût main-d'œuvre : 800 €/ha

AVRIL-MAI : TRAITEMENTS
  → Décision : conventionnel (efficace, pas cher) ou bio (risqué, prime qualité)
  → 4-8 passages selon météo
  → Coût : 400-1 200 €/ha

JUIN : ÉBOURGEONNAGE + EFFEUILLAGE (Expert uniquement)
  → Contrôle du rendement pour augmenter la concentration

JUILLET-AOÛT : VÉRAISON
  → Observation (pas d'action, mais la météo décide du millésime)
  → Grêle possible = perte partielle ou totale

SEPTEMBRE : VENDANGES
  → Décision : date de récolte (trop tôt = vert, trop tard = surmaturité/pourriture)
  → Mécanique ou manuelle (qualité +10% en manuel, coût ×4)
  → Coût : 1 500-6 000 €/ha

OCTOBRE-DÉCEMBRE : VINIFICATION
  → Normal : choix simple (rouge/blanc/rosé, durée de cuve)
  → Expert : température de fermentation, levures, macération, pigeage

ANNÉE N+1 à N+2 : ÉLEVAGE
  → Choix : cuve inox (neutre) ou fût de chêne (complexité, coût)
  → Fûts neufs : 600 €/pièce (228L), durée de vie 3 utilisations
  → Durée : 6-24 mois selon ambition

MISE EN BOUTEILLE
  → Le vin est prêt à vendre ou à garder en cave
```

### 2.4 Qualité du vin — Formule

```python
qualite_base = terroir_match * 20          # 0-20 pts (adéquation cépage/terroir)
             + age_vigne * 0.4             # 0-20 pts (vieilles vignes = mieux, plafond à 50 ans)
             + millesime * 20              # 0-20 pts (météo de l'année, 0.0-1.0)
             + technique * 20             # 0-20 pts (taille + traitements + vendange)
             + vinification * 20          # 0-20 pts (Expert: détaillé / Normal: simplifié)

# Total : 0-100 points

# Bonus élevage en fût
if elevage_fut:
    qualite_finale = qualite_base + min(10, mois_fut * 0.5)
else:
    qualite_finale = qualite_base

# Le millésime est un coefficient serveur, identique pour tous les joueurs d'une région
# Mauvaise année : 0.3-0.5 | Moyenne : 0.6-0.7 | Bonne : 0.8-0.9 | Exceptionnelle : 0.95-1.0
```

**En Normal** : `technique` = 3 choix binaires (taille courte/longue, bio/conventionnel, manuel/mécanique). Score simplifié.

**En Expert** : `technique` et `vinification` = paramètres fins (température, durée macération, assemblage).

### 2.5 Garde et spéculation

Un vin en cave **évolue avec le temps** :

```python
# Chaque vin a une courbe de garde selon sa qualité et son cépage
apogee_annees = qualite_finale * 0.3 + bonus_cepage  # 5-30 ans
garde_actuelle = annees_en_cave

if garde_actuelle < apogee_annees * 0.5:
    valeur_multiplicateur = 1.0 + (garde_actuelle / apogee_annees) * 1.5
elif garde_actuelle < apogee_annees:
    valeur_multiplicateur = 2.0 + (garde_actuelle / apogee_annees) * 0.5  # max ~2.5
elif garde_actuelle < apogee_annees * 1.5:
    valeur_multiplicateur = 2.5 - (garde_actuelle - apogee_annees) / apogee_annees * 0.5
else:
    valeur_multiplicateur = max(0.5, 2.0 - (garde_actuelle - apogee_annees) / apogee_annees)
    # Le vin décline, mais ne tombe jamais sous 50% de sa valeur de base
```

**Conséquence gameplay** : un joueur peut spéculer sur ses millésimes. Un vin de qualité 90, année exceptionnelle, gardé 15 ans, vaut 2-3× son prix initial. Mais il faut immobiliser du capital et de l'espace cave pendant 15 ans.

### 2.6 AOC et concours viticoles

| AOC (fictive) | Condition | Bonus prix |
|---------------|-----------|:----------:|
| AOC Coteaux d'Agriva | Terroir calcaire, Pinot Noir ou Chardonnay, rendement ≤ 50 hl/ha | +40% |
| AOC Graves du Sud | Terroir gravier, Cabernet/Merlot, élevage ≥ 12 mois | +35% |
| IGP Collines | Tout cépage, rendement ≤ 60 hl/ha | +15% |
| Vin de table | Aucune contrainte | +0% |

**Concours des vins** : événement saisonnier (cf. section 5).

### 2.7 Économie viticole — Investissement et revenus

| Poste | Coût |
|-------|-----:|
| Plantation (pieds + tuteurs + palissage) | 25 000 €/ha |
| Cave de vinification (équipement) | 40 000 € (jusqu'à 10 ha) |
| Fûts de chêne (100 pièces) | 60 000 € |
| Charges annuelles (main-d'œuvre, traitements, entretien) | 5 000 €/ha |
| Bouteilles + étiquettes + bouchons | 1,50 €/bouteille |

| Produit | Prix de vente (par bouteille 75cl) |
|---------|-----------------------------------:|
| Vin de table (qualité 30-50) | 3-5 € |
| IGP (qualité 50-70) | 6-10 € |
| AOC jeune (qualité 70-85) | 12-20 € |
| AOC vieilli (qualité 85-95, garde 5+ ans) | 25-50 € |
| Cru exceptionnel (qualité 95+, garde 10+ ans) | 60-120 € |

**Rendement en bouteilles** : 1 ha à 50 hl/ha = 5 000 L = 6 666 bouteilles.

### 2.8 Matériel viticole — Catalogue complet

| Machine | Prix | Puissance | Capacité/Débit | Heures de vie | Entretien/an |
|---------|-----:|:---------:|:--------------:|:-------------:|:------------:|
| Enjambeur (tracteur viticole) | 95 000 € | 75 CV | Inter-rang 1,5-2,0 m | 8 000 h | 3 200 €/an |
| Chenillard de pente | 55 000 € | 50 CV | Pente > 30% | 6 000 h | 2 400 €/an |
| Pulvérisateur confiné (face-par-face) | 18 000 € | Traîné par enjambeur | 2,5-4 ha/h | 2 500 h | 800 €/an |
| Prétailleuse mécanique | 12 000 € | Traîné par enjambeur | 1,5 ha/h | 2 000 h | 450 €/an |
| Rogneuse (rognage d'été) | 8 500 € | Traîné par enjambeur | 2 ha/h | 2 000 h | 350 €/an |
| Effeuilleuse mécanique | 14 000 € | Traîné par enjambeur | 1,2 ha/h | 2 000 h | 500 €/an |
| Vendangeuse mécanique | 185 000 € | 150 CV (automotrice) | 2-3 ha/h | 4 000 h | 6 500 €/an |
| Pressoir pneumatique (30 hl) | 28 000 € | Électrique | 30 hl/pressée (2h/cycle) | 15 ans | 800 €/an |
| Pressoir pneumatique (80 hl) | 55 000 € | Électrique | 80 hl/pressée (2,5h/cycle) | 15 ans | 1 200 €/an |
| Cuve inox thermorégulée (50 hl) | 4 500 € | — | 50 hl | 30 ans | 80 €/an |
| Cuve inox thermorégulée (100 hl) | 7 800 € | — | 100 hl | 30 ans | 120 €/an |
| Égrappoir-fouloir | 8 000 € | Électrique | 5-10 t/h | 15 ans | 300 €/an |
| Embouteilleuse (500 bout./h) | 15 000 € | Électrique | 500 bouteilles/h | 10 ans | 600 €/an |

#### Calcul du temps de travail viticole (ADR-004)

```
DOMAINE DE 10 HA — CYCLE ANNUEL

  Taille (manuelle obligatoire, qualité AOC) :
    800 h/ha × qualité personnelle → 80 h/ha effectif
    10 ha × 80 h = 800 h (répartis sur déc-mars = 4 mois = 200 h/mois)
    → 2 employés nécessaires pour la taille seule

  Traitements (6 passages/an avec enjambeur + pulvé confiné) :
    10 ha ÷ 3 ha/h = 3,3 h/passage × 6 = 20 h/an

  Vendanges :
    Mécanique : 10 ha ÷ 2,5 ha/h = 4 h + transport + tri = 8 h total
    Manuelle : 10 ha × 150 h/ha MO = 1 500 h (50 vendangeurs × 5 jours)

  Vinification + élevage :
    Pressurage : 500 hl ÷ 80 hl/pressée × 2,5 h = 15,6 h
    Surveillance cuves (2 mois) : 1 h/jour × 60 = 60 h
    Soutirage + mise en fûts : 20 h
    Mise en bouteille (66 660 bout.) : 66 660 ÷ 500 bout/h = 133 h

  TOTAL ANNUEL (10 ha, mécanique) : ≈ 1 100 h/an
  TOTAL ANNUEL (10 ha, manuel) : ≈ 2 600 h/an
```

#### Conditions d'utilisation

| Contrainte | Matériel affecté | Effet |
|-----------|:----------------:|-------|
| Pente > 30% | Enjambeur interdit | Chenillard obligatoire (+55 000 €) |
| AOC « vendange manuelle » | Vendangeuse mécanique interdite | MO ×20, qualité +5 pts |
| Inter-rang < 1,5 m (vieilles vignes) | Enjambeur standard interdit | Travail manuel ou micro-enjambeur (+120 000 €) |
| Gel printanier | Tout matériel | Bougies antigel (3 000 €/ha) ou aspersion (irrigation requise) |


---

## 3. Foresterie — Le temps très long

### 3.1 Intention de design

La foresterie est le **jeu ultra-long terme** : planter un chêne pour le récolter dans 80-150 ans de jeu. C'est une mécanique d'héritage — on plante pour les « générations futures » (ou on rachète une forêt mature à un joueur qui quitte).

**Pourquoi c'est du endgame** :
- Capital immobilisé très longtemps (ou achat d'une forêt existante, cher)
- Revenus rares mais importants (une coupe = gros montant ponctuel)
- Gestion patrimoniale : la forêt est un actif qui se valorise avec le temps
- Activité « passive » idéale pour un joueur vétéran qui ne veut plus micro-gérer

### 3.2 Les parcelles forestières

| Paramètre | Valeur |
|-----------|--------|
| Taille parcelle | 5-50 ha |
| Prix d'achat (terrain nu) | 3 000-5 000 €/ha |
| Prix d'achat (forêt mature 80 ans) | 8 000-15 000 €/ha |
| Essences disponibles | 8 |

#### Essences

| Essence | Cycle (ans) | Valeur bois d'œuvre (€/m³) | Usage principal | Croissance |
|---------|:-----------:|:--------------------------:|-----------------|:----------:|
| Chêne sessile | 120-150 | 200-400 | Tonnellerie, menuiserie | Lente |
| Chêne pédonculé | 100-130 | 150-300 | Construction, parquet | Lente |
| Hêtre | 80-120 | 80-150 | Ameublement, chauffage | Moyenne |
| Frêne | 60-80 | 100-180 | Outillage, sport | Moyenne |
| Douglas | 40-60 | 60-100 | Construction, charpente | Rapide |
| Épicéa | 40-50 | 50-80 | Papeterie, palette | Rapide |
| Pin maritime | 30-50 | 40-70 | Industrie, pâte à papier | Rapide |
| Peuplier | 15-20 | 30-50 | Emballage, contreplaqué | Très rapide |

### 3.3 Cycle forestier

```
ANNÉE 0 : PLANTATION
  → Choix de l'essence, densité (1 000-3 000 pieds/ha)
  → Coût : 3 000-6 000 €/ha (plants + main-d'œuvre)

ANNÉES 1-5 : ENTRETIEN JEUNE PEUPLEMENT
  → Dégagement (fauche autour des plants) : 300 €/ha/an
  → Pas de revenu

ANNÉES 10-20 : PREMIÈRE ÉCLAIRCIE
  → Retirer 30-40% des arbres (les plus faibles)
  → Bois de chauffage/industrie : revenu faible (500-1 500 €/ha)
  → Libère de l'espace pour les arbres restants

ANNÉES 30-50 : DEUXIÈME ÉCLAIRCIE
  → Retirer 20-30% supplémentaires
  → Bois d'industrie/petit œuvre : revenu moyen (2 000-5 000 €/ha)

ANNÉES 60-150 : COUPE FINALE (RÉCOLTE)
  → Abattage des arbres matures
  → Bois d'œuvre premium : revenu majeur
  → Chêne 120 ans : 15 000-40 000 €/ha
  → Douglas 50 ans : 8 000-15 000 €/ha
  → Peuplier 18 ans : 3 000-6 000 €/ha

POST-RÉCOLTE : RÉGÉNÉRATION
  → Replantation ou régénération naturelle
  → Le cycle recommence
```

### 3.4 Matériel forestier

| Machine | Prix | Usage |
|---------|-----:|-------|
| Tronçonneuse professionnelle | 1 500 € | Abattage manuel (petits volumes) |
| Abatteuse (harvester) | 350 000 € | Abattage mécanisé (gros volumes) |
| Débusqueur (skidder) | 180 000 € | Tirer les grumes vers la route |
| Porteur forestier (forwarder) | 280 000 € | Transport en forêt |
| Broyeur de branches | 45 000 € | Nettoyage post-coupe |

#### Détails techniques du matériel forestier

| Machine | Puissance | Consommation | Débit | Heures de vie | Entretien/an |
|---------|:---------:|:------------:|:-----:|:-------------:|:------------:|
| Abatteuse (harvester) | 220 CV | 25 L/h | 15-25 m³/h | 12 000 h | 8 500 €/an |
| Débusqueur (skidder) | 180 CV | 18 L/h | 12-20 m³/h | 10 000 h | 5 200 €/an |
| Porteur forestier (forwarder) | 200 CV | 20 L/h | 10-18 m³/h (charge 14 t) | 12 000 h | 6 800 €/an |
| Broyeur de branches | 120 CV (entraîné par tracteur) | 15 L/h | 0,8 ha/h | 3 000 h | 2 200 €/an |
| Tronçonneuse professionnelle | — | 1,5 L/h | 2-5 m³/h (manuel) | 2 000 h | 250 €/an |

#### Calcul du temps de travail forestier (ADR-004)

```
COUPE FINALE (futaie de chêne, 150 m³/ha) :

  Avec abatteuse :
    Abattage : 150 m³ ÷ 20 m³/h = 7,5 h
    Débardage (skidder) : 150 m³ ÷ 15 m³/h = 10 h
    Transport interne (porteur) : 150 m³ ÷ 14 m³/h = 10,7 h
    Total : 28,2 h/ha

  Manuel (tronçonneuse + tracteur forestier) :
    Abattage : 150 m³ ÷ 4 m³/h = 37,5 h
    Débardage (tracteur + treuil) : 150 m³ ÷ 5 m³/h = 30 h
    Total : 67,5 h/ha

ÉCLAIRCIE (futaie de douglas 30 ans, 60 m³/ha) :
  Avec abatteuse : 60 ÷ 18 = 3,3 h + débardage 4 h = 7,3 h/ha
  Manuel : 60 ÷ 3 = 20 h + débardage 12 h = 32 h/ha
```

#### Conditions d'utilisation

| Contrainte | Effet |
|-----------|-------|
| Pente > 30% | Abatteuse interdite, débusqueur câble requis (+80 000 €) |
| Sol gelé | Débardage optimal (moins de dégâts au sol) |
| Sol saturé d'eau | Porteur interdit → attendre le gel ou l'été sec |
| Parcelle < 5 ha | Abatteuse non rentable (coût déplacement), préférer ETF |

### 3.5 ETF — Entreprise de Travaux Forestiers

Un joueur vétéran peut devenir **prestataire forestier** pour d'autres joueurs :

| Service | Tarif facturé | Marge nette |
|---------|:-------------:|:-----------:|
| Plantation | 4 000 €/ha | 25% |
| Éclaircie | 2 500 €/ha | 30% |
| Coupe finale + débardage | 3 000-8 000 €/ha | 20-35% |
| Broyage | 1 500 €/ha | 30% |

**Condition** : posséder le matériel + employé qualifié (ou faire soi-même).

### 3.6 Normal vs Expert — Foresterie

| Aspect | Normal | Expert |
|--------|--------|--------|
| Croissance | Automatique, visible sur compteur | Fonction de densité, éclaircie, sol, météo |
| Éclaircie | « Faire une éclaircie ? Oui/Non » | Choix du % à retirer, marquage |
| Qualité bois | Liée à l'essence et l'âge uniquement | + densité, élagage, station forestière |
| Vente | Prix fixe selon essence + âge | Négociation, lots, scieries différentes |

---

## 4. Foie gras — Spécialité française

### 4.1 Intention de design

Le foie gras est une **micro-filière de niche** : peu de joueurs la pratiquent, mais ceux qui le font ont un produit très haut de gamme. C'est une diversification pour joueurs experts en palmipèdes.

### 4.2 Cycle de production

```
ÉLEVAGE PLEIN AIR (12-14 semaines)
  → Canards mulards ou oies
  → Alimentation : herbe + céréales
  → Parcours extérieur obligatoire (100 m²/canard)
  → Coût : 8-12 € par canard élevé

PHASE DE GAVAGE (12-14 jours — canards | 18-21 jours — oies)
  → 2 repas/jour de maïs grain
  → Surveillance quotidienne obligatoire
  → Coût maïs : 3-5 € par canard
  → Mortalité : 2-4% (Normal) | 1-8% selon technique (Expert)

ABATTAGE + TRANSFORMATION
  → Produits obtenus par canard :
```

| Produit | Poids | Prix de vente |
|---------|:-----:|:-------------:|
| Foie gras cru | 500-700 g | 35-50 €/kg |
| Magret | 350-450 g | 18-25 €/kg |
| Confit de cuisses | 400 g | 12-16 €/kg |
| Gésiers confits | 150 g | 15-20 €/kg |
| Graisse de canard | 200 g | 6-8 €/kg |
| Duvet (oie uniquement) | 100 g | 40-60 €/kg |

### 4.3 Économie

| Paramètre | Canard mulard | Oie |
|-----------|:-------------:|:---:|
| Prix du caneton/oison | 5 € | 12 € |
| Coût total élevage + gavage | 18-22 € | 35-45 € |
| Revenu total par animal | 35-50 € | 60-90 € |
| Marge nette | 15-28 € | 25-45 € |
| Lot minimum | 50 | 20 |
| Cycle complet | 16-18 semaines | 20-24 semaines |

### 4.4 Contraintes et sobriété

Le gavage est un sujet sensible. Traitement dans le jeu :

- **Pas de représentation graphique du gavage** — l'action existe mécaniquement (« Lancer la phase de gavage ») mais sans animation ni détail visuel
- **Texte factuel** : « Phase de finition — alimentation renforcée, 14 jours »
- **Label « Élevage traditionnel »** requis : parcours extérieur préalable obligatoire
- **Réglementation in-game** : densité maximale, durée maximale de gavage, contrôles
- **Alternative** : un joueur peut faire du canard « tout venant » sans gavage (magret maigre, pas de foie gras) — moins rentable mais disponible

### 4.5 Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Gavage | « Lancer le gavage » → résultat automatique à J+14 | Suivi quotidien, ajustement ration, tri |
| Mortalité | Fixe 3% | Variable 1-8% selon technique |
| Qualité foie | Aléatoire (fourchette) | Fonction de la ration, durée, souche |
| Transformation | Automatique | Choix de recette (mi-cuit, conserve, frais) |


---

## 5. Concours et prestige

### 5.1 Intention de design

Les concours sont le **moteur de compétition amicale**. Ils donnent un objectif aux joueurs qui ont déjà tout optimisé économiquement : être reconnu comme le meilleur dans une catégorie précise.

**Principe** : les concours donnent du **prestige** (titres, trophées, visibilité), PAS d'avantage économique écrasant. Un prix de concours = une prime ponctuelle + un badge permanent.

### 5.2 Types de concours

#### Concours d'animaux

| Catégorie | Critère | Fréquence |
|-----------|---------|:---------:|
| Meilleure vache laitière (par race) | Production + morphologie | Mensuel |
| Meilleur taureau (index génétique) | IVRAD | Trimestriel |
| Plus beau troupeau (homogénéité) | Écart-type morpho du lot | Semestriel |
| Meilleur éleveur de l'année | Cumul points | Annuel |

**Score concours animal** :
```python
score_concours = genetique * 0.4 + morphologie * 0.3 + etat_sante * 0.2 + presentation * 0.1
# genetique : index de l'animal (0-100)
# morphologie : note composite (0-100)
# etat_sante : NEC, propreté, pas de boiterie (0-100)
# presentation : bonus Expert uniquement (préparation, toilettage) (0-100, fixe 70 en Normal)
```

#### Concours de produits

| Catégorie | Critère | Fréquence |
|-----------|---------|:---------:|
| Meilleur fromage (par type) | Qualité de fabrication + affinage | Trimestriel |
| Meilleur vin (par couleur/AOC) | Note qualité + dégustation | Annuel (après vendanges) |
| Meilleur miel | Pureté + origine florale | Semestriel |
| Meilleur foie gras | Poids + texture + couleur | Annuel (hiver) |

#### Salons agricoles (événements serveur)

| Salon | Quand | Durée | Contenu |
|-------|-------|:-----:|---------|
| Salon de l'Agriculture | Février-Mars | 2 semaines | Tous concours animaux + produits |
| Fête des Vendanges | Octobre | 1 semaine | Concours des vins, dégustations |
| Comice agricole local | Juin | 3 jours | Concours régional, rencontre joueurs |
| Marché de Noël | Décembre | 2 semaines | Vente directe, produits premium |

### 5.3 Récompenses

| Niveau | Récompense | Nature |
|--------|-----------|--------|
| Médaille d'or | Badge permanent + titre | Prestige |
| Médaille d'argent | Badge permanent | Prestige |
| Médaille de bronze | Badge permanent | Prestige |
| Champion de l'année | Titre spécial + hall of fame | Prestige |
| Prime de concours | 500-5 000 € selon catégorie | Économique (modeste) |

**Règle** : la prime de concours ne dépasse JAMAIS 1 semaine de revenus d'un joueur moyen. C'est un bonus symbolique, pas un avantage structurel.

### 5.4 Mockup — Hall of Fame

```
┌─────────────────────────────────────────────────────────────────────┐
│  🏆  HALL OF FAME — Serveur Beauce                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ═══ ÉLEVEUR DE L'ANNÉE 2031 ═══                                    │
│  👑 FermeDuVallon (Jean-Marc)          │ 847 pts │ Prim'Holstein    │
│                                                                     │
│  ─── Meilleure vache laitière ───                                   │
│  🥇 "Harmony" (FermeDuVallon)          │ 12 450 L │ Index 142       │
│  🥈 "Étoile" (LesCèdres)              │ 11 980 L │ Index 138       │
│  🥉 "Perle" (DomaineRouge)            │ 11 720 L │ Index 135       │
│                                                                     │
│  ─── Meilleur vin rouge AOC ───                                     │
│  🥇 "Cuvée du Centenaire 2029" (ChâteauNoir)  │ 94/100 │ Pinot N. │
│  🥈 "Réserve Prestige 2030" (DomaineSoleil)   │ 91/100 │ Cab.Sauv │
│  🥉 "Fût de Chêne 2028" (VignesDorées)        │ 89/100 │ Syrah    │
│                                                                     │
│  ─── Meilleur fromage affiné ───                                    │
│  🥇 "Tomme du Plateau" (FermeDesHauts)  │ 96/100 │ 8 mois affinage │
│  🥈 "Bleu de Campagne" (LaColline)      │ 93/100 │ 6 mois affinage │
│  🥉 "Comté Réserve" (FermeDuVallon)     │ 91/100 │ 12 mois         │
│                                                                     │
│  ─── Records du serveur ───                                         │
│  📊 Record lait/vache/an : 14 200 L (FermeDuVallon, 2030)           │
│  📊 Record rendement blé : 102 q/ha (LesBlésDor, 2031)              │
│  📊 Record vin : 97/100 (ChâteauNoir, millésime 2027)               │
│  📊 Plus grande exploitation : 450 ha (EmpireVert)                   │
│                                                                     │
│  [Historique]  [Par catégorie]  [Mon palmarès]                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.5 Mockup — Écran d'inscription concours

```
┌─────────────────────────────────────────────────────────────────────┐
│  🎪  SALON DE L'AGRICULTURE 2031 — Inscriptions ouvertes            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📅 Du 28 février au 14 mars │ ⏳ Clôture inscriptions : J-12       │
│                                                                     │
│  ┌─── Mes inscriptions ────────────────────────────────────────┐    │
│  │                                                              │    │
│  │  ✅ Concours Prim'Holstein — "Harmony" (n°4231)             │    │
│  │     Catégorie : Meilleure laitière 3e lactation+             │    │
│  │     Condition : ≥ 10 000 L dernière lactation ✓              │    │
│  │     Index génétique : 142 │ NEC : 3.5 │ Santé : ✓           │    │
│  │                                                              │    │
│  │  ✅ Concours Fromager — "Tomme du Plateau" (lot #87)        │    │
│  │     Catégorie : Pâte pressée non cuite                       │    │
│  │     Affinage : 8 mois │ Qualité : 94/100                    │    │
│  │                                                              │    │
│  │  ⬜ Concours Vin Rouge — (aucune inscription)               │    │
│  │     → [Inscrire un vin]                                     │    │
│  │                                                              │    │
│  └──────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─── Catégories disponibles ──────────────────────────────────┐    │
│  │  🐄 Bovins laitiers (4 catégories)      │ 23 inscrits       │    │
│  │  🐄 Bovins allaitants (3 catégories)    │ 15 inscrits       │    │
│  │  🐖 Porcins (2 catégories)             │ 8 inscrits        │    │
│  │  🧀 Fromages (5 catégories)            │ 31 inscrits       │    │
│  │  🍷 Vins (4 catégories)                │ 18 inscrits       │    │
│  │  🍯 Miels (2 catégories)               │ 12 inscrits       │    │
│  └──────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  💰 Frais d'inscription : 200 € par animal │ 100 € par produit     │
│  🏆 Dotation : médailles + primes (500-5 000 €)                    │
│                                                                     │
│  [Règlement complet]  [Voir les autres inscrits]  [Historique]      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 6. Défis et objectifs long terme

### 6.1 Objectifs de collection

| Collection | Objectif | Récompense |
|-----------|----------|-----------|
| Toutes les races bovines | Posséder au moins 1 animal de chaque race | Badge « Collectionneur » |
| Tous les bâtiments | Construire chaque type au moins une fois | Badge « Bâtisseur » |
| Toutes les cultures | Récolter chaque espèce au moins une fois | Badge « Agronome universel » |
| Tous les cépages | Vinifier chaque cépage | Badge « Œnologue » |
| Toutes les essences | Planter chaque essence forestière | Badge « Sylviculteur » |
| Tous les fromages | Produire chaque type de fromage | Badge « Maître fromager » |

### 6.2 Records du serveur

| Record | Mesure | Persistant ? |
|--------|--------|:------------:|
| Rendement blé | q/ha sur une parcelle | Oui (hall of fame) |
| Production laitière | L/vache/lactation | Oui |
| Qualité vin | Note /100 | Oui |
| Trésorerie maximale | € | Oui (snapshot annuel) |
| Plus grand troupeau | Nombre de têtes | Oui |
| Génétique | Index maximal atteint | Oui |

### 6.3 Défis saisonniers du serveur

Chaque saison (3 mois réels), le serveur propose un **défi collectif ou individuel** :

| Saison | Exemple de défi | Récompense |
|--------|----------------|-----------|
| Printemps | « Semez 10 000 ha de colza sur le serveur » (collectif) | Badge saison + bonus cosmétique |
| Été | « Produisez votre meilleur rendement blé » (individuel) | Classement + badge top 10 |
| Automne | « Vendangez et vinifiez au moins 5 ha » (individuel) | Badge vendangeur |
| Hiver | « Aidez 3 nouveaux joueurs à atteindre 50 000 € » (mentorat) | Badge mentor + titre |

### 6.4 Objectifs coopératifs régionaux

| Objectif | Condition | Récompense (toute la région) |
|----------|-----------|------------------------------|
| Autonomie fourragère | 90% des éleveurs de la région sont autonomes | -5% sur les charges fixes pendant 1 mois |
| Bassin laitier | La région produit 10 M litres/mois | Bonus prix du lait +2% pendant 1 mois |
| Biodiversité | 50% des exploitations ont ≥ 3 productions | Badge régional |
| Solidarité | Aucun joueur de la région en difficulté financière | Titre régional |

---

## 7. Mentorat et transmission

### 7.1 Système de parrainage

| Aspect | Détail |
|--------|--------|
| Condition parrain | ≥ 1 an de jeu, trésorerie ≥ 200 000 € |
| Nombre de filleuls max | 3 simultanés |
| Durée du parrainage | 3 mois (renouvelable) |
| Bonus filleul | +10% revenus pendant le parrainage, accès au chat privé avec le parrain |
| Bonus parrain | XP de prestige, badge « Mentor » après 3 parrainages réussis |
| Parrainage réussi | Le filleul atteint 100 000 € de trésorerie |

### 7.2 Transmission d'exploitation

Un joueur qui quitte le jeu (ou veut repartir de zéro) peut **transmettre** son exploitation :

- **Vente à un joueur** : prix négocié, le repreneur récupère terres + bâtiments + animaux
- **Mise en sommeil** : l'exploitation est gelée (pas de charges, pas de production), récupérable plus tard
- **Don à un filleul** : transfert gratuit avec accord des deux parties

**Règle anti-abus** : un joueur ne peut recevoir qu'UNE transmission par an. Pas de multi-comptes déguisés.

### 7.3 Rôles communautaires

| Rôle | Condition | Avantage |
|------|-----------|----------|
| Mentor | 3+ parrainages réussis | Badge, canal mentor, titre |
| Expert régional | Top 5 de sa région depuis 6 mois | Consulté pour les objectifs régionaux |
| Juge de concours | 2+ ans de jeu, 5+ médailles | Peut siéger comme juré (bonus prestige) |
| Ambassadeur | 3+ ans, actif sur le forum, 5+ filleuls | Titre unique, accès au feedback dev |


---

## 8. Monétisation — Modèle éthique

### 8.1 Principes absolus

> **JAMAIS de pay-to-win.** Un joueur gratuit et un joueur payant ont les mêmes mécaniques, les mêmes prix, les mêmes rendements. L'argent réel n'achète PAS d'avantage compétitif.

| Autorisé | Interdit |
|----------|----------|
| Confort (UI, raccourcis) | Bonus de rendement |
| Cosmétique (skins, décorations) | Animaux/machines exclusifs supérieurs |
| Accélération modérée (files d'attente) | Ressources gratuites (argent, stock) |
| Stockage supplémentaire | Accès à des marchés exclusifs |
| Slots de sauvegarde / export | Avantage en concours |

### 8.2 Modèle proposé : AgriPass

Inspiré du SimPass mais modernisé :

| Formule | Prix | Contenu |
|---------|:----:|---------|
| **Gratuit** | 0 € | Jeu complet, toutes les mécaniques, pas de limite de progression |
| **AgriPass** | 4,99 €/mois | Confort + cosmétique (voir ci-dessous) |
| **AgriPass+** | 9,99 €/mois | AgriPass + fonctionnalités sociales premium |

#### Contenu AgriPass (4,99 €/mois)

| Fonctionnalité | Catégorie |
|---------------|-----------|
| Thèmes visuels pour la ferme (5 choix) | Cosmétique |
| Nom personnalisé pour les parcelles | Cosmétique |
| Portraits d'animaux (photo générée) | Cosmétique |
| Statistiques avancées (graphiques, historiques) | Confort |
| Export CSV des données de l'exploitation | Confort |
| File d'attente constructions : -25% durée | Accélération modérée |
| 2 emplacements de sauvegarde de stratégie | Confort |
| Pas de publicité (si pub il y a en gratuit) | Confort |

#### Contenu AgriPass+ (9,99 €/mois)

| Fonctionnalité | Catégorie |
|---------------|-----------|
| Tout AgriPass | — |
| Création de coopérative (gratuit limité à rejoindre) | Social |
| Salon privé (10 joueurs) | Social |
| Organisation de concours privés | Social |
| Badge « Mécène » (soutien visible) | Cosmétique |
| Décoration de ferme (objets cosmétiques) | Cosmétique |
| Accès anticipé aux contenus saisonniers (1 jour avant) | Modéré |

### 8.3 Boutique ponctuelle

| Objet | Prix | Nature |
|-------|:----:|--------|
| Pack de décorations saisonnières | 2,99 € | Cosmétique |
| Nom de domaine viticole personnalisé | 1,99 € | Cosmétique |
| Étiquette de vin personnalisée | 0,99 € | Cosmétique |
| Skin de tracteur (couleur/style) | 1,99 € | Cosmétique |
| Changement de nom d'exploitation | 0,99 € | Confort |

### 8.4 Revenus estimés

| Hypothèse | Valeur |
|-----------|--------|
| Joueurs actifs (après 1 an de lancement) | 5 000 |
| Taux de conversion AgriPass | 8% (400 joueurs) |
| Taux de conversion AgriPass+ | 3% (150 joueurs) |
| Revenu récurrent mensuel | 400 × 4,99 + 150 × 9,99 = **3 495 €/mois** |
| Boutique ponctuelle | ~500 €/mois |
| **Revenu total estimé** | **~4 000 €/mois** |

### 8.5 Ce que la monétisation ne touche PAS

- Les concours (inscription ouverte à tous)
- La viticulture, foresterie, foie gras (contenu jouable par tous)
- Les objectifs de prestige (badges, records, hall of fame)
- Le mentorat
- L'accès aux modes Normal et Expert
- Les mécaniques de jeu fondamentales

### 8.6 Catalogue détaillé des packs et options

#### Packs cosmétiques (achat unique, permanents)

| Pack | Prix | Contenu | Catégorie |
|------|:----:|---------|:---------:|
| Pack « Ferme fleurie » | 3,99 € | 8 décorations florales pour la ferme (massifs, jardinières, portail fleuri) | Cosmétique |
| Pack « Matériel vintage » | 4,99 € | 5 skins de tracteurs anciens (Massey 135, Deutz, Renault 7745…) | Cosmétique |
| Pack « Animaux de compagnie » | 2,99 € | Chat, chien (décoratif), paon — visibles sur la ferme | Cosmétique |
| Pack « Clôtures d'exception » | 2,49 € | 4 styles de clôtures (bois tourné, pierre sèche, fer forgé, haie topiaire) | Cosmétique |
| Pack « Noël à la ferme » | 3,99 € | Décorations saisonnières (sapin, guirlandes, bonhomme de neige) — disponible nov-jan | Cosmétique |
| Pack « Étiquettes artisan » | 1,99 € | 10 modèles d'étiquettes pour fromages et vins | Cosmétique |

#### Options confort (achat unique, permanents)

| Option | Prix | Effet | Catégorie |
|--------|:----:|-------|:---------:|
| Renommer les parcelles | 1,99 € | Noms libres au lieu de « Parcelle #12 » | Confort |
| Carnet de notes intégré | 2,99 € | Bloc-notes privé in-game pour stratégie | Confort |
| Historique étendu (5 ans) | 2,99 € | Graphiques financiers sur 5 ans au lieu de 1 an | Confort |
| Alertes SMS/mail (1 an) | 4,99 € | Notifications hors-jeu pour événements critiques (vêlage, panne, météo) | Confort |
| Mode daltonien amélioré | 0,00 € (gratuit) | Palettes de couleurs alternatives pour toutes les jauges | Accessibilité |

#### Options à durée limitée (abonnement mensuel inclus dans AgriPass)

| Option | Durée | Inclus dans | Effet |
|--------|:-----:|:-----------:|-------|
| File d'attente constructions -25% | Mensuel | AgriPass | Construction plus rapide (confort, pas d'avantage : les productions ne démarrent qu'à la fin) |
| Statistiques avancées | Mensuel | AgriPass | Graphiques, comparatifs, export CSV |
| Portraits d'animaux | Mensuel | AgriPass | Photo générée unique par animal favori |
| 2 emplacements sauvegarde stratégie | Mensuel | AgriPass | Sauvegarder/charger un plan d'assolement |

#### Règles de gestion des packs

| Règle | Valeur |
|-------|--------|
| Activation | Immédiate après achat |
| Expiration (packs) | Aucune — permanent |
| Expiration (options durée limitée) | Fin du mois d'abonnement, désactivation sans perte de données |
| Remboursement | 14 jours après achat si non utilisé |
| Transfert | Non transférable entre comptes |
| Cumul | Tous les packs sont cumulables |
| Visibilité par les autres joueurs | Cosmétiques visibles, confort invisible |

---

## 9. Équilibrage — Le endgame ne creuse pas l'écart

### 9.1 Problème à résoudre

Un joueur de 3 ans avec viticulture + foresterie + 50 médailles ne doit pas **écraser** un joueur de 3 mois sur le marché. Le prestige est la récompense, pas la puissance économique brute.

### 9.2 Mécanismes de plafonnement

| Mécanisme | Effet |
|-----------|-------|
| Rendements décroissants | Au-delà de 200 ha, les charges augmentent (gestion) |
| Prix de marché dynamiques | Si un joueur produit massivement, les prix baissent pour lui |
| Concours = prestige, pas cash | La prime de concours est symbolique |
| Viticulture = capital immobilisé | L'argent est bloqué en stock, pas disponible pour acheter du terrain |
| Foresterie = rendement très différé | Pas de cash-flow, juste un actif qui dort |

### 9.3 Comparaison de revenus nets mensuels

| Profil | Revenu mensuel net | Écart vs débutant |
|--------|:------------------:|:-----------------:|
| Débutant (3 mois, 50 ha cultures) | 8 000 € | ×1 |
| Intermédiaire (1 an, 150 ha + 40 vaches) | 25 000 € | ×3 |
| Vétéran (3 ans, 300 ha + 100 vaches + transfo) | 55 000 € | ×7 |
| Vétéran endgame (+ viticulture 10 ha + forêt) | 65 000 € | ×8 |

**Objectif** : l'écart entre vétéran et vétéran-endgame est faible (×7 → ×8). Le endgame n'est pas un multiplicateur de revenus, c'est une diversification à marge comparable.

### 9.4 Protection des nouveaux

| Protection | Mécanisme |
|-----------|-----------|
| Pas de PvP économique direct | Un vétéran ne peut pas ruiner un débutant |
| Marchés segmentés | Les produits premium (vin, foie gras) ont leur propre marché |
| Parrainage | Les vétérans sont incités à aider, pas à écraser |
| Pas de monopole | Limite de surface par joueur (500 ha max) |
| Rattrapage | Un joueur qui joue bien rattrape en 6-12 mois |

---

## 10. Scénario chiffré — Domaine viticole (10 ha, 8 ans)

### 10.1 Hypothèses

| Paramètre | Valeur |
|-----------|--------|
| Surface | 10 ha |
| Cépage | Pinot Noir |
| Terroir | Calcaire (match parfait) |
| Mode | Expert |
| AOC | Coteaux d'Agriva (bonus +40%) |

### 10.2 Investissement initial (Année 0)

| Poste | Montant |
|-------|--------:|
| Achat terrain viticole (10 ha × 15 000 €) | 150 000 € |
| Plantation (10 ha × 25 000 €) | 250 000 € |
| Cave de vinification | 40 000 € |
| Fûts de chêne (200 pièces × 600 €) | 120 000 € |
| Matériel (pulvérisateur, enjambeur d'occasion) | 80 000 € |
| **TOTAL INVESTISSEMENT** | **640 000 €** |

### 10.3 Charges annuelles

| Poste | Montant/an |
|-------|----------:|
| Main-d'œuvre (taille, traitements, entretien) | 50 000 € |
| Intrants (traitements, engrais) | 12 000 € |
| Bouteilles + packaging (à partir année 3) | 15 000 € |
| Renouvellement fûts (20%/an) | 24 000 € |
| Charges fixes (assurance, taxe foncière) | 8 000 € |
| **TOTAL CHARGES/AN** | **109 000 €** |

### 10.4 Production et revenus par année

```
Année 1 : PAS DE RÉCOLTE (vigne trop jeune)
  Revenus : 0 €
  Bilan cumulé : -749 000 €

Année 2 : PAS DE RÉCOLTE (vigne immature)
  Revenus : 0 €
  Bilan cumulé : -858 000 €

Année 3 : PREMIÈRE VENDANGE (rendement faible : 25 hl/ha)
  Production : 2 500 L = 3 333 bouteilles
  Qualité : 55/100 (vigne jeune, technique en rodage)
  Classification : IGP (pas encore AOC, rendement ok mais qualité insuffisante)
  → Vente immédiate : 3 333 × 7 € = 23 331 €
  Bilan année : 23 331 - 109 000 = -85 669 €
  Bilan cumulé : -943 669 €

Année 4 : MONTÉE EN PUISSANCE (35 hl/ha)
  Production : 3 500 L = 4 666 bouteilles
  Qualité : 65/100 (technique améliorée)
  Classification : IGP
  → Vente : 4 666 × 9 € = 41 994 €
  Bilan année : 41 994 - 109 000 = -67 006 €
  Bilan cumulé : -1 010 675 €

Année 5 : AOC ACCESSIBLE (45 hl/ha, qualité suffisante)
  Production : 4 500 L = 6 000 bouteilles
  Qualité : 75/100 (vigne 5 ans + bonne technique)
  Millésime : moyen (coefficient 0.65)
  Classification : AOC Coteaux d'Agriva
  → Vente (après 12 mois élevage fût) : 6 000 × 15 € = 90 000 €
  Bilan année : 90 000 - 109 000 = -19 000 €
  Bilan cumulé : -1 029 675 €

Année 6 : CROISIÈRE (50 hl/ha plafonné AOC)
  Production : 5 000 L = 6 666 bouteilles
  Qualité : 82/100 (bonne année, millésime 0.80)
  Classification : AOC
  → Vente (18 mois élevage) : 6 666 × 18 € = 119 988 €
  Bilan année : 119 988 - 109 000 = +10 988 €
  Bilan cumulé : -1 018 687 €
  *** PREMIÈRE ANNÉE BÉNÉFICIAIRE ***

Année 7 : MATURITÉ (50 hl/ha)
  Production : 6 666 bouteilles
  Qualité : 88/100 (millésime exceptionnel 0.95 !)
  Classification : AOC, éligible concours
  → Stratégie : garder 50% en cave pour bonification
  → Vente immédiate (3 333 bouteilles × 22 €) : 73 326 €
  → Stock en cave : 3 333 bouteilles (valeur future estimée : 40-60 €)
  Bilan année : 73 326 - 109 000 = -35 674 € (mais actif en cave)
  Bilan cumulé : -1 054 361 € (hors stock)
  Valeur stock en cave : ~133 320 € (à terme)

Année 8 : VENTE DES STOCKS + PRODUCTION COURANTE
  Production courante : 6 666 bouteilles, qualité 80 → vente 18 € = 119 988 €
  Vente stock année 5 (gardé 3 ans, qualité 75, multiplicateur 1.8) :
    2 000 bouteilles × 15 € × 1.8 = 54 000 €
  Total revenus : 173 988 €
  Bilan année (avant charges sociales) : 173 988 - 109 000 = +64 988 €
  Charges sociales (28% Expert) : 64 988 × 0,28 = -18 197 €
  Résultat net année 8 : +46 791 €
  Bilan cumulé : -1 007 570 €
```

### 10.5 Projection de rentabilité

| Année | Revenu | Charges | Bénéf. avant CS | Charges sociales (28%) | Résultat net | Cumulé |
|:-----:|-------:|--------:|----------------:|----------------------:|---------:|-------:|
| 0 | 0 | 640 000 | -640 000 | 0 | -640 000 | -640 000 |
| 1 | 0 | 109 000 | -109 000 | 0 | -109 000 | -749 000 |
| 2 | 0 | 109 000 | -109 000 | 0 | -109 000 | -858 000 |
| 3 | 23 331 | 109 000 | -85 669 | 0 | -85 669 | -943 669 |
| 4 | 41 994 | 109 000 | -67 006 | 0 | -67 006 | -1 010 675 |
| 5 | 90 000 | 109 000 | -19 000 | 0 | -19 000 | -1 029 675 |
| 6 | 119 988 | 109 000 | +10 988 | -3 077 | +7 911 | -1 021 764 |
| 7 | 73 326 | 109 000 | -35 674 | 0 | -35 674 | -1 057 438 |
| 8 | 173 988 | 109 000 | +64 988 | -18 197 | +46 791 | -1 010 647 |
| ... | | | | | | |
| **~14** | **~200 000** | **109 000** | **+91 000** | **-25 480** | **+65 520** | **~0 (seuil de rentabilité)** |

**Retour sur investissement : ~12 ans.** C'est long, c'est du endgame. Mais à partir de l'année 12, le domaine génère 80 000-120 000 € de bénéfice avant charges sociales, soit après charges sociales (28%, ADR-003 Expert) : **57 600-86 400 €/an de résultat net**, avec des pics sur les grands millésimes.

> ⚠️ **Note d'équilibrage** : le résultat net de 57 600-86 400 € dépasse la cible 38-50 k€.
> C'est justifié par un investissement initial colossal (640 000 €), un ROI de 12 ans,
> et le fait que la viticulture est une activité endgame réservée aux joueurs très capitalisés.
> La marge rapportée au capital immobilisé donne un rendement annuel de 9-13%, comparable
> à un placement risqué (aléa météo, millésimes variables).

### 10.6 Conclusion du scénario

La viticulture est **exactement ce qu'il faut pour le endgame** :
- Un joueur doit avoir 640 000 € de capital libre → impossible avant 2 ans de jeu
- Les revenus ne viennent qu'après 5-6 ans → patience requise
- La spéculation sur les millésimes ajoute un jeu dans le jeu
- Le prestige (concours, AOC, grands crus) est la vraie récompense
- Le résultat net après charges sociales (~58 000-86 000 €/an) n'écrase pas les revenus d'un éleveur optimisé (45 000-55 000 €) car le capital immobilisé est énorme

---

## 11. Checklist playtest

| # | Test | Critère de succès | Bloquant ? |
|:-:|------|-------------------|:----------:|
| 1 | Test recette SimAgri | Un joueur SimAgri dit « ça donne envie de rester longtemps » | ✅ Oui |
| 2 | Un vétéran a des choses à faire | Après 2 ans, ≥ 3 activités endgame non terminées | ✅ Oui |
| 3 | Le endgame ne creuse pas l'écart | Ratio revenu vétéran/débutant < ×10 | ✅ Oui |
| 4 | La viticulture est jouable en Normal | Cycle complet possible sans doc externe | ✅ Oui |
| 5 | Les concours motivent | ≥ 30% des joueurs éligibles participent | Non |
| 6 | Le mentorat fonctionne | ≥ 50% des parrainages sont complétés | Non |
| 7 | La monétisation ne frustre pas | Aucun joueur gratuit ne se sent bloqué | ✅ Oui |
| 8 | La foresterie a du sens | Un joueur qui plante attend la coupe avec impatience | Non |
| 9 | Le foie gras n'est pas polémique | Pas de plainte sur le traitement du sujet | Non |
| 10 | Le hall of fame est consulté | ≥ 20% des joueurs consultent le HoF chaque semaine | Non |

---

## Annexe — Récapitulatif Normal vs Expert

| Système | Normal | Expert |
|---------|--------|--------|
| **Viticulture — Taille** | Choix binaire (courte/longue) | Ajustement par parcelle, charge en bourgeons |
| **Viticulture — Traitements** | Bio/conventionnel (1 clic) | Calendrier, produits, doses, météo |
| **Viticulture — Vendanges** | « Vendanger maintenant » | Choix de la date, tri sélectif |
| **Viticulture — Vinification** | Automatique (rouge/blanc/rosé) | Température, durée, levures, assemblage |
| **Viticulture — Élevage** | Cuve ou fût (choix simple) | Type de fût, durée, soutirage, bâtonnage |
| **Foresterie — Croissance** | Compteur automatique | Fonction densité + sol + climat |
| **Foresterie — Éclaircie** | Oui/Non quand proposé | % à retirer, sélection, timing |
| **Foresterie — Vente** | Prix fixe | Négociation, lots, qualité variable |
| **Foie gras — Gavage** | Résultat auto à J+14 | Suivi quotidien, ajustement ration |
| **Foie gras — Qualité** | Aléatoire (fourchette fixe) | Fonction souche + technique + alimentation |
| **Concours — Préparation** | Inscription → résultat | Toilettage, entraînement, présentation |
| **Concours — Jugement** | Score calculé automatiquement | Score + bonus présentation |
| **Monétisation** | Identique | Identique |
| **Mentorat** | Identique | Identique |
| **Défis** | Identique | Identique |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Phase 10 du plan directeur |
| 2026-08-04 | Ajout §2.8 Matériel viticole, §3.4 Matériel forestier détaillé, §8.6 Packs & Options | Audit couverture fonctionnelle — systèmes 6.11, 6.12, 11.2 partiels |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
