# CULTIVIA — Matrice des Compétences & Plan de Staffing
## Version 2.1 — Mis à jour le 2026-04-09

> **324 actions** | **63 tables** | **~230 routes API** | **~80 pages UI** | **~51 semaines**

---

# 1. RÔLES NÉCESSAIRES

## 1.1 Équipe Core (MVP)

| Rôle | Nb | Compétences requises | Séniorité |
|------|----|----------------------|-----------|
| **Tech Lead / Architecte** | 1 | Node.js, PostgreSQL, system design, WebSocket, DevOps | Senior (5+ ans) |
| **Fullstack Dev** | 2 | Next.js, React, TypeScript, tRPC, Drizzle ORM, PostgreSQL | Mid-Senior (3+ ans) |
| **Game Designer** | 1 | Balancing, économie virtuelle, simulation, Excel/data | Mid (2+ ans jeu) |
| **UI/UX Designer** | 1 | Figma, design system, responsive, accessibilité, jeux web | Mid (3+ ans) |
| **DevOps / SRE** | 0.5 | Docker, CI/CD, monitoring, PostgreSQL tuning, Redis | Mid (3+ ans) |

**Total MVP : 5.5 personnes**

## 1.2 Équipe Scale (post-MVP)

| Rôle | Nb | Compétences requises |
|------|----|----------------------|
| **Frontend Dev** | +1 | React, animations, Canvas/WebGL (vue iso), perf |
| **Backend Dev** | +1 | Node.js workers, queues, optimisation BDD, caching |
| **QA / Testeur** | 1 | Playwright, tests E2E, tests de charge, game testing |
| **Community Manager** | 1 | Modération, forums, Discord, support joueurs |
| **Data Analyst** | 0.5 | SQL, métriques jeu, balancing, économie |
| **Artiste 2D** | 0.5 | Icônes, illustrations matériel/animaux, UI assets |

**Total Scale : +4 personnes = 9.5 total**

---

# 2. MATRICE DES COMPÉTENCES DÉTAILLÉE

## 2.1 Frontend

| Compétence | Niveau requis | Utilisé pour |
|------------|---------------|--------------|
| React 19 + Server Components | Expert | Toutes les pages |
| Next.js 15 App Router | Expert | SSR, routing, middleware |
| TypeScript strict | Expert | Tout le code |
| TailwindCSS | Avancé | Styling responsive |
| Shadcn/UI | Avancé | Composants (tables, forms, dialogs) |
| Zustand | Intermédiaire | State management client |
| TanStack Query | Avancé | Cache API, mutations, optimistic updates |
| tRPC client | Avancé | Appels API type-safe |
| Framer Motion | Intermédiaire | Animations UI |
| Canvas/Pixi.js | Intermédiaire | Vue isométrique ferme 3D |
| Socket.io client | Intermédiaire | Chat, notifications temps réel |
| PWA (Service Workers) | Intermédiaire | Post-MVP : installation mobile, offline |
| Accessibilité (ARIA) | Intermédiaire | WCAG 2.1 AA |
| i18n (next-intl) | Intermédiaire | FR/EN |

## 2.2 Backend

| Compétence | Niveau requis | Utilisé pour |
|------------|---------------|--------------|
| Node.js 22 | Expert | Serveur principal |
| TypeScript strict | Expert | Tout le code |
| tRPC | Avancé | API type-safe |
| Drizzle ORM | Avancé | Queries, migrations, relations |
| PostgreSQL 16 | Expert | Schéma, indexes, JSONB, transactions |
| Redis 7 | Avancé | Cache, sessions, pub/sub, leaderboards |
| Socket.io server | Avancé | Temps réel |
| Node.js Workers | Intermédiaire | Calculs quotidiens (DAILY_UPDATE) |
| Bull/BullMQ | Intermédiaire | Job queues (cron, async tasks) |
| NextAuth.js v5 | Intermédiaire | Auth, sessions |
| Rate limiting | Intermédiaire | Anti-abus |
| Zod | Avancé | Validation input |

## 2.3 Game Design

| Compétence | Niveau requis | Utilisé pour |
|------------|---------------|--------------|
| Économie virtuelle | Expert | Balancing prix, revenus, inflation |
| Simulation farming | Avancé | Mécaniques élevage, cultures, météo |
| Spreadsheet modeling | Expert | Tableaux rations, rendements, génétique |
| Progression design | Avancé | Onboarding, courbe difficulté |
| Multiplayer economy | Avancé | Marché joueur-joueur, coopératives |
| Data analysis | Intermédiaire | Métriques, A/B testing |
| Documentation | Expert | GDD, specs, wiki |

## 2.4 UI/UX Design

| Compétence | Niveau requis | Utilisé pour |
|------------|---------------|--------------|
| Figma | Expert | Maquettes, prototypes, design system |
| Design System | Avancé | Composants réutilisables, tokens |
| Responsive design | Expert | Desktop-first, responsive, tablette |
| Information architecture | Avancé | Navigation 200+ pages |
| Data visualization | Avancé | Graphiques, jauges, tableaux |
| Isometric art direction | Intermédiaire | Vue ferme 3D |
| Accessibilité | Avancé | Contraste, tailles, navigation clavier |
| User research | Intermédiaire | Tests utilisateurs, feedback |
| Micro-interactions | Intermédiaire | Animations feedback |

## 2.5 DevOps / Infrastructure

| Compétence | Niveau requis | Utilisé pour |
|------------|---------------|--------------|
| Docker + Docker Compose | Avancé | Toute l'infra |
| CI/CD (GitHub Actions) | Intermédiaire | Build, test, deploy |
| PostgreSQL admin | Avancé | Backup, tuning |
| Redis admin | Intermédiaire | Cache, persistence |
| Monitoring (Grafana) | Intermédiaire | Métriques serveur + jeu |
| Traefik | Intermédiaire | Reverse proxy, SSL |
| Linux admin | Intermédiaire | VPS, sécurité, firewall |

---

# 3. ESTIMATION EFFORT

## 3.1 Phases de développement

| Phase | Durée | Livrables |
|-------|-------|-----------|
| **Phase 0 : Setup** | 2 semaines | Repo, Docker, BDD, auth, design system, DataTable, CI |
| **Phase 1 : Core Farm** | 8 semaines | Élevage complet, bâtiments, HT, dashboard, DAILY_UPDATE |
| **Phase 2 : Cultures** | 6 semaines | Parcelles, cycle cultural, météo, sol, irrigation, paille/foin |
| **Phase 3 : Matériel + Commerce** | 6 semaines | Catalogue, usure/pannes, HVC, GPS, coopérative, marchés |
| **Phase 4 : Reproduction** | 4 semaines | 3 modes insémination, génétique, IVRAD, labels |
| **Phase 5 : Social + Finance** | 4 semaines | Amis, messagerie, forums, prêts, épargne, CECA |
| **Phase 6 : Transport** | 3 semaines | Licences, chauffeurs, demandes, livraisons |
| **Phase 7 : Activités secondaires** | 8 semaines | Concessionnaire, CIA, fromagerie, ETA |
| **Phase 8 : Activités avancées** | 6 semaines | Maraîchage, viticulture, forêts, CAR, méthanisation, foie gras |
| **Phase 9 : Polish** | 4 semaines | Vue iso 3D, animations, perf, mobile, tests E2E |

**Total estimé : ~51 semaines (~12 mois) avec équipe MVP de 5.5 personnes**

## 3.2 Complexité par module

| Module | Entités BDD | API Routes | Pages UI | Complexité |
|--------|-------------|------------|----------|------------|
| Auth/Profil | 3 | 8 | 5 | 🟢 Faible |
| Élevage | 6 | 25 | 8 | 🔴 Très haute |
| Cultures | 4 | 15 | 6 | 🔴 Très haute |
| Matériel | 3 | 15 | 5 | 🟡 Moyenne |
| Bâtiments | 2 | 10 | 3 | 🟢 Faible |
| Commerce/Marché | 4 | 20 | 8 | 🔴 Très haute |
| Finance | 5 | 12 | 4 | 🟡 Moyenne |
| Transport | 3 | 10 | 4 | 🟡 Moyenne |
| Social | 6 | 18 | 6 | 🟡 Moyenne |
| Concessionnaire | 3 | 12 | 5 | 🟡 Moyenne |
| CIA | 4 | 10 | 4 | 🟡 Moyenne |
| Fromagerie | 3 | 10 | 4 | 🟡 Moyenne |
| Viticulture | 4 | 15 | 6 | 🔴 Très haute |
| Arboriculture | 2 | 8 | 3 | 🟡 Moyenne |
| Forêts/ETF | 4 | 12 | 4 | 🟡 Moyenne |
| Maraîchage | 5 | 14 | 5 | 🟡 Moyenne |
| CAR | 3 | 12 | 5 | 🟡 Moyenne |
| Méthanisation | 2 | 6 | 2 | 🟢 Faible |
| Foie gras | 2 | 5 | 2 | 🟢 Faible |
| CECA | 4 | 8 | 3 | 🟢 Faible |
| Game Engine | 0 | 0 | 0 | 🔴 Très haute |
| **TOTAL** | **~75** | **~230** | **~80** | |

---

# 4. RISQUES TECHNIQUES

| Risque | Impact | Mitigation |
|--------|--------|------------|
| DAILY_UPDATE trop lent (>5min) | Joueurs bloqués | Workers parallèles, batch processing |
| Économie déséquilibrée | Joueurs quittent | Game designer dédié, simulations Excel |
| Scalabilité | Perf dégradée si >500 joueurs | Monitoring, optimisation queries, cache Redis |
| Complexité BDD (63 tables) | Bugs, lenteur | Drizzle migrations, tests intégration (28 tests API) |
| Triche/multi-comptes | Économie cassée | Fingerprinting, rate limiting, modération |
| Mobile UX (200+ pages) | Abandon mobile | Desktop-first design, progressive disclosure |
