# Plan d'Action Agile v2 — Élevage First

> Refacto 2026-04-05 — L'élevage est la première feature jouable.
> Principe : chaque sprint = livrable testable depuis l'interface.
> L'infra se construit AU FUR ET À MESURE des besoins, pas en bloc.

---

## Philosophie : Vertical Slice

L'ancien plan construisait l'infra (6 sprints) puis les cultures (10 sprints) puis l'élevage (8 sprints). Le joueur ne pouvait rien tester avant le sprint 7.

**Nouveau plan :** Chaque sprint livre une tranche verticale (DB → API → UI) testable. On commence par l'élevage car c'est le cœur du jeu de gestion quotidien.

---

## Sprint 01 — Auth + Shell UI 🟡 (2 sem)

**Objectif :** Un joueur s'inscrit, se connecte, voit un shell d'application vide.

**Backend :**
- POST /api/auth/register (email, password, username)
- POST /api/auth/login → JWT 15min + refresh 7j httpOnly
- POST /api/auth/refresh → rotation token
- GET /api/player/me → profil basique
- Middleware : auth JWT, idempotency key, ownership check
- DB : tables `player`, `server`, `session`

**Frontend :**
- Pages : `/register`, `/login`, `/dashboard` (vide avec message bienvenue)
- Layout shell : Header (logo, pseudo, bouton déconnexion), Sidebar (vide), Contenu
- Store : `useAuthStore` (token, player)
- Router guard : redirect `/login` si pas connecté

**Testable UI :** Le joueur s'inscrit → se connecte → voit le dashboard vide → se déconnecte.

---

## Sprint 02 — Création ferme + Géographie + Temps 🟡 (2 sem)

**Objectif :** Le joueur choisit sa localisation et voit le temps avancer.

**Backend :**
- POST /api/farms { prefecture_id } → crée ferme, solde 100k€, 40 HT
- GET /api/geography/regions → GET /api/geography/departments/:id → GET /api/geography/prefectures/:id
- GET /api/server/time → jour, mois, saison, année Cultivia
- Worker : tick journalier 00:00 UTC (reset HT, avance date)
- DB : tables `farm`, `prefecture`, `department`, `region`, `server_time`
- Seed : ~340 préfectures françaises

**Frontend :**
- Wizard `/setup-farm` : carte France → région → département → préfecture
- Header enrichi : date Cultivia + saison + solde + HT (barre)
- Dashboard : message bienvenue + localisation

**Testable UI :** Le joueur choisit Clermont-Ferrand → voit "7 Avril — Mois 4 (Printemps)" → le lendemain le jour avance → HT reset à 40.

---

## Sprint 03 — Bâtiments élevage + Premier animal 🟡 (2 sem)

**Objectif :** Le joueur construit une stabulation, achète un bovin, le voit dans sa ferme.

**Backend :**
- POST /api/buildings { type, size } → construction (instantanée niv 1)
- GET /api/buildings → liste bâtiments
- GET /api/buildings/:id → détail (capacité, remplissage, usure)
- POST /api/animals/buy { breed_id, sex, building_id } → achat coop
- GET /api/animals → liste animaux
- GET /api/animals/:id → fiche complète (identité, santé, génétique, production, parents, actions disponibles)
- DB : tables `building`, `building_type`, `animal`, `breed`, `animal_genetics`
- Seed : types bâtiments (stabulation, cuve eau, silo), races bovines (Prim'Holstein, Charolaise, Montbéliarde)
- Économie : déduction solde (SELECT FOR UPDATE), déduction HT, ledger

**Frontend :**
- Page `/buildings` : DataTable (type, capacité, remplissage, usure, actions)
- Page `/buildings/buy` : catalogue en grille, formulaire taille, bouton construire
- Page `/animals` : tableau de bord élevage (compteurs alertes) + DataTable (nom, race, sexe, âge, santé, nourri, lieu)
- Page `/animals/:id` : fiche complète adaptée par espèce (identité, génétique 5 barres, santé, alimentation, production, reproduction, actions)
- Sidebar : liens Mes bâtiments, Mes animaux, Marché Central

**Testable UI :** Le joueur construit une stabulation → va au Marché Central → achète une Prim'Holstein → voit "🐄 en transit, arrivée dans Xh" → le tick de livraison (F048) confirme l'arrivée → l'animal apparaît dans sa liste → clique dessus → fiche complète avec génétique.

> **Note transport :** L'achat d'animal nécessite tracteur + bétaillère + HVC (inclus dans kits Éleveur/Polyvalent). L'animal est en transit avec un délai basé sur la distance (haversine). Usure véhicule + risque de panne appliqués. Voir AUDIT_REALISME_TRANSPORT.md.

---

## Sprint 04 — Nourrir + Abreuver + Alertes 🟡 (2 sem)

**Objectif :** Le joueur nourrit et abreuve ses animaux. Le tick détecte les carences.

**Backend :**
- POST /api/buildings/:id/feed { ration_id, use_desilage } → nourrir
- POST /api/animals/water { building_id } → abreuver
- POST /api/buildings/:id/auto-feed { ration_id, duration } → config nourrissage auto
- GET /api/rations?species=cattle → rations disponibles
- Worker tick : nourrissage auto (étape 10), vérif santé (étape 11) → maladie si pas nourri/abreuvé
- DB : tables `ration`, `inventory` (stock aliments), `animal_feeding_log`
- Cuve à eau : construction + remplissage

**Frontend :**
- Page nourrissage : sélection bâtiment → rations radio → stock ✅/❌ → bouton Nourrir
- Config nourrissage auto : toggle + ration + durée + estimation stock
- Dashboard élevage : widgets "Pas nourris ⚠️", "Pas abreuvés ⚠️", "Malades 🔴"
- Notifications : "Des animaux n'ont pas mangé aujourd'hui"

**Testable UI :** Le joueur achète du foin au Marché Central → le foin est "en transit" (F050) → arrivée après délai basé sur distance → nourrit ses vaches → le lendemain celles non nourries tombent malades → alerte sur le dashboard.

> **Note transport :** L'achat d'aliments nécessite tracteur + benne + HVC. Marchandises en transit avec délai. Usure + panne appliqués. Voir AUDIT_REALISME_TRANSPORT.md.

---

## Sprint 05 — Soins + Vaccins + Litière 🟢 (1 sem)

**Objectif :** Le joueur soigne, vaccine, met de la paille, retire le fumier.

**Backend :**
- POST /api/animals/:id/heal → soigner (coût € + HT)
- POST /api/animals/batch-heal → soigner groupé
- POST /api/animals/:id/vaccinate → vacciner (50€ + 0.5 HT)
- POST /api/buildings/:id/bedding → mettre paille (stock + HT)
- POST /api/buildings/:id/manure → retirer fumier (HT, fosse)
- POST /api/buildings/:id/slurry → retirer lisier (HT, fosse)
- DB : tables `animal_health_log`, `disease`

**Frontend :**
- Fiche animal : boutons Soigner/Vacciner avec états (grisé + tooltip si pas malade/déjà vacciné)
- Actions groupées dans DataTable : [Soigner tous]
- Sidebar élevage : liens Soins/Propreté, Paille/Fumier/Lisier

**Testable UI :** Animal malade → clic Soigner → toast succès → icône 🏥 disparaît. Vacciner → badge 💉 apparaît. Paille → litière ✅.

---

## Sprint 06 — Reproduction + Naissances 🟡 (2 sem)

**Objectif :** Le joueur insémine une vache, attend la gestation, un veau naît.

**Backend :**
- POST /api/animals/:id/inseminate { method, male_id } → naturel ou CIA
- GET /api/animals/:id/pedigree?depth=3 → arbre généalogique
- Worker tick : vérif gestation → naissance → calcul génétique descendance
- DB : `animal.is_pregnant`, `animal.pregnant_since`, `animal.mate_id`, `animal_reproduction_log`
- Calcul génétique : `offspring = avg(mother, father) ± random_variation`

**Frontend :**
- Fiche animal : bouton Inséminer (modale choix mâle/CIA, comparaison génétique)
- Badge 🤰 sur les gestantes dans la DataTable
- Arbre généalogique : composant SVG 3 générations
- Notification : "🐄 Marguerite a donné naissance à un veau !"
- Dashboard : widget "Naissances à venir", "En arrivage" + bouton Placer auto

**Testable UI :** Inséminer → attendre X jours → naissance → veau dans l'enclos d'arrivage → placer en bâtiment → voir l'arbre généalogique.

---

## Sprint 07 — Traite + Productions + Vente 🟡 (2 sem)

**Objectif :** Le joueur trait ses vaches, vend le lait, vend des animaux à l'abattoir.

**Backend :**
- POST /api/animals/milk { animal_ids | all } → traite (HT, cuve lait)
- POST /api/animals/slaughter { animal_ids } → vente abattoir (cours × poids)
- POST /api/market/sell { product, quantity, price } → vente lait/produits
- GET /api/animals/productions → stock lait/œufs/laine + historique
- GET /api/market/prices → cours actuels par produit
- DB : tables `production_log`, `milk_tank` (stock cuve), `market_price`

**Frontend :**
- Page `/animals/milking` : liste vaches en lactation, production estimée, cuve, bouton Traire
- Page `/animals/productions` : onglets Lait/Œufs/Laine, stock, graphique 30j, bouton Vendre
- Abattoir : ConfirmModal avec détail prix/kg × poids par animal
- Marché Central : cours actuels vs antérieurs (↑↓)

**Testable UI :** Traire → lait dans la cuve → vendre au Marché Central → solde augmente. Vendre vache à l'abattoir → solde + prix × poids.

---

## Sprint 08 — Déplacements + Employés + Météo 🟡 (2 sem)

**Objectif :** Déplacer animaux, embaucher, voir la météo.

**Backend :**
- POST /api/animals/move { animal_ids, destination_type, destination_id }
- POST /api/employees → embaucher (+HT/jour, salaire mensuel)
- DELETE /api/employees/:id → licencier
- GET /api/weather?prefecture_id → météo 3 jours
- Worker tick : génération météo, événements saisonniers (gel, sécheresse)
- DB : tables `employee`, `weather`, `weather_event`

**Frontend :**
- Déplacer : modale destination (bâtiment/pré) avec places dispo + coût HT
- Page `/employees` : liste + coût mensuel total + boutons embaucher/licencier
- Page `/weather` : 3 jours, alertes, historique
- Header : météo (icône + temp), HT mis à jour avec employés
- Dashboard : widget météo + alertes événements

**Testable UI :** Embaucher → HT max passe de 40 à 48. Météo gel → alerte sur dashboard. Déplacer vache au pré → coût HT déduit.

---

## Sprint 09 — Dashboard complet + Finances + Messagerie 🟡 (2 sem)

**Objectif :** Dashboard riche, relevé bancaire, épargne, prêts, messagerie.

**Backend :**
- GET /api/dashboard → endpoint agrégé (alertes, résumés, graphique solde, notifs)
- GET /api/finances/ledger → relevé paginé + filtres + export CSV
- POST /api/finances/savings → souscrire épargne
- POST /api/savings/:id/close → clôturer épargne anticipée (F065 — capital restitué, 0€ intérêts)
- POST /api/finances/loans → demander prêt (max 150k€)
- POST /api/loans/:id/early-repay → rembourser prêt par anticipation (F079 — pénalité 3%)
- POST /api/messages → envoyer message
- GET /api/messages → boîte réception

**Frontend :**
- Dashboard complet : 10 widgets (finances, HT, alertes, élevage, bâtiments, matériels, météo, notifs, actus, guide débutant)
- Pages finances : relevé, épargnes, prêts
- Messagerie : boîte réception, envoi, contacts
- Paramètres : profil, notifications, affichage

**Testable UI :** Dashboard montre tout d'un coup d'œil. Relevé bancaire filtre par catégorie. Prêt → solde crédité → mensualités auto.

---

## Sprint 10 — Parcelles + Sol + Cultures de base 🟡 (2 sem)

**Objectif :** Le joueur achète une parcelle, analyse le sol, sème du blé.

**Backend :**
- POST /api/parcels/buy → achat parcelle
- GET /api/parcels/:id → détail complet (sol, eau, irrigation, haie, fatigue, altitude, note)
- POST /api/parcels/:id/analyze-soil → analyse 6 nutriments
- POST /api/parcels/:id/prepare → déchaumer/labourer/herser
- POST /api/parcels/:id/sow → semer
- DB : tables `parcel`, `parcel_soil`, `crop`, `seed_type`

**Frontend :**
- Page `/parcels` : DataTable 5 onglets (Culture, Sol, Eau, Animaux, Haie)
- Page `/parcels/:id` : fiche complète (infos, sol 6 jauges, météo, culture, irrigation, haie, animaux au pré, note, actions)
- Actions groupées : jachère, culture, ETA, analyse, irrigation

**Testable UI :** Acheter parcelle → analyser sol → voir 6 jauges → semer blé → barre progression croissance.

---

## Sprint 11 — Cycle culture complet + Récolte + Vente 🟡 (2 sem)

**Objectif :** Cycle complet : engrais → traitement → récolte → vente.

**Backend :**
- POST /api/parcels/:id/fertilize → épandre engrais
- POST /api/parcels/:id/treat → traiter (fongicide/herbicide/insecticide)
- POST /api/parcels/:id/roll → passer rouleau
- POST /api/parcels/:id/harvest → récolter
- POST /api/parcels/:id/bale → presser paille
- Worker tick : croissance cultures, fatigue sol, événements météo impact
- Marché Central : vente récolte avec cours saisonniers

**Frontend :**
- Fiche parcelle : boutons contextuels avec coût HT + HVC + matériel requis
- Progression culture : barre + estimation jours restants
- Traitements : 3 icônes ✅/❌
- Vente récolte : cours actuel vs antérieur, quantité, total

**Testable UI :** Semer → engrais → traiter → attendre croissance → récolter → vendre → profit visible dans le relevé.

---

## Sprint 12 — Matériels + HVC + ETA 🟡 (2 sem)

**Objectif :** Acheter du matériel, faire le plein, utiliser l'ETA Cultivia.

**Backend :**
- POST /api/vehicles/buy → achat neuf (catalogue marques réelles)
- POST /api/vehicles/:id/sell → vente (argus)
- POST /api/vehicles/:id/maintain → entretien mensuel/annuel
- POST /api/vehicles/:id/repair → réparation
- POST /api/hvc/buy → plein carburant
- POST /api/eta/order → commander ETA Cultivia (PNJ, +30%)

**Frontend :**
- Page `/equipment` : DataTable (marque, puissance, durée vie, entretien, assurance, emplacement)
- Catalogue neuf : filtres par type + marque, fiche détaillée, compatibilité tracteur
- Page HVC : jauge cuve + achat
- ETA : formulaire commande + devis

**Testable UI :** Acheter tracteur John Deere → matériel "en livraison" (F049, délai concessionnaire basé sur distance) → arrivée → faire le plein → labourer parcelle → usure augmente → si usure > 80% risque de panne → entretenir/réparer.

> **Note transport :** L'achat de matériel est livré par le concessionnaire (pas de véhicule joueur requis) avec un délai et coût de livraison basés sur la distance. Voir AUDIT_REALISME_TRANSPORT.md.

---

## Sprints 13-16 — Commerce + CAR + Social 🟡×4

- Sprint 13 : Annonces + Commerce joueur-joueur + Contrats
- Sprint 14 : CAR (création, gouvernance, votes, stocks)
- Sprint 15 : Transport + Appels d'offres + Marché à terme
- Sprint 16 : Classements + Statistiques + Polish

---

## Résumé

| Sprint | Contenu | Sem | Flows | Testable depuis l'UI |
|--------|---------|-----|-------|---------------------|
| 01 | Auth + Shell | 2 | — | Inscription → connexion → dashboard vide |
| 02 | Ferme + Géo + Temps | 2 | — | Choix préfecture → temps qui avance |
| 03 | Bâtiments + Premier animal | 2 | F001-F005, F048, F072-F074 | Construire → acheter vache → transit → fiche |
| 04 | Nourrir + Abreuver + Alertes | 2 | F006-F010, F031, F050, F053, F068-F070, F076 | Nourrir → tick → maladie si oublié |
| 05 | Soins + Vaccins + Litière | 1 | F011-F017, F052, F075 | Soigner → vacciner → paille → fumier |
| 06 | Reproduction + Naissances | 2 | F018-F022 | Inséminer → gestation → naissance → généalogie |
| 07 | Traite + Productions + Vente | 2 | F023-F026, F071 | Traire → vendre lait → abattoir → négociant |
| 08 | Déplacements + Employés + Météo | 2 | F027-F030, F051 | Déplacer → embaucher → météo → bacs eau pré |
| 09 | Dashboard + Finances + Messages | 2 | F032-F034, F065-F067, F079 | Dashboard → prêts → épargne → clôture anticipée → messagerie |
| 10 | Parcelles + Sol + Semis | 2 | F035-F038, F054, F057, F077 | Acheter parcelle → analyser → semer → rouler → forer |
| 11 | Cycle culture + Récolte + Vente | 2 | F039-F042, F055-F056, F058-F060 | Engrais → irriguer → récolte → paille → vente |
| 12 | Matériels + HVC + ETA | 2 | F043-F047, F049, F061-F063 | Acheter tracteur → livraison → entretenir → assurance → pièces |
| 13-14 | Commerce + CAR | 4 | — | Annonces → CAR → contrats |
| 15 | Transport + Marché à terme | 2 | F064 | Vente matériel entre joueurs |
| 16 | Classements + Compost + Polish | 2 | F078 | Classements → compostage |
| **Total** | **79 flows spécifiés** | **~31 sem** | **79** | |


---

## Améliorations UX/Design intégrées (questionnaires 10 000 joueurs)

37 améliorations réparties dans les sprints existants.
Backlog détaillé : `docs/03-specs/BACKLOG_AMELIORATIONS.md`
Specs UX détaillées : `docs/03-specs/ux/UX_AMELIORATIONS_QUESTIONNAIRE.md`
Specs design : `docs/reports/QUESTIONNAIRE_ERGONOMIE_DESIGN.md`

| Sprint | Items UX/Design ajoutés |
|--------|------------------------|
| 02 | Tutoriel F112 (skippable), glossaire in-game |
| 03 | Icônes sidebar, breadcrumb, toast 5s, header compact, pagination 20/50/100, texture papier, mobile=consultation |
| 04 | Ration basique défaut, filtre "action requise", tooltip ration |
| 05 | Comparatif litière/caillebotis, stepper sol |
| 06 | Calendrier reproduction |
| 07 | Raccourci vente lait |
| 08 | Fil actualité serveur, sidebar par boucle, suggestions dashboard, mode carte tablette |
| 09 | Récap charges mensuel, mode sobre, mode expert |
| 10 | Cultures recommandées rotation, tendance cours marché, ROI kit |
| 11 | Breakdown rendement 9 facteurs, tooltip presser/broyer |
| 14 | Export CSV, dark mode, raccourcis clavier, comparateur races, graphique cours |
