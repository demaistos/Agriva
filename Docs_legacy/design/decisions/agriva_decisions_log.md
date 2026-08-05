# AGRIVA — Decisions Log

## Decided
- Normal mode is the default.
- Expert mode is modular per system.
- Daily labor resets every day.
- Machine capacity is based on equipment.
- Bot cooperative is departmental.
- Player market is national.
- Bot buy/sell spread exists.
- Bot should not be profitable via arbitrage.
- Bot can absorb volume but with diminishing returns.
- Animals can be bought from bot for startup, but not for optimal long-term growth.
- Planning reserves resources in advance.


### Économie V1
- Type d’économie : Option B — Joueur dominant avec bot de secours.
- Rôle du bot : Bot = filet de sécurité (liquidité, amortisseur, anti-blocage).
- Implication : le marché joueur est la voie principale pour optimiser prix, volumes et stratégies, le bot assure uniquement un plancher/plafond et absorbe les excès.

### Activités V1
- Option retenue : A — Grandes cultures + élevage + maraîchage.
- V2+ : viticulture, arboriculture, foresterie, horticulture, aquaculture, transformation.

### Densité UI V1
- Option retenue : B — Synthétique avec détails sur demande.
- Conséquence : les écrans principaux montrent peu de métriques par défaut, le détail est accessible via des panneaux secondaires ou le mode expert.

### Progression V1
- Option retenue : C — Agrandissement + spécialisation + diversification, introduites de façon progressive.
- Chemin type : année 1 = activité principale + prise en main, années 2–3 = agrandissement + début de spécialisation, ensuite = diversification maîtrisée.

### Services V1
- Option retenue : services bot de base (ETA, transport, éventuellement insémination standard) avec interface simple en mode normal.
- Services joueurs, services de conseil avancé et spécialisations de prestataires sont réservés à V2+.

### Normal / Expert V1
- Option retenue : B — Bascule par système, avec un profil global servant de preset.
- Implication : chaque système peut être joué en normal ou expert, le profil global permet d’activer plusieurs systèmes experts pour les joueurs avancés.

### Onboarding V1
- Option retenue : B — Missions progressives enrichies de conseils contextuels légers.
- Implication : pas de gros tutoriel bloquant, mais des premiers parcours structurés et des aides ponctuelles activables/désactivables.

### Objectifs et classements V1
- Option retenue : B — Segmentation par mode (Normal/Expert) et par grande activité.
- Implication : les joueurs sont comparés à des profils similaires, les récompenses restent majoritairement cosmétiques/symboliques.

### Risques V1
- Option retenue : B — Risques présents mais lisibles.
- Implication : météo, prix, pannes, etc. doivent influencer vraiment le jeu, mais avec signaux, leviers d’atténuation et peu de punitions arbitraires.

### Météo V1
- Granularité : B — Régionale avec modificateurs locaux.
- Prévision : B — Prévision moyenne avec incertitude.
- Implication : météo différenciée par grandes zones, planification possible sur quelques jours avec incertitude croissante.

### Sols V1
- Normal : B — Fertilité + humidité comme indicateurs visibles.
- Expert : C — NPK + MO + pH + historique cultural.
- Implication : agronomie lisible pour tous, détaillée pour les joueurs experts et les usages métiers.

### Stockage et logistique V1
- Importance du stockage : B — Contrainte moyenne et structurante.
- Logistique : B — Coût + délai (modèle plus riche plus tard).
- Implication : décisions de stockage et de débouchés ont du poids sans transformer la logistique en micro-gestion.

### Transformation V1
- Option retenue : B — Quelques chaînes simples en V1.
- Implication : introduction de la valeur ajoutée sans complexité excessive, développement futur via nouvelles filières.

### Difficulté V1
- Option retenue : B — Quelques presets (facile, standard, exigeant) qui modulent surtout la générosité des filets de sécurité, sans changer les règles de base.

### Succès V1
- Option retenue : B — Quelques succès principaux à rôle surtout cosmétique et de jalons de progression.

### Social V1
- Option retenue : B — Interactions sociales moyennes (marché + quelques messages limités), avec outils simples de signalement et blocage.

### Modes de jeu V1
- Option retenue : Mode principal uniquement en V1, sandbox joueur et série de scénarios repoussés à V2+.

### Pending résolus — 2026-05-07

#### Market price logic V1
- Option retenue : C — Spread bot + tag d'origine + rendements décroissants.
- Justification : le spread maintient le bot comme filet de sécurité sans arbitrage profitable (cohérent avec la décision Économie V1). Le tag d'origine crée une différenciation régionale qui valorise la logistique et la météo locale. Les rendements décroissants empêchent la domination d'un seul joueur sur un marché.

#### Event layer V1
- Option retenue : 35.1 B (motivation secondaire) + 35.2 B (concours et défis) + 35.3 B (impact léger) + 35.4 A (fixes).
- Justification : les événements sont une couche d'animation, pas le cœur du jeu — cohérent avec la boucle principale observer→investir→progresser. L'impact léger (35.3 B) respecte la règle "risques lisibles, peu de punitions arbitraires". Les récompenses cosmétiques/jalons s'alignent sur Succès V1 et Classements V1. Le calendrier fixe (35.4 A) garantit la prévisibilité nécessaire à la planification agricole.


#### Competitions V1
- Option retenue : B — Segmentation par mode (Normal/Expert) et par grande activité, classements saisonniers.
- Justification : cohérent avec la décision Objectifs et classements V1 déjà figée. Les compétitions sont des classements périodiques sur des métriques de performance (rendement, marge, diversification), récompenses cosmétiques uniquement. Pas de ligue structurée ni de saisons complexes en V1.

#### Service providers V1
- Option retenue : Bot uniquement — ETA bot (travaux de champs), transport coop bot, insémination standard bot.
- Justification : cohérent avec la décision Services V1 déjà figée. Interface simple en mode normal (bouton "Faire intervenir un prestataire" avec coût/délai/effet). Prestataires joueurs, conseils avancés et contrats complexes = V2+.

#### Exact activity list V1
- Option retenue : A — Grandes cultures + élevage + maraîchage.
- Détail grandes cultures : blé, orge, colza, maïs, tournesol, betterave (liste indicative, ajustable en production).
- Détail élevage : bovins lait, bovins viande, ovins, porcins (liste indicative).
- Détail maraîchage : légumes de plein champ à cycles courts/moyens.
- Justification : déjà figé dans Activités V1. Ce point précise la liste indicative sans la verrouiller définitivement — la production peut ajuster selon les assets disponibles.

#### Exact weather granularity V1
- Option retenue : B — Régionale avec modificateurs locaux, prévision J+7 avec incertitude croissante.
- Détail : 6 grandes régions climatiques françaises (Nord, Ouest, Sud-Ouest, Méditerranée, Est, Montagne). Modificateurs locaux : altitude, proximité littorale, effet de bassin (visibles en mode expert uniquement). Fiabilité prévision : J+1 = haute, J+3 = moyenne, J+7 = faible.
- Justification : déjà figé dans Météo V1. Ce point précise le nombre de régions et la courbe de fiabilité.

#### Exact soil model V1
- Option retenue : Normal = fertilité (0–100) + humidité (0–100). Expert = N + P + K (0–100 chacun) + MO (%) + pH (4–8) + historique cultural (dernières 3 cultures) + compaction (0–100).
- Dégradation passive : fertilité -1/saison sans apport, humidité variable selon météo. Rotations : bonus fertilité +5 à +15 selon séquence, malus fatigue culturale si même culture 2 ans consécutifs.
- Justification : déjà figé dans Sols V1. Ce point précise les plages de valeurs et les règles de dégradation/bonus.

#### Transformation depth V1
- Option retenue : 3 chaînes simples — lait → produit laitier standard, céréales → farine/aliment, légumes → conserve/jus.
- Règles : ratio de transformation fixe (ex. 1t lait → 0.1t fromage standard), valeur ajoutée +20–40% vs vente brute, nécessite un bâtiment de transformation (investissement), délai de traitement 1–3 jours.
- Justification : cohérent avec Transformation V1 déjà figée. Ce point précise les 3 chaînes retenues et les paramètres de base. Filières complexes (labels, affinage, qualités multiples) = V2+.

### Décisions issues du cadrage externe — 2026-05-07

#### Temporalité V1
- 1 mois de jeu = 5 jours réels.
- 1 saison = 3 mois = 15 jours réels.
- 1 année = 12 mois = 60 jours réels.
- Justification : compromis entre rétention (résultat visible toutes 48-72h), crédibilité saisonnière et économie de jeu. ~2x plus rapide que SimAgri (1 semaine réelle = 1 mois).

#### Saison compétitive
- 1 saison compétitive = 1 saison de jeu = 15 jours réels.
- Justification : aligne classements et cycles agricoles sur la même unité.

#### Durées de culture (mode Normal)
- Courte : 2 mois (10 jours réels).
- Moyenne : 3-4 mois (15-20 jours réels).
- Longue : 5-6 mois (25-30 jours réels).
- Blé : culture longue, ~5-6 mois.

#### Classements V1
- 8 classements : 2 modes (Normal/Expert) × 4 catégories (grandes cultures, élevage, maraîchage, mixte).
- Justification : la catégorie "mixte" est retenue pour les exploitations diversifiées.

#### Succès V1 — liste unique
- Liste de référence : economy-markets-v1.md §5 (20 succès).
- social-meta-v1.md doit être aligné sur cette liste.

#### Foncier V1
- Achat et location/fermage disponibles.
- Marché foncier local (département + zones limitrophes).
- Offre non permanente et dynamique.
- Regroupement de parcelles en blocs de gestion (sans fusion physique) disponible dès V1.
- Fusion physique de parcelles contiguës : possible avec coût, délai et conditions (même propriétaire, pas d'obstacle).

#### Carte de France
- Le jeu est ancré sur la carte de France.
- Le joueur choisit région → département → ville d'ancrage.
- 6-8 macro-régions agroclimatiques en V1.
- Le territoire influence : météo, calendrier cultural, cultures favorisées, élevages, spécialités locales, marchés.

#### Action economy
- Pas de jauge d'énergie abstraite.
- Limites = ressources métier : temps opérationnel, main-d'œuvre, matériel, intrants, trésorerie, logistique, météo.
- Les décisions sont immédiates ; les opérations prennent du temps.
- File d'ordres de travail : le joueur peut chaîner 3 actions compatibles sur une parcelle.
- Le joueur n'est jamais bloqué pour réfléchir, seulement pour exécuter.

#### Modes Normal/Expert — règle de productivité
- Normal : simulation assistée, stable, pédagogique. Productivité stable (fourchette resserrée).
- Expert : simulation complète, risquée, optimisable. Plafond de maîtrise plus élevé, variance plus forte.
- Pas de supériorité automatique de l'expert — avantage vient de la maîtrise, pas d'un multiplicateur.
- Choix verrouillé pour toute la saison.

#### Spread bot (précision)
- Spread minimum anti-arbitrage : 15-25% (pas 2-15% comme indiqué dans tech-liveops).
- tech-liveops-v1.md §3 doit être corrigé.

#### Échelle fertilité
- Référence unique : 0-100 (entier).
- farming-systems-v1.md doit être corrigé (float [0-1] → int [0-100]).
