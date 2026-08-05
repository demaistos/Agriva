# SDD 01 — Module Core (Auth, Joueurs, Temps, Heures de travail, Serveurs)

## 0. Navigation et parcours joueur

### Sidebar principale
| Icône | Page | Route | Sous-pages | Statut |
|-------|------|-------|------------|--------|
| 🏠 | Mon bureau | `/` | Dashboard, alertes, résumé, météo 3j | ✅ |
| 🌾 | Parcelles | `/parcels` | Mes parcelles, travaux | 📝 |
| 🏗️ | Bâtiments | `/buildings` | Construire, gérer, accessoires | ✅ |
| 🐔 | Élevage | `/animals` | Mes animaux, Œufs ↗, Grossiste ↗, Aliments ↗ | ✅ |
| 🏪 | Marché | `/market` | Coopérative, Grossiste animaux | ✅ |
| 🚜 | Matériel | `/equipment` | Mon matériel, acheter | ✅ |
| 🥚 | Œufs | `/eggs` | Production, équipement, stock, vente | ✅ |
| 🌤️ | Météo | `/meteo` | Carte France, prévisions 7j, toutes zones | ✅ |
| 🚛 | Transport | — | V2 | ❌ |
| 💬 | Messages | — | V2 | ❌ |
| 🏆 | Classements | — | V2 | ❌ |

### Parcours débutant type (élevage volaille)
1. **Bâtiments** → construire un poulailler + un silo + une salle de conditionnement
2. **Matériel** → acheter un tracteur + une benne + une bétaillère
3. **Marché > Grossiste** → acheter des poules (tracteur + bétaillère requis)
4. **Animaux** → déplacer les poules dans le poulailler
5. **Marché > Coopérative** → acheter de la ration volaille (tracteur + benne requis) → stockée dans le silo
6. **Œufs** → installer un robot ramassage dans le poulailler
7. **Attendre** → le worker nourrit les poules (consomme le stock), les poules pondent (si robot + salle)
8. **Œufs** → vendre les œufs par calibre
9. **Animaux** → vendre les poules de réforme à l'abattoir
10. **Répéter** → racheter des poules, racheter de l'aliment

### Parcours débutant type (élevage viande)
1. **Bâtiments** → construire un poulailler + un silo
2. **Matériel** → acheter un tracteur + une benne + une bétaillère
3. **Marché > Grossiste** → acheter des poulets Cou Nu (chair)
4. **Animaux** → déplacer dans le poulailler
5. **Marché > Coopérative** → acheter de la ration volaille
6. **Attendre** → les poulets grandissent (50-60 jours de jeu)
7. **Animaux** → vendre à l'abattoir (poids adulte × prix/kg × revenue_multiplier)

## 0b. Règles UX globales (toutes modales d'action)

Ces règles s'appliquent à TOUTES les pages et modales de jeu (bâtiments, animaux, matériel, cultures, etc.) :

### Modales
1. **Heures de travail** : afficher `Xh / Yh disponibles`. Si X > Y → texte rouge + bouton désactivé
2. **Solde** : afficher le coût total + solde dispo. Si coût > solde → texte rouge + bouton désactivé
3. **Validation** : le bouton "Confirmer" est désactivé tant qu'une condition n'est pas remplie
4. **Erreurs serveur** : affichées dans un bandeau `.alert` sous la modale
5. **Après action** : recharger `store.loadAll()` + `store.loadPlayer()` pour rafraîchir solde et heures
6. **Design** : utiliser `ConfirmModal` avec variant (green=action, orange=attention, red=destruction)
7. **Coût** : bloc `.modal-cost` avec `.modal-cost-label`, `.modal-cost-value`, `.modal-cost-pa`

### Tableaux (DataTable)
8. **ID unique** : tout objet de jeu a un `short_id` global unique (séquence `global_short_id_seq`)
9. **Nom par défaut** : `Race-ShortID` pour animaux, `Type-ShortID` pour bâtiments
10. **Colonnes** : toujours séparer ID, Nom (cliquable → renommer), Type, et les attributs
11. **Sélection multi** : tous les DataTable supportent la sélection multi (checkbox + clic ligne). Actions groupées spécifiques par module
12. **Barre d'actions** : sticky en bas, fond vert dégradé, texte blanc, apparaît quand sélection active
13. **Décimales** : 1 décimale pour les m², poids (kg), jauges (%)

### Navigation
14. **Sub-nav** : barre d'onglets horizontale sous le titre pour les sous-pages d'un module (ex: Mes animaux / Grossiste)
15. **Filtres** : dans une card blanche séparée avec labels uppercase, selects avec fond beige

### Transport
18. **Tout déplacement de ressources ou d'animaux nécessite un attelage** : tracteur + remorque adaptée
19. **Compatibilité CV** : la remorque a un `required_hp`, le tracteur un `horsepower`. Le tracteur doit avoir `horsepower >= required_hp`
20. **Types de remorques** par produit :
    - `benne` : céréales, rations, aliments
    - `plateau` : paille, foin, matériaux
    - `betaillere` : animaux
    - `citerne` : eau, lait
21. **Trajets multiples** : si quantité > capacité remorque → `trips = ⌈quantité / capacité⌉`
22. **Coûts par trajet** : 1h de travail + 0.5% usure sur tracteur ET remorque, × nombre de trajets
23. **Distance coopérative** : 20 km fixe (aller-retour 40 km)
24. **Sélection véhicule** : le joueur choisit son tracteur puis sa remorque (filtrée par CV). Bouton désactivé si équipement manquant ou incompatible
25. **Équipement cassé** : un tracteur ou remorque `is_broken = true` ne peut pas être utilisé

### Serveur
26. **Difficulté** : le `hours_multiplier` est appliqué automatiquement dans `consumeHours()`. Le `penalty_multiplier` dans les ticks worker
27. **Ratio temps** : 1 jour réel = 7 jours de jeu (`servers.time_ratio`). Tous les effets worker × ratio

## 1. Authentification

### Tables
```sql
users (
  id            UUID PRIMARY KEY,
  email         VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  created_at    TIMESTAMP DEFAULT NOW(),
  is_banned     BOOLEAN DEFAULT FALSE
)

sessions (
  id         UUID PRIMARY KEY,
  user_id    UUID REFERENCES users,
  token      VARCHAR NOT NULL,
  expires_at TIMESTAMP
)
```

### Endpoints
| Méthode | Route | Description |
|---------|-------|-------------|
| POST | /auth/register | Inscription |
| POST | /auth/login | Connexion → JWT |
| POST | /auth/logout | Déconnexion |
| GET | /auth/me | Profil connecté |

### Règles
- 1 compte par personne par serveur
- Email unique, mot de passe hashé bcrypt (12 rounds)
- JWT expire 7 jours, refresh token 30 jours

---

## 2. Serveurs de jeu

### Table
```sql
servers (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR NOT NULL,        -- "France 1", "Belgique 1"...
  slug        VARCHAR UNIQUE NOT NULL,  -- "france1", "belgique1"
  country     VARCHAR NOT NULL,
  difficulty  INT CHECK (1..5),
  max_parcel_size INT DEFAULT 50,      -- hectares max par parcelle
  is_expert   BOOLEAN DEFAULT FALSE,
  config      JSONB                     -- races exclusives, spécificités
)
```

### Données seed
8 serveurs : France 1/2/3, Belgique 1, Suisse 1, Canada 1, USA 1, Expert.

| Serveur | Parcelle max | Difficulté | Spécificités |
|---------|-------------|-----------|-------------|
| France 1/2/3 | 50 ha | 3 | Standard |
| Belgique 1 | 50 ha | 3 | Standard |
| Suisse 1 | 50 ha | 3 | Standard |
| Canada 1 | 200 ha | 4 | Race Ayrshire, seigle, matériels nord-américains |
| USA 1 | 200 ha | 4 | Races exclusives (bovin, caprin, ovin, porcin, volaille, canard), coton |
| Expert | 50 ha | 5 | Main d'œuvre limitée |

---

## 3. Joueurs (Exploitations)

### Table
```sql
players (
  id          UUID PRIMARY KEY,
  user_id     UUID REFERENCES users,
  server_id   INT REFERENCES servers,
  name        VARCHAR NOT NULL,
  region_id   INT REFERENCES regions,
  department_id INT REFERENCES departments,
  commune_id  INT REFERENCES communes,
  zone        INT DEFAULT 1,              -- legacy, kept for compatibility
  balance     DECIMAL(15,2) DEFAULT 100000,
  savings     DECIMAL(15,2) DEFAULT 0,
  hours_today DECIMAL(5,2) DEFAULT 8,
  hours_max  DECIMAL(5,2) DEFAULT 8,
  simpass     BOOLEAN DEFAULT FALSE,
  simpass_expires DATE,
  created_at  TIMESTAMP DEFAULT NOW(),
  seniority_days INT DEFAULT 0,
  UNIQUE(user_id, server_id)
)
```

### Endpoints
| Méthode | Route | Description |
|---------|-------|-------------|
| POST | /players | Créer exploitation (choix région/département/commune) |
| GET | /players/me | Ma ferme |
| GET | /players/:id | Voir une ferme |
| PATCH | /players/me | Modifier profil |
| DELETE | /players/me | Désinscription |

---

## 4. Géographie

### Tables
```sql
regions (
  id         SERIAL PRIMARY KEY,
  server_id  INT REFERENCES servers,
  name       VARCHAR NOT NULL,
  meteo_zone VARCHAR NOT NULL  -- 'océanique', 'océanique-dégradé', 'semi-continental', 'continental', 'méditerranéen'
)

departments (
  id        SERIAL PRIMARY KEY,
  region_id INT REFERENCES regions,
  name      VARCHAR NOT NULL,
  code      VARCHAR(3) NOT NULL,   -- code département (01, 02, ... 2A, 2B, ... 95)
  chef_lieu VARCHAR NOT NULL       -- préfecture (ex: Caen, Paris, Lyon...)
)

communes (
  id            SERIAL PRIMARY KEY,
  department_id INT REFERENCES departments(id) NOT NULL,
  name          VARCHAR(100) NOT NULL,
  is_prefecture BOOLEAN DEFAULT FALSE,
  UNIQUE(department_id, name)
)
```

### Communes
Chaque département contient ses préfectures et sous-préfectures réelles (324 communes au total pour 96 départements métropolitains). Le joueur choisit sa commune à l'inscription au lieu d'une zone abstraite 1-10.

Exemple pour le Calvados (14) :
- 🏛️ Caen (préfecture)
- 🏘️ Bayeux
- 🏘️ Lisieux
- 🏘️ Vire

### Zones climatiques
5 zones climatiques françaises réalistes :

| Zone | Régions |
|------|---------|
| `océanique` | Bretagne, Normandie, Pays de la Loire, Nouvelle-Aquitaine |
| `océanique-dégradé` | Hauts-de-France, Île-de-France, Centre-Val de Loire |
| `semi-continental` | Bourgogne-Franche-Comté, Auvergne-Rhône-Alpes |
| `continental` | Grand Est |
| `méditerranéen` | Occitanie, PACA, Corse |

### Zones
Chaque département a ses communes (préfectures + sous-préfectures). La distance entre joueurs se calcule entre communes du même département ou entre départements.

### Météo
Voir [01b-meteo.md](01b-meteo.md) pour le système météo complet (températures, prévisions 7 jours, alertes, carte de France).

---

## 5. Système temporel

### Table
```sql
game_time (
  server_id    INT PRIMARY KEY REFERENCES servers,
  current_day  INT DEFAULT 1,          -- jour dans la saison (1-84)
  current_month INT DEFAULT 1,         -- mois SimAgri (1-12)
  current_season VARCHAR DEFAULT 'printemps',
  season_number INT DEFAULT 1          -- numéro de saison depuis le début
)
```

### Logique Tick
```
Chaque jour réel à 00:00 UTC :
  1. game_time.current_day++
  2. Si current_day % 7 == 0 → nouveau mois SimAgri
  3. Si current_day % 21 == 0 → nouvelle saison
  4. Si current_day % 84 == 0 → nouvelle année SimAgri
  5. Reset heures de tous les joueurs à hours_max
  6. Incrémenter seniority_days de tous les joueurs
```

### Mapping mois
| Jours réels | Mois SimAgri | Saison |
|-------------|-------------|--------|
| 1-7 | Janvier | Hiver |
| 8-14 | Février | Hiver |
| 15-21 | Mars | Printemps |
| 22-28 | Avril | Printemps |
| 29-35 | Mai | Printemps |
| 36-42 | Juin | Été |
| 43-49 | Juillet | Été |
| 50-56 | Août | Été |
| 57-63 | Septembre | Automne |
| 64-70 | Octobre | Automne |
| 71-77 | Novembre | Automne |
| 78-84 | Décembre | Hiver |

---

## 6. Points d'Action (PA)

### Service Heures de travail
```
function consumePA(player_id, amount):
  player = getPlayer(player_id)
  if player.hours_today < amount:
    throw "PA insuffisants"
  player.hours_today -= amount
  save(player)

function calculateTravelPA(zone_from, zone_to):
  return 0.25 + (|zone_from - zone_to| * 0.25)
```

### Coûts PA principaux
| Action | PA |
|--------|-----|
| Déplacement par zone | 0.25 |
| Entretien bâtiment/mois | 0.3 |
| Entretien matériel/mois | 1.0 |
| Nourrir animaux | Variable selon nombre |
| Travail parcelle | Variable selon surface + matériel |

---

## 7. Employés

### Table
```sql
employees (
  id         UUID PRIMARY KEY,
  player_id  UUID REFERENCES players,
  name       VARCHAR,
  pa_per_day DECIMAL(5,2) DEFAULT 25,
  salary     DECIMAL(10,2) DEFAULT 1400,  -- par mois SimAgri
  hired_at   TIMESTAMP
)
```

L'employé ajoute ses heures au hours_max du joueur. Salaire déduit chaque mois SimAgri.

---

## 8. CFSA (Centre de Formation SimAgri)

### Règles
- **Stagiaire** : demande dans les 14 premiers jours d'inscription
- **Maître-exploitant** : ancienneté min 168 jours (24 semaines), max stagiaires selon ancienneté (1-5)
- **Durée** : 42 jours
- **Bonus stagiaire** : +4 jours SimPass + 25 000€ aide (si SimPass activé avant fin)
- **Bonus maître** : +4 jours SimPass

---

## 9. Configuration initiale

À l'inscription, le joueur reçoit :
- Budget initial : 100 000€ (serveur facile)
- Choix région → département → commune (préfecture ou sous-préfecture)
- 1 bâtiment de départ
- Matériel de base
- Pas de délai de construction pour les 10 premiers bâtiments


---

## Économie de départ & difficulté serveur

### Budget initial joueur
| Paramètre | Valeur |
|-----------|--------|
| Solde de départ | Défini par le serveur (100 000€ sur serveur facile) |
| Prêt JA disponible | Défini par le serveur (150 000€ sur serveur facile) |
| Aide CESA | 50 000€ (subvention après formation en jeu, tous serveurs) |

### Multiplicateurs par difficulté serveur
| Difficulté | Solde départ | Prêt dispo | Revenus | Prix achat |
|-----------|-------------|-----------|---------|-----------|
| 1 (facile) | 100 000€ | 150 000€ | ×1.5 | ×1.0 |
| 2 (normal) | 80 000€ | 120 000€ | ×1.0 | ×1.0 |
| 3 (difficile) | 60 000€ | 100 000€ | ×0.8 | ×1.1 |
| 4 (expert) | 50 000€ | 80 000€ | ×0.6 | ×1.2 |

Le multiplicateur de revenus s'applique à : vente de récoltes, vente de lait, vente d'animaux, prestations ETA/transport.
Le multiplicateur de prix d'achat s'applique à : matériel neuf, animaux au marché, semences, engrais.
Les prix de construction des bâtiments restent fixes (coût réel).

### Parcours type débutant (serveur facile)
```
Départ : 100 000€
  → Poulailler 200m² (40 000€) + 200 poules (3 000€) + petit tracteur (15 000€)
  → Reste 42 000€ pour parcelle + aliment + fonctionnement
  → Revenus œufs dès la 1ère semaine

OU avec prêt :
  → Stabulation 200m² (120 000€) + 20 vaches (30 000€) + salle traite (24 000€)
  → Total 174 000€ → prêt de 74 000€
  → Revenus lait réguliers pour rembourser
```


---

## Points d'Action (PA) — Système de travail

### Principe
- Chaque joueur a un quota de 8h de travail/jour
- Chaque action consomme des heures → simule le temps de travail
- Les heures se régénèrent chaque jour de jeu

### Ratio temps
- **1 jour réel = 7 jours de jeu** (`servers.time_ratio = 7`)
- Le worker daily tick applique tous les effets × ratio (usure, énergie, faim, santé)
- Le weekly tick avance `game_time.current_day` de 7 jours

**Impact sur les durées de jeu :**
| Événement | Jours de jeu | Jours réels |
|-----------|-------------|-------------|
| Gestation vache | 280 | 40 |
| Gestation truie | 115 | 16 |
| Couvaison poule | 21 | 3 |
| Gestation jument | 340 | 49 |
| Gestation brebis | 150 | 21 |
| Gestation lapine | 31 | 4 |

### Difficulté serveur

| Difficulté | revenue_multiplier | hours_multiplier | penalty_multiplier | Effet |
|-----------|-------------------|-----------------|-------------------|-------|
| Facile (1) | ×1.5 | ×0.7 | ×0.7 | Plus de revenus, moins d'heures/pénalités |
| Normal (2) | ×1.0 | ×1.0 | ×1.0 | Base |
| Difficile (3) | ×0.8 | ×1.3 | ×1.3 | Moins de revenus, plus d'heures/pénalités |

Le multiplicateur s'applique à TOUT : heures de travail, usure, énergie, pénalités animaux, quotas grossiste.
- `hours_multiplier` : appliqué automatiquement dans `consumeHours()`
- `penalty_multiplier` : appliqué dans les ticks worker (usure, faim, santé, énergie)
- `revenue_multiplier` : appliqué aux ventes

### Alternatives aux PA (à implémenter)
| Méthode | PA | Coût | Disponibilité |
|---------|-----|------|--------------|
| Faire soi-même | Normal | Normal | Toujours |
| Employé | 0 (l'employé utilise ses heures) | Salaire mensuel | Après embauche |
| ETA (prestataire) | 0 | ×2 à ×3 le coût normal | Annuaire ETA |

### Employés (voir 07-metiers.md)
- Embauche = salaire fixe/saison
- Chaque employé apporte des heures supplémentaires/jour
- Spécialisation possible (élevage, cultures, mécanique)

### ETA — Entreprise de Travaux Agricoles (voir 07-metiers.md)
- Autre joueur qui propose ses services
- Le demandeur paie, pas de PA consommés
- L'ETA consomme ses heures + son matériel
- Tarifs libres fixés par l'ETA
