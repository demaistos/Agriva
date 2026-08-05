# Phases 5 & 6 — Contenu Avancé + Social

> **Cultivia Clone — Spécifications techniques**
> Source : GDD 02, 04, 05 + 01_DATA_MODEL.md
> Dépendances : Phases 0-4 (infrastructure, cultures, élevage, économie)

---

## Table des matières

### Phase 5 — Contenu Avancé
1. [Viticulture](#1-viticulture)
2. [Forêts](#2-forêts)
3. [Foie gras](#3-foie-gras)
4. [Méthanisation](#4-méthanisation)
5. [Chevaux](#5-chevaux)
6. [Bisons & Daims](#6-bisons--daims)
7. [IVRAD](#7-ivrad)
8. [Arboriculture](#8-arboriculture)
9. [Haies](#9-haies)

### Phase 6 — Social & Méta
10. [Chambre Agricole](#10-chambre-agricole)
11. [Classements](#11-classements)
12. [Concours](#12-concours)
13. [Lycée Agricole](#13-lycee-agricole)
14. [Parrainage](#14-parrainage)
15. [Garde de ferme](#15-garde-de-ferme)
16. [Forums + MP-Live](#16-forums--mp-live)
17. [Multi-serveurs](#17-multi-serveurs)

---

# PHASE 5 — CONTENU AVANCÉ

---

## 1. Viticulture

### 1.1 Description

Domaine viticole **totalement autonome** de la ferme principale. Aucun partage de HT, matériels ou bâtiments. Déblocage annuel (~1.80 €, remplace Licence Pro). Budget max 850 000 € (500k virements ferme + 350k emprunts). Parcelles 500-10 000 m², densité 6 000 ceps/ha. Personnel : agent viticole (CDI), vendangeur (saisonnier, 0.020 HT/kg), maître de chai (1 seul, compétences Élaboration/Contrôle/Rigueur/Organisation). Vinification : fermentation 7j noirs / 3j blancs, élevage 42j min, assemblage 2-5 cépages (certifié ou libre). Vieillissement en fût. 3 indices qualité (Apparence, Odeur, Goût). Vente Cultivia + magasin viticole (+2€/bouteille). Concours Le Domaine en septembre.

### 1.2 Tables SQL

```sql
-- Domaine viticole (1 par joueur, autonome)
-- Réf: 01_DATA_MODEL §6.6 vineyard
CREATE TABLE vineyard (
  id            SERIAL PRIMARY KEY,
  player_id     INT NOT NULL REFERENCES player(id) UNIQUE,
  region_id     INT NOT NULL REFERENCES region(id),
  balance       DECIMAL(14,2) NOT NULL DEFAULT 0,
  total_invested DECIMAL(14,2) NOT NULL DEFAULT 0,
  max_transfer  DECIMAL(14,2) NOT NULL DEFAULT 500000,
  max_loan      DECIMAL(14,2) NOT NULL DEFAULT 350000,
  unlocked_until TIMESTAMPTZ NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Parcelle viticole
CREATE TABLE vineyard_parcel (
  id            SERIAL PRIMARY KEY,
  vineyard_id   INT NOT NULL REFERENCES vineyard(id),
  area_m2       INT NOT NULL CHECK (area_m2 BETWEEN 500 AND 10000),
  grape_variety VARCHAR(50),
  vine_age_days INT NOT NULL DEFAULT 0,
  vine_count    INT NOT NULL DEFAULT 0, -- 6000 ceps/ha pour 10000m²
  soil_quality  SMALLINT NOT NULL CHECK (soil_quality BETWEEN 1 AND 3),
  exposure      VARCHAR(15), -- 'south','south_east','east','west','north'
  slope_pct     SMALLINT NOT NULL DEFAULT 0,
  stones_level  SMALLINT NOT NULL DEFAULT 0 CHECK (stones_level BETWEEN 0 AND 100),
  stones_broyage_until TIMESTAMPTZ,
  growth_pct    DECIMAL(5,2) NOT NULL DEFAULT 0,
  phyto_gauge   SMALLINT NOT NULL DEFAULT 100 CHECK (phyto_gauge BETWEEN 0 AND 100),
  rain_gauge    SMALLINT NOT NULL DEFAULT 50,
  sun_gauge     SMALLINT NOT NULL DEFAULT 50,
  planted_at    TIMESTAMPTZ,
  bought_price  DECIMAL(12,2) NOT NULL DEFAULT 0
);

-- Employés viticoles
CREATE TABLE vineyard_employee (
  id          SERIAL PRIMARY KEY,
  vineyard_id INT NOT NULL REFERENCES vineyard(id),
  role        VARCHAR(20) NOT NULL CHECK (role IN ('vineyard_agent','harvester','chai_master','cellar_seller')),
  contract    VARCHAR(5) NOT NULL CHECK (contract IN ('CDI','CDD')),
  salary      DECIMAL(10,2) NOT NULL,
  pa_per_day  DECIMAL(6,2) NOT NULL,
  -- Compétences agent/vendangeur (vitesse + qualité par action)
  skill_speed JSONB DEFAULT '{}',
  skill_quality JSONB DEFAULT '{}',
  -- Compétences maître de chai
  elaboration SMALLINT DEFAULT 50 CHECK (elaboration BETWEEN 0 AND 100),
  control     SMALLINT DEFAULT 50 CHECK (control BETWEEN 0 AND 100),
  rigor       SMALLINT DEFAULT 50 CHECK (rigor BETWEEN 0 AND 100),
  organization SMALLINT DEFAULT 50 CHECK (organization BETWEEN 0 AND 100),
  hired_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  contract_end TIMESTAMPTZ
);

-- Bâtiments viticoles
CREATE TABLE vineyard_building (
  id            SERIAL PRIMARY KEY,
  vineyard_id   INT NOT NULL REFERENCES vineyard(id),
  type          VARCHAR(20) NOT NULL CHECK (type IN ('hangar','chai','cave','shop')),
  size_m2       INT NOT NULL,
  level         SMALLINT NOT NULL DEFAULT 1,
  wear_pct      DECIMAL(5,2) NOT NULL DEFAULT 0,
  built_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Cuves inox (dans le chai)
CREATE TABLE vineyard_tank (
  id            SERIAL PRIMARY KEY,
  building_id   INT NOT NULL REFERENCES vineyard_building(id),
  capacity_l    INT NOT NULL,
  current_l     DECIMAL(10,2) NOT NULL DEFAULT 0,
  content_type  VARCHAR(20), -- 'must','wine','empty'
  wine_batch_id INT REFERENCES wine_batch(id)
);

-- Fûts (dans la cave)
CREATE TABLE vineyard_barrel (
  id            SERIAL PRIMARY KEY,
  building_id   INT NOT NULL REFERENCES vineyard_building(id),
  size          VARCHAR(10) NOT NULL CHECK (size IN ('small','medium','large')),
  capacity_l    INT NOT NULL,
  wine_batch_id INT REFERENCES wine_batch(id),
  aging_start   TIMESTAMPTZ,
  wear_pct      DECIMAL(5,2) NOT NULL DEFAULT 0
);

-- Lot de vin (cycle complet)
CREATE TABLE wine_batch (
  id              SERIAL PRIMARY KEY,
  vineyard_id     INT NOT NULL REFERENCES vineyard(id),
  grape_variety   VARCHAR(50) NOT NULL,
  vintage_season  INT NOT NULL,
  liters          DECIMAL(10,2) NOT NULL,
  status          VARCHAR(20) NOT NULL CHECK (status IN (
    'fermenting','aging_tank','aging_barrel','bottled','sold'
  )),
  ferment_start   TIMESTAMPTZ,
  ferment_end     TIMESTAMPTZ,
  aging_start     TIMESTAMPTZ,
  -- 3 indices qualité
  quality_appearance SMALLINT NOT NULL DEFAULT 50 CHECK (quality_appearance BETWEEN 0 AND 100),
  quality_smell      SMALLINT NOT NULL DEFAULT 50 CHECK (quality_smell BETWEEN 0 AND 100),
  quality_taste      SMALLINT NOT NULL DEFAULT 50 CHECK (quality_taste BETWEEN 0 AND 100),
  -- Assemblage
  assembly_type   VARCHAR(10) CHECK (assembly_type IN ('certified','free')),
  assembly_json   JSONB, -- [{variety, pct}, ...]
  assembly_mastered BOOLEAN DEFAULT false,
  -- Bouteilles
  bottled_count   INT DEFAULT 0,
  bottle_price    DECIMAL(8,2),
  -- Concours
  award           VARCHAR(10) CHECK (award IN ('gold','silver','bronze')),
  award_until     TIMESTAMPTZ, -- +84 jours
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_wine_batch_vineyard ON wine_batch(vineyard_id, status);

-- Stock bouteilles (cave ou magasin)
CREATE TABLE wine_bottle_stock (
  id            SERIAL PRIMARY KEY,
  vineyard_id   INT NOT NULL REFERENCES vineyard(id),
  wine_batch_id INT NOT NULL REFERENCES wine_batch(id),
  location      VARCHAR(10) NOT NULL CHECK (location IN ('cave','shop')),
  quantity      INT NOT NULL DEFAULT 0
);

-- Référentiel cépages par serveur
CREATE TABLE grape_variety (
  id          SERIAL PRIMARY KEY,
  server_id   INT NOT NULL REFERENCES server(id),
  name        VARCHAR(50) NOT NULL,
  color       VARCHAR(5) NOT NULL CHECK (color IN ('red','white')),
  UNIQUE(server_id, name)
);

-- Assemblages certifiés (communs à tous)
CREATE TABLE certified_assembly (
  id          SERIAL PRIMARY KEY,
  server_id   INT NOT NULL REFERENCES server(id),
  name        VARCHAR(100) NOT NULL,
  varieties   JSONB NOT NULL, -- [{variety, min_pct, max_pct}, ...]
  ceepage_count SMALLINT NOT NULL CHECK (ceepage_count BETWEEN 2 AND 5)
);
```

### 1.3 Logique métier

| Règle | Détail |
|---|---|
| Densité plantation | `vine_count = FLOOR(area_m2 * 0.6)` (6000/ha) |
| Rendement optimal | À partir de la 4e saison (vine_age_days ≥ 336) |
| Rendement moyen | ~7 500 kg raisin/ha |
| Conversion raisin→vin | 1.5 kg = 1 L |
| Fermentation noirs | 7 jours (ferment_end = ferment_start + 7j) |
| Fermentation blancs | 3 jours |
| Élevage minimum | 42 jours en cuve après fermentation |
| Déclin qualité | Probabilité croissante si élevage > seuil (dépend compétences maître chai) |
| Assemblage | 2-5 cépages, même millésime, même couleur, jamais ré-assemblé |
| Maîtrise assemblage | HT = f(nb_cépages, elaboration, organization, control) ; rattachée au maître |
| Pierres | +10% HT travaux si stones_level > 0 ; broyage = 3 saisons (252j) |
| Vendangeur | Disponible 2j après embauche ; coût = 0.020 HT/kg raisin |
| Vente magasin | +2€/bouteille vs prix Cultivia ; nécessite vendeur caviste CDI |
| Concours Le Domaine | Septembre ; assemblages certifiés uniquement ; récompense = +prix 84j |
| Virement ferme→domaine | Irréversible, max 500 000 € cumulé |

### 1.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/vineyard` | Créer/débloquer domaine viticole |
| GET | `/api/vineyard` | Détails du domaine |
| POST | `/api/vineyard/transfer` | Virement ferme → domaine |
| POST | `/api/vineyard/loan` | Emprunt viticole |
| GET | `/api/vineyard/parcels` | Liste parcelles viticoles |
| POST | `/api/vineyard/parcels` | Acheter parcelle |
| POST | `/api/vineyard/parcels/:id/plant` | Planter cépage |
| POST | `/api/vineyard/parcels/:id/work` | Travaux vigne/sol |
| POST | `/api/vineyard/parcels/:id/harvest` | Vendanger |
| GET | `/api/vineyard/employees` | Liste personnel |
| POST | `/api/vineyard/employees` | Embaucher |
| DELETE | `/api/vineyard/employees/:id` | Licencier |
| GET | `/api/vineyard/buildings` | Bâtiments viticoles |
| POST | `/api/vineyard/buildings` | Construire |
| GET | `/api/vineyard/tanks` | Cuves |
| POST | `/api/vineyard/wine/ferment` | Lancer fermentation |
| POST | `/api/vineyard/wine/:id/decuve` | Décuver → élevage |
| POST | `/api/vineyard/wine/:id/assemble` | Assembler |
| POST | `/api/vineyard/wine/:id/barrel` | Mettre en fût |
| POST | `/api/vineyard/wine/:id/bottle` | Mettre en bouteille |
| POST | `/api/vineyard/wine/:id/sell` | Vendre (Cultivia) |
| POST | `/api/vineyard/shop/stock` | Transférer bouteilles → magasin |
| GET | `/api/vineyard/shop/sales` | Ventes magasin |
| GET | `/api/vineyard/grape-varieties` | Cépages disponibles (serveur) |
| GET | `/api/vineyard/assemblies` | Assemblages certifiés |
| POST | `/api/contests/vitisim/enter` | Inscrire vin au Le Domaine |

### 1.5 Tests

| # | Test | Assertion |
|---|---|---|
| T1.1 | Créer domaine sans déblocage actif | → 403 |
| T1.2 | Virement > 500 000 € cumulé | → rejeté |
| T1.3 | Planter parcelle 500 m² | vine_count = 300 |
| T1.4 | Planter parcelle 10 000 m² | vine_count = 6000 |
| T1.5 | Vendanger avant 2j post-embauche vendangeur | → 403 |
| T1.6 | Fermentation cépage noir → durée = 7j | ferment_end correct |
| T1.7 | Fermentation cépage blanc → durée = 3j | ferment_end correct |
| T1.8 | Décuver avant fin fermentation | → 400 |
| T1.9 | Stopper élevage avant 42j | → 400 |
| T1.10 | Assembler rouge + blanc | → 400 |
| T1.11 | Assembler 6 cépages | → 400 (max 5) |
| T1.12 | Assembler vin déjà assemblé | → 400 |
| T1.13 | Vente magasin sans vendeur CDI | → 403 |
| T1.14 | Vente magasin → prix = Cultivia + 2€ | vérifié |
| T1.15 | Le Domaine avec assemblage libre | → 400 |
| T1.16 | Récompense Le Domaine → award_until = now + 84j | vérifié |
| T1.17 | Rendement vigne < 4 saisons | < rendement optimal |
| T1.18 | Pierres → HT travaux +10% | vérifié |
| T1.19 | Conversion 7500 kg raisin → 5000 L vin | vérifié |
| T1.20 | Virement domaine → ferme | → 400 (irréversible) |

---

## 2. Forêts

### 2.1 Description

Chaque forêt = 20 stations de 1-3 ha chacune. Chaque station : essence, âge, hauteur, circonférence, type de sol, pente, faune. Travaux : broyage souche, fertilisation (120 kg/ha), labour, plantation (1 100 plants/ha), élagage, marquage, éclaircie, coupe finale. Matériel lourd (abatteuse, débusqueur, porteur). ETF possible. Vente bois aux usines.

### 2.2 Tables SQL

```sql
-- Forêt (propriété du joueur)
-- Réf: 01_DATA_MODEL §2.8
CREATE TABLE forest (
  id          SERIAL PRIMARY KEY,
  farm_id     INT NOT NULL REFERENCES farm(id),
  prefecture_id     INT NOT NULL REFERENCES zone(id),
  total_ha    DECIMAL(6,2) NOT NULL,
  road_km     DECIMAL(4,2) NOT NULL DEFAULT 0,
  track_km    DECIMAL(4,2) NOT NULL DEFAULT 0,
  depot_m2    INT NOT NULL DEFAULT 0,
  slope_pct   SMALLINT NOT NULL DEFAULT 0,
  bought_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  bought_price DECIMAL(12,2) NOT NULL
);

-- Station forestière (1-20 par forêt)
CREATE TABLE forest_station (
  id          SERIAL PRIMARY KEY,
  forest_id   INT NOT NULL REFERENCES forest(id),
  station_num SMALLINT NOT NULL CHECK (station_num BETWEEN 1 AND 20),
  area_ha     DECIMAL(4,2) NOT NULL CHECK (area_ha BETWEEN 1 AND 3),
  species     VARCHAR(50) NOT NULL,
  tree_age    INT NOT NULL DEFAULT 0,
  tree_count  INT NOT NULL DEFAULT 0,
  height_m    DECIMAL(4,1) NOT NULL DEFAULT 0,
  circumf_cm  DECIMAL(5,1) NOT NULL DEFAULT 0,
  diameter_cm DECIMAL(5,1) GENERATED ALWAYS AS (circumf_cm / 3.14159) STORED,
  soil_type   VARCHAR(30),
  soil_depth  VARCHAR(20),
  drainage    VARCHAR(20),
  vegetation  VARCHAR(50),
  situation   VARCHAR(30), -- 'plateau','slope','valley','ridge'
  watercourse BOOLEAN NOT NULL DEFAULT false,
  fauna       JSONB DEFAULT '[]', -- ['deer','boar','rabbit']
  stumps_cleared BOOLEAN NOT NULL DEFAULT true,
  last_work   VARCHAR(30),
  UNIQUE(forest_id, station_num)
);

-- Travaux forestiers (log)
CREATE TABLE forest_work (
  id          SERIAL PRIMARY KEY,
  station_id  INT NOT NULL REFERENCES forest_station(id),
  work_type   VARCHAR(30) NOT NULL CHECK (work_type IN (
    'stump_grinding','fertilization','plowing','planting',
    'game_protection','inter_row_clearing','formation_pruning',
    'phyto_treatment','pruning','marking','thinning','final_cut',
    'track_maintenance','road_maintenance','depot_maintenance'
  )),
  pa_spent    DECIMAL(6,2) NOT NULL,
  performed_by VARCHAR(10) NOT NULL DEFAULT 'player', -- 'player','etf'
  performed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Stock bois en dépôt
CREATE TABLE forest_wood_stock (
  id          SERIAL PRIMARY KEY,
  forest_id   INT NOT NULL REFERENCES forest(id),
  species     VARCHAR(50) NOT NULL,
  volume_m3   DECIMAL(10,2) NOT NULL DEFAULT 0,
  source_type VARCHAR(10) NOT NULL CHECK (source_type IN ('thinning','final_cut'))
);

-- ETF (Entreprise Travaux Forestiers)
CREATE TABLE etf (
  id          SERIAL PRIMARY KEY,
  player_id   INT NOT NULL REFERENCES player(id) UNIQUE,
  license_until TIMESTAMPTZ NOT NULL,
  rating      DECIMAL(3,1) NOT NULL DEFAULT 5.0,
  prefecture_id     INT NOT NULL REFERENCES zone(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Référentiel essences
CREATE TABLE tree_species (
  id              SERIAL PRIMARY KEY,
  name            VARCHAR(50) NOT NULL UNIQUE,
  growth_rate     DECIMAL(4,2) NOT NULL, -- cm hauteur/jour
  max_height_m    DECIMAL(5,1) NOT NULL,
  wood_price_m3   DECIMAL(8,2) NOT NULL,
  plants_per_ha   INT NOT NULL DEFAULT 1100
);
```

### 2.3 Logique métier

| Règle | Détail |
|---|---|
| Stations par forêt | Max 20, chacune 1-3 ha |
| Plantation | 1 100 plants/ha, manuelle |
| Fertilisation | 120 kg/ha, épandeur engrais + tracteur |
| Pente | Plus de pente = plus de HT pour tous travaux |
| Faune | Dégâts sur jeunes plants → protections gibier nécessaires |
| Élagage | À 2m, 4m, 6m selon âge du peuplement |
| Marquage | Repérer arbres avant éclaircie, kit manuel |
| Éclaircie | Diminue densité, favorise croissance restants |
| Coupe finale | Abat tous les arbres de la station |
| Broyage souche | Obligatoire avant replantation après coupe finale |
| Entretien piste/route | HT proportionnel à la longueur |
| Volume bois | Dépend sol + travaux effectués (tous travaux = max bois) |
| Vente bois | Aux usines, prix variable selon essence et volume |
| Cours d'eau | +croissance, +risque enlisement matériel |

### 2.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/forests` | Mes forêts |
| POST | `/api/forests` | Acheter forêt |
| GET | `/api/forests/:id/stations` | Stations de la forêt |
| POST | `/api/forests/:id/stations/:num/work` | Effectuer travaux |
| GET | `/api/forests/:id/wood` | Stock bois en dépôt |
| POST | `/api/forests/:id/wood/sell` | Vendre bois (usine) |
| POST | `/api/etf` | Créer ETF |
| GET | `/api/etf/jobs` | Missions ETF disponibles |
| POST | `/api/etf/jobs/:id/accept` | Accepter mission |

### 2.5 Tests

| # | Test | Assertion |
|---|---|---|
| T2.1 | Créer station n°21 | → 400 (max 20) |
| T2.2 | Station de 4 ha | → 400 (max 3) |
| T2.3 | Planter sans broyage souche après coupe | → 400 |
| T2.4 | Fertilisation → 120 kg/ha appliqué | vérifié |
| T2.5 | Plantation → tree_count = area_ha × 1100 | vérifié |
| T2.6 | Pente 30% → HT > pente 0% | vérifié |
| T2.7 | Éclaircie → tree_count diminue, croissance augmente | vérifié |
| T2.8 | Coupe finale → volume bois en dépôt | vérifié |
| T2.9 | Vente bois → prix selon essence | vérifié |
| T2.10 | Tous travaux faits → volume max | vérifié |

---

## 3. Foie gras

### 3.1 Description

Élevage d'oies (Alsace, Landes, Toulouse) et canards (Barbarie) pour production de foie gras. 3 phases d'élevage de 7j chacune, puis gavage (4j oie, 3j canard). Coût HT : 0.27 HT/oie, 0.0625 HT/canard. Abattage 0.25 HT. Foie : 700g oie, 400g canard. 4 modes de vente : non préparé, sous vide, mi-cuit, conserve.

### 3.2 Tables SQL

```sql
-- Lot foie gras (par animal)
-- Réf: 01_DATA_MODEL §6.8
CREATE TABLE foie_gras_batch (
  id            SERIAL PRIMARY KEY,
  farm_id       INT NOT NULL REFERENCES farm(id),
  animal_id     BIGINT NOT NULL REFERENCES animal(id),
  species       VARCHAR(10) NOT NULL CHECK (species IN ('goose','duck')),
  breed_name    VARCHAR(50) NOT NULL, -- 'Alsace','Landes','Toulouse','Barbarie'
  phase         VARCHAR(20) NOT NULL CHECK (phase IN (
    'rearing_1','rearing_2','rearing_3','gavage','slaughtered','processed'
  )),
  phase_start   TIMESTAMPTZ NOT NULL DEFAULT now(),
  phase_day     SMALLINT NOT NULL DEFAULT 0,
  -- Résultats abattage
  liver_g       INT, -- 700 oie, 400 canard
  carcass_kg    DECIMAL(6,2),
  -- Produit final
  product_type  VARCHAR(20) CHECK (product_type IN ('raw','vacuum','semi_conserve','conserve')),
  dlc           TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_foie_gras_farm ON foie_gras_batch(farm_id, phase);

-- Référentiel races foie gras
CREATE TABLE foie_gras_breed (
  id              SERIAL PRIMARY KEY,
  species         VARCHAR(10) NOT NULL CHECK (species IN ('goose','duck')),
  name            VARCHAR(50) NOT NULL UNIQUE,
  gavage_days     SMALLINT NOT NULL, -- 4 oie, 3 canard
  pa_per_gavage   DECIMAL(6,4) NOT NULL, -- 0.27 oie, 0.0625 canard
  liver_g         INT NOT NULL, -- 700 oie, 400 canard
  pa_slaughter    DECIMAL(4,2) NOT NULL DEFAULT 0.25
);

-- DLC par mode de vente
-- raw: 3j, vacuum: 21j, semi_conserve: 180j, conserve: 4 saisons (336j)
```

### 3.3 Logique métier

| Règle | Détail |
|---|---|
| Phases élevage | 3 phases × 7 jours = 21 jours total |
| Gavage oie | 4 jours, 0.27 HT/oie/jour |
| Gavage canard | 3 jours, 0.0625 HT/canard/jour |
| Abattage | 0.25 HT/animal |
| Foie oie | 700 g |
| Foie canard | 400 g |
| Transition phase | Automatique au tick si phase_day ≥ 7 (élevage) ou gavage_days |
| DLC raw | 3 jours |
| DLC vacuum | 21 jours |
| DLC semi_conserve | 180 jours |
| DLC conserve | 336 jours (4 saisons) |
| Races oie | Alsace, Landes, Toulouse |
| Race canard | Barbarie |

### 3.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/foie-gras/start` | Démarrer lot (animal_id) |
| GET | `/api/foie-gras/batches` | Mes lots en cours |
| POST | `/api/foie-gras/:id/gavage` | Gaver (quotidien) |
| POST | `/api/foie-gras/:id/slaughter` | Abattre |
| POST | `/api/foie-gras/:id/process` | Transformer (raw/vacuum/semi/conserve) |
| POST | `/api/foie-gras/:id/sell` | Vendre |

### 3.5 Tests

| # | Test | Assertion |
|---|---|---|
| T3.1 | Démarrer lot avec vache | → 400 (oie/canard uniquement) |
| T3.2 | Gavage avant fin phase 3 | → 400 |
| T3.3 | Gavage oie → 4 jours requis | vérifié |
| T3.4 | Gavage canard → 3 jours requis | vérifié |
| T3.5 | HT gavage oie = 0.27/animal | vérifié |
| T3.6 | HT gavage canard = 0.0625/animal | vérifié |
| T3.7 | Abattage → liver_g = 700 (oie) | vérifié |
| T3.8 | Abattage → liver_g = 400 (canard) | vérifié |
| T3.9 | HT abattage = 0.25 | vérifié |
| T3.10 | DLC conserve = 336j | vérifié |
| T3.11 | Vente après DLC | → 400 (expiré) |


---

## 4. Méthanisation

### 4.1 Description

Unité de méthanisation (CAR ou ferme individuelle). Substrats solides (fumier, paille vrac, céréale immature, résidus) et liquides (lisier). Digesteur 7 jours. Biogaz → électricité (2 kWh/m³) ou HVC (0.7 L/m³). Digestat : 80% liquide, 20% solide (fertilisant). Pannes possibles, entretien régulier.

### 4.2 Tables SQL

```sql
-- Unité de méthanisation
-- Réf: 01_DATA_MODEL §6.5
CREATE TABLE methanizer (
  id            SERIAL PRIMARY KEY,
  owner_type    VARCHAR(5) NOT NULL CHECK (owner_type IN ('car','farm')),
  car_id        INT REFERENCES coop_regional(id),
  farm_id       INT REFERENCES farm(id),
  digestor_capacity_m3 INT NOT NULL,
  elec_mode     BOOLEAN NOT NULL DEFAULT true, -- true=électricité, false=HVC
  wear_pct      DECIMAL(5,2) NOT NULL DEFAULT 0,
  is_broken     BOOLEAN NOT NULL DEFAULT false,
  last_maintenance TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK ((car_id IS NOT NULL) OR (farm_id IS NOT NULL))
);

-- Chargement substrat dans le digesteur
CREATE TABLE methanizer_load (
  id            SERIAL PRIMARY KEY,
  methanizer_id INT NOT NULL REFERENCES methanizer(id),
  substrate_type VARCHAR(20) NOT NULL CHECK (substrate_type IN (
    'manure','slurry','straw_bulk','immature_cereal','crop_residue'
  )),
  phase         VARCHAR(10) NOT NULL CHECK (phase IN ('solid','liquid')),
  quantity_kg   DECIMAL(10,2) NOT NULL,
  loaded_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  digest_end    TIMESTAMPTZ NOT NULL, -- loaded_at + 7 jours
  -- Résultats
  biogas_m3     DECIMAL(10,2), -- calculé à digest_end
  digestat_solid_kg DECIMAL(10,2), -- 20% du digestat
  digestat_liquid_l DECIMAL(10,2), -- 80% du digestat
  processed     BOOLEAN NOT NULL DEFAULT false
);
CREATE INDEX idx_methanizer_load ON methanizer_load(methanizer_id, processed);

-- Production énergie (log quotidien)
CREATE TABLE methanizer_production (
  id            SERIAL PRIMARY KEY,
  methanizer_id INT NOT NULL REFERENCES methanizer(id),
  game_day      INT NOT NULL,
  biogas_m3     DECIMAL(10,2) NOT NULL,
  elec_kwh      DECIMAL(10,2), -- biogas × 2
  hvc_l         DECIMAL(10,2), -- biogas × 0.7
  produced_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 4.3 Logique métier

| Règle | Détail |
|---|---|
| Digestion | 7 jours (digest_end = loaded_at + 7j) |
| Biogaz → Électricité | 2 kWh par m³ de biogaz |
| Biogaz → HVC | 0.7 L par m³ de biogaz |
| Digestat | 80% liquide (épandable comme lisier), 20% solide (épandable comme fumier) |
| Pannes | Probabilité croissante avec wear_pct ; is_broken = true → production stoppée |
| Entretien | Réduit wear_pct, diminue risque panne |
| Substrats solides | Fumier, paille vrac, céréale immature, résidus culture |
| Substrats liquides | Lisier |
| Mode | Choix électricité OU HVC (pas les deux simultanément) |

### 4.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/methanizer` | Construire unité |
| GET | `/api/methanizer/:id` | Détails unité |
| POST | `/api/methanizer/:id/load` | Charger substrat |
| POST | `/api/methanizer/:id/mode` | Changer mode (elec/hvc) |
| POST | `/api/methanizer/:id/maintain` | Entretenir |
| POST | `/api/methanizer/:id/repair` | Réparer panne |
| GET | `/api/methanizer/:id/production` | Historique production |
| GET | `/api/methanizer/:id/digestat` | Stock digestat |

### 4.5 Tests

| # | Test | Assertion |
|---|---|---|
| T4.1 | Charger substrat → digest_end = +7j | vérifié |
| T4.2 | Mode elec : 10 m³ biogaz → 20 kWh | vérifié |
| T4.3 | Mode hvc : 10 m³ biogaz → 7 L | vérifié |
| T4.4 | Digestat 100 kg → 80 L liquide + 20 kg solide | vérifié |
| T4.5 | Charger unité en panne | → 400 |
| T4.6 | Entretien → wear_pct diminue | vérifié |
| T4.7 | Substrat invalide (lait) | → 400 |
| T4.8 | Capacité dépassée | → 400 |

---

## 5. Chevaux

### 5.1 Description

47 races : 20 selle, 14 trait, 13 poney. 3 catégories de rations selon le type. Écurie obligatoire. Pré mars-novembre, ration hivernale décembre-février. Gestation 11 mois (77 jours Cultivia). Indices génétiques : Physique, Mental, Sociabilité.

### 5.2 Tables SQL

```sql
-- Les chevaux utilisent les tables existantes animal, animal_breed, animal_species
-- Ajout des races spécifiques via INSERT dans animal_breed

-- Rations équines (3 catégories)
CREATE TABLE horse_ration (
  id          SERIAL PRIMARY KEY,
  category    VARCHAR(10) NOT NULL CHECK (category IN ('saddle','draft','pony')),
  season      VARCHAR(10) NOT NULL CHECK (season IN ('summer','winter')),
  name        VARCHAR(60) NOT NULL,
  components  JSONB NOT NULL, -- {hay: X, oats: Y, barley: Z, ...} kg/jour
  water_l     DECIMAL(6,1) NOT NULL,
  total_kg    DECIMAL(8,2) NOT NULL,
  UNIQUE(category, season, name)
);

-- Suivi pâturage équin
CREATE TABLE horse_pasture (
  id          SERIAL PRIMARY KEY,
  animal_id   BIGINT NOT NULL REFERENCES animal(id),
  parcel_id   INT NOT NULL REFERENCES parcel(id),
  start_month SMALLINT NOT NULL DEFAULT 3, -- mars
  end_month   SMALLINT NOT NULL DEFAULT 11, -- novembre
  season_year INT NOT NULL,
  UNIQUE(animal_id, season_year)
);
```

### 5.3 Logique métier

| Règle | Détail |
|---|---|
| Races | 20 selle + 14 trait + 13 poney = 47 races |
| Hébergement | Écurie obligatoire (building.type = 'ecurie') |
| Pré | Mars (mois 3) à novembre (mois 11) |
| Ration hivernale | Décembre à février, en écurie |
| Gestation | 11 mois Cultivia = 77 jours réels |
| Catégories ration | Selle, Trait, Poney — besoins différents |
| Indices génétiques | Physique, Mental, Sociabilité |
| Corral | Accessoire écurie, espace extérieur |

### 5.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/horses` | Mes chevaux (filtre breed category) |
| POST | `/api/horses/buy` | Acheter cheval |
| POST | `/api/horses/:id/feed` | Nourrir (ration catégorie) |
| POST | `/api/horses/:id/pasture` | Mettre au pré |
| POST | `/api/horses/:id/stable` | Rentrer en écurie |
| POST | `/api/horses/:id/breed` | Monte naturelle |
| GET | `/api/horses/rations` | Rations par catégorie/saison |

### 5.5 Tests

| # | Test | Assertion |
|---|---|---|
| T5.1 | Mettre au pré en décembre | → 400 (hors période mars-nov) |
| T5.2 | Mettre au pré en mars | → 200 |
| T5.3 | Nourrir selle avec ration poney | → 400 (mauvaise catégorie) |
| T5.4 | Gestation → durée = 77 jours | vérifié |
| T5.5 | Cheval sans écurie | → 400 |
| T5.6 | Ration hivernale en été | → 400 (pas nécessaire, au pré) |

---

## 6. Bisons & Daims

### 6.1 Description

Élevage en prairie boisée. Bison : 1 ha/animal, clôture 2m obligatoire, corral pour manipulation. Monte naturelle uniquement. Saisons d'accouplement spécifiques. Daims : densité plus élevée, même infrastructure.

### 6.2 Tables SQL

```sql
-- Les bisons/daims utilisent les tables animal existantes
-- Infrastructure spécifique

-- Prairie boisée (type parcelle spécial)
-- parcel.type = 'wooded_pasture' déjà supporté

-- Clôture haute (accessoire parcelle)
CREATE TABLE high_fence (
  id          SERIAL PRIMARY KEY,
  parcel_id   INT NOT NULL REFERENCES parcel(id) UNIQUE,
  height_m    DECIMAL(3,1) NOT NULL DEFAULT 2.0 CHECK (height_m >= 2.0),
  length_m    INT NOT NULL,
  installed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  wear_pct    DECIMAL(5,2) NOT NULL DEFAULT 0
);

-- Corral de manipulation
-- Utilise building.type existant ou vineyard_building
-- Ajout via building_type: 'corral_bison'

-- Saisons accouplement
CREATE TABLE mating_season (
  id          SERIAL PRIMARY KEY,
  species     VARCHAR(20) NOT NULL, -- 'bison','deer'
  start_month SMALLINT NOT NULL,
  end_month   SMALLINT NOT NULL,
  UNIQUE(species)
);
-- INSERT: bison juillet-septembre, daim octobre-novembre
```

### 6.3 Logique métier

| Règle | Détail |
|---|---|
| Prairie boisée | Obligatoire (parcel.type = 'wooded_pasture') |
| Densité bison | 1 ha / animal minimum |
| Densité daim | Plus élevée (~3-5 / ha) |
| Clôture | 2m minimum obligatoire |
| Corral | Nécessaire pour manipulation (pesée, tri, soins) |
| Reproduction | Monte naturelle uniquement (pas d'IA) |
| Accouplement bison | Juillet-septembre |
| Accouplement daim | Octobre-novembre |
| Alimentation | Pâturage prairie boisée + complément hivernal |

### 6.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/parcels/:id/fence` | Installer clôture haute |
| POST | `/api/animals/bison/buy` | Acheter bison |
| POST | `/api/animals/deer/buy` | Acheter daim |
| POST | `/api/animals/:id/mate` | Monte naturelle |
| GET | `/api/animals/mating-seasons` | Saisons accouplement |

### 6.5 Tests

| # | Test | Assertion |
|---|---|---|
| T6.1 | Bison sur parcelle non boisée | → 400 |
| T6.2 | Bison sans clôture 2m | → 400 |
| T6.3 | 2 bisons sur 1 ha | → 400 (densité max) |
| T6.4 | Monte bison en décembre | → 400 (hors saison) |
| T6.5 | Monte bison en août | → 200 |
| T6.6 | Monte daim en octobre | → 200 |
| T6.7 | IA sur bison | → 400 (naturelle uniquement) |


---

## 7. IVRAD

### 7.1 Description

Programme de préservation des races rares. Objectifs Génétiques (OG) : présenter des adultes nés à la ferme avec valeur génétique minimale. Places limitées par race. Races : Bordelaise, Bleue du Nord, Porc Gascon, Col Noir du Valais, Blackface. Reproduction naturelle uniquement, ~10% réussite. Salon GénétIvrad en mai.

### 7.2 Tables SQL

```sql
-- Programme IVRAD
CREATE TABLE ivrad_program (
  id              SERIAL PRIMARY KEY,
  server_id       INT NOT NULL REFERENCES server(id),
  breed_id        INT NOT NULL REFERENCES animal_breed(id),
  max_places      INT NOT NULL,
  min_genetic_value DECIMAL(6,2) NOT NULL, -- seuil OG
  UNIQUE(server_id, breed_id)
);

-- Places IVRAD attribuées
CREATE TABLE ivrad_place (
  id          SERIAL PRIMARY KEY,
  program_id  INT NOT NULL REFERENCES ivrad_program(id),
  player_id   INT NOT NULL REFERENCES player(id),
  granted_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  revoked_at  TIMESTAMPTZ,
  UNIQUE(program_id, player_id)
);

-- Objectifs Génétiques (soumissions)
CREATE TABLE ivrad_submission (
  id          SERIAL PRIMARY KEY,
  program_id  INT NOT NULL REFERENCES ivrad_program(id),
  player_id   INT NOT NULL REFERENCES player(id),
  animal_id   BIGINT NOT NULL REFERENCES animal(id),
  genetic_value DECIMAL(6,2) NOT NULL,
  is_adult    BOOLEAN NOT NULL,
  born_on_farm BOOLEAN NOT NULL,
  status      VARCHAR(10) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','accepted','rejected')),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### 7.3 Logique métier

| Règle | Détail |
|---|---|
| Races IVRAD | Bordelaise, Bleue du Nord, Porc Gascon, Col Noir du Valais, Blackface |
| Reproduction | Naturelle uniquement, ~10% taux de réussite |
| OG | Animal adulte + né à la ferme + genetic_value ≥ seuil |
| Places | Limitées par race, attribuées selon résultats OG |
| Salon GénétIvrad | Mai, présentation des meilleurs reproducteurs |
| Pas d'IA | Insémination artificielle interdite pour races IVRAD |

### 7.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/ivrad/programs` | Programmes IVRAD (races, places) |
| GET | `/api/ivrad/my-places` | Mes places IVRAD |
| POST | `/api/ivrad/submit` | Soumettre animal pour OG |
| GET | `/api/ivrad/submissions` | Mes soumissions |
| POST | `/api/contests/genetivrad/enter` | Inscrire au salon GénétIvrad |

### 7.5 Tests

| # | Test | Assertion |
|---|---|---|
| T7.1 | Soumettre animal non adulte | → 400 |
| T7.2 | Soumettre animal acheté (pas né ferme) | → 400 |
| T7.3 | Soumettre genetic_value < seuil | → rejected |
| T7.4 | IA sur race IVRAD | → 400 |
| T7.5 | Monte naturelle IVRAD → ~10% réussite | vérifié (stat) |
| T7.6 | Demander place quand max atteint | → 400 |
| T7.7 | GénétIvrad hors mai | → 400 |

---

## 8. Arboriculture

### 8.1 Description

11 espèces fruitières en verger (5 ha max). Matériel spécialisé ≤80 CV. Filet anti-grêle (1/ha). Chambre froide pour petits fruits (3j max). Calibrage selon espèce. Plantation déc-jan (ou oct-nov petits fruits). Récolte manuelle quotidienne. Très gourmand en main d'œuvre.

### 8.2 Tables SQL

```sql
-- Référentiel espèces arboricoles
-- Réf: 01_DATA_MODEL §2.5
CREATE TABLE tree_type (
  id              SERIAL PRIMARY KEY,
  name            VARCHAR(50) NOT NULL UNIQUE,
  trees_per_ha    INT NOT NULL,
  plant_months    SMALLINT[] NOT NULL, -- {12,1} ou {10,11}
  harvest_months  SMALLINT[] NOT NULL,
  optimal_age_days INT NOT NULL, -- âge optimal en jours
  price_per_kg_min DECIMAL(6,2) NOT NULL,
  price_per_kg_max DECIMAL(6,2) NOT NULL,
  needs_cold_storage BOOLEAN NOT NULL DEFAULT false,
  cold_storage_days SMALLINT DEFAULT 0, -- 3j pour petits fruits
  caliber_options JSONB, -- ['70/75','75/80'] ou ['A','B','C'] ou null
  max_ha          DECIMAL(4,2) NOT NULL DEFAULT 5.0
);
-- INSERT 11 espèces: pommier(1000/ha), pêcher(476), poirier(1200),
-- prunier(250), mirabellier(200), framboisier(5000), groseillier(2500),
-- myrtillier(2000), noyer(100), olivier(248), cerisier(500)

-- Verger (instance)
-- Réf: 01_DATA_MODEL §2.6
CREATE TABLE orchard (
  id            SERIAL PRIMARY KEY,
  parcel_id     INT NOT NULL REFERENCES parcel(id),
  tree_type_id  INT NOT NULL REFERENCES tree_type(id),
  tree_count    INT NOT NULL,
  tree_age_days INT NOT NULL DEFAULT 0,
  dead_trees    INT NOT NULL DEFAULT 0,
  hail_net      BOOLEAN NOT NULL DEFAULT false,
  hail_net_count INT NOT NULL DEFAULT 0, -- 1 par ha
  last_prune    TIMESTAMPTZ,
  last_thin     TIMESTAMPTZ,
  planted_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Récolte arboricole (par jour de ramassage)
CREATE TABLE orchard_harvest (
  id          SERIAL PRIMARY KEY,
  orchard_id  INT NOT NULL REFERENCES orchard(id),
  quantity_kg DECIMAL(10,2) NOT NULL,
  quality     SMALLINT NOT NULL CHECK (quality BETWEEN 1 AND 3),
  caliber     VARCHAR(10),
  harvested_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Rendements arboricoles par région
CREATE TABLE orchard_yield_region (
  id            SERIAL PRIMARY KEY,
  tree_type_id  INT NOT NULL REFERENCES tree_type(id),
  region_id     INT NOT NULL REFERENCES region(id),
  yield_ton_ha  DECIMAL(6,2), -- NULL = non cultivable
  UNIQUE(tree_type_id, region_id)
);
```

### 8.3 Logique métier

| Règle | Détail |
|---|---|
| Surface max | 5 ha par verger |
| Matériel | Tracteur ≤ 80 CV ou tracteur arboricole |
| Filet anti-grêle | 1 par hectare, stocké en entrepôt arboricole |
| Chambre froide | Obligatoire pour framboise, groseille, myrtille, cerise (3j max) |
| Calibrage | Pommier 70/75-75/80mm, poirier 55-70mm, prunier 35-50mm, etc. |
| Récolte | Manuelle, quotidienne obligatoire (fruits perdus sinon) |
| Qualité | 1=mauvaise, 2=moyenne, 3=bonne (inversé : Q1 se vend plus cher en arbo) |
| Âge optimal | Variable par espèce (1 an framboisier → 8 ans mirabellier) |
| Traitements | 25€/L, 3 L/ha, jusqu'à 21 applications/an |
| Arbres morts | Enlèvement régulier nécessaire |

### 8.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/orchards` | Mes vergers |
| POST | `/api/orchards` | Planter verger |
| POST | `/api/orchards/:id/prune` | Tailler |
| POST | `/api/orchards/:id/thin` | Éclaircir |
| POST | `/api/orchards/:id/treat` | Traiter |
| POST | `/api/orchards/:id/harvest` | Récolter (quotidien) |
| POST | `/api/orchards/:id/hail-net` | Installer filet anti-grêle |
| POST | `/api/orchards/:id/remove-dead` | Enlever arbres morts |
| GET | `/api/orchards/tree-types` | Référentiel espèces |
| GET | `/api/orchards/yields/:regionId` | Rendements régionaux |

### 8.5 Tests

| # | Test | Assertion |
|---|---|---|
| T8.1 | Verger > 5 ha | → 400 |
| T8.2 | Tracteur > 80 CV en verger | → 400 |
| T8.3 | Framboise sans chambre froide après 3j | → produit perdu |
| T8.4 | Grêle sans filet | → récolte très faible |
| T8.5 | Grêle avec filet | → récolte protégée |
| T8.6 | Récolte non ramassée le jour même | → fruits perdus |
| T8.7 | Pommier 1000 arbres/ha sur 2 ha | tree_count = 2000 |
| T8.8 | Rendement avant âge optimal | < rendement max |
| T8.9 | Traitement arbo → 3 L/ha, 25€/L | coût vérifié |
| T8.10 | 22e traitement dans l'année | → 400 (max 21) |

---

## 9. Haies

### 9.1 Description

Plantation sept-nov (0.05 HT/plant, 1.50€/plant). Taille déc-fév (0.003 HT/arbre, 1-2 kg bois/arbre). Déchiquetage déc-août (5T/HT). Mortalité 2%/saison. Bonus rendement cultures adjacentes. Litière alternative (30% de la paille). Bois déchiqueté : chauffage serre (2.8-3.5 KW/kg).

### 9.2 Tables SQL

```sql
-- Haie (bordure de parcelle)
-- Réf: 01_DATA_MODEL §2.7
CREATE TABLE hedge (
  id          SERIAL PRIMARY KEY,
  parcel_id   INT NOT NULL REFERENCES parcel(id) UNIQUE,
  plant_count INT NOT NULL,
  alive_count INT NOT NULL, -- plant_count - morts
  planted_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_trim   TIMESTAMPTZ,
  wood_cut_kg DECIMAL(10,2) NOT NULL DEFAULT 0, -- bois coupé non déchiqueté
  wood_chip_kg DECIMAL(10,2) NOT NULL DEFAULT 0  -- bois déchiqueté
);

-- Plateforme bois déchiqueté
CREATE TABLE wood_chip_platform (
  id          SERIAL PRIMARY KEY,
  farm_id     INT NOT NULL REFERENCES farm(id),
  capacity_t  INT NOT NULL DEFAULT 10000,
  stock_kg    DECIMAL(12,2) NOT NULL DEFAULT 0,
  cost_per_t  DECIMAL(6,2) NOT NULL DEFAULT 1.0
);
```

### 9.3 Logique métier

| Règle | Détail |
|---|---|
| Plantation | 1er sept – 7 nov, 0.05 HT/plant, 1.50 €/plant |
| Taille | 1er déc – 7 fév, 0.003 HT/arbre, produit 1-2 kg bois/arbre |
| Mise en andain | 0.2 HT/tonne, tracteur + chargeur frontal/télescopique |
| Déchiquetage | 1er déc – 7 août, 5 T bois/PA (0.2 HT/T), tracteur + broyeur branches |
| Bois perdu | Si non déchiqueté avant 7 août → perdu |
| Mortalité | 2% des plants/saison, remplacement sept-nov |
| Stockage | Plateforme bois déchiqueté, 1€/T, max 10 000 T, 1T = 4 m³ |
| Litière | 30% de la paille habituelle, non mélangeable avec paille |
| Chauffage serre | 2.8-3.5 KW/kg bois déchiqueté (chaudière polycombustible) |
| Bonus rendement | Augmentation rendement cultures/vergers adjacents |
| Bonus maladie | Risque réduit si haie présente |
| Bonus abreuvement | Animaux au pré consomment moins d'eau |

### 9.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/parcels/:id/hedge/plant` | Planter haie |
| POST | `/api/parcels/:id/hedge/trim` | Tailler haie |
| POST | `/api/parcels/:id/hedge/chip` | Déchiqueter bois |
| POST | `/api/parcels/:id/hedge/replace` | Remplacer plants morts |
| GET | `/api/hedges` | Mes haies |
| GET | `/api/wood-chips` | Stock bois déchiqueté |
| POST | `/api/wood-chips/use-litter` | Utiliser comme litière |
| POST | `/api/wood-chips/use-heating` | Utiliser pour chauffage |

### 9.5 Tests

| # | Test | Assertion |
|---|---|---|
| T9.1 | Planter haie en décembre | → 400 (hors période sept-nov) |
| T9.2 | Planter haie en octobre | → 200 |
| T9.3 | HT plantation 100 plants | = 5 HT (0.05×100) |
| T9.4 | Coût 100 plants | = 150€ (1.50×100) |
| T9.5 | Taille en mars | → 400 (hors période déc-fév) |
| T9.6 | Taille 1000 arbres → HT | = 3 HT (0.003×1000) |
| T9.7 | Bois/arbre | entre 1 et 2 kg |
| T9.8 | Déchiquetage 10T → HT | = 2 HT (10/5) |
| T9.9 | Déchiquetage en septembre | → 400 (après 7 août) |
| T9.10 | Mortalité tick → 2% morts | alive_count diminue |
| T9.11 | Litière = 30% paille habituelle | vérifié |
| T9.12 | Litière + paille même bâtiment | → 400 (non mélangeable) |
| T9.13 | Chauffage 1 kg bois → 2.8-3.5 KW | vérifié |


---

# PHASE 6 — SOCIAL & MÉTA

---

## 10. Chambre Agricole

### 10.1 Description

Organe de représentation des joueurs. 3 représentants par région, élections avril-juin (3j délibération + 4j vote). 11 types de décisions régionales et nationales (taux taxe, prix HVC, salaire gardien, prix miscanthus, prix luzerne, etc.). Votes à la majorité.

### 10.2 Tables SQL

```sql
-- Représentants Chambre Agricole
-- Réf: 01_DATA_MODEL §5.8
CREATE TABLE chamber_representative (
  id          SERIAL PRIMARY KEY,
  region_id   INT NOT NULL REFERENCES region(id),
  player_id   INT NOT NULL REFERENCES player(id),
  seat_num    SMALLINT NOT NULL CHECK (seat_num BETWEEN 1 AND 3),
  elected_at  TIMESTAMPTZ NOT NULL,
  term_end    TIMESTAMPTZ NOT NULL, -- 1 an Cultivia (84j)
  UNIQUE(region_id, seat_num)
);

-- Élections Chambre Agricole
CREATE TABLE chamber_election (
  id            SERIAL PRIMARY KEY,
  region_id     INT NOT NULL REFERENCES region(id),
  seat_num      SMALLINT NOT NULL,
  phase         VARCHAR(15) NOT NULL CHECK (phase IN ('candidacy','deliberation','voting','closed')),
  candidacy_start TIMESTAMPTZ NOT NULL, -- avril
  deliberation_start TIMESTAMPTZ, -- 3 jours
  voting_start  TIMESTAMPTZ, -- 4 jours
  voting_end    TIMESTAMPTZ,
  winner_id     INT REFERENCES player(id)
);

CREATE TABLE chamber_candidate (
  id          SERIAL PRIMARY KEY,
  election_id INT NOT NULL REFERENCES chamber_election(id),
  player_id   INT NOT NULL REFERENCES player(id),
  program     TEXT,
  votes       INT NOT NULL DEFAULT 0,
  UNIQUE(election_id, player_id)
);

CREATE TABLE chamber_ballot (
  id          SERIAL PRIMARY KEY,
  election_id INT NOT NULL REFERENCES chamber_election(id),
  voter_id    INT NOT NULL REFERENCES player(id),
  candidate_id INT NOT NULL REFERENCES chamber_candidate(id),
  voted_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(election_id, voter_id)
);

-- Votes/décisions Chambre Agricole
CREATE TABLE chamber_vote (
  id              SERIAL PRIMARY KEY,
  decision_type   VARCHAR(40) NOT NULL CHECK (decision_type IN (
    'tax_rate','hvc_price','guard_salary','miscanthus_price','alfalfa_price',
    'coop_margin','market_fee','energy_subsidy','bio_premium',
    'transport_tax','land_tax'
  )),
  scope           VARCHAR(10) NOT NULL CHECK (scope IN ('regional','national')),
  region_id       INT REFERENCES region(id),
  server_id       INT REFERENCES server(id),
  proposed_value  DECIMAL(12,2) NOT NULL,
  current_value   DECIMAL(12,2) NOT NULL,
  proposer_id     INT NOT NULL REFERENCES player(id),
  deliberation_end TIMESTAMPTZ NOT NULL, -- +3 jours
  voting_end      TIMESTAMPTZ NOT NULL, -- +4 jours après délibération
  votes_for       INT NOT NULL DEFAULT 0,
  votes_against   INT NOT NULL DEFAULT 0,
  status          VARCHAR(10) NOT NULL DEFAULT 'deliberation' CHECK (status IN ('deliberation','voting','passed','rejected')),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE chamber_vote_ballot (
  id          SERIAL PRIMARY KEY,
  vote_id     INT NOT NULL REFERENCES chamber_vote(id),
  rep_id      INT NOT NULL REFERENCES chamber_representative(id),
  choice      BOOLEAN NOT NULL, -- true=pour, false=contre
  voted_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(vote_id, rep_id)
);
```

### 10.3 Logique métier

| Règle | Détail |
|---|---|
| Représentants | 3 par région |
| Élections | Avril-juin, mandat 1 an Cultivia (84j) |
| Délibération | 3 jours (discussion, pas de vote) |
| Vote | 4 jours, majorité simple |
| 11 décisions | tax_rate, hvc_price, guard_salary, miscanthus_price, alfalfa_price, coop_margin, market_fee, energy_subsidy, bio_premium, transport_tax, land_tax |
| Scope | Régional (3 reps de la région) ou national (tous les reps du serveur) |
| Candidature | Tout joueur de la région avec Licence Pro actif |

### 10.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/cesa/representatives` | Représentants (par région) |
| GET | `/api/cesa/elections` | Élections en cours |
| POST | `/api/cesa/elections/:id/candidate` | Se porter candidat |
| POST | `/api/cesa/elections/:id/vote` | Voter |
| GET | `/api/cesa/decisions` | Décisions en cours |
| POST | `/api/cesa/decisions` | Proposer décision (rep uniquement) |
| POST | `/api/cesa/decisions/:id/vote` | Voter sur décision (rep uniquement) |

### 10.5 Tests

| # | Test | Assertion |
|---|---|---|
| T10.1 | 4e candidat même siège | → autorisé (élection) |
| T10.2 | Voter hors période vote | → 400 |
| T10.3 | Voter 2 fois même élection | → 400 |
| T10.4 | Proposer décision (non-rep) | → 403 |
| T10.5 | Délibération = 3j puis vote = 4j | timing vérifié |
| T10.6 | Majorité pour → status = passed | vérifié |
| T10.7 | Majorité contre → status = rejected | vérifié |
| T10.8 | Décision nationale → tous reps votent | vérifié |

---

## 11. Classements

### 11.1 Description

15 classements par activité + palmarès général. Calcul hebdomadaire (tick). Catégories : Animaux, Cultures, Concessionnaires, Ateliers, ETA, Transport, CIA, Coopératives, Laiterie, Maraîchage, Viticulture, Forêts/ETF, Génétique, Production, Parrains.

### 11.2 Tables SQL

```sql
-- Réf: 01_DATA_MODEL §7.6
CREATE TABLE ranking (
  id          SERIAL PRIMARY KEY,
  server_id   INT NOT NULL REFERENCES server(id),
  player_id   INT NOT NULL REFERENCES player(id),
  category    VARCHAR(30) NOT NULL CHECK (category IN (
    'animals','crops','dealership','workshop','eta','transport',
    'cia','cooperatives','dairy','market_garden','viticulture',
    'forestry','genetics','production','sponsors','overall'
  )),
  score       DECIMAL(14,2) NOT NULL DEFAULT 0,
  rank        INT,
  season      INT NOT NULL, -- saison de calcul
  computed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(server_id, player_id, category, season)
);
CREATE INDEX idx_ranking_category ON ranking(server_id, category, season, rank);

-- Palmarès historique (top 10 par saison)
CREATE TABLE hall_of_fame (
  id          SERIAL PRIMARY KEY,
  server_id   INT NOT NULL REFERENCES server(id),
  player_id   INT NOT NULL REFERENCES player(id),
  category    VARCHAR(30) NOT NULL,
  rank        SMALLINT NOT NULL CHECK (rank BETWEEN 1 AND 10),
  score       DECIMAL(14,2) NOT NULL,
  season      INT NOT NULL,
  UNIQUE(server_id, category, season, rank)
);
```

### 11.3 Logique métier

| Règle | Détail |
|---|---|
| Calcul | Hebdomadaire (tick dimanche) |
| 16 catégories | 15 activités + overall |
| Score animaux | Concours par catégorie d'âge, primes/espèce |
| Score cultures | Rendements, surfaces, diversité |
| Score overall | Agrégation pondérée de tous les scores |
| Palmarès | Top 10 archivé chaque saison |
| Cache | Redis `rankings:{server_id}:{category}` TTL 1h |

### 11.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/rankings/:category` | Classement par catégorie |
| GET | `/api/rankings/:category/me` | Mon rang |
| GET | `/api/rankings/overall` | Palmarès général |
| GET | `/api/hall-of-fame/:category` | Historique par saison |

### 11.5 Tests

| # | Test | Assertion |
|---|---|---|
| T11.1 | Catégorie invalide | → 400 |
| T11.2 | Classement trié par score DESC | vérifié |
| T11.3 | Rank = position dans le tri | vérifié |
| T11.4 | Overall = agrégation | vérifié |
| T11.5 | Hall of fame = top 10 uniquement | vérifié |

---

## 12. Concours

### 12.1 Description

4 concours : Salon Agricole (animaux par race/âge), GénétiLab (meilleurs reproducteurs), GénétIvrad (races rares, mai), Le Domaine (vins, septembre). Primes Chambre Agricole pour lauréats. Récompenses = valorisation prix de vente.

### 12.2 Tables SQL

```sql
-- Réf: 01_DATA_MODEL §7.7
CREATE TABLE contest (
  id          SERIAL PRIMARY KEY,
  server_id   INT NOT NULL REFERENCES server(id),
  type        VARCHAR(20) NOT NULL CHECK (type IN ('salon','genetisim','genetivrad','vitisim')),
  season      INT NOT NULL,
  month       SMALLINT NOT NULL, -- mois Cultivia du concours
  status      VARCHAR(15) NOT NULL DEFAULT 'upcoming' CHECK (status IN (
    'upcoming','registration','judging','results','closed'
  )),
  reg_start   TIMESTAMPTZ,
  reg_end     TIMESTAMPTZ,
  results_at  TIMESTAMPTZ,
  UNIQUE(server_id, type, season)
);

CREATE TABLE contest_entry (
  id          SERIAL PRIMARY KEY,
  contest_id  INT NOT NULL REFERENCES contest(id),
  player_id   INT NOT NULL REFERENCES player(id),
  -- Polymorphe selon type concours
  animal_id   BIGINT REFERENCES animal(id),
  wine_batch_id INT REFERENCES wine_batch(id),
  -- Catégorie (âge, race, cépage...)
  category    VARCHAR(50),
  score       DECIMAL(8,2),
  rank        SMALLINT,
  prize_eur   DECIMAL(8,2) DEFAULT 0,
  award       VARCHAR(10) CHECK (award IN ('gold','silver','bronze')),
  entered_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_contest_entry ON contest_entry(contest_id, category, rank);
```

### 12.3 Logique métier

| Règle | Détail |
|---|---|
| Salon Agricole | Animaux par race et catégorie d'âge, primes Chambre Agricole |
| GénétiLab | Meilleurs reproducteurs, indices génétiques |
| GénétIvrad | Mai, races IVRAD uniquement |
| Le Domaine | Septembre, assemblages certifiés uniquement |
| Récompenses | Valorisation prix vente (+X%) pendant 84j |
| Inscription | Période limitée avant le concours |
| Jugement | Automatique selon critères (génétique, qualité vin, etc.) |

### 12.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/contests` | Concours en cours/à venir |
| GET | `/api/contests/:id` | Détails concours |
| POST | `/api/contests/:id/enter` | Inscrire (animal ou vin) |
| GET | `/api/contests/:id/results` | Résultats |
| GET | `/api/contests/:id/my-entries` | Mes inscriptions |

### 12.5 Tests

| # | Test | Assertion |
|---|---|---|
| T12.1 | Inscrire vin au Salon Agricole | → 400 (animaux uniquement) |
| T12.2 | Inscrire animal au Le Domaine | → 400 (vins uniquement) |
| T12.3 | Le Domaine assemblage libre | → 400 (certifié uniquement) |
| T12.4 | GénétIvrad race non-IVRAD | → 400 |
| T12.5 | GénétIvrad hors mai | → 400 |
| T12.6 | Inscription hors période | → 400 |
| T12.7 | Récompense → prize_eur > 0 pour top 3 | vérifié |

---

## 13. Lycée Agricole

### 13.1 Description

Centre de Formation Cultivia. Stagiaire + maître-exploitant, 42 jours. Stagiaire doit demander dans les 14j après inscription. Maître : ancienneté 168j min (1 stagiaire) → 504j (5 stagiaires). Bonus fin : +4j Licence Pro (si Licence Pro actif) + 25 000€ aide Chambre Agricole.

### 13.2 Tables SQL

```sql
-- Réf: 01_DATA_MODEL §7.3
CREATE TABLE cfsa (
  id          SERIAL PRIMARY KEY,
  trainee_id  INT NOT NULL REFERENCES player(id),
  master_id   INT NOT NULL REFERENCES player(id),
  started_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  ends_at     TIMESTAMPTZ NOT NULL, -- started_at + 42 jours
  completed   BOOLEAN NOT NULL DEFAULT false,
  bonus_simpass_days SMALLINT DEFAULT 0, -- +4j si Licence Pro actif
  bonus_money DECIMAL(10,2) DEFAULT 0, -- 25000€
  UNIQUE(trainee_id) -- 1 seul Lycée Agricole par stagiaire
);

-- Capacité maître (calculée dynamiquement selon ancienneté)
-- 168j → 1, 252j → 2, 336j → 3, 420j → 4, 504j+ → 5
```

### 13.3 Logique métier

| Règle | Détail |
|---|---|
| Durée | 42 jours |
| Délai inscription stagiaire | 14 jours après création compte |
| Ancienneté maître | 168j = 1 stagiaire, +84j = +1, max 5 à 504j |
| Capacité maître | `FLOOR((seniority_days - 168) / 84) + 1`, max 5 |
| Bonus Licence Pro | +4 jours si stagiaire a Licence Pro actif à la fin |
| Bonus argent | 25 000 € crédités au stagiaire |
| Fin automatique | Au tick du 42e jour, completed = true, bonus distribués |

### 13.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/lycee-agricole/request` | Demander formation (stagiaire) |
| POST | `/api/lycee-agricole/accept/:traineeId` | Accepter stagiaire (maître) |
| GET | `/api/lycee-agricole/my-training` | Mon Lycée Agricole en cours |
| GET | `/api/lycee-agricole/my-trainees` | Mes stagiaires (maître) |
| GET | `/api/lycee-agricole/available-masters` | Maîtres disponibles |

### 13.5 Tests

| # | Test | Assertion |
|---|---|---|
| T13.1 | Demander Lycée Agricole après 15j | → 400 (délai 14j dépassé) |
| T13.2 | Maître avec 100j ancienneté | → 400 (min 168j) |
| T13.3 | Maître 168j → max 1 stagiaire | vérifié |
| T13.4 | Maître 504j → max 5 stagiaires | vérifié |
| T13.5 | Fin 42j → completed = true | vérifié |
| T13.6 | Fin avec Licence Pro → +4j Licence Pro | vérifié |
| T13.7 | Fin → +25 000€ au stagiaire | vérifié |
| T13.8 | 2e Lycée Agricole même stagiaire | → 400 |


---

## 14. Parrainage

### 14.1 Description

Un joueur parraine un nouveau joueur. Bonus : +4 à +10 jours Licence Pro pour le parrain quand le filleul souscrit un Licence Pro. Classement des parrains.

### 14.2 Tables SQL

```sql
-- Réf: 01_DATA_MODEL §7.4
CREATE TABLE sponsorship (
  id          SERIAL PRIMARY KEY,
  sponsor_id  INT NOT NULL REFERENCES player(id),
  godchild_id INT NOT NULL REFERENCES player(id) UNIQUE, -- 1 seul parrain
  bonus_days  SMALLINT NOT NULL DEFAULT 0, -- 4-10 jours Licence Pro
  activated   BOOLEAN NOT NULL DEFAULT false, -- true quand filleul prend Licence Pro
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Bonus progressif selon nombre de filleuls actifs
-- 1-2 filleuls: +4j, 3-5: +6j, 6-9: +8j, 10+: +10j
```

### 14.3 Logique métier

| Règle | Détail |
|---|---|
| Condition activation | Filleul souscrit un Licence Pro |
| Bonus parrain | +4j (1-2 filleuls), +6j (3-5), +8j (6-9), +10j (10+) |
| Limite filleuls | Illimité |
| 1 parrain par filleul | godchild_id UNIQUE |
| Classement | Catégorie 'sponsors' dans ranking |

### 14.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/sponsorship` | Parrainer (code parrain à l'inscription) |
| GET | `/api/sponsorship/my-godchildren` | Mes filleuls |
| GET | `/api/sponsorship/my-sponsor` | Mon parrain |

### 14.5 Tests

| # | Test | Assertion |
|---|---|---|
| T14.1 | Filleul avec 2 parrains | → 400 (UNIQUE) |
| T14.2 | Filleul prend Licence Pro → bonus parrain | activated = true, bonus_days > 0 |
| T14.3 | 3e filleul actif → +6j | vérifié |
| T14.4 | 10e filleul actif → +10j | vérifié |
| T14.5 | Se parrainer soi-même | → 400 |

---

## 15. Garde de ferme

### 15.1 Description

Confier sa ferme à un gardien pendant une absence. Gardien rémunéré 120€/j par Cultivia. Max 5 fermes par gardien. 150€ prélevés au retour. Nécessite Licence Pro actif.

### 15.2 Tables SQL

```sql
-- Garde de ferme (via farm.guard_player_id existant + table détail)
CREATE TABLE farm_guard (
  id            SERIAL PRIMARY KEY,
  farm_id       INT NOT NULL REFERENCES farm(id),
  owner_id      INT NOT NULL REFERENCES player(id),
  guardian_id   INT NOT NULL REFERENCES player(id),
  daily_pay     DECIMAL(8,2) NOT NULL DEFAULT 120.00,
  return_fee    DECIMAL(8,2) NOT NULL DEFAULT 150.00,
  started_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  ended_at      TIMESTAMPTZ,
  max_duration  TIMESTAMPTZ NOT NULL, -- = license_expires du propriétaire
  is_active     BOOLEAN NOT NULL DEFAULT true,
  UNIQUE(farm_id, is_active) -- 1 garde active par ferme
);
CREATE INDEX idx_farm_guard_guardian ON farm_guard(guardian_id, is_active);
```

### 15.3 Logique métier

| Règle | Détail |
|---|---|
| Prérequis | Licence Pro actif pour le propriétaire |
| Rémunération gardien | 120 €/jour, payé par Cultivia (tick quotidien) |
| Max fermes/gardien | 5 simultanées |
| Coût retour | 150 € prélevés sur le compte du propriétaire |
| Durée max | Jusqu'à expiration du Licence Pro |
| Restriction | Le propriétaire ne doit pas garder une ferme lui-même |
| Gardien | Doit être ami du propriétaire |

### 15.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/api/farm-guard/start` | Activer garde (choisir gardien) |
| POST | `/api/farm-guard/stop` | Désactiver garde (retour) |
| GET | `/api/farm-guard/my-guards` | Fermes que je garde |
| GET | `/api/farm-guard/status` | Statut garde de ma ferme |
| GET | `/api/farm-guard/available` | Gardiens disponibles |

### 15.5 Tests

| # | Test | Assertion |
|---|---|---|
| T15.1 | Garde sans Licence Pro | → 403 |
| T15.2 | Gardien avec 5 fermes → 6e | → 400 |
| T15.3 | Rémunération quotidienne = 120€ | vérifié (tick) |
| T15.4 | Retour → -150€ propriétaire | vérifié |
| T15.5 | Propriétaire garde une ferme + demande garde | → 400 |
| T15.6 | Gardien non-ami | → 400 |
| T15.7 | Durée > Licence Pro restant | → 400 |

---

## 16. Forums + MP-Live

### 16.1 Description

Forums de discussion (principaux + régionaux, modération). Messagerie interne (30j rétention). MP-Live : messagerie instantanée cross-serveur via Redis pub/sub.

### 16.2 Tables SQL

```sql
-- Forums
CREATE TABLE forum (
  id          SERIAL PRIMARY KEY,
  server_id   INT REFERENCES server(id), -- NULL = cross-serveur
  region_id   INT REFERENCES region(id), -- NULL = forum principal
  name        VARCHAR(100) NOT NULL,
  type        VARCHAR(15) NOT NULL CHECK (type IN ('general','regional','help','trade','off_topic'))
);

CREATE TABLE forum_topic (
  id          SERIAL PRIMARY KEY,
  forum_id    INT NOT NULL REFERENCES forum(id),
  author_id   INT NOT NULL REFERENCES player(id),
  title       VARCHAR(200) NOT NULL,
  is_pinned   BOOLEAN NOT NULL DEFAULT false,
  is_locked   BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_post_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_forum_topic ON forum_topic(forum_id, last_post_at DESC);

CREATE TABLE forum_post (
  id          SERIAL PRIMARY KEY,
  topic_id    INT NOT NULL REFERENCES forum_topic(id),
  author_id   INT NOT NULL REFERENCES player(id),
  body        TEXT NOT NULL,
  is_moderated BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  edited_at   TIMESTAMPTZ
);

-- Messagerie interne
-- Réf: 01_DATA_MODEL §7.2
CREATE TABLE message (
  id          BIGSERIAL PRIMARY KEY,
  from_id     INT NOT NULL REFERENCES player(id),
  to_id       INT NOT NULL REFERENCES player(id),
  subject     VARCHAR(200),
  body        TEXT NOT NULL,
  is_read     BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at  TIMESTAMPTZ NOT NULL -- +30 jours
);
CREATE INDEX idx_message_to ON message(to_id, is_read, created_at DESC);

-- MP-Live (temps réel, via Redis pub/sub, pas de persistance longue)
CREATE TABLE mp_live_message (
  id          BIGSERIAL PRIMARY KEY,
  from_id     INT NOT NULL REFERENCES player(id),
  to_id       INT NOT NULL REFERENCES player(id),
  from_server INT NOT NULL REFERENCES server(id),
  body        TEXT NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Rétention courte (7j), nettoyage par cron
CREATE INDEX idx_mp_live ON mp_live_message(to_id, created_at DESC);
```

### 16.3 Logique métier

| Règle | Détail |
|---|---|
| Messages internes | Expiration 30 jours (tick quotidien supprime) |
| MP-Live | Cross-serveur via Redis pub/sub channel `mplive:{player_id}` |
| MP-Live persistance | 7 jours max (historique court) |
| Forums | Modération par bénévoles (is_moderated) |
| Forums régionaux | 1 par région, accès joueurs de la région |
| Topic verrouillé | Pas de nouveau post si is_locked = true |
| WebSocket | Canal `/ws` pour notifications temps réel + MP-Live |

### 16.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/forums` | Liste forums |
| GET | `/api/forums/:id/topics` | Topics d'un forum |
| POST | `/api/forums/:id/topics` | Créer topic |
| GET | `/api/forums/topics/:id/posts` | Posts d'un topic |
| POST | `/api/forums/topics/:id/posts` | Poster |
| GET | `/api/messages` | Messagerie (paginée) |
| POST | `/api/messages` | Envoyer message |
| PATCH | `/api/messages/:id/read` | Marquer lu |
| WS | `/ws/mplive` | MP-Live temps réel (cross-serveur) |

### 16.5 Tests

| # | Test | Assertion |
|---|---|---|
| T16.1 | Message expire après 30j | supprimé par tick |
| T16.2 | Post sur topic verrouillé | → 400 |
| T16.3 | MP-Live cross-serveur | message reçu sur autre serveur |
| T16.4 | Forum régional, joueur autre région | → 403 |
| T16.5 | MP-Live historique > 7j | nettoyé |

---

## 17. Multi-serveurs

### 17.1 Description

1 serveur France (normal). Chaque serveur = DB/schema séparé. Races exclusives par serveur. Tailles parcelles variables (200 ha CA/US). Aucun transfert argent/matériel entre serveurs. MP-Live cross-serveur seul lien. 1 compte par serveur (même email possible).

### 17.2 Tables SQL

```sql
-- Réf: 01_DATA_MODEL §1.1
-- La table server est déjà définie. Compléments :

CREATE TABLE server_config (
  id              SERIAL PRIMARY KEY,
  server_id       INT NOT NULL REFERENCES server(id) UNIQUE,
  max_parcel_ha   SMALLINT NOT NULL DEFAULT 100, -- 200 pour CA/US
  price_per_ha    DECIMAL(10,2) NOT NULL,
  price_maraich_m2 DECIMAL(6,2) NOT NULL,
  pa_per_day      DECIMAL(6,2) NOT NULL DEFAULT 35, -- 70 Expert (couple)
  has_employee    BOOLEAN NOT NULL DEFAULT true, -- false sur Expert
  region_count    SMALLINT NOT NULL,
  exclusive_breeds JSONB DEFAULT '[]', -- ['Oie Flamande', ...]
  exclusive_crops  JSONB DEFAULT '[]', -- ['cotton', 'rye']
  difficulty      SMALLINT NOT NULL CHECK (difficulty BETWEEN 1 AND 5)
);

-- Données de référence serveurs
-- FR1: diff 3, 100ha, 3000€/ha, 40HT
-- FR2: diff 2, 100ha, 3000€/ha, 40HT
-- FR3: diff 2, 100ha, 3000€/ha, 40HT
-- BE1: diff 3, 100ha, 7000€/ha, 40HT, exclusive: ['Oie Flamande']
-- CH1: diff 4, 100ha, 4250€/ha, 40HT, exclusive: ['Simmental','Nera Verzasca','Suisse','Engadine']
-- CA1: diff 3, 200ha, 3400€/ha, 40HT, exclusive: ['Ayrshire'], crops: ['rye']
-- US1: diff 4, 200ha, 3400€/ha, 40HT, exclusive: [US breeds], crops: ['cotton']
-- EXP: diff 5, 100ha, 4500€/ha, 70PA (couple), has_employee=false, 2 régions
```

### 17.3 Logique métier

| Règle | Détail |
|---|---|
| Isolation | Chaque serveur = schema/DB PostgreSQL séparé |
| Aucun transfert | Pas d'argent, matériel, animaux entre serveurs |
| 1 compte/serveur | Même email autorisé sur plusieurs serveurs |
| Parcelles CA/US | Max 200 ha (vs 100 ha standard) |
| Expert | 80 HT/jour (couple), pas d'employé salarié, 2 régions imaginaires |
| Expert ferme annexe | Pas de transfert argent depuis ferme principale |
| Races exclusives | Vérifiées à l'achat (breed.server_exclusive) |
| Cultures exclusives | Seigle (CA), Coton (US) |
| Cross-serveur | Uniquement MP-Live via Redis pub/sub |
| Déménagement vers Expert | Argent perdu, ancienneté + Licence Pro conservés |

### 17.4 Endpoints API

| Méthode | Endpoint | Description |
|---|---|---|
| GET | `/api/servers` | Liste serveurs + config |
| GET | `/api/servers/:id/config` | Config détaillée |
| POST | `/api/servers/:id/register` | S'inscrire sur un serveur |
| GET | `/api/servers/:id/exclusive-breeds` | Races exclusives |
| GET | `/api/servers/:id/exclusive-crops` | Cultures exclusives |

### 17.5 Tests

| # | Test | Assertion |
|---|---|---|
| T17.1 | Parcelle 201 ha sur FR1 | → 400 (max 100) |
| T17.2 | Parcelle 200 ha sur CA1 | → 200 |
| T17.3 | Acheter Oie Flamande sur FR1 | → 400 (exclusive BE1) |
| T17.4 | Acheter Oie Flamande sur BE1 | → 200 |
| T17.5 | Semer coton sur FR1 | → 400 (exclusive US1) |
| T17.6 | Expert → HT = 70/jour | vérifié |
| T17.7 | Expert → embaucher employé | → 400 |
| T17.8 | Transfert argent FR1 → FR2 | → 400 (impossible) |
| T17.9 | MP-Live FR1 → BE1 | → 200 (cross-serveur) |
| T17.10 | 2 comptes même serveur même email | → 400 |
| T17.11 | Même email sur FR1 + BE1 | → 200 |

---

# Annexes

## A. Dépendances entre features

```
Phase 5:
  Viticulture (1) ← standalone
  Forêts (2) ← Phase 0 (parcels, buildings)
  Foie gras (3) ← Phase 3 (animals)
  Méthanisation (4) ← Phase 0 (buildings), Phase 1 (crops → substrats)
  Chevaux (5) ← Phase 3 (animals, breeds)
  Bisons & Daims (6) ← Phase 3 (animals), Phase 0 (parcels)
  IVRAD (7) ← Phase 3 (animals, genetics)
  Arboriculture (8) ← Phase 0 (parcels), Phase 1 (crops)
  Haies (9) ← Phase 0 (parcels)

Phase 6:
  Chambre Agricole (10) ← Phase 0 (regions, players)
  Classements (11) ← toutes phases précédentes
  Concours (12) ← Phase 3 (animals), Phase 5.1 (viticulture), Phase 5.7 (IVRAD)
  Lycée Agricole (13) ← Phase 0 (players)
  Parrainage (14) ← Phase 0 (players)
  Garde de ferme (15) ← Phase 0 (farms, players)
  Forums + MP-Live (16) ← Phase 0 (players, servers)
  Multi-serveurs (17) ← Phase 0 (servers)
```

## B. Daily Tick — Ajouts Phases 5-6

```
Tick quotidien (ajouts) :
  1. Viticulture : croissance vigne, fermentation, élevage, déclin qualité
  2. Forêts : croissance arbres (hauteur, circonférence)
  3. Foie gras : progression phases (7j), gavage
  4. Méthanisation : digestion (7j), production biogaz, pannes aléatoires
  5. Chevaux : pré/écurie selon mois, gestation
  6. Bisons/Daims : saisons accouplement
  7. Haies : mortalité 2%/saison, bois perdu si non déchiqueté après 7 août
  8. Chambre Agricole : transitions élections, clôture votes
  9. Classements : calcul hebdomadaire (dimanche)
  10. Lycée Agricole : fin formation 42j, distribution bonus
  11. Garde : rémunération gardien 120€/j
  12. Messages : expiration 30j
  13. MP-Live : nettoyage > 7j
  14. Concours : transitions statut selon calendrier
```

## C. Résumé des tables ajoutées

| Phase | Feature | Tables | Nombre |
|---|---|---|---|
| 5.1 | Viticulture | vineyard, vineyard_parcel, vineyard_employee, vineyard_building, vineyard_tank, vineyard_barrel, wine_batch, wine_bottle_stock, grape_variety, certified_assembly | 10 |
| 5.2 | Forêts | forest, forest_station, forest_work, forest_wood_stock, etf, tree_species | 6 |
| 5.3 | Foie gras | foie_gras_batch, foie_gras_breed | 2 |
| 5.4 | Méthanisation | methanizer, methanizer_load, methanizer_production | 3 |
| 5.5 | Chevaux | horse_ration, horse_pasture | 2 |
| 5.6 | Bisons & Daims | high_fence, mating_season | 2 |
| 5.7 | IVRAD | ivrad_program, ivrad_place, ivrad_submission | 3 |
| 5.8 | Arboriculture | tree_type, orchard, orchard_harvest, orchard_yield_region | 4 |
| 5.9 | Haies | hedge, wood_chip_platform | 2 |
| 6.10 | Chambre Agricole | chamber_representative, chamber_election, chamber_candidate, chamber_ballot, chamber_vote, chamber_vote_ballot | 6 |
| 6.11 | Classements | ranking, hall_of_fame | 2 |
| 6.12 | Concours | contest, contest_entry | 2 |
| 6.13 | Lycée Agricole | lycee_agricole | 1 |
| 6.14 | Parrainage | sponsorship | 1 |
| 6.15 | Garde | farm_guard | 1 |
| 6.16 | Forums + MP | forum, forum_topic, forum_post, message, mp_live_message | 5 |
| 6.17 | Multi-serveurs | server_config | 1 |
| | **TOTAL** | | **53 tables** |

---

> **PHASE5_6_AVANCE.md — v1.0**
> 17 features, 53 tables, ~90 endpoints, ~130 tests
> Dépendances : Phases 0-4 requises
