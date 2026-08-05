# SDD 06 — Module Économie (Marché, Coopérative, Prix, Banque, Parcelles)

## 0. Coopérative (V1 — implémenté)

Page `/market` — inspirée de la Coopérative SimAgri.

### Structure page
- **Toggle** Conventionnel / Bio
- **Catégories dépliables** dans le tableau (lignes beige cliquables ▸/▾)
- **Clic produit** → déplie panneau avec :
  - Mon stock (total en kg)
  - Vendeurs (🏪 Coopérative — 20 km — prix +15% — stock illimité)
- **Modale d'achat** : sélection tracteur → remorque (filtrée CV) → quantité → silo → récap trajets/heures/usure/coût

### Table `feed_types`
```sql
feed_types (
  id              SERIAL PRIMARY KEY,
  slug            VARCHAR(50) UNIQUE NOT NULL,
  name            VARCHAR(100) NOT NULL,
  species         VARCHAR(50),           -- espèce cible (volaille, bovin...)
  category        VARCHAR(50) DEFAULT 'Alimentation',
  subcategory     VARCHAR(50),
  price_per_ton   DECIMAL(10,2) NOT NULL,
  price_per_unit  DECIMAL(10,4),         -- prix/kg
  transport_family VARCHAR(50) DEFAULT 'benne',  -- benne, plateau
  unit            VARCHAR(20) DEFAULT 'kg'
)
```

### Catalogue V1
| Slug | Nom | Espèce | Catégorie | Prix/tonne | Transport |
|------|-----|--------|-----------|------------|-----------|
| grain_volaille | Ration volaille | volaille | Ration | 240€ | benne |
| foin_bovin | Foin + complément bovin | bovin | Ration | 180€ | benne |
| aliment_porc | Aliment complet porc | porcin | Ration | 320€ | benne |
| foin_ovin | Foin ovin | ovin | Ration | 150€ | benne |
| foin_caprin | Foin caprin | caprin | Ration | 150€ | benne |
| granules_lapin | Granulés lapin | lapin | Ration | 400€ | benne |
| foin_cheval | Foin + avoine | cheval | Ration | 200€ | benne |
| paille | Paille (balles 250kg) | — | Paille et foin | 60€ | plateau |
| foin_prairie | Foin de prairie (balles 250kg) | — | Paille et foin | 100€ | plateau |

### Prix coopérative
- Prix d'achat = `price_per_ton × 1.15` (+15% marge coopérative, comme SimAgri)
- Stock illimité
- Distance fixe : 20 km

### Stockage
- Aliments stockés dans silos/granges/hangars (table `storage`)
- 1 tonne ≈ 1.5 m³
- Capacité vérifiée avant achat

### Routes API (Marché)
| Méthode | Route | Description |
|---------|-------|-------------|
| GET | /market/feed-types | Catalogue aliments |
| GET | /market/feed-stock | Stock du joueur |
| POST | /market/feed/buy | Acheter (slug, tons, buildingId, tractorId, trailerId) |

### Routes API (Élevage)
| Méthode | Route | Description |
|---------|-------|-------------|
| GET | /animals | Mes lots |
| GET | /animals/catalog | Catalogue races |
| GET | /animals/wholesaler?slug=X | Stock grossiste |
| POST | /animals/buy-batch | Acheter au grossiste (items, tractorId, trailerId) |
| POST | /animals/sell | Vendre à l'abattoir (ids) |
| POST | /animals/merge | Regrouper des lots (ids) |
| POST | /animals/:id/split | Scinder un lot (quantity) |
| POST | /animals/move-batch | Déplacer (ids, buildingId) |
| PATCH | /animals/:id/rename | Renommer (name) |
| GET | /animals/eggs | Stock d'œufs |
| POST | /animals/eggs/sell | Vendre des œufs (caliber, quantity) |
| GET | /animals/accessories | Catalogue accessoires |
| GET | /animals/accessories/installed | Accessoires installés |
| POST | /animals/accessories/install | Installer (accessoryId, buildingId) |

### Prix des œufs
| Calibre | Prix unitaire | Âge poule |
|---------|---------------|-----------|
| S | 0.08€ | < 240 jours |
| M | 0.12€ | 240-400 jours |
| L | 0.18€ | 400-600 jours |
| XL | 0.25€ | > 600 jours |

Prix de vente = prix unitaire × `revenue_multiplier` du serveur.

---

## 1. Marché & prix

### Table
```sql
market_prices (
  id          SERIAL PRIMARY KEY,
  server_id   INT REFERENCES servers,
  item_type   VARCHAR NOT NULL,  -- 'ble','mais_grain','lait_vache'...
  base_price  DECIMAL(10,2),
  current_price DECIMAL(10,2),
  bio_premium DECIMAL(4,2) DEFAULT 1.20,  -- +20% pour BIO
  updated_at  TIMESTAMP
)

price_history (
  id         SERIAL PRIMARY KEY,
  server_id  INT REFERENCES servers,
  item_type  VARCHAR NOT NULL,
  price      DECIMAL(10,2),
  game_day   INT,
  recorded_at TIMESTAMP DEFAULT NOW()
)
```

### Tick prix (hebdomadaire = mensuel SimAgri)
```
Pour chaque item :
  supply = totalStockOnServer(item_type)
  demand = estimateDemand(item_type)  // basé sur consommation animale + ventes récentes
  
  ratio = demand / max(supply, 1)
  variation = clamp(ratio - 1, -0.15, +0.15)  // max ±15%
  
  new_price = base_price * (1 + variation) + random(-2, +2)
  new_price = clamp(new_price, base_price * 0.5, base_price * 2.0)
  
  market_prices.current_price = new_price
  INSERT INTO price_history(...)
```

---

## 2. Transactions

### Table
```sql
transactions (
  id          UUID PRIMARY KEY,
  server_id   INT REFERENCES servers,
  seller_id   UUID REFERENCES players,  -- NULL si coopérative
  buyer_id    UUID REFERENCES players,  -- NULL si coopérative
  item_type   VARCHAR NOT NULL,
  quantity    DECIMAL(12,2),
  unit_price  DECIMAL(10,2),
  total       DECIMAL(15,2),
  quality     INT,
  is_bio      BOOLEAN DEFAULT FALSE,
  type        VARCHAR NOT NULL,  -- 'coop_buy','coop_sell','player_trade','market','abattoir'
  created_at  TIMESTAMP DEFAULT NOW()
)
```

### Endpoints
| Méthode | Route | Description |
|---------|-------|-------------|
| GET | /market/prices | Prix actuels |
| GET | /market/history/:item | Historique prix |
| POST | /market/sell | Vendre à la coopérative |
| POST | /market/buy | Acheter à la coopérative |
| POST | /trades | Créer annonce de vente entre joueurs |
| POST | /trades/:id/accept | Accepter une annonce |

---

## 3. Banque

### Table
```sql
bank_accounts (
  player_id  UUID PRIMARY KEY REFERENCES players,
  balance    DECIMAL(15,2) DEFAULT 100000,
  savings    DECIMAL(15,2) DEFAULT 0
)

loans (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  car_id      UUID,  -- via Coopérative Agricole Régionale
  amount      DECIMAL(12,2),
  interest    DECIMAL(4,2),  -- taux annuel
  remaining   DECIMAL(12,2),
  monthly_payment DECIMAL(10,2),
  start_date  DATE,
  end_date    DATE
)

financial_log (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  type        VARCHAR NOT NULL,  -- 'income','expense','loan_payment','salary','electricity','fuel'...
  amount      DECIMAL(12,2),
  description VARCHAR,
  game_day    INT,
  created_at  TIMESTAMP DEFAULT NOW()
)
```

### Charges automatiques (tick mensuel)
```
Pour chaque joueur :
  // Salaires employés
  for emp in getEmployees(player_id):
    deduct(player_id, emp.salary, 'salary')
  
  // Facture électricité
  kwh = sumMonthlyKwh(player_id)
  deduct(player_id, kwh * 0.08, 'electricity')
  
  // Remboursement emprunts
  for loan in getActiveLoans(player_id):
    deduct(player_id, loan.monthly_payment, 'loan_payment')
    loan.remaining -= loan.monthly_payment
  
  // Assurances matériel
  // ...
```

---

## 4. Parcelles — Achat/Vente

### Endpoints
| Méthode | Route | Description |
|---------|-------|-------------|
| GET | /parcels/for-sale | Parcelles disponibles |
| POST | /parcels/buy | Acheter |
| POST | /parcels/:id/sell | Mettre en vente |
| POST | /parcels/:id/sell-to-simagri | Vendre à SimAgri (25% prix estimé, 5 saisons min) |

### Prix par pays
| Pays | Prix/ha |
|------|---------|
| France | 3 000 € |
| Belgique | 7 000 € |
| Suisse | 4 250 € |
| Canada | 3 400 € |
| USA | 3 400 € |
| Expert | 4 500 € |

### Taxe plus-value
```
function calculateTax(buy_price, sell_price, ownership_seasons):
  if sell_price <= buy_price: return 0  // pas de plus-value
  
  plus_value = sell_price - buy_price
  years = ownership_seasons / 4  // 4 saisons = 1 an SimAgri
  
  rates = {0: 0.90, 1: 0.80, 2: 0.70, 3: 0.60, 4: 0.55}
  rate = rates[min(floor(years), 4)] if years < 5 else 0.50
  
  return plus_value * rate
```

---

## 5. Annonces

### Table
```sql
listings (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  type        VARCHAR NOT NULL,  -- 'equipment','animal','product','parcel','service'
  item_id     UUID,
  title       VARCHAR,
  price       DECIMAL(12,2),
  quantity    DECIMAL(10,2),
  region_only BOOLEAN DEFAULT TRUE,
  friend_only BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMP DEFAULT NOW(),
  expires_at  TIMESTAMP
)
```

---

## 6. Grossistes et centrales d'achats

Canaux de vente alternatifs pour les productions transformées (fromage, légumes, foie gras, vin...).

```sql
wholesalers (
  id          UUID PRIMARY KEY,
  server_id   INT REFERENCES servers,
  name        VARCHAR NOT NULL,
  type        VARCHAR NOT NULL,  -- 'grossiste','centrale_achat'
  accepts     VARCHAR[] NOT NULL,  -- types de produits acceptés
  price_factor DECIMAL(4,2)  -- multiplicateur prix de base
)
```

---

## 7. Marchés

Vente directe sur les marchés pour fromagerie, maraîchage, foie gras.

```sql
markets (
  id          UUID PRIMARY KEY,
  region_id   INT REFERENCES regions,
  day_of_week INT,  -- jour du marché
  capacity    INT   -- nombre d'emplacements
)

market_stalls (
  id          UUID PRIMARY KEY,
  market_id   UUID REFERENCES markets,
  player_id   UUID REFERENCES players,
  products    JSONB,  -- produits en vente
  revenue     DECIMAL(12,2) DEFAULT 0
)
```

---

## 8. Organisme Partcel

Vente de parcelles par l'organisme Partcel :
- Parcelles conventionnelles au prix standard
- Parcelles BIO : +50% du prix standard
- Alternative à l'achat entre joueurs ou à SimAgri

---

## 9. Filière pomme de terre (économie)

Voir SDD 03 section 11 pour le détail du cycle stockage/commercialisation.
- Propositions de vente : régional (usine), national (usine), international (port/terminal)
- Transport à charge du producteur
- Cours PDT filière > cours PDT coopérative
