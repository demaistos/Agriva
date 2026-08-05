# 🌾 Cultivia — Simulateur Agricole Multijoueur

> Cultivez votre empire agricole. De la graine au marché.

## Démarrage rapide

```bash
# Infrastructure
docker compose up -d          # PostgreSQL + PgBouncer + Redis

# Développement
npm install                   # Installe tous les workspaces
npm run dev                   # Lance server + client + worker

# Seeds
npm run db:migrate            # Applique les migrations
npm run db:seed               # Charge les données de référence

# Tests
npm run test                  # Unit + intégration

# Flow Editor (visualisation des 199 flows (138 MVP))
npm run flows                 # → http://localhost:5555
```

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Client    │────▶│    Server    │────▶│  PostgreSQL  │
│  Vue 3 +    │     │  Fastify +   │     │  152 tables  │
│  Pinia      │◀────│  TypeScript  │◀────│  PgBouncer   │
│  :5173      │ WS  │  :3001       │     │  :6432       │
└─────────────┘     └──────┬───────┘     └─────────────┘
                           │
                    ┌──────▼───────┐     ┌─────────────┐
                    │    Worker    │     │    Redis     │
                    │  BullMQ +   │────▶│  Cache +     │
                    │  Cron ticks  │     │  Sessions    │
                    └──────────────┘     │  :6379       │
                                        └─────────────┘
```

## Chiffres clés

| Métrique | Valeur |
|----------|--------|
| Flows de gameplay | 199 (138 MVP + 61 post-MVP) |
| Boucles de gameplay | 8 |
| Tables SQL | 143 |
| Types véhicules | 90 (marques réelles) |
| Types bâtiments | 30 |
| Cultures | 24 |
| Espèces animales | 16 |
| Codes erreur | ~140 |

## Structure du projet

```
src/
├── server/          # API Fastify + TypeScript
├── client/          # Vue 3 + Vite + Pinia
├── worker/          # BullMQ + cron ticks (24 étapes)
└── shared/          # Types partagés, enums, contracts

scripts/seed/        # 14 fichiers SQL (données de référence)
tools/flow-editor/   # Visualisation interactive des flows
docs/                # 78 documents (voir docs/INDEX.md)
```

## Documentation

Tout commence par **[docs/INDEX.md](docs/INDEX.md)** — index complet avec ordre de lecture.

| Document | Description |
|----------|------------|
| [BOUCLES_GAMEPLAY.md](docs/03-specs/BOUCLES_GAMEPLAY.md) | 8 boucles détaillées (OÙ/VOIT/SAISIT/RÉSULTAT) |
| [ACTION_FLOW_REGISTRY.yaml](docs/03-specs/ACTION_FLOW_REGISTRY.yaml) | 199 flows (138 MVP) (source de vérité) |
| [MATRICE_ESPECES.md](docs/03-specs/MATRICE_ESPECES.md) | Transport/bâtiment/production par espèce |
| [CONTRIBUTING.md](docs/CONTRIBUTING.md) | Bonnes pratiques et checklist |
| [01_DATA_MODEL.md](docs/02-architecture/01_DATA_MODEL.md) | 152 tables SQL |

## Stack technique

- **Backend :** Fastify, TypeScript, PostgreSQL 17, PgBouncer, Redis 7
- **Frontend :** Vue 3 (Composition API), Vite, Pinia, CSS custom
- **Worker :** BullMQ, node-cron
- **Tests :** Vitest, Supertest, Playwright
- **Infra :** Docker Compose, GitHub Actions CI

## Licence

Projet privé.
