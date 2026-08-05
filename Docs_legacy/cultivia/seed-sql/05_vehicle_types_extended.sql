-- =============================================================================
-- 05_vehicle_types_extended.sql — Catalogue matériels agricoles ÉTENDU
-- =============================================================================
-- Version enrichie avec plus de marques et modèles réels par catégorie
-- ~200+ matériels, 40+ marques
-- Prix ajustés pour l'économie Agriva (~60-70% du prix réel)
-- Consommation HVC en L/CV/HT (trajet 0.05, action variable)
-- =============================================================================
-- MARQUES : John Deere, Claas, New Holland, Fendt, Massey Ferguson, Case IH,
--           Kubota, Deutz-Fahr, Valtra, Same, Landini, McCormick, Zetor,
--           Kuhn, Lemken, Amazone, Horsch, Väderstad, Kverneland, Pöttinger,
--           Grégoire Besson, Maschio, Sulky, Monosem, Berthoud, Hardi,
--           Joskin, Rolland, Fliegl, Krampe, La Littorale, Pichon, Deguillaume,
--           Claas, Krone, Lely, Manitou, Merlo, JCB, Holmer, Grimme,
--           Depoortere, Ifor Williams, Renault, Iveco, Dal-Bo, Cambridge,
--           Lucas, Irrifrance, Bauer
-- =============================================================================

-- ═══════════════════════════════════════════════════════════════════════════════
-- TRACTEURS (25) — Gamme complète 50-520 CV
-- ═══════════════════════════════════════════════════════════════════════════════
-- Prix réel ~800-1200€/CV neuf, ajusté Agriva ~350-450€/CV

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
-- Entrée de gamme (50-80 CV)
('tracteur_kubota_m5091',       'Tracteur 50 CV',    'Kubota',          'M5-091',          'tracteur',  50,  NULL, 17500,  0.05, 0.10, true),
('tracteur_zetor_proxima_65',   'Tracteur 65 CV',    'Zetor',           'Proxima CL 65',   'tracteur',  65,  NULL, 22000,  0.05, 0.10, true),
('tracteur_deutz_5080g',        'Tracteur 75 CV',    'Deutz-Fahr',      '5080 G',          'tracteur',  75,  NULL, 26000,  0.05, 0.10, true),
('tracteur_landini_5_100',      'Tracteur 80 CV',    'Landini',         '5-100',           'tracteur',  80,  NULL, 28000,  0.05, 0.10, true),
-- Polyvalents (85-120 CV)
('tracteur_valtra_a85',         'Tracteur 85 CV',    'Valtra',          'A85',             'tracteur',  85,  NULL, 30000,  0.05, 0.10, true),
('tracteur_jd_6090mc',          'Tracteur 90 CV',    'John Deere',      '6090MC',          'tracteur',  90,  NULL, 32000,  0.05, 0.10, true),
('tracteur_same_explorer_95',   'Tracteur 95 CV',    'Same',            'Explorer 95',     'tracteur',  95,  NULL, 33500,  0.05, 0.10, true),
('tracteur_nh_t5100',           'Tracteur 100 CV',   'New Holland',     'T5.100',          'tracteur', 100,  NULL, 35000,  0.05, 0.10, true),
('tracteur_mf_5711',            'Tracteur 110 CV',   'Massey Ferguson', '5711',            'tracteur', 110,  NULL, 38500,  0.05, 0.10, true),
('tracteur_mccormick_x7120',    'Tracteur 120 CV',   'McCormick',       'X7.620',          'tracteur', 120,  NULL, 42000,  0.05, 0.10, true),
-- Puissants (130-175 CV)
('tracteur_caseih_puma130',     'Tracteur 130 CV',   'Case IH',         'Puma 130',        'tracteur', 130,  NULL, 45500,  0.05, 0.10, true),
('tracteur_claas_arion460',     'Tracteur 140 CV',   'Claas',           'Arion 460',       'tracteur', 140,  NULL, 49000,  0.05, 0.10, true),
('tracteur_nh_t6155',           'Tracteur 155 CV',   'New Holland',     'T6.155',          'tracteur', 155,  NULL, 54000,  0.05, 0.10, true),
('tracteur_fendt_516',          'Tracteur 165 CV',   'Fendt',           '516 Vario',       'tracteur', 165,  NULL, 58000,  0.05, 0.10, true),
('tracteur_jd_6175r',           'Tracteur 175 CV',   'John Deere',      '6175R',           'tracteur', 175,  NULL, 61000,  0.05, 0.10, true),
-- Gros (180-250 CV)
('tracteur_mf_7718s',           'Tracteur 185 CV',   'Massey Ferguson', '7718 S',          'tracteur', 185,  NULL, 65000,  0.05, 0.10, true),
('tracteur_deutz_7250ttv',      'Tracteur 250 CV',   'Deutz-Fahr',      '7250 TTV',        'tracteur', 250,  NULL, 87500,  0.05, 0.10, true),
('tracteur_valtra_t235',        'Tracteur 235 CV',   'Valtra',          'T235 Direct',     'tracteur', 235,  NULL, 82000,  0.05, 0.10, true),
('tracteur_nh_t7210',           'Tracteur 210 CV',   'New Holland',     'T7.210',          'tracteur', 210,  NULL, 73500,  0.05, 0.10, true),
('tracteur_fendt_724',          'Tracteur 240 CV',   'Fendt',           '724 Vario',       'tracteur', 240,  NULL, 84000,  0.05, 0.10, true),
-- Très gros (280-520 CV)
('tracteur_claas_axion870',     'Tracteur 295 CV',   'Claas',           'Axion 870',       'tracteur', 295,  NULL, 103000, 0.05, 0.10, true),
('tracteur_caseih_optum300',    'Tracteur 300 CV',   'Case IH',         'Optum 300 CVX',   'tracteur', 300,  NULL, 105000, 0.05, 0.10, true),
('tracteur_jd_8r340',           'Tracteur 340 CV',   'John Deere',      '8R 340',          'tracteur', 340,  NULL, 125000, 0.05, 0.10, true),
('tracteur_jd_8r410',           'Tracteur 410 CV',   'John Deere',      '8R 410',          'tracteur', 410,  NULL, 143500, 0.05, 0.10, true),
('tracteur_fendt_1050',         'Tracteur 520 CV',   'Fendt',           '1050 Vario',      'tracteur', 520,  NULL, 195000, 0.05, 0.10, true);


-- ═══════════════════════════════════════════════════════════════════════════════
-- MOISSONNEUSES-BATTEUSES (10) — 200-625 CV
-- ═══════════════════════════════════════════════════════════════════════════════
-- Prix réel 200-500k€, ajusté Agriva ~60-70%

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('moissonneuse_claas_440',      'Moissonneuse 200 CV', 'Claas',           'Tucano 440',      'moissonneuse', 200, 5.4, 95000,  0.05, 0.125, true),
('moissonneuse_nh_cx5090',      'Moissonneuse 220 CV', 'New Holland',     'CX5.90',          'moissonneuse', 220, 5.5, 105000, 0.05, 0.125, true),
('moissonneuse_mf_ideal7',     'Moissonneuse 250 CV', 'Massey Ferguson', 'Ideal 7',          'moissonneuse', 250, 6.0, 120000, 0.05, 0.125, true),
('moissonneuse_jd_t560',        'Moissonneuse 270 CV', 'John Deere',      'T560',            'moissonneuse', 270, 6.7, 135000, 0.05, 0.125, true),
('moissonneuse_claas_6600',     'Moissonneuse 300 CV', 'Claas',           'Lexion 6600',     'moissonneuse', 300, 7.5, 155000, 0.05, 0.125, true),
('moissonneuse_nh_cr790',       'Moissonneuse 310 CV', 'New Holland',     'CR7.90',          'moissonneuse', 310, 7.3, 160000, 0.05, 0.125, true),
('moissonneuse_caseih_8250',    'Moissonneuse 380 CV', 'Case IH',         'Axial-Flow 8250', 'moissonneuse', 380, 9.1, 200000, 0.05, 0.125, true),
('moissonneuse_jd_s780',        'Moissonneuse 470 CV', 'John Deere',      'S780',            'moissonneuse', 470, 9.1, 250000, 0.05, 0.125, true),
('moissonneuse_claas_8700',     'Moissonneuse 585 CV', 'Claas',           'Lexion 8700',     'moissonneuse', 585, 10.5, 295000, 0.05, 0.125, true),
('moissonneuse_nh_cr1090',      'Moissonneuse 625 CV', 'New Holland',     'CR10.90',         'moissonneuse', 625, 10.7, 320000, 0.05, 0.125, true);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ENSILEUSES (6) — 300-900 CV
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('ensileuse_claas_830',         'Ensileuse 300 CV',    'Claas',           'Jaguar 830',      'ensileuse', 300, 3.0, 140000, 0.05, 0.150, true),
('ensileuse_krone_bigx480',     'Ensileuse 360 CV',    'Krone',           'BiG X 480',       'ensileuse', 360, 3.0, 165000, 0.05, 0.150, true),
('ensileuse_jd_8500',           'Ensileuse 430 CV',    'John Deere',      '8500',            'ensileuse', 430, 3.0, 190000, 0.05, 0.150, true),
('ensileuse_nh_fr650',          'Ensileuse 490 CV',    'New Holland',     'FR 650',          'ensileuse', 490, 3.0, 220000, 0.05, 0.150, true),
('ensileuse_claas_970',         'Ensileuse 630 CV',    'Claas',           'Jaguar 970',      'ensileuse', 630, 3.5, 290000, 0.05, 0.150, true),
('ensileuse_krone_bigx1180',    'Ensileuse 900 CV',    'Krone',           'BiG X 1180',      'ensileuse', 900, 3.5, 380000, 0.05, 0.150, true);


-- ═══════════════════════════════════════════════════════════════════════════════
-- CHARRUES (8) — 3 à 8 corps
-- ═══════════════════════════════════════════════════════════════════════════════
-- Prix réel 8-30k€, ajusté ~60%

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('charrue_kuhn_vm123',          'Charrue 3 corps',     'Kuhn',            'Vari-Master 123',   'charrue', NULL, 1.05, 5100,  NULL, NULL, false),
('charrue_lemken_juwel7_4',     'Charrue 4 corps',     'Lemken',          'Juwel 7',           'charrue', NULL, 1.40, 6800,  NULL, NULL, false),
('charrue_kverneland_2500_4',   'Charrue 4 corps',     'Kverneland',      '2500 S i-Plough',   'charrue', NULL, 1.40, 7200,  NULL, NULL, false),
('charrue_gregoire_rw5',        'Charrue 5 corps',     'Grégoire Besson', 'RW5',               'charrue', NULL, 1.75, 8500,  NULL, NULL, false),
('charrue_kuhn_vm153',          'Charrue 5 corps',     'Kuhn',            'Vari-Master 153',   'charrue', NULL, 1.75, 9200,  NULL, NULL, false),
('charrue_amazone_cayron200_6', 'Charrue 6 corps',     'Amazone',         'Cayron 200 V',      'charrue', NULL, 2.10, 10800, NULL, NULL, false),
('charrue_lemken_diamant_7',    'Charrue 7 corps',     'Lemken',          'Diamant 16',        'charrue', NULL, 2.45, 13500, NULL, NULL, false),
('charrue_kverneland_7_8',      'Charrue 8 corps',     'Kverneland',      '7 Furrow',          'charrue', NULL, 2.80, 16000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- HERSES ROTATIVES (8) — 2.5 à 6m
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('herse_kuhn_hr2504',           'Herse rotative 2.5m', 'Kuhn',            'HR 2504',           'herse_rotative', NULL, 2.5, 7200,  NULL, NULL, false),
('herse_amazone_ke3001',        'Herse rotative 3m',   'Amazone',         'KE 3001',           'herse_rotative', NULL, 3.0, 9800,  NULL, NULL, false),
('herse_lemken_zirkon10',       'Herse rotative 3m',   'Lemken',          'Zirkon 10',         'herse_rotative', NULL, 3.0, 10200, NULL, NULL, false),
('herse_maschio_delfino',       'Herse rotative 3.5m', 'Maschio',         'Delfino 3500',      'herse_rotative', NULL, 3.5, 11500, NULL, NULL, false),
('herse_kuhn_hr4004',           'Herse rotative 4m',   'Kuhn',            'HR 4004',           'herse_rotative', NULL, 4.0, 13500, NULL, NULL, false),
('herse_pottinger_lion4002',    'Herse rotative 4m',   'Pöttinger',       'Lion 4002',         'herse_rotative', NULL, 4.0, 14200, NULL, NULL, false),
('herse_horsch_tiger4mt',       'Herse rotative 5m',   'Horsch',          'Tiger 4 MT',        'herse_rotative', NULL, 5.0, 18000, NULL, NULL, false),
('herse_amazone_ke6001',        'Herse rotative 6m',   'Amazone',         'KE 6001-2',         'herse_rotative', NULL, 6.0, 24000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- CULTIVATEURS / DÉCHAUMEURS (8) — 3 à 8m
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('cultivateur_lemken_karat9_3', 'Cultivateur 3m',      'Lemken',          'Karat 9',           'cultivateur', NULL, 3.0, 8500,  NULL, NULL, false),
('cultivateur_kuhn_prolander4', 'Cultivateur 4m',      'Kuhn',            'Prolander 400',     'cultivateur', NULL, 4.0, 12000, NULL, NULL, false),
('cultivateur_amazone_cenius4', 'Cultivateur 4m',      'Amazone',         'Cenius 4003-2TX',   'cultivateur', NULL, 4.0, 13500, NULL, NULL, false),
('cultivateur_horsch_terrano5', 'Cultivateur 5m',      'Horsch',          'Terrano 5 FX',      'cultivateur', NULL, 5.0, 18000, NULL, NULL, false),
('cultivateur_vaderstad_topd5', 'Cultivateur 5m',      'Väderstad',       'TopDown 500',       'cultivateur', NULL, 5.0, 22000, NULL, NULL, false),
('cultivateur_lemken_korat_6',  'Cultivateur 6m',      'Lemken',          'Korat 6',           'cultivateur', NULL, 6.0, 26000, NULL, NULL, false),
('cultivateur_kuhn_cultimer_7', 'Cultivateur 7m',      'Kuhn',            'Cultimer L 7000',   'cultivateur', NULL, 7.0, 32000, NULL, NULL, false),
('cultivateur_horsch_cruiser8', 'Cultivateur 8m',      'Horsch',          'Cruiser 8 XL',      'cultivateur', NULL, 8.0, 38000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ROULEAUX (5) — 3 à 9m
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('rouleau_cambridge_3m',        'Rouleau Cambridge 3m','Cambridge',       'Classic',           'rouleau', NULL, 3.0, 3500,  NULL, NULL, false),
('rouleau_dalbo_maxiroll_6',    'Rouleau 6m',          'Dal-Bo',          'MaxiRoll 630',      'rouleau', NULL, 6.0, 7500,  NULL, NULL, false),
('rouleau_lemken_variopack',    'Rouleau 3.5m',        'Lemken',          'VarioPack 110',     'rouleau', NULL, 3.5, 5200,  NULL, NULL, false),
('rouleau_kuhn_manager_6',      'Rouleau 6.3m',        'Kuhn',            'Manager',           'rouleau', NULL, 6.3, 8500,  NULL, NULL, false),
('rouleau_dalbo_maxicut_9',     'Rouleau 9m',          'Dal-Bo',          'MaxiCut 900',       'rouleau', NULL, 9.0, 12000, NULL, NULL, false);


-- ═══════════════════════════════════════════════════════════════════════════════
-- SEMOIRS CÉRÉALES (10) — 2.5 à 9m
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('semoir_amazone_d9_25',        'Semoir 2.5m',         'Amazone',         'D9 2500',           'semoir', NULL, 2.5, 9000,  NULL, NULL, false),
('semoir_kuhn_megant600',       'Semoir 3m',           'Kuhn',            'Megant 600',        'semoir', NULL, 3.0, 12750, NULL, NULL, false),
('semoir_lemken_solitair9_3',   'Semoir 3m',           'Lemken',          'Solitair 9+',       'semoir', NULL, 3.0, 14000, NULL, NULL, false),
('semoir_pottinger_aerosem3',   'Semoir 3m',           'Pöttinger',       'Aerosem 3002',      'semoir', NULL, 3.0, 13500, NULL, NULL, false),
('semoir_horsch_pronto4dc',     'Semoir 4m',           'Horsch',          'Pronto 4 DC',       'semoir', NULL, 4.0, 22000, NULL, NULL, false),
('semoir_amazone_cirrus4003',   'Semoir 4m',           'Amazone',         'Cirrus 4003-2',     'semoir', NULL, 4.0, 24000, NULL, NULL, false),
('semoir_vaderstad_rapid_5',    'Semoir 5m',           'Väderstad',       'Rapid A 500C',      'semoir', NULL, 5.0, 32000, NULL, NULL, false),
('semoir_kuhn_espro6000',       'Semoir 6m',           'Kuhn',            'Espro 6000',        'semoir', NULL, 6.0, 42000, NULL, NULL, false),
('semoir_horsch_avatar8sd',     'Semoir direct 8m',    'Horsch',          'Avatar 8 SD',       'semoir', NULL, 8.0, 65000, NULL, NULL, false),
('semoir_vaderstad_rapid_9',    'Semoir 9m',           'Väderstad',       'Rapid A 900C',      'semoir', NULL, 9.0, 78000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- SEMOIRS MONOGRAINE (6) — maïs, betterave, tournesol
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('semoir_mb_monosem_ng4_6r',    'Semoir monograine 6 rangs', 'Monosem',  'NG Plus 4',        'semoir_mb', NULL, 4.5, 18000, NULL, NULL, false),
('semoir_mb_kuhn_maxima2_8r',   'Semoir monograine 8 rangs', 'Kuhn',     'Maxima 2 TI',      'semoir_mb', NULL, 6.0, 28000, NULL, NULL, false),
('semoir_mb_horsch_maistro8',   'Semoir monograine 8 rangs', 'Horsch',   'Maestro 8 RC',     'semoir_mb', NULL, 6.0, 35000, NULL, NULL, false),
('semoir_mb_amazone_edx6000',   'Semoir monograine 12 rangs','Amazone',  'EDX 6000-2C',      'semoir_mb', NULL, 9.0, 48000, NULL, NULL, false),
('semoir_mb_vaderstad_tempo_8', 'Semoir monograine 8 rangs', 'Väderstad','Tempo L 8',        'semoir_mb', NULL, 6.0, 42000, NULL, NULL, false),
('semoir_mb_jd_1775nt_12r',     'Semoir monograine 12 rangs','John Deere','1775NT',           'semoir_mb', NULL, 9.0, 55000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ÉPANDEURS ENGRAIS (7) — 12 à 36m de largeur d'épandage
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('epandeur_amazone_zats1700',   'Épandeur engrais 12m', 'Amazone',       'ZA-TS 1700',       'epandeur_engrais', NULL, 12, 4200,  NULL, NULL, false),
('epandeur_sulky_x40eco',       'Épandeur engrais 14m', 'Sulky',         'X40 Econov',       'epandeur_engrais', NULL, 14, 5100,  NULL, NULL, false),
('epandeur_kuhn_axis302',       'Épandeur engrais 18m', 'Kuhn',          'Axis 30.2 H-EMC',  'epandeur_engrais', NULL, 18, 7500,  NULL, NULL, false),
('epandeur_amazone_zats2000',   'Épandeur engrais 24m', 'Amazone',       'ZA-TS 2000',       'epandeur_engrais', NULL, 24, 9800,  NULL, NULL, false),
('epandeur_sulky_x50',          'Épandeur engrais 28m', 'Sulky',         'X50+ Econov',      'epandeur_engrais', NULL, 28, 12000, NULL, NULL, false),
('epandeur_kuhn_axis402',       'Épandeur engrais 32m', 'Kuhn',          'Axis 40.2 H-EMC',  'epandeur_engrais', NULL, 32, 14500, NULL, NULL, false),
('epandeur_amazone_zats3200',   'Épandeur engrais 36m', 'Amazone',       'ZA-TS 3200',       'epandeur_engrais', NULL, 36, 18000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PULVÉRISATEURS (8) — 12 à 36m, traînés et automoteurs
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('pulve_berthoud_elyte800',     'Pulvérisateur traîné 12m',  'Berthoud',  'Elyte 800',        'pulverisateur', NULL, 12, 6800,  NULL, NULL, false),
('pulve_hardi_mega1200',        'Pulvérisateur traîné 18m',  'Hardi',     'Mega 1200',        'pulverisateur', NULL, 18, 10200, NULL, NULL, false),
('pulve_amazone_ux5201',        'Pulvérisateur traîné 21m',  'Amazone',   'UX 5201',          'pulverisateur', NULL, 21, 18000, NULL, NULL, false),
('pulve_kuhn_metris4100',       'Pulvérisateur traîné 24m',  'Kuhn',      'Metris 2 4100',    'pulverisateur', NULL, 24, 22000, NULL, NULL, false),
('pulve_berthoud_raptor3600',   'Pulvérisateur traîné 28m',  'Berthoud',  'Raptor 3600',      'pulverisateur', NULL, 28, 28000, NULL, NULL, false),
('pulve_horsch_leeb7gs',        'Pulvérisateur traîné 30m',  'Horsch',    'Leeb 7 GS',        'pulverisateur', NULL, 30, 35000, NULL, NULL, false),
('pulve_amazone_pantera36',     'Pulvérisateur automoteur 36m','Amazone', 'Pantera 4503',     'pulverisateur', 300, 36, 180000, 0.05, 0.08, true),
('pulve_jd_r4060',              'Pulvérisateur automoteur 36m','John Deere','R4060',           'pulverisateur', 320, 36, 210000, 0.05, 0.08, true);


-- ═══════════════════════════════════════════════════════════════════════════════
-- PRESSES (8) — rondes et carrées
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('presse_claas_rollant455',     'Presse ronde 1.50m',  'Claas',           'Rollant 455',       'presse', NULL, NULL, 22000, NULL, NULL, false),
('presse_kuhn_fb3135',          'Presse ronde 1.25m',  'Kuhn',            'FB 3135',           'presse', NULL, NULL, 25000, NULL, NULL, false),
('presse_krone_comprima_v150',  'Presse ronde 1.50m',  'Krone',           'Comprima V 150 XC', 'presse', NULL, NULL, 32000, NULL, NULL, false),
('presse_jd_v461m',             'Presse ronde 1.80m',  'John Deere',      'V461M',             'presse', NULL, NULL, 35000, NULL, NULL, false),
('presse_claas_quadrant5300',   'Presse carrée HD',    'Claas',           'Quadrant 5300 FC',  'presse', NULL, NULL, 75000, NULL, NULL, false),
('presse_nh_bb1290',            'Presse carrée HD',    'New Holland',     'BigBaler 1290 Plus','presse', NULL, NULL, 85000, NULL, NULL, false),
('presse_krone_bigpack1290',    'Presse carrée HD',    'Krone',           'BiG Pack 1290 HDP', 'presse', NULL, NULL, 90000, NULL, NULL, false),
('presse_kuhn_lsb1290d',        'Presse carrée HD',    'Kuhn',            'LSB 1290 D',        'presse', NULL, NULL, 82000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- FAUCHEUSES (8) — 2 à 9m (frontales, latérales, papillon)
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('faucheuse_kuhn_gmd2811',      'Faucheuse frontale 2.8m', 'Kuhn',       'GMD 2811 FF',       'faucheuse', NULL, 2.8, 4800,  NULL, NULL, false),
('faucheuse_claas_disco3200',   'Faucheuse latérale 3m',   'Claas',      'Disco 3200 F',      'faucheuse', NULL, 3.2, 5500,  NULL, NULL, false),
('faucheuse_krone_easycut3210', 'Faucheuse latérale 3.2m', 'Krone',      'EasyCut F 3210',    'faucheuse', NULL, 3.2, 5800,  NULL, NULL, false),
('faucheuse_pottinger_nova3',   'Faucheuse latérale 3m',   'Pöttinger',  'Novacat 302',      'faucheuse', NULL, 3.0, 5200,  NULL, NULL, false),
('faucheuse_kuhn_fc3560tld',    'Faucheuse-conditionneuse 3.5m','Kuhn',  'FC 3560 TLD',       'faucheuse', NULL, 3.5, 12000, NULL, NULL, false),
('faucheuse_krone_bigm450',     'Faucheuse automotrice 9m', 'Krone',     'BiG M 450',         'faucheuse', 450, 9.0, 195000, 0.05, 0.12, true),
('faucheuse_claas_disco9200',   'Faucheuse papillon 8.7m', 'Claas',      'Disco 9200',       'faucheuse', NULL, 8.7, 28000, NULL, NULL, false),
('faucheuse_lely_splendimo9',   'Faucheuse papillon 9m',   'Lely',       'Splendimo 900 MC', 'faucheuse', NULL, 9.0, 30000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- FANEUSES (5) — 5 à 13m
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('faneuse_kuhn_gf5202',         'Faneuse 5.2m',        'Kuhn',            'GF 5202',          'faneuse', NULL, 5.2, 4500,  NULL, NULL, false),
('faneuse_claas_volto770',      'Faneuse 7.7m',        'Claas',           'Volto 770',        'faneuse', NULL, 7.7, 7500,  NULL, NULL, false),
('faneuse_pottinger_hit_8',     'Faneuse 8m',          'Pöttinger',       'Hit 8.91',         'faneuse', NULL, 8.9, 9200,  NULL, NULL, false),
('faneuse_krone_vendro_10',     'Faneuse 10m',         'Krone',           'Vendro 1020',      'faneuse', NULL, 10.0, 12000, NULL, NULL, false),
('faneuse_kuhn_gf13012',        'Faneuse 13m',         'Kuhn',            'GF 13012',         'faneuse', NULL, 13.0, 16000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ANDAINEURS (5) — simple et double
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('andaineur_kuhn_ga4321gm',    'Andaineur simple 4.3m','Kuhn',           'GA 4321 GM',        'andaineur', NULL, 4.3, 5500,  NULL, NULL, false),
('andaineur_claas_liner2700',  'Andaineur simple 7m',  'Claas',          'Liner 2700',        'andaineur', NULL, 7.0, 8500,  NULL, NULL, false),
('andaineur_pottinger_top702', 'Andaineur double 7m',  'Pöttinger',      'Top 702 C',         'andaineur', NULL, 7.0, 12000, NULL, NULL, false),
('andaineur_krone_swadro1400', 'Andaineur double 14m', 'Krone',          'Swadro TC 1400',    'andaineur', NULL, 14.0, 22000, NULL, NULL, false),
('andaineur_kuhn_merge_maxx', 'Andaineur à tapis',    'Kuhn',           'Merge Maxx 902',    'andaineur', NULL, 9.0, 35000, NULL, NULL, false);


-- ═══════════════════════════════════════════════════════════════════════════════
-- BENNES (7) — 6 à 24 tonnes
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('benne_rolland_6t',            'Benne 6T',            'Rolland',         'Rollspeed 6835',    'benne', NULL, NULL, 7200,  NULL, NULL, false),
('benne_joskin_trans8',         'Benne 8T',            'Joskin',          'Trans-Space 7008',  'benne', NULL, NULL, 8500,  NULL, NULL, false),
('benne_la_littorale_10t',     'Benne 10T',           'La Littorale',    'CL 100',            'benne', NULL, NULL, 9800,  NULL, NULL, false),
('benne_krampe_bandit12',      'Benne 12T',           'Krampe',          'Bandit 550',        'benne', NULL, NULL, 12000, NULL, NULL, false),
('benne_fliegl_asw14',         'Benne 14T',           'Fliegl',          'ASW 256 Compact',   'benne', NULL, NULL, 14500, NULL, NULL, false),
('benne_joskin_trans20',        'Benne 20T',           'Joskin',          'Trans-Space 8000/20','benne', NULL, NULL, 18000, NULL, NULL, false),
('benne_krampe_big_body24',    'Benne 24T',           'Krampe',          'Big Body 750',      'benne', NULL, NULL, 25000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLATEAUX (5) — 6 à 16 tonnes
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('plateau_rolland_6t',          'Plateau 6T',          'Rolland',         'Plateau 6000',      'plateau', NULL, NULL, 3400,  NULL, NULL, false),
('plateau_joskin_8t',           'Plateau 8T',          'Joskin',          'Wago-Loader 8',     'plateau', NULL, NULL, 5100,  NULL, NULL, false),
('plateau_fliegl_dpw10',       'Plateau 10T',         'Fliegl',          'DPW 100',           'plateau', NULL, NULL, 6800,  NULL, NULL, false),
('plateau_joskin_14t',          'Plateau 14T',         'Joskin',          'Wago-Loader 14',    'plateau', NULL, NULL, 8500,  NULL, NULL, false),
('plateau_rolland_16t',         'Plateau 16T',         'Rolland',         'Plateau 16000',     'plateau', NULL, NULL, 10500, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- BÉTAILLÈRES (5) — 4 à 12 places gros bétail
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('betaillere_rolland_bv64',     'Bétaillère 4 places', 'Rolland',         'BV 64',            'betaillere', NULL, NULL, 4950,  NULL, NULL, false),
('betaillere_joskin_betimax5',  'Bétaillère 6 places', 'Joskin',          'Betimax RDS 5000', 'betaillere', NULL, NULL, 6200,  NULL, NULL, false),
('betaillere_joskin_betimax6',  'Bétaillère 8 places', 'Joskin',          'Betimax RDS 6000', 'betaillere', NULL, NULL, 7800,  NULL, NULL, false),
('betaillere_fliegl_10pl',     'Bétaillère 10 places','Fliegl',          'Viehtransporter',   'betaillere', NULL, NULL, 9500,  NULL, NULL, false),
('betaillere_rolland_bv127',    'Bétaillère 12 places','Rolland',         'BV 127',           'betaillere', NULL, NULL, 12000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ÉPANDEURS FUMIER (6) — 6 à 18 tonnes
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('epandeur_fumier_rolland5',    'Épandeur fumier 6T',  'Rolland',         'Rollforce 4510',   'epandeur_fumier', NULL, NULL, 4800,  NULL, NULL, false),
('epandeur_fumier_joskin7',     'Épandeur fumier 8T',  'Joskin',          'Tornado 3 7008',   'epandeur_fumier', NULL, NULL, 5950,  NULL, NULL, false),
('epandeur_fumier_deguill10',   'Épandeur fumier 10T', 'Deguillaume',     'SVN 10',           'epandeur_fumier', NULL, NULL, 7500,  NULL, NULL, false),
('epandeur_fumier_joskin12',    'Épandeur fumier 12T', 'Joskin',          'Tornado 3 5512',   'epandeur_fumier', NULL, NULL, 9500,  NULL, NULL, false),
('epandeur_fumier_rolland14',   'Épandeur fumier 14T', 'Rolland',         'Rollforce 6614',   'epandeur_fumier', NULL, NULL, 11500, NULL, NULL, false),
('epandeur_fumier_joskin18',    'Épandeur fumier 18T', 'Joskin',          'Tornado 3 6818',   'epandeur_fumier', NULL, NULL, 15000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- TONNES À LISIER (6) — 6 à 24 m³
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('tonne_lisier_joskin_6m3',     'Tonne à lisier 6m³',  'Joskin',          'Modulo2 6000',     'tonne_lisier', NULL, NULL, 10000, NULL, NULL, false),
('tonne_lisier_pichon_8m3',     'Tonne à lisier 8m³',  'Pichon',          'TCI 8050',         'tonne_lisier', NULL, NULL, 12500, NULL, NULL, false),
('tonne_lisier_joskin_10m3',    'Tonne à lisier 10m³', 'Joskin',          'Modulo2 10000',    'tonne_lisier', NULL, NULL, 16000, NULL, NULL, false),
('tonne_lisier_joskin_14m3',    'Tonne à lisier 14m³', 'Joskin',          'Cobra 2 14000',    'tonne_lisier', NULL, NULL, 22000, NULL, NULL, false),
('tonne_lisier_pichon_18m3',    'Tonne à lisier 18m³', 'Pichon',          'TCI 18700',        'tonne_lisier', NULL, NULL, 28000, NULL, NULL, false),
('tonne_lisier_joskin_24m3',    'Tonne à lisier 24m³', 'Joskin',          'Volumetra 24000',  'tonne_lisier', NULL, NULL, 38000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- TÉLESCOPIQUES / CHARGEURS (6)
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('telescopique_manitou_mlt625', 'Télescopique 75 CV',  'Manitou',         'MLT 625-75 H',    'telescopique', 75,  NULL, 32000,  0.05, 0.120, true),
('telescopique_jcb_531_70',     'Télescopique 75 CV',  'JCB',             '531-70',           'telescopique', 75,  NULL, 34000,  0.05, 0.120, true),
('telescopique_manitou_mlt737', 'Télescopique 130 CV', 'Manitou',         'MLT 737-130 PS+',  'telescopique', 130, NULL, 45000,  0.05, 0.120, true),
('telescopique_merlo_p40_7',    'Télescopique 136 CV', 'Merlo',           'P 40.7',           'telescopique', 136, NULL, 48000,  0.05, 0.120, true),
('telescopique_jcb_541_70',     'Télescopique 145 CV', 'JCB',             '541-70 Agri Super','telescopique', 145, NULL, 52000,  0.05, 0.120, true),
('telescopique_manitou_mlt840', 'Télescopique 170 CV', 'Manitou',         'MLT 840-145 PS',   'telescopique', 170, NULL, 62000,  0.05, 0.120, true);

-- ═══════════════════════════════════════════════════════════════════════════════
-- BROYEURS (5) — 2 à 5m
-- ═══════════════════════════════════════════════════════════════════════════════

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('broyeur_kuhn_bpv280',         'Broyeur 2.8m',        'Kuhn',            'BPV 280',          'broyeur', NULL, 2.8, 6000,  NULL, NULL, false),
('broyeur_maschio_bisonte320',  'Broyeur 3.2m',        'Maschio',         'Bisonte 320',      'broyeur', NULL, 3.2, 8500,  NULL, NULL, false),
('broyeur_kuhn_bkv370',         'Broyeur 3.7m',        'Kuhn',            'BKV 370',          'broyeur', NULL, 3.7, 10500, NULL, NULL, false),
('broyeur_maschio_giraffa',     'Broyeur déportable 5m','Maschio',        'Giraffa 210',      'broyeur', NULL, 5.0, 14000, NULL, NULL, false),
('broyeur_kuhn_mulcher_5m',     'Broyeur 5m repliable', 'Kuhn',           'RM 500',           'broyeur', NULL, 5.0, 16000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- MATÉRIEL SPÉCIALISÉ — Arracheuses, bineuses, enrouleurs, pailleuses, etc.
-- ═══════════════════════════════════════════════════════════════════════════════

-- Arracheuses
INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('arracheuse_holmer_t4',        'Arracheuse betterave', 'Holmer',         'Terra Dos T4-40',   'arracheuse', 530, 6.0, 280000, 0.05, 0.15, true),
('arracheuse_ropa_tiger6s',     'Arracheuse betterave', 'Ropa',           'Tiger 6S',          'arracheuse', 600, 6.0, 320000, 0.05, 0.15, true),
('arracheuse_grimme_se150',     'Arracheuse PDT 2 rangs','Grimme',        'SE 150-60',         'arracheuse', NULL, 2.0, 85000,  NULL, NULL, false),
('arracheuse_grimme_varitron', 'Arracheuse PDT autom.','Grimme',          'Varitron 470',      'arracheuse', 460, 3.0, 350000, 0.05, 0.15, true),
('arracheuse_depoortere_lm420','Arracheuse lin',       'Depoortere',      'LM 420',           'arracheuse', NULL, 4.2, 45000,  NULL, NULL, false);

-- Bineuses
INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('bineuse_monosem_6r',          'Bineuse 6 rangs',     'Monosem',         'Multicrop',        'bineuse', NULL, 4.5, 9000,  NULL, NULL, false),
('bineuse_kuhn_cultivator8',    'Bineuse 8 rangs',     'Kuhn',            'Cultivator',       'bineuse', NULL, 6.0, 14000, NULL, NULL, false),
('bineuse_thomas_ecostar8',     'Bineuse 8 rangs',     'Thomas',          'Ecostar',          'bineuse', NULL, 6.0, 16000, NULL, NULL, false);

-- Enrouleurs irrigation
INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('enrouleur_irrifrance_r38',    'Enrouleur 300m',      'Irrifrance',      'R38',              'enrouleur', NULL, NULL, 15000, NULL, NULL, false),
('enrouleur_bauer_rainstar55',  'Enrouleur 500m',      'Bauer',           'Rainstar E55',     'enrouleur', NULL, NULL, 25000, NULL, NULL, false),
('enrouleur_irrifrance_r60',    'Enrouleur 700m',      'Irrifrance',      'Optima R60',       'enrouleur', NULL, NULL, 35000, NULL, NULL, false);

-- Pailleuses / Désileuses
INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('pailleuse_kuhn_primor3570',   'Pailleuse',           'Kuhn',            'Primor 3570 M',    'pailleuse', NULL, NULL, 8500,  NULL, NULL, false),
('pailleuse_lucas_castor30',    'Pailleuse compacte',  'Lucas',           'Castor 30 GR',     'pailleuse', NULL, NULL, 5500,  NULL, NULL, false),
('pailleuse_kuhn_primor5570m',  'Pailleuse grande',    'Kuhn',            'Primor 5570 M',    'pailleuse', NULL, NULL, 12000, NULL, NULL, false),
('desileuse_kuhn_polycrok',     'Désileuse',           'Kuhn',            'Polycrok 3850',    'desileuse', NULL, NULL, 10200, NULL, NULL, false),
('desileuse_lucas_castor20g',   'Désileuse compacte',  'Lucas',           'Castor 20 G',      'desileuse', NULL, NULL, 7500,  NULL, NULL, false),
('desileuse_kuhn_euromix',      'Mélangeuse-désileuse','Kuhn',            'Euromix I 1070',   'desileuse', NULL, NULL, 22000, NULL, NULL, false);

-- Citernes lait / Tonnes eau
INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('citerne_lait_joskin_2500',    'Citerne lait 2500L',  'Joskin',          'Modulo2 2500',     'citerne_lait', NULL, NULL, 8000,  NULL, NULL, false),
('citerne_lait_joskin_5000',    'Citerne lait 5000L',  'Joskin',          'Modulo2 5000',     'citerne_lait', NULL, NULL, 12000, NULL, NULL, false),
('tonne_eau_joskin_5000',       'Tonne à eau 5000L',   'Joskin',          'Aquatrans 5000',   'tonne_eau', NULL, NULL, 6000,  NULL, NULL, false),
('tonne_eau_joskin_10000',      'Tonne à eau 10000L',  'Joskin',          'Aquatrans 10000',  'tonne_eau', NULL, NULL, 9500,  NULL, NULL, false);

-- Utilitaires / Vans
INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('utilitaire_renault_master',   'Utilitaire 150 CV',   'Renault',         'Master L3H2',      'utilitaire', 150, NULL, 22000, 0.08, NULL, true),
('utilitaire_iveco_daily',      'Utilitaire 180 CV',   'Iveco',           'Daily 35S18',      'utilitaire', 180, NULL, 28000, 0.08, NULL, true),
('utilitaire_ford_transit',     'Utilitaire 170 CV',   'Ford',            'Transit L3H2',     'utilitaire', 170, NULL, 25000, 0.08, NULL, true),
('van_ifor_hb510',              'Van chevaux 2 places','Ifor Williams',   'HB510',            'van', NULL, NULL, 8500,  NULL, NULL, false),
('van_cheval_liberte_gold',     'Van chevaux 2 places','Cheval Liberté',  'Gold Pullman 2',   'van', NULL, NULL, 12000, NULL, NULL, false);

-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DU CATALOGUE — TOTAL : ~210 matériels, 45+ marques
-- ═══════════════════════════════════════════════════════════════════════════════
