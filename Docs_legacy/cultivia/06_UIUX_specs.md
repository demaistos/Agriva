# CULTIVIA — Spécifications UI/UX
## Version 2.1 — Mis à jour le 2026-04-09

> 324 actions → ~80 pages UI → ~27 DataTables avec groupes déroulants

---

# 1. PRINCIPES DE DESIGN

| Principe | Détail |
|----------|--------|
| Responsive | Desktop-first, responsive de base, mobile envisagé post-MVP |
| Centré tableau de bord | Toutes les infos critiques visibles d'un coup |
| Clics minimaux | Max 3 clics pour toute action courante |
| Retour immédiat | Toast notifications, animations, sons optionnels |
| Accessibilité | WCAG 2.1 AA, contraste, navigation clavier, screen reader |
| Mode sombre/clair | Thème sombre par défaut (jeu), clair optionnel |

---

# 2. DISPOSITION PRINCIPALE

```
┌──────────────────────────────────────────────────────┐
│ EN-TÊTE (fixe)                                        │
│ [Logo] [🏠Ferme] [🏗Bâtiments] [🐄Animaux]          │
│ [🚜Matériel] [🌾Parcelles] [🏪Coopérative]          │
│ [Activité ▼]  [☀18°C] [35 HT] [119 013€] [👤 ▼]   │
├──────────┬───────────────────────────────────────────┤
│ BARRE LATÉRALE  │ CONTENU PRINCIPAL                         │
│ (gauche) │                                           │
│          │  Varie selon la page active               │
│ Menu     │                                           │
│ contextuel│  Tableaux, formulaires, cartes,          │
│ selon    │  graphiques, listes d'animaux...          │
│ l'onglet │                                           │
│ actif    │                                           │
│          │                                           │
├──────────┴───────────────────────────────────────────┤
│ PIED DE PAGE                                               │
│ [Règles] [Aide] [Forum] [Contact] [Heure serveur]   │
└──────────────────────────────────────────────────────┘
```

### En-tête — Éléments permanents
| Élément | Données | Interaction |
|---------|---------|-------------|
| Saison/Date | "3 Mai - Saison 93 (printemps)" | Info-bulle calendrier |
| Météo | Icône + température | Clic → prévisions |
| HT restants | "35 HT" | Clic → détail employés, acheter HT |
| Solde | "119 013.72 €" | Clic → détail compte |
| Notifications | Badge rouge | Clic → liste notifications |
| Messagerie | Badge | Clic → boîte réception |
| MP-Live | Badge | Clic → chat instantané |
| Profil | Avatar + dropdown | Déconnexion, préférences, favoris |

---

# 3. PAGES PRINCIPALES

## 3.1 Tableau de bord (Accueil ferme)

### Implémenté (v1)
```
┌─────────────────────────────────────────────────────┐
│ HEADER: 🌾 Cultivia | Nav | 🌙 toggle | 👤 user ▾ │
├─────────────────────────────────────────────────────┤
│ Ma ferme 👋                    50 000 € | 35/35 HT │
│ 📍 Commune, Département                             │
├──────────────────────┬──────────────────────────────┤
│ 🐄 Animaux           │ 🏗 Bâtiments                 │
│ 5 (total)            │ 2 (total)                    │
│ ✅ Tous nourris      │ stabulation 200m² + hangar   │
├──────────────────────┼──────────────────────────────┤
│ 🌾 Parcelles         │ 🚜 Matériel                  │
│ 5 ha                 │ 3 (tracteur + benne + ...)   │
│ pré                  │ MF 5711, Benne 14T, Castor   │
└──────────────────────┴──────────────────────────────┘
```
- Données réelles via API `/api/dashboard?userId=`
- Tutoriel overlay 6 étapes au premier login (skip possible)
- Redirect vers `/setup` si ferme non configurée

### Wireframe cible (complet)
```
┌─────────────────────────────────────────┐
│ Bienvenue [PSEUDO] — [Région/Dept/Zone] │
│ Météo: ☀ Aujourd'hui / 🌧 Demain       │
├──────────────┬──────────────────────────┤
│ TÂCHES DU    │ ALERTES                  │
│ JOUR ☑       │ 🔴 Pas mangé: 12 bovins  │
│ ☑ Nourrir    │ 🔴 Pas bu: 0             │
│ ☐ Traire     │ 🟡 Malades: 0            │
│ ☐ Collecter  │ 💀 Morts: 0              │
│ ☐ Entretien  │ 🐣 Naissances: 2         │
│ Journée: 25% │                          │
├──────────────┼──────────────────────────┤
│ ÉCHÉANCES    │ RACCOURCIS               │
│ 📅 Prêt J-3  │ [Nourrir] [Traire]       │
│ 📅 DLC fro.  │ [Marché national]        │
│ 📅 Assurance │ [Transport: 470]         │
│ [Voir tout]  │ [+ Personnaliser]        │
├──────────────┴──────────────────────────┤
│ NOTIFICATIONS (50 dernières)            │
│ • Animaux pas mangé — 06/04 11:15      │
│ • ...                                   │
├──────────────┬──────────────────────────┤
│ RAPPORTS     │ GRAPHIQUE SOLDE          │
│ Pack du mois │ [Courbe 7 derniers jours]│
├──────────────┴──────────────────────────┤
│ ACTUALITÉS CULTIVIA                     │
└─────────────────────────────────────────┘
```

## 3.2 Page Animaux
```
┌─────────────────────────────────────────┐
│ MES ANIMAUX                             │
│ [Bovins] [Porcins] [Caprins] [Ovins]   │
│ [Lapins] [Volailles] [Pintades] [Oies] │
│ [Canards] [Bisons] [Daims] [Chevaux]   │
│ [Robot alimentation] [Œufs] [Coq]      │
├─────────────────────────────────────────┤
│ TABLEAU DE BORD                         │
│ ⚠ Pas mangé: 0  | ⚠ Pas bu: 0         │
│ 🏥 Malades: 0   | 💀 Morts: 0          │
│ 🐣 Naissances: 0| 📈 Grandissent: 0    │
│ 🚛 Bétaillère: 0| 🔍 Égarés: 0        │
│ 💧 Eau: Nécessaire 0L / Dispo 1000L    │
├─────────────────────────────────────────┤
│ [Nourrir ▼] [Abreuver] [Pailler]       │
│ [Retirer fumier] [Traire] [Œufs]       │
├─────────────────────────────────────────┤
│ LISTE PAR ESPÈCE (tableau triable)      │
│ Matricule | Race | Âge | Poids | Géné.  │
│ Actions: [Nourrir] [Vendre] [Déplacer]  │
└─────────────────────────────────────────┘
```

## 3.3 Page Parcelles
```
┌─────────────────────────────────────────┐
│ MES PARCELLES                           │
│ [Achat/Location] [Travaux] [Tableau bord]│
├─────────────────────────────────────────┤
│ Parcelle | Surface | Culture | Pousse%  │
│ Diode 🟢/🔴 | Sol (N,P,K) | Actions     │
│ [Semer] [Récolter] [Engrais] [Traiter] │
│ Jauges: ☀ [====] 🌧 [====]             │
└─────────────────────────────────────────┘
```

## 3.4 Page Matériel
```
┌─────────────────────────────────────────┐
│ MES MATÉRIELS                           │
│ Filtres: [Catégorie ▼] [Emplacement ▼] │
├─────────────────────────────────────────┤
│ Matériel | Marque | Usure | HVC | GPS  │
│ [Entretenir] [Vendre] [Réparer]        │
├─────────────────────────────────────────┤
│ ACHAT: [Neuf] [Occasion] [Enchères]    │
│ [Privé] [Hors région] [Collection]     │
└─────────────────────────────────────────┘
```

## 3.5 Ferme 3D (carte isométrique)
- Vue isométrique de la ferme
- Drag & drop bâtiments, accessoires, déco
- Mode placement / suppression / rotation
- Éléments : arbres, barrières, asphalte, herbe

## 3.6 Page Bâtiments


**Résumé en haut :** 🏠 nb bâtiments | ⚡ kWh/j total · €/mois

### Spec tableau bâtiments (réutilisable pour tous les tableaux du jeu)

**Layout :** `table-layout: fixed` — colonnes à largeur fixe en %, alignées sur toutes les lignes.

**Colonnes :**

| Colonne | Largeur | Contenu | Tri |
|---------|---------|---------|-----|
| Nom | 25% | Nom auto `Type-XXXX`, clic → panneau détail | ▲▼ alpha |
| Type | 18% | Badge icône + label (ex: 🐄 Stabulation) | ▲▼ alpha |
| Surface | 14% | Valeur + unité (ex: 200 m², 500 T, 10000 L) | ▲▼ num |
| Remplissage | 18% | Barre % + texte X/Y animaux (si élevage) | ▲▼ num |
| Niveau | 10% | Lettre énergie A-E (A=meilleur, E=basique) | ▲▼ num |
| Usure | 15% | Barre % colorée (vert→jaune→rouge) | ▲▼ num |

**Sections déroulantes :** `<details>` groupées par type avec badge compteur : 🐄 Stabulation (2), 🏗 Hangar (1)...

**Filtres :**
- Recherche globale 🔍 (debounce, full-text sur nom + type)
- Select filtre par type (dropdown trié A→Z par label)

**Tri :** Clic header → ASC, re-clic → DESC. Icône ▲▼ sur colonne active.

**Nom auto :** `Type-XXXX` généré à la construction (ex: Stabulation-4EX3).

**Panneau détail (clic ligne → inline sous la ligne) :**
- Bordure verte gauche (continuité visuelle)
- 3 cartes info : Surface (+ max), Niveau A-E, Énergie kWh/j + €/mois
- Capacité animaux X/Y + taille max du type
- Grille animaux (race ♀/♂, poids, santé ✅/🏥)
- Renommage inline ✏️
- Boutons actions avec `marginBottom: 6` pour espacement

**Actions avec modales de confirmation :**

| Action | Modale |
|--------|--------|
| 🔧 Entretenir | Avant/après usure (15%→5%, −10%), coût 0.3 HT |
| 🏢 Entretien externe | Avant/après usure (−25%), coût 500€, 0 HT |
| ⬆️ Améliorer | Niveau actuel→nouveau, ⚡ énergie actuelle→après (−X €/mois), coût, solde, message rouge si insuffisant |
| 📐 Agrandir | Slider jusqu'à taille max BDD, coût dynamique, solde, bouton rouge si insuffisant |
| ✅ Activer chargement | Aire/silo chargement uniquement |
| 🗑 Détruire | Bordure rouge, avertissements animaux, valeur/remboursement 10%/solde après |

**Accessoires :** Constructions indépendantes (D29). Construits via Construire → Accessoires. Apparaissent dans le tableau principal dans la section "Accessoire".

**Tailles max (BDD) :** Stabulation 1000m², Porcherie 600m², Poulailler 800m², Hangar 2000m², Silo 500T...

**Prix stockage (alignés SimAgri) :** Entrepôt 40€/m², Silo 10€/T, Fosse lisier 0.05€/L, Chambre froide 500€/m²

**Modale construction (3 étapes) :**
1. 🏗 Bâtiments / 🔌 Accessoires
2. Tableau `table-layout: fixed` (Type, Usage, Prix/unité, Énergie) — clic ligne → config
3. Slider capacité (adapté à l'unité) + niveau A-E (bâtiments) + récapitulatif coût/énergie/HT

**BDD :** `building_types` (30 types) : type, label, category, usage, unit, price_per_unit, energy_per_unit, capacity_per_animal, max_capacity

**À venir :** Facture énergie mensuelle détaillée

### Wireframe cible (complet)
```
┌─────────────────────────────────────────┐
│ MES BÂTIMENTS                           │
│ [Construire] [Accessoires] [Énergie]    │
├─────────────────────────────────────────┤
│ Type | Capacité | Remplissage | Usure%  │
│ Énergie kWh | Niveau équip. | Actions   │
│ [Agrandir] [Entretenir] [Détruire]     │
├─────────────────────────────────────────┤
│ FACTURE ÉNERGIE MENSUELLE               │
│ Total kWh: 1 240 | Coût: 99.20 €       │
└─────────────────────────────────────────┘
```

## 3.7 Page Finance
```
┌─────────────────────────────────────────┐
│ MON COMPTE                              │
│ Solde: 119 013.72 €                     │
├──────────────┬──────────────────────────┤
│ PRÊTS        │ ÉPARGNE                  │
│ En cours: 1  │ Compte 3 ans: 50 000 €  │
│ Restant: 45k │ Intérêts: 3 000 €       │
│ [Demander]   │ [Ouvrir] [Retirer]       │
├──────────────┴──────────────────────────┤
│ HISTORIQUE (DataTable filtrable)         │
│ Date | Catégorie | Libellé | +/- | Solde│
├─────────────────────────────────────────┤
│ HT: 35 restants | [Acheter] [Vendre]   │
│ Employés: 2 (+70 HT) | [Gérer]         │
└─────────────────────────────────────────┘
```

## 3.8 Page Transport
```
┌─────────────────────────────────────────┐
│ TRANSPORT                               │
│ [Mes véhicules] [Demandes] [Favoris]    │
├─────────────────────────────────────────┤
│ DEMANDES DISPONIBLES (DataTable)        │
│ Départ | Arrivée | Marchandise | km     │
│ Prix | [Accepter]                        │
├─────────────────────────────────────────┤
│ MES LIVRAISONS EN COURS                 │
│ [Charger] [Livrer]                      │
├─────────────────────────────────────────┤
│ Licence: Compte propre ✅               │
│ Chauffeurs: 1 (32 HT/j) | [Embaucher]  │
└─────────────────────────────────────────┘
```

## 3.9 Page Social
```
┌─────────────────────────────────────────┐
│ SOCIAL                                  │
│ [Amis] [Messages] [MP-Live] [Forum]    │
│ [Challenges] [Classements] [Loterie]    │
├─────────────────────────────────────────┤
│ MES AMIS (DataTable)                    │
│ Pseudo | Localisation | Niveau | Actions│
│ [Promouvoir] [Retirer] [Message]        │
├─────────────────────────────────────────┤
│ CHALLENGES ACTIFS                       │
│ Meilleur rendement blé — Fin: 12 Mai   │
│ [Participer] [Classement]              │
├─────────────────────────────────────────┤
│ BADGES: 12/45 débloqués [Voir tous]    │
└─────────────────────────────────────────┘
```

## 3.10 Page Concessionnaire
```
┌─────────────────────────────────────────┐
│ MA CONCESSION                           │
│ [Hall] [Atelier] [Dépôt-vente] [GPS]   │
├─────────────────────────────────────────┤
│ STOCK NEUF (DataTable)                  │
│ Matériel | Marque | Prix | Stock        │
│ [Vendre au client]                      │
├─────────────────────────────────────────┤
│ ATELIER — Réparations en cours          │
│ Client | Matériel | Avancement | Coût   │
├─────────────────────────────────────────┤
│ Licences: 100 pts | Vendeurs: 2         │
│ Pièces détachées | Location tracteurs   │
└─────────────────────────────────────────┘
```

## 3.11 Page CIA
```
┌─────────────────────────────────────────┐
│ MON CIA                                 │
│ [Labo] [Contrats] [GenBook] [IVRAD]    │
├─────────────────────────────────────────┤
│ STOCK SEMENCES                          │
│ Race | Mâle | Doses dispo | Prix dose   │
├─────────────────────────────────────────┤
│ CONTRATS ACTIFS                         │
│ Client | Race | Animal | Statut         │
│ [Prélever] [Inséminer]                 │
├─────────────────────────────────────────┤
│ IVRAD — Objectifs génétiques            │
│ Espèce | Race | Progression | Slots     │
└─────────────────────────────────────────┘
```

## 3.12 Page Fromagerie
```
┌─────────────────────────────────────────┐
│ MA FROMAGERIE (artisanale/industrielle) │
│ [Production] [Affinage] [Vente] [Stock]│
├─────────────────────────────────────────┤
│ PRODUCTION DU JOUR                      │
│ Lait dispo: 500L | [Transformer]        │
│ Type: Pâte molle croûte fleurie         │
├─────────────────────────────────────────┤
│ EN AFFINAGE (DataTable)                 │
│ Fromage | Type | Jour | DLC | Indices   │
├─────────────────────────────────────────┤
│ Crème: 18L [→ Beurre] | Hygiène: 95%   │
│ Fromagers: 2 | [Nettoyer] [Former]      │
└─────────────────────────────────────────┘
```

## 3.13 Page Viticulture
```
┌─────────────────────────────────────────┐
│ MON DOMAINE VITICOLE                    │
│ [Vignes] [Cave] [Vente] [Concours]     │
├─────────────────────────────────────────┤
│ MES PARCELLES DE VIGNE                  │
│ Parcelle | Cépage | Âge | État | Actions│
│ [Tailler] [Traiter] [Vendanger]         │
├─────────────────────────────────────────┤
│ CAVE — Vins en cours                    │
│ Vin | Cépage | Étape | Qualité          │
│ [Vinifier] [Assembler] [Embouteiller]   │
├─────────────────────────────────────────┤
│ FÛTS — Vieillissement                   │
│ Vin | Fût | Durée | Qualité estimée     │
├─────────────────────────────────────────┤
│ Personnel: Agent viticole, Maître chai  │
│ Budget: 350 000 € | [Embaucher]        │
└─────────────────────────────────────────┘
```

## 3.14 Page Maraîchage
```
┌─────────────────────────────────────────┐
│ MON MARAÎCHAGE                          │
│ [Cultures] [Serres] [Marchés] [Stock]  │
├─────────────────────────────────────────┤
│ MES CULTURES (DataTable)                │
│ Légume | Serre/Plein champ | Pousse%   │
│ DLC | [Récolter] [Traiter] [Emballer]   │
├─────────────────────────────────────────┤
│ MES SERRES                              │
│ Type | Surface | Chauffée | Température │
│ [Chauffer] [Semer]                      │
├─────────────────────────────────────────┤
│ Personnel: Chef culture + 3 ouvriers    │
└─────────────────────────────────────────┘
```

## 3.15 Page Forêts / ETF
```
┌─────────────────────────────────────────┐
│ MES FORÊTS                              │
│ [Stations] [Travaux] [Vente bois] [ETF]│
├─────────────────────────────────────────┤
│ STATIONS FORESTIÈRES (DataTable)        │
│ Station | Surface | Essence | Âge       │
│ Stade | Dernier travail | Actions       │
│ [Élaguer] [Éclaircir] [Couper]          │
├─────────────────────────────────────────┤
│ ETF — Prestations                       │
│ Client | Travail | Surface | Prix       │
└─────────────────────────────────────────┘
```

## 3.16 Page CAR
```
┌─────────────────────────────────────────┐
│ COOPÉRATIVE AGRICOLE RÉGIONALE          │
│ [Silos] [Huilerie] [Sucrerie]          │
│ [Laiterie] [Magasin] [Associés]        │
├─────────────────────────────────────────┤
│ STOCK CAR (DataTable)                   │
│ Produit | Quantité | Prix | Actions     │
├─────────────────────────────────────────┤
│ LAITERIE — Production                   │
│ [Yaourt] [UHT] [Pasteurisé] [Poudre]  │
├─────────────────────────────────────────┤
│ MAGASIN LIBRE-SERVICE                   │
│ 5 espaces | Stock | Ventes | [Gérer]   │
├─────────────────────────────────────────┤
│ Associés: 5/7 | Capital: 450 000 €     │
│ [Appels d'offres] [Contrats parcelle]   │
└─────────────────────────────────────────┘
```

## 3.17 Page CECA
```
┌─────────────────────────────────────────┐
│ CECA — Conseil Économique               │
│ [Élections] [Votes] [Résultats]        │
├─────────────────────────────────────────┤
│ REPRÉSENTANTS ACTUELS                   │
│ Région | Élu 1 | Élu 2 | Élu 3         │
├─────────────────────────────────────────┤
│ VOTES EN COURS                          │
│ Proposition | Type | Deadline | [Voter] │
├─────────────────────────────────────────┤
│ [Se porter candidat] (si 90j ancienneté)│
└─────────────────────────────────────────┘
```

## 3.18 Page Profil / Administration

### Implémenté (v1)
- Infos : pseudo, email, commune, solde, HT, nom de ferme
- Sections Sécurité et Préférences (placeholder)
- Accessible via dropdown 👤 dans le header

## 3.19 Page Setup (Configuration initiale)

### Implémenté
```
┌─────────────────────────────────────────────────────┐
│ 🌾 Configurez votre exploitation                     │
│ Choisissez votre pack de départ                      │
├─────────────┬─────────────┬─────────────────────────┤
│ 🐄 Bovin    │ 🐑 Ovin     │ 🐔 Aviculteur           │
│ 5 vaches PH │ 20 brebis   │ 50 poules Sussex        │
│ Stabulation │ Bergerie    │ Poulailler              │
│ + hangar    │ + hangar    │ + hangar                │
│ + tracteur  │ + tracteur  │ + tracteur              │
│ + benne     │ + benne     │ + benne                 │
│ + pailleuse │ + pailleuse │ + pailleuse             │
│ + 5ha pré   │ + 3ha pré   │ + 1ha pré               │
│ + ration 30j│ + ration 30j│ + ration 30j            │
│ + paille    │ + paille    │ + paille                │
│ + traite    │             │ + conditionnement œufs  │
│ 50 000 €    │ 50 000 €    │ 50 000 €                │
├─────────────┴─────────────┴─────────────────────────┤
│ [Lancer mon exploitation 🚀]                         │
└─────────────────────────────────────────────────────┘
```
- 3 packs complets pour tenir ~30 jours sans achat
- Détails chargés dynamiquement depuis GET /api/setup
- Création en transaction (bâtiments + matériel + animaux + parcelle + stocks)
- Redirect vers /dashboard après confirmation

## 3.20 Thème et Design System

### Implémenté
- **Light (défaut)** : beige paille (#f5f0e8), vert prairie (#4a7c3f), or blé (#8b6914), blanc crème (#fffdf7)
- **Dark** : terre nuit (#1a1a12), vert clair (#6aad5a), or (#c9a84c)
- Toggle 🌙/☀️ dans le header, persisté localStorage
- Variables CSS : --background, --foreground, --primary, --card, --border, --input-bg, --input-border, --danger, --header-bg/fg
- Transition douce 0.3s sur background/color

## 3.21 Page Inventaire / Stocks
```
┌─────────────────────────────────────────┐
│ MON PROFIL                              │
│ [Infos] [Sécurité] [Préférences]       │
├─────────────────────────────────────────┤
│ Pseudo: [________] | Avatar: [Changer] │
│ Ferme: [________]  | Commune: [______] │
├─────────────────────────────────────────┤
│ SÉCURITÉ                                │
│ [Changer mot de passe]                  │
├─────────────────────────────────────────┤
│ PRÉFÉRENCES                             │
│ Notifications: [✅ Email] [✅ In-game]  │
│ Thème: [Sombre ▼] | Langue: [FR ▼]    │
├─────────────────────────────────────────┤
│ [Désinscription]                        │
└─────────────────────────────────────────┘
```

## 3.21 Page Inventaire / Stocks
```
┌─────────────────────────────────────────┐
│ MON INVENTAIRE                          │
│ [Céréales] [Fourrages] [Engrais]       │
│ [Produits] [Matières premières] [Divers]│
├─────────────────────────────────────────┤
│ STOCKS (DataTable groupée par catégorie)│
│ Produit | Quantité | Emplacement | Unité│
│ Blé     | 45.2 T   | Silo A      | T   │
│ Foin    | 120 balles| Hangar B    | bal │
│ Lait    | 500 L    | Cuve à lait | L   │
│ Fumier  | 30 T     | Fosse       | T   │
├─────────────────────────────────────────┤
│ CAPACITÉ STOCKAGE                       │
│ Silos: 80% | Hangars: 45% | Cuves: 60% │
│ [Voir détail par bâtiment]              │
└─────────────────────────────────────────┘
```

## 3.22 Page Carte régionale
```
┌─────────────────────────────────────────┐
│ CARTE RÉGIONALE                         │
│ [Ma ferme] [Parcelles] [Joueurs]       │
│ [CAR] [Marchés] [Forêts]              │
├─────────────────────────────────────────┤
│ ┌─────────────────────────────────┐     │
│ │                                 │     │
│ │    Carte de France interactive  │     │
│ │    (zoom département/commune)   │     │
│ │                                 │     │
│ │  📍 Ma ferme                    │     │
│ │  🟢 Mes parcelles (5)          │     │
│ │  👤 Amis (3)                   │     │
│ │  🏭 CAR la plus proche: 12km   │     │
│ │                                 │     │
│ └─────────────────────────────────┘     │
│ Distance vers [commune]: __ km          │
└─────────────────────────────────────────┘
```

## 3.23 Page Journal de bord
```
┌─────────────────────────────────────────┐
│ JOURNAL DE BORD                         │
│ Filtres: [Aujourd'hui ▼] [Type ▼]     │
├─────────────────────────────────────────┤
│ HISTORIQUE ACTIONS (DataTable)          │
│ Heure | Action | Détail | HT | €       │
│ 08:12 | Nourrir bovins | 12 têtes | -2 │
│ 08:15 | Traire | 450L lait | -1        │
│ 09:00 | Vendre blé | 20T → 2000€ | -0.5│
│ 10:30 | Semer colza | Parcelle 3 | -3   │
├─────────────────────────────────────────┤
│ RÉSUMÉ JOURNÉE                          │
│ HT utilisés: 22/35 | €: +1 250         │
│ Actions: 14 | Alertes résolues: 3       │
└─────────────────────────────────────────┘
```

---

# 4. COMPOSANTS UI RÉUTILISABLES

| Composant | Usage |
|-----------|-------|
| `<DataTable>` | TOUS les tableaux du jeu (voir specs ci-dessous) |
| `<ResourceBar>` | HT, solde, météo (header) |
| `<AnimalCard>` | Fiche animal avec indices génétiques |
| `<ParcelCard>` | Fiche parcelle avec jauges |
| `<EquipmentCard>` | Fiche matériel avec usure/HVC |
| `<BuildingCard>` | Fiche bâtiment avec capacité |
| `<MarketTable>` | Tableau triable/filtrable annonces |
| `<ActionButton>` | Bouton action avec coût HT affiché |
| `<ConfirmDialog>` | Confirmation avant action irréversible |
| `<NotificationToast>` | Feedback action (succès/erreur) |
| `<ChatWidget>` | MP-Live flottant |
| `<WeatherWidget>` | Météo + prévisions |
| `<BalanceChart>` | Graphique évolution solde |
| `<GeneticRadar>` | Radar chart indices génétiques |
| `<CropCalendar>` | Calendrier semis/récolte par culture |
| `<MapIsometric>` | Vue 3D ferme |
| `<FormWizard>` | Formulaire multi-étapes (achat, construction) |

---

# 5. COMPOSANT `<DataTable>` — SPEC DÉTAILLÉE

**Règle absolue** : TOUS les tableaux du jeu utilisent ce composant unique. Aucune exception.

## 5.1 Fonctionnalités obligatoires

### Recherche globale
```
┌─────────────────────────────────────────────┐
│ 🔍 Rechercher...              [Filtres ▼]   │
└─────────────────────────────────────────────┘
```
- Champ de recherche en haut du tableau
- Recherche full-text sur toutes les colonnes visibles
- Debounce 300ms
- Highlight des termes trouvés dans les cellules

### Tri bidirectionnel
- Clic sur header de colonne → tri ASC
- Re-clic → tri DESC
- Re-clic → pas de tri (état initial)
- Icône ▲▼ sur la colonne triée
- Tri multi-colonnes avec Shift+clic

### Colonnes configurables
```
┌──────────────────────────────────────────┐
│ ⚙ Colonnes visibles                     │
│ ☑ Matricule    ☑ Race     ☑ Âge         │
│ ☑ Poids        ☐ Croissance  ☐ Lait     │
│ ☑ Santé        ☐ QL       ☑ Actions     │
│                        [Réinitialiser]   │
└──────────────────────────────────────────┘
```
- Bouton ⚙ ouvre un dropdown avec checkboxes
- Le joueur coche/décoche les colonnes à afficher
- Préférences sauvegardées en localStorage (par tableau)
- Bouton "Réinitialiser" pour revenir aux colonnes par défaut
- Drag & drop pour réordonner les colonnes

### Filtres par colonne
- Clic sur icône filtre dans le header → popover de filtre
- **Texte** : contient, commence par, exact
- **Nombre** : =, >, <, entre X et Y
- **Enum** : checkboxes (ex: race = Charolaise ☑, Limousine ☑)
- **Date** : avant, après, entre
- Filtres combinables (AND)
- Badge indiquant le nombre de filtres actifs

### Pagination
```
Affichage 1-50 sur 1 247  |  [◀] [1] [2] ... [25] [▶]  |  Par page: [50 ▼]
```
- 25 / 50 / 100 / Tout
- Navigation première/dernière page

### Groupement par catégorie (accordéon)
Tous les tableaux avec des données catégorisables affichent des **groupes déroulants/enroulants** :

```
┌─────────────────────────────────────────────────────┐
│ 🔍 Rechercher...                     [⚙ Colonnes]  │
├─────────────────────────────────────────────────────┤
│ ▼ Bovins (24 animaux)                          [−]  │
│   Matricule | Race       | Âge  | Poids | Santé    │
│   #001      | Charolaise | 3 ans| 750kg | ✅       │
│   #002      | Limousine  | 2 ans| 620kg | ✅       │
│   ...                                              │
├─────────────────────────────────────────────────────┤
│ ▶ Porcins (156 animaux)                       [+]  │
├─────────────────────────────────────────────────────┤
│ ▶ Volailles (3 200 animaux)                   [+]  │
├─────────────────────────────────────────────────────┤
│ ▼ Caprins (18 animaux)                        [−]  │
│   Matricule | Race    | Âge    | Poids | Santé     │
│   #045      | Alpine  | 1 an   | 55kg  | ✅       │
│   ...                                              │
└─────────────────────────────────────────────────────┘
  [Tout déplier] [Tout replier]
```

- Clic sur le header du groupe → toggle ouvert/fermé
- Badge avec le nombre d'éléments dans le groupe
- Boutons "Tout déplier" / "Tout replier"
- État ouvert/fermé sauvegardé en localStorage
- La recherche et les filtres s'appliquent à l'intérieur des groupes
- Un groupe vide (après filtrage) est masqué

**Groupement par tableau :**

| Tableau | Groupé par |
|---------|-----------|
| Animaux | Espèce (Bovins, Porcins, Caprins...) |
| Matériel | Famille (Motorisé, Travail du sol, Transport...) |
| Bâtiments | Type (Élevage, Stockage, Accessoire...) |
| Parcelles | Type (Champ, Pré, Verger, Maraîchage) |
| Historique compte | Mois |
| Annonces stock | Catégorie (Céréales, Fourrages, Engrais, Divers) |
| Matériel en vente | Famille |
| Marché animaux | Espèce |
| Commandes ETA | Statut (En attente, En cours, Terminé) |
| Messagerie | Lu / Non lu |

### Sélection
- Checkbox par ligne + "Tout sélectionner"
- Actions groupées sur la sélection (ex: nourrir tous, vendre tous)

### Export
- Bouton [📥 Exporter] → CSV ou clipboard

## 5.2 Stack technique DataTable
- **TanStack Table v8** (headless, type-safe)
- **Composant Shadcn/UI Table** pour le rendu
- **Hook custom** `useDataTable(config)` qui encapsule tout
- **Persistance** : `localStorage` pour colonnes visibles + tri + page size

## 5.3 Tableaux du jeu utilisant `<DataTable>`

| Page | Tableau | Colonnes par défaut |
|------|---------|---------------------|
| Animaux | Liste animaux | Matricule, Race, Sexe, Âge, Poids, Santé, Bâtiment, Actions |
| Animaux | Marché régional/national | Vendeur, Race, Sexe, Âge, Poids, Génétique, Prix, Acheter |
| Animaux | Appels d'offres | Usine, Espèce, Race, Quantité, Durée, Répondre |
| Animaux | Carcasses stats | Espèce, Race, Conformation, Engraissement, Montant |
| Parcelles | Mes parcelles | Nom, Surface, Culture, Pousse%, Sol, Eau, Soleil, Actions |
| Parcelles | Parcelles en vente | Localisation, Surface, Prix, Type, Qualité, Acheter |
| Matériel | Mon matériel | Nom, Marque, Usure%, HVC, GPS, Emplacement, Actions |
| Matériel | Matériel en vente | Nom, Marque, État, Prix, Vendeur, Acheter |
| Matériel | Enchères en cours | Nom, Marque, Mise actuelle, Fin enchère, [Enchérir] |
| Bâtiments | Mes bâtiments | Type, Capacité, Remplissage, Usure%, Énergie, Actions |
| Finance | Historique compte | Date, Catégorie, Libellé, Débit, Crédit, Solde |
| Transport | Demandes transport | Départ, Arrivée, Marchandise, Distance, Prix, Accepter |
| Coopérative | Annonces stock | Produit, Quantité, Prix, Vendeur, Région, Acheter |
| ETA | Commandes | Client, Travail, Parcelle, Surface, Statut, Actions |
| CIA | GenBook | Mâle, Race, CIA, Stock, Prix dose, Commander |
| CIA | Objectifs IVRAD | Espèce, Race, Progression, Slots débloqués |
| Fromagerie | En affinage | Fromage, Type, Jour affinage, DLC, Indices qualité |
| Viticulture | Cave — Vins | Vin, Cépage, Étape, Qualité, Fût, Actions |
| Maraîchage | Cultures | Légume, Serre/Plein champ, Pousse%, DLC, Actions |
| Forêts | Stations | Station, Surface, Essence, Âge, Stade, Actions |
| CAR | Stock coopérative | Produit, Quantité, Prix, Origine, Actions |
| CECA | Votes en cours | Proposition, Type, Deadline, Votes pour/contre, [Voter] |
| Classements | Tous | Rang, Joueur, Valeur, Région |
| Social | Amis | Pseudo, Localisation, Niveau ami, Depuis, Actions |
| Social | Messagerie | Expéditeur, Objet, Date, Lu, Actions |
| Concessionnaire | Stock neuf | Matériel, Marque, Prix, Stock, [Vendre] |
| Concessionnaire | Atelier | Client, Matériel, Avancement%, Coût, Actions |
| Inventaire | Stocks | Produit, Quantité, Emplacement, Unité, Catégorie |
| Journal | Historique actions | Heure, Action, Détail, HT consommés, € impact |

---

# 6. FLOWS UTILISATEUR CLÉS

## Parcours : Inscription / Création de ferme
```
Page d'accueil (🌾 Cultivia + 2 boutons) → "Créer mon exploitation"

→ Étape 1/3 : Identifiants
  - Labels au-dessus des champs (contraste élevé)
  - Pseudo (min 3 car.) + Email + Mot de passe (min 8 car.)
  - Validation côté client avant passage à l'étape suivante
  - Fond carte (--card), bordures inputs visibles (--input-border)

→ Étape 2/3 : Localisation (layout 2 colonnes)
  - GAUCHE : Carte SVG de France (13 régions métropolitaines)
    - Contours réels (GeoJSON france-geojson converti en SVG)
    - Hover : surbrillance or blé (--secondary)
    - Clic : sélection vert prairie (--primary)
    - Régions se touchent (stroke 0.5px, strokeLinejoin round)
    - Corse séparée (île)
  - DROITE : Panneau de sélection
    - Breadcrumb cliquable : 🗺️ France › Région › Département
    - Barre de recherche filtrable
    - Départements : cartes avec initiales colorées, hover vert
    - Communes : icônes 🏛️ préfecture / 🏘️ sous-préfecture
      - Population affichée sous le nom
      - Badge vert nb joueurs si > 0
      - Checkmark ✓ sur la sélection
    - Fiche résumé commune sélectionnée en bas du panneau
  - Données : 101 préfectures + 2 162 sous-préfectures (communes > 5000 hab)

→ Étape 3/3 : Récapitulatif
  - 👤 Pseudo, 📧 Email, 📍 Commune — Département, Région
  - 💰 50 000 € de départ, ⏱ 35 HT/jour
  - Bouton "Créer mon exploitation 🚀"
  - Création en transaction (user + user_profile avec commune_id)
  - Redirect vers /login après succès

→ Connexion → Dashboard
```

## Parcours : Nourrir les animaux
```
Tableau de bord → Alertes "Pas mangé" → Clic
→ Page Animaux → Sélectionner espèce
→ Bouton "Nourrir" → Modal choix ration (standard ou libre)
→ Confirmer (affiche coût HT) → Notification "Nourri ✅"
→ HT déduits, alerte disparaît
```

## Parcours : Semer une parcelle
```
Parcelles → Sélectionner parcelle (diode 🟢)
→ Étape affichée: "Semer"
→ Choisir culture (filtré par saison + rotation)
→ Choisir technique (Traditionnelle/TCS/Direct)
→ Sélectionner matériel (ou appeler ETA)
→ Confirmer → HT déduits → Pousse commence
```

## Parcours : Acheter un animal
```
Animaux → Marché → [Régional/National/Négociant]
→ Filtrer (espèce, race, élevage)
→ Clic animal → Fiche détaillée (génétique radar)
→ "Acheter" → Vérifier bétaillère dispo
→ Confirmer → Animal dans enclos d'arrivage
```

## Parcours : Vendre animal sur marché
```
Animaux → Sélectionner animal(s) → "Vendre"
→ Choisir canal: [Abattoir] [Marché régional] [Marché national] [Privé]
→ Si marché: Fixer prix → Confirmer mise en vente
→ Si abattoir: Aperçu prix estimé → Confirmer → Argent crédité
→ Si privé: Sélectionner ami spécial → Fixer prix → Envoyer offre
```

## Parcours : Acheter matériel aux enchères
```
Matériel → Achat → [Enchères]
→ DataTable enchères en cours (tri par fin enchère)
→ Clic matériel → Fiche détaillée + historique enchères
→ Saisir montant → [Enchérir]
→ Notification si surenchéri / si gagné
```

## Parcours : Gérer épargne
```
Finance → Épargne → [Ouvrir] ou [Retirer]
→ Ouvrir: Choisir durée (1/3/5 ans) → Montant → Confirmer
→ Retirer: Avertissement perte intérêts si anticipé → Confirmer
→ Solde mis à jour
```
