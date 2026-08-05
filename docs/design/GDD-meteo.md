> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Système Météo

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `docs/design/GDD-cultures.md` §7, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`, `decisions/ADR-003-expert-nest-pas-plus-rentable.md`

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

La météo est **l'aléa fondamental** de l'agriculture. C'est elle qui crée l'urgence (« il faut moissonner avant la pluie »), l'incertitude (« est-ce que je sème maintenant ou j'attends ? ») et la variabilité d'une année sur l'autre.

Dans Agriva, la météo remplit trois rôles :
1. **Générateur de tension** — le joueur doit réagir, pas seulement planifier
2. **Source de variabilité** — chaque année est différente, pas de routine
3. **Lien entre tous les systèmes** — cultures, élevage, matériel, économie

### 1.2 Philosophie Normal vs Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| Rôle de la météo | **Influence** le rendement (jauges) | **Contraint** les actions (praticabilité) |
| Blocages | Rares et courts (1-2 j) | Fréquents, planification nécessaire |
| Événements extrêmes | Impact modéré, jamais destructeur | Impact sévère, protection stratégique |
| Prévisions | Toujours fiables | Fiabilité décroissante (J+1 à J+7) |
| Pertes possibles | Max -20% rendement | Jusqu'à -90% (grêle non assurée) |
| Ruine possible | **Jamais** (ADR-002) | Non (assurances disponibles, pas de faillite météo) |

### 1.3 Gameplay loop météo

```
QUOTIDIEN
  → Consulter le bulletin météo
  → Décider : travailler aujourd'hui ou attendre ?

HEBDOMADAIRE
  → Prévisions 7 jours : planifier les chantiers
  → Arbitrer : semer maintenant (conditions moyennes) ou risquer d'attendre ?

SAISONNIER
  → Tendance de la saison (sèche/humide)
  → Adapter la stratégie : irriguer, changer de variété, assurer

ANNUEL
  → Bilan climatique de la campagne
  → Comparaison avec les normales → « bonne année » ou « année difficile »
```

### 1.4 Décisions du joueur liées à la météo

| Décision | Quand | Risque | Normal | Expert |
|----------|-------|--------|:------:|:------:|
| Travailler ou attendre ? | Chaque jour de travaux | Pénalité si mauvaises conditions | Rare | Fréquent |
| Moissonner maintenant ou attendre le sec ? | Récolte | Pluie = germination/perte | Signal clair | Arbitrage fin |
| Irriguer ou pas ? | Déficit hydrique | Coût vs gain de rendement | Jauge basse → irriguer | Bilan hydrique + prévisions |
| Assurer ou pas ? | Début campagne | Prime vs risque | Non modélisé | Choix stratégique |
| Quelle variété (précoce/tardive) ? | Semis | Exposition aux aléas | Non | Stratégie climatique |

---

## 2. Modèle de génération météo

### 2.1 Zones climatiques

Agriva utilise **6 zones climatiques** correspondant aux grands types français :

| Zone | Départements types | Caractéristiques |
|------|-------------------|-----------------|
| **Nord-Ouest océanique** | Bretagne, Normandie, Pays de Loire | Doux, humide, peu de gel, peu de canicule |
| **Nord-Est continental** | Alsace, Lorraine, Champagne-Ardenne | Hivers froids, étés chauds, gel fréquent |
| **Bassin parisien** | Île-de-France, Beauce, Picardie | Intermédiaire, climat tempéré équilibré |
| **Sud-Ouest** | Aquitaine, Midi-Pyrénées | Doux, parfois sec en été, orages fréquents |
| **Méditerranéen** | Provence, Languedoc, Corse | Chaud, sec en été, pluies violentes automne |
| **Montagne** | Massif Central, Alpes, Jura, Vosges | Froid, enneigé, saison végétative courte |

### 2.2 Normales climatiques mensuelles — Températures (°C)

#### Températures minimales (°C)

| Mois | Nord-Ouest | Nord-Est | Bassin parisien | Sud-Ouest | Méditerranéen | Montagne |
|------|:----------:|:--------:|:---------------:|:---------:|:-------------:|:--------:|
| Janvier | 3 | -1 | 1 | 2 | 3 | -4 |
| Février | 3 | -1 | 1 | 2 | 4 | -4 |
| Mars | 5 | 2 | 4 | 5 | 6 | -1 |
| Avril | 7 | 5 | 6 | 8 | 9 | 2 |
| Mai | 10 | 9 | 10 | 11 | 13 | 6 |
| Juin | 13 | 12 | 13 | 14 | 17 | 9 |
| Juillet | 14 | 14 | 15 | 16 | 19 | 11 |
| Août | 14 | 13 | 14 | 16 | 19 | 11 |
| Septembre | 12 | 10 | 12 | 13 | 16 | 8 |
| Octobre | 9 | 6 | 8 | 10 | 12 | 4 |
| Novembre | 6 | 2 | 4 | 6 | 7 | 0 |
| Décembre | 4 | 0 | 2 | 3 | 4 | -3 |

#### Températures maximales (°C)

| Mois | Nord-Ouest | Nord-Est | Bassin parisien | Sud-Ouest | Méditerranéen | Montagne |
|------|:----------:|:--------:|:---------------:|:---------:|:-------------:|:--------:|
| Janvier | 9 | 4 | 7 | 10 | 11 | 2 |
| Février | 9 | 6 | 8 | 11 | 12 | 3 |
| Mars | 12 | 11 | 12 | 15 | 15 | 7 |
| Avril | 15 | 15 | 16 | 18 | 18 | 11 |
| Mai | 18 | 20 | 20 | 22 | 23 | 15 |
| Juin | 21 | 23 | 23 | 26 | 28 | 19 |
| Juillet | 23 | 26 | 25 | 28 | 31 | 22 |
| Août | 23 | 25 | 25 | 28 | 31 | 21 |
| Septembre | 20 | 21 | 22 | 25 | 26 | 17 |
| Octobre | 16 | 14 | 16 | 20 | 21 | 12 |
| Novembre | 12 | 8 | 10 | 14 | 15 | 6 |
| Décembre | 9 | 5 | 7 | 10 | 12 | 3 |

### 2.3 Normales climatiques mensuelles — Pluviométrie (mm/mois)

| Mois | Nord-Ouest | Nord-Est | Bassin parisien | Sud-Ouest | Méditerranéen | Montagne |
|------|:----------:|:--------:|:---------------:|:---------:|:-------------:|:--------:|
| Janvier | 80 | 55 | 50 | 70 | 55 | 70 |
| Février | 65 | 50 | 45 | 60 | 45 | 60 |
| Mars | 60 | 50 | 48 | 60 | 40 | 65 |
| Avril | 55 | 50 | 50 | 70 | 45 | 75 |
| Mai | 60 | 65 | 60 | 75 | 40 | 90 |
| Juin | 50 | 70 | 55 | 65 | 25 | 95 |
| Juillet | 45 | 60 | 55 | 45 | 15 | 80 |
| Août | 50 | 55 | 50 | 50 | 30 | 85 |
| Septembre | 60 | 55 | 50 | 65 | 60 | 80 |
| Octobre | 80 | 60 | 55 | 75 | 90 | 90 |
| Novembre | 85 | 60 | 55 | 70 | 75 | 85 |
| Décembre | 85 | 60 | 55 | 75 | 60 | 75 |
| **Total annuel** | **775** | **690** | **628** | **780** | **580** | **950** |

### 2.4 Algorithme de génération

```
ÉTAPE 1 — Tendance annuelle (tirée au 1er janvier)
  tendance_pluie   = random_normal(μ=1.0, σ=0.20)  → 0.6 à 1.4
  tendance_temp    = random_normal(μ=0.0, σ=0.8)   → -2°C à +2°C

  Classification :
    tendance_pluie < 0.75  → "année sèche"  (prob ~11%)
    tendance_pluie > 1.25  → "année humide" (prob ~11%)
    sinon                  → "année normale" (prob ~78%)

ÉTAPE 2 — Génération mensuelle
  pluie_mois = normale_mensuelle × tendance_pluie × random_normal(μ=1.0, σ=0.15)
  temp_moy_mois = normale_mensuelle + tendance_temp + random_normal(μ=0, σ=1.2)

ÉTAPE 3 — Génération quotidienne
  Pour chaque jour du mois :
    temp_max = temp_max_mois + random_normal(μ=0, σ=3.0)
    temp_min = temp_min_mois + random_normal(μ=0, σ=2.5)
    
    // Pluie : modèle markovien (jours de pluie consécutifs)
    prob_pluie = f(zone, mois, pluie_hier)
      Si pluie_hier : prob_pluie × 1.4  (persistance)
      Sinon         : prob_pluie × 0.8
    
    Si pluie :
      quantite_mm = exponentielle(λ = pluie_mois / nb_jours_pluie_attendus)
      Plafond : min(quantite_mm, 80 mm) sauf événement extrême

ÉTAPE 4 — Variables dérivées
  ensoleillement = f(mois, latitude_zone, couverture_nuageuse)
    Base : heures_jour × (1 - 0.7 × couverture_nuageuse)
    couverture_nuageuse = 0.9 si pluie, 0.5 si mitigé, 0.1 si beau

  vent = random_weibull(k=2, λ=base_zone_mois)
    Base Nord-Ouest : 18 km/h (venteux)
    Base Méditerranéen : 14 km/h (mistral ponctuel)
    Base autres : 12 km/h
    Rafales = vent × random_uniform(1.5, 2.5)

  humidite = f(pluie, temperature, zone)
    Après pluie   : 85-95%
    Temps sec été : 40-60%
    Normalement   : 65-80%
```

### 2.5 Nombre de jours de pluie par mois (paramétrage)

| Mois | Nord-Ouest | Nord-Est | Bassin parisien | Sud-Ouest | Méditerranéen | Montagne |
|------|:----------:|:--------:|:---------------:|:---------:|:-------------:|:--------:|
| Janvier | 14 | 11 | 11 | 12 | 7 | 12 |
| Février | 11 | 10 | 10 | 10 | 6 | 10 |
| Mars | 11 | 10 | 10 | 10 | 6 | 11 |
| Avril | 10 | 10 | 9 | 11 | 7 | 12 |
| Mai | 11 | 11 | 10 | 11 | 6 | 13 |
| Juin | 9 | 10 | 9 | 9 | 4 | 12 |
| Juillet | 8 | 9 | 8 | 6 | 2 | 10 |
| Août | 8 | 9 | 7 | 7 | 4 | 10 |
| Septembre | 9 | 9 | 8 | 8 | 5 | 10 |
| Octobre | 13 | 10 | 10 | 10 | 8 | 11 |
| Novembre | 14 | 11 | 11 | 11 | 8 | 12 |
| Décembre | 14 | 12 | 11 | 12 | 7 | 12 |

---

## 3. Variables météo quotidiennes

### 3.1 Liste des variables simulées

| Variable | Unité | Plage | Résolution | Usage principal |
|----------|-------|-------|:----------:|-----------------|
| `temp_min` | °C | -20 à +15 | 0,1 | Gel, degrés-jours |
| `temp_max` | °C | -5 à +42 | 0,1 | Échaudage, THI animaux |
| `pluie` | mm | 0 à 120 | 0,5 | Bilan hydrique, praticabilité |
| `ensoleillement` | h | 0 à 16 | 0,5 | Croissance, fenaison |
| `vent_moyen` | km/h | 0 à 80 | 1 | Pulvérisation, verse |
| `vent_rafale` | km/h | 0 à 150 | 1 | Tempête, dégâts |
| `humidite` | % | 30 à 100 | 1 | Maladie, séchage grain |
| `neige` | cm | 0 à 40 | 1 | Montagne, couverture hivernale |
| `gel_sol` | bool | — | — | Travail du sol impossible |

### 3.2 Affichage selon le mode

**Mode Normal** — informations agrégées, lisibles en un coup d'œil :
- Icône météo du jour (5 niveaux : ☀️ ⛅ 🌥️ 🌧️ ⛈️)
- Température du jour (un seul chiffre arrondi)
- Alerte si blocage (« Trop de pluie pour travailler »)

**Mode Expert** — données brutes complètes :
- Toutes les variables du tableau ci-dessus
- Historique glissant sur 30 jours
- Cumuls par période (depuis semis, depuis dernier traitement)
- Comparaison aux normales

### 3.3 Calcul de la température moyenne journalière

```
temp_moyenne = (temp_max + temp_min) / 2

// Utilisé pour les degrés-jours
degres_jours = max(0, temp_moyenne - seuil_base_culture)

Seuils de base par culture :
  Blé, orge, colza   : 0°C
  Maïs, tournesol    : 6°C
  Betterave           : 3°C
  Prairie             : 0°C
```


---

## 4. Effet sur les cultures

### 4.1 Somme de températures (degrés-jours)

La croissance des cultures est pilotée par l'accumulation de chaleur. Chaque stade phénologique est atteint quand un certain cumul de degrés-jours est dépassé.

**Exemple — Blé tendre d'hiver (base 0°C)**

| Stade | Cumul °Cj depuis semis | Durée indicative |
|-------|:----------------------:|:----------------:|
| Levée | 120 | 10-15 j |
| Tallage | 350 | 30-50 j |
| Épi 1 cm | 750 | fin février |
| 1 nœud | 1 000 | mi-mars |
| Dernière feuille | 1 350 | mi-avril |
| Épiaison | 1 500 | début mai |
| Floraison | 1 600 | mi-mai |
| Grain pâteux | 2 000 | mi-juin |
| Maturité | 2 300 | début juillet |

**Exemple — Maïs grain (base 6°C)**

| Stade | Cumul °Cj depuis semis | Durée indicative |
|-------|:----------------------:|:----------------:|
| Levée | 80 | 8-12 j |
| 6 feuilles | 280 | fin mai |
| 10 feuilles | 500 | mi-juin |
| Floraison mâle | 800 | mi-juillet |
| Fécondation | 850 | fin juillet |
| Grain laiteux | 1 100 | mi-août |
| Grain pâteux | 1 400 | mi-septembre |
| Maturité physio | 1 700 | début octobre |
| Point noir (récolte) | 1 850 | mi-octobre |

**Impact gameplay** : une année fraîche retarde les stades → décale la récolte → risque météo automnal. Une année chaude accélère → fenêtre de récolte précoce.

### 4.2 Bilan hydrique

**Mode Normal — Jauges soleil/pluie (reprise SimAgri)**

```
Chaque parcelle affiche 2 jauges sur 10 segments :

💧 Pluie :  cumul_pluie_cycle / besoin_eau_culture × 10 segments
☀️ Soleil : cumul_soleil_cycle / soleil_reference × 10 segments

Effet sur le rendement :
  Jauge à 5/10 (pile le besoin)  : f_meteo = 1,00
  Jauge à 8/10 (excès modéré)   : f_meteo = 0,95
  Jauge à 3/10 (déficit modéré) : f_meteo = 0,90
  Jauge à 1/10 (déficit sévère) : f_meteo = 0,80
  Jauge à 10/10 (excès majeur)  : f_meteo = 0,85

Fourchette en Normal : f_meteo = 0,80 à 1,10
  → Jamais moins de 80% (ADR-002 : pas de perte définitive)
```

**Mode Expert — Bilan hydrique journalier**

```
reserve_utile_sol = capacite_au_champ - point_fletrissement
  Sol argileux       : 180 mm
  Sol limoneux       : 150 mm
  Sol argilo-calcaire: 120 mm
  Sol sableux        : 80 mm

Chaque jour :
  entrees = pluie_efficace + irrigation
    pluie_efficace = pluie × coef_ruissellement
      coef_ruissellement :
        Sol argileux saturé : 0,60 (40% ruisselle)
        Sol limoneux        : 0,80
        Sol sableux         : 0,95
        Sol sec             : 0,90 (battance)

  sorties = ETc (évapotranspiration de la culture)
    ETc = ET0 × Kc
    ET0 = f(temp_max, ensoleillement, vent, humidite)  // Penman simplifié
    Kc  = coefficient cultural selon le stade :
      Semis-levée      : 0,4
      Tallage          : 0,7
      Montaison        : 1,0
      Épiaison-grain   : 1,15 (période critique)
      Maturation       : 0,6

  reserve = reserve_veille + entrees - sorties
  Si reserve < 0 : stress hydrique → perte de potentiel irréversible

Stress hydrique :
  Seuil de stress = 50% de la réserve utile (RU)
  Si reserve < 50% RU pendant la période critique (floraison-remplissage) :
    perte = 1,5% de potentiel par jour de stress
  Si reserve < 20% RU :
    perte = 3% de potentiel par jour de stress
```

### 4.3 Besoin en eau par culture (mm sur le cycle)

| Culture | Besoin total (mm) | Période critique | Sensibilité sécheresse |
|---------|:-----------------:|:----------------:|:----------------------:|
| Blé tendre | 450 | Mai-juin (épiaison-remplissage) | Moyenne |
| Orge hiver | 400 | Mai (épiaison) | Moyenne |
| Colza | 500 | Avril-mai (floraison) | Moyenne-forte |
| Maïs grain | 550 | Juillet (fécondation) | **Très forte** |
| Tournesol | 400 | Juillet (floraison) | Forte |
| Betterave | 500 | Juin-août (continu) | Forte |
| Prairie | 600 | Avril-septembre (continu) | Moyenne |

### 4.4 Ensoleillement et photosynthèse

```
Mode Normal : intégré dans la jauge soleil, pas de calcul séparé.

Mode Expert :
  rayonnement_intercepte = PAR × couverture_foliaire × durée_jour
  
  Si ensoleillement < 4h/jour pendant 7+ jours consécutifs :
    ralentissement_croissance = -15% accumulation degrés-jours
  
  Si ensoleillement > 12h/jour pendant floraison :
    bonus_fecondation = +3% rendement (meilleures conditions de pollinisation)
```

---

## 5. Effet sur les animaux

### 5.1 Stress thermique — Index THI (Temperature-Humidity Index)

```
THI = 0,8 × temp_max + humidite/100 × (temp_max - 14,4) + 46,4

Seuils (bovins laitiers) :
  THI < 68  : confort     → production lait = référence
  THI 68-72 : stress léger → -5% production lait
  THI 72-78 : stress modéré → -12% production, -15% ingestion
  THI 78-82 : stress sévère → -20% production, risque sanitaire ×2
  THI > 82  : stress critique → -30% production, mortalité possible (Expert)
```

**Mode Normal** : le stress thermique est un malus simple sur la production laitière (max -15%), visible via une icône 🌡️ sur le bâtiment.

**Mode Expert** : le joueur doit investir dans des protections :

| Protection | Coût | Effet |
|-----------|:----:|-------|
| Ventilateurs | 8 000 € (100 vaches) | THI effectif -4 points |
| Brumisation | 12 000 € | THI effectif -6 points |
| Aération bâtiment (conception) | Intégré à la construction | THI effectif -3 points |
| Accès ombre au pâturage | 0 € (arbres existants) | THI effectif -2 points au pré |

### 5.2 Pâturage et pousse de l'herbe

```
pousse_herbe_jour = f(temperature, pluie, ensoleillement, saison)

  Base (kg MS/ha/jour) :
    Janvier-février    : 0-5
    Mars               : 15-30
    Avril              : 40-70  ← pic de printemps
    Mai                : 50-80  ← pic
    Juin               : 30-50
    Juillet-août       : 10-30 (dépend pluie)
    Septembre-octobre  : 20-40 (repousse automnale)
    Novembre-décembre  : 5-15

  Modificateurs :
    temp_moyenne < 5°C    : pousse = 0
    pluie < 2 mm/semaine  : pousse × 0,3 (dormance estivale)
    pluie > 5 mm/semaine  : pousse × 1,2 (bonnes conditions)
    ensoleillement élevé + eau suffisante : pousse × 1,3

  Production annuelle cible (prairie perm.) :
    Nord-Ouest   : 10-12 t MS/ha
    Bassin par.  : 8-10 t MS/ha
    Sud-Ouest    : 7-9 t MS/ha
    Montagne     : 5-7 t MS/ha
    Méditerranéen: 4-6 t MS/ha (sec en été)
```

**Impact gameplay** :
- Printemps humide et doux = beaucoup d'herbe = économie de fourrage
- Été sec = prairie grillée = il faut compléter avec du stock ou acheter du foin
- Le joueur doit anticiper la constitution de stocks au printemps

### 5.3 Conditions de pâturage

| Condition | Effet pâturage |
|-----------|---------------|
| Sol détrempé (pluie > 20 mm/48h) | ❌ Pâturage impossible (piétinement destructeur) |
| Gel au sol | ⚠️ Pâturage possible mais herbe non nutritive |
| Canicule (THI > 78) | ⚠️ Animaux souffrent, rentrée nécessaire (Expert) |
| Neige > 5 cm | ❌ Pâturage impossible |
| Conditions normales | ✅ Pâturage optimal |

### 5.4 Fenaison et météo

```
Conditions pour faire du foin de qualité :
  - Faucher par temps sec
  - 3 jours consécutifs sans pluie après la fauche (séchage au sol)
  - Vent > 8 km/h : séchage accéléré (-0,5 jour)
  
Si pluie pendant le séchage :
  Pluie < 5 mm  : +1 jour de séchage, -10% qualité
  Pluie 5-15 mm : +2 jours, -25% qualité (foin noirci)
  Pluie > 15 mm : foin perdu (moisissures), remettre en andains

Alternative : ensilage d'herbe (1 jour de ressuyage suffit, moins dépendant)
Alternative : enrubannage (2 jours de ressuyage, compromis qualité/sécurité)
```


---

## 6. Fenêtres de travaux

### 6.1 Principe

En Normal, la météo bloque rarement (reprise SimAgri). En Expert, chaque travail a des conditions requises — le joueur doit planifier.

### 6.2 Tableau complet des conditions par travail

| Travail | Pluie du jour | Pluie cumul 7j | Vent | Température | Gel | Humidité |
|---------|:-------------:|:--------------:|:----:|:-----------:|:---:|:--------:|
| **Labour** | < 5 mm | < 40 mm (argile) / < 55 mm (limon) | — | > -5°C | Pas de gel profond | — |
| **Déchaumage** | < 8 mm | < 45 mm | — | — | — | — |
| **Herse rotative** | < 3 mm | < 30 mm | — | — | Pas de gel | — |
| **Semis céréales** | 0 mm | < 30 mm | < 40 km/h | T° sol > 5°C | Pas de gel | — |
| **Semis maïs/tournesol** | 0 mm | < 25 mm | < 30 km/h | T° sol > 10°C | Pas de gel | — |
| **Pulvérisation** | 0 mm | — | **< 19 km/h** | 5°C < T < 25°C | Pas de gel | > 60% |
| **Épandage solide** | < 5 mm | < 35 mm (portance) | < 30 km/h | — | — | — |
| **Épandage liquide** | 0 mm | < 30 mm | < 25 km/h | > 0°C | Pas de gel | — |
| **Récolte céréales** | 0 mm | — | < 50 km/h | — | — | Grain < 16% |
| **Récolte betterave** | < 3 mm | < 40 mm | — | > -3°C | Pas de gel fort | — |
| **Fauche** | 0 mm | — | — | — | — | — |
| **Fenaison (retourner)** | 0 mm | — | — | — | — | — |
| **Pressage** | 0 mm | 0 mm depuis 72h | — | — | — | Foin < 18% |
| **Irrigation** | < 5 mm | — | < 40 km/h (enrouleur) | — | Pas de gel | — |
| **Épandage effluents** | < 3 mm | < 30 mm | < 25 km/h | > 2°C | Pas de gel | — |

### 6.3 Mode Normal — Blocages simplifiés

| Condition | Durée typique | Travaux bloqués | Fréquence |
|-----------|:-------------:|-----------------|:---------:|
| Forte pluie (> 15 mm/j) | 1-2 jours | Tous les travaux de plein champ | 2-4×/mois |
| Vent fort (> 30 km/h) | 1 jour | Pulvérisation uniquement | 2-3×/mois |
| Gel (< -3°C) | Variable (hiver) | Semis, épandage liquide | Hiver seulement |

**Règle ADR-002** : un joueur Normal n'est jamais bloqué plus de 3 jours consécutifs. Si la génération produit 4+ jours bloquants, forcer une amélioration au jour 4.

### 6.4 Mode Expert — Praticabilité fine

```
// Jours disponibles par mois pour travail du sol (argile, Nord-Ouest)
praticabilite_mensuelle :
  Janvier    : 8-12 jours  (sol souvent saturé)
  Février    : 10-14 jours
  Mars       : 14-20 jours ← fenêtre de semis printemps
  Avril      : 16-22 jours
  Mai        : 18-24 jours
  Juin       : 22-28 jours
  Juillet    : 24-28 jours ← récoltes
  Août       : 22-26 jours
  Septembre  : 18-24 jours ← semis automne
  Octobre    : 14-20 jours ← fenêtre serrée colza/blé
  Novembre   : 10-16 jours (sol qui se sature)
  Décembre   : 8-14 jours

→ En sol argileux, les fenêtres d'automne sont critiques.
   Un excès de pluie en octobre peut empêcher de semer le blé à temps.
```

### 6.5 Conséquences du forçage (Expert)

Si le joueur force un travail hors conditions :

| Situation | Pénalité |
|-----------|----------|
| Labour en sol trop humide | Tassement : -5% rendement année suivante, +30% carburant |
| Semis en sol froid (< 5°C) | -15% levée (peuplement insuffisant) |
| Pulvérisation par vent > 19 km/h | -40% efficacité + dérive (amende si zone riverains) |
| Récolte sous la pluie | Humidité grain +3 points → coût séchage, -2 points PS |
| Épandage sur sol gelé | Efficacité 0% (ruissellement au dégel) + risque pollution |

---

## 7. Événements climatiques exceptionnels

### 7.1 Tableau récapitulatif

| Événement | Prob. annuelle | Période | Déclencheur (génération) | Effet rendement | Protection | Coût protection |
|-----------|:--------------:|:-------:|--------------------------|:---------------:|------------|:---------------:|
| **Sécheresse** | 20% | Mai-août | tendance_pluie < 0,70 + 3 sem. sans pluie significative | -15% à -35% | Irrigation | 120-250 €/ha |
| **Excès d'eau** | 18% | Oct-nov ou mai-juin | cumul_30j > 2× normale | Semis impossible ou asphyxie -10 à -20% | Drainage | 2 000 €/ha (investissement) |
| **Gel tardif** | 15% | 1-20 avril | temp_min < -3°C après le 25 mars | -10% à -40% (colza, arbo) | Variété tardive, voiles | 0-80 €/ha |
| **Échaudage/canicule** | 20% | Juin-juillet | temp_max > 35°C pendant 3+ jours pendant remplissage grain | -8% à -20% (céréales) | Variété précoce, irrigation | 0-150 €/ha |
| **Grêle** | 5% | Mai-août | Événement ponctuel (1 parcelle ou zone) | -30% à -90% sur parcelle touchée | Assurance grêle | 25-50 €/ha/an |
| **Tempête** | 3% | Nov-mars | vent_rafale > 100 km/h | Verse totale, bâtiments endommagés | Assurance, bâtiments solides | Variable |
| **Année exceptionnelle** | 10% | Toute l'année | tendance_pluie 0,95-1,05 + tendance_temp +0,5 à +1,5 | **+15% à +25%** bonus | — (cadeau) | 0 € |

### 7.2 Détail par événement

**a) Sécheresse**
```
Déclencheur :
  cumul_pluie_mai_juin < 40 mm (normale ~110 mm)
  OU cumul_pluie_juil_août < 25 mm (normale ~95 mm)

Effets :
  Céréales (si phase critique touchée) : -15% à -25% rendement
  Maïs non irrigué                     : -25% à -50% rendement
  Prairie                              : arrêt pousse, pas de regain
  Betterave                            : -20% rendement

Protection :
  Irrigation : 3-4 tours d'eau × 30 mm = 90-120 mm apportés
    Coût : 40 €/ha/tour × 3-4 = 120-160 €/ha
    → Compense 60-80% de la perte
  Variété précoce : échappe au stress de fin de cycle
    Coût : 0 € (choix au semis)
    → Compense 30-50% de la perte

Mode Normal : sécheresse modérée uniquement (-15% max, jauge basse)
Mode Expert : sécheresse sévère possible (-35%), restrictions irrigation
```

**b) Excès d'eau**
```
Déclencheur :
  cumul_pluie_30j > 150 mm en octobre-novembre
  OU cumul_pluie_7j > 80 mm à n'importe quel moment

Effets :
  Octobre-novembre : semis impossible → report/perte de la parcelle
  Printemps : asphyxie racinaire → -10% à -20% rendement
  Récolte : germination sur pied (-30% qualité) si 3+ jours de pluie

Protection :
  Drainage (installation)      : 2 000 €/ha, durée de vie 25 ans
    → Réduit les jours d'impraticabilité de 40%
  Fossés entretenus            : 200 €/ha/5 ans
    → Réduit le ruissellement de surface
  Semis précoce (avant les pluies) : choix tactique

Mode Normal : délai de semis automatiquement rattrapé (fenêtre élargie)
Mode Expert : la parcelle non semée est perdue pour la saison
```

**c) Gel tardif**
```
Déclencheur :
  temp_min < -3°C après le 25 mars (colza en floraison, arbo en fleur)
  temp_min < -5°C après le 15 mars (betterave/pois levés)

Effets :
  Colza en floraison       : -15% à -40% (siliques gelées)
  Vigne/arbo (si modélisé) : -30% à -80%
  Betterave levée          : -20% (nécessite resemis partiel)
  Blé (rare, résistant)    : -5% si tallage avancé

Protection :
  Variété tardive (floraison décalée)  : 0 €, évite le gel dans 70% des cas
  Voiles de protection (maraîchage)    : 80 €/ha, efficace jusqu'à -5°C
  Brassage d'air (arbo)               : 15 000 € pour 5 ha, efficace -3°C

Mode Normal : gel tardif rare et impact léger (-10% max, message d'info)
Mode Expert : gel potentiellement dévastateur sur colza/pois/betterave
```

**d) Échaudage / Canicule**
```
Déclencheur :
  temp_max > 35°C pendant 3+ jours consécutifs
  pendant la période épiaison-remplissage des céréales (juin-début juillet)

Effets :
  Blé/orge (remplissage interrompu)   : -8% à -20% rendement
  Maïs (fécondation perturbée)         : -15% à -30% si pendant floraison
  Prairie (stress + arrêt de pousse)   : pas de regain été

  Mécanisme : la plante ferme ses stomates → arrêt photosynthèse
  Si combiné à sécheresse : effet cumulatif (les deux pénalités s'additionnent)

Protection :
  Variété précoce (échappe à la canicule)  : 0 €
  Irrigation (refroidissement + eau)        : 40 €/ha/tour
  Dose d'azote modérée (évite échaudage précoce) : 0 €

Mode Normal : canicule = jauge soleil en excès, -10% max
Mode Expert : échaudage brutal si période critique touchée, -20%
```

**e) Grêle**
```
Déclencheur :
  Événement aléatoire mai-août
  Touche 1 à 3 parcelles de l'exploitation (pas toutes)
  5% de probabilité annuelle = une fois tous les 20 ans en moyenne

Effets :
  Dégât faible (grêlons < 1 cm)   : -30% rendement parcelle touchée
  Dégât moyen (grêlons 1-3 cm)    : -60% rendement
  Dégât fort (grêlons > 3 cm)     : -90% rendement (culture détruite)
  Distribution : 50% faible, 35% moyen, 15% fort

Protection :
  Assurance grêle : 25-50 €/ha/an selon zone
    → Indemnise 70% de la perte (franchise 30%)
  Filets anti-grêle (arbo/vigne) : 15 000 €/ha, protection totale

Mode Normal : grêle NON implémentée (ADR-002 : pas de perte brutale)
Mode Expert : grêle possible, assurance fortement recommandée
```

**f) Tempête**
```
Déclencheur :
  vent_rafale > 100 km/h (novembre-mars principalement)
  3% de probabilité annuelle

Effets :
  Verse totale des céréales d'hiver    : -15% rendement + pertes récolte
  Dégâts bâtiments (toitures, hangars) : 5 000-50 000 € de réparations
  Arbres cassés (haies, vergers)        : perte durable
  Serres détruites                     : 100% de perte

Protection :
  Assurance multirisque exploitation  : 500-2 000 €/an selon taille
    → Couvre les bâtiments
  Régulateur de croissance (anti-verse) : 20 €/ha (céréales)
  Densité de semis modérée              : 0 €, réduit le risque de verse

Mode Normal : tempête = 1-2 jours d'impossibilité de travail, pas de dégâts
Mode Expert : dégâts possibles sur bâtiments et cultures
```

**g) Année exceptionnelle (bonus)**
```
Déclencheur :
  Combinaison favorable : pluviométrie bien répartie (0,95-1,05)
  + températures légèrement au-dessus des normales (+0,5 à +1,5°C)
  + pas d'événement extrême
  10% de probabilité annuelle

Effets :
  Toutes cultures        : +15% à +25% rendement
  Qualité supérieure     : +5% prix (protéines, PS élevés)
  Pousse d'herbe record  : +30% production prairie

  → L'année où tout le monde fait un bon résultat
  → Le serveur affiche « Millésime exceptionnel 20XX ! »

Mode Normal : bonus marqué, satisfaction garantie
Mode Expert : idem, le joueur qui a bien fait récolte au maximum du potentiel
```

### 7.3 Cumul d'événements

```
Règle : maximum 2 événements négatifs par campagne.
  Si la génération produit 3+ événements : annuler le 3e.
  
  Combinaisons possibles (les plus réalistes) :
    Excès d'eau automne + gel tardif printemps  (probable)
    Sécheresse été + échaudage                  (se renforcent)
    Grêle + n'importe quoi                     (indépendant)
    
  Combinaisons interdites :
    Sécheresse + excès d'eau la même saison
    Année exceptionnelle + tout événement négatif
```


---

## 8. Prévisions météo

### 8.1 Mode Normal — Prévisions fiables

```
Le joueur Normal voit 5 jours de prévisions, toujours exactes.
Pas de surprise : s'il voit du soleil demain, il y aura du soleil.

Affichage :
  Aujourd'hui + 4 jours suivants
  Icône + température + pluie oui/non
  Alerte si blocage prévu (« Pluie forte jeudi — planifiez vos travaux »)
```

**Justification (ADR-002)** : le joueur Normal ne doit pas être piégé par une météo imprévisible. Il a toujours l'information suffisante pour planifier.

### 8.2 Mode Expert — 7 jours à fiabilité décroissante

| Horizon | Fiabilité | Détail affiché | Déviation possible |
|:-------:|:---------:|----------------|:------------------:|
| J+0 (aujourd'hui) | 100% | Données exactes | 0 |
| J+1 | 95% | Toutes variables | ±1°C, ±2 mm |
| J+2 | 85% | Toutes variables | ±2°C, ±5 mm |
| J+3 | 70% | Tendance + fourchette | ±3°C, ±10 mm |
| J+4 | 55% | Tendance | ±4°C, pluie oui/non incertain |
| J+5 | 40% | Tendance vague | ±5°C, fiabilité pluie 50% |
| J+6 | 30% | Indication | Peu fiable |
| J+7 | 20% | Indication | Presque aléatoire |

```
Mécanisme d'imprécision :
  prevision_affichee[J+n] = valeur_reelle[J+n] + erreur

  erreur_temp = random_normal(μ=0, σ = 0.5 × n)
  erreur_pluie = random_normal(μ=0, σ = 2.0 × n)
  
  Pour la pluie (oui/non) :
    Si pluie_reelle > 0 et n ≥ 4 : 30% de chance d'afficher "sec"
    Si pluie_reelle = 0 et n ≥ 4 : 20% de chance d'afficher "pluie"

Le joueur Expert apprend à ne pas se fier aux prévisions au-delà de J+3.
C'est un apprentissage réaliste (en vrai agriculture, au-delà de J+5 c'est de la loterie).
```

### 8.3 Station météo (investissement Expert)

```
Station météo connectée : 3 500 €
  → Améliore la fiabilité de +10% sur tous les horizons
  → Affiche l'humidité du sol en temps réel
  → Alerte gel automatique (SMS in-game)
  
Station + abonnement pro : 3 500 € + 200 €/an
  → Fiabilité +15%
  → Prévisions étendues à J+10 (mais fiabilité faible après J+7)
  → Historique climatique de l'exploitation (graphiques)
```

---

## 9. Changement climatique (Expert, long terme)

### 9.1 Concept

En mode Expert, sur les serveurs long terme (5+ années de jeu), une dérive climatique progressive est appliquée. C'est un élément de stratégie à long terme : les choix de cultures doivent s'adapter.

### 9.2 Paramètres de la dérive

```
Par année de jeu :
  temperature_moyenne += 0,04°C/an (soit +1°C sur 25 ans de jeu)
  pluviometrie_annuelle × 0,995/an (soit -12% sur 25 ans)
  
  Redistribution saisonnière :
    Hiver : +5% pluviométrie
    Été   : -15% pluviométrie (sécheresses plus fréquentes)
    
  Événements extrêmes :
    prob_secheresse     += 0,5%/an
    prob_echaudage      += 0,5%/an
    prob_gel_tardif     -= 0,3%/an (hivers plus doux)
    prob_exces_eau_automne += 0,3%/an (pluies intenses)

  Après 10 ans de jeu :
    prob_secheresse = 25% (vs 20% initial)
    prob_echaudage  = 25% (vs 20% initial)
    → Le joueur ressent le changement sans que ce soit brutal
```

### 9.3 Impact sur les décisions

```
Adaptations possibles pour le joueur :
  - Décaler les dates de semis (plus tôt au printemps)
  - Choisir des variétés plus précoces / résistantes à la chaleur
  - Investir dans l'irrigation
  - Migrer vers des cultures du Sud (tournesol, sorgho)
  - Couverts végétaux pour préserver l'eau du sol
  
Le jeu affiche (tous les 5 ans) :
  « La température moyenne de votre zone a augmenté de +0,2°C
    sur les 5 dernières années. La pluviométrie estivale est en baisse. »
```

### 9.4 Garde-fous

- Mode Normal : **aucun changement climatique** (ADR-002, pas de complexité supplémentaire)
- Mode Expert : dérive très lente, visible uniquement sur 10+ années de jeu
- Pas de point de non-retour : le joueur peut toujours s'adapter
- Pas d'effet avant l'année 3 du serveur (le joueur s'installe d'abord)

---

## 10. Équilibrage — La météo ne ruine jamais

### 10.1 Principes d'équilibrage

| Règle | Normal | Expert |
|-------|--------|--------|
| Perte max par événement | -20% rendement | -90% (grêle, 1 parcelle) |
| Perte max cumulée annuelle | -20% rendement global | -40% rendement global |
| Faillite possible par la météo | **Jamais** | **Non** (assurances, diversification) |
| Blocage max consécutif | 3 jours | 14 jours (mais travaux alternatifs possibles) |
| Fréquence année catastrophique | 0% | 5% (2 événements cumulés) |

### 10.2 Filets de sécurité

```
MODE NORMAL :
  1. Plancher rendement 40% (quoi qu'il arrive, même météo catastrophique)
  2. Pas de grêle, pas de tempête destructrice
  3. Fenêtres de travaux élargies (3-4 semaines)
  4. Blocages météo max 3 jours consécutifs
  5. La jauge météo ne descend jamais sous 0,80

MODE EXPERT :
  1. Assurance multirisque climatique : 35-50 €/ha/an
     → Couvre : grêle, sécheresse, excès d'eau, gel
     → Indemnise 65% de la perte au-delà d'une franchise de 25%
  2. Diversification des cultures = amortisseur naturel
     → Un événement touche rarement toutes les cultures
  3. Pas de faillite météo : même une année catastrophique ne met pas
     en défaut un joueur qui a 2+ cultures et une assurance
  4. Trésorerie de sécurité : la banque ne saisit pas après 1 mauvaise année
```

### 10.3 Scénario A — Année sèche en Normal

```
Joueur : 120 ha, 3 cultures (blé 50 ha, colza 35 ha, orge 35 ha)
Événement : sécheresse estivale (tendance_pluie = 0,68)

Impact :
  Blé   : f_meteo = 0,85 → rendement 73 q (vs 86 q en année normale) = -15%
  Colza  : f_meteo = 0,82 → rendement 30 q (vs 37 q) = -19%
  Orge   : f_meteo = 0,88 → rendement 70 q (vs 79 q) = -11%
  (l'orge est récoltée avant la sécheresse estivale)

Marge brute :
  Blé  : 50 ha × 73 q × 220 €/t - charges = 50 × (1 606 - 487) = 55 950 €
  Colza: 35 ha × 30 q × 470 €/t - charges = 35 × (1 410 - 520) = 31 150 €
  Orge : 35 ha × 70 q × 195 €/t - charges = 35 × (1 365 - 445) = 32 200 €
  ───────────────────────────────────────────────────────────────────────────
  TOTAL marge brute : 119 300 €

  vs année normale : 50×1 555 + 35×1 219 + 35×1 245 = 164 990 €

  Perte : -45 690 € soit -28% de marge brute

Vérification ADR-002 :
  → Le joueur perd 28% de marge, pas de rendement. Il reste très rentable.
  → Marge/ha restante : 994 €/ha. Largement positif. ✅
  → Pas de culture à 0. Pas de faillite. Pas de découragement.
```

### 10.4 Scénario B — Grêle en Expert

```
Joueur Expert : 180 ha, 4 cultures, assuré (50 €/ha)
Événement : grêle forte sur 1 parcelle de 25 ha de blé (juin)

Impact :
  Parcelle grêlée : 25 ha × rendement résiduel 8 q × 220 €/t = 44 000 €
  Rendement normal sans grêle : 25 ha × 95 q × 232 €/t = 551 000... 
  
  Perte brute : 25 ha × (95 - 8) q × 232 €/t = 50 460 €
  
  Assurance :
    Franchise 25% = 12 615 € à la charge du joueur
    Indemnité 65% de la perte au-delà = (50 460 - 12 615) × 0,65 = 24 599 €
    
  Perte nette après indemnité : 50 460 - 24 599 = 25 861 €
  Coût de l'assurance annuelle : 180 ha × 50 € = 9 000 €

  Bilan exploitation (les 155 autres ha sont normaux) :
    Marge des 155 ha non touchés : 155 × 1 700 € = 263 500 €
    Marge parcelle grêlée (après indemnité) : -25 861 + 24 599 = résiduel
    Assurance payée : -9 000 €
    ──────────────────────────────────
    Marge totale : ~250 000 € (vs ~306 000 € sans grêle)
    Perte : -18% → supportable ✅

Joueur NON assuré :
    Perte nette : 50 460 €
    Marge totale : ~250 000 € aussi (il économise l'assurance les bonnes années)
    → Risque assumé, pas de faillite mais coup dur.
    
  ✅ La grêle ne ruine pas. Elle fait mal mais l'exploitation survit.
```

### 10.5 Scénario C — Pire cas Expert (cumul d'événements)

```
Joueur Expert : 120 ha, année catastrophique (excès d'eau automne + sécheresse été)
  → 20 ha non semés (trop humides en novembre, reportés en cultures de printemps)
  → Sécheresse sur les 100 ha restants : -30% rendement moyen

Impact :
  100 ha × rendement réduit 30% : marge ~1 100 €/ha = 110 000 €
  20 ha en maïs grain (non irrigué, sécheresse) : marge ~400 €/ha = 8 000 €
  ──────────────────────────────────────────────
  Marge totale : 118 000 € (vs ~200 000 € en année normale)
  Perte : -41%

  Avec assurance sécheresse (indemnité partielle) : +15 000 €
  → Marge finale : ~133 000 €, perte -33%

  ✅ Année très difficile mais PAS de faillite.
  Le joueur a de quoi payer ses charges fixes (estimées ~80 000 €).
  Reste 53 000 € de trésorerie. L'année suivante, il récupère.
```

---

## Mockups ASCII

### Mockup 1 — Bulletin météo Mode Normal

```
┌─ 🌤️ Météo — Ma ferme (Bassin parisien) ──────────────────┐
│                                                            │
│  Aujourd'hui : Mardi 15 juillet                            │
│  ☀️ Ensoleillé — 26°C                                      │
│                                                            │
│  ── Prévisions ──                                          │
│  Mer 16  Jeu 17  Ven 18  Sam 19  Dim 20                   │
│   ☀️       ⛅      🌧️      🌧️      ☀️                       │
│   28°C    24°C    19°C    18°C    22°C                     │
│                                                            │
│  ⚠️ Pluie prévue vendredi et samedi                         │
│  💡 Moissonnez vos parcelles avant vendredi !               │
│                                                            │
│  ── Mes parcelles ──                                       │
│  Les Sables (blé)   ☀️████████░░ 💧██████░░░░  Récolte OK  │
│  La Plaine (colza)  ☀️███████░░░ 💧█████░░░░░  Un peu sec  │
│  Le Bas (maïs)      ☀️█████████░ 💧████░░░░░░  ⚠️ Sec      │
│                                                            │
│  [ Moissonner le blé ]  [ Irriguer le maïs ]              │
└────────────────────────────────────────────────────────────┘
```

### Mockup 2 — Météo + Fenêtres de travaux Mode Expert

```
┌─ 🌤️ Météo Expert — Zone Bassin parisien ──────────────────────────────┐
│                                                                        │
│  Mardi 15 juillet 2026 — Données du jour                              │
│  T° min : 14°C  |  T° max : 27°C  |  Moy : 20,5°C                    │
│  Pluie : 0 mm   |  Soleil : 13,2 h |  Vent : 12 km/h SO              │
│  Humidité : 58%  |  Rafales : 22 km/h                                  │
│                                                                        │
│  ── Prévisions (fiabilité décroissante) ──                             │
│         Mer 16   Jeu 17   Ven 18   Sam 19   Dim 20   Lun 21  Mar 22  │
│  T°max   29°C    25°C     19°C     17°C     21°C     24°C    25°C    │
│  T°min   15°C    14°C     13°C     12°C     11°C     13°C    14°C    │
│  Pluie   0 mm    2 mm     22 mm    15 mm    4 mm     0 mm    0 mm    │
│  Vent    8       14       28⚠️      32       18       10      8       │
│  Fiab.   95%     85%      70%      55%      40%      30%     20%     │
│                ──────────    ─────────────────────────────────         │
│                 fiable          tendance seulement                     │
│                                                                        │
│  ── Fenêtres de travaux ──                                             │
│                                                                        │
│  Travail         Mar15  Mer16  Jeu17  Ven18  Sam19  Dim20  Lun21      │
│  ─────────────────────────────────────────────────────────────         │
│  Moisson          ✅     ✅     ⚠️     ❌     ❌     ⚠️     ✅         │
│  Pulvérisation    ✅     ✅     ✅     ❌     ❌     ✅     ✅         │
│  Travail du sol   ✅     ✅     ✅     ❌     ❌     ❌     ⚠️         │
│  Épandage         ✅     ✅     ⚠️     ❌     ❌     ⚠️     ✅         │
│  Fenaison         ✅     ✅     ❌     ❌     ❌     ❌     ❌         │
│                                                                        │
│  ⚠️ = conditions limites (efficacité réduite)                           │
│  ❌ = impossible ou fortement déconseillé                               │
│                                                                        │
│  ── Alertes ──                                                         │
│  🔴 URGENCE : 40 ha de blé mûrs à moissonner avant vendredi           │
│     Grain actuel : 14,2% humidité ✅ | Si pluie vendredi : 17%+ ❌     │
│     Capacité moiss.-batt. : 25 ha/jour → IL FAUT COMMENCER DEMAIN     │
│                                                                        │
│  🟡 Pulvérisation colza (insecticide méligèthes) :                     │
│     Fenêtre optimale : aujourd'hui-demain. Vent OK, hygrométrie OK.    │
│                                                                        │
│  ── Bilan hydrique parcelles ──                                        │
│  Les Sables (blé)  : RU 45%  ─── stress léger, récolte dans 3j       │
│  La Plaine (colza) : RU 52%  ─── correct                              │
│  Le Bas (maïs)     : RU 28% ⚠️── stress sévère, irrigation urgente    │
│  Vallée (prairie)  : RU 35%  ─── pousse ralentie, pas de regain       │
│                                                                        │
│  ── Cumuls campagne ──                                                 │
│  Pluie depuis 1er sept : 548 mm (normale 580 mm) — légèrement sec     │
│  Somme T° (base 0) depuis 1er oct : 2 180 °Cj (normale 2 050) — avance│
│  Jours de travail perdus ce mois : 3 j (moyenne : 5 j)                │
│                                                                        │
│  [ Planifier moisson ]  [ Irriguer Le Bas ]  [ Historique 30j ]        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| Zones climatiques | 6 (même modèle) | 6 (même modèle) |
| Variables affichées | Icône + T° + pluie oui/non | 9 variables complètes |
| Jauges parcelle | ☀️ Soleil + 💧 Pluie (10 segments) | Bilan hydrique en mm, RU% |
| Prévisions | 5 jours, 100% fiables | 7 jours, fiabilité 95% → 20% |
| f_meteo sur rendement | 0,80 à 1,10 | Calcul agronomique (stress hydrique, degrés-jours) |
| Blocage forte pluie | 1-2 jours max | Selon type de sol et cumul 7j |
| Blocage max consécutif | 3 jours | 14 jours |
| Praticabilité sol | Non modélisée | Cumul pluie × type de sol |
| Forcer un travail hors conditions | Impossible (le jeu bloque) | Possible avec pénalité |
| Événements grêle/tempête | Non | Oui (5% et 3%/an) |
| Sécheresse | -15% rendement max | -35% rendement, restrictions irrigation |
| Échaudage | -10% max | -20% si période critique |
| Gel tardif | -10% max | -40% sur colza/pois |
| Assurances | Non nécessaires | 35-50 €/ha (choix stratégique) |
| Changement climatique | Non | +0,04°C/an, -0,5% pluie/an |
| Station météo | Non | 3 500 € (+10-15% fiabilité) |
| Perte max annuelle (marge) | -28% | -41% (cas extrême) |
| Faillite par la météo | **Impossible** | **Impossible** (assurances + trésorerie) |

---

## Points à valider en playtest

**Recette SimAgri (ADR-002) — bloquant**
- [ ] Le joueur Normal est-il bloqué plus de 3 jours consécutifs par la météo ?
- [ ] La météo peut-elle ruiner une campagne en Normal ? (réponse attendue : NON)
- [ ] Les jauges soleil/pluie sont-elles comprises sans explication ?
- [ ] Le joueur occasionnel (2-3 connexions/semaine) subit-il un désavantage météo ?
- [ ] Un joueur absent 1 semaine perd-il une fenêtre critique irrécupérable ?

**Profondeur Expert**
- [ ] Le bilan hydrique est-il lisible et exploitable pour décider d'irriguer ?
- [ ] Les prévisions à 7 jours avec fiabilité décroissante créent-elles une vraie incertitude ?
- [ ] La praticabilité du sol est-elle comprise (pourquoi je ne peux pas labourer) ?
- [ ] Les événements climatiques créent-ils de la tension sans frustration ?
- [ ] Le choix d'assurance récolte (35-50 €/ha) est-il un arbitrage intéressant ?
- [ ] Le joueur peut-il anticiper et s'adapter, ou subit-il passivement ?

**Équilibrage**
- [ ] La fréquence des événements (5% grêle, 25% sécheresse) est-elle ressentie comme juste ?
- [ ] Une mauvaise année météo est-elle survivable sans assurance en Expert ?
- [ ] Le changement climatique progressif est-il perceptible sur 10 ans de jeu ?

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | Création du GDD météo complet |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
