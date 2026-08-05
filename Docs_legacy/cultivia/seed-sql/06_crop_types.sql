-- =============================================================================
-- 06_crop_types.sql — Cultures avec dates semis/récolte, prix, rotations
-- =============================================================================
-- Source : docs/02-architecture/03_CONTENT_DATA.md §5
-- Prix calibrés : blé ~180€/T (réel ~200€, ajusté -10% pour l'économie jeu)
-- Semences : 2 niveaux (standard, certifiée = +30% prix, +5% rendement)
-- Mois Cultivia : 1-3=hiver, 4-6=printemps, 7-9=été, 10-12=automne
-- =============================================================================

INSERT INTO crop_type (slug, name, sow_month_start, sow_month_end, harvest_month_start, harvest_month_end, base_price, rotation_years, seed_kg_per_ha, seed_price_standard, seed_price_certified, harvest_method) VALUES
-- Céréales d'hiver (semis automne, récolte été)
('ble',              'Blé',                   10, 11,  7,  8,  180, 1, 150, 0.35, 0.46, 'moissonneuse'),
('orge',             'Orge',                  10, 11,  6,  7,  190, 1, 150, 0.32, 0.42, 'moissonneuse'),
('avoine',           'Avoine',                10, 11,  7,  8,  170, 1, 150, 0.28, 0.36, 'moissonneuse'),
('triticale',        'Triticale',             10, 11,  7,  8,  160, 1, 150, 0.30, 0.39, 'moissonneuse'),
-- Céréales de printemps
('orge_printemps',   'Orge de printemps',      4,  5,  7,  8,  190, 2, 150, 0.32, 0.42, 'moissonneuse'),
('avoine_printemps', 'Avoine de printemps',     4,  5,  7,  8,  170, 2, 150, 0.28, 0.36, 'moissonneuse'),
-- Maïs
('mais_grain',       'Maïs grain',             4,  5, 10, 11,  200, 2,  25, 3.50, 4.55, 'moissonneuse'),
('mais_ensile',      'Maïs ensilé',            4,  5, 10, 11,   40, 2,  25, 3.50, 4.55, 'ensileuse'),
-- Oléagineux
('colza',            'Colza',                 10, 11,  6,  7,  400, 2,   4, 8.00, 10.40, 'moissonneuse'),
('tournesol',        'Tournesol',              4,  5,  8,  9,  415, 3, 150, 0.50, 0.65, 'moissonneuse'),
-- Protéagineux
('pois',             'Pois',                   4,  5,  7,  8,  215, 3, 150, 0.40, 0.52, 'moissonneuse'),
('feverole',         'Féverole',              11, 12,  7,  8,  260, 2, 220, 0.45, 0.59, 'moissonneuse'),
('soja',             'Soja',                   4,  5,  9, 10,  300, 3, 110, 0.80, 1.04, 'moissonneuse'),
('lentille',         'Lentille',               4,  5,  8,  9, 1100, 2, 150, 1.20, 1.56, 'moissonneuse'),
-- Industrielles
('betterave',        'Betterave',               4,  5, 10, 11,  110, 4, 150, 0.60, 0.78, 'arracheuse_betterave'),
('lin',              'Lin',                     4,  5,  7,  8, 1170, 6, 120, 2.00, 2.60, 'arracheuse_lin'),
('pomme_de_terre',   'Pomme de terre',          4,  5,  9, 10,   72, 4, 900, 0.40, 0.52, 'arracheuse_pdt'),
('chanvre',          'Chanvre industriel',      5,  5,  9,  9,  315, 1,  50, 3.00, 3.90, 'moissonneuse'),
('tabac',            'Tabac',                   4,  5,  7,  9, 4050, 3,  35, 0.01, 0.01, 'manuel'),
-- Fourragères
('sorgho_ensile',    'Sorgho ensilé',           4,  5,  9, 10,   45, 2,  12, 2.50, 3.25, 'ensileuse'),
('luzerne',          'Luzerne',                 4,  5,  4, 12,   68, 4,  25, 5.00, 6.50, 'ensileuse'),
('miscanthus',       'Miscanthus',              4,  5,  4,  5,   68, 1,  20, 0.50, 0.65, 'ensileuse'),
-- Maraîchage
('epinard',          'Épinard',                 4,  9,  6, 11,  108, 3, 150, 0.60, 0.78, 'recolteuse_epinard'),
('haricot_vert',     'Haricot vert',            4,  9,  6, 11,  175, 5, 150, 0.80, 1.04, 'recolteuse_haricot');
