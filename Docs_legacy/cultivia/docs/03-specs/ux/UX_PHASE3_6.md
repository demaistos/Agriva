# UX — Phases 3 à 6 — Spécifications écran par écran

> Pour chaque action : Prérequis visibles, Écran, Bouton, Contrôles front, API, Contrôles back, Résultat succès, Erreur, Effets de bord.

---

## ÉCONOMIE (Phase 3)

---

### Action 1 — Créer une CAR

**Prérequis visibles :**
- Menu latéral : lien "Coopérative (CAR)" visible uniquement si `player.seniority_days ≥ 90` ET `license_expires > now()` ET `activity_unlock('car')` actif
- Si non éligible : lien grisé avec tooltip "Ancienneté 90j + Licence Pro requis"
- Si déjà membre d'une CAR : lien redirige vers le tableau de bord CAR (Action 2)

**Écran : `/car/create`**
- Titre : "Créer une Coopérative Agricole Régionale"
- Champ `Nom de la CAR` (texte, 3-60 caractères)
- Sélecteur `Nombre d'associés` : radio 3 / 5 / 7
- Région : affichée en lecture seule (= région de la ferme du joueur)
- Section "Inviter les fondateurs" :
  - Champ autocomplete joueur (recherche par pseudo, filtre même région)
  - Liste des joueurs invités avec badge vert ✓ (éligible) ou rouge ✗ (non éligible + raison)
  - Pour chaque fondateur : champ `Capital apporté (€)` (input number, min 1, max 1 000 000)
- Ligne récapitulative : `Capital total : XX € / 1 000 000 € max`
- Barre de progression : nombre de fondateurs invités / nombre requis

**Bouton : "Créer la CAR"**
- Actif si : nombre de fondateurs = sélection (3/5/7) ET tous éligibles ET capital total ≤ 1M€ ET chaque fondateur a confirmé son apport
- Grisé + raison sinon :
  - "Il manque X fondateur(s)"
  - "Capital total dépasse 1 000 000 €"
  - "Joueur X n'est pas éligible (ancienneté insuffisante)"
  - "Joueur X est déjà membre d'une CAR"

**Contrôles front :**
- Nom : 3-60 chars, pas de caractères spéciaux
- Capital par joueur : ≥ 1 €, nombre entier
- Somme capitals ≤ 1 000 000
- Nombre fondateurs exact (3, 5 ou 7)
- Pas de doublon dans la liste des fondateurs
- Le créateur est automatiquement inclus

**API :** `POST /api/car`
```json
{
  "name": "Ma CAR",
  "member_count": 3,
  "founders": [
    { "player_id": 12, "capital": 100000 },
    { "player_id": 34, "capital": 150000 },
    { "player_id": 56, "capital": 50000 }
  ]
}
```

**Contrôles back :**
- `len(founders)` ∈ {3, 5, 7}
- `sum(capital)` ≤ 1 000 000
- Chaque fondateur : `seniority_days ≥ 90`, `license_expires > now()`, `hasUnlock('car')`, ferme dans la même région, pas déjà dans une CAR
- Chaque fondateur : `balance ≥ capital`
- Pas de CAR existante avec le même nom dans la région

**Résultat succès :**
- Toast : "CAR « Ma CAR » créée avec succès !"
- Redirect → `/car/:id` (tableau de bord CAR)
- Solde de chaque fondateur débité
- Silo 100t + Entrepôt 100m² créés automatiquement
- Notification envoyée à chaque fondateur

**Erreurs :**
| Code | Message affiché |
|------|----------------|
| 400 | "Le nombre d'associés doit être 3, 5 ou 7" |
| 400 | "Le capital total dépasse 1 000 000 €" |
| 400 | "Le joueur X n'a pas l'ancienneté requise (90 jours)" |
| 400 | "Le joueur X est déjà membre d'une CAR" |
| 400 | "Tous les fondateurs doivent être dans la même région" |
| 400 | "Solde insuffisant pour le joueur X" |
| 409 | "Une CAR avec ce nom existe déjà dans cette région" |

**Effets de bord :**
- Débit solde de chaque fondateur → écriture `transaction(category='car_capital')`
- Création `coop_member` pour chaque fondateur (`is_founder=true`)
- Création `car_building` (silo 100t + entrepôt 100m²)
- Notification in-app à chaque fondateur

---

### Action 2 — Gérer sa CAR (tableau de bord)

**Prérequis visibles :**
- Accessible uniquement si `player` est membre d'une CAR active
- Menu : "Ma CAR" → lien vers `/car/:id`

**Écran : `/car/:id`**
- **En-tête** : Nom CAR, Région, Statut (Active / En difficulté / Faillite), Solde bancaire CAR
- **Alerte** si solde < 0 : bandeau rouge "Attention : solde négatif. Faillite à -30 000 €"
- **Onglet Membres** :
  - Tableau : Pseudo, Rôle (Fondateur/Membre), Capital apporté, % parts, Date adhésion
  - Bouton "Démissionner" (avec ConfirmModal "Vos parts seront remboursées à 1€/part après 84j")
- **Onglet Stocks** :
  - Tableau par bâtiment : Produit, Qualité, Quantité, Unité, Capacité restante
  - Barre de remplissage visuelle par bâtiment
- **Onglet Bénéfices** :
  - Graphique par saison : Revenus, Dépenses, Profit
  - Tableau `car_season_report` : Saison, Revenus, Dépenses, Profit, Distribué
  - Prochain versement : date du 7 Décembre Cultivia
- **Onglet Votes** :
  - Liste des votes en cours : Sujet, Proposeur, Pour/Contre, Expire dans X jours
  - Pour chaque vote : boutons "Pour" / "Contre" (grisés si déjà voté)
  - Bouton "Proposer un vote" → modale avec sélecteur sujet (prix, contrat, emprunt, dividende, exclusion) + payload
- **Onglet Contrats** :
  - Liste contrats parcelle : Joueur, Culture, Prix/t, Statut, Quantité livrée
- **Onglet Emprunts** :
  - Liste emprunts : Joueur, Montant, Restant, Statut, Échéance
  - Bouton "Rembourser" par emprunt
- **Onglet Parts sociales** :
  - Émissions en cours, parts disponibles, mes parts détenues
  - Bouton "Acheter des parts" / "Revendre" (grisé si < 84j de détention)

**Boutons :**
- "Proposer un vote" : actif si membre
- "Démissionner" : actif si membre, grisé si emprunt en cours ("Remboursez vos emprunts d'abord")
- "Voter Pour/Contre" : actif si vote pending + pas encore voté, grisé sinon

**Contrôles front :**
- Onglets chargés en lazy-loading
- Refresh auto toutes les 60s sur l'onglet Votes
- Montant remboursement : ≤ remaining, ≤ solde joueur

**API :**
- `GET /api/car/:id` → détails CAR
- `GET /api/car/:id/inventory` → stocks
- `GET /api/car/:id/votes` → votes en cours
- `POST /api/car/:id/votes` → proposer vote
- `POST /api/car/:id/votes/:vid/ballot` → voter
- `GET /api/car/:id/reports` → rapports saisonniers
- `GET /api/car/:id/loans` → emprunts
- `POST /api/car/:id/loans/:lid/repay` → rembourser
- `POST /api/car/:id/resign` → démissionner

**Contrôles back :**
- Toutes les routes vérifient que le joueur est membre de la CAR
- Vote : vérifier vote `status='pending'`, pas expiré, joueur n'a pas déjà voté
- Remboursement : `amount ≤ loan.remaining`, `player.balance ≥ amount`
- Démission : pas d'emprunt actif

**Résultat succès :**
- Vote soumis → toast "Vote enregistré", compteurs mis à jour en temps réel
- Remboursement → toast "X € remboursés", solde mis à jour
- Démission → toast "Vous avez quitté la CAR", redirect `/dashboard`

**Erreurs :**
| Code | Message |
|------|---------|
| 403 | "Vous n'êtes pas membre de cette CAR" |
| 400 | "Vous avez déjà voté" |
| 400 | "Ce vote a expiré" |
| 400 | "Montant supérieur au restant dû" |
| 400 | "Solde insuffisant" |
| 400 | "Remboursez vos emprunts avant de démissionner" |

**Effets de bord :**
- Vote passé (majorité) → décision appliquée automatiquement (prix mis à jour, emprunt accordé, etc.)
- Remboursement → débit joueur, crédit CAR, écriture transaction
- Démission → `coop_member.left_at = now()`, parts remboursées à 1€/part après 84j

---

### Action 3 — Passer une annonce de vente

**Prérequis visibles :**
- Menu "Marché" → "Mes annonces" → bouton "Nouvelle annonce"
- Solde affiché en haut : doit être ≥ 800 € (ou 0 € si marchandise entre amis privilégiés)

**Écran : `/market/listings/new`**
- Sélecteur `Type` : Matériel / Marchandise / Animal
- **Si Matériel** :
  - Liste déroulante de mes véhicules (nom, marque, usure%, état)
  - Véhicules déjà en annonce : exclus de la liste
  - Véhicules en panne : affichés avec badge "En panne"
- **Si Marchandise** :
  - Sélecteur produit (depuis inventaire joueur)
  - Champ quantité (max = stock disponible)
  - Sélecteur qualité
- **Si Animal** :
  - Liste de mes animaux vendables (exclut : achetés au négociant, fusionnés, malades, gestantes, en gavage)
  - Animaux non vendables : affichés grisés avec raison
- Champ `Prix demandé (€)` (number, min 1)
- Sélecteur `Portée` : Régionale / Nationale
  - Si Nationale : info "Un transporteur sera nécessaire pour la livraison"
- Champ `Description` (textarea, optionnel, max 500 chars)
- Récapitulatif : "Frais de parution : 800 € — Durée : 7 jours"
  - Si marchandise + ami privilégié détecté : "Frais : 0 €"

**Bouton : "Publier l'annonce (800 €)"**
- Actif si : item sélectionné + prix > 0 + solde ≥ frais
- Grisé :
  - "Sélectionnez un article à vendre"
  - "Solde insuffisant (800 € requis)"
  - "Cet animal ne peut pas être vendu (acheté au négociant)"

**Contrôles front :**
- Prix : entier > 0
- Quantité marchandise : > 0, ≤ stock
- Description : max 500 chars
- Pas de doublon (item déjà en annonce → exclu de la liste)

**API :** `POST /api/listings`
```json
{
  "type": "vehicle",
  "item_id": 42,
  "quantity": 1,
  "price": 25000,
  "scope": "regional",
  "description": "Tracteur 150CV, bon état"
}
```

**Contrôles back :**
- Joueur possède l'item
- Pas d'annonce active sur le même item
- `player.balance ≥ fee` (1500 ou 0)
- Si animal : `bought_from ≠ 'dealer'`, `is_fused = false`, `is_sick = false`, `pregnant_until IS NULL`
- Si marchandise : quantité ≤ stock joueur

**Résultat succès :**
- Toast : "Annonce publiée ! Expire dans 7 jours."
- Redirect → `/market/listings/mine`
- Solde débité de 800 € (ou 0 €)

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Solde insuffisant (800 € requis)" |
| 400 | "Une annonce existe déjà pour cet article" |
| 400 | "Cet animal ne peut pas être vendu (acheté au négociant)" |
| 400 | "Cet animal est malade / en gestation" |
| 400 | "Stock insuffisant" |

**Effets de bord :**
- Débit 800 € → `transaction(category='listing_fee')`
- Création `listing` avec `expires_at = now() + 7 CULTIVIA_DAYS`
- L'item reste en possession du vendeur jusqu'à la vente

---

### Action 4 — Répondre à une annonce (acheter)

**Prérequis visibles :**
- Page "Marché" → liste des annonces filtrables (type, région, produit, prix)
- Chaque annonce : carte avec photo/icône, nom, prix, vendeur, région, expire dans X jours

**Écran : `/market/listings/:id`**
- Détail de l'annonce : type, description, prix, vendeur (pseudo + région), date expiration
- **Si Matériel** : marque, modèle, usure%, pièces cassées, GPS, heures d'utilisation
- **Si Marchandise** : produit, qualité, quantité
- **Si Animal** : espèce, race, âge, poids, génétique (indices visibles)
- Info transport :
  - Même région : "Livraison directe"
  - Autre région : "Transport inter-régional requis" + sélecteur transporteur disponible
- Récapitulatif : Prix article + Frais transport (si applicable) = Total

**Bouton : "Acheter pour X €"**
- Actif si : solde ≥ prix + transport, pas le vendeur, transport dispo si inter-régional
- Grisé :
  - "Solde insuffisant"
  - "Vous ne pouvez pas acheter votre propre annonce"
  - "Transport inter-régional requis — aucun transporteur disponible"
  - Si animal : "Vous n'avez pas de bâtiment adapté" / "Bâtiment plein"

**Contrôles front :**
- Vérifier solde ≥ total avant activation bouton
- Si animal : appel API pour vérifier bâtiment adapté avec capacité

**API :** `POST /api/listings/:id/buy`
```json
{
  "transport_job_id": null
}
```

**Contrôles back :**
- Annonce active (`sold_at IS NULL`, `expires_at > now()`)
- `buyer_id ≠ seller_id`
- `buyer.balance ≥ price`
- Si national + régions différentes : `transport_job` valide
- Si animal : bâtiment adapté avec capacité chez l'acheteur

**Résultat succès :**
- Toast : "Achat confirmé ! Article transféré."
- Redirect → inventaire correspondant (garage / stock / animaux)
- Solde acheteur débité, solde vendeur crédité
- Notification au vendeur : "Votre annonce a été vendue !"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Cette annonce n'est plus disponible" |
| 400 | "Vous ne pouvez pas acheter votre propre annonce" |
| 400 | "Solde insuffisant" |
| 400 | "Transport requis pour un achat inter-régional" |
| 400 | "Pas de bâtiment adapté / Bâtiment plein" |

**Effets de bord :**
- Débit acheteur, crédit vendeur → `transaction` pour les deux
- Transfert propriété item (vehicle.player_id, animal.farm_id, ou inventaire)
- `listing.sold_at = now()`, `listing.buyer_id = buyer`
- Notification vendeur
- Si transport : job de transport créé/lié

---

### Action 5 — Ajouter un ami / ami privilégié

**Prérequis visibles :**
- Menu "Social" → "Amis" ou profil d'un joueur → bouton "Ajouter en ami"

**Écran : `/friends`**
- **Onglet Mes amis** :
  - Tableau : Pseudo, Région, Statut (en ligne/hors ligne), Privilégié (oui/non), Actions
  - Pour chaque ami même région : toggle "Ami privilégié" (switch on/off)
  - Toggle grisé si régions différentes : tooltip "Doit être dans la même région"
- **Onglet Demandes** :
  - Demandes reçues : Pseudo, Date, boutons "Accepter" / "Refuser"
  - Demandes envoyées : Pseudo, Date, Statut (en attente)
- **Barre de recherche** : recherche joueur par pseudo → bouton "Envoyer demande d'ami"

**Boutons :**
- "Envoyer demande" : actif si joueur trouvé + pas déjà ami + pas soi-même
- "Accepter/Refuser" : actif sur demandes reçues
- Toggle "Privilégié" : actif si ami + même région

**Contrôles front :**
- Recherche : min 2 caractères
- Pas de demande à soi-même
- Pas de doublon (déjà ami ou demande en cours)

**API :**
- `POST /api/friends` → envoyer demande `{ "target_player_id": 42 }`
- `POST /api/friends/:id/accept` → accepter
- `POST /api/friends/:id/reject` → refuser
- `PATCH /api/friends/:id/privileged` → `{ "is_privileged": true }`
- `GET /api/friends` → liste amis
- `GET /api/friends/privileged` → amis privilégiés

**Contrôles back :**
- Demande : pas de friendship existante, pas de demande en cours, `target ≠ self`
- Privilégié : friendship existe, les deux joueurs dans la même région

**Résultat succès :**
- Demande envoyée → toast "Demande envoyée à X"
- Acceptée → toast "X est maintenant votre ami", apparaît dans la liste
- Privilégié activé → toast "X est maintenant ami privilégié — commerce direct sans frais"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Vous êtes déjà ami avec ce joueur" |
| 400 | "Une demande est déjà en cours" |
| 400 | "Vous ne pouvez pas vous ajouter vous-même" |
| 400 | "Ami privilégié : vous devez être dans la même région" |

**Effets de bord :**
- Création `friendship` (status pending → accepted)
- `is_privileged = true` → débloque commerce direct sans frais (0 € au lieu de 800 €)
- Notification au joueur cible


---

### Action 6 — Acheter un camion + semi (catalogue transport)

**Prérequis visibles :**
- Menu "Transport" visible si `activity_unlock('transport')` actif
- Sous-menu "Catalogue" → page achat matériel routier
- Info licence : afficher licence active ou "Aucune licence — Demandez-en une d'abord"

**Écran : `/transport/catalog`**
- **Section Licences** :
  - Statut licence actuelle : type (compte propre / compte d'autrui), expire le XX
  - Si aucune licence : bouton "Demander une licence"
    - Modale : radio "Compte propre (transports pour moi)" / "Compte d'autrui (transports pour clients)"
    - Info : "Gratuite, valable 84 jours. Non cumulable."
- **Section Tracteurs routiers** :
  - Catalogue : Modèle, Puissance, Consommation (24-28L HVC/HT), Prix
  - Bouton "Acheter" par modèle
- **Section Semi-remorques** :
  - Filtres par type : Benne / Plateau / Porte-engin / Citerne
  - Catalogue : Type, Capacité, Prix
  - Info citerne : "Transport HVC : licence MD chauffeur requise"
  - Bouton "Acheter" par modèle
- **Mon parc** : liste de mes véhicules routiers actuels

**Bouton "Acheter" :**
- Actif si : solde ≥ prix
- Grisé : "Solde insuffisant (X € requis)"

**Contrôles front :**
- Licence : vérifier qu'aucune licence active avant d'en demander une
- Achat : solde ≥ prix du véhicule

**API :**
- `POST /api/transport/license` → `{ "type": "own_account" }`
- `GET /api/transport/license` → licence active
- `POST /api/equipment/buy` → `{ "vehicle_type_id": 99 }` (achat standard)

**Contrôles back :**
- Licence : pas de licence active existante
- Achat : `player.balance ≥ price`

**Résultat succès :**
- Licence → toast "Licence compte propre obtenue — valable 84 jours"
- Achat → toast "Tracteur routier acheté !", véhicule dans le garage

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Vous avez déjà une licence active (non cumulable)" |
| 400 | "Solde insuffisant" |

**Effets de bord :**
- Licence : `transport_license` créée, `valid_until = now() + 84 CULTIVIA_DAYS`
- Achat : débit solde, création `vehicle` + `transport_vehicle`

---

### Action 7 — Effectuer un transport

**Prérequis visibles :**
- Menu "Transport" → "Mes jobs" → bouton "Nouveau transport"
- Licence active requise (affichée en haut)
- Au moins 1 tracteur routier + 1 semi dans le parc
- Au moins 1 chauffeur embauché

**Écran : `/transport/jobs/new`**
- Sélecteur `Client` :
  - Si licence compte propre : "Moi-même" (seul choix)
  - Si licence compte d'autrui : recherche joueur / sélection depuis annonces
- Sélecteur `Cargo` : type de marchandise à transporter
- Sélecteur `Semi` : liste de mes semis compatibles avec le cargo
  - Benne → récoltes, aliments
  - Plateau → balles, semences, engrais
  - Porte-engin → matériels agricoles
  - Citerne → lait, HVC (badge "Licence MD requise")
- Sélecteur `Chauffeur` : liste de mes chauffeurs avec HT restants aujourd'hui
  - Si citerne HVC : seuls les chauffeurs avec `has_md_license = true` affichés
- Champs `Zone départ` / `Zone arrivée` (autocomplete zones)
- Calcul automatique affiché :
  - Distance : X zones
  - HT nécessaires : Y HT
  - HVC estimé : Z litres (24-28L/PA)
  - Coût estimé (si pour autrui) : montant
- Quantité à charger

**Bouton "Lancer le transport" :**
- Actif si : licence valide + tracteur + semi compatible + chauffeur avec assez de HT + HVC suffisant
- Grisé :
  - "Licence expirée"
  - "Aucun chauffeur disponible (PA insuffisants)"
  - "Stock HVC insuffisant (X L requis)"
  - "Licence MD requise pour transport HVC"

**Contrôles front :**
- Compatibilité semi/cargo
- HT chauffeur ≥ HT nécessaires
- Stock HVC joueur ≥ estimation
- Si compte propre : client = self uniquement

**API :**
- `POST /api/transport/jobs` → créer job
- `POST /api/transport/jobs/:id/execute` → exécuter

**Contrôles back :**
- Licence active + type correct (own_account si self, third_party si autrui)
- Tracteur routier + semi approprié possédés
- Chauffeur : `ht_today ≥ pa_needed`, `has_md_license` si HVC
- HVC en stock ≥ `pa_needed × random(24,28)`
- Cargo disponible à l'origine

**Résultat succès :**
- Toast : "Transport effectué ! X tonnes livrées de Zone A à Zone B"
- HT chauffeur déduits, HVC consommé, cargo transféré
- Si pour autrui : paiement reçu du client

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Licence expirée ou invalide" |
| 400 | "Transport pour autrui nécessite licence compte d'autrui" |
| 400 | "Chauffeur n'a pas assez de HT (X requis, Y disponibles)" |
| 400 | "Stock HVC insuffisant (X L requis)" |
| 400 | "Licence MD requise pour transport de HVC" |
| 400 | "Semi incompatible avec ce type de cargo" |

**Effets de bord :**
- `transport_driver.ht_today -= pa_consumed`
- Inventaire HVC joueur débité
- Cargo transféré (inventaire origine → destination)
- Si pour autrui : `client.balance -= price`, `transporter.balance += price`
- `transport_job.status = 'completed'`
- Usure véhicules (tracteur + semi)

---

### Action 8 — Embaucher un employé

**Prérequis visibles :**
- Menu "Ferme" → "Employés" → bouton "Embaucher"
- Solde affiché : doit être ≥ 1 600 €

**Écran : `/farm/employees/hire`**
- Titre : "Embaucher un employé agricole"
- Info : "Salaire : 1 600 €/mois Cultivia (prélevé chaque lundi). Fournit des HT supplémentaires."
- Liste des candidats disponibles (générés par le système) :
  - Nom, Spécialité, HT/jour, Compétences
- Sélection d'un candidat
- Récapitulatif :
  - Salaire mensuel : 1 600 €
  - HT bonus/jour : +X HT
  - Premier mois payé immédiatement

**Bouton "Embaucher (1 600 €)" :**
- Actif si : solde ≥ 1 600 € + candidat sélectionné
- Grisé : "Solde insuffisant (1 600 € requis)"

**Contrôles front :**
- Solde ≥ 1 600
- Un candidat sélectionné

**API :** `POST /api/farm/:id/employees`
```json
{ "role": "farm_worker" }
```

**Contrôles back :**
- `player.balance ≥ 1750`
- Ferme existe et appartient au joueur

**Résultat succès :**
- Toast : "Employé embauché ! +X HT/jour"
- Redirect → `/farm/employees`
- Solde débité de 1 600 € (premier mois)
- Employé apparaît dans la liste avec date de fin de contrat

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Solde insuffisant (1 600 € requis)" |

**Effets de bord :**
- Débit 1 600 € → `transaction(category='salary')`
- Création `employee(role='farm_worker', salary=1750)`
- `salary_payment` créé (premier mois)
- HT joueur augmentés dès le lendemain
- Tick hebdomadaire (lundi) : prélèvement auto 1 600 €. Si insuffisant → licenciement auto + notification

---

### Action 9 — Commander à une ETA

**Prérequis visibles :**
- Page parcelle → bouton "Faire appel à une ETA" (visible si des ETA existent dans le canton)
- Ou menu "Services" → "ETA disponibles"

**Écran : `/eta/nearby`**
- Liste des ETA dans mon canton (département + adjacents) :
  - Nom joueur ETA, Note moyenne (étoiles), Services proposés, Tarifs/ha
- Filtre par type de travail : Labour, Semis, Récolte, Traitement, Pressage
- Clic sur une ETA → détail :
  - Services avec tarifs
  - Avis clients (dernières notes)
  - Matériel utilisé

**Écran commande : `/eta/:id/order`**
- Sélecteur `Parcelle` : mes parcelles dans le périmètre de l'ETA
- Sélecteur `Type de travail` : parmi les services proposés par l'ETA
- Calcul automatique :
  - Surface : X ha
  - Tarif : Y €/ha
  - Total : Z €
- Info HT : "L'ETA utilise ses propres HT et matériel"

**Bouton "Commander (X €)" :**
- Actif si : parcelle sélectionnée + service sélectionné + solde ≥ total
- Grisé :
  - "Solde insuffisant"
  - "Parcelle hors périmètre de l'ETA"

**Contrôles front :**
- Parcelle dans le périmètre ETA
- Solde ≥ prix total
- Service compatible avec l'état de la parcelle

**API :** `POST /api/eta/:id/jobs`
```json
{
  "parcel_id": 15,
  "service_type": "plowing"
}
```

**Contrôles back :**
- ETA licence active (`license_until > now()`)
- Parcelle dans le périmètre (même département + adjacents)
- `client.balance ≥ price`
- ETA a le matériel et les HT pour effectuer le travail

**Résultat succès :**
- Toast : "Commande envoyée à l'ETA de X"
- Statut : "En attente d'acceptation"
- Quand l'ETA accepte et complète → notification "Travail terminé sur parcelle Y"
- Après complétion : modale de notation (1-5 étoiles)

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Licence ETA expirée" |
| 400 | "Parcelle hors périmètre de l'ETA" |
| 400 | "Solde insuffisant" |

**Effets de bord :**
- Création `eta_job(status='pending')`
- Quand complété : débit client, crédit ETA, HT et HVC consommés côté ETA, usure matériel ETA
- Effet sur parcelle identique à si le propriétaire avait fait le travail
- Notation → mise à jour `eta.rating`

---

### Action 10 — Souscrire une épargne

**Prérequis visibles :**
- Menu "Banque" → "Épargne"
- Solde affiché en haut

**Écran : `/bank/savings`**
- **Mes épargnes actives** (0 à 3) :
  - Pour chaque : Durée, Montant, Taux, Intérêts versés, Prochaine date intérêts, Échéance
  - Bouton "Clôturer" (avec ConfirmModal : "Clôture anticipée = perte totale des intérêts. Confirmez ?")
- **Ouvrir une épargne** :
  - 3 cartes côte à côte :
    - **Courte** : 1 an (84j), 5%/an, max 100 000 €
    - **Moyenne** : 3 ans (252j), 6%/an, max 100 000 €
    - **Longue** : 5 ans (420j), 7%/an, max 100 000 €
  - Carte grisée si déjà une épargne active de cette durée
  - Clic sur une carte → champ montant + simulation :
    - Input `Montant` (1 — 100 000 €)
    - Simulation en temps réel :
      - "Intérêts annuels : X €"
      - "Total à l'échéance : Y €"
      - "Prochains intérêts dans : 84 jours"
    - Bouton "Souscrire"

**Bouton "Souscrire (X €)" :**
- Actif si : montant > 0 ET ≤ 100 000 ET solde ≥ montant ET pas d'épargne active même durée
- Grisé :
  - "Montant max : 100 000 €"
  - "Solde insuffisant"
  - "Vous avez déjà une épargne de cette durée"

**Contrôles front :**
- Montant : 1 ≤ X ≤ 100 000, entier
- Solde ≥ montant
- Pas d'épargne active de même durée (vérif locale)
- Simulation : `intérêts = montant × taux / 100` par an

**API :** `POST /api/savings`
```json
{
  "duration": 1,
  "amount": 80000
}
```

**Contrôles back :**
- `duration` ∈ {1, 3, 5}
- `0 < amount ≤ 100000`
- `player.balance ≥ amount`
- Pas d'épargne active de même durée pour ce joueur

**Résultat succès :**
- Toast : "Épargne ouverte ! 80 000 € placés à 5% pendant 1 an"
- Carte épargne apparaît dans "Mes épargnes actives"
- Solde débité immédiatement

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Durée invalide (1, 3 ou 5 ans)" |
| 400 | "Montant max : 100 000 €" |
| 400 | "Solde insuffisant" |
| 400 | "Vous avez déjà une épargne active de 1 an" |

**Effets de bord :**
- Débit solde → `transaction(category='savings_deposit')`
- Création `savings(status='active', next_interest_at = now() + 84 CULTIVIA_DAYS, matures_at = now() + duration×84)`
- Tick quotidien : si `next_interest_at ≤ now()` → versement intérêts automatique
- À maturité : capital + intérêts versés, `status = 'matured'`
- Clôture anticipée : capital rendu, 0 € d'intérêts, `status = 'closed_early'`


---

## ACTIVITÉS SECONDAIRES (Phase 4)

---

### Action 11 — Ouvrir une concession

**Prérequis visibles :**
- Menu "Activités" → "Concession" visible si `activity_unlock('dealership')` actif ET `seniority_days ≥ 90`
- Si non débloqué : lien grisé "Déblocage requis (~1.80 €) + 90 jours d'ancienneté"

**Écran : `/dealership/create`**
- Titre : "Ouvrir votre concession"
- Info : "Hall de 200 m² offert. Répartissez 100 points de licence sur les constructeurs."
- **Étape 1 — Choix des constructeurs** :
  - Tableau des constructeurs disponibles : Nom, Droit d'entrée annuel, % reversement CA
  - Pour chaque constructeur : slider ou input "Points" (0-100)
  - Compteur en temps réel : "Points utilisés : X / 100"
  - Constructeurs avec 0 points : non représentés
- **Étape 2 — Récapitulatif** :
  - Liste constructeurs sélectionnés avec points
  - Droits d'entrée à payer : somme des `entry_fee × (points / 100)` par constructeur
  - Total à payer aujourd'hui : X €
- **Étape 3 — Embaucher un vendeur** (optionnel, peut être fait après)

**Bouton "Créer la concession (X €)" :**
- Actif si : total points = 100 ET solde ≥ droits d'entrée
- Grisé :
  - "Total des points doit être exactement 100 (actuellement X)"
  - "Solde insuffisant (X € requis pour les droits d'entrée)"

**Contrôles front :**
- Somme points = 100 exactement
- Chaque constructeur : points ≥ 0, entier
- Au moins 1 constructeur avec points > 0
- Solde ≥ somme droits d'entrée

**API :** `POST /api/dealership/create`
```json
{
  "licenses": [
    { "brand_id": 1, "points": 40 },
    { "brand_id": 3, "points": 35 },
    { "brand_id": 7, "points": 25 }
  ]
}
```

**Contrôles back :**
- `activity_unlock('dealership')` actif
- `seniority_days ≥ 90`
- `sum(points) = 100`
- `player.balance ≥ sum(entry_fee × points/100)`
- Joueur n'a pas déjà une concession

**Résultat succès :**
- Toast : "Concession ouverte ! Hall de 200 m²"
- Redirect → `/dealership/me`
- Solde débité des droits d'entrée
- Hall 200 m² créé

**Erreurs :**
| Code | Message |
|------|---------|
| 403 | "Déblocage concession requis" |
| 400 | "Ancienneté insuffisante (90 jours requis)" |
| 400 | "Total des points doit être 100" |
| 400 | "Solde insuffisant" |
| 409 | "Vous avez déjà une concession" |

**Effets de bord :**
- Création `dealership(hall_m2=200)`
- Création `dealership_license` par constructeur sélectionné (`valid_until = now() + 84 CULTIVIA_DAYS`)
- Débit droits d'entrée → `transaction(category='dealership_license')`
- Tick annuel : renouvellement droits d'entrée automatique. Si impayé → licence suspendue

---

### Action 12 — Vendre un matériel neuf en concession

**Prérequis visibles :**
- Page concession → onglet "Stock neuf" → bouton "Commander à l'usine" + liste stock actuel
- Licence constructeur active pour la marque

**Écran : `/dealership/me/stock`**
- **Commander du neuf** :
  - Filtre par constructeur (seuls ceux avec licence active)
  - Catalogue : Modèle, Marque, Prix usine, Prix vente suggéré
  - Champ "Prix de vente" par article (libre, ≥ prix usine)
  - Bouton "Commander" par article
- **Mon stock** :
  - Tableau : Article, Neuf/Occasion, Prix achat, Prix vente, En stock depuis
  - Bouton "Modifier prix" par article
- **Ventes en cours** :
  - Clients potentiels (joueurs de la région qui consultent)
  - Historique ventes : Client, Article, Prix, Marge, Date

**Bouton "Commander (X €)" :**
- Actif si : licence active pour la marque + solde concession ≥ prix usine
- Grisé :
  - "Licence expirée pour ce constructeur"
  - "Solde insuffisant"

**Quand un client achète :**
- Le client voit le catalogue de la concession sur `/dealership/:id/stock`
- Bouton "Acheter (X €)" → actif si solde client ≥ prix + même région
- Client autre région → "Vente régionale uniquement"

**Contrôles front :**
- Prix vente ≥ prix usine
- Licence active pour la marque
- Client : même région que la concession

**API :**
- `POST /api/dealership/:id/buy-new` → commander à l'usine
- `POST /api/dealership/:id/sell` → vente à un client
- `GET /api/dealership/:id/stock` → stock

**Contrôles back :**
- Commande : licence active, `dealership.balance ≥ prix_usine`
- Vente : client même région, `client.balance ≥ sell_price`

**Résultat succès :**
- Commande → toast "Matériel commandé — en stock !", stock mis à jour
- Vente → toast "Vente réalisée ! Marge : X €", notification client

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Licence expirée pour ce constructeur" |
| 400 | "Solde insuffisant" |
| 400 | "Vente régionale uniquement" |

**Effets de bord :**
- Commande : débit concession, création `dealership_stock(is_new=true)`
- Vente : crédit concession (prix vente), débit client, transfert véhicule, `vehicle.bought_from_dealership_id = dealership.id`
- Marge = prix vente - prix usine
- Fin d'année : reversement CA = somme ventes neuves × `rebate_pct` par constructeur

---

### Action 13 — Gérer l'atelier (mécanicien, entretien)

**Prérequis visibles :**
- Page concession → onglet "Atelier"
- Au moins 1 mécanicien embauché pour proposer des services

**Écran : `/dealership/me/workshop`**
- **Mes mécaniciens** :
  - Tableau : Nom, Compétence Usure (1-10), Compétence HT (1-10), Spécialisations (0-3 marques), En formation ?, Âge
  - Bouton "Embaucher mécanicien" → modale (salaire 1 400 €/mois, 25 HT/jour)
  - Bouton "Former" par mécanicien → modale : "Formation 84 jours. Choisir : +1 Usure ou +1 PA"
    - Grisé si déjà en formation ou compétence = 10
  - Bouton "Spécialiser" → sélecteur marque (max 3)
    - Grisé si déjà 3 spécialisations
  - Badge "Retraite dans X jours" si proche de 60 ans
- **Tarif main d'œuvre** :
  - Slider 8-24 €/HT
  - Affiché aux clients
- **Travaux en cours** :
  - Tableau : Client, Véhicule, Type (entretien/réparation), HT, Coût pièces, Main d'œuvre, Statut
- **Demander un entretien** (pour mes propres véhicules ou clients) :
  - Sélecteur véhicule
  - Type : Entretien / Réparation / Installation GPS / Attelage avant
  - Calcul : HT nécessaires, coût pièces (+ majoration âge), main d'œuvre (PA × tarif)
  - Remise 10% si véhicule acheté dans cette concession

**Bouton "Embaucher mécanicien (1 400 €)" :**
- Actif si solde ≥ 1 400
- Grisé : "Solde insuffisant"

**Bouton "Lancer entretien" :**
- Actif si : mécanicien disponible (pas en formation) + HT mécanicien suffisants
- Grisé : "Aucun mécanicien disponible" / "PA insuffisants"

**Contrôles front :**
- Tarif : 8 ≤ X ≤ 24
- Formation : mécanicien pas déjà en formation, compétence < 10
- Spécialisation : < 3 marques

**API :**
- `POST /api/dealership/:id/hire-mechanic`
- `POST /api/mechanic/:id/train` → `{ "skill": "wear" }`
- `POST /api/mechanic/:id/specialize` → `{ "brand": "Verdant" }`
- `POST /api/workshop/maintenance` → `{ "vehicle_id": 42 }`
- `PUT /api/workshop/labor-rate` → `{ "rate": 16 }`

**Contrôles back :**
- Embauche : `player.balance ≥ 1400`
- Formation : mécanicien pas en formation, compétence cible < 10
- Spécialisation : `len(specializations) < 3`
- Entretien : mécanicien dispo, HT suffisants
- Pièces : coût = base × (1 + 0.02 × ancienneté_années_véhicule)
- Remise : `vehicle.bought_from_dealership_id = dealership.id` → -10%

**Résultat succès :**
- Embauche → toast "Mécanicien embauché ! 25 HT/jour"
- Formation → toast "Formation lancée — disponible dans 84 jours"
- Entretien → toast "Entretien terminé — usure réduite"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Solde insuffisant" |
| 400 | "Mécanicien déjà en formation" |
| 400 | "Maximum 3 spécialisations" |
| 400 | "Aucun mécanicien disponible" |
| 400 | "Compétence déjà au maximum (10)" |

**Effets de bord :**
- Embauche : `employee(role='mechanic')` + `mechanic(skill_wear=1, skill_pa=1)`
- Formation : `training_until = now() + 84j`, mécanicien indisponible pendant
- Entretien : usure véhicule réduite, HT mécanicien consommés, pièces facturées
- Retraite (tick) : si âge ≥ 60 ans Cultivia → `retired = true`, notification 1 mois avant

---

### Action 14 — Installer GPS

**Prérequis visibles :**
- Page véhicule → badge "GPS : Non installé" → lien "Installer GPS"
- Ou page concession → onglet "GPS"

**Écran : `/gps/install`**
- **Étape 1 — Acheter un récepteur** (si pas déjà acheté) :
  - Prix : 3 000 € (coop Cultivia)
  - Bouton "Acheter récepteur (3 000 €)"
- **Étape 2 — Installer sur un véhicule** :
  - Sélecteur véhicule (sans GPS)
  - Choix installation :
    - En atelier concessionnaire : 150-300 € (variable)
    - Via Cultivia : 500 € (fixe)
  - Bouton "Installer"
- **Étape 3 — S'abonner à une balise** :
  - Liste des balises GPS dans mon canton : Concessionnaire, Zone, Abonnement/an
  - Bouton "S'abonner (X €/an)"
  - Si aucune balise : "Aucune balise GPS dans votre canton"
- **Récapitulatif bonus GPS** :
  - Semis : -10% HT
  - Engrais : -10% HT
  - Semences : -5% consommation
  - Traitement : -5% HT

**Boutons :**
- "Acheter récepteur" : actif si solde ≥ 3 000 + pas déjà acheté pour ce véhicule
- "Installer" : actif si récepteur acheté + véhicule sélectionné + solde ≥ coût install
- "S'abonner" : actif si solde ≥ abonnement annuel

**Contrôles front :**
- Véhicule sans GPS (`has_gps = false`)
- Solde suffisant à chaque étape

**API :**
- `POST /api/equipment/buy` → récepteur GPS (type spécial)
- `POST /api/workshop/install-gps` → `{ "vehicle_id": 42, "method": "dealer" }`
- `POST /api/gps/subscribe` → `{ "beacon_id": 5 }`

**Contrôles back :**
- Récepteur : `player.balance ≥ 3000`
- Installation : véhicule appartient au joueur, `has_gps = false`
- Abonnement : balise existe dans le canton, `player.balance ≥ subscription_fee`

**Résultat succès :**
- Récepteur → toast "Récepteur GPS acheté"
- Installation → toast "GPS installé sur [véhicule] !", `vehicle.has_gps = true`
- Abonnement → toast "Abonné à la balise GPS — bonus actifs !"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Solde insuffisant" |
| 400 | "Ce véhicule a déjà un GPS" |
| 400 | "Aucune balise GPS dans votre canton" |
| 400 | "Abonnement déjà actif pour cette balise" |

**Effets de bord :**
- `vehicle.has_gps = true`
- `gps_installation` créée
- `gps_subscription(valid_until = now() + 84 CULTIVIA_DAYS)`
- Bonus appliqués automatiquement sur les travaux si GPS actif + abonnement valide + balise dans le canton
- Tick : si abonnement expiré → bonus désactivés (récepteur reste installé)

---

### Action 15 — Créer un CIA

**Prérequis visibles :**
- Menu "Activités" → "CIA" visible si `activity_unlock('cia')` actif ET `seniority_days ≥ 90`
- Si non débloqué : grisé "Déblocage requis (~1.80 €) + 90 jours"

**Écran : `/cia/create`**
- Titre : "Créer un Centre d'Insémination Artificielle"
- Info :
  - Labo de 50 m² (1 m² par lot de doses stocké)
  - Inséminateur embauché automatiquement (25 HT/jour, 1 600 €/mois)
  - Utilitaire requis pour les déplacements
- Vérifications affichées :
  - ✓ / ✗ Déblocage CIA
  - ✓ / ✗ Ancienneté ≥ 90 jours
  - ✓ / ✗ Utilitaire possédé
- Récapitulatif : "Coût mensuel : 1 600 € (salaire inséminateur)"

**Bouton "Créer le CIA" :**
- Actif si : toutes vérifications ✓
- Grisé : "Vous devez posséder un utilitaire" / "Ancienneté insuffisante"

**Sous-écran Contrats : `/cia/contracts`**
- **Proposer un contrat** :
  - Type : Contrat race (tous les mâles d'une race) / Contrat animal (1 mâle spécifique)
  - Sélecteur éleveur (recherche joueur)
  - Si contrat race : sélecteur race
  - Si contrat animal : sélecteur animal (mâles adultes de l'éleveur)
  - Champs : Prix par dose, Répartition CIA/Éleveur (% + %, total = 100%)
- **Mes contrats** : tableau avec statut

**Sous-écran Prélèvements : `/cia/collect`**
- Sélecteur animal (mâles sous contrat)
- Info : "Dernier prélèvement : il y a X jours (cooldown : Y jours)"
- Résultat estimé : "300-400 doses (bovin)"
- Bouton "Prélever (1 HT)"
  - Grisé si cooldown non écoulé

**Sous-écran GenBook : `/genbook`**
- Annuaire régional : Race, Indices génétiques, Prix dose, CIA
- Filtres : espèce, race, indice minimum

**Contrôles front :**
- Contrat : répartition CIA + éleveur = 100%
- Prix dose : dans les bornes de l'espèce
- Prélèvement : cooldown respecté

**API :**
- `POST /api/cia/create`
- `POST /api/cia/contracts` → `{ "type": "breed", "breeder_id": 12, "breed_id": 5, "dose_price": 50, "cia_share_pct": 60 }`
- `POST /api/cia/collect` → `{ "animal_id": 789 }`
- `POST /api/cia/inseminate` → `{ "dose_id": 45, "female_id": 123 }`
- `GET /api/genbook?region_id=1&species=cattle`

**Contrôles back :**
- Création : unlock actif, ancienneté ≥ 90, utilitaire possédé
- Contrat : `cia_share_pct + breeder_share_pct = 100`, prix dans bornes espèce
- Prélèvement : animal mâle adulte, sous contrat, cooldown écoulé
- Insémination : dose disponible (`doses_left > 0`), femelle adulte, pas gestante

**Résultat succès :**
- Création → toast "CIA créé ! Inséminateur embauché."
- Contrat → toast "Contrat proposé à [éleveur]" + notification éleveur
- Prélèvement → toast "X doses prélevées sur [animal]"
- Insémination → toast "Insémination réussie" + débit dose

**Erreurs :**
| Code | Message |
|------|---------|
| 403 | "Déblocage CIA requis" |
| 400 | "Ancienneté insuffisante (90 jours)" |
| 400 | "Utilitaire requis" |
| 400 | "Répartition doit totaliser 100%" |
| 400 | "Cooldown non écoulé (X jours restants)" |
| 400 | "Plus de doses disponibles" |
| 400 | "Femelle déjà gestante" |

**Effets de bord :**
- Création : `cia(lab_m2=50)`, `employee(role='inseminator', salary=1750, pa=25)`
- Contrat accepté : tous les mâles de la race (ou l'animal spécifique) disponibles pour prélèvement
- Prélèvement : `cia_dose` créée avec `doses_left = random(min, max)`, génétique copiée
- Insémination : `doses_left -= 1`, paiement réparti CIA/éleveur, femelle `pregnant_until` mis à jour
- Tick mensuel : salaire inséminateur 1 600 €


---

### Action 16 — Créer une fromagerie

**Prérequis visibles :**
- Menu "Activités" → "Fromagerie"
- Choix artisanale (pas de déblocage) ou industrielle (`activity_unlock('cheese_industrial')`)

**Écran : `/cheese-factory/create`**
- **Choix du type** : 2 cartes
  - **Artisanale** : 20 800 — 100 000 €, 250-1 250 L/jour, vous êtes le fromager, vente sur marchés
  - **Industrielle** : 198 000 — 910 000 €, 2 200-11 000 L/jour, 2-10 fromagers employés, vente grossistes (déblocage requis)
    - Carte grisée si pas débloqué
- **Sélection du modèle** (après choix type) :
  - Artisanale : 5 modèles (250/500/750/1000/1250 L/jour) avec prix
  - Industrielle : 9 modèles (2200→11000 L/jour) avec prix et max employés
  - Tableau comparatif : Modèle, Capacité, Prix, HT max/jour, Max employés
- **Récapitulatif** :
  - Modèle choisi, prix, capacité
  - Charges : 0.09 €/L de lait transformé
  - Artisanale : "Vos compétences de fromager : 240 pts répartis aléatoirement"

**Bouton "Construire (X €)" :**
- Actif si : solde ≥ prix + pas déjà une fromagerie du même type
- Grisé : "Solde insuffisant" / "Vous avez déjà une fromagerie artisanale"

**Contrôles front :**
- Solde ≥ prix du modèle
- Pas de fromagerie existante du même type
- Industrielle : déblocage actif

**API :** `POST /api/cheese-factory/create`
```json
{ "type": "artisan", "model": 3 }
```

**Contrôles back :**
- `player.balance ≥ cost`
- Pas de `cheese_factory` existante du même type pour cette ferme
- Industrielle : `activity_unlock('cheese_industrial')`

**Résultat succès :**
- Toast : "Fromagerie artisanale construite ! Capacité : 750 L/jour"
- Redirect → `/cheese-factory/me`
- Compétences fromager générées (artisanale : 240 pts aléatoires sur 6 compétences)

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Solde insuffisant" |
| 409 | "Vous avez déjà une fromagerie de ce type" |
| 403 | "Déblocage fromagerie industrielle requis" |

**Effets de bord :**
- Création `cheese_factory` + `cheese_maker_skill` (artisanale : employee_id=NULL, 240 pts)
- Débit solde → `transaction(category='building')`
- Artisanale : compétences évoluent avec la pratique (+0.1/fromage)
- Industrielle : embaucher fromagers séparément

---

### Action 17 — Fabriquer du fromage

**Prérequis visibles :**
- Page fromagerie → onglet "Production" → bouton "Fabriquer"
- Lait disponible dans la cuve (même jour = transformable)
- Fromagerie propre (`hygiene_pct` affiché avec jauge)

**Écran : `/cheese-factory/produce`**
- **Sélecteur type de fromage** :
  - Liste des types : Pâte Molle Croûte Fleurie, Pâte Molle Croûte Lavée, Pâte Pressée Cuite, Pâte Pressée Non Cuite, Pâte Persillée, Fromage de Chèvre
  - Pour chaque : source lait requise (vache/chèvre/brebis), durée affinage, DLC
  - Types grisés si contrainte non remplie (région, race, QL)
- **Quantité de lait** : slider ou input (min 1L, max = stock lait ou capacité/jour)
- **Simulation en temps réel** :
  - Fromage produit : X kg (lait × 0.1)
  - Crème produite : Y L (lait × 0.0375)
  - Charges : Z € (lait × 0.09)
  - HT nécessaires : W HT
  - Qualité estimée (4 jauges : Forme, Odeur, Goût, Couleur) basée sur compétences + hygiène + matériel
- **Jauges fromagerie** :
  - Hygiène : barre verte→rouge (100%→0%)
  - Matériel : barre verte→rouge
  - Info : "Nettoyage nécessaire" si hygiène < 50%

**Bouton "Fabriquer (W HT)" :**
- Actif si : lait disponible + HT suffisants + hygiène > 0 + matériel > 0
- Grisé :
  - "Pas de lait disponible"
  - "PA insuffisants"
  - "Fromagerie trop sale — nettoyez d'abord"

**Après fabrication → Affinage :**
- Le fromage apparaît dans "En affinage" avec :
  - Barre de progression : jour X / Y (min→max)
  - Bouton "Sortir d'affinage" (actif si ≥ aging_min_days)
  - Info : "Affinage complet = +20% qualité"

**Contrôles front :**
- Quantité lait : > 0, ≤ min(stock, capacité jour)
- Type fromage : source lait compatible
- HT suffisants

**API :** `POST /api/cheese-factory/produce`
```json
{ "cheese_type_id": 3, "milk_liters": 500 }
```

**Contrôles back :**
- Lait disponible (cuve, même jour, propre exploitation)
- `milk_liters ≤ capacity_l` (capacité journalière)
- HT joueur/fromager suffisants
- `hygiene_pct > 0`, `equipment_pct > 0`
- Source lait compatible avec le type de fromage

**Résultat succès :**
- Toast : "500 L transformés → 50 kg fromage + 18.75 L crème"
- Fromage en affinage (barre de progression)
- Hygiène et matériel dégradés (-2 à -5% hygiène, -1 à -3% matériel)

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Pas de lait disponible aujourd'hui" |
| 400 | "Capacité journalière dépassée (max X L)" |
| 400 | "Ce fromage nécessite du lait de chèvre" |
| 400 | "PA insuffisants" |
| 400 | "Fromagerie trop sale — nettoyez d'abord" |

**Effets de bord :**
- Débit lait de la cuve
- Création `cheese_product(status='production')` → passe en affinage
- Création `dairy_product(type='cream')` (crème)
- Charges 0.09 €/L débitées
- `hygiene_pct -= random(2,5)`, `equipment_pct -= random(1,3)`
- Compétences fromager : +0.1 sur compétence principale (cap 100)
- Affinage : tick quotidien avance le compteur. À `aging_end` → `status='ready'`, DLC démarre
- DLC expirée → fromage supprimé (tick)

---

### Action 18 — Vendre sur un marché

**Prérequis visibles :**
- Menu "Ventes" → "Marchés" visible si utilitaire possédé + kit exposant acheté
- Si pas de kit : "Achetez un kit exposant (2 500 €) pour vendre sur les marchés"

**Écran : `/markets`**
- **Mes emplacements** : marchés où je suis inscrit (redevance payée)
- **Marchés disponibles** dans mon canton :
  - Tableau : Nom, Taille (1-3), Clientèle (1-3), Redevance annuelle, Distance
  - Bouton "S'inscrire" par marché
- **Vendre** (sur un marché inscrit) :
  - Sélecteur marché (parmi mes emplacements)
  - Sélecteur produits à charger dans l'utilitaire :
    - Fromage artisanal (avec qualité, DLC restante)
    - Œufs (calibre)
    - Foie gras (type : non préparé, sous vide, mi-cuit, conserve)
    - Légumes
    - Quantité par produit
  - Fixer prix par produit
  - Info météo du jour : ☀️ Soleil (+30%) / ☁️ Nuageux (0%) / 🌧️ Pluie (-30%)
  - Info fidélisation : "X visites — bonus ×Y"
  - HT nécessaires : 1-4 HT
  - Bouton "Aller au marché (X HT)"

**Bouton "Aller au marché" :**
- Actif si : < 4 marchés aujourd'hui + HT suffisants + produits chargés + utilitaire + kit
- Grisé :
  - "Maximum 4 marchés par jour atteint"
  - "PA insuffisants"
  - "Chargez des produits dans l'utilitaire"
  - "Kit exposant requis (2 500 €)"

**Résultat vente (après clic) :**
- Écran résultat : tableau des ventes réalisées
  - Produit, Quantité vendue / proposée, Prix unitaire, Total, Bonus météo/fidélité
  - Total du marché : X €
  - "Invendus retournés dans votre stock"

**Contrôles front :**
- Marchés aujourd'hui < 4
- HT ≥ coût (1-4)
- Au moins 1 produit chargé
- Prix > 0 par produit

**API :** `POST /api/markets/:id/sell`
```json
{
  "products": [
    { "type": "cheese", "product_id": 12, "quantity": 10, "price": 8.50 },
    { "type": "eggs", "caliber": "L", "quantity": 50, "price": 0.30 }
  ]
}
```

**Contrôles back :**
- Redevance payée pour ce marché
- `market_visit` count today < 4
- HT joueur suffisants
- Utilitaire possédé + kit exposant
- Produits en stock + DLC valide
- Fromage industriel → rejeté ("Artisanal uniquement sur les marchés")

**Résultat succès :**
- Toast : "Marché terminé ! X € de ventes"
- Détail des ventes affiché
- Fidélisation incrémentée

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Maximum 4 marchés par jour" |
| 400 | "Redevance non payée pour ce marché" |
| 400 | "Kit exposant requis" |
| 400 | "PA insuffisants" |
| 400 | "Fromage industriel non autorisé sur les marchés" |
| 400 | "DLC expirée sur le produit X" |

**Effets de bord :**
- Débit stock produits (quantité vendue)
- Crédit solde joueur (total ventes)
- `market_visit` créée (PA dépensés)
- `market_sale` par produit vendu
- `market_stand.loyalty_score += 1` (max 100)
- Invendus retournés en stock
- Tick : si absence > 1 mois → `loyalty_score -= 5`

---

### Action 19 — Vendre à un grossiste

**Prérequis visibles :**
- Page fromagerie industrielle → onglet "Ventes" → bouton "Vendre à un grossiste"
- Ou menu "Ventes" → "Grossistes"
- Uniquement pour fromagerie industrielle

**Écran : `/cheese-factory/sell-wholesale`**
- **Liste grossistes/centrales** disponibles :
  - Nom enseigne, Type (grossiste / centrale d'achat), Produits acceptés, Fidélisation
  - Grossiste : prix négociable
  - Centrale : prix fixe
- **Sélection grossiste** → écran négociation :
  - Produits à vendre : sélection depuis stock fromagerie (fromage, crème, beurre)
  - Quantité par produit
  - **Si grossiste** : proposition de prix (le grossiste contre-propose)
    - Slider prix : min (offre grossiste) → max (votre demande)
    - Bouton "Proposer X €" → réponse immédiate (accepté/refusé basé sur algo)
  - **Si centrale** : prix fixe affiché, pas de négociation
  - Info : "Visite X/4 aujourd'hui" + "Horaires : 06h-22h"

**Bouton "Vendre (X HT)" :**
- Actif si : visites aujourd'hui < 4 + HT suffisants (1-4) + produits sélectionnés + horaire OK
- Grisé :
  - "Maximum 4 visites par jour"
  - "PA insuffisants"
  - "Hors horaires (06h-22h)"

**Contrôles front :**
- Visites < 4 / jour
- HT : 1-4 selon distance
- Produits en stock, DLC valide
- Horaire : 06h-22h (heure Cultivia)

**API :** `POST /api/cheese-factory/sell-wholesale`
```json
{
  "wholesaler_id": 5,
  "products": [
    { "product_id": 22, "quantity": 50, "proposed_price": 12.00 }
  ]
}
```

**Contrôles back :**
- Fromagerie industrielle uniquement
- Visites jour < 4, HT suffisants
- Produits en stock, DLC valide
- Prix négocié dans les bornes acceptables (algo : météo, saison, fidélisation, moral)

**Résultat succès :**
- Toast : "Vente conclue avec [enseigne] ! X € encaissés"
- Détail : produits vendus, prix final, fidélisation mise à jour

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Fromagerie artisanale : vendez sur les marchés" |
| 400 | "Maximum 4 visites par jour" |
| 400 | "PA insuffisants" |
| 400 | "Hors horaires de vente (06h-22h)" |
| 400 | "Prix refusé par le grossiste" |

**Effets de bord :**
- Débit stock fromagerie
- Crédit solde joueur
- `dairy_client.loyalty += 1`
- HT consommés
- Fidélisation influence les prix futurs

---

### Action 20 — Gérer le maraîchage

**Prérequis visibles :**
- Menu "Cultures" → "Maraîchage" visible si le joueur possède au moins 1 parcelle maraîchère ou serre

**Écran : `/garden`**
- **Mes parcelles maraîchères** :
  - Tableau : Parcelle, Surface, Culture en cours, Stade, Prochaine action
  - Bouton "Acheter parcelle maraîchère" → catalogue (petites parcelles, prix/m²)
- **Mes serres** :
  - Tableau : Serre, Surface, Culture, Température, Chauffage (bois déchiqueté)
- **Personnel** :
  - Tableau : Employé, Spécialité, HT/jour
  - Bouton "Embaucher personnel maraîcher"
- **Actions par parcelle** :
  - **Semer** : sélecteur légume (12 types : tomate, salade, carotte, etc.), vérif saison + rotation
  - **Entretenir** : arrosage, désherbage, traitement
  - **Récolter** : quand stade = mûr
  - **Conditionner** : mise en caisse/barquette pour vente

**Flux complet Semer → Récolter → Conditionner :**
1. Sélectionner parcelle → bouton "Semer"
   - Sélecteur légume (filtrés par saison)
   - Info : "Durée croissance : X jours, Récolte : mois Y-Z"
   - Bouton "Semer (X HT)"
2. Pendant croissance : entretien (arrosage si pas de pluie, désherbage)
3. À maturité : bouton "Récolter (X HT)" → quantité récoltée affichée
4. Après récolte : bouton "Conditionner" → choix format (caisse, barquette) → prêt pour vente

**Boutons :**
- "Semer" : actif si parcelle libre + saison correcte + semences en stock + HT
- "Récolter" : actif si culture mûre + HT
- "Conditionner" : actif si récolte non conditionnée

**Contrôles front :**
- Saison de semis respectée
- Rotation respectée
- HT suffisants
- Semences en stock

**API :**
- `POST /api/garden/parcels` → acheter parcelle
- `POST /api/garden/parcels/:id/sow` → `{ "vegetable_type": "tomato" }`
- `POST /api/garden/parcels/:id/water` → arroser
- `POST /api/garden/parcels/:id/harvest` → récolter
- `POST /api/garden/products/:id/package` → conditionner

**Contrôles back :**
- Semis : saison correcte, rotation respectée, semences en stock, HT
- Récolte : culture au stade mûr
- Conditionnement : récolte existante non conditionnée

**Résultat succès :**
- Semis → toast "Tomates semées ! Récolte dans X jours"
- Récolte → toast "X kg de tomates récoltées"
- Conditionnement → toast "Produits conditionnés — prêts pour la vente"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Hors saison de semis pour ce légume" |
| 400 | "Rotation non respectée" |
| 400 | "Semences insuffisantes" |
| 400 | "Culture pas encore mûre" |
| 400 | "PA insuffisants" |

**Effets de bord :**
- Semis : débit semences, création culture maraîchère, HT consommés
- Croissance : tick quotidien avance le stade
- Arrosage : si pas de pluie et pas d'arrosage → rendement réduit
- Récolte : ajout au stock, HT consommés
- Conditionnement : produit prêt pour vente (marché ou grossiste)
- Personnel : HT bonus pour les tâches maraîchères


---

## AVANCÉ (Phases 5 & 6)

---

### Action 21 — Acheter un domaine viticole

**Prérequis visibles :**
- Menu "Activités" → "Viticulture" visible si déblocage annuel actif (~1.80 €)
- Si non débloqué : lien grisé "Déblocage annuel requis"

**Écran : `/vineyard/create`**
- Titre : "Acquérir un domaine viticole"
- Info encadré :
  - "Le domaine viticole est totalement autonome de votre ferme"
  - "Aucun partage de HT, matériels ou bâtiments"
  - "Budget max : 500 000 € virements ferme + 350 000 € emprunts"
- **Choix de la région viticole** :
  - Carte ou liste des régions disponibles sur le serveur
  - Pour chaque : cépages disponibles, climat, prix moyen parcelle
- **Investissement initial** :
  - Champ "Virement depuis la ferme" (max 500 000 € cumulé, irréversible)
  - Info : "⚠️ Ce virement est irréversible"
  - Solde ferme affiché
- Récapitulatif : Région, Virement initial

**Bouton "Créer le domaine (X €)" :**
- Actif si : déblocage actif + région sélectionnée + virement > 0 + solde ferme ≥ virement
- Grisé :
  - "Déblocage annuel requis"
  - "Solde ferme insuffisant"
  - "Virement max : 500 000 €"

**Contrôles front :**
- Virement : 1 ≤ X ≤ 500 000
- Solde ferme ≥ virement
- Région sélectionnée

**API :** `POST /api/vineyard`
```json
{ "region_id": 3, "initial_transfer": 100000 }
```

**Contrôles back :**
- Déblocage viticole actif (`unlocked_until > now()`)
- `initial_transfer ≤ 500000`
- `player.balance ≥ initial_transfer`
- Joueur n'a pas déjà un domaine viticole

**Résultat succès :**
- Toast : "Domaine viticole créé en [région] !"
- Redirect → `/vineyard`
- Solde ferme débité (irréversible), solde domaine crédité

**Erreurs :**
| Code | Message |
|------|---------|
| 403 | "Déblocage viticole requis" |
| 400 | "Virement max 500 000 € cumulé" |
| 400 | "Solde ferme insuffisant" |
| 409 | "Vous avez déjà un domaine viticole" |

**Effets de bord :**
- Création `vineyard(balance = initial_transfer, total_invested = initial_transfer)`
- Débit `player.balance`, crédit `vineyard.balance`
- Virement irréversible (pas de retour domaine → ferme)
- Virements futurs possibles jusqu'au plafond cumulé de 500 000 €

---

### Action 22 — Cultiver la vigne

**Prérequis visibles :**
- Page domaine viticole → onglet "Parcelles"
- Au moins 1 parcelle viticole achetée

**Écran : `/vineyard/parcels`**
- **Mes parcelles** :
  - Tableau : N°, Surface, Cépage, Âge vigne, Croissance%, Jauges (phyto/pluie/soleil), Sol, Exposition, Pente, Pierres
  - Barre de croissance par parcelle
  - Badge "Pierres" si `stones_level > 0` (+10% HT travaux)
- **Acheter parcelle** : bouton → catalogue parcelles disponibles (500-10 000 m²)
- **Travaux disponibles** par parcelle (selon saison et état) :
  - **Sol** : Labour, Désherbage mécanique, Broyage pierres (si pierres)
  - **Vigne** : Taille (hiver), Ébourgeonnage (printemps), Palissage, Effeuillage, Vendange verte
  - **Traitements** : Phytosanitaire (bouillie bordelaise, soufre)
  - **Plantation** : Planter cépage (si parcelle vide)
  - Chaque travail : HT nécessaires, matériel requis (tracteur vigneron ou manuel), saison
  - Travaux grisés si hors saison ou matériel manquant

**Bouton par travail "Effectuer (X HT)" :**
- Actif si : saison correcte + matériel disponible + HT (agent viticole ou joueur) suffisants
- Grisé : "Hors saison" / "Matériel manquant" / "PA insuffisants"

**Contrôles front :**
- Saison du travail respectée
- Matériel requis possédé (dans le domaine viticole)
- HT agent viticole ou joueur ≥ coût
- Pierres : afficher surcoût HT +10%

**API :**
- `POST /api/vineyard/parcels` → acheter
- `POST /api/vineyard/parcels/:id/plant` → `{ "grape_variety_id": 7 }`
- `POST /api/vineyard/parcels/:id/work` → `{ "work_type": "pruning" }`

**Contrôles back :**
- Parcelle appartient au domaine du joueur
- Travail : saison correcte, matériel dans le domaine, HT suffisants
- Plantation : parcelle vide, cépage disponible sur le serveur
- Pierres : HT × 1.10 si `stones_level > 0`

**Résultat succès :**
- Travail → toast "Taille effectuée sur parcelle N°X"
- Plantation → toast "Cépage [nom] planté — 6 000 ceps/ha"
- Jauges mises à jour

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Hors saison pour ce travail" |
| 400 | "Matériel requis non disponible dans le domaine" |
| 400 | "PA insuffisants" |
| 400 | "Parcelle déjà plantée" |

**Effets de bord :**
- HT agent viticole consommés
- Matériel : usure
- Croissance : tick quotidien avance `growth_pct` selon travaux effectués + météo
- Rendement optimal à partir de la 4e saison (`vine_age_days ≥ 336`)
- Broyage pierres : `stones_broyage_until = now() + 252j` (3 saisons), après quoi `stones_level = 0`

---

### Action 23 — Vendanger

**Prérequis visibles :**
- Page parcelle viticole → bouton "Vendanger" visible quand `growth_pct ≥ 100%` (maturité)
- Vendangeurs embauchés (ou agents viticoles disponibles)

**Écran : `/vineyard/parcels/:id/harvest`**
- Info parcelle : Cépage, Surface, Rendement estimé (kg), Qualité estimée
- **Embaucher vendangeurs** (si pas assez de main d'œuvre) :
  - Bouton "Embaucher vendangeurs" → modale :
    - Nombre de vendangeurs
    - Contrat CDD saisonnier
    - Coût : 0.020 HT/kg de raisin
    - "Disponibles 2 jours après embauche"
  - Liste vendangeurs actuels avec HT disponibles
- **Lancer la vendange** :
  - Calcul : surface × rendement/ha = kg estimés
  - HT nécessaires : kg × 0.020 HT/kg (vendangeurs)
  - Destination : sélecteur cuve (chai) avec capacité restante
  - Conversion affichée : "X kg raisin → Y litres de moût (÷1.5)"

**Bouton "Vendanger (X HT)" :**
- Actif si : vendangeurs disponibles (embauchés depuis ≥ 2j) + HT suffisants + cuve avec capacité
- Grisé :
  - "Aucun vendangeur disponible"
  - "Vendangeurs embauchés il y a moins de 2 jours"
  - "Capacité cuve insuffisante"
  - "Raisin pas encore mûr"

**Contrôles front :**
- `growth_pct ≥ 100%`
- Vendangeurs embauchés depuis ≥ 2 jours
- HT vendangeurs ≥ kg × 0.020
- Cuve sélectionnée avec capacité ≥ litres de moût

**API :** `POST /api/vineyard/parcels/:id/harvest`
```json
{ "tank_id": 3 }
```

**Contrôles back :**
- Parcelle mûre (`growth_pct ≥ 100`)
- Vendangeurs disponibles (embauchés ≥ 2j, HT suffisants)
- Cuve dans le chai du domaine, capacité suffisante
- Conversion : `liters = kg / 1.5`

**Résultat succès :**
- Toast : "Vendange terminée ! X kg récoltés → Y litres de moût transférés en cuve"
- Parcelle remise à `growth_pct = 0`, `vine_age_days` continue
- Moût en cuve, prêt pour fermentation

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Raisin pas encore mûr" |
| 400 | "Vendangeurs indisponibles (embauchés il y a moins de 2 jours)" |
| 400 | "PA vendangeurs insuffisants" |
| 400 | "Capacité cuve insuffisante (X L requis, Y L disponibles)" |

**Effets de bord :**
- HT vendangeurs consommés
- `vineyard_tank.current_l += liters`, `content_type = 'must'`
- Parcelle : `growth_pct = 0` (nouveau cycle)
- Qualité moût influencée par : sol, exposition, pente, travaux effectués, météo saison

---

### Action 24 — Vinifier

**Prérequis visibles :**
- Page domaine → onglet "Chai" → cuves avec moût
- Maître de chai embauché (1 seul, compétences Élaboration/Contrôle/Rigueur/Organisation)

**Écran : `/vineyard/wine`**
- **Cuves** :
  - Tableau : Cuve, Contenu (moût/vin), Cépage, Litres, Statut (fermentation/élevage/prêt)
  - Barre de progression fermentation (7j noirs / 3j blancs)
- **Actions séquentielles** :
  1. **Fermentation** : sélectionner cuve avec moût → bouton "Lancer fermentation"
     - Info : "Durée : 7 jours (rouge) / 3 jours (blanc)"
  2. **Décuvage** : après fermentation → bouton "Décuver"
     - Transfert vers cuve d'élevage
  3. **Élevage en cuve** : minimum 42 jours
     - Barre de progression, info "Élevage min 42j — plus long = meilleur (mais risque déclin)"
  4. **Assemblage** (optionnel) : combiner 2-5 cépages
     - Sélecteur cuves (même millésime, même couleur)
     - Proportions (%) → total = 100%
     - Type : Certifié (respect cahier des charges) / Libre
     - HT nécessaires selon complexité + compétences maître de chai
  5. **Mise en fût** (optionnel) : sélectionner fût (cave) → vieillissement
  6. **Mise en bouteille** : bouton "Embouteiller"
     - Nombre de bouteilles = litres / 0.75
     - Étiquette : millésime, cépage/assemblage, domaine

**Boutons par étape :**
- "Lancer fermentation" : actif si cuve contient du moût + maître de chai
- "Décuver" : actif si fermentation terminée
- "Assembler" : actif si 2-5 cuves même millésime/couleur + maître de chai + HT
- "Embouteiller" : actif si élevage ≥ 42j

**Contrôles front :**
- Fermentation : cuve avec moût
- Décuvage : `ferment_end ≤ now()`
- Élevage : ≥ 42 jours
- Assemblage : 2-5 cuves, même couleur, même millésime, proportions = 100%
- Assemblage certifié : respect des % min/max du cahier des charges

**API :**
- `POST /api/vineyard/wine/ferment` → `{ "tank_id": 3 }`
- `POST /api/vineyard/wine/:id/decuve` → `{ "target_tank_id": 5 }`
- `POST /api/vineyard/wine/:id/assemble` → `{ "batches": [{"batch_id":1,"pct":60},{"batch_id":2,"pct":40}], "type": "certified" }`
- `POST /api/vineyard/wine/:id/barrel` → `{ "barrel_id": 2 }`
- `POST /api/vineyard/wine/:id/bottle`

**Contrôles back :**
- Fermentation : cuve contient moût, maître de chai embauché
- Décuvage : `ferment_end ≤ now()`
- Élevage : `aging_start + 42j ≤ now()`
- Assemblage : 2-5 lots, même millésime, même couleur, jamais ré-assemblé, `sum(pct) = 100`
- Certifié : respect `certified_assembly.varieties` (min/max %)
- Fût : fût disponible dans la cave, capacité suffisante

**Résultat succès :**
- Fermentation → toast "Fermentation lancée — 7 jours (rouge)"
- Décuvage → toast "Vin décuvé — élevage en cours"
- Assemblage → toast "Assemblage [certifié/libre] réalisé"
- Embouteillage → toast "X bouteilles produites !"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Fermentation pas encore terminée" |
| 400 | "Élevage minimum 42 jours non atteint" |
| 400 | "Assemblage : même couleur et millésime requis" |
| 400 | "Maximum 5 cépages par assemblage" |
| 400 | "Ce vin a déjà été assemblé" |
| 400 | "Assemblage certifié : proportions hors cahier des charges" |
| 400 | "Pas de maître de chai" |

**Effets de bord :**
- Fermentation : tick quotidien avance le compteur (7j ou 3j)
- Élevage : qualité augmente puis risque de déclin (probabilité croissante, dépend compétences maître)
- Assemblage : `wine_batch.assembly_json` renseigné, HT maître consommés
- Fût : vieillissement améliore qualité (Apparence, Odeur, Goût)
- Embouteillage : `wine_bottle_stock` créé, `wine_batch.status = 'bottled'`
- 3 indices qualité calculés selon : terroir + travaux vigne + compétences maître + élevage + fût

---

### Action 25 — Vendre son vin

**Prérequis visibles :**
- Page domaine → onglet "Ventes" → bouteilles en stock
- 2 canaux : vente Cultivia (directe) ou magasin viticole (vendeur caviste CDI requis)

**Écran : `/vineyard/sales`**
- **Mon stock bouteilles** :
  - Tableau : Vin, Millésime, Assemblage, Qualité (3 indices), Quantité, Récompense concours
  - Bouteilles avec médaille : badge Or/Argent/Bronze
- **Vente Cultivia** (canal 1) :
  - Sélecteur vin + quantité
  - Prix calculé automatiquement (basé sur qualité + médaille)
  - Bouton "Vendre à Cultivia (X €)"
- **Magasin viticole** (canal 2) :
  - Prérequis : bâtiment `shop` construit + vendeur caviste CDI embauché
  - Transférer bouteilles cave → magasin
  - Prix : Cultivia + 2 €/bouteille
  - Ventes automatiques (tick quotidien, influencées par qualité + médaille + fidélisation)
  - Historique ventes magasin

**Bouton "Vendre à Cultivia" :**
- Actif si : bouteilles en stock + quantité > 0
- Grisé : "Aucune bouteille en stock"

**Bouton "Transférer au magasin" :**
- Actif si : magasin construit + vendeur caviste + bouteilles en cave
- Grisé : "Construisez un magasin viticole" / "Embauchez un vendeur caviste CDI"

**Contrôles front :**
- Quantité ≤ stock
- Magasin : bâtiment + vendeur vérifiés

**API :**
- `POST /api/vineyard/wine/:id/sell` → `{ "quantity": 100, "channel": "cultivia" }`
- `POST /api/vineyard/shop/stock` → `{ "wine_batch_id": 5, "quantity": 200 }`

**Contrôles back :**
- Bouteilles en stock (`wine_bottle_stock.quantity ≥ quantity`)
- Magasin : `vineyard_building(type='shop')` existe + `vineyard_employee(role='cellar_seller')` CDI
- Prix Cultivia : calculé selon qualité + médaille concours

**Résultat succès :**
- Vente Cultivia → toast "X bouteilles vendues pour Y €"
- Transfert magasin → toast "X bouteilles transférées au magasin"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Stock insuffisant" |
| 400 | "Magasin viticole requis" |
| 400 | "Vendeur caviste CDI requis" |

**Effets de bord :**
- Vente Cultivia : débit stock, crédit `vineyard.balance`
- Magasin : `wine_bottle_stock.location = 'shop'`, ventes auto par tick
- Prix magasin = prix Cultivia + 2 €/bouteille
- Médaille concours : bonus prix pendant 84 jours (`award_until`)
- Tick : ventes magasin quotidiennes basées sur qualité, médaille, fidélisation client


---

### Action 26 — Gérer une forêt

**Prérequis visibles :**
- Menu "Exploitations" → "Forêts" visible si le joueur possède au moins 1 forêt
- Ou "Acheter une forêt" dans le catalogue foncier

**Écran : `/forests/:id`**
- **Vue d'ensemble** :
  - Carte/grille des 20 stations max
  - Pour chaque station : essence, âge, hauteur, circonférence, état (couleur)
  - Infra : routes (km), pistes (km), dépôt (m²)
  - Pente globale, cours d'eau
- **Détail station** (clic sur une station) :
  - Essence, Âge, Hauteur (m), Circonférence (cm), Diamètre, Nombre d'arbres
  - Sol (type, profondeur, drainage), Végétation, Situation, Faune
  - Souches dégagées : oui/non
  - Dernier travail effectué
- **Travaux disponibles** par station (selon état) :
  - Broyage souche (si souches non dégagées, obligatoire avant replantation)
  - Fertilisation (120 kg/ha, tracteur + épandeur)
  - Labour (tracteur + charrue)
  - Plantation (1 100 plants/ha, manuelle)
  - Protection gibier (si faune présente)
  - Dégagement inter-rang
  - Taille de formation
  - Traitement phyto
  - Élagage (à 2m, 4m, 6m selon âge)
  - Marquage (kit manuel, avant éclaircie)
  - Éclaircie (abatteuse ou manuel)
  - Coupe finale (abatteuse + débusqueur + porteur)
  - Entretien piste/route/dépôt
  - Travaux grisés si prérequis non remplis (ex: "Élagage : arbres trop jeunes")
- **Stock bois** :
  - Tableau : Essence, Volume (m³), Source (éclaircie/coupe finale)
  - Bouton "Vendre à l'usine" → sélecteur usine, prix selon essence et volume

**Bouton par travail "Effectuer (X HT)" :**
- Actif si : matériel requis + HT suffisants + prérequis station remplis
- Grisé avec raison : "Matériel manquant (abatteuse)" / "Souches non dégagées" / "PA insuffisants"
- Info pente : "Pente X% → HT majorés de Y%"

**Contrôles front :**
- Prérequis par travail (souches, âge, marquage avant éclaircie)
- Matériel requis possédé
- HT suffisants (majorés par pente)

**API :**
- `GET /api/forests/:id/stations`
- `POST /api/forests/:id/stations/:num/work` → `{ "work_type": "planting" }`
- `POST /api/forests/:id/wood/sell` → `{ "species": "oak", "volume_m3": 50, "factory_id": 3 }`

**Contrôles back :**
- Station appartient à la forêt du joueur
- Travail : prérequis remplis (souches, âge, marquage)
- Matériel : véhicule requis possédé et fonctionnel
- HT : coût × (1 + pente/100)
- Vente bois : stock suffisant, usine existe

**Résultat succès :**
- Travail → toast "Plantation effectuée — 1 100 plants/ha sur station N°X"
- Vente → toast "50 m³ de chêne vendus pour X €"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Souches non dégagées — broyage requis avant plantation" |
| 400 | "Arbres trop jeunes pour l'élagage" |
| 400 | "Marquage requis avant éclaircie" |
| 400 | "Matériel manquant : abatteuse" |
| 400 | "PA insuffisants" |
| 400 | "Station N°21 : maximum 20 stations" |

**Effets de bord :**
- Plantation : `tree_count = area_ha × 1100`
- Croissance : tick quotidien augmente hauteur/circonférence selon essence + sol + travaux
- Éclaircie : `tree_count` diminue, croissance restants augmente
- Coupe finale : tous arbres abattus → bois en dépôt, souches à dégager
- Volume bois : dépend de tous les travaux effectués (tous faits = max)
- Faune : dégâts sur jeunes plants si pas de protection gibier
- Cours d'eau : bonus croissance, risque enlisement matériel

---

### Action 27 — Produire du foie gras

**Prérequis visibles :**
- Menu "Élevage" → "Foie gras" visible si le joueur possède des oies (Alsace/Landes/Toulouse) ou canards (Barbarie)
- Races non foie gras : lien absent

**Écran : `/foie-gras`**
- **Mes lots en cours** :
  - Tableau : Animal, Race, Phase actuelle, Jour X/7, Prochaine action
  - Phases : Élevage 1 (7j) → Élevage 2 (7j) → Élevage 3 (7j) → Gavage (4j oie / 3j canard)
  - Barre de progression par lot
- **Démarrer un lot** :
  - Sélecteur animal (oies foie gras ou canards Barbarie uniquement)
  - Info : "3 phases d'élevage (21 jours) puis gavage (4j oie / 3j canard)"
  - Bouton "Démarrer le lot"
- **Gavage quotidien** :
  - Pour chaque lot en phase gavage : bouton "Gaver (X HT)"
  - HT : 0.27 HT/oie, 0.0625 HT/canard
  - Info : "Gavage obligatoire chaque jour pendant X jours"
  - Compteur : "Jour X/4 (oie)" ou "Jour X/3 (canard)"
- **Abattage** :
  - Bouton "Abattre (0.25 HT)" quand gavage terminé
  - Résultat : Foie (700g oie / 400g canard) + Carcasse (kg)
- **Transformation** :
  - Sélecteur mode : Non préparé (DLC 3j) / Sous vide (21j) / Mi-cuit (180j) / Conserve (336j)
  - Bouton "Transformer"
- **Vente** :
  - Vente sur marché (Action 18) ou directe
  - Info saisonnalité : "Fin d'année : ~10 kg/marché. Reste de l'année : ~1 kg/marché"

**Bouton "Gaver" :**
- Actif si : lot en phase gavage + HT suffisants + pas déjà gavé aujourd'hui
- Grisé : "Déjà gavé aujourd'hui" / "PA insuffisants" / "Pas encore en phase gavage"

**Bouton "Abattre" :**
- Actif si : gavage terminé (tous les jours effectués)
- Grisé : "Gavage non terminé (jour X/Y)"

**Contrôles front :**
- Animal : race foie gras uniquement (Alsace, Landes, Toulouse, Barbarie)
- Gavage : 1 fois/jour, HT suffisants
- Abattage : après gavage complet

**API :**
- `POST /api/foie-gras/start` → `{ "animal_id": 456 }`
- `POST /api/foie-gras/:id/gavage`
- `POST /api/foie-gras/:id/slaughter`
- `POST /api/foie-gras/:id/process` → `{ "product_type": "semi_conserve" }`

**Contrôles back :**
- Animal : espèce oie/canard, race foie gras
- Gavage : phase = 'gavage', pas gavé aujourd'hui, HT suffisants
- Abattage : `phase_day ≥ gavage_days` (4 oie, 3 canard)
- Transformation : foie disponible (post-abattage)

**Résultat succès :**
- Démarrage → toast "Lot foie gras démarré — Phase élevage 1"
- Gavage → toast "Gavage effectué (jour X/Y)"
- Abattage → toast "Abattage : 700g de foie + X kg de carcasse"
- Transformation → toast "Foie gras mi-cuit — DLC : 180 jours"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Race non éligible au foie gras" |
| 400 | "Déjà gavé aujourd'hui" |
| 400 | "Pas encore en phase gavage (élevage en cours)" |
| 400 | "Gavage non terminé" |
| 400 | "PA insuffisants" |

**Effets de bord :**
- Phases élevage : transition auto par tick (7j chacune)
- Gavage : doit être fait manuellement chaque jour (PA consommés)
- Abattage : animal supprimé, `foie_gras_batch` mis à jour (liver_g, carcass_kg)
- Transformation : DLC calculée selon mode
- DLC expirée → produit perdu (tick)
- Vente marché : saisonnalité forte (fin d'année = 10× plus de ventes)

---

### Action 28 — Gérer la méthanisation

**Prérequis visibles :**
- Menu "Bâtiments" → "Méthanisation" visible si unité construite
- Ou bouton "Construire unité de méthanisation" dans le catalogue bâtiments

**Écran : `/methanizer/:id`**
- **État de l'unité** :
  - Capacité digesteur : X m³
  - Mode : Électricité / HVC (switch)
  - Usure : jauge (0-100%)
  - Statut : Opérationnel / En panne
  - Dernier entretien : date
- **Charger substrat** :
  - Sélecteur substrat :
    - Solides : Fumier, Paille vrac, Céréale immature, Résidus culture
    - Liquides : Lisier
  - Quantité (kg ou L)
  - Capacité restante affichée
  - Info : "Digestion : 7 jours"
  - Bouton "Charger"
- **En digestion** :
  - Tableau : Substrat, Quantité, Chargé le, Prêt le, Barre progression
- **Production** :
  - Historique : Date, Biogaz (m³), Électricité (kWh) ou HVC (L)
  - Totaux cumulés
- **Digestat** :
  - Stock : Liquide (L) — épandable comme lisier, Solide (kg) — épandable comme fumier
  - Bouton "Épandre" → sélecteur parcelle
- **Entretien** :
  - Bouton "Entretenir" → réduit usure, coût HT + €
  - Bouton "Réparer" (si en panne) → coût plus élevé

**Bouton "Charger" :**
- Actif si : substrat en stock + capacité restante + unité pas en panne
- Grisé : "Unité en panne — réparez d'abord" / "Capacité dépassée" / "Stock insuffisant"

**Bouton "Changer mode" (Élec ↔ HVC) :**
- Actif si : pas de digestion en cours
- Grisé : "Digestion en cours — attendez la fin"

**Contrôles front :**
- Quantité ≤ stock substrat
- Quantité ≤ capacité restante digesteur
- Unité pas en panne
- Mode : pas de changement pendant digestion

**API :**
- `POST /api/methanizer/:id/load` → `{ "substrate_type": "manure", "quantity_kg": 500 }`
- `POST /api/methanizer/:id/mode` → `{ "elec_mode": false }`
- `POST /api/methanizer/:id/maintain`
- `POST /api/methanizer/:id/repair`

**Contrôles back :**
- Substrat valide (manure, slurry, straw_bulk, immature_cereal, crop_residue)
- Quantité ≤ capacité restante
- `is_broken = false` pour charger
- Mode : pas de `methanizer_load` non processed

**Résultat succès :**
- Chargement → toast "500 kg de fumier chargés — prêt dans 7 jours"
- Entretien → toast "Entretien effectué — usure réduite"
- Réparation → toast "Unité réparée — opérationnelle"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Unité en panne" |
| 400 | "Capacité digesteur dépassée" |
| 400 | "Stock substrat insuffisant" |
| 400 | "Substrat invalide" |
| 400 | "Changement de mode impossible pendant la digestion" |

**Effets de bord :**
- Chargement : `methanizer_load(digest_end = now() + 7j)`
- Tick quotidien : si `digest_end ≤ now()` → calcul biogaz, digestat
  - Biogaz → Électricité : `biogas × 2 kWh` ou HVC : `biogas × 0.7 L`
  - Digestat : 80% liquide, 20% solide
- Pannes : probabilité croissante avec `wear_pct`, `is_broken = true` → production stoppée
- Entretien : `wear_pct -= X`, coût HT + €
- Digestat épandable comme engrais organique (lisier/fumier)

---

### Action 29 — Voter à la Chambre Agricole

**Prérequis visibles :**
- Menu "Social" → "Chambre Agricole" visible pour tous les joueurs
- Onglet "Élections" : visible pendant les périodes électorales (avril-juin)
- Onglet "Décisions" : visible pour les représentants élus

**Écran : `/cesa`**
- **Représentants de ma région** :
  - 3 sièges : Pseudo, Élu le, Fin mandat, Programme
  - Sièges vacants affichés
- **Élections** (si période électorale) :
  - Phase actuelle : Candidature / Délibération (3j) / Vote (4j) / Clos
  - **Si Candidature** :
    - Bouton "Se porter candidat" → modale : champ "Programme" (textarea, max 1000 chars)
    - Liste des candidats actuels
  - **Si Délibération** :
    - Liste candidats + programmes, pas de vote possible
    - Countdown : "Vote dans X jours"
  - **Si Vote** :
    - Liste candidats avec programme
    - Bouton "Voter pour X" (1 seul vote)
    - Grisé après vote : "Vous avez déjà voté"
  - **Résultats** : classement final, élu affiché
- **Décisions** (représentants uniquement) :
  - **Proposer une décision** :
    - Sélecteur type : Taux taxe, Prix HVC, Salaire gardien, Prix miscanthus, Prix luzerne, Marge coop, Redevance marché, Subvention énergie, Prime BIO, Taxe transport, Taxe foncière
    - Scope : Régional / National
    - Valeur proposée (number)
    - Valeur actuelle affichée
    - Bouton "Proposer"
  - **Votes en cours** :
    - Sujet, Proposeur, Valeur actuelle → proposée, Phase (délibération 3j / vote 4j)
    - Boutons "Pour" / "Contre" (pendant phase vote, représentants uniquement)

**Bouton "Se porter candidat" :**
- Actif si : période candidature + Licence Pro actif + joueur de la région
- Grisé : "Hors période de candidature" / "Licence Pro requis"

**Bouton "Voter" (élection) :**
- Actif si : période vote + pas déjà voté
- Grisé : "Vous avez déjà voté" / "Hors période de vote"

**Bouton "Proposer décision" :**
- Actif si : représentant élu
- Grisé : "Réservé aux représentants Chambre Agricole"

**Contrôles front :**
- Candidature : période correcte, Licence Pro
- Vote : 1 seul vote par élection
- Décision : représentant uniquement, valeur numérique

**API :**
- `POST /api/cesa/elections/:id/candidate` → `{ "program": "Mon programme..." }`
- `POST /api/cesa/elections/:id/vote` → `{ "candidate_id": 7 }`
- `POST /api/cesa/decisions` → `{ "decision_type": "hvc_price", "scope": "regional", "proposed_value": 0.45 }`
- `POST /api/cesa/decisions/:id/vote` → `{ "choice": true }`

**Contrôles back :**
- Candidature : période, Licence Pro actif, joueur de la région
- Vote élection : période vote, pas de doublon (`UNIQUE(election_id, voter_id)`)
- Proposition : joueur est représentant élu
- Vote décision : joueur est représentant, phase vote, pas de doublon

**Résultat succès :**
- Candidature → toast "Candidature enregistrée !"
- Vote → toast "Vote enregistré"
- Proposition → toast "Décision proposée — délibération 3 jours"
- Vote décision → toast "Vote enregistré"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Hors période de candidature" |
| 400 | "Hors période de vote" |
| 400 | "Vous avez déjà voté" |
| 403 | "Réservé aux représentants Chambre Agricole" |
| 400 | "Licence Pro requis pour se porter candidat" |

**Effets de bord :**
- Élection : tick gère les transitions de phase (candidature → délibération → vote → clos)
- Résultat : candidat avec le plus de votes → `chamber_representative`, mandat 84 jours
- Décision passée (majorité) → valeur appliquée au serveur/région (ex: prix HVC mis à jour)
- Décision rejetée → aucun changement

---

### Action 30 — Participer à un concours

**Prérequis visibles :**
- Menu "Social" → "Concours" visible pour tous
- 4 types : Salon Agricole (animaux), GénétiLab (reproducteurs), GénétIvrad (races rares, mai), Le Domaine (vins, septembre)

**Écran : `/contests`**
- **Concours à venir / en cours** :
  - Tableau : Type, Saison, Mois, Phase (Inscription / Jugement / Résultats), Dates
- **Détail concours** (`/contests/:id`) :
  - Description, Catégories, Règlement
  - **Si Inscription ouverte** :
    - **Salon Agricole** : sélecteur animal (par race + catégorie d'âge)
    - **GénétiLab** : sélecteur animal (meilleurs reproducteurs, indices affichés)
    - **GénétIvrad** : sélecteur animal race IVRAD uniquement (mai)
    - **Le Domaine** : sélecteur vin (assemblages certifiés uniquement, septembre)
    - Bouton "Inscrire"
  - **Si Jugement** : "Jugement en cours — résultats bientôt"
  - **Si Résultats** :
    - Classement par catégorie : Rang, Joueur, Animal/Vin, Score, Récompense
    - Mes résultats mis en avant
    - Médailles : 🥇 Or / 🥈 Argent / 🥉 Bronze

**Bouton "Inscrire" :**
- Actif si : période inscription + animal/vin éligible
- Grisé :
  - "Hors période d'inscription"
  - "Cet animal n'est pas éligible (race non IVRAD)" (GénétIvrad)
  - "Assemblage certifié requis" (Le Domaine)
  - "Assemblage libre non autorisé" (Le Domaine)

**Contrôles front :**
- Période inscription ouverte
- Animal/vin éligible selon type de concours
- GénétIvrad : race IVRAD + mois de mai
- Le Domaine : assemblage certifié + mois de septembre

**API :**
- `GET /api/contests` → liste concours
- `POST /api/contests/:id/enter` → `{ "animal_id": 123 }` ou `{ "wine_batch_id": 45 }`
- `GET /api/contests/:id/results`

**Contrôles back :**
- Période inscription (`reg_start ≤ now() ≤ reg_end`)
- Salon : animal appartient au joueur, catégorie d'âge valide
- GénétiLab : animal adulte, né à la ferme, indices génétiques calculés
- GénétIvrad : race IVRAD, mois = mai
- Le Domaine : `wine_batch.assembly_type = 'certified'`, mois = septembre
- Pas de double inscription même animal/vin au même concours

**Résultat succès :**
- Inscription → toast "Animal/Vin inscrit au [concours] !"
- Résultats → notification "Votre [animal/vin] a remporté la médaille d'Or !"

**Erreurs :**
| Code | Message |
|------|---------|
| 400 | "Hors période d'inscription" |
| 400 | "Race non IVRAD (GénétIvrad)" |
| 400 | "Assemblage certifié requis (Le Domaine)" |
| 400 | "Concours réservé aux animaux (pas de vin)" |
| 400 | "Concours réservé aux vins (pas d'animaux)" |
| 400 | "GénétIvrad : uniquement en mai" |
| 400 | "Le Domaine : uniquement en septembre" |
| 400 | "Déjà inscrit à ce concours" |

**Effets de bord :**
- Inscription : `contest_entry` créée
- Jugement (tick) : score calculé automatiquement selon critères (génétique, qualité vin, etc.)
- Résultats : `rank`, `award` (gold/silver/bronze), `prize_eur` attribués
- Récompenses :
  - Animaux : valorisation prix vente (+X%) pendant 84 jours
  - Vins : `wine_batch.award = 'gold'`, `award_until = now() + 84j`, bonus prix vente
  - Primes Chambre Agricole en € pour les lauréats
- Notification à tous les participants avec leurs résultats

---

## Contrats joueur-joueur (PO 2.2)

> Réf: GAMEPLAY_VALIDATION F3.4, PLAN_ACTION_AGILE Sprint 32

### Page : `/contracts`

Accessible via menu "Commerce" → "Mes contrats".

**Onglets** : Actifs | En attente | Terminés

**Tableau par onglet** :

| Colonne | Contenu |
|---------|---------|
| Partenaire | Pseudo + avatar |
| Produit | Nom + icône |
| Quantité/mois | "50 T/mois" |
| Prix/T | "95,00 €" |
| Durée | "3 mois" (barre progression mois écoulés) |
| Livraison | Barre progression mois en cours (X/Y T livrées) |
| Statut | Badge : 🟢 En cours / 🟡 En attente / 🔴 Pénalité / ✅ Terminé |
| Actions | Bouton "Détail" |

### Créer un contrat : `/contracts/new`

Formulaire :
- Sélecteur `Joueur cible` : autocomplete par pseudo (même serveur)
- Sélecteur `Produit` : dropdown des produits existants
- Input `Quantité par mois` (T)
- Input `Prix par tonne` (€)
- Input `Durée` : radio 1 / 3 / 6 / 12 mois
- Récapitulatif temps réel : "Total contrat : {qty × prix × durée} €"
- ⚠️ Encadré pénalité : "Non-livraison : pénalité de 20% du montant mensuel non livré"
- Bouton `Proposer le contrat`

**Bouton** : actif si tous champs remplis + joueur cible ≠ soi-même. Grisé sinon avec tooltip.

**API** : `POST /api/contracts` → `{ target_player_id, product, quantity_per_month, price_per_ton, duration_months }`

### Recevoir un contrat

- Notification in-app : "📋 {pseudo} vous propose un contrat : {produit} {qty}T/mois à {prix}€/T pendant {durée} mois"
- Clic notification → `/contracts/{id}` (page détail)
- Page détail : récapitulatif complet + encadré pénalité
- 3 boutons : `Accepter` (vert) | `Refuser` (rouge) | `Négocier` (orange)
- `Négocier` → modale avec champs prix et quantité modifiables → renvoie contre-proposition

### Suivi livraison

Page détail contrat actif :
- Barre de progression mois en cours : "{livré}T / {attendu}T"
- Historique livraisons : tableau date, quantité, statut
- Alerte si fin de mois proche et livraison < 80% : bandeau orange "Attention : livraison en retard"

### Pénalité

- Affichée clairement avant signature : "Pénalité non-livraison : 20% du montant mensuel non livré"
- Si pénalité appliquée (tick fin de mois) : notification rouge + ligne dans le relevé bancaire
- Badge 🔴 sur le contrat dans la liste