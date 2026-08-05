# Agriva GDD — Farming — Temporalité (débat)
> Itérations sur la temporalité, comparaison SimAgri, raisonnement économique, options rejetées

---


Non, vous ne devez surtout pas utiliser l’échelle réelle. Pour un jeu navigateur multijoueur, il faut une temporalité **compressée mais crédible**, avec un monde persistant, des actions rapides à jouer et des saisons assez courtes pour que les joueurs voient des résultats réguliers. Les références de farming sims montrent d’ailleurs que les joueurs ajustent souvent l’échelle du temps, les jours par saison et l’accélération pour garder un bon rythme de jeu.[^18_1][^18_2][^18_3]

## Principe

Je vous conseille de séparer **trois temps différents** :

- le temps des **actions** ;
- le temps de la **croissance** ;
- le temps de la **saison serveur**.

Cette séparation est importante, car dans les browser games et les jeux persistants, le temps utile n’est pas forcément le même pour un chantier, une culture ou une campagne complète.[^18_4][^18_5]

## Proposition Agriva

Je vous propose une temporalité de base comme celle-ci pour le **mode Normal** :

- **1 jour de jeu = 1 jour réel**.
- **1 mois de jeu = 6 jours réels**.
- **1 saison de jeu = 18 jours réels**.
- **1 année de jeu = 72 jours réels**, soit un peu plus de 2 mois.

Cette structure garde les 4 saisons, permet une vraie planification, et reste assez courte pour que le joueur voie plusieurs campagnes dans l’année réelle. Farming Simulator utilise aussi une logique de mois/saisons compressés, avec un nombre de jours configurable par mois, ce qui montre bien que la compression du calendrier est une pratique naturelle dans ce genre.[^18_6][^18_2][^18_7]

## Pourquoi ça marche

Cette échelle donne un bon compromis :

- assez longue pour qu’une culture ait du poids ;
- assez courte pour que la progression ne paraisse pas bloquée ;
- assez régulière pour faire vivre un serveur multijoueur.

Les discussions de joueurs sur les saisons montrent justement qu’ils cherchent un équilibre entre réalisme, quantité de travail disponible et vitesse de progression, souvent en jouant sur les jours par mois ou la vitesse du temps.[^18_8][^18_3][^18_1]

## Échelle des actions

Ensuite, à l’intérieur de ce calendrier, les actions doivent être compressées différemment :

- action simple, achat, planification, vente : **immédiate** ;
- chantier léger, fertiliser, traiter, transporter : **quelques minutes à quelques heures de jeu** ;
- chantier lourd, semis, récolte, gros transport : **plusieurs heures à 1 jour de jeu** ;
- croissance d’une culture : **plusieurs jours ou semaines de jeu**.

Pour un browser game, cela se combine très bien avec une logique de progression persistante, où le serveur fait avancer les timers même quand le joueur n’est pas connecté.[^18_9][^18_5][^18_4]

## Variante plus dynamique

Si vous voulez un rythme encore plus accessible, vous pouvez aussi partir sur :

- **1 saison = 14 jours réels** ;
- **1 année = 56 jours réels**.

Ce format est plus nerveux et probablement meilleur pour un lancement, car il réduit le temps d’attente psychologique entre deux récoltes ou deux bilans de campagne. Les joueurs de farming sims aiment voir le résultat de leurs décisions, et trop allonger les saisons peut donner une impression de stagnation.[^18_3][^18_10][^18_1]

## Ma recommandation finale

Pour Agriva Normal, je partirais sur :

- **1 saison = 14 jours réels**.
- **1 année = 56 jours réels**.
- **1 jour de jeu = 1 jour réel**, mais avec des actions internes compressées et un serveur qui continue à tourner.

C’est, à mon avis, le meilleur point de départ :

- assez réaliste pour une simulation agricole ;
- assez rapide pour un jeu navigateur ;
- assez lisible pour un public large ;
- assez persistant pour du multijoueur.


## Conséquence design

Avec cette temporalité, une culture comme le blé ne prendrait pas “8 mois réels”, mais par exemple :

- semis en début de fenêtre ;
- croissance sur une partie significative de la saison ;
- récolte en fin de cycle saisonnier.

Autrement dit, vous gardez la logique agricole, mais vous remappez les durées à l’échelle du jeu. C’est exactement ce qu’il faut faire pour rester crédible sans devenir pénible.[^18_2][^18_7][^18_6]

La suite logique est de définir maintenant **un calendrier de jeu exact**, avec :

- longueur des saisons ;
- nombre de phases par saison ;
- durée type des cultures en mode Normal ;
- temps moyen des travaux.
<span style="display:none">[^18_11][^18_12][^18_13][^18_14]</span>

<div align="center">⁂</div>

[^18_1]: https://www.reddit.com/r/farmingsimulator/comments/f1ot7a/recommended_timescale_for_seasons/

[^18_2]: https://www.farming-simulator.com/newsArticle.php?lang=fr\&country=fr\&news_id=245

[^18_3]: https://steamcommunity.com/app/1248130/discussions/0/3820780544814106493/

[^18_4]: https://www.reddit.com/r/gamedesign/comments/dygc1y/how_to_scale_timeprogression_in_farm_games/

[^18_5]: https://www.gamedeveloper.com/game-platforms/reacting-to-the-passage-of-time-in-browser-games

[^18_6]: https://www.farming-simulator.com/newsArticle.php?news_id=289

[^18_7]: https://www.farming-simulator.com/newsArticle.php?lang=en\&country=si\&news_id=289

[^18_8]: https://steamcommunity.com/app/1248130/discussions/0/3203744999894666620/?l=tchinese

[^18_9]: https://www.reddit.com/r/playmygame/comments/1rgbu6b/i_built_a_cozy_multiplayer_farming_game_you_can/

[^18_10]: https://www.reddit.com/r/CozyGamers/comments/1ar6gqy/what_is_your_ideal_season_and_day_length_for_cozy/

[^18_11]: https://forum.giants-software.com/viewtopic.php?t=204368

[^18_12]: https://forum.giants-software.com/viewtopic.php?t=132045

[^18_13]: https://www.farming-simulator.com/newsArticle.php?lang=pl\&country=pl\&news_id=284

[^18_14]: https://www.autonomicagame.com


---

# Pourquoi 1 mois n’est pas 7 jour c’est plus simple à comprendre non ?

Oui, **7 jours par mois est plus simple à comprendre**. C’est même un très bon argument de design : un calendrier compressé doit être immédiatement lisible, et des blocs de 7 jours collent naturellement à l’intuition des joueurs parce qu’ils pensent déjà en semaines.[^19_1][^19_2][^19_3]

## Pourquoi j’avais proposé 6

J’avais surtout cherché un compromis de rythme pour garder une année un peu plus courte. Mais en pratique, si un calendrier oblige le joueur à “recalculer mentalement” ou à retenir une logique arbitraire, il perd en clarté, et la simplicité de lecture vaut souvent plus que l’optimisation théorique du rythme.[^19_4][^19_1]

## Pourquoi 7 est meilleur

Avec **1 mois = 7 jours**, vous obtenez plusieurs avantages :

- chaque mois devient une mini-semaine lisible ;
- chaque saison peut se découper facilement ;
- les joueurs comprennent vite les échéances ;
- l’interface du planning devient beaucoup plus intuitive.

Les discussions autour des calendriers de jeu montrent justement qu’il faut éviter les systèmes trop exotiques ou irréguliers, car ils augmentent inutilement la charge mentale.[^19_2][^19_4][^19_1]

## Proposition révisée

Je vous conseillerais donc plutôt :

- **1 mois de jeu = 7 jours réels**.
- **1 saison = 3 mois = 21 jours réels**.
- **1 année = 4 saisons = 84 jours réels**.

C’est plus long que ma proposition précédente, mais beaucoup plus naturel à lire. Et 84 jours pour une année de jeu reste tout à fait raisonnable pour un MMO navigateur persistant.[^19_5][^19_6][^19_7]

## Lecture gameplay

Avec ce modèle :

- une culture courte peut durer 1 à 2 mois de jeu ;
- une culture plus longue peut traverser plusieurs mois ;
- le joueur a un repère hebdomadaire très clair ;
- le planning serveur devient plus compréhensible.

Autrement dit, vous gagnez en **ergonomie mentale**. Dans un jeu de gestion, c’est souvent plus important qu’une compression maximale du temps.[^19_8][^19_2][^19_5]

## Mon avis

Donc oui, je pense que **7 jours par mois est une meilleure base** pour Agriva Normal. Je choisirais même ça comme règle de calendrier principale, sauf si vos premiers tests montrent que 21 jours par saison paraît trop long.

## Règle proposée

Je poserais donc :

- 1 mois = 7 jours.
- 1 saison = 21 jours.
- 1 année = 84 jours.

Et ensuite, à l’intérieur de ça, les travaux et la croissance restent compressés par des timers et des états de progression. C’est ce qui permet de garder à la fois la lisibilité du calendrier et le rythme du jeu.[^19_3][^19_9][^19_2]

La suite logique est de définir maintenant **combien de mois dure chaque culture en mode Normal**, avec ce nouveau calendrier à 7 jours.
<span style="display:none">[^19_10][^19_11][^19_12][^19_13][^19_14][^19_15][^19_16][^19_17]</span>

<div align="center">⁂</div>

[^19_1]: https://www.youtube.com/watch?v=ic8DgT2K0n4

[^19_2]: https://forums.unrealengine.com/t/in-game-date-time-calendar-system/50092

[^19_3]: https://forum.gdevelop.io/t/make-a-functional-calendar-system-solved/45230

[^19_4]: https://www.reddit.com/r/worldbuilding/comments/1kr79xz/is_it_worth_to_get_noodly_with_calenders_naming/

[^19_5]: https://www.reddit.com/r/farmingsimulator/comments/1q5udlz/time_settings/

[^19_6]: https://www.facebook.com/groups/1095542580815422/posts/2337664609936540/

[^19_7]: https://www.farming-simulator.com/newsArticle.php?lang=fr\&country=fr\&news_id=245

[^19_8]: https://steamcommunity.com/app/1248130/discussions/0/3820780544814106493/

[^19_9]: https://www.gamedeveloper.com/game-platforms/reacting-to-the-passage-of-time-in-browser-games

[^19_10]: https://www.gamedeveloper.com/design/7-tips-to-7-day-game-jams

[^19_11]: https://www.greyhawkgrognard.com/2011/07/22/on-calendars/

[^19_12]: https://www.facebook.com/groups/589650256573251/posts/755651473306461/

[^19_13]: https://brandonthegamedev.com/how-to-master-time-so-you-can-make-games/

[^19_14]: https://www.youtube.com/watch?v=cYqiJEuw2vU

[^19_15]: https://steamcommunity.com/app/1248130/discussions/0/3820780544814106493/?l=schinese

[^19_16]: https://www.reddit.com/r/worldbuilding/comments/1e935t3/working_on_a_calendar_should_i_add_a_dayoff/

[^19_17]: https://reikakalseki.github.io/projects/calendar.html


---

# Oui

Oui. Avec un calendrier de **7 jours par mois**, on peut maintenant définir une durée de culture simple et cohérente pour le mode Normal, en s’inspirant des repères saisonniers des farming sims tout en les compressant pour garder un bon rythme de jeu.[^20_1][^20_2][^20_3]

## Principe de conversion

Les références de Farming Simulator donnent des durées de croissance en **mois de jeu**, par exemple environ 10 mois pour le blé, 9 pour l’orge, 11 pour le colza et 4 pour l’avoine. Pour Agriva Normal, je vous conseille de **reprendre cette logique relative**, mais en lissant un peu les écarts pour éviter que certaines cultures deviennent trop longues sur un serveur navigateur.[^20_4][^20_5][^20_2][^20_3][^20_1]

## Proposition Agriva Normal

Avec **1 mois = 7 jours réels**, je vous proposerais une première table de durées comme celle-ci :


| Culture | Durée de jeu | Durée réelle | Lecture simple |
| :-- | --: | --: | :-- |
| Blé | 8 mois | 56 jours | Culture longue mais standard |
| Orge | 7 mois | 49 jours | Un peu plus rapide que le blé |
| Colza | 9 mois | 63 jours | Culture lente, plutôt stratégique |
| Avoine | 4 mois | 28 jours | Culture rapide |
| Sorgho | 5 mois | 35 jours | Culture intermédiaire |
| Maïs | 6 mois | 42 jours | Culture moyenne à longue |
| Tournesol | 6 mois | 42 jours | Intermédiaire |
| Soja | 5 mois | 35 jours | Culture moyenne |
| Herbe | 2 mois par coupe | 14 jours | Très dynamique |
| Radis fourrager / couvert | 2 mois | 14 jours | Technique / rotation |

## Pourquoi raccourcir un peu

Si vous gardez des durées trop proches de certaines références comme **10 à 11 mois**, cela donne 70 à 77 jours réels pour une seule culture, ce qui commence à être long pour un mode Normal sur navigateur. Je pense donc qu’il vaut mieux conserver la hiérarchie relative entre cultures, mais réduire légèrement les durées longues pour que le joueur voie des résultats plus souvent sans casser la logique agricole.[^20_5][^20_6][^20_7][^20_1]

## Bonne règle de design

Je vous recommande cette règle simple pour Agriva Normal :

- culture **courte** : 2 à 4 mois ;
- culture **moyenne** : 5 à 6 mois ;
- culture **longue** : 7 à 9 mois.

Avec cette règle, un joueur comprend tout de suite la temporalité d’une culture sans devoir mémoriser des chiffres complexes. Cela rend aussi le design plus robuste quand vous ajouterez beaucoup de cultures.[^20_8][^20_9]

## Pour le blé

Si on reprend votre fiche actuelle du blé en mode Normal, je fixerais :

- **semis** sur une fenêtre de 1 à 2 mois de jeu ;
- **croissance totale** d’environ 8 mois ;
- **récolte** sur une fenêtre de 1 mois ;
- donc **56 jours réels** entre implantation et récolte si tout se passe normalement.

C’est encore une culture “engageante”, mais pas trop lente pour un joueur navigateur.[^20_10][^20_11][^20_12]

## Mon avis pratique

Je pense que cette grille est une bonne base de départ pour les tests :

- elle reste lisible ;
- elle garde la sensation saisonnière ;
- elle permet plusieurs décisions importantes par saison ;
- elle évite l’effet “j’ai semé et je reviens dans 3 mois IRL”.


## Prochaine étape

Le meilleur enchaînement est de construire maintenant le **calendrier annuel Agriva Normal**, mois par mois, avec :

- ce qu’on peut semer ;
- ce qu’on peut récolter ;
- ce qu’on peut entretenir ;
- et les durées de culture associées.
<span style="display:none">[^20_13][^20_14][^20_15][^20_16][^20_17][^20_18][^20_19][^20_20]</span>

<div align="center">⁂</div>

[^20_1]: https://www.ign.com/wikis/farming-simulator-22/List_of_Crops

[^20_2]: https://teknonel.com/fs22-all-fruit-and-seed-calendar/

[^20_3]: https://farmingsimulator.fandom.com/wiki/Crop_Comparison/Farming_Simulator_22

[^20_4]: https://hardcoregamer.com/farming-simulator-25-complete-crop-guide/

[^20_5]: https://www.thegamer.com/farming-simulator-25-seasonal-farming-every-crop-month/

[^20_6]: https://www.reddit.com/r/gamedesign/comments/dygc1y/how_to_scale_timeprogression_in_farm_games/

[^20_7]: https://forum.giants-software.com/viewtopic.php?t=189716

[^20_8]: https://www.youtube.com/watch?v=ic8DgT2K0n4

[^20_9]: https://forums.unrealengine.com/t/in-game-date-time-calendar-system/50092

[^20_10]: https://www.farming-simulator.com/newsArticle.php?news_id=619

[^20_11]: https://www.cropler.io/blog-posts/wheat-growth-stages-and-associated-management

[^20_12]: https://www.hylandhybridseeds.com/en/blog/wheat-crop-duration-guide/

[^20_13]: https://www.facebook.com/DjGoHamGaming/posts/fs25-crop-growth-calendar-for-those-not-using-seasonal-cycles/1094021532722914/

[^20_14]: https://www.reddit.com/r/farmingsimulator/comments/t6vi3p/growing_time_for_each_crop/

[^20_15]: https://www.farming-simulator.com/newsArticle.php?news_id=298

[^20_16]: https://steamcommunity.com/app/678900/discussions/0/1633040337762454021/

[^20_17]: https://forum.giants-software.com/viewtopic.php?t=181387

[^20_18]: https://www.reddit.com/r/cataclysmdda/comments/aeykt4/default_season_length_made_farming_useless/

[^20_19]: https://farmingsimulator.fandom.com/wiki/Seasons/Farming_Simulator_22

[^20_20]: https://forum.giants-software.com/viewtopic.php?t=129471


---

# Ça ne reste pas trop long ? Il faut pensé à l’économie du jeu aussi

Oui, je pense que **ça reste un peu trop long** pour le mode Normal si on raisonne en économie de jeu, rétention et fréquence de récompense. Dans les jeux persistants et F2P, il faut modéliser le temps en fonction du comportement réel des joueurs, avec des retours réguliers, des objectifs atteignables et des récompenses perceptibles assez souvent pour maintenir l’engagement.[^21_1][^21_2][^21_3][^21_4]

## Pourquoi c’est trop long

Si une culture “standard” prend 56 jours réels, vous créez plusieurs risques :

- le joueur ressent trop peu de payoff ;
- la trésorerie tourne trop lentement ;
- les erreurs coûtent trop cher en temps réel ;
- le début de jeu paraît vide ou bloqué.

Les analyses sur la rétention insistent justement sur le fait qu’il faut récompenser la persistance à un rythme visible, surtout dans les jeux joués par petites sessions répétées.[^21_5][^21_2][^21_3][^21_1]

## Bonne logique économique

Pour un jeu navigateur avec économie partagée, il faut qu’un joueur puisse :

- récolter quelque chose assez vite ;
- vendre ou réinvestir régulièrement ;
- sentir une progression sur quelques jours ;
- ne pas attendre un mois réel pour voir si sa stratégie fonctionne.

Les frameworks d’économie de jeu recommandent de concevoir le temps autour des jalons de progression et des boucles de retour, pas autour d’une reproduction trop fidèle du réel.[^21_6][^21_3][^21_4]

## Ce que je recommande

Je pense qu’il faut **raccourcir nettement le mode Normal**. Je vous proposerais plutôt :

- **1 mois = 4 jours réels**.
- **1 saison = 3 mois = 12 jours réels**.
- **1 année = 48 jours réels**.

Ça reste très simple à comprendre, et c’est beaucoup plus sain économiquement. Vous gardez une structure lisible par semaines-ish, mais vous accélérez suffisamment les retours pour que le marché, la trésorerie et les objectifs tournent à un bon rythme.[^21_7][^21_3][^21_8]

## Nouvelle grille cultures

Avec cette base, on obtient quelque chose de plus jouable :


| Type de culture | Durée en mois | Durée réelle |
| :-- | --: | --: |
| Très courte | 1 à 2 mois | 4 à 8 jours |
| Courte | 2 à 3 mois | 8 à 12 jours |
| Moyenne | 3 à 4 mois | 12 à 16 jours |
| Longue | 5 à 6 mois | 20 à 24 jours |

Là, l’économie commence à respirer : un joueur peut récolter, vendre, corriger sa stratégie et réinvestir plusieurs fois dans une même saison de serveur. C’est beaucoup plus compatible avec un jeu persistant grand public.[^21_9][^21_2][^21_3][^21_10]

## Conséquence pour le blé

Du coup, pour le **blé en mode Normal**, je ne le mettrais plus à 8 mois. Je le placerais plutôt à :

- **4 mois de jeu** ;
- donc **16 jours réels**.

C’est déjà assez long pour que la culture “compte”, mais assez court pour ne pas casser le rythme du serveur. Pour une culture rapide, on pourrait descendre à 2 mois, soit 8 jours réels.[^21_3][^21_7]

## Mon avis net

Donc oui : **56 jours est trop long pour le mode Normal**. Si vous pensez aussi à l’économie du jeu, à la rétention et au plaisir de progression, il faut des cycles plus courts, surtout au lancement.

Je vous recommande de repartir sur cette base :

- 1 mois = 4 jours réels.
- 1 saison = 12 jours réels.
- 1 année = 48 jours réels.
- culture standard = 3 à 4 mois, soit 12 à 16 jours réels.


## Règle de design

Je poserais cette règle pour Agriva Normal :

**Le joueur doit ressentir un résultat économique significatif au minimum toutes les 48 à 72 heures.**

C’est probablement la meilleure boussole pour équilibrer vos cultures, vos contrats et votre marché.[^21_2][^21_1][^21_3]

La suite logique est de **recalculer tout le calendrier des cultures Normal** avec cette nouvelle base plus rapide.
<span style="display:none">[^21_11][^21_12][^21_13][^21_14][^21_15][^21_16]</span>

<div align="center">⁂</div>

[^21_1]: https://pixelfield.co.uk/blog/how-to-design-games-for-retention/

[^21_2]: https://learninghub.athena.studio/post/balancing-game-economy-for-long-term-retention-in-free-to-play-games

[^21_3]: https://texpine.com/media/files/Balancing Free-to-Play Economies.pdf

[^21_4]: https://mobilefreetoplay.com/bible/building-lasting-free-play-economy/

[^21_5]: https://beamable.com/blog/the-link-between-backend-design-and-player-retention

[^21_6]: https://gamedevessentials.com/a-7-step-framework-for-game-economy-design/

[^21_7]: https://www.reddit.com/r/gamedesign/comments/dygc1y/how_to_scale_timeprogression_in_farm_games/

[^21_8]: https://www.gamedeveloper.com/game-platforms/reacting-to-the-passage-of-time-in-browser-games

[^21_9]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^21_10]: https://machinations.io/articles/game-economy-design-free-to-play-games

[^21_11]: https://www.binance.com/en/square/post/316741678869042

[^21_12]: https://machinations.io/articles/balancing-f2p-economies-simulating-player-personas-and-progression-curves-with-machinations

[^21_13]: https://mobilefreetoplay.com/obsessing-retention-metrics-risks-killing-game/

[^21_14]: https://www.reddit.com/r/harvestmoon/comments/1q7pdf7/what_would_you_think_about_a_farming_time_game/

[^21_15]: https://www.youtube.com/watch?v=50hHJ5pCxgA

[^21_16]: https://www.binance.com/en/square/post/316806827618610


---

# La temporarilite va devoir être utilisé pour l’élevage aussi

Oui, et c’est exactement pour ça qu’il faut définir une **temporalité unifiée du monde**, pas juste un calendrier pour les cultures. Dans Agriva, la même échelle de temps doit servir aux cultures, à l’élevage, aux travaux, à l’économie et à la reproduction, sinon le jeu devient incohérent ou impossible à équilibrer.[^22_1][^22_2][^22_3]

## Point clé

L’élevage supporte généralement **encore moins bien** des durées trop longues que les cultures, parce que le joueur attend des retours plus réguliers : production, reproduction, croissance, ventes, soins, alimentation. Les références autour des systèmes animaux dans Farming Simulator montrent que la production et la reproduction sont suivies en cycles mensuels ou quasi mensuels, avec des états comme âge, puberté, reproduction, naissance, lactation et productivité.[^22_4][^22_5][^22_6][^22_7]

## Conséquence design

Donc la bonne question n’est plus seulement “combien dure une culture ?”, mais :

- combien dure un **cycle de culture** ;
- combien dure un **cycle animal** ;
- combien de temps met un joueur à voir un **retour économique** ;
- et est-ce que ces rythmes cohabitent bien dans la même économie.

Les modèles dynamiques de troupeau travaillent justement avec des transitions mensuelles d’état, ce qui est un bon indice pour le design d’un jeu de gestion agricole : le mois de jeu est une unité très pratique pour faire évoluer à la fois cultures et animaux.[^22_1]

## Bonne règle pour Agriva

Je vous recommande donc de garder une temporalité qui fonctionne pour les deux mondes :

- culture = progression par stades mensuels ;
- élevage = progression par états mensuels ;
- économie = flux quotidiens et bilans mensuels ;
- serveur = saisons assez courtes pour générer de la rotation.

Cela renforce l’idée qu’**un mois de jeu doit être l’unité pivot** du système.[^22_2][^22_1]

## Mon avis sur la bonne échelle

Pour que ça marche à la fois pour cultures et élevage, je pense que votre meilleure base devient :

- **1 mois de jeu = 4 jours réels**.
- **1 saison = 3 mois = 12 jours réels**.
- **1 année = 48 jours réels**.

Pourquoi ? Parce que :

- une culture courte peut durer 1 à 2 mois, donc 4 à 8 jours ;
- une culture moyenne 3 à 4 mois, donc 12 à 16 jours ;
- un événement animal important, mise bas, montée en production, sevrage, croissance, peut arriver toutes les 1 à 3 semaines de temps réel selon l’espèce ;
- l’économie du joueur bouge régulièrement.

Cette cadence est bien plus exploitable qu’un système où une gestation ou une croissance animale durerait trop longtemps en temps réel.[^22_5][^22_6][^22_7][^22_4]

## Traduction élevage