# Agriva GDD — Economy — Bot & Marché Joueur
> Économie hybride, rôle du bot, marché joueur, coopérative départementale, filtres, anti-arbitrage

---

# Vois tu d’autre chose à statuer ? Pour l’économie le joueur doit pouvoir acheter et vendre à des joueurs et au bot du jeu car au début rien de sera disponible

Oui, il y a encore plusieurs choses importantes à **statuer**, et pour l’économie votre idée me paraît bonne : au lancement, le joueur doit pouvoir acheter et vendre à la fois à d’autres joueurs et à des bots/NPC du jeu, sinon le marché risque d’être vide, illiquide et frustrant pour les nouveaux joueurs. Les analyses d’économie de jeu insistent sur l’importance des sources et puits de ressources, ainsi que sur la nécessité de maintenir de la liquidité et des débouchés minimaux, surtout au démarrage d’une économie partagée.[^54_1][^54_2][^54_3]

## Économie de base

Je pense que vous devez acter ce principe :

**Agriva doit avoir une économie hybride : marché joueur à joueur + marché bot de secours.**

Le marché joueur à joueur crée la vie économique, la spéculation, les opportunités et la spécialisation, tandis que le marché bot garantit qu’un joueur peut toujours démarrer, vendre une production de base et acheter des intrants essentiels même si l’offre humaine est encore faible.[^54_4][^54_5][^54_6]

## Comment je le ferais

Je ne ferais pas des bots qui remplacent les joueurs, mais des bots qui :

- assurent une offre minimale ;
- assurent une demande minimale ;
- empêchent les pénuries absurdes au lancement ;
- servent de filet de sécurité permanent ;
- retirent ou injectent de la monnaie de manière contrôlée.

Les bots peuvent aussi servir d’outil d’équilibrage macroéconomique, parce qu’un marché purement entre joueurs recycle surtout la monnaie existante, alors qu’une économie saine a besoin de points d’entrée et de sortie clairs pour éviter inflation, pénuries ou blocages.[^54_7][^54_8][^54_1]

## Règles de marché à statuer

Je vous conseille de trancher rapidement ces points :


| Sujet | Décision à prendre |
| :-- | :-- |
| Biens échangeables | Tout ou seulement certaines catégories ? |
| Prix bot | fixes, semi-dynamiques, ou indexés au marché ? |
| Quantités bot | illimitées ou plafonnées ? |
| Zones de marché | marché global, régional ou local ? |
| Frais | taxe, commission, coût logistique ? |
| Qualité | produit standard ou niveaux de qualité ? |
| Temps | vente instantanée ou ordres différés ? |
| Stockage | local, régional, silo, entrepôt ? |

## Ma recommandation précise

Pour une V1, je partirais sur :

- **achats bot possibles** pour les intrants de base ;
- **ventes bot possibles** pour les produits de base ;
- **prix bot moins bons** que les meilleurs échanges entre joueurs ;
- **marché joueur plus avantageux**, mais moins garanti ;
- **taxes ou frais** pour éviter les abus ;
- **quantités bot encadrées** sur certains produits sensibles.

Ainsi, le bot garantit la jouabilité, mais le vrai intérêt économique reste du côté du commerce entre joueurs.

## Autres sujets à statuer

Au-delà de ça, oui, je vois plusieurs autres décisions de fond à fixer maintenant :

### 1. Portée du marché

Marché national unique, régional, départemental, ou hybride.
Ce choix changera beaucoup la sensation de territoire et la profondeur logistique.

### 2. Nature des prix

Prix fixes, dynamiques, saisonniers, ou influencés par l’offre et la demande.
C’est un pilier majeur d’un jeu de gestion.

### 3. Degré de transformation

Est-ce qu’on vend du blé brut seulement, ou aussi farine, aliments du bétail, bois scié, etc.
Cela détermine la profondeur industrielle.

### 4. Rôle des coopératives

Simple canal de vente bot-like, ou véritable structure intermédiaire avec avantages et contraintes.

### 5. Risques économiques

Volatilité, pénurie, surproduction, coût du crédit, contrats non tenus.
Ces risques créent la tension de gestion, mais doivent rester lisibles.

## Ma lecture design

Votre idée “joueur + bot” est particulièrement bonne parce qu’elle résout trois problèmes d’un coup :

- démarrage d’un serveur ;
- confort des nouveaux joueurs ;
- stabilité minimale de l’économie.

Beaucoup de retours sur les économies de jeux montrent que le manque de liquidité sur les produits de base casse l’intégration des nouveaux joueurs, car ils ne peuvent ni acheter ce qu’il leur faut ni vendre facilement ce qu’ils produisent.[^54_3][^54_4]

## Règle que je poserais

Je formulerais la règle ainsi :

**Le marché joueur doit être le meilleur marché, mais le marché bot doit garantir que le jeu reste jouable à tout moment.**

## Ce que je trancherais maintenant

Si vous voulez avancer proprement, je fixerais en priorité :

- économie hybride joueur + bot ;
- liste des biens échangeables ;
- logique de prix bot ;
- échelle géographique du marché ;
- frais et taxes ;
- niveau de transformation des produits ;
- rôle des coopératives ;
- logique de stockage.

C’est un très bon moment pour le faire, parce que ces décisions vont structurer une grande partie du game design économique ensuite.[^54_2][^54_6][^54_1]
<span style="display:none">[^54_10][^54_11][^54_12][^54_13][^54_14][^54_15][^54_9]</span>

<div align="center">⁂</div>

[^54_1]: https://machinations.io/articles/what-is-game-economy-design

[^54_2]: https://blakeir.com/sinks-faucets-lessons-on-designing-effective-virtual-game-economies

[^54_3]: https://com.prosperousuniverse.com/t/improving-liquidity-is-key-to-an-economy/4544

[^54_4]: https://www.reddit.com/r/gamedev/comments/6gk1hy/game_economies_player_markets_and_npc_markets_and/

[^54_5]: http://absinthe.tuxfamily.net/moneta/documents/LARC-2010-03.pdf

[^54_6]: https://300mind.studio/blog/what-is-game-economy-design/

[^54_7]: https://www.reddit.com/r/lostarkgame/comments/1ot41rq/simple_thorough_explanation_of_a_game_economy/

[^54_8]: https://www.youtube.com/watch?v=IqxVwvNEp68

[^54_9]: https://gamedevessentials.com/designing-a-game-economy-101-the-ultimate-guide-for-game-devs/

[^54_10]: https://kevurugames.com/blog/what-is-video-game-economy-design/

[^54_11]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^54_12]: https://mortalonline2.com/forums/threads/npc-bidding-auctions-to-counter-inevitable-gold-inflation.2395/

[^54_13]: https://machinations.io/articles/game-economy-design-free-to-play-games

[^54_14]: https://rowyn.livejournal.com/263909.html

[^54_15]: https://www.linkedin.com/posts/klaus-rubba_building-a-game-economy-is-a-process-of-defining-activity-7346960632660860928-0DMW


---

# Je te laisse y réfléchir et statuer

Oui. À ce stade, je statuerais sur les grands principes maintenant, puis je laisserais les chiffres fins pour plus tard. Pour l’économie, le bon choix est bien une économie **hybride** avec marché joueurs + marché bot, car cela garantit la jouabilité au lancement, crée de la liquidité minimale et évite qu’un nouveau joueur se retrouve bloqué faute d’offre ou de demande.[^55_1][^55_2][^55_3]

## Décisions à figer

Je figerais tout de suite ces 8 décisions de design :


| Sujet | Décision proposée |
| :-- | :-- |
| Type d’économie | Hybride : joueurs + bot |
| Portée du marché | Régional avec secours national |
| Prix bot | Fourchette plancher/plafond |
| Liquidité initiale | Bot présent dès le lancement |
| Produits concernés | Intrants et produits de base garantis |
| Produits avancés | Priorité au marché joueur |
| Frais | Taxe légère sur échanges joueurs |
| Stockage/logistique | Coût et délai réels mais simplifiés |

## Ma proposition pour Agriva

Je partirais sur ce cadre :

- le joueur peut **toujours** vendre ses productions de base au bot ;
- le joueur peut **toujours** acheter au bot les intrants de base ;
- le commerce entre joueurs doit être **plus intéressant** financièrement ;
- le bot ne doit pas écraser le marché joueur, seulement le sécuriser.

Les travaux sur les économies virtuelles montrent qu’un filet de sécurité par NPC ou market maker améliore la liquidité, tandis que des bornes de prix peuvent empêcher qu’un bien essentiel devienne absurde à l’achat ou invendable à la vente.[^55_2][^55_4][^55_1]

## Comment je structurerais le marché

Je recommande une architecture en 3 couches :

### 1. Marché bot garanti

Pour :

- semences de base ;
- aliments de base ;
- engrais génériques ;
- carburant ;
- animaux d’entrée ;
- vente des récoltes standard.


### 2. Marché joueur principal

Pour :

- meilleurs prix ;
- gros volumes ;
- arbitrage ;
- spécialisation ;
- achats opportunistes.


### 3. Produits avancés ou premium

Plutôt orientés marché joueur :

- produits de qualité ;
- transformation ;
- génétique ;
- matériel rare ;
- contrats spécifiques.

Ainsi, la base du jeu est toujours jouable, mais la vraie richesse économique vient du commerce entre joueurs.

## Prix et garde-fous

Je statuerais aussi sur une règle très claire :

**Le bot achète à un prix plancher et vend à un prix plafond.**

C’est probablement le meilleur compromis.
Cela crée :

- un minimum de valeur pour les biens essentiels ;
- un maximum de prix acceptable pour les biens indispensables ;
- un espace au milieu où le marché joueur peut vivre.

Cette logique de floor/ceiling price est souvent utilisée ou discutée pour stabiliser les biens critiques et protéger les nouveaux joueurs contre les marchés cassés.[^55_4][^55_5][^55_2]

## Portée géographique

Je ne ferais pas un marché 100% mondial dès le départ.
Je ferais plutôt :

- marché **régional** pour donner du sens au territoire ;
- possibilité de commerce plus large via logistique ou intermédiaires ;
- bot régional ou semi-national pour éviter les zones mortes.

Cela aide à garder l’identité France / région / bassin, sans créer des impasses économiques.

## Ce qu’il faut absolument éviter

Je n’irais pas vers :

- un marché purement joueur au lancement ;
- des bots à prix trop avantageux ;
- une infinité d’articles échangeables dès la V1 ;
- une économie sans taxes, coûts ou sinks ;
- une absence totale de bornes sur les biens essentiels.

Les sources sur les faucets/sinks et la stabilité des économies rappellent qu’il faut surveiller monnaie, prix, points d’entrée/sortie et comportement des joueurs en continu, sinon l’inflation, la déflation ou l’illiquidité finissent par casser l’expérience.[^55_6][^55_7][^55_8]

## Autres points à statuer

Oui, je vois encore d’autres choses à trancher maintenant, en plus de l’économie :

- **monnaie unique ou non** ;
- **crédit / dette / découvert** ;
- **contrats à terme ou non** ;
- **coopératives comme acteurs du marché** ;
- **qualité des produits** ;
- **saisonnalité des prix** ;
- **coûts de transport** ;
- **temps de vente instantané ou différé** ;
- **marché local vs national** ;
- **niveau de spéculation autorisé**.


## Mes arbitrages recommandés

Si je dois vraiment statuer, voici ma position :

- monnaie unique ;
- économie hybride joueurs + bot ;
- bot pour produits de base uniquement ;
- floor/ceiling price sur les biens essentiels ;
- commerce joueur plus rentable que le bot ;
- marché régional avec extension logistique ;
- taxe légère sur transactions ;
- stockage et transport simplifiés mais existants ;
- produits avancés surtout orientés joueur à joueur ;
- pas de spéculation trop abstraite en V1.


## Règle fondatrice

Je poserais cette règle :

**L’économie doit être vivante grâce aux joueurs, mais jamais dépendante d’eux pour rester jouable.**

C’est, selon moi, la bonne base pour Agriva.

## Ce que je considère désormais comme statué

Si vous me laissez trancher, je considère donc comme base de design :

- économie hybride ;
- bot de sécurité permanent ;
- marché joueur favorisé ;
- bornes de prix sur biens essentiels ;
- marché régional prioritaire ;
- produits de base garantis ;
- produits avancés davantage laissés au marché joueur ;
- coûts et taxes légers pour réguler.

L’autre gros sujet qu’il faudrait statuer ensuite, c’est probablement **la structure de progression économique de l’exploitation** : comment on passe d’une petite ferme de départ à une exploitation plus diversifiée, mécanisée et compétitive sans transformer la croissance en inflation de clics.
<span style="display:none">[^55_10][^55_11][^55_12][^55_13][^55_14][^55_15][^55_16][^55_9]</span>

<div align="center">⁂</div>

[^55_1]: https://aaltodoc.aalto.fi/server/api/core/bitstreams/8ffd4078-668f-4bb0-89f2-f897309e1375/content

[^55_2]: https://www.gamedeveloper.com/design/the-f-words-of-mmos-faucets

[^55_3]: https://com.prosperousuniverse.com/t/market-makers-and-game-health/2030

[^55_4]: https://www.gamedev.net/forums/topic/582659-mmo-rts-trade-system/4718293/?page=3

[^55_5]: https://forums.mabinogi.nexon.net/discussion/22534/a-way-to-fix-inflation

[^55_6]: https://alts.co/the-fundamentals-of-game-economy-design-from-basics-to-advanced-strategies/

[^55_7]: https://alterdata.com/blog/what-drives-monetization-in-mobile-games-a-data-driven-guide-to-optimizing-game-economy/

[^55_8]: https://blakeir.com/sinks-faucets-lessons-on-designing-effective-virtual-game-economies

[^55_9]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^55_10]: https://gamedevessentials.com/a-7-step-framework-for-game-economy-design/

[^55_11]: https://unity.com/how-to/design-balanced-in-game-economy-guide-part-3

[^55_12]: https://aaltodoc.aalto.fi/bitstreams/8ffd4078-668f-4bb0-89f2-f897309e1375/download

[^55_13]: https://www.reddit.com/r/lostarkgame/comments/1ot41rq/simple_thorough_explanation_of_a_game_economy/

[^55_14]: https://devforum.roblox.com/t/how-to-design-the-ideal-in-game-economy/238862

[^55_15]: http://habitatchronicles.com/2004/10/kidtrade-a-design-for-an-ebay-resistant-virtual-economy/

[^55_16]: https://playtank.io/2025/08/12/game-economy-design/


---

# Pour mon la coopérative du bot doit être dans la capital du département pour ne pas forcer le joueur à faire trop de trajet comme en réalité et un marché national entre joueur on pourra appliquer des filtrer pour faciliter les recherche etc.

Oui, je pense que c’est une **très bonne direction**. Une coopérative bot placée dans la capitale du département comme point central de collecte a du sens gameplay et logistique, car les hubs centralisés et les réseaux coopératifs réduisent les trajets inutiles, mutualisent les flux et améliorent l’efficacité de distribution.[^56_1][^56_2][^56_3]

## Coopérative bot

Je statuerais donc comme ceci :

**Chaque département possède une coopérative bot située dans sa préfecture ou capitale départementale.**

C’est une bonne abstraction, parce qu’elle :

- donne un point de repère clair ;
- évite au joueur des trajets absurdes ;
- reste crédible par rapport à une logique de collecte centralisée ;
- simplifie fortement l’économie et la logistique.

Les modèles de hubs agricoles et de coopératives montrent justement qu’un centre de regroupement réduit les coûts et les déplacements dispersés en consolidant les flux vers un point commun.[^56_4][^56_2][^56_1]

## Pourquoi c’est bon pour le jeu

En game design, c’est très propre parce que :

- chaque joueur comprend immédiatement où vendre ou acheter auprès du système ;
- le département gagne une vraie identité fonctionnelle ;
- vous limitez la micro-logistique inutile ;
- vous gardez la possibilité d’ajouter plus tard d’autres nœuds sans casser la base.

Je garderais donc “une coop bot principale par département” comme règle fondatrice.

## Marché national joueur

Pour le commerce entre joueurs, je pense aussi que votre idée est la bonne :

**marché national entre joueurs, avec outils de recherche et filtres solides.**

Cela permet d’éviter qu’un joueur soit bloqué par un bassin local trop vide, tout en rendant les échanges plus fluides grâce à une place de marché large. Les travaux sur le design des marketplaces numériques montrent que les filtres et outils de recherche réduisent fortement la friction de recherche et améliorent la qualité du matching entre offre et demande.[^56_5][^56_6][^56_7]

## Ce que je mettrais comme filtres

Je prévoirais au minimum :

- type de produit ;
- catégorie, intrant, récolte, animal, matériel ;
- région ou département d’origine ;
- prix ;
- quantité ;
- qualité ;
- disponibilité immédiate ;
- mode de livraison ou retrait ;
- vendeur joueur ou coopérative.

Les plateformes de marché fonctionnent mieux quand elles donnent des filtres adaptés à l’intention de recherche réelle, plutôt qu’un simple catalogue brut difficile à parcourir.[^56_6][^56_7]

## Le bon compromis global

Du coup, votre économie pourrait être structurée ainsi :


| Canal | Portée | Rôle |
| :-- | :-- | :-- |
| Coopérative bot | Départementale | filet de sécurité, achats/ventes de base |
| Marché joueur | National | meilleur commerce, arbitrage, spécialisation |
| Logistique | Territoriale | coût, délai, identité géographique |

Je trouve ce compromis très fort, parce qu’il combine :

- proximité et simplicité côté bot ;
- profondeur et dynamisme côté joueurs ;
- territorialité via les coûts ou délais logistiques.


## Ce que je vous conseille d’ajouter

Pour éviter que le marché national soit trop “magique”, j’ajouterais quand même :

- un coût de transport ;
- un délai selon distance ;
- éventuellement un tri entre retrait local et expédition.

Comme ça, le marché national reste pratique sans effacer totalement la géographie.

## Ce que je considère comme statué

Si je tranche avec votre proposition, je retiens donc :

- une coopérative bot par département ;
- localisation à la préfecture/capitale départementale ;
- rôle de point central de marché système ;
- marché joueur national ;
- filtres puissants et recherche claire ;
- géographie conservée par des coûts ou délais logistiques.


## Mon avis net

Franchement, je trouve cette combinaison **très solide**. Elle est plus simple qu’un réseau logistique ultra réaliste, mais bien plus crédible et intéressante qu’un marché totalement abstrait sans ancrage territorial. La prochaine décision logique à fixer est probablement : **quels biens passent par la coop bot, et lesquels doivent surtout vivre sur le marché joueur**.[^56_8][^56_9][^56_5]
<span style="display:none">[^56_10][^56_11][^56_12][^56_13][^56_14][^56_15]</span>

<div align="center">⁂</div>

[^56_1]: https://www.produceleaders.com/benefits-of-collaborative-logistics-in-agriculture/

[^56_2]: https://ap.fftc.org.tw/article/944

[^56_3]: https://blog.pazago.com/post/logistics-supply-chain-agriculture

[^56_4]: https://www.iieta.org/journals/mmep/paper/10.18280/mmep.121107

[^56_5]: https://ide.mit.edu/wp-content/uploads/2017/07/IDE-Research-Brief_0717.pdf

[^56_6]: https://ide.mit.edu/wp-content/uploads/2017/07/IDE-Research-Brief_0717.pdf?x82616

[^56_7]: https://evinent.com/blog/ecommerce-search-filters

[^56_8]: https://www.sciencedirect.com/science/article/abs/pii/S0957417424013885

[^56_9]: https://agriculture.institute/farm-cost-mgt/logistics-management-agricultural-efficiency/

[^56_10]: https://www.scirp.org/journal/paperinformation?paperid=147922

[^56_11]: https://www.diktio-kapa.dos.gr/MATCOM/English/Agricultural Cooperatives/Trainer's Manuals/01(0036)Collecting and receiving agricultural produce.pdf

[^56_12]: https://www.tandfonline.com/doi/full/10.1080/09537287.2020.1796135

[^56_13]: https://openknowledge.fao.org/server/api/core/bitstreams/a33b508d-9429-4f01-b6a2-eba1be940f79/content

[^56_14]: https://www.digivante.com/blog/search-filters-checkout-the-hidden-friction-points-in-retails-digital-journeys/

[^56_15]: https://www.frontiersin.org/journals/sustainable-food-systems/articles/10.3389/fsufs.2024.1442600/pdf


---

# Oui et penser qu’un joueur qui achète du blé à la coopérative ne peut pas le revendre au même prix un malus de mis en place pour éviter les boucles qui rapporte de l’argent sans rien faire

Oui, il faut **absolument** verrouiller ça. Si un joueur peut acheter à la coopérative et revendre au même prix, ou avec un écart trop faible, vous ouvrez la porte à des boucles d’arbitrage sans production réelle, ce qui casse très vite une économie de jeu ; les systèmes de vendeurs/NPC évitent généralement cela avec un écart achat/vente, des prix planchers/plafonds ou des restrictions de revente.[^57_1][^57_2]

## Règle à fixer

Je statuerais sans hésiter :

**Un bien acheté à la coopérative bot ne peut jamais être revendu au bot avec bénéfice, ni à prix neutre.**

Il doit toujours exister une perte automatique entre :

- prix d’achat bot ;
- prix de revente bot.

C’est le garde-fou économique de base pour empêcher les boucles passives et les exploits de type “buy low / sell same system”.[^57_2][^57_1]

## La bonne mécanique

Le plus simple est d’appliquer un **spread bot** permanent :


| Action | Prix |
| :-- | :-- |
| Achat au bot | prix haut / plafond |
| Vente au bot | prix bas / plancher |

Exemple :

- la coop bot vend le blé à 100 ;
- la coop bot rachète le blé à 80 ;
- donc toute boucle immédiate fait perdre 20.

Ce principe de spread est classique pour empêcher les profits sans risque sur un même acteur de marché.[^57_2]

## Ce que je recommande en plus

Je ne me contenterais pas d’un simple malus global.
Je mettrais 3 couches de sécurité :

### 1. Spread achat/vente

Toujours présent.

### 2. Tag d’origine

Un produit acheté au bot garde une information d’origine “coopérative”.
Cela permet d’appliquer des règles spécifiques à sa revente, au moins vis-à-vis du bot.

### 3. Dépréciation ou frais

En cas de revente rapide au bot :

- frais ;
- décote ;
- commission ;
- ou prix encore plus bas.

Cette idée de tag d’origine est utile pour empêcher les circuits absurdes de revente immédiate sur le même système marchand.[^57_3]

## Ma règle concrète pour Agriva

Je ferais quelque chose comme :

- un produit acheté au bot peut être revendu au bot, mais avec perte certaine ;
- un produit acheté au bot puis revendu très vite subit une décote supplémentaire ;
- un produit transformé ou réellement utilisé dans l’exploitation sort de cette logique punitive ;
- le marché joueur, lui, reste libre.

Comme ça, le bot sert d’infrastructure économique, pas de machine à cash.

## Point très important

Il faut bien distinguer :

- **commerce légitime** ;
- **arbitrage stérile**.

Si un joueur achète du blé pour nourrir son élevage, le transformer, ou l’utiliser dans une vraie chaîne de production, c’est très bien.
Si un joueur achète du blé juste pour cliquer “revendre” et générer du profit, il faut que ce soit impossible.

## Ce que j’éviterais

Je n’irais pas vers :

- achat et revente bot au même prix ;
- prix dynamiques mal bornés ;
- exceptions trop nombreuses ;
- systèmes opaques que le joueur ne comprend pas.

Le jeu doit afficher clairement que :

- la coopérative vend avec marge ;
- elle rachète à prix inférieur ;
- le marché joueur est l’endroit où l’on peut faire de meilleures affaires.


## Formule simple à retenir

Je poserais cette règle de design :

**Le bot garantit la liquidité, pas la rentabilité.**

C’est probablement la meilleure formulation.

## Décision statuée

Donc je considère comme acté :

- toute transaction bot a un spread ;
- revente immédiate bot -> bot toujours perdante ;
- possibilité d’ajouter un tag d’origine ;
- éventuelle décote supplémentaire sur les biens revendus sans usage réel ;
- profits intéressants réservés au marché joueur ou à la transformation.

C’est une décision très saine, parce qu’elle protège l’économie dès la base tout en restant simple à comprendre.[^57_1][^57_3][^57_2]
<span style="display:none">[^57_10][^57_11][^57_12][^57_13][^57_14][^57_15][^57_4][^57_5][^57_6][^57_7][^57_8][^57_9]</span>

<div align="center">⁂</div>

[^57_1]: https://www.reddit.com/r/gamedesign/comments/wtjxg7/why_games_about_trading_cant_have_no_minimal_or/

[^57_2]: https://community.stratics.com/threads/question-about-npc-pricing-and-fof.57902/

[^57_3]: https://empyriononline.com/threads/economy-fix-for-buying-and-selling-for-profit-at-the-same-poi-or-close.102726/

[^57_4]: https://seforums.pantheonmmo.com/content/forums/topic/12252/how-to-make-a-player-driven-economy/view/post_id/238808?mobile=0

[^57_5]: https://www.pathofexile.com/forum/view-thread/3635729

[^57_6]: https://forum.playboundless.com/t/how-will-the-player-driven-economic-system-work/6161?page=4

[^57_7]: https://academic.oup.com/book/39754/chapter/339816605

[^57_8]: https://www.reddit.com/r/theouterworlds/comments/1oqq88x/how_to_get_infinite_money_using_vendor_buyback/

[^57_9]: https://ianparberry.com/pubs/econ.pdf

[^57_10]: https://www.bancaditalia.it/pubblicazioni/qef/2023-0799/QEF_799_23.pdf

[^57_11]: http://d2mods.info/forum/viewtopic.php?t=14520

[^57_12]: https://fractalsoftworks.com/forum/index.php?topic=34801.0

[^57_13]: https://onlinelibrary.wiley.com/doi/full/10.1111/1911-3846.70001

[^57_14]: https://www.facebook.com/groups/319479292450616/posts/1502725627459304/

[^57_15]: https://www.tse-fr.eu/sites/default/files/TSE/documents/doc/by/tirole/competition_and_the_industrial_challenge_for_the_digital_age_020922.pdf


---

# Car des joueurs vont beaucoup utiliser le bot quand ils auront de grande exploitation je veux protéger de ça car le bot n’aura pas de limite d’achat pour empêcher la frustration. Pour l’achat d’animaux comment vois tu les chose car pour commencer il faut bien que les joueurs en achète au bot ? Je veux une limite à ça pour éviter de construire sont exploration sur les achat au bot et non le travail

Oui, il faut protéger ça dès la conception. Si le bot garde une demande illimitée pour éviter la frustration, alors il faut compenser avec des garde-fous économiques comme des spreads, des paliers de rentabilité décroissante, des taxes et des limites de progression sur certains achats structurants, sinon les grosses exploitations vont naturellement “jouer contre le bot” plutôt que contre le système agricole réel.[^58_1][^58_2][^58_3]

## Vente au bot

Je statuerais ainsi :

**Le bot peut acheter sans limite de volume, mais pas sans limite de rentabilité.**

Autrement dit :

- oui à la liquidité illimitée ;
- non à la profitabilité illimitée.

Le moyen le plus propre est d’appliquer un système de **rendement décroissant économique** sur les ventes bot au-delà d’un certain seuil par période, ce qui est cohérent avec les principes de soft caps et de diminishing returns souvent utilisés pour contenir les abus sans bloquer complètement le joueur.[^58_3][^58_4][^58_5]

## Ma proposition concrète

Pour les ventes à la coop bot :

- jusqu’à un seuil normal : prix standard bot ;
- au-delà : baisse progressive du prix de reprise ;
- au-delà d’un gros seuil : prix encore moins favorable ;
- jamais de blocage dur complet.

Exemple simple :

- 0 à 100 tonnes : 100% du prix bot ;
- 100 à 300 tonnes : 95% ;
- 300 à 800 tonnes : 90% ;
- au-delà : 85%.

Comme ça :

- le joueur n’est jamais frustré ;
- il peut toujours écouler sa production ;
- mais il a intérêt à chercher mieux via marché joueur, contrats, transformation, stockage ou diversification.


## Achat d’animaux au bot

Pour les animaux, je serais plus strict.
Parce que là, vous touchez à la **construction même de l’exploitation**.

Je statuerais donc :

**Le bot doit permettre de démarrer un atelier animal, mais ne doit pas permettre de bâtir durablement une très grande activité d’élevage uniquement par achats bot.**

C’est important, sinon l’élevage devient une simple mécanique d’achat d’unités plutôt qu’un système de reproduction, de sélection, de gestion et de progression.

## Comment je le vois

Je ferais une logique en 3 temps :


| Phase | Rôle du bot |
| :-- | :-- |
| Démarrage | Le bot vend les animaux nécessaires pour commencer |
| Développement | Le bot reste possible, mais moins efficace |
| Croissance avancée | La progression doit venir surtout de reproduction, marché joueur, ou filières spécialisées |

## Règle concrète pour les animaux

Je vous propose ceci :

### 1. Le bot vend des animaux de base

- génétique standard ;
- qualité moyenne ;
- disponibilité garantie ;
- prix peu avantageux.


### 2. Quantité limitée par période

Par exemple :

- quota hebdomadaire ou mensuel ;
- quota par espèce ;
- quota lié à la taille actuelle de l’atelier.


### 3. Prix croissant par tranche

Plus le joueur achète d’animaux bot sur une période, plus le prix unitaire monte.

### 4. Qualité plafonnée

Le bot ne fournit jamais les meilleures lignées, ni les animaux premium.

### 5. Revente au bot défavorable

Les animaux achetés au bot ne doivent pas permettre de faire des boucles économiques rentables.

## Pourquoi cette solution est bonne

Elle permet :

- à un nouveau joueur de lancer un atelier ;
- à un joueur bloqué de réparer un troupeau ;
- à l’économie de rester jouable même si l’offre joueur est faible ;
- mais sans faire du bot la source principale d’expansion à long terme.

C’est un très bon compromis entre accessibilité et protection de l’économie.

## Ce que je recommande très clairement

Pour les animaux, je ne ferais **pas** un bot à stock illimité neutre.
Je ferais plutôt un bot avec :

- stock “garanti”, mais en quantité raisonnable par période ;
- prix croissant ;
- qualité moyenne ;
- animaux de base seulement ;
- pas d’élite génétique ;
- incitation forte à passer ensuite par reproduction ou marché joueur.


## Ma règle de design

Je poserais deux règles très nettes :

**Le bot doit sécuriser l’entrée dans une activité, pas devenir la stratégie optimale pour la développer.**

**Le bot absorbe les excès de production, mais ne doit jamais être le meilleur partenaire économique d’une grande exploitation.**

## Ce que je considère comme statué

Si je tranche pour Agriva, je retiens :

- ventes au bot illimitées en volume ;
- prix bot dégressif au-delà de seuils ;
- spread permanent achat/vente ;
- achats d’animaux bot autorisés pour démarrer ;
- quantités d’animaux bot limitées par période ;
- prix d’animaux bot croissants par tranche ;
- qualité des animaux bot plafonnée ;
- croissance avancée de l’élevage orientée vers reproduction, marché joueur et spécialisation.


## Ma recommandation finale sur les animaux

Je ferais même une nuance supplémentaire :

- le bot vend bien des **animaux de fondation** ;
- le marché joueur vend des **animaux de progression** ;
- la ferme produit ensuite ses **animaux de consolidation** via la reproduction.

Je trouve cette structure particulièrement saine, parce qu’elle donne au bot un vrai rôle d’amorçage sans le laisser remplacer le cœur du travail d’élevage.[^58_6][^58_7]
<span style="display:none">[^58_10][^58_11][^58_12][^58_13][^58_14][^58_15][^58_8][^58_9]</span>

<div align="center">⁂</div>

[^58_1]: https://adriancrook.com/5-common-mobile-game-economy-problems-solved/

[^58_2]: https://www.gamedeveloper.com/production/i-designed-economies-for-150m-games-here-s-my-ultimate-handbook

[^58_3]: https://300mind.studio/blog/what-is-game-economy-design/

[^58_4]: https://www.reddit.com/r/gamedesign/comments/1rkhpj1/how_do_you_balance_an_rpg_economy_where_the/

[^58_5]: https://us.forums.blizzard.com/en/d3/t/paragon-diminishing-returns-instead-of-a-hard-cap/61401

[^58_6]: https://chainplay.gg/blog/animal-care-becomes-a-structured-progression-system/

[^58_7]: https://github.com/CleverRaven/Cataclysm-DDA/issues/59643

[^58_8]: https://www.reddit.com/r/lostarkgame/comments/1ot41rq/simple_thorough_explanation_of_a_game_economy/

[^58_9]: https://forum.paradoxplaza.com/forum/threads/the-diminishing-returns-on-income.1593591/

[^58_10]: https://forums.elderscrollsonline.com/en-gb/discussion/95846/how-to-end-gold-farming-in-a-mmo/p2

[^58_11]: https://www.facebook.com/LONGLOBAL/posts/weekly-meeting-key-issue-discussion-outcome-update-742026️-i-am-writing-to-sugge/957605353685644/

[^58_12]: https://steamcommunity.com/app/2429640/discussions/0/4701286908192914930/?l=italian

[^58_13]: https://forums.elderscrollsonline.com/en/discussion/95846/how-to-end-gold-farming-in-a-mmo

[^58_14]: https://www.reddit.com/r/ElinsInn/comments/1gq3l63/livestock_breeding_question/

[^58_15]: https://steamcommunity.com/app/1151340/discussions/0/3781372783239870155/?l=danish


---

# Ok très bien.