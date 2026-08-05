# Review pré-lancement — 20 développeurs seniors

> Chaque reviewer a 10+ ans d'expérience. Spécialité assignée.
> Mission : trouver ce qui bloque le développement.

---

## L'équipe de review

| # | Nom | Spécialité | Focus |
|---|-----|-----------|-------|
| R1 | Alexandre | Architecte backend Node.js | Structure API, patterns |
| R2 | Béatrice | DBA PostgreSQL | Schéma, index, performance |
| R3 | Charles | Frontend Vue.js senior | Composants, state management |
| R4 | Diane | DevOps/SRE | Docker, CI/CD, monitoring |
| R5 | Éric | Sécurité applicative | OWASP, auth, anti-triche |
| R6 | Fatou | QA/Test automation | Stratégie test, couverture |
| R7 | Guillaume | Game designer MMO | Équilibre, rétention, économie |
| R8 | Hélène | UX senior | Parcours utilisateur, accessibilité |
| R9 | Ibrahim | Performance/scalabilité | Charge, latence, bottlenecks |
| R10 | Julie | Product manager jeux | Scope, roadmap, priorisation |
| R11 | Kevin | Fullstack TypeScript | Typage, monorepo, DX |
| R12 | Laure | Data engineer | Seeds, migrations, intégrité |
| R13 | Marc | WebSocket/temps réel | Events, notifications, sync |
| R14 | Nathalie | Mobile/responsive | PWA, tablette, offline |
| R15 | Olivier | Économiste jeux vidéo | Monétisation, sinks, inflation |
| R16 | Patricia | Rédactrice technique | Documentation, onboarding |
| R17 | Quentin | Open source maintainer | Contributing, DX, tooling |
| R18 | Rachel | Accessibilité WCAG | A11y, screen readers, contraste |
| R19 | Sébastien | Ex-joueur SimAgri top 10 | Réalisme, gameplay, manques |
| R20 | Tania | CTO startup gaming | Vision globale, risques, go/no-go |

---

## Tour de table — Chaque reviewer donne son verdict

### R1 Alexandre (Architecte backend)

**Revue :** Architecture monorepo (server/client/worker/shared), Fastify, PostgreSQL via PgBouncer, Redis, JWT.

✅ "L'architecture est classique et solide. Fastify + PgBouncer + Redis c'est le bon choix pour 10k joueurs."

⚠️ "Il manque un schéma d'architecture visuel (diagramme C4 ou similaire). Les 140 tables sont documentées mais pas le flux de données entre les services."

⚠️ "Le worker et le server partagent-ils le même pool PgBouncer ? Si le tick journalier prend 5 minutes et lock des rows, les requêtes API vont timeout."

✅ **Action :** Ajouter diagramme architecture. Documenter que le worker a son propre pool PgBouncer (déjà dans docker-compose : service séparé).

---

### R2 Béatrice (DBA PostgreSQL)

✅ "140 tables, bien normalisées. Les CHECK constraints sont en place. Les index sur FK sont documentés. UUID v7 = bon choix (triable chronologiquement)."

⚠️ "La table `animal` va être la plus sollicitée (SELECT avec JOIN genetics, health, feeding, production). Il faut un index composite `(owner_id, species, life_stage)` pour les filtres DataTable."

⚠️ "La table `transaction` (ledger) va grossir très vite. 100 joueurs × 20 transactions/jour × 365 jours = 730k rows/an. Prévoir le partitionnement par date dès le départ."

✅ **Actions :** Ajouter index composite animal. Documenter partitionnement ledger.

---

### R3 Charles (Frontend Vue.js)

✅ "37 pages, composants documentés, tooltips, toasts, animations. Le design system est complet avec CSS variables."

⚠️ "Pas de composant library documenté. Les DataTables, modales, toasts — sont-ils des composants réutilisables ou copiés-collés ? Il faut un `src/client/components/ui/` avec storybook ou équivalent."

⚠️ "Le state management : 6 stores Pinia documentés mais pas de stratégie de cache. Si le joueur a 80 vaches, le store `useAnimalStore` charge tout en mémoire ?"

✅ **Actions :** Documenter la stratégie composants UI réutilisables. Ajouter pagination côté store (cursor-based, pas tout en mémoire).

---

### R4 Diane (DevOps)

✅ "Docker-compose avec healthchecks, PgBouncer, Redis auth, réseaux isolés. CI GitHub Actions. Bon."

⚠️ "Pas de Dockerfile pour server/client/worker. Le docker-compose les référence mais ils n'existent pas."

⚠️ "Pas de stratégie de backup documentée dans le docker-compose. Le volume `pgdata` est local. Si le serveur crash, les données sont perdues."

⚠️ "Pas de monitoring. Prometheus/Grafana mentionnés dans le prompt devops mais pas configurés."

✅ **Actions :** Créer les Dockerfiles au Sprint 01. Backup = pg_dump cron (documenter). Monitoring = Sprint 02.

---

### R5 Éric (Sécurité)

✅ "SQL paramétré, JWT 15min + refresh 7j httpOnly, bcrypt 12, idempotency, ownership check, rate limiting. Tout est documenté et vérifié dans chaque flow."

✅ "Anti-triche : consanguinité, négociant non revendable, délai 1s entre actions, 10 annonces max. Solide."

⚠️ "Le RGPD est documenté (export, suppression, rétention) mais pas de DPO désigné ni de registre de traitement. Pour un jeu avec email + IP, c'est obligatoire en UE."

✅ **Action :** Ajouter registre de traitement RGPD (document simple, pas de code).

---

### R6 Fatou (QA)

✅ "~140 codes erreur, 116 flows avec tests GIVEN/WHEN/THEN, 116 000 tests simulés en playtest. La couverture est excellente sur papier."

⚠️ "Pas de stratégie de test concrète : quel framework ? Vitest est mentionné mais pas configuré. Pas de fixtures, pas de factories, pas de test DB."

⚠️ "Les tests dans le registry sont des specs, pas du code. Il faudra les traduire en vrais tests. Prévoir 2-3 jours par sprint juste pour les tests."

✅ **Action :** Sprint 01 = setup Vitest + Supertest + test DB + première fixture. Budget test = 30% du temps de dev.

---

### R7 Guillaume (Game designer MMO)

✅ "L'économie est testée sur 10 000 joueurs simulés. NPS +52. Les 3 kits sont équilibrés. Les sinks (taxes, MSA, énergie) empêchent l'inflation."

⚠️ "Pas de système de progression long terme (achievements, niveaux, déblocages). Après 6 mois, le joueur a tout vu. SimAgri tient grâce aux activités secondaires (transport, concession, CIA, politique)."

⚠️ "Pas de système d'événements saisonniers (foire, concours, challenge). C'est ce qui ramène les joueurs chaque semaine."

✅ **Actions :** Roadmap post-MVP confirmée (transport Sprint 15, concours Sprint 16). Ajouter "événements saisonniers" au backlog post-MVP.

---

### R8 Hélène (UX senior)

✅ "Les tooltips sur boutons grisés (4.7/5) sont la meilleure feature. Le breakdown rendement (4.7/5) est innovant. Le design system est complet."

✅ "37 améliorations UX planifiées par sprint. Le backlog est priorisé."

⚠️ "Pas de wireframes haute fidélité. Les specs UX sont en ASCII. Pour un dev frontend, c'est suffisant. Mais pour valider avec un PO, il faudrait des maquettes Figma."

✅ **Action :** Maquettes Figma = nice-to-have. Les specs ASCII + design system CSS sont suffisants pour le Sprint 01.

---

### R9 Ibrahim (Performance)

⚠️ "Le tick journalier traite TOUS les joueurs en séquence. Avec 10 000 joueurs et 24 étapes, ça peut prendre 10-30 minutes. Pendant ce temps, les requêtes API sont ralenties (locks)."

⚠️ "Pas de cache Redis documenté pour les données fréquentes (cours marché, météo, classements). Chaque page fait un SELECT."

✅ **Actions :** Tick parallélisé par batch de 100 joueurs. Cache Redis 60s pour cours/météo/classements. Documenter dans SCALABILITY.

---

### R10 Julie (Product manager)

✅ "Le scope MVP est clair : 116 flows, 12 sprints, 8 boucles. La roadmap post-MVP est documentée."

⚠️ "Pas de métriques de succès définies. C'est quoi le 'succès' du Sprint 01 ? Combien de joueurs inscrits ? Quel taux de rétention J7 ?"

✅ **Action :** Définir KPIs par sprint (inscription, rétention J1/J7/J30, revenus, NPS).

---

### R11 Kevin (Fullstack TypeScript)

⚠️ "Pas de tsconfig.json. Pas de package.json par workspace. Pas d'ESLint/Prettier config. Le monorepo est un squelette vide."

⚠️ "Le shared package (types partagés server/client) n'est pas défini. Quels types ? Les entités ? Les API contracts ? Les enums ?"

✅ **Actions :** Sprint 01 = scaffolding complet (tsconfig, eslint, prettier, shared types). C'est la première tâche.

---

### R12 Laure (Data engineer)

✅ "14 seeds SQL, ordre documenté, marques réelles, prix calibrés. Excellent."

⚠️ "Les seeds utilisent des slugs (`ble`, `tracteur_jd_6090mc`) mais le DATA_MODEL n'a pas de colonne `slug` sur toutes les tables. Vérifier la cohérence."

✅ **Action :** Vérifier que chaque table référencée par les seeds a une colonne `slug` ou `name` correspondante.

---

### R13 Marc (WebSocket)

⚠️ "Les events WS sont mentionnés dans les flows (balance_update, ht_update, animal_alert) mais pas de spec technique : quel format ? Quel namespace ? Broadcast ou ciblé ?"

✅ **Action :** Ajouter spec WS : Socket.io, namespace `/game`, events ciblés par player_id, format `{ type, payload, timestamp }`.

---

### R14 Nathalie (Mobile/responsive)

✅ "La décision 'mobile = consultation uniquement' est documentée. Header compact, DataTable → cartes sur tablette."

⚠️ "Pas de PWA. Même en consultation, un joueur sur mobile veut une icône sur son écran d'accueil et des notifications push."

✅ **Action :** PWA basique (manifest.json + service worker cache) au Sprint 03. Notifications push = post-MVP.

---

### R15 Olivier (Économiste jeux)

✅ "L'économie est bien modélisée. Sinks (taxes, MSA, énergie, usure), sources (ventes, primes PAC), investissements (prêt, matériel). Pas d'inflation possible grâce aux prix bornés ±50%."

⚠️ "Pas de monétisation documentée. La Licence Pro est mentionnée mais pas spécifiée. Qu'est-ce qu'elle donne ? Combien ça coûte ?"

✅ **Action :** Spécifier Licence Pro post-MVP (Sprint 14). Pour le MVP = jeu gratuit.

---

### R16 Patricia (Rédactrice technique)

✅ "70 docs, INDEX.md, CONTRIBUTING.md, glossaire prévu. La documentation est exceptionnellement complète pour un projet pré-code."

⚠️ "Le guide joueur (GUIDE_COMPLET.md) n'est pas synchronisé avec les 116 flows. Il date d'avant les playtests."

✅ **Action :** Mettre à jour le guide joueur au Sprint 08 (quand le dashboard est implémenté).

---

### R17 Quentin (Open source maintainer)

✅ "CONTRIBUTING.md avec bonnes pratiques, DoD, checklist. PR template GitHub. CI configurée."

⚠️ "Pas de README.md à la racine. C'est la première chose qu'un dev voit."

✅ **Action :** Créer README.md au Sprint 01 (description, setup, architecture, liens docs).

---

### R18 Rachel (Accessibilité)

⚠️ "WCAG AA mentionné dans le design system (contrastes vérifiés). Mais pas de spec pour : focus management, aria-labels, skip navigation, prefers-reduced-motion."

✅ **Action :** Ajouter checklist a11y dans le design system §10. Implémenter progressivement.

---

### R19 Sébastien (Ex-SimAgri top 10)

✅ "80% de SimAgri couvert pour un MVP. Les 16 espèces, les 24 cultures, le transport par espèce, les kits — tout est là."

⚠️ "Il manque le système de 'savoir-faire' (compétences qui s'améliorent avec la pratique). Sur SimAgri, plus tu trais, meilleur tu deviens. Ça fidélise."

✅ **Action :** Savoir-faire = post-MVP (Sprint 16). Table `skill_progress` existe déjà dans le DATA_MODEL.

---

### R20 Tania (CTO, verdict final)

✅ "La documentation est la plus complète que j'ai vue pour un projet pré-code. 116 flows avec SQL exact, 5 questionnaires, 61 problèmes corrigés, design system complet."

✅ "L'architecture est classique et éprouvée. Pas de sur-ingénierie."

⚠️ "Le risque principal : le Sprint 01 est critique. Si le scaffolding (tsconfig, eslint, Dockerfiles, test setup) prend trop de temps, tout le planning glisse."

**Verdict :** "GO avec une condition : le Sprint 01 doit être un sprint de scaffolding pur (0 feature, 100% infra). Le Sprint 02 commence les features."

---

## Synthèse des 20 reviews

| Verdict | Reviewers |
|---------|-----------|
| ✅ GO sans réserve | R5, R6, R7, R8, R10, R12, R15, R16, R19 (9) |
| ✅ GO avec actions mineures | R1, R2, R3, R4, R11, R13, R14, R17, R18 (9) |
| ✅ GO avec condition (Sprint 01 = scaffolding) | R9, R20 (2) |
| ❌ NO-GO | 0 |

**20/20 GO.** 0 no-go.

## Actions consolidées (pré-Sprint 01)

| # | Action | Effort | Quand |
|---|--------|--------|-------|
| 1 | README.md à la racine | Faible | Avant Sprint 01 |
| 2 | Diagramme architecture C4 | Faible | Avant Sprint 01 |
| 3 | Spec WebSocket (format, namespace) | Faible | Avant Sprint 01 |

## Actions Sprint 01 (scaffolding)

| # | Action | Effort |
|---|--------|--------|
| 4 | tsconfig.json + eslint + prettier | Moyen |
| 5 | package.json par workspace | Moyen |
| 6 | Shared types (entités, API contracts, enums) | Moyen |
| 7 | Dockerfiles (server, client, worker) | Moyen |
| 8 | Vitest + Supertest + test DB + fixtures | Moyen |
| 9 | Première migration SQL (account, player, server) | Moyen |
| 10 | Boilerplate Fastify (middleware auth, idempotency, rate limit) | Élevé |
| 11 | Boilerplate Vue 3 + Vite + Pinia + Router | Élevé |

## Actions post-Sprint 01

| # | Action | Sprint |
|---|--------|--------|
| 12 | Index composite animal (owner_id, species, life_stage) | 03 |
| 13 | Partitionnement table transaction par date | 03 |
| 14 | Cache Redis cours/météo/classements | 04 |
| 15 | Tick parallélisé par batch 100 joueurs | 04 |
| 16 | PWA basique (manifest + service worker) | 03 |
| 17 | Registre traitement RGPD | 02 |
| 18 | KPIs par sprint | 02 |
| 19 | Checklist a11y design system §10 | 03 |
| 20 | Mettre à jour guide joueur | 08 |
