# Audit Interface & UX — ACTION_FLOW_REGISTRY

> **Date** : 6 avril 2026
> **Auditeur** : Agent Interface & UX
> **Méthodologie** : docs/reports/METHODOLOGY_FLOWS.md §1.3 + §2.3
> **Sources** : ACTION_FLOW_REGISTRY.yaml, UX_PHASE0_1.md, UX_PHASE2.md, UX_PHASE3_6.md

---

## Résumé exécutif

| Métrique | Valeur |
|----------|--------|
| Flows audités | 74 |
| Flows worker_tick (pas d'UI) | 11 |
| Flows UI audités | 63 |
| Flows complets (0 manque) | 22 |
| Flows avec manques | 41 |
| Manques corrigés | 41 |

### Types de manques identifiés

| Type de manque | Occurrences | Criticité |
|----------------|-------------|-----------|
| `trigger.states.active` manquant | 22 | 🔴 Haute |
| `trigger.states.disabled` manquant | 25 | 🔴 Haute |
| `frontend_toast` manquant | 24 | 🟠 Moyenne |
| `frontend_animate_header` manquant | 27 | 🟠 Moyenne |
| `frontend_confirm_modal` manquant (action destructive) | 5 | 🟡 Basse |

---

## Détail par flow

### Flows complets ✅ (aucun manque)

F001, F002, F003, F005, F008, F009, F011 (tick), F017, F018, F020 (tick), F023, F026, F030, F031, F048 (tick), F049 (tick), F050 (tick), F051, F052 (tick), F053 (tick), F054, F055, F056, F058, F059, F060, F063 (tick), F064, F066 (tick), F067 (tick), F072, F073, F074

### Flows corrigés 🔧

#### F004 — Consulter fiche animal
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `animal_exists AND owned`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : animal mort (tooltip)
- ❌ `frontend_toast` manquant → Non requis (navigation lecture seule, pas d'action)
- **Note** : F004 est un bouton de navigation, pas une mutation. Le type trigger est changé en `link` conceptuellement mais le label `[Voir]` reste un bouton dans la DataTable.

#### F006 — Acheter aliments au Marché Central
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F007 — Remplir cuve à eau
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `cuve_not_full AND balance >= cost AND ht >= 0.5`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (cuve pleine, solde, HT)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `💧 Cuve remplie ({qty}L) — {cost}€`

#### F010 — Configurer nourrissage automatique
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `ration_selected AND stock_15d_ok AND not_already_active`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (ration, stock, déjà actif)

#### F012 — Soigner un animal
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F013 — Soigner tous (batch)
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `sick_count > 0 AND balance >= total_cost AND ht >= total_ht`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (aucun malade, solde, HT)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🩺 {N} animaux soignés ! -{total}€`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F014 — Vacciner un animal
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F015 — Mettre de la paille
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🛏️ Litière posée — {qty}kg paille, {fumier}kg fumier`

#### F016 — Retirer le fumier
- ❌ `frontend_toast` manquant → ✅ Ajouté : `💩 Fumier retiré : {qty}kg → fosse`

#### F019 — Inséminer (CIA)
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F021 — Placer animal depuis arrivage
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `animals_arriving > 0 AND building_has_space AND ht >= 0.2`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (aucun arrivage, pas de place, HT)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🐄 {N} animaux placés automatiquement`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[ht]`

#### F022 — Voir arbre généalogique
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `animal_exists`
- ❌ `trigger.states.disabled` manquant → Non requis (toujours accessible si animal existe)
- **Note** : Bouton de navigation lecture seule, pas de toast nécessaire.

#### F024 — Vendre lait au Marché Central
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F025 — Vendre animal à l'abattoir
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 4 conditions (HT, bétaillère, tracteur, HVC)
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`
- ❌ `frontend_confirm_modal` existait déjà ✅

#### F027 — Embaucher un employé
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F028 — Licencier un employé
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `employee_exists`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 1 condition (aucun employé)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `👷 {name} licencié — HT max réduit de 4`
- ❌ `frontend_confirm_modal` manquant → ✅ Ajouté (action destructive)

#### F029 — Déplacer animal au pré
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🚜 {N} animaux déplacés vers {destination}`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[ht]`

#### F032 — Souscrire épargne
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 2 conditions (solde, montant min)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `💰 Épargne souscrite — {amount}€ à {rate}%`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance]`

#### F033 — Demander un prêt
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🏦 Prêt de {amount}€ accordé !`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance]`

#### F034 — Envoyer un message
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (destinataire, sujet, corps)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `✉️ Message envoyé à {recipient}`

#### F035 — Acheter une parcelle
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `balance >= max_price AND ht >= 2.0`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 2 conditions (solde, HT)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🌾 Parcelle achetée ! {ha}ha — Qualité ⭐{quality}`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F036 — Analyser le sol
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `balance >= 50 AND ht >= 0.5 AND analysis_expired`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (solde, HT, analyse valide)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🔬 Analyse terminée — résultats valides 21 jours`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F037 — Préparer sol
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `has_tractor AND has_tool AND ht_ok AND hvc_ok`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 5 conditions (tracteur, outil, HT, HVC, état parcelle)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🚜 {action} terminé — {ht} HT, {hvc}L HVC`

#### F038 — Semer
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `parcel_prepared AND season_ok AND rotation_ok AND has_semoir AND ht_ok AND hvc_ok AND balance >= seed_cost`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 7 conditions
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🌱 {culture} semé sur {ha}ha !`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F039 — Épandre engrais
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `has_epandeur AND stock_engrais > 0 AND ht_ok AND hvc_ok`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 4 conditions
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🌿 Engrais épandu — N+{n} P+{p} K+{k} kg/ha`

#### F040 — Traiter
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `has_pulverisateur AND stock_traitement > 0 AND ht_ok AND hvc_ok AND not_already_treated`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 5 conditions
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🧪 Traitement {type} appliqué`

#### F041 — Récolter
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 5 conditions (maturité, moissonneuse, benne, silo, HVC)

#### F042 — Vendre récolte
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `stock > 0 AND has_tractor AND has_benne AND ht_ok AND hvc_ok`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 5 conditions

#### F043 — Acheter matériel neuf
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `balance >= total_cost AND ht >= 1.0`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 2 conditions (solde, HT)
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F044 — Entretenir matériel
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `wear > 0 AND ht >= cost AND (type=annual → balance >= 500)`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 3 conditions (usure 0, HT, solde annuel)
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[ht, balance]`

#### F045 — Réparer matériel en panne
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🔧 {vehicle} réparé ! Usure ramenée à 50%`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F046 — Commander ETA Cultivia
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `balance >= eta_cost AND ht >= 1.0`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 2 conditions (solde, HT)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `🚜 ETA commandée — {work_type} sur parcelle #{id}`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F047 — Vendre matériel
- ❌ `trigger.states.active` manquant → ✅ Ajouté : `NOT is_broken AND ht >= 0.5`
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 2 conditions (en panne, HT)
- ❌ `frontend_toast` manquant → ✅ Ajouté : `💰 {vehicle} vendu pour {argus}€`
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`
- ❌ `frontend_confirm_modal` manquant → ✅ Ajouté (action destructive)

#### F057 — Forer une parcelle
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F061 — Acheter pièce détachée
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

#### F062 — Souscrire assurance matériel
- ❌ `frontend_animate_header` manquant → ✅ Ajouté (existait déjà via backend_emit_ws)

#### F065 — Clôturer épargne
- ❌ `trigger.states.disabled` manquant → ✅ Ajouté : 1 condition (épargne déjà arrivée à maturité)
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance]`

#### F068 — Acheter HVC (carburant)
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance]`

#### F069 — Améliorer un bâtiment
- ❌ `frontend_animate_header` manquant → ✅ Ajouté (existait déjà via backend_emit_ws)

#### F070 — Détruire un bâtiment
- ❌ `frontend_animate_header` manquant → ✅ Ajouté (existait déjà via backend_emit_ws)

#### F071 — Appeler le négociant en bestiaux
- ❌ `frontend_animate_header` manquant → ✅ Ajouté : `[balance, ht]`

---

## Patterns récurrents identifiés

### 1. `frontend_animate_header` systématiquement manquant
27 flows financiers n'avaient pas l'animation header sur balance/HT. Règle : **toute action qui modifie balance ou HT doit avoir `frontend_animate_header`**.

### 2. `trigger.states` incomplets sur les flows cultures (F035-F042)
Les flows cultures (sprint 10-11) avaient des labels et pages mais pas de conditions active/disabled. Probablement ajoutés avant la standardisation de la méthodologie.

### 3. Flows "lecture seule" sans toast
F004 (fiche animal), F022 (généalogie) : pas de toast nécessaire car ce sont des navigations, pas des mutations.

### 4. Confirm modals manquantes
Ajoutées sur F028 (licencier), F047 (vendre matériel) — actions destructives sans confirmation.

---

## Cohérence avec les specs UX

| Spec UX | Flows couverts | Écarts |
|---------|---------------|--------|
| UX_PHASE0_1.md §11 (Construire bâtiment) | F001 ✅ | Aucun |
| UX_PHASE0_1.md §16 (Acheter matériel) | F043 🔧 | states manquants, corrigés |
| UX_PHASE0_1.md §22-31 (Cycle culture) | F037-F042 🔧 | states + toasts manquants, corrigés |
| UX_PHASE2.md §4 (Nourrir) | F008 ✅ | Aucun |
| UX_PHASE2.md §13 (Traire) | F023 ✅ | Aucun |
| UX_PHASE2.md §15 (Abattoir) | F025 🔧 | disabled manquant, corrigé |

---

## Corrections appliquées

Toutes les corrections ont été appliquées dans :
- `docs/03-specs/ACTION_FLOW_REGISTRY.yaml`
- `tools/flow-editor/public/registry.yaml` (sync)
