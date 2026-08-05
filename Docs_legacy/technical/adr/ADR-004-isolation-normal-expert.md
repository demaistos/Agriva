# ADR-004 — Isolation Normal/Expert dans le modèle de données

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Agriva propose deux modes de lecture de la simulation : Normal (fertilité + humidité, météo simplifiée, rendements stables) et Expert (NPK + MO + pH + compaction + historique cultural, météo fine, variance + plafond de maîtrise). Les deux modes partagent le même moteur de simulation et les mêmes données sous-jacentes — seule la granularité exposée diffère. La bascule est possible par système (pas globale), avec un profil global = preset. Il faut choisir comment modéliser cette dualité sans dupliquer la logique ni complexifier inutilement le schéma.

## Options considérées

### Option A — Colonnes séparées par mode dans la même table

La table `Parcel` contient toutes les colonnes : `fertility INT`, `humidity INT` (Normal) + `nitrogen INT`, `phosphorus INT`, `potassium INT`, `organic_matter FLOAT`, `ph FLOAT`, `compaction INT` (Expert). Les colonnes Expert sont `NULL` si le joueur est en mode Normal.

**Avantages** : une seule table, pas de JOIN supplémentaire, migration simple, lisible.  
**Inconvénients** : colonnes nullable en production (légère pollution du schéma), risque de confusion si une colonne Expert est lue par erreur en mode Normal.

### Option B — Vues SQL par mode

Deux vues PostgreSQL : `parcel_normal_view` et `parcel_expert_view`, chacune exposant les colonnes pertinentes depuis la table `Parcel` sous-jacente.

**Avantages** : séparation claire au niveau SQL, l'API peut requêter la vue correspondant au mode du joueur.  
**Inconvénients** : les vues ne simplifient pas la logique applicative (le calcul de rendement doit quand même brancher sur le mode), overhead de maintenance (2 vues à synchroniser avec le schéma), pas de gain réel pour un petit studio.

### Option C — Calcul à la volée côté API (flag en BDD, logique conditionnelle centralisée)

La table `Parcel` contient toutes les colonnes (comme Option A). Le flag `mode` est stocké par joueur (`Player.mode_global`) et par système (ex. `Farm.mode_crops`, `Farm.mode_livestock`). La logique conditionnelle est centralisée dans les modules `crops` et `farm` — jamais dans les routes API. L'API retourne toujours la représentation adaptée au mode courant du joueur.

**Avantages** : une seule source de vérité en base, logique de mode encapsulée dans les modules métier (testable unitairement), bascule de mode sans migration, cohérent avec la décision "bascule par système" du decisions log.  
**Inconvénients** : la logique conditionnelle doit être disciplinée (risque de dispersion si mal encadrée) — mitigé par la règle "logique de mode uniquement dans `crops` et `farm`".

### Option D — Deux codepaths séparés (modules Normal et Expert distincts)

Deux implémentations distinctes du calcul de rendement : `crops-normal.ts` et `crops-expert.ts`, sélectionnées à l'exécution selon le mode.

**Avantages** : séparation maximale, pas de `if (mode === 'expert')` dans le code.  
**Inconvénients** : duplication de logique (les deux modes partagent ~70% du calcul), maintenance double, risque de divergence silencieuse entre les deux codepaths.

## Décision

**Option retenue : C — Flag en BDD + logique conditionnelle centralisée dans les modules métier**

Justification : l'Option C est la plus cohérente avec l'architecture monolithe modulaire retenue et la décision "bascule par système" du decisions log. Elle évite la duplication de l'Option D et l'overhead de maintenance des vues de l'Option B. La discipline de centralisation (logique de mode uniquement dans `crops` et `farm`, jamais dans l'API) est imposée par convention de code et vérifiée en revue. L'Option A (colonnes nullable) est retenue pour le schéma — c'est la même chose que C au niveau BDD, la différence est dans l'organisation du code applicatif.

Règles d'implémentation :
- `Player.mode_global` : `enum('normal', 'expert')` — preset global.
- Par système : `Farm.mode_crops`, `Farm.mode_livestock`, `Farm.mode_economy` — chacun `enum('normal', 'expert')`, initialisé depuis `mode_global`.
- Les colonnes Expert de `Parcel` sont `NULL` pour les joueurs en mode Normal ; elles sont initialisées avec des valeurs par défaut à la bascule vers Expert.
- La fonction `calculateYield(parcel, mode)` dans le module `crops` est le seul point d'entrée pour le calcul de rendement — elle branche sur `mode` en interne.
- L'API ne contient aucune logique de mode : elle appelle le module et retourne le résultat.

## Conséquences

- Le schéma `Parcel` contient les colonnes Normal et Expert (colonnes Expert nullable).
- La bascule Normal→Expert initialise les colonnes Expert depuis les valeurs Normal (conversion fertilité→NPK approximative) sans migration de schéma.
- Les tests unitaires du module `crops` couvrent les deux modes indépendamment.
- L'UI reçoit toujours une représentation adaptée au mode — pas de filtrage côté client.
- Si un nouveau système est ajouté (V2+), il suit le même pattern : flag par système + logique centralisée dans son module.

## Références

- `Docs/external-refinement/agriva_decisions_log_compact.md` — Normal/Expert (bascule par système, profil global = preset), Sols normal/expert
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §1.3 (entité `Parcel`, colonnes Normal/Expert), §3 Risques — "Complexité du mode Normal/Expert mal isolée"
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §2 Sprint 2 (mode Normal/Expert, flag en BDD)
- `Docs/specs/2026-05-07-farming-systems-v1.md`
