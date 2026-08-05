# Sprint 11 — Cycle culture complet + Récolte + Vente — Spec End-to-End

> Prérequis : Sprint 10 (parcelles, semis, croissance).
> Ce sprint ajoute : engrais, traitements, rouleau, récolte, paille, vente récolte.

---

## Flux 1 : Épandre engrais

### Fiche parcelle → bouton "Épandre engrais"

```
┌──────────────────────────────────────────────────────────────┐
│ 🧪 Épandre engrais — Parcelle #1 (10 ha)                     │
│                                                               │
│ Type : [NPK 15-15-15 ▼]                                     │
│ Quantité : [____200____] kg/ha × 10 ha = 2 000 kg            │
│                                                               │
│ Apport nutriments :                                           │
│ N: +30 | P: +30 | K: +30 | Ca: 0 | Mg: 0 | S: 0             │
│                                                               │
│ Stock engrais : 3 000 kg ✅                                   │
│ Coût : 0 € (déjà acheté) | HT : 3.0 | HVC : 12 L            │
│ Matériel : Tracteur ✅ + Épandeur engrais ❌                  │
│                                                               │
│ [Annuler]              [Épandre] (grisé: épandeur)           │
└──────────────────────────────────────────────────────────────┘
```

**Bouton — États :** Même pattern (matériel + stock + HT + HVC).

### → Backend

```
1-5. Vérifs standard
6. BEGIN + FOR UPDATE player + inventory(engrais) + inventory(hvc)
7. UPDATE parcel_soil SET n += $apport_n, p += $apport_p, k += $apport_k...
8. UPDATE inventory SET quantity -= 2000 WHERE product='npk'
9. UPDATE inventory SET quantity -= 12 WHERE product='hvc'
10. UPDATE player SET ht_today -= 3.0
11. UPDATE crop SET fertilized = true
12. UPDATE vehicle SET wear_pct += ...
13. COMMIT + WS
```

---

## Flux 2 : Traiter (fongicide/herbicide/insecticide)

### Fiche parcelle → bouton "Traiter"

```
┌──────────────────────────────────────────────────────────────┐
│ 🧴 Traiter — Parcelle #1                                     │
│                                                               │
│ Type : ● Fongicide 🍄 ○ Herbicide 🌿 ○ Insecticide 🐛       │
│                                                               │
│ Stock fongicide : 50 L ✅                                     │
│ Besoin : 10 ha × 2 L/ha = 20 L                               │
│ HT : 2.0 | HVC : 10 L                                        │
│ Matériel : Tracteur ✅ + Pulvérisateur ❌                     │
│                                                               │
│ [Annuler]              [Traiter] (grisé: pulvérisateur)      │
└──────────────────────────────────────────────────────────────┘
```

3 traitements indépendants. Chacun met un flag sur le crop : `fungicide_done`, `herbicide_done`, `insecticide_done`.

Impact rendement : chaque traitement manquant = -10% rendement à la récolte.

---

## Flux 3 : Passer le rouleau

Même pattern. Matériel : tracteur + rouleau. Flag : `rolled = true`. Impact : +5% rendement.

---

## Flux 4 : Récolter

### Fiche parcelle (crop.status = 'mature') → bouton "Récolter"

```
┌──────────────────────────────────────────────────────────────┐
│ 🌾 Récolter — Parcelle #1 (10 ha de Blé)                     │
│                                                               │
│ Rendement estimé :                                            │
│ Base régional : 7.5 t/ha                                      │
│ × Qualité sol : ×1.10 (⭐⭐⭐)                               │
│ × Nutriments : ×0.95 (N un peu bas)                           │
│ × Météo saison : ×1.05 (bonne saison)                        │
│ × Semence certifiée : ×1.10                                   │
│ × Traitements : ×0.90 (herbicide manquant)                    │
│ × Rouleau : ×1.05                                             │
│ × Fatigue sol : ×1.00 (pas de monoculture)                    │
│ = 8.2 t/ha × 10 ha = 82 tonnes estimées                      │
│                                                               │
│ Destination : [Silo (2/10 t) ▼]                              │
│ ⚠️ Silo insuffisant ! Capacité restante : 8t sur 82t          │
│ → Excédent vendu automatiquement au cours du jour             │
│                                                               │
│ HT : 10.0 | HVC : 30 L                                       │
│ Matériel : Tracteur ✅ + Moissonneuse ❌                      │
│                                                               │
│ [Annuler]              [Récolter] (grisé: moissonneuse)      │
└──────────────────────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | crop.status='mature' + tracteur + moissonneuse + HT + HVC |
| 🔘 Grisé "Culture pas encore mature ({X}%)" | `growth_pct < 100` |
| 🔘 Grisé "Moissonneuse requise" | Pas de moissonneuse |
| 🔘 Grisé "HT/HVC insuffisants" | HT ou HVC < coût |

### → Backend

```
1-5. Vérifs
6. Calculer rendement réel :
   yield = base_yield × soil_factor × nutrient_factor × weather_factor
           × seed_factor × treatment_factor × roll_factor × fatigue_factor
   Clamp à 120% du base (plafond)
7. total_harvest = yield × parcel.size_ha
8. BEGIN + FOR UPDATE
9. Stocker dans silo : MIN(total_harvest, silo.remaining)
   UPDATE inventory SET quantity += $stored WHERE product=$crop_type
10. Excédent = total_harvest - stored → vente auto au cours du jour
    Si excédent > 0 : revenue = excédent × market_price
    UPDATE player SET balance += revenue
11. UPDATE player SET ht_today -= $ht
12. UPDATE inventory SET quantity -= $hvc WHERE product='hvc'
13. DELETE FROM crop WHERE parcel_id=$1
14. UPDATE parcel SET status='harvested'
15. UPDATE parcel_soil SET fatigue_index += $fatigue (monoculture check)
16. UPDATE vehicle SET wear_pct += ...
17. INSERT INTO ledger (si vente auto excédent)
18. COMMIT + WS: parcel_alert, balance_update
```

### ← Frontend

Toast "🌾 82t de Blé récoltées ! 8t stockées, 74t vendues pour 6 660€". Parcelle passe en état "récoltée".

---

## Flux 5 : Presser la paille

### Après récolte → bouton "Presser paille"

```
┌─────────────────────────────────────────────┐
│ 🌾 Presser la paille — Parcelle #1           │
│                                              │
│ Paille disponible : 30 balles estimées       │
│ Destination : [Aire stockage (0/100) ▼]     │
│ HT : 3.0 | HVC : 8 L                        │
│ Matériel : Tracteur ✅ + Presse ❌           │
│                                              │
│ [Annuler]              [Presser]             │
└─────────────────────────────────────────────┘
```

Même pattern. Stock paille dans aire de stockage. Utilisable pour litière (Sprint 05).

---

## Flux 6 : Vendre la récolte au Marché Central

### Page `/market/sell` ou bouton depuis stock

```
┌─────────────────────────────────────────────────────────────────┐
│ 🏪 Vendre au Marché Central                                     │
│                                                                 │
│ Produit : [Blé ▼]                                              │
│ Stock : 8 t                                                     │
│ Cours actuel : 90 €/t (saison récolte : ×0.90)                 │
│ Cours hors saison : ~110 €/t                                    │
│ ℹ️ Conseil : stocker et vendre hors saison pour +22%            │
│                                                                 │
│ Quantité : [____8____] t  [Tout]                                │
│ Total : 8 × 90 = 720 €                                         │
│ HT : 0.5                                                       │
│                                                                 │
│ [Annuler]              [Vendre 720 €]                           │
└─────────────────────────────────────────────────────────────────┘
```

Même pattern que vente lait (Sprint 07 Flux 4).

---

## Dépendances + Tests

```
Sprint 10 → Sprint 11
  ├── Tables : crop_treatment
  ├── Modif : crop (fertilized, fungicide_done, herbicide_done, insecticide_done, rolled)
  ├── Modif : parcel_soil (fatigue_index)
  ├── Services : FertilizeService, TreatService, HarvestService, BaleService
  ├── Worker : tick croissance (enrichi facteurs)
  ├── Routes : POST /parcels/:id/fertilize, /treat, /roll, /harvest, /bale
  └── Composants : FertilizeModal, TreatModal, HarvestModal, YieldBreakdown
```

Tests clés :
```
GIVEN parcelle avec blé mature, moissonneuse, silo 8t libre
WHEN POST /parcels/:id/harvest
THEN 8t stockées, excédent vendu auto, rendement calculé avec tous les facteurs

GIVEN blé sans herbicide
WHEN récolte
THEN rendement × 0.90 (pénalité -10%)

GIVEN même culture 2 saisons de suite
WHEN récolte
THEN fatigue_index += 15 (monoculture)

GIVEN silo plein
WHEN récolte
THEN tout vendu auto au cours du jour
```
