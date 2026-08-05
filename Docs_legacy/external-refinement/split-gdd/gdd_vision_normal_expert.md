# Agriva GDD — Vision — Normal/Expert & Matrice
> Mode Normal/Expert, règles de productivité, matrice MVP par système, règle GDD

---

Le principe “Normal / Expert” répond à un vrai problème : une partie du public veut découvrir la simulation sans être noyée, alors qu’une autre veut plus de variables, plus de risques et plus d’optimisation. Les discussions de design sur les modes de difficulté montrent justement que séparer une version plus accessible d’une version plus exigeante peut élargir la base de joueurs, à condition de ne pas casser la cohérence du monde partagé.[^4_2][^4_3][^4_1]

Le fait de **figer le choix pour toute la saison** est aussi une bonne idée, car cela évite les allers-retours opportunistes. Les changements de mode en cours de route sont souvent une source d’exploitation ou de frustration quand les récompenses et contraintes ne sont pas strictement alignées.[^4_5][^4_1]

## Le point sensible

Le vrai risque est votre proposition de productivité : si le mode normal est plafonné à 100% alors que l’expert peut monter à 130%, les meilleurs joueurs expert risquent d’avoir un avantage économique structurel trop fort sur le même serveur. Dans un monde partagé avec marché, contrats et interaction entre joueurs, un bonus potentiel de 30% est énorme, surtout si les joueurs experts peuvent aussi absorber les risques mieux que prévu.[^4_6][^4_7][^4_8]

Autrement dit, sur le papier :

- normal = stabilité ;
- expert = risque/récompense.

Mais en pratique, les joueurs compétitifs optimisent très vite les systèmes et transforment souvent un “mode risqué” en meilleur choix dominant si la récompense maximale est trop haute.[^4_7][^4_8]

## Ma recommandation

Je garderais le principe, mais je le reformulerais comme ceci :

- **Mode Normal** : variables simplifiées, aide plus forte, automatisations de base, productivité plus stable, fourchette resserrée.
- **Mode Expert** : variables complètes, moins d’aides, plus de leviers, plus de variance, meilleur potentiel technique, mais aussi plus d’échecs possibles.

En revanche, je ne ferais pas un écart aussi grand que **80% à 130%** au début. Je viserais plutôt une plage du type :

- **Normal** : 90% à 105%.
- **Expert** : 75% à 115% au lancement.

Cela garde un vrai intérêt au mode expert sans transformer le mode normal en sous-classe économique permanente.[^4_8][^4_6][^4_7]

## Ce qu’on peut simplifier en normal

Le meilleur levier n’est pas seulement la productivité, mais la **complexité simulée**. En mode normal, vous pouvez retirer un niveau de finesse tout en gardant le même univers :

- agronomie plus agrégée, moins de paramètres cachés ;
- maintenance simplifiée ;
- pénalités moins sévères sur timing ou mauvais enchaînements ;
- recommandations plus explicites ;
- gestion économique plus lisible ;
- moins d’effets croisés entre systèmes.

Ainsi, le joueur normal joue vraiment au même jeu, mais avec moins de couches à maîtriser.[^4_9][^4_10][^4_11]

## Le meilleur compromis

À mon avis, la bonne philosophie est :

- **Normal** = même monde, mêmes métiers, mêmes marchés, mais simulation plus assistée.
- **Expert** = même monde, même économie, mais simulation plus fine et plus volatile.
- **Pas de supériorité garantie** du mode expert, seulement un plafond de maîtrise plus élevé.

Si vous voulez absolument garder un bonus expert marqué, je le déplacerais en partie hors de la “productivité brute” :

- meilleure qualité ;
- meilleure régularité sur le long terme ;
- meilleure capacité à saisir certaines opportunités ;
- meilleurs scores techniques saisonniers.

C’est plus sain qu’un simple multiplicateur de rendement ou de puissance économique.[^4_7][^4_8]

## Ma position finale

Donc : **oui au double mode sur un même serveur**, **oui au verrouillage saisonnier**, **oui à une profondeur plus forte en expert**, mais **je réduirais l’écart de productivité brute**. Le plus important est que le mode expert donne plus de contrôle et plus de variance, pas automatiquement plus d’argent.

Je vous propose la règle de base suivante pour Agriva :

- Normal : simulation assistée, stable, pédagogique.
- Expert : simulation complète, risquée, optimisable.
- Les deux peuvent réussir économiquement, mais par des chemins différents.

La suite logique est qu’on définisse maintenant **quels systèmes sont simplifiés en Normal et complets en Expert**, un par un.
<span style="display:none">[^4_12][^4_13][^4_14][^4_15][^4_16][^4_17][^4_18]</span>

<div align="center">⁂</div>

[^4_1]: https://www.reddit.com/r/MMORPG/comments/j8gdrx/why_dont_mmos_have_servers_with_varied/

[^4_2]: https://forums.mmorpg.com/discussion/360116/difficulty-sliders-in-mmorpgs

[^4_3]: https://blog.osk.sh/post.php?p=6737fdef0666f3.20808811

[^4_4]: https://dev.to/ibmdeveloper/multiplayer-server-basics-ep-1-creating-a-multiplayer-game-server-5aed

[^4_5]: https://www.youtube.com/watch?v=QVYX6vG-Wks

[^4_6]: https://www.sciencedirect.com/science/article/abs/pii/S1568494614000209

[^4_7]: https://gamestudies.org/1101/articles/williams_nesbitt_eidels_elliott

[^4_8]: https://discussions.unity.com/t/the-numerical-balancing-for-a-mmorpg-or-diablo-like-arpg-is-very-complex/759584

[^4_9]: https://blackland.tamu.edu/models/farmsim/

[^4_10]: https://agritrop.cirad.fr/552742/1/document_552742.pdf

[^4_11]: https://www.mssanz.org.au/modsim09/B3/deVoil.pdf

[^4_12]: https://arxiv.org/html/2503.18748v1

[^4_13]: https://www.reddit.com/r/Mechwarrior5Mods/comments/1dupaiw/advice_on_getting_the_right_difficulty_balance_to/

[^4_14]: https://syncaine.com/2010/12/29/mmo-pvp-never-fair-and-balanced/

[^4_15]: https://futuremoneysimulator.com/simulators/risk-based-trading

[^4_16]: https://forum.london2038.com/t/on-grouping-and-difficulty-level/1840

[^4_17]: https://support.fxreplay.com/articles/how-to-use-the-rr-simulator

[^4_18]: https://www.gabrielgambetta.com/client-server-game-architecture.html


---

# Ok pour moi

Parfait. Votre intuition est cohérente avec de bonnes pratiques de design : il vaut mieux jouer sur la **complexité** et l’assistance que sur une hiérarchie brute “facile vs fort”, surtout pour un jeu de simulation destiné à être accessible mais profond. Les sources sur la difficulté en jeu vont justement dans ce sens : complexité, challenge et accessibilité doivent être pensés séparément, et les aides aux débutants peuvent coexister avec une grande profondeur de maîtrise.[^5_1][^5_2][^5_3][^5_4][^5_5]

## Règle de base

Je reformulerais votre système ainsi :

- **Mode Normal** : même monde, même saison, mêmes marchés, mais simulation simplifiée et davantage assistée.
- **Mode Expert** : même monde, mêmes règles macro, mais simulation plus fine, plus volatile, plus optimisable.
- Le choix est **verrouillé pour toute la saison**, ce qui pose un cadre clair et évite l’exploitation opportuniste.[^5_6][^5_1]


## Ce qu’on simplifie

Pour que le mode normal reste attractif, il faut enlever une couche de micro-complexité sans retirer le cœur agricole. L’idée n’est pas de tricher pour le joueur, mais de regrouper certaines variables en indicateurs plus lisibles, ce qui correspond aussi à l’objectif d’accessibilité observé dans les efforts de tutoriels et de guidage des farming sims récents.[^5_2][^5_5]

Je verrais par exemple :

- sol résumé en 2 à 3 états au lieu d’un modèle plus fin ;
- recommandations plus explicites sur le timing des travaux ;
- pénalités techniques moins dures ;
- maintenance plus agrégée ;
- logistique plus simplifiée ;
- assistance plus forte pour la planification.


## Ce qu’on garde en expert

Le mode expert doit surtout offrir plus de **contrôle**, pas seulement plus de sanction. Les réflexions de design sur difficulté et profondeur rappellent qu’un bon mode avancé ajoute de la décision intéressante, pas seulement de la punition arbitraire.[^5_7][^5_3][^5_4]

Je garderais en expert :

- davantage de variables agronomiques ;
- effets croisés plus nombreux entre météo, sol, matériel et calendrier ;
- écarts de performance plus sensibles ;
- opportunités d’optimisation plus fortes ;
- diagnostic moins assisté, donc plus grande valeur de l’expertise joueur.


## Position finale pour Agriva

Donc oui, je validerais votre système de saison avec deux modes, et je le poserais officiellement comme un axe fondateur du design d’Agriva. Cela sert votre promesse “tout public mais réaliste”, parce qu’un nouveau joueur peut entrer par le mode normal, puis basculer en expert sur une saison future une fois qu’il maîtrise mieux les systèmes.[^5_5][^5_1][^5_2]

## Formulation produit

Je vous propose cette formulation simple pour le GDD :

- **Normal** : apprendre et gérer.
- **Expert** : maîtriser et optimiser.
- Même univers, même économie, même saison, mais niveau de finesse différent.
- Le mode expert a un plafond de maîtrise plus haut, mais pas une supériorité automatique.

La prochaine étape logique est de lister précisément, système par système, **ce qui change entre Normal et Expert** pour les 6 systèmes MVP d’Agriva.[^5_3][^5_4]
<span style="display:none">[^5_10][^5_11][^5_12][^5_13][^5_14][^5_15][^5_8][^5_9]</span>

<div align="center">⁂</div>

[^5_1]: https://redharegames.wordpress.com/2022/02/14/simple-article-how-to-design-difficulty-modes-in-games/

[^5_2]: https://www.gamerbraves.com/exclusive-farming-simulator-25-on-expanding-their-horizons-an-interview-with-martin-rabl/

[^5_3]: https://www.youtube.com/watch?v=KspGk0L-eYI

[^5_4]: https://davidmullich.com/2016/11/21/designing-a-good-game-is-about-more-than-making-it-difficult-complexity-depth-and-balance/

[^5_5]: https://www.farming-simulator.com/newsArticle.php?news_id=280

[^5_6]: https://www.intechopen.com/chapters/1228576

[^5_7]: https://www.gamedev.net/tutorials/game-design/game-design-and-theory/game-design-a-different-approach-to-difficulty-r4992/

[^5_8]: https://www.reddit.com/r/gamedesign/comments/10gdi1k/examples_of_dynamicautomatic_difficulty/

[^5_9]: http://www.davetech.co.uk/difficultycurves

[^5_10]: https://www.youtube.com/watch?v=Im0dkDyynF4

[^5_11]: https://lume.ufrgs.br/bitstream/handle/10183/245329/001145461.pdf?sequence=1

[^5_12]: https://www.reddit.com/r/farmingsimulator/comments/16o1dvy/accessibility_mods_for_helping_with_field_work/

[^5_13]: https://en.wikipedia.org/wiki/Dynamic_game_difficulty_balancing

[^5_14]: https://www.apsim.info

[^5_15]: https://discussions.unity.com/t/need-a-proper-formula-for-my-difficulty-based-on-level-system/755453


---

# Ok

Très bien. Je vous propose maintenant une première matrice **Normal vs Expert** sur les 6 systèmes MVP, en gardant votre principe : même monde, même saison, même économie globale, mais moins de complexité en Normal et plus de finesse en Expert. Cette approche est cohérente avec la distinction entre difficulté, complexité et profondeur, ainsi qu’avec les simulateurs agricoles qui combinent climat, sol, management, matériel et décisions dans des modèles modulaires.[^6_1][^6_2][^6_3][^6_4][^6_5]

## Matrice MVP

| Système | Mode Normal | Mode Expert |
| :-- | :-- | :-- |
| Météo | Indicateurs simples, fenêtres favorables/défavorables, risques visibles [^6_6][^6_7] | Variables plus fines, effets croisés sur timing, qualité, pertes, risques locaux [^6_2][^6_7] |
| Parcelles | État global lisible, historique simplifié, peu de micro-variables [^6_8] | Historique technique plus détaillé, effets cumulés des interventions et précédents [^6_2][^6_8] |
| Cultures | Stades visibles, besoins résumés, pénalités modérées, recommandations fortes [^6_7][^6_9] | Stades et besoins plus fins, arbitrages plus serrés sur date, qualité, rendement, intrants [^6_2][^6_7] |
| Matériel | Compatibilité et efficacité simplifiées, usure modérée, peu de réglages [^6_10] | Performances dépendantes du contexte, usure plus sensible, choix techniques plus impactants [^6_10][^6_9] |
| Économie | Comptes plus lisibles, moins de frais cachés, prévisions plus stables [^6_11][^6_12] | Marges plus sensibles, coûts indirects, arbitrages plus fins sur trésorerie et investissement [^6_11][^6_12][^6_13] |
| Planification | Assistant fort, alertes, propositions de priorités, enchaînements guidés [^6_14][^6_15] | Outils avancés mais moins directifs, plus d’autonomie, erreurs d’ordonnancement plus coûteuses [^6_14][^6_16] |

## Principe directeur

La bonne règle est : en **Normal**, vous simplifiez la lecture et réduisez les effets en cascade ; en **Expert**, vous exposez davantage de variables et vous laissez le joueur exploiter ou subir les interactions du système. C’est plus sain qu’un simple “mode facile”, parce que la profondeur vient ici du nombre de leviers décisionnels disponibles et de la manière dont ils se combinent.[^6_3][^6_17][^6_5]

## Productivité

Votre intuition initiale peut rester, mais sous une forme plus contrôlée. Je garderais l’idée que le mode normal offre une performance plus stable, tandis que l’expert ouvre un plafond plus élevé avec plus de variance, car les systèmes agricoles réels dépendent fortement de l’ajustement entre météo, état du sol, pratiques et timing.[^6_2][^6_6][^6_7]

Je proposerais :

- **Normal** : productivité plus stable, proche de la référence.
- **Expert** : productivité plus dispersée selon maîtrise, contexte et choix.
- Les écarts viennent surtout de la qualité des décisions et du couplage entre systèmes, pas d’un bonus artificiel.


## Ce qu’il faut absolument préserver

Même en Normal, le joueur doit apprendre quelque chose de la réalité agricole. Les modèles de simulation agricole sont précisément utiles parce qu’ils relient pratique, contexte et résultat ; si vous retirez trop de causalité, vous perdez la promesse de simulation.[^6_7][^6_4][^6_2]

Donc, en Normal :

- on simplifie ;
- on agrège ;
- on guide ;
- mais on ne ment pas.


## Règle GDD proposée

Je vous propose d’inscrire cette règle dans Agriva :

- **Normal** : simulation pédagogique, stable, assistée.
- **Expert** : simulation détaillée, plus sensible, plus optimisable.
- Les deux modes partagent le même monde, mais pas le même niveau de granularité décisionnelle.
- La supériorité d’un joueur vient de sa maîtrise du système, pas d’un multiplicateur gratuit.


## Étape suivante

La suite logique est de transformer cette matrice en **règles concrètes par système**, en commençant par le plus important : **Météo -> Parcelles -> Cultures**. C’est là que naît la sensation de vraie agriculture dans Agriva.[^6_9][^6_2][^6_7]
<span style="display:none">[^6_18][^6_19]</span>

<div align="center">⁂</div>

[^6_1]: https://www.apsim.info

[^6_2]: https://era.dpi.qld.gov.au/id/eprint/8478/

[^6_3]: https://www.youtube.com/watch?v=KspGk0L-eYI

[^6_4]: https://www.nature.com/research-intelligence/nri-topic-summaries/agricultural-production-systems-simulation-for-l3-300205

[^6_5]: https://www.gamedeveloper.com/design/the-rld-handbook-sometimes-it-s-not-about-the-metrics---depth-complexity

[^6_6]: https://paul-tech.com/smart-farming-how-to-unlock-soil-plant-and-weather-data/

[^6_7]: https://www.maxapress.com/article/id/677b3d46fa6c58500c875ec2

[^6_8]: https://www.mssanz.org.au/modsim09/B3/deVoil.pdf

[^6_9]: https://www.farming-simulator.com/newsArticle.php?lang=fr\&country=fr\&news_id=613

[^6_10]: https://pub.epsilon.slu.se/553/1/Agraria_462.pdf

[^6_11]: https://blackland.tamu.edu/models/farmsim/

[^6_12]: https://www.athanasiadis.info/assets/pdf/seamless2010fssim.pdf

[^6_13]: https://www.ars.usda.gov/ARSUserFiles/np212/LivestockGRACEnet/IFSM.pdf

[^6_14]: https://absel-ojs-ttu.tdl.org/absel/article/download/1757/1726

[^6_15]: https://dl.acm.org/doi/pdf/10.1145/76738.76878

[^6_16]: https://danielzammit.me/a-brief-overview-of-expert-systems-in-the-game-industry/

[^6_17]: https://ecampusontario.pressbooks.pub/gamedesigndevelopmenttextbook/chapter/hierarchy-of-challenges/

[^6_18]: https://agritrop.cirad.fr/614347/7/614347.pdf

[^6_19]: https://arxiv.org/abs/2103.03405


---