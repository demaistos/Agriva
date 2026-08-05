# Cultivia Code Review Fixes — Design Spec
## 2026-04-14

**Goal:** Fix all 32 issues identified in the code review (6 critical, 14 major, 12 minor) across 4 priority levels.

**Approach:** Sequential by priority. Each correction is an atomic commit. Code must be stable after each priority level.

## Section A — Security (P1)
1. Add `auth()` session check to all API routes, use `session.user.id` instead of `userId` param
2. Remove all hardcoded DB credential fallbacks
3. Fix rate limiter memory leak (periodic cleanup)
4. Fix Dockerfile (build + start, not dev)

## Section B — Critical Bugs (P2)
5. Fix worker hungerCheck (don't kill new animals with NULL last_fed_at)
6. Fix surfacePerAnimal (JSON.parse instead of Number)
7. Fix building destroy (relocate animals first)
8. Add prairie_boisee to building types seed
9. Add services/ht export to shared/index.ts

## Section C — Architecture (P3)
10. Change monetary columns from real to numeric(12,2)
11. Add FOR UPDATE on balance/HT mutation routes
12. Replace worker raw SQL with Drizzle
13. Remove 6 unused frontend dependencies
14. Wire up existing DataTable component in pages

## Section D — Quality (P4)
15. Decompose animals-client.tsx and buildings-client.tsx
16. Unify styling to Tailwind
17. Add API tests to CI workflow
18. Add pre-commit hooks
19. Create .dockerignore
