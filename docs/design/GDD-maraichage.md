> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Maraîchage

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : reality-vs-simagri-metiers.md §5, ADR-001, ADR-002, ADR-003, ADR-004

---

## 1. Vision et gameplay loop

### Intention de design

Le maraîchage est **l'opposé des grandes cultures**. Là où le céréalier gère 200 ha avec 0,5 UTH/ha et dégage 2 000 €/ha de CA, le maraîcher gère 2 ha avec 10 UTH/ha et dégage 80 000 €/ha. C'est la voie du joueur qui a **peu de terres mais du temps** (ou de l'argent pour embaucher).

**Plaisir procuré** : micro-management intensif, rotations rapides (cycle de 45 jours pour une salade vs 10 mois pour du blé), revenus fréquents, optimisation serrée de l'espace et du calendrier.

### Ce que SimAgri fait bien (à garder)

- Serres comme investissement structurant
- Chauffage comme coût d'exploitation réaliste
- Vente sur marchés (gameplay circuit court)
- Main d'œuvre spécialisée

### Ce que SimAgri fait mal (à corriger)

- Pas de saisonnalité des cultures (le légume = marché au jour le jour)
- Pas de distinction plein champ / sous abri
- Pas de diversité de cultures détaillée
- Pas de prix volatils
- Pas de périssabilité comme tension de gameplay

### Gameplay loop

```
┌─────────────────────────────────────────────────────────────────┐
│                    BOUCLE QUOTIDIENNE                            │
│                                                                 │
│  Récolter (échelonné) → Conditionner → Vendre (périssable !)   │
│       ↑                                                    │    │
│  Soins cultures (arrosage, palissage, désherbage)          │    │
│                                                            ↓    │
│                                              Invendus = pertes  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    BOUCLE MENSUELLE                              │
│                                                                 │
│  Planter nouvelle série → Suivre croissance → Planifier récolte │
│       ↑                                                    │    │
│  Préparer planches (travail du sol, paillage)              │    │
│                                                            ↓    │
│                                    Rotation : quelle culture ?  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    BOUCLE ANNUELLE                               │
│                                                                 │
│  Investir (serre, matériel) → Planifier assolement légumier     │
│       ↑                                                    │    │
│  Bilan : quels légumes ont été rentables ?                 │    │
│                                                            ↓    │
│                           Embaucher / former / agrandir ?        │
└─────────────────────────────────────────────────────────────────┘
```

### Décisions du joueur

| Décision | Fréquence | Enjeu |
|----------|:---------:|-------|
| Quel légume planter cette semaine ? | Hebdo | Saisonnalité, prix, rotation |
| Vendre où ? (marché, AMAP, GMS) | Hebdo | Prix vs volume vs régularité |
| Embaucher un saisonnier ? | Mensuel | Coût vs capacité de récolte |
| Investir dans un tunnel / une serre ? | Annuel | Précocité + rendement vs amortissement |
| Chauffer ou attendre la saison ? | Saisonnier | Coût énergie vs prime de précocité |

### Différences Normal / Expert (résumé)

| Aspect | Normal | Expert |
|--------|--------|--------|
| Légumes disponibles | 8 (les principaux) | 15 (avec successions) |
| Périssabilité | Douce (-10%/jour après DLC) | Réaliste (perte totale après DLC) |
| Vente | Automatique au prix du jour | Choix du canal, négociation |
| Climat serre | Automatique | Pilotage T°/hygrométrie |
| Successions culturales | Libres | Contraintes agronomiques |
| Charges | 12% forfait | 28% détaillées |

---

## 2. Les 4 systèmes maraîchers

### Tableau comparatif

| Critère | Plein champ industriel | Sous abri chauffé | Sous abri froid / tunnel | Diversifié bio |
|---------|:---------------------:|:-----------------:|:------------------------:|:--------------:|
| **Surface type** | 10-100 ha | 0,5-5 ha | 1-10 ha | 1-5 ha |
| **Investissement/ha** | 5 000-15 000 € | 500 000-1 000 000 € | 50 000-150 000 € | 20 000-50 000 € |
| **CA/ha** | 8 000-30 000 € | 80 000-150 000 € | 30 000-80 000 € | 40 000-80 000 € |
| **UTH/ha** | 1-3 | 8-15 | 5-10 | 5-12 |
| **Cultures phares** | Carotte, oignon, poireau, chou | Tomate, concombre, poivron | Salade, fraise, courgette | 30-50 espèces |
| **Commercialisation** | GMS, industrie | GMS, marché de gros | Circuit court, GMS | AMAP, marchés, vente ferme |
| **Mécanisation** | Élevée (récolteuses) | Moyenne (palissage manuel) | Faible | Très faible |
| **Disponibilité Agriva** | Normal + Expert | Expert uniquement | Normal + Expert | Expert uniquement |

### Plein champ industriel

Grosses surfaces, cultures rustiques, mécanisation poussée. C'est le maraîchage « facile » : peu de main d'œuvre par hectare, mais marges faibles. Adapté au joueur qui a déjà des terres en grandes cultures et veut diversifier.

**Cultures** : carotte, oignon, poireau, chou, betterave potagère, navet.
**Matériel clé** : planteuse mécanique, bineuse de précision, récolteuse spécialisée.
**Risque** : prix bas (GMS impose), météo (pas de protection).

### Sous abri chauffé

L'investissement le plus lourd du jeu (hors foncier). Serre verre ou multichapelle avec chauffage : le joueur produit des tomates en mars quand le prix est à 3,50 €/kg au lieu de 0,80 €/kg en été. ROI sur 8-12 ans.

**Cultures** : tomate (70% de la surface chauffée en France), concombre, poivron, aubergine.
**Contrainte** : coût énergie = 15-25% du CA. Le joueur doit piloter température et ventilation.
**Récompense** : CA de 100 000-150 000 €/ha, calendrier de production étendu (10 mois/an).

### Sous abri froid / tunnel plastique

Le compromis : protection contre le gel et la pluie, précocité de 3-6 semaines, sans le coût du chauffage. C'est l'entrée dans le maraîchage pour la plupart des joueurs.

**Cultures** : salade, fraise, courgette, melon, concombre, haricot vert.
**Avantage** : investissement modéré (80 000 €/ha), amortissement rapide (5-7 ans).
**Limite** : pas de production hivernale sans chauffage d'appoint.

### Diversifié bio

Le gameplay « jardin géant » : 30 à 50 espèces sur 1 à 5 ha, vente directe, lien social fort. Très intensif en travail manuel, faible mécanisation. C'est la voie du joueur qui veut jouer à fond le circuit court et la relation client.

**Spécificité** : pas d'intrants chimiques, rotations longues obligatoires, associations de cultures.
**Commercialisation** : AMAP (panier hebdo garanti), marchés, vente à la ferme.
**Revenu** : CA élevé par ha mais travail énorme (12 UTH/ha).


---

## 3. Serres et abris

### Types d'infrastructures

| Infrastructure | Prix/ha | Durée de vie | Cultures possibles | Gain précocité | Mode |
|---------------|:-------:|:------------:|-------------------|:--------------:|:----:|
| Tunnel plastique simple | 80 000 € | 8 ans (bâche 4 ans) | Salade, fraise, courgette, melon | +3 semaines | Normal |
| Tunnel plastique double paroi | 120 000 € | 10 ans (bâche 5 ans) | Idem + tomate non chauffée | +4 semaines | Normal |
| Multichapelle plastique | 200 000 € | 15 ans | Tomate, concombre, poivron, aubergine | +6 semaines | Expert |
| Serre verre (Venlo) | 500 000 € | 25 ans | Tomate hors-sol, concombre, fleurs | +8 semaines | Expert |

### Mécanique de construction

**Normal** : le joueur achète un abri, il est opérationnel immédiatement. Coût = prix d'achat. Entretien annuel = 3% du prix.

**Expert** : construction en 2 étapes (terrassement + montage). Durée de chantier = 5-15 jours selon type. Entretien détaillé (bâche à changer tous les 4-5 ans = 15 000 €/ha, structure vérifiée après tempête).

### Paramètres techniques

```
surface_couverte = nb_tunnels × longueur × largeur
  Tunnel standard : 8 m × 50 m = 400 m² (0,04 ha)
  Multichapelle : 9,60 m × 100 m × nb_chapelles

capacité_culture = surface_couverte × densité_plantation
  Tomate : 2,5 plants/m² = 25 000 plants/ha
  Salade : 16 plants/m² = 160 000 plants/ha
  Fraise : 8 plants/m² = 80 000 plants/ha
```

### Effet de la précocité sur les prix

La précocité permet de vendre **avant la pleine saison**, quand les prix sont élevés :

| Période | Tomate plein champ | Tomate tunnel froid | Tomate serre chauffée |
|---------|:------------------:|:-------------------:|:---------------------:|
| Mars | — | — | 3,50 €/kg |
| Avril | — | — | 2,80 €/kg |
| Mai | — | 2,20 €/kg | 2,00 €/kg |
| Juin | 1,50 €/kg | 1,50 €/kg | 1,50 €/kg |
| Juillet-Août | 0,80 €/kg | 0,80 €/kg | 0,80 €/kg |
| Septembre | 1,20 €/kg | 1,20 €/kg | 1,20 €/kg |
| Octobre | — | 1,80 €/kg | 1,80 €/kg |
| Novembre | — | — | 2,50 €/kg |

**Formule prix saisonnier** :
```
prix_légume(date) = prix_base × coefficient_saisonnier(date)
  coefficient_saisonnier :
    hors_saison_total  = 3,0 à 4,0  (serre chauffée uniquement)
    début_saison       = 2,0 à 2,5  (sous abri)
    pleine_saison      = 1,0         (tout le monde produit)
    fin_saison         = 1,5 à 2,0  (sous abri prolonge)
```

---

## 4. Le chauffage

### Systèmes de chauffage

| Système | Investissement/ha | Coût énergie/ha/an | Rendement | Disponibilité |
|---------|:-----------------:|:------------------:|:---------:|:------------:|
| Chaudière gaz naturel | 80 000 € | 25 000-40 000 € | ×1,0 (référence) | Normal |
| Chaudière bois déchiqueté | 120 000 € | 12 000-18 000 € | ×1,0 | Normal |
| Géothermie (pompe à chaleur) | 250 000 € | 8 000-12 000 € | ×1,0 | Expert |
| Récupération chaleur méthanisation | 50 000 € (raccord) | 3 000-5 000 € | ×1,0 | Expert |

### Impact du chauffage

Le chauffage permet :
1. **Production hivernale** : récolte de novembre à mars (prime de prix ×2,5-4,0)
2. **Gain de rendement** : +20-30% sur tomate/concombre (température optimale constante)
3. **Réduction maladies** : hygrométrie contrôlée → -50% traitements

### Coût énergétique annuel (poste n°2)

```
coût_chauffage_annuel = surface_chauffée × besoin_thermique × prix_énergie

  besoin_thermique (kWh/m²/an) :
    Tunnel plastique chauffé hors gel  : 100-150 kWh/m²
    Multichapelle chauffée 14°C       : 250-350 kWh/m²
    Serre verre chauffée 18°C         : 400-500 kWh/m²

  prix_énergie (€/kWh) :
    Gaz naturel     : 0,08 €/kWh
    Bois déchiqueté : 0,04 €/kWh
    Géothermie      : 0,025 €/kWh (après investissement)
    Méthanisation   : 0,015 €/kWh (sous-produit)

Exemple — 1 ha de serre verre chauffée à 18°C au gaz :
  Consommation : 10 000 m² × 450 kWh/m² = 4 500 000 kWh/an
  Coût          : 4 500 000 kWh × 0,08 €/kWh = 360 000 €/an
  Soit 36 €/m²/an

⚠️ Le chauffage est le poste de charges N°1 de la serre chauffée — devant la main
   d'œuvre. Sur une serre à tomate produisant 726 000 € de CA, il représente 50% des
   charges. C'est ce qui rend ce système extrêmement sensible au prix de l'énergie.

Comparaison des sources pour la même serre (1 ha, 4 500 000 kWh) :
  Gaz naturel     : 360 000 €/an
  Bois déchiqueté : 180 000 €/an  (mais chaudière 120 000 € + stockage + manutention)
  Géothermie      : 112 500 €/an  (mais forage 400 000-800 000 €)
  Méthanisation    :  67 500 €/an  (si le joueur possède une unité — synergie forte)
```

### Pilotage climatique (Expert uniquement)

En mode Expert, le joueur pilote la consigne de température :
- **Température jour** : 18-24°C (tomate optimale = 22°C)
- **Température nuit** : 14-18°C (abaissement = économie 15-25%)
- **Ventilation** : ouverture ouvrants si T > 28°C
- **Hygrométrie** : brumisation si HR < 60%, ventilation si HR > 85%

Un mauvais pilotage entraîne :
- T° trop basse : croissance ralentie (-2% rendement par °C en dessous de l'optimum)
- T° trop haute : avortement floral (tomate > 32°C = -30% nouaison)
- HR trop haute : botrytis, mildiou (+50% risque maladie)

En mode Normal : le pilotage est automatique (coût énergie fixe, rendement standard).


---

## 5. Catalogue de légumes

### Tableau des cultures maraîchères

| # | Légume | Rendement (t/ha) | Prix moy (€/kg) | Cycle (jours) | Saison plein champ | MO (h/ha) | Périssabilité (jours) | Mode |
|:-:|--------|:----------------:|:----------------:|:-------------:|:------------------:|:---------:|:---------------------:|:----:|
| 1 | Tomate | 80-150 | 1,20 | 150 | Juin-Oct | 3 500 | 10 | N |
| 2 | Salade (laitue) | 30-40 | 0,80 | 45 | Avr-Nov | 1 200 | 5 | N |
| 3 | Carotte | 40-60 | 0,60 | 120 | Juin-Nov | 400 | 60 | N |
| 4 | Courgette | 30-50 | 0,90 | 60 | Juin-Sept | 1 800 | 7 | N |
| 5 | Fraise | 20-35 | 3,50 | 90 (pérenne) | Mai-Oct | 4 000 | 3 | N |
| 6 | Concombre | 60-100 | 0,70 | 120 | Mai-Sept | 2 800 | 7 | N |
| 7 | Poireau | 25-35 | 1,50 | 180 | Sept-Mars | 600 | 30 | N |
| 8 | Oignon | 40-60 | 0,50 | 150 | Juil-Sept | 300 | 180 | N |
| 9 | Poivron | 40-60 | 2,00 | 140 | Juil-Oct | 3 200 | 14 | E |
| 10 | Aubergine | 40-60 | 1,80 | 140 | Juil-Oct | 2 800 | 10 | E |
| 11 | Melon | 20-30 | 1,50 | 100 | Juil-Sept | 1 500 | 10 | E |
| 12 | Haricot vert | 8-12 | 2,50 | 60 | Juin-Sept | 2 000 | 4 | E |
| 13 | Radis | 15-20 | 1,80 | 25 | Mars-Nov | 800 | 5 | E |
| 14 | Chou-fleur | 20-30 | 1,20 | 120 | Sept-Avr | 500 | 14 | E |
| 15 | Épinard | 15-20 | 2,00 | 45 | Mars-Nov | 600 | 3 | E |

> N = disponible en Normal, E = Expert uniquement.

### Légende et notes

- **Rendement** : sous abri pour les cultures d'abri (tomate, concombre), plein champ sinon.
- **Prix moy** : prix moyen annuel en pleine saison. Hors saison = ×2-4 (cf. §3).
- **MO (h/ha)** : heures totales sur le cycle complet (plantation + soins + récolte).
- **Périssabilité** : nombre de jours après récolte avant perte de valeur (Normal) ou perte totale (Expert).

### Détail des besoins en main d'œuvre par poste (exemple : tomate sous abri, 1 ha)

| Opération | Heures/ha | Période | Fréquence |
|-----------|:---------:|---------|:---------:|
| Préparation sol / substrat | 150 | Février | 1× |
| Plantation | 200 | Mars | 1× |
| Palissage (tuteurage) | 600 | Mars-Oct | Hebdo |
| Effeuillage | 300 | Avr-Oct | Bimensuel |
| Récolte | 1 500 | Mai-Oct | 2-3×/semaine |
| Désherbage / entretien | 400 | Continu | Hebdo |
| Traitements phyto | 150 | Continu | Bimensuel |
| Conditionnement | 200 | Mai-Oct | Chaque récolte |
| **TOTAL** | **3 500** | | |

Ce total de 3 500 h/ha équivaut à **2,1 UTH à temps plein** rien que pour 1 ha de tomate. À comparer : 1 ha de blé = 5 h/ha total.


---

## 6. Le travail — LA contrainte du maraîchage

### Principe (ADR-004)

Le temps de travail est **calculé, jamais forfaitaire**. En maraîchage, le calcul dérive de :

```
durée_opération = surface × coefficient_culture × f_mécanisation × f_conditions

Où :
  coefficient_culture = heures de base par ha pour cette opération sur ce légume
  f_mécanisation = 1,0 (manuel) / 0,6 (outil attelé) / 0,3 (machine spécialisée)
  f_conditions = 1,0 (normal) / 1,3 (sol humide) / 0,8 (paillage plastique)
```

### Pourquoi ça impose d'embaucher

**Démonstration : 1 ha de tomate sous tunnel froid**

```
Capacité exploitant seul :
  Grande pointe (juin-août) : 12 h/jour × 26 jours = 312 h/mois
  Pointe modérée (mai, sept) : 12 h/jour × 26 jours = 312 h/mois

Besoin récolte seule (pleine production, juillet) :
  Rendement : 150 t/ha sur 5 mois = 30 t/mois = 1 000 kg/jour (sur 30 jours)
  Cadence récolte manuelle : 80-120 kg/h (tomate grappe)
  → 1 000 / 100 = 10 h/jour JUSTE pour la récolte

Autres tâches quotidiennes juillet (1 ha) :
  Palissage : 2 h/jour
  Effeuillage : 1 h/jour
  Arrosage + fertigation : 0,5 h/jour
  Conditionnement : 2 h/jour
  → 5,5 h/jour supplémentaires

TOTAL besoin juillet : 10 + 5,5 = 15,5 h/jour
Capacité exploitant : 12 h/jour
DÉFICIT : 3,5 h/jour → IMPOSSIBLE SEUL
```

**Conclusion** : à partir de 0,7 ha de tomate sous abri, l'exploitant DOIT embaucher au moins 1 salarié en été. C'est la réalité du métier et c'est la contrainte de gameplay.

### Seuils d'embauche par système

| Système | Surface seul (max) | 1 salarié | 2 salariés | 5 salariés |
|---------|:------------------:|:---------:|:----------:|:----------:|
| Tunnel froid (salade) | 0,5 ha | 1,5 ha | 3 ha | 7 ha |
| Tunnel froid (tomate) | 0,7 ha | 1,5 ha | 2,5 ha | 5 ha |
| Serre chauffée (tomate) | 0,5 ha | 1,2 ha | 2 ha | 4 ha |
| Plein champ (carotte) | 5 ha | 15 ha | 30 ha | 60 ha |
| Diversifié bio | 0,8 ha | 2 ha | 3,5 ha | — |

### Coût de la main d'œuvre

```
Salarié permanent : 26 000 €/an charges comprises (SMIC + charges 42%)
  → 8 h/jour, 5 jours/semaine = 2 080 h/an
  → Coût horaire chargé : 14,30 €/h

Saisonnier (CDD 6 mois) : 14 500 € charges comprises
  → 8 h/jour, 5 jours/semaine = 1 040 h sur 6 mois
  → Coût horaire chargé : 15,90 €/h (plus cher car turnover)

Contrat saisonnier TODE (exonération) : 12 000 € net employeur / 6 mois
  → Coût horaire chargé : 13,20 €/h
```

### Répartition annuelle du travail (1 ha tomate tunnel froid)

```
        h/mois
  400 ┤                    ████
      │                ████████████
  300 ┤            ████████████████████
      │        ████████████████████████████
  200 ┤    ████████████████████████████████████
      │████████████████████████████████████████████
  100 ┤████████████████████████████████████████████████
      │████████████████████████████████████████████████████
    0 ┼──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──
      Jan Fév Mar Avr Mai Jun Jul Aoû Sep Oct Nov Déc

  ── Capacité exploitant seul (12 h/jour fixe)
  ██ Besoin réel en heures

  Pic juillet : 400 h → il faut 2,5 personnes à temps plein
  Creux janvier : 40 h → 1 personne à mi-temps suffit
```

### Impact sur le gameplay

Le maraîchage force le joueur à :
1. **Embaucher** — impossible de tout faire seul au-delà de 0,5-1 ha
2. **Planifier** — les pics de travail sont prévisibles (récolte = pointe)
3. **Arbitrer** — salarié permanent (coûteux mais fiable) vs saisonnier (moins cher mais disponibilité)
4. **Investir en mécanisation** — une planteuse divise le temps de plantation par 3


---

## 7. Matériel maraîcher spécifique

### Catalogue matériel

| Matériel | Prix neuf | Durée de vie | Effet | Mode |
|----------|:---------:|:------------:|-------|:----:|
| Motoculteur 15 CV | 8 000 € | 15 ans | Travail du sol < 3 ha, débit 0,15 ha/h | N |
| Tracteur maraîcher 50 CV | 35 000 € | 20 ans | Traction outils, débit variable | N |
| Planteuse à légumes 2 rangs | 12 000 € | 12 ans | Plantation ×3 plus rapide (f_méca = 0,33) | N |
| Planteuse 4 rangs automatique | 45 000 € | 12 ans | Plantation ×5 plus rapide (f_méca = 0,20) | E |
| Bineuse de précision (guidage caméra) | 25 000 € | 10 ans | Désherbage mécanique (f_méca = 0,30) | N |
| Récolteuse à carottes | 120 000 € | 12 ans | Récolte carotte/oignon, débit 0,8 ha/h | E |
| Récolteuse à poireaux | 80 000 € | 12 ans | Récolte poireaux, débit 0,4 ha/h | E |
| Station de lavage | 40 000 € | 15 ans | Conditionnement ×4 plus rapide | N |
| Calibreuse / trieuse | 60 000 € | 15 ans | Tri automatique (calibre + qualité) | E |
| Chambre froide 50 m³ | 25 000 € | 20 ans | Prolonge périssabilité ×2 | N |
| Chambre froide 200 m³ | 80 000 € | 20 ans | Prolonge périssabilité ×2, stocke 40 t | E |
| Irrigation goutte-à-goutte | 5 000 €/ha | 8 ans | Économie eau 40%, rendement +10% | N |
| Fertigation automatisée | 15 000 € | 10 ans | Pilotage nutrition (Expert : optimisation) | E |

### Effet de la mécanisation sur le temps (ADR-004)

```
Exemple : planter 1 ha de poireaux (densité 200 000 plants/ha)

  À la main (2 personnes) :
    cadence = 400 plants/h/personne
    durée = 200 000 / (400 × 2) = 250 h

  Planteuse 2 rangs (1 conducteur + 2 poseurs) :
    cadence = 3 000 plants/h
    durée = 200 000 / 3 000 = 67 h (÷3,7)

  Planteuse 4 rangs automatique (1 conducteur + 1 chargeur) :
    cadence = 8 000 plants/h
    durée = 200 000 / 8 000 = 25 h (÷10)
```

Le matériel maraîcher offre des gains de temps **considérables** — bien plus qu'en grandes cultures (où le gain est de ×1,5-2). C'est ce qui justifie l'investissement malgré les petites surfaces.

---

## 8. Commercialisation

### Les canaux de vente

| Canal | Prix obtenu | Volume max | Régularité | Contrainte | Mode |
|-------|:----------:|:----------:|:----------:|------------|:----:|
| Marché de producteurs | ×1,8-2,5 du prix GMS | 500 kg/marché | 2×/semaine | Temps de vente (4 h/marché) | N |
| AMAP (panier hebdo) | ×1,5-2,0 | Fixe (nb adhérents × 8 kg) | Garanti 1×/semaine | Engagement variété | E |
| Vente à la ferme / drive | ×1,5-2,0 | Variable | Continue | Investissement magasin/site | N |
| GMS (supermarché) | ×1,0 (référence) | Illimité | Contrat | Cahier des charges, calibre | N |
| Grossiste / MIN | ×0,7-0,9 | Illimité | Quotidien | Prix très volatil | E |
| Restauration | ×1,5-2,0 | Faible (100-500 kg/sem) | Contrat | Livraison quotidienne | E |

### La tension périssabilité

```
┌─ PÉRISSABILITÉ — Le chrono tourne ─────────────────────────────┐
│                                                                │
│  🍅 Récolte J+0     État : ████████████ FRAIS (100%)          │
│  📦 Stock  J+3      État : █████████░░ BON (85%)              │
│  ⚠️  Stock  J+7      État : ██████░░░░░ CORRECT (60%)          │
│  🔴 Stock  J+10     État : ███░░░░░░░░ LIMITE (30%)           │
│  ❌ Perte  J+11     INVENDABLE — perte sèche                  │
│                                                                │
│  💡 Chambre froide : ×2 les durées ci-dessus                   │
│                                                                │
│  MODE NORMAL : valeur diminue de 10%/jour après le seuil      │
│  MODE EXPERT : perte TOTALE après la DLC                       │
└────────────────────────────────────────────────────────────────┘
```

### Prix de vente en jeu

```
prix_vente_final = prix_base × coeff_saisonnier × coeff_canal × coeff_fraîcheur

  coeff_canal :
    Marché         = 2,0
    AMAP           = 1,7
    Vente ferme    = 1,8
    GMS            = 1,0
    Grossiste      = 0,8

  coeff_fraîcheur (Expert) :
    0 à 50% de la DLC  = 1,0
    50 à 80% de la DLC = 0,8
    80 à 100% de la DLC = 0,5
    > 100% de la DLC    = 0 (perte)

  coeff_fraîcheur (Normal) :
    0 à 100% de la DLC = 1,0
    > DLC : -10% par jour (minimum 0,3 puis invendu à J+DLC+7)
```

### Mockup interface de vente (Normal)

```
┌─ 🥬 Vente du jour — Mardi 15 juin ──────────────────────────────┐
│                                                                  │
│  Stock disponible :                                              │
│  ┌──────────────┬────────┬──────────┬──────────┬──────────────┐  │
│  │ Légume       │ Qté    │ Prix GMS │ Fraîcheur│ Action       │  │
│  ├──────────────┼────────┼──────────┼──────────┼──────────────┤  │
│  │ 🍅 Tomate    │ 850 kg │ 1,20 €   │ ████ 4j  │ [Vendre]    │  │
│  │ 🥬 Salade    │ 300 kg │ 0,80 €   │ ██ 2j    │ [Vendre]    │  │
│  │ 🥒 Courgette │ 420 kg │ 0,90 €   │ ███ 3j   │ [Vendre]    │  │
│  │ 🫑 Poivron   │ 180 kg │ 2,00 €   │ █████ 6j │ [Vendre]    │  │
│  └──────────────┴────────┴──────────┴──────────┴──────────────┘  │
│                                                                  │
│  Canal de vente : [Marché ▼] (prix ×2,0)     📅 Prochain : Jeu  │
│                                                                  │
│  💰 Recette estimée : 3 500 €                                    │
│  ⏱️  Temps de vente : 4 h (déplacement + stand)                  │
│                                                                  │
│  [ Tout vendre au marché ]  [ Vente auto GMS ]                   │
└──────────────────────────────────────────────────────────────────┘
```

### Mockup interface de vente (Expert)

```
┌─ 🥬 Gestion commerciale — Semaine 24 ───────────────────────────┐
│                                                                  │
│  CANAUX ACTIFS :                                                 │
│  ┌─────────────┬──────────┬────────────┬────────────┬─────────┐  │
│  │ Canal       │ Capacité │ Prix moyen │ Engagé     │ Statut  │  │
│  ├─────────────┼──────────┼────────────┼────────────┼─────────┤  │
│  │ Marché Mar  │ 500 kg   │ ×2,0       │ —          │ ✅ Actif│  │
│  │ Marché Sam  │ 500 kg   │ ×2,0       │ —          │ ✅ Actif│  │
│  │ AMAP (32p)  │ 256 kg   │ ×1,7       │ 256 kg/sem │ 🔒 Fixe│  │
│  │ GMS Leclerc │ ∞        │ ×1,0       │ 500 kg/sem │ ⚠️ Min │  │
│  │ Resto "Le P"│ 80 kg    │ ×1,8       │ 80 kg/sem  │ ✅ Actif│  │
│  └─────────────┴──────────┴────────────┴────────────┴─────────┘  │
│                                                                  │
│  PLANIFICATION CETTE SEMAINE :                                   │
│  ┌──────────────┬────────┬───────────────────────────────────┐   │
│  │ Légume       │ Stock  │ Répartition                       │   │
│  ├──────────────┼────────┼───────────────────────────────────┤   │
│  │ 🍅 Tomate    │ 2.1 t  │ AMAP 100kg │ GMS 500 │ Marché 800│   │
│  │ 🥬 Salade    │ 0.8 t  │ AMAP 80kg  │ Marché 400│ Reste 320│   │
│  │ 🥒 Concombre │ 1.5 t  │ AMAP 76kg  │ GMS 500 │ Grossiste │   │
│  └──────────────┴────────┴───────────────────────────────────┘   │
│                                                                  │
│  ⚠️  ALERTES :                                                    │
│  • Salade : DLC dans 2 jours — vendre AUJOURD'HUI (320 kg)      │
│  • Engagement GMS non tenu semaine dernière → pénalité -5%       │
│                                                                  │
│  [ Valider plan ]  [ Tout en GMS ]  [ Brader le surplus ]        │
└──────────────────────────────────────────────────────────────────┘
```


---

## 9. Équilibrage et scénarios

### Objectifs d'équilibrage

| Objectif | Cible | Justification |
|----------|:-----:|---------------|
| CA/ha maraîchage vs grandes cultures | ×15-60 | Réaliste (30-150k€/ha vs 2k€/ha) |
| Marge nette/ha maraîchage | 5 000-30 000 €/ha | Après charges MO + énergie + intrants |
| Temps requis/ha (sous abri) | 2 000-4 000 h/ha/an | Force l'embauche (1 personne = 1 820 h/an) |
| Retour sur investissement serre | 5-10 ans | Assez rapide pour motiver, assez lent pour risquer |
| Perte périssabilité (Expert) | 5-15% production | Tension sans punition excessive |
| Avantage circuit court vs GMS | +60-100% prix | Contre-balancé par le temps de vente + volume limité |

### Tableau comparatif des 4 systèmes (équilibre)

| Indicateur | Plein champ 20 ha | Tunnel froid 2 ha | Serre chauffée 1 ha | Diversifié bio 2 ha |
|-----------|:-----------------:|:-----------------:|:-------------------:|:-------------------:|
| Investissement total | 200 000 € | 240 000 € | 700 000 € | 140 000 € |
| CA annuel | 400 000 € | 140 000 € | 130 000 € | 120 000 € |
| Charges MO | 120 000 € | 56 000 € | 52 000 € | 72 000 € |
| Charges énergie | 0 € | 5 000 € | 30 000 € | 0 € |
| Charges intrants | 40 000 € | 12 000 € | 15 000 € | 8 000 € |
| Autres charges | 48 000 € | 17 000 € | 13 000 € | 14 000 € |
| **Bénéfice avant charges sociales** | **192 000 €** | **50 000 €** | **20 000 €** | **26 000 €** |
| Charges sociales (12% N / 28% E) | -23 040 € (N) | -6 000 € (N) | -5 600 € (E) | -7 280 € (E) |
| **Résultat net** | **168 960 €** | **44 000 €** | **14 400 €** | **18 720 €** |
| Résultat net/ha | 8 448 €/ha | 22 000 €/ha | 14 400 €/ha | 9 360 €/ha |
| UTH nécessaires | 8 | 4 | 3,5 | 5 |
| Complexité gameplay | ★★☆ | ★★★ | ★★★★★ | ★★★★ |

---

### Scénario 1 : Tunnel froid 2 ha bio, vente en AMAP + marchés

**Profil** : joueur intermédiaire, peu de foncier, veut du circuit court.

#### Investissement initial

| Poste | Coût |
|-------|:----:|
| 5 tunnels plastique double paroi (2 ha) | 240 000 € |
| Motoculteur 15 CV | 8 000 € |
| Irrigation goutte-à-goutte (2 ha) | 10 000 € |
| Bineuse de précision | 25 000 € |
| Station de lavage | 40 000 € |
| Chambre froide 50 m³ | 25 000 € |
| **TOTAL investissement** | **348 000 €** |

#### Assolement (2 ha sous tunnel froid)

| Culture | Surface | Cycles/an | Rendement/cycle | Production annuelle |
|---------|:-------:|:---------:|:---------------:|:-------------------:|
| Salade | 0,5 ha | 5 | 35 t/ha | 87,5 t |
| Tomate | 0,6 ha | 1 | 120 t/ha | 72 t |
| Fraise | 0,3 ha | 1 (pérenne) | 25 t/ha | 7,5 t |
| Courgette | 0,3 ha | 2 | 40 t/ha | 24 t |
| Concombre | 0,3 ha | 1 | 80 t/ha | 24 t |

#### Calcul du CA (vente 60% marchés, 30% AMAP, 10% GMS)

```
Salade :    87,5 t × 0,80 €/kg × coeff_moyen(1,85) = 129 500 €
Tomate :    72 t × 1,20 €/kg × coeff_moyen(1,85)   = 159 840 €
Fraise :    7,5 t × 3,50 €/kg × coeff_moyen(1,85)  =  48 563 €
Courgette : 24 t × 0,90 €/kg × coeff_moyen(1,85)   =  39 960 €
Concombre : 24 t × 0,70 €/kg × coeff_moyen(1,85)   =  31 080 €

  coeff_moyen = 0,6×2,0 + 0,3×1,7 + 0,1×1,0 = 1,81 (arrondi 1,85 avec prime bio +5%)

CA BRUT TOTAL = 408 943 €
Perte périssabilité estimée (Expert, 10%) : -40 894 €
CA NET = 368 049 €
```

#### Charges annuelles

| Poste | Montant | % CA |
|-------|:-------:|:----:|
| Main d'œuvre (4 salariés permanents) | 104 000 € | 28% |
| Main d'œuvre saisonnière (2 × 6 mois) | 29 000 € | 8% |
| Plants et semences | 18 000 € | 5% |
| Intrants bio (compost, auxiliaires) | 8 000 € | 2% |
| Énergie (hors gel) | 5 000 € | 1% |
| Entretien tunnels (bâches 15k€/4 ans) | 7 500 € | 2% |
| Eau | 4 000 € | 1% |
| Commercialisation (transport, stands) | 8 000 € | 2% |
| Amortissement équipement (hors tunnels) | 10 800 € | 3% |
| Amortissement tunnels (240k€ / 10 ans) | 24 000 € | 7% |
| **TOTAL charges** | **218 300 €** | **59%** |

#### Résultat

```
CA net :                        368 049 €
Charges d'exploitation :       -218 300 €
────────────────────────────────────────
Bénéfice avant charges sociales 149 749 €
Charges sociales (12% Normal) :  -17 970 €
────────────────────────────────────────
RÉSULTAT NET :                  131 779 €

Marge nette / ha :               65 890 €/ha
Marge nette / UTH :              21 963 €/UTH (6 UTH au total)
ROI investissement :             348 000 / 131 779 = 2,6 ans

VERDICT : très rentable mais EXTRÊMEMENT intensif en travail.
Le joueur gère 6 personnes + 2 marchés/semaine + rotation 5 cultures.

⚠️ Point d'équilibrage : 131 779 € dépasse largement la cible de 38-50 k€ des
autres filières. C'est justifié par trois contraintes qui n'existent nulle part
ailleurs dans le jeu :
  1. 8 020 h de travail annuel (vs 2 100 h en bovin laitier) → 6 personnes à gérer
  2. Périssabilité : tout invendu est perdu sous 3-7 jours
  3. Dépendance commerciale : il faut TROUVER les clients (2 marchés/semaine,
     50 paniers AMAP hebdomadaires à honorer sans rupture)

Si le joueur rate sa commercialisation, le CA s'effondre : à 60% d'écoulement,
le résultat net tombe à 43 600 €. C'est le système au risque commercial le plus élevé.
```

#### Temps de travail (ADR-004)

```
Besoin annuel total (2 ha tunnel, 5 cultures) :
  Salade :    0,5 ha × 1 200 h/ha × 5 cycles = 3 000 h (simplifié : soins réduits par cycle)
              → réaliste : 2 400 h (cycles courts, moins de palissage)
  Tomate :    0,6 ha × 3 500 h/ha = 2 100 h
  Fraise :    0,3 ha × 4 000 h/ha = 1 200 h
  Courgette : 0,3 ha × 1 800 h/ha × 2 = 1 080 h
  Concombre : 0,3 ha × 2 800 h/ha = 840 h
  Commercialisation (marchés) : 4 h × 2 × 50 sem = 400 h

TOTAL ANNUEL : 8 020 h

Capacité :
  Exploitant : ~2 400 h/an (8-12 h/jour selon saison)
  4 permanents : 4 × 1 820 = 7 280 h
  2 saisonniers : 2 × 910 = 1 820 h
  TOTAL disponible : 11 500 h

Marge de sécurité : 11 500 - 8 020 = 3 480 h (43%)
→ Absorbe les imprévus, maladie, météo. Correct.
```

---

### Scénario 2 : Serre chauffée 1 ha tomate, vente en GMS

**Profil** : joueur avancé/Expert, fort investissement, production spécialisée.

#### Investissement initial

| Poste | Coût |
|-------|:----:|
| Serre multichapelle 1 ha | 200 000 € |
| Chauffage gaz naturel | 80 000 € |
| Système hors-sol (gouttières, substrat) | 60 000 € |
| Fertigation automatisée | 15 000 € |
| Chambre froide 200 m³ | 80 000 € |
| Station de conditionnement + calibreuse | 100 000 € |
| Palettes, caisses, petit matériel | 15 000 € |
| **TOTAL investissement** | **550 000 €** |

#### Production

```
Culture : tomate grappe, variété longue conservation
Surface : 1 ha (10 000 m²) sous serre chauffée
Densité : 2,5 plants/m² = 25 000 plants
Période de production : mars à novembre (9 mois grâce au chauffage)
Rendement : 50 kg/m² = 500 t/ha/an (hors-sol chauffé, intensif)
```

#### Calcul du CA (vente 100% GMS, contrat annuel)

```
Production : 500 t
Prix moyen GMS annualisé :
  Mars-Avril (hors saison) : 80 t × 2,80 €/kg  = 224 000 €
  Mai-Juin (début saison)  : 120 t × 1,50 €/kg  = 180 000 €
  Juillet-Sept (pleine)    : 200 t × 0,90 €/kg  = 180 000 €
  Oct-Nov (fin saison)     : 100 t × 1,80 €/kg  = 180 000 €

CA BRUT = 764 000 €
Perte calibre + qualité (5%) : -38 200 €
CA NET = 725 800 €
```

#### Charges annuelles

| Poste | Montant | % CA |
|-------|:-------:|:----:|
| Main d'œuvre (3 permanents) | 78 000 € | 11% |
| Main d'œuvre saisonnière (4 × 7 mois) | 65 000 € | 9% |
| Chauffage gaz (450 kWh/m² × 0,08€) | 360 000 € | 50% |
| Plants (25 000 × 0,80€) | 20 000 € | 3% |
| Substrat + nutrition | 25 000 € | 3% |
| Eau | 8 000 € | 1% |
| Traitements (bio-contrôle + chimique) | 12 000 € | 2% |
| Entretien serre + matériel | 15 000 € | 2% |
| Emballage / conditionnement | 20 000 € | 3% |
| Amortissement (550k€ / 15 ans moy) | 36 700 € | 5% |
| **TOTAL charges** | **639 700 €** | **88%** |

#### Résultat

```
CA net :                        725 800 €
Charges d'exploitation :       -639 700 €
────────────────────────────────────────
Bénéfice avant charges sociales  86 100 €
Charges sociales (28% Expert) :  -24 108 €
────────────────────────────────────────
RÉSULTAT NET :                   61 992 €

Marge nette / ha :               61 992 €/ha
Marge nette / UTH :               8 856 €/UTH (7 UTH au total)
ROI investissement :             550 000 / 61 992 = 8,9 ans

VERDICT : CA énorme (725 800 €) mais marge nette faible (8,5% du CA).
Le chauffage gaz MANGE la marge (50% du CA à lui seul).

Sensibilité au prix du gaz :
  Gaz à 0,08 €/kWh (référence) : marge nette  61 992 €
  Gaz à 0,10 €/kWh (+25%)      : marge nette   -3 900 € ⚠️ DÉFICITAIRE
  Gaz à 0,06 €/kWh (-25%)      : marge nette 126 792 €

→ Risque très élevé. Ce système n'est viable que si le joueur maîtrise son énergie :
  • Chaudière bois (-180 000 €/an) → marge nette 191 592 €, ROI 3,5 ans
  • Méthanisation en synergie (-292 500 €/an) → marge nette 272 592 €
  • Abaissement nocturne de consigne (-20% de conso) → +51 840 €/an

C'est LE système où l'arbitrage énergétique décide de la rentabilité.
```

#### Temps de travail (ADR-004)

```
Besoin annuel (1 ha tomate hors-sol chauffée) :
  Plantation (mars) : 200 h
  Palissage + effeuillage : 900 h (9 mois)
  Récolte (500 t à 100 kg/h) : 5 000 h
  Traitements + surveillance : 300 h
  Conditionnement (500 t à 500 kg/h avec station) : 1 000 h
  Entretien serre + chaufferie : 200 h

TOTAL : 7 600 h

Capacité :
  Exploitant : 2 400 h
  3 permanents : 5 460 h
  4 saisonniers (7 mois) : 4 × 1 060 = 4 240 h
  TOTAL : 12 100 h

Marge : 12 100 - 7 600 = 4 500 h (59%) → confortable mais les saisonniers
ne sont là que 7 mois. En pointe été : besoin 900 h/mois, capacité 1 100 h → OK.
```

### Détection des problèmes et corrections

| Problème détecté | Correction |
|-----------------|------------|
| Scénario 2 : marge trop sensible au prix du gaz | Ajouter option géothermie / bois (divise le coût énergie par 2-3) |
| Scénario 1 : ROI trop rapide (2,3 ans) → trop facile ? | Normal : charges 12% → ROI 1,8 ans (OK, Normal = accumulation). Expert : charges 28% → ROI 3,5 ans |
| Fraise : périssabilité 3 jours = très punitif | Normal : fraise = 7 jours (douce). Expert : 3 jours mais chambre froide ×2 = 6 jours |
| Circuit court : si pas de limite volume, tout le monde y va | Marché = 500 kg max/session. AMAP = nb adhérents plafonné par zone |
| Équilibrage interne serveur Expert (ADR-005) | Rappel : Expert charges 28%. Le CA supplémentaire est absorbé par les charges détaillées (comparaison informative — serveurs séparés, aucune équivalence de rentabilité requise) |

### Checklist playtest

| Test | Critère | Bloquant ? |
|------|---------|:----------:|
| Test recette SimAgri | Un joueur SimAgri dit « c'est SimAgri en mieux » en mode Normal | ✅ OUI |
| 1 ha tunnel froid jouable seul (Normal) | L'exploitant seul gère 0,5-0,7 ha sans stress | ✅ OUI |
| Embauche nécessaire > 1 ha | Le joueur ressent le besoin d'embaucher | ✅ OUI |
| Vente auto fonctionne en Normal | Pas besoin de micro-gérer chaque kg | ✅ OUI |
| Périssabilité pas punitive en Normal | Pas de faillite à cause de tomates pourries | ✅ OUI |
| Serveur Expert internement équilibré | Marge Expert viable sur même surface (comparaison informative, cf. ADR-005) | ✅ OUI |
| ROI serre réaliste | 5-10 ans (pas 2, pas 20) | ⚠️ Attention |
| Chauffage = choix stratégique | Plusieurs options avec trade-offs clairs | Non |
| Diversité de cultures utile | Pas de « meilleur légume » évident qui domine | Non |

---

## Annexe — Récapitulatif des paramètres Normal vs Expert

| Paramètre | Normal | Expert |
|-----------|--------|--------|
| Légumes disponibles | 8 (n°1-8 du catalogue) | 15 (catalogue complet) |
| Cycles de culture | Simples (1 durée fixe) | Variables (T°, nutrition, variété) |
| Successions culturales | Libres (pas de contrainte rotation) | Contraintes (même famille = -20% rendement) |
| Périssabilité | Douce : -10%/jour après DLC, min 30% valeur | Réaliste : perte totale après DLC |
| Chambre froide | ×2 DLC automatiquement | ×2 DLC + coût électricité + capacité limitée |
| Vente | Automatique au meilleur canal disponible | Choix du canal, planification, engagements |
| AMAP | Non disponible (vente auto) | Disponible (contrat, variété obligatoire) |
| Prix | Stable (±10% saisonnier) | Volatil (±50% selon offre/demande serveur) |
| Climat serre | Automatique (coût fixe) | Pilotage T°/HR (consignes, économie possible) |
| Chauffage | On/off (coût fixe/mois en hiver) | Modulable (nuit/jour, consigne, source énergie) |
| Maladies | Rares, traitées automatiquement | Fréquentes si HR mal gérée, traitement manuel |
| Charges | 12% forfaitaires sur CA | 28% détaillées (MO, énergie, intrants, amort.) |
| Matériel | Basique (motoculteur, bineuse, chambre froide) | Complet (calibreuse, fertigation, planteuse 4R) |
| Salariés | Comptés en « capacité de travail » simple | Compétences, formation, productivité variable |
| Rendement | Fixe (valeur catalogue) | Variable (±30% selon pilotage et conditions) |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Audit de couverture : maraîchage non conçu (systèmes 9.2 et 6.13) |
| 2026-08-04 | Ajout des charges sociales dans les scénarios chiffrés | ADR-002 / ADR-003 — audit de conformité |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |
