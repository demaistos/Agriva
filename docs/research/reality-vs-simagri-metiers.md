# Réalité des métiers annexes agricoles en France (2024-2026) vs Modèle SimAgri

> **Document de recherche Agriva** — Analyse comparant les activités de diversification et métiers para-agricoles français au modèle SimAgri, avec recommandations pour Agriva.
>
> Date : Août 2026
> Sources : FNEDT, CNEAP, Coop de France, FNPL, APCA, MSA, RGA 2020

---

## Table des matières

1. [ETA (Entreprise de Travaux Agricoles)](#1-eta-entreprise-de-travaux-agricoles)
2. [Concessionnaire](#2-concessionnaire)
3. [Transport agricole](#3-transport-agricole)
4. [Fromagerie](#4-fromagerie)
5. [Maraîchage](#5-maraîchage)
6. [Méthanisation et énergies renouvelables](#6-méthanisation-et-énergies-renouvelables)
7. [Transformation et circuits courts](#7-transformation-et-circuits-courts)
8. [Coopératives (CAR) et CIA](#8-coopératives-car-et-cia)
9. [TOP 10 des différences + TOP 10 des ajouts + Synthèse](#9-synthèse)

---

## 1. ETA (Entreprise de Travaux Agricoles)

### 1.1 RÉALITÉ terrain 2024 (France)

#### Le métier d'ETA

- **25 000 ETA** en France (2024), dont 15 000 "pures" (pas exploitants agricoles)
- **CA du secteur** : 8-10 milliards €/an
- **Emploi** : 80 000 salariés permanents + saisonniers
- **Part du marché** : 30-40% des travaux agricoles réalisés par des ETA
- **Tendance** : en forte croissance (exploitations plus grandes + moins d'agriculteurs)

#### Services proposés

| Service | Part de l'activité ETA | Prix moyen 2024 |
|---------|:---------------------:|:---------------:|
| Moisson (MB + charroi) | 25-30% | 100-150 €/ha |
| Ensilage (ensileuse + charroi) | 15-20% | 40-55 €/t MS |
| Travail du sol (labour, déchaumage) | 15-20% | 50-140 €/ha |
| Semis | 10% | 50-90 €/ha |
| Épandage (fumier, lisier) | 10% | 3-6 €/m³ lisier, 5-10 €/t fumier |
| Pulvérisation | 5% | 15-25 €/ha |
| Pressage | 5% | 8-15 €/balle |
| Arrachage (betterave, PDT) | 5% | 200-400 €/ha |

#### Modèle économique

- **Tarification** : au ha, à la tonne, ou à l'heure (30-150 €/h selon matériel)
- **Investissement** : 500 000-3 000 000 € en matériel (moissonneuses, ensileuses, tracteurs)
- **Seuil de rentabilité** : 500-1000 ha de prestation/an pour une moissonneuse
- **Marge** : 10-25% (très variable selon l'utilisation et la concurrence locale)
- **Saisonnalité** : très concentré (moisson = 3-4 semaines, ensilage = 2-3 semaines)

#### Avantages pour le client agriculteur

- **0 investissement matériel** (la moissonneuse = 300-900 k€)
- **Professionnalisme** : matériel récent, chauffeur expérimenté
- **Rapidité** : gros matériel = débit supérieur
- **Risque** : pas de panne, pas d'entretien, pas d'immobilisation

#### Inconvénients

- **Disponibilité** : en pointe, l'ETA est débordée (risque d'attente)
- **Pas de contrôle** : réglages, dates → l'ETA décide quand elle vient
- **Dépendance** : si l'ETA est en retard, le grain germe ou la betterave pourrit
- **Coût** : plus cher au ha que le matériel propre (si surfaces suffisantes)

### 1.2 Modèle SimAgri

- **ETA** : le joueur propose ses services aux autres joueurs
- **Table `eta_services`** : service, prix/ha, matériel utilisé, région
- **Table `eta_orders`** : commandes des clients
- **Mécanique** : le prestataire utilise ses PA et son HVC, le client paie €/ha
- **Pas de file d'attente** : le service est instantané (pas de planning)
- **Pas de disponibilité limitée** : le joueur peut tout faire tant qu'il a des PA

### 1.3 Comparaison

| Aspect | Réalité | SimAgri | Écart |
|--------|---------|---------|-------|
| ETA comme métier | 25 000 entreprises, 80k emplois | Joueur avec matériel propose ses services | Correct (simplifié) |
| Tarification | €/ha, €/t, €/h | €/ha (prix libre) | ✅ Correct |
| File d'attente / planning | Oui, pointe = embouteillage | Instantané | Moyen |
| Matériel de pointe | Gros matériel (classe 8+, 12m) | Matériel du joueur | Simplifié OK |
| Disponibilité | Limitée en pointe | Illimitée (tant qu'il y a des PA) | Moyen |
| Relation client | Contrat annuel, fidélisation | Commande ponctuelle | Acceptable |
| Client = non-équipé | Client n'a pas de moissonneuse | Client peut tout avoir | Le client DEVRAIT ne pas avoir le matériel |

### 1.4 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Garder** : joueur propose prestation à prix libre (bon mécanisme)
- **Alternative à l'achat** : le client commande une prestation S'IL N'A PAS le matériel
- **Prix benchmark** : afficher un prix de référence (ETA standard du serveur)

#### Priorité 2 (V2)
- **File d'attente** : en pointe (moisson), l'ETA doit prioriser ses clients
- **Contrat annuel** : fidélisation (prix garanti si contrat préalable)
- **Disponibilité limitée** : le joueur ETA a un nombre max de clients/jour

#### Priorité 3 (V3)
- **ETA PNJ** : si aucun joueur n'offre le service, un PNJ le propose (prix élevé)
- **Qualité de prestation** : expérience du chauffeur → moins de pertes
- **Spécialisation** : bonus si l'ETA investit dans du gros matériel récent

---

## 2. Concessionnaire

### 2.1 RÉALITÉ terrain 2024 (France)

#### Le réseau de concessions agricoles

- **2 500 points de vente** en France
- **Emploi** : 25 000-30 000 salariés
- **CA du secteur** : 15-18 milliards €/an (matériel neuf + occasion + pièces + service)
- **Concentration** : consolidation rapide (groupes multi-sites : Sévérac, Euro Nord, Barbot, Maximo)

#### Structure d'une concession type

| Service | Part du CA | Marge |
|---------|:----------:|:-----:|
| Vente neuf | 55-65% | 5-10% |
| Vente occasion | 15-20% | 10-15% |
| Atelier (service) | 10-15% | 60-80 €/h MO |
| Pièces détachées | 8-12% | 25-40% |
| Location | 2-5% | 15-25% |
| Financement (commission) | 1-2% | Variable |

#### Marques et réseaux

| Groupe constructeur | Marques | Part France |
|--------------------|---------|:-----------:|
| John Deere & Co | John Deere | 22-25% |
| AGCO | Fendt, Massey Ferguson, Valtra | 25-28% |
| CNH Industrial | New Holland, Case IH | 18-22% |
| Claas | Claas | 8-10% |
| SDF | Deutz-Fahr, Same | 5-6% |
| Kubota | Kubota | 5-7% |

#### Atelier et SAV

- **Tarif MO** : 60-90 €/h (hors pièces)
- **Temps d'intervention** : 24-72h en saison, 1-2 semaines hors saison
- **Dépannage sur site** : véhicule atelier (intervention en champ)
- **Contrats d'entretien** : forfait annuel tout inclus (tendance croissante)
- **Formation constructeur** : techniciens certifiés (investissement annuel important)

#### Marché de l'occasion

- **75 000-100 000 transactions/an** en occasion
- **Reprise** : le concessionnaire reprend l'ancien matériel (argus - marge)
- **Garantie occasion** : 3-12 mois selon état
- **Plateformes** : Agriaffaires (n°1), Mascus, Le Bon Coin

### 2.2 Modèle SimAgri

- **Prérequis** : 90 jours d'ancienneté + SimPass
- **Hall de vente** : 200 m², vendeurs embauchés
- **Licences constructeurs** : 100 points répartis (droits d'entrée + reversement CA)
- **Atelier** : mécaniciens (compétences 1-10, spécialités, retraite 60 ans)
- **GPS** : balises 20k€/zone, récepteurs 2,5-3k€, abonnement 400-600€/an
- **Pièces** : magasin 20k€ + vendeur, marge 20-50%, remise clients fidèles 5-15%
- **Dépôt-vente** : matériel occasion en commission
- **Location** : tracteur si client en panne (±5CV, durée = immobilisation)
- **Relevage avant** : installation par mécanicien (5 PA, 150-300€)
- **Dépannage** : camion atelier pour intervention extérieure

### 2.3 Ce qui est CORRECT

- ✅ Concessionnaire = métier complet (pas juste vente mais services)
- ✅ Licences par marque (exclusivité)
- ✅ Atelier avec mécaniciens spécialisés (compétences variables)
- ✅ Dépôt-vente occasion (fonctionnement réel)
- ✅ GPS comme service additionnel (correct)
- ✅ Pièces détachées avec marge (le vrai business d'un concessionnaire)
- ✅ Fidélisation clients (remise si acheté en concession)
- ✅ Dépannage mobile (camion atelier)

**Note : c'est le métier le mieux modélisé de SimAgri (9/10).**

### 2.4 Ce qui est FAUX ou MANQUANT

| Élément | Problème | Impact gameplay |
|---------|----------|----------------|
| **Pas de financement** | En réalité le concessionnaire propose du crédit-bail/LOA | Manque une source de revenus |
| **Location très limitée** | Seulement en panne → en réalité : location courte durée | Service majeur absent |
| **Pas de formation technique** | Investissement en formation des mécaniciens | Les compétences sont figées |
| **Pas de saisonnalité SAV** | L'atelier explose en été/automne | Pas de pic de demande |
| **Pas de concurrence** | Peu de limites à la création de concessions | En réalité : territoire exclusif par marque |

### 2.5 RECOMMANDATION Agriva

#### Priorité 1 (V1)
- **Garder le modèle SimAgri** presque tel quel (excellent)
- **Territoire** : 1 concessionnaire par zone × marque (exclusivité)

#### Priorité 2 (V2)
- **Location courte durée** : service aux clients (pas seulement en panne)
- **Crédit-bail** : le concessionnaire propose du financement (commission)
- **Formation** : investir dans les compétences des mécaniciens (progression)
- **Saisonnalité** : plus de demandes atelier en été/automne → file d'attente

#### Priorité 3 (V3)
- **Contrats d'entretien** : forfait annuel tout inclus (revenus récurrents)
- **Matériel de démonstration** : prêt gratuit avant achat (fidélisation)
- **Concurrence entre concessions** : guerre des prix, fidélisation


---

## 3. Transport agricole

### 3.1 RÉALITÉ terrain 2024 (France)

#### Le métier de transporteur agricole

- **15 000 entreprises** de transport rural/agricole
- **Activités** : collecte céréales (moisson→silo), livraison aliments, animaux vivants, engrais/phytos, matériel
- **Réglementation** : permis C/CE, FIMO/FCO, capacité professionnelle transport
- **Tendance** : externalisation croissante (l'agriculteur transporte moins lui-même)

#### Flotte type

| Véhicule | Usage | Prix neuf |
|----------|-------|:---------:|
| Camion porteur 19-26 t | Livraison locale (30-50 km) | 80 000-150 000 € |
| Semi-remorque benne 38-44 t | Céréales coopérative/port | Tracteur 100k€ + semi 60k€ |
| Citerne alimentaire | Lait, huile, vin | 100 000-200 000 € |
| Bétaillère routière | Transport animaux vivants | 100 000-180 000 € |
| Porte-char | Transport matériel agricole | 60 000-100 000 € |

#### Tarification transport

| Trajet | Prix indicatif |
|--------|:-------------:|
| Ferme → coopérative locale (20 km) | 5-10 €/t |
| Coopérative → port export (100 km) | 12-20 €/t |
| Animaux (100 km) | 100-300 €/voyage |
| Matériel (porte-char, 50 km) | 200-500 €/voyage |
| Collecte lait (tournée quotidienne) | 15-30 €/1000L |

#### Spécificités

- **Collecte lait** : tous les 2-3 jours, citerne isotherme, tournée multi-fermes
- **Transport animaux** : réglementation bien-être animal (durée max, abreuvement)
- **Charroi moisson** : pic de 3 semaines, 16-20h/jour, besoin massif de camions
- **Logistique betterave** : 6 mois de campagne (sept→mars), camions en continu vers la sucrerie

### 3.2 Modèle SimAgri

- **Transporteur** : métier joueur avec camions + chauffeurs
- **Licences** de transport requises
- **8 types de semi-remorques** (plateau, benne, citerne, porte-engin, grumier, citerne pulvérulent, citerne agro, citerne lait)
- **Chauffeurs** : 25 PA/jour, salaire 1 400 €/mois
- **Consommation** : 24-28 L HVC/PA (camion)
- **Commandes** : clients passent des ordres de transport
- **Prix** fixé par le transporteur

### 3.3 Comparaison — Note : 7/10

- ✅ Diversité de semi-remorques (8 types = très complet)
- ✅ Métier de service entre joueurs (correct)
- ✅ Chauffeurs comme ressource humaine (PA)
- ⚠️ Pas de réglementation (permis, formation) — acceptable
- ⚠️ Pas de durée max transport animaux — acceptable
- ❌ Pas de collecte lait programmée (tournée quotidienne)
- ❌ Pas de charroi moisson (logistique de pointe saisonnière)

### 3.4 RECOMMANDATION Agriva

- **V1** : transport simplifié (benne, bétaillère, plateau — déjà dans le gameplay de base)
- **V2** : transporteur comme métier joueur (services aux autres)
- **V3** : logistique de collecte (lait quotidien, charroi moisson), contrats réguliers

---

## 4. Fromagerie

### 4.1 RÉALITÉ terrain 2024 (France)

#### La filière fromagère française

- **France = 1er producteur mondial de fromage de qualité** (1 200 variétés)
- **1,9 million de tonnes** de fromage/an (2024)
- **46 AOP fromagères** (dont Comté, Roquefort, Camembert, Reblochon...)
- **3 circuits** : industriel (75%), artisanal (15%), fermier (10%)

#### Fromagerie fermière

- **6 000-8 000 producteurs fermiers** en France
- **Lait propre** : le fermier transforme le lait de SA ferme uniquement
- **Investissement** : 30 000-100 000 € (local, matériel, affinage)
- **Production** : 50-500 fromages/jour (petite échelle)
- **Marge** : ×3-5 par rapport à la vente de lait brut
- **Contraintes** : normes sanitaires (agrément CE), temps de travail (traite + fabrication + vente)

**Rendements réels :**
| Type de fromage | Litres lait / kg fromage | Prix de vente |
|----------------|:------------------------:|:------------:|
| Pâte molle (type Camembert) | 7-8 L/kg | 10-20 €/kg |
| Pâte pressée (type Comté) | 10-12 L/kg | 15-30 €/kg |
| Pâte persillée (type Roquefort) | 10-12 L brebis/kg | 20-40 €/kg |
| Chèvre frais | 5-6 L/kg | 12-25 €/kg |
| Tomme | 8-10 L/kg | 12-20 €/kg |

**Affinage :**
- Pâte molle : 2-8 semaines
- Pâte pressée non cuite : 2-6 mois
- Pâte pressée cuite (Comté, Beaufort) : 6-24 mois
- Pâte persillée : 3-6 mois
- DLC : 14-60 jours après affinage (variable)

#### Commercialisation

- **Marché** : 40-50% des ventes (fromagerie fermière)
- **Vente à la ferme** : 20-30%
- **Épiceries fines / crémiers** : 15-20%
- **Restauration** : 5-10%
- **GMS** : rare en fermier (volume insuffisant)

### 4.2 Modèle SimAgri

- **3 types** : fermière (le joueur est fromager), artisanale (1 fromager employé), industrielle (2-10 fromagers)
- **Fromagers** : 6 compétences (emprésurage, découpe, moulage, égouttage, salage, affinage)
- **Fabrication** : lait → transformation (coût 0,09€/L) → fromage (indices qualité)
- **Affinage** : durée variable, indices montent pendant l'affinage
- **DLC** : date limite de consommation → invendus = perdus
- **Vente** : marchés (fromagerie artisanale) ou grossistes/centrales (industrielle)
- **Sous-produits** : crème (0,0375 L/L lait) → beurre (0,48 kg/L crème)
- **Qualité du lait (QL)** : indice qui influence la qualité du fromage
- **Hygiène** : matériel et local doivent être entretenus

### 4.3 Comparaison — Note : 8/10

- ✅ 3 types de fromagerie (fermière/artisanale/industrielle) — excellent
- ✅ Compétences fromagers (6 axes) — très détaillé et ludique
- ✅ Affinage avec durée variable et maturation des indices — réaliste
- ✅ DLC comme contrainte de gestion — tension gameplay forte
- ✅ Sous-produits (crème, beurre) — correct
- ✅ Qualité du lait → qualité du fromage — réaliste
- ✅ Marchés comme canal de vente — correct
- ⚠️ Pas de distinction AOP / générique — manque la survaleur qualité
- ⚠️ Pas de caves d'affinage comme investissement — simplifié
- ❌ Fromagers aux compétences fixes (pas d'apprentissage réaliste)

### 4.4 RECOMMANDATION Agriva

- **V1** : garder l'essentiel SimAgri (transformation lait → fromage → vente)
- **V2** : AOP = contraintes + survaleur, caves d'affinage, progression compétences
- **V3** : concours fromagers (classement), variétés régionales, export

---

## 5. Maraîchage

### 5.1 RÉALITÉ terrain 2024 (France)

#### La filière maraîchère

- **25 000 exploitations** maraîchères en France
- **Surface** : 140 000 ha de légumes (dont 5 000 ha sous abri)
- **Production** : 5,5 millions de tonnes/an
- **Emploi** : très intensif en main d'œuvre (5-15 UTH/ha sous abri)
- **Taux d'auto-approvisionnement** : 60% (import Espagne, Maroc, Pays-Bas)

#### Types de maraîchage

| Type | Surface | Investissement | Cultures | Commercialisation |
|------|:-------:|:--------------:|----------|-------------------|
| Plein champ industriel | 10-100 ha | Modéré | Carotte, oignon, poireau, chou | GMS, industrie |
| Sous abri chauffé | 0,5-5 ha | Très élevé (500-1000k€/ha) | Tomate, concombre, poivron | GMS, marché |
| Sous abri froid (tunnel) | 1-10 ha | Modéré (50-150k€/ha) | Salade, fraise, courgette | Circuit court |
| Diversifié bio | 1-5 ha | Faible-modéré | 30-50 espèces | AMAP, marchés, vente ferme |

#### Économie maraîchère

- **CA/ha** : 30 000-150 000 €/ha (vs 1 500-2 500 €/ha en grandes cultures)
- **Charges/ha** : 20 000-120 000 €/ha (main d'œuvre = 40-60%)
- **Marge** : très variable (1 000-50 000 €/ha net)
- **Main d'œuvre** : poste n°1 (récolte manuelle, soins quotidiens)
- **Énergie** : poste n°2 sous abri chauffé (gaz, bois, géothermie)
- **Investissement serres** : 50 000-1 000 000 €/ha selon technologie

#### Commercialisation

- **Circuit court** : 50-60% en bio/diversifié (marchés, AMAP, vente ferme)
- **GMS** : 30-40% en conventionnel (contrats, cahiers des charges)
- **Export** : marginal (sauf endive, carotte)
- **Prix très volatils** : tomate 0,50-3,00 €/kg selon saison et volume

### 5.2 Modèle SimAgri

- **Serres** : plastique ou verre, chauffage (chaudière polycombustible)
- **Personnel** : employés spécialisés
- **Cultures légumières** : variété de légumes
- **Vente sur marchés** : jours fixes, demande variable
- **Chauffage** : bois déchiqueté (haies) ou combustible acheté

### 5.3 Comparaison — Note : 6/10

- ✅ Serres comme investissement (correct)
- ✅ Chauffage comme coût d'exploitation (correct)
- ✅ Vente sur marchés (réaliste pour le maraîchage)
- ✅ Main d'œuvre spécialisée (correct)
- ⚠️ Pas de saisonnalité de culture (plein champ vs abri)
- ⚠️ Pas de distinction bio/conventionnel en maraîchage
- ❌ Pas de diversité de cultures détaillée
- ❌ Pas de plein champ industriel (seulement sous abri)
- ❌ Pas de prix très volatils (le légume = marché au jour le jour)

### 5.4 RECOMMANDATION Agriva

- **V1** : pas prioritaire (maraîchage = niche, arrivera en phase tardive)
- **V2** : serres + cultures sous abri + vente marchés (gameplay circuit court)
- **V3** : plein champ, AMAP, saisonnalité, variétés, bio maraîcher


---

## 6. Méthanisation et énergies renouvelables

### 6.1 RÉALITÉ terrain 2024 (France)

#### Méthanisation agricole

- **1 200 unités** de méthanisation agricole en France (2024), objectif 2 500 en 2030
- **Investissement** : 500 000 € (micro-métha 50 kW) à 5 000 000 € (grosse unité 500 kW)
- **Modèles** : injection biométhane réseau (65%) ou cogénération électricité/chaleur (35%)
- **Revenu** : 80 000-250 000 €/an net (contrat 15-20 ans, tarif garanti)

**Substrats :**
| Substrat | Part dans les intrants | Pouvoir méthanogène |
|----------|:---------------------:|:-------------------:|
| Effluents d'élevage (fumier, lisier) | 40-60% | Faible (mais gratuit) |
| CIVE (Cultures Intermédiaires à Vocation Énergétique) | 15-25% | Moyen |
| Résidus de cultures (paille, menues pailles) | 5-10% | Faible |
| Déchets IAA | 10-20% | Élevé |
| Cultures dédiées (maïs ensilé) | 0-15% (plafonné) | Élevé |

**Produits :**
- **Biogaz** → injection réseau (biométhane) ou cogénération (électricité + chaleur)
- **Digestat** : résidu fertilisant (N, P, K conservés), remplace l'engrais chimique
- **Chaleur** : récupérable pour séchage, serres, bâtiments

**Économie d'une unité type (150 kW cogé) :**
| Poste | Montant/an |
|-------|:----------:|
| Recettes électricité | 180 000-250 000 € |
| Recettes chaleur | 20 000-40 000 € |
| Économie engrais (digestat) | 10 000-30 000 € |
| **Total recettes** | **210 000-320 000 €** |
| Charges exploitation | 80 000-120 000 € |
| Annuités (emprunt 15 ans) | 80 000-150 000 € |
| **Revenu net** | **50 000-150 000 €** |

#### Autres énergies renouvelables à la ferme

| Technologie | Investissement | Revenu annuel | ROI |
|-------------|:--------------:|:------------:|:---:|
| Photovoltaïque toiture (100 kWc) | 80 000-120 000 € | 10 000-15 000 € | 7-10 ans |
| Photovoltaïque au sol (1 MWc) | 700 000-1 000 000 € | 80 000-120 000 € | 8-12 ans |
| Éolien (petit, <36 kW) | 50 000-150 000 € | 5 000-15 000 € | 10-15 ans |
| Bois-énergie (chaufferie) | 30 000-100 000 € | Économie fuel 10-30k€ | 5-8 ans |
| Agrivoltaïsme (panneaux + culture) | 100 000-200 000 €/ha | 15 000-30 000 €/ha | 7-12 ans |

### 6.2 Modèle SimAgri

- **Méthanisation CAR** : substrats → digesteur → biogaz → électricité + HVC + digestat
- **Méthanisation ferme** : unité individuelle (même principes)
- **Substrats** : fumier, lisier, maïs ensilé, paille vrac, céréale immature, herbe ensilée
- **Panne et usure** du digesteur (entretien nécessaire)
- **Pas de photovoltaïque, pas d'éolien, pas de bois-énergie**

### 6.3 Comparaison — Note : 7/10

- ✅ Méthanisation bien modélisée (substrats, produits, panne/usure)
- ✅ Double voie : CAR collective ou individuelle
- ✅ Digestat comme engrais organique
- ✅ Lien élevage → substrats → énergie (synergie réaliste)
- ⚠️ Pas de contrat tarif garanti (15-20 ans en réalité)
- ❌ Photovoltaïque absent (revenu complémentaire n°1 des fermes 2024)
- ❌ Pas d'investissement modulable (1 seule taille de digesteur ?)
- ❌ Pas de CIVE (Culture Intermédiaire à Vocation Énergétique)

### 6.4 RECOMMANDATION Agriva

- **V1** : pas prioritaire (la méthanisation arrivera en phase tardive avec les effluents)
- **V2** : méthanisation ferme = investissement lourd + revenu stable + gestion effluents
- **V2** : photovoltaïque = investissement simple + revenu passif (toiture bâtiments)
- **V3** : CIVE, agrivoltaïsme, chaufferie bois, vente chaleur

---

## 7. Transformation et circuits courts

### 7.1 RÉALITÉ terrain 2024 (France)

#### Diversification à la ferme

- **25% des exploitations** pratiquent au moins une activité de diversification
- **Activités principales** :

| Activité | Part des exploitations | Revenu additionnel |
|----------|:---------------------:|:------------------:|
| Vente directe (tous produits) | 15-20% | 10 000-50 000 €/an |
| Transformation à la ferme | 8-10% | 15 000-60 000 €/an |
| Hébergement/agritourisme | 5-8% | 5 000-30 000 €/an |
| Production d'énergie (PV, métha) | 8-12% | 10 000-100 000 €/an |
| Travail à façon (ETA) | 5-8% | 10 000-40 000 €/an |
| Entretien espaces verts/communaux | 3-5% | 5 000-15 000 €/an |

#### Transformation à la ferme (hors fromagerie)

| Produit | Matière première | Investissement | Marge vs brut |
|---------|-----------------|:--------------:|:------------:|
| Jus de pomme | Pommes (verger) | 10 000-50 000 € | ×3-5 |
| Viande (caissettes) | Bovins, ovins, porcs | 20 000-80 000 € (atelier découpe) | ×2-3 |
| Foie gras | Canards/oies | 30 000-100 000 € | ×3-5 |
| Huile (colza, tournesol) | Graines oléagineuses | 20 000-50 000 € | ×2-4 |
| Farine | Blé | 30 000-80 000 € (moulin) | ×3-5 |
| Bière | Orge (malterie micro) | 50 000-200 000 € | ×5-10 |
| Confiture | Fruits | 5 000-20 000 € | ×3-6 |

#### Agritourisme

- **Gîtes/chambres d'hôtes** : 50 000-200 000 € d'investissement, 10 000-40 000 €/an
- **Ferme pédagogique** : 20 000-50 000 €, 5 000-20 000 €/an + image
- **Camping à la ferme** : 10 000-50 000 €, 5 000-15 000 €/an
- **Restaurant de ferme** : investissement lourd, réglementation complexe

### 7.2 Modèle SimAgri

- **Fromagerie** : transformation lait → fromage (détaillée, cf. section 4)
- **Huilerie** (CAR) : colza → huile → HVC
- **Sucrerie** (CAR) : betterave → sucre + écume
- **Laiterie** (CAR) : collecte + transformation lait
- **Foie gras** : élevage oies/canards → gavage → abattage → commercialisation
- **Viticulture** : domaine, cépages, vinification, assemblage, mise en bouteille/fût
- **Pas de vente directe** (hors marchés fromagerie/maraîchage)
- **Pas d'agritourisme**
- **Pas de transformation viande (caissettes)**
- **Pas de bière/jus/confiture**

### 7.3 Comparaison — Note : 5/10

- ✅ Fromagerie excellente (cf. section 4)
- ✅ Viticulture modélisée (domaine complet)
- ✅ Foie gras (niche française unique)
- ✅ Huilerie/sucrerie via CAR (transformation collective)
- ⚠️ Pas de vente directe généralisée (seulement marchés spécialisés)
- ❌ Pas de caissettes viande (circuit court n°1 en élevage allaitant)
- ❌ Pas d'agritourisme (gîtes, ferme pédagogique)
- ❌ Pas de transformation céréales (farine, bière)
- ❌ Pas de jus/confiture (vergers → transformation)

### 7.4 RECOMMANDATION Agriva

- **V1** : pas de transformation (hors fromage si implémenté)
- **V2** : vente directe viande (caissettes), fromage fermier, jus de fruits
- **V3** : agritourisme (gîte = revenu passif), bière/vin, magasin de producteurs

---

## 8. Coopératives (CAR) et CIA

### 8.1 RÉALITÉ terrain 2024 (France)

#### Coopératives — rappel économique (cf. section 2 du doc économie)

Ici on se concentre sur la **CAR comme métier jouable** (structure multi-joueurs).

**Coopérative polyvalente réelle (type Terrena, Agrial) :**
- **Collecte** : silos de zone, séchage, stockage, vente groupée
- **Approvisionnement** : intrants à prix négocié pour les adhérents
- **Transformation** : laiterie, sucrerie, abattoir, malterie
- **Distribution** : magasins agricoles (Gamm Vert = Invivo)
- **Services** : conseil, assurance, financement, formation
- **Gouvernance** : 1 homme = 1 voix, assemblée générale, conseil d'administration

#### Centre d'Insémination (CIA) — réalité

- **7 CIA majeurs** en France : Évolution (n°1), Gènes Diffusion, Auriva-Élevage, ELVA, Umotest...
- **Fusion/consolidation** rapide (2024 : Évolution = 55% du marché bovin)
- **Services** : collecte semence, évaluation génomique, vente de doses, insémination sur ferme
- **Prix des doses** : 15-120 € (bovin), variable selon index du taureau
- **Techniciens** : 3 000 inséminateurs en France (tournées quotidiennes)
- **Tendance** : auto-insémination en hausse (formation CFPPA obligatoire)

### 8.2 Modèle SimAgri

**CAR :**
- Multi-associés (parts sociales, rôles)
- Magasin libre-service
- Contrats parcelles
- Emprunts aux membres
- Sous-activités : huilerie, sucrerie, laiterie, méthanisation
- Achats/ventes entre CAR

**CIA :**
- Mâles reproducteurs avec indices génétiques
- Prélèvements → doses
- Catalogue visible par les éleveurs
- Contrats avec éleveurs
- Prix par dose variable selon qualité génétique

### 8.3 Comparaison

**CAR — Note : 8/10**
- ✅ Structure multi-joueurs avec parts sociales — excellent
- ✅ Sous-activités de transformation (huilerie, sucrerie, laiterie) — réaliste
- ✅ Emprunts aux membres — rôle bancaire de la coopérative
- ✅ Magasin libre-service — distribution aux adhérents
- ⚠️ Pas de collecte/stockage céréales comme activité principale
- ⚠️ Pas de ristourne en fin d'exercice
- ❌ Pas de gouvernance réelle (vote AG, budget)

**CIA — Note : 7/10**
- ✅ Catalogue de mâles avec indices génétiques — correct
- ✅ Doses vendues aux éleveurs — correct
- ✅ Contrats — relation durable
- ⚠️ Pas d'évaluation génomique (progéniture)
- ⚠️ Pas de technicien inséminateur (intervient à distance implicitement)

### 8.4 RECOMMANDATION Agriva

- **V1** : coopérative PNJ (achat/vente simplifié) — pas de structure multi-joueurs en V1
- **V2** : CAR multi-joueurs (structure coopérative avec gouvernance)
- **V2** : CIA = catalogue de doses (existant SimAgri = bon à garder)
- **V3** : gouvernance CAR (vote, budget, dividendes), collecte céréales, ristourne


---

## 9. Synthèse

### TOP 10 des différences majeures réalité vs SimAgri (métiers annexes)

| # | Différence | Impact |
|:-:|-----------|:------:|
| 1 | **Pas de vente directe viande (caissettes)** — circuit court n°1 en élevage allaitant | 🔴 |
| 2 | **Pas de photovoltaïque** — revenu passif n°1 des fermes 2024 | 🔴 |
| 3 | **Pas d'agritourisme** (gîtes, ferme pédagogique) — 8% des exploitations | 🟠 |
| 4 | **ETA sans file d'attente** — pas de contrainte de disponibilité en pointe | 🟠 |
| 5 | **Concessionnaire sans location courte durée** — service majeur absent | 🟠 |
| 6 | **Fromagerie sans AOP** — pas de survaleur qualité, pas de terroir | 🟠 |
| 7 | **Pas de collecte céréales par la CAR** — activité principale d'une coopérative | 🟡 |
| 8 | **Maraîchage sans saisonnalité** — le légume = marché au jour le jour | 🟡 |
| 9 | **Méthanisation sans contrat tarif garanti** — le revenu est sécurisé 15-20 ans | 🟡 |
| 10 | **Pas de CIVE** (culture intermédiaire énergie) — lien cultures ↔ méthanisation | 🟡 |

### TOP 10 des ajouts prioritaires pour Agriva

| # | Ajout | Phase | Impact | Complexité |
|:-:|-------|:-----:|:------:|:----------:|
| 1 | **ETA comme alternative à l'achat de matériel** | V1 | ★★★★★ | ★☆☆ |
| 2 | **Photovoltaïque toiture** (revenu passif) | V2 | ★★★★☆ | ★☆☆ |
| 3 | **Vente directe viande** (caissettes, circuit court) | V2 | ★★★★☆ | ★★☆ |
| 4 | **Concessionnaire joueur** (garder SimAgri) | V2 | ★★★★☆ | ★★★ |
| 5 | **Fromagerie fermière** (caprin/ovin) | V2 | ★★★★☆ | ★★☆ |
| 6 | **CAR multi-joueurs** (coopérative sociale) | V2-V3 | ★★★☆☆ | ★★★ |
| 7 | **Méthanisation ferme** | V3 | ★★★☆☆ | ★★☆ |
| 8 | **Location matériel** (concessionnaire) | V2 | ★★★☆☆ | ★★☆ |
| 9 | **Transport comme service** (joueur transporteur) | V3 | ★★★☆☆ | ★★★ |
| 10 | **Agritourisme** (gîte = revenu passif récurrent) | V3 | ★★☆☆☆ | ★★☆ |

### Tableau récapitulatif par métier — Note SimAgri

| Métier | Note /10 | Forces | Manque principal |
|--------|:--------:|--------|-----------------|
| **Concessionnaire** | 9/10 | Le plus complet (hall, atelier, GPS, pièces, dépôt-vente) | Location, crédit-bail |
| **Fromagerie** | 8/10 | Compétences fromagers, affinage, DLC, marchés | AOP, progression |
| **CAR** | 8/10 | Multi-joueurs, sous-activités, parts sociales | Collecte céréales, gouvernance |
| **Transport** | 7/10 | 8 semi-remorques, chauffeurs, commandes | Collecte lait, charroi moisson |
| **Méthanisation** | 7/10 | Substrats, biogaz, digestat, panne/usure | PV, CIVE, contrat garanti |
| **CIA** | 7/10 | Catalogue doses, indices, contrats | Évaluation génomique |
| **ETA** | 6/10 | Service joueur, prix libre | File d'attente, disponibilité |
| **Maraîchage** | 6/10 | Serres, chauffage, marchés | Saisonnalité, diversité cultures |
| **Viticulture** | 6/10 | Domaine, cépages, vinification | Simplifié (pas de détails AOC) |
| **Foie gras** | 5/10 | Cycle complet modélisé | Niche (peu de joueurs) |
| **Transformation** | 5/10 | Huilerie, sucrerie (CAR) | Caissettes, agritourisme, bière |

### Note globale métiers annexes : 7/10

**Verdict** : les métiers annexes sont le **point fort de SimAgri**. Le concessionnaire joueur est remarquable, la fromagerie est détaillée, la CAR offre un vrai gameplay social. C'est le domaine où SimAgri se différencie le plus des autres jeux agricoles.

**Ce qu'Agriva doit garder** : le modèle de concessionnaire joueur, la fromagerie, la structure CAR multi-joueurs.

**Ce qu'Agriva doit ajouter** : l'ETA comme alternative au matériel (V1), le photovoltaïque (V2), la vente directe viande (V2), et l'agritourisme (V3).

---

*Document complété le 4 août 2026. Prêt pour utilisation comme référence dans le game design des métiers annexes Agriva.*