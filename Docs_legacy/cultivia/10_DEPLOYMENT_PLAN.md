# CULTIVIA — Plan de Déploiement Feature par Feature
## Version 2.1 — Mis à jour le 2026-04-09

> Chaque feature = **1 jour max** de travail, testable en isolation.
> Découpage par couche : Schema → Seed → API → UI → Worker
> **324 actions** réparties sur **~120 micro-features**, **10 phases**, **~51 semaines**

### Avancement au 2026-04-09
| Phase | Features | Cochés | Statut |
|-------|----------|--------|--------|
| Phase 0 — Fondations | 13 | 46/46 | ✅ Terminée |
| Phase 1 — Ferme de base | 25 | 26/~150 | 🔄 En cours (F1.1-F1.8, F1.20-F1.22) |
| Phase 2-9 | ~100 | 0 | ⬜ À faire |

**Stack opérationnelle** : 5 containers Docker, 62 tables BDD, 2 263 communes, 14 espèces, 31 races, 25 cultures, 29 modèles matériel.
**Tests** : 51 (14 unit shared + 28 intégration API + 9 E2E Playwright). Tous passent.
**Commits** : 67
**Pages UI** : 7 (accueil, login, register, setup, dashboard, profil, bâtiments)
**Composants** : 10 (DataTable, GameLayout, FranceMap, ThemeToggle, UserMenu, Tutorial, DashboardClient, BuildingsClient, ResourceBar, base)
**API routes** : 7 (register, setup, dashboard, dashboard/tutorial, auth, ht, buildings)

### Règles de découpage
1. 1 feature = 4-8h de travail max
2. Testable en isolation avec un critère de validation clair
3. Séparation stricte : schema / seed / API / UI / worker
4. Dépendances explicites entre features
5. Traçabilité : chaque action (ELV-001, CUL-003…) est rattachée à une feature

### Légende
- ✅ = Fait
- `[schema]` `[seed]` `[api]` `[ui]` `[worker]` `[infra]` = type de tâche

---

# PHASE 0 — FONDATIONS (2 semaines, 12 features)

## F0.1 — Monorepo + Dockerfiles `[infra]`
**Dépendances** : Aucune
**Livrables** :
- [x] Structure `/frontend`, `/api`, `/shared`
- [x] `package.json` racine (workspaces)
- [x] `docker-compose.yml` (5 containers)
- [x] `tsconfig.base.json`
- [x] `.env.example`, `.gitignore`
- [x] `package.json` pour frontend, api, shared
- [x] Dockerfile frontend (Next.js 15)
- [x] Dockerfile api (Node.js 22)
- [x] `docker compose up` → page blanche Next.js + API health `/api/health`
**Validation** : `docker compose up` démarre 5 containers, `curl localhost:4000/api/health` → OK

## F0.2a — Schema BDD Core `[schema]`
**Dépendances** : F0.1
**Tables** (8) : `users`, `user_profiles`, `regions`, `departments`, `communes`, `commune_distances`, `weather_cache`, `game_state`
**Livrables** :
- [x] Drizzle ORM configuré (`drizzle.config.ts`, connexion PG)
- [x] Script `npm run db:generate` + `npm run db:migrate`
- [x] 8 tables Core avec types, contraintes, FK
**Validation** : `npm run db:migrate` crée les 8 tables sans erreur

## F0.2b — Schema BDD Élevage + Cultures `[schema]`
**Dépendances** : F0.2a
**Tables** (7) : `animals`, `animal_species`, `animal_breeds`, `animal_groups`, `parcels`, `crops`, `buildings`
**Validation** : Migration passe, tables créées avec FK vers `users`

## F0.2c — Schema BDD Matériel + Économie + Social `[schema]`
**Dépendances** : F0.2a
**Tables** (10) : `equipment`, `equipment_models`, `transactions`, `loans`, `savings`, `market_listings`, `contracts`, `friendships`, `messages`, `notifications`
**Validation** : Migration passe

## F0.2d — Schema BDD Activités + Employés `[schema]`
**Dépendances** : F0.2a
**Tables** (8) : `dealerships`, `cia_centers`, `cheese_factories`, `vineyards`, `transport_companies`, `cooperatives`, `employees`, `forum_posts`
**Validation** : Migration passe

## F0.2e — Schema BDD Avancées `[schema]`
**Dépendances** : F0.2a
**Tables** (28) : `eta_companies`, `eta_orders`, `challenges`, `challenge_entries`, `badges`, `user_badges`, `leaderboards`, `lottery_draws`, `lottery_tickets`, `cfsa_formations`, `cesa_elections`, `cesa_candidates`, `cesa_votes`, `cesa_proposals`, `ivrad_objectives`, `ivrad_slots`, `forests`, `forest_stations`, `market_gardens`, `greenhouses`, `garden_plots`, `orchards`, `methanization_plants`, `foie_gras_batches`, `farm_guards`, `farm_visits`, `audit_logs`, `energy_bills`
**Validation** : Migration passe, `SELECT count(*) FROM information_schema.tables WHERE table_schema='public'` → ~61

## F0.2f — Indexes + Contraintes `[schema]`
**Dépendances** : F0.2b, F0.2c, F0.2d, F0.2e
**Livrables** :
- [x] 5 indexes critiques (animals_user, parcels_user, market_type_region, transactions_user_date, animals_species)
- [x] Contraintes CHECK (solde ≥ 0, HT ≥ 0, usure 0-100)
- [x] Enums PostgreSQL (espèces, types bâtiment, statuts)
**Validation** : `\di` dans psql liste tous les indexes

## F0.3 — Seed Géographie `[seed]`
**Dépendances** : F0.2a
**Livrables** :
- [x] Script `scripts/seed-geo.ts`
- [x] Fetch geo.api.gouv.fr → 18 régions, 101 départements, ~340 communes
- [x] Calcul matrice distances Haversine → `commune_distances`
**Validation** : `SELECT count(*) FROM communes` → ~340, `SELECT count(*) FROM commune_distances` → ~57 000

## F0.4 — Auth NextAuth.js v5 `[api]` `[ui]`
**Dépendances** : F0.2a
**Actions** : `ADM-001`, `ADM-003`
**Livrables** :
- [x] NextAuth.js v5 (credentials provider)
- [x] Pages `/login`, `/register` (formulaires Shadcn)
- [x] Sessions JWT httpOnly, secure
- [x] Hash bcrypt cost 12
- [x] Middleware auth routes protégées
**Validation** : Inscription → login → session persistante → refresh OK

## F0.5 — tRPC Setup `[api]`
**Dépendances** : F0.4
**Livrables** :
- [x] Serveur tRPC dans `/api/src/trpc.ts`
- [x] Client tRPC dans `/frontend/src/lib/trpc.ts` (TanStack Query)
- [x] Router `auth` : `me`, `logout`
- [x] Middleware auth (session vérifiée)
- [x] Middleware rate limiting (express-rate-limit)
- [x] Types inférés end-to-end
**Validation** : `trpc.auth.me` depuis le frontend retourne le user connecté

## F0.6 — Design System + Layout `[ui]`
**Dépendances** : F0.5
**Livrables** :
- [x] TailwindCSS + Shadcn/UI initialisé
- [x] Composants de base : Button, Dialog, Input, Select, Toast, Skeleton, DropdownMenu
- [x] Thème sombre/clair (toggle)
- [x] Layout : En-tête (logo, nav, météo, HT, solde, profil) + Barre latérale + Contenu + Pied de page
- [x] Composants : `<ResourceBar>`, `<ActionButton>`, `<ConfirmDialog>`, `<NotificationToast>`
**Validation** : Layout visible avec en-tête fonctionnel (données mockées)

## F0.7 — Composant DataTable `[ui]`
**Dépendances** : F0.6
**Livrables** :
- [x] `<DataTable>` basé sur TanStack Table v8
- [x] Recherche full-text avec surlignage
- [x] Tri bidirectionnel (clic en-tête colonne)
- [x] Colonnes configurables (cases à cocher, localStorage)
- [x] Filtres par colonne (texte/nombre/enum/date)
- [x] Groupes déroulants (accordéon, badge compteur, tout déplier/replier)
- [x] Pagination (25/50/100/tout)
- [x] Sélection + actions groupées
- [x] Export CSV
- [x] Hook `useDataTable(config)`
**Validation** : DataTable avec données mockées, toutes les fonctionnalités opérationnelles

## F0.8 — CI GitHub Actions `[infra]`
**Dépendances** : F0.5
**Livrables** :
- [x] Workflow `.github/workflows/ci.yml` : lint + type-check sur PR
- [x] ESLint + Prettier configurés (0 warning)
**Validation** : PR bloquée si lint ou type-check échoue

---

# PHASE 1 — FERME DE BASE (8 semaines, 24 features)

## F1.1 — Seed espèces + races `[seed]`
**Dépendances** : F0.2b
**Livrables** :
- [ ] Script `scripts/seed-species.ts`
- [ ] 14 espèces dans `animal_species` (bovins laitiers, allaitants, porcins, caprins, ovins laitiers, ovins allaitants, lapins, volailles, pintades, oies, canards, bisons, daims, chevaux)
- [ ] ~80 races dans `animal_breeds` avec poids naissance/adulte, productions, indices
- [ ] Données de ration par espèce (JSONB)
- [ ] Surfaces minimales par espèce (JSONB)
**Validation** : `SELECT count(*) FROM animal_species` → 14, `SELECT count(*) FROM animal_breeds` → ~80

## F1.2 — Seed cultures + matériel `[seed]`
**Dépendances** : F0.2b, F0.2c
**Livrables** :
- [x] 25 cultures dans `crops` avec semis/récolte/prix/rotation/rendements par région
- [x] ~150 modèles matériel dans `equipment_models` (tracteurs, moissonneuses, outils)
- [x] Types de bâtiments (constantes dans `/shared/constants/buildings.ts`)
**Validation** : `SELECT count(*) FROM crops` → 25, `SELECT count(*) FROM equipment_models` → ~150

## F1.3 — API système HT `[api]`
**Dépendances** : F0.5, F0.2a
**Actions** : `FIN-003`, `FIN-005`
**Livrables** :
- [x] Router `finance.getHt` : retourne HT restants du joueur
- [x] Router `finance.buyHt` : acheter HT à un autre joueur (10€/HT)
- [x] Router `finance.sellHt` : vendre ses HT excédentaires
- [x] Service `HtService.deduct(userId, amount)` — utilisé par toutes les actions
- [x] Service `HtService.reset(userId)` — appelé par DAILY_UPDATE
- [x] Validation Zod sur chaque input
**Validation** : Acheter/vendre HT via tRPC, solde HT mis à jour

## F1.4 — API employés `[api]`
**Dépendances** : F1.3
**Actions** : `FIN-006`, `FIN-007`
**Livrables** :
- [ ] Router `employees.hire` : embaucher (type, salaire)
- [ ] Router `employees.fire` : licencier
- [ ] Router `employees.list` : liste des employés du joueur
- [ ] Logique : +35 HT/jour par employé agricole, salaire mensuel auto
**Validation** : Embaucher un employé → HT augmentent le lendemain

## F1.5 — UI Tableau de bord `[ui]`
**Dépendances** : F0.6, F1.3
**Livrables** :
- [ ] Page `/dashboard` — accueil après login
- [ ] Bloc alertes (pas mangé, pas bu, malades, morts, naissances)
- [ ] Bloc raccourcis (événements, marché, transport)
- [ ] Bloc notifications (50 dernières)
- [ ] Bloc graphique solde (7 derniers jours) — composant `<BalanceChart>`
- [ ] Bloc météo résumé
**Validation** : Page affichée avec données mockées, alertes visibles

## F1.6 — UI page Profil `[ui]`
**Dépendances** : F0.6
**Actions** : `ADM-002`
**Livrables** :
- [ ] Page `/profile` — infos, sécurité, préférences
- [ ] Modifier pseudo, avatar, nom de ferme
- [ ] Changer mot de passe
- [ ] Préférences notifications, thème, langue
**Validation** : Modifier son pseudo → sauvegardé en BDD

## F1.7a — API bâtiments (construire, agrandir, détruire) `[api]`
**Dépendances** : F0.5, F1.3
**Actions** : `BAT-001`, `BAT-002`, `BAT-003`, `BAT-010`
**Livrables** :
- [x] Router `buildings.build` : type, surface, niveau équipement → déduire €, HT, délai construction
- [x] Router `buildings.upgrade` (améliorer niveau 1→5) : agrandir (bâtiment vide requis)
- [x] Router `buildings.destroy` : détruire (récupère 10% prix)
- [x] Router `buildings.list` : liste bâtiments du joueur
- [x] Validation : 10 premiers = construction immédiate, ensuite délai
**Validation** : Construire un hangar → apparaît dans la liste

## F1.7b — API bâtiments (entretien, énergie) `[api]`
**Dépendances** : F1.7a
**Actions** : `BAT-004`, `BAT-012`
**Livrables** :
- [x] Router `buildings.maintain` : entretien (0.3 HT/bâtiment/mois)
- [x] Router `buildings.maintainExternal` : entretien externe (500€, −25% usure, 0 HT)
- [x] Calcul consommation énergie (kWh/jour selon niveau, utilisation, usure, saison)
- [x] Facture mensuelle (API energy_bill, table energy_bills) (0.08 €/kWh) → table `energy_bills`
**Validation** : Entretenir un bâtiment → usure diminue, facture énergie générée

## F1.7c — API accessoires bâtiment `[api]`
**Dépendances** : F1.7a
**Actions** : `BAT-005`, `BAT-006`, `BAT-011`, `BAT-013`
**Livrables** :
- [x] Accessoires = constructions indépendantes via modale Construire → Accessoires (10 types)
- [x] Pas de rattachement bâtiment (D29)
- [x] Router `buildings.activateLoading` : activer aire/silo de chargement
- [ ] Router `buildings.buildPipeline` : canalisation (BAT-013, dépend des parcelles F2)
**Validation** : Ajouter une cuve à eau à une stabulation → visible dans le bâtiment

## F1.8 — UI page Bâtiments `[ui]`
**Dépendances** : F1.7a, F1.7b, F1.7c, F0.7
**Livrables** :
- [x] Page `/buildings` avec sections déroulantes par type (Élevage, Stockage, Accessoire)
- [x] Colonnes : Nom, Type, Surface, Remplissage, Niveau, Usure + panneau détail inline
- [x] Modale construction 3 étapes (catégorie, type, config surface+niveau)
- [x] Modale accessoires (8 types, select + slider capacité)
- [x] Énergie recalculée dynamiquement selon niveau
**Validation** : Voir ses bâtiments, en construire un, voir la facture énergie

## F1.9a — API nourrir animaux `[api]`
**Dépendances** : F1.7a, F1.1
**Actions** : `ELV-001`, `ELV-002`, `ELV-036`, `ELV-037`, `ELV-038`
**Livrables** :
- [ ] Router `animals.feed` : nourrir manuellement (espèce, bâtiment, ration standard ou libre)
- [ ] Router `animals.feedRobot` : activer robot alimentation (185 000€, 0 HT, 1-15 jours)
- [ ] Router `animals.buyFood` : acheter nourriture animale à la coop
- [ ] Router `animals.buyConcentrate` : acheter concentré jeune
- [ ] Calcul quantité ration selon espèce/nombre
- [ ] Si ration libre : calcul couverture 4 besoins → bonus 0/10/20/30%
- [ ] Vérification stock silo suffisant
**Validation** : Nourrir des bovins → stock silo diminue, animaux marqués nourris

## F1.9b — API abreuver animaux `[api]`
**Dépendances** : F1.7c
**Actions** : `ELV-003`, `ELV-004`, `ELV-033`, `ELV-034`
**Livrables** :
- [ ] Router `animals.fillWaterTank` : remplir cuve à eau bâtiment (robinet ou pluie)
- [ ] Router `animals.fillWaterTrough` : remplir bac au pré (tonne à eau ou canalisation)
- [ ] Logique canalisation : remplissage auto si pipeline installé
- [ ] Logique source naturelle : remplissage auto gratuit
**Validation** : Remplir une cuve → niveau eau augmente

## F1.9c — API litière + fumier/lisier `[api]`
**Dépendances** : F1.7a
**Actions** : `ELV-005`, `ELV-006`, `ELV-007`, `ELV-008`, `ELV-042`, `ELV-047`, `ELV-048`
**Livrables** :
- [ ] Router `animals.bed` : pailler (pailleuse mécanique ou manuel)
- [ ] Router `animals.removeDung` : retirer fumier (chargeur + tracteur + benne → fosse ou parcelle)
- [ ] Router `animals.removeSlurry` : retirer lisier (caillebotis → fosse)
- [ ] Router `animals.fillRack` : remplir râtelier au pré
- [ ] Router `animals.purgeSlurryPit` : purger fosse à lisier
- [ ] Router `animals.chooseBeddingType` : litière vs caillebotis
- [ ] Calcul paille → fumier (transformation progressive)
**Validation** : Pailler → fumier s'accumule → retirer fumier → fosse se remplit

## F1.10 — API acheter animaux `[api]`
**Dépendances** : F1.9a, F1.1
**Actions** : `ELV-017`, `ELV-019`, `ELV-028`, `ELV-035`
**Livrables** :
- [ ] Router `animals.buyFromCoop` : acheter à la coopérative Cultivia (prix fixe, toujours dispo)
- [ ] Router `animals.buyFromDealer` : acheter au négociant (4 races/mois, adultes, abattoir only)
- [ ] Router `animals.buyDog` : acheter chien de berger (600€, 1/ferme)
- [ ] Génération indices génétiques aléatoires (moyenne serveur)
- [ ] Placement dans enclos d'arrivage
**Validation** : Acheter une vache → apparaît dans le bâtiment, solde débité

## F1.11 — API vendre animaux `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-020`, `ELV-021`, `ELV-051`, `ELV-052`
**Livrables** :
- [ ] Router `animals.sellSlaughter` : vendre à l'abattoir (rendement carcasse, conformation, engraissement)
- [ ] Router `animals.sellPrivate` : vendre en privé (ami spécial, prix libre)
- [ ] Router `animals.sellMarket` : mettre en vente sur marché régional/national
- [ ] Router `animals.respondOffer` : accepter/refuser offre privée
- [ ] Calcul prix abattoir : poids × rendement × conformation × engraissement × valorisation génétique
**Validation** : Vendre une vache à l'abattoir → solde crédité, animal retiré

## F1.12 — API déplacer animaux `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-014`, `ELV-015`, `ELV-016`, `ELV-032`
**Livrables** :
- [ ] Router `animals.moveToPasture` : mettre au pré (bétaillère : tracteur + bétaillère + HVC)
- [ ] Router `animals.moveToPastureDog` : mettre au pré (chien, même département, 0 HVC)
- [ ] Router `animals.moveToBuilding` : rentrer au bâtiment
- [ ] Router `animals.moveBetweenBuildings` : déplacer entre bâtiments
- [ ] Vérification saison (Avr-Oct pour la plupart)
- [ ] Calcul HT trajet (0.25 HT/zone)
**Validation** : Mettre une vache au pré → localisation change, HT déduits

## F1.13 — API gestion animaux (nommer, fusionner, divers) `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-029`, `ELV-030`, `ELV-031`, `ELV-039`, `ELV-040`, `ELV-041`, `ELV-043`, `ELV-044`, `ELV-045`, `ELV-046`
**Livrables** :
- [ ] Router `animals.name` : nommer un animal
- [ ] Router `animals.merge` : fusionner animaux (même race/âge → groupe)
- [ ] Router `animals.unmerge` : défusionner
- [ ] Router `animals.follow` : suivre/annoter un animal
- [ ] Router `animals.resurrect` : ressusciter animal mort (coût €)
- [ ] Router `animals.removeDead` : retirer animal mort
- [ ] Router `animals.buildFence` : poser clôture bisons/daims
- [ ] Router `animals.buildCorral` : construire corral
- [ ] Router `animals.prepareRation` : préparer ration bison/daim
- [ ] Router `animals.bringRation` : emmener ration au pré
**Validation** : Nommer un animal → nom visible, fusionner → groupe créé

## F1.14 — UI page Animaux `[ui]`
**Dépendances** : F1.9a à F1.13, F0.7
**Livrables** :
- [ ] Page `/animals` avec DataTable groupée par espèce
- [ ] Colonnes : Matricule, Race, Sexe, Âge, Poids, Santé, Bâtiment, Actions
- [ ] Onglets espèces (Bovins, Porcins, Caprins, Ovins, Lapins, Volailles…)
- [ ] Tableau de bord animaux (pas mangé, pas bu, malades, morts, naissances, eau)
- [ ] Boutons actions : Nourrir, Abreuver, Pailler, Retirer fumier, Traire, Œufs
- [ ] Modale achat animal (coopérative)
- [ ] Modale vente animal (abattoir/marché/privé)
- [ ] Modale déplacement (pré/bâtiment)
**Validation** : Voir ses animaux par espèce, nourrir, déplacer, vendre

## F1.15 — API productions (traite, œufs, laine) `[api]`
**Dépendances** : F1.9a
**Actions** : `ELV-009`, `ELV-010`, `ELV-011`
**Livrables** :
- [ ] Router `animals.milk` : traire (4x/jour max, salle de traite + cuve à lait)
- [ ] Router `animals.collectEggs` : collecter œufs (1x/jour, conditionnement + stockage)
- [ ] Router `animals.shear` : tondre laine / collecter duvet
- [ ] Calcul production selon race, ration, indice génétique
- [ ] Vérification créneaux traite (avant 6h, 12h, 18h, 24h)
**Validation** : Traire → lait dans la cuve, collecter œufs → stock augmente

## F1.16 — API vente productions `[api]`
**Dépendances** : F1.15
**Actions** : `COM-006`, `COM-007`, `COM-008`
**Livrables** :
- [ ] Router `market.sellMilk` : vendre lait (contrat laiterie ou coop)
- [ ] Router `market.sellEggs` : vendre œufs
- [ ] Router `market.sellWool` : vendre laine/duvet
- [ ] Prix selon qualité, bio (+20%), labels
**Validation** : Vendre du lait → solde crédité, stock cuve diminue

## F1.17 — API soins animaux `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-012`, `ELV-013`, `ELV-025`, `ELV-026`, `ELV-027`
**Livrables** :
- [ ] Router `animals.callVet` : appeler vétérinaire (coût HT + €)
- [ ] Router `animals.vaccinate` : vacciner (protection 1 an)
- [ ] Router `animals.enableSuckling` : activer allaitement (veau/agneau sous la mère)
- [ ] Router `animals.disableSuckling` : désactiver allaitement
- [ ] Router `animals.switchFarmingType` : conventionnel ↔ bio
**Validation** : Animal malade → vétérinaire → guéri, vacciner → protégé 1 an

## F1.18 — Worker DAILY_UPDATE v1 — Animaux `[worker]`
**Dépendances** : F1.9a à F1.17
**Livrables** :
- [ ] Cron 00:00 UTC via BullMQ
- [ ] `animalAging()` : +1 jour tous les animaux
- [ ] `hungerCheck()` : pas nourri → maladie (2 jours) → mort (5 jours)
- [ ] `waterCheck()` : pas abreuvé → maladie
- [ ] `animalGrowth()` : poids selon génétique + qualité ration (standard 100% ou libre +bonus)
- [ ] `milkProduction()` : calcul production lait quotidienne
- [ ] `eggProduction()` : calcul production œufs
- [ ] `woolGrowth()` : croissance laine/duvet
- [ ] Notifications générées (naissances, morts, maladies)
**Validation** : Après minuit → animaux vieillissent, non-nourris tombent malades

## F1.19 — Worker DAILY_UPDATE v1 — Ferme `[worker]`
**Dépendances** : F1.18
**Livrables** :
- [ ] `htReset()` : 35 HT base + 35/employé
- [ ] `buildingWear()` : usure quotidienne bâtiments (plus lente si hangar)
- [ ] `energyConsumption()` : calcul kWh/jour par bâtiment
- [ ] `salaryPayments()` : prélèvement mensuel salaires employés
- [ ] `energyBill()` : facture mensuelle énergie
- [ ] `robotFeeding()` : nourrissage auto si robot actif + stock suffisant
**Validation** : HT se reset, usure augmente, salaires prélevés mensuellement

## F1.20 — Onboarding — Inscription `[api]` `[ui]`
**Dépendances** : F0.4, F0.3
**Actions** : `ADM-001`
**Livrables** :
- [x] Flow multi-étapes : pseudo → email → mdp → région → département → commune
- [x] Carte de France interactive (sélection commune)
- [x] Infos affichées : climat, rendements moyens, nb joueurs installés
- [x] Validation Zod chaque étape
- [x] Création `user` + `user_profile` en transaction
**Validation** : Inscription complète → user créé avec commune rattachée

## F1.21 — Onboarding — Configuration initiale `[api]` `[ui]`
**Dépendances** : F1.20, F1.7a, F1.10
**Actions** : `ADM-004`
**Livrables** :
- [x] Choix bâtiment de départ (stabulation ou hangar)
- [x] Choix matériel de départ (tracteur + outil)
- [x] Choix animaux de départ (5 vaches ou 20 brebis ou 50 poules)
- [x] Solde initial (50 000€)
- [x] Création en transaction (bâtiment + matériel + animaux + solde)
**Validation** : Nouveau joueur → ferme configurée, prêt à jouer

## F1.22 — Onboarding — Tutoriel `[ui]`
**Dépendances** : F1.21
**Livrables** :
- [x] Tutoriel interactif (overlay guidé, 5-7 étapes)
- [x] Étapes : voir tableau de bord → nourrir animaux → voir parcelles → acheter à la coop → consulter solde
- [x] Marqueur `user_profiles.tutorial_completed`
- [x] Possibilité de skip
**Validation** : Nouveau joueur guidé pas à pas, peut skip

## F1.23 — UI page Inventaire / Stocks `[ui]`
**Dépendances** : F1.7a, F0.7
**Livrables** :
- [ ] Page `/inventory` avec DataTable groupée par catégorie (Céréales, Fourrages, Engrais, Produits, Divers)
- [ ] Colonnes : Produit, Quantité, Emplacement, Unité
- [ ] Agrégation de tous les stocks (silos, hangars, cuves, fosses)
- [ ] Indicateurs capacité stockage (silos X%, hangars Y%, cuves Z%)
- [ ] Lien direct depuis la modale ration libre
**Validation** : Voir tous ses stocks en un seul endroit

## F1.24 — UI page Journal de bord `[ui]`
**Dépendances** : F0.7
**Livrables** :
- [ ] Page `/journal` avec DataTable historique actions
- [ ] Colonnes : Heure, Action, Détail, HT consommés, € impact
- [ ] Filtres : date, type d'action
- [ ] Résumé journée (HT utilisés, € net, nb actions)
- [ ] Utilise la table `audit_logs` existante
**Validation** : Voir l'historique de ses actions du jour, filtrer par type

## F1.25 — Mode Vacances `[api]` `[ui]`
**Dépendances** : F1.18
**Livrables** :
- [ ] Router `farm.activateVacation` : activer mode vacances (max 7 jours/saison)
- [ ] Coût quotidien en € (simule un remplaçant)
- [ ] DAILY_UPDATE : nourrissage + abreuvement auto si mode vacances actif
- [ ] Pas de production (lait, œufs, laine) pendant les vacances
- [ ] Table `vacation_modes` en BDD
- [ ] UI : bouton dans Profil → modale activation/désactivation
**Validation** : Activer vacances → animaux survivent 7 jours sans connexion

---

# PHASE 2 — CULTURES (6 semaines, 16 features)

## F2.1 — API parcelles (acheter, louer, vendre) `[api]`
**Dépendances** : F0.5, F0.2b
**Actions** : `CUL-001`, `CUL-002`, `COM-014`
**Livrables** :
- [ ] Router `parcels.buy` : acheter parcelle (prix selon surface, région, qualité)
- [ ] Router `parcels.rent` : louer parcelle (loyer mensuel)
- [ ] Router `parcels.sell` : vendre parcelle (taxe plus-value D16 : 90% <1an → 50% >5ans)
- [ ] Router `parcels.list` : liste parcelles du joueur
- [ ] Router `parcels.available` : parcelles en vente/location
**Validation** : Acheter une parcelle → apparaît dans la liste, solde débité

## F2.2 — API conversion parcelles `[api]`
**Dépendances** : F2.1
**Actions** : `CUL-030`, `CUL-031`, `CUL-017` (jachère)
**Livrables** :
- [ ] Router `parcels.convertOrganic` : convertir en bio
- [ ] Router `parcels.convertMeadow` : convertir en pré
- [ ] Router `parcels.fallow` : mettre en jachère
**Validation** : Convertir une parcelle → type change

## F2.3 — API travail du sol `[api]`
**Dépendances** : F2.1
**Actions** : `CUL-003`, `CUL-004`, `CUL-005`, `CUL-026`, `CUL-038`, `CUL-039`, `CUL-041`
**Livrables** :
- [ ] Router `parcels.stubble` : déchaumer (tracteur + déchaumeur)
- [ ] Router `parcels.plough` : labourer (tracteur + charrue, combiné -25% HT)
- [ ] Router `parcels.prepare` : préparer terre (tracteur + herse rotative)
- [ ] Router `parcels.crushStones` : broyer pierres (-5% malus, effet 3 saisons)
- [ ] Router `parcels.hoe` : binage (bineuse)
- [ ] Router `parcels.harrowMeadow` : herse de prairie
- [ ] Router `parcels.roll` : rouler parcelle
- [ ] Calcul HT + HVC selon surface et puissance matériel
- [ ] Vérification maniabilité matériel vs taille parcelle
**Validation** : Déchaumer → état parcelle change, HT et HVC déduits

## F2.4 — API semis (3 techniques) `[api]`
**Dépendances** : F2.3
**Actions** : `CUL-006`, `CUL-007`, `CUL-008`, `CUL-023`, `CUL-024`, `CUL-042`, `CUL-043`, `CUL-044`, `CUL-045`, `CUL-047`
**Livrables** :
- [ ] Router `parcels.sowTraditional` : semis traditionnel (déchaumé → labouré → hersé → semé)
- [ ] Router `parcels.sowTCS` : semis TCS (déchaumé → cultivé → hersé → semé, combiné possible)
- [ ] Router `parcels.sowDirect` : semis direct (semoir direct, 1 passage)
- [ ] Router `parcels.sowGreenManure` : semer engrais vert CIPAN
- [ ] Router `parcels.destroyGreenManure` : broyer engrais vert
- [ ] Router `parcels.sowTobaccoGreenhouse` : semer tabac sous serre
- [ ] Router `parcels.transplantTobacco` : repiquer tabac en pleine terre
- [ ] Router `parcels.sowAlfalfa` : cultiver luzerne (3 coupes/an, 4 ans)
- [ ] Router `parcels.sowHemp` : semer chanvre industriel
- [ ] Router `parcels.sowImmature` : semer céréale immature
- [ ] Vérification saison + rotation + stock semences
**Validation** : Semer du blé en octobre → culture démarre, pousse% = 0

## F2.5 — API récolte `[api]`
**Dépendances** : F2.4
**Actions** : `CUL-017`, `CUL-018`, `CUL-019`, `CUL-025`, `CUL-034`, `CUL-035`, `CUL-046`
**Livrables** :
- [ ] Router `parcels.harvest` : moissonner (moissonneuse-batteuse → silo, choix réglage coupe haute/standard/basse)
- [ ] Router `parcels.ensile` : ensiler (ensileuse → silo taupe)
- [ ] Router `parcels.uproot` : arracher betterave/PDT (arracheuse spécifique)
- [ ] Router `parcels.crushStraw` : broyer paille
- [ ] Router `parcels.ensileGrass` : ensilage d'herbe (ensileuse sur pré)
- [ ] Router `parcels.looseStraw` : paille en vrac (autochargeuse)
- [ ] Router `parcels.harvestFlax` : récolter lin (3 étapes)
- [ ] Calcul rendement : rendement régional × (1 + bonus sol + bonus traitements + bonus irrigation + bonus technique + bonus pierres)
**Validation** : Moissonner du blé → récolte en silo, rendement calculé

## F2.6 — API sol + analyse `[api]`
**Dépendances** : F2.1
**Actions** : `CUL-022`
**Livrables** :
- [ ] Router `parcels.analyzeSoil` : analyse de sol (150€, 1x/5 ans Cultivia)
- [ ] Retourne les 6 éléments (N, P, K, Ca, Mg, S) + qualité terre (⭐⭐⭐) + pierres
- [ ] Stockage résultat dans `parcels.soil_nutrients` (JSONB)
**Validation** : Analyser un sol → résultats visibles, cooldown 5 ans

## F2.7 — API épandages `[api]`
**Dépendances** : F2.6
**Actions** : `CUL-009`, `CUL-010`, `CUL-011`, `CUL-027`, `CUL-028`, `CUL-029`, `CUL-032`, `CUL-036`, `CUL-037`
**Livrables** :
- [ ] Router `parcels.spreadFertilizer` : épandre engrais (N/P/K/Ca/Mg/S, tracteur + épandeur)
- [ ] Router `parcels.spreadManure` : épandre fumier (25T/ha, tracteur + épandeur à fumier)
- [ ] Router `parcels.spreadSlurry` : épandre lisier (15m³/ha, tracteur + tonne à lisier)
- [ ] Router `parcels.spreadCompost` : épandre compost (15T/ha)
- [ ] Router `parcels.spreadSugarFoam` : épandre écume de sucrerie
- [ ] Router `parcels.spreadDigestate` : épandre digestat
- [ ] Router `parcels.compostOnFarm` : compostage à la ferme (fumier → compost)
- [ ] Router `parcels.stackBales` : mise en tas balles bord de parcelle
- [ ] Router `parcels.compostInField` : compostage en parcelle
**Validation** : Épandre du fumier → éléments nutritifs augmentent

## F2.8 — API irrigation `[api]`
**Dépendances** : F2.1
**Actions** : `CUL-020`, `CUL-021`, `CUL-033`
**Livrables** :
- [ ] Router `parcels.irrigateReel` : irriguer (enrouleur + source)
- [ ] Router `parcels.irrigatePivot` : irriguer (pivot central + rampes, programmable)
- [ ] Router `parcels.buildReservoir` : construire retenue collinaire
- [ ] Vérification source d'eau (forage, rivière, retenue)
**Validation** : Irriguer → jauge eau augmente

## F2.9 — API chaîne foin/paille `[api]`
**Dépendances** : F2.1
**Actions** : `CUL-013`, `CUL-014`, `CUL-015`, `CUL-016`, `CUL-040`
**Livrables** :
- [ ] Router `parcels.mow` : faucher (faucheuse, combiné frontale+arrière -50% HT)
- [ ] Router `parcels.ted` : faner (faneuse)
- [ ] Router `parcels.windrow` : andainer (andaineur)
- [ ] Router `parcels.bale` : presser (presse carrée/ronde + enrubanneuse optionnelle)
- [ ] Router `parcels.collectBales` : ramasser balles
- [ ] Chaîne complète : faucher → faner → andainer → presser → ramasser
**Validation** : Faucher de l'herbe → faner → andainer → presser → balles en hangar

## F2.10 — API traitement cultures `[api]`
**Dépendances** : F2.4
**Actions** : `CUL-012`
**Livrables** :
- [ ] Router `parcels.treat` : traiter (herbicide/fongicide/insecticide, tracteur + pulvérisateur)
- [ ] Combiné cuve frontale + pulvérisateur = -25% HT
- [ ] Vérification stock produit traitement
- [ ] Non compatible bio
**Validation** : Traiter une parcelle → protection appliquée

## F2.11 — Worker météo dynamique `[worker]`
**Dépendances** : F0.3
**Livrables** :
- [ ] Cron toutes les 6h via BullMQ
- [ ] Fetch Open-Meteo pour chaque département (101)
- [ ] Mapping vers `weather_level` (1-5)
- [ ] UPSERT `weather_cache`
- [ ] Publish Redis event `weather:updated`
**Validation** : Après exécution, `SELECT * FROM weather_cache` contient 101 lignes à jour

## F2.12 — Worker DAILY_UPDATE v2 — Cultures `[worker]`
**Dépendances** : F2.5, F2.11
**Livrables** :
- [ ] `cropGrowth()` : % pousse selon météo + sol + traitements + irrigation
- [ ] `weatherEffects()` : appliquer météo sur jauges eau/soleil des parcelles
- [ ] `extremeWeather()` : événements extrêmes (canicule, gel, inondation, grêle — D11)
- [ ] `equipmentWear()` : usure matériel quotidienne
- [ ] `organicCheck()` : vérification certification bio
- [ ] `labelCheck()` : vérification labels (plein-air %)
**Validation** : Après minuit, les cultures poussent, la météo affecte les jauges

## F2.13 — UI page Parcelles `[ui]`
**Dépendances** : F2.1 à F2.10, F0.7
**Livrables** :
- [ ] Page `/parcels` avec DataTable groupée par type (Champ, Pré, Verger, Maraîchage)
- [ ] Colonnes : Nom, Surface, Culture, Pousse%, Sol, Eau, Soleil, Actions
- [ ] Jauges eau/soleil visuelles
- [ ] Diode état (🟢/🔴)
- [ ] Modale achat/location parcelle
- [ ] Modale semis (choix culture, technique, matériel)
- [ ] Modale travaux (déchaumer, labourer, etc.)
**Validation** : Voir ses parcelles, semer, voir la pousse progresser

## F2.14 — UI widget météo `[ui]`
**Dépendances** : F2.11
**Actions** : `SOC-020`
**Livrables** :
- [ ] Composant `<WeatherWidget>` dans l'en-tête
- [ ] Icône + température du département du joueur
- [ ] Clic → prévisions 3 jours
- [ ] Alertes événements extrêmes
**Validation** : Météo visible dans l'en-tête, prévisions accessibles

## F2.15 — UI vente récoltes `[ui]`
**Dépendances** : F2.5
**Actions** : `COM-009`, `COM-010`
**Livrables** :
- [ ] Modale vente récolte (coopérative ou annonce)
- [ ] Choix quantité, prix (si annonce)
- [ ] Confirmation + notification
**Validation** : Vendre du blé à la coop → solde crédité, silo diminue

## F2.16 — UI composant calendrier cultures `[ui]`
**Dépendances** : F2.4
**Livrables** :
- [ ] Composant `<CropCalendar>` : calendrier semis/récolte par culture
- [ ] Affiche les 25 cultures avec périodes de semis et récolte
- [ ] Filtre par saison actuelle
**Validation** : Calendrier visible, cultures filtrées par saison

---

# PHASE 3 — MATÉRIEL + COMMERCE (6 semaines, 14 features)

## F3.1 — API acheter matériel `[api]`
**Dépendances** : F0.5, F1.2
**Actions** : `MAT-001`, `MAT-002`, `MAT-007`, `MAT-008`, `MAT-014`, `MAT-019`
**Livrables** :
- [ ] Router `equipment.buyNew` : acheter neuf (catalogue `equipment_models`)
- [ ] Router `equipment.buyUsed` : acheter occasion (annonces joueurs)
- [ ] Router `equipment.buyShared` : acheter en commun (amis même région)
- [ ] Router `equipment.buyCollection` : acheter matériel de collection
- [ ] Router `equipment.buyOutRegion` : acheter hors région (surcoût transport)
- [ ] Router `equipment.buyAuction` : acheter aux enchères (système d'enchères temps réel)
**Validation** : Acheter un tracteur neuf → apparaît dans le hangar, solde débité

## F3.2 — API vendre + entretenir matériel `[api]`
**Dépendances** : F3.1
**Actions** : `MAT-003`, `MAT-004`, `MAT-009`, `MAT-010`, `MAT-011`, `MAT-012`, `MAT-013`, `MAT-015`
**Livrables** :
- [ ] Router `equipment.sell` : vendre (annonce ou coop)
- [ ] Router `equipment.sellToDealer` : vendre à un concessionnaire joueur
- [ ] Router `equipment.maintain` : entretenir (1 HT/matériel/mois)
- [ ] Router `equipment.repair` : réparer panne (immobilisation 0-2 jours)
- [ ] Router `equipment.repairAtDealer` : réparer chez concessionnaire joueur
- [ ] Router `equipment.insure` : souscrire assurance annuelle
- [ ] Router `equipment.replacePart` : changer pièce détachée
- [ ] Router `equipment.moveGroup` : déplacer matériel groupé
**Validation** : Entretenir un tracteur → usure diminue, vendre → solde crédité

## F3.3 — API carburant + GPS + relevage `[api]`
**Dépendances** : F3.1
**Actions** : `MAT-005`, `MAT-006`, `MAT-016`, `MAT-017`, `MAT-018`
**Livrables** :
- [ ] Router `equipment.refuel` : faire le plein HVC (cuve HVC)
- [ ] Router `equipment.installGps` : installer GPS (balise + récepteur)
- [ ] Router `equipment.installFrontLinkage` : installer relevage avant
- [ ] Router `coop.buyFuel` : acheter HVC à la coopérative
- [ ] Router `equipment.negotiate` : négocier prix matériel
**Validation** : Faire le plein → HVC augmente, installer GPS → bonus HT

## F3.4 — UI page Matériel `[ui]`
**Dépendances** : F3.1, F3.2, F3.3, F0.7
**Livrables** :
- [ ] Page `/equipment` avec DataTable groupée par famille (Motorisé, Travail du sol, Transport…)
- [ ] Colonnes : Nom, Marque, Usure%, HVC, GPS, Emplacement, Actions
- [ ] Onglets : Neuf, Occasion, Enchères, Privé, Hors région, Collection
- [ ] Modale achat (formulaire multi-étapes)
- [ ] Modale entretien/réparation
**Validation** : Voir son matériel, acheter, entretenir, vendre

## F3.5 — API coopérative Cultivia `[api]`
**Dépendances** : F0.5
**Actions** : `COM-001`, `COM-002`, `COM-005`
**Livrables** :
- [ ] Router `coop.buy` : acheter à la coopérative (prix fixes, toujours dispo)
- [ ] Router `coop.sell` : vendre à la coopérative
- [ ] Router `coop.bringVehicle` : amener plateau/fourgon à la coop
- [ ] Catalogue complet : semences, engrais, traitements, nourriture, accessoires
**Validation** : Acheter des semences → stock augmente, solde débité

## F3.6 — UI page Coopérative `[ui]`
**Dépendances** : F3.5, F0.7
**Livrables** :
- [ ] Page `/coop` avec DataTable par catégorie (Céréales, Fourrages, Engrais, Divers)
- [ ] Colonnes : Produit, Quantité, Prix, Actions
- [ ] Modale achat/vente
**Validation** : Acheter/vendre à la coop depuis l'interface

## F3.7 — API marché animaux (régional/national) `[api]`
**Dépendances** : F1.11
**Actions** : `ELV-018`
**Livrables** :
- [ ] Router `market.listAnimals` : annonces animaux en vente
- [ ] Router `market.buyAnimal` : acheter animal d'un autre joueur
- [ ] Filtres : espèce, race, région, prix, génétique
- [ ] Jours de marché : régional J1,2,4,5 / national J3,6,7
**Validation** : Voir les animaux en vente, acheter → transfert propriétaire

## F3.8 — UI page Marché `[ui]`
**Dépendances** : F3.7, F0.7
**Livrables** :
- [ ] Page `/market` avec onglets : Animaux, Matériel, Récoltes, Annonces
- [ ] DataTable marché animaux groupée par espèce
- [ ] DataTable matériel en vente groupée par famille
- [ ] Fiche détaillée animal (radar génétique)
**Validation** : Naviguer le marché, filtrer, acheter

## F3.9 — API annonces + appels d'offres `[api]`
**Dépendances** : F3.5
**Actions** : `COM-003`, `COM-004`, `COM-011`, `COM-012`, `COM-013`
**Livrables** :
- [ ] Router `market.createListing` : passer annonce (vente marchandise)
- [ ] Router `market.respondTender` : répondre appel d'offres
- [ ] Router `market.sellMilkToDairy` : vendre lait à laiterie joueur
- [ ] Router `market.signDairyContract` : signer contrat laiterie
- [ ] Router `market.sellEquipmentPrivate` : vendre matériel en privé (ami spécial)
**Validation** : Passer une annonce → visible par les autres joueurs

## F3.10 — API prix dynamiques `[api]`
**Dépendances** : F3.5, F3.7
**Décision** : D13
**Livrables** :
- [ ] Service `PricingService` : calcul prix selon offre/demande
- [ ] Saisonnalité des prix (blé plus cher en hiver)
- [ ] Pénurie/surplus régional (peu de vendeurs → prix monte)
- [ ] Indice des prix par produit (historique 30 jours)
- [ ] Worker : recalcul prix toutes les heures
**Validation** : Prix du blé fluctue selon les ventes des joueurs

## F3.11 — Worker DAILY_UPDATE v3 — Matériel + Marché `[worker]`
**Dépendances** : F3.2, F3.10
**Livrables** :
- [ ] `equipmentWear()` : usure quotidienne (plus lente si abrité)
- [ ] `equipmentBreakdown()` : pannes aléatoires selon usure
- [ ] `marketExpiry()` : expiration annonces périmées
- [ ] `priceFluctuation()` : mise à jour prix dynamiques
- [ ] `insuranceExpiry()` : expiration assurances
**Validation** : Matériel s'use, pannes arrivent, annonces expirent

## F3.12 — WebSocket — Temps réel marché `[api]`
**Dépendances** : F3.10
**Livrables** :
- [ ] Socket.io serveur configuré
- [ ] Event `market:price_change` : fluctuation prix
- [ ] Event `market:listing_sold` : annonce vendue
- [ ] Event `notification:new` : nouvelle notification
- [ ] Client Socket.io dans le frontend
**Validation** : Prix mis à jour en temps réel sans refresh

## F3.13 — UI enchères matériel `[ui]`
**Dépendances** : F3.1, F3.12
**Livrables** :
- [ ] Page `/equipment/auctions` avec DataTable enchères en cours
- [ ] Historique enchères par matériel
- [ ] Formulaire enchérir (montant)
- [ ] Notifications temps réel (surenchéri, gagné)
**Validation** : Enchérir → notification si surenchéri

## F3.14 — UI indice des prix `[ui]`
**Dépendances** : F3.10
**Livrables** :
- [ ] Composant `<PriceIndex>` : graphique évolution prix 30 jours
- [ ] Accessible depuis la page Marché
- [ ] Filtre par produit
**Validation** : Voir l'évolution du prix du blé sur 30 jours

---

# PHASE 4 — REPRODUCTION + GÉNÉTIQUE (4 semaines, 8 features)

## F4.1 — API insémination Cultivia direct `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-023`
**Livrables** :
- [ ] Router `animals.inseminateCultivia` : insémination directe (pas de CIA)
- [ ] Vérification : âge repro, non gestante, non malade, délai entre mises bas, saison
- [ ] Génétique mâle = moyenne serveur
- [ ] Prix dose selon espèce (taureau ~60€, verrat ~15€, etc.)
**Validation** : Inséminer une vache → gestante, date mise bas calculée

## F4.2 — API insémination naturelle `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-024`
**Livrables** :
- [ ] Router `animals.inseminateNatural` : accouplement (mâle même race dans l'élevage)
- [ ] Taux réussite variable selon espèce
- [ ] Races IVRAD : uniquement naturelle, taux 10-15%
**Validation** : Accoupler → gestation si réussite

## F4.3 — API insémination CIA joueur `[api]`
**Dépendances** : F1.10
**Actions** : `ELV-022`
**Livrables** :
- [ ] Router `animals.inseminateCIA` : commander insémination via CIA joueur
- [ ] Consultation GenBook (catalogue génétique)
- [ ] Choix du mâle (indices visibles)
- [ ] Vérification stock doses CIA
**Validation** : Commander une insémination CIA → dose consommée, gestation

## F4.4 — Worker DAILY_UPDATE v4 — Gestation + Naissances `[worker]`
**Dépendances** : F4.1, F4.2, F4.3
**Livrables** :
- [ ] `pregnancyProgress()` : avancement gestation quotidien
- [ ] `births()` : naissances (portée selon espèce, indices génétiques hérités)
- [ ] Calcul génétique : moyenne parents ± variation aléatoire
- [ ] Saisonnalité reproduction (oies Jan-Fév, pintades Mars, etc.)
- [ ] Notification naissance
**Validation** : Après gestation complète → naissance, petit avec indices hérités

## F4.5 — API génétique + radar `[api]` `[ui]`
**Dépendances** : F4.4
**Livrables** :
- [ ] 14 indices génétiques par animal (JSONB)
- [ ] Composant `<GeneticRadar>` : radar chart des indices
- [ ] Fiche détaillée animal avec radar
- [ ] Comparaison génétique entre animaux
**Validation** : Voir le radar génétique d'un animal, comparer 2 animaux

## F4.6 — API IVRAD (races rares) `[api]`
**Dépendances** : F4.4
**Actions** : `ELV-049`, `ELV-050`, `CIA-006`, `CIA-007`
**Livrables** :
- [ ] Router `cia.setIvradObjective` : définir objectif génétique
- [ ] Router `cia.requestIvradAnimal` : demander animal IVRAD
- [ ] Router `cia.returnIvradAnimal` : rendre animal IVRAD
- [ ] Router `animals.presentSalon` : présenter au Salon Génétique
- [ ] Router `animals.buySalonRare` : acheter au Salon des Races Rares
- [ ] Progression objectifs → déblocage slots
**Validation** : Objectif génétique → progression → slot débloqué

## F4.7 — API labels `[api]`
**Dépendances** : F1.12
**Actions** : `ELV-025`, `ELV-026`, `ELV-027`
**Livrables** :
- [ ] Calcul label plein-air : >3 mois, >50% vie dehors → +5% prix
- [ ] Calcul label bio : conditions multiples → +20% prix
- [ ] Veau sous la mère : allaitement 5-6 mois → +1.50€/kg
- [ ] Agneau sous la mère : allaitement 2-3 mois → +0.30€/kg
**Validation** : Animal au pré >3 mois → label plein-air attribué

## F4.8 — UI page Reproduction `[ui]`
**Dépendances** : F4.1 à F4.7
**Livrables** :
- [ ] Section reproduction dans page Animaux
- [ ] Modale insémination (3 modes : Cultivia, CIA, naturelle)
- [ ] Liste femelles gestantes avec date mise bas prévue
- [ ] Section IVRAD (objectifs, progression, slots)
- [ ] Section labels (éligibilité, statut)
**Validation** : Inséminer depuis l'UI, voir les gestantes, suivre IVRAD

---

# PHASE 5 — SOCIAL + FINANCE (4 semaines, 14 features)

## F5.1 — API amis `[api]`
**Dépendances** : F0.5
**Actions** : `SOC-001`
**Livrables** :
- [ ] Router `social.addFriend` : demande d'ami
- [ ] Router `social.acceptFriend` : accepter
- [ ] Router `social.removeFriend` : retirer
- [ ] Router `social.promoteFriend` : promouvoir (ami → privilégié → spécial)
- [ ] 3 niveaux avec avantages différents
**Validation** : Ajouter un ami → relation créée, promouvoir → niveau change

## F5.2 — API messagerie interne `[api]`
**Dépendances** : F5.1
**Actions** : `SOC-002`
**Livrables** :
- [ ] Router `social.sendMessage` : envoyer message
- [ ] Router `social.listMessages` : boîte de réception
- [ ] Router `social.readMessage` : marquer lu
- [ ] Router `social.deleteMessage` : supprimer
- [ ] Suppression auto messages >30 jours
**Validation** : Envoyer un message → reçu par le destinataire

## F5.3 — API MP-Live (chat temps réel) `[api]`
**Dépendances** : F3.12, F5.1
**Actions** : `SOC-003`
**Livrables** :
- [ ] Event Socket.io `chat:send` / `chat:message`
- [ ] Historique en Redis (dernières 100 messages par conversation)
- [ ] Widget chat flottant côté frontend
**Validation** : Envoyer un message → reçu instantanément par l'autre joueur

## F5.4 — API forums `[api]`
**Dépendances** : F0.5
**Actions** : `SOC-004`, `SOC-024`
**Livrables** :
- [ ] Router `social.createPost` : poster sur forum
- [ ] Router `social.listPosts` : liste posts (régionaux + thématiques)
- [ ] Router `social.acceptCharter` : accepter charte forum
- [ ] Modération basique (signalement)
**Validation** : Poster un message sur le forum régional → visible par les joueurs de la région

## F5.5 — API social divers `[api]`
**Dépendances** : F5.1
**Actions** : `SOC-005` à `SOC-011`, `SOC-014` à `SOC-022`
**Livrables** :
- [ ] Router `social.sponsor` : parrainer un ami (`SOC-005`)
- [ ] Router `social.activateGuard` : activer garde de ferme (`SOC-006`)
- [ ] Router `social.guardFarm` : garder ferme d'un joueur (`SOC-007`)
- [ ] Router `social.visitFarmer` : visiter éleveur (`SOC-008`)
- [ ] Router `social.openVisits` : ouvrir ferme aux visites (`SOC-009`)
- [ ] Router `social.relocate` : déménager (`SOC-010`)
- [ ] Router `social.openAnnex` : ouvrir ferme annexe (`SOC-011`)
- [ ] Router `social.preferences` : gérer préférences (`SOC-014`)
- [ ] Router `social.notificationFilters` : filtres notifications (`SOC-015`)
- [ ] Router `social.favorites` : gérer favoris (`SOC-016`)
- [ ] Router `social.notepad` : bloc-notes (`SOC-017`)
- [ ] Router `social.unsubscribe` : désinscription (`SOC-018`, `ADM-005`)
- [ ] Router `social.events` : événements in-game (`SOC-019`)
- [ ] Router `social.playerProfile` : consulter fiche joueur (`SOC-021`)
- [ ] Router `social.availability` : déclarer disponibilités (`SOC-022`)
**Validation** : Parrainer, visiter, garder une ferme fonctionnels

## F5.6 — API réputation joueur `[api]`
**Dépendances** : F5.1
**Décision** : D12
**Livrables** :
- [ ] Score réputation calculé : livraisons à temps, qualité, délais, annulations
- [ ] Visible sur la fiche joueur
- [ ] Impact sur les transactions (joueurs méfiants si mauvaise réputation)
**Validation** : Livraison réussie → réputation augmente, visible sur le profil

## F5.7 — API fil d'actualité régional `[api]`
**Dépendances** : F5.1
**Décision** : D14
**Livrables** :
- [ ] Feed : ventes, concours, naissances, événements des joueurs de la région
- [ ] Router `social.getFeed` : récupérer le fil
- [ ] Insertion automatique lors des actions (vente, naissance, concours)
**Validation** : Vendre un animal → apparaît dans le fil régional

## F5.8 — UI page Social `[ui]`
**Dépendances** : F5.1 à F5.7, F0.7
**Livrables** :
- [ ] Page `/social` avec onglets : Amis, Messages, MP-Live, Forum, Fil d'actualité
- [ ] DataTable amis (pseudo, localisation, niveau, actions)
- [ ] DataTable messagerie (expéditeur, objet, date, lu)
- [ ] Widget MP-Live flottant
- [ ] Fil d'actualité régional
**Validation** : Naviguer le social, envoyer un message, voir le fil

## F5.9 — API finance (prêts, épargne) `[api]`
**Dépendances** : F0.5
**Actions** : `FIN-001`, `FIN-002`, `FIN-004`, `FIN-008`, `FIN-009`
**Livrables** :
- [ ] Router `finance.requestLoan` : demander prêt (150k max, 1x/7j)
- [ ] Router `finance.repayEarly` : remboursement anticipé (pénalité 3%)
- [ ] Router `finance.openSavings` : ouvrir épargne (1/3/5 ans, 5/6/7%)
- [ ] Router `finance.withdrawSavings` : retirer (perte intérêts si anticipé)
- [ ] Router `finance.getHistory` : historique filtrable par catégorie/période
**Validation** : Demander un prêt → solde crédité, mensualités programmées

## F5.10 — API finance (investissements) `[api]`
**Dépendances** : F5.9
**Actions** : `FIN-010`, `FIN-011`
**Livrables** :
- [ ] Router `finance.buyShares` : acheter parts sociales CAR (1€/part)
- [ ] Router `finance.borrowCAR` : emprunter via CAR
- [ ] Dividendes saisonniers sur parts sociales
**Validation** : Acheter des parts → dividendes versés chaque saison

## F5.11 — UI page Finance `[ui]`
**Dépendances** : F5.9, F5.10, F0.7
**Livrables** :
- [ ] Page `/finance` : solde, prêts, épargne, historique, HT, employés
- [ ] DataTable historique compte groupée par mois
- [ ] Modale prêt (montant, durée, taux)
- [ ] Modale épargne (ouvrir/retirer)
- [ ] Section HT (acheter/vendre, détail employés)
**Validation** : Voir son historique, demander un prêt, ouvrir une épargne

## F5.12 — API CECA `[api]`
**Dépendances** : F0.5
**Actions** : `CECA-001`, `CECA-002`, `CECA-003`, `CECA-004`
**Livrables** :
- [ ] Router `cesa.candidate` : se porter candidat (90j ancienneté)
- [ ] Router `cesa.vote` : voter pour un candidat
- [ ] Router `cesa.propose` : proposer un vote (représentant élu)
- [ ] Router `cesa.results` : consulter résultats
- [ ] 3 représentants/région, élus chaque saison
**Validation** : Se porter candidat → élu si assez de votes → peut proposer des votes

## F5.13 — API CFCA `[api]`
**Dépendances** : F0.5
**Actions** : `CFCA-001`, `CFCA-002`, `CFCA-003`
**Livrables** :
- [ ] Router `cfsa.enroll` : s'inscrire formation (<14j inscription)
- [ ] Router `cfsa.acceptTrainee` : accepter stagiaire (>168j inscription)
- [ ] Router `cfsa.complete` : terminer formation (42 jours → bonus 25 000€)
**Validation** : Stagiaire s'inscrit → maître accepte → 42 jours → bonus versé

## F5.14 — API compétition `[api]`
**Dépendances** : F0.5
**Actions** : `SOC-012`, `SOC-013`, `SOC-023`
**Décision** : D15
**Livrables** :
- [ ] Router `challenges.list` : challenges actifs
- [ ] Router `challenges.join` : participer
- [ ] Router `challenges.leaderboard` : classement
- [ ] Router `lottery.buyTicket` : acheter billet loterie
- [ ] Router `social.buySalonTicket` : acheter billet salon
- [ ] Badges : conditions de déblocage (JSONB)
- [ ] Objectifs personnels : jalons individuels avec récompenses ("100 vaches", "500T blé")
**Validation** : Participer à un challenge → classement mis à jour

## F5.15 — Worker DAILY_UPDATE v5 — Finance `[worker]`
**Dépendances** : F5.9, F5.12
**Livrables** :
- [ ] `loanPayments()` : prélèvement mensuel prêts
- [ ] `savingsInterest()` : versement intérêts anniversaire
- [ ] `taxCollection()` : cotisations/taxe foncière (si CECA voté)
- [ ] `dividends()` : dividendes parts sociales CAR (saisonnier)
**Validation** : Mensualité prêt prélevée, intérêts épargne versés

---

# PHASE 6 — TRANSPORT (3 semaines, 6 features)

## F6.1 — API licences + chauffeurs `[api]`
**Dépendances** : F0.5
**Actions** : `TRA-005`, `TRA-007`, `TRA-004`
**Livrables** :
- [ ] Router `transport.subscribeLicense` : souscrire licence (compte propre / compte d'autrui)
- [ ] Router `transport.subscribeMD` : licence matières dangereuses
- [ ] Router `transport.hireDriver` : embaucher chauffeur (270€/jour, 32 HT)
**Validation** : Souscrire licence → transport possible

## F6.2 — API demandes de transport `[api]`
**Dépendances** : F6.1
**Actions** : `TRA-001`, `TRA-006`
**Livrables** :
- [ ] Router `transport.createDemand` : créer demande de transport
- [ ] Router `transport.acceptDemand` : accepter une demande
- [ ] Router `transport.listDemands` : liste demandes disponibles
- [ ] Calcul distance + coût (0.01 HT/km)
**Validation** : Créer une demande → visible par les transporteurs

## F6.3 — API charger + livrer `[api]`
**Dépendances** : F6.2
**Actions** : `TRA-002`, `TRA-003`
**Livrables** :
- [ ] Router `transport.load` : charger camion (vérification capacité semi)
- [ ] Router `transport.deliver` : livrer (décharger chez l'acheteur)
- [ ] Transfert marchandise + paiement en transaction
**Validation** : Charger → livrer → marchandise transférée, paiement effectué

## F6.4 — API favoris transport `[api]`
**Dépendances** : F6.2
**Actions** : `TRA-008`
**Livrables** :
- [ ] Router `transport.addFavorite` : ajouter transporteur/client favori
- [ ] Router `transport.listFavorites` : liste favoris
**Validation** : Ajouter un favori → visible dans la liste

## F6.5 — UI page Transport `[ui]`
**Dépendances** : F6.1 à F6.4, F0.7
**Livrables** :
- [ ] Page `/transport` avec DataTable demandes (départ, arrivée, marchandise, km, prix)
- [ ] Onglets : Mes véhicules, Demandes, Favoris
- [ ] Modale créer demande
- [ ] Modale charger/livrer
- [ ] Section licence + chauffeurs
**Validation** : Voir les demandes, en créer une, charger, livrer

## F6.6 — Worker DAILY_UPDATE v6 — Transport `[worker]`
**Dépendances** : F6.3
**Livrables** :
- [ ] `driverSalaries()` : paiement chauffeurs (270€/jour)
- [ ] `transportExpiry()` : expiration demandes non acceptées
**Validation** : Salaires chauffeurs prélevés quotidiennement

---

# PHASE 7 — ACTIVITÉS SECONDAIRES (8 semaines, 12 features)

## F7.1 — API concessionnaire (création + hall) `[api]`
**Dépendances** : F0.5
**Actions** : `CON-001`, `CON-002`, `CON-003`
**Livrables** :
- [ ] Router `dealership.create` : créer concession (90j ancienneté)
- [ ] Router `dealership.buyLicense` : acheter licence constructeur (100 pts à répartir)
- [ ] Router `dealership.hireStaff` : embaucher vendeur/mécanicien
**Validation** : Créer une concession → hall visible

## F7.2 — API concessionnaire (vente + atelier) `[api]`
**Dépendances** : F7.1
**Actions** : `CON-004`, `CON-005`, `CON-006`, `CON-007`, `CON-008`, `CON-009`, `CON-010`
**Livrables** :
- [ ] Router `dealership.sellToClient` : vendre matériel neuf au client
- [ ] Router `dealership.repairClient` : entretien atelier (matériel client)
- [ ] Router `dealership.depositSale` : dépôt-vente matériel
- [ ] Router `dealership.sellParts` : vendre pièces détachées
- [ ] Router `dealership.rentTractor` : louer tracteur (panne client)
- [ ] Router `dealership.subscribeGps` : souscrire GPS client
- [ ] Router `dealership.rentEquipment` : louer matériel
**Validation** : Vendre un tracteur à un client → stock diminue, solde crédité

## F7.3 — UI page Concessionnaire `[ui]`
**Dépendances** : F7.1, F7.2, F0.7
**Livrables** :
- [ ] Page `/dealership` avec onglets : Hall, Atelier, Dépôt-vente, GPS
- [ ] DataTable stock neuf, atelier réparations
- [ ] Section licences + personnel
**Validation** : Gérer sa concession depuis l'interface

## F7.4 — API CIA (création + contrats) `[api]`
**Dépendances** : F0.5
**Actions** : `CIA-001`, `CIA-002`, `CIA-003`
**Livrables** :
- [ ] Router `cia.create` : créer CIA (labo 50m², inséminateur, utilitaire)
- [ ] Router `cia.contractBreed` : contrat race
- [ ] Router `cia.contractAnimal` : contrat animal
**Validation** : Créer un CIA → labo visible

## F7.5 — API CIA (prélèvements + inséminations) `[api]`
**Dépendances** : F7.4
**Actions** : `CIA-004`, `CIA-005`
**Livrables** :
- [ ] Router `cia.collect` : prélèvement semence (300-400 doses taureau, 7-12 jars)
- [ ] Router `cia.inseminate` : insémination client
- [ ] GenBook : annuaire génétique régional
**Validation** : Prélever → doses en stock, inséminer client → dose consommée

## F7.6 — UI page CIA `[ui]`
**Dépendances** : F7.4, F7.5, F0.7
**Livrables** :
- [ ] Page `/cia` avec onglets : Labo, Contrats, GenBook, IVRAD
- [ ] DataTable stock semences, contrats actifs
**Validation** : Gérer son CIA depuis l'interface

## F7.7 — API fromagerie (création + production) `[api]`
**Dépendances** : F0.5
**Actions** : `FRO-001`, `FRO-002`, `FRO-003`, `FRO-006`, `FRO-007`, `FRO-008`
**Livrables** :
- [ ] Router `cheese.create` : créer fromagerie (artisanale ou industrielle)
- [ ] Router `cheese.produce` : transformer lait en fromage (6 types)
- [ ] Router `cheese.age` : affiner (4-84 jours selon type)
- [ ] Router `cheese.makeButter` : crème → beurre
- [ ] Router `cheese.clean` : nettoyer (hygiène %)
- [ ] Router `cheese.maintainEquipment` : entretenir matériel fromagerie
**Validation** : Transformer du lait → fromage en affinage → prêt après X jours

## F7.8 — API fromagerie (vente + personnel) `[api]`
**Dépendances** : F7.7
**Actions** : `FRO-004`, `FRO-005`, `FRO-009`, `FRO-010`, `FRO-011`, `FRO-012`
**Livrables** :
- [ ] Router `cheese.sellMarket` : vendre au marché (artisanale)
- [ ] Router `cheese.sellWholesale` : vendre au grossiste (industrielle)
- [ ] Router `cheese.trainCheesemaker` : former fromager (6 compétences)
- [ ] Router `cheese.hireCheeseMaker` : embaucher fromager
- [ ] Router `cheese.sellCream` : vendre crème
- [ ] Router `cheese.sellButter` : vendre beurre
**Validation** : Vendre du fromage → solde crédité

## F7.9 — UI page Fromagerie `[ui]`
**Dépendances** : F7.7, F7.8, F0.7
**Livrables** :
- [ ] Page `/cheese` avec onglets : Production, Affinage, Vente, Stock
- [ ] DataTable fromages en affinage (type, jour, DLC, indices)
**Validation** : Gérer sa fromagerie depuis l'interface

## F7.10 — API ETA `[api]`
**Dépendances** : F0.5
**Actions** : `ETA-001`, `ETA-002`, `ETA-003`
**Livrables** :
- [ ] Router `eta.create` : créer ETA (licence, tarifs)
- [ ] Router `eta.callEta` : appeler une ETA (joueur client)
- [ ] Router `eta.respondOrder` : répondre à une commande
**Validation** : Appeler une ETA → commande créée, ETA répond

## F7.11 — Worker DAILY_UPDATE v7 — Activités `[worker]`
**Dépendances** : F7.7
**Livrables** :
- [ ] `cheeseAging()` : avancement affinage quotidien
- [ ] `cheeseDLC()` : expiration fromages (DLC dépassée)
- [ ] `dealershipSalaries()` : salaires vendeurs/mécaniciens
- [ ] `ciaSalaries()` : salaires inséminateurs
**Validation** : Fromages avancent en affinage, DLC respectée

## F7.12 — WebSocket — Notifications activités `[api]`
**Dépendances** : F3.12
**Livrables** :
- [ ] Event `cheese:aged` : fromage affiné prêt
- [ ] Event `equipment:breakdown` : panne matériel
- [ ] Event `building:constructed` : construction terminée
- [ ] Event `transport:demand_new` : nouvelle demande transport
**Validation** : Notification reçue quand un fromage est prêt

---

# PHASE 8 — ACTIVITÉS AVANCÉES (6 semaines, 18 features)

## F8.1 — API maraîchage (création + cultures) `[api]`
**Dépendances** : F0.5
**Actions** : `MAR-001`, `MAR-002`, `MAR-003`, `MAR-006`, `MAR-007`, `MAR-008`
**Livrables** :
- [ ] Router `maraichage.create` : créer activité maraîchage
- [ ] Router `maraichage.sow` : semer/planter légume
- [ ] Router `maraichage.harvest` : récolter légume
- [ ] Router `maraichage.buySeeds` : acheter semences
- [ ] Router `maraichage.buyFertilizer` : acheter engrais
- [ ] Router `maraichage.buyTreatment` : acheter traitements
**Validation** : Semer un légume → pousse → récolter

## F8.2 — API maraîchage (serres + vente) `[api]`
**Dépendances** : F8.1
**Actions** : `MAR-004`, `MAR-005`, `MAR-010`, `MAR-011`, `MAR-012`, `MAR-013`, `MAR-014`, `MAR-015`, `MAR-016`, `MAR-022`
**Livrables** :
- [ ] Router `maraichage.pack` : emballer légume
- [ ] Router `maraichage.sellMarket` : vendre au marché
- [ ] Router `maraichage.heatGreenhouse` : chauffer serre
- [ ] Router `maraichage.buildGreenhouse` : construire serre (plastique/verre)
- [ ] Router `maraichage.buildTunnel` : construire tunnel
- [ ] Router `maraichage.buyTerrain` : acheter terrain maraîcher
- [ ] Router `maraichage.treat` : traiter légume
- [ ] Achats : plateau polystyrène, bac, bâche plastique
**Validation** : Construire une serre → semer → récolter → emballer → vendre

## F8.3 — API maraîchage (personnel + spécifiques) `[api]`
**Dépendances** : F8.1
**Actions** : `MAR-009`, `MAR-017`, `MAR-018`, `MAR-019`, `MAR-020`, `MAR-021`
**Livrables** :
- [ ] Router `maraichage.hireWorker` : embaucher ouvrier
- [ ] Router `maraichage.hireCropManager` : embaucher chef culture/équipe
- [ ] Router `maraichage.harvestSpecific` : récolter épinard/haricot
- [ ] Router `maraichage.defanePotato` : défanage chimique PDT
- [ ] Router `maraichage.storePotato` : stocker PDT en ligne
- [ ] Router `maraichage.sellPotatoChannel` : vendre PDT via filière
**Validation** : Embaucher un ouvrier → HT supplémentaires

## F8.4 — UI page Maraîchage `[ui]`
**Dépendances** : F8.1, F8.2, F8.3, F0.7
**Livrables** :
- [ ] Page `/maraichage` avec onglets : Cultures, Serres, Marchés, Stock
- [ ] DataTable cultures (légume, serre/plein champ, pousse%, DLC)
- [ ] Section serres + personnel
**Validation** : Gérer son maraîchage depuis l'interface

## F8.5 — API viticulture (domaine + vigne) `[api]`
**Dépendances** : F0.5
**Actions** : `VIT-001`, `VIT-002`, `VIT-003`, `VIT-010`
**Livrables** :
- [ ] Router `vineyard.create` : acheter domaine viticole (4 parcelles 2500m²)
- [ ] Router `vineyard.plant` : planter vigne (cépage)
- [ ] Router `vineyard.prune` : tailler vigne
- [ ] Router `vineyard.treat` : traiter vigne
**Validation** : Acheter un domaine → planter → tailler

## F8.6 — API viticulture (vinification + vente) `[api]`
**Dépendances** : F8.5
**Actions** : `VIT-004`, `VIT-005`, `VIT-006`, `VIT-007`, `VIT-008`, `VIT-009`, `VIT-011`, `VIT-012`, `VIT-013`, `VIT-014`
**Livrables** :
- [ ] Router `vineyard.harvest` : vendanger
- [ ] Router `vineyard.vinify` : vinifier
- [ ] Router `vineyard.assemble` : assembler vin
- [ ] Router `vineyard.bottle` : mettre en bouteille/fût
- [ ] Router `vineyard.age` : élever vin en fût (vieillissement)
- [ ] Router `vineyard.sell` : vendre vin
- [ ] Router `vineyard.contest` : Concours Viticole
- [ ] Router `vineyard.hireAgent` : embaucher agent viticole/maître de chai
- [ ] Router `vineyard.hireHarvester` : embaucher vendangeur saisonnier
- [ ] Router `vineyard.hireSeller` : embaucher vendeur caviste
**Validation** : Vendanger → vinifier → assembler → embouteiller → vendre

## F8.7 — UI page Viticulture `[ui]`
**Dépendances** : F8.5, F8.6, F0.7
**Livrables** :
- [ ] Page `/vineyard` avec onglets : Vignes, Cave, Vente, Concours
- [ ] DataTable parcelles vigne, vins en cave
**Validation** : Gérer son domaine viticole depuis l'interface

## F8.8 — API arboriculture `[api]`
**Dépendances** : F0.5
**Actions** : `ARB-001`, `ARB-002`, `ARB-003`, `ARB-004`, `ARB-005`, `ARB-006`
**Livrables** :
- [ ] Router `arboriculture.plant` : planter arbres
- [ ] Router `arboriculture.prune` : tailler
- [ ] Router `arboriculture.thin` : éclaircir
- [ ] Router `arboriculture.harvest` : récolter fruits (manuel)
- [ ] Router `arboriculture.installHailNet` : installer filet anti-grêle
- [ ] Router `arboriculture.treat` : traiter arbres fruitiers
**Validation** : Planter → tailler → récolter des fruits

## F8.9 — API forêts (gestion) `[api]`
**Dépendances** : F0.5
**Actions** : `FOR-001`, `FOR-002`, `FOR-003`, `FOR-004`, `FOR-005`, `FOR-006`, `FOR-007`, `FOR-008`, `FOR-009`, `FOR-010`, `FOR-011`
**Livrables** :
- [ ] Router `forest.buy` : acheter forêt (20 stations, 1-10 ha chacune)
- [ ] Router `forest.plant` : planter arbres forestiers
- [ ] Router `forest.prune` : élaguer
- [ ] Router `forest.thin` : éclaircie forestière
- [ ] Router `forest.cut` : coupe finale
- [ ] Router `forest.sell` : vendre bois
- [ ] Router `forest.plantHedge` : planter haie
- [ ] Router `forest.trimHedge` : tailler haie
- [ ] Router `forest.chipHedge` : déchiqueter bois de haie
- [ ] Router `forest.mergeParcel` : regrouper parcelles
- [ ] Router `forest.sellParcel` : vendre parcelle forestière
**Validation** : Acheter une forêt → planter → élaguer → couper → vendre bois

## F8.10 — API forêts (travaux avancés + ETF) `[api]`
**Dépendances** : F8.9
**Actions** : `FOR-012`, `FOR-013`, `FOR-014`, `FOR-015`, `FOR-016`, `FOR-017`, `FOR-018`, `FOR-019`, `FOR-020`, `FOR-021`
**Livrables** :
- [ ] Router `forest.formationPrune` : taille de formation
- [ ] Router `forest.treatForest` : traitement phytosanitaire
- [ ] Router `forest.markCut` : marquage de coupe
- [ ] Router `forest.maintainTrack` : entretien piste forestière
- [ ] Router `forest.maintainRoad` : entretien route forestière
- [ ] Router `forest.maintainDepot` : entretien place de dépôt
- [ ] Router `forest.fertilize` : fertilisation forêt
- [ ] Router `forest.ploughForest` : labour forêt
- [ ] Router `forest.grindStump` : broyage souche
- [ ] Router `forest.createEtf` : créer ETF / prestation chez autre joueur
**Validation** : Travaux forestiers avancés fonctionnels

## F8.11 — UI page Forêts `[ui]`
**Dépendances** : F8.9, F8.10, F0.7
**Livrables** :
- [ ] Page `/forests` avec onglets : Stations, Travaux, Vente bois, ETF
- [ ] DataTable stations forestières (surface, essence, âge, stade)
**Validation** : Gérer ses forêts depuis l'interface

## F8.12 — API CAR (création + silos) `[api]`
**Dépendances** : F0.5
**Actions** : `CAR-001`, `CAR-002`, `CAR-020`, `CAR-011`, `CAR-012`, `CAR-013`
**Livrables** :
- [ ] Router `car.create` : créer CAR (3-7 associés, capital max 1M€)
- [ ] Router `car.join` : rejoindre CAR
- [ ] Router `car.leave` : quitter CAR
- [ ] Router `car.tenders` : appels d'offres CAR
- [ ] Router `car.parcelContract` : contrat parcelle CAR
- [ ] Router `car.tradeBetweenCAR` : acheter/vendre entre CAR
**Validation** : Créer une CAR → associés rejoignent

## F8.13 — API CAR (transformations) `[api]`
**Dépendances** : F8.12
**Actions** : `CAR-003`, `CAR-004`, `CAR-005`, `CAR-006`, `CAR-007`, `CAR-008`, `CAR-018`, `CAR-019`
**Livrables** :
- [ ] Router `car.buildOilMill` : construire huilerie
- [ ] Router `car.transformOil` : colza/tournesol → HVC + tourteau
- [ ] Router `car.buildSugarMill` : construire sucrerie
- [ ] Router `car.transformSugar` : betterave → sucre + pulpe + mélasse + écume
- [ ] Router `car.buildDairy` : construire laiterie
- [ ] Router `car.transformMilk` : lait → yaourt/UHT/pasteurisé/poudre
- [ ] Router `car.buildShop` : construire magasin libre-service
- [ ] Router `car.manageShop` : gérer magasin (5 espaces)
**Validation** : Transformer du colza en HVC via l'huilerie

## F8.14 — API CAR (parcelles Partcel) `[api]`
**Dépendances** : F8.12
**Actions** : `CAR-009`, `CAR-010`, `CAR-014`, `CAR-015`, `CAR-016`, `CAR-017`
**Livrables** :
- [ ] Router `car.rentEquipment` : mettre matériel en location
- [ ] Router `car.scrapEquipment` : mettre matériel à la casse
- [ ] Router `car.buyParcelPartcel` : acheter parcelle via Partcel
- [ ] Router `car.rentParcelPartcel` : louer parcelle via Partcel
- [ ] Router `car.buybackRental` : racheter parcelle en location
- [ ] Router `car.fallowParcel` : remettre parcelle en jachère
**Validation** : Acheter une parcelle via Partcel → parcelle rattachée à la CAR

## F8.15 — UI page CAR `[ui]`
**Dépendances** : F8.12, F8.13, F8.14, F0.7
**Livrables** :
- [ ] Page `/car` avec onglets : Silos, Huilerie, Sucrerie, Laiterie, Magasin, Associés
- [ ] DataTable stock CAR
**Validation** : Gérer sa CAR depuis l'interface

## F8.16 — API méthanisation `[api]`
**Dépendances** : F0.5
**Actions** : `MET-001`, `MET-002`, `MET-003`, `MET-004`, `MET-005`
**Livrables** :
- [ ] Router `methanisation.build` : construire digesteur
- [ ] Router `methanisation.feed` : alimenter digesteur (substrats solide/liquide)
- [ ] Router `methanisation.drain` : vidanger digesteur (digestat = engrais)
- [ ] Router `methanisation.electricity` : produire électricité (2 kWh/m³)
- [ ] Router `methanisation.fuel` : produire HVC (0.7L/m³)
**Validation** : Alimenter → 7 jours → biogaz → électricité + HVC

## F8.17 — API foie gras `[api]`
**Dépendances** : F0.5
**Actions** : `FOI-001`, `FOI-002`, `FOI-003`, `FOI-004`
**Livrables** :
- [ ] Router `foiegras.place` : placer animal en filière foie gras
- [ ] Router `foiegras.gavage` : gaver
- [ ] Router `foiegras.slaughter` : abattre et transformer
- [ ] Router `foiegras.sell` : vendre foie gras
**Validation** : Placer → gaver → abattre → vendre

## F8.18 — Worker DAILY_UPDATE v8 — Activités avancées `[worker]`
**Dépendances** : F8.1, F8.5, F8.9, F8.16
**Livrables** :
- [ ] `gardenGrowth()` : pousse légumes maraîchage
- [ ] `vineGrowth()` : croissance vigne
- [ ] `treeGrowth()` : croissance arbres (fruitiers + forestiers)
- [ ] `methanisationCycle()` : avancement cycle digesteur (7 jours)
- [ ] `foieGrasGavage()` : avancement gavage
- [ ] `gardenDLC()` : expiration légumes
**Validation** : Légumes poussent, vigne grandit, digesteur avance

---

# PHASE 9 — FINITIONS (4 semaines, 6 features)

## F9.1 — Ferme 3D isométrique `[ui]`
**Actions** : `BAT-007`, `BAT-008`, `BAT-009`
**Livrables** :
- [ ] Vue isométrique de la ferme (Canvas/Pixi.js)
- [ ] Drag & drop bâtiments
- [ ] Mode placement / suppression / rotation
- [ ] Éléments décoratifs : arbres, barrières, asphalte, herbe
**Validation** : Placer un bâtiment sur la carte, le tourner, le supprimer

## F9.2 — Animations + Micro-interactions `[ui]`
**Livrables** :
- [ ] Framer Motion sur les transitions de page
- [ ] Animations boutons d'action (feedback visuel)
- [ ] Sons optionnels (toggle dans préférences)
- [ ] Skeleton loading sur toutes les pages
**Validation** : Transitions fluides, feedback visuel sur chaque action

## F9.3 — Performance `[api]` `[ui]`
**Livrables** :
- [x] Pagination serveur sur toutes les listes >50 éléments
- [ ] Cache Redis sur les requêtes fréquentes (météo, prix, classements)
- [ ] Optimistic updates TanStack Query sur les mutations
- [ ] Lazy loading des pages (Next.js dynamic imports)
**Validation** : Temps de réponse <200ms sur les requêtes principales

## F9.4 — Responsive mobile `[ui]`
**Livrables** :
- [ ] Adaptation responsive de toutes les pages (breakpoints Tailwind)
- [ ] Navigation mobile (hamburger menu)
- [ ] DataTable responsive (colonnes masquées sur petit écran)
**Validation** : Toutes les pages utilisables sur tablette/mobile

## F9.5 — Tests E2E `[infra]`
**Livrables** :
- [ ] Playwright configuré
- [ ] Tests flows critiques : inscription, nourrir, semer, acheter/vendre, transport
- [ ] Tests DAILY_UPDATE (vérification résultats après exécution)
- [ ] CI : tests E2E sur PR
**Validation** : Tous les tests passent, CI bloquant

## F9.6 — Documentation utilisateur `[ui]`
**Livrables** :
- [ ] Page `/help` avec guide du jeu
- [ ] Aide contextuelle (icônes ? sur chaque section)
- [ ] FAQ
- [ ] Changelog visible en jeu
**Validation** : Aide accessible depuis chaque page
