# Boucles de Gameplay — Parcours Utilisateur Complet

> Pour chaque boucle : OÙ le joueur va, CE QU'IL voit, CE QU'IL saisit, CE QUI se passe.
> Document vivant — 1 section par boucle.

---

## 1. 🏗️ Infrastructure (6 flows)

### Parcours : Construire un bâtiment (F001)

**Où :** `/buildings/buy`
**Ce que le joueur voit :**
- Catalogue en grille : type (stabulation, silo, poulailler…), prix/unité, description
- Formulaire : sélection type, taille (slider ou input), nom libre

**Ce qu'il saisit :**
- `building_type_id` : sélection dans le catalogue
- `size` : nombre (m², tonnes, litres, postes selon le type)
- `name` : texte libre 1-50 chars

**Ce qui se passe :**
- Coût = `size × price_per_unit` (ex: 100m² × 30€ = 3 000€ pour une stabulation)
- Consomme 2.0 HT + coût en €
- Construction instantanée niveau 1 (les 10 premiers bâtiments)
- Niveaux 2+ : délai de construction (1j par niveau)
- Écriture ledger, WS events balance+HT
- Toast : `🏗️ Stabulation construite ! (100 m²)`
- Redirect → `/buildings`

**Bouton grisé si :** solde < prix | HT < 2.0

---

### Parcours : Améliorer un bâtiment (F069)

**Où :** `/buildings/:id`
**Ce que le joueur voit :**
- Fiche bâtiment : type, taille, niveau actuel (1-5), usure, capacité, remplissage
- Bouton "Améliorer niveau {N+1}" avec coût affiché

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :**
- Coût = `base_cost × size × 0.50` par niveau
- Le bâtiment doit être VIDE (pas d'animaux, pas de stock)
- Niveau max = 5. Chaque niveau réduit la consommation énergie
- Consomme 1.0 HT + coût
- Toast : `🏗️ Stabulation améliorée niveau 2 !`

**Bouton grisé si :** niveau = 5 | bâtiment pas vide | solde insuffisant

---

### Parcours : Détruire un bâtiment (F070)

**Où :** `/buildings/:id`
**Ce que le joueur voit :**
- Bouton rouge "Détruire" avec montant récupéré affiché
- Modale de confirmation : `⚠️ Action irréversible — vous récupérez 10% du coût total`

**Ce qu'il saisit :** Confirmation dans la modale

**Ce qui se passe :**
- Le bâtiment doit être VIDE
- Récupère 10% du total investi (construction + améliorations)
- Consomme 1.0 HT
- Bâtiment supprimé de la DB
- Toast : `🏚️ Stabulation détruite — 300€ récupérés`
- Redirect → `/buildings`

**Bouton grisé si :** bâtiment pas vide

---

### Parcours : Voir liste bâtiments (F072)

**Où :** `/buildings`
**Ce que le joueur voit :**
- DataTable : type, nom, taille, niveau, usure (%), capacité (X/Y), taux remplissage
- Chaque ligne cliquable → `/buildings/:id`
- Si 0 bâtiment → message vide + CTA "Construire"

**Ce qu'il saisit :** Rien (consultation)

---

### Parcours : Voir énergie bâtiments (F106)

**Où :** `/buildings/energy`
**Ce que le joueur voit :**
- Tableau : bâtiment, niveau, conso kWh/mois, facteur saison, coût €/mois
- Total mensuel estimé en bas
- Facteur saison : hiver ×1.3, été ×1.1, printemps/automne ×1.0

**Ce qu'il saisit :** Rien (consultation)

---

### Parcours : Changer type de sol (F107)

**Où :** `/buildings/:id` (stabulation, porcherie, chèvrerie, bergerie)
**Ce que le joueur voit :**
- Indicateur sol actuel : "Litière" ou "Caillebotis"
- Bouton "Passer en caillebotis" (ou inversement)
- Modale : explication des conséquences

**Ce qu'il saisit :** Confirmation dans la modale

**Ce qui se passe :**
- Litière → caillebotis : plus de fumier, vous aurez du lisier (fosse à lisier requise)
- Caillebotis → litière : plus de lisier, vous aurez du fumier (fosse à fumier requise)
- Caillebotis = pas de paille nécessaire, pas de mise au pré, pas de label plein-air
- Bâtiment doit être VIDE
- Consomme 1.0 HT + coût

**Bouton grisé si :** bâtiment pas vide | solde insuffisant

---

### Chaîne de dépendances Infrastructure

```
F001 Construire ──→ F069 Améliorer
                ──→ F070 Détruire
                ──→ F072 Voir liste
                ──→ F106 Voir énergie
                ──→ F107 Changer sol
```

Tous les autres boucles dépendent de F001 (il faut des bâtiments pour stocker, abriter, produire).


---

## 2. 🐄 Élevage — Soins & Alimentation (16 flows)

> Le quotidien de l'éleveur : acheter, nourrir, abreuver, soigner, pailler, nettoyer.

### Parcours : Acheter un animal au Marché Central (F002)

**Où :** `/market/animals`
**Ce que le joueur voit :**
- DataTable : race, sexe, âge, prix, distance depuis sa ferme, coût transport, total
- Filtres : espèce (bovins/ovins/caprins/porcins/volailles/lapins/chevaux), race, sexe, prix

**Ce qu'il saisit :**
- `breed_id` : sélection race
- `life_stage` : adulte/jeune
- `sex` : mâle/femelle
- `building_id` : sélection bâtiment destination (dropdown filtré par espèce)

**Ce qui se passe :**
- Transport calculé : `distance_km = haversine(marché, joueur)`
- Coût total = prix animal + `distance × 0.50€/km`
- HVC consommé = `distance × 0.15 L/km`
- HT = `0.5 + distance/100`
- Usure véhicule = `distance × 0.02%` (risque panne si >80%)
- Animal créé en `status='in_transit'`, arrive dans `distance/50` heures
- Véhicule requis selon espèce :
  - Bovins/ovins/caprins/porcins/bisons/daims → tracteur + bétaillère
  - Volailles/pintades/lapins/oies/canards → utilitaire
  - Chevaux → utilitaire + van

**Bouton grisé si :** solde < total | HT insuffisants | pas de place | véhicule manquant/en panne | HVC insuffisant

---

### Parcours : Voir liste animaux (F003)

**Où :** `/animals`
**Ce que le joueur voit :**
- Dashboard élevage en haut : compteurs (total, malades, non nourris, gestantes, en transit)
- DataTable : nom, race, sexe, âge, santé (barre), nourri (✅/❌), lieu, production
- Filtres : espèce, bâtiment, état (sain/malade/gestante), nourri/pas nourri
- Si 0 animal → "Achetez votre premier animal" + lien marché

**Ce qu'il saisit :** Rien (consultation). Clic sur ligne → fiche animal.

---

### Parcours : Consulter fiche animal (F004)

**Où :** `/animals/:id`
**Ce que le joueur voit :**
- Identité : nom, race, sexe, âge, poids, nommé ou pas
- Génétique : 5 barres (lait, viande, fertilité, robustesse, morphologie)
- Santé : barre santé, vacciné (oui/non + expiration), malade, en soins
- Alimentation : dernière ration, qualité, nourri aujourd'hui, abreuvé
- Production (selon espèce) : lait/jour, œufs/jour, laine prête, poids carcasse estimé
- Reproduction : gestante (date mise bas), dernière insémination, nombre de petits
- Parents : père + mère (cliquables)
- Boutons d'action : Nourrir, Soigner, Vacciner, Inséminer, Tondre, Vendre, Déplacer, Renommer

**Ce qu'il saisit :** Rien (consultation). Actions via boutons.

---

### Parcours : Renommer un animal (F005)

**Où :** `/animals/:id` — clic sur le nom (icône ✏️)
**Ce que le joueur voit :** Input inline qui remplace le nom

**Ce qu'il saisit :**
- `name` : 1-30 chars, regex `[a-zA-ZÀ-ÿ0-9 '-]+`

**Ce qui se passe :**
- `UPDATE animal SET name=$name, is_named=true`
- Checkmark inline, pas de toast
- Un animal nommé a un avertissement supplémentaire à l'abattoir

**Bouton grisé si :** animal mort | nom trop long | caractères invalides

---

### Parcours : Acheter aliments au Marché Central (F006)

**Où :** `/market/products`
**Ce que le joueur voit :**
- Catalogue aliments : foin, maïs ensilé, tourteau soja, blé, avoine, minéraux, paille…
- Prix unitaire (€/tonne), stock actuel dans le silo, capacité restante
- Calculateur : quantité × prix = total

**Ce qu'il saisit :**
- `product` : sélection aliment
- `quantity` : tonnes
- `building_id` : silo destination

**Ce qui se passe :**
- Transport : tracteur + benne requis, distance × coûts
- Stock ajouté au silo (plafonné à la capacité)
- HVC consommé, usure véhicule
- Toast : `🌾 2t de foin achetées pour 160€`

**Bouton grisé si :** pas de silo | silo plein | pas de tracteur/benne | HVC insuffisant

---

### Parcours : Remplir cuve à eau (F007)

**Où :** `/buildings/:id` (cuve eau)
**Ce que le joueur voit :** Jauge cuve (ex: 3000/10000L), bouton "Remplir"

**Ce qu'il saisit :**
- `quantity` : litres à ajouter

**Ce qui se passe :**
- Coût = quantité × prix/L
- Consomme 0.5 HT
- Toast : `💧 Cuve remplie (7000L) — 35€`

**Bouton grisé si :** cuve pleine | solde insuffisant | HT < 0.5

---

### Parcours : Nourrir animaux manuellement (F008)

**Où :** `/buildings/:id/feed`
**Ce que le joueur voit :**
- Liste des rations disponibles pour cette espèce (qualité ★1-5)
- Détail ration : composants (foin 60%, maïs 30%, minéraux 10%), stock disponible par composant
- Méthode : manuel (1.0 HT + 0.05/animal) ou désileuse (0.5 HT + 0.02/animal, nécessite tracteur+désileuse)
- Indicateur "déjà nourris aujourd'hui" par bâtiment

**Ce qu'il saisit :**
- `ration_id` : sélection ration
- `method` : `manual` ou `desilage`

**Ce qui se passe :**
- Stock déduit par composant (ex: 10 vaches × 25kg foin/jour = 250kg)
- Animaux marqués `last_fed_at=NOW(), days_unfed=0`
- Qualité ration impacte production (lait, croissance)
- Si désileuse : usure tracteur+désileuse, risque panne
- Toast : `🍽️ 10 animaux nourris — Ration Premium ★4`
- Icônes DataTable passent de 🍽️❌ à 🍽️✅

**Bouton grisé si :** pas de ration sélectionnée | stock insuffisant | HT insuffisants | déjà nourris | désileuse sans tracteur

---

### Parcours : Abreuver animaux (F009)

**Où :** `/buildings/:id`
**Ce que le joueur voit :** Indicateur eau (cuve liée), bouton "Abreuver 💧"

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :**
- Eau déduite de la cuve : bovins 80-120L/jour, ovins 5-10L, volailles 0.2-0.5L
- Consomme 0.3 HT
- Toast : `💧 10 animaux abreuvés (450L)`

**Bouton grisé si :** pas de cuve | cuve vide | déjà abreuvés

---

### Parcours : Configurer nourrissage auto (F010)

**Où :** `/buildings/:id/auto-feed`
**Ce que le joueur voit :**
- Toggle ON/OFF
- Sélection ration + méthode
- Estimation stock restant en jours
- Avertissement si stock < 15 jours

**Ce qu'il saisit :**
- `ration_id` : sélection
- `method` : manual/desilage

**Ce qui se passe :**
- Config sauvegardée. Chaque jour le tick worker applique automatiquement le nourrissage
- Si stock tombe à 0 → skip + notification `⚠️ Stock épuisé, nourrissage auto suspendu`
- Toast : `⚙️ Nourrissage auto activé — ~23j de stock`

**Bouton grisé si :** pas de ration | stock < 15 jours | déjà actif

---

### Parcours : Tick santé — animaux non nourris (F011)

**Automatique** — worker tick quotidien

**Ce qui se passe :**
- Jour 1 sans nourriture : `health -= 10`
- Jour 2 : `health -= 10`
- Jour 3 : `is_sick = true` → production arrêtée (lait=0, poids=0, mâle ne peut plus inséminer)
- Jour 7+ : si `health <= 0` → animal mort
- Même logique pour l'eau (F053)
- Notifications : `🍽️ 3 animaux pas nourris` / `🏥 2 malades` / `💀 1 mort`

---

### Parcours : Soigner un animal (F012)

**Où :** `/animals/:id`
**Ce que le joueur voit :** Badge 🏥 "Malade", bouton "Soigner {cost}€"

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :**
- Coût ~100€ + 0.5 HT
- `is_healing=true, healing_until=NOW()+3j, health+=10`
- Pendant 3j : animal en soins, pas de production
- Après 3j : guéri, production reprend
- Toast : `🩺 Marguerite en soins ! Guérison dans ~3j`

**Bouton grisé si :** pas malade | solde insuffisant | HT < 0.5

---

### Parcours : Soigner tous en batch (F013)

**Où :** `/animals` (dashboard)
**Ce que le joueur voit :** Badge "X malades", bouton "Soigner tous"

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :** Même que F012 mais pour tous les malades en une transaction.

---

### Parcours : Vacciner un animal (F014)

**Où :** `/animals/:id`
**Ce que le joueur voit :** Statut vaccin (non vacciné / vacciné jusqu'au {date})

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :**
- Coût 50€ + 0.5 HT
- Protection 84 jours (1 an Cultivia)
- Réduit le risque de maladie
- Toast : `💉 Marguerite vaccinée ! Protection 1 an`

**Bouton grisé si :** déjà vacciné (expire dans Xj)

---

### Parcours : Mettre de la paille (F015)

**Où :** `/buildings/:id`
**Ce que le joueur voit :** Indicateur litière (fraîche/dégradée/absente), stock paille disponible

**Ce qu'il saisit :**
- `method` : `manual` (1.0 HT) ou `pailleuse` (0.5 HT, nécessite tracteur+pailleuse)

**Ce qui se passe :**
- Paille déduite du stock (ex: 50kg pour 10 vaches)
- `bedding_ok=true, bedding_at=NOW()`
- La paille se transforme en fumier : `manure += paille × 1.2`
- Si pailleuse : usure tracteur+pailleuse
- Toast : `🛏️ Litière posée — 50kg paille, 60kg fumier`

**Bouton grisé si :** pas de paille | litière fraîche | sol caillebotis | pailleuse sans tracteur

---

### Parcours : Retirer le fumier (F016)

**Où :** `/buildings/:id`
**Ce que le joueur voit :** Jauge fumier (ex: 800/2000kg), bouton "Retirer fumier 💩"

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :**
- Fumier transféré du bâtiment vers la fosse à fumier
- Nécessite tracteur + épandeur fumier + HVC
- Consomme 0.5 HT
- Toast : `💩 Fumier retiré : 800kg → fosse`

**Bouton grisé si :** pas de fumier | fosse pleine | pas de fosse | pas de tracteur/épandeur

---

### Parcours : Retirer le lisier (F017)

**Où :** `/buildings/:id` (sol caillebotis uniquement)
**Ce que le joueur voit :** Jauge lisier, bouton "Retirer lisier"

**Ce qu'il saisit :** Rien (1 clic)

**Ce qui se passe :**
- Lisier transféré vers fosse à lisier
- Nécessite tracteur + tonne à lisier + HVC
- Même logique que F016 mais pour le lisier
- Toast : `💧 Lisier retiré : 500L → fosse`

**Bouton grisé si :** pas de lisier | fosse lisier pleine | pas de tonne à lisier

---

### Routine quotidienne type d'un éleveur

```
Chaque jour le joueur fait (ou le nourrissage auto le fait) :
  1. Nourrir (F008)     → 1.0-2.0 HT, stock aliments déduit
  2. Abreuver (F009)    → 0.3 HT, eau déduite
  3. Traire (F023)      → si vaches laitières (boucle prod)
  4. Ramasser œufs (F083) → si volailles (boucle prod)

Périodiquement :
  5. Pailler (F015)     → quand litière dégradée (~tous les 3-5j)
  6. Retirer fumier/lisier (F016/F017) → quand fosse pleine
  7. Soigner (F012)     → si animal malade
  8. Vacciner (F014)    → tous les 84j
  9. Acheter aliments (F006) → quand stock bas
  10. Remplir eau (F007) → quand cuve basse
```


---

## 3. 🧬 Élevage — Production & Reproduction (23 flows)

> Insémination, naissance, traite, abattoir, laine, œufs, vente entre joueurs.

### Parcours : Inséminer avec mâle de la ferme (F018)

**Où :** `/animals/:id` (femelle adulte)
**Ce que le joueur voit :** Bouton "Inséminer 1.0 HT", liste des mâles compatibles (même race)

**Ce qu'il saisit :**
- `male_id` : sélection du mâle

**Ce qui se passe :**
- Vérifications : femelle adulte, pas gestante, en période, même race, mâle pas au max/jour, délai post-naissance respecté
- `pregnant_until = NOW() + gestation_duration` (bovins 63j, ovins 35j, porcins 28j, volailles 7j)
- Génétique du futur petit calculée (moyenne parents ± variation)
- Toast : `🧬 Marguerite inséminée ! Mise bas : {date}`

**Bouton grisé si :** pas adulte | gestante | hors période | pas de mâle même race | mâle au max | délai post-naissance

### Parcours : Inséminer par CIA (F019)

**Où :** `/animals/:id`
**Même logique** mais coûte de l'argent (200€), pas besoin de mâle sur la ferme. Génétique de la dose CIA (souvent meilleure).

### Parcours : Tick naissance (F020)

**Automatique** — quand `pregnant_until <= NOW()`
- Crée 1 à 12 petits selon l'espèce (bovins=1, porcins=6-12, volailles=6-10)
- Petits dans le même bâtiment que la mère
- Mère passe en lactation (`is_lactating=true`)
- Races allaitantes : petits en allaitement 21j
- Notification : `🐄 Marguerite a donné naissance à 1 veau !`

### Parcours : Placer animal depuis arrivage (F021)

**Où :** `/animals` (dashboard, badge "X en arrivage")
**Ce qu'il saisit :** Rien ou sélection bâtiment
- Auto-placement dans le premier bâtiment avec de la place
- Consomme 0.2 HT par animal

### Parcours : Voir arbre généalogique (F022)

**Où :** `/animals/:id` → bouton "Voir généalogie"
- Arbre SVG 3 générations (parents, grands-parents, arrière-grands-parents)
- Chaque nœud cliquable → fiche animal

### Parcours : Traire les vaches (F023)

**Où :** `/animals/milking`
**Ce que le joueur voit :**
- Liste des vaches en lactation, production estimée par vache
- 4 créneaux/jour : avant 6h, avant 12h, avant 18h, avant 24h
- Indicateur créneau actuel, dernier créneau traité

**Ce qu'il saisit :**
- `slot` : 1/2/3/4 (ou "toutes")
- `animal_ids` : sélection ou "toutes"

**Ce qui se passe :**
- HT = `ceil(nb_vaches / nb_postes_traite) × 0.5`
- Production par vache = `base × genetics.milk_index × feeding_quality_bonus`
- Lait ajouté à la cuve
- S'applique aussi aux caprins et ovins laitiers
- Toast : `🥛 32L collectés ! Qualité ⭐4`

**Bouton grisé si :** pas de salle traite | cuve pleine | déjà trait ce créneau | créneau dépassé

### Parcours : Vendre lait (F024)

**Où :** `/animals/productions`
**Ce qu'il saisit :** `quantity` (litres)
- Nécessite tracteur + citerne à lait + HVC
- Transport vers le Marché Central (distance × coûts)
- Toast : `🥛 500L vendus pour 190€`

### Parcours : Vendre animal à l'abattoir (F025)

**Où :** `/animals/:id` → bouton "Vendre 🔪"
**Ce que le joueur voit :**
- Modale de confirmation avec avertissements :
  - Si gestante → "⚠️ Veau perdu"
  - Si en lactation → "⚠️ Lait perdu"
  - Si nommée → "⚠️ Êtes-vous sûr ?"
- Estimation prix : poids carcasse × prix/kg × qualité

**Ce qui se passe :**
- `carcass_weight = weight × rendement_carcasse(race)` (allaitants 55-75%, laitières 50-55%)
- Qualité : conformation (A-E) + engraissement (1-5) depuis `genetics.allure_generale`
- Prix = `carcass_weight × market_price × quality_multiplier`
- Transport : tracteur + bétaillère (ou utilitaire pour volailles)
- Animal passe en `life_stage='dead'`
- Toast : `🔪 Vendu pour 1 512€ (carcasse 379kg, qualité B3)`

### Parcours : Déplacer animal au pré (F029)

**Où :** `/animals/:id` → modale destination
**Ce qu'il saisit :**
- `destination_id` : parcelle de type pré
- `animal_ids` : sélection

**Ce qui se passe :**
- Hiver + race laitière → interdit (sauf allaitantes avec ration hivernale)
- Nécessite tracteur + bétaillère (ou utilitaire) + HVC
- Toast : `🚜 3 animaux déplacés vers Pré Nord`

**Bouton grisé si :** pas de place | hiver + laitière | pas de bétaillère

### Parcours : Tick arrivée animaux en transit (F048)

**Automatique** — quand `arrival_at <= NOW()`
- `status = 'available'`, animal utilisable
- Notification : `🐄 1 animal arrivé à la ferme`

### Parcours : Remplir bacs à eau au pré (F051)

**Où :** `/parcels/:id` (pré avec animaux)
- Nécessite tracteur + tonne à eau + HVC
- Eau transférée de la cuve vers les bacs du pré
- Toast : `💧 Bacs remplis (500L) dans Pré Nord`

### Parcours : Ticks automatiques élevage

- **F052 Tick litière** : chaque jour, fumier s'accumule (litière) ou lisier (caillebotis). Si fumier >80% → notification.
- **F053 Tick eau** : chaque jour, eau consommée. Si cuve=0 → `days_unwatered+=1, health-=5`. Jour 3 → malade.
- **F075 Tick accumulation fumier** : même que F052, calcul précis par espèce.

### Parcours : Appeler le négociant (F071)

**Où :** `/market/negociant`
- 1 appel/mois max. Génère 4 offres aléatoires (races du joueur, génétique moyenne, prix ×1.2)
- Animaux du négociant = non revendables entre joueurs (`negociant_origin=true`)

### Parcours : Vendre/acheter animal entre joueurs (F080/F081)

**Où :** `/animals/:id` → "Mettre en vente" / `/market/animals/players` → "Acheter"
- Le vendeur fixe son prix, l'annonce apparaît sur le marché
- L'acheteur paie prix + transport (distance entre les 2 fermes)
- Animaux du négociant non revendables

### Parcours : Tondre mouton (F082)

**Où :** `/animals/:id` (ovin adulte, laine prête)
- 0.5 HT, laine ajoutée à l'inventaire
- Tonte possible quand toison = 100% (repousse ~84j)

### Parcours : Ramasser œufs (F083)

**Où :** `/buildings/:id` (poulailler)
- Nécessite salle de conditionnement + pièce stockage
- Calibrage selon âge poule : S (<6 mois), M (6-12), L (12-24), XL (>24 mois)
- 3-5 œufs/poule/jour
- Toast : `🥚 45 œufs ramassés ! (calibre L)`

### Parcours : Vendre laine / œufs (F099/F100)

**Où :** `/animals/productions`
- Laine : ~0.45€/kg
- Œufs : S=0.08€, M=0.10€, L=0.13€, XL=0.16€
- Consomme 0.5 HT

### Parcours : Voir stats carcasses / qualité lait (F097/F098)

**Où :** `/animals/carcass-stats` et `/animals/milk-quality`
- Consultation pure : historique, moyennes, graphiques


---

## 4. 🌾 Cultures (25 flows)

> Du labour à la vente : le cycle cultural complet.

### Cycle cultural complet

```
Jachère → Déchaumer (F037) → Labourer (F037) → Herser (F037) → Semer (F038)
→ [Rouler (F054)] → [Biner (F101)] → [Épandre engrais (F039)] → [Traiter (F040)]
→ [Irriguer (F058)] → [Défaner (F102)] → Récolter (F041) → [Presser paille (F059)]
ou [Broyer paille (F060)] → Vendre récolte (F042)

3 techniques de travail du sol :
  Traditionnel : déchaumer → labourer → herser (3 passages)
  TCS (Techniques Culturales Simplifiées) : déchaumer → herser (2 passages, pas de labour)
  Semis direct : rien (0 passage, semoir direct uniquement)
```

### Parcours : Acheter une parcelle (F035)

**Où :** `/parcels/buy`
**Ce que le joueur voit :** Carte avec parcelles disponibles, prix/ha par préfecture, type (culture/pré)

**Ce qu'il saisit :**
- `prefecture_id`, `type` (culture/pré), `size_ha`

**Ce qui se passe :**
- Prix = `size × price_per_ha` (variable par préfecture)
- Sol généré aléatoirement : fertilité, structure, oligo-éléments, pH, matière organique
- Consomme 2.0 HT + prix
- Toast : `🌾 Parcelle achetée ! 10ha — Qualité ⭐3`

### Parcours : Analyser le sol (F036)

**Où :** `/parcels/:id`
- Coût 50€ + 0.5 HT. Révèle les valeurs précises du sol (avant = approximatif)
- Cooldown : 1 analyse par saison

### Parcours : Préparer le sol (F037)

**Où :** `/parcels/:id`
**Ce que le joueur voit :** État parcelle + boutons séquentiels (déchaumer → labourer → herser)

**Ce qu'il saisit :**
- `type` : `stubble` (déchaumer) | `plow` (labourer) | `harrow` (herser)
- `technique` : `traditional` | `tcs` | `direct`

**Matériel requis par étape :**
- Déchaumer : tracteur + cultivateur/déchaumeur
- Labourer : tracteur + charrue (traditionnel uniquement)
- Herser : tracteur + herse rotative
- Chaque étape consomme HT + HVC + usure

**Bouton grisé si :** mauvaise séquence | matériel manquant | technique incompatible

### Parcours : Semer (F038)

**Où :** `/parcels/:id`
**Ce que le joueur voit :** Liste cultures possibles (filtrée par saison + rotation)

**Ce qu'il saisit :**
- `seed_type_id` : culture choisie (blé, maïs, colza…)
- `seed_quality` : `standard` ou `certified` (+10% rendement, +50% prix)

**Matériel :**
- Céréales/colza/tournesol/pois/herbe → semoir classique
- Maïs/betterave/tournesol → semoir monograine

**Vérifications :**
- Saison correcte (blé = oct-nov, maïs = avr-mai…)
- Rotation respectée (pas de blé après blé si rotation_years=1)
- Parcelle préparée (hersée ou semis direct)

### Parcours : Rouler (F054)

**Où :** `/parcels/:id` — entre 10% et 50% de croissance
- Tracteur + rouleau. Bonus rendement +3-5%.

### Parcours : Biner (F101)

**Où :** `/parcels/:id` — betterave/PDT uniquement, 15-60% croissance
- Tracteur + bineuse. 1-2 passages selon la culture.

### Parcours : Épandre engrais (F039)

**Où :** `/parcels/:id`
**Ce qu'il saisit :** `fertilizer_type` (N, P, K, Ca, Mg, S), `quantity_per_ha`
- Tracteur + épandeur engrais. Nutriments du sol augmentés.

### Parcours : Épandre fumier/lisier (F055/F056)

**Où :** `/parcels/:id`
- Fumier : tracteur + épandeur fumier, 25T/ha, apporte N+P+K+Ca+Mg+S
- Lisier : tracteur + tonne à lisier, 15m³/ha, apporte N+P+K

### Parcours : Traiter (F040)

**Où :** `/parcels/:id`
**Ce qu'il saisit :** `treatment_type` (fongicide/herbicide/insecticide)
- Tracteur + pulvérisateur + produit en stock
- **Interdit si vent levé** (check météo)
- Sans traitement : rendement ×0.90

### Parcours : Défaner PDT (F102)

**Où :** `/parcels/:id` — PDT à ≥80% croissance, 1 mois avant récolte
- Mécanique (broyeur) ou chimique (pulvérisateur + désherbant défanage, interdit si vent)

### Parcours : Irriguer (F058)

**Où :** `/parcels/:id`
- Prérequis : forage effectué (F057) avec source trouvée (niveau 1-10)
- Tracteur + enrouleur. Jauge eau parcelle augmentée.

### Parcours : Récolter (F041)

**Où :** `/parcels/:id` — quand culture mature (100%)
**Ce que le joueur voit :** Indicateur maturité, rendement estimé

**Matériel selon culture :**
- Céréales/colza/tournesol/pois/maïs grain → moissonneuse + benne
- Maïs ensilé/sorgho → ensileuse
- Betterave → arracheuse betterave
- PDT → arracheuse PDT
- Lin → arracheuse lin

**Rendement = 9 facteurs :**
1. Base rendement de la culture
2. Qualité semence (certified +10%)
3. Qualité sol (fertilité, structure, oligo)
4. Engrais apportés vs besoins
5. Traitements effectués (fongicide, herbicide, insecticide)
6. Irrigation (si sécheresse)
7. Météo de la saison
8. Roulage (+3-5%)
9. Fatigue sol (rotation +5, monoculture +15)

**Ce qui se passe :**
- Récolte stockée en silo (plafonné). Excédent auto-vendu au cours du jour.
- Si culture produit de la paille (blé, orge, avoine…) → paille au sol
- Parcelle repasse en jachère. Fatigue sol mise à jour.
- Toast : `🌾 82t récoltées ! 8t stockées, 74t vendues`

### Parcours : Presser paille (F059) vs Broyer paille (F060)

**Après récolte**, si paille au sol, le joueur choisit :
- **Presser** (F059) : tracteur + presse → balles en stock (vendables ou litière)
  - 3 formats : carrée 500kg, carrée 250kg, ronde 300kg
  - Exporte des nutriments du sol
- **Broyer** (F060) : tracteur + broyeur → nutriments restitués au sol
  - Pas de stock, mais sol enrichi (N, P, K, Mg)

### Parcours : Semer couvert végétal CIPAN (F103)

**Où :** `/parcels/:id` — parcelle en jachère, été/automne
- Évite sol nu en hiver. Broyage au printemps → bonus rendement culture suivante.

### Parcours : Faucher herbe (F084) + Ensiler herbe (F085)

**Où :** `/parcels/:id` (pré)
- Faucher : tracteur + faucheuse → herbe au sol
- Ensiler : ensileuse → ensilage d'herbe en silo (aliment pour bovins)

### Parcours : Vendre/louer parcelle (F086/F087)

- Vendre : récupère 80% du prix d'achat. Parcelle doit être vide.
- Louer : annonce sur le marché, loyer mensuel.

### Parcours : Planter haie (F088)

- Coût + 1.0 HT. Bonus biodiversité +5% sur primes PAC.

### Parcours : Vendre récolte (F042)

**Où :** `/market/sell`
**Ce qu'il saisit :** `product_type`, `quantity`, `quality` (1/2/3)

**Prix = base × qualité × saison :**
- Qualité 1 (basse) = ×0.85, Q2 (standard) = ×1.00, Q3 (premium) = ×1.10
- Vente en saison récolte = ×0.90 (offre abondante), hors saison = ×1.10
- Transport : tracteur + benne + HVC

### Parcours : Commander ETA Cultivia (F046)

**Où :** `/parcels/:id` → modale ETA
- Filet de sécurité si matériel manquant. L'ETA (PNJ) fait le travail immédiatement.
- Coût majoré (~×1.5 du coût normal). Pas d'usure véhicule (c'est l'ETA).

### Tick : Variation cours marché (F077)

**Automatique** — quotidien
- Prix fluctuent ±3% + facteur offre/demande
- Plafond : base ×0.7 à base ×1.5

### Tick : Primes PAC (F110)

**Automatique** — mensuel
- Prime par hectare pour cultures éligibles. Haies = bonus +5%.


---

## 5. 💰 Économie & Social (20 flows)

> Finances, employés, commerce entre joueurs, coopératives.

### Parcours : Voir cours du marché (F026)

**Où :** `/market/prices` — consultation libre
- Tableau : produit, prix actuel, variation (↑↓%), tendance 7j

### Parcours : Embaucher un employé (F027)

**Où :** `/employees`
**Ce qu'il saisit :** `name`, `specialty`
- Coût : 1 600€/mois (premier salaire immédiat) + 4 HT/jour gagnés
- Max 3 employés (= 40 + 12 = 52 HT/jour max)
- Le tick mensuel F067 débite le salaire. Si solde insuffisant → licenciement auto.

### Parcours : Licencier un employé (F028)

**Où :** `/employees` — modale confirmation "Vous perdrez 4 HT/jour"

### Parcours : Voir météo (F030)

**Où :** `/weather` — 3 jours de prévisions + alertes (gel, canicule, grêle, vent)
- Le vent empêche la pulvérisation (F040, F102 chimique)

### Parcours : Voir dashboard (F031)

**Où :** `/dashboard` — 12 widgets : finances, HT, alertes, animaux, parcelles, bâtiments, matériel, notifications, news, guide

### Parcours : Épargne (F032 souscrire / F065 clôturer / F066 tick intérêts)

**Où :** `/finances/savings`
**Ce qu'il saisit :** `amount` (min 1 000€), `duration_months` (3/6/12 → taux 3/4/5%)
- Clôture anticipée = perte de tous les intérêts non versés
- Tick annuel verse les intérêts. À maturité : capital + intérêts restitués.

### Parcours : Prêt (F033 demander / F079 rembourser anticipé)

**Où :** `/finances/loans`
**Ce qu'il saisit :** `amount`, `duration_months` (3-48)
- Plafond total : 150 000€
- Remboursement anticipé : capital restant × 1.03 (pénalité 3%)
- Tick mensuel F067 débite les mensualités.

### Parcours : Voir finances (F074)

**Où :** `/finances` — solde, ledger paginé (filtrable par catégorie), épargnes, prêts

### Parcours : Acheter HVC (F068)

**Où :** `/buildings` (cuve HVC)
**Ce qu'il saisit :** `quantity` (litres)
- Prix : 0.60€/L (Coop) ou prix CAR (0.36-0.55€)
- Si quantité > capacité cuve → excédent perdu
- Toast : `⛽ 1000L HVC achetés (600€)`

### Parcours : Envoyer message (F034)

**Où :** `/messages` → modale
**Ce qu'il saisit :** `to_player_id` (autocomplete), `subject`, `body`

### Parcours : Annonces stock entre joueurs (F091)

**Où :** `/market/stock`
**Ce qu'il saisit :** `product`, `quantity`, `price_per_unit`
- Met en vente des produits (foin, blé, engrais…) pour d'autres joueurs

### Parcours : Contrat laiterie (F092)

**Où :** `/market/dairy`
- Souscrire un contrat avec une laiterie (prix/L garanti, durée fixe)
- Le lait est vendu automatiquement au prix du contrat

### Parcours : Rejoindre une CAR (F093)

**Où :** `/cooperatives`
- Coopérative Agricole Régionale : achats groupés (HVC moins cher, engrais, semences)
- 1 seule CAR par joueur

### Parcours : Appels d'offres (F108 créer / F109 répondre)

**Où :** `/market/tenders`
- Créer : "Je cherche 50t de blé à max 180€/t, réponses sous 7j"
- Répondre : "Je propose 50t à 175€/t"

### Tick mensuel économique (F067)

**Automatique** — chaque lundi (1er du mois Cultivia)
- Débite : salaires, mensualités prêt, énergie bâtiments, taxes foncières, MSA
- Si solde insuffisant pour salaire → licenciement auto
- Notification : `📊 Prélèvements — Salaires 1600€, Prêt 850€, Énergie 120€, Taxes 250€`

### Tick primes PAC (F110)

**Automatique** — mensuel, verse les subventions par hectare cultivé

---

## 6. 🚜 Matériel (12 flows)

> Acheter, entretenir, réparer, vendre, assurer.

### Parcours : Voir liste matériel (F073)

**Où :** `/equipment`
- VehicleCards : type, marque, modèle, usure (%), état (✅/🔴 panne), abrité (oui/non)
- Si 0 véhicule → CTA "Acheter"

### Parcours : Acheter matériel neuf (F043)

**Où :** `/equipment/shop`
**Ce que le joueur voit :** Catalogue par catégorie (tracteurs, moissonneuses, outils…), marques réelles

**Ce qu'il saisit :** `vehicle_type_id`

**Ce qui se passe :**
- Livraison : `distance_concessionnaire × 0.80€/km`, délai = `distance/60` heures
- Véhicule créé en `status='in_delivery'`
- Recalcul `is_sheltered` (hangar assez grand ?)
- Toast : `🚜 John Deere 6090MC commandé ! Livraison 120km — arrivée dans 2h (96€ transport)`

### Parcours : Entretenir matériel (F044)

**Où :** `/equipment/:id`
**Ce qu'il saisit :** `type` : `monthly` ou `annual`
- Mensuel : 0€ + 1.0 HT → usure -5%
- Annuel : 500€ + 2.0 HT → usure -15%
- Objectif : maintenir l'usure sous 80% (au-dessus = 15% risque panne)

### Parcours : Réparer matériel en panne (F045)

**Où :** `/equipment/:id` (badge 🔴)
**Prérequis :** 1 pièce détachée en stock
- Coût + 2.0 HT. Usure ramenée à 50%.

### Parcours : Acheter pièce détachée (F061)

**Où :** `/equipment/:id`
- Coût = `base × (1 + age_years × 0.02)` — plus cher sur vieux matériel

### Parcours : Assurance matériel (F062 souscrire / F063 tick expiration)

**Où :** `/equipment/:id`
- Prime = `argus × 3%` par an. Réduit le coût de réparation.
- Tick quotidien vérifie expiration → notification.

### Parcours : Vendre matériel (F047)

**Où :** `/equipment/:id`
- Argus = `prix_neuf × (1-usure) × 0.85 × 0.60`
- Vente instantanée au prix argus

### Parcours : Vendre/acheter entre joueurs (F064/F089)

**Où :** `/equipment/:id` → "Mettre en vente" / `/equipment/market` → "Acheter"
- Le vendeur fixe son prix (avec indication argus)
- L'acheteur paie prix + livraison (distance entre fermes)

### Parcours : Louer matériel (F090)

**Où :** `/equipment/:id` → "Mettre en location"
- Prix/jour fixé par le propriétaire. Annonce visible par tous.

### Tick livraison matériel (F049)

**Automatique** — quand `arrival_at <= NOW()`, véhicule passe en `available`

---

## 7. 👥 Social (5 flows)

### Parcours : Voir notifications (F104)

**Où :** `/notifications`
- Liste paginée : type (alerte, info, social), message, date, lu/non lu
- Filtres par type et état lu/non lu
- Clic → marque comme lu + action (ex: lien vers l'animal malade)

### Parcours : Configurer préférences notifications (F105)

**Où :** `/settings/notifications`
- Toggles : alertes HVC, alertes santé, alertes finances, alertes récolte

### Parcours : Ajouter ami (F094)

**Où :** `/players/:id` → bouton "Ajouter en ami"
- Demande envoyée, notification WS au destinataire

### Parcours : Voir classements (F095)

**Où :** `/rankings`
- Onglets : général, élevage, cultures, finances, génétique
- Tableau paginé avec rang, pseudo, score

### Parcours : Voir fiche joueur (F096)

**Où :** `/players/:id`
- Profil public : pseudo, préfecture, stats ferme, classements, nb animaux/parcelles
- Boutons : ajouter ami, envoyer message

---

## 8. ℹ️ Information & Divers (3 flows)

### Tick livraison marchandises (F050)

**Automatique** — marchandises achetées (aliments, semences…) arrivent après transit
- `status='delivered'`, stock ajouté à l'inventaire
- Notification : `📦 Livraison arrivée : 2t de foin`

### Tick alertes ressources critiques (F076)

**Automatique** — vérifie quotidiennement :
- HVC < 50L → `⚠️ Carburant bas`
- Surpopulation bâtiment → `🔴 Surpopulation`
- Récolte prête + moissonneuse en panne → `🔴 Récolte en danger`
- Trésorerie < 3 mois de charges → `⚠️ Trésorerie tendue`
- Matériel non abrité → `ℹ️ Usure accélérée`
- Cuve lait > 80% → `⚠️ Vendez du lait`
- Animal non nourri ≥ 2j → `🔴 Animal en danger`

### Parcours : Composter fumier (F078)

**Où :** `/buildings/compost`
**Ce qu'il saisit :** `quantity_tonnes`
- 3T fumier → 1T compost (14 jours de maturation)
- Alternative à l'épandage brut : compost = meilleur engrais organique
- 1 seul batch à la fois
- Toast : `🌱 Compostage lancé — 5T prêtes dans 14 jours`

---

## Résumé — 116 flows, 8 boucles

| Boucle | Flows | Boutons | Pages | Ticks |
|--------|-------|---------|-------|-------|
| 🏗️ Infrastructure | 7 | 5 | 2 | 0 |
| 🐄 Élevage Soins | 16 | 13 | 1 | 1 |
| 🧬 Élevage Production | 24 | 16 | 3 | 5 |
| 🌾 Cultures | 26 | 24 | 1 | 1 |
| 💰 Économie | 21 | 13 | 5 | 3 |
| 🚜 Matériel | 12 | 9 | 1 | 2 |
| 👥 Social | 7 | 2 | 4 | 1 |
| ℹ️ Info | 3 | 1 | 0 | 2 |
| **TOTAL** | **116** | **83** | **17** | **15** |


---

## Note UX — Page /parcels/:id (23 flows)

Cette page concentre 23 actions. Pour éviter la surcharge UI :

**Organisation en onglets :**
1. **Sol** : analyser (F036), préparer (F037), changer technique
2. **Culture** : semer (F038), rouler (F054), biner (F101), traiter (F040), épandre (F039), irriguer (F058), défaner (F102), récolter (F041)
3. **Paille** : presser (F059), broyer (F060)
4. **Fertilisation** : épandre fumier (F055), épandre lisier (F056), couvert CIPAN (F103)
5. **Gestion** : vendre (F086), louer (F087), planter haie (F088), forer (F057), ETA (F046)
6. **Historique** : rendements (F115)

Seuls les boutons pertinents à l'état actuel de la parcelle sont affichés (ex: pas de "Récolter" si pas de culture mature).
