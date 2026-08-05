# ADR-003 — Gestion du temps in-game (1 mois = 5j réels)

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Le temps in-game est découplé du temps réel selon le ratio fixé : 1 mois de jeu = 5 jours réels, 1 saison = 15 jours réels, 1 année = 60 jours réels. Ce ratio conditionne les durées de cultures (2 à 10 mois de jeu), les cycles d'élevage, les saisons compétitives et le déclenchement du tick. Il faut choisir comment stocker et faire avancer ce temps de manière fiable, testable et cohérente avec le modèle de tick hybride retenu en ADR-002.

## Options considérées

### Option A — Timestamp absolu serveur (date réelle convertie à la volée)

Le temps de jeu est calculé à partir d'une date de départ fixe et du timestamp réel courant, via le ratio `GAME_RATIO = 24 / (5 * 24 / 30)` (1 jour réel = 6 jours de jeu).

**Avantages** : pas de stockage dédié, le temps avance "tout seul" en continu.  
**Inconvénients** : le temps avance même sans tick — incohérence entre l'état simulé (mis à jour par tick) et le temps affiché ; impossible de mettre le jeu en pause pour maintenance ; ratio difficile à modifier sans recalculer toutes les dates existantes ; tests complexes (dépendance à `Date.now()`).

### Option B — Compteur de ticks (entier incrémenté)

`current_game_day` est un entier stocké en base, incrémenté de 1 à chaque tick. Toutes les durées sont exprimées en "nombre de ticks" (jours de jeu).

**Avantages** : simple, déterministe, testable (injecter n'importe quelle valeur), cohérent avec le tick (le temps n'avance que quand le tick s'exécute), facile à sérialiser.  
**Inconvénients** : la correspondance avec le calendrier réel (saisons, mois) doit être calculée à partir du compteur + date de départ ; pas de notion de "date calendaire" native.

### Option C — Horloge virtuelle avec ratio configurable

Une entité `GameClock` stocke `current_game_date` (date calendaire de jeu, ex. `2024-03-15`), `game_start_real_date` et `tick_count`. Le ratio est une constante de configuration. Le temps avance uniquement lors du tick (incrémentation de `current_game_date` de 1 jour).

**Avantages** : date calendaire lisible directement (affichage UI, calcul de saison, prévisions météo), cohérent avec le tick (avance uniquement sur tick), ratio modifiable en config sans migration, testable (injecter une date arbitraire), compatible avec le rattrapage multi-jours (incrémenter de N jours si N ticks manqués).  
**Inconvénients** : légèrement plus complexe que le compteur pur, mais la complexité est marginale.

## Décision

**Option retenue : C — Horloge virtuelle avec ratio configurable**

Justification : l'Option C est la seule qui combine une date calendaire lisible (nécessaire pour les saisons, les prévisions météo J+1/J+3/J+7, et l'affichage UI) avec un avancement strictement couplé au tick. L'Option A est écartée car elle crée une incohérence fondamentale entre le temps affiché et l'état simulé. L'Option B est fonctionnelle mais perd la sémantique calendaire, compliquant les calculs de saison et les durées de cultures exprimées en mois.

Implémentation retenue :
- Table `GameClock` (singleton, `id = 1`) : `current_game_date DATE`, `last_tick_at TIMESTAMP`, `tick_count INT`, `tick_duration_ms INT`.
- Chaque ferme stocke `last_ticked_game_date DATE` pour le rattrapage à la connexion.
- Le ratio `GAME_DAYS_PER_REAL_DAY = 6` (1 jour réel ≈ 6 jours de jeu, soit 1 mois = 5j réels) est une constante d'environnement, non stockée en base.
- Le tick incrémente `current_game_date` de 1 jour et `tick_count` de 1.
- Pour le rattrapage : si `last_ticked_game_date < current_game_date`, appliquer N ticks séquentiels sur la ferme.

## Conséquences

- Toutes les durées de cultures et cycles d'élevage sont stockées en **jours de jeu** (entiers), pas en secondes réelles.
- Les prévisions météo sont indexées sur `game_date` (date calendaire de jeu), ce qui permet un affichage J+1/J+3/J+7 naturel.
- La saison compétitive (15 jours réels = 90 jours de jeu) est calculable directement depuis `current_game_date`.
- Les tests du module `tick` injectent une `GameClock` avec une date arbitraire — pas de dépendance à `Date.now()`.
- Si le ratio doit changer (décision de design), seule la constante d'environnement est modifiée ; les dates stockées restent valides.
- La mise en pause du jeu (maintenance) est triviale : ne pas exécuter le tick.

## Références

- `Docs/external-refinement/agriva_decisions_log_compact.md` — Temporalité (1 mois = 5j réels, 1 saison = 15j, 1 année = 60j)
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §1.3 (entité `GameClock`), §1.4 (séquence tick)
- `Docs/specs/2026-05-07-tech-liveops-v1.md` §2 (tick quotidien, déclenchement)
- ADR-002 (modèle de tick hybride — rattrapage à la connexion)
