# CULTIVIA — Technical Design Document (TDD)
## Version 2.1 — Mis à jour le 2026-04-09

> **324 actions documentées** | **63 tables BDD** | **~230 routes API** | **~80 pages UI**
> Voir `08_ACTIONS_DETAILLEES.md` pour le détail step-by-step de chaque action.
> Voir `09_STEERING.md` pour les décisions de pilotage et la roadmap.

---

# 1. STACK TECHNIQUE

## 1.1 Architecture (single server, full Docker Compose)

**Un seul serveur de jeu : France.** Pas de multi-serveur. Infra identique en dev (local) et prod (VPS/dédié).

```
┌─────────────────────────────────────────────────────────┐
│              Machine hôte (local ou VPS)                 │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │            Traefik (reverse proxy)               │    │
│  │            :80 / :443 (SSL Let's Encrypt)        │    │
│  └──────────┬──────────────┬────────────────────────┘    │
│             ▼              ▼                              │
│  ┌──────────────┐  ┌──────────────┐                      │
│  │  Frontend    │  │  API Server  │                      │
│  │  Next.js     │  │  Node.js     │                      │
│  │  :3000       │  │  tRPC + WS   │                      │
│  │              │  │  :4000       │                      │
│  └──────────────┘  └──────┬───────┘                      │
│                           │                              │
│          ┌────────────────┼────────────────┐             │
│          ▼                ▼                ▼             │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐     │
│  │ PostgreSQL │  │   Redis    │  │  Worker        │     │
│  │   :5432    │  │   :6379    │  │  (cron jobs +  │     │
│  │            │  │            │  │   daily update)│     │
│  └────────────┘  └────────────┘  └────────────────┘     │
│                                                         │
│  ┌────────────┐  ┌────────────┐                         │
│  │   MinIO    │  │  Grafana   │                         │
│  │   :9000    │  │   :3001    │                         │
│  └────────────┘  └────────────┘                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### docker-compose.yml (dev)
```yaml
services:
  frontend:
    build: ./frontend
    ports: ["3000:3000"]

  api:
    build: ./api
    ports: ["4000:4000"]
    depends_on: [postgres, redis]
    environment:
      DATABASE_URL: postgres://cultivia:pass@postgres:5432/cultivia
      REDIS_URL: redis://redis:6379

  worker:
    build: ./api
    command: node dist/worker.js
    depends_on: [postgres, redis]
    environment:
      DATABASE_URL: postgres://cultivia:pass@postgres:5432/cultivia
      REDIS_URL: redis://redis:6379

  postgres:
    image: postgres:16-alpine
    ports: ["5432:5432"]
    volumes: [pgdata:/var/lib/postgresql/data]
    environment:
      POSTGRES_DB: cultivia
      POSTGRES_USER: cultivia
      POSTGRES_PASSWORD: pass

  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
    volumes: [redisdata:/data]

volumes:
  pgdata:
  redisdata:
```

### docker-compose.prod.yml (ajouts prod)
```yaml
services:
  traefik:
    image: traefik:v3
    ports: ["80:80", "443:443"]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik:/etc/traefik

  frontend:
    labels:
      - "traefik.http.routers.frontend.rule=Host(`cultivia.fr`)"

  api:
    labels:
      - "traefik.http.routers.api.rule=Host(`cultivia.fr`) && PathPrefix(`/api`, `/trpc`, `/ws`)"

  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    volumes: [miniodata:/data]

  grafana:
    image: grafana/grafana
    ports: ["3001:3000"]

volumes:
  miniodata:
```

### Déploiement
```
Dev  : docker compose up                                    (5 containers)
Prod : docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build  (8 containers)
```

## 1.2 Choix technologiques

| Couche | Technologie | Justification |
|--------|-------------|---------------|
| Frontend | Next.js 15 + React 19 | SSR pour SEO, App Router, Server Components |
| UI | TailwindCSS + Shadcn/UI | Composants accessibles, thème personnalisable |
| State | Zustand + TanStack Query | Léger, cache API, optimistic updates |
| API | tRPC | Type-safety end-to-end, auto-completion |
| Backend | Node.js 22 + TypeScript | Même langage front/back, workers pour calculs |
| ORM | Drizzle ORM | Type-safe, performant, migrations |
| BDD | PostgreSQL 16 | JSONB pour données flexibles, transactions ACID |
| Cache | Redis 7 | Sessions, leaderboards, pub/sub temps réel |
| Temps réel | Socket.io | Chat, notifications, prix marché live |
| Auth | NextAuth.js v5 | OAuth, credentials, sessions JWT |
| Email | Resend | Transactionnel |
| Storage | S3/MinIO | Images matériel, avatars |
| Infra | Docker Compose | Stack identique dev/prod, simple |
| Reverse proxy | Traefik v3 | SSL auto, routing, dashboard |
| CI/CD | GitHub Actions | Lint, tests, build images |
| Monitoring | Sentry + Grafana | Erreurs, perf, métriques jeu |

---

# 2. MODÈLE DE DONNÉES (PostgreSQL)

## 2.1 Schéma principal

### Core
```sql
-- Joueurs
users (id, username, email, password_hash, created_at, last_login)
user_profiles (user_id FK, commune_id FK, balance, ht_remaining, ht_base, farm_name)

-- Géographie (France réelle — seed depuis geo.api.gouv.fr)
regions (id, name, code_iso)  -- 18 régions
departments (id, region_id FK, name, code, lat, lng)  -- 101 départements
communes (id, department_id FK, name, type ENUM('prefecture','sous_prefecture'),
          code_postal, lat, lng, population)  -- 101 préfectures + ~2 162 sous-préfectures

-- Distances précalculées (matrice)
commune_distances (from_id FK, to_id FK, distance_km)  -- ~2.5M paires

-- Météo dynamique (cache depuis Open-Meteo, refresh toutes les 6h)
weather_cache (department_id FK, date DATE, 
               temp_min FLOAT, temp_max FLOAT,
               precipitation_mm FLOAT, sunshine_hours FLOAT,
               wind_max_kmh FLOAT, weather_level INT, -- 1-5 (très ensoleillé → forte pluie)
               fetched_at TIMESTAMP)

-- Temps jeu
game_state (id, current_season, current_month, current_day)
```

### Élevage
```sql
animals (id, user_id FK, species, breed, sex, age_days, weight_kg, 
         building_id FK, pasture_id FK, is_pregnant, pregnant_since,
         genetics JSONB, -- {croissance: 85, lait: 72, ...}
         health_status, last_fed_at, last_watered_at, last_bedded_at,
         is_named, name, ivrad_slot_id, label, organic_days,
         created_at, born_at_farm BOOLEAN)

animal_species (id, name, building_type, gestation_months, 
                reproduction_age_months, litter_min, litter_max,
                lifespan_years, rations JSONB, surfaces JSONB)
                -- rations JSONB = besoins nutritionnels {energy: 100, protein: 80, fiber: 60, mineral: 40}

animal_breeds (id, species_id FK, name, birth_weight, adult_weight,
               milk_production, wool_production, egg_production,
               is_rare BOOLEAN, server_exclusive VARCHAR)

animal_groups (id, user_id FK, species, breed, count, avg_genetics JSONB)
```

### Cultures
```sql
parcels (id, user_id FK, commune_id FK, surface_ha, 
         soil_quality, soil_nutrients JSONB, -- {N:150, P:80, K:200, Ca:500, Mg:50, S:30}
         current_crop, crop_growth_pct, crop_sown_at,
         is_organic BOOLEAN, organic_since, has_stones BOOLEAN,
         irrigation_type, source_level, has_pipeline BOOLEAN,
         sun_gauge, rain_gauge, type ENUM('field','meadow','orchard','vineyard','market_garden'))

crops (id, name, sow_months, harvest_months, avg_price, rotation_years,
       harvest_machine, seeds_per_ha, nutrients_needed JSONB,
       yields_by_region JSONB) -- {alsace: 7.0, aquitaine: 5.7, ...}
```

### Matériel
```sql
equipment (id, user_id FK, model_id FK, wear_pct, fuel_level,
           building_id FK, is_shared BOOLEAN, shared_with JSONB,
           has_gps BOOLEAN, has_front_linkage BOOLEAN,
           insurance_expires_at, parts_status JSONB,
           purchased_at, purchased_price)

equipment_models (id, brand, name, family, type, power_hp, 
                  width_m, capacity, fuel_consumption JSONB,
                  price_new, maneuverability INT,
                  required_power_hp, is_motorized BOOLEAN)
```

### Bâtiments
```sql
buildings (id, user_id FK, type, name, surface_or_capacity, 
           equipment_level INT, wear_pct, energy_consumption_kwh,
           contents JSONB,
           constructed_at, construction_ends_at)

-- Catalogue des 30 types de bâtiments et accessoires (seed)
-- Accessoires = constructions indépendantes, pas rattachées à un bâtiment
building_types (id, type UNIQUE, label, category ENUM('elevage','stockage','accessoire'),
                usage TEXT, unit, price_per_unit, energy_per_unit,
                capacity_per_animal, max_capacity)
```

### Économie
```sql
transactions (id, user_id FK, type, category, amount, description, created_at)
loans (id, user_id FK, amount, rate, duration_months, remaining, monthly_payment, created_at)
savings (id, user_id FK, type ENUM('1y','3y','5y'), amount, opened_at, matures_at)
market_listings (id, seller_id FK, item_type, item_id, price, quantity, region_scope, expires_at)
contracts (id, buyer_id FK, seller_id FK, type, terms JSONB, status, created_at, expires_at)
```

### Social
```sql
friendships (user_id FK, friend_id FK, level ENUM('friend','privileged','special'), since)
messages (id, from_id FK, to_id FK, subject, body, read_at, created_at)
forum_posts (id, forum_id, user_id FK, title, body, created_at)
notifications (id, user_id FK, type, data JSONB, read_at, created_at)
```

### Activités secondaires
```sql
dealerships (id, user_id FK, hall_surface, licenses JSONB, employees JSONB)
cia_centers (id, user_id FK, lab_surface, stock JSONB)
cheese_factories (id, user_id FK, type ENUM('artisan','industrial'), equipment_level, hygiene_pct)
vineyards (id, user_id FK, region_id FK, balance, parcels JSONB, cellar JSONB)
transport_companies (id, user_id FK, license_type, vehicles JSONB, drivers JSONB)
cooperatives (id, name, region_id FK, capital, associates JSONB, buildings JSONB)
```

### Employés
```sql
employees (id, user_id FK, type ENUM('agricole','chauffeur','vendeur','mecanicien',
           'inseminateur','fromager','chef_culture','ouvrier_maraichage',
           'agent_viticole','maitre_chai','vendangeur','caviste','commercial_laiterie'),
           salary, ht_per_day, hired_at, skills JSONB)
```

### ETA / Prestations
```sql
eta_companies (id, user_id FK, license_type, tariffs JSONB, created_at)
eta_orders (id, eta_id FK, client_id FK, work_type, parcel_id FK,
            surface_ha, status ENUM('pending','accepted','in_progress','done','cancelled'),
            price, created_at, completed_at)
```

### Compétition / Social étendu
```sql
challenges (id, type, scope ENUM('individual','department','region'),
            metric, start_at, end_at, rewards JSONB)
challenge_entries (id, challenge_id FK, user_id FK, value, rank)
badges (id, name, description, condition JSONB, icon)
user_badges (user_id FK, badge_id FK, unlocked_at)
leaderboards (id, type, period, user_id FK, value, rank)  -- dénormalisé, refresh périodique
lottery_draws (id, draw_date, prize, winner_id FK)
lottery_tickets (id, draw_id FK, user_id FK, purchased_at)
```

### Formation CFCA
```sql
cfsa_formations (id, trainee_id FK, mentor_id FK,
                 started_at, ends_at, completed BOOLEAN, bonus_paid BOOLEAN)
```

### CECA
```sql
cesa_elections (id, region_id FK, season, status ENUM('open','closed'))
cesa_candidates (id, election_id FK, user_id FK)
cesa_votes (id, election_id FK, voter_id FK, candidate_id FK, voted_at)
cesa_proposals (id, region_id FK, proposer_id FK, type, params JSONB,
                status ENUM('voting','accepted','rejected'), created_at)
```

### IVRAD
```sql
ivrad_objectives (id, user_id FK, species, breed, target JSONB, progress JSONB)
ivrad_slots (id, user_id FK, species, breed, animal_id FK, granted_at)
```

### Forêts
```sql
forests (id, user_id FK, commune_id FK, surface_ha, nb_stations)
forest_stations (id, forest_id FK, surface_ha, tree_species, age_years,
                 growth_stage ENUM('planted','young','mature','harvestable'),
                 last_work JSONB)
```

### Maraîchage
```sql
market_gardens (id, user_id FK, personnel JSONB, skills JSONB)
greenhouses (id, garden_id FK, type ENUM('plastic','glass','tunnel'),
             heated BOOLEAN, surface_m2, temperature)
garden_plots (id, garden_id FK, crop, sown_at, harvest_at, growth_pct)
```

### Arboriculture
```sql
orchards (id, parcel_id FK, tree_species, tree_count, age_years,
          has_hail_net BOOLEAN, last_pruned_at, last_treated_at)
```

### Méthanisation
```sql
methanization_plants (id, user_id FK, capacity, substrates JSONB,
                      cycle_start_at, cycle_ends_at, digestate_stock)
```

### Foie gras
```sql
foie_gras_batches (id, user_id FK, animal_ids JSONB, stage ENUM('fattening','slaughter','done'),
                   started_at, gavage_day, product_stock JSONB)
```

### Garde de ferme / Visites
```sql
farm_guards (id, farm_owner_id FK, guardian_id FK, started_at, ends_at, active BOOLEAN)
farm_visits (id, host_id FK, visitor_id FK, visited_at)
```

### Audit / Sécurité
```sql
audit_logs (id, user_id FK, action, entity_type, entity_id,
            details JSONB, ip_address, created_at)
```

### Factures énergie
```sql
energy_bills (id, user_id FK, month, year, kwh_consumed, amount, paid_at)
```

### Mode vacances
```sql
vacation_modes (id, user_id FK, started_at, ends_at, daily_cost,
                active BOOLEAN, season)
-- Max 7 jours/saison. Nourrissage + abreuvement auto. Pas de production.
```

## 2.2 Indexes critiques
```sql
CREATE INDEX idx_animals_user ON animals(user_id);
CREATE INDEX idx_animals_species ON animals(user_id, species);
CREATE INDEX idx_parcels_user ON parcels(user_id);
CREATE INDEX idx_market_type_region ON market_listings(item_type, region_scope, expires_at);
CREATE INDEX idx_transactions_user_date ON transactions(user_id, created_at DESC);
```

---

# 3. GAME ENGINE (Workers)

## 3.1 Cron Jobs

### Météo (toutes les 6h)
```
*/6 * * * — WEATHER_FETCH
├── Pour chaque département (101):
│   ├── GET https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lng}
│   │       &daily=temperature_2m_max,temperature_2m_min,precipitation_sum,
│   │              sunshine_duration,wind_speed_10m_max
│   │       &timezone=Europe/Paris&forecast_days=2
│   ├── Mapper vers weather_level (1-5)
│   └── UPSERT weather_cache
└── Publish Redis event weather:updated
```

### Mise à jour quotidienne (00:00 UTC)
```
00:00 UTC — DAILY_UPDATE
├── Weather: apply cached weather effects to all parcels
├── Animal aging (+1 jour tous les animaux)
├── Animal hunger check (pas nourri → maladie/mort)
├── Animal water check
├── Animal pregnancy progress
├── Animal births
├── Animal growth (poids selon génétique + ration standard 100% ou libre +bonus)
├── Crop growth (% pousse selon météo + sol + traitements + bonus rendement parcelle)
├── Building wear (+usure quotidienne)
├── Equipment wear
├── Energy consumption calculation
├── HT reset (35 HT base + employés)
├── Market price fluctuation
├── Milk production calculation
├── Egg production calculation
├── Wool/down growth
├── Organic certification check
├── Label check (plein-air %)
├── Loan payments (mensuel)
├── Salary payments (mensuel)
├── Tax collection (mensuel si applicable)
└── Notification generation
```

## 3.2 Event-driven actions (temps réel — 324 actions documentées)

> Chaque action est détaillée dans `08_ACTIONS_DETAILLEES.md` avec :
> prérequis, étapes UI, validations serveur, impacts BDD, coût HT/€, effets secondaires.

```
USER_ACTION → Validate HT → Execute → Update DB → Broadcast WS
├── feed_animals(species, building_id, ration_type)
│   -- ration_type: 'standard' | 'custom' (si custom: ingredients JSONB)
├── water_animals(building_id)
├── bed_animals(building_id, straw_qty)
├── milk_animals(species)
├── collect_eggs()
├── move_to_pasture(animal_ids, pasture_id)
├── inseminate(female_id, male_id_or_cia)
├── sow_parcel(parcel_id, crop, technique)
├── harvest_parcel(parcel_id)
├── buy_from_coop(item, quantity)
├── sell_to_coop(item, quantity)
├── buy_equipment(model_id, source)
├── build(type, size, level)
├── transport(from, to, cargo)
└── ... (~300 actions au total)
```

---

# 4. API ROUTES (tRPC)

> **Note implémentation** : Les premières routes sont implémentées en Next.js API Routes (`/api/*`)
> plutôt qu'en tRPC, pour simplifier le MVP. Migration vers tRPC prévue en Phase 3.
>
> **Routes implémentées (7) :**
> - `POST /api/register` — inscription (username, email, password, communeId)
> - `GET/POST /api/setup` — packs de départ (GET: liste, POST: créer ferme)
> - `GET /api/dashboard` — données dashboard (profil, animaux, bâtiments, parcelles, matériel)
> - `POST /api/dashboard/tutorial` — marquer tutoriel terminé
> - `GET/POST /api/ht` — système HT (GET: état, POST: deduct/buy)
> - `GET/POST /api/buildings` — bâtiments (GET: liste+animaux+types, POST: build/destroy/maintain/rename/upgrade/expand)
> - `GET/POST /api/auth/[...nextauth]` — NextAuth.js (login/logout/session)

```typescript
// Structure des routers
app.router({
  auth: { login, register, logout, me, changePassword },
  farm: { dashboard, settings, relocate, annex, onboarding },
  animals: { list, feed, water, bed, milk, eggs, inseminate, sell, buy, move,
             vaccinate, vet, merge, unmerge, name, follow, slaughter, market },
  parcels: { list, sow, harvest, fertilize, treat, irrigate, buy, sell, rent,
             analyze, convert, fallow },
  equipment: { list, buy, sell, maintain, refuel, repair, insure, gps, auction, move },
  buildings: { list, build, upgrade, destroy, maintain, accessory, pipeline },
  market: { listings, buy, sell, search, negotiate, private },
  coop: { buy, sell, fuel, accessories, transport },
  finance: { balance, history, loan, repay, savings, withdraw, invest, ht },
  social: { friends, promote, remove, messages, mpLive, forum, visit, guard,
            preferences, notifications, notepad, sponsor },
  transport: { demands, create, accept, load, deliver, license, favorites },
  employees: { hire, fire, list, skills },
  dealership: { create, stock, sell, repair, gps, parts, rent, license, deposit },
  cia: { create, contracts, collect, inseminate, genbook, ivrad },
  cheese: { create, produce, age, sell, clean, cream, butter },
  maraichage: { create, sow, harvest, pack, sell, greenhouse, treat },
  vineyard: { create, plant, prune, treat, harvest, vinify, assemble, bottle, age, sell },
  arboriculture: { plant, prune, thin, harvest, treat, hailNet },
  forest: { buy, plant, prune, thin, cut, sell, etf },
  eta: { create, order, respond },
  car: { create, join, leave, oilMill, sugarMill, dairy, shop, contracts, partcel },
  methanisation: { build, feed, drain, electricity, fuel },
  foiegras: { place, gavage, slaughter, sell },
  cesa: { candidate, vote, propose, results },
  cfsa: { enroll, accept, complete },
  challenges: { list, join, leaderboard, badges },
  lottery: { buy, draw },
  admin: { weather, economy, moderation, audit },
})
```

---

# 5. TEMPS RÉEL (WebSocket)

## Events serveur → client
```
weather:update        — Nouvelle météo
market:price_change   — Fluctuation prix
market:listing_sold   — Annonce vendue
notification:new      — Nouvelle notification
chat:message          — Message MP-Live
animal:birth          — Naissance
animal:death          — Mort
crop:ready            — Récolte prête
equipment:breakdown   — Panne matériel
building:constructed  — Construction terminée
transport:demand_new  — Nouvelle demande transport
cheese:aged           — Fromage affiné prêt
cesa:vote_open        — Nouveau vote CECA
challenge:update      — Mise à jour challenge
energy:bill           — Facture énergie mensuelle
loan:payment          — Prélèvement mensuel prêt
```

## Events client → serveur
```
chat:send             — Envoyer message
action:execute        — Exécuter action jeu
market:place_order    — Passer commande
```
