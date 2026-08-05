> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Métiers de service : ETA, Concessionnaire, Transporteur

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `research/reality-vs-simagri-metiers.md`, `design/GDD-materiel.md` §5, `decisions/ADR-001-modes-de-jeu.md`, `decisions/ADR-002-recette-simagri-en-normal.md`, `decisions/ADR-003-expert-nest-pas-plus-rentable.md`

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

Ces trois métiers transforment un joueur en **PRESTATAIRE** pour les autres. C'est le cœur de l'économie sociale du jeu : un joueur ETA moissonne pour ses voisins, un joueur concessionnaire vend et répare leur matériel, un joueur transporteur achemine leurs récoltes.

**Pourquoi c'est fondamental** :
1. **Social** — chaque prestation crée un lien entre deux joueurs (client ↔ prestataire)
2. **Spécialisation** — un joueur ne peut pas tout faire seul ; il dépend des autres
3. **Économie vivante** — l'argent circule entre joueurs, pas seulement vers le système
4. **Diversité de jeu** — certains joueurs préfèrent gérer une concession qu'un troupeau

**Le modèle SimAgri** : le concessionnaire joueur est le système le mieux réussi (9/10 dans la recherche). L'ETA est fonctionnelle mais trop simple (6/10). Le transport est complet mais sans logistique saisonnière (7/10).

**Ce qu'Agriva garde** : tout le modèle concessionnaire SimAgri. Les mécaniques ETA joueur du GDD-materiel §5.
**Ce qu'Agriva ajoute** : file d'attente ETA, contrats annuels, économie détaillée de chaque métier, transport avec collecte programmée, garde-fous anti-monopole.

### 1.2 Gameplay loop des métiers de service

```
┌─────────────────────────────────────────────────────────────┐
│  BOUCLE COURTE (chaque jour)                                │
└─────────────────────────────────────────────────────────────┘
  Recevoir des commandes → prioriser → exécuter → facturer
        ↓
  ETA : moissonner la parcelle du client X
  Concessionnaire : réparer le tracteur du client Y
  Transporteur : livrer 30 t de blé du client Z au silo

┌─────────────────────────────────────────────────────────────┐
│  BOUCLE MOYENNE (chaque mois)                               │
└─────────────────────────────────────────────────────────────┘
  Gérer la trésorerie → embaucher/former → investir
        ↓
  Décision : acheter une 2e moissonneuse ? Former un mécanicien ?
             Ouvrir une ligne de transport supplémentaire ?

┌─────────────────────────────────────────────────────────────┐
│  BOUCLE LONGUE (chaque année)                               │
└─────────────────────────────────────────────────────────────┘
  Bilan annuel → fidélisation clients → expansion
        ↓
  Décisions structurantes :
    • Renouveler mon parc ETA (matériel plus performant)
    • Prendre une nouvelle licence constructeur (concessionnaire)
    • Ouvrir une 2e zone de collecte (transporteur)
    • Signer des contrats annuels (sécuriser le CA)
```

### 1.3 Les décisions du joueur prestataire

| Décision | Impact Normal | Impact Expert |
|----------|:-------------:|:-------------:|
| Quel tarif fixer ? | Attractivité vs marge | + concurrence locale, élasticité |
| Investir dans du gros matériel ? | Capacité accrue | + débit, amortissement, seuil de rentabilité |
| Signer des contrats annuels ? | Volume garanti | + priorité client, pénalités |
| Embaucher un salarié ? | Plus de capacité | + salaire, compétences, planning |
| Se spécialiser ou diversifier ? | Focus vs polyvalence | + réputation par domaine |
| Quelle zone couvrir ? | Rayon d'action | + frais de déplacement, concurrence |

### 1.4 Différence Normal / Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| **Accès au métier** | Posséder le matériel requis | + ancienneté, capital minimum |
| **Tarification** | Prix libre, benchmark affiché | + coût de revient calculé, marge visible |
| **Disponibilité** | ETA PNJ toujours dispo | File d'attente en pointe |
| **Employés** | Capacité illimitée (temps du joueur) | Salariés avec compétences et planning |
| **Réputation** | Non | 1-5 étoiles, impact sur la clientèle |
| **Contrats** | Non | Annuels (-8% tarif, priorité, pénalités) |
| **Concurrence** | Coexistence libre | Exclusivité territoriale (concessionnaire) |
| **Économie** | Marge implicite | Coût de revient, seuil de rentabilité, bilan |

---

## 2. ETA (Entreprise de Travaux Agricoles)

> Référence : ce chapitre approfondit le GDD-materiel §5 sans le contredire.
> L'ETA PNJ (toujours disponible en Normal) et les tarifs de référence sont définis dans le GDD-materiel §5.2.
> Ici on détaille le **métier joueur** d'entrepreneur de travaux.

### 2.1 Conditions d'accès

| Condition | Normal | Expert |
|-----------|:------:|:------:|
| Posséder le matériel de la prestation | ✅ | ✅ |
| Ancienneté minimum | 30 jours | 60 jours |
| Capital minimum | Aucun | 50 000 € de trésorerie |
| Surface exploitée minimum | Aucune | Aucune (ETA pure possible) |
| Nombre max de prestations actives | 5 | 12 |

**Matériel requis** : le joueur doit posséder l'outil correspondant à la prestation. Exemples :
- Moisson → moissonneuse + tracteur + benne de charroi
- Labour → charrue + tracteur ≥ puissance requise
- Ensilage → ensileuse + 2 bennes minimum

### 2.2 Publier une offre de prestation

```
┌─ Proposer mes services ETA ───────────────────────────────────┐
│                                                                │
│  Prestation : [ Moisson céréales ▼ ]                           │
│  Matériel : Claas Lexion 5300 (coupe 6 m, 4,8 ha/h)           │
│                                                                │
│  Tarif :     [___105___] €/ha                                  │
│  Zone :      [ Ma zone + 2 zones adjacentes ▼ ]                │
│  Capacité :  [___300___] ha/campagne                           │
│  Délai max : [___3_____] jours après commande                  │
│                                                                │
│  ── Indicateurs ──                                             │
│  📊 Tarif moyen serveur : 108 €/ha                             │
│  📊 Tarif ETA PNJ :       110 €/ha                             │
│  💰 Votre coût de revient : 62 €/ha (cf. GDD-materiel §3.4)   │
│  💰 Marge estimée : 43 €/ha (41%)                              │
│                                                                │
│  ⏱️ Capacité réelle : 58 ha/jour (6 m × 5,5 km/h × 12h)       │
│     300 ha = 5,2 jours pleins de travail                       │
│                                                                │
│  [ Publier l'offre ]                                           │
└────────────────────────────────────────────────────────────────┘
```

### 2.3 Tarifs de référence

Tarifs ETA PNJ (repris du GDD-materiel §5.2, inchangés) :

| Prestation | Tarif PNJ | Fourchette joueurs |
|-----------|:---------:|:------------------:|
| Labour | 110 €/ha | 85-120 €/ha |
| Déchaumage | 45 €/ha | 35-50 €/ha |
| Semis céréales (combiné) | 75 €/ha | 60-80 €/ha |
| Moisson céréales | 110 €/ha | 90-120 €/ha |
| Moisson maïs | 145 €/ha | 120-155 €/ha |
| Ensilage maïs | 48 €/t MS | 40-55 €/t MS |
| Pressage balle ronde | 11 €/balle | 9-13 €/balle |
| Pressage grosse carrée | 13 €/balle | 11-15 €/balle |
| Arrachage betterave | 250 €/ha | 210-270 €/ha |
| Épandage fumier | 7 €/t | 5-9 €/t |
| Épandage lisier | 4 €/m³ | 3-5 €/m³ |

**Règle de prix** : le joueur fixe librement son tarif. L'ETA PNJ affiche le tarif de référence. Un joueur peut être moins cher (volume, fidélisation) ou plus cher (premium, rapidité).

### 2.4 File d'attente en pointe (Expert)

En moisson (3-4 semaines), tous les clients veulent être servis en même temps.

```
capacité_journalière = débit_machine × heures_travail/jour

Exemple : moissonneuse 6 m, 4,8 ha/h, 12 h/jour = 58 ha/jour

Si 8 clients × 50 ha = 400 ha de commandes :
  → 7 jours de travail complets
  → Le 8e client attend 7 jours

Ordre de priorité :
  1. Contrats annuels signés (priorité absolue)
  2. Ordre chronologique de commande (premier arrivé)
  3. Proximité géographique (bonus 0,5 jour si même zone)
```

**Conséquence pour le client en retard** : risque de perte de fenêtre de récolte (germination sur pied, verse, météo). C'est la tension de gameplay qui justifie les contrats annuels.

**Garde-fou Normal** : l'ETA PNJ reste toujours disponible sous 1-3 jours. Le joueur Normal n'est JAMAIS bloqué (ADR-002).

### 2.5 Contrats annuels (Expert)

```
┌─ Contrat de prestation annuel ─────────────────────────────────┐
│                                                                 │
│  Prestataire : SARL Travaux du Val (joueur)                     │
│  Client : Ferme des Grands Champs                               │
│                                                                 │
│  Prestation : Moisson céréales — 145 ha                         │
│  Tarif contractuel : 101 €/ha (tarif standard -8%)              │
│  Garantie : intervention sous 3 jours max                       │
│  Engagement : 1 campagne (renouvelable tacitement)              │
│                                                                 │
│  ── Avantages ──                                                │
│  ✅ Client : -8% sur le tarif + priorité garantie               │
│  ✅ Prestataire : volume sécurisé (14 645 € garantis)           │
│                                                                 │
│  ── Pénalités ──                                                │
│  ⚠️ Client annule : 15 €/ha (2 175 €)                           │
│  ⚠️ Prestataire fait défaut : 25 €/ha (3 625 €)                 │
│                                                                 │
│  [ Signer le contrat ]  [ Négocier ]                            │
└─────────────────────────────────────────────────────────────────┘
```

**Limites** : un prestataire ne peut pas signer plus de contrats que sa capacité réelle. Le système bloque à 90% de la capacité déclarée (marge de sécurité).

### 2.6 Réputation (Expert)

```
Note globale : 1 à 5 étoiles (affichée publiquement)

Critères :
  + Respect du délai annoncé           (+0,3 ★ si 100% des délais tenus)
  + Volume réalisé sans incident       (+0,2 ★ si > 500 ha/an)
  + Qualité de prestation (matériel)   (+0,2 ★ si matériel < 3 ans)
  - Retard (> 2 jours)                 (-0,5 ★ par retard)
  - Annulation unilatérale             (-1,0 ★ par annulation)
  - Réclamation client (pertes élevées)(-0,3 ★ par réclamation)

Effets :
  ★★★★★ : peut facturer +10% vs référence, clients affluent
  ★★★★☆ : tarif standard, bonne clientèle
  ★★★☆☆ : tarif standard, clientèle normale
  ★★☆☆☆ : doit baisser ses prix (-10%) pour attirer
  ★☆☆☆☆ : quasi aucun client (seulement les désespérés)
```

### 2.7 Qualité de prestation (Expert)

```
qualité = f(état_matériel, expérience_prestataire, conditions)

Excellente (matériel < 2 000 h, prestataire > 2 ans) :
  → Pertes récolte 1,5%, travail impeccable
  
Bonne (référence) :
  → Pertes 2,5%

Moyenne (matériel > 6 000 h ou prestataire < 6 mois) :
  → Pertes 4%, qualité de travail dégradée (-2% rendement client)

→ Le client a intérêt à choisir un bon prestataire, pas juste le moins cher.
```

### 2.8 Économie de l'ETA joueur

**Coût de revient par prestation** (basé sur GDD-materiel §3.4) :

| Prestation | Coût de revient/ha | Tarif moyen | Marge |
|-----------|:-----------------:|:----------:|:-----:|
| Labour | 62 €/ha | 110 €/ha | 48 €/ha (44%) |
| Moisson | 62 €/ha | 110 €/ha | 48 €/ha (44%) |
| Déchaumage | 22 €/ha | 45 €/ha | 23 €/ha (51%) |
| Semis combiné | 38 €/ha | 75 €/ha | 37 €/ha (49%) |
| Pressage | 6,5 €/balle | 11 €/balle | 4,5 €/balle (41%) |
| Ensilage | 28 €/t MS | 48 €/t MS | 20 €/t MS (42%) |

**Composition du coût de revient (moisson, 6 m)** :
```
Amortissement moissonneuse : 380 000 € / 4 000 h = 95 €/h → 19,8 €/ha
Carburant : 45 L/h × 0,95 € = 42,75 €/h → 8,9 €/ha
Entretien+réparations : 28 €/h → 5,8 €/ha
Assurance : 8 €/h → 1,7 €/ha
Charroi (tracteur+benne) : 22 €/h → 4,6 €/ha
Déplacement entre clients : forfait 8 €/ha
Chauffeur (si salarié Expert) : 18 €/h → 3,7 €/ha
Frais fixes (téléphone, admin) : 4 €/ha
─────────────────────────────────────────────
Coût de revient total : 57-67 €/ha (moyenne 62 €/ha)
```

**Seuil de rentabilité** :
```
Charges fixes annuelles (amortissement + assurance + frais) :
  Moissonneuse : 52 000 €/an
  
Marge par ha : 110 - 62 = 48 €/ha

Seuil de rentabilité = 52 000 / 48 = 1 083 ha/an
  → Très exigeant ! En réalité, le joueur moissonne aussi SES parcelles.

Avec 200 ha propres (économie 110 €/ha × 200 = 22 000 €) :
  Seuil prestation pure = (52 000 - 22 000) / 48 = 625 ha de prestation

→ L'ETA joueur doit trouver 625 ha de clients pour rentabiliser sa moissonneuse.
→ Ou la partager via une CUMA (cf. GDD-materiel §6).
```



---

## 3. CONCESSIONNAIRE

> Le concessionnaire joueur est le métier le mieux réussi de SimAgri (9/10). On reprend intégralement le modèle et on l'enrichit.

### 3.1 Conditions d'accès

| Condition | Normal | Expert |
|-----------|:------:|:------:|
| Ancienneté | 90 jours | 90 jours |
| Capital minimum | 150 000 € | 250 000 € |
| Limite par serveur | 1 par zone × marque | 1 par zone × marque |
| Nombre de marques max au départ | 2 | 2 |

### 3.2 Hall de vente et vendeurs

**Infrastructure** :
```
Hall de vente : 200 m² de base (extensible à 500 m² par tranches de 100 m²)
  Coût construction : 80 000 € (200 m²)
  Extension : 30 000 € / 100 m² supplémentaires
  Capacité d'exposition : 1 machine / 25 m²
  → 200 m² = 8 machines exposées
  → 500 m² = 20 machines exposées
```

**Vendeurs** :
```
Embauche : 2 200 €/mois brut
Compétences : 1-10 (progression +1 tous les 6 mois d'expérience)
Effet : compétence du vendeur → taux de conversion des prospects
  Niveau 1-3 : 15% de conversion
  Niveau 4-6 : 25% de conversion
  Niveau 7-9 : 35% de conversion
  Niveau 10  : 45% de conversion

Retraite : 62 ans (Expert), remplacé automatiquement en Normal
Spécialité : 1 vendeur peut gérer 2 marques max
```

### 3.3 Licences constructeurs (système de points)

Reprise fidèle du système SimAgri :

```
Budget total : 100 points à répartir entre les marques

Coût d'entrée par marque :
  Marque majeure (JD, Fendt, NH, Case, Claas) : 30 points
  Marque moyenne (MF, Valtra, Deutz, Kubota)   : 20 points
  Marque mineure (Same, McCormick, Landini)     : 10 points

Effet des points investis :
  Points = accès au catalogue + marge constructeur
  30 pts dans une marque majeure → catalogue complet + marge max (12%)
  15 pts dans une marque majeure → catalogue partiel + marge réduite (8%)
  
Reversement annuel au constructeur :
  3% du CA réalisé sur la marque (frais de licence)
```

**Exclusivité territoriale** : 1 seul concessionnaire par zone pour une marque donnée. Si un joueur a John Deere dans la zone Nord, aucun autre ne peut prendre JD dans cette zone.

### 3.4 Atelier et mécaniciens

```
┌─ Atelier — Concession Val de Loire ──────────────────────────┐
│                                                               │
│  ── Mécaniciens ──                                            │
│  👨‍🔧 Pierre (38 ans)  Comp: 8/10  Spé: John Deere, Claas     │
│     Salaire: 2 800 €/mois  |  Statut: Disponible             │
│                                                               │
│  👨‍🔧 Marc (52 ans)    Comp: 9/10  Spé: New Holland            │
│     Salaire: 3 200 €/mois  |  Statut: Intervention client    │
│                                                               │
│  👨‍🔧 Lucas (24 ans)   Comp: 4/10  Spé: Généraliste            │
│     Salaire: 2 100 €/mois  |  Statut: Révision en atelier    │
│                                                               │
│  ── File d'attente atelier ──                                 │
│  1. Tracteur JD 6215R — révision 2000h (Marc, 1 jour)         │
│  2. Moissonneuse Claas — panne variateur (Pierre, 2 jours)   │
│  3. Tracteur NH T7 — pneus (Lucas, 0,5 jour)                 │
│                                                               │
│  ── Capacité ──                                               │
│  Postes de travail : 3  |  Occupation : 3/3 (100%)           │
│  Délai moyen actuel : 2,5 jours                              │
│                                                               │
│  [ Embaucher ]  [ Former ]  [ Planning ]                      │
└───────────────────────────────────────────────────────────────┘
```

**Mécaniciens — paramètres** :

| Paramètre | Valeur |
|-----------|--------|
| Compétences | 1-10 (progression +1 / an avec formation) |
| Spécialité marque | 1-2 marques (bonus +20% vitesse sur la marque) |
| Salaire | 2 000 €/mois (comp 1) à 3 500 €/mois (comp 10) |
| Formation | 2 500 €/session, +1 compétence, 5 jours d'absence |
| Retraite | 62 ans (Expert). Normal : pas de retraite |
| Embauche | Délai 7 jours, coût 1 500 € (recrutement) |

**Effet de la compétence sur l'atelier** :
```
Temps de réparation = temps_base × (1,5 - compétence × 0,05)
  Comp 1 : ×1,45 (45% plus lent)
  Comp 5 : ×1,25
  Comp 8 : ×1,10
  Comp 10: ×1,00 (temps optimal)

Qualité de réparation :
  Comp 1-3 : 5% de risque de re-panne dans les 30 jours
  Comp 4-6 : 2% de risque
  Comp 7-9 : 0,5% de risque
  Comp 10 : 0% de risque
```

### 3.5 Activités et marges

| Activité | Part du CA | Marge brute | Mode |
|----------|:----------:|:-----------:|:----:|
| Vente neuf | 50-60% | 5-12% | N+E |
| Vente occasion | 15-20% | 10-15% | N+E |
| Atelier (main d'œuvre) | 12-18% | Tarif 60-90 €/h MO | N+E |
| Pièces détachées | 8-12% | 25-40% | N+E |
| Location courte durée | 3-5% | 15-25% | E |
| Crédit-bail (commission) | 1-2% | 3-5% du montant financé | E |

**a) Vente neuf**
```
Prix affiché au client = prix_catalogue × (1 - remise_négociée)
Marge concessionnaire = prix_catalogue × taux_marge_constructeur - frais

Taux de marge selon les points investis :
  30 pts (max) : 12%
  25 pts       : 10%
  20 pts       : 8%
  15 pts       : 6%
  10 pts       : 5%

Exemple : tracteur 180 000 € catalogue, 30 pts dans la marque
  Marge brute : 180 000 × 12% = 21 600 €
  Remise accordée au client : -5% (fidélité)
  Prix client : 171 000 €
  Marge nette : 21 600 - 9 000 = 12 600 € (7,4% du prix client)
```

**b) Vente occasion (dépôt-vente)**
```
Le concessionnaire reprend le matériel d'un joueur :
  Prix de reprise = argus × 0,82 (marge de revente intégrée)
  Prix de revente = argus × 0,95-1,05
  Marge = 13-23% du prix de reprise

Ou dépôt-vente (commission) :
  Le vendeur fixe son prix
  Commission concessionnaire : 8% du prix de vente
```

**c) Atelier**
```
Tarif main d'œuvre facturé :
  Normal : 65 €/h (tarif unique)
  Expert : 60-90 €/h selon complexité
    Entretien courant     : 60 €/h
    Réparation standard   : 70 €/h
    Réparation complexe   : 80 €/h
    Dépannage sur site    : 90 €/h + déplacement 1,20 €/km

Coût réel du mécanicien : salaire + charges = 18-25 €/h
Marge atelier : 60-70% (c'est le centre de profit principal en % !)
```

**d) Pièces détachées**
```
Magasin de pièces :
  Investissement initial : 20 000 € (stock de base)
  Extension : par tranches de 10 000 €

Marge sur pièces :
  Pièces d'usure courantes (filtres, courroies) : 25-30%
  Pièces mécaniques (roulements, joints)        : 30-35%
  Pièces moteur/hydraulique                     : 35-40%
  
Remise clients fidèles : 5-15% (si le client a acheté sa machine ici)
```

**e) Location courte durée (Expert)**
```
Parc de location (machines de démonstration ou dédiées) :
  Le concessionnaire achète des machines et les loue

Tarifs journaliers :
  Tracteur 150 CV        : 220 €/jour
  Tracteur 250 CV        : 350 €/jour
  Moissonneuse classe 6  : 1 400 €/jour
  Télescopique           : 280 €/jour
  Presse balle ronde     : 180 €/jour

Rentabilité location :
  Taux d'occupation cible : 40-60% (saisonnier)
  ROI machine de location : 4-6 ans
```

**f) Crédit-bail (Expert)**
```
Le concessionnaire propose un financement :
  Commission : 3-5% du montant financé (versée par l'organisme de crédit)
  
Exemple : tracteur 150 000 € financé en crédit-bail 5 ans
  Commission : 150 000 × 4% = 6 000 € pour le concessionnaire
  + fidélisation du client (reviendra pour l'entretien)
```

### 3.6 Réseau GPS (reprise SimAgri enrichie)

```
Le concessionnaire peut installer des balises RTK dans sa zone :

Investissement par balise :
  Achat + installation : 25 000 €
  Couverture : 1 zone (rayon 15 km)
  Entretien annuel : 1 200 €/balise

Revenu :
  Abonnement annuel revendu aux joueurs : 700-900 €/an/client
  Seuil de rentabilité : 8 abonnés
  Capacité max : 40 abonnés/balise
  
Avantage vs satellite :
  Précision : ±1,5 cm (vs ±2 cm satellite)
  Fiabilité : pas de perte de signal
  Prix client : 700-900 €/an (vs 1 200 €/an satellite)

→ Le concessionnaire qui installe une balise capte les clients GPS de sa zone.
→ Revenu récurrent et fidélisant.
```

### 3.7 Exclusivité territoriale

```
Règle : 1 concessionnaire par marque par zone

Zone = unité géographique du serveur (40-80 joueurs agriculteurs par zone)

Effet :
  Le concessionnaire JD de la zone Nord est LE SEUL à vendre du JD neuf
  Les joueurs de la zone doivent passer par lui (ou aller en zone voisine)
  
Conséquence :
  Position de monopole local MAIS limitée par :
  - La concurrence des autres marques (Fendt, NH dans la même zone)
  - Le concessionnaire de la zone voisine (le client peut se déplacer)
  - L'occasion entre joueurs (pas de monopole sur l'occasion)
```

### 3.8 Économie complète d'une concession

**Compte de résultat annuel type (concession 2 marques, zone de 60 agriculteurs)** :

```
CHIFFRE D'AFFAIRES
  Vente neuf (12 machines × 120 000 € moyen)      1 440 000 €
  Vente occasion (18 machines × 55 000 €)            990 000 €
  Atelier (3 mécaniciens × 1 600 h × 70 €/h)        336 000 €
  Pièces détachées                                   180 000 €
  Location (Expert)                                   85 000 €
  GPS (25 abonnés × 800 €)                            20 000 €
  ──────────────────────────────────────────────────────────────
  TOTAL CA                                         3 051 000 €

CHARGES
  Achat machines (neuf : coût constructeur)        1 267 200 €
  Achat machines (occasion : reprise)                841 500 €
  Salaires (3 mécaniciens + 1 vendeur + gérant)      156 000 €
  Charges sociales (45%)                              70 200 €
  Loyer/amortissement bâtiment                        36 000 €
  Stock pièces (renouvellement)                      108 000 €
  Licence constructeur (3% du CA neuf)                43 200 €
  Énergie, assurance, divers                          28 000 €
  Amortissement parc location                         42 000 €
  Entretien balises GPS                                1 200 €
  ──────────────────────────────────────────────────────────────
  TOTAL CHARGES                                    2 593 300 €

RÉSULTAT NET                                         457 700 €
  → Revenu du joueur concessionnaire : 457 700 €/an (Expert, grosse concession)
```

⚠️ **Ce résultat est TROP ÉLEVÉ** par rapport à l'objectif d'équilibrage (35 000-60 000 €/an). Voir §6 pour les corrections.



---

## 4. TRANSPORTEUR

### 4.1 Conditions d'accès

| Condition | Normal | Expert |
|-----------|:------:|:------:|
| Posséder au moins 1 camion + 1 semi | ✅ | ✅ |
| Ancienneté | 30 jours | 60 jours |
| Capital minimum | 100 000 € | 200 000 € |
| Chauffeurs employés | Non requis (le joueur conduit) | 1 minimum |

### 4.2 Flotte — Camions et semi-remorques

**Tracteurs routiers** :

| Modèle | Prix neuf | Charge utile semi | Consommation |
|--------|:---------:|:-----------------:|:------------:|
| Porteur 19 t (local) | 95 000 € | 10 t | 28 L/100 km |
| Tracteur routier 44 t | 135 000 € | 26 t (semi) | 34 L/100 km |

**Semi-remorques (8 types)** :

| Type | Usage | Prix neuf | Charge utile |
|------|-------|:---------:|:------------:|
| Benne céréalière | Céréales, engrais vrac | 45 000 € | 26 t |
| Plateau | Matériel, palettes, big-bags | 35 000 € | 24 t |
| Citerne alimentaire | Lait, huile, vin | 75 000 € | 25 000 L |
| Citerne pulvérulent | Engrais, aliments | 55 000 € | 28 t |
| Porte-engin | Transport de matériel agricole | 65 000 € | 35 t |
| Bétaillère | Animaux vivants | 70 000 € | 20-30 bovins |
| Citerne lait | Collecte quotidienne multi-fermes | 80 000 € | 15 000 L |
| Fond mouvant | Paille, copeaux, compost | 85 000 € | 90 m³ |

### 4.3 Chauffeurs employés (Expert)

```
Embauche :
  Salaire : 2 400 €/mois brut
  Permis CE requis (acquis à l'embauche)
  Compétences : 1-10 (progression +1/an)
  
Capacité :
  1 chauffeur = 1 camion = 10 h/jour max (réglementation)
  
Effet de la compétence :
  Comp 1-3 : consommation +10%, temps de trajet +15%
  Comp 4-6 : valeurs de base
  Comp 7-9 : consommation -5%, temps -5%
  Comp 10  : consommation -8%, temps -10%, 0 incident
```

### 4.4 Commandes de transport entre joueurs

```
┌─ Commander un transport ──────────────────────────────────────┐
│                                                                │
│  Marchandise : Blé tendre (145 t)                              │
│  Départ : Mon exploitation (zone Nord)                         │
│  Arrivée : Coopérative Agri-Centre (zone Centre, 45 km)       │
│                                                                │
│  ── Offres de transporteurs ──                                 │
│                                                                │
│  🚛 Transports Duval (joueur)                                  │
│     Tarif : 8 €/t → 1 160 €                                   │
│     Délai : 2 jours (6 rotations de 26 t)                     │
│     ⭐ 4,7/5 (23 transports)                                   │
│                                                                │
│  🚛 Transport PNJ                                              │
│     Tarif : 10 €/t → 1 450 €                                  │
│     Délai : 1 jour                                             │
│     Toujours disponible                                        │
│                                                                │
│  💡 Si vous aviez une benne 20 t + tracteur :                  │
│     8 trajets × 12 L × 0,95 € = 91 € mais 16 h de votre temps│
│                                                                │
│  [ Commander (Duval) ]  [ Commander (PNJ) ]                    │
└────────────────────────────────────────────────────────────────┘
```

### 4.5 Tarification

| Type de transport | Distance | Tarif joueur | Tarif PNJ |
|------------------|:--------:|:------------:|:---------:|
| Céréales (local, < 30 km) | Court | 5-8 €/t | 10 €/t |
| Céréales (longue distance, > 50 km) | Long | 12-18 €/t | 20 €/t |
| Engrais / amendements | Court | 6-9 €/t | 11 €/t |
| Animaux (bovins, < 50 km) | Court | 100-180 €/voyage | 200 €/voyage |
| Animaux (longue distance, > 100 km) | Long | 200-300 €/voyage | 350 €/voyage |
| Matériel (porte-engin) | Variable | 200-500 €/voyage | 400 €/voyage |
| Lait (collecte programmée) | Tournée | 18-25 €/1000L | 30 €/1000L |
| Paille / fourrage (fond mouvant) | Variable | 8-12 €/t | 15 €/t |

### 4.6 Collecte de lait programmée (Expert)

```
Principe : le transporteur signe un contrat de collecte avec plusieurs éleveurs laitiers.

Contrat de collecte :
  Fréquence : tous les 2 jours (citerne lait isotherme)
  Tournée : 3-8 fermes par rotation
  Volume : 5 000-15 000 L par tournée
  Destination : laiterie (coopérative ou privée)
  
Tarif : 18-25 €/1000 L (fonction du nombre de fermes et de la distance)

Exemple — tournée quotidienne :
  5 fermes × 2 000 L = 10 000 L tous les 2 jours
  Distance totale tournée : 60 km
  Tarif : 22 €/1000 L → 220 €/tournée
  Coût (carburant + usure + chauffeur) : 95 €/tournée
  Marge : 125 €/tournée × 180 tournées/an = 22 500 €/an

→ Revenu récurrent et prévisible (contrat annuel)
→ Nécessite 1 citerne lait dédiée (80 000 €)
→ Rentabilité : dès 4 fermes régulières
```

### 4.7 Charroi de moisson (pic saisonnier)

```
Pendant la moisson (3-4 semaines) :
  Les moissonneuses (ETA ou propres) remplissent des bennes
  Il faut acheminer le grain vers le silo (coopérative)
  Besoin : 3-6 rotations/jour/moissonneuse

Le transporteur peut proposer du charroi :
  Tarif : 5-8 €/t (courte distance, < 15 km)
  Volume potentiel : 200-500 t/jour avec 2 camions
  Durée : 3-4 semaines (pic intense)
  
Revenu charroi moisson :
  400 t/jour × 20 jours × 6 €/t = 48 000 €
  Coût : 22 000 €
  Marge : 26 000 € en 3 semaines (le jackpot saisonnier)
  
→ Le transporteur qui a 2 bennes céréalières peut doubler son CA annuel
   pendant la moisson.
```



---

## 5. Interactions entre métiers et avec les agriculteurs

### 5.1 Matrice d'interactions

```
                    AGRICULTEUR    ETA         CONCESSIONNAIRE    TRANSPORTEUR
AGRICULTEUR         échange/CUMA   client      client             client
ETA                 prestataire    concurrence client (matériel)  sous-traitant charroi
CONCESSIONNAIRE     fournisseur    fournisseur —                  client (porte-engin)
TRANSPORTEUR        prestataire    charroi     client (camion)    concurrence
```

### 5.2 Synergies clés

**ETA ↔ Concessionnaire** :
- L'ETA achète son matériel au concessionnaire (gros volumes = remise 8-12%)
- L'ETA fait entretenir son parc au concessionnaire (contrat annuel)
- Le concessionnaire recommande une ETA à ses clients qui n'achètent pas de moissonneuse

**ETA ↔ Transporteur** :
- L'ETA a besoin de charroi pendant l'ensilage et la moisson
- Elle sous-traite le transport au transporteur (2-4 bennes nécessaires pour 1 ensileuse)
- Contrat de charroi saisonnier : 15-20 jours × 350 €/jour = 5 250-7 000 €

**Concessionnaire ↔ Transporteur** :
- Le concessionnaire fait livrer les machines vendues par le transporteur (porte-engin)
- Tarif : 200-400 €/livraison × 30 machines/an = 6 000-12 000 €/an
- Le transporteur achète/entretient ses camions... chez un concessionnaire PL (PNJ)

**Agriculteur au centre** :
- L'agriculteur est le CLIENT de tous les métiers de service
- Il choisit : faire lui-même OU sous-traiter (arbitrage coût/temps/capital)
- Ses choix créent la demande qui fait vivre les prestataires

### 5.3 Chaîne de valeur d'une moisson (exemple complet)

```
1. Agriculteur commande la moisson à l'ETA (110 €/ha × 50 ha = 5 500 €)
2. ETA intervient avec sa moissonneuse (achetée au concessionnaire)
3. Transporteur assure le charroi ferme→silo (6 €/t × 400 t = 2 400 €)
4. Après moisson, ETA fait réviser la machine (concessionnaire, 2 400 €)

Flux financier : Agriculteur → ETA → Concessionnaire
                 Agriculteur → Transporteur
                 
Tout le monde y gagne. L'argent circule entre joueurs.
```

---

## 6. Équilibrage

### 6.1 Objectifs

| Objectif | Cible |
|----------|-------|
| Revenu net annuel d'un métier de service | 35 000-60 000 €/an |
| Pas plus rentable que l'agriculture | Agriculture = 35 000-55 000 €/an (150 ha) |
| Investissement initial requis | 200 000-600 000 € selon le métier |
| ROI de l'investissement | 4-8 ans |
| Temps de jeu requis | Comparable à un agriculteur (15-25 min/jour) |

### 6.2 Corrections d'équilibrage

**Problème identifié §3.8** : la concession type génère 457 700 €/an. C'est 8× trop élevé.

**Corrections appliquées** :

```
1. RÉDUCTION DE LA DEMANDE :
   Le nombre de ventes/an est limité par la population de la zone.
   Zone de 60 agriculteurs :
     - Achat neuf : 2-4 machines/an (pas 12)
     - Occasion : 5-8 machines/an (pas 18)
   → Cycle de renouvellement réaliste : 1 machine tous les 5-8 ans/joueur

2. CHARGES FIXES PLUS ÉLEVÉES :
   Loyer/amort bâtiment : 60 000 €/an (concession de 200-500 m²)
   Stock pièces immobilisé : 80 000 € (coût du capital 5% = 4 000 €/an)
   
3. RÉSULTAT RECALCULÉ (concession réaliste) :
```

**Compte de résultat CORRIGÉ** :

```
CHIFFRE D'AFFAIRES (zone de 60 agriculteurs)
  Vente neuf (3 machines × 140 000 € moyen)          420 000 €
  Vente occasion (6 machines × 50 000 €)              300 000 €
  Atelier (2 mécaniciens × 1 400 h × 70 €)           196 000 €
  Pièces détachées                                     95 000 €
  Location (Expert)                                    35 000 €
  GPS (12 abonnés × 800 €)                              9 600 €
  ─────────────────────────────────────────────────────────────
  TOTAL CA                                          1 055 600 €

CHARGES
  Achat machines neuf (constructeur, 88% du prix)      369 600 €
  Achat occasion (reprise à 82% de l'argus)            246 000 €
  Salaires (2 mécaniciens + 1 vendeur)                  92 400 €
  Charges sociales (45%)                                41 580 €
  Loyer/amortissement bâtiment                          60 000 €
  Stock pièces (coût achat)                             57 000 €
  Licence constructeur (3% CA neuf)                     12 600 €
  Énergie, assurance, divers                            24 000 €
  Amortissement location                                18 000 €
  Balises GPS (entretien)                                1 200 €
  Frais financiers (stock immobilisé)                    8 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL CHARGES                                       930 380 €

RÉSULTAT NET AVANT IMPÔT                              125 220 €
  Charges Expert (28% — ADR-003)                       35 062 €
  ─────────────────────────────────────────────────────────────
  REVENU NET JOUEUR (Expert)                           90 158 €
```

⚠️ Encore trop haut. **Correction supplémentaire** :
```
En Expert : charges fixes alourdies (formation, garantie, SAV gratuit)
  → Formation mécaniciens : 5 000 €/an
  → Garantie (coûts de retour) : 12 000 €/an  
  → Remises fidélité obligatoires : -8% sur atelier clients fidèles → -15 680 €
  → Marketing, prospection : 6 000 €/an
  
REVENU NET FINAL (Expert) : 90 158 - 38 680 = 51 478 €/an ✅

En Normal (charges 12%) :
  Résultat avant charges : 125 220 €
  Charges Normal (12%) : 15 026 €
  → Simplification : le joueur Normal gagne environ 55 000-60 000 €/an
  (les charges Normal sont plus légères mais le volume de ventes est aussi plus stable)
```

### 6.3 Scénario chiffré A — ETA moisson (Expert, 2e année)

```
INVESTISSEMENT INITIAL
  Moissonneuse Claas Lexion 6 m (occasion 3 ans)     285 000 €
  Tracteur 200 CV (occasion)                           95 000 €
  2 bennes 18 t                                        48 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL                                               428 000 €
  Financement : emprunt 7 ans à 4,5%

ACTIVITÉ ANNUELLE (2e année)
  Surfaces propres moissonnées : 180 ha
  Prestation pour clients : 650 ha
  Tarif moyen : 105 €/ha (contrats -8% + spot)
  
PRODUITS
  Économie sur ses propres surfaces (vs ETA PNJ) :
    180 ha × (110 - 62) € = 8 640 €
  CA prestation : 650 ha × 105 €/ha = 68 250 €
  ─────────────────────────────────────────────────────────────
  TOTAL PRODUITS                                       76 890 €

CHARGES
  Amortissement moissonneuse (285k / 8 ans)            35 625 €
  Amortissement tracteur+bennes (143k / 10 ans)        14 300 €
  Carburant (830 ha × 26 L/ha × 0,95 €)               20 503 €
  Entretien+réparations (3,5% valeur parc)             14 980 €
  Assurance                                             6 200 €
  Chauffeur saisonnier (4 semaines × 2 800 €)          2 800 €
  Frais de déplacement                                  3 200 €
  Intérêts emprunt (année 2)                           17 640 €
  Charges Expert (28% du résultat brut)                  [ci-dessous]
  ─────────────────────────────────────────────────────────────
  TOTAL CHARGES (hors 28%)                            115 248 €

RÉSULTAT BRUT                                         -38 358 € ❌
```

**Problème** : l'ETA moisson seule n'est PAS rentable en année 2 avec un emprunt.

**Corrections** :
```
1. L'ETA moissonneuse n'existe que pour un joueur QUI EXPLOITE AUSSI des terres.
   Ses propres 180 ha économisent 19 800 € vs ETA PNJ.
   
2. Recalcul en incluant l'économie personnelle comme "produit" :
   Produit total réel : 76 890 + 19 800 = 96 690 €
   → Toujours déficitaire en année 2 (-18 558 €)
   
3. Solution : le joueur ETA doit atteindre 900+ ha pour être rentable.
   Ou : acheter en occasion plus ancienne (180 000 € → charges /1,6)

SCÉNARIO CORRIGÉ — Moissonneuse occasion 5 ans (180 000 €) :
  Amortissement : 180 000 / 6 ans = 30 000 €
  Intérêts (emprunt 5 ans) : 7 200 €/an
  Autres charges : 47 683 €
  TOTAL CHARGES : 84 883 €
  
  PRODUITS (avec 180 ha propres + 650 ha prestation) : 76 890 €
  Économie propre (vs PNJ) : 8 640 €
  RÉSULTAT : 76 890 - 84 883 + 8 640 = 647 €  ≈ break-even en année 2

  Année 3 (850 ha de prestation, clients fidélisés) :
    CA : 850 × 105 = 89 250 €
    Charges : 91 000 € (ha supplémentaires = charges variables)
    Économie propre : 8 640 €
    RÉSULTAT : 6 890 €
    
  Année 5 (1 000 ha, emprunt remboursé) :
    CA : 1 000 × 105 = 105 000 €
    Charges (sans intérêts) : 72 000 €
    Économie propre : 8 640 €
    RÉSULTAT : 41 640 € ✅ (dans la cible 35-60k)
```

✅ **Validé** : l'ETA moisson est rentable à partir de l'année 4-5, avec 900-1 000 ha de prestation. C'est un investissement long terme qui récompense la fidélisation.

### 6.4 Scénario chiffré B — Concession (Expert, année stabilisée)

```
INVESTISSEMENT INITIAL
  Hall 200 m² (construction)                           80 000 €
  Stock pièces initial                                 80 000 €
  Licences constructeurs (2 marques × 25 pts)        [inclus dans les 100 pts]
  Parc location (2 machines occasion)                 120 000 €
  Balise GPS                                           25 000 €
  Trésorerie de démarrage                             100 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL                                               405 000 €

ACTIVITÉ ANNUELLE (année 3, stabilisée)
  Zone : 55 agriculteurs actifs
  Ventes neuf : 3/an (renouvellement naturel)
  Ventes occasion : 5/an
  Interventions atelier : 420/an (2 mécaniciens × 210 interventions)
  Abonnés GPS : 10

PRODUITS
  Marge vente neuf (3 × 140k × 10%)                   42 000 €
  Marge occasion (5 × 50k × 12%)                      30 000 €
  Atelier (2 méca × 1 400h × 70€ - coût 22€)         134 400 €
  Pièces (marge nette)                                 38 000 €
  Location (350 jours × 250€ × 45% taux occup.)       39 375 €
  GPS (10 × 800 €)                                      8 000 €
  Crédit-bail commissions (2 × 5 000 €)                10 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL PRODUITS (marges brutes)                       301 775 €

CHARGES
  Salaires (2 mécaniciens + 1 vendeur)                 92 400 €
  Charges sociales                                     41 580 €
  Loyer/amortissement bâtiment                         60 000 €
  Formation mécaniciens                                 5 000 €
  Énergie, assurance, divers                           24 000 €
  Frais financiers                                     12 000 €
  Amortissement parc location                          24 000 €
  Entretien balise GPS                                  1 200 €
  Garantie / SAV gratuit                               12 000 €
  Marketing                                             4 000 €
  ─────────────────────────────────────────────────────────────
  TOTAL CHARGES                                       276 180 €

RÉSULTAT AVANT CHARGES EXPERT                          25 595 €
  (pas de charges 28% car déjà intégrées dans les charges)

Hmm, trop bas. Recalcul avec l'atelier comme centre de profit principal :
  L'atelier génère 134 400 € de marge brute sur 301 775 € total = 45% du revenu
  
AJUSTEMENT : en réalité le vendeur et le gérant, c'est le JOUEUR.
  → On retire le salaire vendeur (2 200 €/mois = 26 400 €) et charges (11 880 €)
  → Le joueur fait lui-même la vente et la gestion (son "travail")
  
RÉSULTAT CORRIGÉ : 25 595 + 26 400 + 11 880 = 63 875 €
  Charges Expert (28%) : 17 885 €
  ─────────────────────────────────────────────────────────────
  REVENU NET JOUEUR : 45 990 €/an ✅
```

✅ **Validé** : revenu de 46 000 €/an pour une concession stabilisée. Dans la cible 35-60k.

---

## 7. Risque de monopole et garde-fous

### 7.1 Le problème

Si un seul joueur cumule ETA + Concessionnaire + Transporteur dans une zone, il contrôle tous les services. Les agriculteurs de la zone dépendent totalement de lui.

**Scénario toxique** :
```
Joueur "MégaService" dans la zone Centre :
  - Concessionnaire JD + NH (les 2 marques majeures)
  - ETA moisson + ensilage (seul prestataire)
  - Transporteur (seul à assurer le charroi)
  
→ Il fixe ses prix sans concurrence
→ Les agriculteurs n'ont pas d'alternative (hors PNJ)
→ Il capte 80% des flux financiers de la zone
→ Nouveaux joueurs découragés (pas d'espace économique)
```

### 7.2 Garde-fous implémentés

| Garde-fou | Effet | Mode |
|-----------|-------|:----:|
| **Limite 1 métier par joueur** | Un joueur ne peut exercer qu'UN seul métier de service (ETA OU Concessionnaire OU Transporteur) | N+E |
| **ETA PNJ toujours disponible** | Même si l'ETA joueur est en monopole, le PNJ assure la prestation (à +15% du tarif) | N+E |
| **Transport PNJ disponible** | Le PNJ transporteur est toujours accessible | N+E |
| **Exclusivité limitée à 2 marques** | Un concessionnaire ne peut pas prendre plus de 2 marques majeures (même avec 100 pts) | N+E |
| **Plafond de zone** | Max 2 concessions par zone (2 joueurs, marques différentes) | N+E |
| **Concurrence ETA libre** | Pas de limite au nombre d'ETA par zone (marché ouvert) | N+E |
| **Tarif PNJ = plafond psychologique** | Si un joueur facture plus que le PNJ, il perd ses clients naturellement | N+E |
| **Notation client** | Les clients notent les prestataires → un monopoleur qui abuse sera mal noté → perte de clients au profit du PNJ ou de la zone voisine | E |

### 7.3 Mécaniques anti-abus (Expert)

```
a) Détection de prix abusif :
   Si tarif joueur > tarif PNJ × 1,20 pendant 30 jours :
     → Alerte aux clients : "Le tarif PNJ est 20% moins cher"
     → Clients redirigés automatiquement vers PNJ
     
b) Encouragement à la concurrence :
   Si une zone n'a QU'UN seul prestataire joueur (tous métiers confondus) :
     → Bonus d'installation pour un 2e prestataire :
        -20% sur les frais de licence (concessionnaire)
        -15% sur le coût du matériel ETA (subvention système)
        
c) Mobilité des clients :
   Un agriculteur peut TOUJOURS acheter dans la zone voisine.
   Surcoût : +5% (frais de livraison) — pas un blocage.
   
d) Rotation naturelle :
   Les joueurs inactifs > 30 jours perdent leurs licences/exclusivités.
   → Libère les places pour de nouveaux joueurs.
```

### 7.4 Équilibre final

```
Le design garantit que :

1. Un monopole TOTAL est IMPOSSIBLE (limite 1 métier/joueur)
2. Un monopole LOCAL est ATTÉNUÉ (PNJ disponible, zone voisine accessible)
3. Un monopole ABUSIF est PUNI (notation, plafond de prix)
4. La CONCURRENCE est ENCOURAGÉE (bonus d'installation)

Résultat attendu :
  Zone de 60 agriculteurs → 2-3 prestataires joueurs
  + services PNJ en backup permanent
  → Personne n'est jamais bloqué
  → Les prestataires sont en concurrence modérée (bon pour les prix)
```

---

## Annexe — Récapitulatif des paramètres Normal / Expert

| Paramètre | Normal | Expert |
|-----------|:------:|:------:|
| **ETA — Accès** | Matériel + 30 j | + 60 j + 50k€ capital |
| **ETA — Tarification** | Libre, benchmark affiché | + coût de revient visible |
| **ETA — File d'attente** | Non (PNJ toujours dispo) | Oui en pointe |
| **ETA — Contrats annuels** | Non | Oui (-8%, priorité, pénalités) |
| **ETA — Réputation** | Non | 1-5 étoiles |
| **ETA — Qualité** | Uniforme | Variable (1,5-4% de pertes) |
| **ETA — Marge cible** | ~40% implicite | 30-50% calculable |
| **Concession — Accès** | 90 j + 150k€ | 90 j + 250k€ |
| **Concession — Vendeurs** | Pas de retraite | Retraite 62 ans |
| **Concession — Mécaniciens** | Comp 1-10, pas de retraite | + retraite, formation payante |
| **Concession — Marge neuf** | 5-12% selon points | Idem |
| **Concession — Atelier** | 65 €/h fixe | 60-90 €/h variable |
| **Concession — Location** | Non | Oui (parc dédié) |
| **Concession — Crédit-bail** | Non | Oui (commission 3-5%) |
| **Concession — GPS balises** | Non | Oui (25k€/balise, 700-900€/an) |
| **Transport — Accès** | 1 camion + 30 j | + chauffeur + 200k€ |
| **Transport — Chauffeurs** | Joueur conduit (temps de travail) | Employés avec compétences |
| **Transport — Collecte lait** | Non | Oui (contrat programmé) |
| **Transport — Charroi moisson** | Non | Oui (pic saisonnier) |
| **Monopole — Limite métiers** | 1 métier/joueur | 1 métier/joueur |
| **Monopole — PNJ backup** | Toujours dispo | Toujours dispo (+15%) |
| **Monopole — Exclusivité** | 2 marques max | 2 marques max |
| **Revenu cible prestataire** | 40 000-60 000 €/an | 35 000-55 000 €/an |

---

## Points à valider en playtest

**Recette SimAgri (ADR-002) — bloquant**
- [ ] Un joueur agriculteur pur peut-il jouer sans jamais dépendre d'un joueur prestataire ?
- [ ] L'ETA PNJ est-elle toujours disponible en Normal (pas de blocage) ?
- [ ] Devenir concessionnaire est-il ressenti comme une progression désirable ?
- [ ] Le concessionnaire joueur est-il un plaisir de gestion (comme dans SimAgri) ?
- [ ] Un prestataire absent 1 semaine pénalise-t-il ses clients de façon irrattrapable ?

**Profondeur Expert**
- [ ] La file d'attente en pointe crée-t-elle de la tension utile ou de la frustration ?
- [ ] Les contrats annuels sont-ils un arbitrage intéressant (client et prestataire) ?
- [ ] La gestion des employés (mécaniciens, chauffeurs) est-elle satisfaisante ?
- [ ] Le système de réputation influence-t-il réellement les choix des clients ?
- [ ] Le calcul du coût de revient aide-t-il à fixer son tarif ?

**Équilibrage et social**
- [ ] Les 3 métiers rapportent-ils autant que l'agriculture (35-60 k€) sans la dépasser ?
- [ ] Les garde-fous anti-monopole fonctionnent-ils (1 métier/joueur, PNJ backup) ?
- [ ] Une région sans prestataire joueur reste-t-elle jouable ?
- [ ] Les prestataires créent-ils des relations durables entre joueurs ?
- [ ] Un nouveau joueur peut-il devenir prestataire dans une région déjà servie ?

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Version initiale | — |
| 2026-08-04 | Correction économie concession (457k → 46k) | Résultat initial irréaliste, ajustement du volume de ventes et des charges |
| 2026-08-04 | Ajout garde-fou "1 métier par joueur" | Empêche le cumul ETA+Concessionnaire+Transport par un seul joueur |
| 2026-08-04 | Contrainte « Expert ≠ plus rentable » levée (serveurs séparés) ; références ADR corrigées | ADR-005 |

