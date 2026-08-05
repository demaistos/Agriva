# Agriva — Core Design
> Sections : 1-3, 21-22, 32, 73-75

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


---

## 32. Règle finale de design

**Agriva doit être simple à lire, profond à maîtriser, et détaillé seulement sur demande.**

Si une mécanique ne respecte pas cette règle, elle doit être simplifiée, repoussée ou supprimée.

---


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