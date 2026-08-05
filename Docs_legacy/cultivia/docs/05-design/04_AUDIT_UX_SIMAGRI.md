# Audit UX/UI Cultivia — Basé sur les exports SimAgri

> Date : 2026-04-05
> Source : 241 pages HTML exportées de france3.simagri.com
> Objectif : Inventaire exhaustif de TOUTES les interfaces, boutons, widgets d'un jeu de gestion agricole
> Méthode : Comparaison SimAgri → Cultivia, adaptation à nos mécaniques (HT, préfectures, 3 branches)

---

## RÉFLEXION D'ÉQUIPE

```
💬 UX Design: "SimAgri a ~240 pages. Notre doc UX couvre ~86 actions. Il manque la navigation 
   globale, le dashboard complet, les widgets persistants, et beaucoup d'écrans secondaires."
💬 Frontend: "Leur UI est jQuery/Bootstrap, très tabulaire. On modernise avec Vue 3 mais on 
   garde la densité d'info — c'est un jeu de GESTION, les joueurs veulent des données."
💬 Game Design: "On simplifie : 3 branches au lieu de 11 activités, mais chaque branche doit 
   avoir autant de profondeur que SimAgri. Ne pas confondre simplification et appauvrissement."
💬 Backend: "Chaque widget du dashboard = un endpoint ou un champ WebSocket. Je dois tout lister."
💬 QA: "Chaque bouton doit avoir ses états (actif/grisé/masqué) et ses tooltips. SimAgri le fait 
   bien, on doit faire pareil."
✅ Décision: Document exhaustif, écran par écran, avec mapping SimAgri → Cultivia.
```

---

## 1. ÉLÉMENTS PERSISTANTS (toutes pages)

### 1.1 Header global

**SimAgri affiche en permanence :**
- Nom du joueur + activité courante (ex: "demaistos FERME")
- Date serveur + saison (ex: "4 Avril - Saison 93 (printemps)")
- Météo : 2 températures (aujourd'hui/demain) + icône
- PA restants (ex: "35 PA") avec lien vers employés
- Solde (ex: "120 000.00 €") avec dropdown : relevé bancaire, épargnes, prêts, parts sociales
- Jauge carburant (gauge visuelle, clic = remplir)
- Badge notifications (compteur)
- Heure serveur + joueurs connectés

**Cultivia doit avoir :**
| Élément | Mapping | Endpoint/Source |
|---------|---------|-----------------|
| Nom joueur + ferme | Identique | `useAuthStore` |
| Date Cultivia + mois + saison | "7 Avril — Mois 4 (Printemps)" | `GET /api/server/time` ou WS |
| Météo zone | Icône + température | WS `weather_update` |
| HT restants | "32/40 HT" avec barre | `player.ht_today` via WS |
| Solde | "87 450.00 €" | `player.balance` via WS |
| Dropdown finances | Relevé, Épargnes, Prêts | Liens navigation |
| Notifications | Badge compteur + dropdown 50 dernières | WS `notification` |
| Joueurs en ligne | Compteur | WS `presence` |

**Boutons header :**
- `Embaucher un employé` → modale ou page `/employees/hire`
- `Mes employés` → `/employees`
- `Se déconnecter` → `POST /api/auth/logout`

**Dropdown profil :**
- Mon profil → `/profile`
- Mes préférences → `/settings`
- Mes favoris → `/favorites`
- Filtres notifications → `/settings/notifications`
- Ma fiche descriptive → `/profile/public`
- Mes disponibilités → `/profile/availability`
- Mes amis → `/friends`
- Joueurs connectés → `/players/online`

### 1.2 Navigation principale (top bar)

**SimAgri : 6 onglets + menu activités**
```
[Bâtiments] [Animaux] [Matériels] [Parcelles] [Coopérative] [Activité ▼]
```
Activités : FERME, MARAÎCHAGE, TRANSPORT, CONCESSIONNAIRE, CIA, CAR, FROMAGERIE, MARCHÉ, FORÊTS, VITICULTURE, CESA

**Cultivia : 5 onglets (simplifié)**
```
[🏠 Ferme] [🌾 Parcelles] [🐄 Élevage] [🔧 Matériels] [💰 Commerce]
```
- Ferme = Bâtiments + Dashboard + Employés
- Parcelles = Cultures + Sol + Eau + Récolte
- Élevage = Animaux + Soins + Reproduction + Productions
- Matériels = Inventaire + Achat/Vente + ETA + Entretien
- Commerce = Marché Central + CAR + Contrats + Transport

### 1.3 Menu latéral gauche (contextuel par onglet)

Chaque onglet principal déploie un menu latéral. Voici le contenu complet :

**🏠 Ferme :**
- Tableau de bord (dashboard)
- Mes bâtiments
- Construire un bâtiment
- Consommation énergie
- Mes marchandises (stock)
- Mes employés
- Embaucher
- Agrandir ma ferme

**🌾 Parcelles :**
- Mes parcelles
- Acheter une parcelle
- Offres vente/location
- Parcelles à travailler
- Commandes ETA Cultivia
- Besoin en engrais
- Tableau de bord cultures
- Mes statistiques
- Classements cultures

**🐄 Élevage :**
- Mes animaux
- Marché Central (animaux)
- Soins / Propreté
- Mettre de la paille
- Retirer le fumier
- Retirer le lisier
- Mes productions (lait, œufs, laine)
- Nourrir (manuel)
- Config nourrissage auto
- Reproduction / Insémination
- Valeurs génétiques
- GénétiLab (= GenBook)
- Statistiques carcasses
- Mon chien de troupeau

**🔧 Matériels :**
- Mes matériels
- Acheter occasion
- Acheter neuf
- Chercher par marque
- Acheter à plusieurs
- Pièces détachées
- ETA Cultivia (commandes)
- Définir mes tarifs ETA
- Annuaire ETA
- Classements ETA
- Mes statistiques ETA

**💰 Commerce :**
- Marché Central (marchandises)
- Mes annonces
- Consulter les annonces
- Commandes reçues
- Commandes passées
- Contrats joueurs
- Appels d'offres
- Ma CAR (si membre)
- Annuaire CAR
- Transport marchandises
- Relevé bancaire
- Épargnes
- Prêts

### 1.4 Sidebar droite (widgets persistants)

**SimAgri a :**
- Bloc-notes personnel
- MP-Live (chat temps réel)
- Liens communauté (Discord, Forums, Forum régional)
- Favoris
- Aide interactive
- Capture de page
- Liens réseaux sociaux

**Cultivia doit avoir :**
- 📝 Bloc-notes personnel (textarea sauvegardé)
- 💬 Chat en jeu (WebSocket)
- ⭐ Favoris (raccourcis personnalisés)
- 🔔 Centre de notifications (panneau déroulant)
- ❓ Aide contextuelle (lien vers guide joueur selon la page)
- 📊 Mini-stats (résumé du jour : HT utilisés, € gagnés/dépensés)

### 1.5 Footer

- Heure serveur
- Joueurs connectés
- Liens : Règles, Aide, Contact, CGU, Infos légales
- Version (PC/Tablette/Mobile) → responsive, pas de lien séparé

---

## 2. DASHBOARD (`/dashboard`)

### 2.1 Widgets du dashboard

**SimAgri affiche :**
1. Message de bienvenue + localisation (région/département/zone)
2. Météo zone : aujourd'hui + demain (texte + icône)
3. Événements in-game (toggle activé/désactivé)
4. Statut marché (ouvert/fermé + type régional/national)
5. Demandes de transport en attente (compteur)
6. Notifications (50 dernières, avec date + lu/non-lu)
7. Graphique évolution du solde (Google Charts)
8. Dernières nouveautés du jeu (changelog)
9. Suivi des packs/abonnement
10. Rapport d'activité quotidien
11. Aide débutant (masquable, 14 premiers jours)
12. Tirage au sort (événement)

**Cultivia — Dashboard complet :**

```
┌─────────────────────────────────────────────────────────────────┐
│ 🌾 Bienvenue {username} — {prefecture}, {department}           │
│ 📅 7 Avril — Mois 4 (Printemps) — Année 2    ☀️ 14°C → 🌧 11°C │
├────────────────────┬────────────────────┬───────────────────────┤
│ 💰 FINANCES        │ ⏱️ HEURES TRAVAIL   │ 🔔 ALERTES DU JOUR    │
│ Solde: 87 450 €    │ ████████░░ 32/40   │ • 3 animaux pas nourris│
│ Variation: +1 200€ │ Employé: +8 HT     │ • Parcelle #4 à récolter│
│ [Relevé bancaire]  │ [Détail HT]        │ • Matériel en panne    │
├────────────────────┴────────────────────┴───────────────────────┤
│ 📊 ÉVOLUTION DU SOLDE (graphique 30 derniers jours)            │
├────────────────────┬────────────────────────────────────────────┤
│ 🐄 MES ANIMAUX     │ 🌾 MES PARCELLES                          │
│ Bovins: 12         │ 5 parcelles — 47 ha                       │
│ Pas nourris: 3 ⚠️  │ Non travaillée: 1 ⚠️                       │
│ Pas abreuvés: 0 ✅ │ À récolter: 2 🟢                           │
│ Malades: 1 🔴      │ En croissance: 2 🌱                        │
│ Naissances: 0      │                                            │
│ Morts: 0           │                                            │
│ En enclos arrivage: 0│                                          │
│ [Voir animaux]     │ [Voir parcelles]                           │
├────────────────────┼────────────────────────────────────────────┤
│ 🏗️ MES BÂTIMENTS   │ 🔧 MES MATÉRIELS                          │
│ 8 bâtiments        │ 4 matériels                                │
│ Capacité: 65%      │ En panne: 1 ⚠️                             │
│ Énergie: OK ✅     │ Non abrité: 2 ⚠️                           │
│ [Voir bâtiments]   │ Carburant: ████░░ 60%                     │
│                    │ [Voir matériels]                            │
├────────────────────┴────────────────────────────────────────────┤
│ 🔔 NOTIFICATIONS (50 dernières)                                 │
│ • Des animaux n'ont pas mangé aujourd'hui — 07/04 21:15        │
│ • Récolte de blé terminée sur parcelle #2 — 07/04 03:00        │
│ • Nouveau message de FermierDu42 — 06/04 18:30                 │
│ [Tout marquer comme lu] [Voir toutes]                          │
├─────────────────────────────────────────────────────────────────┤
│ 📰 ACTUALITÉS CULTIVIA                                          │
│ • Mise à jour 1.2 : Nouvelles races bovines — 05/04            │
│ • Événement saisonnier : Gel printanier — 03/04                │
│ [Voir toutes les actualités]                                    │
├─────────────────────────────────────────────────────────────────┤
│ 💡 AIDE DÉBUTANT (masquable après 84 jours)                     │
│ Bienvenue ! Consultez le guide pour bien démarrer.              │
│ [Guide du joueur] [Masquer]                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Boutons et actions du dashboard

| Bouton | Action | Condition |
|--------|--------|-----------|
| Relevé bancaire | → `/finances/ledger` | Toujours actif |
| Détail HT | Modale détail consommation HT du jour | Toujours actif |
| Voir animaux | → `/animals` | Toujours actif |
| Voir parcelles | → `/parcels` | Toujours actif |
| Voir bâtiments | → `/buildings` | Toujours actif |
| Voir matériels | → `/equipment` | Toujours actif |
| Tout marquer comme lu | `POST /api/notifications/read-all` | Si notifs non lues |
| Guide du joueur | → `/guide` | Toujours actif |
| Masquer aide | `PUT /api/player/preferences` | < 84 jours ancienneté |

### 2.3 Données temps réel (WebSocket)

| Événement WS | Widget mis à jour |
|-------------|-------------------|
| `balance_update` | Solde + graphique |
| `ht_update` | Barre HT |
| `weather_update` | Météo |
| `notification` | Badge + liste notifications |
| `animal_alert` | Widget animaux (pas nourri, malade...) |
| `parcel_alert` | Widget parcelles (à récolter...) |
| `equipment_alert` | Widget matériels (panne...) |
| `market_status` | Statut marché (ouvert/fermé) |

---

## 3. PARCELLES (`/parcels`)

### 3.1 Liste des parcelles — 5 onglets (comme SimAgri)

**Onglet Culture :**
| Colonne | Description |
|---------|-------------|
| ☐ | Checkbox sélection groupée |
| ID/Nom | Identifiant + nom personnalisé |
| Localisation | Préfecture + distance km |
| Culture/État | Culture en cours + état (jachère/semé/en croissance/à récolter) |
| Pousse | Barre de progression croissance |
| Météo | Icône météo de la zone |
| Surface | En hectares |
| Jachère | Nombre de fois en jachère |
| Altitude | En mètres |
| Inclinaison | En degrés |
| Actions | Boutons contextuels |

**Onglet Sol :**
| Colonne | Description |
|---------|-------------|
| ID/Nom | Identifiant |
| Localisation | Préfecture |
| Engrais dispo | Stock engrais disponible |
| Engrais épandu | Quantité épandue |
| Dernière analyse | Date |
| Qualité | Indicateur global |
| N P K Ca Mg S | 6 indicateurs sol (mode expert) |
| Fertilité / Structure / Oligo | 3 indicateurs (mode simple) |
| Actions | Boutons contextuels |

**Onglet Eau :**
| Colonne | Description |
|---------|-------------|
| ID/Nom | Identifiant |
| Météo | Icône |
| Gestion irrigation | Activée/Stoppée |
| Source eau | Ruisseau/Rivière/Source/Canalisation |
| Retenue collinaire | Capacité + remplissage |
| Enrouleurs | Nombre |
| Programmation pivot | Config |

**Onglet Animaux (au pré) :**
| Colonne | Description |
|---------|-------------|
| ID/Nom | Identifiant |
| Nb Animaux | Compteur |
| Eau nécessaire | Litres/jour |
| Bac à eau | Capacité |
| Source eau | Type |
| Nourriture nécessaire | Kg/jour |
| Nourriture dispo | Stock |

**Onglet Haie :**
| Colonne | Description |
|---------|-------------|
| ID/Nom | Identifiant |
| Gestion | État |
| Nombre arbustes | Compteur |
| Densité | Arbustes/mètre |
| Taillés | Oui/Non |
| À andainer | Quantité |
| À déchiqueter | Quantité |

### 3.2 Filtres parcelles

**SimAgri propose :**
- Par type : Conventionnelles / Bio / Suivies / Non suivies / Annotées / Non annotées
- Par achat : Achetées par annonce / Achetées à Partcel / Louées
- Par état : Activée / Stoppée / Avec enrouleur / Avec pivot / En manque d'eau
- Par récolte : Non travaillée / Récoltée / Non récoltée
- Par culture : Liste complète (30+ cultures, prés, vergers)
- Par rotation : Culture + ancienneté (ex: "Blé - 1 an(s)")

**Cultivia doit avoir :**
- Par état : Jachère / Semée / En croissance / À récolter / Non travaillée
- Par type : Champ / Pré
- Par culture : Liste des cultures disponibles (Phase 1)
- Par sol : Fertilité haute/moyenne/basse
- Par suivi : Suivies / Non suivies
- Par annotation : Annotées / Non annotées

### 3.3 Actions groupées parcelles

**SimAgri :**
- Remettre en jachère
- Choisir la technique culturale
- Choisir la culture
- Appeler une ETA
- Analyser le sol
- Regrouper 2 parcelles
- Effectuer un forage
- Activer/Stopper l'irrigation
- Programmer un pivot
- Ordonner mes parcelles
- Ajouter dans un groupe
- Suivre / Ne plus suivre
- Effacer la note

**Cultivia :**
- Remettre en jachère (coût HT)
- Choisir la culture (coût HT)
- Appeler ETA Cultivia (coût HT + €)
- Analyser le sol (coût HT + €)
- Activer/Stopper irrigation
- Suivre / Ne plus suivre
- Annoter / Effacer note
- Ordonner (drag & drop)

---

*Suite dans la partie 2...*

## 4. ANIMAUX (`/animals`)

### 4.1 Page d'accueil animaux

**SimAgri affiche un tableau de bord élevage avec :**

| Widget | Données | Cultivia |
|--------|---------|----------|
| Compteur par espèce | Bovin 12, Porcin 0, Caprin 5... | Compteur par espèce (Phase 2 = bovins) |
| Animaux pas nourris | Liste par espèce + compteur ⚠️ | Identique, lien vers nourrissage |
| Animaux pas abreuvés | Liste par espèce + compteur ⚠️ | Identique |
| Animaux malades | Compteur + bouton "Soigner tous" | Identique + coût HT affiché |
| Animaux morts | Compteur du jour | Identique |
| Animaux vendus abattoir | Compteur du jour | Identique |
| Naissances à venir | Compteur | Identique |
| Morts-nés | Compteur | Identique |
| Animaux grandissant | Compteur (changement stade) | Identique |
| Enclos d'arrivage | Liste + bouton "Mettre auto en bâtiment" | Identique |
| Animaux au parc/pré | Compteur | Identique |
| Animaux en bétaillère | Compteur | Identique |
| Animaux égarés | Compteur ⚠️ | Identique |
| Estimation eau | Nécessaire vs Dispo (bacs + cuves) + bouton "Remplir" | Identique |
| Périodes hivernales | Info mise au pré/plein-air | Identique (selon saison Cultivia) |
| Périodes insémination | Info par espèce | Identique |
| Type élevage | Toggle conventionnel/bio par espèce | Non applicable Phase 2 |
| Ratios et fusions | Lien gestion | Non applicable Phase 2 |

### 4.2 Liste animaux — Colonnes

| Colonne SimAgri | Cultivia |
|----------------|----------|
| Nom | Nom (personnalisable) |
| Race | Race (Prim'Holstein, Charolaise...) |
| Sexe | Sexe (M/F) |
| Âge | Âge (en mois Cultivia) |
| Poids | Poids (kg) |
| Lieu | Bâtiment ou Pré |
| Santé | ❤️ Jauge santé (couleur) |
| Nourri | ✅/❌ |
| Abreuvé | ✅/❌ |
| Gestante | 🤰 si applicable |
| Allaitante | 🍼 si applicable |
| Malade | 🏥 si applicable |
| Vacciné | 💉 si applicable |
| Génétique | 5 barres (indices) |
| Actions | [Voir] [Nourrir] [Soigner] [Vendre] |

### 4.3 Filtres animaux

- Par espèce (Phase 2 = bovins uniquement)
- Par race
- Par sexe
- Par stade de vie (veau, génisse, vache, taureau...)
- Par lieu (bâtiment X, pré Y)
- Par état (nourri/pas nourri, malade, gestante)

### 4.4 Actions groupées animaux

- Nourrir sélection
- Abreuver sélection
- Soigner sélection
- Mettre au pré
- Rentrer en bâtiment
- Mettre en bétaillère
- Vendre à l'abattoir

### 4.5 Fiche animal détaillée

**SimAgri montre :**
- Photo/icône race
- Nom, Race, Sexe, Âge, Poids, Lieu
- Indices génétiques (5 barres visuelles)
- Historique santé
- Historique reproduction
- Arbre généalogique (parents, grands-parents)
- Valeur estimée
- Boutons : Nourrir, Soigner, Vacciner, Inséminer, Déplacer, Vendre, Renommer

**Cultivia identique + :**
- Savoir-faire XP lié à cet animal
- Coût HT de chaque action affiché sur le bouton

### 4.6 Nourrissage

**Page nourrissage manuel (SimAgri) :**
- Sélection bâtiment/pré
- Liste animaux dans ce lieu
- Ration par animal : type aliment + quantité
- Stock disponible affiché
- Bouton "Nourrir" par animal ou "Nourrir tous"
- Robot d'alimentation (si équipé)

**Page nourrissage auto (SimAgri) :**
- Config ration par bâtiment
- Type aliment + quantité/jour
- Toggle actif/inactif
- Le tick applique automatiquement

**Cultivia :**
- Nourrissage auto par défaut (config ration dans `/buildings/:id/ration-config`)
- Page manuelle pour override ponctuel
- Coût HT affiché (0.3 HT auto, 0.5 HT manuel)

### 4.7 Pages marché animaux

**SimAgri — Coopérative animaux :**
- Onglets par espèce (Bovin, Porcin, Caprin...)
- Tableau : Animal | Disponible à la vente | Cours actuel (€/kg) | Cours antérieur
- Jours marché : régional (lun, mar, jeu, ven) / national (mer, sam, dim)

**Cultivia — Marché Central animaux :**
- Même structure, 1 onglet par espèce disponible
- Colonnes : Race | Stade | Dispo | Prix/kg | Variation | [Acheter]
- Consultation gratuite (0 HT), achat = coût HT

---

## 5. BÂTIMENTS (`/buildings`)

### 5.1 Liste bâtiments

**SimAgri — Colonnes :**
| Colonne | Description |
|---------|-------------|
| ☐ | Checkbox sélection |
| Bâtiment | Nom + type + icône |
| Capacité | X / Y (m² ou places) |
| Remplissage | Barre visuelle % |
| Marchandise | Contenu stocké |
| Usure | % usure |
| Entretien | État entretien (mensuel/annuel) |
| Assurance | Assuré / Non assuré |
| Actions | [Détail] [Entretenir] [Détruire] |

**SimAgri — Onglets :**
- Bâtiments (liste principale)
- Accessoires (équipements des bâtiments)

**SimAgri — Types de bâtiments (28 types) :**
Hangar, Hall d'exposition, Écurie, Stabulation, Porcherie, Chèvrerie, Bergerie, Clapier, Poulailler, Entrepôt, Local phytosanitaire, Silo, Silo taupe, Fosse à fumier, Aire de compostage, Fosse à lisier, Aire stockage paille/foin, Entrepôt arboricole, Serre pépinière, Unité tabac, Chambre froide, Salle de stockage, Entrepôt PDT, Plateforme substrat, Plateforme digestat, Fosse substrat, Fosse digestat, Plateforme copeaux, Silo de chargement, Aire de chargement

**Cultivia Phase 0-1 (simplifié) :**
Hangar, Stabulation, Entrepôt, Silo, Fosse à fumier, Fosse à lisier, Aire stockage paille/foin, Silo de chargement, Aire de chargement, Cuve à eau, Cuve à carburant, Salle de traite, Cuve à lait

### 5.2 Actions groupées bâtiments

- Entretenir tous les bâtiments cochés
- Détruire tous les bâtiments cochés (ConfirmModal)

### 5.3 Filtres bâtiments

**SimAgri :** Par type (dropdown 28 types)

**Cultivia :** Par type + Par état (bon/usé/critique) + Par remplissage (vide/partiel/plein)

### 5.4 Détail bâtiment

- Nom, Type, Niveau, Capacité, Remplissage
- Contenu détaillé (animaux ou marchandises)
- Usure + date dernier entretien
- Consommation énergie
- Config ration (si bâtiment élevage)
- Boutons : Entretenir (coût HT + €), Améliorer niveau, Détruire

### 5.5 Achat bâtiment

- Catalogue par type
- Prix + délai construction (instantané niv 1, délai niv 2+)
- Prérequis affichés
- Bouton Construire (coût HT + €)

### 5.6 Énergie

**SimAgri a une page dédiée "Ma conso d'énergie" :**
- Tableau par bâtiment : consommation mensuelle
- Total mensuel
- Coût automatique (prélevé au tick mensuel)

**Cultivia :** Identique, dans onglet bâtiments ou page dédiée `/buildings/energy`

---

## 6. MATÉRIELS (`/equipment`)

### 6.1 Liste matériels

**SimAgri — Colonnes :**
| Colonne | Description |
|---------|-------------|
| ☐ | Checkbox sélection |
| Matériel | Marque + Modèle + Type + icône |
| Puissance | En chevaux (ch.) |
| Utilisation quotidienne | X / Y (compteur usage) |
| Durée de vie | X / Y (heures) |
| Entretien | % + état (mensuel/annuel possible) |
| Assurance | Assuré / Non assuré |
| Emplacement | Chez moi / Ailleurs / En transit / Abrité / Non abrité |
| Actions | [Détail] [Réparer] [Vendre] [Casser] |

**SimAgri — Filtres matériels :**
- Par type (60+ types organisés en catégories)
- Par emplacement : Tous / En panne / Non abrité / Entretien mensuel / Entretien annuel / Non assuré / Chez moi / Ailleurs / En transit

**SimAgri — Catégories matériels (extraites) :**
1. Tracteur
2. Outil du sol non animé (Cultivateur, Déchaumeur, Charrue, Herse, Bineuse, Rouleau...)
3. Outil du sol animé (Herse rotative, Broyeur...)
4. Épandage (Épandeur fumier, Tonne lisier, Épandeur engrais...)
5. Semoir (Semoir, Semoir direct, Semoir maïs, Planteuse PDT...)
6. Pulvérisateur (Pulvérisateur, Automoteur, Arboricole...)
7. Matériel de récolte (Moissonneuse, Ensileuse, Arracheuse...)
8. Fenaison (Presse, Enrouleuse, Faucheuse, Faneuse, Andaineur)
9. Transport/chargement (Télescopique, Chargeur, Benne, Plateau, Remorque, Utilitaire)
10. Irrigation (Enrouleur, Pivot, Rampe)
11. Élevage (Tonne à eau, Dessileuse, Pailleuse, Mélangeuse, Bétaillère, Van...)

### 6.2 Actions groupées matériels

- Réparer tous les matériels cochés
- Mettre à la casse tous les matériels cochés
- Entretenir tous (mensuel)
- Entretenir tous (annuel)
- Assurer tous

### 6.3 Détail matériel

**SimAgri montre :**
- Marque, Modèle, Type, Puissance requise/fournie
- Photo du matériel
- Durée de vie (barre)
- État entretien
- Assurance (oui/non + coût)
- Emplacement actuel
- Historique d'utilisation
- Valeur de revente estimée
- Options installées (GPS, relevage avant...)
- Boutons : Réparer, Entretenir, Assurer, Vendre, Déplacer, Mettre à la casse

### 6.4 Achat matériel

**SimAgri — 4 modes d'achat :**
1. Occasion (marché entre joueurs)
2. Neuf (catalogue concessionnaire)
3. Marché privé (vente directe)
4. Pré-commandes

**Cultivia Phase 0 :**
1. Marché Central occasion (entre joueurs)
2. Concessionnaire neuf (catalogue fixe, marques réelles)
3. ETA Cultivia (PNJ, si pas de matériel = filet de sécurité)

### 6.5 Recherche par marque

**SimAgri :** Page dédiée avec dropdown marques → liste modèles

**Cultivia :** Filtre dans le catalogue : John Deere, Claas, New Holland, Fendt, Massey Ferguson, Case IH, Kubota, Deutz-Fahr


---

## 7. COMMERCE / MARCHÉ (`/market`)

### 7.1 Coopérative / Marché Central

**SimAgri — Structure :**
- Onglets : Animaux | Marchandises (type 1 = coop, type 2 = marché)
- Jours marché : régional (lun-mar-jeu-ven) / national (mer-sam-dim)
- Page fermée les jours sans marché avec message "Prochaine ouverture"

**Cultivia — Marché Central :**
- Consultation gratuite (0 HT), transaction = coût HT
- Toujours consultable, achat/vente selon jours
- Onglets : Marchandises | Animaux | Matériels

### 7.2 Annonces / Stock

**SimAgri pages :**
- `stock_liste_php` — Voir mes marchandises en stock
- `stock_annonce_php` — Consulter les annonces (autres joueurs)
- `stock_mes_annonces_php` — Mes annonces en cours
- `stock_liste_commande_php_l_1` — Commandes reçues
- `stock_liste_commande_php_l_2` — Commandes passées
- `produit_vendre_php` — Mettre en vente un produit

**Cultivia — Pages commerce :**
| Page | Route | Description |
|------|-------|-------------|
| Mon stock | `/stock` | Liste marchandises par bâtiment |
| Créer annonce | `/market/sell` | Formulaire : produit, quantité, prix, durée |
| Mes annonces | `/market/my-listings` | Liste avec statut (active/vendue/expirée) |
| Consulter annonces | `/market/browse` | Recherche + filtres + achat |
| Commandes reçues | `/market/orders/received` | Liste + statut + bouton expédier |
| Commandes passées | `/market/orders/sent` | Liste + statut + suivi |

### 7.3 Appels d'offres

**SimAgri :**
- Liste AO (animaux ou coopérative)
- Mes contrats AO
- Mes réponses AO (en attente / acceptées / refusées)

**Cultivia :**
| Page | Route |
|------|-------|
| Appels d'offres | `/market/tenders` |
| Créer un AO | `/market/tenders/create` |
| Mes contrats | `/market/tenders/my-contracts` |
| Mes réponses | `/market/tenders/my-bids` |

### 7.4 Transport marchandises

**SimAgri — Pages transport (12 pages) :**
- Mes camions, Atteler, Chauffeurs, Embaucher chauffeur
- Licences, Demandes, Propositions, Marges
- Classement, Statistiques, Carte

**Cultivia Phase 3 :**
- Transport simplifié : coût = distance (haversine) × tarif/km
- Pas d'activité transport joueur (Phase 4+)
- Page `/transport` : Demander un transport, Suivi livraisons, Historique

### 7.5 CAR (Coopérative Agricole Régionale)

**Déjà documenté dans UX_PHASE3_6.md** — Complet (création, dashboard, votes, stocks, contrats, emprunts, parts sociales). ✅ OK.

---

## 8. FINANCES (`/finances`)

### 8.1 Relevé bancaire

**SimAgri :** `compte_liste_php` — Tableau : Date | Libellé | Montant | Solde

**Cultivia :**
- Route : `/finances/ledger`
- Colonnes : Date | Catégorie | Libellé | Débit | Crédit | Solde
- Filtres : Par catégorie (vente, achat, entretien, salaire, prêt...), par période
- Export CSV

### 8.2 Épargnes

**SimAgri :**
- `compte_epargne_php` — Souscrire une épargne (durée, taux, montant)
- `compte_mes_epargne_php` — Mes épargnes en cours

**Cultivia :**
- `/finances/savings` — Liste épargnes + bouton souscrire
- Modale souscription : montant, durée (1/3/6 mois Cultivia), taux affiché

### 8.3 Prêts

**SimAgri :**
- `compte_pret_php` — Demander un prêt
- `compte_mes_pret_php` — Mes prêts en cours + remboursement

**Cultivia :**
- `/finances/loans` — Liste prêts + bouton demander
- Modale demande : montant (max 150 000€), durée, taux, mensualité calculée
- Bouton rembourser par anticipation

### 8.4 Parts sociales (CAR)

**SimAgri :** Voir/Acheter des parts dans la CAR

**Cultivia :** Intégré dans le dashboard CAR (`/car/:id` onglet Parts sociales). ✅ Déjà documenté.

---

## 9. EMPLOYÉS (`/employees`)

### 9.1 Pages employés

**SimAgri :**
- `employe_liste_php` — Mes employés (tableau : nom, compétence, salaire, HT fournis)
- `employe_embauche_php` — Embaucher (catalogue + coût)
- `employe_vente_pa_php` — Vendre mes PA (mettre PA en vente pour d'autres joueurs)

**Cultivia :**
| Page | Route | Boutons |
|------|-------|---------|
| Mes employés | `/employees` | [Licencier] [Modifier tâche] |
| Embaucher | `/employees/hire` | [Embaucher] (coût € + HT bonus/jour) |

Note : Pas de vente de HT entre joueurs dans Cultivia (simplification).

---

## 10. SOCIAL / MESSAGERIE

### 10.1 Messagerie

**SimAgri :**
- Boîte de réception (tableau : Sujet | Auteur | Date | Lu | Répondu)
- Messages envoyés
- Contacts
- Indésirables
- Actions : Nouveau message, Supprimer, Répondre, Transférer

**Cultivia :**
- `/messages` — Boîte de réception
- `/messages/sent` — Envoyés
- `/messages/compose` — Nouveau message (autocomplete joueur)
- Actions par message : Lire, Répondre, Supprimer, Signaler

### 10.2 Chat temps réel

**SimAgri :** MP-Live (chat privé entre joueurs, contacts, blocage)

**Cultivia :** WebSocket chat intégré dans sidebar droite
- Liste contacts en ligne (point vert)
- Conversations privées
- Bloquer un joueur

### 10.3 Amis

**SimAgri :** `ami_liste_php` — Liste d'amis avec statut en ligne

**Cultivia :** `/friends` — Liste amis + [Ajouter] [Retirer] [Envoyer message]

### 10.4 Fiche joueur publique

**SimAgri :** `fiche_presentation_php` — Profil public : pseudo, région, ancienneté, réputation, ferme

**Cultivia :** `/players/:id` — Pseudo, Préfecture, Ancienneté, Réputation, Spécialisation, Ferme visible

---

## 11. CLASSEMENTS (`/rankings`)

### 11.1 Pages classements SimAgri (15+ classements)

| Classement SimAgri | Cultivia |
|-------------------|----------|
| Palmarès général | ✅ `/rankings/general` |
| Classement cultures | ✅ `/rankings/crops` |
| Classement génétique | ✅ `/rankings/genetics` |
| Classement production (lait, viande...) | ✅ `/rankings/production` |
| Classement ETA | ✅ `/rankings/eta` |
| Classement concessionnaires | ❌ Phase 4+ |
| Classement CAR (achats/ventes) | ✅ `/rankings/car` |
| Classement CAR (financement) | ✅ `/rankings/car` |
| Classement CAR (stockage) | ✅ `/rankings/car` |
| Classement laiteries | ❌ Phase 4+ |
| Classement parrains | ❌ Pas de parrainage |
| Classement transport | ❌ Phase 4+ |
| Classement concours animaux | ✅ `/rankings/contests` |

### 11.2 Statistiques

**SimAgri :** Pages stats par domaine (parcelles, animaux, localisation)

**Cultivia :**
- `/stats/farm` — Stats globales ferme
- `/stats/crops` — Stats cultures (rendements, revenus)
- `/stats/animals` — Stats élevage (production, reproduction)
- `/stats/finances` — Stats financières (graphiques)

---

## 12. MÉTÉO (`/weather`)

**SimAgri :**
- Météo nationale : 4 zones climatiques
- 3 jours affichés : aujourd'hui, demain, après-demain (prévisions)
- Par zone : icône + température
- Types : Très ensoleillé, Ensoleillé, Mitigé, Pluie, Forte pluie

**Cultivia :**
- `/weather` — Page météo complète
- Par préfecture (pas par zone)
- 3 jours : aujourd'hui (réel), demain (réel), J+2 (prévision)
- Types : Ensoleillé, Nuageux, Pluie, Forte pluie, Gel, Sécheresse, Tempête
- Impact affiché : "Gel → risque perte cultures", "Sécheresse → irrigation recommandée"
- Widget header : icône + temp aujourd'hui/demain (toujours visible)

---

## 13. ÉVÉNEMENTS / BADGES / CONCOURS

**SimAgri :**
- Événements in-game (toggle on/off)
- Challenges (historique + en cours)
- Badges (collection à débloquer)
- Concours animaux (GénétiSim) : inscription, participation, gagnants
- Salons (GénétiSim, GénétIvrad, VitiSim)
- Tirage au sort

**Cultivia Phase 1-3 :**
- `/events` — Événements saisonniers (gel, sécheresse, tempête par préfecture)
- `/achievements` — Badges/succès (Phase 4+)
- Concours animaux → GénétiLab (Phase 4+)

---

## 14. PRÉFÉRENCES / PARAMÈTRES

**SimAgri :**
- `preference_activite_php` — Choix activités visibles
- `preference_notification_php` — Filtres notifications
- `favori_php` — Favoris (raccourcis)
- `inscrit_disponibilite_php` — Disponibilités (jours de jeu)

**Cultivia :**
- `/settings` — Page paramètres unique avec onglets :
  - Profil (nom, email, mot de passe)
  - Notifications (toggle par type)
  - Affichage (mode expert sol, thème clair/sombre)
  - Disponibilités
  - Confidentialité (profil public/privé)

---

## 15. ÉCRANS MANQUANTS IDENTIFIÉS

### 15.1 Manques dans nos docs UX actuelles

| Écran | Statut actuel | Priorité |
|-------|--------------|----------|
| Dashboard complet | ❌ Non spécifié | 🔴 Critique |
| Navigation globale (header + sidebar + onglets) | ❌ Non spécifié | 🔴 Critique |
| Widgets persistants (météo, solde, HT, notifs) | ❌ Non spécifié | 🔴 Critique |
| Liste bâtiments (colonnes, filtres, actions) | ❌ Non spécifié | 🔴 Critique |
| Liste matériels (colonnes, filtres, actions) | ❌ Non spécifié | 🔴 Critique |
| Détail matériel | ❌ Non spécifié | 🟡 Important |
| Achat matériel (neuf/occasion) | ❌ Non spécifié | 🟡 Important |
| Page météo complète | ❌ Non spécifié | 🟡 Important |
| Relevé bancaire | ❌ Non spécifié | 🟡 Important |
| Épargnes / Prêts | ❌ Non spécifié | 🟡 Important |
| Messagerie complète | ❌ Non spécifié | 🟡 Important |
| Chat temps réel | ❌ Non spécifié | 🟡 Important |
| Amis / Profil public | ❌ Non spécifié | 🟢 Normal |
| Classements (15 types) | ❌ Non spécifié | 🟢 Normal |
| Statistiques (4 domaines) | ❌ Non spécifié | 🟢 Normal |
| Paramètres / Préférences | ❌ Non spécifié | 🟢 Normal |
| Employés (liste + embauche) | ❌ Non spécifié | 🟡 Important |
| Bloc-notes personnel | ❌ Non spécifié | 🟢 Normal |
| Aide contextuelle / Guide | ❌ Non spécifié | 🟢 Normal |
| Événements saisonniers (page) | ❌ Non spécifié | 🟢 Normal |

### 15.2 Écrans déjà bien documentés ✅

| Écran | Doc |
|-------|-----|
| Inscription / Login / Setup ferme | UX_PHASE0_1.md ✅ |
| Choix kit démarrage | UX_PHASE0_1.md ✅ |
| Liste parcelles (5 onglets) | UX_PHASE0_1.md ✅ (partiel, complété ici) |
| Achat animal coopérative | UX_PHASE2.md ✅ |
| Liste animaux | UX_PHASE2.md ✅ |
| Fiche animal | UX_PHASE2.md ✅ |
| Nourrissage | UX_PHASE2.md ✅ |
| Reproduction / Insémination | UX_PHASE2.md ✅ |
| CAR (création, dashboard, votes) | UX_PHASE3_6.md ✅ |
| Contrats joueurs | UX_PHASE3_6.md ✅ |
| Marché à terme | UX_PHASE3_6.md ✅ |

### 15.3 Fonctionnalités SimAgri NON reprises dans Cultivia

| Feature SimAgri | Raison exclusion |
|----------------|-----------------|
| SimPass (abonnement payant) | Cultivia = Licence Pro (différent) |
| Packs options payantes | Pas de microtransactions Phase 0-3 |
| Ferme annexe / Déménagement | Phase 4+ |
| Maraîchage | Phase 4+ |
| Viticulture | Phase 4+ |
| Forêts / ETF joueur | Phase 4+ (ETA Cultivia PNJ suffit) |
| Fromagerie | Phase 4+ |
| Concessionnaire joueur | Phase 4+ |
| CIA joueur | Phase 4+ |
| Transport joueur | Phase 4+ |
| Foie gras | Non prévu |
| Méthanisation | Non prévu |
| Ferme en 3D | Non prévu |
| Sondages | Non prévu |
| Parrainage | Non prévu Phase 0-3 |

---

## RÉSUMÉ CHIFFRÉ

| Métrique | SimAgri | Cultivia (Phase 0-3) | Écart |
|----------|---------|---------------------|-------|
| Pages/écrans uniques | ~240 | ~86 documentés | +20 à ajouter |
| Onglets navigation | 6 + 11 activités | 5 onglets | Simplifié ✅ |
| Types bâtiments | 28 | 13 | Simplifié ✅ |
| Types matériels | 60+ | ~30 (Phase 0-1) | Progressif ✅ |
| Espèces animaux | 15 | 1 (Phase 2 = bovins) | Progressif ✅ |
| Classements | 15+ | 6 | Suffisant ✅ |
| Widgets dashboard | 12 | 10 | OK ✅ |
| Actions groupées | ~20 | ~15 | OK ✅ |

---

## PROCHAINES ÉTAPES

1. **Spécifier les 20 écrans manquants** (priorité 🔴 d'abord) dans les docs UX existantes
2. **Ajouter la navigation globale** dans le design system (05-design/)
3. **Spécifier les widgets WebSocket** du dashboard dans les specs Phase 0
4. **Valider avec le PO** les simplifications vs SimAgri
