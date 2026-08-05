# UX SPEC — Phase 0 & Phase 1

> Spécification UX exhaustive pour chaque action de gameplay.
> Un développeur frontend doit pouvoir coder chaque écran sans ambiguïté.
> Référence : PHASE0_INFRASTRUCTURE.md, PHASE1_CULTURES.md

---

## PHASE 0 — INFRASTRUCTURE

---

### 1. S'inscrire

**Prérequis visibles** : Aucun. Page publique accessible depuis `/register`.

**Écran** : Formulaire centré, fond illustration agricole flouté.
- Champ `Email` (type email, placeholder "votre@email.com")
- Champ `Mot de passe` (type password, toggle œil, indicateur force : faible/moyen/fort)
- Champ `Confirmer mot de passe`
- Champ `Nom d'agriculteur` (placeholder "fermier42")
- Sélecteur `Serveur` : dropdown listant les serveurs actifs via `GET /api/servers`
  - Chaque option affiche : nom, difficulté (étoiles), joueurs en ligne, places restantes
  - Serveurs pleins grisés avec tooltip "Serveur complet"
- Bouton `Créer mon exploitation` (primaire, pleine largeur)
- Lien "Déjà inscrit ? Se connecter" vers `/login`

**Bouton/Déclencheur** : `Créer mon exploitation`
- Actif : tous les champs remplis, passwords identiques, indicateur force ≥ moyen
- Grisé : champ vide → tooltip "Remplissez tous les champs"
- Grisé : password faible → tooltip "Mot de passe trop faible (min 8 car., 1 maj., 1 min., 1 chiffre)"
- Grisé : passwords différents → message inline rouge sous le champ confirmation

**Au clic — Contrôles frontend** :
- Email : regex `/^[^\s@]+@[^\s@]+\.[^\s@]+$/` → sinon message "Email invalide"
- Password : ≥ 8 chars, 1 majuscule, 1 minuscule, 1 chiffre → sinon message détaillé
- Username : 3-50 chars, `/^[a-zA-Z0-9_-]+$/` → sinon "Lettres, chiffres, _ et - uniquement"
- Serveur sélectionné et actif

**Au clic — Appel API** : `POST /api/auth/register`
```json
{ "email": "...", "password": "...", "username": "...", "server_id": 1 }
```

**Au clic — Contrôles backend** :
- Unicité email → 409
- Unicité username sur ce serveur → 409
- server_id existe et actif → 404
- Validations password/email/username (double-check) → 400

**Résultat succès** :
- Écran de confirmation : icône ✉️, message "Un email de vérification a été envoyé à {email}. Vérifiez votre boîte (et vos spams)."
- Bouton "Renvoyer l'email" (grisé 60s après envoi, countdown visible)
- Lien "Se connecter" (grisé tant que non vérifié, tooltip "Vérifiez d'abord votre email")

**Résultat erreur** :
- 409 email existant → message inline sous le champ email : "Cet email est déjà utilisé"
- 409 username pris → message inline sous le champ username : "Ce nom est déjà pris sur ce serveur"
- 404 serveur → toast erreur "Serveur indisponible, rechargez la page"
- 400 validation → messages inline sous chaque champ concerné

**Effets de bord** : Aucun (pas encore connecté).

---

### 2. Se connecter

**Prérequis visibles** : Compte créé et email vérifié. Page publique `/login`.

**Écran** : Formulaire centré, même style que l'inscription.
- Champ `Email`
- Champ `Mot de passe` (toggle œil)
- Sélecteur `Serveur` : dropdown des serveurs où le joueur a un profil (ou tous si premier login)
- Bouton `Se connecter` (primaire)
- Lien "Pas encore inscrit ? Créer un compte"
- Lien "Mot de passe oublié ?" (Phase future, grisé avec tooltip "Bientôt disponible")

**Bouton/Déclencheur** : `Se connecter`
- Actif : email + password remplis + serveur sélectionné
- Grisé sinon → tooltip "Remplissez tous les champs"

**Au clic — Contrôles frontend** :
- Email non vide, format email basique
- Password non vide
- Serveur sélectionné

**Au clic — Appel API** : `POST /api/auth/login`
```json
{ "email": "...", "password": "...", "server_id": 1 }
```

**Au clic — Contrôles backend** :
- Email + password → 401 "Email ou mot de passe incorrect"
- Email non vérifié → 403
- Pas de profil sur ce serveur → 404

**Résultat succès** :
- Stocker `access_token` en mémoire (pas localStorage), `refresh_token` en httpOnly cookie ou localStorage sécurisé
- Redirection vers `/dashboard`
- Animation de transition (fade)

**Résultat erreur** :
- 401 → message sous le formulaire : "Email ou mot de passe incorrect" (pas de distinction pour sécurité)
- 403 → message : "Votre email n'est pas vérifié" + lien "Renvoyer l'email de vérification"
- 404 → message : "Vous n'avez pas de profil sur ce serveur" + bouton "Rejoindre ce serveur"

**Effets de bord** : Le store global `useAuthStore` est initialisé avec les données player (id, username, balance, ht_today, server_id).

---

### 3. Choisir sa région/département/canton à l'inscription

**Prérequis visibles** : Première connexion après inscription. Le joueur n'a pas encore de ferme. Redirection automatique vers `/setup-farm`.

**Écran** : Wizard en 3 étapes avec stepper horizontal (Région → Département → Zone).

**Étape 1 — Région** :
- Grille de cartes (3 colonnes) listant les régions du serveur (`GET /api/geography/regions`)
- Chaque carte : nom, code, zone météo (icône soleil/nuage/pluie/montagne), nombre de joueurs
- Clic sur une carte → sélectionnée (bordure colorée), bouton "Suivant" activé

**Étape 2 — Département** :
- Liste des départements de la région choisie (`GET /api/geography/regions/:id/departments`)
- Chaque ligne : nom, code, nombre de joueurs installés
- Clic → sélectionné, bouton "Suivant" activé
- Bouton "Retour" pour revenir à l'étape 1

**Étape 3 — Zone** :
- Grille 2×5 des cantons du département (`GET /api/geography/departments/:id/zones`)
- Chaque case : numéro de canton, nombre de fermes installées
- Zones vides mises en avant (badge "Disponible")
- Clic → sélectionnée, bouton "Installer ma ferme" activé

**Bouton/Déclencheur** : `Installer ma ferme`
- Actif : canton sélectionné
- Grisé sinon

**Au clic — Contrôles frontend** : Canton sélectionné (non null).

**Au clic — Appel API** : `POST /api/farms` (ou endpoint dédié)
```json
{ "prefecture_id": 5, "name": "Ma ferme" }
```

**Au clic — Contrôles backend** :
- Joueur n'a pas déjà une ferme sur ce serveur
- Zone existe et appartient au bon serveur

**Résultat succès** :
- Animation confetti / tracteur
- Message "Bienvenue dans votre exploitation !"
- Résumé : région, département, canton, solde initial (100 000€), HT (35)
- Bouton "Accéder au tableau de bord" → `/dashboard`

**Résultat erreur** :
- 409 ferme déjà existante → redirection `/dashboard`

**Effets de bord** : Store `useFarmStore` initialisé. Notification "welcome" créée côté serveur.

---

### 4. Voir son tableau de bord

**Prérequis visibles** : Connecté, ferme créée.

**Écran** : Page `/dashboard`, layout en grille responsive.

**Header permanent (toutes les pages)** :
- Logo Cultivia (lien `/dashboard`)
- Nom du joueur + avatar
- Solde : `100 000,00 €` (vert si > 10k, orange si < 10k, rouge si < 0) — mis à jour en temps réel
- HT : `35.0 / 35.0` avec barre de progression circulaire (vert > 50%, orange 20-50%, rouge < 20%)
- Icône cloche notifications avec badge rouge (nombre non-lues) — clic ouvre le panneau
- Serveur actif (nom + saison en cours)
- Menu navigation : Tableau de bord, Parcelles, Bâtiments, Matériels, Banque, Coopérative

**Corps du dashboard** :

| Zone | Contenu |
|------|---------|
| **Infos du jour** (bandeau haut) | Jour Cultivia (ex: "Mars, Jour 4 — Année 1"), saison (icône + couleur : 🌸 printemps vert, ☀️ été jaune, 🍂 automne orange, ❄️ hiver bleu), prochain tick (countdown "Prochain jour dans 3h 42min") |
| **Bandeau HT épuisés** (Réf: REVIEW_FINALE R2) | Affiché uniquement quand `ht_today = 0`. Bandeau fixe orange en haut de page : "⏳ Vous avez épuisé vos HT du jour. Prochain reset dans {countdown}". Le countdown est calculé à partir de `next_tick_utc` retourné par `GET /api/time`. Le bandeau disparaît automatiquement après le tick (WebSocket `daily_tick` event). |
| **Météo** (carte) | Météo de le canton du joueur : icône niveau (☀️/🌤️/☁️/🌧️/⛈️), label, vent (💨 si oui), grêle (⚠️ si oui). Historique 7 derniers jours en mini-barres |
| **Mes parcelles** (carte) | Résumé : X parcelles, Y ha total. Liste compacte : nom/id, culture en cours (ou ""), barre progression croissance, diode état (🟢 OK, 🟡 attention, 🔴 problème). Bouton "Voir tout" → `/parcels` |
| **Mes bâtiments** (carte) | Résumé : X bâtiments. Liste compacte : type, taille, niveau, usure (barre). Bouton "Voir tout" → `/buildings` |
| **Mes matériels** (carte) | Résumé : X matériels. Alertes : matériels en panne (🔴), usure > 70% (🟡). Bouton "Voir tout" → `/vehicles` |
| **Finances** (carte) | Solde, revenus/dépenses du mois (mini graphe barres), dernier mouvement. Bouton "Relevé complet" → `/bank` |
| **Notifications récentes** (carte) | 5 dernières notifications non lues. Clic → marque comme lue + navigation si applicable |

**Bouton/Déclencheur** : Pas d'action principale. Navigation vers les sous-pages.

**Au clic — Appels API** (au chargement de la page, en parallèle) :
- `GET /api/player/me`
- `GET /api/weather`
- `GET /api/parcels` (résumé)
- `GET /api/buildings` (résumé)
- `GET /api/vehicles` (résumé)
- `GET /api/bank/summary?period_days=7`
- `GET /api/notifications?limit=5&unread_only=true`
- `GET /api/time`

**Résultat succès** : Toutes les cartes se remplissent. Skeleton loaders pendant le chargement.

**Résultat erreur** : Si une API échoue, la carte affiche "Erreur de chargement" + bouton "Réessayer".

**Effets de bord** : WebSocket connecté pour recevoir les notifications en temps réel. Badge cloche mis à jour dynamiquement.

---

### 5. Consulter son relevé bancaire

**Prérequis visibles** : Connecté. Accessible via `/bank` ou carte Finances du dashboard.

**Écran** : Page `/bank`.

**En-tête** :
- Solde actuel en gros : `100 000,00 €` (couleur selon seuil)
- Seuil de faillite rappelé : "Découvert max : -30 000 €"
- Résumé période : revenus (vert ↑), dépenses (rouge ↓), net (vert/rouge)
- Sélecteur période : "Ce mois" / "Cette saison" / "Cette année" / "Tout"

**Tableau des transactions** :
| Colonne | Contenu |
|---------|---------|
| Date | Date formatée (ex: "4 Mars An 1, 14h30") |
| Libellé | Description (ex: "Achat semences blé 150 kg") |
| Catégorie | Badge coloré (achat=rouge, vente=vert, prêt=bleu, énergie=orange) |
| Montant | `+1 500,00 €` (vert) ou `-5 000,00 €` (rouge) |
| Solde après | `115 000,00 €` |

- Pagination : 20 lignes/page, boutons Précédent/Suivant, indicateur "Page 1/5"
- Filtres : dropdown catégorie (tous, achats, ventes, prêts, énergie, salaires), date début/fin
- Tri par date DESC par défaut

**Bouton/Déclencheur** : Filtres et pagination.

**Au clic — Appel API** : `GET /api/bank/statement?page=1&limit=20&category=...&from_date=...&to_date=...`

**Au clic — Contrôles frontend** : Validation dates (from < to).

**Au clic — Contrôles backend** : Vérification que le joueur accède à ses propres transactions.

**Résultat succès** : Tableau rempli, pagination mise à jour.

**Résultat erreur** : Toast "Erreur de chargement du relevé".

**Effets de bord** : Aucun (lecture seule).

---

### 6. Faire une demande de prêt

**Prérequis visibles** : Connecté. Accessible via `/bank/loans` ou bouton "Emprunter" sur la page banque.

**Écran** : Page `/bank/loans`.

**Section haute — Prêts en cours** :
- Liste des prêts actifs : montant initial, restant dû, taux, mensualité, mois restants, barre progression
- Total emprunté / plafond : `47 916 € / 120 000 €` avec barre
- Si aucun prêt : message "Aucun prêt en cours"

**Section basse — Nouveau prêt** :
- Slider ou input `Montant` : 1 000€ à (120 000 - total_en_cours)€, pas de 1 000€
  - Si plafond atteint : slider désactivé, message "Plafond de 120 000€ atteint"
- Sélecteur `Durée` : boutons radio 6 / 12 / 24 / 36 / 48 mois
- **Simulation en temps réel** (recalculée à chaque changement) :
  - Taux annuel affiché : "3%" / "4%" / "5%" selon palier
  - Mensualité estimée : `2 208,33 €/mois`
  - Coût total des intérêts : `3 000,00 €`
  - Total remboursé : `53 000,00 €`
- Bouton `Emprunter` (primaire)

**Bouton/Déclencheur** : `Emprunter`
- Actif : montant > 0, durée sélectionnée, plafond non dépassé
- Grisé : plafond atteint → tooltip "Vous avez atteint le plafond d'emprunt de 120 000€"

**Au clic — Contrôles frontend** :
- Montant > 0 et ≤ max empruntable
- Durée dans [6, 12, 24, 36, 48]
- Confirmation modale : "Vous allez emprunter {montant}€ sur {durée} mois à {taux}%. Mensualité : {mensualité}€. Confirmer ?"

**Au clic — Appel API** : `POST /api/loans`
```json
{ "amount": 50000, "duration_months": 24 }
```

**Au clic — Contrôles backend** :
- Montant > 0 → 400
- Durée valide → 400
- Total prêts + montant ≤ 120 000 → 409

**Résultat succès** :
- Toast vert : "Prêt de {montant}€ accordé ! Votre solde a été crédité."
- Solde header mis à jour (+montant)
- Liste prêts en cours rafraîchie (nouveau prêt apparaît)
- Barre plafond mise à jour
- Slider montant max recalculé

**Résultat erreur** :
- 409 plafond → toast orange "Plafond d'emprunt dépassé"
- 400 → toast rouge avec message d'erreur

**Effets de bord** : Solde header +montant. Transaction "Prêt bancaire" visible dans le relevé.


---

## PHASE 1 — PARCELLES

---

### 7. Acheter une parcelle

**Prérequis visibles** : Connecté, ferme créée. Accessible via `/parcels/buy` ou bouton "Acheter une parcelle" sur la page parcelles.

**Écran** : Page `/parcels/buy`.

**Filtres** (barre horizontale) :
- Type : boutons toggle `Champ` / `Pré`
- Zone : dropdown hiérarchique Région → Département → Zone (pré-rempli avec le canton de la ferme)
- Surface : slider 1 ha à max_parcel_ha (100 ha standard, 200 ha CA/US), pas de 1 ha
  - Affichage : "10 ha" à côté du slider

**Résultat** : Carte récapitulative (pas de liste — la parcelle est générée à l'achat).
- Type sélectionné
- Surface sélectionnée
- Canton sélectionné (avec région, département, zone météo)
- Prix estimé : fourchette `32 000 € — 48 000 €` (qualité 1 à 3, car la qualité est aléatoire)
  - Détail : "Prix/ha : {server.price_per_ha}€ × qualité (0.80 à 1.20)"
- Coût HT : déplacement (X HT) + achat (1 HT) = total
- HT actuels du joueur affichés

**Bouton/Déclencheur** : `Acheter cette parcelle`
- Actif : surface ≥ 1 ha, canton sélectionné, solde ≥ prix max possible, HT ≥ coût total
- Grisé si solde insuffisant → tooltip "Solde insuffisant (besoin max : {prix_max}€, disponible : {solde}€)"
- Grisé si HT insuffisants → tooltip "PA insuffisants (besoin : {pa_total}, disponible : {ht_today})"

**Au clic — Contrôles frontend** :
- Surface multiple de 10 000 m²
- Canton sélectionné
- Solde ≥ prix estimé max (qualité 3)
- HT ≥ déplacement + 1.0
- Modale confirmation : "Acheter un {type} de {ha} ha dans le canton {zone} ? Prix : entre {min}€ et {max}€ selon la qualité du sol (aléatoire). Confirmer ?"

**Au clic — Appel API** : `POST /api/parcels/buy`
```json
{ "prefecture_id": 5, "type": "field", "area_m2": 100000 }
```

**Au clic — Contrôles backend** :
- Surface valide (min 1 ha, max server.max_parcel_ha, multiple de 1 ha) → 400
- Type valide → 400
- Zone existe → 404
- Fonds suffisants (après calcul qualité aléatoire) → 403
- HT suffisants → 403

**Résultat succès** :
- Modale résultat : "Parcelle achetée !" avec détails :
  - Qualité du sol : ⭐ / ⭐⭐ / ⭐⭐⭐ (avec couleur : rouge/orange/vert)
  - Prix réel payé
  - Pierres : niveau affiché
  - Réserves nutritives initiales (jauges colorées)
- Animation : solde header diminue (compteur animé), HT diminuent
- Bouton "Voir ma parcelle" → `/parcels/{id}`
- Bouton "Acheter une autre parcelle"

**Résultat erreur** :
- 403 fonds → toast "Fonds insuffisants"
- 403 HT → toast "PA insuffisants"

**Effets de bord** : Solde header mis à jour. HT mis à jour. Carte "Mes parcelles" du dashboard +1.

---

### 8. Voir la liste de ses parcelles

**Prérequis visibles** : Connecté. Accessible via `/parcels`.

**Écran** : Page `/parcels`.

**En-tête** :
- Résumé : "{X} parcelles — {Y} ha total"
- Bouton "Acheter une parcelle" (primaire) → `/parcels/buy`

**Tableau** (composant DataTable réutilisable) :

| Colonne | Contenu |
|---------|---------|
| # | ID parcelle |
| Type | Icône + label (🌾 Champ / 🌿 Pré) |
| Surface | "10 ha" |
| Qualité sol | ⭐⭐⭐ (1-3 étoiles, couleur) |
| Culture | Nom culture en cours ou "" (gris italique) |
| Croissance | Barre progression % (verte si > 80%, orange 40-80%, rouge < 40%). Vide si jachère |
| État | Diode : 🟢 OK (jachère ou culture saine), 🟡 Attention (nutriments bas, traitement manquant), 🔴 Problème (grêle, sécheresse, nutriments épuisés) |
| Eau | Mini jauge bleue (0-100) |
| Soleil | Mini jauge jaune (0-100) |
| Zone | "Zone 5, Paris (75)" |
| Actions | Bouton "Détail" → `/parcels/{id}` |

- Tri par colonne (clic header)
- Filtre rapide : "Toutes" / "En culture" / "En jachère" / "Problèmes"

**Logique des diodes** :
- 🟢 : jachère OU (culture en cours ET tous nutriments > 20 ET jauges eau/soleil 30-80)
- 🟡 : un nutriment < 20 OU jauge eau/soleil hors 30-80 OU traitement manquant sur culture > 50%
- 🔴 : nutriment à 0 OU grêle récente OU culture mature non récoltée depuis > 7 jours

**Au clic — Appel API** : `GET /api/parcels` (au chargement)

**Résultat succès** : Tableau rempli.

**Résultat erreur** : Message "Aucune parcelle" + bouton "Acheter votre première parcelle".

**Effets de bord** : Aucun (lecture seule).

---

### 9. Consulter le détail d'une parcelle

**Prérequis visibles** : Connecté, propriétaire de la parcelle. Page `/parcels/{id}`.

**Écran** : Layout 2 colonnes.

**Colonne gauche — Infos parcelle** :
- Titre : "Parcelle #{id} — {type} {ha} ha"
- Nom personnalisé (éditable inline, clic sur ✏️)
- Zone : Préfecture + distance ferme (km)
- Qualité sol : ⭐⭐⭐ + label
- Pierres : barre 0-100 (vert si < 20, orange 20-50, rouge > 50)
- Altitude : "{X} m" — info statique
- Inclinaison : "{X}°" — impact rendement si > 5°
- Fatigue sol : jauge 0-100 (vert < 30, orange 30-60, rouge > 60) + tooltip "Monoculture détectée : +15/saison"
- Jachères : compteur "En jachère {X} fois"
- Prix d'achat / valeur revente (50%)
- Toggle ⭐ Suivie / Non suivie
- 📝 Note personnelle (textarea, sauvegarde auto, max 500 car.)

**Section eau / irrigation** :
- Source eau : Ruisseau / Rivière / Source / Canalisation / Aucune
- Retenue collinaire : capacité + barre remplissage (si applicable)
- Irrigation : "Activée ✅" / "Stoppée ❌" + type (enrouleur/pivot)
- Bouton "Activer/Stopper irrigation" (coût HT affiché)

**Section haie** (si parcelle a une haie) :
- Nombre arbustes / densité
- État : Taillée ✅ / À tailler ⚠️
- Bonus culture : "+X% rendement" (si haie entretenue)
- Bouton "Tailler la haie" (coût HT)

**Section animaux au pré** (si type = pré et animaux présents) :
- Liste animaux : Nom | Race | État nourri/abreuvé
- Eau nécessaire vs disponible
- Nourriture nécessaire vs disponible
- Bouton "Rentrer en bâtiment" (coût HT)

**Section nutriments** :
- 6 jauges verticales (N, P, K, Ca, Mg, S)
- **Sans analyse valide** : jauges en 3 paliers (🔴 0-20, 🟠 21-50, 🟢 51-100), pas de valeur numérique, tooltip "Faites une analyse de sol pour voir les valeurs exactes"
- **Avec analyse valide** : valeur numérique affichée sur chaque jauge (ex: "N: 45.3 kg/ha"), date expiration analyse ("Expire dans 12 jours")
- Bouton "Analyser le sol" (50€, 0.5 HT) sous les jauges

**Section météo parcelle** :
- Jauge eau (bleue, 0-100) avec zone optimale 40-70 marquée en vert
- Jauge soleil (jaune, 0-100) avec zone optimale 40-70 marquée en vert
- Météo du jour de le canton : icône + label
- Historique 7 jours en mini-graphe

**Colonne droite — Culture en cours** (si existante) :
- Nom culture + type semence (GP/G/P)
- État : badge (Semé / En croissance / Mature / Récolté)
- Barre de progression : X% avec estimation jours restants
- Traitements : 3 icônes (🍄 Fongicide, 🌿 Herbicide, 🐛 Insecticide) — ✅ si fait, ❌ si pas fait
- Engrais : ✅ / ❌
- Rouleau : ✅ / ❌
- **Boutons d'action contextuels** (voir actions 22-31)
  - Réf: REVIEW_FINALE I2 — Les boutons utilisent le champ `available_actions` de `GET /api/parcels/:id`
  - Chaque bouton affiche le coût HT et HVC estimé (Réf: R12)
  - Bouton grisé si `possible = false`, tooltip = `reason` + `details`
  - Exemple : `Labourer (5.0 HT — 19.2L HVC)` ou grisé `Épandeur à engrais requis`

**Si jachère** :
- Message "Parcelle en jachère"
- Boutons : "Préparer le sol" (si pas préparé), "Semer" (si préparé)
  - Chaque bouton affiche coût HT + HVC estimé depuis `available_actions`

**Boutons toujours visibles (bas de page)** :
- "Appeler ETA Cultivia" → modale choix travail + devis (coût HT + €)
- "Vendre cette parcelle" → ConfirmModal "Vendre pour {valeur_revente} € ?" — Grisé si culture en cours, tooltip "Récoltez d'abord"
- "Annoter" → ouvre le champ note si fermé

**Historique cultures** (bas de page) :
- Tableau : année, culture, rendement, qualité

**Au clic — Appel API** : `GET /api/parcels/{id}` + `GET /api/parcels/{id}/soil` (au chargement)

**Effets de bord** : Aucun (lecture seule).

---

### 10. Faire une analyse de sol

**Prérequis visibles** : Sur la page détail parcelle `/parcels/{id}`. Bouton "Analyser le sol" visible sous les jauges nutriments.

**Bouton/Déclencheur** : `Analyser le sol (50€ — 0.5 HT)`
- Actif : solde ≥ 50€ ET HT ≥ 0.5
- Grisé si solde insuffisant → tooltip "Solde insuffisant (50€ requis)"
- Grisé si HT insuffisants → tooltip "PA insuffisants (0.5 HT requis)"
- Grisé si analyse encore valide → tooltip "Analyse valide jusqu'au {date}" (cooldown 21 jours in-game)

**Au clic — Contrôles frontend** :
- Solde ≥ 50
- HT ≥ 0.5
- Pas d'analyse valide en cours (vérifier `analysis_expires_at > now`)
- Modale confirmation : "Analyser le sol de la parcelle #{id} ? Coût : 50€ + 0.5 PA"

**Au clic — Appel API** : `POST /api/parcels/{id}/analyze-soil`

**Au clic — Contrôles backend** :
- Propriétaire de la parcelle → 403
- Fonds suffisants → 403
- HT suffisants → 403

**Résultat succès** :
- Les 6 jauges nutriments passent du mode "palier" (🔴🟠🟢) au mode "précis" (valeurs numériques) avec animation de transition
- Toast vert : "Analyse terminée — résultats valides 21 jours"
- Solde header -50€ (animé)
- HT -0.5 (animé)
- Date expiration affichée sous les jauges

**Résultat erreur** :
- 403 → toast approprié

**Effets de bord** : Solde -50€. HT -0.5. Transaction "Analyse de sol" dans le relevé bancaire.


---

## PHASE 1 — BÂTIMENTS

---

### 11. Construire un bâtiment

**Prérequis visibles** : Connecté. Page `/buildings/new` ou bouton "Construire" sur `/buildings`.

**Écran** : Catalogue de bâtiments.

**Catalogue** (grille de cartes) :
- 4 types Phase 1 : Hangar, Silo, Entrepôt, Fosse à fumier
- Chaque carte :
  - Icône/illustration du bâtiment
  - Nom + description courte
  - Unité : m² ou tonne
  - Prix unitaire : "15€/m²"
  - Énergie : "0.02 kWh/unité/mois"
- Clic sur une carte → formulaire de configuration

**Formulaire configuration** (après sélection type) :
- Type sélectionné (rappel avec icône)
- Input `Taille` : nombre + unité (ex: "500 m²" ou "100 tonnes")
  - Min : 10, pas de max strict
- **Calcul en temps réel** :
  - Coût construction : `taille × prix_unitaire` → "7 500€"
  - Énergie mensuelle estimée : `taille × energy_kwh_base × 0.08€` → "0.80€/mois"
  - Niveau initial : 1 (affiché)
- HT requis : 2.0 (fixe)
- Bouton `Construire` (primaire)

**Bouton/Déclencheur** : `Construire`
- Actif : taille > 0, solde ≥ coût, HT ≥ 2.0
- Grisé si solde insuffisant → tooltip avec détail
- Grisé si HT insuffisants → tooltip

**Au clic — Contrôles frontend** :
- Taille > 0
- Solde ≥ coût calculé
- HT ≥ 2.0
- Modale confirmation : "Construire un {type} de {taille} {unité} pour {coût}€ ?"

**Au clic — Appel API** : `POST /api/buildings`
```json
{ "type": "hangar", "size": 500 }
```

**Au clic — Contrôles backend** :
- Type valide → 404
- Taille > 0 → 400
- Fonds → 403
- HT → 403

**Résultat succès** :
- Toast vert : "Hangar de 500 m² construit !"
- Note : "Construction instantanée (< 10 bâtiments)" ou "Construction en cours : {délai}" si > 10
- Solde -coût (animé), HT -2.0 (animé)
- Redirection vers `/buildings` avec le nouveau bâtiment en surbrillance

**Résultat erreur** : Toast avec message d'erreur.

**Effets de bord** : Solde, HT mis à jour. Statut abri des matériels recalculé (si hangar construit).

---

### 12. Voir ses bâtiments

**Prérequis visibles** : Connecté. Page `/buildings`.

**Écran** :

**En-tête** :
- Résumé : "{X} bâtiments"
- Bouton "Construire un bâtiment" → `/buildings/new`

**Tableau** :

| Colonne | Contenu |
|---------|---------|
| Type | Icône + nom (🏚️ Hangar, 🏗️ Silo, 📦 Entrepôt, 💩 Fosse) |
| Taille | "500 m²" / "100 T" |
| Niveau | "Niv. 2 / 5" avec mini barre |
| Usure | Barre % (vert < 30%, orange 30-70%, rouge > 70%) |
| Énergie | "0.80€/mois" |
| Contenu | Remplissage : "320 / 500 m²" ou "45 / 100 T" avec barre |
| Actions | Boutons icônes : 🔧 Entretenir, ⬆️ Améliorer, 🗑️ Détruire, 👁️ Détail |

**Au clic — Appel API** : `GET /api/buildings`

**Effets de bord** : Aucun.

---

### 13. Agrandir un bâtiment

**Prérequis visibles** : Page détail bâtiment ou bouton ⬆️ dans la liste. Bâtiment niveau < 5.

**Écran** : Modale d'amélioration.
- Bâtiment actuel : type, taille, niveau actuel
- Niveau suivant : niveau + 1
- Coût : `base_cost × size × 0.50` → affiché
- Bénéfice : "Énergie réduite de {ancien} à {nouveau} kWh/mois"
- HT requis : 1.0

**Bouton/Déclencheur** : `Améliorer au niveau {n+1}`
- Actif : niveau < 5, solde ≥ coût, HT ≥ 1.0
- Grisé si niveau max → tooltip "Niveau maximum atteint (5/5)"
- Grisé si fonds/PA insuffisants → tooltip détaillé

**Au clic — Contrôles frontend** :
- Niveau < 5
- Solde ≥ coût
- HT ≥ 1.0
- Confirmation modale

**Au clic — Appel API** : `POST /api/buildings/{id}/upgrade`

**Au clic — Contrôles backend** :
- Propriétaire → 403
- Niveau < 5 → 409
- Fonds/PA → 403

**Résultat succès** :
- Toast vert : "Bâtiment amélioré au niveau {n+1} !"
- Niveau mis à jour dans la liste
- Énergie mensuelle recalculée
- Solde -coût, HT -1.0

**Résultat erreur** : Toast erreur.

**Effets de bord** : Solde, HT. Facture énergie mensuelle future réduite.

---

### 14. Entretenir un bâtiment

**Prérequis visibles** : Bouton 🔧 dans la liste bâtiments ou page détail.

**Bouton/Déclencheur** : `Entretenir (0.3 HT)`
- Actif : HT ≥ 0.3 ET usure > 0
- Grisé si HT insuffisants → tooltip
- Grisé si usure = 0% → tooltip "Bâtiment en parfait état"

**Au clic — Contrôles frontend** :
- HT ≥ 0.3
- Usure > 0
- Pas de modale (action rapide)

**Au clic — Appel API** : `POST /api/buildings/{id}/maintain`

**Au clic — Contrôles backend** :
- Propriétaire → 403
- HT → 403

**Résultat succès** :
- Toast discret : "Entretien effectué — usure réduite de 5%"
- Barre usure animée (diminue de 5%, min 0%)
- HT -0.3 (animé dans le header)

**Résultat erreur** : Toast erreur.

**Effets de bord** : HT -0.3.

---

### 15. Détruire un bâtiment

**Prérequis visibles** : Bouton 🗑️ dans la liste ou page détail. Bâtiment vide.

**Bouton/Déclencheur** : `Détruire`
- Actif : bâtiment vide (contenu = 0), HT ≥ 1.0
- Grisé si non vide → tooltip "Videz le bâtiment avant de le détruire ({contenu} restant)"
- Grisé si HT insuffisants → tooltip

**Au clic — Contrôles frontend** :
- Bâtiment vide
- HT ≥ 1.0
- **Modale de confirmation ROUGE** (action destructrice) :
  - "⚠️ Détruire le {type} de {taille} {unité} (niveau {n}) ?"
  - "Vous récupérerez {10% du coût total investi}€"
  - Input de confirmation : taper "DÉTRUIRE" pour activer le bouton
  - Bouton "Détruire définitivement" (rouge)

**Au clic — Appel API** : `POST /api/buildings/{id}/destroy`

**Au clic — Contrôles backend** :
- Propriétaire → 403
- Bâtiment vide → 409
- HT → 403

**Résultat succès** :
- Toast orange : "Bâtiment détruit — {recovery}€ récupérés"
- Bâtiment disparaît de la liste (animation fade out)
- Solde +recovery (animé)
- HT -1.0

**Résultat erreur** :
- 409 non vide → toast "Le bâtiment contient encore du stock"

**Effets de bord** : Solde +recovery. HT -1.0. Statut abri matériels recalculé si hangar détruit.


---

## PHASE 1 — MATÉRIELS

---

### 16. Acheter un matériel neuf

**Prérequis visibles** : Connecté. Page `/vehicles/shop` ou bouton "Acheter neuf" sur `/vehicles`.

**Écran** : Catalogue matériels neuf.

**Filtres** (barre horizontale) :
- Famille : boutons toggle (Tracteurs, Travail du sol, Semis, Récolte, Transport, Traitement)
- Tri : prix croissant/décroissant, puissance

**Grille de fiches matériel** :
- Chaque fiche :
  - Illustration/icône
  - Nom complet (ex: "Tracteur 120 CV")
  - Famille + badge motorisé/tracté
  - Puissance : "120 CV" (si motorisé)
  - Largeur travail : "6.0 m" (si applicable)
  - Puissance tracteur min requise : "80 CV min" (si outil tracté)
  - Prix neuf : "55 000€"
  - Pièces : "4 pièces détachées"
  - Bouton `Acheter` ou `Détail`

**Fiche détaillée** (modale ou page) :
- Toutes les infos ci-dessus +
- Consommation HVC : "0.12 L/CV/HT au travail"
- Usure base : "0.10%/jour"
- HT entretien : "1.0 PA"
- HT réparation : "2.0 PA"
- Coût réparation : "5% du prix neuf = 2 750€"
- Coût pièce : "2% du prix neuf = 1 100€"
- **Vérification compatibilité** : si outil tracté, afficher "Vous avez un tracteur de {X} CV" → ✅ compatible ou ❌ puissance insuffisante

**Bouton/Déclencheur** : `Acheter (55 000€)`
- Actif : solde ≥ prix, HT ≥ 1.0
- Grisé si solde insuffisant → tooltip
- Grisé si HT insuffisants → tooltip
- ⚠️ Warning (non bloquant) si outil tracté et pas de tracteur assez puissant → badge orange "Attention : vous n'avez pas de tracteur assez puissant pour utiliser cet outil"

**Au clic — Contrôles frontend** :
- Solde ≥ prix
- HT ≥ 1.0
- Modale confirmation : "Acheter {nom} pour {prix}€ ?"

**Au clic — Appel API** : `POST /api/vehicles/buy`
```json
{ "vehicle_type_id": 2 }
```

**Au clic — Contrôles backend** :
- Type existe → 404
- Fonds → 403
- HT → 403

**Résultat succès** :
- Toast vert : "{nom} acheté !"
- Solde -prix (animé), HT -1.0
- Redirection `/vehicles` avec nouveau matériel en surbrillance
- Statut abri recalculé

**Résultat erreur** : Toast erreur.

**Effets de bord** : Solde, HT. Abri matériels recalculé.

---

### 17. Acheter un matériel d'occasion

**Prérequis visibles** : Connecté. Page `/vehicles/used` (Phase 1 : vente entre joueurs non disponible, section "Bientôt disponible" grisée).

**Écran** : Message "Le marché de l'occasion entre joueurs sera disponible en Phase 3. En attendant, achetez du matériel neuf à la Coopérative."
- Bouton "Voir le catalogue neuf" → `/vehicles/shop`

**Note** : En Phase 1, pas d'occasion. Cette page est un placeholder.

---

### 18. Vendre un matériel

**Prérequis visibles** : Page `/vehicles` ou détail matériel. Matériel non cassé.

**Écran** : Modale de vente.
- Matériel : nom, usure actuelle
- Argus : `prix_neuf × (1 - usure/100) × 0.85` → affiché
- Prix de vente Coop : `argus × 0.60` → affiché en gros
- Comparaison : "Neuf : {prix_neuf}€ → Argus : {argus}€ → Vente Coop : {vente}€"
- HT requis : 0.5

**Bouton/Déclencheur** : `Vendre à la Coopérative ({prix}€)`
- Actif : matériel non cassé, HT ≥ 0.5
- Grisé si cassé → tooltip "Réparez le matériel avant de le vendre"
- Grisé si HT insuffisants → tooltip

**Au clic — Contrôles frontend** :
- Matériel non cassé
- HT ≥ 0.5
- Modale confirmation : "Vendre {nom} à la Coopérative pour {prix}€ ? (Argus : {argus}€)"

**Au clic — Appel API** : `POST /api/vehicles/{id}/sell`

**Au clic — Contrôles backend** :
- Propriétaire → 403
- Non cassé → 409

**Résultat succès** :
- Toast vert : "{nom} vendu pour {prix}€"
- Matériel disparaît de la liste (fade out)
- Solde +prix (animé), HT -0.5

**Résultat erreur** :
- 409 cassé → toast "Matériel en panne — réparez-le d'abord"

**Effets de bord** : Solde +prix. HT -0.5. Abri recalculé.

---

### 19. Entretenir un matériel

**Prérequis visibles** : Bouton 🔧 dans la liste matériels ou page détail.

**Bouton/Déclencheur** : `Entretenir ({pa_maintenance} HT)`
- Actif : HT ≥ pa_maintenance (1.0 par défaut), usure > 0
- Grisé si HT insuffisants → tooltip
- Grisé si usure = 0% → tooltip "Matériel en parfait état"

**Au clic — Contrôles frontend** :
- HT suffisants
- Usure > 0

**Au clic — Appel API** : `POST /api/vehicles/{id}/maintain`

**Résultat succès** :
- Toast : "Entretien effectué — usure réduite de 3%"
- Barre usure animée (-3%, min 0%)
- HT -{pa_maintenance}

**Effets de bord** : HT mis à jour.

---

### 20. Faire le plein de HVC

**Prérequis visibles** : Connecté. Page `/fuel` ou widget HVC sur le dashboard. Nécessite une cuve HVC construite.

**Écran** : Page `/fuel` ou modale.
- Jauge cuve : barre horizontale avec remplissage actuel / capacité max
  - Ex: "1 200 L / 5 000 L" avec barre bleue
- Prix : "0.60€/L"
- Input `Quantité` : slider ou input numérique, max = capacité restante
  - Boutons rapides : "100 L", "500 L", "1 000 L", "Plein" (remplit au max)
- Coût calculé en temps réel : "{quantité} L × 0.60€ = {coût}€"
- HT requis : 1.5 (1.0 trajet Coop + 0.5 transaction)

**Bouton/Déclencheur** : `Acheter ({coût}€)`
- Actif : quantité > 0, solde ≥ coût, HT ≥ 1.5, cuve existante, place disponible
- Grisé si pas de cuve → tooltip "Construisez d'abord une cuve HVC"
- Grisé si cuve pleine → tooltip "Cuve pleine"
- Grisé si solde/PA insuffisants → tooltip

**Au clic — Contrôles frontend** :
- Quantité > 0
- Quantité ≤ capacité restante
- Solde ≥ coût
- HT ≥ 1.5

**Au clic — Appel API** : `POST /api/hvc/buy`
```json
{ "liters": 500 }
```

**Au clic — Contrôles backend** :
- Quantité > 0 → 400
- Cuve existe → 409
- Place disponible → 409
- Fonds → 403
- HT → 403

**Résultat succès** :
- Jauge cuve animée (remplissage progressif)
- Toast vert : "{quantité} L de HVC achetés pour {coût}€"
- Solde -coût (animé), HT -1.5

**Résultat erreur** :
- 409 pas de cuve → toast "Construisez une cuve HVC d'abord"
- 409 cuve pleine → toast "Cuve pleine"

**Effets de bord** : Solde, HT. Stock HVC mis à jour.


---

## PHASE 1 — CYCLE CULTURE COMPLET

---

### 21. Aller à la coopérative

**Prérequis visibles** : Connecté. Page `/coop`. Lien dans la navigation principale.

**Écran** : Page `/coop` — hub commercial.

**Onglets** :
- **Vendre** : liste des produits en stock vendables (voir action 32)
- **Prix du jour** : tableau des cours de toutes les cultures, par qualité, avec facteur saison
- **Calculateur semences** : outil de simulation (voir action 25)

**Section Prix du jour** :

| Culture | Base/T | Q1 (×0.85) | Q2 (×1.00) | Q3 (×1.10) | Saison | Facteur |
|---------|--------|------------|------------|------------|--------|---------|
| Blé | 100€ | 76,50€ | 90,00€ | 99,00€ | 🌾 Récolte | ×0.90 |
| Colza | 220€ | 168,30€ | 198,00€ | 217,80€ | — | ×1.10 |

- Indicateur visuel : flèche ↓ rouge si saison récolte (prix bas), flèche ↑ verte si hors saison (prix haut)

**Au clic — Appel API** : `GET /api/coop/prices` (au chargement)

**Coût PA** : 1.0 HT pour "se rendre" à la Coop (déduit à la première transaction de la session, pas à chaque visite de page).

**Effets de bord** : Aucun sur simple consultation.

---

### 22. Déchaumer une parcelle

**Prérequis visibles** : Page détail parcelle `/parcels/{id}`. Parcelle en jachère (pas de culture active). Bouton visible dans la section "Actions".

**Bouton/Déclencheur** : `Déchaumer`
- Sous-texte : "{pa_cost} HT — {hvc_cost}L HVC — Tracteur + Cultivateur requis" (Réf: REVIEW_FINALE R12)
- Actif : jachère, tracteur dispo (non cassé), cultivateur dispo (non cassé), HT suffisants, HVC suffisant
- Grisé si culture en cours → tooltip "La parcelle a déjà une culture"
- Grisé si pas de tracteur → tooltip "Vous n'avez pas de tracteur fonctionnel"
- Grisé si pas de cultivateur → tooltip "Vous n'avez pas de cultivateur fonctionnel"
- Grisé si HT insuffisants → tooltip "PA insuffisants ({besoin} requis, {dispo} disponibles)"
- Grisé si HVC insuffisant → tooltip "HVC insuffisant ({hvc_cost}L requis, {stock}L en cuve)"

**Au clic — Contrôles frontend** :
- Parcelle en jachère
- Tracteur + cultivateur disponibles et non cassés
- HT ≥ (déplacement + ha × 0.5)
- HVC ≥ consommation estimée
- Pas de modale (action courante)

**Au clic — Appel API** : `POST /api/parcels/{id}/prepare` (type: "stubble")

**Au clic — Contrôles backend** :
- Propriétaire, pas de culture active, matériel dispo, HT, HVC

**Résultat succès** :
- Toast : "Déchaumage terminé — {pa} HT, {hvc}L HVC"
- Parcelle passe visuellement en état "préparé" (icône terre retournée)
- HT et HVC mis à jour

**Effets de bord** : HT, HVC, usure matériel augmente légèrement.

---

### 23. Labourer

**Prérequis visibles** : Page détail parcelle. Parcelle en jachère ou déchaumée. Bouton "Labourer".

**Bouton/Déclencheur** : `Labourer`
- Sous-texte : "{pa_cost} HT — {hvc_cost}L HVC — Tracteur + Charrue requis" (Réf: REVIEW_FINALE R12)
- Mêmes conditions que déchaumage mais avec charrue au lieu de cultivateur
- Vérification puissance tracteur ≥ min_tractor_cv de la charrue
- Grisé si tracteur trop faible → tooltip "Tracteur trop faible ({cv_tracteur} CV, {cv_requis} CV requis pour cette charrue)"

**Au clic — Contrôles frontend** :
- Tracteur dispo + puissance suffisante pour la charrue
- Charrue dispo et non cassée
- HT ≥ déplacement + ha × 0.5
- HVC suffisant

**Au clic — Appel API** : `POST /api/parcels/{id}/prepare` (type: "plow")

**Résultat succès** :
- Toast : "Labour terminé"
- État parcelle mis à jour visuellement
- HT, HVC déduits

**Effets de bord** : HT, HVC, usure matériel.

---

### 24. Préparer la terre

**Prérequis visibles** : Parcelle labourée. Bouton "Préparer (herse rotative)".

**Bouton/Déclencheur** : `Préparer la terre`
- Sous-texte : "{pa_cost} HT — {hvc_cost}L HVC — Tracteur + Herse rotative requis" (Réf: REVIEW_FINALE R12)
- Mêmes logiques de vérification matériel/PA/HVC

**Au clic — Appel API** : `POST /api/parcels/{id}/prepare` (type: "harrow")

**Résultat succès** :
- Toast : "Terre préparée — prête pour le semis"
- Parcelle passe en état "PREPARED" visuellement (terre fine, icône semoir)
- Bouton "Semer" apparaît / devient actif

**Effets de bord** : HT, HVC, usure.

---

### 25. Semer

**Prérequis visibles** : Parcelle en état PREPARED. Bouton "Semer" actif.

**Écran** : Modale de semis.

**Formulaire** :
- **Culture** : dropdown des 8 cultures MVP, chaque option affiche :
  - Nom + icône
  - Période de semis : "Oct-Nov" (mois autorisés)
  - ✅ ou ❌ selon le mois actuel (cultures hors saison grisées avec tooltip "Semis possible en {mois}")
  - ⚠️ si rotation non respectée → tooltip "Rotation : {n} ans requis, dernière culture il y a {x} ans"
- **Type semence** : boutons radio GP / G / P
  - Chaque option : facteur rendement + facteur prix
  - Ex: "GP — Rendement ×1.00 — Prix ×1.00" / "P — Rendement ×0.90 — Prix ×0.70"
- **Récapitulatif en temps réel** :
  - Surface : {ha} ha
  - Quantité semences : {kg} kg
  - Coût semences : {coût}€
  - HT requis : déplacement + {ha × 0.8} HT
  - HVC estimé : {litres} L
  - Matériel utilisé : Tracteur {nom} + Herse {nom} + Semoir {nom}

**Bouton/Déclencheur** : `Semer`
- Actif : culture sélectionnée ET en saison ET rotation OK ET semoir+herse+tracteur dispos ET HT ET HVC ET solde ≥ coût semences
- Grisé avec tooltip contextuel pour chaque condition non remplie

**Au clic — Contrôles frontend** :
- Culture en saison (mois actuel ∈ sow_months)
- Rotation respectée
- Matériel complet et fonctionnel
- HT suffisants
- HVC suffisant
- Solde ≥ coût semences
- Modale confirmation : "Semer {culture} ({seed_type}) sur {ha} ha ? Coût : {coût}€ + {pa} PA"

**Au clic — Appel API** : `POST /api/parcels/{id}/sow`
```json
{ "crop_type": "wheat", "seed_type": "GP" }
```

**Au clic — Contrôles backend** :
- Parcelle préparée, pas de culture active → 409
- Culture en saison → 400
- Rotation → 409
- Matériel → 409
- Fonds, HT, HVC → 403

**Résultat succès** :
- Toast vert : "Blé semé sur {ha} ha !"
- Parcelle passe en état "SOWN" — icône graines, barre progression à 0%
- Solde -coût semences, HT déduits, HVC déduit
- Section "Culture en cours" apparaît sur la page détail parcelle
- Dans la liste parcelles : colonne Culture = "Blé", Croissance = 0%

**Résultat erreur** :
- 400 hors saison → toast "Le blé se sème en octobre-novembre"
- 409 rotation → toast "Rotation non respectée — attendez encore {n} an(s)"
- 409 matériel → toast "Matériel manquant : {détail}"

**Effets de bord** : Solde, HT, HVC. État parcelle. Historique cultures mis à jour.

---

### 26. Épandre engrais

**Prérequis visibles** : Parcelle avec culture en cours (état SOWN ou GROWING). Culture non encore fertilisée. Bouton "Épandre engrais" dans la section actions.

**Écran** : Modale d'épandage.

**Formulaire** :
- **Type d'engrais** : dropdown des engrais disponibles (`GET /api/input-types?category=fertilizer`)
  - Chaque option : nom, composition (N-P-K), prix/kg, dose/ha
  - Ex: "NPK 15-15-15 — 0.45€/kg — 300 kg/ha"
- **Récapitulatif** :
  - Surface : {ha} ha
  - Quantité : {dose × ha} kg
  - Coût : {quantité × prix}€
  - Apports nutritifs : N +{x}, P +{y}, K +{z} kg/ha (barres vertes)
  - HT : déplacement + {ha × 0.3}
  - Matériel : Tracteur + Épandeur à engrais

**Bouton/Déclencheur** : `Épandre`
- Actif : engrais sélectionné, culture non fertilisée, matériel dispo, HT, HVC, solde
- Grisé si déjà fertilisé → tooltip "Culture déjà fertilisée (1 passage max)"
- Grisé si pas d'épandeur → tooltip "Épandeur à engrais requis"

**Au clic — Appel API** : `POST /api/parcels/{id}/fertilize`
```json
{ "input_type": "npk_15_15_15" }
```

**Résultat succès** :
- Toast : "Engrais épandu — N +{x}, P +{y}, K +{z} kg/ha"
- Icône engrais ✅ sur la fiche culture
- Jauges nutriments de la parcelle mises à jour (animation montée)
- Solde, HT, HVC déduits

**Effets de bord** : Solde, HT, HVC. Réserves sol augmentées. Flag `fertilized` sur la culture.

---

### 27. Traiter (fongicide/herbicide/insecticide)

**Prérequis visibles** : Culture en cours (SOWN/GROWING). Traitement de ce type pas encore appliqué. Bouton "Traiter" avec sous-menu.

**Écran** : Modale de traitement.

**Formulaire** :
- **Type** : boutons radio Fongicide 🍄 / Herbicide 🌿 / Insecticide 🐛
  - Chaque type : ✅ si déjà fait (grisé), ❌ si pas fait (sélectionnable)
- **Détails** (après sélection) :
  - Nom produit, prix/L, dose/ha
  - Quantité : {dose × ha} L
  - Coût : {quantité × prix}€
  - HT : déplacement + {ha × 0.25}
  - Matériel : Tracteur + Pulvérisateur

**Bouton/Déclencheur** : `Traiter`
- Actif : type sélectionné et pas encore appliqué, pulvérisateur dispo, HT, HVC, solde
- Grisé si déjà traité pour ce type → tooltip "Fongicide déjà appliqué"
- Grisé si pas de pulvérisateur → tooltip "Pulvérisateur requis"

**Au clic — Appel API** : `POST /api/parcels/{id}/treat`
```json
{ "treatment": "herbicide" }
```

**Résultat succès** :
- Toast : "Traitement herbicide appliqué"
- Icône correspondante passe de ❌ à ✅ sur la fiche culture
- Solde, HT, HVC déduits

**Effets de bord** : Solde, HT, HVC. Flag traitement sur la culture.

---

### 28. Passer le rouleau

**Prérequis visibles** : Culture céréale en croissance, entre 10% et 50% de progression. Bouton "Passer le rouleau".

**Bouton/Déclencheur** : `Passer le rouleau (+3-5% rendement)`
- Actif : culture céréale, état GROWING, growth 10-50%, pas déjà roulé, tracteur + rouleau dispos, HT, HVC
- Grisé si pas céréale → tooltip "Le rouleau n'est efficace que sur les céréales"
- Grisé si growth < 10% → tooltip "Trop tôt — attendez 10% de croissance"
- Grisé si growth > 50% → tooltip "Trop tard — le rouleau doit être passé avant 50%"
- Grisé si déjà roulé → tooltip "Rouleau déjà passé"

**Au clic — Contrôles frontend** :
- Toutes les conditions ci-dessus
- Pas de modale (action simple)

**Au clic — Appel API** : `POST /api/parcels/{id}/roll`

**Résultat succès** :
- Toast : "Rouleau passé — bonus rendement +3-5%"
- Icône rouleau ✅ sur la fiche culture
- HT, HVC déduits

**Effets de bord** : HT, HVC. Flag `rolled` sur la culture.

---

### 29. Surveiller la pousse

**Prérequis visibles** : Culture en cours. Pas d'action — c'est un écran de consultation.

**Écran** : Section "Culture en cours" sur `/parcels/{id}` (voir action 9).

**Éléments affichés** :
- **Barre de progression** : 0-100%, couleur progressive (rouge → orange → jaune → vert)
  - Pourcentage exact affiché
  - Estimation : "Mature dans ~{jours} jours" (basé sur growth_days et weather_factor moyen)
- **Jauges eau/soleil** : avec zone optimale 40-70 marquée
  - Si hors zone optimale : badge ⚠️ "Eau trop basse — rendement impacté"
- **Diodes traitement** : 3 icônes avec état ✅/❌
  - Tooltip sur ❌ : "Non traité — malus rendement -5%"
- **Engrais** : ✅/❌ avec tooltip
- **Rouleau** : ✅/❌ avec tooltip (si céréale)
- **Facteurs de rendement estimés** (section dépliable) :
  - Sol : ×{factor} (vert/orange/rouge)
  - Nutriments : ×{factor}
  - Météo : ×{factor}
  - Rendement estimé : "~{x} T/ha" (fourchette)

**Mise à jour** : Les données changent à chaque tick (quotidien). Le joueur recharge la page ou les données sont rafraîchies via WebSocket.

**Effets de bord** : Aucun (lecture seule).

---

### 30. Récolter

**Prérequis visibles** : Culture en état MATURE (growth ≥ 100%). Bouton "Récolter" proéminent (vert, gros).

**Bouton/Déclencheur** : `🌾 Récolter`
- Actif : culture mature, moissonneuse dispo (ou machine adaptée), benne dispo, silo avec capacité, HT, HVC
- Sous-texte : "{pa_cost} HT — {hvc_cost}L HVC" (Réf: REVIEW_FINALE R12 — coût HVC affiché)
- Grisé si pas mature → tooltip "Culture à {x}% — pas encore mature"
- Grisé si pas de moissonneuse → tooltip "Moissonneuse-batteuse requise"
- Grisé si pas de benne → tooltip "Benne requise pour le transport"
- Grisé si silo plein → tooltip "Silo plein — agrandissez ou vendez du stock" (Réf: REVIEW_FINALE R13)
- Grisé si HVC insuffisant → tooltip "HVC insuffisant ({hvc_cost}L requis, {stock}L en cuve)" (Réf: R12)

**Au clic — Contrôles frontend** :
- Culture mature
- Moissonneuse + benne disponibles et non cassées
- Silo avec capacité suffisante (estimation)
- HT ≥ déplacement + ha × 0.6
- HVC suffisant
- Modale confirmation : "Récolter {culture} sur {ha} ha ?"

**Au clic — Appel API** : `POST /api/parcels/{id}/harvest`

**Résultat succès** :
- **Écran de résultat détaillé** (modale ou page) :
  - Rendement total : "{x} tonnes" (gros, vert)
  - Rendement/ha : "{y} T/ha"
  - Qualité : ⭐/⭐⭐/⭐⭐⭐
  - **Détail des facteurs** (tableau) :
    | Facteur | Valeur | Impact |
    |---------|--------|--------|
    | Base régionale | 7.7 T/ha | — |
    | Sol | ×0.85 | 🟡 |
    | Nutriments | ×0.92 | 🟡 |
    | Engrais | ×1.10 | 🟢 |
    | Traitements | ×1.00 | 🟢 |
    | Météo | ×0.88 | 🟡 |
    | Rouleau | ×1.04 | 🟢 |
    | Pierres | ×0.99 | 🟢 |
    | Semence | ×1.00 | 🟢 |
  - Stocké dans : "Silo #{id}"
  - Paille disponible : "80 T au sol — pressez-la !" (si applicable, avec bouton "Presser")
- HT, HVC déduits
- Parcelle repasse en jachère visuellement

**Résultat erreur** :
- 409 pas mature → toast
- 409 matériel → toast détaillé

**Effets de bord** : HT, HVC. Stock silo +récolte. Nutriments sol consommés. Parcelle → jachère. Paille au sol (si céréale). Usure moissonneuse.

---

### 31. Presser la paille

**Prérequis visibles** : Paille au sol sur la parcelle (après récolte céréale). Badge "Paille au sol : {x} T" visible sur la parcelle.

**Écran** : Modale de pressage.

**Formulaire** :
- **Type de balle** : boutons radio
  - Carrée 500 kg — pour gros stockage
  - Carrée 250 kg — standard
  - Ronde 300 kg — classique
- **Récapitulatif** :
  - Paille disponible : {x} T
  - Nombre de balles : {nb}
  - HT : déplacement + {ha × 0.4}
  - Matériel : Tracteur + Presse

**Bouton/Déclencheur** : `Presser`
- Actif : paille au sol, tracteur + presse dispos, HT, HVC
- Grisé si pas de paille → tooltip "Pas de paille au sol"
- Grisé si pas de presse → tooltip "Presse à balles requise"

**Au clic — Appel API** : `POST /api/parcels/{id}/press-straw`
```json
{ "bale_type": "square_500" }
```

**Résultat succès** :
- Toast : "{nb} balles pressées et stockées"
- Badge paille au sol disparaît
- Stock balles mis à jour

**Alternative** : Bouton "Broyer la paille" (restitue nutriments au sol au lieu de presser)
- Appel : `POST /api/parcels/{id}/mulch-straw`
- Résultat : jauges nutriments augmentent, paille disparaît

**Effets de bord** : HT, HVC. Stock balles ou nutriments sol.

---

### 32. Vendre la récolte à la coop

**Prérequis visibles** : Stock en silo > 0. Page `/coop` onglet "Vendre" ou bouton depuis l'inventaire.

**Écran** : Formulaire de vente.

**Liste des produits vendables** :
- Tableau des stocks en silo, par culture et qualité :
  | Produit | Qualité | Stock | Prix/T actuel | Saison |
  |---------|---------|-------|---------------|--------|
  | Blé | ⭐⭐ | 50 T | 90,00€ | 🌾 ×0.90 |
  | Blé | ⭐⭐⭐ | 18 T | 99,00€ | 🌾 ×0.90 |

**Formulaire** (après sélection produit) :
- Produit + qualité sélectionnés
- Input `Quantité` : slider 0 à stock max, en kg (affichage en T)
  - Boutons rapides : "25%", "50%", "100%"
- Prix unitaire affiché : "{prix}€/T"
- Total calculé : "{quantité_T} × {prix} = {total}€"
- HT requis : 1.0 (trajet) + 0.5 (transaction) = 1.5 HT
- Conseil : si saison récolte → badge orange "Prix bas en saison de récolte (×0.90). Stocker pour vendre hors saison (×1.10) ?"

**Bouton/Déclencheur** : `Vendre ({total}€)`
- Actif : quantité > 0, stock suffisant, HT ≥ 1.5
- Grisé si stock = 0 → tooltip "Rien à vendre"
- Grisé si HT insuffisants → tooltip

**Au clic — Contrôles frontend** :
- Quantité > 0 et ≤ stock
- HT ≥ 1.5
- Modale confirmation : "Vendre {quantité} T de {produit} Q{qualité} à {prix}€/T pour {total}€ ?"

**Au clic — Appel API** : `POST /api/coop/sell`
```json
{ "product": "wheat", "quality": 2, "quantity_kg": 50000 }
```

**Résultat succès** :
- Toast vert : "{total}€ crédités — {quantité} T de {produit} vendues"
- Solde +total (animé)
- Stock silo diminue
- HT -1.5

**Résultat erreur** :
- 409 stock insuffisant → toast "Stock insuffisant"

**Effets de bord** : Solde +total. HT -1.5. Stock silo mis à jour. Transaction dans le relevé.


---

## PHASE 1 — FUMIER

---

### 33. Mettre la litière

**Prérequis visibles** : Bâtiment d'élevage avec animaux (Phase 2). En Phase 1, cette action est un placeholder — le fumier est acheté directement à la Coop.

**Note Phase 1** : La litière sera documentée en UX Phase 2 (élevage). En Phase 1, le fumier s'achète à la Coop (voir action 34 ci-dessous adaptée).

---

### 34. Acheter et stocker du fumier

**Prérequis visibles** : Fosse à fumier construite. Page `/coop` ou `/inventory/manure`.

**Écran** : Modale d'achat fumier.
- Jauge fosse : "{stock} T / {capacité} T" avec barre
- Prix : "15€/T"
- Input `Quantité` : slider, max = capacité restante, en tonnes
  - Boutons rapides : "10 T", "50 T", "100 T", "Max"
- Coût : "{quantité} × 15€ = {total}€"
- HT : 1.5 (trajet Coop + transaction)

**Bouton/Déclencheur** : `Acheter ({total}€)`
- Actif : fosse existante, place disponible, solde ≥ coût, HT ≥ 1.5
- Grisé si pas de fosse → tooltip "Construisez une fosse à fumier d'abord"
- Grisé si fosse pleine → tooltip "Fosse pleine"

**Au clic — Appel API** : `POST /api/manure/buy`
```json
{ "tons": 100 }
```

**Résultat succès** :
- Jauge fosse animée (remplissage)
- Toast : "{quantité} T de fumier achetées pour {coût}€"
- Solde, HT déduits

**Effets de bord** : Solde, HT. Stock fumier.

---

### 35. Épandre le fumier

**Prérequis visibles** : Stock fumier > 0 en fosse. Parcelle sélectionnée. Bouton "Épandre fumier" sur la page détail parcelle.

**Écran** : Modale d'épandage fumier.
- Parcelle : #{id}, {ha} ha
- Dose standard : 25 T/ha → quantité totale : {25 × ha} T
- Stock disponible : {stock} T
- **Apports nutritifs affichés** (barres vertes) :
  - N : +137.5 kg/ha
  - P : +65.0 kg/ha
  - K : +180.0 kg/ha
  - Ca : +75.0 kg/ha
  - Mg : +50.0 kg/ha
  - S : +70.0 kg/ha
- Comparaison avec engrais chimique : "Fumier : rendement ×1.08 vs Chimique : ×1.10"
- HT : déplacement + {ha × 0.5}
- Matériel : Tracteur + Épandeur à fumier

**Bouton/Déclencheur** : `Épandre`
- Actif : stock ≥ quantité nécessaire, tracteur + épandeur fumier dispos, HT, HVC
- Grisé si stock insuffisant → tooltip "Fumier insuffisant ({besoin} T requis, {stock} T en fosse)"
- Grisé si pas d'épandeur fumier → tooltip "Épandeur à fumier requis"

**Au clic — Appel API** : `POST /api/parcels/{id}/spread-manure`

**Résultat succès** :
- Toast : "Fumier épandu — {quantité} T sur {ha} ha"
- Jauges nutriments de la parcelle mises à jour (animation montée)
- Si culture en cours : icône engrais passe à ✅
- Stock fosse diminue
- HT, HVC déduits

**Effets de bord** : HT, HVC. Stock fumier. Réserves sol. Flag fertilized sur culture.

---

## PHASE 1 — PRÊTS

---

### 36. Demander un prêt

Voir **action 6** (identique — la demande de prêt est déjà documentée en Phase 0 car le système bancaire est en place dès le départ).

---

### 37. Rembourser un prêt par anticipation

**Prérequis visibles** : Prêt actif. Page `/bank/loans`. Bouton "Rembourser" sur chaque prêt actif.

**Écran** : Modale de remboursement anticipé.
- Prêt #{id} : montant initial {principal}€
- Capital restant dû : {remaining}€
- Pénalité 3% : {remaining × 0.03}€
- **Total à payer : {remaining + pénalité}€** (en gros, rouge)
- Économie d'intérêts : "Vous économisez ~{intérêts_restants}€ d'intérêts"
- Solde actuel : {solde}€
- Solde après remboursement : {solde - total}€

**Bouton/Déclencheur** : `Rembourser ({total}€)`
- Actif : solde ≥ total, solde après ≥ -30 000€ (seuil faillite)
- Grisé si solde insuffisant → tooltip "Solde insuffisant (besoin : {total}€, disponible : {solde}€)"

**Au clic — Contrôles frontend** :
- Solde ≥ total
- Solde - total ≥ -30 000
- Modale confirmation ORANGE : "Rembourser le prêt #{id} par anticipation ? Capital : {remaining}€ + Pénalité 3% : {pénalité}€ = Total : {total}€"

**Au clic — Appel API** : `POST /api/loans/{id}/early-repay`

**Au clic — Contrôles backend** :
- Prêt actif et appartient au joueur → 404
- Fonds suffisants (seuil faillite) → 403

**Résultat succès** :
- Toast vert : "Prêt #{id} remboursé — {total}€ débités (dont {pénalité}€ de pénalité)"
- Prêt disparaît de la liste des prêts actifs (ou passe en statut "Remboursé anticipé")
- Barre plafond emprunt mise à jour (plus de marge)
- Solde -{total} (animé)

**Résultat erreur** :
- 403 fonds → toast "Fonds insuffisants"
- 404 → toast "Prêt introuvable"

**Effets de bord** : Solde -{total}. Prêt fermé. Plafond emprunt libéré. Transaction dans le relevé.

---

## CONVENTIONS UX TRANSVERSALES

### États des boutons d'action
Tous les boutons d'action de gameplay suivent la même logique :
1. **Actif** (couleur primaire) : toutes les conditions remplies
2. **Grisé** (opacité 50%) : au moins une condition non remplie → tooltip expliquant la raison prioritaire
3. **Loading** (spinner) : appel API en cours → bouton désactivé, spinner remplace le texte
4. **Priorité des tooltips** : HT insuffisants > Solde insuffisant > Matériel manquant > Condition métier

### Feedback visuel
- **Solde** : compteur animé (défilement chiffres) lors de chaque crédit/débit
- **PA** : barre circulaire animée, flash orange quand < 5 HT
- **HVC** : jauge dans le header si cuve construite
- **Toasts** : vert (succès), orange (warning), rouge (erreur) — auto-dismiss 5s, empilables
- **Modales de confirmation** : actions < 1 000€ → pas de modale. Actions ≥ 1 000€ → modale. Actions destructrices → modale rouge avec input confirmation.

### Temps réel
- WebSocket pour : notifications, changement de jour/saison, mise à jour météo
- Polling fallback : toutes les 60s pour les données critiques (PA, solde)
- Après chaque action : rafraîchir les données locales sans recharger la page (optimistic UI + confirmation serveur)

### Responsive
- Desktop : layout multi-colonnes, tableaux complets
- Tablette : colonnes réduites, tableaux scrollables horizontalement
- Mobile : layout single-column, tableaux en mode carte, bottom navigation

### Accessibilité
- Tous les boutons : `aria-label` descriptif, `aria-disabled` si grisé
- Tooltips : accessibles au focus clavier
- Couleurs : contraste WCAG AA minimum, pas de couleur seule comme indicateur (toujours icône + texte)
- Navigation clavier complète sur les formulaires et modales

---

## Guard navigation — Ferme obligatoire

### Règle

Si le joueur est authentifié et a un `player` sur le serveur courant mais **n'a pas de ferme** (`farm` inexistante), toute navigation est redirigée vers `/setup-farm`.

### Implémentation Vue Router

```typescript
router.beforeEach(async (to, from, next) => {
  if (to.path === '/setup-farm' || to.path.startsWith('/auth')) return next();
  
  const player = usePlayerStore().player;
  if (player && !player.has_farm) return next('/setup-farm');
  
  next();
});
```

### Flux UX

1. Joueur se connecte → API retourne `player` avec `has_farm: false`
2. Guard intercepte → redirect `/setup-farm`
3. Page `/setup-farm` : wizard choix région → département → canton → nom de ferme
4. `POST /api/farms` → succès → redirect `/dashboard`
5. Les navigations suivantes passent le guard normalement

---

## File d'actions (PO 4.8)

> Réf: GAMEPLAY_VALIDATION F2.13, PLAN_ACTION_AGILE Sprint 24

### Écran

Panneau bas rétractable (hauteur 180 px, toggle via icône ▲/▼ dans le footer). Visible sur toutes les pages de gameplay.

| Zone | Contenu |
|------|---------|
| Gauche | Liste ordonnée des actions en queue (max 10). Chaque ligne : icône action, label court, coût HT, coût HVC |
| Centre | Coût HT total + coût HVC total (gros, mis à jour en temps réel) |
| Droite | Bouton `Lancer tout` (primaire) + bouton `Vider` (secondaire, rouge) |

### Ajouter une action

- Sur chaque bouton d'action de parcelle/bâtiment : icône `+` à droite du bouton principal
- Clic sur `+` → action ajoutée à la fin de la queue (toast discret "Action ajoutée à la file")
- Le bouton principal exécute immédiatement (comportement inchangé), le `+` met en queue
- Si la queue est pleine (10) → toast orange "File pleine (max 10 actions)"

### Réordonner / Supprimer

- Drag & drop sur les lignes de la queue pour réordonner
- Icône 🗑️ par ligne pour supprimer une action
- Bouton `Vider` → modale confirmation "Vider toute la file ?"

### Exécution

1. Clic `Lancer tout` → dry-run serveur (`POST /api/action-queue/dry-run`) vérifie HT, HVC, solde, matériel pour TOUTES les actions
2. Si dry-run OK → modale récapitulative : liste actions, coût HT total, coût HVC total, coût € total. Bouton `Confirmer`
3. Si dry-run KO → modale erreur : action fautive surlignée en rouge avec raison. Bouton `Retirer et relancer` ou `Annuler`
4. Après confirmation → `POST /api/action-queue/execute`. Barre de progression (1/N, 2/N…) via WebSocket event `queue_progress`
5. Résumé final : tableau des actions exécutées (✅/❌), HT consommés, HVC consommés, € dépensés

### Gestion erreur

Si une action échoue en cours d'exécution :
- Actions suivantes annulées (rollback cascade)
- Modale : "Action #{n} échouée : {raison}. Les actions suivantes ont été annulées. Actions 1 à {n-1} déjà exécutées."
- Les actions non exécutées restent dans la queue

---

## Savoir-Faire (PO 2.1)

> Réf: GAMEPLAY_VALIDATION F2.12, PLAN_ACTION_AGILE Sprint 24

### Écran : `/skills`

Accessible via le menu principal (icône 🎓) et depuis le profil joueur.

**En-tête** : "Savoir-Faire de {username}" + XP total cumulé

**3 cartes branches** (disposition horizontale desktop, empilées mobile) :

| Branche | Icône | Couleur |
|---------|-------|---------|
| Cultures | 🌾 | Vert |
| Élevage | 🐄 | Marron |
| Commerce | 💰 | Bleu |

Chaque carte :
- Nom branche + icône
- Barre de progression horizontale : `{xp_current} / {xp_next_tier} XP` (couleur de la branche)
- Palier actuel : "Palier {n}/10" avec étoiles
- Bonus actif : badge vert "+{x}% rendement" (ou équivalent par branche)
- Liste dépliable "Bonus à venir" : paliers suivants avec XP requis et bonus associé, grisés

### Tooltip bonus

Survol d'un bonus (actif ou à venir) → tooltip :
- Nom du bonus
- Effet : "+3% rendement cultures" / "-5% mortalité animale" / "+2% prix vente"
- Palier requis
- XP restant si non débloqué

### Notification palier

Quand un palier est atteint (détecté au tick ou après action) :
- Notification in-app priorité `success` : "🎓 Savoir-Faire Cultures — Palier 3 atteint ! Bonus : +3% rendement"
- Badge temporaire sur l'icône 🎓 du menu (disparaît après visite de `/skills`)

### API

- `GET /api/skills` → `{ cultures: { xp, tier, bonuses[] }, elevage: { ... }, commerce: { ... } }`

---

## Toggle expert sol (PO 4.2)

> Réf: PHASE1 Feature 2, UX_PHASE0_1 §9

Sur la page détail parcelle `/parcels/{id}`, section nutriments :
- Bouton toggle "Mode expert" positionné en haut à droite de la section nutriments
- État OFF (défaut) : 3 indicateurs simplifiés (Fertilité, Structure, Oligo-éléments) en jauges colorées
- État ON : 6 jauges détaillées (N, P, K, Ca, Mg, S) avec valeurs numériques si analyse valide
- Le toggle est local à la page (pas dans les paramètres globaux)
- Persisté en `localStorage` : `expert_soil_{player_id}` → `true/false`

---

## Focus parcelle (PO 3.9)

> Réf: PHASE1 Feature 14quater

### Écran

Mode plein écran sur `/parcels/{id}` :
- Activation : bouton "Focus" (icône ⛶) en haut à droite de la page parcelle, ou raccourci `F`
- Le menu latéral et le header sont masqués (sauf solde + HT en overlay semi-transparent coin haut droit)
- Layout : parcelle en plein écran avec stepper d'actions vertical à gauche
- Stepper : liste des actions disponibles dans l'ordre logique (Déchaumer → Labourer → Préparer → Semer → …). Action courante surlignée. Actions faites : ✅. Actions indisponibles : grisées avec raison.
- Bouton "Quitter le focus" (coin haut gauche) ou touche `Échap`

---

## Configuration ration auto (PO 4.1)

> Réf: UX_PHASE2 §4-5, PHASE2 Feature 4

### Écran : page détail bâtiment `/buildings/{id}`

Section "Alimentation automatique" (visible si bâtiment d'élevage avec animaux) :
- Sélecteur `Ration` : dropdown des rations compatibles avec l'espèce/âge des animaux du bâtiment
- Toggle `Nourrissage auto` : switch ON/OFF
- Si ON : badge "AUTO" vert sur le bâtiment dans la liste
- Info stock : "Stock requis pour 15 jours : {qty} kg" avec jauge (vert > 15j, orange 3-15j, rouge < 3j)
- Alerte si stock < 3 jours : bandeau orange "⚠️ Stock alimentation critique — moins de 3 jours"
- API : `PUT /api/buildings/{id}/ration-config` → `{ ration_id, auto_feed: true/false }`
---

### Action 38 — Choisir son kit de démarrage

**Prérequis**: Joueur vient de créer son compte et choisir sa préfecture.

**Écran**: Page plein écran avec 3 cartes côte à côte (mobile: carousel swipe).
- Chaque carte: icône (🌾/🐄/⚖️), nom du kit, description 1 ligne, liste du matériel/bâtiments/animaux inclus, bouton "Choisir ce kit".
- En bas: avertissement "Ce choix est définitif".

**Bouton "Choisir ce kit"**: Toujours actif (les 3 sont cliquables).

**Au clic**:
- Modal de confirmation: "Tu as choisi le kit [Nom]. Ce choix est définitif. Confirmer?"
- Boutons: "Confirmer" (primaire) / "Revenir" (secondaire)

**Au clic "Confirmer"**:
- Appel API: POST /api/farms { server_id, prefecture_id, kit: "cultivator"|"breeder"|"versatile" }
- Spinner pendant le chargement

**Contrôles backend**: Vérifier que le joueur n'a pas déjà une ferme sur ce serveur.

**Résultat succès**:
- Redirect vers le dashboard
- Toast: "Bienvenue ! Ta ferme est prête avec le kit [Nom]."
- Le dashboard affiche immédiatement le matériel, les bâtiments et les animaux du kit.
- Si premier login: lancer le tutoriel guidé.

**Résultat erreur**:
- 409: "Tu as déjà une ferme sur ce serveur" → redirect dashboard
- 400: "Kit invalide" → ne devrait pas arriver (UI contrôlée)

**Effets de bord**: Solde initialisé à 100 000€, 40 HT attribués, matériel/bâtiments/animaux créés.


---

## ÉCRANS GLOBAUX — Navigation, Header, Dashboard

> Ajout suite audit UX SimAgri (04_AUDIT_UX_SIMAGRI.md)
> Ces écrans sont présents sur TOUTES les pages ou constituent le cœur de l'expérience.

---

### Layout global — Shell applicatif

**Prérequis visibles** : Joueur connecté, ferme créée. Toutes les pages authentifiées utilisent ce layout.

**Écran** : Layout 3 zones.
```
┌──────────────────────────────────────────────────────┐
│ HEADER (fixe, toujours visible)                      │
├────────────┬─────────────────────────────────────────┤
│ SIDEBAR    │ CONTENU PRINCIPAL                       │
│ (contextuel│ (change selon la route)                 │
│  par onglet│                                         │
│  collapsible│                                        │
│  sur mobile)│                                        │
├────────────┴─────────────────────────────────────────┤
│ FOOTER (discret)                                     │
└──────────────────────────────────────────────────────┘
```

---

### Header global

**Prérequis visibles** : Joueur connecté.

**Écran** : Barre fixe en haut, hauteur 56px.
```
┌─────────────────────────────────────────────────────────────────────┐
│ 🌾Cultivia  [Ferme][Parcelles][Élevage][Matériels][Commerce]       │
│                                                                     │
│ 📅 7 Avr — Mois 4 (Printemps)  ☀️14°C→🌧11°C  ⏱32/40HT  💰87450€ │
│                                              🔔3  💬2  👤 pseudo ▼ │
└─────────────────────────────────────────────────────────────────────┘
```

**Éléments de gauche :**
- Logo Cultivia (lien → `/dashboard`)
- 5 onglets navigation : Ferme, Parcelles, Élevage, Matériels, Commerce
  - Onglet actif : bordure basse colorée
  - Hover : fond légèrement teinté

**Éléments centraux :**
- Date Cultivia : "7 Avr — Mois 4 (Printemps)" — source : WS `server_time`
- Météo : icône + temp aujourd'hui → icône + temp demain — clic → `/weather`
- HT : "⏱ 32/40 HT" avec mini-barre de progression — clic → modale détail HT
- Solde : "💰 87 450 €" — clic → dropdown finances

**Dropdown finances (au clic sur solde) :**
- Mon relevé bancaire → `/finances/ledger`
- Mes épargnes → `/finances/savings`
- Mes prêts → `/finances/loans`
- Mes parts sociales → `/car/:id` (si membre CAR, sinon masqué)

**Éléments de droite :**
- 🔔 Notifications : badge compteur — clic → panneau déroulant 50 dernières
  - Chaque notif : icône + texte + date relative ("il y a 2h")
  - Bouton "Tout marquer comme lu" en bas
  - Lien "Voir toutes" → `/notifications`
- 💬 Messages : badge compteur non lus — clic → `/messages`
- 👤 Pseudo ▼ : dropdown profil

**Dropdown profil :**
- Mon profil → `/profile`
- Préférences → `/settings`
- Mes favoris → `/favorites`
- Mes amis → `/friends`
- Se déconnecter → `POST /api/auth/logout` + redirect `/login`

**Bouton/Déclencheur** : Chaque élément cliquable décrit ci-dessus.

**Au clic — Modale détail HT :**
```
┌─────────────────────────────────┐
│ ⏱ Détail Heures de Travail     │
│                                 │
│ HT de base :        40         │
│ Employé (+8 HT) :   +8         │
│ Total disponible :   48         │
│ Utilisés aujourd'hui: 16        │
│ Restants :           32         │
│                                 │
│ Détail consommation :           │
│ • Nourrir animaux    -3.0 HT   │
│ • Semer parcelle #2  -4.5 HT   │
│ • Déplacement coop   -2.0 HT   │
│ • Récolte parcelle #1 -6.5 HT  │
│                                 │
│ [Embaucher un employé] [Fermer] │
└─────────────────────────────────┘
```

**Contrôles frontend** : Données via `usePlayerStore` (WS temps réel).

**API sources :**
- `GET /api/player/me` → solde, ht_today, ht_max, prefecture, server_time
- WS events : `balance_update`, `ht_update`, `weather_update`, `notification`, `server_tick`

**Responsive mobile :**
- Onglets → menu hamburger
- Sidebar → drawer overlay
- Solde + HT restent visibles (compactés)
- Météo masquée (accessible via dashboard)

---

### Sidebar contextuelle

**Prérequis visibles** : Joueur connecté. Contenu change selon l'onglet actif.

**Écran** : Panneau gauche 240px, collapsible (icône ☰).

**Contenu par onglet :**

**🏠 Ferme :**
```
📊 Tableau de bord
🏗️ Mes bâtiments
  └ Construire
⚡ Consommation énergie
📦 Mes marchandises
👷 Mes employés
  └ Embaucher
📐 Agrandir ma ferme
📝 Bloc-notes
```

**🌾 Parcelles :**
```
🗺️ Mes parcelles
🛒 Acheter une parcelle
📋 Offres vente/location
🔧 Parcelles à travailler
🚜 Commandes ETA Cultivia
🧪 Besoin en engrais
📊 Tableau de bord cultures
📈 Mes statistiques
🏆 Classements
```

**🐄 Élevage :**
```
🐄 Mes animaux
🏪 Marché Central
🩺 Soins / Propreté
🌾 Paille / Fumier / Lisier
🥛 Mes productions
🍽️ Nourrissage (config)
🧬 Reproduction
📊 Valeurs génétiques
📖 GénétiLab
📈 Statistiques carcasses
🐕 Mon chien
```

**🔧 Matériels :**
```
🔧 Mes matériels
🛒 Acheter occasion
🆕 Acheter neuf
🏷️ Par marque
👥 Acheter à plusieurs
🔩 Pièces détachées
🚜 ETA Cultivia
  └ Commandes
  └ Mes tarifs
  └ Annuaire
  └ Classements
```

**💰 Commerce :**
```
🏪 Marché Central
📢 Mes annonces
🔍 Consulter annonces
📥 Commandes reçues
📤 Commandes passées
📝 Contrats joueurs
📋 Appels d'offres
🏛️ Ma CAR
  └ Annuaire CAR
🚚 Transport
💳 Relevé bancaire
💰 Épargnes
🏦 Prêts
```

**Boutons sidebar :**
- Chaque lien = navigation Vue Router
- Lien actif : fond teinté + bordure gauche
- Badge compteur sur certains liens (ex: "Commandes reçues 3")
- Collapsible sur mobile (drawer)

---

### Dashboard (`/dashboard`)

**Prérequis visibles** : Joueur connecté, ferme créée.

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ Bienvenue {username} — {prefecture_name}, {department}          │
│ 📅 7 Avril — Mois 4 (Printemps) — Année 2                      │
│ ☀️ Aujourd'hui : Ensoleillé 14°C — Demain : Pluie 11°C         │
├────────────────────┬────────────────────┬───────────────────────┤
│ 💰 FINANCES        │ ⏱️ HEURES TRAVAIL   │ 🔔 ALERTES DU JOUR    │
│                    │                    │                       │
│ Solde: 87 450 €    │ ████████░░ 32/40   │ • 3 animaux pas       │
│ Hier: +1 200 €     │ Employé: +8        │   nourris ⚠️          │
│ Ce mois: +12 400 € │ Utilisés: 16       │ • Parcelle #4 à      │
│                    │                    │   récolter 🟢         │
│ [Relevé bancaire]  │ [Détail]           │ • 1 matériel en       │
│                    │                    │   panne 🔴            │
│                    │                    │ [Voir tout]           │
├────────────────────┴────────────────────┴───────────────────────┤
│ 📊 ÉVOLUTION DU SOLDE                                           │
│ [Graphique linéaire — 30 derniers jours — axe X: date, Y: €]   │
│ Hover sur point → tooltip "03/04 : 86 250 €"                   │
├────────────────────┬────────────────────────────────────────────┤
│ 🐄 ÉLEVAGE         │ 🌾 PARCELLES                               │
│ Bovins: 12         │ 5 parcelles — 47 ha                       │
│ ├ Pas nourris: 3 ⚠️│ ├ Non travaillée: 1 ⚠️                    │
│ ├ Pas abreuvés: 0 ✅│ ├ À récolter: 2 🟢                       │
│ ├ Malades: 1 🔴    │ ├ En croissance: 2 🌱                     │
│ ├ Naissances: 0    │ └ En jachère: 0                           │
│ ├ Morts: 0         │                                            │
│ └ En arrivage: 2   │ [Voir parcelles]                           │
│   [Placer auto]    │                                            │
│ [Voir animaux]     │                                            │
├────────────────────┼────────────────────────────────────────────┤
│ 🏗️ BÂTIMENTS       │ 🔧 MATÉRIELS                               │
│ 8 bâtiments        │ 4 matériels                                │
│ Capacité moy: 65%  │ ├ En panne: 1 ⚠️                          │
│ Énergie: OK ✅     │ ├ Non abrité: 2 ⚠️                        │
│ Entretien dû: 0    │ └ Carburant: ████░░ 60%                   │
│ [Voir bâtiments]   │ [Voir matériels]                           │
├────────────────────┴────────────────────────────────────────────┤
│ 🔔 NOTIFICATIONS RÉCENTES                                       │
│ ┌──────────────────────────────────────────────────────────────┐│
│ │ 🐄 Des animaux n'ont pas mangé aujourd'hui    il y a 2h     ││
│ │ 🌾 Récolte blé terminée parcelle #2           il y a 8h     ││
│ │ 💬 Nouveau message de FermierDu42             il y a 1j     ││
│ │ 🌧️ Alerte météo : forte pluie demain          il y a 1j     ││
│ └──────────────────────────────────────────────────────────────┘│
│ [Tout marquer comme lu]                    [Voir toutes →]      │
├─────────────────────────────────────────────────────────────────┤
│ 📰 ACTUALITÉS CULTIVIA                                          │
│ • Mise à jour 1.2 : Nouvelles races — 05/04                    │
│ • Événement : Gel printanier sur 12 préfectures — 03/04        │
│ [Voir toutes →]                                                 │
├─────────────────────────────────────────────────────────────────┤
│ 💡 GUIDE DÉBUTANT (visible si ancienneté < 84 jours)            │
│ Bienvenue ! Consultez le guide pour bien démarrer votre ferme.  │
│ [📖 Guide du joueur]                              [✕ Masquer]   │
└─────────────────────────────────────────────────────────────────┘
```

**Boutons et actions :**

| Bouton | Route/Action | État actif | État grisé |
|--------|-------------|------------|------------|
| Relevé bancaire | → `/finances/ledger` | Toujours | — |
| Détail HT | Modale détail HT | Toujours | — |
| Voir tout (alertes) | → `/notifications?filter=alerts` | Si alertes > 0 | Si 0 alertes |
| Placer auto (arrivage) | `POST /api/animals/auto-place` | Si animaux en arrivage | Si 0 en arrivage |
| Voir animaux | → `/animals` | Toujours | — |
| Voir parcelles | → `/parcels` | Toujours | — |
| Voir bâtiments | → `/buildings` | Toujours | — |
| Voir matériels | → `/equipment` | Toujours | — |
| Tout marquer lu | `POST /api/notifications/read-all` | Si notifs non lues | Si toutes lues |
| Guide du joueur | → `/guide` | Toujours | — |
| Masquer guide | `PUT /api/player/preferences {show_guide: false}` | Si visible | — |

**API — Endpoint dashboard :**
```
GET /api/dashboard
```
```json
{
  "player": { "username": "...", "balance": 87450, "ht_remaining": 32, "ht_max": 48, "seniority_days": 42 },
  "location": { "prefecture": "Clermont-Ferrand", "department": "Puy-de-Dôme" },
  "weather": { "today": { "type": "sunny", "temp": 14 }, "tomorrow": { "type": "rain", "temp": 11 } },
  "date": { "day": 7, "month": 4, "month_name": "Avril", "season": "spring", "year": 2 },
  "alerts": {
    "animals_not_fed": 3,
    "animals_not_watered": 0,
    "animals_sick": 1,
    "animals_dead": 0,
    "animals_arriving": 2,
    "parcels_to_harvest": 2,
    "parcels_not_worked": 1,
    "equipment_broken": 1,
    "equipment_unsheltered": 2
  },
  "summary": {
    "animal_count": 12,
    "parcel_count": 5,
    "parcel_hectares": 47,
    "building_count": 8,
    "building_avg_capacity": 65,
    "equipment_count": 4,
    "fuel_percent": 60
  },
  "finances": {
    "balance_yesterday_delta": 1200,
    "balance_month_delta": 12400,
    "balance_history": [{ "date": "03/04", "balance": 86250 }, ...]
  },
  "notifications": [
    { "id": 1, "type": "animal_alert", "text": "Des animaux n'ont pas mangé", "created_at": "...", "read": false }
  ],
  "news": [
    { "id": 1, "title": "Mise à jour 1.2", "date": "05/04", "summary": "..." }
  ]
}
```

**WebSocket — Mises à jour temps réel :**
| Event | Widgets mis à jour |
|-------|-------------------|
| `balance_update` | Solde header + widget finances + graphique |
| `ht_update` | Barre HT header + widget HT |
| `notification` | Badge header + liste notifications |
| `weather_update` | Météo header + widget météo |
| `animal_alert` | Widget élevage |
| `parcel_alert` | Widget parcelles |
| `tick_daily` | Refresh complet dashboard |

**Effets de bord** : Aucun (lecture seule, 0 HT).


---

### Liste des bâtiments (`/buildings`)

**Prérequis visibles** : Joueur connecté, ferme créée.

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Mes bâtiments" [Total: 8] [Capacité moy: 65%]    │
│ [Construire un bâtiment]                                        │
├─────────┬───────────────────────────────────────────────────────┤
│ Filtres │  DataTable paginée (20/page)                          │
│ ┌─────┐ │                                                       │
│ │Type │ │  ☐ | Bâtiment | Capacité | Remplissage | Contenu |   │
│ │État │ │      Usure | Entretien | Actions                     │
│ │Remp.│ │                                                       │
│ └─────┘ │                                                       │
└─────────┴───────────────────────────────────────────────────────┘
```

**Colonnes DataTable :**
| Colonne | Type | Description |
|---------|------|-------------|
| ☐ | Checkbox | Sélection groupée |
| Bâtiment | Texte + icône | Nom personnalisé + type (ex: "Stabulation Nord — Stabulation") |
| Capacité | Texte | "45 / 60 m²" ou "12 / 20 places" |
| Remplissage | Barre | Barre visuelle % (vert < 70%, orange < 90%, rouge ≥ 90%) |
| Contenu | Texte | Résumé (ex: "12 bovins" ou "3.2t blé, 1.5t orge") |
| Usure | Barre | % usure (vert < 30%, orange < 60%, rouge ≥ 60%) |
| Entretien | Badge | "✅ OK" / "⚠️ Mensuel dû" / "🔴 Annuel dû" |
| Actions | Boutons | [Détail] [Entretenir] |

**Filtres :**
- Type : dropdown (Tous, Hangar, Stabulation, Entrepôt, Silo, Fosse, Cuve...)
- État : Tous / Entretien dû / Usure critique
- Remplissage : Tous / Vide / Partiel / Plein

**Actions groupées (sur sélection checkbox) :**
- `Entretenir tous` → `POST /api/buildings/batch-maintain` — Grisé si aucun entretien dû, tooltip "Aucun entretien nécessaire"
- `Détruire tous` → ConfirmModal "Détruire X bâtiments ? Les contenus seront perdus." — Grisé si bâtiment non vide, tooltip "Videz d'abord le bâtiment"

**Bouton "Construire un bâtiment" :**
- Actif : toujours
- → `/buildings/buy`

**API :**
```
GET /api/buildings?type=X&maintenance_due=true&page=1&limit=20
```

**Effets de bord** : Aucun (lecture seule).

---

### Construire un bâtiment (`/buildings/buy`)

**Écran** : Catalogue en grille (3 colonnes).
- Chaque carte : icône type, nom, capacité, prix, délai construction
- Badge "Instantané" si niveau 1
- Badge "X jours" si niveau 2+

**Bouton "Construire" par carte :**
- Actif : solde suffisant + HT suffisants
- Grisé + tooltip "Solde insuffisant (besoin X €)" si `balance < prix`
- Grisé + tooltip "HT insuffisants (besoin X HT)" si `ht < coût_ht`

**Au clic :** ConfirmModal "Construire {type} pour {prix} € et {ht} HT ?"

**API :** `POST /api/buildings { type, name }`

**Résultat succès :** Toast "🏗️ {type} construit !" + redirect `/buildings`

---

### Liste des matériels (`/equipment`)

**Prérequis visibles** : Joueur connecté.

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Mes matériels" [Total: 4]                         │
│ [Acheter occasion] [Acheter neuf]                               │
├──────────┬──────────────────────────────────────────────────────┤
│ Filtres  │  DataTable                                           │
│ ┌──────┐ │                                                      │
│ │Type  │ │  ☐ | Matériel | Puissance | Durée vie | Entretien | │
│ │Empla.│ │      Assurance | Emplacement | Actions              │
│ │État  │ │                                                      │
│ └──────┘ │                                                      │
└──────────┴──────────────────────────────────────────────────────┘
```

**Colonnes DataTable :**
| Colonne | Type | Description |
|---------|------|-------------|
| ☐ | Checkbox | Sélection groupée |
| Matériel | Texte + icône | Marque + Modèle + "(Type)" ex: "Claas Celtis 436 (Tracteur)" |
| Puissance | Texte | "80 ch." (tracteurs) ou puissance requise (outils) |
| Durée de vie | Barre + texte | "3250/6500 h" + barre % |
| Entretien | Badge | "✅ OK" / "⚠️ Mensuel" / "🔴 Annuel" |
| Assurance | Badge | "✅ Assuré" / "❌ Non assuré" |
| Emplacement | Badge | "🏠 Abrité" / "🌧️ Non abrité" / "🚚 En transit" / "📍 Ailleurs" |
| Actions | Boutons | [Détail] [Réparer] [Vendre] |

**Filtres :**
- Type : dropdown catégorisé (Tracteur, Outil sol, Semoir, Récolte, Élevage, Transport...)
- Emplacement : Tous / Chez moi / Ailleurs / En transit / Abrité / Non abrité
- État : Tous / En panne / Entretien dû / Non assuré

**Actions groupées :**
- `Réparer tous` → `POST /api/equipment/batch-repair` — Coût HT + € affiché
- `Entretenir tous (mensuel)` → `POST /api/equipment/batch-maintain?type=monthly`
- `Entretenir tous (annuel)` → `POST /api/equipment/batch-maintain?type=annual`
- `Assurer tous` → `POST /api/equipment/batch-insure`
- `Mettre à la casse` → ConfirmModal

**Alerte carburant :**
- Si carburant = 0 : bandeau rouge "⛽ Réservoir vide ! Vos matériels motorisés sont inutilisables. [Faire le plein]"
- Bouton "Faire le plein" → `/buildings` (cuve carburant) ou modale achat carburant

**API :**
```
GET /api/equipment?type=X&location=X&status=X&page=1&limit=20
```

---

### Relevé bancaire (`/finances/ledger`)

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Relevé bancaire" [Solde: 87 450 €]               │
│ Filtres: [Catégorie ▼] [Du __/__] [Au __/__] [Exporter CSV]    │
├─────────────────────────────────────────────────────────────────┤
│ Date       | Catégorie    | Libellé              | Débit|Crédit │
│ 07/04 14:30| Vente        | Vente 3t blé         |      | +450 │
│ 07/04 10:15| Achat        | Achat engrais NPK    | -120 |      │
│ 07/04 03:00| Entretien    | Entretien stabulation| -80  |      │
│ 06/04 18:00| Salaire      | Employé Jean         | -200 |      │
│ 06/04 03:00| Prêt         | Mensualité prêt #1   | -500 |      │
├─────────────────────────────────────────────────────────────────┤
│ Pagination: [← Précédent] Page 1/12 [Suivant →]                │
└─────────────────────────────────────────────────────────────────┘
```

**Filtres :**
- Catégorie : Tous / Vente / Achat / Entretien / Salaire / Prêt / Épargne / CAR / Taxe / Autre
- Période : date début + date fin
- Bouton "Exporter CSV" → téléchargement fichier

**API :** `GET /api/finances/ledger?category=X&from=X&to=X&page=1&limit=50`

---

### Épargnes (`/finances/savings`)

**Écran** : Liste épargnes en cours + bouton souscrire.

| Colonne | Description |
|---------|-------------|
| Montant | Somme épargnée |
| Taux | % annuel Cultivia |
| Durée | 1/3/6 mois Cultivia |
| Échéance | Date de fin |
| Intérêts estimés | Calcul affiché |
| Actions | [Retirer] (grisé si pas à échéance) |

**Bouton "Souscrire" :** Modale avec champs montant + durée. Taux calculé automatiquement.
- Grisé si solde < montant minimum (1 000 €)

**API :** `GET /api/finances/savings` / `POST /api/finances/savings`

---

### Prêts (`/finances/loans`)

**Écran** : Liste prêts en cours + bouton demander.

| Colonne | Description |
|---------|-------------|
| Montant initial | Somme empruntée |
| Restant dû | Solde restant |
| Taux | % |
| Mensualité | Montant auto-prélevé |
| Échéance | Date fin |
| Actions | [Rembourser anticipé] |

**Bouton "Demander un prêt" :** Modale.
- Champ montant (max 150 000 €, slider)
- Champ durée (3/6/12 mois Cultivia)
- Taux + mensualité calculés en temps réel
- Grisé si déjà un prêt actif, tooltip "Un seul prêt à la fois"
- Grisé si solde < -30 000 €, tooltip "Solde trop bas"

**API :** `GET /api/finances/loans` / `POST /api/finances/loans` / `POST /api/finances/loans/:id/repay`

---

### Messagerie (`/messages`)

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Messagerie"                                       │
│ [Nouveau message] [Messages reçus] [Messages envoyés]           │
├─────────────────────────────────────────────────────────────────┤
│ ☐ | Sujet                    | Auteur    | Date       | Lu | ↩️ │
│ ☐ | Décision CAR : Prix blé  | CULTIVIA  | 07/04 03:13| ✅ | ✅│
│ ☐ | Proposition contrat      | Fermier42 | 06/04 18:30| ❌ | ❌│
│ ☐ | Bienvenue sur Cultivia ! | SYSTÈME   | 01/04 00:00| ✅ | ❌│
├─────────────────────────────────────────────────────────────────┤
│ [Supprimer sélection]                    Pagination              │
└─────────────────────────────────────────────────────────────────┘
```

**Bouton "Nouveau message" :**
- Modale : Destinataire (autocomplete joueur) + Sujet + Corps
- Actif : toujours

**Actions par message :** Lire (→ page détail), Répondre, Supprimer, Signaler

**API :** `GET /api/messages?folder=inbox&page=1` / `POST /api/messages` / `DELETE /api/messages/:id`

---

### Météo (`/weather`)

**Écran** :
```
┌─────────────────────────────────────────────────────────────────┐
│ PageToolbar: "Météo nationale"                                  │
│ Votre zone : {prefecture} — {zone_climatique}                   │
├────────────────┬────────────────┬───────────────────────────────┤
│ AUJOURD'HUI    │ DEMAIN         │ APRÈS-DEMAIN (prévision)      │
│ ☀️ Ensoleillé   │ 🌧️ Pluie       │ ⛈️ Forte pluie                │
│ 14°C           │ 11°C           │ 8°C                           │
│                │                │ ⚠️ Risque gel cultures         │
├────────────────┴────────────────┴───────────────────────────────┤
│ ALERTES MÉTÉO ACTIVES                                           │
│ 🥶 Gel printanier — Préfectures touchées : Aurillac, Mende...  │
│ Impact : -20% croissance cultures, risque perte jeunes plants   │
├─────────────────────────────────────────────────────────────────┤
│ HISTORIQUE (7 derniers jours)                                    │
│ Jour | Météo | Temp | Précipitations | Événement                │
│ 6/04 | ☀️    | 15°C | 0mm            | —                        │
│ 5/04 | 🌧️    | 12°C | 8mm            | —                        │
│ 4/04 | ⛈️    | 9°C  | 22mm           | Forte pluie              │
└─────────────────────────────────────────────────────────────────┘
```

**API :** `GET /api/weather?prefecture_id=X`

**Effets de bord** : Aucun (lecture seule, 0 HT).

---

### Paramètres (`/settings`)

**Écran** : Page avec onglets.

**Onglet Profil :**
- Nom d'agriculteur (lecture seule)
- Email (modifiable, revalidation)
- Mot de passe (ancien + nouveau + confirmation)
- Bouton "Sauvegarder"

**Onglet Notifications :**
- Toggle par type : Animaux, Parcelles, Commerce, Météo, Messages, Système
- Chaque toggle = `PUT /api/player/preferences`

**Onglet Affichage :**
- Mode sol : Simple (3 indicateurs) / Expert (6 indicateurs) — toggle
- Thème : Clair / Sombre — toggle
- Langue : Français (seul pour l'instant)

**Onglet Confidentialité :**
- Profil public : Oui / Non — toggle
- Disponibilités visibles : Oui / Non — toggle

**API :** `GET /api/player/preferences` / `PUT /api/player/preferences`
