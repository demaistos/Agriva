# SDD — Dashboard Élevage (page "Mes animaux")

> Référence : SimAgri `liste_animaux.php`
> Objectif : reproduire TOUS les paramètres de contrôle de SimAgri, adaptés à notre design horizontal (pas de sidebar).

## 1. Analyse SimAgri — Inventaire complet des contrôles

### 1.1 Sidebar espèces (SimAgri)
SimAgri utilise une sidebar gauche fixe avec :
- Liste de TOUTES les espèces (même celles à 0)
- Pour chaque espèce :
  - Icône type élevage (conventionnel/bio)
  - Nom espèce (lien vers liste filtrée)
  - Compteur total
  - Sous-liste par race avec compteur
  - Bouton nourrir par race (icône change si nourri/pas nourri)
  - Liens spéciaux (oeufs pour poules, labo foie gras)
  - Icône robot d'alimentation si actif

**Notre adaptation** : Pas de sidebar. Section "Mon cheptel" en cards horizontales, uniquement les espèces possédées.

### 1.2 Panneau "Nourrir mes animaux dans un bâtiment"
Raccourcis de nourrissage groupé par :
- Espèce
- Tranche d'âge (ex: "Volaille adulte : 11 animaux de 6 mois et adulte")
- Lien popup pour nourrir directement

### 1.3 Alertes accordéon — 13 panneaux
Chaque panneau = titre + badge compteur + détail par race + actions

| # | Alerte | Sévérité | Action | Détail |
|---|--------|----------|--------|--------|
| 1 | N'ayant pas mangé aujourd'hui | 🔴 CRITIQUE | Nourrir | Par race + compteur |
| 2 | N'ayant pas bu aujourd'hui | 🔴 CRITIQUE | Abreuver | Par race + compteur |
| 3 | Malades pas encore soignés | 🔴 CRITIQUE | Soigner tous | Par race + compteur |
| 4 | Morts | 🔴 DANGER | Retirer les morts | Par race + compteur |
| 5 | Vendus à l'abattoir aujourd'hui | 🟢 INFO | — | Par race + compteur |
| 6 | Allant donner des petits | 🟢 INFO | — | Par race + compteur |
| 7 | Morts nés | 🟠 WARN | Supprimer | Par race + compteur |
| 8 | Allant grandir (changement stade) | 🟢 INFO | — | Par race + compteur |
| 9 | Dans l'enclos d'arrivage | 🟠 WARN | Loger auto | Par race + compteur + bouton loger auto |
| 10 | À mettre dans un parc | 🟠 WARN | — | Par race + compteur |
| 11 | Dans une bétaillère/utilitaire | 🔵 INFO | — | Par race + compteur |
| 12 | Égarés | 🟠 WARN | — | Par race + compteur |
| 13 | À préparer (salon/concours) | 🔵 INFO | — | Par race + compteur |

### 1.4 Panneaux utilitaires
- **Estimation eau** : bacs à eau (nécessaire/dispo) + cuves à eau (nécessaire animaux + maraîchage / dispo) + bouton "Remplir"
- **Périodes hivernales** : quelles espèces peuvent être au pré selon la saison
- **Ratios et fusions** : popup stats génétiques

### 1.5 Table informations
- Modifier type élevage (conventionnel/bio) par espèce
- Fichiers d'aide
- Infos saisonnières (insémination, salon)

---

## 2. Brainstorm joueur — Priorisation

### 2.1 Ce qui me stresse (CRITIQUE — rouge)
En tant que joueur, quand j'ouvre cette page, je veux voir EN PREMIER :
1. **Qui n'a pas mangé ?** → perte de santé immédiate
2. **Qui n'a pas bu ?** → perte de santé immédiate
3. **Qui est malade ?** → risque de mort si pas soigné
4. **Qui est mort ?** → cadavres à retirer
5. **Qui est dans l'enclos ?** → pas protégé, pas nourri auto

### 2.2 Ce qui me fait gagner (OPPORTUNITÉ — vert)
6. **Naissances à venir** → nouveaux animaux = valeur
7. **Changements de stade** → animaux qui grandissent = plus de valeur
8. **Prêts pour l'abattoir** → vente possible

### 2.3 Ce que je dois gérer (LOGISTIQUE — orange)
9. **En transit (bétaillère)** → en cours de déplacement
10. **À mettre au parc** → besoin d'espace extérieur
11. **Égarés** → problème à résoudre
12. **À préparer** → salon/concours

### 2.4 Ressources à surveiller (DASHBOARD — bleu)
13. **Eau** : nécessaire vs disponible, bouton remplir
14. **Nourriture** : raccourcis nourrir par lot/âge
15. **Type élevage** : conventionnel vs bio (impact prix)

---

## 3. Architecture du dashboard — Notre version

### 3.1 Structure de la page `/animals`

```
┌─────────────────────────────────────────────┐
│ PageToolbar: "Élevage"                      │
│ Sub-nav: Mes animaux | Liste | Productions  │
├─────────────────────────────────────────────┤
│ PANNEAU 1: 🍽️ Nourrir mes animaux          │
│ Raccourcis par espèce → race → tranche âge  │
│ Lien direct nourrir                         │
├─────────────────────────────────────────────┤
│ PANNEAU 2: ⚠️ Alertes élevage (accordéon)  │
│ 13 lignes cliquables avec badge compteur    │
│ Détail par race quand ouvert                │
│ Actions directes (Nourrir, Soigner, Loger)  │
├─────────────────────────────────────────────┤
│ PANNEAU 3: 📊 Mon cheptel                  │
│ Cards par espèce possédée                   │
│ Barres faim/soif/santé                      │
│ Stats ♀/♂, gestantes, races                 │
│ Lien vers liste filtrée                     │
├─────────────────────────────────────────────┤
│ PANNEAU 4: 💧 Ressources                   │
│ Estimation eau (nécessaire/dispo)           │
│ Bouton remplir cuves                        │
│ Info saison (pré/hivernage)                 │
├─────────────────────────────────────────────┤
│ PANNEAU 5: ℹ️ Informations                 │
│ Type élevage par espèce                     │
│ Infos saisonnières                          │
└─────────────────────────────────────────────┘
```

### 3.2 Données nécessaires (API)

Le dashboard a besoin de :
- `store.animals` — tous les lots d'animaux du joueur
- `store.buildings` — bâtiments (pour savoir qui est logé)
- `store.equipment` — matériel (bétaillères)
- `store.player` — infos joueur (difficulté, saison)
- Données calculées côté client :
  - Groupement par espèce/race
  - Moyennes faim/soif/santé pondérées par quantité
  - Filtrage par condition (pas mangé, malade, etc.)

### 3.3 Les 13 alertes — Mapping vers nos données

| Alerte SimAgri | Notre champ | Condition |
|---|---|---|
| Pas mangé aujourd'hui | `hunger` | `hunger < 30` (seuil critique) |
| Pas bu aujourd'hui | `thirst` | `thirst < 30` |
| Malades pas soignés | `health` | `health < 30` |
| Morts | `health` | `health <= 0` |
| Vendus abattoir | — | `sold_today` flag (à implémenter) |
| Donner des petits | `is_pregnant` + `expected_birth` | `is_pregnant && expected_birth <= today` |
| Morts nés | — | `stillborn` flag (à implémenter) |
| Allant grandir | `stage` + `age_days` | Prochain changement de stade imminent |
| Dans l'enclos | `building_id` | `building_id IS NULL` |
| À mettre au parc | — | Saison + espèce compatible pré |
| Dans bétaillère | `location_type` | `location_type = 'vehicle'` |
| Égarés | — | `location_type = 'lost'` (à implémenter) |
| À préparer | — | Salon actif + animal inscrit |

### 3.4 Actions disponibles

| Action | Route API | Paramètres |
|---|---|---|
| Nourrir | `POST /animals/:id/feed` | `food_type, quantity` |
| Abreuver | `POST /animals/:id/water` | `quantity` |
| Soigner | `POST /animals/:id/heal` | — |
| Soigner tous | `POST /animals/heal-all` | — |
| Retirer morts | `POST /animals/remove-dead` | — |
| Loger auto | `POST /animals/:id/auto-house` | — |
| Remplir cuves | `POST /buildings/fill-water` | `building_id` |
| Changer type élevage | `PUT /animals/farming-mode` | `species, mode` |

---

## 4. Implémentation — État actuel vs cible

### 4.1 Ce qui est fait ✅
- Panneau "Nourrir mes animaux" (raccourcis par espèce/race)
- Alertes accordéon (1 alerte : enclos)
- Cheptel par espèce avec barres faim/soif/santé
- Navigation dashboard ↔ liste détaillée

### 4.2 Ce qui manque ❌
- [ ] Compléter les 13 alertes (actuellement 1 seule)
- [ ] Actions directes dans les alertes (nourrir, soigner, loger)
- [ ] Panneau ressources (estimation eau)
- [ ] Panneau informations (type élevage, saison)
- [ ] Données manquantes en BDD : `sold_today`, `stillborn`, `location_type='vehicle'|'lost'`
- [ ] Routes API manquantes : feed, water, heal, heal-all, remove-dead, auto-house, fill-water
- [ ] Raccourcis nourrir par tranche d'âge (pas juste par race)
- [ ] Indicateur nourri/pas nourri par race (icône qui change)
- [ ] Type élevage conventionnel/bio par espèce
- [ ] Gestion saisons (pré/hivernage)
- [ ] Salon/concours (préparation animaux)

### 4.3 Priorité d'implémentation

**Phase 1 — Alertes complètes (critique)**
1. Compléter les 13 alertes dans le dashboard
2. Ajouter les champs manquants en BDD
3. Implémenter les routes API d'action

**Phase 2 — Ressources et logistique**
4. Panneau estimation eau
5. Raccourcis nourrir par tranche d'âge
6. Indicateur nourri/pas nourri

**Phase 3 — Élevage avancé**
7. Type élevage conventionnel/bio
8. Gestion saisons
9. Salon/concours

---

## 5. Notes de design

- Pas de sidebar espèces (contrairement à SimAgri) → cards horizontales
- Alertes en accordéon vertical (pas en grille 3 colonnes comme SimAgri)
- Actions directes dans les alertes (pas de popup séparée)
- Barres de progression pour faim/soif/santé (pas dans SimAgri, c'est notre ajout)
- Seules les espèces possédées sont affichées (SimAgri montre tout)
