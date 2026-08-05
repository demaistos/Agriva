# Sprint 07 — Traite + Productions + Vente — Spec End-to-End

> Prérequis : Sprint 06. Le joueur a des vaches en lactation (après naissance).
> Ce sprint ajoute : traite, productions (lait/œufs/laine), vente au Marché Central, abattoir.

---

## Tables SQL nouvelles

```sql
-- production_log (historique production quotidienne)
-- market_listing (annonces vente — simplifié, vente directe coop pour l'instant)
-- Modif : animal (last_milked_at), building (type milk_tank → stock lait)
```

---

## Flux 1 : Construire salle de traite + cuve à lait

### Prérequis

Le joueur doit construire 2 bâtiments avant de pouvoir traire :
1. Salle de traite (`milking_parlor`) — 5 000€, 20 places
2. Cuve à lait (`milk_tank`) — 2 000€, 500L

Même flux que Sprint 03 Flux 1 (construire bâtiment). Ajout de ces 2 types dans le seed `building_type`.

---

## Flux 2 : Traire les vaches

### Déclencheur

Sidebar → "Mes productions" → "Traite" ou page `/animals/milking`.

### Écran

```
┌─────────────────────────────────────────────────────────────────┐
│ 🥛 Traite [Vaches en lactation: 1]                              │
├─────────────────────────────────────────────────────────────────┤
│ Prérequis :                                                     │
│ Salle de traite : ✅ (20 places)                                │
│ Cuve à lait : ✅ (0 / 500 L) ░░░░░░░░░░░░░░░ 0%               │
├─────────────────────────────────────────────────────────────────┤
│ ☐ | Nom        | Race          | Prod. estimée | Qualité (QL)  │
│ ☑ | Marguerite | Prim'Holstein | 32.4 L        | ⭐⭐⭐⭐ (78) │
├─────────────────────────────────────────────────────────────────┤
│ Total estimé : 32.4 L                                           │
│ Cuve après traite : 32.4 / 500 L                                │
│ HT : 1.0                                                       │
│                                                                 │
│ [Traire sélection (1)]              [Traire toutes]             │
└─────────────────────────────────────────────────────────────────┘
```

**Calcul production par vache :**
```
base = breed.milk_per_day (ex: 30 L pour Prim'Holstein)
× health_factor (health/100, ex: 0.95)
× feed_quality_factor (1.0 si ★★★, 0.85 si ★★, 0.7 si ★)
× genetics_factor (1 + (genetics.milk - 50) / 200, ex: 1.205 pour indice 91)
= 30 × 0.95 × 0.85 × 1.205 = 29.2 L (arrondi affiché 32.4 avec d'autres facteurs)
```

**Qualité lait (QL) :**
```
ql = (genetics.milk_quality × 0.4) + (feed_quality × 0.3) + (health × 0.3)
```

**Bouton "Traire toutes" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Salle traite ✅ + cuve non pleine + HT >= 1.0 + vaches en lactation non traites |
| 🔘 Grisé "Construisez une salle de traite" | Pas de `milking_parlor` |
| 🔘 Grisé "Construisez une cuve à lait" | Pas de `milk_tank` |
| 🔘 Grisé "Cuve pleine ({X}/{Y}L) — vendez du lait" | `cuve.quantity >= cuve.capacity` |
| 🔘 Grisé "HT insuffisants (besoin 1.0)" | `ht < 1.0` |
| 🔘 Grisé "Aucune vache en lactation" | 0 vache `is_lactating=true` |
| 🔘 Grisé "Déjà traites aujourd'hui" | Toutes `last_milked_at >= today` |

### → API

```http
POST /api/animals/milk
Headers: X-Idempotency-Key: {uuid}
Body: { "animal_ids": ["{uuid}"] }
```

### → Backend (`MilkingService.milk`)

```
1. Idempotency
2. Charger animaux → vérifier ownership, is_lactating=true, last_milked_at < today
3. Charger salle de traite → vérifier existe
4. Charger cuve à lait → vérifier existe + place
5. Calculer production par animal (formule ci-dessus)
6. Calculer total → vérifier cuve.quantity + total <= cuve.capacity
   Si dépassement : ne traire que les N premières vaches qui rentrent dans la cuve
7. Calculer qualité moyenne pondérée
8. BEGIN
9. SELECT ht_today FROM player WHERE id=$1 FOR UPDATE
10. Vérifier ht >= 1.0
11. UPDATE player SET ht_today -= 1.0
12. UPDATE animal SET last_milked_at = NOW() WHERE id IN ($ids)
13. UPDATE inventory SET quantity = quantity + $total WHERE building_id=$cuve AND product='milk'
14. INSERT INTO production_log (farm_id, product, quantity, quality, date)
    VALUES ($1, 'milk', $total, $avg_ql, CURRENT_DATE)
15. COMMIT
16. WS: ht_update, animal_alert
17. Retourner 200 { milked_count, total_liters, avg_quality, cuve_after }
```

### ← Frontend

Toast "🥛 32.4L de lait collectés ! Qualité : ⭐⭐⭐⭐ (QL 78)". Cuve animée 0→32.4L. HT -1.0.

---

## Flux 3 : Voir les productions

### Page `/animals/productions`

```
┌─────────────────────────────────────────────────────────────────┐
│ Mes productions [🥛 Lait] [🥚 Œufs] [🧶 Laine]                │
├─────────────────────────────────────────────────────────────────┤
│ 🥛 LAIT                                                         │
│                                                                 │
│ Stock : 32.4 / 500 L  ██░░░░░░░░░░░░░ 6%                      │
│ Production aujourd'hui : 32.4 L                                 │
│ Qualité moyenne : ⭐⭐⭐⭐ (QL: 78)                             │
│ Cours Marché Central : 0.38 €/L (↑ +0.02 vs hier)              │
│ Valeur stock : 12.31 €                                          │
│                                                                 │
│ 📊 Production 30 derniers jours                                  │
│ [graphique barres quotidiennes]                                  │
│                                                                 │
│ Détail par vache :                                              │
│ Nom        | Race          | Prod/jour | QL   | Dernière traite │
│ Marguerite | Prim'Holstein | 32.4 L    | 78   | Aujourd'hui ✅  │
│                                                                 │
│ [Vendre au Marché Central]                                      │
└─────────────────────────────────────────────────────────────────┘
```

### → API

```http
GET /api/animals/productions
```

Retourne stock par produit, historique 30j, détail par animal, cours marché.

---

## Flux 4 : Vendre du lait au Marché Central

### Clic "Vendre au Marché Central" → Modale

```
┌─────────────────────────────────────────────┐
│ 🥛 Vendre du lait                            │
│                                              │
│ Stock disponible : 32.4 L                    │
│ Cours actuel : 0.38 €/L                      │
│                                              │
│ Quantité : [____32.4____] L  [Tout]          │
│ Total : 32.4 × 0.38 = 12.31 €               │
│ HT : 0.5                                    │
│                                              │
│ [Annuler]              [Vendre 12.31 €]      │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Stock > 0 + HT >= 0.5 + quantité > 0 |
| 🔘 Grisé "Stock vide" | Stock = 0 |
| 🔘 Grisé "HT insuffisants" | HT < 0.5 |
| 🔘 Grisé "Quantité invalide" | quantity <= 0 ou > stock |

### → API

```http
POST /api/market/sell
Headers: X-Idempotency-Key: {uuid}
Body: { "product": "milk", "quantity": 32.4 }
```

### → Backend

```
1. Idempotency
2. Charger cours : SELECT price FROM market_price WHERE product='milk'
3. Calculer total : 32.4 × 0.38 = 12.31
4. BEGIN
5. SELECT ht_today FROM player FOR UPDATE → vérifier >= 0.5
6. SELECT quantity FROM inventory WHERE product='milk' AND building_id=$cuve FOR UPDATE
7. Vérifier quantity >= 32.4
8. UPDATE player SET balance += 12.31, ht_today -= 0.5
9. UPDATE inventory SET quantity -= 32.4
10. INSERT INTO ledger ('sale', 'Vente 32.4L lait', +12.31)
11. COMMIT
12. WS: balance_update, ht_update
13. Retourner 200 { sold: 32.4, total: 12.31, balance_after }
```

### ← Frontend

Toast "🥛 32.4L vendus pour 12.31€". Solde +12.31. Cuve 32.4→0L.

---

## Flux 5 : Vendre un animal à l'abattoir

### Déclencheur

Fiche animal → "Vendre abattoir" ou action groupée DataTable.

### Écran — ConfirmModal

```
┌─────────────────────────────────────────────────────┐
│ 🔪 Vendre à l'abattoir                              │
│                                                      │
│ • Marguerite (Prim'Holstein, Vache) — 689 kg         │
│   Cours : 3.99 €/kg                                  │
│   Classification : A3-B4                              │
│   Estimé : 689 × 3.99 = 2 749.11 €                  │
│                                                      │
│ HT : 0.5                                            │
│                                                      │
│ ⚠️ IRRÉVERSIBLE. L'animal sera définitivement perdu. │
│ ⚠️ Marguerite est en lactation — vous perdrez la     │
│    production de lait.                                │
│                                                      │
│ [Annuler]                    [Confirmer vente 🔪]    │
└─────────────────────────────────────────────────────┘
```

**Warnings contextuels affichés :**
- Si gestante : "⚠️ Marguerite est gestante — le veau sera perdu"
- Si en lactation : "⚠️ Vous perdrez la production de lait"
- Si nommée : "⚠️ Marguerite a un nom — êtes-vous sûr ?"

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif (rouge danger) | HT >= 0.5 |
| 🔘 Grisé "HT insuffisants" | HT < 0.5 |

### → API

```http
POST /api/animals/slaughter
Headers: X-Idempotency-Key: {uuid}
Body: { "animal_ids": ["{uuid}"] }
```

### → Backend

```
1. Idempotency
2. Charger animaux → ownership, vivants
3. Pour chaque animal :
   Charger cours : market_price[species][life_stage]
   Calculer prix : weight × cours
4. BEGIN
5. SELECT ht_today FROM player FOR UPDATE
6. Vérifier ht >= 0.5 × nb_animaux
7. total_revenue = sum(prix par animal)
8. UPDATE player SET balance += total_revenue, ht_today -= 0.5 × nb
9. UPDATE animal SET life_stage = 'dead', died_at = NOW() WHERE id IN ($ids)
   (on garde l'animal en DB pour l'historique/généalogie, mais life_stage='dead')
10. UPDATE building_animal_capacity SET animal_count -= 1 WHERE building_id IN (...)
11. INSERT INTO ledger ('sale', 'Vente abattoir Marguerite (689kg)', +2749.11)
12. INSERT INTO slaughter_log (animal_id, weight, price_kg, total)
13. COMMIT
14. WS: balance_update, ht_update, animal_alert
15. Retourner 200 { sold_count, total_revenue }
```

### ← Frontend

Toast "🔪 Marguerite vendue pour 2 749.11€". Solde +2749.11. Animal disparaît de la DataTable (fade-out). Compteur toolbar -1.

---

## Flux 6 : Consulter les cours du marché

### Page `/market/prices`

```
┌─────────────────────────────────────────────────────────────────┐
│ 📊 Cours du Marché Central                                      │
│ [Animaux] [Marchandises]                                         │
├─────────────────────────────────────────────────────────────────┤
│ BOVINS                                                           │
│ Stade      | Cours (€/kg) | Hier    | Variation | Tendance 7j   │
│ Veau ♂     | 4.10         | 4.15    | ↓ -0.05   | 📉            │
│ Veau ♀     | 4.25         | 4.23    | ↑ +0.02   | 📈            │
│ Génisse    | 4.00         | 4.00    | = 0.00    | ➡️            │
│ Taurillon  | 3.30         | 3.30    | = 0.00    | ➡️            │
│ Vache      | 3.99         | 3.98    | ↑ +0.01   | 📈            │
│ Taureau    | 3.60         | 4.50    | ↓ -0.90   | 📉            │
├─────────────────────────────────────────────────────────────────┤
│ PRODUITS                                                         │
│ Produit    | Cours        | Hier    | Variation                  │
│ Lait       | 0.38 €/L     | 0.36    | ↑ +0.02                   │
│ Foin       | 80 €/t       | 78      | ↑ +2                      │
│ Paille     | 60 €/t       | 63      | ↓ -3                      │
└─────────────────────────────────────────────────────────────────┘
```

### → API

```http
GET /api/market/prices
```

Lecture seule, 0 HT. Données cachées Redis 1h.

---

## Dépendances techniques Sprint 07

```
Sprint 06 (reproduction, naissances)
  └→ Sprint 07 (traite, productions, vente)
       ├── Tables : production_log
       ├── Seed : building_type (milking_parlor, milk_tank), market_price (lait, produits)
       ├── Modif : animal (last_milked_at)
       ├── Services : MilkingService, ProductionService, MarketSellService, SlaughterService
       ├── Routes : POST /animals/milk, /animals/slaughter, /market/sell, GET /animals/productions, /market/prices
       ├── Stores : useProductionStore, useMarketStore
       ├── Pages : /animals/milking, /animals/productions, /market/prices
       └── Composants : MilkingTable, ProductionChart, SellModal, SlaughterConfirm, PriceTable
```

## Tests Sprint 07

```
GIVEN vache en lactation, salle traite, cuve vide 500L, HT >= 1.0
WHEN POST /api/animals/milk { animal_ids: [id] }
THEN 200, cuve += production, ht -= 1.0, last_milked_at = today

GIVEN cuve 490/500L, vache produit 32L
WHEN POST /api/animals/milk
THEN 200, cuve = 500L (capped), 10L non collectés, warning

GIVEN cuve avec 32.4L lait, cours 0.38€/L
WHEN POST /api/market/sell { product: milk, quantity: 32.4 }
THEN 200, balance += 12.31, cuve = 0, ht -= 0.5

GIVEN vache 689kg, cours 3.99€/kg
WHEN POST /api/animals/slaughter { animal_ids: [id] }
THEN 200, balance += 2749.11, animal.life_stage = 'dead', capacity -= 1

GIVEN vache gestante
WHEN POST /api/animals/slaughter
THEN 200 (autorisé mais warning affiché côté front)

GIVEN vache déjà traite aujourd'hui
WHEN POST /api/animals/milk
THEN 400 "Déjà traites aujourd'hui"
```

---

## 🏁 FIN MVP ÉLEVAGE

Après le Sprint 07, le joueur peut :
1. ✅ Construire des bâtiments (stabulation, cuve eau, silo, salle traite, cuve lait, fosse fumier)
2. ✅ Acheter des bovins au Marché Central
3. ✅ Voir la fiche complète d'un animal (génétique, santé, production, parents)
4. ✅ Nourrir (manuel + auto) et abreuver
5. ✅ Soigner, vacciner
6. ✅ Mettre paille, retirer fumier/lisier
7. ✅ Inséminer (naturel + CIA), attendre gestation, voir naître un veau
8. ✅ Consulter l'arbre généalogique
9. ✅ Traire, voir les productions, vendre le lait
10. ✅ Vendre à l'abattoir
11. ✅ Voir les cours du marché (animaux + produits)
12. ✅ Recevoir des alertes (pas nourri, malade, naissance, stock épuisé)
13. ✅ Le tick gère : nourrissage auto, santé, naissances, sevrage, fumier
