-- =============================================================================
-- 03_prefectures.sql — Préfectures et sous-préfectures de France métropolitaine
-- =============================================================================
-- Source : données INSEE/IGN publiques, coordonnées GPS arrondies à 2 décimales
-- 96 préfectures + ~230 sous-préfectures = ~330 villes jouables
-- Organisé par département (01 à 95, incluant 2A et 2B)
-- =============================================================================

-- 01 Ain
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Bourg-en-Bresse', '01', true, false, 46.21, 5.23),
('Belley', '01', false, true, 45.76, 5.69),
('Gex', '01', false, true, 46.33, 6.06),
('Nantua', '01', false, true, 46.15, 5.61);

-- 02 Aisne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Laon', '02', true, false, 49.56, 3.62),
('Château-Thierry', '02', false, true, 49.05, 3.40),
('Saint-Quentin', '02', false, true, 49.85, 3.29),
('Soissons', '02', false, true, 49.38, 3.32),
('Vervins', '02', false, true, 49.83, 3.91);

-- 03 Allier
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Moulins', '03', true, false, 46.57, 3.33),
('Montluçon', '03', false, true, 46.34, 2.60),
('Vichy', '03', false, true, 46.13, 3.43);

-- 04 Alpes-de-Haute-Provence
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Digne-les-Bains', '04', true, false, 44.09, 6.24),
('Barcelonnette', '04', false, true, 44.39, 6.65),
('Castellane', '04', false, true, 43.85, 6.51),
('Forcalquier', '04', false, true, 43.96, 5.78);

-- 05 Hautes-Alpes
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Gap', '05', true, false, 44.56, 6.08),
('Briançon', '05', false, true, 44.90, 6.64);

-- 06 Alpes-Maritimes
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Nice', '06', true, false, 43.70, 7.27),
('Grasse', '06', false, true, 43.66, 6.92);

-- 07 Ardèche
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Privas', '07', true, false, 44.74, 4.60),
('Largentière', '07', false, true, 44.54, 4.29),
('Tournon-sur-Rhône', '07', false, true, 45.07, 4.83);

-- 08 Ardennes
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Charleville-Mézières', '08', true, false, 49.77, 4.72),
('Rethel', '08', false, true, 49.51, 4.37),
('Sedan', '08', false, true, 49.70, 4.94),
('Vouziers', '08', false, true, 49.40, 4.70);

-- 09 Ariège
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Foix', '09', true, false, 42.97, 1.61),
('Pamiers', '09', false, true, 43.12, 1.61),
('Saint-Girons', '09', false, true, 42.98, 1.15);

-- 10 Aube
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Troyes', '10', true, false, 48.30, 4.07),
('Bar-sur-Aube', '10', false, true, 48.23, 4.71),
('Nogent-sur-Seine', '10', false, true, 48.49, 3.50);

-- 11 Aude
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Carcassonne', '11', true, false, 43.21, 2.35),
('Limoux', '11', false, true, 43.05, 2.22),
('Narbonne', '11', false, true, 43.18, 3.00);

-- 12 Aveyron
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Rodez', '12', true, false, 44.35, 2.57),
('Millau', '12', false, true, 44.10, 3.08),
('Villefranche-de-Rouergue', '12', false, true, 44.35, 2.04);

-- 13 Bouches-du-Rhône
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Marseille', '13', true, false, 43.30, 5.37),
('Aix-en-Provence', '13', false, true, 43.53, 5.45),
('Arles', '13', false, true, 43.68, 4.63),
('Istres', '13', false, true, 43.51, 4.99);

-- 14 Calvados
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Caen', '14', true, false, 49.18, -0.37),
('Bayeux', '14', false, true, 49.28, -0.70),
('Lisieux', '14', false, true, 49.15, 0.23),
('Vire', '14', false, true, 48.84, -0.89);

-- 15 Cantal
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Aurillac', '15', true, false, 44.93, 2.44),
('Mauriac', '15', false, true, 45.22, 2.33),
('Saint-Flour', '15', false, true, 45.03, 3.09);

-- 16 Charente
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Angoulême', '16', true, false, 45.65, 0.16),
('Cognac', '16', false, true, 45.70, -0.33),
('Confolens', '16', false, true, 46.01, 0.67);

-- 17 Charente-Maritime
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('La Rochelle', '17', true, false, 46.16, -1.15),
('Jonzac', '17', false, true, 45.45, -0.43),
('Rochefort', '17', false, true, 45.94, -0.96),
('Saintes', '17', false, true, 45.75, -0.63),
('Saint-Jean-d''Angély', '17', false, true, 45.94, -0.52);

-- 18 Cher
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Bourges', '18', true, false, 47.08, 2.40),
('Saint-Amand-Montrond', '18', false, true, 46.72, 2.50),
('Vierzon', '18', false, true, 47.22, 2.07);

-- 19 Corrèze
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Tulle', '19', true, false, 45.27, 1.77),
('Brive-la-Gaillarde', '19', false, true, 45.16, 1.53),
('Ussel', '19', false, true, 45.55, 2.31);

-- 2A Corse-du-Sud
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Ajaccio', '2A', true, false, 41.93, 8.74),
('Sartène', '2A', false, true, 41.62, 8.97);

-- 2B Haute-Corse
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Bastia', '2B', true, false, 42.70, 9.45),
('Calvi', '2B', false, true, 42.57, 8.76),
('Corte', '2B', false, true, 42.31, 9.15);

-- 21 Côte-d'Or
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Dijon', '21', true, false, 47.32, 5.04),
('Beaune', '21', false, true, 47.02, 4.84),
('Montbard', '21', false, true, 47.63, 4.34);

-- 22 Côtes-d'Armor
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Saint-Brieuc', '22', true, false, 48.51, -2.76),
('Dinan', '22', false, true, 48.45, -2.05),
('Guingamp', '22', false, true, 48.56, -3.15),
('Lannion', '22', false, true, 48.73, -3.46);

-- 23 Creuse
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Guéret', '23', true, false, 46.17, 1.87),
('Aubusson', '23', false, true, 45.96, 2.17);

-- 24 Dordogne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Périgueux', '24', true, false, 45.18, 0.72),
('Bergerac', '24', false, true, 44.85, 0.48),
('Nontron', '24', false, true, 45.53, 0.86),
('Sarlat-la-Canéda', '24', false, true, 44.89, 1.22);

-- 25 Doubs
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Besançon', '25', true, false, 47.24, 6.02),
('Montbéliard', '25', false, true, 47.51, 6.80),
('Pontarlier', '25', false, true, 46.91, 6.35);

-- 26 Drôme
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Valence', '26', true, false, 44.93, 4.89),
('Die', '26', false, true, 44.75, 5.37),
('Nyons', '26', false, true, 44.36, 5.14);

-- 27 Eure
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Évreux', '27', true, false, 49.02, 1.15),
('Bernay', '27', false, true, 49.09, 0.60),
('Les Andelys', '27', false, true, 49.25, 1.43);

-- 28 Eure-et-Loir
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Chartres', '28', true, false, 48.46, 1.50),
('Châteaudun', '28', false, true, 48.07, 1.33),
('Dreux', '28', false, true, 48.74, 1.37),
('Nogent-le-Rotrou', '28', false, true, 48.32, 0.82);

-- 29 Finistère
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Quimper', '29', true, false, 48.00, -4.10),
('Brest', '29', false, true, 48.39, -4.49),
('Châteaulin', '29', false, true, 48.20, -4.09),
('Morlaix', '29', false, true, 48.58, -3.83);

-- 30 Gard
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Nîmes', '30', true, false, 43.84, 4.36),
('Alès', '30', false, true, 44.12, 4.08),
('Le Vigan', '30', false, true, 43.99, 3.61);

-- 31 Haute-Garonne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Toulouse', '31', true, false, 43.60, 1.44),
('Muret', '31', false, true, 43.46, 1.33),
('Saint-Gaudens', '31', false, true, 43.11, 0.72);

-- 32 Gers
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Auch', '32', true, false, 43.65, 0.59),
('Condom', '32', false, true, 43.96, 0.37),
('Mirande', '32', false, true, 43.52, 0.40);

-- 33 Gironde
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Bordeaux', '33', true, false, 44.84, -0.58),
('Arcachon', '33', false, true, 44.66, -1.17),
('Blaye', '33', false, true, 45.13, -0.66),
('Langon', '33', false, true, 44.55, -0.25),
('Lesparre-Médoc', '33', false, true, 45.31, -0.94),
('Libourne', '33', false, true, 44.92, -0.24);

-- 34 Hérault
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Montpellier', '34', true, false, 43.61, 3.88),
('Béziers', '34', false, true, 43.34, 3.22),
('Lodève', '34', false, true, 43.73, 3.32);

-- 35 Ille-et-Vilaine
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Rennes', '35', true, false, 48.11, -1.68),
('Fougères', '35', false, true, 48.35, -1.20),
('Redon', '35', false, true, 47.65, -2.08),
('Saint-Malo', '35', false, true, 48.65, -2.00);

-- 36 Indre
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Châteauroux', '36', true, false, 46.81, 1.69),
('La Châtre', '36', false, true, 46.58, 1.99),
('Le Blanc', '36', false, true, 46.63, 1.07),
('Issoudun', '36', false, true, 46.95, 2.00);

-- 37 Indre-et-Loire
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Tours', '37', true, false, 47.39, 0.69),
('Chinon', '37', false, true, 47.17, 0.24),
('Loches', '37', false, true, 47.13, 1.00);

-- 38 Isère
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Grenoble', '38', true, false, 45.19, 5.72),
('La Tour-du-Pin', '38', false, true, 45.56, 5.44),
('Vienne', '38', false, true, 45.52, 4.87);

-- 39 Jura
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Lons-le-Saunier', '39', true, false, 46.67, 5.55),
('Dole', '39', false, true, 47.09, 5.49),
('Saint-Claude', '39', false, true, 46.39, 5.86);

-- 40 Landes
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Mont-de-Marsan', '40', true, false, 43.89, -0.50),
('Dax', '40', false, true, 43.71, -1.05);

-- 41 Loir-et-Cher
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Blois', '41', true, false, 47.59, 1.33),
('Romorantin-Lanthenay', '41', false, true, 47.36, 1.75),
('Vendôme', '41', false, true, 47.79, 1.07);

-- 42 Loire
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Saint-Étienne', '42', true, false, 45.44, 4.39),
('Montbrison', '42', false, true, 45.61, 4.06),
('Roanne', '42', false, true, 46.04, 4.07);

-- 43 Haute-Loire
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Le Puy-en-Velay', '43', true, false, 45.04, 3.88),
('Brioude', '43', false, true, 45.30, 3.38),
('Yssingeaux', '43', false, true, 45.14, 4.12);

-- 44 Loire-Atlantique
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Nantes', '44', true, false, 47.22, -1.55),
('Châteaubriant', '44', false, true, 47.72, -1.38),
('Saint-Nazaire', '44', false, true, 47.27, -2.21);

-- 45 Loiret
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Orléans', '45', true, false, 47.90, 1.90),
('Montargis', '45', false, true, 47.99, 2.73),
('Pithiviers', '45', false, true, 48.17, 2.25);

-- 46 Lot
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Cahors', '46', true, false, 44.45, 1.44),
('Figeac', '46', false, true, 44.61, 2.03),
('Gourdon', '46', false, true, 44.74, 1.38);

-- 47 Lot-et-Garonne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Agen', '47', true, false, 44.20, 0.62),
('Marmande', '47', false, true, 44.50, 0.16),
('Nérac', '47', false, true, 44.14, 0.34),
('Villeneuve-sur-Lot', '47', false, true, 44.41, 0.71);

-- 48 Lozère
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Mende', '48', true, false, 44.52, 3.50),
('Florac', '48', false, true, 44.33, 3.59);

-- 49 Maine-et-Loire
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Angers', '49', true, false, 47.47, -0.56),
('Cholet', '49', false, true, 47.06, -0.88),
('Saumur', '49', false, true, 47.26, -0.08),
('Segré', '49', false, true, 47.69, -0.87);

-- 50 Manche
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Saint-Lô', '50', true, false, 49.12, -1.09),
('Avranches', '50', false, true, 48.68, -1.36),
('Cherbourg-en-Cotentin', '50', false, true, 49.64, -1.62),
('Coutances', '50', false, true, 49.05, -1.44);

-- 51 Marne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Châlons-en-Champagne', '51', true, false, 48.96, 4.36),
('Épernay', '51', false, true, 49.04, 3.95),
('Reims', '51', false, true, 49.25, 3.88),
('Sainte-Ménehould', '51', false, true, 49.09, 4.90),
('Vitry-le-François', '51', false, true, 48.73, 4.58);

-- 52 Haute-Marne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Chaumont', '52', true, false, 48.11, 5.14),
('Langres', '52', false, true, 47.86, 5.33),
('Saint-Dizier', '52', false, true, 48.64, 4.95);

-- 53 Mayenne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Laval', '53', true, false, 48.07, -0.77),
('Château-Gontier', '53', false, true, 47.83, -0.70),
('Mayenne', '53', false, true, 48.30, -0.62);

-- 54 Meurthe-et-Moselle
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Nancy', '54', true, false, 48.69, 6.18),
('Briey', '54', false, true, 49.25, 5.94),
('Lunéville', '54', false, true, 48.59, 6.50),
('Toul', '54', false, true, 48.68, 5.89);

-- 55 Meuse
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Bar-le-Duc', '55', true, false, 48.77, 5.16),
('Commercy', '55', false, true, 48.76, 5.59),
('Verdun', '55', false, true, 49.16, 5.38);

-- 56 Morbihan
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Vannes', '56', true, false, 47.66, -2.76),
('Lorient', '56', false, true, 47.75, -3.37),
('Pontivy', '56', false, true, 48.07, -2.97);

-- 57 Moselle
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Metz', '57', true, false, 49.12, 6.18),
('Boulay-Moselle', '57', false, true, 49.18, 6.50),
('Château-Salins', '57', false, true, 48.82, 6.50),
('Forbach', '57', false, true, 49.19, 6.90),
('Sarrebourg', '57', false, true, 48.74, 7.05),
('Sarreguemines', '57', false, true, 49.11, 7.07),
('Thionville', '57', false, true, 49.36, 6.17);

-- 58 Nièvre
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Nevers', '58', true, false, 46.99, 3.16),
('Château-Chinon', '58', false, true, 47.07, 3.94),
('Clamecy', '58', false, true, 47.46, 3.52),
('Cosne-Cours-sur-Loire', '58', false, true, 47.41, 2.93);

-- 59 Nord
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Lille', '59', true, false, 50.63, 3.06),
('Avesnes-sur-Helpe', '59', false, true, 50.12, 3.93),
('Cambrai', '59', false, true, 50.18, 3.24),
('Douai', '59', false, true, 50.37, 3.08),
('Dunkerque', '59', false, true, 51.03, 2.38),
('Valenciennes', '59', false, true, 50.36, 3.52);

-- 60 Oise
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Beauvais', '60', true, false, 49.43, 2.08),
('Clermont', '60', false, true, 49.38, 2.41),
('Compiègne', '60', false, true, 49.42, 2.83),
('Senlis', '60', false, true, 49.21, 2.59);

-- 61 Orne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Alençon', '61', true, false, 48.43, 0.09),
('Argentan', '61', false, true, 48.74, -0.02),
('Mortagne-au-Perche', '61', false, true, 48.52, 0.55);

-- 62 Pas-de-Calais
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Arras', '62', true, false, 50.29, 2.78),
('Béthune', '62', false, true, 50.53, 2.64),
('Boulogne-sur-Mer', '62', false, true, 50.73, 1.61),
('Calais', '62', false, true, 50.95, 1.86),
('Lens', '62', false, true, 50.43, 2.83),
('Montreuil', '62', false, true, 50.46, 1.76),
('Saint-Omer', '62', false, true, 50.75, 2.26);

-- 63 Puy-de-Dôme
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Clermont-Ferrand', '63', true, false, 45.78, 3.08),
('Ambert', '63', false, true, 45.55, 3.74),
('Issoire', '63', false, true, 45.54, 3.25),
('Riom', '63', false, true, 45.89, 3.11),
('Thiers', '63', false, true, 45.86, 3.55);

-- 64 Pyrénées-Atlantiques
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Pau', '64', true, false, 43.30, -0.37),
('Bayonne', '64', false, true, 43.49, -1.47),
('Oloron-Sainte-Marie', '64', false, true, 43.19, -0.61);

-- 65 Hautes-Pyrénées
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Tarbes', '65', true, false, 43.23, 0.08),
('Argelès-Gazost', '65', false, true, 43.00, -0.10),
('Bagnères-de-Bigorre', '65', false, true, 43.06, 0.15);

-- 66 Pyrénées-Orientales
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Perpignan', '66', true, false, 42.70, 2.90),
('Céret', '66', false, true, 42.49, 2.75),
('Prades', '66', false, true, 42.62, 2.42);

-- 67 Bas-Rhin
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Strasbourg', '67', true, false, 48.57, 7.75),
('Haguenau', '67', false, true, 48.82, 7.79),
('Molsheim', '67', false, true, 48.54, 7.49),
('Saverne', '67', false, true, 48.74, 7.36),
('Sélestat', '67', false, true, 48.26, 7.45),
('Wissembourg', '67', false, true, 49.04, 7.95);

-- 68 Haut-Rhin
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Colmar', '68', true, false, 48.08, 7.36),
('Altkirch', '68', false, true, 47.62, 7.24),
('Mulhouse', '68', false, true, 47.75, 7.34),
('Ribeauvillé', '68', false, true, 48.19, 7.32),
('Thann', '68', false, true, 47.81, 7.10);

-- 69 Rhône
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Lyon', '69', true, false, 45.76, 4.84),
('Villefranche-sur-Saône', '69', false, true, 45.99, 4.72);

-- 70 Haute-Saône
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Vesoul', '70', true, false, 47.62, 6.15),
('Lure', '70', false, true, 47.69, 6.50);

-- 71 Saône-et-Loire
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Mâcon', '71', true, false, 46.31, 4.83),
('Autun', '71', false, true, 46.95, 4.30),
('Chalon-sur-Saône', '71', false, true, 46.78, 4.85),
('Charolles', '71', false, true, 46.43, 4.27),
('Louhans', '71', false, true, 46.63, 5.22);

-- 72 Sarthe
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Le Mans', '72', true, false, 48.00, 0.20),
('La Flèche', '72', false, true, 47.70, -0.08),
('Mamers', '72', false, true, 48.35, 0.37);

-- 73 Savoie
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Chambéry', '73', true, false, 45.57, 5.92),
('Albertville', '73', false, true, 45.68, 6.39),
('Saint-Jean-de-Maurienne', '73', false, true, 45.28, 6.35);

-- 74 Haute-Savoie
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Annecy', '74', true, false, 45.90, 6.13),
('Bonneville', '74', false, true, 46.08, 6.41),
('Saint-Julien-en-Genevois', '74', false, true, 46.14, 6.08),
('Thonon-les-Bains', '74', false, true, 46.37, 6.48);

-- 75 Paris
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Paris', '75', true, false, 48.86, 2.35);

-- 76 Seine-Maritime
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Rouen', '76', true, false, 49.44, 1.10),
('Dieppe', '76', false, true, 49.92, 1.08),
('Le Havre', '76', false, true, 49.49, 0.11);

-- 77 Seine-et-Marne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Melun', '77', true, false, 48.54, 2.66),
('Fontainebleau', '77', false, true, 48.40, 2.70),
('Meaux', '77', false, true, 48.96, 2.88),
('Provins', '77', false, true, 48.56, 3.30),
('Torcy', '77', false, true, 48.85, 2.66);

-- 78 Yvelines
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Versailles', '78', true, false, 48.80, 2.13),
('Mantes-la-Jolie', '78', false, true, 48.99, 1.72),
('Rambouillet', '78', false, true, 48.64, 1.83),
('Saint-Germain-en-Laye', '78', false, true, 48.90, 2.09);

-- 79 Deux-Sèvres
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Niort', '79', true, false, 46.32, -0.46),
('Bressuire', '79', false, true, 46.84, -0.49),
('Parthenay', '79', false, true, 46.65, -0.25);

-- 80 Somme
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Amiens', '80', true, false, 49.89, 2.30),
('Abbeville', '80', false, true, 50.11, 1.83),
('Montdidier', '80', false, true, 49.65, 2.57),
('Péronne', '80', false, true, 49.93, 2.94);

-- 81 Tarn
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Albi', '81', true, false, 43.93, 2.15),
('Castres', '81', false, true, 43.60, 2.24);

-- 82 Tarn-et-Garonne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Montauban', '82', true, false, 44.02, 1.35),
('Castelsarrasin', '82', false, true, 44.04, 1.11);

-- 83 Var
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Toulon', '83', true, false, 43.12, 5.93),
('Brignoles', '83', false, true, 43.41, 6.06),
('Draguignan', '83', false, true, 43.54, 6.46);

-- 84 Vaucluse
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Avignon', '84', true, false, 43.95, 4.81),
('Apt', '84', false, true, 43.88, 5.40),
('Carpentras', '84', false, true, 44.06, 5.05);

-- 85 Vendée
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('La Roche-sur-Yon', '85', true, false, 46.67, -1.43),
('Fontenay-le-Comte', '85', false, true, 46.47, -0.81),
('Les Sables-d''Olonne', '85', false, true, 46.50, -1.78);

-- 86 Vienne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Poitiers', '86', true, false, 46.58, 0.34),
('Châtellerault', '86', false, true, 46.82, 0.55),
('Montmorillon', '86', false, true, 46.43, 0.87);

-- 87 Haute-Vienne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Limoges', '87', true, false, 45.83, 1.26),
('Bellac', '87', false, true, 46.12, 1.05),
('Rochechouart', '87', false, true, 45.82, 0.82);

-- 88 Vosges
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Épinal', '88', true, false, 48.17, 6.45),
('Neufchâteau', '88', false, true, 48.35, 5.70),
('Saint-Dié-des-Vosges', '88', false, true, 48.29, 6.95);

-- 89 Yonne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Auxerre', '89', true, false, 47.80, 3.57),
('Avallon', '89', false, true, 47.49, 3.91),
('Sens', '89', false, true, 48.20, 3.28);

-- 90 Territoire de Belfort
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Belfort', '90', true, false, 47.64, 6.86);

-- 91 Essonne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Évry-Courcouronnes', '91', true, false, 48.63, 2.44),
('Étampes', '91', false, true, 48.43, 2.16),
('Palaiseau', '91', false, true, 48.71, 2.25);

-- 92 Hauts-de-Seine
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Nanterre', '92', true, false, 48.89, 2.21),
('Antony', '92', false, true, 48.75, 2.30),
('Boulogne-Billancourt', '92', false, true, 48.83, 2.24);

-- 93 Seine-Saint-Denis
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Bobigny', '93', true, false, 48.91, 2.44),
('Le Raincy', '93', false, true, 48.90, 2.52),
('Saint-Denis', '93', false, true, 48.94, 2.36);

-- 94 Val-de-Marne
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Créteil', '94', true, false, 48.79, 2.46),
('L''Haÿ-les-Roses', '94', false, true, 48.78, 2.34),
('Nogent-sur-Marne', '94', false, true, 48.84, 2.48);

-- 95 Val-d'Oise
INSERT INTO prefecture (name, department_code, is_prefecture, is_sous_prefecture, latitude, longitude) VALUES
('Cergy-Pontoise', '95', true, false, 49.04, 2.08),
('Argenteuil', '95', false, true, 48.95, 2.25),
('Sarcelles', '95', false, true, 48.97, 2.38);
