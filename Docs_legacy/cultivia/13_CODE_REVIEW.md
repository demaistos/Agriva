# CULTIVIA — Revue de Code Complète
## 2026-04-14 — 64 fichiers source analysés

> Audit croisé du code déployé vs documentation GDD/TDD.
> Classement : 🔴 Critique (sécurité/crash), 🟡 Majeur (bugs/archi), 🟢 Mineur (qualité/cosmétique).

---

# 1. RÉSUMÉ EXÉCUTIF

| Métrique | Valeur |
|----------|--------|
| Fichiers source | 64 |
| Backend (api/) | 17 fichiers |
| Frontend (frontend/) | 39 fichiers |
| Shared + config | 26 fichiers |
| Couverture schéma BDD | ~70% des tables du TDD |
| Couverture routes API | ~2% (~5 sur ~230 routes) |
| Couverture worker | ~40% du DAILY_UPDATE |
| Problèmes critiques | 6 |
| Problèmes majeurs | 14 |
| Problèmes mineurs | 12 |

---

# 2. PROBLÈMES CRITIQUES 🔴

## 2.1 — Aucune authentification sur les routes API

**Toutes** les routes API (`/api/animals`, `/api/buildings`, `/api/dashboard`, `/api/ht`, `/api/setup`) acceptent un `userId` en paramètre sans vérification de session. N'importe qui peut usurper n'importe quel joueur en changeant le `userId` dans la requête.

**Fichiers concernés :** Tous les fichiers dans `frontend/src/app/api/`

**Correction :** Ajouter `const session = await auth()` en début de chaque route et utiliser `session.user.id` au lieu du `userId` du body/query.

## 2.2 — Le worker tue les animaux nouvellement créés

`hungerCheck()` dans `api/src/workers/index.ts` tue tous les animaux avec `last_fed_at IS NULL` après 5 jours. Or, les animaux nouvellement achetés ont `last_fed_at = NULL`.

**Correction :** Ajouter `AND last_fed_at IS NOT NULL` ou `AND age_days > 5` dans la clause WHERE.

## 2.3 — Dockerfile frontend exécute `npm run dev` en production

Le Dockerfile frontend a `CMD ["npm", "run", "dev"]` — ça lance le serveur de développement Turbopack en production. Pas d'optimisation, pas de build statique, pas de minification.

**Correction :**
```dockerfile
RUN npm run build
CMD ["npm", "start"]
```

## 2.4 — Credentials BDD en dur dans le code

Plusieurs fichiers contiennent des fallback `postgres://cultivia:pass@localhost:5432/cultivia` en dur :
- `frontend/src/app/(auth)/actions.ts`
- `frontend/src/lib/auth.ts`
- `frontend/src/app/dashboard/page.tsx`
- `frontend/src/app/dashboard/profile/page.tsx`
- `scripts/seed-building-types.ts`

**Correction :** Utiliser uniquement `process.env.DATABASE_URL` sans fallback hardcodé.

## 2.5 — Calcul `surfacePerAnimal` cassé (achat animaux)

Dans `frontend/src/app/api/animals/route.ts`, l'action `buy_coop` :
```ts
Number(sp.surfaces ?? '{}')?.per_animal
```
`Number('{}')` retourne `NaN`, donc `NaN?.per_animal` = `undefined`. Le calcul de capacité du bâtiment est mort.

**Correction :** Parser le JSON correctement : `JSON.parse(sp.surfaces ?? '{}')?.per_animal`

## 2.6 — Fuite mémoire du rate limiter

Le `rateMap` dans `api/src/index.ts` grandit indéfiniment — chaque IP est ajoutée mais jamais nettoyée.

**Correction :** Ajouter un `setInterval` pour purger les entrées expirées, ou utiliser une lib comme `express-rate-limit`.

---

# 3. PROBLÈMES MAJEURS 🟡

## 3.1 — `shared/src/index.ts` n'exporte pas `services/ht`

Le barrel export ne contient que `constants/game` et `types/common`. Les fonctions HT (`calculateHtAfterHire`, `validateHtDeduction`, etc.) sont inaccessibles via `@cultivia/shared`.

**Correction :** Ajouter `export * from './services/ht';`

## 3.2 — Type `prairie_boisee` manquant dans le seed bâtiments

Le seed espèces référence `prairie_boisee` comme type de bâtiment pour Bisons/Daims, mais le seed bâtiments ne le contient pas. Ces espèces n'auront pas de bâtiment valide.

**Correction :** Ajouter `prairie_boisee` dans `scripts/seed-building-types.ts`.

## 3.3 — Hostnames BDD incohérents dans les seeds

`seed-building-types.ts` utilise `postgres` (hostname Docker) tandis que les autres seeds utilisent `localhost`. Le script échouera hors Docker.

**Correction :** Utiliser `process.env.DATABASE_URL` dans tous les scripts.

## 3.4 — `float` pour les montants monétaires

Tout le schéma utilise `real` (float4) pour les montants (balance, prix, salaires). Les floats causent des erreurs d'arrondi (`0.1 + 0.2 ≠ 0.3`).

**Correction :** Utiliser `numeric(12,2)` ou `integer` (centimes) pour tous les montants.

## 3.5 — Pas de transactions dans les seeds

Aucun script de seed n'utilise de transaction. Si un seed échoue à mi-chemin, la BDD reste dans un état incohérent.

## 3.6 — Race conditions sur balance/HT

La plupart des routes API lisent le profil sans `FOR UPDATE`, vérifient le solde, puis mettent à jour. Des requêtes concurrentes peuvent dépasser le solde.

**Correction :** Utiliser `SELECT ... FOR UPDATE` dans toutes les routes qui modifient balance/HT (seule `/api/ht` le fait actuellement).

## 3.7 — Worker utilise du SQL brut, API utilise Drizzle

Deux patterns d'accès BDD différents dans le même projet. Le worker devrait utiliser l'instance Drizzle partagée.

## 3.8 — 6 dépendances npm inutilisées (frontend)

| Package | Installé | Utilisé |
|---------|----------|---------|
| `drizzle-orm` | ✅ | ❌ (raw postgres partout) |
| `lucide-react` | ✅ | ❌ (emojis utilisés) |
| `@trpc/client` | ✅ | ❌ (fetch brut) |
| `@trpc/react-query` | ✅ | ❌ |
| `class-variance-authority` | ✅ | ❌ |
| `@tanstack/react-query` | ✅ | ❌ (seulement pour tRPC) |

## 3.9 — Composants massifs non décomposés

| Fichier | Lignes | Recommandation |
|---------|--------|----------------|
| `animals-client.tsx` | ~500 | Séparer en AnimalTable, AnimalDetail, BuyModal, QuickActions |
| `buildings-client.tsx` | ~600 | Séparer en BuildingTable, BuildingDetail, BuildWizard, ActionModals |
| `register/page.tsx` | ~200 | Séparer en StepCredentials, StepLocation, StepConfirm |

## 3.10 — Styling incohérent

Certains composants (`base.tsx`, `data-table.tsx`, `resource-bar.tsx`) utilisent Tailwind CSS. Tous les autres utilisent des styles inline React. Pas de cohérence.

## 3.11 — Aucune utilisation de Redis

Redis est dans le docker-compose et le TDD mais n'est utilisé nulle part. Pas de cache météo, pas de sessions, pas de leaderboards, pas de pub/sub.

## 3.12 — Aucun WebSocket/Socket.io

Le TDD spécifie 16 events temps réel (chat, notifications, prix marché). Aucune implémentation, même pas la dépendance installée.

## 3.13 — CI ne lance pas les tests API

Le workflow GitHub Actions ne lance que les tests `shared`. Les tests API et E2E ne sont pas exécutés.

## 3.14 — Destruction de bâtiment n'évacue pas les animaux

L'action `destroy` dans `/api/buildings` supprime le bâtiment mais ne déplace pas les animaux. Ils deviennent orphelins (building_id invalide).

---

# 4. PROBLÈMES MINEURS 🟢

| # | Problème | Fichier |
|---|----------|---------|
| 4.1 | `DataTable` composant complet mais inutilisé | `ui/data-table.tsx` |
| 4.2 | `ResourceBar` composant inutilisé | `ui/resource-bar.tsx` |
| 4.3 | Navigation vers 5+ pages inexistantes (404) | `layout/game-layout.tsx` |
| 4.4 | `Toast` et `Skeleton` définis mais inutilisés | `ui/base.tsx` |
| 4.5 | Flash de thème au chargement (FOUC) | `ui/theme-toggle.tsx` |
| 4.6 | E2E screenshots vers `/tmp/` (Linux) sur Windows | `e2e/animals.spec.ts` |
| 4.7 | `waitForTimeout` hardcodés dans les E2E (flaky) | `e2e/auth.spec.ts` |
| 4.8 | Stress test attend 26 types bâtiment, seed en a 30 | `scripts/stress-test-buildings.ts` |
| 4.9 | Stress test crée 3 users par agent au lieu de 1 | `scripts/stress-test-buildings.ts` |
| 4.10 | Pas de `.dockerignore` | racine |
| 4.11 | `actions.ts` (server action) = code mort | `(auth)/actions.ts` |
| 4.12 | Pas de pre-commit hooks malgré DEVELOPMENT_RULES | racine |

---

# 5. COUVERTURE GDD

## Features Phase 0

| Feature | Statut | Commentaire |
|---------|--------|-------------|
| F0.1 Monorepo + Docker | ✅ | Structure OK, Docker fonctionne |
| F0.2a Schema Core | ✅ | 8 tables core présentes |
| F0.2b Schema Élevage+Cultures | ✅ | Tables présentes |
| F0.2c Schema Matériel+Économie | ✅ | Tables présentes |
| F0.2d Schema Activités | ✅ | Tables présentes |
| F0.2e Schema Avancées | ✅ | Tables présentes |
| F0.2f Indexes | ⚠️ | Indexes définis dans le schéma Drizzle mais non vérifiés |
| F0.3 Seed Géographie | ✅ | Fonctionne mais sans transactions |
| F0.4 Auth NextAuth | ⚠️ | Login/register fonctionnent, mais routes API non protégées |
| F0.5 tRPC Setup | ⚠️ | Configuré mais quasi inutilisé (5 routes seulement) |
| F0.6 Design System | ⚠️ | Composants créés mais inutilisés (DataTable, ResourceBar) |
| F0.7 DataTable | ⚠️ | Composant complet mais pas utilisé dans les pages |
| F0.8 CI | ⚠️ | Existe mais ne lance pas tous les tests |

## Features Phase 1

| Feature | Statut | Commentaire |
|---------|--------|-------------|
| F1.1 Seed espèces+races | ✅ | 14 espèces, ~30 races |
| F1.2 Seed cultures+matériel | ✅ | 25 cultures, 29 modèles |
| F1.3 API système HT | ✅ | GET/POST fonctionnels |
| F1.5 UI Tableau de bord | ✅ | Dashboard avec stats |
| F1.7a API bâtiments | ✅ | Build/destroy/maintain/upgrade |
| F1.8 UI Bâtiments | ✅ | Page fonctionnelle |
| F1.9a API nourrir | ✅ | Feed action implémentée |
| F1.10 API acheter animaux | ✅ | Buy from coop (avec bug surfacePerAnimal) |
| F1.14 UI Animaux | ✅ | Page avec groupement par espèce |
| F1.15 API productions | ⚠️ | Traite OK, œufs partiels |
| F1.18 Worker DAILY_UPDATE v1 | ⚠️ | Existe mais bug hunger check |
| F1.20 Onboarding inscription | ✅ | Flow multi-étapes avec carte |
| F1.21 Onboarding config initiale | ✅ | Starter packs |
| F1.22 Tutoriel | ✅ | Tutorial overlay |
| F1.4 API employés | ❌ | Non implémenté |
| F1.6 UI Profil | ⚠️ | Lecture seule, pas d'édition |
| F1.9b API abreuver | ⚠️ | Action existe mais ne coûte pas de HT |
| F1.9c API litière+fumier | ❌ | Non implémenté |
| F1.11 API vendre animaux | ⚠️ | Abattoir seulement |
| F1.12 API déplacer animaux | ❌ | Non implémenté |
| F1.13 API gestion animaux | ⚠️ | Nommer OK, fusionner/défusionner manquants |
| F1.16 API vente productions | ⚠️ | Lait/œufs/laine basiques |
| F1.17 API soins | ⚠️ | Vétérinaire/vacciner OK |
| F1.19 Worker ferme | ⚠️ | HT reset OK, usure/énergie manquants |
| F1.23 UI Inventaire | ❌ | Non implémenté |
| F1.24 UI Journal | ❌ | Non implémenté |
| F1.25 Mode Vacances | ❌ | Non implémenté |

---

# 6. POINTS POSITIFS ✅

- Schéma BDD bien organisé en 5 fichiers domaine avec Drizzle ORM
- TypeScript strict avec `noUncheckedIndexedAccess` — excellent
- Structure monorepo propre (frontend/api/shared)
- Seed géographique complet (régions, départements, communes réelles)
- Carte de France interactive SVG pour l'inscription
- Système de starter packs bien pensé
- Tutoriel interactif fonctionnel
- Composant DataTable complet (même s'il est inutilisé)
- Tests E2E Playwright pour le flow d'inscription
- Commentaires en français cohérents avec le domaine métier
- Constantes de jeu alignées avec le GDD (HT, rations, taxes)

---

# 7. PLAN D'ACTION RECOMMANDÉ

## Priorité 1 — Sécurité (avant tout déploiement)
1. Ajouter `auth()` sur toutes les routes API
2. Supprimer les credentials hardcodés
3. Ajouter rate limiting
4. Fixer le Dockerfile (build + start au lieu de dev)

## Priorité 2 — Bugs critiques
5. Fixer le hunger check du worker (ne pas tuer les nouveaux animaux)
6. Fixer le calcul `surfacePerAnimal` (JSON.parse au lieu de Number)
7. Fixer la destruction de bâtiment (évacuer les animaux)
8. Ajouter `prairie_boisee` au seed bâtiments
9. Ajouter l'export `services/ht` dans shared/index.ts

## Priorité 3 — Architecture
10. Passer les montants monétaires en `numeric(12,2)`
11. Ajouter `FOR UPDATE` sur toutes les routes qui modifient balance/HT
12. Unifier l'accès BDD (Drizzle partout, supprimer raw SQL)
13. Supprimer les 6 dépendances inutilisées
14. Utiliser le composant DataTable existant dans les pages

## Priorité 4 — Qualité
15. Décomposer les composants massifs (animals-client, buildings-client)
16. Unifier le styling (Tailwind partout ou inline partout)
17. Ajouter les tests API dans le CI
18. Ajouter des pre-commit hooks (husky + lint-staged)
19. Créer un `.dockerignore`
