# Sprint 03 — Bâtiments + Premier Animal — Spec End-to-End

> Chaque flux décrit : écran → clic → front → API → SQL → retour écran.
> Prérequis : Sprint 01 (auth) + Sprint 02 (ferme, géo, temps, économie de base).
> Le joueur a : un compte, une ferme à Clermont-Ferrand, 100 000€, 40 HT/jour.

---

## Tables SQL à créer ce sprint

```sql
-- Déjà existantes (sprint 01-02) : account, server, region, department, prefecture, farm, player, ledger, server_time
-- Nouvelles ce sprint :
building_type, building, building_animal_capacity,
animal_species, animal_breed, animal, animal_health_log,
market_price
```

## Seed data ce sprint

- `building_type` : stabulation, cuve_eau, silo (3 types minimum)
- `animal_species` : cattle (bovins)
- `animal_breed` : Prim'Holstein (laitière), Charolaise (allaitante), Montbéliarde (laitière)
- `market_price` : cours bovin par stade (veau, génisse, vache, taureau) + variation

---

## Flux 1 : Construire une stabulation

### Ce que le joueur voit

Page `/buildings`. Tableau vide : "Vous n'avez aucun bâtiment. [Construire un bâtiment]"

### Clic → `/buildings/buy`

Catalogue en grille. 3 cartes :

| Carte | Détails affichés |
|-------|-----------------|
| Stabulation | Icône 🐄, "Héberge vos bovins", unité: places, 200€/place, énergie: 0.5€/place/mois, "Instantané (niv 1)" |
| Cuve à eau | Icône 💧, "Stocke l'eau pour vos animaux", unité: litres, 0.5€/L, "Instantané" |
| Silo | Icône 🌾, "Stocke aliments et récoltes", unité: tonnes, 50€/t, "Instantané" |

### Clic sur "Stabulation" → Formulaire

```
┌─────────────────────────────────────────┐
│ 🐄 Construire une Stabulation           │
│                                         │
│ Capacité : [____20____] places          │
│            (min 5, max 200, pas de 5)   │
│                                         │
│ Calcul en temps réel :                  │
│ Coût : 20 × 200€ = 4 000 €             │
│ Énergie : 20 × 0.5€ = 10 €/mois        │
│ HT requis : 2.0                         │
│                                         │
│ Votre solde : 100 000 € ✅              │
│ Vos HT : 40/40 ✅                       │
│                                         │
│ [Annuler]          [Construire 4 000 €] │
└─────────────────────────────────────────┘
```

### Clic "Construire" → Frontend

1. Vérifie : `size >= 5`, `player.balance >= 4000`, `player.ht >= 2.0`
2. Génère `idempotencyKey = uuidv4()`
3. Désactive le bouton, affiche Spinner
4. Appel API

### → API

```http
POST /api/buildings
Headers: Authorization: Bearer {jwt}, X-Idempotency-Key: {uuid}
Body: { "building_type_id": 1, "size": 20, "name": "Stabulation Nord" }
```

### → Backend (service `BuildingService.create`)

```
1. Vérifier idempotency key → si déjà traitée, retourner résultat caché
2. Vérifier JWT → extraire player_id
3. Charger building_type (id=1) → vérifier existe
4. Calculer coût : size × base_cost_per_unit = 20 × 200 = 4000
5. Calculer énergie : size × energy_kwh_base × 0.08 = 20 × 0.5 = 10€/mois
6. BEGIN transaction
7. SELECT balance, ht_today FROM player WHERE id = $1 FOR UPDATE
8. Vérifier balance >= 4000 → sinon ROLLBACK + 400 "Solde insuffisant (besoin 4000€, reste {balance}€)"
9. Vérifier ht_today >= 2.0 → sinon ROLLBACK + 400 "HT insuffisants (besoin 2.0, reste {ht})"
10. UPDATE player SET balance = balance - 4000, ht_today = ht_today - 2.0
11. INSERT INTO building (farm_id, building_type_id, size, level, name, energy_monthly)
    VALUES ($farm_id, 1, 20, 1, 'Stabulation Nord', 10)
    RETURNING id, size, level, energy_monthly
12. INSERT INTO building_animal_capacity (building_id, animal_count, max_capacity)
    VALUES ($building_id, 0, 20)
13. INSERT INTO ledger (player_id, category, label, amount, balance_after)
    VALUES ($1, 'purchase', 'Construction Stabulation Nord (20 places)', -4000, 96000)
14. COMMIT
15. Stocker résultat en Redis avec idempotency key (TTL 24h)
16. Émettre WS events : balance_update(96000), ht_update(38.0), building_alert(created)
17. Retourner 201 { building }
```

### ← Retour Frontend

1. Toast vert : "🏗️ Stabulation Nord construite ! (20 places)"
2. Header animé : solde 100 000 → 96 000 (animation -4 000), HT 40 → 38
3. Redirect → `/buildings`
4. DataTable affiche la nouvelle stabulation :

```
| Bâtiment          | Capacité | Remplissage | Usure | Entretien | Actions      |
| 🐄 Stabulation Nord | 0/20     | ░░░░░░░░░░ 0% | 0%   | ✅ OK     | [Détail] [🔧] |
```

---

## Flux 2 : Construire une cuve à eau

Même flux que Flux 1 mais avec :
- Type : `cuve_eau`, unité : litres, 0.5€/L
- Taille : 5000 L → coût 2 500€
- Pas de `building_animal_capacity` (c'est du stockage, pas de l'hébergement)
- Le joueur en a besoin pour abreuver ses animaux (prérequis Sprint 04)

---

## Flux 3 : Construire un silo

Même flux, type `silo`, unité tonnes, 50€/t, taille 10t → 500€.
Nécessaire pour stocker les aliments (prérequis Sprint 04).

---

## Flux 4 : Acheter un animal au Marché Central

### Ce que le joueur voit

Sidebar → "Marché Central". Page `/market/animals`.

```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Marché Central — Bovins"                          │
│ [Bovins] (seul onglet Phase 2)                                  │
├─────────────────────────────────────────────────────────────────┤
│ Race         | Stade    | Dispo | Cours (€/kg) | Variation | Action │
│ Prim'Holstein| Veau ♀   | 203   | 4.25         | ↑ +0.02   | [Acheter] │
│ Prim'Holstein| Veau ♂   | 150   | 4.10         | ↓ -0.05   | [Acheter] │
│ Prim'Holstein| Génisse  | 52    | 4.00         | = 0.00    | [Acheter] │
│ Charolaise   | Veau ♀   | 89    | 3.80         | ↑ +0.10   | [Acheter] │
│ ...          |          |       |              |           |           │
├─────────────────────────────────────────────────────────────────┤
│ ⚠️ Prérequis : bétaillère + tracteur requis pour le transport   │
│ ℹ️ Consultation gratuite (0 HT). Achat : 0.5 HT par animal.    │
└─────────────────────────────────────────────────────────────────┘
```

### Clic "Acheter" sur Prim'Holstein Génisse

Modale :

```
┌─────────────────────────────────────────────┐
│ 🐄 Acheter une Prim'Holstein (Génisse)       │
│                                              │
│ Race : Prim'Holstein (Laitière)              │
│ Stade : Génisse (♀)                          │
│ Poids estimé : 350 kg                        │
│ Prix : 350 kg × 4.00 €/kg = 1 400 €         │
│                                              │
│ Destination :                                │
│ [Stabulation Nord (0/20 places) ▼]           │
│                                              │
│ Coût HT : 0.5                                │
│                                              │
│ Votre solde : 93 000 € ✅                    │
│ Vos HT : 36/40 ✅                            │
│                                              │
│ ⚠️ Note Sprint 03 : pas de bétaillère        │
│ requise (simplification, ajoutée Sprint 12)  │
│                                              │
│ [Annuler]              [Acheter 1 400 €]     │
└─────────────────────────────────────────────┘
```

**Bouton "Acheter" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= prix` ET `ht >= 0.5` ET destination avec place |
| 🔘 Grisé "Solde insuffisant (besoin 1400€)" | `balance < prix` |
| 🔘 Grisé "HT insuffisants (besoin 0.5)" | `ht < 0.5` |
| 🔘 Grisé "Aucun bâtiment avec place" | Tous les bâtiments bovins pleins |
| 🔘 Grisé "Sélectionnez un bâtiment" | Pas de destination choisie |

### Clic "Acheter" → Frontend

1. Vérifie conditions
2. Génère idempotency key
3. Désactive bouton + Spinner

### → API

```http
POST /api/animals/buy
Headers: Authorization: Bearer {jwt}, X-Idempotency-Key: {uuid}
Body: { "breed_id": 1, "life_stage": "young", "sex": "F", "building_id": "{uuid}" }
```

### → Backend (service `AnimalService.buy`)

```
1. Vérifier idempotency key
2. Charger breed (id=1) → Prim'Holstein, species=cattle
3. Calculer prix : breed.adult_weight_f × 0.6 (génisse) × market_price = 350 × 4.00 = 1400
4. Charger building → vérifier ownership, type compatible (stabulation), place dispo
5. BEGIN transaction
6. SELECT balance, ht_today FROM player WHERE id = $1 FOR UPDATE
7. Vérifier balance >= 1400
8. Vérifier ht_today >= 0.5
9. SELECT animal_count, max_capacity FROM building_animal_capacity WHERE building_id = $1 FOR UPDATE
10. Vérifier animal_count < max_capacity
11. Générer génétique aléatoire :
    genetics = {
      growth: random(40, 60),
      milk: random(40, 60),
      milk_quality: random(40, 60),
      prolificacy: random(40, 60),
      appearance: random(40, 60)
    }
    genetic_value = sum(values)
12. UPDATE player SET balance = balance - 1400, ht_today = ht_today - 0.5
13. INSERT INTO animal (
      farm_id, breed_id, sex, name, birth_date, weight_kg, age_days,
      health, life_stage, is_adult, location_type, building_id,
      genetics, genetic_value, bought_from
    ) VALUES (
      $farm_id, 1, 'F', NULL, now() - interval '365 days', 350, 365,
      100, 'young', false, 'building', $building_id,
      $genetics, $genetic_value, 'market'
    ) RETURNING *
14. UPDATE building_animal_capacity SET animal_count = animal_count + 1 WHERE building_id = $1
15. INSERT INTO ledger (player_id, category, label, amount, balance_after)
    VALUES ($1, 'purchase', 'Achat Prim''Holstein (Génisse)', -1400, 91600)
16. COMMIT
17. WS events : balance_update(91600), ht_update(35.5), animal_alert(new_animal)
18. Retourner 201 { animal }
```

### ← Retour Frontend

1. Toast vert : "🐄 Prim'Holstein achetée ! Placée dans Stabulation Nord."
2. Header : solde 93 000 → 91 600, HT 36 → 35.5
3. Fermer modale
4. Option : redirect vers fiche animal `/animals/{id}` ou rester sur le marché

---

## Flux 5 : Voir la liste de ses animaux

### Page `/animals`

**Chargement :**
1. `GET /api/animals?species=cattle&page=1&limit=20`
2. `GET /api/animals/dashboard` → compteurs alertes

**Backend `GET /api/animals/dashboard` :**
```sql
SELECT
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE last_fed_at IS NULL OR last_fed_at < CURRENT_DATE) as not_fed,
  COUNT(*) FILTER (WHERE is_sick = true) as sick,
  COUNT(*) FILTER (WHERE life_stage = 'dead' AND created_at > CURRENT_DATE - 1) as dead_today,
  COUNT(*) FILTER (WHERE pregnant_until IS NOT NULL) as pregnant,
  COUNT(*) FILTER (WHERE location_type = 'arrival') as in_arrival
FROM animal WHERE farm_id = $1 AND life_stage != 'dead';
```

**Réponse :**
```json
{
  "dashboard": {
    "total": 1, "not_fed": 1, "not_watered": 1, "sick": 0,
    "dead_today": 0, "pregnant": 0, "in_arrival": 0
  },
  "animals": [{
    "id": "uuid", "name": null, "breed": "Prim'Holstein", "sex": "F",
    "age_months": 12, "weight_kg": 350, "life_stage": "young",
    "building_name": "Stabulation Nord",
    "health": 100, "fed_today": false, "watered_today": false,
    "is_sick": false, "is_pregnant": false, "is_lactating": false,
    "vaccinated": false, "genetics_total": 256
  }]
}
```

**Rendu :**
```
┌─────────────────────────────────────────────────────────────────┐
│ Mes animaux [Total: 1 bovin]                                    │
├─────────────────────────────────────────────────────────────────┤
│ 🍽️ Pas nourris: 1 ⚠️ | 💧 Pas abreuvés: 1 ⚠️ | 🏥 Malades: 0 ✅ │
├─────────────────────────────────────────────────────────────────┤
│ ☐ | Nom    | Race          | Sexe | Âge    | Poids | Lieu      │
│   | (sans) | Prim'Holstein | ♀    | 12 mois| 350kg | Stab. Nord│
│   | Santé: ❤️100 🟢 | 🍽️❌ | 💧❌ | Gén: 256 | [Voir]        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Flux 6 : Cliquer sur un animal → Fiche complète

### Clic [Voir] → `/animals/{id}`

**Chargement :**
1. `GET /api/animals/{id}` → fiche complète (identité, santé, alimentation, génétique, production, reproduction, parents, actions disponibles)

**Backend `GET /api/animals/:id` :**
```sql
SELECT a.*, 
  b.name as breed_name, b.category as breed_type,
  s.name as species_name,
  bld.name as building_name,
  -- Parents
  pf.name as father_name, pf.id as father_id,
  pm.name as mother_name, pm.id as mother_id
FROM animal a
JOIN animal_breed b ON a.breed_id = b.id
JOIN animal_species s ON b.species_id = s.id
LEFT JOIN building bld ON a.building_id = bld.id
LEFT JOIN animal pf ON a.parent_father_id = pf.id
LEFT JOIN animal pm ON a.parent_mother_id = pm.id
WHERE a.id = $1 AND a.farm_id = $2;
```

Plus calcul `available_actions` :
```javascript
const actions = [];
// Nourrir
if (!animal.last_fed_at || animal.last_fed_at < today) {
  const hasStock = await checkFeedStock(farm_id, animal.breed_id);
  actions.push({ action: 'feed', possible: hasStock, cost_ht: 0.5,
    reason: hasStock ? null : 'Stock aliments insuffisant' });
} else {
  actions.push({ action: 'feed', possible: false, reason: 'Déjà nourri aujourd\'hui' });
}
// Soigner
if (animal.is_sick) {
  actions.push({ action: 'heal', possible: player.balance >= 100 && player.ht >= 0.5,
    cost_eur: 100, cost_ht: 0.5 });
} // ... etc pour chaque action
```

**Rendu :** La fiche complète telle que spécifiée dans UX_PHASE2.md §3 (identité, génétique 5 barres avec delta, santé, alimentation, production conditionnelle par espèce, reproduction, parents cliquables, actions avec états).

Pour une Prim'Holstein génisse juste achetée :
- Production : "Pas encore en lactation (génisse)"
- Reproduction : "Pas encore en âge de reproduction"
- Bouton Traire : masqué (pas en lactation)
- Bouton Inséminer : grisé "Trop jeune (adulte requis)"
- Bouton Nourrir : vert "Nourrir (0.5 HT)" → mais grisé "Stock aliments insuffisant" si pas de stock
- Bouton Renommer : vert (toujours actif, gratuit)

---

## Flux 7 : Renommer l'animal

### Sur la fiche, clic ✏️ à côté de "(sans nom)"

Input inline apparaît. Le joueur tape "Marguerite".

### Blur ou Enter → Frontend

```http
PUT /api/animals/{id}
Body: { "name": "Marguerite" }
```

### → Backend

```
1. Ownership check
2. Validation : 1-30 chars, regex /^[a-zA-ZÀ-ÿ0-9 '-]+$/
3. UPDATE animal SET name = 'Marguerite', is_named = true WHERE id = $1
4. Retourner 200 { name: "Marguerite" }
```

### ← Frontend

Nom mis à jour inline. ✅ vert 1s. DataTable liste aussi mise à jour si visible.

---

## Dépendances techniques Sprint 03

```
Sprint 01 (auth)
  └→ Sprint 02 (ferme, géo, temps, économie)
       └→ Sprint 03 (bâtiments, animaux)
            ├── Tables : building_type, building, building_animal_capacity
            ├── Tables : animal_species, animal_breed, animal, animal_health_log, market_price
            ├── Seed : 3 types bâtiments, 1 espèce, 3 races, cours marché
            ├── Services : BuildingService, AnimalService, MarketService
            ├── Routes : /api/buildings/*, /api/animals/*, /api/market/animals
            ├── Stores : useBuildingStore, useAnimalStore, useMarketStore
            ├── Pages : /buildings, /buildings/buy, /animals, /animals/:id, /market/animals
            └── Composants : DataTable, ConfirmModal, GeneticBars, AnimalCard, BuildingCard
```

## Tests Sprint 03

### Tests intégration (Supertest)
```
GIVEN joueur avec 100k€ et 40 HT
WHEN POST /api/buildings { type: stabulation, size: 20 }
THEN 201, balance = 96000, ht = 38, building créé avec 0/20 places

GIVEN stabulation 0/20 places
WHEN POST /api/animals/buy { breed: prim_holstein, stage: young, sex: F, building: $id }
THEN 201, balance = 94600, ht = 37.5, animal créé, capacity = 1/20

GIVEN stabulation 20/20 places
WHEN POST /api/animals/buy { ... building: $id }
THEN 400 "Pas assez de place (20/20)"

GIVEN joueur avec 0 HT
WHEN POST /api/buildings { ... }
THEN 400 "HT insuffisants (besoin 2.0, reste 0)"

GIVEN même idempotency key
WHEN POST /api/buildings { ... } × 2
THEN 2ème appel retourne même résultat, pas de double déduction
```

### Tests unitaires (Vitest)
```
calculateBuildingCost(type, size) → prix correct
generateAnimalGenetics(breed) → 5 indices entre 40-60
calculateAnimalPrice(breed, stage, market_price) → prix correct
validateAnimalName("Marguerite") → true
validateAnimalName("") → false
validateAnimalName("a".repeat(31)) → false
```

### Tests E2E (Playwright)
```
1. Login → /buildings → "Aucun bâtiment" visible
2. Clic "Construire" → catalogue → clic Stabulation → taille 20 → Construire
3. Vérifier toast succès + solde mis à jour + bâtiment dans la liste
4. /market/animals → clic Acheter Prim'Holstein → choisir Stabulation → Acheter
5. Vérifier toast + /animals → 1 animal dans la liste
6. Clic [Voir] → fiche complète → génétique 5 barres → boutons avec états corrects
7. Clic ✏️ → taper "Marguerite" → Enter → nom mis à jour
```
