# SimAgri Clone — Game Design Document v2 (Complet)

Basé sur les règles officielles de SimAgri (mise à jour 20/04/2021).

---

## 1. Concept général

Jeu web multijoueur de simulation agricole en temps réel. Le joueur gère une exploitation agricole complète : cultures, élevage, matériel, bâtiments, et peut exercer des activités annexes (concessionnaire, transporteur, CIA, coopérative, fromagerie, maraîchage, viticulture, foresterie...).

---

## 2. Système temporel

- **1 semaine réelle = 1 mois SimAgri**
- **12 semaines réelles = 1 année SimAgri (84 jours)**
- **4 saisons** : Hiver (Déc-Fév), Printemps (Mar-Mai), Été (Juin-Août), Automne (Sep-Nov)
- **35 Points d'Action (PA) par jour** pour effectuer les travaux
- Possibilité d'embaucher un employé pour augmenter les PA
- Déplacement : 0.25 PA par zone traversée

---

## 3. Serveurs

7 serveurs "pays réels" + 1 serveur "Expert" (main d'œuvre limitée).
Chaque serveur a ses spécificités : races exclusives, taille de parcelles, difficulté (1-5).

| Serveur | Parcelle max | Spécificités |
|---------|-------------|-------------|
| France 1/2/3 | 50 ha | Standard |
| Belgique 1 | 50 ha | Standard |
| Suisse 1 | 50 ha | Standard |
| Canada 1 | 200 ha | Race exclusive Ayrshire (bovin), culture seigle, matériels nord-américains |
| USA 1 | 200 ha | Races exclusives (bovin, caprin, ovin, porcin, volaille, canard), culture coton, matériels nord-américains |
| Expert | 50 ha | Main d'œuvre limitée, difficulté élevée |

---

## 4. Inscription & démarrage

- Choix région → département → zone (1 à 10)
- Budget initial
- Configuration initiale : bâtiment, matériel, animaux, parcelle
- Centre de Formation (CFSA) : mentorat 42 jours par joueur expérimenté
- Pas de délai de construction pour les 10 premiers bâtiments

---

## 5. Cultures

### 5.1 Liste des cultures

| Culture | Semis | Récolte | Prix moyen (€/t) | Rotation | Outil récolte |
|---------|-------|---------|-------------------|----------|---------------|
| Blé | Oct-Nov | Juil-Août | 100 | 1 an | Moissonneuse |
| Orge | Oct-Nov | Juin-Juil | 105 | 1 an | Moissonneuse |
| Orge printemps | Fév-Mar | Juil-Août | 105 | 2 ans | Moissonneuse |
| Avoine | Oct-Nov | Juil-Août | 95 | 1 an | Moissonneuse |
| Avoine printemps | Fév-Mar | Juil-Août | 95 | 2 ans | Moissonneuse |
| Triticale | Oct-Nov | Juil-Août | 125 | 1 an | Moissonneuse |
| Maïs grain | Avr-Mai | Oct-Nov | 110 | 2 ans | Moissonneuse |
| Maïs ensilé | Avr-Mai | Oct-Nov | 45 | 2 ans | Ensileuse |
| Sorgho ensilé | Avr-Mai | Sep-Oct | 50 | 2 ans | Ensileuse |
| Betterave | Mar-Avr | Oct-Nov | 120 | 4 ans | Arracheuse |
| Colza | Août-Sep | Juin-Juil | 220 | 2 ans | Moissonneuse |
| Tournesol | Mar-Avr | Août-Sep | 230 | 3 ans | Moissonneuse |
| Pois | Fév-Mar | Juil-Août | 120 | 3 ans | Moissonneuse |
| Féverole | Nov-Déc | Juil-Août | 145 | 2 ans | Moissonneuse |
| Soja | Avr-Mai | Sep-Oct | 165 | 3 ans | Moissonneuse |
| Lin | Mar-Avr | Juil-Août | 1300 | 6 ans | Arracheuse lin |
| Pomme de terre | Avr-Mai | Sep-Oct | 80 | 4 ans | Arracheuse PDT |
| Chanvre | Mai | Sep | 350/120 | 1 an | Moissonneuse+Faucheuse |
| Épinard | Multi | Multi | 120 | 3 ans | Récolteuse |
| Haricot vert | Avr-Sep | Juin-Nov | 195 | 5 ans | Récolteuse |
| Lentille | Avr-Mai | Août-Sep | 1220 | 2 ans | Moissonneuse |
| Tabac | Mar-Mai | Juil-Sep | 4500 | 3 ans | Manuel |
| Herbe | Mar-Avr/Sep-Oct | Toute l'année | 70 (foin) | - | Faucheuse |
| Miscanthus | Avr-Mai | Fév-Mar | 75 | 20 saisons | Ensileuse |
| Luzerne | Mar-Avr | Pousse 100% | 75 | 4 ans | Ensileuse/Faucheuse |
| Seigle | Oct-Nov | Juil-Août | ~100 | 1 an | Moissonneuse (Canada/USA/Expert) |
| Coton | Avr-Mai | Sep-Oct | ~1500 | 3 ans | Récolteuse coton (USA uniquement) |

### 5.2 Facteurs de rendement
- Qualité de la terre (3 niveaux)
- Engrais (épandeur)
- Fumier (25t/ha) / Lisier (15m³/ha)
- Traitements phytosanitaires (fongicide, herbicide, insecticide — 1.6L/ha, 9€/L)
- Ensoleillement et pluviométrie (jauges)
- Date de récolte (maturation 100% = optimal)
- Passage du rouleau (+3% à +5% pour céréales et herbe)
- Qualité récolte : 3 niveaux (influence prix de vente et valeur nutritionnelle)

### 5.3 Rendements par région
Chaque région a des rendements différents pour chaque culture (tableaux complets dans les règles).

### 5.4 Techniques culturales
| Technique | Rendement | Coût | Restrictions |
|-----------|-----------|------|-------------|
| Traditionnelle | Bon | Élevé | Aucune |
| TCS | Bon/Moyen | Modéré | Aucune |
| Semis direct | Moyen/Faible | Faible | Pas maïs ni PDT |

### 5.5 Gestion du sol
- 6 éléments nutritifs : Azote (N), Phosphore (P), Potassium (K), Calcium (Ca), Magnésium (Mg), Soufre (S)
- Analyse de sol tous les 5 saisons (150€)
- Apports : engrais, fumier, lisier, compost, écume de sucrerie, digestat
- Broyage paille = restitution d'éléments au sol
- Pierres dans le sol : -5% rendement, broyeur de pierres (effet 3 saisons)

### 5.6 Engrais verts / CIPAN
Moutarde, Phacélie, Seigle, Ray-grass Italie — semés après récolte d'été, broyés en janvier.

### 5.7 Culture BIO
- Conversion 2 saisons
- Pas de traitements phytosanitaires
- Rotation +1 an
- Prix de vente +20% minimum

### 5.8 Météo
- 4 zones météo (Nord-Ouest, Nord-Est, Sud-Est, Sud-Ouest)
- 5 niveaux : Très ensoleillé → Forte pluie
- Forte pluie = impossible de travailler
- Vent = impossible de pulvériser
- Grêle = dégâts arboricoles (filet anti-grêle)

### 5.9 Irrigation
- Forage : 150€, source niveau 1-10 (100K à 1M litres/jour)
- Enrouleur ou pivot central
- Retenue collinaire (alimentée par rivière, couvre 1 zone, irrigation des parcelles de la même zone)

### 5.10 Cultures arboricoles
Vergers (max 5 ha). Cultures : pommier, poirier, pêcher, prunier, mirabellier, noyer, olivier, cerisier, framboisier, groseillier, myrtillier.
- Rendement dépend de : qualité terre, nombre/âge arbres, taille/éclaircissement, engrais, traitements, équipements, date récolte
- Matériel spécifique : tracteur ≤80CV, cultivateur ≤3m, pulvérisateur arboricole, vibreur hydraulique (noyer), ramasseuse arboricole
- Bâtiments : entrepôt arboricole, palox, filet anti-grêle (1/ha), chambre froide (petits fruits, cerises, 3j max à 4°C)
- Récolte manuelle (sauf noyer), gourmande en main d'œuvre

### 5.11 Haies
- Plantation arbustes en bordure de parcelle (Sep-Nov), ~1.50€/plant, 0.05PA/plant
- Taille (Déc-Fév) → bois coupé → déchiquetage (broyeur branches) → stockage plateforme (4m³/t)
- Bois déchiqueté : litière (alternative paille) ou chauffage serre (2.8-3.5 KW/kg)
- Bonus : rendement cultures, réduction maladies, réduction besoin eau animaux au pré
- Mortalité : 2% plants/saison

### 5.12 Filière pomme de terre
- Ligne de stockage (100 000€) + entrepôt PDT (100€/t)
- Stockage récolte → 7 Juin, propositions vente hebdo (Déc-Juin)
- Transport vers usine/port/terminal à charge du producteur

### 5.13 Céréale immature
- Ensilage blé/orge/avoine/triticale/seigle entre 60-80% pousse (avant 7 mai)
- Rendement = 150% du rendement grain de base
- Usage : méthanisation ou alimentation bovins/caprins/ovins

### 5.14 Compostage
- 3t fumier → 1t compost (14 jours, 2 retournements)
- En parcelle ou sur aire de compostage à la ferme
- Apports (15T/ha) : N=95, P=60, K=120, Ca=180, Mg=35, S=60

### 5.15 Écume de sucrerie
- Amendement calcique, 15T/ha, 1 fois/5 ans
- Apports : N=45, P=120, K=15, Ca=3600, Mg=90

### 5.16 Quotas
- Betterave : 2 ha ou 10% surface cultivée année précédente
- Tabac : 2 ha max, région exploitation uniquement

---

## 6. Élevage

### 6.1 Espèces

| Espèce | Bâtiment | Races | Reproduction | Gestation | Produits |
|--------|----------|-------|-------------|-----------|----------|
| Bovins laitiers | Stabulation | 10 races | IA ou naturelle | 9 mois | Lait, fumier |
| Bovins allaitants | Stabulation/Pré | 8 races | IA ou naturelle | 9 mois | Veaux, fumier |
| Bisons | Prairie boisée | 2 races | Naturelle seule | 9 mois | Viande |
| Caprins | Chèvrerie | 9 races | IA ou naturelle | 5 mois | Lait, laine (Angora) |
| Porcins | Porcherie | 6 races | IA ou naturelle | 4 mois | Viande |
| Lapins | Clapier | 12 races | IA ou naturelle | 1 mois | Viande, laine (Angora) |
| Volailles | Poulailler | 6 races | IA ou naturelle | 1 mois | Œufs, viande |
| Pintades | Poulailler | 1 race | IA ou naturelle | Saisonnier | Viande |
| Ovins | Bergerie | 14 races | IA ou naturelle | 5 mois | Lait, laine, viande |
| Daims | Prairie boisée | 1 race | Naturelle seule | 8 mois | Viande |
| Oies | Poulailler+Parc | 8 races | IA ou naturelle | Saisonnier | Viande, duvet, foie gras |
| Canards | Poulailler+Parc | 6 races | IA ou naturelle | Saisonnier | Viande, œufs, duvet, foie gras |
| Chevaux | Écurie | 35+ races | IA ou naturelle | 11 mois | Vente |

### 6.2 Mécaniques communes
- **Alimentation** : rations détaillées par espèce, âge, et saison (kg/jour)
- **Abreuvement** : litres/jour par animal
- **Litière** : paille (kg/jour) → se transforme en fumier
- **Caillebotis** : alternative sans paille → produit du lisier
- **Pâturage** : Avril-Octobre, surface m²/jour par animal
- **Races allaitantes** : pâturage hivernal possible avec ration complémentaire
- **Santé** : maladies si manque nourriture/litière, vaccins
- **3 niveaux qualité nourriture** : influence croissance et production lait
- **Surface par animal** en m² dans le bâtiment

### 6.3 Modes d'élevage
- Sur litière (fumier)
- Sur caillebotis (lisier)
- En plein-air (porcins Avr-Oct, avec abris)
- En semi-liberté (volailles, avec parc 10m²/animal)
- En prairie boisée (bisons, daims — toute l'année, clôture 2m + corral)

### 6.4 Génétique & IVRAD
- Indices génétiques par animal
- Objectifs Génétiques (OG) par race
- Valorisation génétique
- Concours animaux / GénétiSim
- Qualité du lait (indice QL)
- IVRAD (Institut Virtuel des Races A Développer) : sélection, accouplement raisonné, vente abattoir IVRAD

### 6.5 Labels
- Label plein-air (conditions à remplir)
- Label BIO

### 6.6 Fonctionnalités complémentaires
- **Chien de troupeau** : aide gestion pré, réduit PA
- **Robot d'alimentation** : automatise distribution rations
- **Négociant en bestiaux** : intermédiaire achat/vente
- **Allaitement** : femelles allaitantes nourrissent petits directement
- **Élevage industriel / Ratio fusion** : gestion grands troupeaux
- **Nommer ses animaux** : via coopérative (service payant)
- **Vaccins** : prévention maladies, coût par animal

---

## 7. Bâtiments & accessoires

### Types
| Bâtiment/Accessoire | Usage | Unité |
|---------------------|-------|-------|
| Hangar | Stockage matériel, paille, foin, semences, engrais | m² |
| Stabulation | Bovins | m² |
| Porcherie | Porcins | m² |
| Chèvrerie | Caprins | m² |
| Bergerie | Ovins | m² |
| Poulailler | Volailles, pintades, oies, canards | m² |
| Clapier | Lapins | m² |
| Écurie | Chevaux | m² |
| Entrepôt | Stockage balles, semences, engrais, traitements | m² |
| Silo | Stockage récoltes (1 par type) | tonnes |
| Silo taupe | Maïs ensilé sous bâche | tonnes |
| Fosse à fumier | Fumier, écume de sucrerie | tonnes |
| Fosse à lisier | Lisier | litres |
| Cuve à lait | Stockage lait | litres |
| Cuve HVC | Bio-carburant | litres |
| Salle de traite | Traite bovins/caprins/ovins | postes |
| Citerne à eau | Eau pour animaux | litres |
| Bac à eau | Eau au pré | litres |
| Parc à volailles | Semi-liberté | m² |
| Parc/abri porcins | Plein-air | abris |
| Salle conditionnement | Œufs | robots |
| Pièce stockage œufs | Œufs | nombre |
| Pièce stockage laine | Laine/duvet | kg |
| Aire de chargement | Chargement camions | m² |
| Silo de chargement | Chargement camions | tonnes |
| Aire stockage paille/foin | Stockage extérieur (pertes) | m² |
| Corral | Regroupement bisons/daims | par prairie |

### Mécaniques
- **Niveau d'équipement** (1-5) : influence consommation énergie
- **Consommation électrique** : kWh/jour, facture mensuelle (0.08€/kWh)
- **Usure** : entretien mensuel (0.3 PA) ou entreprise extérieure (saisonnier)
- **Construction** : temps variable selon type/taille, pas de délai pour les 10 premiers
- **Agrandissement** : bâtiment doit être vidé
- **Destruction** : 10% du prix d'achat récupéré

---

## 8. Matériel agricole

### 8.1 Familles
- Motorisés : tracteurs, télescopiques, moissonneuses, ensileuses, arracheuses...
- Travail du sol : cultivateurs, déchaumeurs, charrues, herses rotatives...
- Semis : semoirs, semoirs maïs/betterave, planteuses...
- Traitement : épandeurs engrais, pulvérisateurs...
- Transport : bennes, plateaux, bétaillères, utilitaires, vans...
- Coupe : faucheuses, faneuses, andaineurs...
- Pressage : presses balles carrées/rondes, enrubanneuses...

### 8.2 Caractéristiques
- **Puissance requise** : chaque outil nécessite un tracteur assez puissant
- **Maniabilité** (1-5) : bonus/malus PA selon taille parcelle
- **Usure** : quotidienne, plus rapide si non abrité
- **Entretien** : 1 PA/mois
- **Pannes** : probabilité liée à l'usure, immobilisation jusqu'à 2 jours
- **Assurance** : annuelle, couvre les réparations
- **Pièces détachées** : 1-5 pièces par matériel, remplacement selon utilisation PA
- **Consommation HVC** : trajet (0.05L/CV/PA) + travail (0.08-0.20L/CV/PA)

### 8.3 GPS
- Récepteur GPS (3000€) installé par atelier concessionnaire
- Balises GPS par zone (20 000€/balise)
- Abonnement annuel 400-600€/balise
- Gains : PA, économie semences/engrais/traitements

### 8.4 Combinés
Attelage avant+arrière pour actions multiples en 1 passage (ex: déchaumer+semer).

### 8.5 Achat/Vente
- Neuf chez concessionnaire ou occasion entre joueurs
- Argus pour estimation
- Achat en commun (jusqu'à 5 joueurs, même région)
- Annonce : 1500€

---

## 9. Activités annexes

### 9.1 Concessionnaire
- Condition : 90 jours d'ancienneté + SimPass
- Hall de vente (200m²), vendeurs, licences constructeurs (100 points)
- Droits d'entrée + reversement CA annuel
- Atelier : mécaniciens (compétences 1-10, retraite à 60 ans), entretien, dépannage
- Dépôt-vente, location tracteurs, pièces détachées
- Réseau GPS (balises + récepteurs)

### 9.2 Transporteur
- Camions + chauffeurs
- Licences de transport
- Transport marchandises, matériel, animaux

### 9.3 Centre d'Insémination Artificielle (CIA)
- Mâles reproducteurs
- Prélèvements, contrats, inséminations

### 9.4 Coopérative Agricole Régionale (CAR)
- Associés multiples
- Contrats parcelles, achats/ventes groupés
- Emprunts, parts sociales
- Magasin libre-service
- Huilerie, sucrerie, laiterie
- Méthanisation (substrats → digesteur → biogaz → électricité/HVC)

### 9.5 Fromagerie
- Types : fermière, artisanale, industrielle
- Hygiène/propreté, matériel spécifique
- Fromagers (personnel)
- Fabrication, affinage, DLC
- Crème et beurre
- Vente sur marchés

### 9.6 Maraîchage
- Serres (plastique/verre), chauffage (chaudière polycombustible)
- Personnel spécialisé
- Cultures légumières
- Vente sur marchés

### 9.7 Foie gras
- Bâtiments spécifiques
- Races oies/canards concernées
- Cycle : élevage → gavage → abattage → commercialisation

### 9.8 Viticulture
- Domaine viticole
- Cépages, vendanges, vinification
- Assemblage, mise en bouteille/fût
- Qualité du vin, concours

### 9.9 Activité forestière
- Forêt, station forestière
- Travaux forestiers
- Entreprise de Travaux Forestiers (ETF)
- Vente de bois

### 9.10 ETA (Entreprise de Travaux Agricoles)
- Proposer ses services aux autres joueurs
- Travaux dans leurs parcelles

### 9.11 Haies
- Plantation d'arbustes en bordure de parcelle
- Taille → bois coupé → déchiquetage → litière ou chauffage serre
- Bonus rendement cultures et réduction maladies
- Réduction besoin eau animaux au pré

### 9.12 Méthanisation à la ferme
- Substrats : fumier, lisier, maïs ensilé, paille vrac, céréale immature, herbe ensilée
- Digesteur → biogaz → électricité (vente réseau) + HVC (carburant)
- Digestat solide/liquide (épandage engrais)
- Panne et usure du digesteur

---

## 10. Économie

### 10.1 Marché
- Prix dynamiques selon offre/demande
- Vente à la coopérative SimAgri ou CAR
- Vente directe entre joueurs (annonces)
- Marchés (fromagerie, maraîchage)
- Grossistes et centrales d'achat
- Filière pomme de terre (stockage + commercialisation)
- Organisme Partcel (vente parcelles, BIO +50%)

### 10.2 Finances
- Compte bancaire + épargne
- Emprunts (via CAR)
- Charges : carburant HVC, électricité, alimentation, entretien, salaires
- Revenus : ventes productions, services

### 10.3 Parcelles
- Achat à SimAgri, joueurs, ou organisme Partcel
- Prix/ha variable par pays (3000-7000€)
- Taxe plus-value à la revente (50-90% selon durée détention)
- Location possible

### 10.4 Monnaie
Euro (€)

---

## 11. Social

- Forum intégré
- Messagerie + MP-Live
- Amis / amis privilégiés
- CFSA (mentorat)
- Conseil Économique SimAgri (CESA)
- Annonces
- Statistiques / classements
- Concours animaux (GénétiSim)
- Concours vins
- Salons (GénétiSim, VitiSim, GénétiVRAD)
- Badges et challenges
- Sondages
- Fiche présentation joueur / Carte ISO
- Disponibilité joueur
- Favoris
- Préférences notifications et activité
- Événements in-game

---

## 12. Monétisation (original)

- Inscription gratuite
- **SimPass** : abonnement trimestriel (~2€), débloque fonctionnalités avancées
- Packs et options payantes
- Parrainage

---

## 13. Données techniques originales

- Développeur : EXPONE (France)
- Stack : PHP/MySQL, Apache/Debian
- Domaine : simagri.com (créé 23/12/2004)
- Hébergement : OVH, IP 194.146.227.150
- Encodage : ISO-8859-1
- jQuery 1.9, Bootstrap, FontAwesome
