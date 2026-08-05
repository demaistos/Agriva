# Agriva — README Technique

Jeu de simulation agricole multijoueur asynchrone. V1 Alpha.

## Prérequis

- Docker Desktop ≥ 4.x
- Node.js ≥ 20 (pour les tests Playwright depuis l'hôte)
- Git

## Démarrage rapide (< 5 min)

```bash
# 1. Cloner et démarrer
git clone <repo> agriva && cd agriva
docker compose up --build -d

# 2. Attendre que l'API soit prête (~30s)
docker compose logs -f api | grep "server:start"

# 3. Appliquer les migrations
docker compose exec api npx prisma migrate deploy

# 4. Seeder les données initiales (régions, prix bot, succès)
docker compose exec api npx prisma db seed

# 5. Ouvrir
# Frontend → http://localhost:5173
# API      → http://localhost:3000
```

## Architecture

```
agriva/
├── api/                    # Node.js + Express + Prisma + TypeScript
│   ├── src/modules/        # auth, world, tick, farm, crops, tasks,
│   │                       # economy, livestock, territory, ranking,
│   │                       # achievements, social, notifications, admin
│   ├── prisma/             # schema.prisma, migrations/, seed.ts
│   └── tests/              # unit/ (Vitest) + e2e/ (Playwright API)
├── frontend/               # React 18 + Vite 5 + TypeScript
│   ├── src/pages/          # auth/, hub, exploitation/, marches/,
│   │                       # territoire/, social/, achievements/
│   └── tests/e2e/          # Playwright UI
└── docker-compose.yml      # postgres:16 + redis:7 + api + frontend
```

## Stack

| Couche | Technologie |
|--------|-------------|
| Backend | Node.js 20 + Express 4 + TypeScript |
| ORM | Prisma 5 + PostgreSQL 16 |
| Cache | Redis 7 (BullMQ pour les jobs) |
| Auth | JWT (access 15min + refresh 30j) |
| Frontend | React 18 + Vite 5 + React Router 6 |
| Tests unitaires | Vitest 2 |
| Tests E2E | Playwright |

## Commandes utiles

```bash
# Démarrer / arrêter
docker compose up --build -d
docker compose down

# Logs
docker compose logs -f api
docker compose logs -f frontend

# Migrations
docker compose exec api npx prisma migrate deploy   # appliquer
docker compose exec api npx prisma migrate status   # vérifier

# Seed
docker compose exec api npx prisma db seed

# Reset complet (⚠️ supprime toutes les données)
docker compose down -v
docker compose up --build -d
docker compose exec api npx prisma migrate deploy
docker compose exec api npx prisma db seed

# Tests unitaires (depuis l'hôte)
cd api && node node_modules/vitest/vitest.mjs run

# Tests Playwright API (depuis l'hôte, réutilise les containers)
cd api
DATABASE_URL=postgresql://agriva:dev@localhost:5432/agriva \
  node node_modules/.bin/playwright test

# Tests Playwright UI
cd frontend
node node_modules/.bin/playwright test

# Prisma Studio (interface BDD)
docker compose exec api npx prisma studio
```

## Variables d'environnement

Copier `.env.example` → `.env` et adapter :

| Variable | Défaut | Description |
|----------|--------|-------------|
| `DATABASE_URL` | `postgresql://agriva:dev@postgres:5432/agriva` | URL PostgreSQL |
| `REDIS_URL` | `redis://redis:6379` | URL Redis |
| `JWT_SECRET` | `dev-secret-change-in-prod` | Secret JWT access token |
| `JWT_REFRESH_SECRET` | `dev-refresh-secret-change-in-prod` | Secret JWT refresh token |
| `TICK_INTERVAL_MS` | `18000000` (5h) | Intervalle du tick serveur |
| `NODE_ENV` | `development` | Environnement |

⚠️ **En production** : changer `JWT_SECRET` et `JWT_REFRESH_SECRET` par des valeurs aléatoires fortes.

## URLs de l'API

| Route | Description |
|-------|-------------|
| `POST /auth/register` | Inscription |
| `POST /auth/login` | Connexion |
| `GET /world/regions` | 8 régions agroclimatiques |
| `POST /farm` | Créer/récupérer la ferme |
| `GET /farm/parcels` | Liste des parcelles |
| `POST /farm/parcels/:id/crop` | Semer une culture |
| `POST /farm/parcels/:id/crop/harvest` | Récolter |
| `POST /farm/tasks` | Démarrer une tâche |
| `GET /market/bot/prices` | Prix de la coopérative bot |
| `POST /market/bot/sell` | Vendre au bot |
| `GET /market/treasury` | Trésorerie |
| `POST /livestock/herds` | Créer un troupeau |
| `POST /territory/service-orders` | Commander un service |
| `GET /rankings` | Classements saisonniers |
| `GET /achievements` | Succès du joueur |
| `POST /social/messages` | Envoyer un message |
| `GET /notifications` | Notifications non lues |
| `GET /admin/dashboard` | Dashboard admin |
| `POST /admin/params` | Modifier un paramètre à chaud |
| `POST /admin/tick/run` | Déclencher un tick manuellement |

## Paramètres admin ajustables à chaud

Via `POST /admin/params` avec `{ key, value }` :

| Clé | Défaut | Description |
|-----|--------|-------------|
| `aid_threshold_cash` | 500 | Seuil trésorerie déclenchant l'aide automatique (€) |
| `aid_amount_cash` | 1000 | Montant de l'aide automatique (€) |
| `bot_spread_buy` | 0.80 | Multiplicateur prix d'achat bot (joueur vend) |
| `bot_spread_sell` | 1.20 | Multiplicateur prix de vente bot (joueur achète) |

## Tick serveur

Le tick s'exécute toutes les 5h réelles (configurable via `TICK_INTERVAL_MS`).

Séquence par tick :
1. Météo — génération des prévisions J+7
2. Cultures — avancement des stades
3. Élevage — cycles de production
4. Travaux — complétion des tâches
5. Services — avancement des commandes ETA
6. Économie — coûts fixes journaliers + aide automatique
7. Classements — recalcul des scores et rangs

Déclencher manuellement : `POST /admin/tick/run`

## Tests

```bash
# Unitaires (75 tests, ~600ms)
cd api && node node_modules/vitest/vitest.mjs run

# E2E API (6 suites, ~60 tests)
cd api && DATABASE_URL=postgresql://agriva:dev@localhost:5432/agriva \
  node node_modules/.bin/playwright test

# E2E UI (6 suites, ~30 tests)
cd frontend && node node_modules/.bin/playwright test

# Intégration bout-en-bout (30 tests)
cd api && DATABASE_URL=postgresql://agriva:dev@localhost:5432/agriva \
  node node_modules/.bin/playwright test tests/e2e/sprint-integration.spec.ts
```

## Déploiement production (VPS)

```bash
# 1. Cloner sur le serveur
git clone <repo> /opt/agriva && cd /opt/agriva

# 2. Créer .env avec les vraies valeurs
cp .env.example .env
# Éditer .env : JWT_SECRET, JWT_REFRESH_SECRET, NODE_ENV=production

# 3. Démarrer
docker compose -f docker-compose.yml up --build -d

# 4. Migrations + seed
docker compose exec api npx prisma migrate deploy
docker compose exec api npx prisma db seed

# 5. Vérifier
curl http://localhost:3000/admin/status
```

Recommandations production :
- Nginx en reverse proxy devant le port 3000 (API) et 5173 (frontend)
- Certificat TLS via Let's Encrypt
- Sauvegardes PostgreSQL quotidiennes (`pg_dump`)
- Monitoring : `GET /admin/dashboard` pour les métriques clés

## Structure des données de test

Les tests E2E utilisent des emails isolés (`e2e_TIMESTAMP@agriva.fr`) pour ne pas polluer les données manuelles. Chaque run crée ses propres données.
