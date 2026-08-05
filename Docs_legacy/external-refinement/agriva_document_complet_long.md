
# AGRIVA — Document complet long avec questions et options

## Mode d’emploi
Ce document est la version longue du cadrage d’Agriva. Il combine la vision, les principes, les systèmes, les décisions déjà prises, les thèmes à statuer et les questions structurées avec trois options cohérentes.

Utilisation recommandée :
- lire le master pour comprendre la vision ;
- parcourir les thèmes pour identifier les sujets à arbitrer ;
- utiliser les options A/B/C pour décider rapidement ;
- compléter ensuite le log de décisions ;
- garder la règle normal / expert comme filtre permanent.

---

## 1. Vision produit

### 1.1 Promesse centrale
Agriva doit être un jeu de gestion agricole moderne, crédible, lisible et stratégique, mais sans devenir une seconde charge de travail.

#### Question : quelle est la promesse centrale ?
- A. Gestion agricole accessible et moderne.
- B. Simulation agricole crédible et profonde.
- C. Sandbox agricole évolutif et systémique.

#### Question : quel réalisme viser ?
- A. Réalisme ludique.
- B. Réalisme sélectif.
- C. Réalisme élevé.

#### Question : quelle cible prioritaire ?
- A. Joueurs de gestion généralistes.
- B. Joueurs agricoles / simulation.
- C. Public mixte avec montée progressive de complexité.

#### Question : quel équilibre fun / simulation ?
- A. Fun d’abord, simulation au service du fun.
- B. Équilibre strict fun/simulation.
- C. Simulation d’abord, fun par l’arbitrage.

#### Question : quelle fantasy centrale ?
- A. Diriger une ferme.
- B. Construire un empire agricole.
- C. Gérer un territoire agricole vivant.

### 1.2 Différenciation
Le jeu doit se distinguer par :
- une lecture claire en mode normal ;
- une profondeur modulable en mode expert ;
- un ancrage territorial fort ;
- une économie hybride bot + joueur ;
- une planification lisible et moderne ;
- une diversité de filières agricoles et para-agricoles.

---

## 2. Piliers de design

### 2.1 Piliers retenus
- Lisibilité en premier.
- Profondeur sur demande.
- Territoire comme système.
- Planning comme cœur décisionnel.
- Économie hybride vivante.
- Progression par maîtrise, pas par clics.
- Complexité progressive.

### 2.2 Anti-piliers
- Pas de micro-gestion inutile.
- Pas de surcharge cognitive.
- Pas de mécanique sans décision.
- Pas de système complexe visible dès le début.
- Pas de simulation qui remplace le plaisir.

### 2.3 Question de cadrage
- A. 3 piliers.
- B. 5 piliers.
- C. 6 ou 7 piliers.

### 2.4 Filtre de validation
Une mécanique ne doit être conservée que si elle :
- crée une vraie décision ;
- renforce la boucle principale ;
- reste lisible en mode normal ;
- peut être détaillée en mode expert si nécessaire.

---

## 3. Boucle de jeu

### 3.1 Boucle principale
**observer -> évaluer -> planifier -> réserver -> exécuter -> vendre / acheter -> investir -> progresser**.

### 3.2 Question de rythme
- A. Quotidien.
- B. Hebdomadaire.
- C. Mixte quotidien + saisonnier.

### 3.3 Question de structure
- A. Boucle courte et fréquente.
- B. Boucle moyenne avec paquets de tâches.
- C. Boucle large avec plusieurs niveaux de résolution.

### 3.4 Question de clôture de cycle
- A. Résolution simple.
- B. Résolution + feedback détaillé.
- C. Résolution + projection du prochain cycle.

---

## 4. Temps, météo et calendrier

### 4.1 Structure temporelle
La journée doit rester l’unité de base la plus naturelle, avec une logique de tâches et de résolutions compatible navigateur.

### 4.2 Résolution du temps
- A. Ticks quotidiens.
- B. Temps continu.
- C. Modèle hybride avec queue de tâches.

### 4.3 Météo
La météo doit influencer :
- les tâches possibles ;
- les rendements ;
- le calendrier ;
- certaines décisions logistiques.

### 4.4 Granularité météo
- A. Départementale.
- B. Régionale avec modificateurs locaux.
- C. Bassin local précis.

### 4.5 Visibilité météo
- A. Prévision courte.
- B. Prévision moyenne avec incertitude.
- C. Prévision longue simplifiée.

### 4.6 Rôle des saisons
- A. Décoratif.
- B. Structurel.
- C. Structurel + économique + logistique.

### 4.7 Recommandation V1 — Météo
- Granularité retenue pour la V1 : **B. Régionale avec modificateurs locaux**.
- Prévision retenue pour la V1 : **B. Prévision moyenne avec incertitude**.
- Justification :
  - la météo doit différencier les grandes zones sans nécessiter un modèle hyper local complexe ;
  - les joueurs doivent pouvoir planifier sur quelques jours avec une marge d’erreur, ce qui renforce la valeur de la planification sans la détruire ;
  - les modificateurs locaux (effets de bassin, altitude, proximité littorale) peuvent enrichir l’expert plus tard.
- Conséquences design :
  - les écrans de météo montrent une vue régionale, avec des nuances locales plutôt en mode expert ;
  - les fenêtres météorologiques sont assez fiables sur le très court terme, plus incertaines au-delà ;
  - les risques météo majeurs doivent être anticipables (indices, alertes, historiques).

---

## 5. Ressources principales

### 5.1 Ressources de pilotage
- Argent.
- Capacité de travail.
- Capacité machine.
- Stockage.
- Logistique.

### 5.2 Argent
Usage : acheter, vendre, investir, payer les charges, absorber les aléas.

### 5.3 Capacité de travail
- Reset chaque jour.
- Représente les heures disponibles.
- Structure les arbitrages quotidiens.

### 5.4 Capacité machine
La capacité machine est liée au matériel possédé.

### 5.5 Question de base
- A. Argent + travail + machine.
- B. Argent + travail + machine + stockage.
- C. Argent + travail + machine + stockage + logistique.

### 5.6 Stocks et logistique
Ils servent à différer la vente, absorber les pics de production et donner du poids au territoire.

---

## 6. Travail et main-d’œuvre

### 6.1 Représentation du travail
- A. Heures de travail quotidiennes.
- B. Unités de travail.
- C. Heures visibles + unités internes.

### 6.2 Types de main-d’œuvre
- A. Familiale + salariée.
- B. Familiale + salariée + saisonnière.
- C. Familiale + salariée + saisonnière + prestataire.

### 6.3 Fatigue
- A. Absente.
- B. Légère.
- C. Structurante en expert.

### 6.4 Embauche et délégation
Elles doivent soulager la charge mentale du joueur, pas la compliquer.

---

## 7. Matériel et capacité machine

### 7.1 Structure du matériel
Le matériel doit donner une capacité opérationnelle réelle.

### 7.2 Question de modélisation
- A. Par famille de machines.
- B. Par machine précise en normal, détail en expert.
- C. Double système normal / expert.

### 7.3 Usure
- A. Absente en V1.
- B. Simplifiée.
- C. Détaillée.

### 7.4 Location et sous-traitance
- A. Propriété seulement.
- B. Propriété + location.
- C. Propriété + location + sous-traitance.

---

## 8. Planification

### 8.1 File de tâches
*(Voir aussi section 74.1 pour le catalogue d’actions de planification.)*

Le cœur de l’ergonomie doit être une file de tâches claire.

### 8.2 Réservation prévisionnelle
Le jeu doit montrer immédiatement les ressources consommées en prévisionnel.

### 8.3 Faisabilité
- A. Vert / orange / rouge.
- B. Pourcentage + couleur.
- C. Couleur + texte explicatif.

### 8.4 Réorganisation
Le joueur doit pouvoir réordonner, suspendre, annuler, optimiser ou demander de l’aide.

### 8.5 Question de planification
- A. File simple.
- B. File avec réservation de ressources.
- C. File avec simulation complète.

---

## 9. Activités et filières

### 9.1 Socle V1
*(Voir aussi section 74.3 pour le catalogue d’actions exploitation/élevage/cultures.)*

- Grandes cultures.
- Élevage.
- Maraîchage.

### 9.2 Extensions naturelles
- Viticulture.
- Arboriculture.
- Foresterie.
- Horticulture.
- Aquaculture.
- Transformation.

### 9.3 Différenciation
Chaque activité doit avoir sa propre identité de rythme, de contraintes, de matériel, de risques et de débouchés.

### 9.4 Question V1 activités

### 9.5 Recommandation V1 — Activités
- Option retenue pour la V1 : **A. Grandes cultures + élevage + maraîchage**.
- Justification : ce trio couvre déjà trois rythmes de jeu différents (cycle long, cycle moyen, cycle court) sans multiplier excessivement les systèmes ni les assets. Il permet de représenter une bonne partie de la réalité agricole française tout en restant concentré.
- Conséquences design :
  - viticulture, arboriculture, foresterie, horticulture et aquaculture sont préparées dans le design mais livrées en V2+ ;
  - la plupart des exemples, tutoriels et workflows de base doivent pouvoir se dérouler dans ces trois activités ;
  - le territoire et l’économie doivent déjà proposer des variations pertinentes pour ces trois filières.
- À reporter dans agriva_decisions_log.md comme liste officielle des activités V1.

- Noter ici l’option choisie (A/B/C) pour la V1 et justifier en quelques lignes.
- Reporter la décision dans agriva_decisions_log.md.

- A. Grandes cultures + élevage + maraîchage.
- B. Grandes cultures + élevage + viticulture.
- C. Grandes cultures + élevage + maraîchage + arboriculture.

---

## 10. Sols et agronomie

### 10.1 Mode normal
*(Voir aussi section 74.4 pour le catalogue d’actions sol/foncier/territoire.)*

- A. Fertilité.
- B. Fertilité + humidité.
- C. Fertilité + humidité + fatigue culturale.

### 10.2 Mode expert
- A. NPK.
- B. NPK + matière organique.
- C. NPK + MO + pH + historique cultural.

### 10.3 Règle de design
Le mode normal montre les conséquences. Le mode expert montre les causes.

### 10.4 Rotations
- A. Bonus simples.
- B. Mécanique centrale.
- C. Mécanique centrale + expert détaillé.

### 10.5 Recommandation V1 — Sols
- Mode normal V1 : **B. Fertilité + humidité** comme indicateurs principaux visibles.
- Mode expert V1 : **C. NPK + MO + pH + historique cultural**, accessibles pour les joueurs qui veulent creuser l’agronomie.
- Justification :
  - deux indicateurs (fertilité + humidité) suffisent en normal pour que le joueur comprenne l’état de ses parcelles sans jargon ;
  - le mode expert doit pouvoir accueillir de vrais usages agronomiques pour les joueurs “métiers”, sans impacter la lisibilité pour les autres ;
  - les rotations doivent être centrales, mais leurs détails agronomiques restent surtout exposés en expert.
- Conséquences design :
  - en normal, les actions de gestion du sol (apports, couverts, jachère) affichent principalement l’effet sur ces deux barres ;
  - en expert, les écrans de parcelles doivent montrer des tableaux ou panneaux détaillés avec NPK, MO, pH, historique et effets attendus des pratiques ;
  - les outils d’aide à la décision agronomique doivent se brancher sur ces indicateurs experts sans surcharger le mode normal.

---

## 11. Foncier et parcelles

### 11.1 Représentation
*(Voir aussi section 74.4 pour le catalogue d’actions sol/foncier/territoire.)*

Les parcelles doivent rester abstraites et lisibles.

### 11.2 Fusion
La vraie fusion permanente est préférable au regroupement temporaire.

### 11.3 Question de parcelles
- A. Parcelles textuelles sans géométrie.
- B. Parcelles avec taille et type abstraits.
- C. Parcelles abstraites + contraintes territoriales.

### 11.4 Question de fusion
- A. Permanente et coûteuse.
- B. Permanente avec délai.
- C. Permanente + limites par bassin.

---

## 12. Territoire

### 12.1 Niveaux territoriaux
*(Voir aussi section 74.4 pour le catalogue d’actions sol/foncier/territoire.)*

- Département.
- Ville.
- Bassin local.
- Région.

### 12.2 Rôle du territoire
Le territoire doit influencer météo, économie, logistique, coûts, spécialisations et identité des joueurs.

### 12.3 Coopérative bot
Elle doit être départementale et située dans la préfecture / capitale du département.

### 12.4 Question de niveau territorial
- A. Département.
- B. Ville / bassin local.
- C. Double niveau département + localité.

---

## 13. Économie générale

### 13.1 Type d’économie
Le jeu doit utiliser une économie hybride : bot + joueur.

### 13.2 Rôle du bot
Le bot garantit la jouabilité, la liquidité et le démarrage.

### 13.3 Rôle du joueur
Le marché joueur doit rester plus intéressant, plus stratégique et plus vivant.

### 13.4 Anti-arbitrage
Le bot ne doit pas devenir une machine à profit.

### 13.5 Question d’économie

### 13.6 Recommandation V1 — Économie
- Option retenue pour la V1 : **B. Joueur dominant avec bot de secours**.
- Justification : le marché joueur doit être le principal lieu de création de valeur et de stratégie, tandis que le bot sert de filet de sécurité pour garantir la liquidité et éviter les situations de blocage économiques.
- Rôle du bot : **C. Bot = filet de sécurité**, garantissant des prix bornés, une possibilité de vendre/acheter en dernier recours et l’amortissement des erreurs, sans jamais être plus rentable que le marché joueur.
- Conséquences design :
  - tous les flux critiques doivent être faisables via marché joueur ;
  - les prix bot sont toujours moins intéressants que les meilleurs prix joueurs, à volume comparable ;
  - les boucles de jeu les plus rentables doivent impliquer d’autres joueurs, pas le bot ;
  - les systèmes d’anti-arbitrage (spread, décotes, rendements décroissants) sont obligatoires côté bot.
- À reporter et maintenir dans agriva_decisions_log.md comme décision structurante de l’économie.

- Préciser ici le type d’économie retenu pour la V1 (A/B/C) et le rôle exact du bot.
- Reporter la décision dans agriva_decisions_log.md.

- A. Hybride joueur + bot.
- B. Joueur dominant avec bot de secours.
- C. Bot dominant au départ puis progressivement secondaire.

### 13.6 Rôle du bot
- A. Liquidité.
- B. Amortisseur.
- C. Filet de sécurité.

---

## 14. Coopératives bot

### 14.1 Structure
Chaque département possède une coopérative bot centrale.

### 14.2 Rôle
Acheter, vendre, sécuriser les flux, amortir les déséquilibres.

### 14.3 Limites
Le joueur ne doit pas pouvoir construire durablement son exploitation sur le bot.

### 14.4 Question de localisation
- A. Préfecture / capitale départementale.
- B. Pôle logistique local.
- C. Préfecture en V1 + autres nœuds plus tard.

---

## 15. Marché joueur

### 15.1 Portée
*(Voir aussi section 74.2 pour le catalogue d’actions de marché bot/joueur.)*

Le marché joueur doit être national.

### 15.2 Filtres
Type, quantité, prix, qualité, origine, disponibilité, vendeur joueur / coopérative.

### 15.3 Logistique
Le marché national doit être compensé par coûts, délais et choix de livraison / retrait.

### 15.4 Question de structure
- A. Petites annonces.
- B. Ordres d’achat / vente.
- C. Système hybride.

---

## 16. Animaux

### 16.1 Achat au bot
Le bot doit permettre l’achat d’animaux de base pour lancer une activité.

### 16.2 Limites
Le bot ne doit pas permettre de bâtir de manière optimale de grandes exploitations d’élevage.

### 16.3 Mécanique recommandée
- quota par période ;
- qualité plafonnée ;
- prix croissant par tranche ;
- reproduction plus importante à long terme.

### 16.4 Question de rôle du bot
- A. Lancer l’atelier.
- B. Lancer + dépanner.
- C. Lancer + dépanner + fournir une base, pas la croissance.

---

## 17. Prix et anti-exploit

### 17.1 Spread permanent
Acheter et revendre au bot ne doit jamais être rentable.

### 17.2 Diminution de rentabilité
Les ventes massives au bot doivent devenir moins rentables.

### 17.3 Règle fondatrice
Le bot sécurise la liquidité, pas la rentabilité.

### 17.4 Question anti-arbitrage
- A. Spread simple.
- B. Spread + décote rapide.
- C. Spread + tag d’origine + rendements décroissants.

---

## 18. Stockage et logistique

### 18.1 Stockage
Permettre d’attendre le bon prix, lisser les pics et différer la vente.

### 18.2 Logistique
Peut rester abstraite en V1, puis devenir plus structurante plus tard.

### 18.3 Dépendance au territoire
Les coûts et délais logistiques doivent renforcer le territoire.

---

## 19. Transformation

### 19.1 Place dans le jeu
- A. Hors V1.
- B. Limité en V1.
- C. Axe majeur plus tard.

### 19.2 Recommandation V1 — Transformation
- Option retenue pour la V1 : **B. Quelques chaînes simples en V1**.
- Justification :
  - la transformation est un élément important de la réalité agricole, mais elle peut rapidement devenir un jeu dans le jeu ;
  - quelques chaînes simples (ex : lait → fromage standard, céréales → farine ou aliment, fruits → jus) suffisent à introduire la notion de valeur ajoutée ;
  - les filières de transformation complexes (qualités, affinage, labels très spécifiques) peuvent attendre V2+.
- Conséquences design :
  - la transformation V1 doit rester lisible dans l’UI et associée à des bâtiments ou services facilement identifiables ;
  - elle doit être rentable mais pas au point d’éclipser complètement la vente de produits bruts ;
  - les futures extensions de transformation devront se brancher sur ce socle sans imposer de refonte.

### 19.2 Rôle
Elle doit créer de la valeur ajoutée et pas juste de la complexité.

---

## 20. UI / UX

### 20.1 Ligne directrice
*(Voir aussi sections 44 à 52 pour le détail des écrans et interactions, et 74.7 pour les actions UI/UX.)*

L’interface doit être claire, synthétique et progressive.

### 20.2 Gestion des détails
Le joueur doit voir les conséquences d’abord, puis les détails à la demande.

### 20.3 Alertes
Elles doivent être hiérarchisées et utiles.

### 20.4 Question de densité

### 20.5 Recommandation V1 — Densité UI
- Option retenue pour la V1 : **B. Synthétique avec détails sur demande**.
- Justification : le joueur doit voir en permanence quelques indicateurs clés (argent, travail, météo, file de tâches, alertes critiques), et pouvoir dérouler les détails (parcelles, lots, indicateurs agronomiques, historiques) uniquement quand il en a besoin.
- Conséquences design :
  - les écrans principaux doivent comporter peu de colonnes/éléments par défaut et proposer des volets ou panneaux secondaires pour le détail ;
  - le mode expert ajoute des colonnes et vues supplémentaires mais ne doit pas surcharger le mode normal ;
  - la conception des dashboards (section 48) doit partir d’une vue synthétique, puis empiler les informations par couches.
- Exemple : l’écran d’exploitation montre d’abord les ateliers avec 3–5 métriques clés, les détails de chaque parcelle ou lot étant disponibles via un clic ou un panneau latéral.

- Choisir ici la densité d’information cible en V1 (A/B/C).
- Définir un exemple d’écran principal conforme à ce choix.

- A. Très synthétique.
- B. Synthétique avec détails sur demande.
- C. Personnalisable selon profil.

---

## 21. Normal / expert

### 21.1 Principe
Le mode normal montre les conséquences. Le mode expert montre les causes.

### 21.2 Modulation
Le mode expert doit être activable par système :
- sols ;
- élevage ;
- économie ;
- matériel ;
- logistique ;
- commercialisation.

### 21.3 Cohérence
Il doit rester un seul cœur de simulation, avec plusieurs niveaux de lecture.

### 21.4 Question d’organisation
- A. Global.
- B. Par système.
- C. Global + par système + par activité.

### 21.5 Recommandation V1 — Normal / Expert
- Option retenue pour la V1 : **B. Par système**, avec un commutateur global “Profil normal/expert” comme simple preset.
- Justification :
  - le cœur de simulation reste unique ;
  - chaque système (sols, économie, élevage, matériel, logistique, marchés) peut activer sa couche expert indépendamment ;
  - le profil global permet d’activer rapidement plusieurs systèmes experts pour les joueurs avancés, sans imposer cette complexité aux autres.
- Conséquences design :
  - la plupart des écrans doivent avoir un “niveau de détail” basculable par système ;
  - le mode expert ne doit jamais révéler des informations contradictoires avec le mode normal, seulement plus détaillées ;
  - l’onboarding doit proposer l’activation de certains modules experts au moment où le joueur rencontre naturellement ces systèmes.

- A. Global.
- B. Par système.
- C. Global + par système + par activité.

---

## 22. Progression

### 22.1 Axes
- Agrandissement.
- Spécialisation.
- Diversification.
- Automatisation.
- Optimisation.
- Réputation / classement.

### 22.2 But
La progression doit augmenter les décisions intéressantes, pas seulement les clics.

### 22.3 Question de progression

### 22.4 Recommandation V1 — Progression
- Option retenue pour la V1 : **C. Agrandissement + spécialisation + diversification**, avec une mise en avant progressive.
- Justification :
  - l’agrandissement (foncier, superficie, taille de troupeau) est le vecteur le plus intuitif ;
  - la spécialisation (choisir une ou deux filières maîtresses) donne une identité claire à l’exploitation ;
  - la diversification (deuxième activité, atelier complémentaire) permet de gérer le risque et de varier le gameplay sans exploser la complexité.
- Chemin type V1 sur 1–3 ans in-game :
  1. Année 1 : prise en main, activité principale (grandes cultures ou élevage), premiers investissements matériels ;
  2. Années 2–3 : agrandissement modéré + début de spécialisation (ex : grandes cultures + un atelier animal) ;
  3. À partir de là : diversification maîtrisée (ex : ajout d’un peu de maraîchage ou d’un atelier complémentaire) et montée en gamme (qualité, réputation).
- Conséquences design :
  - les systèmes avancés (transformation, filialisation très poussée, multi-sites complexes) sont réservés à V2+ ;
  - la progression doit rester lisible dans les dashboards (surface, production, revenus, risque, spécialisation).

- Indiquer ici la combinaison de progression retenue pour la V1 (agrandissement, spécialisation, diversification).
- Identifier un chemin type de progression sur 1 à 3 ans in-game.

- A. Agrandissement.
- B. Spécialisation.
- C. Agrandissement + spécialisation + diversification.

---

## 23. Objectifs et classements

### 23.1 Classements
Peuvent être segmentés par mode, activité, saison, région et profil de jeu.

### 23.2 Objectifs
Peuvent être personnels, saisonniers, de ligue, de maîtrise ou d’expertise.

### 23.3 Question de segmentation
- A. Par mode.
- B. Par mode + activité.
- C. Par mode + activité + saison + région.

---

## 24. Risques

### 24.1 Types de risques
- météo ;
- maladie ;
- panne ;
- dette ;
- prix ;
- logistique ;
- disponibilité du travail.

### 24.2 Lisibilité
Les risques doivent être annoncés avant d’être punis.

### 24.3 Question d’intensité
- A. Faibles.
- B. Présents mais lisibles.
- C. Structurants.

### 24.4 Recommandation V1 — Risques
- Option retenue pour la V1 : **B. Présents mais lisibles**.
- Justification :
  - il faut qu’il y ait de vrais risques (météo, prix, pannes, maladies, etc.) pour que les décisions aient du poids ;
  - mais ils doivent rester anticipables et compréhensibles, avec des signaux avant-coureurs et des moyens d’atténuation ;
  - les risques véritablement “structurants” (crises majeures, événements rares violents) pourront être introduits plus tard.
- Conséquences design :
  - la plupart des risques doivent être annoncés via les alertes et les dashboards (tension météo, tension de trésorerie, tension logistique) ;
  - les solutions (assurance, diversification, stockage, contrats) doivent être vraisemblables et accessibles ;
  - les punitions surprises et arbitraires doivent être évitées en V1.

---

## 25. Onboarding

### 25.1 Principe
Le joueur doit apprendre progressivement, sans être submergé.

### 25.2 Outils
- tutoriel court ;
- conseils contextuels ;
- objectifs guidés ;
- modules expert proposés plus tard.

### 25.3 Question d’apprentissage
- A. Tutoriel court.
- B. Missions progressives.
- C. Bac à sable assisté + conseils contextuels.

### 25.4 Recommandation V1 — Onboarding
- Option retenue pour la V1 : **B. Missions progressives** enrichies de **conseils contextuels légers**.
- Justification :
  - un tutoriel unique et lourd serait rapidement rejeté ;
  - des missions progressives permettent de découvrir les systèmes dans le bon ordre, à son rythme ;
  - les conseils contextuels (bulle d’aide, surlignage, mini-checklist) rappellent les actions possibles sans bloquer le joueur.
- Conséquences design :
  - l’onboarding doit être pensé comme une série de “premiers parcours” (première culture, premier atelier élevage, première vente, premier investissement) ;
  - les modules experts ne sont proposés qu’après que le joueur a manipulé le système concerné en mode normal ;
  - le joueur doit pouvoir désactiver facilement certains éléments d’aide lorsqu’il se sent à l’aise.

- A. Tutoriel court.
- B. Missions progressives.
- C. Bac à sable assisté + conseils contextuels.

---

## 26. Prestataires et services

### 26.1 Place dans le jeu
Les prestataires peuvent soulager la charge mentale et créer des décisions économiques.

### 26.2 Exemples
- travaux agricoles ;
- travaux forestiers ;
- transport ;
- insémination ;
- maintenance ;
- conseil.

### 26.3 Question de rôle
- A. Dépannage.
- B. Dépannage + spécialisation.
- C. Dépannage + spécialisation + réduction de charge mentale.

---

## 27. Événements et concours

### 27.1 Rôle
Créer des pics de motivation, des objectifs ponctuels et une vie saisonnière.

### 27.2 Formes possibles
- concours ;
- salons ;
- défis saisonniers ;
- récompenses thématiques.

### 27.3 Question de présence
- A. Pas en V1.
- B. Événements simples.
- C. Événements + concours + saisons.

---

## 28. Automatisation

### 28.1 Philosophie
Ce qui est répétitif doit pouvoir devenir batchable, délégable ou automatisable.

### 28.2 Limite
L’automatisation ne doit pas vider le gameplay, seulement éviter la fatigue inutile.

---

## 29. SimAgri : inspirations utiles

### 29.1 À reprendre
- diversité d’activités ;
- météo et territoire ;
- coopératives ;
- services et prestataires ;
- événements ;
- profondeur agricole.

### 29.2 À simplifier
- trop de micro-gestion ;
- trop de systèmes visibles à la fois ;
- trop de détails dès le départ ;
- surcharge quotidienne.

### 29.3 Leçon principale
Agriva doit filtrer la richesse du genre par le normal / expert, la progressivité et la lisibilité.

---

## 30. V1 / V2 / futur

### 30.1 V1
- socle d’activités limité ;
- économie hybride ;
- planning clair ;
- mode normal prioritaire.

### 30.2 V2
- expert étendu ;
- plus d’activités ;
- transformation ;
- services ;
- événements plus riches.

### 30.3 Futur
- spécialisation avancée ;
- réseaux plus riches ;
- profils de jeu plus divers ;
- systèmes experts plus poussés.

---

## 31. Résumé des décisions déjà prises

- Le jeu doit rester accessible et profond.
- Le mode normal est la base.
- Le mode expert est modulaire par système.
- La capacité de travail reset chaque jour.
- La capacité machine dépend du matériel.
- La planification consomme les ressources en prévisionnel.
- L’économie est hybride bot + joueur.
- La coopérative bot est départementale.
- Le marché joueur est national.
- Le bot garantit la liquidité, pas la rentabilité.
- Les achats / reventes bot ne doivent jamais créer de boucle profitable.
- Les animaux au bot servent au démarrage, pas à la croissance optimale.
- Les classements et objectifs peuvent être séparés par mode.
- Les activités futures doivent être pensées par familles.
- Toute mécanique doit renforcer la boucle principale.

---

## 32. Règle finale de design

**Agriva doit être simple à lire, profond à maîtriser, et détaillé seulement sur demande.**

Si une mécanique ne respecte pas cette règle, elle doit être simplifiée, repoussée ou supprimée.

---

## 33. Fichiers associés
- agriva_index.md
- agriva_gdd_master.md
- agriva_themes_checklist.md
- agriva_questions_options.md
- agriva_themes_questions_complete.md
- agriva_simagri_analysis.md
- agriva_decisions_log.md
- agriva_agents_brief.md


---

## 34. Services et prestataires

### 34.1 Quels services doivent exister en V1 ?
- A. Travaux agricoles uniquement.
- B. Travaux agricoles + transport.
- C. Travaux agricoles + transport + maintenance + conseil.

### 34.2 Qui fournit les services ?
- A. Le bot uniquement.
- B. Les joueurs uniquement.
- C. Un mix bot + joueurs selon le niveau de marché.

### 34.3 Quel rôle pour les prestataires ?
- A. Dépannage ponctuel.
- B. Réduction de charge mentale.
- C. Spécialisation stratégique et source de business.

### 34.4 Quels services sont experts ?

### 34.5 Recommandation V1 — Services et prestataires
- Services effectivement présents en V1 :
  - **ETA bot pour travaux de champs** (labour, semis, récolte, certains travaux spécifiques) ;
  - **services de transport simples** via la coop bot (prise en charge de livraisons/collectes standards) ;
  - éventuellement **quelques prestations élevage basiques** (ex : insémination standard) si la charge de design reste maîtrisée.
- Services explicitement repoussés à V2+ :
  - prestataires joueurs spécialisés ;
  - services de conseil avancé ;
  - services forestiers, viticoles, ou très spécialisés ;
  - services avec contrats complexes ou scénarisés.
- Présentation en mode normal :
  - mise en avant de quelques boutons clairs “Faire intervenir un prestataire” sur les tâches éligibles ;
  - information principale : coût, délai, effet sur la file de tâches ;
  - pas de détails techniques complexes.
- Présentation en mode expert :
  - détails sur les coûts décomposés, les impacts sur les ateliers, les limites de capacité des prestataires ;
  - visibilité accrue des prestataires disponibles par territoire et par période.
- Conséquences design :
  - les prestataires doivent être perçus comme un **levier pour soulager le joueur** plutôt que comme une optimisation obligatoire ;
  - l’économie doit rester équilibrée pour que le joueur puisse réussir sans recourir en permanence aux services.

- Lister les services effectivement présents en V1 (bot/joueurs) et ceux réservés aux versions ultérieures.
- Spécifier comment ils seront présentés en mode normal vs expert.

- A. Aucun.
- B. Les services logistiques.
- C. Les services techniques et de conseil avancé.

## 35. Événements et saisons

### 35.1 Quelle importance donner aux événements ?
- A. Cosmétique.
- B. Motivation secondaire.
- C. Mécanique structurante de rythme.

### 35.2 Quels types d’événements ?
- A. Saisons agricoles classiques.
- B. Concours et défis.
- C. Salons, enchères, festivals et compétitions.

### 35.3 Les événements ont-ils un impact économique ?
- A. Non.
- B. Oui, léger.
- C. Oui, significatif.

### 35.4 Les événements sont-ils ?
- A. Fixes.
- B. Systémiques.
- C. Systémiques + territoriaux.

## 36. Automatisation et délégation

### 36.1 Quelles tâches peuvent être automatisées ?
- A. Les tâches répétitives simples.
- B. Les tâches répétitives + réapprovisionnements.
- C. Les tâches répétitives + logistique + planning simple.

### 36.2 Quand débloquer l’automatisation ?
- A. Dès le départ.
- B. Par progression.
- C. Par progression + expertise.

### 36.3 Quelle limite à l’automatisation ?
- A. Forte limite.
- B. Limite moyenne.
- C. Limite faible mais contrôlée par coût.

### 36.4 L’automatisation agit sur ?
- A. Les tâches seulement.
- B. Les tâches + alertes.
- C. Les tâches + alertes + file de priorisation.

## 37. Réputation et progression sociale

### 37.1 La réputation existe-t-elle ?
- A. Non.
- B. Oui, locale.
- C. Oui, locale + nationale.

### 37.2 À quoi sert la réputation ?
- A. Cosmétique.
- B. Débloquer des objectifs.
- C. Débloquer marchés, contrats, services et classements.

### 37.3 La réputation est-elle ?
- A. Unique.
- B. Par filière.
- C. Par filière + territoire.

## 38. Concurrence et marchés

### 38.1 Le marché joueur doit-il être asymétrique ?
- A. Non.
- B. Oui, un peu.
- C. Oui, fortement selon les filières.

### 38.2 La concurrence se joue sur ?
- A. Le prix.
- B. Le prix + le temps.
- C. Le prix + le temps + la qualité + la réputation.

### 38.3 Peut-on créer des niches ?
- A. Non.
- B. Oui, partiellement.
- C. Oui, c’est un objectif central.

## 39. Données territoriales

### 39.1 Quel niveau de détail territorial ?
- A. Très abstrait.
- B. Département + indicateurs clés.
- C. Département + localité + tendances fines.

### 39.2 Quels indicateurs territoriaux ?
- A. Météo et population.
- B. Météo, prix, sols.
- C. Météo, prix, sols, logistique, densité d’activité.

### 39.3 Les différences territoriales sont-elles ?
- A. Faibles.
- B. Modérées.
- C. Forte identité de gameplay.

## 40. Objectifs long terme

### 40.1 Quelle structure d’objectifs ?
- A. Objectifs personnels simples.
- B. Objectifs personnels + saisonniers.
- C. Objectifs personnels + saisonniers + ligues + prestige.

### 40.2 La victoire existe-t-elle ?
- A. Non.
- B. Oui, partiellement.
- C. Oui, mais multiple selon le style de jeu.

### 40.3 L’échec existe-t-il ?
- A. Non, seulement ralentissement.
- B. Oui, faillite partielle.
- C. Oui, mais avec redressement et second souffle.

## 41. Déblocages et spécialisation

### 41.1 Comment débloquer du contenu ?
- A. Par niveau.
- B. Par progression économique.
- C. Par maîtrise de systèmes et territoire.

### 41.2 Les spécialisations sont-elles ?
- A. Linéaires.
- B. Branchées.
- C. Branchées + combinables.

### 41.3 La spécialisation donne ?
- A. Des bonus simples.
- B. Des accès à des marchés.
- C. Des accès + des outils + des contraintes.

## 42. Cadrage de complexité

### 42.1 Combien d’informations visibles par écran ?
- A. Très peu.
- B. Moyen.
- C. Personnalisable.

### 42.2 La complexité est-elle ?
- A. Cachée.
- B. Résumée.
- C. Optionnelle et progressive.

### 42.3 La règle ultime ?
- A. Simplicité.
- B. Lisibilité.
- C. Lisibilité + profondeur cachée.

## 43. Règle finale de travail pour l’équipe
Pour chaque thème, l’équipe doit fournir :
- une définition du système ;
- les questions A/B/C ;
- l’option recommandée ;
- les impacts de design ;
- les risques ;
- la place en V1/V2/futur ;
- la lecture normal/expert.


---

## 44. Interface, menus et écrans

### 44.1 Structure générale des menus
- A. Menu minimal (Accueil, Exploitation, Marché, Carte, Paramètres).
- B. Menu par grands blocs (Exploitation, Activités, Marchés, Territoire, Rapports, Paramètres).
- C. Menu plus fin avec sous-sections explicites par système.

### 44.2 Accès au mode normal / expert
- A. Commutateur global unique.
- B. Commutateur par écran / système.
- C. Commutateur global + réglages fins par système et activité.

### 44.3 Navigation principale
- A. Barre latérale fixe.
- B. Barre horizontale + sous-onglets.
- C. Tableau de bord d’accueil avec accès rapide aux blocs.

## 45. Écran principal d’exploitation

### 45.1 Informations visibles en permanence
- A. Argent, travail disponible, météo du jour, file de tâches.
- B. Argent, travail, météo, file de tâches, alertes critiques.
- C. Argent, travail, météo, file de tâches, alertes, indicateurs clés personnalisables.

### 45.2 Vue de l’exploitation
- A. Vue textuelle synthétique par ateliers et parcelles.
- B. Vue en liste avec filtres (par atelier, par parcelle, par filière).
- C. Vue tableau de bord combinant synthèse + accès rapide aux détails.

### 45.3 Actions principales accessibles
- A. Ajouter une tâche, consulter la météo, vendre/acheter.
- B. Ajouter tâche, réorganiser file, consulter météo, vendre/acheter, voir alertes.
- C. Ajouter tâche, gérer files, consulter météo, gérer marchés, appeler des prestataires, consulter rapports.

## 46. Écran de planification (file de tâches)

### 46.1 Représentation de la file
- A. Liste simple triée par jour.
- B. Liste par jour avec regroupement par atelier.
- C. Timeline ou vue de planning (type Gantt simplifié).

### 46.2 Indicateurs de faisabilité
- A. Icônes vert/orange/rouge.
- B. Couleur + pourcentage de faisabilité.
- C. Couleur + pourcentage + message explicite.

### 46.3 Actions sur la file
- A. Déplacer, supprimer.
- B. Déplacer, suspendre, supprimer.
- C. Déplacer, suspendre, supprimer, prioriser, dupliquer.

### 46.4 Lecture normal / expert
- A. Normal : vue synthétique, Expert : vue détaillée.
- B. Normal : peu de colonnes, Expert : colonnes supplémentaires.
- C. Normal : résumé par atelier, Expert : détail par tâche et ressource.

## 47. Écran marchés (bot + joueur)

### 47.1 Organisation de l’écran marché
- A. Onglet Bot / Onglet Joueur.
- B. Onglet Achat / Onglet Vente, avec filtre bot/joueur.
- C. Onglet Produits / Onglet Contrats / Onglet Historique.

### 47.2 Informations par ligne de marché
- A. Produit, prix, quantité.
- B. Produit, prix, quantité, origine, délai.
- C. Produit, prix, quantité, origine, délai, qualité, réputation vendeur.

### 47.3 Filtres
- A. Type de produit + prix.
- B. Type + prix + localisation + quantité minimale.
- C. Ensemble complet de filtres (type, filière, qualité, localisation, vendeur, délais).

### 47.4 Interaction normal / expert
- A. Normal : accès direct au bot, Expert : outils avancés pour le marché joueur.
- B. Normal : interface simplifiée, Expert : ajout d’outils d’analyse.
- C. Normal : presets de filtres, Expert : filtres sur mesure et sauvegardables.

## 48. Tableaux de bord et rapports

### 48.1 Types de tableaux de bord
- A. Unique “Exploitation”.
- B. Exploitation + Économie.
- C. Exploitation + Économie + Territoire + Performance.

### 48.2 Fréquence d’usage prévue
- A. Hebdomadaire.
- B. Quotidienne.
- C. Dès que le joueur prend une décision majeure.

### 48.3 Niveau de détail
- A. Résumés simples.
- B. Résumés + quelques graphiques.
- C. Résumés + graphiques + détails exportables.

### 48.4 Normal / expert
- A. Normal : un tableau de bord basique, Expert : plusieurs.
- B. Normal : métriques limitées, Expert : plus de métriques.
- C. Normal : focus sur la santé de l’exploitation, Expert : analyse de performance fine.

## 49. Alertes et notifications

### 49.1 Rôle des alertes
- A. Signaler uniquement les blocages.
- B. Signaler blocages + risques proches.
- C. Signaler blocages, risques, opportunités.

### 49.2 Canal d’affichage
- A. Bandeau en haut.
- B. Icône de notifications + pop-ups rares.
- C. Centre de notifications avec filtres.

### 49.3 Priorisation
- A. Pas de priorisation.
- B. Couleurs par priorité.
- C. Couleurs + catégories (urgent, important, info).

### 49.4 Normal / expert
- A. Normal : peu d’alertes, Expert : plus d’alertes.
- B. Normal : alertes critiques seulement, Expert : alertes détaillées.
- C. Paramètres permettant au joueur de régler sa sensibilité.

## 50. Workflows quotidiens type

### 50.1 Workflow “jour normal”
- A. Ecran principal -> météo -> file -> marché.
- B. Ecran principal -> météo -> file -> marché -> rapports rapides.
- C. Ecran principal -> météo -> file -> marchés -> prestataires -> rapports.

### 50.2 Workflow “crise” (météo, prix, panne)
- A. Alerte -> file -> marché.
- B. Alerte -> diagnostic simple -> file -> marché.
- C. Alerte -> diagnostic détaillé -> recommandation -> file -> marché.

### 50.3 Workflow “investissement”
- A. Rapports -> marché -> décision.
- B. Rapports -> territoire -> marché -> décision.
- C. Rapports -> territoire -> scénarios -> marché -> décision.

## 51. Personnalisation et accessibilité

### 51.1 Personnalisation de l’interface
- A. Thème clair/sombre seulement.
- B. Thème + densité d’informations (compact / standard).
- C. Thème + densité + choix des widgets de tableau de bord.

### 51.2 Accessibilité
- A. Police et contrastes standard.
- B. Options de taille de police et contrastes renforcés.
- C. Options complètes (taille, contrastes, animations, couleurs daltonisme-friendly).

### 51.3 Mode “basse charge mentale”
- A. Inexistant.
- B. Quelques simplifications.
- C. Mode dédié qui réduit les alertes et l’information à l’essentiel.

---

## 52. Synthèse UI/UX pour l’équipe

Pour chaque écran ou flux clé (exploitation, planification, marchés, territoires, rapports) :
- définir les informations visibles en mode normal ;
- définir les informations supplémentaires en mode expert ;
- choisir A/B/C pour la structure de navigation ;
- choisir A/B/C pour la densité d’informations ;
- expliciter comment l’interface aide la décision plutôt que le clic.

L’objectif est de faire de l’UI/UX un **outil de décision agricole** et non un simple affichage de données.


---

## 53. Direction artistique et identité visuelle

### 53.1 Style visuel global
- A. Sobre et fonctionnel (orientation simulation/gestion).
- B. Semi-stylisé, chaleureux, accessible.
- C. Fortement stylisé, identité visuelle marquée.

### 53.2 Niveau de réalisme graphique
- A. Très abstrait (icônes, cartes, dashboards).
- B. Stylisé crédible (pictos + quelques visuels de contexte).
- C. Réalisme poussé (illustrations détaillées, visuels riches).

### 53.3 Rôle de l’art dans le gameplay
- A. Pure lisibilité (signaux clairs, peu de décoration).
- B. Lisibilité + immersion.
- C. Lisibilité + immersion + différenciation forte par territoire/filière.

### 53.4 Priorités art pour la V1
- A. UI propre et cohérente en priorité.
- B. UI + quelques illustrations clés (ferme, territoire, saisons).
- C. UI + illustrations + identité forte par région.

## 54. Son, musique et feedback audio

### 54.1 Présence du son en V1
- A. Très limitée (feedbacks clés uniquement).
- B. Ambiances légères et feedbacks principaux.
- C. Ambiances par saison/activité + feedbacks détaillés.

### 54.2 Rôle de la musique
- A. Optionnelle, volume faible, ambiance légère.
- B. Boucles musicales par saison / contexte.
- C. Musique plus présente avec thèmes par territoire ou progression.

### 54.3 Feedbacks audio critiques
- A. Aucun obligatoire.
- B. Alertes importantes (échec, blocage, événement critique).
- C. Alertes + validation d’actions clés (tâche planifiée, vente majeure, etc.).

### 54.4 Accessibilité audio
- A. On/Off global.
- B. Réglage musique / SFX séparés.
- C. Réglages fins + presets (silencieux, immersif, feedback minimal).

## 55. Narration, ton et univers

### 55.1 Niveau de narration
- A. Quasi-nulle, ton purement systémique.
- B. Légère narration contextuelle (territoire, événements, personnages secondaires).
- C. Narration plus développée avec arcs, personnages et fil conducteur.

### 55.2 Ton général
- A. Sérieux / professionnel.
- B. Sérieux mais chaleureux / bienveillant.
- C. Plus léger, avec touches d’humour.

### 55.3 Présence de personnages
- A. Pas de personnages identifiés.
- B. Quelques interlocuteurs (conseiller, coop, voisins).
- C. Réseau de personnages récurrents (coop, banque, voisins, concurrents).

### 55.4 Rôle de la narration dans le game design
- A. Purement cosmétique.
- B. Sert à contextualiser objectifs et événements.
- C. Sert aussi de support à certains systèmes (contrats, réputation, événements scénarisés).

## 56. Plateformes, technique et performances

### 56.1 Plateforme principale
- A. Navigateur desktop.
- B. Navigateur + mobile responsive.
- C. Navigateur + appli mobile dédiée.

### 56.2 Contraintes de performance
- A. Cible machines modestes, priorité à la légèreté.
- B. Cible moyenne, quelques effets visuels possibles.
- C. Cible mixte, optimisation avancée nécessaire.

### 56.3 Fréquence des calculs lourds
- A. Résolutions batch (jour/nuit) uniquement.
- B. Résolutions batch + certains recalculs en temps quasi-réel.
- C. Modèle plus continu avec optimisation forte côté serveur.

### 56.4 Tolérance à la latence
- A. Le jeu tolère latence modérée (modèle très asynchrone).
- B. Latence modérée mais ressentie sur certains écrans.
- C. Forte exigence de réactivité (plus cher techniquement).

## 57. Données, analytics et équilibrage

### 57.1 Niveau de télémétrie
- A. Minimal : rétention, revenus, quelques métriques clés.
- B. Moyen : rétention, progression, points de friction, économie.
- C. Avancé : parcours détaillés, économie, comportements par profil.

### 57.2 Utilisation des données
- A. Suivi de santé globale.
- B. Ajustements réguliers d’équilibrage.
- C. Ajustements + expérimentation (tests A/B sur certains systèmes).

### 57.3 Outils d’équilibrage
- A. Tableurs simples.
- B. Tableurs + simulateurs dédiés.
- C. Tableurs + simulateurs + outils internes d’édition/balancing.

### 57.4 Rythme de retouche de l’économie
- A. Rare (patchs ponctuels).
- B. Régulier (par saison, par mise à jour majeure).
- C. Continu (petits ajustements fréquents).

## 58. Live Ops, mises à jour et contenu

### 58.1 Stratégie Live Ops
- A. Peu ou pas de Live Ops, mises à jour rares.
- B. Mises à jour régulières (contenu + équilibrage) mais limitées.
- C. Live Ops structurés (événements, saisons, contenus réguliers).

### 58.2 Types de mise à jour
- A. Corrections et équilibrage seulement.
- B. Corrections + nouvelles activités / produits.
- C. Corrections + nouveaux systèmes + événements Live.

### 58.3 Calendrier cible
- A. Aucune promesse publique.
- B. Rythme trimestriel.
- C. Rythme mensuel ou bimensuel sur certains contenus.

### 58.4 Risque de casser le jeu
- A. Changement minimal, priorité à la stabilité.
- B. Changements modérés, avec phases de tests.
- C. Changements plus fréquents, compensés par de bons outils et du monitoring.

## 59. Monétisation et modèle économique

### 59.1 Modèle principal
- A. Achat unique / licence.
- B. Abonnement / pass récurrent.
- C. Free-to-play avec options premium.

### 59.2 Rôle de la monétisation dans le game design
- A. Strictement séparée du cœur de gameplay.
- B. Influence des boucles secondaires (cosmétiques, confort).
- C. Impact plus direct sur certaines boucles (à cadrer avec prudence).

### 59.3 Ce qui ne doit jamais être monétisé
- A. Les performances de base.
- B. Les performances de base + accès à certaines filières.
- C. Les performances de base + accès + météo/territoire.

### 59.4 Monétisation compatible avec la fantasy agricole
- A. Cosmétiques (skins de ferme, interfaces, badges).
- B. Packs de confort (slots, templates de rotations, assistants visuels).
- C. Contenus thématiques (régions, cultures, événements spéciaux).

## 60. Modding, API et extensibilité

### 60.1 Place du modding
- A. Aucune pour l’instant.
- B. API de données en lecture seule pour outils externes.
- C. Système plus ouvert (scénarios, règles, contenus paramétrables).

### 60.2 Risque sur l’équilibrage
- A. On protège très fortement l’équilibre (pas de modding).
- B. On autorise des outils externes qui n’affectent pas le cœur économique.
- C. On prévoit plus tard une “sandbox” séparée pour les expériences.

### 60.3 Bénéfices attendus
- A. Limités pour le moment.
- B. Communauté d’outils et d’analyses.
- C. Communauté de créateurs de contenu / règles.

---

## 61. QA, tests et validation gameplay

### 61.1 Stratégie de test
- A. Tests internes ad hoc.
- B. Tests internes + petit groupe de bêta.
- C. Tests internes + bêta organisée + retours structurés.

### 61.2 Focales de test prioritaires
- A. Bugs bloquants.
- B. Bugs + friction UX.
- C. Bugs + friction UX + qualité des décisions proposées.

### 61.3 Rythme de test
- A. En fin de cycle uniquement.
- B. À chaque jalon majeur.
- C. En continu avec itérations courtes.

---

## 62. Documentation et transmission

### 62.1 Niveau de documentation attendu
- A. GDD principal uniquement.
- B. GDD + docs par système.
- C. GDD + docs par système + guides pour les nouveaux.

### 62.2 Mise à jour de la doc
- A. Rare.
- B. À chaque grande décision.
- C. Processus régulier couplé aux releases.

### 62.3 Public cible de la doc
- A. Équipe cœur seulement.
- B. Équipe + contributeurs externes.
- C. Équipe + contributeurs + futurs partenaires / moddeurs.

---

## 63. Guideline finale pour l’équipe

Pour **tout scope de game design** (systèmes, UI, art, son, économie, territoire, Live Ops, etc.) :

1. Formuler les objectifs du système.
2. Lister les questions clés.
3. Proposer 3 options cohérentes (A/B/C) par question.
4. Choisir l’option préférée pour V1.
5. Indiquer les variantes possibles pour V2 / futur.
6. Indiquer clairement la frontière Normal / Expert.
7. Vérifier que chaque choix respecte les piliers et la boucle principale.

Ce document doit devenir la référence centrale de toutes les décisions de design pour Agriva.


---

## 64. Comptes, identité et persistance

### 64.1 Gestion de compte
- A. Compte propre au jeu (email/mot de passe).
- B. Compte propre + connexions externes (Google, etc.).
- C. Compte propre + SSO + intégrations pro (utile pour écoles/organisations plus tard).

### 64.2 Sauvegarde et persistance
- A. Sauvegarde serveur unique.
- B. Sauvegarde serveur + reprise multi-appareils.
- C. Sauvegarde serveur + multi-appareils + backups/versioning (pour sécurité accrue).

### 64.3 Slots d’exploitations
- A. Une seule exploitation par compte.
- B. Quelques exploitations par compte.
- C. Exploitations multiples par compte + slots supplémentaires éventuels.

## 65. Social, communauté et interactions entre joueurs

### 65.1 Niveau d’interaction sociale
- A. Très faible (marché seulement).
- B. Moyen (marché + quelques interactions indirectes).
- C. Fort (coopérations, alliances, groupes, etc.).

### 65.2 Canaux de communication
- A. Aucun canal in-game (communication externe au jeu).
- B. Messagerie limitée (par exemple notes via marché ou coop).
- C. Systèmes de messages / salons dédiés avec modération.

### 65.3 Formes de coopération
- A. Coopération implicite via marchés uniquement.
- B. Coopération via contrats, entraide ponctuelle.
- C. Coopération structurée via groupes/coops de joueurs.

### 65.4 Gestion des conflits et toxicité
- A. Limiter au maximum l’interaction directe.
- B. Outils simples de signalement et blocage.
- C. Modération, filtres, outils avancés.

### 65.5 Recommandation V1 — Social et interactions
- Niveau d’interaction sociale : **B. Moyen** — marché + quelques interactions indirectes, mais pas de gros outils sociaux à la sortie.
- Canaux de communication : **B. Messagerie limitée** (par exemple notes associées aux annonces ou contacts coop), sans chat global.
- Gestion des conflits : **B. Outils simples de signalement et blocage**.
- Justification :
  - l’économie multi-joueur est centrale, mais les risques de toxicité et de charge de modération sont réels ;
  - en V1, il est plus prudent de se concentrer sur des interactions économiques et quelques messages ciblés ;
  - des outils sociaux plus riches (salons, groupes) pourront être ajoutés une fois les besoins et contraintes mieux maîtrisés.
- Conséquences design :
  - l’interface de marché doit permettre de communiquer juste ce qu’il faut (par ex. notes ou messages très encadrés) ;
  - il doit être facile de bloquer les interactions avec certains comptes ;
  - les mécaniques de coopération structurée (coops de joueurs) sont à réserver pour V2+.

## 66. Anti-triche, exploits et équité

### 66.1 Niveau de tolérance aux exploits
- A. Très faible, politique stricte.
- B. Moyenne, corrections rapides mais tolérance ponctuelle.
- C. Faible sur l’économie, plus souple sur le reste.

### 66.2 Mécanismes anti-triche
- A. Contrôles de base côté serveur.
- B. Contrôles avancés sur l’économie et les classements.
- C. Contrôles avancés + détection de patterns suspects.

### 66.3 Équité entre profils de joueurs
- A. Classements et objectifs séparés par mode.
- B. Séparation par mode + activité.
- C. Séparation par mode + activité + profil de jeu (casual, expert, compétitif).

## 67. Paramètres et options joueur

### 67.1 Paramètres de jeu
- A. Quelques paramètres (volume, confirmations, thèmes).
- B. Paramètres plus complets (interface, alertes, vitesse, etc.).
- C. Paramétrage avancé de tous les systèmes visibles.

### 67.2 Reset / respec
- A. Pas de reset complet.
- B. Reset limité de certains choix (spécialisation, etc.).
- C. Reset complet possible sous conditions (coût, délai, saison, etc.).

### 67.3 Sauvegarde locale de préférences d’interface
- A. Non (tout est serveur).
- B. Oui, quelques préférences.
- C. Oui, profil complet d’UI/UX sauvegardé.

## 68. Difficulté, courbes et profils

### 68.1 Modes de difficulté
- A. Pas de difficulté déclarée (difficulté implicite).
- B. Quelques presets (facile, standard, exigeant).
- C. Difficulté adaptative selon style et progrès.

### 68.2 Courbe d’entrée
- A. Entrée très douce, pic plus tard.
- B. Entrée moyenne, complexité régulière.
- C. Entrée plus raide, mais bien accompagnée.

### 68.3 Profils de joueurs
- A. Un modèle unique, tout le monde dans le même cadre.
- B. Quelques profils (casual, standard, expert).
- C. Segmentation plus fine, avec réglages liés.

### 68.4 Recommandation V1 — Difficulté
- Modes de difficulté déclarés : **B. Quelques presets (facile, standard, exigeant)**, mais sans modifier le cœur de simulation.
- Justification :
  - certains joueurs voudront une expérience plus relax, d’autres plus punitive ;
  - les presets peuvent agir sur la générosité des filets de sécurité (bot, aides, risques) sans introduire des règles économiques différentes ;
  - cela reste compatible avec l’idée d’un jeu systémique partagé.
- Conséquences design :
  - le mode “facile” renforce légèrement les amortisseurs (prix bot, risques, aides, crédits de départ) ;
  - le mode “exigeant” réduit certains filets de sécurité et augmente la sensibilité aux risques ;
  - les classements compétitifs doivent être basés sur un mode standard/exigeant, pas sur le mode facile.

## 69. Succès, trophées et méta-objectifs

### 69.1 Présence de succès
- A. Aucun au départ.
- B. Quelques succès principaux.
- C. Système complet de succès (progression, défis, collections).

### 69.2 Rôle des succès
- A. Purement cosmétiques.
- B. Cosmétiques + jalons de progression.
- C. Cosmétiques + jalons + déblocage de contenus secondaires.

### 69.3 Syncro externe (plateformes)
- A. Non prévue.
- B. Possible plus tard.
- C. Prévue pour certaines intégrations.

### 69.4 Recommandation V1 — Succès
- Présence de succès : **B. Quelques succès principaux**.
- Rôle : **B. Cosmétiques + jalons de progression** (et non leviers économiques).
- Justification :
  - les succès sont utiles pour guider le joueur et lui donner des objectifs secondaires ;
  - en V1, un petit ensemble de succès bien choisis (première récolte, première année positive, première diversification, etc.) suffit ;
  - ils ne doivent pas déstabiliser l’économie ni remplacer la progression propre au jeu.
- Conséquences design :
  - les succès doivent être affichés dans une interface simple, avec quelques paliers visibles ;
  - ils peuvent servir d’objectifs “soft” pendant l’onboarding et au-delà ;
  - les intégrations externes (plateformes) pourront être envisagées plus tard.

## 70. Sécurité, RGPD et données personnelles (cadrage design)

### 70.1 Principe de collecte
- A. Collecte minimale, uniquement ce qui est nécessaire au jeu.
- B. Collecte minimale + quelques données d’usage anonymisées.
- C. Collecte plus riche mais anonymisée/agrégée pour analyse.

### 70.2 Transparence pour le joueur
- A. Mentions légales simples.
- B. Mentions + page dédiée explicite.
- C. Mentions + page dédiée + dashboards de données personnelles.

### 70.3 Impact design
- A. Limiter les écrans liés aux données.
- B. Proposer quelques écrans clairs sur les données stockées.
- C. Intégrer des outils de contrôle des données dans l’interface.

## 71. Modes de jeu spécifiques (sandbox, scénarios, défis)

### 71.1 Modes disponibles
- A. Mode principal uniquement.
- B. Mode principal + mode sandbox.
- C. Mode principal + sandbox + scénarios / défis.

### 71.2 Rôle du sandbox
- A. Outil interne seulement.
- B. Outil joueur sans impact sur les classements.
- C. Outil joueur + vitrine pour expérimenter des systèmes.

### 71.3 Scénarios et défis
- A. Aucun.
- B. Quelques scénarios pédagogiques.
- C. Série de scénarios et défis progressifs.

### 71.4 Recommandation V1 — Modes de jeu
- Modes disponibles en V1 : **A. Mode principal uniquement**, avec éventuellement un “mode test” très limité pour l’équipe interne.
- Sandbox joueur : repoussé à V2+ (sauf éventuels outils internes).
- Scénarios/défis : **B. Quelques scénarios pédagogiques** à envisager seulement si l’onboarding standard ne suffit pas.
- Justification :
  - le cœur du projet est le mode principal persistant ;
  - multiplier les modes dès la V1 diluerait les efforts de design, de contenu et d’équilibrage ;
  - un sandbox joueur riche et une vraie série de scénarios peuvent venir plus tard, une fois les systèmes stabilisés.
- Conséquences design :
  - les écrans, systèmes et données doivent être conçus d’abord pour le mode principal ;
  - le sandbox futur devra pouvoir se brancher sur les mêmes briques techniques ;
  - les scénarios pédagogiques, s’ils sont ajoutés, doivent réutiliser les systèmes du mode principal, pas en inventer d’autres.

## 72. Compatibilité et intégrations externes

### 72.1 Intégrations agri/pro potentielles (futur)
- A. Aucune prévue.
- B. Intégration de quelques données publiques (météo, indices).
- C. Intégrations plus avancées (par ex. données agronomiques ouvertes) dans des modes spécifiques.

### 72.2 Intégrations sociales
- A. Aucune.
- B. Partage simple de captures / stats.
- C. Partage structuré (profils, exploits, classements publics).

---

## 73. Cadre “100 %” pour l’équipe

Pour tendre vers une couverture à **100 % des scopes de game design** pertinents pour Agriva, l’équipe doit vérifier que chaque bloc ci-dessous a été:
- défini (objectif, rôle) ;
- questionné (liste de questions) ;
- décliné en options A/B/C ;
- arbitré pour la V1 ;
- projeté pour V2 / futur ;
- aligné avec Normal / Expert ;
- confronté aux piliers et à la boucle principale.

Blocs à couvrir systématiquement :
- Vision, piliers, fantasy.
- Boucle de jeu, rythme, temps, météo.
- Ressources, travail, machines, stockage, logistique.
- Activités, sols, élevage, foncier, territoire, économie.
- Marché bot, marché joueur, prix, anti-exploit.
- Planification, UI/UX, dashboards, alertes, workflows.
- Services, prestataires, événements, saisons, automatisation.
- Progression, réputation, objectifs, classements, succès.
- Art, son, narration, ton de l’univers.
- Plateformes, performances, données, analytics, équilibrage.
- Live Ops, mises à jour, monétisation (si applicable).
- Modding, API, sandbox, scénarios.
- Comptes, identité, social, anti-triche, sécurité.
- Documentation, QA, transmission.

Une fois tous ces blocs passés au crible A/B/C et décidés pour V1, on peut considérer que le cadrage de game design d’Agriva est **réellement complet**.


---

## 74. Catalogue d’actions par système

Cette section sert à détailler, pour chaque grand système du jeu, les **familles d’actions** possibles : actions du joueur, actions automatiques du jeu, actions exceptionnelles. L’objectif est de ne rien oublier au niveau conceptuel, tout en laissant à la production la liberté d’ajuster les détails.

### 74.1 Planification et file de tâches

#### Actions du joueur
- Créer une tâche.
- Modifier les paramètres d’une tâche (date, durée, ressources, parcelles, atelier).
- Supprimer une tâche.
- Dupliquer une tâche.
- Déplacer une tâche dans le temps.
- Prioriser une tâche.
- Suspendre / reprendre une tâche.
- Accepter/refuser des suggestions d’optimisation.

#### Actions du jeu
- Vérifier la faisabilité (travail, machines, météo, logistique).
- Colorer la file (vert/orange/rouge).
- Réordonner automatiquement selon des règles (optionnel).
- Résoudre les tâches arrivées à échéance.
- Générer des alertes en cas de conflit ou impossibilité.

#### Niveau de granularité des actions de planification
- A. Actions minimales (créer, déplacer, supprimer).
- B. Actions complètes sur la file (créer, déplacer, suspendre, dupliquer, prioriser).
- C. Actions complètes + presets, modèles de tâches, suggestions automatiques.

---

### 74.2 Marché bot et marché joueur

#### Actions du joueur
- Consulter les offres bot.
- Consulter les offres joueurs.
- Filtrer les offres.
- Créer une offre de vente.
- Créer une offre d’achat.
- Accepter une offre.
- Annuler / modifier une offre.
- Négocier (si prévu) ou ajuster les prix.
- Choisir les modalités logistiques.

#### Actions du jeu
- Mettre à jour les prix bot.
- Appliquer les spreads achat/vente.
- Appliquer les rendements décroissants.
- Faire expirer les annonces.
- Appliquer les délais logistiques.
- Mettre à jour l’historique et les statistiques de marché.

#### Niveau de granularité des actions de marché
- A. Achat/vente simple (bot + joueur) avec filtrage basique.
- B. Achat/vente + annulation/modification d’annonces + filtres avancés.
- C. Achat/vente + ordres avancés + historiques + outils d’analyse (expert).

---

### 74.3 Exploitation, élevage et cultures

#### Actions du joueur (exploitation globale)
- Créer / renommer des ateliers.
- Activer / désactiver des activités.
- Affecter des parcelles / bâtiments à des ateliers.

#### Actions du joueur (élevage)
- Acheter des animaux (bot / joueurs).
- Vendre des animaux.
- Déclarer des entrées / sorties (naissance, mortalité, vente, achat).
- Modifier l’alimentation (choix de rations / plans alimentaires).
- Planifier reproduction / insémination.
- Affecter des lots à des bâtiments.
- Choisir de faire appel à un prestataire (vétérinaire, insémination, etc.).

#### Actions du joueur (cultures)
- Choisir les cultures par parcelle.
- Planifier les interventions (préparation, semis, traitements, récolte, irrigation si présente).
- Ajuster les intrants (dose, type).
- Moduler la stratégie (intensif, extensif, bio, etc.).

#### Actions du jeu
- Appliquer les effets des tâches (croissance, rendement).
- Mettre à jour les états sanitaires et nutritionnels.
- Calculer les rendements par parcelle / atelier.
- Appliquer les effets de la météo et du sol sur plantes et animaux.

#### Niveau de granularité des actions exploitation/élevage/cultures
- A. Actions à gros grains (choix de stratégies globales, peu de micro-gestion).
- B. Actions intermédiaires (quelques réglages par atelier / parcelle / lot).
- C. Actions fines (réglages détaillés, surtout en mode expert).

---

### 74.4 Sols, foncier et territoire

#### Actions du joueur
- Acheter / louer des parcelles.
- Fusionner des parcelles.
- Vendre / céder / transmettre des parcelles.
- Changer l’affectation d’une parcelle (atelier, type d’usage).
- Consulter les indicateurs de sol.
- Initier des actions de restauration (apports organiques, jachère, couvert, etc.).
- Choisir son territoire initial et éventuellement un second site plus tard.

#### Actions du jeu
- Mettre à jour les indicateurs de fertilité, humidité, fatigue.
- Appliquer les règles de rotation.
- Appliquer les effets du climat local.
- Gérer la disponibilité du foncier.

#### Niveau de granularité des actions sol/foncier/territoire
- A. Actions foncières simples (achat/vente, fusion basique).
- B. Actions foncières + interventions de restauration.
- C. Actions foncières + interventions fines de gestion de sols (expert).

---

### 74.5 Services, prestataires et événements

#### Actions du joueur
- Commander un prestataire (travaux de champs, transport, entretien, etc.).
- Annuler / replanifier un service.
- Participer à un événement (concours, salon, défi saisonnier).
- Inscrire des produits ou des animaux à un concours.
- Accepter / refuser un contrat proposé par un prestataire / organisme.

#### Actions du jeu
- Proposer des services selon le territoire et l’offre.
- Proposer / déclencher des événements saisonniers.
- Gérer les inscriptions aux événements.
- Attribuer récompenses / effets des événements.

#### Niveau de granularité des actions services/événements
- A. Services simples (ETA bot) + événements très limités.
- B. Services variés (bot + joueurs) + événements réguliers.
- C. Réseau riche de services + calendrier d’événements structuré.

---

### 74.6 Progression, objectifs, classements

#### Actions du joueur
- Consulter ses objectifs.
- Choisir certaines branches de progression / spécialisations.
- Consulter ses classements.
- S’inscrire à des ligues / saisons (si applicable).
- Dépenser des points de progression / prestige (si système prévu).

#### Actions du jeu
- Mettre à jour les objectifs (complétés / en cours / futurs).
- Mettre à jour les classements.
- Calculer la réputation.
- Débloquer contenus / options liés à la progression.

#### Niveau de granularité des actions de progression
- A. Progression implicite (peu de décisions explicites).
- B. Progression avec quelques choix de branches.
- C. Progression riche avec nombreuses branches et re-spécialisations possibles.

---

### 74.7 UI/UX et personnalisation

#### Actions du joueur
- Changer de thème visuel.
- Ajuster la densité d’informations.
- Configurer les alertes (volume, type).
- Personnaliser le tableau de bord (widgets visibles, ordre).
- Choisir les vues par défaut pour certains écrans.

#### Actions du jeu
- Mémoriser les préférences.
- Adapter l’affichage selon le mode normal / expert.
- Proposer ou rappeler des options de personnalisation.

#### Niveau de granularité des actions UI/UX
- A. Personnalisation minimale.
- B. Personnalisation moyenne (quelques options par écran).
- C. Personnalisation avancée (profil d’interface complet).

---

### 74.8 Métasystèmes (analytics, équilibrage, Live Ops)

#### Actions de l’équipe jeu (hors joueur, mais à prévoir dans le design)
- Ajuster des paramètres d’équilibrage.
- Lancer des événements Live.
- Modifier des tables de prix, rendements, coûts.
- Introduire de nouvelles activités / régions / produits.
- Mettre à jour les objectifs et défis.

#### Actions automatiques du système
- Collecter des données d’usage (anonymisées / agrégées).
- Générer des rapports internes.
- Surveiller déséquilibres (boucles dominantes, pénuries, etc.).

#### Niveau de granularité des actions Live Ops / équilibrage
- A. Ajustements rares et manuels.
- B. Ajustements réguliers planifiés.
- C. Ajustements fréquents appuyés sur data et outils internes.

---

## 75. Procédure “actions complètes” pour l’équipe

Pour considérer qu’un système est **100 % couvert** en termes d’actions :
- lister toutes les familles d’actions possibles du joueur pour ce système ;
- lister toutes les familles d’actions automatiques du jeu ;
- placer ces actions dans la boucle de jeu (quotidienne, saisonnière, annuelle) ;
- choisir A/B/C pour le niveau de granularité ;
- indiquer quelles actions restent visibles en normal, lesquelles sont réservées à l’expert ;
- vérifier que chaque action a une raison d’exister (décision, feedback, progression) ;
- supprimer ou fusionner toute action qui ne crée pas de vraie décision.

En appliquant cette procédure à tous les systèmes listés dans la section 73, le jeu dispose d’un **catalogue d’actions complet, cohérent et filtré par la philosophie d’Agriva**.
