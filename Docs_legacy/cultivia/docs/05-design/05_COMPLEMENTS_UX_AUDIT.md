# Compléments UX — Audit SimAgri page par page

> Date : 2026-04-05
> Méthode : Chaque section existante comparée avec SimAgri, manques ajoutés.
> Format : Section → Manques identifiés → Complément à intégrer

---

## RÉFLEXION D'ÉQUIPE GLOBALE

```
💬 UX Design: "Nos specs sont bonnes sur les flux (bouton → API → résultat). Ce qui manque 
   c'est la richesse des DONNÉES affichées et les ACTIONS SECONDAIRES sur chaque page."
💬 Frontend: "SimAgri affiche beaucoup d'infos contextuelles : alertes, rappels, liens d'aide. 
   On doit ajouter ça partout."
💬 Game Design: "Un jeu de gestion = le joueur doit pouvoir TOUT voir d'un coup d'œil. 
   Chaque page doit avoir un résumé/alerte en haut."
💬 QA: "Il manque les cas vides (0 animaux, 0 parcelles, 0 matériels) partout."
✅ Décision: Compléter chaque page avec alertes, cas vides, actions secondaires, infos contextuelles.
```

---

## PHASE 0 — INFRASTRUCTURE

### §4 Dashboard — COMPLET ✅
Déjà complété dans l'audit (ajouté en fin de UX_PHASE0_1.md).

### §5 Relevé bancaire — COMPLET ✅
Déjà bien spécifié. Ajout mineur :
- **Manque** : Bouton "Exporter CSV"
- **Manque** : Graphique évolution solde en haut de page (comme SimAgri)
- **Manque** : Résumé par catégorie (camembert : % achats, % ventes, % entretien...)

### §6 Prêts — COMPLET ✅
Bien spécifié. Ajout mineur :
- **Manque** : Bouton "Rembourser par anticipation" sur chaque prêt actif
- **Manque** : Historique des prêts remboursés

### §7 Acheter parcelle — OK ✅
Bien spécifié.

### §8 Liste parcelles — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Résumé en haut : "{X} parcelles — {Y} ha — {Z} non travaillées ⚠️"
- Cas vide : "Vous n'avez aucune parcelle. [Acheter une parcelle]"
- Alerte : "X parcelle(s) non travaillée(s)" (bandeau orange si > 0)
- Bouton "Ordonner mes parcelles" (drag & drop pour réorganiser l'ordre d'affichage)
- Info aide débutant (masquable) : liens "Louer une parcelle", "Semer sa première culture"

### §9 Détail parcelle — COMPLET ✅
Complété dans l'audit précédent (altitude, inclinaison, fatigue sol, irrigation, haie, animaux au pré, note, vendre, ETA).

### §10 Analyse sol — OK ✅

### §11 Construire bâtiment — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Catalogue incomplet : seulement 4 types listés (Hangar, Silo, Entrepôt, Fosse). SimAgri en a 28.
- **Ajouter Phase 0-1** : Cuve à eau, Cuve à carburant (HVC), Aire de chargement, Silo de chargement, Aire stockage paille/foin, Fosse à lisier
- **Ajouter Phase 2** : Stabulation, Salle de traite, Cuve à lait
- Chaque carte doit afficher : prérequis (ex: "Nécessite un hangar"), énergie mensuelle
- Onglet "Accessoires" (comme SimAgri) : équipements à installer dans un bâtiment existant

### §12 Liste bâtiments — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de checkbox sélection groupée → ajouter
- Pas d'actions groupées → ajouter : "Entretenir tous", "Détruire tous"
- Pas de filtres → ajouter : par type, par état, par remplissage
- Pas de colonne "Assurance" → pas dans Cultivia (simplification OK)
- Cas vide : "Vous n'avez aucun bâtiment. [Construire un bâtiment]"
- Capacité totale en haut : "Capacité totale : X / Y"

### §13-15 Agrandir/Entretenir/Détruire bâtiment — OK ✅
Bien spécifiés.

### §16 Acheter matériel neuf — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Filtres incomplets : ajouter filtre par marque (John Deere, Claas, New Holland, Fendt, Massey Ferguson, Case IH, Kubota, Deutz-Fahr)
- Pas de recherche texte → ajouter barre de recherche
- Pas d'info "GPS disponible" par matériel
- Pas d'info "Relevage avant compatible"
- Fiche détaillée : ajouter photo/illustration du matériel réel

### §17 Acheter occasion — OK (placeholder Phase 1)

### §18 Vendre matériel — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de choix : vente à la coop (prix fixe) vs mise en vente sur le marché (prix libre, Phase 3)
- Pas d'historique des ventes

### §19 Entretenir matériel — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de distinction entretien mensuel vs annuel (SimAgri a les deux)
- Pas de coût affiché avant confirmation
- Pas d'action groupée "Entretenir tous"

### §20 Faire le plein HVC — OK ✅

### §21 Aller à la coopérative — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- SimAgri a des jours marché (régional/national). Notre spec ne précise pas les jours.
- Pas de page "Coopérative fermée aujourd'hui" avec date prochaine ouverture
- Pas de cours des matières premières (prix actuel vs prix antérieur)
- Pas d'onglets par catégorie (Animaux, Marchandises, Accessoires, Carburant)

### §22-31 Actions cultures (Déchaumer → Presser paille) — OK ✅
Bien spécifiées avec coûts HT, matériel requis, états boutons.

**Manque transversal :** Chaque action devrait afficher un rappel "Matériel utilisé : {nom}" et "Carburant consommé : {X} L HVC"

### §32 Vendre récolte — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de cours actuel vs cours antérieur (variation ↑↓)
- Pas de choix : vendre à la coop (prix fixe) vs mettre en annonce (prix libre)
- Pas d'historique des ventes de récolte

### §33-35 Litière/Fumier/Épandage — OK ✅

### §36-37 Prêts — Doublon avec §6, OK ✅

### §38 Kit démarrage — OK ✅

---

## PHASE 2 — ÉLEVAGE

### §1 Acheter animal coopérative — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de cours actuel vs cours antérieur (comme SimAgri : "4.25 €/kg → 4.23 €/kg")
- Pas de filtre par race dans le catalogue
- Pas de distinction marché régional/national par jour
- Pas de lien vers le négociant en bestiaux (alternative si rien en coop)
- Cas vide : "Aucun animal disponible aujourd'hui"

### §2 Voir ses animaux — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de tableau de bord élevage en haut (comme SimAgri) :
  - Compteur par espèce
  - Animaux pas nourris (compteur + lien)
  - Animaux pas abreuvés
  - Animaux malades + bouton "Soigner tous"
  - Animaux morts du jour
  - Animaux en arrivage + bouton "Placer auto"
  - Estimation eau (nécessaire vs dispo)
  - Périodes insémination en cours
- Pas d'actions groupées : Nourrir sélection, Soigner sélection, Mettre au pré, Vendre abattoir
- Cas vide : "Vous n'avez aucun animal. [Aller à la coopérative]"
- Pas de filtre par lieu (bâtiment/pré)
- Pas de filtre par état (nourri/pas nourri, malade, gestante)

### §3 Fiche animal — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas d'arbre généalogique (parents, grands-parents) — SimAgri l'a
- Pas de valeur estimée (prix revente abattoir)
- Pas de bouton "Renommer"
- Pas de bouton "Déplacer" (changer de bâtiment/pré)
- Pas d'historique santé
- Pas d'historique reproduction
- Pas de lien vers le GénétiLab pour cet animal

### §4 Nourrir animaux — OK ✅
Bien spécifié.

### §5 Nourrissage auto — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de config par bâtiment (SimAgri permet de configurer la ration par bâtiment)
- Pas d'affichage stock restant estimé ("Stock suffisant pour X jours")
- Pas d'alerte "Stock épuisé dans X jours"

---

## PHASE 2 — PAGES MANQUANTES À CRÉER

### Soigner un animal

**Écran** : Modale depuis fiche animal ou action groupée.
- Animal : nom, race, maladie détectée
- Coût : X € + Y HT
- Bouton "Soigner" — Grisé si solde/HT insuffisants

**API :** `POST /api/animals/:id/heal`

### Vacciner un animal

**Écran** : Modale depuis fiche animal.
- Animal : nom, race, dernier vaccin
- Coût : X € + Y HT
- Bouton "Vacciner" — Grisé si déjà vacciné cette saison

**API :** `POST /api/animals/:id/vaccinate`

### Inséminer un animal

**Écran** : Modale depuis fiche animal.
- Femelle : nom, race, état (prête / pas en période)
- Choix mâle : dropdown mâles disponibles (même race) ou CIA
- Coût : X € + Y HT (CIA plus cher)
- Bouton "Inséminer" — Grisé si pas en période, tooltip "Période d'insémination : {mois}"

**API :** `POST /api/animals/:id/inseminate`

### Traire les animaux

**Écran** : Page `/animals/milking` ou action groupée.
- Liste vaches en lactation
- Production estimée par animal
- Prérequis : salle de traite + cuve à lait
- Bouton "Traire toutes" — Grisé si pas de salle de traite

**API :** `POST /api/animals/milk`

### Vendre à l'abattoir

**Écran** : Modale depuis fiche animal ou action groupée.
- Animal(aux) sélectionné(s) : nom, race, poids, prix/kg, total estimé
- Bouton "Vendre" — ConfirmModal "Vendre X animaux pour ~Y € ?"

**API :** `POST /api/animals/slaughter`

### Mettre au pré / Rentrer en bâtiment

**Écran** : Modale depuis fiche animal ou action groupée.
- Choix destination : dropdown prés disponibles (avec places) ou bâtiments
- Coût HT : affiché
- Bouton "Déplacer"

**API :** `POST /api/animals/:id/move`

### Productions (lait, œufs, laine)

**Écran** : Page `/animals/productions`
- Onglets : Lait | Œufs | Laine
- Tableau par produit : quantité du jour, stock total, qualité, prix moyen
- Graphique production sur 30 jours
- Bouton "Vendre" par produit → vers Marché Central

**API :** `GET /api/animals/productions`

---

## PHASE 3-6 — ÉCONOMIE & COMMERCE

### §1-2 CAR — COMPLET ✅
Très bien spécifié (création, dashboard 7 onglets, votes, stocks, contrats, emprunts, parts).

### §3 Passer une annonce — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de durée d'annonce (SimAgri a une expiration)
- Pas de catégorie d'annonce (marchandise, matériel, animal)
- Pas de visibilité : régionale vs nationale

### §4 Répondre à une annonce — OK ✅

### §5 Amis — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de distinction ami / ami privilégié (SimAgri a les deux)
- Pas de statut en ligne (point vert)
- Pas de bouton "Envoyer un message" direct

### §6-7 Transport — OK ✅

### §8 Embaucher employé — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de page "Mes employés" avec liste (nom, compétence, salaire, HT fournis)
- Pas de bouton "Licencier"
- Pas d'info "Coût mensuel total employés : X €/mois"

### §9 Commander ETA — OK ✅

### §10 Épargne — OK ✅

### §11-28 Activités Phase 4+ — OK (specs futures)

### §29 Voter Chambre Agricole — OK ✅

### §30 Concours — OK ✅

### Contrats joueurs — COMPLÉMENTS NÉCESSAIRES

**Manques identifiés :**
- Pas de page "Mes contrats en cours" avec suivi livraison
- Pas de système de pénalité visible (retard → malus réputation)
- Pas de notation vendeur/acheteur après transaction

---

## PAGES TRANSVERSALES MANQUANTES

### Classements (`/rankings`)

**Écran** : Page avec onglets.

| Onglet | Colonnes | API |
|--------|----------|-----|
| Général | Rang, Pseudo, Préfecture, Score global, Réputation | `GET /api/rankings/general` |
| Cultures | Rang, Pseudo, Rendement moyen, Ha cultivés, Revenus cultures | `GET /api/rankings/crops` |
| Élevage | Rang, Pseudo, Nb animaux, Production lait, Génétique moy. | `GET /api/rankings/animals` |
| Commerce | Rang, Pseudo, CA total, Nb transactions, Réputation | `GET /api/rankings/commerce` |
| CAR | Rang, Nom CAR, Région, CA, Nb membres, Stock | `GET /api/rankings/car` |
| ETA | Rang, Pseudo, Nb commandes, CA, Note moyenne | `GET /api/rankings/eta` |

- Pagination 50/page
- Recherche par pseudo
- Ma position surlignée en jaune
- Période : Ce mois / Cette saison / Tout temps

### Statistiques (`/stats`)

**Écran** : Page avec onglets.

| Onglet | Contenu |
|--------|---------|
| Ferme | Ancienneté, valeur totale exploitation, nb bâtiments/matériels/animaux/parcelles |
| Cultures | Rendements par culture (graphique barres), revenus par saison, meilleure culture |
| Élevage | Production lait/œufs/laine par mois (graphique), naissances/morts, génétique moyenne |
| Finances | Revenus vs dépenses par mois (graphique), répartition par catégorie (camembert) |

### Profil public (`/players/:id`)

**Écran** :
- Pseudo, Préfecture, Ancienneté (jours)
- Réputation : ⭐⭐⭐⭐☆ (4.2/5)
- Spécialisation : Cultures / Élevage / Commerce (branche principale)
- Statistiques publiques : nb parcelles, nb animaux, classement
- Boutons : [Ajouter en ami] [Envoyer message]
- Si profil privé : "Ce joueur a un profil privé"

### Favoris (`/favorites`)

**Écran** : Liste de raccourcis personnalisés.
- Chaque favori : icône + nom + lien
- Bouton "Ajouter aux favoris" disponible sur chaque page (icône ⭐ dans le header)
- Drag & drop pour réorganiser
- Max 20 favoris

**API :** `GET /api/favorites` / `POST /api/favorites` / `DELETE /api/favorites/:id`

### Employés (`/employees`)

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Mes employés" [Coût mensuel total: 1 200 €/mois]  │
│ [Embaucher un employé]                                          │
├─────────────────────────────────────────────────────────────────┤
│ Nom      | Compétence | HT fournis/jour | Salaire/mois | Actions│
│ Jean     | Cultures   | +4 HT           | 600 €        | [Licencier] │
│ Marie    | Élevage    | +4 HT           | 600 €        | [Licencier] │
├─────────────────────────────────────────────────────────────────┤
│ Total :                 +8 HT/jour        1 200 €/mois          │
└─────────────────────────────────────────────────────────────────┘
```

- Cas vide : "Vous n'avez aucun employé. [Embaucher]"
- Bouton "Licencier" → ConfirmModal "Licencier {nom} ? Vous perdrez {X} HT/jour."

**API :** `GET /api/employees` / `DELETE /api/employees/:id`

### Bloc-notes (`/notes` ou widget sidebar)

**Écran** : Textarea simple, sauvegarde auto (debounce 2s).
- Max 5 000 caractères
- Markdown basique supporté (gras, italique, listes)
- Accessible depuis la sidebar (widget) ou page dédiée

**API :** `GET /api/player/notes` / `PUT /api/player/notes`

---

## RÉSUMÉ DES COMPLÉMENTS

### Par priorité :

**🔴 Critiques (bloquent le gameplay) :**
1. Tableau de bord élevage (compteurs, alertes, actions rapides) — §2 Phase 2
2. Actions groupées animaux (nourrir, soigner, déplacer) — §2 Phase 2
3. Pages manquantes élevage (soigner, vacciner, inséminer, traire, abattoir, déplacer, productions)
4. Coopérative : jours marché, cours matières premières, onglets catégories

**🟡 Importants (améliorent l'expérience) :**
5. Filtres + actions groupées bâtiments
6. Filtres par marque matériels
7. Entretien mensuel vs annuel matériels
8. Arbre généalogique animal
9. Cours actuel vs antérieur (animaux + récoltes)
10. Page employés complète
11. Classements + Statistiques

**🟢 Confort (QoL) :**
12. Exporter CSV relevé bancaire
13. Graphique évolution solde
14. Favoris
15. Bloc-notes
16. Profil public joueur
17. Historique ventes
18. Aide débutant contextuelle par page
