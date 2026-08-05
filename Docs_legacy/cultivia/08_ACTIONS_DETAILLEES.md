# 08 — ACTIONS DÉTAILLÉES — Spécification complète

> Document de référence pour le développement de Cultivia
> Généré le 2026-04-08 — Version 2.0
> Chaque action décrit : déclencheur, prérequis, étapes UI, validations serveur, impacts BDD, coûts HT/€, effets secondaires.

---

## TABLE DES MATIÈRES

1. [ÉLEVAGE](#1-élevage)
2. [CULTURES](#2-cultures)
3. [MATÉRIEL](#3-matériel)
4. [BÂTIMENTS](#4-bâtiments)
5. [COMMERCE](#5-commerce)
6. [FINANCE](#6-finance)
7. [TRANSPORT](#7-transport)
8. [CONCESSIONNAIRE](#14-concessionnaire)
9. [CIA](#15-cia-centre-dinsémination-artificielle)
10. [FROMAGERIE](#16-fromagerie)
11. [MARAÎCHAGE](#17-maraîchage)
12. [VITICULTURE](#18-viticulture)
13. [FORÊTS / ETF](#19-forêts--etf)
14. [CAR](#20-car-coopérative-agricole-régionale)
15. [MÉTHANISATION](#21-méthanisation)
16. [FOIE GRAS](#22-foie-gras)

---

## Légende

| Sigle | Signification |
|-------|---------------|
| HT | Heures de Travail (ressource temps du joueur, 35 HT/jour) |
| PA | Points d'Action (alias HT dans SimAgri, même concept) |
| HVC | Huile Végétale Carburant (carburant des machines) |
| € | Monnaie virtuelle du jeu |
| BDD | Base de données |
| CV | Chevaux (puissance tracteur) |

---

## 1. ÉLEVAGE

> ~22 actions couvrant l'alimentation, l'abreuvement, la litière, les soins, la traite, la collecte, la reproduction, le déplacement et le commerce d'animaux.

---

### ACTION: [ELV-001] Nourrir animaux (manuel)
**Déclencheur** : Onglet `Animaux` → icône 🍽️ nourrir sur la ligne de l'espèce concernée
**Prérequis** :
- Au moins 1 animal vivant dans un bâtiment
- Stock de ration standard OU ingrédients pour ration libre
- HT suffisants (variable selon nb d'animaux)
**Étapes** :
1. Cliquer sur l'icône nourrir de l'espèce (ex: bovins laitiers)
2. Sélectionner le bâtiment cible (si plusieurs)
3. Choisir le type de ration :
   - **Ration standard** : item unique, pas de composition, production normale (100%)
   - **Ration libre** : composer avec ingrédients (énergie/protéines/fibres/minéraux), bonus +10 à +30%
4. Si ration libre : ajuster les quantités de chaque ingrédient, voir les jauges des 4 besoins
5. Le système affiche la quantité nécessaire et le stock disponible
6. Confirmer l'action « Nourrir »
**Validations serveur** :
- Vérifier que le joueur possède assez de HT
- Vérifier stock suffisant (ration standard OU chaque ingrédient de la ration libre)
- Vérifier que les animaux n'ont pas déjà été nourris aujourd'hui
- Si ration libre : calculer couverture des 4 besoins → déterminer bonus (0/+10/+20/+30%)
- Si élevage bio : vérifier que la ration est composée d'ingrédients bio
**Impacts** :
- BDD: `animaux.nourri_aujourd_hui = true`, `animaux.ration_bonus = 0|10|20|30`, `silos.stock -= quantité_consommée`, `joueur.ht -= coût_ht`
- HT: Variable selon nombre d'animaux et espèce (~1-3 HT par action)
- €: 0 € (la ration a été achetée au préalable)
- Effets: Mise à jour de l'état de santé des animaux, influence sur la croissance et la production laitière. Si non nourri → risque maladie le lendemain. Si ration libre avec bonus → le bonus s'applique à la production lait et à la vitesse de croissance jusqu'au prochain nourrissage.

---

### ACTION: [ELV-002] Nourrir animaux (robot d'alimentation)
**Déclencheur** : Automatique chaque jour si robot actif et stock suffisant
**Prérequis** :
- Robot d'alimentation acheté (185 000 €) et installé
- Stock de ration suffisant dans les silos
- Robot non en panne
**Étapes** :
1. Aller dans `Animaux` → section « Robot d'alimentation »
2. Activer le robot pour l'espèce souhaitée
3. Configurer la durée d'alimentation automatique (1 à 15 jours)
4. Valider la configuration
**Validations serveur** :
- Vérifier possession du robot d'alimentation
- Vérifier stock ration ≥ quantité nécessaire × nb jours programmés
- Vérifier que le robot n'est pas en panne
**Impacts** :
- BDD: `robot_alimentation.actif = true`, `robot_alimentation.jours_restants = N`, chaque jour : `silos.stock -= quantité`, `animaux.nourri = true`
- HT: 0 HT (le robot travaille automatiquement)
- €: 0 € (ration déjà en stock, robot déjà acheté)
- Effets: Économie de HT quotidiens. Le robot consomme de l'énergie électrique (kWh). Si stock insuffisant un jour → animaux non nourris ce jour-là, notification d'alerte.

---

### ACTION: [ELV-003] Abreuver (cuve à eau en bâtiment)
**Déclencheur** : Onglet `Bâtiments` → cuve à eau → bouton « Remplir »
**Prérequis** :
- Cuve à eau construite (accessoire bâtiment)
- Source d'eau : robinet (eau courante) ou récupération eau de pluie via toitures
- Argent disponible si remplissage eau du robinet
**Étapes** :
1. Aller dans `Bâtiments` → onglet Accessoires → filtre « Cuves à eau »
2. Cliquer sur « Remplir » à côté de la cuve
3. Choisir la quantité à remplir (en litres)
4. Confirmer le remplissage
**Validations serveur** :
- Vérifier que la cuve n'est pas déjà pleine
- Vérifier capacité restante de la cuve
- Vérifier solde € suffisant pour le coût de l'eau
**Impacts** :
- BDD: `cuves_eau.niveau += quantité_remplie`, `joueur.solde -= coût_eau`
- HT: 0 HT (remplissage automatique)
- €: Coût de l'eau au robinet (faible, ~0.01 €/litre)
- Effets: Les animaux dans le bâtiment associé sont abreuvés automatiquement tant que la cuve contient de l'eau. Si cuve vide → animaux non abreuvés → risque maladie.

---

### ACTION: [ELV-004] Abreuver (bac à eau au pré)
**Déclencheur** : Onglet `Parcelles` → onglet Eau → bouton « Remplir bac »
**Prérequis** :
- Bac à eau installé dans la parcelle (pré)
- Tonne à eau tractée (tracteur + tonne à eau) OU canalisation installée OU source naturelle dans la parcelle
- Animaux présents au pré
**Étapes** :
1. Aller dans `Parcelles` → sélectionner le pré → onglet « Eau »
2. Voir le niveau actuel du bac (Nécessaire vs Disponible en litres)
3. Si remplissage par tonne à eau : sélectionner tracteur + tonne à eau, confirmer
4. Si canalisation : le remplissage est automatique
5. Si source naturelle : remplissage automatique gratuit
**Validations serveur** :
- Vérifier présence d'un bac à eau dans la parcelle
- Si tonne à eau : vérifier possession tracteur + tonne à eau, vérifier HT et HVC suffisants
- Vérifier que le bac n'est pas déjà plein
**Impacts** :
- BDD: `bacs_eau.niveau += quantité`, `joueur.ht -= coût_ht_trajet`, `cuves_hvc.stock -= consommation_hvc`
- HT: Trajet tracteur : 0.25 HT/zone + temps de remplissage (~1 HT)
- €: Coût HVC du trajet (0.05 L/CV/HT × puissance tracteur)
- Effets: Consommation HVC du tracteur. Si canalisation : 0 HT, remplissage auto quotidien.

---

### ACTION: [ELV-005] Pailler litière (pailleuse mécanique)
**Déclencheur** : Onglet `Animaux` → sous-menu « Soins/Propretés » → bouton « Pailler »
**Prérequis** :
- Tracteur + pailleuse (matériel tracté)
- Stock de paille en hangar ou entrepôt
- Animaux en bâtiment avec litière paille (pas caillebotis)
- HT et HVC suffisants
**Étapes** :
1. Aller dans `Animaux` → « Soins/Propretés »
2. Sélectionner le bâtiment à pailler
3. Le système affiche la quantité de paille nécessaire
4. Sélectionner le tracteur et la pailleuse à utiliser
5. Confirmer l'action « Pailler »
**Validations serveur** :
- Vérifier possession tracteur + pailleuse compatibles
- Vérifier stock paille ≥ quantité nécessaire
- Vérifier HT suffisants
- Vérifier HVC suffisant pour le tracteur
- Vérifier que le bâtiment est sur litière (pas caillebotis)
**Impacts** :
- BDD: `batiments.litiere_ok = true`, `stocks.paille -= quantité`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso_hvc`, `batiments.fumier += quantité_transformée`
- HT: ~1-2 HT selon taille du bâtiment
- €: Coût HVC (0.08-0.20 L/CV/HT × puissance tracteur)
- Effets: La paille se transforme progressivement en fumier. Sans paillage → risque maladie animaux. Alternative : bois déchiqueté (30% de la quantité paille).

---

### ACTION: [ELV-006] Pailler litière (manuel)
**Déclencheur** : Onglet `Animaux` → « Soins/Propretés » → bouton « Pailler manuellement »
**Prérequis** :
- Stock de paille disponible
- Animaux en bâtiment avec litière paille
- HT suffisants (plus coûteux en HT que la pailleuse)
**Étapes** :
1. Aller dans `Animaux` → « Soins/Propretés »
2. Sélectionner le bâtiment
3. Cocher l'option « Manuel » dans le formulaire
4. Confirmer
**Validations serveur** :
- Vérifier stock paille suffisant
- Vérifier HT suffisants (coût HT majoré vs pailleuse)
- Vérifier bâtiment sur litière
**Impacts** :
- BDD: `batiments.litiere_ok = true`, `stocks.paille -= quantité`, `joueur.ht -= coût_ht`
- HT: ~2-4 HT (environ le double du mode mécanique)
- €: 0 € (pas de consommation HVC)
- Effets: Même résultat que pailleuse mais plus coûteux en HT. Pas de consommation HVC.

---

### ACTION: [ELV-007] Retirer fumier
**Déclencheur** : Menu `Animaux` → lien « Retirer fumier »
**Prérequis** :
- Fumier accumulé dans un bâtiment d'élevage (litière paille)
- Chargeur frontal ou télescopique
- Tracteur
- Benne
- Fosse à fumier OU parcelle disponible pour épandage direct
- HT et HVC suffisants
**Étapes** :
1. Accéder à la page « Retirer fumier »
2. Sélectionner le chargeur (frontal ou télescopique)
3. Sélectionner le tracteur
4. Sélectionner la benne
5. Choisir la destination : fosse à fumier ou parcelle
6. Indiquer la quantité à retirer (en tonnes)
7. Le système calcule le coût HT et HVC
8. Confirmer l'action
**Validations serveur** :
- Vérifier possession chargeur + tracteur + benne
- Vérifier fumier disponible dans le bâtiment > 0
- Vérifier capacité de la fosse à fumier (si destination = fosse)
- Vérifier HT et HVC suffisants
- Vérifier compatibilité matériel (puissance tracteur vs benne)
**Impacts** :
- BDD: `batiments.fumier -= quantité`, `fosses_fumier.stock += quantité` (ou `parcelles.fumier_epandu += quantité`), `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: ~2-4 HT selon quantité et distance
- €: Coût HVC (trajet + travail chargeur + tracteur)
- Effets: Libère de l'espace dans le bâtiment. Le fumier en fosse peut être composté ou épandu ultérieurement. Épandage direct : 25 T/ha avec épandeur à fumier.

---

### ACTION: [ELV-008] Retirer lisier
**Déclencheur** : Menu `Animaux` → lien « Retirer lisier »
**Prérequis** :
- Élevage porcin sur caillebotis (seule source de lisier)
- Fosse à lisier construite
- HT suffisants
**Étapes** :
1. Accéder à la page « Retirer lisier »
2. Le système affiche le volume de lisier accumulé (en litres)
3. Choisir la quantité à transférer vers la fosse
4. Confirmer l'action
**Validations serveur** :
- Vérifier élevage porcin sur caillebotis
- Vérifier lisier disponible > 0
- Vérifier capacité fosse à lisier suffisante
- Vérifier HT suffisants
**Impacts** :
- BDD: `batiments.lisier -= quantité`, `fosses_lisier.stock += quantité`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT
- €: 0 € (transfert gravitaire, pas de matériel motorisé)
- Effets: Le lisier en fosse peut être épandu : 15 m³/ha (15 000 litres) avec tonne à lisier. Purge possible des fosses (coût : 0.001 €/litre).

---

### ACTION: [ELV-009] Traire
**Déclencheur** : Onglet `Animaux` → « Mes productions » → bouton « Traire »
**Prérequis** :
- Animaux laitiers adultes femelles (vaches, chèvres, brebis laitières)
- Salle de traite construite (accessoire bâtiment)
- Cuve à lait (tank) avec capacité disponible
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Mes productions »
2. Sélectionner l'espèce à traire
3. Le système affiche la production estimée (litres) et la capacité restante du tank
4. Confirmer la traite
**Validations serveur** :
- Vérifier possession salle de traite + cuve à lait
- Vérifier présence d'animaux laitiers adultes femelles en lactation
- Vérifier capacité restante de la cuve à lait
- Vérifier HT suffisants
- Vérifier que la traite n'a pas déjà été faite à ce créneau (max 4 traites/jour : avant 6h, 12h, 18h, 24h)
**Impacts** :
- BDD: `cuves_lait.stock += litres_produits`, `joueur.ht -= coût_ht`, `animaux.derniere_traite = timestamp`
- HT: ~1-2 HT par traite
- €: 0 € direct (le lait sera vendu via contrat laiterie)
- Effets: Production de lait variable selon race, ration (standard 100% ou libre +10 à +30%), indice génétique Lait et QL. Lait bio si élevage bio (+20% prix). Non obligatoire : pas d'impact santé si pas de traite. Consommation énergie salle de traite.

---

### ACTION: [ELV-010] Collecter œufs
**Déclencheur** : Onglet `Animaux` → « Mes productions » → bouton « Collecter les œufs »
**Prérequis** :
- Poules pondeuses ou canes en production (adultes)
- Salle de conditionnement (emballage œufs) construite
- Pièce de stockage œufs construite avec capacité disponible
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Mes productions »
2. Le système affiche le nombre d'œufs à collecter
3. Confirmer la collecte
**Validations serveur** :
- Vérifier possession salle conditionnement + pièce stockage œufs
- Vérifier présence de volailles/canes pondeuses adultes
- Vérifier capacité stockage œufs suffisante
- Vérifier HT suffisants
- Vérifier 1 seule collecte par jour maximum
- Canes : ponte uniquement de janvier à septembre
**Impacts** :
- BDD: `stockage_oeufs.quantite += nb_oeufs`, `joueur.ht -= coût_ht`, `animaux.oeufs_collectes_aujourd_hui = true`
- HT: ~1 HT
- €: 0 € direct (œufs vendus ultérieurement)
- Effets: Nombre d'œufs dépend de l'indice génétique Œuf. Œufs bio si élevage bio (+20% prix). Pack « Traite et ramassage œufs » permet d'automatiser.

---

### ACTION: [ELV-011] Tondre laine / Collecter duvet
**Déclencheur** : Onglet `Animaux` → « Mes productions » → bouton « Tondre » ou « Collecter duvet »
**Prérequis** :
- Ovins à laine, lapins Angora, caprins Angora (laine) OU oies/canards (duvet)
- Pièce de stockage laine/duvet construite
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Mes productions »
2. Sélectionner l'espèce (ovins/lapins/caprins pour laine, oies/canards pour duvet)
3. Le système affiche la quantité récoltable (kg)
4. Confirmer la tonte/collecte
**Validations serveur** :
- Vérifier présence d'animaux adultes producteurs de laine/duvet
- Vérifier pièce de stockage laine avec capacité suffisante
- Vérifier HT suffisants
- Vérifier que la tonte n'a pas déjà été faite récemment (fréquence selon espèce)
**Impacts** :
- BDD: `stockage_laine.quantite += kg_produits`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT
- €: 0 € direct (laine/duvet vendu ultérieurement)
- Effets: Quantité dépend de l'indice génétique Laine/Duvet. Bio = +20% prix de vente.

---

### ACTION: [ELV-012] Appeler vétérinaire
**Déclencheur** : Onglet `Animaux` → « Soins/Propretés » → bouton « Appeler le vétérinaire » sur un animal malade
**Prérequis** :
- Au moins 1 animal malade (icône maladie visible)
- HT suffisants
- Argent suffisant
**Étapes** :
1. Aller dans `Animaux` → « Soins/Propretés » ou tableau de bord « Animaux malades pas encore soignés »
2. Identifier l'animal malade
3. Cliquer sur « Appeler le vétérinaire »
4. Confirmer l'appel (coût HT + €)
**Validations serveur** :
- Vérifier que l'animal est effectivement malade
- Vérifier HT suffisants
- Vérifier solde € suffisant
**Impacts** :
- BDD: `animaux.malade = false`, `animaux.soigne = true`, `joueur.ht -= coût_ht`, `joueur.solde -= coût_veterinaire`
- HT: ~1 HT par animal soigné
- €: Variable selon espèce (~50-200 € par animal)
- Effets: L'animal retrouve la santé, reprend sa croissance et sa production. Un animal malade ne grandit pas, ne produit pas de lait/œufs, ne peut pas être inséminé.

---

### ACTION: [ELV-013] Vacciner
**Déclencheur** : Onglet `Animaux` → « Soins/Propretés » → bouton « Vacciner »
**Prérequis** :
- Animaux non vaccinés ou vaccination expirée (>1 an)
- HT suffisants
- Argent suffisant
**Étapes** :
1. Aller dans `Animaux` → « Soins/Propretés »
2. Sélectionner les animaux à vacciner (par espèce ou individuellement)
3. Le système affiche le coût total (HT + €)
4. Confirmer la vaccination
**Validations serveur** :
- Vérifier que les animaux ne sont pas déjà vaccinés (vaccination valide 1 an)
- Vérifier HT et € suffisants
**Impacts** :
- BDD: `animaux.vaccine = true`, `animaux.date_vaccination = now()`, `joueur.ht -= coût_ht`, `joueur.solde -= coût_vaccination`
- HT: ~0.5-1 HT par lot d'animaux
- €: Variable selon espèce et nombre (~10-50 € par animal)
- Effets: Protection contre toute maladie pendant 1 an Cultivia. Préventif : évite les pertes de production et les frais vétérinaires.

---

### ACTION: [ELV-014] Mettre au pré (bétaillère)
**Déclencheur** : Onglet `Animaux` → sélection d'animaux → bouton « Mettre au pré »
**Prérequis** :
- Animaux éligibles au plein air (bovins, ovins, caprins, équidés, porcins avec abris)
- Saison compatible (Avr-Oct pour la plupart, toute l'année pour allaitants)
- Parcelle (pré) disponible avec capacité suffisante
- Bétaillère + tracteur (pour bovins, porcins, ovins, caprins)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner les animaux à déplacer dans la liste
2. Cliquer « Mettre au pré »
3. Sélectionner la parcelle de destination
4. Sélectionner le tracteur et la bétaillère
5. Le système calcule le trajet (distance en zones) et le coût
6. Confirmer le déplacement
**Validations serveur** :
- Vérifier saison compatible pour l'espèce
- Vérifier capacité du pré (surface suffisante)
- Vérifier possession bétaillère + tracteur compatibles
- Vérifier HT suffisants (0.25 HT/zone de trajet + temps chargement)
- Vérifier HVC suffisant
- Vérifier que les animaux ne sont pas malades
**Impacts** :
- BDD: `animaux.localisation = 'pré'`, `animaux.parcelle_id = X`, `parcelles.nb_animaux += N`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: 0.25 HT dans sa zone + 0.25 HT par zone supplémentaire + ~1 HT chargement/déchargement
- €: Coût HVC du trajet
- Effets: Animaux au pré se nourrissent d'herbe (Avr-Oct). Éligibilité label « Plein-air » (+5% prix vente) si >3 mois et >50% vie dehors. Éligibilité bio si >50% temps au pré.

---

### ACTION: [ELV-015] Mettre au pré (chien de berger)
**Déclencheur** : Onglet `Animaux` → « Mon chien » → bouton « Déplacer au pré »
**Prérequis** :
- Chien de berger acheté (600 €, 1 seul par ferme)
- Animaux éligibles (ovins, caprins, bovins)
- Parcelle dans le même département/zone que la ferme
- Saison compatible
**Étapes** :
1. Aller dans `Animaux` → « Mon chien »
2. Sélectionner les animaux à déplacer
3. Sélectionner la parcelle de destination (même département uniquement)
4. Confirmer le déplacement
**Validations serveur** :
- Vérifier possession d'un chien de berger
- Vérifier que la parcelle est dans le même département
- Vérifier saison compatible
- Vérifier capacité du pré
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.localisation = 'pré'`, `animaux.parcelle_id = X`, `joueur.ht -= coût_ht`
- HT: ~1 HT (pas de trajet motorisé)
- €: 0 € (pas de consommation HVC)
- Effets: Alternative économique à la bétaillère pour les déplacements locaux. Limité au même département.

---

### ACTION: [ELV-016] Rentrer au bâtiment
**Déclencheur** : Onglet `Parcelles` → onglet Animaux → bouton « Rentrer au bâtiment »
**Prérequis** :
- Animaux actuellement au pré
- Bâtiment d'élevage avec capacité disponible
- Bétaillère + tracteur OU chien de berger (même département)
- HT et HVC suffisants
**Étapes** :
1. Aller dans `Parcelles` → sélectionner le pré → onglet « Animaux »
2. Sélectionner les animaux à rentrer
3. Choisir le mode de transport : bétaillère ou chien
4. Sélectionner le bâtiment de destination
5. Confirmer
**Validations serveur** :
- Vérifier capacité du bâtiment de destination
- Vérifier matériel de transport disponible
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.localisation = 'bâtiment'`, `animaux.batiment_id = X`, `parcelles.nb_animaux -= N`, `joueur.ht -= coût_ht`
- HT: Identique à « Mettre au pré » selon mode de transport
- €: Coût HVC si bétaillère
- Effets: Nécessaire avant l'hiver pour les espèces non allaitantes. Obligatoire pour la traite (salle de traite en bâtiment).

---

### ACTION: [ELV-017] Acheter animal (coopérative Cultivia)
**Déclencheur** : Onglet `Coopérative` → menu « Animaux » → bouton « Acheter »
**Prérequis** :
- Bâtiment d'élevage adapté à l'espèce avec capacité disponible
- Argent suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Coopérative` → onglet « Animaux »
2. Filtrer par espèce et race
3. Consulter les prix fixes Cultivia (toujours disponibles)
4. Sélectionner le nombre d'animaux à acheter
5. Choisir le bâtiment de destination
6. Confirmer l'achat
**Validations serveur** :
- Vérifier capacité bâtiment suffisante
- Vérifier solde € suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: Création entrées `animaux` (espèce, race, âge, sexe, indices génétiques aléatoires), `batiments.nb_animaux += N`, `joueur.solde -= prix_total`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Prix fixe Cultivia selon espèce/race/âge (ex: vache Prim'Holstein adulte ~1 500 €)
- Effets: Animaux livrés dans l'enclos d'arrivage, à placer dans un bâtiment. Indices génétiques moyens (aléatoires).

---

### ACTION: [ELV-018] Acheter animal (marché régional/national)
**Déclencheur** : Onglet `Animaux` → « Marché » → bouton « Acheter » sur une annonce
**Prérequis** :
- Bâtiment adapté avec capacité
- Argent suffisant
- Marché ouvert (régional : J1,2,4,5 / national : J3,6,7)
**Étapes** :
1. Aller dans `Animaux` → « Marché »
2. Filtrer par espèce, race, région, prix
3. Consulter les fiches des animaux (indices génétiques visibles)
4. Cliquer « Acheter » sur l'animal souhaité
5. Confirmer l'achat au prix affiché
**Validations serveur** :
- Vérifier que l'animal est toujours disponible (pas déjà vendu)
- Vérifier capacité bâtiment
- Vérifier solde € suffisant
- Vérifier jour de marché correct (régional vs national)
**Impacts** :
- BDD: `animaux.proprietaire_id = acheteur`, `joueur_acheteur.solde -= prix`, `joueur_vendeur.solde += prix`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Prix fixé par le vendeur (joueur)
- Effets: Transport nécessaire (transporteur ou auto-transport). Indices génétiques connus à l'achat. Notification au vendeur.

---

### ACTION: [ELV-019] Acheter animal (négociant)
**Déclencheur** : Onglet `Animaux` → « Marché » → section « Négociant » → bouton « Commander »
**Prérequis** :
- Maximum 4 races commandables par mois
- Uniquement des animaux adultes
- Argent suffisant
- Bâtiment adapté
**Étapes** :
1. Aller dans `Animaux` → « Marché » → onglet « Négociant »
2. Sélectionner l'espèce et la race (max 4 races/mois)
3. Indiquer le nombre d'animaux souhaités
4. Confirmer la commande
5. Livraison sous quelques jours
**Validations serveur** :
- Vérifier limite de 4 races/mois non atteinte
- Vérifier solde € suffisant
- Vérifier capacité bâtiment
**Impacts** :
- BDD: Création `animaux` avec indices génétiques moyens, `joueur.solde -= prix`
- HT: ~1 HT
- €: Prix négociant (légèrement supérieur à la coopérative)
- Effets: Animaux non revendables sur le marché (abattoir uniquement). Livraison différée. Utile pour démarrer rapidement un élevage.

---

### ACTION: [ELV-020] Vendre animal (abattoir)
**Déclencheur** : Onglet `Animaux` → sélection animal → bouton « Vendre à l'abattoir »
**Prérequis** :
- Animal adulte ou à poids suffisant
- HT suffisants
**Étapes** :
1. Sélectionner l'animal dans la liste
2. Cliquer « Vendre à l'abattoir »
3. Le système affiche l'estimation du prix : poids carcasse × prix/kg × qualité
4. Confirmer la vente
**Validations serveur** :
- Vérifier que l'animal est vivant et en état d'être vendu
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.statut = 'vendu_abattoir'`, `joueur.solde += prix_vente`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT par animal
- €: Prix = Poids carcasse (rendement 45-80% selon espèce) × prix/kg × conformation (A→E) × engraissement (optimal=3) × valorisation génétique (+1 à +10%)
- Effets: Labels appliqués si éligibles : Plein-air (+5%), Bio (+20%), Veau/Agneau sous la mère (+1.50/+0.30 €/kg). Statistiques carcasse mises à jour. Animal retiré de l'élevage.

---

### ACTION: [ELV-021] Vendre animal (marché privé)
**Déclencheur** : Onglet `Animaux` → sélection animal → bouton « Vendre en privé »
**Prérequis** :
- Ami spécial (relation réciproque)
- Animal vivant
- HT suffisants
**Étapes** :
1. Sélectionner l'animal
2. Cliquer « Vendre en privé »
3. Sélectionner l'ami spécial destinataire
4. Fixer le prix de vente
5. Confirmer l'offre
6. L'ami reçoit une notification et peut accepter ou refuser
**Validations serveur** :
- Vérifier relation « ami spécial » réciproque
- Vérifier que l'animal est vivant
- Vérifier HT suffisants
**Impacts** :
- BDD: Création `offre_privee`, puis si acceptée : `animaux.proprietaire_id = acheteur`, transfert €
- HT: ~0.5 HT
- €: Prix libre fixé par le vendeur
- Effets: Notification à l'ami. Transport nécessaire après acceptation. Pas de commission.

---

### ACTION: [ELV-022] Inséminer (artificielle — CIA)
**Déclencheur** : Onglet `Animaux` → « CIA et contrats » → bouton « Commander une insémination »
**Prérequis** :
- Femelle adulte en âge de reproduction (ex: vache ≥27 mois)
- Femelle non gestante, non malade
- Délai minimum entre mises bas respecté (ex: bovins 3 mois)
- Contrat avec un CIA (Centre d'Insémination Artificielle) joueur ou Cultivia
- Saison compatible pour espèces saisonnières (oies: Jan-Fév, pintades: Mars, canes: Avril, bisonnes: Jul-Oct, daines: Octobre)
**Étapes** :
1. Aller dans `Animaux` → « CIA et contrats »
2. Consulter l'annuaire CIA ou le GenBook (catalogue génétique)
3. Sélectionner un mâle reproducteur (indices génétiques visibles)
4. Sélectionner la/les femelle(s) à inséminer
5. Confirmer la commande
6. L'inséminateur du CIA vient réaliser l'insémination
**Validations serveur** :
- Vérifier âge reproduction atteint
- Vérifier femelle non gestante et non malade
- Vérifier délai entre mises bas respecté
- Vérifier saison compatible (espèces saisonnières)
- Vérifier stock de doses du CIA > 0
- Vérifier solde € suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.gestante = true` (si réussite), `animaux.date_mise_bas = now() + durée_gestation`, `joueur.solde -= prix_dose`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Prix de la dose (0.50-120 € selon espèce/race/qualité génétique du mâle)
- Effets: Gestation démarre si réussite (taux variable). Indices génétiques du petit = moyenne parents ± variation. Notification de confirmation. Durée gestation selon espèce (bovins: 9 mois, porcins: 4 mois, etc.).

---

### ACTION: [ELV-023] Inséminer (artificielle — Cultivia direct)
**Déclencheur** : Onglet `Animaux` → sélection femelle(s) → bouton « Inséminer » → choisir « Insémination Cultivia »
**Prérequis** :
- Femelle adulte en âge de reproduction (bovins ≥27 mois, caprins/ovins ≥12 mois, porcins ≥12 mois, lapins ≥3 mois, volailles ≥6 mois, chevaux ≥36 mois)
- Femelle non gestante, non malade
- Délai minimum entre mises bas respecté
- Saison compatible pour espèces saisonnières
- Solde € suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → sélectionner l'espèce
2. Sélectionner la/les femelle(s) à inséminer (checkbox)
3. Cliquer « Inséminer »
4. Choisir **« Insémination Cultivia »** (pas besoin de contrat CIA)
5. Sélectionner la race du mâle (même race que la femelle obligatoire)
6. Le système affiche : coût de la dose, indices génétiques moyens du mâle Cultivia
7. Confirmer
8. L'insémination est réalisée immédiatement (pas d'attente d'inséminateur joueur)
**Validations serveur** :
- Vérifier âge reproduction atteint selon espèce
- Vérifier femelle non gestante et non malade
- Vérifier délai entre mises bas respecté
- Vérifier saison compatible (oies: Jan-Fév, pintades: Mars, canes: Avril, bisonnes: Jul-Oct, daines: Octobre)
- Vérifier solde € ≥ prix dose Cultivia
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.gestante = true`, `animaux.date_insemination = now()`, `animaux.date_mise_bas_prevue = now() + duree_gestation`, `animaux.pere_type = 'cultivia'`, `joueur.solde -= prix_dose`, `joueur.ht -= cout_ht`, `INSERT INTO transactions(...)`
- HT: ~0.5 HT par insémination
- €: Prix dose Cultivia (légèrement plus cher qu'un CIA joueur) : taureau ~60€, verrat ~15€, bouc ~25€, bélier ~18€, lapin ~2€, coq ~2€, étalon ~75€
- Effets: Gestation démarre immédiatement. Génétique du mâle Cultivia = moyenne du serveur (pas de sélection génétique fine comme avec un CIA joueur). Avantage : disponible 24h/24, pas besoin de contrat. Inconvénient : génétique moyenne, prix plus élevé. Notification « Insémination réussie ». Pour les espèces à taux de réussite variable (oies: indice fertilité), plusieurs tentatives peuvent être nécessaires.

**Différences avec insémination CIA joueur :**
| | Cultivia direct | CIA joueur |
|---|---|---|
| Disponibilité | Immédiate, 24h/24 | Dépend du CIA (HT inséminateur) |
| Choix du mâle | Non (mâle moyen) | Oui (GenBook, indices visibles) |
| Génétique | Moyenne serveur | Sélectionnable (meilleure) |
| Prix | Plus cher | Négociable (0.50-120€) |
| Contrat requis | Non | Oui (contrat race + animal) |

---

### ACTION: [ELV-024] Inséminer (naturelle)
**Déclencheur** : Onglet `Animaux` → sélection femelle → bouton « Accoupler »
**Prérequis** :
- Mâle reproducteur adulte de même race dans l'élevage
- Femelle adulte en âge de reproduction, non gestante, non malade
- Délai entre mises bas respecté
- Saison compatible (espèces saisonnières)
**Étapes** :
1. Sélectionner la femelle dans la liste
2. Cliquer « Accoupler »
3. Le système propose les mâles disponibles de même race
4. Sélectionner le mâle
5. Confirmer l'accouplement
**Validations serveur** :
- Vérifier présence d'un mâle adulte de même race
- Vérifier conditions de reproduction (âge, délai, santé, saison)
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.gestante = true` (si réussite), `animaux.date_mise_bas = now() + durée_gestation`
- HT: ~0.5 HT
- €: 0 € (pas de dose à acheter)
- Effets: Taux de réussite variable selon espèce. Races IVRAD (rares) : uniquement reproduction naturelle, taux réussite 10-15%. Portée variable selon espèce (bovins: 1, porcins: 6-9, lapins: 6-7, etc.).

---

## 2. CULTURES

> ~20 actions couvrant l'acquisition de parcelles, le travail du sol, les semis, les traitements, la récolte et l'irrigation.

---

### ACTION: [CUL-001] Acheter parcelle
**Déclencheur** : Onglet `Parcelles` → « Achat / Location » → bouton « Acheter » sur une parcelle disponible
**Prérequis** :
- Argent suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Parcelles` → « Achat / Location »
2. Filtrer par type (champs/prés, jardins, vergers, prairies boisées, forêts)
3. Filtrer par région, département, zone
4. Consulter les parcelles disponibles (surface, altitude, inclinaison, qualité sol)
5. Cliquer « Acheter » sur la parcelle souhaitée
6. Confirmer l'achat
**Validations serveur** :
- Vérifier que la parcelle est toujours disponible
- Vérifier solde € suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.proprietaire_id = joueur`, `joueur.solde -= prix_parcelle`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Prix variable selon surface, région, qualité (ex: ~500-2 000 €/ha)
- Effets: La parcelle apparaît dans « Mes parcelles ». Taxe foncière annuelle si >100 ha (fixée par le CECA, ~20 €/ha). Parcelle non travaillée à l'achat.

---

### ACTION: [CUL-002] Louer parcelle
**Déclencheur** : Onglet `Parcelles` → « Achat / Location » → bouton « Louer »
**Prérequis** :
- Argent suffisant pour le loyer
- HT suffisants
**Étapes** :
1. Aller dans `Parcelles` → « Achat / Location »
2. Filtrer les parcelles disponibles à la location
3. Consulter les conditions (loyer mensuel, durée, surface)
4. Cliquer « Louer »
5. Confirmer la location
**Validations serveur** :
- Vérifier parcelle disponible à la location
- Vérifier solde € suffisant pour le premier loyer
**Impacts** :
- BDD: `parcelles.locataire_id = joueur`, `parcelles.date_fin_location = date`, `joueur.solde -= loyer`
- HT: ~0.5 HT
- €: Loyer mensuel variable
- Effets: Parcelle utilisable comme si achetée. Loyer prélevé chaque mois. Pas de taxe foncière (à la charge du propriétaire).

---

### ACTION: [CUL-003] Déchaumer
**Déclencheur** : Onglet `Parcelles` → cliquer sur la parcelle → « Travail possible » → bouton « Déchaumer »
**Prérequis** :
- Parcelle récoltée ou en jachère
- Tracteur + déchaumeur (cover crop ou cultivateur)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle dans la liste
2. Cliquer sur « Travail possible » → « Déchaumer »
3. Sélectionner le tracteur
4. Sélectionner le déchaumeur (cover crop ou cultivateur)
5. Le système calcule le coût HT et HVC selon surface et puissance
6. Confirmer
**Validations serveur** :
- Vérifier état parcelle compatible (récoltée ou jachère)
- Vérifier possession tracteur + déchaumeur
- Vérifier HT suffisants
- Vérifier HVC suffisant
- Vérifier maniabilité matériel vs taille parcelle
**Impacts** :
- BDD: `parcelles.etat = 'déchaumée'`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`, `materiel.usure += usure_travail`
- HT: Variable selon surface (ex: ~2-4 HT pour 10 ha)
- €: Coût HVC = 0.08-0.20 L/CV/HT × puissance tracteur × HT travail. Prix ETA si sous-traitance : 25 €/ha
- Effets: Première étape du cycle cultural traditionnel et TCS. Usure du matériel. Bonus/malus HT selon maniabilité et taille parcelle.

---

### ACTION: [CUL-004] Labourer
**Déclencheur** : Onglet `Parcelles` → parcelle déchaumée → « Travail possible » → bouton « Labourer »
**Prérequis** :
- Parcelle déchaumée (technique traditionnelle uniquement)
- Tracteur + charrue
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle déchaumée
2. Cliquer « Labourer »
3. Sélectionner tracteur + charrue (portée ou frontale, combiné possible : -25% HT)
4. Confirmer
**Validations serveur** :
- Vérifier parcelle en état « déchaumée »
- Vérifier possession tracteur + charrue compatibles
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.etat = 'labourée'`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`, `materiel.usure += usure`
- HT: ~3-6 HT pour 10 ha (travail lourd)
- €: Coût HVC. Prix ETA : 70 €/ha
- Effets: Étape obligatoire en technique traditionnelle. Non nécessaire en TCS ou semis direct. Combiné charrue frontale + portée = -25% HT.

---

### ACTION: [CUL-005] Préparer terre (herse rotative)
**Déclencheur** : Onglet `Parcelles` → parcelle labourée → « Travail possible » → bouton « Préparer la terre »
**Prérequis** :
- Parcelle labourée (traditionnel) ou déchaumée+cultivée (TCS)
- Tracteur + herse rotative
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Préparer la terre »
3. Sélectionner tracteur + herse rotative
4. Confirmer
**Validations serveur** :
- Vérifier état parcelle compatible
- Vérifier possession tracteur + herse rotative
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.etat = 'préparée'`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: ~2-3 HT pour 10 ha
- €: Coût HVC. Prix ETA : 30 €/ha
- Effets: Parcelle prête pour le semis. Peut être combinée avec le semoir (herse+semoir = 2 actions en 1).

---

### ACTION: [CUL-006] Semer (traditionnel)
**Déclencheur** : Onglet `Parcelles` → parcelle préparée → « Travail possible » → bouton « Semer »
**Prérequis** :
- Parcelle préparée (déchaumée → labourée → hersée)
- Tracteur + semoir (ou combiné herse+semoir)
- Semences en stock (achetées à la coopérative)
- Saison de semis compatible avec la culture choisie
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle préparée
2. Cliquer « Semer »
3. Sélectionner la culture (blé, orge, maïs, colza, tournesol, betterave, PDT, lin, herbe, tabac…)
4. Le système vérifie la saison et la rotation (ex: maïs pas 2 ans de suite)
5. Sélectionner tracteur + semoir
6. Confirmer le semis
**Validations serveur** :
- Vérifier parcelle en état « préparée »
- Vérifier saison de semis (ex: blé Oct-Nov, maïs Avr-Mai)
- Vérifier rotation respectée (ex: betterave 1 fois tous les 4 ans)
- Vérifier stock semences suffisant
- Vérifier possession tracteur + semoir
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.culture = 'blé'`, `parcelles.etat = 'semée'`, `parcelles.date_semis = now()`, `stocks.semences -= quantité`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: ~2-3 HT pour 10 ha
- €: Coût HVC + semences déjà achetées. Prix ETA : 30 €/ha
- Effets: La culture commence à pousser. Rendement influencé par : sol (éléments nutritifs + matière organique), météo, traitements, irrigation, technique culturale, région. Technique traditionnelle = meilleur rendement potentiel (+10%).

---

### ACTION: [CUL-007] Semer (TCS — Techniques Culturales Simplifiées)
**Déclencheur** : Onglet `Parcelles` → parcelle préparée (sans labour) → « Semer »
**Prérequis** :
- Parcelle déchaumée → cultivée → hersée (pas de labour)
- Tracteur + cultivateur + herse rotative + semoir
- Semences en stock
- Saison compatible
**Étapes** :
1. Sélectionner la parcelle (état après cultivateur + herse)
2. Cliquer « Semer »
3. Sélectionner la culture
4. Sélectionner le matériel (combiné cultivateur frontal + herse+semoir possible : 3 actions en 1)
5. Confirmer
**Validations serveur** :
- Vérifier parcelle préparée en mode TCS
- Vérifier matériel compatible TCS
- Vérifier saison et rotation
**Impacts** :
- BDD: Identique au semis traditionnel, `parcelles.technique = 'TCS'`
- HT: ~2-3 HT (économie si combiné : -30 à -50% HT)
- €: Coût HVC réduit (moins de passages)
- Effets: Rendement bon/moyen. Coût modéré. Moins d'usure du sol.

---

### ACTION: [CUL-008] Semer (direct)
**Déclencheur** : Onglet `Parcelles` → parcelle récoltée/jachère → « Semer en direct »
**Prérequis** :
- Parcelle récoltée ou en jachère (aucun travail du sol préalable)
- Tracteur + semoir direct
- Semences en stock
- Saison compatible
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Semer en direct »
3. Sélectionner la culture
4. Sélectionner tracteur + semoir direct
5. Confirmer
**Validations serveur** :
- Vérifier possession semoir direct
- Vérifier saison et rotation
- Vérifier stock semences
**Impacts** :
- BDD: `parcelles.culture = X`, `parcelles.technique = 'direct'`, `parcelles.etat = 'semée'`
- HT: ~1-2 HT (un seul passage)
- €: Coût HVC minimal
- Effets: Rendement moyen/faible. Coût très faible. Idéal pour les grandes surfaces avec peu de HT disponibles.

---

### ACTION: [CUL-009] Épandre engrais
**Déclencheur** : Onglet `Parcelles` → parcelle semée → « Travail possible » → bouton « Fertiliser »
**Prérequis** :
- Parcelle avec culture en cours
- Tracteur + épandeur d'engrais
- Engrais en stock (N, P, K, Ca, Mg, S — achetés à la coopérative)
- Analyse de sol recommandée (pour connaître les besoins)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Fertiliser » → choisir « Engrais »
3. Sélectionner le type d'engrais (N, P, K, Ca, Mg, S ou combiné)
4. Indiquer la dose (kg/ha)
5. Sélectionner tracteur + épandeur d'engrais
6. Confirmer
**Validations serveur** :
- Vérifier stock engrais suffisant (dose × surface)
- Vérifier possession tracteur + épandeur
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.engrais_N += dose`, `parcelles.engrais_P += dose`, etc., `stocks.engrais -= quantité`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha
- €: Coût HVC. Prix ETA : 15-20 €/ha. Engrais déjà acheté.
- Effets: Améliore le rendement de la culture. 6 éléments nutritifs à équilibrer. Surdosage possible (pas d'effet négatif mais gaspillage).

---

### ACTION: [CUL-010] Épandre fumier
**Déclencheur** : Onglet `Parcelles` → parcelle → « Fertiliser » → « Fumier »
**Prérequis** :
- Fumier en fosse à fumier (stock > 0)
- Tracteur + épandeur à fumier
- Parcelle disponible
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Fertiliser » → « Fumier »
3. Sélectionner tracteur + épandeur à fumier
4. Le système calcule : 25 T/ha maximum
5. Confirmer
**Validations serveur** :
- Vérifier stock fumier en fosse ≥ quantité nécessaire (25 T × surface ha)
- Vérifier possession tracteur + épandeur à fumier
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `fosses_fumier.stock -= quantité`, `parcelles.fumier_epandu = true`, `parcelles.elements_nutritifs += apports`, `joueur.ht -= coût_ht`
- HT: ~2-4 HT pour 10 ha
- €: Coût HVC. Prix ETA : 35 €/ha
- Effets: Apport en éléments nutritifs (N, P, K principalement). Fumier bio si élevage bio. Dose max : 25 T/ha.

---

### ACTION: [CUL-011] Épandre lisier
**Déclencheur** : Onglet `Parcelles` → parcelle → « Fertiliser » → « Lisier »
**Prérequis** :
- Lisier en fosse à lisier (stock > 0)
- Tracteur + tonne à lisier
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Fertiliser » → « Lisier »
3. Sélectionner tracteur + tonne à lisier
4. Le système calcule : 15 m³/ha (15 000 litres) maximum
5. Confirmer
**Validations serveur** :
- Vérifier stock lisier ≥ 15 000 L × surface ha
- Vérifier possession tracteur + tonne à lisier
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `fosses_lisier.stock -= quantité`, `parcelles.lisier_epandu = true`, `parcelles.elements_nutritifs += apports`
- HT: ~2-4 HT pour 10 ha
- €: Coût HVC
- Effets: Apport en azote principalement. Lisier bio si élevage bio. Dose max : 15 m³/ha.

---

### ACTION: [CUL-012] Traiter (pulvérisateur)
**Déclencheur** : Onglet `Parcelles` → parcelle avec culture → « Travail possible » → bouton « Traiter »
**Prérequis** :
- Culture en cours sur la parcelle
- Tracteur + pulvérisateur (+ cuve frontale optionnelle pour combiné : -25% HT)
- Produit de traitement en stock (herbicide, fongicide, insecticide)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Traiter »
3. Sélectionner le type de traitement (herbicide, fongicide, insecticide)
4. Sélectionner tracteur + pulvérisateur (+ cuve frontale si disponible)
5. Confirmer
**Validations serveur** :
- Vérifier culture en cours
- Vérifier stock produit de traitement suffisant
- Vérifier possession tracteur + pulvérisateur
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.traitement = type`, `stocks.produit_traitement -= quantité`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha. Combiné cuve frontale + pulvérisateur : -25% HT
- €: Coût HVC + produit déjà acheté. Prix ETA : 15 €/ha
- Effets: Protège la culture contre maladies/ravageurs/mauvaises herbes. Améliore le rendement. Non compatible bio (traitements chimiques).

---

### ACTION: [CUL-013] Faucher
**Déclencheur** : Onglet `Parcelles` → parcelle d'herbe prête → « Travail possible » → bouton « Faucher »
**Prérequis** :
- Parcelle d'herbe à maturité
- Tracteur + faucheuse (arrière, ou combiné frontale+arrière : -50 à -60% HT)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle d'herbe
2. Cliquer « Faucher »
3. Sélectionner tracteur + faucheuse(s)
4. Confirmer
**Validations serveur** :
- Vérifier herbe à maturité
- Vérifier possession tracteur + faucheuse
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.etat = 'fauchée'`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: ~2-3 HT pour 10 ha. Combiné frontale+arrière : ~1-1.5 HT
- €: Coût HVC
- Effets: L'herbe fauchée doit sécher (faner) puis être andainée et pressée. Première étape de la chaîne foin.

---

### ACTION: [CUL-014] Faner
**Déclencheur** : Onglet `Parcelles` → parcelle fauchée → « Faner »
**Prérequis** :
- Parcelle fauchée
- Tracteur + faneuse
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle fauchée
2. Cliquer « Faner »
3. Sélectionner tracteur + faneuse
4. Confirmer
**Validations serveur** :
- Vérifier parcelle en état « fauchée »
- Vérifier possession tracteur + faneuse
**Impacts** :
- BDD: `parcelles.etat = 'fanée'`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha
- €: Coût HVC
- Effets: Accélère le séchage de l'herbe. Étape nécessaire avant andainage.

---

### ACTION: [CUL-015] Andainer
**Déclencheur** : Onglet `Parcelles` → parcelle fanée → « Andainer »
**Prérequis** :
- Parcelle fanée
- Tracteur + andaineur
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle fanée
2. Cliquer « Andainer »
3. Sélectionner tracteur + andaineur
4. Confirmer
**Validations serveur** :
- Vérifier parcelle en état « fanée »
- Vérifier possession tracteur + andaineur
**Impacts** :
- BDD: `parcelles.etat = 'andainée'`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha. Prix ETA : 30 €/ha
- €: Coût HVC
- Effets: Regroupe l'herbe en andains pour le pressage. Étape avant pressage.

---

### ACTION: [CUL-016] Presser
**Déclencheur** : Onglet `Parcelles` → parcelle andainée → « Presser »
**Prérequis** :
- Parcelle andainée
- Tracteur + presse (carrée 300kg, carrée 500kg, ou ronde)
- Hangar avec capacité de stockage pour les balles
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle andainée
2. Cliquer « Presser »
3. Sélectionner tracteur + presse (type et taille de balle)
4. Optionnel : enrubanneuse pour enrubannage (conservation humide)
5. Confirmer
**Validations serveur** :
- Vérifier parcelle en état « andainée »
- Vérifier possession tracteur + presse
- Vérifier capacité stockage hangar
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.etat = 'pressée'`, `stocks.foin += nb_balles × poids_balle`, `joueur.ht -= coût_ht`
- HT: ~2-3 HT pour 10 ha. Prix ETA : 35-45 €/ha selon type presse
- €: Coût HVC
- Effets: Production de balles de foin (ou paille après moisson). Stockage en hangar. Le foin sert à nourrir les animaux en hiver. Empilage des balles : 1.9 €/balle (ETA).

---

### ACTION: [CUL-017] Moissonner
**Déclencheur** : Onglet `Parcelles` → parcelle à maturité → « Travail possible » → bouton « Moissonner »
**Prérequis** :
- Culture céréalière à maturité (blé, orge, colza, tournesol, maïs grain…)
- Moissonneuse-batteuse
- Silo ou benne pour stocker la récolte
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle à maturité
2. Cliquer « Moissonner »
3. Sélectionner la moissonneuse-batteuse
4. Choisir le réglage de coupe :
   - **Coupe haute** : 100% paille récupérable, appauvrissement sol fort
   - **Coupe standard** : 60% paille récupérable, appauvrissement moyen
   - **Coupe basse + broyage** : 0% paille (broyée sur place), restitution au sol
5. Confirmer
**Validations serveur** :
- Vérifier culture à maturité (date de récolte atteinte)
- Vérifier possession moissonneuse-batteuse
- Vérifier capacité silo disponible
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.etat = 'récoltée'`, `silos.stock += rendement × surface`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: ~3-5 HT pour 10 ha
- €: Coût HVC (moissonneuse : 0.125 L/CV/HT). Prix ETA : 70 €/ha (+ broyage paille)
- Effets: Rendement (T/ha) dépend de : sol (éléments nutritifs + matière organique), météo, traitements, irrigation, technique culturale, région. Paille récupérable selon réglage de coupe (haute=100%, standard=60%, basse+broyage=0%). Coupe haute exporte plus de matière → sol s'appauvrit plus vite. Récolte stockée en silo (1 type/silo).

---

### ACTION: [CUL-018] Ensiler
**Déclencheur** : Onglet `Parcelles` → parcelle maïs ensilé à maturité → « Ensiler »
**Prérequis** :
- Culture de maïs ensilé à maturité
- Ensileuse
- Silo taupe (sous bâche) avec capacité
- Tracteur + benne pour transport
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle de maïs ensilé
2. Cliquer « Ensiler »
3. Sélectionner l'ensileuse
4. Sélectionner tracteur + benne pour le transport
5. Confirmer
**Validations serveur** :
- Vérifier culture maïs ensilé à maturité
- Vérifier possession ensileuse + tracteur + benne
- Vérifier capacité silo taupe
**Impacts** :
- BDD: `parcelles.etat = 'récoltée'`, `silos_taupe.stock += rendement × surface`, `joueur.ht -= coût_ht`
- HT: ~4-6 HT pour 10 ha
- €: Coût HVC (ensileuse : 0.150 L/CV/HT)
- Effets: Maïs ensilé = base de la ration bovine. Stockage en silo taupe. Rendement élevé (T/ha).

---

### ACTION: [CUL-019] Arracher (betterave / pomme de terre)
**Déclencheur** : Onglet `Parcelles` → parcelle à maturité → « Arracher »
**Prérequis** :
- Culture de betterave ou pomme de terre à maturité
- Arracheuse spécifique (arracheuse betterave ou arracheuse PDT)
- Silo ou stockage avec capacité
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Arracher »
3. Sélectionner l'arracheuse adaptée
4. Confirmer
**Validations serveur** :
- Vérifier culture betterave/PDT à maturité
- Vérifier possession arracheuse spécifique
- Vérifier capacité stockage
**Impacts** :
- BDD: `parcelles.etat = 'récoltée'`, `silos.stock += rendement × surface`
- HT: ~4-6 HT pour 10 ha
- €: Coût HVC. Prix ETA : 135 €/ha (arrachage seul) ou 300 €/ha (arrachage + transport)
- Effets: Betterave : vendue à la sucrerie (CAR) ou en coopérative. PDT : vendue en coopérative ou marché. Rotation longue (betterave: 4 ans, PDT: 4 ans).

---

### ACTION: [CUL-020] Irriguer (enrouleur)
**Déclencheur** : Onglet `Parcelles` → onglet Eau → bouton « Irriguer »
**Prérequis** :
- Enrouleur d'irrigation installé
- Source d'eau : forage, rivière, retenue collinaire
- Culture en cours nécessitant de l'eau
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle → onglet « Eau »
2. Consulter les jauges eau/soleil
3. Cliquer « Irriguer »
4. Sélectionner l'enrouleur
5. Confirmer
**Validations serveur** :
- Vérifier possession enrouleur
- Vérifier source d'eau disponible et suffisante
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.irrigation = true`, `parcelles.eau += apport`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT
- €: Coût HVC (pompage)
- Effets: Compense le manque de pluie. Améliore le rendement en période sèche. Nécessite un forage ou une source.

---

### ACTION: [CUL-021] Irriguer (pivot central)
**Déclencheur** : Onglet `Parcelles` → onglet Eau → « Programmer pivot »
**Prérequis** :
- Pivot central + rampes installés sur la parcelle
- Source d'eau
- Énergie électrique
**Étapes** :
1. Sélectionner la parcelle → onglet « Eau »
2. Cliquer « Programmer pivot »
3. Définir la programmation (automatique selon seuil d'humidité)
4. Confirmer
**Validations serveur** :
- Vérifier possession pivot central + rampes
- Vérifier source d'eau
**Impacts** :
- BDD: `parcelles.pivot_programme = true`, `parcelles.seuil_irrigation = X`
- HT: 0 HT (automatique une fois programmé)
- €: Consommation énergie électrique + coût installation initial élevé
- Effets: Irrigation automatique. Investissement lourd mais économie de HT. Idéal pour grandes parcelles.

---

### ACTION: [CUL-022] Analyse de sol
**Déclencheur** : Onglet `Parcelles` → onglet Sol → bouton « Analyser le sol »
**Prérequis** :
- Parcelle possédée ou louée
- Dernière analyse > 5 ans Cultivia (1 analyse tous les 5 ans max)
- Argent suffisant (150 €)
**Étapes** :
1. Sélectionner la parcelle → onglet « Sol »
2. Cliquer « Analyser le sol »
3. Confirmer le paiement (150 €)
**Validations serveur** :
- Vérifier dernière analyse > 5 ans
- Vérifier solde € ≥ 150 €
**Impacts** :
- BDD: `parcelles.derniere_analyse = now()`, `parcelles.qualite_sol = X`, `parcelles.N/P/K/Ca/Mg/S = valeurs`, `joueur.solde -= 150`
- HT: 0 HT
- €: 150 €
- Effets: Révèle la qualité du sol (3 niveaux), la présence de pierres (-5% rendement), et les niveaux des 6 éléments nutritifs. Indispensable pour optimiser la fertilisation.

---

## 3. MATÉRIEL

> ~6 actions couvrant l'achat, la vente, l'entretien, le carburant et les options du matériel agricole.

---

### ACTION: [MAT-001] Acheter matériel neuf
**Déclencheur** : Onglet `Matériels` → bouton « Acheter du matériel » → onglet « Neuf »
**Prérequis** :
- Argent suffisant
- Hangar avec espace disponible (pour abriter le matériel, optionnel mais recommandé)
- HT suffisants
**Étapes** :
1. Aller dans `Matériels` → « Acheter du matériel »
2. Sélectionner la catégorie (tracteur, charrue, semoir, moissonneuse, etc.)
3. Filtrer par marque, puissance, prix
4. Consulter la fiche technique (puissance CV, maniabilité 1-5, consommation HVC, prix)
5. Cliquer « Acheter »
6. Optionnel : achat en commun avec un ami (même région)
7. Confirmer l'achat
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier HT suffisants
- Si achat en commun : vérifier relation « ami » et même région
**Impacts** :
- BDD: Création entrée `materiels` (type, marque, modèle, puissance, usure=0%, état=neuf), `joueur.solde -= prix`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Prix neuf variable (ex: tracteur 30 000-250 000 €, moissonneuse 150 000-400 000 €, charrue 5 000-30 000 €)
- Effets: Matériel livré immédiatement. Usure à 0%. Garantie constructeur. Si non abrité sous hangar : usure plus rapide.

---

### ACTION: [MAT-002] Acheter matériel occasion
**Déclencheur** : Onglet `Matériels` → « Acheter du matériel » → onglet « Occasion » ou via concessionnaire joueur
**Prérequis** :
- Argent suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Matériels` → « Acheter du matériel » → « Occasion »
2. Filtrer par catégorie, marque, région
3. Consulter les annonces (prix, usure, état, vendeur)
4. Cliquer « Acheter » ou « Faire une offre »
5. Si concessionnaire : consulter le dépôt-vente
6. Confirmer l'achat
**Validations serveur** :
- Vérifier matériel toujours disponible
- Vérifier solde € suffisant
**Impacts** :
- BDD: `materiels.proprietaire_id = acheteur`, `joueur_acheteur.solde -= prix`, `joueur_vendeur.solde += prix`
- HT: ~1 HT
- €: Prix fixé par le vendeur (généralement 30-70% du prix neuf selon usure)
- Effets: Matériel avec usure existante. Peut nécessiter un entretien immédiat. Commission concessionnaire si dépôt-vente. Transport nécessaire si autre région.

---

### ACTION: [MAT-003] Vendre matériel
**Déclencheur** : Onglet `Matériels` → sélection matériel → bouton « Vendre »
**Prérequis** :
- Matériel possédé, non en cours d'utilisation
- HT suffisants
**Étapes** :
1. Sélectionner le matériel dans la liste
2. Cliquer « Vendre »
3. Choisir le mode de vente : marché occasion, dépôt-vente concessionnaire, ou vente privée (ami spécial)
4. Fixer le prix de vente
5. Confirmer la mise en vente
**Validations serveur** :
- Vérifier que le matériel n'est pas en cours d'utilisation
- Vérifier que le matériel n'est pas en panne
- Vérifier HT suffisants
**Impacts** :
- BDD: `materiels.en_vente = true`, `materiels.prix_vente = X`. Après vente : `materiels.proprietaire_id = acheteur`, `joueur.solde += prix`
- HT: ~0.5 HT
- €: Prix de vente fixé par le joueur
- Effets: Matériel visible sur le marché occasion. Commission si dépôt-vente concessionnaire. Notification à l'acheteur.

---

### ACTION: [MAT-004] Entretenir matériel
**Déclencheur** : Onglet `Matériels` → icône clé à molette → bouton « Entretenir »
**Prérequis** :
- Matériel avec usure > 0%
- HT suffisants (1 HT/matériel/mois pour entretien mensuel)
- Argent pour pièces détachées si nécessaire
**Étapes** :
1. Aller dans `Matériels`
2. Identifier le matériel à entretenir (colonne usure)
3. Cliquer sur l'icône entretien
4. Choisir : entretien mensuel (1 HT) ou entretien annuel
5. Si pièces détachées à remplacer : confirmer l'achat des pièces
6. Confirmer l'entretien
**Validations serveur** :
- Vérifier HT suffisants (1 HT/matériel)
- Vérifier solde € si pièces détachées nécessaires
- Vérifier que le matériel n'est pas en cours d'utilisation
**Impacts** :
- BDD: `materiels.usure -= réduction`, `materiels.dernier_entretien = now()`, `joueur.ht -= 1`, `joueur.solde -= coût_pièces`
- HT: 1 HT par matériel (entretien mensuel)
- €: Pièces détachées : 1-5 pièces par matériel, prix variable. Assurance couvre les frais si souscrite.
- Effets: Réduit l'usure, prévient les pannes. Panne = immobilisation 0-2 jours. Entretien groupé possible (« Entretenir tous les matériels cochés »). Réparation possible chez concessionnaire joueur.

---

### ACTION: [MAT-005] Faire le plein HVC (carburant)
**Déclencheur** : Onglet `Coopérative` → « Carburant » → bouton « Acheter HVC »
**Prérequis** :
- Cuve HVC construite (accessoire bâtiment) avec capacité disponible
- Argent suffisant
**Étapes** :
1. Aller dans `Coopérative` → « Carburant »
2. Choisir la source :
   - Option 1 : Coopérative Agricole Régionale (CAR) — prix réduit, livraison différée
   - Option 2 : Coopérative Cultivia — prix standard (0.48 €/L), livraison immédiate
3. Sélectionner la quantité (500 L à 500 000 L)
4. Confirmer l'achat
**Validations serveur** :
- Vérifier capacité cuve HVC restante
- Vérifier solde € suffisant
- Si CAR : vérifier CAR active dans la région
**Impacts** :
- BDD: `cuves_hvc.stock += quantité`, `joueur.solde -= quantité × prix_litre`
- HT: 0 HT
- €: 0.48 €/L (Cultivia) ou prix CAR réduit (~0.40 €/L). Économie de 0.08 €/L via CAR.
- Effets: Le HVC est consommé par tous les matériels motorisés. Sans HVC = impossible de travailler. Consommation : tracteur 0.05 L/CV/HT (trajet), 0.08-0.20 L/CV/HT (travail). Tracteur routier : 24-28 L/HT.

---

### ACTION: [MAT-006] Installer GPS
**Déclencheur** : Onglet `Matériels` → sélection matériel → bouton « Installer GPS »
**Prérequis** :
- Matériel motorisé (tracteur, moissonneuse, ensileuse)
- Récepteur GPS acheté (3 000 € en jeu)
- Balise GPS installée sur la parcelle (20 000 € en jeu, via concessionnaire)
- Souscription annuelle GPS (400-600 €/an en jeu)
**Étapes** :
1. Acheter un récepteur GPS chez un concessionnaire joueur
2. Installer le récepteur sur le matériel
3. Acheter et installer une balise GPS sur la parcelle
4. Souscrire l'abonnement annuel
5. Confirmer l'installation
**Validations serveur** :
- Vérifier possession récepteur GPS
- Vérifier balise installée sur la parcelle cible
- Vérifier souscription annuelle active
**Impacts** :
- BDD: `materiels.gps = true`, `parcelles.balise_gps = true`
- HT: ~1 HT pour l'installation
- €: Récepteur 3 000 € + balise 20 000 € + abonnement 400-600 €/an
- Effets: Le GPS améliore la précision du travail → bonus rendement et économie d'intrants. Réduction de la consommation HVC. Visible dans la colonne « GPS » de la liste des parcelles.

---

## 4. BÂTIMENTS

> ~4 actions couvrant la construction, l'agrandissement, la destruction et l'entretien des bâtiments.

---

### ACTION: [BAT-001] Construire bâtiment
**Déclencheur** : Onglet `Bâtiments` → « Agrandir ma ferme » → bouton « Construire »
**Prérequis** :
- Argent suffisant
- HT suffisants
- Emplacement disponible sur la ferme
**Étapes** :
1. Aller dans `Bâtiments` → « Agrandir ma ferme »
2. Choisir le type de bâtiment (hangar, stabulation, porcherie, chèvrerie, bergerie, poulailler, clapier, écurie, entrepôt, silo, fosse, etc.)
3. Sélectionner la taille/capacité
4. Choisir le niveau d'équipement (1-5) : plus le niveau est élevé, moins la consommation d'énergie est forte
5. Consulter le prix et le délai de construction
6. Confirmer la construction
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier HT suffisants
- Vérifier limite de bâtiments (10 premiers : construction immédiate, ensuite : délai variable)
**Impacts** :
- BDD: Création entrée `batiments` (type, capacité, niveau_equipement, usure=0%), `joueur.solde -= prix_construction`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT
- €: Variable selon type et taille (ex: hangar 200m² ~15 000 €, stabulation 500m² ~50 000 €, silo 500T ~20 000 €)
- Effets: Bâtiment disponible après délai de construction (immédiat pour les 10 premiers). Consommation d'énergie mensuelle (0.08 €/kWh). Apparaît dans la liste des bâtiments et sur la ferme 3D.

---

### ACTION: [BAT-002] Agrandir bâtiment
**Déclencheur** : Onglet `Bâtiments` → sélection bâtiment → bouton « Agrandir »
**Prérequis** :
- Bâtiment existant
- Bâtiment vide (pas d'animaux, pas de stock) pour certains types
- Argent suffisant
- HT suffisants
**Étapes** :
1. Sélectionner le bâtiment dans la liste
2. Cliquer « Agrandir »
3. Choisir la nouvelle capacité (extension)
4. Consulter le coût et le délai
5. Confirmer l'agrandissement
**Validations serveur** :
- Vérifier que le bâtiment est vide (si requis par le type)
- Vérifier solde € suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: `batiments.capacite += extension`, `joueur.solde -= coût_agrandissement`
- HT: ~1 HT
- €: Coût proportionnel à l'extension
- Effets: Augmente la capacité du bâtiment. Délai de travaux possible. Le bâtiment est inutilisable pendant les travaux.

---

### ACTION: [BAT-003] Détruire bâtiment
**Déclencheur** : Onglet `Bâtiments` → sélection bâtiment → bouton « Détruire »
**Prérequis** :
- Bâtiment vide (pas d'animaux, pas de stock, pas de matériel)
- HT suffisants
**Étapes** :
1. Sélectionner le bâtiment
2. Cliquer « Détruire »
3. Le système affiche le montant récupéré (10% du prix d'achat)
4. Confirmer la destruction (action irréversible)
**Validations serveur** :
- Vérifier que le bâtiment est complètement vide
- Vérifier HT suffisants
- Demander confirmation (action irréversible)
**Impacts** :
- BDD: Suppression entrée `batiments`, `joueur.solde += prix_achat × 10%`
- HT: ~0.5 HT
- €: Récupération de 10% du prix d'achat initial
- Effets: Bâtiment supprimé définitivement. Libère l'emplacement sur la ferme 3D. Destruction groupée possible (« Détruire tous les bâtiments cochés »).

---

### ACTION: [BAT-004] Entretenir bâtiment
**Déclencheur** : Onglet `Bâtiments` → icône entretien → bouton « Entretenir »
**Prérequis** :
- Bâtiment avec usure > 0%
- HT suffisants
- Argent suffisant
**Étapes** :
1. Aller dans `Bâtiments`
2. Identifier les bâtiments à entretenir (colonne usure)
3. Cliquer sur l'icône entretien ou « Entretenir tous les bâtiments cochés »
4. Confirmer
**Validations serveur** :
- Vérifier HT suffisants
- Vérifier solde € suffisant
**Impacts** :
- BDD: `batiments.usure -= réduction`, `batiments.dernier_entretien = now()`, `joueur.ht -= coût_ht`, `joueur.solde -= coût_entretien`
- HT: ~1 HT par bâtiment
- €: Variable selon taille et type de bâtiment
- Effets: Réduit l'usure du bâtiment. Un bâtiment très usé consomme plus d'énergie et peut avoir des problèmes. Entretien groupé possible.

---

## 5. COMMERCE

> ~5 actions couvrant les achats/ventes à la coopérative, les annonces et les appels d'offres.

---

### ACTION: [COM-001] Acheter à la coopérative
**Déclencheur** : Onglet `Coopérative` → catégorie de produit → bouton « Acheter »
**Prérequis** :
- Argent suffisant
- Stockage disponible (silo, entrepôt, hangar selon le produit)
**Étapes** :
1. Aller dans `Coopérative`
2. Naviguer par catégorie : Alimentation animale, Semences, Engrais, Produits phytosanitaires, Carburant HVC, Paille, Foin, etc.
3. Sélectionner le produit et la quantité
4. Consulter le prix unitaire (prix fixe Cultivia)
5. Confirmer l'achat
6. Le produit est livré immédiatement en stock (ou livraison différée si CAR)
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier capacité de stockage disponible
**Impacts** :
- BDD: `stocks.produit += quantité`, `joueur.solde -= prix_total`
- HT: 0 HT (achat en ligne)
- €: Prix fixe Cultivia (ex: paille ~70 €/T, foin ~70 €/T, semences blé ~200 €/T)
- Effets: Produit disponible immédiatement en stock. Transport inclus dans le prix Cultivia. Si achat à une CAR joueur : prix potentiellement réduit mais livraison par transporteur nécessaire.

---

### ACTION: [COM-002] Vendre à la coopérative
**Déclencheur** : Onglet `Bâtiments` → silo/entrepôt → bouton « Vendre » sur le stock
**Prérequis** :
- Produit en stock (récolte, foin, paille, lait, œufs, laine, etc.)
- HT suffisants
**Étapes** :
1. Aller dans `Bâtiments` → sélectionner le silo ou entrepôt contenant le produit
2. Cliquer « Vendre »
3. Choisir la destination : Coopérative Cultivia (prix fixe) ou annonce marché (prix libre)
4. Indiquer la quantité à vendre
5. Confirmer la vente
**Validations serveur** :
- Vérifier stock suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: `stocks.produit -= quantité`, `joueur.solde += quantité × prix_unitaire`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: Prix de vente Cultivia (ex: blé ~100 €/T, lait variable selon indice QL)
- Effets: Argent crédité immédiatement. Le prix du lait dépend de l'indice QL moyen du troupeau et du contrat laiterie. Produits bio : +20% prix.

---

### ACTION: [COM-003] Passer une annonce (vente marchandise)
**Déclencheur** : Onglet `Bâtiments` → « Achats/Ventes » → bouton « Passer une annonce »
**Prérequis** :
- Produit en stock à vendre

**Étapes** :
1. Aller dans `Bâtiments` → « Achats/Ventes »
2. Cliquer « Passer une annonce »
3. Sélectionner le produit et la quantité
4. Fixer le prix de vente (libre)
5. Choisir la portée : régionale ou nationale
6. Confirmer la publication
**Validations serveur** :
- Vérifier stock suffisant
- Vérifier prix de vente raisonnable (pas en dessous d'un seuil minimum)
**Impacts** :
- BDD: Création entrée `annonces` (produit, quantité, prix, vendeur, portée, date)
- HT: 0 HT
- €: 0 € (publication gratuite)
- Effets: Annonce visible par les autres joueurs. Transport à la charge de l'acheteur (transporteur). Indication du coût de transport estimé. Possibilité de vendre à des amis privilégiés directement.

---

### ACTION: [COM-004] Répondre à un appel d'offres
**Déclencheur** : Onglet `Animaux` → « Appels d'offres » ou `Coopérative` → « Appels d'offres » → bouton « Répondre »
**Prérequis** :
- Produit ou animaux correspondant à l'appel d'offres
- Stock ou animaux disponibles
- Jour compatible (appels d'offres publiés le lundi)
**Étapes** :
1. Consulter les appels d'offres disponibles (usines, contrats mensuels)
2. Filtrer par type de produit, région
3. Sélectionner un appel d'offres
4. Proposer une offre (quantité, prix)
5. Confirmer l'envoi de l'offre
6. Attendre la réponse (acceptation ou refus)
**Validations serveur** :
- Vérifier stock/animaux disponibles
- Vérifier que l'offre respecte les conditions de l'appel
**Impacts** :
- BDD: Création entrée `offres_appel` (appel_id, joueur, quantité, prix)
- HT: 0 HT
- €: 0 € pour l'offre. Si acceptée : vente au prix convenu
- Effets: Contrats mensuels récurrents possibles. Transport nécessaire après acceptation. Notification de résultat.

---

### ACTION: [COM-005] Amener plateau/fourgon à la coopérative
**Déclencheur** : Onglet `Matériels` → sélection véhicule chargé → bouton « Amener à la coopérative »
**Prérequis** :
- Plateau (tracteur + plateau) ou fourgon chargé de marchandises
- Marchandises à livrer (balles, semences, engrais, etc.)
- HT et HVC suffisants
**Étapes** :
1. Charger le plateau/fourgon avec les marchandises depuis le hangar
2. Sélectionner le véhicule chargé
3. Cliquer « Amener à la coopérative »
4. Le système calcule le trajet et le coût HVC
5. Confirmer le déplacement
**Validations serveur** :
- Vérifier véhicule chargé
- Vérifier HT suffisants
- Vérifier HVC suffisant pour le trajet
**Impacts** :
- BDD: `vehicule.localisation = 'coopérative'`, `joueur.ht -= coût_ht_trajet`, `cuves_hvc.stock -= conso`
- HT: 0.25 HT/zone de trajet
- €: Coût HVC du trajet
- Effets: Permet de livrer des marchandises à la coopérative ou de récupérer des achats. Le fourgon sert aussi au transport de petits animaux (volailles, lapins). La bétaillère pour les gros animaux.

---

## 6. FINANCE

> ~4 actions couvrant les prêts, l'épargne, l'achat/vente de HT et la consultation de l'historique.

---

### ACTION: [FIN-001] Demander un prêt
**Déclencheur** : Menu Finance → « Prêts » → bouton « Demander un prêt »
**Prérequis** :
- Montant cumulé des prêts en cours < 150 000 €
- Dernière demande de prêt > 7 jours
**Étapes** :
1. Aller dans Finance → « Prêts »
2. Cliquer « Demander un prêt »
3. Saisir la raison du prêt (commentaire)
4. Saisir le montant souhaité
5. Choisir la durée de remboursement
6. Consulter le taux d'intérêt et les mensualités
7. Confirmer la demande
**Validations serveur** :
- Vérifier montant cumulé prêts en cours + nouveau prêt ≤ 150 000 €
- Vérifier dernière demande > 7 jours
- Vérifier montant > 0
**Impacts** :
- BDD: Création entrée `prets` (montant, taux, durée, mensualité, date_debut), `joueur.solde += montant_prêt`
- HT: 0 HT
- €: Montant du prêt crédité immédiatement. Mensualités prélevées automatiquement. Remboursement anticipé possible avec pénalité de 3% du capital restant.
- Effets: Argent disponible immédiatement. Mensualités débitées chaque mois Cultivia. Visible dans « Mes prêts en cours ». Taux variable selon conditions du marché.

---

### ACTION: [FIN-002] Ouvrir un compte épargne
**Déclencheur** : Menu Finance → « Épargne » → bouton « Ouvrir un compte »
**Prérequis** :
- Argent disponible pour le versement initial
**Étapes** :
1. Aller dans Finance → « Épargne »
2. Cliquer « Ouvrir un compte »
3. Choisir la durée : 1 an (5%), 3 ans (6%), ou 5 ans (7%)
4. Saisir le montant du versement initial (plafond : 100 000 €)
5. Confirmer l'ouverture
**Validations serveur** :
- Vérifier solde € suffisant pour le versement
- Vérifier montant ≤ plafond (100 000 €)
**Impacts** :
- BDD: Création entrée `epargnes` (montant, taux, durée, date_ouverture), `joueur.solde -= versement`
- HT: 0 HT
- €: Versement débité. Intérêts versés à chaque anniversaire du compte. Retrait anticipé = perte de tous les intérêts.
- Effets: Argent bloqué pour la durée choisie. Intérêts : 5%/an (1 an), 6%/an (3 ans), 7%/an (5 ans). Visible dans « Mes épargnes ». Bon placement pour l'argent excédentaire.

---

### ACTION: [FIN-003] Acheter / Vendre HT (Heures de Travail)
**Déclencheur** : Menu « Employés » → « Mettre en vente mes HT » ou « Acheter des HT »
**Prérequis** :
- Pour vendre : HT disponibles (sur les 35 HT/jour)
- Pour acheter : argent suffisant
**Étapes** :
1. **Vendre** : Aller dans « Employés » → « Mettre en vente mes HT »
   - Sélectionner le nombre de HT à vendre (de 1 à 35)
   - Fixer le prix par HT
   - Confirmer la mise en vente
2. **Acheter** : Consulter les offres de HT disponibles
   - Sélectionner une offre
   - Confirmer l'achat
**Validations serveur** :
- Vendre : vérifier HT disponibles ≥ quantité
- Acheter : vérifier solde € suffisant
**Impacts** :
- BDD: Vendeur : `joueur.ht -= quantité`, `joueur.solde += prix`. Acheteur : `joueur.ht += quantité`, `joueur.solde -= prix`
- HT: Transfert direct de HT entre joueurs
- €: Prix libre fixé par le vendeur
- Effets: Permet aux joueurs avec excès de HT de les monétiser. Permet aux joueurs manquant de HT d'en acheter. Alternative : embaucher un employé agricole (35 HT/jour, 1 750 €/mois).

---

### ACTION: [FIN-004] Consulter historique bancaire
**Déclencheur** : Clic sur le solde € en haut de page → « Mon relevé bancaire »
**Prérequis** :
- Aucun
**Étapes** :
1. Cliquer sur le montant € affiché en haut de l'interface
2. Ou aller dans Finance → « Mon relevé bancaire »
3. Filtrer par période (mois Cultivia)
4. Filtrer par catégorie d'opération (achat nourriture, vente animaux, insémination, vétérinaire, vaccination, vente récolte, achat matériel, etc.)
5. Trier par colonnes (date, montant, catégorie)
**Validations serveur** :
- Aucune validation spécifique
**Impacts** :
- BDD: Lecture seule — aucune modification
- HT: 0 HT
- €: 0 €
- Effets: Consultation uniquement. Permet d'analyser ses dépenses et revenus. Historique complet de toutes les transactions. Utile pour la gestion financière de la ferme.

---

## 7. TRANSPORT

> ~3 actions couvrant l'acceptation de demandes, le chargement et la livraison.

---

### ACTION: [TRA-001] Accepter une demande de transport
**Déclencheur** : Menu Transport → « Demandes de transport » → bouton « Proposer mes services »
**Prérequis** :
- Activité Transport débloquée (permis obtenu)
- Tracteur routier + semi-remorque adaptée (benne, plateau, porte-engin, citerne…)
- Chauffeur embauché (270 €/jour, 32 HT/jour)
- Licence transport : compte propre ou compte d'autrui
- Camion à proximité du lieu de chargement
**Étapes** :
1. Aller dans Transport → « Demandes de transport »
2. Filtrer par : région départ, région arrivée, type de matière, favoris
3. Consulter les demandes disponibles (produit, quantité, trajet, estimation prix)
4. Cliquer « Proposer mes services » sur une demande
5. Saisir le montant de l'offre (prix du transport)
6. Confirmer l'envoi de l'offre
7. Attendre la réponse du client (acceptation ou refus)
**Validations serveur** :
- Vérifier licence transport valide
- Vérifier possession tracteur routier + semi adaptée
- Vérifier chauffeur disponible
- Vérifier camion à proximité raisonnable du lieu de chargement
**Impacts** :
- BDD: Création entrée `offres_transport` (demande_id, transporteur, prix_proposé, statut='en_attente')
- HT: 0 HT pour l'offre
- €: 0 € pour l'offre
- Effets: Notification au client. Si acceptée : le transporteur doit déplacer son camion au lieu de chargement. Coût transport calculé selon : amortissement matériel, personnel, volume transporté, distance, HVC, marge transporteur.

---

### ACTION: [TRA-002] Charger camion
**Déclencheur** : Transport → « Mes missions » → bouton « Charger » quand le camion est au lieu de chargement
**Prérequis** :
- Offre de transport acceptée par le client
- Camion (tracteur routier + semi) positionné au lieu de chargement
- Marchandise disponible chez le vendeur
- Aire/silo de chargement du vendeur activé(e) OU vendeur connecté pour charger
- HT chauffeur suffisants
**Étapes** :
1. Déplacer le camion jusqu'au lieu de chargement (consomme HT chauffeur + HVC)
2. Une fois sur place, cliquer « Charger »
3. Le système vérifie la marchandise disponible
4. Chargement automatique si aire/silo de chargement activé
5. Sinon : le vendeur doit charger manuellement (avec télescopique)
6. Confirmation du chargement
**Validations serveur** :
- Vérifier camion au bon emplacement
- Vérifier marchandise disponible
- Vérifier capacité semi-remorque suffisante
- Vérifier HT chauffeur suffisants
**Impacts** :
- BDD: `semi.chargement = produit`, `semi.quantite_chargee = X`, `vendeur.stock -= quantité`, `chauffeur.ht -= coût_ht_trajet`
- HT: HT chauffeur pour le trajet (32 HT/jour, 64 si double équipage). Trajet : variable selon distance.
- €: Consommation HVC tracteur routier (24-28 L/HT)
- Effets: Le camion est chargé et prêt à partir vers la destination. Si plusieurs voyages nécessaires : les marchandises ne sont disponibles chez l'acheteur qu'après le dernier voyage.

---

### ACTION: [TRA-003] Livrer (décharger chez l'acheteur)
**Déclencheur** : Transport → « Mes missions » → bouton « Décharger » quand le camion est au lieu de livraison
**Prérequis** :
- Camion chargé positionné au lieu de livraison (chez l'acheteur)
- Capacité de stockage chez l'acheteur suffisante
- HT chauffeur suffisants
**Étapes** :
1. Déplacer le camion chargé jusqu'au lieu de livraison
2. Une fois sur place, cliquer « Décharger »
3. Le système vérifie la capacité de stockage de l'acheteur
4. Si pas de place : possibilité de décharger à la coopérative Cultivia à la place
5. Confirmation du déchargement
6. Paiement du transport
**Validations serveur** :
- Vérifier camion au bon emplacement
- Vérifier capacité stockage acheteur (ou coopérative)
- Vérifier HT chauffeur suffisants
**Impacts** :
- BDD: `semi.chargement = null`, `acheteur.stock += quantité`, `transporteur.solde += prix_transport`, `acheteur.solde -= prix_marchandise + prix_transport`
- HT: HT chauffeur pour le trajet retour
- €: Le transporteur reçoit le prix du transport convenu. L'acheteur paie la marchandise + le transport.
- Effets: Mission de transport terminée. Notification à l'acheteur et au vendeur. Le camion est vide et disponible pour une nouvelle mission. Statistiques de transport mises à jour.

---
---

## ANNEXE : Récapitulatif des coûts HT par catégorie

| Catégorie | Action | Coût HT estimé |
|-----------|--------|----------------|
| Élevage | Nourrir (manuel) | 1-3 HT |
| Élevage | Nourrir (robot) | 0 HT |
| Élevage | Pailler (pailleuse) | 1-2 HT |
| Élevage | Pailler (manuel) | 2-4 HT |
| Élevage | Retirer fumier | 2-4 HT |
| Élevage | Traire | 1-2 HT |
| Élevage | Collecter œufs | 1 HT |
| Élevage | Vétérinaire | 1 HT |
| Élevage | Mettre au pré | 0.5-3 HT (selon distance) |
| Élevage | Inséminer | 0.5-1 HT |
| Cultures | Déchaumer | 2-4 HT/10ha |
| Cultures | Labourer | 3-6 HT/10ha |
| Cultures | Préparer terre | 2-3 HT/10ha |
| Cultures | Semer | 1-3 HT/10ha |
| Cultures | Épandre engrais | 1-2 HT/10ha |
| Cultures | Traiter | 1-2 HT/10ha |
| Cultures | Faucher | 2-3 HT/10ha |
| Cultures | Moissonner | 3-5 HT/10ha |
| Cultures | Ensiler | 4-6 HT/10ha |
| Cultures | Arracher | 4-6 HT/10ha |
| Matériel | Acheter | 1 HT |
| Matériel | Entretenir | 1 HT/matériel |
| Bâtiments | Construire | 1-2 HT |
| Bâtiments | Entretenir | 1 HT |
| Transport | Trajet chauffeur | 32 HT/jour (64 double équipage) |

---

## ANNEXE : Formules de consommation HVC

| Matériel | Mode | Formule |
|----------|------|---------|
| Tracteur | Trajet | 0.05 L/CV/HT |
| Tracteur | Travail du sol | 0.08-0.20 L/CV/HT |
| Moissonneuse | Travail | 0.125 L/CV/HT |
| Ensileuse | Travail | 0.150 L/CV/HT |
| Télescopique | Travail | 0.120 L/CV/HT |
| Tracteur routier | Trajet | 24-28 L/HT |

> Exemple : Tracteur 150 CV labourant pendant 4 HT = 150 × 0.15 × 4 = 90 litres HVC

---

## ANNEXE : Prix ETA (sous-traitance) par travail

| Travail | Prix ETA (€/ha) |
|---------|-----------------|
| Déchaumer | 25 |
| Labourer | 70 |
| Herse rotative | 30 |
| Semer (céréales) | 30 |
| Planter | 120 |
| Traiter | 15 |
| Fertiliser (engrais) | 15-20 |
| Épandre fumier/compost | 35 |
| Faucher | - |
| Andainer | 30 |
| Presser foin 300kg | 45 |
| Presser foin 500kg | 35 |
| Presser paille 300kg | 45 |
| Presser paille 500kg | 40 |
| Moissonner | 70 |
| Moissonner + broyage paille | 70 |
| Arracher betterave (seul) | 135 |
| Arracher betterave + transport | 300 |
| Arracher PDT | 300 |
| Empiler balles | 1.9 €/balle |
| Broyer pierres | 60 |
| Passer rouleau | 10 |
| Désherbage chimique | 25 |

---


## 8. ÉLEVAGE — ACTIONS COMPLÉMENTAIRES

> ~21 actions couvrant l'allaitement, le bio, le chien de berger, le nommage, la fusion/défusion, les déplacements, l'eau, la vente de productions, le négociant, les Salon Génétique et l'IVRAD.

---

### ACTION: [ELV-025] Activer allaitement (veau/agneau sous la mère)
**Déclencheur** : Onglet `Animaux` → sélection femelle allaitante → bouton « Activer allaitement »
**Prérequis** :
- Femelle allaitante avec petit(s) de moins de 6 mois (bovins) ou 3 mois (ovins)
- Espèce éligible : bovins allaitants ou ovins allaitants
- Petit non sevré, présent dans le même bâtiment ou pré que la mère
**Étapes** :
1. Aller dans `Animaux` → sélectionner la femelle allaitante
2. Cliquer « Activer allaitement »
3. Le système affiche le(s) petit(s) éligible(s)
4. Confirmer l'activation
**Validations serveur** :
- Vérifier espèce éligible (bovins allaitants ou ovins allaitants)
- Vérifier présence d'un petit de moins de 6 mois (bovins) ou 3 mois (ovins)
- Vérifier que le petit est dans le même lieu que la mère
- Vérifier que l'allaitement n'est pas déjà actif
**Impacts** :
- BDD: `animaux_petit.allaitement = true`, `animaux_petit.date_debut_allaitement = now()`
- HT: 0 HT
- €: 0 € (pas de coût direct)
- Effets: Le petit est nourri par la mère (pas besoin de ration séparée). À la vente à l'abattoir : label « Veau sous la mère » (+1.50 €/kg carcasse) ou « Agneau sous la mère » (+0.30 €/kg carcasse). Durée max : 6 mois (bovins), 3 mois (ovins).

---

### ACTION: [ELV-026] Désactiver allaitement
**Déclencheur** : Onglet `Animaux` → sélection femelle allaitante → bouton « Désactiver allaitement »
**Prérequis** :
- Allaitement actuellement actif sur la femelle
**Étapes** :
1. Sélectionner la femelle avec allaitement actif
2. Cliquer « Désactiver allaitement »
3. Confirmer le sevrage
**Validations serveur** :
- Vérifier que l'allaitement est bien actif
**Impacts** :
- BDD: `animaux_petit.allaitement = false`, `animaux_petit.date_sevrage = now()`
- HT: 0 HT
- €: 0 €
- Effets: Le petit doit désormais être nourri par ration classique. Perte du label « sous la mère » si sevré avant l'âge requis.

---

### ACTION: [ELV-027] Changer type élevage (conventionnel / bio)
**Déclencheur** : Onglet `Animaux` → bandeau informations → lien « conventionnel ou biologique »
**Prérequis** :
- Au moins 1 animal de l'espèce concernée
- Pour passer en bio : respecter les conditions bio (âge min/max, temps au pré ≥50%, tolérance nourriture non bio limitée)
**Étapes** :
1. Aller dans `Animaux` → page principale
2. Cliquer sur le lien « conventionnel ou biologique » dans le bandeau informations
3. Sélectionner l'espèce à modifier
4. Choisir le type d'élevage : conventionnel ou biologique
5. Confirmer le changement
**Validations serveur** :
- Vérifier que l'espèce est éligible au bio (toutes sauf bisons, daims, chevaux)
- Si passage en bio : vérifier conditions (âge, temps au pré, nourriture)
- Conditions bio par espèce : bovins (6-96 mois, 50% pré, 12j tolérance non bio), caprins (3-60 mois, 25% pré, 6j), ovins (3-60 mois, 50% pré, 6j), porcins (6-24 mois, 50% parc, 4j), lapins (3-24 mois, 100% parc, 2j), volailles (6-24 mois, 100% parc, 4j), pintades (6-24 mois, 100% parc, 6j), oies (6-36 mois, 100% parc, 4j), canards (6-36 mois, 100% parc, 4j)
**Impacts** :
- BDD: `elevage.type = 'bio'` ou `'conventionnel'` pour l'espèce concernée
- HT: 0 HT
- €: 0 €
- Effets: Élevage bio = +20% prix de vente (lait, viande, œufs, laine). Rations doivent être composées d'ingrédients bio. Le changement est immédiat mais les animaux doivent individuellement remplir les conditions pour obtenir le label.

---

### ACTION: [ELV-028] Acheter chien de berger
**Déclencheur** : Onglet `Animaux` → « Mon chien » → bouton « Acheter un chien de berger »
**Prérequis** :
- Ne pas déjà posséder un chien de berger (1 seul par ferme)
- Argent suffisant (600 €)
**Étapes** :
1. Aller dans `Animaux` → « Mon chien »
2. Cliquer « Acheter un chien de berger »
3. Consulter le prix (600 €) et le coût d'entretien quotidien
4. Confirmer l'achat
**Validations serveur** :
- Vérifier absence de chien de berger existant (max 1 par ferme)
- Vérifier solde € ≥ 600 €
**Impacts** :
- BDD: Création entrée `chien_berger` (proprietaire_id = joueur, date_achat = now()), `joueur.solde -= 600`
- HT: 0 HT
- €: 600 € à l'achat + 35 HT/jour d'entretien (coût intégré au budget quotidien)
- Effets: Permet de déplacer ovins, caprins et bovins au pré sans bétaillère (même département uniquement). Non revendable. Coût d'entretien quotidien automatique.

---

### ACTION: [ELV-029] Nommer un animal
**Déclencheur** : Onglet `Animaux` → fiche animal → bouton « Nommer »
**Prérequis** :
- Animal avec au moins un indice génétique ≥ 70% du maximum serveur pour sa race/classe
- Nom de domaine enregistré
- Animal adulte
**Étapes** :
1. Sélectionner l'animal dans la liste
2. Consulter sa fiche (indices génétiques)
3. Cliquer « Nommer »
4. Saisir le nom de l'animal (préfixé automatiquement par le nom de domaine)
5. Confirmer
**Validations serveur** :
- Vérifier qu'au moins un indice génétique ≥ 70% du max serveur
- Vérifier nom de domaine enregistré
- Vérifier unicité du nom
**Impacts** :
- BDD: `animaux.nom = 'NomDomaine NomAnimal'`, `animaux.nomme = true`
- HT: 0 HT
- €: 0 €
- Effets: L'animal nommé apparaît sur le marché des animaux nommés avec un prix de vente supérieur. Prestige et visibilité pour l'éleveur. Les animaux nommés ont une génétique au-dessus de la moyenne.


## 14. CONCESSIONNAIRE

> 5 actions couvrant la création de concession, les licences constructeurs, l'embauche, l'entretien atelier et le dépôt-vente.

---

### ACTION: [CON-001] Créer concession
**Déclencheur** : Menu `Activités secondaires` → « Concessionnaire » → bouton « Créer ma concession »
**Prérequis** :
- Inscription depuis au moins 90 jours

- Appel surtaxé de déblocage (~1.80 €)
**Étapes** :
1. Aller dans `Activités secondaires` → « Concessionnaire »
2. Débloquer l'activité (appel surtaxé)
3. Un hall de vente de 200 m² est offert gratuitement
4. Embaucher au moins un vendeur pour le hall
5. Confirmer la création
**Validations serveur** :
- Vérifier ancienneté ≥ 90 jours

- Vérifier déblocage effectué
**Impacts** :
- BDD: Création entrée `concessions` (hall_200m², statut=actif), `joueur.activite_secondaire = 'concessionnaire'`
- HT: 0 HT
- €: 0 € (hall offert)
- Effets: Le joueur dispose d'un hall de 200 m² pour exposer du matériel. Possibilité d'acheter des halls supplémentaires (200 m² max chacun). Nécessite un vendeur par hall.

---

### ACTION: [CON-002] Acheter licence constructeur
**Déclencheur** : Menu `Concession` → « Licences » → bouton « Acheter une licence »
**Prérequis** :
- Concession active
- 100 points à répartir entre constructeurs
- Argent suffisant pour le droit d'entrée
**Étapes** :
1. Aller dans `Concession` → « Licences »
2. Consulter la liste des constructeurs disponibles (marques agricoles et routières)
3. Répartir les 100 points entre les constructeurs choisis (le nombre de points requis varie par constructeur)
4. Payer le droit d'entrée de la licence (variable selon constructeur)
5. Confirmer l'achat — licence valable 1 an Cultivia (84 jours réels)
**Validations serveur** :
- Vérifier total points répartis ≤ 100
- Vérifier solde € suffisant pour le droit d'entrée
- Vérifier concession active
**Impacts** :
- BDD: Création entrées `licences_constructeur` (constructeur_id, points, date_expiration=+84j), `joueur.solde -= droit_entree`
- HT: 0 HT
- €: Droit d'entrée variable par constructeur + redevance sur CA neuf en fin d'année
- Effets: Permet de commander et vendre du matériel neuf de ce constructeur. À l'expiration, renouveler ou changer de constructeur (obligation de liquider le stock restant de l'ancien). Pas de redevance sur le matériel d'occasion.

---

### ACTION: [CON-003] Embaucher vendeur / mécanicien
**Déclencheur** : Menu `Concession` → « Personnel » → bouton « Embaucher »
**Prérequis** :
- Concession active
- Vendeur : au moins 1 hall disponible
- Mécanicien : atelier acheté
- Argent suffisant pour le salaire
**Étapes** :
1. Aller dans `Concession` → « Personnel »
2. Choisir le type d'employé : vendeur ou mécanicien
3. Consulter les candidats disponibles (compétences affichées)
4. Pour un mécanicien : consulter les compétences Usure (1-10) et HT (1-10)
5. Confirmer l'embauche
**Validations serveur** :
- Vérifier hall disponible (vendeur) ou atelier acheté (mécanicien)
- Vérifier solde € suffisant pour le premier salaire
**Impacts** :
- BDD: Création entrée `employes_concession` (type, competences_usure, competences_ht), `joueur.solde -= salaire_mensuel`
- HT: 0 HT (l'employé apporte ses propres HT : vendeur 35 HT/jour, mécanicien 35 HT/jour)
- €: Mécanicien : 1 400 €/mois. Vendeur : salaire variable.
- Effets: Le vendeur gère les ventes dans le hall. Le mécanicien effectue l'entretien et les réparations. Formation gratuite du mécanicien tous les 84 jours (améliore compétences). Spécialisation possible sur 3 marques. Retraite à 60 ans.

---

### ACTION: [CON-004] Entretien atelier (matériel client)
**Déclencheur** : Menu `Concession` → « Atelier » → réception d'une demande d'entretien client
**Prérequis** :
- Atelier acheté
- Au moins 1 mécanicien embauché
- HT mécanicien disponibles
- Pièces détachées en stock ou achetables
**Étapes** :
1. Recevoir une demande d'entretien d'un joueur client
2. Le mécanicien se déplace (camion atelier si réparation à domicile) ou le client amène son matériel
3. Le système calcule le coût : main-d'œuvre (HT × prix/HT) + pièces détachées
4. Effectuer l'entretien (2-5 HT selon type de matériel)
5. Facturer le client
**Validations serveur** :
- Vérifier mécanicien disponible avec HT suffisants
- Vérifier pièces détachées disponibles
- Vérifier matériel client en état d'être entretenu
**Impacts** :
- BDD: `materiel_client.usure -= réduction`, `joueur_concessionnaire.solde += prix_main_oeuvre`, `mecanicien.ht -= coût_ht`
- HT: 2 HT (outils/remorques), 4 HT (tracteurs/télescopiques/routiers), 5 HT (moissonneuses/ensileuses)
- €: Main-d'œuvre : 8-24 €/HT (fixé par le concessionnaire). Pièces : 100 € (outils), 300 € (tracteurs), 500 € (moissonneuses) + majoration 2%/an d'âge du matériel.
- Effets: Réduit l'usure du matériel client. Le concessionnaire ne perçoit que la main-d'œuvre. Assurance du client couvre les pièces si souscrite. Compétences mécanicien influencent la qualité de l'entretien.

---

### ACTION: [CON-005] Dépôt-vente matériel
**Déclencheur** : Menu `Concession` → « Dépôt-vente » → un joueur dépose son matériel
**Prérequis** :
- Rayon occasion dédié dans le hall
- Vendeur affecté au dépôt-vente
- Matériel du joueur déposant non en cours d'utilisation
**Étapes** :
1. Un joueur choisit de déposer son matériel en dépôt-vente chez le concessionnaire
2. Le concessionnaire accepte le dépôt
3. Le matériel est exposé dans le hall occasion
4. Un acheteur consulte le dépôt-vente et achète
5. Le concessionnaire prélève sa commission sur la vente
6. Le vendeur (joueur déposant) reçoit le montant net
**Validations serveur** :
- Vérifier espace disponible dans le hall occasion
- Vérifier vendeur affecté
- Vérifier matériel non en panne et non en cours d'utilisation
**Impacts** :
- BDD: `materiel.en_depot_vente = true`, `materiel.concession_id = X`. Après vente : `materiel.proprietaire_id = acheteur`, `joueur_vendeur.solde += prix - commission`, `joueur_concessionnaire.solde += commission`
- HT: 0 HT
- €: Commission fixée par le concessionnaire (% du prix de vente)
- Effets: Le joueur déposant peut retirer son matériel à tout moment. Tant que non vendu, le concessionnaire ne touche rien. Alternative à la vente directe sur le marché occasion.

---

### ACTION: [CON-006] Fusionner animaux
**Déclencheur** : Onglet `Animaux` → « Mes ratios et fusions » → bouton « Fusionner »
**Prérequis** :
- Nombre d'animaux dépassant le seuil de fusion obligatoire : >5 000 volailles, >12 000 porcins (seuils par espèce)
- Animaux de même espèce, race et classe (ex: poules pondeuses)
**Étapes** :
1. Aller dans `Animaux` → « Mes ratios et fusions »
2. Le système signale les espèces dépassant le seuil
3. Sélectionner les animaux à fusionner (même race, même classe)
4. Cliquer « Fusionner »
5. Confirmer la fusion
**Validations serveur** :
- Vérifier que le seuil de fusion est atteint (obligatoire au-delà)
- Vérifier que les animaux sont de même espèce, race et classe
- Vérifier que les animaux sont dans le même bâtiment
**Impacts** :
- BDD: Les entrées individuelles `animaux` sont regroupées en une seule entrée `animaux_fusion` (espèce, race, classe, nb_animaux, indices_moyens)
- HT: 0 HT
- €: 0 €
- Effets: Réduit la charge serveur pour les gros élevages. Les animaux fusionnés sont gérés comme un lot unique (alimentation, soins, vente groupée). Obligatoire au-delà des seuils pour éviter les ralentissements.

---

### ACTION: [CON-007] Défusionner animaux
**Déclencheur** : Onglet `Animaux` → « Mes ratios et fusions » → bouton « Défusionner »
**Prérequis** :
- Lot d'animaux fusionnés existant
- Nombre total après défusion ne dépasse pas le seuil de fusion
**Étapes** :
1. Aller dans `Animaux` → « Mes ratios et fusions »
2. Sélectionner le lot fusionné à séparer
3. Indiquer le nombre d'animaux à extraire du lot
4. Confirmer la défusion
**Validations serveur** :
- Vérifier que le lot fusionné existe
- Vérifier que le nombre restant après défusion reste gérable (sous le seuil ou refusion nécessaire)
- Vérifier capacité bâtiment suffisante
**Impacts** :
- BDD: `animaux_fusion.nb_animaux -= N`, création de N entrées individuelles `animaux` avec indices génétiques issus de la moyenne du lot
- HT: 0 HT
- €: 0 €
- Effets: Permet de vendre ou déplacer individuellement des animaux d'un lot fusionné. Les indices génétiques individuels sont recalculés à partir de la moyenne du lot.

---

### ACTION: [CON-008] Déplacer animal entre bâtiments
**Déclencheur** : Onglet `Animaux` → sélection animal(aux) → bouton « Déplacer »
**Prérequis** :
- Animal dans un bâtiment
- Bâtiment de destination de même type (ex: stabulation → stabulation) avec capacité disponible
- HT suffisants
**Étapes** :
1. Sélectionner le(s) animal(aux) dans la liste
2. Cliquer « Déplacer »
3. Sélectionner le bâtiment de destination (même type, capacité affichée)
4. Confirmer le déplacement
**Validations serveur** :
- Vérifier que le bâtiment de destination est compatible avec l'espèce
- Vérifier capacité disponible dans le bâtiment de destination (surface par tête respectée)
- Vérifier HT suffisants
- Vérifier que l'animal n'est pas malade (certaines restrictions)
**Impacts** :
- BDD: `animaux.batiment_id = nouveau_batiment`, `batiment_source.nb_animaux -= N`, `batiment_dest.nb_animaux += N`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: 0 €
- Effets: Permet de réorganiser le cheptel entre bâtiments. Utile pour libérer de la place avant mise bas ou pour regrouper par race/âge.

---

### ACTION: [CON-009] Remplir cuve à eau (bâtiment)
**Déclencheur** : Onglet `Animaux` → bandeau « Cuves à eau » → bouton « Remplir »
**Prérequis** :
- Cuve à eau construite (accessoire bâtiment)
- Source d'eau : robinet (eau courante (coût en jeu)) ou récupération eau de pluie via toitures
- Argent disponible si remplissage au robinet
**Étapes** :
1. Aller dans `Animaux` → consulter le bandeau « Estimation eau » (Nécessaire vs Dispo)
2. Cliquer « Remplir » à côté de la cuve
3. Choisir la source : eau du robinet (coût en €) ou eau de pluie (gratuit si toitures installées)
4. Indiquer la quantité à remplir (en litres)
5. Confirmer le remplissage
**Validations serveur** :
- Vérifier que la cuve n'est pas déjà pleine
- Vérifier capacité restante de la cuve
- Si robinet : vérifier solde € suffisant
- Si pluie : vérifier toitures de récupération installées et stock eau de pluie > 0
**Impacts** :
- BDD: `cuves_eau.niveau += quantité_remplie`, `joueur.solde -= coût_eau` (si robinet)
- HT: 0 HT
- €: ~0.01 €/litre (eau du robinet) ou 0 € (eau de pluie)
- Effets: Les animaux dans le bâtiment associé sont abreuvés automatiquement tant que la cuve contient de l'eau. Si cuve vide → animaux non abreuvés → risque maladie.

---

### ACTION: [CON-010] Remplir bac à eau au pré (tonne à eau)
**Déclencheur** : Onglet `Parcelles` → sélectionner le pré → onglet « Eau » → bouton « Remplir bac »
**Prérequis** :
- Bac à eau installé dans la parcelle (pré)
- Tracteur + tonne à eau
- Animaux présents au pré
- HT et HVC suffisants
**Étapes** :
1. Aller dans `Parcelles` → sélectionner le pré → onglet « Eau »
2. Consulter le niveau du bac (Nécessaire vs Disponible en litres)
3. Sélectionner le tracteur et la tonne à eau
4. Le système calcule le coût HT et HVC selon la distance (zones)
5. Confirmer le remplissage
**Validations serveur** :
- Vérifier présence d'un bac à eau dans la parcelle
- Vérifier possession tracteur + tonne à eau
- Vérifier HT et HVC suffisants
- Vérifier que le bac n'est pas déjà plein
**Impacts** :
- BDD: `bacs_eau.niveau += quantité`, `joueur.ht -= coût_ht_trajet`, `cuves_hvc.stock -= consommation_hvc`
- HT: 0.25 HT/zone de trajet + ~1 HT remplissage
- €: Coût HVC du trajet (0.05 L/CV/HT × puissance tracteur)
- Effets: Abreuve les animaux au pré. Alternative : canalisation (remplissage automatique) ou source naturelle (gratuit).


---

## 15. CIA (Centre d'Insémination Artificielle)

> 5 actions couvrant la création du CIA, les contrats race/animal, le prélèvement de semence et l'insémination client.

---

### ACTION: [CIA-001] Créer CIA
**Déclencheur** : Menu `Activités secondaires` → « CIA » → bouton « Créer mon CIA »
**Prérequis** :
- Inscription depuis au moins 90 jours

- Appel surtaxé de déblocage (~1.80 €)
**Étapes** :
1. Aller dans `Activités secondaires` → « CIA »
2. Débloquer l'activité (appel surtaxé)
3. Un laboratoire de 50 m² est offert (1 m²/animal stocké)
4. Embaucher un inséminateur (35 HT/jour, 1 750 €/mois)
5. Acheter un utilitaire (véhicule léger) pour les déplacements
6. Confirmer la création
**Validations serveur** :
- Vérifier ancienneté ≥ 90 jours

- Vérifier déblocage effectué
**Impacts** :
- BDD: Création entrée `cia` (labo_50m², statut=actif), `joueur.activite_secondaire = 'cia'`
- HT: 0 HT
- €: 0 € (labo offert) + salaire inséminateur 1 750 €/mois + achat utilitaire
- Effets: Le CIA peut stocker et conserver la semence des mâles (1 m²/mâle dans le labo). Possibilité de partager un inséminateur entre 2 CIA du même département (partage des HT). Laboratoires supplémentaires achetables (50 m² chacun).

---

### ACTION: [CIA-002] Contrat race CIA
**Déclencheur** : Menu `CIA` → « Contrats » → « Contacter éleveurs » → bouton « Proposer un contrat race »
**Prérequis** :
- CIA actif
- Éleveur cible possédant des mâles de la race visée
**Étapes** :
1. Aller dans `CIA` → « Contrats » → « Contacter éleveurs »
2. Rechercher un éleveur par région/espèce/race
3. Proposer un contrat race pour une race spécifique
4. L'éleveur reçoit la proposition et accepte ou refuse
5. Si accepté : l'éleveur s'engage à présenter tous ses mâles de cette race au CIA
**Validations serveur** :
- Vérifier CIA actif
- Vérifier que l'éleveur possède des mâles de la race
- Vérifier qu'aucun contrat race identique n'existe déjà
**Impacts** :
- BDD: Création entrée `contrats_race_cia` (cia_id, eleveur_id, race_id, statut='en_attente')
- HT: 0 HT
- €: 0 €
- Effets: Étape obligatoire avant le contrat animal. L'éleveur et le CIA peuvent rompre le contrat race à tout moment. Ouvre la possibilité de proposer des contrats individuels par mâle.

---

### ACTION: [CIA-003] Contrat animal CIA
**Déclencheur** : Menu `CIA` → « Contrats » → « Contrats animaux » ou fiche d'un mâle → bouton « Proposer au CIA »
**Prérequis** :
- Contrat race actif entre l'éleveur et le CIA pour cette race
- Mâle adulte reproducteur appartenant à l'éleveur
**Étapes** :
1. L'éleveur va sur la fiche de son mâle reproducteur
2. Cliquer « Proposer au CIA »
3. Fixer le prix de la dose (min/max selon espèce)
4. Définir la répartition CIA/éleveur (% pour chacun)
5. Le CIA accepte ou refuse le contrat
**Validations serveur** :
- Vérifier contrat race actif pour cette race
- Vérifier mâle adulte et reproducteur
- Vérifier prix dose dans les bornes autorisées
**Impacts** :
- BDD: Création entrée `contrats_animal_cia` (cia_id, animal_id, prix_dose, part_cia, part_eleveur)
- HT: 0 HT
- €: 0 € (le prix sera perçu à chaque insémination)
- Effets: Le mâle est référencé dans le GenBook (annuaire génétique régional). Prix dose autorisés : taureau 30-90 €, verrat 5-30 €, bouc 15-35 €, bélier 10-25 €, lapin 0.50-4 €, coq 0.50-4 €, pintade 0.50-4 €, jars 0.50-4 €, canard 0.50-4 €, étalon 30-120 €.

---

### ACTION: [CIA-004] Prélèvement semence
**Déclencheur** : Menu `CIA` → « Prélèvements » → bouton « Prélever » sur un mâle sous contrat
**Prérequis** :
- Contrat animal actif pour ce mâle
- Inséminateur disponible (HT suffisants)
- Utilitaire disponible
- Délai entre prélèvements respecté (variable selon espèce)
**Étapes** :
1. Aller dans `CIA` → « Prélèvements »
2. Sélectionner le mâle sous contrat
3. L'inséminateur se déplace chez l'éleveur avec l'utilitaire
4. Effectuer le prélèvement
5. Les doses sont stockées au laboratoire du CIA
**Validations serveur** :
- Vérifier contrat animal actif
- Vérifier inséminateur avec HT suffisants
- Vérifier utilitaire disponible
- Vérifier délai entre prélèvements respecté
**Impacts** :
- BDD: `cia.stock_doses += nb_doses`, `inseminateur.ht -= coût_ht`
- HT: Variable selon déplacement (inséminateur)
- €: Coût HVC utilitaire pour le déplacement
- Effets: Nombre de doses par prélèvement selon espèce : taureau 300-400, verrat 20-40, bouc 15-25, bélier 10-15, lapin 35-50, coq 35-50, pintade 35-50, jars 7-12, canard 35-50, étalon 20-30. Délai variable entre prélèvements selon espèce.

---

### ACTION: [CIA-005] Insémination client CIA
**Déclencheur** : Un éleveur commande une insémination via `Animaux` → « CIA et contrats » → « Commander une insémination »
**Prérequis** :
- Stock de doses disponible pour le mâle choisi
- Inséminateur disponible (HT suffisants)
- Utilitaire disponible
- Femelle du client éligible (âge, non gestante, non malade, saison)
**Étapes** :
1. L'éleveur client commande une insémination (choix du mâle via GenBook)
2. Le CIA reçoit la commande
3. L'inséminateur se déplace chez l'éleveur avec l'utilitaire et la dose
4. Réaliser l'insémination
5. Facturation automatique : prix dose réparti entre CIA et éleveur propriétaire du mâle
**Validations serveur** :
- Vérifier stock doses > 0 pour ce mâle
- Vérifier inséminateur avec HT suffisants
- Vérifier utilitaire disponible
- Vérifier conditions de la femelle (âge, gestation, santé, saison)
- Vérifier solde € du client suffisant
**Impacts** :
- BDD: `cia.stock_doses -= 1`, `joueur_client.solde -= prix_dose`, `joueur_cia.solde += part_cia`, `joueur_eleveur_male.solde += part_eleveur`, `inseminateur.ht -= coût_ht`
- HT: Variable selon déplacement (inséminateur)
- €: Prix de la dose (0.50-120 € selon espèce/mâle). Répartition CIA/éleveur selon contrat.
- Effets: Si réussite : la femelle devient gestante. Taux de réussite variable selon espèce. Le CIA peut refuser des commandes selon disponibilité. Classement CIA par rentabilité, commandes honorées et inséminations réalisées.

---

### ACTION: [CIA-006] Construire canalisation (ferme ↔ parcelle)
**Déclencheur** : Onglet `Bâtiments` → « Agrandir ma ferme » → section « Canalisations » → bouton « Construire »
**Prérequis** :
- Parcelle (pré) dans la même commune/zone que la ferme
- Argent suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Bâtiments` → « Agrandir ma ferme » → « Canalisations »
2. Sélectionner la parcelle de destination (même zone que la ferme)
3. Consulter le coût de construction
4. Confirmer la construction
**Validations serveur** :
- Vérifier que la parcelle est dans la même zone/commune que la ferme
- Vérifier solde € suffisant
- Vérifier HT suffisants
- Vérifier qu'une canalisation n'existe pas déjà vers cette parcelle
**Impacts** :
- BDD: Création entrée `canalisations` (ferme_id, parcelle_id, date_construction), `joueur.solde -= coût_construction`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Variable selon distance (quelques centaines d'€)
- Effets: Le bac à eau de la parcelle se remplit automatiquement chaque jour depuis la cuve de la ferme. Plus besoin de tracteur + tonne à eau pour cette parcelle. Économie de HT et HVC quotidiens.

---

### ACTION: [CIA-007] Vendre lait
**Déclencheur** : Onglet `Animaux` → « Mes productions » → section Lait → bouton « Vendre »
**Prérequis** :
- Lait stocké dans la cuve à lait (tank)
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Mes productions »
2. Consulter le stock de lait dans la cuve (en litres)
3. Cliquer « Vendre »
4. Choisir la destination : coopérative Cultivia (prix fixe selon QL) ou contrat laiterie joueur
5. Indiquer la quantité à vendre
6. Le système affiche le prix estimé selon l'indice QL moyen du troupeau
7. Confirmer la vente
**Validations serveur** :
- Vérifier stock lait en cuve ≥ quantité vendue
- Vérifier HT suffisants
- Si contrat laiterie : vérifier contrat actif et quantité dans les limites du contrat
**Impacts** :
- BDD: `cuves_lait.stock -= quantité`, `joueur.solde += quantité × prix_par_1000L / 1000`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: Prix selon QL et espèce — Bovins conventionnel : 265 €/1000L (QL 0-9) à 400 €/1000L (QL 90-100). Bovins bio : 318 €/1000L (QL 0-9) à 480 €/1000L (QL 90-100). Caprins : 550-660 €/1000L. Ovins : 850-940 €/1000L. Bio = +20% environ.
- Effets: Revenu principal des élevages laitiers. Le prix dépend de l'indice QL moyen du troupeau. Prime qualité lait si QL moyen >60 (fixée par le CECA).

---

### ACTION: [CIA-008] Vendre œufs
**Déclencheur** : Onglet `Animaux` → « Mes productions » → section Œufs → bouton « Vendre »
**Prérequis** :
- Œufs stockés dans la pièce de stockage œufs
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Mes productions »
2. Consulter le stock d'œufs (par calibre : S, M, L, XL)
3. Cliquer « Vendre »
4. Sélectionner le calibre et la quantité à vendre
5. Le système affiche le prix selon le calibre
6. Confirmer la vente
**Validations serveur** :
- Vérifier stock œufs ≥ quantité vendue (par calibre)
- Vérifier HT suffisants
**Impacts** :
- BDD: `stockage_oeufs.quantite -= quantité`, `joueur.solde += quantité × prix_calibre`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: Prix variable selon calibre — S (< 53g) : prix le plus bas, M (53-63g) : moyen, L (63-73g) : bon, XL (> 73g) : le plus élevé. Bio = +20%.
- Effets: Le calibre dépend de l'âge de la poule : XL (6 mois-1 an), L/XL (1-2 ans), L (2-3 ans), M/L (3-4 ans), M (4-5 ans), S/M (5-6 ans), S (6-8 ans). Optimiser l'âge du cheptel pour maximiser le calibre.

---

### ACTION: [CIA-009] Vendre laine / duvet
**Déclencheur** : Onglet `Animaux` → « Mes productions » → section Laine/Duvet → bouton « Vendre »
**Prérequis** :
- Laine ou duvet stocké dans la pièce de stockage laine
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Mes productions »
2. Consulter le stock de laine/duvet (en kg, par type)
3. Cliquer « Vendre laine » ou « Vendre duvet »
4. Indiquer la quantité à vendre
5. Le système affiche le prix selon le type
6. Confirmer la vente
**Validations serveur** :
- Vérifier stock laine/duvet ≥ quantité vendue
- Vérifier HT suffisants
**Impacts** :
- BDD: `stockage_laine.quantite -= quantité`, `joueur.solde += quantité × prix_kg`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: Prix par kg — Mohair (caprins Angora) : ~16 €/kg, Angora (lapins Angora) : ~20 €/kg, Laine ovine : ~0.45 €/kg, Duvet (oies/canards) : ~10 €/kg. Bio = +20%.
- Effets: Revenu complémentaire pour les élevages ovins, caprins angora, lapins angora, oies et canards. Production dépend de l'indice génétique Laine/Duvet.

---

### ACTION: [CIA-010] Appeler négociant
**Déclencheur** : Onglet `Animaux` → « Marché » → onglet « Négociant » → bouton « Appeler le négociant »
**Prérequis** :
- Maximum 1 appel par mois Cultivia
- Maximum 4 races commandables par appel
- Bâtiment adapté avec capacité disponible
- Argent suffisant
**Étapes** :
1. Aller dans `Animaux` → « Marché » → onglet « Négociant »
2. Cliquer « Appeler le négociant »
3. Sélectionner jusqu'à 4 races (toutes espèces confondues)
4. Indiquer le nombre d'animaux souhaités par race
5. Consulter les animaux proposés (famille, race, âge, poids, stats génétiques, prix)
6. Cliquer « Acheter » sur les animaux souhaités
7. Confirmer la commande
**Validations serveur** :
- Vérifier limite 1 appel/mois non atteinte
- Vérifier maximum 4 races sélectionnées
- Vérifier solde € suffisant
- Vérifier capacité bâtiment
**Impacts** :
- BDD: Création entrées `animaux` (adultes, indices génétiques moyens), `joueur.solde -= prix_total`, `joueur.negociant_dernier_appel = now()`
- HT: ~1 HT
- €: Prix négociant (légèrement supérieur à la coopérative)
- Effets: Animaux adultes uniquement. Non revendables aux autres joueurs (abattoir uniquement). Non éligibles Salon Génétique. Reproduction possible. Préférences de races sauvegardables pour les appels suivants.


---

## 16. FROMAGERIE

> 5 actions couvrant la création de fromagerie, la transformation du lait, l'affinage, et la vente (marché ou grossiste).

---

### ACTION: [FRO-001] Créer fromagerie
**Déclencheur** : Menu `Activités secondaires` → « Fromagerie » → bouton « Créer ma fromagerie »
**Prérequis** :
- Élevage laitier actif (vaches, chèvres ou brebis)
- Argent suffisant

**Étapes** :
1. Aller dans `Activités secondaires` → « Fromagerie »
2. Choisir le type de fromagerie :
   - **Artisanale** : 20 800 à 100 000 €, capacité 250 à 1 250 L/jour, max 25 HT joueur
   - **Industrielle** : 198 000 à 910 000 €, capacité 2 200 à 11 000 L/jour, 2 à 10 fromagers employés
3. Confirmer la construction
**Validations serveur** :
- Vérifier solde € suffisant

- Vérifier élevage laitier existant
**Impacts** :
- BDD: Création entrée `fromageries` (type, capacite_litres_jour, niveau_equipement), `joueur.solde -= prix_construction`
- HT: 0 HT
- €: Artisanale : 20 800-100 000 €. Industrielle : 198 000-910 000 €.
- Effets: Artisanale = le joueur transforme lui-même (max 25 HT). Industrielle = nécessite des fromagers employés (35 HT/jour chacun). Possibilité de produire aussi crème (0.0375 L crème/L lait) et beurre (0.480 kg beurre/L crème).

---

### ACTION: [FRO-002] Transformer lait en fromage
**Déclencheur** : Menu `Fromagerie` → « Production » → bouton « Transformer »
**Prérequis** :
- Lait en stock (tank à lait)
- Fromagerie construite et opérationnelle
- HT suffisants (joueur ou fromagers)
- Capacité de la fromagerie non dépassée
**Étapes** :
1. Aller dans `Fromagerie` → « Production »
2. Sélectionner le type de lait (vache, chèvre, brebis — conventionnel ou bio)
3. Choisir le type de fromage parmi 6 familles : pâte molle croûte fleurie, pâte molle croûte lavée, pâte pressée cuite, pâte pressée non cuite, pâte persillée, chèvre
4. Indiquer la quantité de lait à transformer
5. Confirmer la transformation
**Validations serveur** :
- Vérifier stock lait suffisant
- Vérifier capacité fromagerie non dépassée (L/jour)
- Vérifier HT suffisants
- Vérifier fromagers disponibles (industrielle)
**Impacts** :
- BDD: `cuves_lait.stock -= quantité_lait`, `fromagerie.stock_fromage += quantité_lait × 0.1`, `joueur.ht -= coût_ht`
- HT: Variable selon quantité
- €: 0 € direct (lait déjà en stock)
- Effets: Ratio : 0.1 kg de fromage par litre de lait. Qualité du fromage déterminée par 4 indices : Forme, Odeur, Goût, Couleur. Les 6 compétences du fromager influencent la qualité : Emprésurage, Découpe, Moulage, Égouttage, Salage, Affinage. Fromage bio si lait bio (+20% prix).

---

### ACTION: [FRO-003] Affiner fromage
**Déclencheur** : Menu `Fromagerie` → « Cave d'affinage » → bouton « Affiner » sur un lot de fromage
**Prérequis** :
- Fromage transformé en attente d'affinage
- Cave d'affinage disponible
- Durée d'affinage variable selon type
**Étapes** :
1. Aller dans `Fromagerie` → « Cave d'affinage »
2. Sélectionner le lot de fromage à affiner
3. Le système affiche la durée d'affinage requise selon le type
4. Lancer l'affinage
5. Attendre la fin de l'affinage (4 à 84 jours selon type)
**Validations serveur** :
- Vérifier fromage en état « transformé »
- Vérifier cave d'affinage avec capacité
**Impacts** :
- BDD: `fromage.statut = 'en_affinage'`, `fromage.date_fin_affinage = now() + durée_type`
- HT: 0 HT (affinage passif)
- €: 0 €
- Effets: Durée d'affinage : 4-84 jours selon le type de fromage. Les 4 indices qualité (Forme, Odeur, Goût, Couleur) évoluent pendant l'affinage. DLC (Date Limite de Consommation) : 7-11 jours après fin d'affinage. Fromage non vendu avant DLC = perdu.

---

### ACTION: [FRO-004] Vendre fromage au marché
**Déclencheur** : Menu `Fromagerie` → « Ventes » → bouton « Vendre au marché » (fromagerie artisanale uniquement)
**Prérequis** :
- Fromagerie artisanale
- Fromage affiné et dans sa DLC
- Utilitaire disponible
- Kit exposant acheté
- HT suffisants
**Étapes** :
1. Aller dans `Fromagerie` → « Ventes » → « Marché »
2. Sélectionner le marché (régional)
3. Charger l'utilitaire avec le fromage
4. Se rendre au marché (consomme HT + HVC)
5. Vendre aux clients (prix fixé par le joueur)
**Validations serveur** :
- Vérifier fromagerie artisanale
- Vérifier fromage affiné et DLC valide
- Vérifier utilitaire + kit exposant
- Vérifier HT suffisants
- Vérifier max 4 marchés par jour
**Impacts** :
- BDD: `fromagerie.stock_fromage -= quantité_vendue`, `joueur.solde += recette_vente`, `joueur.ht -= coût_ht`
- HT: Variable selon déplacement + temps de vente
- €: Recette de vente (prix fixé par le joueur × quantité vendue)
- Effets: Maximum 4 marchés par jour. Vente directe au consommateur. Prix influencé par la qualité du fromage (indices). Fromage bio = +20% prix.

---

### ACTION: [FRO-005] Vendre fromage au grossiste
**Déclencheur** : Menu `Fromagerie` → « Ventes » → bouton « Vendre au grossiste » (fromagerie industrielle uniquement)
**Prérequis** :
- Fromagerie industrielle
- Fromage affiné et dans sa DLC
- HT suffisants
**Étapes** :
1. Aller dans `Fromagerie` → « Ventes » → « Grossiste »
2. Consulter les grossistes disponibles dans la région
3. Proposer une offre (type de fromage, quantité, prix)
4. Le grossiste accepte ou négocie
5. Livraison et paiement
**Validations serveur** :
- Vérifier fromagerie industrielle
- Vérifier fromage affiné et DLC valide
- Vérifier HT suffisants
- Vérifier max 4 visites grossiste par jour
**Impacts** :
- BDD: `fromagerie.stock_fromage -= quantité_vendue`, `joueur.solde += recette_vente`, `joueur.ht -= coût_ht`
- HT: Variable selon déplacement
- €: Prix négocié avec le grossiste
- Effets: Maximum 4 visites grossiste par jour. Négociation possible sur le prix. Volumes plus importants qu'au marché. Transport par le grossiste ou par le joueur.

## 10. CULTURES — ACTIONS COMPLÉMENTAIRES

> 27 actions couvrant les engrais verts, amendements organiques, conversion bio, commerce des récoltes, arboriculture, haies et gestion foncière.

---

### ACTION: [CUL-023] Semer engrais vert CIPAN
**Déclencheur** : Onglet `Parcelles` → parcelle récoltée (été) → « Travail possible » → bouton « Semer engrais vert »
**Prérequis** :
- Parcelle récoltée après moisson d'été
- Tracteur + semoir
- Semences CIPAN en stock (moutarde, phacélie, seigle ou RGI — ray-grass italien)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle récoltée
2. Cliquer « Semer engrais vert »
3. Choisir l'espèce : moutarde, phacélie, seigle ou RGI
4. Sélectionner tracteur + semoir
5. Confirmer le semis
**Validations serveur** :
- Vérifier parcelle en état « récoltée » (récolte d'été)
- Vérifier stock semences CIPAN suffisant
- Vérifier possession tracteur + semoir
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.culture = 'cipan_moutarde'` (ou phacélie/seigle/rgi), `parcelles.etat = 'semée'`, `stocks.semences -= quantité`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha
- €: Coût HVC + semences déjà achetées
- Effets: Couvre le sol entre deux cultures principales. Fixe l'azote, limite l'érosion. Doit être broyé en janvier avant la culture suivante.

---

### ACTION: [CUL-024] Broyer engrais vert
**Déclencheur** : Onglet `Parcelles` → parcelle avec CIPAN → « Travail possible » → bouton « Broyer engrais vert »
**Prérequis** :
- Parcelle avec engrais vert CIPAN semé
- Mois de janvier (saison Cultivia)
- Tracteur + broyeur
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle avec CIPAN
2. Cliquer « Broyer engrais vert »
3. Sélectionner tracteur + broyeur
4. Confirmer
**Validations serveur** :
- Vérifier présence CIPAN sur la parcelle
- Vérifier mois = janvier
- Vérifier possession tracteur + broyeur
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.culture = null`, `parcelles.etat = 'broyée'`, `parcelles.elements_nutritifs += apports_cipan`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha
- €: Coût HVC
- Effets: Restitue les éléments nutritifs captés par le CIPAN au sol. Attendre 7 jours avant tout nouveau travail du sol. Améliore la structure du sol.

---

### ACTION: [CUL-025] Broyer paille
**Déclencheur** : Onglet `Parcelles` → parcelle moissonnée → « Travail possible » → bouton « Broyer paille »
**Prérequis** :
- Parcelle moissonnée avec paille non pressée
- Moissonneuse-batteuse avec option broyage OU tracteur + broyeur
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle moissonnée
2. Cliquer « Broyer paille »
3. Sélectionner le matériel (moissonneuse avec broyage ou tracteur + broyeur)
4. Confirmer
**Validations serveur** :
- Vérifier paille présente sur la parcelle (non pressée)
- Vérifier possession matériel de broyage
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.paille_broyee = true`, `parcelles.elements_nutritifs += apports_paille`, `joueur.ht -= coût_ht`
- HT: Inclus dans la moisson si option broyage, sinon ~1-2 HT pour 10 ha
- €: Coût HVC. Prix ETA : inclus dans moisson+broyage (70 €/ha)
- Effets: Restitue N/P/K au sol (ex blé : 6-8 kg N, 1-2 kg P, 11-13 kg K par tonne de paille). Alternative au pressage — pas de paille récupérable.

---

### ACTION: [CUL-026] Broyer pierres
**Déclencheur** : Onglet `Parcelles` → onglet Sol → bouton « Broyer les pierres »
**Prérequis** :
- Parcelle avec pierres détectées (analyse de sol)
- Tracteur + broyeur de pierres
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle → onglet « Sol »
2. Vérifier la présence de pierres (indicateur analyse de sol)
3. Cliquer « Broyer les pierres »
4. Sélectionner tracteur + broyeur de pierres
5. Confirmer
**Validations serveur** :
- Vérifier présence de pierres sur la parcelle
- Vérifier possession tracteur + broyeur de pierres
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.pierres = false`, `parcelles.bonus_rendement += 5%`, `parcelles.duree_effet_broyage = 3_saisons`, `joueur.ht -= coût_ht`
- HT: ~3-5 HT pour 10 ha
- €: Coût HVC. Prix ETA : 60 €/ha
- Effets: Supprime le malus de -5% rendement dû aux pierres. Effet dure 3 saisons Cultivia, après quoi les pierres peuvent réapparaître.

---

### ACTION: [CUL-027] Épandre compost
**Déclencheur** : Onglet `Parcelles` → parcelle → « Fertiliser » → « Compost »
**Prérequis** :
- Compost disponible (aire de compostage ou fosse à fumier, 3T fumier → 1T compost, 14 jours de maturation avec 2 retournements)
- Tracteur + épandeur à fumier
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Fertiliser » → « Compost »
3. Sélectionner tracteur + épandeur à fumier
4. Le système calcule : 15 T/ha maximum
5. Confirmer
**Validations serveur** :
- Vérifier stock compost ≥ 15 T × surface ha
- Vérifier possession tracteur + épandeur à fumier
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `stocks.compost -= quantité`, `parcelles.compost_epandu = true`, `parcelles.elements_nutritifs += {N:95, P:60, K:120, Ca:180, Mg:35, S:60}` (kg/ha)
- HT: ~2-4 HT pour 10 ha
- €: Coût HVC. Prix ETA : 35 €/ha
- Effets: Apport équilibré en 6 éléments nutritifs. Compatible bio et prés. Dose max : 15 T/ha. Fabrication : 45 T fumier pour 15 T compost/ha.

---

### ACTION: [CUL-028] Épandre écume de sucrerie
**Déclencheur** : Onglet `Parcelles` → parcelle → « Fertiliser » → « Écume de sucrerie »
**Prérequis** :
- Écume de sucrerie en stock (achetée ou reçue de sucrerie)
- Tracteur + épandeur à fumier
- Dernière application > 5 ans Cultivia sur cette parcelle
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Fertiliser » → « Écume de sucrerie »
3. Sélectionner tracteur + épandeur à fumier
4. Le système calcule : 15 T/ha maximum
5. Confirmer
**Validations serveur** :
- Vérifier stock écume suffisant
- Vérifier dernière application écume > 5 ans sur cette parcelle
- Vérifier possession tracteur + épandeur à fumier
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `stocks.ecume -= quantité`, `parcelles.ecume_epandue = true`, `parcelles.date_ecume = now()`, `parcelles.elements_nutritifs += {N:45, P:120, K:15, Ca:3600, Mg:90, S:0}` (kg/ha)
- HT: ~2-4 HT pour 10 ha
- €: Coût HVC. Prix ETA : 35 €/ha
- Effets: Très riche en calcium (3 600 kg Ca/ha). Utilisable 1 fois tous les 5 ans Cultivia. Idéal pour corriger les sols acides. Dose max : 15 T/ha.

---

### ACTION: [CUL-029] Épandre digestat
**Déclencheur** : Onglet `Parcelles` → parcelle → « Fertiliser » → « Digestat »
**Prérequis** :
- Digestat disponible (résidu de méthanisation, liquide ou solide)
- Tracteur + tonne à lisier (digestat liquide) ou épandeur à fumier (digestat solide)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Fertiliser » → « Digestat »
3. Choisir le type : liquide ou solide
4. Sélectionner le matériel adapté
5. Confirmer
**Validations serveur** :
- Vérifier stock digestat suffisant (liquide : fosse digestat liquide, solide : plateforme digestat solide)
- Vérifier possession matériel adapté
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `stocks.digestat -= quantité`, `parcelles.digestat_epandu = true`, `parcelles.elements_nutritifs += apports`
- Digestat liquide (25 m³/ha) : N:125, P:50, K:300, Ca:47.5, Mg:17.5, S:14.25 kg/ha
- Digestat solide (25 T/ha) : N:100, P:50, K:325, Ca:135, Mg:82.5, S:62.5 kg/ha
- HT: ~2-4 HT pour 10 ha
- €: Coût HVC. Prix ETA : 35 €/ha
- Effets: Sous-produit de la méthanisation. Riche en potassium. Deux formes avec apports nutritifs différents.

---

### ACTION: [CUL-030] Présenter animal au Salon Génétique
**Déclencheur** : Onglet `Animaux` → « Salon Génétique » → bouton « Inscrire un animal »
**Prérequis** :
- Animal adulte, né à la ferme (pas acheté au négociant)
- Animal non issu de race rare (IVRAD)
- HT suffisants
**Étapes** :
1. Aller dans `Animaux` → « Salon Génétique »
2. Consulter les concours en cours par espèce
3. Sélectionner l'animal à présenter
4. Cliquer « Inscrire »
5. Confirmer l'inscription
**Validations serveur** :
- Vérifier animal adulte
- Vérifier animal né à la ferme (pas négociant, pas IVRAD)
- Vérifier HT suffisants
- Vérifier que l'animal n'est pas déjà inscrit à un concours en cours
**Impacts** :
- BDD: Création entrée `genetisim_inscriptions` (animal_id, concours_id, date), `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: 0 € (inscription gratuite)
- Effets: L'animal est évalué sur ses indices génétiques (allure générale principalement). Prime de 5 à 50 € selon l'espèce et le classement. Prestige pour l'éleveur. Résultats publiés en fin de concours.

---

### ACTION: [CUL-031] Acheter animal au salon Salon des Races Rares
**Déclencheur** : Onglet `Animaux` → « Salon Génétique » ou « IVRAD » → onglet « Salon des Races Rares » → bouton « Acheter »
**Prérequis** :
- Salon des Races Rares ouvert (mois de Mai)
- Argent suffisant (prix IVRAD)
- Bâtiment adapté avec capacité disponible
**Étapes** :
1. Aller dans `Animaux` → « IVRAD » → « Salon des Races Rares »
2. Consulter les animaux de races rares disponibles à la vente
3. Filtrer par espèce, race
4. Consulter la fiche de l'animal (indices génétiques, prix IVRAD)
5. Cliquer « Acheter » ou faire une offre
6. Attendre la sélection par le vendeur (samedi/dimanche)
7. Confirmer l'achat si offre acceptée
**Validations serveur** :
- Vérifier salon Salon des Races Rares ouvert (Mai)
- Vérifier solde € suffisant
- Vérifier capacité bâtiment
**Impacts** :
- BDD: `animaux.proprietaire_id = acheteur`, `joueur.solde -= prix_ivrad`
- HT: ~1 HT
- €: Prix IVRAD (variable selon race rare et qualité génétique)
- Effets: Acquisition de races rares. Reproduction naturelle uniquement (pas d'IA). Taux de réussite accouplement : 10-15% selon espèce. Animal de grande valeur génétique.

---

### ACTION: [CUL-032] Objectif génétique IVRAD
**Déclencheur** : Onglet `Animaux` → « IVRAD » → section « Objectifs génétiques » → bouton « Consulter / Valider »
**Prérequis** :
- Animaux adultes nés à la ferme avec score génétique suffisant
- Races non rares uniquement (races classiques)
**Étapes** :
1. Aller dans `Animaux` → « IVRAD »
2. Consulter les objectifs génétiques par espèce (nombre d'animaux requis avec un score génétique minimum)
3. Le système affiche la progression (animaux éligibles / objectif)
4. Si objectif atteint : cliquer « Valider l'objectif »
5. Un slot IVRAD est débloqué
**Validations serveur** :
- Vérifier nombre d'animaux adultes nés à la ferme avec score génétique ≥ seuil requis
- Vérifier races non rares
- Vérifier que l'objectif n'a pas déjà été validé
**Impacts** :
- BDD: `joueur.slots_ivrad += 1`, `objectifs_ivrad.valide = true`
- HT: 0 HT
- €: 0 €
- Effets: Débloque 1 slot IVRAD = possibilité de demander 1 animal de race rare gratuit. Les valeurs génétiques sont recalculées toutes les 24h. Seuls les adultes nés à la ferme comptent.

---

### ACTION: [CUL-033] Demander animal IVRAD
**Déclencheur** : Onglet `Animaux` → « IVRAD » → section « Mes slots » → bouton « Demander un animal »
**Prérequis** :
- Au moins 1 slot IVRAD disponible (débloqué via objectif génétique)
- Bâtiment adapté avec capacité disponible
**Étapes** :
1. Aller dans `Animaux` → « IVRAD » → « Mes slots »
2. Sélectionner un slot disponible
3. Choisir l'espèce et la race rare souhaitée
4. Confirmer la demande
5. L'animal est livré dans l'enclos d'arrivage
**Validations serveur** :
- Vérifier slot IVRAD disponible
- Vérifier capacité bâtiment
- Vérifier que la race rare demandée est disponible
**Impacts** :
- BDD: Création entrée `animaux` (race rare, indices génétiques IVRAD), `joueur.slots_ivrad -= 1`, `animaux.ivrad = true`, `animaux.date_reception_ivrad = now()`, `animaux.delai_min_garde = durée_selon_espèce`
- HT: 0 HT
- €: 0 € (animal gratuit)
- Effets: Animal gratuit mais avec contraintes : garder minimum 84 jours (variable selon espèce). Non vendable aux joueurs. Reproduction naturelle uniquement (taux réussite 10-15%). Objectif : préserver les races rares.

---

### ACTION: [CUL-034] Rendre animal IVRAD
**Déclencheur** : Onglet `Animaux` → fiche animal IVRAD → bouton « Rendre à l'IVRAD »
**Prérequis** :
- Animal IVRAD dont le délai minimum de garde est écoulé
- Délais par espèce : lapins 3 mois, volailles 6 mois, bovins 12 mois (variable selon espèce)
**Étapes** :
1. Sélectionner l'animal IVRAD dans la liste
2. Vérifier que le délai minimum est écoulé
3. Cliquer « Rendre à l'IVRAD »
4. Confirmer le retour
**Validations serveur** :
- Vérifier que l'animal est bien un animal IVRAD
- Vérifier que le délai minimum de garde est écoulé (lapins: 3 mois, volailles: 6 mois, bovins: 12 mois)
- Vérifier que l'animal est vivant
**Impacts** :
- BDD: Suppression entrée `animaux` (retour à l'IVRAD), `joueur.slots_ivrad += 1` (slot récupéré)
- HT: 0 HT
- €: 0 €
- Effets: Le slot IVRAD est libéré et peut être réutilisé pour demander un autre animal. Les petits nés de l'animal IVRAD restent chez le joueur.

---

### ACTION: [CUL-035] Visiter éleveur
**Déclencheur** : Onglet `Animaux` → « Mon chien » ou lien « Visiter un éleveur »
**Prérequis** :
- L'éleveur visité doit avoir ouvert sa ferme aux visites
**Étapes** :
1. Aller dans `Animaux` → « Visiter un éleveur »
2. Rechercher un éleveur par pseudo
3. Ou consulter la liste des éleveurs ayant ouvert leur ferme
4. Cliquer sur le pseudo de l'éleveur
5. Consulter le détail de son cheptel (espèces, races, nombre d'animaux)
**Validations serveur** :
- Vérifier que l'éleveur visité a activé les visites
**Impacts** :
- BDD: Lecture seule — aucune modification
- HT: 0 HT
- €: 0 €
- Effets: Consultation uniquement. Permet de repérer des éleveurs intéressants pour des achats futurs ou des échanges. Aucun impact sur la ferme visitée.

---

### ACTION: [CUL-036] Ouvrir ferme aux visites
**Déclencheur** : Onglet `Animaux` → « Visiter un éleveur » → toggle « Ouvrir ma ferme aux visites »
**Prérequis** :
- Aucun
**Étapes** :
1. Aller dans `Animaux` → « Visiter un éleveur »
2. Cocher/décocher « Ouvrir ma ferme aux visites »
3. Le changement est immédiat
**Validations serveur** :
- Aucune validation spécifique
**Impacts** :
- BDD: `joueur.ferme_ouverte_visites = true/false`
- HT: 0 HT
- €: 0 €
- Effets: Si activé : les autres joueurs peuvent consulter le détail de votre cheptel. Si désactivé : ferme invisible dans l'annuaire des visites. Toggle on/off instantané.


---

## 17. MARAÎCHAGE

> 5 actions couvrant la création de l'activité, le semis/plantation, la récolte, l'emballage et la vente de légumes.

---

### ACTION: [MAR-001] Créer activité maraîchage
**Déclencheur** : Menu `Activités secondaires` → « Maraîchage » → bouton « Créer mon activité maraîchage »
**Prérequis** :

- Argent suffisant pour le personnel minimum
**Étapes** :
1. Aller dans `Activités secondaires` → « Maraîchage »
2. Débloquer l'activité
3. Embaucher le personnel minimum obligatoire :
   - 1 chef de culture (gestion des cultures)
   - 1 chef d'équipe (encadrement)
   - 1 agent administratif (gestion)
   - 1 ouvrier minimum (travaux)
4. Acheter ou construire les infrastructures : serres (plastique/verre, chauffées ou non), tunnels, entrepôt maraîcher, station de conditionnement
5. Confirmer la création
**Validations serveur** :

- Vérifier solde € suffisant pour les salaires
**Impacts** :
- BDD: Création entrée `maraichage` (statut=actif, personnel=[]), `joueur.activite_secondaire = 'maraichage'`
- HT: 0 HT
- €: Salaires mensuels du personnel + coût infrastructures (serres, tunnels, entrepôts)
- Effets: 7 compétences par employé : Semis, Récolte, Traitements, Engrais, Conditionnement, Matériels, Achat/Vente. Chaque compétence influence la qualité et le coût en HT des tâches. Tracteur max 80 CV pour le maraîchage.

---

### ACTION: [MAR-002] Semer / planter légume
**Déclencheur** : Menu `Maraîchage` → « Mes parcelles » → bouton « Semer » ou « Planter »
**Prérequis** :
- Parcelle maraîchère disponible
- Infrastructure adaptée : serre (plastique/verre), tunnel ou plein air
- Semences ou plants en stock
- Personnel disponible (ouvriers avec HT)
**Étapes** :
1. Aller dans `Maraîchage` → « Mes parcelles »
2. Sélectionner la parcelle maraîchère
3. Choisir le mode de culture : serre, tunnel ou plein air
4. Choisir le légume à cultiver
5. Choisir la méthode : semis direct ou plant + plantation
6. Confirmer le semis/plantation
**Validations serveur** :
- Vérifier parcelle maraîchère disponible
- Vérifier infrastructure compatible (serre/tunnel/plein air)
- Vérifier stock semences ou plants suffisant
- Vérifier HT ouvriers suffisants
- Vérifier saison compatible pour le légume choisi
**Impacts** :
- BDD: `parcelle_maraichere.culture = légume`, `parcelle_maraichere.mode = serre/tunnel/plein_air`, `stocks.semences -= quantité`, `ouvriers.ht -= coût_ht`
- HT: Variable selon surface et compétence Semis de l'ouvrier
- €: Semences/plants déjà achetés. Chauffage serre si activé (consomme HVC ou miscanthus).
- Effets: Croissance du légume selon conditions (serre chauffée = plus rapide). Compétence Semis de l'ouvrier influence la qualité. Serre verre > serre plastique > tunnel > plein air en termes de protection.

---

### ACTION: [MAR-003] Récolter légume
**Déclencheur** : Menu `Maraîchage` → « Mes parcelles » → bouton « Récolter » sur une parcelle à maturité
**Prérequis** :
- Légume à maturité
- Personnel disponible (ouvriers)
- Entrepôt maraîcher avec capacité (palox)
- Matériel de récolte si récolte mécanisée
**Étapes** :
1. Sélectionner la parcelle à maturité
2. Choisir le mode de récolte : manuel ou machine (selon légume)
3. Confirmer la récolte
4. Les légumes sont stockés dans l'entrepôt maraîcher (en palox)
**Validations serveur** :
- Vérifier légume à maturité
- Vérifier HT ouvriers suffisants
- Vérifier capacité entrepôt maraîcher
- Si mécanisé : vérifier possession machine de récolte adaptée
**Impacts** :
- BDD: `parcelle_maraichere.etat = 'récoltée'`, `entrepot_maraicher.stock += quantité`, `ouvriers.ht -= coût_ht`
- HT: Variable selon surface et compétence Récolte
- €: Coût HVC si récolte mécanisée
- Effets: Légumes stockés en palox dans l'entrepôt maraîcher. Qualité influencée par la compétence Récolte de l'ouvrier. DLC variable selon le légume.

---

### ACTION: [MAR-004] Emballer légume
**Déclencheur** : Menu `Maraîchage` → « Conditionnement » → bouton « Emballer »
**Prérequis** :
- Légumes récoltés en entrepôt maraîcher
- Station de conditionnement construite
- Chambre froide ou salle de stockage avec capacité
- Personnel disponible
**Étapes** :
1. Aller dans `Maraîchage` → « Conditionnement »
2. Sélectionner le légume à emballer
3. Le système affiche la quantité disponible et la destination de stockage
4. Choisir la destination : chambre froide (légumes fragiles) ou salle de stockage (légumes résistants)
5. Confirmer l'emballage
**Validations serveur** :
- Vérifier stock légumes en entrepôt > 0
- Vérifier station de conditionnement opérationnelle
- Vérifier capacité chambre froide ou salle de stockage
- Vérifier HT ouvriers suffisants
**Impacts** :
- BDD: `entrepot_maraicher.stock -= quantité`, `chambre_froide.stock += quantité` ou `salle_stockage.stock += quantité`, `ouvriers.ht -= coût_ht`
- HT: Variable selon quantité et compétence Conditionnement
- €: 0 € direct (emballages déjà en stock)
- Effets: Légumes emballés prêts à la vente. Un seul type de légume par chambre froide ou salle de stockage. Compétence Conditionnement influence la qualité de l'emballage.

---

### ACTION: [MAR-005] Vendre légume au marché
**Déclencheur** : Menu `Maraîchage` → « Ventes » → bouton « Vendre au marché »
**Prérequis** :
- Légumes emballés en stock
- Utilitaire disponible
- Kit exposant acheté (2 500 €)
- HT suffisants
**Étapes** :
1. Aller dans `Maraîchage` → « Ventes » → « Marché »
2. Sélectionner le marché
3. Charger l'utilitaire avec les légumes emballés
4. Se rendre au marché (1-4 HT par marché)
5. Vendre aux clients
**Validations serveur** :
- Vérifier légumes emballés en stock
- Vérifier utilitaire + kit exposant (2 500 €)
- Vérifier HT suffisants
- Vérifier max 4 marchés par jour
**Impacts** :
- BDD: `stock_legumes -= quantité_vendue`, `joueur.solde += recette_vente`, `joueur.ht -= coût_ht`
- HT: 1-4 HT par marché
- €: Kit exposant : 2 500 € (achat unique). Recette de vente variable selon légume et saison.
- Effets: Maximum 4 marchés par jour. Prix influencé par la saison et l'offre/demande. DLC à respecter.

---

### ACTION: [MAR-006] Convertir parcelle en bio
**Déclencheur** : Onglet `Parcelles` → parcelle → onglet « Options » → bouton « Convertir en bio »
**Prérequis** :
- Parcelle en agriculture conventionnelle
- Aucun traitement phytosanitaire chimique en cours
- HT suffisants
**Étapes** :
1. Sélectionner la parcelle → onglet « Options »
2. Cliquer « Convertir en bio »
3. Le système affiche les contraintes : 2 saisons de conversion, pas de traitements chimiques, rotation allongée (+1 an)
4. Confirmer la conversion
**Validations serveur** :
- Vérifier parcelle non déjà en bio ou en conversion
- Vérifier aucun traitement chimique actif
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.mode = 'conversion_bio'`, `parcelles.date_debut_conversion = now()`, `parcelles.saisons_conversion_restantes = 2`
- HT: ~0.5 HT
- €: 0 €
- Effets: Pendant 2 saisons : parcelle en conversion (pas encore label bio). Interdiction traitements chimiques (herbicide, fongicide, insecticide). Rotation allongée de +1 an. Après conversion : récoltes bio (+20% prix de vente). Rendements potentiellement plus faibles sans traitements ni engrais chimiques.

---

### ACTION: [MAR-007] Convertir parcelle en pré
**Déclencheur** : Onglet `Parcelles` → parcelle → onglet « Options » → bouton « Convertir en pré »
**Prérequis** :
- Parcelle de type champ (non pré)
- Semences d'herbe en stock
- Tracteur + semoir
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Convertir en pré »
3. Sélectionner tracteur + semoir
4. Confirmer le semis d'herbe
**Validations serveur** :
- Vérifier parcelle de type champ
- Vérifier stock semences herbe
- Vérifier possession tracteur + semoir
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.type = 'pré'`, `parcelles.culture = 'herbe'`, `parcelles.etat = 'semée'`, `joueur.ht -= coût_ht`
- HT: ~2-3 HT pour 10 ha
- €: Coût HVC + semences
- Effets: La parcelle devient un pré utilisable pour le pâturage des animaux. Herbe récoltable (fauche → foin). Conversion irréversible sans nouveau travail du sol.

---

### ACTION: [MAR-008] Vendre récolte à la coopérative
**Déclencheur** : Onglet `Bâtiments` → silo contenant la récolte → bouton « Vendre »
**Prérequis** :
- Récolte en stock dans un silo
- HT suffisants
**Étapes** :
1. Aller dans `Bâtiments` → sélectionner le silo
2. Cliquer « Vendre »
3. Choisir « Coopérative Cultivia » ou « CAR » (si contrat)
4. Indiquer la quantité à vendre
5. Le système affiche le prix (variable selon saison et offre/demande)
6. Confirmer la vente
**Validations serveur** :
- Vérifier stock suffisant dans le silo
- Vérifier HT suffisants
**Impacts** :
- BDD: `silos.stock -= quantité`, `joueur.solde += quantité × prix_unitaire`, `joueur.ht -= coût_ht`
- HT: ~0.5 HT
- €: Prix variable selon culture et saison (ex: blé ~100 €/T, colza ~220 €/T). Bio : +20%. Prix dynamiques selon offre/demande.
- Effets: Argent crédité immédiatement. Prix fluctue selon la saison Cultivia et l'offre/demande régionale.

---

### ACTION: [MAR-009] Vendre récolte par annonce
**Déclencheur** : Onglet `Bâtiments` → silo → « Achats/Ventes » → bouton « Passer une annonce »
**Prérequis** :
- Récolte en stock
- 1 500 € pour les frais de parution
**Étapes** :
1. Aller dans `Bâtiments` → « Achats/Ventes »
2. Cliquer « Passer une annonce »
3. Sélectionner le produit et la quantité
4. Fixer le prix de vente (libre)
5. Payer les frais de parution (1 500 €)
6. Confirmer — annonce visible 7 jours
**Validations serveur** :
- Vérifier stock suffisant
- Vérifier solde ≥ 1 500 €
**Impacts** :
- BDD: Création `annonces` (produit, quantité, prix, vendeur, durée=7j), `joueur.solde -= 1500`
- HT: 0 HT
- €: 1 500 € frais de parution
- Effets: Annonce visible 7 jours par les autres joueurs. Transport à la charge de l'acheteur. Prix libre — potentiellement plus rentable que la coopérative.

---

### ACTION: [MAR-010] Acheter semences
**Déclencheur** : Onglet `Coopérative` → « Semences » → bouton « Acheter »
**Prérequis** :
- Argent suffisant
- Stockage disponible (entrepôt)
**Étapes** :
1. Aller dans `Coopérative` → « Semences »
2. Sélectionner la culture (blé, orge, maïs, colza, etc.)
3. Choisir la culture et la quantité (kg/ha selon culture)
4. Indiquer la quantité (kg)
5. Confirmer l'achat
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier capacité stockage entrepôt
**Impacts** :
- BDD: `stocks.semences += quantité`, `joueur.solde -= quantité × 0.35`
- HT: 0 HT
- €: ~0.35 €/kg (prix moyen coopérative). Prix variable selon culture.
- Effets: Semences livrées immédiatement en stock. Quantité nécessaire dépend de la culture et de la surface.

---

### ACTION: [MAR-011] Acheter engrais
**Déclencheur** : Onglet `Coopérative` → « Engrais » → bouton « Acheter »
**Prérequis** :
- Argent suffisant
- Stockage disponible (entrepôt)
**Étapes** :
1. Aller dans `Coopérative` → « Engrais »
2. Sélectionner le type d'engrais parmi les 6 éléments : Azote (N), Phosphore (P), Potassium (K), Calcium (Ca), Magnésium (Mg), Soufre (S)
3. Indiquer la quantité (kg)
4. Confirmer l'achat
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier capacité stockage
**Impacts** :
- BDD: `stocks.engrais_type += quantité`, `joueur.solde -= prix_total`
- HT: 0 HT
- €: Prix variable selon type d'engrais
- Effets: 6 types d'engrais correspondant aux 6 éléments nutritifs du sol. Analyse de sol recommandée pour optimiser les apports. Version bio disponible pour parcelles en agriculture biologique.

---

### ACTION: [MAR-012] Acheter traitements phytosanitaires
**Déclencheur** : Onglet `Coopérative` → « Traitements » → bouton « Acheter »
**Prérequis** :
- Argent suffisant
- Stockage disponible
**Étapes** :
1. Aller dans `Coopérative` → « Traitements »
2. Sélectionner le type : fongicide, herbicide ou insecticide
3. Indiquer la quantité (litres)
4. Confirmer l'achat
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier capacité stockage
**Impacts** :
- BDD: `stocks.traitement_type += quantité`, `joueur.solde -= quantité × 9`
- HT: 0 HT
- €: 9 €/L. Dose d'application : 1.6 L/ha.
- Effets: 3 types de traitements chimiques. Non utilisables sur parcelles bio. Protègent contre maladies (fongicide), mauvaises herbes (herbicide) et ravageurs (insecticide).

---

## 9. SOCIAL — ACTIONS

> ~11 actions couvrant les amis, la messagerie, les forums, le parrainage, la garde de ferme, la formation CFCA et le CECA.

---

### ACTION: [SOC-001] Ajouter ami
**Déclencheur** : Menu Social → « Mes amis » → bouton « Ajouter un ami »
**Prérequis** :
- Connaître le pseudo du joueur à ajouter
**Étapes** :
1. Aller dans le menu Social → « Mes amis »
2. Cliquer « Ajouter un ami »
3. Rechercher le joueur par pseudo
4. Envoyer la demande d'ami
5. Le joueur reçoit une notification et peut accepter ou refuser
6. Si accepté : relation « Ami » établie. Si même région : « Ami privilégié ». Si ajout réciproque mutuel : « Ami spécial ».
**Validations serveur** :
- Vérifier que le pseudo existe
- Vérifier que la relation n'existe pas déjà
**Impacts** :
- BDD: Création entrée `amis` (joueur_1, joueur_2, niveau, date)
- HT: 0 HT
- €: 0 €
- Effets: 3 niveaux d'amitié avec avantages croissants — Ami : achat matériel en commun (même région). Ami privilégié (même région) : échange de marchandises. Ami spécial (ajout réciproque) : vente privée animaux/matériel/parcelles + tchat privé.

---

### ACTION: [SOC-002] Envoyer message (messagerie interne)
**Déclencheur** : Menu Social → « Messagerie » → bouton « Nouveau message »
**Prérequis** :
- Connaître le pseudo du destinataire
**Étapes** :
1. Aller dans Social → « Messagerie »
2. Cliquer « Nouveau message »
3. Saisir le pseudo du destinataire
4. Rédiger le message (objet + corps)
5. Envoyer
**Validations serveur** :
- Vérifier que le destinataire existe
- Vérifier que le joueur n'est pas bloqué par le destinataire
**Impacts** :
- BDD: Création entrée `messages` (expediteur, destinataire, objet, corps, date, lu=false)
- HT: 0 HT
- €: 0 €
- Effets: Message reçu dans la boîte de réception du destinataire. Les messages de plus de 30 jours sont automatiquement supprimés. Notification au destinataire.

---

### ACTION: [SOC-003] Envoyer MP-Live (messagerie instantanée)
**Déclencheur** : Bandeau MP-Live en haut de page → cliquer sur un contact → saisir message
**Prérequis** :
- Destinataire connecté (ou hors ligne — le message sera reçu à la connexion)
**Étapes** :
1. Cliquer sur le bandeau MP-Live en haut de l'interface
2. Sélectionner un contact ou saisir un pseudo
3. Taper le message dans la zone de saisie
4. Envoyer (Entrée)
**Validations serveur** :
- Vérifier que le destinataire existe
- Vérifier que le joueur n'est pas bloqué
**Impacts** :
- BDD: Création entrée `mp_live` (expediteur, destinataire, message, timestamp)
- HT: 0 HT
- €: 0 €
- Effets: Message instantané, cross-serveur (fonctionne entre serveurs différents). Notification en temps réel si le destinataire est connecté. Historique de conversation consultable.

---

### ACTION: [SOC-004] Poster sur forum
**Déclencheur** : Menu Social → « Forums » → sélectionner un forum → bouton « Nouveau sujet » ou « Répondre »
**Prérequis** :
- Compte actif
**Étapes** :
1. Aller dans Social → « Forums »
2. Choisir le forum : régional (par région du joueur) ou thématique (élevage, cultures, matériel, etc.)
3. Créer un nouveau sujet ou répondre à un sujet existant
4. Rédiger le message
5. Publier
**Validations serveur** :
- Vérifier que le joueur n'est pas banni du forum
- Vérifier contenu non vide
**Impacts** :
- BDD: Création entrée `forum_posts` (forum_id, sujet_id, auteur, contenu, date)
- HT: 0 HT
- €: 0 €
- Effets: Message visible par tous les joueurs du forum. Forums modérés (signalement possible). Forums régionaux : visibles uniquement par les joueurs de la région. Forums thématiques : accessibles à tous.

---

### ACTION: [SOC-005] Parrainer un ami
**Déclencheur** : Menu Social → « Parrainage » → bouton « Obtenir mon lien de parrainage »
**Prérequis** :
- Compte actif
**Étapes** :
1. Aller dans Social → « Parrainage »
2. Copier le lien de parrainage unique
3. Envoyer le lien à un ami (par email, messagerie externe, etc.)
4. L'ami s'inscrit via le lien
5. Bonus attribué si l'ami reste actif
**Validations serveur** :
- Vérifier que le filleul s'est inscrit via le lien de parrainage
- Vérifier que le filleul est un nouveau joueur (pas de multi-compte)
**Impacts** :
- BDD: Création entrée `parrainages` (parrain_id, filleul_id, date, statut), bonus crédité au parrain si conditions remplies
- HT: 0 HT
- €: Bonus parrain (variable, ex: prime en € virtuels si le filleul atteint un certain niveau d'activité)
- Effets: Classement des parrains consultable. Récompenses progressives selon le nombre de filleuls actifs.

---

### ACTION: [SOC-006] Activer garde de ferme
**Déclencheur** : Menu Social → « Garde de ferme » → bouton « Sélectionner un gardien »
**Prérequis** :
- Trouver un gardien disponible dans l'annuaire des gardiens (même zone/région)
- Contacter le gardien au préalable pour convenir des modalités
**Étapes** :
1. Aller dans Social → « Garde de ferme »
2. Consulter l'annuaire des gardiens disponibles
3. Contacter un gardien pour discuter des instructions
4. Sélectionner le gardien et saisir la date de début de garde
5. Le gardien accepte ou refuse
6. À la date prévue : la ferme passe automatiquement sous garde (ou activation manuelle avant)
7. Laisser des instructions sur le bloc-notes « Ma ferme »
**Validations serveur** :
- Vérifier que le gardien a accepté
- Vérifier date de début de garde valide
**Impacts** :
- BDD: `joueur.en_garde = true`, `joueur.gardien_id = gardien`, `joueur.date_debut_garde = date`
- HT: 0 HT à l'activation
- €: 150 € au retour (payé par le propriétaire au moment de la reprise)
- Effets: Le gardien a accès à la ferme et peut effectuer les actions quotidiennes (nourrir, abreuver, traire, etc.). Le propriétaire ne peut plus agir sur sa ferme pendant la garde. Au retour : payer 150 € et notifier le gardien que la garde est terminée.


---

## 18. VITICULTURE

> 8 actions couvrant l'achat de domaine, la plantation, la taille, les vendanges, la vinification, l'assemblage, la mise en bouteille/fût et la vente de vin.

---

### ACTION: [VIT-001] Acheter domaine viticole
**Déclencheur** : Menu `Activités secondaires` → « Viticulture » → bouton « Acheter un domaine »
**Prérequis** :

- Budget suffisant (max 500 000 € virements + 350 000 € emprunts = 850 000 €)
**Étapes** :
1. Aller dans `Activités secondaires` → « Viticulture »
2. Choisir la région viticole
3. Le domaine comprend 4 parcelles de 2 500 m² chacune
4. Consulter les caractéristiques du domaine (terroir, cépages autorisés)
5. Confirmer l'achat
**Validations serveur** :

- Vérifier solde € + emprunts ≤ 850 000 €
**Impacts** :
- BDD: Création entrée `domaines_viticoles` (region, 4 parcelles de 2500m²), `joueur.solde -= prix_domaine`
- HT: 0 HT
- €: Variable selon région (budget max 850 000 €)
- Effets: Le domaine comprend 4 parcelles initiales de 2 500 m². Possibilité d'acheter des parcelles supplémentaires (500-10 000 m²). Nécessite un hangar (matériel max 80 CV), un chai (vinification) et une cave (stockage). Embaucher au minimum un agent viticole et un maître de chai.

---

### ACTION: [VIT-002] Planter vigne
**Déclencheur** : Menu `Viticulture` → « Mes parcelles » → bouton « Planter » sur une parcelle vide
**Prérequis** :
- Parcelle viticole vide ou arrachée
- Saison : décembre à janvier
- Cépages disponibles pour la région
- Agent viticole embauché
**Étapes** :
1. Sélectionner la parcelle viticole vide
2. Cliquer « Planter »
3. Choisir le cépage (selon la région viticole)
4. Confirmer la plantation (6 000 ceps/ha)
**Validations serveur** :
- Vérifier parcelle vide
- Vérifier saison décembre-janvier
- Vérifier cépage autorisé dans la région
- Vérifier HT agent viticole suffisants
**Impacts** :
- BDD: `parcelle_viticole.cepage = X`, `parcelle_viticole.nb_ceps = 6000/ha`, `parcelle_viticole.etat = 'plantée'`, `agent_viticole.ht -= coût_ht`
- HT: Variable selon surface et compétence Vitesse de l'agent
- €: Coût des plants de vigne
- Effets: 6 000 ceps par hectare. La vigne met plusieurs années avant de produire du raisin de qualité. Compétences de l'agent viticole : Vitesse d'exécution et Qualité du travail.

---

### ACTION: [VIT-003] Tailler vigne
**Déclencheur** : Menu `Viticulture` → « Mes parcelles » → bouton « Tailler »
**Prérequis** :
- Vigne plantée et en période de taille
- Agent viticole embauché avec HT suffisants
**Étapes** :
1. Sélectionner la parcelle viticole
2. Cliquer « Tailler »
3. L'agent viticole effectue la taille
4. Confirmer
**Validations serveur** :
- Vérifier vigne plantée
- Vérifier période de taille
- Vérifier HT agent viticole suffisants
**Impacts** :
- BDD: `parcelle_viticole.taillee = true`, `agent_viticole.ht -= coût_ht`
- HT: Variable selon surface et compétence Vitesse de l'agent
- €: 0 €
- Effets: La taille influence le rendement et la qualité du raisin. Compétence Qualité de l'agent viticole détermine la qualité de la taille. Une vigne mal taillée produit moins et de moindre qualité.

---

### ACTION: [VIT-004] Vendanger
**Déclencheur** : Menu `Viticulture` → « Mes parcelles » → bouton « Vendanger » (octobre)
**Prérequis** :
- Raisin à maturité (octobre)
- Vendangeurs saisonniers embauchés (délai de 2 jours entre embauche et début de travail)
- HT vendangeurs suffisants
**Étapes** :
1. Embaucher des vendangeurs saisonniers (anticiper le délai de 2 jours)
2. Sélectionner la parcelle à vendanger
3. Cliquer « Vendanger »
4. Les vendangeurs récoltent le raisin
5. Le raisin est transporté au chai
**Validations serveur** :
- Vérifier raisin à maturité
- Vérifier vendangeurs embauchés et disponibles
- Vérifier HT vendangeurs suffisants
**Impacts** :
- BDD: `parcelle_viticole.etat = 'vendangée'`, `chai.stock_raisin += quantité_kg`, `vendangeurs.ht -= coût_ht`
- HT: 0.020 HT/kg de raisin récolté (taux de base vendangeur)
- €: Salaire des vendangeurs saisonniers
- Effets: Quantité de raisin dépend du rendement (ceps, taille, traitements, météo). Délai de 2 jours entre embauche et disponibilité du vendangeur. Vendanges uniquement en octobre.

---

### ACTION: [VIT-005] Vinifier
**Déclencheur** : Menu `Viticulture` → « Chai » → bouton « Vinifier »
**Prérequis** :
- Raisin en stock au chai
- Maître de chai embauché
- Chai construit et équipé
**Étapes** :
1. Aller dans `Viticulture` → « Chai »
2. Sélectionner le raisin à vinifier (par cépage)
3. Lancer la fermentation (3-7 jours selon type de vin)
4. Le maître de chai supervise la fermentation
**Validations serveur** :
- Vérifier stock raisin au chai > 0
- Vérifier maître de chai embauché
- Vérifier chai opérationnel
**Impacts** :
- BDD: `chai.stock_raisin -= quantité_kg`, `chai.stock_vin += quantité_kg × 0.667` (1.5 kg raisin = 1 L vin), `chai.fermentation_en_cours = true`
- HT: HT du maître de chai
- €: 0 € direct
- Effets: Ratio : 1.5 kg de raisin = 1 litre de vin. Fermentation : 3-7 jours. Toutes les compétences du maître de chai sont prises en compte pour la qualité du vin. Entretien et nettoyage du chai par le maître de chai.

---

### ACTION: [VIT-006] Assembler vin
**Déclencheur** : Menu `Viticulture` → « Chai » → bouton « Assembler »
**Prérequis** :
- Au moins 2 cépages vinifiés disponibles (max 5)
- Maître de chai embauché et maîtrisant les cépages concernés
**Étapes** :
1. Aller dans `Viticulture` → « Chai » → « Assemblage »
2. Sélectionner les cépages à assembler (2 à 5)
3. Définir les proportions de chaque cépage
4. Choisir le type d'assemblage :
   - **Certifié** : respecte les règles d'appellation (éligible aux concours)
   - **Libre** : proportions libres (non éligible aux concours)
5. Confirmer l'assemblage
**Validations serveur** :
- Vérifier 2-5 cépages disponibles
- Vérifier maître de chai maîtrise les cépages
- Si certifié : vérifier respect des règles d'appellation
**Impacts** :
- BDD: Création entrée `vins_assembles` (cepages[], proportions[], type=certifié/libre), `chai.stock_vin_cepage -= quantités`
- HT: HT du maître de chai
- €: 0 €
- Effets: L'assemblage certifié permet de participer au concours Concours Viticole. L'assemblage libre offre plus de flexibilité. La qualité dépend des compétences du maître de chai et de la qualité des vins assemblés.

---

### ACTION: [VIT-007] Mettre en bouteille / fût
**Déclencheur** : Menu `Viticulture` → « Cave » → bouton « Embouteiller » ou « Mettre en fût »
**Prérequis** :
- Vin vinifié ou assemblé disponible
- Équipement d'embouteillage (manuel ou automatique) ou fûts
- Cave construite
**Étapes** :
1. Aller dans `Viticulture` → « Cave »
2. Sélectionner le vin à conditionner
3. Choisir le conditionnement :
   - **Bouteille** : embouteillage manuel ou automatique
   - **Fût** : vieillissement en fût (améliore la qualité au fil du temps)
4. Confirmer
**Validations serveur** :
- Vérifier stock vin disponible
- Vérifier équipement d'embouteillage ou fûts disponibles
- Vérifier capacité cave
**Impacts** :
- BDD: `chai.stock_vin -= quantité`, `cave.stock_bouteilles += nb_bouteilles` ou `cave.stock_futs += nb_futs`
- HT: Variable selon équipement (manuel = plus de HT, auto = moins)
- €: Coût des bouteilles/bouchons ou des fûts
- Effets: Le vin en fût s'améliore avec le temps (qualité augmente progressivement). Le vin en bouteille est prêt à la vente. Équipement automatique = économie de HT.

---

### ACTION: [VIT-008] Vendre vin
**Déclencheur** : Menu `Viticulture` → « Ventes » → bouton « Vendre »
**Prérequis** :
- Vin en bouteille ou en fût disponible
- Vendeur caviste embauché (optionnel mais +2 €/bouteille)
**Étapes** :
1. Aller dans `Viticulture` → « Ventes »
2. Choisir le mode de vente :
   - **À Cultivia** : vente à la coopérative (prix fixe)
   - **Depuis le domaine** : vente directe (vendeur caviste recommandé)
3. Sélectionner le vin et la quantité
4. Fixer le prix (si vente directe)
5. Confirmer la vente
**Validations serveur** :
- Vérifier stock vin en bouteille/fût > 0
- Vérifier HT suffisants
**Impacts** :
- BDD: `cave.stock_bouteilles -= quantité` ou `cave.stock_futs -= quantité`, `joueur.solde += recette_vente`
- HT: Variable
- €: Prix de vente variable. Vendeur caviste : +2 €/bouteille vendue.
- Effets: Le vendeur caviste (contrat long terme obligatoire, au moins 1) ajoute +2 €/bouteille. Concours Viticole en septembre : les meilleurs vins certifiés sont récompensés. Qualité du vin = facteur principal du prix.

---

### ACTION: [VIT-009] Garder ferme d'un joueur
**Déclencheur** : Menu Social → « Garde de ferme » → section « Mes clients » → accepter une demande de garde
**Prérequis** :
- Avoir été contacté par un joueur souhaitant faire garder sa ferme
- Maximum 5 fermes gardées simultanément
**Étapes** :
1. Aller dans Social → « Garde de ferme »
2. Consulter la section « Mes clients ou futurs clients »
3. Accepter la demande de garde
4. À la date de début : accéder à la ferme du joueur absent
5. Effectuer les actions quotidiennes selon les instructions laissées
6. Attendre la notification de retour du propriétaire
**Validations serveur** :
- Vérifier maximum 5 fermes gardées simultanément
- Vérifier que la demande de garde est valide
**Impacts** :
- BDD: `garde.gardien_id = joueur`, `garde.statut = 'active'`
- HT: Les HT du gardien sont utilisés pour les actions sur la ferme gardée
- €: 120 €/jour payé par Cultivia au gardien (rémunération automatique)
- Effets: Le gardien utilise ses propres HT pour travailler sur la ferme gardée. Rémunération de 120 €/jour par Cultivia. Évaluation par le propriétaire au retour. Historique des gardes consultable.

---

### ACTION: [VIT-010] S'inscrire formation CFCA
**Déclencheur** : Menu Social → « Formation CFCA » → bouton « S'inscrire »
**Prérequis** :
- Inscription au jeu depuis moins de 14 jours
- Trouver un maître-exploitant (joueur inscrit depuis >168 jours) acceptant de former
**Étapes** :
1. Aller dans Social → « Formation CFCA »
2. Consulter les maîtres-exploitants disponibles dans sa région
3. Contacter un maître-exploitant pour lui demander d'accepter la formation
4. Une fois le maître-exploitant trouvé : cliquer « S'inscrire »
5. La formation dure 42 jours Cultivia (6 mois en jeu)
6. Suivre les instructions du maître-exploitant pendant la formation
**Validations serveur** :
- Vérifier inscription < 14 jours
- Vérifier qu'un maître-exploitant a accepté
- Vérifier que le joueur n'est pas déjà en formation
**Impacts** :
- BDD: Création entrée `formations_cfsa` (stagiaire_id, maitre_id, date_debut, duree=42j, statut='en_cours')
- HT: 0 HT
- €: 0 € pendant la formation. Bonus de 25 000 € si formation complétée avec succès.
- Effets: Le stagiaire bénéficie des conseils du maître-exploitant. Formation de 42 jours (6 mois Cultivia). À la fin : aide de 25 000 € pour bien démarrer. Le maître-exploitant doit être inscrit depuis >168 jours.

---

### ACTION: [VIT-011] Voter CECA
**Déclencheur** : Menu CECA → « Élections » → bouton « Voter » (mois de Juin)
**Prérequis** :
- Élections CECA en cours (mois de Juin Cultivia)
- Joueur inscrit et actif
**Étapes** :
1. Aller dans CECA → « Élections »
2. Consulter la liste des candidats de sa région (fiches de campagne, convictions 1-10)
3. Sélectionner jusqu'à 3 candidats
4. Confirmer le vote
**Validations serveur** :
- Vérifier période électorale (Juin)
- Vérifier que le joueur n'a pas déjà voté
- Vérifier 1 à 3 candidats sélectionnés
**Impacts** :
- BDD: Création entrée `votes_cesa` (joueur_id, candidats[], date), `joueur.a_vote_cesa = true`
- HT: 0 HT
- €: 0 €
- Effets: 3 représentants élus par région. Les élus siègent au CECA pour une saison. Ils votent les cotisations, taxes, primes et aides régionales/nationales.

---

### ACTION: [VIT-012] Proposer vote CECA (représentant élu)
**Déclencheur** : Menu CECA → « Propositions » → bouton « Nouvelle proposition »
**Prérequis** :
- Être représentant CECA élu
- Mandat en cours
**Étapes** :
1. Aller dans CECA → « Propositions »
2. Cliquer « Nouvelle proposition »
3. Choisir le type de décision : cotisations professionnelles (% sur CA si >85 000 €), taxe foncière (€/ha si >100 ha), aide jeune agriculteur, prix HVC régional, primes cultures, salaire garde de ferme
4. Définir les paramètres de la proposition
5. Soumettre au vote des autres représentants
6. Les représentants votent (majorité simple)
**Validations serveur** :
- Vérifier statut de représentant CECA élu
- Vérifier mandat en cours
- Vérifier que la proposition est dans le cadre des compétences CECA
**Impacts** :
- BDD: Création entrée `propositions_cesa` (auteur, type, parametres, votes_pour, votes_contre, statut)
- HT: 0 HT
- €: 0 €
- Effets: Si adoptée : la décision s'applique à toute la région (ou au niveau national selon le type). Impacte tous les joueurs de la région : cotisations, taxes, primes, prix HVC. Historique des propositions et votes consultable.

---

### ACTION: [VIT-013] Se porter candidat CECA
**Déclencheur** : Menu CECA → « Élections » → bouton « Se porter candidat » (mois d'Avril)
**Prérequis** :
- Ancienneté > 90 jours d'inscription
- Période d'inscription : mois d'Avril Cultivia
- Campagne : mois de Mai Cultivia
- Élection : mois de Juin Cultivia
**Étapes** :
1. Aller dans CECA → « Élections » pendant le mois d'Avril
2. Cliquer « Se porter candidat »
3. Remplir la fiche de campagne : convictions sur 10 critères (élevage, cultures, proximité, entraide, intégration, activités secondaires, qualité travail, dépenses, développement ferme, image agricole)
4. Confirmer la candidature
5. Mois de Mai : campagne (fiche visible par les électeurs)
6. Mois de Juin : élection (vote des joueurs)
**Validations serveur** :
- Vérifier ancienneté > 90 jours
- Vérifier période d'inscription (Avril)
- Vérifier que le joueur n'est pas déjà candidat
**Impacts** :
- BDD: Création entrée `candidats_cesa` (joueur_id, region, convictions[], date_candidature)
- HT: 0 HT
- €: 0 €
- Effets: Si élu (top 3 de la région) : mandat d'une saison Cultivia. Pouvoir de proposer et voter des décisions économiques régionales/nationales. Statistiques du mandat visibles (propositions faites, votes effectués, assiduité).

---

---

### ACTION: [VIT-014] Défanage chimique pomme de terre
**Déclencheur** : Onglet `Parcelles` → parcelle PDT → « Travail possible » → bouton « Défaner »
**Prérequis** :
- Culture de pomme de terre en cours, ~1 mois avant récolte
- Tracteur + pulvérisateur
- Produit de défanage en stock (2.5 L/ha)
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle de PDT
2. Cliquer « Défaner »
3. Sélectionner tracteur + pulvérisateur
4. Confirmer
**Validations serveur** :
- Vérifier culture PDT en cours, stade compatible (1 mois avant récolte)
- Vérifier stock produit défanage ≥ 2.5 L × surface ha
- Vérifier possession tracteur + pulvérisateur
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.defanee = true`, `stocks.defanage -= 2.5 × surface`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT pour 10 ha
- €: Coût HVC + produit déjà acheté
- Effets: Détruit les fanes pour faciliter l'arrachage et améliorer la conservation. Doit être fait ~1 mois avant la récolte.

---

### ACTION: [VIT-015] Stocker PDT en ligne de stockage
**Déclencheur** : Onglet `Bâtiments` → stockage PDT → bouton « Stocker »
**Prérequis** :
- Ligne de stockage PDT achetée (100 000 €, équipement fixe : pré-trémie, calibreuse, table d'inspection, séparateur, remplisseur palox, dégermeuse)
- Bâtiment de stockage PDT construit (climatisé, 100 €/T stockée)
- Récolte PDT disponible, dans les 2 jours suivant l'arrachage
- HT suffisants
**Étapes** :
1. Aller dans `Bâtiments` → stockage PDT
2. Cliquer « Stocker »
3. Sélectionner la quantité à stocker
4. Confirmer
**Validations serveur** :
- Vérifier possession ligne de stockage + bâtiment stockage PDT
- Vérifier récolte PDT disponible et ≤ 2 jours après arrachage
- Vérifier capacité stockage suffisante
- Vérifier HT suffisants
**Impacts** :
- BDD: `stocks.pdt_stockees += quantité`, `silos.pdt -= quantité`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT
- €: 0 € (équipement déjà acheté). Investissement initial : 100 000 € (ligne) + 100 €/T (bâtiment).
- Effets: Stockage possible de la récolte jusqu'au 7 juin. Si non stocké dans les 2 jours : 7 jours pour vendre à Cultivia à prix réduit, sinon perte. Permet d'accéder au marché PDT (filière).

---

### ACTION: [VIT-016] Vendre PDT via filière
**Déclencheur** : Onglet `Bâtiments` → stockage PDT → bouton « Consulter les offres »
**Prérequis** :
- PDT stockées en ligne de stockage
- Période : décembre à juin
**Étapes** :
1. Aller dans `Bâtiments` → stockage PDT
2. Cliquer « Consulter les offres »
3. Consulter les propositions hebdomadaires (au moins 2 offres/qualité sur le marché régional, parfois offres nationales/internationales)
4. Sélectionner une offre
5. Organiser le transport (transporteur)
6. Confirmer la vente
**Validations serveur** :
- Vérifier stock PDT suffisant
- Vérifier période décembre-juin
- Vérifier offre encore valide
**Impacts** :
- BDD: `stocks.pdt_stockees -= quantité`, `joueur.solde += prix_vente`
- HT: ~0.5 HT
- €: Prix variable selon offre, qualité et marché (régional/national/international). Transport à la charge du vendeur.
- Effets: Propositions hebdomadaires de décembre à juin. Prix potentiellement supérieur à la vente directe coopérative. Stock restant après le 7 juin = détruit automatiquement.

---

### ACTION: [VIT-017] Planter arbres (arboriculture)
**Déclencheur** : Onglet `Parcelles` → verger → « Travail possible » → bouton « Planter »
**Prérequis** :
- Parcelle de type verger
- Mois de décembre ou janvier
- Plants d'arbres en stock (achetés à la coopérative)
- Tracteur arbo (≤80 CV) + matériel étroit
- HT et HVC suffisants
**Étapes** :
1. Sélectionner le verger
2. Cliquer « Planter »
3. Choisir l'espèce (pommier 1000/ha, poirier 1200/ha, pêcher 476/ha, prunier 250/ha, mirabellier 200/ha, framboisier 5000/ha, etc.)
4. Sélectionner tracteur + planteuse
5. Confirmer
**Validations serveur** :
- Vérifier type parcelle = verger
- Vérifier mois = décembre ou janvier
- Vérifier stock plants suffisant (200-1200 arbres/ha selon espèce, jusqu'à 5000 pour petits fruits)
- Vérifier possession tracteur arbo + matériel
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `parcelles.culture = espèce`, `parcelles.nb_arbres = densité × surface`, `parcelles.age_verger = 0`, `stocks.plants -= quantité`
- HT: ~3-5 HT pour 1 ha
- €: Coût HVC + plants déjà achetés. Prix ETA : 120 €/ha.
- Effets: Rendement faible la 1ère année, optimal à partir de la 4ème année (6ème pour prunier, 8ème pour mirabellier). Nécessite tracteur ≤80 CV et matériel étroit.

---

### ACTION: [VIT-018] Tailler arbres
**Déclencheur** : Onglet `Parcelles` → verger → « Travail possible » → bouton « Tailler »
**Prérequis** :
- Verger avec arbres plantés
- Kit de taille (manuel)
- HT suffisants
**Étapes** :
1. Sélectionner le verger
2. Cliquer « Tailler »
3. Confirmer (travail manuel)
**Validations serveur** :
- Vérifier présence d'arbres dans le verger
- Vérifier possession kit de taille
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.taille_effectuee = true`, `joueur.ht -= coût_ht`
- HT: ~2-5 HT pour 1 ha (travail manuel intensif)
- €: 0 € (kit déjà acheté)
- Effets: Améliore le rendement et la qualité des fruits. Taille au bon moment = meilleurs résultats. Nécessite beaucoup de personnel.

---

### ACTION: [VIT-019] Éclaircir arbres
**Déclencheur** : Onglet `Parcelles` → verger → « Travail possible » → bouton « Éclaircir »
**Prérequis** :
- Verger avec arbres morts ou en surnombre
- HT suffisants
**Étapes** :
1. Sélectionner le verger
2. Cliquer « Éclaircir »
3. Le système identifie les arbres morts à retirer
4. Confirmer
**Validations serveur** :
- Vérifier présence d'arbres morts dans le verger
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.nb_arbres -= nb_morts`, `joueur.ht -= coût_ht`
- HT: ~1-3 HT pour 1 ha
- €: 0 €
- Effets: Retire les arbres morts pour laisser de l'espace aux arbres sains. Améliore la santé globale du verger.

---

### ACTION: [VIT-020] Récolter fruits (manuel)
**Déclencheur** : Onglet `Parcelles` → verger à maturité → « Travail possible » → bouton « Récolter »
**Prérequis** :
- Verger avec fruits à maturité (période de récolte selon espèce)
- Palox disponibles (accessoire stockage fruits)
- Entrepôt arboricole avec capacité
- HT suffisants
**Étapes** :
1. Sélectionner le verger à maturité
2. Cliquer « Récolter »
3. Le système affiche la quantité récoltable aujourd'hui
4. Confirmer la récolte quotidienne
**Validations serveur** :
- Vérifier fruits à maturité (période de récolte)
- Vérifier possession palox avec capacité
- Vérifier capacité entrepôt arboricole
- Vérifier HT suffisants
**Impacts** :
- BDD: `stocks.fruits += quantité_jour`, `parcelles.fruits_restants -= quantité_jour`, `joueur.ht -= coût_ht`
- HT: ~2-5 HT/jour pour 1 ha (travail manuel quotidien)
- €: 0 € direct
- Effets: Récolte quotidienne obligatoire pendant 1 à 3 mois selon l'espèce. Fruits non récoltés un jour = perdus. Le rendement dépend de la taille, des traitements et de la météo. Nécessite beaucoup de personnel.

---

### ACTION: [VIT-021] Installer filet anti-grêle
**Déclencheur** : Onglet `Parcelles` → verger → onglet « Équipements » → bouton « Installer filet »
**Prérequis** :
- Verger avec arbres plantés
- Filet anti-grêle acheté (1 filet par hectare)
- Entrepôt arboricole pour stockage des filets
- HT suffisants
**Étapes** :
1. Sélectionner le verger → onglet « Équipements »
2. Cliquer « Installer filet anti-grêle »
3. Le système calcule le nombre de filets nécessaires (1/ha)
4. Confirmer l'installation
**Validations serveur** :
- Vérifier possession filets anti-grêle en nombre suffisant (1/ha)
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.filet_antigrele = true`, `stocks.filets -= nb_ha`, `joueur.ht -= coût_ht`
- HT: ~1-2 HT
- €: Filets déjà achetés (accessoire)
- Effets: Protège le verger contre les dégâts de grêle. Stockage des filets en entrepôt arboricole quand non utilisés.


---

## 19. FORÊTS / ETF

> 6 actions couvrant l'achat de forêt, la plantation, l'élagage, l'éclaircie, la coupe finale et la vente de bois.

---

### ACTION: [FOR-001] Acheter forêt
**Déclencheur** : Menu `Activités secondaires` → « Forêts » → bouton « Acheter une forêt »
**Prérequis** :

- Argent suffisant
**Étapes** :
1. Aller dans `Activités secondaires` → « Forêts »
2. Consulter les forêts disponibles
3. Chaque forêt comprend 20 stations forestières de 1 à 10 ha chacune (total 20-200 ha)
4. Consulter les caractéristiques : type de sol, altitude, pente, hydrographie, faune
5. Confirmer l'achat
**Validations serveur** :

- Vérifier solde € suffisant
**Impacts** :
- BDD: Création entrée `forets` (20 stations, surfaces variables), `joueur.solde -= prix_foret`
- HT: 0 HT
- €: Variable selon surface totale et localisation
- Effets: Chaque station est gérée indépendamment (comme une mini-forêt). Le système de stations permet un cycle de travail régulier sans attendre des décennies. Caractéristiques de chaque station : longueur chemin forestier, type de sol, altitude, pente, hydrographie (cours d'eau = risque d'enlisement), faune (dégâts sur plants).

---

### ACTION: [FOR-002] Planter arbres forestiers
**Déclencheur** : Menu `Forêts` → sélection station → bouton « Planter »
**Prérequis** :
- Station forestière vide (après coupe finale et broyage souches)
- Plants forestiers en stock
- HT suffisants (travail manuel)
**Étapes** :
1. Sélectionner la station forestière
2. Préparer le sol : broyage souches (tracteur + broyeur), fertilisation (120 kg/ha, tracteur + épandeur), labour (tracteur + cover forestier)
3. Cliquer « Planter »
4. Choisir l'essence d'arbre
5. Plantation manuelle : 1 100 plants par hectare
6. Installer les protections gibier (anti-lapin, anti-chevreuil, anti-cerf selon la faune)
**Validations serveur** :
- Vérifier station préparée (souches broyées, sol labouré)
- Vérifier stock plants suffisant (1 100/ha)
- Vérifier HT suffisants
- Vérifier protections gibier adaptées à la faune locale
**Impacts** :
- BDD: `station.etat = 'plantée'`, `station.essence = X`, `station.nb_plants = 1100/ha`, `stocks.plants -= quantité`, `joueur.ht -= coût_ht`
- HT: Variable selon surface (travail manuel intensif)
- €: Coût des plants + protections gibier
- Effets: Les arbres poussent sur plusieurs années/saisons. Protections gibier indispensables pour éviter les dégâts de la faune sur les jeunes plants. Entretien du sous-bois nécessaire (débroussaillage).

---

### ACTION: [FOR-003] Élaguer
**Déclencheur** : Menu `Forêts` → sélection station → bouton « Élaguer »
**Prérequis** :
- Arbres ayant atteint l'âge d'élagage
- Kit d'élagage manuel
- HT suffisants
**Étapes** :
1. Sélectionner la station forestière
2. Cliquer « Élaguer »
3. Élagage à 2 m, 4 m ou 6 m selon l'âge des arbres
4. Travail manuel avec kit d'élagage
5. Confirmer
**Validations serveur** :
- Vérifier âge des arbres compatible avec la hauteur d'élagage
- Vérifier possession kit d'élagage
- Vérifier HT suffisants
**Impacts** :
- BDD: `station.elagage = hauteur_m`, `joueur.ht -= coût_ht`
- HT: Variable selon surface et hauteur d'élagage
- €: 0 € (kit déjà acheté)
- Effets: L'élagage améliore la qualité du bois (moins de nœuds). Élagage progressif : 2 m → 4 m → 6 m au fur et à mesure de la croissance. Travail réalisé l'année suivant la plantation puis aux stades appropriés.

---

### ACTION: [FOR-004] Éclaircie forestière
**Déclencheur** : Menu `Forêts` → sélection station → bouton « Éclaircie »
**Prérequis** :
- Station avec densité d'arbres suffisante pour une éclaircie
- Abatteuse + débusqueur + porteur forestier
- HT suffisants
**Étapes** :
1. Sélectionner la station forestière
2. Marquer les arbres à abattre (opération préalable de marquage, kit manuel)
3. Cliquer « Éclaircie »
4. L'abatteuse abat les arbres marqués
5. Le débusqueur déplace les grumes
6. Le porteur forestier transporte le bois vers l'aire de stockage
**Validations serveur** :
- Vérifier arbres marqués
- Vérifier possession abatteuse + débusqueur + porteur
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `station.densite -= nb_arbres_abattus`, `aire_stockage.stock_bois += volume_m3`, `joueur.ht -= coût_ht`, `cuves_hvc.stock -= conso`
- HT: Variable selon nombre d'arbres et surface
- €: Coût HVC (abatteuse 0.075 L/CV/HT, débusqueur 0.060 L/CV/HT, porteur 0.070 L/CV/HT)
- Effets: Réduit la densité pour optimiser la croissance des arbres restants. Le bois récolté est stocké sur l'aire de stockage et peut être vendu. Possibilité de faire appel à une ETF (Entreprise de Travaux Forestiers) joueur.

---

### ACTION: [FOR-005] Coupe finale
**Déclencheur** : Menu `Forêts` → sélection station → bouton « Coupe finale »
**Prérequis** :
- Station avec arbres matures
- Abatteuse + débusqueur + porteur forestier
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la station forestière
2. Marquer tous les arbres restants
3. Cliquer « Coupe finale »
4. L'abatteuse abat tous les arbres de la station
5. Le débusqueur et le porteur évacuent le bois
6. La station est vidée, prête pour un nouveau cycle (broyage souches → replantation)
**Validations serveur** :
- Vérifier arbres matures
- Vérifier possession abatteuse + débusqueur + porteur
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `station.densite = 0`, `station.etat = 'coupée'`, `aire_stockage.stock_bois += volume_total_m3`, `joueur.ht -= coût_ht`
- HT: Variable selon nombre d'arbres et surface
- €: Coût HVC des 3 machines forestières
- Effets: Opération finale du cycle forestier. La station doit ensuite être préparée pour un nouveau cycle (broyage souches, fertilisation, labour, replantation). Volume de bois maximal récolté.

---

### ACTION: [FOR-006] Vendre bois
**Déclencheur** : Menu `Forêts` → « Ventes » → bouton « Vendre » sur le stock de bois
**Prérequis** :
- Bois en stock sur l'aire de stockage
- HT suffisants
**Étapes** :
1. Aller dans `Forêts` → « Ventes »
2. Consulter les scieries/usines acheteuses
3. Sélectionner le bois à vendre (essence, volume)
4. Confirmer la vente
**Validations serveur** :
- Vérifier stock bois > 0
- Vérifier HT suffisants
**Impacts** :
- BDD: `aire_stockage.stock_bois -= volume_vendu`, `joueur.solde += prix_vente`
- HT: ~0.5 HT
- €: Prix variable selon essence et volume de bois. Plus le volume est important, meilleur est le prix unitaire.
- Effets: Le bois est vendu aux scieries/usines. Le prix dépend de l'essence (résineux, feuillus), du volume et de la qualité (liée aux travaux effectués : élagage, éclaircies). Entretien des chemins forestiers et de l'aire de stockage nécessaire (débroussailleuse d'accotement).

---

### ACTION: [FOR-007] Planter haie
**Déclencheur** : Onglet `Parcelles` → parcelle → onglet « Haie » → bouton « Planter une haie »
**Prérequis** :
- Parcelle possédée (champ, pré ou verger)
- Plants d'arbustes en stock (prix moyen 1.50 €/plant)
- Mois de septembre à novembre
- HT suffisants
**Étapes** :
1. Sélectionner la parcelle → onglet « Haie »
2. Cliquer « Planter une haie »
3. Le système calcule le nombre de plants nécessaires selon le périmètre
4. Confirmer la plantation
**Validations serveur** :
- Vérifier stock plants arbustes suffisant
- Vérifier mois = septembre, octobre ou novembre
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.haie = true`, `parcelles.nb_arbres_haie = N`, `stocks.plants_arbustes -= N`, `joueur.ht -= N × 0.05`
- HT: 0.05 HT par plant (travail manuel)
- €: Plants déjà achetés (1.50 €/plant)
- Effets: La haie ne réduit pas la surface cultivable. Produit du bois (taille). Bénéfices pour la culture (brise-vent, biodiversité) et pour les animaux au pré (ombre, abri).

---

### ACTION: [FOR-008] Tailler haie
**Déclencheur** : Onglet `Parcelles` → parcelle avec haie → onglet « Haie » → bouton « Tailler »
**Prérequis** :
- Haie plantée sur la parcelle
- Mois de décembre à février
- Kit bûcheron
- HT suffisants
**Étapes** :
1. Sélectionner la parcelle → onglet « Haie »
2. Cliquer « Tailler la haie »
3. Confirmer (travail manuel avec kit bûcheron)
**Validations serveur** :
- Vérifier présence haie sur la parcelle
- Vérifier mois = décembre, janvier ou février
- Vérifier possession kit bûcheron
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.haie_taillee = true`, `stocks.bois += 1-2 × nb_arbres` (kg), `joueur.ht -= coût_ht`
- HT: Variable selon nombre d'arbres
- €: 0 € (kit déjà acheté)
- Effets: Produit 1 à 2 kg de bois par arbre. Le bois peut être déchiqueté pour produire du bois déchiqueté (litière ou chauffage serre).

---

### ACTION: [FOR-009] Déchiqueter bois de haie
**Déclencheur** : Onglet `Parcelles` → parcelle avec bois taillé → onglet « Haie » → bouton « Déchiqueter »
**Prérequis** :
- Bois de taille disponible (après taille de haie)
- Tracteur + broyeur de branches
- HT et HVC suffisants
**Étapes** :
1. Sélectionner la parcelle → onglet « Haie »
2. Cliquer « Déchiqueter le bois »
3. Sélectionner tracteur + broyeur de branches
4. Confirmer
**Validations serveur** :
- Vérifier bois de taille disponible
- Vérifier possession tracteur + broyeur de branches
- Vérifier HT et HVC suffisants
**Impacts** :
- BDD: `stocks.bois -= quantité`, `stocks.bois_dechiquete += quantité`, `joueur.ht -= coût_ht`
- HT: 0.2 HT par tonne de bois
- €: Coût HVC
- Effets: Produit du bois déchiqueté utilisable comme litière (30% de la quantité paille) ou combustible pour chauffage de serre. Stockage sur plateforme bois déchiqueté.

---

### ACTION: [FOR-010] Regrouper parcelles
**Déclencheur** : Onglet `Parcelles` → sélection de 2 parcelles → bouton « Regrouper »
**Prérequis** :
- 2 parcelles adjacentes dans la même commune
- Les 2 parcelles appartiennent au joueur
- Parcelles vides (pas de culture en cours, pas d'animaux)
- HT suffisants
**Étapes** :
1. Aller dans `Parcelles`
2. Sélectionner les 2 parcelles adjacentes
3. Cliquer « Regrouper »
4. Le système vérifie l'adjacence et la commune
5. Confirmer le regroupement
**Validations serveur** :
- Vérifier que les 2 parcelles sont adjacentes
- Vérifier même commune
- Vérifier propriétaire = joueur pour les 2
- Vérifier parcelles vides
- Vérifier HT suffisants
**Impacts** :
- BDD: Fusion des 2 entrées `parcelles` en 1 (surface = somme), suppression de la 2ème entrée
- HT: ~1 HT
- €: 0 €
- Effets: Crée une parcelle plus grande, plus efficace à travailler (moins de temps de manœuvre). Action irréversible.

---

### ACTION: [FOR-011] Vendre parcelle
**Déclencheur** : Onglet `Parcelles` → sélection parcelle → bouton « Vendre »
**Prérequis** :
- Parcelle possédée (pas louée)
- Parcelle vide (pas de culture en cours, pas d'animaux)
- HT suffisants
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Vendre »
3. Choisir le mode de vente :
   - À un joueur (annonce sur le marché)
   - À un ami (vente directe)
   - À Cultivia (25% du prix d'achat, disponible après 5 saisons de possession)
4. Fixer le prix (si vente joueur/ami)
5. Confirmer la mise en vente
**Validations serveur** :
- Vérifier propriété de la parcelle
- Vérifier parcelle vide
- Si vente Cultivia : vérifier possession ≥ 5 saisons
- Vérifier HT suffisants
**Impacts** :
- BDD: `parcelles.proprietaire_id = acheteur` (ou suppression si Cultivia), `joueur.solde += prix_vente - taxe_plus_value`
- HT: ~0.5 HT
- €: Prix de vente - taxe plus-value (50% à 90% de la plus-value selon durée de possession). Vente Cultivia : 25% du prix d'achat.
- Effets: Taxe plus-value dégressive : 90% si revente rapide → 50% si possession longue. Vente à Cultivia uniquement après 5 saisons. Notification à l'acheteur si vente joueur/ami.

---

## 11. MATÉRIEL — ACTIONS COMPLÉMENTAIRES

> 9 actions couvrant l'achat en commun, les collections, l'assurance, les réparations, les pièces détachées, le relevage avant, la location et la mise à la casse.

---

### ACTION: [MAT-007] Acheter matériel en commun
**Déclencheur** : Onglet `Matériels` → « Acheter du matériel » → option « Achat en commun »
**Prérequis** :
- Maximum 5 amis participants, tous dans la même région
- Argent suffisant (part proportionnelle)
- HT suffisants
**Étapes** :
1. Aller dans `Matériels` → « Acheter du matériel »
2. Sélectionner le matériel souhaité
3. Cocher « Achat en commun »
4. Inviter les amis participants (max 5 au total)
5. Chaque participant confirme et paie sa part proportionnelle
6. Confirmer l'achat collectif
**Validations serveur** :
- Vérifier relation « ami » entre tous les participants
- Vérifier même région pour tous
- Vérifier solde € suffisant pour chaque participant (part proportionnelle)
- Vérifier max 5 participants
**Impacts** :
- BDD: Création `materiels` avec `copropriete = true`, `copropriétaires = [ids]`, `parts = [%]`, chaque joueur : `solde -= prix × part%`
- HT: ~1 HT par participant
- €: Investissement proportionnel au nombre de participants (ex: 2 joueurs = 50% chacun)
- Effets: Temps d'utilisation proportionnel à l'investissement. Planification nécessaire entre copropriétaires. Économie d'investissement pour du matériel coûteux.

---

### ACTION: [MAT-008] Acheter matériel de collection
**Déclencheur** : Onglet `Matériels` → « Collection » → bouton « Acheter »
**Prérequis** :
- Hall d'exposition construit (bâtiment spécial)
- Argent suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Matériels` → « Collection »
2. Consulter les matériels de collection disponibles
3. Sélectionner le matériel
4. Confirmer l'achat
**Validations serveur** :
- Vérifier possession d'un hall d'exposition
- Vérifier solde € suffisant
- Vérifier capacité du hall d'exposition
**Impacts** :
- BDD: Création `materiels` avec `collection = true`, `hall_exposition_id = X`, `joueur.solde -= prix`
- HT: ~1 HT
- €: Prix variable selon rareté du matériel
- Effets: Matériel exposé dans le hall, non utilisable pour le travail agricole. Élément décoratif et de prestige. Le matériel de collection ne peut pas être vendu.

---

### ACTION: [MAT-009] Souscrire assurance matériel
**Déclencheur** : Onglet `Matériels` → sélection matériel → bouton « Souscrire assurance »
**Prérequis** :
- Matériel possédé
- Argent suffisant pour la prime annuelle
**Étapes** :
1. Sélectionner le matériel dans la liste
2. Cliquer « Souscrire assurance »
3. Consulter le montant de la prime annuelle
4. Confirmer la souscription
**Validations serveur** :
- Vérifier possession du matériel
- Vérifier solde € suffisant
**Impacts** :
- BDD: `materiels.assurance = true`, `materiels.date_assurance = now()`, `materiels.fin_assurance = now() + 1_an`, `joueur.solde -= prime_annuelle`
- HT: 0 HT
- €: Prime annuelle variable selon type et valeur du matériel
- Effets: En cas de panne, l'assurance couvre les frais de réparation. L'assurance choisit l'atelier de réparation. Si le joueur refuse l'atelier choisi, une partie des frais reste à sa charge. Renouvellement annuel.

---

### ACTION: [MAT-010] Réparer matériel en panne
**Déclencheur** : Onglet `Matériels` → matériel en panne (icône ⚠️) → bouton « Réparer »
**Prérequis** :
- Matériel en panne
- Argent suffisant (si pas d'assurance)
- HT suffisants
**Étapes** :
1. Identifier le matériel en panne dans la liste
2. Cliquer « Réparer »
3. Choisir le mode de réparation :
   - Cultivia (réparation automatique, coût fixe)
   - Atelier concessionnaire joueur (coût variable, potentiellement moins cher)
4. Si assuré : l'assurance choisit l'atelier
5. Confirmer la réparation
**Validations serveur** :
- Vérifier matériel en panne
- Vérifier solde € suffisant (si pas d'assurance)
- Vérifier HT suffisants
**Impacts** :
- BDD: `materiels.panne = false`, `materiels.immobilisation = 0-2_jours`, `joueur.solde -= coût_réparation` (0 si assuré)
- HT: ~1-2 HT
- €: Variable selon type de matériel et gravité. 0 € si assuré (assurance paie).
- Effets: Immobilisation de 0 à 2 jours pendant la réparation. Matériel inutilisable pendant l'immobilisation. Atelier concessionnaire joueur : délai potentiellement plus court.

---

### ACTION: [MAT-011] Changer pièce détachée
**Déclencheur** : Onglet `Matériels` → matériel avec pièce usée (icône 🔧) → bouton « Changer pièce »
**Prérequis** :
- Matériel avec pièce à remplacer (seuil d'usure atteint selon utilisation/HT)
- Concessionnaire dans la région (ou Cultivia)
- Argent suffisant
- HT suffisants
**Étapes** :
1. Identifier le matériel avec pièce à changer
2. Cliquer « Changer pièce »
3. Le système affiche la pièce à remplacer (pneus, socs, filtres, boulons, etc.)
4. Acheter la pièce chez un concessionnaire (remise possible si matériel acheté chez lui)
5. Confirmer le remplacement
**Validations serveur** :
- Vérifier pièce à remplacer (seuil atteint)
- Vérifier solde € suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: `materiels.pieces[i].usure = 0`, `joueur.solde -= prix_pièce`, `joueur.ht -= coût_ht_remplacement`
- HT: Variable selon la pièce (coût HT de remplacement)
- €: Prix pièce variable. Remise 5-15% si achetée chez le concessionnaire d'origine. 1 à 5 pièces par matériel.
- Effets: Évite les pannes. Ne pas remplacer une pièce usée augmente le risque de panne. Pas de gestion de stock — remplacement immédiat à l'achat.


---

## 20. CAR (Coopérative Agricole Régionale)

> 8 actions couvrant la création/adhésion à une CAR, la construction d'huilerie/sucrerie/laiterie/magasin et les transformations associées.

---

### ACTION: [CAR-001] Créer CAR
**Déclencheur** : Menu `Activités secondaires` → « CAR » → bouton « Créer une CAR »
**Prérequis** :
- 3 à 7 associés fondateurs
- Capital initial (max 1 000 000 €, apporté par les associés)
- Inscription depuis au moins 90 jours

**Étapes** :
1. Aller dans `Activités secondaires` → « CAR »
2. Réunir 3 à 7 associés fondateurs
3. Définir le capital initial (chaque associé apporte sa part, total max 1 000 000 €)
4. Choisir la région d'implantation (siège + annexes possibles)
5. Voter les décisions fondatrices
6. Confirmer la création
**Validations serveur** :
- Vérifier 3-7 associés
- Vérifier capital total ≤ 1 000 000 €
- Vérifier ancienneté ≥ 90 jours pour chaque associé
**Impacts** :
- BDD: Création entrée `car` (associes[], capital, region, statut=actif), `joueur.solde -= apport_capital` pour chaque associé
- HT: 0 HT
- €: Capital apporté par chaque associé
- Effets: La CAR peut construire silos, entrepôts, huilerie, sucrerie, laiterie, magasin. Possibilité de créer des annexes dans d'autres départements. Emprunt possible (montant ≤ capital, taux 0%, remboursement annuel). Parts sociales (1 €/part) créables après 1 an, dividendes saisonniers.

---

### ACTION: [CAR-002] Rejoindre CAR
**Déclencheur** : Menu `CAR` → « Annuaire » → bouton « Rejoindre » sur une CAR existante
**Prérequis** :
- CAR existante avec moins de 7 associés

- Argent suffisant pour l'investissement
**Étapes** :
1. Consulter l'annuaire des CAR
2. Sélectionner une CAR
3. Contacter les associés existants
4. Investir dans le capital de la CAR
5. Être accepté par vote des associés
**Validations serveur** :
- Vérifier CAR < 7 associés

- Vérifier solde € suffisant
**Impacts** :
- BDD: `car.associes += joueur`, `car.capital += investissement`, `joueur.solde -= investissement`
- HT: 0 HT
- €: Investissement dans le capital
- Effets: Le joueur devient associé et participe aux votes. Accès aux infrastructures de la CAR (silos, huilerie, sucrerie, etc.). Dividendes si parts sociales.

---

### ACTION: [CAR-003] Construire huilerie
**Déclencheur** : Menu `CAR` → « Infrastructures » → bouton « Construire huilerie »
**Prérequis** :
- CAR active
- Vote des associés favorable
- Capital suffisant
**Étapes** :
1. Proposer la construction aux associés (vote)
2. Si approuvé, acheter les composants :
   - Silo HVC (stockage colza/tournesol dédié)
   - Trieur (tri avant pressage)
   - Vis sans fin (transfert vers silo de presse)
   - Presse à froid (vis ou barreaux, différentes capacités)
   - Cuve de décantation
   - Filtre (pompes + filtre)
   - Cuve de stockage HVC
3. Confirmer la construction
**Validations serveur** :
- Vérifier vote favorable des associés
- Vérifier capital CAR suffisant
**Impacts** :
- BDD: Création entrée `huileries` (composants[], capacite), `car.solde -= coût_total`
- HT: 0 HT
- €: Coût total des composants (variable selon capacité)
- Effets: L'huilerie transforme le colza ou tournesol en HVC + tourteau. Entretien régulier des composants obligatoire (risque de panne). Production 24h/24 possible. Le tourteau (résidu) est vendu aux usines.

---

### ACTION: [CAR-004] Transformer colza/tournesol en HVC
**Déclencheur** : Menu `CAR` → « Huilerie » → bouton « Lancer la production »
**Prérequis** :
- Huilerie construite et opérationnelle
- Stock de colza ou tournesol dans le silo HVC
- Composants non en panne
**Étapes** :
1. Aller dans `CAR` → « Huilerie »
2. Vérifier le stock de matière première (colza ou tournesol)
3. Lancer la production (automatique, quotidienne)
4. Le HVC produit est stocké dans la cuve de stockage
5. Le tourteau (résidu) est récupéré
**Validations serveur** :
- Vérifier stock matière première > 0
- Vérifier composants opérationnels (pas de panne)
**Impacts** :
- BDD: `silo_hvc.stock -= quantité_transformée`, `cuve_stockage_hvc.stock += quantité_hvc`, `stock_tourteau += quantité_tourteau`
- HT: 0 HT (production automatique)
- €: 0 € direct (matière première déjà en stock)
- Effets: Rendement : colza → 0.336-0.420 L HVC/kg (selon presse). Tournesol → rendement similaire. Le tourteau est un sous-produit vendu aux usines. Le HVC est vendu aux joueurs de la région ou utilisé par la CAR. Gestion des stocks critique pour éviter les ruptures.

---

### ACTION: [CAR-005] Construire sucrerie
**Déclencheur** : Menu `CAR` → « Infrastructures » → bouton « Construire sucrerie »
**Prérequis** :
- CAR active
- Vote des associés favorable
- Capital suffisant (3 000 000 € pour le niveau 1)
**Étapes** :
1. Proposer la construction aux associés (vote)
2. Choisir le niveau de la sucrerie (1 à 10, capacité croissante)
3. Confirmer la construction
**Validations serveur** :
- Vérifier vote favorable
- Vérifier capital CAR suffisant (3 000 000 € niveau 1)
**Impacts** :
- BDD: Création entrée `sucreries` (niveau, capacite), `car.solde -= coût_construction`
- HT: 0 HT
- €: 3 000 000 € (niveau 1), coût croissant par niveau (10 niveaux)
- Effets: La sucrerie transforme la betterave en sucre + sous-produits. 10 niveaux d'amélioration possibles. Nécessite un approvisionnement régulier en betteraves (contrats avec les producteurs ou achat).

---

### ACTION: [CAR-006] Transformer betterave en sucre
**Déclencheur** : Menu `CAR` → « Sucrerie » → production automatique quotidienne
**Prérequis** :
- Sucrerie construite et opérationnelle
- Stock de betteraves
**Étapes** :
1. Approvisionner la sucrerie en betteraves (achat aux producteurs, contrats)
2. La transformation est automatique (quotidienne)
3. Récupérer les produits : sucre, pulpe, mélasse, écume
**Validations serveur** :
- Vérifier stock betteraves > 0
- Vérifier sucrerie opérationnelle
**Impacts** :
- BDD: `stock_betteraves -= quantité`, `stock_sucre += quantité × 0.160`, `stock_pulpe += quantité × 0.050`, `stock_melasse += quantité × 0.030`, `stock_ecume += quantité × 0.030`
- HT: 0 HT (production automatique)
- €: 0 € direct
- Effets: Par tonne de betterave : 0.160 T sucre + 0.050 T pulpe + 0.030 T mélasse + 0.030 T écume. Le sucre est vendu (semi-citerne pulvérulent). La pulpe sert d'aliment animal. La mélasse est vendue (semi-citerne agroalimentaire). L'écume est un amendement calcaire (fosse à fumier/écume).

---

### ACTION: [CAR-007] Construire laiterie
**Déclencheur** : Menu `CAR` → « Infrastructures » → bouton « Construire laiterie »
**Prérequis** :
- CAR active
- Vote des associés favorable
- Capital suffisant
**Étapes** :
1. Proposer la construction aux associés (vote)
2. Choisir les lignes de production :
   - Ligne yaourt
   - Ligne lait UHT
   - Ligne lait pasteurisé
   - Ligne fromage
   - Ligne poudre de lait
3. Embaucher un commercial (2 310 €/mois, 35 HT/jour) + employés (1 750 €/mois, 35 HT/jour)
4. Construire les entrepôts de stockage (entrepôt classique pour UHT/poudre, entrepôt réfrigéré pour yaourt/pasteurisé/fromage)
5. Confirmer la construction
**Validations serveur** :
- Vérifier vote favorable
- Vérifier capital CAR suffisant
**Impacts** :
- BDD: Création entrée `laiteries` (lignes_production[], employes[]), `car.solde -= coût_total`
- HT: 0 HT
- €: Coût des lignes de production (3.20 €/L de capacité journalière pour niveau 1) + entrepôts + salaires
- Effets: Chaque ligne peut transformer jusqu'à 1 000 000 L/jour. Plusieurs lignes identiques possibles. Le commercial prospecte les contrats laitiers avec les producteurs. Collecte du lait par transporteur (semi-citerne lait ou porteur citerne lait).

---

### ACTION: [CAR-008] Construire magasin libre-service
**Déclencheur** : Menu `CAR` → « Infrastructures » → bouton « Construire magasin »
**Prérequis** :
- CAR active (au moins 1 an pour le premier magasin)
- Vote des associés favorable (choix de 3 espaces sur 5)
- Capital suffisant (30 000 €)
**Étapes** :
1. Proposer la construction aux associés (vote)
2. Choisir 3 espaces parmi 5 :
   - Agriculture (semences, phyto, engrais)
   - Arboriculture (plants, traitements, filets anti-grêle, palox)
   - Forêt (plants, protections, engrais forestier)
   - Maraîchage (semences, plants, palox, bâches)
   - Élevage (auges, râteliers, piquets, fil barbelé, minéraux)
3. Construire le magasin (300 m², 30 000 €)
4. Élire un responsable magasin (associé) + embaucher un employé (1 750 €/mois)
5. Commander les marchandises auprès des fournisseurs
**Validations serveur** :
- Vérifier CAR ≥ 1 an d'ancienneté
- Vérifier vote favorable (3 espaces choisis)
- Vérifier capital CAR ≥ 30 000 €
**Impacts** :
- BDD: Création entrée `magasins_car` (espaces[3], surface=300m², responsable_id), `car.solde -= 30 000`
- HT: 0 HT
- €: 30 000 € construction + salaire employé 1 750 €/mois + coût marchandises
- Effets: Les joueurs peuvent acheter dans le magasin comme à la coopérative Cultivia. Le responsable fixe les prix et les remises (remises volume possibles). 1 magasin par siège/annexe. Livraison des marchandises par transporteur. Télescopique nécessaire pour le stockage. Possibilité de modifier les 3 espaces sous conditions.

---

### ACTION: [CAR-009] Installer relevage avant
**Déclencheur** : Onglet `Matériels` → tracteur → bouton « Installer relevage avant »
**Prérequis** :
- Tracteur ≥ 50 CV
- Atelier concessionnaire dans la région
- Argent suffisant (150-300 €)
- HT suffisants
**Étapes** :
1. Sélectionner le tracteur
2. Cliquer « Installer relevage avant »
3. Le système affiche le coût (150-300 €) et l'atelier
4. Confirmer l'installation
**Validations serveur** :
- Vérifier tracteur ≥ 50 CV
- Vérifier tracteur sans relevage avant existant
- Vérifier atelier concessionnaire disponible
- Vérifier solde € suffisant
**Impacts** :
- BDD: `materiels.relevage_avant = true`, `joueur.solde -= 150-300`
- HT: ~1 HT (installation en atelier)
- €: 150-300 € (installation par le concessionnaire)
- Effets: Permet d'atteler du matériel à l'avant du tracteur (charrue frontale, cuve frontale, faucheuse frontale, cultivateur frontal). Indispensable pour les combinés. Action irréversible — le relevage ne peut pas être retiré.

---

### ACTION: [CAR-010] Louer matériel
**Déclencheur** : Onglet `Matériels` → matériel en panne → bouton « Louer un remplacement »
**Prérequis** :
- Tracteur en panne (seul type louable)
- Concessionnaire dans la même région proposant la location
- Argent suffisant
**Étapes** :
1. Constater la panne du tracteur
2. Cliquer « Louer un remplacement »
3. Consulter les tracteurs disponibles à la location (même puissance ±5 CV)
4. Sélectionner un tracteur
5. Confirmer la location (durée = durée de la panne)
**Validations serveur** :
- Vérifier tracteur en panne
- Vérifier tracteur de location disponible (même puissance ±5 CV)
- Vérifier même région
- Vérifier solde € suffisant
**Impacts** :
- BDD: `materiels_loues.tracteur_id = X`, `materiels_loues.duree = durée_panne`, `joueur.solde -= coût_location`
- HT: 0 HT
- €: Coût par HT utilisé (fixé par le concessionnaire)
- Effets: Permet de continuer à travailler pendant la panne. Durée de location = durée de la panne, pas plus. Puissance du tracteur loué doit être ≥ puissance du tracteur en panne (±5 CV).

---

### ACTION: [CAR-011] Mettre matériel en location
**Déclencheur** : Onglet `Matériels` → sélection tracteur → bouton « Mettre en location »
**Prérequis** :
- Tracteur possédé, non en panne, non en cours d'utilisation
- Activité concessionnaire (pour les concessionnaires joueurs)
**Étapes** :
1. Sélectionner le tracteur
2. Cliquer « Mettre en location »
3. Fixer le prix par HT utilisé
4. Confirmer la mise en location
**Validations serveur** :
- Vérifier possession du tracteur
- Vérifier tracteur non en panne et non utilisé
**Impacts** :
- BDD: `materiels.en_location = true`, `materiels.prix_location_ht = X`
- HT: 0 HT
- €: Revenus selon utilisation par le locataire
- Effets: Le tracteur est disponible pour les joueurs de la région dont le tracteur est en panne. Revenus passifs. Le tracteur reste utilisable par le propriétaire quand non loué.

---

### ACTION: [CAR-012] Mettre matériel à la casse
**Déclencheur** : Onglet `Matériels` → sélection matériel → bouton « Mettre à la casse »
**Prérequis** :
- Matériel possédé
- Matériel non en cours d'utilisation
**Étapes** :
1. Sélectionner le matériel
2. Cliquer « Mettre à la casse »
3. Le système affiche un avertissement : destruction définitive, aucune récupération financière
4. Confirmer la destruction (action irréversible)
**Validations serveur** :
- Vérifier possession du matériel
- Vérifier matériel non en cours d'utilisation
- Demander double confirmation (action irréversible)
**Impacts** :
- BDD: Suppression entrée `materiels`
- HT: 0 HT
- €: 0 € (aucune récupération)
- Effets: Matériel détruit définitivement. Aucune valeur récupérée. Utile pour se débarrasser de matériel très usé ou obsolète. Libère de l'espace en hangar.

---

## 12. BÂTIMENTS + COMMERCE — ACTIONS COMPLÉMENTAIRES

> 11 actions couvrant les accessoires, la ferme 3D, le carburant, la nourriture animale, la négociation, les contrats CAR et le commerce inter-CAR.

---

### ACTION: [BAT-005] Construire accessoire
**Déclencheur** : Onglet `Bâtiments` → « Agrandir ma ferme » → onglet « Accessoires » → bouton « Construire »
**Prérequis** :
- Bâtiment principal existant (pour les accessoires liés)
- Argent suffisant
- HT suffisants
**Étapes** :
1. Aller dans `Bâtiments` → « Agrandir ma ferme » → « Accessoires »
2. Choisir le type d'accessoire : salle de traite, cuve à lait, cuve à eau, cuve HVC, parc à volailles, abris porcins, salle de conditionnement, pièce de stockage
3. Sélectionner la taille/capacité
4. Confirmer la construction
**Validations serveur** :
- Vérifier bâtiment principal compatible existant
- Vérifier solde € suffisant
- Vérifier HT suffisants
**Impacts** :
- BDD: Création entrée `accessoires` (type, capacité, batiment_parent_id), `joueur.solde -= prix`, `joueur.ht -= coût_ht`
- HT: ~1 HT
- €: Variable selon type (salle traite ~30 000 €, cuve lait ~5 000-20 000 €, cuve eau ~1 000-5 000 €, cuve HVC ~2 000-10 000 €, parc volailles 10 m²/animal, abris porcins 5 porcs/abri)
- Effets: L'accessoire est lié au bâtiment principal. Nécessaire pour certaines actions (traite → salle de traite, stockage lait → cuve à lait, etc.).

---

### ACTION: [BAT-006] Acheter accessoire à la coopérative
**Déclencheur** : Onglet `Coopérative` → « Accessoires » → bouton « Acheter »
**Prérequis** :
- Argent suffisant
- Emplacement disponible
**Étapes** :
1. Aller dans `Coopérative` → « Accessoires »
2. Sélectionner l'accessoire fixe (palox, filet anti-grêle, etc.)
3. Indiquer la quantité
4. Confirmer l'achat
**Validations serveur** :
- Vérifier solde € suffisant
**Impacts** :
- BDD: `stocks.accessoire += quantité`, `joueur.solde -= prix_total`
- HT: 0 HT
- €: Prix fixe coopérative
- Effets: Accessoires fixes livrés immédiatement. Utilisables pour les activités correspondantes.

---

### ACTION: [BAT-007] Ferme 3D — Placer bâtiment
**Déclencheur** : Onglet `Bâtiments` → « Ma ferme 3D » → mode placement
**Prérequis** :
- Bâtiment, accessoire ou décoration construit/acheté
**Étapes** :
1. Aller dans `Bâtiments` → « Ma ferme 3D »
2. Passer en mode placement
3. Sélectionner l'élément à placer (bâtiment, accessoire ou décoration)
4. Glisser-déposer (drag & drop) sur la vue isométrique
5. Confirmer le placement
**Validations serveur** :
- Vérifier possession de l'élément
- Vérifier emplacement libre (pas de chevauchement)
**Impacts** :
- BDD: `elements_ferme.position_x = X`, `elements_ferme.position_y = Y`
- HT: 0 HT
- €: 0 €
- Effets: Élément visible sur la vue 3D isométrique de la ferme. Purement visuel — n'affecte pas le gameplay.

---

### ACTION: [BAT-008] Ferme 3D — Supprimer élément
**Déclencheur** : Onglet `Bâtiments` → « Ma ferme 3D » → mode suppression
**Prérequis** :
- Élément placé sur la ferme 3D
**Étapes** :
1. Aller dans `Bâtiments` → « Ma ferme 3D »
2. Activer le mode suppression
3. Cliquer sur l'élément à retirer
4. Confirmer la suppression
**Validations serveur** :
- Vérifier élément existant sur la ferme 3D
**Impacts** :
- BDD: `elements_ferme.position = null`
- HT: 0 HT
- €: 0 €
- Effets: Retire l'élément de la vue 3D. L'élément reste possédé — il peut être replacé. Ne détruit pas le bâtiment.

---

### ACTION: [BAT-009] Ferme 3D — Rotation
**Déclencheur** : Onglet `Bâtiments` → « Ma ferme 3D » → mode placement → bouton rotation
**Prérequis** :
- Élément en cours de placement
**Étapes** :
1. En mode placement, sélectionner un élément
2. Cliquer sur le bouton rotation avant de placer
3. L'élément pivote (90° par clic)
4. Placer l'élément pivoté
**Validations serveur** :
- Vérifier élément en cours de placement
**Impacts** :
- BDD: `elements_ferme.rotation = angle`
- HT: 0 HT
- €: 0 €
- Effets: Permet d'orienter les bâtiments et décorations sur la ferme 3D. Purement esthétique.

---

### ACTION: [BAT-010] Nommer sa ferme
**Déclencheur** : Onglet `Bâtiments` → « Ma ferme 3D » ou Profil → bouton « Nommer ma ferme »
**Prérequis** :
- Aucun
**Étapes** :
1. Cliquer « Nommer ma ferme »
2. Saisir le nom souhaité (texte libre)
3. Confirmer
**Validations serveur** :
- Vérifier texte non vide et longueur raisonnable
- Vérifier absence de contenu inapproprié
**Impacts** :
- BDD: `fermes.nom = 'texte_saisi'`
- HT: 0 HT
- €: 0 €
- Effets: Le nom de la ferme est visible par les autres joueurs sur le profil et la carte.


---

## 21. MÉTHANISATION

> 5 actions couvrant la construction du digesteur, l'alimentation, la vidange, la production d'électricité et la production de HVC.

---

### ACTION: [MET-001] Construire digesteur
**Déclencheur** : Menu `Méthanisation` → bouton « Construire un digesteur »
**Prérequis** :
- Argent suffisant
- Disponible pour CAR (méthanisation coopérative) ou à la ferme (méthanisation individuelle)
**Étapes** :
1. Aller dans `Méthanisation`
2. Choisir la capacité du digesteur :
   - 1 000 m³ — 50 000 €
   - 2 000 m³ — 100 000 €
   - 3 000 m³ — 150 000 €
   - 4 000 m³ — 200 000 €
   - 5 000 m³ — 250 000 €
   - 6 000 m³ — 300 000 €
   - 7 000 m³ — 350 000 €
3. Confirmer la construction (délai de construction variable)
**Validations serveur** :
- Vérifier solde € suffisant
**Impacts** :
- BDD: Création entrée `digesteurs` (capacite_m3, usure=0%), `joueur.solde -= prix`
- HT: 0 HT
- €: 50 000 à 350 000 € selon capacité
- Effets: Le digesteur est le cœur de la méthanisation. Nécessite aussi un module électricité (obligatoire, 100 000-2 000 000 €) et optionnellement un module HVC (100 000-2 800 000 €). Plateformes de substrats solides/liquides et de digestat nécessaires. Entretien mensuel (1 HT, récupère 0.1% usure). Risque de panne si usure élevée.

---

### ACTION: [MET-002] Alimenter digesteur
**Déclencheur** : Menu `Méthanisation` → « Digesteur » → bouton « Alimenter »
**Prérequis** :
- Digesteur construit et opérationnel
- Substrats disponibles (solides et/ou liquides)
- Plateforme substrat solide et/ou fosse substrat liquide
**Étapes** :
1. Aller dans `Méthanisation` → « Digesteur »
2. Sélectionner les substrats à introduire :
   - Substrats solides : fumier, ensilage, paille, déchets verts…
   - Substrats liquides : lisier, petit-lait…
3. Indiquer les quantités
4. Confirmer l'alimentation
5. Le digesteur produit du biogaz pendant 7 jours
**Validations serveur** :
- Vérifier digesteur opérationnel (pas en panne)
- Vérifier stock substrats suffisant
- Vérifier capacité digesteur non dépassée
**Impacts** :
- BDD: `digesteur.substrats += quantités`, `plateforme_substrat.stock -= quantité`, `digesteur.date_fin_production = now() + 7j`
- HT: ~1 HT
- €: 0 € (substrats déjà en stock)
- Effets: Le biogaz est produit quotidiennement pendant 7 jours. La quantité de biogaz dépend du pouvoir méthanogène de chaque substrat (variable selon type et qualité). Possibilité de mélanger plusieurs substrats. Après 7 jours, il faut vidanger puis réalimenter.

---

### ACTION: [MET-003] Vidanger digesteur
**Déclencheur** : Menu `Méthanisation` → « Digesteur » → bouton « Vidanger » (après 7 jours de production)
**Prérequis** :
- Digesteur ayant terminé son cycle de 7 jours
- Plateforme digestat solide et fosse digestat liquide avec capacité
**Étapes** :
1. Aller dans `Méthanisation` → « Digesteur »
2. Cliquer « Vidanger »
3. Le digestat est récupéré : 80% du volume des substrats introduits
4. Répartition : 80% digestat liquide + 20% digestat solide
5. Stockage dans les infrastructures dédiées
**Validations serveur** :
- Vérifier cycle de 7 jours terminé
- Vérifier capacité plateforme digestat solide
- Vérifier capacité fosse digestat liquide
**Impacts** :
- BDD: `digesteur.substrats = 0`, `digesteur.etat = 'vide'`, `plateforme_digestat_solide.stock += volume × 0.80 × 0.20`, `fosse_digestat_liquide.stock += volume × 0.80 × 0.80`
- HT: ~1 HT
- €: 0 €
- Effets: Le digestat (80% du volume initial) est un excellent engrais. Digestat liquide (80% du digestat) stocké en fosse. Digestat solide (20% du digestat) stocké sur plateforme. Épandable sur les parcelles comme fertilisant. Vendable aux joueurs de la zone.

---

### ACTION: [MET-004] Produire électricité
**Déclencheur** : Automatique — le module électricité transforme le biogaz quotidiennement
**Prérequis** :
- Module électricité construit (obligatoire, 100 000-2 000 000 €)
- Biogaz disponible dans le digesteur
**Étapes** :
1. Le module électricité transforme automatiquement le biogaz en électricité
2. Ratio : 2 kWh par m³ de biogaz
3. L'électricité produite est déduite de la consommation énergétique de la ferme
4. L'excédent est revendu à Cultivia à 0.04 €/kWh
**Validations serveur** :
- Vérifier module électricité opérationnel (pas en panne)
- Vérifier biogaz disponible
**Impacts** :
- BDD: `biogaz.stock -= quantité_transformée`, `joueur.energie_produite += quantité × 2 kWh`, `joueur.solde += excédent × 0.04`
- HT: 0 HT (automatique)
- €: Revente excédent à 0.04 €/kWh
- Effets: Modèles de 20 000 à 400 000 kWh/jour. Si la production de biogaz dépasse la capacité du module, le surplus est perdu. L'électricité couvre d'abord la consommation de la ferme (bâtiments, accessoires), puis l'excédent est revendu. Entretien mensuel du module (1 HT).

---

### ACTION: [MET-005] Produire HVC (méthanisation)
**Déclencheur** : Automatique — le module HVC transforme le biogaz quotidiennement
**Prérequis** :
- Module HVC construit (optionnel, 100 000-2 800 000 €)
- Biogaz disponible dans le digesteur
- Cuve HVC avec capacité
**Étapes** :
1. Le module HVC transforme automatiquement le biogaz en HVC
2. Ratio : 0.7 L de HVC par m³ de biogaz
3. Le HVC est stocké dans la cuve HVC de la ferme
**Validations serveur** :
- Vérifier module HVC opérationnel (pas en panne)
- Vérifier biogaz disponible
- Vérifier capacité cuve HVC
**Impacts** :
- BDD: `biogaz.stock -= quantité_transformée`, `cuves_hvc.stock += quantité × 0.7`
- HT: 0 HT (automatique)
- €: 0 € direct (HVC utilisé pour les machines ou vendu aux joueurs de la région si CAR)
- Effets: Modèles de 5 000 à 140 000 L/jour. Si la production de biogaz dépasse la capacité du module, le surplus est perdu. Le HVC produit est utilisable directement pour les machines agricoles. En CAR : vendable aux joueurs de la région. À la ferme : usage personnel uniquement, non revendable. Entretien mensuel du module (1 HT).


---

## 22. FOIE GRAS

> 3 actions couvrant le placement en filière, le gavage et l'abattage/transformation.

---

### ACTION: [FOI-001] Placer animal en filière foie gras
**Déclencheur** : Menu `Animaux` → sélection oison/caneton → bouton « Placer en filière foie gras »
**Prérequis** :
- Oisons (oies) ou canetons (canards) dès la naissance
- Bâtiment d'élevage adapté
**Étapes** :
1. Sélectionner les oisons ou canetons nouveau-nés
2. Cliquer « Placer en filière foie gras »
3. Confirmer le placement (action irréversible)
4. L'animal entre dans le cycle foie gras : 3 phases d'élevage de 21 jours chacune
**Validations serveur** :
- Vérifier animal nouveau-né (oison ou caneton)
- Vérifier bâtiment adapté
**Impacts** :
- BDD: `animaux.filiere = 'foie_gras'`, `animaux.phase_elevage = 1`, `animaux.irréversible = true`
- HT: 0 HT
- €: 0 €
- Effets: Décision irréversible — l'animal ne pourra plus être vendu normalement ni utilisé pour la reproduction. 3 phases d'élevage de 21 jours chacune (total 63 jours) avant le gavage. Alimentation spécifique pendant les phases d'élevage. Foie gras bio si élevage bio (+20% prix).

---

### ACTION: [FOI-002] Gaver
**Déclencheur** : Menu `Animaux` → filière foie gras → bouton « Gaver » (après les 3 phases d'élevage)
**Prérequis** :
- Animal ayant terminé les 3 phases d'élevage (63 jours)
- Stock de maïs grain suffisant
- HT suffisants
**Étapes** :
1. Sélectionner les animaux prêts au gavage
2. Cliquer « Gaver »
3. Le gavage dure 3-4 jours
4. Consommation de maïs grain : 4-5.5 kg/jour par animal
5. Confirmer
**Validations serveur** :
- Vérifier animal en fin de phase 3 d'élevage
- Vérifier stock maïs grain suffisant (4-5.5 kg/jour × nb jours × nb animaux)
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.statut = 'en_gavage'`, `stocks.mais_grain -= consommation`, `joueur.ht -= coût_ht`
- HT: 0.27 HT/oie, 0.0625 HT/canard (par jour de gavage)
- €: Coût du maïs grain consommé (déjà en stock)
- Effets: Durée : 3-4 jours. Consommation maïs grain : 4-5.5 kg/jour selon espèce et stade. Le gavage prépare l'animal à l'abattage. HT différents selon espèce : oie plus coûteuse en HT que canard.

---

### ACTION: [FOI-003] Abattre et transformer foie gras
**Déclencheur** : Menu `Animaux` → filière foie gras → bouton « Abattre et transformer » (après gavage)
**Prérequis** :
- Animal gavé (gavage terminé)
- HT suffisants
- Chambre froide avec capacité (pour stockage)
**Étapes** :
1. Sélectionner les animaux gavés
2. Cliquer « Abattre et transformer »
3. Choisir le mode de conservation :
   - **Sous vide** : DLC 5 jours
   - **Mi-cuit** : DLC 42 jours
   - **Conserve** : DLC 252 jours
4. Confirmer l'abattage et la transformation
**Validations serveur** :
- Vérifier animal gavé
- Vérifier HT suffisants
- Vérifier chambre froide avec capacité
**Impacts** :
- BDD: `animaux.statut = 'abattu'`, `stock_foie_gras += poids_foie`, `joueur.ht -= coût_ht`
- HT: 0.25 HT par animal
- €: 0 € direct (vente ultérieure)
- Effets: Poids du foie : 0.4-0.7 kg selon espèce et qualité du gavage. Conservation : sous vide (DLC 5j, qualité maximale), mi-cuit (DLC 42j, bon compromis), conserve (DLC 252j, longue conservation). Stockage en chambre froide obligatoire. Vente sur les marchés (utilitaire + kit exposant) ou à la coopérative. Foie gras bio = +20% prix.

---

---

### ACTION: [FOI-004] Acheter carburant HVC
**Déclencheur** : Onglet `Coopérative` → « Carburant » → bouton « Acheter HVC »
**Prérequis** :
- Cuve HVC construite avec capacité disponible
- Argent suffisant
**Étapes** :
1. Aller dans `Coopérative` → « Carburant »
2. Choisir la source : Coopérative Cultivia (0.48 €/L, immédiat) ou CAR (prix réduit ~0.36-0.40 €/L, livraison différée)
3. Sélectionner la quantité
4. Confirmer l'achat
**Validations serveur** :
- Vérifier capacité cuve HVC restante
- Vérifier solde € suffisant
- Si CAR : vérifier adhésion CAR
**Impacts** :
- BDD: `cuves_hvc.stock += quantité`, `joueur.solde -= quantité × prix_litre`
- HT: 0 HT
- €: 0.36-0.60 €/L selon source (Cultivia ~0.48 €/L, CAR ~0.36-0.40 €/L)
- Effets: HVC indispensable pour tout matériel motorisé. Économie via CAR. Cuve HVC = accessoire bâtiment.

---

### ACTION: [FOI-005] Acheter nourriture animale
**Déclencheur** : Onglet `Coopérative` → « Alimentation animale » → bouton « Acheter »
**Prérequis** :
- Argent suffisant
- Stockage disponible (silo, entrepôt)
**Étapes** :
1. Aller dans `Coopérative` → « Alimentation animale »
2. Choisir entre :
   - Rations complètes (prêtes à l'emploi, par espèce et type)
   - Aliments individuels (foin, maïs ensilé, paille, concentrés, minéraux+vitamines, etc.)
3. Sélectionner la quantité
4. Confirmer l'achat
**Validations serveur** :
- Vérifier solde € suffisant
- Vérifier capacité stockage
**Impacts** :
- BDD: `stocks.aliment += quantité`, `joueur.solde -= prix_total`
- HT: 0 HT
- €: Prix variable selon type d'aliment et qualité. Bio = plus cher.
- Effets: Rations complètes = plus simple mais plus cher. Aliments individuels = permet de composer ses propres rations. Qualité de la ration influence la production (lait, croissance).

---

### ACTION: [FOI-006] Négocier prix matériel
**Déclencheur** : Onglet `Matériels` → marché occasion ou concessionnaire → bouton « Faire une offre »
**Prérequis** :
- Matériel en vente (occasion) ou à acheter chez concessionnaire
- Argent suffisant
**Étapes** :
1. Consulter une annonce de matériel (occasion ou concessionnaire)
2. Cliquer « Faire une offre » (contre-offre)
3. Saisir le prix proposé
4. Confirmer l'envoi de l'offre
5. Attendre la réponse du vendeur (acceptation, refus ou contre-proposition)
**Validations serveur** :
- Vérifier matériel toujours disponible
- Vérifier solde € suffisant pour l'offre
**Impacts** :
- BDD: Création `offres_negociation` (materiel_id, acheteur, prix_proposé, statut='en_attente')
- HT: 0 HT
- €: 0 € pour l'offre. Si acceptée : paiement au prix négocié.
- Effets: Permet d'obtenir un meilleur prix à l'achat ou à la vente. Le vendeur peut accepter, refuser ou contre-proposer. Notification au vendeur/acheteur.

---

### ACTION: [FOI-007] Contrat parcelle CAR
**Déclencheur** : Onglet `Parcelles` → parcelle → onglet « CAR » → bouton « Lier à la CAR »
**Prérequis** :
- Adhésion à une CAR (Coopérative Agricole Régionale)
- Parcelle possédée avec culture compatible
**Étapes** :
1. Sélectionner la parcelle → onglet « CAR »
2. Cliquer « Lier à la CAR »
3. Consulter les conditions du contrat (prix garanti, engagement de livraison)
4. Confirmer le contrat
**Validations serveur** :
- Vérifier adhésion CAR active
- Vérifier parcelle possédée
- Vérifier culture compatible avec les besoins de la CAR
**Impacts** :
- BDD: `parcelles.contrat_car = true`, `parcelles.car_id = X`
- HT: 0 HT
- €: 0 € (le contrat garantit un prix de vente pour la récolte)
- Effets: La récolte de cette parcelle est vendue automatiquement à la CAR au prix garanti. Sécurité de revenu. Le joueur s'engage à livrer la récolte à la CAR.

---

### ACTION: [FOI-008] Acheter/vendre entre CAR
**Déclencheur** : Onglet `Coopérative` → « Annonces inter-CAR » → bouton « Consulter » ou « Publier »
**Prérequis** :
- Adhésion à une CAR
- Produit en stock (pour vente) ou argent suffisant (pour achat)
**Étapes** :
1. Aller dans `Coopérative` → « Annonces inter-CAR »
2. Consulter les annonces des autres CAR
3. Pour acheter : sélectionner une annonce, confirmer l'achat
4. Pour vendre : publier une annonce avec produit, quantité et prix
5. Organiser le transport via CECA (transporteur inter-régional)
**Validations serveur** :
- Vérifier adhésion CAR
- Vérifier stock suffisant (vente) ou solde € suffisant (achat)
**Impacts** :
- BDD: Création/réponse `annonces_inter_car`, transfert stocks et €
- HT: 0 HT
- €: Prix fixé par le vendeur + coût transport CECA
- Effets: Commerce entre coopératives de différentes régions. Transport assuré par le CECA (organisme de transport inter-CAR). Permet d'accéder à des produits non disponibles localement.

---
---

> **Fin du document — 08_ACTIONS_DETAILLEES.md**
> Ce document couvre l'ensemble des actions joueur de Cultivia, organisées par catégorie.
> Pour chaque action : déclencheur, prérequis, étapes UI, validations serveur, impacts BDD, coûts HT/€, et effets secondaires.


## 23. ACTIONS MANQUANTES — VARIANTES CULTIVIA DIRECT / JOUEUR

---

### ACTION: [CUL-101] Appeler une ETA (joueur)
**Déclencheur** : Onglet `Parcelles` → sélectionner parcelle → bouton « Appeler une ETA »
**Prérequis** :
- Parcelle avec un travail à effectuer (diode verte)
- Au moins une ETA active dans la région
- Solde € suffisant
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Appeler une ETA »
3. Le système affiche les ETA disponibles dans le département avec leurs tarifs
4. Sélectionner l'ETA et le travail à effectuer (labourer, semer, moissonner, etc.)
5. Confirmer la commande
6. L'ETA réalise le travail avec son propre matériel et ses propres HT
7. Après le travail : noter l'ETA (évaluation + commentaire)
**Validations serveur** :
- Vérifier parcelle avec travail possible
- Vérifier ETA active et disponible
- Vérifier solde € suffisant pour le tarif ETA
**Impacts** :
- BDD: `parcelles.etat = 'travaillé'`, `joueur.solde -= tarif_eta`, `eta.solde += tarif_eta`, `INSERT INTO commandes_eta(...)`
- HT: **0 HT pour le joueur** (c'est l'ETA qui utilise ses HT)
- €: Tarif fixé par l'ETA (variable selon travail et surface)
- Effets: Le joueur économise ses HT mais paie plus cher. L'ETA gagne de l'argent. Évaluation visible dans le classement ETA.

---

### ACTION: [CUL-102] Créer ETA
**Déclencheur** : Menu `Activités` → « ETA » → bouton « Créer mon ETA »
**Prérequis** :
- Licence annuelle (5 000 € en jeu)
- Au moins 5 matériels pour travailler dans les parcelles
**Étapes** :
1. Aller dans `Activités` → « ETA »
2. Payer la licence annuelle (5 000 €)
3. Fixer les tarifs par type de travail et par hectare
4. L'ETA est active et visible dans l'annuaire régional
**Validations serveur** :
- Vérifier solde ≥ 5 000 €
- Vérifier possession ≥ 5 matériels de travail parcelle
**Impacts** :
- BDD: `INSERT INTO eta(user_id, tarifs, statut='actif')`, `joueur.solde -= 5000`
- HT: 0 HT
- €: -5 000 € (licence annuelle, renouvelable)
- Effets: L'ETA peut recevoir des commandes de joueurs de son département. Classement ETA : commandes honorées, hectares travaillés, délai moyen, évaluation clients.

---

### ACTION: [FIN-101] Embaucher employé agricole
**Déclencheur** : Header → clic sur « HT » → bouton « Embaucher un employé »
**Prérequis** :
- Solde € suffisant pour le salaire (1 750 €/mois)
**Étapes** :
1. Cliquer sur le compteur HT dans le header
2. Cliquer « Embaucher un employé »
3. Choisir la durée du contrat (1 mois)
4. Confirmer l'embauche
**Validations serveur** :
- Vérifier solde ≥ 1 750 €
**Impacts** :
- BDD: `INSERT INTO employes(user_id, type='agricole', salaire=1750, ht_jour=22, debut=now())`, `joueur.ht_base += 22`
- HT: +35 HT/jour pendant la durée du contrat
- €: -1 750 €/mois (prélevé automatiquement)
- Effets: Le joueur passe de 35 à 57 HT/jour. Plusieurs employés cumulables. Salaire prélevé chaque mois Cultivia automatiquement.

---

### ACTION: [ELV-101] Activer nourrissage automatique 15 jours
**Déclencheur** : Onglet `Animaux` → bouton « Nourrissage automatique 15 jours »
**Prérequis** :
- Stock de nourriture suffisant pour 15 jours
- HT suffisants pour activer
**Étapes** :
1. Aller dans `Animaux`
2. Cliquer « Nourrissage automatique 15 jours »
3. Le système calcule la quantité de nourriture nécessaire pour 15 jours
4. Confirmer
**Validations serveur** :
- Vérifier stock nourriture suffisant pour 15 jours × nb animaux
- Vérifier HT suffisants
**Impacts** :
- BDD: `animaux.nourrissage_auto = true`, `animaux.nourrissage_auto_fin = now() + 15j`
- HT: ~1 HT pour activer
- €: 0 € (nourriture déjà en stock)
- Effets: Pendant 15 jours, les animaux sont nourris automatiquement lors du DAILY_UPDATE. Stock déduit quotidiennement. Utile en cas d'absence. Si le stock s'épuise avant les 15 jours, le nourrissage s'arrête.

---

### ACTION: [MAT-101] Entretenir matériel (atelier concessionnaire joueur)
**Déclencheur** : Fiche matériel → bouton « Entretenir chez un concessionnaire »
**Prérequis** :
- Matériel avec usure > 0%
- Au moins un concessionnaire avec atelier dans la région
**Étapes** :
1. Aller sur la fiche du matériel
2. Cliquer « Entretenir chez un concessionnaire »
3. Le système affiche les ateliers disponibles avec leurs tarifs et compétences mécanicien
4. Sélectionner un atelier
5. Confirmer
6. Le mécanicien effectue l'entretien (2-5 HT selon type matériel)
**Validations serveur** :
- Vérifier atelier disponible
- Vérifier solde € suffisant (main d'œuvre 8-24€/HT + pièces 100-500€)
**Impacts** :
- BDD: `materiel.usure -= reduction` (selon compétences mécanicien), `joueur.solde -= cout_entretien`, `concession.solde += cout_main_oeuvre`
- HT: **0 HT pour le joueur** (c'est le mécanicien qui travaille)
- €: Main d'œuvre (8-24€ × 2-5 HT) + pièces (100-500€ + 2%/an ancienneté matériel)
- Effets: Meilleur entretien si mécanicien compétent. Spécialisation marque = bonus. Remise pièces si matériel acheté dans cette concession.

---

### ACTION: [MAT-102] Vendre matériel à un concessionnaire
**Déclencheur** : Fiche matériel → bouton « Vendre » → « À un concessionnaire »
**Prérequis** :
- Matériel non partagé
- Au moins un concessionnaire dans la région
**Étapes** :
1. Aller sur la fiche du matériel
2. Cliquer « Vendre »
3. Choisir « À un concessionnaire »
4. Le système affiche les concessionnaires et leur prix de rachat (basé sur argus)
5. Négocier le prix (le concessionnaire peut proposer plus si rachat + achat neuf)
6. Confirmer la vente
**Validations serveur** :
- Vérifier propriété du matériel
- Vérifier matériel non partagé
**Impacts** :
- BDD: `DELETE FROM equipment WHERE id = :id`, `joueur.solde += prix_rachat`, `concession.stock += materiel`
- HT: ~0.5 HT
- €: Prix de rachat (variable, négociable, basé sur argus et usure)
- Effets: Le concessionnaire peut revendre le matériel en occasion. Prix de rachat potentiellement plus élevé si achat neuf en contrepartie.

---

### ACTION: [MAT-103] Acheter matériel hors région
**Déclencheur** : Onglet `Matériel` → « Achat » → « Matériel hors région »
**Prérequis** :
- Solde € suffisant
- Transporteur disponible pour livraison
**Étapes** :
1. Aller dans `Matériel` → « Achat » → « Matériel hors région »
2. Rechercher par type, marque, prix
3. Sélectionner le matériel
4. Acheter
5. Commander un transport (semi porte-engin) pour livraison
**Validations serveur** :
- Vérifier solde suffisant (matériel + transport)
**Impacts** :
- BDD: `INSERT INTO equipment(...)`, `joueur.solde -= prix + transport`
- HT: ~1 HT
- €: Prix matériel + frais transport
- Effets: Le matériel n'est disponible qu'après livraison par le transporteur. Délai variable selon distance.

---

### ACTION: [SOC-101] Déménager (changer de commune)
**Déclencheur** : Menu `Profil` → « Déménagement »
**Prérequis** :
- Aucun bâtiment, aucun animal, aucune parcelle
- Solde € suffisant pour les frais
**Étapes** :
1. Aller dans `Profil` → « Déménagement »
2. Choisir nouvelle Région → Département → Commune
3. Confirmer (action irréversible)
**Validations serveur** :
- Vérifier aucun bâtiment/animal/parcelle
- Vérifier solde suffisant
**Impacts** :
- BDD: `user_profiles.commune_id = :new_commune_id`
- HT: 0 HT
- €: Frais de déménagement
- Effets: Perte de tous les amis privilégiés (changement de région). Matériel conservé. Argent conservé. Ancienneté conservée.

---

### ACTION: [SOC-102] Ouvrir ferme annexe
**Déclencheur** : Menu `Profil` → « Ferme annexe »
**Prérequis** :
- Ancienneté suffisante
**Étapes** :
1. Aller dans `Profil` → « Ferme annexe »
2. Choisir la commune de la ferme annexe
3. Confirmer
**Validations serveur** :
- Vérifier ancienneté
- Vérifier pas déjà de ferme annexe
**Impacts** :
- BDD: `INSERT INTO user_profiles(user_id, commune_id, type='annexe', balance=0)`
- HT: 0 HT
- €: 0 € (ferme vide au départ)
- Effets: Deuxième exploitation indépendante. Pas de transfert d'argent entre ferme principale et annexe. HT séparés.

---

### ACTION: [SOC-103] Participer à un challenge
**Déclencheur** : Menu `Communauté` → « Challenges » → bouton « Participer »
**Prérequis** :
- Challenge en cours
- Conditions du challenge remplies (ex: avoir du blé, avoir des animaux d'une race)
**Étapes** :
1. Consulter les challenges en cours
2. Vérifier les conditions (type: meilleur rendement, meilleurs animaux, meilleur CA)
3. Cliquer « Participer » (automatique si conditions remplies)
**Validations serveur** :
- Vérifier conditions du challenge
**Impacts** :
- BDD: `INSERT INTO challenge_participants(...)`, résultats calculés à la fin du challenge
- HT: 0 HT
- €: 0 € pour participer, gains si classé (1er=10pts, 2ème=5pts, 3ème=1pt)
- Effets: Challenges individuels, départementaux ou régionaux. Durées 2h, 32h ou 48h. Points convertibles.

---

### ACTION: [SOC-104] Participer à la loterie
**Déclencheur** : Dashboard → « Nouveau tirage au sort » → bouton « Participer »
**Prérequis** :
- Loterie en cours
**Étapes** :
1. Cliquer « Participer » sur le dashboard
2. Confirmer
**Validations serveur** :
- Vérifier loterie active
- Vérifier pas déjà inscrit
**Impacts** :
- BDD: `INSERT INTO loterie_participants(...)`
- HT: 0 HT
- €: 0 €
- Effets: Tirage au sort avec gains virtuels.

---

### ACTION: [SOC-105] Gérer ses préférences
**Déclencheur** : Menu `Profil` → « Mes préférences »
**Prérequis** : Aucun
**Étapes** :
1. Choisir activité par défaut (Ferme, Maraîchage, Transport, etc.)
2. Nombre d'animaux par page (10/25/50/75/100/125/150)
3. Affichage génétique (complet/simplifié)
4. Préfixe nom animaux (aléatoire ou lettre A-Z)
5. Paille par défaut (presser/broyer)
6. Dose engrais par défaut (minimale/conseillée/maximale)
7. Langue (français/anglais)
8. Sauvegarder
**Validations serveur** :
- Vérifier valeurs dans les bornes autorisées
**Impacts** :
- BDD: `UPDATE user_preferences SET ...`
- HT: 0 HT
- €: 0 €
- Effets: Modifie le comportement par défaut de l'interface.

---

### ACTION: [SOC-106] Gérer ses filtres de notifications
**Déclencheur** : Menu `Profil` → « Filtres de notifications »
**Prérequis** : Aucun
**Étapes** :
1. Cocher/décocher les types de notifications à recevoir
2. Sauvegarder
**Validations serveur** : Aucune
**Impacts** :
- BDD: `UPDATE user_notification_filters SET ...`
- HT: 0 HT
- €: 0 €
- Effets: Filtre les notifications affichées sur le dashboard.

---

### ACTION: [SOC-107] Ajouter/Gérer favoris
**Déclencheur** : Icône ⭐ sur n'importe quelle page → « Ajouter aux favoris »
**Prérequis** : Aucun
**Étapes** :
1. Cliquer l'icône ⭐ sur la page courante
2. La page est ajoutée aux favoris
3. Accessible depuis `Profil` → « Mes favoris »
**Validations serveur** : Aucune
**Impacts** :
- BDD: `INSERT INTO favoris(user_id, page_url, label)`
- HT: 0 HT
- €: 0 €
- Effets: Raccourci rapide vers les pages fréquemment utilisées.

---

### ACTION: [SOC-108] Utiliser le bloc-notes
**Déclencheur** : Icône 📝 dans le header → popup bloc-notes
**Prérequis** : Aucun
**Étapes** :
1. Cliquer l'icône bloc-notes
2. Écrire/modifier ses notes personnelles
3. Sauvegarder
**Validations serveur** : Aucune
**Impacts** :
- BDD: `UPDATE user_profiles SET bloc_notes = :text`
- HT: 0 HT
- €: 0 €
- Effets: Notes personnelles persistantes.

---

### ACTION: [CUL-103] Faire du compostage (à la ferme)
**Déclencheur** : Onglet `Bâtiments` → Aire de compostage → bouton « Composter »
**Prérequis** :
- Aire de compostage construite
- Fumier en stock (3 tonnes fumier = 1 tonne compost)
**Étapes** :
1. Aller dans `Bâtiments` → Aire de compostage
2. Transférer du fumier vers l'aire (quantité au choix)
3. Le compostage démarre automatiquement le lendemain
4. **Jour 4 ou 5** : effectuer le 1er retournement (tracteur + retourneur d'andains ou ETA)
5. **Jour 9 ou 10** : effectuer le 2ème retournement
6. **Jour 14** : compost prêt, récupérable
**Validations serveur** :
- Vérifier aire de compostage existante
- Vérifier stock fumier suffisant
- Vérifier retournements effectués aux bons jours
**Impacts** :
- BDD: `aire_compostage.fumier -= quantite`, `aire_compostage.compost += quantite/3`, `aire_compostage.date_debut = now()`
- HT: Variable (retournements : tracteur + retourneur ou ETA)
- €: 0 € (fumier déjà en stock) ou coût ETA pour retournements
- Effets: Si retournements pas effectués, compost partiellement ou totalement perdu. Compost utilisable en bio. Épandage : 15T/ha, apports N95/P60/K120/Ca180/Mg35/S60 kg/ha.

---

### ACTION: [CUL-104] Construire retenue collinaire
**Déclencheur** : Onglet `Parcelles` → parcelle avec rivière → bouton « Construire retenue collinaire »
**Prérequis** :
- Parcelle avec une **rivière** (pas un ruisseau)
- Solde € suffisant
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Construire retenue collinaire »
3. Choisir la capacité (1 000 à 7 000 m³)
4. Confirmer
**Validations serveur** :
- Vérifier présence rivière sur la parcelle
- Vérifier solde suffisant (50 000-350 000 €)
**Impacts** :
- BDD: `INSERT INTO retenues_collinaires(parcelle_id, capacite, date_construction)`, `joueur.solde -= prix`
- HT: 0 HT (construction)
- €: 50 000-350 000 € selon capacité
- Effets: La retenue se remplit automatiquement depuis la rivière. Permet d'irriguer toutes les parcelles de la même commune. Système de pompage automatique.

---

### ACTION: [COM-101] Vendre lait à une laiterie (joueur)
**Déclencheur** : Onglet `Animaux` → « Lait » → bouton « Vendre à une laiterie »
**Prérequis** :
- Lait en cuve
- Contrat laiterie actif avec une CAR
**Étapes** :
1. Aller dans `Animaux` → « Lait »
2. Choisir « Vendre à une laiterie » (au lieu de Cultivia)
3. Le système affiche les contrats laiterie actifs
4. Sélectionner le contrat
5. Le lait est réservé pour collecte par le transporteur de la laiterie
**Validations serveur** :
- Vérifier contrat laiterie actif
- Vérifier lait en cuve
- Vérifier qualité lait dans les bornes du contrat (indice QL min/max)
**Impacts** :
- BDD: `cuves_lait.quantite -= volume`, `contrat_laiterie.volume_livre += volume`
- HT: 0 HT (le transporteur vient chercher)
- €: Prix selon contrat (supérieur au prix Cultivia, basé sur indice QL)
- Effets: Le lait doit être collecté par un transporteur (joueur). Meilleure valorisation qu'une vente à Cultivia. Volume mensuel à respecter sous peine de rupture de contrat (3 mois non respectés = rupture).

---

### ACTION: [COM-102] Signer contrat laiterie
**Déclencheur** : Onglet `Animaux` → « Lait » → « Contrats laiterie » → bouton « Signer un contrat »
**Prérequis** :
- Production de lait active
- Au moins une laiterie (CAR) dans la région
**Étapes** :
1. Consulter les laiteries disponibles dans la région
2. Négocier : volume mensuel, qualité QL min/max, prix/1000L, clause exclusivité
3. Signer le contrat (durée 1 saison = 12 mois Cultivia)
4. Renouveler ou renégocier 1 mois avant le terme
**Validations serveur** :
- Vérifier laiterie active
- Vérifier pas de conflit avec clause exclusivité existante
**Impacts** :
- BDD: `INSERT INTO contrats_laiterie(producteur_id, laiterie_id, volume, ql_min, ql_max, prix, exclusivite, duree)`
- HT: 0 HT
- €: 0 € (le prix est perçu à chaque livraison)
- Effets: Engagement sur 1 saison. Exclusivité possible (par type de lait). Rupture si 3 mois non respectés.

---

### ACTION: [CAR-101] Appels d'offres CAR
**Déclencheur** : Menu `Coopérative` → « Appels d'offres CAR »
**Prérequis** :
- CAR active
- Stock de produits de récolte
**Étapes** :
1. Consulter les appels d'offres (usines, plusieurs centaines de tonnes)
2. Faire une proposition (prix, quantité)
3. Si retenu : livrer la quantité mensuelle pendant la durée du contrat
**Validations serveur** :
- Vérifier CAR active
- Vérifier stock suffisant pour la proposition
**Impacts** :
- BDD: `INSERT INTO appels_offres_car(...)`, livraisons mensuelles
- HT: 0 HT (transport par transporteur)
- €: Revenus selon contrat, amende si non-respect
- Effets: Bon moyen d'écouler des surplus de récoltes. Durée 1-3 mois. Forte amende si non-livraison.

---

### ACTION: [CAR-102] Acheter/Souscrire parts sociales CAR
**Déclencheur** : Menu `Coopérative` → « Parts sociales » → bouton « Acheter des parts »
**Prérequis** :
- 90 jours d'ancienneté
- CAR ayant émis des parts sociales
- Solde € suffisant
**Étapes** :
1. Consulter les CAR ayant émis des parts (1€/part)
2. Choisir le nombre de parts
3. Acheter
**Validations serveur** :
- Vérifier ancienneté ≥ 90j
- Vérifier solde suffisant
**Impacts** :
- BDD: `INSERT INTO parts_sociales(user_id, car_id, nb_parts)`, `joueur.solde -= nb_parts`
- HT: 0 HT
- €: -1€/part achetée
- Effets: Dividendes versés 1x/saison (taux fixé par les associés). Parts revendables à la CAR après 84 jours à 1€/part. Perdues si la CAR fait faillite.

---

### ACTION: [CAR-103] Emprunter (CAR)
**Déclencheur** : Menu `CAR` → « Finance » → bouton « Emprunter »
**Prérequis** :
- Être associé de la CAR
- Vote des associés
**Étapes** :
1. Proposer un emprunt (montant ≤ capital CAR)
2. Vote des associés
3. Si accepté : argent crédité sur le compte CAR
**Validations serveur** :
- Vérifier montant ≤ capital
- Vérifier vote majoritaire
**Impacts** :
- BDD: `INSERT INTO emprunts_car(...)`, `car.solde += montant`
- HT: 0 HT
- €: Taux 0%, remboursement chaque fin de saison ou par anticipation
- Effets: Permet de financer les investissements lourds (huilerie, sucrerie, laiterie).

---

### ACTION: [SOC-109] Désinscription
**Déclencheur** : Menu `Profil` → « Désinscription »
**Prérequis** : Aucun
**Étapes** :
1. Cliquer « Désinscription »
2. Confirmer (double confirmation : « Êtes-vous sûr ? » + saisir mot de passe)
3. Compte supprimé définitivement
**Validations serveur** :
- Vérifier mot de passe correct
**Impacts** :
- BDD: Suppression de toutes les données du joueur (cascade)
- HT: -
- €: -
- Effets: Irréversible. Animaux, matériel, parcelles, bâtiments = perdus. Matériel partagé redistribué aux co-propriétaires.


## 24. DEEP SEARCH — ACTIONS MANQUANTES (Pass 2)

> 63 actions découvertes par analyse croisée des règles du jeu.

---

### CULTURES SPÉCIFIQUES (14 actions)

---

### ACTION: [CUL-105] Ensilage d'herbe (ensileuse sur pré)
**Déclencheur** : Onglet `Parcelles` → prairie → bouton « Ensiler l'herbe »
**Prérequis** :
- Prairie avec herbe à maturité suffisante
- Ensileuse (automotrice ou tracteur+ensileuse traînée)
- Silo taupe disponible avec capacité restante
- HT suffisants
**Étapes** :
1. Sélectionner la prairie à ensiler
2. Choisir l'ensileuse disponible
3. Lancer l'ensilage
4. L'herbe ensilée est stockée automatiquement en silo taupe
**Validations serveur** :
- Vérifier possession ensileuse en état
- Vérifier silo taupe avec capacité restante
- Vérifier maturité herbe suffisante
- Vérifier HT disponibles
**Impacts** :
- BDD: `prairie.herbe = 0`, `silo_taupe.stock += quantité_ensilée`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 € (matériel déjà possédé)
- Effets: Alternative au foin. L'ensilage d'herbe est utilisable en ration animale (ingrédient ration libre). Rendement dépend du stade de coupe.

---

### ACTION: [CUL-106] Paille en vrac (autochargeuse)
**Déclencheur** : Onglet `Parcelles` → parcelle moissonnée → bouton « Ramasser paille en vrac »
**Prérequis** :
- Tracteur + autochargeuse
- Parcelle avec paille au sol après moisson
- Plateforme substrat (méthanisation) disponible
**Étapes** :
1. Sélectionner la parcelle avec paille au sol
2. Choisir tracteur + autochargeuse
3. Lancer le ramassage en vrac
4. Paille stockée sur plateforme substrat
**Validations serveur** :
- Vérifier possession tracteur + autochargeuse
- Vérifier paille présente sur parcelle
- Vérifier plateforme substrat avec capacité
**Impacts** :
- BDD: `parcelle.paille_au_sol = 0`, `plateforme_substrat.stock_paille += quantité`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: Paille en vrac exclusivement destinée à la méthanisation. Ne peut pas être utilisée comme litière.

---

### ACTION: [CUL-107] Mise en tas balles bord de parcelle
**Déclencheur** : Onglet `Parcelles` → parcelle avec balles → bouton « Mettre en tas »
**Prérequis** :
- Balles présentes dans la parcelle (foin, paille, ensilage)
- Aucun matériel requis
**Étapes** :
1. Sélectionner la parcelle contenant des balles
2. Cliquer « Mettre en tas bord de parcelle »
3. Les balles sont regroupées en bord de parcelle
**Validations serveur** :
- Vérifier présence de balles dans la parcelle
**Impacts** :
- BDD: `parcelle.balles_en_tas = true`, `parcelle.nb_balles_tas = N`
- HT: ~1 HT
- €: 0 €
- Effets: Prépare les balles pour transport par camion (semi plateau). Les balles restent en parcelle jusqu'à chargement.

---

### ACTION: [CUL-108] Compostage en parcelle
**Déclencheur** : Onglet `Parcelles` → parcelle vide → bouton « Composter fumier »
**Prérequis** :
- 30 tonnes de fumier minimum
- Parcelle disponible pour mise en tas
- Tracteur + épandeur (pour mise en tas)
**Étapes** :
1. Sélectionner la parcelle cible
2. Choisir la quantité de fumier (multiples de 30T)
3. Mise en tas du fumier dans la parcelle
4. 1er retournement entre J4 et J5
5. 2ème retournement entre J9 et J10
6. Compost prêt à J14
**Validations serveur** :
- Vérifier stock fumier ≥ 30T
- Vérifier parcelle disponible
- Vérifier retournements effectués aux bonnes dates
**Impacts** :
- BDD: `parcelle.compostage_actif = true`, `parcelle.compostage_jour = 0`, `fumier.stock -= 30T` → à J14 : `compost.stock += 10T`
- HT: Variable (mise en tas + 2 retournements)
- €: 0 €
- Effets: 30T fumier = 10T compost. Durée 14 jours. Si retournements manqués → qualité dégradée. Compost utilisable comme amendement.

---

### ACTION: [CUL-109] Binage (bineuse)
**Déclencheur** : Onglet `Parcelles` → culture en cours → bouton « Biner »
**Prérequis** :
- Tracteur + bineuse
- Culture compatible : haricot vert, pomme de terre
- Stade de croissance adapté
**Étapes** :
1. Sélectionner la parcelle à biner
2. Choisir tracteur + bineuse
3. Lancer le binage
4. Pour haricot vert : répéter une 2ème fois (2 binages obligatoires)
**Validations serveur** :
- Vérifier possession tracteur + bineuse
- Vérifier culture compatible (haricot vert, PDT)
- Vérifier stade de croissance adapté
- Pour haricot vert : vérifier nb binages < 2
**Impacts** :
- BDD: `parcelle.nb_binages += 1`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: Désherbage mécanique. Haricot vert nécessite 2 binages. Améliore rendement et réduit adventices.

---

### ACTION: [CUL-110] Passer herse de prairie
**Déclencheur** : Onglet `Parcelles` → prairie → bouton « Herser »
**Prérequis** :
- Tracteur + herse de prairie
- Prairie existante
**Étapes** :
1. Sélectionner la prairie
2. Choisir tracteur + herse de prairie
3. Lancer le hersage
**Validations serveur** :
- Vérifier possession tracteur + herse de prairie
- Vérifier que la parcelle est bien une prairie
**Impacts** :
- BDD: `prairie.hersee = true`, `prairie.bonus_pousse = 5`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: Pousse herbe passe de 4%/jour à 5%/jour. Effet s'atténue en hiver. Améliore la qualité du couvert herbacé.

---

### ACTION: [CUL-111] Ramasser balles
**Déclencheur** : Onglet `Parcelles` → parcelle avec balles → bouton « Ramasser balles »
**Prérequis** :
- Tracteur + chargeur frontal + plateau, OU télescopique + plateau
- Balles présentes dans la parcelle
- Hangar ou entrepôt avec capacité de stockage
**Étapes** :
1. Sélectionner la parcelle contenant les balles
2. Choisir l'attelage (tracteur+chargeur frontal+plateau ou télescopique+plateau)
3. Choisir le lieu de stockage (hangar/entrepôt)
4. Lancer le ramassage et transport
**Validations serveur** :
- Vérifier possession matériel adapté
- Vérifier balles présentes en parcelle
- Vérifier capacité stockage destination
**Impacts** :
- BDD: `parcelle.nb_balles -= N`, `hangar.stock_balles += N`, `joueur.ht -= coût_ht`
- HT: Variable selon distance et nombre de balles
- €: 0 €
- Effets: Balles transportées de la parcelle vers le lieu de stockage. Nécessaire avant de pouvoir utiliser le foin/paille.

---

### ACTION: [CUL-112] Rouler parcelle
**Déclencheur** : Onglet `Parcelles` → parcelle semée → bouton « Rouler »
**Prérequis** :
- Tracteur + rouleau
- Parcelle semée (céréales ou herbe)
**Étapes** :
1. Sélectionner la parcelle à rouler
2. Choisir tracteur + rouleau
3. Lancer le roulage
**Validations serveur** :
- Vérifier possession tracteur + rouleau
- Vérifier culture compatible (céréales, herbe)
- Vérifier parcelle déjà semée
**Impacts** :
- BDD: `parcelle.roulee = true`, `parcelle.bonus_rendement += 3 à 5`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: +3 à +5% rendement. Tasse le sol pour un meilleur contact graine-terre. Recommandé après semis.

---

### ACTION: [CUL-113] Semer tabac sous serre
**Déclencheur** : Onglet `Maraîchage` → serre → bouton « Semer tabac »
**Prérequis** :
- 35 000 graines de tabac
- 50 m² de serre vitrée
- 200 plateaux polystyrène
- 50 m² de bac maraîchage
- 100 m² de bâche plastique
**Étapes** :
1. Aller dans la serre vitrée (≥ 50 m²)
2. Installer les 200 plateaux polystyrène dans les bacs maraîchage
3. Couvrir avec la bâche plastique (100 m²)
4. Semer les 35 000 graines
5. Confirmer le semis
**Validations serveur** :
- Vérifier possession serre vitrée ≥ 50 m²
- Vérifier stock 35 000 graines tabac
- Vérifier 200 plateaux polystyrène
- Vérifier 50 m² bac maraîchage
- Vérifier 100 m² bâche plastique
**Impacts** :
- BDD: `serre.culture = 'tabac_semis'`, `stock.graines_tabac -= 35000`, `stock.plateaux -= 200`, `stock.bache -= 100`
- HT: Variable
- €: Coût des consommables (graines, plateaux, bâche)
- Effets: Plants de tabac en croissance sous serre. Prêts à repiquer en pleine terre en Avr-Mai.

---

### ACTION: [CUL-114] Repiquer tabac en pleine terre
**Déclencheur** : Onglet `Maraîchage` → serre avec plants tabac → bouton « Repiquer »
**Prérequis** :
- Plants de tabac prêts en serre
- Période Avril-Mai
- Parcelle préparée disponible
- Maximum 2 ha par exploitation
**Étapes** :
1. Sélectionner les plants prêts en serre
2. Choisir la parcelle de destination
3. Lancer le repiquage en pleine terre
**Validations serveur** :
- Vérifier plants prêts (stade suffisant)
- Vérifier période Avr-Mai
- Vérifier surface tabac totale ≤ 2 ha
- Vérifier parcelle préparée
**Impacts** :
- BDD: `serre.culture = null`, `parcelle.culture = 'tabac'`, `parcelle.stade = 'repiqué'`
- HT: Variable selon surface
- €: 0 €
- Effets: Tabac en pleine terre, croissance jusqu'à récolte. Max 2 ha/exploitation. Serre libérée pour autre usage.

---

### ACTION: [CUL-115] Cultiver luzerne
**Déclencheur** : Onglet `Parcelles` → parcelle labourée → bouton « Semer luzerne »
**Prérequis** :
- Semences luzerne : 25 kg/ha
- Tracteur + semoir
- Tracteur + rouleau (roulage post-semis obligatoire)
- Période Mars-Avril
**Étapes** :
1. Sélectionner la parcelle préparée
2. Semer la luzerne (25 kg/ha)
3. Rouler la parcelle immédiatement après semis
4. La luzerne reste en place 4 ans
5. Récolter jusqu'à 3 coupes/an (ensilage ou foin)
**Validations serveur** :
- Vérifier stock semences ≥ 25 kg/ha × surface
- Vérifier période Mars-Avril
- Vérifier possession semoir + rouleau
- Vérifier roulage effectué après semis
**Impacts** :
- BDD: `parcelle.culture = 'luzerne'`, `parcelle.annee_implantation = année_courante`, `parcelle.duree_max = 4 ans`
- HT: Variable selon surface (semis + roulage)
- €: Coût semences
- Effets: Culture pérenne exploitée 4 ans. Max 3 coupes/an en ensilage ou foin. Bon précédent cultural (fixation azote).

---

### ACTION: [CUL-116] Semer chanvre industriel
**Déclencheur** : Onglet `Parcelles` → parcelle préparée → bouton « Semer chanvre »
**Prérequis** :
- Semences chanvre : 50 kg/ha
- Tracteur + semoir
- Période Mai
**Étapes** :
1. Sélectionner la parcelle préparée
2. Semer le chanvre (50 kg/ha) en Mai
3. Aucun traitement phytosanitaire nécessaire
4. Récolte en 2 étapes : moissonneuse (grain) puis faucheuse (tige)
**Validations serveur** :
- Vérifier stock semences ≥ 50 kg/ha × surface
- Vérifier période Mai
- Vérifier possession semoir
**Impacts** :
- BDD: `parcelle.culture = 'chanvre'`, `stock.semences_chanvre -= 50 × surface`
- HT: Variable selon surface
- €: Coût semences
- Effets: Pas de traitement phytosanitaire. Récolte en 2 étapes : grain (moissonneuse) + tige (faucheuse). Culture écologique.

---

### ACTION: [CUL-117] Récolter lin (3 étapes)
**Déclencheur** : Onglet `Parcelles` → parcelle lin mature → bouton « Récolter lin »
**Prérequis** :
- Lin à maturité
- Étape 1 : arracheuse à lin
- Étape 2 : retourneuse à lin
- Étape 3 : presse à balles rondes
**Étapes** :
1. Arracher le lin avec l'arracheuse à lin
2. Attendre le rouissage au sol
3. Retourner le lin avec la retourneuse
4. Attendre séchage
5. Presser en balles rondes avec la presse
**Validations serveur** :
- Vérifier maturité du lin
- Vérifier possession arracheuse lin (étape 1)
- Vérifier possession retourneuse lin (étape 2)
- Vérifier possession presse ronde (étape 3)
- Vérifier respect séquence des étapes
**Impacts** :
- BDD: `parcelle.lin_etape = 1→2→3`, à chaque étape `joueur.ht -= coût_ht`, à étape 3 : `stock.balles_lin += N`
- HT: Variable à chaque étape
- €: 0 €
- Effets: Processus sur ~2 mois pour les 3 phases. Chaque étape nécessite une machine spécifique. Lin vendu en balles.

---

### ACTION: [CUL-118] Semer céréale immature
**Déclencheur** : Onglet `Parcelles` → parcelle semée en céréale → bouton « Ensiler immature »
**Prérequis** :
- Céréale semée : blé, orge, avoine ou triticale
- Stade de pousse entre 60% et 80%
- Date avant le 7 Mai
- Ensileuse disponible
**Étapes** :
1. Surveiller le stade de pousse de la céréale (60-80%)
2. Vérifier que la date est avant le 7 Mai
3. Lancer l'ensilage avec l'ensileuse
4. Céréale ensilée stockée en silo
**Validations serveur** :
- Vérifier culture = blé/orge/avoine/triticale
- Vérifier 60% ≤ stade pousse ≤ 80%
- Vérifier date < 7 Mai
- Vérifier possession ensileuse
**Impacts** :
- BDD: `parcelle.culture = null`, `silo.stock_ensilage_cereale += rendement`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: Rendement = 150% du rendement grain normal. Ensilage utilisable en ration animale. Parcelle libérée pour culture dérobée.

---

### ÉLEVAGE SPÉCIFIQUE (12 actions)

---

### ACTION: [ELV-102] Suivre/annoter un animal
**Déclencheur** : Onglet `Animaux` → fiche animal → bouton « Annoter »
**Prérequis** :
- Au moins 1 animal dans le cheptel
**Étapes** :
1. Ouvrir la fiche de l'animal
2. Cliquer « Annoter / Suivre »
3. Saisir une note texte libre
4. L'animal est marqué comme « suivi » dans la liste
**Validations serveur** :
- Vérifier que l'animal appartient au joueur
**Impacts** :
- BDD: `animal.suivi = true`, `animal.note = 'texte_libre'`
- HT: 0 HT
- €: 0 €
- Effets: L'animal apparaît en surbrillance dans les listes. Facilite le suivi individuel (reproduction, santé, vente).

---

### ACTION: [ELV-103] Ressusciter animal mort
**Déclencheur** : Dashboard → notification animal mort → bouton « Ressusciter »
**Prérequis** :
- Animal mort récemment
- Solde € suffisant
**Étapes** :
1. Voir la notification de mort sur le dashboard
2. Cliquer « Ressusciter »
3. Payer le coût de résurrection
4. L'animal est remis en vie
**Validations serveur** :
- Vérifier que l'animal est bien mort
- Vérifier solde € suffisant
**Impacts** :
- BDD: `animal.vivant = true`, `animal.sante = valeur_initiale`, `joueur.solde -= coût_resurrection`
- HT: 0 HT
- €: Coût variable selon espèce et valeur de l'animal
- Effets: L'animal retrouve un état de santé initial. Option de confort pour éviter la perte définitive.

---

### ACTION: [ELV-104] Retirer animal mort
**Déclencheur** : Onglet `Animaux` → animal mort → bouton « Retirer »
**Prérequis** :
- Animal mort dans le cheptel
**Étapes** :
1. Aller dans la liste des animaux
2. Identifier l'animal mort
3. Cliquer « Retirer définitivement »
4. Confirmer la suppression
**Validations serveur** :
- Vérifier que l'animal est mort
- Vérifier que l'animal appartient au joueur
**Impacts** :
- BDD: `DELETE FROM animaux WHERE id = X`
- HT: 0 HT
- €: 0 €
- Effets: Animal supprimé définitivement de la liste. Libère une place dans le bâtiment. Irréversible.

---

### ACTION: [ELV-105] Remplir râtelier au pré
**Déclencheur** : Onglet `Parcelles` → prairie avec râtelier → bouton « Remplir râtelier »
**Prérequis** :
- Tracteur + benne
- Foin ou ration disponible en stock
- Râtelier installé dans la prairie
**Étapes** :
1. Sélectionner la prairie avec le râtelier
2. Choisir tracteur + benne
3. Sélectionner le type d'aliment (foin ou ration)
4. Charger et emmener au râtelier
**Validations serveur** :
- Vérifier possession tracteur + benne
- Vérifier stock aliment suffisant
- Vérifier râtelier présent dans la prairie
**Impacts** :
- BDD: `ratelier.stock += quantité`, `silo.stock -= quantité`, `joueur.ht -= coût_ht`
- HT: Variable selon distance
- €: 0 €
- Effets: Les animaux au pré se nourrissent au râtelier. Indispensable en hiver quand l'herbe ne pousse plus.

---

### ACTION: [ELV-106] Poser clôture bisons/daims
**Déclencheur** : Onglet `Parcelles` → prairie boisée → bouton « Clôturer »
**Prérequis** :
- Prairie boisée
- Tracteur + enfonce-pieux
- Tracteur + dérouleuse grillage
- Grillage 2m de haut
**Étapes** :
1. Sélectionner la prairie boisée
2. Enfoncer les pieux (tracteur + enfonce-pieux)
3. Dérouler le grillage 2m (tracteur + dérouleuse grillage)
4. Clôture terminée
**Validations serveur** :
- Vérifier parcelle = prairie boisée
- Vérifier possession enfonce-pieux + tracteur
- Vérifier possession dérouleuse grillage + tracteur
- Vérifier stock grillage suffisant
**Impacts** :
- BDD: `prairie.cloture_haute = true`, `stock.grillage -= périmètre`, `joueur.ht -= coût_ht`
- HT: Variable selon périmètre
- €: Coût du grillage
- Effets: Obligatoire pour accueillir bisons ou daims. Clôture 2m de haut empêche les évasions. Prairie boisée uniquement.

---

### ACTION: [ELV-107] Construire corral
**Déclencheur** : Onglet `Parcelles` → prairie boisée clôturée → bouton « Construire corral »
**Prérequis** :
- Prairie boisée avec clôture haute posée
- Matériaux de construction
- 1 seul corral par prairie boisée
**Étapes** :
1. Sélectionner la prairie boisée clôturée
2. Choisir l'emplacement du corral
3. Lancer la construction
**Validations serveur** :
- Vérifier clôture haute posée
- Vérifier aucun corral existant sur cette prairie
- Vérifier matériaux disponibles
**Impacts** :
- BDD: `INSERT INTO corrals(prairie_id, ...)`, `joueur.solde -= coût_construction`
- HT: Variable
- €: Coût matériaux de construction
- Effets: Permet le regroupement des bisons/daims pour chargement, soins vétérinaires. 1 corral max par prairie boisée.

---

### ACTION: [ELV-108] Préparer ration bison/daim
**Déclencheur** : Onglet `Élevage` → rations → bouton « Préparer ration bison/daim »
**Prérequis** :
- Stock de foin
- Stock de blé ou triticale
- Stock d'orge
- Stock d'avoine
- Stock de tourteau
- Stock de minéraux
- Silo disponible pour stockage
**Étapes** :
1. Sélectionner les ingrédients et quantités
2. Mélanger : foin + blé/triticale + orge + avoine + tourteau + minéraux
3. Stocker la ration préparée en silo
**Validations serveur** :
- Vérifier stock de chaque ingrédient suffisant
- Vérifier silo avec capacité restante
**Impacts** :
- BDD: `silo.stock_ration_bison += quantité`, stocks ingrédients décrémentés, `joueur.ht -= coût_ht`
- HT: Variable selon quantité
- €: 0 € (ingrédients déjà en stock)
- Effets: Ration spécifique bisons/daims. Composition équilibrée obligatoire. Stockée en silo pour distribution hivernale.

---

### ACTION: [ELV-109] Emmener ration au pré
**Déclencheur** : Onglet `Parcelles` → prairie boisée → bouton « Emmener ration »
**Prérequis** :
- Tracteur + benne
- Ration bison/daim préparée en stock
- Période hivernale : Oct-Mars (bisons et daims)
**Étapes** :
1. Sélectionner la prairie boisée
2. Choisir tracteur + benne
3. Charger la ration depuis le silo
4. Emmener au pré et distribuer
**Validations serveur** :
- Vérifier possession tracteur + benne
- Vérifier stock ration suffisant
- Vérifier période Oct-Mars
**Impacts** :
- BDD: `silo.stock_ration -= quantité`, `prairie.ration_distribuee = true`, `joueur.ht -= coût_ht`
- HT: Variable selon distance
- €: 0 €
- Effets: Alimentation hivernale obligatoire pour bisons/daims. En été, ils se nourrissent seuls au pré.

---

### ACTION: [ELV-110] Acheter concentré jeune
**Déclencheur** : Menu `Coopérative` → rayon alimentation → bouton « Acheter concentré jeune »
**Prérequis** :
- Solde € suffisant
- Jeunes animaux présents : veaux 0-3 mois, porcelets 0-1 mois, ou lapereaux 0-1 mois
**Étapes** :
1. Aller à la coopérative
2. Sélectionner « Concentré jeune »
3. Choisir la quantité
4. Acheter
**Validations serveur** :
- Vérifier solde € suffisant
**Impacts** :
- BDD: `stock.concentre_jeune += quantité`, `joueur.solde -= coût`
- HT: 0 HT (achat en ligne)
- €: Prix coopérative variable
- Effets: Aliment spécifique pour jeunes animaux. Veaux 0-3 mois, porcelets 0-1 mois, lapereaux 0-1 mois. Indispensable à leur survie.

---

### ACTION: [ELV-111] Purger fosse à lisier
**Déclencheur** : Onglet `Bâtiments` → fosse à lisier → bouton « Purger »
**Prérequis** :
- Fosse à lisier pleine ou partiellement pleine
- Impossibilité d'épandre (période interdite ou pas de parcelle disponible)
**Étapes** :
1. Sélectionner la fosse à lisier
2. Cliquer « Purger » (vider sans épandre)
3. Confirmer la purge
**Validations serveur** :
- Vérifier fosse non vide
**Impacts** :
- BDD: `fosse_lisier.niveau = 0`
- HT: ~1 HT
- €: Coût de traitement (évacuation)
- Effets: Vide la fosse sans valorisation agronomique. Solution de dernier recours quand l'épandage est impossible. Lisier perdu.

---

### ACTION: [BAT-101] Activer aire/silo de chargement
**Déclencheur** : Onglet `Bâtiments` → aire ou silo → bouton « Activer chargement »
**Prérequis** :
- Aire de chargement ou silo construit
**Étapes** :
1. Sélectionner l'aire ou le silo
2. Cliquer « Activer pour chargement/déchargement »
3. L'aire est ouverte aux transporteurs
**Validations serveur** :
- Vérifier possession de l'aire/silo
**Impacts** :
- BDD: `aire_chargement.actif = true`
- HT: 0 HT
- €: 0 €
- Effets: Permet aux transporteurs (joueurs ou PNJ) de charger/décharger chez vous. Nécessaire pour le commerce inter-joueurs.

---

### ACTION: [ELV-112] Choisir élevage litière vs caillebotis
**Déclencheur** : Onglet `Bâtiments` → construction bâtiment élevage → choix « Type de sol »
**Prérequis** :
- Construction ou rénovation d'un bâtiment bovins ou porcins
**Étapes** :
1. Lors de la construction du bâtiment, choisir le type de sol
2. Option A : Litière (paille au sol) → produit du fumier
3. Option B : Caillebotis (grille) → produit du lisier
4. Confirmer le choix (irréversible sauf rénovation)
**Validations serveur** :
- Vérifier espèce compatible (bovins, porcins)
- Vérifier choix non déjà effectué (sauf rénovation)
**Impacts** :
- BDD: `batiment.type_sol = 'litiere' | 'caillebotis'`
- HT: 0 HT (choix lors de la construction)
- €: Inclus dans le coût de construction
- Effets: Litière = fumier (épandage, compostage). Caillebotis = lisier (fosse, épandage liquide). Impact sur labels : plein-air incompatible avec caillebotis.

---

### PARCELLES / ACHATS (4 actions)

---

### ACTION: [CUL-119] Acheter parcelle via Partcel
**Déclencheur** : Menu `Parcelles` → « Acheter une parcelle » → onglet « Partcel »
**Prérequis** :
- Solde € suffisant
**Étapes** :
1. Aller dans le menu Parcelles → Acheter
2. Sélectionner l'organisme Partcel
3. Choisir la surface souhaitée
4. Acheter au prix fixé (3 000 €/ha en France, +50% si bio)
**Validations serveur** :
- Vérifier solde ≥ prix (3 000 €/ha × surface, ×1.5 si bio)
**Impacts** :
- BDD: `INSERT INTO parcelles(user_id, surface, type, bio)`, `joueur.solde -= prix`
- HT: 0 HT
- €: 3 000 €/ha (France), +50% si bio
- Effets: Parcelle toujours disponible via Partcel (stock illimité). Prix fixe, pas de négociation. Alternative au marché joueur.

---

### ACTION: [CUL-120] Louer parcelle via Partcel
**Déclencheur** : Menu `Parcelles` → « Louer une parcelle » → onglet « Partcel »
**Prérequis** :
- Solde € suffisant pour le loyer
**Étapes** :
1. Aller dans le menu Parcelles → Louer
2. Sélectionner Partcel
3. Choisir la surface et la durée
4. Signer le bail de location
**Validations serveur** :
- Vérifier solde suffisant pour le loyer
**Impacts** :
- BDD: `INSERT INTO locations_parcelles(user_id, surface, loyer, date_debut)`, `joueur.solde -= loyer`
- HT: 0 HT
- €: Loyer périodique
- Effets: Parcelle en location. Rachat possible dès la 2ème année de location. Loyer prélevé automatiquement.

---

### ACTION: [CUL-121] Racheter parcelle en location
**Déclencheur** : Menu `Parcelles` → parcelle louée → bouton « Racheter »
**Prérequis** :
- Parcelle en location depuis au moins 2 ans
- Solde € suffisant pour le rachat
**Étapes** :
1. Sélectionner la parcelle louée (≥ 2 ans)
2. Cliquer « Racheter »
3. Payer le prix de rachat
4. La parcelle devient propriété du joueur
**Validations serveur** :
- Vérifier durée location ≥ 2 ans
- Vérifier solde suffisant
**Impacts** :
- BDD: `parcelle.proprietaire = user_id`, `DELETE FROM locations_parcelles WHERE id = X`, `joueur.solde -= prix_rachat`
- HT: 0 HT
- €: Prix de rachat (valeur marché)
- Effets: La parcelle devient propriété définitive. Plus de loyer à payer. Bail résilié automatiquement.

---

### ACTION: [BAT-102] Entretien bâtiment par entreprise extérieure
**Déclencheur** : Automatique, 1 fois par saison
**Prérequis** :
- Bâtiment existant
**Étapes** :
1. L'entretien est déclenché automatiquement 1x/saison
2. Une entreprise extérieure effectue les travaux
3. Le coût est prélevé automatiquement
**Validations serveur** :
- Vérifier solde suffisant pour le prélèvement
**Impacts** :
- BDD: `batiment.entretien_date = date_courante`, `joueur.solde -= coût_entretien`
- HT: 0 HT (pas de HT joueur, entreprise extérieure)
- €: Coût variable selon type et taille du bâtiment
- Effets: Maintient le bâtiment en bon état. Automatique et payant. Aucun HT consommé côté joueur.

---

### FORÊT DÉTAILLÉ (8 actions)

---

### ACTION: [FOR-101] Taille de formation (forêt)
**Déclencheur** : Onglet `Forêts` → parcelle forestière jeune → bouton « Taille de formation »
**Prérequis** :
- Plantation effectuée l'année précédente
- Kit de taille (manuel)
**Étapes** :
1. Sélectionner la parcelle forestière (année suivant plantation)
2. Utiliser le kit de taille
3. Tailler manuellement les jeunes arbres
**Validations serveur** :
- Vérifier année = année plantation + 1
- Vérifier possession kit de taille
**Impacts** :
- BDD: `parcelle_foret.taille_formation = true`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 € (kit déjà acheté)
- Effets: Améliore la forme des arbres et leur croissance future. Travail manuel avec kit. Année suivant la plantation uniquement.

---

### ACTION: [FOR-102] Traitement phytosanitaire forêt
**Déclencheur** : Onglet `Forêts` → parcelle forestière → bouton « Traiter »
**Prérequis** :
- Tracteur + pulvérisateur arboricole
- Produit phytosanitaire en stock
**Étapes** :
1. Sélectionner la parcelle forestière
2. Choisir tracteur + pulvérisateur arboricole
3. Sélectionner le produit phytosanitaire
4. Lancer le traitement
**Validations serveur** :
- Vérifier possession tracteur + pulvérisateur arboricole
- Vérifier stock produit phytosanitaire
**Impacts** :
- BDD: `parcelle_foret.traitement_date = date`, `stock.phyto -= quantité`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: Coût du produit phytosanitaire
- Effets: Protection contre les insectes ravageurs. Préventif ou curatif selon le produit utilisé.

---

### ACTION: [FOR-103] Marquage de coupe
**Déclencheur** : Onglet `Forêts` → parcelle forestière mature → bouton « Marquer coupe »
**Prérequis** :
- Arbres à maturité suffisante pour éclaircie
- Kit de marquage (manuel)
**Étapes** :
1. Sélectionner la parcelle forestière
2. Utiliser le kit de marquage
3. Repérer et marquer les arbres à abattre
4. Valider le marquage
**Validations serveur** :
- Vérifier maturité suffisante pour éclaircie
- Vérifier possession kit de marquage
**Impacts** :
- BDD: `parcelle_foret.arbres_marques = N`, `joueur.ht -= coût_ht`
- HT: Variable selon nombre d'arbres
- €: 0 € (kit déjà acheté)
- Effets: Étape préalable obligatoire avant éclaircie. Permet de sélectionner les arbres à abattre. Travail manuel.

---

### ACTION: [FOR-104] Entretien piste forestière
**Déclencheur** : Onglet `Forêts` → infrastructure → bouton « Entretenir piste »
**Prérequis** :
- Débroussailleur à bras + tracteur
- Piste forestière existante
**Étapes** :
1. Sélectionner la piste forestière
2. Choisir tracteur + débroussailleur à bras
3. Lancer l'entretien
**Validations serveur** :
- Vérifier possession tracteur + débroussailleur à bras
- Vérifier piste existante
**Impacts** :
- BDD: `piste.entretien_date = date`, `joueur.ht -= coût_ht`
- HT: Proportionnel à la longueur de la piste
- €: 0 €
- Effets: Maintient l'accessibilité de la piste. HT proportionnel à la longueur. Nécessaire pour le débardage.

---

### ACTION: [FOR-105] Entretien route forestière
**Déclencheur** : Onglet `Forêts` → infrastructure → bouton « Entretenir route »
**Prérequis** :
- Débroussailleur à bras + tracteur
- Route forestière existante (vers sortie forêt)
**Étapes** :
1. Sélectionner la route forestière
2. Choisir tracteur + débroussailleur à bras
3. Lancer l'entretien
**Validations serveur** :
- Vérifier possession tracteur + débroussailleur à bras
- Vérifier route existante
**Impacts** :
- BDD: `route_forestiere.entretien_date = date`, `joueur.ht -= coût_ht`
- HT: Proportionnel à la longueur de la route
- €: 0 €
- Effets: Route vers la sortie de forêt. Indispensable pour l'évacuation du bois. HT proportionnel à la longueur.

---

### ACTION: [FOR-106] Entretien place de dépôt
**Déclencheur** : Onglet `Forêts` → infrastructure → bouton « Entretenir place de dépôt »
**Prérequis** :
- Débroussailleur + tracteur
- Place de dépôt existante
**Étapes** :
1. Sélectionner la place de dépôt
2. Choisir tracteur + débroussailleur
3. Lancer l'entretien
**Validations serveur** :
- Vérifier possession tracteur + débroussailleur
- Vérifier place de dépôt existante
**Impacts** :
- BDD: `place_depot.entretien_date = date`, `joueur.ht -= coût_ht`
- HT: Proportionnel à la surface de la place
- €: 0 €
- Effets: Lieu de stockage temporaire du bois avant transport. HT proportionnel à la surface. Entretien régulier nécessaire.

---

### ACTION: [FOR-107] Fertilisation forêt
**Déclencheur** : Onglet `Forêts` → parcelle forestière → bouton « Fertiliser »
**Prérequis** :
- Engrais : 120 kg/ha
- Tracteur + épandeur
**Étapes** :
1. Sélectionner la parcelle forestière
2. Choisir tracteur + épandeur
3. Épandre 120 kg/ha d'engrais
**Validations serveur** :
- Vérifier stock engrais ≥ 120 kg/ha × surface
- Vérifier possession tracteur + épandeur
**Impacts** :
- BDD: `stock.engrais -= 120 × surface`, `parcelle_foret.fertilisee = true`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: Coût de l'engrais
- Effets: Accélère la croissance des arbres. 120 kg/ha. Recommandé sur sols pauvres.

---

### ACTION: [FOR-108] Labour forêt
**Déclencheur** : Onglet `Forêts` → parcelle à planter → bouton « Labourer »
**Prérequis** :
- Tracteur + déchaumeur forestier
- Parcelle forestière avant plantation
**Étapes** :
1. Sélectionner la parcelle forestière à préparer
2. Choisir tracteur + déchaumeur forestier
3. Lancer le labour
**Validations serveur** :
- Vérifier possession tracteur + déchaumeur forestier
- Vérifier parcelle non encore plantée
**Impacts** :
- BDD: `parcelle_foret.labouree = true`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: Prépare le sol avant plantation forestière. Déchaumeur forestier spécifique. Améliore la reprise des plants.

---

### FROMAGERIE DÉTAILLÉ (5 actions)

---

### ACTION: [FRO-101] Transformer crème en beurre
**Déclencheur** : Onglet `Fromagerie` → bouton « Transformer crème en beurre »
**Prérequis** :
- Fromagerie construite et opérationnelle
- Stock de crème disponible
- Fromager disponible
**Étapes** :
1. Aller dans la fromagerie
2. Sélectionner « Transformer crème en beurre »
3. Choisir la quantité de crème
4. Lancer la transformation (1L crème = 0.480 kg beurre)
**Validations serveur** :
- Vérifier fromagerie opérationnelle
- Vérifier stock crème suffisant
- Vérifier fromager disponible
**Impacts** :
- BDD: `stock.creme -= quantité_L`, `stock.beurre += quantité_L × 0.480`, `joueur.ht -= coût_ht`
- HT: Variable selon quantité
- €: 0 €
- Effets: 1L crème = 0.480 kg beurre. DLC beurre = 18 jours. Vendable sur les marchés.

---

### ACTION: [FRO-102] Nettoyer fromagerie
**Déclencheur** : Onglet `Fromagerie` → bouton « Nettoyer » (en fin de journée)
**Prérequis** :
- Fromagerie utilisée dans la journée
**Étapes** :
1. En fin de journée, aller dans la fromagerie
2. Cliquer « Nettoyer »
3. La fromagerie est nettoyée
4. Fromagerie inutilisable jusqu'au lendemain
**Validations serveur** :
- Vérifier fromagerie utilisée aujourd'hui
**Impacts** :
- BDD: `fromagerie.nettoyee = true`, `fromagerie.disponible_demain = true`
- HT: ~1 HT
- €: 0 €
- Effets: Obligatoire après chaque utilisation. Fromagerie indisponible jusqu'au lendemain. Si non nettoyée → problèmes qualité.

---

### ACTION: [FRO-103] Entretenir matériel fromagerie
**Déclencheur** : Onglet `Fromagerie` → bouton « Entretenir matériel »
**Prérequis** :
- Fromagerie avec matériel installé
**Étapes** :
1. Aller dans la fromagerie
2. Cliquer « Entretenir matériel »
3. Effectuer l'entretien
**Validations serveur** :
- Vérifier fromagerie existante
**Impacts** :
- BDD: `fromagerie.materiel_entretenu = true`, `fromagerie.derniere_maintenance = date`, `joueur.ht -= coût_ht`
- HT: Variable
- €: Coût pièces d'entretien
- Effets: Évite les problèmes de qualité des fromages. Entretien régulier recommandé. Matériel mal entretenu → fromages de moindre qualité.

---

### ACTION: [FRO-104] Former fromager
**Déclencheur** : Onglet `Fromagerie` → personnel → bouton « Former »
**Prérequis** :
- Fromager embauché
- 1 000 € disponibles
**Étapes** :
1. Sélectionner le fromager à former
2. Payer 1 000 € de formation
3. Le fromager passe de 240 à 300 points compétences max
**Validations serveur** :
- Vérifier fromager embauché
- Vérifier solde ≥ 1 000 €
- Vérifier compétences max actuelles = 240
**Impacts** :
- BDD: `fromager.competences_max = 300`, `joueur.solde -= 1000`
- HT: 0 HT
- €: -1 000 €
- Effets: Augmente le plafond de compétences du fromager de 240 à 300. Meilleure qualité de fromage. Investissement rentable à long terme.

---

### ACTION: [FRO-105] Embaucher fromager
**Déclencheur** : Onglet `Fromagerie` → personnel → bouton « Embaucher fromager »
**Prérequis** :
- Fromagerie industrielle
- Moins de 10 fromagers actuellement
- Solde € suffisant
**Étapes** :
1. Aller dans la fromagerie industrielle
2. Cliquer « Embaucher fromager »
3. Consulter les candidats disponibles (compétences variables)
4. Sélectionner et embaucher
**Validations serveur** :
- Vérifier fromagerie industrielle
- Vérifier nb fromagers < 10
- Vérifier solde suffisant
**Impacts** :
- BDD: `INSERT INTO fromagers(fromagerie_id, competences)`, coût salarial quotidien activé
- HT: 35 HT/jour consommés par le fromager
- €: Salaire quotidien
- Effets: Fromagerie industrielle : 2 à 10 fromagers. Chaque fromager consomme 35 HT/jour. Compétences variables selon le candidat.

---

### EMPLOI / RH (4 actions)

---

### ACTION: [MAR-101] Embaucher ouvrier maraîchage
**Déclencheur** : Menu `Personnel` → bouton « Embaucher ouvrier maraîchage »
**Prérequis** :
- Activité maraîchage active
- Solde € suffisant
**Étapes** :
1. Aller dans le menu Personnel
2. Cliquer « Embaucher ouvrier maraîchage »
3. Choisir le type de contrat : CDI ou saisonnier (1 à 3 mois)
4. Confirmer l'embauche
**Validations serveur** :
- Vérifier activité maraîchage
- Vérifier solde suffisant pour le salaire
**Impacts** :
- BDD: `INSERT INTO employes(user_id, type='ouvrier_maraichage', contrat)`, coût salarial activé
- HT: 35 HT/jour consommés par l'ouvrier
- €: Salaire quotidien
- Effets: CDI ou saisonnier 1-3 mois. Consomme 35 HT/jour. Effectue les travaux de maraîchage automatiquement.

---

### ACTION: [TRA-101] Embaucher chauffeur routier
**Déclencheur** : Menu `Personnel` → bouton « Embaucher chauffeur routier »
**Prérequis** :
- Licence transport souscrite
- Camion disponible
- Solde € suffisant
**Étapes** :
1. Aller dans le menu Personnel
2. Cliquer « Embaucher chauffeur routier »
3. Confirmer l'embauche (270 €/jour)
**Validations serveur** :
- Vérifier licence transport active
- Vérifier possession camion
- Vérifier solde suffisant
**Impacts** :
- BDD: `INSERT INTO employes(user_id, type='chauffeur', salaire=270)`, coût salarial activé
- HT: 32 HT/jour (64 HT/jour si double équipage)
- €: -270 €/jour
- Effets: Chauffeur routier pour transport de marchandises. 32 HT/jour (64 si double équipage). Nécessite licence transport.

---

### ACTION: [FIN-102] Licencier employé
**Déclencheur** : Menu `Personnel` → fiche employé → bouton « Licencier »
**Prérequis** :
- Employé actuellement embauché
**Étapes** :
1. Aller dans le menu Personnel
2. Sélectionner l'employé à licencier
3. Cliquer « Licencier »
4. Confirmer le licenciement
**Validations serveur** :
- Vérifier que l'employé appartient au joueur
**Impacts** :
- BDD: `DELETE FROM employes WHERE id = X`
- HT: 0 HT
- €: 0 € (pas d'indemnité)
- Effets: Tout type d'employé. Effet immédiat. L'employé cesse de consommer des HT et du salaire dès le licenciement.

---

### ACTION: [TRA-102] Souscrire licence transport
**Déclencheur** : Menu `Transport` → bouton « Souscrire licence »
**Prérequis** :
- Aucune licence transport active
**Étapes** :
1. Aller dans le menu Transport
2. Choisir le type de licence : « Compte propre » OU « Compte d'autrui » (non cumulables)
3. Souscrire la licence (gratuite)
4. Licence active pendant 84 jours
**Validations serveur** :
- Vérifier aucune licence active
- Vérifier choix exclusif (propre OU autrui)
**Impacts** :
- BDD: `INSERT INTO licences_transport(user_id, type, date_fin = date + 84j)`
- HT: 0 HT
- €: 0 € (gratuite)
- Effets: Compte propre = transporter ses propres marchandises. Compte d'autrui = transporter pour d'autres joueurs. Non cumulables. Durée 84 jours, renouvelable.

---

### VITICULTURE / MARCHÉ (3 actions)

---

### ACTION: [VIT-101] Concours Viticole
**Déclencheur** : Menu `Viticulture` → bouton « Inscrire au concours Concours Viticole »
**Prérequis** :
- Vin produit et en stock
- Période : Septembre
**Étapes** :
1. Aller dans le menu Viticulture
2. Sélectionner le vin à présenter
3. Inscrire au concours Concours Viticole (Septembre)
4. Attendre les résultats
**Validations serveur** :
- Vérifier stock vin disponible
- Vérifier période = Septembre
**Impacts** :
- BDD: `INSERT INTO concours_vitisim(user_id, vin_id, date)`, si primé : `vin.prime = true`, `vin.prime_expiration = date + 84j`
- HT: 0 HT
- €: Frais d'inscription
- Effets: Si le vin est primé → valorisation du prix de vente pendant 84 jours. Prestige pour l'exploitation.

---

### ACTION: [FRO-106] Vendre crème
**Déclencheur** : Menu `Marchés` → bouton « Vendre crème »
**Prérequis** :
- Stock de crème disponible
- DLC non dépassée (7 jours)
- Place disponible sur un marché
**Étapes** :
1. Aller sur un marché
2. Sélectionner « Vendre crème »
3. Choisir la quantité
4. Mettre en vente
**Validations serveur** :
- Vérifier stock crème > 0
- Vérifier DLC ≤ 7 jours
- Vérifier place marché disponible
**Impacts** :
- BDD: `stock.creme -= quantité`, `joueur.solde += prix_vente`
- HT: Variable (temps de marché)
- €: Revenus de la vente
- Effets: Crème vendue sur les marchés. DLC 7 jours. Produit périssable, à vendre rapidement après fabrication.

---

### ACTION: [FRO-107] Vendre beurre
**Déclencheur** : Menu `Marchés` → bouton « Vendre beurre »
**Prérequis** :
- Stock de beurre disponible
- DLC non dépassée (18 jours)
- Place disponible sur un marché
**Étapes** :
1. Aller sur un marché
2. Sélectionner « Vendre beurre »
3. Choisir la quantité
4. Mettre en vente
**Validations serveur** :
- Vérifier stock beurre > 0
- Vérifier DLC ≤ 18 jours
- Vérifier place marché disponible
**Impacts** :
- BDD: `stock.beurre -= quantité`, `joueur.solde += prix_vente`
- HT: Variable (temps de marché)
- €: Revenus de la vente
- Effets: Beurre vendu sur les marchés. DLC 18 jours. Issu de la transformation de crème en fromagerie.

---

### MARAÎCHAGE DÉTAILLÉ (4 actions)

---

### ACTION: [MAR-102] Chauffer serre
**Déclencheur** : Onglet `Maraîchage` → serre → bouton « Chauffer »
**Prérequis** :
- Serre construite avec option chauffage
- Chaufferie HVC ou chaudière polycombustible installée
- Combustible disponible (HVC ou miscanthus)
**Étapes** :
1. Sélectionner la serre à chauffer
2. Choisir la source de chaleur (chaufferie HVC ou chaudière polycombustible)
3. Régler la température cible (optimale selon la culture)
4. Activer le chauffage
**Validations serveur** :
- Vérifier serre avec option chauffage
- Vérifier chaufferie/chaudière installée
- Vérifier stock combustible suffisant
**Impacts** :
- BDD: `serre.chauffage_actif = true`, `serre.temperature = T`, `stock.combustible -= consommation`
- HT: 0 HT (automatique)
- €: Coût du combustible consommé
- Effets: Température optimale par culture. Chaudière polycombustible : miscanthus 1 kg = 5 KW. Indispensable en hiver pour certaines cultures.

---

### ACTION: [MAR-103] Acheter plateau polystyrène
**Déclencheur** : Menu `Coopérative` → rayon matériel → bouton « Acheter plateaux polystyrène »
**Prérequis** :
- Solde € suffisant
**Étapes** :
1. Aller à la coopérative
2. Sélectionner « Plateaux polystyrène »
3. Choisir la quantité
4. Acheter
**Validations serveur** :
- Vérifier solde suffisant
**Impacts** :
- BDD: `stock.plateaux_polystyrene += quantité`, `joueur.solde -= coût`
- HT: 0 HT
- €: Prix unitaire × quantité
- Effets: Nécessaire pour semis tabac (200 plateaux) et semis maraîchage sous serre. Consommable réutilisable.

---

### ACTION: [MAR-104] Acheter bac maraîchage
**Déclencheur** : Menu `Coopérative` → rayon matériel → bouton « Acheter bacs maraîchage »
**Prérequis** :
- Solde € suffisant
**Étapes** :
1. Aller à la coopérative
2. Sélectionner « Bacs maraîchage »
3. Choisir la quantité (en m²)
4. Acheter
**Validations serveur** :
- Vérifier solde suffisant
**Impacts** :
- BDD: `stock.bacs_maraichage += quantité_m2`, `joueur.solde -= coût`
- HT: 0 HT
- €: Prix au m²
- Effets: Nécessaire pour semis sous serre (tabac : 50 m² de bacs). Installés dans la serre pour accueillir les plateaux.

---

### ACTION: [MAR-105] Acheter bâche plastique
**Déclencheur** : Menu `Coopérative` → rayon matériel → bouton « Acheter bâche plastique »
**Prérequis** :
- Solde € suffisant
**Étapes** :
1. Aller à la coopérative
2. Sélectionner « Bâche plastique »
3. Choisir la surface (en m²)
4. Acheter
**Validations serveur** :
- Vérifier solde suffisant
**Impacts** :
- BDD: `stock.bache_plastique += quantité_m2`, `joueur.solde -= coût`
- HT: 0 HT
- €: Prix au m²
- Effets: Nécessaire pour la culture du tabac (100 m² de bâche). Protège les semis sous serre.

---

### FOIE GRAS (1 action)

---

### ACTION: [FOI-101] Vendre foie gras
**Déclencheur** : Menu `Marchés` → bouton « Vendre foie gras »
**Prérequis** :
- Stock de foie gras disponible (sous vide, mi-cuit conserve, ou conserve)
- Place disponible sur un marché
**Étapes** :
1. Aller sur un marché
2. Sélectionner « Vendre foie gras »
3. Choisir le format : sous vide, mi-cuit conserve, ou conserve
4. Choisir la quantité (max 10 kg/marché en fin d'année, 1 kg sinon)
5. Mettre en vente
**Validations serveur** :
- Vérifier stock foie gras > 0
- Vérifier DLC non dépassée selon format
- Vérifier quantité ≤ limite (10 kg fin d'année, 1 kg sinon)
- Vérifier place marché disponible
**Impacts** :
- BDD: `stock.foie_gras -= quantité`, `joueur.solde += prix_vente`
- HT: Variable (temps de marché)
- €: Sous vide : 82.50 €/kg (DLC 5j) | Mi-cuit conserve : 95 €/kg (DLC 42j) | Conserve : 102.50 €/kg (DLC 252j)
- Effets: Vente sur marchés uniquement. 3 formats avec DLC et prix différents. Quota : 10 kg/marché en fin d'année, 1 kg sinon.

---

### UI / CONSULTATION (8 actions)

---

### ACTION: [SOC-110] Événements in-game (activer/désactiver)
**Déclencheur** : Dashboard → section événements → toggle on/off
**Prérequis** :
- Aucun
**Étapes** :
1. Aller sur le dashboard
2. Trouver la section « Événements »
3. Activer ou désactiver le toggle
**Validations serveur** :
- Aucune validation spécifique
**Impacts** :
- BDD: `joueur.evenements_actifs = true | false`
- HT: 0 HT
- €: 0 €
- Effets: Active ou désactive les notifications d'événements in-game. Permet de filtrer les alertes selon les préférences du joueur.

---

### ACTION: [SOC-111] Consulter météo/prévisions
**Déclencheur** : Header → icône météo → clic
**Prérequis** :
- Aucun
**Étapes** :
1. Cliquer sur l'icône météo dans le header
2. Consulter la météo actuelle du département
3. Consulter les prévisions à 2 jours
**Validations serveur** :
- Aucune validation spécifique
**Impacts** :
- BDD: Aucun impact (lecture seule)
- HT: 0 HT
- €: 0 €
- Effets: Prévisions à 2 jours par département. Influence les décisions de semis, récolte, traitements. La météo affecte la pousse et les rendements.

---

### ACTION: [SOC-112] Consulter fiche joueur
**Déclencheur** : Clic sur le nom d'un joueur (classement, marché, voisinage)
**Prérequis** :
- Aucun
**Étapes** :
1. Cliquer sur le nom d'un joueur
2. Popup avec les informations de l'exploitation
3. Consulter : cheptel, surfaces, classements, département
**Validations serveur** :
- Aucune validation spécifique
**Impacts** :
- BDD: Aucun impact (lecture seule)
- HT: 0 HT
- €: 0 €
- Effets: Permet de consulter les informations publiques d'un autre joueur. Utile pour le commerce et la coopération.

---

### ACTION: [SOC-113] Déclarer disponibilités
**Déclencheur** : Menu `Profil` → bouton « Déclarer disponibilités »
**Prérequis** :
- Aucun
**Étapes** :
1. Aller dans le profil
2. Cliquer « Déclarer disponibilités »
3. Indiquer ses créneaux de jeu (jours/heures)
4. Valider
**Validations serveur** :
- Aucune validation spécifique
**Impacts** :
- BDD: `joueur.disponibilites = créneaux`
- HT: 0 HT
- €: 0 €
- Effets: Informe les autres joueurs de vos créneaux de jeu. Facilite la coordination pour le commerce et les coopératives.

---

### ACTION: [MAR-106] Acheter terrain maraîcher
**Déclencheur** : Menu `Maraîchage` → bouton « Acheter terrain »
**Prérequis** :
- Solde € suffisant
- Même département que l'exploitation
**Étapes** :
1. Aller dans le menu Maraîchage
2. Cliquer « Acheter terrain »
3. Choisir la surface (500 à 10 000 m²)
4. Acheter (0.30 €/m² en France)
**Validations serveur** :
- Vérifier solde ≥ surface × 0.30 €
- Vérifier même département que l'exploitation
- Vérifier surface entre 500 et 10 000 m²
**Impacts** :
- BDD: `INSERT INTO terrains_maraichers(user_id, surface, departement)`, `joueur.solde -= surface × 0.30`
- HT: 0 HT
- €: 0.30 €/m² (France)
- Effets: Terrain dédié au maraîchage. Même département obligatoire. Surface 500-10 000 m². Peut accueillir serre ou tunnel.

---

### ACTION: [MAR-107] Construire serre
**Déclencheur** : Menu `Maraîchage` → terrain maraîcher → bouton « Construire serre »
**Prérequis** :
- Terrain maraîcher disponible (vide)
- Solde € suffisant
**Étapes** :
1. Sélectionner le terrain maraîcher
2. Choisir le type de serre : plastique ou verre
3. Option : ajouter le chauffage
4. Construire (occupe toute la parcelle maraîchère)
**Validations serveur** :
- Vérifier terrain vide
- Vérifier solde suffisant
**Impacts** :
- BDD: `INSERT INTO serres(terrain_id, type, chauffage)`, `joueur.solde -= coût_construction`
- HT: 0 HT (construction par entreprise)
- €: Variable selon type (plastique < verre) et option chauffage
- Effets: Serre plastique ou verre. Option chauffage pour cultures hors saison. Occupe toute la parcelle maraîchère. Serre vitrée nécessaire pour tabac.

---

### ACTION: [MAR-108] Construire tunnel
**Déclencheur** : Menu `Maraîchage` → terrain maraîcher → bouton « Construire tunnel »
**Prérequis** :
- Terrain maraîcher disponible (vide)
- Solde € suffisant
**Étapes** :
1. Sélectionner le terrain maraîcher
2. Choisir « Tunnel plastique »
3. Construire (occupe toute la parcelle maraîchère)
**Validations serveur** :
- Vérifier terrain vide
- Vérifier solde suffisant
**Impacts** :
- BDD: `INSERT INTO tunnels(terrain_id)`, `joueur.solde -= coût_construction`
- HT: 0 HT (construction par entreprise)
- €: Coût de construction (moins cher que serre)
- Effets: Tunnel plastique. Occupe toute la parcelle maraîchère. Moins cher que la serre mais pas d'option chauffage. Protection contre intempéries.

---

### ACTION: [CUL-122] Récolter spécifique (épinard/haricot)
**Déclencheur** : Onglet `Maraîchage` → culture mature → bouton « Récolter »
**Prérequis** :
- Culture à maturité : épinard ou haricot vert
- Machine spécifique : récolteuse épinard OU récolteuse haricot
**Étapes** :
1. Sélectionner la parcelle maraîchère avec culture mature
2. Choisir la machine spécifique (récolteuse épinard ou récolteuse haricot)
3. Lancer la récolte
**Validations serveur** :
- Vérifier culture à maturité
- Vérifier possession machine spécifique (récolteuse épinard pour épinard, récolteuse haricot pour haricot)
**Impacts** :
- BDD: `parcelle.culture = null`, `stock.legume += rendement`, `joueur.ht -= coût_ht`
- HT: Variable selon surface
- €: 0 €
- Effets: Machines spécifiques non interchangeables. Récolteuse épinard uniquement pour épinard. Récolteuse haricot uniquement pour haricot vert.


## 25. DEEP SEARCH — ACTIONS MANQUANTES (Pass 3+4)

> 7 actions découvertes par croisement des boutons/JS des 225 pages scrapées.

---

### ACTION: [FIN-103] Rembourser prêt par anticipation
**Déclencheur** : Menu `Finance` → « Mes prêts » → bouton « Rembourser par anticipation »
**Prérequis** :
- Prêt en cours
- Solde € suffisant (capital restant dû + pénalité 3%)
**Étapes** :
1. Aller dans `Finance` → « Mes prêts »
2. Sélectionner le prêt à rembourser
3. Le système affiche : capital restant dû + pénalité 3%
4. Confirmer le remboursement anticipé
**Validations serveur** :
- Vérifier prêt actif
- Vérifier solde ≥ capital restant + 3% pénalité
**Impacts** :
- BDD: `DELETE FROM loans WHERE id = :id`, `joueur.solde -= (capital_restant * 1.03)`, `INSERT INTO transactions(...)`
- HT: 0 HT
- €: Capital restant dû + 3% de pénalité
- Effets: Le prêt est soldé immédiatement. Plus de mensualités. Libère la capacité d'emprunt pour un nouveau prêt.

---

### ACTION: [SOC-114] Acheter billet salon (Salon Génétique / Salon des Races Rares / Concours Viticole)
**Déclencheur** : Menu `Communauté` → « Salons » → bouton « Acheter un billet »
**Prérequis** :
- Salon en cours ou à venir
- Solde € suffisant (prix fixé par le CECA)
**Étapes** :
1. Consulter les salons disponibles (Salon Génétique, Salon des Races Rares, Concours Viticole)
2. Cliquer « Acheter un billet »
3. Payer le prix d'entrée
4. Accéder au salon (acheter/vendre animaux rares, présenter vins, concours)
**Validations serveur** :
- Vérifier salon actif
- Vérifier solde suffisant
- Vérifier pas déjà de billet pour ce salon
**Impacts** :
- BDD: `INSERT INTO salon_billets(user_id, salon_id)`, `joueur.solde -= prix_billet`
- HT: 0 HT
- €: Prix du billet (fixé par vote CECA)
- Effets: Donne accès au salon pour acheter/vendre des animaux de races rares (Salon des Races Rares), participer aux concours animaux (Salon Génétique), ou présenter ses vins (Concours Viticole).

---

### ACTION: [MAT-104] Déplacer matériel (groupé)
**Déclencheur** : Onglet `Matériel` → sélectionner plusieurs matériels (checkbox) → bouton « Déplacer »
**Prérequis** :
- Au moins 1 matériel sélectionné
- Bâtiment de destination avec place disponible
**Étapes** :
1. Cocher les matériels à déplacer dans la DataTable
2. Cliquer « Déplacer »
3. Popup : sélectionner le bâtiment de destination (hangar, entrepôt, etc.)
4. Confirmer
**Validations serveur** :
- Vérifier propriété des matériels
- Vérifier place disponible dans le bâtiment destination
**Impacts** :
- BDD: `UPDATE equipment SET building_id = :dest WHERE id IN (:ids)`
- HT: 0 HT (déplacement interne à la ferme)
- €: 0 €
- Effets: Matériel abrité = usure réduite. Matériel non abrité = usure plus rapide.

---

### ACTION: [CUL-123] Remettre parcelle en jachère
**Déclencheur** : Onglet `Parcelles` → sélectionner parcelle cultivée → bouton « Remettre en jachère »
**Prérequis** :
- Parcelle avec une culture en cours (pas encore récoltée)
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Remettre en jachère »
3. Confirmation : « La culture en cours sera perdue. Confirmer ? »
4. Confirmer
**Validations serveur** :
- Vérifier propriété de la parcelle
- Vérifier parcelle cultivée
**Impacts** :
- BDD: `UPDATE parcels SET current_crop = NULL, crop_growth_pct = 0, etat = 'jachère'`
- HT: 0 HT
- €: 0 € (mais perte de la culture et des semences investies)
- Effets: La culture est perdue. La parcelle redevient disponible pour un nouveau cycle. Utile si mauvaise culture semée par erreur ou si la météo est catastrophique.

---

### ACTION: [CUL-124] Activer/Stopper irrigation
**Déclencheur** : Onglet `Parcelles` → parcelle avec enrouleur ou pivot installé → bouton « Activer irrigation » / « Stopper irrigation »
**Prérequis** :
- Enrouleur installé dans la parcelle OU pivot central + rampes
- Source d'eau (forage, retenue collinaire, ou canalisation)
- Eau disponible dans la source
**Étapes** :
1. Sélectionner la parcelle
2. Cliquer « Activer irrigation » (ou « Stopper » si déjà active)
3. Pour le pivot : définir la durée d'arrosage (1-24h, 1h = 1mm = 10m³/ha)
4. Confirmer
**Validations serveur** :
- Vérifier équipement irrigation installé
- Vérifier source d'eau avec débit suffisant
- Vérifier eau disponible
**Impacts** :
- BDD: `UPDATE parcels SET irrigation_active = true/false, irrigation_duree = :heures`
- HT: ~0.5 HT pour activer
- €: 0 € (eau de la source)
- Effets: Chaque jour d'arrosage fait évoluer la jauge pluviométrie. Attention à ne pas inonder (trop d'eau = baisse rendement). Irrigation possible toute l'année.

---

### ACTION: [FIN-104] Vendre HT excédentaires
**Déclencheur** : Header → clic sur compteur HT → bouton « Vendre mes HT »
**Prérequis** :
- HT restants > 0
**Étapes** :
1. Cliquer sur le compteur HT dans le header
2. Cliquer « Vendre mes HT »
3. Choisir le nombre de HT à vendre (dropdown : de 1 à HT restants)
4. Confirmer la mise en vente
**Validations serveur** :
- Vérifier HT restants ≥ quantité à vendre
**Impacts** :
- BDD: `INSERT INTO market_ht(seller_id, quantity, price=10)`, `joueur.ht_remaining -= quantite`
- HT: -quantité vendue
- €: +10 €/HT vendu (quand un acheteur achète)
- Effets: Les HT sont mis en vente sur le marché régional. Un autre joueur peut les acheter à 10€/HT. Si personne n'achète, les HT sont perdus en fin de journée (reset quotidien).

---

### ACTION: [SOC-115] Accepter/Lire charte forum
**Déclencheur** : Menu `Communauté` → « Forums » → popup « Charte du forum »
**Prérequis** :
- Première visite sur les forums
**Étapes** :
1. Aller dans `Communauté` → « Forums »
2. Popup automatique : « Lire et accepter la charte »
3. Lire la charte
4. Cocher « J'accepte la charte »
5. Valider
**Validations serveur** :
- Vérifier que la charte n'a pas déjà été acceptée
**Impacts** :
- BDD: `UPDATE user_profiles SET charte_forum_acceptee = true`
- HT: 0 HT
- €: 0 €
- Effets: Obligatoire pour poster sur les forums. Une seule fois. Modérateurs veillent au respect.
