# 03 — CONTENT DATA (Référence BDD)

> Fichier de référence pour peupler la base de données du jeu Cultivia.
> Source : `regle sim.txt` (20/04/2021) + GDD 00-05.

---

## 1. Bâtiments et Accessoires

### 1.1 Bâtiments (type b)

| Type | Unité | Usage |
|------|-------|-------|
| Hangar | m² | Ranger matériels, stocker paille/foin/semences/engrais/traitements |
| Stabulation | m² | Abriter bovins |
| Porcherie | m² | Abriter porcins |
| Chèvrerie | m² | Abriter caprins |
| Bergerie | m² | Abriter ovins |
| Poulailler | m² | Abriter volailles, pintades, oies, canards |
| Clapier | m² | Abriter lapins |
| Écurie | m² | Abriter chevaux |
| Entrepôt | m² | Stocker balles paille/foin, semences, engrais, traitements |
| Silo | tonne | Stocker récoltes (1 silo par type) |
| Fosse à fumier | tonne | Stocker fumier ou écume de sucrerie |
| Fosse à lisier | litre | Stocker lisier |
| Aire de chargement | m² | Stocker marchandise vendue pour camions |
| Silo de chargement | tonne | Stocker aliments vendus pour camions |
| Aire stockage paille/foin | m² | Stocker balles (légère perte) |
| Silo taupe | tonne | Stocker maïs ensilé sous bâche (légère perte) |

### 1.2 Accessoires (type a)

| Type | Unité | Usage |
|------|-------|-------|
| Cuve à lait | litre | Stocker/conserver lait |
| Cuve HVC | litre | Stocker bio-carburant |
| Salle de traite | nb postes | Traire bovins, caprins, ovins |
| Citerne à eau | litre | Stocker eau animaux |
| Bac à eau | litre | Eau animaux au pré/prairie boisée |
| Parc à volailles | m² | Élevage semi-liberté volailles/oies/canards |
| Parc et abri à porcins | nb abris | Élevage plein-air porcins (5 porcins/abri) |
| Salle de conditionnement | nb robots | Ramasser/conditionner œufs |
| Pièce stockage œufs | nb œufs | Stocker œufs conditionnés |
| Pièce stockage laine | kg | Stocker laine/duvet |
| Corral | unité | Regroupement bisons (1 par prairie boisée) |

### 1.3 Consommation énergétique

- Coût kWh : **0,08 €**
- 5 niveaux d'équipement (1 à 5, 5 = meilleur = moins de conso)
- Facteurs : niveau équipement, utilisation, usure, saison (surconsommation été/hiver)
- Bâtiment vide consomme quand même un peu
- Facture mensuelle Cultivia

### 1.4 Entretien et destruction

- Entretien mensuel : **0,3 HT** par bâtiment
- Destruction : récupération **10 %** du prix d'achat
- Pas de délai de construction pour les **10 premiers** bâtiments

---

## 2. Matériels

### 2.1 Catalogue complet

| Matériel | Utilisation | Cultures/Produits | Motorisé/Tracté |
|----------|-------------|-------------------|-----------------|
| Tracteur | Tracter matériels | — | Motorisé |
| Tracteur arboricole | Tracter matériels | Arboriculture | Motorisé |
| Broyeur de pierres | Broyer pierres | Toutes | Tracté |
| Cultivateur | Déchaumer | Toutes | Tracté |
| Épandeur à fumier | Épandre fumier | Toutes | Tracté |
| Tonne à lisier | Épandre lisier | Toutes | Tracté |
| Charrue | Labourer | Toutes | Tracté |
| Déchaumeur | Déchaumer | Toutes | Tracté |
| Herse rotative | Préparer terre | Toutes | Tracté |
| Semoir | Semer | Blé, Orge, Avoine, Triticale, Tournesol, Herbe, Colza, Pois, Lin | Tracté |
| Semoir maïs/betterave | Semer | Maïs ensilé, Maïs grain, Betterave | Tracté |
| Planteuse | Planter | Pomme de terre | Tracté |
| Butteuse | Butter | Pomme de terre | Tracté |
| Épandeur à engrais | Épandre engrais | Toutes (1-2 passages) | Tracté |
| Pulvérisateur | Traiter | Toutes (1-2 passages) | Tracté |
| Pulvérisateur automoteur | Traiter | Toutes (1-2 passages) | Motorisé |
| Pulvérisateur arboricole | Traiter | Arboriculture | Tracté |
| Moissonneuse batteuse | Moissonner | Blé, Orge, Avoine, Triticale, Colza, Pois, Tournesol, Maïs grain | Motorisé |
| Ensileuse | Ensiler | Maïs ensilé | Motorisé |
| Arracheuse betterave | Arracher | Betterave | Motorisé |
| Arracheuse pomme de terre | Arracher | Pomme de terre | Motorisé |
| Récolteuse haricot | Récolter | Haricot vert | Motorisé |
| Récolteuse épinard | Récolter | Épinard | Motorisé |
| Arracheuse lin | Arracher | Lin | Motorisé |
| Retourneuse lin | Retourner | Lin | Motorisé |
| Enrouleuse automotrice | Presser/enrouler | Lin | Motorisé |
| Presse balle carrée 500 kg | Presser | Blé, Orge, Avoine, Triticale, Pois, Herbe | Tracté |
| Presse balle carrée 250 kg | Presser | Blé, Orge, Avoine, Triticale, Pois, Herbe | Tracté |
| Presse balle ronde 300 kg | Presser | Blé, Orge, Avoine, Triticale, Pois, Herbe, Lin | Tracté |
| Presse enrubanneuse | Presser et enrubanner | Herbe | Tracté |
| Faucheuse | Faucher | Herbe (Pré) | Tracté |
| Faneuse | Faner | Herbe (Pré) | Tracté |
| Andaineur | Andainer | Herbe (Pré) | Tracté |
| Herse de prairie | Aérer | Herbe (Pré) | Tracté |
| Chargeur frontal | Charger | Balle et fumier | Accroché tracteur |
| Télescopique | Charger | Balle et fumier | Motorisé |
| Plateau | Transport | Balle, semence, engrais, traitement | Tracté |
| Benne | Transport | Récolte, aliment, fumier | Tracté |
| Désileuse | Nourrir animaux | — | Tracté |
| Pailleuse | Litière | Balle de paille | Tracté |
| Tonne à eau | Remplir bacs pré | — | Tracté |
| Enrouleur | Irriguer parcelles/vergers | — | Tracté |
| Pivot central | Irriguer parcelles | — | — |
| Rampe pivot | Irriguer parcelles | — | — |
| Enfonce pieux | Enfoncer pieux/piquets | Bisons | Tracté |
| Dérouleuse grillage | Pose clôture | Bisons | Tracté |
| Bétaillère | Transport | Bovins, bisons, caprins, porcins, ovins | Tracté |
| Utilitaire | Transport | Volailles, pintades, lapins | Motorisé |
| Van | Transport | Chevaux | Tracté par utilitaire |
| Rouleau | Passer le rouleau | Céréales et herbe | Tracté |

### 2.2 Entretien matériels

- Entretien mensuel : **1 HT** par matériel
- Usure quotidienne (plus rapide si non abrité sous hangar)
- Pièces détachées : 1 à 5 pièces par matériel, remplacement selon seuil HT

---

## 3. Combinés matériels

| Combiné | Avant (relevage) | Arrière | Puissance | Avantage |
|---------|-------------------|---------|-----------|----------|
| Semis Traditionnel | — | Herse rotative + semoir (≤6m, même largeur) | +50% puissance herse | 2 actions en 1 |
| Semis TCS | — | Herse rotative + semoir (≤6m, même largeur) | +50% puissance herse | 2 actions en 1 |
| Semis M/B (Trad./TCS) | — | Herse rotative + semoir M/B (≤6m) | +50% puissance herse | 2 actions en 1 |
| Traiter | Cuve frontale pulvé | Pulvérisateur porté | +10% | -25% HT Traiter |
| Faucher | Faucheuse frontale | Faucheuse portée simple/double | Faucheuse arrière | -50 à -60% HT Faucher |
| Labourer | Charrue frontale | Charrue portée (≤6 corps) | Charrue portée | -25% HT Labourer |
| Déchaumer/Semer | Cultivateur frontal | Herse rotative + semoir (≤6m) | +60% | 3 actions en 1 |
| Déchaumer/Semer M/B | Cultivateur frontal | Herse rotative + semoir M/B (≤6m) | +60% | 3 actions en 1 |
| Rouler/Semer (Trad.) | Rouleau frontal | Herse rotative + semoir (≤6m) | +60% | 3 actions en 1, +3 à +5% rendement |
| Herse/Cultivateur frontal (TCS) | Cultivateur frontal | Herse rotative (≤6m) | +60% | 2 actions en 1 |

---

## 4. Consommation HVC (bio-carburant)

### 4.1 Prix HVC

| Source | Prix/litre |
|--------|-----------|
| CAR | 0,36 à 0,55 € |
| Le Marché Central | 0,60 € |

### 4.2 Consommation par matériel motorisé

| Matériel | Trajet (L/CV/HT) | Action (L/CV/HT) |
|----------|------------------|------------------|
| Tracteur / tracteur arboricole | 0,05 | 0,08 à 0,200* |
| Moissonneuse batteuse | 0,05 | 0,125 |
| Ensileuse | 0,05 | 0,150 |
| Arracheuse betterave | 0,05 | 0,150 |
| Arracheuse pomme de terre | 0,05 | 0,150 |
| Arracheuse lin | 0,05 | 0,125 |
| Retourneuse lin | 0,05 | 0,125 |
| Enrouleuse automotrice | 0,05 | 0,125 |
| Pulvérisateur automoteur | 0,05 | 0,120 |
| Télescopique | 0,05 | 0,120 |
| Utilitaire | 0,11 | 0,11 |
| Tracteur routier | 24-28 L/HT | — |
| Abatteuse | 0,05 | 0,075 |
| Débusqueur | 0,05 | 0,060 |
| Porteur forestier | 0,05 | 0,070 |

> *Tracteur au travail : varie selon matériel tracté (ex: désileuse < charrue)

---

## 5. Cultures

### 5.1 Fiches cultures

| Culture | Semis | Récolte | Prix moyen (€/t) | Rotation | Semences/ha (kg) | Récolte par |
|---------|-------|---------|-------------------|----------|-------------------|-------------|
| Blé | Oct-Nov | Juil-Août | 100 | 1 an | 150 | Moissonneuse |
| Orge | Oct-Nov | Juin-Juil | 105 | 1 an | 150 | Moissonneuse |
| Orge de printemps | Fév-Mars | Juil-Août | 105 | 2 ans | 150 | Moissonneuse |
| Avoine | Oct-Nov | Juil-Août | 95 | 1 an | 150 | Moissonneuse |
| Avoine de printemps | Fév-Mars | Juil-Août | 95 | 2 ans | 150 | Moissonneuse |
| Triticale | Oct-Nov | Juil-Août | 125 | 1 an | 150 | Moissonneuse |
| Maïs grain | Avr-Mai | Oct-Nov | 110 | 2 ans | 25 | Moissonneuse |
| Maïs ensilé | Avr-Mai | Oct-Nov | 45 | 2 ans | 25 | Ensileuse |
| Sorgho ensilé | Avr-Mai | Sep-Oct | 50 | 2 ans | 12 | Ensileuse |
| Betterave | Mars-Avr | Oct-Nov | 120 | 4 ans | 150 | Arracheuse betterave |
| Colza | Août-Sep | Juin-Juil | 220 | 2 ans | 4 | Moissonneuse |
| Tournesol | Mars-Avr | Août-Sep | 230 | 3 ans | 150 | Moissonneuse |
| Pois | Fév-Mars | Juil-Août | 120 | 3 ans | 150 | Moissonneuse |
| Féverole | Nov-Déc | Juil-Août | 145 | 2 ans | 220 | Moissonneuse |
| Soja | Avr-Mai | Sep-Oct | 165 | 3 ans | 110 | Moissonneuse |
| Lin | Mars-Avr | Juil-Août | 1 300 | 6 ans | 120 | Arracheuse lin + retourneuse |
| Pomme de terre | Avr-Mai | Sep-Oct | 80 | 4 ans | 900 | Arracheuse PDT |
| Chanvre industriel | Mai | Sep | Graine 350 / Paille 120 | Non | 50 | Moissonneuse + faucheuse |
| Épinard | Août/Mars/Juin/Sep | Oct/Mai/Août/Avr | 120 | 3 ans | 150 | Récolteuse épinard |
| Haricot vert | Avr-Sep | Juin-Nov | 195 | 5 ans | 150 | Récolteuse haricot |
| Lentille | Avr-Mai | Août-Sep | 1 220 | 2 ans | 150 | Moissonneuse |
| Tabac | Mars(serre)/Avr-Mai | Juil-Sep | 4 500 | 3 ans | 35 000 graines | Manuel |
| Miscanthus | Avr-Mai | Fév-Mars | 75 | 20 saisons | 20 000 rhizomes | Ensileuse |
| Luzerne | Mars-Avr | Pousse 100% | 75 | 4 ans (3 coupes/an) | 25 | Ensileuse ou faucheuse |
| Herbe | Mars/Avr/Sep/Oct | Toute l'année | 70 (foin) | — | Variable* | Faucheuse+faneuse+andaineur |

> *Herbe : quantité semence variable selon espèce (voir section Graminées)

---

## 6. Rendements par région (T/ha)

### 6.1 Blé, Orge, Orge printemps, Avoine, Avoine printemps, Triticale

| Région | Blé (R1) | Orge (R1) | Orge P (R2) | Avoine (R1) | Avoine P (R2) | Triticale (R1) |
|--------|----------|-----------|-------------|-------------|----------------|----------------|
| **FRANCE** | | | | | | |
| Alsace | 7 | 6 | 4.6 | 4.2 | 4 | 6.2 |
| Aquitaine | 5.7 | 5.6 | 5 | 4.3 | 4.2 | 4.9 |
| Auvergne | 6.2 | 5.5 | 4.5 | 3.5 | 3.2 | 5.1 |
| Basse-Normandie | 8.1 | 6.9 | 5.8 | 5.9 | 5.7 | 6.4 |
| Bourgogne | 6.1 | 5.8 | 4.8 | 3.8 | 3.6 | 5 |
| Bretagne | 7.3 | 7 | 6.5 | 5.2 | 5.1 | 6.4 |
| Centre | 6.8 | 6.6 | 6.1 | 4.5 | 4.4 | 5.3 |
| Champagnes-Ardennes | 7.6 | 6.4 | 6.7 | 5.5 | 5.2 | 6.5 |
| Corse | 3.4 | 3 | 2.7 | 2.6 | 2.6 | 3.5 |
| Franche-Comté | 6 | 5.8 | 5 | 3.9 | 3.8 | 5.4 |
| Haute-Normandie | 8.4 | 7.7 | 7.3 | 6.3 | 6 | 7.1 |
| Ile-de-France | 7.7 | 7.1 | 6.5 | 5.9 | 5.6 | 6.2 |
| Languedoc-Roussillon | 4.8 | 4.6 | 3.5 | 3.3 | 3.2 | 3.9 |
| Limousin | 5.2 | 5.2 | 3.6 | 3.7 | 3.6 | 5.1 |
| Lorraine | 6.4 | 6 | 5.5 | 3.9 | 3.8 | 6.2 |
| Midi-Pyrénées | 5.6 | 5.1 | 4.1 | 3.3 | 3.2 | 4.6 |
| Nord | 8.6 | 7.9 | 8.4 | 6.3 | 6.2 | 7.3 |
| Pays de Loire | 7 | 6.4 | 5.3 | 5.4 | 5.3 | 5.8 |
| Picardie | 8.3 | 7.5 | 7.2 | 6.5 | 6.2 | 6.9 |
| Poitou-Charentes | 6.6 | 6.2 | 5.7 | 4.4 | 4.2 | 5.3 |
| PACA | 4 | 3.9 | 1.8 | 2.4 | 2.4 | 4 |
| Rhône-Alpes | 6 | 5.6 | 4.6 | 3.6 | 3.5 | 5.3 |
| **BELGIQUE** | | | | | | |
| Wallonie | 8.9 | 7.4 | 6.9 | 5.6 | 4.7 | 7 |
| Flandre | 9.1 | 7.2 | 6.7 | 5.7 | 4.8 | 7.2 |
| **SUISSE** | | | | | | |
| Suisse Romande | 5.9 | 5.8 | 5 | 5.1 | 4.8 | 5.7 |
| Suisse Alémanique | 6 | 5.9 | 5.2 | 5.3 | 5.1 | 6 |
| Suisse Italienne | — | 5.8 | 5.1 | — | — | 5.8 |

### 6.2 Maïs grain, Maïs ensilé, Betterave, Colza, Tournesol

| Région | Maïs G (R2) | Maïs E (R2) | Betterave (R4) | Colza (R2) | Tournesol (R3) |
|--------|-------------|-------------|----------------|------------|----------------|
| **FRANCE** | | | | | |
| Alsace | 10.8 | 13.1 | 75 | 3.7 | 2.5 |
| Aquitaine | 9 | 13.2 | — | 2.7 | 2.3 |
| Auvergne | 9.1 | 10.3 | 60 | 3 | 2.5 |
| Basse-Normandie | 8.6 | 13.6 | 80 | 3.7 | 2.5 |
| Bourgogne | 8.4 | 9.8 | 70 | 3 | 2.4 |
| Bretagne | 8.5 | 13.2 | — | 3.4 | 2.5 |
| Centre | 9.1 | 12.4 | 82 | 3.3 | 2.6 |
| Champagnes-Ardennes | 8.3 | 10.8 | 76 | 3.4 | 3.5 |
| Corse | 11.2 | 10 | — | — | 1.5 |
| Franche-Comté | 8.4 | 11 | — | 3.4 | 2.5 |
| Haute-Normandie | 9 | 14.7 | 90 | 3.9 | 2.8 |
| Ile-de-France | 9.2 | 10.9 | 75 | 3.6 | 2.8 |
| Languedoc-Roussillon | 9.4 | 8.6 | — | 2.8 | 2 |
| Limousin | 6.9 | 11.7 | — | 3.1 | 1.9 |
| Lorraine | 7.5 | 10.4 | 60 | 3 | 2.8 |
| Midi-Pyrénées | 9.7 | 11.6 | — | 2.9 | 2.1 |
| Nord | 9.4 | 15.1 | 90 | 3.9 | — |
| Pays de Loire | 8.5 | 12.4 | — | 3.7 | 2.6 |
| Picardie | 8.8 | 14.5 | 90 | 3.8 | 2.5 |
| Poitou-Charentes | 8.6 | 11 | 75 | 3.3 | 2.3 |
| PACA | 10.8 | 9.5 | — | 2.1 | 1.9 |
| Rhône-Alpes | 9.4 | 10.6 | — | 3.3 | 2.4 |
| **BELGIQUE** | | | | | |
| Wallonie | 14 | 15 | 85 | 3.5 | — |
| Flandre | 12.8 | 15.8 | 75 | — | — |
| **SUISSE** | | | | | |
| Suisse Romande | 8.8 | 15 | 63 | 3 | 2.8 |
| Suisse Alémanique | 9.2 | 15.5 | 66 | 3.2 | 3 |
| Suisse Italienne | 9 | 15 | — | — | — |

### 6.3 Pois, Féverole, Soja, Lin, Pomme de terre, Chanvre

| Région | Pois (R3) | Féverole (R2) | Soja (R3) | Lin (R6) | PDT (R4) | Chanvre (R1) G/P |
|--------|-----------|---------------|-----------|----------|----------|------------------|
| **FRANCE** | | | | | | |
| Alsace | 3.3 | 3 | 3.4 | — | 41.2 | — |
| Aquitaine | 3.5 | 2.3 | 2.6 | — | 33.9 | 0.8/7 |
| Auvergne | 2.9 | 2.5 | 2.5 | — | 29.7 | — |
| Basse-Normandie | 4.8 | 4.3 | — | 3.5 | 33.9 | — |
| Bourgogne | 3 | 3.2 | 2.6 | — | 36.4 | 0.8/7 |
| Bretagne | 4.2 | 4.2 | — | — | 24.6 | 0.8/7 |
| Centre | 4.6 | 3.5 | 2.2 | — | 48.2 | 0.8/7 |
| Champagnes-Ardennes | 4.6 | 4 | 2.2 | 3.3 | 50.5 | 0.8/7 |
| Corse | 2.5 | 2.5 | 1.3 | — | 9.2 | — |
| Franche-Comté | 2.8 | 2.9 | 2.5 | — | 27.2 | 0.8/7 |
| Haute-Normandie | 5 | 5 | — | 3.6 | 45.2 | — |
| Ile-de-France | 4.8 | 4 | 2.8 | 3.5 | 48 | 0.8/7 |
| Languedoc-Roussillon | 2.7 | 2.3 | 2.8 | — | 24.9 | — |
| Limousin | 2.8 | 3.1 | — | — | 28.2 | — |
| Lorraine | 4.1 | 3.2 | 2.3 | — | 38.1 | — |
| Midi-Pyrénées | 3.2 | 2 | 2.7 | — | 30.7 | 0.8/7 |
| Nord | 5.3 | 4.6 | — | 3.7 | 44.9 | — |
| Pays de Loire | 3.8 | 3.5 | 2.2 | — | 30.2 | 0.8/7 |
| Picardie | 5.2 | 4.3 | — | 3.4 | 44.5 | — |
| Poitou-Charentes | 4.3 | 2.9 | 2.3 | — | 26 | — |
| PACA | 2.1 | 2.6 | 2.6 | — | 30 | — |
| Rhône-Alpes | 3.2 | 2 | 3.1 | — | 28 | — |
| **BELGIQUE** | | | | | | |
| Wallonie | 3 | 3 | — | 3.2 | 47.5 | 0.8/7 |
| Flandre | 3 | 3 | — | 3.2 | 49 | 0.8/7 |
| **SUISSE** | | | | | | |
| Suisse Romande | 4.4 | 3.5 | 2.7 | — | 43 | 0.8/7 |
| Suisse Alémanique | 4.5 | 3.6 | 2.8 | — | 45 | 0.8/7 |
| Suisse Italienne | 4.5 | 3.5 | 2.7 | — | 44 | 0.8/7 |

### 6.4 Épinard, Haricot vert, Lentille, Sorgho ensilé, Tabac

| Région | Épinard (R2) | Haricot (R5) | Lentille (R2) | Sorgho E (R2) | Tabac (R3) |
|--------|-------------|-------------|---------------|---------------|------------|
| **FRANCE** | | | | | |
| Alsace | — | — | — | 8.8 | 2.7 |
| Aquitaine | — | 12 | — | 12.1 | 2.8 |
| Auvergne | — | — | 1.5 | 11 | 2.6 |
| Basse-Normandie | — | — | — | — | — |
| Bourgogne | — | 13 | 2.5 | 9.3 | — |
| Bretagne | 23 | 13 | — | — | 3 |
| Centre | 20 | 11 | 2.5 | 9.3 | 2.7 |
| Champagnes-Ardennes | 16 | 11 | 3.1 | — | 2.7 |
| Corse | — | — | — | — | — |
| Franche-Comté | — | 14 | — | 9.3 | 2.9 |
| Haute-Normandie | — | — | — | — | — |
| Ile-de-France | 15 | 13 | — | — | — |
| Languedoc-Roussillon | 15 | 13 | 1.6 | 11 | — |
| Limousin | — | — | — | 9.3 | 2.6 |
| Lorraine | — | — | — | 8.8 | — |
| Midi-Pyrénées | 12 | 11 | 1.5 | 10 | 2.6 |
| Nord | 23 | 15 | — | — | 2.3 |
| Pays de Loire | 12 | 13 | 1.9 | 10.5 | 2.7 |
| Picardie | 22 | 15 | — | — | 2.3 |
| Poitou-Charentes | — | 13 | 1.6 | 9.3 | 3 |
| PACA | 21 | 12 | — | 11 | — |
| Rhône-Alpes | 14 | 11 | — | 11 | 2.9 |
| **BELGIQUE** | | | | | |
| Wallonie | 22 | 12 | — | — | 3.8 |
| Flandre | 22 | 12 | — | — | 3.8 |
| **SUISSE** | | | | | |
| Suisse Romande | 13 | — | — | — | 2.1 |
| Suisse Alémanique | 13 | — | — | — | 1.9 |
| Suisse Italienne | 13 | — | — | — | — |

> **Note serveur Maîtrise** : composé de 2 régions imaginaires (Inorda, Isude). Les rendements spécifiques ne sont pas documentés dans les règles source.

---

## 7. Besoins nutritifs par culture (Kg/Tonne de rendement)

| Culture | N | P | K | Ca | Mg | S |
|---------|---|---|---|----|----|---|
| Blé | 20/30 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Orge | 18/24 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Orge de printemps | 18/24 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Avoine | 20/30 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Avoine de printemps | 20/30 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Triticale | 20/30 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Seigle | 20/30 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 4/6 |
| Maïs grain | 22/32 | 7/11 | 4/6 | 5/7 | 2/4 | 0 |
| Maïs ensilé | 10/16 | 5/7 | 12/16 | 3/5 | 2/4 | 0 |
| Betterave | 1/3 | 0.5/1.5 | 4/6 | 5/7 | 0.5/1.5 | 0.5/1.5 |
| Colza/Canola | 50/56 | 12/16 | 8/12 | 77/87 | 9/13 | 59/69 |
| Tournesol | 30/36 | 12/18 | 20/26 | 52/62 | 12/18 | 0 |
| Pois | 0 | 9/13 | 13/19 | 2/4 | 3/5 | 2/4 |
| Féverole | 0 | 9/13 | 13/19 | 2/4 | 3/5 | 2/4 |
| Soja | 66/76 | 12/18 | 46/56 | 41/51 | 11/15 | 0 |
| Lin | 4/6 | 2/4 | 2/4 | 2/4 | 1/3 | 1/3 |
| Pomme de terre | 3/5 | 1/3 | 7/11 | 1/3 | 0.5/1.5 | 0.5/1.5 |
| Chanvre industriel | 20/30 | 0.5/1.5 | 1/3 | 5/9 | 2/4 | 6/10 |
| Coton | 50/70 | 25/35 | 25/35 | 4/8 | 4/8 | 4/8 |
| Tabac | 70/90 | 40/60 | 40/60 | 9/15 | 12/18 | 10/16 |
| Épinard | 3/5 | 1/3 | 7/11 | 0.5/1.5 | 0.5/1.5 | 0.5/1.5 |
| Haricot vert | 7/11 | 2/4 | 8/12 | 1/3 | 1/3 | 1/3 |
| Lentille | 8/12 | 5/7 | 7/9 | 3/5 | 3/5 | 2/4 |
| Miscanthus | 6.5/7.5 | 0.5/1.1 | 6/8 | 0.6/1.2 | 0 | 0 |
| Luzerne | 0 | 5/7 | 27/33 | 27/33 | 2/4 | 1/3 |
| Sorgho ensilé | 10/14 | 8/7 | 8/12 | 3/5 | 3/5 | 0 |

---

## 8. Valeurs épandages (Kg/hectare)

| Type | N | P | K | Ca | Mg | S |
|------|---|---|---|----|----|---|
| Fumier (25 T/ha) | 137.5 | 65 | 180 | 75 | 50 | 70 |
| Lisier (15 m³/ha) | 75 | 60 | 45 | 45 | 15 | 35 |
| Compost (15 T/ha) | 95 | 60 | 120 | 180 | 35 | 60 |
| Écume de sucrerie (15 T/ha) | 45 | 120 | 15 | 3 600 | 90 | — |
| Digestat liquide (25 m³/ha) | 125 | 50 | 300 | 47.5 | 17.5 | 14.25 |
| Digestat solide (25 T/ha) | 100 | 50 | 225 | 135 | 82.5 | 62.5 |

### 8.1 Broyage paille — restitutions (Kg/tonne broyée)

| Culture | Rdt paille (T/ha) | N | P | K | Ca | Mg | S |
|---------|-------------------|---|---|---|----|----|---|
| Blé | 8 | 6-8 | 1.2-2.2 | 11-13 | — | 0.5-1.5 | — |
| Orge | 8 | 6-8 | 0.5-1.5 | 11-13 | — | 0.5-1.5 | — |
| Avoine | 8 | 6-8 | 0.5-1.5 | 11-13 | — | 0.5-1.5 | — |
| Triticale | 8 | 6-8 | 1-3 | 8-12 | — | 1-3 | — |
| Pois | 6 | 8-10 | — | — | — | — | — |
| Féverole | 5 | 8-10 | — | — | — | — | — |

---

## 9. Races animales par espèce

### 9.1 Bovins — Races laitières

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Lait moyen (L/traite) | Espérance vie |
|------|---------------------|---------------------|----------------------|---------------|
| Prim'Holstein | 44 | 700 | 28 | 10-12 ans |
| Montbéliarde | 50 | 700 | 25 | 10-12 ans |
| Normande | 43 | 750 | 28 | 10-12 ans |
| Armoricaine | 35 | 680 | 14 | 10-12 ans |
| Brune des Alpes | 35 | 650 | 26 | 10-12 ans |
| Vosgienne | 35 | 600 | 14 | 10-12 ans |
| Simmental (Suisse) | 44 | 750 | 18 | 10-12 ans |
| Brown Swiss | 35 | 650 | 26 | 10-12 ans |
| Jersiaise | 20 | 450 | 18 | 10-12 ans |
| Red Holstein | 45 | 750 | 28 | 10-12 ans |

### 9.2 Bovins — Races allaitantes

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Lait moyen (L/traite) | Espérance vie |
|------|---------------------|---------------------|----------------------|---------------|
| Charolaise | 45 | 750 | 12 | 10-12 ans |
| Blond d'Aquitaine | 44 | 850 | 12 | 10-12 ans |
| Limousine | 38 | 670 | 12 | 10-12 ans |
| Blanc Bleu Belge | 45 | 800 | 10 | 10-12 ans |
| Parthenaise | 42 | 800 | 14 | 10-12 ans |
| Rouge des Prés | 49 | 850 | 12 | 10-12 ans |
| Salers | 36 | 680 | 12 | 10-12 ans |
| Aubrac | 36 | 650 | 10 | 10-12 ans |

### 9.3 Bisons

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Espérance vie |
|------|---------------------|---------------------|---------------|
| Bison d'Amérique | 25 | 550 | 20-22 ans |
| Bison d'Europe | 25 | 550 | 20-22 ans |

### 9.4 Caprins

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Lait (L/jour) | Laine (kg/tonte) | Espérance vie |
|------|---------------------|---------------------|---------------|------------------|---------------|
| Alpine | 2.2 | 60 | 2.7 | 0 | 7-8 ans |
| Angora | 2 | 30 | 2.4 | 2 | 7-8 ans |
| Corse | 2.1 | 40 | 2.4 | 0 | 7-8 ans |
| Poitevine | 2.2 | 65 | 2.7 | 0 | 7-8 ans |
| Rove | 2.3 | 65 | 2.7 | 0 | 7-8 ans |
| Saanen | 2.4 | 70 | 2.7 | 0 | 7-8 ans |
| Nera Verzasca (Suisse) | 2.2 | 50 | 1.7 | 0 | 7-8 ans |
| Toggenburg (Suisse) | 2 | 55 | 2.7 | 2 | 7-8 ans |
| Spanish | 2.4 | 70 | 2.7 | 0 | 7-8 ans |

### 9.5 Porcins

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Espérance vie |
|------|---------------------|---------------------|---------------|
| Large White | 1.5 | 240 | 3-4 ans |
| Landrace Français | 1.5 | 230 | 3-4 ans |
| Piétrain | 1.5 | 220 | 3-4 ans |
| Penshire | 1.5 | 220 | 3-4 ans |
| Duroc | 1.5 | 240 | 3-4 ans |
| Hereford | 1.5 | 240 | 3-4 ans |

### 9.6 Lapins

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Laine (kg/tonte) | Espérance vie |
|------|---------------------|---------------------|------------------|---------------|
| Argenté de Champagne | 0.05 | 4.5 | 0 | 5-6 ans |
| Fauve de Bourgogne | 0.05 | 4.5 | 0 | 5-6 ans |
| Néo Zélandais Blanc | 0.05 | 4.5 | 0 | 5-6 ans |
| Bleu de Vienne | 0.05 | 4.5 | 0 | 5-6 ans |
| Chamois de Thuringe | 0.05 | 3.7 | 0 | 5-6 ans |
| Lièvre Belge | 0.05 | 3.8 | 0 | 5-6 ans |
| Angora | 0.05 | 4.1 | 0.3 | 5-6 ans |
| Alaska | 0.05 | 3.8 | 0 | 5-6 ans |
| Rex Castor | 0.05 | 4.1 | 0 | 5-6 ans |
| Rex Blanc | 0.05 | 4.1 | 0 | 5-6 ans |
| Rex Dalmatien | 0.05 | 4.1 | 0 | 5-6 ans |
| Rex Bleu | 0.05 | 4.1 | 0 | 5-6 ans |

### 9.7 Volailles

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) Intensif/Semi | Œufs/jour | Espérance vie |
|------|---------------------|-----------------------------------|-----------|---------------|
| Charollaise | 0.05 | 2.5/2.9 | 3-5 | 7-8 ans |
| Gauloise | 0.05 | 2.5/2.9 | 3-5 | 7-8 ans |
| Coucou des Flandres | 0.05 | 2.5/2.9 | 3-5 | 7-8 ans |
| Meusienne | 0.05 | 3.9/4.5 | 1 | 7-8 ans |
| Bourbourg | 0.05 | 2.75/3.2 | 2 | 7-8 ans |
| Suisse (Suisse) | 0.05 | 2.4/2.8 | 2 | 7-8 ans |

### 9.8 Pintades

| Race | Poids naissance (kg) | Poids adulte (kg) Intensif/Semi | Œufs/ponte | Espérance vie |
|------|---------------------|--------------------------------|------------|---------------|
| Pintade grise | 0.05 | 2.5/2.9 | 8-15 | 7-8 ans |

### 9.9 Ovins — Races laitières

| Race | Poids naiss. (kg) | Poids adulte ♀ (kg) | Laine (kg/tonte) | Lait (L/jour) | Nb petits |
|------|-------------------|---------------------|------------------|---------------|-----------|
| Lacaune Lait | 4 | 75 | 0 | 3 | 1-2 |
| Manech Noire | 4 | 50 | 2 | 1.5 | 1-2 |
| Manech Rousse | 4 | 45 | 2 | 1 | 1-2 |

### 9.10 Ovins — Races allaitantes

| Race | Poids naiss. (kg) | Poids adulte ♀ (kg) | Laine (kg/tonte) | Nb petits |
|------|-------------------|---------------------|------------------|-----------|
| Ile de France | 4.5 | 80 | 4 | 2 |
| Charollais | 3.5 | 90 | 0 | 2 |
| Texel | 5 | 90 | 3 | 2 |
| Engadine (Suisse) | 4 | 70 | 4 | 2 |
| Suffolk | 3 | 80 | 0 | 2 |
| Rouge de l'Ouest | 4 | 75 | 3 | 2 |
| Blanche du Massif Central | 3.5 | 65 | 1 | 2 |
| Mérinos d'Arles | 3.5 | 55 | 5.5 | 1-2 |
| Causses du Lot | 4.5 | 60 | 2 | 1-2 |
| Charmoise | 5 | 70 | 0 | 1-2 |
| Berrichon du Cher | 5 | 70 | 3 | 1-2 |

> Espérance de vie ovins : 7-8 ans

### 9.11 Daims

| Race | Poids naissance (kg) | Poids adulte ♀ (kg) | Espérance vie |
|------|---------------------|---------------------|---------------|
| Daims | 3 | 53 | 18-20 ans |

### 9.12 Oies

| Race | Recommandée pour | Poids adulte ♀ (kg) | Oisons/portée | Espérance vie |
|------|------------------|---------------------|---------------|---------------|
| Oie Blanche du Bourbonnais | Chair | 7 | 4-10 | 8-10 ans |
| Oie Blanche du Poitou | Chair | 6 | 4-10 | 8-10 ans |
| Oie Normande | Chair | 4 | 4-10 | 8-10 ans |
| Oie de Guinée | Chair | 4 | 4-10 | 8-10 ans |
| Oie Flamande (Belgique) | Chair | 4 | 4-10 | 8-10 ans |
| Oie d'Alsace | Foie gras + chair | 4 | 4-10 | 8-10 ans |
| Oie de Toulouse | Foie gras + chair | 8 | 4-10 | 8-10 ans |
| Oie Grise des Landes | Foie gras + chair | 6 | 4-10 | 8-10 ans |

### 9.13 Canards

| Race | Recommandée pour | Poids adulte ♀ (kg) | Œufs/jour | Espérance vie |
|------|------------------|---------------------|-----------|---------------|
| Canard de Rouen Clair | Chair | 3 | 0-4 | 6-8 ans |
| Canard Duclair | Chair | 2.5 | 0-4 | 6-8 ans |
| Canard de Pékin Allemand | Chair | 3 | 0-4 | 6-8 ans |
| Canard de Pékin Américain (USA) | Chair | 3 | 0-4 | 6-8 ans |
| Canard de Bourbourg | Chair | 3 | 0-4 | 6-8 ans |
| Canard de Barbarie | Foie gras + chair | 4 | 0-4 | 6-8 ans |

### 9.14 Chevaux — Selle

| Race | Poids naiss. (kg) | Poids adulte (kg) | Taille (m) | Espérance vie |
|------|-------------------|-------------------|------------|---------------|
| Alter Real | 45/55 | 400/500 | 1.50/1.60 | 20-22 ans |
| Anglo-Arabe | 45/55 | 450/550 | 1.49/1.60 | 20-22 ans |
| Appaloosa | 45/55 | 400/450 | 1.50/1.63 | 20-22 ans |
| Arabe Shagya | 45/55 | 350/400 | 1.55/1.65 | 20-22 ans |
| Barbe | 45/55 | 400/550 | 1.49/1.60 | 20-22 ans |
| Cheval Canadien | 45/55 | 500/650 | 1.49/1.60 | 20-22 ans |
| Franches-Montagnes | 45/55 | 550/650 | 1.50/1.60 | 20-22 ans |
| Frison | 48/55 | 600/800 | 1.50/1.60 | 20-22 ans |
| Hanovrien | 45/55 | 500/600 | 1.53/1.70 | 20-22 ans |
| Henson | 45/55 | 450/500 | 1.50/1.60 | 20-22 ans |
| Holsteiner | 45/55 | 500/600 | 1.63/1.73 | 20-22 ans |
| Lipizzan | 45/55 | 450/550 | 1.50/1.60 | 20-22 ans |
| Paint Horse | 45/55 | 500/650 | 1.52/1.60 | 20-22 ans |
| Pur-Sang Anglais | 45/55 | 400/500 | 1.49/1.80 | 20-22 ans |
| Pur-Sang Arabe | 45/55 | 350/400 | 1.49/1.60 | 20-22 ans |
| Pur Race Espagnole | 45/55 | 400/500 | 1.50/1.65 | 20-22 ans |
| Quarter Horse | 45/55 | 500/650 | 1.52/1.63 | 20-22 ans |
| Selle Français | 45/55 | 400/550 | 1.60/1.65 | 20-22 ans |
| Trakehner | 45/55 | 400/500 | 1.60/1.68 | 20-22 ans |
| Trotteur Français | 45/55 | 500/650 | 1.60/1.70 | 20-22 ans |

### 9.15 Chevaux — Trait

| Race | Poids naiss. (kg) | Poids adulte (kg) | Taille (m) | Espérance vie |
|------|-------------------|-------------------|------------|---------------|
| Ardennais | 50/60 | 700/1000 | 1.60/1.65 | 22-25 ans |
| Auxois | 50/60 | 700/1000 | 1.60/1.70 | 22-25 ans |
| Boulonnais | 50/60 | 650/700 | 1.60/1.70 | 22-25 ans |
| Breton | 50/60 | 700/800 | 1.55/1.63 | 22-25 ans |
| Cob Normand | 50/60 | 550/800 | 1.60/1.65 | 22-25 ans |
| Comtois | 50/60 | 650/800 | 1.50/1.65 | 22-25 ans |
| Percheron | 50/60 | 500/1200 | 1.60/1.85 | 22-25 ans |
| Poitevin Mulassier | 50/60 | 700/800 | 1.60/1.70 | 22-25 ans |
| Trait du Nord | 50/60 | 800/1000 | 1.65/1.75 | 22-25 ans |
| Brabançon | 50/60 | 800/1000 | 1.60/1.75 | 22-25 ans |
| Shire | 50/60 | 800/1000 | 1.72/1.80 | 22-25 ans |
| Clydesdale | 50/60 | 800/1000 | 1.62/1.70 | 22-25 ans |
| Irish Cob | 50/60 | 500/600 | 1.49/1.55 | 22-25 ans |
| American Cream Draft | 50/60 | 650/700 | 1.55/1.70 | 22-25 ans |

### 9.16 Chevaux — Poney

| Race | Poids naiss. (kg) | Poids adulte (kg) | Taille (m) | Espérance vie |
|------|-------------------|-------------------|------------|---------------|
| Camargue | 15/25 | 300/400 | 1.35/1.45 | 28-30 ans |
| Cheval Castillonais | 15/25 | 400/500 | 1.35/1.48 | 28-30 ans |
| Mérens | 15/25 | 400/500 | 1.35/1.48 | 28-30 ans |
| Connemara | 15/25 | 380/420 | 1.28/1.48 | 28-30 ans |
| Dartmoor | 15/25 | 280/320 | 1.20/1.27 | 28-30 ans |
| Fjord | 15/25 | 450/550 | 1.40/1.48 | 28-30 ans |
| Haflinger | 15/25 | 340/380 | 1.35/1.48 | 28-30 ans |
| Landais | 15/25 | 250/350 | 1.18/1.48 | 28-30 ans |
| New Forest | 15/25 | 350/450 | 1.20/1.48 | 28-30 ans |
| Poney Français de Selle | 15/25 | 380/420 | 1.25/1.48 | 28-30 ans |
| Pottok | 15/25 | 380/420 | 1.20/1.47 | 28-30 ans |
| Shetland | 15/25 | 150/180 | 0.90/1.07 | 28-30 ans |
| Welsh | 15/25 | 230/270 | 1.20/1.38 | 28-30 ans |

---

## 10. Rations animales (kg/jour sauf eau en litres)

### 10.1 Bovins — Stabulation

**Compléments par tranche d'âge :**

| Catégorie | Orge/blé/trit. | Tourteau colza/soja | Min.&Vit. | Eau (L) |
|-----------|---------------|---------------------|-----------|---------|
| Taureaux/vaches >3 ans | 7.2 | 4.8 | 1 | 200 |
| 24-36 mois | 6 | 4 | 0.8 | 100 |
| 18-24 mois | 4 | 4 | 0.6 | 80 |
| 12-18 mois | 2 | 4 | 0.4 | 60 |
| Veaux 6-12 mois | 1.2 | 2 | 0.4 | 40 |
| Veaux 3-6 mois | 0.6 | 1.2 | 0.4 | 28 |
| Veaux 0-3 mois | 0 | 0 | 0 | 12 |

> Veaux 0-3 mois : Concentré jeune bovin 8 kg + eau 12 L

**Rations de base (choix parmi) — Taureaux/vaches >3 ans :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 72 + 84 | 169 |
| Paille + maïs ensilé | 28 + 96 | 137 |
| Paille + betterave | 28 + 120 | 161 |
| Paille + pulpe betterave | 28 + 100 | 141 |
| Foin + maïs ensilé + ensilage herbe | 56 + 48 + 28 | 146 |
| Maïs ensilé + bouchons luzerne | 60 + 10 | 83 |
| Foin + maïs + sorgho/céréale immature | 72 + 42 + 42 | 169 |
| Paille + maïs + sorgho | 28 + 48 + 48 | 137 |
| Foin + maïs + sorgho + ensilage herbe | 56 + 24 + 24 + 28 | 145 |
| Maïs + sorgho + bouchons luzerne | 30 + 30 + 10 | 83 |

**24-36 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 60 + 72 | 144 |
| Paille + maïs ensilé | 24 + 80 | 117 |
| Paille + betterave | 24 + 80 | 117 |
| Paille + pulpe betterave | 24 + 80 | 117 |
| Foin + maïs + ensilage herbe | 48 + 48 + 24 | 130.8 |
| Maïs ensilé + bouchons luzerne | 54 + 9 | 71 |
| Foin + maïs + sorgho | 60 + 36 + 36 | 144 |
| Paille + maïs + sorgho | 24 + 40 + 40 | 117 |
| Foin + maïs + sorgho + ensilage herbe | 48 + 24 + 24 + 24 | 130.8 |
| Maïs + sorgho + bouchons luzerne | 27 + 27 + 9 | 71 |

**18-24 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 48 + 48 | 112 |
| Paille + maïs ensilé | 20 + 60 | 91 |
| Paille + betterave | 20 + 84 | 107 |
| Paille + pulpe betterave | 20 + 64 | 87 |
| Foin + maïs + ensilage herbe | 32 + 32 + 16 | 88.6 |
| Maïs ensilé + bouchons luzerne | 48 + 8 | 64 |
| Foin + maïs + sorgho | 48 + 24 + 24 | 112 |
| Paille + maïs + sorgho | 20 + 30 + 30 | 91 |
| Foin + maïs + sorgho + ensilage herbe | 32 + 16 + 16 + 16 | 88.6 |
| Maïs + sorgho + bouchons luzerne | 24 + 24 + 8 | 55 |

**12-18 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 36 + 36 | 85 |
| Paille + maïs ensilé | 16 + 44 | 69 |
| Paille + betterave | 16 + 60 | 81 |
| Paille + pulpe betterave | 16 + 40 | 67 |
| Foin + maïs + ensilage herbe | 24 + 24 + 12 | 66.4 |
| Maïs ensilé + bouchons luzerne | 42 + 7 | 55 |
| Foin + maïs + sorgho | 36 + 18 + 18 | 85 |
| Paille + maïs + sorgho | 16 + 22 + 22 | 69 |
| Foin + maïs + sorgho + ensilage herbe | 24 + 12 + 12 + 12 | 66.4 |
| Maïs + sorgho + bouchons luzerne | 21 + 21 + 7 | 42 |

**Veaux 6-12 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 24 + 24 | 57 |
| Paille + maïs ensilé | 8 + 28 | 47 |
| Paille + betterave | 8 + 36 | 55 |
| Paille + pulpe betterave | 8 + 16 | 35 |
| Foin + maïs + ensilage herbe | 16 + 16 + 8 | 43.6 |
| Maïs ensilé + bouchons luzerne | 36 + 6 | 45 |
| Foin + maïs + sorgho | 24 + 12 + 12 | 57 |
| Paille + maïs + sorgho | 8 + 14 + 14 | 47 |
| Foin + maïs + sorgho + ensilage herbe | 16 + 8 + 8 + 8 | 43.6 |
| Maïs + sorgho + bouchons luzerne | 18 + 18 + 6 | 28 |

**Veaux 3-6 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 12 + 12 | 29 |
| Paille + maïs ensilé | 4 + 12 | 23 |
| Paille + betterave | 4 + 16 | 27 |
| Paille + pulpe betterave | 4 + 12 | 23 |
| Foin + maïs + ensilage herbe | 8 + 8 + 4 | 22.2 |
| Maïs ensilé + bouchons luzerne | 30 + 5 | 37 |
| Foin + maïs + sorgho | 12 + 6 + 6 | 29 |
| Paille + maïs + sorgho | 4 + 6 + 6 | 23 |
| Foin + maïs + sorgho + ensilage herbe | 8 + 4 + 4 + 4 | 22.2 |
| Maïs + sorgho + bouchons luzerne | 15 + 15 + 5 | 14 |

### 10.2 Bovins — Ration hivernale au pré (races allaitantes, Nov→Mars)

| Catégorie | Foin | Orge/blé/trit. | Tourteau | Min.&Vit. | Eau (L) | Ration complète |
|-----------|------|---------------|----------|-----------|---------|-----------------|
| >3 ans | 44 | 6.6 | 2.2 | 1 | 200 | 53.8 |
| 24-36 mois | 36 | 5.4 | 1.8 | 0.8 | 100 | 44 |
| 18-24 mois | 28 | 4.2 | 1.4 | 0.7 | 80 | 34 |
| 12-18 mois | 20 | 3 | 1 | 0.5 | 60 | 25 |
| 6-12 mois | 16 | 2.4 | 0.8 | 0.4 | 40 | 20 |
| 3-6 mois | 12 | 1.2 | 0.6 | 0.3 | 28 | 15 |
| 0-3 mois | 0 | 0 | 0 | 0 | 12 | — |

### 10.3 Bisons — Ration hivernale (Oct→Mars)

| Catégorie | Foin | Blé/trit. | Orge | Avoine | Tourteau colza/soja | Min.&Vit. | Eau (L) |
|-----------|------|-----------|------|--------|---------------------|-----------|---------|
| ≥3 ans | 40 | 6 | 6 | 6 | 6 | 1 | 100 |
| 24-36 mois | 32 | 4.8 | 4.8 | 4.8 | 4.8 | 0.8 | 60 |
| 18-24 mois | 24 | 3.6 | 3.6 | 3.6 | 3.6 | 0.6 | 48 |
| 12-18 mois | 20 | 3 | 3 | 3 | 3 | 0.5 | 40 |
| 6-12 mois | 16 | 2.4 | 2.4 | 2.4 | 2.4 | 0.4 | 32 |
| 3-6 mois | 8 | 1.2 | 1.2 | 1.2 | 1.2 | 0.2 | 20 |
| 0-3 mois | Lait mère | — | — | — | — | — | 8 |

### 10.4 Caprins — Chèvrerie

**Compléments :**

| Catégorie | Orge | Blé/trit. | Min.&Vit. | Eau (L) |
|-----------|------|-----------|-----------|---------|
| Boucs/chèvres >12 mois | 1.6 | 1.6 | 0.08 | 20 |
| Jeunes 6-12 mois | 1.4 | 1.4 | 0.04 | 12 |
| Chevreaux 3-6 mois | 1.2 | 1.2 | 0.04 | 8 |
| Chevreaux 0-3 mois | 1 | 1 | 0.04 | 4 |

**Rations de base — Boucs/chèvres >12 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Maïs ensilé + foin | 16 + 1.2 | 21 |
| Betterave + foin | 14 + 2 | 19 |
| Pulpe betterave + foin | 14 + 2 | 19 |
| Foin seul | 16 | 19 |
| Foin + maïs + ensilage herbe | 1.2 + 10 + 6 | 20.48 |
| Sorgho/céréale immature + foin | 16 + 1.2 | 21 |
| Foin + sorgho + ensilage herbe | 1.2 + 10 + 6 | 20.48 |

**Jeunes 6-12 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Maïs ensilé + foin | 12 + 1.2 | 16 |
| Betterave + foin | 10 + 2 | 14 |
| Pulpe betterave + foin | 10 + 2 | 14 |
| Foin seul | 12 | 14 |
| Foin + maïs + ensilage herbe | 1.2 + 8 + 4 | 16.04 |
| Sorgho/céréale immature + foin | 12 + 1.2 | 16 |

**Chevreaux 3-6 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Maïs ensilé + foin | 8 + 0.8 | 11 |
| Betterave + foin | 6 + 1.2 | 10 |
| Pulpe betterave + foin | 6 + 1.2 | 10 |
| Foin seul | 6 | 10 |
| Foin + maïs + ensilage herbe | 0.8 + 6 + 2 | 11.24 |

**Chevreaux 0-3 mois :** Foin 2.8 (ration complète 3)

---

### 10.5 Porcins — Porcherie

| Catégorie | Ration base | Tourteau colza | Min.&Vit. | Eau (L) | Ration complète |
|-----------|-------------|---------------|-----------|---------|-----------------|
| Verrats/truies >12 mois | Orge 8 + blé/trit. 2 + avoine 2 | 0.8 | 0.8 | 68 | 14 |
| Jeunes 6-12 mois | Orge 6 + blé/trit. 1.6 + avoine 1.6 | 1.4 | 1.4 | 48 | 10 |
| Jeunes 3-6 mois | Orge 0.8 + blé/trit. 2 + maïs grain 3.2 | 1.6 | 0.4 | 24 | 8 |
| Porcelets 1-3 mois | Blé/trit. 1 + avoine 0.6 + maïs grain 1.2 | 1 | 0.2 | 12 | 4 |
| Porcelets 0-1 mois | Concentré jeune porcin 0.4 | — | — | 2 | — |

### 10.6 Lapins — Clapier

| Catégorie | Foin | Blé+orge+pois+avoine | Betterave | Tourteau tournesol | Eau (L) | Ration complète |
|-----------|------|---------------------|-----------|-------------------|---------|-----------------|
| Adultes >3 mois | 0.8 | 0.16×4 = 0.64 | 0.18 | 0.18 | 1.2 | 1.8 |
| Jeunes 1-3 mois | 0.54 | 0.104×4 = 0.416 | 0.12 | 0.12 | 1.2 | 1.2 |
| Lapereaux 0-1 mois | Concentré 0.04 | — | — | — | 0.4 | — |

### 10.7 Volailles — Poulailler

| Catégorie | Blé/trit. | Maïs grain | Avoine | Min.&Vit. | Eau (L) | Ration complète |
|-----------|-----------|------------|--------|-----------|---------|-----------------|
| Coqs/poules >6 mois | 0.055 | 0.02 | 0.02 | 0.005 | 1 | 0.1 |
| Jeunes 1-6 mois | 0.04 | 0.015 | 0.015 | 0.003 | 0.6 | 0.075 |
| Poussins 0-1 mois | 0.03 | 0.01 | 0.01 | 0.002 | 0.2 | 0.055 |

### 10.8 Pintades — Poulailler

| Catégorie | Blé/trit. | Maïs grain | Avoine | Min.&Vit. | Eau (L) | Ration complète |
|-----------|-----------|------------|--------|-----------|---------|-----------------|
| Adultes >9 mois | 0.055 | 0.02 | 0.02 | 0.005 | 1 | 0.1 |
| Jeunes 1-9 mois | 0.05 | 0.015 | 0.015 | 0.003 | 0.6 | 0.091 |
| Pintadeaux 0-1 mois | 0.03 | 0.01 | 0.01 | 0.002 | 0.2 | 0.055 |

### 10.9 Ovins — Bergerie

**Compléments :**

| Catégorie | Orge/blé/trit. | Tourteau colza | Min.&Vit. | Eau (L) |
|-----------|---------------|---------------|-----------|---------|
| Béliers/brebis >12 mois | 1.6 | 1.2 | 0.14 | 20 |
| Jeunes 6-12 mois | 1.4 | 0.8 | 0.08 | 12 |
| Agneaux 3-6 mois | 1.2 | 0.6 | 0.04 | 8 |
| Agneaux 0-3 mois | 1 | 0.4 | 0.04 | 4 |

**Rations de base — Béliers/brebis >12 mois :**

| Ration | Composants (kg) | Ration complète |
|--------|----------------|-----------------|
| Foin + maïs ensilé | 8 + 16 | 26.94 |
| Foin + betterave | 8 + 8 | 18.94 |
| Paille + betterave | 8 + 8 | 18.94 |
| Paille + pulpe betterave | 8 + 16 | 26.94 |
| Foin + pulpe betterave | 8 + 16 | 26.94 |
| Foin + maïs + ensilage herbe | 10 + 8 + 6 | 26.94 |
| Foin + bouchons luzerne | 8 + 2 | 12.94 |
| Foin + sorgho/céréale immature | 8 + 16 | 26.94 |

**Jeunes 6-12 mois :** Foin+maïs 6+12 (20.28), Foin+betterave 6+6 (14.28), Foin+luzerne 6+1.5 (9.78)

**Agneaux 3-6 mois :** Foin+maïs 4+8 (13.84), Foin+betterave 4+6 (11.84), Foin+luzerne 4+1 (6.84)

### 10.10 Ovins — Ration hivernale au pré (races allaitantes)

| Catégorie | Foin | Orge/blé/trit. | Tourteau colza | Min.&Vit. | Eau (L) |
|-----------|------|---------------|---------------|-----------|---------|
| >12 mois | 4 | 1.6 | 0.6 | 0.1 | 20 |
| 6-12 mois | 3.2 | 1.28 | 0.48 | 0.08 | 12 |
| 3-6 mois | 2.4 | 0.96 | 0.36 | 0.06 | 8 |
| 0-3 mois | 2 | 0.8 | 0.3 | 0.05 | 4 |

### 10.11 Daims — Ration hivernale (Oct→Mars)

| Catégorie | Foin | Blé/trit. | Orge | Avoine | Tourteau colza/soja | Min.&Vit. | Eau (L) | Ration complète |
|-----------|------|-----------|------|--------|---------------------|-----------|---------|-----------------|
| ≥3 ans | 10 | 1 | 1 | 1 | 1 | 0.25 | 20 | 14.25 |
| 24-36 mois | 9 | 0.9 | 0.9 | 0.9 | 0.9 | 0.23 | 18 | 12.83 |
| 18-24 mois | 8 | 0.8 | 0.8 | 0.8 | 0.8 | 0.2 | 16 | 11.4 |
| 12-18 mois | 7 | 0.7 | 0.7 | 0.7 | 0.7 | 0.18 | 14 | 9.98 |
| 6-12 mois | 6 | 0.6 | 0.6 | 0.6 | 0.6 | 0.15 | 12 | 8.55 |
| 3-6 mois | 5 | 0.5 | 0.5 | 0.5 | 0.5 | 0.13 | 10 | 7.13 |
| 0-3 mois | Lait mère | — | — | — | — | — | 8 | — |

### 10.12 Oies

| Catégorie | Blé/trit. | Maïs grain | Avoine | Min.&Vit. | Eau (L) | Ration complète |
|-----------|-----------|------------|--------|-----------|---------|-----------------|
| Jars/oies >6 mois | 0.220 | 0.08 | 0.08 | 0.002 | 4 | 0.382 |
| Jeunes 3-6 mois | 0.160 | 0.06 | 0.06 | 0.012 | 2.4 | 0.287 |
| Oisons 0-3 mois | 0.12 | 0.04 | 0.04 | 0.008 | 0.8 | 0.210 |

### 10.13 Canards

| Catégorie | Maïs grain | Blé/trit. | Tourteau colza/soja | Min.&Vit. | Eau (L) | Ration complète |
|-----------|------------|-----------|---------------------|-----------|---------|-----------------|
| Adultes >6 mois | 0.110 | 0.040 | 0.040 | 0.01 | 4 | 0.191 |
| Jeunes 3-6 mois | 0.080 | 0.030 | 0.030 | 0.006 | 3 | 0.143 |
| Canetons 0-3 mois | 0.500 | 0.200 | 0.200 | 0.100 | 2 | 0.955 |

### 10.14 Chevaux — Écurie

| Catégorie | Selle | Trait | Poney |
|-----------|-------|-------|-------|
| **Poulain 0-12 mois** | RC: 12.5 | RC: 21.5 | RC: 9 |
| Avoine | 1.5 | 2.5 | 1 |
| Orge | 1.5 | 2.5 | 1 |
| Maïs grain | 1.5 | 2.5 | 1 |
| Foin | 4 | 7 | 3 |
| Paille | 4 | 7 | 3 |
| Eau (L) | 30 | 60 | 25 |
| **Jeune 12-24 mois** | RC: 23.5 | RC: 36 | RC: 18 |
| Avoine | 2.5 | 4 | 2 |
| Orge | 2.5 | 4 | 2 |
| Maïs grain | 2.5 | 4 | 2 |
| Foin | 8 | 12 | 6 |
| Paille | 8 | 12 | 6 |
| Eau (L) | 70 | 100 | 50 |
| **Jeune 24-36 mois** | RC: 36 | RC: 54 | RC: 27 |
| Avoine | 4 | 6 | 3 |
| Orge | 4 | 6 | 3 |
| Maïs grain | 4 | 6 | 3 |
| Foin | 12 | 18 | 9 |
| Paille | 12 | 18 | 9 |
| Eau (L) | 100 | 150 | 75 |
| **Adulte >36 mois** | RC: 54 | RC: 74 | RC: 36 |
| Avoine | 6 | 8 | 4 |
| Orge | 6 | 8 | 4 |
| Maïs grain | 6 | 8 | 4 |
| Foin | 18 | 25 | 12 |
| Paille | 18 | 25 | 12 |
| Eau (L) | 150 | 200 | 100 |

### 10.15 Chevaux — Ration hivernale au pré (Déc→Fév)

| Catégorie | | Selle | Trait | Poney |
|-----------|---|-------|-------|-------|
| **Poulain 0-12** | Min.&Vit. | 0.05 | 0.10 | 0.05 |
| | Orge | 1.5 | 3 | 1.5 |
| | Foin | 1 | 2.5 | 1 |
| | Paille | 3 | 5 | 3 |
| | Eau (L) | 30 | 60 | 25 |
| **Jeune 12-24** | Min.&Vit. | 0.1 | 0.15 | 0.07 |
| | Orge | 3 | 4 | 2 |
| | Foin | 2 | 3 | 1.5 |
| | Paille | 6 | 8 | 4 |
| | Eau (L) | 70 | 100 | 50 |
| **Jeune 24-36** | Min.&Vit. | 0.15 | 0.2 | 0.11 |
| | Orge | 4.5 | 6 | 3 |
| | Foin | 3 | 4 | 2 |
| | Paille | 9 | 11 | 6 |
| | Eau (L) | 100 | 150 | 75 |
| **Adulte >36** | Min.&Vit. | 0.2 | 0.3 | 0.15 |
| | Orge | 6 | 8 | 4 |
| | Foin | 4 | 6 | 3 |
| | Paille | 12 | 16 | 9 |
| | Eau (L) | 150 | 200 | 100 |

---

## 11. Surfaces par animal (m²)

### 11.1 Bovins (stabulation)

| Taureau | Vache | Taurillon | Génisse | Veau |
|---------|-------|-----------|---------|------|
| 15 | 12 | 8 | 8 | 5 |

### 11.2 Caprins (chèvrerie)

| Bouc | Chèvre | Jeune bouc | Jeune chèvre | Chevreau |
|------|--------|------------|--------------|----------|
| 7 | 5 | 4 | 4 | 2 |

### 11.3 Porcins (porcherie)

| Verrat | Truie | Jeune verrat | Jeune truie | Porcelet |
|--------|-------|-------------|-------------|----------|
| 5 | 4 | 2 | 2 | 0.5 |

### 11.4 Lapins (clapier)

| Lapin | Lapine | Jeune lapin | Jeune lapine | Lapereau |
|-------|--------|-------------|-------------|----------|
| 1 | 1 | 0.5 | 0.5 | 0.2 |

### 11.5 Volailles (poulailler)

| Coq | Poule | Jeune coq | Jeune poule | Poussin |
|-----|-------|-----------|-------------|---------|
| 0.1 | 0.1 | 0.07 | 0.07 | 0.01 |

Parc à volailles : **10 m²** par animal

### 11.6 Pintades (poulailler)

| Pintade M/F | Jeune pintade M/F | Pintadeau |
|-------------|-------------------|-----------|
| 0.1 | 0.07 | 0.01 |

Parc à volailles : **10 m²** par animal

### 11.7 Ovins (bergerie)

| Bélier | Brebis | Jeune bélier | Jeune brebis | Agneau |
|--------|--------|-------------|-------------|--------|
| 7 | 5 | 4 | 4 | 2 |

### 11.8 Oies (poulailler)

| Jars | Oie | Jeune jars | Jeune oie | Oison |
|------|-----|------------|-----------|-------|
| 0.5 | 0.5 | 0.3 | 0.3 | 0.15 |

Parc à volailles : **10 m²** par animal

### 11.9 Canards (poulailler)

| Canard | Cane | Jeune canard | Jeune cane | Caneton |
|--------|------|-------------|------------|---------|
| 0.1 | 0.1 | 0.08 | 0.08 | 0.04 |

Parc à volailles : **10 m²** par animal

### 11.10 Chevaux (écurie)

| Catégorie | Selle | Trait | Poney |
|-----------|-------|-------|-------|
| Poulain/Pouliche | 9 | 12 | 7 |
| Jeune étalon | 9 | 12 | 7 |
| Jeune jument | 9 | 12 | 7 |
| Étalon | 12 | 15 | 10 |
| Jument | 12 | 15 | 10 |

### 11.11 Bisons (prairie boisée)

**1 hectare** par animal (quel que soit l'âge)

### 11.12 Daims (prairie boisée, en hectares)

| Daim | Daine | Jeune daim | Jeune daine | Faon |
|------|-------|------------|-------------|------|
| 1 | 1 | 0.5 | 0.5 | 0.25 |

### 11.13 Herbe au pré (m²/jour)

| Animal | Bovins | Caprins | Ovins |
|--------|--------|---------|-------|
| Mâle adulte | 88 | 68 | 68 |
| Femelle adulte | 80 | 60 | 60 |
| Jeune mâle | 80 | 52 | 52 |
| Jeune femelle | 72 | 52 | 52 |
| Petit | 56 | 40 | 40 |

**Chevaux (m²/jour au pré) :**

| Catégorie | Selle | Trait | Poney |
|-----------|-------|-------|-------|
| Poulain/pouliche | 40 | 60 | 30 |
| Jeune étalon/jument | 60 | 80 | 40 |
| Étalon/jument | 80 | 100 | 60 |

---

## 12. Litière (kg paille/jour) et Lisier (L/jour)

### 12.1 Litière

| Espèce | Mâle adulte | Femelle adulte | Jeune mâle | Jeune femelle | Petit |
|--------|-------------|----------------|------------|---------------|-------|
| Bovins | 90 | 72 | 48 | 48 | 30 |
| Caprins | 20 | 15 | 10 | 10 | 5 |
| Porcins | 15 | 10 | 5 | 5 | 5 |
| Lapins | 2 | 2 | 1 | 1 | 0.5 |
| Volailles | 0.5 | 0.5 | 0.3 | 0.3 | 0.1 |
| Pintades | 0.5 | 0.5 | 0.3 | 0.3 | 0.1 |
| Ovins | 20 | 15 | 10 | 10 | 5 |
| Oies | 1 | 1 | 0.6 | 0.6 | 0.2 |
| Canards | 0.5 | 0.5 | 0.3 | 0.3 | 0.1 |

**Chevaux :**

| Catégorie | Selle | Trait | Poney |
|-----------|-------|-------|-------|
| Poulain/Pouliche | 27 | 30 | 25 |
| Jeune étalon/jument | 27 | 30 | 25 |
| Étalon/Jument | 36 | 40 | 30 |

### 12.2 Lisier (élevage caillebotis uniquement)

**Bovins (L/jour) :**

| Taureau | Vache | Taurillon | Génisse | Veau |
|---------|-------|-----------|---------|------|
| 200 | 200 | 140 | 140 | 60 |

**Porcins (L/jour) :**

| Verrat | Truie | Jeune verrat | Jeune truie | Porcelet |
|--------|-------|-------------|-------------|----------|
| 50 | 50 | 30 | 30 | 5 |

---

## 13. Reproduction par espèce

| Espèce | Maturité sexuelle | Gestation | Portée | Délai entre mises bas | Insém. naturelle max/jour |
|--------|-------------------|-----------|--------|----------------------|--------------------------|
| Bovins | 27 mois (♀), 3 ans (♂) | 9 mois | 1 veau | 3 mois après mise bas | 4 |
| Bisons | 27 mois (♀), 3 ans (♂) | 9 mois | 1 bisonneau | 3 mois après mise bas | 1 |
| Caprins | 12 mois | 5 mois | 2 chevreaux | 6 mois après mise bas | 2 |
| Porcins | 12 mois | 4 mois | 6-9 porcelets | 1 mois après mise bas | 3 |
| Lapins | 3 mois | 1 mois | 6-7 lapereaux | 1 mois après mise bas | 5 |
| Volailles | 6 mois | 1 mois | 6-10 poussins | 5 jours après éclosion | 5 |
| Pintades | 9 mois | 6 cycles×1 mois | 8-15 pintadeaux | Saisonnier (mars) | 5 |
| Ovins | 12 mois | 5 mois | 1-2 agneaux | 7 mois après mise bas | 2 |
| Daims | 16 mois (♀), 3 ans (♂) | 8 mois | 1 faon | Octobre uniquement | 3 |
| Oies | 6 mois | 9 jours ponte/couvaison | 4-10 oisons | 3 cycles Mars→Juin | 4 |
| Canards | 6 mois | 7j (domestique) / 9j (Barbarie) | 3-12 canetons | Avril uniquement | 8 |
| Chevaux | 3 ans | 11 mois | 1 poulain | 1 mois après mise bas | 1 |

> Bisons : accouplement Juil-Oct uniquement. Daims : accouplement Oct uniquement. Pintades : insémination Mars uniquement. Oies : insémination Jan-Fév.

---

## 14. Prix lait par indice Qualité Lait (QL)

### 14.1 Élevage conventionnel (€/1000 L)

| Indice QL | Bovins | Caprins | Ovins |
|-----------|--------|---------|-------|
| 0-9.99 | 265 | 550 | 850 |
| 10-19.99 | 275 | 560 | 860 |
| 20-29.99 | 285 | 570 | 870 |
| 30-39.99 | 295 | 580 | 880 |
| 40-49.99 | 305 | 590 | 880 |
| 50-59.99 | 320 | 600 | 900 |
| 60-69.99 | 340 | 610 | 910 |
| 70-79.99 | 360 | 620 | 920 |
| 80-89.99 | 380 | 630 | 930 |
| 90-100 | 400 | 640 | 940 |

### 14.2 Élevage BIO (€/1000 L)

| Indice QL | Bovins | Caprins | Ovins |
|-----------|--------|---------|-------|
| 0-9.99 | 318 | 660 | 1020 |
| 10-19.99 | 330 | 672 | 1032 |
| 20-29.99 | 342 | 684 | 1044 |
| 30-39.99 | 354 | 696 | 1056 |
| 40-49.99 | 366 | 708 | 1068 |
| 50-59.99 | 384 | 720 | 1080 |
| 60-69.99 | 408 | 732 | 1092 |
| 70-79.99 | 432 | 744 | 1104 |
| 80-89.99 | 456 | 756 | 1116 |
| 90-100 | 480 | 768 | 1128 |

---

## 15. Rendement carcasse par espèce

| Espèce | Rendement carcasse (%) |
|--------|----------------------|
| Bovins (laitières) | 50-55 |
| Bovins (allaitants) | 55-75 |
| Porcins | 72-80 |
| Lapins | 55-63 |
| Volailles | 60-65 |
| Oies | 60-65 |
| Canards | 60-65 |
| Pintades | 60-65 |
| Ovins | 45-50 |
| Caprins | 45-50 |
| Bisons | 55-60 |
| Daims | 55-60 |

---

## 16. Serveurs de jeu

| Serveur | Pays | Difficulté | Spécificités |
|---------|------|------------|-------------|
| France | France | 2 | Serveur unique au lancement |
| Aubrac | France | 2 | Depuis 2006, bonne génétique animale |
| France 3 | France | 2 | Depuis 2009, parcelles plus disponibles |
| Belgique 1 | Belgique | 3 | Très actif, race exclusive Oie Flamande |
| Suisse 1 | Suisse | 4 | Peu peuplé, races exclusives : Simmental, Nera Verzasca, Suisse (volaille), Engadine |
| Canada 1 | Canada | 3 | Parcelles jusqu'à 200 ha, matériels nord-américains, race exclusive Ayrshire, seigle |
| USA 1 | USA | 4 | Parcelles 200 ha, trajets longs, races exclusives bovins/caprins/ovins/porcins/volailles/canards, coton |
| Expert | Imaginaire | 5 | 2 régions (Inorda, Isude), main d'œuvre limitée (couple d'exploitants), pas de transfert d'argent |

---

## 17. Arboriculture

### 17.1 Espèces arboricoles

| Espèce | Plantation | Récolte | Prix moyen | Arbres/ha | Rendement optimal à | Récolte par |
|--------|-----------|---------|------------|-----------|---------------------|-------------|
| Pommier | Déc-Jan | Sep-Oct | 0.51-0.65 €/kg | 1 000 | 4 ans | Manuel |
| Poirier | Déc-Jan | Sep-Oct | 0.55-0.95 €/kg | 1 200 | 4 ans | Manuel |
| Pêcher | Déc-Jan | Juil-Sep | 1.25-1.90 €/kg | 476 | 4 ans | Manuel |
| Prunier | Déc-Jan | Août-Sep | 0.90-1.10 €/kg | 250 | 6 ans | Manuel |
| Mirabellier | Déc-Jan | Août-Sep | 1.20-1.50 €/kg | 200 | 8 ans | Manuel |
| Noyer | Nov-Déc | Oct | 3.80-4.00 €/kg | 100 | 5 ans | Mécanique (vibreur+ramasseuse) |
| Olivier | Déc-Fév | Nov | 4.00-4.20 €/kg | 248 | 5 ans | Manuel |
| Cerisier | Déc-Jan | Mai-Juil | 1.90-2.10 €/kg | 500 | 5 ans | Manuel |
| Framboisier | Oct-Nov | Juil | 6.30-6.50 €/kg | 5 000 | 1 an | Manuel |
| Groseillier | Oct-Nov | Juin-Août | 3.80-4.00 €/kg | 2 500 | 2 ans | Manuel |
| Myrtillier | Oct-Nov | Juil-Août | 4.00-4.20 €/kg | 2 000 | 3 ans | Manuel |

### 17.2 Rendements arboricoles par région (T/ha)

| Région | Pommier | Poirier | Pêcher | Prunier | Mirabellier | Noyer | Olivier | Cerisier |
|--------|---------|---------|--------|---------|-------------|-------|---------|----------|
| Alsace | 28 | — | — | — | 4 | — | — | 10 |
| Aquitaine | 42 | 33 | 16 | 13 | — | 3 | — | 10 |
| Auvergne | 28 | — | — | — | — | — | — | — |
| Basse-Normandie | 21 | — | — | — | — | — | — | — |
| Bourgogne | 30 | — | — | — | — | — | — | 10 |
| Bretagne | 22 | — | — | — | — | — | — | — |
| Centre | 40 | 29 | — | — | — | — | — | 10 |
| Champagnes-Ardennes | 28 | — | — | — | — | — | — | — |
| Corse | 19 | — | — | 10 | — | — | 4 | — |
| Franche-Comté | 12 | — | — | — | — | — | — | — |
| Haute-Normandie | 18 | — | — | — | — | — | — | — |
| Ile-de-France | 20 | 15 | — | — | — | — | — | — |
| Languedoc-Roussillon | 39 | 29 | 24 | 12 | — | 3 | 4 | 10 |
| Limousin | 35 | — | — | — | — | 3 | — | — |
| Lorraine | 21 | — | — | — | 7 | — | — | 10 |
| Midi-Pyrénées | 43 | 17 | 11 | 12 | — | 3 | — | 10 |
| Nord | 33 | — | — | — | — | — | — | — |
| Pays de Loire | 45 | 27 | — | — | — | — | — | 10 |
| Picardie | 37 | — | — | — | — | — | — | — |
| Poitou-Charentes | 39 | — | — | — | — | — | — | — |
| PACA | 43 | 29 | 27 | 16 | — | 3 | 4 | 10 |
| Rhône-Alpes | 28 | 21 | 19 | 9 | 4 | 3 | 4 | 10 |
| Wallonie | — | 26 | — | 6 | — | — | — | — |
| Flandre | 38 | 28 | — | 6 | — | — | — | — |
| Suisse Romande | 38 | 24 | — | 7 | — | — | — | — |
| Suisse Alémanique | 40 | 26 | — | 7 | — | — | — | — |
| Suisse Italienne | — | — | — | 7 | — | — | — | — |

### 17.3 Petits fruits rouges (toutes régions)

| Espèce | Rendement moyen (T/ha) |
|--------|----------------------|
| Framboisier | 8.5 |
| Groseillier | 10 |
| Myrtillier | 10 |

---

## 18. Graminées (herbe)

### 18.1 Espèces

| Espèce | Semence (kg/ha) | Exploitation (saisons) | Rendement optimal (kg/% pousse) |
|--------|----------------|----------------------|-------------------------------|
| Ray-grass Italie | 20 | 1-2 | 50 |
| Ray-grass anglais | 25 | 3-10 | 50 |
| Dactyle | 20 | 4-10 | 53 |
| Fétuque élevée | 20 | 5-10 | 57 |
| Fléole | 7 | 3-5 | 50 |
| Brome | 50 | 3-4 | 57 |
| Trèfle blanc | 20 | 4-5 | 33 |
| Trèfle violet | 20 | 2-3 | 53 |

### 18.2 Recommandations d'utilisation

| Espèce | Pâture | Ensilage | Foin |
|--------|--------|----------|------|
| Ray-grass Italie | Bonne | Bonne/moyenne | Bonne/moyenne |
| Ray-grass anglais | Bonne | Moyenne/mauvaise | Moyenne/mauvaise |
| Dactyle | Mauvaise | Bonne/moyenne | Bonne/moyenne |
| Fétuque élevée | Mauvaise | Moyenne/mauvaise | Moyenne/mauvaise |
| Fléole | Mauvaise | Moyenne/mauvaise | Moyenne/mauvaise |
| Brome | Moyenne | Bonne/moyenne | Bonne/moyenne |
| Trèfle blanc | Bonne | Moyenne/mauvaise | Moyenne/mauvaise |
| Trèfle violet | Moyenne/mauvaise | Bonne | Bonne/moyenne |

### 18.3 Besoins nutritifs graminées (Kg/Tonne de rendement)

| Espèce | N | P | K | Ca | Mg | S |
|--------|---|---|---|----|----|---|
| Ray-grass Italie | 20/25 | 6/8 | 15/20 | 6/8 | 1/3 | 1/3 |
| Ray-grass anglais | 20/25 | 6/8 | 15/20 | 6/8 | 1/3 | 1/3 |
| Dactyle | 20/25 | 6/8 | 15/20 | 6/8 | 1/3 | 1/3 |
| Fétuque élevée | 20/25 | 6/8 | 15/20 | 6/8 | 1/3 | 1/3 |
| Fléole | 20/25 | 6/8 | 15/20 | 6/8 | 1/3 | 1/3 |
| Brome | 20/25 | 6/8 | 15/20 | 6/8 | 1/3 | 1/3 |
| Trèfle blanc | 0 | 6/8 | 17/23 | 17/23 | 5/7 | 1/3 |
| Trèfle violet | 0 | 6/8 | 17/23 | 17/23 | 5/7 | 1/3 |

---

## 19. Fromagerie et Foie gras

### 19.1 Fromagerie — Conversion

| Conversion | Ratio |
|-----------|-------|
| 1 L lait → fromage | 0.1 kg |
| 1 L lait → crème | 0.0375 L |
| 1 L crème → beurre | 0.480 kg |

### 19.2 Types de fromagerie

| Type | Coût | Transformation/jour | HT max/jour | Vente |
|------|------|--------------------|-----------|----|
| Artisanale | 20 800 – 100 000 € | 250 – 1 250 L | 25 | Marchés |
| Industrielle | 198 000 – 910 000 € | 2 200 – 11 000 L | 220 | Grossistes/centrales |

### 19.3 Affinage et DLC (jours Cultivia)

| Type de fromage | Affinage min-max | DLC |
|----------------|-----------------|-----|
| Pâte Molle Croûte Fleurie | 4-10 | 7 |
| Pâte Molle Croûte Lavée | 4-10 | 7 |
| Pâte Pressée Cuite | 21-84 | 11 |
| Pâte Pressée Non Cuite | 14-84 | 11 |
| Pâte Persillée | 14-42 | 7 |
| Fromage de Chèvre | 4-9 | 7 |
| Crème | — | 7 |
| Beurre | — | 18 |

### 19.4 Foie gras — Races concernées

| Oies | Canards |
|------|---------|
| Oie d'Alsace | Canard de Barbarie |
| Oie Grise des Landes | |
| Oie de Toulouse | |

### 19.5 Foie gras — Cycle de production

| Phase | Oie | Canard |
|-------|-----|--------|
| Démarrage (0-1 mois) | 7 jours | 7 jours |
| Croissance (1-2 mois) | 7 jours | 7 jours |
| Préparation gavage (2-3 mois) | 7 jours | 7 jours |
| Gavage | 4 jours | 3 jours |
| **Total** | **25 jours** | **24 jours** |

### 19.6 Foie gras — Rations élevage (kg/jour)

**Oisons (foie gras) :**

| Phase | Blé/trit. | Maïs grain | Avoine | Min.&Vit. | Eau (L) | Ration complète |
|-------|-----------|------------|--------|-----------|---------|-----------------|
| 0-1 mois | 0.180 | 0.054 | 0.054 | 0.012 | 0.8 | 0.313 |
| 1-2 mois | 0.600 | 0.180 | 0.180 | 0.040 | 0.8 | 1.05 |
| 2-3 mois | 0.780 | 0.234 | 0.234 | 0.052 | 0.8 | 1.36 |
| Gavage | — | 5.5 | — | — | 0.8 | — |

**Canetons (foie gras) :**

| Phase | Maïs grain | Blé/trit. | Soja | Min.&Vit. | Eau (L) | Ration complète |
|-------|------------|-----------|------|-----------|---------|-----------------|
| 0-1 mois | 0.180 | 0.054 | 0.054 | 0.012 | 2 | 0.315 |
| 1-2 mois | 0.600 | 0.180 | 0.180 | 0.040 | 2 | 1.04 |
| 2-3 mois | 0.780 | 0.234 | 0.234 | 0.052 | 2 | 1.36 |
| Gavage | 4 | — | — | — | 2 | — |

### 19.7 Foie gras — Poids et commercialisation

| Donnée | Oie | Canard |
|--------|-----|--------|
| Poids moyen foie | 0.700 kg | 0.400 kg |
| Prix carcasse | 2.50 €/kg | 2.50 €/kg |
| HT abattage | 0.25 | 0.25 |
| HT gavage | 0.27/animal | 0.0625/animal |
| Délai abattage après gavage | 4 jours max | 4 jours max |

### 19.8 Foie gras — Produits transformés

| Produit | HT/kg | Emballage/kg | Conservation (jours) | Stockage | Prix moyen (indice 50, €/kg) |
|---------|-------|-------------|---------------------|----------|------------------------------|
| Non préparé | 0 | 0 | 2 | — | 22.50 |
| Sous vide | 1 | 1.00 € | 5 | Chambre froide +2° | 82.50 |
| Mi-cuit conserve | 1 | 3.00 € | 42 | Chambre froide +2° | 95.00 |
| Conserve | 1.5 | 3.00 € | 252 | T° ambiante (salle stockage) | 102.50 |

---

*Fin du fichier de référence CONTENT DATA.*
