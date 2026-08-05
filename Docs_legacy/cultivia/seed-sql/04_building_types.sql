-- =============================================================================
-- 04_building_types.sql — Types de bâtiments et accessoires
-- =============================================================================
-- Source : docs/02-architecture/03_CONTENT_DATA.md §1
-- Prix calibrés pour l'économie Cultivia (100k€ initial, 40 HT/jour)
-- Entretien mensuel : 0.3 HT/bâtiment, destruction récupère 10% du prix
-- =============================================================================

-- ─── BÂTIMENTS (type 'b') ──────────────────────────────────────────────────
-- Prix au m² ou à la tonne selon l'unité
-- 5 niveaux d'équipement (1=basique, 5=premium) affectent la conso énergie

INSERT INTO building_type (slug, name, category, unit, price_per_unit, energy_kwh_per_month, description) VALUES
-- Stockage & rangement
('hangar',              'Hangar',                    'b', 'm2',    15,    5,   'Ranger matériels, stocker paille/foin/semences/engrais/traitements'),
('entrepot',            'Entrepôt',                  'b', 'm2',    20,    3,   'Stocker balles paille/foin, semences, engrais, traitements'),
('silo',                'Silo',                      'b', 't',     50,    8,   'Stocker récoltes (1 silo par type de récolte)'),
('silo_taupe',          'Silo taupe',                'b', 't',     20,    0,   'Stocker maïs ensilé sous bâche (légère perte)'),
('aire_stockage',       'Aire stockage paille/foin', 'b', 'm2',    8,    0,   'Stocker balles en extérieur (légère perte)'),
-- Élevage
('stabulation',         'Stabulation',               'b', 'm2',    30,   10,   'Abriter bovins'),
('porcherie',           'Porcherie',                 'b', 'm2',    35,   12,   'Abriter porcins'),
('chevrerie',           'Chèvrerie',                 'b', 'm2',    25,    8,   'Abriter caprins'),
('bergerie',            'Bergerie',                  'b', 'm2',    25,    8,   'Abriter ovins'),
('poulailler',          'Poulailler',                'b', 'm2',    20,    6,   'Abriter volailles, pintades, oies, canards'),
('clapier',             'Clapier',                   'b', 'm2',    18,    4,   'Abriter lapins'),
('ecurie',              'Écurie',                    'b', 'm2',    35,   10,   'Abriter chevaux'),
-- Logistique
('fosse_fumier',        'Fosse à fumier',            'b', 't',     30,    0,   'Stocker fumier ou écume de sucrerie'),
('fosse_lisier',        'Fosse à lisier',            'b', 'l',     0.02,  2,   'Stocker lisier'),
('aire_chargement',     'Aire de chargement',        'b', 'm2',    12,    0,   'Stocker marchandise vendue pour camions'),
('silo_chargement',     'Silo de chargement',        'b', 't',     45,    5,   'Stocker aliments vendus pour camions');

-- ─── ACCESSOIRES (type 'a') ────────────────────────────────────────────────
-- Prix à l'unité ou selon la capacité

INSERT INTO building_type (slug, name, category, unit, price_per_unit, energy_kwh_per_month, description) VALUES
('cuve_lait',           'Cuve à lait',               'a', 'l',     0.80,  15,  'Stocker/conserver lait'),
('cuve_hvc',            'Cuve HVC',                  'a', 'l',     0.50,   0,  'Stocker bio-carburant'),
('salle_traite',        'Salle de traite',           'a', 'poste', 2500,  30,  'Traire bovins, caprins, ovins'),
('citerne_eau',         'Citerne à eau',             'a', 'l',     0.10,   2,  'Stocker eau animaux'),
('bac_eau',             'Bac à eau',                 'a', 'l',     0.05,   0,  'Eau animaux au pré/prairie boisée'),
('parc_volailles',      'Parc à volailles',          'a', 'm2',     5,     0,  'Élevage semi-liberté volailles/oies/canards'),
('parc_porcins',        'Parc et abri à porcins',    'a', 'abri',  800,    0,  'Élevage plein-air porcins (5 porcins/abri)'),
('salle_conditionnement','Salle de conditionnement', 'a', 'robot', 8000,  20,  'Ramasser/conditionner œufs'),
('stockage_oeufs',      'Pièce stockage œufs',       'a', 'oeuf',  0.10,   5,  'Stocker œufs conditionnés'),
('stockage_laine',      'Pièce stockage laine',      'a', 'kg',    0.50,   3,  'Stocker laine/duvet'),
('corral',              'Corral',                    'a', 'unite', 1500,    0,  'Regroupement bisons (1 par prairie boisée)');


-- ─── BÂTIMENTS ÉLEVAGE COMPLÉMENTS ─────────────────────────────────────────

INSERT INTO building_type (slug, name, category, unit, price_per_unit, energy_kwh_per_month, description) VALUES
('parc_volailles',      'Parc à volailles',          'b', 'm2',    8,     0,   'Semi-liberté volailles/pintades/oies/canards (10m²/animal)'),
('parc_porcins',        'Parc à porcins',            'b', 'abri',  800,   0,   'Plein-air porcins (1 abri = 10 places)');

-- ─── ACCESSOIRES PRODUCTION ŒUFS ───────────────────────────────────────────

INSERT INTO building_type (slug, name, category, unit, price_per_unit, energy_kwh_per_month, description) VALUES
('atelier_oeufs',         'Atelier œufs',            'a', 'robot', 5500,  25,  'Ramasser, conditionner et stocker les œufs (1 robot = 500 poules, stockage 10 000 œufs inclus)');
