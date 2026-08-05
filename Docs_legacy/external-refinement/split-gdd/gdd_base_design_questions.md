# Agriva GDD — Base de Questions Design
> Questions structurées avec 3 options par thème — base de décision pour toute l'équipe
> Lignes source : 9075–9914

---

# Vois tu d’autre chose comme base de game design ?

Oui. Vous avez déjà posé beaucoup de bases solides, mais je vois encore plusieurs **fondations de game design** à statuer pour éviter des ambiguïtés plus tard. Les approches de préproduction recommandent de définir clairement les piliers, les boucles de jeu, les ressources, les contraintes et les relations entre systèmes avant d’entrer dans la production technique.[^62_1][^62_2][^62_3]

## Les bases restantes

Je pense qu’il vous reste surtout à trancher ces 10 blocs :


| Bloc | Question à figer |
| :-- | :-- |
| Boucle principale | Que fait le joueur chaque jour / semaine / saison ? |
| Conditions de victoire | On joue pour quoi : croissance, richesse, classement, maîtrise ? |
| Conditions d’échec | Qu’est-ce qui met réellement en danger l’exploitation ? |
| Rythme du temps | Que se passe-t-il chaque jour, et qu’est-ce qui est résolu automatiquement ? |
| Progression | Comment on passe de petite ferme à grande exploitation ? |
| Risques | Quelle place pour météo, maladie, dette, panne, marché ? |
| Automatisation | Qu’est-ce que le joueur finit par déléguer ? |
| Information | Quelles infos sont visibles, et sous quelle forme ? |
| Onboarding | Comment le joueur apprend sans être noyé ? |
| Profils de jeu | Quels parcours sont valorisés : éleveur, cultivateur, trader, gestionnaire ? |

## Les trois plus urgents

S’il faut prioriser, je dirais que les trois décisions les plus importantes maintenant sont :

### 1. La boucle de jeu

Il faut écrire noir sur blanc la séquence type :

- observer ;
- planifier ;
- affecter ;
- exécuter ;
- vendre / acheter ;
- investir ;
- préparer la suite.

Une boucle claire est essentielle, car elle structure tout le reste du design et donne au joueur un rythme compréhensible.[^62_4][^62_5]

### 2. Les conditions d’échec et de tension

Il faut savoir ce qui fait pression sur le joueur :

- manque d’argent ;
- manque de travail ;
- fenêtre météo ratée ;
- mauvais investissement ;
- dette ;
- baisse de fertilité ;
- perte de cheptel.

Sans tension claire, un jeu de gestion perd de sa saveur ; avec trop de tension opaque, il devient punitif.[^62_3][^62_6]

### 3. La progression

Il faut décider ce que signifie “progresser” :

- plus de surface ;
- plus de spécialisation ;
- plus de diversification ;
- plus de mécanisation ;
- plus d’automatisation ;
- plus de prestige ou de classement.

Les travaux sur les loops et la progression rappellent qu’il faut déterminer très tôt le chemin de progression principal et ses ressources associées.[^62_7][^62_4]

## Ce que je vous conseille aussi de figer

Je pense qu’il faut statuer sur les règles suivantes :

- **une tâche répétée doit devenir batchable ou délégable** ;
- **un système visible doit produire une vraie décision** ;
- **l’échec doit être annoncé avant d’être subi** ;
- **le joueur doit apprendre dans l’action, pas par lecture lourde** ;
- **chaque activité doit avoir une identité de rythme et de contraintes**.

Les bonnes pratiques d’onboarding et de fondations de game design insistent sur un apprentissage progressif, des petits succès précoces et une révélation graduelle de la complexité.[^62_8][^62_9]

## Les questions très concrètes à encore trancher

Je vous proposerais cette checklist :

- le joueur incarne-t-il une ferme unique ou peut-il gérer plusieurs sites ?
- y a-t-il faillite, redressement, ou simple ralentissement ?
- le temps avance-t-il en continu ou par validations ?
- quelles tâches peuvent être planifiées en avance ?
- quelles tâches exigent une intervention active ?
- quelles ressources sont visibles en synthèse et lesquelles sont détaillées ?
- comment se débloquent les couches expertes ?
- comment le classement mesure-t-il la réussite ?
- quel est le premier “grand objectif” des 7 premiers jours ?
- quel est le premier “grand objectif” du premier mois ou de la première saison ?


## Mon avis net

Le plus gros sujet encore un peu flou, selon moi, n’est plus l’économie ni les ressources.
C’est **le contrat de jeu** :

- qu’est-ce qu’on fait souvent ;
- qu’est-ce qui est risqué ;
- qu’est-ce qui fait progresser ;
- qu’est-ce qui fait gagner.

C’est ce qu’il faut verrouiller maintenant pour que tout le reste reste cohérent avec vos piliers.[^62_2][^62_5][^62_1]

## Proposition de règle

Je poserais cette règle fondatrice :

**Chaque système d’Agriva doit renforcer la boucle observer → décider → planifier → exécuter → récolter les conséquences → progresser.**

Si un système ne renforce pas cette boucle, il est probablement secondaire ou à simplifier.

## Ma recommandation pratique

Si vous voulez vraiment avancer proprement, la prochaine chose à faire est de figer un document très court avec seulement :

- les piliers ;
- la boucle principale ;
- les ressources ;
- les tensions ;
- la progression ;
- les règles de simplification / mode expert.

C’est, à mon sens, la dernière grande base de game design à consolider avant d’ouvrir les choix plus techniques.[^62_1][^62_3][^62_8]
<span style="display:none">[^62_10][^62_11][^62_12][^62_13][^62_14][^62_15]</span>

<div align="center">⁂</div>

[^62_1]: https://ch0m5.github.io/Game-Design-Pillars/

[^62_2]: https://gamedesigns.github.io/docs/tutorial-basics/intro

[^62_3]: https://journals.sagepub.com/doi/10.1177/1046878118768858

[^62_4]: https://deliberategamedesign.com/resources-loop/

[^62_5]: https://jm-j.com/education/intro_to_game_design.pdf

[^62_6]: https://proceedings.systemdynamics.org/2015/proceed/papers/P1142.pdf

[^62_7]: https://www.reddit.com/r/gamedesign/comments/1muj2an/a_hierarchy_of_fun_what_are_your_core_game_design/

[^62_8]: https://adriancrook.com/best-practices-for-mobile-game-onboarding/

[^62_9]: https://yukaichou.com/gamification-analysis/onboarding-design-gamification-first-five-minutes/

[^62_10]: https://www.scribd.com/document/271300699/Game-Design-Foundations

[^62_11]: https://gamedevessentials.com/10-essential-game-design-principles-every-developer-should-know/

[^62_12]: https://researchportal.bath.ac.uk/files/284256559/Smith_Procedural_Constraint_based_Generation_for_Game_Development_Thesis_Acknowledgements_.pdf

[^62_13]: https://pressstartleadership.com/rethinking-onboarding-for-game-developers-a-complete-guide-to-building-confident-aligned-teams/

[^62_14]: https://www.linkedin.com/posts/zamfir-stefan-213251b_leveldesign-gamedesign-leveldesign101-activity-7363819208356376577-eH3c

[^62_15]: https://www.nature.com/articles/s41599-025-04990-x


---

# Compile tout le contexte de notre discusion dans un fichier md

C’est fait.
J’ai compilé tout le contexte de la discussion dans un fichier Markdown structuré, prêt à servir de base de cadrage pour Agriva.

---

# Fais aussi la liste complete des choses à statuer dans le game design

C’est ajouté.
J’ai enrichi le fichier Markdown avec une **liste complète des choses à statuer en game design**, organisée par grands blocs, avec une **priorisation** pour savoir quoi verrouiller en premier.[^64_1][^64_2][^64_3]

Je vous conseille d’utiliser cette checklist comme base de travail pour :

- valider les décisions déjà prises ;
- repérer les zones encore floues ;
- transformer ensuite cela en vrai document maître de game design.
<span style="display:none">[^64_10][^64_11][^64_12][^64_13][^64_14][^64_15][^64_4][^64_5][^64_6][^64_7][^64_8][^64_9]</span>

<div align="center">⁂</div>

[^64_1]: https://room8studio.com/news/game-pre-production-core-steps/

[^64_2]: https://ch0m5.github.io/Game-Design-Pillars/

[^64_3]: https://www.gamedeveloper.com/design/what-developers-need-to-know-about-making-a-management-simulator

[^64_4]: https://gdkeys.com/game-development-process/

[^64_5]: https://gamedevessentials.com/a-7-step-framework-for-game-economy-design/

[^64_6]: https://www.udacity.com/topic/game-development-process

[^64_7]: https://book.leveldesignbook.com/process/preproduction

[^64_8]: https://fgfactory.com.au/resources/the-ultimate-game-development-checklist

[^64_9]: https://rocketbrush.com/blog/game-development-process-guide

[^64_10]: https://machinations.io/articles/embracing-the-big-picture-a-practical-guide-to-machinations-and-system-thinking

[^64_11]: https://checklist.gg/templates/game-design-checklist

[^64_12]: https://www.reddit.com/r/gamedev/comments/2be1lt/game_preproduction_how_is_it_done/

[^64_13]: https://www.reddit.com/r/gamedesign/comments/1mnmbe6/how_do_you_decide_what_to_prioritize_when/

[^64_14]: https://www.perforce.com/resources/game-development-process

[^64_15]: https://www.linkedin.com/pulse/decoding-core-game-design-terms-meta-systems-builds-peng-jen-chen-qjeqc


---

# Agriva — Questions de game design avec 3 options cohérentes

## Objet

Ce document transforme la checklist de cadrage en format de travail décisionnel. Pour chaque grande question de game design, trois options cohérentes sont proposées afin de faciliter les arbitrages en préproduction. Les approches de design pillars et de préproduction recommandent justement de formuler des options claires avec leurs conséquences, afin que chaque choix puisse être évalué à l’aune de la vision du jeu plutôt qu’au fil de l’eau.[^65_1][^65_2][^65_3]

## 1. Vision produit

### 1.1 Quelle est la promesse centrale du jeu ?

- **Option A — Gestion agricole accessible et moderne** : priorité à la lisibilité, aux bons arbitrages et à une prise en main rapide.
- **Option B — Simulation agricole crédible et profonde** : priorité à la cohérence systémique et à la richesse de décision.
- **Option C — Sandbox agricole évolutif** : priorité à la liberté, à la diversité des styles de jeu et à l’appropriation du système.


### 1.2 Quel niveau de réalisme viser ?

- **Option A — Réalisme ludique** : simplification forte de tout ce qui n’apporte pas de décision amusante.
- **Option B — Réalisme sélectif** : fidélité sur les systèmes centraux, abstraction sur le reste.
- **Option C — Réalisme élevé** : plus de détails métiers et plus de contraintes structurelles.


### 1.3 Quel public prioritaire ?

- **Option A — Joueurs de gestion généralistes** : onboarding plus fort, interface plus guidée.
- **Option B — Joueurs agricoles / simulation** : contenu métier plus dense, profondeur plus visible.
- **Option C — Public mixte** : base accessible avec couches expertes modulaires.


## 2. Piliers de design

### 2.1 Combien de piliers garder ?

- **Option A — 3 piliers** : très lisible, très directif.
- **Option B — 5 piliers** : meilleur équilibre entre clarté et nuance.
- **Option C — 6 à 7 piliers** : plus complet, mais risque de dilution.[^65_2][^65_1]


### 2.2 Quel filtre appliquer à toute mécanique ?

- **Option A — Crée-t-elle une vraie décision ?**
- **Option B — Renforce-t-elle la boucle principale ?**
- **Option C — Est-elle lisible pour le joueur normal ?**


## 3. Boucle de jeu

### 3.1 Quelle boucle centrale retenir ?

- **Option A — Observer → planifier → exécuter → vendre → investir**.
- **Option B — Observer → arbitrer → affecter ressources → résoudre → corriger**.
- **Option C — Produire → échanger → agrandir → spécialiser → optimiser**.


### 3.2 Quel rythme de décision dominant ?

- **Option A — Quotidien** : beaucoup de petits arbitrages.
- **Option B — Hebdomadaire** : plus synthétique, moins de friction.
- **Option C — Mixte** : quotidien pour l’opérationnel, saisonnier pour la stratégie.


## 4. Temps

### 4.1 Comment le temps avance-t-il ?

- **Option A — Tick quotidien validé** : très lisible, bon pour le navigateur.
- **Option B — Temps continu accéléré** : plus vivant, mais plus complexe.
- **Option C — Temps hybride** : file de tâches + résolutions à moments clés.


### 4.2 Quelle unité est la plus structurante ?

- **Option A — Le jour**.
- **Option B — La semaine**.
- **Option C — La saison**.


## 5. Ressources principales

### 5.1 Quelles ressources de pilotage garder en V1 ?

- **Option A — Argent + travail + matériel**.
- **Option B — Argent + travail + matériel + stockage**.
- **Option C — Argent + travail + matériel + stockage + logistique**.


### 5.2 Comment représenter le travail ?

- **Option A — Heures de travail quotidiennes**.
- **Option B — Équipes ou unités de travail**.
- **Option C — Système hybride : heures affichées, équipes en support.**


## 6. Travail et main-d’œuvre

### 6.1 Comment la capacité de travail reset-elle ?

- **Option A — Reset journalier strict**.
- **Option B — Reset journalier avec reports limités**.
- **Option C — Capacité lissée sur plusieurs jours.**


### 6.2 Quelle granularité pour la main-d’œuvre ?

- **Option A — Main-d’œuvre agrégée** : simple et lisible.
- **Option B — Main-d’œuvre par catégories** : familiale, salariée, saisonnière.
- **Option C — Main-d’œuvre individualisée** : plus riche, plus lourde.


## 7. Matériel

### 7.1 Comment modéliser la capacité machine ?

- **Option A — Par type de machine requis** : tracteur, semoir, etc.
- **Option B — Par capacité générique d’atelier** : plus simple.
- **Option C — Double système** : générique en normal, détaillé en expert.


### 7.2 Comment gérer l’usure ?

- **Option A — Pas d’usure en V1**.
- **Option B — Usure simplifiée avec entretien périodique**.
- **Option C — Usure détaillée avec pannes et indisponibilités.**


## 8. Planification

### 8.1 Comment afficher la faisabilité d’une file de tâches ?

- **Option A — Vert / orange / rouge**.
- **Option B — Pourcentage de faisabilité**.
- **Option C — Alertes textuelles de conflit.**


### 8.2 Quel niveau de liberté laisser au joueur ?

- **Option A — Bloquer toute tâche impossible**.
- **Option B — Autoriser mais signaler fortement**.
- **Option C — Autoriser et résoudre automatiquement avec reports.**


### 8.3 Comment traiter la réservation de ressources ?

- **Option A — Réservation immédiate intégrale**.
- **Option B — Réservation souple avec conflits signalés**.
- **Option C — Réservation seulement au lancement réel.**


## 9. Activités V1

### 9.1 Quelles activités inclure en premier ?

- **Option A — Grandes cultures + élevage + maraîchage**.
- **Option B — Grandes cultures + élevage + viticulture**.
- **Option C — Grandes cultures + élevage + maraîchage + arboriculture.**


### 9.2 Comment structurer le futur ?

- **Option A — Extensions par familles d’activités**.
- **Option B — Extensions par régions / terroirs**.
- **Option C — Extensions par couches de simulation.**


## 10. Cultures

### 10.1 Quelle granularité des cultures en V1 ?

- **Option A — Familles de cultures**.
- **Option B — Cultures précises majeures seulement**.
- **Option C — Cultures précises + variantes régionales plus tard.**


### 10.2 Quelle importance des rotations ?

- **Option A — Bonus/malus simples**.
- **Option B — Système central de fertilité**.
- **Option C — Détail complet en expert seulement.**


## 11. Élevage

### 11.1 Quelle granularité d’élevage ?

- **Option A — Atelier global**.
- **Option B — Lots**.
- **Option C — Individus en expert, lots en normal.**


### 11.2 Quelle source de croissance du troupeau ?

- **Option A — Reproduction surtout**.
- **Option B — Mix reproduction + achats marché**.
- **Option C — Dépend fortement de l’activité et de l’espèce.**


## 12. Sols et agronomie

### 12.1 Quel indicateur simple en mode normal ?

- **Option A — Fertilité**.
- **Option B — Fertilité + humidité**.
- **Option C — Fertilité + humidité + fatigue culturale.**


### 12.2 Quel niveau expert ?

- **Option A — NPK seul**.
- **Option B — NPK + matière organique**.
- **Option C — NPK + MO + pH + historique cultural.**


## 13. Météo

### 13.1 Quelle granularité météo ?

- **Option A — Départementale**.
- **Option B — Régionale avec modificateurs locaux**.
- **Option C — Bassin local précis.**


### 13.2 Quelle visibilité future ?

- **Option A — Prévision courte**.
- **Option B — Prévision moyenne avec incertitude**.
- **Option C — Prévision longue simplifiée.**


## 14. Territoire

### 14.1 Quel niveau territorial principal ?

- **Option A — Département**.
- **Option B — Ville / bassin local**.
- **Option C — Double niveau : département + localité.**


### 14.2 Comment donner une identité aux territoires ?

- **Option A — Par météo et activités dominantes**.
- **Option B — Par sol, climat, économie et accès marché**.
- **Option C — Par ensembles régionaux fortement typés.**


## 15. Foncier et parcelles

### 15.1 Quelle abstraction des parcelles ?

- **Option A — Parcelles textuelles/localisées sans géométrie**.
- **Option B — Parcelles avec taille, forme abstraite, accès**.
- **Option C — Géométrie simplifiée plus tard, abstraite en V1.**


### 15.2 Quelle logique de fusion ?

- **Option A — Fusion permanente et coûteuse**.
- **Option B — Fusion permanente avec délai**.
- **Option C — Fusion permanente + limites par bassin local.**


## 16. Bâtiments

### 16.1 Quel rôle principal des bâtiments ?

- **Option A — Capacités et stockage**.
- **Option B — Capacités + bonus de production**.
- **Option C — Capacités + bonus + déblocage d’activités.**


## 17. Économie générale

### 17.1 Quel type d’économie ?

- **Option A — Hybride joueur + bot**.
- **Option B — Joueur dominant avec bot minimal**.
- **Option C — Bot structurant au départ puis plus discret ensuite.**


### 17.2 Quel marché doit être le plus avantageux ?

- **Option A — Marché joueur**.
- **Option B — Selon les produits**.
- **Option C — Selon distance, timing et volume.**


## 18. Marché bot

### 18.1 Comment fixer les prix bot ?

- **Option A — Prix fixes**.
- **Option B — Prix semi-dynamiques**.
- **Option C — Prix bornés par plancher/plafond.**


### 18.2 Comment éviter l’abus du bot pour les grandes exploitations ?

- **Option A — Rendements décroissants sur volumes**.
- **Option B — Frais croissants**.
- **Option C — Prix de reprise dégressifs par tranche.**


### 18.3 Quel rôle pour le bot sur les animaux ?

- **Option A — Amorçage uniquement**.
- **Option B — Amorçage + dépannage**.
- **Option C — Amorçage + dépannage + quotas progressifs.**


## 19. Coopératives bot

### 19.1 Où placer la coopérative bot ?

- **Option A — Préfecture du département**.
- **Option B — Capitale économique locale**.
- **Option C — Préfecture en V1, réseau secondaire plus tard.**


### 19.2 Quel est son rôle ?

- **Option A — Achat/vente uniquement**.
- **Option B — Achat/vente + logistique**.
- **Option C — Achat/vente + logistique + services de filière.**


## 20. Marché joueur

### 20.1 Quelle portée pour le marché joueur ?

- **Option A — National**.
- **Option B — Régional interconnecté**.
- **Option C — National avec coûts logistiques différenciés.**


### 20.2 Quelle forme de vente ?

- **Option A — Annonces directes**.
- **Option B — Ordres d’achat/vente**.
- **Option C — Système mixte.**


### 20.3 Quels outils de recherche ?

- **Option A — Filtres simples**.
- **Option B — Filtres avancés + favoris**.
- **Option C — Filtres avancés + comparateur + historique.**


## 21. Prix

### 21.1 Quelle part de prix dynamiques ?

- **Option A — Très limitée**.
- **Option B — Moyenne**.
- **Option C — Forte, selon marché et saison.**


### 21.2 Quelle place pour la qualité ?

- **Option A — Aucune en V1**.
- **Option B — Quelques paliers de qualité**.
- **Option C — Qualité importante sur plusieurs filières.**


## 22. Intrants

### 22.1 Quelle disponibilité des intrants de base ?

- **Option A — Toujours disponibles au bot**.
- **Option B — Disponibles mais avec fluctuations**.
- **Option C — Certains garantis, d’autres plus rares.**


## 23. Stockage et logistique

### 23.1 Quelle importance donner au stockage ?

- **Option A — Contrainte légère**.
- **Option B — Contrainte moyenne et structurante**.
- **Option C — Système majeur de décision.**


### 23.2 Comment traiter la logistique ?

- **Option A — Coûts abstraits simples**.
- **Option B — Coûts + délais**.
- **Option C — Réseau logistique plus riche à terme.**


## 24. Transformation

### 24.1 Quand introduire la transformation ?

- **Option A — Hors V1**.
- **Option B — Quelques chaînes simples en V1**.
- **Option C — Système avancé réservé aux spécialisations.**


## 25. Progression

### 25.1 Quel axe principal de progression ?

- **Option A — Agrandissement**.
- **Option B — Spécialisation**.
- **Option C — Agrandissement + spécialisation + diversification.**


### 25.2 Comment éviter la croissance en clics ?

- **Option A — Batch systématique**.
- **Option B — Délégation progressive**.
- **Option C — Automatisation partielle + meilleurs outils de pilotage.**


## 26. Réussite et échec

### 26.1 Quelle forme d’échec ?

- **Option A — Pas de game over, seulement ralentissement**.
- **Option B — Faillite partielle avec redressement possible**.
- **Option C — Faillite réelle mais rare et bien annoncée.**


### 26.2 Comment mesurer la réussite ?

- **Option A — Argent et croissance**.
- **Option B — Rentabilité, stabilité et diversification**.
- **Option C — Succès multi-axes : richesse, maîtrise, prestige, classement.**


## 27. Risques

### 27.1 Quel niveau de risque en V1 ?

- **Option A — Modéré**.
- **Option B — Présent mais lisible**.
- **Option C — Fort mais surtout en expert.**


### 27.2 Comment annoncer les risques ?

- **Option A — Alertes explicites**.
- **Option B — Indicateurs de tension**.
- **Option C — Avertissements progressifs + recommandations.**


## 28. Information et UI

### 28.1 Quelle densité d’information sur l’écran principal ?

- **Option A — Très synthétique**.
- **Option B — Synthétique avec panneaux secondaires**.
- **Option C — Personnalisable selon le profil du joueur.**


### 28.2 Quel système d’alertes ?

- **Option A — Peu d’alertes, très prioritaires**.
- **Option B — Alertes hiérarchisées**.
- **Option C — Centre de notifications filtrable.**


## 29. Onboarding

### 29.1 Comment apprendre au joueur ?

- **Option A — Tutoriel guidé court**.
- **Option B — Missions contextuelles progressives**.
- **Option C — Bac à sable assisté avec conseils.**


### 29.2 Quand proposer les modules experts ?

- **Option A — Au choix dès le départ**.
- **Option B — Déblocage progressif recommandé**.
- **Option C — Suggestion intelligente selon comportement du joueur.**


## 30. Normal / expert

### 30.1 Comment organiser les modes ?

- **Option A — Mode normal / expert global**.
- **Option B — Modules experts par système**.
- **Option C — Global + réglages fins par système.**


### 30.2 Comment préserver la cohérence ?

- **Option A — Un seul moteur, deux vues**.
- **Option B — Un moteur simplifié et un moteur expert**.
- **Option C — Moteur commun + couches additionnelles.**


## 31. Profils de jeu

### 31.1 Quels styles de jeu valoriser ?

- **Option A — Producteur / gestionnaire**.
- **Option B — Producteur / éleveur / commerçant**.
- **Option C — Large palette incluant spécialiste, trader, organisateur, territorial.**


## 32. Objectifs et classements

### 32.1 Comment segmenter les classements ?

- **Option A — Par mode**.
- **Option B — Par mode + activité**.
- **Option C — Par mode + activité + saison + région.**


### 32.2 Quels objectifs proposer ?

- **Option A — Objectifs personnels**.
- **Option B — Objectifs personnels + défis saisonniers**.
- **Option C — Objectifs personnels + défis + ligues + succès experts.**


## 33. Automatisation

### 33.1 Quelle philosophie d’automatisation ?

- **Option A — Très limitée**.
- **Option B — Débloquée avec la progression**.
- **Option C — Personnalisable selon le style de jeu.**


### 33.2 Qu’automatiser en premier ?

- **Option A — Tâches répétitives simples**.
- **Option B — Logistique et réapprovisionnement**.
- **Option C — Ateliers entiers en gestion avancée.**


## 34. Abstractions assumées

### 34.1 Comment formaliser les simplifications ?

- **Option A — Liste interne seulement**.
- **Option B — Document de design explicite**.
- **Option C — Document de design + conventions UI/UX par système.**


## 35. V1 vs futur

### 35.1 Quelle stratégie de V1 ?

- **Option A — Très resserrée, extrêmement propre**.
- **Option B — Socle moyen avec plusieurs portes ouvertes**.
- **Option C — Socle large mais simplifié.**


### 35.2 Comment penser l’extension future ?

- **Option A — Par modules d’activité**.
- **Option B — Par modules de simulation**.
- **Option C — Par territoires + filières + expertises.**


## 36. Contrat de complexité

### 36.1 Quelle promesse de complexité faire au joueur ?

- **Option A — Facile à prendre en main, profond ensuite**.
- **Option B — Exigeant mais lisible**.
- **Option C — Accessible en normal, ambitieux en expert.**


### 36.2 Quel garde-fou principal ?

- **Option A — Pas plus de X variables visibles par écran**.
- **Option B — Toute mécanique répétitive doit être batchable**.
- **Option C — Toute couche complexe doit être optionnelle ou progressive.**


## Utilisation recommandée

Pour avancer efficacement, chaque question peut maintenant être traitée selon ce format :

1. choisir l’option A, B ou C ;
2. noter pourquoi ce choix est cohérent avec les piliers ;
3. préciser si le choix est **V1**, **V1 simplifié**, ou **futur** ;
4. identifier les dépendances avec d’autres décisions. Les méthodes de décision en préproduction et les approches à base de piliers recommandent justement de comparer des alternatives explicites à l’aide de critères communs pour conserver la cohérence globale du projet[^65_4][^65_5][^65_6]
<span style="display:none">[^65_10][^65_11][^65_12][^65_13][^65_14][^65_15][^65_16][^65_7][^65_8][^65_9]</span>

<div align="center">⁂</div>

[^65_1]: https://ch0m5.github.io/Game-Design-Pillars/

[^65_2]: https://www.gamedeveloper.com/design/design-pillars-the-core-of-your-game

[^65_3]: https://room8studio.com/news/game-pre-production-core-steps/

[^65_4]: https://www.reddit.com/r/gamedesign/comments/1mieyoz/thinking_about_design_pillars_and_the/

[^65_5]: https://www.meegle.com/en_us/topics/decision-matrix/decision-matrix-for-gaming-strategies

[^65_6]: https://home.uevora.pt/~fc/dj/05_elements_of_strategy.pdf

[^65_7]: https://jefflindsey.net/game-dev-phases-may-be-preventing-its-evolution/

[^65_8]: https://polarisgamedesign.com/2024/how-to-design-collective-decision-making-systems/

[^65_9]: https://www.linelab.io/insights/production-simulation-alternatives

[^65_10]: https://pulsegeek.com/articles/choice-architecture-in-game-writing-shaping-player-intent/

[^65_11]: https://www.simio.com/blog/process-simulation-software-vs-traditional-business-modeling

[^65_12]: https://logicsimplified.com/newgames/game-design-and-development-process-pre-to-postproduction/

[^65_13]: https://egrove.olemiss.edu/cgi/viewcontent.cgi?article=1142\&context=mgmtservices

[^65_14]: https://gamifire.eu/how-game-design-mirrors-real-world-decision-making/

[^65_15]: https://arxiv.org/html/2602.12887v1

[^65_16]: http://scholararticles.net/business-process-modelling-and-simulation-advantages-and-disadvantages/


---
