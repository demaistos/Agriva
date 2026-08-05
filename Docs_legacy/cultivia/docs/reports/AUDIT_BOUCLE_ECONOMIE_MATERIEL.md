# AUDIT — Boucles Économie & Matériel

> **Expert Économie & Matériel** — Audit de bout en bout
> Date : 2026-04-06
> Sources : `regle sim.txt`, `ACTION_FLOW_REGISTRY.yaml`, specs phases 0-4, `08_EQUILIBRAGE_ECONOMIQUE.md`

---

## SYNTHÈSE EXÉCUTIVE

| Métrique | Valeur |
|----------|--------|
| Étapes analysées | 22 (12 matériel + 10 économie) |
| Flows existants dans le registry | 14 couvrent ces boucles |
| **Lacunes critiques** | **7** |
| Lacunes mineures | 5 |
| Flows manquants à créer | 6 |
| Corrections registry | 8 |

---

## 1. BOUCLE MATÉRIEL — Cycle de vie complet

### 1.1 Analyse étape par étape

| # | Étape | Flow registry | Spec phase | SimAgri ref | Statut |
|---|-------|--------------|------------|-------------|--------|
| M1 | Acheter neuf (concessionnaire PNJ) | F043 ✅ | PHASE1 F5 ✅ | ✅ | **OK** |
| M2 | Livraison (délai distance) | F049 ✅ | PHASE1 F5 ✅ | ✅ | **OK** |
| M3 | Utilisation quotidienne (usure action) | Implicite dans F002/F006/F008… | PHASE1 F4 ✅ | ✅ | **OK** |
| M4 | Usure passive quotidienne (abrité/non) | Tick step 8 | PHASE1 F4 ✅ | ✅ | **OK** |
| M5 | Entretien mensuel (1 HT, -5% usure) | F044 ✅ | PHASE1 F5 ✅ | ✅ | **OK** |
| M6 | Entretien annuel (2 HT, 500€, -15% usure) | F044 ✅ | PHASE1 F5 ✅ | ✅ | **OK** — body `type: monthly\|annual` |
| M7 | Panne aléatoire (>70% usure) | Tick step 9 | PHASE1 F4 ✅ | ✅ | **OK** |
| M8 | Réparation (pièce détachée + €) | F045 ✅ | PHASE1 F5 ✅ | ✅ | **⚠️ LACUNE** — voir §1.2.1 |
| M9 | Assurance matériel | ❌ **ABSENT** | PHASE_COMP F10 ✅ | ✅ | **❌ MANQUE FLOW** |
| M10 | Revente argus (Coop 60%) | F047 ✅ | PHASE1 F5 ✅ | ✅ | **OK** |
| M11 | Achat occasion (entre joueurs) | ❌ **ABSENT** | PHASE4 F3 (concessionnaire) | ✅ | **❌ MANQUE FLOW** |
| M12 | Location matériel (tracteur en panne) | ❌ **ABSENT** | ❌ **NON SPÉCIFIÉ** | ✅ | **❌ MANQUE FLOW + SPEC** |

### 1.2 Lacunes critiques matériel

#### 1.2.1 ❌ F045 — Réparation : pièces détachées incomplètes

**Problème :** Le flow F045 mentionne `has_piece` et `Consume 1 piece` mais :
- Aucun flow d'**achat de pièces détachées** n'existe dans le registry
- SimAgri a un système complet : chaque matériel a 1-5 pièces, chaque pièce s'use selon les PA utilisés, le remplacement se fait chez un concessionnaire ou à la Coop
- Le registry ne modélise pas l'usure individuelle des pièces (pneus, filtres, socs…)

**Impact :** Le joueur ne peut pas acheter de pièces → ne peut pas réparer → matériel bloqué.

**Correction :** Créer flow **F061 — Acheter pièce détachée** (sprint 12).

#### 1.2.2 ❌ Assurance matériel — Aucun flow

**Problème :** La spec PHASE_COMPLEMENTS Feature 10 définit l'assurance (3% argus/an, couvre 100% réparations) mais aucun flow n'existe dans le registry.

**Impact :** Feature spécifiée mais non traçable dans le pipeline de développement.

**Correction :** Créer flows **F062 — Souscrire assurance matériel** et **F063 — Tick expiration assurance** (sprint 12).

#### 1.2.3 ❌ Achat occasion entre joueurs — Aucun flow

**Problème :** SimAgri a un marché de l'occasion riche (annonces, négociation, concessionnaire intermédiaire). Le registry n'a aucun flow pour l'achat/vente d'occasion entre joueurs. PHASE4 Feature 3 (concessionnaire joueur) couvre le dépôt-vente mais pas l'achat direct entre joueurs.

**Impact :** Pas de marché secondaire du matériel → économie matériel fermée.

**Correction :** Créer flow **F064 — Vendre matériel entre joueurs** (sprint 15, dépend de F043 + annonces).

#### 1.2.4 ❌ Location matériel — Non spécifié

**Problème :** SimAgri permet la location de tracteur quand le sien est en panne (même puissance ±5 CV, durée = durée d'immobilisation). Ni spec ni flow dans Cultivia.

**Impact :** Un joueur dont le tracteur tombe en panne et qui n'a pas de pièce est totalement bloqué. L'ETA Cultivia (PNJ) compense partiellement mais ne couvre pas le transport.

**Décision recommandée :** Reporter en Phase 4+ (le PNJ ETA suffit comme filet de sécurité en Phase 1-3). Documenter comme feature future.

#### 1.2.5 ⚠️ F043 — Livraison concessionnaire : coût de livraison absent du flow

**Problème :** F043 calcule `delivery_cost = distance_km × 0.80` et `delivery_delay` mais le SQL ne débite pas explicitement le `delivery_cost` — seul `prix` est débité.

**Correction :** Ajouter dans le SQL de F043 : `UPDATE player SET balance -= (prix + delivery_cost)`.

#### 1.2.6 ⚠️ F044 — Entretien : pas de distinction coût mensuel vs annuel

**Problème :** F044 SQL dit `balance -= 0|500` mais ne détaille pas la logique. PHASE1 F5 spécifie :
- Mensuel : 1 HT, 0€, -5% usure
- Annuel : 2 HT, 500€, -15% usure

Le flow devrait expliciter les deux branches.

**Correction :** Enrichir le SQL de F044 avec les deux cas.

#### 1.2.7 ⚠️ Entretien concessionnaire (atelier joueur) — Non modélisé

**Problème :** SimAgri permet de faire entretenir son matériel chez un concessionnaire (mécanicien, compétences, prix variable). Cultivia ne modélise que l'auto-entretien.

**Décision :** Couvert par PHASE4 Feature 3 (concessionnaire joueur + atelier). OK pour Phase 1-3.

---

## 2. BOUCLE ÉCONOMIE — Analyse de bout en bout

### 2.1 Analyse étape par étape

| # | Étape | Flow registry | Spec phase | SimAgri ref | Statut |
|---|-------|--------------|------------|-------------|--------|
| E1 | Acheter aliments (Marché Central) | F006 ✅ | PHASE2 ✅ | ✅ | **OK** |
| E2 | Stocker (silo/hangar/entrepôt) | Implicite dans F006 | PHASE1 F3 ✅ | ✅ | **⚠️ LACUNE** — voir §2.2.1 |
| E3 | Remplir eau (cuve) | F007 ✅ | PHASE2 ✅ | ✅ | **OK** |
| E4 | Embaucher employé | F027 ✅ | PHASE3 §13 ✅ | ✅ | **⚠️ LACUNE** — voir §2.2.2 |
| E5 | Licencier employé | F028 ✅ | PHASE3 §13 ✅ | ✅ | **OK** |
| E6 | Épargne (3 formules) | F032 ✅ | PHASE3 §11 ✅ | ✅ | **⚠️ LACUNE** — voir §2.2.3 |
| E7 | Prêts bancaires | F033 ✅ | PHASE1 F12 ✅ | ✅ | **⚠️ LACUNE** — voir §2.2.4 |
| E8 | Messagerie | F034 ✅ | PHASE3 ✅ | ✅ | **OK** |
| E9 | Salaires (tick mensuel) | ❌ **ABSENT** | PHASE3 §13 ✅ | ✅ | **❌ MANQUE FLOW** |
| E10 | MSA + Taxe foncière (tick mensuel) | ❌ **ABSENT** | PHASE1 F14ter ✅ | ✅ | **❌ MANQUE FLOW** |
| E11 | Facture énergie (tick mensuel) | ❌ **ABSENT** | PHASE1 F3 ✅ | ✅ | **❌ MANQUE FLOW** |
| E12 | Remboursement prêt (tick mensuel) | ❌ **ABSENT** | PHASE1 F12 ✅ | ✅ | **❌ MANQUE FLOW** |

### 2.2 Lacunes critiques économie

#### 2.2.1 ⚠️ Stockage — Débordement et péremption non modélisés dans le registry

**Problème :** Les flows F006, F041, F024 vérifient `stock + qty <= capacity` mais :
- **Débordement** : F041 (récolte) auto-vend l'excédent — OK, mais pas de notification explicite dans le flow
- **Péremption** : SimAgri a des pertes sur le silo taupe et l'aire de stockage paille/foin. Cultivia ne modélise aucune péremption.
- **Lait** : la cuve à lait devrait avoir une DLC (48h max dans SimAgri). Non spécifié.

**Correction :**
- Ajouter dans F041 un step `frontend_toast` pour l'excédent auto-vendu (déjà présent ✅)
- Créer un tick de péremption lait (48h) — à spécifier en PHASE2
- Reporter la péremption paille/silo taupe en Phase 4+ (complexité faible, impact gameplay faible)

#### 2.2.2 ⚠️ F027 — Embauche : incohérence salaire

**Problème :**
- F027 dit `Embaucher 500 €` et `balance -= 500, ht_max += 4`
- PHASE3 §13 dit `salaire = 1 600€/mois` (ou 1 750€ dans le SQL)
- `08_EQUILIBRAGE_ECONOMIQUE.md` dit `1 600€/mois`
- SimAgri dit `1 750€/mois`

**Incohérences :**
1. Le coût d'embauche (500€) dans F027 ≠ premier salaire (1 600€) dans la spec
2. Le salaire varie entre 1 600€ et 1 750€ selon les docs
3. F027 donne `+4 HT/jour` mais la spec dit `pa_per_day = variable`

**Correction :**
- Aligner sur **1 600€/mois** (choix Cultivia, plus accessible que SimAgri)
- F027 : le coût d'embauche = premier mois de salaire = 1 600€
- HT : fixer à **+4 HT/jour** par employé agricole (cohérent avec F027)
- Max 3 employés (cohérent avec F027)

#### 2.2.3 ⚠️ F032 — Épargne : flow incomplet

**Problème :** F032 ne couvre que la souscription. Manquent :
- Clôture anticipée
- Tick intérêts (date anniversaire)
- Maturité automatique

**Correction :** Créer **F065 — Clôturer épargne** et **F066 — Tick intérêts épargne** (sprint 9).

#### 2.2.4 ⚠️ F033 — Prêt : incohérence plafond

**Problème :**
- F033 dit `total_loans + amount <= 150000`
- PHASE1 F12 dit `MAX_TOTAL_LOANS = 150000`
- `08_EQUILIBRAGE_ECONOMIQUE.md` dit `150 000€`
- Mais PHASE1 F12 description dit `120 000€`

**Correction :** Aligner sur **150 000€** partout (décision de `08_EQUILIBRAGE_ECONOMIQUE.md`).

#### 2.2.5 ❌ Ticks mensuels économiques — Aucun flow

**Problème critique :** 4 prélèvements mensuels automatiques sont spécifiés dans les phases mais n'ont **aucun flow** dans le registry :

| Prélèvement | Spec | Flow |
|-------------|------|------|
| Salaires employés | PHASE3 §13 | ❌ |
| Remboursement prêts | PHASE1 F12 | ❌ |
| Facture énergie | PHASE1 F3 | ❌ |
| Taxe foncière + MSA | PHASE1 F14ter | ❌ |

**Impact :** Sans ces ticks, l'économie n'a pas de sinks récurrents → inflation garantie.

**Correction :** Créer **F067 — Tick mensuel économique** (sprint 9) qui regroupe les 4 prélèvements en un seul worker tick.

---

## 3. STOCKAGE — Analyse capacité/débordement/péremption

### 3.1 Inventaire des structures de stockage

| Structure | Unité | Produits | Débordement | Péremption | Flow |
|-----------|-------|----------|-------------|------------|------|
| Silo | tonnes | Récoltes (blé, maïs…) | Auto-vente excédent (F041) | ❌ Non modélisé | F041 |
| Hangar | m² | Matériels (20m²/unité) | Matériel non abrité | N/A | F043 (implicite) |
| Entrepôt | m² | Balles, semences, engrais, traitements | ❌ Non modélisé | ❌ Non modélisé | ❌ Aucun flow |
| Fosse fumier | tonnes | Fumier | Notification (F052) | N/A | F016 |
| Fosse lisier | litres | Lisier | Notification (F052) | N/A | F017 |
| Cuve HVC | litres | Carburant | Perte si commande > capacité (SimAgri) | N/A | ❌ Aucun flow |
| Cuve lait | litres | Lait | Traite bloquée si plein (F023) | ❌ Non modélisé (48h SimAgri) | F023 |
| Citerne eau | litres | Eau | Remplissage bloqué si plein | N/A | F007 |
| Bac eau (pré) | litres | Eau | Remplissage bloqué si plein | N/A | F051 |

### 3.2 Lacunes stockage

1. **Entrepôt** : aucun flow ne vérifie la capacité de l'entrepôt lors de l'achat de semences/engrais/traitements. F006 vérifie le silo mais pas l'entrepôt.
2. **Cuve HVC** : aucun flow d'achat HVC dans le registry. Le carburant est consommé dans de nombreux flows mais jamais acheté explicitement.
3. **Péremption lait** : SimAgri impose une DLC. Cultivia devrait au minimum avoir un tick de péremption lait (qualité dégradée après 48h → prix de vente réduit).
4. **Silo taupe** : SimAgri a des pertes sur le maïs ensilé stocké sous bâche. Non modélisé — acceptable en Phase 1.

**Correction :** Créer **F068 — Acheter HVC** (sprint 4, dépend de F001).

---

## 4. FLOWS MANQUANTS — Récapitulatif

| ID proposé | Nom | Sprint | Priorité | Justification |
|------------|-----|--------|----------|---------------|
| **F061** | Acheter pièce détachée | 12 | 🔴 Critique | Sans pièce, pas de réparation |
| **F062** | Souscrire assurance matériel | 12 | 🟡 Important | Spec existe (PHASE_COMP F10), pas de flow |
| **F063** | Tick expiration assurance | 12 | 🟡 Important | Complète F062 |
| **F064** | Vendre matériel entre joueurs | 15 | 🟢 Normal | Marché secondaire (Phase 3+) |
| **F065** | Clôturer épargne | 9 | 🟡 Important | Complète F032 |
| **F066** | Tick intérêts épargne | 9 | 🟡 Important | Complète F032 |
| **F067** | Tick mensuel économique | 9 | 🔴 Critique | Salaires, prêts, énergie, taxes |
| **F068** | Acheter HVC (carburant) | 4 | 🔴 Critique | Prérequis de tout transport |

---

## 5. CORRECTIONS REGISTRY — Détail

### 5.1 F043 — Acheter matériel neuf

**Correction :** Le SQL doit débiter `prix + delivery_cost`, pas seulement `prix`.

### 5.2 F044 — Entretenir matériel

**Correction :** Expliciter les deux branches mensuel/annuel dans le SQL.

### 5.3 F027 — Embaucher employé

**Corrections :**
- Coût : `500 €` → `1 600 €`
- Label : `Embaucher 500 €` → `Embaucher 1 600 €`
- Tooltip solde : `balance < 500` → `balance < 1600`
- Test : `GIVEN 0 employees WHEN hire THEN ht_max=44` → OK (40 + 4)

### 5.4 F032 — Souscrire épargne

**Correction :** Ajouter `minimum >= 1000` dans les checks (déjà dans states).

### 5.5 F033 — Demander un prêt

**Correction :** Aligner description sur 150 000€ (déjà correct dans le flow, mais PHASE1 F12 description dit 120k).

### 5.6 F045 — Réparer matériel

**Correction :** Ajouter prérequis `stock:piece_detachee` → dépend de F061 (achat pièce).

---

## 6. COMPARAISON SIMAGRI vs CULTIVIA

### 6.1 Features SimAgri présentes dans Cultivia

| Feature SimAgri | Cultivia | Commentaire |
|----------------|----------|-------------|
| Achat neuf | ✅ F043 | Via Marché Central (PNJ) |
| Usure quotidienne (abrité/non) | ✅ Tick | Formule simplifiée |
| Entretien mensuel/annuel | ✅ F044 | 2 niveaux |
| Pannes aléatoires | ✅ Tick | Seuil 70% (SimAgri : variable) |
| Réparation | ✅ F045 | Simplifié (1 pièce vs 1-5 dans SimAgri) |
| Argus | ✅ F047 | `prix_neuf × (1-usure) × 0.85` |
| Revente Coop | ✅ F047 | 60% de l'argus |
| Prêts bancaires | ✅ F033 | Plafond 150k€, taux progressif |
| Épargne | ✅ F032 | 3 formules, plafond 100k€ |
| Employé agricole | ✅ F027/F028 | Simplifié (pas d'achat de PA entre joueurs) |
| ETA | ✅ F046 (PNJ) + PHASE3 §14 (joueur) | PNJ dès Phase 1 |
| Taxe foncière | ✅ PHASE1 F14ter | Barème progressif |
| MSA | ✅ PHASE1 F14ter | 5% du CA |
| Énergie bâtiments | ✅ PHASE1 F3 | 0.08€/kWh, facteur saison |
| HVC (carburant) | ✅ Consommation modélisée | Mais achat non flowé |

### 6.2 Features SimAgri absentes de Cultivia

| Feature SimAgri | Priorité | Recommandation |
|----------------|----------|----------------|
| **Pièces détachées multiples** (1-5 par matériel, usure PA) | 🟡 | Simplifier à 1 pièce générique — OK |
| **Assurance matériel** | 🟡 | Spec existe, créer flows F062/F063 |
| **Concessionnaire joueur** (hall, licences, atelier) | 🟢 | PHASE4 Feature 3 — planifié |
| **Dépôt-vente** | 🟢 | PHASE4 Feature 3 — planifié |
| **Location matériel** (tracteur en panne) | 🟢 | Reporter Phase 4+ |
| **Achat en commun** (5 joueurs, matériel partagé) | 🟢 | Reporter Phase 5+ |
| **GPS matériel** (balises, récepteurs, bonus PA) | 🟢 | Reporter Phase 5+ |
| **Maniabilité matériel** (bonus/malus PA selon taille parcelle) | 🟡 | Spécifié dans GAME_SYSTEMS §2.3 — OK |
| **Combiné** (2-3 outils en 1 passage) | 🟢 | Reporter Phase 4+ |
| **Relevage avant** | 🟢 | Reporter Phase 5+ |
| **Achat PA entre joueurs** | 🟢 | Reporter Phase 3+ |
| **Service de garde** (ferme gardée par un ami) | 🟢 | Reporter Phase 5+ |
| **Compostage** | 🟢 | Tick prévu dans GAME_SYSTEMS §1.4 step 13 |
| **Retenue collinaire** | 🟢 | Non planifié — alternative à l'irrigation |

---

## 7. RECOMMANDATIONS PRIORITAIRES

### Sprint 4 (immédiat)
1. **Créer F068 — Acheter HVC** : bloquant pour tout transport

### Sprint 9
2. **Créer F065 — Clôturer épargne** : complète F032
3. **Créer F066 — Tick intérêts épargne** : complète F032
4. **Créer F067 — Tick mensuel économique** : salaires + prêts + énergie + taxes

### Sprint 12
5. **Créer F061 — Acheter pièce détachée** : bloquant pour réparation
6. **Créer F062 — Souscrire assurance matériel** : spec existe
7. **Créer F063 — Tick expiration assurance** : complète F062
8. **Corriger F043** : débiter `prix + delivery_cost`
9. **Corriger F044** : expliciter mensuel vs annuel
10. **Corriger F027** : aligner salaire sur 1 600€

### Sprint 15+
11. **Créer F064 — Vendre matériel entre joueurs** : marché secondaire

---

*Audit réalisé le 2026-04-06 par l'expert Économie & Matériel.*
*Prochaine étape : appliquer les corrections dans le registry YAML et les docs.*
