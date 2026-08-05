-- =============================================================================
-- 01_server.sql — Serveur unique France
-- =============================================================================
-- Source : docs/05-design/03_IDENTITE_CULTIVIA.md §3.2
-- 1 seul serveur au lancement. France, difficulté normale.
-- =============================================================================

INSERT INTO server (name, country, difficulty, ht_per_day, initial_balance, min_balance, max_loan, employee_salary, announcement_cost, savings_rates, land_base_price_per_ha, transport_cost_per_kg_km, car_radius_km, ht_price)
VALUES (
    'France',           -- name : serveur unique
    'FR',               -- country
    2,                  -- difficulty : normale
    40,                 -- ht_per_day : 40 HT = 40h/semaine réaliste
    100000,             -- initial_balance : 100 000 € — départ modeste
    -30000,             -- min_balance : plancher découvert
    150000,             -- max_loan : augmenté post-audit E3
    1600,               -- employee_salary : €/mois
    800,                -- announcement_cost : coût annonce marché
    '{3, 4.5, 6}',     -- savings_rates : taux épargne (3 paliers)
    4500,               -- land_base_price_per_ha : modulé par coeff départemental
    0.02,               -- transport_cost_per_kg_km
    150,                -- car_radius_km : rayon max CAR
    10                  -- ht_price : 10 €/HT (achat/vente entre joueurs)
);
