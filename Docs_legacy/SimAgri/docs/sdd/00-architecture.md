# SDD 00 — Architecture globale (Scalable)

Objectif : supporter plusieurs centaines de joueurs simultanés, avec un tick engine qui tourne 24/7 sans bloquer les requêtes.

---

## Stack technique

| Couche | Technologie | Justification |
|--------|------------|---------------|
| Frontend | Vue.js 3 + Vite | SPA légère, réactive |
| Backend API | Node.js + Fastify | Async natif, ~30K req/s sur un core |
| BDD | PostgreSQL 16 | Relationnel solide, partitioning natif, JSONB |
| Cache / Pub-Sub | Redis 7 (Cluster mode) | Sessions, cache prix, pub/sub notifications, rate limiting |
| ORM | Prisma | Migrations, typage, connection pooling via PgBouncer |
| Connection Pool | PgBouncer | Limite les connexions PG (100 joueurs = 100 connexions sans pool) |
| Tick Engine | Worker threads + BullMQ | Jobs async découplés de l'API, retry, concurrency control |
| Temps réel | Socket.io (Redis adapter) | Notifications live, chat, scalable sur N instances |
| Auth | JWT (access 15min + refresh 30j) | Stateless, pas de session serveur |
| Reverse Proxy | Nginx | Load balancing, SSL, static files, WebSocket proxy |
| Déploiement | Docker Compose → puis Kubernetes si besoin | Scale horizontal |
| Monitoring | Prometheus + Grafana | Métriques API, ticks, BDD, Redis |
| Logs | Pino (Fastify natif) → stdout → agrégation | Structured JSON logging |

---

## Architecture

```
                         ┌──────────┐
                         │  Nginx   │
                         │ (LB/SSL) │
                         └────┬─────┘
                              │
                 ┌────────────┼────────────┐
                 │            │            │
          ┌──────┴──────┐ ┌──┴───┐ ┌──────┴──────┐
          │ API Node #1 │ │ #2   │ │ #N          │  ← Scale horizontal
          │ (Fastify)   │ │      │ │             │
          └──────┬──────┘ └──┬───┘ └──────┬──────┘
                 │           │            │
                 └─────┬─────┘────────────┘
                       │
          ┌────────────┼────────────┐
          │            │            │
   ┌──────┴──────┐ ┌───┴────┐ ┌────┴─────┐
   │  PgBouncer  │ │ Redis  │ │ BullMQ   │
   │  (Pool)     │ │ Cluster│ │ Workers  │
   └──────┬──────┘ └────────┘ └────┬─────┘
          │                        │
   ┌──────┴──────┐          ┌──────┴──────┐
   │ PostgreSQL  │          │ Tick Worker  │  ← Process séparé
   │ (Primary)   │          │ (1 par       │
   │             │          │  serveur jeu)│
   └─────────────┘          └─────────────┘
```

### Principes clés

1. **API stateless** : chaque instance Fastify est identique, pas d'état en mémoire. Scale en ajoutant des instances derrière Nginx.

2. **Tick Engine découplé** : les ticks (croissance cultures, faim animaux, météo) tournent dans des workers BullMQ séparés. L'API ne fait jamais de calcul lourd.

3. **1 worker par serveur de jeu** : chaque serveur SimAgri (France1, Belgique1...) a son propre worker tick. Pas de contention entre serveurs.

4. **PgBouncer** : pool de connexions PostgreSQL. 200 joueurs simultanés → 20-30 connexions PG réelles au lieu de 200.

5. **Redis pour tout le temps réel** : cache prix marché (TTL 60s), sessions Socket.io partagées entre instances API, pub/sub pour notifications.

---

## Schéma BDD — Stratégie multi-serveur

### Option retenue : `server_id` sur chaque table

Plutôt que des schemas séparés (complexe à maintenir), chaque table de données de jeu a un `server_id`. Index composites pour les performances.

```sql
-- Exemple : toutes les requêtes filtrent par server_id
CREATE INDEX idx_players_server ON players(server_id);
CREATE INDEX idx_animals_player ON animals(player_id);
CREATE INDEX idx_crops_parcel ON crops(parcel_id);
CREATE INDEX idx_parcels_player_server ON parcels(player_id, server_id);
```

### Partitioning (si >10K joueurs par serveur)
```sql
-- Partitioning par server_id sur les tables volumineuses
CREATE TABLE animals (
  ...
) PARTITION BY LIST (server_id);

CREATE TABLE animals_france1 PARTITION OF animals FOR VALUES IN (1);
CREATE TABLE animals_france2 PARTITION OF animals FOR VALUES IN (2);
```

---

## Tick Engine — Design détaillé

### Problème
Le tick doit mettre à jour potentiellement des milliers d'animaux et cultures chaque heure, sans bloquer l'API.

### Solution : BullMQ avec jobs batch

```
Cron (node-cron) dans le tick worker :
  
  Toutes les heures :
    → Queue "tick:hourly:{server_id}"
    → Job : croissance cultures (UPDATE batch SQL)
    → Job : consommation eau/soleil jauges
  
  Tous les jours à 00:00 :
    → Queue "tick:daily:{server_id}"
    → Job : reset PA joueurs (1 UPDATE batch)
    → Job : usure matériel (1 UPDATE batch)
    → Job : usure bâtiments (1 UPDATE batch)
    → Job : alimentation animaux (batch par espèce)
    → Job : litière → fumier (batch)
    → Job : météo du jour (1 INSERT)
    → Job : gestation check (batch)
    → Job : ancienneté joueurs (1 UPDATE batch)
  
  Toutes les semaines (= 1 mois SimAgri) :
    → Job : facture électricité (batch)
    → Job : salaires (batch)
    → Job : remboursement emprunts (batch)
    → Job : mise à jour prix marché
    → Job : avancement game_time
```

### Batch SQL (clé de la performance)
```sql
-- Au lieu de 500 UPDATE individuels pour la croissance :
UPDATE crops
SET growth_pct = LEAST(100, growth_pct + :daily_growth * weather_factor)
WHERE parcel_id IN (
  SELECT id FROM parcels WHERE server_id = :server_id
)
AND harvested = false
AND culture_type != 'herbe' OR current_season != 'hiver';

-- 1 seule requête pour tous les joueurs d'un serveur
UPDATE players SET hours_today = hours_max WHERE server_id = :server_id;
```

### Concurrency
- BullMQ `concurrency: 1` par serveur de jeu → pas de race condition
- Les jobs d'un même serveur s'exécutent séquentiellement
- Les jobs de serveurs différents s'exécutent en parallèle

---

## Cache Redis — Stratégie

| Clé | TTL | Usage |
|-----|-----|-------|
| `prices:{server_id}` | 60s | Prix marché (évite requête BDD à chaque affichage) |
| `weather:{server_id}:{day}` | 24h | Météo du jour |
| `player:{id}:pa` | 0 (permanent) | PA restants (lecture fréquente) |
| `online:{server_id}` | SET | Joueurs connectés (Socket.io) |
| `rate:{ip}` | 60s | Rate limiting (100 req/min) |

---

## WebSocket — Socket.io avec Redis Adapter

```
Événements émis par le serveur :
  - "notification" : alerte joueur (animal malade, récolte prête, panne...)
  - "market:update" : nouveau prix marché
  - "weather:update" : météo du jour
  - "chat:message" : message MP-Live
  - "tick:daily" : résumé journalier (PA reset, événements)
```

Avec le Redis adapter, les événements sont broadcast à toutes les instances API. Un joueur connecté à l'instance #1 reçoit les messages émis par l'instance #2.

---

## Rate Limiting

```
Via Fastify plugin @fastify/rate-limit + Redis store :
  - Global : 100 req/min par IP
  - Auth : 10 req/min (login/register)
  - Actions jeu : 60 req/min par joueur
  - Marché : 30 req/min par joueur
```

---

## Estimation ressources serveur

### Pour ~500 joueurs simultanés :
| Composant | Specs |
|-----------|-------|
| API (2 instances) | 2 vCPU, 2 Go RAM chacune |
| Tick Worker | 2 vCPU, 2 Go RAM |
| PostgreSQL | 4 vCPU, 8 Go RAM, SSD |
| PgBouncer | 1 vCPU, 512 Mo RAM (pool_size=30) |
| Redis | 2 vCPU, 2 Go RAM |
| Nginx | 1 vCPU, 512 Mo RAM |
| **Total** | ~12 vCPU, ~15 Go RAM |

Un VPS dédié à ~40-60€/mois (Hetzner, OVH) suffit largement pour démarrer avec Docker Compose. Kubernetes si on dépasse 1000+ simultanés.

---

## Structure des dossiers

```
SimAgri/
├── client/                    # Vue.js frontend
│   ├── src/
│   │   ├── views/
│   │   ├── components/
│   │   ├── stores/            # Pinia
│   │   ├── composables/       # Logique réutilisable
│   │   ├── api/               # Client HTTP (axios/fetch)
│   │   └── socket/            # Socket.io client
│   └── vite.config.ts
├── server/                    # Fastify backend
│   ├── src/
│   │   ├── app.ts             # Bootstrap Fastify
│   │   ├── routes/            # Routes par domaine
│   │   ├── services/          # Logique métier
│   │   ├── plugins/           # Fastify plugins (auth, rate-limit...)
│   │   ├── socket/            # Socket.io handlers
│   │   └── utils/
│   └── tsconfig.json
├── worker/                    # Tick engine (process séparé)
│   ├── src/
│   │   ├── index.ts           # Bootstrap worker
│   │   ├── ticks/             # Jobs par type (hourly, daily, weekly)
│   │   ├── jobs/              # Logique de chaque job
│   │   └── queries/           # SQL batch optimisés
│   └── tsconfig.json
├── shared/                    # Code partagé (types, constantes)
│   ├── types/
│   ├── constants/             # Données de référence (races, cultures, rendements)
│   └── utils/
├── prisma/
│   ├── schema.prisma
│   └── seed.ts                # Seed données de référence
├── docker/
│   ├── nginx.conf
│   └── pgbouncer.ini
├── docker-compose.yml
├── docker-compose.prod.yml
├── package.json               # Workspace root (npm workspaces)
├── turbo.json                 # Turborepo (build/dev parallèle)
└── docs/sdd/
```

### Monorepo avec npm workspaces + Turborepo
- `client`, `server`, `worker`, `shared` sont des packages séparés
- `shared` est importé par `server` et `worker`
- Turborepo parallélise les builds
