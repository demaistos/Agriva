# UX Phase 2 — Élevage Bovins

> Spécifications UX exhaustives pour chaque action élevage.
> Composants réutilisés : `DataTable`, `Toast`, `ConfirmModal`, `Spinner`, `PageToolbar`.
> Convention boutons : vert = actif, gris + tooltip = désactivé avec raison.

---

## 1. Acheter un animal à la coopérative

### Prérequis visibles
- Bandeau info en haut : jour actuel du serveur + type marché (🟢 "Marché régional — Jour 1" ou 🔵 "Marché national — Jour 3")
- HT restants affichés dans le header
- Solde affiché dans le header
- Si jour non-marché : page affiche "La coopérative est fermée aujourd'hui. Prochaine ouverture : Jour X (régional/national)"

### Écran (layout)
```
┌─────────────────────────────────────────────────┐
│ PageToolbar: "Coopérative bovine"               │
│ [Jour 2 — Marché régional 🟢]                   │
├──────────┬──────────────────────────────────────┤
│ Filtres  │  Catalogue animaux                    │
│ ┌──────┐ │  DataTable:                           │
│ │Espèce│ │  Race | Sexe | Âge | Poids | Prix |  │
│ │Race  │ │  Génétique (5 barres) | [Acheter]    │
│ │Sexe  │ │                                       │
│ └──────┘ │                                       │
├──────────┴──────────────────────────────────────┤
│ ⚠️ Rappel : bétaillère + tracteur requis         │
└─────────────────────────────────────────────────┘
```

### Bouton "Acheter" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Jour marché + solde suffisant + bétaillère possédée + place en bâtiment |
| 🔘 Grisé | Gris + tooltip "Solde insuffisant (besoin X €)" | `player.balance < prix_animal` |
| 🔘 Grisé | Gris + tooltip "Bétaillère requise" | Pas de bétaillère dans l'inventaire matériel |
| 🔘 Grisé | Gris + tooltip "Aucun bâtiment avec place disponible" | Tous les bâtiments bovins pleins |
| 🔘 Grisé | Gris + tooltip "Tracteur requis" | Pas de tracteur |
| 🚫 Masqué | Bouton absent | Jour non-marché (page fermée) |

### Contrôles frontend
- Vérifier `server.current_day` → jour marché valide (1,2,4,5 = régional / 3,6,7 = national)
- Vérifier `player.balance >= animal.price`
- Vérifier possession bétaillère via `GET /api/equipment?type=livestock_trailer`
- Vérifier capacité bâtiment via `GET /api/buildings?type=stabulation&has_space=true`

### Appel API
```
POST /api/animals/buy
Body: { breed_id: number, sex: 'M'|'F', building_id: number }
```

### Contrôles backend
1. Jour marché valide (sinon 400 "Coopérative fermée")
2. Race existe et disponible ce jour
3. `player.balance >= prix` (sinon 400 "Solde insuffisant")
4. Joueur possède bétaillère (sinon 400 "Bétaillère requise")
5. Joueur possède tracteur (sinon 400 "Tracteur requis")
6. `building_id` appartient au joueur, type stabulation, place disponible (sinon 400 "Bâtiment plein")
7. HT suffisants ≥ 0.5 (sinon 400 "PA insuffisants")

### Résultat succès
- Toast vert : "🐄 Prim'Holstein achetée — 1 200 € débités"
- Solde header mis à jour (animation -X €)
- HT header mis à jour (-0.5)
- Redirection vers fiche animal OU retour catalogue avec ligne surlignée "Acheté ✓"
- Notification push si activée

### Résultat erreur
- Toast rouge avec message backend exact
- Bouton repasse actif (pas de double-clic : désactivé pendant l'appel API, `loading=true`)

### Effets de bord
- `player.balance -= prix`
- `player.pa -= 0.5`
- Animal créé en DB avec génétique aléatoire (indices 40-60)
- `building.animal_count += 1`
- Entrée `ledger` (relevé bancaire)
- Stock grossiste décrémenté (si applicable)

---

## 2. Voir ses animaux

### Prérequis visibles
- Au moins 1 animal possédé (sinon : message vide "Vous n'avez aucun animal. [Aller à la coopérative]")

### Écran (layout)
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Mes animaux" [Total: 47 bovins]                   │
├─────────────────────────────────────────────────────────────────┤
│ 📊 TABLEAU DE BORD ÉLEVAGE                                      │
│ ┌──────────────┬──────────────┬──────────────┬────────────────┐ │
│ │🍽️ Pas nourris │💧Pas abreuvés│🏥 Malades     │💀 Morts du jour│ │
│ │ 3 ⚠️          │ 0 ✅         │ 1 🔴 [Soigner│ 0              │ │
│ │               │              │     tous]    │                │ │
│ ├──────────────┼──────────────┼──────────────┼────────────────┤ │
│ │🤰 Naissances  │📥 En arrivage│🐄 Au pré      │💧 Eau           │
│ │ à venir: 2   │ 3 [Placer   │ 12           │ Besoin: 200L   │
│ │              │     auto]    │              │ Dispo: 500L ✅ │
│ └──────────────┴──────────────┴──────────────┴────────────────┘ │
│ ℹ️ Insémination : Les vaches sont inséminables ce mois.         │
├─────────┬───────────────────────────────────────────────────────┤
│ Filtres │  DataTable paginée (20/page)                          │
│ ┌─────┐ │                                                       │
│ │Lieu │ │  ☐ | Nom | Race | Sexe | Âge | Poids | Lieu |        │
│ │(bât/│ │  🩺Santé | 🍽️Nourri | 💧Abreuvé | [Voir]             │
│ │ pré)│ │                                                       │
│ │Race │ │  Icônes par ligne :                                   │
│ │Sexe │ │  ❤️100 🟢 | ❤️60 🟡 | ❤️30 🔴                        │
│ │Âge  │ │  🍽️✅ nourri | 🍽️❌ pas nourri                        │
│ │Stade│ │  💧✅ abreuvé | 💧❌ pas abreuvé                       │
│ │État │ │  🤰 gestante | 🍼 allaitante | 🏥 malade              │
│ │(nour│ │  💉 vacciné                                            │
│ │ri/  │ │                                                       │
│ │mal.)│ │  Sélection multiple : ☐ pour actions groupées         │
│ └─────┘ │                                                       │
│ Tri:    │  Actions groupées (sur sélection) :                   │
│ [Nom]   │  [Nourrir] [Abreuver] [Soigner] [Mettre au pré]      │
│ [Âge]   │  [Rentrer en bâtiment] [Vendre abattoir]              │
│ [Poids] │                                                       │
│ [Santé] │                                                       │
└─────────┴───────────────────────────────────────────────────────┘
```

### Tableau de bord élevage — Boutons

| Bouton | Action | Condition actif | Condition grisé |
|--------|--------|----------------|-----------------|
| Soigner tous | `POST /api/animals/batch-heal` | Malades > 0 | 0 malades |
| Placer auto | `POST /api/animals/auto-place` | En arrivage > 0 | 0 en arrivage, ou 0 place en bâtiment → tooltip |
| Nourrir (groupé) | `POST /api/animals/batch-feed` | Sélection > 0 + stock aliment | Sélection vide ou stock = 0 |
| Abreuver (groupé) | `POST /api/animals/batch-water` | Sélection > 0 + eau dispo | Sélection vide ou eau = 0 |
| Soigner (groupé) | `POST /api/animals/batch-heal` | Sélection > 0 + malades dans sélection | Aucun malade sélectionné |
| Mettre au pré | `POST /api/animals/batch-move` | Sélection > 0 + pré avec place | Pas de pré ou pas de place |
| Rentrer bâtiment | `POST /api/animals/batch-move` | Sélection > 0 + bâtiment avec place | Pas de bâtiment ou pas de place |
| Vendre abattoir | `POST /api/animals/batch-slaughter` | Sélection > 0 → ConfirmModal | Sélection vide |

### Filtres animaux
- Lieu : Tous / Bâtiment X / Pré Y (dropdown)
- Race : Tous / Prim'Holstein / Charolaise / Montbéliarde...
- Sexe : Tous / Mâle / Femelle
- Âge/Stade : Tous / Veau / Génisse / Vache / Taurillon / Taureau
- État : Tous / Pas nourri / Pas abreuvé / Malade / Gestante

### Bouton "Voir" (fiche) — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Lien bleu | Toujours (animal vivant) |
| 🔘 Grisé | Gris + barré | `life_stage = 'dead'` — ligne grisée entière |

### Contrôles frontend
- Appel `GET /api/animals?species=cattle` au montage
- Filtres appliqués côté client (ou query params si > 100 animaux)
- Tri par colonne cliquable (asc/desc)
- Pagination 20 items

### Appel API
```
GET /api/animals?species=cattle&building_id=X&breed_id=X&sex=M&life_stage=adult&page=1&limit=20
```

### Contrôles backend
1. `farm_id` = ferme du joueur authentifié
2. Filtres validés (breed_id existe, sex ∈ {M,F}, life_stage valide)

### Résultat succès
- DataTable remplie, icônes colorées selon état
- Compteur total en toolbar
- Filtres actifs affichés en tags cliquables (× pour retirer)

### Résultat erreur
- Toast rouge "Erreur chargement animaux"
- Spinner remplacé par message retry

### Effets de bord
- Aucun (lecture seule, 0 HT)

---

## 3. Consulter fiche animal (`/animals/:id`)

### Prérequis visibles
- Animal existant et appartenant au joueur. Clic sur [Voir] dans la DataTable.

### Écran (layout) — Adapté par espèce

La fiche s'adapte selon l'espèce. Voici le layout complet avec les sections conditionnelles.

```
┌──────────────────────────────────────────────────────────────────┐
│ ← Retour liste | Fiche #{matricule} — "Marguerite" ✏️           │
│                                        [⭐ Favori] [📸 Capture]  │
├─────────────────────┬────────────────────────────────────────────┤
│ IDENTITÉ            │ GÉNÉTIQUE                                  │
│                     │                                            │
│ Matricule: 24595547 │ Croissance   ████████░░ 78 (+17)          │
│ Race: Prim'Holstein │ Lait         █████████░ 91 (+14)          │
│  └ Type: Laitière   │ Qualité Lait ███████░░░ 72 (+12)          │
│ Sexe: ♀ Femelle     │ Prolificité  █████░░░░░ 52 (+21)          │
│ Âge: 3 ans 6 mois   │ Allure       ██████░░░░ 63 (+18)          │
│  └ Né(e): 1 Oct S89 │                                            │
│ Poids: 689.1 kg     │ Somme: 356/500                            │
│ Lieu: Stabulation 1 │ [Voir généalogie]                          │
│                     │                                            │
│ Parents:            │ Chaque barre affiche:                      │
│  Mère: #23920695    │  - Valeur actuelle (gras)                  │
│  Père: GOITU #23920130│ - Min/Max de la race (bornes grises)     │
│  (liens cliquables) │  - Delta vs moyenne race (+X en vert/-X rouge)│
├─────────────────────┼────────────────────────────────────────────┤
│ SANTÉ               │ ALIMENTATION                               │
│                     │                                            │
│ Santé globale:      │ 🍽️ Nourri: ✅ (×1 aujourd'hui)             │
│  ❤️ 95/100 ████████▓░│ Ration: Foin+Maïs ensilé (★★★)           │
│ Santé nourriture:   │                                            │
│  100% ██████████    │ 💧 Abreuvé: ✅                              │
│ Santé eau:          │ Eau consommée: 45 L                        │
│  100% ██████████    │                                            │
│                     │ 🛏️ Litière: ✅ (paille fraîche)             │
│ 💉 Vaccin: ✅        │                                            │
│  Expire dans 62j    │                                            │
│ 🏥 Malade: Non      │                                            │
│ Remises en vie: 0   │                                            │
├─────────────────────┴────────────────────────────────────────────┤
│ PRODUCTION (section conditionnelle selon espèce)                 │
│                                                                  │
│ [Si bovin laitier]                                               │
│ 🥛 Lait: 32.4 L/jour | Qualité: ⭐⭐⭐⭐ (QL: 78)               │
│ Traites totales: 45 | Dernière traite: aujourd'hui 08:00         │
│                                                                  │
│ [Si bovin allaitant]                                             │
│ 🥩 Classification carcasse: A3-B4                                │
│ Conformation: A (Excellente) — muscles exceptionnels, profils convexes│
│ Engraissement: 3 (Moyen) — muscles presque partout couverts      │
│                                                                  │
│ [Si volaille]                                                    │
│ 🥚 Œufs: 1/jour (ponte active) | Total pondu: 142               │
│ Dernière ponte: aujourd'hui                                      │
│ Couvaison: Non                                                   │
│                                                                  │
│ [Si ovin]                                                        │
│ 🧶 Laine: 4.2 kg/tonte | Dernière tonte: Mois 2                 │
│ Prochaine tonte possible: Mois 8                                 │
├──────────────────────────────────────────────────────────────────┤
│ REPRODUCTION                                                     │
│                                                                  │
│ 🤰 Gestante: Non | Dernière mise bas: 15 Mars An 1               │
│ Historique naissances: 3 petits (2♀ 1♂)                          │
│ Période insémination: Toute l'année (bovins)                     │
│ [Voir arbre généalogique]                                        │
├──────────────────────────────────────────────────────────────────┤
│ PRIX / RÉCOMPENSES (si applicable)                               │
│                                                                  │
│ 🏆 1er Vache (Génétique) — 394.16 pts                            │
│ 🏆 1er Veau femelle (Génétique) — 148.05 pts                     │
│ 🥉 4ème Génisse (Poids) — 689.1 kg                               │
├──────────────────────────────────────────────────────────────────┤
│ HISTORIQUE PROPRIÉTAIRES                                         │
│                                                                  │
│ Propriétaire | Acquisition      | Cession                        │
│ Vous         | Né(e) à la ferme | Propriétaire actuel            │
├──────────────────────────────────────────────────────────────────┤
│ ACTIONS (boutons contextuels selon espèce + état)                │
│                                                                  │
│ [Nourrir]  [Abreuver]  [Soigner]  [Vacciner]                    │
│ [Traire]*  [Inséminer]* [Déplacer] [Renommer]                   │
│ [Vendre abattoir]  [Vendre à un joueur]*                         │
│                                                                  │
│ * = conditionnel selon espèce/état                               │
└──────────────────────────────────────────────────────────────────┘
```

### Sections conditionnelles par espèce

| Section | Bovin laitier | Bovin allaitant | Volaille | Ovin | Caprin |
|---------|:---:|:---:|:---:|:---:|:---:|
| Lait (production + QL) | ✅ | ❌ | ❌ | ❌ | ✅ |
| Classification carcasse | ❌ | ✅ | ❌ | ❌ | ❌ |
| Œufs | ❌ | ❌ | ✅ | ❌ | ❌ |
| Laine | ❌ | ❌ | ❌ | ✅ | ❌ |
| Bouton Traire | ✅ | ❌ | ❌ | ❌ | ✅ |
| Bouton Inséminer | ✅ (si ♀) | ✅ (si ♀) | ❌ (couvaison auto) | ✅ (si ♀) | ✅ (si ♀) |
| Bouton Tondre | ❌ | ❌ | ❌ | ✅ | ❌ |
| Génétique 5 indices | ✅ | ✅ | ✅ (indices différents) | ✅ | ✅ |

### Indices génétiques par espèce

| Espèce | Indice 1 | Indice 2 | Indice 3 | Indice 4 | Indice 5 |
|--------|----------|----------|----------|----------|----------|
| Bovin laitier | Croissance | Lait | Qualité Lait | Prolificité | Allure |
| Bovin allaitant | Croissance | Conformation | Engraissement | Prolificité | Allure |
| Volaille | Croissance | Ponte | Qualité Œuf | Prolificité | Allure |
| Ovin | Croissance | Laine | Qualité Laine | Prolificité | Allure |
| Caprin | Croissance | Lait | Qualité Lait | Prolificité | Allure |

### Boutons actions — États détaillés

| Bouton | Visible si | Actif si | Grisé + tooltip si |
|--------|-----------|---------|-------------------|
| Nourrir | Toujours | `last_fed_at < today` + stock + HT ≥ 0.5 | "Déjà nourri" / "Stock insuffisant" / "HT insuffisants" |
| Abreuver | Toujours | `last_watered_at < today` + eau dispo + HT ≥ 0.3 | "Déjà abreuvé" / "Pas d'eau" / "HT insuffisants" |
| Soigner | `health_status = 'sick'` | Solde ≥ coût + HT ≥ coût_ht | "Solde insuffisant" / "HT insuffisants" |
| Vacciner | Toujours | `last_vaccinated_at < season_start` + solde ≥ 50 + HT ≥ 0.5 | "Déjà vacciné cette saison" / "Solde/HT insuffisants" |
| Traire | Espèce laitière + ♀ + en lactation | Salle traite + cuve non pleine + HT ≥ 0.5 + `last_milked_at < today` | "Pas de salle de traite" / "Cuve pleine" / "Déjà traite" |
| Inséminer | ♀ + espèce compatible | En période + pas gestante + HT ≥ 1.0 | "Hors période" / "Déjà gestante" / "HT insuffisants" |
| Déplacer | Toujours | Destination avec place + HT ≥ coût | "Aucun lieu avec place" / "HT insuffisants" |
| Renommer | Toujours | Toujours (gratuit) | — |
| Vendre abattoir | Toujours | Bétaillère + HT ≥ 0.5 | "Bétaillère requise" / "HT insuffisants" |
| Vendre joueur | Phase 3+ | Annonce créée | "Disponible en Phase 3" |
| Tondre | Ovin uniquement | Saison OK + `last_sheared_at` > 6 mois + HT ≥ 0.5 | "Tonte récente" / "Mauvaise saison" |

### Contrôles frontend
- `GET /api/animals/:id` au montage → remplit toutes les sections
- `GET /api/animals/:id/pedigree?depth=1` → parents (liens cliquables)
- Barres génétique : `width = (valeur / 100)%`, couleur gradient rouge→jaune→vert
- Delta affiché : `valeur - moyenne_race` → vert si positif, rouge si négatif
- Sections conditionnelles rendues via `v-if` selon `animal.species` et `animal.breed_type`
- Boutons : chaque bouton appelle `GET /api/animals/:id/available-actions` pour connaître l'état

### Appel API
```
GET /api/animals/:id
```
```json
{
  "id": 24595547,
  "name": "Marguerite",
  "species": "cattle",
  "breed": { "id": 1, "name": "Prim'Holstein", "type": "dairy" },
  "sex": "F",
  "age_months": 42,
  "birth_date": { "day": 1, "month": 10, "season": 89 },
  "weight_kg": 689.1,
  "life_stage": "adult",
  "building": { "id": 5, "name": "Stabulation 1" },
  "health": {
    "global": 95,
    "food": 100,
    "water": 100,
    "is_sick": false,
    "disease": null,
    "vaccine_expires_in_days": 62,
    "revivals": 0
  },
  "feeding": {
    "fed_today": true,
    "fed_count": 1,
    "ration": "Foin+Maïs ensilé",
    "ration_quality": 3,
    "watered_today": true,
    "water_consumed_l": 45,
    "bedding_ok": true
  },
  "genetics": {
    "indices": [
      { "name": "Croissance", "value": 78, "min": 13, "max": 80, "race_avg": 61, "delta": 17 },
      { "name": "Lait", "value": 91, "min": 21, "max": 74, "race_avg": 77, "delta": 14 },
      { "name": "Qualité Lait", "value": 72, "min": 24, "max": 87, "race_avg": 60, "delta": 12 },
      { "name": "Prolificité", "value": 52, "min": 34, "max": 86, "race_avg": 31, "delta": 21 },
      { "name": "Allure", "value": 63, "min": 25, "max": 84, "race_avg": 45, "delta": 18 }
    ],
    "total": 356
  },
  "production": {
    "type": "milk",
    "daily_liters": 32.4,
    "quality_index": 78,
    "total_milkings": 45,
    "last_milked_at": "2026-04-05T08:00:00Z"
  },
  "reproduction": {
    "is_pregnant": false,
    "last_birth_date": "2026-03-15",
    "total_offspring": 3,
    "offspring_sexes": { "F": 2, "M": 1 },
    "insemination_period": "year_round"
  },
  "carcass": null,
  "awards": [
    { "rank": 1, "category": "Vache (Génétique)", "score": 394.16 },
    { "rank": 4, "category": "Génisse (Poids)", "score": 689.1 }
  ],
  "parents": {
    "mother": { "id": 23920695, "name": null },
    "father": { "id": 23920130, "name": "GOITU DU HAUT PLATEAU" }
  },
  "ownership_history": [
    { "owner": "Vous", "acquired": "Né(e) à la ferme", "sold": null }
  ],
  "available_actions": [
    { "action": "feed", "possible": false, "reason": "Déjà nourri aujourd'hui" },
    { "action": "water", "possible": false, "reason": "Déjà abreuvé aujourd'hui" },
    { "action": "heal", "possible": false, "reason": "Pas malade" },
    { "action": "vaccinate", "possible": true, "cost_eur": 50, "cost_ht": 0.5 },
    { "action": "milk", "possible": false, "reason": "Déjà traite aujourd'hui" },
    { "action": "inseminate", "possible": true, "cost_eur": 0, "cost_ht": 1.0, "details": "Mâle ferme" },
    { "action": "move", "possible": true, "cost_ht": 0.3 },
    { "action": "slaughter", "possible": true, "cost_ht": 0.5, "estimated_eur": 2748 },
    { "action": "rename", "possible": true }
  ]
}
```

### Contrôles backend
1. `animal.farm_id = player.farm_id` (sinon 403)
2. Animal non supprimé (sinon 404)
3. `available_actions` calculé dynamiquement selon état animal + inventaire joueur + date

### Résultat succès
- Fiche complète affichée
- Barres génétique animées au chargement (0 → valeur en 500ms)
- Sections conditionnelles rendues selon espèce
- Boutons colorés selon état (vert actif, gris désactivé avec tooltip)
- Parents cliquables → navigation vers `/animals/:parent_id` (ou popup si vendu/mort)

### Résultat erreur
- 404 → redirection `/animals` + Toast "Animal introuvable"
- 403 → Toast "Cet animal ne vous appartient pas"

### Effets de bord
- Aucun (lecture seule, 0 HT)

### Boutons actions — États
Chaque bouton suit les règles de son action dédiée (sections 4-19). Sur cette fiche, ils sont tous visibles mais grisés si prérequis non remplis, avec tooltip explicatif.

### Contrôles frontend
- `GET /api/animals/:id` au montage
- Barres génétique : `width = indice%`, couleur gradient rouge→jaune→vert

### Appel API
```
GET /api/animals/:id
GET /api/animals/:id/health-log (onglet historique)
GET /api/animals/:id/genetics
```

### Contrôles backend
1. Animal appartient au joueur
2. Animal vivant (`life_stage != 'dead'`)

### Résultat succès
- Fiche complète affichée
- Barres génétique animées au chargement
- Icônes santé/alimentation colorées en temps réel

### Résultat erreur
- 404 → redirection liste avec Toast "Animal introuvable"
- 403 → Toast "Cet animal ne vous appartient pas"

### Effets de bord
- Aucun (lecture seule, 0 HT)

---

## 4. Nourrir ses animaux

### Prérequis visibles
- Au moins 1 animal vivant dans le bâtiment sélectionné
- Stock aliments visible (quantités en stock vs besoin affiché)
- HT restants ≥ coût affiché

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Nourrir — Stabulation 1" (12 animaux)  │
├──────────────────────────────────────────────────────┤
│ RATION DE BASE (sélection radio)                      │
│ ○ Foin + Maïs ensilé    Besoin: 2 028 kg  Stock: ✅  │
│ ○ Paille + Maïs ensilé  Besoin: 1 644 kg  Stock: ✅  │
│ ○ Paille + Betterave    Besoin: 1 932 kg  Stock: ❌  │
│   └─ ⚠️ Manque 400 kg betterave                      │
│ ○ ... (10 options)                                    │
├──────────────────────────────────────────────────────┤
│ COMPLÉMENTS (auto-calculés par tranche d'âge)         │
│ Orge/blé/triticale: 86.4 kg  Stock: 500 kg ✅        │
│ Tourteau colza/soja: 57.6 kg  Stock: 200 kg ✅       │
│ Minéraux & vitamines: 12 kg   Stock: 50 kg ✅        │
├──────────────────────────────────────────────────────┤
│ MÉTHODE                                               │
│ ○ Tracteur + Désileuse (PA: 0.5)  ✅ Matériel dispo  │
│ ○ Manuel (PA: 2.0)                                    │
├──────────────────────────────────────────────────────┤
│ RÉSUMÉ                                                │
│ Animaux: 12 | Qualité ration: ★★★ | PA: 0.5          │
│                                    [Nourrir 🍽️]       │
└──────────────────────────────────────────────────────┘
```

### Bouton "Nourrir" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Ration sélectionnée + stock OK + méthode choisie + HT suffisants |
| 🔘 Grisé | Tooltip "Sélectionnez une ration" | Aucune ration cochée |
| 🔘 Grisé | Tooltip "Stock insuffisant : manque X kg de Y" | Stock < besoin pour un composant |
| 🔘 Grisé | Tooltip "PA insuffisants (besoin X, reste Y)" | `player.pa < pa_cost` |
| 🔘 Grisé | Tooltip "Tracteur requis pour désileuse" | Méthode désileuse sans tracteur |
| 🔘 Grisé | Tooltip "Désileuse requise" | Méthode désileuse sans désileuse |
| 🔘 Grisé | Tooltip "Animaux déjà nourris aujourd'hui" | Tous nourris (`last_fed_at = today`) |

### Contrôles frontend
- Charger rations disponibles `GET /api/rations?species=cattle&age_group=...`
- Calculer besoin total = somme par tranche d'âge × nb animaux par tranche
- Comparer avec `GET /api/farm/:id/inventory` pour chaque composant
- Afficher ✅/❌ par ligne de composant
- Qualité = min(qualité de chaque composant en stock)
- Désactiver options ration dont stock insuffisant (mais les laisser visibles barrées)

### Appel API
```
POST /api/buildings/:id/feed
Body: { ration_id: number, use_desilage: boolean }
```

### Contrôles backend
1. Bâtiment appartient au joueur
2. Animaux vivants présents
3. Ration valide pour l'espèce
4. Stock suffisant pour chaque composant (sinon 400 + composant manquant)
5. Matériel requis si `use_desilage=true` (tracteur + désileuse)
6. HT suffisants
7. Animaux pas déjà nourris aujourd'hui

### Résultat succès
- Toast vert : "🍽️ 12 animaux nourris — Ration Foin+Maïs ★★★"
- Stock mis à jour dans l'affichage (animation -X kg)
- HT mis à jour dans le header
- Icônes 🍽️ passent de ❌ à ✅ sur la liste animaux
- Bouton passe à grisé "Déjà nourris aujourd'hui"

### Résultat erreur
- Toast rouge avec détail : "Stock insuffisant : manque 400 kg de betterave"
- Aucune déduction (transaction atomique)

### Effets de bord
- `inventory[composant] -= quantité` pour chaque composant
- `player.pa -= pa_cost`
- `animal.last_fed_at = now()` pour chaque animal
- `animal_feeding_log` créé
- Qualité ration impacte croissance au prochain tick

---

## 5. Nourrir automatique 15 jours

### Prérequis visibles
- Même écran que "Nourrir" (action 4) avec toggle supplémentaire
- Affichage stock requis × 15 jours vs stock actuel

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ NOURRISSAGE AUTOMATIQUE                               │
│ ┌──────────────────────────────────────────────────┐ │
│ │ ⚙️ Activer pour 15 jours                    [ON] │ │
│ └──────────────────────────────────────────────────┘ │
│                                                       │
│ Ration sélectionnée: Foin + Maïs ensilé               │
│                                                       │
│ STOCK REQUIS (15 jours × 12 animaux)                  │
│ Foin:        16 200 kg  Stock: 20 000 kg ✅           │
│ Maïs ensilé: 18 900 kg  Stock: 15 000 kg ❌          │
│   └─ ⚠️ Stock suffisant pour 11 jours seulement      │
│ Compléments: 2 925 kg   Stock: 5 000 kg ✅           │
│                                                       │
│ HT auto-déduits: 0.5/jour × 15 = 7.5 HT              │
│ (déduits quotidiennement, pas en une fois)            │
│                                                       │
│                        [Activer nourrissage auto 🔄]  │
└──────────────────────────────────────────────────────┘
```

### Bouton "Activer nourrissage auto" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Ration sélectionnée + stock ≥ 15j + matériel OK |
| 🔘 Grisé | Tooltip "Stock insuffisant pour 15 jours (assez pour Xj)" | Stock < besoin × 15 |
| 🔘 Grisé | Tooltip "Sélectionnez une ration d'abord" | Pas de ration |
| 🔘 Grisé | Tooltip "Nourrissage auto déjà actif (Xj restants)" | Déjà activé |
| 🟠 Orange | "Désactiver nourrissage auto" | Auto actif → bouton bascule |

### Contrôles frontend
- Calculer `besoin_total = besoin_journalier × 15`
- Pour chaque composant : `jours_possibles = floor(stock / besoin_journalier)`
- Afficher le nombre de jours couverts si < 15
- HT affichés comme "déduits quotidiennement" (pas en bloc)

### Appel API
```
POST /api/buildings/:id/auto-feed
Body: { ration_id: number, duration_days: 15, use_desilage: boolean }
```
```
DELETE /api/buildings/:id/auto-feed  (désactivation)
```

### Contrôles backend
1. Mêmes vérifs que nourrir manuel (action 4)
2. Stock suffisant pour 15 jours complets (sinon 400 + nb jours possibles)
3. Pas d'auto-feed déjà actif sur ce bâtiment
4. Matériel disponible (tracteur + désileuse si applicable)

### Résultat succès
- Toast vert : "🔄 Nourrissage automatique activé pour 15 jours"
- Badge "AUTO 🔄 15j" affiché sur le bâtiment dans la liste
- Compteur jours restants visible sur la fiche bâtiment
- Bouton bascule en orange "Désactiver"

### Résultat erreur
- Toast rouge : "Stock insuffisant pour 15 jours (assez pour 11 jours)"
- Suggestion : "Voulez-vous activer pour 11 jours ?" (bouton secondaire)

### Effets de bord
- `building.auto_feed_ration_id = ration_id`
- `building.auto_feed_until = now() + 15 days`
- Chaque jour au tick : stock déduit, HT déduits, `feeding_log` créé
- Si stock épuisé avant fin : auto-feed désactivé + notification "⚠️ Stock épuisé, nourrissage auto arrêté"
- Si HT épuisés : auto-feed continue mais HT négatifs (dette HT)

---

## 6. Donner à boire

### Prérequis visibles
- Cuve à eau construite (bâtiment) ou bac à eau installé (pré)
- Niveau cuve/bac affiché en jauge (L actuels / capacité)
- Besoin total affiché (somme eau par animal)

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Abreuvement — Stabulation 1"           │
├──────────────────────────────────────────────────────┤
│ CUVE À EAU                                            │
│ ████████████░░░░░░░░ 3 200 / 5 000 L (64%)          │
│                                                       │
│ BESOIN AUJOURD'HUI                                    │
│ 8 vaches adultes × 200L = 1 600 L                    │
│ 3 génisses × 100L       =   300 L                    │
│ 1 veau × 12L            =    12 L                    │
│ ─────────────────────────────────                     │
│ Total: 1 912 L           Cuve: ✅ suffisant           │
│                                                       │
│ [Abreuver 💧]                    [Remplir cuve 🚰]   │
├──────────────────────────────────────────────────────┤
│ PRÉ — Parcelle "Grand Pré" (si animaux au pré)       │
│ Bac à eau: ████░░░░░░ 200 / 500 L (40%)             │
│ 🔗 Canalisation: ❌ Non                               │
│ Besoin: 480 L  Bac: ❌ insuffisant                    │
│                                                       │
│ [Remplir bac — Tonne à eau 🚛]                       │
└──────────────────────────────────────────────────────┘
```

### Bouton "Abreuver" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Cuve ≥ besoin total + HT ≥ 0.25 |
| 🔘 Grisé | Tooltip "Cuve insuffisante (X L / Y L requis)" | `cuve.current < besoin` |
| 🔘 Grisé | Tooltip "Pas de cuve à eau sur ce bâtiment" | Cuve inexistante |
| 🔘 Grisé | Tooltip "Animaux déjà abreuvés aujourd'hui" | Tous abreuvés |
| 🔘 Grisé | Tooltip "PA insuffisants" | `player.pa < 0.25` |

### Bouton "Remplir cuve" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Bleu | Cuve pas pleine + HT ≥ 0.5 |
| 🔘 Grisé | Tooltip "Cuve déjà pleine" | `cuve.current == cuve.capacity` |

### Bouton "Remplir bac — Tonne à eau" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Bleu | Tracteur + tonne à eau possédés + HT ≥ 1.0 |
| 🔘 Grisé | Tooltip "Tracteur requis" | Pas de tracteur |
| 🔘 Grisé | Tooltip "Tonne à eau requise" | Pas de tonne à eau |
| 🔘 Grisé | Tooltip "PA insuffisants (besoin 1.0)" | `player.pa < 1.0` |
| 🟢 Auto | Label "Canalisation active — remplissage auto" | `trough.has_pipeline = true` |

### Contrôles frontend
- `GET /api/farm/:id/water-status` → niveaux cuves et bacs
- Calculer besoin par animal selon tranche d'âge (table §5.3)
- Comparer besoin vs niveau cuve
- Si canalisation active sur bac : afficher "Remplissage automatique" et masquer bouton remplir

### Appel API
```
POST /api/buildings/:id/water          (abreuver en bâtiment, 0.25 HT)
POST /api/parcels/:id/water            (abreuver au pré, 0.25 HT)
POST /api/water-tanks/:id/fill         (remplir cuve, 0.5 HT)
POST /api/water-troughs/:id/fill       (remplir bac pré, 1.0 HT)
```

### Contrôles backend
1. Source eau (cuve/bac) appartient au joueur
2. Niveau suffisant pour tous les animaux
3. HT suffisants
4. Animaux pas déjà abreuvés aujourd'hui
5. Pour remplir bac : tracteur + tonne à eau vérifiés
6. Coût remplissage cuve : 3 €/m³ (0.003 €/L)

### Résultat succès
- Toast vert : "💧 12 animaux abreuvés — 1 912 L consommés"
- Jauge cuve animée (descend)
- Icônes 💧 passent de ❌ à ✅
- Pour remplissage : jauge remonte + Toast "Cuve remplie — X € débités"

### Résultat erreur
- Toast rouge : "Cuve insuffisante : 1 200 L disponibles, 1 912 L requis"

### Effets de bord
- `cuve.current -= total_water`
- `player.pa -= 0.25`
- `animal.last_watered_at = now()`
- `water_consumption_log` créé
- Remplissage cuve : `player.balance -= litres × 0.003`

---

## 7. Mettre la litière

### Prérequis visibles
- Bâtiment de type "stabulation litière" (pas caillebotis)
- Stock de paille affiché
- Besoin total affiché par animal

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Litière — Stabulation 1 (litière)"     │
├──────────────────────────────────────────────────────┤
│ BESOIN PAILLE QUOTIDIEN                               │
│ 1 taureau × 90 kg  =   90 kg                         │
│ 8 vaches × 72 kg   =  576 kg                         │
│ 3 génisses × 48 kg =  144 kg                         │
│ ─────────────────────────                             │
│ Total: 810 kg        Stock paille: 5 000 kg ✅        │
│                                                       │
│ MÉTHODE                                               │
│ ○ Tracteur + Pailleuse (PA: 0.5)  ✅ Matériel dispo  │
│ ○ Manuel (PA: 1.5)                                    │
│                                                       │
│ FUMIER PRODUIT (estimation)                           │
│ 810 kg × 1.2 = 972 kg → Fosse fumier                 │
│ Fosse: ████████░░ 8 000 / 10 000 kg (80%) ✅         │
│                                                       │
│                                    [Pailler 🛏️]       │
└──────────────────────────────────────────────────────┘
```

### Bouton "Pailler" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Stock paille ≥ besoin + méthode choisie + HT OK + fosse pas pleine |
| 🔘 Grisé | Tooltip "Stock paille insuffisant (besoin X kg, stock Y kg)" | Stock < besoin |
| 🔘 Grisé | Tooltip "Tracteur requis pour pailleuse" | Méthode pailleuse sans tracteur |
| 🔘 Grisé | Tooltip "Pailleuse requise" | Méthode pailleuse sans pailleuse |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < coût méthode |
| 🔘 Grisé | Tooltip "Bâtiment caillebotis — pas de litière" | `building.type = 'stabulation_caillebotis'` |
| 🟡 Warning | Tooltip "Fosse fumier pleine — fumier sera perdu" | Fosse ≥ 95% capacité |

### Contrôles frontend
- Vérifier `building.type == 'stabulation_litiere'` (sinon masquer toute la section)
- Calculer besoin paille par type animal (table §6.3)
- Calculer fumier produit = paille × 1.2
- Vérifier capacité fosse fumier
- Si caillebotis : afficher message "Ce bâtiment est en caillebotis — pas de litière nécessaire, le lisier est évacué automatiquement"

### Appel API
```
POST /api/buildings/:id/litter
Body: { method: 'machine'|'manual' }
```

### Contrôles backend
1. Bâtiment type litière (sinon 400 "Bâtiment caillebotis")
2. Stock paille suffisant
3. Matériel si méthode machine (tracteur + pailleuse)
4. HT suffisants
5. Fosse fumier existe (sinon 400 "Pas de fosse à fumier")

### Résultat succès
- Toast vert : "🛏️ Litière posée — 810 kg paille, 972 kg fumier produit"
- Stock paille mis à jour
- Jauge fosse fumier mise à jour (monte)
- Icônes litière passent à ✅

### Résultat erreur
- Toast rouge avec détail composant manquant

### Effets de bord
- `inventory.straw -= total_straw`
- `fosse_fumier.current += total_straw × 1.2`
- `player.pa -= pa_cost`
- `litter_log` créé
- Si fosse pleine : fumier excédentaire perdu + notification warning

---

## 8. Retirer le fumier/lisier

### Prérequis visibles
- Fosse fumier ou fosse lisier avec contenu > 0
- Matériel d'épandage disponible

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Gestion fumier / lisier"                │
├──────────────────────────────────────────────────────┤
│ FOSSE À FUMIER                                        │
│ ████████████████░░░░ 8 500 / 10 000 kg (85%)        │
│ [Épandre sur parcelle ▾]                              │
│   → Parcelle "Champ Nord" (2 ha) — besoin 50 000 kg  │
│   → Parcelle "Champ Sud" (1 ha) — besoin 25 000 kg   │
│ Matériel: Tracteur ✅ + Épandeur fumier ✅            │
│                                                       │
│ FOSSE À LISIER                                        │
│ ██████░░░░░░░░░░░░░░ 3 000 / 10 000 L (30%)         │
│ [Épandre sur parcelle ▾]                              │
│   → Parcelle "Champ Nord" (2 ha) — besoin 30 000 L   │
│ Matériel: Tracteur ✅ + Tonne à lisier ✅             │
│                                                       │
│ Parcelle sélectionnée: Champ Nord (2 ha)              │
│ Fumier dispo: 8 500 kg / 50 000 kg requis (17%)      │
│ ⚠️ Épandage partiel — sol partiellement enrichi       │
│                                                       │
│                              [Épandre fumier 🚜]      │
└──────────────────────────────────────────────────────┘
```

### Bouton "Épandre" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Fosse > 0 + parcelle sélectionnée + matériel OK + HT OK |
| 🔘 Grisé | Tooltip "Fosse vide" | `fosse.current == 0` |
| 🔘 Grisé | Tooltip "Sélectionnez une parcelle" | Pas de parcelle choisie |
| 🔘 Grisé | Tooltip "Épandeur à fumier requis" | Pas d'épandeur (fumier) |
| 🔘 Grisé | Tooltip "Tonne à lisier requise" | Pas de tonne (lisier) |
| 🔘 Grisé | Tooltip "Tracteur requis" | Pas de tracteur |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < coût |
| 🟡 Warning | Label "Épandage partiel" | Fosse < besoin parcelle |

### Contrôles frontend
- `GET /api/farm/:id/manure-status` et `/slurry-status`
- Lister parcelles du joueur avec surface
- Calculer besoin : fumier 25 T/ha, lisier 15 m³/ha
- Si fosse < besoin : afficher "Épandage partiel" + % couverture

### Appel API
```
POST /api/parcels/:id/spread-manure   (fumier)
POST /api/parcels/:id/spread-slurry   (lisier)
```

### Contrôles backend
1. Fosse appartient au joueur, contenu > 0
2. Parcelle appartient au joueur
3. Matériel requis (tracteur + épandeur/tonne)
4. HT suffisants
5. Parcelle pas déjà épandue récemment (cooldown optionnel)

### Résultat succès
- Toast vert : "🚜 8 500 kg fumier épandu sur Champ Nord — Sol enrichi"
- Jauge fosse descend (animation)
- Détail nutriments ajoutés affiché : "N+137.5, P+65, K+180..."
- HT mis à jour

### Résultat erreur
- Toast rouge avec détail

### Effets de bord
- `fosse.current -= quantité_épandue`
- `parcel.nutrient_reserves` enrichis (N, P, K, Ca, Mg, S)
- `player.pa -= pa_cost`
- Bénéfice cultures suivantes sur cette parcelle

---

## 9. Mettre au pré

### Prérequis visibles
- Saison actuelle affichée (mois in-game)
- Parcelles de type "pré" listées avec surface et herbe disponible
- Bac à eau présent sur le pré

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Mise au pré"  [Mois actuel: Avril 🌱]  │
├──────────────────────────────────────────────────────┤
│ SÉLECTION ANIMAUX (depuis bâtiment)                   │
│ ☑ Marguerite (Prim'Holstein ♀, 4 ans, 685 kg)       │
│ ☑ Rosalie (Prim'Holstein ♀, 3 ans, 670 kg)          │
│ ☐ Brutus (Charolais ♂, 5 ans, 1150 kg)              │
│ [Tout sélectionner] [Désélectionner]                  │
│ Sélectionnés: 2 animaux                              │
├──────────────────────────────────────────────────────┤
│ PARCELLE PRÉ (sélection)                              │
│ ○ Grand Pré (3 ha) — Herbe: 85% — 4 animaux dessus  │
│   Bac eau: ✅ 500L | Capacité restante: ~30 animaux  │
│ ○ Petit Pré (1 ha) — Herbe: 40% ⚠️ — 0 animaux      │
│   Bac eau: ❌ Aucun                                   │
├──────────────────────────────────────────────────────┤
│ VÉRIFICATIONS                                         │
│ ✅ Saison: Avril (pâturage autorisé)                  │
│ ✅ Bétaillère disponible                              │
│ ✅ Herbe suffisante (≥ 7 jours)                       │
│ ✅ Bac à eau présent                                  │
│                                                       │
│                              [Mettre au pré 🌿]       │
└──────────────────────────────────────────────────────┘
```

### Bouton "Mettre au pré" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Animaux sélectionnés + pré choisi + saison OK + herbe ≥ 7j + bac eau + bétaillère + HT |
| 🔘 Grisé | Tooltip "Sélectionnez au moins un animal" | Aucun animal coché |
| 🔘 Grisé | Tooltip "Sélectionnez un pré" | Pas de parcelle choisie |
| 🔘 Grisé | Tooltip "Pâturage interdit (Nov→Mars pour laitières)" | Laitière hors avril-octobre |
| 🔘 Grisé | Tooltip "Herbe insuffisante (< 7 jours)" | Herbe restante < besoin × 7 |
| 🔘 Grisé | Tooltip "Pas de bac à eau sur ce pré" | Bac absent |
| 🔘 Grisé | Tooltip "Bétaillère requise" | Pas de bétaillère |
| 🔘 Grisé | Tooltip "Tracteur requis" | Pas de tracteur |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.5 |

### Contrôles frontend
- `GET /api/parcels?type=meadow` → prés disponibles
- Vérifier `server.current_month` ∈ [4..10] pour laitières
- Calculer herbe restante vs besoin (56-88 m²/jour × nb animaux × 7 jours)
- Vérifier bac à eau sur parcelle sélectionnée
- Vérifier bétaillère + tracteur

### Appel API
```
POST /api/animals/:id/to-pasture
Body: { parcel_id: number }
(appelé pour chaque animal sélectionné, ou endpoint batch)
```

### Contrôles backend
1. Animal appartient au joueur, vivant
2. Parcelle type pré, appartient au joueur
3. Saison valide (laitières avril-oct, allaitantes toute l'année)
4. Herbe suffisante ≥ 7 jours
5. Bac à eau présent sur parcelle
6. Bétaillère + tracteur
7. HT ≥ 0.5

### Résultat succès
- Toast vert : "🌿 2 animaux mis au pré — Grand Pré"
- Animaux disparaissent de la liste bâtiment
- Apparaissent dans la vue pré avec badge "🌿 Au pré"
- Capacité bâtiment recalculée

### Résultat erreur
- Toast rouge avec raison précise
- Animaux restent en bâtiment

### Effets de bord
- `animal.location_type = 'pasture'`
- `animal.building_id = null`
- `animal.parcel_id = parcel_id`
- `pasture_session` créée
- `building.animal_count -= nb`
- Herbe consommée quotidiennement au tick
- Allaitantes en hiver : ration hivernale requise (sinon health -10/jour)

---

## 10. Rentrer du pré

### Prérequis visibles
- Animaux actuellement au pré
- Bâtiments avec place disponible listés

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Rentrer du pré — Grand Pré"            │
├──────────────────────────────────────────────────────┤
│ ANIMAUX AU PRÉ (sélection)                           │
│ ☑ Marguerite (Prim'Holstein ♀) — 45 jours au pré    │
│ ☑ Rosalie (Prim'Holstein ♀) — 45 jours au pré       │
│ Sélectionnés: 2                                      │
├──────────────────────────────────────────────────────┤
│ BÂTIMENT DESTINATION                                  │
│ ○ Stabulation 1 (litière) — 4 places libres ✅       │
│ ○ Stabulation 2 (caillebotis) — 0 places ❌          │
│                                                       │
│ VÉRIFICATIONS                                         │
│ ✅ Bétaillère disponible                              │
│ ✅ Place suffisante en bâtiment                       │
│                                                       │
│                              [Rentrer en bâtiment 🏠] │
└──────────────────────────────────────────────────────┘
```

### Bouton "Rentrer en bâtiment" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Animaux sélectionnés + bâtiment choisi + place OK + bétaillère + HT |
| 🔘 Grisé | Tooltip "Sélectionnez au moins un animal" | Aucun coché |
| 🔘 Grisé | Tooltip "Sélectionnez un bâtiment" | Pas de bâtiment choisi |
| 🔘 Grisé | Tooltip "Place insuffisante (besoin X m², libre Y m²)" | Capacité dépassée |
| 🔘 Grisé | Tooltip "Bétaillère requise" | Pas de bétaillère |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.5 |

### Contrôles frontend
- `GET /api/parcels/:id/pasture-status` → animaux au pré
- `GET /api/buildings?type=stabulation&has_space=true` → bâtiments avec place
- Calculer surface requise par animal (5/8/12/15 m² selon type)
- Comparer avec espace libre bâtiment

### Appel API
```
POST /api/animals/:id/to-building
Body: { building_id: number }
```

### Contrôles backend
1. Animal au pré, appartient au joueur
2. Bâtiment appartient au joueur, type stabulation
3. Place suffisante (surface libre ≥ surface requise)
4. Bétaillère + tracteur
5. HT ≥ 0.5

### Résultat succès
- Toast vert : "🏠 2 animaux rentrés — Stabulation 1"
- Animaux disparaissent de la vue pré
- Apparaissent dans la liste bâtiment
- `pasture_session.end_date` mis à jour

### Résultat erreur
- Toast rouge : "Place insuffisante : besoin 24 m², libre 16 m²"

### Effets de bord
- `animal.location_type = 'building'`
- `animal.building_id = building_id`
- `animal.parcel_id = null`
- `pasture_session.end_date = now()`
- `building.animal_count += nb`
- Herbe du pré arrête d'être consommée par ces animaux

---

## 11. Inséminer naturellement

### Prérequis visibles
- Femelle éligible (≥ 27 mois, pas gestante, cooldown OK, santé ≥ 50)
- Taureau disponible (≥ 3 ans, même race, santé ≥ 50, < 4 inséminations aujourd'hui)

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Insémination naturelle"                 │
├──────────────────────────────────────────────────────┤
│ FEMELLE SÉLECTIONNÉE                                  │
│ Marguerite — Prim'Holstein ♀ — 4 ans — ❤️ 95         │
│ ✅ Âge ≥ 27 mois                                     │
│ ✅ Pas gestante                                       │
│ ✅ Cooldown respecté (dernière mise bas: il y a 45j)  │
│ ✅ Santé ≥ 50                                         │
├──────────────────────────────────────────────────────┤
│ SÉLECTION TAUREAU (même race uniquement)              │
│ ○ Brutus — Prim'Holstein ♂ — 5 ans — ❤️ 90           │
│   Inséminations aujourd'hui: 2/4 ✅                   │
│   Génétique: Cr:72 Pr:55 Al:68 La:— QL:—            │
│ ○ César — Prim'Holstein ♂ — 4 ans — ❤️ 85            │
│   Inséminations aujourd'hui: 4/4 ❌ Max atteint      │
├──────────────────────────────────────────────────────┤
│ ESTIMATION VEAU                                       │
│ Génétique probable: moyenne parents ±5                │
│ Cr: ~(72+78)/2 = 75 ±5  |  Al: ~(68+63)/2 = 66 ±5  │
│ Naissance prévue: dans 63 jours (9 mois sim)          │
│                                                       │
│ PA: 0.5                   [Inséminer 🐄]              │
└──────────────────────────────────────────────────────┘
```

### Bouton "Inséminer" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Femelle éligible + taureau sélectionné et éligible + HT ≥ 0.5 |
| 🔘 Grisé | Tooltip "Femelle trop jeune (X mois, min 27)" | `female.age_days < 810` |
| 🔘 Grisé | Tooltip "Femelle déjà gestante" | Gestation active |
| 🔘 Grisé | Tooltip "Délai 3 mois non respecté (X jours restants)" | Cooldown actif |
| 🔘 Grisé | Tooltip "Femelle en mauvaise santé (X/100, min 50)" | `female.health < 50` |
| 🔘 Grisé | Tooltip "Sélectionnez un taureau" | Aucun taureau coché |
| 🔘 Grisé | Tooltip "Taureau: max 4 inséminations/jour atteint" | `today_count >= 4` |
| 🔘 Grisé | Tooltip "Taureau trop jeune (X mois, min 36)" | `male.age_days < 1095` |
| 🔘 Grisé | Tooltip "Taureau en mauvaise santé" | `male.health < 50` |
| 🔘 Grisé | Tooltip "Races différentes — croisement interdit" | `female.breed != male.breed` |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.5 |

### Contrôles frontend
- Filtrer taureaux : même race, ≥ 3 ans, santé ≥ 50
- Afficher compteur inséminations/jour par taureau
- Taureaux à 4/4 : ligne grisée avec ❌
- Calculer estimation génétique enfant (moyenne parents)
- Calculer date naissance prévue

### Appel API
```
POST /api/animals/:id/inseminate
Body: { method: "natural", male_id: number }
```

### Contrôles backend
1. Femelle : appartient au joueur, ≥ 27 mois, pas gestante, cooldown 21j, santé ≥ 50
2. Mâle : appartient au joueur, même race, ≥ 36 mois, santé ≥ 50, < 4 insém/jour
3. HT ≥ 0.5

### Résultat succès
- Toast vert : "🐄 Insémination réussie — Naissance prévue le XX/XX"
- Fiche femelle : badge "🤰 Gestante" + date prévue
- Compteur taureau incrémenté (3/4)
- HT déduits

### Résultat erreur
- Toast rouge avec raison exacte

### Effets de bord
- `insemination` créée
- `gestation` créée (status='ongoing', due_date=now+63j)
- `female.pregnant_until = due_date`
- Au tick jour 63 : veau né automatiquement, génétique calculée

---

## 12. Inséminer artificiellement

### Prérequis visibles
- Femelle éligible (mêmes critères que naturelle)
- Doses CIA disponibles (même race)
- Inséminateur (employé) embauché

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Insémination artificielle"              │
├──────────────────────────────────────────────────────┤
│ FEMELLE: Marguerite — Prim'Holstein ♀ — 4 ans        │
│ ✅ Éligible (voir critères action 11)                 │
├──────────────────────────────────────────────────────┤
│ DOSE CIA (sélection)                                  │
│ ○ Dose #12 — Prim'Holstein "Excellence 92"            │
│   Génétique père: Cr:88 Pr:72 Al:91 La:95 QL:85     │
│   Doses restantes: 3  |  Prix: 150 €                  │
│ ○ Dose #15 — Prim'Holstein "Standard"                 │
│   Génétique père: Cr:55 Pr:50 Al:52 La:60 QL:48     │
│   Doses restantes: 10 |  Prix: 30 €                   │
├──────────────────────────────────────────────────────┤
│ INSÉMINATEUR                                          │
│ ✅ Dr. Martin (employé) — Disponible                  │
│ Coût intervention: 50 €                               │
├──────────────────────────────────────────────────────┤
│ COÛT TOTAL: 150 € (dose) + 50 € (véto) = 200 €      │
│ PA: 0.5                   [Inséminer 💉]              │
└──────────────────────────────────────────────────────┘
```

### Bouton "Inséminer" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Femelle éligible + dose sélectionnée + inséminateur + solde OK + HT |
| 🔘 Grisé | Tooltip "Sélectionnez une dose CIA" | Aucune dose choisie |
| 🔘 Grisé | Tooltip "Plus de doses disponibles" | `dose.doses_left == 0` |
| 🔘 Grisé | Tooltip "Dose incompatible (race différente)" | `dose.breed != female.breed` |
| 🔘 Grisé | Tooltip "Inséminateur requis — Embauchez un employé" | Pas d'employé inséminateur |
| 🔘 Grisé | Tooltip "Solde insuffisant (besoin X €)" | `balance < coût_total` |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.5 |
| + tous les grisés femelle de l'action 11 |

### Contrôles frontend
- Lister doses CIA compatibles (même race, doses_left > 0)
- Vérifier employé inséminateur via `GET /api/employees?specialty=inseminator`
- Calculer coût total (dose + intervention)
- Afficher génétique du père (depuis la dose)

### Appel API
```
POST /api/animals/:id/inseminate
Body: { method: "artificial", dose_id: number }
```

### Contrôles backend
1. Mêmes vérifs femelle que naturelle
2. Dose existe, même race, doses_left > 0
3. Employé inséminateur présent
4. Solde ≥ coût total
5. HT ≥ 0.5

### Résultat succès
- Toast vert : "💉 IA réussie — Dose Excellence 92 — Naissance prévue le XX/XX"
- Solde débité (dose + intervention)
- Dose restantes décrémentée
- Badge 🤰 sur fiche femelle

### Résultat erreur
- Toast rouge avec raison

### Effets de bord
- `dose.doses_left -= 1`
- `player.balance -= coût_total`
- `insemination` + `gestation` créées
- Même mécanique naissance que naturelle (tick jour 63)

---

## 13. Traire

### Prérequis visibles
- Salle de traite construite
- Cuve à lait construite (avec capacité restante)
- Au moins 1 vache lactante dans le bâtiment

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Traite — Stabulation 1"                 │
├──────────────────────────────────────────────────────┤
│ SALLE DE TRAITE: 8 postes (niveau 3)                  │
│ Traite du jour: 2/4 effectuées                        │
│                                                       │
│ VACHES LACTANTES: 6                                   │
│ Marguerite — 32.4 L/j — QL: 72 — 🍼 Non             │
│ Rosalie    — 28.1 L/j — QL: 68 — 🍼 Non             │
│ Blanchette — 25.0 L/j — QL: 55 — 🍼 Non             │
│ Daisy      — ⛔ Allaitement (pas de traite)           │
│ ...                                                   │
│                                                       │
│ ESTIMATION TRAITE #3                                  │
│ Lait estimé: (32.4+28.1+25.0+...)/4 = ~21.4 L total │
│                                                       │
│ CUVE À LAIT                                           │
│ ████████████░░░░░░░░ 1 200 / 2 000 L (60%)          │
│ Après traite: ~1 221 L (61%) ✅                       │
│                                                       │
│ PA: 0.5                        [Traire 🥛]            │
└──────────────────────────────────────────────────────┘
```

### Bouton "Traire" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Salle traite + cuve pas pleine + vaches lactantes + traite < 4/jour + HT |
| 🔘 Grisé | Tooltip "Salle de traite requise" | Pas de salle de traite |
| 🔘 Grisé | Tooltip "Cuve à lait requise" | Pas de cuve |
| 🔘 Grisé | Tooltip "Cuve à lait pleine" | `cuve.current >= cuve.capacity` |
| 🔘 Grisé | Tooltip "Maximum 4 traites/jour atteint" | `milking_count_today >= 4` |
| 🔘 Grisé | Tooltip "Aucune vache en lactation" | 0 vache lactante |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < coût |

### Contrôles frontend
- `GET /api/buildings/:id/capacity` → vaches lactantes
- Compter traites du jour
- Estimer litres = somme(production/4) pour chaque vache lactante (hors allaitement)
- Vérifier capacité cuve restante ≥ estimation

### Appel API
```
POST /api/buildings/:id/milk
```

### Contrôles backend
1. Salle de traite liée au bâtiment
2. Cuve à lait avec capacité restante
3. Au moins 1 vache lactante (pas en allaitement)
4. Traites < 4 aujourd'hui
5. HT suffisants

### Résultat succès
- Toast vert : "🥛 Traite #3 — 21.4 L récoltés (6 vaches)"
- Jauge cuve monte (animation)
- Compteur traites : 3/4
- HT déduits

### Résultat erreur
- Toast rouge : "Cuve pleine — vendez le lait d'abord"

### Effets de bord
- `cuve.current += litres`
- `milk_production` log créé par vache
- `player.pa -= pa_cost`
- Si 7 jours sans traite → tarissement automatique (tick)

---

## 14. Vendre le lait

### Prérequis visibles
- Cuve à lait avec contenu > 0
- Prix affiché selon indice QL moyen

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Vente de lait"                          │
├──────────────────────────────────────────────────────┤
│ CUVE À LAIT                                           │
│ ████████████████░░░░ 1 600 / 2 000 L (80%)          │
│                                                       │
│ QUALITÉ MOYENNE: QL 68 → 340 €/1000L                 │
│ Mode: Conventionnel                                   │
│ (BIO: 408 €/1000L — non éligible actuellement)       │
│                                                       │
│ QUANTITÉ À VENDRE                                     │
│ [━━━━━━━━━━━━━━━━━━━━] 1 600 L (tout)               │
│ ou saisir: [1600] L                                   │
│                                                       │
│ ESTIMATION REVENU                                     │
│ 1 600 L × 340 €/1000L = 544.00 €                    │
│                                                       │
│ PA: 0.5                        [Vendre lait 💰]       │
└──────────────────────────────────────────────────────┘
```

### Bouton "Vendre lait" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Cuve > 0 + quantité saisie > 0 + HT ≥ 0.5 |
| 🔘 Grisé | Tooltip "Cuve vide" | `cuve.current == 0` |
| 🔘 Grisé | Tooltip "Saisissez une quantité" | Quantité = 0 |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.5 |

### Contrôles frontend
- Slider ou input numérique pour quantité (min 1, max cuve.current)
- Calcul prix en temps réel : `quantité × prix_1000L / 1000`
- Afficher prix BIO si éligible

### Appel API
```
POST /api/farm/:id/sell-milk
Body: { liters: number }
```

### Contrôles backend
1. Cuve appartient au joueur, contenu ≥ quantité
2. Prix calculé côté serveur (pas confiance au client)
3. HT ≥ 0.5

### Résultat succès
- ConfirmModal avant vente : "Vendre 1 600 L pour 544.00 € ?"
- Toast vert : "💰 1 600 L vendus — 544.00 € crédités"
- Solde header animé (+544.00 €)
- Jauge cuve descend
- HT déduits

### Résultat erreur
- Toast rouge

### Effets de bord
- `cuve.current -= liters`
- `player.balance += revenu`
- `player.pa -= 0.5`
- Entrée `ledger` (relevé bancaire)

---

## 15. Vendre à l'abattoir

### Prérequis visibles
- Animal vivant sélectionné
- Estimation prix affichée avant confirmation

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Vente abattoir"                         │
├──────────────────────────────────────────────────────┤
│ ANIMAL SÉLECTIONNÉ                                    │
│ Brutus — Charolais ♂ — 5 ans — 1 150 kg              │
├──────────────────────────────────────────────────────┤
│ ESTIMATION ABATTOIR                                   │
│ Poids vif:        1 150 kg                            │
│ Rendement carcasse: 70% (allaitante, allure 68)       │
│ Poids carcasse:   805 kg                              │
│ Conformation:     B (allure 68)                       │
│ Engraissement:    3 (optimal ✅)                      │
│ Prix/kg carcasse: 4.10 €                              │
│ Bonus génétique:  +5% (somme indices > moy. serveur) │
│ ─────────────────────────────────                     │
│ TOTAL ESTIMÉ:     3 465.15 €                          │
│                                                       │
│ ⚠️ Action irréversible — l'animal sera abattu         │
│                                                       │
│ PA: 0.25                  [Vendre à l'abattoir 🔪]    │
└──────────────────────────────────────────────────────┘
```

### Bouton "Vendre à l'abattoir" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Rouge (danger) | Animal vivant + HT ≥ 0.25 |
| 🔘 Grisé | Tooltip "Animal mort" | `life_stage == 'dead'` |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.25 |
| 🔘 Grisé | Tooltip "Animal gestant — mise bas dans X jours" | Femelle gestante (protection) |

### Contrôles frontend
- `GET /api/animals/:id/slaughter-estimate` → estimation complète
- Afficher détail calcul (rendement, conformation, engraissement, bonus)
- Bouton rouge (couleur danger) car action irréversible
- ConfirmModal obligatoire : "Êtes-vous sûr ? Cette action est irréversible."

### Appel API
```
POST /api/animals/:id/slaughter
```

### Contrôles backend
1. Animal appartient au joueur, vivant
2. HT ≥ 0.25
3. Calcul prix côté serveur (pas confiance estimation client)
4. Optionnel : protection femelle gestante

### Résultat succès
- ConfirmModal → confirmation
- Toast vert : "🔪 Brutus vendu à l'abattoir — 3 465.15 € crédités"
- Solde header animé
- Animal retiré de la liste (ou marqué "Abattu" grisé)
- Redirection vers liste animaux

### Résultat erreur
- Toast rouge

### Effets de bord
- `animal.life_stage = 'dead'`
- `player.balance += total`
- `player.pa -= 0.25`
- `slaughter_record` créé
- `building.animal_count -= 1` ou `pasture_session.end_date = now()`
- Entrée `ledger`

---

## 16. Vendre à un joueur

### Prérequis visibles
- Animal vivant, adulte de préférence (valorisation génétique)
- Marché coopératif accessible

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Vendre animal — Coopérative joueurs"    │
├──────────────────────────────────────────────────────┤
│ ANIMAL                                                │
│ Marguerite — Prim'Holstein ♀ — 4 ans — 685 kg        │
├──────────────────────────────────────────────────────┤
│ VALORISATION GÉNÉTIQUE                                │
│ Somme indices: 356 (moy. serveur: 250)                │
│ Bonus estimé: +8% | Valeur génétique: +212 €          │
│ Cr:78 Pr:52 Al:63 La:91 QL:72                        │
│ (Née à la ferme ✅ — valorisation active)             │
├──────────────────────────────────────────────────────┤
│ TYPE DE VENTE                                         │
│ ○ Annonce publique (visible de tous les joueurs)      │
│ ○ Vente directe à un ami (sélection joueur)           │
│   └─ Joueur: [recherche...▾]                          │
├──────────────────────────────────────────────────────┤
│ PRIX DE VENTE                                         │
│ Prix suggéré (abattoir): 2 800 €                      │
│ Prix suggéré (génétique): 3 012 €                     │
│ Votre prix: [3 000] €                                 │
│                                                       │
│ ⚠️ Transport obligatoire (bétaillère acheteur)        │
│                                                       │
│ PA: 0.25                [Mettre en vente 📢]          │
└──────────────────────────────────────────────────────┘
```

### Bouton "Mettre en vente" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Animal vivant + prix saisi > 0 + type vente choisi + HT |
| 🔘 Grisé | Tooltip "Saisissez un prix" | Prix = 0 ou vide |
| 🔘 Grisé | Tooltip "Sélectionnez un type de vente" | Ni annonce ni ami |
| 🔘 Grisé | Tooltip "Sélectionnez un joueur" | Vente directe sans joueur choisi |
| 🔘 Grisé | Tooltip "Animal déjà en vente" | Annonce existante |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.25 |

### Contrôles frontend
- `GET /api/animals/:id/genetic-value` → valorisation
- `GET /api/animals/:id/slaughter-estimate` → prix abattoir de référence
- Input prix libre (min 1 €, pas de max)
- Recherche joueur autocomplete si vente directe

### Appel API
```
POST /api/coop/listings
Body: { animal_id: number, price: number, type: 'public'|'direct', target_player_id?: number }
```

### Contrôles backend
1. Animal appartient au joueur, vivant
2. Pas déjà en vente
3. Prix > 0
4. Si vente directe : joueur cible existe et actif
5. HT ≥ 0.25

### Résultat succès
- Toast vert : "📢 Marguerite mise en vente — 3 000 €"
- Badge "🏷️ En vente" sur fiche animal
- Annonce visible sur le marché coopératif
- Notification à l'acheteur ciblé (si vente directe)

### Résultat erreur
- Toast rouge

### Effets de bord
- `coop_listing` créée
- Animal reste chez le vendeur jusqu'à achat
- Acheteur doit posséder bétaillère + bâtiment avec place
- À l'achat : transfert animal, solde débité acheteur, crédité vendeur, transport simulé

---

## 17. Appeler le vétérinaire

### Prérequis visibles
- Animal malade (santé < 50 ou maladie diagnostiquée)
- Icône 🏥 visible sur la fiche

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Vétérinaire"                            │
├──────────────────────────────────────────────────────┤
│ ANIMAL MALADE                                         │
│ Rosalie — Prim'Holstein ♀ — ❤️ 35/100 🔴             │
│ Diagnostic: Mammite                                   │
│ Depuis: 3 jours                                       │
├──────────────────────────────────────────────────────┤
│ SOINS PROPOSÉS                                        │
│ Traitement antibiotique                               │
│ Coût: 120 €                                           │
│ Durée guérison: 5 jours                               │
│ Santé estimée après guérison: ~80/100                 │
│                                                       │
│ ⚠️ Pendant le traitement:                             │
│ - Lait non vendable (résidus antibiotiques, 7 jours) │
│ - Animal reste en bâtiment                            │
├──────────────────────────────────────────────────────┤
│ Solde: 15 420 € | Coût: 120 €                        │
│ PA: 0.25              [Appeler le vétérinaire 🏥]     │
└──────────────────────────────────────────────────────┘
```

### Bouton "Appeler le vétérinaire" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Animal malade + solde ≥ coût + HT ≥ 0.25 |
| 🔘 Grisé | Tooltip "Animal en bonne santé" | `health >= 50` et pas de maladie |
| 🔘 Grisé | Tooltip "Solde insuffisant (besoin X €)" | `balance < coût` |
| 🔘 Grisé | Tooltip "Traitement déjà en cours (X jours restants)" | Traitement actif |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.25 |

### Contrôles frontend
- Vérifier `animal.health < 50` ou maladie active
- Afficher diagnostic si disponible
- Afficher coût et durée guérison
- Avertissement lait non vendable si vache laitière

### Appel API
```
POST /api/vet/treat
Body: { animal_id: number }
```

### Contrôles backend
1. Animal appartient au joueur, vivant, malade
2. Pas de traitement déjà en cours
3. Solde ≥ coût soins
4. HT ≥ 0.25

### Résultat succès
- Toast vert : "🏥 Vétérinaire appelé — Traitement en cours (5 jours)"
- Badge "💊 En traitement" sur fiche animal (avec countdown)
- Solde débité
- Santé remonte progressivement (+10/jour pendant 5 jours)

### Résultat erreur
- Toast rouge

### Effets de bord
- `player.balance -= coût`
- `player.pa -= 0.25`
- `animal_health_log` : event_type='treatment'
- Santé remonte au tick quotidien pendant durée traitement
- Si vache laitière : lait marqué "résidus" pendant 7 jours (non vendable)
- Assurance élevage rembourse une partie si souscrite

---

## 18. Vacciner

### Prérequis visibles
- Animal vivant, pas déjà vacciné (ou vaccin expiré > 1 an)

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Vaccination"                            │
├──────────────────────────────────────────────────────┤
│ ANIMAL                                                │
│ Marguerite — Prim'Holstein ♀ — 4 ans — ❤️ 95         │
│ Vaccin actuel: ❌ Non vaccinée                        │
│ (ou: ✅ Vaccinée le 12/03 — Expire le 12/03 +1an)   │
├──────────────────────────────────────────────────────┤
│ VACCINATION                                           │
│ Vaccin polyvalent bovin                               │
│ Coût: 25 €                                            │
│ Protection: 1 an (365 jours in-game)                  │
│ Effet: réduit risque maladie de 90%                   │
│                                                       │
│ PA: 0.1                        [Vacciner 💉]          │
└──────────────────────────────────────────────────────┘
```

### Bouton "Vacciner" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Animal vivant + pas vacciné (ou expiré) + solde ≥ 25 € + HT |
| 🔘 Grisé | Tooltip "Déjà vacciné (expire dans X jours)" | Vaccin actif non expiré |
| 🔘 Grisé | Tooltip "Solde insuffisant" | `balance < 25` |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.1 |

### Contrôles frontend
- Vérifier date dernier vaccin + 365 jours > now
- Afficher statut vaccin sur fiche (💉 icône verte si actif, grise si expiré/absent)

### Appel API
```
POST /api/vet/vaccinate
Body: { animal_id: number }
```

### Contrôles backend
1. Animal appartient au joueur, vivant
2. Pas de vaccin actif (dernier vaccin + 365j < now)
3. Solde ≥ 25 €
4. HT ≥ 0.1

### Résultat succès
- Toast vert : "💉 Marguerite vaccinée — Protection 1 an"
- Icône 💉 verte sur fiche animal
- Date expiration affichée
- Solde débité

### Résultat erreur
- Toast rouge : "Déjà vaccinée — expire dans 280 jours"

### Effets de bord
- `player.balance -= 25`
- `player.pa -= 0.1`
- `animal_health_log` : event_type='vaccination'
- Risque maladie réduit de 90% au tick quotidien
- Icône 💉 visible dans la liste animaux et sur la fiche

---

## 19. Activer allaitement

### Prérequis visibles
- Vache avec veau nouveau-né (< 6 mois)
- Vache actuellement en lactation

### Écran (layout)
```
┌──────────────────────────────────────────────────────┐
│ PageToolbar: "Allaitement maternel"                   │
├──────────────────────────────────────────────────────┤
│ MÈRE                                                  │
│ Daisy — Charolaise ♀ — 6 ans — 🥛 En lactation       │
│ Production actuelle: 12 L/jour                        │
├──────────────────────────────────────────────────────┤
│ VEAU                                                  │
│ Petit Daisy — Charolais ♂ — 15 jours — 48 kg         │
│ Croissance actuelle: 0.64 kg/jour                     │
├──────────────────────────────────────────────────────┤
│ EFFETS DE L'ALLAITEMENT                               │
│ ✅ Meilleure croissance veau (+30% estimé)            │
│ ✅ Valorisation vente: +1.50 €/kg carcasse            │
│ ❌ Pas de traite possible (lait consommé par veau)    │
│ ❌ Perte revenu lait: ~12 L/jour × prix              │
│                                                       │
│ Durée: jusqu'à sevrage (6 mois) ou désactivation     │
│                                                       │
│ PA: 0.25                                              │
│ [Activer allaitement 🍼]  ou  [Désactiver ⛔]        │
└──────────────────────────────────────────────────────┘
```

### Bouton "Activer allaitement" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Mère lactante + veau < 6 mois + même lieu + HT |
| 🔘 Grisé | Tooltip "Pas de veau associé (< 6 mois)" | Pas de veau nouveau-né de cette mère |
| 🔘 Grisé | Tooltip "Veau trop âgé (> 6 mois)" | Veau ≥ 180 jours |
| 🔘 Grisé | Tooltip "Mère pas en lactation" | `is_lactating = false` |
| 🔘 Grisé | Tooltip "Mère et veau pas au même endroit" | Lieux différents |
| 🔘 Grisé | Tooltip "Allaitement déjà actif" | `is_nursing = true` |
| 🔘 Grisé | Tooltip "PA insuffisants" | HT < 0.25 |

### Bouton "Désactiver" — États
| État | Apparence | Condition |
|------|-----------|-----------|
| 🟠 Orange | Actif | Allaitement en cours |
| 🔘 Masqué | Invisible | Allaitement pas actif |

### Contrôles frontend
- Identifier veau de la mère via `gestation.offspring_id`
- Vérifier âge veau < 180 jours
- Vérifier même `building_id` ou `parcel_id`
- Afficher comparaison gains/pertes (croissance vs revenu lait)

### Appel API
```
POST /api/animals/:id/nursing
Body: { enable: true, calf_id: number }
```
```
DELETE /api/animals/:id/nursing   (désactivation)
```

### Contrôles backend
1. Mère appartient au joueur, lactante
2. Veau existe, < 6 mois, fils/fille de cette mère
3. Même localisation (bâtiment ou pré)
4. HT ≥ 0.25

### Résultat succès
- Toast vert : "🍼 Allaitement activé — Petit Daisy sous la mère"
- Badge "🍼 Allaitement" sur fiche mère ET veau
- Traite désactivée pour cette vache (grisée avec tooltip "En allaitement")
- Croissance veau boostée visible sur fiche

### Résultat erreur
- Toast rouge avec raison

### Effets de bord
- `mother.is_nursing = true`
- `calf.is_nursed = true`
- Traite impossible pour cette vache (bloquée côté API aussi)
- Croissance veau × 1.3 (bonus 30%)
- Valorisation carcasse veau : +1.50 €/kg
- À 6 mois : sevrage automatique (tick), `is_nursing = false`, notification "Sevrage automatique"
- Si mère ou veau déplacés séparément : allaitement interrompu + notification

---

## Annexe — Récapitulatif des états de boutons

| # | Action | Bouton principal | HT | Couleur active |
|---|--------|-----------------|-----|----------------|
| 1 | Acheter coop | Acheter | 0.5 | 🟢 Vert |
| 2 | Voir animaux | Voir (lien) | 0 | 🔵 Bleu |
| 3 | Fiche animal | — (lecture) | 0 | — |
| 4 | Nourrir | Nourrir 🍽️ | Variable | 🟢 Vert |
| 5 | Nourrir auto | Activer 🔄 / Désactiver | 0.5/j | 🟢/🟠 |
| 6 | Abreuver | Abreuver 💧 | 0.25 | 🟢 Vert |
| 7 | Litière | Pailler 🛏️ | 0.5 | 🟢 Vert |
| 8 | Fumier/Lisier | Épandre 🚜 | Variable | 🟢 Vert |
| 9 | Mettre au pré | Mettre au pré 🌿 | 0.5 | 🟢 Vert |
| 10 | Rentrer du pré | Rentrer 🏠 | 0.5 | 🟢 Vert |
| 11 | Insém. naturelle | Inséminer 🐄 | 0.5 | 🟢 Vert |
| 12 | Insém. artificielle | Inséminer 💉 | 0.5 | 🟢 Vert |
| 13 | Traire | Traire 🥛 | Variable | 🟢 Vert |
| 14 | Vendre lait | Vendre 💰 | 0.5 | 🟢 Vert |
| 15 | Vendre abattoir | Vendre 🔪 | 0.25 | 🔴 Rouge (danger) |
| 16 | Vendre joueur | Mettre en vente 📢 | 0.25 | 🟢 Vert |
| 17 | Vétérinaire | Appeler 🏥 | 0.25 | 🟢 Vert |
| 18 | Vacciner | Vacciner 💉 | 0.1 | 🟢 Vert |
| 19 | Allaitement | Activer 🍼 / Désactiver | 0.25 | 🟢/🟠 |

### Convention globale boutons grisés
- Toujours un `tooltip` expliquant POURQUOI le bouton est grisé
- Format tooltip : "Raison (détail chiffré si pertinent)"
- Bouton `disabled` + `cursor: not-allowed` + `opacity: 0.5`
- Pendant appel API : bouton remplacé par `Spinner` inline, `pointer-events: none`
- Après succès : bouton peut changer d'état (ex: "Déjà nourri aujourd'hui")

### Convention ConfirmModal
Actions irréversibles nécessitant `ConfirmModal` :
- Vendre à l'abattoir (#15)
- Vendre lait (#14)
- Acheter animal (#1)
- Inséminer (#11, #12)

### Convention Toast
- ✅ Succès : fond vert, icône action, auto-dismiss 5s
- ❌ Erreur : fond rouge, message backend, persist jusqu'à clic
- ⚠️ Warning : fond orange, auto-dismiss 8s


---

## PAGES MANQUANTES — Ajout audit SimAgri

> Ces pages n'étaient pas spécifiées. Identifiées par comparaison avec SimAgri.

---

### Soigner un animal

**Prérequis visibles** : Animal malade (`health_status = 'sick'`). Depuis fiche animal ou action groupée.

**Écran** : Modale.
- Animal : nom, race, maladie détectée (nom + icône gravité)
- Gravité : Légère (🟡) / Moyenne (🟠) / Grave (🔴)
- Coût : `maladie.heal_cost` € + `maladie.heal_ht` HT
- Si action groupée : liste des animaux malades sélectionnés + coût total

**Bouton "Soigner" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | `player.balance >= coût` ET `player.ht >= ht_cost` ET animal malade |
| 🔘 Grisé | Tooltip "Solde insuffisant (besoin {X} €, reste {Y} €)" | `balance < coût` |
| 🔘 Grisé | Tooltip "HT insuffisants (besoin {X}, reste {Y})" | `ht < ht_cost` |
| 🔘 Grisé | Tooltip "Cet animal n'est pas malade" | `health_status != 'sick'` |

**Contrôles frontend :**
- Vérifier `animal.health_status === 'sick'`
- Calculer coût total si groupé : `sum(maladie.heal_cost)` et `sum(maladie.heal_ht)`
- Comparer avec `player.balance` et `player.ht_remaining`
- Bouton désactivé pendant appel API (`loading = true`)

**Appel API :**
```
POST /api/animals/:id/heal
Headers: X-Idempotency-Key: {uuid}
```
Action groupée :
```
POST /api/animals/batch-heal
Headers: X-Idempotency-Key: {uuid}
Body: { animal_ids: [1, 5, 12] }
```

**Contrôles backend :**
1. Ownership : animal appartient au joueur (sinon 403)
2. Animal vivant : `life_stage != 'dead'` (sinon 400 "Animal mort")
3. Animal malade : `health_status = 'sick'` (sinon 400 "Pas malade")
4. Solde : `SELECT balance FROM player WHERE id=$1 FOR UPDATE` ≥ coût (sinon 400 "Solde insuffisant")
5. HT : `ht_remaining >= ht_cost` (sinon 400 "HT insuffisants")
6. Idempotency : vérifier `X-Idempotency-Key` pas déjà traité (sinon 200 avec résultat précédent)
7. Batch : max 50 animaux par requête (sinon 400)

**Résultat succès :**
- Toast vert : "🩺 {nom} soigné !" (ou "🩺 {N} animaux soignés !")
- Solde header animé : -{coût} €
- HT header animé : -{ht_cost}
- Icône 🏥 disparaît de la ligne animal dans la DataTable
- Fiche animal : `health_status` passe à `'recovering'` puis `'healthy'` au prochain tick
- Widget dashboard "Malades" décrémenté

**Résultat erreur :**
- 400 → Toast rouge avec message exact du backend
- 403 → Toast "Cet animal ne vous appartient pas"
- Aucune déduction (transaction atomique côté backend)

**Effets de bord :**
- `UPDATE animal SET health_status='recovering', healed_at=NOW() WHERE id=$1`
- `UPDATE player SET balance = balance - $cost, ht_today = ht_today - $ht WHERE id=$1`
- `INSERT INTO ledger (player_id, category, label, amount) VALUES ($1, 'health', 'Soin {animal_name}', -$cost)`
- `INSERT INTO animal_health_log (animal_id, event, details) VALUES ($1, 'healed', '{maladie}')`
- Notification WS : `animal_alert` (compteur malades mis à jour)

---

### Vacciner un animal

**Prérequis visibles** : Animal non vacciné cette saison. Depuis fiche animal.

**Écran** : Modale.
- Animal : nom, race, dernier vaccin (date Cultivia ou "Jamais vacciné")
- Prochain vaccin possible : date calculée (1 vaccin / saison = 21 jours)
- Coût : 50 € + 0.5 HT (fixe)

**Bouton "Vacciner" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | `last_vaccinated_at` < début saison courante ET solde ≥ 50 ET HT ≥ 0.5 |
| 🔘 Grisé | Tooltip "Déjà vacciné cette saison (prochain : {date})" | Vacciné cette saison |
| 🔘 Grisé | Tooltip "Solde insuffisant" | `balance < 50` |
| 🔘 Grisé | Tooltip "HT insuffisants" | `ht < 0.5` |

**Contrôles frontend :**
- Vérifier `animal.last_vaccinated_at` vs date début saison courante
- Comparer solde et HT

**Appel API :**
```
POST /api/animals/:id/vaccinate
Headers: X-Idempotency-Key: {uuid}
```

**Contrôles backend :**
1. Ownership (403)
2. Animal vivant (400)
3. Pas vacciné cette saison : `last_vaccinated_at < season_start_date` (sinon 400 "Déjà vacciné")
4. Solde ≥ 50 (`SELECT FOR UPDATE`) (sinon 400)
5. HT ≥ 0.5 (sinon 400)
6. Idempotency key

**Résultat succès :**
- Toast vert : "💉 {nom} vacciné !"
- Badge 💉 apparaît sur la fiche et dans la DataTable
- Solde -{50} €, HT -{0.5}
- `animal.last_vaccinated_at = NOW()`

**Résultat erreur :**
- Toast rouge avec message backend
- Aucune déduction

**Effets de bord :**
- `UPDATE animal SET last_vaccinated_at=NOW() WHERE id=$1`
- `UPDATE player SET balance = balance - 50, ht_today = ht_today - 0.5 WHERE id=$1`
- `INSERT INTO ledger (player_id, category, label, amount) VALUES ($1, 'health', 'Vaccin {animal_name}', -50)`
- `INSERT INTO animal_health_log (animal_id, event) VALUES ($1, 'vaccinated')`
- Effet gameplay : réduit probabilité maladie de 80% pour la saison

---

### Inséminer un animal

**Prérequis visibles** : Femelle en période d'insémination, non gestante. Depuis fiche animal.

**Écran** : Modale.
- Femelle : nom, race, âge, état reproductif ("Prête" / "Gestante" / "Hors période")
- Choix méthode (radio) :
  - ○ Mâle de la ferme : dropdown mâles même race → coût 0 € + 1.0 HT
    - Chaque mâle affiche : nom, indices génétiques (5 barres miniatures)
  - ○ Insémination CIA : coût 200 € + 1.0 HT
    - Indices génétiques CIA affichés (supérieurs en moyenne)
- Comparaison génétique : tableau côte à côte femelle vs mâle choisi
- Estimation descendance : moyenne indices parents ± variation aléatoire

**Bouton "Inséminer" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Femelle prête + méthode choisie + solde OK + HT ≥ 1.0 |
| 🔘 Grisé | Tooltip "Pas en période d'insémination ({mois_début} à {mois_fin})" | Hors période |
| 🔘 Grisé | Tooltip "Déjà gestante (mise bas dans {X} jours)" | `is_pregnant = true` |
| 🔘 Grisé | Tooltip "Sélectionnez un mâle ou CIA" | Aucune méthode choisie |
| 🔘 Grisé | Tooltip "Aucun mâle de race {race} dans votre ferme" | Méthode mâle + 0 mâle dispo |
| 🔘 Grisé | Tooltip "Solde insuffisant (besoin 200 €)" | CIA + `balance < 200` |
| 🔘 Grisé | Tooltip "HT insuffisants" | `ht < 1.0` |

**Contrôles frontend :**
- Charger mâles disponibles : `GET /api/animals?species=cattle&sex=M&breed_id={breed}&farm_id={farm}`
- Vérifier période insémination selon espèce + mois Cultivia courant
- Vérifier `animal.is_pregnant === false`
- Afficher comparaison génétique en temps réel au changement de mâle

**Appel API :**
```
POST /api/animals/:id/inseminate
Headers: X-Idempotency-Key: {uuid}
Body: { method: "natural" | "cia", male_id: 42 }  // male_id requis si method=natural
```

**Contrôles backend :**
1. Ownership (403)
2. Animal vivant + femelle (400 "Seules les femelles peuvent être inséminées")
3. Pas gestante (400 "Déjà gestante")
4. En période d'insémination : vérifier mois Cultivia vs `breed.insemination_months` (400 "Hors période")
5. Si `method=natural` : `male_id` appartient au joueur, même race, vivant, mâle (400)
6. Si `method=cia` : solde ≥ 200 (`SELECT FOR UPDATE`)
7. HT ≥ 1.0
8. Idempotency key

**Résultat succès :**
- Toast vert : "🧬 {nom} inséminée ! Gestation estimée : {durée} jours Cultivia."
- Fiche animal : badge 🤰 apparaît, date mise bas estimée affichée
- Solde -{coût} € (0 si naturel, 200 si CIA), HT -{1.0}
- Indices génétiques du futur veau calculés (non affichés, surprise à la naissance)

**Résultat erreur :**
- Toast rouge avec message backend exact
- Aucune déduction

**Effets de bord :**
- `UPDATE animal SET is_pregnant=true, pregnant_since=NOW(), insemination_method=$method, mate_id=$male_id WHERE id=$1`
- `UPDATE player SET balance = balance - $cost, ht_today = ht_today - 1.0 WHERE id=$1`
- `INSERT INTO ledger` (si CIA : -200 €)
- `INSERT INTO animal_reproduction_log (animal_id, event, male_id, method) VALUES (...)`
- Calcul génétique descendance stocké : `offspring_genetics = avg(mother, father) + random_variation`
- Le tick vérifiera `pregnant_since + gestation_days` pour déclencher la naissance

---

### Traire les animaux

**Prérequis visibles** : Au moins 1 vache en lactation + salle de traite + cuve à lait.

**Écran** : Page `/animals/milking`.
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Traite" [Vaches en lactation: 8]                  │
├─────────────────────────────────────────────────────────────────┤
│ Prérequis : Salle de traite ✅ | Cuve à lait ✅ (120/500 L)    │
├─────────────────────────────────────────────────────────────────┤
│ ☐ | Nom      | Race          | Production estimée | Qualité    │
│ ☐ | Marguerite| Prim'Holstein | 28 L              | ⭐⭐⭐⭐   │
│ ☐ | Blanchette| Montbéliarde  | 22 L              | ⭐⭐⭐⭐⭐ │
├─────────────────────────────────────────────────────────────────┤
│ Total estimé : 180 L | Cuve restante : 380 L                   │
│ Coût : 1.0 HT                                                  │
│ [Traire toutes] [Traire sélection]                              │
└─────────────────────────────────────────────────────────────────┘
```

**Bouton "Traire toutes" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Salle de traite + cuve non pleine + HT ≥ 1.0 + vaches en lactation |
| 🔘 Grisé | Tooltip "Construisez une salle de traite" | Pas de salle de traite |
| 🔘 Grisé | Tooltip "Cuve à lait pleine ({X}/{Y} L) — vendez du lait" | `cuve.current >= cuve.capacity` |
| 🔘 Grisé | Tooltip "HT insuffisants (besoin 1.0, reste {Y})" | `ht < 1.0` |
| 🔘 Grisé | Tooltip "Aucune vache en lactation" | 0 vache avec `is_lactating = true` |
| 🔘 Grisé | Tooltip "Déjà traites aujourd'hui" | Toutes `last_milked_at = today` |

**Contrôles frontend :**
- Charger vaches en lactation : `GET /api/animals?species=cattle&is_lactating=true`
- Charger état cuve : `GET /api/buildings?type=milk_tank`
- Calculer production estimée par vache (formule : `base_production × breed_factor × health_factor × feed_quality`)
- Vérifier `total_production + cuve.current <= cuve.capacity` (sinon warning "Cuve insuffisante, seules X vaches seront traites")

**Appel API :**
```
POST /api/animals/milk
Headers: X-Idempotency-Key: {uuid}
Body: { animal_ids: [1, 2, 3] | all: true }
```

**Contrôles backend :**
1. Ownership : toutes les vaches appartiennent au joueur (403)
2. Salle de traite : joueur possède un bâtiment `type='milking_parlor'` (400 "Salle de traite requise")
3. Cuve à lait : joueur possède un bâtiment `type='milk_tank'` avec place (400 "Cuve pleine")
4. Vaches en lactation : chaque animal `is_lactating=true` ET `last_milked_at < today` (400)
5. HT ≥ 1.0 (400)
6. Idempotency key
7. `SELECT FOR UPDATE` sur player (solde HT) + cuve (capacité)

**Résultat succès :**
- Toast vert : "🥛 {total} L de lait collectés ! Qualité moyenne : ⭐⭐⭐⭐"
- Cuve mise à jour visuellement (barre remplissage animée)
- HT header : -{1.0}
- Chaque vache : `last_milked_at = today`
- Widget dashboard "Productions" mis à jour

**Résultat erreur :**
- 400 → Toast rouge avec message exact
- Aucune traite partielle (tout ou rien par requête)

**Effets de bord :**
- `UPDATE animal SET last_milked_at=NOW() WHERE id IN ($ids)`
- `UPDATE building SET current_stock = current_stock + $total WHERE type='milk_tank' AND farm_id=$1`
- `UPDATE player SET ht_today = ht_today - 1.0 WHERE id=$1`
- `INSERT INTO production_log (farm_id, product, quantity, quality, date) VALUES ($1, 'milk', $total, $avg_quality, NOW())`
- Qualité lait dépend de : race, alimentation, santé, génétique (indice QL)

---

### Vendre à l'abattoir

**Prérequis visibles** : Animal(aux) sélectionné(s), vivant(s). Depuis fiche ou action groupée.

**Écran** : ConfirmModal.
```
┌─────────────────────────────────────────────────────┐
│ 🔪 Vendre à l'abattoir                              │
│                                                      │
│ Animal(aux) :                                        │
│ • Marguerite (Prim'Holstein, Vache) — 650 kg         │
│   Cours : 3.99 €/kg → Estimé : 2 593.50 €           │
│ • Taurillon #42 (Charolaise) — 480 kg                │
│   Cours : 3.30 €/kg → Estimé : 1 584.00 €           │
│                                                      │
│ Total estimé : 4 177.50 €                            │
│ Coût : 0.5 HT × 2 animaux = 1.0 HT                 │
│ Bétaillère requise : ✅ (possédée)                   │
│                                                      │
│ ⚠️ Cette action est IRRÉVERSIBLE.                    │
│ [Annuler]                         [Confirmer vente]  │
└─────────────────────────────────────────────────────┘
```

**Bouton "Confirmer vente" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Rouge (danger) | Bétaillère possédée + HT ≥ 0.5×N |
| 🔘 Grisé | Tooltip "Bétaillère requise" | Pas de bétaillère |
| 🔘 Grisé | Tooltip "HT insuffisants (besoin {X})" | `ht < 0.5 * nb_animaux` |

**Contrôles frontend :**
- Calculer prix total : `sum(animal.weight × cours_actuel_espece_stade)`
- Vérifier possession bétaillère : `GET /api/equipment?type=livestock_trailer`
- Vérifier HT : `0.5 × nb_animaux`
- Afficher warning si animal gestante : "⚠️ Marguerite est gestante. Confirmer quand même ?"

**Appel API :**
```
POST /api/animals/slaughter
Headers: X-Idempotency-Key: {uuid}
Body: { animal_ids: [1, 42] }
```

**Contrôles backend :**
1. Ownership (403)
2. Animaux vivants (400 "Animal déjà mort")
3. Bétaillère possédée (400 "Bétaillère requise")
4. HT ≥ 0.5 × len(animal_ids) (400)
5. `SELECT FOR UPDATE` sur player
6. Calcul prix réel : `weight × market_price[species][life_stage]` (prix peut varier entre affichage et exécution)
7. Idempotency key
8. Max 20 animaux par requête (400)

**Résultat succès :**
- Toast vert : "🔪 {N} animaux vendus pour {total} €"
- Solde header : +{total} € (animé)
- HT header : -{ht_cost}
- Animaux retirés de la DataTable (animation fade-out)
- Compteur toolbar mis à jour
- Widget dashboard "Élevage" mis à jour

**Résultat erreur :**
- 400 → Toast rouge, aucun animal vendu (atomique)
- Si prix a changé entre affichage et exécution : le prix réel est appliqué (pas de rejet)

**Effets de bord :**
- `DELETE FROM animal WHERE id IN ($ids)` (ou `UPDATE SET life_stage='slaughtered'` pour historique)
- `UPDATE player SET balance = balance + $total, ht_today = ht_today - $ht WHERE id=$1`
- `INSERT INTO ledger (player_id, category, label, amount) VALUES ($1, 'sale', 'Vente abattoir {N} animaux', +$total)`
- `INSERT INTO slaughter_log (farm_id, animal_id, weight, price_kg, total, date) VALUES (...)`
- `UPDATE building SET animal_count = animal_count - 1 WHERE id=$building_id` pour chaque animal
- Statistiques carcasses mises à jour
- Réputation : pas d'impact (vente normale)

---

### Déplacer un animal

**Prérequis visibles** : Depuis fiche animal ou action groupée.

**Écran** : Modale.
- Animal(aux) sélectionné(s) : nom, race, lieu actuel
- Destination (dropdown groupé) :
  - **Bâtiments** : "Stabulation Nord (8/20 places) — 0.3 HT"
  - **Prés** : "Pré #3 (5/15 places) — 0.5 HT" (coût HT plus élevé si pré éloigné)
  - **Bétaillère** : "Bétaillère (0/5 places) — 0.2 HT" (si possédée)
- Coût HT total : `ht_par_animal × nb_animaux`
- Si pré : distance affichée "{X} km de la ferme"

**Bouton "Déplacer" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Destination choisie + place dispo + HT suffisants |
| 🔘 Grisé | Tooltip "Sélectionnez une destination" | Aucune destination |
| 🔘 Grisé | Tooltip "Pas assez de place ({X}/{Y})" | `destination.available < nb_animaux` |
| 🔘 Grisé | Tooltip "HT insuffisants" | `ht < coût_total` |
| 🔘 Grisé | Tooltip "Bétaillère requise pour aller au pré" | Destination = pré + pas de bétaillère |

**Contrôles frontend :**
- Charger destinations : `GET /api/buildings?has_space=true&species=cattle` + `GET /api/parcels?type=pasture&has_space=true`
- Calculer coût HT selon destination (bâtiment même ferme = 0.3, pré = 0.3 + distance/30)
- Vérifier bétaillère si destination = pré

**Appel API :**
```
POST /api/animals/move
Headers: X-Idempotency-Key: {uuid}
Body: { animal_ids: [1, 5], destination_type: "building" | "pasture" | "trailer", destination_id: 42 }
```

**Contrôles backend :**
1. Ownership animaux + destination (403)
2. Animaux vivants (400)
3. Destination a assez de place (400 "Pas assez de place")
4. Si pré : bétaillère possédée + tracteur (400)
5. HT suffisants (400)
6. `SELECT FOR UPDATE` sur player + destination (capacité)
7. Idempotency key

**Résultat succès :**
- Toast vert : "🚜 {N} animaux déplacés vers {destination_name}"
- HT header : -{coût}
- DataTable : colonne "Lieu" mise à jour pour chaque animal
- Ancien lieu : compteur décrémenté
- Nouveau lieu : compteur incrémenté

**Résultat erreur :**
- 400 → Toast rouge, aucun déplacement (atomique)

**Effets de bord :**
- `UPDATE animal SET building_id=$dest (ou parcel_id=$dest) WHERE id IN ($ids)`
- `UPDATE building SET animal_count = animal_count - $N WHERE id=$old_building`
- `UPDATE building SET animal_count = animal_count + $N WHERE id=$new_building` (ou parcel)
- `UPDATE player SET ht_today = ht_today - $ht WHERE id=$1`
- Si pré : vérifier saison (mise au pré autorisée selon espèce + saison Cultivia)

---

### Renommer un animal

**Prérequis visibles** : Depuis fiche animal. Clic sur l'icône ✏️ à côté du nom.

**Écran** : Input inline (le nom devient éditable).
- Placeholder : nom actuel
- Max 30 caractères
- Regex : `/^[a-zA-ZÀ-ÿ0-9 '-]+$/` (lettres, chiffres, espaces, apostrophes, tirets)
- Validation temps réel : bordure rouge si invalide

**Bouton : Sauvegarde au blur ou Enter.**

**Contrôles frontend :**
- Longueur 1-30 caractères
- Regex validée
- Debounce 0ms (sauvegarde immédiate au blur/Enter)
- Spinner inline pendant l'appel API

**Appel API :**
```
PUT /api/animals/:id
Body: { name: "Marguerite" }
```

**Contrôles backend :**
1. Ownership (403)
2. Animal vivant (400)
3. Nom : 1-30 chars, regex `/^[a-zA-ZÀ-ÿ0-9 '-]+$/` (400 "Nom invalide")
4. Sanitization : trim, pas de double espaces

**Résultat succès :**
- Nom mis à jour inline (pas de toast, feedback visuel : ✅ vert 1s à côté du nom)
- DataTable liste animaux : nom mis à jour si visible

**Résultat erreur :**
- Bordure rouge + message inline "Nom invalide" ou "Erreur serveur"
- Nom revient à la valeur précédente

**Effets de bord :**
- `UPDATE animal SET name=$name WHERE id=$1`
- Pas de coût HT ni € (action gratuite)

---

### Productions animales (`/animals/productions`)

**Prérequis visibles** : Joueur connecté. Au moins 1 production en stock ou 1 animal producteur.

**Écran** : Page avec onglets.
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Mes productions animales"                         │
│ [🥛 Lait] [🥚 Œufs] [🧶 Laine]                                 │
├─────────────────────────────────────────────────────────────────┤
│ 🥛 LAIT                                                         │
│                                                                 │
│ Stock actuel : 320 / 500 L  ████████████░░░░░ 64%              │
│ Production aujourd'hui : 180 L                                  │
│ Qualité moyenne : ⭐⭐⭐⭐ (indice QL: 78/100)                  │
│ Cours Marché Central : 0.38 €/L (↑ +0.02 vs hier)              │
│ Valeur stock estimée : 121.60 €                                 │
│                                                                 │
│ 📊 Production 30 derniers jours                                  │
│ [graphique barres : axe X = jour, axe Y = litres]               │
│ Hover → tooltip "03/04 : 175 L — QL: 76"                       │
│                                                                 │
│ Détail par vache :                                              │
│ Nom        | Race          | Prod/jour | QL   | Dernière traite │
│ Marguerite | Prim'Holstein | 28 L      | ⭐⭐⭐⭐| Aujourd'hui    │
│ Blanchette | Montbéliarde  | 22 L      | ⭐⭐⭐⭐⭐| Aujourd'hui │
│                                                                 │
│ [Vendre au Marché Central]  [Vendre à la laiterie CAR]          │
└─────────────────────────────────────────────────────────────────┘
```

**Cas vide :** "Aucune production de lait. Construisez une salle de traite et trayez vos vaches. [Construire]"

**Bouton "Vendre au Marché Central" — États :**
| État | Apparence | Condition |
|------|-----------|-----------|
| ✅ Actif | Vert | Stock > 0 + HT ≥ 0.5 |
| 🔘 Grisé | Tooltip "Stock vide" | `stock = 0` |
| 🔘 Grisé | Tooltip "HT insuffisants" | `ht < 0.5` |

**Au clic "Vendre au Marché Central" :**
- Modale : quantité (slider 1L → stock max), prix unitaire (cours actuel), total estimé
- Bouton "Confirmer vente"

**Appel API vente :**
```
POST /api/market/sell
Headers: X-Idempotency-Key: {uuid}
Body: { product: "milk", quantity: 200, price_per_unit: 0.38 }
```

**Contrôles backend vente :**
1. Stock suffisant (`SELECT current_stock FROM building WHERE type='milk_tank' FOR UPDATE`)
2. HT ≥ 0.5
3. Prix dans la fourchette autorisée (±30% du cours)
4. Idempotency key

**Résultat succès vente :**
- Toast vert : "🥛 200 L de lait vendus pour 76.00 €"
- Solde header : +76 €
- HT : -0.5
- Barre stock cuve mise à jour
- `INSERT INTO ledger (category='sale', label='Vente lait 200L', amount=+76)`

**Bouton "Vendre à la laiterie CAR" :**
- Même logique, mais prix fixé par contrat CAR
- Grisé si pas membre d'une CAR → tooltip "Rejoignez une CAR"
- Grisé si pas de contrat lait actif → tooltip "Aucun contrat lait avec votre CAR"

**API chargement page :**
```
GET /api/animals/productions
```
```json
{
  "milk": {
    "stock": 320, "capacity": 500,
    "today_production": 180, "avg_quality": 78,
    "market_price": 0.38, "price_delta": 0.02,
    "history_30d": [{ "date": "03/04", "quantity": 175, "quality": 76 }, ...],
    "per_animal": [{ "id": 1, "name": "Marguerite", "breed": "Prim'Holstein", "daily": 28, "quality": 82, "last_milked": "today" }]
  },
  "eggs": { ... },
  "wool": { ... }
}
```

**Effets de bord page :** Aucun (lecture seule, 0 HT).

---

### Arbre généalogique

**Prérequis visibles** : Depuis fiche animal, onglet "Généalogie".

**Écran** : Arbre visuel SVG sur 3 générations.
```
              [GP paternel ♂]──[GM paternelle ♀]
                       └──────┬──────┘
                         [Père ♂]
                                          [GP maternel ♂]──[GM maternelle ♀]
                                                   └──────┬──────┘
                                                     [Mère ♀]
                            └────────────┬────────────┘
                                  [Animal actuel]
```

**Chaque nœud affiche :**
- Nom (ou "Inconnu" si non tracé)
- Race
- 5 mini-barres indices génétiques (au hover : valeurs numériques)
- Badge : 🟢 vivant dans la ferme / 🔵 vendu / ⚫ mort / ❓ inconnu

**Interactions :**
- Clic sur nœud 🟢 → navigation vers fiche animal (`/animals/:id`)
- Clic sur nœud 🔵/⚫ → popup info (nom, race, indices, date vente/mort)
- Clic sur ❓ → rien (tooltip "Parent inconnu — animal acheté en coopérative")

**Contrôles frontend :**
- Composant `<PedigreeTree>` en SVG ou Canvas
- Responsive : sur mobile, arbre vertical scrollable
- Chargement lazy (pas chargé par défaut, uniquement quand onglet "Généalogie" cliqué)

**Appel API :**
```
GET /api/animals/:id/pedigree?depth=3
```
```json
{
  "animal": { "id": 1, "name": "Marguerite", "breed": "Prim'Holstein", "genetics": [72, 65, 80, 55, 68] },
  "father": {
    "id": 42, "name": "Taureau Royal", "status": "alive", "genetics": [85, 70, 75, 60, 72],
    "father": { "id": null, "name": "Inconnu", "status": "unknown" },
    "mother": { "id": 30, "name": "Belle", "status": "sold", "genetics": [78, 68, 82, 58, 70] }
  },
  "mother": {
    "id": 15, "name": "Blanchette", "status": "alive", "genetics": [68, 62, 78, 52, 65],
    "father": { "id": 8, "name": "Champion", "status": "dead", "genetics": [90, 75, 70, 65, 80] },
    "mother": { "id": null, "name": "Inconnu", "status": "unknown" }
  }
}
```

**Contrôles backend :**
1. Ownership de l'animal (403)
2. Animal vivant ou mort (pas supprimé)
3. Depth max 3 (ignorer si > 3)
4. Récursion SQL : `WITH RECURSIVE pedigree AS (...)` limité à 3 niveaux

**Résultat succès :** Arbre rendu avec animations d'apparition nœud par nœud.

**Résultat erreur :** Toast "Erreur chargement généalogie" + arbre vide avec message "Données indisponibles".

**Effets de bord :** Aucun (lecture seule, 0 HT).
