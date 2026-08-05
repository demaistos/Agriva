# Sprint 02 — Création Ferme + Géographie + Temps — End to End

> Objectif : Le joueur choisit sa localisation, crée sa ferme, voit le temps avancer.

---

## Flows couverts

Aucun flow du registry (les flows commencent au sprint 03). Ce sprint pose la géographie et le temps.

---

## Backend

### Routes API

| Méthode | Route | Body | Réponse | Sécurité |
|---------|-------|------|---------|----------|
| GET | /api/geography/regions | — | 200 `[{ id, name, code }]` | Auth |
| GET | /api/geography/departments/:regionId | — | 200 `[{ id, name, code }]` | Auth |
| GET | /api/geography/prefectures/:deptId | — | 200 `[{ id, name, lat, lng }]` | Auth |
| POST | /api/farms | `{ prefecture_id, kit: 'eleveur'\|'cultivateur'\|'polyvalent' }` | 201 `{ farm }` | Auth, idempotency |
| GET | /api/server/time | — | 200 `{ day, month, season, year }` | Auth |
| GET | /api/player/me | — | 200 enrichi avec farm + kit | Auth |

### Kit de démarrage

À la création de la ferme, le joueur choisit 1 kit parmi 3 (voir `08_EQUILIBRAGE_ECONOMIQUE.md`) :
- 🌾 Cultivateur : matériel cultures + hangar + silo + entrepôt
- 🐄 Éleveur : matériel élevage + stabulation + silo + fosse + cuve eau + salle traite + 4 vaches + 1 taureau
- ⚖️ Polyvalent : matériel mixte réduit + hangar + silo

Le kit crée automatiquement les véhicules (usés 40-60%), bâtiments (niv.1) et animaux dans la DB.

### Worker — Tick journalier

- Cron 00:00 Europe/Paris
- `SELECT id FROM server WHERE is_active FOR UPDATE` → lock
- Séquence : voir GAME_SYSTEMS §1.4 (24 étapes)
- Reset HT à 40 pour chaque joueur
- Avance date : jour+1, check changement mois/saison/année

### DB — Migrations

```sql
-- Tables : farm, region, department, prefecture, distance_matrix, server_config
-- Seed : ~340 préfectures françaises (scripts/seed/)
-- Voir DATA_MODEL §1.3-§1.5
```

---

## Frontend

### Pages

| Route | Composant | Description |
|-------|-----------|-------------|
| /setup-farm | SetupFarmWizard | Wizard 3 étapes : région → département → préfecture + choix kit |
| /dashboard | DashboardPage | Enrichi avec localisation + date + solde + HT |

### Wizard création ferme

1. Étape 1 : Carte France → sélection région
2. Étape 2 : Liste départements → sélection
3. Étape 3 : Liste préfectures → sélection + choix kit (3 cartes avec détail matériel)
4. Confirmation → POST /api/farms → redirect /dashboard

### Header enrichi

- Date Cultivia : « 7 Avril — Mois 4 (Printemps) Année 1 »
- Solde : 100 000 € (animé)
- HT : 40/40 (barre de progression)
- Localisation : « Clermont-Ferrand (63) »

---

## Testable UI

1. Le joueur connecté arrive sur `/setup-farm`
2. Il sélectionne Auvergne-Rhône-Alpes → Puy-de-Dôme → Clermont-Ferrand
3. Il choisit le kit 🐄 Éleveur
4. Il confirme → toast « Ferme créée à Clermont-Ferrand ! Kit Éleveur activé. »
5. Il voit le dashboard avec date, solde 100k€, HT 40/40
6. Le lendemain : le jour avance, HT reset à 40
7. Après 7 jours : le mois change (Avril → Mai)

---

## Tests

- GIVEN player without farm WHEN POST /api/farms THEN 201 + farm + kit vehicles + kit buildings
- GIVEN player with farm WHEN POST /api/farms THEN 409 ferme déjà créée
- GIVEN kit=eleveur THEN 4 vaches + 1 taureau + stabulation + salle traite créés
- GIVEN kit=cultivateur THEN moissonneuse + charrue + semoir créés, 0 animaux
- GIVEN same idempotency key ×2 THEN no double farm
- GIVEN midnight tick WHEN dailyTick THEN day+1, HT reset, season check
