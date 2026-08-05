> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# Rapport final de conformité — Phase Game Design

> Date : 2026-08-04
> Auditeur : agent:reviewer
> Objet : autorisation de passage à la phase Architecture

---

## VERDICT

### ✅ CONFORME — le développement peut commencer

La phase Game Design est **complète, cohérente et prête pour l'Architecture**. Les 23 GDD couvrent 100% des systèmes identifiés, respectent les 4 ADR, et les valeurs partagées sont cohérentes. Les anomalies résiduelles sont mineures et ne bloquent pas le développement.

**Justification** :
- 23/23 fichiers pleinement conformes sur la structure (avec tolérance justifiée pour GDD-ui-ux qui est un document UX, pas un système économique)
- 0 violation des ADR
- 0 référence croisée cassée
- 0 divergence de valeur bloquante
- Couverture fonctionnelle 100% (119/119 systèmes statués)

---

## 1. Inventaire des livrables

| # | Document | Lignes | Type |
|:-:|----------|:------:|:----:|
| 1 | GDD-bovin-laitier.md | 1 813 | GDD |
| 2 | GDD-materiel.md | 1 600 | GDD |
| 3 | GDD-cultures.md | 1 438 | GDD |
| 4 | GDD-economie-base.md | 1 298 | GDD |
| 5 | GDD-elevage-autres-especes.md | 1 222 | GDD |
| 6 | GDD-core-temporalite.md | 1 140 | GDD |
| 7 | GDD-metiers-eta-concession.md | 1 138 | GDD |
| 8 | GDD-meteo.md | 1 094 | GDD |
| 9 | GDD-endgame.md | 1 058 | GDD |
| 10 | GDD-especes-secondaires.md | 1 078 | GDD |
| 11 | GDD-parcelles-sol.md | 1 037 | GDD |
| 12 | GDD-specialisations-vegetales.md | 991 | GDD |
| 13 | GDD-poulet-chair.md | 926 | GDD |
| 14 | GDD-ui-ux.md | 895 | GDD |
| 15 | GDD-maraichage.md | 883 | GDD |
| 16 | GDD-social-multijoueur.md | 864 | GDD |
| 17 | GDD-marche.md | 864 | GDD |
| 18 | GDD-onboarding.md | 804 | GDD |
| 19 | GDD-cooperatives-car.md | 799 | GDD |
| 20 | GDD-batiments-stockage.md | 750 | GDD |
| 21 | GDD-transformation.md | 759 | GDD |
| 22 | GDD-gouvernance-serveur.md | 744 | GDD |
| 23 | GDD-genetique.md | 664 | GDD |
| — | ADR-001-modes-de-jeu.md | — | ADR |
| — | ADR-002-recette-simagri-en-normal.md | — | ADR |
| — | ADR-003-expert-nest-pas-plus-rentable.md | — | ADR |
| — | ADR-004-temps-de-travail-calcule.md | — | ADR |
| — | COUVERTURE-FONCTIONNELLE.md | — | Audit |

**Total lignes de game design : 23 859 lignes** (23 GDD)

---

## 2. Conformité structurelle

### Critères vérifiés

| Critère | Description | Méthode de vérification |
|---------|-------------|------------------------|
| C1 | En-tête (date, statut, auteur, références) | Grep `> (Date|Statut|Auteur)` — 3 occurrences par fichier |
| C2 | Section Vision / §1 | Grep `Vision|§1|1.` dans les titres |
| C3 | Tableau comparatif Normal/Expert | Grep `Normal.*Expert|Mode Normal|Mode Expert` |
| C4 | Au moins 2 mockups ASCII | Grep `┌─` (count ≥ 2) |
| C5 | Au moins 1 scénario chiffré | Grep `Scénario|Équilibrage` dans titres |
| C6 | Section Annexe | Grep `# .*Annexe` |
| C7 | Checklist de validation | Grep `# .*(Checklist|Validation|Playtest)` |
| C8 | Historique des révisions | Grep `# .*Historique|# .*Révision` |

### Tableau de conformité (23 fichiers × 8 critères)

| GDD | C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 |
|-----|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| GDD-batiments-stockage | ✅ | ✅ | ✅ | ✅ (8) | ✅ (3) | ✅ | ✅ | ✅ |
| GDD-bovin-laitier | ✅ | ✅ | ✅ | ✅ (17) | ✅ (8) | ✅ | ✅ | ✅ |
| GDD-cooperatives-car | ✅ | ✅ | ✅ | ✅ (9) | ✅ (3) | ✅ | ✅ | ✅ |
| GDD-core-temporalite | ✅ | ✅ | ✅ | ✅ (7) | ✅ (5) | ✅ | ✅ | ✅ |
| GDD-cultures | ✅ | ✅ | ✅ | ✅ (14) | ✅ (6) | ✅ | ✅ | ✅ |
| GDD-economie-base | ✅ | ✅ | ✅ | ✅ (14) | ✅ (12) | ✅ | ✅ | ✅ |
| GDD-elevage-autres-especes | ✅ | ✅ | ✅ | ✅ (8) | ✅ (8) | ✅ | ✅ | ✅ |
| GDD-endgame | ✅ | ✅ | ✅ | ✅ (7) | ✅ (3) | ✅ | ✅ | ✅ |
| GDD-especes-secondaires | ✅ | ✅ | ✅ | ✅ (6) | ✅ (4) | ✅ | ✅ | ✅ |
| GDD-genetique | ✅ | ✅ | ✅ | ✅ (4) | ✅ (3) | ✅ | ✅ | ✅ |
| GDD-gouvernance-serveur | ✅ | ✅ | ✅ | ✅ (8) | ✅ (3) | ✅ | ✅ | ✅ |
| GDD-maraichage | ✅ | ✅ | ✅ | ✅ (9) | ✅ (4) | ✅ | ✅ | ✅ |
| GDD-marche | ✅ | ✅ | ✅ | ✅ (6) | ✅ (5) | ✅ | ✅ | ✅ |
| GDD-materiel | ✅ | ✅ | ✅ | ✅ (20) | ✅ (11) | ✅ | ✅ | ✅ |
| GDD-meteo | ✅ | ✅ | ✅ | ✅ (2) | ✅ (5) | ✅ | ✅ | ✅ |
| GDD-metiers-eta-concession | ✅ | ✅ | ✅ | ✅ (7) | ✅ (4) | ✅ | ✅ | ✅ |
| GDD-onboarding | ✅ | ✅ | ✅ | ✅ (16) | ✅ (2) | ✅ | ✅ | ✅ |
| GDD-parcelles-sol | ✅ | ✅ | ✅ | ✅ (3) | ✅ (5) | ✅ | ✅ | ✅ |
| GDD-poulet-chair | ✅ | ✅ | ✅ | ✅ (4) | ✅ (5) | ✅ | ✅ | ✅ |
| GDD-social-multijoueur | ✅ | ✅ | ✅ | ✅ (9) | ✅ (4) | ✅ | ✅ | ✅ |
| GDD-specialisations-vegetales | ✅ | ✅ | ✅ | ✅ (3) | ✅ (3) | ✅ | ✅ | ✅ |
| GDD-transformation | ✅ | ✅ | ✅ | ✅ (10) | ✅ (4) | ✅ | ✅ | ✅ |
| GDD-ui-ux | ✅ | ✅ | ✅ | ✅ (30) | ⚠️¹ | ✅ | ✅ | ✅ |

> ¹ GDD-ui-ux n'a pas de section « Scénario chiffré » au sens économique. Ce document est un Design System (tokens CSS, grilles, composants, animations). Il contient des spécifications quantitatives (ms, px, breakpoints) qui tiennent lieu de « scénario chiffré UX ». **Tolérance acceptée** — un document UX n'a pas vocation à contenir des simulations économiques.

**Taux de conformité structurelle : 23/23** (avec tolérance justifiée sur C5 pour GDD-ui-ux)

---

## 3. Conformité aux ADR

### ADR-001 — Deux modes de jeu (Normal et Expert)

| Vérification | Résultat |
|-------------|----------|
| Chaque GDD distingue-t-il Normal et Expert ? | ✅ **OUI** — 23/23 fichiers contiennent des mentions Normal/Expert (min 5 dans GDD-gouvernance-serveur, max 40 dans GDD-bovin-laitier) |
| Tableau comparatif présent ? | ✅ **OUI** — 23/23 fichiers ont un tableau ou section comparant les deux modes |

**Verdict ADR-001 : CONFORME ✅**

---

### ADR-002 — Pas de mécanique punitive en Normal

| Vérification | Résultat |
|-------------|----------|
| Faillite en Normal ? | ✅ **Explicitement impossible** dans 13 GDD (mentions « pas de faillite », « impossible », « plancher à 0€ ») |
| Perte totale en Normal ? | ✅ **Protégé** — Perte totale réservée au mode Expert (ex : GDD-maraichage L82 « perte totale après DLC = Expert uniquement ») |
| Récolte nulle en Normal ? | ✅ **Plancher 40%** — GDD-cultures L261 « jamais de récolte nulle en Normal » |
| Blocage > 3 jours en Normal ? | ✅ **Max 3 jours** — GDD-meteo L844 « Blocages météo max 3 jours consécutifs » (Normal) |
| Faillite CAR ? | ✅ **Protégé** — GDD-cooperatives-car L488 « parts remboursées à 80% minimum (protection ADR-002) » |

**Verdict ADR-002 : CONFORME ✅**

---

### ADR-003 — Expert n'est pas plus rentable

| Vérification | Résultat |
|-------------|----------|
| Un GDD prétend-il qu'Expert rapporte systématiquement plus ? | ✅ **NON** — 10 GDD mentionnent explicitement l'ADR-003. Les formulations sont correctes : « Expert n'est PAS plus rentable », « Expert = contrôle, pas +€ » |
| Les scénarios confirment-ils ? | ✅ **OUI** — GDD-bovin-laitier L1627 : « le produit brut Expert est supérieur mais les charges 28% réduisent le revenu net sous celui du Normal » |
| Les avantages Expert sont-ils bien positionnés ? | ✅ **OUI** — Grandes structures, temps libéré, long terme, gestion de crise |

**Verdict ADR-003 : CONFORME ✅**

---

### ADR-004 — Temps calculé, pas attribué

| Vérification | Résultat |
|-------------|----------|
| Mentions « HT » comme unité de temps ? | ✅ **2 fichiers, 3 mentions** — toutes dans un contexte descriptif de SimAgri (comparaison « Dans SimAgri… ») = autorisé |
| Durées forfaitaires pour travaux de parcelle ? | ✅ **AUCUNE** — GDD-core-temporalite L265 confirme « aucune durée n'est attribuée forfaitairement ». Les seuls forfaits (5-15 min) sont pour des actions administratives (L370). |
| Formule de calcul de durée référencée ? | ✅ **OUI** — `durée = surface / débit` documentée dans GDD-materiel §2, référencée par GDD-core-temporalite §4 |

**Verdict ADR-004 : CONFORME ✅**

---

## 4. Cohérence des valeurs partagées

### Valeurs de référence — Résultats de vérification

| Valeur | Référence | Vérification | Résultat |
|--------|-----------|-------------|----------|
| Charges sociales Normal | 12% du bénéfice | 20 fichiers, 160 mentions | ✅ Cohérent |
| Charges sociales Expert | 28% du revenu | 18 fichiers, 88 mentions | ✅ Cohérent |
| DPB Normal | 150 €/ha | GDD-economie-base L268, L395 | ✅ Cohérent |
| DPB Expert | 152 €/ha | GDD-economie-base L367, L395, L1067 ; GDD-elevage-autres-especes L270, L277 | ✅ Cohérent |
| Aide bovine allaitante | 150 €/tête | GDD-economie-base L271, L1271 ; GDD-elevage-autres-especes L269, L276, L980 | ✅ Cohérent |
| Aide bovine laitière | 35 €/tête (plafond 60) | GDD-economie-base L274, L1272 | ✅ Cohérent |
| Aide ovine | 22 €/brebis | GDD-economie-base L278, L293, L1273 | ✅ Cohérent |
| Aide caprine | 16 €/chèvre | GDD-economie-base L280, L1274 | ✅ Cohérent |
| Blé | 220 €/t | 13 fichiers | ✅ Cohérent |
| Orge | 195 €/t | GDD-marche L103, GDD-cultures L1377, GDD-onboarding L218, L373, L380 | ✅ Cohérent |
| Maïs grain | 200 €/t | GDD-marche L104, GDD-cultures L1379, GDD-specialisations-vegetales L701 | ✅ Cohérent |
| Colza | 470 €/t | GDD-marche L105, GDD-cultures L1378, GDD-meteo L882, GDD-specialisations-vegetales L702 | ✅ Cohérent |
| Lait vache | 0,43 €/L | GDD-bovin-laitier L561 (×5 mentions), GDD-marche L107, GDD-social-multijoueur L633, GDD-economie-base L618 | ✅ Cohérent |
| Lait chèvre | 0,85 €/L | GDD-elevage-autres-especes L810, L875, L920, L934, L1208 | ✅ Cohérent |
| Porc | 1,75 €/kg carc. | GDD-elevage-autres-especes L392, L402 ; GDD-marche L108 | ✅ Cohérent |
| Agneau | 7,50 €/kg carc. | GDD-elevage-autres-especes L601 ; GDD-marche L109 ; GDD-economie-base L1139 | ✅ Cohérent |
| Poulet | 1,00 €/kg vif | GDD-poulet-chair L583 ; GDD-marche L110 | ✅ Cohérent |
| Salarié heures | 7 h/jour | GDD-core-temporalite L298, L403, L410 ; GDD-maraichage L372 | ✅ Cohérent |
| Salarié coût | 2 200 €/mois ch. incluses | GDD-core-temporalite L298, L403, L463 ; GDD-metiers-eta-concession L315, L989 ; GDD-transformation L107 | ✅ Cohérent |
| Exploitant hiver | 6 h | GDD-core-temporalite L293, L1085 | ✅ Cohérent |
| Exploitant hors pointe | 8 h | GDD-core-temporalite L294, L1086 | ✅ Cohérent |
| Exploitant pointe modérée | 10 h | GDD-core-temporalite L295, L1087 | ✅ Cohérent |
| Exploitant grande pointe | 12 h | GDD-core-temporalite L296, L1088 ; GDD-maraichage L336 | ✅ Cohérent |
| Fermage | 90-250 €/ha | GDD-economie-base L587, L1153, L1276 ; GDD-parcelles-sol L841, L859, L877 | ✅ Cohérent |

### Divergences détectées

| Valeur | Fichier | Ligne | Attendu | Trouvé | Gravité | Analyse |
|--------|---------|:-----:|---------|--------|:-------:|---------|
| Salaire mécanicien | GDD-metiers-eta-concession | 363 | 2 200 €/mois | 2 100 €/mois | ℹ️ Basse | **Pas une divergence** — il s'agit d'un mécanicien junior (comp. 4/10) dans un mockup de concessionnaire. Les mécaniciens ont un salaire variable selon la compétence (2 100 à 3 200 €). Le salarié agricole standard reste à 2 200 €. |
| Colza dans scénarios | GDD-economie-base | 1016, 1065 | 470 €/t | 460 €/t, 465 €/t | ℹ️ Basse | **Pas une divergence** — ces scénarios simulent des prix dynamiques (marché fluctuant ±15%). Le prix de référence en L618 est bien 470 €/t. |

**Conclusion : aucune divergence de valeur bloquante.**

---

## 5. Références croisées

### Méthode
Extraction de toutes les références au pattern `GDD-[nom]` dans les 23 fichiers, puis vérification de l'existence du fichier cible.

### Références trouvées et vérifiées

| GDD référencé | Fichier existant ? |
|---------------|:------------------:|
| GDD-bovin-laitier | ✅ |
| GDD-cooperatives-car | ✅ |
| GDD-cultures | ✅ |
| GDD-economie-base | ✅ |
| GDD-endgame | ✅ |
| GDD-maraichage | ✅ |
| GDD-marche | ✅ |
| GDD-materiel | ✅ |
| GDD-poulet-chair | ✅ |
| GDD-transformation | ✅ |

**Références cassées : AUCUNE** ✅

---

## 6. Couverture fonctionnelle

### Source : `COUVERTURE-FONCTIONNELLE.md`

| Statut | Nombre | % |
|--------|:------:|:-:|
| ✅ Couvert (GDD avec paramètres chiffrés) | 112 | 94,1% |
| 🔧 Architecture (hors périmètre GDD) | 2 | 1,7% |
| 🗑️ Écarté volontairement (V2) | 5 | 4,2% |
| ❌ Absent | 0 | 0% |
| **TOTAL** | **119** | **100%** |

### Analyse

Les 119 sous-systèmes SimAgri sont **tous statués** :
- **112 conçus** dans les GDD avec mécaniques et paramètres chiffrés
- **2 renvoyés** à l'Architecture (Authentification, Short IDs) — justifié, ce sont des choix techniques sans mécanique de jeu
- **5 écartés** avec justification (Chien de troupeau → V2, Négociant → redondant, Location matériel → micro-fonctionnalité, Assurance matériel → implicite, Organisme Partcel → fusionné)

Les 2 systèmes initialement signalés « absents » (4.15 Quotas, 4.16 Engrais verts/CIPAN) ont été corrigés et sont désormais couverts dans la version définitive du document.

**Verdict couverture : COMPLÈTE ✅**

---

## 7. Anomalies résiduelles

| # | Anomalie | Gravité | Fichier | Action recommandée |
|:-:|----------|:-------:|---------|-------------------|
| 1 | GDD-ui-ux n'a pas de « scénario chiffré » au sens économique | ℹ️ INFO | GDD-ui-ux.md | Aucune — un Design System n'a pas de simulation économique. Le document contient des specs quantitatives (timing, tailles, breakpoints). |
| 2 | GDD-meteo n'a que 2 mockups ASCII (minimum requis) | ℹ️ INFO | GDD-meteo.md | Facultatif : ajouter un mockup « alerte » ou « carte sécheresse ». Non bloquant. |
| 3 | GDD-cooperatives-car a 799 lignes vs 622 dans COUVERTURE-FONCTIONNELLE | ℹ️ INFO | COUVERTURE-FONCTIONNELLE.md | Mettre à jour le compteur dans le document de couverture. Écart dû à des ajouts post-audit. |
| 4 | Colza à 460/465 dans des scénarios de GDD-economie-base | ℹ️ INFO | GDD-economie-base.md L1016, L1065 | Acceptable : ce sont des prix dynamiques simulés, pas des prix de référence. Ajouter un commentaire si besoin de clarté. |

### Synthèse par gravité

| Gravité | Nombre | Impact |
|---------|:------:|--------|
| 🔴 Bloquant (empêche de coder) | **0** | — |
| 🟠 Majeur (à corriger avant sprint 1) | **0** | — |
| 🟡 Mineur (à corriger pendant le dev) | **0** | — |
| ℹ️ Information (cosmétique) | **4** | Aucun impact |

---

## 8. Points d'attention pour la phase Architecture

### 8.1 Service central de calcul de temps (ADR-004)
Le `WorkDurationService` est le service le plus transversal du projet. Toute action passe par lui. Il doit :
- Recevoir le matériel utilisé, la surface/effectif, les conditions météo
- Retourner une durée en heures
- Être extensible (nouveaux types de travaux)
- Référence : GDD-core-temporalite §4, GDD-materiel §2

### 8.2 Dualité Normal/Expert (ADR-001)
Chaque système a deux comportements. L'architecture doit prévoir :
- Un flag `mode` par exploitation (pas par serveur)
- Des paramètres conditionnels (charges 12% vs 28%, météo bloquante ou non, etc.)
- Un seul univers économique (prix identiques, même marché)
- Le passage Normal → Expert est possible ; l'inverse nécessite une nouvelle ferme

### 8.3 Tick temporel et progression
- `time_ratio = 7` (1 jour réel = 7 jours jeu)
- Tick de simulation : mise à jour des jauges, croissance, consommation alimentaire
- Protection hors-ligne : gel des jauges après 48h d'absence
- Saisons impactant la capacité de travail (6-12h selon période)

### 8.4 Économie et prix dynamiques
- Prix de base fixés dans une table de référence (220, 195, 200, 470 €/t, etc.)
- Variation hebdomadaire par offre/demande (±15% Normal, ±25% Expert)
- Charges automatiques mensuelles (salaires, électricité, annuités)
- Les joueurs Normal et Expert partagent le même marché

### 8.5 Matériel et débit de chantier
- `débit = largeur × vitesse × 0,1 × rendement_machine × f_conditions`
- Le matériel est la source de vérité pour le calcul des durées
- L'usure (0,1%/jour) affecte les performances
- Les combinés réduisent le temps (−50% HT)

### 8.6 Élevage et génétique
- Les lots sont l'unité de gestion (pas les animaux individuels sauf reproducteurs)
- La génétique est cumulative (transmission ISU sur les générations)
- Production lait = f(génétique, alimentation, stade lactation, santé, confort)
- Robot de traite = fonctionnalité premium (AgriPass requis)

### 8.7 Données géographiques
- 13 régions, 96 départements, 5 zones climatiques
- La météo est par zone (pas par exploitation)
- La distance parcelle↔siège impacte le temps de transport

### 8.8 Multi-joueur et économie sociale
- CESA (stabilisateur de prix), CFSA (guildes 42 jours), coopératives CAR
- Marché joueur↔joueur avec commissions
- ETA/concessionnaire/transporteur = métiers joueurs prestataires
- Forum et messagerie intégrés (WebSocket)

### 8.9 Monétisation
- AgriPass (4,99€/mois) et AgriPass+ (9,99€/mois)
- Pas de Pay-to-Win : les fonctionnalités premium sont des conforts (robot de traite, stats avancées)
- Cosmétiques uniquement pour les packs additionnels

### 8.10 Modèle de données critique
Les entités suivantes sont au cœur de presque tous les GDD :
- **Exploitation** (mode, trésorerie, heures disponibles)
- **Parcelle** (surface, sol 6 éléments, culture active, historique rotation)
- **Lot animal** (espèce, effectif, poids moyen, génétique, jauges)
- **Matériel** (type, largeur, puissance, usure, état)
- **Bâtiment** (type, niveau, capacité, usure, accessoires)
- **Transaction** (type, montant, date, acheteur, vendeur)

---

## Signature

```
Rapport établi le 2026-08-04 à 16:05 UTC+2
Auditeur : agent:reviewer
Méthode : vérification automatisée par grep + lecture structurelle + cross-référencement
Périmètre : 23 GDD (23 859 lignes) + 4 ADR + COUVERTURE-FONCTIONNELLE.md

VERDICT FINAL : ✅ CONFORME
Le passage à la phase Architecture est AUTORISÉ.
```
