# Game Design — Décisions Tranchées (Session 2026-08-04)

> Date : 2026-08-04
> Statut : Validé
> Auteur : Direction créative

---

## 1. Économie

### Puits d'argent (money sinks)

L'argent disparaît du jeu via :
- **Charges d'entretien** (matériel, bâtiments) — proportionnelles à la richesse
- **Charges fixes** (fermage implicite, cotisations, assurance)
- **Investissements endgame** — quand les joueurs sont riches, ils investissent dans : nouveaux élevages, forêt, futures features (viticulture, fromagerie, etc.)

**Pas de taxes sur les transactions.** L'argent excédentaire est absorbé par le contenu de progression, pas par des mécaniques punitives.

### Objectifs de jeu au-delà de l'argent

| Objectif | Description |
|----------|-------------|
| 💰 Patrimoine | Classement richesse / valeur ferme |
| 🏆 Rendements | Classement meilleur rendement par culture (q/ha) |
| 🧬 Génétique | Classement meilleurs index génétiques (lait, viande) |
| 🌱 Diversification | Nombre de filières actives |
| 📊 Efficience | Marge nette / ha exploité |

Les classements sont des objectifs à long terme qui donnent envie de continuer à jouer et dépenser même quand on est "riche".

### Coopérative — Prix fixe

La coopérative (bot) achète et vend à **prix fixe**. Pas de dynamique d'offre/demande sur la coop.

Le **marché joueurs** est libre (offre/demande entre joueurs).

→ La coop est le filet de sécurité (tu peux toujours vendre), le marché joueurs est l'optimisation (meilleur prix possible mais pas garanti).

---

## 2. Late Joiner & Foncier

### Philosophie : pas de rattrapage artificiel

Un joueur qui arrive tard ne rattrape pas mécaniquement les vétérans. Il rattrape **s'il joue bien**, naturellement, avec le temps. Pas de bonus, pas de protection, pas de catch-up mécanique.

### Système foncier : parcelles réservées

| Règle | Détail |
|-------|--------|
| Parcelles disponibles | **10 parcelles/joueur/mois in-game** apparaissent dans sa zone |
| Réservation | Les 5 premiers jours IG : réservées exclusivement au joueur |
| Après 5 jours | Les autres joueurs peuvent les acheter |
| Localisation | Parcelles dans la région/ville de la ferme du joueur |
| Achat hors zone | Possible mais **frais de distance** (coût croissant avec l'éloignement) |
| Terrain infini | Le jeu génère toujours de nouvelles parcelles — pas de pénurie |

→ Le late joiner a toujours accès à des parcelles neuves. Les vétérans ne monopolisent pas le foncier.

---

## 3. HT / Heures de Travail

### Système : coût variable par action

Les HT (Heures de Travail) ne sont pas un nombre fixe identique pour chaque action. Le coût dépend de :

| Facteur | Influence |
|---------|-----------|
| **Type d'action** | Labourer > nourrir des poules |
| **Surface/volume** | Labourer 10 ha > labourer 1 ha |
| **Matériel utilisé** | Gros matériel = plus rapide = moins de HT/ha |
| **Largeur de travail** | Semoir 6m = 2× moins de HT qu'un semoir 3m |
| **GPS** | Réduit les HT (précision = moins de passages) |

**Budget quotidien** : à calibrer (probablement 40-50 HT/jour de base), mais c'est l'**équilibrage global** qui déterminera le chiffre exact — chaque action doit être pesée pour que le joueur ait des choix significatifs sans être frustré.

---

## 4. Automatisation

### Philosophie : l'automatisation est un GAMEPLAY, pas un avantage payant

| Mécanisme | Détail |
|-----------|--------|
| **Employés** | Embauche contre salaire mensuel, fournit des HT supplémentaires |
| **Robot de traite** | Investissement lourd (150-180k€), supprime le besoin de traire manuellement |
| **Robot alimentation** | Automatise la distribution de rations |
| **Ordres permanents** | "Vendre à la coop quand le silo est plein" — gameplay, pas paywall |

L'automatisation nécessite toujours :
- Un **investissement financier** (achat robot, salaire employé)
- Un **coût d'entretien** (pièces, maintenance)
- Une **progression** (pas accessible au jour 1)

→ C'est un arc de progression naturel : début = tout à la main → milieu = premiers employés → endgame = ferme largement automatisée.

---

## 5. Mode Normal vs Expert

### Proposition de design

| Aspect | Normal | Expert |
|--------|--------|--------|
| **Serveur** | Serveur France Normal | Serveur France Expert |
| **Météo** | Simplifiée (3 niveaux : sec/normal/humide) | Complète (température, pluvio, vent, gel) |
| **Fertilisation** | Dose recommandée auto-calculée, le joueur valide | Le joueur calcule N-P-K et fractionne |
| **Maladies** | Alertes claires + traitement suggéré | Détection manuelle (scouting), choix du produit |
| **Rotation** | Suggestions de rotation, pénalité visible | Pas de suggestion, effet précédent masqué |
| **Économie** | Prix coop stables, marché simple | Prix fluctuants, contrats, spéculation |
| **Génétique** | Index simplifiés (bon/moyen/faible) | 14 index détaillés, croisements raisonnés |
| **Comptabilité** | Bilan simplifié (entrées/sorties) | Comptabilité complète, analyse de marge |
| **Aide** | Tutoriels intégrés, tooltips partout | Documentation wiki, pas d'aide in-game |
| **HT** | Coûts fixes visibles avant chaque action | Coûts variables selon conditions (sol humide = +HT) |

**Résumé** : 
- **Normal** = le jeu te guide, les infos sont accessibles, c'est fun et accessible
- **Expert** = le jeu ne te dit rien, tu dois comprendre et optimiser toi-même, plus réaliste et plus punitif

Les deux serveurs partagent les mêmes systèmes techniques — c'est le niveau d'**assistanat et de transparence** qui change, pas les mécaniques.

---

## 6. Monétisation

### Structure : Gratuit + 1 abonnement

| | 🌱 Gratuit | ⭐ Premium (3,99€/mois) |
|---|---|---|
| **Accès** | Toutes les mécaniques, 100% jouable | Idem |
| **Publicités** | **Aucune** | Aucune |
| **Stats** | Stats de base | Stats avancées (historiques, graphiques, comparaisons) |
| **Cosmétiques** | Thème par défaut | Thèmes visuels (couleurs, habillage ferme) |
| **Alertes** | En jeu uniquement | Push/email (récolte prête, vente réussie, vêlage) |
| **Profil** | Standard | Badge Premium visible, fiche profil personnalisée |
| **Fermes** | 1 ferme | 1 ferme (même serveur) |

### Lignes rouges (INTERDIT en Premium)

- ❌ Plus de HT / Heures de Travail
- ❌ Boost de production (rendement, lait, reproduction)
- ❌ Prix préférentiels à la coop
- ❌ Accès exclusif à des cultures/animaux/matériel
- ❌ Skip de temps (accélérer une gestation, une culture)
- ❌ Avantage compétitif quelconque dans les classements

**Principe** : le premium est du **confort et du cosmétique**, jamais de la **puissance**.

---

## 7. Météo

### Simulation climatique basée sur données historiques

| Paramètre | Source |
|-----------|--------|
| Température | Moyennes mensuelles historiques par zone (Météo-France) |
| Pluviométrie | Moyennes + distribution statistique (jours de pluie/mois) |
| Ensoleillement | Heures/mois par zone |
| Vent | Fréquence et force par zone/saison |
| Gel | Nombre de jours de gel par mois par zone |
| Événements extrêmes | Canicule, grêle, sécheresse — probabilité réaliste par zone |

### Fonctionnement

- Chaque "mois in-game" (= 1 semaine réelle), le système génère la météo de la zone
- Basé sur les **statistiques climatiques réelles** de la localisation du joueur
- **Aléa** ajouté : une année peut être plus sèche ou plus humide que la moyenne
- Pas la météo du jour en temps réel — une **simulation réaliste**
- Impact : rendement, fenêtres de travail, maladies, pâturage, irrigation

### Différences régionales effectives

| Zone | Caractéristique |
|------|----------------|
| Bretagne/Nord | Plus de pluie, moins de gel, pâturage long |
| Beauce/IDF | Continental doux, sols limoneux, fenêtres larges |
| Sud-Ouest | Chaud, irrigation nécessaire, maïs roi |
| Montagne | Gel tardif, saison courte, herbe/élevage |
| Méditerranée | Sec été, peu de pluie, irrigation obligatoire |

---

## 8. Serveurs

### 2 serveurs au lancement

| Serveur | Public | Spécificité |
|---------|--------|-------------|
| 🇫🇷 **France Normal** | Tous les joueurs, casual-friendly | Assistanat, suggestions, tooltips |
| 🇫🇷 **France Expert** | Joueurs expérimentés | Pas d'aide, plus réaliste, plus punitif |

- Même carte de France, mêmes mécaniques de base
- Un joueur choisit son serveur à l'inscription (pas de changement après)
- Possibilité d'ouvrir d'autres serveurs plus tard (Belgique, Suisse, Canada, USA — cf. Roadmap Phase 10)

---

## Résumé des décisions

| # | Sujet | Décision |
|---|-------|----------|
| Q1 | Puits d'argent | Charges + entretien + investissements endgame (pas de taxes) |
| Q2 | Coop | Prix fixe (filet de sécurité) |
| Q3 | Late joiner | Pas de rattrapage artificiel + 10 parcelles/mois réservées 5j |
| Q4 | HT | Coût variable (action × surface × matériel) |
| Q5 | Automatisation | Gameplay (employés, robots) — coûte de l'argent, pas un paywall |
| Q6 | Normal/Expert | 2 serveurs séparés, même jeu mais niveau d'assistanat différent |
| Q7 | Monétisation | Gratuit (sans pub) + Premium 3,99€/mois (confort/cosmétique) |
| Q8 | Lignes rouges | Aucun boost de production/temps/HT dans le premium |
| Q9 | Météo | Simulation statistique réaliste par zone (pas temps réel) |
| Q10 | Serveurs | 2 serveurs : France Normal + France Expert |


---

## 9. Foncier (précisions)

### Parcelles disponibles

| Paramètre | Valeur |
|-----------|--------|
| Nombre | 10 parcelles/joueur/mois IG |
| Taille | **Aléatoire** (variée : 3-5-8-10-15-20 ha…) |
| Prix | **Fixe par taille**, identique partout (pas de variation zone) |
| Réservation | 5 premiers jours IG = exclusif au joueur |
| Après 5j | Achetable par n'importe qui |
| Hors zone | Possible avec frais de distance |

Le joueur ne choisit pas la taille — il voit ses 10 parcelles disponibles et décide lesquelles acheter. L'aléa crée de la variété (parfois on a de grosses parcelles, parfois des petites).

---

## 10. Employés

### Un employé = des heures supplémentaires

| Paramètre | Valeur |
|-----------|--------|
| Unité | **Heures (HT)** — même unité que le joueur |
| Polyvalence | **Tout faire** (pas de spécialisation tractoriste/vacher) |
| Coût | Salaire mensuel IG (charge fixe) |
| Heures fournies | À calibrer (probablement 20-40h/jour par employé) |

→ Un employé est un "deuxième joueur" sans cerveau : il exécute les ordres mais ne décide rien. Le joueur doit quand même planifier et affecter les tâches.

---

## 11. Marché joueurs

### Type : carnet d'ordres (order book)

| Aspect | Détail |
|--------|--------|
| Modèle | **Carnet d'ordres** (offre/demande avec matching automatique) |
| Vente | Le joueur pose un ordre de vente : quantité + prix minimum |
| Achat | Le joueur pose un ordre d'achat : quantité + prix maximum |
| Matching | Si prix achat ≥ prix vente → transaction automatique |
| Historique | Courbes de prix visibles (dernier prix, moyenne, volume) |
| Alternative | Toujours possible de vendre à la coop (prix fixe, immédiat) |

→ Plus sophistiqué que les "petites annonces" de SimAgri. Permet la spéculation, la stratégie de timing, les contrats implicites.

---

## 12. Événements aléatoires

| Paramètre | Valeur |
|-----------|--------|
| Serveur Expert | **Oui** — grippe aviaire, sécheresse, tempête, gel tardif, etc. |
| Serveur Normal | **À voir** — possiblement en saisons/événements spéciaux plutôt qu'en permanent |
| Fréquence | Réaliste (pas tous les mois — basé sur probabilités réelles) |
| Impact | Dégâts proportionnels à l'exposition (pas de perte totale d'un coup) |

---

## 13. Mort des animaux

### Système de dégradation progressive

| Phase | Timing | Effet |
|-------|--------|-------|
| Bien nourri | Normal | Production normale, prise de poids |
| Sous-alimenté | Jour 1-3 sans nourriture | Production baisse, perte de poids commence |
| Affamé | Jour 4-10 | Perte de poids accélérée, production arrêtée, santé décline |
| Critique | Jour 10-14 | Animal très maigre, risque de mort élevé |
| **Mort** | **~14 jours IG (2 semaines)** sans nourriture | L'animal meurt |

- La mort n'est pas instantanée — le joueur a le temps de réagir
- Un animal affaibli met du temps à récupérer (pas de retour immédiat à la normale)
- Mortalité naturelle aussi : vieillesse (durée de vie par espèce), maladies non soignées
- **Alerte** : notification au joueur dès le premier jour de sous-alimentation

---

## 14. Coopération & Compétition

### Les deux coexistent

| Mécanique | Type | Détail |
|-----------|------|--------|
| **Classements** | Compétition | Rendement, génétique, patrimoine, efficience |
| **ETA** | Coopération | Prestation de services entre joueurs (moisson, épandage) |
| **Marché** | Les deux | Échange libre, mais aussi concurrence sur les prix |
| **Coopératives (CAR)** | Coopération | Structure multi-joueurs, transformation collective |
| **CFSA** | Coopération | Mentorat parrain/filleul |
| **Achat en commun** | Coopération | Matériel partagé (moissonneuse entre 3-5 joueurs) |

→ Le jeu est coopétitif : on s'entraide ET on se compare.

---

## 15. Tick & Temporalité

### 1 tick par jour réel

| Paramètre | Valeur |
|-----------|--------|
| Fréquence tick | **1 par jour réel** |
| Équivalent IG | ~4 jours IG par tick (1 semaine réelle = 1 mois IG ≈ 7 ticks) |
| Ce qui se passe au tick | Croissance cultures, production (lait/œufs), consommation aliment, usure matériel, météo du jour |

### Détail du tick quotidien

```
Chaque jour réel (1 tick) :
├── Météo du jour IG calculée
├── Cultures : croissance avance (basée sur météo + sol + intrants)
├── Animaux :
│   ├── Consommation aliment (si stock disponible)
│   ├── Production (lait, œufs)
│   ├── Prise/perte de poids
│   ├── Gestation avance
│   └── Santé évolue (si non nourri → dégradation)
├── Matériel : usure +0.1%/jour (×1.5 si pas sous hangar)
├── Pannes : tirage aléatoire si usure > 50%
├── Bâtiments : entretien périodique
└── Économie : charges fixes au tick mensuel
```

### Actions joueur = hors tick

Les actions du joueur (semer, récolter, acheter, vendre) sont **instantanées** et exécutées quand il se connecte. Le tick est le "moteur du monde" qui fait avancer le temps.

---

## Résumé complémentaire

| # | Sujet | Décision |
|---|-------|----------|
| Q11 | Parcelles | Taille aléatoire, prix fixe par taille, identique partout |
| Q12 | Employés | Fournit des heures, polyvalent, salaire mensuel |
| Q13 | Marché | Carnet d'ordres (order book) avec matching auto |
| Q14 | Session type | À déterminer par le calibrage |
| Q15 | Événements | Expert = oui, Normal = à voir (peut-être saisonnier) |
| Q16 | Mort animaux | Dégradation 2 semaines IG puis mort |
| Q17 | PvP/Coop | Coopétitif : ETA + marchés + classements |
| Q18 | Tick | 1/jour réel, croissance + production + consommation |


---

## 16. Tick — Heure d'exécution

| Paramètre | Valeur |
|-----------|--------|
| Heure du tick | **Minuit** (00:00 heure serveur, heure française) |
| Identique pour tous | Oui — tick global serveur |

→ Tous les joueurs "avancent" en même temps. Pas de personnalisation par joueur.

---

## 17. Vente d'animaux entre joueurs

### Modèle SimAgri conservé

| Aspect | Détail |
|--------|--------|
| Vente directe | **Oui** — un joueur peut vendre à un autre |
| Mécanisme | Annonce (type petites annonces) — pas le carnet d'ordres |
| Transport | Le **vendeur** OU **l'acheteur** doit avoir une bétaillère (à négocier/convenir) |
| Prix libre | Oui — mais au-dessus du prix minimum (anti-multicompte) |
| Abattoir | Vente possible aussi à l'abattoir (prix coop fixe par kg carcasse) |

→ Le marché d'animaux est plus "petites annonces" que carnet d'ordres (chaque animal est unique : âge, génétique, état).

---

## 18. Matériel d'occasion

### Passage obligatoire par un concessionnaire-joueur

| Aspect | Détail |
|--------|--------|
| Vente directe joueur→joueur | **Non** |
| Vente via concessionnaire | **Oui** — un joueur concessionnaire gère la revente |
| Dépôt-vente | Le vendeur dépose son matériel chez le concessionnaire, qui prend une commission |
| Achat neuf | Via le concessionnaire (qui a des licences de marques) |
| Argus | Valeur estimée basée sur âge + usure (transparent) |

→ Le concessionnaire est un **métier de joueur** (Phase 8). Ça crée de l'économie et du gameplay social. Avant Phase 8 : achat/vente via la coop uniquement.

---

## 19. Bâtiments

### Construction — modèle SimAgri

| Aspect | Détail |
|--------|--------|
| Construction | Le joueur commande un bâtiment → il est construit après un **délai** |
| Délai | Variable selon la taille (quelques jours IG à 1-2 mois IG) |
| Coût | Prix fixe selon type + taille |
| **Mode Premium** | **Supprime le temps de construction** (construction instantanée) |
| Destruction | Possible (le terrain redevient libre) |
| Revente | Non (on détruit, on ne revend pas un bâtiment) |
| Agrandissement | Possible pour certains bâtiments (ajouter des places) |

> ⚠️ C'est le **seul avantage temporel** du mode premium. Ce n'est pas un boost de production — c'est du confort (skip d'attente sur une action ponctuelle). Acceptable car :
> - Pas de compétition directe sur la construction
> - Le joueur gratuit a le même bâtiment au final, juste quelques jours plus tard
> - C'est une "QoL" classique des jeux de gestion F2P

---

## 20. Progression visible

### Systèmes de progression

| Système | Description |
|---------|-------------|
| **Niveaux** | Niveau global du joueur (XP gagnée via les actions) |
| **Objectifs in-game** | Quêtes/missions (ex: "Récoltez votre premier blé", "Atteignez 50 vaches") |
| **Badges** | Accomplissements débloqués (affichables sur le profil) |
| **Classements** | Rendement, génétique, patrimoine, ancienneté |
| **Déblocage fonctionnel** | Certaines features débloquées par le niveau ? (à calibrer) |

### Exemples de badges

| Badge | Condition |
|-------|-----------|
| 🌱 Premier semis | Semer sa première parcelle |
| 🥛 Premiers litres | Produire 1000L de lait |
| 🐣 Éleveur en herbe | Faire naître 100 animaux |
| 💰 Millionnaire | Atteindre 1 000 000 € de patrimoine |
| 🏆 Champion de rendement | Être #1 sur un classement rendement |
| 🤝 Coopérateur | Rejoindre une coopérative |
| 🧬 Généticien | Produire un animal avec index > seuil |
| 📅 Vétéran | Jouer depuis 1 an |

---

## 21. Anti-multicompte

### Levier principal : prix minimum

| Mesure | Détail |
|--------|--------|
| **Prix minimum** | Aucune transaction joueur→joueur en dessous d'un prix plancher (par produit/animal) |
| **Effet** | Empêche le transfert de richesse déguisé (vendre 100 vaches à 1€ entre ses comptes) |
| **Calibrage** | Prix minimum = ~70-80% du prix coop (le joueur n'a aucun intérêt à sous-vendre) |
| **Détection complémentaire** | Fingerprint navigateur, patterns IP, alertes sur transferts répétés entre mêmes comptes |

→ Simple et efficace. Si tu ne peux pas vendre en dessous du prix coop -20%, le multi-compte perd 90% de son intérêt.

---

## 22. Triche & Bots

### Position : tolérance zéro

| Aspect | Détail |
|--------|--------|
| **CGU** | Interdit explicitement : scripts, bots, automation externe, multi-compte |
| **Détection** | Rate limiting API, patterns d'actions anormaux (actions à intervalles réguliers = bot) |
| **Sanction** | Ban permanent (pas de warning) |
| **Signalement** | Les joueurs peuvent signaler un suspect |
| **Appel** | Possible via support, mais charge de la preuve au joueur |

→ Le jeu fournit déjà l'automatisation in-game (employés, robots). Pas de raison de scripter.

---

## Résumé Q19-Q25

| # | Sujet | Décision |
|---|-------|----------|
| Q19 | Heure tick | Minuit |
| Q20 | Vente animaux | Oui, entre joueurs, annonce, prix minimum obligatoire |
| Q21 | Matériel occasion | Via concessionnaire-joueur uniquement |
| Q22 | Bâtiments | Construction avec délai, Premium = skip du délai |
| Q23 | Progression | Niveaux + objectifs + badges + classements |
| Q24 | Multi-compte | Prix minimum empêche le transfert de richesse |
| Q25 | Bots | Bannis (CGU), détection technique, tolérance zéro |


---

## 23. Confirmation — Premium & construction

> **Seule accélération autorisée en Premium : skip du temps de construction bâtiment.**
> 
> Interdit en Premium :
> - ❌ Skip gestation
> - ❌ Skip croissance culture
> - ❌ Skip engraissement
> - ❌ Toute accélération biologique ou productive

---

## 24. Saisons

### Oui — saisons visuelles ET mécaniques

| Saison | Mois IG | Impact mécanique | Impact visuel |
|--------|:---:|---|---|
| 🌸 Printemps | Mars-Mai | Semis printemps, mise à l'herbe, floraison, 1er apport N | Vert clair, fleurs |
| ☀️ Été | Juin-Août | Récoltes céréales, irrigation, fenaison, pâturage plein | Jaune/doré, soleil |
| 🍂 Automne | Sept-Nov | Semis d'hiver, vente broutards, rentrée bâtiment, vendanges | Orange/brun, feuilles |
| ❄️ Hiver | Déc-Fév | Repos végétatif, travaux bâtiment, planning, vêlages | Gris/blanc, givre |

- L'interface change visuellement selon la saison (palette, illustrations)
- Les mécaniques suivent le calendrier agricole réel
- La météo (section 7) est cohérente avec la saison

---

## 25. Communication

### 3 canaux intégrés + modération

| Canal | Description | Modération |
|-------|-------------|------------|
| **Chat global** | Canal serveur, tous les joueurs | Auto (filtres) + signalement |
| **Chat privé** | Messages directs entre joueurs | Signalement |
| **Forum intégré** | Catégories, topics, posts (coopératives, aide, marché) | Auto + modérateurs joueurs |

- **Modération automatique** : filtres mots interdits, spam, liens suspects
- **Signalement** : bouton sur chaque message
- Pas de dépendance à un service externe (Discord = complémentaire, pas obligatoire)

---

## 26. Notifications hors-jeu

### Distinction Gratuit vs Premium

| Situation | Gratuit | Premium |
|-----------|---------|---------|
| Récolte prête | Notification **à la connexion** (page principale) | Push/email en temps réel |
| Animal malade | Notification **à la connexion** | Push |
| Vente réussie (marché) | Notification **à la connexion** | Push |
| Panne matériel | Notification **à la connexion** | Push |
| Message reçu | Notification **à la connexion** | Push |

→ Le joueur gratuit voit tout quand il se connecte (fil de notifications sur la page d'accueil). Le Premium reçoit les alertes en temps réel même hors-jeu.

---

## 27. Tutoriel

### Non skippable

| Aspect | Détail |
|--------|--------|
| Obligatoire | **Oui** — tout le monde passe par le tutoriel |
| Raison | Même un vétéran SimAgri doit découvrir les différences d'Agriva |
| Durée | Court (4-5 étapes, ~2 minutes) |
| Style | Overlay pointant les éléments, pas un "mur de texte" |

→ C'est rapide. On ne punit pas le vétéran avec 30 min de tutoriel, mais on s'assure que tout le monde comprend l'interface.

---

## 28. Ouverture au public

### Quand le gameplay de base est jouable

| Critère | Requis pour ouvrir |
|---------|-------------------|
| Cultures | Cycle complet : semer → récolter → vendre ✅ |
| Élevage | Au moins bovins + volaille jouables ✅ |
| Marché | Coop + marché joueurs fonctionnels ✅ |
| Économie | Balance testée et viable ✅ |
| Social de base | Chat + profils ✅ |
| **Pas de** | Early access payant, founder packs P2W, ou accès réservé |

→ **Ouverture gratuite pour tous** dès que les bases fonctionnent (probablement Phase 4-5 de la roadmap). Pas d'exclusivité payante, pas de beta fermée payante.

---

## Résumé Q26-Q30

| # | Sujet | Décision |
|---|-------|----------|
| — | Premium & construction | Seul skip autorisé = temps construction bâtiment |
| Q26 | Saisons | Oui, visuelles ET mécaniques (4 saisons) |
| Q27 | Communication | Chat global + privé + forum intégré, modération auto |
| Q28 | Notifications | Gratuit = à la connexion / Premium = push temps réel |
| Q29 | Tutoriel | Non skippable (mais court : ~2 min) |
| Q30 | Ouverture | Quand gameplay de base jouable, gratuit pour tous, pas d'early payant |
