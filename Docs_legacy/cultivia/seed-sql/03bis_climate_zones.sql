-- 03bis — Zones climatiques
-- Réf: REUNION_PLENIERE_FINALE B3 / M27
-- Source: Météo-France classification simplifiée
-- Exécuter APRÈS 02_regions_departments.sql

-- Table des zones climatiques
CREATE TABLE IF NOT EXISTS climate_zone (
  id                  SERIAL PRIMARY KEY,
  name                VARCHAR(50) NOT NULL UNIQUE,
  base_rain           SMALLINT NOT NULL,  -- mm/an moyen
  base_sun            SMALLINT NOT NULL,  -- h/an moyen
  base_temp_winter    DECIMAL(4,1) NOT NULL,  -- °C moyen hiver
  base_temp_summer    DECIMAL(4,1) NOT NULL   -- °C moyen été
);

INSERT INTO climate_zone (name, base_rain, base_sun, base_temp_winter, base_temp_summer) VALUES
  ('Nord-Ouest',  800, 1700, 5.0, 20.0),
  ('Nord-Est',    700, 1650, 2.0, 22.0),
  ('Sud-Ouest',   750, 2000, 6.0, 25.0),
  ('Sud-Est',     650, 2600, 4.0, 27.0)
ON CONFLICT (name) DO NOTHING;

-- Mapping département → zone climatique
CREATE TABLE IF NOT EXISTS department_climate (
  department_code VARCHAR(10) NOT NULL,
  climate_zone_id INT NOT NULL REFERENCES climate_zone(id),
  PRIMARY KEY (department_code)
);

-- Nord-Ouest : Bretagne, Normandie, Pays de la Loire, Centre-Val de Loire
INSERT INTO department_climate (department_code, climate_zone_id) VALUES
  -- Bretagne
  ('22', 1), ('29', 1), ('35', 1), ('56', 1),
  -- Normandie
  ('14', 1), ('27', 1), ('50', 1), ('61', 1), ('76', 1),
  -- Pays de la Loire
  ('44', 1), ('49', 1), ('53', 1), ('72', 1), ('85', 1),
  -- Centre-Val de Loire
  ('18', 1), ('28', 1), ('36', 1), ('37', 1), ('41', 1), ('45', 1)
ON CONFLICT (department_code) DO NOTHING;

-- Nord-Est : Hauts-de-France, Grand Est, Bourgogne-Franche-Comté, Île-de-France
INSERT INTO department_climate (department_code, climate_zone_id) VALUES
  -- Hauts-de-France
  ('02', 2), ('59', 2), ('60', 2), ('62', 2), ('80', 2),
  -- Grand Est
  ('08', 2), ('10', 2), ('51', 2), ('52', 2), ('54', 2), ('55', 2), ('57', 2), ('67', 2), ('68', 2), ('88', 2),
  -- Bourgogne-Franche-Comté
  ('21', 2), ('25', 2), ('39', 2), ('58', 2), ('70', 2), ('71', 2), ('89', 2), ('90', 2),
  -- Île-de-France
  ('75', 2), ('77', 2), ('78', 2), ('91', 2), ('92', 2), ('93', 2), ('94', 2), ('95', 2)
ON CONFLICT (department_code) DO NOTHING;

-- Sud-Ouest : Nouvelle-Aquitaine, Occitanie ouest
INSERT INTO department_climate (department_code, climate_zone_id) VALUES
  -- Nouvelle-Aquitaine
  ('16', 3), ('17', 3), ('19', 3), ('23', 3), ('24', 3), ('33', 3), ('40', 3), ('47', 3), ('64', 3), ('79', 3), ('86', 3), ('87', 3),
  -- Occitanie ouest
  ('09', 3), ('12', 3), ('31', 3), ('32', 3), ('46', 3), ('65', 3), ('81', 3), ('82', 3)
ON CONFLICT (department_code) DO NOTHING;

-- Sud-Est : Auvergne-Rhône-Alpes, PACA, Occitanie est, Corse
INSERT INTO department_climate (department_code, climate_zone_id) VALUES
  -- Auvergne-Rhône-Alpes
  ('01', 4), ('03', 4), ('07', 4), ('15', 4), ('26', 4), ('38', 4), ('42', 4), ('43', 4), ('63', 4), ('69', 4), ('73', 4), ('74', 4),
  -- Provence-Alpes-Côte d'Azur
  ('04', 4), ('05', 4), ('06', 4), ('13', 4), ('83', 4), ('84', 4),
  -- Occitanie est
  ('11', 4), ('30', 4), ('34', 4), ('48', 4), ('66', 4),
  -- Corse
  ('2A', 4), ('2B', 4)
ON CONFLICT (department_code) DO NOTHING;
