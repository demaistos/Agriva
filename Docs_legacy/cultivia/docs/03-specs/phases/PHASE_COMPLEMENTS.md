# PHASE COMPLÉMENTS — Mécaniques Gameplay Manquantes

> **Cultivia — Specs détaillées des features identifiées par la revue REVIEW_GAMEPLAY.md**
> Chaque feature est spécifiée pour être codée sans ambiguïté.
> Référence : 01-game-design/, 02-architecture/, PHASE1_CULTURES.md (format)
> Source : docs/reports/REVIEW_GAMEPLAY.md §1 — Mécaniques manquantes

---

## Table des matières

### Cultures (Phase 1/5)
1. [Feature 1 — Céréale immature](#feature-1--céréale-immature)
2. [Feature 2 — Quotas betterave](#feature-2--quotas-betterave)
3. [Feature 3 — Engrais verts / CIPAN](#feature-3--engrais-verts--cipan)
4. [Feature 4 — Compostage](#feature-4--compostage)
5. [Feature 5 — Retenue collinaire](#feature-5--retenue-collinaire)
6. [Feature 6 — Pivot central irrigation](#feature-6--pivot-central-irrigation)

### Élevage (Phase 4/5)
7. [Feature 7 — Chien de troupeau](#feature-7--chien-de-troupeau)
8. [Feature 8 — Négociant en bestiaux](#feature-8--négociant-en-bestiaux)
9. [Feature 9 — Élevage industriel & ratio fusion](#feature-9--élevage-industriel--ratio-fusion)
10. [Feature 10 — Assurance matériel](#feature-10--assurance-matériel)
11. [Feature 11 — Combinés de travail](#feature-11--combinés-de-travail)

### Économie / Infrastructure (Phase 3/5)
12. [Feature 12 — Achat matériel en commun](#feature-12--achat-matériel-en-commun)
13. [Feature 13 — Magasin libre-service CAR](#feature-13--magasin-libre-service-car)
14. [Feature 14 — Organisme Partcel](#feature-14--organisme-partcel)
15. [Feature 15 — Déménagement & fermes annexes](#feature-15--déménagement--fermes-annexes)

---

## Feature 1 — Céréale immature

### 1.1 Description

Certaines céréales (blé, orge, avoine, triticale, seigle sur CA/US/Expert) peuvent être récoltées avant maturité complète, entre 60 % et 80 % de pousse, au plus tard le 7 mai. La récolte se fait à l'ensileuse (pas à la moissonneuse). Le rendement est de 150 % du rendement grain de base. Le produit est stocké en silo taupe et utilisable en méthanisation (substrat) ou alimentation animale (bovins, caprins, ovins).

**Règles métier :**
- Cultures éligibles : blé, orge, avoine, triticale + seigle (serveurs CA/US/Expert uniquement)
- Fenêtre de récolte : `growth_pct` entre 60.00 et 80.00
- Date limite : 7 mai (game_month=5, game_day_of_month≤7)
- Machine requise : ensileuse (pas moissonneuse-batteuse)
- Rendement = `base_yield_region × 1.50 × (growth_pct / 100)`
- Produit : `immature_silage` (ensilage de céréale immature)
- Stockage : silo taupe uniquement (`building_type.slug = 'silo_taupe'`)
- Usages : alimentation bovins/caprins/ovins, substrat méthanisation
- La parcelle revient en jachère après récolte immature (pas de paille produite)

### 1.2 Schéma BDD

```sql
-- Pas de nouvelle table. Modifications :
-- 1. Ajout du produit 'immature_silage' dans les types d'inventaire
-- 2. Ajout du building_type 'silo_taupe'

-- Seed data
INSERT INTO building_type (name, slug, category, unit, base_cost_per_unit, energy_kwh_base)
VALUES ('Silo taupe', 'silo_taupe', 'b', 'tonne', 25.00, 0);

-- Cultures éligibles (flag dans crop_type)
ALTER TABLE crop_type ADD COLUMN immature_eligible BOOLEAN NOT NULL DEFAULT false;

UPDATE crop_type SET immature_eligible = true
WHERE slug IN ('wheat', 'barley', 'oat', 'triticale', 'rye');
```

### 1.3 Logique métier

```
IMMATURE_MIN_PCT = 60.0
IMMATURE_MAX_PCT = 80.0
IMMATURE_YIELD_FACTOR = 1.50
IMMATURE_DEADLINE_MONTH = 5
IMMATURE_DEADLINE_DAY = 7
IMMATURE_ELIGIBLE = ['wheat','barley','oat','triticale']
IMMATURE_ELIGIBLE_EXTRA = ['rye']  -- CA/US/Expert uniquement

function harvestImmature(player_id, parcel_id):
    parcel = getParcel(parcel_id)
    crop = getActiveCrop(parcel_id)
    server = getServerForPlayer(player_id)

    ASSERT parcel.farm.player_id == player_id                        → 403
    ASSERT crop EXISTS AND crop.state IN ('growing')                 → 409 "Pas de culture en croissance"

    -- Vérifier éligibilité
    crop_type = getCropType(crop.crop_type_id)
    eligible = IMMATURE_ELIGIBLE
    IF server.slug IN ('ca','us','expert'):
        eligible = eligible + IMMATURE_ELIGIBLE_EXTRA
    ASSERT crop_type.slug IN eligible                                → 400 "Culture non éligible"

    -- Vérifier fenêtre de pousse
    ASSERT crop.growth_pct >= IMMATURE_MIN_PCT                       → 409 "Pousse < 60%"
    ASSERT crop.growth_pct <= IMMATURE_MAX_PCT                       → 409 "Pousse > 80%"

    -- Vérifier date limite
    ASSERT server.game_month < IMMATURE_DEADLINE_MONTH
           OR (server.game_month == IMMATURE_DEADLINE_MONTH
               AND server.game_day_of_month <= IMMATURE_DEADLINE_DAY) → 409 "Après le 7 mai"

    -- Vérifier ensileuse
    ensileuse = findVehicle(player_id, 'cutting', slug_contains='ensileuse')
    ASSERT ensileuse EXISTS AND NOT ensileuse.is_broken              → 409 "Ensileuse requise"

    benne = findVehicle(player_id, 'transport')
    ASSERT benne EXISTS AND NOT benne.is_broken                      → 409 "Benne requise"

    -- Vérifier silo taupe
    silo = findBuildingWithCapacity(player_id, 'silo_taupe', needed_tons)
    ASSERT silo EXISTS                                               → 409 "Silo taupe requis"

    ha = parcel.area_m2 / 10000
    region_id = getRegionForParcel(parcel_id)
    base_yield = getRegionalYield(crop.crop_type_id, region_id)

    yield_per_ha = base_yield * IMMATURE_YIELD_FACTOR * (crop.growth_pct / 100.0)
    total_yield = yield_per_ha * ha

    -- HT
    pa_cost = ha * 0.6
    move_cost = calculateMoveCost(farm.prefecture_id, parcel.prefecture_id)
    ASSERT canPerformAction(player_id, move_cost + pa_cost)          → 403
    IF move_cost > 0:
        spendPA(player_id, move_cost, 'move', { to_prefecture_id: parcel.prefecture_id })
    spendPA(player_id, pa_cost, 'harvest_immature', { parcel_id })
    consumeHVC(player_id, ensileuse, pa_cost)

    -- Stocker en silo taupe
    addToInventory(player_id, silo.id, 'immature_silage', NULL, total_yield * 1000, 'kg')

    -- Consommer nutriments sol
    consumeNutrients(parcel_id, crop_type, yield_per_ha, ha)

    -- Clore la culture (pas de paille)
    UPDATE crop SET state = 'harvested', harvested_at = now(),
                    yield_tons = total_yield
           WHERE id = crop.id

    RETURN { yield_tons: total_yield, yield_per_ha, growth_pct: crop.growth_pct }
```

### 1.4 API Endpoints

#### POST `/api/parcels/:id/harvest-immature`

```
Response 200:
{
  "yield_tons": 15.75,
  "yield_per_ha": 7.875,
  "growth_pct": 70.0,
  "storage": "silo_taupe"
}

Erreurs:
  400 — Culture non éligible
  403 — Pas propriétaire, HT/fonds insuffisants
  409 — Pousse hors 60-80%, après le 7 mai, ensileuse manquante, silo taupe manquant
```

### 1.5 Tests

**Tests unitaires :**
- Blé à 70% pousse, base 7T/ha → 7 × 1.50 × 0.70 = 7.35 T/ha
- Blé à 60% pousse → 7 × 1.50 × 0.60 = 6.30 T/ha
- Blé à 80% pousse → 7 × 1.50 × 0.80 = 8.40 T/ha
- Blé à 59% → 409
- Blé à 81% → 409
- Maïs grain à 70% → 400 (non éligible)
- Seigle sur FR1 → 400 (non éligible)
- Seigle sur CA → OK
- Récolte le 8 mai → 409
- Récolte le 7 mai → OK
- Récolte sans ensileuse → 409
- Récolte avec moissonneuse → 409
- Pas de silo taupe → 409
- Pas de paille produite après récolte immature

**Tests d'intégration :**
- Semer blé → tick ×40 (≈70%) → récolte immature → stock en silo taupe → vérifier inventaire
- Vérifier que le produit `immature_silage` est utilisable en alimentation bovins

---

## Feature 2 — Quotas betterave

### 2.1 Description

Le semis de betterave est soumis à un quota : maximum 2 ha OU 10 % de la surface cultivée (hors prés printemps/automne et vergers) de l'année précédente, selon le plus avantageux. La vérification se fait au moment du semis. Si le quota est dépassé, le semis est refusé.

**Règles métier :**
- Quota = MAX(2 ha, 10% de la surface cultivée l'année précédente)
- Surface cultivée = somme des parcelles de type `field` ayant eu une culture l'année précédente (hors prés et vergers)
- Vérification au semis uniquement (pas de rétroactivité)
- Surface betterave en cours = somme des parcelles avec culture betterave active

### 2.2 Schéma BDD

```sql
-- Pas de nouvelle table. Utilise crop_history + parcel existants.
-- Vue utilitaire optionnelle :
CREATE OR REPLACE VIEW v_beet_quota AS
SELECT
    f.id AS farm_id,
    f.player_id,
    -- Surface cultivée année précédente (hors prés/vergers)
    COALESCE(SUM(DISTINCT CASE
        WHEN ch.sown_year = (SELECT current_year - 1 FROM server s
             JOIN player p ON p.server_id = s.id WHERE p.id = f.player_id)
        AND p.type = 'field'
        THEN p.area_m2
    END), 0) / 10000.0 AS prev_year_cultivated_ha,
    -- Surface betterave en cours
    COALESCE(SUM(DISTINCT CASE
        WHEN c.harvested_at IS NULL AND ct.slug = 'sugar_beet'
        THEN p.area_m2
    END), 0) / 10000.0 AS current_beet_ha
FROM farm f
LEFT JOIN parcel p ON p.farm_id = f.id
LEFT JOIN crop_history ch ON ch.parcel_id = p.id
LEFT JOIN crop c ON c.parcel_id = p.id
LEFT JOIN crop_type ct ON ct.id = c.crop_type_id
GROUP BY f.id, f.player_id;
```

### 2.3 Logique métier

```
BEET_QUOTA_BASE_HA = 2.0
BEET_QUOTA_PCT = 0.10

function checkBeetQuota(player_id, parcel_id) -> { allowed: bool, quota_ha, current_ha }:
    farm = getPrimaryFarm(player_id)
    server = getServerForPlayer(player_id)
    parcel = getParcel(parcel_id)
    new_ha = parcel.area_m2 / 10000

    -- Surface cultivée année précédente (champs uniquement)
    prev_cultivated = SELECT COALESCE(SUM(DISTINCT p.area_m2), 0) / 10000.0
        FROM crop_history ch
        JOIN parcel p ON p.id = ch.parcel_id
        WHERE p.farm_id = farm.id
        AND p.type = 'field'
        AND ch.sown_year = server.current_year - 1

    -- Quota = max(2 ha, 10% surface cultivée)
    quota_ha = MAX(BEET_QUOTA_BASE_HA, prev_cultivated * BEET_QUOTA_PCT)

    -- Surface betterave en cours
    current_beet = SELECT COALESCE(SUM(p.area_m2), 0) / 10000.0
        FROM crop c
        JOIN crop_type ct ON ct.id = c.crop_type_id
        JOIN parcel p ON p.id = c.parcel_id
        WHERE p.farm_id = farm.id
        AND ct.slug = 'sugar_beet'
        AND c.harvested_at IS NULL

    allowed = (current_beet + new_ha) <= quota_ha
    RETURN { allowed, quota_ha, current_ha: current_beet, requested_ha: new_ha }

-- Intégration dans la fonction sow() existante (PHASE1 Feature 7) :
-- Ajouter après la vérification de rotation :
--   IF crop_type.slug == 'sugar_beet':
--       quota = checkBeetQuota(player_id, parcel_id)
--       ASSERT quota.allowed → 409 "Quota betterave dépassé (max " + quota.quota_ha + " ha)"
```

### 2.4 API Endpoints

#### GET `/api/quotas/beet`

```
Response 200:
{
  "quota_ha": 5.0,
  "current_beet_ha": 3.0,
  "remaining_ha": 2.0,
  "prev_year_cultivated_ha": 50.0,
  "rule": "10% de 50 ha = 5 ha (> 2 ha base)"
}
```

Modification de `POST /api/parcels/:id/sow` :
```
Erreur 409 supplémentaire : "Quota betterave dépassé (max X ha)"
```

### 2.5 Tests

**Tests unitaires :**
- Joueur sans historique → quota = 2 ha (base)
- Joueur avec 50 ha cultivés l'an passé → quota = max(2, 5) = 5 ha
- Joueur avec 10 ha cultivés → quota = max(2, 1) = 2 ha
- Semis 2 ha betterave, quota 2 ha, 0 en cours → OK
- Semis 1 ha betterave, quota 2 ha, 2 ha en cours → 409
- Semis blé → pas de vérification quota
- Prés et vergers exclus du calcul surface cultivée

**Tests d'intégration :**
- Année 1 : cultiver 30 ha de blé → Année 2 : quota betterave = max(2, 3) = 3 ha
- Semer 3 ha betterave → OK → semer 1 ha de plus → 409

---

## Feature 3 — Engrais verts / CIPAN

### 3.1 Description

Les couverts végétaux (CIPAN) sont semés après les récoltes d'été, broyés en janvier, et apportent un bonus de rendement à la culture de printemps suivante. 4 espèces disponibles avec des dates de semis différentes. Le cycle est : déchaumage → semis → broyage en janvier → attente 7 jours → semis de printemps (suppression du passage déchaumeur).

**Règles métier :**
- 4 espèces : moutarde (sept), phacélie (août), seigle (oct), ray-grass Italie (juillet)
- Préparation : 1 déchaumage (cultivateur ou déchaumeur)
- Semis : épandeur engrais (largeur max 18m) ou semoir direct
- Destruction : 1 broyage en janvier (broyeur ou déchaumeur)
- Après destruction : attendre 7 jours, puis suppression du passage déchaumeur pour la culture suivante
- Bonus : meilleur rendement culture printemps suivante + moins de matériel requis
- L'effet positif expire en juin (passé juin, plus de bénéfice)

### 3.2 Schéma BDD

```sql
CREATE TABLE cover_crop_type (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(50) NOT NULL UNIQUE,
  slug          VARCHAR(30) NOT NULL UNIQUE,
  sow_month     SMALLINT NOT NULL CHECK (sow_month BETWEEN 1 AND 12),
  seed_kg_ha    DECIMAL(6,2) NOT NULL,
  seed_price_kg DECIMAL(6,2) NOT NULL DEFAULT 0.50,
  bonus_yield   DECIMAL(4,2) NOT NULL DEFAULT 1.05  -- facteur rendement
);

INSERT INTO cover_crop_type (name, slug, sow_month, seed_kg_ha, seed_price_kg, bonus_yield) VALUES
('Moutarde',          'mustard',       9,  10, 0.40, 1.05),
('Phacélie',          'phacelia',      8,  12, 0.60, 1.05),
('Seigle (couvert)',  'rye_cover',    10, 100, 0.25, 1.05),
('Ray-grass Italie',  'ryegrass_cover', 7,  20, 0.35, 1.05);

CREATE TABLE cover_crop (
  id                SERIAL PRIMARY KEY,
  parcel_id         INT NOT NULL REFERENCES parcel(id) ON DELETE CASCADE,
  cover_crop_type_id INT NOT NULL REFERENCES cover_crop_type(id),
  state             VARCHAR(15) NOT NULL DEFAULT 'sown',
  -- states: 'sown', 'growing', 'destroyed', 'active_bonus'
  sown_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  destroyed_at      TIMESTAMPTZ,
  bonus_expires_at  TIMESTAMPTZ,  -- destroyed_at + ~5 mois (fin juin)
  UNIQUE(parcel_id) -- 1 couvert actif par parcelle
);
CREATE INDEX idx_cover_crop_parcel ON cover_crop(parcel_id);
```

### 3.3 Logique métier

```
COVER_DESTROY_MONTH = 1  -- janvier
COVER_WAIT_DAYS = 7
COVER_BONUS_EXPIRE_MONTH = 6  -- juin

function sowCoverCrop(player_id, parcel_id, cover_type_slug):
    parcel = getParcel(parcel_id)
    server = getServerForPlayer(player_id)
    cover_type = SELECT * FROM cover_crop_type WHERE slug = cover_type_slug

    ASSERT parcel.farm.player_id == player_id                        → 403
    ASSERT cover_type EXISTS                                         → 404
    ASSERT NOT EXISTS active crop on parcel                          → 409 "Culture en cours"
    ASSERT NOT EXISTS cover_crop WHERE parcel_id = parcel_id         → 409 "Couvert déjà en place"
    ASSERT server.current_month == cover_type.sow_month              → 400 "Hors période semis"

    -- Matériel : tracteur + déchaumeur/cultivateur (préparation) + épandeur engrais ou semoir direct
    tractor = findVehicle(player_id, 'motor')
    dechaumeur = findVehicle(player_id, 'soil', slug_contains='dechaumeur|cultivateur')
    semoir = findVehicle(player_id, family IN ('sowing','treatment'),
                         slug_contains='epandeur_engrais|semoir_direct')
    ASSERT tractor AND dechaumeur AND semoir (not broken)            → 409 "Matériel manquant"

    ha = parcel.area_m2 / 10000
    seed_cost = cover_type.seed_kg_ha * ha * cover_type.seed_price_kg

    debit(player_id, seed_cost, 'cover_crop_seed',
          'Semences ' + cover_type.name + ' ' + ha + ' ha', 'cover_crop_type', cover_type.id)

    -- HT : déchaumage (0.4/ha) + semis (0.3/ha)
    pa_cost = ha * 0.7
    move_cost = calculateMoveCost(farm.prefecture_id, parcel.prefecture_id)
    IF move_cost > 0:
        spendPA(player_id, move_cost, 'move', { to_prefecture_id: parcel.prefecture_id })
    spendPA(player_id, pa_cost, 'sow_cover', { parcel_id })
    consumeHVC(player_id, tractor, pa_cost)

    INSERT INTO cover_crop (parcel_id, cover_crop_type_id, state)
    VALUES (parcel_id, cover_type.id, 'sown')

    RETURN { seed_cost, pa_spent: pa_cost }

function destroyCoverCrop(player_id, parcel_id):
    parcel = getParcel(parcel_id)
    server = getServerForPlayer(player_id)
    cover = SELECT cc.*, cct.* FROM cover_crop cc
            JOIN cover_crop_type cct ON cct.id = cc.cover_crop_type_id
            WHERE cc.parcel_id = parcel_id AND cc.state IN ('sown','growing')

    ASSERT cover EXISTS                                              → 409 "Pas de couvert"
    ASSERT server.current_month == COVER_DESTROY_MONTH               → 400 "Destruction en janvier uniquement"

    -- Matériel : tracteur + broyeur ou déchaumeur
    tractor = findVehicle(player_id, 'motor')
    broyeur = findVehicle(player_id, family='soil', slug_contains='broyeur|dechaumeur')
    ASSERT tractor AND broyeur (not broken)                          → 409

    ha = parcel.area_m2 / 10000
    pa_cost = ha * 0.3
    move_cost = calculateMoveCost(farm.prefecture_id, parcel.prefecture_id)
    IF move_cost > 0:
        spendPA(player_id, move_cost, 'move', { to_prefecture_id: parcel.prefecture_id })
    spendPA(player_id, pa_cost, 'destroy_cover', { parcel_id })
    consumeHVC(player_id, tractor, pa_cost)

    -- Calculer date expiration bonus (fin juin)
    bonus_expires = getGameDate(server, COVER_BONUS_EXPIRE_MONTH, 30)

    UPDATE cover_crop SET state = 'active_bonus',
                          destroyed_at = now(),
                          bonus_expires_at = bonus_expires
           WHERE id = cover.id

    RETURN { bonus_active: true, wait_days: COVER_WAIT_DAYS, bonus_expires_at: bonus_expires }

-- Intégration dans sow() de PHASE1 Feature 7 :
-- Si cover_crop existe avec state='active_bonus' et destroyed_at + 7 jours < now() :
--   1. Pas besoin de passage déchaumeur (skip prepare_soil)
--   2. Bonus rendement : fertilizer_factor *= cover.bonus_yield (1.05)
-- Si bonus_expires_at < now() : supprimer le cover_crop, pas de bonus

-- Tick quotidien : nettoyer les cover_crop expirés
function dailyCoverCropCleanup(server_id):
    DELETE FROM cover_crop
    WHERE state = 'active_bonus'
    AND bonus_expires_at < now()
```

### 3.4 API Endpoints

#### POST `/api/parcels/:id/sow-cover`

```
Request: { "cover_type": "mustard" }
Response 201:
{
  "cover_type": "mustard",
  "seed_cost": 40.00,
  "pa_spent": 7.0,
  "destroy_month": "janvier"
}
Erreurs: 400 (hors période), 403, 404, 409 (culture en cours, couvert existant, matériel)
```

#### POST `/api/parcels/:id/destroy-cover`

```
Response 200:
{
  "bonus_active": true,
  "wait_days": 7,
  "bonus_expires_at": "2026-06-30T00:00:00Z",
  "skip_dechaumage": true
}
Erreurs: 400 (pas en janvier), 409 (pas de couvert, matériel)
```

#### GET `/api/cover-crop-types`

```
Response 200:
{
  "types": [
    { "slug": "mustard", "name": "Moutarde", "sow_month": 9, "seed_kg_ha": 10, "bonus_yield": 1.05 },
    ...
  ]
}
```

### 3.5 Tests

**Tests unitaires :**
- Semis moutarde en septembre → OK
- Semis moutarde en octobre → 400
- Semis phacélie en août → OK
- Semis sur parcelle avec culture active → 409
- Destruction en janvier → OK, bonus actif
- Destruction en février → 400
- Bonus rendement : culture printemps après couvert → ×1.05
- Bonus expiré (après juin) → pas de bonus
- Semis printemps après couvert : pas besoin de déchaumeur
- Semis printemps avant 7 jours post-destruction → 409 "Attendre 7 jours"
- Coût semences moutarde 10 ha : 10 × 10 × 0.40 = 40€

**Tests d'intégration :**
- Récolter blé (juillet) → semer moutarde (sept) → détruire (janv) → attendre 7j → semer maïs (mai) → vérifier bonus rendement +5%
- Vérifier que le passage déchaumeur est supprimé après couvert

---

## Feature 4 — Compostage

### 4.1 Description

Le compostage transforme le fumier en compost, un amendement organique riche. Deux modes : en parcelle (14 jours, 2 retournements manuels obligatoires) ou à la ferme via une aire de compostage (bâtiment). Ratio : 3 T fumier → 1 T compost. Épandage : 15 T/ha. Apports nutritifs : N=95, P=60, K=120, Ca=180, Mg=35, S=60 kg/ha.

**Règles métier :**
- Ratio : 3 T fumier → 1 T compost
- Durée : 14 jours
- Retournement 1 : jour 4 ou 5 (obligatoire)
- Retournement 2 : jour 9 ou 10 (obligatoire)
- Si retournement manqué → perte 50% du compost par retournement manqué
- Matériel retournement : retourneur d'andains (ou ETA)
- Épandage : 15 T/ha avec épandeur à fumier
- Compostage en parcelle : fumier transporté sur la parcelle, compost récupéré sur place
- Compostage à la ferme : aire de compostage (bâtiment), processus automatique avec retournements manuels
- Utilisable en conventionnel et BIO
- Vendable entre joueurs

### 4.2 Schéma BDD

```sql
INSERT INTO building_type (name, slug, category, unit, base_cost_per_unit, energy_kwh_base)
VALUES ('Aire de compostage', 'aire_compostage', 'b', 'tonne', 20.00, 0);

CREATE TABLE compost_batch (
  id              SERIAL PRIMARY KEY,
  farm_id         INT NOT NULL REFERENCES farm(id) ON DELETE CASCADE,
  parcel_id       INT REFERENCES parcel(id),          -- NULL si compostage à la ferme
  building_id     INT REFERENCES building(id),         -- NULL si compostage en parcelle
  fumier_tons     DECIMAL(10,2) NOT NULL,
  compost_tons    DECIMAL(10,2) NOT NULL,              -- fumier_tons / 3
  state           VARCHAR(15) NOT NULL DEFAULT 'composting',
  -- states: 'composting', 'ready', 'collected'
  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  ready_at        TIMESTAMPTZ NOT NULL,                -- started_at + 14 jours
  turn_1_done     BOOLEAN NOT NULL DEFAULT false,
  turn_1_deadline_start TIMESTAMPTZ NOT NULL,          -- started_at + 4 jours
  turn_1_deadline_end   TIMESTAMPTZ NOT NULL,          -- started_at + 5 jours
  turn_2_done     BOOLEAN NOT NULL DEFAULT false,
  turn_2_deadline_start TIMESTAMPTZ NOT NULL,          -- started_at + 9 jours
  turn_2_deadline_end   TIMESTAMPTZ NOT NULL,          -- started_at + 10 jours
  loss_pct        DECIMAL(5,2) NOT NULL DEFAULT 0,
  completed_at    TIMESTAMPTZ,
  CHECK (parcel_id IS NOT NULL OR building_id IS NOT NULL)
);
CREATE INDEX idx_compost_farm ON compost_batch(farm_id) WHERE state != 'collected';
```

### 4.3 Logique métier

```
COMPOST_RATIO = 3.0          -- 3T fumier → 1T compost
COMPOST_DURATION_DAYS = 14
COMPOST_TURN1_DAYS = [4, 5]
COMPOST_TURN2_DAYS = [9, 10]
COMPOST_MISS_PENALTY = 0.50  -- 50% perte par retournement manqué
COMPOST_DOSE_T_HA = 15.0
COMPOST_NUTRIENTS = { n: 95, p: 60, k: 120, ca: 180, mg: 35, s: 60 }

function startCompost(player_id, location_type, location_id, fumier_tons):
    farm = getPrimaryFarm(player_id)
    ASSERT fumier_tons >= 3.0                                        → 400 "Min 3T fumier"

    -- Vérifier stock fumier
    stock = getInventoryQuantity(farm.id, 'manure')
    ASSERT stock >= fumier_tons * 1000                               → 409 "Fumier insuffisant"

    compost_tons = fumier_tons / COMPOST_RATIO

    IF location_type == 'parcel':
        parcel = getParcel(location_id)
        ASSERT parcel.farm.player_id == player_id                    → 403
        ASSERT NOT EXISTS active crop on parcel                      → 409
        building_id = NULL
        parcel_id = location_id
    ELIF location_type == 'building':
        building = getBuilding(location_id)
        ASSERT building.farm.player_id == player_id                  → 403
        ASSERT getBuildingType(building).slug == 'aire_compostage'   → 400
        parcel_id = NULL
        building_id = location_id

    removeFromInventory(farm.id, 'manure', fumier_tons * 1000)

    now = now()
    batch = INSERT INTO compost_batch (
        farm_id, parcel_id, building_id, fumier_tons, compost_tons,
        ready_at,
        turn_1_deadline_start, turn_1_deadline_end,
        turn_2_deadline_start, turn_2_deadline_end
    ) VALUES (
        farm.id, parcel_id, building_id, fumier_tons, compost_tons,
        now + INTERVAL '14 days',
        now + INTERVAL '4 days', now + INTERVAL '5 days',
        now + INTERVAL '9 days', now + INTERVAL '10 days'
    ) RETURNING *

    spendPA(player_id, 1.0, 'start_compost', { location_type, location_id })
    RETURN batch

function turnCompost(player_id, batch_id, turn_number):
    batch = SELECT * FROM compost_batch WHERE id = batch_id
    ASSERT batch EXISTS AND batch.state == 'composting'              → 409
    ASSERT batch.farm.player_id == player_id                         → 403

    -- Vérifier matériel : retourneur d'andains
    retourneur = findVehicle(player_id, family='soil', slug_contains='retourneur')
    tractor = findVehicle(player_id, 'motor')
    ASSERT retourneur AND tractor (not broken)                       → 409 "Retourneur requis"

    now = now()
    IF turn_number == 1:
        ASSERT NOT batch.turn_1_done                                 → 409 "Déjà fait"
        ASSERT now >= batch.turn_1_deadline_start
               AND now <= batch.turn_1_deadline_end                  → 409 "Hors fenêtre j4-j5"
        UPDATE compost_batch SET turn_1_done = true WHERE id = batch_id
    ELIF turn_number == 2:
        ASSERT NOT batch.turn_2_done                                 → 409 "Déjà fait"
        ASSERT now >= batch.turn_2_deadline_start
               AND now <= batch.turn_2_deadline_end                  → 409 "Hors fenêtre j9-j10"
        UPDATE compost_batch SET turn_2_done = true WHERE id = batch_id

    spendPA(player_id, 1.0, 'turn_compost', { batch_id, turn_number })
    consumeHVC(player_id, tractor, 1.0)
    RETURN { turn_number, done: true }

-- Tick quotidien : vérifier les lots prêts et appliquer les pénalités
function dailyCompostCheck(server_id):
    batches = SELECT * FROM compost_batch WHERE state = 'composting'

    FOR EACH batch IN batches:
        now = now()
        -- Vérifier retournements manqués
        loss = 0
        IF now > batch.turn_1_deadline_end AND NOT batch.turn_1_done:
            loss += COMPOST_MISS_PENALTY
        IF now > batch.turn_2_deadline_end AND NOT batch.turn_2_done:
            loss += COMPOST_MISS_PENALTY

        IF loss != batch.loss_pct:
            new_compost = batch.fumier_tons / COMPOST_RATIO * (1.0 - loss)
            UPDATE compost_batch SET loss_pct = loss, compost_tons = new_compost
                   WHERE id = batch.id

        -- Lot prêt ?
        IF now >= batch.ready_at:
            UPDATE compost_batch SET state = 'ready' WHERE id = batch.id

function collectCompost(player_id, batch_id):
    batch = SELECT * FROM compost_batch WHERE id = batch_id
    ASSERT batch.state == 'ready'                                    → 409 "Pas encore prêt"
    ASSERT batch.farm.player_id == player_id                         → 403

    addToInventory(player_id, NULL, 'compost', NULL, batch.compost_tons * 1000, 'kg')
    UPDATE compost_batch SET state = 'collected', completed_at = now()
           WHERE id = batch_id

    RETURN { compost_tons: batch.compost_tons, loss_pct: batch.loss_pct }

function spreadCompost(player_id, parcel_id):
    parcel = getParcel(parcel_id)
    ASSERT parcel.farm.player_id == player_id                        → 403

    ha = parcel.area_m2 / 10000
    needed_kg = COMPOST_DOSE_T_HA * ha * 1000
    farm = getPrimaryFarm(player_id)
    stock = getInventoryQuantity(farm.id, 'compost')
    ASSERT stock >= needed_kg                                        → 409 "Compost insuffisant"

    tractor = findVehicle(player_id, 'motor')
    spreader = findVehicle(player_id, 'treatment', slug_contains='epandeur_fumier')
    ASSERT tractor AND spreader (not broken)                         → 409

    pa_cost = ha * 0.5
    move_cost = calculateMoveCost(farm.prefecture_id, parcel.prefecture_id)
    IF move_cost > 0:
        spendPA(player_id, move_cost, 'move', { to_prefecture_id: parcel.prefecture_id })
    spendPA(player_id, pa_cost, 'spread_compost', { parcel_id })
    consumeHVC(player_id, tractor, pa_cost)

    removeFromInventory(farm.id, 'compost', needed_kg)
    addNutrients(parcel_id, COMPOST_NUTRIENTS)

    -- Marquer fertilisé si culture en cours
    crop = getActiveCrop(parcel_id)
    IF crop EXISTS AND crop.state IN ('sown','growing'):
        UPDATE crop SET fertilized = true WHERE id = crop.id

    RETURN { nutrients_added: COMPOST_NUTRIENTS, quantity_tons: COMPOST_DOSE_T_HA * ha }
```

### 4.4 API Endpoints

#### POST `/api/compost/start`

```
Request: { "location_type": "building", "location_id": 5, "fumier_tons": 90 }
Response 201:
{
  "id": 1, "fumier_tons": 90, "compost_tons": 30,
  "ready_at": "2026-04-18T22:00:00Z",
  "turn_1_window": { "start": "2026-04-08", "end": "2026-04-09" },
  "turn_2_window": { "start": "2026-04-13", "end": "2026-04-14" }
}
Erreurs: 400, 403, 409 (fumier insuffisant, culture en cours)
```

#### POST `/api/compost/:id/turn`

```
Request: { "turn_number": 1 }
Response 200: { "turn_number": 1, "done": true }
Erreurs: 409 (hors fenêtre, déjà fait, matériel)
```

#### POST `/api/compost/:id/collect`

```
Response 200: { "compost_tons": 30.0, "loss_pct": 0 }
Erreurs: 409 (pas prêt)
```

#### POST `/api/parcels/:id/spread-compost`

```
Response 200:
{
  "quantity_tons": 150,
  "nutrients_added": { "n": 95, "p": 60, "k": 120, "ca": 180, "mg": 35, "s": 60 }
}
Erreurs: 403, 409 (compost insuffisant, matériel)
```

#### GET `/api/compost`

```
Response 200:
{
  "batches": [
    { "id": 1, "state": "composting", "compost_tons": 30, "turn_1_done": true, "turn_2_done": false, ... }
  ]
}
```

### 4.5 Tests

**Tests unitaires :**
- 90T fumier → 30T compost (ratio 3:1)
- 3T fumier → 1T compost (minimum)
- 2T fumier → 400 (min 3T)
- Retournement 1 jour 4 → OK
- Retournement 1 jour 5 → OK
- Retournement 1 jour 3 → 409 (trop tôt)
- Retournement 1 jour 6 → 409 (trop tard)
- 0 retournement manqué → 0% perte
- 1 retournement manqué → 50% perte (30T → 15T)
- 2 retournements manqués → 100% perte (30T → 0T)
- Épandage 10 ha → 150T compost, nutriments ajoutés
- Compost utilisable en BIO
- Fumier insuffisant → 409

**Tests d'intégration :**
- Acheter fumier → démarrer compost → retourner j4 → retourner j9 → collecter j14 → épandre → vérifier sol
- Démarrer compost → manquer retournement 1 → collecter → vérifier perte 50%

---

## Feature 5 — Retenue collinaire

### 5.1 Description

La retenue collinaire est une réserve d'eau alimentée par pompage depuis une rivière (pas un ruisseau). Elle permet d'irriguer les parcelles situées dans la même canton. Le joueur construit la retenue, installe un système de pompage, et peut activer/désactiver l'irrigation par parcelle.

**Règles métier :**
- Construction : bâtiment de type `retenue_collinaire`, capacité en m³
- Alimentation : pompage depuis une rivière dans la même canton (vérification zone.has_river)
- Pas d'alimentation depuis un ruisseau
- Pompage : action manuelle ou programmable, remplit la retenue
- Irrigation : activation par parcelle (même canton que la retenue)
- Effet : augmente la jauge pluie de la parcelle (+5/jour tant qu'irrigué)
- Consommation : 10 m³/ha/jour d'irrigation
- Non cumulable avec pivot central sur la même parcelle

### 5.2 Schéma BDD

```sql
INSERT INTO building_type (name, slug, category, unit, base_cost_per_unit, energy_kwh_base)
VALUES ('Retenue collinaire', 'retenue_collinaire', 'b', 'm3', 5.00, 0.01);

-- Ajout flag rivière sur canton
ALTER TABLE canton ADD COLUMN has_river BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE reservoir (
  id              SERIAL PRIMARY KEY,
  building_id     INT NOT NULL REFERENCES building(id) ON DELETE CASCADE UNIQUE,
  prefecture_id         INT NOT NULL REFERENCES zone(id),
  capacity_m3     DECIMAL(12,2) NOT NULL,
  current_m3      DECIMAL(12,2) NOT NULL DEFAULT 0,
  pump_rate_m3_h  DECIMAL(8,2) NOT NULL DEFAULT 50.0  -- m³/heure de pompage
);

CREATE TABLE parcel_irrigation (
  id              SERIAL PRIMARY KEY,
  parcel_id       INT NOT NULL REFERENCES parcel(id) ON DELETE CASCADE UNIQUE,
  reservoir_id    INT NOT NULL REFERENCES reservoir(id),
  active          BOOLEAN NOT NULL DEFAULT false,
  started_at      TIMESTAMPTZ
);
CREATE INDEX idx_irrigation_reservoir ON parcel_irrigation(reservoir_id) WHERE active = true;
```

### 5.3 Logique métier

```
IRRIGATION_RAIN_BONUS = 5       -- +5 sur jauge pluie/jour
IRRIGATION_CONSUMPTION = 10.0   -- m³/ha/jour
PUMP_PA_PER_HOUR = 0.5

function buildReservoir(player_id, prefecture_id, capacity_m3):
    farm = getPrimaryFarm(player_id)
    zone = getZone(prefecture_id)
    ASSERT zone.has_river                                            → 400 "Pas de rivière dans ce canton"

    -- Construire le bâtiment via buildBuilding() existant
    building = buildBuilding(player_id, 'retenue_collinaire', capacity_m3)

    INSERT INTO reservoir (building_id, prefecture_id, capacity_m3)
    VALUES (building.id, prefecture_id, capacity_m3)
    RETURNING *

function pumpWater(player_id, reservoir_id, hours):
    reservoir = SELECT * FROM reservoir WHERE id = reservoir_id
    building = getBuilding(reservoir.building_id)
    ASSERT building.farm.player_id == player_id                      → 403
    ASSERT hours >= 1 AND hours <= 24                                → 400

    volume = reservoir.pump_rate_m3_h * hours
    new_level = MIN(reservoir.capacity_m3, reservoir.current_m3 + volume)
    actual_pumped = new_level - reservoir.current_m3

    pa_cost = hours * PUMP_PA_PER_HOUR
    ASSERT canPerformAction(player_id, pa_cost)                      → 403
    spendPA(player_id, pa_cost, 'pump_water', { reservoir_id, hours })

    UPDATE reservoir SET current_m3 = new_level WHERE id = reservoir_id
    RETURN { pumped_m3: actual_pumped, current_m3: new_level, pa_spent: pa_cost }

function toggleIrrigation(player_id, parcel_id, reservoir_id, active):
    parcel = getParcel(parcel_id)
    reservoir = SELECT * FROM reservoir WHERE id = reservoir_id
    ASSERT parcel.farm.player_id == player_id                        → 403
    ASSERT parcel.prefecture_id == reservoir.prefecture_id                       → 400 "Parcelle pas dans la même canton"

    -- Vérifier pas de pivot sur cette parcelle
    ASSERT NOT EXISTS pivot_installation WHERE parcel_id = parcel_id  → 409 "Pivot déjà installé"

    UPSERT parcel_irrigation (parcel_id, reservoir_id, active, started_at)
    VALUES (parcel_id, reservoir_id, active, CASE WHEN active THEN now() ELSE NULL END)
    ON CONFLICT (parcel_id) DO UPDATE SET active = active,
        started_at = CASE WHEN active THEN COALESCE(started_at, now()) ELSE NULL END

    RETURN { parcel_id, active }

-- Tick quotidien : consommer eau et irriguer
function dailyIrrigation(server_id):
    irrigations = SELECT pi.*, p.area_m2, r.id AS reservoir_id, r.current_m3
        FROM parcel_irrigation pi
        JOIN parcel p ON p.id = pi.parcel_id
        JOIN reservoir r ON r.id = pi.reservoir_id
        JOIN building b ON b.id = r.building_id
        JOIN farm f ON f.id = b.farm_id
        JOIN player pl ON pl.id = f.player_id
        WHERE pl.server_id = server_id AND pi.active = true

    FOR EACH irr IN irrigations:
        ha = irr.area_m2 / 10000
        needed = IRRIGATION_CONSUMPTION * ha

        IF irr.current_m3 >= needed:
            UPDATE reservoir SET current_m3 = current_m3 - needed
                   WHERE id = irr.reservoir_id
            UPDATE parcel SET rain_gauge = LEAST(100, rain_gauge + IRRIGATION_RAIN_BONUS)
                   WHERE id = irr.parcel_id
        ELSE:
            -- Pas assez d'eau → désactiver
            UPDATE parcel_irrigation SET active = false WHERE id = irr.id
            createNotification(player_id, 'irrigation_empty', 'warning',
                'Retenue vide', 'Irrigation désactivée parcelle #' + irr.parcel_id)
```

### 5.4 API Endpoints

#### POST `/api/reservoirs`

```
Request: { "prefecture_id": 5, "capacity_m3": 5000 }
Response 201: { "id": 1, "prefecture_id": 5, "capacity_m3": 5000, "current_m3": 0 }
Erreurs: 400 (pas de rivière), 403
```

#### POST `/api/reservoirs/:id/pump`

```
Request: { "hours": 4 }
Response 200: { "pumped_m3": 200, "current_m3": 200, "pa_spent": 2.0 }
Erreurs: 400, 403
```

#### POST `/api/parcels/:id/irrigation`

```
Request: { "reservoir_id": 1, "active": true }
Response 200: { "parcel_id": 1, "active": true }
Erreurs: 400 (canton différent), 403, 409 (pivot installé)
```

#### GET `/api/reservoirs`

```
Response 200:
{
  "reservoirs": [
    { "id": 1, "prefecture_id": 5, "capacity_m3": 5000, "current_m3": 3200,
      "irrigated_parcels": [ { "parcel_id": 1, "active": true } ] }
  ]
}
```

### 5.5 Tests

**Tests unitaires :**
- Construction dans zone avec rivière → OK
- Construction dans zone sans rivière → 400
- Pompage 4h à 50 m³/h → 200 m³ ajoutés
- Pompage dépassant capacité → borné à capacity_m3
- Irrigation 10 ha/jour → 100 m³ consommés
- Irrigation parcelle canton différent → 400
- Irrigation + pivot même parcelle → 409
- Retenue vide → irrigation désactivée automatiquement
- Jauge pluie +5/jour avec irrigation (bornée à 100)

**Tests d'intégration :**
- Construire retenue → pomper → activer irrigation → tick → vérifier jauge pluie augmente
- Pomper insuffisamment → tick consomme tout → irrigation désactivée + notification

---

## Feature 6 — Pivot central irrigation

### 6.1 Description

Le pivot central est un système d'irrigation fixe installé dans une parcelle. Il nécessite des rampes (30 HT par installation/désinstallation). L'arrosage est programmable de 1 à 24h. 1h d'arrosage = +1 mm sur la jauge = 10 m³/ha. Non cumulable avec l'enrouleur ou la retenue collinaire sur la même parcelle. Le pivot doit être détruit avant vente de la parcelle.

**Règles métier :**
- Construction pivot : dans une parcelle, nécessite un forage (source d'eau)
- Rampes : ajoutées selon la surface, 30 HT par installation ou désinstallation
- Programmation : 1 à 24h d'arrosage
- Débit : 10 m³/ha/h → +1 mm/h sur jauge pluie
- 24h max → +24 mm sur jauge, 240 m³/ha consommés
- Source requise : forage dans la parcelle (10 niveaux, 100k-1M L/jour)
- Non cumulable avec enrouleur ou retenue collinaire sur même parcelle
- Doit être détruit avant vente parcelle

### 6.2 Schéma BDD

```sql
CREATE TABLE well (
  id          SERIAL PRIMARY KEY,
  parcel_id   INT NOT NULL REFERENCES parcel(id) ON DELETE CASCADE UNIQUE,
  level       SMALLINT NOT NULL CHECK (level BETWEEN 1 AND 10),
  capacity_l_day DECIMAL(12,2) NOT NULL,  -- 100000 à 1000000
  cost        DECIMAL(10,2) NOT NULL DEFAULT 150.00,
  drilled_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE pivot_installation (
  id              SERIAL PRIMARY KEY,
  parcel_id       INT NOT NULL REFERENCES parcel(id) ON DELETE CASCADE UNIQUE,
  well_id         INT NOT NULL REFERENCES well(id),
  rampe_count     SMALLINT NOT NULL DEFAULT 0,
  program_hours   SMALLINT NOT NULL DEFAULT 0 CHECK (program_hours BETWEEN 0 AND 24),
  is_active       BOOLEAN NOT NULL DEFAULT false,
  installed_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_watered_at TIMESTAMPTZ
);
```

### 6.3 Logique métier

```
WELL_COST = 150.00
WELL_LEVELS = {
  1: 100000, 2: 200000, 3: 300000, 4: 400000, 5: 500000,
  6: 600000, 7: 700000, 8: 800000, 9: 900000, 10: 1000000
}  -- L/jour
RAMPE_INSTALL_PA = 30.0
PIVOT_M3_PER_HA_PER_H = 10.0   -- 10 m³/ha/h
PIVOT_MM_PER_H = 1              -- +1 mm/h sur jauge

function drillWell(player_id, parcel_id):
    parcel = getParcel(parcel_id)
    ASSERT parcel.farm.player_id == player_id                        → 403
    ASSERT NOT EXISTS well WHERE parcel_id = parcel_id               → 409 "Forage existant"

    debit(player_id, WELL_COST, 'well', 'Forage parcelle #' + parcel_id, 'parcel', parcel_id)
    spendPA(player_id, 1.0, 'drill_well', { parcel_id })

    -- Niveau aléatoire (1-10)
    level = randomInt(1, 10)
    capacity = WELL_LEVELS[level]

    INSERT INTO well (parcel_id, level, capacity_l_day, cost)
    VALUES (parcel_id, level, capacity, WELL_COST)
    RETURNING *

function installPivot(player_id, parcel_id):
    parcel = getParcel(parcel_id)
    well = SELECT * FROM well WHERE parcel_id = parcel_id
    ASSERT parcel.farm.player_id == player_id                        → 403
    ASSERT well EXISTS                                               → 409 "Forage requis"
    ASSERT NOT EXISTS pivot_installation WHERE parcel_id = parcel_id → 409 "Pivot existant"
    ASSERT NOT EXISTS parcel_irrigation WHERE parcel_id = parcel_id AND active = true
                                                                     → 409 "Retenue active"

    -- Matériel pivot requis
    pivot = findVehicle(player_id, family='special', slug_contains='pivot')
    ASSERT pivot EXISTS                                              → 409 "Matériel pivot requis"

    spendPA(player_id, 2.0, 'install_pivot', { parcel_id })

    INSERT INTO pivot_installation (parcel_id, well_id)
    VALUES (parcel_id, well.id)
    RETURNING *

function addRampe(player_id, parcel_id):
    pivot = SELECT * FROM pivot_installation WHERE parcel_id = parcel_id
    ASSERT pivot EXISTS                                              → 409
    ASSERT canPerformAction(player_id, RAMPE_INSTALL_PA)             → 403 "30 HT requis"

    spendPA(player_id, RAMPE_INSTALL_PA, 'install_rampe', { parcel_id })

    UPDATE pivot_installation SET rampe_count = rampe_count + 1
           WHERE id = pivot.id
    RETURN { rampe_count: pivot.rampe_count + 1, pa_spent: RAMPE_INSTALL_PA }

function removeRampe(player_id, parcel_id):
    pivot = SELECT * FROM pivot_installation WHERE parcel_id = parcel_id
    ASSERT pivot EXISTS AND pivot.rampe_count > 0                    → 409

    spendPA(player_id, RAMPE_INSTALL_PA, 'remove_rampe', { parcel_id })

    UPDATE pivot_installation SET rampe_count = rampe_count - 1
           WHERE id = pivot.id
    RETURN { rampe_count: pivot.rampe_count - 1 }

function programPivot(player_id, parcel_id, hours):
    pivot = SELECT * FROM pivot_installation WHERE parcel_id = parcel_id
    ASSERT pivot EXISTS                                              → 409
    ASSERT pivot.rampe_count > 0                                     → 409 "Aucune rampe"
    ASSERT hours >= 1 AND hours <= 24                                → 400
    ASSERT parcel.farm.player_id == player_id                        → 403

    UPDATE pivot_installation SET program_hours = hours, is_active = true
           WHERE id = pivot.id
    RETURN { program_hours: hours, is_active: true }

-- Tick quotidien : exécuter l'arrosage programmé
function dailyPivotIrrigation(server_id):
    pivots = SELECT pi.*, p.area_m2, w.capacity_l_day
        FROM pivot_installation pi
        JOIN parcel p ON p.id = pi.parcel_id
        JOIN well w ON w.id = pi.well_id
        JOIN farm f ON f.id = p.farm_id
        JOIN player pl ON pl.id = f.player_id
        WHERE pl.server_id = server_id AND pi.is_active = true AND pi.program_hours > 0

    FOR EACH pv IN pivots:
        ha = pv.area_m2 / 10000
        water_needed_l = PIVOT_M3_PER_HA_PER_H * ha * pv.program_hours * 1000
        mm_added = PIVOT_MM_PER_H * pv.program_hours

        IF water_needed_l <= pv.capacity_l_day:
            UPDATE parcel SET rain_gauge = LEAST(100, rain_gauge + mm_added)
                   WHERE id = pv.parcel_id
            UPDATE pivot_installation SET last_watered_at = now() WHERE id = pv.id
        ELSE:
            -- Source insuffisante : arrosage partiel
            actual_hours = floor(pv.capacity_l_day / (PIVOT_M3_PER_HA_PER_H * ha * 1000))
            actual_mm = PIVOT_MM_PER_H * actual_hours
            UPDATE parcel SET rain_gauge = LEAST(100, rain_gauge + actual_mm)
                   WHERE id = pv.parcel_id

function destroyPivot(player_id, parcel_id):
    pivot = SELECT * FROM pivot_installation WHERE parcel_id = parcel_id
    ASSERT pivot EXISTS                                              → 409
    ASSERT parcel.farm.player_id == player_id                        → 403

    spendPA(player_id, 2.0 + pivot.rampe_count * RAMPE_INSTALL_PA, 'destroy_pivot', { parcel_id })

    DELETE FROM pivot_installation WHERE id = pivot.id
    RETURN { destroyed: true }
```

### 6.4 API Endpoints

#### POST `/api/parcels/:id/drill-well`

```
Response 201: { "level": 7, "capacity_l_day": 700000, "cost": 150.00 }
Erreurs: 403, 409 (forage existant)
```

#### POST `/api/parcels/:id/install-pivot`

```
Response 201: { "id": 1, "parcel_id": 1, "rampe_count": 0 }
Erreurs: 403, 409 (forage requis, pivot existant, retenue active)
```

#### POST `/api/parcels/:id/pivot/add-rampe`

```
Response 200: { "rampe_count": 1, "pa_spent": 30 }
Erreurs: 403, 409
```

#### POST `/api/parcels/:id/pivot/remove-rampe`

```
Response 200: { "rampe_count": 0 }
Erreurs: 409 (aucune rampe)
```

#### POST `/api/parcels/:id/pivot/program`

```
Request: { "hours": 12 }
Response 200: { "program_hours": 12, "is_active": true }
Erreurs: 400 (hours hors 1-24), 409 (pas de rampe)
```

#### DELETE `/api/parcels/:id/pivot`

```
Response 200: { "destroyed": true, "pa_spent": 92 }
Erreurs: 403, 409
```

### 6.5 Tests

**Tests unitaires :**
- Forage → niveau aléatoire 1-10, coût 150€
- Double forage même parcelle → 409
- Installation pivot sans forage → 409
- Ajout rampe → 30 HT
- Retrait rampe → 30 HT
- Programmation 12h sur 10 ha → 120 m³/ha, +12 mm jauge
- Programmation 24h → +24 mm jauge
- Programmation 0h → 400
- Programmation 25h → 400
- Source niveau 1 (100k L/jour), 10 ha, 24h → besoin 2.4M L > 100k → arrosage partiel
- Pivot + retenue même parcelle → 409
- Destruction pivot avec 3 rampes → HT = 2 + 3×30 = 92 HT
- Vente parcelle avec pivot → 409 (doit détruire d'abord)

**Tests d'intégration :**
- Forage → installer pivot → ajouter rampe → programmer 12h → tick → vérifier jauge +12
- Programmer pivot → tick quotidien × 5 → vérifier jauge augmente chaque jour

---

## Feature 7 — Chien de troupeau

### 7.1 Description

Le chien de troupeau permet de déplacer des animaux d'un pré à un autre dans la même canton, sans bétaillère. 5 races disponibles. Le chien dispose de 40 HT/jour dédiés au déplacement d'animaux. Il n'a pas besoin de nourriture.

**Règles métier :**
- 5 races : Border Collie, Berger Australien, Beauceron, Berger des Pyrénées, Patou
- Achat : à la Le Marché Central
- HT chien : 40 HT/jour (indépendants des HT du joueur)
- Déplacement : animaux d'un pré vers un autre pré dans la même canton
- Coût HT chien par déplacement : 1 HT/animal déplacé
- Pas de nourriture requise
- Pas de reproduction
- Pas de mort (durée de vie illimitée)
- Revente possible à 50% du prix d'achat

### 7.2 Schéma BDD

```sql
CREATE TABLE herding_dog_breed (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(50) NOT NULL UNIQUE,
  slug        VARCHAR(30) NOT NULL UNIQUE,
  price       DECIMAL(10,2) NOT NULL,
  pa_per_day  SMALLINT NOT NULL DEFAULT 35
);

INSERT INTO herding_dog_breed (name, slug, price) VALUES
('Border Collie',          'border_collie',     2500.00),
('Berger Australien',      'berger_australien', 2800.00),
('Beauceron',              'beauceron',         2200.00),
('Berger des Pyrénées',    'berger_pyrenees',   2000.00),
('Patou',                  'patou',             3000.00);

CREATE TABLE herding_dog (
  id          SERIAL PRIMARY KEY,
  farm_id     INT NOT NULL REFERENCES farm(id) ON DELETE CASCADE,
  breed_id    INT NOT NULL REFERENCES herding_dog_breed(id),
  name        VARCHAR(50),
  ht_today    SMALLINT NOT NULL DEFAULT 35,
  bought_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  bought_price DECIMAL(10,2) NOT NULL
);
CREATE INDEX idx_herding_dog_farm ON herding_dog(farm_id);
```

### 7.3 Logique métier

```
DOG_PA_PER_ANIMAL = 1.0
DOG_RESALE_FACTOR = 0.50

function buyDog(player_id, breed_slug):
    breed = SELECT * FROM herding_dog_breed WHERE slug = breed_slug
    ASSERT breed EXISTS                                              → 404
    farm = getPrimaryFarm(player_id)

    debit(player_id, breed.price, 'dog_buy', 'Achat ' + breed.name, 'herding_dog', NULL)
    spendPA(player_id, 0.5, 'buy_dog', { breed: breed_slug })

    INSERT INTO herding_dog (farm_id, breed_id, bought_price)
    VALUES (farm.id, breed.id, breed.price)
    RETURNING *

function moveAnimalsWithDog(player_id, dog_id, animal_ids, from_parcel_id, to_parcel_id):
    dog = SELECT d.*, b.pa_per_day FROM herding_dog d
          JOIN herding_dog_breed b ON b.id = d.breed_id
          WHERE d.id = dog_id
    ASSERT dog EXISTS AND dog.farm.player_id == player_id            → 403

    from_parcel = getParcel(from_parcel_id)
    to_parcel = getParcel(to_parcel_id)
    ASSERT from_parcel.type == 'meadow' AND to_parcel.type == 'meadow' → 400 "Prés requis"
    ASSERT from_parcel.prefecture_id == to_parcel.prefecture_id                  → 400 "Même zone requise"
    ASSERT from_parcel.farm.player_id == player_id                   → 403
    ASSERT to_parcel.farm.player_id == player_id                     → 403

    nb_animals = LENGTH(animal_ids)
    pa_needed = nb_animals * DOG_PA_PER_ANIMAL
    ASSERT dog.ht_today >= pa_needed                                 → 409 "PA chien insuffisants"

    -- Vérifier que les animaux sont bien dans from_parcel
    FOR EACH aid IN animal_ids:
        animal = getAnimal(aid)
        ASSERT animal.parcel_id == from_parcel_id                    → 409 "Animal pas dans ce pré"

    -- Vérifier capacité du pré destination
    current_count = SELECT COUNT(*) FROM animal WHERE parcel_id = to_parcel_id
    -- (capacité vérifiée selon surface pré et espèce — dépend Phase 2)

    -- Déplacer les animaux
    UPDATE animal SET parcel_id = to_parcel_id WHERE id = ANY(animal_ids)
    UPDATE herding_dog SET ht_today = ht_today - pa_needed WHERE id = dog_id

    RETURN { moved: nb_animals, dog_pa_remaining: dog.ht_today - pa_needed }

function sellDog(player_id, dog_id):
    dog = SELECT * FROM herding_dog WHERE id = dog_id
    ASSERT dog.farm.player_id == player_id                           → 403

    resale = dog.bought_price * DOG_RESALE_FACTOR
    credit(player_id, resale, 'dog_sell', 'Vente chien', 'herding_dog', dog_id)
    DELETE FROM herding_dog WHERE id = dog_id
    RETURN { resale_price: resale }

-- Tick quotidien : reset HT chien
function dailyDogPAReset(server_id):
    UPDATE herding_dog d SET ht_today = b.pa_per_day
    FROM herding_dog_breed b
    WHERE d.breed_id = b.id
    AND d.farm_id IN (SELECT f.id FROM farm f JOIN player p ON p.id = f.player_id
                      WHERE p.server_id = server_id)
```

### 7.4 API Endpoints

#### POST `/api/dogs/buy`

```
Request: { "breed": "border_collie" }
Response 201: { "id": 1, "breed": "Border Collie", "ht_today": 35, "price": 2500.00 }
```

#### POST `/api/dogs/:id/move-animals`

```
Request: { "animal_ids": [1,2,3,4,5], "from_parcel_id": 10, "to_parcel_id": 12 }
Response 200: { "moved": 5, "dog_pa_remaining": 30 }
Erreurs: 400 (pas des prés, zones différentes), 403, 409 (PA chien insuffisants)
```

#### POST `/api/dogs/:id/sell`

```
Response 200: { "resale_price": 1250.00 }
```

#### GET `/api/dogs`

```
Response 200:
{ "dogs": [ { "id": 1, "breed": "Border Collie", "ht_today": 30, "name": null } ] }
```

### 7.5 Tests

**Tests unitaires :**
- Achat Border Collie → 2500€, 40 HT/jour
- Déplacement 5 animaux → 5 HT chien consommés, 30 restants
- Déplacement 36 animaux → 409 (40 HT max)
- Déplacement pré→pré même canton → OK
- Déplacement pré→pré canton différent → 400
- Déplacement pré→champ → 400
- Vente chien → 50% prix achat
- Reset HT quotidien → 35

**Tests d'intégration :**
- Acheter chien → déplacer 10 bovins pré A → pré B → vérifier animaux dans pré B
- Déplacer 35 animaux → HT chien = 0 → tick → HT chien = 35

---

## Feature 8 — Négociant en bestiaux

### 8.1 Description

Le négociant en bestiaux est un PNJ appelable 1 fois par mois Cultivia. Il propose des animaux adultes dans 4 races maximum au choix du joueur. Les animaux achetés au négociant ne sont pas revendables à d'autres joueurs et ne peuvent pas participer aux concours GénétiLab. Ils sont destinés à la reproduction et ne peuvent être vendus qu'à l'abattoir.

**Règles métier :**
- 1 appel par mois Cultivia (cooldown 1 mois)
- Le joueur choisit jusqu'à 4 races parmi celles disponibles
- Le négociant propose des animaux adultes (âge ≥ maturité de l'espèce)
- Prix : prix Coop × 1.20 (majoration 20%)
- Animaux marqués `from_dealer = true`
- Restrictions : pas de vente entre joueurs, pas de concours GénétiLab
- Vente à l'abattoir : autorisée
- Génétique : indices moyens (50% de l'indice max serveur)

### 8.2 Schéma BDD

```sql
-- Ajout colonne sur la table animal existante (Phase 2)
ALTER TABLE animal ADD COLUMN from_dealer BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE dealer_call (
  id          SERIAL PRIMARY KEY,
  player_id   INT NOT NULL REFERENCES player(id),
  called_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  breeds_requested VARCHAR(30)[] NOT NULL,  -- max 4 slugs
  animals_bought INT NOT NULL DEFAULT 0
);
CREATE INDEX idx_dealer_call_player ON dealer_call(player_id, called_at DESC);
```

### 8.3 Logique métier

```
DEALER_COOLDOWN_MONTHS = 1
DEALER_MAX_BREEDS = 4
DEALER_PRICE_FACTOR = 1.20
DEALER_GENETICS_PCT = 0.50  -- 50% de l'indice max

function callDealer(player_id, breed_slugs):
    ASSERT LENGTH(breed_slugs) >= 1 AND LENGTH(breed_slugs) <= DEALER_MAX_BREEDS → 400
    server = getServerForPlayer(player_id)

    -- Vérifier cooldown
    last_call = SELECT called_at FROM dealer_call
                WHERE player_id = player_id ORDER BY called_at DESC LIMIT 1
    IF last_call EXISTS:
        months_since = monthsDiff(last_call.called_at, now())
        ASSERT months_since >= DEALER_COOLDOWN_MONTHS                → 409 "1 appel/mois max"

    -- Vérifier que les races existent
    breeds = SELECT * FROM animal_breed WHERE slug = ANY(breed_slugs)
    ASSERT LENGTH(breeds) == LENGTH(breed_slugs)                     → 404 "Race inconnue"

    -- Générer le catalogue (3-5 animaux par race)
    catalog = []
    FOR EACH breed IN breeds:
        nb = randomInt(3, 5)
        FOR i IN 1..nb:
            animal = {
                breed: breed,
                sex: randomChoice(['male','female']),
                age_days: breed.maturity_days + randomInt(0, 180),
                genetics: breed.max_index * DEALER_GENETICS_PCT,
                price: breed.base_price * DEALER_PRICE_FACTOR
            }
            catalog.append(animal)

    INSERT INTO dealer_call (player_id, breeds_requested)
    VALUES (player_id, breed_slugs)

    spendPA(player_id, 1.0, 'call_dealer', { breeds: breed_slugs })
    RETURN { catalog, expires_in: '24h' }

function buyFromDealer(player_id, dealer_call_id, animal_selections):
    call = SELECT * FROM dealer_call WHERE id = dealer_call_id AND player_id = player_id
    ASSERT call EXISTS                                               → 404
    ASSERT now() - call.called_at < INTERVAL '1 day'                → 409 "Offre expirée"

    total_cost = 0
    animals_created = []
    FOR EACH sel IN animal_selections:
        -- Créer l'animal avec from_dealer = true
        animal = createAnimal(player_id, sel.breed_id, sel.sex, sel.age_days,
                              sel.genetics, from_dealer=true)
        total_cost += sel.price
        animals_created.append(animal)

    debit(player_id, total_cost, 'dealer_buy',
          'Achat négociant ' + LENGTH(animal_selections) + ' animaux', NULL, NULL)

    UPDATE dealer_call SET animals_bought = LENGTH(animal_selections)
           WHERE id = dealer_call_id

    RETURN { animals: animals_created, total_cost }

-- Contraintes dans les fonctions existantes :
-- sellAnimalToPlayer() : ASSERT NOT animal.from_dealer → 409 "Animal du négociant non revendable"
-- enterContest() : ASSERT NOT animal.from_dealer → 409 "Animal du négociant non éligible"
```

### 8.4 API Endpoints

#### POST `/api/dealer/call`

```
Request: { "breeds": ["charolaise", "limousine", "holstein", "montbeliarde"] }
Response 200:
{
  "call_id": 1,
  "catalog": [
    { "breed": "Charolaise", "sex": "female", "age_days": 730, "genetics": 50, "price": 1800.00 },
    ...
  ],
  "expires_at": "2026-04-05T22:00:00Z"
}
Erreurs: 400 (>4 races), 404 (race inconnue), 409 (cooldown)
```

#### POST `/api/dealer/:call_id/buy`

```
Request: { "selections": [ { "catalog_index": 0 }, { "catalog_index": 3 } ] }
Response 200: { "animals": [...], "total_cost": 3600.00 }
Erreurs: 403 (fonds), 409 (offre expirée)
```

### 8.5 Tests

**Tests unitaires :**
- Appel avec 4 races → OK, catalogue généré
- Appel avec 5 races → 400
- 2e appel même mois → 409
- 2e appel mois suivant → OK
- Prix animal = base × 1.20
- Génétique = 50% indice max
- Animal from_dealer = true
- Vente entre joueurs animal dealer → 409
- Concours animal dealer → 409
- Vente abattoir animal dealer → OK
- Offre expire après 24h

**Tests d'intégration :**
- Appeler négociant → acheter 2 animaux → vérifier from_dealer → tenter vente joueur → 409 → vendre abattoir → OK

---

## Feature 9 — Élevage industriel & ratio fusion

### 9.1 Description

Quand le nombre d'animaux d'un joueur dépasse un seuil par espèce, les fiches animales doivent être fusionnées (1 fiche = groupe d'animaux). Les animaux nommés, races à développer, daims et bisons sont exclus de la fusion. Plusieurs paliers de seuils avec des ratios minimum différents.

**Règles métier :**

| Espèces | Seuil | Ratio minimum |
|---------|-------|--------------|
| Volailles, pintades, canards, oies | 5 000 | 45 |
| | 1 000 000 | 150 |
| | 50 000 000 | 20 000 |
| Porcins | 12 000 | 45 |
| | 1 000 000 | 150 |
| | 50 000 000 | 20 000 |
| Lapins | 12 500 | 45 |
| | 1 000 000 | 150 |
| | 50 000 000 | 20 000 |
| Ovins, caprins, chevaux | 15 000 | 20 |
| Bovins | 20 000 | 20 |

- Exclusions : animaux nommés, races à développer, daims, bisons
- Fusion obligatoire : le joueur doit fusionner ses fiches pour respecter le ratio
- Fiche fusionnée : `animal_group` avec count, moyennes génétiques, âge moyen
- Vente/abattoir d'un groupe = vente de `count` animaux

### 9.2 Schéma BDD

```sql
CREATE TABLE fusion_threshold (
  id              SERIAL PRIMARY KEY,
  species_group   VARCHAR(30) NOT NULL,  -- 'poultry','porcine','rabbit','ovine_caprine_equine','bovine'
  threshold       INT NOT NULL,
  min_ratio       INT NOT NULL,
  UNIQUE(species_group, threshold)
);

INSERT INTO fusion_threshold (species_group, threshold, min_ratio) VALUES
('poultry',                5000,     45),
('poultry',                1000000,  150),
('poultry',                50000000, 20000),
('porcine',                12000,    45),
('porcine',                1000000,  150),
('porcine',                50000000, 20000),
('rabbit',                 12500,    45),
('rabbit',                 1000000,  150),
('rabbit',                 50000000, 20000),
('ovine_caprine_equine',   15000,    20),
('bovine',                 20000,    20);

-- Groupe d'animaux fusionnés
CREATE TABLE animal_group (
  id              SERIAL PRIMARY KEY,
  farm_id         INT NOT NULL REFERENCES farm(id) ON DELETE CASCADE,
  breed_id        INT NOT NULL REFERENCES animal_breed(id),
  count           INT NOT NULL CHECK (count > 0),
  avg_age_days    INT NOT NULL,
  avg_genetics    DECIMAL(6,2) NOT NULL,
  sex             VARCHAR(10) NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_animal_group_farm ON animal_group(farm_id);
```

### 9.3 Logique métier

```
FUSION_EXCLUDED_SPECIES = ['bison', 'deer']

function getSpeciesGroup(breed) -> string:
    IF breed.species IN ('chicken','guinea_fowl','duck','goose'): RETURN 'poultry'
    IF breed.species == 'pig': RETURN 'porcine'
    IF breed.species == 'rabbit': RETURN 'rabbit'
    IF breed.species IN ('sheep','goat','horse'): RETURN 'ovine_caprine_equine'
    IF breed.species == 'cattle': RETURN 'bovine'
    RETURN NULL

function checkFusionRequired(player_id) -> list:
    farm = getPrimaryFarm(player_id)
    violations = []

    -- Compter animaux par groupe d'espèce
    counts = SELECT getSpeciesGroup(ab.species) AS grp, COUNT(*) AS total
             FROM animal a
             JOIN animal_breed ab ON ab.id = a.breed_id
             WHERE a.farm_id = farm.id
             AND ab.species NOT IN FUSION_EXCLUDED_SPECIES
             AND a.name IS NULL  -- non nommés
             GROUP BY grp

    FOR EACH c IN counts:
        thresholds = SELECT * FROM fusion_threshold
                     WHERE species_group = c.grp AND threshold <= c.total
                     ORDER BY threshold DESC LIMIT 1
        IF thresholds EXISTS:
            -- Nombre max de fiches individuelles = total / min_ratio
            max_individual = c.total / thresholds.min_ratio
            current_individual = SELECT COUNT(*) FROM animal a
                JOIN animal_breed ab ON ab.id = a.breed_id
                WHERE a.farm_id = farm.id AND getSpeciesGroup(ab.species) = c.grp
                AND a.name IS NULL AND ab.species NOT IN FUSION_EXCLUDED_SPECIES
            IF current_individual > max_individual:
                violations.append({
                    species_group: c.grp, total: c.total,
                    max_fiches: max_individual, current_fiches: current_individual,
                    must_fuse: current_individual - max_individual
                })

    RETURN violations

function fuseAnimals(player_id, animal_ids):
    ASSERT LENGTH(animal_ids) >= 2                                   → 400
    farm = getPrimaryFarm(player_id)

    animals = SELECT * FROM animal WHERE id = ANY(animal_ids) AND farm_id = farm.id
    ASSERT LENGTH(animals) == LENGTH(animal_ids)                     → 404

    -- Vérifier même race et sexe
    breed_id = animals[0].breed_id
    sex = animals[0].sex
    FOR EACH a IN animals:
        ASSERT a.breed_id == breed_id AND a.sex == sex               → 400 "Même race/sexe requis"
        ASSERT a.name IS NULL                                        → 409 "Animal nommé non fusionnable"
        breed = getBreed(a.breed_id)
        ASSERT breed.species NOT IN FUSION_EXCLUDED_SPECIES          → 409 "Espèce exclue"

    avg_age = AVG(a.age_days FOR a IN animals)
    avg_gen = AVG(a.genetics FOR a IN animals)

    group = INSERT INTO animal_group (farm_id, breed_id, count, avg_age_days, avg_genetics, sex)
            VALUES (farm.id, breed_id, LENGTH(animals), avg_age, avg_gen, sex)
            RETURNING *

    DELETE FROM animal WHERE id = ANY(animal_ids)
    RETURN group
```

### 9.4 API Endpoints

#### GET `/api/fusion/check`

```
Response 200:
{
  "violations": [
    { "species_group": "poultry", "total": 6000, "max_fiches": 133, "current_fiches": 500, "must_fuse": 367 }
  ]
}
```

#### POST `/api/fusion/fuse`

```
Request: { "animal_ids": [1,2,3,...,50] }
Response 200: { "group_id": 1, "count": 50, "avg_age_days": 180, "avg_genetics": 45.5 }
Erreurs: 400 (<2 animaux, race/sexe différents), 409 (nommé, espèce exclue)
```

#### GET `/api/animal-groups`

```
Response 200:
{ "groups": [ { "id": 1, "breed": "Poulet", "count": 500, "avg_age_days": 90, "sex": "female" } ] }
```

### 9.5 Tests

**Tests unitaires :**
- 6000 volailles → seuil 5000, ratio 45 → max 133 fiches
- 5000 volailles → seuil atteint, fusion requise
- 4999 volailles → pas de fusion requise
- 20000 bovins → seuil 20000, ratio 20 → max 1000 fiches
- Fusion 50 poulets même race/sexe → 1 groupe de 50
- Fusion animaux races différentes → 400
- Fusion animal nommé → 409
- Fusion bison → 409
- Fusion daim → 409

**Tests d'intégration :**
- Acheter 5001 volailles → GET /fusion/check → violation → fusionner → check OK

---

## Feature 10 — Assurance matériel

### 10.1 Description

L'assurance matériel est une souscription annuelle par matériel qui couvre les frais de réparation en cas de panne. Le prix de la prime varie selon la valeur du matériel. L'assurance est optionnelle et se renouvelle manuellement chaque année.

**Règles métier :**
- Souscription : par matériel, durée 1 an (12 mois Cultivia)
- Prime annuelle = 3% de la valeur argus du matériel au moment de la souscription
- Couverture : 100% des frais de réparation (coût pièces + main d'œuvre)
- Pas de couverture HT (le joueur dépense toujours les HT de réparation)
- Renouvellement : manuel, pas de tacite reconduction
- Résiliation anticipée : pas de remboursement
- 1 seule assurance active par matériel

### 10.2 Schéma BDD

```sql
CREATE TABLE vehicle_insurance (
  id              SERIAL PRIMARY KEY,
  vehicle_id      INT NOT NULL REFERENCES vehicle(id) ON DELETE CASCADE,
  premium         DECIMAL(10,2) NOT NULL,
  argus_at_sub    DECIMAL(12,2) NOT NULL,  -- argus au moment de la souscription
  starts_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at      TIMESTAMPTZ NOT NULL,    -- starts_at + 12 mois
  status          VARCHAR(15) NOT NULL DEFAULT 'active',
  -- 'active', 'expired'
  UNIQUE(vehicle_id, status)  -- 1 active par matériel
);
CREATE INDEX idx_insurance_vehicle ON vehicle_insurance(vehicle_id) WHERE status = 'active';
```

### 10.3 Logique métier

```
INSURANCE_RATE = 0.03  -- 3% de l'argus

function subscribeInsurance(player_id, vehicle_id):
    vehicle = getVehicle(vehicle_id)
    ASSERT vehicle.farm.player_id == player_id                       → 403

    -- Vérifier pas d'assurance active
    existing = SELECT * FROM vehicle_insurance
               WHERE vehicle_id = vehicle_id AND status = 'active'
    ASSERT existing IS NULL                                          → 409 "Assurance déjà active"

    argus = calculateArgus(vehicle)
    premium = argus * INSURANCE_RATE

    debit(player_id, premium, 'insurance',
          'Assurance matériel ' + vehicle.type.name, 'vehicle', vehicle_id)

    INSERT INTO vehicle_insurance (vehicle_id, premium, argus_at_sub, expires_at)
    VALUES (vehicle_id, premium, argus, now() + INTERVAL '12 months')

    RETURN { premium, argus, expires_at: now() + INTERVAL '12 months' }

-- Modification de repairVehicle() existante (PHASE1 Feature 5) :
-- Après calcul repair_cost :
--   insurance = SELECT * FROM vehicle_insurance
--               WHERE vehicle_id = vehicle_id AND status = 'active'
--               AND expires_at > now()
--   IF insurance EXISTS:
--       repair_cost = 0  -- couvert par l'assurance
--       -- Le joueur paie toujours les HT

-- Tick mensuel : expirer les assurances
function monthlyInsuranceExpiry(server_id):
    UPDATE vehicle_insurance SET status = 'expired'
    WHERE status = 'active' AND expires_at <= now()
```

### 10.4 API Endpoints

#### POST `/api/vehicles/:id/insure`

```
Response 201: { "premium": 893.25, "argus": 29775.00, "expires_at": "2027-04-04T22:00:00Z" }
Erreurs: 403, 409 (assurance déjà active)
```

#### GET `/api/vehicles/:id/insurance`

```
Response 200:
{ "active": true, "premium": 893.25, "expires_at": "2027-04-04T22:00:00Z" }
-- ou
{ "active": false }
```

### 10.5 Tests

**Tests unitaires :**
- Assurance tracteur argus 29775€ → prime = 29775 × 0.03 = 893.25€
- Double souscription → 409
- Réparation avec assurance → coût = 0€ (PA toujours dépensés)
- Réparation sans assurance → coût = 5% prix neuf
- Assurance expirée → réparation payante
- Pas de remboursement à la résiliation

**Tests d'intégration :**
- Souscrire assurance → panne → réparer → vérifier coût = 0 → attendre expiration → panne → réparer → coût normal

---

## Feature 11 — Combinés de travail

### 11.1 Description

Les combinés permettent de réaliser plusieurs opérations en un seul passage, économisant des HT et du HVC. Le joueur attelle un outil à l'avant et un à l'arrière du tracteur. La puissance requise est la somme des deux outils. Le bonus HT est significatif.

**Règles métier :**

| Combiné | Avant | Arrière | Puissance min | Bonus HT |
|---------|-------|---------|---------------|----------|
| Semis traditionnel | Herse rotative | Semoir classique | 120 CV | -30% HT |
| Semis TCS | Déchaumeur | Semoir classique | 150 CV | -30% HT |
| Semis M/B | — | Semoir M/B | 100 CV | -20% HT |
| Traiter | — | Pulvérisateur | 80 CV | -10% HT |
| Faucher | Faucheuse avant | Faucheuse arrière | 120 CV | -40% HT |
| Labourer | — | Charrue | 100 CV | 0% (standard) |
| Déchaumer/semer | Déchaumeur | Semoir direct | 180 CV | -35% HT |
| Rouler/semer | Rouleau | Semoir classique | 120 CV | -25% HT |
| Herse/cultivateur | Herse | Cultivateur | 150 CV | -30% HT |

- Le tracteur doit avoir la puissance minimale requise
- Les deux outils doivent être possédés et en état
- Le relevage avant du tracteur est requis pour les combinés avec outil avant
- Un seul combiné par passage

### 11.2 Schéma BDD

```sql
CREATE TABLE work_combo (
  id              SERIAL PRIMARY KEY,
  name            VARCHAR(50) NOT NULL UNIQUE,
  slug            VARCHAR(30) NOT NULL UNIQUE,
  front_family    VARCHAR(20),           -- NULL si pas d'outil avant
  front_slug_match VARCHAR(50),          -- pattern pour matcher le type
  rear_family     VARCHAR(20) NOT NULL,
  rear_slug_match VARCHAR(50) NOT NULL,
  min_tractor_cv  SMALLINT NOT NULL,
  pa_bonus_pct    DECIMAL(4,2) NOT NULL, -- ex: -0.30 = -30%
  requires_front_lift BOOLEAN NOT NULL DEFAULT false
);

INSERT INTO work_combo (name, slug, front_family, front_slug_match, rear_family, rear_slug_match, min_tractor_cv, pa_bonus_pct, requires_front_lift) VALUES
('Semis traditionnel',  'semis_trad',     'soil',    'herse_rotative',  'sowing',    'semoir_classique', 120, -0.30, true),
('Semis TCS',           'semis_tcs',      'soil',    'dechaumeur',      'sowing',    'semoir_classique', 150, -0.30, true),
('Semis M/B',           'semis_mb',       NULL,      NULL,              'sowing',    'semoir_mb',        100, -0.20, false),
('Traiter',             'traiter',        NULL,      NULL,              'treatment', 'pulverisateur',     80, -0.10, false),
('Faucher',             'faucher',        'cutting', 'faucheuse',       'cutting',   'faucheuse',        120, -0.40, true),
('Labourer',            'labourer',       NULL,      NULL,              'soil',      'charrue',          100,  0.00, false),
('Déchaumer/semer',     'dechaume_seme',  'soil',    'dechaumeur',      'sowing',    'semoir_direct',    180, -0.35, true),
('Rouler/semer',        'rouler_semer',   'soil',    'rouleau',         'sowing',    'semoir_classique', 120, -0.25, true),
('Herse/cultivateur',   'herse_cultiv',   'soil',    'herse',           'soil',      'cultivateur',      150, -0.30, true);
```

### 11.3 Logique métier

```
function executeCombo(player_id, parcel_id, combo_slug):
    combo = SELECT * FROM work_combo WHERE slug = combo_slug
    ASSERT combo EXISTS                                              → 404
    parcel = getParcel(parcel_id)
    ASSERT parcel.farm.player_id == player_id                        → 403

    -- Trouver tracteur avec puissance suffisante
    tractor = findVehicle(player_id, 'motor', min_cv=combo.min_tractor_cv)
    ASSERT tractor EXISTS AND NOT tractor.is_broken                  → 409 "Tracteur " + combo.min_tractor_cv + " CV min requis"

    -- Vérifier relevage avant si nécessaire
    IF combo.requires_front_lift:
        ASSERT tractor.has_front_lift                                → 409 "Relevage avant requis"

    -- Trouver outil arrière
    rear_tool = findVehicle(player_id, combo.rear_family, slug_contains=combo.rear_slug_match)
    ASSERT rear_tool EXISTS AND NOT rear_tool.is_broken              → 409 "Outil arrière manquant"

    -- Trouver outil avant (si requis)
    IF combo.front_family IS NOT NULL:
        front_tool = findVehicle(player_id, combo.front_family, slug_contains=combo.front_slug_match)
        ASSERT front_tool EXISTS AND NOT front_tool.is_broken        → 409 "Outil avant manquant"

    ha = parcel.area_m2 / 10000

    -- Calculer HT de base (somme des opérations individuelles)
    -- Exemple semis trad : hersage (0.4/ha) + semis (0.4/ha) = 0.8/ha
    base_pa = getBasePA(combo.slug, ha)  -- lookup table par combiné

    -- Appliquer bonus
    final_pa = base_pa * (1.0 + combo.pa_bonus_pct)

    move_cost = calculateMoveCost(farm.prefecture_id, parcel.prefecture_id)
    ASSERT canPerformAction(player_id, move_cost + final_pa)         → 403
    IF move_cost > 0:
        spendPA(player_id, move_cost, 'move', { to_prefecture_id: parcel.prefecture_id })
    spendPA(player_id, final_pa, 'combo_' + combo.slug, { parcel_id })
    consumeHVC(player_id, tractor, final_pa)

    -- Exécuter les effets des opérations combinées
    executeComboEffects(combo.slug, player_id, parcel_id)

    RETURN { combo: combo.name, pa_spent: final_pa, pa_saved: base_pa - final_pa }

BASE_PA_PER_HA = {
  'semis_trad':    0.80,  -- herse 0.4 + semis 0.4
  'semis_tcs':     0.80,  -- déchaumage 0.4 + semis 0.4
  'semis_mb':      0.40,  -- semis M/B seul
  'traiter':       0.25,  -- traitement
  'faucher':       0.60,  -- fauche avant + arrière
  'labourer':      0.50,  -- labour
  'dechaume_seme': 0.80,  -- déchaumage 0.4 + semis 0.4
  'rouler_semer':  0.70,  -- rouleau 0.3 + semis 0.4
  'herse_cultiv':  0.80   -- herse 0.4 + cultivateur 0.4
}

function getBasePA(combo_slug, ha) -> float:
    RETURN BASE_PA_PER_HA[combo_slug] * ha
```

### 11.4 API Endpoints

#### POST `/api/parcels/:id/combo`

```
Request: { "combo": "semis_trad" }
Response 200:
{
  "combo": "Semis traditionnel",
  "pa_spent": 5.6,
  "pa_saved": 2.4,
  "bonus_pct": -30
}
Erreurs: 403, 404, 409 (matériel manquant, puissance insuffisante)
```

#### GET `/api/combos`

```
Response 200:
{
  "combos": [
    { "slug": "semis_trad", "name": "Semis traditionnel", "min_cv": 120, "bonus": "-30%",
      "front": "Herse rotative", "rear": "Semoir classique" },
    ...
  ]
}
```

### 11.5 Tests

**Tests unitaires :**
- Semis trad 10 ha : base = 8 HT, bonus -30% → 5.6 HT (économie 2.4 HT)
- Faucher 10 ha : base = 6 HT, bonus -40% → 3.6 HT
- Labourer 10 ha : base = 5 HT, bonus 0% → 5 HT (pas d'économie)
- Tracteur 100 CV + combo min 120 CV → 409
- Tracteur 150 CV + combo min 120 CV → OK
- Combo avec outil avant sans relevage avant → 409
- Outil arrière en panne → 409
- Outil avant manquant pour combo qui le requiert → 409

**Tests d'intégration :**
- Combo semis trad → vérifier que la parcelle est semée + HT réduits vs opérations séparées
- Combo faucher → vérifier que le foin est produit

---

## Feature 12 — Achat matériel en commun

### 12.1 Description

L'achat en commun permet à 2-5 joueurs amis de la même région de partager l'achat et l'utilisation d'un matériel coûteux. Chaque joueur investit librement. Le temps d'utilisation est proportionnel à l'investissement. La revente nécessite l'accord de tous et le produit est redistribué proportionnellement.

**Règles métier :**
- 2 à 5 joueurs, tous amis entre eux
- Tous dans la même région
- Investissement libre (chaque joueur met ce qu'il veut, total = prix du matériel)
- Temps d'utilisation : proportionnel à la part investie (ex: 40% investi = 40% du temps)
- Planning : rotation automatique par jour Cultivia, proportionnel aux parts
- Entretien et frais HVC : à la charge de l'utilisateur du jour
- Vente : vote unanime requis, produit redistribué au prorata des parts
- Le matériel est stocké chez le joueur majoritaire (ou le premier acheteur en cas d'égalité)

### 12.2 Schéma BDD

```sql
CREATE TABLE shared_vehicle (
  id              SERIAL PRIMARY KEY,
  vehicle_id      INT NOT NULL REFERENCES vehicle(id) ON DELETE CASCADE UNIQUE,
  total_price     DECIMAL(12,2) NOT NULL,
  region_id       INT NOT NULL REFERENCES region(id),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  status          VARCHAR(15) NOT NULL DEFAULT 'active'  -- 'active','pending_sale','sold'
);

CREATE TABLE shared_vehicle_member (
  id                SERIAL PRIMARY KEY,
  shared_vehicle_id INT NOT NULL REFERENCES shared_vehicle(id) ON DELETE CASCADE,
  player_id         INT NOT NULL REFERENCES player(id),
  investment        DECIMAL(12,2) NOT NULL CHECK (investment > 0),
  share_pct         DECIMAL(5,2) NOT NULL,  -- % de la part
  vote_sell         BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(shared_vehicle_id, player_id)
);
CREATE INDEX idx_shared_member ON shared_vehicle_member(player_id);

CREATE TABLE shared_vehicle_schedule (
  id                SERIAL PRIMARY KEY,
  shared_vehicle_id INT NOT NULL REFERENCES shared_vehicle(id) ON DELETE CASCADE,
  player_id         INT NOT NULL REFERENCES player(id),
  game_day          INT NOT NULL,
  game_year         INT NOT NULL,
  UNIQUE(shared_vehicle_id, game_day, game_year)
);
```

### 12.3 Logique métier

```
SHARED_MIN_MEMBERS = 2
SHARED_MAX_MEMBERS = 5

function proposeSharedPurchase(player_id, vehicle_type_id, invitations):
    -- invitations = [{ player_id, investment }]
    vtype = getVehicleType(vehicle_type_id)
    player = getPlayer(player_id)
    farm = getPrimaryFarm(player_id)
    region_id = getRegionForZone(farm.prefecture_id)

    all_members = [{ player_id, investment: invitations.self_investment }] + invitations.others
    ASSERT LENGTH(all_members) >= SHARED_MIN_MEMBERS
           AND LENGTH(all_members) <= SHARED_MAX_MEMBERS             → 400

    total_investment = SUM(m.investment FOR m IN all_members)
    ASSERT total_investment == vtype.base_price                      → 400 "Total ≠ prix matériel"

    -- Vérifier amitié et même région
    FOR EACH m IN all_members:
        IF m.player_id != player_id:
            ASSERT areFriends(player_id, m.player_id)                → 400 "Pas amis"
            m_farm = getPrimaryFarm(m.player_id)
            ASSERT getRegionForZone(m_farm.prefecture_id) == region_id     → 400 "Région différente"

    -- Créer la proposition (les autres doivent accepter)
    -- ... (système de notification/acceptation)
    RETURN { proposal_id, members: all_members, vehicle_type: vtype.name }

function confirmSharedPurchase(proposal_id):
    -- Tous les membres ont accepté
    proposal = getProposal(proposal_id)

    -- Débiter chaque membre
    FOR EACH m IN proposal.members:
        debit(m.player_id, m.investment, 'shared_vehicle_buy',
              'Achat commun ' + proposal.vehicle_type.name, NULL, NULL)

    -- Créer le véhicule (chez le membre majoritaire)
    majority = MAX(m.investment FOR m IN proposal.members)
    host_farm = getPrimaryFarm(majority.player_id)

    vehicle = createVehicle(host_farm.id, proposal.vehicle_type_id, proposal.total_price)

    shared = INSERT INTO shared_vehicle (vehicle_id, total_price, region_id)
             VALUES (vehicle.id, proposal.total_price, proposal.region_id)

    FOR EACH m IN proposal.members:
        share_pct = (m.investment / proposal.total_price) * 100
        INSERT INTO shared_vehicle_member (shared_vehicle_id, player_id, investment, share_pct)
        VALUES (shared.id, m.player_id, m.investment, share_pct)

    -- Générer le planning
    generateSchedule(shared.id)
    RETURN shared

function generateSchedule(shared_vehicle_id):
    members = SELECT * FROM shared_vehicle_member WHERE shared_vehicle_id = shared_vehicle_id
    server = getServerForSharedVehicle(shared_vehicle_id)

    -- Répartir les 7 jours de la semaine proportionnellement
    -- Ex: 60% = 4.2 jours/semaine, 40% = 2.8 jours/semaine
    -- Arrondi par rotation sur les semaines
    days_in_year = 365
    FOR day IN 1..days_in_year:
        -- Attribution round-robin pondérée
        assigned = getWeightedAssignment(members, day)
        INSERT INTO shared_vehicle_schedule (shared_vehicle_id, player_id, game_day, game_year)
        VALUES (shared_vehicle_id, assigned.player_id, day, server.current_year)

function voteToSell(player_id, shared_vehicle_id):
    member = SELECT * FROM shared_vehicle_member
             WHERE shared_vehicle_id = shared_vehicle_id AND player_id = player_id
    ASSERT member EXISTS                                             → 403

    UPDATE shared_vehicle_member SET vote_sell = true
           WHERE id = member.id

    -- Vérifier unanimité
    all_voted = SELECT COUNT(*) = COUNT(CASE WHEN vote_sell THEN 1 END)
                FROM shared_vehicle_member WHERE shared_vehicle_id = shared_vehicle_id

    IF all_voted:
        shared = SELECT * FROM shared_vehicle WHERE id = shared_vehicle_id
        vehicle = getVehicle(shared.vehicle_id)
        argus = calculateArgus(vehicle)
        sell_price = argus * 0.60

        -- Redistribuer
        members = SELECT * FROM shared_vehicle_member WHERE shared_vehicle_id = shared_vehicle_id
        FOR EACH m IN members:
            payout = sell_price * (m.share_pct / 100.0)
            credit(m.player_id, payout, 'shared_vehicle_sell',
                   'Vente matériel commun', 'vehicle', shared.vehicle_id)

        DELETE FROM vehicle WHERE id = shared.vehicle_id
        UPDATE shared_vehicle SET status = 'sold' WHERE id = shared_vehicle_id

    RETURN { vote_registered: true, all_voted, sell_price: IF all_voted THEN sell_price ELSE NULL }
```

### 12.4 API Endpoints

#### POST `/api/shared-vehicles/propose`

```
Request: {
  "vehicle_type_id": 10,
  "self_investment": 100000,
  "invitations": [
    { "player_id": 2, "investment": 80000 },
    { "player_id": 3, "investment": 100000 }
  ]
}
Response 201: { "proposal_id": 1, "total": 280000, "vehicle": "Moissonneuse 450 CV" }
Erreurs: 400 (total ≠ prix, pas amis, région différente, nb membres)
```

#### POST `/api/shared-vehicles/:id/vote-sell`

```
Response 200: { "vote_registered": true, "all_voted": false }
```

#### GET `/api/shared-vehicles`

```
Response 200:
{
  "shared": [
    { "id": 1, "vehicle": "Moissonneuse 450 CV", "my_share_pct": 35.7,
      "today_user": "Joueur2", "members": [...] }
  ]
}
```

#### GET `/api/shared-vehicles/:id/schedule`

```
Response 200: { "schedule": [ { "day": 1, "player": "Joueur1" }, ... ] }
```

### 12.5 Tests

**Tests unitaires :**
- 2 joueurs, 50/50 → chaque joueur a 50% du temps
- 3 joueurs, 100k/80k/100k sur 280k → parts 35.7%/28.6%/35.7%
- Total investissement ≠ prix → 400
- 1 joueur seul → 400
- 6 joueurs → 400
- Joueurs pas amis → 400
- Joueurs régions différentes → 400
- Vote vente : 2/3 votent → pas de vente
- Vote vente : 3/3 votent → vente, redistribution proportionnelle
- Vente 60% argus, redistribué au prorata

**Tests d'intégration :**
- Proposer → accepter → vérifier planning → utiliser le jour assigné → voter vente → redistribution

---

## Feature 13 — Magasin libre-service CAR

### 13.1 Description

Le magasin libre-service est un bâtiment de la CAR (Coopérative Agricole Régionale). Il propose 3 espaces choisis parmi 5 catégories. Un employé (1 600 €/mois) est requis. Le responsable fixe les prix de vente (jamais à perte) et peut faire des promotions. L'approvisionnement se fait via des commandes fournisseurs avec transport.

**Règles métier :**
- Bâtiment CAR : magasin libre-service (300 m², 30 000€)
- 3 espaces choisis parmi : Agriculture, Arboriculture, Forêt, Maraîchage, Élevage
- Employé obligatoire : salaire 1 600 €/mois
- Produits par espace : semences, engrais, outils, aliments selon la catégorie
- Prix de vente : fixé par le responsable CAR, minimum = prix d'achat fournisseur
- Promotions : réduction temporaire (max -20%)
- Approvisionnement : commande fournisseur → livraison (délai 1-3 jours) → stock magasin
- Vente aux joueurs de la région

### 13.2 Schéma BDD

```sql
CREATE TABLE car_shop (
  id          SERIAL PRIMARY KEY,
  car_id      INT NOT NULL REFERENCES car(id) ON DELETE CASCADE UNIQUE,
  building_id INT NOT NULL REFERENCES building(id),
  space_1     VARCHAR(20) NOT NULL,
  space_2     VARCHAR(20) NOT NULL,
  space_3     VARCHAR(20) NOT NULL,
  employee_salary DECIMAL(10,2) NOT NULL DEFAULT 1750.00,
  opened_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (space_1 IN ('agriculture','arboriculture','forest','market_garden','livestock')),
  CHECK (space_2 IN ('agriculture','arboriculture','forest','market_garden','livestock')),
  CHECK (space_3 IN ('agriculture','arboriculture','forest','market_garden','livestock')),
  CHECK (space_1 != space_2 AND space_1 != space_3 AND space_2 != space_3)
);

CREATE TABLE car_shop_product (
  id              SERIAL PRIMARY KEY,
  car_shop_id     INT NOT NULL REFERENCES car_shop(id) ON DELETE CASCADE,
  product_slug    VARCHAR(50) NOT NULL,
  product_name    VARCHAR(100) NOT NULL,
  space           VARCHAR(20) NOT NULL,
  supplier_price  DECIMAL(10,2) NOT NULL,  -- prix fournisseur
  sell_price      DECIMAL(10,2) NOT NULL,  -- prix vente (>= supplier_price)
  stock_qty       DECIMAL(12,2) NOT NULL DEFAULT 0,
  unit            VARCHAR(10) NOT NULL DEFAULT 'kg',
  promo_pct       DECIMAL(4,2) DEFAULT 0,  -- 0 à -0.20
  CHECK (sell_price >= supplier_price),
  CHECK (promo_pct BETWEEN -0.20 AND 0),
  UNIQUE(car_shop_id, product_slug)
);
CREATE INDEX idx_shop_product ON car_shop_product(car_shop_id, space);

CREATE TABLE car_shop_order (
  id              SERIAL PRIMARY KEY,
  car_shop_id     INT NOT NULL REFERENCES car_shop(id),
  product_slug    VARCHAR(50) NOT NULL,
  quantity        DECIMAL(12,2) NOT NULL,
  total_cost      DECIMAL(12,2) NOT NULL,
  ordered_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  delivery_at     TIMESTAMPTZ NOT NULL,  -- ordered_at + 1-3 jours
  delivered       BOOLEAN NOT NULL DEFAULT false
);
```

### 13.3 Logique métier

```
SHOP_BUILDING_COST = 30000.00
SHOP_BUILDING_SIZE = 300  -- m²
SHOP_EMPLOYEE_SALARY = 1750.00
SHOP_SPACES = ['agriculture','arboriculture','forest','market_garden','livestock']
SHOP_MAX_PROMO = -0.20
SHOP_DELIVERY_DAYS_MIN = 1
SHOP_DELIVERY_DAYS_MAX = 3

function openShop(car_id, spaces):
    car = getCAR(car_id)
    ASSERT LENGTH(spaces) == 3                                       → 400
    ASSERT ALL spaces IN SHOP_SPACES                                 → 400
    ASSERT ALL DISTINCT(spaces)                                      → 400 "Espaces uniques"

    -- Construire le bâtiment
    building = buildBuilding(car.manager_player_id, 'magasin_ls', SHOP_BUILDING_SIZE)

    INSERT INTO car_shop (car_id, building_id, space_1, space_2, space_3)
    VALUES (car_id, building.id, spaces[0], spaces[1], spaces[2])

    -- Initialiser les produits par espace
    FOR EACH space IN spaces:
        products = getProductsForSpace(space)
        FOR EACH p IN products:
            INSERT INTO car_shop_product (car_shop_id, product_slug, product_name,
                                          space, supplier_price, sell_price, unit)
            VALUES (shop.id, p.slug, p.name, space, p.supplier_price, p.supplier_price * 1.15, p.unit)

    RETURN shop

function setPrice(car_id, player_id, product_id, new_price):
    shop = SELECT * FROM car_shop WHERE car_id = car_id
    ASSERT isCarManager(car_id, player_id)                           → 403
    product = SELECT * FROM car_shop_product WHERE id = product_id AND car_shop_id = shop.id
    ASSERT product EXISTS                                            → 404
    ASSERT new_price >= product.supplier_price                       → 400 "Prix < coût fournisseur"

    UPDATE car_shop_product SET sell_price = new_price WHERE id = product_id
    RETURN { product_slug: product.product_slug, new_price }

function setPromo(car_id, player_id, product_id, promo_pct):
    ASSERT promo_pct >= SHOP_MAX_PROMO AND promo_pct <= 0            → 400
    product = SELECT * FROM car_shop_product WHERE id = product_id
    final_price = product.sell_price * (1 + promo_pct)
    ASSERT final_price >= product.supplier_price                     → 400 "Promo met à perte"

    UPDATE car_shop_product SET promo_pct = promo_pct WHERE id = product_id

function orderStock(car_id, player_id, product_id, quantity):
    shop = SELECT * FROM car_shop WHERE car_id = car_id
    ASSERT isCarManager(car_id, player_id)                           → 403
    product = SELECT * FROM car_shop_product WHERE id = product_id

    total_cost = product.supplier_price * quantity
    debitCAR(car_id, total_cost, 'shop_order', 'Commande ' + product.product_name)

    delivery_days = randomInt(SHOP_DELIVERY_DAYS_MIN, SHOP_DELIVERY_DAYS_MAX)

    INSERT INTO car_shop_order (car_shop_id, product_slug, quantity, total_cost, delivery_at)
    VALUES (shop.id, product.product_slug, quantity, total_cost, now() + delivery_days * INTERVAL '1 day')

function buyFromShop(player_id, car_shop_id, product_id, quantity):
    product = SELECT * FROM car_shop_product WHERE id = product_id AND car_shop_id = car_shop_id
    ASSERT product EXISTS AND product.stock_qty >= quantity           → 409 "Stock insuffisant"

    price = product.sell_price * (1 + product.promo_pct) * quantity
    debit(player_id, price, 'shop_buy', product.product_name, NULL, NULL)
    spendPA(player_id, 0.5, 'shop_buy', { product: product.product_slug })

    UPDATE car_shop_product SET stock_qty = stock_qty - quantity WHERE id = product_id
    creditCAR(car_shop.car_id, price, 'shop_sale', product.product_name)

    RETURN { product: product.product_name, quantity, price }

-- Tick quotidien : livraisons + salaire mensuel
function dailyShopTick(server_id):
    -- Livraisons
    orders = SELECT * FROM car_shop_order WHERE NOT delivered AND delivery_at <= now()
    FOR EACH o IN orders:
        UPDATE car_shop_product SET stock_qty = stock_qty + o.quantity
               WHERE car_shop_id = o.car_shop_id AND product_slug = o.product_slug
        UPDATE car_shop_order SET delivered = true WHERE id = o.id

    -- Salaire mensuel (1er du mois)
    IF is_first_of_month:
        shops = SELECT cs.*, c.id AS car_id FROM car_shop cs JOIN car c ON c.id = cs.car_id
        FOR EACH s IN shops:
            debitCAR(s.car_id, SHOP_EMPLOYEE_SALARY, 'shop_salary', 'Salaire employé magasin')
```

### 13.4 API Endpoints

#### POST `/api/car/:car_id/shop`

```
Request: { "spaces": ["agriculture", "livestock", "forest"] }
Response 201: { "id": 1, "spaces": [...], "building_cost": 30000 }
```

#### PUT `/api/car/:car_id/shop/products/:id/price`

```
Request: { "sell_price": 0.55 }
Response 200: { "product": "Engrais NPK", "new_price": 0.55 }
```

#### PUT `/api/car/:car_id/shop/products/:id/promo`

```
Request: { "promo_pct": -0.10 }
Response 200: { "promo_pct": -0.10, "final_price": 0.495 }
```

#### POST `/api/car/:car_id/shop/orders`

```
Request: { "product_id": 5, "quantity": 5000 }
Response 201: { "order_id": 1, "total_cost": 2250.00, "delivery_at": "2026-04-06" }
```

#### POST `/api/car/:car_id/shop/buy`

```
Request: { "product_id": 5, "quantity": 300 }
Response 200: { "product": "Engrais NPK", "quantity": 300, "price": 148.50 }
```

#### GET `/api/car/:car_id/shop`

```
Response 200:
{
  "spaces": ["agriculture","livestock","forest"],
  "products": [ { "slug": "npk", "name": "Engrais NPK", "sell_price": 0.55, "stock": 4700, "promo": -0.10 } ]
}
```

### 13.5 Tests

**Tests unitaires :**
- Ouverture avec 3 espaces distincts → OK
- Ouverture avec 2 espaces identiques → 400
- Ouverture avec 4 espaces → 400
- Prix vente < prix fournisseur → 400
- Promo -25% → 400 (max -20%)
- Promo qui met à perte → 400
- Commande 5000 kg → livraison 1-3 jours
- Achat joueur : stock diminue, CAR créditée
- Salaire mensuel 1600€ débité de la CAR

**Tests d'intégration :**
- Ouvrir magasin → commander stock → attendre livraison → joueur achète → vérifier flux financier CAR

---

## Feature 14 — Organisme Partcel

### 14.1 Description

L'organisme Partcel est un PNJ qui propose l'achat ou la location de parcelles. Les prix sont majorés de 50% par rapport à Cultivia. Les parcelles BIO sont disponibles uniquement via Partcel ou entre joueurs. La location est possible avec option de rachat dès la 2e année.

**Règles métier :**
- Prix achat Partcel = `server.price_per_ha × 1.50`
- Parcelles BIO disponibles (déjà certifiées, pas de conversion nécessaire)
- Prix BIO = prix Partcel × 1.50 (soit 2.25× le prix Cultivia)
- Location : loyer mensuel = prix achat / 60 (amortissement 5 ans)
- Rachat possible dès la 2e année de location : prix = prix achat - loyers déjà versés
- Résiliation location : à tout moment, pas de pénalité, parcelle rendue
- Parcelle louée : le joueur peut cultiver normalement mais ne peut pas revendre
- Qualité sol : même mécanique que Cultivia (aléatoire pondéré)

### 14.2 Schéma BDD

```sql
CREATE TABLE partcel_lease (
  id              SERIAL PRIMARY KEY,
  parcel_id       INT NOT NULL REFERENCES parcel(id) ON DELETE CASCADE UNIQUE,
  player_id       INT NOT NULL REFERENCES player(id),
  monthly_rent    DECIMAL(10,2) NOT NULL,
  purchase_price  DECIMAL(12,2) NOT NULL,  -- prix de rachat initial
  total_rent_paid DECIMAL(12,2) NOT NULL DEFAULT 0,
  is_bio          BOOLEAN NOT NULL DEFAULT false,
  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  buyout_available_at TIMESTAMPTZ NOT NULL,  -- started_at + 2 ans
  status          VARCHAR(15) NOT NULL DEFAULT 'active',
  -- 'active', 'bought_out', 'terminated'
  ended_at        TIMESTAMPTZ
);
CREATE INDEX idx_partcel_player ON partcel_lease(player_id) WHERE status = 'active';
```

### 14.3 Logique métier

```
PARTCEL_PRICE_FACTOR = 1.50
PARTCEL_BIO_FACTOR = 1.50   -- en plus du facteur Partcel
PARTCEL_LEASE_MONTHS = 60   -- amortissement 5 ans
PARTCEL_BUYOUT_YEARS = 2    -- rachat possible après 2 ans

function buyFromPartcel(player_id, prefecture_id, type, area_m2, is_bio):
    server = getServerForPlayer(player_id)
    quality = weightedRandom({ 1: 0.25, 2: 0.50, 3: 0.25 })
    ha = area_m2 / 10000

    base_price = server.price_per_ha * ha * QUALITY_PRICE_FACTOR[quality]
    partcel_price = base_price * PARTCEL_PRICE_FACTOR
    IF is_bio:
        partcel_price = partcel_price * PARTCEL_BIO_FACTOR

    debit(player_id, partcel_price, 'partcel_buy',
          'Achat Partcel ' + ha + ' ha' + (IF is_bio THEN ' BIO' ELSE ''),
          'parcel', NULL)
    spendPA(player_id, 1.0, 'partcel_buy', { prefecture_id, area_m2 })

    parcel = createParcel(player_id, prefecture_id, type, area_m2, quality, partcel_price)

    IF is_bio:
        -- Marquer la parcelle comme BIO (pas de conversion nécessaire)
        UPDATE parcel SET is_bio = true, bio_certified_at = now() WHERE id = parcel.id

    RETURN parcel

function leaseFromPartcel(player_id, prefecture_id, type, area_m2, is_bio):
    server = getServerForPlayer(player_id)
    quality = weightedRandom({ 1: 0.25, 2: 0.50, 3: 0.25 })
    ha = area_m2 / 10000

    base_price = server.price_per_ha * ha * QUALITY_PRICE_FACTOR[quality]
    purchase_price = base_price * PARTCEL_PRICE_FACTOR
    IF is_bio:
        purchase_price = purchase_price * PARTCEL_BIO_FACTOR

    monthly_rent = purchase_price / PARTCEL_LEASE_MONTHS

    -- Créer la parcelle (propriété Partcel, usage joueur)
    parcel = createParcel(player_id, prefecture_id, type, area_m2, quality, 0)

    IF is_bio:
        UPDATE parcel SET is_bio = true, bio_certified_at = now() WHERE id = parcel.id

    INSERT INTO partcel_lease (parcel_id, player_id, monthly_rent, purchase_price,
                               is_bio, buyout_available_at)
    VALUES (parcel.id, player_id, monthly_rent, purchase_price,
            is_bio, now() + INTERVAL '2 years')

    -- Premier loyer
    debit(player_id, monthly_rent, 'partcel_rent', 'Loyer Partcel', 'parcel', parcel.id)

    RETURN { parcel, monthly_rent, purchase_price, buyout_available_at }

function buyoutLease(player_id, lease_id):
    lease = SELECT * FROM partcel_lease WHERE id = lease_id AND player_id = player_id
    ASSERT lease EXISTS AND lease.status == 'active'                 → 404
    ASSERT now() >= lease.buyout_available_at                        → 409 "Rachat possible après 2 ans"

    buyout_price = lease.purchase_price - lease.total_rent_paid
    ASSERT buyout_price > 0                                          -- sinon déjà amorti

    debit(player_id, buyout_price, 'partcel_buyout',
          'Rachat parcelle Partcel', 'parcel', lease.parcel_id)

    UPDATE partcel_lease SET status = 'bought_out', ended_at = now()
           WHERE id = lease_id
    -- La parcelle devient pleine propriété du joueur
    UPDATE parcel SET bought_price = lease.purchase_price WHERE id = lease.parcel_id

    RETURN { buyout_price, total_paid: lease.total_rent_paid + buyout_price }

function terminateLease(player_id, lease_id):
    lease = SELECT * FROM partcel_lease WHERE id = lease_id AND player_id = player_id
    ASSERT lease EXISTS AND lease.status == 'active'                 → 404
    ASSERT NOT EXISTS active crop on lease.parcel_id                 → 409 "Culture en cours"

    UPDATE partcel_lease SET status = 'terminated', ended_at = now()
           WHERE id = lease_id
    -- Supprimer la parcelle
    DELETE FROM parcel WHERE id = lease.parcel_id
    RETURN { terminated: true, rent_lost: lease.total_rent_paid }

-- Tick mensuel : prélèvement loyer
function monthlyPartcelRent(server_id):
    leases = SELECT * FROM partcel_lease
             WHERE status = 'active'
             AND player_id IN (SELECT id FROM player WHERE server_id = server_id)

    FOR EACH lease IN leases:
        TRY:
            debit(lease.player_id, lease.monthly_rent, 'partcel_rent',
                  'Loyer Partcel mensuel', 'parcel', lease.parcel_id)
            UPDATE partcel_lease SET total_rent_paid = total_rent_paid + lease.monthly_rent
                   WHERE id = lease.id
        CATCH insufficient_funds:
            createNotification(lease.player_id, 'partcel_unpaid', 'critical',
                'Loyer Partcel impayé', 'Risque de résiliation.')
```

### 14.4 API Endpoints

#### POST `/api/partcel/buy`

```
Request: { "prefecture_id": 5, "type": "field", "area_m2": 100000, "is_bio": false }
Response 201:
{
  "parcel": { "id": 1, "area_m2": 100000, "soil_quality": 2 },
  "price": 60000.00,
  "source": "partcel"
}
```

#### POST `/api/partcel/lease`

```
Request: { "prefecture_id": 5, "type": "field", "area_m2": 100000, "is_bio": true }
Response 201:
{
  "parcel": { "id": 2, "area_m2": 100000, "is_bio": true },
  "monthly_rent": 1500.00,
  "purchase_price": 90000.00,
  "buyout_available_at": "2028-04-04"
}
```

#### POST `/api/partcel/leases/:id/buyout`

```
Response 200: { "buyout_price": 54000.00, "total_paid": 90000.00 }
Erreurs: 409 (avant 2 ans)
```

#### POST `/api/partcel/leases/:id/terminate`

```
Response 200: { "terminated": true, "rent_lost": 36000.00 }
Erreurs: 409 (culture en cours)
```

#### GET `/api/partcel/leases`

```
Response 200:
{
  "leases": [
    { "id": 1, "parcel_id": 2, "monthly_rent": 1500, "total_rent_paid": 36000,
      "buyout_price": 54000, "buyout_available": true }
  ]
}
```

### 14.5 Tests

**Tests unitaires :**
- Achat Partcel 10 ha FR (4000€/ha) qualité 2 → 4000 × 10 × 1.0 × 1.50 = 60 000€
- Achat Partcel BIO → 60 000 × 1.50 = 90 000€
- Location 10 ha → loyer = 60 000 / 60 = 1 000€/mois
- Rachat après 2 ans (24 loyers payés = 24 000€) → rachat = 60 000 - 24 000 = 36 000€
- Rachat avant 2 ans → 409
- Résiliation → parcelle supprimée, loyers perdus
- Résiliation avec culture en cours → 409
- Parcelle BIO via Partcel → pas de conversion nécessaire
- Vente parcelle louée → interdit

**Tests d'intégration :**
- Louer parcelle → cultiver → tick mensuel × 24 → racheter → vérifier propriété pleine
- Louer parcelle BIO → semer en BIO → vérifier label BIO actif

---

## Feature 15 — Déménagement & fermes annexes

### 15.1 Description

Le joueur peut déménager son exploitation vers une autre localisation ou acquérir des fermes annexes. Le déménagement est une opération lourde avec des coûts et restrictions. Les fermes annexes permettent d'étendre l'activité dans d'autres zones. Sur serveur Maîtrise, le déménagement entraîne une perte d'argent et les fermes annexes ne permettent pas de transfert d'argent depuis la principale.

**Règles métier — Déménagement :**
- Coût : 10 000€ + 500€ par bâtiment transféré
- HT : 50 HT (opération sur plusieurs jours)
- Conditions : pas de culture en cours, pas d'animaux en transit
- Les parcelles ne sont PAS transférées (doivent être vendues/rachetées)
- Les bâtiments sont reconstruits dans la nouvelle zone (même niveau, même taille)
- Les matériels sont transférés automatiquement
- Le stock (inventaire) est transféré
- Serveur Expert : perte de 20% du solde bancaire au déménagement

**Règles métier — Fermes annexes :**
- Achat : 50 000€ par ferme annexe
- Localisation : dans un canton différente de la ferme principale
- Bâtiments et parcelles propres
- Matériels transférables entre fermes (coût HT déplacement)
- Max 3 fermes annexes
- Serveur Expert : pas de transfert d'argent depuis la ferme principale vers l'annexe

### 15.2 Schéma BDD

```sql
-- La table farm existe déjà (Phase 0) avec is_primary
-- Ajout :
ALTER TABLE farm ADD COLUMN is_annexe BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE relocation (
  id              SERIAL PRIMARY KEY,
  player_id       INT NOT NULL REFERENCES player(id),
  from_prefecture_id    INT NOT NULL REFERENCES zone(id),
  to_prefecture_id      INT NOT NULL REFERENCES zone(id),
  cost            DECIMAL(12,2) NOT NULL,
  money_lost      DECIMAL(12,2) NOT NULL DEFAULT 0,  -- perte Expert
  buildings_moved INT NOT NULL DEFAULT 0,
  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at    TIMESTAMPTZ,
  status          VARCHAR(15) NOT NULL DEFAULT 'pending'
  -- 'pending', 'in_progress', 'completed'
);
```

### 15.3 Logique métier

```
RELOCATION_BASE_COST = 10000.00
RELOCATION_PER_BUILDING = 500.00
RELOCATION_PA = 50.0
RELOCATION_EXPERT_LOSS_PCT = 0.20
ANNEXE_COST = 50000.00
ANNEXE_MAX = 3

function relocate(player_id, to_prefecture_id):
    player = getPlayer(player_id)
    farm = getPrimaryFarm(player_id)
    server = getServer(player.server_id)

    ASSERT farm.prefecture_id != to_prefecture_id                                → 400 "Même zone"

    -- Vérifier pas de culture en cours
    active_crops = SELECT COUNT(*) FROM crop c
                   JOIN parcel p ON p.id = c.parcel_id
                   WHERE p.farm_id = farm.id AND c.harvested_at IS NULL
    ASSERT active_crops == 0                                         → 409 "Cultures en cours"

    -- Compter bâtiments
    building_count = SELECT COUNT(*) FROM building WHERE farm_id = farm.id
    cost = RELOCATION_BASE_COST + building_count * RELOCATION_PER_BUILDING

    -- Perte Expert
    money_lost = 0
    IF server.slug == 'expert':
        balance = getBalance(player_id)
        money_lost = balance * RELOCATION_EXPERT_LOSS_PCT

    total_cost = cost + money_lost
    ASSERT canPerformAction(player_id, RELOCATION_PA)                → 403

    debit(player_id, cost, 'relocation', 'Déménagement vers zone ' + to_prefecture_id, NULL, NULL)
    IF money_lost > 0:
        debit(player_id, money_lost, 'relocation_penalty',
              'Pénalité déménagement Expert (-20%)', NULL, NULL)

    spendPA(player_id, RELOCATION_PA, 'relocate', { to_prefecture_id })

    -- Transférer la ferme
    old_zone = farm.prefecture_id
    UPDATE farm SET prefecture_id = to_prefecture_id WHERE id = farm.id

    -- Les parcelles restent dans leurs zones (le joueur doit les gérer)
    -- Les bâtiments sont "reconstruits" dans la nouvelle zone
    -- Les matériels suivent la ferme
    -- L'inventaire suit la ferme

    INSERT INTO relocation (player_id, from_prefecture_id, to_prefecture_id, cost, money_lost,
                            buildings_moved, completed_at, status)
    VALUES (player_id, old_zone, to_prefecture_id, cost, money_lost,
            building_count, now(), 'completed')

    RETURN { cost, money_lost, buildings_moved: building_count, new_prefecture_id: to_prefecture_id }

function buyAnnexe(player_id, prefecture_id):
    player = getPlayer(player_id)
    farm = getPrimaryFarm(player_id)
    server = getServer(player.server_id)

    ASSERT prefecture_id != farm.prefecture_id                                   → 400 "Même zone que principale"

    -- Vérifier max annexes
    annexe_count = SELECT COUNT(*) FROM farm
                   WHERE player_id = player_id AND is_annexe = true
    ASSERT annexe_count < ANNEXE_MAX                                 → 409 "Max 3 annexes"

    -- Vérifier pas déjà une ferme dans ce canton
    ASSERT NOT EXISTS farm WHERE player_id = player_id AND prefecture_id = prefecture_id
                                                                     → 409 "Déjà une ferme ici"

    debit(player_id, ANNEXE_COST, 'annexe_buy',
          'Achat ferme annexe zone ' + prefecture_id, NULL, NULL)
    spendPA(player_id, 5.0, 'buy_annexe', { prefecture_id })

    annexe = INSERT INTO farm (player_id, prefecture_id, name, is_primary, is_annexe)
             VALUES (player_id, prefecture_id, 'Ferme annexe', false, true)
             RETURNING *

    RETURN annexe

-- Contrainte Expert : pas de transfert argent principale → annexe
-- Implémenté dans le système de transfert (si existant) :
-- IF server.slug == 'expert' AND target_farm.is_annexe:
--     ASSERT false → 409 "Transfert interdit sur Expert"
```

### 15.4 API Endpoints

#### POST `/api/farm/relocate`

```
Request: { "to_prefecture_id": 15 }
Response 200:
{
  "cost": 14500.00,
  "money_lost": 0,
  "buildings_moved": 9,
  "new_prefecture_id": 15
}
Erreurs: 400 (même canton), 403 (fonds/PA), 409 (cultures en cours)
```

#### POST `/api/farm/annexe`

```
Request: { "prefecture_id": 20 }
Response 201: { "id": 2, "prefecture_id": 20, "name": "Ferme annexe", "is_annexe": true }
Erreurs: 400 (même canton), 403, 409 (max 3, déjà une ferme ici)
```

#### GET `/api/farms`

```
Response 200:
{
  "farms": [
    { "id": 1, "prefecture_id": 5, "name": "Ma ferme", "is_primary": true, "is_annexe": false },
    { "id": 2, "prefecture_id": 20, "name": "Ferme annexe", "is_primary": false, "is_annexe": true }
  ]
}
```

### 15.5 Tests

**Tests unitaires :**
- Déménagement avec 9 bâtiments → 10000 + 9×500 = 14 500€
- Déménagement même canton → 400
- Déménagement avec cultures en cours → 409
- Déménagement Expert : solde 100k → perte 20k
- Déménagement non-Expert : pas de perte
- Achat annexe → 50 000€
- 4e annexe → 409
- Annexe même canton que principale → 400
- Annexe dans zone déjà occupée → 409
- Transfert argent vers annexe sur Expert → 409
- Transfert argent vers annexe sur FR1 → OK

**Tests d'intégration :**
- Déménager → vérifier ferme dans nouvelle zone → vérifier bâtiments transférés → vérifier parcelles inchangées
- Acheter annexe → construire bâtiment dans annexe → acheter parcelle dans zone annexe

---

## Annexe — Constantes complémentaires

| Constante | Valeur | Feature |
|---|---|---|
| **Céréale immature** | | |
| Fenêtre pousse | 60-80% | F1 |
| Facteur rendement | ×1.50 | F1 |
| Date limite | 7 mai | F1 |
| **Quotas betterave** | | |
| Base | 2 ha | F2 |
| Pourcentage | 10% surface cultivée | F2 |
| **CIPAN** | | |
| Bonus rendement | ×1.05 | F3 |
| Destruction | Janvier | F3 |
| Attente post-destruction | 7 jours | F3 |
| Expiration bonus | Juin | F3 |
| **Compostage** | | |
| Ratio fumier→compost | 3:1 | F4 |
| Durée | 14 jours | F4 |
| Retournement 1 | Jour 4-5 | F4 |
| Retournement 2 | Jour 9-10 | F4 |
| Pénalité retournement manqué | 50% | F4 |
| Dose épandage | 15 T/ha | F4 |
| Apports (15T/ha) | N=95, P=60, K=120, Ca=180, Mg=35, S=60 | F4 |
| **Retenue collinaire** | | |
| Consommation irrigation | 10 m³/ha/jour | F5 |
| Bonus jauge pluie | +5/jour | F5 |
| Débit pompage | 50 m³/h | F5 |
| **Pivot central** | | |
| Débit | 10 m³/ha/h | F6 |
| Jauge | +1 mm/h | F6 |
| Max programmation | 24h | F6 |
| HT par rampe | 30 HT | F6 |
| Coût forage | 150€ | F6 |
| **Chien de troupeau** | | |
| HT/jour | 35 | F7 |
| HT/animal déplacé | 1 | F7 |
| Revente | 50% prix achat | F7 |
| **Négociant** | | |
| Cooldown | 1 mois | F8 |
| Max races | 4 | F8 |
| Majoration prix | ×1.20 | F8 |
| Génétique | 50% indice max | F8 |
| **Fusion industrielle** | | |
| Seuil volailles | 5 000 / 1M / 50M | F9 |
| Seuil porcins | 12 000 / 1M / 50M | F9 |
| Seuil lapins | 12 500 / 1M / 50M | F9 |
| Seuil ovins/caprins/chevaux | 15 000 | F9 |
| Seuil bovins | 20 000 | F9 |
| **Assurance matériel** | | |
| Prime | 3% argus | F10 |
| Durée | 12 mois | F10 |
| Couverture | 100% réparation | F10 |
| **Combinés** | | |
| Bonus HT semis trad | -30% | F11 |
| Bonus HT faucher | -40% | F11 |
| Bonus HT déchaumer/semer | -35% | F11 |
| **Achat commun** | | |
| Min/max membres | 2-5 | F12 |
| Condition | Amis, même région | F12 |
| Vente | Unanimité requise | F12 |
| **Magasin CAR** | | |
| Coût bâtiment | 30 000€ | F13 |
| Salaire employé | 1 600€/mois | F13 |
| Espaces | 3 parmi 5 | F13 |
| Promo max | -20% | F13 |
| **Partcel** | | |
| Majoration prix | ×1.50 | F14 |
| Majoration BIO | ×1.50 (en plus) | F14 |
| Rachat location | Après 2 ans | F14 |
| Amortissement location | 60 mois | F14 |
| **Déménagement** | | |
| Coût base | 10 000€ | F15 |
| Coût/bâtiment | 500€ | F15 |
| HT | 50 | F15 |
| Perte Expert | 20% solde | F15 |
| **Fermes annexes** | | |
| Coût | 50 000€ | F15 |
| Max | 3 | F15 |

---

> **Cultivia — PHASE_COMPLEMENTS.md — v1.0**
> 15 features, ~15 nouvelles tables, formules complètes
> Source : REVIEW_GAMEPLAY.md — mécaniques manquantes identifiées
> Prêt pour développement. Un dev peut coder sans poser de questions.
