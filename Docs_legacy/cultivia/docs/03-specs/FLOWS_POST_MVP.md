# Flows Post-MVP — Sprints 14-17+

> Toutes les features post-MVP définies comme flows.

---

## Sprint 14 — Labels, Météo, QoL (10 flows + F199)

### F139 — Demander label bio
- **Page :** /parcels/:id
- **Trigger :** button "Demander label bio"
- **Condition :** Parcelle sans traitement chimique depuis 2 ans (168j), balance >= 500€
- **Disabled+tooltip :** "Traitement chimique il y a Xj (min 168j)" / "Solde insuffisant (500€)"
- **Requires :** parcelle owned, no chemical_treatment 168j
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND owner_id=$2`
  - `SELECT MAX(applied_at) FROM parcel_treatment WHERE parcel_id=$1 AND is_chemical=true`
  - `CHECK applied_at < NOW() - INTERVAL '168 days'`
  - `UPDATE parcel SET label='bio' WHERE id=$1`
  - `UPDATE player SET balance = balance - 500 WHERE id=$1`
  - `INSERT INTO transaction (player_id, amount, category, description)`
- **Idempotency :** Oui. Si déjà bio → 409 "Parcelle déjà labellisée bio"
- **Toast :** "🌿 Label bio obtenu ! Prix de vente ×1.5"
- **Animate :** balance
- **Tests :**
  - GIVEN 0 chimique 170j + 500€ WHEN request THEN label=bio, balance -500
  - GIVEN chimique il y a 100j THEN 400 ERR_LABEL_TOO_EARLY
  - GIVEN déjà bio THEN 409 ERR_ALREADY_LABELED
  - GIVEN balance 200€ THEN 400 ERR_INSUFFICIENT_BALANCE

### F140 — Demander label plein-air
- **Page :** /buildings/:id (poulailler/porcherie)
- **Trigger :** button "Demander label plein-air"
- **Condition :** Parc extérieur associé, surface ≥ 10m²/animal, balance >= 300€
- **Disabled+tooltip :** "Pas de parc extérieur associé" / "Surface insuffisante (Xm²/animal, min 10)"
- **Requires :** building owned, parc linked, surface/animal >= 10
- **SQL chain :**
  - `SELECT FOR UPDATE building WHERE id=$1 AND owner_id=$2`
  - `SELECT b2.capacity FROM building b2 WHERE b2.parent_id=$1 AND b2.type='parc_%'`
  - `SELECT COUNT(*) as nb FROM animal WHERE building_id=$1`
  - `CHECK parc.capacity / nb >= 10`
  - `UPDATE building SET label='plein_air' WHERE id=$1`
  - `UPDATE player SET balance = balance - 300 WHERE id=$1`
  - `INSERT INTO transaction`
- **Idempotency :** Oui. Déjà labellisé → 409
- **Toast :** "🐔 Label plein-air obtenu ! Prix ×1.3"
- **Animate :** balance
- **Tests :**
  - GIVEN parc 500m² + 50 poules THEN label=plein_air
  - GIVEN parc 200m² + 50 poules THEN 400 ERR_SURFACE_TOO_SMALL
  - GIVEN no parc THEN 400 ERR_NO_OUTDOOR_AREA

### F141 — Tick événement météo destructeur
- **Type :** worker_tick (étape 3bis, après updateWeather)
- **Trigger :** tick journalier, probabilité par saison
- **Probabilités :** grêle (été 5%), gel sévère (hiver 8%), tempête (automne 3%), canicule (été 3%)
- **Requires :** aucun (automatique)
- **SQL chain :**
  - `SELECT id, season FROM game_time`
  - `random() < probability → event triggered`
  - Par joueur affecté :
    - Grêle : `UPDATE parcel SET yield_modifier = yield_modifier * (1 - random()*0.6 - 0.2) WHERE crop_status='growing' AND prefecture_id IN (affected)`
    - Gel : `UPDATE parcel SET crop_status='destroyed' WHERE crop_growth < 20 AND prefecture_id IN (affected)`
    - Tempête : `UPDATE vehicle SET wear = LEAST(100, wear + 10) WHERE is_sheltered=false AND owner_id=player_id`
    - Canicule : `UPDATE animal SET welfare_index = GREATEST(0, welfare_index - 10) WHERE building_id IN (no_ventilation)`
  - `INSERT INTO event_log (type, affected_prefectures, date)`
  - `INSERT INTO notification (player_id, type, message) FOR EACH affected player`
- **Idempotency :** 1 event max par type par jour (check event_log)
- **Toast :** WS push "⛈️ Grêle ! 3 parcelles touchées, rendement -40%"
- **Tests :**
  - GIVEN été + random < 0.05 THEN grêle event created
  - GIVEN grêle + parcelle growing THEN yield_modifier reduced
  - GIVEN gel + crop_growth 15% THEN crop destroyed
  - GIVEN tempête + véhicule non abrité THEN wear +10
  - GIVEN déjà 1 grêle today THEN pas de 2ème

### F142 — Voir achievements/milestones
- **Page :** /achievements
- **Trigger :** navigation
- **Condition :** aucune (lecture)
- **Requires :** authenticated
- **SQL chain :**
  - `SELECT * FROM achievement_definition`
  - `SELECT * FROM player_achievement WHERE player_id=$1`
  - `LEFT JOIN pour afficher unlocked/locked`
- **Composants :** Grille badges (bronze/argent/or), progress bar par achievement
- **Achievements :** Première traite 🥛, 1000L lait, 100T blé, 10 naissances, 1 an de jeu, 50 vaches, Millionnaire, Bien-être 100, Sol santé 100
- **Tests :**
  - GIVEN 3 achievements unlocked THEN affiche 3 dorés + reste grisé

### F143 — Tutoriel contextuel (popup première action)
- **Type :** frontend automatique
- **Trigger :** première occurrence d'une action (first milking, first harvest, first P2P buy)
- **Requires :** authenticated, action not yet done
- **SQL chain :**
  - `SELECT step FROM tutorial_progress WHERE player_id=$1 AND step=$2`
  - Si absent : afficher popup
  - `INSERT INTO tutorial_progress (player_id, step, completed_at) ON CONFLICT DO NOTHING`
- **Idempotency :** ON CONFLICT DO NOTHING
- **Toast :** "🎉 Première traite ! Conseil : trayez 2×/jour pour maximiser la production"
- **Tests :**
  - GIVEN first milking THEN popup shown + tutorial_progress inserted
  - GIVEN second milking THEN no popup

### F144 — Tick pousse herbe au pré
- **Type :** worker_tick (étape 4bis, après updateCropGrowth)
- **Trigger :** tick journalier
- **Requires :** aucun (automatique)
- **SQL chain :**
  - `SELECT id, grass_level, season FROM parcel WHERE type='pre'`
  - `growth_rate = CASE season WHEN 'spring' THEN 4 WHEN 'summer' THEN 3 WHEN 'autumn' THEN 1.5 WHEN 'winter' THEN 0 END`
  - `growth_rate = growth_rate * soil_health_bonus`
  - `SELECT SUM(daily_consumption) FROM animal WHERE parcel_id=p.id`
  - `UPDATE parcel SET grass_level = GREATEST(0, LEAST(100, grass_level + growth_rate - consumption))`
  - Si grass_level = 0 depuis 14j : `UPDATE parcel SET overgrazed=true, grass_regrow_blocked_until=NOW()+'14 days'`
  - Si overgrazed + animaux : `INSERT INTO notification "⚠️ Pré surpâturé, nourrissez manuellement"`
- **Idempotency :** tick_lock
- **Tests :**
  - GIVEN printemps + 0 animaux THEN grass +4/jour
  - GIVEN 10 vaches consomment 5/jour + pousse 3 THEN grass -2/jour
  - GIVEN grass=0 depuis 14j THEN overgrazed=true
  - GIVEN hiver THEN pousse=0

### F145 — Comparateur de races
- **Page :** /market/animals (onglet Comparateur)
- **Trigger :** navigation
- **Condition :** aucune (lecture)
- **Requires :** authenticated
- **SQL chain :**
  - `SELECT * FROM species_breed WHERE species_id=$1 ORDER BY name`
- **Composants :** DataTable comparatif (race, poids adulte, prod lait/œufs/laine, gestation, portée, prix moyen, indice génétique moyen serveur)
- **Tests :**
  - GIVEN espèce bovins THEN affiche Montbéliarde, Holstein, Charolais, Limousine...

### F146 — Graphique historique cours marché
- **Page :** /market/prices
- **Trigger :** navigation
- **Condition :** aucune (lecture)
- **Requires :** authenticated
- **SQL chain :**
  - `SELECT date, product, price FROM market_price_history WHERE date > NOW() - INTERVAL '84 days' ORDER BY date`
- **Composants :** Sparkline 84j par produit + graphique détaillé au clic (Chart.js)
- **Tests :**
  - GIVEN 84j d'historique blé THEN sparkline affichée avec min/max/current

### F147 — Souscrire Licence Pro
- **Page :** /settings/licence
- **Trigger :** button "Souscrire Licence Pro"
- **Condition :** Pas déjà abonné, paiement Stripe valide
- **Disabled+tooltip :** "Déjà abonné (expire le X)"
- **Requires :** authenticated, not already subscribed
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - Stripe checkout session → webhook
  - `UPDATE player SET licence_pro=true, licence_expires_at=NOW()+'30 days'`
  - `INSERT INTO transaction (player_id, amount, category, description) VALUES ($1, -4.99, 'licence', 'Licence Pro')`
- **Idempotency :** Stripe idempotency key
- **Avantages :** +5 HT/jour, dark mode, export CSV, raccourcis clavier, stats avancées, badge "Pro"
- **Pas de pay-to-win :** pas de bonus rendement, pas de prix réduits
- **Toast :** "⭐ Licence Pro activée ! +5 HT/jour"
- **Animate :** ht_max (40→45)
- **Tests :**
  - GIVEN Stripe success THEN licence_pro=true, ht_max=45
  - GIVEN déjà abonné THEN 409 ERR_ALREADY_SUBSCRIBED
  - GIVEN Stripe fail THEN pas de changement

### F148 — Export CSV DataTable
- **Page :** Toutes les DataTables (bouton 📥)
- **Trigger :** button "📥 Exporter CSV"
- **Condition :** Licence Pro active
- **Disabled+tooltip :** "Réservé aux abonnés Licence Pro"
- **Requires :** authenticated, licence_pro=true
- **SQL chain :** Même requête que la DataTable courante, sans pagination (LIMIT 10000)
- **Format :** CSV UTF-8 BOM, headers français, séparateur ;
- **Idempotency :** Non nécessaire (lecture)
- **Toast :** "📥 Export terminé (X lignes)"
- **Tests :**
  - GIVEN licence pro + 50 animaux THEN CSV 50 lignes
  - GIVEN pas de licence THEN 403 ERR_LICENCE_REQUIRED

### F199 — Souscrire assurance récolte
- **Page :** /parcels/:id
- **Trigger :** button "Souscrire assurance récolte"
- **Condition :** Parcelle avec culture active, balance >= prime, pas déjà assurée
- **Disabled+tooltip :** "Pas de culture active" / "Solde insuffisant (15€/ha)" / "Déjà assurée"
- **Requires :** parcel owned, crop_status IN ('growing','mature'), not insured
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND owner_id=$2`
  - `CHECK crop_status IN ('growing','mature')`
  - `premium = parcel.size_ha * 15`
  - `UPDATE player SET balance = balance - premium WHERE id=$1 AND balance >= premium`
  - `UPDATE parcel SET is_insured=true, insurance_expires_at=crop_harvest_date`
  - `INSERT INTO transaction (player_id, amount, category, description)`
- **Idempotency :** Oui. Déjà assurée → 409
- **Indemnisation (dans F141) :** Si grêle/gel + is_insured → `UPDATE player SET balance = balance + (estimated_loss * 0.70)`
- **Toast :** "🛡️ Assurance souscrite pour {size}ha ({premium}€). Couvert jusqu'à la récolte."
- **Animate :** balance
- **Tests :**
  - GIVEN 10ha blé growing + 500€ WHEN subscribe THEN balance -150€, is_insured=true
  - GIVEN insured + grêle -50% THEN indemnisation 70% de la perte
  - GIVEN déjà assurée THEN 409 ERR_ALREADY_INSURED
  - GIVEN pas de culture THEN 400 ERR_NO_ACTIVE_CROP
  - GIVEN balance 50€ + 10ha (150€ prime) THEN 400 ERR_INSUFFICIENT_BALANCE

---

## Sprint 15 — Transport, Commerce avancé (8 flows)

### F149 — Acheter licence transport
- **Page :** /transport/licence
- **Trigger :** button "Acheter licence transport"
- **Condition :** balance >= 10 000€, ht >= 2.0, pas déjà licencié
- **Disabled+tooltip :** "Solde insuffisant (10 000€)" / "HT insuffisants (2.0)" / "Déjà licencié"
- **Requires :** authenticated, not licensed
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `CHECK balance >= 10000 AND ht >= 2.0 AND has_transport_licence=false`
  - `UPDATE player SET balance = balance - 10000, ht = ht - 2.0, has_transport_licence=true`
  - `INSERT INTO transaction (player_id, amount, category, description)`
- **Idempotency :** Oui. Déjà licencié → 409
- **Toast :** "🚛 Licence transport obtenue ! Achetez un camion."
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 15000€ + 5HT WHEN buy THEN licence=true, balance -10000, ht -2
  - GIVEN déjà licencié THEN 409 ERR_ALREADY_LICENSED
  - GIVEN 5000€ THEN 400 ERR_INSUFFICIENT_BALANCE

### F150 — Acheter un camion
- **Page :** /transport/shop
- **Trigger :** button "Acheter"
- **Condition :** licence transport, balance >= prix camion
- **Disabled+tooltip :** "Licence transport requise" / "Solde insuffisant"
- **Requires :** has_transport_licence=true
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `CHECK has_transport_licence=true AND balance >= price`
  - `INSERT INTO vehicle (owner_id, type, brand, model, wear, hours_used) VALUES ($1, $2, $3, $4, 0, 0)`
  - `UPDATE player SET balance = balance - price`
  - `INSERT INTO transaction`
- **Types :** Porteur 12T (45 000€), Semi-remorque 25T (85 000€)
- **Idempotency :** Oui (idempotency key)
- **Toast :** "🚛 {brand} {model} acheté ! Capacité {capacity}T"
- **Animate :** balance
- **Tests :**
  - GIVEN licence + 50000€ WHEN buy porteur THEN vehicle created, balance -45000
  - GIVEN no licence THEN 403 ERR_NO_TRANSPORT_LICENCE

### F151 — Embaucher un chauffeur
- **Page :** /transport/drivers
- **Trigger :** button "Embaucher"
- **Condition :** licence transport, balance >= 2000€ (1er mois), max 5 chauffeurs
- **Disabled+tooltip :** "Max 5 chauffeurs atteint" / "Solde insuffisant (2 000€)"
- **Requires :** has_transport_licence=true, nb_drivers < 5
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT COUNT(*) FROM driver WHERE owner_id=$1` → check < 5
  - `INSERT INTO driver (owner_id, name, speed, reliability, salary) VALUES ($1, generated_name, random(3,8), random(3,8), 2000)`
  - `UPDATE player SET balance = balance - 2000`
  - `INSERT INTO transaction`
- **Idempotency :** Oui
- **Toast :** "👷 {name} embauché ! Vitesse {speed}/10, Fiabilité {reliability}/10"
- **Animate :** balance
- **Tests :**
  - GIVEN licence + 5000€ + 2 chauffeurs WHEN hire THEN driver created
  - GIVEN 5 chauffeurs THEN 400 ERR_MAX_DRIVERS

### F152 — Proposer un transport
- **Page :** /transport/offers
- **Trigger :** button "Créer offre"
- **Condition :** licence transport, ≥1 camion, ≥1 chauffeur
- **Disabled+tooltip :** "Aucun camion disponible" / "Aucun chauffeur disponible"
- **Requires :** has_transport_licence, vehicle available, driver available
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `INSERT INTO transport_offer (owner_id, vehicle_id, driver_id, price_per_km, available_from, available_to, capacity_tons)`
- **Idempotency :** Oui
- **Toast :** "📋 Offre de transport publiée ({capacity}T, {price}€/km)"
- **Tests :**
  - GIVEN camion + chauffeur WHEN create THEN offer published
  - GIVEN no camion THEN 400 ERR_NO_VEHICLE

### F153 — Visiter ferme d'un joueur
- **Page :** /players/:id/farm
- **Trigger :** navigation (lien depuis classement/annuaire)
- **Condition :** joueur existe, profil non privé
- **Requires :** authenticated, target player exists
- **SQL chain :**
  - `SELECT p.username, p.prefecture, p.created_at FROM player p WHERE id=$1 AND is_private=false`
  - `SELECT type, COUNT(*) FROM building WHERE owner_id=$1 GROUP BY type`
  - `SELECT species, COUNT(*) FROM animal WHERE owner_id=$1 GROUP BY species`
  - `SELECT type, SUM(size_ha) FROM parcel WHERE owner_id=$1 GROUP BY type`
- **Composants :** Vue lecture seule (compteurs, pas de détail individuel)
- **Tests :**
  - GIVEN joueur public THEN affiche stats
  - GIVEN joueur privé THEN 403 ERR_PROFILE_PRIVATE

### F154 — Créer enchère animal
- **Page :** /market/auctions
- **Trigger :** button "Mettre aux enchères"
- **Condition :** animal owned, not pregnant, not sick, not in_transit
- **Disabled+tooltip :** "Animal en gestation" / "Animal malade" / "Animal en transit"
- **Requires :** animal owned, healthy, not pregnant
- **SQL chain :**
  - `SELECT FOR UPDATE animal WHERE id=$1 AND owner_id=$2`
  - `CHECK is_pregnant=false AND is_sick=false AND status='stable'`
  - `INSERT INTO auction (seller_id, animal_id, start_price, end_at) VALUES ($1, $2, $3, NOW() + $4)`
  - `UPDATE animal SET status='auction'`
- **Idempotency :** Oui. Animal déjà en enchère → 409
- **Toast :** "🔨 {name} mis aux enchères ! Prix départ {price}€, fin dans {days}j"
- **Tests :**
  - GIVEN animal sain WHEN create auction 500€ 3j THEN auction created
  - GIVEN animal malade THEN 400 ERR_ANIMAL_SICK
  - GIVEN animal déjà en enchère THEN 409 ERR_ALREADY_AUCTIONED

### F155 — Enchérir sur un animal
- **Page :** /market/auctions/:id
- **Trigger :** button "Enchérir"
- **Condition :** enchère active, bid > current_price × 1.05, balance >= bid, not own auction
- **Disabled+tooltip :** "Enchère terminée" / "Offre trop basse (min +5%)" / "Solde insuffisant"
- **Requires :** authenticated, not seller, auction active
- **SQL chain :**
  - `SELECT FOR UPDATE auction WHERE id=$1 AND end_at > NOW()`
  - `CHECK $bid > current_price * 1.05`
  - `SELECT FOR UPDATE player WHERE id=$2 AND balance >= $bid`
  - `UPDATE auction SET current_price=$bid, current_bidder_id=$2`
  - WS notify seller + previous bidder
- **Idempotency :** Oui (idempotency key)
- **Toast :** "🔨 Enchère placée : {bid}€ sur {animal_name}"
- **Animate :** (pas de débit immédiat, débit à la clôture)
- **Tests :**
  - GIVEN enchère 500€ WHEN bid 530€ THEN current_price=530
  - GIVEN bid 510€ (< 525 = 500×1.05) THEN 400 ERR_BID_TOO_LOW
  - GIVEN own auction THEN 400 ERR_CANNOT_BID_OWN

### F156 — Contrat vente à terme
- **Page :** /market/futures
- **Trigger :** button "Créer contrat"
- **Condition :** balance >= garantie (10% du montant), produit en stock ou production prévue
- **Disabled+tooltip :** "Garantie insuffisante (10% = X€)"
- **Requires :** authenticated, balance >= guarantee
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `guarantee = quantity * price * 0.10`
  - `UPDATE player SET balance = balance - guarantee`
  - `INSERT INTO futures_contract (seller_id, product, quantity, price_per_unit, delivery_date, guarantee)`
  - `INSERT INTO transaction (category='futures_guarantee')`
- **À la livraison (tick) :**
  - Si stock suffisant : livraison + paiement + restitution garantie
  - Si stock insuffisant : pénalité (garantie perdue) + achat au marché pour compléter
- **Idempotency :** Oui
- **Toast :** "📜 Contrat créé : {qty}T {product} à {price}€/T, livraison {date}"
- **Animate :** balance (garantie déduite)
- **Tests :**
  - GIVEN 1000€ + contrat 500T×200€ (garantie 10000€) THEN 400 ERR_INSUFFICIENT_BALANCE
  - GIVEN 15000€ WHEN create 500T×200€ THEN guarantee=10000, balance -10000
  - GIVEN delivery date + stock OK THEN livraison + paiement + garantie restituée
  - GIVEN delivery date + stock insuffisant THEN garantie perdue

---

## Sprint 16 — Activités secondaires (8 flows)

### F157 — Construire fromagerie
- **Page :** /buildings/buy (type fromagerie)
- **Trigger :** button "Construire"
- **Condition :** balance >= 50 000€, ht >= 3.0, pas déjà une fromagerie
- **Disabled+tooltip :** "Solde insuffisant (50 000€)" / "HT insuffisants (3.0)"
- **Requires :** authenticated, balance, ht
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `CHECK balance >= 50000 AND ht >= 3.0`
  - `INSERT INTO building (owner_id, type, wear, capacity) VALUES ($1, 'fromagerie', 0, 500)`
  - `UPDATE player SET balance = balance - 50000, ht = ht - 3.0`
  - `INSERT INTO transaction`
- **Idempotency :** Oui
- **Toast :** "🧀 Fromagerie construite ! Transformez votre lait."
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 60000€ + 5HT WHEN build THEN fromagerie created, balance -50000
  - GIVEN 30000€ THEN 400 ERR_INSUFFICIENT_BALANCE

### F158 — Transformer lait en fromage
- **Page :** /buildings/:id (fromagerie)
- **Trigger :** button "Lancer transformation"
- **Condition :** fromagerie owned, stock lait >= quantité, ht >= 1.0
- **Disabled+tooltip :** "Stock lait insuffisant (min X L)" / "HT insuffisants"
- **Requires :** fromagerie owned, milk stock, ht
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT FOR UPDATE inventory WHERE player_id=$1 AND product='milk'`
  - `CHECK milk.quantity >= required_liters`
  - `UPDATE inventory SET quantity = quantity - liters WHERE product='milk'`
  - `INSERT INTO cheese_batch (building_id, type, quantity_kg, started_at, ready_at)`
  - Affinage : frais 14j (10L→1kg, 3.50€/kg), affiné 42j (12L→1kg, 8€/kg), vieux 84j (15L→1kg, 15€/kg)
  - `cost = liters * 0.09` (main d'œuvre + ingrédients)
  - `UPDATE player SET balance = balance - cost, ht = ht - 1.0`
  - `INSERT INTO transaction`
- **Idempotency :** Oui
- **Toast :** "🧀 Transformation lancée : {kg}kg {type}, prêt le {date}"
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 100L lait WHEN transform frais THEN 10kg cheese, milk -100, ready in 14j
  - GIVEN 50L lait + need 100L THEN 400 ERR_INSUFFICIENT_MILK
  - GIVEN batch ready WHEN collect THEN inventory +10kg fromage

### F159 — Inscrire animal à un concours
- **Page :** /events/contests
- **Trigger :** button "Inscrire"
- **Condition :** animal owned, healthy, not pregnant, concours ouvert pour l'espèce, balance >= 100€ (frais inscription)
- **Disabled+tooltip :** "Animal malade" / "Pas de concours ouvert pour cette espèce" / "Frais 100€"
- **Requires :** animal owned, healthy, contest open
- **SQL chain :**
  - `SELECT FOR UPDATE animal WHERE id=$1 AND owner_id=$2`
  - `SELECT * FROM contest WHERE species=$3 AND status='open'`
  - `CHECK animal.is_sick=false AND animal.is_pregnant=false`
  - `INSERT INTO contest_entry (contest_id, animal_id, player_id)`
  - `UPDATE player SET balance = balance - 100`
  - `INSERT INTO transaction`
- **Jury (tick clôture concours) :** score = genetics_avg × 0.4 + welfare_index × 0.3 + age_factor × 0.3
- **Prix :** 1er = 5 000€ + badge or, 2ème = 2 000€ + badge argent, 3ème = 1 000€ + badge bronze
- **Idempotency :** Oui. Animal déjà inscrit → 409
- **Toast :** "🏆 {name} inscrit au concours {espèce} !"
- **Animate :** balance
- **Tests :**
  - GIVEN animal sain + concours ouvert WHEN inscribe THEN entry created
  - GIVEN animal malade THEN 400 ERR_ANIMAL_SICK
  - GIVEN déjà inscrit THEN 409 ERR_ALREADY_ENTERED

### F160 — Gavage oie/canard (foie gras)
- **Page :** /buildings/:id (salle gavage)
- **Trigger :** button "Démarrer gavage"
- **Condition :** oie/canard adulte, salle gavage construite, stock maïs >= 50kg, ht >= 0.5
- **Disabled+tooltip :** "Pas d'oie/canard adulte" / "Stock maïs insuffisant" / "Salle gavage requise"
- **Requires :** salle_gavage owned, oie/canard adult, corn stock
- **SQL chain :**
  - `SELECT FOR UPDATE animal WHERE id=$1 AND species IN ('oie','canard') AND age >= adult_age`
  - `SELECT FOR UPDATE inventory WHERE product='mais' AND quantity >= 50`
  - `UPDATE animal SET gavage_started_at=NOW(), gavage_end_at=NOW()+'14 days'`
  - `UPDATE inventory SET quantity = quantity - 50 WHERE product='mais'`
  - `UPDATE player SET ht = ht - 0.5`
- **Tick gavage (2×/jour pendant 14j) :** consomme 3.5kg maïs/jour, poids foie augmente
- **Fin gavage :** animal abattable → foie gras 22.50€/kg
- **Idempotency :** Oui. Animal déjà en gavage → 409
- **Toast :** "🦆 Gavage démarré pour {name}. Fin dans 14j."
- **Tests :**
  - GIVEN canard adulte + 60kg maïs WHEN start THEN gavage_started, mais -50
  - GIVEN oie juvénile THEN 400 ERR_NOT_ADULT
  - GIVEN déjà en gavage THEN 409 ERR_ALREADY_GAVAGE

### F161 — Débloquer savoir-faire
- **Page :** /profile/skills
- **Trigger :** automatique (chaque action donne XP)
- **Requires :** authenticated
- **Branches :** Élevage (traite, nourrir, soigner), Cultures (semer, récolter, épandre), Commerce (vendre, acheter, transporter)
- **SQL chain :**
  - Après chaque action : `UPDATE player_skill SET xp = xp + $xp_gain WHERE player_id=$1 AND branch=$2`
  - `SELECT level FROM skill_level WHERE xp_required <= $current_xp ORDER BY level DESC LIMIT 1`
  - Si level up : `INSERT INTO notification`
- **Niveaux 1-10 :** Bonus par niveau : +1% rendement (cultures), +1% production (élevage), -1% commission (commerce)
- **Idempotency :** XP additionné (pas de double via idempotency de l'action parente)
- **Toast :** "⬆️ Savoir-faire Élevage niveau 5 ! +5% production"
- **Tests :**
  - GIVEN 0 XP élevage WHEN milk 10 times THEN XP += 10, level check
  - GIVEN level 4 + 1 XP to level 5 THEN notification level up

### F162 — Voir classement savoir-faire
- **Page :** /rankings (onglet Savoir-faire)
- **Trigger :** navigation
- **Requires :** authenticated
- **SQL chain :**
  - `SELECT p.username, ps.branch, ps.level, ps.xp FROM player_skill ps JOIN player p ON p.id=ps.player_id ORDER BY ps.xp DESC LIMIT 100`
- **Composants :** DataTable (rang, joueur, branche, niveau, XP)
- **Tests :**
  - GIVEN 50 joueurs avec XP THEN classement trié par XP desc

### F163 — Événement saisonnier (foire)
- **Type :** worker_tick, 1×/saison (jour 1 de chaque saison)
- **Trigger :** tick conditionnel
- **Requires :** aucun (automatique)
- **SQL chain :**
  - `IF day_of_season = 1 THEN`
  - `INSERT INTO event (type='foire', season, start_at=NOW(), end_at=NOW()+'7 days')`
  - `UPDATE market_modifier SET sell_bonus=1.10 WHERE event_id=$1` (prix +10%)
  - `INSERT INTO contest (species, event_id, status='open')` pour chaque espèce
  - `INSERT INTO notification FOR ALL players "🎪 Foire de {saison} ! Prix +10%, concours ouverts pendant 7j"`
- **Fin foire (tick) :** clôture concours (jury), reset market_modifier
- **Idempotency :** 1 foire par saison max
- **Tests :**
  - GIVEN jour 1 printemps THEN foire created, prix +10%
  - GIVEN jour 8 THEN foire closed, prix normaux
  - GIVEN déjà 1 foire ce printemps THEN pas de 2ème

### F164 — Quête temporaire (événement)
- **Page :** /events/quests
- **Trigger :** navigation + tick hebdomadaire (génération)
- **Requires :** authenticated
- **SQL chain :**
  - Génération (tick lundi) : `INSERT INTO quest (type, target_product, target_quantity, reward, expires_at=NOW()+'7 days')`
  - Exemples : "Vendez 50T blé" (5 000€), "Trayez 500L" (2 000€), "Achetez 5 animaux" (3 000€)
  - Progression : `UPDATE player_quest SET progress = progress + $qty WHERE quest_id=$1 AND player_id=$2`
  - Complétion : `IF progress >= target THEN UPDATE player SET balance += reward, INSERT notification`
- **Idempotency :** progression additive (pas de double via action parente)
- **Toast :** "🎯 Quête complétée ! +{reward}€"
- **Animate :** balance
- **Tests :**
  - GIVEN quête "50T blé" + vend 30T THEN progress=30
  - GIVEN progress 45 + vend 10T THEN progress=50, reward 5000€
  - GIVEN quête expirée THEN pas de progression

---

## Sprint 17 — Extensions futures + Social avancé + Élevage niche (12 flows)

### F165 — Planter vigne (viticulture)
- **Page :** /parcels/:id (type vigne)
- **Trigger :** button "Planter vigne"
- **Condition :** parcelle type vigne, balance >= 8 000€/ha (plants), ht >= 3.0
- **Disabled+tooltip :** "Type parcelle incompatible" / "Solde insuffisant"
- **Requires :** parcel type=vigne, balance, ht
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND owner_id=$2 AND type='vigne'`
  - `UPDATE parcel SET crop='vigne', crop_status='planted', crop_planted_at=NOW(), first_harvest_year=3`
  - `UPDATE player SET balance = balance - (size_ha * 8000), ht = ht - 3.0`
  - `INSERT INTO transaction`
- **Cycle :** Plantation → 3 ans (252j) avant 1ère vendange. Taille annuelle obligatoire. Vendange automne.
- **Idempotency :** Oui. Déjà plantée → 409
- **Toast :** "🍇 Vigne plantée ! Première vendange dans 3 ans."
- **Tests :**
  - GIVEN vigne 2ha + 20000€ WHEN plant THEN crop=vigne, balance -16000
  - GIVEN parcelle culture THEN 400 ERR_WRONG_PARCEL_TYPE

### F166 — Cultiver légumes (maraîchage)
- **Page :** /parcels/:id (serre ou plein champ)
- **Trigger :** button "Semer légumes"
- **Condition :** parcelle culture ou serre, semences légumes en stock, ht >= 1.5
- **Requires :** parcel owned, seeds, ht
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND owner_id=$2`
  - `SELECT FOR UPDATE inventory WHERE product=$seed AND quantity >= required`
  - `UPDATE parcel SET crop=$legume, crop_status='growing'`
  - `UPDATE inventory SET quantity = quantity - required`
  - `UPDATE player SET ht = ht - 1.5`
- **Types :** Tomates (serre, 28j), carottes (42j), pommes de terre (56j), salades (21j)
- **Vente :** marchés locaux (F186) prix ×2 vs Marché Central
- **Idempotency :** Oui
- **Toast :** "🥕 {légume} semé ! Récolte dans {days}j"
- **Tests :**
  - GIVEN serre + semences tomates WHEN sow THEN crop=tomates
  - GIVEN pas de semences THEN 400 ERR_NO_SEEDS

### F167 — Exploiter une forêt (ETF)
- **Page :** /parcels/:id (type forêt)
- **Trigger :** button "Abattre"
- **Condition :** parcelle forêt, arbres matures (>5 ans = 420j), tronçonneuse, ht >= 4.0
- **Requires :** parcel type=foret, trees mature, chainsaw, ht
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND type='foret' AND tree_age >= 420`
  - `volume_m3 = size_ha * density * tree_volume`
  - `INSERT INTO inventory (product='bois', quantity=volume_m3)`
  - `UPDATE parcel SET tree_age=0, tree_density=0`
  - `UPDATE player SET ht = ht - 4.0`
  - `UPDATE vehicle SET wear += usage WHERE type='tronconneuse'`
- **Replantation :** automatique ou manuelle (choix essence)
- **Idempotency :** Oui
- **Toast :** "🪵 {volume}m³ de bois abattus ! Replantation en cours."
- **Tests :**
  - GIVEN forêt 10ha + arbres 500j WHEN abattre THEN bois en stock
  - GIVEN arbres 200j THEN 400 ERR_TREES_NOT_MATURE

### F168 — Mode classe (professeur)
- **Page :** /classroom
- **Trigger :** button "Créer classe"
- **Condition :** compte vérifié, email .edu ou validation manuelle
- **Requires :** verified teacher account
- **SQL chain :**
  - `INSERT INTO classroom (teacher_id, name, max_students, scenario)`
  - `INSERT INTO classroom_student (classroom_id, player_id)` pour chaque élève invité
- **Fonctionnalités :** Tableau de bord prof (P&L par élève, classement, export notes), scénarios pédagogiques (budget limité, objectif rendement), reset possible
- **Idempotency :** Oui
- **Toast :** "🎓 Classe {name} créée ! Invitez vos élèves."
- **Tests :**
  - GIVEN teacher account WHEN create class THEN classroom created
  - GIVEN 30 élèves invités THEN all linked

### F169 — Forum in-game
- **Page :** /forums
- **Trigger :** button "Nouveau sujet" / "Répondre"
- **Condition :** authenticated, not banned, rate limit 5 posts/heure
- **Requires :** authenticated, not banned
- **SQL chain :**
  - Nouveau sujet : `INSERT INTO forum_topic (author_id, category, title, body)`
  - Réponse : `INSERT INTO forum_reply (topic_id, author_id, body)`
  - `UPDATE forum_topic SET reply_count = reply_count + 1, last_reply_at = NOW()`
- **Modération :** Signalement → `INSERT INTO report (reporter_id, target_type, target_id, reason)`. Mots interdits filtrés côté serveur.
- **Idempotency :** Oui (idempotency key sur POST)
- **Toast :** "💬 Sujet publié !" / "💬 Réponse publiée !"
- **Tests :**
  - GIVEN authenticated WHEN post topic THEN topic created
  - GIVEN banned THEN 403 ERR_BANNED
  - GIVEN 6ème post en 1h THEN 429 ERR_RATE_LIMIT

### F170 — Chat live entre amis
- **Page :** Widget chat (bas de page)
- **Trigger :** clic sur ami dans la liste
- **Condition :** amis mutuels (F094 accepté)
- **Requires :** friendship confirmed
- **SQL chain :**
  - `SELECT * FROM friendship WHERE (player_a=$1 AND player_b=$2) AND status='accepted'`
  - `INSERT INTO chat_message (sender_id, receiver_id, body, sent_at)`
  - Socket.io room : `room_${min(a,b)}_${max(a,b)}`
  - Historique : `SELECT * FROM chat_message WHERE (sender=$1 AND receiver=$2) OR (sender=$2 AND receiver=$1) ORDER BY sent_at DESC LIMIT 50`
  - Purge : messages > 7j supprimés par job hebdomadaire
- **Idempotency :** Non nécessaire (messages)
- **Tests :**
  - GIVEN amis WHEN send message THEN delivered via WS
  - GIVEN pas amis THEN 403 ERR_NOT_FRIENDS

### F171 — Parrainer un joueur
- **Page :** /settings/referral
- **Trigger :** button "Copier mon code"
- **Requires :** authenticated
- **SQL chain :**
  - `SELECT referral_code FROM player WHERE id=$1` (généré à l'inscription)
  - Filleul s'inscrit avec code : `UPDATE player SET referred_by=$parrain_id WHERE id=$filleul`
  - Après 7j de jeu actif du filleul (tick) :
    - `UPDATE player SET balance = balance + 5000 WHERE id=$parrain_id`
    - `UPDATE player SET balance = balance + 2000 WHERE id=$filleul_id`
    - `INSERT INTO transaction` ×2
- **Idempotency :** 1 parrain par filleul
- **Toast (parrain) :** "🎁 Votre filleul {name} est actif ! +5 000€"
- **Tests :**
  - GIVEN filleul actif 7j THEN parrain +5000, filleul +2000
  - GIVEN filleul inactif 7j THEN pas de bonus

### F172 — Ajouter en favoris
- **Page :** Toutes les pages (bouton ⭐)
- **Trigger :** button ⭐
- **Requires :** authenticated
- **SQL chain :**
  - `INSERT INTO favorite (player_id, target_type, target_id) ON CONFLICT DO NOTHING`
  - Retirer : `DELETE FROM favorite WHERE player_id=$1 AND target_type=$2 AND target_id=$3`
- **Types :** animal, player, listing, auction
- **Idempotency :** ON CONFLICT DO NOTHING
- **Toast :** "⭐ Ajouté aux favoris" / "Retiré des favoris"
- **Tests :**
  - GIVEN animal WHEN fav THEN favorite created
  - GIVEN déjà fav WHEN fav THEN no duplicate
  - GIVEN fav WHEN unfav THEN deleted

### F173 — Acheter chien de troupeau
- **Page :** /market/animals (espèce chien)
- **Trigger :** button "Acheter"
- **Condition :** balance >= 500€, ≥1 troupeau au pré
- **Disabled+tooltip :** "Aucun troupeau au pré" / "Solde insuffisant (500€)"
- **Requires :** animals at pasture, balance
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT COUNT(*) FROM animal WHERE owner_id=$1 AND location='pasture'` → check > 0
  - `INSERT INTO animal (owner_id, species='chien', breed=$2, role='troupeau')`
  - `UPDATE player SET balance = balance - 500`
  - `INSERT INTO transaction`
- **Effets :** Risque fuite au pré -100%, welfare_index animaux au pré +5/mois. Nourrir 1×/jour (croquettes 0.50€/jour).
- **Idempotency :** Oui
- **Toast :** "🐕 {name} rejoint votre troupeau !"
- **Animate :** balance
- **Tests :**
  - GIVEN troupeau au pré + 600€ WHEN buy THEN chien created
  - GIVEN 0 animaux au pré THEN 400 ERR_NO_PASTURE_ANIMALS

### F174 — Élevage industriel (fusion lots)
- **Page :** /animals (sélection lot >50)
- **Trigger :** button "Passer en industriel"
- **Condition :** lot >= 50 animaux, même espèce, bâtiment adapté
- **Disabled+tooltip :** "Lot trop petit (min 50)" / "Bâtiment non adapté"
- **Requires :** lot owned, size >= 50
- **SQL chain :**
  - `SELECT FOR UPDATE animal_lot WHERE id=$1 AND owner_id=$2`
  - `SELECT COUNT(*) FROM animal WHERE lot_id=$1` → check >= 50
  - `UPDATE animal_lot SET mode='industrial'`
  - Effets : production ×1.10, welfare_index -20 (permanent), label plein-air/bio impossible
- **Idempotency :** Oui. Déjà industriel → 409
- **Toast :** "🏭 Lot passé en mode industriel. Production +10%, bien-être -20."
- **Tests :**
  - GIVEN lot 60 poules WHEN industrialize THEN mode=industrial
  - GIVEN lot 30 THEN 400 ERR_LOT_TOO_SMALL
  - GIVEN lot industriel + demande label bio THEN 400 ERR_INCOMPATIBLE

### F175 — Inscrire animal IVRAD
- **Page :** /animals/:id
- **Trigger :** button "Confier à l'IVRAD"
- **Condition :** animal owned, génétique basse (<30), pas en gestation
- **Disabled+tooltip :** "Génétique trop haute (max 30)" / "Animal en gestation"
- **Requires :** animal owned, genetics < 30
- **SQL chain :**
  - `SELECT FOR UPDATE animal WHERE id=$1 AND owner_id=$2`
  - `CHECK genetics_avg < 30 AND is_pregnant=false`
  - `UPDATE animal SET status='ivrad', ivrad_until=NOW()+'84 days'`
  - L'IVRAD verse 50€/mois au joueur pour l'entretien
  - Si animal meurt : `UPDATE player SET ivrad_reputation = ivrad_reputation - 1`
- **Idempotency :** Oui
- **Toast :** "🏥 {name} confié à l'IVRAD pour 84j. Indemnité 50€/mois."
- **Tests :**
  - GIVEN genetics 25 WHEN confier THEN status=ivrad
  - GIVEN genetics 50 THEN 400 ERR_GENETICS_TOO_HIGH

### F176 — Définir objectif génétique (OG)
- **Page :** /animals/genetics
- **Trigger :** button "Définir OG"
- **Condition :** ≥5 animaux de l'espèce
- **Disabled+tooltip :** "Min 5 animaux de cette espèce"
- **Requires :** ≥5 animals of species
- **SQL chain :**
  - `INSERT INTO genetic_objective (player_id, species, target_trait, priority) ON CONFLICT UPDATE`
  - Traits : lait, viande, fertilité, longévité, docilité
  - L'IA suggère : `SELECT a1.id, a2.id, predicted_score FROM animal a1 CROSS JOIN animal a2 WHERE a1.sex='F' AND a2.sex='M' ORDER BY predicted_score DESC LIMIT 5`
- **Idempotency :** ON CONFLICT UPDATE
- **Toast :** "🧬 Objectif génétique défini : maximiser {trait}"
- **Tests :**
  - GIVEN 10 bovins WHEN set OG=lait THEN objective saved + suggestions affichées
  - GIVEN 3 bovins THEN 400 ERR_NOT_ENOUGH_ANIMALS

---

## Sprint 18 — Cultures avancées + Environnement (8 flows)

### F177 — Récolter céréale immature (ensilage)
- **Page :** /parcels/:id
- **Trigger :** button "Récolter en ensilage"
- **Condition :** culture céréale à 60-80% croissance, ensileuse disponible, ht >= 2.0
- **Disabled+tooltip :** "Croissance insuffisante (min 60%)" / "Ensileuse requise" / "HT insuffisants"
- **Requires :** parcel owned, crop 60-80%, ensileuse, ht
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND owner_id=$2`
  - `CHECK crop_growth BETWEEN 60 AND 80`
  - `yield = base_yield * (crop_growth/100) * 0.8 * soil_health_bonus`
  - `INSERT INTO inventory (product='ensilage', quantity=yield)`
  - `UPDATE parcel SET crop_status='harvested', crop=NULL`
  - `UPDATE player SET ht = ht - 2.0`
  - `UPDATE vehicle SET wear += usage WHERE type='ensileuse'`
  - `INSERT INTO transaction`
- **Idempotency :** Oui
- **Toast :** "🌽 {yield}T d'ensilage récoltés !"
- **Animate :** ht
- **Tests :**
  - GIVEN maïs 70% + ensileuse WHEN harvest THEN ensilage in stock
  - GIVEN maïs 50% THEN 400 ERR_CROP_TOO_YOUNG
  - GIVEN maïs 90% THEN 400 ERR_CROP_TOO_MATURE_FOR_ENSILAGE

### F178 — Épierrer une parcelle
- **Page :** /parcels/:id
- **Trigger :** button "Épierrer"
- **Condition :** parcelle avec pierres (has_stones=true), tracteur + épierreuse, balance >= 500€, ht >= 2.0
- **Disabled+tooltip :** "Pas de pierres" / "Épierreuse requise" / "Solde insuffisant"
- **Requires :** parcel owned, has_stones, épierreuse, balance, ht
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND has_stones=true`
  - `UPDATE parcel SET has_stones=false, yield_bonus = yield_bonus + 0.03`
  - `UPDATE player SET balance = balance - 500, ht = ht - 2.0`
  - `UPDATE vehicle SET wear += usage WHERE type IN ('tracteur','epierreuse')`
  - `INSERT INTO transaction`
- **Idempotency :** Oui. Déjà épierrée → 409
- **Toast :** "🪨 Parcelle épierrée ! Rendement +3%"
- **Animate :** balance, ht
- **Tests :**
  - GIVEN parcelle avec pierres WHEN épierrer THEN has_stones=false, +3%
  - GIVEN pas de pierres THEN 409 ERR_NO_STONES

### F179 — Acheter écume de sucrerie
- **Page :** /market/products
- **Trigger :** button "Acheter"
- **Condition :** balance >= prix, stock disponible au marché
- **Requires :** authenticated, balance
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `UPDATE player SET balance = balance - (quantity * 12)` (12€/T)
  - `INSERT INTO inventory (product='ecume_sucrerie', quantity=$qty)`
  - `INSERT INTO transaction`
- **Usage :** Épandage avec épandeur fumier (F129 alt). Apporte Ca + améliore pH sol.
- **Idempotency :** Oui
- **Toast :** "🏭 {qty}T d'écume achetées ({total}€)"
- **Animate :** balance
- **Tests :**
  - GIVEN 5000€ WHEN buy 100T THEN inventory +100T, balance -1200

### F180 — Gérer quotas de production
- **Page :** /finances/quotas
- **Trigger :** navigation (lecture) + tick mensuel (vérification)
- **Requires :** authenticated
- **SQL chain :**
  - `SELECT * FROM production_quota WHERE player_id=$1`
  - Quotas : lait (base 50 000L/an), betterave (base 200T/an)
  - `quota_increase = ancienneté_years * 10%`
  - Tick mensuel : `SELECT SUM(quantity) FROM transaction WHERE product=$1 AND category='sell' AND date > year_start`
  - Si dépassement : prix vente ×0.70 sur l'excédent
- **Tests :**
  - GIVEN quota lait 50000L + vendu 45000L WHEN sell 10000L THEN 5000L à prix normal + 5000L à ×0.70
  - GIVEN ancienneté 3 ans THEN quota = 50000 × 1.30 = 65000L

### F181 — Construire retenue collinaire
- **Page :** /buildings/buy
- **Trigger :** button "Construire"
- **Condition :** balance >= 20 000€, ht >= 3.0, parcelle disponible
- **Disabled+tooltip :** "Solde insuffisant" / "HT insuffisants"
- **Requires :** balance, ht
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `INSERT INTO building (owner_id, type='retenue_collinaire', capacity=5000, water_level=0)`
  - `UPDATE player SET balance = balance - 20000, ht = ht - 3.0`
  - `INSERT INTO transaction`
- **Tick pluie :** `UPDATE building SET water_level = LEAST(capacity, water_level + rainfall * 100) WHERE type='retenue_collinaire'`
- **Usage :** Alternative irrigation. Gratuit (pas de forage). Dépend de la pluie.
- **Idempotency :** Oui
- **Toast :** "💧 Retenue collinaire construite ! Capacité 5 000m³"
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 25000€ WHEN build THEN retenue created, balance -20000
  - GIVEN pluie 10mm THEN water_level +1000m³

### F182 — Installer GPS sur tracteur
- **Page :** /equipment/:id
- **Trigger :** button "Installer GPS"
- **Condition :** tracteur owned, balance >= 5 000€, pas déjà équipé GPS
- **Disabled+tooltip :** "Déjà équipé GPS" / "Solde insuffisant (5 000€)"
- **Requires :** vehicle owned, type=tracteur, no GPS
- **SQL chain :**
  - `SELECT FOR UPDATE vehicle WHERE id=$1 AND owner_id=$2 AND type='tracteur'`
  - `UPDATE vehicle SET has_gps=true`
  - `UPDATE player SET balance = balance - 5000`
  - `INSERT INTO transaction`
- **Effets :** HVC -10% sur travaux parcelle, usure -5% sur travaux parcelle
- **Abonnement :** 500€/an (tick annuel)
- **Idempotency :** Oui. Déjà GPS → 409
- **Toast :** "📡 GPS installé ! HVC -10%, usure -5%"
- **Animate :** balance
- **Tests :**
  - GIVEN tracteur sans GPS + 6000€ WHEN install THEN has_gps=true, balance -5000
  - GIVEN déjà GPS THEN 409 ERR_ALREADY_GPS

### F183 — Créer dépôt-vente matériel
- **Page :** /equipment/depot
- **Trigger :** button "Déposer en consigne"
- **Condition :** véhicule owned, not broken, not in use
- **Disabled+tooltip :** "Véhicule en panne" / "Véhicule en cours d'utilisation"
- **Requires :** vehicle owned, functional, idle
- **SQL chain :**
  - `SELECT FOR UPDATE vehicle WHERE id=$1 AND owner_id=$2`
  - `CHECK is_broken=false AND status='idle'`
  - `INSERT INTO depot_listing (vehicle_id, seller_id, asking_price, commission_rate=0.10)`
  - `UPDATE vehicle SET status='depot'`
- **Vente (par un autre joueur) :** `UPDATE vehicle SET owner_id=$buyer`, seller reçoit prix × 0.90
- **Idempotency :** Oui
- **Toast :** "🏪 {vehicle} déposé en consigne. Prix demandé {price}€ (commission 10%)"
- **Tests :**
  - GIVEN tracteur idle WHEN deposit THEN listing created
  - GIVEN tracteur broken THEN 400 ERR_VEHICLE_BROKEN

### F184 — Accessoires bâtiments
- **Page :** /buildings/:id
- **Trigger :** button "Installer accessoire"
- **Condition :** bâtiment owned, balance >= prix accessoire
- **Disabled+tooltip :** "Solde insuffisant" / "Déjà installé"
- **Requires :** building owned, balance
- **SQL chain :**
  - `SELECT FOR UPDATE building WHERE id=$1 AND owner_id=$2`
  - `INSERT INTO building_accessory (building_id, type, installed_at)`
  - `UPDATE player SET balance = balance - price`
  - `INSERT INTO transaction`
- **Types :**
  - Abreuvoirs auto (2 000€) : -0.1 HT/jour abreuvement
  - Ventilation (3 000€) : annule malus canicule (F141)
  - Éclairage (1 500€) : production œufs +10% en hiver
  - Racleur lisier (4 000€) : -0.2 HT/jour litière
- **Coût énergie :** 50€/mois par accessoire (tick mensuel)
- **Idempotency :** Oui. Déjà installé → 409
- **Toast :** "⚙️ {accessoire} installé ! {effet}"
- **Animate :** balance
- **Tests :**
  - GIVEN étable + 3000€ WHEN install ventilation THEN accessory created
  - GIVEN déjà ventilation THEN 409 ERR_ALREADY_INSTALLED
  - GIVEN canicule + ventilation THEN pas de malus welfare

---

## Sprint 19 — Économie avancée + Politique (6 flows)

### F185 — Acheter parts sociales CAR
- **Page :** /cooperatives/:id
- **Trigger :** button "Acheter parts"
- **Condition :** membre de la CAR, balance >= montant (1€/part, min 100 parts)
- **Disabled+tooltip :** "Pas membre de cette CAR" / "Min 100 parts (100€)"
- **Requires :** car_member, balance >= 100
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT * FROM car_membership WHERE player_id=$1 AND car_id=$2`
  - `UPDATE player SET balance = balance - (nb_parts * 1)`
  - `INSERT INTO car_shares (car_id, player_id, nb_parts, purchased_at)`
  - `INSERT INTO transaction`
- **Dividendes (tick annuel) :** `profit_per_share = car.annual_profit / total_shares`. `UPDATE player SET balance += shares * profit_per_share`
- **Revente :** après 84j, au prix d'achat (1€/part)
- **Idempotency :** Oui
- **Toast :** "🏦 {nb} parts achetées dans {car_name} ({total}€)"
- **Animate :** balance
- **Tests :**
  - GIVEN membre + 500€ WHEN buy 200 parts THEN shares created, balance -200
  - GIVEN pas membre THEN 403 ERR_NOT_MEMBER
  - GIVEN revente avant 84j THEN 400 ERR_LOCK_PERIOD

### F186 — Vendre sur les marchés locaux
- **Page :** /market/local
- **Trigger :** button "Vendre au marché local"
- **Condition :** produit frais en stock (lait, œufs, fromage, légumes), 1 vente/semaine max, ht >= 1.0
- **Disabled+tooltip :** "Déjà vendu cette semaine" / "Produit non éligible" / "HT insuffisants"
- **Requires :** fresh product in stock, weekly limit not reached
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT COUNT(*) FROM transaction WHERE player_id=$1 AND category='local_market' AND date > NOW() - '7 days'` → check = 0
  - `price = market_price * 1.20` (prix +20%)
  - `UPDATE inventory SET quantity = quantity - $qty`
  - `UPDATE player SET balance = balance + (qty * price), ht = ht - 1.0`
  - `INSERT INTO transaction (category='local_market')`
- **Pas de transport** (marché de la préfecture)
- **Idempotency :** Oui
- **Toast :** "🧺 {qty} {product} vendus au marché local ! {total}€ (+20%)"
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 50 œufs + 0 vente semaine WHEN sell THEN balance += prix×1.20
  - GIVEN déjà vendu cette semaine THEN 400 ERR_WEEKLY_LIMIT
  - GIVEN produit blé (pas frais) THEN 400 ERR_NOT_FRESH_PRODUCT

### F187 — Grossiste / centrale d'achat
- **Page :** /market/wholesale
- **Trigger :** button "Acheter en gros" / "Vendre en gros"
- **Condition :** quantité >= 10T (achat) ou >= 10T (vente), licence transport ou membre CAR
- **Disabled+tooltip :** "Min 10T" / "Licence transport ou CAR requise"
- **Requires :** quantity >= 10T, transport_licence OR car_member
- **SQL chain :**
  - Achat : `price = market_price * 0.85` (remise -15%)
  - Vente : `price = market_price * 0.90` (prix -10%, pas de transport)
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `UPDATE player SET balance = balance ± total`
  - `UPDATE inventory SET quantity = quantity ± qty`
  - `INSERT INTO transaction (category='wholesale')`
- **Idempotency :** Oui
- **Toast :** "📦 {qty}T {product} achetées en gros (-15%) !" / "vendues en gros"
- **Animate :** balance
- **Tests :**
  - GIVEN licence transport + 50T blé WHEN sell wholesale THEN prix ×0.90, no transport
  - GIVEN 5T THEN 400 ERR_MIN_QUANTITY
  - GIVEN no licence + no CAR THEN 403 ERR_NO_ACCESS

### F188 — Créer le CESA (Chambre Agricole)
- **Page :** /politics/chamber
- **Trigger :** automatique (tick, quand serveur atteint 50 joueurs actifs)
- **Requires :** ≥50 joueurs actifs sur le serveur
- **SQL chain :**
  - `INSERT INTO cesa (server_id, created_at, election_at=NOW()+'7 days')`
  - `INSERT INTO notification FOR ALL players "🏛️ La Chambre Agricole est créée ! Élections dans 7j."`
- **7 sièges :** élus pour 84j
- **Idempotency :** 1 CESA par serveur
- **Tests :**
  - GIVEN 50 joueurs actifs THEN CESA created
  - GIVEN 30 joueurs THEN pas de CESA
  - GIVEN CESA existe THEN pas de doublon

### F189 — Voter aux élections CESA
- **Page :** /politics/vote
- **Trigger :** button "Voter"
- **Condition :** élection en cours, pas déjà voté, ancienneté >= 7j
- **Disabled+tooltip :** "Pas d'élection en cours" / "Déjà voté" / "Ancienneté min 7j"
- **Requires :** election active, not voted, ancienneté >= 7j
- **SQL chain :**
  - `SELECT * FROM cesa_election WHERE status='open'`
  - `SELECT * FROM cesa_vote WHERE election_id=$1 AND voter_id=$2` → check absent
  - `INSERT INTO cesa_vote (election_id, voter_id, candidate_id)`
  - Clôture (tick) : `SELECT candidate_id, COUNT(*) FROM cesa_vote GROUP BY candidate_id ORDER BY count DESC LIMIT 7`
  - `INSERT INTO cesa_member (cesa_id, player_id, role, term_end)`
- **Idempotency :** 1 vote par joueur par élection
- **Toast :** "🗳️ Vote enregistré !"
- **Tests :**
  - GIVEN élection ouverte + pas voté WHEN vote THEN vote recorded
  - GIVEN déjà voté THEN 409 ERR_ALREADY_VOTED
  - GIVEN ancienneté 3j THEN 400 ERR_TOO_NEW

### F190 — Décisions du CESA
- **Page :** /politics/decisions
- **Trigger :** button "Proposer décision" (membres CESA uniquement)
- **Condition :** membre CESA, mandat actif
- **Requires :** cesa_member, term active
- **SQL chain :**
  - `INSERT INTO cesa_decision (cesa_id, proposer_id, type, value, vote_end=NOW()+'3 days')`
  - Types : ajuster taxes ±20%, créer subvention temporaire, organiser événement serveur
  - Vote membres : `INSERT INTO cesa_decision_vote (decision_id, member_id, vote)` (pour/contre)
  - Adoption (tick) : si 4/7 pour → `UPDATE server_config SET tax_rate = new_rate` (ou autre effet)
  - `INSERT INTO notification FOR ALL players "🏛️ Le CESA a voté : {decision}"`
- **Idempotency :** 1 vote par membre par décision
- **Toast :** "🏛️ Décision proposée : {type}. Vote pendant 3j."
- **Tests :**
  - GIVEN membre CESA WHEN propose tax +10% THEN decision created
  - GIVEN 4 votes pour THEN decision adopted
  - GIVEN 3 votes pour + 4 contre THEN decision rejected
  - GIVEN pas membre THEN 403 ERR_NOT_CESA_MEMBER

---

## Sprint 20+ — Activités joueur (6 flows)

### F191 — Ouvrir une concession (activité joueur)
- **Page :** /business/dealership
- **Trigger :** button "Ouvrir concession"
- **Condition :** balance >= 100 000€, ancienneté >= 168j (2 ans), ht >= 5.0
- **Disabled+tooltip :** "Solde insuffisant (100 000€)" / "Ancienneté min 2 ans" / "HT insuffisants"
- **Requires :** balance, ancienneté, ht
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `CHECK balance >= 100000 AND created_at < NOW() - '168 days' AND ht >= 5.0`
  - `INSERT INTO business (owner_id, type='concession', balance=0)`
  - `UPDATE player SET balance = balance - 100000, ht = ht - 5.0`
  - `INSERT INTO transaction`
- **Fonctionnement :** Acheter matériel à l'usine (prix -30%), revendre aux joueurs (marge libre). Embaucher mécaniciens (entretien/réparation pour les clients). Stock limité.
- **Idempotency :** Oui. 1 concession par joueur
- **Toast :** "🏭 Concession ouverte ! Achetez du matériel à l'usine."
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 120000€ + 200j ancienneté WHEN open THEN concession created
  - GIVEN 50000€ THEN 400 ERR_INSUFFICIENT_BALANCE
  - GIVEN 100j ancienneté THEN 400 ERR_TOO_NEW

### F192 — Ouvrir un CIA (activité joueur)
- **Page :** /business/cia
- **Trigger :** button "Ouvrir CIA"
- **Condition :** balance >= 50 000€, ≥10 mâles reproducteurs, ancienneté >= 84j
- **Disabled+tooltip :** "Min 10 mâles reproducteurs" / "Solde insuffisant"
- **Requires :** balance, males >= 10, ancienneté
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT COUNT(*) FROM animal WHERE owner_id=$1 AND sex='M' AND is_reproducer=true` → check >= 10
  - `INSERT INTO business (owner_id, type='cia', balance=0)`
  - `UPDATE player SET balance = balance - 50000`
  - `INSERT INTO transaction`
- **Fonctionnement :** Collecter doses (1 mâle = 5 doses/mois). Catalogue génétique public. Vente doses aux joueurs (prix libre). Qualité = génétique du mâle.
- **Idempotency :** Oui. 1 CIA par joueur
- **Toast :** "🧬 CIA ouvert ! Collectez des doses de vos meilleurs mâles."
- **Animate :** balance
- **Tests :**
  - GIVEN 60000€ + 12 mâles WHEN open THEN cia created
  - GIVEN 8 mâles THEN 400 ERR_NOT_ENOUGH_MALES

### F193 — Ouvrir une laiterie (activité joueur)
- **Page :** /business/dairy
- **Trigger :** button "Ouvrir laiterie"
- **Condition :** balance >= 200 000€, ancienneté >= 168j
- **Disabled+tooltip :** "Solde insuffisant (200 000€)" / "Ancienneté min 2 ans"
- **Requires :** balance, ancienneté
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `INSERT INTO business (owner_id, type='laiterie', balance=0, capacity_liters=50000)`
  - `UPDATE player SET balance = balance - 200000`
  - `INSERT INTO transaction`
- **Fonctionnement :** Contrats d'achat lait (F092) avec éleveurs. Transformation : pasteurisé (1j, ×1.5 prix), UHT (3j, ×2), fromage (14-84j, ×3-5). Gestion DLC, personnel, stock.
- **Idempotency :** Oui. 1 laiterie par joueur
- **Toast :** "🥛 Laiterie ouverte ! Signez des contrats avec les éleveurs."
- **Animate :** balance
- **Tests :**
  - GIVEN 250000€ + 200j WHEN open THEN laiterie created
  - GIVEN 100000€ THEN 400 ERR_INSUFFICIENT_BALANCE

### F194 — Planter un verger (arboriculture)
- **Page :** /parcels/:id (type verger)
- **Trigger :** button "Planter verger"
- **Condition :** parcelle type verger, balance >= 5 000€/ha (plants), ht >= 3.0
- **Disabled+tooltip :** "Type parcelle incompatible" / "Solde insuffisant"
- **Requires :** parcel type=verger, balance, ht
- **SQL chain :**
  - `SELECT FOR UPDATE parcel WHERE id=$1 AND type='verger'`
  - `UPDATE parcel SET crop=$fruit, crop_status='planted', first_harvest_year=3`
  - `UPDATE player SET balance = balance - (size_ha * 5000), ht = ht - 3.0`
  - `INSERT INTO transaction`
- **Essences :** Pommiers (récolte automne), poiriers (automne), cerisiers (été), pruniers (été)
- **Cycle :** 3 ans avant 1ère récolte. Taille annuelle (hiver, 1 HT). Traitement (printemps). Récolte manuelle (2 HT/ha).
- **Idempotency :** Oui
- **Toast :** "🍎 {fruit} plantés ! Première récolte dans 3 ans."
- **Animate :** balance, ht
- **Tests :**
  - GIVEN verger 2ha + 15000€ WHEN plant pommiers THEN crop=pommier, balance -10000
  - GIVEN parcelle culture THEN 400 ERR_WRONG_PARCEL_TYPE

### F195 — Construire méthaniseur
- **Page :** /buildings/buy
- **Trigger :** button "Construire"
- **Condition :** balance >= 200 000€, ht >= 5.0, ≥50 animaux (source fumier)
- **Disabled+tooltip :** "Solde insuffisant" / "Min 50 animaux (source fumier)"
- **Requires :** balance, ht, animals >= 50
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - `SELECT COUNT(*) FROM animal WHERE owner_id=$1` → check >= 50
  - `INSERT INTO building (owner_id, type='methaniseur', capacity=1000, efficiency=0.8)`
  - `UPDATE player SET balance = balance - 200000, ht = ht - 5.0`
  - `INSERT INTO transaction`
- **Tick journalier :** fumier/lisier → biogaz (revente 500€/jour) + digestat (engrais gratuit). ROI ~3-5 ans.
- **Idempotency :** Oui
- **Toast :** "⚡ Méthaniseur construit ! Revenu estimé 500€/jour."
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 250000€ + 60 animaux WHEN build THEN methaniseur created
  - GIVEN 30 animaux THEN 400 ERR_NOT_ENOUGH_ANIMALS

### F196 — Construire huilerie / sucrerie
- **Page :** /buildings/buy
- **Trigger :** button "Construire"
- **Condition :** balance >= 150 000€, ht >= 5.0, parcelles colza/tournesol ou betterave
- **Disabled+tooltip :** "Solde insuffisant" / "Aucune parcelle compatible"
- **Requires :** balance, ht, compatible parcels
- **SQL chain :**
  - `SELECT FOR UPDATE player WHERE id=$1`
  - Huilerie : `SELECT COUNT(*) FROM parcel WHERE owner_id=$1 AND crop IN ('colza','tournesol')` → check > 0
  - Sucrerie : `SELECT COUNT(*) FROM parcel WHERE owner_id=$1 AND crop='betterave'` → check > 0
  - `INSERT INTO building (owner_id, type=$type, capacity=500)`
  - `UPDATE player SET balance = balance - 150000, ht = ht - 5.0`
  - `INSERT INTO transaction`
- **Transformation :**
  - Huilerie : 1T colza → 400kg huile (2.50€/kg) + 600kg tourteau (0.30€/kg)
  - Sucrerie : 1T betterave → 150kg sucre (0.80€/kg) + 50kg écume (0.12€/kg)
- **Idempotency :** Oui
- **Toast :** "🏭 {type} construite ! Transformez vos récoltes."
- **Animate :** balance, ht
- **Tests :**
  - GIVEN 200000€ + parcelle colza WHEN build huilerie THEN building created
  - GIVEN 0 parcelle compatible THEN 400 ERR_NO_COMPATIBLE_PARCELS


---

## Gestion parcelles — Regroupement & Dissociation

### F197 — Regrouper des parcelles
- **Sprint :** 10
- **Page :** /parcels (sélection multiple, même ville, même type)
- **Condition :** 2+ parcelles, même type, même préfecture, taille totale ≤ max du type
- **Logique :** Fusion en 1 parcelle. Sol = moyenne pondérée par surface. Coût 0.5 HT.
- **Tailles max :** Culture 100ha, Pré 50ha, Verger 10ha, Vigne 8ha, Forêt 200ha
- **Test :** GIVEN 2 parcelles culture 10ha+15ha même ville WHEN merge THEN 1 parcelle 25ha

### F198 — Dissocier une parcelle
- **Sprint :** 10
- **Page :** /parcels/:id
- **Condition :** Parcelle sans culture active, taille > taille min du type
- **Ce qu'il saisit :** Taille de la nouvelle parcelle (le reste = l'ancienne réduite)
- **Logique :** Découpe en 2. Sol identique. Coût 0.5 HT.
- **Test :** GIVEN parcelle 25ha WHEN split 10ha THEN 2 parcelles (10ha + 15ha)


### F199 — Souscrire assurance récolte
- **Sprint :** 14
- **Page :** /parcels/:id
- **Condition :** Parcelle avec culture active, balance >= prime
- **Logique :** Prime = 15€/ha/an. Si événement météo destructeur (F141 grêle/gel) → indemnisation 70% de la perte estimée. Versée automatiquement après l'événement.
- **Test :** GIVEN assuré + grêle -50% rendement THEN indemnisation = 70% × perte
