# Agriva — Social & Meta
> Sections : 33, 37, 65-71

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


---

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


---

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
