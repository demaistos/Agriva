# Sprint 05 — Soins + Vaccins + Litière — Spec End-to-End

> Prérequis : Sprint 04 (nourrissage, tick santé). Le joueur a des animaux qui peuvent tomber malades.
> Ce sprint ajoute : soigner, vacciner, paille, fumier, lisier.

---

## Tables SQL nouvelles

```sql
-- disease (seed : 5+ maladies bovines)
-- Modif : animal (vaccinated_until), building (bedding_ok, manure_level, slurry_level)
-- Existantes utilisées : animal_health_log, ledger, inventory
```

## Seed data

- `disease` : Mammite (coût 100€), Boiterie (80€), Diarrhée (60€), Fièvre (120€), Parasites (90€)

---

## Flux 1 : Soigner un animal malade

### Déclencheur

Fiche animal `/animals/:id` → animal avec `is_sick = true` → bouton "Soigner" visible en rouge.

Ou : Dashboard élevage → "🏥 Malades: 1 🔴 [Soigner tous]"

### Écran — Modale (depuis fiche)

```
┌─────────────────────────────────────────────┐
│ 🩺 Soigner Marguerite                        │
│                                              │
│ Maladie : Mammite 🟠 (gravité moyenne)       │
│ Santé actuelle : ❤️ 70/100                   │
│                                              │
│ Traitement : Antibiotiques                   │
│ Coût : 100 € + 0.5 HT                       │
│ Effet : Santé → "en rémission" (+20/tick)    │
│                                              │
│ Solde : 91 440 € ✅                          │
│ HT : 33.5/40 ✅                              │
│                                              │
│ [Annuler]              [Soigner 100 €]       │
└─────────────────────────────────────────────┘
```

**Bouton "Soigner" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `is_sick=true` + `balance >= 100` + `ht >= 0.5` |
| 🔘 Grisé "Pas malade" | `is_sick = false` |
| 🔘 Grisé "Solde insuffisant (besoin 100€)" | `balance < 100` |
| 🔘 Grisé "HT insuffisants (besoin 0.5)" | `ht < 0.5` |

### → API

```http
POST /api/animals/{id}/heal
Headers: X-Idempotency-Key: {uuid}
```

### → Backend

```
1. Idempotency check
2. SELECT * FROM animal WHERE id=$1 AND farm_id=$farm FOR UPDATE
3. Vérifier is_sick = true → sinon 400 "Pas malade"
4. Charger disease → coût
5. SELECT balance, ht_today FROM player WHERE id=$1 FOR UPDATE
6. Vérifier balance >= 100, ht >= 0.5
7. UPDATE player SET balance = balance - 100, ht_today = ht_today - 0.5
8. UPDATE animal SET is_sick = false, health = LEAST(health + 20, 100) WHERE id=$1
9. INSERT INTO animal_health_log (animal_id, event_type, description, health_before, health_after)
   VALUES ($1, 'healed', 'Mammite traitée', 70, 90)
10. INSERT INTO ledger (player_id, category, label, amount) VALUES ($1, 'health', 'Soin Marguerite (Mammite)', -100)
11. COMMIT
12. WS: balance_update, ht_update, animal_alert
13. Retourner 200 { health: 90, is_sick: false }
```

### ← Frontend

Toast "🩺 Marguerite soignée ! Santé : 90/100". Icône 🏥 disparaît. Barre santé animée 70→90.

### Soigner tous (batch) — depuis dashboard élevage

Clic "Soigner tous" → ConfirmModal :

```
┌─────────────────────────────────────────────┐
│ 🩺 Soigner tous les animaux malades          │
│                                              │
│ • Marguerite — Mammite — 100 €               │
│                                              │
│ Total : 100 € + 0.5 HT                      │
│                                              │
│ [Annuler]              [Soigner tous]        │
└─────────────────────────────────────────────┘
```

→ `POST /api/animals/batch-heal { animal_ids: [...] }` — même logique en boucle dans une seule transaction.

---

## Flux 2 : Vacciner un animal

### Déclencheur

Fiche animal → bouton "Vacciner" (visible si `vaccinated_until IS NULL OR vaccinated_until < NOW()`).

### Écran — Modale

```
┌─────────────────────────────────────────────┐
│ 💉 Vacciner Marguerite                       │
│                                              │
│ Dernier vaccin : Jamais                      │
│ Coût : 50 € + 0.5 HT                        │
│ Durée protection : 1 saison (21 jours)       │
│ Effet : -80% risque maladie                  │
│                                              │
│ [Annuler]              [Vacciner 50 €]       │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `vaccinated_until < NOW()` + solde + HT |
| 🔘 Grisé "Déjà vacciné (expire dans {X}j)" | `vaccinated_until > NOW()` |
| 🔘 Grisé "Solde/HT insuffisants" | Solde < 50 ou HT < 0.5 |

### → API + Backend

```http
POST /api/animals/{id}/vaccinate
Headers: X-Idempotency-Key: {uuid}
```

```
1-6. Mêmes vérifs (idempotency, ownership, état, solde, HT, FOR UPDATE)
7. UPDATE player SET balance -= 50, ht_today -= 0.5
8. UPDATE animal SET vaccinated_until = NOW() + interval '21 days'
9. INSERT INTO animal_health_log (event_type='vaccinated')
10. INSERT INTO ledger ('health', 'Vaccin Marguerite', -50)
11. COMMIT + WS
```

### ← Frontend

Toast "💉 Marguerite vaccinée ! Protection 21 jours." Badge 💉 apparaît sur fiche + DataTable.

---

## Flux 3 : Mettre de la paille (litière)

### Déclencheur

Sidebar → "Paille / Fumier / Lisier" ou fiche bâtiment → bouton "Mettre paille".

### Écran — Modale

```
┌─────────────────────────────────────────────┐
│ 🛏️ Mettre de la paille — Stabulation Nord   │
│                                              │
│ Paille nécessaire : 50 kg                    │
│ Stock paille : 500 kg ✅                     │
│ HT : 0.5                                    │
│                                              │
│ Effet : Litière propre → +5 santé/tick       │
│ Sans paille : -3 santé/tick                  │
│                                              │
│ [Annuler]              [Mettre paille 🛏️]    │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Stock paille >= besoin + HT >= 0.5 |
| 🔘 Grisé "Stock paille insuffisant (besoin {X}kg)" | Stock < besoin |
| 🔘 Grisé "HT insuffisants" | HT < 0.5 |
| 🔘 Grisé "Litière déjà fraîche" | `building.bedding_ok = true` et fait aujourd'hui |

### → API + Backend

```http
POST /api/buildings/{id}/bedding
Headers: X-Idempotency-Key: {uuid}
```

```
1-5. Vérifs standard
6. SELECT quantity FROM inventory WHERE product='straw' FOR UPDATE
7. Vérifier >= besoin
8. UPDATE inventory SET quantity -= besoin
9. UPDATE building SET bedding_ok = true, last_bedding_at = NOW()
10. UPDATE player SET ht_today -= 0.5
11. COMMIT + WS
```

### ← Frontend

Toast "🛏️ Paille mise dans Stabulation Nord". Icône litière ✅ sur la fiche bâtiment.

---

## Flux 4 : Retirer le fumier

### Déclencheur

Sidebar → "Paille / Fumier / Lisier" ou fiche bâtiment → bouton "Retirer fumier".

### Écran — Modale

```
┌─────────────────────────────────────────────┐
│ 💩 Retirer le fumier — Stabulation Nord      │
│                                              │
│ Fumier accumulé : 200 kg                     │
│ Fosse à fumier : 800 / 2000 kg ✅           │
│ HT : 0.5                                    │
│                                              │
│ ⚠️ Si fosse pleine, le fumier déborde        │
│ (malus santé animaux)                        │
│                                              │
│ [Annuler]              [Retirer fumier 💩]   │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Fumier > 0 + fosse avec place + HT >= 0.5 |
| 🔘 Grisé "Pas de fumier à retirer" | `manure_level = 0` |
| 🔘 Grisé "Fosse à fumier pleine" | Fosse pleine |
| 🔘 Grisé "Pas de fosse à fumier" | Aucune fosse construite |
| 🔘 Grisé "HT insuffisants" | HT < 0.5 |

### → API + Backend

```http
POST /api/buildings/{id}/manure
Headers: X-Idempotency-Key: {uuid}
```

```
1-5. Vérifs standard
6. SELECT manure_level FROM building WHERE id=$1 FOR UPDATE
7. SELECT quantity, capacity FROM inventory WHERE building_id=$fosse AND product='manure' FOR UPDATE
8. Vérifier fosse.quantity + manure_level <= fosse.capacity
9. UPDATE building SET manure_level = 0
10. UPDATE inventory SET quantity += $manure_level WHERE building_id=$fosse AND product='manure'
11. UPDATE player SET ht_today -= 0.5
12. COMMIT + WS
```

### ← Frontend

Toast "💩 200kg de fumier retirés → Fosse à fumier". Bâtiment : manure_level = 0.

---

## Flux 5 : Retirer le lisier

Même pattern que Flux 4 mais :
- Produit : `slurry` au lieu de `manure`
- Destination : fosse à lisier
- Quantité en litres

---

## Tick quotidien — Impact litière/fumier

```
Étape 11bis — Litière et fumier :
  Pour chaque bâtiment avec animaux :
    manure_level += nb_animaux × 5 (kg/jour/animal)
    Si bedding_ok = false depuis > 2 jours :
      Pour chaque animal : health -= 3
    Si manure_level > capacity × 0.9 :
      Notification "⚠️ Fosse presque pleine dans {bâtiment}"
    Si manure_level > capacity :
      Pour chaque animal : health -= 5 (débordement)
      Notification "🔴 Fumier déborde dans {bâtiment} !"
```

---

## Dépendances techniques Sprint 05

```
Sprint 04 (nourrissage, tick santé)
  └→ Sprint 05 (soins, vaccins, litière)
       ├── Tables : disease (seed)
       ├── Modif : animal (vaccinated_until), building (bedding_ok, manure_level, slurry_level, last_bedding_at)
       ├── Services : HealService, VaccineService, BeddingService, ManureService
       ├── Worker : tick étape 11bis (litière/fumier impact)
       ├── Routes : POST /animals/:id/heal, /vaccinate, /buildings/:id/bedding, /manure, /slurry
       ├── Pages : modales depuis fiche animal + fiche bâtiment
       └── Composants : HealModal, VaccineModal, BeddingModal, ManureModal
```

## Tests Sprint 05

```
GIVEN animal malade (Mammite), joueur avec 100€ et 0.5 HT
WHEN POST /api/animals/{id}/heal
THEN 200, balance -= 100, health += 20, is_sick = false

GIVEN animal pas malade
WHEN POST /api/animals/{id}/heal
THEN 400 "Pas malade"

GIVEN animal non vacciné
WHEN POST /api/animals/{id}/vaccinate
THEN 200, vaccinated_until = now + 21j, balance -= 50

GIVEN animal vacciné il y a 5 jours
WHEN POST /api/animals/{id}/vaccinate
THEN 400 "Déjà vacciné (expire dans 16j)"

GIVEN bâtiment avec 200kg fumier, fosse 800/2000
WHEN POST /api/buildings/{id}/manure
THEN 200, building.manure = 0, fosse = 1000/2000

GIVEN bâtiment sans litière depuis 3 jours
WHEN tick santé
THEN chaque animal health -= 3

GIVEN animal vacciné, tick maladie aléatoire
THEN probabilité maladie réduite de 80%
```
