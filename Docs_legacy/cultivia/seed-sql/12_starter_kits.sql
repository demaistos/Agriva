-- =============================================================================
-- 12_starter_kits.sql — 3 kits de démarrage (matériel réel)
-- =============================================================================
-- Source : docs/02-architecture/08_EQUILIBRAGE_ECONOMIQUE.md §1
-- Marques réelles remplaçant les fictives :
--   Verdant → John Deere, Aureus → Claas, Novaterra → New Holland,
--   Feldmark → Fendt, Castor → Case IH, Fergusson → Massey Ferguson
-- Matériel usé (40-60%), 50% durée de vie consommée, fonctionnel, non revendable pendant 7 jours
-- =============================================================================

-- ─── DÉFINITION DES 3 KITS ─────────────────────────────────────────────────

INSERT INTO starter_kit (slug, name, emoji, tagline, description) VALUES
('cultivateur', 'Cultivateur', '🌾',
 'Tu veux labourer, semer et récolter. La terre est ton outil.',
 'Idéal pour les joueurs qui veulent se concentrer sur les cultures.'),
('eleveur', 'Éleveur', '🐄',
 'Tu veux élever des animaux, les nourrir, les soigner. Le troupeau est ta fierté.',
 'Idéal pour les joueurs qui veulent se concentrer sur l''élevage bovin.'),
('polyvalent', 'Polyvalent', '⚖️',
 'Tu veux un peu de tout. Cultures et élevage, à toi de choisir ta voie.',
 'Idéal pour les joueurs indécis ou qui veulent explorer.');

-- ─── KIT CULTIVATEUR 🌾 ─────────────────────────────────────────────────────
-- Total argus : ~100 130€
-- Le joueur peut cultiver immédiatement (déchaumer→récolter→transporter)

INSERT INTO starter_kit_item (kit_slug, item_type, vehicle_type_slug, brand, model, description, wear_pct, book_value) VALUES
('cultivateur', 'vehicle', 'tracteur_jd_6090mc',       'John Deere',      '6090MC',        'Tracteur 90 CV',          50, 17000),
('cultivateur', 'vehicle', 'charrue_lemken_juwel7',    'Lemken',          'Juwel 7',       'Charrue 4 corps',         40,  4080),
('cultivateur', 'vehicle', 'herse_lemken_zirkon10',    'Lemken',          'Zirkon 10',     'Herse rotative 3m',       40,  6120),
('cultivateur', 'vehicle', 'semoir_kuhn_megant600',    'Kuhn',            'Megant 600',    'Semoir 3m',               40,  7650),
('cultivateur', 'vehicle', 'epandeur_engrais_amazone', 'Amazone',         'ZA-TS 2000',    'Épandeur engrais 12m',    40,  3060),
('cultivateur', 'vehicle', 'pulve_berthoud_elyte',     'Berthoud',        'Elyte 800',     'Pulvérisateur 12m',       40,  4080),
('cultivateur', 'vehicle', 'moissonneuse_claas_530',   'Claas',           'Lexion 530',    'Moissonneuse 280 CV',     60, 51000),
('cultivateur', 'vehicle', 'benne_joskin_trans8',      'Joskin',          'Trans-Space 7008','Benne 10T',              40,  5100),
('cultivateur', 'vehicle', 'plateau_rolland_6t',       'Rolland',         'Plateau 6000',  'Plateau 6T',              40,  2040),
('cultivateur', 'vehicle', 'broyeur_kuhn_bpv280',      'Kuhn',            'BPV 280',       'Broyeur 2.8m',            40,  3600);

-- Bâtiments offerts kit Cultivateur
INSERT INTO starter_kit_item (kit_slug, item_type, building_type_slug, description, size_or_capacity) VALUES
('cultivateur', 'building', 'hangar',    'Hangar 100m² (niv.1)',   100),
('cultivateur', 'building', 'silo',      'Silo 20T',               20),
('cultivateur', 'building', 'entrepot',  'Entrepôt 50m²',          50);

-- ─── KIT ÉLEVEUR 🐄 ─────────────────────────────────────────────────────────
-- Total argus matériel : ~37 825€
-- + 4 vaches Montbéliarde + 1 taureau Montbéliard
-- Le joueur peut élever immédiatement (nourrir→traire→inséminer)

INSERT INTO starter_kit_item (kit_slug, item_type, vehicle_type_slug, brand, model, description, wear_pct, book_value) VALUES
('eleveur', 'vehicle', 'tracteur_nh_t5100',        'New Holland',     'T5.100',          'Tracteur 100 CV',         50, 14875),
('eleveur', 'vehicle', 'benne_joskin_trans8',       'Joskin',          'Trans-Space 7008','Benne 10T',               40,  5100),
('eleveur', 'vehicle', 'plateau_rolland_6t',        'Rolland',         'Plateau 6000',    'Plateau 6T',              40,  2040),
('eleveur', 'vehicle', 'betaillere_joskin_betimax', 'Joskin',          'Betimax RDS 6000','Bétaillère 5T',           40,  4080),
('eleveur', 'vehicle', 'epandeur_fumier_joskin',    'Joskin',          'Tornado 3 7008',  'Épandeur fumier 8T',      40,  3570),
('eleveur', 'vehicle', NULL,                        'Kuhn',            'Primor 3560',     'Pailleuse',               40,  2550),
('eleveur', 'vehicle', NULL,                        'Kuhn',            'Profile 1670',    'Désileuse',               40,  3060),
('eleveur', 'vehicle', 'faucheuse_kuhn_gmd3125',   'Kuhn',            'GMD 3125',        'Faucheuse 2.5m',          40,  2550),
('eleveur', 'vehicle', 'citerne_lait_joskin_2500',  'Joskin',          'Modulo2 2500',    'Citerne lait 2500L',      40,  4800);

-- Bâtiments offerts kit Éleveur
INSERT INTO starter_kit_item (kit_slug, item_type, building_type_slug, description, size_or_capacity) VALUES
('eleveur', 'building', 'hangar',       'Hangar 50m² (niv.1)',          50),
('eleveur', 'building', 'stabulation',  'Stabulation 100m² (niv.1)',   100),
('eleveur', 'building', 'silo',         'Silo 10T',                     10),
('eleveur', 'building', 'fosse_fumier', 'Fosse fumier 20T',             20),
('eleveur', 'building', 'citerne_eau',  'Citerne eau 10 000L',       10000),
('eleveur', 'building', 'salle_traite', 'Salle traite 4 postes',        4),
('eleveur', 'building', 'cuve_lait',    'Cuve lait 500L',             500);

-- Animaux offerts kit Éleveur
INSERT INTO starter_kit_item (kit_slug, item_type, breed_slug, description, quantity) VALUES
('eleveur', 'animal', 'montbeliarde', 'Vache Montbéliarde (2 ans, prête à inséminer)', 4),
('eleveur', 'animal', 'montbeliarde', 'Taureau Montbéliard (3 ans)',                    1);

-- ─── KIT POLYVALENT ⚖️ ──────────────────────────────────────────────────────
-- Total argus matériel : ~72 970€
-- + 2 vaches Prim'Holstein
-- Le joueur peut cultiver ET élever mais avec du matériel plus modeste

INSERT INTO starter_kit_item (kit_slug, item_type, vehicle_type_slug, brand, model, description, wear_pct, book_value) VALUES
('polyvalent', 'vehicle', 'tracteur_mf_5711',          'Massey Ferguson', '5711',          'Tracteur 110 CV',         50, 14875),
('polyvalent', 'vehicle', 'charrue_kuhn_vm123',        'Kuhn',            'Vari-Master 123','Charrue 3 corps',        45,  2805),
('polyvalent', 'vehicle', 'herse_kuhn_hr2504',         'Kuhn',            'HR 2504',       'Herse rotative 2.5m',     45,  3960),
('polyvalent', 'vehicle', 'semoir_amazone_d9_25',      'Amazone',         'D9 2500',       'Semoir 2.5m',             45,  4950),
('polyvalent', 'vehicle', 'moissonneuse_mf_ideal7',    'Massey Ferguson', 'Ideal 7',       'Moissonneuse 250 CV',     65, 37800),
('polyvalent', 'vehicle', 'benne_joskin_trans8',        'Joskin',          'Trans-Space 7008','Benne 8T',              45,  3740),
('polyvalent', 'vehicle', 'plateau_rolland_6t',         'Rolland',         'Plateau 6000',  'Plateau 6T',              45,  1870),
('polyvalent', 'vehicle', 'betaillere_rolland_bv64',    'Rolland',         'BV 64',         'Bétaillère 4T',           45,  2970),
('polyvalent', 'vehicle', 'citerne_lait_joskin_2500',   'Joskin',          'Modulo2 2500',  'Citerne lait 2500L',      45,  4800);

-- Bâtiments offerts kit Polyvalent
INSERT INTO starter_kit_item (kit_slug, item_type, building_type_slug, description, size_or_capacity) VALUES
('polyvalent', 'building', 'hangar',       'Hangar 80m² (niv.1)',         80),
('polyvalent', 'building', 'stabulation',  'Stabulation 50m² (niv.1)',    50),
('polyvalent', 'building', 'silo',         'Silo 15T',                    15),
('polyvalent', 'building', 'entrepot',     'Entrepôt 30m²',              30),
('polyvalent', 'building', 'citerne_eau',  'Citerne eau 5 000L',       5000),
('polyvalent', 'building', 'salle_traite', 'Salle traite 2 postes',       2),
('polyvalent', 'building', 'cuve_lait',    'Cuve lait 300L',            300);

-- Animaux offerts kit Polyvalent
INSERT INTO starter_kit_item (kit_slug, item_type, breed_slug, description, quantity) VALUES
('polyvalent', 'animal', 'primholstein', 'Vache Prim''Holstein (2 ans)', 2);
