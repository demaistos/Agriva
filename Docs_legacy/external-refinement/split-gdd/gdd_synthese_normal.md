# Agriva GDD — Synthèse Mode Normal
> Document consolidé : tous les principes du mode Normal, règles de design, workflows
> Lignes source : 4201–4647

---

# Agriva — Synthèse game design mode Normal

## Objet du document

Ce document synthétise les décisions de game design prises pour **Agriva**, un jeu de simulation agricole par navigateur, en se concentrant sur le **mode Normal**. Il sert de base de travail pour une équipe d’agents IA chargée de concevoir les spécifications détaillées, l’architecture métier et les workflows du jeu.

L’objectif est de poser un cadre cohérent pour :

- la temporalité du monde ;
- les cultures ;
- l’élevage ;
- l’économie d’action ;
- la montée en échelle d’une exploitation ;
- les workflows métier, en particulier l’action **semer**.

Les références utilisées montrent qu’un farming game moderne doit équilibrer réalisme, lisibilité, rétention, économie de jeu et charge mentale du joueur, avec une temporalité compressée mais crédible et des workflows planifiables plutôt qu’une micro-gestion permanente.[^32_1][^32_2][^32_3][^32_4][^32_5]

## Vision produit

Agriva vise une simulation agricole **plus moderne, plus lisible et plus scalable** qu’un jeu comme SimAgri, tout en gardant un vrai socle métier. Les décisions ne doivent pas être simplifiées au point de devenir arcade, mais la complexité doit être principalement portée par le moteur et les workflows plutôt que par des interfaces opaques ou des clics répétés.[^32_6][^32_7][^32_8]

Le mode Normal doit permettre au joueur de comprendre rapidement ce qu’il peut faire, pourquoi une action est bloquée, ce qu’il lui manque et ce qui va se passer ensuite. Le jeu doit être jouable en sessions courtes, avec une progression perceptible sur quelques jours réels et une exploitation qui peut grandir sur plusieurs années sans devenir un enfer de micro-gestion.[^32_2][^32_9][^32_10][^32_11]

## Principes de design retenus

Les principes suivants structurent le mode Normal :

- Une culture n’est pas un bouton “semer puis attendre”, mais un **plan vivant d’opérations sous contraintes**.[^32_7][^32_12][^32_13]
- Les **décisions** sont immédiates, mais les **opérations** prennent du temps.[^32_14][^32_15]
- Le joueur n’est jamais bloqué pour réfléchir ; il est seulement limité pour exécuter, selon ses ressources réelles d’exploitation.[^32_16][^32_17][^32_18]
- La taille de l’exploitation doit augmenter la **complexité stratégique**, pas le nombre de clics ou de micro-actions.[^32_11][^32_19][^32_20]
- Une action visible peut cacher de nombreuses vérifications, mais le joueur doit toujours comprendre simplement pourquoi elle est possible, risquée ou impossible.[^32_8][^32_21][^32_7]
- Un clic doit pouvoir lancer une **séquence de travail**, pas seulement une micro-action isolée.[^32_22][^32_23][^32_24]


## Temporalité du monde

La temporalité retenue pour Agriva Normal est la suivante :

- **1 mois de jeu = 5 jours réels**.
- **1 saison = 3 mois de jeu = 15 jours réels**.
- **1 année de jeu = 12 mois = 60 jours réels**.

Cette base est un compromis entre lisibilité, économie de jeu et profondeur. Elle est plus rapide que SimAgri, dont la logique historique est d’environ une année de jeu en 12 semaines réelles, mais elle n’accélère pas au point d’écraser la valeur des saisons, de l’élevage ou des décisions de campagne.[^32_25][^32_26][^32_27][^32_28][^32_6]

### Justification

Cette temporalité a été retenue pour plusieurs raisons :

- elle permet une progression sensible dans un horizon de temps compatible avec un jeu navigateur persistant ;
- elle laisse assez de temps aux cultures et aux animaux pour exister économiquement ;
- elle garde des repères calendaires simples ;
- elle facilite les boucles économiques régulières, ce qui est important pour la rétention et la sensation de progression.[^32_3][^32_4][^32_5][^32_29][^32_2]


## Calendrier annuel du mode Normal

Le calendrier annuel est structuré sur 12 mois de jeu, avec une logique tempérée inspirée des séquences agricoles classiques et des calendriers simplifiés des farming sims.[^32_30][^32_31][^32_32]


| Mois | Rôle principal |
| :-- | :-- |
| Septembre à novembre | Semis des cultures d’hiver |
| Décembre | Entretien et fin de fenêtre d’hiver |
| Janvier à mars | Semis des cultures de printemps |
| Avril à juillet | Récoltes des cultures d’hiver et premières récoltes |
| Août | Préparation du retour à l’automne |

Des cultures comme le blé, l’orge ou le colza suivent une logique de semis automnal et de récolte printanière ou estivale. Les cultures de printemps comme maïs, soja ou tournesol occupent une fenêtre plus courte et plus dynamique.[^32_31][^32_32][^32_33][^32_34]

## Logique culturale en mode Normal

Chaque culture doit être décrite par une fiche de conduite simplifiée, compréhensible rapidement et exploitable sans expertise technique approfondie. La structure recommandée est la suivante :

1. Choix de la culture.
2. Vérification de faisabilité.
3. Préparation de la parcelle.
4. Semis ou plantation.
5. Entretien et surveillance.
6. Récolte.
7. Logistique post-récolte.
8. Vente ou stockage.
9. Bilan de campagne.

Cette structure reprend les grandes séquences culturales utilisées dans les modèles agronomiques simplifiés et dans les guides de farming games, tout en restant adaptée à un mode Normal orienté accessibilité.[^32_12][^32_33][^32_35][^32_36][^32_7]

### Exemple de philosophie pour le blé

Le blé a servi de culture de référence pour le design. Dans Agriva Normal, il ne doit pas durer aussi longtemps qu’un cycle complet de SimAgri, où la logique observée correspond globalement à un blé d’hiver semé à l’automne et récolté l’été suivant, soit environ 8 à 9 mois de jeu.[^32_37][^32_38][^32_6]

Dans Agriva, une culture longue comme le blé doit rester structurante sans bloquer l’économie pendant trop longtemps. Avec la temporalité retenue, le blé peut devenir une culture longue du mode Normal, mais toujours dans une durée compatible avec une boucle économique visible sur quelques semaines réelles.[^32_2][^32_3][^32_25]

## Élevage et temporalité commune

La même temporalité doit être valable pour les cultures et pour l’élevage. Il ne faut pas avoir un calendrier pour les cultures et une logique totalement séparée pour les animaux, sinon l’économie devient incohérente.[^32_5][^32_39][^32_40]

Le mois de jeu est l’unité pivot recommandée pour les deux systèmes :

- les cultures évoluent par **stades mensuels** ;
- les animaux évoluent par **états mensuels** ;
- l’économie suit des flux quotidiens avec des bilans mensuels ;
- les événements importants, croissance, reproduction, mise bas, montée en production, sont intégrés dans le même cadre temporel.[^32_41][^32_42][^32_43][^32_44][^32_5]

L’élevage doit produire des retours économiques plus fréquents que certaines cultures longues. Des ateliers comme les volailles ou le lait peuvent donner une production régulière, tandis que les bovins viande ou certaines reproductions servent davantage de placements de moyen terme.[^32_42][^32_43][^32_44]

## Action economy et ressources

Le jeu ne doit pas utiliser une jauge d’“énergie” abstraite comme dans certains jeux mobiles. La bonne limitation pour une simulation agricole est une limitation **métier** : temps, matériel, personnel, stocks, météo, trésorerie et logistique.[^32_17][^32_18][^32_45][^32_16]

### Ressources principales

Les ressources recommandées sont :

- **Argent / trésorerie** : monnaie principale de tout le jeu.[^32_46][^32_16]
- **Temps opérationnel** : créneaux de travail disponibles dans les bonnes conditions.[^32_47][^32_48]
- **Main-d’œuvre** : ouvriers, chauffeurs, équipes, responsables d’atelier.[^32_21][^32_48]
- **Matériel** : tracteurs, semoirs, moissonneuses, outils, véhicules.[^32_49][^32_47]
- **Intrants** : semences, engrais, carburant, aliments, soins, etc.[^32_50][^32_21]
- **Capacité logistique** : stockage, remorques, transport, silos.[^32_48][^32_21]
- **Fenêtres météo** : disponibilité contextuelle des chantiers.[^32_51][^32_52]


### Principe de capacité quotidienne

La bonne logique n’est pas de limiter le nombre de clics ou de décisions, mais de limiter la **capacité réelle d’exécution**. Un joueur peut réfléchir, consulter et planifier autant qu’il veut, mais son exploitation ne peut exécuter qu’un certain nombre de chantiers selon ses ressources disponibles.[^32_18][^32_53][^32_17]

Ainsi, une petite ferme peut n’exécuter qu’un petit nombre de travaux simultanés, tandis qu’une grosse exploitation avec plusieurs équipes, machines et réserves logistiques peut en exécuter beaucoup plus.[^32_19][^32_20][^32_11]

## Montée en échelle de l’exploitation

Le système doit être valable pour un joueur débutant comme pour un joueur jouant depuis plusieurs années avec une très grande exploitation. Le vrai défi du mid/late game n’est pas seulement l’argent, mais la **charge de coordination** et la micro-gestion.[^32_20][^32_11][^32_19]

### Trois phases de jeu

#### Petite exploitation

- peu de parcelles ;
- peu de matériel ;
- faible spécialisation ;
- implication manuelle forte ;
- chaque décision a un poids important.[^32_54][^32_55]


#### Exploitation moyenne

- premières équipes ;
- premières spécialisations ;
- diversité plus marquée entre cultures et élevage ;
- début d’automatisation et de planification structurée.[^32_55][^32_56][^32_57]


#### Grande exploitation

- gestion par ateliers ou pôles ;
- files d’ordres de travail ;
- délégation ;
- tableaux de bord ;
- focalisation sur les arbitrages et les exceptions plutôt que sur chaque action unitaire.[^32_11][^32_19][^32_20]


### Règle de design associée

La règle centrale retenue est :

> La taille de l’exploitation doit augmenter la complexité stratégique, pas la quantité de micro-actions.

Cette règle est structurante pour toute l’architecture gameplay et UI du projet.[^32_19][^32_20][^32_11]

## Décisions immédiates et opérations temporisées

Une distinction forte a été retenue entre les **décisions** et les **opérations**.

### Les décisions sont immédiates

Exemples :

- choisir une culture ;
- acheter des intrants ;
- valider un plan ;
- affecter une équipe ;
- ordonnancer des tâches.[^32_15][^32_14]


### Les opérations prennent du temps

Exemples :

- préparer le sol ;
- semer ;
- fertiliser ;
- récolter ;
- transporter de gros volumes.[^32_58][^32_59][^32_14]

Cette distinction permet de garder la sensation de chantier et de capacité d’exploitation sans forcer le joueur à attendre passivement devant l’écran.[^32_14][^32_15]

## File d’ordres de travail

Pour éviter qu’un joueur doive se reconnecter ou cliquer après chaque micro-opération sur une parcelle, le jeu doit intégrer une **file d’ordres de travail**. Le joueur peut alors planifier une séquence logique de travaux sur une même parcelle, et l’exploitation les exécute dans l’ordre si les conditions restent valides.[^32_23][^32_24][^32_60][^32_22]

### Exemple de séquence chaînable

Sur une parcelle, le joueur doit pouvoir, dans certaines limites, enchaîner :

1. préparation du sol ;
2. semis ;
3. roulage ;
4. fertilisation de base.

Chaque étape peut être :

- **confirmée**, si les prérequis sont garantis ;
- **conditionnelle**, si elle dépend de la météo, d’un résultat ou d’une disponibilité ultérieure.[^32_61][^32_62][^32_63][^32_64]


### Règle de design associée

> Un clic doit pouvoir lancer une séquence de travail, pas seulement une micro-action.

Cette règle est particulièrement importante pour rendre la gestion d’une grosse exploitation supportable.[^32_24][^32_65][^32_22]

## Workflow complet de l’action “Semer”

L’action **semer** a été définie comme un workflow métier end-to-end avec validations, réservations, exécution et effets aval. Ce workflow ne doit pas être traité comme une simple action instantanée.[^32_66][^32_7][^32_8][^32_47][^32_51]

### Étapes du workflow

1. Le joueur exprime l’intention de semer une culture sur une parcelle.
2. Le système vérifie la compatibilité du calendrier cultural.
3. Le système vérifie l’état de la parcelle.
4. Le système vérifie la rotation simplifiée.
5. Le système vérifie l’état du sol et la praticabilité.
6. Le système vérifie la météo et la fenêtre de semis.
7. Le système vérifie les semences disponibles ou achetables.
8. Le système vérifie le matériel et la compatibilité machine/outils.
9. Le système vérifie la main-d’œuvre disponible.
10. Le système estime durée, coût et risques.
11. Le système détecte les dépendances amont manquantes.
12. Le système propose un plan ou affiche les blocages.
13. Le joueur valide maintenant ou planifie.
14. Les ressources sont réservées.
15. Un ordre de travail est créé.
16. Le chantier s’exécute dans le temps.
17. Des aléas éventuels peuvent suspendre ou recalculer le chantier.
18. En fin de chantier, la parcelle passe à l’état semé.
19. Une instance de culture est créée avec son potentiel initial.
20. Les coûts, l’usure et les consommations sont enregistrés.
21. Les étapes aval sont programmées.
22. Le joueur reçoit un feedback clair sur le résultat.[^32_7][^32_8][^32_21][^32_47][^32_51][^32_66]

### Philosophie UX du workflow

Le mode Normal ne doit pas afficher toute la complexité interne. Il doit surtout afficher :

- si le semis est possible ;
- ce qui manque ;
- les risques ;
- le temps estimé ;
- le coût estimé ;
- la prochaine étape recommandée.

La complexité reste dans le moteur ; l’interface expose une lecture simple et exploitable.[^32_8][^32_21][^32_7]

## Règles de design consolidées

Les règles suivantes ont émergé comme fondations du mode Normal :

- **Une culture = un plan vivant d’opérations sous contraintes**.[^32_13][^32_12][^32_7]
- **Les décisions sont immédiates, les opérations prennent du temps**.[^32_15][^32_14]
- **Le joueur n’est jamais bloqué pour réfléchir, seulement pour exécuter**.[^32_16][^32_17][^32_18]
- **Une action visible peut cacher de nombreuses vérifications, mais la raison doit toujours être claire pour le joueur**.[^32_21][^32_7][^32_8]
- **Un clic doit pouvoir lancer une séquence de travail**.[^32_22][^32_23][^32_24]
- **La taille de l’exploitation doit augmenter la complexité stratégique, pas la quantité de micro-actions**.[^32_20][^32_11][^32_19]
- **Le mois de jeu est l’unité pivot des cultures, de l’élevage et des bilans économiques**.[^32_44][^32_5][^32_41]


## Conséquences techniques pour une équipe d’agents IA

Une équipe d’agents IA qui développe Agriva doit considérer que le projet repose sur plusieurs sous-domaines métier forts :

- **Calendrier et temporalité** ;
- **Parcelles et état du sol** ;
- **Cultures et stades** ;
- **Élevage et états animaux** ;
- **Matériel et compatibilité** ;
- **Main-d’œuvre et planning** ;
- **Stocks et intrants** ;
- **Ordres de travail et files d’exécution** ;
- **Économie et comptabilité d’exploitation** ;
- **Alertes, recommandations et UX mode Normal**.[^32_17][^32_8][^32_16][^32_21]

Chaque agent doit raisonner non seulement en termes d’objets et d’écrans, mais aussi en termes de **préconditions**, **consommations**, **effets**, **événements déclenchés**, **états intermédiaires** et **chaînes de dépendances**.[^32_60][^32_67][^32_8]

## Priorités de spécification à écrire ensuite

Les prochaines spécifications à produire sont les suivantes :

1. modèle global de l’action economy ;
2. système de work orders et de files d’actions ;
3. catalogue des ressources et consommations ;
4. workflow formel de **récolter** ;
5. fiche détaillée des premières cultures ;
6. modèle des ateliers animaux ;
7. modèle de montée en échelle de l’exploitation ;
8. architecture métier événementielle ;
9. règles de feedback et d’assistance du mode Normal.

Ces briques sont les prochaines étapes logiques pour passer du cadrage au design système exploitable en production.[^32_5][^32_7][^32_8][^32_20]

<div align="center">⁂</div>

[^32_1]: https://www.farming-simulator.com/newsArticle.php?lang=fr\&country=fr\&news_id=245

[^32_2]: https://pixelfield.co.uk/blog/how-to-design-games-for-retention/

[^32_3]: https://learninghub.athena.studio/post/balancing-game-economy-for-long-term-retention-in-free-to-play-games

[^32_4]: https://mobilefreetoplay.com/bible/building-lasting-free-play-economy/

[^32_5]: https://www.fao.org/4/x5528e/x5528e03.htm

[^32_6]: https://www.simagri.com/regle_simagri.php?id=3\&hide=

[^32_7]: https://www.logineko.com/knowledge/enhancing-field-operation-planning-with-cultivation-templates/

[^32_8]: https://www.tandfonline.com/doi/full/10.1080/09540091.2022.2083078

[^32_9]: https://beamable.com/blog/the-link-between-backend-design-and-player-retention

[^32_10]: https://docs.devtodev.com/scenarios-and-best-practices/farming-games

[^32_11]: https://www.reddit.com/r/gamedesign/comments/1rxcvnr/balancing_a_simulationmanagement_game_with/

[^32_12]: https://vtechworks.lib.vt.edu/server/api/core/bitstreams/65709072-179b-4808-8ee5-16a9e21e964c/content

[^32_13]: https://users.aalto.fi/~ttoksane/pub/2010_ICPA2010.pdf

[^32_14]: https://www.reddit.com/r/gamedesign/comments/b9c0bq/crafting_instant_product_or_timelapsed_production/

[^32_15]: https://en.wikipedia.org/wiki/Time_management_game

[^32_16]: https://machinations.io/articles/what-is-game-economy-design

[^32_17]: https://kevurugames.com/blog/what-is-video-game-economy-design/

[^32_18]: https://www.balangay.games/understanding-an-action-economy-game-part-1-net-action-advantage/

[^32_19]: https://steamcommunity.com/app/281990/discussions/0/1606022547925333581/?l=italian

[^32_20]: https://www.reddit.com/r/gamedesign/comments/q86x7d/balancing_mmo_economy_not_just_currency/

[^32_21]: https://www.meegle.com/en_us/topics/workflow-role/agricultural-managers

[^32_22]: https://www.gamedeveloper.com/game-platforms/analysis-asynchronicity-in-game-design

[^32_23]: https://blog.blasphemess.com/python-celery-task-queue-for-my-browser-game/

[^32_24]: https://www.reddit.com/r/gamedev/comments/18b0ro/how_do_timebased_actions_in_browserbased_games/

[^32_25]: https://cursa.app/en/article/game-development-core-loops-designing-progression-systems-players-actually-stick-with

[^32_26]: https://thedesignlab.blog/2026/04/13/the-compression-problem-in-modern-game-design/

[^32_27]: https://www.reddit.com/r/farmingsimulator25/comments/1mgmwsa/what_is_recommended_for_days_per_month_and_time/

[^32_28]: https://steamcommunity.com/app/1248130/discussions/0/3203744999894666620/

[^32_29]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^32_30]: https://www.thegamer.com/farming-simulator-25-seasonal-farming-every-crop-month/

[^32_31]: https://hardcoregamer.com/farming-simulator-25-complete-crop-guide/

[^32_32]: https://teknonel.com/fs22-all-fruit-and-seed-calendar/

[^32_33]: https://www.farming-simulator.com/newsArticle.php?news_id=298

[^32_34]: https://www.farming-simulator.com/newsArticle.php?news_id=619

[^32_35]: https://www.apsim.info/clem/Content/Features/Activities/Crop/ManagingCropping.htm

[^32_36]: https://livefarmer.co.uk/the-7-steps-in-the-modern-farming-lifecycle/

[^32_37]: https://www.simagri.com/bulletins/bulletin_agricole_simagri_octobre_saison9.pdf

[^32_38]: https://www.vivescia.com/grand-angle/tous/cereale-quel-est-le-cycle-du-ble

[^32_39]: https://www.reddit.com/r/farmingsimulator/comments/1kw7l44/is_crop_growth_and_livestock_production_based_on/

[^32_40]: https://agromixproject.eu/knowledge/dynamix-a-serious-game-to-design-scenarios-of-exchange-of-animal-or-crop-co-roducts-between-farmers/

[^32_41]: https://www.youtube.com/watch?v=mjNvSyV6wnE

[^32_42]: https://www.ign.com/wikis/farming-simulator-22/How_to_Manage_Animals_-_Storing,_Feeding,_and_Breeding_Guide

[^32_43]: https://fs17.lt/enhanced-animal-system-v-2-2-1-1/

[^32_44]: https://www.farming-simulator.com/mod.php?mod_id=259964

[^32_45]: https://unity.com/how-to/building-game-economy-guide-part-2

[^32_46]: https://www.thedylanjones.com/blog/currencies-in-game-economy-loops

[^32_47]: https://era.ed.ac.uk/handle/1842/34007

[^32_48]: https://www.ufs.ac.za/docs/librariesprovider22/agricultural-economics-documents/agri-management-documents/all-documents/mechanisation-and-labour-guidelines-1547-eng.pdf?sfvrsn=bc2ff921_0

[^32_49]: https://pub.epsilon.slu.se/553/1/Agraria_462.pdf

[^32_50]: https://www.agrivi.com/blog/field-management-farming-facts-every-grower-should-know/

[^32_51]: https://bbro.co.uk/media/50683/22-advisory-bulletin-no-2.pdf

[^32_52]: https://www.vaderstad.com/ca-en/know-how/farming-practises/direct-seeding

[^32_53]: https://www.reddit.com/r/gamedesign/comments/2pyqyn/economy_balancing_in_management_games/

[^32_54]: https://forum.giants-software.com/viewtopic.php?t=194212

[^32_55]: http://acresgame.com

[^32_56]: https://steamcommunity.com/app/1248130/discussions/0/4739473745777245854/?l=dutch\&ctp=2

[^32_57]: https://www.youtube.com/watch?v=sZLNl7MwKMQ

[^32_58]: http://ascpro0.ascweb.org/archives/cd/2013/paper/CEUE120002013.pdf

[^32_59]: https://duepublico2.uni-due.de/servlets/MCRFileNodeServlet/duepublico_derivate_00038158/Dissertation_Karl.pdf

[^32_60]: https://docs.temporal.io/task-queue

[^32_61]: https://www.reddit.com/r/farmingsimulator25/comments/1gt7qmr/field_work_order/

[^32_62]: https://www.gamepressure.com/farming-simulator-22/order-of-fieldwork/z0f253

[^32_63]: https://www.gamepressure.com/farming-simulator-25/order-of-field-work/ze116ae

[^32_64]: https://www.farming-simulator.com/newsArticle.php?news_id=313

[^32_65]: https://www.reddit.com/r/gamedesign/comments/ysmv2d/asynchronous_multiplayer_interaction/

[^32_66]: https://nationalagro.com/blog/the-complete-guide-to-using-a-seed-drill-correctly

[^32_67]: https://gameprogrammingpatterns.com/event-queue.html


---
