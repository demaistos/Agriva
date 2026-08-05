# Agriva — Spec Wireframes UI/UX V1
> Date : 2026-05-07 | Statut : référence V1 | Auteur : wireframes-ui

---

## Principes directeurs

- **Densité** : synthétique avec détails sur demande (décision figée). Peu de métriques en vue principale ; détails via clic/panneau latéral.
- **Normal/Expert** : bascule par système (preset global = profil). Expert ajoute colonnes et panneaux, ne remplace pas le normal.
- **Direction artistique** : gestion agricole contemporaine — structure moderne, densité assumée, patine légère (textures discrètes, ombres douces, relief léger). Ni flat design pur, ni skeuomorphisme lourd.
- **Palette** : neutre terreuse, accents verts profonds, bleu professionnel discret, états colorés lisibles (vert / ambre / rouge / bleu logistique).
- **Navigation principale** : barre latérale fixe — Hub · Exploitation · Planification · Marchés · Rapports · Territoire.
- **Bandeau supérieur persistant** : présent sur tous les écrans — Argent · Travail dispo · Météo · Alerte.

---

## 1. Hub Quotidien

### Layout

Grille 12 colonnes. Bandeau supérieur pleine largeur (hauteur fixe ~48px). Corps divisé en 3 colonnes :
- **Gauche (col 1–4)** : file de tâches rapide (3 prochaines tâches du jour)
- **Centre (col 5–9)** : carte synthétique des ateliers actifs
- **Droite (col 10–12)** : panneau alertes + météo détaillée du jour

### Widgets & composants

| Zone | Composant | Contenu Normal | Contenu Expert (ajouts) | État vide | État alerte |
|------|-----------|---------------|------------------------|-----------|-------------|
| Bandeau supérieur | Barre persistante | Argent · Travail dispo (h) · Météo (icône + °C) · Badge alerte | + Trésorerie J+7 · Charge hebdo (%) | — | Badge rouge clignotant si alerte critique |
| File tâches rapide | Liste 3 items | Nom tâche · Atelier · Faisabilité (●vert/●orange/●rouge) | + Durée estimée · Ressource critique | "Aucune tâche aujourd'hui" | Tâche ●rouge surlignée |
| Carte ateliers | Cards empilées | Nom atelier · État principal · 1 métrique clé | + Fertilité/humidité · Marge brute estimée | "Aucun atelier actif — Démarrer une culture" | Card avec bordure ambre/rouge selon criticité |
| Alertes | Liste badges | Alertes critiques uniquement (météo sévère, blocage) | + Risques proches (stock bas, fenêtre courte) | "Aucune alerte" (icône verte) | Liste rouge avec icône type alerte |
| Météo du jour | Widget compact | Icône condition · Temp min/max · Vent | + Prévision J+3 avec barre d'incertitude | — | Fond ambre/rouge si météo défavorable |

### Interactions principales

| Action joueur | Résultat | Transition |
|---------------|----------|------------|
| Clic badge alerte (bandeau) | Ouvre panneau détail alerte + action suggérée | Slide-in panneau droit |
| Clic tâche dans file rapide | Ouvre fiche tâche complète | Slide-in panneau droit |
| Clic card atelier | Navigue vers écran Exploitation, atelier sélectionné | Transition page |
| Clic météo | Ouvre prévision J+7 avec incertitude croissante | Modal léger |
| Clic "Voir toutes les tâches" | Navigue vers écran Planification | Transition page |

### Règles d'affichage

- **Normal** : bandeau 4 métriques, 3 tâches, cards ateliers (1 métrique clé), alertes critiques uniquement, météo icône+temp.
- **Expert** : + trésorerie J+7, + charge hebdo, + fertilité/humidité sur cards, + risques proches, + prévision J+3 avec incertitude.
- **Mobile** : bandeau réduit (argent + alerte uniquement), file tâches en pleine largeur, ateliers en carousel horizontal, météo collapsée.

---

## 2. Exploitation

### Layout

Grille 12 colonnes. Bandeau supérieur persistant. Corps :
- **Gauche (col 1–3)** : liste des ateliers/parcelles (nav secondaire)
- **Centre (col 4–9)** : vue principale de l'atelier sélectionné (parcelles/lots en grille ou liste)
- **Droite (col 10–12)** : panneau contextuel (détail parcelle/lot, rétractable)

### Widgets & composants

| Zone | Composant | Contenu Normal | Contenu Expert (ajouts) | État vide | État alerte |
|------|-----------|---------------|------------------------|-----------|-------------|
| Nav ateliers | Liste verticale | Nom atelier · Icône type · Statut global (●) | + Marge brute atelier · Charge travail | "Aucun atelier — Créer" | Atelier avec ● rouge si blocage |
| Vue parcelles/lots | Grille de cards | Nom/ID · Culture en cours · Stade phénologique · Prochaine tâche | + Rendement prévisionnel · Fertilité · Humidité | Card grisée "Parcelle vide" | Bordure rouge/ambre selon alerte |
| Panneau détail | Panneau latéral droit | Stade culture · Sol (fertilité + humidité 0–100) · Tâches associées | + NPK · MO · pH · Historique cultural · Compaction | "Sélectionner une parcelle" | Section sol en rouge si valeur critique |
| Barre d'actions | Boutons contextuels | Ajouter tâche · Voir planification | + Modifier sol · Historique complet | — | — |

### Interactions principales

| Action joueur | Résultat | Transition |
|---------------|----------|------------|
| Clic atelier (nav gauche) | Affiche les parcelles/lots de cet atelier en zone centrale | Mise à jour zone centrale |
| Clic card parcelle/lot | Ouvre panneau détail droit | Slide-in panneau droit |
| Clic "Ajouter tâche" | Ouvre formulaire ajout tâche pré-rempli (atelier + parcelle) | Modal ou panneau |
| Clic stade phénologique | Tooltip : description du stade + actions disponibles | Tooltip inline |
| Clic indicateur sol (expert) | Ouvre historique sol + recommandations rotation | Panneau détail étendu |

### Règles d'affichage

- **Normal** : nav ateliers (nom + statut), cards parcelles (culture, stade, prochaine tâche), panneau détail (fertilité + humidité), actions simples.
- **Expert** : + marge brute par atelier, + rendement prévisionnel sur cards, + NPK/MO/pH/historique/compaction dans panneau détail.
- **Mobile** : nav ateliers en onglets horizontaux, cards parcelles en liste verticale, panneau détail en modal plein écran.

---


## 3. Planification

### Layout

Grille 12 colonnes. Bandeau supérieur persistant. Corps :
- **Gauche (col 1–2)** : filtres rapides (atelier, semaine, statut faisabilité)
- **Centre (col 3–10)** : liste de tâches groupées par jour
- **Droite (col 11–12)** : barre de charge journalière (indicateur vertical)
- **Panneau détail** (col 9–12, slide-in) : détail tâche sélectionnée

### Widgets & composants

| Zone | Composant | Contenu Normal | Contenu Expert (ajouts) | État vide | État alerte |
|------|-----------|---------------|------------------------|-----------|-------------|
| Filtres | Sidebar compacte | Atelier (multi-select) · Semaine (nav J précédent/suivant) · Faisabilité (●/●/●) | + Filtre ressource · Filtre dépendance | — | — |
| Liste tâches | Tableau groupé par jour | Tâche · Atelier · Faisabilité (●) | + Durée · Ressources · Dépendances · % faisabilité chiffré | "Aucune tâche planifiée — Ajouter" | Ligne rouge si ●rouge ; ligne ambre si ●orange |
| Barre de charge | Indicateur vertical par jour | Barre remplie (travail requis / disponible) colorée vert/ambre/rouge | + Valeur chiffrée (h requis / h dispo) | Barre vide (grise) | Barre rouge si surcharge |
| Réservation prévisionnelle | Lignes grisées | Tâches futures réservées (grisées, icône "réservé") | + Date de réservation · Ressource pré-allouée | — | Réservation en conflit : bordure ambre |
| Panneau détail tâche | Panneau droit | Ressources requises · Fenêtre météo · Note libre | + Dépendances · % faisabilité · Actions avancées (suspendre, prioriser, dupliquer) | "Sélectionner une tâche" | Section ressource en rouge si manquante |

### Interactions principales

| Action joueur | Résultat | Transition |
|---------------|----------|------------|
| Clic tâche ●rouge | Ouvre panneau détail avec raison précise + suggestion (reporter, déléguer) | Slide-in panneau droit |
| Clic tâche ●orange | Ouvre panneau détail avec risque identifié (météo incertaine, travail limite) | Slide-in panneau droit |
| Déplacer tâche (sélecteur de jour) | Recalcul faisabilité en temps réel sur la nouvelle date | Mise à jour inline |
| Clic barre de charge rouge | Affiche liste des tâches excédentaires avec suggestions de report | Tooltip étendu |
| Clic "Ajouter tâche" | Ouvre formulaire création tâche | Modal |
| Clic tâche réservée future | Ouvre panneau détail avec option de modification | Slide-in panneau droit |

### Règles d'affichage

- **Normal** : colonnes Tâche · Atelier · Jour · Faisabilité (icône couleur), barre de charge colorée, réservations grisées.
- **Expert** : + colonnes Durée · Ressources · Dépendances · % faisabilité chiffré, + message explicite sur blocage (ex. "Travail insuffisant : 6h manquantes"), + actions avancées dans panneau détail.
- **Mobile** : filtres en drawer, liste tâches pleine largeur, barre de charge en bandeau horizontal sous les filtres, panneau détail en modal plein écran.

---

## 4. Marchés

### Layout

Grille 12 colonnes. Bandeau supérieur persistant. Corps :
- **Haut** : onglets Acheter · Vendre · Historique + barre de filtres
- **Gauche (col 1–8)** : liste d'annonces
- **Droite (col 9–12)** : panneau logistique + mes annonces actives

### Widgets & composants

| Zone | Composant | Contenu Normal | Contenu Expert (ajouts) | État vide | État alerte |
|------|-----------|---------------|------------------------|-----------|-------------|
| Onglets | Tabs | Acheter · Vendre · Historique | — | — | Badge sur onglet si annonce expirée |
| Filtres | Barre horizontale | Type de produit · Fourchette de prix (presets) · Quantité min | + Filière · Qualité · Vendeur · Délais personnalisés | — | — |
| Liste annonces | Tableau | Produit · Prix · Quantité · Origine (tag Bot/Joueur) · Délai livraison | + Qualité · Tag filière · Indicateur rendements décroissants | "Marché calme — le bot assure l'approvisionnement" | Annonce expirée grisée avec badge |
| Panneau logistique | Panneau droit | Coût transport estimé · Délai · Prestataire (bot ETA ou coop) | — | "Sélectionner une annonce" | Message erreur si logistique indisponible + alternative bot |
| Mes annonces | Liste compacte (panneau droit bas) | Annonces actives : produit · prix · statut | + Option renouvellement auto · Prix plancher/plafond | "Aucune annonce active" | Annonce expirée avec badge rouge |
| Formulaire annonce | Modal | Produit · Quantité · Prix · Délai | + Prix plancher/plafond · Renouvellement auto | — | — |

### Interactions principales

| Action joueur | Résultat | Transition |
|---------------|----------|------------|
| Clic annonce | Sélectionne l'annonce, affiche logistique dans panneau droit | Mise à jour panneau droit |
| Clic "Acheter / Vendre" sur annonce | Confirmation + toast + mise à jour argent dans bandeau | Toast + mise à jour bandeau |
| Clic tag "Bot" | Tooltip : "Prix bot = prix marché + spread 15–25%. Toujours disponible." | Tooltip inline |
| Clic annonce expirée | Panneau droit : options Renouveler ou Supprimer | Slide-in panneau droit |
| Clic onglet Historique | Affiche transactions passées (produit, prix, date, contrepartie) | Transition onglet |
| Clic métrique prix (expert) | Ouvre graphique historique 30 jours du produit | Modal graphique |

### Règles d'affichage

- **Normal** : colonnes Produit · Prix · Quantité · Origine · Délai, filtres simples (type + prix presets), logistique coût + délai, formulaire annonce simple.
- **Expert** : + colonnes Qualité · Tag filière · Indicateur rendements décroissants, + filtres avancés, + graphique historique prix 30 jours, + volume échangé, + options annonce avancées.
- **Mobile** : onglets en pleine largeur, filtres en drawer, liste annonces pleine largeur, panneau logistique en modal au clic "Acheter/Vendre".

---


## 5. Dashboards & Rapports

### Layout

Grille 12 colonnes. Bandeau supérieur persistant. Corps :
- **Haut** : onglets Exploitation · Économie (Économie visible en Expert uniquement)
- **Gauche (col 1–3)** : nav secondaire (période, atelier)
- **Centre (col 4–12)** : zone de métriques + graphiques

### Widgets & composants

| Zone | Composant | Contenu Normal | Contenu Expert (ajouts) | État vide | État alerte |
|------|-----------|---------------|------------------------|-----------|-------------|
| Onglets | Tabs | Exploitation | + Économie | — | — |
| Nav secondaire | Sélecteurs | Période (semaine / mois) · Atelier (tous / un) | + Comparaison N vs N-1 | — | — |
| Métriques clés | Cards 4 colonnes | CA semaine · Charges semaine · Marge brute · Travail utilisé/dispo | + Marge par atelier · Coût de production/unité · ROI investissements | "Données disponibles après 7 jours de jeu" | Métrique en rouge si valeur négative ou sous seuil |
| Graphique trésorerie | Courbe | Trésorerie 30 jours | + Prévision 30 jours · Dépenses catégorisées (barres empilées) | Graphique vide avec message | Ligne rouge si trésorerie < seuil |
| Historiques | Courbes | — | + Prix de vente · Rendements · Météo (30/90 jours) | — | — |
| Classements | Tableau compact | Rang joueur · Score · Activité dominante | + Détail score (revenu net 40% + marge 25% + diversif. 15% + ventes hors bot 20%) | "Classement disponible après 1 saison" | — |
| Succès | Liste badges | Jalons débloqués (cosmétiques) | — | "Aucun succès débloqué" | Badge "Nouveau succès" si débloqué récemment |
| Journal alertes | Liste | Alertes critiques résolues/en cours | + Journal complet (critiques + risques + opportunités) | "Aucune alerte" | Alerte en cours surlignée |

### Interactions principales

| Action joueur | Résultat | Transition |
|---------------|----------|------------|
| Clic métrique en rouge | Ouvre panneau détail avec composition et historique | Slide-in panneau droit |
| Clic onglet Économie (expert) | Affiche dashboard économie complet | Transition onglet |
| Clic graphique trésorerie | Zoom sur période + détail par catégorie | Modal graphique étendu |
| Clic rang classement | Détail score + comparaison top 3 | Modal |
| Clic badge succès | Description du succès + condition de déblocage | Tooltip ou modal |
| Changer période (semaine/mois) | Recalcul de toutes les métriques et graphiques | Mise à jour inline |

### Règles d'affichage

- **Normal** : onglet Exploitation uniquement, 4 métriques clés, courbe trésorerie 30 jours, classement rang + score, succès débloqués, alertes critiques.
- **Expert** : + onglet Économie, + métriques par atelier, + prévision trésorerie 30 jours, + historiques 90 jours + comparaison N/N-1, + journal complet, + détail score classement.
- **Mobile** : onglets en pleine largeur, métriques en 2 colonnes, graphiques scrollables horizontalement, classement et succès en accordéon.

---

## 6. Territoire & Foncier

### Layout

Grille 12 colonnes. Bandeau supérieur persistant. Corps :
- **Gauche (col 1–3)** : panneau filtres + liste parcelles disponibles
- **Centre (col 4–9)** : carte département (vue principale)
- **Droite (col 10–12)** : panneau détail parcelle sélectionnée + marché foncier

### Widgets & composants

| Zone | Composant | Contenu Normal | Contenu Expert (ajouts) | État vide | État alerte |
|------|-----------|---------------|------------------------|-----------|-------------|
| Filtres foncier | Sidebar | Type (achat/location) · Surface · Prix max | + Qualité sol · Région agroclimatique · Proximité exploitation | — | — |
| Liste parcelles dispo | Liste scrollable | Nom/ID · Surface · Prix · Type (achat/location) · Distance | + Qualité sol (fertilité) · Région | "Aucune parcelle disponible dans ce secteur" | Parcelle en alerte si offre expirante |
| Carte département | Carte abstraite | Parcelles colorées : ma propriété (vert foncé) · disponible (ambre) · indisponible (gris) | + Overlay qualité sol · Overlay région agroclimatique | Carte vide avec message "Aucune donnée territoriale" | Parcelle clignotante si offre expirante |
| Panneau détail parcelle | Panneau droit | Surface · Prix · Type · Distance · Statut | + Fertilité · Historique cultural · Région agroclimatique | "Sélectionner une parcelle" | Offre expirante : badge + compte à rebours |
| Marché foncier | Section panneau droit bas | Mes parcelles (achat/location en cours) · Bouton "Acheter / Louer" | + Coût fusion physique si regroupement bloc | "Aucune transaction en cours" | — |

### Interactions principales

| Action joueur | Résultat | Transition |
|---------------|----------|------------|
| Clic parcelle sur carte | Sélectionne la parcelle, affiche détail dans panneau droit | Mise à jour panneau droit |
| Clic parcelle dans liste | Même effet + centrage sur carte | Mise à jour carte + panneau |
| Clic "Acheter / Louer" | Confirmation avec récapitulatif (prix, impact trésorerie) | Modal confirmation |
| Confirmation achat/location | Parcelle passe en "ma propriété" (vert foncé) sur carte + mise à jour argent bandeau | Toast + mise à jour carte |
| Clic overlay qualité sol (expert) | Affiche gradient de fertilité sur toute la carte | Mise à jour overlay carte |
| Clic "Fusionner parcelles" (expert) | Affiche coût de fusion + confirmation | Modal confirmation |

### Règles d'affichage

- **Normal** : carte avec 3 états couleur (propriété / disponible / indisponible), liste parcelles (surface, prix, type, distance), panneau détail simple, bouton achat/location.
- **Expert** : + overlay qualité sol sur carte, + overlay région agroclimatique, + fertilité et historique dans panneau détail, + coût de fusion physique.
- **Mobile** : carte en pleine largeur (vue principale), liste parcelles en drawer bas, panneau détail en modal plein écran, filtres en drawer.

---


## 7. Workflows Quotidiens

### Jour Normal

Séquence type d'une session quotidienne sans événement critique.

```
1. Hub Quotidien
   → Lire bandeau (argent, travail dispo, météo, alertes)
   → Vérifier file de tâches rapide (3 prochaines)
   → [Si alerte ●orange] → aller en Planification

2. Planification (si ajustement nécessaire)
   → Identifier tâche ●orange ou surcharge
   → Reporter ou réorganiser via sélecteur de jour
   → Vérifier barre de charge (vert = OK)

3. Marchés (optionnel, ~2 min)
   → Onglet Vendre : vérifier si stock à écouler
   → Onglet Acheter : vérifier intrants nécessaires
   → Passer commande si besoin

4. Retour Hub ou Exploitation
   → Confirmer que la file du jour est propre (tout ●vert)
   → Fin de session
```

**Durée estimée** : 5–10 min. Aucun écran expert requis.

---

### Jour Crise

Déclencheur : alerte critique (badge rouge dans bandeau) — météo sévère, effondrement de prix, panne, stock critique.

```
1. Badge alerte rouge (bandeau, tout écran)
   → Clic → Panneau diagnostic :
     - Type de crise (météo / prix / stock / panne)
     - Impact estimé (tâches bloquées, pertes potentielles)
     - Action suggérée

2. Planification
   → Tâches impactées surlignées ●rouge automatiquement
   → Reporter les tâches bloquées (sélecteur de jour)
   → Suspendre les tâches non urgentes (mode expert)
   → Vérifier barre de charge sur les jours de report

3. Marchés (si crise prix ou stock)
   → Vendre stocks menacés avant aggravation (crise météo)
   → Acheter intrants si rupture imminente
   → Bot disponible comme filet de sécurité

4. [Optionnel] Rapports
   → Vérifier impact sur marge brute
   → Évaluer si investissement prévu doit être reporté

5. Hub Quotidien
   → Vérifier que l'alerte est résolue ou en cours de résolution
   → Badge alerte passe en ●ambre (risque résiduel) ou disparaît
```

**Durée estimée** : 10–20 min selon gravité.

---

### Jour Investissement

Déclencheur : joueur identifie une opportunité ou atteint un seuil de trésorerie.

```
1. Rapports — onglet Exploitation
   → Vérifier marge brute et trésorerie disponible
   → Identifier atelier sous-performant ou opportunité de croissance
   → [Expert] Consulter ROI investissements passés

2. Exploitation
   → Consulter capacité travail actuelle (bandeau : travail dispo)
   → Vérifier capacité de stockage (panneau détail atelier)

3. Territoire & Foncier (si agrandissement)
   → Identifier parcelle disponible sur carte
   → Vérifier prix + impact trésorerie dans panneau détail
   → [Expert] Vérifier qualité sol et région agroclimatique

4. Marchés (si achat équipement ou intrants)
   → Vérifier prix des intrants / équipements
   → Comparer bot vs joueur

5. Décision & Confirmation
   → Modal de confirmation : récapitulatif (coût, impact trésorerie, nouvelles tâches générées)
   → Confirmer → mise à jour bandeau (argent) + nouvelles tâches dans Planification

6. Planification
   → Vérifier les nouvelles tâches générées automatiquement
   → Ajuster la file si surcharge détectée
```

**Durée estimée** : 15–30 min. Mode expert recommandé mais non requis.

---

## 8. Récapitulatif Normal vs Expert par Écran

| Écran | Normal (visible) | Expert (ajouts) |
|-------|-----------------|-----------------|
| **Hub Quotidien** | Argent · Travail · Météo · Alertes critiques · 3 tâches · Cards ateliers (1 métrique) | + Trésorerie J+7 · Charge hebdo · Fertilité/humidité sur cards · Risques proches · Prévision J+3 |
| **Exploitation** | Nav ateliers (nom + statut) · Cards parcelles (culture, stade, prochaine tâche) · Sol (fertilité + humidité) | + Marge brute atelier · Rendement prévisionnel · NPK/MO/pH/historique/compaction |
| **Planification** | Tâche · Atelier · Jour · Faisabilité (●) · Barre de charge colorée | + Durée · Ressources · Dépendances · % faisabilité chiffré · Message blocage explicite · Actions avancées |
| **Marchés** | Produit · Prix · Quantité · Origine · Délai · Filtres simples · Logistique coût+délai | + Qualité · Tag filière · Rendements décroissants · Filtres avancés · Historique prix 30j · Options annonce avancées |
| **Rapports** | Dashboard Exploitation · 4 métriques clés · Trésorerie 30j · Classement rang+score · Succès · Alertes critiques | + Dashboard Économie · Métriques par atelier · Prévision 30j · Historiques 90j · Comparaison N/N-1 · Journal complet · Détail score |
| **Territoire** | Carte 3 états · Liste parcelles (surface, prix, type, distance) · Panneau détail simple · Achat/location | + Overlay qualité sol · Overlay région agroclimatique · Fertilité + historique · Coût fusion physique |

**Règle fondamentale** : le mode normal doit permettre de jouer une session complète sans jamais avoir besoin du mode expert. Expert = profondeur, pas prérequis.

---

## 9. Bandeau Supérieur Persistant — Spécification

Présent sur tous les écrans, hauteur fixe ~48px, non scrollable.

| Slot | Contenu Normal | Contenu Expert (ajouts) | État alerte |
|------|---------------|------------------------|-------------|
| Argent | Solde disponible (€) | + Variation J (+ / −) | Rouge si < seuil critique |
| Travail dispo | Heures disponibles aujourd'hui | + % charge hebdo | Ambre si < 20% restant |
| Météo | Icône condition + temp max | + Icône J+1 (preview) | Ambre/rouge si météo défavorable |
| Alerte | Icône cloche (verte si aucune) | — | Badge rouge + nombre si alerte(s) critique(s) |

Clic sur chaque slot ouvre un panneau contextuel rapide (non bloquant, fermable par clic extérieur).

---

## Annexe — Éléments V2+

> Hors scope V1. Ne pas implémenter.

- Vue Gantt interactive multi-ateliers
- Filtres de marché sauvegardables
- Dashboard Territoire et Performance
- Prestataires joueurs (transport, insémination premium)
- Mode "basse charge mentale" dédié
- Personnalisation des widgets de tableau de bord
- Export des rapports
- Flux logistiques fins (traçabilité lot par lot)
- Viticulture, arboriculture, forêt
- Scénarios d'investissement comparatifs
- Overlay météo sur carte territoire
