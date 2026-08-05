# ADR Agriva V1 — Index

Les Architecture Decision Records (ADR) documentent les décisions techniques structurantes d'Agriva V1. Chaque ADR est immuable une fois accepté ; une révision crée un nouvel ADR qui supersède le précédent.

## Tableau récapitulatif

| # | Fichier | Titre | Statut | Décision retenue |
|---|---------|-------|--------|-----------------|
| 001 | [ADR-001](ADR-001-migration-base-de-donnees.md) | Stratégie de migration BDD | Accepté | `node-pg-migrate` — migrations SQL manuelles versionnées |
| 002 | [ADR-002](ADR-002-modele-tick-serveur.md) | Modèle de tick serveur | Accepté | Tick hybride : cron fixe + rattrapage à la connexion, batch 100 fermes |
| 003 | [ADR-003](ADR-003-gestion-temps-ingame.md) | Gestion du temps in-game | Accepté | Horloge virtuelle `GameClock` avec date calendaire, ratio configurable en env var |
| 004 | [ADR-004](ADR-004-isolation-normal-expert.md) | Isolation Normal / Expert | Accepté | Flag en BDD par système, logique conditionnelle centralisée dans `crops`/`farm` |
| 005 | [ADR-005](ADR-005-algorithme-prix-bot.md) | Algorithme de prix bot | Accepté | Prix fixes en config + spread 15-25% + rendements décroissants, ajustement admin hebdomadaire |
| 006 | [ADR-006](ADR-006-capacite-stockage.md) | Capacité de stockage | Accepté | Capacité par type (sec/froid/vrac/bétail) avec limites dures portées par le bâtiment |
| 007 | [ADR-007](ADR-007-strategie-test.md) | Stratégie de test | Accepté | Vitest (unit ≥ 70-80%) + Supertest/pg-mem (intégration) ; E2E Playwright reporté à la bêta |
| 008 | [ADR-008](ADR-008-format-logs-telemetrie.md) | Format des logs / télémétrie | Accepté | NDWSON via `pino` + rotation quotidienne, rétention 90 j, compatible Loki/Grafana V2+ |
| 009 | [ADR-009](ADR-009-authentification-abonnement.md) | Authentification & abonnement | Accepté | WWT stateless (15 min / 30 j) + webhook Stripe, statut abonnement en Redis TTL 5 min |
| 010 | [ADR-010](ADR-010-rendu-carte-territoire.md) | Rendu carte territoire | Accepté | SVG statique topojson (< 80 Ko), composant `TerritoryMap`, fallback liste mobile < 480 px |

---

## Guide de lecture — utiliser les ADR pendant le développement

**Avant de coder une fonctionnalité** : identifiez l'ADR concerné dans le tableau ci-dessus et lisez la section *Décision* et *Conséquences*. Ne réimplémentez pas une alternative rejetée sans ouvrir un nouvel ADR.

**Pendant une code review** : si une PR contredit un ADR accepté, bloquez la PR et citez l'ADR. La discussion se tient dans un nouvel ADR, pas dans la PR.

**Quand un ADR est partiellement obsolète** : créez un ADR de révision (ex. ADR-011 supersède ADR-005 §Prix). L'ancien ADR reste lisible avec la mention `Supersédé par ADR-011`.

**Invariants à faire respecter en CI** (issus des ADR) :
- ADR-005 : test anti-arbitrage bot bloquant dès Sprint 3
- ADR-007 : couverture unitaire ≥ 70% sur `simulation/`, `economy/`, `crops/`

---

## Processus pour créer un nouvel ADR

1. **Copier le template** depuis `ADR-000-template.md` (ou utiliser la structure ci-dessous).
2. **Nommer le fichier** : `ADR-NNN-titre-court-en-kebab-case.md` avec le prochain numéro disponible.
3. **Remplir les sections** : Contexte → Options envisagées → Décision → Conséquences.
4. **Statut initial** : `Proposé`. Passer à `Accepté` après validation en réunion d'équipe ou async (commentaire PR).
5. **Mettre à jour ce README** : ajouter la ligne dans le tableau récapitulatif.
6. **Référencer dans le code** si pertinent : commentaire `// cf. ADR-NNN` au point d'entrée de la logique concernée.

### Structure minimale d'un ADR

```markdown
# ADR-NNN — Titre

- **Date** : YYYY-MM-DD
- **Statut** : Proposé | Accepté | Supersédé par ADR-XXX

## Contexte
Pourquoi cette décision est nécessaire.

## Options envisagées
- Option A …
- Option B …

## Décision
Option retenue et justification.

## Conséquences
Ce qui change, ce qui est exclu, les risques résiduels.
```
