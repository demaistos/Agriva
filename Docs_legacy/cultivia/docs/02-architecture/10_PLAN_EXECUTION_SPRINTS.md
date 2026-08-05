# Plan d'exécution détaillé — Sprint par sprint

> Pour chaque sprint : tâches dev, tests, validation utilisateur.
> Chaque tâche a un responsable (@agent) et un critère de validation.

---

## Sprint 01 — Scaffolding + Auth (2 sem)

### Objectif
Un joueur s'inscrit, se connecte, voit un shell vide. L'infra tourne.

### Semaine 1 — Dev

| # | Tâche | Agent | Livrable | Critère done |
|---|-------|-------|----------|-------------|
| 1.1 | tsconfig.json (root + 4 workspaces) | @backend | Fichiers config | `npm run typecheck` passe |
| 1.2 | ESLint + Prettier config | @backend | .eslintrc, .prettierrc | `npm run lint` passe |
| 1.3 | package.json par workspace (server/client/worker/shared) | @backend | 4 package.json | `npm install` sans erreur |
| 1.4 | Shared types (Player, Server, enums Season/Kit/CropState) | @backend | src/shared/types/ | Importable depuis server + client |
| 1.5 | Dockerfiles (server, client, worker) | @devops | 3 Dockerfiles | `docker compose build` passe |
| 1.6 | Migration 001 (account, player, server, refresh_token, idempotency_key) | @database | prisma/migrations/001 | `npm run db:migrate` passe |
| 1.7 | Seed server France + 5 joueurs test | @data | scripts/seed/test | `npm run db:seed` passe |
| 1.8 | Boilerplate Fastify (app, plugins, error handler, logger pino) | @backend | src/server/src/app.ts | Server démarre sur :3001 |
| 1.9 | Middleware auth JWT (verify, extract player_id) | @backend | src/server/src/middleware/auth.ts | Token invalide → 401 |
| 1.10 | Middleware idempotency (check Redis, cache 24h) | @backend | src/server/src/middleware/idempotency.ts | Double requête → même réponse |
| 1.11 | Middleware rate limit (100/min IP, 30/min user) | @backend | src/server/src/middleware/rateLimit.ts | 101ème requête → 429 |
| 1.12 | Routes auth : POST register, login, refresh, logout | @backend | src/server/src/routes/auth.ts | Inscription + connexion fonctionnelles |
| 1.13 | Route GET /api/player/me | @backend | src/server/src/routes/player.ts | Retourne profil joueur |
| 1.14 | Boilerplate Vue 3 + Vite + Pinia + Router | @frontend | src/client/ | `npm run dev:client` → page blanche |
| 1.15 | Layout shell (header, sidebar vide, contenu) | @frontend | src/client/src/layouts/ | Header avec logo + déconnexion |
| 1.16 | Pages register, login, dashboard (vide) | @frontend | src/client/src/pages/ | Navigation entre les 3 pages |
| 1.17 | Store useAuthStore (login, logout, refresh) | @frontend | src/client/src/stores/auth.ts | Token stocké, refresh auto |
| 1.18 | Router guard (redirect /login si pas connecté) | @frontend | src/client/src/router/ | Page protégée → redirect |
| 1.19 | Vitest config + premier test unitaire | @tests | vitest.config.ts | `npm run test` passe |
| 1.20 | Supertest config + test intégration auth | @tests | src/server/src/test/ | Test register + login + me |

### Semaine 2 — Tests + Validation

| # | Test | Type | Critère pass |
|---|------|------|-------------|
| T1.1 | POST /register email valide → 201 | Intégration | Player créé en BDD |
| T1.2 | POST /register email existant → 409 | Intégration | AUTH_EMAIL_EXISTS |
| T1.3 | POST /login credentials valides → 200 + JWT | Intégration | Token retourné |
| T1.4 | POST /login mauvais password → 401 | Intégration | AUTH_INVALID_CREDENTIALS |
| T1.5 | GET /me avec JWT valide → 200 | Intégration | Profil retourné |
| T1.6 | GET /me avec JWT expiré → 401 | Intégration | AUTH_TOKEN_EXPIRED |
| T1.7 | POST /refresh avec token valide → nouveau JWT | Intégration | Rotation token |
| T1.8 | Double requête même idempotency key → même réponse | Intégration | Pas de doublon |
| T1.9 | 101 requêtes en 1 min → 429 | Intégration | Rate limited |
| T1.10 | Inscription UI → connexion → dashboard | E2E (manuel) | Parcours complet |

### Validation utilisateur (5 testeurs internes)
- [ ] Je m'inscris avec email + mot de passe → toast "Compte créé"
- [ ] Je me connecte → je vois le dashboard vide avec "Bienvenue"
- [ ] Je me déconnecte → retour page login
- [ ] Je rafraîchis la page → je reste connecté (refresh token)
- [ ] `docker compose up` → tout démarre en < 30s

### KPI Sprint 01
- `docker compose up && npm run test` = 0 erreur
- Couverture tests auth ≥ 80%

---

## Sprint 02 — Ferme + Géographie + Temps (2 sem)

### Objectif
Le joueur choisit sa localisation, crée sa ferme avec un kit, voit le temps avancer.

### Semaine 1 — Dev

| # | Tâche | Agent | Critère done |
|---|-------|-------|-------------|
| 2.1 | Migration 002 (farm, region, department, prefecture, distance_matrix, server_config) | @database | Migrate passe |
| 2.2 | Seed géographie (~325 préfectures avec lat/lng) | @data | 325 préfectures en BDD |
| 2.3 | Seed distance_matrix (pré-calculé haversine) | @data | Distances entre préfectures |
| 2.4 | Routes GET /geography (regions, departments, prefectures) | @backend | 3 endpoints fonctionnels |
| 2.5 | POST /api/farms { prefecture_id, kit } | @backend | Ferme créée + kit appliqué |
| 2.6 | Service StarterKitService (crée véhicules, bâtiments, animaux selon kit+espèce) | @backend | Kit éleveur bovin = 9 véhicules + 7 bâtiments + 5 animaux |
| 2.7 | GET /api/server/time | @backend | Jour, mois, saison, année |
| 2.8 | Worker : tick journalier basique (reset HT, avance date) | @worker | HT reset à 40 chaque jour |
| 2.9 | Page /setup-farm (wizard 3 étapes + choix kit + sous-choix espèce) | @frontend | Wizard fonctionnel |
| 2.10 | Header enrichi (date Cultivia, saison, solde, barre HT) | @frontend | Infos visibles |
| 2.11 | Glossaire in-game (popup termes) | @frontend | Clic sur "HT" → définition |
| 2.12 | Tutoriel F112 (5 étapes, skippable, liens cliquables) | @frontend | Tutoriel affiché après création ferme |
| 2.13 | Registre RGPD (page /legal) | @docs | Page accessible |

### Semaine 2 — Tests + Validation

| # | Test | Critère pass |
|---|------|-------------|
| T2.1 | POST /farms avec kit éleveur bovin → 5 animaux + 9 véhicules + 7 bâtiments | Vérifié en BDD |
| T2.2 | POST /farms avec kit cultivateur → 0 animaux + 10 véhicules + 3 bâtiments | Vérifié |
| T2.3 | POST /farms avec kit polyvalent → 2 animaux + 9 véhicules + 7 bâtiments | Vérifié |
| T2.4 | POST /farms déjà créée → 409 | Pas de double ferme |
| T2.5 | Tick minuit → jour +1, HT reset | Worker fonctionnel |
| T2.6 | Après 7 jours → mois +1 | Changement mois |
| T2.7 | Après 21 jours → saison change | Changement saison |
| T2.8 | Wizard UI → choix préfecture → choix kit → ferme créée | E2E |

### Validation utilisateur
- [ ] Je choisis Clermont-Ferrand → kit Éleveur → Bovin laitier → "Ferme créée !"
- [ ] Le header affiche "7 Avril — Printemps — 100 000€ — 40/40 HT"
- [ ] Le lendemain le jour avance, HT revient à 40
- [ ] Le tutoriel me guide en 5 étapes
- [ ] Je peux skip le tutoriel à chaque étape
- [ ] Le glossaire m'explique "HT = Heures de Travail"

---

## Sprint 03 — Bâtiments + Premier animal (2 sem)

### Semaine 1 — Dev

| # | Tâche | Agent | Critère done |
|---|-------|-------|-------------|
| 3.1 | Migration 003 (building, building_type, building_animal_capacity, vehicle, vehicle_type, animal, animal_breed, animal_genetics) | @database | Migrate passe |
| 3.2 | Seeds building_types (30) + vehicle_types (90) + animal_breeds (16 espèces) | @data | Données en BDD |
| 3.3 | F001 Construire bâtiment (service + route + tests) | @backend | POST /api/buildings |
| 3.4 | F072 Voir liste bâtiments | @backend | GET /api/buildings |
| 3.5 | F002 Acheter animal (avec transport par espèce, transit, HVC, usure) | @backend | POST /api/animals/buy |
| 3.6 | F003 Voir liste animaux | @backend | GET /api/animals |
| 3.7 | F004 Consulter fiche animal | @backend | GET /api/animals/:id |
| 3.8 | F048 Tick arrivée animaux en transit | @worker | Animal passe en available |
| 3.9 | Pages /buildings, /buildings/buy, /animals, /animals/:id | @frontend | 4 pages fonctionnelles |
| 3.10 | Composants DataTable, Modal, Toast, Button (réutilisables) | @frontend | Storybook ou page démo |
| 3.11 | Icône véhicule par espèce sur page achat (UX-03) | @frontend | Badge visible |
| 3.12 | Breadcrumb sur pages détail | @frontend | Navigation claire |
| 3.13 | Toast 5s + clic fermer | @frontend | Configurable |
| 3.14 | Sidebar avec icônes et groupes repliables | @frontend | Mémorisé localStorage |
| 3.15 | Header compact < 768px | @frontend | Responsive |
| 3.16 | Sélecteur pagination 20/50/100 | @frontend | Sur DataTables |
| 3.17 | PWA basique (manifest.json + service worker) | @frontend | Installable |

### Semaine 2 — Tests + Validation

| # | Test | Critère pass |
|---|------|-------------|
| T3.1 | Construire stabulation 100m² → 3000€ déduit, 2 HT | Solde + HT corrects |
| T3.2 | Construire avec solde insuffisant → 400 | Tooltip affiché |
| T3.3 | Acheter vache avec bétaillère → transit 7h | Animal in_transit |
| T3.4 | Acheter poule avec bétaillère → 400 "Utilitaire requis" | Bon véhicule exigé |
| T3.5 | Acheter cheval sans van → 400 | Bon véhicule exigé |
| T3.6 | Bâtiment plein → 400 "Pas de place" | Capacité vérifiée |
| T3.7 | Double-clic achat → 1 seul animal | Idempotency |
| T3.8 | Tick arrivée → animal disponible | Worker OK |
| T3.9 | Transport minimum 20€ même à 0km | Coût minimum |

### Validation utilisateur
- [ ] Je construis une stabulation → toast "🏗️ Stabulation construite !"
- [ ] J'achète une vache → toast "🐄 Montbéliarde achetée ! Transport 348km"
- [ ] Le bouton est grisé si je n'ai pas assez d'argent → tooltip explique
- [ ] L'animal apparaît "En transit" puis "Disponible" le lendemain
- [ ] La sidebar a des icônes 🐄🏗️🌾 et se replie
- [ ] Le breadcrumb affiche "Dashboard > Animaux > Marguerite"

---

## Sprints 04-12 — Même structure

> Chaque sprint suit le même pattern :
> 1. Migration SQL pour les nouvelles tables
> 2. Services + routes pour chaque flow du sprint
> 3. Tests unitaires + intégration (budget 30%)
> 4. Pages + composants frontend
> 5. Améliorations UX du backlog assignées à ce sprint
> 6. Déploiement staging lundi S2
> 7. Fix bugs mardi S2
> 8. Démo PO mercredi S2
> 9. Déploiement prod jeudi S2
> 10. Rétrospective vendredi S2

### Sprint 04 — Nourrir + Abreuver (2 sem)
**Flows :** F006, F007, F008, F009, F010, F031, F050, F053, F068, F104
**UX :** Ration basique défaut (UX-06), filtre "Action requise" (D-06)
**Validation :** "Je nourris mes 4 vaches → stock déduit → icône passe de ❌ à ✅"

### Sprint 05 — Soins + Litière (1 sem)
**Flows :** F011, F012, F013, F014, F015, F016, F017, F052, F075, F107
**UX :** Comparatif litière/caillebotis (UX-02), stepper sol (P34)
**Validation :** "Mon animal est malade → je soigne → guérison en 3j"

### Sprint 06 — Reproduction (2 sem)
**Flows :** F018, F019, F020, F021, F022
**UX :** Calendrier reproduction (UX-04)
**Validation :** "J'insèmine ma vache → 63j plus tard → naissance d'un veau !"

### Sprint 07 — Traite + Productions + Vente (2 sem)
**Flows :** F023, F024, F025, F071, F080, F081, F082, F083, F097, F098, F099, F100, F114
**UX :** Raccourci vente lait (UX-raccourci)
**Validation :** "Je trais → je vends le lait → solde augmente. Je tonds → je vends la laine."

### Sprint 08 — Dashboard + Déplacements + Employés (2 sem)
**Flows :** F027, F028, F029, F030, F051
**UX :** Fil actualité (UX-10), sidebar par boucle, mode carte tablette (D-09), message encouragement
**Validation :** "Le dashboard montre toutes mes stats. Je déplace mes vaches au pré."

### Sprint 09 — Finances + Social (2 sem)
**Flows :** F032, F033, F034, F065, F066, F067, F079, F094, F095, F096, F105, F111, F116
**UX :** Récap charges (UX-07), mode sobre (D-04), mode expert (D-08)
**Validation :** "Je souscris un prêt → mensualités débitées chaque mois. Le P&L me montre mes marges."

### Sprint 10 — Parcelles + Cultures base (2 sem)
**Flows :** F035, F036, F037, F038, F077, F086, F087, F088, F110, F115
**UX :** Cultures recommandées (UX-05), tendance cours (UX-08)
**Validation :** "J'achète 10ha → je prépare le sol → je sème du blé. Le cours du marché fluctue."

### Sprint 11 — Cycle culture complet (2 sem)
**Flows :** F039, F040, F041, F042, F046, F054, F055, F056, F057, F058, F059, F060, F084, F085, F101, F102, F103
**UX :** Breakdown rendement (UX-01), tooltip presser/broyer (UX-09)
**Validation :** "Je récolte 70T de blé → le breakdown me montre les 9 facteurs → je vends au marché."

### Sprint 12 — Matériels + ETA (2 sem)
**Flows :** F043, F044, F045, F047, F049, F061, F062, F063, F064, F073, F089, F090, F113
**Validation :** "J'achète un tracteur neuf → livraison 2h → je l'entretiens → je le vends à un joueur."

---

## Validation finale MVP (après Sprint 12)

### Beta fermée (100 joueurs, 30 jours)
- [ ] Inscription → choix kit → premiers pas sans blocage
- [ ] Boucle élevage complète (acheter → nourrir → traire → vendre)
- [ ] Boucle cultures complète (acheter parcelle → semer → récolter → vendre)
- [ ] Commerce P2P (annonces, achat entre joueurs)
- [ ] Finances (prêt, épargne, charges mensuelles)
- [ ] Social (amis, classements, messagerie)
- [ ] 0 erreur 500 en 24h
- [ ] Rétention J7 > 40%
- [ ] NPS > +40
- [ ] Couverture tests globale ≥ 80%

### Go/No-Go production
Validé par : PO + CTO + Lead QA
Critères : beta fermée réussie + 0 bug bloquant + NPS > +40
