# Agriva GDD — Economy — Planification & Ressources
> Capacité de travail, matériel, planification prévisionnelle, faisabilité, file de tâches

---

# Ok très bien.

Vois tu d’autre choses ? Quel seront les différente monnaie que le joueur aura à disposition chaque jour ? Argent ? Capacité de travail en heure ?

Oui, il y a encore quelque chose de très structurant à statuer : **quelles sont les vraies monnaies / ressources de décision du joueur au quotidien**. En jeu de gestion, les ressources clés ne se limitent pas à l’argent ; le temps, la capacité de travail, les intrants, la logistique et la capacité de production sont souvent tout aussi déterminants, et une bonne économie de jeu repose justement sur des ressources limitées que le joueur doit arbitrer intelligemment.[^59_1][^59_2][^59_3]

## Ce que je recommande

Je ne ferais pas trop de monnaies abstraites.
Je partirais sur un système très lisible avec **quelques ressources quotidiennes ou périodiques majeures** :


| Ressource | Rôle |
| :-- | :-- |
| Argent | payer, investir, absorber les aléas |
| Temps | organiser les actions et priorités |
| Capacité de travail | main-d’œuvre disponible |
| Capacité machine | ce que l’exploitation peut réellement exécuter |
| Stockage | ce que l’on peut conserver sans vendre tout de suite |
| Logistique | ce qu’on peut déplacer / livrer / collecter |

## Les 2 monnaies centrales

Pour moi, les deux plus importantes doivent être :

### 1. Argent

C’est la monnaie universelle :

- achat ;
- vente ;
- salaires ;
- intrants ;
- investissements ;
- charges.


### 2. Capacité de travail

Je pense que vous avez raison de penser en **heures de travail**, ou en une abstraction proche.
Dans une exploitation agricole, le vrai blocage n’est pas seulement financier ; c’est aussi la capacité humaine à faire les tâches au bon moment. Les jeux de gestion et de resource management montrent souvent que temps et capacité de travail créent des arbitrages plus intéressants que l’argent seul.[^59_4][^59_1]

## Comment je le modéliserais

Je ferais une distinction simple :

- **Argent** = ressource financière.
- **Heures de travail** = capacité humaine disponible par jour ou semaine.
- **Heures machine** ou **capacité d’exécution** = capacité technique de l’exploitation.

Ainsi, une tâche peut demander :

- de l’argent ;
- du travail ;
- parfois du matériel ;
- parfois une fenêtre météo.

C’est beaucoup plus intéressant qu’un simple “payer = faire”.

## Mon avis sur le rythme

Je ne mettrais pas trop de ressources “qui reset chaque jour” si cela devient artificiel.
Je ferais plutôt :

- l’**argent** persiste évidemment ;
- la **main-d’œuvre disponible** se renouvelle par jour ou par semaine ;
- la **capacité machine** dépend des équipements, des pannes, de la saison et des affectations ;
- le **temps de campagne** ou la fenêtre météo crée la vraie pression.

Autrement dit, la ressource quotidienne n’est pas seulement “des points d’action”, mais une combinaison crédible entre travail, matériel et calendrier.

## Les autres ressources importantes

En plus, je retiendrais comme ressources secondaires :

- **intrants** : semences, engrais, alimentation, carburant ;
- **stocks** : récoltes, fourrages, bois, produits transformés ;
- **cheptel** : pas une monnaie, mais un capital productif ;
- **fertilité / état des parcelles** : capital agronomique ;
- **réputation / contrats / accès marché** éventuellement plus tard.

Les systèmes de resource management sont généralement plus solides quand ils mélangent monnaie liquide, ressources de capacité et ressources de transformation, au lieu de tout ramener à un seul compteur.[^59_2][^59_5][^59_6]

## Ce que je ne ferais pas

Je n’ajouterais pas trop tôt :

- énergie type mobile game ;
- points d’action artificiels ;
- monnaies secondaires décoratives ;
- trop de barres qui se vident chaque jour sans sens métier.

Pour Agriva, je pense qu’il faut rester au plus près de ressources qui ont une vraie traduction agricole.

## Ce que je statuerais maintenant

Si je tranche, je dirais que les **ressources de pilotage principales** sont :

1. **Argent**
2. **Temps / calendrier**
3. **Capacité de travail**
4. **Capacité machine**
5. **Stocks**
6. **Capacité logistique**

Et les **ressources métier spécifiques** sont :

- parcelles ;
- cheptel ;
- fertilité ;
- eau selon les systèmes ;
- fourrages / intrants ;
- bâtiments.


## Version très simple pour la V1

Pour ne pas surcharger, je commencerais avec :

- argent ;
- heures de travail ;
- disponibilité machine ;
- stockage ;
- intrants principaux.

C’est déjà largement suffisant pour créer des arbitrages intéressants.

## Ma recommandation nette

Donc oui :

- **argent** doit être une monnaie centrale ;
- **capacité de travail en heures** est une très bonne idée ;
- j’ajouterais aussi une notion de **capacité machine** ;
- et je traiterais le reste comme ressources métier spécifiques plutôt que comme monnaies génériques.


## Règle de design

Je poserais cette règle :

**Une ressource n’existe dans Agriva que si elle crée un arbitrage clair entre faire maintenant, faire plus tard, déléguer, investir ou renoncer.**

C’est, selon moi, le bon filtre pour éviter de multiplier inutilement les compteurs.
<span style="display:none">[^59_10][^59_11][^59_12][^59_13][^59_14][^59_15][^59_7][^59_8][^59_9]</span>

<div align="center">⁂</div>

[^59_1]: https://www.meegle.com/en_us/topics/game-design/resource-management

[^59_2]: https://deliberategamedesign.com/resources-loop/

[^59_3]: https://arxiv.org/html/2506.04699v1

[^59_4]: https://discussions.unity.com/t/economy-design-in-a-single-player-simulation-game/596443

[^59_5]: https://www.smoothiewars.com/blog/competitive-strategy-resource-management-games

[^59_6]: https://docs.sandbox.game/en/creators/game-maker/creative-guides/experience-guide/resource-management

[^59_7]: https://repositori.tecnocampus.cat/bitstream/handle/20.500.12367/2351/TFG_MarcosVaquero_Memoria.pdf?isAllowed=y\&sequence=1

[^59_8]: https://www.smoothiewars.com/blog/resource-management-mechanics-guide

[^59_9]: https://www.reddit.com/r/mmt_economics/comments/1p12sv9/economic_simulation_game_based_on_mmt/

[^59_10]: https://befitgametek.com/comprehensive-guide-to-resource-management-in-strategy-games/

[^59_11]: https://www.reddit.com/r/gamedesign/comments/19a35u2/designing_balanced_resource_management_games/

[^59_12]: https://chillplacegaming.com/resource-management-tactics/

[^59_13]: https://repositori.tecnocampus.cat/bitstream/handle/20.500.12367/2351/TFG_MarcosVaquero_Memoria.pdf?sequence=1\&isAllowed=y

[^59_14]: https://www.reddit.com/r/gamedev/comments/1f0gf3g/how_does_one_balance_a_game_where_your_resources/

[^59_15]: https://www.unamur.be/en/management-simulation-business-game-5


---

# Capacité de travail reset par jour. Pour capacité machine ça sera lié au matériel (tracteur semoir)

Oui, ça me paraît **très bien**. Une capacité de travail qui se réinitialise chaque jour, et une capacité machine dérivée directement du matériel disponible, donnent un modèle clair, compréhensible et cohérent avec une logique de planification par ressources finies.[^60_1][^60_2]

## Capacité de travail

Je validerais cette règle :

**Chaque jour, l’exploitation dispose d’un capital d’heures de travail disponible.**

Cette capacité quotidienne est une très bonne ressource de pilotage, parce qu’elle oblige le joueur à arbitrer entre les tâches du jour sans introduire une monnaie artificielle trop éloignée du métier. Les approches de capacity planning insistent d’ailleurs sur l’importance de raisonner en heures réellement disponibles plutôt qu’en simple nombre de personnes.[^60_3][^60_4]

## Capacité machine

Et oui, la capacité machine doit venir du matériel :

- tracteur ;
- semoir ;
- moissonneuse ;
- remorque ;
- épandeur ;
- etc.

Autrement dit, une action ne doit pas seulement consommer du travail humain ; elle doit aussi mobiliser le bon équipement. Les approches de planification de capacité montrent justement que les goulots d’étranglement apparaissent souvent au niveau des ressources critiques, notamment les machines et équipements, pas seulement au niveau de la main-d’œuvre.[^60_5][^60_6][^60_2]

## Modèle simple que je recommande

Je ferais une tâche agricole avec trois conditions :


| Condition | Exemple |
| :-- | :-- |
| Heures de travail | 4 h |
| Capacité machine | 1 tracteur + 1 semoir pendant 4 h |
| Fenêtre de contexte | bonne météo / bonne période |

C’est un très bon modèle, car il reste simple à lire tout en créant de vrais arbitrages :

- manque-t-on d’heures humaines ?
- manque-t-on de matériel ?
- ou rate-t-on la bonne fenêtre météo ?


## Ce que ça implique

Cette logique vous permet aussi d’avoir une progression très saine :

- embaucher augmente la capacité de travail ;
- acheter du matériel augmente la capacité machine ;
- mieux s’organiser améliore l’utilisation des deux.

Du coup, la croissance de l’exploitation ne repose pas uniquement sur l’argent, mais sur l’augmentation réelle des moyens d’action.

## Ma recommandation de formulation

Je poserais noir sur blanc :

- **Capacité de travail** : se renouvelle chaque jour.
- **Capacité machine** : dépend du parc matériel et de sa disponibilité.
- **Une opération agricole consomme les deux**.
- **Le calendrier et la météo décident si l’opération est possible ou non**.


## Point important

Je ne transformerais pas trop vite chaque machine en compteur séparé complexe dans l’interface.
Au départ, vous pouvez garder une lecture simple :

- matériel disponible ;
- matériel occupé ;
- matériel insuffisant.

Puis, en mode expert, détailler davantage les temps, compatibilités et goulots.

## Ce que je considère comme statué

Si je tranche, je retiens donc :

- heures de travail quotidiennes reset chaque jour ;
- capacité machine liée aux équipements possédés ;
- tâches consommant à la fois travail et matériel ;
- météo et calendrier comme conditions externes ;
- progression par main-d’œuvre + matériel + organisation.

Franchement, c’est une très bonne base de simulation, parce qu’elle crée des décisions réelles sans tomber dans une usine à gaz.[^60_2][^60_3][^60_1]
<span style="display:none">[^60_10][^60_11][^60_12][^60_13][^60_14][^60_15][^60_7][^60_8][^60_9]</span>

<div align="center">⁂</div>

[^60_1]: https://www.meegle.com/en_us/topics/game-design/resource-management

[^60_2]: https://ieeexplore.ieee.org/document/717251/

[^60_3]: https://www.aihr.com/blog/workforce-capacity-planning/

[^60_4]: https://www.meistertask.com/blog/resource-capacity-planning-101-everything-you-need-to-know

[^60_5]: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5066290

[^60_6]: https://livrepository.liverpool.ac.uk/3176324/2/240375_vol1.pdf

[^60_7]: https://www.linkedin.com/posts/gem-resource-management-solutions_rmcp-resourcemanagement-activity-7411556877228011520-Luy1

[^60_8]: https://community.atlassian.com/forums/App-Central-articles/Practices-for-Resource-Capacity-Planning-Managers-Need-to-Know/ba-p/3131037

[^60_9]: https://fr.celoxis.com/article/best-capacity-planning-tools

[^60_10]: https://productive.io/blog/capacity-management/

[^60_11]: https://www.eresourcescheduler.com/resource-capacity-planning

[^60_12]: https://www.saviom.com/blog/how-can-robust-resource-management-future-proof-the-gaming-industry/

[^60_13]: https://loadmaster.ai/equipment-utilisation-simulation-transport/

[^60_14]: https://baserow.io/blog/resource-management-tool-modern-teams

[^60_15]: https://teamdeck.io/uncategorized/resource-capacity-planning/


---

# Très bien et pour la partie planification je veux que quand le joueur défini des tâches à la suite ça près consomme ce qu’il faut car si ils en fait plusieurs et calcul mal sont coup il aura pas la visibilité direct de la faisabilité ou non ? Qu’en pense tu ?

Oui, je pense que vous avez raison de vouloir une **consommation prévisionnelle immédiate** pendant la planification. Les bonnes pratiques de capacity planning recommandent de montrer les contraintes et conflits dès la phase de planification, avec une vue visuelle des ressources disponibles et des goulots, afin d’éviter que l’utilisateur découvre trop tard qu’un enchaînement n’est pas faisable.[^61_1][^61_2][^61_3]

## Mon avis net

Je ferais donc ceci :

**quand le joueur empile des tâches, le jeu doit immédiatement réserver ou projeter la consommation des ressources nécessaires.**

Sinon, il perd la visibilité sur :

- les heures de travail restantes ;
- le matériel déjà mobilisé ;
- la faisabilité réelle de la séquence ;
- les conflits de planning.


## Pourquoi c’est important

Si le joueur peut planifier 5 tâches sans voir leur coût cumulé, il devra faire les calculs dans sa tête ou découvrir les blocages après validation. Cela augmente inutilement la charge mentale, alors que les interfaces de planification efficaces montrent justement les écarts entre capacité disponible et demande prévue avant l’exécution.[^61_4][^61_1]

## Ce que je recommande

Je ferais une **planification avec simulation instantanée** :

À chaque tâche ajoutée à la file :

- les heures de travail disponibles diminuent en prévisionnel ;
- les machines concernées passent en “réservées” sur la durée prévue ;
- la météo / fenêtre de temps est vérifiée ;
- un statut visuel apparaît : faisable, tendu, impossible.


## Le bon fonctionnement UI

Je verrais très bien une file de tâches avec :


| Élément | Fonction |
| :-- | :-- |
| Consommation prévue | heures + machines requises |
| Ressources restantes | après ajout de la tâche |
| Statut | OK, tension, blocage |
| Cause du blocage | manque de temps, machine absente, météo, conflit |
| Réorganisation | glisser-déposer, suppression, re-priorisation |

C’est ce type de visualisation qui aide le joueur à comprendre immédiatement les conséquences de ses choix.[^61_2][^61_1]

## Ma recommandation précise

Je ne bloquerais pas forcément dès le premier dépassement.
Je mettrais plutôt 3 états :

- **Vert** : faisable.
- **Orange** : faisable mais tendu, marge faible.
- **Rouge** : non faisable en l’état.

Comme ça, le joueur garde de la liberté, mais il comprend tout de suite ce qui coince.

## Très bonne règle de design

Je vous propose cette règle :

**Une tâche planifiée doit consommer immédiatement les ressources en prévisionnel, même avant son exécution réelle.**

C’est, selon moi, la bonne base.

## Nuance importante

Je distinguerais bien :

- **réservation prévisionnelle** dans le planning ;
- **consommation réelle** au moment de l’exécution.

Exemple :

- les heures de travail du lendemain sont “réservées” si une tâche est planifiée ;
- elles ne sont réellement consommées qu’au moment où le jour se joue ou se résout.

Cette distinction est très utile, parce qu’elle garde une logique de simulation propre sans sacrifier la lisibilité.

## Ce que je ferais dans Agriva

Concrètement :

- le joueur ajoute “semer parcelle A” ;
- le jeu réserve 4 h de travail + tracteur + semoir ;
- il ajoute “épandre parcelle B” ;
- le jeu recalcule le reliquat ;
- s’il n’a plus assez de capacité, la tâche passe en orange ou rouge ;
- l’interface dit clairement pourquoi.

C’est beaucoup mieux que de laisser passer un planning irréaliste puis de sanctionner après coup.

## Ce que je considère comme statué

Si je tranche :

- oui à une file de tâches ;
- oui à une consommation **prévisionnelle immédiate** ;
- oui à un reliquat visible en temps réel ;
- oui à des alertes de faisabilité ;
- non à une planification aveugle.

Franchement, c’est la bonne décision. Elle rendra le jeu bien plus lisible, plus moderne, et surtout beaucoup moins pénible à jouer.[^61_3][^61_1][^61_4]
<span style="display:none">[^61_10][^61_11][^61_12][^61_13][^61_14][^61_15][^61_5][^61_6][^61_7][^61_8][^61_9]</span>

<div align="center">⁂</div>

[^61_1]: https://www.visual-planning.com/en/blog/resource-capacity-planning

[^61_2]: https://www.ppm.express/blog/resource-scheduling

[^61_3]: https://lucid.co/blog/capacity-planning

[^61_4]: https://craft.io/guide/capacity-planning-a-step-by-step-guide/

[^61_5]: https://www.reddit.com/r/gamedev/comments/1703cya/solo_dev_project_management_process_and_tools/

[^61_6]: https://www.justinmind.com/ui-design/game

[^61_7]: https://dribbble.com/search/queue-management

[^61_8]: https://stackoverflow.com/questions/2617413/game-architecture-modeling-different-steps-types-of-ui

[^61_9]: https://www.gridsagegames.com/blog/2016/06/iterative-ui-design/

[^61_10]: https://chuchugame.com/blog/news/how-to-schedule-like-a-pro--resource-allocation--agent-management--and-automation

[^61_11]: https://github.com/VoltAgent/awesome-agent-skills

[^61_12]: https://www.engineering.org.cn/engi/EN/PDF/10.1016/j.eng.2025.07.033

[^61_13]: https://www.reddit.com/r/agile/comments/1i4uprh/how_do_you_do_capacity_planning/

[^61_14]: https://www.toptal.com/designers/ui/game-ui

[^61_15]: https://arxiv.org/html/2604.25301v1


---