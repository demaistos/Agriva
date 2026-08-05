# Sprint 12 — Matériels + HVC + ETA — Spec End-to-End

> Prérequis : Sprint 11. Le joueur a besoin de matériel pour les cultures.
> Ce sprint ajoute : catalogue matériel neuf (marques réelles), entretien, réparation, HVC, ETA Cultivia.

---

## Flux 1 : Acheter un matériel neuf

### Page `/equipment/shop`

```
┌─────────────────────────────────────────────────────────────────┐
│ 🔧 Catalogue matériel neuf                                      │
│ Filtres: [Type ▼] [Marque ▼] [Recherche ____]                  │
│ Tri: [Prix ↑↓] [Puissance ↑↓]                                  │
├─────────────────────────────────────────────────────────────────┤
│ 🚜 TRACTEURS                                                    │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ John Deere 6120M          │ Claas Arion 530               │ │
│ │ 120 ch | 55 000 €         │ 125 ch | 58 000 €             │ │
│ │ [Détail] [Acheter]        │ [Détail] [Acheter]            │ │
│ └─────────────────────────────────────────────────────────────┘ │
│ 🔧 OUTILS DU SOL                                                │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Kuhn Cultimer L300        │ Lemken Juwel 8                │ │
│ │ Cultivateur | 80ch min    │ Charrue | 100ch min            │ │
│ │ 12 000 € [Acheter]       │ 18 000 € [Acheter]            │ │
│ └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Clic "Détail" → Fiche matériel

```
┌─────────────────────────────────────────────────────────────────┐
│ 🚜 John Deere 6120M — Tracteur                                  │
│                                                                 │
│ Marque : John Deere                                             │
│ Puissance : 120 ch                                              │
│ Prix neuf : 55 000 €                                            │
│ Consommation HVC : 0.12 L/ch/HT au travail                     │
│ Usure base : 0.10%/jour                                         │
│ Entretien mensuel : 1.0 HT                                     │
│ Réparation : 2.0 HT + 2 750 € (5% prix neuf)                  │
│ Pièces détachées : 4 pièces, 1 100 €/pièce (2% prix neuf)     │
│ Maniabilité : ⭐⭐⭐ (3/5)                                     │
│                                                                 │
│ Compatibilité avec vos outils :                                 │
│ ✅ Benne robust RT15 (40ch requis)                              │
│ ✅ Plateau Dangreville P60 (60ch requis)                        │
│ ✅ Bétaillère Mazeron BT1340 (50ch requis)                      │
│ ❌ Charrue Lemken Juwel 8 (100ch requis) — pas encore achetée  │
│                                                                 │
│ [Annuler]              [Acheter 55 000 €]                       │
└─────────────────────────────────────────────────────────────────┘
```

**Bouton "Acheter" — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= prix` + `ht >= 1.0` |
| 🔘 Grisé "Solde insuffisant" | `balance < prix` |
| 🔘 Grisé "HT insuffisants" | `ht < 1.0` |
| 🟠 Warning "Pas de tracteur assez puissant pour cet outil" | Outil tracté + tracteur < min_cv (non bloquant) |

### → Backend

```
1-5. Vérifs + FOR UPDATE
6. INSERT INTO vehicle (farm_id, vehicle_type_id, wear_pct=0, bought_price=$prix, is_sheltered=false)
7. UPDATE player SET balance -= prix, ht_today -= 1.0
8. INSERT INTO ledger ('purchase', 'Achat John Deere 6120M', -55000)
9. Recalculer is_sheltered pour tous les matériels (si hangar construit)
10. COMMIT + WS
```

---

## Flux 2 : Entretenir un matériel

### Page `/equipment` → bouton 🔧 sur un matériel

```
┌─────────────────────────────────────────────┐
│ 🔧 Entretenir — John Deere 6120M            │
│                                              │
│ Usure actuelle : 15%                         │
│ Type : ● Mensuel (-5% usure, 1.0 HT)        │
│        ○ Annuel (-15% usure, 2.0 HT + 500€) │
│                                              │
│ [Annuler]              [Entretenir]          │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Usure > 0 + HT OK + (si annuel: solde OK) |
| 🔘 Grisé "Matériel en parfait état" | `wear_pct = 0` |
| 🔘 Grisé "HT insuffisants" | HT < coût |
| 🔘 Grisé "Solde insuffisant (entretien annuel)" | Annuel + balance < 500 |

### → Backend

```
1-5. Vérifs
6. reduction = mensuel ? 5 : 15
7. UPDATE vehicle SET wear_pct = MAX(wear_pct - reduction, 0)
8. UPDATE player SET ht_today -= $ht, balance -= $cost (0 ou 500)
9. INSERT INTO ledger (si annuel)
10. COMMIT + WS
```

---

## Flux 3 : Réparer un matériel en panne

### Fiche matériel (is_broken=true) → bouton "Réparer"

```
┌─────────────────────────────────────────────┐
│ 🔧 Réparer — John Deere 6120M               │
│                                              │
│ État : EN PANNE 🔴                           │
│ Coût : 2 750 € (5% prix neuf) + 2.0 HT     │
│ Pièce détachée requise : ✅ (3/4 en stock)  │
│                                              │
│ Après réparation : usure ramenée à 50%       │
│                                              │
│ [Annuler]              [Réparer 2 750 €]     │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `is_broken=true` + solde + HT + pièce dispo |
| 🔘 Grisé "Pas en panne" | `is_broken = false` |
| 🔘 Grisé "Pièce détachée manquante" | `piece_count = 0` |
| 🔘 Grisé "Solde/HT insuffisants" | Solde < coût ou HT < 2.0 |

### → Backend

```
1-5. Vérifs
6. UPDATE vehicle SET is_broken=false, wear_pct=50
7. UPDATE vehicle_piece SET used=true WHERE vehicle_id=$1 AND used=false LIMIT 1
8. UPDATE player SET balance -= 2750, ht_today -= 2.0
9. INSERT INTO ledger ('maintenance', 'Réparation John Deere 6120M', -2750)
10. COMMIT + WS
```

---

## Flux 4 : Commander à l'ETA Cultivia (PNJ)

### Fiche parcelle → bouton "Appeler ETA Cultivia"

```
┌──────────────────────────────────────────────────────────────┐
│ 🚜 ETA Cultivia — Devis                                      │
│                                                               │
│ Parcelle : #1 (10 ha)                                         │
│ Travail : [Labourer ▼]                                       │
│                                                               │
│ Tarif ETA : 120 €/ha × 10 ha = 1 200 €                       │
│ (tarif joueur : ~800 € avec votre matériel)                   │
│ Surcoût ETA : +50% vs faire soi-même                          │
│                                                               │
│ HT : 1.0 (commande uniquement, ETA fait le travail)           │
│ Délai : immédiat                                              │
│                                                               │
│ ℹ️ L'ETA Cultivia est un service PNJ. Pas besoin de matériel. │
│                                                               │
│ [Annuler]              [Commander 1 200 €]                    │
└──────────────────────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= coût` + `ht >= 1.0` |
| 🔘 Grisé "Solde insuffisant" | `balance < coût` |
| 🔘 Grisé "HT insuffisants" | `ht < 1.0` |

### → Backend

```
1-5. Vérifs
6. Exécuter le travail immédiatement (même effet que si le joueur le faisait) :
   UPDATE parcel SET status = $next_status
   UPDATE parcel_soil (si engrais/traitement)
7. UPDATE player SET balance -= 1200, ht_today -= 1.0
8. INSERT INTO ledger ('purchase', 'ETA Cultivia — Labour parcelle #1', -1200)
9. COMMIT + WS
```

Pas d'usure matériel (c'est l'ETA qui utilise le sien).

---

## Flux 5 : Vendre un matériel

### Page `/equipment` → bouton "Vendre" sur un matériel

```
┌─────────────────────────────────────────────┐
│ 💰 Vendre — John Deere 6120M                │
│                                              │
│ Prix neuf : 55 000 €                         │
│ Usure : 15%                                  │
│ Argus : 55000 × (1-0.15) × 0.85 = 39 738 €  │
│ Prix vente coop : 39738 × 0.60 = 23 843 €    │
│                                              │
│ HT : 0.5                                    │
│                                              │
│ [Annuler]              [Vendre 23 843 €]     │
└─────────────────────────────────────────────┘
```

### → Backend

```
1-5. Vérifs
6. Calculer prix : prix_neuf × (1 - wear/100) × 0.85 × 0.60
7. UPDATE player SET balance += prix, ht_today -= 0.5
8. DELETE FROM vehicle WHERE id=$1
9. INSERT INTO ledger ('sale', 'Vente John Deere 6120M', +23843)
10. COMMIT + WS
```

---

## Dépendances + Tests

```
Sprint 11 → Sprint 12
  ├── Seed : vehicle_type (~30 types, 8 marques réelles)
  ├── Services : VehicleShopService, MaintenanceService, RepairService, EtaService, VehicleSellService
  ├── Routes : POST /vehicles/buy, /vehicles/:id/maintain, /repair, /sell, POST /eta/order
  ├── Pages : /equipment/shop, /equipment/:id
  └── Composants : VehicleCatalog, VehicleDetail, MaintenanceModal, RepairModal, EtaOrderModal, SellModal
```

Tests clés :
```
GIVEN joueur avec 55000€
WHEN POST /vehicles/buy { type: john_deere_6120m }
THEN vehicle créé, balance -= 55000, is_sheltered calculé

GIVEN matériel usure 15%
WHEN POST /vehicles/:id/maintain { type: monthly }
THEN wear = 10%, ht -= 1.0

GIVEN matériel en panne, 1 pièce dispo
WHEN POST /vehicles/:id/repair
THEN is_broken=false, wear=50%, pièce consommée, balance -= 2750

GIVEN parcelle à labourer, pas de charrue
WHEN POST /eta/order { work: plow, parcel_id }
THEN parcelle labourée, balance -= 1200 (tarif ETA +50%)
```
