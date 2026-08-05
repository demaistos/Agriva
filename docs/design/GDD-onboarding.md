> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Onboarding : les 30 premières minutes

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : ADR-001, ADR-002, ADR-003, ADR-005, GDD-cultures, GDD-economie-base, GDD-materiel

---

## 1. Vision et gameplay loop

### 1.1 Intention de design

L'onboarding détermine si un joueur reste ou part. Dans un jeu à 119 sous-systèmes, le défi est double :
1. **Ne pas noyer** — le joueur ne doit jamais se sentir perdu ou submergé
2. **Donner envie de creuser** — montrer la profondeur sans l'imposer

**Objectif des 30 premières minutes** : le joueur a **produit quelque chose**, **gagné de l'argent**, et **compris le rythme du jeu**. Il sait ce qu'il fera demain.

**Ce que SimAgri fait bien** : le joueur commence avec du matériel, de la terre, et un solde. Il peut agir immédiatement.

**Ce que SimAgri fait mal** : aucun guidage. Le nouveau joueur découvre par essai-erreur, ou via le forum. Beaucoup abandonnent avant de comprendre.

### 1.2 Gameplay loop de l'onboarding

```
┌─────────────────────────────────────────────────────────────────┐
│  LES 30 PREMIÈRES MINUTES                                       │
└─────────────────────────────────────────────────────────────────┘

  INSCRIPTION (3 min)
    Pseudo + email + mot de passe → Région → Serveur → Nom ferme
        ↓
  DOTATION (instantané)
    Le joueur reçoit : solde + parcelles + bâtiment + matériel
        ↓
  TUTORIEL GUIDÉ (20-25 min)
    Étape 1 : Préparer le sol         → Récompense + explication
    Étape 2 : Semer une culture        → Récompense + explication
    Étape 3 : Accélérer le temps       → Le joueur voit sa culture pousser
    Étape 4 : Récolter                 → Récompense + explication
    Étape 5 : Vendre                   → L'ARGENT TOMBE 💰
    Étape 6 : Premier investissement   → Le joueur choisit quoi acheter
        ↓
  FIN DU TUTORIEL
    Dashboard → objectifs suggérés → "à demain !"
```

### 1.3 Différence Normal / Expert à l'onboarding

| Aspect | Normal | Expert |
|--------|--------|--------|
| Tutoriel | Complet, 6 étapes guidées | Même tutoriel + encart "En Expert, vous auriez aussi..." |
| Dotation | Identique | Identique |
| Première culture | Orge de printemps (déjà en place, presque mûre) | Idem |
| Complexité montrée | Minimale (1 engrais, 1 action = 1 résultat) | Indices de profondeur (N-P-K mentionné, météo affichée) |
| Risque d'échec | Impossible | Impossible (tutoriel protégé) |

---

## 2. Parcours d'inscription

### 2.1 Création de compte

**Principe** : 3 champs, 30 secondes. Rien de plus.

| Champ | Contraintes | Justification |
|-------|-------------|---------------|
| Pseudo | 3-16 caractères, unique | Identité en jeu |
| Email | Valide, unique | Récupération + notifications |
| Mot de passe | 8+ caractères | Sécurité minimale |

Pas de captcha au premier écran (anti-friction). Vérification email différée (le joueur peut commencer à jouer immédiatement, validation requise sous 48h).

### 2.2 Choix de la région/département

**Écran 2** : une carte de France cliquable.

Le joueur choisit son département. Impact en jeu :

| Paramètre impacté | Exemple |
|-------------------|---------|
| Rendements de base | Beauce : blé 85 q/ha ; Massif Central : blé 55 q/ha |
| Races locales disponibles | Bretagne : Pie Noire ; Sud-Ouest : Blonde d'Aquitaine |
| Climat (Expert) | Pluviométrie, gel, sécheresse estivale |
| Prix du foncier | Île-de-France : 9 000 €/ha ; Creuse : 3 200 €/ha |
| Spécialisations favorisées | Champagne : grandes cultures ; Normandie : lait |

**En Normal** : le département influence les rendements et les races, mais aucun département n'est "mauvais". Tous sont viables.

**Texte d'aide affiché** : *"Chaque région a ses forces. Il n'y a pas de mauvais choix — seulement des spécialités différentes."*

### 2.3 Choix du serveur

Écran explicite, obligatoire, avec description honnête. Le joueur choisit sur quel serveur créer sa première exploitation. Chaque serveur est un univers indépendant avec sa propre économie, son propre marché et ses propres classements (cf. ADR-005).

```
┌─ Choisir votre serveur ─────────────────────────────────────────┐
│                                                                  │
│  🌾 NORMAL — « Je veux gérer ma ferme »                           │
│     👥 1 247 exploitants actifs                                   │
│                                                                  │
│     • Progression fluide, décisions claires                      │
│     • Charges allégées (12%)                                     │
│     • La météo influence, elle ne bloque pas                     │
│     • Faillite impossible                                        │
│     • Un oubli coûte du temps, jamais votre ferme                │
│                                                                  │
│     → Recommandé pour découvrir Agriva                           │
│                              [ Créer ma ferme ici ]              │
│                                                                  │
│  ─────────────────────────────────────────────────────────────   │
│                                                                  │
│  🔬 EXPERT — « Je veux comprendre et optimiser »                  │
│     👥 386 exploitants actifs                                     │
│                                                                  │
│     • Simulation agronomique et économique réaliste              │
│     • Charges réelles (28%), risques réels                       │
│     • La météo bloque les travaux                                │
│     • Maladies, pannes, crises à gérer                           │
│     • Une mauvaise gestion peut mener au redressement            │
│                                                                  │
│     ⚠️ Plus exigeant. Prévoyez d'y consacrer plus d'attention.    │
│                                                                  │
│     → Recommandé si vous aimez la technique agricole             │
│                              [ Créer ma ferme ici ]              │
│                                                                  │
│  💡 Vous pouvez avoir une exploitation sur CHAQUE serveur.        │
│     Rien n'est transférable de l'un à l'autre.                   │
└──────────────────────────────────────────────────────────────────┘
```

**Design critique** :
- Le serveur Normal est visuellement en premier. L'Expert ne doit pas paraître "supérieur" — juste différent.
- Le nombre de joueurs actifs est affiché en temps réel : cela rassure sur la vitalité du serveur et informe honnêtement.
- Le joueur peut créer une exploitation sur **chaque** serveur (une par serveur maximum). Ce choix n'est donc pas irréversible.
- **Aucun transfert** n'est possible entre serveurs : ni argent, ni matériel, ni animaux, ni terres. Chaque exploitation est totalement indépendante.

### 2.4 Nom de l'exploitation

Dernier écran. Un champ libre (3-40 caractères). Suggestions aléatoires proposées :
- "La Ferme des Tilleuls"
- "GAEC du Moulin"
- "Les Hauts de [nom département]"

Le joueur peut taper ce qu'il veut. Filtrage des noms offensants.

**Bouton final** : `[ Créer ma ferme → ]`

Temps total d'inscription visé : **2-3 minutes**.


---

## 3. Dotation de départ

### 3.1 Principes

Le joueur doit pouvoir **agir immédiatement** après l'inscription. Chaque élément de la dotation a une justification :

| Principe | Conséquence |
|----------|-------------|
| Agir dès la première minute | Matériel + parcelle prête = première action possible |
| Pas de décision bloquante au jour 1 | Dotation standardisée, pas de choix paralysant |
| Marge de manœuvre financière | Solde suffisant pour 2-3 investissements sans emprunt |
| Progression visible rapidement | Le premier cycle de culture doit rapporter |

### 3.2 Composition de la dotation

| Élément | Détail | Valeur estimée | Justification |
|---------|--------|:--------------:|---------------|
| **Solde initial** | Trésorerie disponible | 50 000 € | Permet d'acheter 1-2 équipements ou 10 ha de terre |
| **Parcelle 1** | 8 ha en propriété, orge de printemps déjà semée (stade épiaison) | ~25 600 € (foncier) | Culture rapide quasi prête pour le tutoriel |
| **Parcelle 2** | 12 ha en propriété, libre (sol nu) | ~38 400 € (foncier) | Surface pour le premier vrai semis du joueur |
| **Hangar** | 1 bâtiment de stockage (200 t) | 45 000 € | Stocker la récolte (option de vente différée) |
| **Tracteur** | 1 tracteur 110 CV d'occasion (8 ans, 4 500 h) | 28 000 € | Suffisant pour 20 ha, pas optimal (envie d'upgrader) |
| **Charrue** | 4 corps, occasion | 8 500 € | Travail du sol basique |
| **Combiné semoir** | Herse rotative + semoir 3 m, occasion | 12 000 € | Semer immédiatement |
| **Épandeur** | Épandeur centrifuge 1 500 L, occasion | 4 500 € | Fertilisation |
| **Pulvérisateur** | Pulvé traîné 800 L, 12 m, occasion | 7 000 € | Traitements |
| **Moissonneuse** | ❌ Non incluse | — | Trop cher (80 000 €+), force le premier choix stratégique |

**Valeur totale de la dotation** : ~219 000 € (foncier + bâtiment + matériel + trésorerie)

### 3.3 Justification du solde initial : 50 000 €

```
Budget type d'un nouveau joueur après tutoriel :

Option A — Acheter une moissonneuse d'occasion :
  Moissonneuse 90 CV, 5 m, 12 ans    = 35 000 €
  Reste en trésorerie                 = 15 000 €
  → Le joueur est autonome pour sa moisson

Option B — Faire appel à une ETA pour la moisson :
  Prestation moisson 8 ha orge        = 1 200 € (150 €/ha)
  Prestation moisson 12 ha blé        = 1 800 €
  Reste pour acheter de la terre      = 47 000 €
  → Le joueur agrandit sa surface, paie la moisson en prestation

Option C — Acheter de la terre :
  10 ha supplémentaires (Beauce)      = 32 000 €
  Reste en trésorerie                 = 18 000 €
  → Le joueur double sa surface
```

Le solde de 50 000 € permet **au moins deux stratégies viables** dès le jour 1. C'est le minimum pour que le joueur ait un vrai choix.

### 3.4 Pourquoi pas de moissonneuse ?

La moissonneuse est volontairement absente pour créer le **premier choix stratégique** :
- Acheter une moissonneuse = autonomie mais capital immobilisé
- Payer une ETA = moins cher mais dépendance
- Rejoindre une CUMA = solution sociale (découverte du multijoueur)

Ce choix intervient **après** le tutoriel (la moisson du tutoriel est offerte en prestation gratuite — cadeau de bienvenue).

### 3.5 L'orge de printemps pré-semée

**Pourquoi l'orge de printemps ?**
- Cycle court (semis mars → récolte juillet = 4 mois, vs 11 mois pour le blé)
- Le joueur arrive sur une culture au stade épiaison (il reste ~3 semaines de jeu avant récolte)
- Le tutoriel peut couvrir : fertilisation tardive → traitement → récolte → vente
- Rendement moyen : 70 q/ha × 8 ha × 195 €/t = **10 920 €** de premier revenu

Le joueur **gagne de l'argent dans sa première session**. Promesse tenue.

### 3.6 Différence Normal / Expert sur la dotation

| Aspect | Normal | Expert |
|--------|--------|--------|
| Dotation matérielle | Identique | Identique |
| Solde | 50 000 € | 50 000 € |
| État du sol (affiché) | Non | Oui (analyse de sol fournie gratuitement) |
| Crédit disponible | Pas nécessaire au départ | Ligne de crédit 30 000 € pré-approuvée |
| Comptabilité | Solde simple | Bilan d'ouverture complet |


---

## 4. Tutoriel guidé (première session, 20-25 min)

### 4.1 Principes du tutoriel

| Règle | Application |
|-------|-------------|
| **Chaque étape = 1 action** | Pas de séquence complexe, une chose à la fois |
| **Chaque étape = 1 récompense** | Le joueur est récompensé immédiatement (argent, XP, déblocage) |
| **Chaque étape = 1 apprentissage** | Le joueur comprend un concept fondamental |
| **Jamais d'échec** | Le tutoriel est scriptté : résultat garanti |
| **Sortie possible** | Le joueur peut quitter le tutoriel à tout moment (il le retrouve en revenant) |
| **Pas de mur de texte** | 2 phrases max par bulle d'aide. Le reste = tooltip optionnel |

### 4.2 Gestion du temps long

**Problème** : une culture d'orge de printemps pousse en 4 mois de jeu. Le joueur ne peut pas attendre 4 mois pour sa première récolte.

**Solution retenue** : la culture est **déjà en place et presque mûre** à l'arrivée du joueur.

```
Chronologie in-game au moment de l'inscription :
  ┌──────────────────────────────────────────────────────────┐
  │  Mars (semis) ──── Mai (montaison) ──── Juin (épiaison)  │
  │       ↑                                      ↑           │
  │   Fait "avant"                        JOUEUR ARRIVE ICI  │
  │   (backstory)                                            │
  └──────────────────────────────────────────────────────────┘
```

Le joueur est briefé : *"Votre parcelle de 8 ha d'orge a été semée au printemps. Elle est presque prête pour la récolte !"*

**Temps réel avant moisson** : 2-3 semaines de jeu (le joueur a le temps d'apprendre les bases avant de moissonner). Pendant ce temps, le tutoriel lui fait faire la fertilisation et le traitement.

### 4.3 Séquence détaillée du tutoriel

#### Étape 1 — Découvrir sa ferme (2 min)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🏠 Bienvenue sur votre exploitation !                              │
│                                                                     │
│  ┌─ Votre ferme ─────────────────────────────────────────────────┐  │
│  │                                                               │  │
│  │  📍 GAEC du Moulin — Eure-et-Loir (28)                        │  │
│  │                                                               │  │
│  │  🌾 Parcelle "Les Grands Champs" — 8 ha                       │  │
│  │     Orge de printemps — Stade : épiaison 🟡                   │  │
│  │     Récolte estimée : dans 18 jours                           │  │
│  │                                                               │  │
│  │  🟫 Parcelle "Le Clos" — 12 ha                                │  │
│  │     Sol nu — prêt à être travaillé                            │  │
│  │                                                               │  │
│  │  🏗️ Hangar (200 t) — vide                                     │  │
│  │                                                               │  │
│  │  💰 Trésorerie : 50 000 €                                     │  │
│  │                                                               │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  💬 "Votre orge sera prête dans 18 jours. En attendant,            │
│      occupons-nous de votre deuxième parcelle !"                   │
│                                                                     │
│                                            [ Continuer → ]          │
└─────────────────────────────────────────────────────────────────────┘
```

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Regarde le dashboard | Vue d'ensemble de sa ferme | Rien (observation) |

#### Étape 2 — Préparer le sol (3 min)

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Sélectionne la parcelle "Le Clos" → Labour | Le sol doit être préparé avant de semer | +500 € bonus "Premier labour" |

**Action guidée** : clic sur la parcelle → menu "Travaux" → "Labourer" → confirmation.

**Feedback immédiat** : animation de la parcelle qui change de couleur (marron retourné). Message : *"Sol prêt ! Vous pouvez maintenant semer."*

**Coût affiché** : carburant 38 €/ha × 12 ha = 456 €. Le joueur voit que chaque action a un coût.

#### Étape 3 — Semer du blé (3 min)

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Sélectionne "Le Clos" → Semer → Blé tendre d'hiver | Le calendrier des cultures, le choix d'une espèce | +500 € bonus "Premier semis" |

**Choix simplifié** : le tutoriel propose 3 cultures avec une recommandation.

```
┌─ Que souhaitez-vous semer ? ──────────────────────────────────────┐
│                                                                    │
│  ⭐ Blé tendre d'hiver (recommandé)                               │
│     Rendement : 80 q/ha — Récolte : juillet prochain              │
│     Recette estimée : 19 200 € pour 12 ha                         │
│                                                                    │
│  ○ Colza d'hiver                                                   │
│     Rendement : 35 q/ha — Récolte : juillet prochain              │
│     Recette estimée : 18 900 € pour 12 ha                         │
│                                                                    │
│  ○ Orge d'hiver                                                    │
│     Rendement : 70 q/ha — Récolte : juin prochain                 │
│     Recette estimée : 16 800 € pour 12 ha                         │
│                                                                    │
│                                           [ Semer → ]              │
└────────────────────────────────────────────────────────────────────┘
```

**Coût** : semences blé 80 €/ha × 12 ha = 960 €.

#### Étape 4 — Fertiliser l'orge (3 min)

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Sélectionne "Les Grands Champs" → Fertiliser | L'engrais augmente le rendement | +300 € bonus "Premier épandage" |

**En Normal** : un seul choix "Engrais complet" à dose recommandée. Coût : 95 €/ha × 8 ha = 760 €.

**En Expert** : le tutoriel montre la même action mais affiche N-P-K dans un encart informatif (pas d'action supplémentaire demandée pendant le tutoriel).

#### Étape 5 — Récolter l'orge (3 min, après 18 jours de jeu)

Le joueur revient après quelques connexions. L'orge est mûre.

**Note** : si le joueur s'est inscrit depuis moins de 3 jours, l'orge mûrit accélérée (×3) pour garantir une récolte dans les 72h réelles. Au-delà de 72h, le joueur serait parti.

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Sélectionne "Les Grands Champs" → Récolter | La moisson est le moment de paie | Récolte : 56 t d'orge (70 q/ha × 8 ha, dont +5 q grâce à la fertilisation) |

**Prestation offerte** : la moisson est réalisée gratuitement par une ETA (cadeau de bienvenue). Message : *"Un voisin vous prête sa moissonneuse pour votre première récolte !"*

Cela évite le problème de ne pas avoir de moissonneuse, et introduit le concept d'ETA.

#### Étape 6 — Vendre la récolte (3 min)

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Va au négoce → Vend l'orge | Le marché, les prix, le revenu | 56 t × 195 €/t = **10 920 €** 💰 |

```
┌─ Vente de récolte ────────────────────────────────────────────────┐
│                                                                    │
│  🌾 Orge de printemps — 56 tonnes disponibles                      │
│                                                                    │
│  Prix du jour : 195 €/t                                            │
│  📈 Tendance : stable                                              │
│                                                                    │
│  Vendre :  [ Tout (56 t) ▼ ]                                      │
│                                                                    │
│  Revenu estimé : 10 920 €                                          │
│                                                                    │
│  💡 Vous pouvez aussi stocker dans votre hangar et vendre           │
│     plus tard si les prix montent.                                 │
│                                                                    │
│              [ Stocker ]           [ Vendre maintenant → ]         │
└────────────────────────────────────────────────────────────────────┘
```

**Moment clé** : le joueur voit son solde passer de ~47 000 € à ~57 000 €. C'est la dopamine. Il a gagné de l'argent.

#### Étape 7 — Premier investissement libre (5 min)

Le tutoriel se termine par un choix **libre** (pas imposé). Le joueur décide quoi faire ensuite :

| Ce que le joueur fait | Ce qu'il apprend | Ce qu'il gagne |
|----------------------|------------------|----------------|
| Choisit un investissement parmi 3 suggestions | L'autonomie — il peut décider seul | L'objet acheté + satisfaction du choix |

**Suggestions (pas obligatoires)** :
1. "Acheter une moissonneuse d'occasion" → autonomie pour la prochaine récolte
2. "Acheter 10 ha de terre" → agrandissement
3. "Explorer le marché aux animaux" → diversification

**Fin du tutoriel** : message de félicitations, récapitulatif de ce qui a été accompli.

### 4.4 Récapitulatif du tutoriel

| Étape | Durée | Coût joueur | Gain joueur | Solde après |
|-------|:-----:|:-----------:|:-----------:|:-----------:|
| 1. Découvrir | 2 min | 0 € | 0 € | 50 000 € |
| 2. Labourer | 3 min | -456 € | +500 € | 50 044 € |
| 3. Semer | 3 min | -960 € | +500 € | 49 584 € |
| 4. Fertiliser | 3 min | -760 € | +300 € | 49 124 € |
| 5. Récolter | 3 min | 0 € (offert) | 56 t en stock | 49 124 € |
| 6. Vendre | 3 min | 0 € | +10 920 € | 60 044 € |
| 7. Investir | 5 min | Variable | Variable | Variable |

**Bilan** : le joueur termine le tutoriel avec **~10 000 € de plus** qu'au départ et une compréhension du cycle complet cultures.


---

## 5. Progression guidée (premières semaines)

### 5.1 Objectifs suggérés

Après le tutoriel, le joueur reçoit des **objectifs suggérés** (jamais imposés). Ils apparaissent dans un panneau latéral "Prochaines étapes".

| Semaine | Objectif suggéré | Récompense | Ce que ça enseigne |
|:-------:|-----------------|:----------:|-------------------|
| 1 | "Récolte ton blé sur Le Clos" | 1 000 € bonus | Patience, cycle long |
| 1 | "Achète ou loue une moissonneuse" | Badge "Autonome" | Investissement stratégique |
| 2 | "Atteins 30 ha de surface" | 2 000 € bonus | Agrandissement, marché foncier |
| 2 | "Vends pour 20 000 € de récolte" | Badge "Commerçant" | Accumulation |
| 3 | "Achète tes premiers animaux" | 3 000 € bonus | Diversification |
| 3 | "Rejoins une coopérative" | Badge "Sociable" | Découverte du multijoueur |
| 4 | "Emploie un salarié ou fais appel à une ETA" | 1 500 € bonus | Gestion du travail |
| 4 | "Construis un nouveau bâtiment" | Badge "Bâtisseur" | Investissement structure |

**Principe** : les objectifs sont des **incitations**, pas des obligations. Le joueur peut les ignorer totalement. Ils disparaissent s'il les dépasse naturellement (ex : s'il achète des animaux avant la semaine 3, l'objectif est coché automatiquement).

### 5.2 Déblocage progressif : NON

**Décision** : tous les systèmes sont disponibles dès le jour 1. Pas de déblocage progressif.

**Justification** :

| Argument pour le déblocage | Contre-argument (décisif) |
|---------------------------|--------------------------|
| Évite la surcharge | L'UI épurée + les objectifs guidés suffisent |
| Force un chemin d'apprentissage | Viole ADR-002 : "pas de frein à la progression" |
| Donne un sentiment de progression | L'accumulation (acheter, agrandir) est déjà le moteur |
| Autres jeux le font | SimAgri ne le fait pas, et ça marche depuis 2005 |

**Le problème du déblocage** : si un joueur SimAgri rejoint Agriva et ne peut pas acheter de vaches au jour 1, il dira "c'est plus contraignant que SimAgri". Violation directe de l'ADR-002.

**La solution** : guidage par l'UI, pas par le verrouillage.
- Les systèmes complexes (ETA, Labels, Génétique) sont **visibles mais non mis en avant** pour un nouveau joueur
- Le dashboard du jour 1 montre : parcelles, matériel, trésorerie. Les onglets "Élevage", "Marché", "Coopérative" sont accessibles mais pas dans le focus
- Les tooltips disent "disponible" et proposent un mini-guide si le joueur clique

### 5.3 Visibilité progressive de la complexité

Sans verrouiller, on peut **révéler progressivement** :

| Moment | Ce qui apparaît | Déclencheur |
|--------|----------------|-------------|
| Jour 1 | Dashboard simple : parcelles, matériel, solde | Inscription |
| Jour 3 | Notification "Le marché aux bestiaux est ouvert" | Fin tutoriel culture |
| Semaine 1 | Encart "Saviez-vous ? Vous pouvez louer vos machines" | Première moisson réussie |
| Semaine 2 | "Les coopératives recrutent !" | 20 000 € de CA cumulé |
| Semaine 3 | "Le fermage : agrandir sans acheter" | 30 ha atteints |
| Semaine 4 | "Créer une ETA : travaillez pour les autres" | 50 h de travaux réalisés |

Ce sont des **notifications ponctuelles**, pas des verrous. Le joueur curieux peut tout explorer dès le jour 1.

---

## 6. Aide contextuelle

### 6.1 Architecture de l'aide

Trois niveaux, du plus léger au plus profond :

```
Niveau 1 — TOOLTIPS (survol)
  Apparaît au survol de tout élément d'interface.
  1 phrase max. Exemple : "Rendement : quantité récoltée par hectare."

Niveau 2 — ENCARTS CONTEXTUELS (dans l'action)
  Apparaît quand le joueur est dans un écran d'action.
  3-5 phrases. Exemple dans l'écran de fertilisation :
  "L'engrais augmente votre rendement. La dose recommandée est
   de 180 unités/ha pour le blé. En mettre plus ne sert à rien."

Niveau 3 — ENCYCLOPÉDIE (recherche active)
  Page dédiée par sujet (culture, élevage, matériel...).
  Accessible via icône 📖 ou barre de recherche.
  Articles de 200-400 mots avec illustrations.
```

### 6.2 Conseils du jeu ("Le saviez-vous ?")

Un système de notifications non-intrusives, 1 par session max :

| Contexte | Conseil affiché |
|----------|----------------|
| Le joueur n'a pas vendu depuis 7 jours | "Vos récoltes prennent de la place. Pensez à vendre ou à construire du stockage !" |
| Le joueur a 80 000 € en banque sans investir | "Avec ce capital, vous pourriez acheter 20 ha de terre ou un nouveau tracteur." |
| Le joueur n'a pas d'animaux après 3 semaines | "L'élevage est une source de revenus réguliers. Visitez le marché aux bestiaux !" |
| Le joueur est en Expert et fait une erreur | "Attention : le sol est trop humide pour le labour. Attendez 2 jours." |

### 6.3 Différence Normal / Expert dans l'aide

| Aspect | Normal | Expert |
|--------|--------|--------|
| Tooltips | Simples (1 phrase, résultat) | Détaillés (formule, facteurs) |
| Recommandations | "Dose recommandée : 180 u/ha" (1 clic) | "Bilan azoté : reliquat 40 + minéralisation 30 = fourniture sol 70. Besoin 250. Apport conseillé : 180 u/ha en 2 passages." |
| Alertes | "Pensez à fertiliser" | "Stade tallage atteint : fenêtre optimale N1 = 5 jours" |
| Encyclopédie | Mêmes articles, version simplifiée par défaut | Version complète avec données agronomiques |


---

## 7. Découvrir le serveur Expert

### 7.1 Principe : une seconde exploitation, pas un « passage »

Il n'y a **pas de passage** d'un serveur à l'autre. Le joueur crée une **seconde exploitation** sur le serveur Expert, indépendante de sa ferme Normal. Les deux coexistent.

```
Compte joueur (identité unique)
  ├── 🌾 Exploitation sur le serveur Normal   → continue de tourner
  └── 🔬 Exploitation sur le serveur Expert   → nouvelle ferme, dotation standard
```

**Sa ferme Normal continue d'exister et de tourner** : les ticks s'écoulent, les cultures poussent, les animaux mangent. Le joueur n'abandonne rien — il ajoute une seconde ferme à gérer.

### 7.2 Quand un joueur est-il prêt pour Expert ?

Le serveur Expert est accessible à tout moment via l'écran « Mes exploitations ». Pas de verrou.

Cependant, le jeu **suggère** la découverte d'Expert lorsque le joueur a vécu **au moins un cycle annuel complet** sur le serveur Normal. Ce critère est recommandé pour les raisons suivantes :

| Raison | Explication |
|--------|-------------|
| Le joueur a vu toutes les saisons | Il comprend le rythme du jeu, les semis, les récoltes, les bilans |
| Il a un point de comparaison | Il sait ce que « Normal » signifie, donc il appréciera les différences d'Expert |
| Sa ferme Normal est autonome | Avec un an d'exploitation, il a assez de surface et de matériel pour que la ferme tourne avec moins d'attention |
| Il ne sera pas déstabilisé | Les mécaniques de base (marché, travail du sol, vente) sont acquises |

**Notification suggérée (après 1 cycle annuel complet)** :
> *"Vous avez bouclé votre première année ! Envie de découvrir la simulation réaliste ? Le serveur Expert vous attend — votre ferme Normal continuera de tourner."*

### 7.3 Ce qui est partagé et ce qui ne l'est pas

| Élément | Partagé entre serveurs ? | Détail |
|---------|:------------------------:|--------|
| Compte (login, email) | ✅ Oui | Un seul compte pour tout |
| Liste d'amis | ✅ Oui | Les relations sociales sont globales |
| Messagerie privée | ✅ Oui | On discute avec un joueur, pas avec une ferme |
| Forum | ✅ Oui | Communauté commune, catégories par serveur |
| Abonnement premium | ✅ Oui | Souscrit une fois, actif partout |
| Encyclopédie / aide | ✅ Oui | Contenu de référence identique |
| **Argent** | ❌ Non | Économies cloisonnées |
| **Matériel** | ❌ Non | Pas de transfert |
| **Cheptel** | ❌ Non | Pas de transfert |
| **Terres** | ❌ Non | Pas de transfert |
| **Réputation** | ❌ Non | Propre à chaque serveur |
| **Classements** | ❌ Non | Propres à chaque serveur |
| **Coopératives, CUMA** | ❌ Non | Structures locales au serveur |

**Règle absolue** : aucun transfert de richesse ou de bien n'est possible entre serveurs. Chaque exploitation repart de zéro avec la dotation standard (cf. §3).

### 7.4 Gestion du temps de jeu entre deux fermes

Le joueur qui possède deux exploitations gère librement son temps :

| Aspect | Fonctionnement |
|--------|---------------|
| Connexion | Le joueur choisit sur quel serveur se connecter via l'écran « Mes exploitations » |
| Ticks | Les deux fermes avancent en parallèle, même quand le joueur est connecté sur l'autre |
| Notifications | Le joueur reçoit les alertes des deux fermes (configurable) |
| Temps recommandé | 2-3 sessions/semaine par ferme (le rythme du jeu est conçu pour ça) |
| Risque d'absence | En Normal : aucun dommage (cf. §9.1). En Expert : les animaux non nourris perdent du poids, les travaux non faits manquent leur fenêtre |

**Conseil de design** : le joueur n'est jamais puni d'avoir deux fermes. Le jeu est conçu pour des sessions courtes. Gérer deux exploitations revient à doubler le nombre de sessions (4-6/semaine au total), pas à doubler la durée de chaque session.

### 7.5 Comment créer sa seconde exploitation

Depuis n'importe quel écran : Menu → « Mes exploitations » → « Créer une exploitation sur le serveur Expert »

Le joueur passe par le même processus qu'à l'inscription (choix de région, nom de ferme), mais sans recréer de compte. Il reçoit la dotation standard Expert (identique à §3, avec les spécificités Expert du §3.6).

### 7.6 Écran « Mes exploitations »

```
┌─ Mes exploitations ─────────────────────────────────────────────┐
│                                                                  │
│  👤 Jean-Pierre Dumont                                           │
│     Compte premium ⭐ — Membre depuis mars 2027                  │
│                                                                  │
│  ─────────────────────────────────────────────────────────────   │
│                                                                  │
│  🌾 SERVEUR NORMAL                                                │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  GAEC du Moulin — Eure-et-Loir (28)                        │  │
│  │  📏 84 ha │ 🐄 45 Charolaises │ 💰 127 340 €                │  │
│  │  📅 En jeu depuis 14 mois                                   │  │
│  │  🌾 Blé : stade montaison │ Colza : en fleur               │  │
│  │  ⚡ 2 alertes : fertilisation N2 blé, vêlage prévu J+3     │  │
│  │                                                            │  │
│  │                        [ Gérer cette exploitation → ]       │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│  🔬 SERVEUR EXPERT                                                │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Ferme de la Vallée — Côtes-d'Armor (22)                   │  │
│  │  📏 20 ha │ 🐄 — │ 💰 52 180 €                              │  │
│  │  📅 En jeu depuis 2 mois                                    │  │
│  │  🌾 Orge : récolte dans 8 jours │ Prairie : 1ère coupe OK  │  │
│  │  ⚡ 1 alerte : météo — pluie 40 mm prévue demain           │  │
│  │                                                            │  │
│  │                        [ Gérer cette exploitation → ]       │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│  💡 Les deux fermes avancent en parallèle. Votre temps est       │
│     votre seule ressource partagée.                              │
└──────────────────────────────────────────────────────────────────┘
```

### 7.7 Et si le joueur veut quitter Expert ?

Le joueur peut **supprimer** son exploitation Expert à tout moment. C'est irréversible (confirmation par saisie de texte « SUPPRIMER »). Sa ferme Normal n'est pas affectée.

Il ne peut pas « ramener » quoi que ce soit d'Expert vers Normal. C'est un abandon pur et simple.

S'il veut revenir sur Expert plus tard, il crée une nouvelle exploitation (repartant de zéro avec la dotation standard).

---

## 8. Rétention : pourquoi revenir demain ?

### 8.1 Les hooks de rétention

| Hook | Mécanisme | Fréquence |
|------|-----------|-----------|
| **La culture pousse** | "Votre blé est au stade montaison. Fertilisation possible !" | Notification push/email |
| **Le prix monte** | "Le prix de l'orge a grimpé à 210 €/t (+10%). Vendre ?" | Quand seuil dépassé |
| **Un voisin a besoin** | "La CUMA cherche un chauffeur pour la moisson" | Événement social |
| **Objectif proche** | "Plus que 5 ha pour atteindre 30 ha !" | Quand 80% atteint |
| **Le bilan approche** | "Fin de campagne dans 7 jours. Bilan provisoire : +35 000 €" | Annuel |
| **Marché aux bestiaux** | "Vente aux enchères de Charolaises demain 14h" | Événement planifié |

### 8.2 Le rythme idéal de connexion

**Objectif** : le joueur revient **2-3 fois par semaine**, 10-15 minutes par session.

Le jeu ne punit pas l'absence (ADR-002, règle 6 : pas de perte définitive). Un joueur absent 2 semaines retrouve sa ferme intacte. Mais le jeu **récompense** la présence régulière :

| Connexion | Récompense |
|-----------|-----------|
| Quotidienne | Bonus connexion : +200 € (symbolique) |
| Action quotidienne | Les cultures avancent (même sans action, mais les interventions optimisent) |
| Hebdomadaire | Récapitulatif de la semaine envoyé par email |
| Après 3 jours d'absence | Notification douce : "Vos cultures poussent bien. Un petit tour ?" |

### 8.3 Le dashboard du jour 1 (après tutoriel)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🏠 GAEC du Moulin — Eure-et-Loir          💰 60 044 €    Jour 1   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📋 AUJOURD'HUI                                                     │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  ✅ Tutoriel terminé — Bravo !                                 │  │
│  │  🌾 Blé semé sur "Le Clos" (12 ha) — Levée dans 12 jours      │  │
│  │  💡 Suggestion : "Achète une moissonneuse pour l'été"          │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  🌾 MES PARCELLES                                                   │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Les Grands Champs  │ 8 ha  │ Libre (récolté) │ —            │  │
│  │  Le Clos            │ 12 ha │ Blé tendre      │ Semé 🟢      │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  🚜 MON MATÉRIEL                                                    │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Tracteur 110 CV    │ Disponible │ 4 500 h                    │  │
│  │  Charrue 4 corps    │ Disponible │ OK                         │  │
│  │  Combiné semoir 3 m │ Disponible │ OK                         │  │
│  │  Épandeur 1 500 L   │ Disponible │ OK                         │  │
│  │  Pulvérisateur 12 m │ Disponible │ OK                         │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  🎯 PROCHAINES ÉTAPES (optionnel)                                   │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  ○ Acheter une moissonneuse           → Autonomie moisson     │  │
│  │  ○ Acheter de la terre                → Augmenter tes revenus │  │
│  │  ○ Découvrir le marché aux bestiaux   → Diversification       │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  [ 🌾 Parcelles ] [ 🚜 Matériel ] [ 🐄 Élevage ] [ 💶 Marché ]     │
│  [ 🏗️ Bâtiments ] [ 🤝 Coopérative ] [ 📖 Encyclopédie ]           │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Équilibrage : le joueur peut-il échouer ?

### 9.1 Réponse : NON en Normal

Conformément à l'ADR-002, règle 3 : **pas de perte définitive**.

| Situation | En Normal | En Expert |
|-----------|-----------|-----------|
| Récolte ratée (oubli de traitement) | Rendement -20% max, jamais 0 | Rendement -50% possible, 0 si gel/grêle |
| Faillite | **Impossible**. Plancher à 0 €, pas de dette bloquante | Possible → redressement judiciaire |
| Mort d'animaux | Jauge santé ne descend jamais sous 30% | Mortalité réaliste si négligence |
| Solde négatif | Le jeu empêche les achats, mais pas de pénalité | Découvert bancaire → intérêts → saisie |
| 2 semaines d'absence | Rien ne meurt, cultures sur pause | Animaux non nourris = perte de poids/lait |

### 9.2 Le filet de sécurité Normal

```
SI solde < 5 000 € ET aucune récolte en attente :
  → Notification : "Vous êtes à court de trésorerie."
  → Proposition : "Vendez du matériel inutilisé" ou "Demandez un prêt (taux 0%)"
  → Le prêt à taux 0 est un mécanisme anti-blocage (5 000 € max, remboursable quand le joueur veut)

SI le joueur ne se connecte pas depuis 14 jours :
  → Les cultures sont mises en pause (pas de pourrissement)
  → Les animaux sont nourris automatiquement (pas de mort)
  → Email : "Votre ferme vous attend !"
```

### 9.3 Pourquoi c'est important

La peur de l'échec est le **premier facteur d'abandon** dans les jeux de gestion complexes. Un joueur qui perd sa progression dans les premiers jours ne revient jamais.

En Normal, le pire qui puisse arriver :
- Le joueur ne peut plus acheter (solde trop bas) → solution : vente de matériel ou prêt à taux 0
- Le joueur fait un mauvais investissement → il revend à perte (mais pas à 0)
- Le joueur est inefficace → il progresse plus lentement, mais il progresse toujours

**Le serveur Expert** est le lieu de l'échec constructif. Le joueur qui choisit Expert accepte le risque. Mais même en Expert, la faillite est un processus lent (6+ mois de mauvaise gestion) avec des alertes multiples.

---

## 10. Scénario chiffré : les 30 premières minutes

### 10.1 Joueur Normal, département Eure-et-Loir

```
INSCRIPTION (3 min)
  → Serveur Normal, région Beauce

DOTATION REÇUE :
  Solde               : 50 000 €
  Parcelle 1 (8 ha)  : orge printemps, stade épiaison
  Parcelle 2 (12 ha) : sol nu
  Matériel            : tracteur 110 CV + outils
  Hangar              : 200 t

TUTORIEL :
  Étape 2 — Labour 12 ha :
    Coût : 38 €/ha × 12 = -456 €
    Bonus : +500 €
    Solde : 50 044 €

  Étape 3 — Semis blé 12 ha :
    Coût semences : 80 €/ha × 12 = -960 €
    Bonus : +500 €
    Solde : 49 584 €

  Étape 4 — Fertilisation orge 8 ha :
    Coût engrais : 95 €/ha × 8 = -760 €
    Bonus : +300 €
    Solde : 49 124 €

  [... 18 jours passent, le joueur revient ...]

  Étape 5 — Récolte orge 8 ha :
    Rendement : 65 q/ha (avec fertilisation tardive : +5 q = 70 q/ha)
    Production : 70 × 8 = 560 q = 56 t
    Coût moisson : 0 € (prestation offerte)
    Solde : 49 124 € + 56 t en stock

  Étape 6 — Vente orge :
    Prix : 195 €/t × 56 t = +10 920 €
    Solde : 60 044 €

BILAN APRÈS 30 MIN EFFECTIVES :
  Solde final         : 60 044 €
  Gain net            : +10 044 €
  Cultures en place   : 12 ha de blé (récolte dans 9 mois)
  Prochain revenu     : ~19 200 € (blé à la moisson)
  Progression ressentie : FORTE ✅
```

### 10.2 Vérification ADR-002

| Règle ADR-002 | Respectée ? | Preuve |
|---------------|:-----------:|--------|
| 1. Pas de frein à la progression | ✅ | Gain net +10 044 € en 30 min |
| 2. Pas de complexité obligatoire | ✅ | 1 clic par action, dose recommandée auto |
| 3. Pas de perte définitive | ✅ | Tutoriel scriptté, résultat garanti |
| 4. Nouveautés = bonus | ✅ | ETA offerte = cadeau, pas contrainte |
| 5. Information suffisante | ✅ | Tooltips + encarts contextuels |
| 6. Social prime | ✅ | ETA = première interaction avec un "voisin" |
| 7. Accumulation = moteur | ✅ | +10 044 € + choix d'investissement libre |

---

## Annexe — Récapitulatif des paramètres

| Paramètre | Valeur | Justification |
|-----------|:------:|---------------|
| Solde initial | 50 000 € | 2-3 investissements possibles sans emprunt |
| Surface offerte | 20 ha (8 + 12) | Viable en grandes cultures, pas trop gros |
| Tracteur départ | 110 CV, 8 ans, 4 500 h | Suffisant pour 20 ha, envie d'upgrader |
| Culture pré-semée | Orge de printemps, 8 ha, stade épiaison | Récolte rapide pour le tutoriel |
| Accélération premier cycle | ×3 si inscription < 3 jours | Garantir une récolte dans les 72h réelles |
| Rendement orge tutoriel | 70 q/ha (avec bonus fertilisation) | Revenu 10 640 € = satisfaisant |
| Prix orge | 195 €/t | Prix de référence France 2024-2025 |
| Bonus tutoriel (total) | 1 300 € | Symbolique, ne déséquilibre pas |
| Prêt anti-blocage Normal | 5 000 € à taux 0% | Filet de sécurité, pas une stratégie |
| Moisson tutoriel | Gratuite (prestation ETA offerte) | Évite le problème pas-de-moissonneuse |
| Objectifs suggérés | 8 sur 4 semaines | Non-bloquants, disparaissent si dépassés |
| Notifications max | 1 conseil/session | Non-intrusif |
| Bonus connexion quotidienne | 200 € | Symbolique, incite sans punir l'absence |

---

## Checklist playtest

| Test | Critère de réussite | Bloquant ? |
|------|--------------------:|:----------:|
| Inscription < 3 min | Le joueur arrive sur le dashboard en < 3 min | ✅ Oui |
| Tutoriel complété < 25 min | 90% des testeurs finissent le tutoriel | ✅ Oui |
| Premier revenu | Le joueur a gagné de l'argent avant de quitter | ✅ Oui |
| Pas de blocage | Aucun testeur ne se retrouve "coincé" | ✅ Oui |
| Test recette SimAgri | Un joueur SimAgri dit "c'est SimAgri en mieux" | ✅ Oui |
| Rétention J+1 | > 60% des testeurs reviennent le lendemain | ✅ Oui |
| Rétention J+7 | > 40% des testeurs sont actifs à J+7 | ⚠️ Cible |
| Serveur Expert pas effrayant | Les joueurs Expert finissent aussi le tutoriel | ✅ Oui |
| Aide contextuelle suffisante | < 5% des testeurs consultent une doc externe | ✅ Oui |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création du document | Première rédaction |
| 2026-08-04 | Choix de mode remplacé par choix de serveur ; passage Normal→Expert remplacé par création d'une seconde exploitation | ADR-005 |
