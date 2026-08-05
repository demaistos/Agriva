# PHASE 0 — INFRASTRUCTURE — Spécifications Techniques

> **Cultivia Clone — Specs détaillées pour développement**
> Chaque feature est spécifiée pour être codée sans ambiguïté.
> Référence : 01_DATA_MODEL.md, 02_GAME_SYSTEMS.md, 04_PRODUCT_ROADMAP.md

---

## Table des matières

1. [Feature 1 — Authentification](#feature-1--authentification)
2. [Feature 2 — Système de serveurs de jeu](#feature-2--système-de-serveurs-de-jeu)
3. [Feature 3 — Moteur de temps](#feature-3--moteur-de-temps)
4. [Feature 4 — Système de Heures de Travail](#feature-4--système-de-points-daction)
5. [Feature 5 — Économie de base](#feature-5--économie-de-base)
6. [Feature 6 — Cantons](#feature-6--zones-géographiques)
7. [Feature 7 — Notifications in-app](#feature-7--notifications-in-app)

---

## Feature 1 — Authentification

### 1.1 Description

Système d'inscription, connexion et gestion de profil joueur. Un utilisateur crée un compte global (email + mot de passe), puis rejoint un ou plusieurs serveurs de jeu. Sur chaque serveur, il possède un profil joueur distinct (username, solde, HT, ferme). L'authentification utilise JWT avec refresh token rotation pour maintenir des sessions stateless côté API.

**Pourquoi** : C'est le point d'entrée obligatoire. Sans auth, aucune autre feature ne fonctionne. L'isolation par serveur est fondamentale pour l'économie du jeu.

### 1.2 Schéma BDD

```sql
-- Compte global (cross-serveur)
CREATE TABLE account (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email           VARCHAR(255) NOT NULL UNIQUE,
  password_hash   VARCHAR(255) NOT NULL,
  email_verified  BOOLEAN NOT NULL DEFAULT false,
  verification_token UUID,
  verification_expires_at TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_account_email ON account(email);
CREATE INDEX idx_account_verification_token ON account(verification_token) WHERE verification_token IS NOT NULL;

-- Profil joueur par serveur
CREATE TABLE player (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id      UUID NOT NULL REFERENCES account(id) ON DELETE CASCADE,
  server_id       INT NOT NULL REFERENCES server(id),
  username        VARCHAR(50) NOT NULL,
  avatar_url      VARCHAR(500),
  balance         DECIMAL(14,2) NOT NULL DEFAULT 100000.00,
  ht_today        DECIMAL(6,2) NOT NULL DEFAULT 40.00,
  ht_max          DECIMAL(6,2) NOT NULL DEFAULT 40.00,
  seniority_days  INT NOT NULL DEFAULT 0,
  is_online       BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_login      TIMESTAMPTZ,
  UNIQUE(account_id, server_id),  -- 1 seul profil par compte par serveur
  UNIQUE(server_id, username)     -- username unique par serveur
);
CREATE INDEX idx_player_account ON player(account_id);
CREATE INDEX idx_player_server ON player(server_id);

-- Refresh tokens (rotation)
CREATE TABLE refresh_token (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id  UUID NOT NULL REFERENCES account(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL UNIQUE,
  family_id   UUID NOT NULL,  -- pour détecter le vol de token
  expires_at  TIMESTAMPTZ NOT NULL,
  revoked_at  TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_refresh_token_account ON refresh_token(account_id);
CREATE INDEX idx_refresh_token_family ON refresh_token(family_id);
CREATE INDEX idx_refresh_token_expires ON refresh_token(expires_at) WHERE revoked_at IS NULL;
```

### 1.3 Logique métier

```
// ─── INSCRIPTION ───
function register(email, password, username, server_id):
    // Validations
    ASSERT email matches /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    ASSERT password.length >= 8
    ASSERT password contient au moins 1 majuscule, 1 minuscule, 1 chiffre
    ASSERT username.length BETWEEN 3 AND 50
    ASSERT username matches /^[a-zA-Z0-9_-]+$/  // alphanum + _ -
    ASSERT server_id EXISTS in server table
    ASSERT NOT EXISTS account WHERE email = email
    ASSERT NOT EXISTS player WHERE server_id = server_id AND username = username

    hash = bcrypt(password, rounds=12)
    verification_token = uuid_v4()

    BEGIN TRANSACTION
      account = INSERT INTO account (email, password_hash, verification_token, verification_expires_at)
                VALUES (email, hash, verification_token, now() + INTERVAL '24 hours')
      player = INSERT INTO player (account_id, server_id, username, balance)
               VALUES (account.id, server_id, username, 100000.00)
      INSERT INTO bank_account (player_id, type, balance)
               VALUES (player.id, 'main', 100000.00)
    COMMIT

    sendVerificationEmail(email, verification_token)
    RETURN { account_id, player_id, message: "Vérifiez votre email" }

// ─── VÉRIFICATION EMAIL ───
function verifyEmail(token):
    account = SELECT * FROM account WHERE verification_token = token
    ASSERT account EXISTS                          → 404
    ASSERT account.verification_expires_at > now() → 410 GONE (expiré)
    ASSERT account.email_verified = false          → 409 (déjà vérifié)

    UPDATE account SET email_verified = true,
                       verification_token = NULL,
                       verification_expires_at = NULL
    RETURN { success: true }

// ─── CONNEXION ───
function login(email, password, server_id):
    account = SELECT * FROM account WHERE email = email
    ASSERT account EXISTS                          → 401
    ASSERT bcrypt.verify(password, account.password_hash) → 401
    ASSERT account.email_verified = true           → 403 "Email non vérifié"

    player = SELECT * FROM player WHERE account_id = account.id AND server_id = server_id
    ASSERT player EXISTS                           → 404 "Pas de profil sur ce serveur"

    UPDATE player SET is_online = true, last_login = now()

    access_token = signJWT({
      sub: account.id,
      player_id: player.id,
      server_id: server_id,
      username: player.username
    }, expires_in: 15min)

    family_id = uuid_v4()
    refresh = generateRefreshToken(account.id, family_id, expires_in: 7days)

    RETURN {
      access_token,
      refresh_token: refresh.plain_token,
      player: { id, username, balance, ht_today, server_id }
    }

// ─── REFRESH TOKEN ───
function refreshAccessToken(refresh_token_plain):
    token_hash = sha256(refresh_token_plain)
    stored = SELECT * FROM refresh_token WHERE token_hash = token_hash
    ASSERT stored EXISTS                           → 401
    ASSERT stored.revoked_at IS NULL               → 401

    // Vérifier expiration
    ASSERT stored.expires_at > now()               → 401

    // Rotation : révoquer l'ancien, créer un nouveau dans la même famille
    // Si le token est déjà révoqué → vol détecté → révoquer toute la famille
    BEGIN TRANSACTION
      UPDATE refresh_token SET revoked_at = now() WHERE id = stored.id
      new_refresh = generateRefreshToken(stored.account_id, stored.family_id, 7days)
    COMMIT

    new_access = signJWT(...)  // même payload
    RETURN { access_token: new_access, refresh_token: new_refresh.plain_token }

// ─── DÉTECTION VOL DE TOKEN ───
function detectTokenTheft(family_id):
    // Si un refresh token déjà révoqué est réutilisé :
    UPDATE refresh_token SET revoked_at = now()
           WHERE family_id = family_id AND revoked_at IS NULL
    // → Force la reconnexion de l'utilisateur légitime

// ─── DÉCONNEXION ───
function logout(account_id, refresh_token_plain):
    token_hash = sha256(refresh_token_plain)
    UPDATE refresh_token SET revoked_at = now() WHERE token_hash = token_hash
    UPDATE player SET is_online = false WHERE account_id = account_id

// ─── REJOINDRE UN SERVEUR ───
function joinServer(account_id, server_id, username):
    ASSERT account.email_verified = true
    ASSERT NOT EXISTS player WHERE account_id = account_id AND server_id = server_id → 409
    ASSERT NOT EXISTS player WHERE server_id = server_id AND username = username → 409

    BEGIN TRANSACTION
      player = INSERT INTO player (account_id, server_id, username, balance)
               VALUES (account_id, server_id, username, 100000.00)
      INSERT INTO bank_account (player_id, type, balance)
               VALUES (player.id, 'main', 100000.00)
    COMMIT
    RETURN player
```

### 1.4 API Endpoints

#### POST `/api/auth/register`

```
Request:
{
  "email": "joueur@example.com",
  "password": "MonMotDePasse1",
  "username": "fermier42",
  "server_id": 1
}

Response 201:
{
  "account_id": "uuid",
  "player_id": 1,
  "message": "Un email de vérification a été envoyé"
}

Erreurs:
  400 — Validation échouée (email invalide, password trop faible, username invalide)
  409 — Email déjà utilisé OU username déjà pris sur ce serveur
  404 — server_id inexistant
```

#### POST `/api/auth/verify-email`

```
Request:
{
  "token": "uuid-verification-token"
}

Response 200:
{ "success": true }

Erreurs:
  404 — Token inconnu
  410 — Token expiré
  409 — Email déjà vérifié
```

#### POST `/api/auth/login`

```
Request:
{
  "email": "joueur@example.com",
  "password": "MonMotDePasse1",
  "server_id": 1
}

Response 200:
{
  "access_token": "eyJhbG...",
  "refresh_token": "random-string",
  "player": {
    "id": 1,
    "username": "fermier42",
    "balance": 100000.00,
    "ht_today": 35.00,
    "server_id": 1
  }
}

Erreurs:
  401 — Email ou mot de passe incorrect
  403 — Email non vérifié
  404 — Pas de profil joueur sur ce serveur
```

#### POST `/api/auth/refresh`

```
Request:
{
  "refresh_token": "random-string"
}

Response 200:
{
  "access_token": "eyJhbG...",
  "refresh_token": "new-random-string"
}

Erreurs:
  401 — Token invalide, expiré ou révoqué
```

#### POST `/api/auth/logout`

```
Headers: Authorization: Bearer <access_token>
Request:
{
  "refresh_token": "random-string"
}

Response 204: (no content)
```

#### POST `/api/auth/join-server`

```
Headers: Authorization: Bearer <access_token>
Request:
{
  "server_id": 2,
  "username": "fermier42_be"
}

Response 201:
{
  "player_id": 15,
  "server_id": 2,
  "username": "fermier42_be",
  "balance": 100000.00
}

Erreurs:
  403 — Email non vérifié
  409 — Déjà inscrit sur ce serveur OU username pris
```

#### GET `/api/player/me`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "id": 1,
  "username": "fermier42",
  "email": "joueur@example.com",
  "balance": 100000.00,
  "ht_today": 35.00,
  "ht_max": 35.00,
  "seniority_days": 0,
  "server_id": 1,
  "is_online": true,
  "created_at": "2026-04-04T10:00:00Z",
  "last_login": "2026-04-04T20:00:00Z"
}
```

#### PATCH `/api/player/me`

```
Headers: Authorization: Bearer <access_token>
Request:
{
  "username": "nouveau_nom",
  "avatar_url": "https://..."
}

Response 200:
{ "id": 1, "username": "nouveau_nom", "avatar_url": "https://..." }

Erreurs:
  400 — Validation échouée
  409 — Username déjà pris
```

### 1.5 Tests

**Tests unitaires :**
- `register` — email valide, password fort, username valide → succès
- `register` — email invalide → 400
- `register` — password < 8 chars → 400
- `register` — password sans majuscule → 400
- `register` — username < 3 chars → 400
- `register` — username avec caractères spéciaux interdits → 400
- `register` — email déjà existant → 409
- `register` — username déjà pris sur le même serveur → 409
- `register` — même email, serveur différent → succès (via join-server)
- `verifyEmail` — token valide → succès
- `verifyEmail` — token expiré (>24h) → 410
- `verifyEmail` — token inconnu → 404
- `verifyEmail` — déjà vérifié → 409
- `login` — credentials corrects → JWT + refresh token
- `login` — email inconnu → 401
- `login` — mauvais password → 401
- `login` — email non vérifié → 403
- `login` — pas de profil sur le serveur demandé → 404
- `refreshToken` — token valide → nouveau access + refresh
- `refreshToken` — token expiré → 401
- `refreshToken` — token déjà révoqué → 401 + révocation famille entière
- `logout` — révoque le refresh token
- `joinServer` — nouveau serveur → succès avec solde 100000
- `joinServer` — déjà inscrit sur ce serveur → 409
- Vérifier que le password_hash est bien bcrypt (pas de stockage en clair)
- Vérifier que le JWT contient sub, player_id, server_id, exp

**Tests d'intégration :**
- Flux complet : register → verify email → login → get profile → logout
- Flux multi-serveur : register sur FR1 → join FR2 → login FR1 → login FR2 (profils distincts)
- Refresh token rotation : login → refresh → ancien token invalide
- Détection vol : login → refresh → réutiliser ancien refresh → toute la famille révoquée
- Expiration JWT : attendre 15min → requête → 401 → refresh → succès
- Nettoyage : refresh tokens expirés supprimés par job

### 1.6 Diagrammes

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API
    participant DB as PostgreSQL
    participant Mail as Email Service

    Note over C,Mail: INSCRIPTION
    C->>API: POST /auth/register {email, password, username, server_id}
    API->>DB: Vérifier unicité email + username
    API->>DB: INSERT account + player + bank_account
    API->>Mail: Envoyer email vérification (token)
    API-->>C: 201 {account_id, player_id}

    Note over C,Mail: VÉRIFICATION EMAIL
    C->>API: POST /auth/verify-email {token}
    API->>DB: UPDATE account SET email_verified=true
    API-->>C: 200 {success}

    Note over C,Mail: CONNEXION
    C->>API: POST /auth/login {email, password, server_id}
    API->>DB: SELECT account + player
    API->>API: Vérifier bcrypt + email_verified
    API->>DB: INSERT refresh_token
    API-->>C: 200 {access_token, refresh_token, player}

    Note over C,Mail: REFRESH
    C->>API: POST /auth/refresh {refresh_token}
    API->>DB: Vérifier + révoquer ancien token
    API->>DB: INSERT nouveau refresh_token (même family)
    API-->>C: 200 {access_token, refresh_token}
```

```mermaid
stateDiagram-v2
    [*] --> NonVerifie: POST /register
    NonVerifie --> Verifie: POST /verify-email
    NonVerifie --> NonVerifie: Token expiré → renvoyer
    Verifie --> Connecte: POST /login
    Connecte --> Deconnecte: POST /logout
    Deconnecte --> Connecte: POST /login
    Connecte --> Connecte: POST /refresh (rotation token)
```

---

## Feature 2 — Système de serveurs de jeu

### 2.1 Description

Le jeu fonctionne sur 1 serveur France (normal). Chaque serveur est un monde isolé avec sa propre économie, ses propres joueurs et son propre calendrier. Aucun transfert d'argent, de matériel ou d'animaux n'est possible entre serveurs. Un joueur peut avoir un profil sur chaque serveur (même email, username différent). Le serveur Maîtrise a des règles spécifiques (PA doublés, prix parcelles différents).

**Serveurs prévus** : France (serveur unique au lancement).

**Pourquoi** : L'isolation par serveur permet des économies indépendantes, des communautés de taille gérable, et des variantes de gameplay (Expert). C'est un pilier du game design hérité de Cultivia.

### 2.2 Schéma BDD

```sql
CREATE TABLE server (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(50) NOT NULL UNIQUE,
  slug          VARCHAR(20) NOT NULL UNIQUE,   -- 'fr1','fr2','be','ch','ca','us','expert'
  country       VARCHAR(10) NOT NULL,           -- FR, BE, CH, CA, US, EX
  difficulty    SMALLINT NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
  price_per_ha  DECIMAL(10,2) NOT NULL,         -- prix base hectare (3000-7000)
  max_parcel_ha SMALLINT NOT NULL DEFAULT 100,  -- 200 pour CA/US
  ht_base       DECIMAL(6,2) NOT NULL DEFAULT 40.00, -- 70 pour Expert
  starting_balance DECIMAL(14,2) NOT NULL DEFAULT 100000.00,
  current_day   INT NOT NULL DEFAULT 1,         -- jour Cultivia courant (1-84 par an)
  current_month SMALLINT NOT NULL DEFAULT 3,    -- mois Cultivia (1-12)
  current_season VARCHAR(10) NOT NULL DEFAULT 'spring',
  current_year  INT NOT NULL DEFAULT 1,         -- année Cultivia
  is_active     BOOLEAN NOT NULL DEFAULT true,
  max_players   INT NOT NULL DEFAULT 5000,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Données de seed des 8 serveurs
-- INSERT INTO server (name, slug, country, difficulty, price_per_ha, max_parcel_ha, ht_base) VALUES
-- ('France', 'fr', 'FR', 2, 4500, 100, 40),
-- ('Aubrac',  'fr2',    'FR', 2, 4000, 100, 35),
-- ('France 3',  'fr3',    'FR', 2, 4000, 100, 35),
-- ('Belgique',  'be',     'BE', 3, 5000, 100, 35),
-- ('Suisse',    'ch',     'CH', 3, 6000, 100, 35),
-- ('Canada',    'ca',     'CA', 2, 3000, 200, 35),
-- ('USA',       'us',     'US', 2, 3000, 200, 35),
-- ('Expert',    'expert', 'EX', 5, 7000, 100, 70);
```

### 2.3 Logique métier

```
// ─── LISTER LES SERVEURS ───
function listServers():
    RETURN SELECT id, name, slug, country, difficulty, current_season,
                  current_day, current_year, is_active,
                  (SELECT COUNT(*) FROM player WHERE server_id = server.id) AS player_count,
                  max_players
           FROM server
           WHERE is_active = true
           ORDER BY id

// ─── DÉTAIL D'UN SERVEUR ───
function getServer(server_id):
    server = SELECT * FROM server WHERE id = server_id
    ASSERT server EXISTS → 404
    RETURN server enrichi avec :
      - player_count (nombre de joueurs inscrits)
      - online_count (nombre de joueurs en ligne)

// ─── VÉRIFIER CAPACITÉ ───
function canJoinServer(server_id):
    server = SELECT * FROM server WHERE id = server_id
    ASSERT server.is_active = true → 403 "Serveur fermé"
    player_count = SELECT COUNT(*) FROM player WHERE server_id = server_id
    ASSERT player_count < server.max_players → 403 "Serveur plein"
    RETURN true

// ─── RÈGLES SPÉCIFIQUES PAR SERVEUR ───
// Le serveur Maîtrise a :
//   - ht_base = 70 (couple d'agriculteurs)
//   - difficulty = 5
//   - price_per_ha = 7000
//   - Pas de tutoriel
// Les serveurs CA/US ont :
//   - max_parcel_ha = 200 (grandes exploitations)
//   - price_per_ha = 3000
```

### 2.4 API Endpoints

#### GET `/api/servers`

```
Response 200:
{
  "servers": [
    {
      "id": 1,
      "name": "France",
      "slug": "fr1",
      "country": "FR",
      "difficulty": 2,
      "current_season": "spring",
      "current_day": 25,
      "current_year": 1,
      "player_count": 342,
      "max_players": 5000,
      "is_active": true
    },
    ...
  ]
}
```

#### GET `/api/servers/:id`

```
Response 200:
{
  "id": 1,
  "name": "France",
  "slug": "fr1",
  "country": "FR",
  "difficulty": 2,
  "price_per_ha": 4000.00,
  "max_parcel_ha": 100,
  "ht_base": 40.00,
  "current_day": 25,
  "current_month": 4,
  "current_season": "spring",
  "current_year": 1,
  "player_count": 342,
  "online_count": 47,
  "is_active": true
}

Erreurs:
  404 — Serveur inexistant
```

### 2.5 Tests

**Tests unitaires :**
- `listServers` — retourne les 8 serveurs actifs
- `listServers` — serveur inactif non retourné
- `getServer` — id valide → détails complets
- `getServer` — id inexistant → 404
- `canJoinServer` — serveur actif avec places → true
- `canJoinServer` — serveur plein → 403
- `canJoinServer` — serveur inactif → 403
- Vérifier que le serveur Maîtrise a ht_base=70
- Vérifier que les serveurs CA/US ont max_parcel_ha=200

**Tests d'intégration :**
- Inscription sur FR1 → vérifier balance=100000, ht_max=40
- Inscription sur Expert → vérifier ht_max=70
- Inscription sur serveur plein → 403
- Même compte, 2 serveurs différents → 2 profils joueur distincts

### 2.6 Diagramme

```mermaid
graph TD
    A[Client] --> LB[Load Balancer / API Gateway]
    LB --> API[API Stateless]
    API --> PG_FR1[(PostgreSQL<br/>Schema: fr1)]
    API --> PG_FR2[(PostgreSQL<br/>Schema: fr2)]
    API --> PG_FR3[(PostgreSQL<br/>Schema: fr3)]
    API --> PG_BE[(PostgreSQL<br/>Schema: be)]
    API --> PG_CH[(PostgreSQL<br/>Schema: ch)]
    API --> PG_CA[(PostgreSQL<br/>Schema: ca)]
    API --> PG_US[(PostgreSQL<br/>Schema: us)]
    API --> PG_EX[(PostgreSQL<br/>Schema: expert)]
    API --> REDIS[Redis<br/>Sessions + Cache<br/>1 namespace/serveur]

    style API fill:#4CAF50,color:white
    style REDIS fill:#DC3545,color:white
```

> **Note d'architecture** : Chaque serveur de jeu correspond à un schema PostgreSQL séparé (ou une base séparée). La table `account` est dans un schema `global` partagé. La table `server` est aussi dans `global`. Les tables `player`, `bank_account`, `transaction`, etc. sont dupliquées dans chaque schema serveur. L'API détermine le schema cible via le `server_id` du JWT.

---

## Feature 3 — Moteur de temps

### 3.1 Description

Le moteur de temps est le cœur du jeu. Il fait avancer le monde de jeu chaque jour à minuit UTC via un cron job (le "daily tick"). Le mapping temporel est : 1 jour réel = 1 jour Cultivia, 7 jours réels = 1 mois Cultivia, 84 jours réels = 1 an Cultivia. Le tick gère l'avancement du calendrier, le changement de saisons, et orchestre tous les systèmes dépendants (PA reset, économie mensuelle, etc.).

**Pourquoi** : Sans le tick, le monde est statique. C'est le métronome qui rythme toute la simulation. L'ordre d'exécution des étapes du tick est critique pour la cohérence des données.

### 3.2 Schéma BDD

```sql
-- La table server contient déjà current_day, current_month, current_season, current_year
-- (voir Feature 2)

-- Log d'exécution du tick (audit + debug)
CREATE TABLE tick_log (
  id          BIGSERIAL PRIMARY KEY,
  server_id   INT NOT NULL REFERENCES server(id),
  game_day    INT NOT NULL,
  game_month  SMALLINT NOT NULL,
  game_season VARCHAR(10) NOT NULL,
  game_year   INT NOT NULL,
  started_at  TIMESTAMPTZ NOT NULL,
  finished_at TIMESTAMPTZ,
  status      VARCHAR(20) NOT NULL DEFAULT 'running', -- 'running','completed','failed'
  error_message TEXT,
  steps_completed JSONB DEFAULT '[]',  -- ["advance_date","reset_pa","weather",...]
  duration_ms INT,
  UNIQUE(server_id, game_day, game_year)
);
CREATE INDEX idx_tick_log_server ON tick_log(server_id, started_at DESC);

-- Verrou pour empêcher les ticks concurrents
CREATE TABLE tick_lock (
  server_id   INT PRIMARY KEY REFERENCES server(id),
  locked_at   TIMESTAMPTZ,
  locked_by   VARCHAR(100),  -- identifiant du worker
  expires_at  TIMESTAMPTZ    -- auto-release après 5 min
);
```

### 3.3 Logique métier

```
// ─── CONSTANTES TEMPORELLES ───
DAYS_PER_MONTH  = 7       // 1 semaine réelle = 1 mois Cultivia
MONTHS_PER_SEASON = 3
DAYS_PER_SEASON = 21      // 3 semaines réelles
MONTHS_PER_YEAR = 12
DAYS_PER_YEAR   = 84      // 15 semaines réelles

SEASON_MAP = {
  1: 'winter',   2: 'winter',   3: 'winter',    // Déc, Jan, Fév
  4: 'spring',   5: 'spring',   6: 'spring',    // Mar, Avr, Mai
  7: 'summer',   8: 'summer',   9: 'summer',    // Jun, Jul, Aoû
  10: 'autumn',  11: 'autumn',  12: 'autumn'    // Sep, Oct, Nov
}

MONTH_NAMES = {
  1: 'Décembre', 2: 'Janvier', 3: 'Février',
  4: 'Mars',     5: 'Avril',   6: 'Mai',
  7: 'Juin',     8: 'Juillet', 9: 'Août',
  10: 'Septembre', 11: 'Octobre', 12: 'Novembre'
}

// ─── CALCULS TEMPORELS ───
function getMonthFromDay(day_of_year: int) -> int:
    // day_of_year: 1-84
    RETURN ceil(day_of_year / DAYS_PER_MONTH)  // 1-12

function getSeasonFromMonth(month: int) -> string:
    RETURN SEASON_MAP[month]

function getDayOfMonth(day_of_year: int) -> int:
    // Jour dans le mois (1-7, correspond à lundi-dimanche)
    RETURN ((day_of_year - 1) % DAYS_PER_MONTH) + 1

function isFirstDayOfMonth(day_of_year: int) -> bool:
    RETURN getDayOfMonth(day_of_year) == 1

function isFirstDayOfSeason(day_of_year: int, month: int) -> bool:
    RETURN isFirstDayOfMonth(day_of_year) AND month IN (1, 4, 7, 10)

function isLastDayOfYear(day_of_year: int) -> bool:
    RETURN day_of_year == DAYS_PER_YEAR

// ─── DAILY TICK (CRON 00:00 UTC) ───
function dailyTick(server_id):
    // 1. Acquérir le verrou
    lock = acquireTickLock(server_id)
    IF NOT lock: LOG "Tick déjà en cours pour server_id"; RETURN

    // Réf: REVIEW_FINALE I5 — Démarrer le heartbeat
    heartbeatId = startTickHeartbeat(server_id)

    server = SELECT * FROM server WHERE id = server_id
    tick_log = INSERT INTO tick_log (server_id, game_day, game_month, game_season, game_year, started_at)
               VALUES (server_id, server.current_day, server.current_month, server.current_season, server.current_year, now())

    TRY:
        // 2. Avancer la date
        new_day = server.current_day + 1
        new_month = server.current_month
        new_season = server.current_season
        new_year = server.current_year

        IF new_day > DAYS_PER_YEAR:
            new_day = 1
            new_year = new_year + 1

        new_month = getMonthFromDay(new_day)
        new_season = getSeasonFromMonth(new_month)

        month_changed = (new_month != server.current_month)
        season_changed = (new_season != server.current_season)
        year_changed = (new_year != server.current_year)

        UPDATE server SET
            current_day = new_day,
            current_month = new_month,
            current_season = new_season,
            current_year = new_year
        WHERE id = server_id

        logStep(tick_log, 'advance_date')

        // 3. Reset HT joueurs (AVANT toute action consommant des HT)
        UPDATE player SET ht_today = ht_max WHERE server_id = server_id
        logStep(tick_log, 'reset_pa')

        // 4. Incrémenter ancienneté joueurs
        UPDATE player SET seniority_days = seniority_days + 1
               WHERE server_id = server_id
        logStep(tick_log, 'seniority')

        // 5. Traitements mensuels (si 1er du mois = jour 1, 8, 15, 22, ...)
        IF isFirstDayOfMonth(new_day):
            processMonthlyEconomy(server_id)  // → Feature 5
            logStep(tick_log, 'monthly_economy')

        // 6. Traitements saisonniers
        IF season_changed:
            processSeasonChange(server_id, new_season)
            logStep(tick_log, 'season_change')

        // 7. Traitements annuels
        IF year_changed:
            processYearEnd(server_id)
            logStep(tick_log, 'year_end')

        // 8. Marquer le tick comme terminé
        UPDATE tick_log SET
            status = 'completed',
            finished_at = now(),
            duration_ms = EXTRACT(EPOCH FROM (now() - tick_log.started_at)) * 1000
        WHERE id = tick_log.id

    CATCH error:
        UPDATE tick_log SET status = 'failed', error_message = error.message, finished_at = now()
        WHERE id = tick_log.id
        ALERT_ADMIN("Tick failed for server " + server_id + ": " + error.message)

    FINALLY:
        stopTickHeartbeat(heartbeatId)
        releaseTickLock(server_id)

// ─── VERROU TICK ───
function acquireTickLock(server_id) -> bool:
    // Réf: REVIEW_FINALE I5 — Expiration 10 min (marge ×2 sur budget 5 min)
    result = UPDATE tick_lock
             SET locked_at = now(), locked_by = WORKER_ID, expires_at = now() + INTERVAL '10 minutes'
             WHERE server_id = server_id
             AND (locked_at IS NULL OR expires_at < now())
    RETURN result.rowCount == 1

function releaseTickLock(server_id):
    UPDATE tick_lock SET locked_at = NULL, locked_by = NULL, expires_at = NULL
           WHERE server_id = server_id

// ─── HEARTBEAT TICK (Réf: REVIEW_FINALE I5) ───
// Le worker met à jour expires_at toutes les 60s pendant le tick
// pour empêcher l'expiration du verrou si le tick est long
function startTickHeartbeat(server_id) -> intervalId:
    RETURN setInterval(() => {
        UPDATE tick_lock SET expires_at = now() + INTERVAL '10 minutes'
               WHERE server_id = server_id AND locked_by = WORKER_ID
    }, 60_000)  // toutes les 60 secondes

function stopTickHeartbeat(intervalId):
    clearInterval(intervalId)

// ─── ORCHESTRATION MULTI-SERVEUR ───
// Le cron lance le tick pour chaque serveur actif en parallèle (ou séquentiel)
function dailyTickAll():
    servers = SELECT id FROM server WHERE is_active = true
    FOR EACH server IN servers:
        // Lancer en parallèle (BullMQ job par serveur)
        enqueueJob('daily_tick', { server_id: server.id })
```

### 3.4 API Endpoints

#### GET `/api/time`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "server_id": 1,
  "current_day": 25,
  "day_of_month": 4,
  "current_month": 4,
  "month_name": "Mars",
  "current_season": "spring",
  "current_year": 1,
  "days_per_month": 7,
  "days_per_year": 84,
  "is_first_day_of_month": false,
  "next_tick_utc": "2026-04-05T00:00:00Z"
}
```

#### GET `/api/time/tick-history`  *(admin only)*

```
Headers: Authorization: Bearer <access_token>
Query: ?server_id=1&limit=10

Response 200:
{
  "ticks": [
    {
      "game_day": 25,
      "game_month": 4,
      "game_season": "spring",
      "game_year": 1,
      "status": "completed",
      "duration_ms": 1234,
      "started_at": "2026-04-04T00:00:00Z",
      "steps_completed": ["advance_date","reset_pa","seniority"]
    }
  ]
}
```

### 3.5 Tests

**Tests unitaires :**
- `getMonthFromDay(1)` → 1 (Décembre)
- `getMonthFromDay(7)` → 1
- `getMonthFromDay(8)` → 2 (Janvier)
- `getMonthFromDay(22)` → 4 (Mars)
- `getMonthFromDay(84)` → 12 (Novembre)
- `getSeasonFromMonth(1)` → 'winter'
- `getSeasonFromMonth(4)` → 'spring'
- `getSeasonFromMonth(7)` → 'summer'
- `getSeasonFromMonth(10)` → 'autumn'
- `getDayOfMonth(1)` → 1
- `getDayOfMonth(7)` → 7
- `getDayOfMonth(8)` → 1
- `isFirstDayOfMonth(1)` → true
- `isFirstDayOfMonth(8)` → true
- `isFirstDayOfMonth(5)` → false
- `isLastDayOfYear(84)` → true
- `isLastDayOfYear(83)` → false
- Transition jour 84 → jour 1, year+1
- Transition mois : jour 7 (mois 1) → jour 8 (mois 2)
- Transition saison : mois 3→4 = winter→spring
- Transition année : jour 84 year 1 → jour 1 year 2

**Tests d'intégration :**
- Exécuter dailyTick → current_day incrémenté de 1
- Exécuter dailyTick au jour 84 → rollover à jour 1, year+1
- Exécuter dailyTick → tous les HT joueurs reset à ht_max
- Exécuter dailyTick au jour 8 (1er du mois 2) → traitements mensuels déclenchés
- Exécuter dailyTick → tick_log créé avec status 'completed'
- Double tick simultané → le 2e échoue (verrou)
- Tick échoué → tick_log status='failed', error_message renseigné
- Tick échoué → verrou libéré (pas de deadlock)
- Vérifier que seniority_days s'incrémente chaque tick

### 3.6 Diagramme

```mermaid
sequenceDiagram
    participant CRON as Cron (00:00 UTC)
    participant Q as BullMQ
    participant W as Worker
    participant DB as PostgreSQL
    participant R as Redis

    CRON->>Q: Enqueue daily_tick pour chaque serveur actif
    Q->>W: Process job {server_id: 1}
    W->>DB: Acquire tick_lock (UPDATE conditionnel)
    alt Lock acquis
        W->>DB: INSERT tick_log (status=running)
        W->>DB: UPDATE server SET current_day++
        W->>DB: UPDATE player SET ht_today = ht_max
        W->>DB: UPDATE player SET seniority_days++
        opt 1er du mois
            W->>DB: Process monthly economy
        end
        W->>DB: UPDATE tick_log SET status=completed
        W->>R: PUBLISH server:1:tick {day, month, season}
        W->>DB: Release tick_lock
    else Lock non acquis
        W->>W: Skip (tick déjà en cours)
    end
```

```mermaid
graph LR
    subgraph "Année Cultivia (84 jours réels)"
        subgraph "Hiver (21j)"
            D[Déc<br/>J1-7] --> JA[Jan<br/>J8-14] --> F[Fév<br/>J15-21]
        end
        subgraph "Printemps (21j)"
            MA[Mar<br/>J22-28] --> AV[Avr<br/>J29-35] --> MAI[Mai<br/>J36-42]
        end
        subgraph "Été (21j)"
            JU[Jun<br/>J43-49] --> JUI[Jul<br/>J50-56] --> AO[Aoû<br/>J57-63]
        end
        subgraph "Automne (21j)"
            SE[Sep<br/>J64-70] --> OC[Oct<br/>J71-77] --> NO[Nov<br/>J78-84]
        end
    end
    F --> MA
    MAI --> JU
    AO --> SE
```

---

## Feature 4 — Système de Heures de Travail

### 4.1 Description

Les Heures de Travail (HT) sont la ressource temporelle du jeu. Chaque joueur reçoit 40 HT/jour (70 sur Expert). Les HT sont consommés par chaque action de jeu (travaux, déplacements, entretien). Les HT non utilisés sont perdus à minuit (pas de cumul). Le déplacement entre préfectures coûte 0.25 HT par préfecture traversée. En Phase 0, seul le mécanisme de base est implémenté (attribution, consommation, reset). Les employés et l'achat de HT viendront en Phase 3.

**Pourquoi** : Les HT structurent le rythme de jeu. Sans HT, un joueur pourrait tout faire en 1 jour. C'est le mécanisme anti-rush qui force la planification quotidienne.

### 4.2 Schéma BDD

```sql
-- Les HT sont stockés dans la table player (ht_today, ht_max)
-- Voir Feature 1 pour la table player

-- Log de consommation HT (audit + analytics)
CREATE TABLE action_log (
  id          BIGSERIAL PRIMARY KEY,
  player_id   UUID NOT NULL REFERENCES player(id),
  pa_spent    DECIMAL(6,2) NOT NULL CHECK (pa_spent > 0),
  action_type VARCHAR(50) NOT NULL,  -- 'move','build','maintain','sow','harvest',...
  details     JSONB,                 -- contexte libre {from_préfecture, to_préfecture, parcel_id,...}
  performed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_action_log_player ON action_log(player_id, performed_at DESC);
CREATE INDEX idx_action_log_type ON action_log(action_type);
```

### 4.3 Logique métier

```
// ─── CONSTANTES ───
HT_BASE         = 40.00    // HT/jour standard
HT_EXPERT       = 70.00    // HT/jour serveur Maîtrise
HT_PER_CANTON     = 0.25     // coût déplacement par préfecture traversée (même département)
PA_CHANGE_DEPT  = 3.00     // coût changement de département
PA_MIN_ACTION   = 0.01     // seuil minimum pour une action

// ─── CONSULTER SES HT ───
function getPA(player_id) -> { ht_today, ht_max }:
    player = SELECT ht_today, ht_max FROM player WHERE id = player_id
    RETURN { ht_today: player.ht_today, ht_max: player.ht_max }

// ─── CONSOMMER DES HT ───
function spendPA(player_id, amount, action_type, details) -> { remaining_pa }:
    ASSERT amount > 0                                → 400 "Montant HT invalide"
    ASSERT amount >= PA_MIN_ACTION                   → 400 "Action trop petite"

    player = SELECT ht_today FROM player WHERE id = player_id FOR UPDATE
    ASSERT player.ht_today >= amount                 → 403 "PA insuffisants"

    BEGIN TRANSACTION
      UPDATE player SET ht_today = ht_today - amount WHERE id = player_id
      INSERT INTO action_log (player_id, pa_spent, action_type, details)
             VALUES (player_id, amount, action_type, details)
    COMMIT

    RETURN { remaining_pa: player.ht_today - amount }

// ─── RESET QUOTIDIEN (appelé par le daily tick) ───
function resetAllPA(server_id):
    UPDATE player SET ht_today = ht_max WHERE server_id = server_id
    // Note : ht_max = 35 pour serveurs normaux, 70 pour Expert
    // En Phase 3+, ht_max pourra être augmenté par les employés

// ─── COÛT DE DÉPLACEMENT ───
function calculateMoveCost(from_prefecture_id, to_prefecture_id) -> float:
    from_préfecture = SELECT préfecture_number, department_id FROM préfecture WHERE id = from_prefecture_id
    to_préfecture = SELECT préfecture_number, department_id FROM préfecture WHERE id = to_prefecture_id

    IF from_préfecture.department_id != to_préfecture.department_id:
        // Changement de département = coût fixe
        RETURN PA_CHANGE_DEPT  // 3.0 HT

    // Même département : coût proportionnel à la distance dans le préfectures
    distance = abs(to_préfecture.préfecture_number - from_préfecture.préfecture_number)
    RETURN distance * HT_PER_CANTON  // 0.25 HT/zone

// ─── EFFECTUER UN DÉPLACEMENT ───
function moveToCanton(player_id, from_prefecture_id, to_prefecture_id):
    ASSERT from_prefecture_id != to_prefecture_id                → 400 "Déjà sur place"

    cost = calculateMoveCost(from_prefecture_id, to_prefecture_id)
    spendPA(player_id, cost, 'move', {
        from_prefecture_id: from_prefecture_id,
        to_prefecture_id: to_prefecture_id,
        cost: cost
    })
    RETURN { cost, remaining_pa }

// ─── VÉRIFIER SI UNE ACTION EST POSSIBLE ───
function canPerformAction(player_id, required_pa) -> bool:
    player = SELECT ht_today FROM player WHERE id = player_id
    RETURN player.ht_today >= required_pa

// ─── HISTORIQUE HT DU JOUR ───
function getTodayActions(player_id) -> list:
    RETURN SELECT action_type, pa_spent, details, performed_at
           FROM action_log
           WHERE player_id = player_id
           AND performed_at >= CURRENT_DATE
           ORDER BY performed_at DESC
```

### 4.4 API Endpoints

#### GET `/api/pa`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "ht_today": 28.50,
  "ht_max": 35.00,
  "pa_spent_today": 6.50,
  "actions_today": [
    {
      "action_type": "move",
      "pa_spent": 0.75,
      "details": {"from_prefecture_id": 1, "to_prefecture_id": 4},
      "performed_at": "2026-04-04T10:30:00Z"
    },
    {
      "action_type": "maintain",
      "pa_spent": 1.00,
      "details": {"building_id": 5},
      "performed_at": "2026-04-04T11:00:00Z"
    }
  ]
}
```

#### POST `/api/pa/move`

```
Headers: Authorization: Bearer <access_token>
Request:
{
  "from_prefecture_id": 1,
  "to_prefecture_id": 4
}

Response 200:
{
  "cost": 0.75,
  "remaining_pa": 27.75
}

Erreurs:
  400 — from_prefecture_id == to_prefecture_id
  403 — HT insuffisants
  404 — Canton inexistant
```

#### GET `/api/pa/move/cost`

```
Headers: Authorization: Bearer <access_token>
Query: ?from_prefecture_id=1&to_prefecture_id=4

Response 200:
{
  "from_prefecture_id": 1,
  "to_prefecture_id": 4,
  "same_department": true,
  "distance_préfectures": 3,
  "cost": 0.75,
  "can_afford": true
}
```

#### GET `/api/pa/history`

```
Headers: Authorization: Bearer <access_token>
Query: ?date=2026-04-04&page=1&limit=50

Response 200:
{
  "actions": [...],
  "total": 12,
  "pa_spent_total": 6.50
}
```

### 4.5 Tests

**Tests unitaires :**
- `spendPA(player, 5.0)` avec 40 HT → reste 35 HT
- `spendPA(player, 35.0)` avec 40 HT → reste 0 HT
- `spendPA(player, 40.01` avec 40 HT → 403 HT insuffisants
- `spendPA(player, 0)` → 400 montant invalide
- `spendPA(player, -1)` → 400 montant invalide
- `calculateMoveCost(zone1, zone4)` même département → 0.75 HT (3 × 0.25)
- `calculateMoveCost(zone1, zone1)` → 0 (même préfecture, mais moveToCanton refuse)
- `calculateMoveCost(zone_dept_A, zone_dept_B)` → 3.0 HT
- `calculateMoveCost(zone1, zone10)` même département → 2.25 HT (9 × 0.25)
- `resetAllPA` → tous les joueurs du serveur à ht_max
- `resetAllPA` sur Expert → joueurs à 70 HT
- Vérifier que action_log est créé à chaque spendPA
- Vérifier la précision décimale (0.25 HT, pas d'arrondi flottant)
- `canPerformAction(player, 35.00)` avec 40 HT → true
- `canPerformAction(player, 40.01` avec 40 HT → false

**Tests d'intégration :**
- Flux : login → dépenser 10 HT → vérifier solde HT → daily tick → HT reset à 35
- Concurrence : 2 requêtes simultanées dépensant 20 HT chacune avec 40 HT → une seule réussit (FOR UPDATE)
- Déplacement : move préfecture 1→5 → 1.0 HT déduit → action_log créé
- Déplacement inter-département → 3.0 HT déduit
- Historique : 5 actions → GET /pa/history retourne 5 entrées triées DESC
- Vérifier que les HT ne se cumulent pas (tick → 35, pas d'action, tick → 35, pas 70)

### 4.6 Diagramme

```mermaid
stateDiagram-v2
    [*] --> PA_40: Daily Tick (reset)
    PA_40 --> PA_Partiel: Action (spendPA)
    PA_Partiel --> PA_Partiel: Action (spendPA)
    PA_Partiel --> PA_0: Dernière action
    PA_0 --> PA_0: Toute action → 403
    PA_40 --> PA_40: Daily Tick (non cumulable)
    PA_Partiel --> PA_40: Daily Tick (reset, HT restants perdus)
    PA_0 --> PA_40: Daily Tick (reset)

    note right of PA_40
        40 HT (standard)
        80 HT (Expert)
    end note
```

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API
    participant DB as PostgreSQL

    C->>API: POST /pa/move {from:1, to:4}
    API->>DB: SELECT préfecture_number, department_id FROM préfecture (×2)
    API->>API: calculateMoveCost → 0.75 HT
    API->>DB: SELECT ht_today FROM player FOR UPDATE
    alt HT suffisants
        API->>DB: UPDATE player SET ht_today -= 0.75
        API->>DB: INSERT action_log
        API-->>C: 200 {cost: 0.75, remaining_pa: 27.75}
    else HT insuffisants
        API-->>C: 403 "PA insuffisants (besoin: 0.75, disponible: 0.50)"
    end
```

---

## Feature 5 — Économie de base

### 5.1 Description

Chaque joueur possède un compte bancaire principal avec un solde initial de 100 000 €. Toutes les opérations financières (achats, ventes, salaires, taxes) passent par ce compte et sont tracées dans un historique de transactions. Le solde peut devenir négatif mais ne peut pas descendre en dessous de -30 000 € (seuil de faillite). Les traitements mensuels (salaires, remboursements de prêts, factures) sont déclenchés par le tick au 1er de chaque mois Cultivia.

**Pourquoi** : L'économie est le système nerveux du jeu. Sans traçabilité des transactions, impossible de débugger l'économie ou de détecter la triche. Le seuil de faillite empêche les abus.

### 5.2 Schéma BDD

```sql
CREATE TABLE bank_account (
  id         SERIAL PRIMARY KEY,
  player_id  UUID NOT NULL REFERENCES player(id) ON DELETE CASCADE,
  type       VARCHAR(20) NOT NULL DEFAULT 'main',
  balance    DECIMAL(14,2) NOT NULL DEFAULT 100000.00,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(player_id, type)
);

CREATE TABLE transaction (
  id          BIGSERIAL PRIMARY KEY,
  player_id   UUID NOT NULL REFERENCES player(id),
  account_type VARCHAR(20) NOT NULL DEFAULT 'main',
  amount      DECIMAL(14,2) NOT NULL,  -- positif=crédit, négatif=débit
  balance_after DECIMAL(14,2) NOT NULL, -- solde après opération (pour relevé)
  category    VARCHAR(50) NOT NULL,
  -- Catégories Phase 0 : 'initial_balance','admin_credit','admin_debit'
  -- Catégories Phase 1+ : 'sale','purchase','salary','tax','loan','interest',
  --   'energy','seed','fertilizer','treatment','vehicle_buy','vehicle_sell',
  --   'parcel_buy','parcel_sell','building','coop_sale','coop_purchase'
  label       VARCHAR(200) NOT NULL,   -- description lisible
  reference_type VARCHAR(30),          -- 'building','vehicle','parcel','crop',...
  reference_id   INT,                  -- FK polymorphe vers l'entité concernée
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_transaction_player ON transaction(player_id, created_at DESC);
CREATE INDEX idx_transaction_category ON transaction(player_id, category);
CREATE INDEX idx_transaction_date ON transaction(created_at);
```

### 5.3 Logique métier

```
// ─── CONSTANTES ───
STARTING_BALANCE    = 100000.00
BANKRUPTCY_THRESHOLD = -30000.00  // solde minimum autorisé
ACCOUNT_TYPE_MAIN   = 'main'

// ─── CONSULTER LE SOLDE ───
function getBalance(player_id) -> { balance }:
    account = SELECT balance FROM bank_account
              WHERE player_id = player_id AND type = ACCOUNT_TYPE_MAIN
    RETURN { balance: account.balance }

// ─── CRÉDITER (ajouter de l'argent) ───
function credit(player_id, amount, category, label, ref_type?, ref_id?):
    ASSERT amount > 0 → 400 "Montant doit être positif"

    BEGIN TRANSACTION
      account = SELECT balance FROM bank_account
                WHERE player_id = player_id AND type = ACCOUNT_TYPE_MAIN
                FOR UPDATE

      new_balance = account.balance + amount

      UPDATE bank_account SET balance = new_balance
             WHERE player_id = player_id AND type = ACCOUNT_TYPE_MAIN

      // Synchroniser le champ player.balance (dénormalisé pour perf)
      UPDATE player SET balance = new_balance WHERE id = player_id

      INSERT INTO transaction (player_id, account_type, amount, balance_after,
                               category, label, reference_type, reference_id)
             VALUES (player_id, ACCOUNT_TYPE_MAIN, +amount, new_balance,
                     category, label, ref_type, ref_id)
    COMMIT

    RETURN { new_balance }

// ─── DÉBITER (retirer de l'argent) ───
function debit(player_id, amount, category, label, ref_type?, ref_id?):
    ASSERT amount > 0 → 400 "Montant doit être positif"

    BEGIN TRANSACTION
      account = SELECT balance FROM bank_account
                WHERE player_id = player_id AND type = ACCOUNT_TYPE_MAIN
                FOR UPDATE

      new_balance = account.balance - amount

      // Vérifier le seuil de faillite
      ASSERT new_balance >= BANKRUPTCY_THRESHOLD
             → 403 "Fonds insuffisants (seuil de faillite : -30 000 €)"

      UPDATE bank_account SET balance = new_balance
             WHERE player_id = player_id AND type = ACCOUNT_TYPE_MAIN

      UPDATE player SET balance = new_balance WHERE id = player_id

      INSERT INTO transaction (player_id, account_type, amount, balance_after,
                               category, label, reference_type, reference_id)
             VALUES (player_id, ACCOUNT_TYPE_MAIN, -amount, new_balance,
                     category, label, ref_type, ref_id)
    COMMIT

    RETURN { new_balance }

// ─── TRANSFERT ENTRE JOUEURS ───
function transfer(from_player_id, to_player_id, amount, category, label):
    ASSERT amount > 0
    ASSERT from_player_id != to_player_id → 400

    // Vérifier même serveur
    from_server = SELECT server_id FROM player WHERE id = from_player_id
    to_server = SELECT server_id FROM player WHERE id = to_player_id
    ASSERT from_server == to_server → 403 "Transfert inter-serveur interdit"

    BEGIN TRANSACTION
      debit(from_player_id, amount, category, label + " → " + to_player_id)
      credit(to_player_id, amount, category, label + " ← " + from_player_id)
    COMMIT

// ─── RELEVÉ DE COMPTE ───
function getStatement(player_id, filters?) -> list:
    // filters: { from_date?, to_date?, category?, page, limit }
    query = SELECT * FROM transaction
            WHERE player_id = player_id
    IF filters.from_date: query += AND created_at >= filters.from_date
    IF filters.to_date:   query += AND created_at <= filters.to_date
    IF filters.category:  query += AND category = filters.category
    query += ORDER BY created_at DESC
    query += LIMIT filters.limit OFFSET (filters.page - 1) * filters.limit
    RETURN query

// ─── RÉSUMÉ FINANCIER ───
function getFinancialSummary(player_id, period_days?) -> summary:
    period = period_days OR 7  // 1 mois Cultivia par défaut
    RETURN {
      balance: current balance,
      income: SUM(amount) WHERE amount > 0 AND created_at >= now() - period days,
      expenses: SUM(ABS(amount)) WHERE amount < 0 AND created_at >= now() - period days,
      net: income - expenses,
      transaction_count: COUNT(*)
    }

// ─── TRAITEMENTS MENSUELS (appelé par le tick au 1er du mois) ───
function processMonthlyEconomy(server_id):
    // En Phase 0, pas encore de salaires/prêts/factures
    // Ce hook sera enrichi en Phase 1+ :
    // 1. Prélever les salaires des employés
    // 2. Prélever les remboursements de prêts
    // 3. Prélever les factures d'énergie
    // 4. Prélever les cotisations Chambre Agricole
    // Pour l'instant : no-op, mais le mécanisme est en place
    LOG "Monthly economy processed for server " + server_id
```

### 5.4 API Endpoints

#### GET `/api/bank/balance`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "balance": 100000.00,
  "account_type": "main",
  "bankruptcy_threshold": -30000.00
}
```

#### GET `/api/bank/statement`

```
Headers: Authorization: Bearer <access_token>
Query: ?page=1&limit=20&category=sale&from_date=2026-04-01&to_date=2026-04-04

Response 200:
{
  "transactions": [
    {
      "id": 42,
      "amount": -5000.00,
      "balance_after": 115000.00,
      "category": "purchase",
      "label": "Achat semences blé (150 kg)",
      "reference_type": "crop",
      "reference_id": 3,
      "created_at": "2026-04-04T14:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1,
    "total_pages": 1
  }
}
```

#### GET `/api/bank/summary`

```
Headers: Authorization: Bearer <access_token>
Query: ?period_days=7

Response 200:
{
  "balance": 115000.00,
  "income": 0.00,
  "expenses": 5000.00,
  "net": -5000.00,
  "transaction_count": 1,
  "period_days": 7
}
```

### 5.5 Tests

**Tests unitaires :**
- `credit(player, 1000, 'sale', 'Vente blé')` → balance +1000, transaction créée
- `debit(player, 500, 'purchase', 'Achat semences')` → balance -500, transaction créée
- `debit(player, 130001)` avec balance 100000 → 403 (100000 - 130001 = -30001 < -30000)
- `debit(player, 130000)` avec balance 100000 → succès (100000 - 130000 = -30000 = seuil)
- `debit(player, 0)` → 400
- `debit(player, -100)` → 400
- `credit(player, 0)` → 400
- Vérifier que balance_after est correct dans chaque transaction
- Vérifier que player.balance est synchronisé avec bank_account.balance
- `transfer(A, B, 1000)` → A débité, B crédité, 2 transactions créées
- `transfer(A, A, 1000)` → 400
- `transfer(A_fr1, B_fr2, 1000)` → 403 (serveurs différents)
- `getStatement` avec filtre category → seules les transactions de cette catégorie
- `getStatement` avec filtre date → seules les transactions dans la période
- `getStatement` pagination → page 1 = 20 résultats, page 2 = suite
- `getFinancialSummary` → income, expenses, net corrects

**Tests d'intégration :**
- Inscription → vérifier balance initiale = 100000 dans bank_account ET player
- Crédit + débit successifs → relevé cohérent avec balance_after
- Concurrence : 2 débits simultanés de 100000 avec balance 100000 → un seul réussit (FOR UPDATE)
- Tick mensuel → processMonthlyEconomy appelé (no-op en Phase 0, mais vérifié)
- Vérifier que les transactions sont ordonnées par created_at DESC
- Stress test : 1000 transactions → relevé paginé fonctionne

### 5.6 Diagramme

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API
    participant DB as PostgreSQL

    Note over C,DB: DÉBIT (achat)
    C->>API: POST /action (qui déclenche un débit)
    API->>DB: SELECT balance FROM bank_account FOR UPDATE
    API->>API: Vérifier balance - amount >= -30000
    alt Fonds suffisants
        API->>DB: UPDATE bank_account SET balance -= amount
        API->>DB: UPDATE player SET balance -= amount
        API->>DB: INSERT transaction (amount négatif, balance_after)
        API-->>C: 200 {new_balance}
    else Seuil de faillite atteint
        API-->>C: 403 "Fonds insuffisants"
    end
```

```mermaid
graph TD
    A[Solde initial<br/>100 000 €] --> B{Action économique}
    B -->|Vente| C[credit: +montant]
    B -->|Achat| D[debit: -montant]
    C --> E[Transaction enregistrée<br/>balance_after calculé]
    D --> F{balance - montant >= -30000 ?}
    F -->|Oui| E
    F -->|Non| G[403 Faillite]
    E --> H[bank_account.balance MAJ]
    E --> I[player.balance MAJ]
    H --> J[Relevé consultable]
```

---

## Feature 6 — Cantons

### 6.1 Description

Le monde de jeu est structuré en 3 niveaux : Régions → Départements → Zones. Chaque département contient exactement préfectures numérotées de 1 à 10. Les préfectures sont l'unité géographique de base : les fermes, parcelles et bâtiments sont localisés dans un préfecture. Le déplacement entre préfectures coûte des HT (0.25 HT/zone dans le même département, 3 HT pour changer de département). Les régions déterminent aussi le préfecture météo (1-4) qui influence les cultures.

**Pourquoi** : La géographie crée la notion de distance et de localité. Elle force les joueurs à se spécialiser régionalement et rend le transport pertinent. C'est le socle spatial de toute l'économie.

### 6.2 Schéma BDD

```sql
CREATE TABLE region (
  id           SERIAL PRIMARY KEY,
  server_id    INT NOT NULL REFERENCES server(id),
  name         VARCHAR(100) NOT NULL,
  code         VARCHAR(10) NOT NULL,             -- 'IDF','NOR','BRE',...
  weather_zone SMALLINT NOT NULL CHECK (weather_zone BETWEEN 1 AND 4),
  UNIQUE(server_id, name),
  UNIQUE(server_id, code)
);
CREATE INDEX idx_region_server ON region(server_id);

CREATE TABLE department (
  id        SERIAL PRIMARY KEY,
  region_id INT NOT NULL REFERENCES region(id) ON DELETE CASCADE,
  name      VARCHAR(100) NOT NULL,
  code      VARCHAR(10) NOT NULL,  -- '75','59','13',...
  UNIQUE(region_id, name),
  UNIQUE(region_id, code)
);
CREATE INDEX idx_department_region ON department(region_id);

CREATE TABLE préfecture (
  id            SERIAL PRIMARY KEY,
  department_id INT NOT NULL REFERENCES department(id) ON DELETE CASCADE,
  préfecture_number   SMALLINT NOT NULL CHECK (préfecture_number BETWEEN 1 AND 10),
  UNIQUE(department_id, préfecture_number)
);
CREATE INDEX idx_zone_department ON zone(department_id);

-- Données de seed : pour chaque serveur FR, créer les 13 régions métropolitaines,
-- ~96 départements, et préfectures par département = ~960 zones.
-- Pour BE : 3 régions, ~10 provinces, 100 zones.
-- Pour CH : 7 grandes régions, ~26 préfectures, 260 zones.
-- Etc.
```

### 6.3 Logique métier

```
// ─── CONSTANTES ───
ZONES_PER_DEPARTMENT = 10
HT_PER_CANTON          = 0.25
PA_CHANGE_DEPT       = 3.00

// ─── LISTER LES RÉGIONS D'UN SERVEUR ───
function getRegions(server_id) -> list:
    RETURN SELECT r.id, r.name, r.code, r.weather_zone,
                  (SELECT COUNT(*) FROM department d WHERE d.region_id = r.id) AS dept_count
           FROM region r
           WHERE r.server_id = server_id
           ORDER BY r.name

// ─── LISTER LES DÉPARTEMENTS D'UNE RÉGION ───
function getDepartments(region_id) -> list:
    RETURN SELECT d.id, d.name, d.code,
                  (SELECT COUNT(DISTINCT p.id) FROM player p
                   JOIN farm f ON f.player_id = p.id
                   JOIN zone z ON z.id = f.prefecture_id
                   WHERE z.department_id = d.id) AS player_count
           FROM department d
           WHERE d.region_id = region_id
           ORDER BY d.name

// ─── LISTER LES ZONES D'UN DÉPARTEMENT ───
function getZones(department_id) -> list:
    RETURN SELECT z.id, z.préfecture_number,
                  (SELECT COUNT(*) FROM farm f WHERE f.prefecture_id = z.id) AS farm_count
           FROM préfecture z
           WHERE z.department_id = department_id
           ORDER BY z.préfecture_number

// ─── CALCULER LA DISTANCE ENTRE 2 ZONES ───
function calculateDistance(zone_a_id, zone_b_id) -> { distance_préfectures, pa_cost, same_department }:
    zone_a = SELECT préfecture_number, department_id FROM préfecture WHERE id = zone_a_id
    zone_b = SELECT préfecture_number, department_id FROM préfecture WHERE id = zone_b_id

    ASSERT zone_a EXISTS → 404 "Zone A inexistante"
    ASSERT zone_b EXISTS → 404 "Zone B inexistante"

    IF zone_a.department_id != zone_b.department_id:
        RETURN {
            distance_préfectures: NULL,
            pa_cost: PA_CHANGE_DEPT,
            same_department: false
        }

    distance = abs(zone_a.préfecture_number - zone_b.préfecture_number)
    RETURN {
        distance_préfectures: distance,
        pa_cost: distance * HT_PER_CANTON,
        same_department: true
    }

// ─── RÉSOUDRE LA HIÉRARCHIE COMPLÈTE D'UNE ZONE ───
function getZoneHierarchy(prefecture_id) -> hierarchy:
    RETURN SELECT z.id AS prefecture_id, z.préfecture_number,
                  d.id AS department_id, d.name AS department_name, d.code AS department_code,
                  r.id AS region_id, r.name AS region_name, r.code AS region_code,
                  r.weather_zone, r.server_id
           FROM préfecture z
           JOIN department d ON d.id = z.department_id
           JOIN region r ON r.id = d.region_id
           WHERE z.id = prefecture_id

// ─── TROUVER LES ZONES VOISINES ───
function getNeighborZones(prefecture_id) -> list:
    zone = SELECT préfecture_number, department_id FROM préfecture WHERE id = prefecture_id
    RETURN SELECT * FROM préfecture
           WHERE department_id = zone.department_id
           AND préfecture_number BETWEEN zone.préfecture_number - 1 AND zone.préfecture_number + 1
           AND id != prefecture_id
           ORDER BY préfecture_number

// ─── SEED DATA (exemple serveur France) ───
// Régions FR avec zones météo :
// Zone 1 (océanique) : Bretagne, Normandie, Pays de la Loire, Nouvelle-Aquitaine
// Zone 2 (semi-continental) : Île-de-France, Hauts-de-France, Grand Est, Bourgogne-FC, Centre-VdL
// Zone 3 (méditerranéen) : Occitanie, Provence-Alpes-Côte d'Azur, Corse
// Zone 4 (montagnard) : Auvergne-Rhône-Alpes
```

### 6.4 API Endpoints

#### GET `/api/geography/regions`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "regions": [
    {
      "id": 1,
      "name": "Île-de-France",
      "code": "IDF",
      "weather_zone": 2,
      "department_count": 8
    },
    ...
  ]
}
```

#### GET `/api/geography/regions/:id/departments`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "region": { "id": 1, "name": "Île-de-France", "code": "IDF" },
  "departments": [
    {
      "id": 1,
      "name": "Paris",
      "code": "75",
      "player_count": 12
    },
    ...
  ]
}

Erreurs:
  404 — Région inexistante
```

#### GET `/api/geography/departments/:id/zones`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "department": { "id": 1, "name": "Paris", "code": "75" },
  "zones": [
    { "id": 1, "préfecture_number": 1, "farm_count": 3 },
    { "id": 2, "préfecture_number": 2, "farm_count": 1 },
    ...
    { "id": 10, "préfecture_number": 10, "farm_count": 0 }
  ]
}

Erreurs:
  404 — Département inexistant
```

#### GET `/api/geography/préfectures/:id`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{
  "prefecture_id": 5,
  "préfecture_number": 5,
  "department": { "id": 1, "name": "Paris", "code": "75" },
  "region": { "id": 1, "name": "Île-de-France", "code": "IDF", "weather_zone": 2 },
  "farm_count": 2,
  "neighbors": [
    { "id": 4, "préfecture_number": 4 },
    { "id": 6, "préfecture_number": 6 }
  ]
}

Erreurs:
  404 — Canton inexistant
```

#### GET `/api/geography/distance`

```
Headers: Authorization: Bearer <access_token>
Query: ?from_prefecture_id=1&to_prefecture_id=7

Response 200:
{
  "from_prefecture_id": 1,
  "to_prefecture_id": 7,
  "same_department": true,
  "distance_préfectures": 6,
  "pa_cost": 1.50
}

// Si départements différents :
{
  "from_prefecture_id": 1,
  "to_prefecture_id": 150,
  "same_department": false,
  "distance_préfectures": null,
  "pa_cost": 3.00
}

Erreurs:
  404 — Canton inexistant
```

### 6.5 Tests

**Tests unitaires :**
- `getRegions(fr1)` → retourne toutes les régions du serveur FR1
- `getRegions(be)` → retourne les régions belges (pas les françaises)
- `getDepartments(region_idf)` → retourne les départements d'IDF
- `getZones(dept_paris)` → retourne exactement préfectures (1-10)
- `calculateDistance(zone1, zone4)` même département → distance=3, cost=0.75
- `calculateDistance(zone1, zone10)` même département → distance=9, cost=2.25
- `calculateDistance(zone1, zone1)` → distance=0, cost=0
- `calculateDistance(zone_dept_A, zone_dept_B)` → same_department=false, cost=3.0
- `getZoneHierarchy(zone5)` → retourne zone + département + région + weather_zone
- `getNeighborZones(zone1)` → retourne [zone2] (pas de préfecture 0)
- `getNeighborZones(zone5)` → retourne [zone4, zone6]
- `getNeighborZones(zone10)` → retourne [zone9] (pas de préfecture 11)
- Vérifier que chaque département a exactement préfectures après seed

**Tests d'intégration :**
- Seed FR1 → vérifier nombre de régions, départements, zones
- Navigation : regions → departments → zones → zone detail (chaîne complète)
- Distance cross-département → 3.0 HT
- Vérifier l'isolation : les préfectures de FR1 ne sont pas visibles depuis FR2
- Vérifier que weather_zone est cohérent par région

### 6.6 Diagramme

```mermaid
graph TD
    S[Server FR1] --> R1[Région: Île-de-France<br/>weather_zone: 2]
    S --> R2[Région: Bretagne<br/>weather_zone: 1]
    S --> R3[...]

    R1 --> D1[Département: Paris<br/>code: 75]
    R1 --> D2[Département: Seine-et-Marne<br/>code: 77]

    D1 --> Z1[Zone 1]
    D1 --> Z2[Zone 2]
    D1 --> Z3[...]
    D1 --> Z10[Zone 10]

    Z1 ---|0.25 HT| Z2
    Z2 ---|0.25 HT| Z3

    D1 ---|3.0 HT| D2

    style S fill:#2196F3,color:white
    style R1 fill:#4CAF50,color:white
    style R2 fill:#4CAF50,color:white
    style D1 fill:#FF9800,color:white
    style D2 fill:#FF9800,color:white
```

---

## Feature 7 — Notifications in-app

### 7.1 Description

Système de notifications temps réel pour informer les joueurs des événements importants : changement de saison, reset HT, transactions bancaires, actions d'autres joueurs sur leurs biens, alertes système. Les notifications sont persistées en BDD et poussées en temps réel via WebSocket. Chaque notification a un type, un niveau de priorité, et un statut lu/non-lu. Les notifications expirent après 30 jours.

**Pourquoi** : Sans notifications, le joueur doit vérifier manuellement chaque aspect du jeu. Les notifications guident l'attention et améliorent l'engagement (rétention J7).

### 7.2 Schéma BDD

```sql
CREATE TABLE notification (
  id          BIGSERIAL PRIMARY KEY,
  player_id   UUID NOT NULL REFERENCES player(id) ON DELETE CASCADE,
  type        VARCHAR(50) NOT NULL,
  -- Types Phase 0 :
  --   'welcome'           — bienvenue après inscription
  --   'daily_tick'        — nouveau jour, HT reset
  --   'season_change'     — changement de saison
  --   'month_change'      — nouveau mois
  --   'year_change'       — nouvelle année
  --   'balance_low'       — solde < 10000€
  --   'balance_critical'  — solde < 0€
  --   'transaction'       — crédit ou débit significatif
  --   'system'            — maintenance, mise à jour
  priority    VARCHAR(10) NOT NULL DEFAULT 'info',
  -- 'info', 'warning', 'critical'
  title       VARCHAR(200) NOT NULL,
  body        TEXT,
  data        JSONB,          -- payload contextuel {transaction_id, amount, season,...}
  is_read     BOOLEAN NOT NULL DEFAULT false,
  read_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at  TIMESTAMPTZ NOT NULL DEFAULT now() + INTERVAL '30 days'
);
CREATE INDEX idx_notification_player ON notification(player_id, created_at DESC);
CREATE INDEX idx_notification_unread ON notification(player_id, is_read) WHERE is_read = false;
CREATE INDEX idx_notification_expires ON notification(expires_at);
```

### 7.3 Logique métier

```
// ─── CRÉER UNE NOTIFICATION ───
function createNotification(player_id, type, priority, title, body?, data?):
    notif = INSERT INTO notification (player_id, type, priority, title, body, data)
            VALUES (player_id, type, priority, title, body, data)
            RETURNING *

    // Push temps réel via WebSocket (si joueur connecté)
    wsPublish('player:' + player_id + ':notifications', {
        id: notif.id,
        type: type,
        priority: priority,
        title: title,
        body: body,
        data: data,
        created_at: notif.created_at
    })

    RETURN notif

// ─── CRÉER DES NOTIFICATIONS EN MASSE (tick) ───
function createBulkNotifications(server_id, type, priority, title, body?, data?):
    // Pour tous les joueurs d'un serveur (ex: changement de saison)
    INSERT INTO notification (player_id, type, priority, title, body, data)
    SELECT p.id, type, priority, title, body, data
    FROM player p WHERE p.server_id = server_id

    // Push WebSocket broadcast sur le channel du serveur
    wsPublish('server:' + server_id + ':notifications', {
        type, priority, title, body, data
    })

// ─── LISTER LES NOTIFICATIONS ───
function getNotifications(player_id, filters?) -> list:
    // filters: { unread_only?, type?, page, limit }
    query = SELECT * FROM notification
            WHERE player_id = player_id
            AND expires_at > now()
    IF filters.unread_only: query += AND is_read = false
    IF filters.type: query += AND type = filters.type
    query += ORDER BY created_at DESC
    query += LIMIT filters.limit OFFSET (filters.page - 1) * filters.limit
    RETURN query

// ─── COMPTER LES NON-LUES ───
function getUnreadCount(player_id) -> int:
    RETURN SELECT COUNT(*) FROM notification
           WHERE player_id = player_id AND is_read = false AND expires_at > now()

// ─── MARQUER COMME LUE ───
function markAsRead(player_id, notification_id):
    result = UPDATE notification SET is_read = true, read_at = now()
             WHERE id = notification_id AND player_id = player_id
    ASSERT result.rowCount == 1 → 404

// ─── MARQUER TOUTES COMME LUES ───
function markAllAsRead(player_id):
    UPDATE notification SET is_read = true, read_at = now()
           WHERE player_id = player_id AND is_read = false

// ─── SUPPRIMER UNE NOTIFICATION ───
function deleteNotification(player_id, notification_id):
    result = DELETE FROM notification
             WHERE id = notification_id AND player_id = player_id
    ASSERT result.rowCount == 1 → 404

// ─── NETTOYAGE DES NOTIFICATIONS EXPIRÉES (job quotidien) ───
function cleanupExpiredNotifications():
    DELETE FROM notification WHERE expires_at < now()

// ─── NOTIFICATIONS DÉCLENCHÉES PAR LE TICK ───
// Appelé dans dailyTick() :
function tickNotifications(server_id, new_day, new_month, new_season, new_year,
                           month_changed, season_changed, year_changed):

    // Notification quotidienne (PA reset)
    createBulkNotifications(server_id, 'daily_tick', 'info',
        'Nouveau jour : ' + MONTH_NAMES[new_month] + ' J' + getDayOfMonth(new_day),
        'Vos HT ont été réinitialisés.',
        { day: new_day, month: new_month })

    IF month_changed:
        createBulkNotifications(server_id, 'month_change', 'info',
            'Nouveau mois : ' + MONTH_NAMES[new_month],
            NULL,
            { month: new_month })

    IF season_changed:
        createBulkNotifications(server_id, 'season_change', 'warning',
            'Changement de saison : ' + new_season,
            'Adaptez vos cultures et votre élevage.',
            { season: new_season })

    IF year_changed:
        createBulkNotifications(server_id, 'year_change', 'info',
            'Nouvelle année Cultivia : Année ' + new_year,
            NULL,
            { year: new_year })

    // Alertes solde bas (individuelles)
    low_balance_players = SELECT id, balance FROM player
                          WHERE server_id = server_id AND balance < 10000 AND balance >= 0
    FOR EACH p IN low_balance_players:
        createNotification(p.id, 'balance_low', 'warning',
            'Solde bas : ' + p.balance + ' €',
            'Pensez à vendre vos récoltes.',
            { balance: p.balance })

    critical_balance_players = SELECT id, balance FROM player
                               WHERE server_id = server_id AND balance < 0
    FOR EACH p IN critical_balance_players:
        createNotification(p.id, 'balance_critical', 'critical',
            'Solde négatif : ' + p.balance + ' €',
            'Attention, faillite à -30 000 €.',
            { balance: p.balance })
```

### 7.4 API Endpoints

#### GET `/api/notifications`

```
Headers: Authorization: Bearer <access_token>
Query: ?page=1&limit=20&unread_only=true&type=season_change

Response 200:
{
  "notifications": [
    {
      "id": 42,
      "type": "season_change",
      "priority": "warning",
      "title": "Changement de saison : summer",
      "body": "Adaptez vos cultures et votre élevage.",
      "data": { "season": "summer" },
      "is_read": false,
      "created_at": "2026-04-04T00:00:05Z"
    }
  ],
  "unread_count": 3,
  "pagination": { "page": 1, "limit": 20, "total": 1, "total_pages": 1 }
}
```

#### GET `/api/notifications/unread-count`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{ "unread_count": 3 }
```

#### PATCH `/api/notifications/:id/read`

```
Headers: Authorization: Bearer <access_token>

Response 204: (no content)

Erreurs:
  404 — Notification inexistante ou pas la sienne
```

#### POST `/api/notifications/read-all`

```
Headers: Authorization: Bearer <access_token>

Response 200:
{ "marked_count": 3 }
```

#### DELETE `/api/notifications/:id`

```
Headers: Authorization: Bearer <access_token>

Response 204: (no content)

Erreurs:
  404 — Notification inexistante ou pas la sienne
```

#### WebSocket — Channel notifications

```
// Le client s'abonne au channel après connexion WebSocket
// Channel: player:{player_id}:notifications

// Message reçu (push serveur → client) :
{
  "event": "notification",
  "data": {
    "id": 42,
    "type": "season_change",
    "priority": "warning",
    "title": "Changement de saison : summer",
    "body": "Adaptez vos cultures et votre élevage.",
    "data": { "season": "summer" },
    "created_at": "2026-04-04T00:00:05Z"
  }
}

// Le client peut aussi écouter le channel serveur pour les broadcasts :
// Channel: server:{server_id}:notifications
```

### 7.5 Tests

**Tests unitaires :**
- `createNotification` → notification créée en BDD, retournée avec id
- `createNotification` → WebSocket publish appelé
- `createBulkNotifications` pour 100 joueurs → 100 notifications créées
- `getNotifications` → retourne les notifications triées DESC
- `getNotifications(unread_only=true)` → exclut les lues
- `getNotifications(type='season_change')` → filtre par type
- `getUnreadCount` → compte correct
- `markAsRead` → is_read=true, read_at renseigné
- `markAsRead` notification d'un autre joueur → 404
- `markAllAsRead` → toutes les non-lues passent à lues
- `deleteNotification` → supprimée
- `deleteNotification` d'un autre joueur → 404
- `cleanupExpiredNotifications` → supprime les notifications > 30 jours
- Vérifier que expires_at = created_at + 30 jours par défaut

**Tests d'intégration :**
- Tick → notifications daily_tick créées pour tous les joueurs du serveur
- Tick avec changement de saison → notification season_change créée
- Tick avec joueur balance < 10000 → notification balance_low créée
- Tick avec joueur balance < 0 → notification balance_critical créée
- WebSocket : connecter un client → recevoir les notifications en temps réel
- Pagination : 50 notifications → page 1 (20), page 2 (20), page 3 (10)
- Nettoyage : créer notification avec expires_at passé → cleanup la supprime

### 7.6 Diagramme

```mermaid
sequenceDiagram
    participant TICK as Daily Tick
    participant DB as PostgreSQL
    participant R as Redis Pub/Sub
    participant WS as WebSocket Server
    participant C as Client

    Note over TICK,C: Notification broadcast (ex: changement saison)
    TICK->>DB: INSERT notification pour chaque joueur
    TICK->>R: PUBLISH server:1:notifications {season_change}
    R->>WS: Message reçu
    WS->>C: Push notification (si connecté)

    Note over TICK,C: Notification individuelle (ex: solde bas)
    TICK->>DB: INSERT notification pour joueur X
    TICK->>R: PUBLISH player:X:notifications {balance_low}
    R->>WS: Message reçu
    WS->>C: Push notification

    Note over C,DB: Lecture des notifications
    C->>WS: GET /notifications?unread_only=true
    WS->>DB: SELECT notifications
    DB-->>C: Liste notifications
    C->>WS: PATCH /notifications/42/read
    WS->>DB: UPDATE is_read=true
```

```mermaid
stateDiagram-v2
    [*] --> Creee: createNotification
    Creee --> NonLue: Persistée en BDD
    NonLue --> Lue: PATCH /read
    NonLue --> Supprimee: DELETE
    Lue --> Supprimee: DELETE
    NonLue --> Expiree: expires_at < now()
    Lue --> Expiree: expires_at < now()
    Expiree --> Supprimee: cleanup job
    Supprimee --> [*]
```

---

## Feature 10 — Barre de statut persistante

<!-- PO-VALIDATED: 3.2 -->

### 10.1 Description

Header fixe affiché sur toutes les pages du jeu. Affiche en permanence : HT restants (barre + chiffre), solde (couleur selon seuil), météo du jour (icône), saison + jour Cultivia, countdown avant le prochain tick (00:00 UTC). Le joueur ne perd jamais le contexte.

### 10.2 Composants affichés

| Donnée | Source | Format | Rafraîchissement |
|--------|--------|--------|-----------------|
| HT restants | `player.ht_today` / `player.ht_max` | Barre + `28.5 / 35.0 HT` | Temps réel (WebSocket) |
| Solde | `player.balance` | `100 000 €` — vert > 10k, orange 0-10k, rouge < 0 | Temps réel (WebSocket) |
| Météo | `weather` du jour, zone du joueur | Icône (☀️🌤️☁️🌧️⛈️) + label | 1×/jour (tick) |
| Saison + jour | `server.current_season`, `current_day` | `Printemps — Mars J4` | 1×/jour (tick) |
| Countdown tick | Calcul client → 00:00 UTC | `Prochain tick : 05h32m` | Client-side, chaque seconde |

### 10.3 Conventions frontend

- Composant Vue : `<StatusBar />` inclus dans le layout principal
- Position : `position: sticky; top: 0; z-index: 1000`
- Responsive : sur mobile, les éléments secondaires (météo, countdown) passent dans un menu déroulant
- Les données sont alimentées par le store Pinia global, mis à jour via WebSocket

### 10.4 Tests

- Vérifier que la barre est visible sur toutes les routes authentifiées
- Vérifier que le solde change de couleur aux seuils (10k, 0)
- Vérifier que le countdown se met à jour chaque seconde
- Vérifier que le tick WebSocket met à jour HT + saison + météo

---

## Feature 11 — WebSocket temps réel

<!-- PO-VALIDATED: 6.2 -->

### 11.1 Description

Connexion WebSocket persistante entre le client et le serveur pour pousser les événements en temps réel : tick journalier, notifications, prix marché, résultat d'actions, ami connecté. Remplace le polling. Authentification par token JWT envoyé à la connexion.

### 11.2 Endpoint

```
WS /ws?token=<access_token>
```

### 11.3 Authentification

1. Le client ouvre une connexion WebSocket vers `/ws?token=<JWT>`
2. Le serveur vérifie le JWT (même logique que le middleware HTTP)
3. Si valide → connexion acceptée, le serveur souscrit le client aux channels :
   - `player:{player_id}:*` — événements personnels
   - `server:{server_id}:*` — événements serveur (tick, météo, prix)
4. Si invalide → fermeture avec code 4001 + message `"Invalid token"`
5. Si le JWT expire pendant la connexion → le serveur envoie un event `token_expired`, le client doit refresh et reconnecter

### 11.4 Événements poussés

| Event | Channel | Payload | Déclencheur |
|-------|---------|---------|-------------|
| `tick` | `server:{id}` | `{ day, month, season, year }` | Daily tick |
| `ht_update` | `player:{id}` | `{ ht_today, ht_max }` | Après chaque action |
| `balance_update` | `player:{id}` | `{ balance }` | Après chaque transaction |
| `notification` | `player:{id}` | `{ id, type, title, priority }` | Création notification |
| `weather` | `server:{id}` | `{ zones: [...] }` | Daily tick |
| `token_expired` | `player:{id}` | `{}` | JWT expiré |

### 11.5 Implémentation

- Librairie serveur : `@fastify/websocket` ou `ws`
- Pub/Sub via Redis pour supporter plusieurs instances API
- Heartbeat : ping/pong toutes les 30s, déconnexion si pas de pong en 60s
- Reconnexion client : backoff exponentiel (1s, 2s, 4s, 8s, max 30s)

### 11.6 Tests

- Connexion avec JWT valide → acceptée
- Connexion avec JWT invalide → code 4001
- Tick → tous les clients du serveur reçoivent l'event `tick`
- Action HT → le joueur reçoit `ht_update`
- Transaction → le joueur reçoit `balance_update`
- Pas de pong en 60s → déconnexion serveur
- Reconnexion après déconnexion → re-souscription automatique

---

## Feature 12 — Cache Redis

<!-- PO-VALIDATED: 6.5 -->

### 12.1 Description

Les données peu changeantes sont cachées dans Redis avec TTL adapté. Invalidation ciblée au tick journalier ou lors de mutations. Objectif : réduire les requêtes PostgreSQL de 60-70% en régime de croisière.

### 12.2 Clés cachées et TTL

| Clé Redis | Données | TTL | Invalidation |
|-----------|---------|-----|-------------|
| `catalog:vehicles` | Catalogue matériels (vehicle_type) | 7 jours | Jamais (statique) |
| `catalog:crops` | Catalogue cultures (crop_type) | 7 jours | Jamais (statique) |
| `catalog:inputs` | Catalogue engrais/traitements | 7 jours | Jamais (statique) |
| `catalog:buildings` | Catalogue bâtiments (building_type) | 7 jours | Jamais (statique) |
| `catalog:breeds` | Catalogue races animales | 7 jours | Jamais (statique) |
| `coop:prices:{server_id}` | Prix Coop (vente récoltes) | 7 jours (1 saison) | Changement de saison |
| `weather:{server_id}:{day}:{year}` | Météo du jour (4 zones) | 24h | Daily tick (nouvelle météo) |
| `server:{server_id}:time` | Jour/mois/saison/année courants | 24h | Daily tick |
| `player:{player_id}:summary` | HT, solde, ferme (données header) | 5 min | Après action HT ou transaction |
| `geography:{server_id}:regions` | Régions + départements | 30 jours | Jamais (statique) |
| `distances:{from}:{to}` | Distance entre préfectures | 30 jours | Jamais (statique) |

### 12.3 Conventions

- Préfixe par namespace : `catalog:`, `coop:`, `weather:`, `server:`, `player:`, `geography:`
- Sérialisation : JSON (`JSON.stringify` / `JSON.parse`)
- Pattern cache-aside : vérifier Redis → si miss, requête PostgreSQL → stocker en Redis
- Invalidation : `redis.DEL(key)` lors des mutations ou dans le tick
- Pas de cache sur les données transactionnelles (balance exacte, stock exact) sauf `player:summary` avec TTL court

### 12.4 Tests

- Cache hit → pas de requête PostgreSQL
- Cache miss → requête PostgreSQL + stockage Redis
- Tick → clés `weather`, `server:time`, `coop:prices` invalidées
- Action joueur → clé `player:summary` invalidée
- TTL expiré → re-fetch automatique

---

## Feature 13 — Monitoring latence

<!-- PO-VALIDATED: 6.7 -->

### 13.1 Description

Middleware Fastify qui mesure la latence de chaque requête API. Les métriques sont agrégées et exposées sur un dashboard admin. Alerte si le p95 dépasse 500ms.

### 13.2 Implémentation

```
// Middleware onRequest + onResponse
function latencyMiddleware(req, reply):
    req.startTime = process.hrtime.bigint()

    reply.addHook('onResponse', () => {
        const duration_ms = Number(process.hrtime.bigint() - req.startTime) / 1e6
        const route = req.routeOptions?.url || req.url
        const method = req.method
        const status = reply.statusCode

        // Stocker dans Redis (sorted set pour percentiles)
        redis.ZADD('metrics:latency:' + route, duration_ms, Date.now().toString())
        redis.LPUSH('metrics:requests', JSON.stringify({
            route, method, status, duration_ms, timestamp: Date.now()
        }))
        redis.LTRIM('metrics:requests', 0, 9999)  // garder les 10k dernières
    })
```

### 13.3 Endpoint admin

```
GET /api/admin/metrics
Response 200:
{
  "requests_last_hour": 4523,
  "latency": {
    "p50": 45,
    "p95": 180,
    "p99": 420
  },
  "routes": [
    { "route": "/api/parcels", "p50": 32, "p95": 120, "count": 890 },
    ...
  ],
  "alerts": []
}
```

### 13.4 Tests

- Chaque requête API → métrique enregistrée dans Redis
- GET /admin/metrics → percentiles calculés correctement
- p95 > 500ms → alerte dans la réponse

---

## Feature 14 — Conventions frontend

<!-- PO-VALIDATED: 6.9, 6.1, 6.4 -->

### 14.1 Lazy loading

Toutes les pages rarement visitées sont chargées en lazy loading via `defineAsyncComponent` ou `() => import(...)` dans le router Vue. Le bundle initial ne contient que :
- Layout principal + StatusBar
- Page Dashboard
- Page la plus visitée (Parcelles ou Animaux selon la phase)

Pages en lazy loading : Paramètres, Historique, Classements, Banque (détail), Carte, Profil.

### 14.2 Optimistic UI

Pattern pour les actions de jeu (nourrir, semer, récolter, etc.) :

1. Le client envoie la requête API
2. **Immédiatement** : le store Pinia met à jour l'état local (HT déduits, animation)
3. Si le serveur répond 2xx → confirmation silencieuse
4. Si le serveur répond 4xx/5xx → **rollback** de l'état local + toast rouge `"Action annulée : [raison]"` + restauration visuelle animée

Convention :
- Chaque action dans le store a une méthode `optimistic_<action>` et `rollback_<action>`
- Le composant appelle `optimistic_<action>` avant `await api.<action>()`
- Le `catch` appelle `rollback_<action>` + affiche le toast

### 14.3 Pagination cursor

Toutes les réponses de liste API utilisent la pagination par curseur (pas d'offset). Format standardisé :

```json
{
  "data": [...],
  "pagination": {
    "cursor": "eyJpZCI6NDJ9",
    "has_more": true,
    "limit": 20
  }
}
```

- Paramètres query : `?limit=20&cursor=<opaque_string>`
- Le curseur encode l'ID du dernier élément (base64)
- `has_more: true` → le client peut demander la page suivante
- Compression : gzip/brotli activé sur toutes les réponses API
- Sparse fieldsets : paramètre `?fields=id,name,balance` pour exclure les champs inutiles
- Objectif : < 50ms pour toute requête liste

### 14.4 Tests

- Lazy loading : vérifier que le bundle initial ne contient pas les pages secondaires
- Optimistic UI : action réussie → pas de flash visuel
- Optimistic UI : action échouée → rollback visible + toast rouge
- Pagination cursor : 50 items, limit=20 → 3 pages, curseurs valides
- Compression : réponse API contient header `Content-Encoding: gzip`

---

## Annexe A — Ordre d'exécution du Daily Tick (récapitulatif)

Le tick s'exécute chaque jour à **00:00 UTC** pour chaque serveur actif.

```
┌─────────────────────────────────────────────────────────────┐
│                    DAILY TICK — Phase 0                      │
├─────┬───────────────────────────────────────────────────────┤
│  1  │ Acquérir le verrou (tick_lock)                        │
│  2  │ Avancer la date (day++, vérifier mois/saison/année)   │
│  3  │ Reset HT de tous les joueurs (ht_today = ht_max)      │
│  4  │ Incrémenter ancienneté joueurs (seniority_days++)     │
│  5  │ Si 1er du mois : traitements mensuels économie        │
│     │   └─ (Phase 0 : no-op, hook prêt pour Phase 1+)      │
│  6  │ Si changement de saison : processSeasonChange()       │
│     │   └─ (Phase 0 : no-op, hook prêt pour Phase 1+)      │
│  7  │ Si changement d'année : processYearEnd()              │
│     │   └─ (Phase 0 : no-op, hook prêt pour Phase 1+)      │
│  8  │ Envoyer les notifications (tick, saison, solde bas)   │
│  9  │ Nettoyer les notifications expirées (>30 jours)       │
│ 10  │ Logger le tick (tick_log, durée, statut)              │
│ 11  │ Libérer le verrou                                     │
└─────┴───────────────────────────────────────────────────────┘
```

## Annexe B — Schéma global des tables Phase 0

```mermaid
erDiagram
    ACCOUNT ||--o{ PLAYER : "has profiles"
    ACCOUNT ||--o{ REFRESH_TOKEN : "has tokens"

    SERVER ||--o{ PLAYER : "hosts"
    SERVER ||--o{ REGION : "contains"
    SERVER ||--o{ TICK_LOG : "logs"
    SERVER ||--|| TICK_LOCK : "has lock"

    REGION ||--o{ DEPARTMENT : "contains"
    DEPARTMENT ||--o{ ZONE : "contains"

    PLAYER ||--|| BANK_ACCOUNT : "has"
    PLAYER ||--o{ TRANSACTION : "records"
    PLAYER ||--o{ ACTION_LOG : "logs PA"
    PLAYER ||--o{ NOTIFICATION : "receives"
```

## Annexe C — Variables d'environnement requises

```env
# Base de données
DATABASE_URL=postgresql://user:pass@localhost:5432/cultivia
DATABASE_POOL_SIZE=20

# Redis
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=<random-256-bit-key>
JWT_ACCESS_EXPIRES=15m
JWT_REFRESH_EXPIRES=7d

# Email
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=noreply@cultivia.com
SMTP_PASS=<smtp-password>
EMAIL_FROM=Cultivia <noreply@cultivia.com>
VERIFICATION_URL=https://cultivia.com/verify-email

# Application
APP_URL=https://cultivia.com
API_PORT=3000
NODE_ENV=production
TICK_CRON=0 0 * * *

# Sécurité
BCRYPT_ROUNDS=12
RATE_LIMIT_WINDOW=60000
RATE_LIMIT_MAX=100
```

## Annexe D — Résumé des constantes de jeu (Phase 0)

| Constante | Valeur | Source |
|---|---|---|
| HT de base | 40/jour | 02_GAME_SYSTEMS §2.1 |
| HT Expert | 70/jour | 02_GAME_SYSTEMS §2.1 |
| HT par préfecture | 0.25 | 02_GAME_SYSTEMS §2.2 |
| HT changement département | 3.0 | 02_GAME_SYSTEMS §2.2 |
| Solde initial | 100 000 € | 04_PRODUCT_ROADMAP §2.1 |
| Seuil de faillite | -30 000 € | 01_DATA_MODEL §5.2 |
| Zones par département | 10 | 01_DATA_MODEL §1.4 |
| Jours par mois Cultivia | 7 | 02_GAME_SYSTEMS §1.1 |
| Jours par saison | 21 | 02_GAME_SYSTEMS §1.1 |
| Jours par année | 84 | 02_GAME_SYSTEMS §1.1 |
| Expiration notifications | 30 jours | Spec Phase 0 |
| Expiration token vérification email | 24 heures | Spec Phase 0 |
| Durée access token JWT | 15 minutes | Spec Phase 0 |
| Durée refresh token | 7 jours | Spec Phase 0 |
| Nombre de serveurs | 8 | 01_DATA_MODEL §9.4 |
| Max joueurs par serveur | 5 000 | Spec Phase 0 |

---

> **Cultivia Clone — PHASE0_INFRASTRUCTURE.md — v1.0**
> 7 features, ~10 tables, 1 serveur France (normal)
> Prêt pour développement. Un dev peut coder sans poser de questions.

---

## Feature 8 — Création de ferme

### 8.1 Règles métier

- Un joueur doit créer une ferme avant de pouvoir acheter des parcelles ou interagir avec le jeu.
- La ferme est liée à un `player` (lui-même lié à un `account` + `server`).
- Le joueur choisit une région, un département, puis un préfecture pour implanter sa ferme.
- Un joueur ne peut avoir qu'une seule ferme principale (`is_primary = true`) par serveur.
- Le nom de la ferme est obligatoire (3-100 caractères).

### 8.2 Endpoint

#### POST `/api/farms`

```
Auth: JWT required
Body:
{
  "prefecture_id": 42,
  "name": "Ferme du Vallon"
}

Validations:
- Le joueur ne doit pas déjà avoir de ferme principale sur ce serveur
- Le préfecture doit exister et appartenir au serveur du joueur
- Le nom doit faire entre 3 et 100 caractères

Response 201:
{
  "id": 1,
  "player_id": 5,
  "prefecture_id": 42,
  "name": "Ferme du Vallon",
  "is_primary": true,
  "created_at": "2026-04-04T12:00:00Z"
}

Erreurs:
- 400: prefecture_id invalide, nom trop court/long
- 409: "Le joueur a déjà une ferme principale"
- 404: "Zone introuvable"
```

### 8.3 Pseudocode

```
function createFarm(player_id, prefecture_id, name):
    player = getPlayer(player_id)
    ASSERT player EXISTS                                          → 401

    existing = SELECT * FROM farm WHERE player_id = player_id AND is_primary = true
    ASSERT NOT existing                                           → 409 "Ferme déjà existante"

    zone = SELECT z.*, d.region_id, r.server_id
           FROM préfecture z
           JOIN department d ON d.id = z.department_id
           JOIN region r ON r.id = d.region_id
           WHERE z.id = prefecture_id
    ASSERT zone EXISTS                                            → 404
    ASSERT zone.server_id == player.server_id                     → 400 "Zone hors serveur"

    BEGIN TRANSACTION
      farm = INSERT INTO farm (player_id, prefecture_id, name, is_primary)
             VALUES (player_id, prefecture_id, name, true)

      // ─── KIT DE DÉMARRAGE (résolution audit E1) ───
      // Matériel usé offert — non revendable pendant 7 jours (1 mois Cultivia)
      lock_until = now() + INTERVAL '7 days'
      STARTER_KIT = [
        { slug: 'tractor-80',     wear: 50 },
        { slug: 'plow-4',         wear: 40 },
        { slug: 'harrow-3m',      wear: 40 },
        { slug: 'seeder-3m',      wear: 40 },
        { slug: 'combine-300',    wear: 60 },
        { slug: 'trailer-12t',    wear: 40 }
      ]
      FOR EACH item IN STARTER_KIT:
        vtype = SELECT * FROM vehicle_type WHERE slug = item.slug
        vehicle = INSERT INTO vehicle (farm_id, vehicle_type_id, wear_pct, is_sheltered, bought_price, sell_locked_until)
                  VALUES (farm.id, vtype.id, item.wear, true, 0, lock_until)
        // Créer les pièces détachées avec usure proportionnelle
        FOR piece_num IN 1..vtype.piece_count:
          INSERT INTO vehicle_piece (vehicle_id, piece_num, wear_pct)
                 VALUES (vehicle.id, piece_num, item.wear * 0.8)

      // Bâtiments de départ : silo 100T + hangar 200m² + cuve HVC 2000L
      INSERT INTO building (farm_id, building_type_id, ...)  // silo, hangar, cuve
    COMMIT

    RETURN farm
```

### 8.4 Tests

```
✅ Créer une ferme avec zone valide → 201 + 6 véhicules kit + 3 bâtiments créés
✅ Kit de démarrage : vérifier usure correcte (50%, 40%, 60% selon matériel)
✅ Kit de démarrage : matériel non revendable avant 7 jours (sell_locked_until)
✅ Kit de démarrage : pièces détachées créées avec usure proportionnelle
✅ Créer une ferme alors qu'une existe déjà → 409
✅ Canton inexistant → 404
✅ Zone d'un autre serveur → 400
✅ Nom trop court (<3 chars) → 400
✅ Joueur non authentifié → 401
```

---

## Feature 8bis — Renvoi email de vérification

### Endpoint

#### POST `/api/auth/resend-verification`

```
Auth: none (email dans le body)
Rate limit: 1 requête par minute par email

Body:
{
  "email": "player@example.com"
}

Logique:
- Chercher le compte par email
- Si le compte n'existe pas → 200 (pas de leak d'info)
- Si le compte est déjà vérifié → 200 (pas de leak d'info)
- Si le compte n'est pas vérifié : générer un nouveau verification_token,
  mettre à jour verification_expires_at = now() + 24h, envoyer l'email

Response 200:
{
  "message": "Si un compte non vérifié existe, un email a été envoyé."
}

Erreurs:
- 429: "Rate limit — réessayez dans 60 secondes"
```

### Tests

```
✅ Email existant non vérifié → 200 + email envoyé
✅ Email existant déjà vérifié → 200 (pas d'email)
✅ Email inexistant → 200 (pas de leak)
✅ 2 requêtes en <60s → 429
```

---

## Feature 9 — Middleware Idempotency Key (Réf: REVIEW_FINALE I4)

### 9.1 Description

Protection contre les double-clicks et les requêtes réseau dupliquées. Le client envoie un header `X-Idempotency-Key` (UUID v4) avec chaque requête de mutation. Si la même clé est rejouée, le serveur retourne la réponse mise en cache sans ré-exécuter l'action.

### 9.2 Schéma BDD

```sql
-- Voir 01_DATA_MODEL.md §1.17
CREATE TABLE idempotency_key (
  id          SERIAL PRIMARY KEY,
  player_id   UUID NOT NULL REFERENCES player(id),
  key         VARCHAR(100) NOT NULL,
  endpoint    VARCHAR(200) NOT NULL,
  response    JSONB NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at  TIMESTAMPTZ NOT NULL DEFAULT now() + INTERVAL '24 hours',
  UNIQUE(player_id, key)
);
CREATE INDEX idx_idempotency_expires ON idempotency_key(expires_at);
```

### 9.3 Logique métier

```
// ─── MIDDLEWARE IDEMPOTENCY ───
// Appliqué sur toutes les routes POST/PUT/HTTCH/DELETE authentifiées
function idempotencyMiddleware(req, reply):
    key = req.headers['x-idempotency-key']
    IF NOT key: RETURN  // header optionnel mais recommandé

    player_id = req.user.player_id
    cache_key = 'idempotency:' + player_id + ':' + key

    // 1. Vérifier Redis (fast path)
    cached = redis.GET(cache_key)
    IF cached:
        response = JSON.parse(cached)
        reply.code(response.status).send(response.body)
        RETURN reply  // court-circuite le handler

    // 2. Vérifier BDD (si Redis a été purgé)
    db_cached = SELECT response FROM idempotency_key
                WHERE player_id = player_id AND key = key AND expires_at > now()
    IF db_cached:
        redis.SET(cache_key, JSON.stringify(db_cached.response), 'EX', 86400)
        reply.code(db_cached.response.status).send(db_cached.response.body)
        RETURN reply

    // 3. Exécuter le handler normalement
    // Après exécution (via onSend hook), stocker la réponse :
    //   redis.SET(cache_key, JSON.stringify({status, body}), 'EX', 86400)
    //   INSERT INTO idempotency_key (player_id, key, endpoint, response)
    //     VALUES (player_id, key, req.url, {status, body})

// ─── NETTOYAGE (job quotidien) ───
function cleanupIdempotencyKeys():
    DELETE FROM idempotency_key WHERE expires_at < now()
```

### 9.4 Tests

```
✅ Même requête avec même clé → même réponse, pas de double déduction HT/argent
✅ Même clé, endpoint différent → nouvelle exécution (clé scopée par player_id + key)
✅ Clé expirée (>24h) → nouvelle exécution
✅ Sans header X-Idempotency-Key → exécution normale (pas de protection)
✅ Clé avec caractères spéciaux → rejetée (validation UUID format)
✅ Vérifier que le solde ne change qu'une fois malgré 2 requêtes identiques
```


---

## Feature 9 — Choix du kit de démarrage (inscription)

> PO-VALIDATED: Kit par style de jeu, 1 seul par joueur, irréversible.

### 9.1 Description
Après le choix de la préfecture, le joueur choisit 1 kit parmi 3 : Cultivateur 🌾, Éleveur 🐄, Polyvalent ⚖️. Le kit offre du matériel usé, des bâtiments niveau 1, et éventuellement des animaux. Choix irréversible.

### 9.2 Schéma BDD

```sql
CREATE TYPE starter_kit AS ENUM ('cultivator', 'breeder', 'versatile');

-- Ajout sur la table player
ALTER TABLE player ADD COLUMN kit starter_kit NOT NULL;
```

### 9.3 API

#### POST `/api/farms` (mise à jour)
```json
{
  "server_id": 1,
  "region_id": 5,
  "department_id": 33,
  "prefecture_id": 142,
  "kit": "cultivator"  // "cultivator" | "breeder" | "versatile"
}
```

### 9.4 Logique métier
```
function createFarm(account_id, server_id, prefecture_id, kit):
    BEGIN TRANSACTION
    player = INSERT player (account_id, server_id, prefecture_id, kit, balance=10000000)
    
    if kit == 'cultivator':
        createVehicle(player, 'tractor_90cv', usure=50)
        createVehicle(player, 'plough_4', usure=40)
        createVehicle(player, 'rotary_harrow_3m', usure=40)
        createVehicle(player, 'seeder_3m', usure=40)
        createVehicle(player, 'spreader_12m', usure=40)
        createVehicle(player, 'sprayer_12m', usure=40)
        createVehicle(player, 'harvester_280cv', usure=60)
        createVehicle(player, 'trailer_10t', usure=40)
        createVehicle(player, 'flatbed_6t', usure=40)
        createBuilding(player, 'hangar', 100, level=1)
        createBuilding(player, 'silo', 20)
        createBuilding(player, 'warehouse', 50)
    
    elif kit == 'breeder':
        createVehicle(player, 'tractor_80cv', usure=50)
        createVehicle(player, 'trailer_10t', usure=40)
        createVehicle(player, 'flatbed_6t', usure=40)
        createVehicle(player, 'livestock_trailer_5t', usure=40)
        createVehicle(player, 'manure_spreader_8t', usure=40)
        createVehicle(player, 'straw_blower', usure=40)
        createVehicle(player, 'feed_mixer', usure=40)
        createVehicle(player, 'mower_25m', usure=40)
        createBuilding(player, 'hangar', 50, level=1)
        createBuilding(player, 'stable', 100, level=1)
        createBuilding(player, 'silo', 10)
        createBuilding(player, 'manure_pit', 20)
        createBuilding(player, 'water_tank', 10000)
        createBuilding(player, 'milking_parlor', 4)
        createBuilding(player, 'milk_tank', 500)
        createAnimal(player, 'montbeliarde', 'female', age=24, count=4)
        createAnimal(player, 'montbeliarde', 'male', age=36, count=1)
    
    elif kit == 'versatile':
        createVehicle(player, 'tractor_80cv', usure=50)
        createVehicle(player, 'plough_3', usure=45)
        createVehicle(player, 'rotary_harrow_25m', usure=45)
        createVehicle(player, 'seeder_25m', usure=45)
        createVehicle(player, 'harvester_250cv', usure=65)
        createVehicle(player, 'trailer_8t', usure=45)
        createVehicle(player, 'flatbed_6t', usure=45)
        createVehicle(player, 'livestock_trailer_4t', usure=45)
        createBuilding(player, 'hangar', 80, level=1)
        createBuilding(player, 'stable', 50, level=1)
        createBuilding(player, 'silo', 15)
        createBuilding(player, 'warehouse', 30)
        createBuilding(player, 'water_tank', 5000)
        createAnimal(player, 'prim_holstein', 'female', age=24, count=2)
    
    COMMIT
```

### 9.5 Tests
```
GIVEN un nouveau joueur WHEN il choisit le kit "cultivator" THEN il reçoit 9 matériels + 3 bâtiments + 0 animaux
GIVEN un nouveau joueur WHEN il choisit le kit "breeder" THEN il reçoit 8 matériels + 7 bâtiments + 5 animaux
GIVEN un nouveau joueur WHEN il choisit le kit "versatile" THEN il reçoit 8 matériels + 5 bâtiments + 2 animaux
GIVEN un joueur existant WHEN il tente de recréer une ferme THEN erreur 409 "Ferme déjà existante"
GIVEN un joueur WHEN il envoie kit="invalid" THEN erreur 400 validation
```

---

## Feature 10 — Reset Password

> Ajouté suite à la réunion plénière finale (M5/B1) — Sprint 03

### 10.1 Description

Flow « mot de passe oublié » : le joueur demande un lien de réinitialisation par email. Le token est à usage unique et expire après 1 heure.

### 10.2 Schéma BDD

```sql
CREATE TABLE password_reset_token (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id  UUID NOT NULL REFERENCES account(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL UNIQUE,
  expires_at  TIMESTAMPTZ NOT NULL DEFAULT now() + INTERVAL '1 hour',
  used_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_prt_account ON password_reset_token(account_id);
CREATE INDEX idx_prt_expires ON password_reset_token(expires_at) WHERE used_at IS NULL;
```

### 10.3 API Endpoints

#### POST `/api/auth/forgot-password`

```
Request:
{ "email": "joueur@example.com" }

Logique:
- Chercher le compte par email
- Si inexistant → 200 (pas de leak d'info)
- Sinon : générer token, hasher (sha256), stocker, envoyer email avec lien
- Rate limit : 3 requêtes par heure par email

Response 200:
{ "message": "Si un compte existe, un email a été envoyé." }

Erreurs:
  429 — Rate limit
```

#### POST `/api/auth/reset-password`

```
Request:
{
  "token": "plain-token-from-email",
  "new_password": "NouveauMotDePasse1"
}

Logique:
- Hasher le token, chercher en BDD
- Vérifier : exists, used_at IS NULL, expires_at > now()
- Valider new_password (mêmes règles que register)
- Mettre à jour password_hash, marquer token used_at = now()
- Révoquer tous les refresh tokens du compte (force reconnexion)

Response 200:
{ "success": true }

Erreurs:
  400 — Password trop faible
  404 — Token invalide ou expiré
  410 — Token déjà utilisé
```

### 10.4 Tests

```
GIVEN un email existant WHEN POST /forgot-password THEN 200 + email envoyé avec token
GIVEN un email inexistant WHEN POST /forgot-password THEN 200 (pas de leak)
GIVEN un token valide + password fort WHEN POST /reset-password THEN password changé + refresh tokens révoqués
GIVEN un token expiré (>1h) WHEN POST /reset-password THEN 404
GIVEN un token déjà utilisé WHEN POST /reset-password THEN 410
GIVEN un password faible WHEN POST /reset-password THEN 400
GIVEN 4 requêtes /forgot-password en 1h WHEN 4e requête THEN 429
```
