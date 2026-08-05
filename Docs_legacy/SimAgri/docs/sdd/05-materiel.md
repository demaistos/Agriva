# SDD 05 — Module Matériel (Matériel, HVC, Pannes, GPS, Combinés)

## 1. Matériel

### Table
```sql
equipment (
  id              UUID PRIMARY KEY,
  player_id       UUID REFERENCES players,
  definition_id   INT REFERENCES equipment_definitions,
  wear            DECIMAL(5,2) DEFAULT 0,     -- 0-100%
  pa_used         INT DEFAULT 0,              -- PA cumulés utilisés
  is_sheltered    BOOLEAN DEFAULT FALSE,       -- sous hangar
  building_id     UUID REFERENCES buildings,   -- hangar de stockage
  has_gps         BOOLEAN DEFAULT FALSE,
  has_front_lift  BOOLEAN DEFAULT FALSE,       -- relevage avant
  insurance_until DATE,
  is_broken       BOOLEAN DEFAULT FALSE,
  broken_until    DATE,
  is_shared       BOOLEAN DEFAULT FALSE,       -- achat en commun
  bought_at       TIMESTAMP DEFAULT NOW(),
  buy_price       DECIMAL(12,2)
)

equipment_definitions (
  id              SERIAL PRIMARY KEY,
  brand           VARCHAR NOT NULL,
  model           VARCHAR NOT NULL,
  family          VARCHAR NOT NULL,  -- 'tracteur','moissonneuse','charrue','benne','semoir'...
  is_motorized    BOOLEAN DEFAULT FALSE,
  horsepower      INT,               -- CV (si motorisé)
  required_hp     INT,               -- puissance tracteur requise (si tracté)
  width_m         DECIMAL(4,2),
  capacity        DECIMAL(10,2),     -- tonnes, litres, postes...
  capacity_unit   VARCHAR,           -- 't','l','m','postes'
  maneuverability INT CHECK (1..5),
  max_pa          INT,               -- PA totaux avant remplacement pièces
  fuel_work       DECIMAL(6,3),      -- L/CV/PA au travail
  fuel_travel     DECIMAL(6,3) DEFAULT 0.05,  -- L/CV/PA en trajet
  price_new       DECIMAL(12,2),
  parts_count     INT DEFAULT 3      -- nombre de pièces à changer
)
```

---

## 1b. Transport (règles globales)

Tout déplacement de ressources ou d'animaux entre la ferme et un point extérieur (coopérative, grossiste, autre joueur) nécessite un **attelage** : tracteur + remorque adaptée.

### Familles d'équipement (V1 implémenté)
| Famille | Type | Exemples | Usage |
|---------|------|----------|-------|
| `tracteur` | Motorisé | John Deere 6130R (130CV), New Holland T5.120 (120CV), MF 7720S (200CV) | Traction de tout |
| `benne` | Tracté | Joskin 7t (100CV), Rolland 6t (80CV) | Transport céréales, rations |
| `plateau` | Tracté | Rolland 8m 10t (80CV), Joskin 10m 14t (100CV) | Transport paille, foin |
| `betaillere` | Tracté | Joskin 8 places (90CV), Rolland 6 places (80CV) | Transport animaux |
| `citerne` | Tracté | Joskin 6000L (90CV) | Transport eau (V2) |
| `charrue` | Tracté | — | Travail du sol (V2) |
| `moissonneuse` | Motorisé | — | Récolte (V2) |
| + 7 autres | Tracté | andaineur, cultivateur, faneuse, faucheuse, herse, presse, pulvérisateur, semoir | Cultures (V2) |

### Familles de remorques (transport)
| Famille | Transporte | Exemples |
|---------|-----------|----------|
| `benne` | Céréales, rations, aliments | Joskin Trans-Space 7000 (7t), Rolland Rollspeed 6835 (6t) |
| `plateau` | Paille, foin, matériaux | Rolland Plateau 8m (10t), Joskin Plateau 10m (14t) |
| `betaillere` | Animaux | Joskin Betimax 4800 (8 places), Rolland BH 510 (6 places) |
| `citerne` | Eau, lait | Joskin Modulo2 6000 (6000L) |

### Compatibilité tracteur/remorque
- Chaque remorque a un `required_hp` (CV minimum du tracteur)
- Le tracteur doit avoir `horsepower >= required_hp`
- Un équipement `is_broken = true` ne peut pas être utilisé

### Calcul des trajets
```
trips = ⌈quantité / capacité_remorque⌉
heures = 1h × trips
usure = 0.5% × trips (sur tracteur ET remorque)
```

### Distance coopérative
- Fixe : **20 km** (aller-retour 40 km)
- 1h par trajet (≈ 40 km/h)

### Correspondance produit → remorque
Table `feed_types.transport_family` :
- Rations / aliments → `benne`
- Paille et foin → `plateau`
- Animaux (grossiste) → `betaillere`

### UX modale d'achat
1. Sélection tracteur (liste des tracteurs non cassés, affiche marque/modèle/CV/usure)
2. Sélection remorque (filtrée par CV compatible, affiche capacité/CV requis/usure)
3. Quantité
4. Destination (silo pour ressources, enclos pour animaux)
5. Récap : nombre de trajets, heures, usure, coût total
6. Bouton désactivé si équipement manquant/incompatible

### Vérifications serveur
1. Tracteur existe, appartient au joueur, non cassé
2. Remorque existe, bonne famille, non cassée, CV compatible
3. Capacité stockage suffisante (silo)
4. Solde suffisant
5. Heures suffisantes
6. Appliquer : débit solde + heures × trips + usure × trips

---

## 2. Consommation HVC (bio-carburant)

### Table
```sql
fuel_tanks (
  player_id  UUID PRIMARY KEY REFERENCES players,
  hvc_liters DECIMAL(12,2) DEFAULT 0  -- réservoir global
)
```

### Calcul consommation
```
function consumeFuel(player_id, equipment, pa_travel, pa_work):
  if NOT equipment.is_motorized: return  // outils tractés = pas de conso directe
  
  hp = equipment.horsepower
  fuel_travel = hp * equipment.fuel_travel * pa_travel
  fuel_work = hp * equipment.fuel_work * pa_work
  total = fuel_travel + fuel_work
  
  tank = getFuelTank(player_id)
  if tank.hvc_liters < total:
    throw "Réservoir HVC vide"
  tank.hvc_liters -= total
```

### Prix HVC
- CAR : 0.36 à 0.55 €/L
- Coopérative SimAgri : 0.60 €/L

---

## 3. Usure & entretien

### Tick usure (journalier)
```
Pour chaque equipment :
  base_wear = 0.1  // % par jour
  if NOT equipment.is_sheltered: base_wear *= 1.5
  equipment.wear = min(100, equipment.wear + base_wear)
```

### Entretien (action joueur, 2h)
```
function maintainEquipment(player_id, equipment_id):
  consumePA(player_id, 1)
  eq = getEquipment(equipment_id)
  
  // Coût pièces selon type
  parts_cost = getPartsCost(eq.definition.family)
  age_years = yearsSince(eq.bought_at)
  parts_cost *= (1 + age_years * 0.02)  // +2% par an d'âge
  
  deductBalance(player_id, parts_cost)
  eq.wear = max(0, eq.wear - 30)  // récupère 30% d'usure
```

---

## 4. Pannes

```
Chaque jour, pour chaque matériel :
  if equipment.wear > 50:
    chance = (equipment.wear - 50) / 200  // 0% à 25%
    if random() < chance:
      equipment.is_broken = true
      equipment.broken_until = now + random(1, 2) days
      
      if equipment.insurance_until > now:
        // Réparation gratuite
      else:
        repair_cost = calculateRepairCost(equipment)
        deductBalance(player_id, repair_cost)
```

---

## 5. Pièces détachées

```sql
equipment_parts (
  equipment_id  UUID REFERENCES equipment,
  part_index    INT,  -- 1 à 5
  pa_threshold  DECIMAL(5,2),  -- % des PA max pour changement
  is_worn       BOOLEAN DEFAULT FALSE
)
```

```
Après chaque utilisation :
  usage_pct = equipment.pa_used / equipment.definition.max_pa * 100
  for part in equipment.parts:
    if usage_pct >= part.pa_threshold AND NOT part.is_worn:
      part.is_worn = true
      // Alerte joueur : pièce à changer
      // Si non changée → matériel inutilisable
```

---

## 6. Maniabilité

```
function getManueverabilityBonus(equipment, parcel):
  ideal = getIdealManeuverability(parcel.size_ha)
  diff = abs(equipment.maneuverability - ideal)
  
  bonuses = {0: 1.10, 1: 1.05, 2: 1.00, 3: 0.95, 4: 0.90}
  return bonuses[diff]

function getIdealManeuverability(size_ha):
  if size_ha < 11: return 5
  if size_ha <= 20: return 4
  if size_ha <= 30: return 3
  if size_ha <= 40: return 2
  return 1
```

---

## 7. GPS

```sql
gps_beacons (
  id              UUID PRIMARY KEY,
  owner_player_id UUID REFERENCES players,  -- concessionnaire
  department_id   INT REFERENCES departments,
  zone            INT CHECK (1..10),
  altitude        INT,
  orientation     INT,
  signal_quality  DECIMAL(5,2)  -- influence gains
)

gps_subscriptions (
  player_id  UUID REFERENCES players,
  beacon_id  UUID REFERENCES gps_beacons,
  expires_at DATE,
  price      DECIMAL(8,2)  -- 400-600€/an
)

gps_receivers (
  id           UUID PRIMARY KEY,
  equipment_id UUID REFERENCES equipment,
  installed_by UUID REFERENCES players  -- concessionnaire
)
```

### Gains GPS
Réduction heures, économie semences/engrais/traitements. Gains proportionnels à `signal_quality`.

---

## 8. Combinés

```sql
combined_definitions (
  id             SERIAL PRIMARY KEY,
  name           VARCHAR NOT NULL,
  front_tool     VARCHAR,  -- type matériel avant
  rear_tools     VARCHAR[] NOT NULL,  -- types matériel arrière
  hp_multiplier  DECIMAL(4,2) DEFAULT 1.5,
  hours_reduction   DECIMAL(4,2) DEFAULT 0,  -- % réduction heures
  yield_bonus    DECIMAL(4,2) DEFAULT 0,
  actions_merged INT DEFAULT 2  -- nombre d'actions en 1
)
```

### Exemples
| Combiné | Avant | Arrière | Bonus |
|---------|-------|---------|-------|
| Semis Traditionnel | - | Herse + Semoir | 2 actions en 1 |
| Faucher | Faucheuse frontale | Faucheuse arrière | -50% PA |
| Déchaumer/Semer | Cultivateur frontal | Herse + Semoir | 3 actions en 1 |

---

## 9. Achat/Vente matériel

### Endpoints
| Méthode | Route | Description |
|---------|-------|-------------|
| GET | /equipment/market | Catalogue neuf + occasion |
| POST | /equipment/buy | Acheter |
| POST | /equipment/:id/sell | Vendre (annonce 1500€ ou à concessionnaire) |
| POST | /equipment/shared-buy | Achat en commun (max 5 joueurs amis) |

### Argus
```
function getArgusValue(equipment):
  base = equipment.definition.price_new
  age_factor = max(0.1, 1 - (yearsSince(equipment.bought_at) * 0.1))
  wear_factor = max(0.1, 1 - (equipment.wear / 100))
  return base * age_factor * wear_factor
```

---

## 10. Matériel arboricole

| Matériel | Usage | Contrainte |
|----------|-------|------------|
| Tracteur arboricole (ou ≤80CV) | Traction dans vergers | Motorisé |
| Cultivateur ≤3m | Déchaumage verger | Tracté |
| Herse rotative ≤3m | Préparation terre | Tracté |
| Broyeur ≤80CV | Nettoyage (noyer, cerisier) | Tracté |
| Pulvérisateur arboricole (ou porté ≤18m) | Traitement/engrais | Tracté |
| Vibreur hydraulique | Faire tomber fruits (noyer) | Tracté |
| Ramasseuse arboricole | Ramasser fruits (noyer) | Motorisée |
| Plateau | Transport récolte | Tracté |
| Chargeur frontal / Télescopique ≤80CV | Chargement palox | Motorisé |

---

## 11. Matériel forestier

| Matériel | Usage |
|----------|-------|
| Abatteuse | Abattage arbres |
| Débusqueur | Extraction bois |
| Porteur forestier | Transport bois en forêt |
| Broyeur de branches | Déchiquetage bois (haies) |

Tous motorisés, consomment HVC.

---

## 12. Matériel viticole

Matériel spécifique aux domaines viticoles : enjambeur, machine à vendanger, pressoir, etc.

---

## 13. Matériel maraîcher

Matériel spécifique aux serres et cultures légumières.

---

## 14. Location de matériel

- Client : peut louer un tracteur uniquement si le sien est en panne
- Puissance équivalente (±5 CV)
- Durée = durée d'immobilisation du tracteur client
- Paiement au PA utilisé (prix fixé par le concessionnaire)

---

## 15. Dépôt-vente

Le concessionnaire peut accepter du matériel en dépôt-vente. Commission sur la vente.

---

## 16. Pièces détachées (concessionnaire)

- Investissement : magasin pièces détachées (20 000€) + vendeur pièces
- Vente uniquement pour les marques dont le concessionnaire a la licence
- Marge : 20% à 50%
- Remise : 5% à 15% pour les clients ayant acheté leur matériel dans la concession
- Pas de gestion de stock (intermédiaire)

---

## 17. Relevage avant

- Installation par atelier concessionnaire : 5 PA mécanicien, facturé 150-300€
- Permet d'atteler des matériels à l'avant du tracteur (combinés)
- Désinstallation : 2 PA mécanicien (uniquement sur matériel neuf en concession)
