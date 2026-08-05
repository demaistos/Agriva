# Agriva — Bonnes Pratiques de Développement

> Date : 2026-08-04
> Statut : Actif — Document vivant
> Auteur : agent:architecte

---

## Table des matières

1. [Conventions de code](#1-conventions-de-code)
2. [Architecture](#2-architecture)
3. [Base de données](#3-base-de-données)
4. [Tests](#4-tests)
5. [API](#5-api)
6. [Frontend](#6-frontend)
7. [Simulation (tick engine)](#7-simulation-tick-engine)
8. [Sécurité](#8-sécurité)
9. [Git & CI](#9-git--ci)
10. [Performance](#10-performance)
11. [Documentation](#11-documentation)
12. [Patterns & Anti-patterns](#12-patterns--anti-patterns)

---

## 1. Conventions de code

### 1.1 Nommage

| Élément | Convention | Exemple |
|---------|-----------|---------|
| Fichiers | kebab-case.ts | `crop-growth.service.ts` |
| Classes | PascalCase | `CropGrowthService` |
| Interfaces/Types | PascalCase (pas de préfixe I) | `CropState`, `GrowthResult` |
| Fonctions/méthodes | camelCase | `calculateYield()` |
| Constantes | UPPER_SNAKE_CASE | `MAX_FIELD_SIZE` |
| Variables | camelCase | `currentGrowthStage` |
| Enums | PascalCase (membres aussi) | `CropStatus.Growing` |
| Modules (dossiers) | kebab-case | `crop-management/` |
| Tests | `*.test.ts` ou `*.spec.ts` | `crop-growth.service.test.ts` |

### 1.2 Structure d'un fichier TypeScript

```typescript
// 1. Imports externes (node_modules)
import { FastifyInstance } from 'fastify';
import { z } from 'zod';

// 2. Imports internes (autres modules)
import { EventBus } from '@/shared/event-bus';
import { Result } from '@/shared/result';

// 3. Imports locaux (même module)
import { CropRepository } from './crop.repository';
import { CropState, GrowthParams } from './crop.types';

// 4. Constantes
const GROWTH_RATE_MULTIPLIER = 1.2;

// 5. Types locaux au fichier (si non exportés)
type InternalCalcResult = { yield: number; quality: number };

// 6. Implémentation
export class CropGrowthService {
  // ...
}
```

### 1.3 Imports — règles

- **Toujours utiliser des path aliases** : `@/modules/...`, `@/shared/...`
- **Pas d'imports circulaires** — si 2 modules dépendent l'un de l'autre, passer par les events
- **Pas d'import \*** — toujours nommer ce qu'on importe
- **Barrel exports** (`index.ts`) uniquement à la racine d'un module pour exposer l'API publique

```typescript
// ✅ Correct
import { CropService } from '@/modules/crop';
import { Result, AppError } from '@/shared/result';

// ❌ Interdit
import * as CropModule from '../../../modules/crop/crop.service';
```

### 1.4 Types — règles strictes

```typescript
// ✅ TypeScript strict — tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "exactOptionalPropertyTypes": true
  }
}
```

- **Jamais `any`** — utiliser `unknown` si le type est vraiment inconnu
- **Jamais `as` pour caster** (sauf dans les tests ou les adaptateurs de libs externes)
- **Préférer `interface` pour les objets**, `type` pour les unions/intersections
- **Marquer explicitement les retours de fonctions publiques**

```typescript
// ✅ Type de retour explicite
export function calculateGrowth(params: GrowthParams): GrowthResult {
  // ...
}

// ✅ Result type pour les erreurs métier
export function harvestCrop(cropId: string): Result<HarvestOutput, CropError> {
  // ...
}

// ❌ Pas de any
function process(data: any) { } // INTERDIT
```

### 1.5 Style et formatting

- **ESLint + Prettier** — configuration partagée, pas de discussion sur le style
- **Max 1 classe/fonction exportée par fichier** (exceptions : types groupés)
- **Fonctions < 30 lignes** — au-delà, extraire
- **Pas de commentaires évidents** — le code doit se lire seul
- **Commentaires utiles** : le "pourquoi", pas le "quoi"

```typescript
// ❌ Commentaire inutile
// Increment counter
counter++;

// ✅ Commentaire utile — explique le pourquoi
// SimAgri uses a 4-week growth cycle regardless of crop type.
// We preserve this for gameplay balance even though reality differs.
const GROWTH_CYCLE_WEEKS = 4;
```

---

## 2. Architecture

### 2.1 Monolithe modulaire — principes

Chaque module = 1 domaine métier. Les modules communiquent par **events**, jamais par import direct de services internes.

```
src/
├── modules/
│   ├── auth/
│   ├── player/
│   ├── crop/
│   ├── livestock/
│   ├── equipment/
│   ├── market/
│   ├── building/
│   └── ...
├── shared/           # Code partagé (result, events, utils)
├── infrastructure/   # DB, cache, config, server setup
└── main.ts
```

### 2.2 Structure d'un module

```
src/modules/crop/
├── __tests__/
│   ├── crop.service.test.ts        # Tests unitaires
│   ├── crop.repository.test.ts     # Tests intégration DB
│   └── crop.e2e.test.ts            # Tests API e2e
├── crop.types.ts          # Types, interfaces, enums du domaine
├── crop.schemas.ts        # Schemas Zod (validation input API)
├── crop.service.ts        # Logique métier
├── crop.repository.ts     # Accès données (Prisma)
├── crop.controller.ts     # Routes Fastify (thin layer)
├── crop.events.ts         # Events émis/écoutés
├── crop.errors.ts         # Erreurs métier spécifiques
├── crop.constants.ts      # Constantes du domaine
└── index.ts               # Barrel export (API publique)
```

### 2.3 Couches et responsabilités

```
┌─────────────────────────────────────────┐
│  Controller (routes)                     │  ← Validation, sérialisation, HTTP
├─────────────────────────────────────────┤
│  Service (logique métier)               │  ← Règles de jeu, calculs, orchestration
├─────────────────────────────────────────┤
│  Repository (données)                   │  ← Queries Prisma, mapping DB → domain
├─────────────────────────────────────────┤
│  Infrastructure (DB, Redis, etc.)       │  ← Prisma client, Redis client
└─────────────────────────────────────────┘
```

**Règles strictes :**
- Le **Controller** ne contient AUCUNE logique métier — il appelle le service et retourne le résultat
- Le **Service** ne connaît PAS Prisma — il utilise le repository
- Le **Repository** ne connaît PAS le HTTP — il reçoit/retourne des types domaine
- Les **Events** traversent les couches — un service peut émettre et écouter

### 2.4 Services — logique métier pure

```typescript
// crop.service.ts
import { Result, ok, err } from '@/shared/result';
import { EventBus } from '@/shared/event-bus';
import { CropRepository } from './crop.repository';
import { CropState, PlantParams, HarvestResult } from './crop.types';
import { CropError } from './crop.errors';

export class CropService {
  constructor(
    private readonly repository: CropRepository,
    private readonly eventBus: EventBus,
  ) {}

  async plant(params: PlantParams): Promise<Result<CropState, CropError>> {
    const field = await this.repository.getField(params.fieldId);

    if (!field) {
      return err(CropError.FieldNotFound);
    }

    if (field.currentCrop) {
      return err(CropError.FieldAlreadyPlanted);
    }

    const crop = await this.repository.createCrop({
      fieldId: params.fieldId,
      speciesId: params.speciesId,
      plantedAt: params.gameDate,
    });

    this.eventBus.emit('crop.planted', {
      cropId: crop.id,
      playerId: params.playerId,
      speciesId: params.speciesId,
    });

    return ok(crop);
  }
}
```

### 2.5 Controllers — couche mince

```typescript
// crop.controller.ts
import { FastifyInstance } from 'fastify';
import { CropService } from './crop.service';
import { plantSchema, harvestSchema } from './crop.schemas';

export function cropController(
  fastify: FastifyInstance,
  service: CropService,
): void {
  fastify.post('/crops/plant', {
    schema: { body: plantSchema },
    handler: async (request, reply) => {
      const result = await service.plant({
        ...request.body,
        playerId: request.user.id,
      });

      if (!result.ok) {
        return reply.status(400).send({ error: result.error });
      }

      return reply.status(201).send(result.value);
    },
  });
}
```

### 2.6 Events — communication inter-modules

```typescript
// crop.events.ts
import { DomainEvent } from '@/shared/event-bus';

export interface CropPlantedEvent extends DomainEvent {
  type: 'crop.planted';
  payload: {
    cropId: string;
    playerId: string;
    speciesId: string;
  };
}

export interface CropHarvestedEvent extends DomainEvent {
  type: 'crop.harvested';
  payload: {
    cropId: string;
    playerId: string;
    yieldKg: number;
    quality: number;
  };
}

// Type union des events du module
export type CropEvent = CropPlantedEvent | CropHarvestedEvent;
```

```typescript
// Dans le module market — écoute un event du module crop
// market.service.ts
export class MarketService {
  constructor(private readonly eventBus: EventBus) {
    this.eventBus.on('crop.harvested', this.handleCropHarvested.bind(this));
  }

  private async handleCropHarvested(event: CropHarvestedEvent): Promise<void> {
    // Update supply data for the market
    await this.updateSupply(event.payload.speciesId, event.payload.yieldKg);
  }
}
```

### 2.7 Result type — gestion des erreurs métier

```typescript
// shared/result.ts
export type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

export function ok<T>(value: T): Result<T, never> {
  return { ok: true, value };
}

export function err<E>(error: E): Result<never, E> {
  return { ok: false, error };
}
```

**Règle : les exceptions sont pour les erreurs techniques (crash), les Result pour les erreurs métier (prévisibles).**

```typescript
// ✅ Erreur métier → Result
return err(CropError.InsufficientSeeds);

// ✅ Erreur technique → exception (catch global)
throw new Error('Database connection lost');
```



---

## 3. Base de données

### 3.1 Prisma — conventions

```prisma
// schema.prisma — conventions de nommage
model Crop {
  id          String      @id @default(uuid())
  fieldId     String      @map("field_id")
  speciesId   String      @map("species_id")
  plantedAt   DateTime    @map("planted_at")
  harvestedAt DateTime?   @map("harvested_at")
  growthStage Int         @default(0) @map("growth_stage")
  quality     Float       @default(0)
  createdAt   DateTime    @default(now()) @map("created_at")
  updatedAt   DateTime    @updatedAt @map("updated_at")

  field       Field       @relation(fields: [fieldId], references: [id])
  species     CropSpecies @relation(fields: [speciesId], references: [id])

  @@map("crops")
  @@index([fieldId])
  @@index([speciesId])
}
```

**Conventions :**
- Modèles en **PascalCase singulier** : `Crop`, `Field`, `Player`
- Colonnes DB en **snake_case** via `@map()`
- Table en **snake_case pluriel** via `@@map()`
- Toujours `id`, `createdAt`, `updatedAt`
- UUID par défaut pour les IDs
- Index explicites sur les clés étrangères

### 3.2 Migrations

```bash
# Créer une migration
npx prisma migrate dev --name add-crop-quality-field

# Appliquer en production
npx prisma migrate deploy
```

**Règles :**
- **1 migration = 1 changement logique** (pas de méga-migration)
- **Nommer clairement** : `add-crop-quality-field`, `create-market-table`
- **Jamais modifier une migration déjà commitée** — créer une nouvelle migration
- **Tester la migration sur une DB vide** avant de commit
- **Migrations destructives** (DROP, ALTER colonne NOT NULL) : toujours en 2 étapes
  1. Migration qui ajoute/prépare
  2. Migration qui supprime (après déploiement et vérification)

### 3.3 Seeds

```typescript
// prisma/seeds/crop-species.seed.ts
import { PrismaClient } from '@prisma/client';

export async function seedCropSpecies(prisma: PrismaClient): Promise<void> {
  const species = [
    { id: 'wheat-soft', name: 'Blé tendre', category: 'cereal', growthWeeks: 36 },
    { id: 'corn-grain', name: 'Maïs grain', category: 'cereal', growthWeeks: 24 },
    { id: 'rapeseed', name: 'Colza', category: 'oilseed', growthWeeks: 44 },
  ];

  for (const sp of species) {
    await prisma.cropSpecies.upsert({
      where: { id: sp.id },
      update: sp,
      create: sp,
    });
  }
}
```

**Règles :**
- Seeds **idempotents** (utiliser `upsert`)
- Seeds **par domaine** (1 fichier par module)
- Seeds de données de référence séparés des seeds de test
- Pas de seeds qui dépendent d'un ordre d'exécution non explicite

### 3.4 Repository — requêtes

```typescript
// crop.repository.ts
import { PrismaClient, Crop as PrismaCrop } from '@prisma/client';
import { CropState, CropFilter } from './crop.types';

export class CropRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async findById(id: string): Promise<CropState | null> {
    const crop = await this.prisma.crop.findUnique({
      where: { id },
      include: { species: true },
    });

    return crop ? this.toDomain(crop) : null;
  }

  async findByPlayer(
    playerId: string,
    filter: CropFilter,
  ): Promise<CropState[]> {
    const crops = await this.prisma.crop.findMany({
      where: {
        field: { playerId },
        ...(filter.status && { status: filter.status }),
      },
      include: { species: true },
      orderBy: { plantedAt: 'desc' },
      take: filter.limit,
      skip: filter.offset,
    });

    return crops.map(this.toDomain);
  }

  // Mapper DB → Domain (toujours)
  private toDomain(crop: PrismaCrop & { species: any }): CropState {
    return {
      id: crop.id,
      fieldId: crop.fieldId,
      speciesName: crop.species.name,
      growthStage: crop.growthStage,
      quality: crop.quality,
      plantedAt: crop.plantedAt,
    };
  }
}
```

**Règles :**
- Le repository **mappe toujours** de DB vers types domaine (pas de fuite Prisma)
- **Pas de requêtes dans les services** — tout passe par le repository
- **Pagination par défaut** : `take` + `skip` sur toute requête listant des données
- **Select explicite** pour les requêtes de performance (pas de `SELECT *`)

### 3.5 Transactions

```typescript
// Quand plusieurs écritures doivent être atomiques
async transferEquipment(
  fromPlayerId: string,
  toPlayerId: string,
  equipmentId: string,
  price: number,
): Promise<Result<void, TransferError>> {
  try {
    await this.prisma.$transaction(async (tx) => {
      // 1. Vérifier le solde
      const buyer = await tx.player.findUnique({ where: { id: toPlayerId } });
      if (!buyer || buyer.balance < price) {
        throw new InsufficientFundsError();
      }

      // 2. Débiter l'acheteur
      await tx.player.update({
        where: { id: toPlayerId },
        data: { balance: { decrement: price } },
      });

      // 3. Créditer le vendeur
      await tx.player.update({
        where: { id: fromPlayerId },
        data: { balance: { increment: price } },
      });

      // 4. Transférer l'équipement
      await tx.equipment.update({
        where: { id: equipmentId },
        data: { ownerId: toPlayerId },
      });
    });

    return ok(undefined);
  } catch (error) {
    if (error instanceof InsufficientFundsError) {
      return err(TransferError.InsufficientFunds);
    }
    throw error; // Erreur technique → rethrow
  }
}
```

**Règles :**
- Transactions pour **toute opération multi-écritures** qui doit être atomique
- **Timeout explicite** sur les transactions longues : `$transaction(..., { timeout: 10000 })`
- **Pas de logique métier complexe** dans la transaction — préparer avant, écrire dans la transaction
- **Vérifier les deadlocks** : toujours accéder aux tables dans le même ordre

---

## 4. Tests

### 4.1 Philosophie TDD

```
1. Écrire le test (RED)
2. Écrire le minimum de code pour passer (GREEN)
3. Refactorer (REFACTOR)
4. Répéter
```

**Tout code métier a ses tests. Pas de PR sans tests.**

### 4.2 Pyramide de tests

```
        ╱╲
       ╱ E2E ╲          ← Peu (chemins critiques)
      ╱────────╲
     ╱Integration╲      ← Modéré (repository + service avec DB)
    ╱──────────────╲
   ╱  Unit Tests    ╲   ← Beaucoup (service logic, pure functions)
  ╱──────────────────╲
```

| Type | Scope | Outils | Vitesse |
|------|-------|--------|---------|
| Unit | 1 fonction/service, mocks | Vitest | < 1ms/test |
| Integration | Service + DB réelle | Vitest + TestContainers | < 500ms/test |
| E2E | API complète | Vitest + supertest | < 2s/test |
| UI E2E | Navigateur complet | Playwright | < 10s/test |

### 4.3 Tests unitaires — services

```typescript
// __tests__/crop.service.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { CropService } from '../crop.service';
import { CropRepository } from '../crop.repository';
import { EventBus } from '@/shared/event-bus';
import { CropError } from '../crop.errors';

describe('CropService', () => {
  let service: CropService;
  let repository: CropRepository;
  let eventBus: EventBus;

  beforeEach(() => {
    repository = {
      getField: vi.fn(),
      createCrop: vi.fn(),
      findById: vi.fn(),
    } as unknown as CropRepository;

    eventBus = {
      emit: vi.fn(),
      on: vi.fn(),
    } as unknown as EventBus;

    service = new CropService(repository, eventBus);
  });

  describe('plant', () => {
    it('should plant a crop on an empty field', async () => {
      // Arrange
      const field = { id: 'field-1', currentCrop: null, playerId: 'player-1' };
      const expectedCrop = { id: 'crop-1', fieldId: 'field-1', speciesId: 'wheat' };

      vi.mocked(repository.getField).mockResolvedValue(field);
      vi.mocked(repository.createCrop).mockResolvedValue(expectedCrop);

      // Act
      const result = await service.plant({
        fieldId: 'field-1',
        speciesId: 'wheat',
        playerId: 'player-1',
        gameDate: new Date('2026-03-15'),
      });

      // Assert
      expect(result.ok).toBe(true);
      if (result.ok) {
        expect(result.value.id).toBe('crop-1');
      }
      expect(eventBus.emit).toHaveBeenCalledWith('crop.planted', {
        cropId: 'crop-1',
        playerId: 'player-1',
        speciesId: 'wheat',
      });
    });

    it('should return error when field not found', async () => {
      vi.mocked(repository.getField).mockResolvedValue(null);

      const result = await service.plant({
        fieldId: 'nonexistent',
        speciesId: 'wheat',
        playerId: 'player-1',
        gameDate: new Date(),
      });

      expect(result.ok).toBe(false);
      if (!result.ok) {
        expect(result.error).toBe(CropError.FieldNotFound);
      }
    });

    it('should return error when field already planted', async () => {
      const field = { id: 'field-1', currentCrop: { id: 'existing' }, playerId: 'player-1' };
      vi.mocked(repository.getField).mockResolvedValue(field);

      const result = await service.plant({
        fieldId: 'field-1',
        speciesId: 'wheat',
        playerId: 'player-1',
        gameDate: new Date(),
      });

      expect(result.ok).toBe(false);
      if (!result.ok) {
        expect(result.error).toBe(CropError.FieldAlreadyPlanted);
      }
    });
  });
});
```

### 4.4 Tests d'intégration — repository avec DB

```typescript
// __tests__/crop.repository.test.ts
import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { PrismaClient } from '@prisma/client';
import { CropRepository } from '../crop.repository';
import { createTestDatabase, cleanDatabase } from '@/test-utils/database';

describe('CropRepository (integration)', () => {
  let prisma: PrismaClient;
  let repository: CropRepository;

  beforeAll(async () => {
    prisma = await createTestDatabase();
    repository = new CropRepository(prisma);
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  beforeEach(async () => {
    await cleanDatabase(prisma);
  });

  it('should create and retrieve a crop', async () => {
    // Seed required data
    await prisma.player.create({ data: { id: 'p1', username: 'test' } });
    await prisma.field.create({ data: { id: 'f1', playerId: 'p1', size: 10 } });
    await prisma.cropSpecies.create({ data: { id: 'wheat', name: 'Blé', growthWeeks: 36 } });

    // Act
    const crop = await repository.create({
      fieldId: 'f1',
      speciesId: 'wheat',
      plantedAt: new Date('2026-03-15'),
    });

    // Assert
    const found = await repository.findById(crop.id);
    expect(found).not.toBeNull();
    expect(found!.speciesName).toBe('Blé');
  });
});
```

### 4.5 Tests E2E — API

```typescript
// __tests__/crop.e2e.test.ts
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { createTestApp } from '@/test-utils/app';
import { FastifyInstance } from 'fastify';

describe('Crop API (e2e)', () => {
  let app: FastifyInstance;
  let authToken: string;

  beforeAll(async () => {
    app = await createTestApp();
    authToken = await getTestToken(app, 'player-1');
  });

  afterAll(async () => {
    await app.close();
  });

  it('POST /crops/plant — should plant a crop', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/api/crops/plant',
      headers: { authorization: `Bearer ${authToken}` },
      payload: {
        fieldId: 'field-1',
        speciesId: 'wheat',
      },
    });

    expect(response.statusCode).toBe(201);
    const body = JSON.parse(response.body);
    expect(body.fieldId).toBe('field-1');
    expect(body.speciesName).toBe('Blé tendre');
  });

  it('POST /crops/plant — should reject if field occupied', async () => {
    // Plant first
    await app.inject({
      method: 'POST',
      url: '/api/crops/plant',
      headers: { authorization: `Bearer ${authToken}` },
      payload: { fieldId: 'field-1', speciesId: 'wheat' },
    });

    // Plant again — should fail
    const response = await app.inject({
      method: 'POST',
      url: '/api/crops/plant',
      headers: { authorization: `Bearer ${authToken}` },
      payload: { fieldId: 'field-1', speciesId: 'corn' },
    });

    expect(response.statusCode).toBe(400);
    expect(JSON.parse(response.body).error).toBe('FIELD_ALREADY_PLANTED');
  });
});
```

### 4.6 Mocks et fixtures

```typescript
// test-utils/fixtures/player.fixture.ts
import { Player } from '@/modules/player/player.types';

export function createPlayerFixture(overrides: Partial<Player> = {}): Player {
  return {
    id: 'player-test-1',
    username: 'testplayer',
    email: 'test@example.com',
    balance: 50000,
    level: 1,
    createdAt: new Date('2026-01-01'),
    ...overrides,
  };
}

// Usage dans les tests
const richPlayer = createPlayerFixture({ balance: 1_000_000 });
const newPlayer = createPlayerFixture({ level: 1, balance: 10_000 });
```

**Règles mocks :**
- **Mocker les dépendances externes** (DB, Redis, APIs tierces) dans les tests unitaires
- **Ne PAS mocker** le code qu'on teste
- **Préférer les fixtures aux données hardcodées** dans chaque test
- **Mocker au niveau le plus haut possible** (interface, pas implémentation)

### 4.7 Coverage

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      thresholds: {
        statements: 80,
        branches: 80,
        functions: 80,
        lines: 80,
      },
      include: ['src/modules/**/*.ts'],
      exclude: ['**/*.types.ts', '**/*.schemas.ts', '**/index.ts'],
    },
  },
});
```

**Objectifs :**
- **Services** : > 90% coverage
- **Repositories** : > 80% coverage
- **Controllers** : couverts par les tests E2E
- **Types/schemas** : pas de coverage requis (pas de logique)



---

## 5. API

### 5.1 Structure des routes

```
/api/v1/{module}/{resource}
```

| Méthode | Route | Description |
|---------|-------|-------------|
| GET | `/api/v1/crops` | Lister (avec pagination) |
| GET | `/api/v1/crops/:id` | Détail |
| POST | `/api/v1/crops/plant` | Action (verbe métier) |
| PUT | `/api/v1/crops/:id` | Mise à jour complète |
| PATCH | `/api/v1/crops/:id` | Mise à jour partielle |
| DELETE | `/api/v1/crops/:id` | Suppression |

**Conventions :**
- Actions métier = `POST /resource/action` (pas de REST dogmatique)
- Toujours versionné (`/api/v1/`)
- Noms de ressources au **pluriel**
- Réponse toujours en JSON

### 5.2 Validation avec Zod

```typescript
// crop.schemas.ts
import { z } from 'zod';

export const plantCropSchema = z.object({
  fieldId: z.string().uuid(),
  speciesId: z.string().min(1).max(50),
});

export const cropFilterSchema = z.object({
  status: z.enum(['growing', 'ready', 'harvested']).optional(),
  page: z.coerce.number().int().positive().default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
});

// Type inféré automatiquement depuis le schema
export type PlantCropInput = z.infer<typeof plantCropSchema>;
export type CropFilterInput = z.infer<typeof cropFilterSchema>;
```

**Règles :**
- **Tout input est validé** — jamais faire confiance aux données client
- **Zod = source de vérité** pour les types d'input (inférer les types depuis Zod)
- **Valeurs par défaut** pour la pagination
- **Coerce** pour les query params (toujours string en entrée)
- **Messages d'erreur custom** sur les champs critiques

### 5.3 Format de réponse

```typescript
// Succès — ressource unique
{
  "data": {
    "id": "crop-123",
    "fieldId": "field-1",
    "speciesName": "Blé tendre",
    "growthStage": 3
  }
}

// Succès — liste paginée
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 150,
    "totalPages": 8
  }
}

// Erreur métier
{
  "error": {
    "code": "FIELD_ALREADY_PLANTED",
    "message": "This field already has an active crop."
  }
}

// Erreur de validation
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "fieldId", "message": "Must be a valid UUID" }
    ]
  }
}
```

### 5.4 Gestion des erreurs HTTP

```typescript
// shared/http-errors.ts
export const HTTP_ERROR_MAP: Record<string, number> = {
  NOT_FOUND: 404,
  VALIDATION_ERROR: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  CONFLICT: 409,
  RATE_LIMITED: 429,
  INTERNAL_ERROR: 500,
};

// shared/error-handler.ts — plugin Fastify global
export function errorHandler(
  error: Error,
  request: FastifyRequest,
  reply: FastifyReply,
): void {
  // Erreur Zod
  if (error instanceof ZodError) {
    return reply.status(400).send({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid input',
        details: error.issues.map((i) => ({
          field: i.path.join('.'),
          message: i.message,
        })),
      },
    });
  }

  // Erreur métier connue
  if (error instanceof AppError) {
    const status = HTTP_ERROR_MAP[error.code] ?? 400;
    return reply.status(status).send({
      error: { code: error.code, message: error.message },
    });
  }

  // Erreur non gérée → 500, loggée
  request.log.error(error);
  return reply.status(500).send({
    error: { code: 'INTERNAL_ERROR', message: 'An unexpected error occurred' },
  });
}
```

### 5.5 Pagination

```typescript
// shared/pagination.ts
export interface PaginationParams {
  page: number;
  pageSize: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
}

export function paginate<T>(
  data: T[],
  total: number,
  params: PaginationParams,
): PaginatedResponse<T> {
  return {
    data,
    pagination: {
      page: params.page,
      pageSize: params.pageSize,
      total,
      totalPages: Math.ceil(total / params.pageSize),
    },
  };
}

// Conversion page → offset pour Prisma
export function toOffset(params: PaginationParams): { take: number; skip: number } {
  return {
    take: params.pageSize,
    skip: (params.page - 1) * params.pageSize,
  };
}
```

### 5.6 Authentification sur les routes

```typescript
// Décorateur d'authentification
fastify.addHook('onRequest', async (request, reply) => {
  // Routes publiques exemptées
  if (PUBLIC_ROUTES.includes(request.url)) return;

  const token = request.headers.authorization?.replace('Bearer ', '');
  if (!token) {
    return reply.status(401).send({ error: { code: 'UNAUTHORIZED', message: 'Token required' } });
  }

  try {
    request.user = await verifyAccessToken(token);
  } catch {
    return reply.status(401).send({ error: { code: 'UNAUTHORIZED', message: 'Invalid token' } });
  }
});
```

---

## 6. Frontend

### 6.1 Structure des composants

```
src/
├── components/          # Composants réutilisables (UI kit)
│   ├── ui/             # Primitives (Button, Input, Card, Modal)
│   ├── layout/         # Layout (Header, Sidebar, Page)
│   └── shared/         # Composants métier partagés (ResourceBar, Timer)
├── features/           # Features par domaine (1 dossier = 1 écran/feature)
│   ├── crops/
│   │   ├── components/ # Composants spécifiques à la feature
│   │   ├── hooks/      # Custom hooks de la feature
│   │   ├── api/        # Appels API (queries/mutations)
│   │   └── types.ts    # Types frontend de la feature
│   ├── market/
│   └── ...
├── hooks/              # Hooks globaux réutilisables
├── lib/                # Utilitaires, config, clients API
├── routes/             # Configuration routing
└── stores/             # State management global
```

### 6.2 Composants — conventions

```tsx
// components/ui/button.tsx
import { type ButtonHTMLAttributes, type ReactNode } from 'react';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  children: ReactNode;
}

export function Button({
  variant = 'primary',
  size = 'md',
  loading = false,
  children,
  disabled,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        'btn',
        `btn-${variant}`,
        `btn-${size}`,
        loading && 'btn-loading',
      )}
      disabled={disabled || loading}
      aria-busy={loading}
      {...props}
    >
      {loading ? <Spinner size={size} /> : children}
    </button>
  );
}
```

**Règles :**
- **Composants fonctionnels** uniquement (pas de classes)
- **Props typées** avec interface (pas inline)
- **Export nommé** (pas de default export)
- **Accessibilité** : `aria-*` attributes, labels, rôles sémantiques
- **Pas de logique métier dans les composants** — déléguer aux hooks

### 6.3 Custom hooks — logique métier frontend

```tsx
// features/crops/hooks/use-plant-crop.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { plantCrop } from '../api/crop.api';
import { PlantCropInput } from '../types';

export function usePlantCrop() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (input: PlantCropInput) => plantCrop(input),
    onSuccess: () => {
      // Invalider les caches liés
      queryClient.invalidateQueries({ queryKey: ['crops'] });
      queryClient.invalidateQueries({ queryKey: ['fields'] });
    },
    onError: (error) => {
      // Error toast géré globalement
    },
  });
}
```

### 6.4 Fetch — client API

```typescript
// lib/api-client.ts
const API_BASE = import.meta.env.VITE_API_URL;

class ApiClient {
  private accessToken: string | null = null;

  setToken(token: string): void {
    this.accessToken = token;
  }

  async request<T>(path: string, options: RequestInit = {}): Promise<T> {
    const response = await fetch(`${API_BASE}${path}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...(this.accessToken && { Authorization: `Bearer ${this.accessToken}` }),
        ...options.headers,
      },
    });

    if (!response.ok) {
      const error = await response.json();
      throw new ApiError(response.status, error.error);
    }

    return response.json();
  }

  get<T>(path: string): Promise<T> {
    return this.request<T>(path, { method: 'GET' });
  }

  post<T>(path: string, body: unknown): Promise<T> {
    return this.request<T>(path, {
      method: 'POST',
      body: JSON.stringify(body),
    });
  }
}

export const api = new ApiClient();
```

### 6.5 State management

```
┌─────────────────────────────────────────────────┐
│ Server state (TanStack Query)                    │
│  → Données du serveur, cache, invalidation      │
├─────────────────────────────────────────────────┤
│ Client state (Zustand / React context)          │
│  → UI state, préférences, état local            │
├─────────────────────────────────────────────────┤
│ URL state (React Router)                        │
│  → Navigation, filtres, pagination              │
└─────────────────────────────────────────────────┘
```

**Règles :**
- **TanStack Query** pour tout ce qui vient du serveur (pas de Redux pour les données API)
- **Zustand** pour l'état client global (thème, sidebar ouverte, etc.)
- **React Context** pour l'état très localisé (1 arbre de composants)
- **URL** pour les filtres, la page courante, les onglets (shareable, bookmarkable)
- **Pas de state global pour ce qui peut être local**

### 6.6 Routing

```tsx
// routes/index.tsx
import { createBrowserRouter } from 'react-router-dom';
import { ProtectedRoute } from '@/components/layout/protected-route';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <RootLayout />,
    children: [
      { path: 'login', element: <LoginPage /> },
      { path: 'register', element: <RegisterPage /> },
      {
        element: <ProtectedRoute />,
        children: [
          { path: 'dashboard', element: <DashboardPage /> },
          { path: 'fields', element: <FieldsPage /> },
          { path: 'fields/:fieldId', element: <FieldDetailPage /> },
          { path: 'market', element: <MarketPage /> },
          { path: 'equipment', element: <EquipmentPage /> },
        ],
      },
    ],
  },
]);
```



---

## 7. Simulation (tick engine)

### 7.1 Architecture du tick engine

```
┌─────────────────────────────────────────────────────────────┐
│ Redis                                                        │
│  ┌──────────┐    ┌──────────────┐    ┌────────────────┐    │
│  │ Scheduler │───→│ Tick Queue   │───→│ Tick Workers   │    │
│  │ (cron)    │    │ (Bull/BullMQ)│    │ (N instances)  │    │
│  └──────────┘    └──────────────┘    └────────────────┘    │
│                                              │               │
│                                              ▼               │
│                                   ┌──────────────────┐      │
│                                   │ Tick Processors   │      │
│                                   │ (par module)      │      │
│                                   └──────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

**Temporalité : 1 semaine réelle = 1 mois de jeu. 1 tick = 1 jour de jeu (traité toutes les ~5.6h réelles).**

### 7.2 Structure d'un tick processor

```typescript
// modules/crop/crop.tick-processor.ts
import { TickProcessor, TickContext } from '@/shared/tick-engine';
import { CropRepository } from './crop.repository';
import { EventBus } from '@/shared/event-bus';

export class CropTickProcessor implements TickProcessor {
  readonly name = 'crop-growth';
  readonly priority = 10; // Ordre d'exécution (plus bas = plus tôt)

  constructor(
    private readonly repository: CropRepository,
    private readonly eventBus: EventBus,
  ) {}

  async process(context: TickContext): Promise<void> {
    const { gameDate, tickNumber } = context;

    // Batch processing — traiter par lots pour la performance
    const activeCrops = await this.repository.findAllActive();

    const updates: CropUpdate[] = [];
    const events: DomainEvent[] = [];

    for (const crop of activeCrops) {
      const result = this.calculateGrowth(crop, gameDate);

      if (result.stageChanged) {
        updates.push({ id: crop.id, growthStage: result.newStage });
      }

      if (result.ready) {
        events.push({
          type: 'crop.ready-to-harvest',
          payload: { cropId: crop.id, playerId: crop.playerId },
        });
      }
    }

    // Écriture en batch (1 query, pas N)
    if (updates.length > 0) {
      await this.repository.batchUpdateGrowth(updates);
    }

    // Events émis après les écritures (cohérence)
    for (const event of events) {
      this.eventBus.emit(event.type, event.payload);
    }
  }

  private calculateGrowth(crop: CropState, gameDate: Date): GrowthCalcResult {
    const daysSincePlanting = diffDays(crop.plantedAt, gameDate);
    const expectedStage = Math.floor(daysSincePlanting / crop.daysPerStage);
    const newStage = Math.min(expectedStage, crop.maxStages);

    return {
      stageChanged: newStage > crop.growthStage,
      newStage,
      ready: newStage >= crop.maxStages,
    };
  }
}
```

### 7.3 Règles de performance du tick

| Règle | Pourquoi |
|-------|----------|
| Batch reads (findAll) | 1 query au lieu de N |
| Batch writes (updateMany) | 1 query au lieu de N |
| Pas d'appels HTTP dans un tick | Latence imprévisible |
| Pas d'events entre ticks | Ordre d'exécution garanti par priority |
| Timeout par processor (30s max) | Un processor bloqué ne bloque pas le tick |
| Idempotent | Un tick rejoué produit le même résultat |

### 7.4 Cohérence et ordre d'exécution

```typescript
// shared/tick-engine/tick-runner.ts
export class TickRunner {
  private processors: TickProcessor[] = [];

  register(processor: TickProcessor): void {
    this.processors.push(processor);
    // Toujours trié par priority
    this.processors.sort((a, b) => a.priority - b.priority);
  }

  async runTick(context: TickContext): Promise<TickResult> {
    const results: ProcessorResult[] = [];

    // Exécution séquentielle — l'ordre COMPTE
    for (const processor of this.processors) {
      const start = performance.now();
      try {
        await processor.process(context);
        results.push({ name: processor.name, success: true, durationMs: performance.now() - start });
      } catch (error) {
        results.push({ name: processor.name, success: false, error, durationMs: performance.now() - start });
        // Log but continue — un module en erreur ne casse pas les autres
        logger.error(`Tick processor ${processor.name} failed`, { error, context });
      }
    }

    return { tickNumber: context.tickNumber, results };
  }
}
```

**Ordre typique :**
1. `weather` (priority 1) — La météo influence tout
2. `crop-growth` (priority 10) — Croissance des cultures
3. `livestock` (priority 20) — Consommation, production animale
4. `equipment-wear` (priority 30) — Usure du matériel
5. `market-prices` (priority 40) — Mise à jour des prix (offre/demande)
6. `player-finances` (priority 50) — Charges récurrentes, revenus

### 7.5 Gestion des pannes

```typescript
// Si un tick échoue partiellement :
// 1. Les processors réussis ne sont PAS rollback (trop coûteux)
// 2. Les processors échoués sont retry au tick suivant
// 3. Alert si un processor échoue 3 ticks consécutifs

// Le tick est idempotent : si on le relance, il recalcule depuis l'état DB
// → Pas besoin de "undo", juste "redo" le processor manquant
```

---

## 8. Sécurité

### 8.1 Authentification JWT

```typescript
// modules/auth/auth.service.ts
import jwt from 'jsonwebtoken';
import { AUTH_CONFIG } from '@/infrastructure/config';

export class AuthService {
  generateTokens(userId: string): TokenPair {
    const accessToken = jwt.sign(
      { sub: userId, type: 'access' },
      AUTH_CONFIG.accessSecret,
      { expiresIn: '15m' },
    );

    const refreshToken = jwt.sign(
      { sub: userId, type: 'refresh' },
      AUTH_CONFIG.refreshSecret,
      { expiresIn: '30d' },
    );

    return { accessToken, refreshToken };
  }

  async verifyAccessToken(token: string): Promise<TokenPayload> {
    try {
      const payload = jwt.verify(token, AUTH_CONFIG.accessSecret) as JwtPayload;
      if (payload.type !== 'access') throw new Error('Wrong token type');
      return { userId: payload.sub };
    } catch {
      throw new UnauthorizedError('Invalid or expired token');
    }
  }

  async refreshTokens(refreshToken: string): Promise<TokenPair> {
    // Vérifier le refresh token
    const payload = jwt.verify(refreshToken, AUTH_CONFIG.refreshSecret) as JwtPayload;
    if (payload.type !== 'refresh') throw new UnauthorizedError('Invalid token type');

    // Vérifier que le token n'est pas révoqué (blacklist Redis)
    const isRevoked = await this.redis.get(`revoked:${refreshToken}`);
    if (isRevoked) throw new UnauthorizedError('Token revoked');

    // Révoquer l'ancien refresh token (rotation)
    await this.redis.set(`revoked:${refreshToken}`, '1', 'EX', 30 * 24 * 3600);

    // Générer une nouvelle paire
    return this.generateTokens(payload.sub);
  }
}
```

**Règles auth :**
- Access token : **15 minutes** (court, stateless)
- Refresh token : **30 jours** (long, avec rotation)
- Refresh token rotation : chaque refresh invalide l'ancien
- **Jamais stocker les tokens en localStorage** côté frontend — httpOnly cookie pour le refresh
- Access token en mémoire (variable JS) côté frontend

### 8.2 Input validation — défense en profondeur

```typescript
// 3 niveaux de validation :

// Niveau 1 : Schema Zod (format, types)
const createPlayerSchema = z.object({
  username: z.string()
    .min(3, 'Username must be at least 3 characters')
    .max(20, 'Username must be at most 20 characters')
    .regex(/^[a-zA-Z0-9_-]+$/, 'Username can only contain letters, numbers, _ and -'),
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
});

// Niveau 2 : Validation métier (dans le service)
if (await this.repository.usernameExists(input.username)) {
  return err(PlayerError.UsernameAlreadyTaken);
}

// Niveau 3 : Contraintes DB (unique, check)
// @@unique([username]) dans Prisma — filet de sécurité final
```

### 8.3 Rate limiting

```typescript
// infrastructure/rate-limiter.ts
import rateLimit from '@fastify/rate-limit';

export function setupRateLimiting(fastify: FastifyInstance): void {
  // Limite globale
  fastify.register(rateLimit, {
    max: 100,           // 100 requêtes
    timeWindow: '1 minute',
    keyGenerator: (request) => request.ip,
  });

  // Limites spécifiques (sur les routes sensibles)
  // Login : 5 tentatives / 15 min
  fastify.register(rateLimit, {
    max: 5,
    timeWindow: '15 minutes',
    routePrefix: '/api/v1/auth/login',
    keyGenerator: (request) => request.ip,
  });

  // Actions de jeu : 30/min (anti-bot)
  fastify.register(rateLimit, {
    max: 30,
    timeWindow: '1 minute',
    routePrefix: '/api/v1/crops',
    keyGenerator: (request) => request.user?.id ?? request.ip,
  });
}
```

### 8.4 CORS

```typescript
// infrastructure/cors.ts
import cors from '@fastify/cors';

export function setupCors(fastify: FastifyInstance): void {
  fastify.register(cors, {
    origin: [
      'https://agriva.fr',
      'https://www.agriva.fr',
      ...(process.env.NODE_ENV === 'development' ? ['http://localhost:5173'] : []),
    ],
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
    credentials: true, // Pour les cookies httpOnly
    maxAge: 86400,     // Preflight cache 24h
  });
}
```

### 8.5 Checklist sécurité par feature

Chaque feature doit passer cette checklist avant déploiement :

- [ ] Inputs validés (Zod schema)
- [ ] Authentification requise (sauf routes publiques explicites)
- [ ] Autorisation vérifiée (le joueur ne peut agir que sur SES ressources)
- [ ] Rate limiting en place
- [ ] Pas de données sensibles dans les réponses (pas de hash password, pas de tokens internes)
- [ ] Queries paramétrées (Prisma le fait automatiquement)
- [ ] Pas de secrets hardcodés
- [ ] Headers de sécurité (Helmet)

```typescript
// Protection des ressources — toujours vérifier la propriété
async getField(fieldId: string, requestingPlayerId: string): Promise<Result<Field, FieldError>> {
  const field = await this.repository.findById(fieldId);

  if (!field) return err(FieldError.NotFound);

  // ⚠️ CRITIQUE : vérifier que le champ appartient au joueur
  if (field.playerId !== requestingPlayerId) {
    return err(FieldError.NotFound); // Pas "Forbidden" → ne pas révéler l'existence
  }

  return ok(field);
}
```



---

## 9. Git & CI

### 9.1 Branches

```
main              ← Production, toujours stable
├── develop       ← Intégration, CI verte obligatoire
│   ├── feat/crop-growth-system    ← Feature
│   ├── fix/market-price-overflow  ← Bugfix
│   ├── refactor/auth-module       ← Refactoring
│   └── docs/adr-007-caching      ← Documentation
```

**Conventions :**
- Format : `type/description-courte` (kebab-case)
- Types : `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Merge vers `develop` par PR (jamais direct)
- Merge vers `main` par release (après validation complète)
- **Jamais de push --force** sur `main` ou `develop`

### 9.2 Commits conventionnels

```
feat(crop): add growth stage calculation
fix(market): prevent negative price on excess supply
refactor(auth): extract token service from auth module
test(livestock): add feeding schedule unit tests
docs(adr): document caching strategy decision
chore(deps): update prisma to 6.2.0
```

**Format :** `type(scope): description`

- **type** : feat, fix, refactor, test, docs, chore, perf
- **scope** : nom du module (crop, market, auth, player, etc.)
- **description** : impératif, minuscule, < 72 chars, pas de point final
- **Body** (optionnel) : pourquoi ce changement, pas quoi (le diff montre le quoi)

```
feat(crop): add disease spread between adjacent fields

Diseases now spread with a 15% probability per tick to adjacent fields.
This mirrors SimAgri's mechanics where proximity matters.

Refs: GDD-cultures#diseases
```

### 9.3 Pull Requests

**Titre :** Même format que les commits (`feat(crop): add growth system`)

**Description template :**
```markdown
## Résumé
[1-2 phrases : quoi et pourquoi]

## Changements
- [liste des changements principaux]

## Tests
- [ ] Tests unitaires ajoutés/modifiés
- [ ] Tests d'intégration ajoutés/modifiés
- [ ] Tests e2e pour les chemins critiques
- [ ] Tous les tests passent localement

## Checklist
- [ ] Types stricts (pas de `any`)
- [ ] Pas de logique dans les controllers
- [ ] Events documentés
- [ ] Migrations réversibles
```

**Règles PR :**
- **1 PR = 1 feature/fix** (pas de méga-PR)
- Max **~400 lignes** de diff (au-delà → découper)
- La CI doit être verte avant merge
- Au moins 1 review (humain ou agent reviewer)

### 9.4 Hooks (Husky)

```json
// package.json
{
  "scripts": {
    "prepare": "husky install"
  }
}
```

```bash
# .husky/pre-commit
npx lint-staged

# .husky/commit-msg
npx commitlint --edit $1
```

```json
// lint-staged.config.js
export default {
  '*.{ts,tsx}': ['eslint --fix', 'prettier --write'],
  '*.{json,md}': ['prettier --write'],
};
```

### 9.5 CI/CD (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck

  test-unit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm test:unit --coverage

  test-integration:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: agriva_test
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
      redis:
        image: redis:7
        ports:
          - 6379:6379
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm prisma migrate deploy
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/agriva_test
      - run: pnpm test:integration

  test-e2e:
    runs-on: ubuntu-latest
    needs: [test-unit, test-integration]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: npx playwright install --with-deps
      - run: pnpm test:e2e
```

---

## 10. Performance

### 10.1 Requêtes DB — optimisation

```typescript
// ❌ N+1 queries
const fields = await prisma.field.findMany({ where: { playerId } });
for (const field of fields) {
  const crop = await prisma.crop.findFirst({ where: { fieldId: field.id } });
  // ...
}

// ✅ Eager loading (1 query)
const fields = await prisma.field.findMany({
  where: { playerId },
  include: { currentCrop: { include: { species: true } } },
});

// ✅ Select only what you need
const fieldSummary = await prisma.field.findMany({
  where: { playerId },
  select: {
    id: true,
    name: true,
    size: true,
    currentCrop: {
      select: { growthStage: true, species: { select: { name: true } } },
    },
  },
});
```

**Règles queries :**
- **Toujours `include` ou `select`** — jamais de requête imbriquée en boucle
- **Index sur les colonnes filtrées** — vérifier avec `EXPLAIN ANALYZE`
- **Paginer toute liste** — jamais de `findMany` sans `take`
- **Count séparé** pour la pagination (ne pas charger toutes les lignes pour compter)

### 10.2 Caching (Redis)

```typescript
// shared/cache.ts
import { Redis } from 'ioredis';

export class CacheService {
  constructor(private readonly redis: Redis) {}

  async get<T>(key: string): Promise<T | null> {
    const raw = await this.redis.get(key);
    return raw ? JSON.parse(raw) : null;
  }

  async set<T>(key: string, value: T, ttlSeconds: number): Promise<void> {
    await this.redis.set(key, JSON.stringify(value), 'EX', ttlSeconds);
  }

  async invalidate(pattern: string): Promise<void> {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(...keys);
    }
  }
}
```

**Stratégie de cache :**

| Donnée | TTL | Invalidation |
|--------|-----|-------------|
| Données de référence (espèces, recettes) | 24h | Au redémarrage |
| Prix du marché | 5 min | Au tick market |
| Profil joueur | 5 min | À la modification |
| Dashboard joueur | 1 min | Au tick |
| Session auth | 15 min | Au logout/refresh |

```typescript
// Exemple : cache-aside pattern
async getMarketPrices(speciesId: string): Promise<MarketPrice[]> {
  const cacheKey = `market:prices:${speciesId}`;

  // 1. Check cache
  const cached = await this.cache.get<MarketPrice[]>(cacheKey);
  if (cached) return cached;

  // 2. Query DB
  const prices = await this.repository.getPrices(speciesId);

  // 3. Store in cache
  await this.cache.set(cacheKey, prices, 300); // 5 min

  return prices;
}
```

### 10.3 Lazy loading frontend

```tsx
// Routes chargées à la demande
import { lazy, Suspense } from 'react';

const MarketPage = lazy(() => import('@/features/market/market.page'));
const EquipmentPage = lazy(() => import('@/features/equipment/equipment.page'));

// Dans le router
{
  path: 'market',
  element: (
    <Suspense fallback={<PageSkeleton />}>
      <MarketPage />
    </Suspense>
  ),
}
```

### 10.4 Monitoring et métriques

```typescript
// infrastructure/metrics.ts
import { performance } from 'perf_hooks';

export class Metrics {
  private static timers = new Map<string, number>();

  static startTimer(label: string): void {
    this.timers.set(label, performance.now());
  }

  static endTimer(label: string): number {
    const start = this.timers.get(label);
    if (!start) return 0;
    const duration = performance.now() - start;
    this.timers.delete(label);

    // Log si trop lent
    if (duration > 1000) {
      logger.warn(`Slow operation: ${label} took ${duration.toFixed(0)}ms`);
    }

    return duration;
  }
}

// Usage dans le tick engine
Metrics.startTimer(`tick:${tickNumber}:crop-growth`);
await cropProcessor.process(context);
const duration = Metrics.endTimer(`tick:${tickNumber}:crop-growth`);
```

**Seuils d'alerte :**
- API response > 500ms → warning
- API response > 2000ms → error
- Tick processor > 10s → warning
- Tick total > 60s → critical
- DB query > 100ms → log pour investigation



---

## 11. Documentation

### 11.1 Commentaires dans le code

```typescript
// ✅ Commenter le POURQUOI, pas le QUOI
// SimAgri caps quality at 95% to prevent perfect runs.
// This maintains economic tension between "good enough" and optimal.
const MAX_QUALITY = 0.95;

// ✅ Documenter les formules de gameplay (source de vérité)
/**
 * Calculate crop yield based on soil quality, weather, and care.
 *
 * Formula: baseYield * soilMultiplier * weatherMultiplier * careBonus
 * - soilMultiplier: 0.5 (poor) to 1.3 (excellent)
 * - weatherMultiplier: 0.3 (drought) to 1.2 (ideal)
 * - careBonus: 1.0 (no care) to 1.15 (perfect care)
 *
 * Reference: GDD-cultures#yield-calculation
 */
function calculateYield(params: YieldParams): number {
  return params.baseYield
    * params.soilMultiplier
    * params.weatherMultiplier
    * params.careBonus;
}

// ✅ Marquer les décisions techniques non évidentes
// Using raw SQL here because Prisma can't express this window function.
// See: https://github.com/prisma/prisma/issues/XXXX
const rankings = await prisma.$queryRaw`...`;

// ❌ Ne PAS faire
// Get the user
const user = getUser(); // Inutile

// Increment i
i++; // Évidemment
```

### 11.2 JSDoc — quand l'utiliser

```typescript
// Utiliser JSDoc sur :
// - Les fonctions publiques des services
// - Les types/interfaces exportés avec des champs non évidents
// - Les constantes de gameplay (avec référence au GDD)

/**
 * Process a market tick: recalculate prices based on supply/demand.
 *
 * Prices move ±5% max per tick to prevent market crashes.
 * Floor price = 50% of base price (prevents worthless goods).
 * Ceiling price = 300% of base price (prevents hyperinflation).
 *
 * @see docs/design/GDD-economie-base.md#price-algorithm
 */
export async function processMarketTick(context: TickContext): Promise<void> {
  // ...
}
```

### 11.3 ADR (Architecture Decision Records)

Quand créer un ADR :
- Choix de technologie (ex: "pourquoi Prisma et pas TypeORM")
- Pattern architectural (ex: "pourquoi event-driven entre modules")
- Compromis de game design qui impacte le code (ex: "tick toutes les 5.6h, pas temps réel")

```markdown
# ADR-007 : Cache strategy — Redis cache-aside

> Date : 2026-09-15
> Statut : Accepté

## Contexte
Le dashboard joueur effectue 8-12 queries par chargement.
Avec 1000 joueurs connectés, ça représente ~10k queries/minute.

## Options
| Option | Avantages | Inconvénients |
|--------|-----------|---------------|
| Pas de cache | Simple | 10k queries/min |
| Cache-aside Redis | Flexible, invalidation fine | Complexité cache invalidation |
| Materialized views | Très rapide en lecture | Refresh coûteux, rigide |

## Décision
Cache-aside Redis avec TTL courts (1-5 min).
Invalidation explicite au tick et aux actions joueur.

## Conséquences
- Ajouter Redis comme dépendance obligatoire
- Chaque repository "cacheable" a un wrapper CachedRepository
- Les tests d'intégration doivent aussi tester l'invalidation
```

### 11.4 Specs techniques

Chaque module a une spec avant l'implémentation :

```markdown
# Spec : Module Crop (cultures)

> Date : 2026-09-01
> Statut : Validé
> GDD source : docs/design/GDD-cultures.md

## API

### POST /api/v1/crops/plant
- Input : { fieldId, speciesId }
- Output : CropState
- Erreurs : FIELD_NOT_FOUND, FIELD_OCCUPIED, WRONG_SEASON

### GET /api/v1/crops?fieldId=xxx
- Output : PaginatedResponse<CropState>
- Filtres : status, speciesId

## Types principaux

```typescript
interface CropState {
  id: string;
  fieldId: string;
  speciesId: string;
  growthStage: number;
  maxStages: number;
  quality: number;
  plantedAt: Date;
  estimatedHarvestAt: Date;
}
```

## Tick processing
- Priority : 10
- Actions : growth stage update, disease check, weather impact

## Events émis
- crop.planted
- crop.stage-changed
- crop.ready-to-harvest
- crop.harvested
- crop.diseased

## Events écoutés
- weather.changed → recalculate growth speed
- equipment.used-on-field → apply care bonus
```

---

## 12. Patterns & Anti-patterns

### 12.1 Patterns à suivre ✅

#### Result type pour les erreurs métier

```typescript
// Toujours retourner Result pour les opérations qui peuvent échouer
async function sellCrop(cropId: string, playerId: string): Promise<Result<SaleReceipt, SaleError>> {
  const crop = await this.repository.findById(cropId);
  if (!crop) return err(SaleError.CropNotFound);
  if (crop.playerId !== playerId) return err(SaleError.NotOwner);
  if (crop.status !== 'harvested') return err(SaleError.NotHarvested);

  const price = await this.marketService.getCurrentPrice(crop.speciesId);
  const receipt = await this.repository.sell(crop, price);

  this.eventBus.emit('crop.sold', { cropId, playerId, amount: price });
  return ok(receipt);
}
```

#### Dependency injection via constructeur

```typescript
// Testable, explicite, pas de magie
export class MarketService {
  constructor(
    private readonly repository: MarketRepository,
    private readonly cache: CacheService,
    private readonly eventBus: EventBus,
  ) {}
}

// Dans le bootstrap de l'app
const marketRepository = new MarketRepository(prisma);
const marketService = new MarketService(marketRepository, cache, eventBus);
```

#### Guard clauses (early return)

```typescript
// ✅ Guard clauses — cas d'erreur d'abord, happy path à la fin
async function processHarvest(fieldId: string, playerId: string): Promise<Result<Harvest, HarvestError>> {
  const field = await this.repository.getField(fieldId);
  if (!field) return err(HarvestError.FieldNotFound);
  if (field.playerId !== playerId) return err(HarvestError.NotOwner);
  if (!field.crop) return err(HarvestError.NoCrop);
  if (field.crop.growthStage < field.crop.maxStages) return err(HarvestError.NotReady);

  // Happy path — toutes les validations passées
  const harvest = await this.repository.harvest(field.crop);
  return ok(harvest);
}
```

#### Factory functions pour les fixtures de test

```typescript
// Réutilisable, composable, typé
export function createCropFixture(overrides: Partial<CropState> = {}): CropState {
  return {
    id: `crop-${Math.random().toString(36).slice(2)}`,
    fieldId: 'field-default',
    speciesId: 'wheat',
    growthStage: 0,
    maxStages: 6,
    quality: 0.8,
    plantedAt: new Date('2026-03-01'),
    estimatedHarvestAt: new Date('2026-09-01'),
    status: 'growing',
    ...overrides,
  };
}
```

#### Module isolation — communiquer par events

```typescript
// ✅ Le module market ne connaît PAS les internals de crop
// Il écoute un event et réagit
eventBus.on('crop.harvested', async (event) => {
  await marketService.updateSupply(event.payload.speciesId, event.payload.yieldKg);
});

// ✅ L'API publique d'un module est définie dans son index.ts
// modules/crop/index.ts
export { CropService } from './crop.service';
export type { CropState, CropEvent } from './crop.types';
// Tout le reste est interne au module
```

#### Constantes de gameplay centralisées et documentées

```typescript
// modules/crop/crop.constants.ts
/**
 * Growth cycle duration per crop category (in game days).
 * Source: GDD-cultures.md#growth-timings
 */
export const GROWTH_DAYS = {
  cereal: 252,      // ~36 semaines
  oilseed: 308,     // ~44 semaines
  vegetable: 84,    // ~12 semaines
  fruit: 180,       // ~26 semaines (après plantation mature)
} as const;

/**
 * Quality multipliers based on soil condition.
 * Source: GDD-parcelles-sol.md#quality-impact
 */
export const SOIL_QUALITY_MULTIPLIER = {
  poor: 0.5,
  average: 0.8,
  good: 1.0,
  excellent: 1.2,
  exceptional: 1.3,
} as const;
```

---

### 12.2 Anti-patterns à éviter ❌

#### ❌ Logique métier dans les controllers

```typescript
// ❌ INTERDIT — le controller fait de la logique
fastify.post('/crops/plant', async (request, reply) => {
  const field = await prisma.field.findUnique({ where: { id: request.body.fieldId } });
  if (!field) return reply.status(404).send({ error: 'Not found' });
  if (field.currentCrop) return reply.status(400).send({ error: 'Occupied' });

  const crop = await prisma.crop.create({ data: { ... } });
  return reply.send(crop);
});

// ✅ Le controller délègue au service
fastify.post('/crops/plant', async (request, reply) => {
  const result = await cropService.plant(request.body);
  if (!result.ok) return reply.status(400).send({ error: result.error });
  return reply.status(201).send({ data: result.value });
});
```

#### ❌ any et assertions de type

```typescript
// ❌ INTERDIT
function processData(data: any) { ... }
const result = someFunction() as SpecificType;

// ✅ Typer correctement ou utiliser unknown + narrowing
function processData(data: unknown): Result<ProcessedData, ValidationError> {
  const parsed = dataSchema.safeParse(data);
  if (!parsed.success) return err(new ValidationError(parsed.error));
  return ok(transform(parsed.data));
}
```

#### ❌ Imports circulaires entre modules

```typescript
// ❌ Module A importe Module B et vice versa
// modules/crop/crop.service.ts
import { MarketService } from '@/modules/market'; // ❌

// modules/market/market.service.ts
import { CropService } from '@/modules/crop'; // ❌ Circulaire !

// ✅ Passer par les events
// modules/crop/crop.service.ts
this.eventBus.emit('crop.harvested', { ... });

// modules/market/market.service.ts
this.eventBus.on('crop.harvested', (event) => { ... });
```

#### ❌ Exceptions pour le flow control

```typescript
// ❌ Utiliser throw pour un cas métier prévisible
function withdraw(amount: number): void {
  if (balance < amount) throw new Error('Insufficient funds');
  // ...
}

// ✅ Utiliser Result
function withdraw(amount: number): Result<Transaction, WithdrawError> {
  if (balance < amount) return err(WithdrawError.InsufficientFunds);
  // ...
  return ok(transaction);
}
```

#### ❌ God services (service qui fait tout)

```typescript
// ❌ Un service qui gère 10 responsabilités
export class FarmService {
  plantCrop() { ... }
  harvestCrop() { ... }
  feedAnimals() { ... }
  sellOnMarket() { ... }
  buyEquipment() { ... }
  // 50 méthodes...
}

// ✅ Un service par domaine, responsabilité unique
export class CropService { /* planting, growth, harvest */ }
export class LivestockService { /* feeding, breeding, health */ }
export class MarketService { /* buying, selling, pricing */ }
```

#### ❌ State mutation silencieuse

```typescript
// ❌ Modifier un objet reçu en paramètre
function applyDiscount(order: Order): void {
  order.total *= 0.9; // Mutation silencieuse
}

// ✅ Retourner un nouvel objet
function applyDiscount(order: Order): Order {
  return { ...order, total: order.total * 0.9 };
}
```

#### ❌ Secrets et configuration hardcodés

```typescript
// ❌ JAMAIS
const JWT_SECRET = 'super-secret-key-123';
const DATABASE_URL = 'postgresql://user:pass@localhost:5432/agriva';

// ✅ Variables d'environnement + validation au démarrage
// infrastructure/config.ts
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url(),
  JWT_ACCESS_SECRET: z.string().min(32),
  JWT_REFRESH_SECRET: z.string().min(32),
  NODE_ENV: z.enum(['development', 'test', 'production']),
  PORT: z.coerce.number().default(3000),
});

export const config = envSchema.parse(process.env);
// Si une variable manque → crash immédiat au démarrage (fail fast)
```

#### ❌ Tests sans assertions claires

```typescript
// ❌ Test qui ne vérifie rien de précis
it('should work', async () => {
  const result = await service.doSomething();
  expect(result).toBeTruthy(); // Trop vague
});

// ✅ Assertions précises sur le comportement attendu
it('should calculate yield with soil bonus applied', async () => {
  const result = await service.calculateYield({
    baseYield: 100,
    soilMultiplier: 1.2,
    weatherMultiplier: 1.0,
    careBonus: 1.0,
  });

  expect(result).toBe(120); // 100 * 1.2 * 1.0 * 1.0
});
```

#### ❌ Ignorer les erreurs

```typescript
// ❌ Avaler l'erreur silencieusement
try {
  await sendNotification(playerId, message);
} catch {
  // rien
}

// ✅ Au minimum logger, idéalement gérer
try {
  await sendNotification(playerId, message);
} catch (error) {
  logger.warn('Failed to send notification', { playerId, error });
  // La notification n'est pas critique → on continue
}
```

---

## Annexe : Checklist rapide pour les agents IA

Avant de soumettre du code, vérifier :

```
□ TypeScript strict, 0 erreurs de type
□ Pas de `any`, pas de `as` (sauf cas documenté)
□ Tests écrits AVANT le code (TDD)
□ Coverage > 80% sur le code ajouté
□ Service → logique métier, Controller → thin layer
□ Result type pour les erreurs métier
□ Events pour la communication inter-modules
□ Input validé avec Zod
□ Queries optimisées (pas de N+1, pagination)
□ Constantes documentées avec référence au GDD
□ Commit message : type(scope): description
□ Fichiers en kebab-case, code en anglais
□ Pas de secrets hardcodés
□ Pas d'imports circulaires
```

---

> Ce document est vivant. Il évolue avec le projet. Chaque nouvelle convention validée y est ajoutée.
> En cas de doute, ce document fait autorité après `FOUNDATION.md` et les ADR.
