# Agriva GDD — Action Economy
> Capacité quotidienne, ressources/monnaies, scalabilité exploitation, file d'ordres de travail
> Lignes source : 3442–4200

---

# Il faut aussi définir quel va être la capacité par jour du joueur à jouer quel monnaies ou ressources le joueur va utiliser pour faire des actions

Oui — et c’est un point **fondamental**. Pour Agriva, il faut définir à la fois :

1. la **capacité quotidienne de jeu** du joueur, donc combien il peut raisonnablement faire par jour ;
2. les **ressources / monnaies** consommées ou mobilisées pour réaliser les actions ;
3. la manière dont ces ressources limitent, guident ou enrichissent le gameplay sans le rendre artificiel.[^28_1][^28_2][^28_3][^28_4]

## Principe général

Je vous déconseille fortement un système classique de type “énergie mobile” qui bloque arbitrairement le joueur. Dans une simulation agricole, la meilleure limite n’est pas une jauge abstraite, mais un ensemble de contraintes métier crédibles : **temps**, **main-d’œuvre**, **matériel**, **intrants**, **trésorerie** et **fenêtre météo**.[^28_2][^28_5][^28_6]

Autrement dit, le joueur ne doit pas être limité par “il n’a plus 12 points d’énergie”, mais par :

- il n’a plus de créneau machine ;
- il n’a plus assez de semences ;
- son équipe est déjà occupée ;
- il n’a pas la trésorerie ;
- la météo ne permet pas le chantier.

Ça colle beaucoup mieux à votre ambition réaliste.

## Capacité quotidienne du joueur

Je vous propose de distinguer **3 capacités** :

- **Capacité de pilotage** : nombre de décisions / arbitrages qu’un joueur peut prendre dans une session.
- **Capacité opérationnelle** : quantité de travaux réellement réalisables par son exploitation.
- **Capacité d’attention** : quantité d’informations / alertes qu’on lui demande de gérer.

Pour le mode Normal, je viserais une session type de :

- **10 à 20 minutes** en visite rapide ;
- **20 à 40 minutes** en session active ;
- avec **3 à 8 décisions importantes par jour**.

Cela permet un jeu navigateur compatible avec une routine quotidienne, sans obliger le joueur à être présent des heures.[^28_7][^28_8][^28_9]

## Ressources à utiliser

Je vous conseille de structurer l’économie d’action d’Agriva autour de **6 ressources principales** :


| Ressource | Rôle |
| :-- | :-- |
| Temps | Sert à planifier les travaux, les délais et les fenêtres d’action. |
| Main-d’œuvre | Limite humaine réelle des chantiers. |
| Matériel disponible | Conditionne ce qu’on peut lancer. |
| Intrants | Semences, engrais, aliments, carburant, soins, etc. |
| Trésorerie | Permet achats, réparations, investissements, salaires. |
| Capacité logistique / stockage | Conditionne transport, stockage et vente. |

Ce sont exactement les ressources qu’un jeu agricole crédible doit faire circuler entre sources et sinks.[^28_3][^28_6][^28_2]

## Monnaies

Je recommande un système très sobre :

### 1. Monnaie principale

- **Argent** / trésorerie.
- C’est la ressource économique universelle.


### 2. Ressources métier

- semences ;
- carburant ;
- engrais ;
- aliments ;
- paille / fourrage ;
- pièces d’usure / entretien ;
- stockage disponible ;
- éventuellement eau selon ateliers.


### 3. Ressources non monétaires

- **heures machine** ;
- **heures de travail** ;
- **créneaux météo exploitables**.

Ces dernières sont très importantes, car elles servent de monnaies d’action naturelles sans devenir artificielles.[^28_5][^28_6][^28_4][^28_2]

## Ce qu’il ne faut pas faire

Je vous déconseille pour l’instant :

- une monnaie premium liée à l’accélération des chantiers ;
- des points d’énergie globaux ;
- plusieurs monnaies virtuelles opaques ;
- un système mobile-like où chaque clic consomme une ressource abstraite.

Les frameworks d’économie montrent que trop de monnaies et trop de sinks artificiels rendent l’économie difficile à lire et souvent frustrante.[^28_10][^28_11][^28_1][^28_3]

## Capacité d’action par jour

Je poserais cette règle simple pour Agriva Normal :

- un joueur doit pouvoir **prendre autant de décisions qu’il veut** ;
- mais son exploitation ne peut exécuter qu’un certain volume d’actions selon ses ressources.

Donc :

- **pas de limite de clics** ;
- **pas de limite de consultation** ;
- **pas de limite d’arbitrage** ;
- mais une limite sur l’**exécution réelle**.

Exemple :

- il peut planifier 12 chantiers ;
- mais seulement 3 pourront réellement démarrer aujourd’hui ;
- car il n’a qu’un tracteur disponible, 2 opérateurs et une fenêtre météo de 6 heures.

Ça, c’est une vraie action economy agricole.

## Boucle journalière type

En mode Normal, un joueur devrait pouvoir, dans une journée de jeu :

- consulter ses alertes ;
- lancer 1 à 3 gros travaux ;
- réaliser 2 à 5 arbitrages économiques ou logistiques ;
- traiter quelques micro-actions immédiates ;
- préparer les prochains jours.

Le rythme important n’est donc pas “combien d’actions le joueur peut cliquer”, mais “combien d’actions le système peut absorber sans perdre en lisibilité”.[^28_4][^28_8][^28_9]

## Ressource pivot

S’il faut choisir une ressource pivot pour le design, je dirais que ce doit être :

**le temps opérationnel disponible**.

Parce que c’est lui qui fait le lien entre :

- météo ;
- main-d’œuvre ;
- matériel ;
- parcelles ;
- saison ;
- économie.

L’argent seul ne suffit pas. Dans l’agriculture, on peut avoir l’argent et quand même rater une fenêtre critique.

## Modèle recommandé

Je vous propose ce modèle simple pour Agriva Normal :

- **Monnaie principale** : argent.
- **Ressources physiques** : intrants, stocks, carburant, aliments.
- **Ressources opérationnelles** : heures machine, heures de travail, capacité logistique.
- **Ressource contextuelle** : fenêtres météo.
- **Pas d’énergie abstraite**.


## Règle de design

Je poserais cette règle fondatrice :

**Le joueur n’est jamais bloqué pour réfléchir, seulement pour exécuter.**

C’est une règle très forte pour un jeu de simulation, parce qu’elle encourage la stratégie sans frustration artificielle.

## Étape suivante

La suite logique est de formaliser un **modèle d’action economy Agriva**, avec :

- les ressources consommées par type d’action ;
- la capacité quotidienne standard d’une petite exploitation ;
- les coûts / durées / blocages associés.
<span style="display:none">[^28_12][^28_13][^28_14][^28_15][^28_16][^28_17]</span>

<div align="center">⁂</div>

[^28_1]: https://machinations.io/articles/what-is-game-economy-design

[^28_2]: https://kevurugames.com/blog/what-is-video-game-economy-design/

[^28_3]: https://unity.com/how-to/building-game-economy-guide-part-2

[^28_4]: https://www.balangay.games/understanding-an-action-economy-game-part-1-net-action-advantage/

[^28_5]: https://deliberategamedesign.com/resources-loop/

[^28_6]: http://ndl.ethernet.edu.et/bitstream/123456789/27419/1/123.pdf.pdf

[^28_7]: https://docs.devtodev.com/scenarios-and-best-practices/farming-games

[^28_8]: https://beamable.com/blog/the-link-between-backend-design-and-player-retention

[^28_9]: https://pixelfield.co.uk/blog/how-to-design-games-for-retention/

[^28_10]: https://300mind.studio/blog/what-is-game-economy-design/

[^28_11]: https://www.thedylanjones.com/blog/currencies-in-game-economy-loops

[^28_12]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^28_13]: https://www.reddit.com/r/lostarkgame/comments/1ot41rq/simple_thorough_explanation_of_a_game_economy/

[^28_14]: https://pretendo.games/2018/12/30/designing-a-soulslike-action-economy/

[^28_15]: https://airapport.itch.io/farm-and-mine

[^28_16]: http://hackslashmaster.blogspot.com/2024/07/on-solving-action-economy-or-why.html

[^28_17]: https://arcane.org/2026/04/03/action-economy-again/


---

# Oui tout en prenant en compte une logique valable pour un joueur qui va joueur plusieurs année et avoir une grosse exploitation

Oui, il faut absolument penser le système pour **deux échelles de jeu** : la petite ferme du début et la grosse exploitation de plusieurs années. Dans les jeux de gestion et les économies MMO, le vrai risque du mid/late game n’est pas seulement l’inflation, c’est aussi la **surcharge de microgestion**, le fait que le joueur ait trop d’unités à piloter sans nouveaux leviers de décision intéressants.[^29_1][^29_2][^29_3][^29_4]

## Principe directeur

Je vous conseille de faire évoluer le jeu selon cette logique :

- **début de partie** : le joueur gère presque tout à la main ;
- **milieu de partie** : il planifie plus qu’il n’exécute ;
- **fin de partie** : il arbitre, délègue et optimise.

C’est cohérent avec les discussions sur la montée en échelle dans les sims de ferme et les jeux de management, où la croissance saine passe par l’ajout d’**automation, spécialisation et outils de pilotage**, pas simplement par “plus de champs à cliquer”.[^29_5][^29_6][^29_7]

## Modèle de capacité scalable

Il faut donc éviter une capacité fixe du type “3 actions par jour”. À la place, je vous propose une **capacité multi-couches** qui grandit avec l’exploitation :


| Couche | Début de partie | Milieu de partie | Grande exploitation |
| :-- | :-- | :-- | :-- |
| Décisions stratégiques | 3 à 5 / jour | 5 à 8 / jour | 8 à 15 / jour |
| Chantiers simultanés | 1 à 2 | 2 à 4 | 4 à 10+ |
| Main-d’œuvre | faible | moyenne | structurée par équipes |
| Matériel | limité | spécialisé | flotte organisée |
| Automation / délégation | presque nulle | partielle | forte |
| Attention requise | très élevée par parcelle | élevée par atelier | focalisée sur exceptions |

Cette logique rejoint les problèmes classiques du late game dans les jeux de gestion : quand tout grossit, il faut que le joueur pilote des **systèmes** plutôt que des clics unitaires.[^29_2][^29_1]

## Ressources d’action

Je vous recommande de garder les mêmes grandes ressources, mais avec une montée en échelle claire :

- **Argent** : monnaie universelle.[^29_8][^29_9]
- **Temps opérationnel** : créneaux de travaux disponibles.
- **Main-d’œuvre** : ouvriers, chauffeurs, responsables d’atelier.
- **Matériel** : tracteurs, semoirs, moissonneuses, outils.
- **Intrants** : semences, engrais, carburant, aliments.
- **Capacité logistique** : stockage, remorques, transport.
- **Attention managériale** : pas affichée comme monnaie, mais gérée via UI/alertes.

Le point important est que les grosses exploitations ne doivent pas être limitées par une jauge artificielle, mais par la coordination de ces ressources.[^29_4][^29_10][^29_11]

## Ce qui doit scaler

Pour qu’un joueur puisse jouer plusieurs années sans que le jeu s’effondre, certaines choses doivent **augmenter** :

- nombre de chantiers simultanés ;
- taille des équipes ;
- capacité de stockage ;
- profondeur logistique ;
- volume financier ;
- automatisation.

Et certaines choses ne doivent **pas** augmenter proportionnellement :

- nombre d’alertes critiques ;
- nombre de clics nécessaires ;
- nombre d’écrans à visiter ;
- nombre de décisions triviales.

C’est une règle très importante. Sinon le late game devient du travail administratif sans intérêt.[^29_1][^29_2]

## Ce qui doit changer entre early et late game

Je vous propose un modèle en 3 paliers :

### Petite exploitation

- peu de parcelles ;
- peu de matériel ;
- forte implication manuelle ;
- chaque décision compte beaucoup ;
- erreurs coûteuses mais lisibles.


### Exploitation moyenne

- premières équipes ;
- premiers outils de planification ;
- possibilité de lancer des campagnes plus complexes ;
- diversification cultures + élevage.


### Grande exploitation

- gestion par **ateliers** ou **pôles** : grandes cultures, élevage, logistique, commerce ;
- ordres de travail groupés ;
- routage automatique ;
- tableaux de bord, priorités, exceptions ;
- le joueur devient directeur, plus opérateur.

Cette logique ressemble à ce qu’attendent les joueurs des jeux de management à croissance progressive : on ne joue pas pareil au bout de 100 heures qu’au bout de 5 heures.[^29_6][^29_7][^29_5]

## Règle de design pour Agriva

Je vous propose cette règle fondatrice :

**La taille de l’exploitation doit augmenter la complexité stratégique, pas la quantité de micro-actions.**

C’est probablement l’une des règles les plus importantes pour qu’Agriva tienne sur plusieurs années de jeu.

## Modèle concret recommandé

Je formaliserais l’action economy ainsi :

### 1. Pas de limite de clics

Le joueur peut consulter, planifier et décider librement.

### 2. Limite d’exécution réelle

Les travaux dépendent de :

- créneaux météo ;
- disponibilité des équipes ;
- disponibilité du matériel ;
- consommables ;
- trésorerie.


### 3. Déblocage progressif de délégation

À mesure que l’exploitation grandit :

- planification automatique ;
- groupes de parcelles ;
- équipes affectées ;
- templates de campagne ;
- alertes seulement sur anomalies ;
- files d’ordres de travail.


### 4. Coût de coordination

Une grande ferme gagne en capacité, mais paie :

- plus de salaires ;
- plus d’entretien ;
- plus de logistique ;
- plus de risque d’inefficience ;
- plus de besoin de trésorerie.

Ainsi, la croissance n’est pas juste “plus gros = plus facile”.[^29_3][^29_5][^29_4]

## Boucle idéale à long terme

Après plusieurs années, un joueur devrait jouer comme ça :

- il consulte ses tableaux de bord ;
- il valide quelques arbitrages prioritaires ;
- il surveille les goulets d’étranglement ;
- il intervient surtout sur les exceptions ;
- il investit pour améliorer la fluidité.

C’est ce type de boucle qui rend un management game durable.[^29_2][^29_1]

## Ce que je vous conseille maintenant

Il faut passer à une **spec structurée d’action economy scalable**, avec :

- ressources principales ;
- limites d’exécution ;
- capacités selon taille d’exploitation ;
- systèmes de délégation ;
- coûts de coordination ;
- impacts sur cultures, élevage, logistique et marché.[^29_4]

Je peux vous la rédiger maintenant sous forme de **cadre game design complet**, directement exploitable dans votre GDD.
<span style="display:none">[^29_12][^29_13][^29_14][^29_15][^29_16][^29_17][^29_18][^29_19]</span>

<div align="center">⁂</div>

[^29_1]: https://www.reddit.com/r/gamedesign/comments/1rxcvnr/balancing_a_simulationmanagement_game_with/

[^29_2]: https://steamcommunity.com/app/281990/discussions/0/1606022547925333581/?l=italian

[^29_3]: https://www.reddit.com/r/gamedesign/comments/2pyqyn/economy_balancing_in_management_games/

[^29_4]: https://www.reddit.com/r/gamedesign/comments/q86x7d/balancing_mmo_economy_not_just_currency/

[^29_5]: https://steamcommunity.com/app/1248130/discussions/0/4739473745777245854/?l=dutch\&ctp=2

[^29_6]: http://acresgame.com

[^29_7]: https://www.youtube.com/watch?v=sZLNl7MwKMQ

[^29_8]: https://machinations.io/articles/what-is-game-economy-design

[^29_9]: https://www.thedylanjones.com/blog/currencies-in-game-economy-loops

[^29_10]: https://kevurugames.com/blog/what-is-video-game-economy-design/

[^29_11]: https://unity.com/how-to/building-game-economy-guide-part-2

[^29_12]: https://www.reddit.com/r/BaseBuildingGames/comments/1pji0bp/looking_for_a_farming_sim_that_focuses_on/

[^29_13]: https://forum.giants-software.com/viewtopic.php?t=194212

[^29_14]: https://discussions.unity.com/t/economy-design-in-a-single-player-simulation-game/596443

[^29_15]: https://www.galaxus.at/en/page/not-complex-enough-study-criticises-the-farming-simulator-38777

[^29_16]: https://www.reddit.com/r/gamedesign/comments/178te4x/designing_mmo_economies/

[^29_17]: http://faculty.trinity.edu/adelwich/worlds/articles/trinity.sam.kaminski.pdf

[^29_18]: https://www.reddit.com/r/MMORPG/comments/2ms6yf/lf_mmo_sandbox_w_player_driven_economy_farming/

[^29_19]: https://www.reddit.com/r/BaseBuildingGames/comments/uzys1e/games_with_small_start_to_large_scale/


---

# Tu pense que c’est mieux que le joueur attende un certain temps pour une action comme semer ou que que ce soit immédiat tout en consommant les ressources ?

Je pense que **semer ne doit pas être immédiat**. Dans Agriva, la meilleure solution est un modèle **hybride** : la décision du joueur est immédiate, mais l’exécution du chantier prend du temps en jeu et consomme des ressources pendant ce temps. Les réflexions sur les actions temporisées en game design montrent qu’un timer est utile quand il crée de la planification et laisse le joueur faire autre chose, mais devient mauvais s’il ne fait qu’ajouter de l’attente passive.[^30_1][^30_2][^30_3]

## Ce qu’il faut éviter

Si “semer” est totalement instantané :

- vous perdez la sensation de chantier ;
- vous affaiblissez le rôle du matériel, de la main-d’œuvre et des fenêtres météo ;
- vous rendez la montée en taille d’exploitation trop facile à absorber ;
- vous aplatissez la logistique du jeu.

Dans une simulation agricole, semer est justement une action qui a du poids parce qu’elle mobilise des ressources pendant une durée donnée.[^30_4][^30_5][^30_6]

## Modèle recommandé

Je vous conseille de distinguer **3 niveaux d’instantanéité** :

### 1. Immédiat

Pour les actions de **gestion** :

- choisir une culture ;
- acheter des semences ;
- valider un ordre de travail ;
- planifier un chantier ;
- déplacer des priorités.

Ces actions doivent être immédiates, car elles relèvent de la décision.

### 2. Temporisé court

Pour les actions **opérationnelles simples** :

- remplir un semoir ;
- charger une remorque ;
- affecter une équipe ;
- petits transports ou traitements.

Ces actions peuvent durer peu de temps, mais sans immobiliser le joueur.

### 3. Temporisé métier

Pour les **vrais travaux agricoles** :

- semer ;
- récolter ;
- épandre ;
- travailler le sol ;
- transporter en volume.

Ces actions doivent prendre du temps en jeu, car c’est ce qui donne du sens à l’organisation de l’exploitation.[^30_2][^30_3]

## Donc pour “semer”

Je recommanderais ce comportement :

- le joueur clique sur **Semer** ;
- il voit immédiatement le coût, la durée estimée, les ressources mobilisées et la qualité de faisabilité ;
- en confirmant, le chantier démarre **tout de suite** ;
- mais la parcelle ne passe à l’état “semée” qu’à la fin du chantier ;
- pendant ce temps, le tracteur, le semoir, l’équipe et les semences sont mobilisés.

C’est, à mon avis, le meilleur compromis entre jouabilité et crédibilité.[^30_3][^30_1][^30_2]

## Pourquoi c’est meilleur

Ce modèle donne plusieurs avantages :

- il préserve la logique de planification ;
- il crée des arbitrages entre chantiers concurrents ;
- il permet des aléas pendant l’exécution ;
- il fait exister la notion de capacité d’exploitation ;
- il évite l’attente passive, puisque le joueur peut gérer autre chose en parallèle.

Les exemples de systèmes temporisés fonctionnent bien quand le joueur lance un processus puis revient plus tard, au lieu d’être forcé d’attendre devant une barre de progression.[^30_7][^30_2]

## Règle de design simple

Je vous propose cette règle :

**Les décisions sont immédiates, les opérations prennent du temps.**

C’est probablement la règle la plus saine pour tout Agriva :

- immédiat pour penser ;
- temporisé pour produire ;
- jamais d’attente vide.


## Pour le mode Normal

En mode Normal, le temps d’un semis ne doit pas être trop long psychologiquement. Je viserais :

- petite parcelle : chantier court ;
- grande parcelle : chantier plus long ;
- possibilité d’accélérer la capacité non pas par magie, mais par meilleur matériel, équipes plus nombreuses, organisation et délégation.

Ainsi, le joueur ressent la progression de son exploitation sans que l’action devienne pénible.[^30_2][^30_3]

## Ce qu’il ne faut pas faire

Je déconseille :

- semis 100% instantané ;
- semis avec attente forcée devant l’écran ;
- semis avec timer long sans autre chose à faire ;
- consommation de ressources sans immobilisation du matériel.

Ce serait soit trop arcade, soit trop frustrant.

## Recommandation nette

Donc, si je tranche clairement :

- **Semer ne doit pas être instantané**.
- **L’ordre de semis doit être immédiat**.
- **Le chantier de semis doit être temporisé**.
- **Le joueur doit pouvoir continuer à jouer pendant ce temps**.

C’est le meilleur modèle pour supporter à la fois petite ferme, grosse exploitation, économie crédible et planification multi-années.[^30_4][^30_3][^30_2]

Voulez-vous que je formalise maintenant un **modèle précis de durée de chantier**, par exemple comment calculer le temps d’un semis selon surface, matériel, équipe et conditions ?
<span style="display:none">[^30_10][^30_11][^30_12][^30_13][^30_14][^30_15][^30_8][^30_9]</span>

<div align="center">⁂</div>

[^30_1]: https://ultimatepopculture.fandom.com/wiki/Timekeeping_in_games

[^30_2]: https://www.reddit.com/r/gamedesign/comments/b9c0bq/crafting_instant_product_or_timelapsed_production/

[^30_3]: https://en.wikipedia.org/wiki/Time_management_game

[^30_4]: http://ascpro0.ascweb.org/archives/cd/2013/paper/CEUE120002013.pdf

[^30_5]: https://tiij.org/issues/issues/fall2012/abstracts/Z__TIIJ%20fall%202012%20v13%20n1%20(paper%208).pdf

[^30_6]: https://duepublico2.uni-due.de/servlets/MCRFileNodeServlet/duepublico_derivate_00038158/Dissertation_Karl.pdf

[^30_7]: https://www.reddit.com/r/WatcherofRealmsGame/comments/1hyh8ws/how_does_farming_work_in_this_game/

[^30_8]: https://steamcommunity.com/sharedfiles/filedetails/?l=ukrainian\&id=2340596586

[^30_9]: https://steamcommunity.com/sharedfiles/filedetails/?l=greek\&id=2340596586

[^30_10]: https://www.reddit.com/r/RPGdesign/comments/xmxnw1/time_based_action_economy/

[^30_11]: https://www.reddit.com/r/RPGdesign/comments/kvigd1/modes_of_play_how_do_you_handle_ingame_time/

[^30_12]: https://ultimatepopculture.fandom.com/wiki/Turns,_rounds_and_time-keeping_systems_in_games

[^30_13]: https://www.reddit.com/r/harvestmoon/comments/1q7pdf7/what_would_you_think_about_a_farming_time_game/

[^30_14]: https://www.wikiwand.com/en/articles/Time-keeping_systems_in_games

[^30_15]: https://peer.asee.org/design-of-a-construction-simulation-educational-game-through-a-cognitive-lens.pdf


---

# Ok je ne sais pas trop le temps que les actions prendrais car si un joueur veut faire 2 action de suite sur parcelle il doit se connecter plusieurs ou perdre un jour qu’en pense tu ?

Je pense qu’il ne faut **ni obliger le joueur à se reconnecter pour chaque sous-action**, ni rendre tout instantané. La meilleure solution est un système de **file d’ordres de travail** sur la parcelle : le joueur peut enchaîner 2 ou 3 actions compatibles à l’avance, et l’exploitation les exécute automatiquement dans l’ordre si les dépendances restent valides. Les systèmes asynchrones et de task queues sont justement faits pour ça, et les workflows de travaux agricoles suivent naturellement une séquence ordonnée sur une même parcelle.[^31_1][^31_2][^31_3][^31_4][^31_5][^31_6]

## Mon avis net

Pour Agriva, je ferais ceci :

- **les actions importantes prennent du temps** ;
- **le joueur peut les mettre en file** ;
- **il n’a pas besoin d’être connecté à chaque étape** ;
- **mais il ne peut pas chaîner n’importe quoi sans contrôle**.

C’est ce qui évite à la fois la frustration du “reviens plus tard pour cliquer à nouveau” et la dérive arcade du “je fais toute ma campagne en 2 secondes”.[^31_2][^31_3][^31_1]

## Règle pratique

Sur une parcelle, un joueur devrait pouvoir faire :

- préparer ;
- semer ;
- rouler ;
- éventuellement fertiliser de base ;

dans une **même séquence planifiée**, à condition que :

- les ressources soient disponibles ;
- le matériel soit affecté ;
- l’ordre soit logique ;
- la météo ne casse pas la chaîne ;
- aucune opération précédente ne bloque la suivante.

Les guides d’ordre de travaux de champ montrent bien que ces actions ont un enchaînement logique, ce qui se prête très bien à une exécution séquentielle.[^31_7][^31_8][^31_9]

## Ce qu’il faut éviter

Si vous obligez le joueur à revenir après chaque micro-étape :

- il va perdre un jour juste pour cliquer ;
- il va ressentir de la friction inutile ;
- la grande exploitation deviendra pénible à gérer ;
- l’UX sera trop dépendante de la présence constante.

À l’inverse, si tout s’exécute instantanément, vous perdez toute la valeur de l’organisation.

## Le bon compromis

Je vous recommande un modèle en **3 couches** :

### 1. Actions de gestion immédiates

- choisir culture ;
- acheter intrants ;
- planifier chantier ;
- ordonnancer les tâches.


### 2. Travaux temporisés

- travail du sol ;
- semis ;
- fertilisation ;
- récolte ;
- transport.


### 3. File d’enchaînement

Le joueur peut dire par exemple :

1. préparer la parcelle ;
2. semer le blé ;
3. rouler juste après.

Le système exécute ces tâches dans l’ordre dès que possible. C’est probablement la mécanique la plus saine pour un browser game agricole persistant.[^31_3][^31_6][^31_2]

## Comment gérer les blocages

La file ne doit pas être “magique”. Chaque tâche suivante doit rester :

- **confirmée** si les prérequis sont garantis ;
- ou **conditionnelle** si elle dépend d’un résultat précédent ou de la météo.

Exemple :

- “Préparer le sol” = confirmé.
- “Semer blé après préparation” = confirmé si semences réservées.
- “Rouler après semis” = conditionnel si pas de pluie entre-temps.

Ainsi, le joueur peut planifier sans que le jeu devienne absurde.[^31_5][^31_1][^31_3]

## Impact sur le quotidien du joueur

Avec ce système, un joueur peut se connecter une fois par jour et :

- consulter ses alertes ;
- créer 2 à 10 files de travail ;
- lancer ses arbitrages ;
- corriger uniquement les exceptions.

C’est beaucoup plus compatible avec une exploitation qui grossit sur plusieurs années, parce que le joueur pilote des séquences plutôt que des clics isolés.[^31_10][^31_6][^31_1]

## Recommandation de durée

Donc pour répondre directement à votre inquiétude :

- **non**, le joueur ne doit pas perdre un jour juste parce qu’il faut cliquer deux fois ;
- **oui**, deux actions de suite sur une parcelle doivent être possibles ;
- **mais** via une file d’ordres temporisés, pas via exécution instantanée totale.


## Règle de design

Je poserais cette règle :

**Un clic doit pouvoir lancer une séquence de travail, pas seulement une micro-action.**

C’est très important pour la qualité de vie du jeu.

## Ce que je ferais concrètement

Pour le mode Normal :

- file simple de **3 actions max** par parcelle au début ;
- plus tard, avec une exploitation plus grande, déblocage de files plus riches ou de templates ;
- affichage très clair : en attente, en cours, bloqué, terminé ;
- notifications seulement en cas de problème ou de fin de séquence.

La prochaine brique logique est de définir précisément le **système de work orders / files d’actions**, avec :

- ce qui peut être chaîné ;
- ce qui ne peut pas l’être ;
- ce qui consomme les ressources à la réservation et à l’exécution.
<span style="display:none">[^31_11][^31_12][^31_13][^31_14][^31_15]</span>

<div align="center">⁂</div>

[^31_1]: https://www.gamedeveloper.com/game-platforms/analysis-asynchronicity-in-game-design

[^31_2]: https://blog.blasphemess.com/python-celery-task-queue-for-my-browser-game/

[^31_3]: https://www.reddit.com/r/gamedev/comments/18b0ro/how_do_timebased_actions_in_browserbased_games/

[^31_4]: https://gameprogrammingpatterns.com/event-queue.html

[^31_5]: https://docs.temporal.io/task-queue

[^31_6]: https://www.farming-simulator.com/newsArticle.php?news_id=313

[^31_7]: https://www.reddit.com/r/farmingsimulator25/comments/1gt7qmr/field_work_order/

[^31_8]: https://www.gamepressure.com/farming-simulator-22/order-of-fieldwork/z0f253

[^31_9]: https://www.gamepressure.com/farming-simulator-25/order-of-field-work/ze116ae

[^31_10]: https://www.reddit.com/r/gamedesign/comments/ysmv2d/asynchronous_multiplayer_interaction/

[^31_11]: https://www.reddit.com/r/Unity3D/comments/p1a4a8/networkingmultiplayer_solution_for_asynchronous/

[^31_12]: https://discussions.unity.com/t/best-way-to-have-queued-move-actions-for-up-to-10-players-executing-simultaneously/855151

[^31_13]: https://learn.microsoft.com/en-us/gaming/gdk/docs/features/common/async/async-task-queue-design?view=gdk-2510

[^31_14]: https://gpuopen.com/learn/concurrent-execution-asynchronous-queues/

[^31_15]: https://stackoverflow.com/questions/76396621/asynchronous-python-how-to-handle-multiple-job-submissions-and-queue-them-while


---
