# SDD 04 — Module Élevage (Animaux, Rations, Reproduction, Génétique)

> **Dashboard élevage** : voir `04-elevage-dashboard.md` pour l'inventaire complet des contrôles de la page "Mes animaux" (13 alertes, raccourcis nourrir, estimation eau, etc.)

## 0. Canaux d'achat

Trois canaux d'achat d'animaux, chacun avec ses règles :

### Grossiste (serveur → joueur)
| Règle | Valeur |
|-------|--------|
| Prix | Fixe (`animal_definitions.buy_price`) |
| Génétique | Moyenne (indices 40-60, aléatoire) |
| Limite | Quota mensuel par espèce (voir ci-dessous) |
| Transport | Tracteur + bétaillère requis (voir SDD 05 §1b) |
| Distance | 20 km (coopérative) |
| Trajets | `⌈nb_animaux / capacité_bétaillère⌉` |
| Coût trajet | 1h + 0.5% usure par trajet (tracteur + bétaillère) |
| Destination | Enclos d'attente |

**Quotas mensuels grossiste :**
| Espèce | Limite/mois de jeu |
|--------|-------------------|
| Volailles | 50 |
| Porcins | 20 |
| Bovins | 5 |
| Ovins | 15 |
| Caprins | 15 |
| Lapins | 30 |
| Chevaux | 3 |

### Marché global (joueur → marché → joueur)
| Règle | Valeur |
|-------|--------|
| Prix | Libre, fixé par le vendeur |
| Commission | 5% prélevée sur le vendeur |
| Durée annonce | 7 jours de jeu, renouvelable |
| Génétique | Visible avant achat |
| Vente en lot | Oui, même espèce, sans limite de taille |
| Âge minimum | Voir tableau ci-dessous |
| Transport | Acheteur se déplace → tracteur + bétaillère requis |
| Filtres | Espèce, race, sexe, âge, mode élevage, fourchette prix |

### Marché privé (joueur → joueur, B2B)
| Règle | Valeur |
|-------|--------|
| Prix | Négocié entre les 2 joueurs |
| Commission | 2% |
| Durée offre | 3 jours de jeu pour accepter |
| Génétique | Visible |
| Vente en lot | Oui, même espèce, sans limite |
| Transport | Acheteur se déplace → tracteur + bétaillère requis |
| Condition | Le vendeur choisit le destinataire (par pseudo) |

### Âge minimum de vente
| Espèce | Âge min |
|--------|---------|
| Bovins | 1 mois |
| Porcins | 1 mois |
| Ovins/Caprins | 1 mois |
| Volailles | 2 semaines |
| Lapins | 1 mois |
| Chevaux | 3 mois |

---

## 0b. Transport d'animaux

### Matériel requis (marché global et privé uniquement)
- **Tracteur** : pour tracter la bétaillère
- **Bétaillère** : capacité en m² intérieur (mêmes m²/animal que les bâtiments)

| Bétaillère | Prix | Capacité | Exemple |
|-----------|------|----------|---------|
| Petite | 8 000€ | 12 m² | ~100 poules ou 1 vache |
| Moyenne | 18 000€ | 25 m² | ~3 vaches ou 30 porcs |
| Grande | 35 000€ | 45 m² | ~5 vaches ou 50 porcs |

### Mécanique de transport
1. L'acheteur lance le transport
2. Le système calcule le nombre d'allers-retours : `ceil(animaux_m2_total / capacité_bétaillère)`
3. Chaque aller-retour consomme :
   - Heures matériel sur le tracteur : `1h + 0.5h × zones_traversées`
   - Heures matériel sur la bétaillère : idem
   - Heures de travail du joueur : idem (× `hours_multiplier` du serveur)
4. Boucle automatique jusqu'à l'une de ces conditions :
   - ✅ Tous les animaux transportés
   - ❌ Tracteur à 0h restantes → stop
   - ❌ Bétaillère à 0h restantes → stop
   - ❌ Joueur plus d'heures de travail → stop
5. Les animaux non transportés restent chez le vendeur

### Heures matériel
Chaque matériel a un compteur `hours_remaining`. L'entretien/révision remet des heures.

| Matériel | Heures neuf |
|----------|------------|
| Tracteur | 10 000h |
| Bétaillère | 5 000h |

### Exemple concret
Acheter 10 vaches (8 m²/vache en conventionnel = 80 m²) à 3 zones de distance, bétaillère moyenne (25 m²) :
- 25 m² / 8 m² = 3 vaches/voyage
- 4 voyages nécessaires (3+3+3+1)
- Trajet = 1h + 3×0.5h = 2.5h par aller-retour
- Total : 4 × 2.5h = **10h tracteur + 10h bétaillère + 10h travail joueur**
- Sur serveur facile (×0.7) : 10h × 0.7 = **7h travail joueur**

### Destination à l'achat
L'acheteur choisit la destination :

1. **Bâtiment** : remplissage automatique selon capacité m². Si le bâtiment est plein → transport s'arrête.
2. **Enclos d'attente** : tous les animaux y vont directement.

Si le transport s'arrête (bâtiment plein, matériel HS, plus d'heures), les animaux restants restent chez le vendeur. Le joueur doit relancer un nouveau transport en choisissant :
- Un autre bâtiment
- L'enclos d'attente

### Enclos d'attente
- Créé automatiquement à l'inscription du joueur (1 par joueur)
- **Pas de limite de capacité**
- Pas de mode d'élevage
- Les animaux ne produisent pas (pas de lait, pas d'œufs, pas de laine)
- **Pénalités quotidiennes** (worker tick) :
  - Faim : −20/jour (au lieu de −10 en bâtiment)
  - Santé : −10/jour si faim < 50 (au lieu de −5 en bâtiment)
  - Ces pénalités sont multipliées par le `difficulty` du serveur (facile ×0.7, normal ×1.0, difficile ×1.3)
- Le joueur doit déplacer ses animaux dans un bâtiment adapté rapidement

### Conditions d'arrêt du transport (mises à jour)
La boucle de transport s'arrête dès l'une de ces conditions :
1. ✅ Tous les animaux transportés
2. ❌ Bâtiment destination plein → stop, animaux restants chez le vendeur
3. ❌ Tracteur à 0h restantes → stop, animaux restants chez le vendeur
4. ❌ Bétaillère à 0h restantes → stop, animaux restants chez le vendeur
5. ❌ Joueur plus d'heures de travail → stop, animaux restants chez le vendeur

Le joueur doit relancer un nouveau transport pour les animaux restants (autre bâtiment ou enclos d'attente).

---

## 0c. Difficulté serveur — Impact global

Le niveau de difficulté du serveur impacte TOUS les calculs du jeu :

| Paramètre | Facile (×0.7) | Normal (×1.0) | Difficile (×1.3) |
|-----------|:------------:|:------------:|:----------------:|
| Heures de travail consommées | −30% | Base | +30% |
| Revenus (ventes) | +50% | Base | −20% |
| Pénalités enclos d'attente | −30% | Base | +30% |
| Usure matériel/bâtiment | −30% | Base | +30% |
| Coûts énergie | −30% | Base | +30% |
| Quotas grossiste | +30% | Base | −30% |

> **Règle** : tout calcul de coût, pénalité ou consommation doit passer par le multiplicateur serveur. Côté code, `consumeHours()` applique déjà `hours_multiplier` automatiquement. Les autres multiplicateurs doivent être appliqués dans chaque tick/action concerné.

---

## 1. Animaux

### Table
```sql
animals (
  id              UUID PRIMARY KEY,
  player_id       UUID REFERENCES players,
  species         VARCHAR NOT NULL,           -- 'volaille','bovin','porcin','ovin','caprin','lapin','cheval'
  race_slug       VARCHAR NOT NULL REFERENCES animal_definitions(slug),
  sex             VARCHAR NOT NULL,           -- 'male','female'
  name            VARCHAR,
  short_id        VARCHAR(10) UNIQUE NOT NULL, -- ex: PPO-1020
  birth_date      DATE NOT NULL,
  weight          DECIMAL(8,2) NOT NULL,
  health          DECIMAL(5,2) DEFAULT 100,   -- 0-100%
  hunger          DECIMAL(5,2) DEFAULT 100,   -- 0=affamé, 100=rassasié
  thirst          DECIMAL(5,2) DEFAULT 100,   -- 0=assoiffé, 100=hydraté
  farming_mode    VARCHAR(20),                -- conventionnel, label_rouge, bio
  location_type   VARCHAR DEFAULT 'building', -- 'building','enclos','pasture'
  building_id     UUID REFERENCES buildings,
  parcel_id       UUID REFERENCES parcels,
  is_pregnant     BOOLEAN DEFAULT FALSE,
  pregnant_since  DATE,
  expected_birth  DATE,                       -- date calculée à l'insémination
  last_birth      DATE,
  genetics        JSONB DEFAULT '{}',
  created_at      TIMESTAMP DEFAULT NOW()
)
```

### Table animal_definitions (catalogue)
```sql
animal_definitions (
  id                  SERIAL PRIMARY KEY,
  species             VARCHAR NOT NULL,
  slug                VARCHAR UNIQUE NOT NULL,
  name                VARCHAR NOT NULL,
  race                VARCHAR(50),              -- ex: Gauloise, Charolaise
  sex                 VARCHAR DEFAULT 'female',
  buy_price           DECIMAL(10,2) NOT NULL,   -- prix grossiste
  avg_weight          DECIMAL(8,2) NOT NULL,     -- poids à l'achat
  avg_adult_weight    DECIMAL(8,2),              -- poids adulte
  gestation_days      INT DEFAULT 0,
  maturity_days       INT DEFAULT 0,             -- jours avant maturité
  compatible_buildings TEXT[] NOT NULL,
  m2_per_animal       JSONB NOT NULL,            -- {"conventionnel":0.11,"label_rouge":0.17,"bio":0.25}
  prefix              VARCHAR(3) NOT NULL        -- pour short_id
)
```

### Colonnes tableau animaux (lots)
| Colonne | Contenu |
|---------|---------|
| ID | `short_id` (code unique) |
| Nom | `name` (cliquable → renommer), défaut = Race-ShortID |
| Qté | Nombre d'animaux dans le lot |
| Type | Poule, Vache, Truie… (display_name genré) |
| Race | Gauloise, Charolaise… |
| Sexe | ♀ / ♂ |
| Stade | Chip coloré genré (Poussin/Poulette/Poule/Coq…) |
| Âge | Xs / Xm Xs / Xa Xm |
| Poids | X.X kg (poids moyen du lot) |
| Lieu | Code bâtiment ou chip "Enclos" |
| Faim | Jauge 0-100% colorée (moyenne du lot) |
| Soif | Jauge 0-100% colorée |
| Santé | Jauge 0-100% colorée |
| Naissance | Date prévue si gestant, sinon — |

### Actions groupées (barre sticky)
| Action | Condition | Effet |
|--------|-----------|-------|
| Regrouper | 2+ lots, même espèce/race/sexe/bâtiment, aucun gestant | Fusionne avec moyennes pondérées |
| Scinder | 1 lot, quantité ≥ 2 | Sépare en 2 lots avec mêmes stats |
| Déplacer | 1+ lots | Modale avec recherche bâtiment + barre remplissage |

---

## 2. Rations alimentaires

### Table (données de référence)
```sql
ration_definitions (
  id           SERIAL PRIMARY KEY,
  species      VARCHAR NOT NULL,
  age_category VARCHAR NOT NULL,  -- 'adult','young_24_36','young_18_24','young_12_18','baby_6_12','baby_3_6','baby_0_3'
  location     VARCHAR NOT NULL,  -- 'building','pasture_summer','pasture_winter'
  ration_type  VARCHAR NOT NULL,  -- 'foin_mais','paille_mais','paille_betterave'...
  items        JSONB NOT NULL     -- {"foin":72,"mais_ensile":84,"orge":7.2,"tourteau_colza":4.8,"mineraux":1}
  water_liters DECIMAL(8,2),
  is_complete  DECIMAL(8,2)       -- ration complète en kg
)
```

### Pâturage (données de référence)
```sql
pasture_requirements (
  species       VARCHAR NOT NULL,
  age_category  VARCHAR NOT NULL,
  sqm_per_day   INT NOT NULL  -- m² d'herbe par jour
)
-- Ex: bovin adult = 80 m², bovin baby = 56 m²
```

---

## 3. Tick alimentation (journalier)

Le nourrissage est **automatique** (worker tick). Le joueur doit s'assurer d'avoir du stock.

```
Chaque jour (worker tick), pour chaque animal en bâtiment :
  ration = getRation(espèce, âge)
  
  Pour chaque aliment de la ration :
    si stock disponible dans le bâtiment → consommer
    sinon → faim -15 par aliment manquant
  
  si eau disponible (bac_eau ou citerne) → consommer
  sinon → soif -20
  
  si tout consommé → faim = min(100, faim + 5), soif = min(100, soif + 5)
  
  Pénalités × penalty_multiplier du serveur

Pour chaque animal en enclos d'attente :
  faim -= 20 × penalty_multiplier
  si faim < 50 → santé -= 10 × penalty_multiplier
  soif -= 25 × penalty_multiplier
  si soif < 50 → santé -= 10 × penalty_multiplier

Remontée santé : +2/jour si faim > 70 ET soif > 70
Mort : santé = 0 → animal supprimé
```

### Rations simplifiées V1

| Espèce | Aliment principal | Kg/jour | Eau L/jour |
|--------|------------------|---------|-----------|
| Bovin adulte | Foin + maïs ensilé | 12 + 15 | 60 |
| Bovin jeune | Foin | 6 | 30 |
| Porc | Aliment complet | 3 | 10 |
| Poule/Volaille | Aliment complet | 0.12 | 0.3 |
| Brebis/Chèvre | Foin | 3 | 8 |
| Lapin | Foin + granulés | 0.15 + 0.05 | 0.5 |
| Cheval | Foin + avoine | 10 + 3 | 40 |

> L'aliment complet s'achète au grossiste. Fabrication maison en V2 (mélangeur).

---

## 4. Litière & fumier

### Données de référence
```sql
litter_requirements (
  species       VARCHAR NOT NULL,
  age_category  VARCHAR NOT NULL,
  straw_kg_day  DECIMAL(6,2) NOT NULL
)
-- Ex: bovin adult taureau = 90 kg, vache = 72 kg, veau = 30 kg
```

### Tick litière (journalier)
```
Pour chaque animal en bâtiment (élevage sur litière) :
  straw_needed = getLitterReq(animal.species, animal.age_category)
  consumeStock(player_id, 'paille', straw_needed)
  
  // Paille consommée → se transforme en fumier
  addToStorage(player_id, 'fumier', straw_needed * 1.5, 'fosse_fumier')
  
  if stock_paille < straw_needed:
    animal.health -= 3  // risque maladie
```

### Lisier (caillebotis)
```
Pour chaque animal en bâtiment (élevage sur caillebotis) :
  lisier = getLisierProduction(animal.species, animal.age_category)
  addToLiquidStorage(player_id, 'lisier', lisier)
```

---

## 5. Reproduction

### Monte naturelle (V1)
La reproduction est **automatique** — si un mâle et des femelles de la même espèce sont dans le même bâtiment, la monte se fait naturellement. Pas de coût en heures.

**Capacité par mâle :**
| Espèce | Femelles/mâle/mois |
|--------|-------------------|
| Bovin | 3 |
| Porc | 5 |
| Ovin/Caprin | 10 |
| Volaille | 10 |
| Lapin | 8 |
| Cheval | 3 |

**Taux de réussite :** 70-90% selon santé + génétique du couple.

**Tick reproduction (worker, quotidien) :**
```
Pour chaque bâtiment d'élevage :
  mâles = animaux mâles adultes dans le bâtiment
  femelles = animaux femelles adultes, non gestantes, âge >= âge_min_repro
  
  Pour chaque mâle :
    quota = femelles_par_mois[espèce] / 30  (par jour)
    femelles_dispo = femelles non encore couvertes ce mois
    
    Pour chaque femelle (jusqu'au quota) :
      taux = base_taux × (santé_mâle/100) × (santé_femelle/100)
      si random < taux → femelle.is_pregnant = true, femelle.pregnant_since = now
```

### Insémination artificielle (IA)
Prestation extérieure — pas de coût en heures, juste le prix de la dose.

- Le joueur choisit une femelle + une dose du catalogue CIA
- Indices génétiques du mâle donneur visibles avant achat
- Pas besoin de mâle dans le bâtiment
- Taux de réussite : 60-80% selon santé de la femelle

**Prix des doses :**
| Espèce | Prix dose |
|--------|----------|
| Bovin | 30-90€ |
| Porc | 5-30€ |
| Ovin/Caprin | 10-35€ |
| Volaille | 0.5-4€ |
| Lapin | 0.5-4€ |
| Cheval | 30-120€ |

> Le prix varie selon la qualité génétique du mâle donneur (indices élevés = dose plus chère).

---

## 6. Production lait

### Traite (action joueur, coûte des heures)
```
function milkAnimals(player_id):
  milking_room = getAccessory(player_id, 'salle_traite')
  milk_tank = getAccessory(player_id, 'cuve_lait')
  
  dairy_animals = getAnimals(player_id, is_dairy=true, age >= maturity)
  
  pa_cost = calculateMilkingPA(dairy_animals.count, milking_room.size)
  consumePA(player_id, pa_cost)
  
  total_milk = 0
  for animal in dairy_animals:
    milk = animal.race.avg_milk_per_day * qualityFactor(animal.hunger) * geneticFactor(animal)
    total_milk += milk
  
  if milk_tank.current + total_milk > milk_tank.size:
    total_milk = milk_tank.size - milk_tank.current  // overflow perdu
  
  addLiquid(milk_tank, total_milk)
```

---

## 6b. Système de lots

### Gestion par lots
Les animaux sont gérés en **lots** (1 lot = N animaux de même espèce/race/sexe).

### Colonnes tableau animaux (lots)
| Colonne | Contenu |
|---------|---------|
| ID | `short_id` (code unique) |
| Nom | `name` (cliquable → renommer), défaut = Race-ShortID |
| Qté | Nombre d'animaux dans le lot |
| Type | Poule, Vache, Truie… (display_name genré) |
| Race | Gauloise, Charolaise… |
| Sexe | ♀ / ♂ |
| Stade | Chip coloré genré (Poussin/Poulette/Poule/Coq…) |
| Âge | Xs / Xm Xs / Xa Xm |
| Poids | X.X kg (poids moyen du lot) |
| Lieu | Code bâtiment ou chip "Enclos" |
| Faim | Jauge 0-100% colorée (moyenne du lot) |
| Soif | Jauge 0-100% colorée |
| Santé | Jauge 0-100% colorée |
| Naissance | Date prévue si gestant, sinon — |

### Actions groupées (barre sticky)
| Action | Condition | Effet |
|--------|-----------|-------|
| Regrouper | 2+ lots, même espèce/race/sexe/bâtiment, aucun gestant | Fusionne avec moyennes pondérées |
| Scinder | 1 lot, quantité ≥ 2 | Sépare en 2 lots avec mêmes stats |
| Déplacer | 1+ lots | Modale avec recherche bâtiment + barre remplissage |
| Vendre (abattoir) | 1+ lots, achetés depuis > 1 mois in-game | Modale rouge avec récap (lots, animaux, poids, revenu estimé) |

### Vente abattoir (V1)
| Règle | Valeur |
|-------|--------|
| Prix | `avg_weight × quantity × slaughter_price_per_kg × revenue_multiplier` |
| Délai | Animaux achetés au grossiste : revente interdite avant 1 mois in-game (30j / time_ratio en jours réels) |
| Animaux nés sur la ferme | Pas de délai |
| Anti-abus | Prix d'achat > revente immédiate même en difficulté facile (×1.5) |
| Heures | `⌈nb_animaux / 10⌉ × 0.5h` |

### Naissances
- 1 naissance = max 2 lots (1 mâle + 1 femelle)
- Poids standard (poids naissance de l'espèce), pas d'aléa (V2 = génétique)
- Le joueur regroupe ensuite s'il le souhaite

Les animaux sont gérés par **lots** (1 lot = 1 ligne en base). Un lot = N animaux de même espèce/race/sexe.

### Table
```sql
animal_lots (
  id              UUID PRIMARY KEY,
  player_id       UUID REFERENCES players,
  short_id        VARCHAR(10) UNIQUE NOT NULL,
  name            VARCHAR(100),              -- renommable, défaut = Race-ShortID
  species         VARCHAR(30) NOT NULL,
  race_slug       VARCHAR NOT NULL REFERENCES animal_definitions(slug),
  sex             VARCHAR(10) NOT NULL,
  quantity        INT NOT NULL DEFAULT 1,
  avg_weight      DECIMAL(8,2) NOT NULL,
  health          DECIMAL(5,2) DEFAULT 100,
  hunger          DECIMAL(5,2) DEFAULT 100,
  thirst          DECIMAL(5,2) DEFAULT 100,
  farming_mode    VARCHAR(20),
  location_type   VARCHAR DEFAULT 'enclos',
  building_id     UUID REFERENCES buildings,
  birth_date      DATE NOT NULL,
  is_pregnant     BOOLEAN DEFAULT FALSE,
  pregnant_since  DATE,
  expected_birth  DATE,
  genetics        JSONB DEFAULT '{}',
  created_at      TIMESTAMP DEFAULT NOW()
)
```

### Scinder un lot
- Lot de 50 → scinder en X + (50-X)
- Les 2 nouveaux lots gardent les mêmes stats (poids, santé, faim, soif, génétique)
- Chacun reçoit un nouveau short_id et nom
- Coûte 0h (administratif)
- X doit être entre 1 et quantité-1

### Regrouper des lots
- Lot A (qA, statsA) + Lot B (qB, statsB) → nouveau lot (qA+qB, stats pondérées)
- Poids moyen = (qA × poidsA + qB × poidsB) / (qA + qB)
- Même formule pour santé, faim, soif, génétique
- Condition : même espèce + même race + même sexe + même bâtiment
- Coûte 0h (administratif)

### Vente
- On vend un lot **entier** uniquement
- Pour vendre une partie → scinder d'abord, puis vendre le lot isolé
- Pas de vente partielle

---

## 7. Génétique (V2 — reporté)

Système d'indices génétiques reporté en V2. En V1, tous les lots ont des stats de base.
En V2, chaque lot aura ses indices moyens. La reproduction croisera les indices des lots parents + aléatoire → nouveau lot bébé.

---

## 7a. Production d'œufs (page `/eggs`)

### Prérequis joueur
Pour produire des œufs, le joueur doit avoir :
1. Un **poulailler** avec des poules pondeuses dedans
2. Un **robot ramassage** installé dans le poulailler (accessoire, acheté depuis page Œufs)
3. Une **salle de conditionnement** construite sur la ferme (bâtiment, depuis page Bâtiments)
4. Les poules doivent être **assez âgées** (`age >= egg_production_age`) et **bien nourries** (`hunger >= 50`)

### Production
| Race | Ponte/jour de jeu | Âge min ponte | Aptitude |
|------|-------------------|---------------|----------|
| Gauloise ♀ | 1 œuf | 150 jours | pondeuse ★★★ |
| Sussex ♀ | 1 œuf | 140 jours | mixte ★★ |
| Cou Nu ♀ | 0-1 œuf (50%) | 120 jours | chair ★ |

### Calibre selon l'âge
| Âge poule | Calibre | Prix unitaire |
|-----------|---------|---------------|
| < 240 jours | S (Petit) | 0.08€ |
| 240-400 jours | M (Moyen) | 0.12€ |
| 400-600 jours | L (Gros) | 0.18€ |
| > 600 jours | XL (Très gros) | 0.25€ |

### Robot ramassage (accessoire de poulailler)
| Modèle | Capacité | Prix |
|--------|----------|------|
| Robot 1 poste | 500 poules | 2 500€ |
| Robot 2 postes | 1 000 poules | 4 500€ |

Si le joueur a plus de poules que la capacité du robot → seules les poules couvertes produisent.

### Salle de conditionnement (bâtiment de ferme)
- Catégorie : `stockage_spe`
- Unité : œufs
- Prix : 1.50€/œuf de capacité
- Min : 500 œufs, Max : 10 000 œufs
- **Partagée** entre tous les poulaillers (stockage global)
- Si pleine → production s'arrête

### Worker tick
```
Pour chaque lot de poules en bâtiment :
  1. Vérifier robot ramassage dans le bâtiment
  2. Vérifier salle de conditionnement du joueur (global)
  3. coveredHens = min(quantity, robotCapacity)
  4. eggs = coveredHens × random(min, max) × time_ratio
  5. eggs = min(eggs, storageCapacity - currentStock)
  6. Calibre selon âge de la poule
  7. Stocker dans egg_stock
```

### Page Œufs (`/eggs`)
**Dashboard** : 5 cards résumé (stock total, stockage X/Y, poules pondeuses, production estimée/jour, valeur stock)

**Mes poulaillers** : 1 card par poulailler avec :
- Nombre de poules
- Robot : ✅ installé (X poules max) ou ❌ manquant
- Statut production : active ou ⚠️ raison
- Select pour installer un robot

**Alerte globale** : si pas de salle de conditionnement → bandeau jaune avec lien vers Bâtiments

**Stock d'œufs** : 4 cards (S/M/L/XL) avec quantité, prix, valeur, input vente + "Tout sélectionner"

### Rentabilité (serveur normal)
| Troupeau | Production/jour réel | Profit/jour | ROI équipement |
|----------|---------------------|-------------|----------------|
| 50 Gauloises | 350 œufs | 30€ | 3.6 mois |
| 100 Gauloises | 700 œufs | 60€ | 2.2 mois |
| 200 Gauloises | 1 400 œufs | 163€ | 1.1 mois |

## 7b. Stades de croissance

Table `growth_stages` — chaque espèce a 3 stades :

| Espèce | Bébé (jours jeu) | Jeune (jours jeu) | Adulte | Réel bébé | Réel jeune→adulte |
|--------|:---:|:---:|:---:|:---:|:---:|
| Volaille | 0-42 | 42-180 | 180+ | 6j | 20j |
| Lapin | 0-30 | 30-90 | 90+ | 4j | 9j |
| Porcin | 0-60 | 60-360 | 360+ | 9j | 43j |
| Ovin/Caprin | 0-120 | 120-360 | 360+ | 17j | 34j |
| Bovin | 0-180 | 180-810 | 810+ | 26j | 90j |
| Cheval | 0-180 | 180-1080 | 1080+ | 26j | 129j |

Chaque stade a un `feed_ratio` (bébé mange 20-30% d'un adulte) et un `m2_ratio` (bébé prend 10-30% de l'espace).

---

## 7c. Protection hors-ligne

- `players.last_seen` mis à jour à chaque requête authentifiée
- Si joueur absent > 48h réelles : les jauges (faim, soif) ne descendent pas en dessous de 20%
- Empêche la mort des animaux pendant une absence courte
- Mode vacances (gel de ferme) → V2

---

## 8. Surface par animal

### Données de référence (extrait)
| Espèce | Adulte mâle | Adulte femelle | Jeune | Bébé |
|--------|------------|----------------|-------|------|
| Bovins | 15 m² | 12 m² | 8 m² | 5 m² |
| Caprins | 7 m² | 5 m² | 4 m² | 2 m² |
| Porcins | 5 m² | 4 m² | 2 m² | 0.5 m² |
| Lapins | 1 m² | 1 m² | 0.5 m² | 0.2 m² |
| Volailles | 0.1 m² | 0.1 m² | 0.07 m² | 0.01 m² |
| Ovins | 7 m² | 5 m² | 4 m² | 2 m² |

### Vérification
```
function canHouseAnimal(building_id, animal):
  building = getBuilding(building_id)
  current_used = sumAnimalSurface(building_id)
  needed = getSurfaceReq(animal.species, animal.age_category, animal.sex)
  return (current_used + needed) <= building.size
```

---

## 9. IVRAD (Institut Virtuel des Races A Développer)

### Objectifs Génétiques (OG)
Chaque race a des objectifs génétiques définis. Les éleveurs travaillent à améliorer les indices génétiques de leurs animaux pour atteindre ces OG.

### Développement élevage IVRAD
- Sélection des reproducteurs selon indices
- Accouplement raisonné (croisement indices complémentaires)
- Vente à l'abattoir IVRAD (prix selon indices génétiques)

---

## 10. Labels

### Label plein-air
- Conditions : animaux au pré minimum X mois/an, surface minimale par animal, alimentation conforme
- Bonus prix de vente

### Label BIO
- Conversion 2 saisons
- Pas de traitements phytosanitaires sur alimentation
- Rations spécifiques (aliments BIO)
- Bonus prix de vente (+20% min)

---

## 11. Vaccins

```sql
vaccinations (
  id         UUID PRIMARY KEY,
  animal_id  UUID REFERENCES animals,
  vaccine    VARCHAR NOT NULL,
  date       DATE NOT NULL,
  expires_at DATE
)
```

Prévention des maladies. Coût par animal, durée de protection variable.

---

## 12. Élevage industriel / Ratio fusion

Possibilité d'élever en mode industriel avec des ratios de fusion pour optimiser la gestion de grands troupeaux.

---

## 13. Négociant en bestiaux

Intermédiaire pour l'achat/vente d'animaux entre joueurs. Commission sur les transactions.

---

## 14. Allaitement

Les femelles allaitantes nourrissent leurs petits directement. Réduit le besoin en alimentation externe pour les jeunes mais consomme plus de ressources pour la mère.

---

## 15. Robot d'alimentation

Accessoire automatisant la distribution des rations. Réduit les PA nécessaires pour nourrir les animaux.

---

## 16. Chien de troupeau

Aide à la gestion du troupeau au pré. Réduit les PA de mise au pré et de rentrée des animaux.

---

## 17. Nommer ses animaux

Fonctionnalité sociale permettant de nommer individuellement chaque animal. Possible via la coopérative (service payant).

---

## 18. Élevage BIO — Contraintes par espèce

> Source : export france3.simagri.com

| Espèce | Plein-air min | Lieu | Tolérance nourriture conv. | Âge min | Âge max |
|--------|-------------|------|---------------------------|---------|---------|
| Bovin | 50% | Pré | 12 jours | 6 mois | 8 ans |
| Porcin | 50% | Parc+abris | 4 jours | 6 mois | 24 mois |
| Caprin | 25% | Pré | 6 jours | 3 mois | 5 ans |
| Ovin | 50% | Pré | 6 jours | 3 mois | 5 ans |
| Lapin | 95% | Parc à lapins | 2 jours | 3 mois | 24 mois |
| Volaille | 95% | Parc à volailles | 4 jours | 6 mois | 24 mois |
| Pintade | 95% | Parc à volailles | 6 jours | 6 mois | 24 mois |
| Oie | 95% | Parc à volailles | 4 jours | 6 mois | 3 ans |
| Oie foie gras | 95% | Parc à volailles | 2 jours | 3 mois 5j | 4 mois 1j |
| Canard | 95% | Parc à volailles | 4 jours | 6 mois | 3 ans |
| Canard foie gras | 95% | Parc à volailles | 2 jours | 3 mois 4j | 4 mois |

Bisons, daims et équidés non concernés par le BIO.

---

## 19. Rendement carcasse (abattoir)

| Espèce | Rendement carcasse |
|--------|-------------------|
| Bovins laitiers | 50-55% |
| Bovins allaitants | 55-75% |
| Porcins | 72-80% |
| Lapins | 55-63% |
| Volailles | 60-65% |
| Oies | 60-65% |
| Canards | 60-65% |
| Pintades | 60-65% |
| Ovins | 45-50% |
| Caprins | 45-50% |
| Bisons | 55-60% |
| Daims | 55-60% |

Qualité viande : conformation A-E + engraissement 1-5.

---

## 20. Prix du lait par indice Qualité Lait (QL)

### Conventionnel (€/1000L)
| QL | Bovins | Caprins | Ovins |
|----|--------|---------|-------|
| 0-9 | 265 | 550 | 850 |
| 10-19 | 275 | 560 | 860 |
| 20-29 | 285 | 570 | 870 |
| 30-39 | 295 | 580 | 880 |
| 40-49 | 305 | 590 | 880 |
| 50-59 | 320 | 600 | 900 |
| 60-69 | 340 | 610 | 910 |
| 70-79 | 360 | 620 | 920 |
| 80-89 | 380 | 630 | 930 |
| 90-100 | 400 | 640 | 940 |

### BIO (€/1000L)
| QL | Bovins | Caprins | Ovins |
|----|--------|---------|-------|
| 0-9 | 318 | 660 | 1020 |
| 10-19 | 330 | 672 | 1032 |
| 20-29 | 342 | 684 | 1044 |
| 30-39 | 354 | 696 | 1056 |
| 40-49 | 366 | 708 | 1068 |
| 50-59 | 384 | 720 | 1080 |
| 60-69 | 408 | 732 | 1092 |
| 70-79 | 432 | 744 | 1104 |
| 80-89 | 456 | 756 | 1116 |
| 90-100 | 480 | 768 | 1128 |

---

## 21. Valorisation génétique (vente entre joueurs)

Prix supplémentaire par point au-dessus de la moyenne serveur :
| Espèce | €/point |
|--------|---------|
| Bovins, Équins, Bisons | 2.00 |
| Porcins, Caprins, Ovins | 0.50 |
| Daims | 0.25 |
| Oies | 0.03 |
| Lapins, Volailles, Pintades, Canards | 0.01 |

---

## 22. Indices génétiques — Liste complète

| Indice | Description | Espèces |
|--------|------------|---------|
| Croissance | Poids adulte | Toutes |
| Prolificité | Nombre petits/portée | Toutes |
| Allure générale | Apparence, standard race | Toutes |
| Lait | Production laitière | Bovins, Caprins, Ovins |
| Qualité Lait (QL) | Qualité du lait | Bovins, Caprins, Ovins |
| Laine | Production laine | Ovins, Lapins angora, Caprins angora |
| Oeuf | Production œufs | Volailles, Pintades |
| Eclosion | Taux éclosion | Pintades, Oies, Canards |
| Résistance | Résistance maladies | Bisons, Daims |
| Sociabilité | Facilité approche | Bisons, Daims |
| Fertilité | Réussite insémination | Oies |
| Duvet | Production duvet | Oies, Canards |
| Physique | Qualités physiques | Chevaux |
| Mental | Qualités mentales | Chevaux |

---

## 23. Robot d'alimentation

- Prix : 185 000€ par espèce
- Automatise la distribution des rations en bâtiment
- Nécessite SimPass actif
- Maintenance par atelier concessionnaire
- Consomme de l'électricité (variable selon nombre animaux)
- Pack Robot Alimentation (option) : calendrier, compte rendu, estimation besoins, historique

---

## 24. CIA — Doses et prix

### Doses par prélèvement
| Mâle | Doses |
|------|-------|
| Taureau | 300-400 |
| Verrat | 20-40 |
| Bouc | 15-25 |
| Bélier | 10-15 |
| Lapin | 35-50 |
| Coq | 35-50 |
| Pintade mâle | 35-50 |
| Jars | 7-12 |
| Canard | 35-50 |
| Étalon | 20-30 |

### Prix dose (€)
| Mâle | Min | Max |
|------|-----|-----|
| Taureau | 30 | 90 |
| Verrat | 5 | 30 |
| Bouc | 15 | 35 |
| Bélier | 10 | 25 |
| Lapin | 0.5 | 4 |
| Coq | 0.5 | 4 |
| Pintade mâle | 0.5 | 4 |
| Jars | 0.5 | 4 |
| Canard | 0.5 | 4 |
| Étalon | 30 | 120 |

---

## 25. Dates mise au pré / plein-air

| Espèce | Début | Fin | Hivernal possible |
|--------|-------|-----|-------------------|
| Bovins laitiers | Avril | Fin Octobre | Non |
| Bovins allaitants | Avril | Fin Octobre | Oui (ration hivernale Nov-Mars) |
| Caprins | Avril | Fin Octobre | Non |
| Ovins laitiers | Avril | Fin Octobre | Non |
| Ovins allaitants | Avril | Fin Octobre | Oui (ration hivernale Nov-Mars) |
| Bisons | Toute l'année | - | Ration Oct-Mars |
| Daims | Toute l'année | - | Ration Oct-Mars |
| Chevaux | Mars | Fin Novembre | Oui (ration hivernale Déc-Fév) |
