# Code Review Fixes — Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix all 32 issues from the code review across security, bugs, architecture, and quality.
**Architecture:** Sequential fixes by priority. Each task is atomic and independently committable.
**Tech Stack:** Next.js 15, NextAuth v5, Drizzle ORM, PostgreSQL, TypeScript strict

---

## PRIORITY 1 — SECURITY

### Task 1: Add auth() to all API routes
**Files:**
- Modify: `frontend/src/app/api/animals/route.ts`
- Modify: `frontend/src/app/api/buildings/route.ts`
- Modify: `frontend/src/app/api/dashboard/route.ts`
- Modify: `frontend/src/app/api/dashboard/tutorial/route.ts`
- Modify: `frontend/src/app/api/ht/route.ts`
- Modify: `frontend/src/app/api/setup/route.ts`

- [ ] Add `import { auth } from '@/lib/auth'` and `const session = await auth()` at top of each GET/POST handler
- [ ] Return 401 if no session
- [ ] Replace all `userId` from body/query with `session.user.id`
- [ ] Commit: `fix(security): add auth checks to all API routes`

### Task 2: Remove hardcoded DB credentials
**Files:**
- Modify: `frontend/src/app/(auth)/actions.ts`
- Modify: `frontend/src/lib/auth.ts`
- Modify: `frontend/src/app/dashboard/page.tsx`
- Modify: `frontend/src/app/dashboard/profile/page.tsx`
- Modify: `scripts/seed-building-types.ts`

- [ ] Replace all `postgres('postgres://cultivia:pass@...')` fallbacks with `postgres(process.env.DATABASE_URL!)`
- [ ] Commit: `fix(security): remove hardcoded DB credentials`

### Task 3: Fix rate limiter memory leak
**Files:**
- Modify: `api/src/index.ts`

- [ ] Add cleanup interval that prunes expired entries from rateMap every 60s
- [ ] Commit: `fix(security): add rate limiter cleanup interval`

### Task 4: Fix Dockerfiles
**Files:**
- Modify: `frontend/Dockerfile`
- Modify: `api/Dockerfile`
- Create: `.dockerignore`

- [ ] Frontend Dockerfile: add `RUN npm run build`, change CMD to `npm start`
- [ ] API Dockerfile: ensure proper build step
- [ ] Create `.dockerignore` with node_modules, .git, .next, dist, test-results, coverage
- [ ] Commit: `fix(infra): production Dockerfiles + .dockerignore`

---

## PRIORITY 2 — CRITICAL BUGS

### Task 5: Fix worker hunger/water check
**Files:**
- Modify: `api/src/workers/index.ts`

- [ ] Add `AND last_fed_at IS NOT NULL` to hungerCheck sick/kill queries
- [ ] Add `AND last_watered_at IS NOT NULL` to waterCheck query
- [ ] Commit: `fix(worker): don't kill newly created animals`

### Task 6: Fix surfacePerAnimal calculation
**Files:**
- Modify: `frontend/src/app/api/animals/route.ts`

- [ ] Replace `Number(sp.surfaces ?? '{}')?.per_animal` with `JSON.parse(sp.surfaces ?? '{}')?.per_animal`
- [ ] Commit: `fix(animals): fix surfacePerAnimal JSON parse`

### Task 7: Fix building destroy (relocate animals)
**Files:**
- Modify: `frontend/src/app/api/buildings/route.ts`

- [ ] Before deleting building, SET animals.building_id = NULL WHERE building_id = target
- [ ] Return relocated animal count in response
- [ ] Commit: `fix(buildings): relocate animals before destroy`

### Task 8: Add prairie_boisee to building seed
**Files:**
- Modify: `scripts/seed-building-types.ts`

- [ ] Add prairie_boisee entry (category: elevage, has_energy: false, capacity_per_animal appropriate for bisons/daims)
- [ ] Commit: `fix(seed): add prairie_boisee building type`

### Task 9: Fix shared exports
**Files:**
- Modify: `shared/src/index.ts`

- [ ] Add `export * from './services/ht';`
- [ ] Commit: `fix(shared): export ht service functions`

---

## PRIORITY 3 — ARCHITECTURE

### Task 10: Fix monetary column types
**Files:**
- Modify: `api/src/db/schema/core.ts`
- Modify: `api/src/db/schema/economy.ts`
- Modify: `api/src/db/schema/farm.ts`
- Modify: `api/src/db/schema/activities.ts`

- [ ] Replace all `real()` on monetary columns (balance, price, salary, amount, cost) with `numeric({ precision: 12, scale: 2 })`
- [ ] Commit: `refactor(schema): use numeric(12,2) for monetary values`

### Task 11: Add FOR UPDATE on mutation routes
**Files:**
- Modify: `frontend/src/app/api/animals/route.ts`
- Modify: `frontend/src/app/api/buildings/route.ts`
- Modify: `frontend/src/app/api/setup/route.ts`

- [ ] Wrap profile reads + balance/HT mutations in `sql.begin` with `FOR UPDATE`
- [ ] Commit: `fix(api): add FOR UPDATE to prevent race conditions`

### Task 12: Replace worker raw SQL with Drizzle
**Files:**
- Modify: `api/src/workers/index.ts`

- [ ] Import db and schema from `../db`
- [ ] Replace all raw `sql` template literals with Drizzle query builder
- [ ] Commit: `refactor(worker): use Drizzle instead of raw SQL`

### Task 13: Remove unused frontend dependencies
**Files:**
- Modify: `frontend/package.json`

- [ ] Remove: drizzle-orm, lucide-react, @trpc/client, @trpc/react-query, class-variance-authority, @tanstack/react-query
- [ ] Run npm install to update lockfile
- [ ] Commit: `chore(deps): remove 6 unused frontend dependencies`

### Task 14: Wire up DataTable component
**Files:**
- Modify: `frontend/src/components/animals/animals-client.tsx`
- Modify: `frontend/src/components/buildings/buildings-client.tsx`

- [ ] Replace hand-rolled tables with `<DataTable>` from `ui/data-table.tsx`
- [ ] Configure columns, grouping, sorting, filtering per existing DataTable API
- [ ] Commit: `refactor(ui): use DataTable component in animals and buildings`

---

## PRIORITY 4 — QUALITY

### Task 15: Decompose large components
**Files:**
- Create: `frontend/src/components/animals/animal-table.tsx`
- Create: `frontend/src/components/animals/animal-detail.tsx`
- Create: `frontend/src/components/animals/buy-modal.tsx`
- Create: `frontend/src/components/animals/quick-actions.tsx`
- Modify: `frontend/src/components/animals/animals-client.tsx`
- Create: `frontend/src/components/buildings/building-table.tsx`
- Create: `frontend/src/components/buildings/building-detail.tsx`
- Create: `frontend/src/components/buildings/build-wizard.tsx`
- Create: `frontend/src/components/buildings/action-modals.tsx`
- Modify: `frontend/src/components/buildings/buildings-client.tsx`

- [ ] Extract sub-components, keep animals-client and buildings-client as orchestrators
- [ ] Commit: `refactor(ui): decompose animals and buildings components`

### Task 16: Unify styling to Tailwind
**Files:**
- Modify: all component files with inline styles

- [ ] Replace inline `style={{}}` with Tailwind classes across all components
- [ ] Commit: `refactor(ui): replace inline styles with Tailwind classes`

### Task 17: Add API tests to CI
**Files:**
- Modify: `.github/workflows/ci.yml`

- [ ] Add `npm test --workspace=api` step
- [ ] Commit: `ci: add API tests to CI workflow`

### Task 18: Add pre-commit hooks
**Files:**
- Modify: `package.json`

- [ ] Add husky + lint-staged as devDependencies
- [ ] Configure lint-staged for eslint + prettier on staged files
- [ ] Commit: `chore: add pre-commit hooks with husky + lint-staged`

### Task 19: Clean up misc issues
**Files:**
- Modify: `frontend/src/components/layout/game-layout.tsx`
- Delete: `frontend/src/app/(auth)/actions.ts`
- Modify: `frontend/src/lib/trpc.ts`

- [ ] Remove nav links to non-existent pages (or add placeholder pages)
- [ ] Delete dead code (actions.ts server action)
- [ ] Commit: `chore: remove dead code and broken nav links`
