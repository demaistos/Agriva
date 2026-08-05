# 3. LES 11 ACTIVITÉS
## Version 2.0 — Mis à jour le 2026-04-08

| # | Activité | Condition | Description |
|---|----------|-----------|-------------|
| 1 | **Ferme** | Gratuit (base) | Élevage + cultures + bâtiments |
| 2 | **Maraîchage** | Gratuit | Légumes, serres, marchés |
| 3 | **Transport** | Permis (en jeu) | Camions, livraisons, licences |
| 4 | **Concessionnaire** | 90j ancienneté | Vente matériel, atelier, GPS |
| 5 | **CIA** | 90j ancienneté | Insémination artificielle |
| 6 | **Coop. Régionale (CAR)** | 90j + 3-7 associés | Achat/vente marchandises, huilerie, sucrerie, laiterie |
| 7 | **Fromagerie** | Gratuit (artisanale) / 90j ancienneté (industrielle) | Transformation lait → fromage |
| 8 | **Marché/Grossiste** | Via fromagerie/maraîchage | Vente directe consommateurs |
| 9 | **Forêts/ETF** | Investissement lourd | Exploitation forestière |
| 10 | **Viticulture** | 90j ancienneté + investissement | Vignes, vinification, cave |
| 11 | **CECA** | Élection (90j ancienneté) | Conseil économique, votes, taxes |

---

# 4. BOUCLE ÉLEVAGE (quotidienne)

## 4.1 Espèces (14)
| Espèce | Bâtiment | Litière | Lait | Laine | Œufs | Plein air |
|--------|----------|---------|------|-------|------|-----------|
| Bovins laitiers | Stabulation | Paille/Caillebotis | ✅ | ❌ | ❌ | Avr-Oct |
| Bovins allaitants | Stabulation | Paille/Caillebotis | ✅ | ❌ | ❌ | Toute l'année* |
| Porcins | Porcherie | Paille/Caillebotis | ❌ | ❌ | ❌ | Avr-Oct (abris) |
| Caprins | Chèvrerie | Paille | ✅ | Mohair (Angora) | ❌ | Avr-Oct |
| Ovins laitiers | Bergerie | Paille | ✅ | ✅ (certaines) | ❌ | Avr-Oct |
| Ovins allaitants | Bergerie | Paille | ❌ | ✅ | ❌ | Toute l'année* |
| Lapins | Clapier | Paille | ❌ | Angora | ❌ | ❌ (jamais) |
| Volailles | Poulailler | Paille | ❌ | ❌ | ✅ | Semi-liberté (parc) |
| Pintades | Poulailler | Paille | ❌ | ❌ | Reproduction | Semi-liberté |
| Oies | Poulailler | Paille | ❌ | Duvet | Reproduction | Semi-liberté obligatoire |
| Canards | Poulailler | Paille | ❌ | Duvet | ✅ | Semi-liberté obligatoire |
| Bisons | Prairie boisée | ❌ | ❌ | ❌ | ❌ | Toute l'année |
| Daims | Prairie boisée | ❌ | ❌ | ❌ | ❌ | Toute l'année |
| Chevaux (selle/trait/poney) | Écurie | Paille | ❌ | ❌ | ❌ | Mar-Nov |

*avec ration hivernale

## 4.2 Actions quotidiennes élevage

### Nourrir
- **Manuel** : Onglet Animaux → icône nourrir par catégorie
- **Robot alimentation** : 185 000 €, automatique si stock suffisant
- **Au pré** : Herbe uniquement (Avr-Oct), ration hivernale si allaitants restent dehors

#### Deux types de ration

**Ration standard** (achetable)
- Item unique par espèce, achetable à la coopérative Cultivia ou à d'autres joueurs
- Production et croissance normales (baseline 100%)
- Aucune composition requise — idéal pour les débutants

**Ration libre** (composée par le joueur)
- Le joueur compose sa ration en choisissant les ingrédients et proportions
- 4 besoins nutritionnels par espèce : **Énergie**, **Protéines**, **Fibres**, **Minéraux**
- Bonus selon la couverture des besoins :

| Couverture (4 axes) | Bonus production/croissance |
|----------------------|-----------------------------|
| < 100% sur un axe | Pas de bonus (= ration standard) |
| 100% sur les 4 axes | +10% |
| 110% sur les 4 axes | +20% |
| 120%+ sur les 4 axes | +30% (plafond) |

- Surdosage au-delà de 120% = gaspillage, pas de bonus supplémentaire, pas de malus
- Recettes de ration sauvegardables

**Besoins nutritionnels par espèce** :

| Espèce | Énergie | Protéines | Fibres | Minéraux | Profil |
|--------|---------|-----------|--------|----------|--------|
| Bovins laitiers | Élevé | Élevé | Moyen | Moyen | Gros besoins, équilibré |
| Bovins allaitants | Moyen | Moyen | Élevé | Faible | Rustique, fibres++ |
| Porcins | Élevé | Élevé | Faible | Faible | Énergie + protéines |
| Caprins | Moyen | Moyen | Élevé | Moyen | Fibres++ (brouteurs) |
| Ovins | Moyen | Moyen | Élevé | Faible | Similaire caprins |
| Lapins | Faible | Moyen | Élevé | Faible | Fibres+++ |
| Volailles | Moyen | Élevé | Faible | Moyen | Protéines++ (œufs) |
| Chevaux | Élevé | Moyen | Élevé | Moyen | Énergie + fibres |
| Bisons/Daims | Faible | Faible | Élevé | Faible | Rustiques, fibres |

**Ingrédients ration libre** :

| Ingrédient | Énergie | Protéines | Fibres | Minéraux | Source |
|-----------|---------|-----------|--------|----------|--------|
| Maïs ensilé | +++ | + | + | — | Culture |
| Orge | ++ | + | + | — | Culture |
| Blé | ++ | + | + | — | Culture |
| Avoine | ++ | + | ++ | — | Culture |
| Triticale | ++ | + | + | — | Culture |
| Sorgho ensilé | ++ | + | ++ | — | Culture |
| Céréale immature | + | + | ++ | — | Culture |
| Foin | + | + | +++ | + | Pré |
| Herbe (pré) | + | + | ++ | + | Pâturage |
| Luzerne | + | ++ | ++ | + | Culture |
| Ensilage d'herbe | + | + | ++ | + | Pré (ensileuse) |
| Paille | — | — | ++ | — | Moisson |
| Bois déchiqueté | — | — | + | — | Forêt/haie |
| Tourteau colza | + | +++ | — | — | Huilerie CAR |
| Tourteau tournesol | + | +++ | — | — | Huilerie CAR |
| Pois | + | ++ | + | — | Culture |
| Féverole | + | ++ | + | — | Culture |
| Soja | + | +++ | — | — | Culture |
| Betterave | ++ | — | + | — | Culture |
| Pomme de terre | ++ | + | — | — | Culture |
| Pulpe betterave | + | + | ++ | — | Sucrerie CAR |
| Mélasse | +++ | — | — | + | Sucrerie CAR |
| Minéraux+vitamines | — | — | — | +++ | Coopérative |
| Lait (allaitement) | ++ | ++ | — | ++ | Traite |

### Abreuver
- **Bâtiment** : Cuve à eau (se remplit eau robinet ou pluie via toitures)
- **Pré** : Bacs à eau + tonne à eau pour remplir, ou source naturelle, ou canalisation
- **Canalisation** : Relie ferme↔parcelle même zone, remplissage auto bacs

### Pailler / Litière
- **Pailleuse** (tracteur+pailleuse) ou **manuel**
- Paille → se transforme en **fumier**
- Sans paille = risque maladie
- Alternative : **bois déchiqueté** (30% de la quantité paille)

### Retirer fumier
- **Matériel** : chargeur frontal + tracteur + benne
- **Stockage** : fosse à fumier ou directement dans parcelle
- **Épandage** : 25 T/hectare avec épandeur à fumier

### Retirer lisier (élevage caillebotis)
- **Stockage** : fosse à lisier
- **Épandage** : 15 m³/hectare avec tonne à lisier

### Traite
- **Espèces** : Vaches, chèvres, brebis
- **Matériel** : Salle de traite + cuve à lait
- **Fréquence** : Jusqu'à 4 fois/jour (avant 6h, 12h, 18h, 24h)
- **Non obligatoire** : Pas d'impact santé si pas de traite

### Collecte œufs
- **Espèces** : Poules (quotidien), canes (Jan-Sep)
- **Matériel** : Salle conditionnement + pièce stockage
- **1 collecte/jour max**, coûte des HT

### Soins
- **Maladies** : Si pas nourri, pas d'eau, litière insuffisante
- **Vétérinaire** : Appeler pour soigner (coûte HT + €)
- **Vaccination** : Protection 1 an contre toute maladie
- **Animal malade** : Pas de croissance, pas de lait/œufs, pas d'insémination

---

# 5. BOUCLE REPRODUCTION / GÉNÉTIQUE

## 5.1 Insémination
| Mode | Description |
|------|-------------|
| **Artificielle (CIA)** | Inséminateur vient, semence d'un mâle de CIA joueur ou Cultivia |
| **Naturelle** | Mâle reproducteur de même race dans l'élevage |

## 5.2 Reproduction par espèce
| Espèce | Âge repro | Gestation | Portée | Délai entre mises bas |
|--------|-----------|-----------|--------|----------------------|
| Bovins | 27 mois (♀), 3 ans (♂) | 9 mois | 1 (jumeaux possible) | 3 mois min |
| Porcins | 12 mois | 4 mois | 6-9 | 1 mois min |
| Caprins | 12 mois (♀), 1 an (♂) | 5 mois | 2 | 6 mois min |
| Ovins | 12 mois | 5 mois | 1-2 | 7 mois min |
| Lapins | 3 mois | 1 mois | 6-7 | 1 mois min |
| Volailles | 6 mois | 1 mois | 6-10 | 5 jours min |
| Pintades | 9 mois | 6 cycles×1 mois | 8-15/cycle | Saisonnier (Mars) |
| Oies | 6 mois | 9 jours | 4-10 | Saisonnier (Jan-Fév insém, Mar-Juin ponte) |
| Canards | 6 mois | 7-9 jours | 3-12 | Saisonnier (Avril insém) |
| Bisons | 3 ans (♀ 27m) | 9 mois | 1 | Saisonnier (Jul-Oct) |
| Daims | 16 mois (♀), 3 ans (♂) | 8 mois | 1 | Saisonnier (Octobre) |
| Chevaux | 3 ans | 11 mois | 1 | 1 mois min |

## 5.3 Indices génétiques
| Indice | Espèces | Effet |
|--------|---------|-------|
| Croissance | Toutes | Poids adulte |
| Prolificité | Porcins, lapins | Nb petits/portée |
| Allure générale | Toutes | Apparence, concours |
| Lait | Bovins, caprins, ovins | Production lait |
| Qualité Lait (QL) | Bovins, caprins, ovins | Prix du lait |
| Laine | Ovins, lapins angora, caprins angora | Production laine |
| Œuf | Volailles, pintades | Nb œufs/jour |
| Éclosion | Pintades, oies, canards | Taux éclosion |
| Résistance | Bisons, daims | Résistance maladies |
| Sociabilité | Bisons, daims | Facilité approche |
| Fertilité | Oies | Taux réussite insémination |
| Duvet | Oies, canards | Production duvet |
| Physique | Chevaux | Qualités physiques |
| Mental | Chevaux | Qualités mentales |

## 5.4 IVRAD (races rares)
- Objectifs génétiques → débloquer des **slots IVRAD**
- 1 slot = 1 animal adulte de race rare
- Animaux IVRAD : reproduction naturelle uniquement (pas d'IA)
- Taux réussite accouplement : 10-15% selon espèce
- Salon des Races Rares : vente/achat races rares (Mai)
