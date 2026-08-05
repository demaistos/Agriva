# Agriva GDD — Farming Systems
> Météo/Parcelles/Cultures, Matériel/Travaux/Temps, Temporalité, Calendrier annuel, Workflow semer
> Lignes source : 710–3441

---

# Ok

Parfait. On peut maintenant poser le premier triptyque cœur d’Agriva : **Météo -> Parcelles -> Cultures**. C’est probablement la chaîne la plus importante pour donner une vraie sensation de simulation agricole, car les modèles agronomiques relient justement la météo, l’eau du sol, l’état de la parcelle, le calendrier des travaux et le rendement final.[^7_1][^7_2][^7_3][^7_4][^7_5]

## Logique métier

La logique simple à retenir est :

- la **météo** crée les conditions ;
- la **parcelle** stocke et transforme ces conditions localement ;
- la **culture** réagit à cet état au fil du temps.

Les travaux de simulation agricole montrent que des variables comme pluie, température, humidité du sol, stress hydrique, calendrier et événements extrêmes influencent directement croissance, qualité et rendement.[^7_6][^7_3][^7_4][^7_7][^7_1]

## Météo

Le système météo ne doit pas être seulement décoratif. Il doit agir comme une source quotidienne de contraintes et d’opportunités sur les fenêtres de semis, de traitement, d’irrigation, de récolte et sur les risques de stress ou de perte.[^7_8][^7_7][^7_6]

Je proposerais pour Agriva :

- pluie ;
- température min/max ;
- humidité ;
- vent ;
- rayonnement simplifié ;
- événements spéciaux, gel, canicule, excès d’eau, sécheresse.


### Normal

- indicateur météo simple ;
- fenêtres “bon / moyen / mauvais” pour les travaux ;
- risques affichés clairement ;
- effets agrégés.


### Expert

- météo plus fine ;
- enchaînements météo plus déterminants ;
- effets plus sensibles sur qualité, retard, pertes et choix techniques.[^7_4][^7_6][^7_8]


## Parcelles

La parcelle est le point de convergence entre météo, historique et interventions. Les études de simulation insistent sur le fait que le même épisode météo ne produit pas le même résultat selon le type de sol, l’état hydrique, la structure et l’historique de gestion.[^7_9][^7_10][^7_11][^7_12]

Je proposerais que chaque parcelle possède au minimum :

- surface ;
- type de sol ;
- humidité ;
- fertilité ;
- compaction ;
- historique de culture ;
- état d’occupation ;
- accessibilité / portance.


### Normal

- quelques indicateurs synthétiques ;
- état global facile à lire ;
- historique simplifié ;
- moins de pénalités croisées.


### Expert

- davantage d’états internes ;
- précédent cultural plus important ;
- effets plus fins de compaction, humidité et timing ;
- identité technique plus marquée d’une parcelle à l’autre.[^7_11][^7_12][^7_9]


## Cultures

La culture doit être le système visible par le joueur, celui qui transforme ses décisions en résultats concrets. Les modèles de culture utilisent souvent des stades de développement, des besoins thermiques, l’eau disponible, le stress et le calendrier des opérations pour faire varier croissance et rendement.[^7_2][^7_13][^7_3][^7_4]

Je verrais pour chaque culture :

- stades phénologiques ;
- besoin en temps / chaleur ;
- besoin en eau ;
- sensibilité au stress ;
- potentiel de rendement ;
- qualité ;
- fenêtre optimale de travaux.


### Normal

- stades lisibles ;
- besoins résumés ;
- conseil clair sur les prochaines actions ;
- pénalités modérées.


### Expert

- plus de stades ou sous-états ;
- sensibilité plus fine aux écarts de date ;
- qualité et rendement plus dépendants de la conduite ;
- plus d’interactions avec météo et parcelle.[^7_14][^7_2][^7_4]


## Règle de causalité Agriva

Je vous propose cette règle fondatrice :

1. La météo du jour modifie l’état de la parcelle.
2. L’état de la parcelle modifie la réponse de la culture.
3. Les actions du joueur modifient à leur tour la parcelle et la culture.
4. Le rendement, la qualité et le calendrier futur découlent de cette chaîne.

Cette causalité est essentielle, car elle évite l’effet “barres de progression arbitraires” et donne au joueur l’impression d’agir sur un vrai système agricole.[^7_7][^7_1][^7_6]

## Version gameplay

Pour rester jouable, je conseille d’afficher au joueur non pas toutes les variables brutes, mais trois niveaux d’information :

- **vue simple** : feu vert / orange / rouge ;
- **vue gestion** : causes principales et conséquences ;
- **vue expert** : détail des facteurs techniques.

Cela colle très bien à votre idée de cohabitation Normal / Expert sur un même serveur : la simulation peut être profonde en interne, mais exposée différemment selon le mode choisi.[^7_15][^7_16][^7_17]

## Étape suivante

Le prochain bloc logique est **Matériel -> Travaux -> Temps d’exécution**, car c’est lui qui transforme la décision agronomique en action concrète sur l’exploitation.
<span style="display:none">[^7_18]</span>

<div align="center">⁂</div>

[^7_1]: https://agridots.com/courses/bsc-agriculture/electives/elec11-system-simulation-and-agro-advisory/03-weather-based-crop-simulation

[^7_2]: https://acsess.onlinelibrary.wiley.com/doi/10.1002/agg2.20453

[^7_3]: https://www.nature.com/articles/s41598-025-20211-6

[^7_4]: https://homo-deus.com/lab/agriculture/yield-prediction/

[^7_5]: https://theses.hal.science/tel-04009518v1/file/DINH_Thi_Lan_Anh_2022.pdf

[^7_6]: https://www.cordulus.com/blog/weather-monitoring-for-precision-agriculture

[^7_7]: https://www.scirp.org/journal/paperinformation?paperid=125112

[^7_8]: https://rynanagriculture.com/news-blogs/how-to-leverage-weather-monitoring-for-precision-agriculture

[^7_9]: https://odjar.org/article/download/15741/18018/20925

[^7_10]: https://www.sciencedirect.com/science/article/pii/S1110982323000303

[^7_11]: https://meetingorganizer.copernicus.org/DKT-10/DKT-10-8-1.pdf

[^7_12]: https://www.sciencedirect.com/science/article/pii/S2772375525002059

[^7_13]: https://arxiv.org/html/2404.00528v1

[^7_14]: https://www.nature.com/articles/s41598-021-90835-x

[^7_15]: https://www.youtube.com/watch?v=KspGk0L-eYI

[^7_16]: https://www.maxapress.com/article/id/677b3d46fa6c58500c875ec2

[^7_17]: https://www.gamedeveloper.com/design/the-rld-handbook-sometimes-it-s-not-about-the-metrics---depth-complexity

[^7_18]: https://www.ijltemas.in/DigitalLibrary/Vol.13Issue2/19-28.pdf


---

# Ok

Très bien. On peut poser maintenant le deuxième grand bloc d’Agriva : **Matériel -> Travaux -> Temps d’exécution**. Les modèles de gestion agricole montrent clairement que la capacité machine, les jours ouvrables selon la météo, la largeur de travail, l’efficacité réelle, la main-d’œuvre et le respect des fenêtres d’intervention ont un impact direct sur les coûts et la performance globale de l’exploitation.[^8_1][^8_2][^8_3][^8_4][^8_5]

## Logique métier

La logique à retenir est simple :

- le **matériel** donne une capacité théorique ;
- les **travaux** consomment cette capacité dans une fenêtre donnée ;
- le **temps d’exécution réel** dépend de la météo, de la parcelle, de la disponibilité et de l’organisation.

Les recherches sur la capacité de chantier et la timeliness montrent que ce n’est pas seulement “avoir un tracteur”, mais surtout pouvoir finir le bon travail au bon moment avec le bon équipement.[^8_2][^8_6][^8_4][^8_1]

## Matériel

Le matériel doit être un système de décision, pas juste une collection d’objets. Dans une vraie exploitation, le choix d’un tracteur, d’un semoir ou d’une moissonneuse engage la puissance disponible, la vitesse de travail, l’usure, les coûts fixes et la capacité à respecter les fenêtres critiques.[^8_7][^8_8][^8_2]

Je vous propose pour chaque matériel :

- type ;
- puissance ;
- largeur de travail ;
- compatibilités ;
- vitesse de chantier ;
- consommation ;
- usure ;
- fiabilité ;
- coût fixe et variable ;
- disponibilité.


### Normal

- compatibilité simplifiée ;
- performance affichée clairement ;
- peu de réglages ;
- pannes rares ou agrégées.


### Expert

- performance plus contextuelle ;
- compatibilités plus fines ;
- effets de sous-dimensionnement ;
- pannes, usure et entretien plus structurants.[^8_9][^8_10]


## Travaux

Le travail agricole doit être défini comme une **opération avec prérequis, ressources et fenêtre optimale**. Les études sur la planification des opérations agricoles insistent justement sur les contraintes de date, de ressource et de conditions de terrain.[^8_6][^8_11][^8_5][^8_7]

Chaque travail devrait comporter :

- type d’opération, semis, labour, pulvérisation, récolte, etc. ;
- parcelle cible ;
- ressources requises ;
- durée estimée ;
- fenêtre idéale ;
- conditions minimales de faisabilité ;
- effet attendu sur parcelle ou culture.


### Normal

- le jeu propose directement les travaux possibles ;
- les prérequis sont visibles ;
- la durée est simple à comprendre ;
- les pénalités de mauvais timing sont modérées.


### Expert

- davantage de dépendances entre travaux ;
- fenêtres plus serrées ;
- conséquences plus fortes d’un mauvais séquencement ;
- plus d’impact des choix techniques.[^8_11][^8_1][^8_6]


## Temps d’exécution

C’est là que la simulation devient vraiment crédible. Les travaux agricoles réels ne se déroulent pas dans un temps abstrait ; ils dépendent des jours réellement travaillables, de l’humidité du sol, des distances, des ruptures de disponibilité, des aléas météo et de l’organisation globale.[^8_3][^8_12][^8_5][^8_9]

Je proposerais que le temps d’exécution réel dépende de :

- taille de la parcelle ;
- capacité machine ;
- efficacité de chantier ;
- conditions météo ;
- portance / état de la parcelle ;
- disponibilité du matériel ;
- éventuels conflits de planning.


### Normal

- estimation assez stable ;
- peu d’interruptions ;
- jours travaillables simplifiés ;
- faible variance.


### Expert

- vraies fenêtres de travail ;
- retards dynamiques ;
- interruptions météo ;
- conflits de ressources ;
- coût de retard plus fort.[^8_12][^8_5][^8_1][^8_3]


## Règle de causalité Agriva

Je vous propose cette règle fondatrice :

1. Une culture a besoin d’un travail dans une fenêtre donnée.
2. Ce travail exige un matériel compatible et disponible.
3. Le temps réel dépend des conditions de chantier.
4. Si le travail est retardé ou mal exécuté, la parcelle et la culture en subissent les conséquences.
5. Ces conséquences reviennent ensuite dans l’économie et la planification.

C’est cette chaîne qui transforme un simple “clic pour semer” en vraie décision de gestion agricole.[^8_1][^8_3][^8_11][^8_9]

## Gameplay

Pour que ce soit lisible, je vous conseille 3 vues :

- **vue action** : “je peux lancer ce travail maintenant” ;
- **vue planning** : “je peux finir ce chantier dans la bonne fenêtre ou non” ;
- **vue analyse** : “pourquoi j’ai perdu du temps ou du rendement”.

Cela permet au grand public de jouer sans être noyé, tout en donnant aux joueurs experts un vrai espace d’optimisation.[^8_5][^8_13][^8_14]

## Étape suivante

Le bloc suivant est **Économie -> Coûts -> Marché**, car une simulation agricole crédible ne vaut que si les conséquences techniques se transforment en conséquences financières.
<span style="display:none">[^8_15][^8_16][^8_17]</span>

<div align="center">⁂</div>

[^8_1]: https://www.sciencedirect.com/science/article/abs/pii/S1537511005001261

[^8_2]: https://www.extension.iastate.edu/agdm/crops/pdf/a3-24.pdf

[^8_3]: https://pure.psu.edu/en/publications/predicting-suitable-days-for-field-machinery-operations-in-a-whol/

[^8_4]: https://extension.purdue.edu/extmedia/ID/ID-155.html

[^8_5]: https://edepot.wur.nl/202729

[^8_6]: https://rae.agriculturejournals.cz/pdfs/rae/2018/04/04.pdf

[^8_7]: https://era.ed.ac.uk/handle/1842/27322

[^8_8]: https://uknowledge.uky.edu/cgi/viewcontent.cgi?article=1020\&context=aen_reports

[^8_9]: https://www.scirp.org/journal/paperinformation?paperid=63680

[^8_10]: https://publications.slu.se/?file=publ%2Fshow\&id=2274

[^8_11]: https://www.sciencedirect.com/science/article/abs/pii/S1537511025001242

[^8_12]: https://www.sciencedirect.com/science/article/abs/pii/S0308521X23000082

[^8_13]: https://www.youtube.com/watch?v=KspGk0L-eYI

[^8_14]: https://ecampusontario.pressbooks.pub/gamedesigndevelopmenttextbook/chapter/hierarchy-of-challenges/

[^8_15]: https://www.nda.gov.za/images/Branches/Economica Development Trade and Marketing/Statistc and  Economic Analysis/economic-analysis/2015-2016-guide-to-machinery-costs-field-capacity-explain-table-.pdf

[^8_16]: https://www.academia.edu/figures/22979550/table-4-parameters-and-values-assumed-to-estimate-timeliness

[^8_17]: https://rpsonline.com.sg/proceedings/esrel-sra-e2025/pdf/ESREL-SRA-E2025-P1479.pdf


---

# Ok

Parfait. On peut poser le troisième bloc : **Économie -> Coûts -> Marché**. Les simulateurs agricoles et les jeux de gestion sérieux montrent que la rentabilité ne dépend pas seulement de produire, mais surtout d’aligner production, timing, prix, coûts, contrats et trésorerie.[^9_1][^9_2][^9_3][^9_4][^9_5]

## Logique métier

Le joueur doit comprendre que l’agriculture est un système de marge. Les revenus viennent des cultures, de l’élevage, des services et de la transformation, mais ils sont absorbés par les coûts d’intrants, de main-d’œuvre, de matériel, de transport, de stockage et d’aléas.[^9_2][^9_6][^9_3][^9_4][^9_7]

La logique Agriva doit donc être :

- produire ;
- vendre au bon moment ;
- payer le coût réel de la production ;
- absorber les risques ;
- protéger la trésorerie.


## Économie

Je vous recommande de séparer l’économie en 5 couches :

1. **Revenus** : ventes de récoltes, animaux, produits transformés, services.
2. **Coûts variables** : semences, aliments, carburant, soins, énergie, transport.
3. **Coûts fixes** : amortissement, entretien, assurances, charges structurelles.
4. **Trésorerie** : argent disponible, flux entrants/sortants, crédit éventuel.
5. **Résultat** : marge brute, marge nette, bilan saisonnier.

Les jeux de simulation agricole qui enseignent l’économie insistent justement sur le fait qu’il faut apprendre à comparer coûts, revenus et liquidité dans le temps, pas seulement le profit final.[^9_6][^9_4][^9_7][^9_2]

## Marché

Le marché doit être dynamique, mais lisible. Les simulations de marché agricole utilisent souvent des prix variables, des attentes de marché, des contrats, des stratégies de couverture et des effets de saison ou d’offre/demande.[^9_8][^9_3][^9_9][^9_10][^9_1]

Pour Agriva, je proposerais :

- marché spot ;
- contrats à terme simplifiés ;
- prix régionaux ;
- variation par saison ;
- qualité influençant le prix ;
- pénalités ou bonus liés au timing ;
- possibilité de livraisons contractuelles.


## Normal vs Expert

### Normal

- prix moins volatils ;
- aide à la décision forte ;
- coûts mieux agrégés ;
- trésorerie plus lisible ;
- moins d’outils financiers.


### Expert

- variation plus forte des prix ;
- écart plus net entre bon et mauvais timing ;
- contrats plus stratégiques ;
- coûts indirects plus visibles ;
- meilleure lecture du risque marché.[^9_3][^9_9][^9_10][^9_1][^9_8]


## Règle de causalité Agriva

Je vous propose cette règle simple :

1. La production crée un volume et une qualité.
2. Le marché donne un prix selon contexte et timing.
3. Les coûts réduisent la marge.
4. La trésorerie détermine la capacité à survivre et investir.
5. Les mauvais choix peuvent être sauvés par une bonne gestion, mais jamais gratuitement.

Cette logique est essentielle si vous voulez un jeu de simulation crédible et pas seulement un “jeu de ferme” décoratif.[^9_4][^9_7][^9_2][^9_6]

## Découpage gameplay

Je verrais 3 vues :

- **vue caisse** : état simple, argent, coûts, recettes, tension de trésorerie ;
- **vue décision** : vendre maintenant, stocker, contracter, investir ;
- **vue analyse** : marge par atelier, par parcelle, par produit, par saison.

C’est ce triptyque qui permet au grand public de comprendre la valeur économique de ses choix sans être noyé dans un tableau de comptabilité.[^9_2][^9_6][^9_3]

## Ce qu’il faut éviter

- un marché purement décoratif ;
- des prix fixes qui ne créent aucune stratégie ;
- des bonus monétaires liés à l’abonnement ;
- des coûts cachés impossibles à comprendre ;
- une économie qui récompense surtout le temps de connexion au lieu de la qualité des décisions.[^9_11][^9_3][^9_4]


## Étape suivante

Le prochain bloc naturel est **main-d’œuvre -> planning -> spécialisation des rôles**, parce que dans une exploitation réaliste, le temps humain devient vite la ressource la plus rare.
<span style="display:none">[^9_12][^9_13][^9_14][^9_15]</span>

<div align="center">⁂</div>

[^9_1]: https://agyield.com/simulator/

[^9_2]: https://sparkassenstiftung-asia.org/activities/business-games/farmers-business-game

[^9_3]: https://www.econstor.eu/bitstream/10419/176989/1/1017711461.pdf

[^9_4]: https://www.agproud.com/articles/60705-farm-budgeting-from-planning-to-profit

[^9_5]: https://www.crops.org/files/publications/jnrlse/pdfs/jnr022/022-02-0103.pdf

[^9_6]: https://www.facebook.com/groups/1047526948656738/posts/9182476421828376/

[^9_7]: https://www.farmbrite.com/post/farm-budget-the-backbone-of-the-farm

[^9_8]: https://www.cambridge.org/core/journals/journal-of-agricultural-and-applied-economics/article/abs/commodity-market-simulation-game-for-teaching-market-risk-management/518B58DDB468DB6A78ADBBFFD3B7516F

[^9_9]: https://citeseerx.ist.psu.edu/document?repid=rep1\&type=pdf\&doi=3194e9fdb0e40d8554eeef59ef44c88f3034e69d

[^9_10]: https://absel-ojs-ttu.tdl.org/absel/article/download/1296/1265

[^9_11]: https://virtonomics.com/business-games-list/

[^9_12]: https://www.sparkassenstiftung.de/fileadmin/Sparkassenstiftung/downloads/Business_Games/20210625_FarmerBG-BRO_Digital_EN.pdf

[^9_13]: https://www.linkedin.com/pulse/farm-management-game-market-report-2026-2033-uivue

[^9_14]: https://store.steampowered.com/app/3070880/Farming__Supermarket_Simulator/

[^9_15]: https://ndl.ethernet.edu.et/bitstream/123456789/27419/1/123.pdf.pdf


---

# Ok

Très bien. On peut poser le dernier bloc MVP : **Main-d’œuvre -> Planning -> Rôles**. Les modèles de gestion agricole montrent que le temps humain devient vite le goulot d’étranglement le plus critique, bien plus que le matériel ou la météo, et que l’organisation des tâches, la réactivité aux aléas et la coordination sont au cœur de la performance réelle d’une exploitation.[^10_1][^10_2][^10_3][^10_4][^10_5]

## Logique métier

Le joueur doit sentir qu’il ne peut pas tout faire. Dans une vraie ferme, les heures disponibles, les compétences, la fatigue, les priorités concurrentes et les imprévus créent une tension permanente sur le temps humain.[^10_2][^10_6][^10_7][^10_1]

La logique Agriva doit donc être :

- le travail a besoin de main-d’œuvre ;
- la main-d’œuvre a un temps limité ;
- le planning arbitre les priorités ;
- les rôles spécialisés rendent l’organisation plus efficace.


## Main-d’œuvre

Je vous propose de modéliser la main-d’œuvre comme une ressource finie, avec :

- nombre d’heures disponibles par jour/semaine ;
- compétences ;
- fatigue ;
- disponibilité ;
- coût horaire ;
- mobilité.

Les recherches sur la planification agricole insistent sur le fait que la main-d’œuvre est souvent sous-dimensionnée et mal allouée, ce qui crée des conflits de planning et des retards critiques.[^10_6][^10_7][^10_1][^10_2]

### Normal

- équipe simple ;
- compétences peu variées ;
- fatigue modérée ;
- allocation assez flexible.


### Expert

- compétences plus spécialisées ;
- fatigue plus marquée ;
- conflits de disponibilité ;
- impact plus fort sur les coûts et les délais.[^10_7][^10_8][^10_6]


## Planning

Le planning doit être un système central, pas un détail. Les modèles de scheduling agricole utilisent souvent des algorithmes qui priorisent les travaux selon urgence, fenêtre, ressources et contraintes.[^10_3][^10_5][^10_1]

Pour Agriva, le planning devrait permettre :

- d’assigner des travaux à des équipes ;
- de voir les conflits de ressources ;
- de réarbitrer les priorités ;
- de gérer les interruptions ;
- de simuler les effets de retard.


### Normal

- aide à la priorisation forte ;
- conflits résolus automatiquement ;
- moins de pénalités ;
- vue d’ensemble simple.


### Expert

- plus d’autonomie dans l’arbitrage ;
- conflits plus visibles ;
- pénalités plus fortes ;
- optimisation plus stratégique.[^10_1][^10_2][^10_3]


## Rôles et spécialisation

C’est là que le multijoueur et la simulation deviennent vraiment riches. Une bonne exploitation a des rôles spécialisés : chef d’exploitation, chef de culture, chef d’élevage, logisticien, mécanicien, commercial.[^10_8][^10_9][^10_7]

Pour Agriva, je verrais :

- rôles du joueur ;
- rôles des employés ;
- rôles des partenaires externes ;
- spécialisation des fermes entre joueurs.


### Normal

- rôles peu différenciés ;
- équipe polyvalente ;
- moins d’impact des compétences.


### Expert

- compétences plus marquées ;
- spécialisation plus rentable ;
- conflits de rôle plus visibles ;
- opportunités de formation.[^10_9][^10_6][^10_7]


## Règle de causalité Agriva

Je vous propose cette règle simple :

1. Un travail a besoin d’une ressource humaine avec les bonnes compétences.
2. La main-d’œuvre a un temps fini et des contraintes.
3. Le planning arbitre l’ordre et l’allocation.
4. Les retards ou mauvaises affectations impactent les travaux, donc les cultures, les parcelles et l’économie.
5. Une bonne organisation libère du temps pour d’autres décisions stratégiques.

Cette causalité est essentielle pour que le joueur sente qu’il gère une équipe, pas qu’il a une baguette magique.[^10_4][^10_5][^10_2][^10_1]

## Gameplay

Je verrais 3 vues :

- **vue équipe** : qui est disponible, compétences, fatigue ;
- **vue planning** : travaux à assigner, conflits, priorités ;
- **vue impact** : pourquoi un retard, quel coût, quelle conséquence.

C’est ce triptyque qui permet au grand public de comprendre l’importance de l’organisation sans être submergé par un Gantt complexe.[^10_7][^10_8][^10_1]

## Ce qu’il faut éviter

- une main-d’œuvre infinie ;
- des conflits automagiquement résolus ;
- des rôles décoratifs ;
- une abstraction totale du temps humain.[^10_2][^10_6][^10_1]


## MVP complet

Avec ce dernier bloc, vous avez maintenant les **6 systèmes MVP d’Agriva** bien cadrés :

1. Météo -> Parcelles -> Cultures.
2. Matériel -> Travaux -> Temps.
3. Économie -> Coûts -> Marché.
4. Main-d’œuvre -> Planning -> Rôles.

Ces 6 systèmes sont déjà suffisants pour produire une boucle agricole crédible et jouable. La suite logique est de les transformer en **entités métier et règles précises**, ou de passer à la définition des **objectifs et progression** pour que le joueur sache où il va.
<span style="display:none">[^10_10][^10_11][^10_12][^10_13][^10_14][^10_15]</span>

<div align="center">⁂</div>

[^10_1]: https://edepot.wur.nl/202729

[^10_2]: https://miat.inrae.fr/diese/docs/MODSIM11.pdf

[^10_3]: https://www.sciencedirect.com/science/article/pii/0308521X80900165

[^10_4]: https://miat.inrae.fr/diese/docs/IJMSO09.pdf

[^10_5]: https://www.sciencedirect.com/science/article/abs/pii/S0168169921003057

[^10_6]: https://proceedings.systemdynamics.org/2012/proceed/papers/P1256.pdf

[^10_7]: https://decisionbrain.com/workforce-optimization-for-agriculture/

[^10_8]: https://www.farmerp.com/blog/optimising-labour-use-in-agriculture-enhancing-efficiency-through-workforce-management-and-technology/

[^10_9]: https://www.agriculture.gov.au/agriculture-land/farm-food-drought/agricultural-workforce/planning

[^10_10]: https://agris.fao.org/search/en/providers/122575/records/64746aa1bf943c8c797ffa53

[^10_11]: https://www.mssanz.org.au/modsim2011/B1/martin_clouaire.pdf

[^10_12]: http://article.nadiapub.com/IJGDC/vol9_no1/17.pdf

[^10_13]: https://documents1.worldbank.org/curated/en/153211468739189210/pdf/multi0page.pdf

[^10_14]: https://agris.fao.org/search/en/providers/122558/records/6472429953aa8c896303b2b7

[^10_15]: https://edepot.wur.nl/172450


---

# Ok

Voici le **GDD Agriva consolidé** à ce stade, avec vos 6 systèmes MVP bien cadrés sur Normal / Expert. J’ai généré un tableau CSV récapitulatif complet des 12 systèmes pour que vous ayez un artefact structuré et téléchargeable .

## Récapitulatif systèmes

[Voici un tableau complet des 12 systèmes, avec Normal vs Expert. Téléchargez le CSV pour l’éditer ou l’importer dans votre workflow Kiro/Claude .]


| Système | Mode Normal | Mode Expert |
| :-- | :-- | :-- |
| Météo | Indicateurs simples, fenêtres favorables/défavorables, risques visibles [^11_1][^11_2] | Variables plus fines, effets croisés sur timing, qualité, pertes, risques locaux [^11_3][^11_2] |
| Parcelles | État global lisible, historique simplifié, peu de micro-variables [^11_4] | Historique technique plus détaillé, effets cumulés des interventions et précédents [^11_3][^11_4] |
| Cultures | Stades visibles, besoins résumés, pénalités modérées, recommandations fortes [^11_2][^11_5] | Stades et besoins plus fins, arbitrages plus serrés sur date, qualité, rendement, intrants [^11_3][^11_2] |
| Matériel | Compatibilité et efficacité simplifiées, usure modérée, peu de réglages [^11_6] | Performances dépendantes du contexte, usure plus sensible, choix techniques plus impactants [^11_6][^11_5] |
| Travaux | Le jeu propose directement les travaux possibles, prérequis visibles, durée simple | Dépendances plus nombreuses, fenêtres plus serrées, conséquences plus fortes d’un mauvais séquencement [^11_7][^11_8][^11_9] |
| Temps d’exécution | Estimation assez stable, peu d’interruptions, jours travaillables simplifiés | Vraies fenêtres de travail, retards dynamiques, interruptions météo, conflits de ressources [^11_7][^11_10][^11_11][^11_12] |
| Économie | Comptes plus lisibles, moins de frais cachés, prévisions plus stables [^11_13][^11_14] | Marges plus sensibles, coûts indirects, arbitrages plus fins sur trésorerie et investissement [^11_13][^11_14][^11_15] |
| Coûts | Coûts variables/fixes bien agrégés, trésorerie lisible | Coûts indirects plus visibles, trésorerie plus sensible, charges structurelles détaillées [^11_16][^11_17][^11_18] |
| Marché | Prix moins volatils, aide à la décision forte | Variation plus forte des prix, écart plus net entre bon et mauvais timing, contrats plus stratégiques [^11_19][^11_20][^11_21] |
| Main-d’œuvre | Équipe simple, compétences peu variées, fatigue modérée, allocation flexible | Compétences plus spécialisées, fatigue plus marquée, conflits de disponibilité, impact plus fort sur les coûts [^11_22][^11_23][^11_24] |
| Planning | Aide à la priorisation forte, conflits résolus automatiquement, vue simple | Plus d’autonomie dans l’arbitrage, conflits plus visibles, pénalités plus fortes, optimisation stratégique [^11_12][^11_25][^11_26] |
| Rôles | Rôles peu différenciés, équipe polyvalente, moins d’impact des compétences | Compétences marquées, spécialisation plus rentable, conflits de rôle visibles, opportunités de formation [^11_22][^11_23][^11_27] |

## État du GDD Agriva

Avec ce récap, vous avez maintenant une base solide :

- Vision produit et fantasy joueur.[^11_28][^11_29]
- Core loop jour/semaine/saison.[^11_30][^11_31][^11_32]
- 12 systèmes cœur bien décrits.
- Double mode Normal/Expert cohérent.
- Monétisation abonnement confort.

Cette structure est déjà assez complète pour alimenter un workflow Kiro/Claude Sonnet 4.6, comme vous l’aimez.[^11_33]

## Prochaine étape

Je vous propose qu’on passe maintenant à la **progression et objectifs** pour Agriva, car vous avez raison : même dans un MMO simulation, le joueur a besoin de repères clairs pour se motiver et comprendre où il va. Les farming sims qui marchent bien ont souvent des objectifs courts, moyens et longs qui guident sans enfermer.[^11_34][^11_35][^11_36][^11_37]
<span style="display:none">[^11_38][^11_39][^11_40][^11_41][^11_42][^11_43][^11_44][^11_45][^11_46][^11_47]</span>

<div align="center">⁂</div>

[^11_1]: https://paul-tech.com/smart-farming-how-to-unlock-soil-plant-and-weather-data/

[^11_2]: https://www.maxapress.com/article/id/677b3d46fa6c58500c875ec2

[^11_3]: https://era.dpi.qld.gov.au/id/eprint/8478/

[^11_4]: https://www.mssanz.org.au/modsim09/B3/deVoil.pdf

[^11_5]: https://www.farming-simulator.com/newsArticle.php?lang=fr\&country=fr\&news_id=613

[^11_6]: https://pub.epsilon.slu.se/553/1/Agraria_462.pdf

[^11_7]: https://www.sciencedirect.com/science/article/abs/pii/S1537511005001261

[^11_8]: https://rae.agriculturejournals.cz/pdfs/rae/2018/04/04.pdf

[^11_9]: https://www.sciencedirect.com/science/article/abs/pii/S1537511025001242

[^11_10]: https://pure.psu.edu/en/publications/predicting-suitable-days-for-field-machinery-operations-in-a-whol/

[^11_11]: https://www.sciencedirect.com/science/article/abs/pii/S0308521X23000082

[^11_12]: https://edepot.wur.nl/202729

[^11_13]: https://blackland.tamu.edu/models/farmsim/

[^11_14]: https://www.athanasiadis.info/assets/pdf/seamless2010fssim.pdf

[^11_15]: https://www.ars.usda.gov/ARSUserFiles/np212/LivestockGRACEnet/IFSM.pdf

[^11_16]: https://sparkassenstiftung-asia.org/activities/business-games/farmers-business-game

[^11_17]: https://www.facebook.com/groups/1047526948656738/posts/9182476421828376/

[^11_18]: https://www.agproud.com/articles/60705-farm-budgeting-from-planning-to-profit

[^11_19]: https://agyield.com/simulator/

[^11_20]: https://www.cambridge.org/core/journals/journal-of-agricultural-and-applied-economics/article/abs/commodity-market-simulation-game-for-teaching-market-risk-management/518B58DDB468DB6A78ADBBFFD3B7516F

[^11_21]: https://www.econstor.eu/bitstream/10419/176989/1/1017711461.pdf

[^11_22]: https://proceedings.systemdynamics.org/2012/proceed/papers/P1256.pdf

[^11_23]: https://decisionbrain.com/workforce-optimization-for-agriculture/

[^11_24]: https://www.farmerp.com/blog/optimising-labour-use-in-agriculture-enhancing-efficiency-through-workforce-management-and-technology/

[^11_25]: https://miat.inrae.fr/diese/docs/MODSIM11.pdf

[^11_26]: https://www.sciencedirect.com/science/article/pii/0308521X80900165

[^11_27]: https://www.agriculture.gov.au/agriculture-land/farm-food-drought/agricultural-workforce/planning

[^11_28]: https://cursus.edu/fr/20006/simagri

[^11_29]: https://www.simagri.com/index.php?lang=1

[^11_30]: https://www.farming-simulator.com/newsArticle.php?news_id=289

[^11_31]: https://vsquad.art/blog/what-gameplay-loop-types-core-loops-explained

[^11_32]: https://farmingsimulator.fandom.com/wiki/Seasons/Farming_Simulator_22

[^11_33]: https://www.perplexity.ai/search/1ba33c14-3c49-4683-9935-56c3f06fd0ca

[^11_34]: https://www.reddit.com/r/farmingsimulator/comments/1sqlxxu/setting_objectives/

[^11_35]: https://forum.giants-software.com/viewtopic.php?t=147207

[^11_36]: https://www.reddit.com/r/gamedev/comments/8fe1wo/what_are_good_goals_for_a_farming_game/

[^11_37]: https://tracextech.com/farm-management/5-main-objectives-of-farm-management/

[^11_38]: https://steamcommunity.com/app/2300320/discussions/0/4634861275507069583/

[^11_39]: https://www.farming-simulator.com/newsArticle.php?news_id=280

[^11_40]: https://www.studocu.com/en-za/document/university-of-the-free-state/strategic-management/agricultural-management-strategies-objectives-tactics-explained/141737830

[^11_41]: https://farming-and-friends.fandom.com/wiki/Goals

[^11_42]: https://www.farming-simulator.com/newsArticle.php?lang=pl\&country=pl\&news_id=284

[^11_43]: https://www.scribd.com/document/861775194/Unit-III

[^11_44]: https://www.youtube.com/watch?v=grt163sAqhM

[^11_45]: https://www.reddit.com/r/gamedesign/comments/dygc1y/how_to_scale_timeprogression_in_farm_games/

[^11_46]: https://steamcommunity.com/sharedfiles/filedetails/?id=3595074881

[^11_47]: https://agribusinessplay.com/how-to-create-an-efficient-agricultural-management-plan/


---

# Ok

Parfait. Pour un jeu de simulation agricole multijoueur comme Agriva, les objectifs doivent être à la fois **accessibles**, **progressifs** et **diversifiés**, pour éviter que le joueur ne se sente ni perdu ni enfermé dans une course unique à l’agrandissement. Les farming sims qui marchent bien ont justement des objectifs courts pour la satisfaction immédiate, moyens pour la maîtrise métier, et longs pour l’ambition sociale ou économique.[^12_1][^12_2][^12_3][^12_4][^12_5]

## Principes de progression

Je vous recommande 4 axes de progression cohérents avec votre simulation réaliste :

1. **Technique** : maîtriser les systèmes.
2. **Économique** : bâtir une exploitation viable.
3. **Sociale** : interagir et coopérer.
4. **Réputation** : être reconnu pour ses compétences.

Ces axes permettent à des profils différents de progresser : le gestionnaire pur, le technicien, le commercial, le coopérateur.[^12_3][^12_4]

## Objectifs par échelle

J’ai généré un tableau CSV structuré des objectifs Normal vs Expert .


| Échelle | Objectifs Normal | Objectifs Expert |
| :-- | :-- | :-- |
| Court terme (1 jour) | Terminer les travaux du jour | Optimiser les travaux du jour |
| Court terme (1 semaine) | Respecter le plan de semaine | Minimiser les pertes de semaine |
| Moyen terme (1 saison) | Finir la campagne à l’équilibre | Atteindre une marge supérieure à la moyenne |
| Long terme (3-6 saisons) | Agrandir l’exploitation | Optimiser un atelier de production |
| Moyen terme (coop) | Premier contrat coop réussi | Premier contrat expert coop réussi |
| Long terme (serveur) | Top 50% des fermes du serveur | Top 20% des fermes du serveur |

## Détail par axe

### Technique

- Normal : finir les étapes essentielles.
- Expert : optimiser timing, qualité, rendement.


### Économique

- Normal : équilibre, croissance modérée.
- Expert : marge forte, atelier spécialisé.


### Sociale

- Normal : premiers échanges, coop simple.
- Expert : contrats complexes, partenariats stratégiques.


### Réputation

- Normal : objectifs de campagne atteints.
- Expert : classements techniques, records de qualité ou d’efficacité.


## Système de progression proposé

Je vous propose un système en 4 paliers par saison :

1. **Découverte** : objectifs tutoriels, premiers succès.
2. **Maîtrise** : objectifs de campagne, premiers bilans positifs.
3. **Optimisation** : objectifs de marge, premier atelier spécialisé.
4. **Maîtrise collective** : coop, classements serveur.

Ces paliers guident sans enfermer, et le mode Expert a des objectifs plus techniques mais pas forcément plus rentables.[^12_4][^12_5][^12_3]

## Récompenses

Les objectifs doivent donner des récompenses qui aident sans déséquilibrer :

- badges techniques ;
- outils de gestion gratuits ;
- accès à des contrats ou opportunités ;
- points de réputation pour coop ;
- contenu narratif ou historique.

Rien qui donne un avantage économique direct, pour rester fidèle à votre non pay-to-win.[^12_4]

## Intégration mode Normal/Expert

Les objectifs s’adaptent au mode choisi :

- Normal : plus de guidage, paliers plus larges.
- Expert : plus technique, paliers plus serrés.

C’est cette flexibilité qui rend le double mode vraiment puissant.[^12_6][^12_7]

## État du GDD

Avec ça, Agriva est maintenant bien cadré :

- systèmes MVP détaillés  ;
- double mode Normal/Expert ;
- progression claire .


## Prochaine étape

La suite logique est de passer à **l’abonnement confort** et **la monétisation**, pour boucler la vision produit avant de passer aux specs techniques.

<div align="center">⁂</div>

[^12_1]: https://www.reddit.com/r/farmingsimulator/comments/1sqlxxu/setting_objectives/

[^12_2]: https://forum.giants-software.com/viewtopic.php?t=147207

[^12_3]: https://www.reddit.com/r/gamedev/comments/8fe1wo/what_are_good_goals_for_a_farming_game/

[^12_4]: https://tracextech.com/farm-management/5-main-objectives-of-farm-management/

[^12_5]: https://www.reddit.com/r/gamedesign/comments/dygc1y/how_to_scale_timeprogression_in_farm_games/

[^12_6]: https://redharegames.wordpress.com/2022/02/14/simple-article-how-to-design-difficulty-modes-in-games/

[^12_7]: https://www.youtube.com/watch?v=KspGk0L-eYI


---

# Ok

Parfait. On peut maintenant cadrer la **monétisation Agriva** avec votre principe d’abonnement de confort, sans pay-to-win. Les modèles économiques des jeux de simulation et management montrent que les abonnements fonctionnent mieux quand ils offrent des outils de qualité de vie, d’analyse et de gestion, plutôt qu’un avantage direct de performance.[^13_1][^13_2][^13_3][^13_4]

## Principe général

Le jeu doit être **jouable et compétitif sans payer**, mais l’abonnement rend l’expérience plus fluide, plus lisible et plus puissante en termes de pilotage. L’abonnement ne doit jamais donner de rendement, de vitesse, de prix ou de capacité supérieure — seulement des leviers de contrôle et de confort.[^13_4][^13_1]

## Matrice abonnement

J’ai généré un tableau CSV structuré .


| Fonctionnalité | Gratuit | Abonnement |
| :-- | :-- | :-- |
| Tableaux de bord avancés | Basique | Complet, prévisions |
| Alertes intelligentes | Alertes essentielles | Alertes personnalisées |
| Planification enrichie | Planification simple | Planification avancée |
| Vues historiques | Historique récent | Historique complet |
| Automatisations limitées | Non disponible | Automatisations non compétitives |
| Gestion multi-exploitations | Non disponible | Multi-sites, rôles coop |
| Personnalisation | Basique | Avancée |
| Qualité de vie | Standard | Optimisée |

## Détail des offres

### Gratuit (jouable et compétitif)

- tableaux de bord essentiels ;
- alertes critiques ;
- planification de base ;
- historique court ;
- accès complet aux mécaniques du jeu.


### Abonnement (confort)

- tableaux de bord complets avec prévisions ;
- alertes personnalisées et proactives ;
- planification avancée et simulation ;
- historique complet pour analyse ;
- automatisations légères non compétitives ;
- gestion multi-exploitations ;
- personnalisation avancée ;
- qualité de vie optimisée.


## Ce qui est interdit

Pour rester fidèle à votre vision non pay-to-win :

- bonus de rendement, vitesse, capacité, prix ;
- accès anticipé à des mécaniques ;
- ressources ou production supplémentaires ;
- avantage dans les classements ou événements ;
- automatisation compétitive.[^13_1][^13_4]


## Ce qui est accepté

- outils de lecture et de pilotage ;
- confort d’interface ;
- analyse et historique ;
- qualité de vie ;
- personnalisation non mécanique ;
- gestion multi-comptes pour gros joueurs.


## Positionnement tarifaire

Je verrais un abonnement à **4,99€/mois** ou **49€/an**, positionné comme un outil pro pour les joueurs sérieux. Les jeux de simulation qui utilisent l’abonnement réussissent quand ils le présentent comme un “pass pro” plutôt qu’un “paywall”.[^13_5][^13_1]

## Intégration mode Normal/Expert

L’abonnement peut aussi différencier selon le mode :

- Normal : plus d’assistance et de guidage.
- Expert : plus d’analyse et de profondeur technique.


## Règle GDD

Je vous propose cette règle simple :

**Abonnement = confort de pilotage, pas avantage compétitif.**

## État du GDD

Avec ce bloc, Agriva est maintenant **complet au niveau vision produit** :

- systèmes  ;
- progression  ;
- monétisation .


## Prochaine étape

La suite logique est de passer aux **specs techniques** : entités métier, base de données, architecture navigateur, intégration Normal/Expert, et plan Kiro/Claude.

<div align="center">⁂</div>

[^13_1]: https://www.reddit.com/r/gamedev/comments/gpoi6x/subscription_models_for_games/

[^13_2]: https://agyield.com/simulator/

[^13_3]: https://sparkassenstiftung-asia.org/activities/business-games/farmers-business-game

[^13_4]: https://www.econstor.eu/bitstream/10419/176989/1/1017711461.pdf

[^13_5]: https://www.linkedin.com/pulse/farm-management-game-market-report-2026-2033-uivue


---

# Ok

Parfait. Le GDD produit d’Agriva est maintenant **solide et complet**. On peut passer aux **specs techniques** pour implémenter ce concurrent à SimAgri dans votre stack Kiro/Claude Sonnet 4.6. Les architectures de MMO browser simulation montrent qu’il faut un frontend performant, un backend scalable pour l’état persistant, et une simulation temps réel bien découplée.[^14_1][^14_2][^14_3][^14_4][^14_5][^14_6]

## Stack technique recommandé

J’ai généré un tableau CSV de la stack .


| Composant | Technologie | Raison |
| :-- | :-- | :-- |
| Frontend | React + Phaser.js ou PixiJS (canvas 2D) | Interface fluide, rendu performant navigateur [^14_3][^14_5] |
| Backend | Node.js / Express ou Go (backend simulation) | Scalable pour MMO browser [^14_1][^14_2] |
| Base de données | PostgreSQL + Redis (état persistant + cache) | Transactions ACID pour économie + cache pour état [^14_7] |
| Réseau | WebSockets (Socket.io) ou WebTransport | Latence faible pour actions temps réel [^14_1][^14_5] |
| Simulation | Engine custom (cycle simulation temps réel) | Cycle jour/semaine/saison persistant [^14_4] |
| Authentification | JWT ou Auth0 | Sécurisé pour multi [^14_2] |
| Monétisation | Stripe (abonnement) | Abonnement récurrent simple [^14_8] |

## Architecture détaillée

### Frontend

- **React** pour l’interface, tableaux de bord, planning.[^14_3]
- **Phaser.js** ou **PixiJS** pour canvas 2D des parcelles, ferme, animations.[^14_5][^14_3]
- **TypeScript** partout pour robustesse.


### Backend

- **Node.js** avec Express pour API REST + WebSockets.[^14_2][^14_5]
- Ou **Go** pour simulation lourde et scalable.[^14_1]
- **Engine simulation** qui tourne en cycle : état -> actions -> avancement temps -> nouveaux états.[^14_4]


### Base de données

- **PostgreSQL** pour entités persistantes : joueurs, fermes, parcelles, cultures, matériel, contrats, historique.[^14_7]
- **Redis** pour état en temps réel : positions, travaux en cours, marché spot, alertes.[^14_7]


### Réseau

- **WebSockets** pour état temps réel, actions, notifications.[^14_5][^14_1]
- **REST** pour données statiques, login, abonnement.[^14_2]


## Specs entités métier (extrait MVP)

Pour Kiro, voici les entités principales à modéliser :

```
Joueur {
  id, nom, mode (normal/expert), ferme_id, abonnement, reputation
}

Ferme {
  id, joueur_id, nom, surface, parcelles[], materiel[], economie[], main_oeuvre[]
}

Parcelle {
  id, ferme_id, surface, sol_type, humidite, fertilite, compaction, occupation (culture_id ou libre), historique[]
}

Culture {
  id, parcelle_id, type_culture, stade, besoin_eau, besoin_chaleur, rendement_potentiel, qualite
}

Materiel {
  id, ferme_id, type, puissance, largeur, usure, etat, disponible
}

Travail {
  id, type, parcelle_id, materiel_id, main_oeuvre_id, date_debut, duree_estimee, statut (planifie/en_cours/fini), penalites
}

Economie {
  id, ferme_id, tresorerie, marge_brute, marge_nette, stocks[], contrats[]
}
```


## Cycle simulation

Le cœur technique est un **cycle serveur** :

1. Avancer le temps (jour/semaine).
2. Appliquer météo sur parcelles.
3. Avancer cultures selon état.
4. Exécuter travaux en cours.
5. Mettre à jour économie.
6. Notifier changements via WebSockets.

Ce cycle tourne toutes les X minutes selon échelle, avec pause/accéléré pour debug.[^14_4]

## Intégration Normal/Expert

- **Flags par joueur** dans la DB.
- **Requêtes conditionnelles** dans l’API.
- **UI adaptative** selon mode.


## Plan Kiro/Claude

Pour votre workflow  :[^14_6]

1. **requirements.md** : ce GDD.
2. **design.md** : entités + cycle simulation.
3. **tasks.md** : MVP en 6 sprints (1 système par sprint).

## État du projet

Vous avez maintenant :

- GDD complet .
- Stack technique .
- Specs entités prêtes pour Kiro.

La prochaine étape est de **générer le prompt maître Kiro** pour lancer le développement. Prêt ?
<span style="display:none">[^14_10][^14_11][^14_12][^14_13][^14_14][^14_15][^14_16][^14_17][^14_9]</span>

<div align="center">⁂</div>

[^14_1]: https://www.youtube.com/watch?v=lUzh35XV0Pw

[^14_2]: https://stackoverflow.com/questions/44476766/inner-workings-of-browser-based-real-time-mmo-games

[^14_3]: https://phaser.io/news/2025/08/building-a-modern-web-based-farming-game

[^14_4]: http://ithare.com/chapter-via-server-side-mmo-architecture-naive-and-classical-deployment-architectures/

[^14_5]: https://www.gamedeveloper.com/programming/modern-html5-game-tech-stack

[^14_6]: https://www.perplexity.ai/search/1ba33c14-3c49-4683-9935-56c3f06fd0ca

[^14_7]: https://tigerbeetle.com/blog/2023-07-11-we-put-a-distributed-database-in-the-browser/

[^14_8]: https://www.reddit.com/r/gamedev/comments/gpoi6x/subscription_models_for_games/

[^14_9]: https://forum.babylonjs.com/t/babylon-js-browser-3d-mmorpg-devlog/47440

[^14_10]: https://www.youtube.com/watch?v=C9TC69ZdI1o

[^14_11]: https://www.reddit.com/r/gamedev/comments/1kmyrf3/browser_mmorpgs_successful_models/

[^14_12]: https://dev.to/mufeng/building-a-high-performance-html5-game-aggregator-a-deep-dive-with-risequestgame-cia

[^14_13]: https://www.babylonjs.com/games/

[^14_14]: https://www.youtube.com/watch?v=38ltTkSfR_w

[^14_15]: https://www.reddit.com/r/GameDevelopment/comments/1ot9hwl/need_browser_based_game_engines/

[^14_16]: https://www.youtube.com/watch?v=QXeWQJSPXzw

[^14_17]: https://www.html5gamedevs.com/topic/29820-how-to-make-a-time-based-game-like-farm-simulator-games/


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

Avec cette logique, vous pouvez ensuite remapper les animaux ainsi :

- **volailles** : cycles très courts, production quasi quotidienne ;
- **porcs** : croissance et reproduction moyennes ;
- **bovins lait** : production régulière, reproduction plus longue ;
- **bovins viande** : croissance plus lente mais plus rentable à terme.

Les jeux et mods de simulation animale montrent déjà cette logique : tous les animaux n’ont pas la même vitesse de retour, et c’est même une force économique si c’est bien équilibré.[^22_6][^22_8][^22_7][^22_5]

## Règle d’équilibrage

Je vous propose cette règle fondatrice :

**Chaque atelier doit produire un retour économique visible dans une fenêtre de 2 à 8 jours réels, mais avec des amplitudes différentes.**

Par exemple :

- œufs / lait : retour très fréquent ;
- cultures rapides : retour fréquent ;
- cultures longues : retour plus espacé mais plus gros ;
- reproduction bovine : retour rare mais structurant.

C’est cela qui fera respirer l’économie globale du serveur.[^22_3][^22_1]

## Ce qu’il faut éviter

- des gestations ou croissances animales trop longues ;
- des cultures longues sans revenus intermédiaires ;
- un début de partie où tout est bloqué pendant 2 semaines ;
- des ateliers qui ne produisent rien à court terme.


## Étape suivante

La suite logique est de définir un **cadre de temporalité global Agriva**, avec :

- 1 mois de jeu ;
- durée type des cultures ;
- durée type des cycles animaux ;
- fréquence des revenus ;
- fréquence des dépenses.
<span style="display:none">[^22_10][^22_11][^22_12][^22_13][^22_14][^22_15][^22_9]</span>

<div align="center">⁂</div>

[^22_1]: https://www.fao.org/4/x5528e/x5528e03.htm

[^22_2]: https://www.reddit.com/r/farmingsimulator/comments/1kw7l44/is_crop_growth_and_livestock_production_based_on/

[^22_3]: https://agromixproject.eu/knowledge/dynamix-a-serious-game-to-design-scenarios-of-exchange-of-animal-or-crop-co-roducts-between-farmers/

[^22_4]: https://www.youtube.com/watch?v=mjNvSyV6wnE

[^22_5]: https://www.ign.com/wikis/farming-simulator-22/How_to_Manage_Animals_-_Storing,_Feeding,_and_Breeding_Guide

[^22_6]: https://fs17.lt/enhanced-animal-system-v-2-2-1-1/

[^22_7]: https://www.farming-simulator.com/mod.php?mod_id=259964

[^22_8]: https://forum.giants-software.com/viewtopic.php?t=47726

[^22_9]: https://www.youtube.com/watch?v=clFGFaDLb88

[^22_10]: https://en.wikipedia.org/wiki/Farming_Simulator

[^22_11]: https://farmingsimulator25mods.com/enhanced-livestock-v1-1/

[^22_12]: https://academic.oup.com/af/article/7/3/5/4616839

[^22_13]: https://ruminants.ceva.pro/calving

[^22_14]: https://www.youtube.com/watch?v=LsNrVH6PSnc

[^22_15]: https://play.google.com/store/apps/details?id=com.whatme.farm.management\&hl=ln


---

# Et dans simagri qu’elle se le temps pour dj blé ?

Dans **SimAgri**, le **blé** (comme la plupart des céréales d’hiver) suit un cycle classique de **blé d’hiver** qui dure environ **8 à 9 mois de jeu**.[^23_1][^23_2][^23_3][^23_4]

## Temporalité SimAgri

Pour rappel, SimAgri utilise :

- **1 semaine réelle = 1 mois de jeu**.
- **12 semaines = 1 année de jeu** (84 jours réels).

Donc une culture de blé dure typiquement :

- **semis en automne** (septembre/octobre) ;
- **croissance hiver/printemps** ;
- **récolte été** (juin/juillet).

Cela fait **8 à 9 mois de jeu**, soit **8 à 9 semaines réelles** (56 à 63 jours réels).[^23_2][^23_4][^23_1]

## Cycle précis blé SimAgri

D’après les bulletins et guides SimAgri :

- **semis blé** : septembre à novembre ;
- **récolte blé** : juin à juillet ;
- **durée totale** : environ 9 mois de jeu.

Les bulletins agricoles SimAgri montrent régulièrement le blé en phase de semis en automne et de récolte en été, confirmant ce cycle complet sur une année agricole.[^23_5]

## Comparaison avec votre design

Donc pour répondre directement à votre question :

- **SimAgri blé** : 8 à 9 mois de jeu = **56 à 63 jours réels**.
- **Agriva Normal** (proposition précédente) : 8 mois = **56 jours réels**.

Vous êtes **exactement sur la même durée** que SimAgri, ce qui est logique si vous voulez être plus réaliste. Mais c’est aussi ce qui confirme que cette durée est **trop longue pour un jeu navigateur moderne**.[^23_6][^23_7][^23_8]

## Ce que ça implique

SimAgri est un jeu plus ancien (2005), conçu pour un public très engagé qui accepte des cycles longs. Pour Agriva, viser le grand public navigateur, il faut accélérer sans casser la logique saisonnière.[^23_9][^23_10]

Ma proposition reste donc valide :

- **1 mois = 4 jours réels**.
- **Blé = 4 à 5 mois de jeu = 16 à 20 jours réels**.

Vous gardez un cycle saisonnier crédible, mais 3 fois plus rapide que SimAgri, ce qui est parfait pour la rétention et l’économie du jeu.[^23_7][^23_8]

## Avantage pour Agriva

Cette accélération vous donne un vrai avantage compétitif :

- les joueurs voient plus vite les résultats de leurs choix ;
- l’économie tourne plus vite ;
- le multijoueur est plus dynamique ;
- le mode Normal devient vraiment accessible.

SimAgri est un bon benchmark pour le réalisme, mais pas pour le rythme d’un jeu navigateur 2026.[^23_10][^23_6]

La suite logique est de **valider cette temporalité accélérée** et de construire le calendrier des cultures Normal avec cette base.
<span style="display:none">[^23_11][^23_12][^23_13][^23_14][^23_15][^23_16][^23_17][^23_18]</span>

<div align="center">⁂</div>

[^23_1]: https://www.simagri.com/regle_simagri.php?id=3\&hide=

[^23_2]: https://www.vivescia.com/grand-angle/tous/cereale-quel-est-le-cycle-du-ble

[^23_3]: https://www.simagri.com/regle_simagri.php

[^23_4]: https://www.arvalis.fr/infos-techniques/ble-dur-des-rythmes-de-developpement-differents-selon-la-variete

[^23_5]: https://www.simagri.com/bulletins/bulletin_agricole_simagri_octobre_saison9.pdf

[^23_6]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^23_7]: https://pixelfield.co.uk/blog/how-to-design-games-for-retention/

[^23_8]: https://learninghub.athena.studio/post/balancing-game-economy-for-long-term-retention-in-free-to-play-games

[^23_9]: https://micado-france.fr/simagri-guide-pour-bien-debuter-et-progresser/

[^23_10]: https://www.g-net.fr/simagri-le-guide-ultime/

[^23_11]: https://www.clg-lesaulnes.fr/simagri/

[^23_12]: https://www.simagri.com/bulletins/bulletin_agricole_simagri_decembre_saison9.pdf

[^23_13]: https://www.jeux-alternatifs.com/Simagri--jeu124_critique_1_1.html

[^23_14]: https://www.agrialpro.fr/blog/post/etapes-de-la-culture-du-ble-du-semis-a-la-recolte-reussie

[^23_15]: https://fr.wikipedia.org/wiki/Blé

[^23_16]: https://alcuinfonds.be/blog/inseminer-avec-les-males-simagri/

[^23_17]: https://ressources.dane.ac-versailles.fr/IMG/pdf/cycle_de_vie_du_ble_au_cours_des_saisons.pdf

[^23_18]: https://www.facebook.com/groups/503642203809003/posts/1862650874574789/


---

# 3 fois plus rapide c’est pas un trop ?

Oui, **3 fois plus rapide peut être trop** si vous l’appliquez brutalement à tout le jeu. Le bon point n’est pas “aller 3x plus vite que SimAgri”, mais trouver une vitesse où la progression reste lisible, où l’économie tourne, et où les joueurs ont encore le temps de prendre des décisions intéressantes.[^24_1][^24_2][^24_3]

## Pourquoi ça peut être trop

Si vous compressez trop :

- les cultures s’enchaînent trop vite ;
- l’élevage perd en poids ;
- les erreurs deviennent moins marquantes ;
- le marché devient plus nerveux que stratégique.

Les réflexions sur la compression en game design montrent bien qu’en réduisant trop les délais et les étapes, on peut finir par perdre de la contingence, donc de la profondeur de simulation. De même, dans les farming sims, accélérer le temps change directement le coût du travail, des animaux et des machines, donc la difficulté et l’économie globale.[^24_4][^24_5][^24_2]

## Ce que je ferais

Je ne raisonnerais pas en “x3 plus vite”, mais en **cadence cible par boucle économique**. La bonne question est : à quelle fréquence un joueur doit-il voir un résultat significatif, sans que tout paraisse jetable ? Les principes de progression et d’économie recommandent justement de faire servir le rythme au gameplay, pas l’inverse.[^24_6][^24_1]

## Meilleur compromis

À mon avis, une meilleure base serait :

- **1 mois de jeu = 5 jours réels**.
- **1 saison = 15 jours réels**.
- **1 année = 60 jours réels**.

C’est un compromis très intéressant :

- plus rapide que SimAgri ;
- moins agressif qu’un x3 plein ;
- assez lent pour garder du poids aux cultures et à l’élevage ;
- assez rapide pour que l’économie respire.


## Pourquoi 5 jours marche bien

Le 5 jours réels par mois a plusieurs avantages :

- il reste facile à comprendre ;
- il permet des rythmes hebdomadaires naturels ;
- il laisse de la place aux actions intermédiaires ;
- il garde de la valeur aux cycles longs comme le blé ou la reproduction bovine.

Vous conservez donc un jeu persistant avec de vraies attentes, sans tomber dans un système où tout tourne trop vite pour être savouré.[^24_7][^24_3][^24_4]

## Mon avis sur les durées

Avec cette base :

- culture rapide : **2 mois** = 10 jours réels ;
- culture moyenne : **3 à 4 mois** = 15 à 20 jours ;
- culture longue : **5 à 6 mois** = 25 à 30 jours.

Ça me paraît beaucoup plus sain pour un mode Normal. Le joueur voit régulièrement des résultats, mais une culture garde une vraie inertie économique. Et l’élevage peut cohabiter plus facilement avec ces cycles.[^24_3][^24_4][^24_1]

## Recommandation finale

Donc oui : **x3 plus rapide est probablement un peu trop fort comme point de départ**. Je partirais plutôt sur un modèle autour de **x2 à x2,5 plus rapide que SimAgri**, ce qui revient grosso modo à une année de jeu en **60 jours réels** au lieu d’environ 84.[^24_8][^24_3]

La bonne règle pour Agriva serait :

**Le jeu doit aller assez vite pour nourrir l’économie, mais assez lentement pour que chaque décision garde du poids.**

La prochaine étape utile est de comparer **3 calendriers candidats** pour Agriva :

- conservateur ;
- médian ;
- rapide.
<span style="display:none">[^24_10][^24_11][^24_12][^24_13][^24_14][^24_15][^24_16][^24_9]</span>

<div align="center">⁂</div>

[^24_1]: https://cursa.app/en/article/game-development-core-loops-designing-progression-systems-players-actually-stick-with

[^24_2]: https://thedesignlab.blog/2026/04/13/the-compression-problem-in-modern-game-design/

[^24_3]: https://discourse.pbbg.com/t/could-someone-give-me-advice-on-balancing-in-game-economy-and-player-progression-in-a-pbbg/502

[^24_4]: https://www.reddit.com/r/farmingsimulator/comments/v7xy4u/effect_of_game_time_speed/

[^24_5]: https://steamcommunity.com/app/313160/discussions/0/620700960756062005/

[^24_6]: https://www.youtube.com/watch?v=uM8NqYEnNqg

[^24_7]: https://forum.giants-software.com/viewtopic.php?t=155447

[^24_8]: https://www.simagri.com/regle_simagri.php?id=3\&hide=

[^24_9]: https://steamcommunity.com/app/1248130/discussions/0/3820780544814106493/

[^24_10]: https://steamcommunity.com/app/1248130/discussions/0/3820780544814106493/?l=schinese

[^24_11]: https://www.linkedin.com/posts/alexanderrehm_good-progression-design-isnt-just-art-its-activity-7384891168557465600-r-rY

[^24_12]: https://www.matrixgames.com/forums/viewtopic.php?t=307013

[^24_13]: https://www.facebook.com/groups/1355915555316357/posts/1906814336893140/

[^24_14]: https://www.farming-simulator.com/mod.php?mod_id=322424\&title=fs2025

[^24_15]: https://www.wayline.io/blog/animation-compression-in-games

[^24_16]: https://www.farming-simulator.com/mod.php?lang=en\&country=no\&mod_id=225295


---

# Oui si une année c’est 2 mois je trouve ça bien non ?

Oui, **une année = 2 mois réels** me paraît être une très bonne cible de départ pour Agriva Normal. Cela donne une année de jeu en environ **60 jours**, ce qui est assez long pour garder du poids aux saisons, mais assez court pour que les joueurs voient une vraie progression économique et plusieurs cycles significatifs dans un trimestre réel.[^25_1][^25_2][^25_3][^25_4]

## Pourquoi c’est une bonne cible

Avec 2 mois réels par année de jeu, vous êtes dans une zone médiane :

- plus rapide que SimAgri, donc plus moderne en rythme;[^25_5]
- pas trop rapide, donc les décisions gardent de la valeur;[^25_6][^25_7]
- compatible avec un jeu navigateur persistant et une économie partagée.[^25_3][^25_1]

Les discussions autour du pacing des farming sims montrent aussi qu’il faut adapter la durée à la taille de la ferme, au nombre d’activités et au niveau d’engagement attendu ; un rythme médian est souvent plus robuste qu’un rythme extrême.[^25_8][^25_9][^25_10][^25_11]

## Calendrier simple

Si vous voulez garder quelque chose de facile à comprendre, je poserais :

- **1 année de jeu = 60 jours réels**.
- **1 saison = 15 jours réels**.
- **1 mois de jeu = 5 jours réels**.
- **1 saison = 3 mois de jeu**.
- **1 année = 12 mois de jeu**.

C’est lisible, stable, et très facile à afficher dans l’interface. Cela vous donne aussi un bon squelette pour les cultures, l’élevage et les bilans mensuels.[^25_12][^25_13]

## Effet sur les cultures

Avec cette base :

- culture courte = **2 mois** = 10 jours réels ;
- culture moyenne = **3 à 4 mois** = 15 à 20 jours ;
- culture longue = **5 à 6 mois** = 25 à 30 jours.

Ça me paraît très sain pour le mode Normal. Un joueur peut récolter régulièrement, mais chaque campagne garde une vraie inertie stratégique.[^25_4][^25_14][^25_6]

## Effet sur l’élevage

C’est aussi une bonne base pour l’élevage :

- revenus fréquents, lait, œufs, etc., sur des pas de temps courts ;
- croissance animale sur plusieurs mois de jeu ;
- reproduction sur des durées plus longues mais encore perceptibles ;
- bilans mensuels utiles pour suivre atelier par atelier.[^25_15][^25_16][^25_17]


## Mon avis net

Donc oui : **2 mois réels pour 1 année de jeu**, c’est probablement le meilleur compromis que nous avons évoqué jusqu’ici pour Agriva Normal. C’est simple, crédible, jouable, et surtout bon pour l’économie globale du jeu.[^25_18][^25_19][^25_20]

## Règle proposée

Je poserais officiellement :

**Calendrier Agriva Normal**

- 1 mois = 5 jours réels.
- 1 saison = 15 jours réels.
- 1 année = 60 jours réels.

Ensuite, toutes les cultures, tous les ateliers animaux et tous les coûts/revenus seront équilibrés à partir de cette base.[^25_4]

La prochaine étape logique est de bâtir le **calendrier annuel complet Agriva Normal** sur cette temporalité.
<span style="display:none">[^25_21][^25_22][^25_23][^25_24][^25_25][^25_26]</span>

<div align="center">⁂</div>

[^25_1]: https://www.reddit.com/r/incremental_games/comments/1otpt4f/i_built_a_browserbased_economy_game_where_every/

[^25_2]: https://store.steampowered.com/app/1761220/Prosperous_Universe/

[^25_3]: https://prosperousuniverse.com

[^25_4]: https://neopryus.itch.io/idle-economy-simulator

[^25_5]: https://www.simagri.com/regle_simagri.php?id=3\&hide=

[^25_6]: https://cursa.app/en/article/game-development-core-loops-designing-progression-systems-players-actually-stick-with

[^25_7]: https://thedesignlab.blog/2026/04/13/the-compression-problem-in-modern-game-design/

[^25_8]: https://www.reddit.com/r/farmingsimulator25/comments/1mgmwsa/what_is_recommended_for_days_per_month_and_time/

[^25_9]: https://steamcommunity.com/app/1248130/discussions/0/3203744999894666620/

[^25_10]: https://www.reddit.com/r/farmingsimulator/comments/1hv478o/question_about_play/

[^25_11]: https://forum.giants-software.com/viewtopic.php?t=213781

[^25_12]: https://www.reddit.com/r/gamedesign/comments/jv7x9v/calendar_system_for_a_farming_and_community_life/

[^25_13]: https://forums.unrealengine.com/t/in-game-date-time-calendar-system/50092

[^25_14]: https://www.youtube.com/watch?v=uM8NqYEnNqg

[^25_15]: https://www.youtube.com/watch?v=mjNvSyV6wnE

[^25_16]: https://www.ign.com/wikis/farming-simulator-22/How_to_Manage_Animals_-_Storing,_Feeding,_and_Breeding_Guide

[^25_17]: https://www.fao.org/4/x5528e/x5528e03.htm

[^25_18]: https://learninghub.athena.studio/post/balancing-game-economy-for-long-term-retention-in-free-to-play-games

[^25_19]: https://machinations.io/articles/game-economy-design-free-to-play-games

[^25_20]: https://mobilefreetoplay.com/bible/building-lasting-free-play-economy/

[^25_21]: https://www.reddit.com/r/GirlGamers/comments/1b0mwt4/pacing_in_farming_sims/

[^25_22]: https://steamcommunity.com/app/2300320/discussions/0/685239894022306073/

[^25_23]: https://gamedev.net/forums/topic/376355-length-of-day/

[^25_24]: https://forum.giants-software.com/viewtopic.php?t=204368

[^25_25]: https://forums.mmorpg.com/discussion/64412/hypothetical-farming-as-in-crops-in-an-mmo

[^25_26]: https://www.reddit.com/r/CozyGamers/comments/1ar6gqy/what_is_your_ideal_season_and_day_length_for_cozy/


---

# Ok

Parfait. Avec votre calendrier validé **1 année = 60 jours réels**, on peut maintenant construire le **calendrier annuel complet Agriva Normal** mois par mois. J’ai généré un fichier CSV structuré .

## Calendrier Agriva Normal

| Mois | Semis possibles | Récoltes possibles | Activités principales |
| :-- | :-- | :-- | :-- |
| Septembre (1) | Blé d’hiver, orge d’hiver, colza | Cultures d’été précédentes | Semis hiver |
| Octobre (2) | Blé d’hiver, orge d’hiver, colza | Cultures d’été précédentes | Semis hiver |
| Novembre (3) | Blé d’hiver, orge d’hiver, colza | Cultures d’été précédentes | Semis hiver |
| Décembre (4) | Fin semis hiver | Préparations hiver | Entretien hiver |
| Janvier (5) | Avoine, cultures de printemps précoces | Herbe, avoine | Semis printemps |
| Février (6) | Sorgho, maïs précoce | Herbe, cultures précoces | Semis printemps |
| Mars (7) | Maïs, soja, tournesol | Herbe, cultures précoces | Semis printemps |
| Avril (8) | Maïs, soja, tournesol | Blé d’hiver, orge d’hiver, colza | Récolte hiver |
| Mai (9) | Cultures de printemps tardives | Blé d’hiver, orge d’hiver, colza | Récolte hiver |
| Juin (10) | Fin semis printemps | Colza, orge d’hiver | Récolte hiver |
| Juillet (11) | Préparations pour hiver | Blé d’hiver, orge d’hiver | Récolte hiver |
| Août (12) | Préparations pour hiver | Herbe, cultures d’été | Préparation automne |

## Logique de ce calendrier

Ce calendrier suit une logique agricole classique en zone tempérée, adaptée à votre compression temporelle :

- **Automne** : semis des céréales d’hiver ;
- **Hiver** : entretien et préparation ;
- **Printemps** : semis des cultures de printemps ;
- **Été** : récoltes des céréales d’hiver + cultures d’été.

Les références sur les calendriers de culture en farming sims montrent exactement cette structure, avec des fenêtres de semis et de récolte claires par saison.[^26_1][^26_2][^26_3]

## Avantages de ce modèle

1. **Lisibilité** : chaque saison a des activités claires.
2. **Cohérence** : les cultures longues couvrent plusieurs saisons.
3. **Rythme** : il y a toujours quelque chose à faire.
4. **Équilibre** : semis et récoltes alternent naturellement.
5. **Économie** : flux réguliers de revenus et dépenses.

## Conséquences gameplay

Avec ce calendrier, le joueur peut :

- **semer du blé** en septembre/octobre ;
- **récolter du blé** en avril/mai ;
- **semer du maïs** en février/mars ;
- **récolter du maïs** en août/septembre.

Chaque saison a donc sa propre activité, ce qui évite les périodes mortes et nourrit l’économie du jeu.[^26_2][^26_1]

## Règle de design

Je vous propose cette règle simple pour le calendrier :

**Chaque mois doit offrir au minimum une activité de production et une activité de récolte.**

Cela garantit que le joueur a toujours quelque chose à faire et que l’économie du serveur reste active toute l’année.[^26_4][^26_5]

## Adaptation élevage

Ce calendrier fonctionne aussi très bien pour l’élevage :

- **vaches laitières** : production quasi continue ;
- **porcs** : croissance et reproduction sur 3 à 6 mois ;
- **poules** : production rapide et constante ;
- **mise bas** : automne/printemps selon espèce.


## État du design

Avec ce calendrier, vous avez maintenant une base temporelle très solide pour :

- cultures  ;
- calendrier annuel  ;
- rythme économique cohérent.


## Prochaine étape

La suite logique est de **définir les durées précises de 6 à 8 cultures** sur ce calendrier, avec fenêtres de semis, récolte et entretien, pour pouvoir enfin construire une vraie économie de départ.

<div align="center">⁂</div>

[^26_1]: https://www.thegamer.com/farming-simulator-25-seasonal-farming-every-crop-month/

[^26_2]: https://hardcoregamer.com/farming-simulator-25-complete-crop-guide/

[^26_3]: https://teknonel.com/fs22-all-fruit-and-seed-calendar/

[^26_4]: https://www.reddit.com/r/gamedesign/comments/dygc1y/how_to_scale_timeprogression_in_farm_games/

[^26_5]: https://www.reddit.com/r/gamedesign/comments/jv7x9v/calendar_system_for_a_farming_and_community_life/


---

# Je veux aussi définir le workflow complet de l’action semer end to end avec toute les dépendances sous jacente

Oui — c’est exactement le bon niveau de détail à définir maintenant. Pour Agriva, l’action **“semer”** ne doit pas être un simple bouton, mais un **workflow end-to-end** avec validations, dépendances, réservations de ressources, exécution, effets économiques et création de l’état initial de la culture. Les sources sur les templates d’opérations agricoles et les workflows crop-first vont dans ce sens : un semis dépend d’une séquence agronomique, de conditions de terrain, de matériel, de main-d’œuvre et de météo, puis déclenche toute la suite du cycle cultural.[^27_1][^27_2][^27_3][^27_4][^27_5][^27_6][^27_7]

## Vue d’ensemble

J’ai généré un CSV complet du workflow **semer** avec toutes les dépendances sous-jacentes .

La logique générale est :

1. Le joueur veut semer.
2. Le système vérifie si c’est possible.
3. Le système détecte ce qu’il manque.
4. Le joueur confirme ou planifie.
5. Le chantier est réservé puis exécuté.
6. La parcelle devient semée.
7. La culture est créée.
8. L’économie, le planning et les prochaines tâches sont mis à jour.

## Workflow complet

| Étape | Action / décision | Dépendance principale | Effet système |
| :-- | :-- | :-- | :-- |
| 0 | Le joueur veut semer une culture sur une parcelle | Choix joueur | Déclenche le workflow |
| 1 | Vérifier la fenêtre de semis | Calendrier cultural | Autorise ou bloque |
| 2 | Vérifier la parcelle | État parcelle | Évite conflits |
| 3 | Vérifier la rotation simplifiée | Historique parcelle | Bonus / malus |
| 4 | Vérifier l’état du sol | Sol / parcelle | Peut exiger préparation |
| 5 | Vérifier météo et fenêtre | Météo | Peut retarder ou risquer |
| 6 | Vérifier les semences | Stocks / achat | Condition obligatoire |
| 7 | Vérifier le matériel | Parc matériel | Condition technique |
| 8 | Vérifier la main-d’œuvre | Planning RH | Condition de lancement |
| 9 | Estimer durée et coût | Moteur opération | Donne visibilité |
| 10 | Détecter les dépendances amont | Workflow cultural | Liste les prérequis |
| 11 | Proposer un plan | Assistant normal | UX de décision |
| 12 | Validation joueur | Interface | Crée l’intention |
| 13 | Réserver les ressources | Scheduler | Évite doublons |
| 14 | Créer l’ordre de travail | Système travaux | Lance l’opération |
| 15 | Exécuter le chantier | Moteur exécution | Consomme temps et ressources |
| 16 | Gérer les aléas | Moteur événements | Suspend/recalcule si besoin |
| 17 | Fin de chantier | Parcelles / cultures | Parcelle semée |
| 18 | Initialiser la culture | Moteur culture | Début de croissance |
| 19 | Mettre à jour l’économie | Économie | Coûts et usure |
| 20 | Déclencher les tâches aval | Workflow cultural | Roulage, fertilisation, surveillance |
| 21 | Afficher le feedback joueur | UI / notifications | Boucle de compréhension |

## Dépendances cachées

Sous l’action “semer”, il y a en réalité plusieurs couches de dépendances :

- **agronomiques** : rotation, état du sol, humidité, météo, fenêtre de semis;[^27_2][^27_8][^27_9][^27_7]
- **techniques** : tracteur, semoir, compatibilité, état machine;[^27_3][^27_10]
- **organisationnelles** : parcelle libre, créneau, équipe disponible, conflit avec autres travaux;[^27_10][^27_6][^27_3]
- **économiques** : semences, carburant, coût du chantier, achat éventuel;[^27_5][^27_6]
- **systémiques** : création de la culture, futur planning, tâches suivantes.[^27_4][^27_5]

C’est précisément cette profondeur qui donnera à Agriva une vraie sensation de simulation moderne.

## Version mode Normal

Comme on se concentre sur le **mode Normal**, je vous conseille de ne pas exposer toutes ces couches d’un coup. Le joueur devrait voir surtout :

- “vous pouvez semer” ;
- “vous ne pouvez pas semer car…” ;
- “il vous manque…” ;
- “temps estimé / coût estimé / risque estimé” ;
- “souhaitez-vous planifier automatiquement les prérequis ?”.

Autrement dit, la complexité doit être **dans le moteur**, pas forcément dans l’écran principal.[^27_1][^27_4][^27_5]

## Règle de design

Je vous propose cette règle pour Agriva Normal :

**Une action visible peut cacher 20 vérifications, mais le joueur doit toujours comprendre en 1 phrase pourquoi elle est possible, bloquée ou risquée.**

C’est probablement l’une des règles UX les plus importantes pour tout votre système.

## Modèle logique

En pratique, je structurerais “semer” en 5 sous-domaines :

- **Intent** : le joueur veut semer.
- **Eligibility** : est-ce autorisé maintenant ?
- **Preparation** : qu’est-ce qu’il manque ?
- **Execution** : le chantier se déroule.
- **Aftermath** : culture créée, coûts enregistrés, prochaines étapes générées.

Cette structure sera très utile ensuite pour Kiro, la base de données, l’API et les agents.

## Ce qu’il faut faire ensuite

La suite la plus utile est de transformer ce workflow en **spécification métier formelle** avec :

- inputs ;
- règles ;
- erreurs possibles ;
- sorties ;
- événements générés.

Puis juste après, on fera la même chose pour **récolter**, car semer et récolter sont les deux workflows les plus structurants du jeu.
<span style="display:none">[^27_11][^27_12][^27_13][^27_14][^27_15]</span>

<div align="center">⁂</div>

[^27_1]: https://www.logineko.com/knowledge/enhancing-field-operation-planning-with-cultivation-templates/

[^27_2]: https://bbro.co.uk/media/50683/22-advisory-bulletin-no-2.pdf

[^27_3]: https://era.ed.ac.uk/handle/1842/34007

[^27_4]: https://www.tandfonline.com/doi/full/10.1080/09540091.2022.2083078

[^27_5]: https://www.meegle.com/en_us/topics/workflow-role/agricultural-managers

[^27_6]: https://www.ufs.ac.za/docs/librariesprovider22/agricultural-economics-documents/agri-management-documents/all-documents/mechanisation-and-labour-guidelines-1547-eng.pdf?sfvrsn=bc2ff921_0

[^27_7]: https://nationalagro.com/blog/the-complete-guide-to-using-a-seed-drill-correctly

[^27_8]: https://www.arrichards.co.uk/guide-to-drilling-seeds-equipment-arrichards/

[^27_9]: https://www.vaderstad.com/ca-en/know-how/farming-practises/direct-seeding

[^27_10]: https://pub.epsilon.slu.se/553/1/Agraria_462.pdf

[^27_11]: https://www.agrivi.com/blog/field-management-farming-facts-every-grower-should-know/

[^27_12]: https://www.soft.farm/en/blog/automation-of-crop-rotation-planning-for-farmers-and-medium-sized-agricultural-enterprises-196

[^27_13]: https://www.sciencedirect.com/science/article/pii/S0168169925004983

[^27_14]: https://www.reddit.com/r/farmingsimulator/comments/1gugi3v/what_is_your_field_work_cycle/

[^27_15]: https://www.oxmaint.com/blog/post/agricultural-fleet-management-software-2025


---
