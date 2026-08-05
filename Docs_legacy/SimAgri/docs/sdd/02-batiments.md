# SDD 02 — Bâtiments

## 1. Catalogue

Les prix sont basés sur les coûts réels de construction agricole en France (2024).
Sur un serveur facile, les revenus sont majorés pour compenser.

### Élevage
| Slug | Nom | Unité | Prix/u | Animaux | Énergie (kWh/j/u) |
|------|-----|-------|--------|---------|-------------------|
| stabulation | Stabulation | m² | 600€ | Bovins | 0.05 |
| porcherie | Porcherie | m² | 450€ | Porcins | 0.05 |
| chevrerie | Chèvrerie | m² | 300€ | Caprins | 0.04 |
| bergerie | Bergerie | m² | 300€ | Ovins | 0.04 |
| poulailler | Poulailler | m² | 200€ | Volailles, pintades, oies, canards | 0.03 |
| clapier | Clapier | m² | 150€ | Lapins | 0.03 |
| ecurie | Écurie | m² | 500€ | Chevaux | 0.06 |

### Surface par animal (m²) selon mode d'élevage

Trois modes d'élevage existent. Le mode impacte la surface requise, les revenus et les contraintes.

| Animal | Conventionnel | Label Rouge | Bio |
|--------|:------------:|:-----------:|:---:|
| Vache laitière | 8 | 9 | 11 |
| Vache allaitante | 8 | 10 | 12 |
| Taureau | 10 | 12 | 14 |
| Veau | 3 | 4 | 5 |
| Porc charcutier | 0.8 | 1.3 | 2.3 |
| Truie | 2.5 | 4 | 6 |
| Porcelet | 0.5 | 0.7 | 0.8 |
| Chèvre | 1.5 | 2 | 3 |
| Chevreau | 0.7 | 0.8 | 1.2 |
| Brebis | 1.5 | 2 | 2.5 |
| Agneau | 0.7 | 0.8 | 1.2 |
| Poule pondeuse | 0.11 (9/m²) | 0.17 (6/m²) | 0.25 (4/m²) |
| Poulet de chair | 0.05 (20/m²) | 0.08 (12/m²) | 0.10 (10/m²) |
| Oie | 0.25 (4/m²) | 0.33 (3/m²) | 0.50 (2/m²) |
| Canard | 0.17 (6/m²) | 0.25 (4/m²) | 0.33 (3/m²) |
| Pintade | 0.10 (10/m²) | 0.14 (7/m²) | 0.20 (5/m²) |
| Lapin | 0.18 | 0.25 | 0.40 |
| Cheval | 10 | 12 | 14 |

> Ces valeurs sont basées sur la réglementation française (arrêtés bien-être animal) et les cahiers des charges Label Rouge / AB.
> Le détail complet (alimentation, accès extérieur, durée d'élevage) sera dans `04-elevage.md`.

### Règles par mode
| | Conventionnel | Label Rouge | Bio |
|-|:------------:|:-----------:|:---:|
| Surface bâtiment | Base | +30 à +60% | +80 à +200% |
| Accès extérieur obligatoire | Non | Oui (parcours) | Oui (parcours + pâturage) |
| Prix de vente | ×1.0 | ×1.3 | ×1.6 |
| Durée élevage min | Base | +20% | +40% |
| Alimentation | Standard | Sans OGM | 100% bio |

### Stockage sec
| Slug | Nom | Unité | Prix/u | Contenu autorisé | Énergie |
|------|-----|-------|--------|-----------------|---------|
| hangar | Hangar | m² | 100€ | Matériel, paille, foin, marchandises | 0 |
| entrepot | Entrepôt | m² | 90€ | Semences, engrais, paille, foin | 0 |
| local_phyto | Local phyto | m² | 120€ | Produits phyto (1000L/m²) | 0 |
| silo | Silo | t | 150€ | 1 seul type céréale/oléagineux par silo | 0 |
| silo_taupe | Silo taupe | t | 80€ | Maïs ensilé, ensilage herbe, sorgho ensilé | 0 |
| salle_conditionnement | Salle de conditionnement œufs | oeufs | 1.50€ | Stockage global œufs (500-10000) | 0 |
| aire_stockage | Aire stockage | t | 15€ | Paille, foin (sous bâche, pertes) | 0 |

### Stockage spécialisé
| Slug | Nom | Unité | Prix/u | Contenu autorisé | Énergie |
|------|-----|-------|--------|-----------------|---------|
| entrepot_arbo | Entrepôt arboricole | m² | 150€ | Palox fruits | 0.02 |
| entrepot_pdt | Entrepôt PDT | m² | 200€ | Palox pommes de terre (climatisé) | 0.08 |
| chambre_froide | Chambre froide | m² | 700€ | Légumes emballés, foie gras | 0.20 |
| salle_stockage | Salle de stockage | m² | 120€ | Légumes emballés (ambiant) | 0 |

### Déchets organiques
| Slug | Nom | Unité | Prix/u | Contenu | Énergie |
|------|-----|-------|--------|---------|---------|
| fosse_fumier | Fosse à fumier | t | 60€ | Fumier, écume | 0 |
| fosse_lisier | Fosse à lisier | m³ | 50€ | Lisier | 0 |
| aire_compostage | Aire compostage | t | 70€ | Fumier → compost | 0 |

> **Note :** fosse_lisier en m³ (1 m³ ≈ 1000L) pour harmoniser avec fosse_fumier en tonnes.
>
> Les bâtiments de **transformation** (fromagerie, huilerie, serre, méthanisation) et **cosmétiques** (hall d'exposition) sont dans leurs SDD respectifs.

---

## 2. Accessoires

| Slug | Nom | Unité | Prix/u | Compatible avec |
|------|-----|-------|--------|----------------|
| cuve_lait | Cuve à lait | L | 25€ | Stabulation, chèvrerie, bergerie |
| cuve_hvc | Cuve carburant HVC | L | 15€ | Hangar |
| salle_traite | Salle de traite | places | 3 000€ | Stabulation, chèvrerie, bergerie |
| citerne_eau | Citerne à eau | m³ | 150€ | Tout bâtiment |
| bac_eau | Bac à eau | L | 10€ | Tout bâtiment élevage |
| corral | Corral | places | 50€ | Tout bâtiment élevage |
| parc_volailles | Parc à volailles | m² | 30€ | Poulailler |
| parc_porcins | Parc à porcins | m² | 40€ | Porcherie |
| parc_lapins | Parc à lapins | m² | 30€ | Clapier |
| piece_oeuf | Pièce stockage œufs | m² | 80€ | Poulailler |
| piece_laine | Pièce stockage laine | m² | 80€ | Bergerie, clapier |
| salle_conditionnement | Station conditionnement | m² | 250€ | Entrepôt arbo |

> Accessoires de **pré** (râtelier, clôtures, piquets) → voir 04-elevage.md

---

## 3. Construction

### Coût
```
coût = prix_par_unité × taille × facteur_niveau(level)

facteur_niveau :
  1 → ×1.0
  2 → ×1.5
  3 → ×2.2
  4 → ×3.0
  5 → ×4.0
```

### Exemples concrets
| Bâtiment | Taille | Coût niv.1 | Capacité (conventionnel) | Capacité (bio) |
|----------|--------|-----------|------------------------|----------------|
| Stabulation | 200 m² | 120 000€ | 25 vaches | 18 vaches |
| Poulailler | 200 m² | 40 000€ | 1 800 poules | 800 poules |
| Porcherie | 100 m² | 45 000€ | 125 porcs | 43 porcs |
| Bergerie | 100 m² | 30 000€ | 66 brebis | 40 brebis |
| Hangar | 300 m² | 30 000€ | — | — |
| Silo | 200 t | 30 000€ | — | — |

### Délai
| Condition | Délai |
|-----------|-------|
| Joueur a < 10 bâtiments | Instantané |
| Joueur a ≥ 10 bâtiments | ceil(taille / 100) jours de jeu (min 1, max 7) |

### Tailles
| Catégorie | Min | Max |
|-----------|-----|-----|
| Élevage | 20 m² | 2000 m² |
| Hangar, entrepôt | 20 m² | 5000 m² |
| Silo | 10 t | 1000 t |
| Fosse fumier | 10 t | 3000 t |
| Fosse lisier | 10 m³ | 3000 m³ |

### Contraintes
- Plusieurs bâtiments du même type autorisés
- Coûte **2h**


| Colonne | Contenu |
|---------|---------|
| ID | `short_id` (code unique) |
| Nom | `custom_name` ou `Type-ShortID` (cliquable → renommer) |
| Type | Nom du type (Poulailler, Hangar…) |
| Catégorie | Chip (Élevage, Stockage, Spécialisé, Déchets) |
| Mode | Chip coloré (Conv./Label R./Bio) — tiret si non-élevage |
| Remplissage | `X.X / Y unit` + barre de progression (vert/orange/rouge) — animaux m² + stock |
| Niveau | Chip Niv. 1-5 |
| Usure | Pourcentage coloré |
| État | "OK" vert ou "Fini le JJ/MM/AAAA" orange |
| Actions | Entretien, Agrandir, Niveau +, Détruire |

---

## 4. Agrandissement
- Bâtiment **vide** requis (aucun stock, aucun animal)
- Coût = prix_par_unité × taille_ajoutée × facteur_niveau
- Coûte **2h**

## 5. Destruction
- Bâtiment **vide** requis
- Récupère **10% du coût initial**
- Coûte **1h**

---

## 6. Niveaux d'équipement (1 à 5)

| Niv. | Coût upgrade | Énergie | Usure/jour | Capacité |
|------|-------------|---------|------------|----------|
| 1 | — | ×1.0 | ×1.0 | ×1.0 |
| 2 | 50% coût initial | ×0.9 | ×0.85 | ×1.0 |
| 3 | 100% coût initial | ×0.8 | ×0.70 | ×1.05 |
| 4 | 200% coût initial | ×0.7 | ×0.55 | ×1.10 |
| 5 | 400% coût initial | ×0.6 | ×0.40 | ×1.15 |

- Coûte **1h**, bâtiment opérationnel et usure < 80%

---

## 7. Usure & entretien

### Usure quotidienne
```
usure_jour = 0.15 × facteur_niveau_usure × facteur_saison

facteur_saison :
  printemps = 1.0
  été       = 0.8
  automne   = 1.1
  hiver     = 1.3
```

### Paliers
| Usure | Effet |
|-------|-------|
| 0–30% | Normal |
| 30–60% | +20% consommation énergie |
| 60–80% | +50% énergie, risque panne 2%/jour |
| 80–100% | +100% énergie, risque panne 10%/jour |
| 100% | Inutilisable |

### Entretien
| Type | Coût | Effet | Heures |
|------|------|-------|-----|
| Mensuel | 2% valeur bâtiment | Usure −15 points | 0.5h |
| Annuel | 8% valeur bâtiment | Usure reset à 5% | 2h |

---

## 8. Consommation énergétique

Ne concerne que les bâtiments avec énergie > 0.

### Formule
```
kwh_jour = base_kwh × taille × f_remplissage × f_usure × f_saison × f_niveau
```

### Facteurs
```
f_remplissage = 0.2 + (taux × 0.8)     -- vide=0.2, plein=1.0
f_usure       = 1.0 / 1.2 / 1.5 / 2.0  -- selon palier usure
f_saison      = 1.0 / 1.1 / 1.0 / 1.3  -- print/été/aut/hiver
f_niveau      = voir tableau niveaux
```

### Facturation
- **0.08 €/kWh**, débitée chaque tick
- Si solde insuffisant : usure ×1.5

---

## 9. Stockage

### Compatibilité
| Bâtiment | Contenu autorisé |
|----------|-----------------|
| hangar | materiel, paille_balle, foin_balle, marchandises |
| entrepot | semences, engrais, paille_balle, foin_balle |
| local_phyto | produits_phyto |
| silo | **1 seul type** : ble, orge, mais_grain, colza, tournesol, avoine, triticale, pois, seigle |
| silo_taupe | mais_ensile, ensilage_herbe, sorgho_ensile |
| aire_stockage | paille_balle, foin_balle |
| fosse_fumier | fumier, ecume |
| fosse_lisier | lisier |
| entrepot_arbo | palox_fruits |
| entrepot_pdt | palox_pdt |
| chambre_froide | legumes_emballes, foie_gras |
| salle_stockage | legumes_emballes, foie_gras |

### Pertes quotidiennes
| Bâtiment | Perte/jour |
|----------|-----------|
| aire_stockage | 0.5% |
| silo_taupe | 0.1% |
| Tous les autres | 0% |

### Capacité
```
capacité = taille × facteur_niveau_capacite
utilisé  = SUM(storage.quantity)
libre    = capacité - utilisé
```

---

## 10. Schéma SQL

```sql
CREATE TABLE building_definitions (
  id SERIAL PRIMARY KEY,
  slug VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(30) NOT NULL,       -- 'elevage','stockage_sec','stockage_spe','dechets'
  unit VARCHAR(10) NOT NULL,           -- 'm2','t','m3'
  price_per_unit DECIMAL(10,2) NOT NULL,
  base_kwh DECIMAL(8,4) DEFAULT 0,
  loss_per_day DECIMAL(5,4) DEFAULT 0,
  min_size INT DEFAULT 10,
  max_size INT DEFAULT 5000,
  m2_per_animal DECIMAL(5,2),          -- DEPRECATED: ratio exact dans animal_definitions par mode élevage
  allowed_contents TEXT[],
  description TEXT
);

CREATE TABLE buildings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID NOT NULL REFERENCES players(id),
  definition_id INT NOT NULL REFERENCES building_definitions(id),
  short_id VARCHAR(20) UNIQUE NOT NULL,   -- ex: POU-1009, global unique
  custom_name VARCHAR(100),               -- nom personnalisé, défaut = type-short_id
  farming_mode VARCHAR(20) DEFAULT 'conventionnel', -- conventionnel, label_rouge, bio
  size DECIMAL(10,2) NOT NULL,
  equipment_level INT DEFAULT 1 CHECK (equipment_level BETWEEN 1 AND 5),
  wear DECIMAL(5,2) DEFAULT 0 CHECK (wear BETWEEN 0 AND 100),
  is_building BOOLEAN DEFAULT false,
  build_end_date DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE accessories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  player_id UUID NOT NULL REFERENCES players(id),
  definition_slug VARCHAR(50) NOT NULL,
  size DECIMAL(10,2) NOT NULL,
  wear DECIMAL(5,2) DEFAULT 0,
  building_id UUID REFERENCES buildings(id)
);

CREATE TABLE storage (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  building_id UUID NOT NULL REFERENCES buildings(id),
  item_type VARCHAR(50) NOT NULL,
  quantity DECIMAL(15,2) DEFAULT 0 CHECK (quantity >= 0),
  quality INT DEFAULT 2 CHECK (quality BETWEEN 1 AND 3),
  is_bio BOOLEAN DEFAULT false
);

CREATE INDEX idx_buildings_player ON buildings(player_id);
CREATE INDEX idx_storage_building ON storage(building_id);
```

---

## 11. Endpoints API

| Méthode | Route | Description | Heures |
|---------|-------|-------------|-----|
| GET | /buildings | Mes bâtiments + stocks | — |
| GET | /buildings/catalog | Catalogue types | — |
| POST | /buildings | Construire (1-10, mode élevage) | 2h × qté |
| POST | /buildings/:id/upgrade | Monter de niveau | 1h |
| POST | /buildings/:id/expand | Agrandir (vide requis) | 2h |
| POST | /buildings/:id/maintain | Entretien mensuel | 0.5h |
| POST | /buildings/:id/maintain-annual | Entretien annuel | 2h |
| PATCH | /buildings/:id/rename | Renommer | — |
| DELETE | /buildings/:id | Détruire (vide, récup 10%) | 1h |
| POST | /buildings/:id/storage/move | Déplacer stock | 0.5h |

---

## 12. Worker (ticks quotidiens)

Exécuté chaque jour de jeu par le worker BullMQ.

### 1. Fin de construction
```sql
UPDATE buildings SET is_building = false, build_end_date = NULL
WHERE is_building = true AND build_end_date <= NOW()
```

### 2. Usure automatique
```
usure_jour = 0.15 × facteur_niveau_usure[level] × facteur_saison
```
Appliquée à tous les bâtiments terminés (is_building = false).

### 3. Facturation énergie
```
coût = base_kwh × taille × facteur_saison × facteur_niveau_énergie[level] × 0.08€
```
Débité du solde joueur. Seuls les bâtiments avec base_kwh > 0.

---

## 13. Identifiants

- Séquence globale `global_short_id_seq` (partagée entre bâtiments, matériel, parcelles, animaux)
- Format : `POU-1009` (3 lettres du slug + numéro séquence)
- Unicité garantie cross-joueurs (contrainte UNIQUE)
- Nom par défaut = `Type-ShortID` (ex: "Poulailler-POU-1009")
- Nom personnalisable via renommage
