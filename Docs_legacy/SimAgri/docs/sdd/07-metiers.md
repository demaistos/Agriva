# SDD 07 — Module Métiers annexes (Concessionnaire, Transporteur, CIA, CAR)

## 1. Concessionnaire

### Tables
```sql
dealerships (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  unlocked_at DATE,  -- 90 jours ancienneté + SimPass requis
  license_points INT DEFAULT 100
)

dealer_halls (
  id            UUID PRIMARY KEY,
  dealership_id UUID REFERENCES dealerships,
  size_sqm      INT DEFAULT 200,
  seller_id     UUID REFERENCES dealer_staff
)

dealer_licenses (
  id            UUID PRIMARY KEY,
  dealership_id UUID REFERENCES dealerships,
  brand         VARCHAR NOT NULL,
  points_used   INT NOT NULL,
  entry_fee     DECIMAL(10,2),
  revenue_share DECIMAL(4,2),  -- % CA reversé
  expires_at    DATE
)

dealer_staff (
  id            UUID PRIMARY KEY,
  dealership_id UUID REFERENCES dealerships,
  role          VARCHAR NOT NULL,  -- 'vendeur','mecanicien','vendeur_pieces'
  skill_wear    INT DEFAULT 5 CHECK (1..10),
  skill_pa      INT DEFAULT 5 CHECK (1..10),
  specialties   VARCHAR[],  -- marques spécialisées (max 3, mécanicien)
  salary        DECIMAL(10,2) DEFAULT 1400,
  age           INT DEFAULT 25,
  hired_at      DATE
)

dealer_workshops (
  id            UUID PRIMARY KEY,
  dealership_id UUID REFERENCES dealerships,
  repair_truck  BOOLEAN DEFAULT FALSE  -- camion atelier pour dépannage
)
```

### Fonctionnalités
- Vente matériel neuf (marge libre) et occasion
- Atelier : entretien (8-24€/PA) + dépannage (camion atelier pour intervention extérieure)
- Dépôt-vente (commission sur vente)
- Location tracteurs (si client en panne, ±5CV, durée = immobilisation)
- Pièces détachées : magasin (20 000€), vendeur dédié, marge 20-50%, remise 5-15% clients fidèles
- Réseau GPS : balise 20 000€/zone, récepteur 2 500€ (achat SimAgri, délai 2j), revente ~3 000€, installation 5PA mécanicien (150-300€), abonnement 400-600€/an/balise
- Relevage avant : installation 5PA mécanicien (150-300€), désinstallation 2PA (matériel neuf uniquement)

### Mécaniciens
- Compétences : 1 à 10 (usure et heures)
- Spécialités : max 3 marques par mécanicien
- Retraite à 60 ans
- Salaire mensuel

---

## 2. Transporteur

### Tables
```sql
transport_companies (
  id         UUID PRIMARY KEY,
  player_id  UUID REFERENCES players
)

trucks (
  id            UUID PRIMARY KEY,
  company_id    UUID REFERENCES transport_companies,
  definition_id INT REFERENCES truck_definitions,
  fuel_level    DECIMAL(10,2),
  wear          DECIMAL(5,2) DEFAULT 0
)

drivers (
  id          UUID PRIMARY KEY,
  company_id  UUID REFERENCES transport_companies,
  name        VARCHAR,
  pa_per_day  INT DEFAULT 25,
  salary      DECIMAL(10,2) DEFAULT 1400
)

transport_orders (
  id            UUID PRIMARY KEY,
  company_id    UUID REFERENCES transport_companies,
  client_id     UUID REFERENCES players,
  cargo_type    VARCHAR NOT NULL,
  cargo_qty     DECIMAL(10,2),
  origin_zone   INT,
  dest_zone     INT,
  price         DECIMAL(10,2),
  status        VARCHAR DEFAULT 'pending',  -- 'pending','in_transit','delivered'
  truck_id      UUID REFERENCES trucks,
  driver_id     UUID REFERENCES drivers
)
```

### Coûts transport
- Consommation camion : 24-28 L HVC/PA
- Prix fixé par le transporteur
- Licences requises

### Types de semi-remorques
Plateau, Benne, Citerne, Porte-engin, Grumier, Citerne à pulvérulent, Citerne agroalimentaire, Citerne lait

---

## 3. Centre d'Insémination Artificielle (CIA)

### Tables
```sql
cia_centers (
  id         UUID PRIMARY KEY,
  player_id  UUID REFERENCES players
)

cia_males (
  id         UUID PRIMARY KEY,
  cia_id     UUID REFERENCES cia_centers,
  animal_id  UUID REFERENCES animals,
  species    VARCHAR NOT NULL,
  genetics   JSONB,
  doses_available INT DEFAULT 0,
  price_per_dose DECIMAL(8,2)
)

cia_contracts (
  id          UUID PRIMARY KEY,
  cia_id      UUID REFERENCES cia_centers,
  client_id   UUID REFERENCES players,
  species     VARCHAR,
  start_date  DATE,
  end_date    DATE
)
```

### Fonctionnalités
- Catalogue de mâles reproducteurs avec indices génétiques
- Prélèvements → doses
- Contrats avec éleveurs
- Insémination à distance (inséminateur se déplace)

---

## 4. Coopérative Agricole Régionale (CAR)

### Tables
```sql
cooperatives (
  id          UUID PRIMARY KEY,
  region_id   INT REFERENCES regions,
  name        VARCHAR NOT NULL,
  balance     DECIMAL(15,2) DEFAULT 0
)

coop_members (
  id          UUID PRIMARY KEY,
  coop_id     UUID REFERENCES cooperatives,
  player_id   UUID REFERENCES players,
  shares      INT DEFAULT 1,  -- parts sociales
  role        VARCHAR DEFAULT 'member'  -- 'member','admin','president'
)

coop_contracts (
  id          UUID PRIMARY KEY,
  coop_id     UUID REFERENCES cooperatives,
  type        VARCHAR NOT NULL,  -- 'parcel','buy','sell'
  item_type   VARCHAR,
  price       DECIMAL(10,2),
  quantity    DECIMAL(10,2),
  player_id   UUID REFERENCES players
)

coop_store (
  id          UUID PRIMARY KEY,
  coop_id     UUID REFERENCES cooperatives,
  item_type   VARCHAR NOT NULL,
  quantity    DECIMAL(12,2),
  price       DECIMAL(10,2)
)
```

### Sous-activités CAR
- **Magasin libre-service** : vente aliments, produits, semences, engrais
- **Huilerie** : transformation colza → huile → HVC
- **Sucrerie** : transformation betterave → sucre + écume de sucrerie
- **Laiterie** : collecte lait (producteur → transporteur → laiterie) → transformation
- **Méthanisation** : substrats (fumier, lisier, maïs ensilé, paille vrac, céréale immature) → digesteur → biogaz → électricité/HVC + digestat (solide/liquide). Panne et usure du digesteur.
- **Emprunts** : prêts aux membres (taux variable)
- **Parts sociales** : chaque membre détient des parts, dividendes selon résultats
- **Achats/ventes entre CAR** : échanges inter-coopératives
- **Appels d'offre CAR** : contrats d'approvisionnement

---

## 5. ETA (Entreprise de Travaux Agricoles)

### Table
```sql
eta_services (
  id          UUID PRIMARY KEY,
  provider_id UUID REFERENCES players,
  service     VARCHAR NOT NULL,  -- 'labour','moisson','semis','fauchage'...
  price_per_ha DECIMAL(8,2),
  equipment_id UUID REFERENCES equipment,
  region_id   INT REFERENCES regions
)

eta_orders (
  id          UUID PRIMARY KEY,
  service_id  UUID REFERENCES eta_services,
  client_id   UUID REFERENCES players,
  parcel_id   UUID REFERENCES parcels,
  status      VARCHAR DEFAULT 'pending',
  completed_at TIMESTAMP
)
```

Le joueur propose ses services avec son propre matériel. Le client paie, l'ETA consomme ses PA et son HVC.

---

## 8. Méthanisation à la ferme

Distincte de la méthanisation CAR. Le joueur peut construire sa propre unité de méthanisation.

### Tables
```sql
farm_biogas_plants (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  digester_capacity DECIMAL(10,2),
  wear        DECIMAL(5,2) DEFAULT 0,
  is_broken   BOOLEAN DEFAULT FALSE
)
```

### Substrats acceptés
Fumier, lisier, maïs ensilé, paille en vrac, céréale immature, herbe ensilée

### Cycle
Substrats → Digesteur → Biogaz → Électricité (vente réseau) + HVC (carburant) + Digestat (solide/liquide, épandage)

### Panne et usure
Le digesteur s'use et peut tomber en panne. Entretien régulier nécessaire.

---

## 9. Laiterie (détail)

### Chaîne complète
1. **Producteur** : trait ses animaux, stocke le lait en cuve
2. **Transporteur** : collecte le lait (camion citerne) et livre à la laiterie
3. **Laiterie** (CAR) : transforme le lait en produits laitiers

### Contrats lait
```sql
milk_contracts (
  id          UUID PRIMARY KEY,
  producer_id UUID REFERENCES players,
  dairy_id    UUID REFERENCES cooperatives,
  milk_type   VARCHAR NOT NULL,  -- 'vache','chevre','brebis'
  price_per_l DECIMAL(6,4),
  quantity_l  DECIMAL(10,2),
  frequency   VARCHAR DEFAULT 'weekly'
)
```
