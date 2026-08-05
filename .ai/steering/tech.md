# Tech — Agriva

## Stack technique

| Couche | Technologie | Justification |
|--------|-------------|---------------|
| Runtime | Node.js 20+ | Écosystème riche, TypeScript natif |
| Langage | TypeScript 5.x (strict) | Types, maintenabilité, DX |
| Framework backend | Fastify | Performance, plugins, schema validation |
| ORM | Prisma | Type-safe, migrations, DX |
| Base de données | PostgreSQL 16+ | JSONB, performance, fiabilité |
| Cache/Queue | Redis | Pub/sub ticks, cache sessions |
| Frontend | React 19 + TypeScript | Composants, écosystème |
| Build frontend | Vite | Rapidité, HMR |
| Tests unitaires | Vitest | Rapide, compatible Jest API |
| Tests e2e | Playwright | Cross-browser, fiable |
| Infra dev | Docker Compose | Reproductible |
| Infra prod | VPS (Hetzner/OVH) | Coût maîtrisé |
| Auth | JWT (access 15min + refresh 30j) | Stateless, scalable |
| Validation | Zod | Runtime validation, type inference |
| Temps réel | WebSocket (ws/Socket.io) | Chat, notifications |

## Patterns architecturaux

- **Monolithe modulaire** : 1 module = 1 domaine, interfaces claires
- **Repository pattern** : accès données isolé
- **Service layer** : logique métier pure, testable
- **Result type** : erreurs métier sans exceptions
- **Event-driven** : événements entre modules (découplage)
- **Tick-based simulation** : worker Redis traite les ticks

## Outils de développement

- Git (GitHub)
- ESLint + Prettier
- Husky (pre-commit hooks)
- GitHub Actions (CI)
- Prisma Studio (visualisation BDD)

## Contraintes

- Pas de `any` en TypeScript
- Pas de logique métier dans les controllers
- Pas de dépendances sans justification
- Tests obligatoires pour tout code métier
- Pas de microservices — monolithe modulaire uniquement
