# Agriva GDD — Farming — Workflow Semer
> Workflow complet action semer : dépendances, validations, exécution, effets aval

---


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