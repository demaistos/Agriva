> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


> ⚠️ **Note** : Ce document de review est antérieur aux décisions validées dans `GDD-SOURCE-VERITE.md`. Certains points soulevés ici ont été tranchés depuis.


# Review Monétisation — Agriva

> Date : 2026-08-04
> Auteur : Expert Monétisation (review externe)
> Statut : Analyse critique — À discuter

---

## Contexte de l'analyse

Agriva vise à reconstruire SimAgri (simulation agricole navigateur, fermé depuis ~10 ans) avec un modèle **F2P + abonnement confort (QoL), jamais Pay-to-Win**. Cible : adultes nostalgiques, progression longue durée. Le modèle originel SimAgri reposait sur un SimPass payant débloquant certaines features.

Cette review s'appuie sur mon expérience de monétisation de jeux de gestion navigateur/mobile (Travian, OGame, Forge of Empires, Ikariam, etc.) et sur les spécificités du projet Agriva.

---

## 1. Dix questions critiques sur la monétisation

### Q1 — Où est la ligne entre "confort QoL" et "feature essentielle" ?

Le mantra "jamais P2W" est louable, mais dans un jeu de gestion profond à 119 sous-systèmes, la frontière est floue. Un slot de file d'attente supplémentaire est-il du confort ou un avantage compétitif ? Un filtre de marché avancé ? Un raccourci d'interface ? **Si les joueurs F2P se sentent limités dans le gameplay core, vous avez un P2W perçu même si ce n'en est pas un objectivement.**

### Q2 — Quel est le revenu moyen par utilisateur (ARPU) cible ?

Avec un modèle abo seul (pas de microtransactions), votre ARPU est plafonné au prix de l'abo × taux de conversion. Sur des jeux navigateur niche, le taux de conversion F2P→payant tourne autour de 2-5%. Si votre abo est à 5€/mois et votre conversion à 3%, votre ARPU global est de **0,15€/mois/joueur**. Est-ce suffisant pour couvrir les coûts serveur + développement continu d'un jeu à 119 sous-systèmes ?

### Q3 — Comment justifier un paiement récurrent sur un jeu sans contenu saisonnier ?

Les abonnements marchent quand il y a du contenu frais régulier (MMO, Battle Pass, saisons). SimAgri/Agriva est un sandbox persistant. **Pourquoi un joueur continuerait-il à payer après 6 mois si les features QoL débloquées sont les mêmes ?** Le risque de churn sur l'abo est élevé sans injection de valeur nouvelle.

### Q4 — Quelle est la stratégie de rétention à long terme pour les joueurs F2P ?

Si les joueurs F2P n'ont aucune friction (puisque "pas de limitation gameplay"), quelle est leur motivation à convertir ? Et s'ils ont de la friction, comment la calibrer pour qu'elle pousse à la conversion sans être punitive ? **Le sweet spot entre "assez de friction pour convertir" et "pas assez pour frustrer et faire quitter" est extrêmement étroit.**

### Q5 — Le modèle survivra-t-il à une communauté petite ?

SimAgri était niche (~quelques milliers de joueurs actifs). Si Agriva atteint 2 000 joueurs actifs avec 3% de conversion, ça fait **60 abonnés**. À 5€/mois = 300€/mois de revenus. C'est même pas un serveur dédié. **Quel est le seuil de viabilité minimum et comment l'atteindre ?**

### Q6 — Pourquoi un seul tier d'abonnement et pas une structure à paliers ?

Un tier unique laisse de l'argent sur la table. Les "minnows" (petits payeurs) veulent un prix d'entrée bas. Les "dolphins" veulent plus de valeur. Un seul prix force un compromis qui ne satisfait personne optimalement. **Avez-vous envisagé 2-3 paliers ?**

### Q7 — Quelle monétisation pendant la phase de croissance initiale ?

Le jeu est en phase de cadrage. Au lancement, la base de joueurs sera minuscule. **Allez-vous offrir l'abo gratuitement pour les early adopters ? Pratiquer un "founder's pack" ? Comment financez-vous le développement continu entre le lancement et l'atteinte du seuil de rentabilité ?**

### Q8 — Comment gérez-vous la perception de valeur face au SimPass original ?

SimAgri demandait ~30€/an pour le SimPass. Les anciens joueurs vont comparer. **Si votre abo est plus cher avec moins de features (puisque le core reste gratuit), la valeur perçue peut être négative.** Si c'est moins cher, vos revenus par joueur chutent.

### Q9 — Existe-t-il des opportunités de monétisation non-récurrente ?

Cosmétiques (skins de tracteurs, décorations de ferme), packs ponctuels, DLC de contenu... Un modèle 100% abo dans un jeu niche est fragile. **Des achats ponctuels en complément diversifieraient les revenus et captureraient les joueurs qui refusent les abos mais paieraient pour un achat unique.**

### Q10 — Comment mesurez-vous que le modèle n'est PAS Pay-to-Win ?

"Jamais P2W" est un engagement fort. **Avez-vous une définition opérationnelle testable ?** Par exemple : "Un joueur F2P atteignant le même temps de jeu qu'un abonné doit pouvoir atteindre les mêmes résultats économiques/classement à ±10%". Sans métrique, c'est un vœu pieux.

---

## 2. Cinq risques business majeurs

### Risque 1 — Marché trop étroit, revenus insuffisants

**Probabilité : Élevée | Impact : Critique**

SimAgri était un jeu ultra-niche francophone. Même en élargissant (multilingue, UX moderne), le marché adressable d'une simulation agricole réaliste navigateur reste petit. Avec un modèle pur abo, le plafond de revenus est bas. Le risque est de ne jamais atteindre la viabilité financière pour maintenir un jeu à 119 sous-systèmes.

**Mitigation :** Diversifier les sources de revenus (cosmétiques, achats ponctuels), viser l'international dès le lancement, optimiser les coûts serveur.

### Risque 2 — Churn élevé sur l'abonnement

**Probabilité : Élevée | Impact : Fort**

Sans contenu saisonnier ou injection de valeur régulière, les abonnés décrochent après 3-6 mois. Le jeu sandbox n'a pas de "fin de saison" qui force le renouvellement. Les joueurs qui ont débloqué toutes les features QoL n'ont plus de raison de rester abonnés si leur ferme "tourne toute seule".

**Mitigation :** Introduire des avantages rotatifs, du contenu exclusif mensuel, des événements réservés aux abonnés (sans avantage compétitif).

### Risque 3 — Perception P2W malgré l'intention contraire

**Probabilité : Moyenne | Impact : Fort**

Dans une économie joueur compétitive (marché, classements, coopératives), tout avantage de productivité — même "confort" — peut être perçu comme P2W par la communauté. Un seul thread Reddit/forum viral "Agriva is P2W" peut tuer la réputation et la croissance organique.

**Mitigation :** Définir publiquement et précisément ce qui est et n'est pas inclus dans l'abo. Faire valider par la communauté. Limiter strictement l'abo à du cosmétique + UX (jamais de vitesse, jamais de rendement, jamais d'accès exclusif à du contenu gameplay).

### Risque 4 — Coût de développement disproportionné vs revenus

**Probabilité : Élevée | Impact : Critique**

119 sous-systèmes, c'est un scope MMO. Même AI-assisted, le développement + maintenance + modération + serveurs coûtent cher. Si les revenus restent à quelques centaines d'euros/mois pendant les 2 premières années, le projet meurt d'épuisement financier et motivationnel.

**Mitigation :** Lancer avec un scope réduit mais monétisable (MVP avec 20-30 sous-systèmes core). Valider le modèle économique AVANT de développer les 119 systèmes.

### Risque 5 — Pas de whale mechanics = pas de revenus concentrés

**Probabilité : Certaine | Impact : Moyen**

Dans les jeux F2P classiques, 80% des revenus viennent de 5-10% des joueurs (whales). Un modèle abo pur élimine cette mécanique. Vous dépendez entièrement du volume de joueurs. Or le volume est votre faiblesse (niche). **Vous avez structurellement un modèle qui demande du volume dans un marché qui n'en offre pas.**

**Mitigation :** Créer des paliers premium élevés pour les joueurs qui VEULENT dépenser plus (cosmétiques premium, support prioritaire, nom dans les crédits, etc.) sans avantage gameplay.

---

## 3. Proposition de structure de monétisation

### Architecture recommandée : Freemium 3 tiers + boutique cosmétique

#### Tier 0 — Gratuit (Free)
**Prix : 0€**

| Inclus | Exclu |
|--------|-------|
| Accès à TOUS les systèmes de jeu (cultures, élevage, marché, coopératives...) | — |
| Progression identique aux payants | — |
| Marché joueur complet | — |
| Social (messagerie, coopératives) | — |

**Limitations UX uniquement :**
- Publicités discrètes (bannière en bas, jamais interstitielles intrusives)
- Interface standard (pas de thèmes)
- Notifications basiques (email uniquement)
- 1 ferme par compte

#### Tier 1 — Fermier (Abonnement Confort)
**Prix : 3,99€/mois | 34,99€/an (−27%)**

| Feature | Description |
|---------|-------------|
| Zéro publicité | Suppression totale des pubs |
| Notifications avancées | Push, SMS, alertes personnalisées |
| Thèmes d'interface | 5+ thèmes visuels |
| Tableau de bord avancé | Statistiques détaillées, graphiques, historiques |
| Multi-onglets | Plusieurs vues simultanées |
| Export de données | CSV/PDF de ses stats |
| Badge abonné | Cosmétique sur le profil |
| Support prioritaire | Réponse < 24h |

#### Tier 2 — Agriculteur Premium
**Prix : 7,99€/mois | 69,99€/an (−27%)**

Inclut tout le Tier 1, plus :

| Feature | Description |
|---------|-------------|
| 2ème ferme | Possibilité de gérer une deuxième exploitation |
| Personnalisation avancée | Couleurs de bâtiments, noms custom, blason |
| Accès bêta | Tester les nouvelles features en avant-première |
| Historique de marché étendu | 6 mois au lieu de 1 mois |
| Automatisations QoL | Réapprovisionnement auto, alertes de seuils |
| Nom dans les crédits | Reconnaissance permanente |

#### Boutique Cosmétique (achats ponctuels)
**Prix : 0,99€ à 9,99€ par item**

- Skins de tracteurs et matériel
- Décorations de ferme (arbres, clôtures, bâtiments déco)
- Avatars et cadres de profil
- Emotes et réactions en chat
- Packs saisonniers (Noël, moissons, vendanges)

**Règle absolue : RIEN dans la boutique n'affecte le gameplay, les rendements, la vitesse, ou l'économie.**

#### Offre Fondateur (lancement uniquement)
**Prix : 49,99€ one-time**

- Tier 2 gratuit pendant 1 an
- Badge "Fondateur" permanent (rare, jamais réédité)
- Nom dans les crédits spéciaux
- Accès Discord privé avec les développeurs
- Skin de tracteur exclusif

**Objectif : financer le lancement + créer une communauté investie émotionnellement**

---

### Justification des prix

| Référence | Prix |
|-----------|------|
| SimAgri SimPass | ~2,50€/mois (30€/an) |
| Forge of Empires VIP | 0€ (mais microtransactions lourdes) |
| Farming Simulator (achat) | 40€ + DLC |
| Old School RuneScape | 10,99€/mois |
| EVE Online | 14,99€/mois |

Le Tier 1 à 3,99€/mois est **en dessous du SimPass historique** en valeur faciale, ce qui est important pour la perception des anciens joueurs. Le Tier 2 offre suffisamment de valeur ajoutée pour justifier le doublement.

---

## 4. Trois métriques clés à suivre dès le lancement

### Métrique 1 — Taux de conversion F2P → Payant (par cohorte)

**Définition :** % de joueurs ayant joué ≥7 jours qui souscrivent un abonnement dans les 30/60/90 jours.

**Cible :** 
- J+30 : ≥2%
- J+60 : ≥4%
- J+90 : ≥5%

**Pourquoi c'est critique :** C'est VOTRE métrique de survie. Si la conversion est sous 2% à J+90, le modèle est cassé — soit la valeur perçue de l'abo est trop faible, soit le jeu gratuit est "trop bien" (pas assez de friction QoL), soit le pricing est mauvais.

**Comment la bouger :** A/B tester les features par tier, ajuster le pricing, améliorer l'onboarding vers la conversion (moments de friction naturels = trigger de conversion).

### Métrique 2 — Rétention de l'abonnement (churn mensuel)

**Définition :** % d'abonnés qui annulent leur abonnement chaque mois.

**Cible :**
- Mois 1-3 : churn ≤ 8%/mois
- Mois 4-12 : churn ≤ 5%/mois
- Mois 12+ : churn ≤ 3%/mois

**Pourquoi c'est critique :** Un churn de 10%/mois signifie que vous perdez la moitié de vos abonnés en 7 mois. Sur un jeu niche où l'acquisition coûte cher (pas de viralité organique massive), chaque abonné perdu est très difficile à remplacer.

**Comment la bouger :** Ajouter de la valeur régulière à l'abo (contenu mensuel, features QoL nouvelles), engagement communautaire, réductions pour engagement long terme (annuel vs mensuel).

### Métrique 3 — LTV/CAC (Lifetime Value / Coût d'Acquisition Client)

**Définition :** Revenu total moyen généré par un joueur sur sa durée de vie ÷ coût pour acquérir ce joueur.

**Cible :** LTV/CAC ≥ 3

**Pourquoi c'est critique :** Si votre LTV est de 15€ (abonné moyen 4 mois à 3,99€) et votre CAC est de 10€ (pub Facebook niche), votre ratio est 1,5 — vous êtes à peine rentable. Ce ratio détermine si vous pouvez investir en acquisition ou si vous dépendez uniquement du bouche-à-oreille.

**Comment la bouger :** Augmenter la LTV (réduire le churn, upsell Tier 2, cosmétiques ponctuels) ET réduire le CAC (SEO, communauté, contenu organique, partenariats streamers farming sim).

---

## Synthèse et recommandation finale

Le modèle "F2P + abo confort" est **philosophiquement sain** mais **économiquement fragile** pour un jeu de cette ambition (119 sous-systèmes) dans un marché niche. 

**Mes 3 recommandations prioritaires :**

1. **Diversifiez les revenus** — L'abo seul ne suffira pas. Ajoutez cosmétiques + offre fondateur + dons/tips communautaires. Visez un mix 60% abo / 30% cosmétiques / 10% one-time.

2. **Validez le modèle AVANT le scope complet** — Lancez un MVP avec 20-30 systèmes, monétisez, mesurez. Si la conversion est sous 2% et le churn au-dessus de 10%, pivotez avant d'investir 2 ans de développement.

3. **Définissez opérationnellement le "pas P2W"** — Écrivez une charte publique avec des critères testables. Faites-la valider par votre communauté early. C'est votre avantage compétitif face aux Forge of Empires du monde — protégez-le.

---

*Ce document est une review externe. Il ne remplace pas les décisions du game director mais doit alimenter la discussion sur la viabilité du modèle économique.*
