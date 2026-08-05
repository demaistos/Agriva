# TODO — SimAgri

> Dernière mise à jour : 2026-04-03
> Voir `docs/RULES_ENGINE.md` pour les règles complètes du jeu.
> Voir `docs/sdd/README.md` pour l'architecture et les SDD par domaine.

---

## ✅ FAIT — Fondations

### Auth & Joueurs
- [x] Register/Login (JWT)
- [x] Joueurs : balance, hours_today, fuel_stock, commune_id
- [x] Communes (324 préfectures + sous-préfectures, 96 départements)
- [x] Inscription : Région → Département → Commune

### Temps & Worker
- [x] game_time (game_day, game_hour, time_ratio)
- [x] Worker BullMQ : ticks hourly, daily, weekly
- [x] Système d'heures (consumeHours, hours_multiplier)

### Bâtiments
- [x] Construction, niveaux d'équipement, capacité
- [x] Types : élevage (stabulation, poulailler, etc.), stockage (silo, hangar, etc.)
- [x] Silo mono-type (assigned_item)
- [x] Config ration par bâtiment (ration_base_id, complement_*)
- [x] Productivité stockée (last_productivity)
- [x] Nourrissage manuel/robot (fed_today, has_feed_robot)
- [x] API : construire, détruire, configurer ration, nourrir, options de ration

### Matériel
- [x] Tracteurs, bennes, plateaux, bétaillères, désileuses
- [x] Usure, pannes, réparations
- [x] Compatibilité puissance (CV tracteur ≥ CV requis remorque)
- [x] Consommation carburant

### Animaux & Élevage
- [x] 21 races (7 espèces : bovin, ovin, caprin, cheval, porcin, volaille, lapin)
- [x] Lots d'animaux (hunger, thirst, health, weight, birth_date)
- [x] Achat avec bétaillère + tracteur
- [x] Reproduction (monte naturelle, gestation, naissances)
- [x] Production d'œufs (modulée par productivité, calibre par âge)
- [x] Prise de poids (modulée par productivité)
- [x] Santé : faim/soif → maladie → mort

### Alimentation (nouveau système)
- [x] Catalogue unifié : 20 aliments (feed_items) avec prix et transport
- [x] Ration de base : 20 options pour 7 espèces (ration_bases + ration_base_items)
- [x] Compléments optionnels : 21 compléments (ration_complements)
- [x] Coefficients d'âge : 21 stades (age_stages)
- [x] Base partielle proportionnelle (weight sur ration_base_items)
- [x] Productivité : 75% base → 120% max avec tous compléments
- [x] Worker : nourrissage par bâtiment, consommation par ingrédient

### Marché / Coopérative
- [x] Achat d'aliments avec transport (tracteur + benne/plateau)
- [x] Vérification capacité silo, affectation mono-type
- [x] Coût = prix × 1.15 + carburant + heures + usure

### Météo
- [x] 5 zones climatiques, prévisions 7 jours
- [x] Températures réalistes par climat × saison
- [x] Alertes gel, grêle, canicule
- [x] Dashboard widget 3 jours + page /meteo complète

### Cultures
- [x] Parcelles, semis, pousse (hourlyTick), récolte
- [x] Impact météo sur maturation (eau, soleil)

### Dashboard
- [x] Météo 3 jours avec tooltips
- [x] Stock alimentation (base + compléments, barres colorées)
- [x] Alertes (stock bas, météo, naissances)
- [x] Son de notification
- [x] Badge "nouveau" animaux nés
- [x] Compteur argent gagné/perdu du jour

---

## 🔴 PROCHAINE SESSION — Actions prioritaires

### 1. Corriger le dailyTick (worker)
- [ ] Reset `fed_today = false` sur tous les bâtiments d'élevage
- [ ] Vérifier que `hours_today` est bien reset (quota quotidien)
- [ ] Fichier : `worker/src/ticks/daily.ts`

### 2. Système de notifications
- [ ] Table `notifications` (player_id, type, message, data JSONB, read, created_at)
- [ ] Le worker y écrit les événements : ponte, naissance, mort, stock bas, maladie
- [ ] API `GET /notifications` — liste des notifications du joueur
- [ ] API `POST /notifications/:id/read` — marquer comme lue
- [ ] Dashboard : afficher les notifications au lieu des alertes statiques

### 3. Système de transactions
- [ ] Table `transactions` (player_id, type, amount, description, metadata JSONB, created_at)
- [ ] Modifier `deductBalance` et `addBalance` pour créer une transaction à chaque opération
- [ ] API `GET /transactions` — relevé bancaire du joueur
- [ ] Fichier : `server/src/services/player.ts`

### 4. API de vente
- [ ] `POST /market/sell/eggs` — vendre des œufs (stock egg_stock → argent)
- [ ] `POST /market/sell/animal` — vendre un animal à l'abattoir (prix_kg × poids)
- [ ] Prix de vente des œufs par calibre (S, M, L, XL)
- [ ] Prix de vente viande par espèce et qualité
- [ ] Fichier : `server/src/routes/market.ts`

### 5. Pages frontend essentielles
- [ ] Page Bâtiments : liste, config ration (dropdown base + checkboxes compléments), bouton nourrir
- [ ] Page Marché : acheter aliments (choisir aliment, quantité, tracteur, remorque, silo)
- [ ] Page Stock : voir chaque silo/hangar avec contenu et capacité
- [ ] Page Animaux : état de chaque lot (faim, santé, poids, productivité)
- [ ] Page Vente : vendre œufs, vendre animaux

---

## 🟡 APRÈS — Profondeur gameplay

### Impact météo sur l'élevage
- [ ] Canicule → stress animaux → baisse productivité
- [ ] Gel → risque si animaux au pré en hiver
- [ ] Lié au système météo existant

### Saisonnalité / Pâturage
- [ ] Mapping game_day → saison (printemps/été/automne/hiver)
- [ ] Ruminants au pré avril-octobre : pas de ration de base, herbe gratuite
- [ ] Consommation d'herbe au pré (m²/jour par animal)
- [ ] Rentrée en stabulation novembre-mars

### Litière / Fumier
- [ ] Paille pour la litière (consommation quotidienne)
- [ ] Sans litière → maladie
- [ ] Litière → fumier → fosse → épandage → rendements cultures

### Eau complète
- [ ] Cuve à eau (bâtiment)
- [ ] Eau de pluie (liée à la météo)
- [ ] Bacs au pré + tonne à eau

### Qualité des aliments
- [ ] 3 niveaux (mauvaise, moyenne, bonne)
- [ ] Impact sur productivité
- [ ] Dégradation dans le temps

### Production de lait
- [ ] Traite (salle de traite + cuve)
- [ ] Production modulée par productivité
- [ ] Vente à la laiterie

### Journal de ferme
- [ ] Notifications enrichies : "Vos poules ont pondu 42 œufs", "Stock de blé bas"
- [ ] Historique consultable
- [ ] Résumé quotidien

---

## 🔵 FUTUR — Features avancées

- [ ] Génétique (indices, sélection, amélioration)
- [ ] Maraîchage (légumes, serres)
- [ ] Fromagerie (transformation lait)
- [ ] Coopérative entre joueurs (achat/vente)
- [ ] Transport routier (camions, chauffeurs)
- [ ] Concessions (vente matériel entre joueurs)
- [ ] Employés (PA supplémentaires)
- [ ] Prêts bancaires
- [ ] Assurances matériel
- [ ] Bio vs conventionnel (choix stratégique)

---

## 📋 Dette technique

- [ ] Supprimer l'ancienne table `feed_types` (remplacée par `feed_items`)
- [ ] Supprimer les colonnes obsolètes `ration_type` et `ration_kg` sur `animal_definitions`
- [ ] Optimiser le worker : réduire le nombre de requêtes SQL par tick
- [ ] Tester le worker en conditions réelles (scheduler BullMQ)
- [ ] Mettre à jour le Dashboard Vue pour les derniers changements (config par bâtiment)
