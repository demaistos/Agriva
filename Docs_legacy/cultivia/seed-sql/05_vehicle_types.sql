-- =============================================================================
-- 05_vehicle_types.sql — Catalogue matériels agricoles (marques réelles)
-- =============================================================================
-- Source : docs/02-architecture/03_CONTENT_DATA.md §2 + 08_EQUILIBRAGE_ECONOMIQUE.md
-- Marques réelles : John Deere, Claas, New Holland, Fendt, Massey Ferguson,
--                   Case IH, Kubota, Deutz-Fahr, Valtra, Kuhn, Lemken, etc.
-- Prix ajustés pour l'économie Cultivia (tracteur 100CV ≈ 35 000€)
-- Consommation HVC en L/CV/HT (trajet 0.05, action variable)
-- =============================================================================

-- ─── TRACTEURS (15) ────────────────────────────────────────────────────────
-- Prix réel ~800-1000€/CV, ajusté Cultivia ~350€/CV

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('tracteur_kubota_m5091',     'Tracteur 50 CV',    'Kubota',          'M5-091',        'tracteur',  50,   NULL, 17500,  0.05, 0.10, true),
('tracteur_deutz_5080g',      'Tracteur 75 CV',    'Deutz-Fahr',      '5080 G',        'tracteur',  75,   NULL, 26000,  0.05, 0.10, true),
('tracteur_valtra_a85',       'Tracteur 85 CV',    'Valtra',          'A85',           'tracteur',  85,   NULL, 30000,  0.05, 0.10, true),
('tracteur_jd_6090mc',        'Tracteur 90 CV',    'John Deere',      '6090MC',        'tracteur',  90,   NULL, 32000,  0.05, 0.10, true),
('tracteur_nh_t5100',         'Tracteur 100 CV',   'New Holland',     'T5.100',        'tracteur', 100,   NULL, 35000,  0.05, 0.10, true),
('tracteur_mf_5711',          'Tracteur 110 CV',   'Massey Ferguson', '5711',          'tracteur', 110,   NULL, 38500,  0.05, 0.10, true),
('tracteur_caseih_puma130',   'Tracteur 130 CV',   'Case IH',         'Puma 130',      'tracteur', 130,   NULL, 45500,  0.05, 0.10, true),
('tracteur_claas_arion460',   'Tracteur 140 CV',   'Claas',           'Arion 460',     'tracteur', 140,   NULL, 49000,  0.05, 0.10, true),
('tracteur_fendt_516',        'Tracteur 165 CV',   'Fendt',           '516 Vario',     'tracteur', 165,   NULL, 58000,  0.05, 0.10, true),
('tracteur_jd_6175r',         'Tracteur 175 CV',   'John Deere',      '6175R',         'tracteur', 175,   NULL, 61000,  0.05, 0.10, true),
('tracteur_nh_t7210',         'Tracteur 210 CV',   'New Holland',     'T7.210',        'tracteur', 210,   NULL, 73500,  0.05, 0.10, true),
('tracteur_mf_7722',          'Tracteur 220 CV',   'Massey Ferguson', '7722',          'tracteur', 220,   NULL, 77000,  0.05, 0.10, true),
('tracteur_fendt_724',        'Tracteur 240 CV',   'Fendt',           '724 Vario',     'tracteur', 240,   NULL, 84000,  0.05, 0.10, true),
('tracteur_claas_axion870',   'Tracteur 295 CV',   'Claas',           'Axion 870',     'tracteur', 295,   NULL, 103000, 0.05, 0.10, true),
('tracteur_jd_8r410',         'Tracteur 410 CV',   'John Deere',      '8R 410',        'tracteur', 410,   NULL, 143500, 0.05, 0.10, true);

-- ─── MOISSONNEUSES-BATTEUSES (5) ───────────────────────────────────────────
-- Prix réel 200-400k€, ajusté Cultivia ~60-70% du réel

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('moissonneuse_mf_ideal7',   'Moissonneuse 250 CV', 'Massey Ferguson', 'Ideal 7',      'moissonneuse', 250, 6.0, 120000, 0.05, 0.125, true),
('moissonneuse_claas_530',    'Moissonneuse 280 CV', 'Claas',           'Lexion 530',   'moissonneuse', 280, 6.7, 135000, 0.05, 0.125, true),
('moissonneuse_nh_cr790',     'Moissonneuse 310 CV', 'New Holland',     'CR7.90',       'moissonneuse', 310, 7.3, 155000, 0.05, 0.125, true),
('moissonneuse_jd_t560',      'Moissonneuse 330 CV', 'John Deere',      'T560',         'moissonneuse', 330, 7.6, 170000, 0.05, 0.125, true),
('moissonneuse_caseih_8250',  'Moissonneuse 380 CV', 'Case IH',         '8250',         'moissonneuse', 380, 9.1, 200000, 0.05, 0.125, true);

-- ─── ENSILEUSES (3) ─────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('ensileuse_claas_840',       'Ensileuse 360 CV',    'Claas',           'Jaguar 840',   'ensileuse', 360, 3.0, 160000, 0.05, 0.150, true),
('ensileuse_jd_8500',         'Ensileuse 430 CV',    'John Deere',      '8500',         'ensileuse', 430, 3.0, 190000, 0.05, 0.150, true),
('ensileuse_nh_fr650',        'Ensileuse 490 CV',    'New Holland',     'FR 650',       'ensileuse', 490, 3.0, 220000, 0.05, 0.150, true);

-- ─── CHARRUES (5) ───────────────────────────────────────────────────────────
-- Prix réel 8-25k€, ajusté Cultivia ~60%

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('charrue_kuhn_vm123',        'Charrue 3 corps',     'Kuhn',            'Vari-Master 123', 'charrue', NULL, 1.05, 5100,  NULL, NULL, false),
('charrue_lemken_juwel7',     'Charrue 4 corps',     'Lemken',          'Juwel 7',         'charrue', NULL, 1.40, 6800,  NULL, NULL, false),
('charrue_gregoire_rw5',      'Charrue 5 corps',     'Grégoire Besson', 'RW5',             'charrue', NULL, 1.75, 8500,  NULL, NULL, false),
('charrue_kverneland_2500',   'Charrue 6 corps',     'Kverneland',      '2500 S',          'charrue', NULL, 2.10, 10200, NULL, NULL, false),
('charrue_amazone_cayron',    'Charrue 7 corps',     'Amazone',         'Cayron 200',      'charrue', NULL, 2.45, 12000, NULL, NULL, false);

-- ─── HERSES ROTATIVES (5) ──────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('herse_kuhn_hr2504',         'Herse rotative 2.5m', 'Kuhn',            'HR 2504',      'herse_rotative', NULL, 2.5, 7200,  NULL, NULL, false),
('herse_lemken_zirkon10',     'Herse rotative 3m',   'Lemken',          'Zirkon 10',    'herse_rotative', NULL, 3.0, 10200, NULL, NULL, false),
('herse_amazone_ke3001',      'Herse rotative 3m',   'Amazone',         'KE 3001',      'herse_rotative', NULL, 3.0, 9800,  NULL, NULL, false),
('herse_maschio_delfino',     'Herse rotative 4m',   'Maschio',         'Delfino 4000', 'herse_rotative', NULL, 4.0, 13500, NULL, NULL, false),
('herse_horsch_tiger4mt',     'Herse rotative 5m',   'Horsch',          'Tiger 4 MT',   'herse_rotative', NULL, 5.0, 18000, NULL, NULL, false);

-- ─── SEMOIRS (5) ────────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('semoir_amazone_d9_25',      'Semoir 2.5m',         'Amazone',         'D9 2500',      'semoir', NULL, 2.5, 9000,  NULL, NULL, false),
('semoir_kuhn_megant600',     'Semoir 3m',           'Kuhn',            'Megant 600',   'semoir', NULL, 3.0, 12750, NULL, NULL, false),
('semoir_horsch_pronto4dc',   'Semoir 4m',           'Horsch',          'Pronto 4 DC', 'semoir', NULL, 4.0, 22000, NULL, NULL, false),
('semoir_vaderstad_rapid',    'Semoir 5m',           'Väderstad',       'Rapid 500C',   'semoir', NULL, 5.0, 32000, NULL, NULL, false),
('semoir_lemken_solitair9',   'Semoir 6m',           'Lemken',          'Solitair 9',   'semoir', NULL, 6.0, 42000, NULL, NULL, false);

-- ─── ÉPANDEURS ENGRAIS (3) ──────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('epandeur_engrais_amazone',  'Épandeur engrais 12m','Amazone',         'ZA-TS 2000',   'epandeur_engrais', NULL, 12, 5100, NULL, NULL, false),
('epandeur_engrais_kuhn',     'Épandeur engrais 18m','Kuhn',            'Axis 30.2',    'epandeur_engrais', NULL, 18, 7500, NULL, NULL, false),
('epandeur_engrais_sulky',    'Épandeur engrais 24m','Sulky',           'X50 Econov',   'epandeur_engrais', NULL, 24, 9800, NULL, NULL, false);

-- ─── PULVÉRISATEURS (3) ─────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('pulve_berthoud_elyte',      'Pulvérisateur 12m',   'Berthoud',        'Elyte 800',    'pulverisateur', NULL, 12, 6800,  NULL, NULL, false),
('pulve_hardi_mega1200',      'Pulvérisateur 18m',   'Hardi',           'Mega 1200',    'pulverisateur', NULL, 18, 10200, NULL, NULL, false),
('pulve_jd_m740i',            'Pulvérisateur 24m',   'John Deere',      'M740i',        'pulverisateur', NULL, 24, 15000, NULL, NULL, false);

-- ─── PRESSES (3) ────────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('presse_claas_rollant455',   'Presse ronde 300kg',  'Claas',           'Rollant 455',  'presse', NULL, NULL, 22000, NULL, NULL, false),
('presse_nh_bb1290',          'Presse carrée 500kg', 'New Holland',     'BB 1290',      'presse', NULL, NULL, 45000, NULL, NULL, false),
('presse_kuhn_fb3135',        'Presse carrée 250kg', 'Kuhn',            'FB 3135',      'presse', NULL, NULL, 28000, NULL, NULL, false);

-- ─── FAUCHEUSES (3) ─────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('faucheuse_kuhn_gmd3125',    'Faucheuse 2.5m',      'Kuhn',            'GMD 3125',     'faucheuse', NULL, 2.5, 4250, NULL, NULL, false),
('faucheuse_claas_disco3200', 'Faucheuse 3m',        'Claas',           'Disco 3200',   'faucheuse', NULL, 3.0, 5500, NULL, NULL, false),
('faucheuse_krone_easycut',   'Faucheuse 3.5m',      'Krone',           'EasyCut 3210', 'faucheuse', NULL, 3.5, 6800, NULL, NULL, false);

-- ─── BENNES (3) ─────────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('benne_joskin_trans8',       'Benne 8T',            'Joskin',          'Trans-Space 7008', 'benne', NULL, NULL, 8500,  NULL, NULL, false),
('benne_rolland_turbo12',     'Benne 12T',           'Rolland',         'Turbo 120',        'benne', NULL, NULL, 10200, NULL, NULL, false),
('benne_littorale_16',        'Benne 16T',           'La Littorale',    'BL 160',           'benne', NULL, NULL, 13500, NULL, NULL, false);

-- ─── PLATEAUX (2) ───────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('plateau_rolland_6t',        'Plateau 6T',          'Rolland',         'Plateau 6000',  'plateau', NULL, NULL, 3400, NULL, NULL, false),
('plateau_joskin_10t',        'Plateau 10T',         'Joskin',          'Plateau 10000', 'plateau', NULL, NULL, 5100, NULL, NULL, false);

-- ─── BÉTAILLÈRES (2) ────────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('betaillere_joskin_betimax', 'Bétaillère 5T',       'Joskin',          'Betimax RDS 6000', 'betaillere', NULL, NULL, 6800, NULL, NULL, false),
('betaillere_rolland_bv64',   'Bétaillère 4T',       'Rolland',         'BV 64',            'betaillere', NULL, NULL, 4950, NULL, NULL, false);

-- ─── ÉPANDEURS FUMIER (2) ───────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('epandeur_fumier_joskin',    'Épandeur fumier 8T',  'Joskin',          'Tornado 3 7008', 'epandeur_fumier', NULL, NULL, 5950, NULL, NULL, false),
('epandeur_fumier_rolland',   'Épandeur fumier 10T', 'Rolland',         'Rollforce 5510', 'epandeur_fumier', NULL, NULL, 7500, NULL, NULL, false);

-- ─── TONNES À LISIER (2) ───────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('tonne_lisier_joskin',       'Tonne à lisier 10m³', 'Joskin',          'Modulo2 10000', 'tonne_lisier', NULL, NULL, 12000, NULL, NULL, false),
('tonne_lisier_pichon',       'Tonne à lisier 14m³', 'Pichon',          'TCI 14200',     'tonne_lisier', NULL, NULL, 16000, NULL, NULL, false);

-- ─── TÉLESCOPIQUE (1) ───────────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('telescopique_manitou',      'Télescopique',        'Manitou',         'MLT 737-130 PS+', 'telescopique', 130, NULL, 42000, 0.05, 0.120, true);


-- ─── UTILITAIRES (2) — Transport volailles, pintades, lapins, oies, canards ─
-- Véhicule motorisé (pas besoin de tracteur)

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('utilitaire_renault_master',  'Utilitaire 150 CV',  'Renault',  'Master L3H2',  'utilitaire', 150, NULL, 22000, 0.08, NULL, true),
('utilitaire_iveco_daily',     'Utilitaire 180 CV',  'Iveco',    'Daily 35S18',  'utilitaire', 180, NULL, 28000, 0.08, NULL, true);

-- ─── VANS (1) — Transport chevaux (tracté par utilitaire) ──────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('van_ifor_hb510',             'Van 2 places',       'Ifor Williams', 'HB510',  'van', NULL, NULL, 8500, NULL, NULL, false);


-- ─── CULTIVATEURS / DÉCHAUMEURS (3) — F037 stubble ─────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('cultivateur_lemken_karat9',  'Cultivateur 3m',     'Lemken',    'Karat 9',     'cultivateur', NULL, 3.0, 8500,  NULL, NULL, false),
('cultivateur_kuhn_prolander', 'Cultivateur 4m',     'Kuhn',      'Prolander',   'cultivateur', NULL, 4.0, 12000, NULL, NULL, false),
('cultivateur_horsch_terrano', 'Cultivateur 5m',     'Horsch',    'Terrano 5 FX','cultivateur', NULL, 5.0, 18000, NULL, NULL, false);

-- ─── ROULEAUX (2) — F054 ───────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('rouleau_dalbo_maxiroll',     'Rouleau 6m',         'Dal-Bo',    'MaxiRoll',    'rouleau', NULL, 6.0, 7500,  NULL, NULL, false),
('rouleau_cambridge_3m',       'Rouleau Cambridge 3m','Cambridge','Classic',     'rouleau', NULL, 3.0, 3500,  NULL, NULL, false);

-- ─── BROYEURS (2) — F060 ──────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('broyeur_kuhn_bpv280',        'Broyeur 2.8m',       'Kuhn',      'BPV 280',    'broyeur', NULL, 2.8, 6000,  NULL, NULL, false),
('broyeur_maschio_bisonte',    'Broyeur 3.2m',       'Maschio',   'Bisonte 320', 'broyeur', NULL, 3.2, 8500,  NULL, NULL, false);

-- ─── ENROULEURS IRRIGATION (2) — F058 ─────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('enrouleur_irrifrance_r38',   'Enrouleur 300m',     'Irrifrance','R38',         'enrouleur', NULL, NULL, 15000, NULL, NULL, false),
('enrouleur_bauer_rainstar',   'Enrouleur 500m',     'Bauer',     'Rainstar E55','enrouleur', NULL, NULL, 25000, NULL, NULL, false);

-- ─── ARRACHEUSES (3) — F041 cultures spéciales ────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('arracheuse_betterave_holmer', 'Arracheuse betterave','Holmer',   'Terra Dos T4','arracheuse_betterave', 530, 6.0, 280000, 0.05, 0.15, true),
('arracheuse_pdt_grimme',       'Arracheuse PDT',     'Grimme',   'SE 150-60',   'arracheuse_pdt',       NULL, 2.0, 85000,  NULL, NULL, false),
('arracheuse_lin_depoortere',   'Arracheuse lin',     'Depoortere','LM 420',     'arracheuse_lin',       NULL, 4.2, 45000,  NULL, NULL, false);

-- ─── SEMOIRS MONOGRAINE (2) — maïs, betterave, tournesol ──────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('semoir_mb_monosem_ng4',      'Semoir monograine 6r','Monosem',  'NG Plus 4',   'semoir_mb', NULL, 4.5, 18000, NULL, NULL, false),
('semoir_mb_kuhn_maxima2',     'Semoir monograine 8r','Kuhn',     'Maxima 2',    'semoir_mb', NULL, 6.0, 28000, NULL, NULL, false);

-- ─── BINEUSES (2) — pomme de terre, betterave ─────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('bineuse_monosem_6r',         'Bineuse 6 rangs',    'Monosem',  'Multicrop',   'bineuse', NULL, 4.5, 9000,  NULL, NULL, false),
('bineuse_kuhn_cultivator',    'Bineuse 8 rangs',    'Kuhn',     'Cultivator',  'bineuse', NULL, 6.0, 14000, NULL, NULL, false);

-- ─── PAILLEUSES (2) — F015 ────────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('pailleuse_kuhn_primor3570',  'Pailleuse',          'Kuhn',      'Primor 3570', 'pailleuse', NULL, NULL, 8500,  NULL, NULL, false),
('pailleuse_lucas_castor30',   'Pailleuse compacte', 'Lucas',     'Castor 30',   'pailleuse', NULL, NULL, 5500,  NULL, NULL, false);

-- ─── DÉSILEUSES (2) — F008 désilage ───────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('desileuse_kuhn_polycrok',    'Désileuse',          'Kuhn',      'Polycrok',    'desileuse', NULL, NULL, 10200, NULL, NULL, false),
('desileuse_lucas_castor20g',  'Désileuse compacte', 'Lucas',     'Castor 20 G', 'desileuse', NULL, NULL, 7500,  NULL, NULL, false);

-- ─── CITERNES À LAIT (2) — F024 ──────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('citerne_lait_joskin_2500',   'Citerne lait 2500L', 'Joskin',    'Modulo2 2500','citerne_lait', NULL, NULL, 8000,  NULL, NULL, false),
('citerne_lait_joskin_5000',   'Citerne lait 5000L', 'Joskin',    'Modulo2 5000','citerne_lait', NULL, NULL, 12000, NULL, NULL, false);

-- ─── TONNES À EAU (2) — F051 ─────────────────────────────────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('tonne_eau_joskin_5000',      'Tonne à eau 5000L',  'Joskin',    'Aquatrans 5000','tonne_eau', NULL, NULL, 6000,  NULL, NULL, false),
('tonne_eau_joskin_10000',     'Tonne à eau 10000L', 'Joskin',    'Aquatrans 10000','tonne_eau', NULL, NULL, 9500, NULL, NULL, false);


-- ─── SEMOIR DIRECT (1) — semis direct sans préparation sol ─────────────────

INSERT INTO vehicle_type (slug, name, brand, model, category, power_hp, width_m, price_new, fuel_consumption_travel, fuel_consumption_work, is_motorized) VALUES
('semoir_direct_horsch_avatar', 'Semoir direct 4m', 'Horsch', 'Avatar 4 SD', 'semoir_direct', NULL, 4.0, 35000, NULL, NULL, false);
