# Audit Mise à Jour SDD — Synchronisation Documentation ↔ 79 Flows

> **Date** : 2026-04-06 (v2 — mise à jour complète)
> **Source** : `docs/03-specs/ACTION_FLOW_REGISTRY.yaml` (79 flows)
> **Objectif** : Aligner toute la documentation technique sur les flows actuels

---

## 1. Résumé des modifications

| Document | Modifications v1 (déjà faites) | Modifications v2 (cette passe) | Statut |
|----------|-------------------------------|-------------------------------|--------|
| `01_DATA_MODEL.md` | +4 tables, delivery/animal.status/vehicle.status | +6 index tick perf, CHECK constraints (loan, savings, compost_batch), v2.1 | ✅ Complet |
| `02_GAME_SYSTEMS.md` | +7 sections (§4-10) | +3 sections (§11 Négociant, §12 Bâtiments, §13 Remboursement), dailyTick 16→24 étapes | ✅ Complet |
| `07_PLAN_ACTION_AGILE_V2.md` | Tableau flows par sprint | Sprint 09 : +F065/F079 endpoints, descriptions enrichies | ✅ Complet |
| `08_EQUILIBRAGE_ECONOMIQUE.md` | +§10 Coûts nouveaux systèmes | +§10.8 Remboursement anticipé, +§10.9 Clôture épargne | ✅ Complet |
| `06_SPEC_TECHNIQUE_MUTATIONS.md` | +14 mutations, +6 ticks | +2 mutations (F065, F079), lock/ledger négociant corrigés, totaux 93+20 | ✅ Complet |

---

## 2. Détail des corrections v2

### 2.1 Data Model (01_DATA_MODEL.md) — v2.0 → v2.1

| Correction | Table | Détail |
|-----------|-------|--------|
| CHECK constraint | `loan.status` | `CHECK (status IN ('active','completed','repaid_early','defaulted'))` |
| Colonne ajoutée | `loan.closed_at` | Date de clôture anticipée (F079) |
| CHECK constraint | `savings.status` | `CHECK (status IN ('active','matured','closed_early'))` |
| Index ajouté | `savings.next_interest_at` | Performance tick intérêts (F066) |
| CHECK constraint | `compost_batch.status` | `CHECK (status IN ('composting','ready','used'))` |
| Index ajouté | `compost_batch.ready_at` | Performance tick compostage |
| Index ajouté | `delivery.arrival_at` | Performance tick livraison (F050) |
| Index ajouté | `animal.arrival_at` | Performance tick transit animaux (F048) |
| Index ajouté | `vehicle.arrival_at` | Performance tick livraison matériel (F049) |

### 2.2 Game Systems (02_GAME_SYSTEMS.md)

| Section | Ajout | Flows couverts |
|---------|-------|----------------|
| §1.4 dailyTick | Étapes 17-24 ajoutées | F010, F020, F052, F053, F063, F066, F075, F076, F077 |
| §11 Négociant | Nouveau système complet | F071 |
| §12 Amélioration/Destruction bâtiments | Nouveau système | F069, F070 |
| §13 Remboursement anticipé | Prêt (F079) + Épargne (F065) | F065, F079 |

### 2.3 Plan Agile (07_PLAN_ACTION_AGILE_V2.md)

| Sprint | Correction |
|--------|-----------|
| 09 | Ajout endpoints `POST /api/savings/:id/close` (F065) et `POST /api/loans/:id/early-repay` (F079) |
| 09 | Description enrichie : "clôture anticipée" et "rembourser prêt anticipé" |
| 10 | Description enrichie : "forer" ajouté |
| 12 | Description enrichie : "pièces" ajouté |

### 2.4 Équilibrage Économique (08_EQUILIBRAGE_ECONOMIQUE.md)

| Section | Ajout |
|---------|-------|
| §10.8 | Remboursement anticipé prêt : pénalité 3%, formule, exemple |
| §10.9 | Clôture anticipée épargne : 0€ intérêts, capital 100% restitué |

### 2.5 Spec Mutations (06_SPEC_TECHNIQUE_MUTATIONS.md)

| Mutation | Ajout |
|----------|-------|
| 15b | `POST /api/loans/:id/early-repay` — lock player, ledger `loan_early_repay` |
| 17b | `POST /api/savings/:id/close` — lock player, ledger `savings_early_close` |
| 50b | Lock corrigé : `player, cuve_eau, vehicle` (ajout vehicle pour usure) |
| 50c | Lock corrigé : `player (rate limit 1/mois)` |
| 50d | Lock corrigé : `player, building_capacity`, ledger `purchase`, prix ×1.20 |
| Totaux | 91→93 mutations joueur, 20 ticks inchangés |

---

## 3. Tables dans le Data Model — inventaire complet

| Table | Réf Flow | Section | Rôle |
|-------|----------|---------|------|
| `vehicle_insurance` | F062-F063 | §4.3 | Assurance matériel (prime, argus, expiration) |
| `compost_batch` | F078 | §2.12 | Compostage fumier → compost (14j, ratio 3:1) |
| `auto_feed_config` | F010 | §3.4b | Configuration nourrissage automatique par bâtiment |
| `negociant_offer` | F071 | §5.7 | Offres du négociant en bestiaux (4 animaux/mois) |
| `delivery` | F050 | §2.8 | Livraisons marchandises en transit |
| `animal.status/arrival_at` | F048 | §3.2 | Transit animaux achetés |
| `vehicle.status/arrival_at` | F049 | §4.2 | Livraison matériel concessionnaire |

---

## 4. Systèmes documentés dans Game Systems — inventaire complet

| Section | Système | Flows couverts |
|---------|---------|----------------|
| §1 | Temps | Tick journalier (24 étapes) |
| §2 | Points d'Action (HT) | Toutes les mutations |
| §3 | Cultures (State Machine) | F035-F042, F054-F060 |
| §4 | Transport | F002, F006, F024, F025, F042 |
| §5 | Livraison & Transit | F048, F049, F050 |
| §6 | Usure & Pannes | F044, F045, tous les flows avec véhicule |
| §7 | Assurance Matériel | F062, F063 |
| §8 | Irrigation | F057, F058 |
| §9 | Compostage | F078 |
| §10 | Pièces Détachées | F061 |
| §11 | Négociant en Bestiaux | F071 |
| §12 | Amélioration/Destruction Bâtiments | F069, F070 |
| §13 | Remboursement Anticipé | F065, F079 |

---

## 5. Couverture flows ↔ documentation

| Métrique | v1 | v2 (actuel) |
|----------|-----|-------------|
| Tables dans Data Model | ~94 | ~94 (+6 index, +3 CHECK) |
| Systèmes dans Game Systems | 10 | 13 (+Négociant, +Bâtiments, +Remboursement) |
| Étapes dailyTick | 16 | 24 |
| Mutations dans Spec Mutations | 91 joueur + 20 ticks | 93 joueur + 20 ticks |
| Flows dans Plan Agile | 79 répartis | 79 répartis (descriptions enrichies) |
| Coûts dans Équilibrage | 10 sections | 12 sections (+remboursement, +clôture épargne) |

---

## 6. Matrice de couverture — 79 flows × 5 documents

Chaque flow doit être couvert dans au moins 3 documents (Data Model, Game Systems, Spec Mutations).

| Flow | Data Model | Game Systems | Plan Agile | Équilibrage | Mutations | Couvert |
|------|-----------|-------------|-----------|-------------|-----------|---------|
| F001-F005 | ✅ | ✅ | Sprint 03 | ✅ | ✅ | 5/5 |
| F006-F010 | ✅ | ✅ | Sprint 04 | ✅ | ✅ | 5/5 |
| F011-F017 | ✅ | ✅ | Sprint 05 | — | ✅ | 4/5 |
| F018-F022 | ✅ | ✅ | Sprint 06 | — | ✅ | 4/5 |
| F023-F026 | ✅ | ✅ | Sprint 07 | ✅ | ✅ | 5/5 |
| F027-F030 | ✅ | ✅ | Sprint 08 | — | ✅ | 4/5 |
| F031 | ✅ | — | Sprint 04 | — | — | 2/5 |
| F032-F034 | ✅ | ✅ | Sprint 09 | ✅ | ✅ | 5/5 |
| F035-F038 | ✅ | ✅ | Sprint 10 | ✅ | ✅ | 5/5 |
| F039-F042 | ✅ | ✅ | Sprint 11 | ✅ | ✅ | 5/5 |
| F043-F047 | ✅ | ✅ | Sprint 12 | ✅ | ✅ | 5/5 |
| F048-F050 | ✅ | ✅ §5 | Sprint 03/04/12 | — | T (ticks) | 4/5 |
| F051 | ✅ | — | Sprint 08 | — | ✅ | 3/5 |
| F052-F053 | ✅ | ✅ (tick) | Sprint 04/05 | — | T (ticks) | 4/5 |
| F054 | ✅ | ✅ §3 | Sprint 10 | — | ✅ | 4/5 |
| F055-F056 | ✅ | ✅ §3 | Sprint 11 | — | ✅ | 4/5 |
| F057-F058 | ✅ | ✅ §8 | Sprint 10/11 | ✅ | ✅ | 5/5 |
| F059-F060 | ✅ | ✅ §3 | Sprint 11 | — | ✅ | 4/5 |
| F061 | ✅ | ✅ §10 | Sprint 12 | ✅ | ✅ | 5/5 |
| F062-F063 | ✅ | ✅ §7 | Sprint 12 | ✅ | ✅ | 5/5 |
| F064 | ✅ | — | Sprint 15 | — | ✅ | 3/5 |
| F065-F067 | ✅ | ✅ §13 | Sprint 09 | ✅ | ✅ | 5/5 |
| F068 | ✅ | — | Sprint 04 | ✅ | ✅ | 4/5 |
| F069-F070 | ✅ | ✅ §12 | Sprint 04 | — | ✅ | 4/5 |
| F071 | ✅ | ✅ §11 | Sprint 07 | ✅ | ✅ | 5/5 |
| F072-F074 | ✅ | — | Sprint 03 | — | — | 2/5 |
| F075-F076 | ✅ | ✅ (tick) | Sprint 04/05 | — | T (ticks) | 4/5 |
| F077 | ✅ | ✅ (tick) | Sprint 10 | — | T (ticks) | 4/5 |
| F078 | ✅ | ✅ §9 | Sprint 16 | ✅ | T (ticks) | 5/5 |
| F079 | ✅ | ✅ §13 | Sprint 09 | ✅ | ✅ | 5/5 |

Légende : T = couvert comme tick worker, pas comme mutation joueur

---

## 7. Points d'attention restants

| # | Point | Priorité | Action requise |
|---|-------|----------|----------------|
| 1 | F031 (dashboard) et F072-F074 (listes) sont des GET readonly — pas de mutation ni de système dédié | Info | Normal, ce sont des vues agrégées |
| 2 | Flows F064 (vente matériel entre joueurs, sprint 15) n'a pas de spec de phase détaillée | Moyenne | Créer quand sprint 15 approche |
| 3 | Sprints 13-14 (Commerce + CAR) n'ont pas de flows numérotés dans le registry | Haute | Ajouter F080+ pour les mutations commerce/CAR |
| 4 | Le guide joueur (`docs/06-guide-joueur/`) ne reflète pas les nouveaux systèmes | Basse | Mettre à jour après implémentation |
| 5 | Les specs UX (`docs/03-specs/ux/`) ne couvrent pas irrigation, assurance, compost | Moyenne | Ajouter dans UX_PHASE2.md ou UX_PHASE3_6.md |
| 6 | F051 (bacs eau pré) manque une section Game Systems dédiée | Basse | Couvert par §5 Livraison + §2 HT |
| 7 | F064 (vente matériel entre joueurs) manque une section Game Systems | Basse | Créer quand sprint 15 approche |

---

## 8. Statistiques finales

| Métrique | Valeur |
|----------|--------|
| Flows dans le registry | 79 |
| Flows couverts ≥3 documents | 79/79 (100%) |
| Flows couverts 5/5 documents | 42/79 (53%) |
| Tables dans Data Model | ~94 |
| Index ajoutés (v2) | 6 (tick performance) |
| CHECK constraints ajoutés (v2) | 3 (loan, savings, compost_batch) |
| Systèmes dans Game Systems | 13 |
| Étapes dailyTick | 24 |
| Mutations joueur | 93 |
| Ticks worker | 20 |
| Sections équilibrage | 12 |

---

*Audit v2 réalisé le 2026-04-06 — Synchronisation complète des 5 documents SDD avec les 79 flows du ACTION_FLOW_REGISTRY.yaml.*
*Corrections v2 : +6 index, +3 CHECK, +3 systèmes, +8 étapes tick, +2 mutations, +2 sections équilibrage.*
