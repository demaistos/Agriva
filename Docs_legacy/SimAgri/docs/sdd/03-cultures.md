# SDD 03 — Module Cultures (Cultures, Sol, Météo, Irrigation)

## 1. Parcelles

### Table
```sql
parcels (
  id            UUID PRIMARY KEY,
  player_id     UUID REFERENCES players,
  department_id INT REFERENCES departments,
  zone          INT CHECK (1..10),
  type          VARCHAR NOT NULL,  -- 'champ','pre','verger','prairie_boisee'
  size_ha       DECIMAL(6,2) NOT NULL,
  soil_quality  INT DEFAULT 2 CHECK (1..3),
  is_bio        BOOLEAN DEFAULT FALSE,
  bio_conversion_start DATE,
  bought_at     TIMESTAMP DEFAULT NOW(),
  buy_price     DECIMAL(12,2)
)

parcel_soil (
  parcel_id  UUID PRIMARY KEY REFERENCES parcels,
  azote      DECIMAL(8,2) DEFAULT 50,
  phosphore  DECIMAL(8,2) DEFAULT 50,
  potassium  DECIMAL(8,2) DEFAULT 50,
  calcium    DECIMAL(8,2) DEFAULT 50,
  magnesium  DECIMAL(8,2) DEFAULT 50,
  soufre     DECIMAL(8,2) DEFAULT 50,
  stones     BOOLEAN DEFAULT FALSE,
  stones_crushed_until DATE,
  last_analysis DATE
)
```

---

## 2. Cultures actives

### Table
```sql
crops (
  id              UUID PRIMARY KEY,
  parcel_id       UUID REFERENCES parcels,
  culture_type    VARCHAR NOT NULL,  -- 'ble','mais_grain','herbe_ray_grass'...
  technique       VARCHAR DEFAULT 'traditionnelle',  -- 'traditionnelle','tcs','semis_direct'
  seed_type       VARCHAR DEFAULT 'GP',  -- 'G','P','GP'
  sown_at         DATE NOT NULL,
  growth_pct      DECIMAL(5,2) DEFAULT 0,  -- 0-100%
  water_gauge     DECIMAL(5,2) DEFAULT 50, -- 0-100 (rouge si extrêmes)
  sun_gauge       DECIMAL(5,2) DEFAULT 50,
  is_treated      JSONB DEFAULT '{"fongicide":false,"herbicide":false,"insecticide":false}',
  fertilized      BOOLEAN DEFAULT FALSE,
  manured         BOOLEAN DEFAULT FALSE,  -- fumier épandu
  rolled          BOOLEAN DEFAULT FALSE,  -- rouleau passé
  harvested       BOOLEAN DEFAULT FALSE,
  straw_available BOOLEAN DEFAULT FALSE,  -- paille disponible après moisson
  quality         INT,  -- 1-3, calculé à la récolte
  disease         VARCHAR  -- NULL ou type de maladie active
)
```

---

## 3. Données de référence cultures

### Table
```sql
culture_definitions (
  id              SERIAL PRIMARY KEY,
  slug            VARCHAR UNIQUE NOT NULL,
  name            VARCHAR NOT NULL,
  sow_months      INT[] NOT NULL,         -- [10,11] pour Oct-Nov
  harvest_months  INT[] NOT NULL,
  base_price      DECIMAL(10,2),
  rotation_years  INT DEFAULT 1,
  seed_qty_per_ha DECIMAL(8,2) DEFAULT 150,
  harvest_tool    VARCHAR NOT NULL,        -- 'moissonneuse','ensileuse','arracheuse'...
  has_straw       BOOLEAN DEFAULT FALSE,
  treatment_count INT DEFAULT 2
)

culture_yields (
  id            SERIAL PRIMARY KEY,
  culture_id    INT REFERENCES culture_definitions,
  region_id     INT REFERENCES regions,
  yield_per_ha  DECIMAL(6,2)  -- tonnes/ha rendement moyen
)
```

---

## 4. Tick croissance (horaire)

```
Pour chaque crop non récoltée :
  if saison == 'hiver' AND culture_type == 'herbe':
    skip  // l'herbe ne pousse pas en hiver
  
  base_growth = 4% par jour (0.17% par heure)
  
  // Modificateurs
  if herbe AND herse_prairie_done: base_growth = 5% par jour
  
  // Météo du jour
  water_effect = calculateWaterEffect(crop.water_gauge)
  sun_effect = calculateSunEffect(crop.sun_gauge)
  
  actual_growth = base_growth * water_effect * sun_effect
  crop.growth_pct = min(100, crop.growth_pct + actual_growth)
```

---

## 5. Calcul rendement à la récolte

```
function calculateYield(crop, parcel):
  base = getRegionYield(crop.culture_type, parcel.region_id)
  
  multiplier = 1.0
  
  // Sol
  nutrients = getSoilNutrients(parcel.id)
  multiplier *= nutrientFactor(nutrients, crop.culture_type)  // 0.5 à 1.3
  
  // Qualité terre
  multiplier *= [0.8, 1.0, 1.2][parcel.soil_quality - 1]
  
  // Engrais
  if crop.fertilized: multiplier *= 1.15
  if crop.manured: multiplier *= 1.10
  
  // Traitements
  if crop.disease AND NOT crop.is_treated: multiplier *= 0.7
  
  // Météo
  multiplier *= gaugeBonus(crop.water_gauge)  // 0.6 à 1.1
  multiplier *= gaugeBonus(crop.sun_gauge)
  
  // Maturation
  multiplier *= maturationFactor(crop.growth_pct)  // 100% = 1.0, <100% = pénalité
  
  // Rouleau
  if crop.rolled: multiplier *= 1.04  // +3% à +5%
  
  // Pierres
  if parcel.stones AND NOT parcel.stones_crushed: multiplier *= 0.95
  
  // BIO
  if parcel.is_bio: multiplier *= 0.85  // rendement inférieur
  
  // Technique culturale
  if crop.technique == 'tcs': multiplier *= 0.95
  if crop.technique == 'semis_direct': multiplier *= 0.85
  
  return base * parcel.size_ha * multiplier
```

---

## 6. Météo

### Table
```sql
weather (
  id          SERIAL PRIMARY KEY,
  server_id   INT REFERENCES servers,
  meteo_zone  VARCHAR NOT NULL,  -- 'nord-ouest','nord-est','sud-est','sud-ouest'
  game_day    INT NOT NULL,
  level       INT CHECK (1..5),  -- 1=très ensoleillé, 5=forte pluie
  wind        BOOLEAN DEFAULT FALSE,
  hail        BOOLEAN DEFAULT FALSE
)
```

### Tick météo (journalier)
```
Pour chaque zone météo :
  Générer niveau météo basé sur :
    - Saison (plus pluie automne/hiver, plus soleil été)
    - Données historiques réelles par zone
    - Aléatoire pondéré
  
  wind = random < 0.1  // 10% de chance
  hail = random < 0.02 AND saison IN ('printemps','été')  // 2% rare
  
  Mettre à jour jauges eau/soleil de toutes les cultures de la zone
```

### Effets
| Niveau | Effet eau | Effet soleil | Travail parcelle |
|--------|-----------|-------------|-----------------|
| 1 Très ensoleillé | -2 | +4 | OK |
| 2 Ensoleillé | -1 | +2 | OK |
| 3 Mitigé | +1 | +1 | OK |
| 4 Pluie | +3 | -1 | OK |
| 5 Forte pluie | +5 | -2 | INTERDIT |

---

## 7. Irrigation

### Table
```sql
water_sources (
  id         UUID PRIMARY KEY,
  parcel_id  UUID REFERENCES parcels,
  level      INT CHECK (1..10),  -- 100K à 1M litres/jour
  type       VARCHAR DEFAULT 'forage'  -- 'forage','retenue_collinaire'
)

irrigation_equipment (
  id         UUID PRIMARY KEY,
  parcel_id  UUID REFERENCES parcels,
  type       VARCHAR NOT NULL,  -- 'enrouleur','pivot_central','rampe_pivot'
  is_active  BOOLEAN DEFAULT FALSE
)
```

### Logique
```
Si irrigation active ET source disponible :
  water_available = source.level * 100000  // litres/jour
  water_per_ha = water_available / parcel.size_ha
  crop.water_gauge += calculerApportEau(water_per_ha)
```

---

## 8. Rotation des cultures

### Table
```sql
parcel_history (
  id         UUID PRIMARY KEY,
  parcel_id  UUID REFERENCES parcels,
  culture    VARCHAR NOT NULL,
  season     INT NOT NULL,  -- numéro de saison
  yield      DECIMAL(10,2),
  quality    INT
)
```

### Vérification
```
function canSow(parcel_id, culture_type):
  rotation = getCultureRotation(culture_type)  // ex: 2 ans
  if is_bio: rotation += 1
  
  history = getParcelHistory(parcel_id, last_N_seasons=rotation)
  return culture_type NOT IN history.cultures
```

---

## 9. Cultures arboricoles

> Source : export france3.simagri.com — règles officielles.

### Tables
```sql
orchards (
  id          UUID PRIMARY KEY,
  parcel_id   UUID REFERENCES parcels,  -- type='verger', max 5 ha
  fruit_type  VARCHAR NOT NULL,  -- 'pommier','poirier','pecher','prunier','mirabellier','noyer','olivier','cerisier','framboisier','groseillier','myrtillier'
  tree_count  INT NOT NULL,
  dead_trees  INT DEFAULT 0,
  age_seasons INT DEFAULT 0,
  growth_pct  DECIMAL(5,2) DEFAULT 0,
  last_trim   DATE,
  has_hail_net BOOLEAN DEFAULT FALSE,
  has_irrigation BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMP DEFAULT NOW()
)

orchard_harvests (
  id          UUID PRIMARY KEY,
  orchard_id  UUID REFERENCES orchards,
  quantity_kg DECIMAL(10,2),
  quality     INT CHECK (1..3),
  caliber     VARCHAR,  -- '70/75mm','75/80mm','A','B','C'...
  harvested_at DATE
)
```

### Données de référence

| Culture | Arbres/ha | Plantation | Récolte | Prix moyen (€/kg) | Rendement optimal (ans) |
|---------|-----------|------------|---------|-------------------|------------------------|
| Pommier | 1000 | Déc-Jan | Sep-Oct | 0.51-0.65 | 4 |
| Poirier | 1200 | Déc-Jan | Sep-Oct | 0.55-0.95 | 4 |
| Pêcher | 476 | Déc-Jan | Jul-Sep | 1.25-1.90 | 4 |
| Prunier | 250 | Déc-Jan | Août-Sep | 0.90-1.10 | 6 |
| Mirabellier | 200 | Déc-Jan | Août-Sep | 1.20-1.50 | 8 |
| Noyer | 100 | Nov-Déc | Oct | 3.80-4.00 | 5 |
| Olivier | 248 | Déc-Fév | Nov | 4.00-4.20 | 5 |
| Cerisier | 500 | Déc-Jan | Mai-Jul | 1.90-2.10 | 5 |
| Framboisier | 5000 | Oct-Nov | Jul | 6.30-6.50 | 1 |
| Groseillier | 2500 | Oct-Nov | Jun-Août | 3.80-4.00 | 2 |
| Myrtillier | 2000 | Oct-Nov | Jul-Août | 4.00-4.20 | 3 |

### Matériel arboricole
- Tracteur 80 CV max ou tracteur arboricole
- Cultivateur 3m max, herse rotative 3m max
- Pulvérisateur porté 18m max ou pulvérisateur arboricole
- Vibreur hydraulique (noyer), ramasseuse arboricole (noyer)
- Broyeur 80CV max (noyer, cerisier)
- Plateau + chargeur frontal ou télescopique 80CV max

### Bâtiments arboricoles
- Entrepôt arboricole (m²) : stockage palox + filets anti-grêle
- Palox (kg) : récolte et stockage
- Filet anti-grêle : 1 par hectare
- Chambre froide (m²) : petits fruits rouges + cerises (stockage 3 jours max à 4°C)

---

## 10. Haies

### Table
```sql
hedges (
  id          UUID PRIMARY KEY,
  parcel_id   UUID REFERENCES parcels,
  plant_count INT NOT NULL,
  dead_count  INT DEFAULT 0,
  last_trim   DATE,
  wood_stock_kg DECIMAL(10,2) DEFAULT 0
)

wood_chip_platforms (
  player_id   UUID PRIMARY KEY REFERENCES players,
  quantity_kg DECIMAL(12,2) DEFAULT 0,
  capacity_t  DECIMAL(8,2) DEFAULT 0  -- 1€/tonne, max 10000t
)
```

### Cycle
1. **Plantation** (Sep 1 → Nov 7) : plants arbustes ~1.50€/unité, 0.05 h/plant
2. **Taille** (Déc 1 → Fév 7) : kit bûcheron, 0.003 h/arbre, bois coupé 1-2 kg/arbre, mise en andain 0.2 h/tonne (tracteur+chargeur frontal ou télescopique)
3. **Déchiquetage** (Déc 1 → Août 7) : tracteur + broyeur de branches, 0.2 h/tonne (5t bois/PA)
4. **Stockage** : plateforme bois déchiqueté, 4 m³/tonne
5. **Mortalité** : 2% des plants meurent par saison, remplacement possible en période plantation

### Bonus
- Cultures : rendement amélioré, réduction risque maladies
- Animaux au pré : réduction besoin en eau

### Utilisation bois déchiqueté
- **Litière** : alternative à la paille
- **Chauffage serre** : 2.8-3.5 KW/kg (vs miscanthus 5 KW/kg)

---

## 11. Filière pomme de terre

### Investissements
- **Ligne de stockage** : 100 000€ (trémie, déterreur, calibreur, table de visite, séparateur, remplisseur/videur palox)
- **Entrepôt PDT** : 100€/tonne (climatisé, palox empilés)

### Cycle
1. Récolte → stockage dans les 2 jours (sinon vente forcée à SimAgri à prix bas sous 7 jours)
2. Stockage possible jusqu'au 7 Juin saison suivante
3. Propositions de vente hebdomadaires (Déc → Juin) : min 2 propositions régionales/qualité + contrats nationaux/internationaux occasionnels
4. Transport vers usine/port/terminal à charge du producteur (via transporteur)
5. Stock non écoulé au 7 Juin = perdu

---

## 12. Céréale immature

- Cultures : blé, orge, avoine, triticale, seigle (seigle = Canada/USA/Expert uniquement)
- Récolte entre 60% et 80% de pousse, au plus tard le 7 mai
- Outil : ensileuse
- Rendement = 150% du rendement grain de base (varie selon pousse)
- Stockage : silo taupe
- Usage : méthanisation (substrat) ou alimentation bovins/caprins/ovins

---

## 13. Compostage

### En parcelle (14 jours)
1. **Mise en tas** : 3t fumier → 1t compost. Pour 1 ha : 15t compost = 45t fumier
2. **Retournement 1** : retourneur d'andains (ou ETA)
3. **Retournement 2** : idem
4. **Épandage** : épandeur à fumier, 15 T/ha

### À la ferme
- Aire de compostage (bâtiment)
- Fumier composté automatiquement dès le lendemain
- Retournements J4-5 et J9-10
- Compost prêt après 14 jours

### Apports nutritifs (15 T/ha)
| N | P | K | Ca | Mg | S |
|---|---|---|----|----|---|
| 95 | 60 | 120 | 180 | 35 | 60 |

---

## 14. Quotas

- **Betterave** : 2 ha de base OU 10% de la surface cultivée (hors prés printemps/automne et vergers) de l'année précédente
- **Tabac** : 2 ha max par exploitation, cultivé dans la région de l'exploitation uniquement

---

## 15. Écume de sucrerie

- Amendement calcique, très riche en calcium
- Épandage : 15 T/ha, épandeur à fumier, une fois tous les 5 ans
- Stockage : fosse à fumier ou directement en parcelle
- Achat : Coopérative SimAgri ou CAR

### Apports nutritifs (15 T/ha)
| N | P | K | Ca | Mg | S |
|---|---|---|----|----|---|
| 45 | 120 | 15 | 3600 | 90 | 0 |

---

## 16. Digestat (épandage)

### Apports nutritifs
| Type | N | P | K | Ca | Mg | S |
|------|---|---|---|----|----|---|
| Digestat liquide (25 m³/ha) | 125 | 50 | 300 | 47.5 | 17.5 | 14.25 |
| Digestat solide (25 T/ha) | 100 | 50 | 225 | 135 | 82.5 | 62.5 |
