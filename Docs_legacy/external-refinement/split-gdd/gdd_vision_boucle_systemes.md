# Agriva GDD — Vision — Boucle & 12 Systèmes
> Vision produit, fantasy joueur, boucle jour/semaine/saison, 12 systèmes cœur, MVP

---

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