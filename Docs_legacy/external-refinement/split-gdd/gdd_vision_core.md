# Agriva GDD — Vision & Core Design
> Vision produit, boucle de jeu, 12 systèmes cœur, Normal/Expert, matrice MVP
> Lignes source : 3–709

---

# Oui

Parfait. On peut poser maintenant un **GDD niveau 1** pour Agriva, centré sur une simulation agricole multijoueur navigateur, plus réaliste que SimAgri, accessible, avec une économie saine et un abonnement de confort. Les bonnes pratiques de cadrage GDD recommandent justement de commencer par la vision, la core loop, les systèmes, la progression et le modèle économique avant d’entrer dans les détails de features.[^1_1][^1_2][^1_3]

## Fantasy joueur

Le joueur doit se sentir à la tête d’une vraie exploitation agricole vivante, où chaque décision a un impact concret sur la production, les finances, l’organisation du travail et les relations avec les autres acteurs du monde agricole. L’objectif n’est pas seulement “faire pousser des choses”, mais comprendre comment fonctionne réellement une ferme moderne, sans exiger d’être déjà expert du métier.[^1_4][^1_5][^1_6]

## Boucle principale

La boucle centrale d’Agriva pourrait être :

1. Observer l’état de l’exploitation, météo, sols, animaux, stocks, matériel, finances.
2. Décider des priorités du jour ou de la semaine.
3. Lancer des actions immédiates et des actions longues.
4. Laisser les systèmes produire leurs effets.
5. Récolter les résultats, corriger la stratégie, investir, recommencer.

Cette structure colle bien aux jeux de gestion à boucle ressource-production-échange, tout en ajoutant une couche de simulation métier plus riche et plus persistante.[^1_7][^1_8][^1_3]

## Temps

Votre intuition sur les actions immédiates et différées est très bonne. Un jeu de ferme persistant fonctionne mieux quand il mélange micro-décisions instantanées et processus longs, car cela crée à la fois du plaisir court terme et de la planification long terme.[^1_9][^1_10][^1_7]

Je définirais 4 types de temps :

- **Instantané** : arbitrer une vente, acheter un outil, changer une consigne, lancer un contrat.
- **Court** : inspection, transport local, entretien léger, préparation d’un chantier.
- **Moyen** : semis, traitements, récolte, vêlage, transformation, livraison.
- **Long** : croissance culturale, reproduction, construction, amortissement, évolution du marché.


## Économie

Comme Agriva vise le multijoueur, l’économie doit être un système central et non un décor. Les économies MMO ont besoin de bons flux entre production, consommation, échange et destruction de valeur, sinon les ressources s’accumulent et le marché devient vite instable ou exploitable.[^1_8][^1_11]

Je vous recommande :

- des **sources** de valeur : récoltes, élevage, contrats, transformation, services entre joueurs ;
- des **puits** de valeur : maintenance, carburant, salaires, transport, taxes, usure, stockage, intérêts ;
- des **marchés multiples** : marché public, contrats privés, coopératives, appels d’offres ;
- une **spécialisation** des fermes : céréales, lait, engraissement, semences, ETA, logistique.


## Multijoueur

Le multijoueur ne doit pas être juste “voir d’autres gens”, mais produire de vraies interdépendances. Les browser farming games qui tiennent bien ont souvent une couche sociale ou communautaire forte, tandis que les jeux plus systémiques gagnent en profondeur quand les joueurs peuvent échanger, collaborer et se spécialiser.[^1_10][^1_12][^1_13]

Pour Agriva, je verrais :

- commerce entre joueurs ;
- coopératives et groupements ;
- entreprises de travaux agricoles ;
- contrats de production ;
- location ou prestation de matériel ;
- saisons serveur avec classements non pay-to-win, centrés sur efficacité, qualité, durabilité ou rentabilité.


## Progression

La progression ne doit pas être seulement “plus gros = mieux”. Pour un jeu réaliste, il faut plusieurs axes de maîtrise :

- taille de l’exploitation ;
- technicité agronomique ;
- qualité d’organisation ;
- maîtrise économique ;
- réputation commerciale ;
- spécialisation métier.

Cela permet à des profils différents d’exister dans le même monde, sans transformer le jeu en course linéaire à l’agrandissement.[^1_2][^1_3]

## Abonnement

Votre modèle est bon s’il reste sur du confort. Les discussions sur les modèles d’abonnement montrent que les joueurs acceptent plus facilement une formule récurrente quand elle donne des outils, du service ou de la commodité, plutôt qu’un avantage direct de performance.[^1_14][^1_15]

Je verrais par exemple :

- version de base jouable ;
- abonnement avec tableaux de bord avancés, alertes intelligentes, planification plus fine, vues historiques, outils de gestion multi-sites, personnalisation et qualité de vie ;
- aucune amélioration directe des rendements, vitesses, prix, croissance ou puissance économique.


## MVP

Je vous propose un MVP en 3 blocs :


| Bloc | Contenu |
| :-- | :-- |
| Exploitation | Parcelles, météo, calendrier, cultures, matériel, travaux, stock, finances |
| Monde | Marché, contrats, échanges, logistique simple, autres joueurs |
| Rétention | Objectifs, progression, événements saisonniers, tableaux de bord |

Ce MVP suffit pour tester si la boucle “simulation réaliste + monde partagé + gestion accessible” fonctionne réellement, avant d’ajouter élevage profond, transformation avancée, coopératives complètes ou filières détaillées.[^1_3][^1_7]

La meilleure suite maintenant est de définir **le core loop exact en 1 journée de jeu, 1 semaine de jeu et 1 saison de jeu** pour Agriva.
<span style="display:none">[^1_16][^1_17][^1_18][^1_19][^1_20]</span>

<div align="center">⁂</div>

[^1_1]: https://www.gitbook.com/blog/how-to-write-a-game-design-document

[^1_2]: https://smithery.ai/skills/neversight/game-systems-doc

[^1_3]: https://www.gameanalytics.com/blog/how-to-perfect-your-games-core-loop

[^1_4]: https://cursus.edu/fr/20006/simagri

[^1_5]: https://www.simagri.com/index.php?lang=1

[^1_6]: https://www.agritour.info/simagri-le-jeu-de-simulation-sur-lagriculture-et-lelevage/

[^1_7]: https://www.reddit.com/r/gamedesign/comments/j6jyg9/if_you_were_going_to_design_the_simplest/

[^1_8]: https://deliberategamedesign.com/resources-loop/

[^1_9]: https://playtoearn.com/news/5-browser-games-that-actually-pay-you-real-rewards-april-2026

[^1_10]: https://playtoearn.com/news/5-farming-games-that-pay-you-real-money-in-march-2026

[^1_11]: https://www.reddit.com/r/gamedesign/comments/178te4x/designing_mmo_economies/

[^1_12]: https://browser-games.net/simulations/farmerama/

[^1_13]: https://www.f2p.com/games/farmerama/

[^1_14]: https://zensimu.com/best-training-game-simulator/

[^1_15]: https://www.reddit.com/r/gamedev/comments/gpoi6x/subscription_models_for_games/

[^1_16]: https://indiegameacademy.com/free-game-design-document-template-how-to-guide/

[^1_17]: https://www.craft.do/vi/templates/game-design-document-template

[^1_18]: https://docsbot.ai/prompts/creative/complex-farming-game-design

[^1_19]: https://www.capitalismlab.com/good-business-simulation-games/

[^1_20]: https://www.reddit.com/r/incremental_games/comments/1in2nnc/ive_released_my_incremental_browser_mmo_today/


---

# Ok

Très bien. On peut maintenant formaliser la boucle de jeu d’Agriva à trois échelles : **1 journée**, **1 semaine** et **1 saison**, car une simulation agricole forte fonctionne justement en emboîtant une boucle courte d’actions, une boucle moyenne d’organisation, et une boucle longue de planification et de résultats.[^2_1][^2_2][^2_3][^2_4]

## 1 journée

La journée doit être le niveau de jeu le plus concret et le plus satisfaisant. Le joueur se connecte, lit l’état de son exploitation, lance quelques arbitrages immédiats, affecte des ressources, traite des imprévus, puis prépare les actions en cours ou à venir.[^2_5][^2_4][^2_1]

Je verrais cette boucle quotidienne :

1. Vérifier alertes, météo, travaux, animaux, stocks, finances.
2. Décider les priorités du jour.
3. Lancer des actions immédiates, par exemple vendre, acheter, affecter un tracteur, replanifier une équipe.
4. Suivre des actions en cours ou démarrer des actions à durée.
5. Encaisser les conséquences, coûts, retards, opportunités.
6. Préparer le lendemain.

Le rôle de la journée n’est pas d’achever des cycles agricoles entiers, mais de donner un sentiment de pilotage permanent de l’exploitation.[^2_6][^2_5]

## 1 semaine

La semaine doit être l’échelle de coordination. C’est là que le joueur gère la cohérence entre parcelles, matériel, main-d’œuvre, marché, élevage et trésorerie, plutôt que de juste cliquer opération par opération.[^2_4][^2_7][^2_8]

La boucle hebdomadaire pourrait être :

- établir le plan de travaux ;
- prioriser les parcelles ou ateliers ;
- réserver le matériel et les créneaux ;
- organiser achats, ventes et livraisons ;
- arbitrer les urgences apparues pendant la semaine ;
- comparer prévision versus réalisé.

C’est probablement à cette échelle que vous pouvez créer le plus de profondeur “gestion agricole” sans rendre l’interface lourde. Le joueur doit sentir qu’il orchestre une exploitation, pas qu’il exécute seulement des tâches unitaires.[^2_9][^2_10][^2_11]

## 1 saison

La saison est la grande boucle stratégique. C’est à ce niveau que le joueur mesure si son système d’exploitation fonctionne vraiment, car les décisions de semis, d’investissement, de rotation, de stocks, de conduite d’élevage et de commercialisation produisent enfin des résultats visibles.[^2_2][^2_3][^2_12]

La boucle saisonnière pourrait être :

1. Choisir une orientation de campagne.
2. Préparer moyens, budget, assolement et objectifs.
3. Exécuter la saison avec contraintes météo, temps et marché.
4. Récolter ou produire.
5. Commercialiser et absorber les coûts.
6. Faire le bilan technique, économique et organisationnel.
7. Réinvestir et préparer la saison suivante.

C’est aussi à ce niveau que le jeu doit enseigner la réalité agricole : une bonne décision n’est pas seulement rentable à l’instant, elle doit tenir sur une campagne complète.[^2_3][^2_11][^2_13]

## Articulation des trois boucles

L’important est que chaque niveau serve le suivant :

- la **journée** sert à piloter ;
- la **semaine** sert à organiser ;
- la **saison** sert à juger la stratégie.

Si une action n’a d’effet qu’au niveau journalier, elle sera vite perçue comme cosmétique. Si tout n’a d’effet qu’à la saison, le jeu semblera trop lent. L’intérêt vient précisément du mélange entre récompense rapide et conséquence différée.[^2_14][^2_1][^2_4]

## Première proposition Agriva

Je vous propose cette formulation simple du core loop :

- **Jour** : je contrôle mon exploitation.
- **Semaine** : j’organise mon système de production.
- **Saison** : je mesure si mon modèle agricole est viable.

Avec ça, on a une base solide pour la suite. La prochaine étape utile est de définir les **8 à 12 systèmes cœur** qui alimentent cette boucle, par exemple météo, sol, cultures, animaux, matériel, main-d’œuvre, stockage, marché, logistique, finance et contrats.[^2_10][^2_11][^2_9]
<span style="display:none">[^2_15][^2_16][^2_17][^2_18][^2_19][^2_20][^2_21]</span>

<div align="center">⁂</div>

[^2_1]: https://vsquad.art/blog/what-gameplay-loop-types-core-loops-explained

[^2_2]: https://farmingsimulator.fandom.com/wiki/Seasons/Farming_Simulator_22

[^2_3]: https://www.farming-simulator.com/newsArticle.php?news_id=289

[^2_4]: https://deliberategamedesign.com/core-loop/

[^2_5]: https://www.youtube.com/watch?v=zNs5BtuPDns

[^2_6]: https://www.reddit.com/r/gamedesign/comments/8x40fp/basic_game_loop_in_management_sims/

[^2_7]: https://deliberategamedesign.com/resources-loop/

[^2_8]: https://www.reddit.com/r/gamedesign/comments/178te4x/designing_mmo_economies/

[^2_9]: https://cursus.edu/fr/20006/simagri

[^2_10]: https://www.simagri.com/index.php?lang=1

[^2_11]: https://www.agritour.info/simagri-le-jeu-de-simulation-sur-lagriculture-et-lelevage/

[^2_12]: https://www.youtube.com/watch?v=KZ8eCdLKH0Y

[^2_13]: https://jeuvideo.afjv.com/news/2259_simagri.htm

[^2_14]: https://www.reddit.com/r/farmingsimulator/comments/185vek3/whats_a_good_way_to_kill_time_when_using_the/

[^2_15]: https://www.reddit.com/r/gamingsuggestions/comments/1lu8cn1/games_that_get_you_into_the_core_gameplay_loop/

[^2_16]: https://coreloop.gg

[^2_17]: https://www.facebook.com/groups/boardgamerevolution/posts/3743311782627399/

[^2_18]: https://www.reddit.com/r/playmygame/comments/1rgbu6b/i_built_a_cozy_multiplayer_farming_game_you_can/

[^2_19]: https://www.freemmorpglist.com/Lets_Farm-mmorpg.html

[^2_20]: https://gb.mmommorpg.com/browser-games/6/

[^2_21]: https://www.cmich.edu/docs/default-source/colleges/college-of-liberal-arts-and-social-sciences/center-for-learning-through-games-and-simulations/20230828-core-loop-syllabus.pdf?sfvrsn=cb9660de_4


---

# Ok

Très bien. Pour un jeu “plus réaliste que SimAgri”, les systèmes cœur doivent couvrir non seulement la production, mais aussi les interactions entre biophysique, décisions de gestion, contraintes économiques et temps long. Les modèles agricoles et whole-farm simulators utilisés en recherche insistent justement sur l’importance des liens entre climat, sol, cultures, élevage, décisions, budget et ressources partagées à l’échelle de l’exploitation.[^3_1][^3_2][^3_3][^3_4][^3_5][^3_6]

## 12 systèmes cœur

Je vous propose ces 12 systèmes centraux pour Agriva :


| Système | Rôle |
| :-- | :-- |
| Météo | Conditionne fenêtres de travaux, croissance, stress, risques [^3_2][^3_3][^3_5] |
| Sol | Gère eau, fertilité, structure, compaction, nutriments [^3_7][^3_3][^3_5] |
| Parcelles | Support spatial des cultures, états, historiques et interventions [^3_6] |
| Cultures | Croissance, stades, besoins, rendement, qualité [^3_3][^3_5][^3_8] |
| Élevage | Reproduction, alimentation, santé, production, bien-être [^3_1][^3_9] |
| Matériel | Disponibilité, puissance, compatibilité, consommation, usure [^3_10][^3_11] |
| Main-d’œuvre | Temps humain, compétences, planning, fatigue, disponibilité [^3_2][^3_6] |
| Stocks | Intrants, récoltes, aliments, capacité, pertes, conservation [^3_12][^3_3] |
| Logistique | Déplacements, chargement, distances, retards, livraison [^3_10] |
| Économie | Coûts fixes/variables, trésorerie, crédit, amortissement, marge [^3_3][^3_4][^3_9] |
| Marché \& contrats | Prix, volatilité, ventes, achats, engagements, services [^3_1][^3_4] |
| Décision \& planification | Plans annuels, arbitrages journaliers, règles et priorités [^3_2][^3_6] |

## Les indispensables MVP

Pour démarrer, il ne faut pas implémenter les 12 au même niveau de profondeur. Le MVP devrait surtout reposer sur 6 systèmes structurants, parce qu’ils suffisent à faire émerger une vraie boucle agricole crédible.[^3_2][^3_3][^3_6]

Je mettrais en priorité :

- météo ;
- parcelles ;
- cultures ;
- matériel ;
- économie ;
- décision / planification.

Avec seulement ces six-là, vous pouvez déjà produire une boucle puissante : choisir quoi semer, quand intervenir, avec quel matériel, sous quelles contraintes météo, pour quels coûts et quels résultats.[^3_5][^3_6][^3_2]

## Ce qui fera la différence

Si vous voulez dépasser SimAgri, la vraie différence ne viendra pas seulement du nombre de systèmes, mais de leur **interconnexion**. Les simulateurs agricoles sérieux mettent en avant le fait que les décisions du fermier doivent être reliées dynamiquement à l’état technique du système, à plusieurs échelles de temps, avec ajustement permanent selon climat, ressources et objectifs.[^3_4][^3_6][^3_2]

Autrement dit :

- une pluie tardive doit décaler une opération ;
- ce décalage doit impacter la culture ;
- cet impact doit modifier rendement, qualité ou calendrier ;
- cela doit avoir un effet économique et logistique ;
- le joueur doit devoir réarbitrer.

C’est cette chaîne de causalité qui donne la sensation de “vraie simulation”.[^3_3][^3_2][^3_5]

## Modèle de profondeur

Je vous conseille de penser chaque système sur 3 niveaux :

- **Niveau 1** : lisible et jouable.
- **Niveau 2** : plus de variables et d’arbitrages.
- **Niveau 3** : expertise et optimisation.

Exemple pour le sol :

- Niveau 1 : humidité, fertilité, compaction.
- Niveau 2 : azote, pH, structure, précédent cultural.
- Niveau 3 : dynamique plus fine par horizon ou pratiques agronomiques avancées.

Cette approche permet de rester tout public au départ, tout en gardant un vrai plafond de maîtrise pour les joueurs motivés.[^3_8][^3_13][^3_5]

## Ordre recommandé

Je vous propose cet ordre de construction :

1. Météo.
2. Parcelles.
3. Cultures.
4. Matériel.
5. Économie.
6. Planification.
7. Stocks.
8. Logistique.
9. Marché \& contrats.
10. Main-d’œuvre.
11. Élevage.
12. Sol approfondi et systèmes avancés.

Je place le **sol approfondi** plus tard non pas parce qu’il est secondaire, mais parce qu’il est très structurant et peut vite complexifier tout le reste. En MVP, un modèle de sol simplifié mais crédible est souvent plus efficace qu’un système très détaillé mais opaque.[^3_7][^3_5][^3_8]

## Étape suivante

La suite logique est de transformer ces 12 systèmes en **bounded contexts métier** pour Agriva, puis de définir pour chacun :

- ses entités ;
- ses états ;
- ses événements ;
- ses règles ;
- ses interactions avec les autres systèmes.

On peut commencer maintenant par les **6 systèmes MVP** et les spécifier proprement.
<span style="display:none">[^3_14][^3_15]</span>

<div align="center">⁂</div>

[^3_1]: https://blackland.tamu.edu/models/farmsim/

[^3_2]: https://agritrop.cirad.fr/552742/1/document_552742.pdf

[^3_3]: https://www.ars.usda.gov/northeast-area/up-pa/pswmru/docs/integrated-farm-system-model/

[^3_4]: https://www.athanasiadis.info/assets/pdf/seamless2010fssim.pdf

[^3_5]: https://era.dpi.qld.gov.au/id/eprint/8478/

[^3_6]: https://www.mssanz.org.au/modsim09/B3/deVoil.pdf

[^3_7]: https://www.nature.com/nature-index/topics/l3/agricultural-production-systems-simulation

[^3_8]: https://ftsm.ukm.my/v6/public/assets/file/technicalreport/A186091_TReport.pdf

[^3_9]: https://www.ars.usda.gov/ARSUserFiles/np212/LivestockGRACEnet/IFSM.pdf

[^3_10]: https://www.thegamer.com/most-realistic-farming-simulators-ranked/

[^3_11]: https://www.galaxus.at/en/page/not-complex-enough-study-criticises-the-farming-simulator-38777

[^3_12]: https://gamecritix.co.uk/farm-supply-simulator-25-review/

[^3_13]: https://acsess.onlinelibrary.wiley.com/doi/10.1002/nse2.20058

[^3_14]: https://www.facebook.com/proagri/posts/make-better-decisions-with-boernetfarmers-data-on-soil-weather-crops-livestock-a/1562342002562301/

[^3_15]: https://www.sciencedirect.com/science/article/pii/S2949736125001332


---

# Je pense aussi à 2 mode de jeu le normal et expert pour un même serveur le joueur choisi et son choix est fixe pour toute la saison. Dans le normal on enlève un niveau de complexité et la productivité est à 100% par défaut mais en mode expert on peut monter jusque 130% mais aussi tomber sous les 80% qu’e pense tu ?

Je trouve l’idée **très bonne**, avec une condition importante : il faut que ce soit un choix de **lisibilité et de profondeur**, pas un mode “facile” contre un mode “fort”. Dans un même serveur multijoueur, deux modes peuvent coexister si vous simplifiez la charge cognitive en normal, tout en gardant une base économique comparable pour éviter un déséquilibre social ou marchand trop fort.[^4_1][^4_2][^4_3][^4_4]

## Ce qui marche bien

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
