# CULTIVIA — Index des Actions
## Version 2.1 — Mis à jour le 2026-04-09

**324 actions** avec ID unique par catégorie.

> Changelog v2.1 :
> - +33 actions manquantes identifiées lors de l'audit
> - Re-catégorisation de ~32 actions mal placées
> - Nouvelle catégorie `ARB` (Arboriculture), `ETA` (Entreprise Travaux Agricoles)
> - Catégorie `CECA` séparée de SOC/VIT
> - Catégorie `CFCA` séparée
> - Toutes les actions regroupées proprement par catégorie (plus d'éparpillement)

### Convention
`{CAT}-{NNN}` — Utilisable dans commits (`feat(ELV-001):`), tickets, tests, code.

### Résumé par catégorie

| Préfixe | Catégorie | Nb |
|---------|-----------|----|
| `ELV` | Élevage | 52 |
| `CUL` | Cultures | 47 |
| `MAT` | Matériel | 19 |
| `BAT` | Bâtiments | 13 |
| `COM` | Commerce | 14 |
| `FIN` | Finance | 11 |
| `TRA` | Transport | 8 |
| `SOC` | Social | 24 |
| `CON` | Concessionnaire | 10 |
| `CIA` | CIA | 7 |
| `FRO` | Fromagerie | 12 |
| `MAR` | Maraîchage | 22 |
| `VIT` | Viticulture | 14 |
| `ARB` | Arboriculture | 6 |
| `FOR` | Forêts/ETF | 21 |
| `ETA` | ETA | 3 |
| `CAR` | CAR | 20 |
| `MET` | Méthanisation | 5 |
| `FOI` | Foie gras | 4 |
| `CECA` | CECA | 4 |
| `CFCA` | Formation CFCA | 3 |
| `ADM` | Administration compte | 5 |
| | **TOTAL** | **324** |

### Index complet

| ID | Action |
|-----|--------|
| | **— ÉLEVAGE (52) —** |
| `ELV-001` | Nourrir animaux (manuel) |
| `ELV-002` | Nourrir animaux (robot d'alimentation) |
| `ELV-003` | Abreuver (cuve à eau en bâtiment) |
| `ELV-004` | Abreuver (bac à eau au pré) |
| `ELV-005` | Pailler litière (pailleuse mécanique) |
| `ELV-006` | Pailler litière (manuel) |
| `ELV-007` | Retirer fumier |
| `ELV-008` | Retirer lisier |
| `ELV-009` | Traire |
| `ELV-010` | Collecter œufs |
| `ELV-011` | Tondre laine / Collecter duvet |
| `ELV-012` | Appeler vétérinaire |
| `ELV-013` | Vacciner |
| `ELV-014` | Mettre au pré (bétaillère) |
| `ELV-015` | Mettre au pré (chien de berger) |
| `ELV-016` | Rentrer au bâtiment |
| `ELV-017` | Acheter animal (coopérative Cultivia) |
| `ELV-018` | Acheter animal (marché régional/national) |
| `ELV-019` | Acheter animal (négociant) |
| `ELV-020` | Vendre animal (abattoir) |
| `ELV-021` | Vendre animal (marché privé — ami spécial) |
| `ELV-022` | Inséminer (artificielle — CIA joueur) |
| `ELV-023` | Inséminer (artificielle — Cultivia direct) |
| `ELV-024` | Inséminer (naturelle) |
| `ELV-025` | Activer allaitement (veau/agneau sous la mère) |
| `ELV-026` | Désactiver allaitement |
| `ELV-027` | Changer type élevage (conventionnel / bio) |
| `ELV-028` | Acheter chien de berger |
| `ELV-029` | Nommer un animal |
| `ELV-030` | Fusionner animaux *(ex CON-006)* |
| `ELV-031` | Défusionner animaux *(ex CON-007)* |
| `ELV-032` | Déplacer animal entre bâtiments *(ex CON-008)* |
| `ELV-033` | Remplir cuve à eau bâtiment *(ex CON-009)* |
| `ELV-034` | Remplir bac à eau au pré — tonne à eau *(ex CON-010)* |
| `ELV-035` | Appeler négociant *(ex CIA-010)* |
| `ELV-036` | Acheter nourriture animale *(ex FOI-005)* |
| `ELV-037` | Acheter concentré jeune *(ex ELV-110)* |
| `ELV-038` | Activer nourrissage automatique 15 jours *(ex ELV-101)* |
| `ELV-039` | Suivre/annoter un animal *(ex ELV-102)* |
| `ELV-040` | Ressusciter animal mort *(ex ELV-103)* |
| `ELV-041` | Retirer animal mort *(ex ELV-104)* |
| `ELV-042` | Remplir râtelier au pré *(ex ELV-105)* |
| `ELV-043` | Poser clôture bisons/daims *(ex ELV-106)* |
| `ELV-044` | Construire corral *(ex ELV-107)* |
| `ELV-045` | Préparer ration bison/daim *(ex ELV-108)* |
| `ELV-046` | Emmener ration au pré *(ex ELV-109)* |
| `ELV-047` | Purger fosse à lisier *(ex ELV-111)* |
| `ELV-048` | Choisir élevage litière vs caillebotis *(ex ELV-112)* |
| `ELV-049` | Présenter animal au Salon Génétique *(ex CUL-030)* |
| `ELV-050` | Acheter animal au salon Salon des Races Rares *(ex CUL-031)* |
| `ELV-051` | **Vendre animal sur marché régional/national** *(NOUVEAU)* |
| `ELV-052` | **Accepter/Refuser offre privée animal** *(NOUVEAU)* |
| | **— CULTURES (47) —** |
| `CUL-001` | Acheter parcelle |
| `CUL-002` | Louer parcelle |
| `CUL-003` | Déchaumer |
| `CUL-004` | Labourer |
| `CUL-005` | Préparer terre (herse rotative) |
| `CUL-006` | Semer (traditionnel) |
| `CUL-007` | Semer (TCS — Techniques Culturales Simplifiées) |
| `CUL-008` | Semer (direct) |
| `CUL-009` | Épandre engrais |
| `CUL-010` | Épandre fumier |
| `CUL-011` | Épandre lisier |
| `CUL-012` | Traiter (pulvérisateur) |
| `CUL-013` | Faucher |
| `CUL-014` | Faner |
| `CUL-015` | Andainer |
| `CUL-016` | Presser |
| `CUL-017` | Moissonner |
| `CUL-018` | Ensiler |
| `CUL-019` | Arracher (betterave / pomme de terre) |
| `CUL-020` | Irriguer (enrouleur) |
| `CUL-021` | Irriguer (pivot central) |
| `CUL-022` | Analyse de sol |
| `CUL-023` | Semer engrais vert CIPAN |
| `CUL-024` | Broyer engrais vert |
| `CUL-025` | Broyer paille |
| `CUL-026` | Broyer pierres |
| `CUL-027` | Épandre compost |
| `CUL-028` | Épandre écume de sucrerie |
| `CUL-029` | Épandre digestat |
| `CUL-030` | Convertir parcelle en bio *(ex MAR-006)* |
| `CUL-031` | Convertir parcelle en pré *(ex MAR-007)* |
| `CUL-032` | Faire du compostage à la ferme *(ex CUL-103)* |
| `CUL-033` | Construire retenue collinaire *(ex CUL-104)* |
| `CUL-034` | Ensilage d'herbe (ensileuse sur pré) *(ex CUL-105)* |
| `CUL-035` | Paille en vrac (autochargeuse) *(ex CUL-106)* |
| `CUL-036` | Mise en tas balles bord de parcelle *(ex CUL-107)* |
| `CUL-037` | Compostage en parcelle *(ex CUL-108)* |
| `CUL-038` | Binage (bineuse) *(ex CUL-109)* |
| `CUL-039` | Passer herse de prairie *(ex CUL-110)* |
| `CUL-040` | Ramasser balles *(ex CUL-111)* |
| `CUL-041` | Rouler parcelle *(ex CUL-112)* |
| `CUL-042` | Semer tabac sous serre *(ex CUL-113)* |
| `CUL-043` | Repiquer tabac en pleine terre *(ex CUL-114)* |
| `CUL-044` | Cultiver luzerne *(ex CUL-115)* |
| `CUL-045` | Semer chanvre industriel *(ex CUL-116)* |
| `CUL-046` | Récolter lin (3 étapes) *(ex CUL-117)* |
| `CUL-047` | Semer céréale immature *(ex CUL-118)* |
| | **— MATÉRIEL (19) —** |
| `MAT-001` | Acheter matériel neuf |
| `MAT-002` | Acheter matériel occasion |
| `MAT-003` | Vendre matériel |
| `MAT-004` | Entretenir matériel |
| `MAT-005` | Faire le plein HVC (carburant) |
| `MAT-006` | Installer GPS |
| `MAT-007` | Acheter matériel en commun |
| `MAT-008` | Acheter matériel de collection |
| `MAT-009` | Souscrire assurance matériel |
| `MAT-010` | Réparer matériel en panne |
| `MAT-011` | Changer pièce détachée |
| `MAT-012` | Entretenir matériel (atelier concessionnaire joueur) *(ex MAT-101)* |
| `MAT-013` | Vendre matériel à un concessionnaire *(ex MAT-102)* |
| `MAT-014` | Acheter matériel hors région *(ex MAT-103)* |
| `MAT-015` | Déplacer matériel (groupé) *(ex MAT-104)* |
| `MAT-016` | Installer relevage avant *(ex CAR-009)* |
| `MAT-017` | Acheter carburant HVC *(ex FOI-004)* |
| `MAT-018` | Négocier prix matériel *(ex FOI-006)* |
| `MAT-019` | **Acheter matériel aux enchères** *(NOUVEAU)* |
| | **— BÂTIMENTS (13) —** |
| `BAT-001` | Construire bâtiment |
| `BAT-002` | Agrandir bâtiment |
| `BAT-003` | Détruire bâtiment |
| `BAT-004` | Entretenir bâtiment |
| `BAT-005` | Construire accessoire |
| `BAT-006` | Acheter accessoire à la coopérative |
| `BAT-007` | Ferme 3D — Placer bâtiment |
| `BAT-008` | Ferme 3D — Supprimer élément |
| `BAT-009` | Ferme 3D — Rotation |
| `BAT-010` | Nommer sa ferme |
| `BAT-011` | Activer aire/silo de chargement *(ex BAT-101)* |
| `BAT-012` | Entretien bâtiment par entreprise extérieure *(ex BAT-102)* |
| `BAT-013` | Construire canalisation ferme↔parcelle *(ex CIA-006)* |
| | **— COMMERCE (14) —** |
| `COM-001` | Acheter à la coopérative |
| `COM-002` | Vendre à la coopérative |
| `COM-003` | Passer une annonce (vente marchandise) |
| `COM-004` | Répondre à un appel d'offres |
| `COM-005` | Amener plateau/fourgon à la coopérative |
| `COM-006` | Vendre lait *(ex CIA-007)* |
| `COM-007` | Vendre œufs *(ex CIA-008)* |
| `COM-008` | Vendre laine / duvet *(ex CIA-009)* |
| `COM-009` | Vendre récolte à la coopérative *(ex MAR-008)* |
| `COM-010` | Vendre récolte par annonce *(ex MAR-009)* |
| `COM-011` | Vendre lait à une laiterie joueur *(ex COM-101)* |
| `COM-012` | Signer contrat laiterie *(ex COM-102)* |
| `COM-013` | **Vendre matériel en privé (ami spécial)** *(NOUVEAU)* |
| `COM-014` | **Vendre parcelle** *(NOUVEAU)* |
| | **— FINANCE (11) —** |
| `FIN-001` | Demander un prêt |
| `FIN-002` | Ouvrir un compte épargne |
| `FIN-003` | Acheter HT (Heures de Travail) |
| `FIN-004` | Consulter historique bancaire |
| `FIN-005` | Vendre HT excédentaires *(ex FIN-104)* |
| `FIN-006` | Embaucher employé agricole *(ex FIN-101)* |
| `FIN-007` | Licencier employé *(ex FIN-102)* |
| `FIN-008` | Rembourser prêt par anticipation *(ex FIN-103)* |
| `FIN-009` | **Retirer/Clôturer épargne** *(NOUVEAU)* |
| `FIN-010` | **Acheter/Souscrire parts sociales CAR** *(ex CAR-102)* |
| `FIN-011` | **Emprunter (CAR)** *(ex CAR-103)* |
| | **— TRANSPORT (8) —** |
| `TRA-001` | Accepter une demande de transport |
| `TRA-002` | Charger camion |
| `TRA-003` | Livrer (décharger chez l'acheteur) |
| `TRA-004` | Embaucher chauffeur routier *(ex TRA-101)* |
| `TRA-005` | Souscrire licence transport *(ex TRA-102)* |
| `TRA-006` | **Créer demande de transport** *(NOUVEAU)* |
| `TRA-007` | **Souscrire licence MD (matières dangereuses)** *(NOUVEAU)* |
| `TRA-008` | **Gérer favoris transporteurs/clients** *(NOUVEAU)* |
| | **— SOCIAL (24) —** |
| `SOC-001` | Ajouter ami |
| `SOC-002` | Envoyer message (messagerie interne) |
| `SOC-003` | Envoyer MP-Live (messagerie instantanée) |
| `SOC-004` | Poster sur forum |
| `SOC-005` | Parrainer un ami |
| `SOC-006` | Activer garde de ferme |
| `SOC-007` | Garder ferme d'un joueur *(ex VIT-009)* |
| `SOC-008` | Visiter éleveur *(ex CUL-035)* |
| `SOC-009` | Ouvrir ferme aux visites *(ex CUL-036)* |
| `SOC-010` | Déménager (changer de commune) *(ex SOC-101)* |
| `SOC-011` | Ouvrir ferme annexe *(ex SOC-102)* |
| `SOC-012` | Participer à un challenge *(ex SOC-103)* |
| `SOC-013` | Participer à la loterie *(ex SOC-104)* |
| `SOC-014` | Gérer ses préférences *(ex SOC-105)* |
| `SOC-015` | Gérer ses filtres de notifications *(ex SOC-106)* |
| `SOC-016` | Ajouter/Gérer favoris *(ex SOC-107)* |
| `SOC-017` | Utiliser le bloc-notes *(ex SOC-108)* |
| `SOC-018` | Désinscription *(ex SOC-109)* |
| `SOC-019` | Événements in-game (activer/désactiver) *(ex SOC-110)* |
| `SOC-020` | Consulter météo/prévisions *(ex SOC-111)* |
| `SOC-021` | Consulter fiche joueur *(ex SOC-112)* |
| `SOC-022` | Déclarer disponibilités *(ex SOC-113)* |
| `SOC-023` | Acheter billet salon (Salon Génétique / Salon des Races Rares / Concours Viticole) *(ex SOC-114)* |
| `SOC-024` | Accepter/Lire charte forum *(ex SOC-115)* |
| | **— CONCESSIONNAIRE (10) —** |
| `CON-001` | Créer concession |
| `CON-002` | Acheter licence constructeur |
| `CON-003` | Embaucher vendeur / mécanicien |
| `CON-004` | Entretien atelier (matériel client) |
| `CON-005` | Dépôt-vente matériel |
| `CON-006` | **Vendre matériel neuf au client** *(NOUVEAU)* |
| `CON-007` | **Vendre pièces détachées** *(NOUVEAU)* |
| `CON-008` | **Louer tracteur (panne client)** *(NOUVEAU)* |
| `CON-009` | **Souscrire GPS client (souscription annuelle)** *(NOUVEAU)* |
| `CON-010` | Louer matériel *(ex CAR-010)* |
| | **— CIA (7) —** |
| `CIA-001` | Créer CIA |
| `CIA-002` | Contrat race CIA |
| `CIA-003` | Contrat animal CIA |
| `CIA-004` | Prélèvement semence |
| `CIA-005` | Insémination client CIA |
| `CIA-006` | Objectif génétique IVRAD *(ex CUL-032)* |
| `CIA-007` | Demander/Rendre animal IVRAD *(ex CUL-033 + CUL-034)* |
| | **— FROMAGERIE (12) —** |
| `FRO-001` | Créer fromagerie |
| `FRO-002` | Transformer lait en fromage |
| `FRO-003` | Affiner fromage |
| `FRO-004` | Vendre fromage au marché |
| `FRO-005` | Vendre fromage au grossiste |
| `FRO-006` | Transformer crème en beurre *(ex FRO-101)* |
| `FRO-007` | Nettoyer fromagerie *(ex FRO-102)* |
| `FRO-008` | Entretenir matériel fromagerie *(ex FRO-103)* |
| `FRO-009` | Former fromager *(ex FRO-104)* |
| `FRO-010` | Embaucher fromager *(ex FRO-105)* |
| `FRO-011` | Vendre crème *(ex FRO-106)* |
| `FRO-012` | Vendre beurre *(ex FRO-107)* |
| | **— MARAÎCHAGE (22) —** |
| `MAR-001` | Créer activité maraîchage |
| `MAR-002` | Semer / planter légume |
| `MAR-003` | Récolter légume |
| `MAR-004` | Emballer légume |
| `MAR-005` | Vendre légume au marché |
| `MAR-006` | Acheter semences *(ex MAR-010)* |
| `MAR-007` | Acheter engrais *(ex MAR-011)* |
| `MAR-008` | Acheter traitements phytosanitaires *(ex MAR-012)* |
| `MAR-009` | Embaucher ouvrier maraîchage *(ex MAR-101)* |
| `MAR-010` | Chauffer serre *(ex MAR-102)* |
| `MAR-011` | Acheter plateau polystyrène *(ex MAR-103)* |
| `MAR-012` | Acheter bac maraîchage *(ex MAR-104)* |
| `MAR-013` | Acheter bâche plastique *(ex MAR-105)* |
| `MAR-014` | Acheter terrain maraîcher *(ex MAR-106)* |
| `MAR-015` | Construire serre *(ex MAR-107)* |
| `MAR-016` | Construire tunnel *(ex MAR-108)* |
| `MAR-017` | Récolter spécifique (épinard/haricot) *(ex CUL-122)* |
| `MAR-018` | Défanage chimique pomme de terre *(ex VIT-014)* |
| `MAR-019` | Stocker PDT en ligne de stockage *(ex VIT-015)* |
| `MAR-020` | Vendre PDT via filière *(ex VIT-016)* |
| `MAR-021` | **Embaucher chef culture / chef équipe** *(NOUVEAU)* |
| `MAR-022` | **Traiter légume (serre/plein champ)** *(NOUVEAU)* |
| | **— VITICULTURE (14) —** |
| `VIT-001` | Acheter domaine viticole |
| `VIT-002` | Planter vigne |
| `VIT-003` | Tailler vigne |
| `VIT-004` | Vendanger |
| `VIT-005` | Vinifier |
| `VIT-006` | Assembler vin |
| `VIT-007` | Mettre en bouteille / fût |
| `VIT-008` | Vendre vin |
| `VIT-009` | Concours Viticole *(ex VIT-101)* |
| `VIT-010` | **Traiter vigne** *(NOUVEAU)* |
| `VIT-011` | **Embaucher agent viticole / maître de chai** *(NOUVEAU)* |
| `VIT-012` | **Embaucher vendangeur (saisonnier)** *(NOUVEAU)* |
| `VIT-013` | **Embaucher vendeur caviste** *(NOUVEAU)* |
| `VIT-014` | **Élever vin en fût (vieillissement)** *(NOUVEAU)* |
| | **— ARBORICULTURE (6) —** |
| `ARB-001` | Planter arbres *(ex VIT-017)* |
| `ARB-002` | Tailler arbres *(ex VIT-018)* |
| `ARB-003` | Éclaircir arbres *(ex VIT-019)* |
| `ARB-004` | Récolter fruits (manuel) *(ex VIT-020)* |
| `ARB-005` | Installer filet anti-grêle *(ex VIT-021)* |
| `ARB-006` | **Traiter arbres fruitiers** *(NOUVEAU)* |
| | **— FORÊTS/ETF (21) —** |
| `FOR-001` | Acheter forêt |
| `FOR-002` | Planter arbres forestiers |
| `FOR-003` | Élaguer |
| `FOR-004` | Éclaircie forestière |
| `FOR-005` | Coupe finale |
| `FOR-006` | Vendre bois |
| `FOR-007` | Planter haie |
| `FOR-008` | Tailler haie |
| `FOR-009` | Déchiqueter bois de haie |
| `FOR-010` | Regrouper parcelles |
| `FOR-011` | Vendre parcelle forestière |
| `FOR-012` | Taille de formation *(ex FOR-101)* |
| `FOR-013` | Traitement phytosanitaire forêt *(ex FOR-102)* |
| `FOR-014` | Marquage de coupe *(ex FOR-103)* |
| `FOR-015` | Entretien piste forestière *(ex FOR-104)* |
| `FOR-016` | Entretien route forestière *(ex FOR-105)* |
| `FOR-017` | Entretien place de dépôt *(ex FOR-106)* |
| `FOR-018` | Fertilisation forêt *(ex FOR-107)* |
| `FOR-019` | Labour forêt *(ex FOR-108)* |
| `FOR-020` | **Broyage souche** *(NOUVEAU)* |
| `FOR-021` | **Créer ETF / Prestation chez autre joueur** *(NOUVEAU)* |
| | **— ETA (3) —** |
| `ETA-001` | Créer ETA *(ex CUL-102)* |
| `ETA-002` | Appeler une ETA (joueur) *(ex CUL-101)* |
| `ETA-003` | **Répondre à une commande ETA** *(NOUVEAU)* |
| | **— CAR (20) —** |
| `CAR-001` | Créer CAR |
| `CAR-002` | Rejoindre CAR |
| `CAR-003` | Construire huilerie |
| `CAR-004` | Transformer colza/tournesol en HVC |
| `CAR-005` | Construire sucrerie |
| `CAR-006` | Transformer betterave en sucre |
| `CAR-007` | Construire laiterie |
| `CAR-008` | Construire magasin libre-service |
| `CAR-009` | Mettre matériel en location *(ex CAR-011)* |
| `CAR-010` | Mettre matériel à la casse *(ex CAR-012)* |
| `CAR-011` | Appels d'offres CAR *(ex CAR-101)* |
| `CAR-012` | Contrat parcelle CAR *(ex FOI-007)* |
| `CAR-013` | Acheter/vendre entre CAR *(ex FOI-008)* |
| `CAR-014` | Acheter parcelle via Partcel *(ex CUL-119)* |
| `CAR-015` | Louer parcelle via Partcel *(ex CUL-120)* |
| `CAR-016` | Racheter parcelle en location *(ex CUL-121)* |
| `CAR-017` | Remettre parcelle en jachère *(ex CUL-123)* |
| `CAR-018` | **Transformer lait (yaourt/UHT/pasteurisé/poudre)** *(NOUVEAU)* |
| `CAR-019` | **Gérer magasin libre-service** *(NOUVEAU)* |
| `CAR-020` | **Quitter CAR** *(NOUVEAU)* |
| | **— MÉTHANISATION (5) —** |
| `MET-001` | Construire digesteur |
| `MET-002` | Alimenter digesteur |
| `MET-003` | Vidanger digesteur |
| `MET-004` | Produire électricité |
| `MET-005` | Produire HVC (méthanisation) |
| | **— FOIE GRAS (4) —** |
| `FOI-001` | Placer animal en filière foie gras |
| `FOI-002` | Gaver |
| `FOI-003` | Abattre et transformer foie gras |
| `FOI-004` | Vendre foie gras *(ex FOI-101)* |
| | **— CECA (4) —** |
| `CECA-001` | Se porter candidat CECA *(ex VIT-013)* |
| `CECA-002` | Voter CECA *(ex VIT-011)* |
| `CECA-003` | Proposer vote CECA (représentant élu) *(ex VIT-012)* |
| `CECA-004` | **Consulter résultats CECA** *(NOUVEAU)* |
| | **— FORMATION CFCA (3) —** |
| `CFCA-001` | S'inscrire formation CFCA *(ex VIT-010)* |
| `CFCA-002` | **Accepter stagiaire (maître-exploitant)** *(NOUVEAU)* |
| `CFCA-003` | **Terminer formation CFCA** *(NOUVEAU)* |
| | **— ADMINISTRATION COMPTE (5) —** |
| `ADM-001` | **Créer compte / S'inscrire** *(NOUVEAU)* |
| `ADM-002` | **Modifier profil / avatar** *(NOUVEAU)* |
| `ADM-003` | **Changer mot de passe** *(NOUVEAU)* |
| `ADM-004` | **Configurer ferme initiale (accueil nouveau joueur)** *(NOUVEAU)* |
| `ADM-005` | Désinscription *(ex SOC-109)* |
