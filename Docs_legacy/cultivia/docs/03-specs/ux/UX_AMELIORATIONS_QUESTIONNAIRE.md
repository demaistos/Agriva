# Améliorations UX — Issues du questionnaire 10 000 joueurs

> 10 améliorations identifiées, priorisées, assignées à un sprint.
> Source : docs/reports/QUESTIONNAIRE_DETAIL_FEATURES.md

---

## UX-01 — Breakdown rendement estimé avant récolte
**Source :** Q4.6 (3.0/5) — pire note du questionnaire
**Sprint :** 11 (avec F041 récolter)
**Page :** `/parcels/:id` onglet Culture
**Spec :**
- Nouveau composant `YieldEstimateBreakdown`
- Affiché quand la culture est à ≥80% de croissance
- Format : tableau des 9 facteurs avec leur impact

```
Rendement estimé : 7.1 T/ha (71T pour 10ha)
─────────────────────────────────────────
Base blé                    7.0 T/ha
× Semence certifiée         +10%  → 7.7
× Sol fertilité ★3          -5%   → 7.3
× Engrais NPK               OK    → 7.3
× Traitement fongicide       OK    → 7.3
× Traitement herbicide       ❌    → 6.6 (-10%)
× Irrigation                 OK    → 6.6
× Météo saison              -3%   → 6.4
× Roulage                   +4%   → 6.7
× Fatigue sol (rotation)     OK    → 6.7
× Sur-maturité (2j)         -4%   → 6.4
─────────────────────────────────────────
= 6.4 T/ha × 10ha = 64T
```
- Chaque ligne : vert si bonus, rouge si malus, gris si neutre
- Endpoint : `GET /api/parcels/:id/yield-estimate`

---

## UX-02 — Comparatif litière vs caillebotis
**Source :** Q1.6 (3.1/5)
**Sprint :** 5 (avec F107 changer sol)
**Page :** `/buildings/:id` modale changement sol
**Spec :**
```
┌─────────────────┬──────────────┬──────────────┐
│                 │ 🛏️ Litière   │ ⬜ Caillebotis│
├─────────────────┼──────────────┼──────────────┤
│ Déjection       │ Fumier       │ Lisier       │
│ Paille requise  │ Oui          │ Non          │
│ Fosse requise   │ Fosse fumier │ Fosse lisier │
│ Mise au pré     │ Possible     │ Impossible   │
│ Label plein-air │ Possible     │ Impossible   │
│ Entretien       │ Pailler      │ Aucun        │
└─────────────────┴──────────────┴──────────────┘
```

---

## UX-03 — Icône véhicule par espèce sur page achat
**Source :** Q2.2 (3.3/5)
**Sprint :** 3 (avec F002 acheter animal)
**Page :** `/market/animals`
**Spec :**
- Quand le joueur sélectionne une espèce dans le filtre, afficher l'icône du véhicule requis :
  - Bovins/ovins/caprins/porcins → 🚜+🐄 "Tracteur + Bétaillère"
  - Volailles/pintades/lapins → 🚐 "Utilitaire"
  - Chevaux → 🚐+🐴 "Utilitaire + Van"
- Si le joueur n'a pas le véhicule → badge rouge "⚠️ Véhicule manquant"

---

## UX-04 — Calendrier reproduction sur fiche animal
**Source :** Q3.2 (3.2/5)
**Sprint :** 6 (avec F018/F019 inséminer)
**Page :** `/animals/:id` section Reproduction
**Spec :**
- Barre horizontale 12 mois avec zone verte = période fertile
- Indicateur position actuelle (mois courant)
- Si hors période → texte "Hors période. Prochaine : {mois}"
- Si en période → texte "En période fertile ✅"

---

## UX-05 — Cultures recommandées par rotation
**Source :** Q4.4 (3.2/5)
**Sprint :** 10 (avec F038 semer)
**Page :** `/parcels/:id` onglet Culture, bouton Semer
**Spec :**
- Sous le sélecteur de culture, afficher :
```
Dernière culture : Blé (récolté il y a 3 mois)
Recommandé : Colza ✅  Pois ✅  Tournesol ✅
Interdit :   Blé ❌ (rotation 1 an minimum)
```
- Basé sur `crop_history` + `crop_type.rotation_years`

---

## UX-06 — Ration "Basique" pré-sélectionnée
**Source :** Q2.3 (3.3/5)
**Sprint :** 4 (avec F008 nourrir)
**Page :** `/buildings/:id/feed`
**Spec :**
- À la création du bâtiment, une ration "Basique" est auto-créée (foin seul pour bovins, blé seul pour volailles)
- Cette ration est pré-sélectionnée par défaut
- Bouton "Personnaliser ration ▸" pour accéder aux rations avancées
- La ration basique a une qualité ★2 (suffisante pour survivre, pas optimale)

---

## UX-07 — Récapitulatif charges avant tick mensuel
**Source :** Q5.5 (3.4/5)
**Sprint :** 9 (avec F067 tick mensuel)
**Page :** `/dashboard` widget Finances + `/finances`
**Spec :**
- Le dimanche (veille du tick lundi), afficher un bandeau :
```
📊 Prélèvements prévus demain :
  Salaires      1 600€
  Prêt            850€
  Énergie         120€
  Taxes            50€
  ─────────────────────
  Total         2 620€
  Solde après  45 380€  ✅
```
- Si solde après < 0 → bandeau rouge "⚠️ Solde insuffisant — risque licenciement"

---

## UX-08 — Indicateur tendance cours marché
**Source :** Q8.7 (3.3/5)
**Sprint :** 10 (avec F026 cours marché)
**Page :** `/market/prices`
**Spec :**
- Sparkline 30 jours à côté de chaque produit
- Badge tendance : "📈 +8% sur 7j" ou "📉 -5% sur 7j"
- Tooltip : "Bon moment pour vendre" (si hausse >5%) / "Attendez" (si baisse)

---

## UX-09 — Tooltip presser vs broyer comparatif
**Source :** Q4.8 (3.3/5)
**Sprint :** 11 (avec F059/F060)
**Page :** `/parcels/:id` onglet Paille (après récolte)
**Spec :**
- Deux boutons côte à côte avec comparatif :
```
┌─────────────────────┬─────────────────────┐
│ 📦 Presser          │ 🌿 Broyer           │
│ → Balles vendables  │ → Nutriments au sol  │
│ Revenu : ~3 600€    │ Revenu : 0€          │
│ Sol : nutriments -  │ Sol : nutriments ++  │
│ Besoin : presse     │ Besoin : broyeur     │
└─────────────────────┴─────────────────────┘
```

---

## UX-10 — Fil d'actualité serveur sur dashboard
**Source :** Q7.10 (3.3/5)
**Sprint :** 8 (avec F031 dashboard)
**Page :** `/dashboard` widget News
**Spec :**
- Widget "Actualités du serveur" :
  - "🐄 Marcel a vendu 5 Charolaises à l'abattoir"
  - "🌾 Sophie a récolté 120T de blé (record du mois !)"
  - "🏆 Nouveau #1 au classement élevage : Lucie"
  - "📈 Cours du colza en hausse (+12%)"
- Max 10 entrées, rafraîchi toutes les heures
- Anonymisé si le joueur a désactivé la visibilité (préférences)

---

## Récapitulatif planning

| UX | Nom | Sprint | Effort |
|----|-----|--------|--------|
| UX-01 | Breakdown rendement | 11 | Moyen (endpoint + composant) |
| UX-02 | Comparatif sol | 5 | Faible (composant) |
| UX-03 | Icône véhicule espèce | 3 | Faible (badge) |
| UX-04 | Calendrier reproduction | 6 | Faible (composant) |
| UX-05 | Cultures recommandées | 10 | Faible (logique rotation) |
| UX-06 | Ration basique défaut | 4 | Faible (seed + UI) |
| UX-07 | Récap charges mensuel | 9 | Moyen (calcul prévisionnel) |
| UX-08 | Tendance cours marché | 10 | Moyen (sparkline + calcul) |
| UX-09 | Tooltip presser/broyer | 11 | Faible (composant) |
| UX-10 | Fil actualité serveur | 8 | Moyen (endpoint + WS) |
