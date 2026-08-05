# Agriva — Spec UI/UX & Onboarding V1
> Date : 2026-05-07 | Statut : référence V1 | Densité : synthétique avec détails sur demande

---

## Principes directeurs

- **Densité retenue** : B — Synthétique avec détails sur demande. Peu de métriques en vue principale ; détails via clic/panneau latéral.
- **Normal/Expert** : bascule par système (preset global = profil). Expert ajoute des colonnes et vues, ne remplace pas le normal.
- **L'UI est un outil de décision**, pas un affichage de données. Chaque écran répond à la question : *que dois-je faire maintenant ?*
- **Navigation principale** : barre latérale fixe — Exploitation · Planification · Marchés · Rapports · Paramètres.

---

## 1. Écran principal — Exploitation

### Sections & widgets

| Zone | Contenu |
|------|---------|
| **Bandeau supérieur** | Argent disponible · Travail dispo (h) · Météo du jour (icône + temp) · Alerte critique (badge rouge si présente) |
| **File de tâches rapide** | 3 prochaines tâches du jour avec statut faisabilité (●vert ●orange ●rouge) |
| **Ateliers** | Carte synthétique par atelier (Grandes cultures / Élevage / Maraîchage) : nom, état principal, 1 métrique clé |
| **Panneau latéral (clic)** | Détail parcelle ou lot : stade, sol (fertilité + humidité), tâches associées |

### Mode Normal

- Bandeau : 4 métriques fixes (argent, travail, météo, alerte).
- Ateliers : 3–4 métriques par carte (ex. blé : stade phénologique, surface, prochaine tâche).
- Alertes : critiques uniquement (blocage imminent, météo sévère).
- Pas de données sol détaillées visibles.

### Mode Expert (ajouts)

- Bandeau : + indicateur de trésorerie à 7 jours, + charge de travail hebdo.
- Ateliers : + fertilité/humidité sol, + rendement prévisionnel, + marge brute estimée.
- Alertes : + risques proches (stock bas, fenêtre météo courte).
- Panneau latéral : + NPK, MO, pH, historique cultural, compaction.

### États & interactions principales

| État | Comportement |
|------|-------------|
| Alerte critique présente | Badge rouge clignotant sur bandeau ; clic → détail alerte + action suggérée |
| Tâche infaisable (rouge) | Icône rouge sur carte atelier + dans file rapide ; clic → raison + alternatives |
| Météo défavorable | Icône météo colorée (orange/rouge) ; clic → prévision J+7 avec incertitude croissante (J+3 max en mode Exigeant) |
| Aucune alerte | Bandeau sobre, focus sur file de tâches |
| Clic sur atelier | Ouvre panneau latéral avec détail parcelles/lots |

---

## 2. Écran planification — File de tâches

### Sections & widgets

| Zone | Contenu |
|------|---------|
| **Vue principale** | Liste par jour, regroupée par atelier ; chaque tâche : nom, atelier, durée estimée, faisabilité (●/●/●) |
| **Indicateur de charge** | Barre de charge journalière (travail requis vs disponible) |
| **Réservation prévisionnelle** | Tâches futures planifiées avec statut "réservé" (grisé) |
| **Panneau détail tâche** | Ressources requises, dépendances, fenêtre météo, note libre |

### Mode Normal

- Colonnes : Tâche · Atelier · Jour · Faisabilité (icône couleur).
- Faisabilité : ●vert = OK, ●orange = tension ressource ou météo incertaine, ●rouge = blocage.
- Actions : déplacer (drag ou sélecteur de jour), supprimer.
- Réservation prévisionnelle visible mais non modifiable directement (clic → détail).

### Mode Expert (ajouts)

- Colonnes supplémentaires : Durée · Ressources · Dépendances · % faisabilité chiffré.
- Faisabilité : couleur + pourcentage + message explicite (ex. "Travail insuffisant : 6h manquantes").
- Actions supplémentaires : suspendre, prioriser, dupliquer.
- Vue alternative : timeline Gantt simplifiée par atelier (V2+ si complexité trop haute).

### États & interactions principales

| État | Comportement |
|------|-------------|
| Tâche ●rouge | Ligne surlignée rouge ; clic → raison précise + suggestion (reporter, déléguer) |
| Tâche ●orange | Ligne orange ; clic → risque identifié (météo J+2 incertaine, travail limite) |
| Surcharge journalière | Barre de charge rouge ; tâches excédentaires marquées automatiquement orange |
| Drag & drop tâche | Recalcul faisabilité en temps réel sur la nouvelle date |
| Tâche réservée future | Grisée avec icône "réservé" ; modifiable via panneau détail |

---

## 3. Écran marchés — Bot + Joueur

### Sections & widgets

| Zone | Contenu |
|------|---------|
| **Onglets** | Acheter · Vendre · Historique |
| **Liste d'annonces** | Par ligne : Produit · Prix · Quantité · Origine (bot/joueur) · Délai livraison |
| **Filtres** | Type de produit · Fourchette de prix · Localisation · Quantité minimale |
| **Panneau logistique** | Coût transport estimé · Délai · Prestataire (bot ETA ou coop) |
| **Mes annonces** | Liste des annonces actives du joueur avec statut |

### Mode Normal

- Affichage : Produit · Prix · Quantité · Origine · Délai.
- Filtres : Type de produit + prix (presets simples).
- Bot toujours visible comme filet de sécurité (prix spread, jamais arbitrage profitable).
- Logistique : coût + délai uniquement.
- Création d'annonce : formulaire simple (produit, quantité, prix, délai).

### Mode Expert (ajouts)

- Colonnes supplémentaires : Qualité · Tag d'origine · Rendements décroissants (indicateur).
- Filtres avancés : filière, qualité, vendeur, délais personnalisés.
- Outils d'analyse : historique de prix du produit (graphique 30 jours), volume échangé.
- Annonces : options de renouvellement automatique, prix plancher/plafond.

### États & interactions principales

| État | Comportement |
|------|-------------|
| Aucune annonce joueur | Message "Marché calme — le bot assure l'approvisionnement" |
| Prix bot affiché | Tag "Bot" visible ; prix spread appliqué (jamais meilleur que joueur) |
| Annonce expirée | Grisée avec badge "Expirée" ; clic → renouveler ou supprimer |
| Transaction confirmée | Toast de confirmation + mise à jour argent dans bandeau |
| Logistique indisponible | Message d'erreur + alternative bot proposée |

---

## 4. Dashboards & Rapports

### Sections & widgets

| Zone | Contenu |
|------|---------|
| **Dashboard Exploitation** | Métriques clés : CA semaine, charges semaine, marge brute, taux d'occupation travail |
| **Dashboard Économie** | Trésorerie courante, prévision 30 jours, dépenses par catégorie (graphique barres) |
| **Historiques** | Courbes : prix de vente, rendements, météo (30/90 jours) |
| **Alertes passées** | Journal des alertes résolues et en cours |

### Mode Normal

- Dashboard unique "Exploitation" par défaut.
- Métriques : CA, charges, marge brute, travail utilisé/disponible.
- Graphiques : 1 courbe de trésorerie (30 jours).
- Alertes : critiques uniquement dans le journal.

### Mode Expert (ajouts)

- Dashboard Économie activé : trésorerie détaillée, prévision 30 jours, dépenses catégorisées.
- Métriques supplémentaires : marge par atelier, coût de production par unité, ROI investissements.
- Historiques étendus : 90 jours, comparaison saison N vs N-1.
- Alertes : journal complet (critiques + risques + opportunités).

### États & interactions principales

| État | Comportement |
|------|-------------|
| Marge brute négative | Métrique en rouge ; clic → détail par atelier |
| Trésorerie < seuil | Alerte dans bandeau + mise en évidence sur dashboard |
| Données insuffisantes | Graphique vide avec message "Données disponibles après 7 jours de jeu" |
| Clic sur métrique | Ouvre panneau détail avec historique et composition |

---

## 5. Workflows quotidiens

### Workflow "Jour normal"

```
Écran Exploitation
  → Vérifier bandeau (argent, travail, météo, alertes)
  → Consulter file de tâches rapide (3 prochaines)
  → [Si alerte orange] Ajuster tâche dans Planification
Écran Marchés
  → Vérifier opportunités de vente/achat
  → Passer commande si besoin
[Optionnel] Rapports rapides
  → Vérifier trésorerie semaine
```

### Workflow "Crise" (météo sévère, prix effondré, panne)

```
Alerte critique (bandeau rouge)
  → Clic → Diagnostic simple : type de crise + impact estimé
Écran Planification
  → Tâches impactées surlignées rouge
  → Reporter / suspendre les tâches bloquées
  → Réorganiser la file
Écran Marchés
  → Vendre stocks menacés si crise météo
  → Acheter intrants si rupture
[Optionnel] Rapports
  → Évaluer impact sur marge
```

### Workflow "Investissement"

```
Écran Rapports
  → Vérifier marge brute et trésorerie disponible
  → Identifier atelier sous-performant ou opportunité
Écran Exploitation
  → Consulter capacité travail et stockage
Écran Marchés
  → Vérifier prix des intrants / équipements
Décision
  → Confirmer achat/investissement via panneau dédié
  → Mise à jour automatique de la file de tâches (nouvelles tâches générées)
```

---

## 6. Normal vs Expert — Récapitulatif par écran

| Écran | Normal (visible) | Expert (ajouts) |
|-------|-----------------|-----------------|
| **Exploitation** | Argent, travail, météo, alertes critiques, ateliers 3–4 métriques | Trésorerie 7j, charge hebdo, NPK/MO/pH, marge brute estimée, risques proches |
| **Planification** | Tâche, atelier, jour, faisabilité couleur | Durée, ressources, dépendances, % faisabilité, actions avancées |
| **Marchés** | Produit, prix, quantité, origine, délai | Qualité, historique prix, filtres avancés, outils d'analyse |
| **Rapports** | Dashboard exploitation, trésorerie 30j, alertes critiques | Dashboard économie, métriques par atelier, historiques 90j, journal complet |

**Règle** : le mode normal doit permettre de jouer une session complète sans jamais avoir besoin du mode expert. Expert = profondeur, pas prérequis.

---

## 7. Onboarding — Missions progressives V1

### Principe

Missions progressives + conseils contextuels légers (bulles d'aide, surlignage, mini-checklist). Désactivables à tout moment. Les modules expert ne sont proposés qu'après manipulation du système en mode normal.

### Liste des missions V1

| # | Mission | Prérequis | Systèmes activés | Déclencheur conseil contextuel |
|---|---------|-----------|-----------------|-------------------------------|
| 1 | **Découvrir l'exploitation** — Explorer l'écran principal, lire le bandeau | Aucun | Exploitation (lecture seule) | Bulle sur chaque zone du bandeau au premier survol |
| 2 | **Première tâche** — Ajouter et exécuter une tâche agricole simple | Mission 1 | Planification (ajout tâche) | Bulle "Faisabilité : que signifient les couleurs ?" à la première tâche orange |
| 3 | **Première culture** — Semer une parcelle de blé, suivre jusqu'à la récolte | Mission 2 | Grandes cultures, météo, sol (fertilité+humidité) | Conseil météo à J+3 si fenêtre de semis ; rappel récolte à maturité |
| 4 | **Première vente** — Vendre la récolte sur le marché bot | Mission 3 | Marchés (vente bot) | Bulle "Prix bot vs prix joueur" à la première ouverture marchés |
| 5 | **Gérer la trésorerie** — Terminer une semaine avec marge positive | Mission 4 | Rapports (dashboard exploitation) | Conseil si trésorerie < 20% du capital initial |
| 6 | **Premier atelier élevage** — Acquérir un lot, produire, vendre | Mission 4 | Élevage, stockage | Bulle sur contrainte stockage au premier dépassement |
| 7 | **Planifier sur 7 jours** — Remplir la file de tâches pour une semaine complète | Mission 5 | Planification (réservation prévisionnelle) | Conseil si charge journalière > 90% sur 2 jours consécutifs |
| 8 | **Première crise** — Gérer une alerte météo ou de prix | Mission 6 | Alertes, workflow crise | Bulle "Comment réorganiser la file en urgence" à la première alerte rouge |
| 9 | **Premier investissement** — Acheter un équipement ou agrandir | Mission 7 | Rapports (économie), foncier | Conseil "Vérifier la marge avant d'investir" à l'ouverture du panneau achat |
| 10 | **Découvrir le mode Expert** — Activer expert sur un système | Mission 8 | Mode expert (un système au choix) | Bulle de présentation des nouvelles colonnes à l'activation |

### Règles d'enchaînement

- Missions 1–4 : séquentielles, débloquées automatiquement.
- Missions 5–9 : débloquées à la complétion de la précédente, mais jouables dans un ordre flexible (5 et 6 peuvent être parallèles).
- Mission 10 : proposée après mission 8, jamais forcée.
- Chaque mission affiche une mini-checklist dans un panneau rétractable (coin bas-droit).
- Le joueur peut ignorer une mission sans blocage ; elle reste accessible dans le menu Paramètres > Missions.

### Conseils contextuels — déclencheurs récurrents

| Déclencheur | Conseil affiché |
|-------------|----------------|
| Première tâche ●rouge | "Cette tâche est bloquée. Raison : [X]. Vous pouvez la reporter ou la déléguer." |
| Trésorerie < seuil | "Votre trésorerie est basse. Pensez à vendre des stocks ou reporter un investissement." |
| File vide pour demain | "Aucune tâche planifiée pour demain. Voulez-vous en ajouter ?" |
| Météo sévère J+1 | "Météo défavorable demain. Certaines tâches risquent d'être bloquées." |
| Stock proche du plafond | "Votre stockage est presque plein. Pensez à vendre ou à louer de la capacité." |
| Premier accès marchés | "Le bot garantit toujours un acheteur/vendeur, mais à un prix moins favorable que le marché joueur." |

---

## Annexe — Éléments V2+

> Marqués V2+ : hors scope V1, à ne pas implémenter.

- Vue Gantt complète (timeline interactive multi-ateliers)
- Filtres de marché sauvegardables et personnalisés
- Dashboard Territoire et Performance
- Prestataires joueurs (transport, insémination premium)
- Mode "basse charge mentale" dédié
- Personnalisation des widgets de tableau de bord
- Export des rapports
- Flux logistiques fins (traçabilité lot par lot)
- Viticulture, arboriculture, forêt
- Scénarios d'investissement comparatifs
