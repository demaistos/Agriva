# Audit Espèces & Complétude Boucles — 2026-04-06

> Audit croisé SimAgri ↔ Registry ↔ Seeds pour garantir la complétude par espèce.

---

## Problèmes identifiés et corrigés

### 1. Véhicules de transport par espèce

**Problème :** F002 exigeait bétaillère pour TOUT animal. SimAgri distingue 3 véhicules.

| Véhicule | Espèces | Action |
|----------|---------|--------|
| Bétaillère (tractée) | Bovins, bisons, caprins, ovins, porcins, daims | Existait ✅ |
| Utilitaire (motorisé) | Volailles, pintades, lapins, oies, canards | **Ajouté** au seed + F002 |
| Van (tracté par utilitaire) | Chevaux | **Ajouté** au seed + F002 |

**Corrections :**
- `05_vehicle_types.sql` : +2 utilitaires (Renault Master, Iveco Daily) + 1 van (Ifor Williams)
- F002 : disabled states + requires conditionnels par espèce
- F002 : note explicative ajoutée

### 2. Bâtiments manquants

| Bâtiment | Usage | Action |
|----------|-------|--------|
| Parc à volailles | Semi-liberté volailles (10m²/animal) | **Ajouté** au seed |
| Parc à porcins | Plein-air porcins (1 abri = 10 places) | **Ajouté** au seed |
| Salle de conditionnement | Ramasser/conditionner œufs | **Ajouté** au seed |
| Pièce stockage œufs | Stocker œufs conditionnés | **Ajouté** au seed |

### 3. Flows de vente manquants

| Flow | Production | Action |
|------|-----------|--------|
| F099 — Vendre laine | Laine (ovins) | **Créé** |
| F100 — Vendre œufs | Œufs avec calibrage S/M/L/XL | **Créé** |

### 4. F083 (ramasser œufs) incomplet

**Problème :** Pas de prérequis salle conditionnement ni stockage, pas de calibrage.

**Corrections :**
- Ajout requires : `infra:salle_conditionnement`, `infra:piece_stockage_oeuf`
- Ajout disabled states : stockage plein, pas de salle
- Ajout calibrage basé sur l'âge de la poule (S/M/L/XL)

---

## État final

| Métrique | Avant | Après |
|----------|-------|-------|
| Flows | 98 | 100 |
| Types véhicules seed | ~40 | ~43 (+utilitaire ×2, van ×1) |
| Types bâtiments seed | ~18 | ~22 (+4 bâtiments) |
| Espèces avec boucle complète | Bovins seuls | Bovins, ovins, caprins, porcins, volailles, lapins |
| Document matrice espèces | ❌ | ✅ `MATRICE_ESPECES.md` |

---

## Reste à faire (P2/P3, post-MVP)

- Foie gras (oies/canards) — activité secondaire complexe
- Chevaux — pas de production, juste élevage/vente
- Mode semi-liberté vs intensif — impacte croissance et label
- Fromage, méthanisation, viticulture — extensions futures
