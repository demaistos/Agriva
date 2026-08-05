# Agriva GDD — Economy — Marché Joueur & Anti-Exploit
> Marché joueur national, filtres, anti-exploit, malus revente, décisions statuées

---


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