# 🌿 Verdura

Encyclopédie du Potager & Fruitier — API REST + frontend SPA avec workflow utilisateur/admin, photos, multi-langue FR/EN, zones USDA, calendrier personnalisé, comparateur, monitoring.

## Prérequis

- Node.js 18+
- Docker

## Installation rapide

```bash
npm install
npm run setup    # Lance PostgreSQL + init DB + seed data
```

## Lancement

```bash
# Tout via Docker (recommandé)
docker-compose up -d --build

# Ou manuellement :
npm run dev        # Backend (port 3000)
npm run frontend   # Frontend (port 3001)
npm start          # Les deux ensemble
```

| Service    | URL                    |
|------------|------------------------|
| Frontend   | http://localhost:3001   |
| API        | http://localhost:3000   |
| PostgreSQL | localhost:5433         |

## Authentification

### Inscription / Connexion

Le frontend propose un formulaire d'inscription/connexion dans le header.

- **Inscription** : `POST /api/auth/register` — pseudo + email + mot de passe → crée un compte + génère une clé API `vrd_...`
- **Connexion** : `POST /api/auth/login` — email + mot de passe → retourne le profil + la clé API
- **Régénérer clé** : `POST /api/auth/regenerate` — email + mot de passe → nouvelle clé API

Les mots de passe sont hashés avec **bcrypt** (coût 10). Validation email format + longueur inputs.

```bash
# Inscription
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"monuser","email":"mon@email.com","password":"monpass"}'

# Connexion
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"mon@email.com","password":"monpass"}'
```

### Comptes de test (seed)

| Email | Mot de passe | Rôle | Clé API |
|-------|-------------|------|---------|
| `admin@verdura.local` | `admin` | admin | `admin-key-dev-000000` |
| `marie@verdura.local` | `marie` | user | `user-key-marie-111111` |
| `jean@verdura.local` | `jean` | user | `user-key-jean-222222` |
| `sophie@verdura.local` | `sophie` | user | `user-key-sophie-333333` |

## API Endpoints

Toutes les routes (sauf `/api/auth/*`) nécessitent le header `x-api-key`.

### Auth (public)
- `POST /api/auth/register` — Inscription (pseudo + email + password → user + clé API)
- `POST /api/auth/login` — Connexion (email + password → user + clé API)
- `POST /api/auth/regenerate` — Régénérer clé API (email + password → nouvelle clé)

### Plantes (admin pour écriture)
- `GET /api/plants` — Liste (params: `search`, `type`, `lang`)
- `GET /api/plants/:id` — Détail
- `POST /api/plants` — Créer (admin)
- `PUT /api/plants/:id` — Modifier (admin)
- `DELETE /api/plants/:id` — Supprimer (admin)

### Variétés
- `GET /api/varieties` — Liste (params: `search`, `plant_id`, `status`, `tag`, `lang`)
- `GET /api/varieties/:id` — Détail avec conditions, calendrier et pseudo soumetteur
- `POST /api/varieties` — Soumettre (pending pour user, approved pour admin)
- `PUT /api/varieties/:id` — Modifier (admin ou auteur)
- `PATCH /api/varieties/:id/status` — Approuver/rejeter (admin)
- `DELETE /api/varieties/:id` — Supprimer (admin ou auteur)

### Conditions / Calendrier / Compagnonnage
- `GET /api/growing-conditions` — Toutes les conditions (batch)
- `GET/PUT /api/growing-conditions/:variety_id`
- `GET /api/calendar` — Tous les calendriers (batch)
- `GET/PUT /api/calendar/:variety_id`
- `GET/PUT /api/companions/:plant_id`

### Zones USDA
- `GET /api/zones` — Toutes les zones (28+ villes en base)
- `GET /api/zones/search?q=` — Recherche par code postal ou nom de ville (fallback geo.api.gouv.fr avec upsert en base)

### Utilisateurs
- `GET /api/users` — Liste (admin)
- `GET /api/users/:id` — Profil (avec zone USDA et langue)
- `PUT /api/users/:id/profile` — Modifier pseudo, zone USDA et langue
- `PATCH /api/users/:id/status` — Activer/désactiver (admin)
- `POST /api/users/:id/favorites` — Ajouter favori
- `DELETE /api/users/:id/favorites/:variety_id` — Retirer favori
- `PUT /api/users/:id/garden` — Notes de jardin
- `GET /api/users/:id/notifications` — Notifications
- `PATCH /api/users/:id/notifications/read` — Marquer comme lues

### Photos
- `POST /api/photos/varieties/:id` — Upload (multipart, max 5MB, jpeg/png/webp)
- `GET /api/photos/:filename` — Photo originale (path traversal protégé)
- `GET /api/photos/thumbs/:filename` — Miniature

### API Keys (admin)
- `GET /api/api-keys` — Liste
- `POST /api/api-keys` — Créer
- `DELETE /api/api-keys/:key` — Supprimer

### Admin
- `GET /api/admin/stats` — Dashboard (query unique optimisée)
- `GET /api/admin/monitoring` — Métriques temps réel (uptime, requêtes, status codes, routes, erreurs, mémoire)
- `GET /api/admin/history` — Historique paginé avec pseudo (params: `limit`, `offset`, `search`)
- `GET /api/admin/export/json` — Export JSON
- `GET /api/admin/export/csv/plants` — Export CSV plantes
- `GET /api/admin/export/csv/varieties` — Export CSV variétés
- `POST /api/admin/import/csv/plants` — Import CSV

## Frontend

SPA multi-langue (FR/EN) avec les pages :

- **Accueil** — Hero avec stats, variétés récentes, variétés populaires avec placeholders visuels (gradient + emoji par type), accès rapide par type de plante (légume/fruit/herbe)
- **Explorer** — Grille de variétés : barre de recherche texte (debounce 200ms), filtres latéraux (ensoleillement, arrosage, sol, plante, tags, goût, résistance, période de semis), catégories en pills, tri par colonnes, pagination "Load more", bouton ★ favori et ⚖️ comparer sur chaque card
- **Détail variété** — Layout bento : hero + photo + conditions de culture + profil + tags + calendrier visuel + compagnonnage. Mode édition inline pour admin et auteur. Bouton 🔗 Partager (copie URL). URL partageable `#variety/ID`. Page 404 si variété introuvable
- **Favoris** — Page dédiée avec layout explore : sidebar filtres (plante, ensoleillement, arrosage), recherche texte, tri par colonnes, groupement par plante, suppression rapide ✕, badge compteur dans la nav
- **Comparateur** — Sélection ⚖️ de 2-4 variétés depuis l'explore, barre flottante, tableau côte à côte (conditions, rendement, goût, résistance, tags)
- **Calendrier** — Charge automatiquement la zone du profil utilisateur. Recherche par code postal ou ville → zone USDA, dates de gel, calendrier ajusté. Filtre par plante, tri par nom/semis/récolte
- **Profil** — Accessible via l'avatar/nom en haut à droite. Modifier pseudo, zone USDA (auto-sauvegarde communes via geo.api.gouv.fr), langue par défaut (FR/EN), clé API, carnet de jardin (ajout/suppression de notes avec noms de variétés cliquables), notifications avec badge sur l'avatar
- **Admin** (admin uniquement) — Onglets : Soumissions, Utilisateurs, Plantes (CRUD admin), Historique, Export/Import, **Monitoring** (uptime, requêtes, temps moyen, mémoire, status codes, top routes, erreurs récentes, requêtes live auto-refresh 5s)
- **Recherche globale** — Modal ⌘K avec résultats instantanés dans noms, descriptions, tags, conditions, goût, résistance, type de plante
- **Auth** — Inscription (pseudo + email + mot de passe) / Connexion (email + mot de passe)
- **Toast notifications** — Feedback visuel animé sur favoris, profil, notes

## Workflow soumission

1. Un utilisateur soumet une variété → statut `pending`
2. Max 10 soumissions pending par utilisateur
3. Un admin voit la fiche complète, peut l'éditer, puis approuver (`approved`) ou rejeter (`rejected`) → notification à l'auteur
4. Les admins créent directement en `approved`

## Sécurité

- **Helmet** — headers de sécurité (X-Frame-Options, X-Content-Type-Options, etc.)
- **CORS** — origines restreintes, configurable via `CORS_ORIGINS` en env
- **Mots de passe** hashés avec **bcrypt** (coût 10)
- **Authentification** par clé API (`x-api-key` header) avec cache 60s
- **Rate limiting** global (300 requêtes / 15 min via `express-rate-limit`)
- **Quotas** par utilisateur (100 requêtes pour users, illimité pour admin)
- **Sanitization XSS** sur tous les inputs, arrays et query params (middleware `xss`)
- **Validation inputs** — email regex, username 2-50 chars, password 4-100 chars, clé API max 100 chars
- **Path traversal** — protection sur les routes photos (regex whitelist)
- **Plants CRUD** — restreint admin (POST/PUT/DELETE)
- **asyncHandler** — toutes les routes async wrappées, erreurs catchées vers le error handler global
- **Error handler** — stack trace loggé pour 500, message générique renvoyé au client
- **404 API** — routes inconnues retournent `{ error: "Endpoint not found" }`
- Rôles : `user` (lecture + soumission) / `admin` (tout)

## Logging & Monitoring

- **Request logger** — chaque requête loggée : `[timestamp] METHOD /path STATUS ms user:ID`
- **Auth logs** — register, login, failed login, key regeneration
- **Error logs** — stack trace complet pour les 500
- **Métriques en mémoire** — requêtes totales, status codes, temps de réponse moyen, top routes, erreurs récentes, mémoire RSS
- **Dashboard admin** — onglet Monitoring avec auto-refresh 5s

## Performance

- **Pool PG** — max 20 connexions, idle timeout 30s, connect timeout 5s
- **Cache API keys** — Map en mémoire avec TTL 60s, invalidation sur régénération
- **Usage count** — fire-and-forget (non-bloquant)
- **Admin stats** — 1 query unique au lieu de 6
- **Admin history** — `COUNT(*) OVER()` window function au lieu de 2 queries
- **Batch endpoints** — `GET /api/growing-conditions` et `GET /api/calendar` pour charger tout en 1 requête
- **12 index DB** — sur toutes les foreign keys et colonnes de recherche fréquentes
- **Frontend** — debounce recherche, état local pour favoris (pas de re-fetch)

## Multi-langue

- Champs `name_fr`/`name_en`, `description_fr`/`description_en` sur chaque entité
- Frontend : sélecteur FR/EN dans le header
- Langue par défaut configurable dans le profil utilisateur (stockée en base)
- API : paramètre `lang=fr|en` pour le tri/recherche

## Zones USDA

28 villes françaises avec zones USDA, dates de gel et durée de saison. Recherche par code postal (préfixe 2 chiffres) ou nom de ville. Stockées en base PostgreSQL (table `zones`).

Pour les communes non présentes en base, fallback automatique sur l'API `geo.api.gouv.fr` (35 000+ communes) avec calcul de zone USDA par latitude. Les communes recherchées sont automatiquement sauvegardées en base (upsert) pour permettre leur sélection dans le profil utilisateur.

## Tests

```bash
# Tests API backend (34 tests)
npm test

# Tests UI Playwright (26 tests)
npm run test:ui

# Tout
npm test && npm run test:ui
```

### Couverture des tests

**API (34 tests)** : Auth, CRUD plants, CRUD varieties, workflow soumission/validation, users, favoris, garden notes, admin dashboard/historique/export, quotas, upload/download photos.

**Playwright (26 tests)** : Home, explore (cards, filtres, tri, pills), détail variété, navigation, recherche globale (par nom et par condition), calendrier avec zones, langue FR/EN, admin dashboard, favoris (ajout, filtres, suppression), profil via avatar, liens partagés (#variety/ID), comparateur (sélection, tableau).

## Données

Le projet contient **28913 variétés réelles** de **143 plantes** issues de sources multiples :

### Sources de données
- **516 variétés manuelles** (fichiers 01-13) — descriptions complètes FR/EN, conditions, calendriers
- **361 variétés** — Ferme de Sainte Marthe (catalogue bio français)
- **5996 variétés** — Wikipedia FR (cépages, pommes, pommes de terre)
- **4956 variétés** — Wikipedia EN (listes de cultivars)
- **5642 variétés** — Wikipedia EN (sections #Cultivars — 28 plantes)
- **9740 variétés** — Wikipedia FR+EN (deep research — tropicaux, épices, céréales)
- **60 variétés** — Au Jardin
- **56 variétés** — Planfor (pépinière)
- **541 variétés** — Promesse de Fleurs (306 pages scrapées)
- **17 variétés** — Camérisier (baie de mai)

### Commandes
```bash
npm run db:full      # Reset + import toutes les données réelles
npm run db:reset     # Reset DB + seed de base (65 variétés)
npm run db:import    # Import des fichiers JSON (sans reset)
```

### Le seed de base génère :
- 28 zones USDA (villes françaises)
- 4 utilisateurs avec clés API (mots de passe bcrypt)
- 16 plantes avec cycle de vie (annuelle/bisannuelle/vivace)
- 65 variétés avec descriptions FR/EN, rendement, goût, résistance, tags
- 60 fiches conditions de culture
- 60 calendriers semis/récolte
- 16 fiches compagnonnage

## Déploiement AWS

Le template CloudFormation est dans `cloudformation/template.yml`. Il crée :
- VPC + subnets privés
- RDS PostgreSQL (db.t3.micro, 20GB, chiffré)
- Lambda + API Gateway HTTP
- S3 frontend (website) + CloudFront
- S3 photos (accès restreint)
- Secrets Manager pour les credentials DB

```bash
aws cloudformation deploy \
  --template-file cloudformation/template.yml \
  --stack-name verdura \
  --parameter-overrides DBPassword=<password> AdminApiKey=<key> \
  --capabilities CAPABILITY_IAM
```

## Structure

```
├── backend/
│   ├── server.js              # Express + helmet + CORS + rate limit
│   ├── db/
│   │   ├── pool.js            # PG pool (max 20, timeouts)
│   │   ├── init.js            # Schema (10 tables, 12 index)
│   │   ├── seed.js            # Test data (bcrypt passwords)
│   │   ├── import.js          # Import JSON data files
│   │   └── data/              # 18 fichiers JSON de variétés réelles
│   ├── middleware/
│   │   ├── auth.js            # API key auth + cache 60s + quotas + asyncHandler
│   │   ├── sanitize.js        # XSS sanitization (body, arrays, query)
│   │   ├── logger.js          # Request logger + métriques en mémoire
│   │   └── history.js         # Change tracking
│   ├── routes/
│   │   ├── auth.js            # Register / Login / Regenerate (bcrypt + validation)
│   │   ├── plants.js          # CRUD (admin pour écriture)
│   │   ├── varieties.js       # CRUD + workflow + notifications
│   │   ├── growing_conditions.js  # Batch + par variété
│   │   ├── calendar.js        # Batch + par variété
│   │   ├── companions.js
│   │   ├── users.js           # Profil + favoris + notes + notifications
│   │   ├── zones.js           # Zones USDA + fallback geo.api.gouv.fr (upsert)
│   │   ├── api_keys.js
│   │   ├── photos.js          # Upload + path traversal protection
│   │   └── admin.js           # Stats + monitoring + historique + export/import
│   └── tests/
│       └── api.test.js        # 49 tests API
├── frontend/
│   ├── index.html
│   ├── style.css              # Responsive (768px + 480px)
│   ├── app.js                 # SPA + favoris + comparateur + toasts
│   ├── i18n.js                # FR/EN
│   └── tests/
│       └── ui.spec.ts         # 26 tests Playwright
├── cloudformation/
│   └── template.yml
├── photos/                    # Local photo storage
├── CONTEXT.md                 # Contexte pour redémarrage Kiro
├── docker-compose.yml
├── Dockerfile
├── playwright.config.ts
├── .env
└── package.json
```
