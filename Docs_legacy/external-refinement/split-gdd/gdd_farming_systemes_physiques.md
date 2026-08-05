# Agriva GDD — Farming — Systèmes Physiques
> Météo, Parcelles, Cultures, Matériel, Travaux, Temps d'exécution, Main-d'œuvre, Planning

---

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