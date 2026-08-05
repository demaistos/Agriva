-- =============================================================================
-- 11_base_prices.sql — Prix de référence au Marché Central
-- =============================================================================
-- Source : docs/02-architecture/08_EQUILIBRAGE_ECONOMIQUE.md
-- Calibrage : 10ha de blé ≈ 15 000€ de revenu brut par saison
--   → 10ha × 7T/ha × 180€/T = 12 600€ (sol moyen, sans bonus)
--   → Avec engrais/traitement : ~15 000€ (objectif atteint)
-- Prix ajustés -10% vs réel pour maintenir la tension économique
-- =============================================================================

-- ─── CÉRÉALES & OLÉO-PROTÉAGINEUX ──────────────────────────────────────────

INSERT INTO base_price (slug, name, category, unit, base_price, price_min, price_max) VALUES
-- Céréales (prix réel ~200€/T blé, ajusté -10%)
('ble',              'Blé',                   'cereale',       'tonne', 200, 140, 240),
('orge',             'Orge',                  'cereale',       'tonne', 190, 150, 250),
('orge_printemps',   'Orge de printemps',     'cereale',       'tonne', 190, 150, 250),
('avoine',           'Avoine',                'cereale',       'tonne', 170, 130, 220),
('avoine_printemps', 'Avoine de printemps',   'cereale',       'tonne', 170, 130, 220),
('triticale',        'Triticale',             'cereale',       'tonne', 160, 120, 210),
('mais_grain',       'Maïs grain',            'cereale',       'tonne', 200, 160, 260),
-- Oléagineux
('colza',            'Colza',                 'oleagineux',    'tonne', 400, 320, 520),
('tournesol',        'Tournesol',             'oleagineux',    'tonne', 415, 330, 540),
-- Protéagineux
('pois',             'Pois',                  'proteagineux',  'tonne', 215, 170, 280),
('feverole',         'Féverole',              'proteagineux',  'tonne', 260, 210, 340),
('soja',             'Soja',                  'proteagineux',  'tonne', 300, 240, 390),
('lentille',         'Lentille',              'proteagineux',  'tonne', 1100, 880, 1430),
-- Industrielles
('betterave',        'Betterave',             'industrielle',  'tonne', 110, 88, 143),
('lin',              'Lin (fibre)',           'industrielle',  'tonne', 1170, 940, 1520),
('pomme_de_terre',   'Pomme de terre',        'industrielle',  'tonne', 72, 58, 94),
('chanvre_graine',   'Chanvre (graine)',      'industrielle',  'tonne', 315, 250, 410),
('chanvre_paille',   'Chanvre (paille)',      'industrielle',  'tonne', 108, 86, 140),
('tabac',            'Tabac',                 'industrielle',  'tonne', 4050, 3240, 5265),

-- ─── FOURRAGE ───────────────────────────────────────────────────────────────
('mais_ensile',      'Maïs ensilé',           'fourrage',      'tonne', 40, 32, 52),
('sorgho_ensile',    'Sorgho ensilé',         'fourrage',      'tonne', 45, 36, 59),
('luzerne',          'Luzerne',               'fourrage',      'tonne', 68, 54, 88),
('foin',             'Foin',                  'fourrage',      'tonne', 63, 50, 82),
('paille',           'Paille',                'fourrage',      'tonne', 45, 36, 59),

-- ─── MARAÎCHAGE ─────────────────────────────────────────────────────────────
('epinard',          'Épinard',               'maraichage',    'tonne', 108, 86, 140),
('haricot_vert',     'Haricot vert',          'maraichage',    'tonne', 175, 140, 228),

-- ─── PRODUITS ANIMAUX ───────────────────────────────────────────────────────
-- Lait : prix pour 1000L, varie selon indice Qualité Lait (QL 50 = base)
('lait_bovin',       'Lait bovin',            'lait',          '1000L', 320, 265, 400),
('lait_caprin',      'Lait caprin',           'lait',          '1000L', 600, 550, 640),
('lait_ovin',        'Lait ovin',             'lait',          '1000L', 900, 850, 940),

-- Viande (prix carcasse au kg)
('viande_bovin',     'Viande bovine',         'viande',        'kg', 4.50, 3.50, 6.00),
('viande_porc',      'Viande porcine',        'viande',        'kg', 1.80, 1.40, 2.40),
('viande_ovin',      'Viande ovine',          'viande',        'kg', 6.50, 5.00, 8.50),
('viande_caprin',    'Viande caprine',        'viande',        'kg', 5.00, 4.00, 6.50),
('viande_volaille',  'Viande volaille',       'viande',        'kg', 2.20, 1.70, 2.90),
('viande_lapin',     'Viande lapin',          'viande',        'kg', 5.50, 4.40, 7.15),
('viande_bison',     'Viande bison',          'viande',        'kg', 12.00, 9.60, 15.60),
('viande_daim',      'Viande daim',           'viande',        'kg', 15.00, 12.00, 19.50),

-- Œufs
('oeufs',            'Œufs',                  'oeuf',          'unite', 0.15, 0.10, 0.22),

-- Laine & duvet
('laine',            'Laine',                 'fibre',         'kg', 1.50, 1.00, 2.20),
('duvet_oie',        'Duvet d''oie',          'fibre',         'kg', 25.00, 20.00, 32.50),

-- Foie gras
('foie_gras_oie',    'Foie gras d''oie',      'foie_gras',     'kg', 22.50, 18.00, 29.25),
('foie_gras_canard', 'Foie gras de canard',   'foie_gras',     'kg', 22.50, 18.00, 29.25),

-- ─── INTRANTS ───────────────────────────────────────────────────────────────
('hvc',              'HVC (bio-carburant)',   'carburant',     'litre', 0.60, 0.36, 0.60),
('engrais_n',        'Engrais azoté (N)',     'engrais',       'kg', 0.90, 0.72, 1.17),
('engrais_p',        'Engrais phosphaté (P)', 'engrais',       'kg', 0.75, 0.60, 0.98),
('engrais_k',        'Engrais potassique (K)','engrais',       'kg', 0.65, 0.52, 0.85),
('traitement_phyto', 'Traitement phyto',      'traitement',    'ha', 45, 36, 59),
('concentre_jb',     'Concentré jeune bovin', 'aliment',       'kg', 0.35, 0.28, 0.46),
('tourteau_colza',   'Tourteau de colza',     'aliment',       'kg', 0.30, 0.24, 0.39),
('tourteau_soja',    'Tourteau de soja',      'aliment',       'kg', 0.40, 0.32, 0.52),
('mineraux_vit',     'Minéraux & vitamines',  'aliment',       'kg', 0.80, 0.64, 1.04),
('eau',              'Eau',                   'eau',           '1000L', 2.00, 1.60, 2.60);


-- ─── COMPLÉMENT PLAYTEST ────────────────────────────────────────────────────
('desherbant_defanage', 'Désherbant défanage', 'traitement', 'ha', 35, 28, 46);
