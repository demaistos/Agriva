# Agriva GDD — Farming — Logique Culturale
> Cycle complet d'une culture, fiche blé Normal, conditions de réussite, pénalités, interface

---


---

# Je veux aussi tout la logique game design que ce passe t’il si je veux faire une culture quelles sont toute les étapes de quoi ai je besoin combien de temps ça va me prendre etc etc

Oui — et c’est un point **central** du game design. Pour Agriva, il ne faut pas seulement définir des systèmes abstraits ; il faut modéliser la logique opérationnelle complète d’un atelier, par exemple “je veux faire du blé” : de quoi ai-je besoin, dans quel ordre, sous quelles conditions, combien de temps cela prend, quels sont les risques, et quelles conséquences si je me trompe. Les références sur les opérations culturales montrent justement qu’une culture suit une séquence structurée : préparation, implantation, nutrition, protection, suivi, récolte, logistique et commercialisation.[^15_1][^15_2][^15_3][^15_4][^15_5][^15_6]

## Cycle complet d’une culture

J’ai généré un fichier CSV qui récapitule ce cycle complet étape par étape .


| Étape | Nom | Ce qu’il se passe |
| --: | :-- | :-- |
| 1 | Choix de culture | Le joueur choisit une culture selon saison, parcelle, objectifs et marché. |
| 2 | Analyse parcelle | Il vérifie l’état technique de la parcelle et la météo à venir. |
| 3 | Plan de campagne | Il planifie dates, intrants, matériel, main-d’œuvre et budget. |
| 4 | Préparation du sol | Il prépare le terrain selon le système cultural retenu. |
| 5 | Correction parcelle | Il applique éventuellement des amendements ou corrections. |
| 6 | Approvisionnement | Il achète ou réserve semences, intrants, carburant, etc. |
| 7 | Semis / plantation | Il implante la culture dans la bonne fenêtre. |
| 8 | Fertilisation initiale | Il réalise le premier apport si nécessaire. |
| 9 | Levée / installation | La culture démarre et devient sensible aux conditions. |
| 10 | Protection / entretien | Le joueur gère adventices, maladies, irrigation, entretien. |
| 11 | Suivi croissance | Il suit les stades, stress, rendement potentiel et retards. |
| 12 | Arbitrages en cours | Il ajuste sa stratégie selon météo, prix et état de la culture. |
| 13 | Récolte | Il récolte dans une fenêtre optimale. |
| 14 | Transport / stockage | Il gère la logistique post-récolte. |
| 15 | Vente / contractualisation | Il vend, stocke ou livre en contrat. |
| 16 | Bilan de campagne | Il compare prévu/réalisé et prépare la suite. |

## Ce que cela implique en jeu

Une culture dans Agriva ne doit donc pas être un bouton “semer -> attendre -> récolter”. Elle doit être un **workflow métier complet**, avec prérequis, dépendances, ressources, durée, risques et arbitrages en cours de route, comme dans les templates d’opérations culturales et les modèles de planification agricole.[^15_4][^15_7][^15_6]

Concrètement, quand un joueur veut lancer une culture, le jeu doit pouvoir répondre à ces questions :

- ai-je la bonne parcelle ?
- est-ce la bonne période ?
- ai-je le bon matériel ?
- ai-je les bons intrants ?
- ai-je le temps et l’équipe ?
- la météo et l’état du sol me permettent-ils d’agir ?
- quel sera le coût ?
- quel sera le temps estimé ?
- quels risques je prends si je lance quand même ?


## Ce qu’il faut afficher au joueur

Pour chaque culture, Agriva devrait proposer une **fiche d’itinéraire technique** avec :

- étapes obligatoires ;
- étapes optionnelles ;
- ressources nécessaires ;
- durée estimée ;
- fenêtre optimale ;
- risques en cas de retard ou d’erreur ;
- rendement et qualité potentiels.

C’est exactement le type de logique que les systèmes de simulation et d’aide à la décision agricole cherchent à formaliser, avec des séquences d’opérations liées à la météo, au sol et au calendrier.[^15_3][^15_6][^15_4]

## Normal vs Expert

Cette logique se prête très bien à vos deux modes :

- en **Normal**, le joueur voit un itinéraire simplifié, avec recommandations claires et étapes regroupées ;
- en **Expert**, il voit le détail complet, avec plus d’options techniques, plus de dépendances et plus de variance sur le résultat.[^15_8][^15_6][^15_1]


## Ce qu’il faut modéliser dans le moteur

Pour chaque culture, je vous conseille de définir au minimum :

- un **template cultural** ;
- une liste d’**opérations possibles** ;
- les **préconditions** de chaque opération ;
- les **ressources** consommées ;
- la **durée théorique** ;
- les **modificateurs de durée** ;
- les **effets** sur parcelle et culture ;
- les **pénalités** si hors fenêtre ;
- les **issues** finales : rendement, qualité, coût, marge.


## Règle de design Agriva

Je vous propose cette règle simple :

**Une culture = un plan vivant d’opérations sous contraintes.**

C’est probablement l’une des clés les plus fortes pour faire un jeu plus réaliste que SimAgri tout en restant jouable, parce que le joueur comprend enfin la culture comme une chaîne de décisions et non comme un simple état.[^15_2][^15_6][^15_4]

## Suite logique

La prochaine étape la plus utile est de transformer cette logique en **fiche type d’une première culture**, par exemple **blé**, avec :

- toutes les étapes ;
- tous les besoins ;
- toutes les durées ;
- toutes les dépendances ;
- les variantes Normal / Expert.
<span style="display:none">[^15_10][^15_11][^15_12][^15_13][^15_14][^15_15][^15_9]</span>

<div align="center">⁂</div>

[^15_1]: https://www.farming-simulator.com/newsArticle.php?news_id=298

[^15_2]: https://vtechworks.lib.vt.edu/server/api/core/bitstreams/65709072-179b-4808-8ee5-16a9e21e964c/content

[^15_3]: https://www.apsim.info/clem/Content/Features/Activities/Crop/ManagingCropping.htm

[^15_4]: https://www.logineko.com/knowledge/enhancing-field-operation-planning-with-cultivation-templates/

[^15_5]: https://livefarmer.co.uk/the-7-steps-in-the-modern-farming-lifecycle/

[^15_6]: https://users.aalto.fi/~ttoksane/pub/2010_ICPA2010.pdf

[^15_7]: https://edepot.wur.nl/202729

[^15_8]: https://www.reddit.com/r/farmingsimulator/comments/18f1n2m/order_of_operations_for_precision_farming/

[^15_9]: https://www.reddit.com/r/farmingsimulator/comments/1gr2efq/correct_sequence_for_farming/

[^15_10]: https://steamcommunity.com/app/1248130/discussions/0/4147320315762756074/?l=greek

[^15_11]: https://www.facebook.com/100064654106728/posts/the-lifecycle-of-a-crop-7-steps-in-the-modern-farming-ecosystemthe-modern-farmin/960303199468141/

[^15_12]: https://www.thegamer.com/farming-simulator-25-seasonal-farming-every-crop-month/

[^15_13]: https://www.gamepressure.com/farmingsimulator17/from-sowing-to-harvesting/z592c7

[^15_14]: https://www.farming-simulator.com/newsArticle.php?news_id=297

[^15_15]: https://ag.purdue.edu/usda/gl/ceap-page/section-i-field-operatons.pdf


---

# On se focus sur le mode normal pour le moment et continue

D’accord, on se concentre sur le **mode Normal** et on continue en gardant une logique simple, lisible et pédagogique. Pour ce mode, il faut transformer une culture en une suite d’étapes compréhensibles, avec aides, estimations de temps et besoins clairement affichés, sans noyer le joueur dans toute la profondeur technique dès le départ.[^16_1][^16_2][^16_3][^16_4]

## Fiche culture Normal

Je vous propose qu’en mode Normal, chaque culture soit décrite par une **fiche de conduite simplifiée** avec 6 blocs :

1. Choisir la culture.
2. Préparer la parcelle.
3. Semer.
4. Entretenir.
5. Récolter.
6. Vendre ou stocker.

Cette structure correspond bien aux séquences simplifiées qu’on retrouve dans les tutoriels de farming games pour débutants, où l’on enchaîne préparation du sol, semis, fertilisation, désherbage puis récolte.[^16_2][^16_3][^16_1]

## Exemple blé Normal

Pour une première culture type **blé**, la logique peut être la suivante :


| Étape | Ce qu’il faut | Temps jeu estimé | Résultat attendu |
| :-- | :-- | --: | :-- |
| Choix | Parcelle libre, saison correcte, semences, budget | immédiat | Plan de culture créé |
| Préparation | Tracteur + outil de préparation, parcelle praticable | quelques heures à 1 jour | Parcelle prête |
| Semis | Tracteur + semoir + semences | quelques heures à 1 jour | Culture implantée |
| Entretien | Engrais simple, éventuellement désherbage | sur plusieurs jours / semaines | Rendement sécurisé |
| Récolte | Moissonneuse + benne ou stockage | quelques heures à 1 jour | Production récoltée |
| Vente / stockage | Contrat, silo ou marché | immédiat à quelques jours | Recette ou stock |

Les références “Crops 101” sur le blé montrent bien une séquence simplifiée de type chaulage éventuel, préparation, semis, roulage éventuel, fertilisation, désherbage puis récolte.[^16_3][^16_1][^16_2]

## Ce que le jeu doit calculer

En mode Normal, quand le joueur clique sur “planter du blé”, le jeu doit lui afficher automatiquement :

- si la culture est possible maintenant ;
- la liste des ressources manquantes ;
- le matériel nécessaire ;
- le temps total estimé ;
- le coût estimé ;
- la date probable de récolte ;
- un niveau de risque simple, faible / moyen / élevé.

Cela suit bien l’objectif d’un mode pédagogique : montrer la logique d’une culture sans obliger le joueur à faire lui-même tous les calculs cachés.[^16_4][^16_5]

## Temps en mode Normal

Je vous conseille de garder un temps **agrégé** et compréhensible. Par exemple :

- préparation : X heures ou X % de journée ;
- semis : X heures ;
- entretien : événements ponctuels à traiter ;
- croissance : phase passive avec alertes ;
- récolte : gros moment actif.

L’idée est que le joueur sente qu’une culture prend du temps à l’échelle de la saison, mais sans devoir microgérer chaque minute. Les tutoriels et guides débutants de farming sim insistent justement sur une séquence simple d’actions clés plutôt que sur une micro-simulation continue.[^16_6][^16_2][^16_3]

## Aides du mode Normal

Pour ce mode, je mettrais en place :

- une checklist des étapes ;
- des alertes “vous pouvez semer”, “il faut fertiliser”, “récolte prête” ;
- une estimation de coût et rendement ;
- un bouton “plan recommandé” ;
- un diagnostic simple si quelque chose bloque.

Ainsi, le joueur apprend progressivement la logique agricole réelle, mais avec une interface de pilotage claire.[^16_7][^16_1][^16_4]

## Règle de design

Je vous propose cette règle pour le mode Normal :

**Une culture doit être compréhensible en 30 secondes, jouable en quelques clics, mais avoir des conséquences sur plusieurs semaines de jeu.**

C’est probablement la meilleure base pour rendre Agriva accessible sans le rendre creux.[^16_8][^16_5]

## Étape suivante

Le meilleur enchaînement maintenant est de construire la **fiche complète du blé en mode Normal**, avec :

- besoins exacts ;
- ordre des étapes ;
- coûts estimés ;
- durées ;
- conditions de réussite ;
- pénalités simples si le joueur rate une étape.
<span style="display:none">[^16_10][^16_11][^16_12][^16_13][^16_14][^16_15][^16_16][^16_9]</span>

<div align="center">⁂</div>

[^16_1]: https://www.farming-simulator.com/newsArticle.php?news_id=619

[^16_2]: https://www.farming-simulator.com/newsArticle.php?news_id=298

[^16_3]: https://www.youtube.com/watch?v=42uj5ztrmgA

[^16_4]: https://gamedevacademy.org/unity-farm-crop-tutorial/

[^16_5]: https://onewheelstudio.com/blog/2017/3/24/building-a-game-loop

[^16_6]: https://www.youtube.com/watch?v=IBVOD_HNSb4

[^16_7]: https://www.farming-simulator.com/newsArticle.php?news_id=280

[^16_8]: https://www.reddit.com/r/gamedesign/comments/j6jyg9/if_you_were_going_to_design_the_simplest/

[^16_9]: https://www.reddit.com/r/farmingsimulator/comments/1g985xe/order_of_planting/

[^16_10]: https://forum.giants-software.com/viewtopic.php?t=180776

[^16_11]: https://prepp.in/question/arrange-the-following-farming-processes-in-a-logic-6453cfa6b66a14c00534ba3b

[^16_12]: https://www.fao.org/4/y5146e/y5146e0a.htm

[^16_13]: https://steamcommunity.com/app/2300320/discussions/0/4638239054524077431/

[^16_14]: https://egritech.org/en/grain-crops-timing-and-harvesting-phase/

[^16_15]: https://farmingsimulator.fandom.com/wiki/Wheat/Farming_Simulator_22

[^16_16]: https://shiningrocksoftware.com/2013-05-07-game-design-flux-or-how-i-learned-virtual-crop-rotation-isnt-fun/


---

# Ok

Très bien. On formalise maintenant la **fiche complète du blé en mode Normal**, parce que c’est un bon modèle pour construire ensuite les autres cultures. Les guides blé des farming sims présentent une séquence simple et pédagogique : préparation, semis, roulage éventuel, fertilisation, désherbage, récolte, puis vente ou transformation.[^17_1][^17_2][^17_3]

## Fiche blé Normal

J’ai généré un CSV structuré de cette conduite simplifiée .


| Étape | Description gameplay | Besoins | Temps estimé |
| :-- | :-- | :-- | :-- |
| Vérifier faisabilité | Vérifier si le blé est pertinent maintenant | Parcelle libre, saison, budget, semences | immédiat |
| Préparer le chantier | Le jeu estime matériel et durée | Tracteur, outils, main-d’œuvre | immédiat |
| Préparer la parcelle | Préparation simplifiée du sol | Matériel, météo correcte | quelques heures à 1 jour |
| Semer le blé | Implantation dans la bonne fenêtre | Semoir, tracteur, semences | quelques heures à 1 jour |
| Rouler / finaliser | Option recommandée | Outil léger | quelques heures |
| Fertiliser | Apport simple recommandé | Engrais, matériel, budget | quelques heures |
| Gérer les adventices | Traitement simplifié si besoin | Produit, pulvérisateur, météo | quelques heures |
| Attendre et surveiller | Croissance avec alertes | Temps, météo, état parcelle | jours à semaines |
| Récolter | Récolte à maturité | Moissonneuse, coupe, logistique | quelques heures à 1 jour |
| Transporter / stocker | Évacuer et stocker | Remorque, silo ou point de vente | quelques heures |
| Vendre ou conserver | Choix économique | Marché ou stockage | immédiat à quelques jours |
| Bilan culture | Résultat lisible | Campagne terminée | immédiat |

## Logique de design

En mode Normal, le but n’est pas de montrer toute la complexité réelle du blé, mais de rendre la culture **pilotable**. Les tutoriels Farming Simulator montrent bien qu’un joueur débutant a surtout besoin de comprendre l’ordre logique des opérations et le matériel requis pour avancer sans se bloquer.[^17_2][^17_4][^17_3]

## Ce que le jeu doit calculer

Pour cette fiche, Agriva devrait calculer automatiquement :

- le **coût estimé** de la campagne ;
- le **temps total estimé** ;
- le **matériel requis** ;
- les **ressources manquantes** ;
- la **date estimée de récolte** ;
- le **niveau de risque global**.

Les références sur le blé montrent aussi que la durée entre semis et récolte varie fortement selon type de blé et contexte, avec des cycles d’environ 100 à 130 jours pour du blé de printemps et 180 à 250 jours pour du blé d’hiver. Pour Agriva, en mode Normal, il vaut mieux traduire cela en “fenêtres de saison” claires plutôt qu’en physiologie détaillée.[^17_5][^17_6]

## Conditions de réussite

Je vous propose des règles très simples pour le mode Normal :

- semer dans la bonne période ;
- disposer du bon matériel ;
- ne pas trop retarder les étapes clés ;
- faire au moins un entretien recommandé ;
- récolter dans une fenêtre correcte.

Si ces conditions sont remplies, le joueur obtient une culture “réussie”, même sans optimisation fine. Cela correspond bien à votre objectif d’un mode accessible mais crédible.[^17_7][^17_1]

## Pénalités simples

Les pénalités doivent être lisibles :

- semis tardif = baisse de rendement ;
- manque d’entretien = baisse modérée de rendement/qualité ;
- récolte tardive = pertes ;
- absence de logistique = retard de vente ou surcharge.

Cela suit bien la logique des farming sims et des cycles blé réels, où le timing reste un facteur décisif.[^17_8][^17_9][^17_2]

## Interface idéale

Pour le mode Normal, la fiche blé devrait afficher :

- une **checklist** des étapes ;
- un **pourcentage d’avancement** ;
- un **coût prévisionnel** ;
- une **date cible de récolte** ;
- des **alertes simples** ;
- un bouton **“plan recommandé”**.

C’est probablement la meilleure manière d’enseigner la logique agricole sans créer un mur de complexité.[^17_10][^17_11]

## Étape suivante

Le meilleur enchaînement maintenant est de créer la même chose pour une deuxième culture, par exemple **maïs** ou **colza**, afin de commencer à construire une vraie bibliothèque d’itinéraires techniques simplifiés pour Agriva.
<span style="display:none">[^17_12][^17_13][^17_14][^17_15][^17_16][^17_17][^17_18]</span>

<div align="center">⁂</div>

[^17_1]: https://www.farming-simulator.com/newsArticle.php?news_id=619

[^17_2]: https://www.farming-simulator.com/newsArticle.php?news_id=298

[^17_3]: https://www.youtube.com/watch?v=42uj5ztrmgA

[^17_4]: https://www.youtube.com/watch?v=k2hUiEVPYKI

[^17_5]: https://www.cropler.io/blog-posts/wheat-growth-stages-and-associated-management

[^17_6]: https://eos.com/blog/growing-wheat/

[^17_7]: https://www.reddit.com/r/farmingsimulator/comments/t6puh1/how_do_i_do_a_full_harvest/

[^17_8]: https://www.hylandhybridseeds.com/en/blog/wheat-crop-duration-guide/

[^17_9]: https://egritech.org/en/grain-crops-timing-and-harvesting-phase/

[^17_10]: https://www.farming-simulator.com/newsArticle.php?news_id=280

[^17_11]: https://gamedevacademy.org/unity-farm-crop-tutorial/

[^17_12]: https://www.youtube.com/playlist?list=PL8MrMOUUSmO_reafgM8LcmAtYJjn0OZPr

[^17_13]: https://www.sciencedirect.com/science/article/abs/pii/S0261219421002295

[^17_14]: https://stepupsoy.osu.edu/wheat-production/wheat-growth-stages-and-associated-management

[^17_15]: https://www.scirp.org/journal/paperinformation?paperid=33553

[^17_16]: https://www.youtube.com/watch?v=SqvWtjW6aIs

[^17_17]: http://eagri.org/eagri50/AGRO302/lec04.pdf

[^17_18]: https://www.youtube.com/watch?v=_ng2HgOeW88


---

# Quel est la temporalité dans le jeu ? Car on ne peut pas utiliser l’échelle réel les joueur vont trouver ça trop long