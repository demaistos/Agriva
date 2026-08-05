# 04 — Product Roadmap — Cultivia

> **Product Owner Document**
> Dernière mise à jour : 2026-04-05
> Intègre les 28 features validées du brainstorm d'équipe du 2026-04-05

---

## 0. COMPTE-RENDU RÉUNION D'ÉQUIPE — 2026-04-05

> **Participants** : Game Designer (GD), Backend Dev (BD), Frontend Dev (FD), DBA, QA
> **Objet** : Intégration des 28 features validées par le PO dans la roadmap

### 🎮 Game Designer

> « Les features validées renforcent trois axes : la profondeur stratégique (lignées, fatigue sol, savoir-faire), la fluidité (nourrissage auto, file d'actions, entretien auto), et l'économie sociale (contrats, enchères, coopération). Le risque principal est la surcharge de la formule de rendement : fatigue sol + savoir-faire + les 9 facteurs existants. Je propose de plafonner le rendement total à 120% du base régional pour éviter l'inflation. »

> « Les semences 2 niveaux (Standard/Certifiée) simplifient sans perdre de profondeur. La fatigue sol force la diversification — c'est le bon levier. Les taxes progressives aux 100 premiers ha créent un vrai sink monétaire. »

### 🔧 Backend Dev

> « Côté technique, les 6 features infra (WebSocket, Redis cache, pagination cursor, monitoring, lazy loading, optimistic UI) sont des fondations. Le WebSocket doit arriver en Phase 0 car la barre statut (3.2) et l'optimistic UI (6.1) en dépendent. Le cache Redis réduit la charge Postgres de 60-70%. »

> « Point d'attention : la file d'actions (4.8) + optimistic UI (6.1) = rollback en cascade si une action échoue au milieu. Il faut un dry-run obligatoire avant exécution. L'idempotency key doit être par action, pas par queue. »

> « Le nourrissage auto (4.1) modifie l'ordre du daily tick Phase 2 : il faut insérer l'étape auto-feed AVANT la vérification santé. »

### 🎨 Frontend Dev

> « La barre statut (3.2) est unanime — c'est le premier composant à coder. Elle doit être dans le bundle initial (pas lazy loaded). Le mode focus parcelle (3.9) et le dashboard financier (3.5) sont des candidats lazy loading parfaits. »

> « Le sol 3 indicateurs (4.2) est purement frontend : Fertilité (N+P+K), Structure (Ca+Mg), Oligo-éléments (S). Le backend garde les 6 nutriments, on ajoute un toggle expert/simplifié en localStorage. »

> « Les liens contextuels (3.8) doivent être systématiques : chaque mention d'entité dans les notifications, le dashboard, les tableaux = lien cliquable. C'est un pattern global, pas une feature isolée. »

### 🗄️ DBA

> « La feature lignées (1.1) nécessite soit un champ `lineage JSONB` dans animal limité à 3 générations, soit une table `animal_lineage`. Je recommande le JSONB pour la perf — pas de JOIN supplémentaire sur 10k joueurs. »

> « La pagination cursor (6.4) impacte toutes les API de liste. Les specs P0 utilisent déjà offset pagination sur `/pa/history` et `/bank/statement` — migration nécessaire. »

> « Le savoir-faire (2.1) nécessite une nouvelle table `player_skill` avec tracking des actions par type. On peut s'appuyer sur `action_log` existant pour le comptage. »

> « Le marché à terme (2.10) nécessite une table `futures_contract` + `price_history` pour les graphiques. Les prix Coop restent fixes (plancher garanti), le marché à terme est un jeu parallèle entre joueurs. »

### 🧪 QA

> « Je vois 10 conflits avec les specs existantes à résoudre avant le dev. Les plus critiques : la formule de rendement surchargée (C1), le nourrissage auto qui inverse le flux P2 (C3), et la reproduction lignées qui remplace la formule simple (C4). »

> « La file d'actions (4.8) est le plus gros risque QA : rollback partiel, idempotency par action, dry-run. Je recommande des tests d'intégration exhaustifs avec scénarios d'échec au milieu de la queue. »

> « Le plafond marché de 16 HT/jour (4.6) n'existe pas dans les specs actuelles — c'est un héritage SimAgri non documenté. Il faut le documenter explicitement à 24 HT/jour. »

---

## 1. CARTE DES INTERDÉPENDANCES

### Phase 0 — Infrastructure

| Feature | Dépend de | Impacte | Conflit |
|---------|-----------|---------|---------|
| **3.2 Barre statut** | P0-Auth, P0-Temps, 6.2 WebSocket | Toutes les pages UI, 3.9 Focus parcelle | — |
| **6.2 WebSocket** | P0-Auth (JWT), 6.5 Cache Redis (Pub/Sub) | 3.2 Barre statut, 6.1 Optimistic UI, 2.10 Marché à terme, 2.6 Enchères, P0-Notifs | — |
| **6.4 Pagination cursor** | P0-Auth | Toutes les API liste, 2.10 Marché à terme, 3.5 Dashboard | ⚠️ Specs P0 utilisent offset pagination → migration |
| **6.5 Cache Redis** | Redis (docker-compose) | 6.2 WebSocket, P1-Météo, P1-Coop, catalogues, 6.7 Monitoring | — |
| **6.7 Monitoring** | 6.5 Cache Redis | Toutes les routes API, dashboard admin | — |
| **6.9 Lazy loading** | Vue Router | 3.5 Dashboard, 3.9 Focus, 2.10 Marché à terme (candidats lazy) | — |

### Phase 1 — Cultures

| Feature | Dépend de | Impacte | Conflit |
|---------|-----------|---------|---------|
| **1.3 Fatigue sol** | P1-Sol, P1-Cultures (crop_history) | Formule rendement (+fatigue_factor), 4.2 Sol 3 indicateurs | ⚠️ Pas de formule d'impact dans spec actuelle → à définir |
| **1.6 Taxes/charges** | P0-Économie, P0-Temps (tick mensuel), P1-Parcelles | processMonthlyEconomy, 3.5 Dashboard | ⚠️ processMonthlyEconomy = no-op en P0 → activer en P1 |
| **4.2 Sol 3 indicateurs** | P1-Sol (6 réserves) | 1.3 Fatigue sol, 3.9 Focus parcelle | — (purement frontend, toggle expert) |
| **4.3 Entretien auto** | P1-Bâtiments, P0-Temps (tick mensuel) | POST /buildings/:id/maintain → prélèvement auto | ⚠️ Entretien manuel → auto. Si HT insuffisants → sauté + notif |
| **4.4 Marché gratuit** | P1-Coop | PA_COOP_TRAVEL → 0 | — (déjà intégré dans spec) |
| **4.7 Semences 2 niveaux** | P1-Semences | Formule rendement (seed_factor), API semences | ⚠️ Refs GP/G/P résiduelles dans spec P1 → nettoyage |
| **4.9 Construction niv1** | P1-Bâtiments | Délai construction, P2-Bâtiments élevage | ⚠️ MAX_FREE_BUILDINGS=10 → supprimer, tous niv1 instantanés |
| **6.1 Optimistic UI** | 6.2 WebSocket, Pinia store | Toutes les actions, 4.8 File d'actions, 3.2 Barre statut | — |
| **3.8 Liens contextuels** | Vue Router | P0-Notifs, 3.5 Dashboard, 3.2 Barre statut | — |

### Phase 2 — Élevage

| Feature | Dépend de | Impacte | Conflit |
|---------|-----------|---------|---------|
| **1.1 Lignées** | P2-Reproduction, P2-Génétique | Arbre généalogique (JSONB 3 gen), sélection reproducteurs, 2.1 Savoir-Faire | ⚠️ Formule `(père+mère)/2+random(-5,+5)` → modèle 3 générations |
| **1.2 Rations dynamiques** | P2-Alimentation, P1-Inventaire | Score nutritionnel visible, production lait, croissance, 4.1 Nourrissage auto | ⚠️ QUALITY_FACTOR discret → courbe continue possible |
| **4.1 Nourrissage auto** | 1.2 Rations dynamiques, P0-Temps (tick) | Daily tick P2 (nouvelle étape), P2-Santé, P0-HT, P0-Notifs | ⚠️ **Inversion complète** : manuel → auto par défaut |
| **4.8 File d'actions** | 6.1 Optimistic UI, 6.2 WebSocket, P0-HT | Toutes les actions, 3.2 Barre statut, P0-Idempotency | ⚠️ Dry-run obligatoire, rollback cascade, idempotency par action |
| **2.1 Savoir-Faire** | P0-Auth, action_log | P1-Cultures (+rendement), P2-Élevage (+production), P3-Commerce (+prix) | ⚠️ Vérifier que bonus ne stack pas trop (+10% max) |
| **3.5 Dashboard financier** | P0-Économie, 1.6 Taxes, 6.4 Pagination, 3.8 Liens | GET /bank/summary enrichi, 2.10 Marché à terme | — |
| **3.9 Focus parcelle** | P1-Parcelles, 3.2 Barre statut, 4.2 Sol 3 indicateurs | Workflow cultures, 4.8 File d'actions | — |

### Phase 3 — Commerce

| Feature | Dépend de | Impacte | Conflit |
|---------|-----------|---------|---------|
| **2.2 Contrats joueurs** | P0-Économie, P3-Annonces, P0-Temps, P1-Inventaire | Transactions 'contract', 2.1 Savoir-Faire, 3.5 Dashboard | ⚠️ Différent des contrats CAR (collectifs vs bilatéraux) |
| **2.6 Enchères** | P0-Économie, P0-Temps (tick hebdo), 6.2 WebSocket, P1-Matériels | Transactions 'auction', P0-Notifs | ⚠️ Nécessite flag `is_rare` dans vehicle_type |
| **2.7 Coopération récolte** | P1-Matériels, P0-Cantons (voisinage), P0-HT | vehicle.lent_to_player_id, P1-Cultures (récolte empruntée) | ⚠️ Check `farm_id == player.farm_id` → assouplir pour prêts |
| **2.10 Marché à terme** | P0-Économie, P1-Coop (prix ref), 6.2 WebSocket, 6.4 Pagination | 3.5 Dashboard, 2.1 Savoir-Faire | ⚠️ Prix Coop fixes vs prix dynamiques → Coop = plancher, marché = libre |
| **4.6 Pas de limite marchés** | P1-Coop, 4.4 Marché gratuit | 2.10 Marché à terme, 2.6 Enchères | ⚠️ Plafond 16 HT/jour non documenté → documenter à 24 HT/jour |

### Phase 4+

| Feature | Dépend de | Impacte | Conflit |
|---------|-----------|---------|---------|
| **2.5 Mentor** | P0-Auth (seniority >= 365j), 2.1 Savoir-Faire | player.mentor_id, P0-Notifs (conseils) | — |

### Conflits critiques à résoudre

| # | Conflit | Résolution |
|---|---------|------------|
| C1 | Formule rendement surchargée (fatigue + savoir-faire + 9 facteurs) | Plafonner rendement total à 120% du base_yield_region |
| C2 | Pagination offset → cursor dans specs P0 | Migrer toutes les API liste vers cursor dès Phase 0 |
| C3 | Nourrissage auto vs ordre du daily tick P2 | Insérer étape auto-feed entre vieillissement et vérif santé |
| C4 | Reproduction simple → lignées 3 générations | Remplacer formule (père+mère)/2+random par modèle pondéré |
| C5 | Prix Coop fixes vs Marché à terme dynamique | Coop = plancher garanti, Marché à terme = prix libre entre joueurs |
| C6 | Refs GP/G/P résiduelles dans spec P1 | Nettoyer → standard/certified partout |
| C7 | MAX_FREE_BUILDINGS=10 vs niv1 instantané | Supprimer MAX_FREE_BUILDINGS, tous niv1 instantanés |
| C8 | File d'actions + rollback cascade | Dry-run obligatoire, idempotency par action |
| C9 | Check ownership matériel vs prêt coopération | Ajouter `OR vehicle.lent_to_player_id = player_id` |
| C10 | Plafond marché non documenté | Documenter explicitement à 24 HT/jour |

---

## 2. ROADMAP MISE À JOUR

### Phase 0 — Infrastructure (10-12 semaines)

> Objectif : socle technique solide + fondations temps réel et performance.

| # | Feature | Effort | Statut | Source |
|---|---------|--------|--------|--------|
| 0.1 | Architecture serveur (API REST, BDD, cache) | XL | Existante | Roadmap v1 |
| 0.2 | Authentification (inscription, login, JWT) | M | Existante | Roadmap v1 |
| 0.3 | Modèle de données (joueurs, exploitations, régions) | L | Existante | Roadmap v1 |
| 0.4 | Moteur de temps (tick journalier, saisons, mois) | L | Existante | Roadmap v1 |
| 0.5 | Système HT (40 HT/jour, consommation, reset) | M | Existante | Roadmap v1 |
| 0.6 | Économie de base (compte bancaire, transactions) | M | Existante | Roadmap v1 |
| 0.7 | Pipeline CI/CD | L | Existante | Roadmap v1 |
| 0.8 | Shell applicatif, navigation, responsive | L | Existante | Roadmap v1 |
| 0.9 | Back-office admin | M | Existante | Roadmap v1 |
| 0.10 | Notifications in-app | S | Existante | Roadmap v1 |
| 0.11 | Création de ferme | S | Existante | Roadmap v1 |
| 0.12 | Middleware Idempotency Key | S | Existante | Roadmap v1 |
| **0.13** | **🆕 WebSocket temps réel (6.2)** | **L** | **Nouvelle** | Brainstorm |
| **0.14** | **🆕 Cache Redis intelligent (6.5)** | **M** | **Nouvelle** | Brainstorm |
| **0.15** | **🆕 Pagination cursor + compression (6.4)** | **S** | **Nouvelle** | Brainstorm |
| **0.16** | **🆕 Monitoring latence (6.7)** | **M** | **Nouvelle** | Brainstorm |
| **0.17** | **🆕 Lazy loading composants (6.9)** | **S** | **Nouvelle** | Brainstorm |
| **0.18** | **🆕 Barre statut persistante (3.2)** | **S** | **Nouvelle** | Brainstorm |

**Livrable Phase 0** : Un joueur peut s'inscrire, se connecter, voir son tableau de bord avec barre statut (HT + solde + météo + saison). WebSocket actif, cache Redis opérationnel, monitoring en place. Le tick journalier tourne.

---

### Phase 1 — MVP Cultures (12-16 semaines)

> Objectif : boucle culture jouable + simplifications validées.

| # | Feature | Effort | Statut | Source |
|---|---------|--------|--------|--------|
| 1.1 | Parcelles (achat, propriété, surface, zone) | L | Existante | Roadmap v1 |
| 1.2 | Gestion du sol (qualité, 6 éléments nutritifs) | L | Existante | Roadmap v1 |
| 1.3 | Bâtiments (hangar, silo, entrepôt, fosse, niv 1-5) | XL | Existante | Roadmap v1 |
| 1.4 | Catalogue matériels MVP (8 types) | L | Existante | Roadmap v1 |
| 1.5 | Achat/vente matériels (neuf, occasion, argus) | L | Existante | Roadmap v1 |
| 1.6 | Moteur météo (4 zones, 5 niveaux) | M | Existante | Roadmap v1 |
| 1.7 | Moteur de culture (semis → récolte, 8 cultures) | XL | Existante | Roadmap v1 |
| 1.8 | Rendements par région | M | Existante | Roadmap v1 |
| 1.9 | Engrais & traitements phytosanitaires | M | Existante | Roadmap v1 |
| 1.10 | Semences ~~(GP/G/P)~~ | S | Existante | Roadmap v1 |
| 1.11 | Le Marché Central — vente récoltes | L | Existante | Roadmap v1 |
| 1.12 | Le Marché Central — achat intrants | M | Existante | Roadmap v1 |
| 1.13 | Système HVC | M | Existante | Roadmap v1 |
| 1.14 | Prêts bancaires | M | Existante | Roadmap v1 |
| 1.15 | Onboarding / tutoriel guidé | L | Existante | Roadmap v1 |
| 1.16 | Amis + messagerie interne | M | Existante | Roadmap v1 |
| 1.17 | Paille & foin | M | Existante | Roadmap v1 |
| 1.18 | Fumier | S | Existante | Roadmap v1 |
| **1.19** | **🔄 Semences 2 niveaux Standard/Certifiée (4.7)** | **S** | **Modifie 1.10** | Brainstorm |
| **1.20** | **🔄 Construction instantanée niv1 (4.9)** | **S** | **Modifie 1.3** | Brainstorm |
| **1.21** | **🔄 Marché gratuit — consultation 0 HT (4.4)** | **S** | **Modifie 1.11** | Brainstorm |
| **1.22** | **🔄 Entretien auto bâtiments (4.3)** | **S** | **Modifie 1.3** | Brainstorm |
| **1.23** | **🆕 Fatigue sol — indice 0-100 (1.3)** | **M** | **Nouvelle** | Brainstorm |
| **1.24** | **🆕 Taxes & charges fixes saisonnières (1.6)** | **S** | **Nouvelle** | Brainstorm |
| **1.25** | **🔄 Sol 3 indicateurs + mode expert (4.2)** | **S** | **Modifie 1.2** | Brainstorm |
| **1.26** | **🆕 Optimistic UI (6.1)** | **M** | **Nouvelle** | Brainstorm |
| **1.27** | **🆕 Liens contextuels « Aller à » (3.8)** | **S** | **Nouvelle** | Brainstorm |

**Livrable Phase 1** : Un joueur peut cultiver du blé, le récolter, le vendre au Marché Central (consultation gratuite). Sol simplifié en 3 indicateurs (mode expert disponible). Bâtiments niv1 instantanés, entretien auto. Fatigue du sol force la rotation. Taxes mensuelles. Actions optimistes côté client. **C'est le MVP jouable.**

---

### Phase 2 — MVP Élevage Bovins (12-16 semaines)

> Objectif : élevage bovin + rations dynamiques + automatisations.

| # | Feature | Effort | Statut | Source |
|---|---------|--------|--------|--------|
| 2.1 | Système animal générique | XL | Existante | Roadmap v1 |
| 2.2 | Bovins 4 races MVP | L | Existante | Roadmap v1 |
| 2.3 | Bâtiments élevage (stabulation niv 1-5) | L | Existante | Roadmap v1 |
| 2.4 | Alimentation (rations par âge, qualité 1-3) | XL | Existante | Roadmap v1 |
| 2.5 | Abreuvement | M | Existante | Roadmap v1 |
| 2.6 | Litière & fumier/lisier | M | Existante | Roadmap v1 |
| 2.7 | Pâturage (avril→octobre) | L | Existante | Roadmap v1 |
| 2.8 | Reproduction bovine (IA + naturelle) | L | Existante | Roadmap v1 |
| 2.9 | Production laitière (traite 1-4x/jour) | L | Existante | Roadmap v1 |
| 2.10 | Vente abattoir | M | Existante | Roadmap v1 |
| 2.11 | Achat animaux — Le Marché Central | M | Existante | Roadmap v1 |
| 2.12 | Maladies & vaccins | M | Existante | Roadmap v1 |
| 2.13 | Transport animaux (bétaillère) | S | Existante | Roadmap v1 |
| 2.14 | Herbe & pré | L | Existante | Roadmap v1 |
| 2.15 | Allaitement bovins | S | Existante | Roadmap v1 |
| 2.16 | Rations hivernales au pré | M | Existante | Roadmap v1 |
| **2.17** | **🔄 Rations dynamiques avec score nutritionnel (1.2)** | **M** | **Modifie 2.4** | Brainstorm |
| **2.18** | **🔄 Nourrissage auto par défaut (4.1)** | **S** | **Modifie 2.4** | Brainstorm |
| **2.19** | **🆕 Lignées reproduction & traits héritables (1.1)** | **L** | **Modifie 2.8 + génétique** | Brainstorm |
| **2.20** | **🆕 Savoir-Faire — skill passif (2.1)** | **L** | **Nouvelle** | Brainstorm |
| **2.21** | **🆕 File d'actions — queue séquentielle (4.8)** | **L** | **Nouvelle** | Brainstorm |
| **2.22** | **🆕 Dashboard financier avec graphiques (3.5)** | **M** | **Nouvelle** | Brainstorm |
| **2.23** | **🆕 Mode focus parcelle plein écran (3.9)** | **S** | **Nouvelle** | Brainstorm |

**Livrable Phase 2** : Un joueur peut élever des bovins avec nourrissage automatique, rations dynamiques à score nutritionnel visible, et sélection génétique par lignées. File d'actions pour enchaîner les tâches. Dashboard financier complet. Savoir-faire qui progresse avec la pratique.

---

### Phase 3 — Économie & Commerce (10-12 semaines)

> Objectif : économie joueur-joueur, coopératives, marché à terme.

| # | Feature | Effort | Statut | Source |
|---|---------|--------|--------|--------|
| 3.1 | CAR — Coopératives Agricoles Régionales | XL | Existante | Roadmap v1 |
| 3.2 | CAR — contrats parcelle | L | Existante | Roadmap v1 |
| 3.3 | CAR — achat/vente récoltes | M | Existante | Roadmap v1 |
| 3.4 | CAR — emprunts | S | Existante | Roadmap v1 |
| 3.5 | CAR — faillite | S | Existante | Roadmap v1 |
| 3.6 | Annonces (matériels/marchandises) | M | Existante | Roadmap v1 |
| 3.7 | Amis privilégiés | S | Existante | Roadmap v1 |
| 3.8 | Transport routier | XL | Existante | Roadmap v1 |
| 3.9 | Déplacement inter-zones | M | Existante | Roadmap v1 |
| 3.10 | Vente parcelles entre joueurs | M | Existante | Roadmap v1 |
| 3.11 | Commerce animaux entre joueurs | M | Existante | Roadmap v1 |
| 3.12 | Épargne (3 formules) | M | Existante | Roadmap v1 |
| 3.13 | Parts sociales CAR | S | Existante | Roadmap v1 |
| 3.14 | Employé agricole | M | Existante | Roadmap v1 |
| 3.15 | Achat/vente HT entre joueurs | S | Existante | Roadmap v1 |
| 3.16 | ETA — Entreprise de Travaux Agricoles | L | Existante | Roadmap v1 |
| 3.17 | Appels d'offres usines PNJ | L | Existante | Roadmap v1 |
| **3.18** | **🆕 Contrats saisonniers entre joueurs (2.2)** | **L** | **Nouvelle** | Brainstorm |
| **3.19** | **🆕 Enchères hebdomadaires matériel rare (2.6)** | **M** | **Nouvelle** | Brainstorm |
| **3.20** | **🆕 Coopération récolte entre voisins (2.7)** | **M** | **Nouvelle** | Brainstorm |
| **3.21** | **🆕 Marché à terme avec graphiques (2.10)** | **L** | **Nouvelle** | Brainstorm |
| **3.22** | **🔄 Plafond marchés augmenté à 24 HT/jour (4.6)** | **S** | **Modifie 3.6** | Brainstorm |

**Livrable Phase 3** : Les joueurs commercent entre eux via contrats fermes et enchères. Coopération de récolte entre voisins. Marché à terme avec graphiques et spéculation. Les CAR structurent l'économie régionale.

---

### Phase 4+ — Activités secondaires & Social

> Inchangé par rapport à la roadmap v1, avec ajout du mentorat.

| # | Feature | Effort | Statut | Source |
|---|---------|--------|--------|--------|
| 4+ | Espèces supplémentaires, concessionnaire, CIA, fromagerie, maraîchage... | — | Existante | Roadmap v1 |
| **4+.NEW** | **🆕 Système de mentor (2.5)** | **M** | **Nouvelle** | Brainstorm |

---

## 3. MODIFICATIONS AUX SPECS EXISTANTES

### PHASE0_INFRASTRUCTURE.md

| Section | Modification | Feature source |
|---------|-------------|----------------|
| Feature 7 — Notifications | Ajouter WebSocket push natif (channel `player:{id}:notifications` + `server:{id}:notifications`) | 6.2 WebSocket |
| Nouvelle Feature 10 | Ajouter spec WebSocket : connexion auth JWT, channels, heartbeat, reconnexion auto | 6.2 WebSocket |
| Nouvelle Feature 11 | Ajouter spec Cache Redis : clés, TTL, invalidation au tick, patterns Pub/Sub | 6.5 Cache Redis |
| Nouvelle Feature 12 | Ajouter spec Pagination cursor : format cursor opaque, limit max 50, compression gzip/brotli | 6.4 Pagination |
| Nouvelle Feature 13 | Ajouter spec Monitoring : middleware onRequest/onResponse, métriques p50/p95/p99, alertes | 6.7 Monitoring |
| API GET /pa/history | Migrer offset → cursor pagination | 6.4 Pagination |
| API GET /bank/statement | Migrer offset → cursor pagination | 6.4 Pagination |
| API GET /notifications | Migrer offset → cursor pagination | 6.4 Pagination |
| Shell applicatif | Ajouter barre statut persistante (HT + solde + météo + saison + countdown tick) | 3.2 Barre statut |

### PHASE1_CULTURES.md

| Section | Modification | Feature source |
|---------|-------------|----------------|
| Feature 2 — Sol | Ajouter affichage simplifié 3 indicateurs : Fertilité (N+P+K), Structure (Ca+Mg), Oligo (S) + toggle expert | 4.2 Sol 3 indicateurs |
| Feature 2 — Sol | Ajouter `fatigue_index` (0-100) dans table parcel, formule : monoculture +15/récolte, rotation variée -10/saison, jachère -20/saison | 1.3 Fatigue sol |
| Feature 7 — Rendement | Ajouter `fatigue_factor = 1.0 - max(0, (fatigue_index - 60)) × 0.0125` dans la formule (0% malus si fatigue ≤ 60, -50% si fatigue = 100) | 1.3 Fatigue sol |
| Feature 7 — Rendement | Plafonner rendement total à 120% du base_yield_region | Équilibrage |
| Feature 3 — Bâtiments | Supprimer `MAX_FREE_BUILDINGS = 10`, remplacer par : tous les bâtiments niv1 = construction instantanée | 4.9 Construction niv1 |
| Feature 3 — Bâtiments | Entretien mensuel → prélèvement auto au tick (0.3 HT + coût €). Si HT insuffisants → sauté + notification | 4.3 Entretien auto |
| Feature 9 — Semences | Remplacer GP/G/P par Standard (factor 1.00, prix ×1.0) / Certifiée (factor 1.10, prix ×1.5) | 4.7 Semences 2 niveaux |
| Feature 10 — Marché Central | `PA_COOP_TRAVEL = 0` (consultation gratuite), seul `PA_COOP_TRANSACTION = 0.5` reste | 4.4 Marché gratuit |
| Nouvelle section | Taxes mensuelles : taxe foncière = `max(0, ha_total - 20) × 15€/ha/mois` (progressif, 0€ pour ≤20 ha, augmente aux 100 premiers ha), MSA = `chiffre_affaires_mensuel × 3%` | 1.6 Taxes/charges |
| Toutes les API liste | Migrer vers cursor pagination | 6.4 Pagination |
| Toutes les actions | Ajouter pattern Optimistic UI (update client → confirm/rollback serveur via WS) | 6.1 Optimistic UI |
| Notifications, dashboard, tableaux | Chaque mention d'entité = lien cliquable vers la fiche | 3.8 Liens contextuels |

### PHASE2_ELEVAGE.md

| Section | Modification | Feature source |
|---------|-------------|----------------|
| Feature 4 — Alimentation | Rations deviennent des recettes composées avec score nutritionnel visible (0-100). Score = moyenne pondérée des composants × qualité. Impact graduel sur croissance/lait (pas binaire) | 1.2 Rations dynamiques |
| Feature 4 — Alimentation | Nourrissage auto par défaut : le tick exécute la ration configurée tant qu'il y a du stock. Manuel reste possible pour ajuster. Étape insérée dans le tick AVANT vérif santé | 4.1 Nourrissage auto |
| Feature 8 — Reproduction | Remplacer formule `(père+mère)/2 + random(-5,+5)` par modèle lignées : `0.5×(père+mère)/2 + 0.25×(gp_paternel+gp_maternel)/2 + random(-3,+3)`. Arbre limité à 3 générations, stockage JSONB | 1.1 Lignées |
| Feature 12 — Génétique | Ajouter champ `lineage JSONB` dans table animal : `{parents: [id_père, id_mère], grandparents: [4 ids]}`. Traits héritables avec variance par lignée | 1.1 Lignées |
| Daily Tick Phase 2 | Insérer étape « 2bis. Nourrissage auto » entre « 2. Transitions cycle vie » et « 3. Vérif alimentation » | 4.1 Nourrissage auto |
| UX Phase 2 | Ajouter actions alimentation dans UX_PHASE2 : action 4 « Configurer ration auto » remplace « Nourrir manuellement » | 4.1 Nourrissage auto |

---

## 4. BACKLOG FUTUR — Features rejetées (28)

> Archivées pour réévaluation ultérieure par le PO. Classées par catégorie.

### Gameplay & Simulation (6)

| # | Feature | Effort | Phase cible | Raison du rejet / Commentaire PO |
|---|---------|--------|-------------|----------------------------------|
| 1.4 | Météo extrême avec choix stratégiques | M | 1 | Complexifie le MVP, les événements météo existent déjà |
| 1.5 | Transport avec usure et pannes en route | S | 3 | Frustrant si aléatoire pur, à tester en beta |
| 1.7 | Qualité des produits en 5 niveaux | S | 1 | Risque d'illiquidité du marché avec 5 niveaux |
| 1.8 | Cycle jour/nuit avec impact gameplay | L | 4+ | Trop risqué, double la charge mentale, refonte HT |
| 1.9 | Maladies contagieuses entre exploitations | M | 3 | Potentiellement toxique, à tester en beta fermée |
| 1.10 | Vieillissement matériel avec cote argus dynamique | M | 3 | PO : « intéressant mais plus tard » |

### Social & Communauté (4)

| # | Feature | Effort | Phase cible | Raison du rejet / Commentaire PO |
|---|---------|--------|-------------|----------------------------------|
| 2.3 | Événements communautaires par préfecture | M | 3 | Gestion d'état par préfecture complexe, nécessite masse critique |
| 2.4 | Carnet de l'exploitant (objectifs personnels) | S | 1 | Doublon potentiel avec objectifs hebdomadaires prévus |
| 2.8 | Saisons de crise économique | S | 3 | Punitif pour les nouveaux joueurs |
| 2.9 | Album de la ferme (screenshots milestones) | S | 4+ | Nice-to-have, pas prioritaire |

### UX & Interface (6)

| # | Feature | Effort | Phase cible | Raison du rejet / Commentaire PO |
|---|---------|--------|-------------|----------------------------------|
| 3.1 | Vue carte interactive de l'exploitation | L | 1 | Effort L pour du visuel, pas core gameplay |
| 3.3 | Mode résumé rapide au login | S | 1 | Doublon avec résumé quotidien QoL §3.4 |
| 3.4 | Thème visuel saisonnier automatique | S | 2 | Purement cosmétique, attention accessibilité |
| 3.6 | Glisser-déposer bâtiments | S | 2 | Cosmétique, localStorage seulement |
| 3.7 | Notifications sonores configurables | S | 2 | Sons web souvent agaçants, off par défaut |
| 3.10 | Indicateur rentabilité par parcelle | S | 2 | Intéressant mais nécessite calcul HT valorisés |

### Simplification (1)

| # | Feature | Effort | Phase cible | Raison du rejet / Commentaire PO |
|---|---------|--------|-------------|----------------------------------|
| 4.5 | Fusionner abreuver dans nourrir | S | 2 | L'eau reste une ressource séparée en backend |

### Monétisation (8)

| # | Feature | Effort | Phase cible | Raison du rejet / Commentaire PO |
|---|---------|--------|-------------|----------------------------------|
| 5.1 | Battle Pass saisonnier (Carnet de Saison) | L | 3 | Modèle à valider, uniquement cosmétique |
| 5.2 | Skins de matériels | S | 3 | Simple techniquement, pas prioritaire |
| 5.3 | Personnalisation ferme (décorations) | M | 4+ | Micro-transactions à 0.50€ = friction paiement |
| 5.4 | Licence Pro 3 formules | M | 1 | Débat P2W sur le bonus HT, compromis non trouvé |
| 5.5 | Nom personnalisé exploitation | S | 1 | Évident mais pas prioritaire |
| 5.6 | Avatars et portraits | S | 2 | Cosmétique pur |
| 5.7 | Don volontaire « Soutenir Cultivia » | S | 2 | Revenus imprévisibles, complément seulement |
| 5.8 | Emotes et réactions chat | S | 4+ | Trivial techniquement, pas prioritaire |

### Technique (3)

| # | Feature | Effort | Phase cible | Raison du rejet / Commentaire PO |
|---|---------|--------|-------------|----------------------------------|
| 6.3 | Prefetch intelligent pages adjacentes | S | 1 | Attention consommation data mobile |
| 6.6 | Service Worker / PWA | M | 1 | Intéressant mais pas MVP |
| 6.8 | Batch API actions groupées | M | 1 | Remplacé par 4.8 File d'actions côté client |

### Résumé backlog

| Effort | Nombre | % |
|--------|--------|---|
| S | 18 | 64% |
| M | 8 | 29% |
| L | 2 | 7% |
| **Total** | **28** | **100%** |

> 💡 **Note** : La majorité des features rejetées sont de faible effort (S). Elles pourront être réintégrées rapidement si le PO change d'avis. Les features 1.10 (argus dynamique) et 3.1 (carte interactive) sont les plus demandées par le joueur vétéran — à réévaluer après la beta.

---

## 5. RÉCAPITULATIF CHIFFRÉ

| Phase | Features existantes | Features nouvelles | Features modifiées | Total |
|-------|--------------------|--------------------|-------------------|-------|
| 0 | 12 | 6 | 0 | 18 |
| 1 | 18 | 5 | 4 | 27 |
| 2 | 16 | 4 | 3 | 23 |
| 3 | 17 | 4 | 1 | 22 |
| 4+ | existantes | 1 | 0 | +1 |
| **Total** | **63** | **20** | **8** | **91** |

| Catégorie brainstorm | Validées | Rejetées | Total |
|---------------------|----------|----------|-------|
| 1 — Mécaniques | 4 | 6 | 10 |
| 2 — Nouvelles mécaniques | 6 | 4 | 10 |
| 3 — UX/UI | 4 | 6 | 10 |
| 4 — Simplifications | 8 | 1 | 9 |
| 5 — Monétisation | 0 | 8 | 8 |
| 6 — Technique | 6 | 3 | 9 |
| **Total** | **28** | **28** | **56** |

---

> **Cultivia — 04_PRODUCT_ROADMAP.md — v2.0**
> Mise à jour : 2026-04-05 — Intégration brainstorm 28 features validées
> Prochaine étape : modifier les specs PHASE0/PHASE1/PHASE2 selon la section 3
