# Sprint 04 — Nourrir + Abreuver + Alertes — Spec End-to-End

> Prérequis : Sprint 03 (bâtiments, animaux). Le joueur a une stabulation avec 1+ bovins.
> Ce sprint ajoute : stock aliments, nourrissage manuel/auto, abreuvement, tick santé.

---

## Tables SQL nouvelles ce sprint

```sql
-- animal_ration (seed), inventory (stock aliments/eau), auto_feed_config
-- Existantes modifiées : animal (last_fed_at, last_watered_at, days_unfed, is_sick)
```

## Seed data

- `animal_ration` : 10+ rations bovines (Foin+Maïs, Paille+Maïs, Paille+Betterave...) par tranche d'âge
- `inventory` : types produits (foin, maïs_ensile, paille, orge, tourteau, mineraux, eau)

---

## Flux 1 : Acheter des aliments au Marché Central

### Écran `/market/products`

```
┌─────────────────────────────────────────────────────────────────┐
│ Marché Central — Marchandises                                    │
│ [Animaux] [Marchandises]                                         │
├─────────────────────────────────────────────────────────────────┤
│ Produit        | Prix/t  | Variation | Stock dispo | Action      │
│ Foin           | 80 €/t  | ↑ +2      | 5 000 t     | [Acheter]  │
│ Maïs ensilé    | 45 €/t  | = 0       | 12 000 t    | [Acheter]  │
│ Paille         | 60 €/t  | ↓ -3      | 8 000 t     | [Acheter]  │
│ Orge           | 120 €/t | ↑ +5      | 3 000 t     | [Acheter]  │
│ Tourteau colza | 250 €/t | = 0       | 1 500 t     | [Acheter]  │
│ Minéraux       | 400 €/t | = 0       | 800 t       | [Acheter]  │
├─────────────────────────────────────────────────────────────────┤
│ ℹ️ Consultation gratuite. Achat : 0.5 HT par transaction.       │
│ ⚠️ Vous devez avoir un silo pour stocker les aliments.           │
└─────────────────────────────────────────────────────────────────┘
```

### Clic "Acheter" sur Foin → Modale

```
┌─────────────────────────────────────────────┐
│ 🌾 Acheter du Foin                           │
│                                              │
│ Prix : 80 €/t                                │
│ Quantité : [____2.0____] tonnes              │
│            (min 0.1t, max: capacité silo)    │
│                                              │
│ Destination : [Silo (0/10 t) ▼]             │
│                                              │
│ Total : 2.0 × 80 = 160 €                    │
│ HT : 0.5                                    │
│                                              │
│ Solde : 91 600 € ✅                          │
│ HT : 35.5/40 ✅                              │
│ Silo : 10t dispo ✅                          │
│                                              │
│ [Annuler]              [Acheter 160 €]       │
└─────────────────────────────────────────────┘
```

**Bouton "Acheter" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= total` ET `ht >= 0.5` ET `silo.remaining >= quantity` |
| 🔘 Grisé "Solde insuffisant (besoin {X}€)" | `balance < total` |
| 🔘 Grisé "HT insuffisants" | `ht < 0.5` |
| 🔘 Grisé "Silo plein ({X}/{Y}t)" | `silo.remaining < quantity` |
| 🔘 Grisé "Pas de silo" | Aucun silo construit |
| 🔘 Grisé "Quantité invalide" | `quantity <= 0` |

### → API

```http
POST /api/market/buy
Headers: Authorization: Bearer {jwt}, X-Idempotency-Key: {uuid}
Body: { "product": "hay", "quantity": 2.0, "building_id": "{silo_uuid}" }
```

### → Backend

```
1. Idempotency check
2. Charger market_price pour "hay" → 80€/t
3. Calculer total : 2.0 × 80 = 160
4. BEGIN
5. SELECT balance, ht_today FROM player WHERE id=$1 FOR UPDATE
6. Vérifier balance >= 160, ht >= 0.5
7. SELECT current_stock, capacity FROM inventory WHERE building_id=$silo AND product='hay' FOR UPDATE
   → Si pas de ligne : INSERT INTO inventory (building_id, product, quantity, capacity) VALUES ($silo, 'hay', 0, 10)
8. Vérifier current_stock + 2.0 <= capacity
9. UPDATE player SET balance = balance - 160, ht_today = ht_today - 0.5
10. UPDATE inventory SET quantity = quantity + 2.0 WHERE building_id=$silo AND product='hay'
11. INSERT INTO ledger (player_id, category, label, amount) VALUES ($1, 'purchase', 'Achat 2.0t Foin', -160)
12. COMMIT
13. WS: balance_update, ht_update
14. Retourner 201 { product: 'hay', quantity: 2.0, total: 160 }
```

### ← Frontend

Toast "🌾 2.0t de Foin achetées pour 160€". Header animé. Silo mis à jour si visible.

---

## Flux 2 : Remplir la cuve à eau

### Écran : Clic sur cuve à eau dans `/buildings` → détail → bouton "Remplir"

```
┌─────────────────────────────────────────────┐
│ 💧 Remplir la cuve à eau                    │
│                                              │
│ Cuve : 0 / 5 000 L                          │
│ Prix : 0.01 €/L                              │
│ Quantité : [___5000___] L  [Plein]           │
│                                              │
│ Total : 50 €                                 │
│ HT : 0.5                                    │
│                                              │
│ [Annuler]              [Remplir 50 €]        │
└─────────────────────────────────────────────┘
```

**Même pattern que Flux 1** mais produit = `water`, destination = cuve à eau.

---

## Flux 3 : Nourrir ses animaux (manuel)

### Navigation : Sidebar → "Nourrissage" ou fiche bâtiment → "Nourrir"

### Écran `/buildings/{id}/feed`

```
┌──────────────────────────────────────────────────────────────┐
│ 🍽️ Nourrir — Stabulation Nord (1 animal)                     │
├──────────────────────────────────────────────────────────────┤
│ RATION DE BASE (radio)                                        │
│                                                               │
│ ○ Foin + Maïs ensilé                                         │
│   Besoin : Foin 8kg + Maïs 12kg = 20 kg total                │
│   Stock : Foin 2000kg ✅ | Maïs 0kg ❌                       │
│   Qualité : ★★★                                              │
│                                                               │
│ ● Foin seul                                                   │
│   Besoin : Foin 25 kg                                         │
│   Stock : Foin 2000kg ✅                                      │
│   Qualité : ★★                                                │
│                                                               │
│ ○ Paille + Maïs ensilé                                       │
│   Besoin : Paille 10kg + Maïs 15kg = 25 kg total             │
│   Stock : Paille 0kg ❌ | Maïs 0kg ❌                        │
│   Qualité : ★★ (barré, stock insuffisant)                     │
├──────────────────────────────────────────────────────────────┤
│ COMPLÉMENTS (auto-calculés)                                   │
│ Orge : 3.2 kg — Stock: 0 kg ❌ (optionnel, réduit qualité)  │
│ Minéraux : 0.5 kg — Stock: 0 kg ❌ (optionnel)              │
├──────────────────────────────────────────────────────────────┤
│ MÉTHODE                                                       │
│ ● Manuel (2.0 HT)                                            │
│ ○ Tracteur + Désileuse (0.5 HT) — ❌ Pas de désileuse       │
├──────────────────────────────────────────────────────────────┤
│ RÉSUMÉ                                                        │
│ Animaux : 1 | Ration : Foin seul ★★ | HT : 2.0              │
│ Stock après : Foin 1975 kg                                    │
│                                                               │
│ [Annuler]                              [Nourrir 🍽️]          │
└──────────────────────────────────────────────────────────────┘
```

**Bouton "Nourrir" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Ration sélectionnée + stock suffisant pour composants de base + HT suffisants |
| 🔘 Grisé "Sélectionnez une ration" | Aucune ration cochée |
| 🔘 Grisé "Stock insuffisant : manque {X}kg de {produit}" | Stock < besoin pour un composant de base |
| 🔘 Grisé "HT insuffisants (besoin {X}, reste {Y})" | `ht < ht_cost` |
| 🔘 Grisé "Animaux déjà nourris aujourd'hui" | Tous `last_fed_at >= today` |
| 🔘 Grisé "Désileuse requise" | Méthode désileuse + pas de désileuse |
| 🔘 Grisé "Tracteur requis pour désileuse" | Méthode désileuse + pas de tracteur |

**Note :** Les rations avec stock insuffisant sont affichées mais barrées et non sélectionnables.

### Clic "Nourrir" → Frontend

1. Vérifie toutes les conditions
2. Idempotency key
3. Spinner sur bouton

### → API

```http
POST /api/buildings/{id}/feed
Headers: X-Idempotency-Key: {uuid}
Body: { "ration_id": 2, "method": "manual" }
```

### → Backend (`FeedingService.feed`)

```
1. Idempotency check
2. Charger bâtiment → ownership, type hébergement
3. Charger animaux dans ce bâtiment : SELECT * FROM animal WHERE building_id=$1 AND life_stage!='dead'
4. Vérifier au moins 1 animal non nourri aujourd'hui
5. Charger ration (id=2) → composants JSONB : [{"product":"hay","kg_per_animal":25}]
6. Calculer besoin total : nb_animaux × kg_per_animal par composant
7. Si method = "desilage" : vérifier tracteur + désileuse non cassés
8. Calculer HT : method=manual → 2.0, method=desilage → 0.5
9. BEGIN
10. SELECT balance, ht_today FROM player WHERE id=$1 FOR UPDATE
11. Vérifier ht_today >= ht_cost
12. Pour chaque composant de la ration :
    SELECT quantity FROM inventory WHERE building_id IN (silos du joueur) AND product=$product FOR UPDATE
    Vérifier quantity >= besoin
    UPDATE inventory SET quantity = quantity - besoin
13. UPDATE player SET ht_today = ht_today - $ht_cost
14. UPDATE animal SET last_fed_at = NOW(), days_unfed = 0
    WHERE building_id = $building_id AND life_stage != 'dead'
    AND (last_fed_at IS NULL OR last_fed_at < CURRENT_DATE)
15. INSERT INTO animal_feeding_log (animal_id, farm_id, ration_id, quality, fed_at)
    SELECT id, farm_id, $ration_id, $quality, NOW()
    FROM animal WHERE building_id = $building_id AND life_stage != 'dead'
16. COMMIT
17. WS: ht_update, animal_alert (not_fed count updated)
18. Retourner 200 { fed_count: 1, ration: "Foin seul", quality: 2, ht_spent: 2.0 }
```

### ← Frontend

1. Toast vert : "🍽️ 1 animal nourri — Ration Foin seul ★★"
2. HT header animé : -2.0
3. Stock affiché mis à jour
4. Si on revient sur `/animals` : icône 🍽️ passe de ❌ à ✅
5. Dashboard élevage : compteur "Pas nourris" décrémenté
6. Bouton "Nourrir" passe à grisé "Déjà nourris aujourd'hui"

---

## Flux 4 : Abreuver les animaux

### Écran : Bouton "Abreuver" sur la page bâtiment ou action groupée

```
┌─────────────────────────────────────────────┐
│ 💧 Abreuver — Stabulation Nord              │
│                                              │
│ Animaux : 1                                  │
│ Eau nécessaire : 45 L                        │
│ Cuve à eau : 4 950 / 5 000 L ✅             │
│ HT : 0.3                                    │
│                                              │
│ [Annuler]              [Abreuver 💧]         │
└─────────────────────────────────────────────┘
```

**Bouton "Abreuver" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Cuve eau dispo >= besoin + HT >= 0.3 + animaux pas abreuvés |
| 🔘 Grisé "Pas de cuve à eau" | Aucune cuve construite |
| 🔘 Grisé "Cuve vide ({X}/{Y}L)" | `cuve.quantity < besoin` |
| 🔘 Grisé "HT insuffisants" | `ht < 0.3` |
| 🔘 Grisé "Déjà abreuvés aujourd'hui" | Tous `last_watered_at >= today` |

### → API

```http
POST /api/buildings/{id}/water
Headers: X-Idempotency-Key: {uuid}
```

### → Backend

```
1. Idempotency
2. Charger animaux dans le bâtiment non abreuvés aujourd'hui
3. Calculer eau nécessaire : sum(breed.water_per_day) pour chaque animal
4. BEGIN
5. SELECT ht_today FROM player FOR UPDATE → vérifier >= 0.3
6. SELECT quantity FROM inventory WHERE product='water' AND building_id=$cuve FOR UPDATE
7. Vérifier quantity >= eau_necessaire
8. UPDATE player SET ht_today = ht_today - 0.3
9. UPDATE inventory SET quantity = quantity - $eau WHERE product='water'
10. UPDATE animal SET last_watered_at = NOW() WHERE building_id=$1 AND last_watered_at < CURRENT_DATE
11. COMMIT
12. WS: ht_update, animal_alert
13. Retourner 200 { watered_count: 1, water_used: 45 }
```

### ← Frontend

Toast "💧 1 animal abreuvé (45L)". HT -0.3. Cuve mise à jour. Icône 💧 passe ❌→✅.

---

## Flux 5 : Configurer le nourrissage automatique

### Écran `/buildings/{id}/auto-feed`

```
┌──────────────────────────────────────────────────────────────┐
│ ⚙️ Nourrissage automatique — Stabulation Nord                │
├──────────────────────────────────────────────────────────────┤
│ Statut : ❌ Désactivé                                        │
│                                                               │
│ Ration : [Foin seul ★★ ▼]                                   │
│ Méthode : ● Manuel (2.0 HT/jour) ○ Désileuse (0.5 HT/jour) │
│                                                               │
│ ESTIMATION STOCK                                              │
│ Foin : 1975 kg en stock                                       │
│ Besoin/jour : 25 kg × 1 animal = 25 kg                       │
│ Stock suffisant pour : 79 jours ✅                            │
│                                                               │
│ ⚠️ Le tick quotidien (00:00 UTC) nourrira automatiquement.    │
│ Si le stock est épuisé, les animaux ne seront pas nourris.    │
│ HT déduits quotidiennement (pas en bloc).                     │
│                                                               │
│ [Annuler]                    [Activer nourrissage auto ⚙️]    │
└──────────────────────────────────────────────────────────────┘
```

**Bouton "Activer" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Ration choisie + stock > 0 |
| 🔘 Grisé "Sélectionnez une ration" | Pas de ration |
| 🔘 Grisé "Stock vide" | Stock = 0 pour un composant de base |
| 🟠 "Désactiver" | Déjà actif → bouton bascule |

**Note :** Pas de vérification HT à l'activation. Les HT sont déduits par le tick chaque jour. Si HT insuffisants au moment du tick, le nourrissage auto est skippé et une notification est envoyée.

### → API

```http
POST /api/buildings/{id}/auto-feed
Body: { "ration_id": 2, "method": "manual" }
```

Désactivation :
```http
DELETE /api/buildings/{id}/auto-feed
```

### → Backend

```
1. Ownership check
2. Vérifier bâtiment héberge des animaux
3. Vérifier ration compatible avec l'espèce
4. UPSERT auto_feed_config (building_id, ration_id, method, active, created_at)
5. Retourner 200 { active: true, ration: "Foin seul", estimated_days: 79 }
```

Pas de transaction lourde — c'est juste une config. Le tick l'exécutera.

### Tick quotidien — Étape nourrissage auto (worker)

```
Pour chaque auto_feed_config WHERE active = true :
  1. Charger animaux du bâtiment non nourris
  2. Charger ration → calculer besoin
  3. Vérifier stock suffisant
     → Si non : skip, notification "⚠️ Stock épuisé, nourrissage auto impossible"
  4. Vérifier HT joueur >= ht_cost
     → Si non : skip, notification "⚠️ HT insuffisants pour nourrissage auto"
  5. BEGIN
  6. Déduire stock, déduire HT, marquer animaux nourris
  7. COMMIT
  8. Log dans animal_feeding_log
```

### ← Frontend (après activation)

Toast "⚙️ Nourrissage auto activé — Foin seul ★★ — ~79 jours de stock". Bouton bascule vers "Désactiver".

---

## Flux 6 : Le tick passe — Animaux non nourris tombent malades

### Ce qui se passe à 00:00 UTC (worker)

```
Étape 10 — Nourrissage auto : exécuté (voir Flux 5)
Étape 11 — Vérification santé :
  Pour chaque animal WHERE last_fed_at < CURRENT_DATE - 1 :
    days_unfed += 1
    Si days_unfed >= 1 : health -= 10
    Si days_unfed >= 3 : is_sick = true
    Si health <= 0 : life_stage = 'dead'
    
  Pour chaque animal WHERE last_watered_at < CURRENT_DATE - 1 :
    health -= 15 (eau plus critique que nourriture)
    Si 2 jours sans eau : is_sick = true
    Si health <= 0 : life_stage = 'dead'
```

### Notifications générées

```
Si animaux pas nourris : "🍽️ {N} animaux n'ont pas mangé aujourd'hui"
Si animaux pas abreuvés : "💧 {N} animaux n'ont pas bu aujourd'hui"
Si animaux malades : "🏥 {N} animaux sont tombés malades"
Si animaux morts : "💀 {N} animaux sont morts (manque de soins)"
```

### Ce que le joueur voit le lendemain

**Dashboard :**
```
🔔 ALERTES DU JOUR
• 🍽️ 1 animal pas nourri ⚠️
• 💧 1 animal pas abreuvé ⚠️
```

**Page `/animals` — Tableau de bord élevage :**
```
🍽️ Pas nourris: 1 ⚠️ | 💧 Pas abreuvés: 1 ⚠️ | 🏥 Malades: 0 ✅
```

**DataTable :** Icônes 🍽️❌ et 💧❌ sur l'animal concerné. Santé ❤️90 🟢 (baissé de 10).

**Fiche animal :** Santé 90/100, "Nourri : ❌ Non", "Abreuvé : ❌ Non".

---

## Flux 7 : Notification cliquable → action directe

### Le joueur clique sur la notification "🍽️ 1 animal pas nourri"

→ Navigation vers `/animals?filter=not_fed`

La DataTable est pré-filtrée sur les animaux non nourris. Le joueur peut :
1. Cliquer [Voir] → fiche → bouton Nourrir
2. Ou cocher l'animal → action groupée [Nourrir sélection]

L'action groupée ouvre la même modale que Flux 3 mais pour les animaux sélectionnés.

---

## Dépendances techniques Sprint 04

```
Sprint 03 (bâtiments, animaux)
  └→ Sprint 04 (nourrissage, abreuvement)
       ├── Tables : inventory, auto_feed_config, animal_ration (seed)
       ├── Modif tables : animal (last_fed_at, last_watered_at, days_unfed)
       ├── Services : FeedingService, WaterService, MarketBuyService, AutoFeedWorker
       ├── Worker : tick étapes 10 (auto-feed) + 11 (health check)
       ├── Routes : POST /buildings/:id/feed, /water, /auto-feed, POST /market/buy
       ├── Stores : useInventoryStore, useFeedingStore
       ├── Pages : /buildings/:id/feed, /buildings/:id/auto-feed, /market/products
       └── Composants : RationSelector, StockIndicator, AutoFeedToggle
```

## Tests Sprint 04

### Intégration
```
GIVEN joueur avec silo 10t vide
WHEN POST /api/market/buy { product: hay, quantity: 2.0, building_id: silo }
THEN 201, balance -= 160, silo.hay = 2.0

GIVEN stabulation avec 1 animal non nourri, silo avec 2t foin
WHEN POST /api/buildings/{id}/feed { ration_id: 2, method: manual }
THEN 200, ht -= 2.0, silo.hay -= 25kg, animal.last_fed_at = today

GIVEN animal nourri aujourd'hui
WHEN POST /api/buildings/{id}/feed
THEN 400 "Animaux déjà nourris aujourd'hui"

GIVEN silo avec 0kg foin
WHEN POST /api/buildings/{id}/feed { ration foin }
THEN 400 "Stock insuffisant : manque 25kg de Foin"

GIVEN auto_feed actif, stock suffisant, HT suffisants
WHEN tick quotidien exécuté
THEN animal.last_fed_at = today, stock déduit, HT déduit

GIVEN auto_feed actif, stock = 0
WHEN tick quotidien
THEN animal PAS nourri, notification "Stock épuisé" envoyée

GIVEN animal non nourri depuis 3 jours
WHEN tick santé
THEN animal.is_sick = true, notification "Animal malade"

GIVEN animal non abreuvé depuis 2 jours, health = 30
WHEN tick santé
THEN health = 0, life_stage = 'dead', notification "Animal mort"
```

### E2E
```
1. /market/products → acheter 2t foin → vérifier toast + silo mis à jour
2. /buildings/{id}/feed → sélectionner "Foin seul" → Nourrir → toast + icône ✅
3. Activer nourrissage auto → vérifier estimation jours
4. Simuler tick → vérifier animal nourri automatiquement
5. Simuler animal non nourri 3 jours → vérifier maladie + notification
```
