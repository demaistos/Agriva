# Sprint 10 — Parcelles + Sol + Semis — Spec End-to-End

> Prérequis : Sprint 09. Économie, HT, météo fonctionnels.
> Ce sprint ajoute : achat parcelle, analyse sol, préparation, semis.

---

## Tables SQL nouvelles

```sql
parcel, parcel_soil, crop, seed_type (seed), crop_treatment
-- Modif : inventory (semences, engrais)
```

---

## Flux 1 : Acheter une parcelle

### Page `/parcels/buy`

```
┌─────────────────────────────────────────────────────────────────┐
│ 🌾 Acheter une parcelle                                         │
│ Type : [● Champ] [○ Pré]                                       │
│ Préfecture : [Clermont-Ferrand ▼] (distance: 0 km)             │
│ Surface : [____10____] ha (1-100, pas de 1)                     │
│                                                                 │
│ Prix : 10 ha × 1 500 €/ha = 15 000 €                           │
│ HT : 2.0                                                       │
│ Qualité sol : aléatoire (25% ⭐, 50% ⭐⭐, 25% ⭐⭐⭐)         │
│                                                                 │
│ [Annuler]              [Acheter 15 000 €]                       │
└─────────────────────────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= prix` + `ht >= 2.0` + surface valide |
| 🔘 Grisé "Solde insuffisant" | `balance < prix` |
| 🔘 Grisé "HT insuffisants" | `ht < 2.0` |

### → Backend

```
1-5. Vérifs standard + FOR UPDATE
6. Générer qualité sol : random weighted (Q1:25%, Q2:50%, Q3:25%)
7. Générer 6 nutriments : N,P,K,Ca,Mg,S = random(20,80) pondéré par qualité
8. Générer altitude : random(50,800) selon département
9. Générer inclinaison : random(0,15)
10. INSERT INTO parcel (farm_id, prefecture_id, type, size_ha, quality, altitude, inclination, status='fallow')
11. INSERT INTO parcel_soil (parcel_id, n, p, k, ca, mg, s, last_analysis, fatigue_index=0)
12. UPDATE player SET balance -= prix, ht_today -= 2.0
13. INSERT INTO ledger
14. COMMIT + WS
```

---

## Flux 2 : Voir liste parcelles (`/parcels`)

### Écran — 5 onglets

```
┌─────────────────────────────────────────────────────────────────┐
│ 🌾 Mes parcelles [1 parcelle — 10 ha] [⚠️ 1 non travaillée]    │
│ [Acheter une parcelle]                                          │
│ [Culture] [Sol] [Eau] [Animaux] [Haie]                          │
├─────────────────────────────────────────────────────────────────┤
│ Onglet CULTURE :                                                │
│ ☐ | ID/Nom    | Localisation      | Culture | Pousse | Surface │
│ ☐ | #1        | Clermont-Fd (0km) | Jachère | —      | 10 ha   │
│                                                                 │
│ Actions groupées : [Jachère] [Choisir culture] [Appeler ETA]   │
│                    [Analyser sol] [Ordonner]                    │
└─────────────────────────────────────────────────────────────────┘
```

Chaque onglet a ses colonnes spécifiques (voir audit UX §3.1).

---

## Flux 3 : Analyser le sol

### Fiche parcelle `/parcels/:id` → bouton "Analyser le sol"

```
┌─────────────────────────────────────────────┐
│ 🧪 Analyser le sol — Parcelle #1            │
│                                              │
│ Coût : 50 € + 0.5 HT                        │
│ Résultat : valeurs exactes N,P,K,Ca,Mg,S    │
│ Validité : 5 saisons (105 jours)             │
│                                              │
│ Dernière analyse : Jamais                    │
│                                              │
│ [Annuler]              [Analyser 50 €]       │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | `balance >= 50` + `ht >= 0.5` + pas d'analyse récente |
| 🔘 Grisé "Analyse encore valide (expire dans {X}j)" | `last_analysis + 105j > today` |
| 🔘 Grisé "Solde/HT insuffisants" | Solde < 50 ou HT < 0.5 |

### → Backend

```
1-5. Vérifs + FOR UPDATE
6. UPDATE parcel_soil SET last_analysis = NOW(), analysis_expires = NOW() + 105 days
   -- Les valeurs N,P,K,Ca,Mg,S existent déjà, l'analyse les rend visibles
7. UPDATE player SET balance -= 50, ht_today -= 0.5
8. INSERT INTO ledger
9. COMMIT + WS
```

### ← Frontend

Jauges sol passent de mode "approximatif" (3 paliers colorés) à mode "précis" (valeurs numériques).

---

## Flux 4 : Préparer le sol (déchaumer → labourer → herser)

3 actions séquentielles, même pattern. Exemple pour labourer :

### Fiche parcelle → bouton "Labourer"

```
┌─────────────────────────────────────────────┐
│ 🚜 Labourer — Parcelle #1 (10 ha)           │
│                                              │
│ Matériel : Tracteur ✅ + Charrue ❌          │
│ HT : 10 ha × 0.8 = 8.0 HT                  │
│ HVC : 10 ha × 2.5 = 25 L                    │
│                                              │
│ ⚠️ Charrue requise — achetez-en une          │
│ [Aller au catalogue matériel]                │
│                                              │
│ [Annuler]              [Labourer] (grisé)    │
└─────────────────────────────────────────────┘
```

**Bouton — États :**

| État | Condition |
|------|-----------|
| ✅ Actif | Tracteur OK + outil OK + HT OK + HVC OK + parcelle en bon état |
| 🔘 Grisé "Tracteur requis" | Pas de tracteur fonctionnel |
| 🔘 Grisé "{outil} requis" | Pas de charrue/cultivateur/herse |
| 🔘 Grisé "Puissance insuffisante ({X}ch requis, tracteur {Y}ch)" | Tracteur trop faible |
| 🔘 Grisé "HT insuffisants (besoin {X})" | HT < coût |
| 🔘 Grisé "HVC insuffisant (besoin {X}L)" | HVC < consommation |
| 🔘 Grisé "Déchaumez d'abord" | Étape précédente pas faite |

### → Backend (même pattern pour les 3)

```
1. Vérifs : ownership, état parcelle, matériel, puissance, HT, HVC
2. BEGIN + FOR UPDATE player + inventory(hvc)
3. UPDATE player SET ht_today -= $ht
4. UPDATE inventory SET quantity -= $hvc WHERE product='hvc'
5. UPDATE parcel SET status = $next_status (stubbled → plowed → harrowed)
6. UPDATE vehicle SET wear_pct += $wear WHERE id=$tractor (et outil)
7. COMMIT + WS
```

---

## Flux 5 : Semer

### Fiche parcelle (état: harrowed) → bouton "Semer"

```
┌──────────────────────────────────────────────────────────────┐
│ 🌱 Semer — Parcelle #1 (10 ha)                               │
│                                                               │
│ Culture : [Blé ▼]                                            │
│ Semence : ● Standard (150 €/ha) ○ Certifiée (225 €/ha, +10%)│
│                                                               │
│ Saison actuelle : Printemps ✅ (blé semable au printemps)     │
│                                                               │
│ Coût semences : 10 ha × 150 = 1 500 €                        │
│ HT : 10 ha × 0.5 = 5.0 HT                                   │
│ HVC : 10 ha × 1.5 = 15 L                                     │
│ Matériel : Tracteur ✅ + Semoir ❌                            │
│                                                               │
│ [Annuler]              [Semer 1 500 €] (grisé: semoir)       │
└──────────────────────────────────────────────────────────────┘
```

**Bouton — États :** Même pattern que labourer + vérif saison + vérif semoir.

### → Backend

```
1-5. Vérifs (matériel, saison, HT, HVC, solde)
6. BEGIN + FOR UPDATE
7. INSERT INTO crop (parcel_id, seed_type_id, seed_quality, sow_date, growth_pct=0, status='growing')
8. UPDATE parcel SET status='sown'
9. UPDATE player SET balance -= 1500, ht_today -= 5.0
10. UPDATE inventory SET quantity -= 15 WHERE product='hvc'
11. UPDATE vehicle SET wear_pct += ... (tracteur + semoir)
12. INSERT INTO ledger
13. COMMIT + WS: parcel_alert
```

### Tick quotidien — Croissance

```
Pour chaque crop WHERE status='growing' :
  growth_increment = base_growth × weather_factor × soil_factor × seed_factor
  UPDATE crop SET growth_pct = MIN(growth_pct + growth_increment, 100)
  Si growth_pct >= 100 : UPDATE crop SET status='mature', UPDATE parcel SET status='ready_harvest'
  Notification "🌾 Parcelle #1 : blé prêt à récolter !"
```

---

## Dépendances + Tests

```
Sprint 09 → Sprint 10
  ├── Tables : parcel, parcel_soil, crop, seed_type
  ├── Services : ParcelService, SoilService, CropService
  ├── Worker : tick croissance cultures
  ├── Routes : POST /parcels/buy, /parcels/:id/analyze-soil, /prepare, /sow
  ├── Pages : /parcels, /parcels/buy, /parcels/:id
  └── Composants : ParcelTable (5 onglets), SoilGauges, CropProgress, SowModal
```
