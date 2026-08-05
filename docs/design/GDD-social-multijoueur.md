> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


# GDD — Social et Multijoueur

> Date : 2026-08-04
> Statut : Draft
> Auteur : agent:game-designer
> Références : `docs/research/reality-vs-simagri-economie.md`, `docs/design/GDD-marche.md`, `docs/design/GDD-materiel.md`, ADR-001, ADR-002, ADR-003

---

## 1. Vision et gameplay loop social

### 1.1 Intention de design

Le social EST le cœur d'Agriva. Les autres joueurs sont une **ressource**, pas des adversaires. La coopération est toujours plus rentable que la compétition. Il n'y a pas de PvP destructif : on ne peut pas nuire à un autre joueur.

**Trois piliers sociaux :**
1. **Interdépendance économique** — personne ne produit tout, donc on échange.
2. **Entraide quotidienne** — un coup de main donné aujourd'hui sera rendu demain.
3. **Appartenance** — les joueurs restent des années grâce aux liens humains, pas au gameplay seul.

### 1.2 Ce que SimAgri fait bien (à garder)

- Coopératives entre joueurs = liens forts multi-années
- Concessionnaires joueurs = rôle social unique
- Marché entre joueurs actif (annonces, négociation)
- Forum intégré très vivant (discussions hors-jeu incluses)
- Pas de grief possible (on ne peut pas voler/détruire)

### 1.3 Ce que SimAgri fait mal (à corriger)

- Pas de système de réputation visible → impossible d'évaluer la fiabilité
- Messagerie archaïque (pas de conversations groupées)
- Pas de notion d'amis/relations formalisée
- Profil joueur pauvre (pas de stats publiques)
- Forum monolithique sans modération outillée
- Aucun événement communautaire organisé par le jeu
- Multi-comptes endémiques sans détection

### 1.4 Gameplay loop social

```
┌─────────────────────────────────────────────────────────────────┐
│                    LOOP QUOTIDIENNE                              │
│  Lire messages → Répondre → Consulter marché joueurs → Échanger │
├─────────────────────────────────────────────────────────────────┤
│                    LOOP HEBDOMADAIRE                             │
│  Aider un voisin → Participer au forum → Vérifier classements  │
├─────────────────────────────────────────────────────────────────┤
│                    LOOP MENSUELLE                                │
│  Événement communautaire → Bilan entraide → Badges/réputation   │
└─────────────────────────────────────────────────────────────────┘
```

### 1.5 Les décisions sociales du joueur

| Décision | Fréquence | Impact |
|----------|:---------:|--------|
| Ajouter un joueur en ami privilégié ? | Ponctuel | Accès à des prix préférentiels (-5%) |
| Répondre à une demande d'entraide ? | Quotidien | +réputation, +lien social |
| Rejoindre un groupement ? | Ponctuel | Accès matériel partagé, achats groupés |
| Participer à un événement ? | Mensuel | Récompenses exclusives, visibilité |
| Signaler un abus ? | Rare | Santé de la communauté |
| Vendre à un ami ou au marché libre ? | Quotidien | Prix vs relation |

### 1.6 Différences entre serveur Normal et serveur Expert (social)

| Aspect | Serveur Normal | Serveur Expert |
|--------|--------|--------|
| Profil joueur | Stats de base (surface, cheptel, ancienneté) | Stats détaillées (rendements moyens, ratios financiers) |
| Réputation | Score unique 0-100 | Score décomposé (fiabilité, réactivité, qualité) |
| Messagerie | Identique | Identique |
| Entraide | Bonus fixe (+10% réputation) | Bonus variable selon impact réel |
| Classements | Par ligue (taille), propres au serveur | Classement absolu + par ligue, propres au serveur |
| Événements | Accessibles à tous | Défis Expert avec contraintes supplémentaires |

> **Important** : ces différences décrivent la configuration de chaque serveur. Les joueurs de chaque serveur ne sont jamais en interaction économique ou compétitive entre eux (cf. §1bis).

---

## 1bis. Portée inter-serveurs

> Réf. : `ADR-005-deux-serveurs-separes.md` §3

Agriva propose **deux serveurs séparés** (Normal et Expert). Un même compte peut avoir une exploitation sur chaque serveur, mais les deux univers sont économiquement et compétitivement cloisonnés. Cette section définit ce qui traverse la frontière des serveurs et ce qui ne la traverse pas.

### 1bis.1 Tableau de partage

| Élément | Partagé entre serveurs ? | Justification |
|---------|:------------------------:|---------------|
| Identité de compte (login) | ✅ Oui | Un seul compte, deux exploitations optionnelles |
| Liste d'amis | ✅ Oui | La relation sociale précède le serveur |
| Messagerie privée | ✅ Oui | On discute avec un joueur, pas avec une ferme |
| Forum | ✅ Oui | Communauté commune (catégories par serveur possibles) |
| Encyclopédie / aide | ✅ Oui | Contenu de référence identique |
| Abonnement premium | ✅ Oui | Souscrit une fois, actif sur les deux serveurs |
| **Économie, marché, prix** | ❌ Non | Cloisonnement strict — pas de transfert possible |
| **Classements** | ❌ Non | Comparer un Normal et un Expert n'a aucun sens |
| **Coopératives, CUMA, ETA** | ❌ Non | Structures locales à un serveur |
| **Génétique, cheptel, terres** | ❌ Non | Aucun transfert inter-serveurs |

### 1bis.2 Conséquences de gameplay

| Situation | Possible ? | Explication |
|-----------|:----------:|-------------|
| Ajouter en ami un joueur qui ne joue que sur l'autre serveur | ✅ | L'amitié est liée au compte, pas au serveur |
| Envoyer un MP à un joueur de l'autre serveur | ✅ | La messagerie est inter-serveurs |
| Vendre du blé à un ami qui joue sur l'autre serveur | ❌ | Le marché est interne au serveur |
| Prêter du matériel à un ami privilégié de l'autre serveur | ❌ | Le matériel appartient à un serveur |
| Rejoindre une CUMA / ETA de l'autre serveur | ❌ | Les structures économiques sont locales |
| Faire de l'entraide pour un joueur de l'autre serveur | ❌ | L'entraide implique des actions in-game, donc un serveur |
| Participer au même événement collectif | ❌ | Les événements sont par serveur |
| Poster sur le forum et être lu par les deux serveurs | ✅ | Le forum est commun |

**Résumé pour le joueur** : tu peux *parler* avec n'importe qui, mais tu ne peux *échanger* (biens, services, argent) qu'avec les joueurs de ton propre serveur.

### 1bis.3 Impact sur les amis privilégiés

Les 10 slots d'amis privilégiés fonctionnent **par serveur** pour les avantages économiques :
- Les bonus (−5% commission, prêt gratuit de matériel, priorité annonces) ne s'appliquent que si les deux joueurs sont sur le même serveur.
- Un ami privilégié qui n'a pas d'exploitation sur votre serveur reste votre ami privilégié (lien social), mais les avantages économiques ne sont pas activables.

---

## 2. Le profil joueur

### 2.1 Fiche publique

Chaque joueur dispose d'une fiche publique visible par tous. Elle affiche l'identité agricole du joueur et ses réalisations.

**Informations affichées :**

| Donnée | Source | Visibilité |
|--------|--------|:----------:|
| Pseudo + avatar | Choix joueur | Publique |
| Département / région | Choix à l'inscription | Publique |
| Date d'inscription | Automatique | Publique |
| Surface totale (ha) | Calcul auto | Publique |
| Cheptel (têtes) | Calcul auto | Publique |
| Spécialités (icônes) | Auto si >30% du CA | Publique |
| Score réputation | Calcul (§2.3) | Publique |
| Badges obtenus | Attribution auto | Publique |
| Statut en ligne | Temps réel | Amis uniquement |
| Dernière connexion | Auto | Publique |

### 2.2 Mockup — Profil joueur

```
┌────────────────────────────────────────────────────────────────┐
│  👤 PROFIL DE « FermeDesBois »                          [✉️ MP] │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  📍 Bretagne (35)          📅 Inscrit depuis : 14 mois         │
│  🌾 182 ha                 🐄 95 vaches laitières              │
│  ⭐ Réputation : 87/100    🟢 En ligne                         │
│                                                                │
│  ┌─ Spécialités ──────────────────────────────────────────┐   │
│  │  🥛 Lait    🌾 Grandes cultures    🚜 ETA (prestataire) │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│  ┌─ Badges ───────────────────────────────────────────────┐   │
│  │  🏆 Top 10 lait régional   🤝 100 entraides données     │   │
│  │  📦 500 transactions       🌱 1 an d'ancienneté         │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│  ┌─ Statistiques ─────────────────────────────────────────┐   │
│  │  Transactions réussies : 487/492 (98.9%)                │   │
│  │  Délai moyen de livraison : 1.2 jours                   │   │
│  │  Entraides données : 104    Entraides reçues : 67       │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
│  [➕ Ajouter en ami]  [⭐ Ami privilégié]  [⚠️ Signaler]       │
└────────────────────────────────────────────────────────────────┘
```

### 2.3 Système de réputation

La réputation est un score de 0 à 100, calculé automatiquement.

```
reputation = (fiabilite * 0.5) + (entraide * 0.3) + (anciennete * 0.2)

fiabilite   = transactions_ok / transactions_total * 100   (cap 100)
entraide    = min(entraides_donnees / 10, 100)             (10 entraides = 100%)
anciennete  = min(mois_inscrits / 24, 100)                 (2 ans = max)
```

| Palier | Label affiché | Effet |
|:------:|:-------------:|-------|
| 0-30 | Nouveau | Pas d'effet |
| 31-60 | Fiable | Peut poster des annonces premium |
| 61-80 | Reconnu | Commission marché réduite (-1%) |
| 81-95 | Excellent | Priorité dans les réponses aux annonces |
| 96-100 | Pilier | Badge doré, visibilité dans classements |

### 2.4 Badges

Badges attribués automatiquement. Non échangeables, purement cosmétiques + prestige.

| Badge | Condition | Icône |
|-------|-----------|:-----:|
| Première récolte | Vendre sa 1ère récolte | 🌱 |
| Centenaire | 100 transactions réussies | 📦 |
| Bon voisin | 50 entraides données | 🤝 |
| Grand domaine | Atteindre 200 ha | 🏡 |
| Éleveur confirmé | 100 têtes de bétail | 🐄 |
| Vétéran | 2 ans d'ancienneté | ⏳ |
| Top régional | Top 10 d'un classement régional | 🏆 |
| Pilier communautaire | Réputation 96+ | 💎 |

---

## 3. Amis et relations

### 3.1 Liste d'amis

Un joueur peut ajouter jusqu'à **150 amis**. L'ajout nécessite une demande acceptée par l'autre joueur.

**Fonctionnalités amis :**
- Voir le statut en ligne
- Notifications quand un ami poste une annonce
- Chat rapide (raccourci messagerie)
- Voir la ferme de l'ami (visite virtuelle)

### 3.2 Amis privilégiés

Sous-catégorie : jusqu'à **10 amis privilégiés** (relation réciproque obligatoire).

| Avantage | Détail |
|----------|--------|
| Prix préférentiel | -5% sur les ventes directes entre privilégiés |
| Prêt de matériel | Gratuit (au lieu de la location standard) |
| Priorité annonces | Voit les annonces 2h avant le marché public |
| Entraide bonus | +50% de points d'entraide quand on aide un privilégié |

**Limite anti-abus** : on ne peut changer ses privilégiés qu'une fois par semaine (cooldown 7 jours par slot modifié).

### 3.3 Voisinage géographique

Les joueurs du même département sont « voisins ». Avantages :

- Coût de transport réduit (-50%) pour les échanges entre voisins
- Accès au tableau d'entraide régional
- Visibilité dans le classement départemental
- Événements régionaux accessibles

---

## 4. Messagerie

### 4.1 Messages privés (MP)

Messagerie asynchrone, style boîte de réception.

| Paramètre | Valeur |
|-----------|--------|
| Longueur max message | 2 000 caractères |
| Pièces jointes | Non (liens vers annonces/profils uniquement) |
| Historique conservé | 6 mois |
| Notifications | In-game + email (configurable) |
| Blocage joueur | Instantané, réciproque |

### 4.2 Discussions de groupe

Un joueur peut créer une discussion de groupe (max **20 participants**).

Usages : coordination d'un groupement, discussion entre voisins, organisation d'un événement.

| Paramètre | Valeur |
|-----------|--------|
| Groupes max par joueur | 10 |
| Participants max par groupe | 20 |
| Admin | Créateur + délégation possible |
| Modération | Admin peut exclure un membre |

### 4.3 Notifications

| Événement | Canal | Défaut |
|-----------|-------|:------:|
| Nouveau MP | In-game + email | ✅ |
| Réponse à un sujet forum suivi | In-game | ✅ |
| Annonce d'un ami | In-game | ✅ |
| Demande d'entraide reçue | In-game + email | ✅ |
| Événement communautaire lancé | In-game | ✅ |
| Classement mis à jour | In-game | ❌ |

### 4.4 Modération et signalement

- Bouton **⚠️ Signaler** sur chaque message et profil
- Signalement traité sous 48h par modérateurs humains
- Sanctions graduelles : avertissement → mute 24h → mute 7j → ban
- Mots interdits : filtre automatique (contournable = aggravation)
- Un joueur bloqué ne peut plus envoyer de MP ni voir le profil



---

## 5. Dimension sociale du marché

> Les mécaniques de prix, canaux et contrats sont dans `GDD-marche.md`. Ici : le volet humain.

### 5.1 Négociation

Le marché entre joueurs permet la **contre-offre**. Flux :

```
Vendeur poste annonce (prix affiché)
  → Acheteur fait une offre (prix proposé)
    → Vendeur accepte / refuse / contre-offre
      → Max 3 allers-retours, puis expiration 48h
```

| Paramètre | Valeur |
|-----------|--------|
| Nombre d'allers-retours max | 3 |
| Délai d'expiration d'une offre | 48h |
| Commission marché public | 5% (vendeur) |
| Commission entre amis privilégiés | 0% |
| Commission entre amis | 3% |

### 5.2 Confiance et historique

Chaque joueur dispose d'un **historique de transactions** visible sur son profil :
- Nombre total de transactions
- Taux de transactions abouties (vs annulées par le vendeur)
- Délai moyen de livraison
- Note moyenne reçue (1-5 étoiles, optionnelle après transaction)

```
score_marche = (tx_abouties / tx_total) * 80 + (note_moyenne / 5) * 20
```

Un score marché < 50 déclenche un avertissement visible : `⚠️ Fiabilité faible`.

### 5.3 Réputation marchande et avantages

| Score marché | Effet |
|:------------:|-------|
| < 50 | Avertissement visible, annonces limitées à 3 simultanées |
| 50-75 | Normal (10 annonces simultanées) |
| 76-90 | 15 annonces, badge « Commerçant fiable » |
| 91-100 | 20 annonces, mise en avant dans la recherche |

---

## 6. Entraide

### 6.1 Principe

L'entraide permet à un joueur d'aider un autre joueur pour des tâches ponctuelles. C'est un système **gagnant-gagnant** : l'aidant gagne de la réputation et des points d'entraide, l'aidé résout un problème.

### 6.2 Types d'entraide

| Type | Exemple | Coût pour l'aidant | Gain aidant |
|------|---------|:------------------:|:-----------:|
| Prêt de matériel | Prêter sa moissonneuse 2 jours | 30 min + usure machine | +5 réputation, +1 point entraide |
| Coup de main | Aider à la moisson (bonus débit) | 45 min | +3 réputation, +1 point entraide |
| Dépannage | Fournir du carburant/pièce | Coût matière | +2 réputation, +1 point entraide |
| Transport | Livrer un produit chez un voisin | 15 min + carburant | +2 réputation, +1 point entraide |

### 6.3 Tableau d'entraide régional

Chaque département dispose d'un tableau d'entraide :

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 TABLEAU D'ENTRAIDE — Ille-et-Vilaine (35)                   │
├─────────────────────────────────────────────────────────────────┤
│  🆘 FermeDesBois cherche : moissonneuse-batteuse (2 jours)     │
│     Période : 15-17 juillet    ⭐ Réputation : 87              │
│     [Proposer mon matériel]                                     │
│  ─────────────────────────────────────────────────────────────  │
│  🆘 LaFermeDuPont cherche : coup de main moisson (1 jour)      │
│     Période : 18 juillet       ⭐ Réputation : 72              │
│     [Proposer mon aide]                                         │
│  ─────────────────────────────────────────────────────────────  │
│  🆘 ChampsCléments cherche : 500L de carburant (dépannage)     │
│     Urgent ⚡                  ⭐ Réputation : 91              │
│     [Proposer]                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 6.4 Incitations à l'entraide

Le jeu encourage activement l'entraide via :

| Mécanisme | Détail |
|-----------|--------|
| Points d'entraide | Cumulés → débloquent des badges |
| Bonus réputation | +2 à +5 par action d'entraide |
| Réciprocité automatique | Si A aide B, B voit une notification « rendre la pareille ? » |
| Événements d'entraide | Défis mensuels : « 50 entraides dans le département = récompense collective » |
| Réduction amis privilégiés | Entraide entre privilégiés = +50% points |

### 6.5 Limites anti-abus

- Max **5 entraides données par jour** (évite le farming de réputation)
- Entraide entre le même duo : max **3 par semaine** (évite la collusion)
- Un joueur avec réputation < 20 ne peut pas poster de demande d'entraide

---

## 7. Classements

### 7.1 Philosophie

Les classements motivent sans décourager. Un joueur de 50 ha ne doit pas se sentir écrasé par un joueur de 500 ha. Solution : **ligues par taille**, à l'intérieur de chaque serveur.

> **Règle structurante (ADR-005)** : les classements sont **PAR SERVEUR**. Chaque serveur possède ses propres ligues et ses propres classements. Un joueur du serveur Normal et un joueur du serveur Expert ne sont jamais comparés, dans aucune catégorie.

### 7.2 Pourquoi des classements séparés ?

Comparer un joueur Normal et un joueur Expert n'aurait pas de sens :

| Facteur | Serveur Normal | Serveur Expert |
|---------|:--------------:|:--------------:|
| Charges sociales | 12% | 28% |
| Plafond surface | 800 ha | 500 ha |
| Rendements décroissants | −5%/tranche | −12%/tranche |
| Faillite | Impossible | Possible |
| Contraintes météo | Légères | Bloquantes |

Un joueur Normal avec 500 ha a mécaniquement plus de production qu'un Expert au plafond (500 ha avec −12%/tranche). Les classer ensemble reviendrait à comparer deux jeux différents. Chaque serveur a son écosystème, ses records, ses champions.

### 7.3 Catégories de classement

| Classement | Métrique | Mise à jour | Scope |
|------------|----------|:-----------:|:-----:|
| Surface totale | Hectares possédés + loués | Quotidienne | Serveur |
| Cheptel | Nombre de têtes (toutes espèces) | Quotidienne | Serveur |
| Production laitière | Litres/an | Mensuelle | Serveur |
| Rendement céréalier | Quintaux/ha moyen | À la récolte | Serveur |
| Génétique bovine | Index moyen du troupeau | Mensuelle | Serveur |
| Richesse | Patrimoine net (actifs - dettes) | Hebdomadaire | Serveur |
| Réputation | Score 0-100 | Quotidienne | Serveur |
| Ancienneté | Jours depuis inscription | Quotidienne | Serveur |
| Entraide | Points d'entraide cumulés | Quotidienne | Serveur |

### 7.4 Ligues par taille (par serveur)

Chaque serveur possède ses propres ligues. Le système de ligues par taille reste pertinent au sein d'un serveur : il garantit que les joueurs se comparent à des pairs de dimension similaire.

| Ligue | Critère d'accès | Couleur |
|-------|:---------------:|:-------:|
| Starter | 0-50 ha | 🟢 Vert |
| Confirmé | 51-150 ha | 🔵 Bleu |
| Avancé | 151-400 ha | 🟣 Violet |
| Élite | 401+ ha | 🟡 Or |

Le joueur est classé dans sa ligue ET dans le classement général de son serveur. L'affichage par défaut est **la ligue** pour que chaque joueur se compare à des pairs.

> Note : la ligue « Avancé » remplace l'ancien nom « Expert » pour éviter la confusion avec le serveur Expert. Le mot « Expert » dans un classement désigne toujours le serveur, pas une ligue.

### 7.5 Scope géographique

Trois niveaux de classement, **tous internes au serveur** :
- **Départemental** (voisins directs, même serveur)
- **Régional** (13 régions, même serveur)
- **National** (serveur entier)

Il n'existe pas de classement inter-serveurs.

### 7.6 Mockup — Écran de classements

```
┌────────────────────────────────────────────────────────────────┐
│  🏆 CLASSEMENTS — Serveur Normal                               │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  [Surface] [Lait] [Richesse] [Réputation] [Entraide] [+]      │
│                                                                │
│  📊 Production laitière — Ligue Confirmé (51-150 ha)          │
│  📍 Bretagne                                                   │
│                                                                │
│  ┌─────┬────────────────────┬────────────┬──────────────┐     │
│  │ Pos │ Joueur             │ Litres/an  │ Évolution    │     │
│  ├─────┼────────────────────┼────────────┼──────────────┤     │
│  │  1  │ ⭐ FermeDesBois    │ 892 000 L  │ ↑ +2 places  │     │
│  │  2  │ LaVacheFolle       │ 845 000 L  │ → stable     │     │
│  │  3  │ PréVert            │ 801 000 L  │ ↓ -1 place   │     │
│  │  4  │ LaitDesMonts       │ 756 000 L  │ ↑ +5 places  │     │
│  │  5  │ 👤 Vous (CréaLait) │ 723 000 L  │ ↑ +1 place   │     │
│  │ ... │                    │            │              │     │
│  └─────┴────────────────────┴────────────┴──────────────┘     │
│                                                                │
│  Votre position : 5ème / 234 joueurs dans cette ligue          │
│                                                                │
│  [🟢 Starter] [🔵 Confirmé ✓] [🟣 Avancé] [🟡 Élite]          │
│  [Département] [Région ✓] [National]                           │
│                                                                │
│  📈 Historique : vous étiez 8ème il y a 30 jours              │
└────────────────────────────────────────────────────────────────┘
```

### 7.7 Récompenses de classement

| Position | Récompense |
|:--------:|-----------|
| Top 1 (ligue) | Badge « Champion [catégorie] » + titre affiché |
| Top 3 | Badge « Podium » |
| Top 10 | Badge « Top 10 » |
| Top 50% | Aucune (évite la frustration des derniers) |

Les récompenses sont des badges (cosmétiques). Pas de bonus économique pour éviter le « rich get richer ». Les badges portent l'indication du serveur (ex : « Champion Lait — Serveur Normal »).

---

## 8. Groupements de joueurs

> CUMA = voir `GDD-materiel.md`. CAR/ETA = GDD dédiés. Ici : structures sociales informelles.

### 8.1 Associations

Un joueur peut créer une **association** (groupement informel).

| Paramètre | Valeur |
|-----------|--------|
| Membres max | 30 |
| Création | Gratuite, 3 membres fondateurs minimum |
| Dissolution | Vote majoritaire ou inactivité 60 jours |
| Rôles | Président, vice-président, membres |
| Avantages | Chat de groupe dédié, tableau d'entraide interne, page publique |

### 8.2 Fonctionnalités d'une association

- **Page publique** : description, membres, spécialités, recrutement ouvert/fermé
- **Chat interne** : discussion de groupe permanente (max 30 membres)
- **Tableau d'entraide interne** : demandes visibles uniquement par les membres (priorité)
- **Événements internes** : le président peut lancer un défi interne
- **Statistiques collectives** : surface totale, production totale, classement collectif

### 8.3 Entraide régionale

Les joueurs d'un même département forment automatiquement une « communauté régionale » (sans adhésion).

Fonctionnalités :
- Tableau d'entraide départemental (§6.3)
- Classement départemental
- Chat régional (optionnel, le joueur peut s'y inscrire)
- Événements régionaux

### 8.4 Groupes de discussion

Indépendants des associations. Un joueur peut créer un groupe thématique (ex : « Éleveurs bio de Normandie », « Fans de John Deere »).

| Paramètre | Valeur |
|-----------|--------|
| Membres max | 50 |
| Visibilité | Publique (trouvable) ou privée (sur invitation) |
| Modération | Créateur + modérateurs nommés |
| Durée de vie | Illimitée tant qu'au moins 2 membres actifs |



---

## 9. Forum in-game

### 9.1 Structure

Le forum est intégré au jeu (pas de redirection externe). Il est le lieu de discussion libre.

| Catégorie | Description |
|-----------|-------------|
| 📢 Annonces officielles | Mises à jour, maintenance, événements (lecture seule) |
| 💬 Discussion générale | Tout sujet hors-jeu |
| 🌾 Stratégie & conseils | Astuces, guides, questions de gameplay |
| 🏪 Commerce | Annonces de vente/achat hors-marché, partenariats |
| 🐄 Élevage | Discussions spécifiques élevage |
| 🚜 Matériel | Avis, comparatifs, questions |
| 🏆 Événements | Discussion des événements en cours |
| 💡 Suggestions | Idées pour le jeu |
| 🐛 Bugs | Signalement de bugs |

### 9.2 Fonctionnalités

| Fonctionnalité | Détail |
|----------------|--------|
| Création de sujet | Tout joueur avec 7+ jours d'ancienneté |
| Réponses | Illimitées |
| Édition | Auteur peut éditer dans les 15 min |
| Épinglage | Modérateurs uniquement |
| Sondages | Intégrés (choix unique ou multiple) |
| Recherche | Texte complet |
| Suivi de sujet | Notification à chaque réponse |
| Quota anti-spam | Max 5 nouveaux sujets/jour, 50 réponses/jour |

### 9.3 Modération

- **Modérateurs bénévoles** : joueurs de confiance (réputation 90+, ancienneté 6+ mois), nommés par l'équipe
- **Actions modérateur** : éditer, supprimer, déplacer, verrouiller, avertir
- **Signalement communautaire** : bouton ⚠️ sur chaque post. 3 signalements = masquage automatique en attente de review
- **Sanctions** : mute forum 24h → 7j → 30j → ban forum permanent
- **Appel** : un joueur sanctionné peut contester via le support

---

## 10. Événements communautaires

### 10.1 Types d'événements

| Type | Fréquence | Durée | Exemple |
|------|:---------:|:-----:|---------|
| Défi individuel | Mensuel | 7 jours | « Produire 50 000 L de lait cette semaine » |
| Défi collectif | Trimestriel | 14 jours | « Le département produit 5M L de lait ensemble » |
| Concours | Mensuel | 3 jours | « Plus beau rendement blé » (classement ponctuel) |
| Saison thématique | Trimestriel | 30 jours | « Mois de l'élevage » (bonus entraide éleveurs) |
| Événement régional | Bimestriel | 7 jours | « Foire agricole Bretagne » (marché spécial) |

### 10.2 Récompenses événements

| Palier | Récompense |
|--------|-----------|
| Participation | Badge « Participant [événement] » |
| Objectif atteint (individuel) | Cosmétique exclusif (décoration ferme) |
| Top 10 | Badge spécial + titre temporaire (30 jours) |
| Objectif collectif atteint | Bonus pour tout le département (+5% prix vente pendant 7 jours) |

### 10.3 Défis collectifs — Mécanique

```
objectif_collectif = somme(contribution_chaque_joueur)

Paliers :
  - 50% atteint → récompense bronze (badge)
  - 100% atteint → récompense argent (badge + bonus économique 7j)
  - 150% atteint → récompense or (badge + bonus + cosmétique rare)
```

Un joueur qui contribue au moins 1% de l'objectif reçoit la récompense. Évite le free-riding total tout en restant accessible.

---

## 11. Anti-abus

### 11.1 Multi-comptes

| Mesure | Détail |
|--------|--------|
| Détection IP | Alerte si 2+ comptes depuis la même IP (tolérance foyer) |
| Fingerprint navigateur | Empreinte technique croisée avec IP |
| Pattern de jeu | Algorithme détectant les fermes « nourrices » (uniquement fournisseur d'un seul joueur) |
| Vérification email | Obligatoire, unique |
| Sanction | Avertissement → gel du 2ème compte → ban si récidive |

### 11.2 Collusion et exploitation du marché

| Abus | Détection | Sanction |
|------|-----------|----------|
| Ventes à prix dérisoire (transfert de richesse) | Alerte si prix < 50% du prix référence | Transaction bloquée + review manuelle |
| Achats circulaires (A→B→C→A) | Détection de boucles sur 7 jours | Avertissement + gel des transactions |
| Monopole artificiel | Alerte si un joueur détient >40% du stock serveur d'un produit | Plafond d'achat temporaire |
| Manipulation de classement | Détection d'entraide spam entre mêmes joueurs | Points annulés + avertissement |

### 11.3 Harcèlement

| Mesure | Détail |
|--------|--------|
| Blocage joueur | Instantané, empêche tout contact |
| Signalement MP | Review sous 48h |
| Mots interdits | Filtre automatique (insultes, discriminations) |
| Harcèlement répété | Détection si un joueur signale le même joueur 3+ fois | 
| Sanctions | Mute → ban temporaire → ban permanent |
| Protection nouveaux joueurs | Les comptes de < 7 jours ne peuvent pas être contactés par MP non sollicité |

### 11.4 Sanctions graduelles

| Niveau | Sanction | Déclencheur |
|:------:|----------|-------------|
| 1 | Avertissement (visible sur profil 30j) | 1er abus mineur |
| 2 | Mute 24h (MP + forum) | 2ème abus ou 1er abus modéré |
| 3 | Mute 7 jours + gel du marché | Récidive |
| 4 | Ban temporaire 30 jours | Abus grave ou 3ème récidive |
| 5 | Ban permanent | Harcèlement grave, multi-comptes confirmé x3 |

---

## 12. Équilibrage social

### 12.1 Principe fondamental

**Un joueur solo doit rester viable.** Le social apporte un avantage net de **15-30%**, pas une nécessité absolue.

| Aspect | Joueur solo | Joueur social | Avantage social |
|--------|:-----------:|:-------------:|:---------------:|
| Prix de vente | Prix marché standard | -5% commission (amis privilégiés) | +5% |
| Coût matériel | Achat individuel | Prêt gratuit entre privilégiés | ~15-25% économie |
| Temps (travail) | Tout seul | Entraide = heures économisées | +10-15% efficacité |
| Information | Marché public uniquement | Annonces amis en avance (2h) | +3-5% sur les bons deals |
| Événements | Participe seul | Bonus collectifs départementaux | +5% ponctuels |
| **Total estimé** | **Base 100** | **Base 115-130** | **+15-30%** |

### 12.2 Scénario chiffré — Joueur laitier, 100 ha, 60 VL

**Contexte** : Joueur confirmé, ligue Confirmé, 1 an d'ancienneté.
**Référence** : les charges détaillées sont celles du `GDD-bovin-laitier.md` §9.2.

**Joueur solo :**
```
Production lait : 60 VL × 8 500 L = 510 000 L/an
Prix moyen : 0,43 €/L (référence marché)
CA lait : 510 000 × 0,43                        = 219 300 €
+ Veaux, génisses, réformes                     =  36 260 €
+ Aides PAC                                     =  17 850 €
─────────────────────────────────────────────────────────
PRODUIT BRUT                                     273 410 €

- Charges opérationnelles (alimentation, véto,
  litière, cultures fourragères, carburant)     -113 200 €
- Charges de structure (amortissement, fermage,
  électricité, assurances, entretien)           -106 675 €
─────────────────────────────────────────────────────────
Bénéfice avant charges sociales                   53 535 €
- Charges sociales (12% Normal)                   -6 424 €
─────────────────────────────────────────────────────────
BÉNÉFICE NET                                      47 111 €
```

**Joueur social (5 amis privilégiés, association active) :**
```
Production identique : 510 000 L/an

Avantages sociaux quantifiés :
  1. Commission réduite sur le marché joueurs (-3% au lieu de -5%)
     → sur 40% des ventes passant par le marché :
       219 300 × 0,40 × 0,02                    = +1 754 €

  2. Achats groupés d'intrants (aliment, engrais) : -8%
     → sur 48 000 € d'aliment acheté             = +3 840 €

  3. Entraide reçue : 3 coups de main/mois
     → 2 h économisées/mois × 12 mois = 24 h
     → valorisées au coût d'un salarié (18 €/h)  = +432 €
     → surtout : 24 h réinvesties dans la production

  4. Prêt de matériel entre amis (évite la location
     d'une ensileuse en complément)              = +2 000 €

  5. Événement collectif régional (+5% prix pendant
     7 jours, 2 fois par an)
     → 510 000/52 × 2 × 0,43 × 0,05              = +422 €
  ─────────────────────────────────────────────────────
  Avantage social brut                            = +8 448 €
  - Charges sociales sur ce gain (12%)            =  -1 014 €
  ─────────────────────────────────────────────────────
  Avantage social net                             = +7 434 €

BÉNÉFICE NET SOCIAL : 47 111 + 7 434            =  54 545 €
```

**Comparaison :**

| | Solo | Social | Écart |
|--|:----:|:------:|:-----:|
| Bénéfice net | 47 111 € | 54 545 € | **+15,8%** |
| Heures de travail | 2 100 h | 2 076 h | -24 h |
| Dépendance aux autres | Aucune | Modérée | — |

**Conclusion** : le social donne un avantage de 15,8% — dans la cible visée (15-30%) — sans rendre le solo non-viable. Le joueur solo dégage 47 111 €, ce qui reste confortable. Il joue simplement « moins optimisé ».

### 12.3 Garde-fous anti-obligation sociale

| Risque | Mesure |
|--------|--------|
| « Il faut être en asso pour progresser » | Aucun contenu bloqué derrière une association |
| « Sans amis privilégiés je suis désavantagé » | Les économies sont un bonus, pas une nécessité |
| « Le classement récompense les sociaux » | Classement par production réelle, pas par réseau |
| « Les événements collectifs excluent les solos » | Les solos peuvent contribuer et recevoir les bonus |
| « La réputation est impossible à monter seul » | L'ancienneté (20%) monte sans interaction |

---

## 12bis. CFSA — Centre de Formation SimAgri (mécaniques sociales)

### 12bis.1 Intention de design

Le CFSA est un **système de mentorat structuré** qui formalise l'accompagnement des nouveaux joueurs par des vétérans. C'est à la fois un outil de rétention (les nouveaux restent grâce au mentorat) et une mécanique de prestige (devenir maître-exploitant est un accomplissement social).

### 12bis.2 Parcours CFSA — 42 jours

| Phase | Durée | Contenu | Validation |
|-------|:-----:|---------|:----------:|
| **Inscription** | J0 | Le nouveau joueur s'inscrit au CFSA après le tutoriel (optionnel) | Automatique si < 14 jours d'ancienneté |
| **Attribution maître** | J0-J1 | Le système attribue un maître-exploitant disponible dans la région | Match géographique + disponibilité |
| **Semaine 1-2** | J1-J14 | Cultures de base : semis, fertilisation, récolte | Quiz en jeu (5 questions, 80% requis) |
| **Semaine 3-4** | J15-J28 | Élevage OU économie (choix du mentor) | Action validée : 1ère vente réussie > 5 000 € |
| **Semaine 5-6** | J29-J42 | Spécialisation libre + premier investissement structurant | Achat de matériel OU bâtiment > 20 000 € |
| **Diplôme** | J42 | Certificat CFSA, badge permanent, bonus de sortie | Conditions ci-dessous |

### 12bis.3 Conditions de réussite

| Condition | Détail |
|-----------|--------|
| Durée minimum | 42 jours de jeu actif (pas de jours hors-ligne comptés) |
| Interactions avec le mentor | Minimum 8 messages échangés sur 42 jours |
| Actions validées | 3 validations sur 3 phases (quiz + vente + investissement) |
| Pas d'abandon | Si le joueur ne se connecte pas pendant 7 jours consécutifs → formation suspendue |

### 12bis.4 Récompenses

| Bénéficiaire | Récompense | Condition |
|:------------:|-----------|-----------|
| **Élève (nouveau joueur)** | 25 000 € d'aide à l'installation | Réussite des 3 phases |
| **Élève** | 4 jours d'AgriPass gratuit | Fin de formation |
| **Élève** | Badge « Diplômé CFSA » (permanent) | Certificat délivré |
| **Maître-exploitant** | +50 points de réputation | Par élève diplômé |
| **Maître-exploitant** | Badge « Mentor » (après 3 élèves) → « Maître-exploitant » (après 8 élèves) | Cumul |
| **Maître-exploitant** | Accès au canal mentor (forum privé) | 1er élève diplômé |

### 12bis.5 Devenir maître-exploitant

| Condition | Seuil |
|-----------|:-----:|
| Ancienneté minimum | 6 mois de jeu actif |
| Score de réputation | ≥ 60/100 |
| Exploitation viable | Bénéfice net > 0 sur les 3 derniers mois |
| Candidature | Volontaire (le joueur postule) |
| Capacité | 1 élève à la fois (max 2 en simultané pour les badges « Maître-exploitant ») |
| Refus possible | Le mentor peut refuser un élève (1 refus/mois max, pas de pénalité) |

### 12bis.6 Serveur Normal vs Serveur Expert

| Aspect | Normal | Expert |
|--------|--------|--------|
| CFSA disponible | Oui | Oui |
| Contenu adapté | Cultures simplifiées, économie de base | Intègre les mécaniques Expert (sol, ration, qualité) |
| Durée | 42 jours | 42 jours (même durée, contenu plus dense) |
| Aide financière | 25 000 € | 25 000 € (même montant — ADR-003) |

---

## 12ter. Sondages — Système générique

### 12ter.1 Mécanique

Les sondages permettent à tout joueur de consulter la communauté du serveur sur un sujet. Ils sont intégrés au forum mais accessibles depuis le tableau de bord.

| Paramètre | Valeur |
|-----------|--------|
| Qui peut créer un sondage | Tout joueur avec ≥ 30 jours d'ancienneté |
| Nombre d'options | 2 à 6 choix |
| Vote | 1 vote par joueur par sondage (irrévocable) |
| Durée | 3 à 14 jours (choisi par le créateur) |
| Résultats | Visibles en temps réel (nombre + %) |
| Anonymat | Vote anonyme (les autres joueurs ne voient pas qui a voté quoi) |
| Limitation | 1 sondage actif par joueur à la fois |
| Modération | Les administrateurs peuvent clôturer un sondage abusif |
| Notification | Alerte « Nouveau sondage » pour tous les joueurs du serveur (1×/sondage) |
| Catégories | Économie, Social, Événements, Règles du serveur, Divers |
| Sondage officiel (admin) | Résultat contraignant pour les décisions de gouvernance CAR |

### 12ter.2 Interface

```
┌─ Sondage — "Faut-il limiter les ventes nocturnes ?" ─────────┐
│                                                                │
│  Créé par : FermeDesChênes | Expire dans : 4 jours            │
│  Catégorie : Règles du serveur | 47 votes                     │
│                                                                │
│  ○ Oui, limiter à 22h max              ████████████░░  62% (29)│
│  ○ Non, garder la liberté totale        ██████░░░░░░░░  28% (13)│
│  ○ Oui mais seulement en semaine        ██░░░░░░░░░░░░  10% (5) │
│                                                                │
│  ✅ Vous avez voté (option 1)                                  │
│                                                                │
│  💬 12 commentaires | [ Voir les commentaires ]                │
└────────────────────────────────────────────────────────────────┘
```

**Serveur Normal et Serveur Expert** : même mécanique. Les sondages sont un outil social pur, pas de différence selon le serveur.

---

## 13. Équilibrage et scénarios

### 13.1 Objectifs d'équilibrage

| Objectif | Cible | Tolérance |
|----------|:-----:|:---------:|
| Avantage social vs solo | +20% | ±5% |
| % joueurs avec au moins 1 ami | >80% après 30j | — |
| % joueurs en association | 40-60% | ±10% |
| Temps moyen sur le social/jour | 3-5 min | — |
| Signalements traités < 48h | 95% | — |
| Multi-comptes détectés | >90% | — |

### 13.2 Checklist playtest

| Test | Critère | Bloquant ? |
|------|---------|:----------:|
| Test recette SimAgri | Un joueur SimAgri retrouve la richesse sociale du jeu original | ✅ Oui |
| Test solo viable | Un joueur peut atteindre 200 ha sans aucune interaction sociale | ✅ Oui |
| Test entraide intuitive | Un nouveau joueur comprend l'entraide sans tutoriel | ✅ Oui |
| Test anti-découragement | Un joueur de 30 ha ne se sent pas écrasé par les classements | ✅ Oui |
| Test modération | Un message toxique est masqué en < 1h (via signalements auto) | ⚠️ Souhaité |
| Test multi-comptes | Le système détecte un multi-compte en < 7 jours | ⚠️ Souhaité |
| Test événement collectif | >60% du département participe à un défi collectif | ❌ Non |

---

## Annexe — Récapitulatif des paramètres par serveur (social)

| Paramètre | Serveur Normal | Serveur Expert |
|-----------|--------|--------|
| Score réputation | Unique (0-100) | Décomposé (fiabilité, réactivité, qualité) |
| Calcul réputation | Formule simple à 3 facteurs | Algorithme pondéré avec decay temporel |
| Amis max | 150 | 150 |
| Amis privilégiés max | 10 | 10 |
| Commission marché entre privilégiés | 0% | 0% |
| Commission marché entre amis | 3% | 3% |
| Commission marché public | 5% | 5% |
| Prêt matériel entre privilégiés | Gratuit | Gratuit (mais usure comptabilisée) |
| Entraide max/jour | 5 | 5 |
| Ligues classement | 4 (par taille) | Classement absolu + 4 ligues |
| Badges | Cosmétiques | Cosmétiques + stats détaillées débloquées |
| Forum | Identique | Identique |
| Événements | Accessibles à tous | Défis Expert additionnels (contraintes) |
| Association max membres | 30 | 30 |
| Groupes discussion max membres | 50 | 50 |
| MP longueur max | 2 000 car. | 2 000 car. |
| Historique MP | 6 mois | 6 mois |
| Notifications | 6 types configurables | 6 types configurables |
| Sanctions | Identiques | Identiques |

---

## Historique des révisions

| Date | Modification | Raison |
|------|-------------|--------|
| 2026-08-04 | Création initiale | Cadrage des mécaniques sociales génériques |
| 2026-08-04 | Ajout §12bis CFSA (formation 42 jours) + §12ter Sondages (système générique) | Audit couverture fonctionnelle — systèmes 1.8, 10.4 et 10.10 partiels |
| 2026-08-04 | Passage à deux serveurs séparés : portée inter-serveurs, classements par serveur, stratégie d'ouverture séquentielle | ADR-005 |
