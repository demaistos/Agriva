# Agriva — Spec Produit Web V1
> Date : 2026-05-07 | Statut : référence V1 | Auteur : spec-produit-web

---

## 1. Pages publiques (non connecté)

---

### 1.1 Page d'accueil

#### Contenu

- **Hero** : titre principal ("Gérez votre exploitation agricole virtuelle"), sous-titre proposition de valeur ("Stratégie, réalisme, communauté — le simulateur agricole nouvelle génération"), CTA primaire "Commencer gratuitement" → `/inscription`, CTA secondaire "Voir les tarifs" → `/tarifs`.
- **Section proposition de valeur** : 3 blocs icône + titre + texte court — (1) Réalisme agronomique, (2) Économie multi-joueur en temps réel, (3) Progression libre (normal → expert).
- **Section captures d'écran** : carousel de 3–4 screenshots annotés (Hub quotidien, Planification, Marchés, Territoire). Légendes courtes.
- **Section comparaison SimAgri** : tableau 2 colonnes (SimAgri vs Agriva) sur 5 critères : interface, économie, profondeur agronomique, multi-joueur, accessibilité débutant.
- **Section témoignages** : **V2+** — placeholder vide en V1.
- **Footer CTA** : "Créer un compte gratuit" → `/inscription`.

#### Interactions

- CTA "Commencer gratuitement" → redirige vers `/inscription` (étape 1).
- CTA "Voir les tarifs" → redirige vers `/tarifs`.
- Carousel screenshots : navigation manuelle (flèches) + auto-play 5 s, pause au survol.
- Liens footer : CGU, Politique de confidentialité, À propos.

#### Règles métier

- Page accessible sans authentification.
- Si l'utilisateur est déjà connecté : CTA "Commencer gratuitement" devient "Accéder au jeu" → `/hub`.
- Pas de cookie wall bloquant (bandeau RGPD non bloquant).

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ NAVBAR : Logo Agriva | Tarifs | À propos | Connexion │
├─────────────────────────────────────────────────────┤
│ HERO (pleine largeur, fond image champ)              │
│   H1 : Gérez votre exploitation agricole virtuelle  │
│   H2 : Stratégie, réalisme, communauté              │
│   [Commencer gratuitement]  [Voir les tarifs]        │
├──────────────┬──────────────┬───────────────────────┤
│ 🌾 Réalisme  │ 📈 Économie  │ 🎯 Progression libre  │
│ agronomique  │ multi-joueur │ normal → expert        │
├─────────────────────────────────────────────────────┤
│ CAPTURES D'ÉCRAN (carousel 3–4 screenshots annotés) │
├─────────────────────────────────────────────────────┤
│ COMPARAISON SimAgri vs Agriva (tableau 2 colonnes)  │
├─────────────────────────────────────────────────────┤
│ TÉMOIGNAGES — V2+                                   │
├─────────────────────────────────────────────────────┤
│ CTA FOOTER : [Créer un compte gratuit]              │
├─────────────────────────────────────────────────────┤
│ FOOTER : CGU | Confidentialité | À propos           │
└─────────────────────────────────────────────────────┘
```

---

### 1.2 Page tarifs

#### Contenu

- **Titre** : "Choisissez votre formule".
- **Deux colonnes** :
  - **Gratuit** : "Jouez sans limite de temps" — liste de fonctionnalités incluses.
  - **Confort — 4,99 €/mois** : badge "Recommandé" **[POST-V1]** — liste complète avec ajouts confort.
- **Tableau comparatif** :

| Fonctionnalité | Gratuit | Confort 4,99 €/mois |
|---|---|---|
| Accès complet au jeu | ✓ | ✓ |
| Mode Normal | ✓ | ✓ |
| Mode Expert | ✓ | ✓ |
| Toutes les activités V1 | ✓ | ✓ |
| Classements & succès | ✓ | ✓ |
| Sauvegarde cloud | ✓ | ✓ |
| Suppression des publicités | ✗ | ✓ |
| Thèmes visuels supplémentaires | ✗ | ✓ |
| Badge profil "Confort" | ✗ | ✓ |
| Support prioritaire | ✗ | ✓ |

- **Note** : "Aucune fonctionnalité de jeu n'est bloquée derrière l'abonnement. Confort = confort d'usage et cosmétiques." **[POST-V1 — page tarifs non disponible au lancement V1]**
- **CTA** : Gratuit → "Commencer gratuitement" (`/inscription`) ; Confort → "S'abonner" (`/inscription?plan=confort`).
- **FAQ courte** : 3 questions (résiliation, paiement, différence avec gratuit).

#### Interactions

- CTA "Commencer gratuitement" → `/inscription`.
- CTA "S'abonner" → `/inscription?plan=confort` (pré-sélectionne le plan Confort à l'étape de confirmation post-inscription).
- **[POST-V1]** Si connecté et sans abonnement : CTA "S'abonner" → Stripe Customer Portal.
- Si connecté et abonné : affiche statut actuel + lien "Gérer mon abonnement".

#### Règles métier

- Prix affiché TTC (4,99 €/mois).
- Paiement géré par Stripe — aucune donnée CB stockée côté Agriva.
- Résiliation possible à tout moment, accès Confort jusqu'à fin de période payée.
- Pas d'essai gratuit Confort en V1 (V2+).

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ NAVBAR                                              │
├──────────────────────┬──────────────────────────────┤
│ GRATUIT              │ CONFORT — 4,99 €/mois 🏅     │
│ Jouez sans limite    │ Recommandé                   │
│ [Commencer gratis]   │ [S'abonner]                  │
├─────────────────────────────────────────────────────┤
│ TABLEAU COMPARATIF (voir ci-dessus)                 │
├─────────────────────────────────────────────────────┤
│ NOTE : aucune fonctionnalité de jeu bloquée         │
├─────────────────────────────────────────────────────┤
│ FAQ : Résiliation · Paiement · Différence           │
└─────────────────────────────────────────────────────┘
```

---

### 1.3 Page à propos

#### Contenu

- **Vision** : paragraphe court — "Agriva est né de la conviction qu'un simulateur agricole peut être à la fois réaliste, accessible et social. Notre objectif : créer la référence francophone du jeu de gestion agricole."
- **Valeurs** : 3 points (Réalisme agronomique, Accessibilité progressive, Communauté équitable).
- **Équipe** : optionnel en V1 — section masquée ou placeholder "L'équipe se présente bientôt".
- **Contact** : lien email support.

#### Interactions

- Liens vers `/inscription` et `/tarifs` dans le corps du texte.

#### Règles métier

- Page statique, pas d'authentification requise.

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ NAVBAR                                              │
├─────────────────────────────────────────────────────┤
│ H1 : À propos d'Agriva                             │
│ Vision (paragraphe)                                 │
│ Valeurs (3 blocs)                                   │
│ Équipe (optionnel / placeholder)                    │
│ Contact : support@agriva.fr                         │
└─────────────────────────────────────────────────────┘
```

---

### 1.4 CGU / Politique de confidentialité

#### Contenu

- **CGU** (`/cgu`) : conditions d'utilisation standard — accès au service, règles de conduite, propriété intellectuelle, limitation de responsabilité, résiliation de compte.
- **Politique de confidentialité** (`/confidentialite`) : données collectées (email, pseudo, données de jeu), finalités, durée de conservation, droits RGPD (accès, rectification, suppression), contact DPO.

#### Interactions

- Liens depuis le footer de toutes les pages publiques.
- Lien depuis le formulaire d'inscription (case à cocher obligatoire).

#### Règles métier

- Pages statiques, mises à jour manuellement.
- Date de dernière mise à jour affichée en haut de chaque page.
- Conformité RGPD obligatoire avant lancement.

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ NAVBAR                                              │
├─────────────────────────────────────────────────────┤
│ H1 : [Titre page]                                   │
│ Dernière mise à jour : JJ/MM/AAAA                   │
│ Contenu légal (sections numérotées)                 │
└─────────────────────────────────────────────────────┘
```

---


## 2. Flux inscription

Route de base : `/inscription`. Wizard multi-étapes, progression linéaire, état conservé en session (pas de perte si rechargement).

---

### 2.1 Étape 1 — Identifiants

#### Contenu

- Champ **email** (type email, requis).
- Champ **mot de passe** (type password, requis, min 8 caractères, indicateur de force).
- Champ **confirmation mot de passe** (requis).
- Lien "J'ai déjà un compte" → `/connexion`.
- Bouton "Continuer".
- Séparateur "ou".
- Bouton "Continuer avec Google" — **V2+** (désactivé en V1, affiché grisé avec tooltip "Bientôt disponible").
- Lien vers CGU et Politique de confidentialité (case à cocher obligatoire : "J'accepte les CGU et la politique de confidentialité").

#### Interactions

- Validation en temps réel : email format, force mot de passe, correspondance confirmation.
- Soumission → vérification unicité email (appel API) → si email déjà utilisé : message inline "Cet email est déjà associé à un compte. [Se connecter]".
- Succès → étape 2.

#### Règles métier

- Email normalisé en minuscules avant stockage.
- Mot de passe haché (bcrypt) côté serveur, jamais stocké en clair.
- Case CGU obligatoire — bouton "Continuer" désactivé tant que non cochée.
- Pas de vérification email à cette étape (vérification envoyée après étape 5).

#### Maquette textuelle

```
┌─────────────────────────────────────┐
│ Créer un compte — Étape 1/5         │
│ ●────○────○────○────○               │
│                                     │
│ Email                               │
│ [________________________]          │
│ Mot de passe                        │
│ [________________________] [force]  │
│ Confirmer le mot de passe           │
│ [________________________]          │
│ ☐ J'accepte les CGU et la          │
│   politique de confidentialité      │
│                                     │
│ [Continuer]                         │
│ ─────── ou ───────                  │
│ [Continuer avec Google] (V2+)       │
│                                     │
│ Déjà un compte ? [Se connecter]     │
└─────────────────────────────────────┘
```

---

### 2.2 Étape 2 — Pseudo

#### Contenu

- Champ **pseudo** (requis, 3–20 caractères, alphanumérique + tirets/underscores, pas d'espaces).
- Indicateur de disponibilité en temps réel (✓ disponible / ✗ déjà pris).
- Suggestions automatiques si pseudo indisponible (ex. `AgriJoueur42`).

#### Interactions

- Debounce 400 ms → appel API vérification unicité pseudo.
- Bouton "Continuer" désactivé tant que pseudo invalide ou indisponible.
- Bouton "Retour" → étape 1 (données conservées).

#### Règles métier

- Pseudo insensible à la casse pour la vérification d'unicité (stocké tel que saisi, comparé en minuscules).
- Caractères interdits : espaces, caractères spéciaux hors `-` et `_`.
- Longueur : 3 min, 20 max.
- Modifiable ultérieurement dans le profil (1×/saison).

#### Maquette textuelle

```
┌─────────────────────────────────────┐
│ Créer un compte — Étape 2/5         │
│ ●────●────○────○────○               │
│                                     │
│ Choisissez votre pseudo             │
│ [________________________] ✓        │
│ Suggestions : AgriPro · FermeNord   │
│                                     │
│ [Retour]          [Continuer]       │
└─────────────────────────────────────┘
```

---

### 2.3 Étape 3 — Territoire

#### Contenu

- Sélecteur **région agroclimatique** (liste déroulante, 8 options — voir territoire-foncier-v1.md §1).
- Sélecteur **département** (filtré selon région, liste déroulante).
- Champ **ville d'ancrage** (texte libre ou sélecteur selon département, optionnel — sert à personnaliser la météo locale).
- Note : "Votre région détermine votre climat et vos marchés locaux. Ce choix est **permanent**."

#### Interactions

- Sélection région → filtre la liste des départements.
- Sélection département → active le champ ville (optionnel).
- Bouton "Retour" → étape 2.
- Bouton "Continuer" → étape 4.

#### Règles métier

- Région = choix permanent (non modifiable après confirmation — décision figée).
- Département = sous-division de la région, détermine le marché foncier local.
- Ville d'ancrage = optionnelle, affine les modificateurs météo locaux.
- Les 8 régions agroclimatiques sont fixes (voir territoire-foncier-v1.md §1).

#### Maquette textuelle

```
┌─────────────────────────────────────┐
│ Créer un compte — Étape 3/5         │
│ ●────●────●────○────○               │
│                                     │
│ Région agroclimatique               │
│ [▼ Sélectionner une région    ]     │
│ Département                         │
│ [▼ Sélectionner un département]     │
│ Ville d'ancrage (optionnel)         │
│ [________________________]          │
│                                     │
│ ⚠ Ce choix est permanent            │
│                                     │
│ [Retour]          [Continuer]       │
└─────────────────────────────────────┘
```

---

### 2.4 Étape 4 — Preset difficulté

#### Contenu

- 3 cartes sélectionnables :
  - **Facile** : Capital 65 000 € · Taux emprunt −1 pt · Fertilité sols 65/100 · "Idéal pour découvrir le jeu".
  - **Standard** : Capital 50 000 € · Taux emprunt nominal · Fertilité sols 60/100 · "L'expérience recommandée".
  - **Exigeant** : Capital 40 000 € · Taux emprunt +1,5 pt · Fertilité sols 55/100 · "Pour les joueurs expérimentés".
- Note : "Le preset agit sur les amortisseurs économiques, pas sur les règles du jeu. Modifiable 1×/saison."

#### Interactions

- Clic sur une carte → sélection (bordure active).
- Standard sélectionné par défaut.
- Bouton "Retour" → étape 3.
- Bouton "Continuer" → étape 5.

#### Règles métier

- Preset modifiable 1×/saison (15 jours réels) depuis le profil.
- Les 3 presets partagent la même superficie initiale (20 ha, 2 × 10 ha) — seuls capital, taux et fertilité diffèrent (voir social-meta-v1.md §6.3).
- Preset = profil global (bascule Normal/Expert est indépendante du preset).

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ Créer un compte — Étape 4/5                         │
│ ●────●────●────●────○                               │
│                                                     │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│ │  FACILE  │  │ STANDARD │  │EXIGEANT  │           │
│ │ 65 000 € │  │ 50 000 € │  │ 40 000 € │           │
│ │ Fertilité│  │ Fertilité│  │ Fertilité│           │
│ │  65/100  │  │  60/100  │  │  55/100  │           │
│ │ Découvrir│  │Recommandé│  │Expérimenté│          │
│ └──────────┘  └──────────┘  └──────────┘           │
│                                                     │
│ ℹ Modifiable 1×/saison depuis votre profil         │
│                                                     │
│ [Retour]                    [Continuer]             │
└─────────────────────────────────────────────────────┘
```

---

### 2.5 Étape 5 — Activité de départ

#### Contenu

- 3 cartes sélectionnables :
  - **Grandes cultures** : blé, orge, colza, maïs, tournesol, betterave — "Cycles longs, marges stables".
  - **Élevage** : bovins lait/viande, ovins, porcins, volailles — "Revenus réguliers, gestion quotidienne".
  - **Maraîchage** : légumes de saison — "Cycles courts, forte valeur ajoutée, exigeant en travail".
- Note : "Ce choix oriente votre onboarding. Vous pouvez diversifier librement par la suite."

#### Interactions

- Clic sur une carte → sélection.
- Grandes cultures sélectionnées par défaut.
- Bouton "Retour" → étape 4.
- Bouton "Créer mon exploitation" → soumission finale.

#### Règles métier

- Activité de départ = orientation onboarding uniquement, non contraignante pour la suite.
- Détermine la mission 1 d'onboarding (voir §6).
- Toutes les activités V1 restent accessibles quelle que soit la sélection.

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ Créer un compte — Étape 5/5                         │
│ ●────●────●────●────●                               │
│                                                     │
│ ┌────────────┐ ┌──────────┐ ┌──────────────┐       │
│ │  GRANDES   │ │ ÉLEVAGE  │ │ MARAÎCHAGE   │       │
│ │  CULTURES  │ │          │ │              │       │
│ │ Cycles     │ │ Revenus  │ │ Cycles courts│       │
│ │ longs      │ │ réguliers│ │ haute valeur │       │
│ └────────────┘ └──────────┘ └──────────────┘       │
│                                                     │
│ ℹ Vous pouvez diversifier librement par la suite   │
│                                                     │
│ [Retour]          [Créer mon exploitation]          │
└─────────────────────────────────────────────────────┘
```

---

### 2.6 Confirmation & redirection

#### Contenu

- Page de confirmation : "Votre exploitation est prête !" + récapitulatif (pseudo, région, preset, activité).
- Message : "Un email de vérification a été envoyé à [email]. Vous pouvez jouer immédiatement — vérifiez votre email pour sécuriser votre compte."
- Bouton "Commencer l'aventure" → `/hub` (onboarding in-game déclenché automatiquement).

#### Interactions

- Redirection automatique vers `/hub` après 5 s si pas de clic.
- Email de vérification envoyé en arrière-plan (non bloquant).

#### Règles métier

- Compte actif immédiatement sans vérification email (vérification recommandée mais non bloquante).
- Si email non vérifié après 7 jours : bannière de rappel dans l'interface de jeu.
- Ferme initialisée avec les paramètres du preset choisi (voir social-meta-v1.md §6.3).
- Missions d'onboarding déclenchées automatiquement à la première connexion sur `/hub`.

---

## 3. Flux connexion

Route : `/connexion`.

---

### 3.1 Formulaire principal

#### Contenu

- Champ **email** (requis).
- Champ **mot de passe** (requis).
- Case **"Se souvenir de moi"** (session persistante 30 jours).
- Lien "Mot de passe oublié ?" → `/mot-de-passe-oublie`.
- Bouton "Se connecter".
- Séparateur "ou".
- Bouton "Continuer avec Google" — **V2+** (affiché grisé avec tooltip "Bientôt disponible").
- Lien "Pas encore de compte ? [Créer un compte]" → `/inscription`.

#### Interactions

- Soumission → validation email + mot de passe côté serveur.
- Succès → redirection vers `/hub` (ou URL d'origine si redirection forcée depuis une page protégée).
- Échec → message inline générique "Email ou mot de passe incorrect" (pas de distinction pour éviter l'énumération d'emails).
- 5 tentatives échouées → blocage temporaire 15 min + message "Trop de tentatives. Réessayez dans 15 minutes."

#### Règles métier

- "Se souvenir de moi" = cookie sécurisé HttpOnly, durée 30 jours.
- Sans "Se souvenir de moi" = session expire à la fermeture du navigateur.
- Compte suspendu → message spécifique "Votre compte est suspendu. [Contacter le support]" + redirection `/compte-suspendu`.

#### Maquette textuelle

```
┌─────────────────────────────────────┐
│ Connexion                           │
│                                     │
│ Email                               │
│ [________________________]          │
│ Mot de passe                        │
│ [________________________]          │
│ ☐ Se souvenir de moi                │
│              [Mot de passe oublié ?]│
│                                     │
│ [Se connecter]                      │
│ ─────── ou ───────                  │
│ [Continuer avec Google] (V2+)       │
│                                     │
│ Pas de compte ? [Créer un compte]   │
└─────────────────────────────────────┘
```

---

### 3.2 Mot de passe oublié

#### Contenu

- Route : `/mot-de-passe-oublie`.
- Champ **email** (requis).
- Bouton "Envoyer le lien de réinitialisation".
- Message de confirmation affiché après soumission (même message si email inexistant — anti-énumération) : "Si cet email est associé à un compte, vous recevrez un lien de réinitialisation dans quelques minutes."

#### Interactions

- Soumission → envoi email avec lien tokenisé (`/reinitialiser-mot-de-passe?token=XXX`).
- Lien valide 1 heure.
- Page `/reinitialiser-mot-de-passe` : 2 champs (nouveau mot de passe + confirmation) → validation → redirection `/connexion` avec message "Mot de passe mis à jour. Connectez-vous."

#### Règles métier

- Token à usage unique, expiré après utilisation ou après 1 heure.
- Pas de limite de demandes en V1 (rate limiting basique : 3 demandes/heure par IP — V2+ pour sophistication).
- Email de réinitialisation envoyé même si l'email n'existe pas (réponse identique).

---

### 3.3 OAuth Google — V2+

> Hors scope V1. Bouton affiché grisé avec tooltip "Bientôt disponible". Ne pas implémenter le flux OAuth en V1.

---


## 4. Navigation principale (connecté)

Présente sur tous les écrans authentifiés. Deux composants persistants : barre latérale fixe + bandeau supérieur.

---

### 4.1 Barre latérale

#### Contenu

- **Logo Agriva** (lien → `/hub`).
- **6 liens principaux** (icône + libellé) :
  1. Hub — `/hub`
  2. Exploitation — `/exploitation`
  3. Planification — `/planification`
  4. Marchés — `/marches`
  5. Rapports — `/rapports`
  6. Territoire — `/territoire`
- **Séparateur**.
- **Profil** (avatar + pseudo, lien → `/profil`).
- **Déconnexion** (icône, bas de barre).

#### Interactions

- Lien actif = état visuel distinct (fond coloré, texte accentué).
- Survol = tooltip avec libellé complet (utile si barre réduite).
- Barre rétractable sur desktop (icônes seules) — état mémorisé en localStorage.
- Mobile : barre latérale remplacée par bottom navigation bar (5 onglets principaux + menu "Plus" pour Territoire et Profil).

#### Règles métier

- Tous les liens accessibles dès la première connexion (pas de verrouillage progressif de la nav).
- Déconnexion : supprime la session + cookie "Se souvenir de moi" + redirige vers `/`.

---

### 4.2 Bandeau supérieur persistant

#### Contenu

Hauteur fixe ~48 px, non scrollable, présent sur tous les écrans connectés.

| Slot | Mode Normal | Mode Expert (ajouts) | État alerte |
|---|---|---|---|
| **Argent** | Solde disponible (€) | + Variation J (+/−) | Rouge si < seuil critique |
| **Travail dispo** | Heures disponibles aujourd'hui | + % charge hebdo | Ambre si < 20 % restant |
| **Météo** | Icône condition + temp max | + Icône J+1 (preview) | Ambre/rouge si météo défavorable |
| **Alerte** | Icône cloche (verte si aucune) | — | Badge rouge + nombre si alerte(s) critique(s) |

#### Interactions

- Clic **Argent** → panneau contextuel rapide : détail trésorerie (solde, variation, prochaines échéances).
- Clic **Travail dispo** → panneau contextuel : charge du jour + charge hebdo.
- Clic **Météo** → panneau contextuel : prévision J+7 avec incertitude croissante (J+3 max en preset Exigeant).
- Clic **Alerte** → panneau contextuel : liste des alertes actives avec type + action suggérée.
- Panneaux contextuels : slide-in non bloquant, fermable par clic extérieur ou touche Échap.

#### Règles métier

- Bandeau mis à jour en temps réel (WebSocket ou polling 30 s).
- Badge alerte rouge clignotant si alerte critique active.
- Seuil critique argent = défini par le moteur de jeu (non configurable par le joueur en V1).

---

### 4.3 Notifications

#### Contenu

- Badge numérique sur l'icône cloche (bandeau) indiquant le nombre d'alertes non lues.
- Panneau notifications (slide-in depuis le bandeau) : liste chronologique inverse, chaque notification avec icône type + texte court + horodatage + lien "Voir" vers l'écran concerné.
- Types de notifications V1 : alerte météo, blocage tâche, stock critique, transaction confirmée, succès débloqué, email non vérifié (rappel).

#### Interactions

- Clic notification → marque comme lue + redirige vers l'écran concerné.
- "Tout marquer comme lu" → vide le badge.

#### Règles métier

- Notifications persistées côté serveur (pas perdues au rechargement).
- Durée de rétention : 30 jours.
- Notifications push navigateur : opt-in, proposé après mission 1 d'onboarding.

---

## 5. Profil joueur

Route : `/profil`.

---

### 5.1 Informations

#### Contenu

- **Avatar** : initiales du pseudo sur fond coloré (pas d'upload photo en V1 — V2+).
- **Pseudo** : affiché + bouton "Modifier" (modal, 1×/saison, validation unicité).
- **Email** : affiché masqué (ex. `j***@example.com`) + lien "Modifier" → flux changement email (confirmation par email actuel).
- **Région** : affichée, non modifiable (choix permanent).
- **Mode** : Normal / Expert — toggle par système (voir wireframes-ui-v1.md §8).
- **Preset difficulté** : Facile / Standard / Exigeant — bouton "Modifier" (1×/saison).

#### Interactions

- Modifier pseudo → modal : champ nouveau pseudo + validation disponibilité + confirmation.
- Modifier preset → modal : 3 cartes (même UI qu'étape 4 inscription) + avertissement "Modifiable 1×/saison. Prochain changement disponible le [date]."
- Toggle Normal/Expert : bascule immédiate, appliquée à tous les écrans.

#### Règles métier

- Pseudo : modifiable 1×/saison (15 jours réels). Compteur affiché si modification récente.
- Preset : modifiable 1×/saison. Changement effectif au début de la saison suivante (pas immédiat).
- Région : immuable après création du compte.
- Mode Normal/Expert : bascule immédiate, sans restriction.

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ [Avatar]  AgriJoueur42                [Modifier]    │
│           j***@example.com            [Modifier]    │
│           Région : Bassin parisien    (permanent)   │
│           Mode : [Normal ●] [Expert ○]              │
│           Preset : Standard           [Modifier]    │
└─────────────────────────────────────────────────────┘
```

---

### 5.2 Statistiques

#### Contenu

- **Saisons jouées** : nombre entier.
- **Meilleur classement** : rang + segment (ex. "3e — Grandes cultures / Normal").
- **Succès débloqués** : N/20 avec liste des badges obtenus (cosmétiques).
- **Activité dominante** : calculée sur les 2 dernières saisons (≥ 60 % revenu brut → activité ; sinon "Mixte").

#### Interactions

- Clic badge succès → tooltip : nom du succès + condition de déblocage + date d'obtention.
- Clic "Voir le classement" → `/rapports` onglet Classements.

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ STATISTIQUES                                        │
│ Saisons jouées : 3                                  │
│ Meilleur classement : 3e — GC / Normal              │
│ Activité dominante : Grandes cultures               │
│ Succès : 7/20  [🏅][🏅][🏅][🏅][🏅][🏅][🏅][ ]…  │
└─────────────────────────────────────────────────────┘
```

---

### 5.3 Abonnement

#### Contenu

- **Statut** : "Gratuit" ou "Confort — actif jusqu'au [date]".
- **Plan Gratuit** : bouton "Passer à Confort" → Stripe Checkout.
- **Plan Confort actif** : bouton "Gérer mon abonnement" → Stripe Customer Portal (résiliation, mise à jour CB, historique factures).
- **Avantages rappelés** : liste courte (sans pub, thèmes, badge, support prioritaire).

#### Interactions

- **[POST-V1]** "Passer à Confort" → création session Stripe Checkout → redirection Stripe → retour `/profil?abonnement=succes` ou `/profil?abonnement=annule`.
- "Gérer mon abonnement" → redirection Stripe Customer Portal (session sécurisée).
- Retour depuis Stripe → toast de confirmation ou message d'annulation.

#### Règles métier

- Paiement 100 % géré par Stripe. Aucune donnée CB côté Agriva.
- Webhook Stripe → mise à jour statut abonnement en base (événements : `checkout.session.completed`, `customer.subscription.deleted`, `invoice.payment_failed`).
- Accès Confort maintenu jusqu'à fin de période payée après résiliation.
- Échec de paiement → email automatique Stripe + bannière dans l'interface de jeu.

#### Maquette textuelle

```
┌─────────────────────────────────────────────────────┐
│ ABONNEMENT                                          │
│ Statut : Gratuit                                    │
│ [Passer à Confort — 4,99 €/mois]                   │
│                                                     │
│ Avantages Confort :                                 │
│ ✓ Sans publicité  ✓ Thèmes  ✓ Badge  ✓ Support     │
└─────────────────────────────────────────────────────┘
```

---

### 5.4 Paramètres

#### Contenu

- **Langue** : sélecteur (Français uniquement en V1 — autres langues V2+).
- **Notifications** : toggles par type (alertes critiques, succès, transactions, rappels onboarding).
- **Notifications push navigateur** : toggle opt-in/opt-out.
- **Accessibilité** : toggle contraste élevé, toggle réduction des animations.
- **Supprimer mon compte** : lien rouge → modal de confirmation avec saisie du pseudo + avertissement "Cette action est irréversible. Toutes vos données seront supprimées sous 30 jours."

#### Interactions

- Toggles sauvegardés immédiatement (pas de bouton "Enregistrer").
- Suppression compte → modal → saisie pseudo → confirmation → désactivation immédiate du compte + email de confirmation + suppression effective sous 30 jours (RGPD).

#### Règles métier

- Langue : Français uniquement en V1. Sélecteur affiché mais options V2+ grisées.
- Suppression compte : irréversible après 30 jours. Pendant les 30 jours, le joueur peut annuler via email de confirmation.
- Données supprimées : compte, ferme, transactions, messages. Données agrégées anonymisées conservées pour statistiques.

---


## 6. Flux onboarding in-game (première connexion)

Déclenché automatiquement à la première arrivée sur `/hub` après inscription. Mini-checklist rétractable en coin bas-droit. Missions désactivables à tout moment (Paramètres > Missions). Progression conservée côté serveur.

---

### 6.1 Mission 1 — Découverte de l'interface

#### Contenu

- Objectif : explorer le Hub quotidien et comprendre le bandeau supérieur.
- Checklist : (1) Lire le solde dans le bandeau, (2) Lire le travail disponible, (3) Cliquer sur la météo, (4) Consulter la file de tâches rapide.
- Bulles d'aide : apparaissent au premier survol de chaque zone du bandeau (texte court, fermable).

#### Interactions

- Chaque action cochée automatiquement à la détection de l'interaction (pas de bouton "Valider").
- Complétion de tous les items → toast "Mission 1 terminée !" + déblocage Mission 2.
- Bulle bandeau Argent : "Votre trésorerie disponible. Cliquez pour le détail."
- Bulle Travail dispo : "Heures de travail disponibles aujourd'hui. Planifiez vos tâches en conséquence."
- Bulle Météo : "La météo influence vos tâches. Cliquez pour la prévision."
- Bulle Alerte : "Les alertes critiques apparaissent ici. Aucune alerte = bonne nouvelle !"

#### Règles métier

- Bulles affichées une seule fois (état mémorisé en base).
- Mission 1 non sautable (séquentielle avec Mission 2).
- Durée estimée : 2–3 min.

---

### 6.2 Mission 2 — Première culture (semis d'une parcelle)

#### Contenu

- Objectif : semer une parcelle dans l'atelier Grandes cultures (ou l'activité de départ choisie).
- Checklist : (1) Aller sur l'écran Exploitation, (2) Sélectionner une parcelle, (3) Ajouter une tâche "Semis", (4) Confirmer la tâche dans la Planification.
- Bulle sur la card parcelle vide : "Cette parcelle est prête à être semée. Cliquez pour commencer."
- Bulle faisabilité : "●vert = tâche réalisable aujourd'hui. ●orange = tension. ●rouge = bloquée."

#### Interactions

- Surlignage de la parcelle cible au déclenchement de la mission.
- Complétion → toast + déblocage Mission 3.

#### Règles métier

- Prérequis : Mission 1 complétée.
- Culture proposée par défaut selon l'activité de départ (ex. blé pour Grandes cultures).
- Tâche "Semis" pré-remplie avec les paramètres par défaut (pas de configuration avancée requise en mode Normal).

---

### 6.3 Mission 3 — Première récolte

#### Contenu

- Objectif : attendre la maturité de la culture semée en Mission 2 et exécuter la récolte.
- Checklist : (1) Vérifier le stade phénologique dans Exploitation, (2) Planifier la tâche "Récolte" quand le stade = "Maturité", (3) Confirmer la récolte.
- Conseil contextuel déclenché à J-3 avant maturité estimée : "Votre culture approche de la maturité. Planifiez la récolte !"
- Conseil météo si fenêtre défavorable : "Météo défavorable prévue. Anticipez la récolte si possible."

#### Interactions

- Notification in-game à la maturité : "Votre [culture] est prête à être récoltée !"
- Complétion → toast + déblocage Mission 4.

#### Règles métier

- Prérequis : Mission 2 complétée.
- La récolte génère automatiquement un stock dans le hangar.
- Durée réelle entre semis et récolte : selon la culture (blé ~3–4 mois in-game = ~9–12 jours réels en temporalité 1 mois = 5j réels).

---

### 6.4 Mission 4 — Première vente

#### Contenu

- Objectif : vendre le stock récolté sur le marché (bot ou joueur).
- Checklist : (1) Aller sur l'écran Marchés, (2) Onglet "Vendre", (3) Créer une annonce ou vendre au bot, (4) Confirmer la transaction.
- Bulle à la première ouverture Marchés : "Le bot garantit toujours un acheteur, mais à un prix moins favorable (spread 15–25 %). Le marché joueur peut offrir de meilleures conditions."
- Bulle tag "Bot" : "Prix bot = prix marché + spread. Toujours disponible comme filet de sécurité."

#### Interactions

- Complétion → toast "Première vente réalisée ! +[montant] €" + mise à jour bandeau Argent + déblocage Missions 5–10.

#### Règles métier

- Prérequis : Mission 3 complétée.
- Vente bot disponible immédiatement (pas de délai de mise en relation).
- Transaction confirmée → stock décrémenté + argent incrémenté + notification.

---

### 6.5 Missions 5–10 — Progressives

Débloquées après Mission 4. Missions 5 et 6 peuvent être jouées en parallèle. Missions 7–10 séquentielles.

| # | Mission | Prérequis | Systèmes activés | Conseil contextuel déclencheur |
|---|---|---|---|---|
| 5 | **Gérer la trésorerie** — Terminer une semaine avec marge positive | Mission 4 | Rapports (dashboard Exploitation) | Si trésorerie < 20 % capital initial : "Votre trésorerie est basse. Pensez à vendre des stocks." |
| 6 | **Premier atelier élevage** — Acquérir un lot, produire, vendre | Mission 4 | Élevage, stockage | Au premier dépassement stockage : "Votre stockage est presque plein. Pensez à vendre ou louer de la capacité." |
| 7 | **Planifier sur 7 jours** — Remplir la file pour une semaine complète | Mission 5 | Planification (réservation prévisionnelle) | Si charge > 90 % sur 2 jours consécutifs : "Attention, surcharge détectée. Reportez certaines tâches." |
| 8 | **Première crise** — Gérer une alerte météo ou de prix | Mission 6 | Alertes, workflow crise | À la première alerte rouge : "Comment réorganiser la file en urgence — cliquez sur l'alerte pour le diagnostic." |
| 9 | **Premier investissement** — Acheter un équipement ou agrandir | Mission 7 | Rapports (économie), Territoire | À l'ouverture panneau achat : "Vérifiez votre marge avant d'investir — consultez les Rapports." |
| 10 | **Découvrir le mode Expert** — Activer Expert sur un système | Mission 8 | Mode Expert (un système au choix) | À l'activation : présentation des nouvelles colonnes + "Vous pouvez revenir en Normal à tout moment." |

#### Règles d'enchaînement

- Missions 5 et 6 : parallèles (débloquées simultanément après Mission 4).
- Missions 7–10 : séquentielles.
- Mission 10 : proposée après Mission 8, jamais forcée.
- Chaque mission affiche sa checklist dans le panneau rétractable (coin bas-droit).
- Le joueur peut ignorer une mission sans blocage — elle reste accessible dans Paramètres > Missions.
- Complétion de toutes les missions → badge "Explorateur" (cosmétique) + message "Vous maîtrisez les bases d'Agriva. La suite vous appartient."

---

## 7. Pages erreur & états vides

---

### 7.1 Page 404

#### Contenu

- Titre : "Page introuvable".
- Message : "La page que vous cherchez n'existe pas ou a été déplacée."
- CTA : "Retour à l'accueil" → `/` (non connecté) ou `/hub` (connecté).
- Illustration légère (optionnelle — champ vide, tracteur perdu).

#### Règles métier

- Navbar affichée si connecté, navbar publique si non connecté.
- Log côté serveur de l'URL 404 pour détection de liens cassés.

---

### 7.2 Page 500

#### Contenu

- Titre : "Erreur serveur".
- Message : "Une erreur inattendue s'est produite. Notre équipe a été notifiée."
- CTA : "Réessayer" (reload) + "Retour à l'accueil".
- Pas de détail technique affiché à l'utilisateur.

#### Règles métier

- Erreur loguée automatiquement (Sentry ou équivalent).
- Message générique — aucune stack trace exposée.

---

### 7.3 Page maintenance

#### Contenu

- Route : `/maintenance` (ou interception globale via middleware).
- Titre : "Agriva est en maintenance".
- Message : "Nous effectuons une mise à jour. Le service sera rétabli dans [durée estimée]."
- Durée estimée configurable via variable d'environnement.
- Pas de navbar, pas de liens de navigation.

#### Règles métier

- Mode maintenance activé par flag serveur (env var `MAINTENANCE_MODE=true`).
- Exceptions : accès admin non bloqué.
- Pas de redirection automatique — page statique servie directement.

---

### 7.4 Page compte suspendu

#### Contenu

- Route : `/compte-suspendu`.
- Titre : "Votre compte est suspendu".
- Message : "Votre compte a été suspendu suite à une violation des CGU. Pour contester cette décision, contactez le support."
- Lien : "Contacter le support" → `mailto:support@agriva.fr`.
- Pas d'accès au jeu.

#### Règles métier

- Redirection automatique vers `/compte-suspendu` à toute tentative d'accès à une page protégée si statut compte = `suspended`.
- Session détruite à la suspension.

---

### 7.5 États vides par écran

| Écran | État vide | Message affiché | Action proposée |
|---|---|---|---|
| **Hub** | Nouvelle ferme, aucune tâche | "Aucune tâche aujourd'hui — commencez par semer une parcelle." | Lien → Exploitation |
| **Hub** | Aucune alerte | "Aucune alerte — tout va bien !" | — (icône verte) |
| **Exploitation** | Aucun atelier actif | "Aucun atelier actif — démarrez une culture pour commencer." | Bouton "Démarrer une culture" → modal semis |
| **Exploitation** | Parcelle vide | Card grisée "Parcelle vide — prête à être semée" | Clic → formulaire semis |
| **Planification** | Aucune tâche planifiée | "Aucune tâche planifiée — ajoutez votre première tâche." | Bouton "Ajouter une tâche" |
| **Marchés** | Aucune annonce joueur | "Marché calme — le bot assure l'approvisionnement." | Bouton "Vendre au bot" |
| **Marchés** | Aucune annonce active (mes annonces) | "Aucune annonce active." | Bouton "Créer une annonce" |
| **Rapports** | Données insuffisantes (< 7 jours) | "Données disponibles après 7 jours de jeu." | — |
| **Rapports** | Aucun succès | "Aucun succès débloqué — continuez à jouer !" | — |
| **Rapports** | Classement (< 1 saison) | "Classement disponible après 1 saison complète." | — |
| **Territoire** | Aucune parcelle disponible | "Aucune parcelle disponible dans ce secteur." | Bouton "Élargir la recherche" (filtre région) |

---

## Annexe — Éléments V2+

> Hors scope V1. Ne pas implémenter.

- OAuth Google (inscription et connexion)
- Upload photo de profil
- Essai gratuit abonnement Confort
- Autres langues (interface multilingue)
- Sandbox joueur, scénarios pédagogiques
- Coopératives de joueurs structurées
- Chat global (hors scope définitif)
- Prestataires joueurs (transport, insémination premium)
- Mode "basse charge mentale" dédié
- Personnalisation widgets dashboard
- Export des rapports
- Témoignages page d'accueil
- Filtres de marché sauvegardables
- Vue Gantt interactive multi-ateliers
- Overlay météo sur carte territoire
- Sync succès plateformes externes
