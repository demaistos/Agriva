# Agriva — Plan d'implémentation technique V1

> Date : 2026-05-07  
> Statut : Draft V1  
> Auteur : Tech & LiveOps Planner  
> Sources : `gdd_farming_progression_tech.md`, `2026-05-07-tech-liveops-v1.md`, `agriva_decisions_log_compact.md`  
> Contexte : Petit studio. Pragmatisme avant exhaustivité. Priorité à la jouabilité rapide.

---

## 0. Environnement de développement

**Dev local uniquement — Docker Compose.**

\\\yaml
# docker-compose.yml (services principaux)
services:
  postgres:
    image: postgres:16-alpine
    environment: { POSTGRES_DB: agriva, POSTGRES_PASSWORD: dev }
  redis:
    image: redis:7-alpine
  api:
    build: ./api
    depends_on: [postgres, redis]
    environment: { DATABASE_URL: postgresql://postgres:dev@postgres/agriva }
  frontend:
    build: ./frontend
    depends_on: [api]
\\\\n\n**Commandes de base :**\n- \docker compose up\ — démarrer tout\n- \docker compose exec api npx prisma migrate dev\ — migrations\n- \stripe listen --forward-to localhost:3000/webhooks/stripe  # [POST-V1]\ — Stripe local\n\n---\n\n## 1. Architecture technique

### 1.1 Stack recommandée

| Couche | Technologie | Justification |
|--------|-------------|---------------|
| **Frontend** | React + TypeScript | Composants réutilisables, écosystème mature, pas de surcharge pour un jeu browser asynchrone |
| **Rendu carte/parcelles** | PixiJS (Canvas 2D) | Léger, performant navigateur, pas de WebGL requis |
| **Backend** | Node.js + Express | Même langage front/back, suffisant pour le modèle asynchrone V1 |
| **Base de données** | PostgreSQL | Transactions ACID pour l'économie, relations claires, fiable |
| **Cache / état temps réel** | Redis | File de tâches, sessions, paramètres ajustables à chaud |
| **Réseau** | REST (actions) + WebSocket (notifications push) | REST pour les actions joueur ; WS uniquement pour les notifications post-tick |
| **Auth** | JWT (access + refresh tokens) | Simple, stateless, pas de dépendance externe obligatoire |
| **Monitoring** | Logs JSON structurés → fichier/stdout + dashboard admin maison | Suffisant jusqu'à ~3 000 joueurs actifs ; pas d'APM externe en V1 |
| **Paiement** | Stripe (abonnement mensuel/annuel) | **[POST-V1]** — non requis pour Sprint 1–6 |
| **Hébergement** | 1 VPS (4 vCPU, 8 Go RAM, SSD) | Suffisant pour alpha + bêta ; scalabilité horizontale = V2+ |

### 1.2 Architecture des services — Monolithe modulaire

**Décision : monolithe modulaire**, pas de microservices.

Justification : petit studio, équipe réduite, modèle asynchrone (1 tick/jour). Les microservices ajoutent une complexité opérationnelle injustifiée à ce stade. La modularité interne permet d'extraire des services plus tard si nécessaire.

```
agriva-server/
├── modules/
│   ├── auth/          # JWT, sessions, comptes
│   ├── world/         # Régions, météo, calendrier
│   ├── farm/          # Fermes, parcelles, sols
│   ├── crops/         # Cultures, stades, rendements
│   ├── livestock/     # Élevage, troupeaux
│   ├── tasks/         # File d'ordres, travaux
│   ├── economy/       # Marché, bot, stocks, trésorerie
│   ├── territory/     # Foncier, achat/location
│   ├── social/        # Classements, succès, messagerie
│   └── tick/          # Moteur de simulation quotidien
├── shared/            # Types, utilitaires, constantes
├── admin/             # Dashboard interne, paramètres à chaud
└── api/               # Routes REST + handlers WebSocket
```

**Règle** : chaque module expose une interface publique claire. Les modules ne s'appellent pas directement — ils passent par des événements internes ou des services partagés. Cela facilite les tests unitaires et une future extraction.

### 1.3 Modèle de données principal

#### Entités clés et relations
> Entités : Player, Farm, Region, RegionClimate, Parcel, Crop, Equipment, Building, Inventory, Stock, Task, MarketOrder, ServiceOrder, Achievement, PlayerAchievement, Notification, WeatherForecast, GameClock

```
Player
  id, username, email, password_hash
  mode_global: enum(normal|expert)
  difficulty_preset: enum(facile|standard|exigeant)
  subscription_status: enum(free|active|expired)  // [POST-V1] toujours "free" jusqu'à intégration Stripe
  created_at, last_login_at

Farm
  id, player_id (FK Player)
  name, region_id (FK Region)
  treasury: decimal          -- trésorerie courante
  reputation: int
  dominant_activity: enum(grandes_cultures|elevage|maraichage|mixte)

Region
  id, name, climate_type
  risk_intensity: float      -- paramètre ajustable à chaud

Parcel
  id, farm_id (FK Farm)
  surface_ha: decimal
  soil_type: enum
  -- Mode normal
  fertility: int(0-100)
  humidity: int(0-100)
  -- Mode expert (nullable si normal)
  nitrogen: int, phosphorus: int, potassium: int
  organic_matter: float, ph: float, compaction: int
  -- Commun
  current_crop_id: int (FK Crop, nullable)
  previous_crop_type: varchar  -- pour calcul rotation
  locked_until: date           -- fusion en cours

Crop
  id, parcel_id (FK Parcel)
  crop_type: enum(ble|orge|colza|mais|tournesol|betterave|...)
  stage: enum(semis|levee|croissance|floraison|maturation|recolte)
  sown_at: date
  expected_harvest_at: date
  yield_potential: float       -- modifié par sols, météo, travaux
  quality: float(0-1)
  status: enum(active|harvested|failed)

Task (file d'ordres — max 3 actives par ferme)
  id, farm_id (FK Farm)
  task_type: enum(labour|semis|traitement|recolte|alimentation|...)
  parcel_id: int (FK Parcel, nullable)
  started_at: date
  estimated_duration_days: int
  status: enum(queued|in_progress|completed|cancelled)
  worker_type: enum(player|bot_eta|coop_transport)

MarketOrder
  id, farm_id (FK Farm)
  product: varchar
  quantity: decimal
  price: decimal
  side: enum(buy|sell)
  counterpart: enum(bot|player)
  created_at, filled_at (nullable)

Stock
  id, farm_id (FK Farm)
  product: varchar
  quantity: decimal
  capacity_max: decimal        -- contrainte structurante
  stored_since: date

WeatherForecast
  id, region_id (FK Region)
  game_date: date
  condition: enum
  temperature_min, temperature_max: int
  precipitation_mm: int
  reliability: enum(haute|moyenne|faible)  -- J+1/J+3/J+7

GameClock
  id: 1 (singleton)
Building
  id, farm_id (FK Farm)
  type: enum(silo_cereales|entrepot_sec|chambre_froide|citerne_liquide|
             batiment_elevage|atelier_transformation|hangar_materiel)
  name: varchar
  capacity: decimal            -- t ou UGB selon type
  capacity_used: decimal       -- calculé à chaque tick
  condition: int(0-100)
  construction_status: enum(operational|under_construction)
  construction_done_at: date   -- null si opérationnel
  daily_fixed_cost: decimal    -- amortissement/entretien

Inventory                      -- stocks d'intrants (semences, engrais, carburant, aliments)
  id, farm_id (FK Farm)
  item_type: enum(semences_ble|semences_orge|semences_colza|semences_mais|
                  semences_tournesol|semences_betterave|semences_legumes|
                  engrais_azote|engrais_phosphore|engrais_potasse|
                  herbicide|fongicide|insecticide|
                  carburant|aliments_bovins|aliments_porcins|aliments_volailles)
  quantity: decimal
  unit: enum(kg|t|L|sac)
  purchase_price: decimal      -- prix d'achat (pour calcul marge)
  purchased_at: date

  current_game_date: date
  last_tick_at: timestamp
  tick_duration_ms: int        -- durée du dernier tick (monitoring)

Equipment
  id, farm_id (FK Farm)
  name: varchar                -- ex. "Tracteur John Deere 6R"
  type: enum(tracteur|semoir|moissonneuse|pulverisateur|benne|micro_tracteur|autre)
  power_kw: int                -- puissance (détermine capacité de travail/ha)
  working_width_m: float       -- largeur de travail (détermine vitesse de chantier)
  condition: int(0-100)        -- état (dégradé par l'usure)
  available: bool              -- false si en cours d'utilisation sur une tâche
  owner_type: enum(owned|rented)
  -- Coûts
  daily_fixed_cost: decimal    -- amortissement/entretien par jour in-game
  fuel_cost_per_ha: decimal    -- carburant par hectare travaillé

```


Stock                          -- lots en silo (distinct de Inventory = intrants)
  id, farm_id (FK Farm)
  building_id (FK Building)    -- silo où est stocké le lot
  product: varchar             -- ex. "ble", "lait_brut", "fromage_standard"
  quantity: decimal
  quality: int(0-100)
  stored_at: date
  origin: enum(production|bot_purchased|transformed)  -- tag anti-arbitrage

ServiceOrder                   -- ETA bot, transport coop
  id, farm_id (FK Farm)
  service_type: enum(eta_labour|eta_semis|eta_recolte|transport_coop|insemination)
  target_task_id (FK Task, nullable)
  cost: decimal
  delay_days: int
  status: enum(pending|in_progress|completed)
  ordered_at: date

Achievement                    -- définition des succès
  id, achievement_id: varchar  -- ex. "ACH_FIRST_HARVEST"
  name, condition_description
  reward_type: enum(badge|title|skin)

PlayerAchievement              -- succès débloqués par joueur
  id, player_id (FK Player)
  achievement_id (FK Achievement)
  unlocked_at: date


RegionClimate                  -- normales climatiques réelles par région et mois
  id, region_id (FK Region)
  month: int(1-12)             -- mois de l'année
  temp_min_avg: float          -- température minimale moyenne (°C) — source : Météo-France normales
  temp_max_avg: float          -- température maximale moyenne (°C)
  precipitation_avg: float     -- précipitations moyennes (mm)
  sunshine_avg: float          -- ensoleillement moyen (h/jour)
  frost_probability: float     -- probabilité de gel (0-1)
  drought_probability: float   -- probabilité de sécheresse (0-1)
  -- Ces données sont seedées en base (données statiques, jamais modifiées en runtime)

WeatherForecast                -- météo générée pour chaque jour de jeu par région
  id, region_id (FK Region)
  game_date: date
  -- Valeurs calculées : normale RegionClimate + variance aléatoire (seed déterministe)
  temp_min: float, temp_max: float
  precipitation: float
  sunshine: float
  event: enum(aucun|gel|canicule|orage|grele|inondation|secheresse)
  -- Fiabilité décroissante selon horizon (J+1 ~90%, J+3 ~70%, J+7 ~50%)
  reliability: float(0-1)

Notification                   -- alertes et résultats tick
  id, player_id (FK Player)
  type: enum(tick_result|alert_stock|alert_meteo|alert_treasury|achievement)
  payload: jsonb
  read: bool
  created_at: timestamp

#### Relations principales

```
Player 1──* Farm
Farm   1──* Parcel
Farm   1──* Task
Farm   1──* Stock
Farm   1──* MarketOrder
Parcel 0..1──1 Crop
Region 1──* Farm
Region 1──* WeatherForecast
Farm   1──* Equipment
Farm   1──* Building
Farm   1──* Inventory
Farm   1──* Stock
Farm   1──* ServiceOrder
Farm   1──* Notification
Player 1──* PlayerAchievement
Building 1──* Stock
Region  1──12 RegionClimate   // 1 entrée par mois, données statiques seedées
Region  1──* WeatherForecast
```

### 1.4 Cycle de simulation serveur (tick quotidien)

Le tick est le cœur du jeu. Il s'exécute **une fois par jour de jeu** (1 mois = 5 jours réels → 1 jour de jeu ≈ 4h48 réelles).

**Déclenchement** : cron job à heure fixe (02h00 UTC). Si un joueur se connecte et que le tick du jour n'a pas encore été appliqué à sa ferme, il est appliqué à la connexion (mode rattrapage).

**Séquence du tick** (par ferme, traitement batch de 100 fermes en parallèle) :

```
1. MÉTÉO
   - Générer/avancer les prévisions météo pour la région
   - Appliquer les effets météo sur les parcelles (humidité, stress)

2. CULTURES
   - Avancer le stade de chaque culture active
   - Calculer les modificateurs de rendement (météo × sols × travaux effectués)
   - Détecter les cultures en échec (stade bloqué, conditions critiques)

3. ÉLEVAGE
   - Avancer le cycle de chaque troupeau
   - Calculer production (lait, œufs, croissance)
   - Consommer stocks d'alimentation

4. TRAVAUX
   - Avancer les tâches en cours (décrémenter durée restante)
   - Compléter les tâches terminées → appliquer effets sur parcelle/culture
   - Débloquer la prochaine tâche dans la file d'ordres

5. STOCKS
   - Appliquer dégradation des stocks périssables
   - Vérifier dépassements de capacité → alerte

6. ÉCONOMIE
   - Mettre à jour les prix du bot (algorithme spread 15-25%)
   - Calculer les coûts fixes journaliers (charges structurelles)
   - Déclencher les aides automatiques si seuils atteints

7. CLASSEMENTS
   - Recalculer le score de chaque ferme (quotidien)
   - Score = revenu_net×0.4 + marge_nette×0.25 + diversification×0.15 + %ventes_hors_bot×0.20

8. TÉLÉMÉTRIE
   - Logger tick_completed avec durée et nombre de fermes traitées

9. NOTIFICATIONS
   - Pousser via WebSocket les changements significatifs aux joueurs connectés
   - Stocker les notifications pour les joueurs déconnectés
```

**Durée cible** : < 500 ms par ferme ; < 60 s total pour 3 000 fermes actives.

---

## 2. Découpage en sprints

> 6 sprints × 2 semaines = 12 semaines (3 mois) jusqu'à l'alpha interne jouable.

---

## Sprint 1 — Fondations

**Durée** : 2 semaines  
**Objectif** : Avoir un serveur qui tourne, un joueur qui se connecte, une ferme avec des parcelles, et un tick quotidien qui s'exécute.

**Livrables** :
- [ ] Projet initialisé (monorepo, TypeScript, ESLint, tests unitaires configurés)
- [ ] Module `auth` : inscription, connexion, JWT access + refresh, logout
- [ ] Schéma BDD PostgreSQL V1 avec **Prisma** (ADR-001) : `schema.prisma`, `prisma migrate dev`
- [ ] Entités : `Player`, `Farm`, `Region`, `RegionClimate`, `Parcel`, `Equipment`, `Building`, `Inventory`, `WeatherForecast`, `GameClock`
- [ ] API REST : CRUD ferme, CRUD parcelles, CRUD matériel, CRUD bâtiments (silo/hangar/bâtiment élevage), CRUD inventaire intrants (semences, engrais, carburant)
- [ ] Module `world` : 8 régions agroclimatiques seedées avec leurs `RegionClimate` (normales mensuelles réelles — 8×12 = 96 entrées statiques), génération `WeatherForecast` = normale + variance aléatoire déterministe
- [ ] Entités supplémentaires : `Stock` (lots en silo), `Notification` (stub), `EventBus` (interne, pub/sub synchrone)
- [ ] Module `tick` : cron job, séquence météo + avancement cultures (stub), logging `tick_completed`
- [ ] Dashboard admin minimal : vue GameClock, déclenchement tick manuel, logs récents
- [ ] **UI Sprint 1** : pages `/connexion` et `/inscription` (wizard 4 étapes : email+mdp / pseudo / région+dept / difficulté+activité)
- [ ] Tests : tick s'exécute sans erreur, auth fonctionne, parcelles persistées

**Critères de done** :
- [ ] Un joueur peut s'inscrire, se connecter, créer une ferme avec 3 parcelles, un silo (Building), un stock vide (Stock), et acheter des semences (Inventory)
- [ ] Le tick s'exécute automatiquement toutes les ~5h (configurable) sans erreur
- [ ] Les prévisions météo sont générées pour les 7 prochains jours de jeu pour chaque région
- [ ] Les logs `tick_completed` apparaissent dans le dashboard admin
- [ ] Tous les tests unitaires passent (couverture ≥ 70 % sur `tick` et `auth`)
- [ ] Tests Playwright UI : flux inscription complet 4 étapes + connexion (4/4 en navigateur réel)

**Dépendances** : aucune (sprint initial)

---

## Sprint 2 — Farming core

**Durée** : 2 semaines  
**Objectif** : Un joueur peut semer, suivre la croissance de ses cultures, et récolter — la boucle agricole de base est jouable.

**Livrables** :
- [ ] Module `crops` : entité `Crop`, stades (semis→levée→croissance→floraison→maturation→récolte), durées par type de culture
- [ ] Transfert récolte → Stock (Building silo) : consomme `Inventory(semences)` au semis, remplit `Stock` à la récolte
- [ ] EventBus : événements `crop.harvested`, `task.completed`, `stock.full` → déclenche Notifications
- [ ] 6 cultures grandes cultures : blé, orge, colza, maïs, tournesol, betterave (durées selon decisions log)
- [ ] Calcul rendement : modificateurs sols (fertilité/humidité normal ; NPK/pH/MO expert), météo, rotation (+5/+15, malus monoculture -10%)
- [ ] Module `tasks` : entité `Task`, file d'ordres (max 3 actives), types : labour, semis, traitement, récolte
- [ ] Tick : intégration complète séquences 1 (météo) + 2 (cultures) + 4 (travaux)
- [ ] API REST : démarrer une tâche, consulter la file, annuler une tâche
- [ ] Mode Normal/Expert : flag par joueur, sols simplifiés vs détaillés, UI adaptative (stub)
- [ ] Tests : cycle complet semis→récolte simulé en accéléré

**Critères de done** :
- [ ] Un joueur peut labourer une parcelle, semer du blé, attendre la croissance, récolter
- [ ] Le rendement varie selon la fertilité du sol et la météo (vérifiable en logs)
- [ ] La file d'ordres bloque à 3 tâches actives
- [ ] Le malus monoculture s'applique si même culture 2 saisons consécutives
- [ ] Mode Expert affiche NPK + pH + MO sur la parcelle

**Dépendances** : Sprint 1

---

## Sprint 3 — Économie

**Durée** : 2 semaines  
**Objectif** : Le joueur peut vendre sa récolte, le bot assure la liquidité, les stocks sont contraignants — la boucle économique est fermée.

**Livrables** :
- [ ] Module `economy` : entité `MarketOrder`, entité `Stock` avec capacité max
- [ ] Bot de marché : prix de référence par produit, spread 15-25%, algorithme d'ajustement hebdomadaire
- [ ] EventBus : événements `market.order.filled`, `treasury.low`, `stock.degraded` → Notifications
- [ ] Marché joueur : ordres d'achat/vente, matching joueur↔joueur, fallback bot
- [ ] Tag d'origine sur les transactions (bot vs joueur), rendements décroissants si volume bot > 60%
- [ ] Trésorerie : coûts fixes journaliers, revenus des ventes, bilan consultable
- [ ] Stocks : contrainte de capacité structurante, dégradation périssables dans le tick
- [ ] 3 chaînes de transformation : lait→laiterie, céréales→meunerie, légumes→conserverie (+20-40% valeur, bâtiment requis)
- [ ] Aide automatique : seuils `aid_threshold_cash` et `aid_amount_cash` configurables à chaud
- [ ] Dashboard admin : vue prix bots, volumes transactions, taux bot vs joueur
- [ ] Tests : arbitrage bot impossible (spread toujours défavorable), aide déclenchée aux bons seuils

**Critères de done** :
- [ ] Un joueur peut vendre sa récolte au bot ou à un autre joueur
- [ ] Le spread bot est toujours ≥ 15% (achat < prix référence, vente > prix référence)
- [ ] Un stock plein bloque la récolte (message d'erreur clair)
- [ ] L'aide automatique se déclenche si trésorerie < seuil configuré
- [ ] Les paramètres bot sont modifiables à chaud depuis le dashboard sans redéploiement
- [ ] Aucun arbitrage bot détecté (test automatisé : achat + revente immédiate = perte)

**Dépendances** : Sprint 2

---

## Sprint 4 — Élevage + Territoire

**Durée** : 2 semaines  
**Objectif** : Le joueur peut gérer un troupeau et acquérir de nouvelles parcelles — les deux autres piliers de l'exploitation sont jouables.

**Livrables** :
- [ ] Entité `ServiceOrder` : ETA bot et transport coop (type, ferme, tâche cible, coût, délai, statut)
- [ ] Module `livestock` : bovins lait/viande, ovins, porcins, volailles ; cycles de production, consommation d'alimentation (Inventory)
- [ ] Tick : intégration séquence 3 (élevage)
- [ ] Module `territory` : achat et location de parcelles, marché foncier local, regroupement de blocs, fusion avec coût
- [ ] Carte France : 6-8 macro-régions agroclimatiques, département, ville (données seedées)
- [ ] Services : ETA bot via `ServiceOrder` (crée une Task déléguée), transport coop via `ServiceOrder`
- [ ] Logistique : coût + délai de transport entre parcelles distantes
- [ ] Classement saisonnier : calcul du score (formule decisions log), 8 classements (2 modes × 4 activités)
- [ ] Tests : cycle élevage complet (achat animal → production → vente), achat parcelle

**Critères de done** :
- [ ] Un joueur peut acheter des bovins laitiers, les nourrir, collecter le lait, le vendre
- [ ] Un joueur peut acheter une parcelle adjacente (marché foncier)
- [ ] La fusion de parcelles est possible avec coût et délai
- [ ] Le classement saisonnier se met à jour quotidiennement
- [ ] Les 8 classements (mode × activité) sont consultables

**Dépendances** : Sprint 3

---

## Sprint 5 — Polish UI + Onboarding

**Durée** : 2 semaines  
**Objectif** : Polir l'UI construite incrémentalement aux sprints 1-4, finaliser l'onboarding et rendre le tout responsive mobile.

**Livrables** :
- [ ] Polish et cohérence visuelle de tous les écrans construits aux sprints 1-4
- [ ] UI mobile responsive : breakpoints 375/768/1024 px, touch targets ≥ 44 px, pas de hover-only
- [ ] Onboarding : séquence de 4 missions (jusqu'à "Première vente" incluse), guidage contextuel
- [ ] Mode Normal/Expert : UI adaptative complète (sols simplifiés vs détaillés, météo simple vs fine)
- [ ] Presets de difficulté : facile/standard/exigeant sur les amortisseurs (aides, pénalités)
- [ ] Notifications in-app : résultats du tick, alertes stocks, alertes météo
- [ ] Télémétrie complète : tous les événements du §1 de tech-liveops-v1 loggés
- [ ] Tests : taux de complétion onboarding mesuré, UI testée sur Chrome/Firefox/Edge/Safari

**Critères de done** :
- [ ] Un nouveau joueur complète les 4 missions d'onboarding sans aide en < 20 min
- [ ] L'UI est utilisable sur mobile 375 px (pas de contenu coupé, actions accessibles)
- [ ] Les notifications post-tick arrivent en < 5 s via WebSocket
- [ ] La télémétrie `onboarding_step` est loggée pour chaque étape
- [ ] L'UI s'adapte correctement au mode Normal vs Expert (test manuel)

**Dépendances** : Sprint 4

---

## Sprint 6 — Social, classements, succès, polish

**Durée** : 2 semaines  
**Objectif** : Le jeu est prêt pour l'alpha interne — social minimal, succès, polish, stabilité.

**Livrables** :
- [ ] Messagerie limitée : messages directs entre joueurs (pas de chat global)
- [ ] Entité `Achievement` + `PlayerAchievement` (débloqué, date)
- [ ] Système de déclenchement : listeners sur EventBus (`crop.harvested`, `market.order.filled`, `farm.year.completed`, etc.)
- [ ] 20 succès (liste decisions log §economy-markets-v1 §5) : jalons principaux, récompenses cosmétiques uniquement
- [ ] Cosmétiques : personnalisation ferme/avatar (non compétitif)
- [ ] **[POST-V1]** Abonnement confort : intégration Stripe, features abonnés
- [ ] Dashboard admin complet : tous les paramètres ajustables à chaud, vue santé serveur, vue joueurs
- [ ] Polish : messages d'erreur clairs, états de chargement, gestion des cas limites (stock plein, trésorerie négative, etc.)
- [ ] Tests de charge : simulation 50 joueurs actifs simultanés, tick < 5 s total
- [ ] Documentation : README technique, guide déploiement, liste des paramètres admin

**Critères de done** :
- [ ] Les 20 succès se débloquent aux bons jalons (test manuel sur compte de test)
- [ ] **[POST-V1]** L'abonnement Stripe fonctionne
- [ ] Le tick s'exécute sans erreur 7 jours consécutifs sur l'environnement de dev local Docker Compose
- [ ] Aucun bug bloquant ouvert
- [ ] La documentation de déploiement permet à un nouveau dev de lancer le projet en < 1h

**Dépendances** : Sprint 5

---

## 3. Risques techniques

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| Tick trop lent à l'échelle (> 60 s pour 3 000 fermes) | Moyenne | Élevé | Traitement batch parallèle dès Sprint 1 ; benchmark à chaque sprint ; optimisation SQL (index sur `farm_id`, `game_date`) |
| Arbitrage bot non détecté en production | Faible | Élevé | Test automatisé anti-arbitrage dans la CI (achat + revente immédiate = perte garantie) ; alerte dashboard si taux bot > 60% |
| Dérive du modèle de données entre sprints | Élevée | Moyen | Migrations versionnées dès Sprint 1 ; pas de modification de schéma sans migration |
| Complexité du mode Normal/Expert mal isolée | Moyenne | Moyen | Flag par joueur en BDD ; logique conditionnelle centralisée dans les modules `crops` et `farm`, pas dans l'API |
| Onboarding trop complexe → abandon précoce | Moyenne | Élevé | Tester l'onboarding avec des non-joueurs dès Sprint 5 ; métrique `onboarding_step` pour identifier les points de friction |
| Synchronisation tick asynchrone (joueur se connecte entre deux ticks) | Moyenne | Moyen | Rattrapage à la connexion : appliquer les ticks manqués avant de servir l'état ; tester le cas "joueur absent 3 jours" |
| Sécurité : manipulation des prix/stocks côté client | Faible | Élevé | Toute la logique de simulation est serveur ; le client ne fait qu'envoyer des intentions (actions) ; validation stricte côté API |
| **[POST-V1]** Stripe webhook manqué → abonnement non activé | Faible | Moyen | Idempotence des webhooks |

---

## 4. Critères d'entrée alpha

L'alpha interne est jouable quand **toutes** les conditions suivantes sont remplies :

**Boucle principale**
- [ ] Observer → Évaluer → Planifier → Réserver → Exécuter → Vendre/Acheter → Investir → Progresser est jouable de bout en bout
- [ ] Au moins 1 culture grande culture complète (semis → récolte → vente)
- [ ] Au moins 1 type d'élevage fonctionnel (achat → production → vente)
- [ ] Achat/location d'une parcelle fonctionne

**Économie**
- [ ] Bot de marché opérationnel (spread ≥ 15%, aucun arbitrage possible)
- [ ] Trésorerie, coûts fixes, revenus calculés correctement
- [ ] Stocks avec contrainte de capacité

**Technique**
- [ ] Tick quotidien s'exécute sans erreur 7 jours consécutifs
- [ ] Auth sécurisée (JWT, pas de fuite de données entre comptes)
- [ ] Latence P95 des actions < 500 ms

**Jouabilité**
- [ ] Onboarding : un nouveau joueur atteint la première vente sans aide
- [ ] UI desktop utilisable (pas de bug bloquant, pas de contenu inaccessible)
- [ ] Mode Normal jouable sans connaissance préalable du jeu

**Admin**
- [ ] Dashboard admin opérationnel (prix bots, volumes, santé serveur)
- [ ] Au moins 3 paramètres ajustables à chaud sans redéploiement

**Non requis pour l'alpha** (V2+ ou bêta) : mobile responsive complet, abonnement Stripe [POST-V1], classements publics, succès, messagerie, 6 régions complètes.

---

## 5. Décisions techniques à prendre (ADR)

✅ Les 10 ADR V1 sont écrits et acceptés. Voir l'index complet : **[Docs/plans/ADR/README.md](ADR/README.md)**

Le tableau récapitulatif (numéro, titre, statut, décision retenue) et le processus pour créer de nouveaux ADR sont documentés dans ce fichier index.

---

## Récapitulatif des jalons

| Jalon | Date cible | Critère principal |
|-------|-----------|-------------------|
| Fin Sprint 1 | S+2 | Tick tourne, auth fonctionne, parcelles persistées |
| Fin Sprint 2 | S+4 | Boucle semis→récolte jouable |
| Fin Sprint 3 | S+6 | Boucle économique fermée, bot opérationnel |
| Fin Sprint 4 | S+8 | Élevage + foncier jouables |
| Fin Sprint 5 | S+10 | UI complète, onboarding fonctionnel |
| **Alpha interne** | S+12 | Tous les critères §4 remplis |
| **Bêta fermée** | S+24 | Rétention J7 ≥ 30%, 50-150 joueurs invités |
| **V1 publique** | S+36 | Rétention J30 ≥ 20%, 1 000 joueurs actifs |

---

*Tout ce qui dépasse V1 est documenté dans `2026-05-07-tech-liveops-v1.md` §Récapitulatif V2+.*
