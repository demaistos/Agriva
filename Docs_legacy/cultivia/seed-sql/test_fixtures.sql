-- =============================================================================
-- test_fixtures.sql — Données de test pour Vitest/Supertest
-- =============================================================================
-- 5 joueurs avec des états différents pour couvrir tous les cas de test.
-- Exécuter APRÈS les seeds (01-12) et les migrations.
-- =============================================================================

-- Joueur 1 : Éleveur laitier riche (100k€, 4 vaches, stabulation, tout le matériel)
INSERT INTO player (id, username, email, balance, ht_today, ht_max, prefecture_id, kit)
VALUES ('11111111-1111-1111-1111-111111111111', 'test_eleveur', 'eleveur@test.com', 100000, 40, 40, 1, 'eleveur');

-- Joueur 2 : Cultivateur avec parcelle semée (blé en croissance 50%)
INSERT INTO player (id, username, email, balance, ht_today, ht_max, prefecture_id, kit)
VALUES ('22222222-2222-2222-2222-222222222222', 'test_cultivateur', 'cultivateur@test.com', 80000, 35, 40, 2, 'cultivateur');

-- Joueur 3 : Joueur fauché (solde = -25000€, proche plancher)
INSERT INTO player (id, username, email, balance, ht_today, ht_max, prefecture_id, kit)
VALUES ('33333333-3333-3333-3333-333333333333', 'test_fauche', 'fauche@test.com', -25000, 10, 40, 3, 'polyvalent');

-- Joueur 4 : Joueur avec 0 HT (tout dépensé)
INSERT INTO player (id, username, email, balance, ht_today, ht_max, prefecture_id, kit)
VALUES ('44444444-4444-4444-4444-444444444444', 'test_zero_ht', 'zeroht@test.com', 50000, 0, 40, 4, 'eleveur');

-- Joueur 5 : Joueur neuf (vient de s'inscrire, rien construit)
INSERT INTO player (id, username, email, balance, ht_today, ht_max, prefecture_id, kit)
VALUES ('55555555-5555-5555-5555-555555555555', 'test_nouveau', 'nouveau@test.com', 100000, 40, 40, 5, 'eleveur');

-- Bâtiments joueur 1
INSERT INTO building (id, player_id, building_type_id, name, size, level, floor_type)
VALUES (1, '11111111-1111-1111-1111-111111111111', 1, 'Stabulation Nord', 100, 1, 'litiere');

-- Animal joueur 1 (vache laitière, en bonne santé)
INSERT INTO animal (id, owner_id, breed_id, name, sex, life_stage, weight, health, building_id, status)
VALUES (1, '11111111-1111-1111-1111-111111111111', 1, 'Marguerite', 'female', 'adult', 650, 100, 1, 'available');

-- Animal joueur 1 (vache malade)
INSERT INTO animal (id, owner_id, breed_id, name, sex, life_stage, weight, health, is_sick, building_id, status)
VALUES (2, '11111111-1111-1111-1111-111111111111', 1, 'Rosalie', 'female', 'adult', 620, 30, true, 1, 'available');

-- Animal joueur 1 (taureau)
INSERT INTO animal (id, owner_id, breed_id, name, sex, life_stage, weight, health, building_id, status)
VALUES (3, '11111111-1111-1111-1111-111111111111', 1, 'Brutus', 'male', 'adult', 900, 100, 1, 'available');

-- Parcelle joueur 2 (10ha, blé semé)
INSERT INTO parcel (id, player_id, prefecture_id, type, size_ha)
VALUES (1, '22222222-2222-2222-2222-222222222222', 2, 'culture', 10);

-- Inventaire joueur 1 (foin, HVC)
INSERT INTO inventory (player_id, product, quantity, capacity)
VALUES ('11111111-1111-1111-1111-111111111111', 'hay', 2000, 10000);
INSERT INTO inventory (player_id, product, quantity, capacity)
VALUES ('11111111-1111-1111-1111-111111111111', 'hvc', 500, 2000);
