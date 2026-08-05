-- =============================================================================
-- 13_parcel_prices.sql — Prix par hectare par type de parcelle
-- =============================================================================
-- Prix indicatifs, ajustés par préfecture via un facteur régional.
-- Le prix réel = base_price × regional_factor (0.5 à 2.0 selon la zone).

INSERT INTO parcel_price (type, base_price_per_ha, min_price, max_price) VALUES
('culture', 1500, 1000, 3000),
('pre',      1200,  800, 2000),
('verger',   8000, 5000, 15000),
('vigne',   25000, 10000, 50000),
('foret',    1000,  500, 2000);
