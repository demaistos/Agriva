# SimAgri — Rule Engine (Moteur de Règles)

> Document de référence décrivant toutes les mécaniques de jeu et leurs règles.
> Dernière mise à jour : 2026-04-03

---

## 1. SYSTÈME DE TEMPS

### 1.1 Heures quotidiennes
- Chaque joueur dispose d'un quota d'heures par jour (`hours_today` sur `players`)
- Chaque action consomme des heures via `consumeHours(playerId, amount)`
- Le multiplicateur serveur (`hours_multiplier` sur `servers`) ajuste la consommation réelle
- Les heures sont réinitialisées chaque jour de jeu par le worker `dailyTick`

### 1.2 Temps de jeu
- Le temps de jeu est accéléré par un ratio (`time_ratio` sur `servers`, ex: 7 = 7 jours de jeu par jour réel)
- Le worker exécute des ticks : `hourly`, `daily`, `weekly`
- `game_day` et `game_hour` sur `game_time` trackent le temps de jeu

---

## 2. SYSTÈME D'ALIMENTATION

### 2.1 Catalogue d'aliments (`feed_items`)
- 20 aliments répartis en 7 catégories : fourrage, cereale, proteine, mineral, calcium, fibre, granule
- Chaque aliment a : `slug`, `name`, `category`, `price_per_ton`, `transport_family` (benne/plateau), `storable_in` (silo/hangar)

### 2.2 Ration de base (`ration_bases` + `ration_base_items`)
- Chaque espèce a 2 à 4 options de ration de base (ex: Foin seul, Foin + Maïs ensilé, etc.)
- Le joueur choisit UNE option par bâtiment d'élevage
- Chaque option est composée de 1 à 3 ingrédients avec des quantités en kg/jour (pour un adulte)
- Chaque ingrédient a un `weight` (poids relatif, somme = 1.0 par option)
- **Base partielle** : si un ingrédient manque, la productivité de base est réduite proportionnellement au poids manquant (pas tout-ou-rien)
- Productivité de base = 75% × (somme des poids des ingrédients fournis)

### 2.3 Compléments optionnels (`ration_complements`)
- Chaque espèce a 3 types de compléments (ex: cereale, proteine, mineral)
- Chaque complément offre un bonus de productivité (+10% à +20%)
- Le joueur choisit UN aliment spécifique par type de complément (ex: orge OU blé OU triticale pour le type "cereale")
- Les compléments sont optionnels : sans eux, l'animal produit à 75% (base seule)
- Avec tous les compléments : productivité max = 120%

### 2.4 Formule de productivité
```
productivité = base_partielle + bonus_complement_1 + bonus_complement_2 + bonus_complement_3
             = (75% × Σ poids_fournis) + 15% + 15% + 15%
             = max 120%
```

Cas spéciaux :
- **Porcin** : protéine +20%, mineral +15%, fibre +10% = +45%
- **Volaille** : protéine +15%, calcium +20%, mineral +10% = +45%

### 2.5 Coefficients d'âge (`age_stages`)
- 3 stades par espèce : jeune, croissance, adulte
- Chaque stade a un coefficient multiplicateur sur les quantités consommées
- Les jeunes qui ont besoin de lait maternel (`needs_milk = true`) consomment moins

| Espèce | Jeune (coeff) | Croissance (coeff) | Adulte (coeff) |
|--------|---------------|-------------------|----------------|
| Bovin | 0.25 (0-180j) | 0.60 (181-720j) | 1.00 (+721j) |
| Ovin | 0.20 (0-90j) | 0.55 (91-365j) | 1.00 (+366j) |
| Caprin | 0.20 (0-90j) | 0.55 (91-365j) | 1.00 (+366j) |
| Cheval | 0.25 (0-180j) | 0.60 (181-900j) | 1.00 (+901j) |
| Porcin | 0.15 (0-60j) | 0.60 (61-180j) | 1.00 (+181j) |
| Volaille | 0.30 (0-60j) | 0.70 (61-150j) | 1.00 (+151j) |
| Lapin | 0.20 (0-30j) | 0.60 (31-120j) | 1.00 (+121j) |

### 2.6 Configuration par bâtiment
- La ration (base + compléments) est configurée sur le bâtiment d'élevage, pas sur chaque lot
- Tous les animaux d'un bâtiment mangent la même ration
- Colonnes sur `buildings` : `ration_base_id`, `complement_cereale`, `complement_proteine`, `complement_mineral`, `complement_calcium`, `complement_fibre`

### 2.7 Nourrissage (action manuelle ou robot)
- Le joueur doit nourrir ses animaux chaque jour de jeu
- **Manuel** : action `POST /buildings/:id/feed` qui consomme 1h + nécessite tracteur + désileuse
- **Robot d'alimentation** : `has_feed_robot = true` sur le bâtiment → nourrissage automatique
- Si pas nourri (`fed_today = false` et pas de robot) : les animaux perdent de la faim
- Le flag `fed_today` est remis à `false` après chaque tick du worker

### 2.8 Stockage
- **Silo mono-type** : chaque silo ne peut stocker qu'un seul type d'aliment (`assigned_item` sur `buildings`)
- Le silo est automatiquement affecté au premier aliment stocké
- Capacité en tonnes (`size` sur `buildings`)
- Foin et paille → hangar, entrepôt, aire de stockage
- Tout le reste → silo

---

## 3. SYSTÈME DE TRANSPORT

### 3.1 Matériel requis
- Acheter des aliments nécessite : tracteur + remorque (benne ou plateau)
- Le type de remorque dépend de l'aliment : `transport_family` (benne pour vrac, plateau pour balles)
- Le tracteur doit avoir assez de puissance pour la remorque (`horsepower >= required_hp`)

### 3.2 Trajets
- Chaque trajet coopérative ↔ ferme = 1h
- Nombre de trajets = ceil(tonnes_achetées / capacité_remorque)
- Chaque trajet cause de l'usure (0.5% par trajet sur tracteur et remorque)
- Chaque trajet consomme du carburant : `horsepower × fuel_rate × hours`

### 3.3 Coûts d'achat
- Prix = tonnes × prix_par_tonne × 1.15 (marge coopérative 15%)
- + coût carburant
- + heures consommées
- + usure matériel

---

## 4. SYSTÈME DE PRODUCTION

### 4.1 Production d'œufs
- Conditions : poule femelle, en bâtiment, âge ≥ `egg_production_age`, productivité > 0
- Quantité : `eggs = base_eggs × ratio × productivity`
- Nécessite : robot ramassage (accessoire) + salle de conditionnement (stockage)
- Calibre selon l'âge : S (<240j), M (240-400j), L (400-600j), XL (+600j)

### 4.2 Prise de poids
- Condition : `hunger > 30` et poids < poids adulte
- Formule : `gain = (adult_weight - current_weight) × 0.01 × ratio × productivity`
- La productivité du bâtiment module directement la vitesse de croissance

### 4.3 Reproduction
- Monte naturelle : mâle + femelles dans le même bâtiment
- Taux de réussite : `0.8 × (santé_mâle/100) × (santé_femelle/100)`
- Gestation : durée en jours de jeu, naissance automatique
- Nombre de petits : aléatoire entre `babies_min` et `babies_max`

---

## 5. SYSTÈME DE SANTÉ

### 5.1 Faim et soif
- `hunger` et `thirst` sur `animal_lots` (0-100)
- Nourri : faim remonte proportionnellement à la productivité
- Pas nourri : faim baisse de `10 × ratio × pm` par tick
- Eau en bâtiment : automatique (eau courante), coût = `water_liters × quantity × ratio × 0.003€/L`

### 5.2 Santé
- `health` sur `animal_lots` (0-100)
- `hunger < 30` → santé baisse de `5 × ratio × pm` par tick
- `thirst < 30` → santé baisse de `10 × ratio × pm` par tick
- `hunger > 70 AND thirst > 70` → santé remonte de `2 × ratio` par tick
- `health = 0` → mort (suppression du lot)

---

## 6. SYSTÈME MÉTÉO

### 6.1 Prévisions
- 7 jours de prévisions par zone climatique (5 zones)
- Données : `level` (1-5), `wind`, `hail`, `frost`, `temp_min`, `temp_max`, `precipitation_mm`
- Générées par le worker `weeklyTick`

### 6.2 Impact sur les cultures
- Ensoleillement et pluviométrie affectent la maturation (`hourlyTick`)
- Gel, grêle, canicule : dégâts sur les cultures (à implémenter)

### 6.3 Alertes
- Gel, grêle, canicule : notifications sur le dashboard
- Son de notification quand une alerte apparaît

---

## 7. SYSTÈME DE BÂTIMENTS

### 7.1 Types
- **Élevage** : stabulation, porcherie, poulailler, bergerie, chèvrerie, écurie, clapier
- **Stockage sec** : silo (mono-type), hangar, entrepôt, aire de stockage
- **Stockage spécialisé** : chambre froide, salle de conditionnement, silo taupe

### 7.2 Construction
- Coût = `price_per_unit × size × level_factor`
- Consomme des heures
- Capacité animale = `size / m2_per_animal` (varie selon espèce et mode d'élevage)

### 7.3 Niveaux d'équipement
- 5 niveaux (1-5), chaque niveau augmente la capacité et le coût
- `LEVEL_CAPACITY = [0, 1.0, 1.0, 1.05, 1.10, 1.15]`

---

## 8. SYSTÈME DE MATÉRIEL

### 8.1 Familles
- Tracteur, benne, plateau, bétaillère, désileuse, pailleuse, moissonneuse, semoir, etc.
- Chaque matériel a : puissance, capacité, usure, état de panne

### 8.2 Usure et pannes
- L'usure augmente à chaque utilisation
- Plus l'usure est élevée, plus le risque de panne est grand
- Réparation : coût + délai (7 jours de jeu minimum entre réparations)

### 8.3 Carburant
- `fuel_stock` sur `players`
- Consommation = `horsepower × fuel_rate × hours`
- Achat de carburant (à implémenter dans le marché)

---

## 9. SYSTÈME ÉCONOMIQUE

### 9.1 Balance
- `balance` sur `players` (en euros)
- Dépenses : achat aliments, construction, matériel, eau, carburant, vétérinaire
- Revenus : vente œufs, lait, animaux, récoltes

### 9.2 Suivi quotidien
- Le dashboard affiche la variation du solde depuis le début de la journée
- `initialBalance` stocké en localStorage par joueur par jour

---

## 10. SYSTÈME GÉOGRAPHIQUE

### 10.1 Communes
- 324 communes (préfectures + sous-préfectures des 96 départements)
- Chaque joueur est rattaché à une commune (`commune_id` sur `players`)
- La commune détermine la région, le département, et la zone climatique

### 10.2 Zones climatiques
- 5 zones : océanique, continental, méditerranéen, montagnard, semi-océanique
- Chaque zone a ses propres données météo
