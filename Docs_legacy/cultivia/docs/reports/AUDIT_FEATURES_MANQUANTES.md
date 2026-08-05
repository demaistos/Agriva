# Audit features manquantes — SimAgri vs Cultivia

> Audit systématique des features quotidiennes SimAgri non couvertes.

---

## MVP (bloquant ou très attendu)

| # | Feature | Impact | Justification |
|---|---------|--------|---------------|
| M1 | **Voir inventaire complet** (1 page, tous les stocks) | 🔴 | Le joueur ne sait pas ce qu'il a. Foin, blé, HVC, paille, œufs, laine — tout dispersé. |
| M2 | **Sevrage** (séparer veau de la mère après 21j) | 🔴 | SimAgri le fait automatiquement. Sans ça, les veaux allaitants restent collés à la mère. |
| M3 | **Carnet de santé animal** (historique soins/vaccins) | 🟡 | Le joueur veut savoir quand il a vacciné pour la dernière fois. |
| M4 | **Faire le plein HVC** (jauge globale, pas par véhicule) | 🟡 | SimAgri a 1 réservoir global. On a déjà la cuve HVC mais pas de "faire le plein" explicite — c'est F068 (acheter HVC). OK tel quel. |

## Post-MVP (enrichissement)

| # | Feature | Sprint | Justification |
|---|---------|--------|---------------|
| P1 | Atteler/dételer outil au tracteur | 14 | Combinés = optimisation HT (2 outils en 1 passage) |
| P2 | Relevage avant | 14 | Outil avant + arrière = combiné avancé |
| P3 | Peser un animal | 14 | Utile pour estimer le prix abattoir |
| P4 | Castrer un mâle | 14 | Empêche la reproduction non voulue |
| P5 | Réformer un animal | 14 | Retirer de la reproduction sans vendre |
| P6 | Drainage parcelle | 14 | Améliore le sol en zone humide |
| P7 | Chaulage (amendement calcique) | 14 | Corrige le pH du sol |
| P8 | Clôturer un pré | 14 | Prérequis pour mettre au pré (actuellement implicite) |
| P9 | Plan de ferme (carte parcelles) | 15 | Vue visuelle de l'exploitation |

## Déjà couvert (pas de manque)

| Feature | Comment c'est géré |
|---------|-------------------|
| Faire le plein HVC | F068 (acheter HVC) — 1 cuve globale, pas par véhicule |
| Gestion stock | Implicite dans chaque flow (silo, cuve, inventaire) |
| GPS/guidage | Post-MVP, accessoire matériel |
| Formation/compétence | Table `skill_progress` existe, post-MVP Sprint 16 |
| Labels bio/plein-air | Post-MVP Sprint 14 |
