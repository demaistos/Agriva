# SDD 08 — Module Transformations (Fromagerie, Maraîchage, Foie gras, Viticulture, Foresterie)

## 1. Fromagerie

### Types de fromageries

| Type | Coût | Transformation/jour | PA max/jour | Vente |
|------|------|--------------------|-----------|----|
| Artisanale | 20 800 - 100 000€ | 250 - 1 250 L lait | 25 | Marchés |
| Industrielle | 198 000 - 910 000€ | 2 200 - 11 000 L lait | 220 | Grossistes/centrales |

- 5 modèles artisanaux, 9 modèles industriels (agrandissement progressif)
- Impossible de passer d'artisanale à industrielle sans destruction
- Industrielle nécessite déblocage (SimPass + ~1.80€)
- Fromagers : jusqu'à 10 employés (industrielle)

### Hygiène/propreté et matériel
- Nettoyage quotidien recommandé (après chaque utilisation)
- Fromagerie inutilisable le jour du nettoyage → nettoyer en fin de journée
- Matériel : entretien régulier, influence qualité fromage

### Matière première
- Lait de vache, chèvre ou brebis de l'exploitation uniquement
- Lait doit être transformé dans la journée (perdu sinon)
- Lait vache fromagerie comptabilisé dans quota laitier

### Tables
```sql
cheese_factories (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  type        VARCHAR NOT NULL,  -- 'fermiere','artisanale','industrielle'
  hygiene     DECIMAL(5,2) DEFAULT 100,
  equipment   JSONB  -- matériel spécifique
)

cheese_workers (
  id          UUID PRIMARY KEY,
  factory_id  UUID REFERENCES cheese_factories,
  skill       INT DEFAULT 5 CHECK (1..10),
  salary      DECIMAL(10,2)
)

cheese_production (
  id          UUID PRIMARY KEY,
  factory_id  UUID REFERENCES cheese_factories,
  cheese_type VARCHAR NOT NULL,
  milk_type   VARCHAR NOT NULL,  -- 'vache','chevre','brebis'
  milk_used   DECIMAL(10,2),
  quantity_kg DECIMAL(10,2),
  quality     INT CHECK (1..3),
  started_at  DATE,
  aging_days  INT,  -- durée affinage
  ready_at    DATE,
  dlc         DATE,  -- date limite consommation
  sold        BOOLEAN DEFAULT FALSE
)
```

### Sous-produits
- Crème et beurre (issus de la transformation)
- Vente sur marchés

---

## 2. Maraîchage

### Tables
```sql
greenhouses (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  type        VARCHAR NOT NULL,  -- 'plastique','verre'
  size_sqm    INT,
  heating     VARCHAR,  -- 'none','polycombustible','miscanthus','bois'
  temperature DECIMAL(4,1)
)

market_garden_crops (
  id            UUID PRIMARY KEY,
  greenhouse_id UUID REFERENCES greenhouses,
  crop_type     VARCHAR NOT NULL,  -- légumes variés
  sown_at       DATE,
  growth_pct    DECIMAL(5,2) DEFAULT 0,
  harvested     BOOLEAN DEFAULT FALSE
)

market_garden_staff (
  id            UUID PRIMARY KEY,
  player_id     UUID REFERENCES players,
  role          VARCHAR,
  salary        DECIMAL(10,2)
)
```

### Chauffage serres
- Chaudière polycombustible : miscanthus (5 KW/kg), bois déchiqueté (2.8-3.5 KW/kg), plaquettes bois
- Température contrôlée selon culture

---

## 3. Foie gras

### Table
```sql
foie_gras_production (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  animal_id   UUID REFERENCES animals,  -- oie ou canard race foie gras
  phase       VARCHAR NOT NULL,  -- 'elevage','pre_gavage','gavage','abattage'
  started_at  DATE,
  rations     JSONB,
  ready_at    DATE
)
```

### Cycle
1. Élevage (races spécifiques : Oie de Toulouse, Canard de Barbarie...)
2. Pré-gavage
3. Gavage (rations spéciales)
4. Abattage → foie gras + viande
5. Commercialisation (marchés, grossistes)

---

## 4. Viticulture

### Tables
```sql
vineyards (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  name        VARCHAR NOT NULL,  -- nom du domaine
  region_id   INT REFERENCES regions,
  balance     DECIMAL(15,2) DEFAULT 0
)

vine_parcels (
  id          UUID PRIMARY KEY,
  vineyard_id UUID REFERENCES vineyards,
  grape_type  VARCHAR NOT NULL,  -- cépage
  size_ha     DECIMAL(6,2),
  age_years   INT DEFAULT 0,
  growth_pct  DECIMAL(5,2) DEFAULT 0,
  health      DECIMAL(5,2) DEFAULT 100
)

wine_production (
  id          UUID PRIMARY KEY,
  vineyard_id UUID REFERENCES vineyards,
  vintage     INT,  -- année
  grape_type  VARCHAR,
  phase       VARCHAR NOT NULL,  -- 'vendange','vinification','assemblage','elevage','bouteille'
  quantity_l  DECIMAL(10,2),
  quality     INT CHECK (1..5),
  container   VARCHAR,  -- 'cuve','fut','bouteille'
  label       VARCHAR,
  medals      VARCHAR[]  -- concours gagnés
)

vine_staff (
  id          UUID PRIMARY KEY,
  vineyard_id UUID REFERENCES vineyards,
  role        VARCHAR,
  salary      DECIMAL(10,2)
)
```

### Cycle viticole
Plantation → Taille → Traitement → Vendange → Vinification → Assemblage → Élevage (fût/cuve) → Mise en bouteille → Vente + Concours

---

## 5. Foresterie

### Tables
```sql
forests (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  parcel_id   UUID REFERENCES parcels,
  tree_type   VARCHAR,
  tree_count  INT,
  age_years   INT DEFAULT 0,
  volume_m3   DECIMAL(10,2)
)

forestry_stations (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  type        VARCHAR  -- type de station
)

forestry_companies (  -- ETF
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players
)

wood_sales (
  id          UUID PRIMARY KEY,
  forest_id   UUID REFERENCES forests,
  volume_m3   DECIMAL(10,2),
  price       DECIMAL(10,2),
  buyer_id    UUID REFERENCES players,
  sold_at     TIMESTAMP
)
```

### Matériel forestier
- Abatteuse, débusqueur, porteur forestier (motorisés, consomment HVC)

---

## 6. Haies

### Table
```sql
hedges (
  id          UUID PRIMARY KEY,
  parcel_id   UUID REFERENCES parcels,
  plant_count INT,
  dead_count  INT DEFAULT 0,  -- 2% meurent par saison
  last_trim   DATE,
  wood_stock  DECIMAL(10,2) DEFAULT 0  -- kg bois coupé
)

wood_chip_storage (
  player_id   UUID PRIMARY KEY REFERENCES players,
  quantity_kg DECIMAL(12,2) DEFAULT 0,
  capacity_t  DECIMAL(8,2) DEFAULT 0  -- plateforme bois déchiqueté
)
```

### Cycle
Plantation (Sep-Nov) → Taille (Déc-Fév, kit bûcheron) → Déchiquetage (broyeur branches) → Stockage → Utilisation (litière ou chauffage serre)

### Bonus
- Rendement culture +X% si haie présente
- Risque maladie réduit
- Animaux au pré : moins d'eau nécessaire

---

## 7. Méthanisation

### Tables
```sql
biogas_plants (
  id          UUID PRIMARY KEY,
  owner_type  VARCHAR NOT NULL,  -- 'car' ou 'player'
  owner_id    UUID,  -- coop_id ou player_id
  digester_capacity DECIMAL(10,2),  -- m³
  wear        DECIMAL(5,2) DEFAULT 0
)

biogas_substrates (
  id          UUID PRIMARY KEY,
  plant_id    UUID REFERENCES biogas_plants,
  type        VARCHAR NOT NULL,  -- 'fumier','lisier','mais_ensile','paille_vrac','cereale_immature'...
  quantity    DECIMAL(10,2)
)
```

### Cycle
Substrats → Digesteur → Biogaz → Électricité (vente) + HVC (carburant) + Digestat (engrais solide/liquide)
