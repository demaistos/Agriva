# Game Design — Inscription & Onboarding

> Date : 2026-08-04
> Statut : Validé
> Auteur : agent:game-designer + validation humaine
> Référence legacy : `Docs_legacy/cultivia/docs/03-specs/ux/UX_INSCRIPTION.md`

---

## 1. Flux d'inscription — 4 étapes

```
①─────────②─────────③─────────④
Compte    Email     Lieu      Kit
```

---

## 2. Étape 1 — Créer son compte

| Champ | Validation |
|-------|------------|
| Nom d'agriculteur | 3-50 chars, `[a-zA-Z0-9_-]`, unicité temps réel |
| Email | Format email + unicité temps réel |
| Mot de passe | ≥8 chars, 1 maj, 1 min, 1 chiffre, indicateur de force |
| Confirmation MDP | Identique au précédent |
| Code parrain (optionnel) | Nom d'un joueur existant, vérifié temps réel |
| CGU / RGPD | Checkbox obligatoire |

### Parrainage

- Champ **optionnel** : "Nom de votre parrain (facultatif)"
- Vérification temps réel : `GET /api/auth/check-sponsor?username=xxx`
  - Joueur existant → ✅ "Parrain trouvé : [pseudo]"
  - Inexistant → ❌ "Ce joueur n'existe pas"
  - Vide → neutre (pas obligatoire)
- **Avantages parrainage** (à calibrer) :
  - Parrain : bonus HT ou récompense en jeu quand le filleul atteint un milestone
  - Filleul : accès au système CFSA (mentorat), aide contextuelle du parrain
- Le parrain est notifié de l'inscription de son filleul

---

## 3. Étape 2 — Vérification email

- Email de validation envoyé
- Polling auto toutes les 5s (détection automatique)
- Bouton "Renvoyer" avec cooldown 60s
- Option "Changer d'email" (retour étape 1 pré-rempli)

---

## 4. Étape 3 — Choisir sa localisation (carte de France)

### Carte SVG interactive — 3 niveaux de zoom

| Niveau | Action | Affichage |
|--------|--------|-----------|
| France | Vue des 13 régions | Clic → zoom région |
| Région | Départements visibles | Clic → zoom département |
| Département | Préfectures / sous-préfectures | Clic → sélection ville |

~340 villes disponibles. Affichage du nombre de joueurs par zone.

### Impact gameplay de la localisation

> **DÉCISION : la localisation IMPACTE le gameplay.**

| Élément impacté | Détail |
|-----------------|--------|
| **Météo** | Basée sur des données réelles de la zone (température, pluviométrie, ensoleillement) |
| **Type de sol dominant** | Limons en Beauce, argiles en Lauragais, sables en Landes, etc. |
| **Fenêtres de travail** | Plus de jours praticables dans le Sud que dans le Nord |
| **Cultures adaptées** | Certaines cultures sont plus rentables selon la zone (maïs irrigué dans le Sud-Ouest, blé en Beauce) |
| **Saison de pâturage** | Plus longue dans l'Ouest/Sud |
| **Réseau de joueurs** | Proximité pour les échanges, coopératives, ETA |

Le joueur voit ces informations dans le panneau latéral avant de confirmer :
- Climat dominant (océanique / continental / méditerranéen)
- Sol type de la zone
- Cultures recommandées
- Nombre de joueurs déjà installés

**Mobile** : carte plein écran + bottom sheet

---

## 5. Étape 4 — Choisir son kit de démarrage

### Décisions validées

| Paramètre | Valeur |
|-----------|--------|
| Capital de départ | **150 000 €** |
| Nombre de kits | **4** (ajout kit Volaille) |
| Matériel de départ | Usé (50-60%), non-revendable 7 jours réels |
| Choix | **Définitif** |

### Les 4 kits

| | 🌾 Cultivateur | 🐄 Éleveur | 🐔 Aviculteur | ⚖️ Polyvalent |
|---|---|---|---|---|
| **Focus** | Grandes cultures | Élevage bovin laitier | Volaille (œufs + reproduction) | Mix cultures + élevage |
| **Tracteur** | 120 CV (usure 50%) | 80 CV (usure 50%) | 50 CV (usure 50%) | 100 CV (usure 50%) |
| **Charrue** | 4 corps | 4 corps | — | 4 corps |
| **Herse rotative** | 3m | — | — | 3m |
| **Semoir** | 3m | — | — | — |
| **Moissonneuse** | 280 CV (usure 60%) | — | — | — |
| **Benne** | 12T | 12T | — | 12T |
| **Remorque plateau** | — | 8T | — | 8T |
| **Bâtiments** | Hangar 200m² + Silo 100T | Hangar 200m² + Stabulation 300m² | Poulailler 50m² + Hangar 100m² | Hangar 200m² + Silo 50T |
| **Animaux** | — | **10 vaches Holstein** (en lactation) | 20 poules + 2 coqs | — |
| **Capital** | 150 000 € | 150 000 € | 150 000 € | 150 000 € |

### Détail par kit

#### 🌾 Cultivateur
- Matériel complet pour faire un cycle cultural immédiatement (semer → récolter → vendre)
- Moissonneuse usée mais fonctionnelle (pas besoin d'acheter au départ)
- Le joueur doit acheter ses premières parcelles avec son capital
- **Première action** : acheter une parcelle → semer

#### 🐄 Éleveur
- 10 vaches Holstein en lactation = revenu lait immédiat (~3 600 €/VL/an)
- Stabulation prête, pas besoin de construire
- Doit acheter du fourrage ou des parcelles pour l'autonomie
- **Première action** : nourrir les vaches (acheter aliment) ou acheter une parcelle pour faire du foin

#### 🐔 Aviculteur
- 20 poules + 2 coqs = reproduction possible immédiatement
- Poulailler petit (50m² = 500 places à 0,1m²/poule) → marge de croissance
- Revenu immédiat (œufs) + multiplication rapide
- Capital élevé (150k€) permet d'investir dans des poulaillers supplémentaires
- **Première action** : ramasser les œufs, laisser les poules se reproduire

#### ⚖️ Polyvalent
- Matériel de base pour cultures (charrue + herse) mais pas de moissonneuse (à acheter ou prestation ETA)
- Pas d'animaux mais capital pour en acheter
- Le plus libre mais aussi le plus "nu" au démarrage
- **Première action** : décider sa direction (acheter des parcelles OU des animaux)

### Équilibrage des kits

| Kit | Revenu estimé mois 1-4 IG | Avantage | Inconvénient |
|-----|:---:|---|---|
| 🌾 Cultivateur | 0 € (semis en cours) puis 14 000 € à la récolte | Moissonneuse incluse (économie 135k€) | Pas de revenu avant la 1ère récolte (6-9 mois IG) |
| 🐄 Éleveur | ~5 000-6 600 € (lait immédiat) | Cash-flow dès J1 | Stabulation limitée, croissance lente du troupeau |
| 🐔 Aviculteur | ~1 500-2 500 € (œufs + 1ères ventes) | Croissance exponentielle, ROI futur énorme | Revenu initial faible, nécessite patience |
| ⚖️ Polyvalent | Variable (dépend du choix) | Liberté totale | Pas de matériel spécialisé, doit investir vite |

---

## 6. Post-inscription — Onboarding

### Écran de bienvenue (1.5s)
```
🌾 Bienvenue, [pseudo] !
Votre exploitation est prête à [ville] ([département]).
```

### Tutoriel guidé (overlay pointant les éléments clés)

| Étape | Élément | Message |
|:---:|---|---|
| 1 | Solde | "Voici votre capital de départ : 150 000 €" |
| 2 | Heures de Travail | "Vos Heures de Travail : 40 HT/jour — elles limitent vos actions quotidiennes" |
| 3 | Météo | "La météo de votre zone — elle influence vos cultures !" |
| 4 | Action suggérée (selon kit) | Voir ci-dessous |

### Première action suggérée (selon le kit)

| Kit | Suggestion tutoriel |
|-----|---|
| 🌾 Cultivateur | "Achetez votre première parcelle pour semer !" → lien vers le marché foncier |
| 🐄 Éleveur | "Vos vaches ont besoin de manger ! Achetez du fourrage ou une parcelle d'herbe." |
| 🐔 Aviculteur | "Vos poules pondent déjà ! Consultez votre poulailler." |
| ⚖️ Polyvalent | "Choisissez votre voie : achetez des parcelles ou des animaux." |

### Système CFSA (si parrain renseigné)

- Le parrain reçoit une notification : "[filleul] vient de s'inscrire avec vous comme parrain !"
- Le filleul voit un badge "Parrainé par [parrain]" sur son profil
- Le parrain peut envoyer un message de bienvenue
- Déblocage progressif d'avantages CFSA selon les milestones du filleul

---

## 7. Anti-abus inscription

| Mesure | Détail |
|--------|--------|
| Vérification email | Obligatoire avant de jouer |
| Rate limit | 3 comptes max par IP / 24h |
| Cooldown parrainage | Un joueur ne peut parrainer que 5 filleuls/mois |
| Matériel non-revendable | 7 jours réels après inscription |
| Détection multi-compte | Fingerprinting navigateur + patterns de jeu |

---

## 8. Récapitulatif API

| Endpoint | Méthode | Étape | Description |
|----------|---------|:---:|-------------|
| `/api/auth/check-username` | GET | 1 | Unicité pseudo |
| `/api/auth/check-email` | GET | 1 | Unicité email |
| `/api/auth/check-sponsor` | GET | 1 | Vérifier parrain |
| `/api/auth/register` | POST | 1 | Créer le compte |
| `/api/auth/resend-verification` | POST | 2 | Renvoyer email |
| `/api/auth/verify-email` | POST | 2 | Valider token |
| `/api/auth/verification-status` | GET | 2 | Polling statut |
| `/api/regions` | GET | 3 | 13 régions + joueurs |
| `/api/departments?region=XX` | GET | 3 | Départements |
| `/api/prefectures?department=XX` | GET | 3 | Villes + infos zone |
| `/api/farms` | POST | 4 | Créer la ferme |

---

> **Ce document est la référence pour l'inscription. Les specs UX détaillées (CSS, composants Vue, animations) sont dans le legacy : `Docs_legacy/cultivia/docs/03-specs/ux/UX_INSCRIPTION.md`**
