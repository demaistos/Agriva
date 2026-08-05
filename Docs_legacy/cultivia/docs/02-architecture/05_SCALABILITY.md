# Cultivia — Architecture Scalabilité (10 000+ utilisateurs)

## 1. Dimensionnement cible

| Métrique | Valeur |
|----------|--------|
| Joueurs inscrits | 10 000+ |
| Joueurs actifs simultanés (pic) | 2 000 |
| Requêtes API (pic) | 500 req/s |
| Tick journalier | 10 000 joueurs en < 5 min |
| Serveurs de jeu | 8 (BDD partagée, isolation par server_id) |

## 2. Base de données — PostgreSQL

### Volumétrie estimée (10 000 joueurs, 1 an de jeu)

| Table | Lignes estimées | Taille |
|-------|----------------|--------|
| players | 10 000 | 5 MB |
| parcels | 80 000 (8/joueur) | 30 MB |
| crops (historique) | 500 000 | 100 MB |
| animals | 2 000 000 | 400 MB |
| buildings | 100 000 | 20 MB |
| vehicles | 150 000 | 30 MB |
| ledger (transactions) | 20 000 000 | 2 GB |
| notifications | 50 000 000 | 3 GB |
| **Total estimé** | | **~6 GB** |

### Configuration PostgreSQL

```ini
# postgresql.conf optimisé pour 10k joueurs
max_connections = 200
shared_buffers = 2GB            # 25% de la RAM
effective_cache_size = 6GB      # 75% de la RAM
work_mem = 16MB
maintenance_work_mem = 512MB
wal_buffers = 64MB
checkpoint_completion_target = 0.9
random_page_cost = 1.1          # SSD
effective_io_concurrency = 200  # SSD

# Connection pooling via PgBouncer (pas connexion directe)
# Mode: transaction (libère la connexion après chaque transaction)
```

### PgBouncer (obligatoire)

```ini
[pgbouncer]
pool_mode = transaction
max_client_conn = 1000
default_pool_size = 50
min_pool_size = 10
reserve_pool_size = 10
```

L'API et le worker ne se connectent JAMAIS directement à PostgreSQL. Toujours via PgBouncer.

### Index critiques

> **NOTE:** Les noms de tables suivent le DATA_MODEL (docs/02-architecture/01_DATA_MODEL.md). Adapter si le schéma évolue.

```sql
-- Les requêtes les plus fréquentes et leurs index
-- 1. "Mes parcelles" (chaque joueur, chaque connexion)
CREATE INDEX idx_parcels_player_server ON parcels(player_id, server_id) WHERE deleted_at IS NULL;

-- 2. "Mes animaux" (chaque joueur, chaque connexion)
CREATE INDEX idx_animals_player_server ON animals(player_id, server_id) WHERE deleted_at IS NULL;

-- 3. Tick journalier: tous les joueurs actifs d'un serveur
CREATE INDEX idx_players_server_active ON players(server_id) WHERE deleted_at IS NULL;

-- 4. Tick cultures: parcelles avec culture en cours
CREATE INDEX idx_crops_active ON crops(parcel_id) WHERE state IN ('sown', 'growing');

-- 5. Tick animaux: animaux vivants par joueur
CREATE INDEX idx_animals_alive ON animals(player_id) WHERE health > 0 AND deleted_at IS NULL;

-- 6. Ledger: relevé bancaire d'un joueur
CREATE INDEX idx_ledger_player_date ON ledger(player_id, created_at DESC);

-- 7. Marché: annonces actives
CREATE INDEX idx_listings_active ON listings(server_id, expires_at) WHERE status = 'active';

-- 8. Notifications non lues
CREATE INDEX idx_notifs_unread ON notifications(player_id, created_at DESC) WHERE read_at IS NULL;
```

### Partitionnement (si >50 000 joueurs)

```sql
-- Partitionner ledger par mois (table la plus volumineuse)
CREATE TABLE ledger (
    id UUID PRIMARY KEY,
    player_id UUID NOT NULL,
    amount_cents INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (created_at);

-- Partition automatique par mois
CREATE TABLE ledger_2026_01 PARTITION OF ledger
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
```

### Nettoyage automatique

```sql
-- Cron hebdomadaire: purger les données obsolètes
DELETE FROM notifications WHERE read_at IS NOT NULL AND read_at < now() - INTERVAL '30 days';
DELETE FROM listings WHERE status = 'expired' AND expires_at < now() - INTERVAL '7 days';
VACUUM ANALYZE;
```

## 3. Redis

### Dimensionnement

| Usage | Clés estimées | Mémoire |
|-------|--------------|---------|
| Sessions JWT | 10 000 | 50 MB |
| HT restants | 10 000 | 1 MB |
| Météo du jour (par zone) | 400 (8 serveurs × 50 zones) | 1 MB |
| Prix coop (cache) | 200 | 1 MB |
| Rate limiting | 2 000 (actifs) | 10 MB |
| BullMQ queues | variable | 50 MB |
| **Total** | | **~120 MB** |

### Configuration

```ini
maxmemory 512mb
maxmemory-policy allkeys-lru
```

### Patterns de cache

```typescript
// Cache-aside pattern pour toutes les lectures fréquentes
async function getPlayerPA(playerId: string): Promise<number> {
    const cached = await redis.get(`pa:${playerId}`);
    if (cached !== null) return parseInt(cached);
    
    const result = await db.query('SELECT work_hours FROM players WHERE id = $1', [playerId]);
    const pa = result.rows[0].work_hours;
    await redis.set(`pa:${playerId}`, pa, 'EX', 300); // TTL 5min
    return pa;
}

// Invalidation sur écriture
async function deductPA(playerId: string, cost: number): Promise<void> {
    await db.query('UPDATE players SET work_hours = work_hours - $1 WHERE id = $2', [cost, playerId]);
    await redis.del(`pa:${playerId}`); // Invalider le cache
}
```

## 4. API — Fastify

### Connection pool

```typescript
import { Pool } from 'pg';

const pool = new Pool({
    connectionString: process.env.DATABASE_URL, // pointe vers PgBouncer
    max: 20,           // 20 connexions par instance API
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000,
});
```

### Rate limiting

```typescript
// Global: 100 req/min par IP
fastify.register(rateLimit, {
    max: 100,
    timeWindow: '1 minute',
    keyGenerator: (req) => req.ip,
});

// Par route sensible: 10 req/min
fastify.post('/api/auth/login', {
    config: { rateLimit: { max: 10, timeWindow: '1 minute' } },
    handler: loginHandler,
});

// Par joueur authentifié: 30 req/min
fastify.addHook('onRequest', async (req) => {
    if (req.user) {
        const key = `rl:user:${req.user.id}`;
        const count = await redis.incr(key);
        if (count === 1) await redis.expire(key, 60);
        if (count > 30) throw new AppError('RATE_LIMITED', 'Trop de requêtes', 429);
    }
});
```

### Scaling horizontal

```
                    ┌─────────────┐
                    │   Nginx     │
                    │ (reverse    │
                    │  proxy +    │
                    │  SSL)       │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
        ┌─────┴─────┐ ┌───┴─────┐ ┌───┴─────┐
        │  API #1   │ │  API #2 │ │  API #3 │
        │ (Fastify) │ │         │ │         │
        └─────┬─────┘ └───┬─────┘ └───┬─────┘
              │            │            │
              └────────────┼────────────┘
                           │
                    ┌──────┴──────┐
                    │  PgBouncer  │
                    └──────┬──────┘
                           │
                    ┌──────┴──────┐
                    │ PostgreSQL  │
                    │   (8 GB)    │
                    └─────────────┘
```

- 1 instance API = 500 req/s → 3 instances = 1500 req/s (marge ×3)
- Stateless: JWT + Redis → n'importe quelle instance peut servir n'importe quel joueur
- Nginx round-robin ou least_conn

## 5. Tick journalier — Performance critique

Le tick doit traiter 10 000 joueurs en < 5 minutes.

### Architecture du tick

```typescript
async function dailyTick(serverId: number): Promise<void> {
    const BATCH_SIZE = 100;
    
    // Réf: REVIEW_FINALE I5 — Heartbeat pour maintenir le verrou tick
    const heartbeat = setInterval(async () => {
        await db.query(
            "UPDATE tick_lock SET expires_at = now() + INTERVAL '10 minutes' WHERE server_id = $1",
            [serverId]
        );
    }, 60_000); // toutes les 60s
    
    try {
    // 1. Avancer le calendrier (1 requête)
    await advanceCalendar(serverId);
    
    // 2. Reset HT (1 requête bulk)
    await db.query(
        'UPDATE players SET work_hours = $1 WHERE server_id = $2',
        [DEFAULT_HT, serverId]
    );
    
    // 3. Météo (1 requête par zone, ~50 zones)
    await generateWeather(serverId);
    
    // 4-8. Traitement par joueur (chaque joueur dans sa propre transaction)
    let offset = 0;
    const failed_player_ids: number[] = [];
    while (true) {
        const players = await db.query(
            'SELECT id FROM players WHERE server_id = $1 AND deleted_at IS NULL ORDER BY id LIMIT $2 OFFSET $3',
            [serverId, BATCH_SIZE, offset]
        );
        if (players.rows.length === 0) break;
        
        for (const player of players.rows) {
            // Chaque joueur dans sa propre transaction
            await db.query('BEGIN');
            try {
                await tickCrops(player.id);      // ~2ms/joueur
                await tickAnimals(player.id);    // ~5ms/joueur
                await tickBuildings(player.id);  // ~1ms/joueur
                await tickVehicles(player.id);   // ~1ms/joueur
                await tickEconomy(player.id);    // ~1ms/joueur
                await db.query('COMMIT');
            } catch (e) {
                await db.query('ROLLBACK');
                failed_player_ids.push(player.id);
                logger.error({ player_id: player.id, error: e }, 'Tick player failed');
            }
        }
        
        offset += BATCH_SIZE;
    }
    
    // Enregistrer les joueurs en échec dans tick_log pour retry
    if (failed_player_ids.length > 0) {
        await db.query(
            'UPDATE tick_log SET failed_player_ids = $1 WHERE server_id = $2 AND game_day = $3',
            [failed_player_ids, serverId, currentDay]
        );
    }
    } finally {
        clearInterval(heartbeat);
    }
}
```

### Budget temps

| Étape | Par joueur | 10 000 joueurs |
|-------|-----------|----------------|
| Calendrier + météo | - | 2s |
| Reset HT | - | 1s (bulk) |
| Cultures | 2ms | 20s |
| Animaux | 5ms | 50s |
| Bâtiments + matériels | 2ms | 20s |
| Économie | 1ms | 10s |
| Nettoyage | - | 5s |
| **Total** | **~10ms** | **~108s (~2 min)** |

Marge confortable: 2 min sur un budget de 5 min.

### Optimisations si nécessaire

```sql
-- Bulk update cultures au lieu de boucle
UPDATE crops SET
    growth = LEAST(growth + growth_rate, 100),
    water_gauge = water_gauge + $1,
    sun_gauge = sun_gauge + $2
WHERE state = 'growing'
AND parcel_id IN (SELECT id FROM parcels WHERE server_id = $3);
```

## 6. WebSocket (notifications temps réel)

```typescript
// Pas de polling: WebSocket pour les notifications
fastify.register(fastifyWebsocket);

fastify.get('/ws', { websocket: true }, (socket, req) => {
    const playerId = verifyWSToken(req);
    connections.set(playerId, socket);
    
    socket.on('close', () => connections.delete(playerId));
});

// Envoyer une notification en temps réel
function notifyPlayer(playerId: string, event: string, data: any) {
    const socket = connections.get(playerId);
    if (socket) socket.send(JSON.stringify({ event, data }));
}
```

Avec 2 000 connexions simultanées, une instance Fastify gère facilement (Node.js supporte 100k+ WebSocket).

## 7. Infrastructure de production

### Serveur minimum (10 000 joueurs)

| Composant | Specs | Coût estimé |
|-----------|-------|-------------|
| VPS API (×2) | 4 vCPU, 8 GB RAM | 2 × 30€/mois |
| VPS Worker | 2 vCPU, 4 GB RAM | 15€/mois |
| PostgreSQL managé | 4 vCPU, 8 GB RAM, 100 GB SSD | 50€/mois |
| Redis managé | 1 GB | 10€/mois |
| Nginx + SSL | inclus dans API VPS | - |
| Backups BDD | quotidien, rétention 30j | 10€/mois |
| **Total** | | **~145€/mois** |

### Backups

```bash
# Backup quotidien PostgreSQL (cron 04:00)
pg_dump -Fc cultivia | gzip > /backups/cultivia_$(date +%Y%m%d).dump.gz

# Rétention: 30 jours local, 90 jours S3
find /backups -name "*.dump.gz" -mtime +30 -delete
```

### Monitoring

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
  
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```

Dashboards Grafana:
- Durée tick journalier (alerte si > 5 min)
- Requêtes API/s + latence p95 (alerte si > 500ms)
- Connexions BDD actives (alerte si > 80%)
- Erreurs 5xx/min (alerte si > 10)
- Joueurs connectés en temps réel
- Mémoire Redis (alerte si > 80%)

## 8. Tests de charge

> Réf: REVIEW_FINALE R5+R6 — Scénarios k6 différenciés avec seuils par type de requête

### 8.1 Scénarios

```typescript
// k6 load test — 4 scénarios pondérés (Réf: REVIEW_FINALE R5)
import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';

export const options = {
    scenarios: {
        // Scénario 1: Lecture pure (70% du trafic)
        readers: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '2m', target: 1400 },
                { duration: '5m', target: 1400 },
                { duration: '2m', target: 0 },
            ],
            exec: 'readScenario',
        },
        // Scénario 2: Écriture (20% du trafic)
        writers: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '2m', target: 400 },
                { duration: '5m', target: 400 },
                { duration: '2m', target: 0 },
            ],
            exec: 'writeScenario',
        },
        // Scénario 3: Mixte + WebSocket (10% du trafic)
        mixed: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '2m', target: 200 },
                { duration: '5m', target: 200 },
                { duration: '2m', target: 0 },
            ],
            exec: 'mixedScenario',
        },
    },
    // Réf: REVIEW_FINALE R6 — Seuils différenciés par type
    thresholds: {
        'http_req_duration{scenario:readers}': ['p(95)<100'],    // lectures < 100ms
        'http_req_duration{scenario:writers}': ['p(95)<500'],    // écritures < 500ms
        'http_req_duration{scenario:mixed}': ['p(95)<300'],      // mixte < 300ms
        http_req_failed: ['rate<0.01'],
    },
};

// Scénario 1: Lecture pure — dashboard + parcelles + météo
export function readScenario() {
    const login = http.post('/api/auth/login', JSON.stringify({
        email: `player${__VU}@test.com`, password: 'test123',
    }));
    const headers = { Authorization: `Bearer ${login.json('accessToken')}` };

    group('dashboard', () => {
        check(http.get('/api/player/me', { headers }), { '200': (r) => r.status === 200 });
        check(http.get('/api/parcels', { headers }), { '200': (r) => r.status === 200 });
        check(http.get('/api/weather', { headers }), { '200': (r) => r.status === 200 });
        check(http.get('/api/bank/summary?period_days=7', { headers }), { '200': (r) => r.status === 200 });
    });
    sleep(randomIntBetween(2, 5));
}

// Scénario 2: Écriture — acheter parcelle + semer
export function writeScenario() {
    const login = http.post('/api/auth/login', JSON.stringify({
        email: `writer${__VU}@test.com`, password: 'test123',
    }));
    const headers = {
        Authorization: `Bearer ${login.json('accessToken')}`,
        'X-Idempotency-Key': `${__VU}-${__ITER}-${Date.now()}`,
    };

    group('write_actions', () => {
        const buy = http.post('/api/parcels/buy', JSON.stringify({
            prefecture_id: randomIntBetween(1, 100), type: 'field', area_m2: 10000,
        }), { headers });
        check(buy, { 'buy 201': (r) => r.status === 201 });

        if (buy.status === 201) {
            const parcelId = buy.json('id');
            sleep(1.5); // délai anti-bot
            http.post(`/api/parcels/${parcelId}/sow`, JSON.stringify({
                crop_type: 'wheat', seed_type: 'GP',
            }), { headers: { ...headers, 'X-Idempotency-Key': `${__VU}-sow-${Date.now()}` } });
        }
    });
    sleep(randomIntBetween(3, 8));
}

// Scénario 3: Mixte — lecture + écriture + WebSocket
export function mixedScenario() {
    const login = http.post('/api/auth/login', JSON.stringify({
        email: `mixed${__VU}@test.com`, password: 'test123',
    }));
    const headers = { Authorization: `Bearer ${login.json('accessToken')}` };

    group('mixed', () => {
        http.get('/api/player/me', { headers });
        http.get('/api/parcels', { headers });
        sleep(1.5);
        http.post('/api/hvc/buy', JSON.stringify({ liters: 100 }), {
            headers: { ...headers, 'X-Idempotency-Key': `${__VU}-hvc-${Date.now()}` },
        });
        http.get('/api/notifications?limit=5&unread_only=true', { headers });
    });
    sleep(randomIntBetween(2, 6));
}
```

### 8.2 Scénario tick concurrent

```typescript
// Lancer le tick pendant le test de charge pour vérifier l'impact
// Exécuté manuellement ou via un scénario k6 séparé
// POST /admin/trigger-tick (endpoint admin protégé)
```

### 8.3 Critères de validation

| Type | Seuil p95 | Justification |
|------|-----------|---------------|
| Lectures (GET) | < 100ms | Pas de lock BDD, cache Redis |
| Écritures (POST) | < 500ms | SELECT FOR UPDATE, transactions |
| Mixte | < 300ms | Moyenne pondérée |
| Tick concurrent | Pas d'impact > +50ms sur les lectures | Le tick ne doit pas bloquer l'API |

- 0 erreur 5xx sous charge normale
- Tick journalier < 5 min avec 10 000 joueurs
- WebSocket stable avec 2000 connexions


---

## Addendum performance (Réf: Review R9)

### Tick parallélisé
Le tick journalier traite les joueurs par batch de 100 (pas en séquence) :
```
SELECT id FROM player WHERE is_active ORDER BY id
→ batch 1: players 1-100 (1 transaction par joueur)
→ batch 2: players 101-200
→ ...
→ Parallélisme : 5 batches simultanés (5 connexions worker pool)
```
Objectif : 10 000 joueurs en < 5 minutes.

### Cache Redis
| Donnée | TTL | Clé |
|--------|-----|-----|
| Cours marché | 60s | `cache:market_prices` |
| Météo par zone | 60s | `cache:weather:{zone_id}` |
| Classements | 300s | `cache:rankings:{type}` |
| Profil joueur public | 60s | `cache:player:{id}:public` |

Le cache est invalidé par le worker après chaque tick.
