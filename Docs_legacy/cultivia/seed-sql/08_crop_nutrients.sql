-- =============================================================================
-- 08_crop_nutrients.sql — Besoins nutritifs par culture (kg/tonne de rendement)
-- =============================================================================
-- Source : docs/02-architecture/03_CONTENT_DATA.md §7
-- Données agronomiques réelles (COMIFER, ARVALIS)
-- Format : min/max → on stocke la moyenne pour le calcul de base
-- N=azote, P=phosphore, K=potassium, Ca=calcium, Mg=magnésium, S=soufre
-- =============================================================================

INSERT INTO crop_nutrient (crop_slug, n_min, n_max, p_min, p_max, k_min, k_max, ca_min, ca_max, mg_min, mg_max, s_min, s_max) VALUES
('ble',              20, 30,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  4,  6),
('orge',             18, 24,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  4,  6),
('orge_printemps',   18, 24,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  4,  6),
('avoine',           20, 30,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  4,  6),
('avoine_printemps', 20, 30,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  4,  6),
('triticale',        20, 30,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  4,  6),
('mais_grain',       22, 32,  7,  11,    4,  6,   5,  7,  2, 4,  0,  0),
('mais_ensile',      10, 16,  5,   7,   12, 16,   3,  5,  2, 4,  0,  0),
('betterave',         1,  3,  0.5, 1.5,  4,  6,   5,  7,  0.5, 1.5, 0.5, 1.5),
('colza',            50, 56, 12,  16,    8, 12,  77, 87,  9, 13, 59, 69),
('tournesol',        30, 36, 12,  18,   20, 26,  52, 62, 12, 18,  0,  0),
('pois',              0,  0,  9,  13,   13, 19,   2,  4,  3,  5,  2,  4),
('feverole',          0,  0,  9,  13,   13, 19,   2,  4,  3,  5,  2,  4),
('soja',             66, 76, 12,  18,   46, 56,  41, 51, 11, 15,  0,  0),
('lin',               4,  6,  2,   4,    2,  4,   2,  4,  1,  3,  1,  3),
('pomme_de_terre',    3,  5,  1,   3,    7, 11,   1,  3,  0.5, 1.5, 0.5, 1.5),
('chanvre',          20, 30,  0.5, 1.5,  1,  3,   5,  9,  2, 4,  6, 10),
('tabac',            70, 90, 40,  60,   40, 60,   9, 15, 12, 18, 10, 16),
('epinard',           3,  5,  1,   3,    7, 11,   0.5, 1.5, 0.5, 1.5, 0.5, 1.5),
('haricot_vert',      7, 11,  2,   4,    8, 12,   1,  3,  1,  3,  1,  3),
('lentille',          8, 12,  5,   7,    7,  9,   3,  5,  3,  5,  2,  4),
('miscanthus',        6.5, 7.5, 0.5, 1.1, 6, 8,  0.6, 1.2, 0, 0, 0, 0),
('luzerne',           0,  0,  5,   7,   27, 33,  27, 33,  2, 4,  1,  3),
('sorgho_ensile',    10, 14,  8,   7,    8, 12,   3,  5,  3,  5,  0,  0);
