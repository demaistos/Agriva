> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.

# GDD — Système de temporalité et moteur de ticks

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `Docs_legacy/SimAgri/docs/sdd/01-core.md`, ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

Agriva est un jeu **par navigateur** conçu pour être joué **10-20 minutes par jour**, sur des **mois**. Le système temporel est le fondement de TOUT le jeu : il rythme les cultures, les animaux, l'économie, et les interactions sociales.

**Trois principes absolus :**
1. **Pas de FOMO** — le joueur absent 3 jours ne prend pas de retard irrattrapable.
2. **Pas de pression** — aucune action urgente à effectuer dans l'heure. Tout peut attendre 24h.
3. **Progression tangible** — chaque connexion montre un changement visible (croissance, production, météo).

**Ce que SimAgri fait bien (à garder) :**
- Ratio 1 jour réel = 7 jours de jeu → rythme satisfaisant sans attente excessive
- Régénération quotidienne des heures → rituel de connexion
- Saisons qui affectent les cultures → immersion agricole

**Ce que SimAgri fait mal (à corriger) :**
- Aucune protection hors-ligne → animaux meurent si le joueur ne nourrit pas
- Tick opaque → le joueur ne comprend pas ce qui s'est passé pendant la nuit
- Heures de travail rigides → frustration quand on manque de 0,5 h pour finir une action

### 1.2 Gameplay loop temporel

```
┌──────────────────────────────────────────────────────────────────┐
│                    BOUCLE QUOTIDIENNE (10-20 min)                 │
└──────────────────────────────────────────────────────────────────┘

  00:00 heure française — TICK QUOTIDIEN (automatique, joueur déconnecté)
    │
    ├─ 1. Avance calendrier (+1 jour de jeu)
    ├─ 2. Croissance cultures (stades, maturité)
    ├─ 3. Météo du jour (température, précipitations)
    ├─ 4. Alimentation animaux (consommation stock)
    ├─ 5. Santé animaux (état, maladies)
    ├─ 6. Production (lait, œufs, laine)
    ├─ 7. Usure matériel (+% usure quotidienne)
    ├─ 8. Charges périodiques (si jour = fin de mois)
    ├─ 9. Prix marché (ajustement offre/demande)
    └─ 10. Régénération heures de travail
    │
    ▼
  JOUEUR SE CONNECTE (quand il veut dans la journée)
    │
    ├─ Consulte le rapport du tick (quoi de neuf ?)
    ├─ Prend des décisions (semer, vendre, acheter)
    ├─ Lance des chantiers (semer, vendre, acheter)
    └─ Se déconnecte (rien d'urgent avant demain)

┌──────────────────────────────────────────────────────────────────┐
│                    BOUCLE HEBDOMADAIRE (1 mois de jeu)            │
└──────────────────────────────────────────────────────────────────┘

  Chaque 7 ticks = 1 mois de jeu
    ├─ Charges mensuelles (salaires, entretien)
    ├─ Production mensuelle comptabilisée
    ├─ Marché : nouvelles offres/demandes
    └─ Météo : prévision du mois suivant disponible

┌──────────────────────────────────────────────────────────────────┐
│                    BOUCLE SAISONNIÈRE (21 jours réels)            │
└──────────────────────────────────────────────────────────────────┘

  Chaque 21 ticks = 1 saison de jeu
    ├─ Nouvelles cultures disponibles (semis de saison)
    ├─ Changement climatique (températures, gel, canicule)
    ├─ Ajustement prix saisonniers
    └─ Bilan de saison (résumé automatique)

┌──────────────────────────────────────────────────────────────────┐
│                    BOUCLE ANNUELLE (84 jours réels ≈ 3 mois)     │
└──────────────────────────────────────────────────────────────────┘

  Chaque 84 ticks = 1 année de jeu
    ├─ Bilan annuel complet (revenus, charges, bénéfice)
    ├─ Versement aides PAC (Normal : automatique)
    ├─ Charges sociales annuelles
    ├─ Classements mis à jour
    └─ Nouveau cycle de cultures annuelles
```

### 1.3 Les décisions du joueur liées au temps

| Décision | Fréquence | Impact |
|----------|:---------:|--------|
| Quand semer ? | Saisonnier | Rendement ±20% selon date |
| Combien d'employés ? | Structurel | Heures disponibles × durée |
| Stocker ou vendre maintenant ? | Hebdomadaire | Prix ±15% selon saison |
| Investir en automatisation ? | Ponctuel | Moins d'heures de travail, plus de charges |
| Nourrir manuellement ou automatiser ? | Quotidien | Temps vs coût robot |
| Quand récolter ? | Saisonnier | Maturité = rendement max |

### 1.4 Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| **Temps de travail** | 6 à 12 h/jour selon saison — largement suffisant en Normal | 6 à 12 h/jour — mais plus d'actions nécessaires |
| **Protection hors-ligne** | Forte : auto-nourrissage (stock + achat secours ×1.5), mais animaux meurent si ≥2 sem. sans nourriture | Faible : stock consommé, pas d'auto-achat, animaux meurent si ≥2 sem. sans nourriture |
| **Tick** | Résultat simplifié (rapport clair) | Détail complet (chaque étape visible) |
| **Calendrier** | Saisons simples, dates de semis larges | Fenêtres de semis précises, gel impactant |
| **Notifications** | Rappel simple « vos poules n'ont plus d'aliment » | Alertes détaillées avec prévisions |
| **Absence prolongée** | Stock consommé normalement, animaux meurent si ≥2 semaines sans nourriture | Idem — animaux meurent si ≥2 semaines sans nourriture |


---

## 2. Ratio temps réel / temps de jeu

### 2.1 Choix retenu : 1 jour réel = 7 jours de jeu

**Justification :**

| Option | Avantages | Inconvénients | Verdict |
|--------|-----------|---------------|---------|
| 1:1 (temps réel) | Immersif, saisons alignées | Blé = 8 mois d'attente. Intenable. | ❌ Rejeté |
| 1:3 (×3) | Cycle de culture en 3 mois | Trop lent pour l'élevage. Gestation vache = 93 jours réels | ❌ Trop lent |
| 1:7 (×7) | **Cycle blé = 35j réels. Gestation vache = 40j. Année complète = 84j (≈3 mois)** | Les saisons ne sont pas alignées sur la réalité | ✅ **Retenu** |
| 1:14 (×14) | Tout va vite | Trop rapide : une culture pousse en 2 semaines, pas le temps de s'y attacher | ❌ Trop rapide |

**Pourquoi ×7 est le sweet spot :**
- **Rétention** : un joueur voit un cycle complet (semis → récolte) en 5 semaines réelles. Assez court pour rester engagé, assez long pour créer de l'attachement.
- **Session quotidienne** : chaque connexion = 7 jours de jeu écoulés = changements visibles à chaque fois.
- **Durée de vie** : une « partie » de 2 ans (temps du joueur) = 14 années de jeu. Énormément de contenu à explorer.
- **Compatibilité SimAgri** : c'est exactement le ratio de SimAgri. Les joueurs vétérans ne seront pas dépaysés.

### 2.2 Mapping temporel complet

```
1 jour réel    = 7 jours de jeu
1 semaine      = 49 jours de jeu (≈ 1.6 mois de jeu)
7 jours réels  = 1 mois de jeu
21 jours réels = 1 saison de jeu (3 mois)
84 jours réels = 1 année de jeu (12 mois)
```

### 2.3 Impact sur les durées de gameplay

| Événement agricole | Durée réelle | Durée en jeu | Jours réels |
|-------------------|:------------:|:------------:|:-----------:|
| Pousse du blé (semis → récolte) | 240 jours | 240 jours jeu | 34 jours |
| Pousse du maïs | 150 jours | 150 jours jeu | 21 jours |
| Gestation vache | 280 jours | 280 jours jeu | 40 jours |
| Gestation truie | 115 jours | 115 jours jeu | 16 jours |
| Poulet de chair (éclosion → abattage) | 42 jours | 42 jours jeu | 6 jours |
| Poule pondeuse (maturité → réforme) | 365 jours | 365 jours jeu | 52 jours |
| Croissance d'un bovin (naissance → abattage) | 540 jours | 540 jours jeu | 77 jours |

### 2.4 Impact sur la rétention

| Métrique | Cible | Mécanisme |
|----------|-------|-----------|
| Taux de connexion J+7 | >70% | Première récolte visible (poulet = 6j) |
| Taux de connexion J+30 | >50% | Première récolte céréales (blé = 34j) |
| Taux de connexion J+90 | >30% | Première année complète, bilan annuel |
| Session moyenne | 12 min | Heures limitées = pas besoin de rester longtemps |
| Connexions/jour | 1-2 | Tick quotidien = 1 raison de revenir |

### 2.5 Règle d'or du ratio

```
INVARIANT : time_ratio = 7

game_days_elapsed = real_days_elapsed × time_ratio
game_months_elapsed = game_days_elapsed / 30
game_seasons_elapsed = game_days_elapsed / 90
game_years_elapsed = game_days_elapsed / 360

// Simplification calendrier Agriva :
// 1 mois de jeu = 30 jours de jeu (pas 28/30/31)
// 1 saison = 3 mois = 90 jours de jeu
// 1 année = 4 saisons = 12 mois = 360 jours de jeu
// En jours réels : 1 année de jeu = 360/7 ≈ 51.4 jours réels
```

**Note : divergence avec le SDD legacy**

Le SDD legacy indique 1 mois = 7 jours réels (84 jours/an). On conserve ce mapping simplifié pour le calendrier de jeu :

```
CALENDRIER AGRIVA (hérité SimAgri) :
  1 mois de jeu   = 7 jours réels (1 tick/jour × 7 ticks)
  1 saison         = 3 mois = 21 jours réels
  1 année          = 12 mois = 84 jours réels (≈ 2.8 mois réels)
```

Les durées biologiques (gestation, croissance) utilisent les jours de jeu bruts (7 jours de jeu par tick). Les durées calendaires (mois, saisons) utilisent le mapping simplifié ci-dessus.


---

## 3. Le calendrier : saisons, mois, effets

### 3.1 Structure du calendrier

| Mois de jeu | Saison | Jours réels (cumulés) | Événements clés |
|:-----------:|:------:|:---------------------:|-----------------|
| Janvier | Hiver | 1-7 | Gel possible, repos végétatif |
| Février | Hiver | 8-14 | Préparation semis, commandes intrants |
| Mars | Printemps | 15-21 | Semis de printemps, réveil animaux |
| Avril | Printemps | 22-28 | Croissance active, traitement phyto |
| Mai | Printemps | 29-35 | Fenaison, pic de production lait |
| Juin | Été | 36-42 | Moisson orge, début récoltes |
| Juillet | Été | 43-49 | Moisson blé, forte production |
| Août | Été | 50-56 | Fin moissons, préparation sols |
| Septembre | Automne | 57-63 | Semis d'automne, vendanges |
| Octobre | Automne | 64-70 | Récolte maïs, semis blé |
| Novembre | Automne | 71-77 | Derniers semis, rentrée animaux |
| Décembre | Hiver | 78-84 | Bilan annuel, repos, planification |

### 3.2 Effets saisonniers

| Saison | Cultures | Animaux | Météo | Marché |
|--------|----------|---------|-------|--------|
| **Printemps** | Semis maïs/tournesol, croissance active | Production lait +20%, naissances | Pluie modérée, T° 8-18°C | Prix céréales ↑ (stocks bas) |
| **Été** | Récoltes, moissons | Production lait stable | Sec, T° 18-32°C, canicule possible | Prix céréales ↓ (offre abondante) |
| **Automne** | Semis blé/colza, labours | Rentrée en bâtiment | Pluie fréquente, T° 6-15°C | Prix céréales ↑ (stockeurs vendent) |
| **Hiver** | Repos végétatif, couverture sols | Consommation aliment +30% | Gel, T° -5 à 8°C, neige possible | Prix lait ↑ (production ↓) |

### 3.3 Fenêtres de semis (Normal vs Expert)

| Culture | Fenêtre Normal | Fenêtre Expert | Pénalité hors-fenêtre |
|---------|:--------------:|:--------------:|:---------------------:|
| Blé tendre | Sept-Déc | Oct 15 - Nov 30 | -5%/mois de retard (Normal), -15%/mois (Expert) |
| Maïs grain | Mars-Mai | Avr 1 - Mai 15 | -10%/mois (Normal), -25%/mois (Expert) |
| Colza | Août-Sept | Août 20 - Sept 15 | -8%/mois (Normal), -20%/mois (Expert) |
| Tournesol | Mars-Avr | Mars 15 - Avr 30 | -5%/mois (Normal), -15%/mois (Expert) |

**En Normal** : fenêtre large, pénalité faible. Impossible de rater complètement (minimum 50% rendement).
**En Expert** : fenêtre étroite, pénalité forte. Semis trop tardif = récolte compromise (minimum 20% rendement).

### 3.4 Effet du gel et de la canicule

```
// Gel (Hiver, T° < -5°C)
if temperature < -5 AND culture.stade == 'levée':
    if mode == 'Normal':
        culture.rendement_modifier -= 0.05  // -5% max
    if mode == 'Expert':
        culture.rendement_modifier -= 0.15  // -15%, protectable avec couvert

// Canicule (Été, T° > 32°C pendant 5+ jours)
if jours_consecutifs_caniculaires >= 5:
    if mode == 'Normal':
        culture.rendement_modifier -= 0.03  // -3% par jour au-delà de 5
    if mode == 'Expert':
        culture.rendement_modifier -= 0.08  // -8% par jour, irrigation réduit à -2%
```


---

## 4. Le temps de travail

### 4.1 Principe — le temps est CALCULÉ, jamais attribué

Dans Agriva, **aucune durée n'est attribuée forfaitairement**. Toute durée de travail est le résultat d'un calcul qui prend en compte le matériel utilisé, l'effectif concerné et les conditions de réalisation. C'est la décision fondatrice ADR-004.

La formule centrale pour les travaux de parcelle est définie dans le GDD-materiel §2 :

```
débit (ha/h) = largeur (m) × vitesse (km/h) × 0,1 × rendement_machine

durée (h) = surface (ha) / débit (ha/h)
```

Le facteur 0,1 est la constante de conversion : 1 m de largeur à 1 km/h couvre 0,1 ha par heure.

**Conséquence directe** : investir dans un outil plus large **divise le temps de travail**. Un semoir de 6 m sème deux fois plus vite qu'un semoir de 3 m. Le matériel a un retour mesurable en productivité — c'est ce qui différencie fondamentalement Agriva de SimAgri.

**Ce qui est interdit** : toute table de « coût fixe par action ». Le temps émerge toujours du matériel, de l'effectif et des conditions. Il n'existe pas de raccourci forfaitaire (sauf pour l'administratif, voir §4.3).

### 4.2 Le budget d'heures par tick

Le joueur dispose d'un **budget d'heures par tick** qui se recharge à chaque tick quotidien. C'est l'équivalent des HT de SimAgri, mais exprimé en heures et calculé à partir de la main d'œuvre.

> **Note** : La SdV §4 indique un budget de base de ~40-50 HT/jour (calibrage exact en phase d'équilibrage). Les valeurs ci-dessous sont des estimations de départ qui seront ajustées lors du playtesting.

```
budget_tick = (heures_exploitant + Σ heures_salariés) × 7 jours

Exploitant : variable selon saison (6-12 h/jour) × 7 = 42-84 h/tick
Salarié    :  7 h/jour × 7 = 49 h/tick
```

| Effectif | Budget/tick (pointe, 12h) | Budget/jour (affichage) |
|:--------:|:-----------:|:-----------------------:|
| Exploitant seul | 84 h | 12 h |
| + 1 salarié | 133 h | 19 h |
| + 2 salariés | 182 h | 26 h |
| + 3 salariés | 231 h | 33 h |
| + 4 salariés | 280 h | 40 h |
| + 5 salariés (max) | 329 h | 47 h |

**Salarié** : 7 h/jour (fixe toute l'année). Coût : 2 200 €/mois charges patronales incluses. Maximum 5 salariés.

**Pas de report** : les heures non utilisées d'un tick sont perdues. Le budget repart à son maximum au tick suivant.

**Pas de variation saisonnière** : le budget est fixe toute l'année. C'est la **demande de travail** qui varie avec les saisons (beaucoup en été, peu en hiver), pas la capacité du joueur.

### 4.3 Catégories de durées et leur mode de calcul

| Catégorie | Mode de calcul | Source de vérité |
|-----------|----------------|------------------|
| **Travaux de parcelle** | durée = surface / débit | GDD-materiel §2 |
| **Travaux d'élevage** | durée = f(effectif, équipement, automatisation) | GDD-bovin-laitier §4.2 |
| **Transport** | durée = (distance / vitesse) × nb_trajets | Calcul interne |
| **Administratif** | Forfait court (5 à 15 min) — **seul cas de forfait admis** | — |

#### Travaux de parcelle — exemples chiffrés

```
Labour 18 ha, charrue 5 corps (1,75 m), vitesse 7 km/h, rendement 0,80 :
  débit = 1,75 × 7 × 0,1 × 0,80 = 0,98 ha/h
  durée = 18 / 0,98 = 18 h 22 min

Semis 45 ha, semoir combiné 4 m, vitesse 10 km/h, rendement 0,80 :
  débit = 4 × 10 × 0,1 × 0,80 = 3,2 ha/h
  durée = 45 / 3,2 = 14 h 04 min

Moisson 60 ha, moissonneuse coupe 6 m, vitesse 5,5 km/h, rendement 0,75 :
  débit = 6 × 5,5 × 0,1 × 0,75 = 2,475 ha/h
  durée = 60 / 2,475 = 24 h 15 min
```

#### Travaux d'élevage — exemples chiffrés

```
Traite de 60 vaches, salle de traite 2×8 postes (cadence 16 vaches/rotation, 
  rotation de 12 min) :
  durée = (60 / 16) × 12 min + 25 min de préparation/nettoyage
        = 45 min + 25 min = 1 h 10 min (× 2 traites/jour = 2 h 20 min/jour)

Alimentation 80 bovins, mélangeuse automotrice :
  durée = 45 min (chargement + distribution + nettoyage)

Alimentation 80 bovins, distribution manuelle au godet :
  durée = 1 h 30 min
```

#### Transport — exemple chiffré

```
Livrer 60 t de blé à la coopérative (distance : 8 km, benne 18 t) :
  nb_trajets = ⌈60 / 18⌉ = 4 allers-retours
  durée = (8 km / 25 km/h) × 2 (aller-retour) × 4 trajets + 4 × 10 min (chargement/déchargement)
        = 0,64 h × 4 + 0,67 h = 3 h 13 min
```

#### Administratif — forfait court

```
Vendre une récolte au marché         :  5 min
Acheter un intrant                   : 10 min
Consulter un concessionnaire         : 10 min
Signer un contrat ETA / CUMA         : 15 min
Consultation vétérinaire (appel)     :  5 min
```

Ce sont les seules durées forfaitaires du jeu. Elles représentent du temps de bureau, pas du travail physique mesurable.

### 4.4 Modèle d'exécution — instantané, libre, limité par le budget

**Principe** : le joueur enchaîne autant d'actions qu'il veut en une session. Chaque action est résolue instantanément au clic. La seule limite est le budget d'heures disponible sur le tick en cours.

```
SESSION TYPE (joueur se connecte après un tick) :

  Budget du tick : 12 h/jour × 7 jours = 84 h (exploitant seul)
                   + 8 h/jour × 7 jours = 56 h par ouvrier

  Le joueur enchaîne :
    "Labourer A" (30,6 h) → instantané → reste 53,4 h
    "Herser A"   (6,3 h)  → instantané → reste 47,1 h
    "Semer A"    (9,4 h)  → instantané → reste 37,7 h
    "Labourer B" (25,5 h) → instantané → reste 12,2 h
    "Herser B"   (5,3 h)  → instantané → reste 6,9 h
    "Semer B"    (7,8 h)  → IMPOSSIBLE (budget insuffisant)

  → Demain (tick suivant) : budget rechargé à 84 h. Le joueur finit B.
```

**Aucune file d'attente, aucun timer, aucune planification obligatoire.** Le joueur fait ce qu'il veut dans l'ordre qu'il veut tant que le budget le permet. C'est le modèle SimAgri : cliquer, résoudre, enchaîner.

#### Ce qui est autorisé

- ✅ Enchaîner labour + herse + semis + fertilisation sur la même parcelle en un clic
- ✅ Travailler 5 parcelles différentes dans la même session
- ✅ Moissonner puis vendre dans la même session
- ✅ Traire + nourrir + pailler le même jour (élevage)

#### Ce qui est interdit (contraintes NATURELLES, pas artificielles)

- ❌ Moissonner une culture qu'on vient de semer (il faut qu'elle pousse = plusieurs ticks)
- ❌ Fertiliser à un stade pas encore atteint (Expert : le stade évolue au tick)
- ❌ Travailler par forte pluie ou grand vent (Expert : météo bloquante)
- ❌ Semer hors de la fenêtre calendaire
- ❌ Dépasser le budget d'heures du tick

#### La tension de gameplay

Le budget de 84 h/tick (exploitant seul) ne suffit PAS pour une exploitation de 150+ ha en période de pointe. Le joueur doit **prioriser** : quelle parcelle d'abord ? Investir en matériel plus large ? Embaucher un ouvrier ? Déléguer à une ETA ?

C'est exactement ce qui faisait le gameplay de SimAgri : les 35 HT ne suffisaient pas pour tout faire en un jour sur une grosse ferme.

#### Exemple de tension en moisson (été)

```
Situation : 145 ha de céréales mûres, moissonneuse coupe 6 m (8 ha/h)
Budget : 84 h/tick (seul)
Besoin : 145 / 8 = 18,1 h de moisson + 12 h de transport = 30 h

→ La moisson seule passe en un tick (30 h < 84 h) ✅

MAIS le joueur a AUSSI :
  - 60 vaches à traire (14 h/tick)
  - Alimentation animaux (8 h/tick)
  - Pailler + curer (4 h/tick)
  - Pressage paille derrière la moisson (12 h)
  - Total élevage + récolte = 68 h

→ Il reste 16 h pour labourer derrière et préparer les semis d'automne.
→ C'est serré. Il doit choisir : tout faire seul en 2 ticks, ou embaucher/ETA.
```

### 4.5 Règle du budget strict — pas de chantier « à moitié fait »

**Si le joueur n'a pas assez d'heures pour une action → il ne peut pas la lancer.** Il doit attendre le prochain tick (budget rechargé), investir en matériel plus large (réduire le coût), embaucher (augmenter le budget), ou déléguer à une ETA (0 heure consommée).

```
Exemple :
  Budget restant : 6,9 h
  Action souhaitée : "Semer parcelle B" (7,8 h)
  → REFUSÉ. Message : "Budget insuffisant (6,9 h / 7,8 h nécessaires)."
  → Suggestions : attendre demain, ou semer une partie seulement (si parcelle découpable).
```

**Pourquoi pas de chantier « en cours » ?**
- Simplicité : une parcelle est labourée ou ne l'est pas. Pas d'état intermédiaire.
- Clarté : le joueur sait exactement où il en est. Pas de chantier oublié.
- Modèle SimAgri : les HT sont dépensés, l'action est résolue. Point.

**Exception unique** : le joueur peut découper une grande parcelle en sous-actions :
```
"Labourer les 80 ha des Grands Champs" coûte 81,6 h > budget de 84 h.
→ Le joueur peut labourer 40 ha maintenant (40,8 h), et 40 ha au tick suivant.
→ C'est LUI qui découpe, pas le système. Deux actions distinctes sur la même parcelle.
```

Cette exception force le joueur à investir : avec une charrue 8 corps au lieu de 5, les mêmes 80 ha ne coûtent que 43,5 h → ça passe en un tick.

### 4.5 Les salariés

**Coût réel** : 2 200 €/mois par salarié (salaire brut + charges patronales). Ce chiffre correspond à la réalité agricole française pour un ouvrier qualifié.

#### Mode Normal — pool d'heures commun

Les salariés ajoutent simplement leurs heures au pool disponible. Le joueur ne gère pas l'affectation : le jeu répartit automatiquement le travail.

```
capacité_jour = heures_exploitant + (nb_salariés × 7 h)
```

Tous les salariés sont polyvalents — ils peuvent travailler indifféremment aux cultures ou à l'élevage.

#### Mode Expert — spécialisation et efficacité

Chaque salarié a un profil :

| Spécialisation | Peut faire | Ne peut pas | Bonus efficacité |
|----------------|-----------|-------------|:----------------:|
| Élevage | Traite, alimentation, soins, reproduction | Labour, semis, récolte | +10% vitesse sur élevage |
| Cultures | Tous travaux de parcelle, transport | Traite, soins vétérinaires | +10% vitesse sur parcelle |
| Polyvalent | Tout | — | Aucun bonus |

**Niveau d'expérience** (Expert uniquement) :

| Niveau | Ancienneté | Effet sur efficacité | Coût mensuel |
|--------|:----------:|:--------------------:|:------------:|
| Débutant | 0-1 an | ×0,85 (plus lent) | 2 000 € |
| Confirmé | 1-3 ans | ×1,00 (référence) | 2 200 € |
| Expérimenté | 3+ ans | ×1,10 (plus rapide) | 2 500 € |

#### Tableau de dimensionnement

| Surface / cheptel | Salariés recommandés | Capacité journalière | Coût mensuel |
|:---:|:---:|:---:|:---:|
| < 80 ha ou < 40 vaches | 0 | 12 h | 0 € |
| 80-150 ha | 1 | 20 h | 2 200 € |
| 150-250 ha | 2 | 28 h | 4 400 € |
| 250-400 ha ou > 100 vaches | 3 | 36 h | 6 600 € |
| 400-600 ha | 4 | 44 h | 8 800 € |
| > 600 ha ou exploitation mixte grande | 5 (max) | 52 h | 11 000 € |

### 4.6 L'arbitrage en période de pointe (le cœur du gameplay)

En moisson (juin-août), l'exploitant dispose de 12 h/jour — sa capacité maximale. Mais les besoins dépassent largement cette capacité. C'est la tension fondamentale du jeu.

**Exemple — moissonner 145 ha de céréales**

Moissonneuse coupe 6 m, vitesse 5,5 km/h, rendement 0,75 :
```
débit = 6 × 5,5 × 0,1 × 0,75 = 2,475 ha/h
durée totale = 145 / 2,475 = 58 h 36 min
```

Avec 12 h/jour (exploitant seul) : **5 journées complètes de moisson**.

Mais il y a aussi le transport, le stockage, la vente, et la pluie menace dans 6 jours. Le joueur doit arbitrer :

| Stratégie | Investissement | Durée | Coût annuel | Risque |
|-----------|:---------:|:-----:|:-----------:|--------|
| **1. Matériel plus large** (coupe 9 m) | 420 000 € | 3,5 jours | Amortissement élevé | Aucun (autonomie totale) |
| **2. Embaucher** (1 salarié) | — | 3,1 jours | 2 200 €/mois = 26 400 €/an | Faible (main d'œuvre disponible) |
| **3. Déléguer à une ETA** | — | 0 jour (temps joueur) | 145 ha × 110 € = 15 950 € | Moyen (file d'attente, délai 2 j) |
| **4. Étaler et accepter la pénalité** | — | 5 jours | 0 € | Élevé (pluie → -15% qualité grain) |

```
Comparaison chiffrée sur 10 ans :
  Stratégie 1 : 420 000 € d'investissement, 0 €/an de prestation
    → amortissement 10 ans = 42 000 €/an + entretien 8 000 € = 50 000 €/an
    → rentable uniquement au-delà de 380 ha

  Stratégie 2 : 26 400 €/an de salaire
    → le salarié aide AUSSI le reste de l'année (semis, pulvé, transport)
    → option la plus polyvalente pour 145 ha ✅

  Stratégie 3 : 15 950 €/an de prestation
    → pas d'investissement ni d'engagement permanent
    → risque si ETA saturée en pointe (Expert)

  Stratégie 4 : 0 € mais perte qualité estimée 3 800 € sur la récolte
    → acceptable si la météo est clémente
    → catastrophique si pluie prolongée
```

**Ce choix stratégique EST le jeu en période de pointe.** Il n'y a pas de bonne réponse universelle — seulement des arbitrages adaptés à chaque situation.

### 4.7 Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| **Calcul de durée** | Calculée et affichée, conditions favorables (pas de malus) | Modulée par sol, relief, adéquation puissance, géométrie de parcelle |
| **Facteurs de conditions** | Toujours ×1,00 | Variables : sol (×0,80-1,00), relief (×0,65-1,00), puissance (×0,88-1,05), parcelle (×0,82-1,00) |
| **Salariés** | Polyvalents, pool commun | Spécialisés (élevage/cultures/polyvalent), niveaux d'expérience |
| **Budget insuffisant** | Le jeu propose des solutions (ETA, découpage) | Le joueur doit trouver ses solutions |
| **Affichage** | Durée totale estimée + coût | Détail complet du calcul (débit, facteurs, coûts, comparaisons) |

### 4.8 Mockups

#### Interface Normal — budget et actions disponibles

```
┌─────────────────────────────────────────────────────────────────┐
│  🕐 Temps de travail — Budget du jour                           │
│                                                                  │
│  Disponible : 47 h 10 / 84 h 00                                │
│  ████████████████░░░░░░░░  56%                                  │
│                                                                  │
│  📋 Actions effectuées ce tick :                                │
│  • Labour « Les Sables » (30 ha)              30 h 36           │
│  • Herse « Les Sables »                        6 h 14           │
│                                                                  │
│  📌 Prochaine action possible :                                 │
│  • Semer blé « Les Sables » → coût 9 h 24    [✅ Lancer]       │
│  • Labour « Plaine Nord » → coût 25 h 30     [✅ Lancer]       │
│  • Labour « Les Grands Champs » (80 ha) → 81 h [❌ Budget]     │
│                                                                  │
│  ⏰ Prochain tick : demain 00:00 → budget rechargé à 84 h      │
└─────────────────────────────────────────────────────────────────┘
```

#### Interface Expert — détail du calcul et coûts

```
┌─ Labourer « Plaine Nord » (25 ha) ────────────────────────────┐
│                                                                  │
│  Attelage : JD 6215R (215 CV) + Charrue Kuhn Vari-Master 5c     │
│                                                                  │
│  Débit de base           : 1,75 × 7 × 0,1 × 0,80 = 0,98 ha/h  │
│  × Sol argileux humide   : ×0,85                                │
│  × Relief plat           : ×1,00                                │
│  × Puissance suffisante  : ×1,00                                │
│  ─────────────────────────────────────                           │
│  Débit effectif          : 0,83 ha/h                             │
│  Coût en heures          : 25 / 0,83 = 30 h 07                  │
│                                                                  │
│  Budget restant : 47 h 10 → ✅ Suffisant                        │
│                                                                  │
│  Cascade des effets :                                            │
│  ⏱️ Temps          : −30 h 07                                    │
│  ⛽ Carburant      : 215 CV × 0,22 × 0,85 × 30 = 1 209 L (1 149€)│
│  🔧 Usure tracteur : +30 h (total 2 877 h — 29%)                │
│  🔧 Usure charrue  : +30 h (socs : 170 h restantes)             │
│  🌍 Sol            : structure → bonne, résidus enfouis          │
│                                                                  │
│  [ ✅ Confirmer — 30 h 07 ]    [ ❌ Annuler ]                    │
└──────────────────────────────────────────────────────────────────┘
```


---

## 5. Le moteur de ticks

### 5.1 Vue d'ensemble

Le tick est le **cœur battant** du jeu. C'est un job CRON qui s'exécute une fois par jour et simule 7 jours de jeu pour chaque joueur. Tout le jeu repose sur sa fiabilité.

### 5.2 Fréquence et déclenchement

| Paramètre | Valeur | Justification |
|-----------|--------|---------------|
| Fréquence | **1 fois par jour** | Suffisant pour ×7, pas de surcharge serveur |
| Heure | **00:00 heure française** (23:00 UTC hiver / 22:00 UTC été) | Avant la connexion matinale des joueurs |
| Durée max acceptable | 15 minutes | Budget temps pour 5000 joueurs |
| Fenêtre de maintenance | 23:45 - 00:15 heure française | Jeu en lecture seule pendant le tick |

**Pourquoi pas plusieurs ticks par jour ?**
- Complexité serveur multipliée sans gain de gameplay
- Le joueur ne peut agir qu'1-2 fois/jour → pas besoin de granularité infra-journalière
- 1 tick/jour = simple, prédictible, testable

### 5.3 Ordre d'exécution (STRICT — ne jamais modifier l'ordre)

```
TICK_DAILY(server_id):
  BEGIN TRANSACTION per player (isolation par joueur)
  
  Pour chaque joueur actif du serveur :
  
    PHASE 1 — CALENDRIER
      1.1  game_day += 7 (avance de 7 jours de jeu)
      1.2  Recalcul mois/saison/année si seuil franchi
      1.3  Événement de changement de saison (si applicable)
  
    PHASE 2 — MÉTÉO
      2.1  Générer météo des 7 jours (température, précipitations, vent)
      2.2  Appliquer modificateurs zone climatique
      2.3  Déclencher événements météo (gel, canicule, grêle)
      2.4  Impact gel/canicule sur cultures en cours
  
    PHASE 3 — CULTURES (par parcelle)
      3.1  Avancer stade de croissance (+7 jours de maturité)
      3.2  Appliquer effet météo sur rendement
      3.3  Consommer eau/nutriments du sol
      3.4  Vérifier maladies (probabilité selon météo + traitement)
      3.5  Si stade == 'mûr' → marquer récolte disponible
      3.6  Expert : dégradation si récolte non faite depuis 14j
  
    PHASE 4 — ALIMENTATION ANIMAUX
      4.1  Calculer besoin alimentaire = nb_animaux × ration × 7 jours
      4.2  Déduire du stock (silo/pâturage)
      4.3  Si stock insuffisant → marquer sous-alimentation
      4.4  Normal : auto-achat de secours (prix ×1.5, max 7 jours)
      4.5  Expert : pas d'auto-achat, dégradation santé
  
    PHASE 5 — SANTÉ ANIMAUX
      5.1  Si bien nourris : santé += 2/jour (cap 100)
      5.2  Si sous-alimentés : santé -= 5/jour (Normal) ou -10/jour (Expert)
      5.3  Vérifier maladies (probabilité selon hygiène + densité)
      5.4  Si sous-alimentés ≥10j IG consécutifs : risque de mort élevé (SdV §12)
      5.5  Si sous-alimentés ≥14j IG : mort (Normal ET Expert, conformément à SdV §12)
      5.6  Appliquer vieillissement (+7 jours d'âge)
  
    PHASE 6 — PRODUCTION
      6.1  Lait : production = nb_vaches × litres/j × 7 × facteur_santé × facteur_alimentation
      6.2  Œufs : production = nb_poules × taux_ponte × 7 × facteur_santé
      6.3  Laine/viande : accumulation selon race et âge
      6.4  Stocker production dans bâtiment (tank à lait, ramassage)
      6.5  Si stockage plein → Normal : vente auto au prix plancher. Expert : perte.
  
    PHASE 7 — USURE MATÉRIEL
      7.1  Pour chaque matériel utilisé cette semaine :
           usure += heures_utilisées × taux_usure_horaire
      7.2  Pour chaque matériel non-utilisé :
           usure += 0.01% (usure passive, intempéries)
      7.3  Si usure > 80% → alerte « entretien recommandé »
      7.4  Si usure > 95% → panne (is_broken = true)
      7.5  Expert : usure ×1.3 si stocké dehors (pas de hangar)
  
    PHASE 8 — CHARGES PÉRIODIQUES (si fin de mois de jeu)
      8.1  Salaires employés (si applicable)
      8.2  Entretien bâtiments (si applicable)
      8.3  Assurances (mensuel)
      8.4  Annuités prêts (mensuel)
      8.5  Normal : si solde < 0 → crédit automatique (taux 3%)
      8.6  Expert : si solde < 0 → découvert (taux 8%, max 50 000€)
  
    PHASE 9 — MARCHÉ
      9.1  Ajuster prix selon offre/demande globale du serveur
      9.2  Appliquer saisonnalité (±5% Normal, ±15% Expert)
      9.3  Expirer les annonces de marché > 30 jours de jeu
  
    PHASE 10 — RÉGÉNÉRATION JOUEUR
      10.1  Heures de travail → reset à capacité_jour (exploitant + salariés)
      10.2  Incrémenter seniority_days += 1
      10.3  Générer rapport de tick (résumé des événements)
  
  COMMIT TRANSACTION per player
  
  PHASE GLOBALE (post-joueurs) :
    G1. Mettre à jour classements serveur
    G2. Envoyer notifications (email/push) si alertes critiques
    G3. Logger performance du tick (durée, erreurs)
```

### 5.4 Idempotence et reprise sur erreur

**Problème** : le tick échoue à mi-parcours (crash serveur, timeout BDD, erreur mémoire).

**Solution : isolation par joueur + flag de progression**

```sql
tick_status (
  server_id     INT REFERENCES servers,
  tick_date     DATE NOT NULL,
  player_id     UUID REFERENCES players,
  phase         INT DEFAULT 0,          -- dernière phase complétée (0-10)
  status        VARCHAR DEFAULT 'pending', -- pending | processing | done | failed
  error_message TEXT,
  started_at    TIMESTAMP,
  completed_at  TIMESTAMP,
  PRIMARY KEY (server_id, tick_date, player_id)
)
```

**Règles d'idempotence :**
1. Chaque phase est atomique par joueur. Si phase 4 échoue pour le joueur X, les phases 1-3 sont commitées.
2. La reprise recommence à `phase + 1` pour les joueurs en `status = 'failed'`.
3. Un joueur en erreur n'empêche pas le traitement des autres joueurs.
4. Chaque phase vérifie « ai-je déjà été exécutée pour ce tick_date ? » → idempotent.

```
// Pseudo-code de reprise
TICK_RETRY(server_id, tick_date):
  failed_players = SELECT * FROM tick_status 
                   WHERE status = 'failed' AND tick_date = today
  
  FOR player IN failed_players:
    resume_from_phase = player.phase + 1
    EXECUTE phases resume_from_phase..10 FOR player
    UPDATE tick_status SET status = 'done'
  
  // Si encore des échecs après 3 retries → alerte admin
  IF count(failed) > 0 AFTER 3 retries:
    ALERT admin "Tick échoué pour N joueurs, intervention manuelle requise"
```

### 5.5 Rattrapage après indisponibilité serveur

**Scénario** : le worker est éteint pendant 6h (maintenance, crash infra).

**Règle : on NE RATTRAPE PAS les ticks manqués dans la même journée.**

| Situation | Action |
|-----------|--------|
| Worker éteint < 24h | Le tick se lance à la prochaine fenêtre (00:00 heure française le lendemain) |
| Worker éteint 24-48h | 1 tick manqué → le prochain tick simule 14 jours de jeu au lieu de 7 |
| Worker éteint 48-72h | 2 ticks manqués → le prochain tick simule 21 jours max |
| Worker éteint > 72h | **Plafond : max 21 jours de jeu rattrapés en 1 tick** (3 ticks manqués max) |

**Justification du plafond :** au-delà de 21 jours de jeu rattrapés, les effets cumulatifs (mort animaux, charges) seraient catastrophiques. On simule max 3 semaines de jeu d'un coup.

```
// Calcul du rattrapage
missed_ticks = (NOW - last_successful_tick) / 24h - 1
catchup_days = MIN(missed_ticks × 7, 21)  // Plafond 21 jours de jeu

TICK_CATCHUP(server_id, catchup_days):
  // Même séquence que TICK_DAILY mais avec game_day += catchup_days
  // Alimentation : besoin × catchup_days (au lieu de ×7)
  // Production : output × catchup_days
  // Mais : protection hors-ligne s'applique (section 6)
```

### 5.6 Performance

**Budget cible pour un serveur de 5000 joueurs :**

| Métrique | Cible | Calcul |
|----------|-------|--------|
| Joueurs par serveur | 5 000 | Max prévu Phase 2 |
| Parcelles par joueur (moy.) | 15 | 5000 × 15 = 75 000 parcelles |
| Animaux par joueur (moy.) | 80 | 5000 × 80 = 400 000 animaux |
| Temps par joueur | < 200ms | Phases 1-10 sérialisées |
| Temps total tick | < 15 min | 5000 × 200ms = 1000s ≈ 17 min (paralléliser) |
| Parallélisme | 10 workers | 17min / 10 = 1.7 min effective |

**Stratégie de parallélisation :**
```
// Les joueurs sont indépendants → parallélisation triviale
TICK_PARALLEL(server_id):
  players = get_active_players(server_id)
  chunks = split(players, 10)  // 10 workers

  PARALLEL FOR chunk IN chunks:
    FOR player IN chunk:
      TICK_DAILY_PLAYER(player)
  
  // Phase globale après tous les joueurs
  TICK_GLOBAL(server_id)
```

**Optimisations clés :**
- Batch les requêtes SQL (UPDATE animaux SET santé = ... WHERE player_id IN (...))
- Cache les données statiques (prix de base, paramètres météo)
- Skip les joueurs inactifs > 30 jours (flag `is_dormant`)
- Index sur `(server_id, player_id)` pour toutes les tables de jeu


---

## 6. Protection hors-ligne (ADR-002 — règle absolue)

### 6.1 Principe fondamental

> **Un joueur absent ne doit pas perdre sa progression sans prévenir, mais les conséquences biologiques (mort animale) s'appliquent conformément à la SdV §12.**

Le jeu est conçu pour 10-20 min/jour. La protection offre un filet de sécurité via les alertes et la dormance, mais **les animaux meurent en ~2 semaines sans nourriture** (Normal comme Expert, conformément à la SdV §12).

### 6.2 Mécanismes de protection (Normal)

| Durée d'absence | Protection active | Effet |
|:---------------:|:-----------------:|-------|
| 0-3 jours réels | Forte | Auto-nourrissage depuis stock. Production normale. |
| 4-7 jours réels | Modérée | Stock aliment consommé normalement. Si stock épuisé → achat auto secours (×1.5). Production continue. |
| 8-14 jours réels | Faible | Stock s'épuise → achat auto secours (×1.5). Si rupture prolongée (≥10j IG sans nourriture) → **animaux meurent** (SdV §12). Production -20%. Charges payées. |
| 15-30 jours réels | Minimale | Mode « vacances » auto : production suspendue, charges suspendues. Animaux en dormance (pas de consommation, pas de mort). |
| >30 jours réels | Dormance | Ferme gelée. Aucun tick. Le joueur revient et reprend exactement où il en était. |

### 6.3 Mécanismes de protection (Expert)

| Durée d'absence | Protection active | Effet |
|:---------------:|:-----------------:|-------|
| 0-3 jours réels | Modérée | Stock consommé normalement. Production normale. Pas d'auto-achat. |
| 4-7 jours réels | Faible | Stock s'épuise → pas d'auto-achat. Santé -5/jour si rupture. Production -30%. |
| 8-14 jours réels | Très faible | Si rupture aliment ≥10j IG → **animaux meurent** (SdV §12). Production suspendue. Charges courantes. |
| 15-30 jours réels | Minimale | Mode « vacances » auto : production suspendue, animaux en dormance, charges suspendues. |
| >30 jours réels | Dormance | Identique Normal : ferme gelée. |

### 6.4 Détection d'absence

```
// À chaque tick, vérifier la dernière connexion
last_login = player.last_login_at
days_absent = (NOW - last_login) / 24h

protection_level = CASE
  WHEN days_absent <= 3  THEN 'full'
  WHEN days_absent <= 7  THEN 'strong'
  WHEN days_absent <= 14 THEN 'moderate'
  WHEN days_absent <= 30 THEN 'vacation'
  ELSE 'dormant'
END

// Appliquer les modificateurs selon le niveau
IF protection_level == 'dormant':
  SKIP tick for this player entirely
  RETURN

IF protection_level == 'vacation':
  SKIP phases 3-9 (cultures, animaux, production, charges)
  EXECUTE phase 10 only (heures reset, seniority)
  RETURN
```

### 6.5 Mode vacances manuel

Le joueur peut activer manuellement le mode vacances (identique à l'absence 15-30j) :
- Durée : 3 à 30 jours réels
- Activation : instantanée, 1 clic
- Désactivation : retour à la normale au prochain tick
- Limite : max 60 jours de vacances par année de jeu (84 jours réels)
- Pas de pénalité au retour

### 6.6 Garantie — pas de perte définitive sans prévenir

**En mode Normal, le jeu prévient et offre des filets de sécurité, mais les conséquences biologiques s'appliquent :**
- ⚠️ Les animaux **meurent en ~2 semaines IG sans nourriture** (SdV §12) — mais l'auto-achat de secours (×1.5) retarde cette échéance tant que le joueur a du solde
- ❌ Aucune récolte ne pourrit (pause à maturité, attend le joueur)
- ❌ Aucune faillite (crédit auto si solde < 0, taux doux 3%)
- ❌ Aucun bâtiment ne s'effondre (usure plafonnée à 95%, jamais détruite)
- ✅ Le joueur revient et tout est récupérable en 2-3 sessions (sauf animaux morts par négligence prolongée)


---

## 7. Notifications et rappels

### 7.1 Philosophie

Les notifications doivent **informer**, pas **stresser**. Règle : max 3 notifications par jour. Aucune notification la nuit (22h-8h locale).

### 7.2 Types de notifications

| Priorité | Type | Exemple | Canal | Fréquence max |
|:--------:|------|---------|:-----:|:-------------:|
| 🔴 Critique | Stock aliment épuisé | « Vos poules n'ont plus d'aliment depuis 2j » | Push + email | 1/jour |
| 🔴 Critique | Solde négatif | « Votre solde est de -5 000€ » | Push + email | 1/semaine |
| 🟡 Important | Récolte prête | « Votre blé (parcelle Nord) est mûr » | Push | 1/événement |
| 🟡 Important | Animal malade | « 3 vaches sont malades (santé < 50) » | Push | 1/jour |
| 🟢 Info | Production du jour | « +850 œufs collectés aujourd'hui » | In-app | 1/tick |
| 🟢 Info | Changement de saison | « Le printemps commence ! Semis disponibles. » | In-app | 1/saison |
| ⚪ Rappel | Connexion | « Votre ferme vous attend ! 3 jours sans visite. » | Email | 1/3 jours |

### 7.3 Rapport de tick (in-app)

À chaque connexion, le joueur voit un résumé de ce qui s'est passé depuis sa dernière visite :

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 RAPPORT DU JOUR — Mardi 15 Mai (Printemps, Année 3)        │
│  ─────────────────────────────────────────────────────────────  │
│                                                                  │
│  🌾 Cultures                                                    │
│  • Blé (parcelle Nord, 12ha) : stade épiaison → floraison      │
│  • Maïs (parcelle Sud, 8ha) : stade levée (15% maturité)       │
│                                                                  │
│  🐄 Élevage                                                     │
│  • 30 vaches : production 720L de lait (+5% vs hier)           │
│  • Stock aliment : 2.1t restantes (≈ 12 jours)    ⚠️           │
│                                                                  │
│  🥚 Volaille                                                    │
│  • 200 poules : 1 190 œufs collectés                           │
│  • Stock aliment : 450kg (≈ 9 jours)                           │
│                                                                  │
│  💰 Finances                                                    │
│  • Revenus : +1 250€ (lait vendu auto)                         │
│  • Charges : -340€ (électricité, entretien)                    │
│  • Solde : 45 670€                                             │
│                                                                  │
│  ⚠️ ACTIONS RECOMMANDÉES                                        │
│  • Racheter de l'aliment bovin (stock < 14 jours)              │
│  • Récolter l'orge (parcelle Est) — mûre depuis 3 jours       │
│                                                                  │
│  🕐 Temps disponible : 12 h (février)                            │
└─────────────────────────────────────────────────────────────────┘
```

### 7.4 Règles anti-spam

- Le joueur peut désactiver TOUS les canaux sauf in-app
- Email de rappel : désactivable, jamais plus d'1/semaine
- Push : groupées (max 3/jour, regroupement intelligent)
- In-app : toujours disponible, jamais intrusive (badge + panneau)

---

## 8. Équilibrage et scénarios

### 8.1 Objectifs d'équilibrage

| Métrique | Cible Normal | Cible Expert | Justification |
|----------|:------------:|:------------:|---------------|
| Temps de session | 10-15 min | 15-25 min | Expert = plus de micro-décisions |
| Heures utilisées/jour (ferme moyenne) | 5-6 h / 10 h | 8-9 h / 10 h | Normal = marge confortable |
| Chantiers/jour (ferme 120 ha) | 2-4 chantiers | 4-8 chantiers | Expert = plus d'étapes par action |
| Chantiers/jour (60 vaches) | 2-3 chantiers | 4-6 chantiers | Expert = diagnostic + dosage |
| Connexions nécessaires/semaine | 5-6 (lundi-sam) | 6-7 (quasi quotidien) | Expert = suivi plus fin |
| Revenus mensuels (jeu) ferme 120 ha | 15 000-25 000 € | 12 000-20 000 € | Expert = charges +16% |

### 8.2 Scénario 1 — Ferme céréalière 120 ha, mode Normal

```
PROFIL : Céréalier, 120 ha (8 parcelles de 15 ha)
         Blé (60 ha) + Maïs (40 ha) + Colza (20 ha)
         1 salarié, matériel : tracteur 150 CV, charrue 5 corps, semoir combiné 4 m
         Capacité jour (pointe modérée, mars) : 10 h + 7 h = 17 h

JOURNÉE TYPE EN SAISON DE SEMIS (Mars — pointe modérée) :
  • Semer maïs, parcelle A (15 ha), semoir combiné 4 m :
      débit = 4 × 10 × 0,1 × 0,80 = 3,2 ha/h → durée = 15 / 3,2 = 4 h 41 min
  • Épandage engrais colza (20 ha), épandeur 18 m :
      débit = 18 × 14 × 0,1 × 0,85 = 21,4 ha/h → durée = 20 / 21,4 = 0 h 56 min
  • Transport semences (1 aller-retour, 5 km) : 0 h 35 min
  • Transport engrais (1 aller-retour, 5 km) : 0 h 35 min
  ─────────────────────────────────────────
  TOTAL HEURES CONSOMMÉES : 6 h 47 min / 17 h disponibles
  MARGE : 10 h 13 min (confortable ✅)

JOURNÉE TYPE HORS-SAISON (Janvier — cœur d'hiver) :
  • Entretien tracteur (vidange 500 h)     : 2 h 00 min
  • Vendre blé stocké (administratif)      : 0 h 05 min
  • Consulter concessionnaire (administratif) : 0 h 10 min
  ─────────────────────────────────────────
  TOTAL HEURES CONSOMMÉES : 2 h 15 min / 6 h disponibles
  MARGE : 3 h 45 min (très confortable ✅)

JOURNÉE TYPE EN MOISSON (Juillet — grande pointe) :
  • Moissonner blé, parcelle B (15 ha), moissonneuse coupe 6 m :
      débit = 6 × 5,5 × 0,1 × 0,75 = 2,475 ha/h → durée = 15 / 2,475 = 6 h 04 min
  • Transport récolte (15 ha × 80 q/ha = 120 t, benne 18 t, 8 km) :
      7 trajets A/R × 0 h 49 min = 5 h 43 min
  • Vendre blé (administratif)             : 0 h 05 min
  ─────────────────────────────────────────
  TOTAL SOUHAITÉ : 11 h 52 min
  PLUS : labourer parcelle récoltée (15 ha, charrue 5 corps) :
      débit = 1,75 × 7 × 0,1 × 0,80 = 0,98 ha/h → durée = 15 h 18 min
  TOTAL SOUHAITÉ AVEC LABOUR : 27 h 10 min / 84 h budget tick (exploitant seul)
  
  → Le tout passe en un seul tick (27 h < 84 h) ✅
  → Mais si le joueur a 145 ha à moissonner + labourer + semer sur le tick :
     Moisson 145 ha (18 h) + Transport (12 h) + Labour 145 ha (148 h) = 178 h
     Budget seul = 84 h → IMPOSSIBLE en un tick
     Budget + 1 ouvrier = 140 h → toujours insuffisant
     Budget + 2 ouvriers = 196 h → ça passe ✅
  
  → C'est voulu : sur 150 ha, le joueur DOIT investir (matériel ou personnel).
  → Avec une charrue 8 corps : 145 ha / 1,84 = 79 h au lieu de 148 h → ça passe avec 1 ouvrier.
```

### 8.3 Scénario 2 — Éleveur 60 vaches laitières, mode Expert

```
PROFIL : Éleveur laitier, 60 vaches + 30 ha de prairies
         2 salariés (1 élevage confirmé, 1 cultures confirmé)
         Salle de traite 2×8, robot racleur
         Capacité jour (pointe modérée, mai) : 10 h + 7 h + 7 h = 24 h

JOURNÉE TYPE (quotidien, mai) :
  • [Salarié élevage] Alimentation 60 vaches (mélangeuse) :
      durée = 45 min (chargement + distribution)                 : 0 h 45 min
  • [Salarié élevage] Traite matin (60 vaches, salle 2×8) :
      durée = (60/16) × 12 min + 25 min = 1 h 10 min            : 1 h 10 min
  • [Salarié élevage] Contrôle santé lot A (30 vaches) :         : 0 h 30 min
  • [Joueur] Diagnostic vache #23 (boiterie détectée)  :         : 0 h 30 min
  • [Joueur] Traitement vache #23                      :         : 0 h 20 min
  • [Joueur] Vérifier stock aliment + commande (admin) :         : 0 h 10 min
  • [Joueur] Vente lait du jour (admin)                :         : 0 h 05 min
  • [Salarié cultures] Fauche prairie 10 ha (faucheuse 3,2 m) :
      débit = 3,2 × 12 × 0,1 × 0,85 = 3,26 ha/h
      durée = 10 / 3,26 = 3 h 04 min                            : 3 h 04 min
  ─────────────────────────────────────────
  TOTAL HEURES CONSOMMÉES : 6 h 34 min / 24 h disponibles
  → Joueur : 1 h 05 min / 10 h (11% — TRÈS confortable)
  → Salarié élevage : 2 h 25 min / 7 h (35%)
  → Salarié cultures : 3 h 04 min / 7 h (44%)
  
  MARGE : 17 h 26 min non-utilisées → le joueur peut investir
  dans de nouvelles activités (agrandissement, diversification)

SEMAINE DE VÊLAGE (pic d'activité Expert) :
  • Chantiers quotidiens normaux              : 6 h 34 min
  • [Joueur] Surveillance vache en travail    : 1 h 00 min
  • [Joueur] Assistance vêlage               : 1 h 30 min
  • [Joueur] Soins veau nouveau-né           : 0 h 30 min
  • [Salarié élevage] Isolement mère + veau  : 0 h 30 min
  ─────────────────────────────────────────
  TOTAL HEURES CONSOMMÉES : 10 h 04 min / 24 h
  → Joueur : 4 h 35 min / 10 h (46% — actif mais pas débordé ✅)
```

### 8.4 Scénario 3 — Petit éleveur volaille, début de jeu, Normal

```
PROFIL : Débutant, 200 poules pondeuses + 1 poulailler
         Pas de salarié, pas de robot ramassage
         Capacité jour (hors pointe, février) : 8 h

JOURNÉE TYPE :
  • Nourrir poules (200 têtes, distribution manuelle) :
      durée = f(effectif=200, équipement=manuel) = 1 h 20 min
  • Ramasser œufs (manuel, 200 poules)       : 0 h 50 min
  • Vendre œufs au marché (administratif)    : 0 h 05 min
  • Transport aliment (1 aller-retour, 4 km) :
      durée = (4/25) × 2 + 10 min = 0 h 29 min
  ─────────────────────────────────────────
  TOTAL HEURES CONSOMMÉES : 2 h 44 min / 8 h disponibles
  MARGE : 5 h 16 min pour explorer, acheter, planifier ✅

APRÈS INSTALLATION ROBOT RAMASSAGE :
  • Nourrir poules (distribution manuelle)   : 1 h 20 min
  • Ramasser œufs (robot = 0 h)              : 0 h
  • Vendre œufs au marché                    : 0 h 05 min
  ─────────────────────────────────────────
  TOTAL HEURES CONSOMMÉES : 1 h 25 min / 8 h
  MARGE : 6 h 35 min → le joueur peut commencer une 2e activité ✅
  
  → Progression claire : investir dans l'automatisation
     libère du temps pour agrandir la ferme.
```

### 8.5 Checklist playtest

| Test | Critère | Bloquant ? |
|------|---------|:----------:|
| Test recette SimAgri | Un joueur SimAgri dit « c'est SimAgri en mieux » | ✅ OUI |
| Session < 20 min | Le joueur peut faire ses actions quotidiennes en < 20 min | ✅ OUI |
| Pas de FOMO | Absent 3 jours → aucune perte irréversible en Normal | ✅ OUI |
| Heures suffisantes | Ferme 120 ha : heures suffisantes 90% des jours (hors moisson) | ✅ OUI |
| Pic d'activité | La moisson DOIT être un moment tendu en temps (pas tout en 1 jour seul) | ✅ OUI |
| Expert ≠ punitif | Expert absent 7j → dégradation récupérable en 3 sessions | ✅ OUI |
| Tick < 15 min | 5000 joueurs, tick complet en < 15 min | ✅ OUI |
| Progression visible | Chaque connexion montre un changement (croissance, production, météo) | ✅ OUI |
| Notifications non-intrusives | Max 3 push/jour, 0 la nuit, tout désactivable | ✅ OUI |


---

## Annexe — Récapitulatif des paramètres

### A.1 Paramètres temporels

| Paramètre | Valeur | Variable |
|-----------|:------:|----------|
| Ratio temps | ×7 | `servers.time_ratio = 7` |
| Tick fréquence | 1/jour | `CRON: 0 0 * * * Europe/Paris` |
| Tick heure | 00:00 heure française | `TICK_HOUR = 0 (Europe/Paris)` |
| Jours par mois (jeu) | 30 | `DAYS_PER_MONTH = 30` |
| Mois par saison | 3 | `MONTHS_PER_SEASON = 3` |
| Jours réels par mois (jeu) | 7 | `REAL_DAYS_PER_MONTH = 7` |
| Jours réels par saison | 21 | `REAL_DAYS_PER_SEASON = 21` |
| Jours réels par année (jeu) | 84 | `REAL_DAYS_PER_YEAR = 84` |
| Max rattrapage tick | 21 jours de jeu | `MAX_CATCHUP_DAYS = 21` |

### A.2 Paramètres de capacité de main d'œuvre

| Paramètre | Normal | Expert | Variable |
|-----------|:------:|:------:|----------|
| Heures exploitant (cœur d'hiver) | 6 h | 6 h | `FARMER_HOURS_WINTER = 6` |
| Heures exploitant (hors pointe) | 8 h | 8 h | `FARMER_HOURS_OFFPEAK = 8` |
| Heures exploitant (pointe modérée) | 10 h | 10 h | `FARMER_HOURS_MODERATE = 10` |
| Heures exploitant (grande pointe) | 12 h | 12 h | `FARMER_HOURS_PEAK = 12` |
| Heures salarié/jour | 7 h | 7 h | `EMPLOYEE_HOURS = 7` |
| Max salariés | 5 | 5 | `MAX_EMPLOYEES = 5` |
| Coût salarié/mois | 2 200 € | 2 200 € | `EMPLOYEE_COST = 2200` |
| Report heures | Non | Non | `HOURS_CARRY_OVER = false` |
| Spécialisation salariés | Non | Oui | `EMPLOYEE_SPECIALIZATION = expert_only` |

### A.3 Paramètres protection hors-ligne

| Paramètre | Normal | Expert | Variable |
|-----------|:------:|:------:|----------|
| Protection complète | 3 jours | 3 jours | `FULL_PROTECTION_DAYS = 3` |
| Auto-nourrissage | Oui (depuis stock) | Non | `AUTO_FEED_NORMAL = true` |
| Auto-achat secours | Oui (×1.5) | Non | `AUTO_BUY_NORMAL = true` |
| Mort animale (≥2 sem. sans nourriture) | Oui (SdV §12) | Oui (SdV §12) | `ANIMAL_DEATH = true` |
| Mode vacances auto | 15 jours | 15 jours | `AUTO_VACATION_DAYS = 15` |
| Dormance | 30 jours | 30 jours | `DORMANT_DAYS = 30` |
| Limite vacances/an | 60 jours réels | 60 jours réels | `MAX_VACATION_PER_YEAR = 60` |

### A.4 Paramètres tick — phases

| Phase | Nom | Dépendances | Rollback possible |
|:-----:|-----|-------------|:-----------------:|
| 1 | Calendrier | Aucune | Oui |
| 2 | Météo | Phase 1 (date) | Oui |
| 3 | Cultures | Phase 1 (date), Phase 2 (météo) | Oui |
| 4 | Alimentation | Phase 1 (date) | Oui |
| 5 | Santé animaux | Phase 4 (alimentation) | Oui |
| 6 | Production | Phase 5 (santé) | Oui |
| 7 | Usure matériel | Phase 1 (date) | Oui |
| 8 | Charges | Phase 1 (date calendaire) | Oui |
| 9 | Marché | Phase 6 (offre globale) | Non (global) |
| 10 | Régénération heures de travail | Aucune | Oui |

### A.5 Paramètres notifications

| Paramètre | Valeur | Variable |
|-----------|:------:|----------|
| Max push/jour | 3 | `MAX_PUSH_PER_DAY = 3` |
| Heures silencieuses | 22h-8h locale | `QUIET_HOURS = [22, 8]` |
| Rappel connexion | Après 3 jours | `REMINDER_AFTER_DAYS = 3` |
| Max email/semaine | 1 | `MAX_EMAIL_PER_WEEK = 1` |
| Toutes désactivables | Oui (sauf in-app) | `ALL_CHANNELS_OPTIONAL = true` |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création du document | GDD fondateur du système temporel |
| 2026-08-04 | Section 4 réécrite : suppression des HT forfaitaires au profit de durées calculées | ADR-004 — le temps de travail est calculé, pas attribué |
