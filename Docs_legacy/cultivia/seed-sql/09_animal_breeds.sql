-- =============================================================================
-- 09_animal_breeds.sql — Races réelles par espèce
-- =============================================================================
-- Source : docs/02-architecture/03_CONTENT_DATA.md §9
-- Données : Institut de l'Élevage, INRAE, Races de France
-- Poids en kg, lait en L/traite ou L/jour, espérance en années
-- =============================================================================

-- ─── BOVINS LAITIERS ────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, milk_per_milking_l, lifespan_min, lifespan_max) VALUES
('primholstein',    'Prim''Holstein',    'bovin', 'laitier',    44, 700, 28, 10, 12),
('montbeliarde',    'Montbéliarde',      'bovin', 'laitier',    50, 700, 25, 10, 12),
('normande',        'Normande',          'bovin', 'laitier',    43, 750, 28, 10, 12),
('armoricaine',     'Armoricaine',       'bovin', 'laitier',    35, 680, 14, 10, 12),
('brune_alpes',     'Brune des Alpes',   'bovin', 'laitier',    35, 650, 26, 10, 12),
('vosgienne',       'Vosgienne',         'bovin', 'laitier',    35, 600, 14, 10, 12),
('brown_swiss',     'Brown Swiss',       'bovin', 'laitier',    35, 650, 26, 10, 12),
('jersiaise',       'Jersiaise',         'bovin', 'laitier',    20, 450, 18, 10, 12),
('red_holstein',    'Red Holstein',      'bovin', 'laitier',    45, 750, 28, 10, 12);

-- ─── BOVINS ALLAITANTS ──────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, milk_per_milking_l, lifespan_min, lifespan_max) VALUES
('charolaise',      'Charolaise',            'bovin', 'allaitant', 45, 750, 12, 10, 12),
('blonde_aquitaine','Blonde d''Aquitaine',   'bovin', 'allaitant', 44, 850, 12, 10, 12),
('limousine',       'Limousine',             'bovin', 'allaitant', 38, 670, 12, 10, 12),
('blanc_bleu_belge','Blanc Bleu Belge',      'bovin', 'allaitant', 45, 800, 10, 10, 12),
('parthenaise',     'Parthenaise',           'bovin', 'allaitant', 42, 800, 14, 10, 12),
('rouge_des_pres',  'Rouge des Prés',        'bovin', 'allaitant', 49, 850, 12, 10, 12),
('salers',          'Salers',                'bovin', 'allaitant', 36, 680, 12, 10, 12),
('aubrac',          'Aubrac',                'bovin', 'allaitant', 36, 650, 10, 10, 12);

-- ─── CAPRINS ────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, milk_per_day_l, wool_per_shearing_kg, lifespan_min, lifespan_max) VALUES
('alpine',          'Alpine',            'caprin', 'laitier',  2.2, 60,  2.7, 0,   7, 8),
('saanen',          'Saanen',            'caprin', 'laitier',  2.4, 70,  2.7, 0,   7, 8),
('poitevine',       'Poitevine',         'caprin', 'laitier',  2.2, 65,  2.7, 0,   7, 8),
('rove',            'Rove',              'caprin', 'laitier',  2.3, 65,  2.7, 0,   7, 8),
('corse_caprin',    'Corse',             'caprin', 'laitier',  2.1, 40,  2.4, 0,   7, 8),
('angora_caprin',   'Angora',            'caprin', 'lainier',  2.0, 30,  2.4, 2.0, 7, 8);

-- ─── OVINS LAITIERS ─────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, milk_per_day_l, wool_per_shearing_kg, litter_size, lifespan_min, lifespan_max) VALUES
('lacaune_lait',    'Lacaune Lait',      'ovin', 'laitier',   4.0, 75, 3.0, 0, 2, 7, 8),
('manech_noire',    'Manech Noire',      'ovin', 'laitier',   4.0, 50, 1.5, 2, 2, 7, 8),
('manech_rousse',   'Manech Rousse',     'ovin', 'laitier',   4.0, 45, 1.0, 2, 2, 7, 8);

-- ─── OVINS ALLAITANTS ───────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, wool_per_shearing_kg, litter_size, lifespan_min, lifespan_max) VALUES
('ile_de_france',   'Île-de-France',         'ovin', 'allaitant', 4.5, 80, 4.0, 2, 7, 8),
('charollais_ovin', 'Charollais',            'ovin', 'allaitant', 3.5, 90, 0,   2, 7, 8),
('texel',           'Texel',                 'ovin', 'allaitant', 5.0, 90, 3.0, 2, 7, 8),
('suffolk',         'Suffolk',               'ovin', 'allaitant', 3.0, 80, 0,   2, 7, 8),
('rouge_ouest',     'Rouge de l''Ouest',     'ovin', 'allaitant', 4.0, 75, 3.0, 2, 7, 8),
('blanche_mc',      'Blanche du Massif Central','ovin','allaitant',3.5, 65, 1.0, 2, 7, 8),
('merinos_arles',   'Mérinos d''Arles',      'ovin', 'allaitant', 3.5, 55, 5.5, 2, 7, 8),
('causses_lot',     'Causses du Lot',        'ovin', 'allaitant', 4.5, 60, 2.0, 2, 7, 8),
('charmoise',       'Charmoise',             'ovin', 'allaitant', 5.0, 70, 0,   2, 7, 8),
('berrichon_cher',  'Berrichon du Cher',     'ovin', 'allaitant', 5.0, 70, 3.0, 2, 7, 8);

-- ─── PORCINS ────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, lifespan_min, lifespan_max) VALUES
('large_white',     'Large White',       'porcin', 'standard', 1.5, 240, 3, 4),
('landrace_fr',     'Landrace Français', 'porcin', 'standard', 1.5, 230, 3, 4),
('pietrain',        'Piétrain',          'porcin', 'standard', 1.5, 220, 3, 4),
('duroc',           'Duroc',             'porcin', 'standard', 1.5, 240, 3, 4),
('penshire',        'Penshire',          'porcin', 'standard', 1.5, 220, 3, 4),
('hereford_porc',   'Hereford',          'porcin', 'standard', 1.5, 240, 3, 4);

-- ─── VOLAILLES ──────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_intensive_kg, adult_weight_semi_kg, eggs_per_day, lifespan_min, lifespan_max) VALUES
('charollaise_vol', 'Charollaise',           'volaille', 'pondeuse',  0.05, 2.5,  2.9, 4, 7, 8),
('gauloise',        'Gauloise',              'volaille', 'pondeuse',  0.05, 2.5,  2.9, 4, 7, 8),
('coucou_flandres',  'Coucou des Flandres',  'volaille', 'pondeuse',  0.05, 2.5,  2.9, 4, 7, 8),
('meusienne',       'Meusienne',             'volaille', 'chair',     0.05, 3.9,  4.5, 1, 7, 8),
('bourbourg_vol',   'Bourbourg',             'volaille', 'mixte',     0.05, 2.75, 3.2, 2, 7, 8);

-- ─── CHEVAUX — SELLE ────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_min_kg, birth_weight_max_kg, adult_weight_min_kg, adult_weight_max_kg, height_min_m, height_max_m, lifespan_min, lifespan_max) VALUES
('selle_francais',  'Selle Français',        'cheval', 'selle', 45, 55, 400, 550, 1.60, 1.65, 20, 22),
('pur_sang_anglais','Pur-Sang Anglais',      'cheval', 'selle', 45, 55, 400, 500, 1.49, 1.80, 20, 22),
('pur_sang_arabe',  'Pur-Sang Arabe',        'cheval', 'selle', 45, 55, 350, 400, 1.49, 1.60, 20, 22),
('anglo_arabe',     'Anglo-Arabe',           'cheval', 'selle', 45, 55, 450, 550, 1.49, 1.60, 20, 22),
('trotteur_fr',     'Trotteur Français',     'cheval', 'selle', 45, 55, 500, 650, 1.60, 1.70, 20, 22),
('quarter_horse',   'Quarter Horse',         'cheval', 'selle', 45, 55, 500, 650, 1.52, 1.63, 20, 22),
('frison',          'Frison',                'cheval', 'selle', 48, 55, 600, 800, 1.50, 1.60, 20, 22),
('hanovrien',       'Hanovrien',             'cheval', 'selle', 45, 55, 500, 600, 1.53, 1.70, 20, 22),
('appaloosa',       'Appaloosa',             'cheval', 'selle', 45, 55, 400, 450, 1.50, 1.63, 20, 22),
('paint_horse',     'Paint Horse',           'cheval', 'selle', 45, 55, 500, 650, 1.52, 1.60, 20, 22);

-- ─── CHEVAUX — TRAIT ────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_min_kg, birth_weight_max_kg, adult_weight_min_kg, adult_weight_max_kg, height_min_m, height_max_m, lifespan_min, lifespan_max) VALUES
('percheron',       'Percheron',             'cheval', 'trait', 50, 60, 500, 1200, 1.60, 1.85, 22, 25),
('comtois',         'Comtois',               'cheval', 'trait', 50, 60, 650,  800, 1.50, 1.65, 22, 25),
('breton',          'Breton',                'cheval', 'trait', 50, 60, 700,  800, 1.55, 1.63, 22, 25),
('ardennais',       'Ardennais',             'cheval', 'trait', 50, 60, 700, 1000, 1.60, 1.65, 22, 25),
('boulonnais',      'Boulonnais',            'cheval', 'trait', 50, 60, 650,  700, 1.60, 1.70, 22, 25),
('cob_normand',     'Cob Normand',           'cheval', 'trait', 50, 60, 550,  800, 1.60, 1.65, 22, 25),
('trait_du_nord',   'Trait du Nord',         'cheval', 'trait', 50, 60, 800, 1000, 1.65, 1.75, 22, 25);

-- ─── CHEVAUX — PONEY ────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_min_kg, birth_weight_max_kg, adult_weight_min_kg, adult_weight_max_kg, height_min_m, height_max_m, lifespan_min, lifespan_max) VALUES
('shetland',        'Shetland',              'cheval', 'poney', 15, 25, 150, 180, 0.90, 1.07, 28, 30),
('connemara',       'Connemara',             'cheval', 'poney', 15, 25, 380, 420, 1.28, 1.48, 28, 30),
('haflinger',       'Haflinger',             'cheval', 'poney', 15, 25, 340, 380, 1.35, 1.48, 28, 30),
('fjord',           'Fjord',                 'cheval', 'poney', 15, 25, 450, 550, 1.40, 1.48, 28, 30),
('camargue',        'Camargue',              'cheval', 'poney', 15, 25, 300, 400, 1.35, 1.45, 28, 30),
('merens',          'Mérens',                'cheval', 'poney', 15, 25, 400, 500, 1.35, 1.48, 28, 30),
('welsh',           'Welsh',                 'cheval', 'poney', 15, 25, 230, 270, 1.20, 1.38, 28, 30);

-- ─── OIES ───────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, adult_weight_kg, goslings_per_clutch_min, goslings_per_clutch_max, lifespan_min, lifespan_max) VALUES
('oie_bourbonnais',  'Oie Blanche du Bourbonnais', 'oie', 'chair',         7, 4, 10, 8, 10),
('oie_poitou',       'Oie Blanche du Poitou',      'oie', 'chair',         6, 4, 10, 8, 10),
('oie_normande',     'Oie Normande',                'oie', 'chair',         4, 4, 10, 8, 10),
('oie_guinee',       'Oie de Guinée',               'oie', 'chair',         4, 4, 10, 8, 10),
('oie_alsace',       'Oie d''Alsace',               'oie', 'foie_gras',     4, 4, 10, 8, 10),
('oie_toulouse',     'Oie de Toulouse',             'oie', 'foie_gras',     8, 4, 10, 8, 10),
('oie_landes',       'Oie Grise des Landes',        'oie', 'foie_gras',     6, 4, 10, 8, 10);

-- ─── CANARDS ────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, adult_weight_kg, eggs_per_day_min, eggs_per_day_max, lifespan_min, lifespan_max) VALUES
('canard_rouen',     'Canard de Rouen Clair',       'canard', 'chair',      3.0, 0, 4, 6, 8),
('canard_duclair',   'Canard Duclair',              'canard', 'chair',      2.5, 0, 4, 6, 8),
('canard_pekin',     'Canard de Pékin Allemand',    'canard', 'chair',      3.0, 0, 4, 6, 8),
('canard_bourbourg', 'Canard de Bourbourg',         'canard', 'chair',      3.0, 0, 4, 6, 8),
('canard_barbarie',  'Canard de Barbarie',          'canard', 'foie_gras',  4.0, 0, 4, 6, 8);

-- ─── LAPINS ─────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, wool_per_shearing_kg, lifespan_min, lifespan_max) VALUES
('argente_champagne','Argenté de Champagne',  'lapin', 'chair',   0.05, 4.5, 0,   5, 6),
('fauve_bourgogne',  'Fauve de Bourgogne',    'lapin', 'chair',   0.05, 4.5, 0,   5, 6),
('neo_zelandais',    'Néo Zélandais Blanc',   'lapin', 'chair',   0.05, 4.5, 0,   5, 6),
('bleu_vienne',      'Bleu de Vienne',        'lapin', 'chair',   0.05, 4.5, 0,   5, 6),
('angora_lapin',     'Angora',                'lapin', 'lainier', 0.05, 4.1, 0.3, 5, 6),
('rex_castor',       'Rex Castor',            'lapin', 'fourrure',0.05, 4.1, 0,   5, 6);

-- ─── PINTADES ───────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_intensive_kg, adult_weight_semi_kg, eggs_per_clutch_min, eggs_per_clutch_max, lifespan_min, lifespan_max) VALUES
('pintade_grise',    'Pintade grise',         'pintade', 'standard', 0.05, 2.5, 2.9, 8, 15, 7, 8);

-- ─── BISONS ─────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, lifespan_min, lifespan_max) VALUES
('bison_amerique',   'Bison d''Amérique',     'bison', 'standard', 25, 550, 20, 22),
('bison_europe',     'Bison d''Europe',       'bison', 'standard', 25, 550, 20, 22);

-- ─── DAIMS ──────────────────────────────────────────────────────────────────

INSERT INTO animal_breed (slug, name, species, breed_type, birth_weight_kg, adult_weight_kg, lifespan_min, lifespan_max) VALUES
('daim',             'Daim',                  'daim', 'standard', 3, 53, 18, 20);
