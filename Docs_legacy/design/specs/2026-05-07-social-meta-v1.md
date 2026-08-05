# Agriva — Spec Social & Meta V1

> Date : 2026-05-07 | Statut : validé V1
> Sources : agriva_split_social_meta.md (§65–71), agriva_decisions_log_compact.md

---

## 1. Messagerie

### 1.1 Principe général

Messagerie limitée et contextuelle. Pas de chat global, pas de salons, pas de fil public. Toute communication est attachée à un contexte économique (annonce de marché, transaction, contrat de service).

### 1.2 Types de messages autorisés

| Type | Déclencheur | Sens |
|------|-------------|------|
| Note d'annonce | Création/modification d'une annonce de marché | Vendeur → acheteurs potentiels |
| Message de contact | Clic "Contacter" sur une annonce | Acheteur → vendeur |
| Message de transaction | Confirmation d'achat/vente | Système → les deux parties |
| Message de service | Réservation d'un service (transport coop, ETA bot) | Système → demandeur |

Aucun autre type de message n'est autorisé en V1.

### 1.3 Règles et limites

- **Longueur max** : 280 caractères par message.
- **Quota d'envoi** : 20 messages sortants par tranche de 24 h par compte.
- **Historique** : 30 derniers messages conservés par fil de conversation ; suppression automatique après 90 jours.
- **Fils actifs max** : 50 fils ouverts simultanément par compte.
- **Pièces jointes** : aucune (texte uniquement).
- **Liens** : interdits (filtrés automatiquement).

### 1.4 Modération

- Filtre automatique à l'envoi : liste de mots interdits (insultes, spam, coordonnées personnelles).
- Un message bloqué par le filtre est rejeté silencieusement côté expéditeur avec message d'erreur générique.
- Signalement manuel possible sur chaque message reçu (voir §2).
- Pas de modérateur humain en temps réel en V1 ; révision sur signalement uniquement.

---

## 2. Signalement & Blocage

### 2.1 Signalement d'un message

**Flux :**
1. Le joueur appuie sur "Signaler" sur un message reçu.
2. Il choisit une catégorie : Spam · Contenu offensant · Tentative d'arnaque.
3. Le signalement est enregistré avec le contexte (message, expéditeur, horodatage).
4. Confirmation visuelle immédiate ("Signalement envoyé").
5. Révision asynchrone par l'équipe (hors scope technique V1 — file d'attente admin).

**Effets immédiats :** aucun effet automatique sur le compte signalé en V1 (décision humaine requise).

**Seuil d'alerte automatique :** si un compte reçoit ≥ 5 signalements distincts en 7 jours, il est marqué "sous surveillance" dans l'interface admin (pas de sanction automatique).

### 2.2 Blocage d'un compte

**Flux :**
1. Le joueur accède au profil d'un autre joueur ou à un fil de message.
2. Il appuie sur "Bloquer".
3. Confirmation demandée ("Bloquer [pseudo] ?").
4. Blocage effectif immédiatement.

**Effets du blocage :**
- Le compte bloqué ne peut plus envoyer de messages au bloqueur.
- Les annonces du bloqueur restent visibles sur le marché pour le compte bloqué (le marché est public), mais le bouton "Contacter" est désactivé.
- Les annonces du compte bloqué restent visibles pour le bloqueur (idem).
- Aucun effet sur les transactions déjà en cours.

**Limites :**
- Max 100 comptes bloqués par joueur.
- Le déblocage est possible à tout moment depuis les paramètres du compte.
- Un joueur ne peut pas voir qu'il a été bloqué.

---

## 3. Difficulté

### 3.1 Principe

Trois presets : **Facile**, **Standard**, **Exigeant**. Ils agissent uniquement sur les amortisseurs et filets de sécurité — pas sur les règles économiques ni les systèmes de simulation. Le cœur du jeu est identique pour tous.

Le preset est choisi à la création de la ferme et peut être modifié une fois par saison (hors classements compétitifs).

### 3.2 Tableau des effets par paramètre

| Paramètre | Facile | Standard | Exigeant |
|-----------|--------|----------|----------|
| **Prix bot achat** (filet plancher) | +15 % vs prix marché | Prix marché | −15 % vs prix marché |
| **Prix bot vente** (filet plafond) | −10 % vs prix marché | Prix marché | +10 % vs prix marché (bot moins compétitif) |
| **Spread bot** | 15 % (plancher min) | Normal (20 %) | 25 % (plafond max) |
| **Probabilité événement risque** (sécheresse, maladie, etc.) | ×0,6 | ×1,0 | ×1,4 |
| **Intensité des risques** (perte de rendement si événement) | −20 % | Nominal | +20 % |
| **Aides PAC / subventions** | +20 % du montant nominal | Nominal | −20 % du montant nominal |
| **Crédit de départ** | +30 % | Nominal | −20 % |
| **Taux d'intérêt emprunts** | −1 pt | Nominal | +1,5 pt |
| **Délai de grâce remboursement** | 2 saisons | 1 saison | 0 saison |
| **Conseils contextuels** | Activés par défaut, non désactivables | Activés par défaut | Désactivés par défaut |
| **Visibilité prévisions météo** | J+7 fiabilité affichée comme "moyenne" | Nominale (J+1 haute, J+3 moy, J+7 faible) | J+3 max affiché |

### 3.3 Classements et difficulté

- Les classements compétitifs (§4) n'acceptent que les joueurs en mode **Standard** ou **Exigeant**.
- Les joueurs en mode **Facile** ont accès à un classement séparé non compétitif (affichage uniquement, pas de récompenses).
- Un changement de preset en cours de saison exclut le joueur du classement de cette saison.

---

## 4. Classements

### 4.1 Segmentation

Les classements sont segmentés sur deux axes : **mode de difficulté** × **activité principale**.

| Axe | Valeurs |
|-----|---------|
| Mode | Standard · Exigeant |
| Activité | Grandes cultures · Élevage · Maraîchage · Mixte |

Cela donne 8 classements compétitifs actifs en V1.

L'activité principale d'un joueur est déterminée par la part de revenu brut sur les **2 dernières saisons** : ≥ 60 % dans une activité = classé dans cette activité ; sinon = Mixte.

### 4.2 Métrique de classement

> **Source de vérité : `economy-markets-v1.md §4.R2`**

Score composite (4 métriques) :

| Métrique | Poids | Justification |
|---|---|---|
| Revenu net saison | 40 % | Performance économique principale |
| Marge nette | 25 % | Efficacité, pas seulement volume |
| Diversification (nb produits vendus) | 15 % | Encourage la variété |
| Utilisation marché joueur (% ventes hors bot) | 20 % | Renforce la philosophie joueur-dominant |

- Mise à jour **quotidienne** (fin de journée in-game).
- Métriques visibles dans le tableau de bord (normal : score global + rang ; expert : détail complet).

### 4.3 Fréquence de mise à jour

- Mise à jour **quotidienne** (fin de journée in-game).
- Affichage du rang précédent et de la variation (+/−) à chaque mise à jour.
- Classement figé en fin de saison pour archivage et attribution des récompenses.

### 4.4 Saisons

- Durée d'une saison compétitive : **1 saison de jeu = 15 jours réels** (3 mois in-game). Décision figée dans `decisions_log_compact`.
- Fin de saison : classement archivé, scores remis à zéro, récompenses distribuées.
- Un joueur doit avoir été actif (au moins 1 transaction ou action de production) pendant ≥ 8 des 15 jours réels pour être éligible aux récompenses de fin de saison.
- **Note** : cette condition d'éligibilité doit être référencée dans economy-markets-v1.md §4.R3.

### 4.5 Affichage

- Top 100 visible publiquement par segment.
- Le joueur voit toujours son propre rang même s'il est hors top 100.
- Affichage : rang · pseudo · score · variation hebdo · activité principale.
- Pas d'affichage du revenu absolu ni des actifs (confidentialité).

### 4.6 Récompenses

Cosmétiques uniquement : badge de saison, cadre de profil, titre affiché. Aucun avantage économique ou de gameplay.

| Rang fin de saison | Récompense |
|--------------------|------------|
| 1 | Badge Or + titre "Champion [activité] S[N]" |
| 2–3 | Badge Argent |
| 4–10 | Badge Bronze |
| 11–100 | Badge Participant |

---

## 5. Succès V1

### 5.1 Principes

- Rôle : jalons de progression + cosmétiques. Aucun avantage économique.
- Affichage : interface dédiée avec paliers visibles et progression.
- Déclenchement : côté serveur, vérification asynchrone (délai max 5 min après l'action).
- Récompenses : titre de profil ou badge cosmétique uniquement.
- **Source de vérité** : `economy-markets-v1.md §5` — liste unique, 20 succès avec IDs.

### 5.2 Liste complète (référence economy-markets-v1 §5.R2)

**Catégorie : Premiers pas**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_FIRST_HARVEST` | Première récolte | Récolter un lot de n'importe quelle culture | Badge "Agriculteur" |
| `ACH_FIRST_SALE_BOT` | Premier écoulement | Vendre un lot à la coopérative bot | Titre "Coopérateur" |
| `ACH_FIRST_SALE_PLAYER` | Première vente joueur | Vendre un lot via le marché joueur | Badge "Commerçant" |
| `ACH_FIRST_ANIMAL` | Premier troupeau | Acquérir un premier animal | Badge "Éleveur" |
| `ACH_FIRST_STORAGE_UPGRADE` | Agrandissement | Améliorer une capacité de stockage | Titre "Bâtisseur" |

**Catégorie : Progression économique**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_FIRST_POSITIVE_YEAR` | Première année positive | Terminer une année in-game avec un revenu net > 0 | Badge "Rentable" + skin bâtiment niveau 1 |
| `ACH_PLAYER_MARKET_50` | Marché joueur actif | Réaliser 50 % de ses ventes via le marché joueur sur une saison | Titre "Marchand" |
| `ACH_PLAYER_MARKET_80` | Indépendant du bot | Réaliser 80 % de ses ventes via le marché joueur sur une saison | Titre "Indépendant" + badge |
| `ACH_REVENUE_10K` | 10 000 € de revenu | Atteindre 10 000 € de revenu net cumulé | Badge bronze |
| `ACH_REVENUE_100K` | 100 000 € de revenu | Atteindre 100 000 € de revenu net cumulé | Badge argent |
| `ACH_REVENUE_1M` | Millionnaire | Atteindre 1 000 000 € de revenu net cumulé | Badge or + titre "Magnat" |

**Catégorie : Diversification**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_FIRST_DIVERSIFICATION` | Première diversification | Avoir des revenus actifs dans 2 activités différentes | Badge "Polyculture" |
| `ACH_THREE_ACTIVITIES` | Exploitation complète | Avoir des revenus actifs dans les 3 activités V1 | Titre "Polyvalent" + skin |
| `ACH_TRANSFORMATION_FIRST` | Première transformation | Produire un lot transformé (laiterie, meunerie ou conserverie) | Badge "Transformateur" |

**Catégorie : Classements**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_RANK_TOP10` | Dans le top | Entrer dans le top 10 % d'un classement saison | Badge "Compétiteur" |
| `ACH_RANK_TOP1` | Élite | Entrer dans le top 1 % d'un classement saison | Badge "Élite" + titre activité |
| `ACH_RANK_FIRST` | Champion | Atteindre le rang #1 d'un classement saison | Skin exclusif + titre "Champion [activité]" |

**Catégorie : Maîtrise**

| ID | Nom | Condition | Récompense |
|---|---|---|---|
| `ACH_NO_BOT_SEASON` | Autonome | Réaliser une saison entière sans vendre au bot | Titre "Autonome" |
| `ACH_FULL_STORAGE` | Greniers pleins | Remplir 100 % d'un type de stockage | Badge "Abondance" |
| `ACH_FIVE_YEARS` | Cinq ans | Compléter 5 années in-game | Badge "Vétéran" |

**Total V1 : 20 succès.**

---

## 6. Modes de jeu

### 6.1 Mode disponible en V1

**Mode principal uniquement** — monde persistant partagé, économie multi-joueur en temps réel.

> V2+ : sandbox joueur, scénarios pédagogiques, défis saisonniers.

### 6.2 Règles de démarrage

1. Le joueur crée un compte et choisit :
   - **Région** (parmi les 8 régions agroclimatiques disponibles — voir territoire-foncier-v1.md §1) — choix permanent.
   - **Preset de difficulté** (Facile / Standard / Exigeant) — modifiable 1×/saison.
   - **Activité de départ** (Grandes cultures / Élevage / Maraîchage) — oriente l'onboarding, non contraignant.
2. La ferme est initialisée avec les paramètres ci-dessous.
3. Les missions d'onboarding progressives se déclenchent automatiquement.

### 6.3 Paramètres initiaux (mode Standard — référence)

| Paramètre | Valeur Standard | Facile | Exigeant |
|-----------|----------------|--------|----------|
| Capital de départ (€) | 50 000 | 65 000 | 40 000 |
| Superficie initiale (ha) | 20 | 20 | 20 |
| Parcelles initiales | 2 × 10 ha | 2 × 10 ha | 2 × 10 ha |
| Bâtiments de départ | Hangar basique | Hangar basique | Hangar basique |
| Équipements de départ | Tracteur entrée de gamme | Tracteur entrée de gamme | Tracteur entrée de gamme |
| Emprunt initial disponible | 30 000 € à taux nominal | 30 000 € à taux −1 pt | 20 000 € à taux +1,5 pt |
| Fertilité sols initiale | 60/100 | 65/100 | 55/100 |
| Saison de départ | Printemps S1 | Printemps S1 | Printemps S1 |

La superficie et les parcelles sont identiques quel que soit le preset — la difficulté joue sur le capital et les conditions, pas sur la surface.

### 6.4 Ce qui n'existe pas en V1

- Mode sandbox joueur — **V2+**
- Scénarios pédagogiques — **V2+** (sauf si l'onboarding standard s'avère insuffisant)
- Mode test public — interne équipe uniquement
- Coopératives de joueurs structurées — **V2+**
- Chat global — **hors scope définitif**

---

## Annexe — Décisions figées rappelées

| Sujet | Décision |
|-------|----------|
| Chat global | Interdit en V1 et au-delà (hors scope définitif) |
| Coops structurées | V2+ |
| Récompenses classements | Cosmétiques uniquement, jamais économiques |
| Récompenses succès | Cosmétiques uniquement |
| Sandbox joueur | V2+ |
| Modération temps réel | V2+ (révision sur signalement en V1) |
| Sync succès plateformes externes | V2+ |
