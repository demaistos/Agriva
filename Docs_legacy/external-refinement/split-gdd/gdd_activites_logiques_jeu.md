# Agriva GDD — Activités — Logiques de Jeu
> Anti-second-travail, abstraction Normal/Expert, logiques transversales, règles de design

---

---

# Je veux quand même que ça reste un jeu et pas un deuxième travail dans la complexité qui ferait fuir les joueurs

Oui, et c’est une très bonne alerte. Un jeu de gestion profond ne doit pas demander au joueur de porter en permanence toute la complexité du système ; la bonne direction est donc de viser de la **profondeur avec complexité contenue**, en limitant la complexité de compréhension et de suivi tout en gardant de vraies décisions intéressantes.[^49_1][^49_2]

## Principe directeur

La règle la plus importante pour Agriva pourrait être :

**Le joueur doit prendre des décisions agricoles intéressantes, pas faire de la paperasse simulée.**

Les travaux sur la complexité en game design distinguent justement la profondeur stratégique de la complexité de compréhension ou de suivi, et recommandent de supprimer tout ce qui ajoute de la charge mentale sans enrichir les choix.[^49_3][^49_4][^49_1]

## Ce qu’il faut éviter

Je ferais très attention à :

- la micro-gestion permanente ;
- les écrans remplis de paramètres ;
- les tâches répétitives sans arbitrage ;
- les systèmes trop nombreux visibles d’un coup ;
- les détails réalistes qui ne produisent pas de choix amusants.

La recherche UX sur la charge cognitive et la divulgation progressive montre qu’il faut montrer peu d’options au départ, puis révéler les fonctions avancées seulement quand elles deviennent utiles, afin d’éviter l’effet “deuxième travail”.[^49_5][^49_6][^49_7]

## Les bons leviers

Pour garder le jeu agréable, je vous conseille ces 6 principes :

1. **Boucle simple, systèmes profonds** : la boucle de base doit rester compréhensible en quelques minutes, même si le système derrière est riche.[^49_2][^49_3]
2. **Progressive disclosure** : options avancées cachées tant qu’elles ne sont pas nécessaires.[^49_6][^49_8][^49_5]
3. **Automatisation progressive** : plus l’exploitation grandit, plus le joueur débloque des moyens de déléguer.
4. **Agrégation intelligente** : raisonner en lots, ateliers, troupeaux, campagnes, pas en centaines d’actions unitaires.
5. **Feedback clair** : chaque décision doit montrer clairement son effet.
6. **Exceptions plutôt que surveillance constante** : alerter seulement quand quelque chose mérite vraiment l’attention du joueur.

## Ce que ça veut dire pour Agriva

Concrètement, je ferais un jeu où :

- la météo influence fortement les choix, mais sans exiger 15 réglages ;
- les parcelles existent, mais sont gérées comme unités claires et lisibles ;
- l’élevage existe, mais à travers des indicateurs synthétiques avant d’aller dans le détail ;
- l’économie est réelle, mais présentée par grandes masses avant le niveau comptable fin.

Autrement dit, le système peut être riche en arrière-plan, mais l’interface doit rester centrée sur quelques décisions importantes par cycle de jeu, ce qui suit bien les principes de réduction de charge cognitive et de progression par couches.[^49_9][^49_7][^49_5]

## Ma recommandation nette

Je vous conseille de poser noir sur blanc ces règles de design :

- une action répétée plus de 3 fois doit être batchable, automatisable ou supprimée ;
- un système n’existe que s’il crée un arbitrage visible ;
- un écran principal ne doit pas exposer trop de variables à la fois ;
- la croissance de l’exploitation doit augmenter les enjeux, pas multiplier mécaniquement les clics ;
- chaque couche avancée doit pouvoir être ignorée au début sans pénaliser fortement le joueur.[^49_5][^49_6]


## Test simple

Pour chaque future mécanique, posez-vous 3 questions :

- Est-ce qu’elle crée une vraie décision ?
- Est-ce qu’elle est compréhensible sans tutoriel lourd ?
- Est-ce qu’elle reste amusante après 50 utilisations ?

Si la réponse est non à l’une de ces questions, il faut probablement simplifier, agréger ou repousser la mécanique. Oui, il faut absolument protéger Agriva de l’effet “deuxième travail”, et votre instinct là-dessus est très sain.[^49_7][^49_1][^49_3]
<span style="display:none">[^49_10][^49_11][^49_12][^49_13][^49_14][^49_15]</span>

<div align="center">⁂</div>

[^49_1]: https://www.gamedeveloper.com/design/design-101-complexity-vs-depth

[^49_2]: https://nexus.leagueoflegends.com/en-us/2016/10/dev-on-depth-vs-accessibility/

[^49_3]: https://www.reddit.com/r/gamedesign/comments/15nq4px/how_can_i_add_depth_to_my_game_without/

[^49_4]: https://www.reddit.com/r/gamedesign/comments/17ii0ra/guidelines_to_evaluating_depth_while_avoiding/

[^49_5]: https://www.nngroup.com/articles/progressive-disclosure/

[^49_6]: https://ixdf.org/literature/topics/progressive-disclosure

[^49_7]: https://www.bloodmooninteractive.com/articles/cognitive-load-in-game-design.html

[^49_8]: https://www.uxpin.com/studio/blog/what-is-progressive-disclosure/

[^49_9]: https://matthewhadick.com/PDFs/HCI5300X_DeepDive_Hadick.pdf

[^49_10]: https://www.reddit.com/r/Games/comments/2yipk4/does_complexity_depth_is_a_trend_toward/

[^49_11]: https://kva.com.ec/how-game-complexity-shapes-modern-design/

[^49_12]: https://journals.sagepub.com/doi/10.1177/10468781231222524

[^49_13]: https://www.linkedin.com/posts/dylansparling_mental-overload-in-game-design-when-designing-activity-7363925531249045505-Ypl9

[^49_14]: https://sparkco.ai/blog/mastering-progressive-disclosure-a-comprehensive-guide

[^49_15]: https://xuanmingzhou.com/blog/depth-and-complexity-in-games/


---

# Oui par exemple faire un système plus simple que le NPK pour une parcelle en normal et dans le futur en expert le mettre

Oui, c’est une **très bonne idée**. Remplacer le NPK détaillé par un indicateur plus simple en mode normal, puis réserver le NPK réel à un mode expert, correspond bien aux principes de profondeur accessible, de difficulté paramétrable et de divulgation progressive des systèmes complexes.[^50_1][^50_2][^50_3]

## Ce que je ferais

En mode normal, je ne montrerais pas $N$, $P$, $K$ séparément. Je remplacerais cela par 2 ou 3 jauges synthétiques, par exemple :

- fertilité ;
- réserve du sol ;
- état agronomique.

Les recherches agronomiques utilisent d’ailleurs souvent des **indicateurs synthétiques de santé/fertilité du sol** pour résumer des ensembles de variables plus complexes, ce qui va bien dans le sens d’une abstraction gameplay lisible.[^50_4][^50_5]

## Proposition concrète

Je verrais très bien deux couches :


| Mode | Système parcelle |
| :-- | :-- |
| Normal | Indicateurs synthétiques simples, lisibles en un coup d’œil |
| Expert | Détails agronomiques avancés, dont NPK séparé et gestion plus fine |

En gameplay, cela permet aux nouveaux joueurs de raisonner en termes de “sol en forme / sol fatigué / sol à corriger”, tandis que les joueurs avancés peuvent optimiser plus finement la fertilisation et les rendements, ce qui correspond aussi à l’idée que les niveaux de difficulté doivent changer la nature des décisions et pas seulement les chiffres.[^50_6][^50_7][^50_1]

## Le bon niveau d’abstraction

Je pense qu’en mode normal, un modèle comme celui-ci serait excellent :

- **Fertilité** : potentiel global du sol.
- **Équilibre** : qualité de la conduite récente, rotations, apports, pression culturale.
- **Humidité utile** ou **réserve** : état hydrique simplifié.
- éventuellement **pression sanitaire** ou **fatigue culturale** plus tard.

Le joueur comprend immédiatement quoi faire, sans entrer dans une logique de tableau chimique.

## Comment relier les deux modes

Le plus intelligent serait que le mode expert ne change pas totalement le jeu, mais **déplie** le système caché.
Par exemple :

- en normal, “fertilité = 62/100” ;
- en expert, cette fertilité est calculée à partir de plusieurs composantes dont $N$, $P$, $K$, matière organique, historique cultural ou efficacité des apports.

Comme ça, vous avez un seul cœur de simulation, mais deux niveaux de lecture. La divulgation progressive est précisément recommandée pour masquer la complexité inutile au départ et révéler les détails au moment où l’utilisateur est prêt à les exploiter.[^50_3][^50_8][^50_9]

## Pourquoi c’est bon pour Agriva

Cette approche vous donne plusieurs avantages :

- onboarding plus doux ;
- interface beaucoup plus lisible ;
- profondeur conservée pour plus tard ;
- meilleure rejouabilité ;
- possibilité d’avoir un vrai “mode expert” qui apporte du sens.

Des jeux et outils agricoles orientés précision montrent que la gestion détaillée du sol, des cartes de sol et des nutriments devient intéressante quand elle s’appuie sur des outils plus avancés, pas forcément comme couche de base imposée à tous les joueurs.[^50_10][^50_11]

## Ma recommandation nette

Je poserais cette règle de design :

**Le mode normal montre les conséquences, le mode expert montre les causes.**

C’est une règle très forte.

Exemple :

- normal : “ta parcelle perd en fertilité” ;
- expert : “ta parcelle manque surtout d’azote et d’équilibre de fertilisation”.


## Version très concrète

Si vous voulez quelque chose de simple, je commencerais par :

### Mode normal

- Fertilité : 0 à 100
- Réserve hydrique : 0 à 100
- Fatigue culturale : 0 à 100


### Mode expert

- Azote
- Phosphore
- Potasse
- Matière organique
- pH éventuellement plus tard
- historique des apports
- efficience de fertilisation


## Point d’attention

Je n’introduirais pas le mode expert trop tôt.
Il faut d’abord que le mode normal soit déjà amusant, clair et satisfaisant. Sinon le mode expert risque de devenir un pansement sur un système encore mal calibré.

Oui, donc votre exemple est exactement le bon réflexe de design : **abstraction simple d’abord, simulation détaillée ensuite**.[^50_12][^50_4][^50_3]
<span style="display:none">[^50_13][^50_14][^50_15][^50_16][^50_17][^50_18][^50_19]</span>

<div align="center">⁂</div>

[^50_1]: https://www.gamedeveloper.com/design/the-designer-s-notebook-difficulty-modes-and-dynamic-difficulty-adjustment

[^50_2]: https://ecampusontario.pressbooks.pub/gamedesigndevelopmenttextbook/chapter/managing-difficulty-in-games/

[^50_3]: https://www.nngroup.com/articles/progressive-disclosure/

[^50_4]: https://www.sciencedirect.com/science/article/pii/S001670612400065X

[^50_5]: https://www.fertilizer.org/wp-content/uploads/2023/01/2014_IPNI_Issue_Review_14061.pdf

[^50_6]: https://game-wisdom.com/critical/difficulty-changed-game-design

[^50_7]: https://www.gamedev.net/tutorials/game-design/game-design-and-theory/game-design-a-different-approach-to-difficulty-r4992/

[^50_8]: https://ixdf.org/literature/topics/progressive-disclosure

[^50_9]: https://www.uxpin.com/studio/blog/what-is-progressive-disclosure/

[^50_10]: https://www.reading.ac.uk/news/2022/Research-News/Farming-Sim-22

[^50_11]: https://sefari.scot/blog/2024/12/10/farming-meets-gaming-how-cropsim-brings-agricultural-science-to-life

[^50_12]: https://www.gamedeveloper.com/design/design-101-complexity-vs-depth

[^50_13]: https://www.reddit.com/r/gamedesign/comments/1q847vj/how_do_you_design_difficulty_modes/

[^50_14]: https://www.frontiersin.org/journals/plant-science/articles/10.3389/fpls.2025.1579011/full

[^50_15]: https://lume.ufrgs.br/bitstream/handle/10183/245329/001145461.pdf?sequence=1

[^50_16]: https://www.universityxp.com/blog/2024/1/16/what-are-progression-systems-in-games

[^50_17]: https://pmc.ncbi.nlm.nih.gov/articles/PMC12990597/

[^50_18]: https://wateragri.eu/solutions/serious-gaming/

[^50_19]: https://pmc.ncbi.nlm.nih.gov/articles/PMC11179034/


---

# Et cette logique s’appliquera partout

Oui, et je pense même que ça doit devenir une **règle fondatrice globale** d’Agriva. Les principes de progressive disclosure recommandent d’utiliser une logique cohérente dans toute l’expérience, avec des schémas de révélation constants, afin que l’utilisateur sache toujours comment la complexité est cachée puis révélée au bon moment.[^51_1][^51_2][^51_3]

## Règle centrale

Je formulerais la règle ainsi :

**Chaque système du jeu doit exister en lecture simple par défaut, avec une lecture avancée optionnelle.**

C’est cohérent avec les approches qui distinguent profondeur et complexité, et avec l’idée qu’un jeu peut rester riche en décisions tout en limitant la charge mentale imposée au joueur.[^51_4][^51_5][^51_6]

## Où l’appliquer

Oui, cette logique peut s’appliquer presque partout :


| Système | Mode normal | Mode expert |
| :-- | :-- | :-- |
| Sol | Fertilité globale | NPK, MO, pH, détails |
| Météo | Impact synthétique | variables fines, historique |
| Élevage | Santé / production / charge | ration, reproduction, lots détaillés |
| Économie | Résultat, charges, trésorerie | postes fins, amortissements, marges |
| Matériel | état général, capacité | usure détaillée, coûts techniques |
| Main-d’œuvre | disponibilité / charge | planning fin, spécialisation, saisonniers |
| Logistique | stockage et flux simplifiés | transport détaillé, saturation, arbitrages |
| Commercial | vente simple | contrats, timing, débouchés multiples |

## Ce que ça change en design

Cela veut dire que vous ne concevez plus :

- un système “simple” puis un autre “expert” séparé ;
- mais **un seul système à plusieurs niveaux de lecture**.

C’est important, parce qu’une divulgation progressive réussie garde une structure cohérente entre novice et expert, au lieu de créer deux jeux différents.[^51_7][^51_8][^51_1]

## Les bons principes

Je vous conseille 5 règles transversales :

- **visible simple, calcul interne riche** ;
- **normal = conséquences**, **expert = causes** ;
- **pas d’écran expert imposé au joueur standard** ;
- **les mêmes mots et les mêmes objets doivent rester valables dans tous les modes** ;
- **chaque couche avancée doit enrichir les décisions, pas seulement ajouter des chiffres**.[^51_6][^51_4]


## Exemple très clair

Prenons l’économie :

- en normal : trésorerie, coûts, revenus, rentabilité globale ;
- en expert : amortissements, structure de charges, dette, poste par atelier, marge détaillée.

Le joueur standard comprend la santé économique de son exploitation sans devenir comptable, tandis que l’expert peut optimiser ses arbitrages plus finement. Cette logique est précisément en phase avec les approches de difficulté par couches et avec l’idée d’offrir une base accessible puis des raffinements optionnels.[^51_9][^51_10]

## Point de vigilance

La seule vraie limite, c’est la cohérence.
Si chaque système a une logique de simplification différente, le jeu deviendra confus.

Donc je fixerais une convention unique :

- partout, un **niveau synthétique** ;
- partout, un **niveau détaillé** ;
- partout, des **alertes simples** avant les tableaux experts ;
- partout, une **progression maîtrisée** de la complexité.


## Formule de design

Je pense que vous tenez là une très bonne devise produit :

**Agriva doit être simple à lire, profond à maîtriser, et détaillé seulement sur demande.**

C’est probablement l’une des meilleures bases possibles pour éviter l’effet “deuxième travail” tout en gardant une vraie ambition de simulation.[^51_1][^51_4][^51_6]
<span style="display:none">[^51_11][^51_12][^51_13][^51_14][^51_15]</span>

<div align="center">⁂</div>

[^51_1]: https://www.nngroup.com/articles/progressive-disclosure/

[^51_2]: https://blog.logrocket.com/ux-design/progressive-disclosure-ux-types-use-cases/

[^51_3]: https://learn.microsoft.com/en-us/windows/win32/uxguide/ctrl-progressive-disclosure-controls

[^51_4]: https://www.accidentalcyclops.com/depth-vs-complexity/

[^51_5]: https://www.superjumpmagazine.com/the-difference-between-complexity-and-depth-in-video-games/

[^51_6]: https://www.gamedeveloper.com/design/the-rld-handbook-sometimes-it-s-not-about-the-metrics---depth-complexity

[^51_7]: https://uxuiprinciples.com/en/principles/progressive-disclosure

[^51_8]: https://ixdf.org/literature/topics/progressive-disclosure

[^51_9]: https://www.strayspark.studio/blog/difficulty-systems-players-enjoy

[^51_10]: https://ecampusontario.pressbooks.pub/gamedesigndevelopmenttextbook/chapter/managing-difficulty-in-games/

[^51_11]: https://magora-systems.com/ux-design-progressive-disclosure/pdf

[^51_12]: https://www.reddit.com/r/gamedev/comments/1gssi9r/how_complicated_is_it_to_create_different/

[^51_13]: https://ui-patterns.com/patterns/ProgressiveDisclosure

[^51_14]: https://babich.biz/blog/design-patterns-progressive-disclosure-for-mobile-apps/

[^51_15]: https://www.youtube.com/watch?v=Hb4i02fnc2k


---