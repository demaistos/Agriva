# Réalité de l'économie agricole en France (2024-2026) vs Modèle SimAgri

> **Document de recherche Agriva** — Analyse exhaustive comparant l'économie agricole française actuelle au modèle SimAgri, avec recommandations pour Agriva.
>
> Date : Août 2026
> Sources : Agreste, RICA, MSA, FranceAgriMer, Chambres d'agriculture, Crédit Agricole, SAFER

---

## Table des matières

1. [Marchés et prix agricoles](#1-marchés-et-prix-agricoles)
2. [Coopératives et négoce](#2-coopératives-et-négoce)
3. [Financement et banque](#3-financement-et-banque)
4. [Aides PAC et subventions](#4-aides-pac-et-subventions)
5. [Fiscalité et charges sociales](#5-fiscalité-et-charges-sociales)
6. [Foncier et fermage](#6-foncier-et-fermage)
7. [Main d'œuvre et emploi](#7-main-dœuvre-et-emploi)
8. [Assurances agricoles](#8-assurances-agricoles)
9. [Circuits de commercialisation](#9-circuits-de-commercialisation)
10. [Investissement et rentabilité](#10-investissement-et-rentabilité)
11. [TOP 10 des différences majeures](#11-top-10-des-différences-majeures-réalité-vs-simagri)
12. [TOP 10 des ajouts prioritaires pour Agriva](#12-top-10-des-ajouts-prioritaires-pour-agriva)
13. [Tableau récapitulatif](#13-tableau-récapitulatif)

---

## 1. Marchés et prix agricoles

### 1.1 RÉALITÉ terrain 2024 (France)

#### Organisation des marchés agricoles

**Marchés physiques (cotations de référence) :**
| Marché | Produit | Fréquence | Référence |
|--------|---------|:---------:|-----------|
| Euronext Paris (Matif) | Blé meunier, maïs, colza | Continue (bourse) | Internationale |
| Cadran de Plérin | Porc (MPB) | Hebdomadaire | Nationale |
| Rungis | Viande bovine, ovine, fruits, légumes | Quotidienne | Nationale |
| Atla / CNIEL | Lait (indicateurs) | Mensuelle | Nationale |
| FranceAgriMer | Toutes productions (cotations officielles) | Hebdo/mensuelle | Officielle |

**Facteurs de prix :**
- **Offre mondiale** : production grandes zones (USA, Brésil, Ukraine, Australie)
- **Demande** : Chine, Moyen-Orient, Afrique du Nord
- **Géopolitique** : guerre Ukraine (+80% blé en 2022), embargos
- **Météo** : sécheresse, inondations → rendements → prix
- **Stocks mondiaux** : ratio stock/consommation = indicateur n°1
- **Spéculation financière** : fonds sur Euronext, volatilité amplifiée
- **Taux de change** : €/$ (export européen)

#### Prix des grandes cultures 2024 (France, départ ferme)

| Culture | Prix 2024 (€/t) | Min 5 ans | Max 5 ans | Volatilité |
|---------|:---------------:|:---------:|:---------:|:----------:|
| Blé meunier | 200-240 | 160 (2020) | 380 (2022) | ±40% |
| Orge fourragère | 180-210 | 140 | 330 | ±40% |
| Maïs grain | 180-220 | 150 | 350 | ±35% |
| Colza | 430-500 | 360 | 830 | ±50% |
| Tournesol | 380-440 | 300 | 700 | ±45% |
| Pois protéagineux | 250-300 | 200 | 380 | ±30% |
| Betterave (prix contrat) | 30-35 €/t | 25 | 40 | ±20% |
| PDT (contrat) | 120-180 €/t | 80 | 300 | ±60% |
| PDT (libre) | 50-400 €/t | 30 | 500+ | Extrême |

#### Prix des productions animales 2024

| Produit | Prix 2024 | Volatilité |
|---------|:---------:|:----------:|
| Lait vache (conv.) | 410-450 €/1000L | ±25% (cycle 3-4 ans) |
| Lait vache (bio) | 500-540 €/1000L | ±15% |
| Porc (carcasse, MPB) | 1,60-1,90 €/kg | ±30% (cycle 3-4 ans) |
| JB viande (R+) | 4,80-5,50 €/kg carc. | ±15% |
| Agneau | 7,00-8,50 €/kg carc. | ±20% (saisonnier) |
| Poulet standard | 0,90-1,10 €/kg vif | ±20% |
| Œuf (plein-air) | 0,15-0,22 €/unité | ±30% |

#### Mécanismes de fixation des prix

**Contrats :**
- **Prix fixe** : acheteur et vendeur s'engagent sur un prix (avant récolte)
- **Prix indexé** : formule automatique (ex : Euronext + prime régionale)
- **Prix spot** : au jour le jour (le plus risqué)
- **Prime qualité** : protéines, poids spécifique, humidité, teneur huile

**Saisonnalité :**
- Blé : prix bas à la moisson (juillet), remonte en hiver/printemps (+10-30€/t)
- Agneau : pic à Pâques (+20%), creux en été
- Porc : cycle pluriannuel 3-4 ans

#### Volatilité historique

La volatilité est LE risque économique de l'agriculteur :
- **Blé** : entre 160 et 380 €/t sur 5 ans (×2,4)
- **Colza** : entre 360 et 830 €/t sur 5 ans (×2,3)
- **Porc** : entre 1,20 et 2,10 €/kg sur 5 ans (×1,75)
- **PDT libre** : entre 30 et 500+ €/t (×15+ ! le plus volatile)

### 1.2 Modèle SimAgri

- **Prix de base** par produit (table `market_prices`)
- **Tick hebdomadaire** : offre/demande du serveur → variation ±15% max
- **Plafond** : prix entre 50% et 200% du prix de base
- **Bio** : +20% automatique sur tous les produits
- **Qualité** : 3 niveaux influencent le prix de vente
- **Prix coopérative** : prix de base + 15% de marge
- **Historique** : table `price_history` consultable
- **Pas de cotation externe** (pas d'Euronext, pas de marché mondial)

### 1.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Amplitude variation | ±40-60% sur 5 ans | ±15% / tick, plafond ×2 | Moyen (acceptable) |
| Saisonnalité | Forte (blé moisson, agneau Pâques) | Non modélisée | Fort |
| Cycles pluriannuels | Oui (porc 3-4 ans, lait) | Non | Fort |
| Géopolitique/macro | Impact massif (guerre, embargo) | Absent | Moyen |
| Contrats/fixation anticipée | 60% des ventes en contrat | Absent | Fort |
| Qualité → prix | Primes continues (protéines, huile) | 3 niveaux discrets | Acceptable |
| Offre/demande locale | Via le serveur (joueurs) | Oui ✅ | Correct |
| Bio = premium | +20-50% selon produit | +20% fixe | Simplifié OK |

### 1.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Garder** le tick offre/demande (bon mécanisme)
- **Saisonnalité** : courbe sinusoïdale (bas à la récolte, haut en contre-saison)
- **Amplitude** : élargir à ±30% pour plus de tension
- **Qualité** : garder 3 niveaux avec impact prix

#### Priorité 2 (V2)
- **Contrats** : vente anticipée à prix garanti (avant récolte, engagement de livraison)
- **Cycles pluriannuels** : tendance de fond (hausse/baisse sur 2-3 saisons)
- **Stockage spéculatif** : le joueur peut stocker et vendre plus tard (déjà possible mais rendre explicite)

#### Priorité 3 (V3)
- **Événements macro** : crise, sécheresse mondiale, embargo = choc de prix
- **Euronext simulé** : prix de référence visible pour le joueur
- **Primes qualité** : continues (pas seulement 3 niveaux)

---

## 2. Coopératives et négoce

### 2.1 RÉALITÉ terrain 2024 (France)

#### Organisation de la collecte

- **2 200 coopératives agricoles** en France (2024)
- **75% des céréales** collectées par les coopératives (le reste = négoce privé)
- **40% du lait** collecté par les coopératives (Sodiaal, Agrial, etc.)
- **Chiffre d'affaires coopératif** : 90 milliards €/an (1er réseau mondial)

**Principales coopératives françaises :**
| Coopérative | Filière | CA (Mrd€) | Membres |
|-------------|---------|:---------:|:-------:|
| InVivo | Céréales, distribution | 12 | 200 coops |
| Sodiaal | Lait | 5,5 | 17 000 |
| Agrial | Polyvalent (lait, légumes, viande) | 7 | 12 000 |
| Terrena | Polyvalent | 5 | 22 000 |
| Euralis | Sud-Ouest, maïs, foie gras | 1,5 | 12 000 |
| Vivescia | Céréales Nord-Est | 4 | 10 000 |
| Axéréal | Céréales Centre | 4 | 13 000 |

#### Fonctionnement coopératif

**Principes :**
- **Adhésion** : l'agriculteur est sociétaire (parts sociales)
- **Engagement** : obligation d'apporter X% de sa production (apport total/partiel)
- **Rémunération** : prix de base + compléments (ristournes en fin d'exercice)
- **Gouvernance** : 1 homme = 1 voix (pas proportionnel au capital)
- **Acompte + solde** : le coopérateur reçoit un acompte à la livraison, puis le solde 6-12 mois après

**Services offerts :**
- Collecte et stockage (silos de zone)
- Vente groupée (meilleur pouvoir de négociation)
- Approvisionnement (semences, engrais, phytos à tarif négocié)
- Conseil technique (agronomes, techniciens)
- Financement (avance de trésorerie)

#### Négoce privé

- **25% des céréales** en négoce (Bunge, Cargill, Louis Dreyfus, Soufflet/InVivo)
- **Avantages** : prix parfois meilleur, pas d'engagement, paiement rapide
- **Inconvénients** : pas de services, pas de ristourne, pas de gouvernance

#### Prix coopérative vs négoce vs marché

| Canal | Prix typique (blé, €/t) | Délai paiement | Engagement |
|-------|:----------------------:|:--------------:|:----------:|
| Coopérative (acompte) | 190-210 | Immédiat (80%) | Oui |
| Coopérative (solde final) | +10-30 | 6-12 mois | Oui |
| Négoce privé | 200-230 | 30 jours | Non |
| Vente directe Euronext | 210-240 | J+2 | Non |
| Stockage ferme + vente différée | Variable (±30%) | Variable | Non |

#### Approvisionnement (achats)

| Poste | Canal dominant | Part coopérative |
|-------|:-------------:|:----------------:|
| Semences | Coopérative + sélectionneurs | 70% |
| Engrais | Coopérative + négoce | 65% |
| Phytosanitaires | Coopérative + négoce | 60% |
| Aliments animaux | Coopérative | 55% |
| Matériel | Concessionnaire (pas coopérative) | 5% |

### 2.2 Modèle SimAgri

- **Coopérative SimAgri** : canal d'achat/vente PNJ (stock illimité, prix fixe +15%)
- **CAR (Coopérative Agricole Régionale)** : structure joueur multi-associés
  - Parts sociales, emprunts, sous-activités
  - Magasin libre-service (vente aux joueurs)
  - Contrats parcelles
  - HVC (bio-carburant)
  - Huilerie, sucrerie, laiterie, méthanisation
- **Marché entre joueurs** : annonces, prix libre, commission 5%
- **Marché privé (B2B)** : entre 2 joueurs, commission 2%
- **Grossistes** : achat animaux (quotas mensuels)

### 2.3 Ce qui est CORRECT

- ✅ Coopérative comme canal principal (prix supérieur, stock garanti)
- ✅ CAR comme structure multi-joueurs (approche coopérative réelle)
- ✅ Marché entre joueurs (négoce libre = dynamique)
- ✅ Commission sur les ventes (réaliste)
- ✅ Contrats parcelles (engagement d'apport = mécanisme coopératif)
- ✅ HVC via CAR (la coopérative fournit l'énergie = analogue au GNR distribué par les coops)

### 2.4 Ce qui est FAUX ou MANQUANT

| Élément | Problème | Impact gameplay |
|---------|----------|----------------|
| **Prix fixe coopérative** | En réalité : acompte + complément variable en fin d'année | Pas de notion de "performance coopérative" |
| **Stock illimité** | En réalité : la coopérative peut refuser (capacités de stockage limitées) | Pas de contrainte de collecte |
| **Pas de ristourne** | En réalité : 5-20 €/t de ristourne en fin d'exercice | Manque un revenu différé |
| **Pas d'approvisionnement groupé** | La coopérative = aussi achats d'intrants à prix réduit | Manque un avantage économique |
| **Pas d'engagement d'apport** | En réalité : obligation de livrer X% à la coopérative | Manque une contrainte stratégique |
| **+15% marge** | En réalité : la coop est MOINS chère en achat (achats groupés) | Inversé pour les intrants (la coop négocie des remises) |

### 2.5 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Coopérative = achat et vente** : prix de référence (pas le meilleur ni le pire)
- **Négoce** : alternative libre (prix variable, pas d'engagement)
- **Commission** : garder le principe (5% marché libre, 2% B2B)

#### Priorité 2 (V2)
- **Engagement d'apport** : livrer X% à la coopérative = contrepartie des services
- **Ristourne** : complément de prix en fin de saison selon résultats coop
- **Achats groupés** : intrants moins chers via la coopérative (-5-15%)
- **Acompte + solde** : paiement partiel immédiat, reste en fin de campagne

#### Priorité 3 (V3)
- **Performance de la coopérative** : bonne gestion collective = meilleurs prix pour tous
- **Capacité de stockage coop** : limitée (premier arrivé = stocké, les autres en dégradé)
- **Gouvernance** : vote des sociétaires sur les décisions de la coop


---

## 3. Financement et banque

### 3.1 RÉALITÉ terrain 2024 (France)

#### Structure de l'endettement agricole

- **Encours de prêts agricoles** : 55 milliards € (2024)
- **Endettement moyen par exploitation** : 200 000-350 000 € (très variable selon filière)
- **Taux d'endettement** : 40-60% du bilan en grandes cultures, 50-70% en élevage
- **Durée moyenne des prêts** : 12-15 ans (investissement), 1-3 ans (court terme)

**Endettement par filière :**
| Filière | Endettement moyen | Capital total |
|---------|:-----------------:|:------------:|
| Grandes cultures (200 ha) | 250 000-400 000 € | 600 000-1 200 000 € |
| Bovin laitier (80 vaches) | 300 000-500 000 € | 500 000-900 000 € |
| Bovin allaitant | 150 000-300 000 € | 400 000-700 000 € |
| Porc (200 truies NE) | 500 000-900 000 € | 1 000 000-1 800 000 € |
| Volaille (2 bâtiments) | 300 000-600 000 € | 500 000-900 000 € |
| Caprin fromager | 150 000-350 000 € | 300 000-600 000 € |

#### Banques agricoles

| Banque | Part de marché agricole | Spécificité |
|--------|:-----------------------:|-------------|
| Crédit Agricole | 70-75% | Historique, mutualiste, spécialisé |
| Crédit Mutuel | 10-12% | Mutualiste, régions Est |
| Banque Populaire/BPCE | 5-8% | Zones urbaines périphériques |
| BNP Paribas | 3-5% | Grandes exploitations |
| Autres | 5% | Banques en ligne, BPI France |

#### Types de financement

| Type | Durée | Taux 2024 | Usage |
|------|:-----:|:---------:|-------|
| Prêt long terme (investissement) | 10-20 ans | 3,5-5,0% | Bâtiments, foncier |
| Prêt moyen terme | 5-10 ans | 3,5-4,5% | Matériel |
| Prêt court terme (campagne) | 1-12 mois | 4,0-5,5% | Trésorerie, intrants |
| Crédit-bail (leasing) | 3-7 ans | 4,0-5,5% | Matériel (pas propriétaire) |
| Prêt JA (Jeune Agriculteur) | 12-15 ans | 1,0-2,0% (bonif.) | Installation (<40 ans) |
| Prêt BPI France | 5-15 ans | 2,5-4,0% | Innovation, diversification |
| Découvert autorisé | Permanent | 6-10% | Trésorerie saisonnière |

#### Trésorerie et cycle de cash

**Le problème fondamental** : l'agriculteur investit en automne (semences, engrais) et ne vend qu'à la moisson suivante (12 mois plus tard). Le besoin en fonds de roulement est structurel.

```
Sept-Nov : Achat semences + engrais (200-400 €/ha) → SORTIE
Dec-Fév : Peu de dépenses
Mars-Mai : Engrais azotés + phytos (150-250 €/ha) → SORTIE
Juin : Attente
Juillet-Août : Récolte + vente → ENTRÉE (800-1600 €/ha)
```

- **BFR moyen** : 50 000-150 000 € (grandes cultures, 150-300 ha)
- **Pic de trésorerie négative** : mai-juin (avant moisson)
- **Crédit de campagne** : financement spécifique pour couvrir ce creux

#### Épargne et placements

- **DPA (Déduction Pour Aléas)** : épargne défiscalisée (plafond 27 000 €/an), utilisable en cas de coup dur
- **DEP (Déduction Pour Épargne de Précaution)** : remplace la DPA depuis 2019, plafond 150 000 € cumulé
- **Livret A** : épargne de précaution classique
- **GFA (Groupement Foncier Agricole)** : investissement foncier collectif
- **Taux d'épargne agriculteurs** : 10-20% du revenu (inférieur à la moyenne nationale)

### 3.2 Modèle SimAgri

- **Solde initial** : 100 000 € à l'inscription
- **Emprunts** : via la CAR (Coopérative Agricole Régionale)
  - Montant, taux d'intérêt, durée
  - Remboursement mensuel automatique (tick)
- **Épargne** : compte épargne séparé (balance vs savings)
- **Log financier** : historique de toutes les transactions (recettes, dépenses, salaires, électricité)
- **Charges automatiques** : salaires employés, électricité (0,08€/kWh), remboursements
- **Pas de découvert** : si solde insuffisant → action impossible
- **Pas de crédit de campagne** : pas de financement saisonnier

### 3.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Solde initial | Variable (installation : 50-200 k€ d'apport) | 100 000 € fixe | Acceptable |
| Emprunts | Taux 3-5%, durée 5-20 ans | Via CAR (taux variable) | Correct |
| Remboursement | Mensuel ou trimestriel | Mensuel automatique | ✅ Correct |
| Crédit-bail | 30-40% des achats matériel | Absent | Moyen |
| Trésorerie saisonnière | BFR = problème fondamental | Pas modélisé | Fort |
| Épargne | DEP, placements | Compte épargne simple | Simplifié OK |
| Découvert | Autorisé (coûteux) | Interdit (solde ≥ 0 toujours) | Fort |
| Taux d'intérêt | Fixe ou variable, selon marché | Non précisé | Moyen |
| Investisseurs extérieurs | GFA, portage foncier | Absent | Faible |
| Prêt JA bonifié | 1-2% pour les jeunes | Absent | Moyen |

### 3.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Emprunts** : taux fixe, durée 5-20 ans, remboursement automatique (garder SimAgri)
- **Solde initial** : paramétrable selon difficulté (50k, 100k, 200k)
- **Pas de découvert** : si solde = 0, action bloquée (garde-fou gameplay = bon)
- **Log financier** : historique détaillé (existant SimAgri = excellent)

#### Priorité 2 (V2)
- **Crédit de campagne** : prêt court terme pour couvrir le BFR (printemps → moisson)
- **Crédit-bail** : option matériel (pas de capital, mensualités + restitution en fin)
- **Trésorerie** : afficher le flux de cash prévisionnels (entrées/sorties prochains mois)
- **Taux variable** : selon la durée et le montant (plus risqué = plus cher)

#### Priorité 3 (V3)
- **DEP** : épargne de précaution défiscalisée (réserve pour les mauvaises années)
- **Prêt JA** : bonus pour nouveaux joueurs (taux réduit les 5 premières saisons)
- **Refus de prêt** : si endettement > seuil → la banque refuse
- **Faillite** : si insolvable → game over ou restructuration


---

## 4. Aides PAC et subventions

### 4.1 RÉALITÉ terrain 2024 (France)

#### La PAC en chiffres

- **Budget PAC France** : 9,5 milliards €/an (2023-2027)
- **Nombre de bénéficiaires** : 380 000 exploitations
- **Aide moyenne** : 25 000 €/exploitation/an
- **Part dans le revenu** : 15-60% selon filière (moyenne 30%)
- **1er pilier (paiements directs)** : 7,3 Mrd€/an
- **2nd pilier (développement rural)** : 2,2 Mrd€/an

#### Structure des aides — 1er pilier (paiements directs)

| Aide | Montant 2024 | Conditions | Bénéficiaires |
|------|:------------:|-----------|:-------------:|
| **DPB** (Droit à Paiement de Base) | 120-180 €/ha | Activité agricole, conditionnalité | Tous |
| **Paiement redistributif** (52 premiers ha) | 48-52 €/ha | <52 ha seulement | Petites/moyennes |
| **Éco-régime** | 60-82 €/ha | Niveau 1 (standard) ou 2 (supérieur) | Tous (98%) |
| **Paiement JA** | +50% DPB pendant 5 ans | <40 ans, diplôme | Jeunes agriculteurs |

**Éco-régime (nouveau 2023) :**
- **Voie des pratiques** : diversification rotation, maintien prairies permanentes, couverture sols
- **Voie certification** : HVE (Haute Valeur Environnementale) ou Agriculture Bio
- **Voie éléments favorables** : haies, arbres, mares (10% de surfaces non-productives)
- Niveau standard (60 €/ha) vs supérieur (82 €/ha)

#### Aides couplées (à la production)

| Aide | Montant | Conditions |
|------|:-------:|-----------|
| Aide bovine allaitante | 100-160 €/vache | Minimum 10 vaches, race allaitante |
| Aide bovine laitière | 30-40 €/vache | Petites exploitations (<40 vaches) |
| Aide ovine | 20-25 €/brebis | Minimum 50 brebis |
| Aide caprine | 15-18 €/chèvre | Minimum 25 chèvres |
| Aide protéines végétales | 100-150 €/ha | Pois, féverole, luzerne, soja |
| Aide blé dur | 50-70 €/ha | Zones traditionnelles (Sud) |

#### 2nd pilier — Développement rural

| Aide | Montant | Durée |
|------|:-------:|:-----:|
| **ICHN** (zones défavorisées) | 70-250 €/ha | Annuel |
| **MAEC** (agri-environnement) | 50-450 €/ha | 5 ans |
| **Aide à la conversion bio** | 200-900 €/ha | 5 ans |
| **Aide au maintien bio** | 0-160 €/ha (variable) | Annuel |
| **DJA** (Dotation Jeune Agriculteur) | 10 000-50 000 € (unique) | Installation |
| **Investissement (PCAE)** | 20-40% subvention | Par projet |

#### Impact des aides par filière

| Filière | Aides PAC/an | % du revenu |
|---------|:----------:|:-----------:|
| Grandes cultures (200 ha) | 50 000-80 000 € | 40-60% |
| Bovin allaitant (100 vaches, 150 ha) | 60 000-100 000 € | 50-70% |
| Bovin laitier (80 vaches, 100 ha) | 30 000-50 000 € | 20-35% |
| Ovin viande (500 brebis, 100 ha) | 35 000-55 000 € | 40-60% |
| Porc/Volaille (hors-sol) | 5 000-15 000 € | 5-15% |
| Caprin (300 chèvres, 50 ha) | 15 000-25 000 € | 15-25% |

#### Conditionnalité (obligations)

Les aides PAC sont conditionnées au respect de règles :
- **BCAE 1-9** (Bonnes Conditions Agricoles et Environnementales)
  - Bandes tampon 5m le long des cours d'eau
  - 4% de surfaces non-productives (jachère, haies)
  - Couverture des sols en interculture
  - Rotation minimum (pas de monoculture)
  - Maintien des prairies permanentes
- **Contrôles** : 5% des exploitations/an (PAC, MSA)
- **Sanctions** : réduction 1-5% des aides si non-conformité

### 4.2 Modèle SimAgri

- **Aucune aide PAC**
- **Aucune subvention**
- **Aucune conditionnalité**
- Le revenu agricole dans SimAgri repose uniquement sur la vente des productions

### 4.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Existence des aides | 9,5 Mrd€/an, 15-60% du revenu | 0 | **Très fort** |
| Impact sur l'équilibre des filières | Bovin allaitant/ovin = non-viables sans aides | Filières déséquilibrées sans savoir pourquoi | **Critique** |
| Conditionnalité | Contraintes environnementales | Aucune | Fort |
| Installation JA | DJA + prêts bonifiés | Pas de parcours d'installation | Moyen |
| Bio | Aides conversion 200-900€/ha | +20% prix seulement | Fort |
| ICHN montagne | 70-250 €/ha | Pas de zones défavorisées | Moyen |

### 4.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **DPB simplifié** : aide annuelle fixe par hectare (~150 €/ha)
- **Aide couplée animale** : €/tête pour ovins et bovins allaitants (rend ces filières viables)
- **Conditionnalité minimale** : rotation obligatoire + couverture sols (déjà dans le gameplay)

#### Priorité 2 (V2)
- **Éco-régime** : bonus €/ha si pratiques vertueuses (haies, rotation diversifiée, prairies)
- **Aide bio** : subvention conversion (5 ans) + maintien
- **ICHN** : bonus pour zones difficiles (montagne, piémont)
- **Paiement redistributif** : bonus sur les 52 premiers ha (favorise les petits)

#### Priorité 3 (V3)
- **DJA** : dotation unique à l'installation (parcours JA)
- **PCAE** : subvention d'investissement (20-40% du montant)
- **Contrôles** : risque d'audit → pénalité si non-conforme
- **Plafonnement** : les aides sont plafonnées → pas d'avantage infini à agrandir


---

## 5. Fiscalité et charges sociales

### 5.1 RÉALITÉ terrain 2024 (France)

#### Régimes fiscaux agricoles

| Régime | Seuil CA | Principe | Part des exploitations |
|--------|:--------:|---------|:---------------------:|
| Micro-BA | <91 900 €/an | Forfait (87% du CA = charges) | 20% |
| Réel simplifié | 91 900-391 000 € | Comptabilité simplifiée | 50% |
| Réel normal | >391 000 € | Comptabilité complète | 30% |

#### Impôt sur le revenu (bénéfices agricoles)

- **Barème IR progressif** : 0-45% selon tranches (comme tout contribuable)
- **Abattement JA** : 50% pendant 5 ans (puis 100% la 1ère année)
- **DEP** : déduction épargne de précaution (lisse le revenu entre bonnes et mauvaises années)
- **Moyenne triennale** : option d'imposition sur la moyenne de 3 ans (lissage)
- **Résultat moyen imposable** : 25 000-50 000 € → IR = 5 000-15 000 €/an

#### Cotisations sociales MSA

| Poste | Taux | Assiette | Montant moyen/an |
|-------|:----:|----------|:----------------:|
| Maladie (AMEXA) | 6,5% | Revenu professionnel | 2 000-4 000 € |
| Retraite de base (AVA) | 14,1% | Revenu (plafond SS) | 4 000-6 000 € |
| Retraite complémentaire (RCO) | 4,0% | Revenu | 1 000-2 500 € |
| Allocations familiales | 3,1-5,25% | Revenu | 1 000-2 500 € |
| CSG/CRDS | 9,7% | Revenu + aides PAC | 3 000-6 000 € |
| Formation, accident du travail | 1-2% | Revenu | 500-1 000 € |
| **Total MSA** | **~40-45%** | **Revenu professionnel** | **12 000-22 000 €** |

- **MSA** = Mutualité Sociale Agricole (sécu des agriculteurs)
- **Cotisation minimale** : ~4 000 €/an même si revenu nul (protection plancher)
- **Assiette** : revenu N-1 (décalage problématique en cas de mauvaise année)

#### TVA agricole

- **Régime forfaitaire** : remboursement forfaitaire 5,59% du CA (petits exploitants)
- **Régime réel** : TVA classique (déductible sur achats, collectée sur ventes)
- **TVA réduite** : 5,5% sur aliments animaux, 10% sur bois, 20% sur matériel
- **Pas de TVA sur les ventes de céréales** à la coopérative (autoliquidation)

#### Taxe foncière

- **TFNB (Taxe Foncière sur les propriétés Non Bâties)** : 30-80 €/ha selon commune
- **Exonération partielle** : terres agricoles exonérées à 20% de la part communale
- **TFPB** : sur les bâtiments d'exploitation (modérée)

#### Charge fiscale totale

| Revenu agricole | IR | MSA | Taxe foncière | **Total** | **% du revenu** |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 20 000 € | 1 000 | 9 000 | 3 000 | **13 000** | **65%** |
| 35 000 € | 4 000 | 14 000 | 3 000 | **21 000** | **60%** |
| 50 000 € | 8 000 | 20 000 | 3 000 | **31 000** | **62%** |
| 80 000 € | 18 000 | 30 000 | 4 000 | **52 000** | **65%** |

> Les charges sociales MSA représentent la charge la plus lourde (40-45% du revenu). C'est le poste que les agriculteurs ressentent le plus durement.

### 5.2 Modèle SimAgri

- **Taxe plus-value** : sur la revente de parcelles (90% → 50% selon durée de détention)
- **Pas d'IR** : le joueur garde 100% de ses bénéfices
- **Pas de MSA** : pas de cotisations sociales
- **Pas de TVA** : pas de mécanisme de TVA
- **Pas de taxe foncière** : pas de charge annuelle sur les terres
- **Facture électricité** : seule charge fixe automatique (0,08€/kWh)

### 5.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Charges sociales | 40-45% du revenu (MSA) | 0% | **Très fort** |
| Impôt sur le revenu | 5-25% selon tranche | 0% | Fort |
| Taxe foncière | 30-80 €/ha/an | 0€ | Moyen |
| TVA | Mécanisme complexe (collecte/déduction) | Absente | Acceptable (pas fun en jeu) |
| Taxe plus-value | Sur cession foncier | Oui ✅ (modélisée) | Correct |
| Charge totale | 55-65% du revenu brut | ~5% (électricité seulement) | **Critique** |

### 5.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Charges sociales forfaitaires** : % du revenu prélevé automatiquement (ex: 25-35%)
  - Simplifié par rapport au réel (pas 40-45% pour garder le fun)
  - Mais suffisant pour que le joueur ressente le poids des charges
- **Garder** la taxe plus-value sur parcelles (bon mécanisme anti-spéculation)

#### Priorité 2 (V2)
- **Cotisation minimum** : même en année déficitaire, un plancher est dû
- **Taxe foncière** : charge annuelle par ha possédé (encourage le fermage vs propriété)
- **Déductions** : investissement productif = réduction de charges (incitation)

#### Priorité 3 (V3)
- **DEP** : lissage inter-annuel (épargner les bonnes années pour les mauvaises)
- **Abattement JA** : réduction charges les 5 premières saisons
- **Progressivité** : taux de charges augmente avec le revenu (réalisme)

---

## 6. Foncier et fermage

### 6.1 RÉALITÉ terrain 2024 (France)

#### Prix des terres agricoles

| Zone | Prix moyen/ha (2024) | Évolution 5 ans |
|------|:--------------------:|:---------------:|
| Grandes cultures (Beauce, Picardie) | 8 000-12 000 €/ha | +3-5%/an |
| Polyculture-élevage (Ouest) | 5 000-8 000 €/ha | +2-4%/an |
| Élevage montagne | 2 000-5 000 €/ha | +1-3%/an |
| Vigne AOC (Champagne) | 1 000 000-2 000 000 €/ha | Variable |
| Vigne AOC (Bordeaux GCC) | 300 000-3 000 000 €/ha | Variable |
| Moyenne nationale | 6 200 €/ha | +3,2%/an |

- **Prix France 2024** : moyenne 6 200 €/ha (terres et prés libres)
- **Régulation SAFER** : droit de préemption, empêche spéculation, protège agriculteurs
- **Contrôle des structures** : autorisation préfectorale si surface > seuil départemental
- **Rareté** : moins de 1% du foncier agricole change de main chaque année

#### Fermage

- **60% des terres agricoles** en France sont en fermage (location)
- **Bail rural** : 9 ans minimum (renouvelable), très protecteur pour le fermier
- **Loyer de fermage** : fixé par arrêté préfectoral (indices départementaux)

| Zone | Loyer fermage/ha/an | Indice national |
|------|:-------------------:|:---------------:|
| Grandes cultures (Beauce) | 200-350 €/ha | Indice + revanche |
| Polyculture-élevage | 120-200 €/ha | Indice |
| Prairie/montagne | 50-120 €/ha | Indice |
| **Moyenne nationale** | **150-180 €/ha** | Indexé sur prix agricoles |

- **Révision** : indexée sur les résultats agricoles (lissage)
- **Avantage** : pas de capital immobilisé (vs 6 000-12 000 €/ha en achat)
- **Inconvénient** : pas de patrimoine, pas de plus-value à terme

#### SAFER (Société d'Aménagement Foncier)

- **Rôle** : régulation du marché foncier, installation jeunes, empêcher la concentration
- **Droit de préemption** : peut acheter à la place de n'importe quel acquéreur
- **Stock SAFER** : acquisition, portage (1-5 ans), revente à des agriculteurs installés ou JA
- **Priorité** : JA > agrandissement > investisseurs non-agricoles

### 6.2 Modèle SimAgri

- **Parcelles** : achat/vente à prix fixe (3 000-7 000 €/ha selon pays)
- **Organisme Partcel** : vente de parcelles nouvelles (stock serveur)
- **Vente à SimAgri** : rachat à 25% du prix estimé (liquidation, 5 saisons minimum)
- **Taxe plus-value** : 50-90% de la plus-value (dégressif avec la durée)
- **Pas de fermage** : le joueur est toujours propriétaire
- **Parcelle bio** : +50% du prix standard
- **Taille** : variable selon serveur (jusqu'à 200 ha en Amérique du Nord)

### 6.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Prix/ha | 2 000-12 000 €/ha (France) | 3 000 €/ha (France fixe) | Sous-évalué |
| Fermage | 60% des terres (150-350 €/ha/an) | Absent | **Fort** |
| SAFER | Régulation, préemption | Absent (Partcel ≠ SAFER) | Moyen |
| Bail rural | 9 ans minimum, protecteur | Absent | Fort |
| Plus-value | Taxée (réel + JV) | Taxée ✅ | Correct |
| Marché libre | Très régulé (SAFER, contrôle structures) | Libre entre joueurs | Simplifié OK |
| Rareté | <1% change de main/an | Illimité (Partcel) | Fort |

### 6.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Prix réaliste** : 5 000-10 000 €/ha selon zone (pas 3 000€)
- **Achat** : capital immobilisé lourd (investissement majeur)
- **Taxe plus-value** : garder le mécanisme SimAgri (anti-spéculation = bon)

#### Priorité 2 (V2)
- **Fermage** : louer des terres (150-300 €/ha/an) au lieu d'acheter
  - Avantage : pas de capital, charge annuelle faible
  - Inconvénient : pas de patrimoine, bail peut ne pas être renouvelé (V3)
- **Rareté** : les terres sont en quantité limitée sur le serveur (pas illimité)
- **Prix variable** : selon la qualité de la terre et la localisation

#### Priorité 3 (V3)
- **SAFER** : priorité aux petites exploitations / nouveaux joueurs
- **Bail 9 ans** : engagement long terme (le fermier ne peut pas être viré)
- **GFA** : achat collectif de terres entre joueurs
- **Contrôle des structures** : seuil de surface max par joueur (anti-monopole)


---

## 7. Main d'œuvre et emploi

### 7.1 RÉALITÉ terrain 2024 (France)

#### Emploi agricole en France

- **400 000 exploitations** agricoles (2024, en baisse constante -2%/an)
- **750 000 actifs permanents** (chefs + conjoints + salariés permanents)
- **Salariés agricoles** : 150 000 permanents + 900 000 saisonniers/an
- **SAU moyenne** : 69 ha/exploitation (en hausse constante)
- **Temps de travail** : 2 000-2 500 h/an pour un chef d'exploitation (bien au-dessus des 1 607h légales)

#### Coût du travail salarié

| Poste | Montant 2024 |
|-------|:----------:|
| SMIC horaire brut | 11,65 € |
| SMIC mensuel brut (151,67h) | 1 767 € |
| Coût total employeur (charges) | 2 200-2 500 €/mois |
| Salaire moyen ouvrier agricole | 1 800-2 200 € brut/mois |
| Salaire chef de culture | 2 500-3 500 € brut/mois |
| Salaire saisonnier (vendange, récolte) | SMIC + primes |
| Coût ETA (prestation) | 30-50 €/h |

#### Organisation du travail

| Type d'exploitation | UTH nécessaires | Répartition |
|--------------------:|:---------------:|-------------|
| Grandes cultures 200 ha | 1-1,5 UTH | 1 chef + saisonnier moisson |
| Bovin laitier 80 vaches | 1,5-2 UTH | 1 chef + 0,5 conjoint + 0,5 salarié |
| Porc 200 truies NE | 3-4 UTH | 1 chef + 2-3 salariés |
| Volaille 2 bâtiments | 1-1,5 UTH | 1 chef + saisonnier nettoyage |
| Ovin 500 brebis | 1,5-2 UTH | 1 chef + 1 salarié (agnelage) |
| Maraîchage | 3-10 UTH | Très intensif en main d'œuvre |
| Arboriculture | 2-5 UTH permanent + saisonniers | Pics récolte = 10× le personnel |

> **UTH** = Unité de Travail Humain (1 UTH = 1 personne à temps plein/an = ~1 800 h)

#### Pics de travail et saisonnalité

La main d'œuvre agricole est très saisonnière :
- **Moisson** (juillet) : pointe de travail (16-18h/jour pendant 2-3 semaines)
- **Semis automne** (oct-nov) : forte intensité
- **Agnelage** (jan-mars) : surveillance 24/7
- **Vendanges** (sept) : besoin massif de saisonniers (15-30 jours)
- **Récolte fruits** (mai-oct) : main d'œuvre intensive

#### Problèmes structurels

- **Pénurie de main d'œuvre** : difficulté à recruter (conditions, image, ruralité)
- **Vieillissement** : 50% des exploitants ont >55 ans
- **Transmission** : 50% des exploitations n'ont pas de repreneur identifié
- **Temps de travail excessif** : burn-out, isolement social
- **Mécanisation/robotisation** : substitution progressive (robot traite, guidage GPS)

### 7.2 Modèle SimAgri

- **PA (Points d'Action)** : 35 PA/jour pour le joueur (≈ temps de travail)
- **Employé agricole** : embauche = PA supplémentaires (25 PA/jour)
- **Salaire** : fixe mensuel (~1 400 €/mois dans SimAgri)
- **Pas de compétences** : l'employé fait tout (sauf fromager/mécanicien spécialisés)
- **Fromagers** : compétences 0-100 sur 6 axes, salaire variable
- **Mécaniciens** : compétences usure/PA (1-10), retraite à 60 ans
- **Vendeurs** : concessionnaire (PA spécifiques)
- **Pas de saisonnalité** : l'employé travaille 365 jours/an uniformément
- **Pas de charges patronales** : le salaire = coût total

### 7.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Unité de travail | Heures (1800h/an/UTH) | PA (35/jour) | Simplifié OK |
| Coût employé | 2 200-2 500 €/mois (charges incluses) | 1 400 €/mois (pas de charges) | Sous-évalué |
| Compétences | Variables, formation, expérience | Uniformes (sauf fromager/mécanicien) | Simplifié OK |
| Saisonnalité | Pics massifs (moisson, vendange) | Uniforme toute l'année | Moyen |
| Charges patronales | +30-40% du brut | 0% | Fort |
| Pénurie | Difficulté croissante à recruter | Toujours disponible | Moyen |
| Retraite | 62-67 ans | 60 ans (mécanicien) | OK |
| Temps de travail exploitant | 2 000-2 500 h/an (excessif) | 35 PA/jour = limité | Acceptable (jeu) |

### 7.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Garder PA** comme unité de temps de travail (bon mécanisme ludique)
- **Employés** : ajoutent des PA, coût mensuel réaliste (2 000-2 500 €/mois)
- **Limiter les employés** : max 3-5 (réalisme + empêche le pay-to-win)

#### Priorité 2 (V2)
- **Saisonniers** : disponibles uniquement pour des tâches ponctuelles (moisson, récolte fruits)
- **Compétences** : niveaux d'expérience → efficacité (plus ancien = plus rapide)
- **Charges patronales** : +30% sur le salaire brut (réalisme économique)

#### Priorité 3 (V3)
- **Pénurie** : difficulté à recruter si trop de joueurs embauchent en même temps (serveur)
- **Formation** : investir pour monter en compétence (coût temps + argent)
- **Retraite** : l'employé part après X saisons (turnover)

---

## 8. Assurances agricoles

### 8.1 RÉALITÉ terrain 2024 (France)

#### Types d'assurances agricoles

| Assurance | Objet | Coût annuel moyen | Pénétration |
|-----------|-------|:-----------------:|:-----------:|
| **Multirisque climatique (MRC)** | Récolte (grêle, sécheresse, gel) | 15-30 €/ha | 30% des surfaces |
| **RC exploitation** | Responsabilité civile | 500-1 500 € | 99% |
| **Bris de machine** | Matériel (panne majeure) | 1-3% valeur/an | 40% |
| **Mortalité bétail** | Animaux (mort accidentelle) | 3-5% valeur/troupeau | 20% |
| **Incendie/bâtiments** | Bâtiments | 0,2-0,5% valeur | 90% |
| **Perte d'exploitation** | Manque à gagner post-sinistre | Variable | 10% |

#### Assurance récolte (MRC) — réforme 2023

**Nouveau dispositif public-privé (2023) :**
- **Niveau 1** : pertes 0-20% → absorbées par l'agriculteur (auto-assurance)
- **Niveau 2** : pertes 20-50% → assurance privée (subventionnée à 70% par l'État)
- **Niveau 3** : pertes > 50% → Fonds de solidarité nationale (État)
- **Subvention** : l'État paye 70% de la prime d'assurance MRC
- **Prime nette agriculteur** : 5-12 €/ha (après subvention)

**Sans assurance :**
- Si pas assuré → indemnisation réduite par l'État en cas de catastrophe
- Franchise 50% au lieu de 20%

#### Coûts d'assurance par exploitation type

| Exploitation | Assurance totale/an | Part dans charges |
|-------------|:-------------------:|:-----------------:|
| Grandes cultures 200 ha | 5 000-12 000 € | 2-4% |
| Bovin laitier 80 vaches | 4 000-8 000 € | 2-3% |
| Porc 200 truies | 6 000-15 000 € | 2-4% |
| Arboriculture 20 ha | 8 000-20 000 € | 4-8% |

### 8.2 Modèle SimAgri

- **Assurance matériel** : annuelle, couvre les réparations en cas de panne
- **Grêle** : événement rare, détruit les récoltes arboricoles → filet anti-grêle = protection
- **Pas d'assurance récolte** généralisée
- **Pas d'assurance bétail**
- **Pas d'assurance bâtiment**

### 8.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Assurance matériel | Bris de machine (1-3% valeur) | Annuelle, couvre pannes ✅ | Correct |
| Assurance récolte | MRC (15-30€/ha, subventionnée 70%) | Absente (sauf grêle arbo) | Fort |
| Assurance bétail | Mortalité (3-5% valeur) | Absente | Moyen |
| Grêle | Couvert par MRC | Événement + filet anti-grêle | Partiel |
| Sécheresse | Couvert par MRC / fonds calamités | Absente | Fort |
| Incendie | Couvert par multirisque | Absent | Moyen |

### 8.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Garder** l'assurance matériel (bon mécanisme anti-panne)
- **Assurance récolte basique** : option payante qui couvre les événements météo extrêmes

#### Priorité 2 (V2)
- **Événements climatiques** : sécheresse, gel tardif, grêle → perte de rendement
- **Indemnisation** : si assuré = couvert partiellement, si non-assuré = perte totale
- **Assurance bétail** : protection contre la mortalité (épizootie, accident)

#### Priorité 3 (V3)
- **Franchise modulable** : plus la franchise est haute, moins la prime est chère
- **Historique sinistres** : l'assurance coûte plus cher si beaucoup de sinistres
- **Fonds de solidarité** : mécanisme collectif en cas de catastrophe serveur


---

## 9. Circuits de commercialisation

### 9.1 RÉALITÉ terrain 2024 (France)

#### Circuits longs (75% du volume)

| Canal | Part de marché | Produits | Caractéristiques |
|-------|:-------------:|----------|------------------|
| Coopératives | 40-50% | Céréales, lait, viande | Engagement, services |
| Négoce privé | 15-20% | Céréales, oléagineux | Pas d'engagement, prix spot |
| Industries agro-alimentaires | 10-15% | Contrats directs (betterave, PDT, légumes industrie) | Contrat pluriannuel |
| GMS (grandes surfaces) | 5-10% | Via intermédiaires (pas directement agriculteur) | Prix imposé |
| Export | 10-15% | Céréales, vins, produits laitiers | Euronext, ports |

#### Circuits courts et vente directe (10-15% du volume)

| Canal | Part | Produits typiques | Marge |
|-------|:----:|-------------------|:-----:|
| Vente à la ferme | 5% | Tous (fromage, viande, légumes, œufs) | +50-100% vs circuit long |
| Marchés de plein vent | 3% | Fromage, fruits, légumes, viande | +30-80% |
| AMAP / paniers | 1% | Légumes, œufs, viande | +40-60% |
| Restauration collective | 1% | Local, produits frais | +20-40% |
| Drive fermier / e-commerce | 1% | Tous | +30-60% |
| Magasins de producteurs | 1% | Collectifs de producteurs | +30-50% |

- **25% des exploitations** ont au moins une activité de vente directe
- **Tendance** : en forte croissance depuis Covid-2020 (+30% en 3 ans)
- **Contraintes** : normes sanitaires, temps commercial, logistique, irrégularité demande

#### Contrats et prix garantis

| Type de contrat | Exemple | Avantage | Inconvénient |
|----------------|---------|----------|--------------|
| Contrat volume + prix fixe | Betterave (sucrerie) | Sécurité totale | Pas de gain si prix monte |
| Contrat indexé | Lait (formule mensuelle) | Suit le marché avec plancher | Complexe, pas toujours favorable |
| Intégration | Volaille (Doux, LDC) | 0 risque commercial | Marge captive (5-10 €/1000 poulets) |
| Filière qualité | Label Rouge, AOP, bio | Prix garanti supérieur | Contraintes cahier des charges |
| Spot (pas de contrat) | PDT libre, porc cadran | Gain maximal si prix haut | Risque maximal si prix bas |

#### Labels et signes de qualité

| Label | Nombre de produits | Survaleur |
|-------|:------------------:|:---------:|
| AOP/AOC | 450+ | +30-200% |
| IGP | 750+ | +10-50% |
| Label Rouge | 500+ | +15-40% |
| Agriculture Biologique | 60 000 exploitations | +20-80% |
| HVE | 40 000 exploitations | +0-10% (faible valorisation) |
| Bleu Blanc Cœur | 7 000 éleveurs | +5-15% |

### 9.2 Modèle SimAgri

- **Coopérative SimAgri** : vente au prix de base (PNJ, illimité)
- **Marché entre joueurs** : annonces, prix libre, commission 5%
- **Marché privé** (B2B) : entre 2 joueurs nommément, commission 2%
- **Marchés** (fromagerie/maraîchage) : vente directe sur marchés physiques (jours fixes)
- **Grossistes** : centrales d'achat pour produits transformés
- **Bio** : +20% sur tous les prix automatiquement
- **Qualité** : 3 niveaux influencent le prix
- **Filière PDT** : propositions de vente (régional/national/international)
- **Pas de contrats anticipés** (sauf PDT)
- **Pas d'AOP/IGP/Label Rouge**

### 9.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Coopérative | Canal principal (40-50%) | Oui ✅ | Correct |
| Marché entre joueurs | Négoce libre | Oui ✅ | Correct |
| Vente directe / marchés | 10-15%, marge ×2 | Fromage/maraîchage seulement | Partiel |
| Contrats | 60% des ventes | Absent (sauf PDT) | Fort |
| Intégration | 50-80% volaille/porc | Absent | Fort |
| Labels / AOP | +30-200% survaleur | Bio +20% seulement | Fort |
| Export | 10-15% du volume | Absent | Moyen |
| Saisonnalité demande | Forte (Noël, Pâques, été) | Absente | Moyen |

### 9.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Garder** : coopérative + marché joueurs (bonne base)
- **Qualité → prix** : 3 niveaux (existant = correct)
- **Bio** : survaleur (+20-50%) avec contraintes

#### Priorité 2 (V2)
- **Contrats** : vendre avant la récolte (prix garanti vs risque spot)
- **Vente directe** : option marge supérieure mais coûte du temps (PA)
- **Labels** : Label Rouge, AOP = contraintes + prix garanti élevé
- **Saisonnalité demande** : prix plus élevé à Noël (volaille), Pâques (agneau)

#### Priorité 3 (V3)
- **Intégration volaille** : contrat avec intégrateur (revenu garanti mais faible marge)
- **Export** : vente à l'international (Euronext simulé)
- **Drive fermier** : canal de vente directe en ligne (investissement web)
- **Cahiers des charges AOP** : contraintes détaillées (race, zone, pratiques)


---

## 10. Investissement et rentabilité

### 10.1 RÉALITÉ terrain 2024 (France)

#### Capital d'exploitation par filière

| Filière | Foncier | Bâtiments | Matériel | Cheptel | **Total** |
|---------|:-------:|:---------:|:--------:|:-------:|:---------:|
| GC 200 ha (propriétaire) | 1 200 000 | 100 000 | 400 000 | — | **1 700 000** |
| GC 200 ha (fermier) | 0 | 100 000 | 400 000 | — | **500 000** |
| Bovin laitier 80 VL | 300 000 | 400 000 | 250 000 | 150 000 | **1 100 000** |
| Porc 200 truies NE | 50 000 | 900 000 | 150 000 | 80 000 | **1 180 000** |
| Volaille 2 bâtiments | 30 000 | 400 000 | 100 000 | 10 000 | **540 000** |
| Ovin 500 brebis | 200 000 | 200 000 | 100 000 | 75 000 | **575 000** |
| Caprin fromager 300 | 100 000 | 250 000 | 80 000 | 45 000 | **475 000** |

#### Indicateurs de rentabilité

| Indicateur | Définition | Objectif |
|-----------|-----------|:--------:|
| EBE (Excédent Brut d'Exploitation) | Produit - charges (hors amortissement) | >30% du produit |
| Revenu agricole | EBE - amortissements - frais financiers | Positif |
| EBE/Produit brut | Efficacité économique | 25-40% |
| Annuités/EBE | Capacité de remboursement | <50% |
| Taux d'endettement | Dettes / Actif total | <60% |
| Productivité du travail | EBE / UTH | >50 000 € |

#### Rentabilité par filière (données RICA 2023)

| Filière | Produit brut | EBE | Revenu/UTANS | EBE/Produit |
|---------|:----------:|:---:|:------------:|:-----------:|
| GC 200 ha | 280 000 € | 100 000 € | 45 000 € | 36% |
| Bovin lait 80 VL | 350 000 € | 90 000 € | 40 000 € | 26% |
| Bovin allaitant 100 VA | 200 000 € | 50 000 € | 20 000 € | 25% |
| Porc 200 truies | 1 200 000 € | 150 000 € | 45 000 € | 13% |
| Volaille (2 bât.) | 250 000 € | 60 000 € | 30 000 € | 24% |
| Ovin 500 brebis | 150 000 € | 40 000 € | 20 000 € | 27% |
| Caprin fromager | 180 000 € | 60 000 € | 35 000 € | 33% |
| Viticulture AOP | 200 000 € | 80 000 € | 55 000 € | 40% |

#### Seuils de viabilité

| Critère | Seuil minimum |
|---------|:------------:|
| Revenu/UTANS | >15 000 €/an (SMIC agricole = non atteint pour 30%) |
| EBE | Positif (sinon exploitation en déclin) |
| Annuités/EBE | <60% (sinon étranglement financier) |
| Capacité d'autofinancement | >0 (sinon décapitalisation) |

#### Retour sur investissement (ROI) type

| Investissement | Coût | Gain annuel | ROI |
|---------------|:----:|:----------:|:---:|
| Robot de traite | 180 000 € | +20 000 €/an (temps + production) | 9 ans |
| Bâtiment volaille | 250 000 € | 30 000 €/an | 8 ans |
| Drainage parcelle | 3 000 €/ha | +300-500 €/ha/an | 6-10 ans |
| GPS RTK | 25 000 € | 4 000-8 000 €/an | 3-6 ans |
| Photovoltaïque (100 kWc) | 100 000 € | 10 000-15 000 €/an | 7-10 ans |
| Méthaniseur (250 kW) | 2 000 000 € | 150 000-200 000 €/an | 10-13 ans |
| Conversion bio | -20% rendement, investissement formation | +30-80% prix vente | 3-5 ans |

### 10.2 Modèle SimAgri

- **Pas d'indicateurs comptables** (pas d'EBE, pas de bilan)
- **Log financier** : historique des recettes/dépenses (consultable)
- **Solde = indicateur unique** de "santé financière"
- **Pas d'amortissement** : le matériel ne génère pas de charge annuelle comptable
- **Pas de bilan** : pas de vision patrimoniale (actif/passif)
- **Argus matériel** : valeur de revente calculée (seule notion de dépréciation)
- **Rentabilité** : implicite (le joueur gagne ou perd de l'argent)

### 10.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| Indicateurs comptables | EBE, revenu, taux d'endettement | Solde seul | Fort |
| Capital d'exploitation | 500k-1.7M€ selon filière | Non modélisé (pas de bilan) | Moyen |
| Amortissement | Charge annuelle (matériel, bâtiments) | Absent (usure seulement) | Fort |
| ROI par investissement | Calculable (gain/coût) | Non visible | Moyen |
| Viabilité | Seuils critiques (annuités/EBE) | Solde > 0 = viable | Simplifié |
| Comparaison entre filières | RICA/Agreste publie chaque année | Pas d'outil comparatif | Moyen |

### 10.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Tableau de bord financier** : recettes, dépenses, bénéfice net par saison
- **Solde + historique** : garder le log financier SimAgri (excellent)
- **Coûts visibles** : chaque action affiche son coût total (temps + intrants + carburant)

#### Priorité 2 (V2)
- **EBE simplifié** : produit brut - charges opérationnelles (indicateur mensuel)
- **Amortissement** : charge annuelle par bâtiment/matériel (réalisme)
- **Bilan patrimonial** : total des actifs vs total des dettes (progression visible)
- **ROI par investissement** : estimation du temps de retour avant achat

#### Priorité 3 (V3)
- **Comparaison serveur** : benchmark avec les autres joueurs (classement)
- **Ratios de gestion** : annuités/EBE, EBE/produit, endettement
- **Simulation financière** : "si j'achète X, combien ça me rapporte/coûte par an ?"
- **Faillite** : si dettes > actifs → procédure de redressement (game event)


---

## 11. TOP 10 des différences majeures réalité vs SimAgri

### 1. 🔴 Pas de charges sociales ni fiscales (0% vs 55-65%)

**Réalité** : MSA + IR + taxe foncière = 55-65% du revenu brut est prélevé.
**SimAgri** : le joueur garde 100% de ses bénéfices (seule l'électricité est prélevée).
**Impact** : fausse totalement le calcul de rentabilité. Un joueur qui "gagne bien" dans SimAgri serait en réalité à peine viable.

### 2. 🔴 Pas d'aides PAC (0€ vs 15-60% du revenu)

**Réalité** : 9,5 Mrd€/an distribués. Sans aides, le bovin allaitant et l'ovin sont non-viables.
**SimAgri** : aucune aide, aucune subvention.
**Impact** : l'équilibre économique des filières est complètement faussé. Les filières extensives paraissent non-rentables alors qu'elles sont viables grâce aux aides.

### 3. 🔴 Pas de fermage (0% vs 60% des terres)

**Réalité** : 60% des terres sont louées. Le fermage (150-350 €/ha/an) est le mode d'exploitation dominant — il permet de démarrer sans capital foncier.
**SimAgri** : le joueur doit ACHETER toutes ses terres (3000€/ha). Pas d'option location.
**Impact** : force un investissement foncier irréaliste. En réalité, un JA s'installe en fermage.

### 4. 🟠 Pas de saisonnalité des prix

**Réalité** : blé = bas en juillet (moisson), haut en avril. Agneau = pic à Pâques. Porc = cycle 3-4 ans.
**SimAgri** : prix fluctuent par offre/demande mais sans tendance saisonnière.
**Impact** : supprime la dimension "quand vendre" (stockage, spéculation saisonnière).

### 5. 🟠 Pas de contrats de vente anticipés

**Réalité** : 60% des ventes se font par contrat (prix fixé avant la récolte). C'est un outil de gestion du risque fondamental.
**SimAgri** : le joueur vend uniquement après récolte, au prix du moment.
**Impact** : le joueur ne peut pas sécuriser ses revenus avant la production.

### 6. 🟠 Prix du foncier sous-évalué

**Réalité** : 6 200 €/ha en moyenne (2 000-12 000 selon zone).
**SimAgri** : 3 000 €/ha (France).
**Impact** : le foncier devrait être un investissement majeur et engageant, pas un achat facile.

### 7. 🟠 Pas de labels / signes de qualité (AOP, Label Rouge)

**Réalité** : 1 700+ AOP/IGP/Labels en France. Survaleur +30-200%. C'est ce qui différencie l'agriculture française.
**SimAgri** : Bio = +20%. Pas d'AOP, pas de Label Rouge, pas d'IGP.
**Impact** : manque une dimension stratégique majeure (différenciation par la qualité).

### 8. 🟡 Pas de tableau de bord financier (EBE, bilan)

**Réalité** : tout agriculteur suit son EBE, son taux d'endettement, sa capacité de remboursement.
**SimAgri** : le solde est le seul indicateur. Pas de bilan, pas d'amortissement visible.
**Impact** : le joueur ne peut pas analyser sa performance ni comparer des stratégies.

### 9. 🟡 Employés sous-évalués (1400€ vs 2200-2500€ réels)

**Réalité** : un salarié coûte 2 200-2 500 €/mois (charges incluses).
**SimAgri** : 1 400 €/mois (pas de charges patronales).
**Impact** : la main d'œuvre paraît trop bon marché → biais vers l'embauche facile.

### 10. 🟡 Pas de cycle de trésorerie (BFR)

**Réalité** : l'agriculteur investit en automne (semences, engrais) et ne vend qu'en juillet. Le besoin en fonds de roulement crée une tension permanente.
**SimAgri** : le solde est toujours disponible immédiatement, pas de décalage de paiement.
**Impact** : la gestion de trésorerie = contrainte quotidienne absente du jeu.

---

## 12. TOP 10 des ajouts prioritaires pour Agriva

### 1. 🏆 Charges sociales forfaitaires (V1)

**Quoi** : prélèvement automatique de 25-35% du bénéfice net (simplifié).
**Pourquoi** : sans charges, la rentabilité est irréaliste. Le joueur doit "sentir" le poids des prélèvements.
**Complexité** : Faible. Tick mensuel/annuel : `bénéfice × taux = charge`.
**ROI gameplay** : ★★★★★ — rend le jeu exigeant, les marges sont serrées (comme en vrai).

### 2. 🏆 Aides PAC simplifiées (V1-V2)

**Quoi** : DPB (€/ha) + aides couplées (€/tête ovins/bovins allaitants).
**Pourquoi** : rend les filières extensives viables. Explique pourquoi l'ovin et l'allaitant existent. Ajoute un "revenu de base" conditionnel.
**Complexité** : Faible. Calcul annuel automatique : `ha × DPB + têtes × aide_couplée`.
**ROI gameplay** : ★★★★★ — stabilise les revenus, ouvre les stratégies extensives.

### 3. 🏆 Fermage — louer des terres (V1)

**Quoi** : le joueur peut louer des terres (150-300 €/ha/an) au lieu d'acheter (5000-10000€/ha).
**Pourquoi** : permet de démarrer sans capital. Choix stratégique propriété (patrimoine) vs location (trésorerie).
**Complexité** : Faible. Ajout d'un `rent_per_ha` payé annuellement, parcelle non-cessible.
**ROI gameplay** : ★★★★★ — ouvre un chemin de jeu "démarrage léger" vs "investissement lourd".

### 4. 🥈 Saisonnalité des prix (V1-V2)

**Quoi** : courbe de prix sinusoïdale (bas à la récolte, haut en contre-saison).
**Pourquoi** : donne une raison de stocker (vendre en mars au lieu de juillet = +10-30€/t).
**Complexité** : Faible. Modulation du tick prix existant avec une composante saisonnière.
**ROI gameplay** : ★★★★☆ — ajoute la dimension temporelle et le stockage spéculatif.

### 5. 🥈 Contrats de vente anticipés (V2)

**Quoi** : avant la récolte, le joueur peut s'engager à vendre X tonnes à un prix garanti.
**Pourquoi** : outil de gestion du risque n°1 de l'agriculteur. Sécurité vs potentiel de gain.
**Complexité** : Moyenne. Engagement (volume promis) + pénalité si non-livré.
**ROI gameplay** : ★★★★☆ — choix stratégique (sécuriser vs spéculer).

### 6. 🥈 Labels et AOP (V2)

**Quoi** : le joueur peut certifier sa production (contraintes + survaleur prix).
**Pourquoi** : différenciation par la qualité = stratégie alternative au volume. La France = labels.
**Complexité** : Moyenne. Cahier des charges (conditions) + vérification + bonus prix.
**ROI gameplay** : ★★★★☆ — diversifie les stratégies (volume pas cher vs niche premium).

### 7. 🥉 Tableau de bord financier (V1-V2)

**Quoi** : EBE, revenu net, marge par culture, coût par hectare — affichés clairement.
**Pourquoi** : le joueur doit pouvoir analyser ce qui rapporte et ce qui coûte.
**Complexité** : Faible-moyenne. Agrégation du log financier existant + affichage.
**ROI gameplay** : ★★★☆☆ — aide à la décision, progression visible.

### 8. 🥉 Prix du foncier réaliste (V1)

**Quoi** : terres à 5 000-10 000 €/ha (pas 3 000 €). Variable selon zone et qualité.
**Pourquoi** : le foncier est le poste n°1 du bilan. Son prix doit rendre l'achat engageant.
**Complexité** : Très faible. Ajuster les prix dans la table.
**ROI gameplay** : ★★★☆☆ — rend le choix achat vs fermage significatif.

### 9. 🥉 Charges patronales sur employés (V1)

**Quoi** : le coût d'un employé = salaire + 30-40% de charges.
**Pourquoi** : réalisme économique. L'embauche est un investissement, pas un achat trivial.
**Complexité** : Très faible. Multiplier le salaire par 1,3-1,4 dans le tick.
**ROI gameplay** : ★★★☆☆ — rend le choix embauche vs automatisation stratégique.

### 10. 🥉 Assurance récolte (V2)

**Quoi** : option payante (5-15 €/ha) qui protège contre les événements climatiques.
**Pourquoi** : ajoute une dimension de gestion du risque. Les événements météo ont un coût.
**Complexité** : Moyenne. Événement → perte → indemnisation si assuré.
**ROI gameplay** : ★★★☆☆ — tension risque/protection, récompense la prudence.

---

### Synthèse

| Rang | Ajout | Phase | Complexité | Impact |
|:----:|-------|:-----:|:----------:|:------:|
| 1 | Charges sociales | V1 | ★☆☆ | ★★★★★ |
| 2 | Aides PAC | V1-V2 | ★☆☆ | ★★★★★ |
| 3 | Fermage | V1 | ★☆☆ | ★★★★★ |
| 4 | Saisonnalité prix | V1-V2 | ★☆☆ | ★★★★☆ |
| 5 | Contrats anticipés | V2 | ★★☆ | ★★★★☆ |
| 6 | Labels / AOP | V2 | ★★☆ | ★★★★☆ |
| 7 | Tableau de bord | V1-V2 | ★★☆ | ★★★☆☆ |
| 8 | Prix foncier réaliste | V1 | ★☆☆ | ★★★☆☆ |
| 9 | Charges patronales | V1 | ★☆☆ | ★★★☆☆ |
| 10 | Assurance récolte | V2 | ★★☆ | ★★★☆☆ |

---

## 13. Tableau récapitulatif

### Couverture SimAgri vs Réalité — Économie agricole

| Domaine | Note SimAgri /10 | Manque principal |
|---------|:----------------:|-----------------|
| Marchés et prix | 6/10 | Saisonnalité, cycles, contrats |
| Coopératives | 7/10 | Ristourne, engagement, achats groupés |
| Banque / financement | 6/10 | Crédit-bail, BFR, trésorerie |
| Aides PAC | 0/10 | **Totalement absentes** |
| Fiscalité / charges | 1/10 | **MSA et IR absents** |
| Foncier | 4/10 | Fermage absent, prix sous-évalué |
| Main d'œuvre | 6/10 | Coût sous-évalué, pas de saisonnalité |
| Assurances | 4/10 | Pas de MRC récolte, pas de bétail |
| Commercialisation | 5/10 | Labels, contrats, vente directe |
| Rentabilité / gestion | 3/10 | Pas d'EBE, pas de bilan, pas de ROI |

### Note globale : 4/10

**Forces de SimAgri (économie)** : log financier existant, tick prix offre/demande, coopérative multi-joueurs (CAR), marché entre joueurs, emprunts, taxe plus-value.

**Faiblesse fondamentale** : SimAgri modélise un monde où l'agriculteur garde 100% de ses revenus et ne reçoit aucune aide. En réalité, c'est l'inverse : 55-65% de prélèvements + 15-60% d'aides = l'économie agricole est un jeu d'équilibre entre charges et soutiens publics. Sans ce modèle, les choix stratégiques sont faussés.

**Conclusion** : c'est le domaine où Agriva peut apporter le plus de valeur ajoutée par rapport à SimAgri. Un modèle économique réaliste transformerait le gameplay en rendant chaque décision économiquement significative.

---

*Document complété le 4 août 2026. Prêt pour utilisation comme référence dans le game design des systèmes économiques Agriva.*