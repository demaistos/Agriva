# INVENTAIRE EXHAUSTIF DES SYSTÈMES SimAgri

---

## 1. CORE (Temporalité, Carte, Joueur, PA)

### 1.1 Système d'Authentification
- **Sous-systèmes** : Inscription, Connexion (JWT), Sessions, Déconnexion
- **Mécaniques clés** : 1 compte/personne/serveur, email unique, bcrypt 12 rounds, JWT 7j, refresh token 30j
- **Dépendances** : Serveurs (choix à l'inscription)
- **Complexité** : Simple

### 1.2 Système de Serveurs de jeu
- **Sous-systèmes** : Configuration serveur, Difficulté, Races exclusives, Tailles parcelles
- **Mécaniques clés** : 8 serveurs (France×3, Belgique, Suisse, Canada, USA, Expert), multiplicateurs difficulté (revenue_multiplier, hours_multiplier, penalty_multiplier), config JSONB par serveur
- **Dépendances** : Joueurs, Économie (multiplicateurs prix), Élevage (races exclusives), Cultures (cultures exclusives)
- **Complexité** : Moyenne

### 1.3 Système Joueur (Exploitation)
- **Sous-systèmes** : Création exploitation, Profil, Budget, Heures de travail, Ancienneté, SimPass
- **Mécaniques clés** : Budget initial variable selon difficulté (50k-100k€), 8h/jour de travail, ancienneté en jours, épargne séparée
- **Dépendances** : Serveurs, Géographie, Banque, Employés
- **Complexité** : Moyenne

### 1.4 Système Géographique
- **Sous-systèmes** : Régions, Départements, Communes, Zones climatiques
- **Mécaniques clés** : 13 régions métropolitaines, 96 départements avec préfectures, 324 communes (préfectures + sous-préfectures), 5 zones climatiques réalistes, choix commune à l'inscription
- **Dépendances** : Météo (zones climatiques), Joueurs (localisation), Cultures (rendements régionaux), Marché (distance)
- **Complexité** : Moyenne

### 1.5 Système Temporel
- **Sous-systèmes** : Tick journalier, Calendrier SimAgri, Saisons, Années
- **Mécaniques clés** : 1 jour réel = 7 jours de jeu (time_ratio=7), 7j réels = 1 mois SimAgri, 21j réels = 1 saison, 84j réels = 1 année SimAgri, 4 saisons (Hiver/Printemps/Été/Automne), 12 mois SimAgri
- **Dépendances** : Tous les systèmes (ticks worker), Météo, Cultures, Élevage
- **Complexité** : Complexe

### 1.6 Système de Points d'Action (PA / Heures de travail)
- **Sous-systèmes** : Consommation PA, Régénération quotidienne, Multiplicateur difficulté, Déplacement par zone
- **Mécaniques clés** : 8h/jour (régénération à 00:00 UTC), 0.25 PA/zone traversée, hours_multiplier appliqué automatiquement, actions désactivées si PA insuffisants
- **Dépendances** : Serveurs (multiplicateur), Employés (heures supplémentaires), ETA (alternative), Matériel (consommation PA)
- **Complexité** : Moyenne

### 1.7 Système d'Employés
- **Sous-systèmes** : Embauche, Salaire, PA additionnels
- **Mécaniques clés** : 25 PA/jour par employé, salaire 1400€/mois SimAgri, heures ajoutées au hours_max du joueur
- **Dépendances** : Joueur (budget), Économie (charges mensuelles), PA
- **Complexité** : Simple

### 1.8 Système CFSA (Centre de Formation SimAgri)
- **Sous-systèmes** : Inscription stagiaire, Attribution maître-exploitant, Suivi formation, Bonus
- **Mécaniques clés** : Stagiaire dans les 14 premiers jours, Maître 168+ jours ancienneté, durée 42 jours, bonus +4j SimPass + 25000€ aide
- **Dépendances** : Joueur (ancienneté), SimPass, Social
- **Complexité** : Moyenne

### 1.9 Configuration Initiale (Onboarding)
- **Sous-systèmes** : Budget initial, Bâtiment de départ, Matériel de base, Prêt JA, Aide CESA
- **Mécaniques clés** : Budget selon difficulté, pas de délai construction pour 10 premiers bâtiments, prêt JA disponible (80k-150k€), aide CESA 50k€ post-formation
- **Dépendances** : Serveurs, Bâtiments, Matériel, Banque
- **Complexité** : Simple

### 1.10 Système de Difficulté Serveur
- **Sous-systèmes** : Multiplicateurs globaux (revenus, heures, pénalités, usure, énergie, quotas)
- **Mécaniques clés** : Facile (×0.7 heures, ×1.5 revenus), Normal (×1.0), Difficile (×1.3 heures, ×0.8 revenus), Expert (×1.5 heures, ×0.6 revenus). Appliqué à TOUT le jeu.
- **Dépendances** : Tous les systèmes
- **Complexité** : Moyenne

### 1.11 Système de Transport (global)
- **Sous-systèmes** : Attelage tracteur+remorque, Compatibilité CV, Types de remorques, Trajets multiples, Usure transport
- **Mécaniques clés** : 4 types remorques (benne/plateau/bétaillère/citerne), required_hp du tracteur, trips = ⌈quantité/capacité⌉, 1h + 0.5% usure par trajet, distance coopérative 20km fixe, équipement cassé inutilisable
- **Dépendances** : Matériel, Économie (coopérative), Élevage (animaux), PA
- **Complexité** : Complexe

### 1.12 Système d'Identifiants (Short IDs)
- **Sous-systèmes** : Séquence globale, Format préfixe-numéro, Nommage par défaut
- **Mécaniques clés** : Séquence `global_short_id_seq` partagée entre tous objets, format `POU-1009` (3 lettres slug + numéro), unicité cross-joueurs, nom par défaut = Type-ShortID
- **Dépendances** : Bâtiments, Matériel, Animaux, Parcelles
- **Complexité** : Simple

### 1.13 Règles UX Globales
- **Sous-systèmes** : Modales d'action, DataTable, Navigation, Barre d'actions sticky, Filtres
- **Mécaniques clés** : Affichage PA/solde avec validation, ConfirmModal avec variants, sélection multi + actions groupées, sub-nav onglets, décimales normalisées
- **Dépendances** : Tous les modules frontend
- **Complexité** : Moyenne

### 1.14 Protection hors-ligne
- **Sous-systèmes** : Détection absence, Gel des jauges
- **Mécaniques clés** : `players.last_seen` mis à jour à chaque requête, si absent > 48h réelles : jauges ne descendent pas sous 20%, mode vacances V2
- **Dépendances** : Élevage (jauges animaux), Joueur
- **Complexité** : Simple

---

## 2. MÉTÉO

### 2.1 Système Météo Principal
- **Sous-systèmes** : Génération météo, Prévisions 7 jours, Zones climatiques, Températures, Précipitations, Gel, Vent, Grêle
- **Mécaniques clés** : 5 niveaux météo (très ensoleillé→orage), 5 zones climatiques réalistes, températures min/max par zone×saison, ajustements par level, précipitations en mm, gel auto-détecté (temp_min < 0), vent (10-18%), grêle (2-4%)
- **Dépendances** : Géographie (zones climatiques), Cultures (jauges eau/soleil, blocage travaux), Élevage (stress thermique), Temporalité (tick horaire)
- **Complexité** : Complexe

### 2.2 Prévisions et Fiabilité
- **Sous-systèmes** : Prévisions fiables (J+0 à J+2), Prévisions incertaines (J+3 à J+6), Régénération
- **Mécaniques clés** : J+0-J+2 jamais écrasées, J+3-J+6 régénérées à chaque tick, probabilités par climat×saison, affichage opacité réduite pour incertaines
- **Dépendances** : Worker (tick horaire), Temporalité
- **Complexité** : Moyenne

### 2.3 Interface Météo
- **Sous-systèmes** : Widget dashboard 3 jours, Page /meteo, Carte de France SVG, Tableau 7 jours, Alertes météo
- **Mécaniques clés** : 13 régions colorées selon level, région joueur surlignée, alertes gel/grêle/canicule dans notifications, légende symboles
- **Dépendances** : Dashboard, Notifications, Géographie
- **Complexité** : Moyenne

### 2.4 Impact Gameplay Météo
- **Sous-systèmes** : Impact cultures (gel, canicule, pluie forte, grêle), Impact animaux (stress thermique, consommation accrue, rentrée auto), Impact actions (blocage travaux sol/semis/récolte/pulvérisation)
- **Mécaniques clés** : Gel = dégâts cultures + sol gelé (pas labour), Canicule (>35°C) = stress hydrique + baisse lait, Pluie forte (>20mm) = blocage travaux, Orage+grêle = dégâts cultures matures, Vent = pas de pulvérisation
- **Dépendances** : Cultures, Élevage, PA/Actions
- **Complexité** : Complexe

---

## 3. BÂTIMENTS

### 3.1 Catalogue Bâtiments
- **Sous-systèmes** : Bâtiments élevage (7 types), Stockage sec (7 types), Stockage spécialisé (4 types), Déchets organiques (3 types)
- **Mécaniques clés** : Prix/unité réalistes (150-700€/m²), énergie kWh/jour/unité, surface par animal selon mode élevage (conventionnel/label rouge/bio), 3 modes d'élevage avec impact surface/prix/durée
- **Dépendances** : Élevage (capacité animaux), Cultures (stockage récoltes), Économie (coûts), Énergie
- **Complexité** : Complexe

### 3.2 Système de Construction
- **Sous-systèmes** : Coût construction, Délai, Tailles min/max, Facteur niveau
- **Mécaniques clés** : coût = prix/unité × taille × facteur_niveau (1.0→4.0), instantané si < 10 bâtiments sinon ceil(taille/100) jours (max 7), 2h PA, tailles min 10-20 → max 1000-5000
- **Dépendances** : Joueur (budget, PA), Temporalité (délai), Worker (fin construction)
- **Complexité** : Moyenne

### 3.3 Système de Niveaux (1-5)
- **Sous-systèmes** : Upgrade, Coût par niveau, Bonus énergie/usure/capacité
- **Mécaniques clés** : Coût upgrade = 50%-400% coût initial, énergie ×0.6-×1.0, usure/jour ×0.4-×1.0, capacité ×1.0-×1.15, upgrade coûte 1h, usure < 80% requis
- **Dépendances** : Économie (coûts), PA, Usure
- **Complexité** : Moyenne

### 3.4 Système d'Usure & Entretien
- **Sous-systèmes** : Usure quotidienne, Paliers d'usure, Entretien mensuel/annuel, Pannes
- **Mécaniques clés** : 0.15%/jour × facteur_niveau × facteur_saison (hiver ×1.3), 4 paliers (0-30% normal, 30-60% +20% énergie, 60-80% +50% énergie + 2% panne/jour, 80-100% +100% énergie + 10% panne/jour, 100% inutilisable), entretien mensuel (2% valeur, -15pts usure, 0.5h), annuel (8% valeur, reset 5%, 2h)
- **Dépendances** : Worker (tick quotidien), Économie, PA, Temporalité (saisons)
- **Complexité** : Complexe

### 3.5 Système Énergétique
- **Sous-systèmes** : Consommation kWh, Facteurs (remplissage, usure, saison, niveau), Facturation
- **Mécaniques clés** : kwh_jour = base × taille × f_remplissage × f_usure × f_saison × f_niveau, 0.08€/kWh, débit chaque tick, si solde insuffisant usure ×1.5
- **Dépendances** : Économie (facturation), Worker (tick), Joueur (solde)
- **Complexité** : Moyenne

### 3.6 Système de Stockage
- **Sous-systèmes** : Compatibilité contenu, Pertes quotidiennes, Capacité, Déplacement stock
- **Mécaniques clés** : Chaque bâtiment a des contenus autorisés, silo = 1 seul type céréale, pertes (aire_stockage 0.5%/jour, silo_taupe 0.1%/jour), capacité = taille × facteur_niveau, qualité stockée (1-3), bio flag
- **Dépendances** : Cultures (récoltes), Élevage (aliments, fumier), Économie (valeur stock)
- **Complexité** : Complexe

### 3.7 Accessoires
- **Sous-systèmes** : Cuve lait, Cuve HVC, Salle de traite, Citernes/bacs eau, Corrals, Parcs (volailles/porcins/lapins), Pièces stockage (œufs/laine), Station conditionnement
- **Mécaniques clés** : Prix/unité variable, compatibilité par type bâtiment, installation dans un bâtiment spécifique
- **Dépendances** : Bâtiments, Élevage (production lait/œufs), Matériel (HVC)
- **Complexité** : Moyenne

### 3.8 Agrandissement & Destruction
- **Sous-systèmes** : Agrandissement (bâtiment vide requis), Destruction (récupération 10%)
- **Mécaniques clés** : Agrandissement = prix/unité × taille_ajoutée × facteur_niveau (2h), Destruction = bâtiment vide, récupère 10% coût initial (1h)
- **Dépendances** : Économie, PA, Stockage (vérification vide)
- **Complexité** : Simple

### 3.9 Modes d'Élevage (Conventionnel / Label Rouge / Bio)
- **Sous-systèmes** : Surface par mode, Prix vente par mode, Contraintes par mode
- **Mécaniques clés** : Conventionnel = base, Label Rouge = +30-60% surface + accès extérieur + prix ×1.3, Bio = +80-200% surface + pâturage + alimentation bio + prix ×1.6 + durée élevage +40%
- **Dépendances** : Élevage, Économie (prix vente), Parcelles (accès extérieur)
- **Complexité** : Complexe


---

## 4. CULTURES

### 4.1 Système de Parcelles
- **Sous-systèmes** : Types de parcelles (champ, pré, verger, prairie boisée), Achat/vente, Qualité sol (3 niveaux), Conversion BIO, Prix par pays
- **Mécaniques clés** : Taille en hectares (max selon serveur : 50-200 ha), qualité sol 1-3, conversion bio = 2 saisons, prix/ha par pays (3000-7000€)
- **Dépendances** : Géographie (département), Économie (achat/vente), Météo (zone), Sol
- **Complexité** : Moyenne

### 4.2 Système de Sol (Nutriments)
- **Sous-systèmes** : 6 éléments nutritifs (N, P, K, Ca, Mg, S), Pierres, Analyse de sol, Apports (engrais, fumier, lisier, compost, écume, digestat)
- **Mécaniques clés** : Jauges 0-100 pour chaque élément, analyse tous les 5 saisons (150€), pierres = -5% rendement (broyeur effet 3 saisons), apports nutriments par type d'amendement
- **Dépendances** : Cultures (rendement), Élevage (fumier/lisier), Transformations (digestat), Matériel (épandeur)
- **Complexité** : Complexe

### 4.3 Cultures Actives (Cycle cultural)
- **Sous-systèmes** : Semis, Croissance, Jauges eau/soleil, Traitements (fongicide/herbicide/insecticide), Fertilisation, Fumure, Rouleau, Maladies, Récolte, Paille
- **Mécaniques clés** : Croissance 4%/jour (0.17%/heure), multiplicateurs eau/soleil, 28+ cultures avec périodes semis/récolte spécifiques, qualité récolte 1-3, paille disponible après moisson
- **Dépendances** : Météo (jauges), Sol (rendement), Matériel (semoir, moissonneuse...), Bâtiments (stockage), PA, Temporalité
- **Complexité** : Très complexe

### 4.4 Calcul de Rendement
- **Sous-systèmes** : Rendement de base par région, Multiplicateurs (sol, qualité terre, engrais, fumier, traitements, météo, maturation, rouleau, pierres, bio, technique)
- **Mécaniques clés** : rendement = base × region × Π(multiplicateurs), facteurs : 0.5-1.3 (sol), 0.8-1.2 (qualité), ×1.15 (engrais), ×1.10 (fumier), ×0.7 (maladie non traitée), ×0.85 (bio), ×0.95 (TCS), ×0.85 (semis direct), ×1.04 (rouleau)
- **Dépendances** : Sol, Météo, Matériel, Parcelles, Saisons
- **Complexité** : Très complexe

### 4.5 Techniques Culturales
- **Sous-systèmes** : Traditionnelle, TCS (Techniques Culturales Simplifiées), Semis direct
- **Mécaniques clés** : Traditionnelle = bon rendement/coût élevé, TCS = rendement×0.95/coût modéré, Semis direct = rendement×0.85/coût faible (interdit maïs/PDT)
- **Dépendances** : Matériel (outils spécifiques), Rendement
- **Complexité** : Simple

### 4.6 Rotation des Cultures
- **Sous-systèmes** : Historique parcelle, Vérification rotation, Rotation BIO (+1 an)
- **Mécaniques clés** : Chaque culture a une rotation (1-6 ans), historique par saison, bio = rotation +1 an, vérification avant semis
- **Dépendances** : Temporalité, Parcelles, Base de données cultures
- **Complexité** : Moyenne

### 4.7 Système d'Irrigation
- **Sous-systèmes** : Sources d'eau (forage, retenue collinaire), Équipement (enrouleur, pivot central, rampe pivot), Activation
- **Mécaniques clés** : Forage 150€, niveau 1-10 (100K-1M litres/jour), retenue collinaire alimentée par rivière, apport eau proportionnel à surface
- **Dépendances** : Parcelles, Cultures (jauge eau), Météo, Économie
- **Complexité** : Moyenne

### 4.8 Cultures Arboricoles (Vergers)
- **Sous-systèmes** : 11 espèces fruitières, Plantation, Croissance (age_seasons), Taille, Récolte, Mortalité arbres, Filet anti-grêle, Calibre fruits
- **Mécaniques clés** : Max 5 ha/verger, arbres/ha variable (100-5000), rendement optimal à 1-8 ans selon espèce, récolte manuelle (sauf noyer), matériel spécifique (tracteur ≤80CV, vibreur hydraulique, ramasseuse), filet anti-grêle 1/ha
- **Dépendances** : Matériel (arboricole), Bâtiments (entrepôt arbo, chambre froide, palox), Météo (grêle), PA (main d'œuvre intensive)
- **Complexité** : Très complexe

### 4.9 Système de Haies
- **Sous-systèmes** : Plantation (Sep-Nov), Taille (Déc-Fév), Déchiquetage, Stockage plateforme bois, Mortalité (2%/saison)
- **Mécaniques clés** : Plants ~1.50€/unité (0.05h/plant), kit bûcheron pour taille (0.003h/arbre, 1-2kg bois/arbre), broyeur branches (0.2h/tonne), plateforme 4m³/tonne, bois déchiqueté = litière ou chauffage serre (2.8-3.5 KW/kg)
- **Dépendances** : Matériel (broyeur, chargeur), Cultures (bonus rendement), Élevage (réduction eau au pré), Serres (chauffage)
- **Complexité** : Moyenne

### 4.10 Filière Pomme de Terre
- **Sous-systèmes** : Ligne de stockage (100k€), Entrepôt PDT climatisé, Stockage palox, Propositions de vente hebdomadaires, Transport
- **Mécaniques clés** : Récolte → stockage dans 2 jours (sinon vente forcée sous 7j), stockage jusqu'au 7 juin saison suivante, propositions régionales/nationales/internationales (Déc-Juin), stock non écoulé au 7 juin = perdu
- **Dépendances** : Bâtiments (entrepôt PDT), Transport, Économie (cours PDT), Temporalité
- **Complexité** : Complexe

### 4.11 Céréale Immature (Ensilage)
- **Sous-systèmes** : Récolte précoce (60-80% pousse), Ensilage, Stockage silo taupe
- **Mécaniques clés** : Blé/orge/avoine/triticale/seigle, récolte avant 7 mai, outil ensileuse, rendement = 150% rendement grain, usage = méthanisation ou alimentation bovins/caprins/ovins
- **Dépendances** : Cultures actives, Matériel (ensileuse), Bâtiments (silo taupe), Élevage/Méthanisation
- **Complexité** : Moyenne

### 4.12 Compostage
- **Sous-systèmes** : Compostage en parcelle, Compostage à la ferme (aire), Retournements, Épandage
- **Mécaniques clés** : 3t fumier → 1t compost en 14 jours, 2 retournements obligatoires (retourneur d'andains), épandage 15T/ha (épandeur fumier), apports N=95 P=60 K=120 Ca=180 Mg=35 S=60
- **Dépendances** : Élevage (fumier), Bâtiments (aire compostage/fosse fumier), Matériel (retourneur, épandeur), Sol
- **Complexité** : Moyenne

### 4.13 Écume de Sucrerie
- **Sous-systèmes** : Achat (Coopérative/CAR), Épandage, Stockage
- **Mécaniques clés** : Amendement calcique, 15T/ha, 1×/5 ans, épandeur fumier, stockage fosse fumier, apports N=45 P=120 K=15 Ca=3600 Mg=90 S=0
- **Dépendances** : Sol (calcium), Matériel (épandeur), Bâtiments (fosse fumier), Économie
- **Complexité** : Simple

### 4.14 Digestat (Épandage)
- **Sous-systèmes** : Digestat liquide, Digestat solide, Épandage
- **Mécaniques clés** : Liquide 25m³/ha (N=125, P=50, K=300), Solide 25T/ha (N=100, P=50, K=225), issu de la méthanisation
- **Dépendances** : Méthanisation, Sol, Matériel (épandeur/tonne à lisier)
- **Complexité** : Simple

### 4.15 Quotas
- **Sous-systèmes** : Quota betterave, Quota tabac
- **Mécaniques clés** : Betterave = 2ha ou 10% surface cultivée année précédente, Tabac = 2ha max + région exploitation uniquement
- **Dépendances** : Parcelles (surface), Cultures, Géographie (région)
- **Complexité** : Simple

### 4.16 Engrais Verts / CIPAN
- **Sous-systèmes** : Moutarde, Phacélie, Seigle, Ray-grass Italie
- **Mécaniques clés** : Semés après récolte d'été, broyés en janvier, amélioration sol
- **Dépendances** : Rotation, Sol, Temporalité
- **Complexité** : Simple


---

## 5. ÉLEVAGE

### 5.1 Système d'Animaux (lots)
- **Sous-systèmes** : Catalogue races (animal_definitions), Lots (animal_lots), Short IDs, Stades de croissance (bébé/jeune/adulte), Poids, Sexe, Localisation
- **Mécaniques clés** : Gestion par lots (1 lot = N animaux même espèce/race/sexe), 7 espèces principales + pintades/oies/canards/bisons/daims, poids moyen par lot, stades avec feed_ratio et m2_ratio, 13+ races par espèce
- **Dépendances** : Bâtiments (capacité m²), Économie (achat/vente), PA, Transport
- **Complexité** : Très complexe

### 5.2 Canaux d'Achat
- **Sous-systèmes** : Grossiste (serveur→joueur), Marché global (joueur↔marché), Marché privé (joueur→joueur B2B)
- **Mécaniques clés** : Grossiste = prix fixe + génétique moyenne + quota mensuel (5 bovins→50 volailles/mois) + transport requis. Marché global = prix libre + commission 5% + annonce 7j + filtres. Marché privé = négocié + commission 2% + offre 3j. Âge minimum de vente par espèce.
- **Dépendances** : Transport (tracteur+bétaillère), Économie, Génétique (visible avant achat)
- **Complexité** : Complexe

### 5.3 Transport d'Animaux
- **Sous-systèmes** : Bétaillères (petite/moyenne/grande), Calcul trajets, Heures matériel, Destination (bâtiment/enclos), Conditions d'arrêt
- **Mécaniques clés** : Capacité en m² intérieur (12/25/45 m²), allers-retours = ceil(m²_total/capacité), 1h + 0.5h×zones par aller-retour, boucle auto jusqu'à : tous transportés / bâtiment plein / matériel HS / plus d'heures
- **Dépendances** : Matériel (tracteur+bétaillère), Bâtiments (capacité), PA, Serveur (multiplicateur)
- **Complexité** : Complexe

### 5.4 Enclos d'Attente
- **Sous-systèmes** : Stockage temporaire, Pénalités accélérées, Pas de production
- **Mécaniques clés** : 1 par joueur, capacité illimitée, pas de lait/œufs/laine, faim -20/jour (vs -10), santé -10/jour si faim<50 (vs -5), pénalités × difficulty_multiplier
- **Dépendances** : Worker (tick quotidien), Serveur (difficulté), Animaux
- **Complexité** : Moyenne

### 5.5 Système Alimentaire (Rations)
- **Sous-systèmes** : Rations par espèce/âge/localisation, Consommation auto (worker), Stock alimentation, Eau (bacs/citernes), Pénalités faim/soif/santé
- **Mécaniques clés** : Nourrissage automatique par worker tick, ration détaillée (kg/jour par aliment), eau L/jour, si stock manquant → faim -15/aliment, si pas d'eau → soif -20, remontée santé +2/jour si faim>70 ET soif>70, mort si santé=0
- **Dépendances** : Bâtiments (stockage aliments), Économie (achat rations), Worker, Cultures (foin, ensilage)
- **Complexité** : Complexe

### 5.6 Litière & Fumier/Lisier
- **Sous-systèmes** : Consommation paille (sur litière), Production fumier (paille×1.5), Production lisier (caillebotis), Stockage fosses
- **Mécaniques clés** : Besoin paille/jour par espèce/âge (30-90 kg/bovin), paille consommée → fumier (×1.5), caillebotis = lisier directement, si pas de paille → santé -3 (maladie)
- **Dépendances** : Bâtiments (fosse fumier/lisier), Cultures (paille), Sol (épandage fumier/lisier)
- **Complexité** : Moyenne

### 5.7 Reproduction
- **Sous-systèmes** : Monte naturelle (auto si mâle+femelles même bâtiment), Insémination artificielle (IA), Taux de réussite, Naissances
- **Mécaniques clés** : Monte naturelle = 0 PA, capacité/mâle/mois (3 bovins→10 volailles), taux 70-90% × santé. IA = dose 0.5-120€, taux 60-80% × santé, indices génétiques du donneur visibles. Gestation 21j (poule) à 340j (jument). Naissance = max 2 lots (1 mâle + 1 femelle).
- **Dépendances** : CIA (doses), Génétique, Temporalité, Worker (tick quotidien)
- **Complexité** : Complexe

### 5.8 Production Lait
- **Sous-systèmes** : Traite (action joueur), Salle de traite, Cuve à lait, Calcul production, Qualité lait (QL)
- **Mécaniques clés** : PA variable selon nb animaux et taille salle traite, production = avg_milk × qualityFactor(hunger) × geneticFactor, overflow perdu si cuve pleine, prix du lait indexé sur indice QL (265-480€/1000L bovin conv.)
- **Dépendances** : Bâtiments (salle traite, cuve lait), PA, Économie (prix lait), Génétique (QL)
- **Complexité** : Complexe

### 5.9 Production d'Œufs
- **Sous-systèmes** : Robot ramassage (accessoire poulailler), Salle de conditionnement (bâtiment), Calibres (S/M/L/XL selon âge), Stock œufs, Vente par calibre
- **Mécaniques clés** : Prérequis = poulailler + robot + salle conditionnement + poules âgées (120-150j min) + faim≥50. Production 0-1 œuf/jour/poule selon race. Calibre S(<240j)/M(240-400j)/L(400-600j)/XL(>600j). Robot couvre 500-1000 poules. Salle partagée entre tous poulaillers.
- **Dépendances** : Bâtiments (poulailler, salle conditionnement), Accessoires (robot), Économie (prix œufs), Worker
- **Complexité** : Complexe

### 5.10 Génétique (V2)
- **Sous-systèmes** : 14 indices génétiques (Croissance, Prolificité, Allure, Lait, QL, Laine, Oeuf, Eclosion, Résistance, Sociabilité, Fertilité, Duvet, Physique, Mental), Objectifs Génétiques (OG), Valorisation
- **Mécaniques clés** : Indices par animal/lot, croisement indices parents + aléatoire, valorisation vente (0.01-2€/point au-dessus moyenne serveur), concours basés sur indices
- **Dépendances** : Reproduction, CIA, Concours, Économie (prix vente)
- **Complexité** : Très complexe

### 5.11 Stades de Croissance
- **Sous-systèmes** : 3 stades par espèce (bébé/jeune/adulte), Feed ratio, M2 ratio
- **Mécaniques clés** : Durées en jours de jeu (bébé 0-30→180j selon espèce), feed_ratio bébé = 20-30% adulte, m2_ratio bébé = 10-30% adulte, display_name genré par stade (Poussin/Poulette/Poule/Coq)
- **Dépendances** : Alimentation (portions réduites), Bâtiments (surface réduite), Temporalité
- **Complexité** : Moyenne

### 5.12 Gestion des Lots
- **Sous-systèmes** : Regrouper (fusionner), Scinder, Déplacer, Vendre (abattoir), Actions groupées
- **Mécaniques clés** : Regrouper = même espèce/race/sexe/bâtiment + pas gestant → stats pondérées (0h). Scinder = sépare en X+(N-X) avec mêmes stats (0h). Vente = lot entier uniquement (scinder d'abord). Abattoir = poids×qty×prix/kg×revenue_multiplier, délai 1 mois après achat grossiste.
- **Dépendances** : Bâtiments, Économie, PA
- **Complexité** : Moyenne

### 5.13 Pâturage (Mise au pré)
- **Sous-systèmes** : Dates par espèce (Avril-Octobre), Surface m²/jour, Ration hivernale, Prairie boisée (bisons/daims)
- **Mécaniques clés** : Bovins laitiers Avril-Octobre, allaitants = hivernal possible, chevaux Mars-Novembre, bisons/daims toute l'année, surface 56-80 m²/jour par bovin, consommation herbe
- **Dépendances** : Parcelles (pré), Temporalité (saisons), Alimentation (ration complémentaire hiver), Météo (rentrée auto si vent)
- **Complexité** : Complexe

### 5.14 Labels d'Élevage
- **Sous-systèmes** : Conventionnel, Label Rouge, Bio, Plein-air
- **Mécaniques clés** : Bio = conversion 2 saisons, plein-air obligatoire (25-95% selon espèce), alimentation bio, tolérance nourriture conv. (2-12 jours), prix +20-60%, âge min/max par espèce. Label Rouge = accès extérieur, sans OGM, prix ×1.3
- **Dépendances** : Bâtiments (mode élevage), Parcelles (pré/parc), Alimentation, Économie (prix vente)
- **Complexité** : Complexe

### 5.15 Vaccinations
- **Sous-systèmes** : Catalogue vaccins, Application, Durée protection
- **Mécaniques clés** : Coût par animal, prévention maladies, durée variable, expiration
- **Dépendances** : Santé animale, Économie
- **Complexité** : Simple

### 5.16 IVRAD (Institut Virtuel des Races A Développer)
- **Sous-systèmes** : Objectifs Génétiques par race, Sélection reproducteurs, Accouplement raisonné, Abattoir IVRAD
- **Mécaniques clés** : Travail d'amélioration génétique, vente à prix valorisé selon indices
- **Dépendances** : Génétique, Reproduction, Économie
- **Complexité** : Complexe

### 5.17 Rendement Carcasse (Abattoir)
- **Sous-systèmes** : Rendement par espèce (45-80%), Qualité viande (conformation A-E + engraissement 1-5)
- **Mécaniques clés** : Bovins laitiers 50-55%, allaitants 55-75%, porcins 72-80%, volailles 60-65%, ovins/caprins 45-50%
- **Dépendances** : Économie (prix vente carcasse), Élevage (poids)
- **Complexité** : Moyenne

### 5.18 CIA — Doses et Prélèvements
- **Sous-systèmes** : Prélèvements (doses par prélèvement par espèce), Prix par dose, Catalogue reproducteurs
- **Mécaniques clés** : Taureau 300-400 doses (30-90€), Verrat 20-40 (5-30€), Étalon 20-30 (30-120€), prix selon qualité génétique
- **Dépendances** : Reproduction, Génétique, CIA (métier), Économie
- **Complexité** : Moyenne

### 5.19 Robot d'Alimentation
- **Sous-systèmes** : Automatisation distribution, Maintenance, Consommation électrique
- **Mécaniques clés** : 185 000€/espèce, SimPass requis, réduit PA nourrissage, maintenance par concessionnaire, pack options (calendrier, compte rendu, estimation)
- **Dépendances** : Bâtiments, Alimentation, SimPass, Concessionnaire
- **Complexité** : Moyenne

### 5.20 Chien de Troupeau
- **Sous-systèmes** : Aide gestion pré, Réduction PA
- **Mécaniques clés** : Réduit PA de mise au pré et rentrée animaux
- **Dépendances** : Pâturage, PA
- **Complexité** : Simple

### 5.21 Allaitement
- **Sous-systèmes** : Femelles allaitantes nourrissant petits
- **Mécaniques clés** : Réduit besoin alimentation externe jeunes, consommation accrue pour la mère
- **Dépendances** : Reproduction (naissances), Alimentation
- **Complexité** : Simple

### 5.22 Négociant en Bestiaux
- **Sous-systèmes** : Intermédiaire achat/vente, Commission
- **Mécaniques clés** : Facilite transactions entre joueurs, commission sur ventes
- **Dépendances** : Marché animaux, Économie
- **Complexité** : Simple


---

## 6. MATÉRIEL

### 6.1 Catalogue Matériel
- **Sous-systèmes** : Motorisés (tracteurs, moissonneuses, ensileuses, arracheuses, télescopiques), Travail du sol (charrues, cultivateurs, herses, déchaumeurs), Semis (semoirs), Traitement (pulvérisateurs, épandeurs), Transport (bennes, plateaux, bétaillères, citernes), Coupe (faucheuses, faneuses, andaineurs), Pressage (presses, enrubanneuses)
- **Mécaniques clés** : Famille, marque, modèle, CV (motorisé) ou required_hp (tracté), largeur, capacité, maniabilité (1-5), max_PA, consommation HVC (travail + trajet), prix neuf, nombre pièces
- **Dépendances** : Cultures (outils requis), Élevage (bétaillères), Transport, PA, Économie
- **Complexité** : Très complexe

### 6.2 Consommation HVC (Bio-carburant)
- **Sous-systèmes** : Réservoir global (fuel_tanks), Calcul consommation (CV × coefficient × PA), Achat HVC
- **Mécaniques clés** : Seuls les motorisés consomment, fuel_travel = 0.05 L/CV/PA, fuel_work = 0.08-0.20 L/CV/PA, prix HVC 0.36-0.60€/L (CAR vs coopérative), si réservoir vide → impossible d'utiliser
- **Dépendances** : Économie (achat HVC), CAR (production HVC via huilerie/méthanisation), Matériel motorisé
- **Complexité** : Moyenne

### 6.3 Usure & Entretien Matériel
- **Sous-systèmes** : Usure quotidienne, Abri (hangar), Entretien (action joueur 2h → -30% usure), Coût pièces selon âge
- **Mécaniques clés** : 0.1%/jour base, ×1.5 si non abrité, entretien = 1 PA + coût pièces × (1 + age × 0.02), récupère 30 points d'usure
- **Dépendances** : Bâtiments (hangar), Économie (coût pièces), PA, Worker (tick quotidien)
- **Complexité** : Moyenne

### 6.4 Pannes
- **Sous-systèmes** : Probabilité panne (liée à usure), Immobilisation (1-2 jours), Assurance, Réparation
- **Mécaniques clés** : Si usure > 50% → chance = (usure-50)/200 (0-25%/jour), is_broken = true, immobilisation 1-2 jours, si assuré = gratuit sinon coût réparation
- **Dépendances** : Usure, Économie (assurance/réparation), Concessionnaire (atelier), Temporalité
- **Complexité** : Moyenne

### 6.5 Pièces Détachées
- **Sous-systèmes** : 1-5 pièces par matériel, Seuils PA (pa_threshold), Alerte changement, Matériel inutilisable si non changée
- **Mécaniques clés** : Chaque pièce a un % des PA max comme seuil, quand usage_pct >= seuil → pièce usée → alerte → si non changée = inutilisable
- **Dépendances** : Utilisation (PA cumulés), Concessionnaire (vente pièces), Économie
- **Complexité** : Moyenne

### 6.6 Maniabilité
- **Sous-systèmes** : Score maniabilité (1-5), Taille parcelle idéale, Bonus/malus PA
- **Mécaniques clés** : Idéal selon taille parcelle (<11ha=5, ≤20=4, ≤30=3, ≤40=2, >40=1), bonus = ×1.10 (match parfait) à ×0.90 (écart 4)
- **Dépendances** : Parcelles (taille), PA
- **Complexité** : Simple

### 6.7 Système GPS
- **Sous-systèmes** : Balises GPS (par zone, 20k€), Récepteurs (3k€ par matériel), Abonnements (400-600€/an/balise), Signal quality
- **Mécaniques clés** : Installation par atelier concessionnaire (5 PA mécanicien), gains proportionnels à signal_quality (réduction heures, économie semences/engrais/traitements)
- **Dépendances** : Concessionnaire (installation + réseau), Cultures (économie intrants), PA (réduction), Économie
- **Complexité** : Complexe

### 6.8 Combinés
- **Sous-systèmes** : Attelage avant+arrière, Actions fusionnées, Relevage avant requis
- **Mécaniques clés** : 2-3 actions en 1 passage, réduction PA (jusqu'à -50%), bonus rendement, hp_multiplier ×1.5 (tracteur plus puissant requis), relevage avant nécessaire (installation 5 PA concessionnaire)
- **Dépendances** : Matériel (avant + arrière), Concessionnaire (relevage avant), Cultures (actions fusionnées), PA
- **Complexité** : Moyenne

### 6.9 Achat/Vente Matériel
- **Sous-systèmes** : Neuf (concessionnaire), Occasion (entre joueurs), Argus, Achat en commun (max 5 joueurs), Annonces (1500€), Dépôt-vente
- **Mécaniques clés** : Argus = prix_neuf × age_factor(max 0.1, 1-age×0.1) × wear_factor(max 0.1, 1-usure/100), achat en commun = même région + amis, annonce 1500€
- **Dépendances** : Concessionnaire, Économie, Social (amis pour achat commun)
- **Complexité** : Moyenne

### 6.10 Matériel Arboricole
- **Sous-systèmes** : Tracteur ≤80CV/arboricole, Cultivateur ≤3m, Herse ≤3m, Broyeur ≤80CV, Pulvérisateur arboricole, Vibreur hydraulique, Ramasseuse arboricole, Plateau, Chargeur frontal/Télescopique ≤80CV
- **Mécaniques clés** : Contraintes taille et puissance spécifiques aux vergers
- **Dépendances** : Cultures arboricoles, Vergers
- **Complexité** : Moyenne

### 6.11 Matériel Forestier
- **Sous-systèmes** : Abatteuse, Débusqueur, Porteur forestier, Broyeur de branches
- **Mécaniques clés** : Tous motorisés, consomment HVC, spécifiques forêts et haies
- **Dépendances** : Foresterie, Haies, HVC
- **Complexité** : Moyenne

### 6.12 Matériel Viticole
- **Sous-systèmes** : Enjambeur, Machine à vendanger, Pressoir, etc.
- **Mécaniques clés** : Spécifique domaines viticoles
- **Dépendances** : Viticulture
- **Complexité** : Moyenne

### 6.13 Matériel Maraîcher
- **Sous-systèmes** : Matériel spécifique serres et légumes
- **Mécaniques clés** : Adapté aux cultures légumières sous serre
- **Dépendances** : Maraîchage, Serres
- **Complexité** : Moyenne

### 6.14 Location de Matériel
- **Sous-systèmes** : Location si panne, Puissance équivalente, Durée = immobilisation, Paiement au PA
- **Mécaniques clés** : Uniquement si tracteur en panne, ±5 CV, durée = durée immobilisation, prix fixé par concessionnaire
- **Dépendances** : Concessionnaire, Pannes
- **Complexité** : Simple

### 6.15 Assurance Matériel
- **Sous-systèmes** : Souscription annuelle, Couverture réparations
- **Mécaniques clés** : Couvre les coûts de réparation en cas de panne
- **Dépendances** : Pannes, Économie (charges)
- **Complexité** : Simple

---

## 7. ÉCONOMIE

### 7.1 Coopérative SimAgri (Marché V1)
- **Sous-systèmes** : Catalogue aliments/produits, Toggle Conv./Bio, Catégories dépliables, Modale achat avec transport, Stock joueur
- **Mécaniques clés** : Prix achat = price_per_ton × 1.15 (+15% marge), stock illimité, distance 20km fixe, 9 types de rations + paille + foin, transport requis (tracteur+remorque)
- **Dépendances** : Transport, Bâtiments (stockage), Économie, PA
- **Complexité** : Complexe

### 7.2 Prix Dynamiques (Marché)
- **Sous-systèmes** : Prix de base, Offre/demande, Variation hebdomadaire, Historique prix, Prime bio
- **Mécaniques clés** : Tick hebdomadaire (=mensuel SimAgri), ratio demand/supply → variation ±15% max, clamp [base×0.5, base×2.0], prime bio +20%, historique enregistré
- **Dépendances** : Tous les producteurs (offre), Consommation (demande), Temporalité
- **Complexité** : Complexe

### 7.3 Transactions
- **Sous-systèmes** : Types (coop_buy, coop_sell, player_trade, market, abattoir), Historique, Qualité, Bio flag
- **Mécaniques clés** : Enregistrement systématique de toute transaction, seller_id/buyer_id (NULL si coopérative), quantité, prix unitaire, total
- **Dépendances** : Tous les modules de vente/achat
- **Complexité** : Moyenne

### 7.4 Banque
- **Sous-systèmes** : Compte courant (balance), Épargne (savings), Emprunts (via CAR), Journal financier (financial_log)
- **Mécaniques clés** : Prêt JA (80k-150k€ selon difficulté), taux intérêt variable, remboursement mensuel automatique, historique toutes opérations par type (income/expense/loan/salary/electricity/fuel)
- **Dépendances** : Joueur, CAR (emprunts), Worker (tick mensuel charges), Tous les modules (revenus/dépenses)
- **Complexité** : Complexe

### 7.5 Charges Automatiques (tick mensuel)
- **Sous-systèmes** : Salaires employés, Facture électricité, Remboursements emprunts, Assurances
- **Mécaniques clés** : Déduction auto chaque mois SimAgri : salaires, kwh×0.08€, mensualités prêts, assurances
- **Dépendances** : Employés, Bâtiments (énergie), Banque (prêts), Matériel (assurances), Worker
- **Complexité** : Moyenne

### 7.6 Parcelles — Achat/Vente
- **Sous-systèmes** : Achat SimAgri/joueurs/Partcel, Prix par pays (3000-7000€/ha), Taxe plus-value, Vente à SimAgri (25% prix, 5 saisons min)
- **Mécaniques clés** : Prix/ha variable par pays, BIO +50% (Partcel), taxe plus-value dégressive (90%→50% selon durée détention 0-5+ ans), vente à SimAgri = 25% prix estimé (min 5 saisons)
- **Dépendances** : Joueur (budget), Cultures (parcelles), Géographie
- **Complexité** : Moyenne

### 7.7 Annonces (entre joueurs)
- **Sous-systèmes** : Types (equipment, animal, product, parcel, service), Filtres (région, amis), Expiration
- **Mécaniques clés** : Prix libre, possibilité region_only ou friend_only, expiration automatique
- **Dépendances** : Social (amis), Géographie, Tous les modules (objets à vendre)
- **Complexité** : Moyenne

### 7.8 Grossistes et Centrales d'Achat
- **Sous-systèmes** : Grossistes par serveur, Centrales d'achat, Types de produits acceptés, Multiplicateur prix
- **Mécaniques clés** : Canaux de vente alternatifs pour productions transformées (fromage, légumes, foie gras, vin), price_factor variable
- **Dépendances** : Transformations, Économie
- **Complexité** : Moyenne

### 7.9 Marchés (vente directe)
- **Sous-systèmes** : Marchés par région, Jours de marché, Emplacements, Revenus
- **Mécaniques clés** : Vente directe fromagerie/maraîchage/foie gras, capacité limitée par emplacement, jour de marché fixe
- **Dépendances** : Transformations (fromage, légumes, foie gras), Géographie (région)
- **Complexité** : Moyenne

### 7.10 Organisme Partcel
- **Sous-systèmes** : Vente parcelles conventionnelles et BIO
- **Mécaniques clés** : Prix standard + BIO (+50%), alternative à l'achat entre joueurs
- **Dépendances** : Parcelles, Économie
- **Complexité** : Simple


---

## 8. MÉTIERS / ACTIVITÉS ANNEXES

### 8.1 Concessionnaire
- **Sous-systèmes** : Hall de vente (200m²), Licences constructeurs (100 points), Vendeurs, Mécaniciens (compétences 1-10, spécialités 3 marques, retraite 60 ans), Atelier (entretien 8-24€/PA + dépannage + camion atelier), Dépôt-vente, Location tracteurs, Pièces détachées (magasin 20k€ + vendeur + marge 20-50% + remise 5-15%), Réseau GPS (balises 20k€/zone + récepteur 2.5k€ + abonnement 400-600€/an), Relevage avant (installation 5 PA, 150-300€)
- **Mécaniques clés** : Condition = 90j ancienneté + SimPass, droits d'entrée + reversement CA, licences = points, mécaniciens avec skills wear/pa (1-10), salaire mensuel, location seulement si client en panne (±5CV), désinstallation relevage 2PA (matériel neuf uniquement)
- **Dépendances** : SimPass, Matériel (vente/entretien/GPS), Économie, Employés (staff concessionnaire), PA
- **Complexité** : Très complexe

### 8.2 Transporteur
- **Sous-systèmes** : Entreprise de transport, Camions (semi-remorques), Chauffeurs (25 PA/jour, salaire 1400€), Commandes de transport, Licences, Types semi-remorques (8 types)
- **Mécaniques clés** : Consommation camion 24-28L HVC/PA, prix fixé par transporteur, 8 types semi (plateau, benne, citerne, porte-engin, grumier, citerne pulvérulent, citerne agroalimentaire, citerne lait), statuts commande (pending/in_transit/delivered)
- **Dépendances** : Économie (revenus), HVC, Joueurs (clients), Laiterie (collecte lait)
- **Complexité** : Complexe

### 8.3 Centre d'Insémination Artificielle (CIA)
- **Sous-systèmes** : Centre, Mâles reproducteurs, Prélèvements → doses, Contrats éleveurs, Catalogue doses, Insémination à distance
- **Mécaniques clés** : Catalogage mâles avec indices génétiques, prélèvements (300-400 doses/taureau, 20-40/verrat, etc.), prix dose variable (0.5-120€ selon génétique), contrats avec éleveurs, inséminateur se déplace
- **Dépendances** : Élevage (reproduction, génétique), Économie, SimPass
- **Complexité** : Complexe

### 8.4 Coopérative Agricole Régionale (CAR)
- **Sous-systèmes** : Structure (associés, parts sociales, rôles président/admin/membre), Magasin libre-service, Huilerie (colza→huile→HVC), Sucrerie (betterave→sucre+écume), Laiterie (collecte+transformation), Méthanisation (substrats→digesteur→biogaz→électricité/HVC+digestat), Emprunts, Achats/ventes entre CAR, Appels d'offre
- **Mécaniques clés** : Multi-joueurs (associés), parts sociales + dividendes, contrats d'approvisionnement, magasin avec HVC (0.36-0.55€/L), chaque sous-activité = chaîne de transformation complète, panne/usure digesteur
- **Dépendances** : Économie (emprunts, parts), Cultures (betterave, colza), Élevage (lait), Transporteur (collecte), Matériel (HVC), Multiple joueurs
- **Complexité** : Très complexe

### 8.5 ETA (Entreprise de Travaux Agricoles)
- **Sous-systèmes** : Offre de services (labour, moisson, semis, fauchage...), Commandes, Exécution avec matériel propre
- **Mécaniques clés** : Joueur propose ses services avec son matériel, prix/ha libre, client paie (0 PA client), ETA consomme ses PA + HVC, annuaire par région
- **Dépendances** : Matériel (du prestataire), Cultures (travaux), PA (du prestataire), Économie
- **Complexité** : Moyenne

### 8.6 Méthanisation à la Ferme
- **Sous-systèmes** : Digesteur, Substrats (fumier, lisier, maïs ensilé, paille vrac, céréale immature, herbe ensilée), Biogaz → Électricité + HVC, Digestat (solide/liquide), Panne et usure
- **Mécaniques clés** : Construction propre unité, entretien régulier nécessaire, vente électricité au réseau + production HVC propre, digestat réutilisable en épandage
- **Dépendances** : Élevage (fumier/lisier), Cultures (ensilage, céréale immature), Bâtiments (digesteur), Économie (vente électricité), Sol (digestat)
- **Complexité** : Complexe

### 8.7 Laiterie (chaîne complète)
- **Sous-systèmes** : Producteur (traite→cuve), Transporteur (collecte citerne), Laiterie CAR (transformation), Contrats lait
- **Mécaniques clés** : Contrats fréquence hebdomadaire, prix/L variable selon type lait (vache/chèvre/brebis), chaîne producteur→transporteur→laiterie
- **Dépendances** : Élevage (production lait), Transporteur, CAR, Économie
- **Complexité** : Complexe

---

## 9. TRANSFORMATIONS

### 9.1 Fromagerie
- **Sous-systèmes** : Types (fermière/artisanale/industrielle), Hygiène/propreté, Matériel fromagerie, Fromagers (1-10 employés), Fabrication, Affinage (durée variable), DLC, Sous-produits (crème, beurre), Vente (marchés/grossistes)
- **Mécaniques clés** : 5 modèles artisanaux (20.8k-100k€, 250-1250L/j) + 9 industriels (198k-910k€, 2200-11000L/j), impossible passer artisanale→industrielle sans destruction, industrielle = SimPass + ~1.80€, nettoyage quotidien (fromagerie inutilisable le jour), lait transformé dans la journée (sinon perdu), qualité fromage 1-3, DLC
- **Dépendances** : Élevage (lait vache/chèvre/brebis), Économie (vente marchés/grossistes), SimPass (industrielle), PA (fromagers)
- **Complexité** : Très complexe

### 9.2 Maraîchage
- **Sous-systèmes** : Serres (plastique/verre), Chauffage (chaudière polycombustible : miscanthus 5KW/kg, bois déchiqueté 2.8-3.5KW/kg), Personnel spécialisé, Cultures légumières, Température contrôlée, Vente marchés
- **Mécaniques clés** : Construction serre, contrôle température selon culture, chauffage = consommation combustible, personnel avec rôle et salaire, récolte légumes, vente sur marchés
- **Dépendances** : Bâtiments (serre), Haies (bois déchiqueté chauffage), Économie (marchés, grossistes), PA (personnel)
- **Complexité** : Complexe

### 9.3 Foie Gras
- **Sous-systèmes** : Races spécifiques (Oie Toulouse, Canard Barbarie...), Phases (élevage→pré-gavage→gavage→abattage), Rations spéciales gavage, Commercialisation (marchés, grossistes)
- **Mécaniques clés** : Cycle complet élevage→gavage→abattage, races spécifiques foie gras uniquement, rations gavage dédiées, produits = foie gras + viande, stockage chambre froide
- **Dépendances** : Élevage (oies/canards races FG), Bâtiments (chambre froide), Économie (marchés), Labels BIO (contraintes spécifiques)
- **Complexité** : Complexe

### 9.4 Viticulture
- **Sous-systèmes** : Domaine viticole (balance propre), Parcelles vignes (cépages, âge, santé), Cycle (plantation→taille→traitement→vendange→vinification→assemblage→élevage→mise en bouteille), Conteneurs (cuve/fût/bouteille), Qualité (1-5), Labels, Concours/Médailles, Personnel viticole
- **Mécaniques clés** : Domaine = entité économique séparée (balance propre), cépages variés, âge des vignes impacte qualité, vinification multi-étapes, vieillissement en fût/cuve, mise en bouteille, concours avec médailles, vente
- **Dépendances** : Matériel viticole (enjambeur, vendangeuse, pressoir), Météo, Parcelles, Économie, Social (concours)
- **Complexité** : Très complexe

### 9.5 Foresterie
- **Sous-systèmes** : Forêts (type arbre, âge, volume m³), Stations forestières, Entreprise de Travaux Forestiers (ETF), Vente de bois, Matériel forestier (abatteuse, débusqueur, porteur)
- **Mécaniques clés** : Gestion forêt long terme, abattage → extraction → transport → vente, ETF = prestation pour d'autres joueurs, volume en m³
- **Dépendances** : Matériel forestier, Parcelles (prairie boisée), Économie (vente bois), HVC
- **Complexité** : Complexe

### 9.6 Haies (transformation bois)
- **Sous-systèmes** : Taille → bois coupé → déchiquetage → stockage plateforme → utilisation (litière OU chauffage serre)
- **Mécaniques clés** : Chaîne de valeur complète, plateforme bois déchiqueté (1€/tonne, max 10000t, 4m³/tonne), bois = litière alternative paille OU chauffage serre (2.8-3.5 KW/kg)
- **Dépendances** : Matériel (broyeur branches, tracteur, chargeur), Cultures (haies), Maraîchage (chauffage), Élevage (litière)
- **Complexité** : Moyenne

### 9.7 Méthanisation (transformation)
- **Sous-systèmes** : Digesteur (capacité m³, usure), Substrats acceptés (fumier, lisier, maïs ensilé, paille vrac, céréale immature, herbe ensilée), Biogaz, Électricité (vente réseau), HVC (carburant), Digestat (solide + liquide pour épandage)
- **Mécaniques clés** : Substrats → digesteur → biogaz → 2 produits (électricité vendue + HVC produit) + 2 sous-produits (digestat solide/liquide = engrais), panne et usure digesteur
- **Dépendances** : Élevage (fumier/lisier), Cultures (ensilage, céréale immature, paille), Économie (vente électricité), Sol (digestat), Matériel (HVC produit)
- **Complexité** : Complexe


---

## 10. SOCIAL

### 10.1 Système d'Amis
- **Sous-systèmes** : Liste amis, Amis privilégiés (vente directe)
- **Mécaniques clés** : Relation bidirectionnelle, flag is_privileged pour vente directe entre amis
- **Dépendances** : Marché (vente privée), Matériel (achat en commun)
- **Complexité** : Simple

### 10.2 Messagerie
- **Sous-systèmes** : Messages privés (asynchrone), MP-Live (temps réel WebSocket), Canaux (privé 1-1, régional, serveur)
- **Mécaniques clés** : Messages avec sujet/corps/statut lu, chat temps réel via WebSocket, canaux multiples
- **Dépendances** : Joueurs, Infrastructure WebSocket
- **Complexité** : Moyenne

### 10.3 Forum
- **Sous-systèmes** : Catégories (par serveur), Topics (épinglables), Posts
- **Mécaniques clés** : Forum intégré par serveur, topics épinglables, auteur = joueur
- **Dépendances** : Joueurs, Serveurs
- **Complexité** : Moyenne

### 10.4 CFSA (Centre de Formation)
- **Sous-systèmes** : Inscription stagiaire, Attribution maître, Suivi formation 42 jours, Bonus (SimPass + aide financière)
- **Mécaniques clés** : Stagiaire < 14j ancienneté, Maître 168+ jours (max 1-5 stagiaires selon ancienneté), durée 42 jours, bonus stagiaire +4j SimPass + 25k€, bonus maître +4j SimPass
- **Dépendances** : Joueur (ancienneté), SimPass, Économie (aide)
- **Complexité** : Moyenne

### 10.5 Classements
- **Sous-systèmes** : Richesse, Surface cultivée, Nombre animaux, Production lait, Génétique
- **Mécaniques clés** : Vue calculée agrégée (balance + épargne + patrimoine), classement multi-critères
- **Dépendances** : Tous les modules (données agrégées)
- **Complexité** : Moyenne

### 10.6 Concours Animaux / GénétiSim
- **Sous-systèmes** : Organisation concours (par espèce/race), Inscriptions, Scoring (génétique + poids + morphologie + production), Classement
- **Mécaniques clés** : Concours réguliers, scoring basé sur indices génétiques, participation payante, récompenses
- **Dépendances** : Élevage (génétique), Économie (récompenses), Social
- **Complexité** : Complexe

### 10.7 CESA (Conseil Économique SimAgri)
- **Sous-systèmes** : Fixation prix régulés (miscanthus, luzerne), Aide financière nouveaux joueurs (25k€), Arbitrage litiges
- **Mécaniques clés** : Organe de régulation serveur, intervention sur prix, aide post-formation
- **Dépendances** : Économie (prix), CFSA, Joueurs
- **Complexité** : Moyenne

### 10.8 Salons et Événements
- **Sous-systèmes** : GénétiSim (salon génétique), VitiSim (salon viticole), GénétiVRAD (salon IVRAD), Événements in-game (dates, récompenses)
- **Mécaniques clés** : Événements périodiques avec dates début/fin, récompenses JSONB, participation joueurs
- **Dépendances** : Élevage (GénétiSim), Viticulture (VitiSim), IVRAD, Temporalité
- **Complexité** : Moyenne

### 10.9 Badges
- **Sous-systèmes** : Catalogue badges (slug, nom, description, icône), Attribution automatique
- **Mécaniques clés** : Badges gagnés par accomplissements, date d'obtention, affichage profil
- **Dépendances** : Tous les modules (critères), Profil joueur
- **Complexité** : Moyenne

### 10.10 Sondages
- **Sous-systèmes** : Création sondages (par serveur), Options, Votes, Expiration
- **Mécaniques clés** : 1 vote par joueur par sondage, fermeture automatique (closes_at)
- **Dépendances** : Joueurs, Serveurs
- **Complexité** : Simple

### 10.11 Profil Joueur
- **Sous-systèmes** : Fiche présentation (texte libre, photo, stats publiques), Carte ISO (identité virtuelle), Disponibilité (en ligne/hors ligne/occupé), Favoris (joueurs, animaux, matériels), Préférences notifications, Préférences activités
- **Mécaniques clés** : Profil public configurable, statut temps réel, favoris cross-module, notifications configurables par type
- **Dépendances** : Tous les modules (stats), WebSocket (statut), Notifications
- **Complexité** : Moyenne

### 10.12 Challenges
- **Sous-systèmes** : Définition challenge (critères JSONB, dates, récompenses), Participation, Score, Classement
- **Mécaniques clés** : Challenges temporaires avec objectifs, scoring automatique, classement entre participants, récompenses
- **Dépendances** : Tous les modules (critères), Économie (récompenses), Temporalité
- **Complexité** : Complexe

---

## 11. MONÉTISATION

### 11.1 SimPass
- **Sous-systèmes** : Activation, Durée (84 jours = 1 saison), Jours bonus (CFSA, parrainage), Fonctionnalités débloquées
- **Mécaniques clés** : ~2€/trimestre, débloque activités annexes (concessionnaire, CIA, CAR...), statistiques avancées, options supplémentaires, pas de publicité
- **Dépendances** : Métiers annexes (condition déblocage), CFSA (bonus), Parrainage (bonus)
- **Complexité** : Simple

### 11.2 Packs & Options
- **Sous-systèmes** : Options cosmétiques/confort, Activation/expiration
- **Mécaniques clés** : Pas de pay-to-win agressif, bonus de confort, date d'activation et expiration
- **Dépendances** : Joueur
- **Complexité** : Simple

### 11.3 Parrainage
- **Sous-systèmes** : Lien parrain/filleul, Bonus SimPass
- **Mécaniques clés** : Bonus SimPass pour le parrain quand filleul s'inscrit et active son SimPass
- **Dépendances** : SimPass, Inscription
- **Complexité** : Simple

---
---

## RÉSUMÉ — COMPTAGE DES SYSTÈMES

| Catégorie | Nb systèmes | Complexité dominante |
|-----------|:-----------:|---------------------|
| 1. CORE | 14 | Moyenne |
| 2. MÉTÉO | 4 | Complexe |
| 3. BÂTIMENTS | 9 | Complexe |
| 4. CULTURES | 16 | Complexe / Très complexe |
| 5. ÉLEVAGE | 22 | Complexe / Très complexe |
| 6. MATÉRIEL | 15 | Moyenne / Complexe |
| 7. ÉCONOMIE | 10 | Complexe |
| 8. MÉTIERS | 7 | Complexe / Très complexe |
| 9. TRANSFORMATIONS | 7 | Complexe / Très complexe |
| 10. SOCIAL | 12 | Moyenne |
| 11. MONÉTISATION | 3 | Simple |
| **TOTAL** | **119 sous-systèmes** | |

### Systèmes les plus complexes (Très complexe)
1. Cultures actives (cycle cultural complet)
2. Calcul de rendement (multi-facteurs)
3. Cultures arboricoles (vergers)
4. Animaux (lots, 13+ espèces)
5. Génétique (14 indices, croisements)
6. Catalogue matériel (familles, caractéristiques)
7. Concessionnaire (sous-activités multiples)
8. CAR (8+ sous-activités)
9. Fromagerie (chaîne complète)
10. Viticulture (cycle complet multi-étapes)

### Dépendances critiques (systèmes les plus connectés)
1. **Économie** → connectée à TOUS les modules
2. **PA / Heures** → requis par toutes les actions
3. **Worker / Ticks** → anime cultures, élevage, usure, charges
4. **Transport** → requis pour tout déplacement de ressources
5. **Bâtiments** → stockage + capacité pour élevage + cultures
