> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# Catalogue exhaustif des actions — Agriva
> Date : 2026-08-04
> Principe directeur : ADR-006 — Toute action déclenche la cascade complète de ses effets
> Capacité : exploitant 12 h/jour, ouvrier 8 h/jour (fixes, ADR-004)

## Conventions
- ⏱️ = temps de travail consommé
- ⛽ = carburant (GNR)
- 🔧 = usure matériel (heures compteur)
- 🌱 = intrant consommé (stock −)
- 📦 = production/stock ajouté (+)
- 🌍 = modification sol/parcelle
- 💰 = flux d'argent
- ⚠️ = alerte/risque déclenché
- N/E = différence Normal/Expert

---

## §1. CULTURES — TRAVAUX DE PARCELLE

---

### 1.01 — Labourer

**Déclencheur** : joueur sélectionne « Labourer » sur une parcelle récoltée ou en interculture
**Catégorie** : Cultures > Travail du sol

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle récoltée ou en interculture ; sol non gelé (Expert : cumul pluie 7j < 40 mm argile / < 55 mm limon) |
| Matériel | Tracteur (≥ 32 CV/corps) + charrue (3 à 9 corps, largeur 1,05 à 3,15 m) |
| Formule durée | `surface / (largeur × 7 × 0.1 × 0.80)` |
| Exemple | 30 ha, charrue 5 corps (1,75 m) : `30 / (1,75 × 7 × 0,1 × 0,80)` = **30,6 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 30,6 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,85 × durée` (ex : 215 × 0,22 × 0,85 × 30,6 = 1 230 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h au compteur | Compteur horaire tracteur |
| 4 | 🔧 Usure charrue | +durée h (socs : durée de vie 400 ha, ex : 30 ha consommés) | Compteur pièces (socs) |
| 5 | 🌍 Sol — structure | Structure reset → « Bonne » ; résidus enfouis ; compaction reset | Parcelle.structure |
| 6 | 🌍 Sol — MO | −0,02% MO/labour (destruction humus) | Parcelle.matiere_organique |
| 7 | 🌍 Sol — adventices | −80% stock adventices | Parcelle.adventices |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 1 169 €) | Trésorerie |
| 9 | ⚠️ Semelle de labour | Si labour > 3 ans consécutifs même profondeur → alerte semelle | Parcelle.semelle |

**Différences N/E** : Normal — pas de vérification praticabilité sol, pas de semelle de labour. Expert — praticabilité (cumul pluie 7j), forcer en sol humide = tassement (−5% rendement année suivante, +30% conso carburant).

---

### 1.02 — Déchaumer

**Déclencheur** : joueur sélectionne « Déchaumer » sur une parcelle post-récolte ou en interculture
**Catégorie** : Cultures > Travail du sol

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle récoltée ; sol non gelé (Expert : cumul pluie 7j < 45 mm) |
| Matériel | Tracteur (≥ 28 CV/m) + déchaumeur (3 à 8 m) |
| Formule durée | `surface / (largeur × 10 × 0.1 × 0.85)` |
| Exemple | 30 ha, déchaumeur 4,5 m : `30 / (4,5 × 10 × 0,1 × 0,85)` = **7,8 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 7,8 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,75 × durée` (ex : 180 × 0,22 × 0,75 × 7,8 = 232 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure déchaumeur | +durée h (disques : durée de vie 800 ha) | Compteur pièces (disques) |
| 5 | 🌍 Sol — résidus | Résidus mélangés sur 5-10 cm (pas enfouis) | Parcelle.residus |
| 6 | 🌍 Sol — adventices | −50% stock adventices (faux-semis) | Parcelle.adventices |
| 7 | 🌍 Sol — structure | Amélioration superficielle ; pas de reset compaction | Parcelle.structure |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 220 €) | Trésorerie |

**Différences N/E** : Normal — pas de contrainte météo sauf forte pluie jour même. Expert — praticabilité fine ; un 2e déchaumage 10-15 jours après le 1er fait un excellent faux-semis (−30% adventices supplémentaires).

---

### 1.03 — Herser / Affiner

**Déclencheur** : joueur sélectionne « Affiner » sur une parcelle labourée ou déchaumée, avant semis
**Catégorie** : Cultures > Travail du sol (préparation lit de semence)

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle labourée ou déchaumée ; sol ressuyé (Expert : cumul pluie 7j < 30 mm) |
| Matériel | Tracteur (≥ 32 CV/m) + herse rotative (3 à 6 m) |
| Formule durée | `surface / (largeur × 8 × 0.1 × 0.82)` |
| Exemple | 30 ha, herse 4 m : `30 / (4 × 8 × 0,1 × 0,82)` = **11,4 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 11,4 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,75 × durée` (ex : 150 × 0,22 × 0,75 × 11,4 = 282 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure herse rotative | +durée h (dents : durée de vie 600 ha) | Compteur pièces (dents) |
| 5 | 🌍 Sol — lit de semence | Qualité lit = « Bon » (f_qualité_lit = 1,00) | Parcelle.lit_semence |
| 6 | 🌍 Sol — structure superficielle | Affinage sur 5-8 cm | Parcelle.surface |
| 7 | 💰 Coût carburant | litres × 0,95 €/L (ex : 268 €) | Trésorerie |

**Différences N/E** : Normal — action simple, produit toujours un « bon » lit. Expert — qualité dépend de l'humidité du sol ; si sol trop humide → lit grossier (f_qualité_lit = 0,96), si sol idéal → lit fin (1,00).

---

### 1.04 — Combiner (herse + semoir en 1 passage)

**Déclencheur** : joueur sélectionne « Semer (combiné) » sur une parcelle préparée ou labourée
**Catégorie** : Cultures > Travail du sol + Implantation

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle labourée ou déchaumée ; stock semences suffisant ; tracteur avec puissance ≥ 45 CV/m ; sol ressuyé |
| Matériel | Tracteur (≥ 45 CV/m) + combiné herse rotative + semoir (3 à 6 m) |
| Formule durée | `surface / (largeur × 8 × 0.1 × 0.78)` |
| Exemple | 30 ha, combiné 4 m : `30 / (4 × 8 × 0,1 × 0,78)` = **12,0 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 12,0 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,65 × durée` (ex : 180 × 0,22 × 0,65 × 12,0 = 309 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure herse | +durée h (dents : 600 ha) | Compteur pièces (dents) |
| 5 | 🔧 Usure semoir | +durée h (disques semoir : 500 ha) | Compteur pièces (disques) |
| 6 | 🌱 Semences | `surface × dose_ha` (ex : 30 ha × 180 kg/ha = 5 400 kg) | Stock semences −5,4 t |
| 7 | 🌍 Sol — lit de semence | Qualité lit = « Bon » (1,00) | Parcelle.lit_semence |
| 8 | 🌍 Sol — état | État → « Semée » ; culture associée ; date_semis = aujourd'hui | Parcelle.etat |
| 9 | 💰 Coût carburant | litres × 0,95 €/L (ex : 294 €) | Trésorerie |
| 10 | ⚠️ Fenêtre de semis | Si hors fenêtre optimale → pénalité date (Expert : −1%/jour) | Parcelle.penalite_date |

**Différences N/E** : Normal — économise 1 passage (herse + semis = 1 action au lieu de 2), pas de pénalité de date sauf hors fenêtre large. Expert — combiné requiert un tracteur plus puissant ; le rendement machine est légèrement plus bas (0,78 vs 0,80+0,82 séparés) car l'ensemble est lourd.

---

### 1.05 — Décompacter / Sous-soler

**Déclencheur** : joueur sélectionne « Décompacter » sur une parcelle dont la structure est dégradée ou avec semelle de labour
**Catégorie** : Cultures > Travail du sol (amélioration structurelle)

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle avec structure « Moyenne » ou « Dégradée » ou semelle de labour détectée ; sol sec (Expert : cumul pluie 7j < 25 mm) |
| Matériel | Tracteur (≥ 200 CV) + sous-soleuse / décompacteur (2,5 à 4 m) |
| Formule durée | `surface / (largeur × 6 × 0.1 × 0.75)` |
| Exemple | 30 ha, sous-soleuse 3 m : `30 / (3 × 6 × 0,1 × 0,75)` = **22,2 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 22,2 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,90 × durée` (ex : 250 × 0,22 × 0,90 × 22,2 = 1 098 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure sous-soleuse | +durée h (pointes : durée de vie 300 ha) | Compteur pièces (pointes) |
| 5 | 🌍 Sol — structure | Dégradée → Moyenne OU Moyenne → Bonne (1 niveau) | Parcelle.structure |
| 6 | 🌍 Sol — semelle | Semelle de labour cassée | Parcelle.semelle = false |
| 7 | 🌍 Sol — compaction | Compaction profonde réduite (reset 30-50 cm) | Parcelle.compaction_profonde |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 1 043 €) | Trésorerie |

**Différences N/E** : Normal — non modélisé (pas de tassement en Normal, action absente du menu). Expert — action corrective nécessaire si passages répétés en sol humide ; sol doit être SEC pour être efficace (sinon lissage au lieu de fissuration).

---

### 1.06 — Semer (céréales d'hiver)

**Déclencheur** : joueur sélectionne « Semer » sur une parcelle préparée, en fenêtre de semis d'automne
**Catégorie** : Cultures > Implantation

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle labourée+affinée OU combiné ; stock semences ≥ dose × surface ; T° sol > 5°C ; fenêtre semis (blé : 5 oct–15 nov, orge H : 25 sept–5 nov, colza : 15–31 août) |
| Matériel | Tracteur (≥ 12 CV/m) + semoir céréales (3 à 8 m) |
| Formule durée | `surface / (largeur × 10 × 0.1 × 0.80)` |
| Exemple | 30 ha, semoir 4 m : `30 / (4 × 10 × 0,1 × 0,80)` = **9,4 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 9,4 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,55 × durée` (ex : 150 × 0,22 × 0,55 × 9,4 = 171 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure semoir | +durée h (disques : 500 ha) | Compteur pièces (disques) |
| 5 | 🌱 Semences | `surface × dose_ha` — blé : 150-180 kg/ha ; orge H : 140-170 kg/ha ; colza : 3-4 kg/ha | Stock semences |
| 6 | 🌍 Sol — état | État → « Semée » ; culture = [blé/orge H/colza] ; date_semis | Parcelle.etat |
| 7 | 🌍 Sol — compaction | +0,1 à +0,3 (semoir léger sur sol meuble) | Parcelle.compaction |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 162 €) | Trésorerie |
| 9 | 💰 Coût semences | dose × prix — blé : 0,42 €/kg ; orge : 0,40 €/kg ; colza : 12 €/kg | Trésorerie |
| 10 | ⚠️ Pénalité date | Si hors fenêtre optimale : Normal −3% max ; Expert −1%/jour de retard | Parcelle.penalite_date |

**Différences N/E** : Normal — fenêtre large (3-4 semaines), dose suggérée automatiquement, pénalité douce (−3% max). Expert — fenêtre serrée (10 jours optimaux), choix de la densité (280-380 gr/m²), choix variétal (précoce/résistant/productif), pénalité forte (−1%/jour au-delà de la fenêtre optimale).


---

### 1.07 — Semer (cultures de printemps)

**Déclencheur** : joueur sélectionne « Semer » sur une parcelle préparée, en fenêtre de semis de printemps
**Catégorie** : Cultures > Implantation

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle préparée ; stock semences suffisant ; T° sol > 10°C (maïs, tournesol) ou > 5°C (pois, orge P) ; fenêtre : maïs 15 avr–10 mai, tournesol 1–25 avr, pois 20 fév–20 mars, orge P 15 fév–20 mars |
| Matériel | Semoir monograine (maïs/tournesol) : 4 à 12 rangs (3 à 9 m) — OU semoir céréales (pois/orge P) : 3 à 8 m |
| Formule durée (monograine) | `surface / (largeur × 8 × 0.1 × 0.75)` |
| Formule durée (céréales) | `surface / (largeur × 10 × 0.1 × 0.80)` |
| Exemple | 30 ha maïs, semoir 6 rangs (4,5 m) : `30 / (4,5 × 8 × 0,1 × 0,75)` = **11,1 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 11,1 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,55 × durée` (ex : 150 × 0,22 × 0,55 × 11,1 = 201 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure semoir | +durée h (éléments semeurs : 500 ha) | Compteur pièces |
| 5 | 🌱 Semences | Maïs : 85 000 gr/ha (≈ 22 kg/ha × prix dose 120 €/ha) ; tournesol : 70 000 gr/ha (≈ 5 kg, dose 80 €/ha) ; pois : 250 kg/ha (0,55 €/kg) | Stock semences |
| 6 | 🌍 Sol — état | État → « Semée » ; culture associée ; date_semis | Parcelle.etat |
| 7 | 🌍 Sol — compaction | +0,1 à +0,3 | Parcelle.compaction |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 191 €) | Trésorerie |
| 9 | 💰 Coût semences | dose × prix/ha × surface | Trésorerie |
| 10 | ⚠️ Pénalité date | Normal : −3% max hors fenêtre large ; Expert : −1,5%/jour (maïs très sensible) | Parcelle.penalite_date |

**Différences N/E** : Normal — dose automatique, fenêtre 3-4 semaines. Expert — choix variétal (précocité FAO pour maïs), choix densité (75 000–95 000 gr/m² maïs), T° sol vérifiée jour par jour, semis en sol froid = −15% levée.

---

### 1.08 — Semer couvert végétal (CIPAN)

**Déclencheur** : joueur sélectionne « Semer CIPAN » sur une parcelle en interculture (après récolte été, avant culture suivante)
**Catégorie** : Cultures > Implantation (couvert intermédiaire)

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle récoltée ; période août-octobre ; stock semences couvert disponible |
| Matériel | Tracteur (≥ 12 CV/m) + semoir céréales (3 à 8 m) OU épandeur centrifuge (semis à la volée, 12-24 m) |
| Formule durée (semoir) | `surface / (largeur × 10 × 0.1 × 0.80)` |
| Formule durée (volée) | `surface / (largeur × 14 × 0.1 × 0.85)` |
| Exemple | 30 ha, semoir 4 m : `30 / (4 × 10 × 0,1 × 0,80)` = **9,4 h** ; OU épandeur 18 m à la volée : `30 / (18 × 14 × 0,1 × 0,85)` = **1,4 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 1,4 h à la volée) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,45 × durée` (ex volée : 150 × 0,22 × 0,45 × 1,4 = 21 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure semoir/épandeur | +durée h | Compteur pièces |
| 5 | 🌱 Semences couvert | 20-40 kg/ha selon mélange (moutarde 8 kg, phacélie 10 kg, vesce+avoine 60 kg) × surface | Stock semences couvert |
| 6 | 🌍 Sol — état | État → « Couvert CIPAN » ; type couvert associé | Parcelle.etat |
| 7 | 🌍 Sol — MO (à terme) | +0,01% MO lors de la destruction (coefficient isohumique 0,20 × 2,5 t MS) | Parcelle.matiere_organique |
| 8 | 🌍 Sol — azote | Piège à azote (−lessivage hivernal) ; restitution 20-30 u N au suivant (si légumineuse dans le mélange) | Parcelle.azote_disponible |
| 9 | 💰 Coût carburant | litres × 0,95 €/L | Trésorerie |
| 10 | 💰 Coût semences | 40-80 €/ha selon mélange | Trésorerie |

**Différences N/E** : Normal — action optionnelle, bonus rotation +2% rendement suivant automatique. Expert — choix du mélange (légumineuse = N gratuit, crucifère = piège nitrates, graminée = structure), effet MO et N détaillé, obligation réglementaire en zone vulnérable (amende si absent).

---

### 1.09 — Fertiliser — engrais minéral (épandeur centrifuge)

**Déclencheur** : joueur sélectionne « Fertiliser » sur une parcelle en culture, pendant la période d'apport
**Catégorie** : Cultures > Conduite (nutrition)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place au stade adéquat ; stock engrais suffisant ; sol portant (Expert : cumul pluie 7j < 35 mm) ; vent < 30 km/h |
| Matériel | Tracteur (≥ 60 CV) + épandeur centrifuge (12 à 36 m) |
| Formule durée | `surface / (largeur × 14 × 0.1 × 0.85)` |
| Exemple | 30 ha, épandeur 24 m : `30 / (24 × 14 × 0,1 × 0,85)` = **1,05 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 1,05 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,45 × durée` (ex : 150 × 0,22 × 0,45 × 1,05 = 16 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure épandeur | +durée h (disques d'épandage : 2 000 ha) | Compteur pièces |
| 5 | 🌱 Engrais | `dose_u/ha × surface / teneur_produit` — ex : 180 u N × 30 ha / 335 (ammo 33,5%) = 16,1 t | Stock engrais |
| 6 | 🌍 Sol — NPK | +dose apportée par élément (ex : +180 u N/ha) | Parcelle.N (ou P, K) |
| 7 | 💰 Coût carburant | litres × 0,95 €/L (ex : 15 €) | Trésorerie |
| 8 | 💰 Coût engrais | tonnage × prix/t — ammonitrate 33,5% : 420 €/t → 16,1 t = 6 762 € | Trésorerie |
| 9 | ⚠️ Excès azote (Expert) | Si N total > 220 u/ha → risque verse (+15% probabilité) | Parcelle.risque_verse |

**Différences N/E** : Normal — 1 apport, dose conseillée automatique, pas de fractionnement. Expert — 3-4 apports fractionnés (tallage/épi 1cm/dernière feuille), efficience variable selon météo (0,50 à 0,90), plafond Directive Nitrates 170 u N organique/ha.

---

### 1.10 — Fertiliser — fumier/lisier (épandeur organique)

**Déclencheur** : joueur sélectionne « Épandre fumier » ou « Épandre lisier » sur une parcelle
**Catégorie** : Cultures > Conduite (nutrition organique)

| Élément | Détail |
|---------|--------|
| Prérequis | Stock effluents en fosse/fumière suffisant ; sol portant (Expert : cumul pluie 7j < 30 mm) ; vent < 25 km/h ; T° > 0°C ; calendrier réglementaire Expert (pas de lisier oct–jan sur sol nu) |
| Matériel | Tracteur (≥ 150 CV) + épandeur à fumier (10-18 t) OU tonne à lisier (12-22 m³) |
| Formule durée (fumier) | `(surface × dose_t/ha) / capacité_épandeur × (temps_chargement + temps_épandage + temps_trajet)` simplifié en : `surface / (débit_épandage ha/h)` avec débit ≈ 3-4 ha/h (épandeur 14 t à 25 t/ha, rechargement inclus) |
| Exemple | 30 ha, fumier 25 t/ha, épandeur 14 t, débit effectif 3 ha/h : **10,0 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 10,0 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,70 × durée` (ex : 180 × 0,22 × 0,70 × 10 = 277 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure épandeur | +durée h (chaînes/hérissons : 1 500 h) | Compteur pièces |
| 5 | 🌱 Effluents | `surface × dose` — fumier : 25 t/ha × 30 ha = 750 t ; lisier : 30 m³/ha × 30 ha = 900 m³ | Stock fosse/fumière |
| 6 | 🌍 Sol — NPK | Fumier 25 t/ha : +125 u N, +75 u P₂O₅, +175 u K₂O ; Lisier 30 m³ : +90 u N, +45 u P, +120 u K | Parcelle.N, P, K |
| 7 | 🌍 Sol — MO | Fumier : +0,15% MO/an (coeff. isohumique 0,30 × 25 t) ; Lisier : +0,02% | Parcelle.matiere_organique |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 263 €) | Trésorerie |
| 9 | 💰 Coût produit | 0 € si effluents propres ; coût épandage ETA : 7 €/t fumier ou 4 €/m³ lisier | Trésorerie |
| 10 | ⚠️ Plafond N organique | Expert : vérifie que Σ N organique / SAU épandable ≤ 170 u/ha | Exploitation.bilan_azote |

**Différences N/E** : Normal — pas de plafond réglementaire, pas de calendrier d'interdiction, épandage toujours possible. Expert — calendrier réglementaire strict, distances cours d'eau (35 m lisier), contrôle possible (pénalité PAC −5 à −20%).

---

### 1.11 — Fertiliser — chaulage

**Déclencheur** : joueur sélectionne « Chauler » sur une parcelle dont le pH < 6,5 (Expert) ou jauge fertilité basse (Normal)
**Catégorie** : Cultures > Conduite (amendement calcique)

| Élément | Détail |
|---------|--------|
| Prérequis | Expert : pH parcelle < 6,8 ; dernier chaulage > 3 ans ; sol portant. Normal : jauge fertilité < 80% |
| Matériel | Tracteur (≥ 150 CV) + épandeur à fumier (10-18 t) adapté chaux — OU prestation ETA |
| Formule durée | Similaire à fumier : `surface / 3 ha/h` (dose 3-5 t/ha, rechargement inclus) |
| Exemple | 30 ha, amendement calcaire 4 t/ha, épandeur 14 t, débit 3,5 ha/h : **8,6 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 8,6 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,70 × durée` (ex : 180 × 0,22 × 0,70 × 8,6 = 239 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure épandeur | +durée h | Compteur pièces |
| 5 | 🌱 Amendement calcaire | `surface × dose` (ex : 30 × 4 t = 120 t) | Stock amendement |
| 6 | 🌍 Sol — pH | +0,5 à +0,8 point de pH (selon produit et dose) ; effet progressif sur 6 mois | Parcelle.pH |
| 7 | 🌍 Sol — Ca | +180 u Ca/ha (pour 4 t/ha d'amendement calcaire broyé) | Parcelle.Ca |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 227 €) | Trésorerie |
| 9 | 💰 Coût amendement | 40-50 €/t livré × tonnage (ex : 120 t × 45 € = 5 400 €) soit 180 €/ha | Trésorerie |

**Différences N/E** : Normal — action « Amendement » (200 €/ha), recharge fertilité +20%, pas de notion de pH. Expert — choix du produit (chaux vive 1-2 t/ha, amendement broyé 3-5 t/ha, écume de sucrerie 15 t/ha gratuite hors transport), effet pH mesuré à l'analyse suivante, 1 chaulage max tous les 3 ans.


---

### 1.12 — Traiter — herbicide

**Déclencheur** : joueur sélectionne « Traiter (herbicide) » ou en Normal « Traiter — désherbage » sur une parcelle en culture
**Catégorie** : Cultures > Conduite (protection — adventices)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place (stade adapté : automne ou printemps précoce) ; stock produit phyto suffisant ; vent < 19 km/h ; T° 5–25°C ; hygrométrie > 60% ; pas de pluie le jour |
| Matériel | Tracteur (≥ 5 CV/m + 40 CV pour la cuve) + pulvérisateur traîné (12 à 40 m) |
| Formule durée | `surface / (largeur × 12 × 0.1 × 0.85)` |
| Exemple | 30 ha, pulvé 24 m : `30 / (24 × 12 × 0,1 × 0,85)` = **1,23 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 1,23 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,35 × durée` (ex : 150 × 0,22 × 0,35 × 1,23 = 14 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure pulvérisateur | +durée h (buses : durée de vie 3 ans / 300 h) | Compteur pièces (buses) |
| 5 | 🌱 Produit herbicide | `dose_L/ha × surface` — ex : 2 L/ha × 30 ha = 60 L | Stock phyto |
| 6 | 🌍 Parcelle — adventices | −70 à −95% pression adventices (selon efficacité produit) | Parcelle.adventices |
| 7 | 🌍 Rendement | +8 à +15% facteur protection (vs aucun traitement) | Parcelle.f_protection |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 13 €) | Trésorerie |
| 9 | 💰 Coût produit | 35-70 €/ha × surface (ex : 50 €/ha × 30 = 1 500 €) | Trésorerie |
| 10 | ⚠️ Résistances (Expert) | +1 au compteur d'utilisation de la matière active ; si > 6 utilisations consécutives → efficacité −10 à −25% | Parcelle.resistance_herbicide |

**Différences N/E** : Normal — 1 bouton « Traiter (désherbage) », efficacité 100%, pas de résistance, conditions météo = vent seul. Expert — choix de la matière active (anti-graminées vs anti-dicotylédones), efficacité variable selon stade adventice, conditions météo complètes (vent + T° + hygrométrie), résistances cumulatives.

---

### 1.13 — Traiter — fongicide

**Déclencheur** : joueur sélectionne « Traiter (fongicide) » sur une parcelle dont la pression maladie est détectée
**Catégorie** : Cultures > Conduite (protection — maladies)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place (stade adapté : montaison à floraison) ; stock produit suffisant ; vent < 19 km/h ; T° 5–25°C ; hygrométrie > 60% ; pas de pluie jour |
| Matériel | Tracteur + pulvérisateur (12 à 40 m) — même attelage que herbicide |
| Formule durée | `surface / (largeur × 12 × 0.1 × 0.85)` |
| Exemple | 30 ha, pulvé 24 m : **1,23 h** (idem herbicide) |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 1,23 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,35 × durée` (ex : 14 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure pulvérisateur | +durée h | Compteur pièces (buses) |
| 5 | 🌱 Produit fongicide | `dose_L/ha × surface` — ex : 1,5 L/ha × 30 ha = 45 L | Stock phyto |
| 6 | 🌍 Parcelle — pression maladie | Protection active 3-4 semaines ; pression réduite à 10-20% | Parcelle.pression_maladie |
| 7 | 🌍 Rendement | +6 à +12% facteur protection (fongicide seul, cumul avec herbicide) | Parcelle.f_protection |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 13 €) | Trésorerie |
| 9 | 💰 Coût produit | 40-90 €/ha (ex : 62 €/ha × 30 = 1 860 €) | Trésorerie |
| 10 | ⚠️ Timing (Expert) | Si traité trop tard (pression > 60% depuis 2 sem) → dégâts irréversibles, fongicide ne récupère que 50% du potentiel perdu | Parcelle.degats_irreversibles |

**Différences N/E** : Normal — le jeu suggère « Traiter (fongicide) » quand la pression est modérée, efficacité standard. Expert — 2 positionnements possibles (T1 relais + T2 épi), choix des molécules (triazole, SDHI, strobilurine), résistance aux strobilurines si suremploi, timing crucial.

---

### 1.14 — Traiter — insecticide

**Déclencheur** : joueur sélectionne « Traiter (insecticide) » sur une parcelle attaquée par des ravageurs
**Catégorie** : Cultures > Conduite (protection — ravageurs)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place ; observation de ravageurs au-dessus du seuil (Expert) ou alerte automatique (Normal) ; mêmes conditions météo que pulvérisation |
| Matériel | Tracteur + pulvérisateur (12 à 40 m) |
| Formule durée | `surface / (largeur × 12 × 0.1 × 0.85)` |
| Exemple | 30 ha, pulvé 24 m : **1,23 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 1,23 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,35 × durée` (ex : 14 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure pulvérisateur | +durée h | Compteur pièces (buses) |
| 5 | 🌱 Produit insecticide | `dose_L/ha × surface` — ex : 0,3 L/ha × 30 ha = 9 L | Stock phyto |
| 6 | 🌍 Parcelle — ravageurs | Population ravageur réduite à < 10% (efficacité 85-95%) | Parcelle.ravageurs |
| 7 | 🌍 Rendement | Évite la perte : +5 à +15% selon niveau d'attaque (sauvetage, pas bonus) | Parcelle.f_protection |
| 8 | 💰 Coût carburant | litres × 0,95 €/L | Trésorerie |
| 9 | 💰 Coût produit | 12-30 €/ha (ex : 22 €/ha × 30 = 660 €) | Trésorerie |
| 10 | ⚠️ Seuil de nuisibilité (Expert) | Si traitement sous le seuil → dépense inutile (gain < coût) ; si au-dessus → justifié | Parcelle.observation_ravageurs |

**Différences N/E** : Normal — le jeu propose de traiter uniquement quand c'est nécessaire, toujours efficace. Expert — observation du seuil de nuisibilité (ex : colza : 8 pieds sur 10 avec altises = seuil atteint), traitement sous le seuil = perte d'argent nette, certains ravageurs résistants après 4+ traitements identiques.

---

### 1.15 — Traiter — régulateur de croissance

**Déclencheur** : joueur sélectionne « Régulateur » sur une parcelle de céréales en montaison (prévention verse)
**Catégorie** : Cultures > Conduite (protection — verse)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture céréalière au stade épi 1cm à 1 nœud ; risque de verse identifié (sol fertile, forte densité, azote élevé) ; conditions de pulvérisation OK |
| Matériel | Tracteur + pulvérisateur (12 à 40 m) |
| Formule durée | `surface / (largeur × 12 × 0.1 × 0.85)` |
| Exemple | 30 ha, pulvé 24 m : **1,23 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 1,23 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,35 × durée` (ex : 14 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure pulvérisateur | +durée h | Compteur pièces (buses) |
| 5 | 🌱 Produit régulateur | `dose_L/ha × surface` — ex : 1,0 L/ha × 30 ha = 30 L | Stock phyto |
| 6 | 🌍 Parcelle — risque verse | Risque de verse réduit de 70-80% | Parcelle.risque_verse |
| 7 | 🌍 Rendement (indirect) | Évite −15% rendement + pertes récolte si verse survient | Parcelle.protection_verse |
| 8 | 💰 Coût carburant | litres × 0,95 €/L | Trésorerie |
| 9 | 💰 Coût produit | 15-30 €/ha (ex : 22 €/ha × 30 = 660 €) | Trésorerie |

**Différences N/E** : Normal — inclus dans le « traitement » global si le joueur fertilise à la dose conseillée (pas de verse). Expert — nécessaire si azote > 200 u/ha ou densité élevée ou variété sensible ; combinable avec le fongicide T1 (même passage).

---

### 1.16 — Désherber mécaniquement (bineuse / herse étrille)

**Déclencheur** : joueur sélectionne « Désherbage mécanique » sur une parcelle en culture (alternative aux herbicides)
**Catégorie** : Cultures > Conduite (protection — adventices, mécanique)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place, stade jeune (céréales : tallage pour herse étrille ; maïs/tournesol/betterave : 3-6 feuilles pour bineuse) ; sol SEC obligatoirement ; adventices jeunes (< 3 feuilles) |
| Matériel | Bineuse (maïs/colza/betterave) : 4 à 12 rangs (3-9 m) — OU herse étrille (céréales) : 6 à 15 m |
| Formule durée (bineuse) | `surface / (largeur × 7 × 0.1 × 0.75)` |
| Formule durée (herse étrille) | `surface / (largeur × 10 × 0.1 × 0.82)` |
| Exemple | 30 ha maïs, bineuse 6 rangs (4,5 m) : `30 / (4,5 × 7 × 0,1 × 0,75)` = **12,7 h** |
| Exemple | 30 ha blé, herse étrille 12 m : `30 / (12 × 10 × 0,1 × 0,82)` = **3,0 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex bineuse : 12,7 h ; herse étrille : 3,0 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,55 × durée` (ex bineuse : 150 × 0,22 × 0,55 × 12,7 = 231 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure bineuse/herse étrille | +durée h (socs bineuse : 400 ha ; dents herse : 800 ha) | Compteur pièces |
| 5 | 🌍 Parcelle — adventices | Bineuse : −70% ; herse étrille : −50% | Parcelle.adventices |
| 6 | 🌍 Sol — aération | Binage = aération superficielle du sol (+5% infiltration eau) | Parcelle.structure_surface |
| 7 | 🌍 Résistances | Réinitialise partiellement le compteur résistances herbicides (−2 points) | Parcelle.resistance_herbicide |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 219 €) | Trésorerie |
| 9 | 💰 Coût produit | 0 € (pas d'intrant chimique) | Trésorerie |
| 10 | ⚠️ Conditions | Si sol humide → arrachage des plantes cultivées (−3% peuplement) ; si adventices trop développées → efficacité ÷2 | Parcelle.peuplement |

**Différences N/E** : Normal — option de désherbage alternative à l'herbicide, efficacité affichée clairement. Expert — obligatoire en bio ; nécessite 2-3 passages pour efficacité équivalente à 1 herbicide ; fenêtre météo restrictive (sol sec + adventices jeunes = 2-3 jours de créneaux seulement) ; plus consommateur de temps mais 0 € d'intrant.


---

### 1.17 — Irriguer (enrouleur)

**Déclencheur** : joueur sélectionne « Irriguer » sur une parcelle en déficit hydrique, avec un enrouleur disponible
**Catégorie** : Cultures > Conduite (eau)

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place ; source d'eau disponible (forage, rivière, réserve) ; quota non épuisé (Expert) ; pas de restriction sécheresse (Expert niv.4) ; enrouleur disponible ; vent < 40 km/h ; pas de gel |
| Matériel | Enrouleur (couvre 60-80 m de large, avance sur 300-500 m) ; tracteur pour mise en place uniquement (0,5 h) |
| Formule durée | `(surface × dose_mm) / (débit_m³/h × efficience)` — un enrouleur couvre ≈ 3-4 ha/jour (24h de fonctionnement, 1 repositionnement) |
| Exemple | 30 ha, dose 30 mm, débit enrouleur 55 m³/h, bande 3,5 ha/position : 30/3,5 = 9 positions × 8h/position = **72 h de fonctionnement** (≈ 3 jours), temps joueur = 9 × 0,5 h déplacement = **4,5 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps joueur | 0,5 h par repositionnement × nb positions (ex : 4,5 h) | Pool heures joueur |
| 2 | ⛽ Carburant (pompage) | Coût énergie : `dose_mm × surface × 10 / 1000 × coût_m³` — ex : 30 mm × 30 ha × 10 = 9 000 m³ ; pompage ≈ 0,08 €/m³ = 720 € | Trésorerie (électricité) |
| 3 | 🔧 Usure enrouleur | +heures fonctionnement (durée de vie : 8 000 h) | Compteur horaire enrouleur |
| 4 | 🌱 Eau | 9 000 m³ consommés sur la réserve/forage | Stock eau (quota) |
| 5 | 🌍 Sol — réserve hydrique | +30 mm (dose) × efficience 0,75 = +22,5 mm effectifs dans la RU | Parcelle.reserve_eau |
| 6 | 🌍 Rendement | Stress hydrique évité : maintient f_eau = 1,00 (ou réduit déficit) | Parcelle.bilan_hydrique |
| 7 | 💰 Coût total | Énergie pompage + redevance eau (Expert : 0,05 €/m³ × 9 000 = 450 €) = 1 170 € soit **39 €/ha/tour** | Trésorerie |
| 8 | ⚠️ Restrictions (Expert) | Si niveau alerte sécheresse ≥ 2 → jours interdits ; niveau 4 → interdiction totale | Exploitation.irrigation |

**Différences N/E** : Normal — bouton « Irriguer » quand la jauge eau est basse, coût forfaitaire 40 €/ha/tour, remplit la jauge automatiquement. Expert — choix de la dose (20-40 mm), calcul du bilan hydrique, restrictions sécheresse par arrêté préfectoral, quota annuel de prélèvement (ex : 1 800 m³/ha).

---

### 1.18 — Irriguer (pivot)

**Déclencheur** : joueur sélectionne « Irriguer (pivot) » sur une parcelle équipée d'un pivot fixe
**Catégorie** : Cultures > Conduite (eau)

| Élément | Détail |
|---------|--------|
| Prérequis | Pivot installé sur la parcelle (investissement : 80 000-150 000 € selon surface couverte) ; source d'eau ; quota ; pas de gel ; vent < 30 km/h (Expert) |
| Matériel | Pivot fixe (couvre 30-80 ha en cercle) ; pas de tracteur nécessaire (autonome) |
| Formule durée | Le pivot est autonome : temps joueur = **0,25 h** (mise en route + contrôle). Durée de fonctionnement : 1 tour = 24-72 h selon dose et surface |
| Exemple | 50 ha, dose 25 mm : 50 × 25 × 10 = 12 500 m³ ; débit pivot 100 m³/h → 125 h de fonctionnement (≈ 5 jours). Temps joueur : **0,25 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps joueur | 0,25 h (mise en route automatique) | Pool heures joueur |
| 2 | ⛽ Énergie (pompage) | `volume_m³ × coût_énergie/m³` — ex : 12 500 × 0,06 €/m³ = 750 € (pivot + pompe) | Trésorerie |
| 3 | 🔧 Usure pivot | +heures de tour (durée de vie pivot : 15 000 h soit 20 ans) | Compteur horaire pivot |
| 4 | 🌱 Eau | Volume prélevé (ex : 12 500 m³) | Stock eau (quota) |
| 5 | 🌍 Sol — réserve hydrique | +25 mm × efficience 0,85 (pivot = meilleure uniformité) = +21 mm effectifs | Parcelle.reserve_eau |
| 6 | 🌍 Rendement | Stress hydrique évité ; sur maïs irrigué en Beauce : +40-60 q/ha vs non irrigué en année sèche | Parcelle.bilan_hydrique |
| 7 | 💰 Coût total | Énergie + redevance eau (ex : 750 + 625 = 1 375 €) soit **27,5 €/ha/tour** | Trésorerie |
| 8 | ⚠️ Restrictions (Expert) | Idem enrouleur : sécheresse, quota annuel | Exploitation.irrigation |

**Différences N/E** : Normal — même principe que l'enrouleur, coût 40 €/ha/tour. Expert — pivot plus efficient (85% vs 75% pour enrouleur), coût/ha/tour inférieur (−30%), mais investissement initial très lourd ; gestion du quota annuel de prélèvement ; parcelle ronde (perte de surface dans les coins).

---

### 1.19 — Moissonner (céréales)

**Déclencheur** : joueur sélectionne « Moissonner » sur une parcelle de céréales à maturité (≥ 85% Normal, humidité < 16% Expert)
**Catégorie** : Cultures > Récolte

| Élément | Détail |
|---------|--------|
| Prérequis | Culture à maturité ; humidité grain < 16% (Expert) ; pas de pluie le jour ; vent < 50 km/h ; moissonneuse disponible (propre, CUMA ou ETA) |
| Matériel | Moissonneuse-batteuse (coupe 4,5 à 10,5 m, automotrice) + benne/remorque pour évacuation |
| Formule durée | `surface / (largeur_coupe × 5.5 × 0.1 × 0.75)` |
| Exemple | 30 ha, moissonneuse coupe 6 m : `30 / (6 × 5,5 × 0,1 × 0,75)` = **12,1 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 12,1 h) | Pool heures joueur (ou ETA/CUMA) |
| 2 | ⛽ Carburant (moissonneuse) | Conso spécifique moissonneuse : 26 L/ha (automoteur) × surface (ex : 30 × 26 = 780 L) | Réservoir moissonneuse |
| 3 | 🔧 Usure moissonneuse | +durée h (courroies : 800 h ; batteur : 2 000 h ; chaîne : 400 h) | Compteurs pièces moissonneuse |
| 4 | 📦 Récolte | `surface × rendement_final` — ex : 30 ha × 86 q/ha = 258 t de grain | Stock silo (+258 t) |
| 5 | 🌍 Sol — résidus | Paille laissée au sol : 4-5 t/ha de résidus (menues pailles + paille si non pressée) | Parcelle.residus |
| 6 | 🌍 Sol — état | État → « Récoltée » ; date_récolte ; culture terminée | Parcelle.etat |
| 7 | 🌍 Sol — compaction | +0,4 à +0,6 (moissonneuse lourde, facteur poids 3,0) | Parcelle.compaction |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 741 €) | Trésorerie |
| 9 | 💰 Coût ETA (si applicable) | 110 €/ha × surface (ex : 3 300 €) | Trésorerie |
| 10 | ⚠️ Capacité silo | Si stock silo + récolte > capacité → perte de l'excédent OU action bloquée | Stock.silo |
| 11 | ⚠️ Qualité (Expert) | Si humidité > 15% → séchage nécessaire (0,80 €/t/point) ; si pluie récente → PS −2 points | Lot.qualite |

**Différences N/E** : Normal — fenêtre large (2 semaines), qualité 3 niveaux automatique, pas de séchage. Expert — humidité grain vérifiée (14-15% optimal, > 15% = séchage payant), qualité multi-critères (protéines, PS, mycotoxines), pertes récolte (+1,5%/semaine de retard après maturité, +3% si humide, +8% si verse).

---

### 1.20 — Récolter (betterave/PDT — arracheuse)

**Déclencheur** : joueur sélectionne « Arracher » sur une parcelle de betterave ou pomme de terre à maturité
**Catégorie** : Cultures > Récolte

| Élément | Détail |
|---------|--------|
| Prérequis | Culture à maturité (betterave : oct-nov, PDT : août-oct) ; sol ressuyé (Expert : cumul pluie 7j < 40 mm) ; T° > −3°C (pas de gel fort) ; arracheuse disponible (quasi toujours en ETA/CUMA) |
| Matériel | Arracheuse automotrice (betterave : 6 rangs, PDT : 2-4 rangs) + bennes de transport |
| Formule durée (betterave) | `surface / (débit arracheuse)` — débit 6 rangs : 1,5-2,0 ha/h |
| Formule durée (PDT) | `surface / (débit arracheuse)` — débit 2 rangs : 0,8-1,2 ha/h |
| Exemple | 15 ha betterave, arracheuse 6 rangs débit 1,8 ha/h : **8,3 h** |
| Exemple | 10 ha PDT, arracheuse 2 rangs débit 1,0 ha/h : **10,0 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex betterave : 8,3 h) | Pool heures joueur (ou ETA) |
| 2 | ⛽ Carburant (arracheuse) | Betterave : 55 L/ha × surface ; PDT : 45 L/ha × surface (ex : 55 × 15 = 825 L) | Réservoir arracheuse |
| 3 | 🔧 Usure arracheuse | +durée h (socs, rouleaux, chaînes : pièces spécifiques) | Compteurs pièces arracheuse |
| 4 | 📦 Récolte | Betterave : `surface × rendement_t/ha` (ex : 15 × 88 t = 1 320 t) ; PDT : 10 × 45 t = 450 t | Stock silo/bâtiment |
| 5 | 🌍 Sol — résidus | Betterave : fanes laissées (+30 u N, +10 u P, +60 u K si enfouies) ; PDT : peu de résidus | Parcelle.residus |
| 6 | 🌍 Sol — état | État → « Récoltée » | Parcelle.etat |
| 7 | 🌍 Sol — tassement | Compaction TRÈS ÉLEVÉE (+0,8 à +1,0 — arracheuse = poids 3,5) ; risque structure dégradée si sol humide | Parcelle.compaction |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 784 €) | Trésorerie |
| 9 | 💰 Coût ETA | Betterave : 250 €/ha ; PDT : 380 €/ha | Trésorerie |
| 10 | ⚠️ Tare terre (Expert) | Si sol humide → +5-15% de terre arrachée avec les racines → pénalité richesse sucre (betterave) ou surcoût nettoyage (PDT) | Lot.tare_terre |
| 11 | ⚠️ Capacité stockage | Betterave : souvent livraison directe usine (pas de silo) ; PDT : bâtiment ventilé nécessaire | Stock.capacite |

**Différences N/E** : Normal — rendement × prix simple, pas de tare. Expert — tare terre déduite du poids livré (betterave : richesse en sucre vérifiée, base 16°S, prime/malus), PDT : calibrage, taux de sucres réducteurs, conservation en bâtiment ventilé avec risque de pourriture si mal stocké.


---

### 1.21 — Ensiler (maïs/herbe)

**Déclencheur** : joueur sélectionne « Ensiler » sur une parcelle de maïs ensilage (30% MS) ou prairie (herbe préfanée)
**Catégorie** : Cultures > Récolte (fourrage)

| Élément | Détail |
|---------|--------|
| Prérequis | Maïs ensilage à maturité (stade grain pâteux, 30-35% MS) OU prairie fauchée et préfanée (35-40% MS) ; ensileuse disponible (quasi toujours en ETA/CUMA) ; charroi suffisant (2-3 remorques + tracteurs) ; silo taupe/couloir avec capacité disponible |
| Matériel | Ensileuse automotrice (6-12 rangs maïs OU pick-up herbe) + 2-3 tracteurs + remorques (charroi) + 1 tracteur tasseur au silo |
| Formule durée (maïs) | `surface / (débit ensileuse)` — 6 rangs : 2,5-3,5 ha/h |
| Formule durée (herbe) | `surface / (débit ensileuse pick-up)` — pick-up 3 m : 2,0-3,0 ha/h |
| Exemple | 20 ha maïs, ensileuse 8 rangs débit 3,2 ha/h : **6,3 h** — mais charroi = 3 tracteurs × 6,3 h = 18,9 h MO total + tassage 4 h = **23 h MO** (répartis entre exploitant + ouvriers + entraide) |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps total MO | Ensileuse 6,3 h + charroi 3 × 6,3 h + tassage 4 h + bâchage 2 h = **25,2 h** (répartis) | Pool heures (multiple acteurs) |
| 2 | ⛽ Carburant ensileuse | Maïs : 45 L/ha × surface (ex : 20 × 45 = 900 L) | Réservoir ensileuse |
| 3 | ⛽ Carburant charroi | 3 tracteurs × 12 L/h × 6,3 h = 227 L | Réservoirs tracteurs |
| 4 | ⛽ Carburant tassage | 1 tracteur × 18 L/h × 4 h = 72 L | Réservoir tracteur tasseur |
| 5 | 🔧 Usure ensileuse | +6,3 h (couteaux : 150 h ; rouleaux : 2 000 h) | Compteurs pièces |
| 6 | 🔧 Usure tracteurs charroi | +6,3 h × 3 tracteurs | Compteurs horaires |
| 7 | 🔧 Usure remorques | +6,3 h × 3 remorques | Compteurs remorques |
| 8 | 📦 Récolte | Maïs : `surface × 15 t MS/ha` (ex : 20 × 15 = 300 t MS) ; Herbe : `surface × 3-4 t MS/coupe` | Stock silo ensilage |
| 9 | 🌍 Sol — état | État → « Récoltée » | Parcelle.etat |
| 10 | 🌍 Sol — compaction | +0,5 à +0,7 (nombreux passages de remorques chargées) | Parcelle.compaction |
| 11 | 💰 Coût carburant total | (900 + 227 + 72) × 0,95 €/L = **1 139 €** | Trésorerie |
| 12 | 💰 Coût ETA (si prestation) | Maïs : 48 €/t MS × 300 t = 14 400 € (inclut ensileuse + charroi) | Trésorerie |
| 13 | ⚠️ Capacité silo | Si silo trop petit → perte (fermentation impossible si mal tassé en débordement) | Stock.silo_ensilage |
| 14 | ⚠️ Qualité (Expert) | MS trop basse (< 28%) → jus d'écoulement + mauvaise conservation ; MS trop haute (> 38%) → mauvais tassage | Lot.qualite_ensilage |

**Différences N/E** : Normal — le joueur lance « Ensiler », la prestation ETA gère tout (48 €/t MS), rendement standard affiché. Expert — le joueur gère le charroi (nombre de remorques = fluidité du chantier), qualité de tassage impacte la conservation (pertes 5-20% si mal fait), stade de récolte précis (30-35% MS optimal).

---

### 1.22 — Faucher (foin/herbe)

**Déclencheur** : joueur sélectionne « Faucher » sur une prairie prête (hauteur herbe > 20 cm) ou une luzerne au stade adapté
**Catégorie** : Cultures > Récolte (fourrage — étape 1/3)

| Élément | Détail |
|---------|--------|
| Prérequis | Prairie ou luzerne à maturité de coupe ; pas de pluie le jour (Expert : 3 jours secs prévus après la fauche) ; faucheuse disponible |
| Matériel | Tracteur (≥ 22 CV/m) + faucheuse (2,4 à 9 m, simple ou double) |
| Formule durée | `surface / (largeur × 12 × 0.1 × 0.85)` |
| Exemple | 20 ha, faucheuse 3,2 m : `20 / (3,2 × 12 × 0,1 × 0,85)` = **6,1 h** |
| Exemple | 20 ha, double fauche 6 m (avant + arrière) : `20 / (6 × 12 × 0,1 × 0,85)` = **3,3 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex simple : 6,1 h ; double : 3,3 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,60 × durée` (ex : 120 × 0,22 × 0,60 × 6,1 = 97 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure faucheuse | +durée h (couteaux/lames : durée de vie 500 ha) | Compteur pièces (couteaux) |
| 5 | 🌍 Parcelle — état | Herbe fauchée, andains au sol ; commence le séchage (humidité herbe 80% → cible 18% pour foin) | Parcelle.etat_fourrage |
| 6 | 🌍 Rendement fourrage | Prairie : 3-4 t MS/ha/coupe × surface (ex : 20 × 3,5 = 70 t MS potentiel) | Parcelle.rendement_fourrage |
| 7 | 💰 Coût carburant | litres × 0,95 €/L (ex : 92 €) | Trésorerie |
| 8 | ⚠️ Météo post-fauche | Si pluie dans les 72 h : qualité foin dégradée (−10 à −25%) ou foin perdu (> 15 mm) | Lot.qualite_foin |

**Différences N/E** : Normal — fauche + fenaison + pressage en un workflow simplifié (le joueur valide, le résultat apparaît après 3 jours). Expert — chaque étape est une action séparée ; la météo post-fauche est critique (3 jours secs nécessaires) ; choix du mode de récolte (foin sec, enrubannage 2 j, ensilage 1 j).

---

### 1.23 — Faner / Andainer

**Déclencheur** : joueur sélectionne « Faner » ou « Andainer » sur une parcelle avec herbe fauchée en cours de séchage
**Catégorie** : Cultures > Récolte (fourrage — étape 2/3)

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle fauchée ; herbe au sol en séchage ; pas de pluie le jour. Fanage : dans les 24-48 h après fauche (accélère séchage). Andainage : quand humidité herbe ≈ 20-25% (juste avant pressage) |
| Matériel | Faneuse : tracteur (≥ 60 CV) + faneuse (4,5 à 11 m) — Andaineur : tracteur + andaineur (3,5 à 12 m) |
| Formule durée fanage | `surface / (largeur × 12 × 0.1 × 0.88)` |
| Formule durée andainage | `surface / (largeur × 11 × 0.1 × 0.85)` |
| Exemple fanage | 20 ha, faneuse 6,5 m : `20 / (6,5 × 12 × 0,1 × 0,88)` = **2,9 h** |
| Exemple andainage | 20 ha, andaineur 6,5 m : `20 / (6,5 × 11 × 0,1 × 0,85)` = **3,3 h** |

**Cascade des effets (fanage) :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 2,9 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,40 × durée` (ex : 100 × 0,22 × 0,40 × 2,9 = 26 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure faneuse | +durée h (dents : durée de vie 2 000 ha) | Compteur pièces |
| 5 | 🌍 Fourrage — séchage | Accélère séchage de 0,5 jour (humidité −15 à −20 points en 1 passage) | Parcelle.humidite_fourrage |
| 6 | 💰 Coût carburant | litres × 0,95 €/L (ex : 25 €) | Trésorerie |

**Cascade des effets (andainage) :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 3,3 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,40 × durée` (ex : 100 × 0,22 × 0,40 × 3,3 = 29 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure andaineur | +durée h (dents : 2 000 ha) | Compteur pièces |
| 5 | 🌍 Fourrage — mise en andain | Herbe regroupée en andains réguliers (prêt pour pressage) | Parcelle.etat_fourrage = « andainé » |
| 6 | 💰 Coût carburant | litres × 0,95 €/L (ex : 28 €) | Trésorerie |

**Différences N/E** : Normal — fanage et andainage inclus dans le workflow « récolte foin » automatique. Expert — le joueur décide du nombre de fanages (1 à 3 selon météo), du moment de l'andainage (trop tôt = pressage humide, trop tard = feuilles qui tombent = perte de valeur).

---

### 1.24 — Presser (paille ou foin)

**Déclencheur** : joueur sélectionne « Presser » sur une parcelle avec andains de paille (post-moisson) ou foin sec andainé
**Catégorie** : Cultures > Récolte (fourrage — étape 3/3) ou résidus

| Élément | Détail |
|---------|--------|
| Prérequis | Andains au sol (paille post-moisson OU foin sec) ; humidité fourrage < 18% (Expert) ; pas de pluie depuis 72 h (Expert) ; presse disponible |
| Matériel | Tracteur (≥ 90 CV balle ronde, ≥ 160 CV grosse carrée) + presse (balle ronde Ø 1,5 m OU grosse carrée 120×90 cm) |
| Formule durée | `nb_balles / cadence_presse` — cadence balle ronde : 20-30 balles/h ; grosse carrée : 40-60 balles/h |
| Calcul nb balles | Paille blé : 1 balle ronde (300 kg) par ~0,5 ha → 30 ha = 60 balles rondes. Foin : 1 balle ronde par ~0,4 ha → 20 ha = 50 balles |
| Exemple | 30 ha de paille, presse ronde cadence 25 balles/h, 60 balles : **2,4 h**. OU grosse carrée cadence 50 balles/h, 35 balles (500 kg) : **0,7 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex ronde : 2,4 h ; carrée : 0,7 h) | Pool heures joueur |
| 2 | ⛽ Carburant | Presse ronde : 0,8 L/balle × nb_balles (ex : 48 L) ; carrée : 1,2 L/balle (ex : 42 L) + tracteur : `CV × 0,22 × 0,70 × durée` | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure presse | +durée h OU +nb_balles (chaînes presse : 15 000 balles ; courroies : 8 000 balles) | Compteur pièces (chaînes) |
| 5 | 🌱 Ficelle/filet | Balle ronde : 1 filet (1,50 €/balle) × nb ; carrée : ficelle (0,80 €/balle) | Stock consommables |
| 6 | 📦 Production | Paille : 60 balles rondes (18 t) → stock paille. Foin : 50 balles (15 t MS) → stock foin | Stock fourrage/litière |
| 7 | 🌍 Sol — résidus | Parcelle débarrassée des andains (résidus = 0) | Parcelle.residus = 0 |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 46 €) | Trésorerie |
| 9 | 💰 Coût ficelle/filet | 1,50 €/balle ronde ou 0,80 €/balle carrée (ex : 90 €) | Trésorerie |
| 10 | 💰 Coût ETA (si applicable) | Balle ronde : 11 €/balle ; grosse carrée : 13 €/balle | Trésorerie |
| 11 | ⚠️ Qualité foin (Expert) | Si humidité > 18% → moisissures en stockage, perte de valeur (−30%) voire risque d'incendie | Lot.qualite_foin |

**Différences N/E** : Normal — pressage inclus dans le workflow, qualité automatiquement « bonne ». Expert — humidité vérifiée (presser trop humide = moisissures = foin perdu), choix balle ronde (petit matériel, moins cher) vs grosse carrée (rapide, meilleur rendement, stockage plus dense).

---

### 1.25 — Broyer résidus de culture

**Déclencheur** : joueur sélectionne « Broyer » sur une parcelle récoltée avec résidus au sol (paille non pressée, cannes de maïs, tiges de tournesol)
**Catégorie** : Cultures > Travail du sol (gestion des résidus)

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle récoltée avec résidus au sol ; broyeur disponible |
| Matériel | Tracteur (≥ 80 CV) + broyeur à axe horizontal (2 à 6 m) |
| Formule durée | `surface / (largeur × 10 × 0.1 × 0.82)` |
| Exemple | 30 ha, broyeur 3 m : `30 / (3 × 10 × 0,1 × 0,82)` = **12,2 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 12,2 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,70 × durée` (ex : 120 × 0,22 × 0,70 × 12,2 = 225 L) | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure broyeur | +durée h (couteaux : durée de vie 150 h) | Compteur pièces (couteaux) |
| 5 | 🌍 Sol — résidus | Résidus broyés finement → dégradation accélérée | Parcelle.residus = « broyés » |
| 6 | 🌍 Sol — MO | +0,03% MO (restitution organique via enfouissement ultérieur — coeff. isohumique 0,15 × 4 t paille) | Parcelle.matiere_organique |
| 7 | 🌍 Sol — NPK (restitution) | Paille broyée : +15 u N, +5 u P, +40 u K/ha ; Cannes maïs : +20 u N, +8 u P, +50 u K | Parcelle.N, P, K |
| 8 | 💰 Coût carburant | litres × 0,95 €/L (ex : 214 €) | Trésorerie |
| 9 | 💰 Coût d'opportunité | Paille non pressée = renonce à la vente (120-180 €/ha) | — |

**Différences N/E** : Normal — action simple « Broyer paille » avec effet visible sur la jauge fertilité (+5%). Expert — restitution détaillée par élément (K surtout), impact MO calculé dans le bilan humique annuel, alternative au pressage avec arbitrage économique (vente paille 150 €/ha vs restitution sol valeur engrais ≈ 35 €/ha + MO long terme).

---

### 1.26 — Transporter récolte au silo

**Déclencheur** : joueur sélectionne « Transporter » ou « Vendre au silo coopérative » avec un stock de grain à acheminer
**Catégorie** : Cultures > Logistique

| Élément | Détail |
|---------|--------|
| Prérequis | Stock de grain en silo exploitation > 0 ; benne/remorque disponible ; tracteur disponible ; destination définie (silo coopérative, négoce, autre joueur) |
| Matériel | Tracteur (≥ 15 CV/t de charge utile) + benne céréalière (14-30 t de charge utile) |
| Formule durée | `nb_trajets × ((distance_km / vitesse_km/h) × 2 + temps_chargement + temps_déchargement)` |
| Calcul nb trajets | `⌈quantité_t / capacité_benne_t⌉` |
| Vitesse | Route : 25 km/h (tracteur + benne chargée) |
| Exemple | 60 t de blé, benne 18 t, distance 8 km : `⌈60/18⌉` = 4 trajets × `((8/25) × 2 + 0,17 h charge + 0,10 h décharge)` = 4 × 0,91 h = **3,6 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | durée h (ex : 3,6 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `CV × 0,22 × 0,45 × durée` (transport chargé) — ex : 150 × 0,22 × 0,45 × 3,6 = 53 L | Réservoir tracteur |
| 3 | 🔧 Usure tracteur | +durée h | Compteur horaire tracteur |
| 4 | 🔧 Usure benne | +durée h (pneus remorque : 2 000 h) | Compteur pièces (pneus) |
| 5 | 📦 Stock départ | −quantité transportée (ex : −60 t) | Stock silo exploitation |
| 6 | 📦 Stock arrivée (si stockage externe) | +quantité transportée | Stock silo coopérative |
| 7 | 💰 Coût carburant | litres × 0,95 €/L (ex : 50 €) | Trésorerie |
| 8 | 💰 Recette (si vente) | quantité × prix_du_jour (ex : 60 t × 220 €/t = 13 200 €) | Trésorerie (+) |
| 9 | 💰 Frais de stockage coopérative (Expert) | 2-3 €/t/mois si stockage externe | Trésorerie |
| 10 | ⚠️ Distance | Si distance > 15 km → surcoût carburant significatif ; si > 30 km → le joueur devrait envisager la livraison par un transporteur (camion, non modélisé en jeu : le coût est abstrait) | Trésorerie |

**Différences N/E** : Normal — transport simplifié (le joueur clique « Vendre », le coût de transport est déduit automatiquement selon la distance, pas de gestion du nombre de trajets). Expert — le joueur gère le nombre de bennes/trajets, peut optimiser (2 bennes en rotation = gain de temps mais 2 tracteurs monopolisés), distance réelle impacte le temps et le carburant.

---

*Fin de la section §1 — Cultures — Travaux de parcelle. Les sections suivantes (§2 Élevage, §3 Transformation, §4 Gestion) seront documentées dans des parties ultérieures du catalogue.*
# ACTIONS-CATALOGUE-ELEVAGE — §2. ÉLEVAGE — TOUTES ESPÈCES

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer (catalogue_part2_elevage)
> Références : ADR-006, GDD-bovin-laitier, GDD-poulet-chair, GDD-elevage-autres-especes, GDD-especes-secondaires, GDD-genetique

---

## §2. ÉLEVAGE — TOUTES ESPÈCES

Ce catalogue documente la **cascade complète des effets** de chaque action d'élevage, conformément à l'ADR-006 : aucune action n'a de coût partiel, toutes les ressources impliquées sont impactées.

---

## 2.A — ACTIONS QUOTIDIENNES

---

### 2.01 — Nourrir (mélangeuse)

**Déclencheur** : joueur lance « Distribuer ration » (quotidien ou automatisé via robot d'alimentation)
**Catégorie** : Élevage > Alimentation

| Élément | Détail |
|---------|--------|
| Prérequis | Tracteur disponible + mélangeuse attelée + stock aliment suffisant + bâtiment avec animaux |
| Matériel | Tracteur (100 CV typ.) + mélangeuse traînée (14-18 m³) |
| Formule durée | `durée = temps_chargement + temps_mélange + temps_distribution` = 20 min + 25 min/lot + 25 min/lot × nb_lots |
| Exemple | 60 VL, 2 lots (lactation + taries) : 20 + 50 + 50 = 2 h 00 |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_heures` (ex : 2,00 h pour 60 VL en 2 lots) | Pool exploitant/salarié |
| 2 | ⛽ Carburant | `100 CV × 0,22 L/CV/h × 0,60 (charge) × durée` = 26,4 L (ex.) | Réservoir tracteur (−) |
| 3 | 🔧 Usure tracteur | `+durée` heures au compteur | Compteur horaire tracteur |
| 4 | 🔧 Usure mélangeuse | `+durée` heures (couteaux : durée vie 300 h) | Compteur mélangeuse |
| 5 | 📦 Stock ensilage maïs (−) | `nb_VL × 30 kg/VL/j` (ration équilibrée) = 1 800 kg (ex. 60 VL) | Stock silo |
| 6 | 📦 Stock correcteur azoté (−) | `nb_VL × 7 kg/VL/j` = 420 kg | Stock hangar |
| 7 | 📦 Stock minéraux (−) | `nb_VL × 0,2 kg/VL/j` = 12 kg | Stock hangar |
| 8 | 🐄 Ration reçue | `ration_reçue = OUI`, `qualité_ration = f(équilibre UFL/PDI)` | État animal (lot) |
| 9 | 🐄 Production laitière | Si ration correcte : facteur alimentation = 1,00 ; si insuffisante : 0,75 | Production jour |
| 10 | 💰 Coût matière | `1 800 kg × 0,05 €/kg + 420 kg × 0,35 €/kg + 12 kg × 0,80 €/kg` = 247 € (ex.) | Trésorerie |

**Différences N/E** :
- **Normal** : 3 rations prédéfinies (Économique 3,80 €/VL/j, Équilibrée 5,20 €/VL/j, Intensive 6,40 €/VL/j). Le joueur choisit un niveau, la distribution est automatique.
- **Expert** : calcul libre UFL/PDI/MS/fibres/amidon. Risques nutritionnels (acidose si amidon > 28%, cétose si déficit > -3 UFL). Mélangeuse donne +4% production (homogénéité ration).

---

### 2.02 — Nourrir (distribution manuelle)

**Déclencheur** : joueur lance « Distribuer ration » sans mélangeuse (petits effectifs, caprins, ovins, équins)
**Catégorie** : Élevage > Alimentation

| Élément | Détail |
|---------|--------|
| Prérequis | Stock aliment suffisant + bâtiment avec animaux |
| Matériel | Brouette / seau / fourche (pas de tracteur) |
| Formule durée | `durée = nb_animaux × 2 min + 10 min (préparation)` |
| Exemple | 150 chèvres : 150 × 2 + 10 = 310 min = 5 h 10 ; 8 chevaux : 8 × 2 + 10 = 26 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_heures` (ex : 5,17 h pour 150 chèvres) | Pool exploitant/salarié |
| 2 | 📦 Stock foin (−) | Selon espèce : chèvre 2,5 kg/j, cheval 10 kg/j, brebis 2 kg/j | Stock hangar |
| 3 | 📦 Stock concentré (−) | Selon espèce/stade : chèvre 0,8 kg/j, cheval 3 kg/j | Stock hangar |
| 4 | 📦 Stock minéraux (−) | 0,1-0,2 kg/animal/j | Stock hangar |
| 5 | 🐄 Ration reçue | `ration_reçue = OUI` | État animal (lot) |
| 6 | 🐄 Production/Croissance | Facteur alimentation appliqué (1,00 si correcte) | Production/GMQ |

**Différences N/E** :
- **Normal** : une action rapide, consommation automatique.
- **Expert** : pas d'homogénéité de ration (pas de mélangeuse = -4% efficacité en bovin). L'ordre de distribution compte (les dominants mangent en premier → hétérogénéité).

---

### 2.03 — Abreuver (vérifier eau)

**Déclencheur** : vérification quotidienne automatique ou manuelle
**Catégorie** : Élevage > Alimentation

| Élément | Détail |
|---------|--------|
| Prérequis | Abreuvoirs installés dans le bâtiment/pâturage |
| Matériel | Abreuvoirs automatiques (1 pour 15 VL, 1 pour 30 brebis) |
| Formule durée | `durée = 5 min + nb_points_eau × 1 min` (vérification) |
| Exemple | Stabulation 60 VL, 4 abreuvoirs : 5 + 4 = 9 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_minutes` (ex : 9 min) | Pool exploitant |
| 2 | 💧 Eau consommée | VL : 80-120 L/j ; brebis : 5-8 L/j ; chèvre : 8-12 L/j ; cheval : 30-50 L/j | Compteur eau (−) |
| 3 | 🐄 Hydratation | Si eau disponible : état hydratation OK ; si panne/gel : santé −8%/jour | État animal |
| 4 | 💰 Coût eau | `nb_animaux × conso_L × 0,004 €/L` | Trésorerie |

**Différences N/E** :
- **Normal** : abreuvement automatique, le joueur n'intervient que si une alerte signale une panne. Pas de pénalité si vérification oubliée (auto-détection).
- **Expert** : risque de gel hivernal (−10°C → abreuvoirs bouchés si pas de résistance chauffante). Panne possible (0,5%/jour). Pénalité immédiate si non résolu.

---

### 2.04 — Traire (salle de traite)

**Déclencheur** : joueur lance « Traire » (2×/jour obligatoire)
**Catégorie** : Élevage > Traite

| Élément | Détail |
|---------|--------|
| Prérequis | Salle de traite opérationnelle + vaches en lactation + tank non plein |
| Matériel | Salle de traite (Épi 2×4 à Rotative 40 postes) |
| Formule durée | `durée = (nb_VL / cadence_horaire) + 25 min (préparation/lavage)` |
| Exemple | 50 VL, salle 2×6 (60 VL/h) : 50/60 + 0,42 = 1,25 h par traite × 2 = 2 h 30/jour |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée × 2 traites/jour` (ex : 2,50 h/jour) | Pool exploitant/salarié |
| 2 | ⚡ Électricité | `12 kWh/traite × 2` = 24 kWh/jour | Compteur électrique |
| 3 | 🔧 Usure salle traite | `+durée` heures/traite au compteur (manchons trayeurs : vie 2 500 h) | Compteur salle |
| 4 | 🥛 Production lait (+) | `Σ(production_individuelle_vache)` selon courbe lactation | Tank à lait (+) |
| 5 | 🐄 État traite | `traite_effectuée = OUI` ; si manquée : production −25% + mammite ×3 | État animal |
| 6 | 🏠 Tank à lait | `+production_jour` ; si tank plein → collecte forcée | Bâtiment (tank) |
| 7 | 💧 Eau de lavage | 5-8 L/VL/traite | Compteur eau (−) |
| 8 | 💰 Coût électricité | `24 kWh × 0,18 €` = 4,32 €/jour | Trésorerie |

**Différences N/E** :
- **Normal** : 1 action = tout le troupeau. Production constante par paliers (cf. GDD-bovin-laitier §3.2).
- **Expert** : intervalle entre traites (si < 10 h ou > 14 h → production −5%). Option monotraite (−30% production, −50% temps). Option 3 traites (+12% production, +50% temps). Comptage cellulaire individuel à chaque traite.

---

### 2.05 — Traire (robot)

**Déclencheur** : automatique (le robot tourne 24 h/24, les vaches viennent d'elles-mêmes)
**Catégorie** : Élevage > Traite

| Élément | Détail |
|---------|--------|
| Prérequis | Robot de traite installé (165 000 €) + bâtiment adapté (circulation libre) |
| Matériel | Robot de traite (capacité 55-65 VL/robot) |
| Formule durée | Surveillance uniquement : `30 min/jour` (alertes, vaches à pousser) |
| Exemple | 60 VL, 1 robot : 30 min/jour de surveillance |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 0,5 h/jour (surveillance) vs 2,5 h/jour (salle) = économie 2 h/jour | Pool exploitant |
| 2 | ⚡ Électricité | `+40% vs salle` = 33,6 kWh/jour | Compteur électrique |
| 3 | 🔧 Usure robot | `+24 h/jour` au compteur (durée vie 10-12 ans, maintenance 4 200 €/an) | Compteur robot |
| 4 | 📦 Consommables | Produits lavage, filtres : 3 500 €/an = 9,6 €/jour | Stock consommables (−) |
| 5 | 🥛 Production lait (+) | 2,6-3,1 traites/VL/jour → production +8 à +12% vs 2 traites | Tank à lait (+) |
| 6 | 🐄 Concentré au robot | Distribution individualisée : 2-4 kg/VL/passage | Stock concentré (−) |
| 7 | 🐄 Détection mammite | Conductivité mesurée → alerte automatique si cellules élevées | Alerte santé |
| 8 | 🏠 Tank à lait | `+production_jour` | Bâtiment (tank) |
| 9 | 💰 Coût jour | Élec 6,05 € + consommables 9,6 € + amortissement 45 €/jour = ~61 €/jour | Trésorerie |

**Différences N/E** :
- **Normal** : le robot est un achat « plug & play ». Réduction de temps affichée, pannes rares.
- **Expert** : taux de fréquentation (75-92% optimal). Si > 92% : file d'attente, production −6%. 3-5% de vaches inadaptées (réforme nécessaire). Panne : immobilisation > 12 h = crise. Contrat maintenance 24/7 : 4 200 €/an recommandé.



---

### 2.06 — Ramasser œufs

**Déclencheur** : quotidien (1-2×/jour recommandé)
**Catégorie** : Élevage > Collecte produits

| Élément | Détail |
|---------|--------|
| Prérequis | Poulailler avec poules pondeuses en production |
| Matériel | Manuel (plateaux) ou robot ramassage (20 000-35 000 €) ou tapis roulant (8 000-15 000 €) |
| Formule durée | Manuel : `nb_poules / 40 poules·min⁻¹` ; Tapis : `nb_poules / 200` ; Robot : `nb_poules / 1000` |
| Exemple | 3 000 poules, manuel : 75 min ; tapis : 15 min ; robot : 3 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Selon équipement (ex : 75 min manuel pour 3 000 poules) | Pool exploitant |
| 2 | 🥚 Œufs collectés (+) | `effectif_vivant × taux_ponte(semaine)` (ex : 3 000 × 93% = 2 790 œufs) | Stock œufs (+) |
| 3 | 🥚 Calibrage | Répartition S/M/L/XL selon âge poule (cf. GDD-especes-secondaires §2) | Qualité stock |
| 4 | 🔧 Usure équipement | Si robot/tapis : +durée au compteur | Compteur équipement |
| 5 | ⚡ Électricité (si robot) | 2-4 kWh/collecte | Compteur électrique |
| 6 | ⚠️ DLC | Œufs datés du jour de ponte. DLC = 28 jours. Non vendus → perte sèche | Stock (timer) |

**Différences N/E** :
- **Normal** : ramassage automatique (robot inclus dans l'investissement initial). Pas de DLC à gérer (vente auto hebdomadaire).
- **Expert** : ramassage manuel ou robot (investissement séparé). DLC à gérer (28 jours max). Choix du circuit de vente (grossiste vs circuit court).

---

### 2.07 — Pailler / litière

**Déclencheur** : joueur lance « Pailler » (fréquence selon le système : quotidien en aire paillée, hebdomadaire en logettes)
**Catégorie** : Élevage > Entretien bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Tracteur + pailleuse + stock paille suffisant + bâtiment nécessitant litière |
| Matériel | Tracteur (80-100 CV) + pailleuse (ou fourche pour petits effectifs) |
| Formule durée | Mécanisé : `15 min + nb_places × 0,5 min` ; Manuel : `nb_places × 2 min` |
| Exemple | 60 VL logettes paille, pailleuse : 15 + 60 × 0,5 = 45 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_heures` (ex : 0,75 h pour 60 logettes) | Pool exploitant |
| 2 | ⛽ Carburant | `80 CV × 0,22 × 0,45 × durée` = 5,9 L (ex.) | Réservoir tracteur (−) |
| 3 | 🔧 Usure tracteur | `+durée` heures | Compteur tracteur |
| 4 | 🔧 Usure pailleuse | `+durée` heures (tapis : vie 800 h) | Compteur pailleuse |
| 5 | 📦 Stock paille (−) | Logettes : 2 kg/VL/j ; Aire paillée intégrale : 12 kg/VL/j ; Aire mixte : 7 kg/VL/j | Stock paille |
| 6 | 🐄 Confort | `confort_litière = PROPRE` → production +0 à +3% ; si manquant : mammites ×2,5 | État animal |
| 7 | 🏠 Litière bâtiment | `état_litière = NEUF` ; compteur dégradation reset | État bâtiment |

**Différences N/E** :
- **Normal** : fréquence conseillée affichée. Pas de pénalité tant que la litière est « correcte ».
- **Expert** : litière sale = mammites ×2,5, cellules tank en hausse. Choix du substrat (paille, sciure 0,5 kg/j en logettes, copeaux). Chaque substrat a un coût et un effet différent sur les cellules.

---

### 2.08 — Curer fumier

**Déclencheur** : joueur lance « Curer » (fréquence : hebdomadaire en aire raclée, saisonnier en aire paillée intégrale)
**Catégorie** : Élevage > Entretien bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Tracteur + godet/racleur + fosse/fumière non pleine |
| Matériel | Tracteur (100+ CV) + godet chargeur ou racleur automatique (18 000 €) |
| Formule durée | Godet : `volume_fumier_m³ / 3 m³ (capacité godet) × 8 min/rotation` ; Racleur auto : 0 (fonctionnement continu) |
| Exemple | 60 VL, aire raclée, 1 semaine d'accumulation (~21 m³) : 21/3 × 8 = 56 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_heures` (ex : 0,93 h) ; racleur auto : 0 h (surveillance 10 min/jour) | Pool exploitant |
| 2 | ⛽ Carburant | `100 CV × 0,22 × 0,65 × durée` = 13,3 L (ex.) | Réservoir tracteur (−) |
| 3 | 🔧 Usure tracteur | `+durée` heures | Compteur tracteur |
| 4 | 🔧 Usure godet | `+durée` heures (dents : vie 500 h) | Compteur godet |
| 5 | 🏠 Fosse/fumière (+) | `+volume_curé` en m³ (ex : +21 m³) | Capacité fosse |
| 6 | 🏠 Bâtiment propre | `état_sol = PROPRE` → confort +, mammites − | État bâtiment |
| 7 | 🌱 Fumier produit | Fumier stocké = valorisable en épandage sur parcelles (N, P, K, MO) | Stock effluent |

**Différences N/E** :
- **Normal** : racleur automatique si installé, sinon action manuelle sans pénalité tant qu'on le fait 1×/semaine minimum.
- **Expert** : si curage négligé > 7 jours en aire raclée : propreté −, mammites ×1,8. Fosse pleine = blocage (pas de curage possible → il faut épandre d'abord). Gestion du plan d'épandage (plafond N directive nitrates).

---

### 2.09 — Surveiller lot (observation)

**Déclencheur** : joueur lance « Surveiller » (recommandé quotidien, obligatoire pour détection chaleurs/vêlages)
**Catégorie** : Élevage > Surveillance

| Élément | Détail |
|---------|--------|
| Prérequis | Animaux présents dans un bâtiment ou au pâturage |
| Matériel | Aucun (observation visuelle) ou caméra de surveillance (2 500 €) |
| Formule durée | `durée = 5 min + nb_animaux × 0,5 min` (visuel) ; Caméra : 5 min (revue écran) |
| Exemple | 60 VL, visuel : 5 + 30 = 35 min ; 60 VL avec caméra : 5 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_minutes` (ex : 35 min visuel) | Pool exploitant |
| 2 | 🐄 Détection chaleurs | Taux de détection : visuel 50-60% ; colliers 85-92% ; capteurs rumination 88-94% | État reproduction |
| 3 | 🐄 Détection vêlages | Si surveillance : mortalité veau réduite de 60% (assistance possible) | Alerte vêlage |
| 4 | 🐄 Détection maladies | Identification précoce : boiteries, mammites, comportement anormal | Alerte santé |
| 5 | 📊 Données lot | Mise à jour des indicateurs (comportement, ingestion, rumination si capteurs) | Tableau de bord |

**Différences N/E** :
- **Normal** : les alertes apparaissent automatiquement (chaleurs détectées, vêlages prévus, santé en baisse). La surveillance est implicite.
- **Expert** : sans surveillance active (visuelle ou capteurs), taux de détection chaleurs = 50-60% (vs 85-94% avec colliers). Chaque chaleur manquée = +21 jours d'IVV = −3 €/vache. Investissement colliers (110 €/vache) rentabilisé en 2,6 ans.



---

## 2.B — ACTIONS PÉRIODIQUES

---

### 2.10 — Inséminer / mettre au taureau

**Déclencheur** : joueur sélectionne une vache/brebis/chèvre en chaleur et choisit un reproducteur
**Catégorie** : Élevage > Reproduction

| Élément | Détail |
|---------|--------|
| Prérequis | Femelle en chaleur détectée + dose IA en stock OU taureau/bélier/bouc présent + délai post-partum respecté (60 j bovin, 45 j ovin/caprin) |
| Matériel | Dose IA (pistolet d'insémination) ou mâle reproducteur en lot |
| Formule durée | IA : `15 min/animal` (contention + insémination) ; Monte naturelle : `0 min` (automatique si mâle présent) |
| Exemple | 4 vaches à inséminer : 4 × 15 = 60 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_animaux × 15 min` (IA) ou 0 (monte naturelle) | Pool exploitant |
| 2 | 📦 Dose IA (−) | −1 dose/animal (prix : 18-156 € selon gamme, cf. GDD-genetique §4.2) | Stock semences |
| 3 | 🐄 Gestation (potentielle) | Taux réussite : Normal 55-65% ; Expert variable (42-65% selon 7 facteurs) | État reproduction |
| 4 | 🐄 Génétique veau | `index_descendant = (index_mère + index_père)/2 + aléa(σ=5)` | Futur veau (prédéterminé) |
| 5 | 🐄 Sexe veau | Conventionnel : 50/50 ; Sexée : 90% femelles | Futur veau |
| 6 | ⏱️ Gestation déclenchée | Si réussite : gestation = 283 j (bovin), 150 j (ovin/caprin), 114 j (porc), 31 j (lapin) | Timer gestation |
| 7 | 💰 Coût dose | Selon catalogue : Standard 18-25 €, Génomique 30-60 €, Élite 50-90 €, Sexée +36 € | Trésorerie |

**Différences N/E** :
- **Normal** : détection chaleurs automatique (le jeu signale les vaches prêtes). Choix du taureau simplifié (3-5 options). Taux réussite stable (55-65%).
- **Expert** : détection chaleurs selon méthode (50-95%). Taux réussite = `base_race × f_NEC × f_bilan_énergie × f_santé_utérine × f_index_fertilité × f_stress_therm × f_moment_IA`. Plan d'accouplement raisonné (éviter consanguinité > 6,25%).

---

### 2.11 — Détecter chaleurs

**Déclencheur** : joueur observe le troupeau ou consulte les alertes capteurs
**Catégorie** : Élevage > Reproduction

| Élément | Détail |
|---------|--------|
| Prérequis | Femelles non gestantes, post-partum > 40 jours |
| Matériel | Visuel (0 €), podomètres/colliers (110 €/vache), capteurs rumination (140 €/vache), patchs (8 €/cycle), progestérone (4 €/test) |
| Formule durée | Visuel : `15 min × 2/jour` (matin + soir) ; Capteurs : `5 min/jour` (consultation alertes) |
| Exemple | 50 VL, visuel : 30 min/jour ; colliers : 5 min/jour |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Visuel : 30 min/jour × 365 = 182 h/an ; Capteurs : 5 min/jour = 30 h/an | Pool exploitant |
| 2 | 🐄 Chaleurs détectées | Taux : visuel 50-60%, colliers 85-92%, capteurs rumination 88-94%, patch 75-85%, progestérone 95% | État reproduction |
| 3 | 📦 Consommable (−) | Patchs : 8 €/vache/cycle ; Progestérone : 4 €/test | Stock consommables |
| 4 | 💰 Investissement capteurs | Colliers : 110 €/vache (amortissement 5 ans = 22 €/vache/an) | Amortissement |
| 5 | ⚠️ Chaleur manquée | Si non détectée : +21 jours d'IVV, coût 3 €/jour de retard × 21 = 63 €/vache | Perte économique |

**Différences N/E** :
- **Normal** : détection automatique (le jeu alerte le joueur). Pas de coût supplémentaire.
- **Expert** : le joueur choisit sa méthode. ROI colliers : 6 600 € (60 VL) → gain IVV 402→388 j = +2 520 €/an → retour 2,6 ans.

---

### 2.12 — Contrôle de gestation

**Déclencheur** : joueur lance « Contrôle gestation » 30-45 jours post-IA
**Catégorie** : Élevage > Reproduction

| Élément | Détail |
|---------|--------|
| Prérequis | Animal inséminé/sailli depuis 30-45 jours |
| Matériel | Échographe (vétérinaire) ou palpation transrectale (bovin) |
| Formule durée | `nb_animaux × 5 min + 15 min (installation)` |
| Exemple | 10 vaches à contrôler : 10 × 5 + 15 = 65 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_minutes` (ex : 65 min pour 10 vaches) | Pool exploitant |
| 2 | 🐄 Statut gestation | Confirmation : gestante OUI/NON. Si NON : retour en insémination | État reproduction |
| 3 | 💰 Coût vétérinaire | Écho : 8 €/animal ; Palpation : 5 €/animal (forfait visite : 35 €) | Trésorerie |
| 4 | ⚠️ Non-gestation détectée | Si non gestante : reprogrammer IA (−21 j de délai vs ne pas savoir) | Alerte reproduction |

**Différences N/E** :
- **Normal** : le résultat de gestation est affiché automatiquement à J+35. Pas de visite vétérinaire explicite.
- **Expert** : le joueur doit planifier le contrôle. S'il oublie, il ne sait pas si la vache est gestante jusqu'à signes tardifs (5e mois). Perte de 60-90 jours si non-gestation non détectée.

---

### 2.13 — Vêlage / mise-bas (surveillance)

**Déclencheur** : l'animal atteint le terme de gestation (283 j bovin, 150 j ovin/caprin, 114 j porc, 335-345 j équin)
**Catégorie** : Élevage > Reproduction

| Élément | Détail |
|---------|--------|
| Prérequis | Femelle gestante à terme + box/case de vêlage disponible (si applicable) |
| Matériel | Box de vêlage (bovin), case maternité (porc), caméra surveillance (2 500 €, optionnel) |
| Formule durée | Surveillance : `1-4 h par vêlage` (selon difficulté) ; Assistance : `+30-60 min` si dystocie |
| Exemple | Vache Charolaise primipare (12% dystocie) : 2-4 h surveillance |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 1-4 h/vêlage (selon espèce/difficulté) ; porc : 2-4 h surveillance portée entière | Pool exploitant |
| 2 | 🐄 Naissance(s) | 1 veau (bovin), 1-3 agneaux/chevreaux (ovin/caprin), 12-16 porcelets, 1 poulain (équin) | Nouvel animal créé |
| 3 | 🐄 Mortalité néonatale | Sans surveillance : mortalité veau 25% si dystocie ; avec : 10%. Caméra : mortalité −60% | Risque mortalité |
| 4 | 🐄 Dystocie | Probabilité = `base_race × f_parité × f_taureau × f_NEC` (Charolais P1 : 12%, Salers : 2%) | État animal mère |
| 5 | 💰 Coût vétérinaire | Si césarienne : 150-350 € ; Si assistance simple : 80 € | Trésorerie |
| 6 | 🐄 Lactation déclenchée | Vache/chèvre : début courbe lactation (J0 = vêlage). Production en montée | État lactation |
| 7 | 🐄 IVV compteur | Enregistrement date vêlage → calcul IVV pour la prochaine gestation | Indicateur repro |
| 8 | 🏠 Box vêlage occupé | Box indisponible pendant 2-5 jours post-vêlage | État bâtiment |

**Différences N/E** :
- **Normal** : vêlage automatique, pas de dystocie (sauf événement rare). Lactation démarre automatiquement. Si oublié tarissement : auto à J−50.
- **Expert** : difficulté = `base_race × f_parité × f_taureau × f_NEC`. Conséquences dystocie : mortalité veau 25% si non assisté, IVV +15-30 j. Caméra (2 500 €) réduit mortalité de 60%. Choix taureau « facilité naissance > 105 » recommandé sur primipares.



---

### 2.14 — Sevrer

**Déclencheur** : joueur lance « Sevrer » quand le jeune atteint l'âge/poids cible
**Catégorie** : Élevage > Conduite du troupeau

| Élément | Détail |
|---------|--------|
| Prérequis | Jeune animal ayant atteint l'âge minimum (veau 3-10 mois, agneau 60-90 j, porcelet 21-28 j, poulain 6 mois) |
| Matériel | Bâtiment séparé (nurserie/post-sevrage) ou lot distinct |
| Formule durée | `nb_animaux × 3 min (séparation physique) + 15 min (déplacement lot)` |
| Exemple | 15 veaux à sevrer : 15 × 3 + 15 = 60 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `durée_minutes` (ex : 60 min pour 15 veaux) | Pool exploitant |
| 2 | 🐄 Jeune : changement alimentation | Passage lait maternel → ration solide. Porcelet 7-8 kg → post-sevrage | État alimentation jeune |
| 3 | 🐄 Mère : fin allaitement | Besoin énergétique mère −4,5 UFL/j (bovin) ; retour ration entretien | État alimentation mère |
| 4 | 🐄 Mère : retour en chaleur | Sevrage déclenche retour cyclique (porc : 4-7 j post-sevrage) | État reproduction mère |
| 5 | 🐄 Stress sevrage | Jeune : stress +20 pts pendant 5-7 jours → GMQ −15% temporaire | État bien-être |
| 6 | 📦 Stock lait poudre/DAL (−) | Si allaitement artificiel post-sevrage progressif : 2-3 kg/veau/j pendant 7 j | Stock aliment |
| 7 | 🏠 Changement lot | Jeune quitte le lot « sous la mère » → lot « post-sevrage » ou « génisses » | Affectation lot |

**Différences N/E** :
- **Normal** : bouton « Sevrer » à l'âge recommandé. Pas de stress visible. Le jeu conseille la date optimale.
- **Expert** : sevrage progressif possible (3 semaines, −stress, +GMQ final). Sevrage brutal = stress +20, GMQ −15% pendant 7 j. Date de sevrage influe sur le poids final du broutard (bovin allaitant : +80 kg si sous la mère 8 mois vs 6 mois).

---

### 2.15 — Tarir (vache laitière)

**Déclencheur** : joueur lance « Tarir » sur une vache 55-65 jours avant la date de vêlage prévue
**Catégorie** : Élevage > Conduite du troupeau

| Élément | Détail |
|---------|--------|
| Prérequis | Vache gestante, à 55-65 jours du vêlage prévu |
| Matériel | Traitement au tarissement (antibiotique intramammaire 18 €/vache ou obturateur seul 8 €/vache) |
| Formule durée | `nb_vaches × 10 min (traitement intramammaire)` |
| Exemple | 3 vaches à tarir : 3 × 10 = 30 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_vaches × 10 min` | Pool exploitant |
| 2 | 📦 Traitement (−) | −1 tube antibio/quartier × 4 quartiers × nb_vaches (ou obturateur) | Stock médicaments |
| 3 | 🐄 Production lait = 0 | La vache ne produit plus de lait pendant 55-65 jours | Production (arrêt) |
| 4 | 🐄 Régénération mamelle | Tissu mammaire se régénère → lactation suivante optimale si durée 55-65 j | État mamelle |
| 5 | 🐄 Changement lot | Vache passe du lot « lactation » au lot « taries » | Affectation lot |
| 6 | 🐄 Ration tarissement | Passage ration faible énergie, riche fibres (si Expert : sinon engraissement) | État alimentation |
| 7 | 💰 Coût traitement | 18 €/vache (antibio) ou 8 €/vache (obturateur) | Trésorerie |

**Différences N/E** :
- **Normal** : le jeu prévient 10 j avant la date recommandée. Si oublié : tarissement automatique à J−50. Pas de pénalité.
- **Expert** : tarissement < 40 j → mamelle non régénérée, lactation suivante −12%, mammite ×2. Tarissement > 80 j → engraissement (NEC > 3,5), vêlage difficile, cétose. Ration spécifique obligatoire. Choix antibio vs obturateur (label « sans antibiotique » = +0,015 €/L).

---

### 2.16 — Vacciner

**Déclencheur** : joueur lance « Vacciner » (annuel ou selon protocole)
**Catégorie** : Élevage > Santé

| Élément | Détail |
|---------|--------|
| Prérequis | Animaux à vacciner + stock vaccins + cornadis/contention |
| Matériel | Seringues, cornadis autobloquants (bovins), cage de contention (ovins) |
| Formule durée | `nb_animaux × 3 min + 15 min (préparation)` |
| Exemple | 100 bovins (VL + génisses) BVD+IBR+FCO : 100 × 3 + 15 = 315 min = 5 h 15 |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_animaux × 3 min + 15 min` (ex : 5,25 h pour 100 bovins) | Pool exploitant |
| 2 | 📦 Stock vaccins (−) | −1 dose/animal/vaccin. Bovin : BVD 12 €, IBR 15 €, FCO 8 € = 35 €/animal total | Stock médicaments |
| 3 | 🐄 Protection sanitaire | Risque épizootie 8%/an (non vacciné) → 0,5%/an (vacciné). Durée protection 12 mois | État santé |
| 4 | 🐄 Vaccin expiré | Si retard > 30 j : protection 50% seulement → risque intermédiaire | État vaccinal |
| 5 | 💰 Coût total | Bovin (BVD+IBR+FCO) : 35 €/animal × 100 = 3 500 €/an | Trésorerie |
| 6 | ⚠️ Économie si non-vacciné | Épizootie BVD : 8 vaches × 220 €/trait. + 15 j sans collecte (9 375 €) = 11 135 € perte | Risque économique |

**Différences N/E** :
- **Normal** : action « Vacciner » annuelle, forfait affiché, rappel automatique. Alerte si vaccin expire.
- **Expert** : le joueur choisit quels vaccins administrer, peut cibler par lot. Un oubli de rappel expose le troupeau. Volailles : Newcastle, Gumboro, Bronchite = 0,08 €/poulet (si oublié → risque maladie).

---

### 2.17 — Soigner (traitement curatif)

**Déclencheur** : animal ou lot détecté malade (alerte santé)
**Catégorie** : Élevage > Santé

| Élément | Détail |
|---------|--------|
| Prérequis | Diagnostic établi (mammite, boiterie, métrite, coccidiose...) + médicament en stock |
| Matériel | Médicaments (antibiotiques, anti-inflammatoires, antiparasitaires), matériel d'injection |
| Formule durée | `15-30 min/animal (selon gravité)` + visite vétérinaire si prescription (1 h) |
| Exemple | 1 vache mammite clinique : 20 min traitement + visite véto 1 h = 1 h 20 |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 15-30 min/animal + visite véto si nécessaire (1 h) | Pool exploitant |
| 2 | 📦 Médicaments (−) | Antibiotique : 45-90 €/traitement ; Anti-inflammatoire : 15-30 € | Stock médicaments |
| 3 | 🐄 Santé (+) | Santé +25% (Normal) ; guérison en 3-7 j (Expert) selon maladie | État santé animal |
| 4 | 🥛 Lait jeté | Antibiotique = délai d'attente 5-8 jours. Lait non commercialisable | Production (perte) |
| 5 | 💰 Coût vétérinaire | Visite : 35-50 € ; Mammite complète : 220 € ; Boiterie : 150 € ; Césarienne : 350 € | Trésorerie |
| 6 | 🐄 Compteur antibiotiques | +1 traitement au compteur annuel. Label « sans antibio » impossible si > 0 | Indicateur qualité |
| 7 | ⚠️ Lait traité dans le tank | Si erreur (lait antibio collecté) → TOUTE la collecte refusée | Risque critique |

**Différences N/E** :
- **Normal** : 1 action « Soigner » = santé +25%, coût 45 €/vache. Pas de délai d'attente modélisé.
- **Expert** : 4 maladies spécifiques (mammite 220 €, boiterie 150 €, métrite 130 €, cétose 180 €). Délai d'attente 5-8 j (lait jeté). Arbitrage soigner vs réformer. Compteur antibiotiques impactant les labels.

---

### 2.18 — Vermifuger

**Déclencheur** : joueur lance « Vermifuger » (1×/an recommandé, à la rentrée en bâtiment)
**Catégorie** : Élevage > Santé

| Élément | Détail |
|---------|--------|
| Prérequis | Animaux à traiter + stock anthelminthique |
| Matériel | Anthelminthique (bolus, injectable, ou per os) |
| Formule durée | `nb_animaux × 2 min + 10 min (préparation)` |
| Exemple | 350 brebis : 350 × 2 + 10 = 720 min = 12 h (sur 2 jours) |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_animaux × 2 min + 10 min` (ex : 12 h pour 350 brebis) | Pool exploitant |
| 2 | 📦 Anthelminthique (−) | Coût : 12 €/bovin, 2 €/brebis, 1 €/chèvre | Stock médicaments |
| 3 | 🐄 Parasitisme | Niveau infestation −80% immédiatement | État parasitaire |
| 4 | 🐄 Production restaurée | Si infestation > 30% : GMQ agneaux −20% → retour normal post-traitement | GMQ / Production |
| 5 | ⚠️ Résistance | Si traitement > 4×/an même troupeau : probabilité 15%/an de résistance | Risque long terme |
| 6 | 💰 Coût | 12 €/bovin × 60 = 720 € ; 2 €/brebis × 350 = 700 € | Trésorerie |

**Différences N/E** :
- **Normal** : vermifugation 1×/an, coût forfaitaire, pas de parasitisme modélisé. Santé −8%/mois si non fait.
- **Expert** : parasitisme ovin = LE problème sanitaire (strongles). Infestation +5%/sem si même paddock > 3 sem. Traitements > 4×/an → risque résistance 15%/an → changement molécule ×3 prix. Gestion raisonnée (rotation pâturage) > traitement systématique.

---

### 2.19 — Parage / tonte (onglons, laine)

**Déclencheur** : joueur lance « Parer » (bovins 2×/an) ou « Tondre » (ovins 1×/an, juin)
**Catégorie** : Élevage > Santé / Entretien

| Élément | Détail |
|---------|--------|
| Prérequis | Animaux à parer/tondre + intervenant (pareur, tondeur) + cage de contention |
| Matériel | Cage de parage (bovins), tondeuse (ovins), pareur professionnel |
| Formule durée | Parage : `nb_animaux × 8 min` ; Tonte : `nb_animaux × 4 min` |
| Exemple | 60 VL parage : 60 × 8 = 480 min = 8 h ; 350 brebis tonte : 350 × 4 = 1 400 min = 23 h (2-3 jours) |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Parage 8 min/animal, tonte 4 min/animal | Pool exploitant (ou prestataire) |
| 2 | 💰 Coût prestation | Parage : 22 €/bovin ; Tonte : 3 €/brebis (coût net — laine quasi sans valeur) | Trésorerie |
| 3 | 🐄 Prévention boiteries | Parage 2×/an → boiteries −35% (15 cas/100 VL au lieu de 30) | Risque sanitaire |
| 4 | 🐄 Confort ovin | Tonte avant été → évite stress thermique, meilleur bien-être | État confort |
| 5 | 📦 Laine (+) | Ovin : ~3 kg/brebis. Valeur : quasi nulle (0,50-1,50 €/kg brut) → coût net −3 €/brebis | Stock laine (marginal) |
| 6 | 🐄 Production | Bovin : si boiterie = −15% production + fertilité −20%. Parage = prévention | Production indirecte |

**Différences N/E** :
- **Normal** : action planifiée avec rappel. Coût forfaitaire. Si négligé : santé −.
- **Expert** : boiterie = 2e maladie bovin laitier (20-30 cas/100 VL/an). Sans parage : +15 cas/100 VL supplémentaires. Coût boiterie : 150 €/cas. Investissement pédiluve automatique (6 500 €) → boiteries −35%.

---

### 2.20 — Débourrage (équin)

**Déclencheur** : joueur lance « Débourrer » sur un jeune cheval de 3-4 ans
**Catégorie** : Élevage > Valorisation équine

| Élément | Détail |
|---------|--------|
| Prérequis | Cheval de 3-4 ans, non débourré + manège/carrière ou rond de longe |
| Matériel | Manège (30 000 €) ou rond de longe (8 000 €) + matériel équitation |
| Formule durée | `30 jours × 1 h/jour` = 30 h de travail (étalé sur 4-6 semaines) |
| Exemple | 1 poulain de 3 ans : 30 h sur 6 semaines |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 30 h par cheval (étalé sur 4-6 semaines) | Pool exploitant |
| 2 | 🐎 Statut débourré | Cheval passe de « non débourré » à « débourré » → valorisation possible | État animal |
| 3 | 💰 Valorisation | Prix vente ×1,5 à ×2 (cheval débourré vs non débourré) | Valeur marchande |
| 4 | 🔧 Usure installation | +30 h au compteur manège/carrière | Compteur installation |
| 5 | 💰 Coût externe | Si confié à un professionnel : 800-1 500 €/cheval (4-6 semaines pension + travail) | Trésorerie |

**Différences N/E** :
- **Normal** : action « Débourrer » simple. Durée fixe 30 jours. Valorisation +50% automatique.
- **Expert** : qualité du débourrage influencée par l'investissement temps. Cheval mal débourré : vente −20%. Possibilité de spécialiser (CSO, dressage, CCE) pour cibler des acheteurs premium.



---

## 2.C — GESTION DE LOT

---

### 2.21 — Acheter animaux (marché/joueur)

**Déclencheur** : joueur accède au marché et sélectionne des animaux à acheter
**Catégorie** : Élevage > Commerce

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante + place disponible (bâtiment ou enclos d'attente max 20 UGB) |
| Matériel | Bétaillère si transport depuis autre exploitation (cf. 2.28) |
| Formule durée | Marché : `30 min (transaction)` + transport (variable) ; Joueur : `15 min (transaction)` + transport |
| Exemple | Achat 5 génisses au marché à 30 km : 30 min + transport 1 h 30 = 2 h |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Transaction + transport (si nécessaire) | Pool exploitant |
| 2 | 💰 Prix d'achat (−) | Génisse laitière pleine : 1 800-2 400 € ; Vache réforme : 600-1 300 € ; Poussin : 0,45-1,30 € | Trésorerie |
| 3 | 🐄 Animal(x) ajouté(s) | Ajout au troupeau dans l'enclos d'attente (max 2 j sans pénalité) | Effectif |
| 4 | 🐄 Stress transport | Nouveaux animaux : production −5% pendant 3 jours (adaptation) | État animal |
| 5 | 🏠 Place occupée | −1 place disponible dans enclos d'attente ou bâtiment cible | Capacité bâtiment |
| 6 | 📋 Quarantaine (Expert) | 15 jours d'isolement recommandé (risque sanitaire si non respecté) | État sanitaire |

**Différences N/E** :
- **Normal** : achat instantané, animal livré dans le bâtiment choisi. Pas de quarantaine.
- **Expert** : quarantaine 15 j recommandée (biosécurité porc : obligatoire). Si non respecté : risque d'introduction maladie dans le troupeau. Enclos d'attente > 2 j = pénalités (santé −5/j, faim −10/j dès J3).

---

### 2.22 — Vendre animaux (marché/joueur/abattoir)

**Déclencheur** : joueur sélectionne des animaux à vendre et choisit la destination
**Catégorie** : Élevage > Commerce

| Élément | Détail |
|---------|--------|
| Prérequis | Animaux à vendre + visite sanitaire à jour + bétaillère (si transport) |
| Matériel | Bétaillère pour le transport vers marché/abattoir |
| Formule durée | Préparation : `nb_animaux × 5 min` + transport |
| Exemple | Vente 30 broutards à l'abattoir (20 km) : 30 × 5 min + transport 1 h = 3 h 30 |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Préparation + transport | Pool exploitant |
| 2 | 💰 Recette (+) | Selon type : broutard 380 kg × 2,80 €/kg = 1 064 € ; VL réforme 950-1 300 € ; porc 90,8 kg × 1,88 €/kg = 171 € | Trésorerie |
| 3 | 🐄 Animaux retirés | −nb_animaux du troupeau | Effectif |
| 4 | ⛽ Carburant transport | Si bétaillère : cf. action 2.28 | Réservoir tracteur |
| 5 | 🔧 Usure bétaillère | +durée_transport heures | Compteur bétaillère |
| 6 | 🏠 Places libérées | +nb_places dans le bâtiment d'origine | Capacité bâtiment |
| 7 | 📊 Classement (Expert) | Bovin viande : grille EUROP (E/U/R/O/P × état engraissement). Prime/malus ±0,60 €/kg | Prix carcasse |

**Différences N/E** :
- **Normal** : prix stable selon le type d'animal. Vente instantanée.
- **Expert** : prix variable (saisonnalité ±15%). Classement EUROP pour bovins viande. TMP pour porcs. Saisonnalité ovine (Pâques +20%). Choix du moment de vente = stratégie.

---

### 2.23 — Réformer

**Déclencheur** : joueur décide de réformer un animal (fin de carrière, mauvaise génétique, problème santé chronique)
**Catégorie** : Élevage > Commerce

| Élément | Détail |
|---------|--------|
| Prérequis | Animal identifié comme candidat à la réforme |
| Matériel | Aucun (décision administrative + vente ultérieure) |
| Formule durée | `5 min (décision + marquage)` |
| Exemple | Réformer 3 vaches : 15 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 5 min/animal | Pool exploitant |
| 2 | 🐄 Statut | Animal marqué « à réformer » → transfert vers lot de vente | État animal |
| 3 | 💰 Valeur boucherie | VL bon état 950-1 300 € ; VL maigre 600-850 € ; Montb./Normande +15% | Recette future |
| 4 | 🐄 Place libérée | −1 UGB du troupeau productif → besoin génisse de remplacement | Capacité |
| 5 | 📊 Taux renouvellement | +1 au compteur réforme annuel. Objectif 30-38%/an (bovin laitier) | Indicateur |
| 6 | 🐄 Génétique | Retrait de l'ISU le plus faible → hausse ISU moyen troupeau | Progression génétique |

**Différences N/E** :
- **Normal** : recommandations automatiques (« cette vache coûte plus qu'elle ne rapporte »). Choix libre du joueur.
- **Expert** : calcul de la marge individuelle par vache (production − charges). Recommandation basée sur carrière (production, cellules, fertilité, âge). Taux de renouvellement optimum à gérer (< 25% = troupeau vieillissant, > 40% = coûteux).

---

### 2.24 — Déplacer entre bâtiments

**Déclencheur** : joueur déplace un lot ou un animal vers un autre bâtiment de l'exploitation
**Catégorie** : Élevage > Logistique

| Élément | Détail |
|---------|--------|
| Prérequis | Bâtiment destination avec place disponible + couloir/chemin praticable |
| Matériel | Aucun (déplacement à pied sur l'exploitation) ou quad pour distances > 500 m |
| Formule durée | `nb_animaux × 2 min + distance_m / 50 m·min⁻¹` |
| Exemple | 10 vaches, bâtiment à 200 m : 10 × 2 + 200/50 = 24 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_animaux × 2 min + distance/50` | Pool exploitant |
| 2 | 🐄 Localisation | Animaux changent de bâtiment d'affectation | État localisation |
| 3 | 🐄 Stress léger | Déplacement intra-exploitation : stress +5 (négligeable, récupéré en 1 j) | État bien-être |
| 4 | 🏠 Capacité | −places dans bâtiment origine, +places occupées dans destination | Bâtiments |

**Différences N/E** :
- **Normal** : déplacement instantané (drag & drop entre bâtiments).
- **Expert** : temps réel de déplacement. Si pas de couloir adapté : risque d'évasion (0,5%). Mixage de lots inconnus = bagarres, stress +15 pendant 3 j.

---

### 2.25 — Mettre au pâturage / rentrer

**Déclencheur** : joueur lance « Mettre au pré » (printemps, avril-mai) ou « Rentrer » (automne, octobre-novembre)
**Catégorie** : Élevage > Conduite du troupeau

| Élément | Détail |
|---------|--------|
| Prérequis | Pâtures disponibles (35-45 ares/VL, 2 m²/poulet LR) + portail ouvert + herbe suffisante (> 8 cm) |
| Matériel | Clôtures en état + abreuvoirs au pré |
| Formule durée | Mise au pré : `nb_animaux × 3 min + 15 min (vérification clôtures)` ; Rentrée : `nb_animaux × 4 min` |
| Exemple | 60 VL mise au pré : 60 × 3 + 15 = 195 min = 3 h 15 |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Mise au pré / rentrée (ex : 3 h 15 pour 60 VL) | Pool exploitant |
| 2 | 🐄 Alimentation | Pâturage : coût alimentaire −60% (herbe gratuite). Complémentation concentré : 2 kg/VL | État alimentation |
| 3 | 🐄 Production | Pâturage : production −8 à −12% (herbe moins dense que maïs ensilé) | Production |
| 4 | 🐄 Bien-être | +15% bien-être. Accès label « pâturage » (+0,015 €/L) | État confort |
| 5 | 🏠 Bâtiment libéré | Places de stabulation libres → possibilité d'accueillir d'autres animaux | Capacité |
| 6 | 🌱 Prairie | Herbe consommée (chargement 1 VL/35-45 ares). Si surpâturage : dégradation prairie | État parcelle |
| 7 | ⚠️ Risque | Ovin au pâturage : parasitisme +5%/sem (si même paddock > 3 sem) | Risque sanitaire |

**Différences N/E** :
- **Normal** : bouton « Mettre au pré » / « Rentrer ». Coût réduit automatiquement. Production légèrement réduite.
- **Expert** : pâturage tournant avec paddocks (6-8 paddocks, 2-3 j/paddock, repos 18-24 j). Herbomètre (entrée 12-15 cm, sortie 5-6 cm). Croissance herbe variable selon saison (45-95 kg MS/ha/j). Risque tétanie d'herbage au printemps (si transition brutale sans Mg).

---

### 2.26 — Grouper lots

**Déclencheur** : joueur fusionne deux lots en un seul (ex : regrouper les lots en lactation)
**Catégorie** : Élevage > Logistique

| Élément | Détail |
|---------|--------|
| Prérequis | 2 lots existants + bâtiment avec capacité suffisante |
| Matériel | Aucun (gestion administrative + déplacement physique si nécessaire) |
| Formule durée | `nb_animaux_déplacés × 2 min` (si même bâtiment : instantané) |
| Exemple | Fusionner 2 lots de 25 VL dans la même stabulation : instantané |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Instantané si même bâtiment ; sinon déplacement (cf. 2.24) | Pool exploitant |
| 2 | 🐄 Ration unifiée | Les 2 lots reçoivent la même ration (à vérifier si compatible) | État alimentation |
| 3 | 🐄 Stress regroupement | Animaux inconnus mélangés : stress +10 pendant 2-3 j (hiérarchie à rétablir) | État bien-être |
| 4 | 📊 Gestion simplifiée | 1 lot au lieu de 2 → 1 ration, 1 distribution | Logistique |

**Différences N/E** :
- **Normal** : groupage libre, pas de conséquence.
- **Expert** : mélanger des animaux de stades différents = ration inadaptée pour certains. Stress hiérarchique (−3% production pendant 3 j). Recommandation : ne grouper que des animaux de même stade physiologique.

---

### 2.27 — Séparer lots

**Déclencheur** : joueur crée un sous-lot à partir d'un lot existant (ex : lot « hautes productrices »)
**Catégorie** : Élevage > Logistique

| Élément | Détail |
|---------|--------|
| Prérequis | Lot existant + critères de séparation définis + place dans un 2e bâtiment/zone |
| Matériel | Barrières de séparation dans le bâtiment |
| Formule durée | `nb_animaux_triés × 3 min + 10 min (mise en place barrières)` |
| Exemple | Séparer 15 vaches hautes productrices : 15 × 3 + 10 = 55 min |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_animaux × 3 min + 10 min` (ex : 55 min) | Pool exploitant |
| 2 | 🐄 Rations différenciées | Possibilité d'attribuer une ration plus riche au lot « hautes prod. » | État alimentation |
| 3 | 🐄 Optimisation | Ration adaptée au stade : +3 à +6% d'efficacité alimentaire | Production |
| 4 | ⏱️ Gestion augmentée | 2 rations à distribuer au lieu d'1 → temps alimentation ×1,5 | Temps quotidien |

**Différences N/E** :
- **Normal** : le joueur peut créer des lots mais la ration reste la même pour tous.
- **Expert** : lots personnalisés avec rations spécifiques (hautes productrices, taries, fraîches vêlées). Indispensable pour optimiser la nutrition (UFL/PDI adaptés au stade).

---

### 2.28 — Transporter (bétaillère)

**Déclencheur** : joueur déplace des animaux vers un lieu externe (abattoir, marché, autre exploitation)
**Catégorie** : Élevage > Logistique

| Élément | Détail |
|---------|--------|
| Prérequis | Tracteur + bétaillère + animaux chargés + destination définie |
| Matériel | Tracteur (80-100 CV) + bétaillère (capacité : 6-8 bovins, 30-40 ovins, 1 cheval) |
| Formule durée | `temps_chargement + (distance_km / 25 km/h) × 2 (A/R) × nb_rotations` |
| Exemple | 30 broutards vers abattoir 20 km, bétaillère 8 places : ⌈30/8⌉ = 4 rotations. 4 × (20/25 × 2) + 4 × 15 min = 6 h 24 + 1 h = 7 h 24 |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Chargement + transport A/R × rotations (ex : 7,4 h pour 30 broutards à 20 km) | Pool exploitant |
| 2 | ⛽ Carburant | `100 CV × 0,22 × 0,45 (charge route) × durée` (ex : 73 L) | Réservoir tracteur (−) |
| 3 | 🔧 Usure tracteur | `+durée` heures | Compteur tracteur |
| 4 | 🔧 Usure bétaillère | `+durée` heures (pneus : vie 2 000 h) | Compteur bétaillère |
| 5 | 🐄 Stress transport | Animaux : stress +15-25 selon durée. Production −5% pendant 3 j post-transport | État bien-être |
| 6 | 🐄 Poids vif (−) | Perte au transport : −2 à −4% du poids vif (déshydratation, stress) | Poids animal |
| 7 | 💰 Coût carburant | `litres × 0,90 €` (ex : 66 €) | Trésorerie |

**Différences N/E** :
- **Normal** : transport simplifié (1 action = animaux livrés). Coût forfaitaire selon distance.
- **Expert** : perte de poids au transport (−2 à −4%). Durée max réglementaire (8 h sans pause). Si > 4 rotations : étalé sur 2 jours. Stress cumulé si transport + changement d'environnement.



---

## 2.D — GÉNÉTIQUE

---

### 2.29 — Génotyper un animal

**Déclencheur** : joueur sélectionne un animal et lance « Génotyper » (Expert uniquement)
**Catégorie** : Élevage > Génétique

| Élément | Détail |
|---------|--------|
| Prérequis | Animal né (dès la naissance) + mode Expert |
| Matériel | Kit de prélèvement (poils ou sang) — envoi laboratoire |
| Formule durée | Prélèvement : `5 min/animal` ; Résultat : `7 jours` (délai labo) |
| Exemple | Génotyper 12 génisses à la naissance : 12 × 5 = 60 min + 7 j d'attente |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 5 min/animal (prélèvement) | Pool exploitant |
| 2 | 💰 Coût | 50 €/animal | Trésorerie |
| 3 | 🐄 Précision index | Avant : 30-40% (estimation parentale) → Après : 70-80% (valeur ADN) | Fiche génétique |
| 4 | 🐄 Index révélé | L'index réel (proche du vrai) est affiché. Permet tri précoce des génisses | Indicateur ISU |
| 5 | 📊 Décision éclairée | Garder les génisses ISU > seuil, vendre les autres (économie 2 ans d'élevage inutile) | Stratégie |
| 6 | 💰 Plus-value vente | Génisse génotypée ISU 120+ : prix ×2-3 vs non génotypée | Valeur marchande |

**Différences N/E** :
- **Normal** : indisponible. Le joueur voit des étoiles (★) basées sur l'estimation parentale.
- **Expert** : accessible dès le début. Rentable si différence valeur garder/vendre > 50 €. Stratégie : génotyper toutes les femelles à la naissance pour tri précoce. Ne pas génotyper les mâles destinés à l'abattoir.

---

### 2.30 — Choisir taureau IA (catalogue CIA)

**Déclencheur** : joueur accède au catalogue CIA pour sélectionner un reproducteur
**Catégorie** : Élevage > Génétique

| Élément | Détail |
|---------|--------|
| Prérequis | Accès au catalogue CIA (toujours disponible) |
| Matériel | Aucun (interface de consultation) |
| Formule durée | `10-30 min` (consultation, comparaison, choix) — pas de temps de jeu consommé |
| Exemple | Choisir un taureau élite dans le catalogue : action instantanée (hors jeu) |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 0 h (action de gestion, pas de temps physique) | — |
| 2 | 📦 Dose réservée | Dose ajoutée au stock de semences du joueur (−prix) | Stock semences (+) |
| 3 | 💰 Achat dose | Standard 18-25 €, Génomique 30-60 €, Élite 50-90 €, Sexée +36 € | Trésorerie |
| 4 | 🐄 Potentiel génétique | Le taureau choisi détermine 50% de l'index du futur veau | Impact futur |
| 5 | ⚠️ Consanguinité | Le jeu affiche l'alerte si ancêtres communs avec le troupeau (F > 6,25%) | Alerte |

**Différences N/E** :
- **Normal** : 3-5 taureaux présentés (« Bon / Très bon / Excellent ») avec recommandation automatique. Étoiles ★.
- **Expert** : catalogue complet (30+ taureaux, renouvellement 30%/mois). Tous les index (ISU, INEL, MO, CEL, FER, LGV). Coefficient consanguinité prédictif. Profils spécialisés (lait pur, fonctionnel, morpho...).

---

### 2.31 — Commander semence sexée

**Déclencheur** : joueur coche « Semence sexée » lors du choix de taureau
**Catégorie** : Élevage > Génétique

| Élément | Détail |
|---------|--------|
| Prérequis | Taureau sélectionné + surcoût accepté |
| Matériel | Dose de semence triée par sexe (stockage azote liquide) |
| Formule durée | Instantané (ajout au stock semences) |
| Exemple | Commander 10 doses sexées Ravalier : 10 × (45 + 36) = 810 € |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 💰 Surcoût | +36 €/dose par rapport à la conventionnelle | Trésorerie |
| 2 | 🐄 Taux réussite IA | −8 points vs conventionnelle (ex : 45% → 37%) | Taux fécondation |
| 3 | 🐄 Sexe du veau | 90% femelles (vs 50% en conventionnel) | Futur veau |
| 4 | 📊 Stratégie optimale | Sur les 30-40% meilleures vaches : maximise les génisses de renouvellement de qualité | Génétique troupeau |
| 5 | 💰 Rentabilité | Veau mâle laitier 60 € vs génisse remplacement 1 200 € → toujours rentable en laitier | ROI |

**Différences N/E** :
- **Normal** : bouton « Semence sexée (+36 €, 90% de femelles) » disponible. Choix simple oui/non.
- **Expert** : stratégie différenciée : sexée sur les meilleures (renouvellement), conventionnelle sur les moyennes, croisement viande (Charolais) sur les réformes (+85 € par veau croisé vs mâle laitier). Éviter sexée sur primipares (taux réussite déjà faible).

---

### 2.32 — Établir plan d'accouplement

**Déclencheur** : joueur accède à l'outil « Plan d'accouplement » (Expert)
**Catégorie** : Élevage > Génétique

| Élément | Détail |
|---------|--------|
| Prérequis | Mode Expert + troupeau > 10 femelles + catalogue CIA consulté |
| Matériel | Aucun (outil de gestion) |
| Formule durée | `30-60 min` de réflexion (pas de temps jeu) |
| Exemple | Plan pour 60 VL : assigner un taureau spécifique à chaque vache selon ses faiblesses |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 0 h (action de gestion, pas de temps physique) | — |
| 2 | 🐄 Accouplements optimisés | Chaque vache reçoit le taureau qui compense ses faiblesses (CEL, MO, FER...) | Plan enregistré |
| 3 | 🐄 Consanguinité évitée | Le plan vérifie F < 6,25% pour chaque croisement proposé | Sécurité génétique |
| 4 | 📊 Gain génétique | Plan raisonné vs aléatoire : +0,5 à +1,0 ISU/an de gain supplémentaire | Progression |
| 5 | 💡 Recommandation auto | L'algorithme propose top 3 taureaux par vache : `score = (ISU_V + ISU_T)/2 − pénalité_F + bonus_complémentarité` | Aide à la décision |

**Différences N/E** :
- **Normal** : le jeu affecte automatiquement le meilleur taureau dans le budget (pas de plan visible).
- **Expert** : interface dédiée. Tableau vache × taureau recommandé × raison. Optimisation manuelle possible. Gain supplémentaire +0,5-1,0 ISU/an vs affectation automatique.

---

### 2.33 — Inscrire au concours IVRAD

**Déclencheur** : joueur inscrit son troupeau au programme IVRAD (annuel)
**Catégorie** : Élevage > Génétique > Concours

| Élément | Détail |
|---------|--------|
| Prérequis | Minimum 10 femelles de la race en production + participation active (5+ naissances/an) |
| Matériel | Aucun (inscription administrative) |
| Formule durée | Instantané (inscription) ; Concours : `2-4 h` (présentation de l'animal, préparation) |
| Exemple | Inscrire 60 VL Holstein au programme IVRAD + présenter 2 vaches au concours trimestriel |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Inscription : 0 ; Concours : 2-4 h/événement (4×/an) | Pool exploitant |
| 2 | 📊 Classement IVRAD | ISU moyen troupeau classé parmi les top N joueurs de la race | Prestige |
| 3 | 💰 Récompenses | Concours mensuel : badge ; Trimestriel : 500-2 000 € ; Annuel : 5 000 € + trophée | Trésorerie |
| 4 | 💰 Prime vente | Place IVRAD obtenue → +5% prix de vente génisses | Valorisation animaux |
| 5 | 🐄 Objectif génétique | OG race : Holstein ISU 112 (An 5), ISU 122 (An 10). Si atteint : bonus permanent | Progression |
| 6 | 📋 Places limitées | 5-30 places/race selon taille serveur (compétition entre joueurs) | Exclusivité |

**Différences N/E** :
- **Normal** : participation automatique. Objectifs simplifiés (« Améliorez vos étoiles ! »). Encouragements visuels.
- **Expert** : OG chiffrés par index. Choix stratégique de l'animal présenté en concours. Classement détaillé permanent. Subventions races rares (+200-300 €/femelle/an pour races menacées).

---

### 2.34 — Prélever semence (CIA)

**Déclencheur** : joueur possédant un mâle d'élite (ISU > 125, F < 5%) le propose au catalogue CIA du serveur
**Catégorie** : Élevage > Génétique > Valorisation

| Élément | Détail |
|---------|--------|
| Prérequis | Mode Expert + mâle génotypé ISU > 125 + coefficient consanguinité < 5% |
| Matériel | Centre de collecte (envoi de l'animal ou prélèvement sur place si CIA installé) |
| Formule durée | Envoi au centre : `1 journée` (animal absent 7-14 jours) ; Prélèvement local : `2 h` |
| Exemple | Envoyer un taureau ISU 132 au CIA pour 30 jours → production de 50 doses/mois |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 2 h (prélèvement local) ou 1 jour (envoi CIA) | Pool exploitant |
| 2 | 🐄 Animal absent | Si envoi CIA : taureau indisponible 7-14 jours (pas de monte naturelle) | Disponibilité |
| 3 | 📦 Doses produites | 50 doses/mois maximum. Prix fixé par le joueur (15-100 €/dose) | Stock semences serveur |
| 4 | 💰 Commission CIA | −20% sur chaque dose vendue (commission plateforme) | Trésorerie |
| 5 | 💰 Revenu récurrent | Si taureau ISU 132 à 60 €/dose, 30 ventes/mois : 30 × 60 × 0,80 = 1 440 €/mois | Trésorerie (+) |
| 6 | 📊 Visibilité | Le taureau apparaît dans le catalogue CIA de tous les joueurs du serveur | Réputation |

**Différences N/E** :
- **Normal** : indisponible (le joueur est acheteur de doses, pas vendeur).
- **Expert** : disponible si le mâle remplit les critères (ISU > 125, F < 5%, génotypé). Revenu très lucratif si le taureau est de qualité (1 000-3 000 €/mois). Le prix est libre mais le marché régule (trop cher = pas de vente).



---

## 2.E — TRANSFORMATION ANIMALE

---

### 2.35 — Fabrication fromage (fromagerie)

**Déclencheur** : joueur lance « Fabriquer fromage » dans l'atelier de transformation
**Catégorie** : Élevage > Transformation

| Élément | Détail |
|---------|--------|
| Prérequis | Fromagerie installée (45 000 € atelier + 25 000 € cave affinage) + lait disponible en tank + formation hygiène (2 500 €) |
| Matériel | Cuve, moules, presse, cave d'affinage (500 places), égouttoirs |
| Formule durée | Fabrication : `2-4 h/batch` (selon type) ; Affinage : `0-60 jours` (passif) |
| Exemple | 30 crottins (150 L lait) : 2 h fabrication + 10 j affinage |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 2-4 h par batch de fabrication | Pool exploitant |
| 2 | 📦 Lait (−) | Selon recette : Frais 5 L/fromage, Crottin 5 L, Bûche 7 L, Pyramide 6 L, Tomme 12 L | Tank à lait (−) |
| 3 | ⚡ Énergie | Électricité + gaz (chauffage cuve) : 8-15 kWh/batch | Compteur énergie |
| 4 | 🔧 Usure équipement | +durée au compteur cuve/presse | Compteur fromagerie |
| 5 | 🧀 Fromages produits (+) | Nombre = lait_utilisé / rendement_recette | Stock fromages (+) |
| 6 | 🧀 Affinage (timer) | Chaque fromage a un timer d'affinage. Frais = 0 j, Crottin = 10 j, Tomme = 60 j | Cave affinage |
| 7 | ⚠️ Pertes | Taux perte 2-3% (normal). Si hygiène < 80% : +5%. Si T° cave instable : +3% | Fromages perdus |
| 8 | 🏠 Cave affinage | Capacité occupée : +nb_fromages. Si > 500 : surproduction → pertes +10% | État bâtiment |
| 9 | 💰 Valeur produite | Frais 3,50 €, Crottin 5,00 €, Bûche 7,50 €, Pyramide 6,80 €, Tomme 16,00 € | Valeur stock |
| 10 | 💰 Marge / L de lait | Frais 0,70 €/L, Crottin 1,00 €/L, Bûche 1,07 €/L, Pyramide 1,13 €/L, Tomme 1,33 €/L (vs lait brut 0,85 €/L) | Rentabilité |

**Différences N/E** :
- **Normal** : 3 recettes simples (frais, crottin, tomme). Affinage automatique. Vente automatique au prix fixe.
- **Expert** : 5+ recettes avec affinage variable. DLC à gérer (fromages frais : 7 j). Taux de perte variable selon hygiène et T° cave. Canaux de vente multiples (marché fermier : prix max ; GMS : −25% mais volume garanti). Investissement total fromagerie : 90 500 €.

---

### 2.36 — Gavage (canard)

**Déclencheur** : joueur lance « Gaver » sur un lot de canards mulards prêts (14 semaines d'âge)
**Catégorie** : Élevage > Transformation (contenu tardif / GDD-endgame)

| Élément | Détail |
|---------|--------|
| Prérequis | Salle de gavage installée + canards mulards 14 sem. + stock maïs grain + AgriPass actif (contenu premium) |
| Matériel | Salle de gavage (investissement 35 000-50 000 €), embuc/gaveuse, épis de maïs |
| Formule durée | `nb_canards × 2 min × 2 repas/jour × 12 jours` = 24 min/canard sur le cycle (réparti) |
| Exemple | 200 canards : 200 × 2 × 2 = 800 min/jour = 13 h 20/jour ⚠️ → nécessite salarié ou petit lot |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 2 min/canard × 2 repas/jour × 12 jours. Lot 50 canards réaliste : 200 min/jour = 3 h 20/jour | Pool exploitant |
| 2 | 📦 Maïs grain (−) | 300-450 g/repas × 2 × 12 j = 7-10 kg maïs/canard | Stock maïs (−) |
| 3 | 🐄 Prise de poids | Canard : 4,5 kg → 6,0-6,5 kg en 12 jours (+35% de poids) | Poids animal |
| 4 | 🐄 Foie gras | Formation du foie gras : 500-600 g/canard (valeur 35-50 €/kg) | Produit premium |
| 5 | 🔧 Usure gaveuse | +durée au compteur | Compteur matériel |
| 6 | 🐄 Mortalité gavage | 2-4% de mortalité pendant le gavage | Effectif (−) |
| 7 | 💰 Valorisation | Canard gavé entier : 25-40 € vs canard maigre : 8-12 €. Foie seul : 17-30 €/foie | Recette |
| 8 | ⚠️ Bien-être | Score bien-être temporairement réduit (réglementaire : période limitée à 12 j max) | Indicateur |

**Différences N/E** :
- **Normal** : indisponible (pas de gavage en Normal — contenu tardif renvoyé au GDD-endgame).
- **Expert** : disponible avec AgriPass (premium). Saisonnalité forte (Noël = prix ×1,5). Gestion des lots de gavage par bande. Investissement important (50 000 €) mais marge unitaire élevée (15-25 €/canard net).

---

### 2.37 — Mise en couveuse (œufs fécondés)

**Déclencheur** : joueur place des œufs fécondés dans une couveuse pour faire naître des poussins
**Catégorie** : Élevage > Reproduction volaille

| Élément | Détail |
|---------|--------|
| Prérequis | Couveuse installée + œufs fécondés (poules avec coq, ou achat d'œufs fécondés) + électricité |
| Matériel | Couveuse (200-2 000 € selon capacité : 50 à 500 œufs) |
| Formule durée | Mise en couveuse : `15-30 min` (chargement) ; Incubation : `21 jours` (poule), `28 jours` (canard/oie) |
| Exemple | 100 œufs fécondés de poules : 20 min chargement + 21 jours d'incubation |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 15-30 min (chargement) + 5 min/jour (vérification T°/humidité) × 21 j = 1 h 45 au total | Pool exploitant |
| 2 | 📦 Œufs fécondés (−) | −nb_œufs du stock. Coût achat : 0,80-2,00 €/œuf fécondé (selon race) | Stock œufs |
| 3 | ⚡ Électricité | Couveuse : 100-200 W × 24 h × 21 j = 50-100 kWh/cycle | Compteur énergie |
| 4 | 🐣 Éclosion | Taux d'éclosion : 75-85% des œufs fécondés → poussins d'1 jour | Nouveaux animaux |
| 5 | 🐣 Sexe ratio | 50% mâles / 50% femelles (naturel) | Composition lot |
| 6 | 🔧 Usure couveuse | +21 j d'utilisation. Durée vie : 5-10 ans selon qualité | Compteur couveuse |
| 7 | 💰 Économie vs achat | Poussin acheté : 0,45-1,30 € ; Poussin éclos : 0,80-2,00 € (œuf) ÷ 0,80 (taux) = 1,00-2,50 € → plus cher MAIS races rares non disponibles autrement | Comparaison |
| 8 | ⚠️ Risque | T° instable (> ±0,5°C pendant > 2 h) : taux éclosion −20 à −50% | Risque perte |

**Différences N/E** :
- **Normal** : couveuse « automatique » — le joueur charge les œufs, attend 21 jours, récupère les poussins. Pas de risque de T°.
- **Expert** : gestion T° (37,5°C ± 0,5°C) et humidité (55-65%). Retournement 3×/jour (auto ou manuel). Mirage à J7 et J14 (éliminer les non fécondés). Risque de panne couveuse = perte totale du lot.

---

## ANNEXE — Résumé des cascades par catégorie

### Matrice récapitulative — Effets systématiques

| Action | Temps | Carburant | Usure tracteur | Usure outil | Stock (−) | Animal modifié | Bâtiment modifié |
|--------|:-----:|:---------:|:--------------:|:-----------:|:---------:|:--------------:|:----------------:|
| **Nourrir (mélangeuse)** | ✅ | ✅ | ✅ | ✅ mélangeuse | ✅ aliments | ✅ ration | |
| **Nourrir (manuel)** | ✅ | | | | ✅ aliments | ✅ ration | |
| **Abreuver** | ✅ | | | | ✅ eau | ✅ hydratation | |
| **Traire (salle)** | ✅ | | | ✅ salle traite | | ✅ production | ✅ tank (+lait) |
| **Traire (robot)** | ✅ (réduit) | | | ✅ robot | ✅ concentré | ✅ production +10% | ✅ tank (+lait) |
| **Ramasser œufs** | ✅ | | | ✅ robot/tapis | | | ✅ stock œufs (+) |
| **Pailler** | ✅ | ✅ | ✅ | ✅ pailleuse | ✅ paille | ✅ confort | ✅ litière |
| **Curer fumier** | ✅ | ✅ | ✅ | ✅ godet | | | ✅ fosse (+fumier) |
| **Surveiller** | ✅ | | | | | ✅ détection | |
| **Inséminer** | ✅ | | | | ✅ dose IA | ✅ gestation | |
| **Détecter chaleurs** | ✅ | | | | | ✅ repro | |
| **Contrôle gestation** | ✅ | | | | | ✅ statut | |
| **Vêlage/mise-bas** | ✅ | | | | | ✅ naissance | ✅ box occupé |
| **Sevrer** | ✅ | | | | | ✅ alimentation | ✅ lot changé |
| **Tarir** | ✅ | | | | ✅ traitement | ✅ production=0 | |
| **Vacciner** | ✅ | | | | ✅ vaccins | ✅ santé | |
| **Soigner** | ✅ | | | | ✅ médicaments | ✅ santé + | |
| **Vermifuger** | ✅ | | | | ✅ anthelminthique | ✅ parasitisme − | |
| **Parage/tonte** | ✅ | | | | | ✅ prévention | |
| **Débourrage** | ✅ | | | ✅ manège | | ✅ valeur + | |
| **Acheter animaux** | ✅ | ✅ (transport) | ✅ | ✅ bétaillère | | ✅ +effectif | ✅ −place |
| **Vendre animaux** | ✅ | ✅ (transport) | ✅ | ✅ bétaillère | | ✅ −effectif | ✅ +place |
| **Réformer** | ✅ | | | | | ✅ statut | ✅ +place |
| **Déplacer** | ✅ | | | | | ✅ localisation | ✅ capacité |
| **Pâturage/rentrer** | ✅ | | | | | ✅ alimentation | ✅ libéré/occupé |
| **Grouper lots** | ✅ | | | | | ✅ stress | |
| **Séparer lots** | ✅ | | | | | ✅ optimisation | |
| **Transporter** | ✅ | ✅ | ✅ | ✅ bétaillère | | ✅ stress | |
| **Génotyper** | ✅ | | | | | ✅ index précisé | |
| **Choisir taureau** | | | | | ✅ dose achetée | | |
| **Semence sexée** | | | | | ✅ dose achetée | ✅ 90% femelles | |
| **Plan accouplement** | | | | | | ✅ optimisé | |
| **Concours IVRAD** | ✅ | | | | | ✅ classement | |
| **Prélever semence** | ✅ | | | | | ✅ mâle absent | |
| **Fromage** | ✅ | | | ✅ fromagerie | ✅ lait | | ✅ cave (+fromages) |
| **Gavage** | ✅ | | | ✅ gaveuse | ✅ maïs | ✅ foie gras | |
| **Couveuse** | ✅ | | | ✅ couveuse | ✅ œufs fécondés | ✅ +poussins | |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale — catalogue complet §2 Élevage (37 actions) | Couverture exhaustive des actions d'élevage toutes espèces |

# ACTIONS-CATALOGUE — Partie 3 : Matériel, Économie, Métiers, Social, Transformation

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : ADR-006, GDD-materiel, GDD-batiments-stockage, GDD-economie-base, GDD-marche, GDD-social-multijoueur, GDD-metiers-eta-concession, GDD-cooperatives-car, GDD-transformation, GDD-core-temporalite

---

## §3. MATÉRIEL & BÂTIMENTS

---

### 3.01 — Acheter matériel neuf

**Déclencheur** : Joueur sélectionne un matériel neuf dans le catalogue concession (PNJ ou joueur)
**Catégorie** : Investissement — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante (comptant) OU capacité d'emprunt (si financement) |
| Acteur | Joueur |
| Cible | Parc matériel du joueur |
| Durée | Instantané (livraison immédiate) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | prix_catalogue (ex : 132 000 € tracteur 155 CV) | Solde joueur |
| 2 | Ajout matériel au parc | Compteur heures = 0, état = neuf, garantie 2 ans | Inventaire matériel |
| 3 | Garantie constructeur | 0 panne pendant 2 ans (Normal + Expert) | État matériel |
| 4 | Commission concessionnaire joueur | prix_catalogue × taux_marge (5-12% selon pts licence) | Solde concessionnaire |
| 5 | Reversement constructeur | 3% du CA réalisé sur la marque (annuel) | Charge concessionnaire |
| 6 | Mise à jour argus | valeur_argus = prix_neuf × 0,80 (année 1) | Fiche matériel |

---

### 3.02 — Acheter matériel occasion

**Déclencheur** : Joueur achète un matériel d'occasion (entre joueurs, concession dépôt-vente, ou enchères Expert)
**Catégorie** : Investissement — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante ; matériel disponible sur le marché |
| Acteur | Joueur acheteur |
| Cible | Parc matériel acheteur |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie acheteur | prix_transaction | Solde acheteur |
| 2 | Crédit trésorerie vendeur | prix_transaction − commission (0-8%) | Solde vendeur |
| 3 | Transfert matériel | Compteur heures conservé, état conservé | Inventaire acheteur |
| 4 | Retrait du parc vendeur | Matériel retiré | Inventaire vendeur |
| 5 | Garantie concession | 6 mois si via concession ; aucune si entre joueurs | État matériel |
| 6 | Argus recalculé | prix_neuf × f_âge × f_heures × f_état | Fiche matériel |
| 7 | Commission dépôt-vente (si concession) | 8% du prix de vente | Solde concessionnaire |

---

### 3.03 — Vendre matériel

**Déclencheur** : Joueur met en vente un matériel de son parc
**Catégorie** : Cession — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Matériel non attelé, non en chantier, non en panne |
| Acteur | Joueur vendeur |
| Cible | Parc matériel, trésorerie |
| Durée | Instantané (reprise concession) ou 1-30 jours (annonce joueurs) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Retrait du parc | Matériel indisponible pour toute action | Inventaire joueur |
| 2 | Crédit trésorerie | Reprise concession : argus × 0,82 ; Annonce joueurs : prix libre ; Casse : 3% prix neuf | Solde joueur |
| 3 | Commission marché | 5% si marché public ; 0% si ami privilégié | Système |
| 4 | Annulation assurance | Prime mensuelle supprimée | Charges récurrentes |
| 5 | Recalcul adéquation parc | Indicateur d'adéquation mis à jour | Dashboard joueur |

---

### 3.04 — Atteler / Dételer outil

**Déclencheur** : Joueur associe un outil à un tracteur (ou le dissocie)
**Catégorie** : Préparation — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Tracteur disponible (pas en panne, pas en chantier) ; outil compatible (CV suffisants : ratio puissance ≥ 0,85) |
| Acteur | Joueur |
| Cible | Attelage tracteur + outil |
| Durée | 15 min (attelage) / 10 min (dételage) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | 0,25 h (atteler) / 0,17 h (dételer) | Pool heures joueur |
| 2 | Verrouillage outil | Outil marqué « attelé à [tracteur_id] » | Disponibilité outil |
| 3 | Vérification puissance | ratio = CV_tracteur / CV_requis_outil ; si < 0,85 → blocage | Validation |
| 4 | Expert : surconsommation | Si ratio 0,85-1,00 → flag surconso +20% sur prochains chantiers | État attelage |

---

### 3.05 — Ravitailler carburant

**Déclencheur** : Joueur remplit le réservoir d'un tracteur/automoteur
**Catégorie** : Consommable — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Cuve de carburant sur l'exploitation (ou achat direct) ; trésorerie suffisante |
| Acteur | Joueur |
| Cible | Réservoir du matériel |
| Durée | 15 min |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | 0,25 h | Pool heures joueur |
| 2 | Remplissage réservoir | litres_ajoutés = capacité_max − litres_actuels | Réservoir matériel |
| 3 | Débit stock cuve | −litres_ajoutés | Stock cuve exploitation |
| 4 | Débit trésorerie (si achat direct) | litres × prix_GNR (0,95 €/L) ou prix_HVC (0,55 €/L) | Solde joueur |
| 5 | Si cuve avec accessoire −8% | Réduction prix si cuve 5 000 L installée : 0,95 × 0,92 = 0,874 €/L | Solde joueur |

---

### 3.06 — Entretenir (vidange, graissage, révision)

**Déclencheur** : Joueur lance un entretien préventif sur un matériel
**Catégorie** : Maintenance — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Matériel non en chantier ; trésorerie suffisante |
| Acteur | Joueur (ou concession joueur/PNJ) |
| Cible | État du matériel |
| Durée | Normal : 2 h ; Expert : variable (0,5-8 h selon échéance) |
| Mode | Normal + Expert |

**Cascade des effets (Mode Normal):**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | 2 h | Pool heures joueur |
| 2 | Débit trésorerie | coût_entretien (ex : 720 € tracteur 215 CV) | Solde joueur |
| 3 | Remise à zéro risque panne | 500 h d'effet sans risque | État matériel |
| 4 | Si fait par concession | Coût majoré (ex : 950 € au lieu de 720 €) ; temps joueur = 0 h | Solde joueur |

**Cascade des effets (Mode Expert — échéances programmées):**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | 250h: 0,5h / 500h: 2h / 1000h: 3h / 2000h: 1 jour (concession) | Pool heures |
| 2 | Débit trésorerie | 250h: 80€ / 500h: 380€ / 1000h: 850€ / 2000h: 2 400€ | Solde joueur |
| 3 | Risque panne remis à 0 | Jusqu'à prochaine échéance | État matériel |
| 4 | Si échéance dépassée > 20% | Risque panne ×3 + usure accélérée ×1,3 | État matériel |

---

### 3.07 — Réparer panne

**Déclencheur** : Panne déclenchée (probabiliste selon usure) ; joueur lance la réparation
**Catégorie** : Urgence — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Matériel en panne ; trésorerie ; pièce disponible (Expert) |
| Acteur | Joueur ou concessionnaire |
| Cible | État du matériel |
| Durée | Normal : 1-2 jours ; Expert : 2h à 3 semaines selon gravité |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Immobilisation matériel | Normal: 1-2 j ; Expert: mineure 2-6h, moyenne 1-2j, majeure 3-7j, critique 1-3 sem. | Disponibilité |
| 2 | Débit trésorerie | Normal: 2-5% valeur matériel ; Expert: 150-35 000€ selon gravité | Solde joueur |
| 3 | Délai pièce (Expert) | Immédiat / 1j / 2-5j / 1-2 sem. selon gravité | Temps réparation |
| 4 | Indemnisation assurance | Si assuré : coût − franchise (300-1 500€ selon formule) | Solde joueur |
| 5 | Perte fenêtre travail (Expert) | Si matériel critique en saison → perte rendement possible | Parcelle/récolte |
| 6 | Consommation temps MO concession | Comp mécanicien : temps = temps_base × (1,5 − comp × 0,05) | Atelier concession |

---

### 3.08 — Changer pièce d'usure

**Déclencheur** : Joueur remplace une pièce usée (socs, disques, buses, courroies, etc.)
**Catégorie** : Maintenance — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Pièce en stock (joueur) ou disponible chez concessionnaire ; matériel non en chantier |
| Acteur | Joueur (ou atelier concession) |
| Cible | Pièce d'usure du matériel |
| Durée | 0,5 h à 6 h selon pièce |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | Socs: 1h / Disques: 1,5h / Dents: 2h / Couteaux: 0,75h / Buses: 0,5h / Courroies: 3h / Batteur: 6h | Pool heures |
| 2 | Débit trésorerie | Socs: 850€ / Disques: 1 200€ / Dents: 950€ / Couteaux: 480€ / Buses: 320€ / Courroies: 1 400€ / Batteur: 3 800€ | Solde joueur |
| 3 | Reset compteur pièce | pièce.heures_restantes = durée_vie_max | Fiche matériel |
| 4 | Restauration performance | Débit machine revient à 100% (si était dégradé −15%) | Performance outil |
| 5 | Délai approvisionnement (Expert) | Stock joueur: 0j / Concessionnaire joueur: 0-1j / PNJ: 1-3j / Commande spéciale: 5-14j | Temps total |

---

### 3.09 — Installer GPS

**Déclencheur** : Joueur installe un système de guidage sur un tracteur
**Catégorie** : Amélioration — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Tracteur compatible ; trésorerie suffisante |
| Acteur | Concession (installation) |
| Cible | Tracteur |
| Durée | Installation par concession (temps joueur = 0 h) |
| Mode | Normal : 1 niveau (RTK) ; Expert : 4 niveaux |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie (achat) | Normal: 18 000€ ; Expert: Barre 3 500€ / DGPS 11 000€ / RTK 22 000€ / RTK+coupure 34 000€ | Solde joueur |
| 2 | Charge annuelle abonnement | Normal: 1 200€/an ; Expert: 0€ (barre) / 400€ / 1 200€ / 1 200€ ; ou balise joueur 700-900€ | Charges récurrentes |
| 3 | Bonus temps de travail | Normal: −12% ; Expert: −5% / −9% / −12% / −12% | Débit de chantier |
| 4 | Bonus économie intrants | Normal: −8% ; Expert: −3% / −5% / −8% / −14% | Consommation semences/phyto |
| 5 | Travail de nuit possible | Oui (toutes versions GPS) | Heures utilisables |
| 6 | Modulation VRA (Expert +6 000€) | +2,5% rendement via dose variable | Rendement parcelles |

---

### 3.10 — Souscrire assurance matériel

**Déclencheur** : Joueur souscrit une assurance bris de machine
**Catégorie** : Gestion — Matériel

| Élément | Détail |
|---------|--------|
| Prérequis | Parc matériel existant ; entretien à jour (condition formule Essentielle/Confort) |
| Acteur | Joueur |
| Cible | Couverture assurance du parc |
| Durée | Instantané (souscription annuelle) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Charge annuelle | Essentielle: 1,2% valeur parc / Confort: 1,8% / Tous risques: 2,5% | Charges récurrentes |
| 2 | Couverture pannes | Essentielle: majeures+critiques / Confort: toutes / Tous risques: + vol/incendie | État assurance |
| 3 | Franchise par sinistre | Essentielle: 1 500€ / Confort: 500€ / Tous risques: 300€ | Déduction indemnisation |
| 4 | Plafond annuel | Essentielle/Confort: 2× prime / Tous risques: 4× prime | Limite couverture |
| 5 | Condition entretien | Si retard entretien > 20% → refus prise en charge | Vérification |

---

### 3.11 — Construire bâtiment

**Déclencheur** : Joueur commande la construction d'un bâtiment
**Catégorie** : Investissement — Bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Surface libre suffisante ; trésorerie ; heures disponibles (2 h) |
| Acteur | Joueur |
| Cible | Ferme (bâtiments) |
| Durée | < 10 bâtiments : instantané ; ≥ 10 : ceil(taille/100) jours (min 1, max 7) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | prix_par_unité × taille × facteur_niveau (Niv1: ×1,0 / Niv2: ×1,5 / Niv3: ×2,2 / Niv4: ×3,0 / Niv5: ×4,0) | Solde joueur |
| 2 | Consommation temps | 2 h | Pool heures joueur |
| 3 | Consommation surface | taille m² de terrain libre | Surface disponible |
| 4 | Création bâtiment | Usure = 0%, capacité = taille × facteur_niveau_capacité | Inventaire bâtiments |
| 5 | Charge énergie quotidienne | base_kWh × taille × f_remplissage × f_niveau × 0,08 €/kWh | Charges récurrentes |
| 6 | Délai de construction | Si ≥ 10 bât : ceil(taille/100) jours | Disponibilité bâtiment |

---

### 3.12 — Agrandir bâtiment

**Déclencheur** : Joueur agrandit un bâtiment existant
**Catégorie** : Investissement — Bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Bâtiment VIDE (aucun stock/animal) ; taille résultante ≤ max du type ; surface libre |
| Acteur | Joueur |
| Cible | Bâtiment existant |
| Durée | 2 h de travail |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | prix_par_unité × taille_ajoutée × facteur_niveau | Solde joueur |
| 2 | Consommation temps | 2 h | Pool heures joueur |
| 3 | Consommation surface | taille_ajoutée m² | Surface disponible |
| 4 | Mise à jour capacité | nouvelle_capacité = ancienne + taille_ajoutée × facteur_niveau_capacité | Bâtiment |
| 5 | Conservation usure | L'usure actuelle est conservée (pas de reset) | État bâtiment |

---

### 3.13 — Améliorer niveau bâtiment

**Déclencheur** : Joueur monte le niveau d'un bâtiment (isolation, automatisation, etc.)
**Catégorie** : Investissement — Bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Bâtiment VIDE ; trésorerie suffisante |
| Acteur | Joueur |
| Cible | Bâtiment existant |
| Durée | 2 h |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | prix_par_unité × taille × (facteur_nouveau_niveau − facteur_ancien_niveau) | Solde joueur |
| 2 | Consommation temps | 2 h | Pool heures |
| 3 | Réduction usure quotidienne | facteur_niveau_usure : Niv2 ×0,85 / Niv3 ×0,70 / Niv4 ×0,55 / Niv5 ×0,40 | Taux usure/jour |
| 4 | Réduction consommation énergie | f_niveau énergie : Niv2 ×0,9 / Niv3 ×0,8 / Niv4 ×0,7 / Niv5 ×0,6 | Facture énergie |
| 5 | Bonus capacité (Niv3+) | Niv3: +5% / Niv4: +10% / Niv5: +15% | Capacité effective |

---

### 3.14 — Détruire bâtiment

**Déclencheur** : Joueur démolit un bâtiment
**Catégorie** : Cession — Bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Bâtiment VIDE |
| Acteur | Joueur |
| Cible | Bâtiment, terrain |
| Durée | 2 h |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | 2 h | Pool heures joueur |
| 2 | Suppression bâtiment | Bâtiment retiré de l'inventaire | Inventaire bâtiments |
| 3 | Libération terrain | Surface récupérée pour autre usage | Surface libre |
| 4 | Crédit trésorerie (récupération matériaux) | 10% de la valeur de construction initiale | Solde joueur |
| 5 | Suppression charges | Énergie et entretien du bâtiment supprimés | Charges récurrentes |

---

### 3.15 — Entretenir bâtiment

**Déclencheur** : Joueur lance un entretien sur un bâtiment (mensuel ou annuel)
**Catégorie** : Maintenance — Bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante |
| Acteur | Joueur |
| Cible | État bâtiment |
| Durée | Mensuel : 0,5 h ; Annuel : 2 h |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | Mensuel: 0,5 h / Annuel: 2 h | Pool heures |
| 2 | Débit trésorerie | Mensuel: 2% valeur bâtiment / Annuel: 8% valeur bâtiment | Solde joueur |
| 3 | Réduction usure | Mensuel: usure −15 points / Annuel: usure reset à 5% | État bâtiment |
| 4 | Normal 80%+ : auto-entretien | Si usure atteint 80% en Normal → débit auto (2× coût mensuel) | Solde joueur |
| 5 | Expert : si négligé 60%+ | +50% énergie, panne 2%/jour | Charges + disponibilité |

---

### 3.16 — Installer accessoire bâtiment

**Déclencheur** : Joueur installe un accessoire optionnel dans un bâtiment
**Catégorie** : Amélioration — Bâtiment

| Élément | Détail |
|---------|--------|
| Prérequis | Bâtiment compatible ; trésorerie |
| Acteur | Joueur |
| Cible | Bâtiment |
| Durée | 0,5 h à 3 jours selon accessoire |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | Variable : ex. DAC 8 500€ / Racleur auto 12 000€ / Ventilation silo 8 000€/100t / Pont-bascule 18 000€ | Solde joueur |
| 2 | Consommation temps | Variable : 0,5h/place (cornadis) à 2 jours (pont-bascule) | Pool heures |
| 3 | Activation bonus | DAC: −30 min/jour / Racleur: −45 min/jour / Ventilation: pertes ÷2 / Pédiluve: −40% boiteries | Bâtiment/production |
| 4 | Charge entretien annuelle | 50-1 200 €/an selon accessoire | Charges récurrentes |
| 5 | Expert : panne accessoire | 2%/an de risque, réparation 200-2 000€ | État accessoire |




---

## §4. ÉCONOMIE & MARCHÉ

---

### 4.01 — Vendre au marché (annonce joueurs)

**Déclencheur** : Joueur crée une annonce de vente sur le marché entre joueurs
**Catégorie** : Commerce — Vente

| Élément | Détail |
|---------|--------|
| Prérequis | Stock disponible du produit ; prix dans la fourchette autorisée (Normal: 70-150% prix_final / Expert: 50-200%) |
| Acteur | Joueur vendeur |
| Cible | Marché public |
| Durée | Annonce active 7 jours (renouvelable) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Création annonce | Produit, quantité, prix fixé par le joueur | Marché joueurs |
| 2 | Réservation stock | Quantité mise en annonce marquée « en vente » | Stock joueur |
| 3 | Quand vendu : débit stock | −quantité_vendue | Stock joueur |
| 4 | Quand vendu : crédit trésorerie | prix × quantité × (1 − commission) | Solde vendeur |
| 5 | Commission | Public: 5% / Entre amis: 3% / Amis privilégiés: 0% | Système |
| 6 | Mise à jour réputation | +0,01 point fiabilité par transaction réussie | Score réputation |
| 7 | Offre/demande serveur | volume_vendu_7j ajusté → impact f_offre_demande | Prix marché |

---

### 4.02 — Acheter au marché (annonce joueurs)

**Déclencheur** : Joueur achète un produit sur une annonce d'un autre joueur
**Catégorie** : Commerce — Achat

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante ; capacité de stockage (si céréales/intrants) |
| Acteur | Joueur acheteur |
| Cible | Stock acheteur, trésorerie |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie acheteur | prix × quantité | Solde acheteur |
| 2 | Crédit stock acheteur | +quantité dans le bâtiment de destination | Stock acheteur |
| 3 | Crédit trésorerie vendeur | prix × quantité × (1 − commission) | Solde vendeur |
| 4 | Débit stock vendeur | −quantité | Stock vendeur |
| 5 | Coût transport (si distance > 50 km) | Céréales: 2-8 €/t / Animaux: 0,05-0,20 €/kg selon distance | Solde acheteur |
| 6 | Mise à jour réputation (les deux) | +0,01 fiabilité si transaction aboutie | Scores réputation |

---

### 4.03 — Vendre à la coopérative PNJ

**Déclencheur** : Joueur vend un produit à la coopérative PNJ (toujours disponible)
**Catégorie** : Commerce — Vente

| Élément | Détail |
|---------|--------|
| Prérequis | Stock disponible ; quantité minimum : 1 unité |
| Acteur | Joueur |
| Cible | Trésorerie, stock |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit stock | −quantité vendue | Stock joueur |
| 2 | Crédit trésorerie | prix_final × 0,97 × quantité (−3% vs prix marché) | Solde joueur |
| 3 | Paiement | Immédiat (pas de délai) | Solde joueur |
| 4 | Offre/demande | Vente comptabilisée dans volume_vendu_7j | Prix marché serveur |
| 5 | Normal : conseil affiché | « Le blé monte au printemps, stocker pourrait rapporter +15-25 €/t » | Interface joueur |

---

### 4.04 — Acheter intrants

**Déclencheur** : Joueur achète des intrants (semences, engrais, phytos, aliments)
**Catégorie** : Commerce — Achat

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante ; capacité stockage (entrepôt, local phyto, etc.) |
| Acteur | Joueur |
| Cible | Stock intrants |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | prix_base × quantité × canal (Coop: ×0,92 / Négoce: ×1,00 / CAR: ×0,85) | Solde joueur |
| 2 | Saisonnalité prix | × f_saison intrant (ex: engrais fév-mars ×1,08, été ×0,93) | Prix effectif |
| 3 | Crédit stock | +quantité dans le bâtiment adapté (entrepôt, local phyto) | Stock joueur |
| 4 | Vérification capacité | Si bâtiment plein → achat bloqué | Validation |
| 5 | Si achat groupé CAR | Réduction −15% mais volume minimum requis | Prix effectif |

---

### 4.05 — Emprunter (crédit bancaire)

**Déclencheur** : Joueur contracte un emprunt bancaire
**Catégorie** : Finance — Crédit

| Élément | Détail |
|---------|--------|
| Prérequis | Normal : toujours possible ; Expert : taux endettement < 70% (annuités/EBE < 70%) |
| Acteur | Joueur |
| Cible | Trésorerie, passif |
| Durée | Instantané (déblocage) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Crédit trésorerie | montant_emprunté | Solde joueur |
| 2 | Création dette | Capital restant dû = montant ; taux = 4-4,5% ; durée = 5-20 ans | Passif joueur |
| 3 | Charge mensuelle d'annuité | mensualité = annuité / 12 (prélevée chaque fin de mois de jeu) | Charges récurrentes |
| 4 | Expert : frais de dossier | 0,5% du montant emprunté | Solde joueur |
| 5 | Expert : mise à jour ratios | Taux endettement, annuités/EBE recalculés | Bilan joueur |
| 6 | Si emprunt CAR | Taux 2,5%/saison ; plafond 3× parts sociales ; garantie = parts | Conditions spéciales |

---

### 4.06 — Rembourser par anticipation

**Déclencheur** : Joueur rembourse tout ou partie d'un emprunt avant terme
**Catégorie** : Finance — Crédit

| Élément | Détail |
|---------|--------|
| Prérequis | Emprunt en cours ; trésorerie suffisante |
| Acteur | Joueur |
| Cible | Passif, trésorerie |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | capital_remboursé + pénalité anticipation | Solde joueur |
| 2 | Pénalité (Expert) | 1% du capital restant dû (indemnité de remboursement anticipé) | Coût additionnel |
| 3 | Réduction capital restant | −capital_remboursé | Dette joueur |
| 4 | Recalcul mensualités | Nouvelle mensualité OU durée raccourcie | Charges récurrentes |
| 5 | Mise à jour ratios | Taux endettement amélioré | Bilan joueur |

---

### 4.07 — Payer charges mensuelles

**Déclencheur** : Automatique — chaque fin de mois de jeu (chaque 7 ticks)
**Catégorie** : Finance — Charges

| Élément | Détail |
|---------|--------|
| Prérequis | Aucun (automatique) |
| Acteur | Système (tick mensuel) |
| Cible | Trésorerie joueur |
| Durée | Automatique |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Prélèvement annuités | mensualité_emprunt (capital + intérêts) | Solde joueur |
| 2 | Prélèvement salaires | nb_salariés × salaire_brut × 1,45 (charges patronales) | Solde joueur |
| 3 | Prélèvement énergie | somme(kWh_jour × 30 × 0,08 €) par bâtiment | Solde joueur |
| 4 | Prélèvement fermage | fermage_annuel / 12 (ou annuel en novembre) | Solde joueur |
| 5 | Prélèvement assurances | prime_annuelle / 12 | Solde joueur |
| 6 | Expert : prélèvement MSA trimestriel | charges_sociales_28% / 4 (chaque 3 mois de jeu) | Solde joueur |
| 7 | Si solde insuffisant (Normal) | Alerte ; jamais de blocage (ADR-002) | Notification |
| 8 | Si solde insuffisant (Expert) | Découvert possible → intérêts 6%/an ; si > 3 mois → redressement | Situation financière |

---

### 4.08 — Toucher aides PAC

**Déclencheur** : Automatique — date de versement calendaire (Normal : 15 février ; Expert : échelonné)
**Catégorie** : Finance — Aides

| Élément | Détail |
|---------|--------|
| Prérequis | Exploiter des terres agricoles |
| Acteur | Système |
| Cible | Trésorerie joueur |
| Durée | Automatique |
| Mode | Normal + Expert |

**Cascade des effets (Normal) :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | DPB | surface_totale_ha × 150 €/ha | Solde joueur |
| 2 | Aide couplée bovine allaitante | nb_VA × 150 €/tête (si ≥ 10 VA) | Solde joueur |
| 3 | Aide couplée laitière | nb_VL × 35 €/tête (plafond 60 VL) | Solde joueur |
| 4 | Aide ovine | nb_brebis × 22 €/tête (si ≥ 50) | Solde joueur |
| 5 | Aide caprine | nb_chèvres × 16 €/tête (si ≥ 25) | Solde joueur |
| 6 | Aide bio | surface_bio × 150 €/ha | Solde joueur |

**Cascade des effets (Expert — versements échelonnés) :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Avance DPB (70%) — 16 octobre | surface × 152 €/ha × 0,70 | Solde joueur |
| 2 | Solde DPB (30%) + éco-régime — 15 février | Solde DPB + voie choisie (60-82 €/ha) | Solde joueur |
| 3 | Aides couplées — 15 février | Mêmes que Normal | Solde joueur |
| 4 | ICHN — 15 décembre | surface_fourragère × montant_zone (80-220 €/ha, plafond 50 ha) | Solde joueur |
| 5 | Aide bio — 15 mars | surface_bio × 150 €/ha | Solde joueur |
| 6 | Conditionnalité vérifiée | Si manquement BCAE : pénalité −3 à −5% par condition violée (max −20%) | Montant versé |
| 7 | Contrôle aléatoire | 5% de chance/an ; si non conforme → pénalité doublée | Montant versé |

---

### 4.09 — Acheter parcelle

**Déclencheur** : Joueur achète une parcelle de terre
**Catégorie** : Investissement — Foncier

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle disponible sur le marché foncier ; trésorerie ou capacité d'emprunt |
| Acteur | Joueur |
| Cible | Patrimoine foncier |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | Normal: prix_base_zone × surface (4 000-9 000 €/ha) ; Expert: × f_qualité × f_accessibilité | Solde joueur |
| 2 | Ajout au patrimoine | Parcelle ajoutée à l'exploitation (propriété) | Inventaire parcelles |
| 3 | Charge annuelle taxe foncière (Expert) | surface × 50 €/ha/an | Charges récurrentes |
| 4 | Augmentation surface PAC | Surface éligible DPB augmentée | Calcul aides |
| 5 | Expert : enchères si concurrence | Meilleur prix l'emporte ; priorité si plus petite surface (SAFER) | Système enchères |
| 6 | Mise à jour bilan | Actif immobilisé augmenté | Bilan patrimonial |

---

### 4.10 — Prendre parcelle en fermage

**Déclencheur** : Joueur loue une parcelle (bail)
**Catégorie** : Investissement — Foncier

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle disponible en fermage ; trésorerie pour 1er loyer |
| Acteur | Joueur |
| Cible | Exploitation (surface louée) |
| Durée | Instantané (signature bail) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Signature bail | Normal: résiliable annuellement ; Expert: engagement 9 ans | Contrat foncier |
| 2 | Charge annuelle fermage | Normal: fixe (90-250 €/ha/an selon zone) ; Expert: indexé ±20% sur prix agricoles | Charges récurrentes |
| 3 | Ajout surface exploitable | Parcelle utilisable pour cultures/élevage | Inventaire parcelles |
| 4 | Pas de taxe foncière | Le bailleur paie la TFNB, pas le fermier | — |
| 5 | Surface PAC augmentée | Surface éligible aux aides | Calcul aides |
| 6 | Expert : renouvellement | 85% chance renouvellement à 9 ans ; préavis 18 mois si reprise | Sécurité foncière |
| 7 | Expert : résiliation anticipée | Pénalité = 2 ans de loyer | Coût de sortie |

---

### 4.11 — Vendre parcelle

**Déclencheur** : Joueur vend une parcelle dont il est propriétaire
**Catégorie** : Cession — Foncier

| Élément | Détail |
|---------|--------|
| Prérequis | Être propriétaire ; parcelle non emblavée (ou récolte terminée) ; possession > 2 ans |
| Acteur | Joueur vendeur |
| Cible | Patrimoine, trésorerie |
| Durée | Instantané (vente système) ou 1-30 jours (entre joueurs) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Crédit trésorerie | prix_marché − 10% (frais de vente) ou prix libre entre joueurs | Solde joueur |
| 2 | Retrait parcelle | Parcelle retirée de l'exploitation | Inventaire parcelles |
| 3 | Réduction surface PAC | Surface éligible diminuée | Calcul aides |
| 4 | Suppression taxe foncière | −50 €/ha/an | Charges récurrentes |
| 5 | Expert : droit de préemption fermier | Si parcelle louée : le fermier a priorité d'achat (délai 2 mois) | Processus de vente |
| 6 | Mise à jour bilan | Actif immobilisé diminué | Bilan patrimonial |




---

## §5. MÉTIERS DE SERVICE

---

### 5.01 — Proposer prestation ETA

**Déclencheur** : Joueur prestataire publie une offre de service ETA
**Catégorie** : Métier — ETA

| Élément | Détail |
|---------|--------|
| Prérequis | Posséder le matériel de la prestation ; ancienneté ≥ 30j (Normal) / 60j (Expert) ; Expert: 50 000€ capital |
| Acteur | Joueur prestataire |
| Cible | Marché des prestations |
| Durée | Instantané (publication) ; offre permanente jusqu'à retrait |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Création offre | Prestation + tarif (libre) + zone (1-3 zones) + capacité max ha/campagne + délai | Marché ETA |
| 2 | Vérification matériel | Matériel doit être en état, non en panne | Validation |
| 3 | Affichage benchmark | Tarif moyen serveur + tarif ETA PNJ affichés au joueur | Interface |
| 4 | Expert : capacité max vérifiée | Contrats limités à 90% de la capacité réelle (marge sécurité) | Limite contrats |
| 5 | Expert : coût de revient calculé | Affiché au prestataire (ex : moisson 62 €/ha) | Aide à la décision |

---

### 5.02 — Effectuer prestation ETA

**Déclencheur** : Un client commande une prestation ; le prestataire l'exécute
**Catégorie** : Métier — ETA (exécution)

| Élément | Détail |
|---------|--------|
| Prérequis | Commande validée ; matériel disponible et fonctionnel ; carburant suffisant |
| Acteur | Joueur prestataire |
| Cible | Parcelle du client |
| Durée | Selon débit de chantier du matériel (ex : moisson 6m → 4,8 ha/h) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps prestataire | surface_client / débit_ha_h (ex : 50 ha / 4,8 = 10,4 h) | Pool heures prestataire |
| 2 | Consommation carburant | conso_L/ha × surface (ex : moisson 26 L/ha × 50 = 1 300 L) | Réservoir matériel |
| 3 | Usure matériel prestataire | +heures au compteur tracteur + outil ; pièces d'usure dégradées | État matériel |
| 4 | Effet sur parcelle client | Action agricole exécutée (labour, moisson, etc.) — mêmes effets sol/stock | Parcelle client |
| 5 | Crédit trésorerie prestataire | tarif × surface (ex : 110 €/ha × 50 ha = 5 500 €) | Solde prestataire |
| 6 | Débit trésorerie client | tarif × surface | Solde client |
| 7 | Expert : qualité prestation | f(état_matériel, expérience) → pertes récolte 1,5-4% | Rendement client |
| 8 | Expert : mise à jour réputation | Si délai respecté: +0,3★ ; Si retard: −0,5★ | Score prestataire |
| 9 | Expert : contrat annuel | Si sous contrat : tarif −8%, priorité garantie | Prix effectif |

---

### 5.03 — Ouvrir concession

**Déclencheur** : Joueur crée une concession de matériel agricole
**Catégorie** : Métier — Concessionnaire

| Élément | Détail |
|---------|--------|
| Prérequis | Ancienneté ≥ 90 jours ; capital ≥ 150 000€ (Normal) / 250 000€ (Expert) ; place disponible (1 par zone × marque) |
| Acteur | Joueur |
| Cible | Métier joueur |
| Durée | Instantané (ouverture) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Construction hall | 80 000 € (200 m²) — 8 machines exposables | Solde joueur / bâtiment |
| 2 | Stock pièces initial | 20 000 € minimum | Solde joueur / inventaire |
| 3 | Choix marques (100 pts) | Majeure 30 pts / Moyenne 20 pts / Mineure 10 pts (max 2 marques) | Licences |
| 4 | Exclusivité territoriale | Marques choisies réservées dans la zone | Marché zone |
| 5 | Embauche mécaniciens | 1-3 au démarrage (2 000-3 500 €/mois selon compétence 1-10) | Personnel |
| 6 | Charges récurrentes | Loyer/amort 60 000€/an + salaires + licence 3% CA neuf | Compte de résultat |
| 7 | Accès catalogue constructeur | Achat au prix constructeur (88-95% du catalogue selon pts) | Capacité vente |

---

### 5.04 — Vendre matériel neuf (concessionnaire)

**Déclencheur** : Un client achète un matériel neuf chez le concessionnaire joueur
**Catégorie** : Métier — Concessionnaire (vente)

| Élément | Détail |
|---------|--------|
| Prérequis | Matériel en stock ou commandable ; client présent |
| Acteur | Concessionnaire joueur |
| Cible | Client (joueur acheteur) |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie client | prix_catalogue × (1 − remise_négociée) ex : 171 000 € | Solde client |
| 2 | Marge concessionnaire | prix_catalogue × taux_marge (5-12%) − remise accordée | Résultat concession |
| 3 | Crédit trésorerie concessionnaire | prix_vente − coût_constructeur | Solde concessionnaire |
| 4 | Garantie 2 ans activée | Client couvert 0 panne pendant 2 ans | État matériel client |
| 5 | Transfert matériel | Matériel ajouté au parc client (heures = 0) | Inventaire client |
| 6 | Fidélisation | Client lié : remise pièces 5-15% ; priorité atelier | Relation client |
| 7 | Expert : commission crédit-bail | Si financement : 3-5% du montant pour le concessionnaire | Solde concessionnaire |

---

### 5.05 — Réparer pour un client (concessionnaire)

**Déclencheur** : Un client confie son matériel en panne à l'atelier de la concession
**Catégorie** : Métier — Concessionnaire (atelier)

| Élément | Détail |
|---------|--------|
| Prérequis | Mécanicien disponible ; poste de travail libre ; pièce en stock |
| Acteur | Concessionnaire joueur (via mécanicien employé) |
| Cible | Matériel du client |
| Durée | Variable selon gravité et compétence mécanicien |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Occupation poste atelier | Durée = temps_base × (1,5 − comp_mécanicien × 0,05) | Capacité atelier |
| 2 | Consommation pièces | Coût pièce prélevé du stock concession | Stock pièces |
| 3 | Facturation client (MO) | Normal: 65 €/h ; Expert: 60-90 €/h selon complexité + déplacement 1,20 €/km | Solde client |
| 4 | Facturation client (pièces) | Prix pièce + marge 25-40% | Solde client |
| 5 | Crédit trésorerie concessionnaire | Total facture (MO + pièces) | Solde concessionnaire |
| 6 | Matériel client réparé | Compteur panne remis à 0 ; matériel disponible | État matériel client |
| 7 | Expert : risque re-panne | Comp 1-3: 5% sous 30j / Comp 7-9: 0,5% / Comp 10: 0% | Fiabilité réparation |
| 8 | Marge atelier nette | MO facturée − coût salarial (18-25 €/h) = marge 60-70% | Résultat concession |

---

### 5.06 — Effectuer transport

**Déclencheur** : Un client commande un transport ; le transporteur joueur l'exécute
**Catégorie** : Métier — Transporteur

| Élément | Détail |
|---------|--------|
| Prérequis | Camion + semi disponible et adapté ; chauffeur (Expert) ; carburant |
| Acteur | Joueur transporteur |
| Cible | Marchandise du client |
| Durée | Selon distance et nombre de rotations : (distance_km / 25 km/h) × 2 × nb_rotations + chargement |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation temps | durée totale (ou temps chauffeur si Expert avec employé) | Pool heures |
| 2 | Consommation carburant | distance_km × 2 × nb_rotations × conso_L/100km (28-34 L) / 100 | Réservoir camion |
| 3 | Usure camion + semi | +heures au compteur | État matériel |
| 4 | Transfert stock | Stock départ → stock arrivée (client → coopérative/silo/acheteur) | Stocks |
| 5 | Crédit trésorerie transporteur | tarif × tonnage (ex: céréales 5-18 €/t selon distance) | Solde transporteur |
| 6 | Débit trésorerie client | Même montant | Solde client |
| 7 | Expert : collecte lait programmée | Contrat récurrent : 18-25 €/1000L, tournée tous les 2 jours | Revenu récurrent |
| 8 | Expert : charroi moisson (pic) | 5-8 €/t, 200-500 t/jour, 3-4 semaines/an = jackpot saisonnier | Revenu saisonnier |




---

## §6. SOCIAL & MULTIJOUEUR

---

### 6.01 — Créer coopérative / CAR

**Déclencheur** : Joueur initie la création d'une Coopérative Agricole Régionale
**Catégorie** : Social — Groupement

| Élément | Détail |
|---------|--------|
| Prérequis | 5 joueurs fondateurs minimum ; ancienneté ≥ 30 jours chacun ; capital social ≥ 500 000 € (parts ≥ 50 000 €/fondateur) ; max 3 CAR/région |
| Acteur | Joueur initiateur + 4 co-fondateurs |
| Cible | Serveur (entité CAR créée) |
| Durée | 14 jours max pour réunir les fondateurs |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie chaque fondateur | parts_souscrites × 10 000 €/part (min 3, max 20 parts) | Solde chaque fondateur |
| 2 | Création entité CAR | Nom, région, objet, capital social initial | Serveur |
| 3 | Président provisoire | L'initiateur devient président pour 6 mois | Gouvernance |
| 4 | Infrastructure de base | Silo 5 000 t + magasin approvisionnement créés | Actifs CAR |
| 5 | Services activés | Collecte (prix +5-12%), magasin (intrants −8 à −15%), prêts membres | Avantages membres |
| 6 | Obligation AG à 6 mois | Élection du bureau définitif (Expert) | Calendrier |
| 7 | Normal : PNJ-président | Gestion automatique sans vote | Gouvernance simplifiée |

---

### 6.02 — Rejoindre coop / CAR

**Déclencheur** : Joueur demande l'adhésion à une CAR existante
**Catégorie** : Social — Groupement

| Élément | Détail |
|---------|--------|
| Prérequis | CAR existante avec places ; trésorerie ≥ 30 000 € (3 parts min) |
| Acteur | Joueur candidat |
| Cible | CAR |
| Durée | Normal : instantané ; Expert : vote conseil (72 h) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | parts_souscrites × 10 000 € (min 3 = 30 000 €) | Solde joueur |
| 2 | Ajout au registre membres | 1 voix en AG (indépendant du capital) | Gouvernance CAR |
| 3 | Accès services | Collecte (+5-12% prix), magasin (−8 à −15%), prêts (3× parts à 2,5%/saison) | Avantages |
| 4 | Expert : engagement d'apport | 50-100% de la production doit être livrée à la CAR | Obligation |
| 5 | Expert : pénalité non-livraison | 10% de la valeur non livrée | Risque |
| 6 | Ristourne future | Au prorata du volume livré (5-15 €/t, versée en fin d'exercice) | Revenu additionnel |

---

### 6.03 — Voter (AG / Conseil CAR)

**Déclencheur** : Un vote est ouvert en AG ou au conseil d'administration
**Catégorie** : Social — Gouvernance

| Élément | Détail |
|---------|--------|
| Prérequis | Être membre de la CAR ; vote en cours ; Expert uniquement (Normal = PNJ décide) |
| Acteur | Joueur membre |
| Cible | Décision collective |
| Durée | Conseil : 72 h ; AG : 7 jours |
| Mode | Expert uniquement |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Expression du vote | 1 membre = 1 voix (POUR / CONTRE / ABSTENTION) | Résultat vote |
| 2 | Quorum vérifié | 50% des membres doivent voter (sinon report 7j) | Validité |
| 3 | Majorité calculée | Simple (>50%) ou qualifiée (>66%) selon type de décision | Résultat |
| 4 | Application décision | Investissement lancé / tarifs modifiés / ristourne versée / président élu | Effet sur CAR |
| 5 | Sondage communautaire (hors CAR) | Tout joueur ≥ 30j ancienneté, 2-6 options, durée 3-14j, vote anonyme | Forum/dashboard |

---

### 6.04 — Mentorer un débutant (CFSA)

**Déclencheur** : Joueur vétéran accepte de parrainer un nouveau joueur via le CFSA
**Catégorie** : Social — Mentorat

| Élément | Détail |
|---------|--------|
| Prérequis | Maître : ancienneté ≥ 6 mois, réputation ≥ 60, bénéfice net > 0 sur 3 derniers mois ; Élève : < 14 jours ancienneté |
| Acteur | Maître-exploitant + élève |
| Cible | Relation de mentorat (42 jours) |
| Durée | 42 jours de jeu actif |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Attribution maître-élève | Match géographique + disponibilité | Relation CFSA |
| 2 | Phase 1 (J1-J14) : Cultures | Quiz 5 questions, 80% requis | Validation élève |
| 3 | Phase 2 (J15-J28) : Éco/Élevage | 1ère vente réussie > 5 000 € | Validation élève |
| 4 | Phase 3 (J29-J42) : Spécialisation | Achat matériel/bâtiment > 20 000 € | Validation élève |
| 5 | Récompense élève | 25 000 € aide installation + 4j AgriPass + badge « Diplômé CFSA » | Solde + profil élève |
| 6 | Récompense maître | +50 réputation + badge « Mentor » (après 3 élèves) / « Maître-exploitant » (après 8) | Profil maître |
| 7 | Condition interactions | Min 8 messages échangés sur 42 jours | Validation globale |

---

### 6.05 — Prêter matériel

**Déclencheur** : Joueur prête un matériel à un autre joueur (ami privilégié = gratuit ; autre = location)
**Catégorie** : Social — Entraide

| Élément | Détail |
|---------|--------|
| Prérequis | Matériel disponible (pas en chantier, pas en panne) ; relation avec l'emprunteur |
| Acteur | Joueur prêteur |
| Cible | Matériel → joueur emprunteur |
| Durée | Définie par le prêteur (1 jour à 1 semaine typique) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Transfert temporaire | Matériel disponible chez l'emprunteur pour la durée | Inventaire emprunteur |
| 2 | Indisponibilité prêteur | Matériel marqué « prêté » — inutilisable par le prêteur | Inventaire prêteur |
| 3 | Coût | Ami privilégié : gratuit ; Autre : location standard (1,2-1,8% valeur/jour) | Solde emprunteur |
| 4 | Usure pendant le prêt | Heures ajoutées au compteur du matériel du prêteur | État matériel |
| 5 | Gain réputation prêteur | +5 réputation + 1 point entraide | Score réputation |
| 6 | Bonus entraide privilégié | +50% points entraide si entre amis privilégiés | Score entraide |
| 7 | Limite anti-abus | Max 5 entraides/jour ; même duo max 3/semaine | Système |

---

### 6.06 — Envoyer message

**Déclencheur** : Joueur envoie un message privé ou de groupe
**Catégorie** : Social — Communication

| Élément | Détail |
|---------|--------|
| Prérequis | Destinataire non bloqué ; joueur non muté |
| Acteur | Joueur émetteur |
| Cible | Joueur(s) destinataire(s) |
| Durée | Instantané |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Message délivré | Max 2 000 caractères ; pas de pièces jointes (liens seulement) | Boîte destinataire |
| 2 | Notification | In-game + email (si configuré) | Destinataire |
| 3 | Historique | Conservé 6 mois | Base de données |
| 4 | Discussion de groupe | Max 20 participants, 10 groupes/joueur | Canaux |
| 5 | Filtre automatique | Mots interdits bloqués ; contournement = aggravation | Modération |
| 6 | Inter-serveurs | MP possibles entre serveurs Normal ↔ Expert (même compte) | Portée |

---

### 6.07 — Participer à un concours / événement

**Déclencheur** : Joueur s'inscrit à un événement communautaire (concours, défi individuel/collectif)
**Catégorie** : Social — Événement

| Élément | Détail |
|---------|--------|
| Prérequis | Événement en cours ; conditions spécifiques selon type |
| Acteur | Joueur |
| Cible | Classement événement |
| Durée | 3 à 30 jours selon type |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Inscription | Joueur ajouté au tableau de l'événement | Système événement |
| 2 | Contribution mesurée | Production laitière / rendement / entraide / etc. selon le concours | Classement |
| 3 | Récompense participation | Badge « Participant [événement] » | Profil joueur |
| 4 | Récompense top 10 | Badge spécial + titre temporaire (30 jours) | Profil joueur |
| 5 | Récompense top 1 (ligue) | Badge « Champion [catégorie] » + titre affiché | Profil joueur |
| 6 | Défi collectif atteint (100%) | Bonus économique +5% prix vente pour tout le département pendant 7 jours | Serveur |
| 7 | Contribution minimum | ≥ 1% de l'objectif collectif pour recevoir la récompense | Validation |




---

## §7. TRANSFORMATION

---

### 7.01 — Fabriquer fromage

**Déclencheur** : Joueur lance une production de fromage à partir de lait
**Catégorie** : Transformation — Fromagerie

| Élément | Détail |
|---------|--------|
| Prérequis | Fromagerie construite (30 000-500 000 €) ; stock lait suffisant ; heures disponibles |
| Acteur | Joueur (fermière) ou fromager employé (artisanale/industrielle) |
| Cible | Stock fromage |
| Durée | Normal : 1 action (instantané + affinage auto) ; Expert : 1h30-2h30/jour |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation lait | litres_transformés (ex : 150 L/jour caprin) | Stock lait (−) |
| 2 | Consommation temps | Normal: 1 action ; Expert fermière: 1h30-2h30 ; artisanale: 30 min (supervision) | Pool heures |
| 3 | Production fromage | kg = litres / rendement_type (chèvre frais: 5-6 L/kg ; pâte pressée: 10-12 L/kg) | Stock fromage (+) |
| 4 | Production sous-produits | 0,0375 L crème/L lait ; 0,85 L petit-lait/L transformé | Stock sous-produits |
| 5 | Calcul qualité (Expert) | indice = (6 compétences moyennées) / 6 × 10 (30-100) | Qualité lot |
| 6 | Lancement affinage | Durée selon type : frais 0j / pâte molle 21-42j / tomme 60-120j / pressée 180-720j | Cave affinage |
| 7 | Usure équipement | +heures sur cuve, presse, moules | État équipement fromagerie |
| 8 | Charge énergie | Consommation électrique fromagerie | Facture énergie |
| 9 | Normal : vente auto | Fromage vendu automatiquement au prix fixe (qualité 70) une fois prêt | Solde joueur |
| 10 | Prix de vente | kg × prix_base × coef_qualité (0,7 + indice × 0,006) × coef_AOP (1,0 ou 1,3-3,0) | Revenu |

---

### 7.02 — Affiner fromage

**Déclencheur** : Fromage en cave ; joueur surveille et décide du moment de vente (Expert)
**Catégorie** : Transformation — Fromagerie (affinage)

| Élément | Détail |
|---------|--------|
| Prérequis | Lot de fromage en cave d'affinage ; capacité cave non dépassée |
| Acteur | Joueur / fromager |
| Cible | Lot de fromage en affinage |
| Durée | Continue (jours → mois selon type) |
| Mode | Expert (automatique en Normal) |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Progression qualité | qualité_affinage(jour) = qualité_base + bonus × (jour / durée_optimale) ; bonus = comp_affinage × 2 | Qualité lot |
| 2 | Si jour > durée_optimale × 1,2 | Suraffinage : qualité commence à baisser | Qualité lot |
| 3 | Si jour < durée_optimale × 0,5 | Fromage immature : malus −20% prix | Prix de vente |
| 4 | DLC (Expert) | Après affinage : chèvre 14j / pâte molle 30j / tomme 45j / pressée 60j | Date limite |
| 5 | Perte si DLC dépassée | Fromage perdu (valeur = 0) ; pénalité hygiène si non retiré sous 7j | Stock (−) |
| 6 | Occupation cave | Kg en cave / capacité cave (ex : 500 kg max) | Capacité disponible |
| 7 | Charge énergie cave | Climatisation/humidité maintenue | Facture énergie |
| 8 | AOP : affinage minimum | Comté ≥ 120j / Reblochon ≥ 42j / etc. — non négociable | Certification |

---

### 7.03 — Méthaniser (digesteur)

**Déclencheur** : Joueur alimente le digesteur en substrats (quotidien en Expert ; automatique en Normal)
**Catégorie** : Transformation — Énergie

| Élément | Détail |
|---------|--------|
| Prérequis | Méthaniseur construit (500 000-2 500 000 €) ; substrats disponibles |
| Acteur | Joueur / employé dédié |
| Cible | Production biogaz → électricité + digestat |
| Durée | Normal : automatique (15 min/jour supervision) ; Expert : 30 min/jour (gestion substrats) |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation substrats | Effluents 40-60% + CIVE 15-25% + résidus 5-10% + déchets IAA 10-20% + maïs ≤15% | Stock effluents/cultures (−) |
| 2 | Consommation temps | Normal: 0,25 h/jour ; Expert: 0,5 h/jour | Pool heures |
| 3 | Production électricité | puissance_kW × heures × rendement_moteur (0,38) × 0,20 €/kWh (tarif garanti 15-20 ans) | Crédit trésorerie |
| 4 | Production chaleur | puissance × 0,42 → valorisation séchage/chauffage (20 000-40 000 €/an pour 150 kW) | Économie charges |
| 5 | Production digestat | substrat_total × 0,85 → remplace engrais chimique (économie 30-50 €/ha) | Stock digestat (+) |
| 6 | Charge maintenance | 30 000-50 000 €/an (moteur) + entretien digesteur | Charges récurrentes |
| 7 | Expert : usure mensuelle | 1,5%/mois sans entretien ; 0,5%/mois avec entretien (3 000-5 000 €/mois) | État digesteur |
| 8 | Expert : panne si usure > 80% | Risque = (usure − 80) × 5% ; panne = 0 production 7-21 jours, réparation 15 000-50 000 € | Production arrêtée |
| 9 | Expert : acidification | Si effluents < 40% du mix → rendement biogaz −20% | Production (−) |
| 10 | Expert : amende maïs | Si maïs > 15% du mix → pénalité réglementaire 5 000 €/mois | Solde joueur (−) |

---

### 7.04 — Installer photovoltaïque

**Déclencheur** : Joueur investit dans une installation photovoltaïque
**Catégorie** : Transformation — Énergie

| Élément | Détail |
|---------|--------|
| Prérequis | Bâtiment avec toiture (toiture) ou terrain disponible (au sol) ; trésorerie/emprunt |
| Acteur | Joueur |
| Cible | Production énergie passive |
| Durée | Installation instantanée (jeu) ; production sur 20-30 ans |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Débit trésorerie | Toiture petit: 40 000€ / Grand: 100 000€ / Au sol 1MWc: 700 000-1 000 000€ / Agrivoltaïsme: 200 000€ | Solde joueur |
| 2 | Revenu annuel automatique | puissance_kWc × ensoleillement (1000-1400 h/an) × tarif (0,10-0,13 €/kWh) × (1 − dégradation) | Crédit annuel |
| 3 | Dégradation annuelle | −0,5%/an de rendement | Production (−) |
| 4 | Entretien annuel | 500-1 500 €/an (nettoyage + onduleur) | Charges récurrentes |
| 5 | Remplacement onduleur (Expert) | 10 000-20 000 € à 12-15 ans | Coût ponctuel |
| 6 | Normal : revenu mensuel fixe | investissement / (ROI × 12) pendant 20 ans | Solde joueur |
| 7 | Expert : autoconsommation possible | Réduit facture énergie bâtiments ; surplus vendu | Charges (−) / Revenu |
| 8 | ROI | Toiture: 7-9 ans / Au sol: 8-12 ans | Rentabilité |
| 9 | Temps de travail | 0 min (revenu 100% passif) | — |

---

### 7.05 — Presser huile

**Déclencheur** : Joueur transforme du colza ou tournesol en huile alimentaire / HVC
**Catégorie** : Transformation — Huilerie

| Élément | Détail |
|---------|--------|
| Prérequis | Huilerie construite (30 000-50 000 € individuel ; 800 000 € CAR) ; stock colza/tournesol |
| Acteur | Joueur |
| Cible | Stock huile + tourteau |
| Durée | 30 min/tonne pressée |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation matière première | quantité_tonnes de colza ou tournesol | Stock grains (−) |
| 2 | Consommation temps | 0,5 h × tonnes | Pool heures joueur |
| 3 | Production huile | 1 t colza → 400 L huile (prix 3,50-5,00 €/L) | Stock huile (+) |
| 4 | Production tourteau | 1 t colza → 600 kg tourteau (250-350 €/t, alimentation animale) | Stock tourteau (+) |
| 5 | Production HVC (carburant) | 1 t colza → 350 L HVC (1,20 €/L ou autoconsommation : −40% coût carburant) | Stock HVC (+) |
| 6 | Usure pressoir | +heures sur l'équipement | État huilerie |
| 7 | Multiplicateur valeur | ×2,5-3,5 vs vente colza brut | Revenu total |
| 8 | Si CAR : prix membre | HVC à 0,95 €/L (−21% vs marché) ; tourteau à 300 €/t (−14%) | Prix membres CAR |

---

### 7.06 — Vinifier

**Déclencheur** : Joueur transforme du raisin en vin (vendange → vinification → élevage)
**Catégorie** : Transformation — Viticulture

| Élément | Détail |
|---------|--------|
| Prérequis | Chai/cuverie construit (50 000-200 000 €) ; stock raisin (récolte vendange) ; compétences (Expert) |
| Acteur | Joueur / employé caviste |
| Cible | Stock vin |
| Durée | Vinification : 2-4 semaines ; Élevage : 6-18 mois selon type |
| Mode | Normal + Expert |

**Cascade des effets :**

| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | Consommation raisin | kg_raisin (rendement : 1 kg raisin → 0,65-0,75 L vin) | Stock raisin (−) |
| 2 | Consommation temps | 1 h/hectolitre (vinification) + supervision élevage 15 min/jour | Pool heures |
| 3 | Production moût → vin | Fermentation 2-4 semaines ; rendement = kg_raisin × 0,70 / densité | Stock vin en élevage |
| 4 | Élevage (durée) | Rouge: 12-18 mois / Blanc: 6-12 mois / Rosé: 3-6 mois | Temps immobilisation |
| 5 | Prix de vente | Vin de table: 3-5 €/L / AOC: 8-25 €/L / Grand cru: 30-80 €/L | Valeur stock |
| 6 | Multiplicateur vs raisin brut | ×3-8 selon qualité et appellation | Revenu |
| 7 | Expert : qualité | Dépend du terroir (parcelle), millésime (météo), compétences | Prix final |
| 8 | Usure équipement | Cuve, pressoir, fûts (remplacement fûts tous les 3-5 ans : 600-900 €/fût) | Charges |
| 9 | DLC (Expert) | Vin en bouteille : pas de DLC (se bonifie) ; vin en vrac : 24 mois max | Conservation |
| 10 | Charges annuelles | Énergie chai + entretien + intrants œnologiques | Charges récurrentes |

---

---

## §8. SPÉCIALISATIONS VÉGÉTALES

---

### 8.01 — Planter verger

**Déclencheur** : joueur sélectionne « Planter verger » sur une parcelle nue ou en prairie (surface ≤ 5 ha)
**Catégorie** : Spécialisations végétales > Arboriculture

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle libre ≤ 5 ha ; sol labouré et affiné ; plants disponibles en stock ou commande (8 €/arbre) ; fenêtre plantation : nov–mars (repos végétatif) |
| Matériel | Tracteur fruitier (≤ 80 CV) + tarière ou planteuse mécanique ; filet anti-grêle optionnel (12 000-18 000 €/ha) |
| Formule durée | `surface_ha × densité_arbres/ha × 0,003 h/arbre` (manuel assisté) |
| Exemple | 3 ha pommiers, 1 200 arbres/ha : `3 × 1 200 × 0,003` = **10,8 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `surface × densité × 0,003` (ex : 10,8 h) | Pool heures joueur |
| 2 | 💰 Coût plants | `surface × densité × 8 €/arbre` (ex : 3 × 1 200 × 8 = 28 800 €) | Trésorerie |
| 3 | 💰 Coût palissage + tuteurs | `surface × 3 500 €/ha` (ex : 10 500 €) | Trésorerie |
| 4 | 🌍 Parcelle — état | État → « Verger planté » ; espèce associée ; année_plantation = année en cours | Parcelle.etat |
| 5 | 🌍 Parcelle — rendement | Rendement = 0 pendant 3-8 ans (selon espèce : pommier 4 ans, noyer 8 ans) | Parcelle.rendement |
| 6 | ⛽ Carburant | `75 CV × 0,22 × 0,45 × durée` (ex : 75 × 0,22 × 0,45 × 10,8 = 80 L) | Réservoir tracteur |
| 7 | 🔧 Usure tracteur fruitier | +durée h (ex : +10,8 h sur compteur 8 000 h de vie) | Compteur horaire tracteur |

**Différences N/E** : Normal — choix de l'espèce parmi 11, le reste est automatique, 1 action unique. Expert — choix variétal (précoce/tardif), choix porte-greffe, densité ajustable (800-2 000 arbres/ha), orientation des rangs, mortalité 2%/saison à remplacer.

---

### 8.02 — Tailler (verger/vigne)

**Déclencheur** : joueur sélectionne « Tailler » sur un verger en production ou une vigne (obligatoire annuellement, janv–mars)
**Catégorie** : Spécialisations végétales > Arboriculture / Viticulture

| Élément | Détail |
|---------|--------|
| Prérequis | Verger ou vigne planté(e), en repos végétatif (déc–mars) ; sécateur / prétailleuse |
| Matériel | Verger : MO manuelle (sécateur) ; Vigne : MO manuelle + prétailleuse mécanique (12 000 €, débit 1,5 ha/h) |
| Formule durée | Verger : `surface × 60 h/ha` (MO manuelle) ; Vigne : `surface × 80 h/ha` (MO) + prétaillage mécanique `surface / 1,5 ha/h` |
| Exemple | Verger 3 ha : `3 × 60` = **180 h** ; Vigne 10 ha : `10 × 80` = **800 h** MO + 6,7 h mécanique |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps MO | Verger : 60 h/ha ; Vigne : 80 h/ha (exploitant + salariés à 15 €/h) | Pool heures / salariés |
| 2 | 💰 Coût main-d'œuvre | Verger : `surface × 60 × 15 €` = 900 €/ha ; Vigne : `surface × 80 × 15 €` = 1 200 €/ha | Trésorerie |
| 3 | 🌍 Parcelle — qualité | Taille courte → qualité +10%, rendement −15% ; Taille longue → rendement +10%, qualité −10% (Expert) | Parcelle.qualite / rendement |
| 4 | 🌍 Parcelle — état sanitaire | −30% pression maladie (aération de la frondaison) | Parcelle.pression_maladie |
| 5 | 🔧 Usure prétailleuse (vigne) | +durée h mécanique (lames : durée de vie 2 000 h) | Compteur pièces (lames) |
| 6 | ⚠️ Non-taille | Si non taillé avant débourrement → rendement −25%, alternance aggravée | Parcelle.penalite |

**Différences N/E** : Normal — 1 action « Tailler », résultat automatique (rendement standard). Expert — choix entre taille de formation (jeunes arbres), taille de fructification, taille de rajeunissement (vieux verger) ; pour la vigne : taille courte (Gobelet, Cordon) vs longue (Guyot) impacte rendement et qualité.

---

### 8.03 — Éclaircir (fruits)

**Déclencheur** : joueur sélectionne « Éclaircir » sur un verger au stade jeunes fruits (mai-juin)
**Catégorie** : Spécialisations végétales > Arboriculture

| Élément | Détail |
|---------|--------|
| Prérequis | Verger en production, stade « nouaison » (mai-juin) ; fruits à pépins uniquement (pommier, poirier) |
| Matériel | MO manuelle uniquement (non mécanisable) |
| Formule durée | `surface × 80 h/ha` |
| Exemple | Verger pommiers 3 ha : `3 × 80` = **240 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps MO | `surface × 80 h/ha` (ex : 240 h) | Pool heures / salariés |
| 2 | 💰 Coût main-d'œuvre | `surface × 80 × 15 €/h` (ex : 3 600 €) soit 1 200 €/ha | Trésorerie |
| 3 | 🌍 Calibre fruits | Calibre moyen +20% (gros calibre = prime +30% au prix de vente) | Parcelle.calibre |
| 4 | 🌍 Rendement | −15% en tonnage (moins de fruits, mais plus gros et mieux valorisés) | Parcelle.rendement_t |
| 5 | 🌍 Alternance | Réduit l'alternance biannuelle de 50% (Expert) | Parcelle.alternance |
| 6 | ⚠️ Non-éclaircissage | Si non fait → petits calibres (prix −30%), alternance forte année suivante | Parcelle.calibre_défaut |

**Différences N/E** : Normal — 1 action « Éclaircir », calibre bonus automatique. Expert — choix de l'intensité (léger/moyen/fort), éclaircissage chimique possible (moins cher : 120 €/ha, mais moins précis, interdit en bio), fenêtre serrée (10 jours après floraison).

---

### 8.04 — Vendanger

**Déclencheur** : joueur sélectionne « Vendanger » sur une vigne à maturité (septembre-octobre)
**Catégorie** : Spécialisations végétales > Viticulture

| Élément | Détail |
|---------|--------|
| Prérequis | Vigne en production (≥ 3 ans), raisin à maturité ; vendangeuse mécanique (185 000 €, 2-3 ha/h) OU MO manuelle (150 h/ha) |
| Matériel | Vendangeuse mécanique (185 000 €, 150 CV, 2,5 ha/h) OU MO manuelle (50 vendangeurs pour 10 ha en 5 jours) |
| Formule durée | Mécanique : `surface / 2,5 ha/h` ; Manuelle : `surface × 150 h/ha` |
| Exemple | 10 ha mécanique : `10 / 2,5` = **4 h** ; 10 ha manuelle : **1 500 h** MO |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Mécanique : 4 h (exploitant) ; Manuelle : 1 500 h MO (50 saisonniers × 5 j × 6 h) | Pool heures |
| 2 | 📦 Production raisin | `surface × rendement_hl/ha × 1,3 kg/L` (ex : 10 ha × 50 hl/ha = 500 hl = 65 t de raisin) | Stock raisin |
| 3 | 💰 Coût MO (manuelle) | `surface × 150 h × 15 €/h` = 22 500 € pour 10 ha (2 250 €/ha) | Trésorerie |
| 4 | ⛽ Carburant (mécanique) | `150 CV × 0,22 × 0,70 × durée` (ex : 150 × 0,22 × 0,70 × 4 = 92 L) | Réservoir |
| 5 | 🔧 Usure vendangeuse | +durée h (batteurs : durée de vie 4 000 h) | Compteur pièces |
| 6 | 🌍 Qualité raisin | Manuelle : qualité_base + 5 pts ; Mécanique : qualité_base + 0 pts | Stock.qualite_raisin |
| 7 | ⚠️ Timing | Trop tôt : −10 pts qualité (acidité haute) ; Trop tard : −15 pts qualité (surmaturité/pourriture) | Qualité vin |

**Différences N/E** : Normal — date de vendange suggérée, résultat standard. Expert — choix de la date critique (suivi du rapport sucre/acidité), tri sélectif possible (+10 pts qualité, +50% coût MO), AOC « vendange manuelle » obligatoire pour certaines appellations.

---

### 8.05 — Rogner / Effeuiller (vigne)

**Déclencheur** : joueur sélectionne « Rogner » ou « Effeuiller » sur une vigne entre mai et août
**Catégorie** : Spécialisations végétales > Viticulture

| Élément | Détail |
|---------|--------|
| Prérequis | Vigne en végétation active (mai–août) ; enjambeur + rogneuse (8 500 €, 2 ha/h) ou effeuilleuse (14 000 €, 1,2 ha/h) |
| Matériel | Enjambeur 75 CV (95 000 €) + rogneuse (8 500 €, débit 2 ha/h) ou effeuilleuse (14 000 €, 1,2 ha/h) |
| Formule durée | Rognage : `surface / 2 ha/h` ; Effeuillage : `surface / 1,2 ha/h` |
| Exemple | 10 ha rognage : **5 h** ; 10 ha effeuillage : **8,3 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Rognage : `surface / 2` ; Effeuillage : `surface / 1,2` (ex : 5 h ou 8,3 h) | Pool heures joueur |
| 2 | ⛽ Carburant | `75 CV × 0,22 × 0,55 × durée` (ex rognage : 75 × 0,22 × 0,55 × 5 = 45 L) | Réservoir enjambeur |
| 3 | 🔧 Usure enjambeur | +durée h (compteur vie : 8 000 h) | Compteur horaire enjambeur |
| 4 | 🔧 Usure rogneuse/effeuilleuse | +durée h (lames : durée de vie 2 000 h) | Compteur pièces (lames) |
| 5 | 🌍 Vigne — aération | Effeuillage : −40% pression botrytis/mildiou (zone grappes ventilée) | Parcelle.pression_maladie |
| 6 | 🌍 Qualité | Effeuillage : +5 pts qualité (exposition soleil des grappes) ; Rognage : entretien (pas de bonus qualité) | Parcelle.qualite_raisin |

**Différences N/E** : Normal — 1 action « Entretien vigne » regroupe rognage + effeuillage (résultat auto). Expert — rognage obligatoire 3-4 passages/an (maîtrise végétation) ; effeuillage optionnel mais crucial pour la qualité en AOC ; timing effeuillage important (trop tôt = brûlure raisin).

---

### 8.06 — Planter forêt

**Déclencheur** : joueur sélectionne « Planter forêt » sur une parcelle forestière nue ou un terrain nu
**Catégorie** : Spécialisations végétales > Foresterie

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle forestière 5-50 ha ; terrain préparé (broyage, sous-solage) ; fenêtre plantation : nov–mars ; plants disponibles |
| Matériel | Tracteur (≥ 100 CV) + tarière forestière ; MO pour la plantation manuelle (plants fragiles) |
| Formule durée | `surface × densité × 0,002 h/plant` (plantation assistée) |
| Exemple | 20 ha de Douglas, 1 100 plants/ha : `20 × 1 100 × 0,002` = **44 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `surface × densité × 0,002` (ex : 44 h) | Pool heures joueur/salariés |
| 2 | 💰 Coût plants + MO plantation | `surface × 4 500 €/ha` (plants 2,50 € × 1 100 + préparation terrain + main d'œuvre) | Trésorerie |
| 3 | 🌍 Parcelle — état | État → « Forêt plantée » ; essence associée ; année_plantation | Parcelle.etat |
| 4 | 🌍 Parcelle — cycle | Cycle de production démarré : peuplier 15-20 ans, Douglas 40-60 ans, chêne 120-150 ans | Parcelle.cycle_forestier |
| 5 | 💰 Entretien annuel (5 premières années) | Dégagement 300 €/ha/an × 5 ans = 1 500 €/ha au total | Charges annuelles |
| 6 | ⚠️ Mortalité | 5-10% mortalité la 1ère année → remplacement plants 0,5 €/plant mort | Coût additionnel |

**Différences N/E** : Normal — choix de l'essence parmi 8, plantation instantanée, entretien automatique. Expert — choix de densité (800-3 000 plants/ha), mélange d'essences possible, mortalité variable selon conditions (sol/météo), dégagement manuel obligatoire années 1-5.


---

### 8.07 — Éclaircir forêt

**Déclencheur** : joueur sélectionne « Éclaircie » sur une parcelle forestière âgée de 10-50 ans (selon essence)
**Catégorie** : Spécialisations végétales > Foresterie

| Élément | Détail |
|---------|--------|
| Prérequis | Forêt plantée depuis ≥ 10 ans (résineux) ou ≥ 20 ans (feuillus) ; abatteuse (350 000 €, 15-25 m³/h) ou tronçonneuse (1 500 €, 2-5 m³/h) |
| Matériel | Abatteuse harvester (350 000 €, 220 CV, 20 m³/h) + débusqueur (180 000 €, 15 m³/h) OU tronçonneuse + tracteur forestier |
| Formule durée | Mécanisé : `(surface × volume_m3/ha) / 20 m³/h` abattage + `(surface × volume) / 15 m³/h` débardage ; Manuel : `(surface × volume) / 4 m³/h` |
| Exemple | 20 ha Douglas 30 ans, 60 m³/ha éclaircie mécanisée : abattage `1 200 / 20` = 60 h + débardage `1 200 / 15` = 80 h = **140 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Mécanisé : `volume_total / 20 + volume_total / 15` (ex : 140 h) | Pool heures |
| 2 | ⛽ Carburant abatteuse | `220 CV × 0,22 × 0,75 × heures_abattage` (ex : 220 × 0,22 × 0,75 × 60 = 2 178 L) | Réservoir |
| 3 | ⛽ Carburant débusqueur | `180 CV × 0,22 × 0,70 × heures_débardage` (ex : 180 × 0,22 × 0,70 × 80 = 2 217 L) | Réservoir |
| 4 | 🔧 Usure abatteuse | +60 h (durée de vie : 12 000 h) | Compteur horaire |
| 5 | 🔧 Usure débusqueur | +80 h (durée de vie : 10 000 h) | Compteur horaire |
| 6 | 📦 Production bois | Bois d'industrie : `volume × prix` (ex : 1 200 m³ × 65 €/m³ Douglas industrie = 78 000 €) | Stock bois / vente |
| 7 | 🌍 Peuplement | Densité réduite de 30-40% → arbres restants croissent +25% plus vite | Parcelle.densité |
| 8 | 💰 Coût carburant | `(2 178 + 2 217) × 0,95 €/L` = 4 175 € | Trésorerie |

**Différences N/E** : Normal — 1 action « Éclaircie », bois vendu automatiquement, résultat forfaitaire. Expert — choix des arbres à retirer (diamètre, forme), martelage préalable, qualité du bois variable, marché bois fluctuant.

---

### 8.08 — Abattre / Coupe finale

**Déclencheur** : joueur sélectionne « Coupe finale » sur une forêt mature (peuplier ≥ 18 ans, Douglas ≥ 50 ans, chêne ≥ 120 ans)
**Catégorie** : Spécialisations végétales > Foresterie

| Élément | Détail |
|---------|--------|
| Prérequis | Forêt à maturité (âge ≥ cycle minimal de l'essence) ; abatteuse ou bûcherons ; autorisation de coupe (Expert) |
| Matériel | Abatteuse (350 000 €, 20 m³/h) + porteur forestier (280 000 €, 14 m³/h) OU tronçonneuse (2-5 m³/h) + tracteur treuil |
| Formule durée | Mécanisé : `volume_total / 20` (abattage) + `volume_total / 14` (portage) ; Ex : 150 m³/ha × 20 ha |
| Exemple | 20 ha chêne mature, 150 m³/ha = 3 000 m³ : abattage `3 000/20` = 150 h + portage `3 000/14` = 214 h = **364 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | Abattage + portage (ex : 364 h) | Pool heures |
| 2 | ⛽ Carburant abatteuse | `220 CV × 0,22 × 0,75 × 150 h` = 5 445 L | Réservoir |
| 3 | ⛽ Carburant porteur | `200 CV × 0,22 × 0,70 × 214 h` = 6 590 L | Réservoir |
| 4 | 📦 Production bois d'œuvre | Chêne 120 ans : `3 000 m³ × 300 €/m³` = 900 000 € ; Douglas 50 ans : `2 000 m³ × 80 €/m³` = 160 000 € | Stock bois / Vente |
| 5 | 🔧 Usure abatteuse | +150 h | Compteur (12 000 h vie) |
| 6 | 🔧 Usure porteur | +214 h | Compteur (12 000 h vie) |
| 7 | 🌍 Parcelle — état | État → « Coupe rase » ; nécessite régénération (replantation ou naturelle) | Parcelle.etat |
| 8 | 💰 Coût carburant | `(5 445 + 6 590) × 0,95 €/L` = 11 433 € | Trésorerie |

**Différences N/E** : Normal — 1 action « Récolter bois », revenu forfaitaire basé sur l'essence et l'âge. Expert — qualité du bois variable (nœuds, rectitude), marché du bois d'œuvre fluctuant, coupe progressive possible (pas tout d'un coup), obligation de plan de gestion forestier.

---

### 8.09 — Débarder

**Déclencheur** : joueur sélectionne « Débarder » après abattage pour sortir les grumes de la parcelle vers la route
**Catégorie** : Spécialisations végétales > Foresterie

| Élément | Détail |
|---------|--------|
| Prérequis | Arbres abattus sur parcelle ; débusqueur skidder (180 000 €, 12-20 m³/h) ou porteur forwarder (280 000 €, 10-18 m³/h) |
| Matériel | Skidder 180 CV (180 000 €, 18 L/h, 15 m³/h) OU Forwarder 200 CV (280 000 €, 20 L/h, 14 m³/h charge 14 t) |
| Formule durée | `volume_m3 / débit_m3/h` (ex skidder : volume / 15) |
| Exemple | 800 m³ à débarder (éclaircie 20 ha) avec skidder : `800 / 15` = **53,3 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `volume / débit` (ex : 53,3 h) | Pool heures joueur |
| 2 | ⛽ Carburant | Skidder : `180 CV × 0,22 × 0,70 × durée` (ex : 180 × 0,22 × 0,70 × 53,3 = 1 477 L) | Réservoir |
| 3 | 🔧 Usure skidder/porteur | +durée h (durée de vie : 10 000-12 000 h) | Compteur horaire |
| 4 | 🌍 Parcelle — grumes | Grumes sorties → disponibles sur place de dépôt (bord de route) pour vente | Parcelle.stock_bord_route |
| 5 | 💰 Coût carburant | `1 477 L × 0,95 €/L` = 1 403 € | Trésorerie |
| 6 | ⚠️ Sol forestier | Si sol détrempé → ornières profondes, dégradation sol (Expert : −10% croissance zone impactée) | Parcelle.sol_forestier |

**Différences N/E** : Normal — débardage inclus dans l'action de coupe (automatique). Expert — action séparée, choix du matériel (skidder = moins cher mais abîme plus le sol ; porteur = cher mais préserve le sol), conditions météo impactent la praticabilité (gel = idéal, pluie = ornières).

---

### 8.10 — Planter en serre / tunnel

**Déclencheur** : joueur sélectionne « Planter » dans une serre ou un tunnel plastique
**Catégorie** : Spécialisations végétales > Maraîchage

| Élément | Détail |
|---------|--------|
| Prérequis | Serre/tunnel construit (tunnel plastique 80 000 €/ha, multichapelle 200 000 €/ha, serre verre 500 000 €/ha) ; plants ou semences disponibles ; sol/substrat préparé |
| Matériel | Manuel (motoculteur léger 3 000 €, planteuse manuelle) ; densité : tomate 2,5 plants/m², salade 16 plants/m² |
| Formule durée | `surface_m² × densité × 0,0012 h/plant` (plantation assistée) |
| Exemple | 5 000 m² (0,5 ha) tomate, 2,5 plants/m² = 12 500 plants : `12 500 × 0,0012` = **15 h** |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | `nb_plants × 0,0012 h` (ex : 15 h) | Pool heures joueur/salariés |
| 2 | 💰 Coût plants/semences | Tomate : 0,80 €/plant × 12 500 = 10 000 € ; Salade : 0,05 €/plant × 80 000 = 4 000 €/ha | Trésorerie |
| 3 | 🌍 Serre — état | État → « Plantée » ; culture associée ; date_plantation ; cycle en jours (tomate 150j, salade 45j) | Serre.etat |
| 4 | 🌱 Substrat/terreau | Consommation substrat si hors-sol : 15 L/plant × nb_plants (coût 0,10 €/L) | Stock substrat |
| 5 | 🌍 Occupation serre | Surface occupée mise à jour ; rotation suivante planifiable | Serre.occupation |
| 6 | ⚠️ Succession culturale (Expert) | Si même culture 3× consécutivement → pression maladie +50% | Serre.historique_rotation |

**Différences N/E** : Normal — choix parmi 8 légumes, plantation instantanée, résultat standard. Expert — 15 légumes, choix variétal, gestion des successions culturales, associations possibles (tomate + basilic = −20% ravageurs), planning de plantation échelonné pour étaler la récolte.

---

### 8.11 — Chauffer serre

**Déclencheur** : joueur active ou ajuste le chauffage d'une serre équipée (nov–mars, ou en continu pour production hivernale)
**Catégorie** : Spécialisations végétales > Maraîchage

| Élément | Détail |
|---------|--------|
| Prérequis | Serre équipée d'un système de chauffage : chaudière gaz (80 000 €/ha), chaudière bois (120 000 €/ha), géothermie (250 000 €/ha) ou raccord méthanisation (50 000 €) |
| Matériel | Chaudière + réseau de distribution ; pas de matériel mobile |
| Formule durée | Action instantanée (réglage consigne) ; effet continu tick par tick |
| Exemple | 1 ha serre verre chauffée à 18°C : consommation 450 kWh/m²/an = 4 500 000 kWh/an |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 💰 Coût énergie | `surface_m² × besoin_kWh/m²/an × prix_énergie` — Gaz : 0,08 €/kWh = 360 000 €/ha/an ; Bois : 0,04 €/kWh = 180 000 €/ha/an ; Géothermie : 0,025 €/kWh = 112 500 €/ha/an ; Méthanisation : 0,015 €/kWh = 67 500 €/ha/an | Trésorerie (charges mensuelles) |
| 2 | 🌍 Serre — température | Température maintenue à la consigne (18-22°C jour, 14-18°C nuit) | Serre.temperature |
| 3 | 🌍 Production hivernale | Permet récolte nov–mars : prix de vente ×2,5 à ×4,0 (hors saison) | Serre.calendrier_production |
| 4 | 🌍 Rendement | +20-30% rendement (température optimale constante vs tunnel froid) | Serre.rendement |
| 5 | 🌍 Pression maladie | −50% traitements nécessaires (hygrométrie contrôlée) | Serre.pression_maladie |
| 6 | ⚠️ Panne chauffage (Expert) | Si chaudière en panne en hiver → gel des cultures en 48h → perte totale | Serre.risque_panne |

**Différences N/E** : Normal — chauffage ON/OFF, coût mensuel fixe affiché, résultat automatique. Expert — pilotage fin (consigne jour/nuit, abaissement nocturne = −15-25% coût énergie), panne possible si entretien négligé, choix source d'énergie impacte le coût et la fiabilité.

---

### 8.12 — Récolter légumes (maraîchage)

**Déclencheur** : joueur sélectionne « Récolter » sur une culture maraîchère à maturité (cycle achevé)
**Catégorie** : Spécialisations végétales > Maraîchage

| Élément | Détail |
|---------|--------|
| Prérequis | Culture à maturité (cycle atteint) ; MO disponible (récolte manuelle intensive) ; conditionnement possible |
| Matériel | MO manuelle (cadence : tomate 100 kg/h, salade 200 plants/h, fraise 50 kg/h) ; caisses/palettes |
| Formule durée | `production_kg / cadence_kg/h` (ex tomate) ou `nb_plants / cadence_plants/h` (ex salade) |
| Exemple | 0,5 ha tomate, rendement 120 t/ha = 60 t : `60 000 kg / 100 kg/h` = **600 h** sur 5 mois |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps MO | `production / cadence` (ex : 600 h répartis sur la saison ; pic juillet : 150 h/mois) | Pool heures / salariés |
| 2 | 📦 Production | Tomate : 80-150 t/ha (sous abri) ; Salade : 30-40 t/ha ; Fraise : 20-35 t/ha | Stock légumes (+) |
| 3 | 💰 Revenu vente | `production × prix_saisonnier` — Tomate pleine saison : 0,80 €/kg ; hors saison : 2,50-3,50 €/kg | Trésorerie |
| 4 | 💰 Coût MO récolte | `heures × 15 €/h` (ex : 600 × 15 = 9 000 € pour 0,5 ha) | Trésorerie |
| 5 | ⚠️ Périssabilité | Tomate : 10 jours ; Salade : 5 jours ; Fraise : 3 jours — au-delà : perte valeur (Normal −10%/j) ou perte totale (Expert) | Stock.DLC |
| 6 | 🌍 Serre — libérée | Si fin de cycle → surface libérée pour rotation suivante | Serre.occupation |

**Différences N/E** : Normal — récolte en 1 action, vente automatique au prix du jour, périssabilité douce (−10%/jour après DLC). Expert — récolte échelonnée (planification hebdo), choix du canal de vente (marché : prix haut/volume bas ; GMS : prix bas/volume garanti ; AMAP : prix fixe/panier), périssabilité stricte (perte totale après DLC), tri par calibre.

---

## §9. GESTION D'EXPLOITATION

---

### 9.01 — Embaucher salarié

**Déclencheur** : joueur sélectionne « Embaucher » dans le menu Gestion > Personnel
**Catégorie** : Gestion d'exploitation > Ressources humaines

| Élément | Détail |
|---------|--------|
| Prérequis | Trésorerie suffisante pour couvrir au moins 3 mois de salaire ; maximum 5 salariés (ADR-004) |
| Matériel | Aucun matériel requis |
| Formule durée | Action administrative instantanée ; salarié disponible dès le tick suivant |
| Exemple | Embauche d'un salarié permanent : +8 h/jour au pool, coût 2 200 €/mois |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Pool heures | +8 h/jour (permanent) ou +8 h/jour sur durée CDD (saisonnier 6 mois) | Capacité journalière |
| 2 | 💰 Charge mensuelle | Permanent : 2 200 €/mois (26 400 €/an) ; Saisonnier 6 mois : 2 417 €/mois (14 500 € total) ; TODE : 2 000 €/mois (12 000 € total) | Trésorerie (−) |
| 3 | 🌍 Exploitation — effectif | Effectif +1 ; capacité journalière = 12 h (exploitant) + nb_salariés × 8 h | Exploitation.effectif |
| 4 | ⚠️ Trésorerie | Si trésorerie < 3 × salaire mensuel au tick → alerte « risque de cessation de paiement » | Alerte financière |
| 5 | 🌍 Efficacité (Expert) | Salarié débutant (0-1 an) : ×0,85 ; confirmé (1-3 ans) : ×1,00 ; expérimenté (3+ ans) : ×1,10 | Salarié.efficacité |

**Différences N/E** : Normal — salariés polyvalents, coût unique 2 200 €/mois, efficacité toujours ×1,00, pas de spécialisation. Expert — choix de spécialisation (élevage : +10% vitesse élevage ; cultures : +10% vitesse parcelle ; polyvalent : pas de bonus), 3 niveaux d'expérience avec progression, turnover possible (départ si conditions mauvaises).

---

### 9.02 — Licencier salarié

**Déclencheur** : joueur sélectionne « Licencier » sur un salarié dans le menu Gestion > Personnel
**Catégorie** : Gestion d'exploitation > Ressources humaines

| Élément | Détail |
|---------|--------|
| Prérequis | Au moins 1 salarié embauché ; respecter le préavis (1 mois Normal, 1-3 mois Expert selon ancienneté) |
| Matériel | Aucun |
| Formule durée | Effet immédiat sur pool heures après la période de préavis |
| Exemple | Licenciement d'un salarié à 2 200 €/mois, ancienneté 2 ans : préavis 2 mois + indemnité |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Pool heures | −8 h/jour (effectif après fin de préavis) | Capacité journalière |
| 2 | 💰 Indemnité de licenciement | Normal : 1 mois de salaire (2 200 €) ; Expert : `ancienneté_années × 0,25 × salaire_mensuel` (ex 2 ans : 1 100 €) | Trésorerie (−) |
| 3 | 💰 Préavis payé | Normal : 1 mois (2 200 €) ; Expert : 1-3 mois selon ancienneté | Trésorerie (−) |
| 4 | 🌍 Exploitation — effectif | Effectif −1 après fin de préavis | Exploitation.effectif |
| 5 | ⚠️ Surcharge | Si heures nécessaires > capacité restante → chantiers en retard, actions impossibles | Alerte capacité |

**Différences N/E** : Normal — licenciement en 1 clic, 1 mois de préavis, indemnité forfaitaire 1 mois. Expert — préavis proportionnel à l'ancienneté (1 mois < 1 an, 2 mois 1-5 ans, 3 mois > 5 ans), indemnité légale calculée, perte de l'expérience accumulée (le remplaçant repart à « débutant »).

---

### 9.03 — Analyse de sol

**Déclencheur** : joueur sélectionne « Analyse de sol » sur une parcelle (max 1 analyse/parcelle/an)
**Catégorie** : Gestion d'exploitation > Diagnostic

| Élément | Détail |
|---------|--------|
| Prérequis | Parcelle non analysée depuis ≥ 1 campagne ; trésorerie ≥ 150 € |
| Matériel | Aucun (prestation laboratoire) |
| Formule durée | 0,5 h (prélèvement terrain) ; résultat immédiat (simplification gameplay) |
| Exemple | Parcelle 30 ha, coût : 150 € ; résultat : pH 6,2, MO 2,1%, P faible, K correct |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | ⏱️ Temps | 0,5 h (prélèvement) | Pool heures joueur |
| 2 | 💰 Coût analyse | 150 €/parcelle (quelle que soit la surface) | Trésorerie |
| 3 | 🌍 Parcelle — données révélées | Normal : jauge fertilité précise (±0% erreur au lieu de ±15%) + conseil d'apport ; Expert : N, P, K, Ca, Mg, S, pH, MO%, structure, RU, CEC | Parcelle.analyse |
| 4 | 🌍 Validité | Données valides 5 campagnes (après = grisées « périmées ») | Parcelle.date_analyse |
| 5 | 💰 Économie potentielle | Ciblage engrais : −10 à −20% de dépenses engrais/ha sur 5 ans (ex : 30 ha × 30 €/ha/an économisés = 4 500 € sur 5 ans) | Optimisation charges |

**Différences N/E** : Normal — analyse = scan qui affiche une jauge fertilité précise et un conseil « apportez X ». Expert — résultat détaillé (tableau chimique complet), le joueur interprète et décide ; sans analyse, aucune donnée sol sauf N estimé par reliquat ; rentabilité toujours positive (150 € → 3 000-5 000 € économisés sur 5 ans).

---

### 9.04 — Drainer une parcelle

**Déclencheur** : joueur sélectionne « Drainer » sur une parcelle argileuse ou limono-argileuse non drainée
**Catégorie** : Gestion d'exploitation > Amélioration structurelle

| Élément | Détail |
|---------|--------|
| Prérequis | Sol argile ou limon-argileux avec engorgement hivernal ; parcelle non déjà drainée ; terrain plat ou légère pente ; trésorerie/emprunt |
| Matériel | Prestation ETA spécialisée (drainière + laser) ; pas de matériel joueur requis |
| Formule durée | Travaux : `surface × 4 h/ha` (prestation, pas d'heures joueur consommées) ; résultat effectif dès la saison suivante |
| Exemple | 30 ha argile : coût 3 000 €/ha × 30 = 90 000 € ; gain annuel espéré : +13 q blé/ha × 220 €/t + 50 €/ha = 336 €/ha/an |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 💰 Coût investissement | `surface × 3 000 €/ha` (ex : 30 ha = 90 000 €, amortissable sur 20 ans = 4 500 €/an) | Trésorerie (−) |
| 2 | 🌍 Sol — engorgement | Supprime les jours d'engorgement hivernal (parcelle praticable plus tôt au printemps : +15-20 jours) | Parcelle.engorgement = false |
| 3 | 🌍 Sol — RU | +30 à +50 mm de réserve utile effective (eau circule au lieu de stagner) | Parcelle.reserve_utile |
| 4 | 🌍 Sol — portance | Portance améliorée → −50% risque de tassement en conditions humides | Parcelle.portance |
| 5 | 🌍 Rendement | +13 q/ha blé (65 → 78 q/ha) ; betterave et maïs deviennent viables sur argile drainée | Parcelle.rendement_potentiel |
| 6 | 💰 Gain annuel | +286 €/ha/an (blé) + 50 €/ha (économie tassement) = 336 €/ha/an ; ROI = 3 000 / 336 = **9 ans** | Rentabilité |

**Différences N/E** : Normal — drainage = investissement 3 000 €/ha, effet immédiat : « qualité terre +1 niveau » (pauvre → moyenne, ou moyenne → bonne). Expert — effet détaillé sur RU, portance, engorgement ; drainage uniquement sur sols adaptés (argile, limon-argileux) ; visualisation du réseau de drains ; ROI calculable par le joueur.

---

### 9.05 — Souscrire assurance récolte

**Déclencheur** : joueur sélectionne « Souscrire assurance » dans le menu Gestion > Assurances (avant le semis ou en début de campagne)
**Catégorie** : Gestion d'exploitation > Gestion du risque

| Élément | Détail |
|---------|--------|
| Prérequis | Culture en place ou prévue ; budget prime disponible ; souscription avant le 31 mars (grandes cultures) ou 30 avril (arbo/vigne) |
| Matériel | Aucun (contrat administratif) |
| Formule durée | Action instantanée (pas de temps consommé) |
| Exemple | Assurance 100 ha de blé, rendement garanti 70 q/ha, prime 45 €/ha : coût 4 500 €, indemnisation si rendement < 70 q/ha |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 💰 Prime annuelle | `surface_assurée × prime_€/ha` — Grandes cultures : 35-55 €/ha ; Arbo : 150-300 €/ha ; Vigne : 80-150 €/ha | Trésorerie (−) |
| 2 | 🌍 Couverture | Rendement garanti = 70-80% du rendement moyen olympique (5 ans, hors min/max) | Contrat.seuil_déclenchement |
| 3 | 💰 Indemnisation (si sinistre) | `(rendement_garanti − rendement_réel) × prix_référence × surface` — Ex : grêle sur verger (perte 80%) → indemnité 35 t/ha × 550 €/t × 5 ha = 96 250 € | Trésorerie (+) si sinistre |
| 4 | ⚠️ Franchise | 25-30% du montant garanti non indemnisé (le joueur assume la 1ère tranche de perte) | Contrat.franchise |
| 5 | 💰 Subvention PAC | 65% de la prime prise en charge par la PAC (coût réel joueur = 35% × prime) — Ex : 45 €/ha × 35% = 15,75 €/ha net | Réduction prime |

**Différences N/E** : Normal — assurance optionnelle, prime forfaitaire 40 €/ha, indemnisation automatique si rendement < 70% de la moyenne. Expert — choix du niveau de couverture (50% à 80% du rendement), franchise modulable (25-50%), assurance par culture ou multirisque climatique, prix de la prime dépend de l'historique de sinistres du joueur.

---

## §10. STRUCTURES COLLECTIVES & STRATÉGIE

---

### 10.01 — Réserver matériel CUMA

**Déclencheur** : joueur sélectionne « Réserver » dans le planning CUMA pour un matériel partagé
**Catégorie** : Structures collectives > CUMA

| Élément | Détail |
|---------|--------|
| Prérequis | Adhérent d'une CUMA (3-20 membres Expert, max 5 Normal) ; parts sociales payées (5-15% valeur matériel) ; créneau disponible dans le planning |
| Matériel | Matériel CUMA cible (moissonneuse, ensileuse, arracheuse, presse, etc.) |
| Formule durée | Action de réservation instantanée ; utilisation = durée normale de l'action avec le matériel réservé |
| Exemple | Réservation moissonneuse CUMA pour 145 ha : créneau 5-6 juillet, coût usage 63 €/ha = 9 135 € |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 💰 Facturation à l'usage | `surface × tarif_CUMA_€/ha` — Moissonneuse : 63 €/ha ; Ensileuse : 55 €/ha ; Presse : 12 €/balle | Trésorerie (−) |
| 2 | 🌍 Planning — créneau bloqué | Dates réservées : matériel indisponible pour les autres membres pendant le créneau | CUMA.planning |
| 3 | 💰 Économie vs ETA | −25 à −40% vs tarif ETA (ex : CUMA 63 €/ha vs ETA 110 €/ha = économie 47 €/ha) | Comparaison coûts |
| 4 | 💰 Économie vs achat seul | −75 à −80% vs possession individuelle (ex : CUMA 9 135 €/an vs achat 50 000 €/an amorti) | Comparaison coûts |
| 5 | ⚠️ Conflit météo (Expert) | Si pluie décale le planning → créneau retardé, risque de moisson tardive (−qualité grain) | Risque planning |
| 6 | ⚠️ Ordre de priorité (Expert) | Rotation annuelle : cette année 3e sur 8, l'an prochain 1er | CUMA.priorité |

**Différences N/E** : Normal — matériel CUMA toujours disponible quand le joueur en a besoin (pas de conflit), coût au prorata. Expert — planning avec conflits réels, ordre de priorité tournant, échange de créneaux entre adhérents (interaction sociale), risque de décalage météo, appel ETA en complément si créneau raté.

---

### 10.02 — Acheter en CUMA (investissement groupé)

**Déclencheur** : joueur propose ou accepte un achat groupé de matériel via la CUMA
**Catégorie** : Structures collectives > CUMA

| Élément | Détail |
|---------|--------|
| Prérequis | Membre d'une CUMA ; accord d'au moins 50%+1 des membres ; financement disponible (parts + emprunt CUMA) |
| Matériel | Tout matériel éligible CUMA (moissonneuse, ensileuse, arracheuse, presse, tonne à lisier, sous-soleuse…) |
| Formule durée | Délai de livraison : 1-4 semaines (jeu) après vote positif |
| Exemple | Moissonneuse Claas 6 m à 380 000 € — 8 adhérents, part joueur 40% = apport 22 800 € (parts sociales) + cotisation annuelle 9 135 €/an |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 💰 Parts sociales | `prix_machine × quote_part × 5-15%` — Ex : 380 000 € × 12% (part joueur sur 1 200 ha) × 10% = 4 560 € (récupérable en quittant) | Trésorerie (−) → actif récupérable |
| 2 | 💰 Cotisation annuelle | `(annuité_emprunt + frais_exploitation) × quote_part` — Ex : (54 000 + 22 000) × 12% = 9 120 €/an | Charges annuelles |
| 3 | 🌍 Parc matériel | Matériel ajouté au parc CUMA (utilisable sur réservation) | CUMA.parc_matériel |
| 4 | 💰 Économie totale vs individuel | −75 à −80% du coût de possession individuelle | Rentabilité |
| 5 | ⚠️ Vote | Normal : accord automatique si trésorerie OK ; Expert : vote majoritaire des membres (peut être refusé) | CUMA.gouvernance |
| 6 | ⚠️ Engagement | Préavis de sortie : 1 an (Expert) ; le joueur ne peut pas revendre sa part immédiatement | CUMA.engagement |

**Différences N/E** : Normal — « Achat en commun » simplifié (max 5 joueurs), chacun paie sa part, matériel toujours disponible, pas de vote. Expert — CUMA formelle (3-20 adhérents), vote majoritaire, parts sociales, cotisation + facturation à l'usage, remboursement des parts en quittant (préavis 1 an), gestion collective du planning.

---

### 10.03 — Convertir en bio

**Déclencheur** : joueur sélectionne « Passer en bio » sur l'exploitation (engagement global) ou sur un îlot de parcelles
**Catégorie** : Structures collectives & Stratégie > Conversion

| Élément | Détail |
|---------|--------|
| Prérequis | Décision stratégique du joueur ; engagement minimum 5 ans (aide conversion) ; aucun produit chimique de synthèse autorisé dès le jour 1 de la conversion |
| Matériel | Matériel de désherbage mécanique obligatoire (herse étrille 6 000 €, bineuse 15 000 €, houe rotative 12 000 €) |
| Formule durée | Timer de conversion : 2 campagnes (C1 + C2) avant certification AB ; 3 ans pour arbo/vigne |
| Exemple | Conversion 80 ha grandes cultures : 2 ans de « vallée de la mort » puis certification AB |

**Cascade des effets :**
| # | Effet | Formule/Valeur | Cible |
|:-:|-------|----------------|-------|
| 1 | 🌍 Exploitation — statut | Statut → « En conversion C1 » puis « C2 » puis « Certifié AB » | Exploitation.statut_bio |
| 2 | 🌍 Rendement (transition) | Année C1 : −15 à −25% ; Année C2 : −25 à −40% ; Certifié : −30 à −40% (stabilisé) | Parcelles.rendement |
| 3 | 💰 Prix de vente | C1-C2 : prix conventionnel (pas de prime) ; Certifié AB : ×1,4 à ×1,8 (blé bio 380 €/t vs 220 €/t conv.) | Prix vente |
| 4 | 💰 Aide conversion PAC | 350 €/ha/an grandes cultures (5 ans) ; 900 €/ha/an arbo (5 ans) | Trésorerie (+) |
| 5 | 💰 Aide maintien PAC | Après conversion : 100 €/ha/an (grandes cultures) ; 450 €/ha/an (arbo) + éco-régime 110 €/ha | Trésorerie (+) |
| 6 | 🌍 Contraintes | Rotation allongée (min 5 cultures + 1 légumineuse) ; désherbage mécanique seul ; fertilisation organique seule ; cuivre ≤ 4 kg/ha/an ; semences bio obligatoires | Exploitation.contraintes_bio |
| 7 | ⚠️ Vallée de la mort | Années C1-C2 : marge potentiellement négative (charges bio + rendement bas + prix conventionnel) | Alerte financière |

**Différences N/E** : Normal — conversion = switch en 2 ans (timer), rendement ×0,65 fixe, prix ×1,60 fixe, pas de gestion adventices. Expert — gestion progressive des adventices (pression cumulative), rendement variable (×0,55 à ×0,75 selon maîtrise), marché bio distinct (offre/demande), échec possible (parcelle envahie = rendement 20%), alternance culturale obligatoire vérifiée.

---

---

## SOMMAIRE GLOBAL

| Section | Actions | Couverture |
|---------|:-------:|------------|
| §1. Cultures — Travaux de parcelle | 26 | Travail du sol, semis, fertilisation, traitements, irrigation, récolte, transport |
| §2. Élevage — Toutes espèces | 37 | Alimentation, traite, reproduction, soins, pâturage, vente animaux |
| §3. Matériel & Bâtiments | 16 | Achat, vente, entretien, réparation, construction, stockage |
| §4. Économie & Marché | 11 | Vente produits, achats intrants, emprunts, subventions, comptabilité |
| §5. Métiers de service | 6 | ETA, transport, négoce, prestation concessionnaire |
| §6. Social & Multijoueur | 7 | Coopérative, échange, entraide, marché joueurs, forum |
| §7. Transformation | 6 | Fromagerie, méthanisation, huilerie, photovoltaïque, vinification |
| §8. Spécialisations végétales | 12 | Arboriculture, viticulture, foresterie, maraîchage sous abri |
| §9. Gestion d'exploitation | 5 | Embauche, licenciement, analyse sol, drainage, assurance |
| §10. Structures collectives & Stratégie | 3 | CUMA réservation, achat groupé, conversion bio |
| **TOTAL** | **129** | **100 %** |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale — Parties §1 à §7 | Catalogue actions matériel, économie, métiers, social, transformation |
| 2026-08-04 | Ajout §8, §9, §10 — 20 actions manquantes | Audit couverture : spécialisations végétales, gestion exploitation, structures collectives |
