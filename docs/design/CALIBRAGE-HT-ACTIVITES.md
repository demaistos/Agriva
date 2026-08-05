# Calibrage HT — Coûts par activité

> Date : 2026-08-05
> Statut : Draft
> Auteur : agent:game-designer
> Référence : `docs/decisions/ADR-004-temps-de-travail-calcule.md`, `docs/design/GDD-materiel.md` §2

---

## 1. Budget de base

| Rôle | Heures/jour | Heures/tick (7 jours) | Coût |
|------|:-----------:|:---------------------:|------|
| **Exploitant** | 12 h | **84 h** | — |
| **Salarié** | 8 h | **56 h** | 2 200 €/mois IG |

- Les heures sont **rechargées à chaque tick** (1×/jour réel, 00:00 heure française).
- Pas de report des heures non utilisées.
- Le budget est **fixe toute l'année** — c'est la demande qui varie avec les saisons.

---

## 2. Coûts HT — Grandes cultures

Formule de base (cf. ADR-004) :

```
durée (h) = surface (ha) / débit (ha/h)
débit = largeur (m) × vitesse (km/h) × 0,1 × rendement_machine
```

### Coûts de référence (matériel moyen, mode Normal)

| Opération | Matériel de réf. | Largeur | Vitesse | Rdt | Débit | **Coût/ha** |
|-----------|-----------------|:-------:|:-------:|:---:|:-----:|:-----------:|
| Labour | Charrue 5 corps | 1,75 m | 7 km/h | 0,80 | 0,98 ha/h | **~1,02 h/ha** |
| Déchaumage | Déchaumeur 4,5 m | 4,5 m | 10 km/h | 0,85 | 3,83 ha/h | ~0,26 h/ha |
| Herse rotative | Herse 4 m | 4,0 m | 8 km/h | 0,82 | 2,62 ha/h | ~0,38 h/ha |
| **Semis céréales** | Semoir 4 m | 4,0 m | 10 km/h | 0,80 | 3,20 ha/h | **~0,31 h/ha** |
| Semis combiné (H+S) | Combiné 4 m | 4,0 m | 8 km/h | 0,75 | 2,40 ha/h | ~0,42 h/ha |
| Épandage engrais | Épandeur 24 m | 24,0 m | 14 km/h | 0,85 | 28,56 ha/h | ~0,04 h/ha |
| **Pulvérisation** | Pulvé 24 m | 24,0 m | 12 km/h | 0,85 | 24,48 ha/h | **~0,04 h/ha** |
| **Récolte céréales** | Moiss. coupe 6 m | 6,0 m | 5,5 km/h | 0,75 | 2,48 ha/h | **~0,40 h/ha** |
| Récolte maïs | Moiss. 6 rangs (4,5 m) | 4,5 m | 5,5 km/h | 0,70 | 1,73 ha/h | ~0,58 h/ha |
| Fauche | Faucheuse 3,2 m | 3,2 m | 12 km/h | 0,85 | 3,26 ha/h | ~0,31 h/ha |
| Fanage | Faneuse 6,5 m | 6,5 m | 12 km/h | 0,88 | 6,86 ha/h | ~0,15 h/ha |
| Andainage | Andaineur 6,5 m | 6,5 m | 11 km/h | 0,85 | 6,08 ha/h | ~0,16 h/ha |
| Pressage | Presse BR | — | 9 km/h | 0,70 | ~3 ha/h (variable) | ~0,33 h/ha |

### Arrondi simplifié pour le calibrage rapide

| Opération | **Coût arrondi** | Note |
|-----------|:----------------:|------|
| Labour | **1 h/ha** | Charrue 5 corps |
| Semis | **0,6 h/ha** | Combiné herse+semoir 4 m (plus réaliste pour céréalier moyen) |
| Récolte | **0,5 h/ha** | Moissonneuse coupe 6 m |
| Traitement (pulvé) | **0,3 h/ha** | Inclut remplissage + manœuvres en bout de champ |
| Épandage | **0,1 h/ha** | Très rapide avec 24 m |

---

## 3. Coûts HT — Élevage bovin

Formule (cf. ADR-004) : `durée = f(effectif, équipement, degré d'automatisation)`

### 3.1 Traite

```
durée_traite = (nb_vaches / cadence_salle) + temps_préparation

Salle 2×4 : cadence = 16 VL/h → 40 VL = 2,5 h + 0,5 h prépa = 3,0 h
Salle 2×6 : cadence = 20 VL/h → 40 VL = 2,0 h + 0,5 h prépa = 2,5 h
Salle 2×8 : cadence = 26 VL/h → 40 VL = 1,5 h + 0,5 h prépa = 2,0 h
Roto 20 postes : cadence = 50 VL/h → 80 VL = 1,6 h + 0,3 h = 1,9 h

Robot de traite : 0 h (automatique, requiert AgriPass)
```

**Par tick (7 jours, 2 traites/jour en mode simplifié) :**

| Salle | 40 VL/tick | 60 VL/tick | 80 VL/tick |
|-------|:----------:|:----------:|:----------:|
| 2×6 | **17,5 h** | 24,5 h | 31,5 h |
| 2×8 | 14 h | 19,3 h | 24,5 h |
| Robot | 0 h | 0 h | 0 h |

> Note : le coût de traite par tick = durée_traite × 7 jours.

### 3.2 Alimentation

```
durée_alimentation = 0,5 h (préparation mélangeuse) + 0,02 h × nb_animaux

40 VL : 0,5 + 0,8 = 1,3 h/jour → 9,1 h/tick
80 VL : 0,5 + 1,6 = 2,1 h/jour → 14,7 h/tick
```

### 3.3 Soins & surveillance

```
durée_soins = 0,1 h × nb_animaux / semaine (= par tick)

40 VL : 4 h/tick
80 VL : 8 h/tick
```

### 3.4 Récapitulatif bovin (40 VL, salle 2×6)

| Activité | Coût/tick |
|----------|:---------:|
| Traite (2×6, 40 VL) | 17,5 h |
| Alimentation | 9,1 h |
| Soins | 4,0 h |
| **Sous-total élevage** | **30,6 h/tick** |
| Cultures fourragères (~30 ha en saison) | ~20 h |
| **TOTAL en pointe** | **~50 h/tick** |

---

## 4. Coûts HT — Volaille

**Design intent** : la volaille est intentionnellement HIGH HT. C'est le balancier du ROI élevé — le joueur paie en temps ce qu'il gagne en marge.

### 4.1 Coûts unitaires

| Activité | Formule | Exemple 500 poules |
|----------|---------|:------------------:|
| Ramassage œufs | 0,5 h + 0,01 h/poule | 5,5 h/jour |
| Alimentation | 0,3 h + 0,005 h/poule | 2,8 h/jour |
| Nettoyage | 1 h / 100 poules / semaine | 5,0 h/tick |
| Santé & surveillance | 0,2 h/lot/jour (1 lot = bâtiment) | 1,4 h/jour |

### 4.2 Budget par tick (500 poules, 1 bâtiment)

| Activité | Coût/jour | **Coût/tick (×7)** |
|----------|:---------:|:------------------:|
| Ramassage œufs | 5,5 h | 38,5 h |
| Alimentation | 2,8 h | 19,6 h |
| Nettoyage | — | 5,0 h |
| Santé | 1,4 h | 9,8 h |
| **TOTAL 500 poules** | **~10 h/jour** | **~73 h/tick** |

### 4.3 Scaling — le mur HT

| Effectif | HT/tick | Budget solo (84h) | Verdict |
|:--------:|:-------:|:-----------------:|---------|
| 200 poules | ~29 h | ✅ Gérable + autre activité | |
| 500 poules | ~73 h | ⚠️ Quasi-totalité du budget | Aucune marge |
| 1 000 poules | ~145 h | ❌ **Dépasse le solo** | DOIT embaucher ≥1 salarié |
| 2 000 poules | ~290 h | ❌❌ | Besoin 4 salariés minimum |

> **Insight clé** : 500 poules consomment ~87 % du budget solo. C'est le cap naturel au-delà duquel l'embauche est OBLIGATOIRE. C'est ce mécanisme qui empêche la poule d'être un « money printer » infini — le ROI/poule est élevé mais le coût total en salaires érode massivement la marge à grande échelle.

---

## 5. Coûts HT — Maraîchage

Le maraîchage est intensif en main d'œuvre (travail manuel, peu mécanisable).

| Activité | Coût/1000 m² | Note |
|----------|:------------:|------|
| Plantation | 3–5 h | Variable selon culture (salade vs tomate) |
| Désherbage | 2 h/semaine | Manuel ou binage mécanique |
| Récolte | 4–8 h | Très variable (fraise = 8h, courgette = 4h) |
| Irrigation | 0,5 h | Mise en route/arrêt |
| Tuteurage/palissage | 2–3 h | Tomates, concombres |

**Budget type — 3000 m² maraîchage diversifié :**

| Phase | Coût/tick |
|-------|:---------:|
| Semaine de plantation | ~15 h |
| Semaine d'entretien | ~12 h |
| Semaine de récolte | ~20 h |

---

## 6. Coûts HT — Transport

```
durée_transport = (distance_km / 40) × 2 × ⌈tonnage / capacité_remorque⌉

  distance_km : distance ferme ↔ destination (coop, silo, marché)
  40 : vitesse moyenne tracteur+remorque (km/h)
  × 2 : aller-retour
  ⌈tonnage / capacité⌉ : nombre de trajets nécessaires
```

**Exemples :**

| Scénario | Calcul | Durée |
|----------|--------|:-----:|
| 20T à 10 km, benne 12T | (10/40) × 2 × ⌈20/12⌉ = 0,5 × 2 × 2 | **2,0 h** |
| 80T à 15 km, benne 18T | (15/40) × 2 × ⌈80/18⌉ = 0,75 × 2 × 5 | **7,5 h** |
| 200T à 25 km, benne 24T | (25/40) × 2 × ⌈200/24⌉ = 1,25 × 2 × 9 | **22,5 h** |

> Le transport est un coût « caché » significatif en moisson — il faut le budgéter.

---

## 7. Coûts HT — Administratif

```
Forfait par action : 5 à 15 minutes (seul cas de forfait admis, cf. ADR-004)

  Vendre à la coop / marché        : 5 min
  Acheter matériel / consommable    : 10 min
  Embaucher / licencier             : 15 min
  Consulter stats / bilan           : 5 min
  Passer une annonce marché joueurs : 10 min
```

Impact négligeable sur le budget total — ne dépasse jamais 2-3 h/tick sauf commerçant très actif.

---

## 8. Exemples travaillés — Convergence des profils

### Exemple 1 : Céréalier 100 ha en pointe (moisson)

```
CONTEXTE : 100 ha de blé mûr, moissonneuse coupe 6 m, benne 18T, silo à 12 km

Récolte     : 100 ha × 0,40 h/ha               = 40,0 h
Transport   : (12/40) × 2 × ⌈800T/18T⌉         
            = 0,6 × 2 × 45 = 54 h (!!!)         ← transport massif
              ... en pratique 2 bennes tournent :
              temps réel bloquant = max(récolte, transport/2)
              simplification : 40h récolte + 15h logistique joueur = 55 h

Admin       : ventes coop/marché                 = 2 h

TOTAL TICK MOISSON : ~57 h
Budget solo : 84 h → il reste 27 h pour autres travaux
```

**Verdict** : le céréalier 100 ha passe en solo MAIS il n'a aucune marge pour d'autres activités en moisson. Au-delà de 120 ha, l'embauche ou l'ETA devient nécessaire.

### Exemple 2 : Éleveur 40 VL (salle 2×6)

```
CONTEXTE : 40 VL Holstein, salle 2×6, 30 ha de cultures fourragères

Traite (7 jours × ~2,5 h/jour)     = 17,5 h
Alimentation (7 jours × 1,3 h)     =  9,1 h
Soins & surveillance                =  4,0 h
Cultures fourragères (en saison) :
  - Fauche 30 ha × 0,31 h          =  9,3 h
  - Fanage+andainage 30 ha × 0,31  =  9,3 h
  - Pressage                        =  3,0 h
Transport fourrages                 =  4,0 h

TOTAL TICK (en saison fourragère) : ~56 h
Budget solo : 84 h → marge de 28 h

MAIS : hors fourrages, le poste traite+alim+soins = 30,6 h/tick
       → largement gérable, mais rigide (incompressible)
```

**Verdict** : l'éleveur 40 VL est en **tension** en saison fourragère. À 60 VL, l'embauche d'un salarié (56 h/tick supplémentaires) devient incontournable.

### Exemple 3 : Aviculteur 500 poules → 1000 poules

```
CONTEXTE : aviculteur qui scale de 500 à 1000 poules

=== 500 POULES ===
Soins quotidiens (tout confondu)     = 73 h/tick
Logistique œufs (conditionnement, 
  transport, vente)                  = 8 h/tick

TOTAL : ~81 h/tick
Budget solo : 84 h → MARGE = 3 h (!!!)
→ Le joueur est au maximum absolu, il ne peut RIEN faire d'autre.

=== 1000 POULES ===
Soins quotidiens                     = 145 h/tick
Logistique                           = 15 h/tick

TOTAL : ~160 h/tick
Budget solo : 84 h → DÉFICIT = -76 h
Avec 1 salarié : 84 + 56 = 140 h → DÉFICIT = -20 h
Avec 2 salariés : 84 + 112 = 196 h → OK (marge 36 h)

Coût salariés : 2 × 2 200 = 4 400 €/mois
Sur le CA de 1000 poules (~8 000-12 000 €/mois brut) → 35-55% en masse salariale
```

**Verdict** : le passage à 1000 poules IMPOSE 2 salariés, qui absorbent ~40 % du CA. Le ROI/poule reste positif mais la marge nette converge vers les autres profils.

---

## 9. Convergence économique — Le plafond HT comme régulateur

| Profil | Seuil critique HT | CA annuel IG au seuil | Marge nette estimée |
|--------|:-----------------:|:---------------------:|:-------------------:|
| Céréalier | ~120 ha (solo) → 150+ ha (1 salarié) | 90 000–130 000 € | 40 000–60 000 € |
| Éleveur laitier | ~50 VL (solo) → 80 VL (1 salarié) | 100 000–140 000 € | 35 000–55 000 € |
| Aviculteur | ~500 poules (solo) → 1000 (2 salariés) | 80 000–120 000 € | 30 000–50 000 € |
| Polyvalent | Mix → 1 salarié nécessaire rapidement | 80 000–110 000 € | 35 000–50 000 € |

**Observation clé** : tous les profils convergent vers une **marge nette de 30 000–60 000 €/an IG** au moment où le joueur solo atteint son plafond HT. C'est le régulateur naturel :

- La poule a un ROI unitaire élevé MAIS un coût HT astronomique → margin squeezée par les salaires.
- Le céréalier a un ROI/ha modéré MAIS un coût HT faible → limité par la surface et le capital matériel.
- L'éleveur est entre les deux → limité par le combo traite + fourrages.

**Le HT est l'outil d'équilibrage n°1 du jeu.** Il garantit qu'aucun profil ne domine indéfiniment — chacun frappe un mur à un moment différent, pour un revenu comparable.

---

## 10. Notes de calibrage

### À ajuster en phase de test

- Les facteurs de la volaille (0,01 h/poule ramassage, 0,005 h/poule alimentation) sont les leviers principaux pour régler le « mur poule ».
- La cadence des salles de traite détermine à quel cheptel l'éleveur recrute.
- La vitesse de transport (40 km/h) est un simplificateur — en Expert, elle variera avec le chargement et la route.
- Le forfait administratif pourra être supprimé si le gameplay ne le justifie pas.

### Règles de cohérence

1. **Aucun coût HT ne peut être 0** pour une action physique (même le robot de traite conserve un coût de surveillance marginal dans le calcul interne — simplement affiché « 0 h » au joueur car sous le seuil d'affichage).
2. **Le coût HT doit toujours être inversement proportionnel à l'investissement matériel** — c'est la boucle fondamentale (cf. ADR-004 §4).
3. **Un joueur solo ne doit jamais pouvoir exploiter > 150 ha en céréales pures** sans aide — c'est le garde-fou anti-snowball.
