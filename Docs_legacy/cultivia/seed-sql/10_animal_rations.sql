-- =============================================================================
-- 10_animal_rations.sql — Rations par espèce × tranche d'âge
-- =============================================================================
-- Source : docs/02-architecture/03_CONTENT_DATA.md §10
-- Données basées sur les recommandations INRAE réelles
-- Quantités en kg/jour (eau en L/jour)
-- Seuls les compléments sont listés ici ; les rations de base (choix parmi
-- plusieurs combinaisons foin/maïs/paille) sont gérées côté applicatif.
-- =============================================================================

-- ─── BOVINS — Compléments stabulation ───────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('bovin', 'adulte_3plus',  'stabulation', 7.2, 4.8, 1.0, 200, 169),
('bovin', '24_36_mois',    'stabulation', 6.0, 4.0, 0.8, 100, 144),
('bovin', '18_24_mois',    'stabulation', 4.0, 4.0, 0.6,  80, 112),
('bovin', '12_18_mois',    'stabulation', 2.0, 4.0, 0.4,  60,  85),
('bovin', '6_12_mois',     'stabulation', 1.2, 2.0, 0.4,  40,  57),
('bovin', '3_6_mois',      'stabulation', 0.6, 1.2, 0.4,  28,  29),
('bovin', '0_3_mois',      'stabulation', 0,   0,   0,    12,   8);
-- Note : veaux 0-3 mois = concentré jeune bovin 8 kg + eau 12 L

-- ─── BOVINS — Ration hivernale au pré (allaitants, Nov→Mars) ────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('bovin', 'adulte_3plus',  'pre_hiver', 44, 6.6, 2.2, 1.0, 200, 53.8),
('bovin', '24_36_mois',    'pre_hiver', 36, 5.4, 1.8, 0.8, 100, 44.0),
('bovin', '18_24_mois',    'pre_hiver', 28, 4.2, 1.4, 0.7,  80, 34.0),
('bovin', '12_18_mois',    'pre_hiver', 20, 3.0, 1.0, 0.5,  60, 25.0),
('bovin', '6_12_mois',     'pre_hiver', 16, 2.4, 0.8, 0.4,  40, 20.0),
('bovin', '3_6_mois',      'pre_hiver', 12, 1.2, 0.6, 0.3,  28, 15.0),
('bovin', '0_3_mois',      'pre_hiver',  0, 0,   0,   0,    12,  0);

-- ─── CAPRINS — Compléments chèvrerie ────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('caprin', 'adulte_12plus', 'chevrerie', 3.2, 0, 0.08, 20, 21),
('caprin', '6_12_mois',     'chevrerie', 2.8, 0, 0.04, 12, 16),
('caprin', '3_6_mois',      'chevrerie', 2.4, 0, 0.04,  8, 11),
('caprin', '0_3_mois',      'chevrerie', 2.0, 0, 0.04,  4,  3);

-- ─── PORCINS — Porcherie ────────────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('porcin', 'adulte_12plus', 'porcherie', 12.0, 0.8, 0.8, 68, 14),
('porcin', '6_12_mois',     'porcherie',  9.2, 1.4, 1.4, 48, 10),
('porcin', '3_6_mois',      'porcherie',  6.0, 1.6, 0.4, 24,  8),
('porcin', '1_3_mois',      'porcherie',  2.8, 1.0, 0.2, 12,  4),
('porcin', '0_1_mois',      'porcherie',  0.4, 0,   0,    2,  0.4);

-- ─── OVINS — Compléments bergerie ───────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('ovin', 'adulte_12plus', 'bergerie', 1.6, 1.2, 0.14, 20, 26.94),
('ovin', '6_12_mois',     'bergerie', 1.4, 0.8, 0.08, 12, 20.28),
('ovin', '3_6_mois',      'bergerie', 1.2, 0.6, 0.04,  8, 13.84),
('ovin', '0_3_mois',      'bergerie', 1.0, 0.4, 0.04,  4,  0);

-- ─── OVINS — Ration hivernale au pré ────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, cereal_kg, oilcake_kg, minerals_kg, water_l) VALUES
('ovin', 'adulte_12plus', 'pre_hiver', 4.0, 1.60, 0.60, 0.10, 20),
('ovin', '6_12_mois',     'pre_hiver', 3.2, 1.28, 0.48, 0.08, 12),
('ovin', '3_6_mois',      'pre_hiver', 2.4, 0.96, 0.36, 0.06,  8),
('ovin', '0_3_mois',      'pre_hiver', 2.0, 0.80, 0.30, 0.05,  4);

-- ─── LAPINS — Clapier ──────────────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, cereal_kg, oilcake_kg, water_l, total_ration_kg) VALUES
('lapin', 'adulte_3plus', 'clapier', 0.80, 0.64, 0.36, 1.2, 1.8),
('lapin', '1_3_mois',     'clapier', 0.54, 0.416, 0.24, 1.2, 1.2),
('lapin', '0_1_mois',     'clapier', 0,    0.04,  0,    0.4, 0.04);

-- ─── VOLAILLES — Poulailler ─────────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, minerals_kg, water_l, total_ration_kg) VALUES
('volaille', 'adulte_6plus', 'poulailler', 0.095, 0.005, 1.0, 0.100),
('volaille', '1_6_mois',     'poulailler', 0.070, 0.003, 0.6, 0.075),
('volaille', '0_1_mois',     'poulailler', 0.050, 0.002, 0.2, 0.055);

-- ─── OIES ───────────────────────────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, minerals_kg, water_l, total_ration_kg) VALUES
('oie', 'adulte_6plus', 'poulailler', 0.380, 0.002, 4.0, 0.382),
('oie', '3_6_mois',     'poulailler', 0.280, 0.012, 2.4, 0.287),
('oie', '0_3_mois',     'poulailler', 0.200, 0.008, 0.8, 0.210);

-- ─── CANARDS ────────────────────────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('canard', 'adulte_6plus', 'poulailler', 0.150, 0.040, 0.01, 4.0, 0.191),
('canard', '3_6_mois',     'poulailler', 0.110, 0.030, 0.006, 3.0, 0.143),
('canard', '0_3_mois',     'poulailler', 0.700, 0.200, 0.100, 2.0, 0.955);

-- ─── CHEVAUX — Écurie (selle) ───────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, straw_kg, cereal_kg, water_l, total_ration_kg) VALUES
('cheval_selle', '0_12_mois',  'ecurie',  4,  4, 4.5,  30, 12.5),
('cheval_selle', '12_24_mois', 'ecurie',  8,  8, 7.5,  70, 23.5),
('cheval_selle', '24_36_mois', 'ecurie', 12, 12, 12.0, 100, 36.0),
('cheval_selle', 'adulte_36plus','ecurie',18, 18, 18.0, 150, 54.0);

-- ─── CHEVAUX — Écurie (trait) ───────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, straw_kg, cereal_kg, water_l, total_ration_kg) VALUES
('cheval_trait', '0_12_mois',  'ecurie',  7,  7, 7.5,  60, 21.5),
('cheval_trait', '12_24_mois', 'ecurie', 12, 12, 12.0, 100, 36.0),
('cheval_trait', '24_36_mois', 'ecurie', 18, 18, 18.0, 150, 54.0),
('cheval_trait', 'adulte_36plus','ecurie',25, 25, 24.0, 200, 74.0);

-- ─── CHEVAUX — Écurie (poney) ───────────────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, straw_kg, cereal_kg, water_l, total_ration_kg) VALUES
('cheval_poney', '0_12_mois',  'ecurie',  3,  3, 3.0,  25,  9.0),
('cheval_poney', '12_24_mois', 'ecurie',  6,  6, 6.0,  50, 18.0),
('cheval_poney', '24_36_mois', 'ecurie',  9,  9, 9.0,  75, 27.0),
('cheval_poney', 'adulte_36plus','ecurie',12, 12, 12.0, 100, 36.0);

-- ─── BISONS — Ration hivernale (Oct→Mars) ───────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, cereal_kg, oilcake_kg, minerals_kg, water_l) VALUES
('bison', 'adulte_3plus',  'pre_hiver', 40, 18.0, 6.0, 1.0, 100),
('bison', '24_36_mois',    'pre_hiver', 32, 14.4, 4.8, 0.8,  60),
('bison', '18_24_mois',    'pre_hiver', 24, 10.8, 3.6, 0.6,  48),
('bison', '12_18_mois',    'pre_hiver', 20,  9.0, 3.0, 0.5,  40),
('bison', '6_12_mois',     'pre_hiver', 16,  7.2, 2.4, 0.4,  32),
('bison', '3_6_mois',      'pre_hiver',  8,  3.6, 1.2, 0.2,  20),
('bison', '0_3_mois',      'pre_hiver',  0,  0,   0,   0,     8);

-- ─── DAIMS — Ration hivernale (Oct→Mars) ────────────────────────────────────

INSERT INTO animal_ration (species, age_bracket, housing, hay_kg, cereal_kg, oilcake_kg, minerals_kg, water_l, total_ration_kg) VALUES
('daim', 'adulte_3plus',  'pre_hiver', 10, 3.0, 1.0, 0.25, 20, 14.25),
('daim', '24_36_mois',    'pre_hiver',  9, 2.7, 0.9, 0.23, 18, 12.83),
('daim', '18_24_mois',    'pre_hiver',  8, 2.4, 0.8, 0.20, 16, 11.40),
('daim', '12_18_mois',    'pre_hiver',  7, 2.1, 0.7, 0.18, 14,  9.98),
('daim', '6_12_mois',     'pre_hiver',  6, 1.8, 0.6, 0.15, 12,  8.55),
('daim', '3_6_mois',      'pre_hiver',  5, 1.5, 0.5, 0.13, 10,  7.13),
('daim', '0_3_mois',      'pre_hiver',  0, 0,   0,   0,     8,  0);
