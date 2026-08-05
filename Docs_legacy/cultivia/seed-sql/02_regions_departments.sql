-- =============================================================================
-- 02_regions_departments.sql — 13 régions métropolitaines + 96 départements
-- =============================================================================
-- Source : découpage administratif officiel (réforme 2016)
-- Les codes région correspondent aux codes INSEE officiels.
-- =============================================================================

-- ─── RÉGIONS ────────────────────────────────────────────────────────────────

INSERT INTO region (code, name) VALUES
('84', 'Auvergne-Rhône-Alpes'),
('27', 'Bourgogne-Franche-Comté'),
('53', 'Bretagne'),
('24', 'Centre-Val de Loire'),
('94', 'Corse'),
('44', 'Grand Est'),
('32', 'Hauts-de-France'),
('11', 'Île-de-France'),
('28', 'Normandie'),
('75', 'Nouvelle-Aquitaine'),
('76', 'Occitanie'),
('52', 'Pays de la Loire'),
('93', 'Provence-Alpes-Côte d''Azur');

-- ─── DÉPARTEMENTS ───────────────────────────────────────────────────────────
-- Format : (code, name, region_code)
-- 96 départements métropolitains (dont 2A/2B pour la Corse)

INSERT INTO department (code, name, region_code) VALUES
-- Auvergne-Rhône-Alpes (84)
('01', 'Ain', '84'),
('03', 'Allier', '84'),
('07', 'Ardèche', '84'),
('15', 'Cantal', '84'),
('26', 'Drôme', '84'),
('38', 'Isère', '84'),
('42', 'Loire', '84'),
('43', 'Haute-Loire', '84'),
('63', 'Puy-de-Dôme', '84'),
('69', 'Rhône', '84'),
('73', 'Savoie', '84'),
('74', 'Haute-Savoie', '84'),
-- Bourgogne-Franche-Comté (27)
('21', 'Côte-d''Or', '27'),
('25', 'Doubs', '27'),
('39', 'Jura', '27'),
('58', 'Nièvre', '27'),
('70', 'Haute-Saône', '27'),
('71', 'Saône-et-Loire', '27'),
('89', 'Yonne', '27'),
('90', 'Territoire de Belfort', '27'),
-- Bretagne (53)
('22', 'Côtes-d''Armor', '53'),
('29', 'Finistère', '53'),
('35', 'Ille-et-Vilaine', '53'),
('56', 'Morbihan', '53'),
-- Centre-Val de Loire (24)
('18', 'Cher', '24'),
('28', 'Eure-et-Loir', '24'),
('36', 'Indre', '24'),
('37', 'Indre-et-Loire', '24'),
('41', 'Loir-et-Cher', '24'),
('45', 'Loiret', '24'),
-- Corse (94)
('2A', 'Corse-du-Sud', '94'),
('2B', 'Haute-Corse', '94'),
-- Grand Est (44)
('08', 'Ardennes', '44'),
('10', 'Aube', '44'),
('51', 'Marne', '44'),
('52', 'Haute-Marne', '44'),
('54', 'Meurthe-et-Moselle', '44'),
('55', 'Meuse', '44'),
('57', 'Moselle', '44'),
('67', 'Bas-Rhin', '44'),
('68', 'Haut-Rhin', '44'),
('88', 'Vosges', '44'),
-- Hauts-de-France (32)
('02', 'Aisne', '32'),
('59', 'Nord', '32'),
('60', 'Oise', '32'),
('62', 'Pas-de-Calais', '32'),
('80', 'Somme', '32'),
-- Île-de-France (11)
('75', 'Paris', '11'),
('77', 'Seine-et-Marne', '11'),
('78', 'Yvelines', '11'),
('91', 'Essonne', '11'),
('92', 'Hauts-de-Seine', '11'),
('93', 'Seine-Saint-Denis', '11'),
('94', 'Val-de-Marne', '11'),
('95', 'Val-d''Oise', '11'),
-- Normandie (28)
('14', 'Calvados', '28'),
('27', 'Eure', '28'),
('50', 'Manche', '28'),
('61', 'Orne', '28'),
('76', 'Seine-Maritime', '28'),
-- Nouvelle-Aquitaine (75)
('16', 'Charente', '75'),
('17', 'Charente-Maritime', '75'),
('19', 'Corrèze', '75'),
('23', 'Creuse', '75'),
('24', 'Dordogne', '75'),
('33', 'Gironde', '75'),
('40', 'Landes', '75'),
('47', 'Lot-et-Garonne', '75'),
('64', 'Pyrénées-Atlantiques', '75'),
('79', 'Deux-Sèvres', '75'),
('86', 'Vienne', '75'),
('87', 'Haute-Vienne', '75'),
-- Occitanie (76)
('09', 'Ariège', '76'),
('11', 'Aude', '76'),
('12', 'Aveyron', '76'),
('30', 'Gard', '76'),
('31', 'Haute-Garonne', '76'),
('32', 'Gers', '76'),
('34', 'Hérault', '76'),
('46', 'Lot', '76'),
('48', 'Lozère', '76'),
('65', 'Hautes-Pyrénées', '76'),
('66', 'Pyrénées-Orientales', '76'),
('81', 'Tarn', '76'),
('82', 'Tarn-et-Garonne', '76'),
-- Pays de la Loire (52)
('44', 'Loire-Atlantique', '52'),
('49', 'Maine-et-Loire', '52'),
('53', 'Mayenne', '52'),
('72', 'Sarthe', '52'),
('85', 'Vendée', '52'),
-- Provence-Alpes-Côte d'Azur (93)
('04', 'Alpes-de-Haute-Provence', '93'),
('05', 'Hautes-Alpes', '93'),
('06', 'Alpes-Maritimes', '93'),
('13', 'Bouches-du-Rhône', '93'),
('83', 'Var', '93'),
('84', 'Vaucluse', '93');
