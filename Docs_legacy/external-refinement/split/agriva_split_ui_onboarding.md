# Agriva — UI/UX & Onboarding
> Sections : 20, 25, 44-52

---

## 20. UI / UX

### 20.1 Ligne directrice
*(Voir aussi sections 44 à 52 pour le détail des écrans et interactions, et 74.7 pour les actions UI/UX.)*

L’interface doit être claire, synthétique et progressive.

### 20.2 Gestion des détails
Le joueur doit voir les conséquences d’abord, puis les détails à la demande.

### 20.3 Alertes
Elles doivent être hiérarchisées et utiles.

### 20.4 Question de densité

### 20.5 Recommandation V1 — Densité UI
- Option retenue pour la V1 : **B. Synthétique avec détails sur demande**.
- Justification : le joueur doit voir en permanence quelques indicateurs clés (argent, travail, météo, file de tâches, alertes critiques), et pouvoir dérouler les détails (parcelles, lots, indicateurs agronomiques, historiques) uniquement quand il en a besoin.
- Conséquences design :
  - les écrans principaux doivent comporter peu de colonnes/éléments par défaut et proposer des volets ou panneaux secondaires pour le détail ;
  - le mode expert ajoute des colonnes et vues supplémentaires mais ne doit pas surcharger le mode normal ;
  - la conception des dashboards (section 48) doit partir d’une vue synthétique, puis empiler les informations par couches.
- Exemple : l’écran d’exploitation montre d’abord les ateliers avec 3–5 métriques clés, les détails de chaque parcelle ou lot étant disponibles via un clic ou un panneau latéral.

- Choisir ici la densité d’information cible en V1 (A/B/C).
- Définir un exemple d’écran principal conforme à ce choix.

- A. Très synthétique.
- B. Synthétique avec détails sur demande.
- C. Personnalisable selon profil.

---


---

## 25. Onboarding

### 25.1 Principe
Le joueur doit apprendre progressivement, sans être submergé.

### 25.2 Outils
- tutoriel court ;
- conseils contextuels ;
- objectifs guidés ;
- modules expert proposés plus tard.

### 25.3 Question d’apprentissage
- A. Tutoriel court.
- B. Missions progressives.
- C. Bac à sable assisté + conseils contextuels.

### 25.4 Recommandation V1 — Onboarding
- Option retenue pour la V1 : **B. Missions progressives** enrichies de **conseils contextuels légers**.
- Justification :
  - un tutoriel unique et lourd serait rapidement rejeté ;
  - des missions progressives permettent de découvrir les systèmes dans le bon ordre, à son rythme ;
  - les conseils contextuels (bulle d’aide, surlignage, mini-checklist) rappellent les actions possibles sans bloquer le joueur.
- Conséquences design :
  - l’onboarding doit être pensé comme une série de “premiers parcours” (première culture, premier atelier élevage, première vente, premier investissement) ;
  - les modules experts ne sont proposés qu’après que le joueur a manipulé le système concerné en mode normal ;
  - le joueur doit pouvoir désactiver facilement certains éléments d’aide lorsqu’il se sent à l’aise.

- A. Tutoriel court.
- B. Missions progressives.
- C. Bac à sable assisté + conseils contextuels.

---


---

## 44. Interface, menus et écrans

### 44.1 Structure générale des menus
- A. Menu minimal (Accueil, Exploitation, Marché, Carte, Paramètres).
- B. Menu par grands blocs (Exploitation, Activités, Marchés, Territoire, Rapports, Paramètres).
- C. Menu plus fin avec sous-sections explicites par système.

### 44.2 Accès au mode normal / expert
- A. Commutateur global unique.
- B. Commutateur par écran / système.
- C. Commutateur global + réglages fins par système et activité.

### 44.3 Navigation principale
- A. Barre latérale fixe.
- B. Barre horizontale + sous-onglets.
- C. Tableau de bord d’accueil avec accès rapide aux blocs.

## 45. Écran principal d’exploitation

### 45.1 Informations visibles en permanence
- A. Argent, travail disponible, météo du jour, file de tâches.
- B. Argent, travail, météo, file de tâches, alertes critiques.
- C. Argent, travail, météo, file de tâches, alertes, indicateurs clés personnalisables.

### 45.2 Vue de l’exploitation
- A. Vue textuelle synthétique par ateliers et parcelles.
- B. Vue en liste avec filtres (par atelier, par parcelle, par filière).
- C. Vue tableau de bord combinant synthèse + accès rapide aux détails.

### 45.3 Actions principales accessibles
- A. Ajouter une tâche, consulter la météo, vendre/acheter.
- B. Ajouter tâche, réorganiser file, consulter météo, vendre/acheter, voir alertes.
- C. Ajouter tâche, gérer files, consulter météo, gérer marchés, appeler des prestataires, consulter rapports.

## 46. Écran de planification (file de tâches)

### 46.1 Représentation de la file
- A. Liste simple triée par jour.
- B. Liste par jour avec regroupement par atelier.
- C. Timeline ou vue de planning (type Gantt simplifié).

### 46.2 Indicateurs de faisabilité
- A. Icônes vert/orange/rouge.
- B. Couleur + pourcentage de faisabilité.
- C. Couleur + pourcentage + message explicite.

### 46.3 Actions sur la file
- A. Déplacer, supprimer.
- B. Déplacer, suspendre, supprimer.
- C. Déplacer, suspendre, supprimer, prioriser, dupliquer.

### 46.4 Lecture normal / expert
- A. Normal : vue synthétique, Expert : vue détaillée.
- B. Normal : peu de colonnes, Expert : colonnes supplémentaires.
- C. Normal : résumé par atelier, Expert : détail par tâche et ressource.

## 47. Écran marchés (bot + joueur)

### 47.1 Organisation de l’écran marché
- A. Onglet Bot / Onglet Joueur.
- B. Onglet Achat / Onglet Vente, avec filtre bot/joueur.
- C. Onglet Produits / Onglet Contrats / Onglet Historique.

### 47.2 Informations par ligne de marché
- A. Produit, prix, quantité.
- B. Produit, prix, quantité, origine, délai.
- C. Produit, prix, quantité, origine, délai, qualité, réputation vendeur.

### 47.3 Filtres
- A. Type de produit + prix.
- B. Type + prix + localisation + quantité minimale.
- C. Ensemble complet de filtres (type, filière, qualité, localisation, vendeur, délais).

### 47.4 Interaction normal / expert
- A. Normal : accès direct au bot, Expert : outils avancés pour le marché joueur.
- B. Normal : interface simplifiée, Expert : ajout d’outils d’analyse.
- C. Normal : presets de filtres, Expert : filtres sur mesure et sauvegardables.

## 48. Tableaux de bord et rapports

### 48.1 Types de tableaux de bord
- A. Unique “Exploitation”.
- B. Exploitation + Économie.
- C. Exploitation + Économie + Territoire + Performance.

### 48.2 Fréquence d’usage prévue
- A. Hebdomadaire.
- B. Quotidienne.
- C. Dès que le joueur prend une décision majeure.

### 48.3 Niveau de détail
- A. Résumés simples.
- B. Résumés + quelques graphiques.
- C. Résumés + graphiques + détails exportables.

### 48.4 Normal / expert
- A. Normal : un tableau de bord basique, Expert : plusieurs.
- B. Normal : métriques limitées, Expert : plus de métriques.
- C. Normal : focus sur la santé de l’exploitation, Expert : analyse de performance fine.

## 49. Alertes et notifications

### 49.1 Rôle des alertes
- A. Signaler uniquement les blocages.
- B. Signaler blocages + risques proches.
- C. Signaler blocages, risques, opportunités.

### 49.2 Canal d’affichage
- A. Bandeau en haut.
- B. Icône de notifications + pop-ups rares.
- C. Centre de notifications avec filtres.

### 49.3 Priorisation
- A. Pas de priorisation.
- B. Couleurs par priorité.
- C. Couleurs + catégories (urgent, important, info).

### 49.4 Normal / expert
- A. Normal : peu d’alertes, Expert : plus d’alertes.
- B. Normal : alertes critiques seulement, Expert : alertes détaillées.
- C. Paramètres permettant au joueur de régler sa sensibilité.

## 50. Workflows quotidiens type

### 50.1 Workflow “jour normal”
- A. Ecran principal -> météo -> file -> marché.
- B. Ecran principal -> météo -> file -> marché -> rapports rapides.
- C. Ecran principal -> météo -> file -> marchés -> prestataires -> rapports.

### 50.2 Workflow “crise” (météo, prix, panne)
- A. Alerte -> file -> marché.
- B. Alerte -> diagnostic simple -> file -> marché.
- C. Alerte -> diagnostic détaillé -> recommandation -> file -> marché.

### 50.3 Workflow “investissement”
- A. Rapports -> marché -> décision.
- B. Rapports -> territoire -> marché -> décision.
- C. Rapports -> territoire -> scénarios -> marché -> décision.

## 51. Personnalisation et accessibilité

### 51.1 Personnalisation de l’interface
- A. Thème clair/sombre seulement.
- B. Thème + densité d’informations (compact / standard).
- C. Thème + densité + choix des widgets de tableau de bord.

### 51.2 Accessibilité
- A. Police et contrastes standard.
- B. Options de taille de police et contrastes renforcés.
- C. Options complètes (taille, contrastes, animations, couleurs daltonisme-friendly).

### 51.3 Mode “basse charge mentale”
- A. Inexistant.
- B. Quelques simplifications.
- C. Mode dédié qui réduit les alertes et l’information à l’essentiel.

---

## 52. Synthèse UI/UX pour l’équipe

Pour chaque écran ou flux clé (exploitation, planification, marchés, territoires, rapports) :
- définir les informations visibles en mode normal ;
- définir les informations supplémentaires en mode expert ;
- choisir A/B/C pour la structure de navigation ;
- choisir A/B/C pour la densité d’informations ;
- expliciter comment l’interface aide la décision plutôt que le clic.

L’objectif est de faire de l’UI/UX un **outil de décision agricole** et non un simple affichage de données.


---
