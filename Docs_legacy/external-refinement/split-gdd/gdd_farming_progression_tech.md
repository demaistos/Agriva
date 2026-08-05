# Agriva GDD — Farming — Progression, Abonnement & Tech
> Progression, objectifs, abonnement confort, stack technique, entités métier, cycle simulation

---


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

