# ADR-001 — Stratégie de migration de base de données

**Date** : 2026-05-07  
**Statut** : Accepté
**Environnement** : Dev local Docker Compose  
**Décideurs** : Lead, Tech

## Contexte

Le schéma PostgreSQL d'Agriva va évoluer fréquemment pendant les 6 sprints de développement (ajout de colonnes Normal/Expert, entités élevage, foncier, etc.). Il faut un outil de migration fiable, versionné, et compatible avec le stack Node.js + TypeScript retenu. La décision doit être prise avant le Sprint 1 (fondations).

## Options considérées

### Option A — Migrations manuelles SQL

Fichiers `.sql` numérotés, appliqués à la main ou via un script shell.

**Avantages** : aucune dépendance, contrôle total du SQL généré, lisible par tout DBA.  
**Inconvénients** : pas de suivi d'état automatique, risque d'oubli ou de désynchronisation entre environnements, pas de rollback structuré, friction élevée en développement rapide.

### Option B — ORM avec migrations auto (Prisma Migrate (`docker compose up` lance PostgreSQL + `prisma migrate dev` automatiquement))

Prisma génère les migrations à partir du schéma déclaratif `.prisma`, les applique et les versionne.

**Avantages** : migrations générées automatiquement depuis le schéma, intégration TypeScript native (types générés), rollback via `prisma migrate reset`, workflow rapide en développement.  
**Inconvénients** : couplage fort à Prisma (migration vers un autre ORM coûteuse), SQL généré parfois sous-optimal pour des cas complexes, overhead d'apprentissage si l'équipe ne connaît pas Prisma.

### Option C — Outil dédié (Flyway / Liquibase)

Outil indépendant de l'ORM, gère les migrations SQL versionnées avec suivi d'état en base.

**Avantages** : indépendant du langage applicatif, robuste en production, supporte les rollbacks explicites, standard en environnements Java/entreprise.  
**Inconvénients** : Flyway/Liquibase sont des outils JVM — friction d'intégration dans un projet Node.js, configuration supplémentaire (Docker ou binaire séparé), surcharge injustifiée pour un petit studio.

### Option D — `node-pg-migrate`

Bibliothèque Node.js légère : migrations en JS/TS ou SQL, suivi d'état en base (`pgmigrations`), CLI simple.

**Avantages** : natif Node.js (même stack que le projet), migrations en TypeScript possible, pas de dépendance JVM, rollback par migration, léger et bien maintenu.  
**Inconvénients** : pas de génération automatique depuis un schéma déclaratif (migrations écrites à la main), moins de magie que Prisma.

## Décision

**Option retenue : D — `node-pg-migrate`**

Justification : le projet est Node.js + TypeScript ; `node-pg-migrate` s'intègre sans friction dans le monorepo. Les migrations sont écrites explicitement en TypeScript, ce qui garantit un contrôle total du SQL tout en restant versionnées et traçables. Prisma Migrate (`docker compose up` lance PostgreSQL + `prisma migrate dev` automatiquement) (Option B) a été écarté car le couplage ORM complet n'est pas souhaité — les requêtes complexes du tick (batch de 100 fermes, calculs de rendement) bénéficient d'un accès SQL direct via `pg` ou `kysely`. Flyway (Option C) est écarté pour la friction JVM dans un projet Node.js.

Règle associée (issue du plan d'implémentation) : **aucune modification de schéma sans migration versionnée**. Toute PR modifiant le schéma doit inclure le fichier de migration correspondant.

## Conséquences

- Le dossier `migrations/` est créé dès le Sprint 1 avec le schéma initial complet.
- La CI vérifie que les migrations sont à jour avant tout déploiement.
- Les rollbacks sont possibles migration par migration (`migrate down`).
- L'équipe écrit les migrations manuellement — pas de génération automatique depuis un modèle déclaratif.
- Si Prisma est introduit plus tard (V2+) pour la génération de types, il coexistera avec `node-pg-migrate` (Prisma en mode `prisma db pull` uniquement, sans `migrate`).

## Références

- `Docs/plans/2026-05-07-plan-implementation-v1.md` §1.1 (stack PostgreSQL), §2 Sprint 1 (migrations Sprint 1)
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §3 Risques — "Dérive du modèle de données entre sprints"
- `Docs/plans/2026-05-07-plan-implementation-v1.md` §5 ADR-001
