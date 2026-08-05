# UX SPEC — Page d'inscription complète

> Spécification UX exhaustive du flux d'inscription en 4 étapes.
> Un développeur frontend doit pouvoir coder chaque écran sans ambiguïté.
> Référence : UX_PHASE0_1.md §1-3, 01_IDENTITE_VISUELLE.md, 03_IDENTITE_CULTIVIA.md §2

---

## Vue d'ensemble

**Route** : `/register`
**Layout** : Plein écran, pas de sidebar ni header jeu. Fond `--color-bg-primary` (#FAFAF5) avec illustration agricole SVG en filigrane (opacité 5%).
**Logo** : Cultivia centré en haut, font `--text-h1` Nunito 800, couleur `--color-green-700`.

**Stepper visuel** : `<SignupStepper :step="currentStep" />` — barre horizontale 4 étapes.

---

## Composant `<SignupStepper>`

**Props** : `step: 1 | 2 | 3 | 4`

**Rendu** : Barre horizontale centrée, largeur max 600px.

```
  ①───────②───────③───────④
Compte   Email   Lieu    Kit
```

| État | Style |
|------|-------|
| Complété | Cercle `--color-green-700`, icône ✓ blanche, ligne `--color-green-700` |
| Actif | Cercle `--color-green-700` avec ring `box-shadow: 0 0 0 4px rgba(46,125,50,0.2)`, numéro blanc, ligne `--color-earth-200` |
| À venir | Cercle `--color-earth-200`, numéro `--color-text-muted`, ligne `--color-earth-200` |

**Labels sous chaque cercle** : font `--text-caption`, `--color-text-muted` (à venir) ou `--color-text-primary` (actif/complété).

**CSS** :
```css
.stepper { display: flex; align-items: center; justify-content: center; gap: 0; max-width: 600px; margin: var(--space-8) auto; }
.stepper-step { display: flex; flex-direction: column; align-items: center; gap: var(--space-1); position: relative; z-index: 1; }
.stepper-circle {
  width: 36px; height: 36px; border-radius: var(--radius-full);
  display: grid; place-content: center;
  font: var(--text-body-medium); transition: all var(--transition-base);
}
.stepper-circle--active { background: var(--color-green-700); color: var(--color-text-inverse); box-shadow: 0 0 0 4px rgba(46,125,50,0.2); }
.stepper-circle--done { background: var(--color-green-700); color: var(--color-text-inverse); }
.stepper-circle--pending { background: var(--color-earth-200); color: var(--color-text-muted); }
.stepper-line { flex: 1; height: 2px; background: var(--color-earth-200); min-width: 60px; }
.stepper-line--done { background: var(--color-green-700); }
.stepper-label { font: var(--text-caption); }
```

**Responsive mobile** : Labels masqués sous 480px, cercles réduits à 28px.

---

## Étape 1 — Créer son compte

**Composant** : `<SignupForm />`
**Route** : `/register` (step=1 par défaut)

### Layout

Formulaire centré, max-width 440px, padding `--space-8`. Carte blanche (`--color-bg-card`) avec `--shadow-md`, `--radius-xl`.

### Champs

| Champ | Composant | Type | Placeholder | Validation |
|-------|-----------|------|-------------|------------|
| Nom d'agriculteur | `<CInput>` | text | "fermier42" | 3-50 chars, `/^[a-zA-Z0-9_-]+$/`, unicité temps réel |
| Email | `<CInput>` | email | "votre@email.com" | Regex email, unicité temps réel |
| Mot de passe | `<CInput>` | password | "8 caractères minimum" | ≥8 chars, 1 maj, 1 min, 1 chiffre |
| Confirmer mot de passe | `<CInput>` | password | "Confirmez votre mot de passe" | Identique au champ précédent |

**Ordre des champs** : Pseudo → Email → Mot de passe → Confirmation → CGU → Bouton.

### Validation temps réel

Chaque champ est validé au `blur` ET après 500ms de debounce pendant la saisie.

**Pseudo** :
- Frontend : 3-50 chars, regex `/^[a-zA-Z0-9_-]+$/` → sinon message inline rouge "Lettres, chiffres, _ et - uniquement (3-50 caractères)"
- Unicité : `GET /api/auth/check-username?username=xxx` (debounce 500ms)
  - Disponible → icône ✅ verte à droite du champ, hint vert "Nom disponible"
  - Pris → icône ❌ rouge, erreur "Ce nom est déjà pris"
  - Loading → `<CSpinner size="sm" />` à droite du champ

**Email** :
- Frontend : regex `/^[^\s@]+@[^\s@]+\.[^\s@]+$/` → sinon "Email invalide"
- Unicité : `GET /api/auth/check-email?email=xxx` (debounce 500ms)
  - Disponible → ✅ hint vert "Email disponible"
  - Pris → ❌ "Cet email est déjà utilisé"

**Mot de passe** :
- Indicateur de force sous le champ (barre 3 segments) :
  - 🔴 Faible : < 8 chars OU manque maj/min/chiffre → "Mot de passe trop faible"
  - 🟠 Moyen : 8+ chars, 2/3 critères (maj, min, chiffre) → "Mot de passe moyen"
  - 🟢 Fort : 8+ chars, 3/3 critères → "Mot de passe fort"
- Critères affichés en liste sous la barre, chaque critère ✅ ou ❌ :
  - "8 caractères minimum"
  - "1 lettre majuscule"
  - "1 lettre minuscule"
  - "1 chiffre"
- Toggle œil (`Eye`/`EyeOff` Lucide) à droite du champ pour afficher/masquer

**Confirmation mot de passe** :
- Comparaison en temps réel → si différent : erreur "Les mots de passe ne correspondent pas"
- Si identique : ✅ vert

### Indicateur force mot de passe — CSS

```css
.password-strength { display: flex; gap: var(--space-1); margin-top: var(--space-1); }
.password-strength-segment { flex: 1; height: 4px; border-radius: var(--radius-full); background: var(--color-earth-200); transition: background var(--transition-fast); }
.password-strength--weak .password-strength-segment:nth-child(1) { background: var(--color-red-600); }
.password-strength--medium .password-strength-segment:nth-child(-n+2) { background: var(--color-amber-600); }
.password-strength--strong .password-strength-segment { background: var(--color-green-700); }

.password-criteria { list-style: none; padding: 0; margin-top: var(--space-2); }
.password-criteria li { font: var(--text-small); color: var(--color-text-muted); display: flex; align-items: center; gap: var(--space-1); }
.password-criteria li--met { color: var(--color-success); }
.password-criteria li--unmet { color: var(--color-text-muted); }
```

### Checkbox CGU + RGPD

`<CCheckbox>` avec label riche :
> "J'accepte les [Conditions Générales d'Utilisation](/cgu) et la [Politique de Confidentialité](/privacy)"

Les liens s'ouvrent dans un nouvel onglet (`target="_blank"`). Checkbox obligatoire pour activer le bouton.

### Bouton principal

`<CButton variant="primary" size="lg" fullWidth :loading="isSubmitting" :disabled="!isFormValid">`
Label : **"Créer mon compte"**

**Conditions d'activation** (`isFormValid`) :
- Pseudo : 3-50 chars, regex OK, unicité confirmée ✅
- Email : format OK, unicité confirmée ✅
- Mot de passe : force ≥ moyen (8+ chars, 2/3 critères)
- Confirmation : identique au mot de passe
- CGU : cochée

**État grisé** : `opacity: 0.5`, tooltip contextuel sur la première condition non remplie :
- "Choisissez un nom d'agriculteur" (si vide)
- "Ce nom est déjà pris" (si unicité KO)
- "Mot de passe trop faible" (si faible)
- "Les mots de passe ne correspondent pas"
- "Acceptez les CGU pour continuer"

### Au clic — Appel API

`POST /api/auth/register`
```json
{ "username": "fermier42", "email": "xxx@xxx.com", "password": "Xxxx1234" }
```

**Loading** : Bouton passe en état `loading` (spinner, texte masqué, désactivé).

### Contrôles backend

| Code | Condition | Message inline |
|------|-----------|----------------|
| 201 | Succès | → Étape 2 |
| 409 | Email existant | Sous champ email : "Cet email est déjà utilisé" |
| 409 | Username pris | Sous champ pseudo : "Ce nom est déjà pris" |
| 400 | Validation échouée | Messages inline sous chaque champ concerné |
| 429 | Rate limit | Toast orange : "Trop de tentatives, réessayez dans 1 minute" |

### Résultat succès

- Transition animée (slide left, 300ms `--transition-slow`) vers l'étape 2
- Stepper : étape 1 passe en "complété" (✓ vert), étape 2 devient "active"
- L'email saisi est stocké dans le store `useAuthStore` pour affichage étape 2

### Lien secondaire

Sous le bouton : "Déjà inscrit ? [Se connecter](/login)" — font `--text-small`, couleur `--color-text-link`.

### Accessibilité

- Tous les champs : `aria-label`, `aria-describedby` pointant vers le message d'erreur
- `aria-invalid="true"` sur les champs en erreur
- Focus automatique sur le premier champ au montage
- Navigation clavier Tab entre les champs
- Erreurs annoncées via `aria-live="polite"`

---

## Étape 2 — Vérifier son email

**Composant** : `<EmailVerification />`
**Route** : `/register/verify` (ou step=2 dans le wizard)

### Layout

Carte centrée, max-width 480px. Icône ✉️ (Lucide `Mail`) en grand (64px) centrée, couleur `--color-green-700`.

### Contenu

```
        ✉️
  Vérifiez votre email

  Un email de vérification a été envoyé à
  xxx@xxx.com (gras, --color-text-primary)

  Cliquez sur le lien dans l'email pour continuer.
  Pensez à vérifier vos spams.

  [Renvoyer l'email]     (bouton secondary, sm)
  [Changer d'email]      (lien ghost)
```

### Bouton "Renvoyer l'email"

`<CButton variant="secondary" size="sm" :disabled="resendCooldown > 0" :loading="isResending">`

**Rate limit** : 1 envoi par minute.
- Après clic : bouton grisé avec countdown visible "Renvoyer (58s)" — décompte chaque seconde
- Le countdown utilise `--font-mono` pour éviter le saut de largeur
- API : `POST /api/auth/resend-verification` → `{ email: "xxx@xxx.com" }`
- Succès : toast vert "Email renvoyé !"
- Erreur 429 : toast orange "Attendez avant de renvoyer"

### Lien "Changer d'email"

Retour à l'étape 1 avec les champs pré-remplis (sauf mot de passe). Le pseudo et l'ancien email sont conservés dans le store.

### Vérification du lien email

Le lien dans l'email pointe vers : `/register/verify?token=xxx`

**Au chargement de cette URL** :
1. Appel `POST /api/auth/verify-email` avec `{ token: "xxx" }`
2. Pendant le chargement : spinner centré + "Vérification en cours..."
3. Succès (200) : transition vers étape 3, toast vert "Email vérifié !"
4. Erreur 400 (token invalide/expiré) : message "Lien invalide ou expiré" + bouton "Renvoyer un email"
5. Erreur 409 (déjà vérifié) : redirect direct vers étape 3

### Polling optionnel

Si le joueur reste sur cette page sans cliquer le lien :
- Polling `GET /api/auth/verification-status` toutes les 5s (max 60 tentatives = 5 min)
- Dès que `verified: true` → transition automatique vers étape 3 avec animation confetti légère
- Après 5 min sans vérification : arrêt du polling, message "Toujours pas reçu ? Vérifiez vos spams ou renvoyez l'email."

### Accessibilité

- `aria-live="polite"` sur le countdown
- `role="status"` sur le message de confirmation
- Focus sur le bouton "Renvoyer" au montage

---

## Étape 3 — Choisir sa localisation (Carte SVG interactive)

**Composant principal** : `<FranceMap />`
**Composants enfants** : `<RegionDetail />`, `<PrefectureList />`
**Route** : `/register/location` (ou step=3)

### Layout desktop

```
┌──────────────────────────────────────────────────────────────┐
│ [SignupStepper step=3]                                       │
├────────────────────────────────┬─────────────────────────────┤
│                                │                             │
│   CARTE SVG FRANCE (60%)       │   PANNEAU INFO (40%)        │
│                                │                             │
│   ┌────────────────────────┐   │   Fil d'Ariane :            │
│   │                        │   │   France > Bretagne > 29    │
│   │    13 régions          │   │   > Quimper                 │
│   │    cliquables          │   │                             │
│   │                        │   │   📍 Quimper                │
│   │    Survol = highlight  │   │   Département : Finistère   │
│   │    + tooltip nom       │   │   Joueurs installés : 12    │
│   │                        │   │                             │
│   │    Clic = zoom région  │   │   [← Retour]               │
│   │                        │   │                             │
│   └────────────────────────┘   │   [Confirmer cette          │
│                                │    localisation]             │
│                                │                             │
├────────────────────────────────┴─────────────────────────────┤
│ (mobile : carte plein écran + bottom sheet info)             │
└──────────────────────────────────────────────────────────────┘
```

### Niveaux de zoom — Machine à états

```
FRANCE (vue initiale)
  │ clic région
  ▼
REGION (départements visibles)
  │ clic département
  ▼
DEPARTMENT (préfectures/sous-préfectures visibles)
  │ clic préfecture
  ▼
SELECTED (préfecture confirmée, point en surbrillance)
```

**State machine** :
```typescript
type MapZoom =
  | { level: 'france' }
  | { level: 'region'; regionCode: string }
  | { level: 'department'; regionCode: string; deptCode: string }
  | { level: 'selected'; regionCode: string; deptCode: string; prefectureId: number }
```

### Composant `<FranceMap>`

**Props** :

| Prop | Type | Description |
|------|------|-------------|
| `selected` | `number \| null` | ID de la préfecture sélectionnée |
| `zoom` | `MapZoom` | Niveau de zoom actuel |

**Emits** :

| Event | Payload | Déclencheur |
|-------|---------|-------------|
| `select-region` | `regionCode: string` | Clic sur une région |
| `select-department` | `deptCode: string` | Clic sur un département |
| `select-prefecture` | `prefectureId: number` | Clic sur un point préfecture |
| `back` | — | Retour au niveau précédent |

**Template structure** :
```vue
<template>
  <div class="france-map" :class="`france-map--${zoom.level}`">
    <svg
      viewBox="0 0 800 780"
      xmlns="http://www.w3.org/2000/svg"
      class="france-map__svg"
      :style="svgTransform"
      role="img"
      aria-label="Carte interactive de la France"
    >
      <!-- Niveau France : 13 régions -->
      <g v-if="zoom.level === 'france'" class="france-map__regions">
        <path
          v-for="region in regions"
          :key="region.code"
          :id="`region-${region.code}`"
          :d="region.path"
          class="france-map__region"
          :class="{ 'france-map__region--hover': hoveredRegion === region.code }"
          @click="$emit('select-region', region.code)"
          @mouseenter="hoveredRegion = region.code"
          @mouseleave="hoveredRegion = null"
          role="button"
          :aria-label="region.name"
          tabindex="0"
          @keydown.enter="$emit('select-region', region.code)"
        />
      </g>

      <!-- Niveau Région : départements de la région -->
      <g v-if="zoom.level === 'region' || zoom.level === 'department' || zoom.level === 'selected'" class="france-map__departments">
        <path
          v-for="dept in visibleDepartments"
          :key="dept.code"
          :id="`dept-${dept.code}`"
          :d="dept.path"
          class="france-map__dept"
          :class="{
            'france-map__dept--hover': hoveredDept === dept.code,
            'france-map__dept--active': zoom.level !== 'region' && zoom.deptCode === dept.code
          }"
          @click="$emit('select-department', dept.code)"
          @mouseenter="hoveredDept = dept.code"
          @mouseleave="hoveredDept = null"
          role="button"
          :aria-label="dept.name"
          tabindex="0"
          @keydown.enter="$emit('select-department', dept.code)"
        />
      </g>

      <!-- Niveau Département : points préfectures -->
      <g v-if="zoom.level === 'department' || zoom.level === 'selected'" class="france-map__prefectures">
        <g
          v-for="pref in visiblePrefectures"
          :key="pref.id"
          :id="`pref-${pref.id}`"
          class="france-map__pref-group"
          @click="$emit('select-prefecture', pref.id)"
          role="button"
          :aria-label="`${pref.name}${pref.is_prefecture ? ' (préfecture)' : ' (sous-préfecture)'}`"
          tabindex="0"
          @keydown.enter="$emit('select-prefecture', pref.id)"
        >
          <circle
            :cx="pref.x" :cy="pref.y"
            :r="pref.is_prefecture ? 6 : 4"
            class="france-map__pref-dot"
            :class="{
              'france-map__pref-dot--prefecture': pref.is_prefecture,
              'france-map__pref-dot--sous': pref.is_sous_prefecture,
              'france-map__pref-dot--selected': selected === pref.id
            }"
          />
          <text
            :x="pref.x" :y="pref.y - 10"
            class="france-map__pref-label"
            text-anchor="middle"
          >{{ pref.name }}</text>
        </g>
      </g>
    </svg>

    <!-- Tooltip flottant -->
    <div v-if="tooltipText" class="france-map__tooltip" :style="tooltipPosition">
      {{ tooltipText }}
    </div>
  </div>
</template>
```

### Données SVG — Fichiers statiques

Les paths SVG des régions et départements sont des fichiers JSON statiques importés au build (pas d'appel API) :

```
src/client/assets/geo/
├── regions.json          # 13 régions : { code, name, path, center: {x,y} }
├── departments/
│   ├── IDF.json          # Départements Île-de-France : { code, name, path, center }
│   ├── BRE.json          # Départements Bretagne
│   ├── ...               # 1 fichier par région (13 fichiers)
```

**Format `regions.json`** :
```json
[
  { "code": "IDF", "name": "Île-de-France", "path": "M 350 200 L 380 210 ...", "center": { "x": 365, "y": 220 } },
  { "code": "BRE", "name": "Bretagne", "path": "M 120 230 L 90 250 ...", "center": { "x": 105, "y": 260 } }
]
```

**Les préfectures sont chargées via API** (car elles incluent des données dynamiques : nombre de joueurs) :
- `GET /api/prefectures?department=XX` → `{ id, name, is_prefecture, is_sous_prefecture, lat, lng, player_count }`
- Les coordonnées lat/lng sont converties en x/y SVG via une projection simple (Mercator simplifiée, pré-calculée côté client)

### Animation de zoom

**Technique** : CSS `transform: scale() translate()` sur le `<svg>` avec `transition: transform 300ms ease`.

```css
.france-map {
  position: relative;
  width: 100%;
  aspect-ratio: 800 / 780;
  overflow: hidden;
  background: var(--color-bg-secondary);
  border-radius: var(--radius-lg);
  border: var(--border);
}

.france-map__svg {
  width: 100%;
  height: 100%;
  transition: transform 300ms ease;
  transform-origin: center center;
}
```

**Calcul du transform** (composable `useMapZoom`) :
```typescript
const svgTransform = computed(() => {
  if (zoom.value.level === 'france') return 'scale(1) translate(0, 0)'

  // Centrer sur la région ou le département
  const target = getZoomTarget(zoom.value) // retourne { x, y, scale }
  const dx = 400 - target.x * target.scale  // 400 = moitié viewBox width
  const dy = 390 - target.y * target.scale  // 390 = moitié viewBox height
  return `scale(${target.scale}) translate(${dx / target.scale}px, ${dy / target.scale}px)`
})
```

| Niveau | Scale | Centrage |
|--------|-------|----------|
| France | 1.0 | Aucun |
| Région | 2.5 – 4.0 (selon taille région) | Centre de la région |
| Département | 5.0 – 8.0 (selon taille dept) | Centre du département |

### Styles SVG — Régions

```css
.france-map__region {
  fill: var(--color-earth-50);
  stroke: var(--color-earth-500);
  stroke-width: 1;
  cursor: pointer;
  transition: fill var(--transition-fast), stroke var(--transition-fast);
}
.france-map__region:hover,
.france-map__region--hover {
  fill: var(--color-green-100);
  stroke: var(--color-green-700);
  stroke-width: 2;
}
.france-map__region:focus-visible {
  outline: none;
  fill: var(--color-green-100);
  stroke: var(--color-green-700);
  stroke-width: 2;
}
```

### Styles SVG — Départements

```css
.france-map__dept {
  fill: var(--color-earth-50);
  stroke: var(--color-earth-500);
  stroke-width: 0.5;
  cursor: pointer;
  transition: fill var(--transition-fast);
}
.france-map__dept:hover,
.france-map__dept--hover {
  fill: var(--color-green-100);
  stroke: var(--color-green-700);
  stroke-width: 1;
}
.france-map__dept--active {
  fill: rgba(46, 125, 50, 0.15);
  stroke: var(--color-green-700);
  stroke-width: 1.5;
}
```

### Styles SVG — Préfectures (points)

```css
.france-map__pref-dot {
  fill: var(--color-earth-500);
  stroke: var(--color-bg-card);
  stroke-width: 1.5;
  cursor: pointer;
  transition: all var(--transition-fast);
}
.france-map__pref-dot--prefecture {
  fill: var(--color-blue-600);
  r: 6;
}
.france-map__pref-dot--sous {
  fill: var(--color-earth-700);
  r: 4;
}
.france-map__pref-dot:hover {
  fill: var(--color-green-700);
  transform: scale(1.5);
  transform-origin: center;
}
.france-map__pref-dot--selected {
  fill: var(--color-green-700);
  stroke: var(--color-green-700);
  stroke-width: 3;
  r: 8;
  animation: pulse-dot 1.5s ease infinite;
}

@keyframes pulse-dot {
  0%, 100% { stroke-opacity: 1; }
  50% { stroke-opacity: 0.3; stroke-width: 6; }
}

.france-map__pref-label {
  font: var(--text-caption);
  fill: var(--color-text-primary);
  pointer-events: none;
  opacity: 0;
  transition: opacity var(--transition-fast);
}
.france-map__pref-group:hover .france-map__pref-label,
.france-map__pref-dot--selected + .france-map__pref-label {
  opacity: 1;
}
```

### Tooltip

```css
.france-map__tooltip {
  position: absolute;
  padding: var(--space-2) var(--space-3);
  background: var(--color-earth-900);
  color: var(--color-text-inverse);
  font: var(--text-small);
  border-radius: var(--radius-md);
  pointer-events: none;
  z-index: var(--z-tooltip);
  white-space: nowrap;
  box-shadow: var(--shadow-md);
  transform: translate(-50%, -100%);
  margin-top: -8px;
}
```

Le tooltip suit le curseur et affiche :
- Niveau France : nom de la région survolée
- Niveau Région : nom du département + code ("Finistère (29)")
- Niveau Département : nom de la préfecture + type + joueurs ("Quimper — Préfecture — 12 joueurs")

### Panneau info (colonne droite)

**Composant** : `<RegionDetail />`

**Props** :

| Prop | Type |
|------|------|
| `zoom` | `MapZoom` |
| `selectedPrefecture` | `Prefecture \| null` |
| `playerCounts` | `Record<string, number>` |

**Contenu dynamique selon le niveau** :

#### Niveau France (aucune sélection)

```
📍 Choisissez votre localisation

Cliquez sur une région de la carte
pour commencer.

~340 villes disponibles
```

Font `--text-body`, couleur `--color-text-muted`, centré.

#### Niveau Région

```
Fil d'Ariane : France > Bretagne

🗺️ Bretagne
4 départements
47 joueurs installés

Cliquez sur un département pour voir
les villes disponibles.

[← Retour à la France]
```

#### Niveau Département

```
Fil d'Ariane : France > Bretagne > Finistère (29)

🗺️ Finistère (29)
Région : Bretagne
1 préfecture, 4 sous-préfectures
12 joueurs installés

Villes disponibles :
┌──────────────────────────────────┐
│ 📍 Quimper (préfecture)    — 5j │
│ 📍 Brest (sous-préf.)     — 3j │
│ 📍 Châteaulin (sous-préf.)— 2j │
│ 📍 Morlaix (sous-préf.)   — 1j │
│ 📍 Quimperlé (sous-préf.) — 1j │
└──────────────────────────────────┘

[← Retour à Bretagne]
```

La liste `<PrefectureList>` affiche chaque ville avec :
- Icône 📍 (préfecture en `--color-blue-600`, sous-préfecture en `--color-earth-700`)
- Nom
- Badge "(préfecture)" ou "(sous-préfecture)" — `<CBadge variant="info">` ou `<CBadge variant="neutral">`
- Nombre de joueurs installés — font `--text-caption`, `--color-text-muted`
- Au clic : sélectionne la préfecture sur la carte (highlight + zoom)

#### Niveau Selected

```
Fil d'Ariane : France > Bretagne > Finistère (29) > Quimper

✅ Quimper
Préfecture du Finistère
Région Bretagne
5 joueurs installés

[← Changer de ville]

[Confirmer cette localisation]  ← bouton primary lg
```

### Fil d'Ariane

```css
.breadcrumb { display: flex; align-items: center; gap: var(--space-1); flex-wrap: wrap; margin-bottom: var(--space-4); }
.breadcrumb-item { font: var(--text-small); color: var(--color-text-link); cursor: pointer; text-decoration: none; }
.breadcrumb-item:hover { text-decoration: underline; }
.breadcrumb-item--current { color: var(--color-text-primary); font-weight: 500; cursor: default; }
.breadcrumb-separator { color: var(--color-text-muted); font: var(--text-small); }
```

Chaque élément du fil d'Ariane est cliquable pour remonter à ce niveau :
- "France" → zoom.level = 'france'
- "Bretagne" → zoom.level = 'region', regionCode = 'BRE'
- "Finistère (29)" → zoom.level = 'department', deptCode = '29'

### Bouton "Retour"

`<CButton variant="ghost" size="sm" icon="ChevronLeft">` — remonte d'un niveau dans la machine à états.

### Bouton "Confirmer cette localisation"

`<CButton variant="primary" size="lg" fullWidth :disabled="!selectedPrefecture">`

- **Actif** : une préfecture est sélectionnée
- **Grisé** : aucune sélection → tooltip "Sélectionnez une ville sur la carte"
- Au clic : stocke `prefecture_id` dans le store `useRegistrationStore`, transition vers étape 4

### Responsive mobile (< 768px)

**La carte passe en plein écran** :
```css
@media (max-width: 768px) {
  .location-layout {
    display: flex;
    flex-direction: column;
    height: calc(100vh - 120px); /* stepper + padding */
  }
  .france-map { flex: 1; border-radius: 0; }
}
```

**Le panneau info devient un bottom sheet** :
```css
.location-panel-mobile {
  position: fixed;
  bottom: 0; left: 0; right: 0;
  background: var(--color-bg-card);
  border-radius: var(--radius-xl) var(--radius-xl) 0 0;
  box-shadow: 0 -4px 24px rgba(62, 39, 35, 0.15);
  padding: var(--space-4) var(--space-6);
  z-index: var(--z-overlay);
  transform: translateY(calc(100% - 80px)); /* réduit par défaut, montre juste le fil d'Ariane */
  transition: transform var(--transition-slow);
}
.location-panel-mobile--expanded {
  transform: translateY(0);
  max-height: 60vh;
  overflow-y: auto;
}
.location-panel-mobile__handle {
  width: 40px; height: 4px;
  background: var(--color-earth-200);
  border-radius: var(--radius-full);
  margin: 0 auto var(--space-3);
}
```

- Swipe up pour ouvrir le bottom sheet, swipe down pour réduire
- Handle visuel (barre grise 40×4px centrée en haut)
- Les régions sur la carte sont assez grandes pour être tapées au doigt (min 44×44px touch target)

### Touch targets mobile

```css
@media (max-width: 768px) {
  .france-map__region { stroke-width: 2; } /* plus visible */
  .france-map__pref-dot { r: 10; } /* plus gros pour le doigt */
  .france-map__pref-dot--prefecture { r: 12; }
}
```

### API endpoints utilisés (étape 3)

| Endpoint | Quand | Données |
|----------|-------|---------|
| `GET /api/regions` | Au montage | `[{ code, name, player_count }]` |
| `GET /api/departments?region=XX` | Au clic région | `[{ code, name, player_count }]` |
| `GET /api/prefectures?department=XX` | Au clic département | `[{ id, name, is_prefecture, is_sous_prefecture, lat, lng, player_count }]` |

**Cache** : Les données régions/départements sont cachées en mémoire (ne changent pas). Les préfectures sont rechargées à chaque navigation (player_count peut changer).

### Accessibilité carte SVG

- `role="img"` sur le `<svg>`, `aria-label="Carte interactive de la France"`
- Chaque `<path>` région/département : `role="button"`, `tabindex="0"`, `aria-label="Nom"`, `@keydown.enter`
- Chaque `<circle>` préfecture : idem
- Navigation clavier : Tab entre les zones, Enter pour sélectionner
- `aria-current="true"` sur la zone active
- Annonce vocale via `aria-live="polite"` quand le zoom change : "Zoom sur la région Bretagne, 4 départements"

---

## Étape 4 — Choisir son kit de démarrage

**Composant principal** : `<StarterKitSelector />`
**Composant enfant** : `<StarterKitCard />`
**Route** : `/register/kit` (ou step=4)

### Layout

3 cartes côte à côte, centrées, max-width 960px. Gap `--space-6`.

```
┌──────────────────────────────────────────────────────────┐
│ [SignupStepper step=4]                                   │
│                                                          │
│  Choisissez votre kit de démarrage                       │
│  Ce choix est définitif et détermine votre équipement    │
│  de départ.                                              │
│                                                          │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐     │
│  │  🌾           │ │  🐄           │ │  ⚖️           │     │
│  │  Cultivateur  │ │  Éleveur     │ │  Polyvalent  │     │
│  │              │ │              │ │              │     │
│  │  Spécialisé  │ │  Spécialisé  │ │  Équilibré   │     │
│  │  cultures    │ │  élevage     │ │  cultures +  │     │
│  │              │ │              │ │  élevage     │     │
│  │  ─────────── │ │  ─────────── │ │  ─────────── │     │
│  │  Matériel:   │ │  Matériel:   │ │  Matériel:   │     │
│  │  • Tracteur  │ │  • Tracteur  │ │  • Tracteur  │     │
│  │    120 CV    │ │    80 CV     │ │    100 CV    │     │
│  │  • Charrue   │ │  • Charrue   │ │  • Charrue   │     │
│  │  • Herse     │ │  • Remorque  │ │  • Herse     │     │
│  │  • Semoir    │ │              │ │  • Remorque  │     │
│  │  • Moisson.  │ │  Bâtiments:  │ │              │     │
│  │  • Benne     │ │  • Étable    │ │  Bâtiments:  │     │
│  │              │ │  • Hangar    │ │  • Hangar    │     │
│  │  Bâtiments:  │ │              │ │  • Silo      │     │
│  │  • Hangar    │ │  Animaux:    │ │              │     │
│  │  • Silo      │ │  • 5 vaches  │ │              │     │
│  │              │ │              │ │              │     │
│  │ [Choisir]   │ │ [Choisir]   │ │ [Choisir]   │     │
│  └──────────────┘ └──────────────┘ └──────────────┘     │
│                                                          │
│  ⚠️ Ce choix est définitif                               │
│                                                          │
│  [Commencer l'aventure]  (grisé tant que pas de choix)   │
└──────────────────────────────────────────────────────────┘
```

### Composant `<StarterKitCard>`

**Props** :

| Prop | Type | Description |
|------|------|-------------|
| `kit` | `'cultivator' \| 'breeder' \| 'versatile'` | Type de kit |
| `selected` | `boolean` | Sélectionné ou non |

**Emits** : `select`

### Données des 3 kits

| | 🌾 Cultivateur | 🐄 Éleveur | ⚖️ Polyvalent |
|---|---|---|---|
| **Description** | Spécialisé grandes cultures. Matériel complet pour semer, traiter et récolter. | Spécialisé élevage bovin. Bâtiment et animaux pour démarrer la production laitière. | Équipement de base pour cultures et élevage. Progression libre. |
| **Tracteur** | 120 CV (usure 50%) | 80 CV (usure 50%) | 100 CV (usure 50%) |
| **Charrue** | 4 corps (usure 40%) | 4 corps (usure 40%) | 4 corps (usure 40%) |
| **Herse rotative** | 3m (usure 40%) | — | 3m (usure 40%) |
| **Semoir** | 3m (usure 40%) | — | — |
| **Moissonneuse** | 300 CV (usure 60%) | — | — |
| **Benne** | 12T (usure 40%) | 12T (usure 40%) | 12T (usure 40%) |
| **Remorque** | — | 8T (usure 40%) | 8T (usure 40%) |
| **Hangar** | 200 m² | 200 m² | 200 m² |
| **Silo** | 100 T | — | 50 T |
| **Étable** | — | 300 m² | — |
| **Animaux** | — | 5 vaches Holstein | — |

> Réf: 03_IDENTITE_CULTIVIA.md §3.3 — Matériel usé mais fonctionnel, non revendable pendant 7 jours réels.

### Style des cartes

```css
.kit-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-6);
  max-width: 960px;
  margin: 0 auto;
}

.kit-card {
  background: var(--color-bg-card);
  border: 2px solid var(--color-earth-200);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
  cursor: pointer;
  transition: all var(--transition-base);
  display: flex;
  flex-direction: column;
  text-align: center;
}
.kit-card:hover {
  border-color: var(--color-green-500);
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}
.kit-card--selected {
  border-color: var(--color-green-700);
  box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.2), var(--shadow-md);
  background: rgba(46, 125, 50, 0.03);
}

.kit-icon { font-size: 48px; margin-bottom: var(--space-3); }
.kit-name { font: var(--text-h3); color: var(--color-text-primary); margin-bottom: var(--space-1); }
.kit-desc { font: var(--text-small); color: var(--color-text-muted); margin-bottom: var(--space-4); }

.kit-section-title {
  font: var(--text-caption);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-muted);
  margin: var(--space-3) 0 var(--space-1);
  text-align: left;
}
.kit-item-list {
  list-style: none; padding: 0; text-align: left;
}
.kit-item-list li {
  font: var(--text-small);
  color: var(--color-text-secondary);
  padding: var(--space-1) 0;
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.kit-item-list li::before {
  content: '•';
  color: var(--color-green-700);
  font-weight: bold;
}

.kit-select-indicator {
  margin-top: auto;
  padding-top: var(--space-4);
}
.kit-card--selected .kit-select-indicator::after {
  content: '✓ Sélectionné';
  font: var(--text-body-medium);
  color: var(--color-green-700);
}
```

### Interaction de sélection

1. **Au clic sur une carte** : la carte passe en état `--selected` (bordure verte, ring, fond léger). Les autres cartes reviennent à l'état normal.
2. **Animation** : transition `--transition-base` (200ms) sur border, shadow, transform.
3. **Le bouton "Commencer l'aventure"** s'active.

### Bouton "Commencer l'aventure"

`<CButton variant="primary" size="lg" :disabled="!selectedKit" :loading="isCreating">`

- **Grisé** si aucun kit sélectionné → tooltip "Choisissez un kit de démarrage"
- **Au clic** → Modal de confirmation

### Modal de confirmation

`<CModal title="Confirmer votre choix" size="sm">`

```
⚠️ Ce choix est définitif

Vous avez choisi le kit 🌾 Cultivateur.
Votre ferme sera créée à Quimper (Finistère).

Vous ne pourrez pas changer de kit par la suite.

[Revenir]              [Confirmer et commencer]
(secondary)            (primary)
```

### Au clic "Confirmer" — Appel API

`POST /api/farms`
```json
{
  "prefecture_id": 42,
  "kit": "cultivator"
}
```

**Loading** : Bouton en état `loading`, modal non fermable.

### Contrôles backend

| Code | Condition | Réaction |
|------|-----------|----------|
| 201 | Succès | → Redirect dashboard |
| 409 | Ferme déjà existante | Toast orange "Vous avez déjà une ferme" → redirect `/dashboard` |
| 400 | Kit invalide | Toast rouge "Kit invalide" (ne devrait pas arriver) |
| 404 | Préfecture invalide | Toast rouge "Localisation invalide" → retour étape 3 |

### Résultat succès — Séquence d'onboarding

1. **Écran de transition** (1.5s) : fond `--color-green-700`, texte blanc centré :
   ```
   🌾 Bienvenue, fermier42 !
   Votre exploitation est prête.
   ```
   Animation : fade in texte (300ms), puis fade out écran (300ms).

2. **Redirect** vers `/dashboard`

3. **Toast bienvenue** : `toast.success("Bienvenue ! Votre ferme est prête avec le kit Cultivateur.")`

4. **Tutoriel guidé** (si premier login) : overlay semi-transparent pointant les éléments clés du dashboard :
   - Étape 1 : "Voici votre solde : 100 000 €" (pointe `<BalanceDisplay>`)
   - Étape 2 : "Vos Heures de Travail : 40 HT/jour" (pointe `<HTBar>`)
   - Étape 3 : "Consultez vos parcelles ici" (pointe lien sidebar Parcelles)
   - Étape 4 : "Achetez votre première parcelle pour commencer !" (pointe bouton)
   - Bouton "Compris !" à chaque étape, "Passer le tutoriel" en lien discret

### Responsive mobile (< 768px)

```css
@media (max-width: 768px) {
  .kit-grid {
    grid-template-columns: 1fr;
    gap: var(--space-4);
    max-width: 400px;
  }
  /* Carousel swipe horizontal optionnel */
  .kit-grid--carousel {
    display: flex;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
    gap: var(--space-4);
    padding: 0 var(--space-4);
  }
  .kit-grid--carousel .kit-card {
    min-width: 280px;
    scroll-snap-align: center;
    flex-shrink: 0;
  }
}
```

- Les 3 cartes s'empilent verticalement OU carousel swipe horizontal
- Indicateurs de pagination (3 dots) sous le carousel
- Le bouton "Commencer l'aventure" est fixé en bas (sticky)

---

## Récapitulatif — Composants Vue

| Composant | Fichier | Props principales |
|-----------|---------|-------------------|
| `<SignupStepper>` | `components/auth/SignupStepper.vue` | `step: 1\|2\|3\|4` |
| `<SignupForm>` | `components/auth/SignupForm.vue` | — |
| `<EmailVerification>` | `components/auth/EmailVerification.vue` | `email: string` |
| `<FranceMap>` | `components/auth/FranceMap.vue` | `selected, zoom` |
| `<RegionDetail>` | `components/auth/RegionDetail.vue` | `zoom, selectedPrefecture, playerCounts` |
| `<PrefectureList>` | `components/auth/PrefectureList.vue` | `prefectures: Prefecture[], selected: number` |
| `<StarterKitSelector>` | `components/auth/StarterKitSelector.vue` | `selectedKit: string` |
| `<StarterKitCard>` | `components/auth/StarterKitCard.vue` | `kit: string, selected: boolean` |

**Store** : `useRegistrationStore` (Pinia) — conserve l'état entre les étapes :
```typescript
interface RegistrationState {
  step: 1 | 2 | 3 | 4
  email: string | null
  username: string | null
  emailVerified: boolean
  prefectureId: number | null
  prefectureName: string | null
  regionName: string | null
  departmentName: string | null
  selectedKit: 'cultivator' | 'breeder' | 'versatile' | null
}
```

---

## Récapitulatif — API endpoints

| Endpoint | Méthode | Étape | Description |
|----------|---------|-------|-------------|
| `/api/auth/check-username?username=xx` | GET | 1 | Vérifier unicité pseudo |
| `/api/auth/check-email?email=xx` | GET | 1 | Vérifier unicité email |
| `/api/auth/register` | POST | 1 | Créer le compte |
| `/api/auth/resend-verification` | POST | 2 | Renvoyer l'email |
| `/api/auth/verify-email` | POST | 2 | Valider le token email |
| `/api/auth/verification-status` | GET | 2 | Polling statut vérification |
| `/api/regions` | GET | 3 | Liste des 13 régions + player_count |
| `/api/departments?region=XX` | GET | 3 | Départements d'une région |
| `/api/prefectures?department=XX` | GET | 3 | Préfectures d'un département |
| `/api/farms` | POST | 4 | Créer la ferme (prefecture_id + kit) |

---

## Récapitulatif — Transitions entre étapes

| De → Vers | Déclencheur | Animation | Condition |
|-----------|-------------|-----------|-----------|
| 1 → 2 | `POST /api/auth/register` succès | Slide left 300ms | Formulaire valide |
| 2 → 3 | Email vérifié (clic lien ou polling) | Slide left 300ms | Token valide |
| 3 → 4 | Clic "Confirmer cette localisation" | Slide left 300ms | Préfecture sélectionnée |
| 4 → Dashboard | `POST /api/farms` succès | Écran transition 1.5s → fade | Kit sélectionné + confirmé |

**Animation slide** :
```css
.step-enter-active, .step-leave-active { transition: all 300ms ease; }
.step-enter-from { opacity: 0; transform: translateX(30px); }
.step-leave-to { opacity: 0; transform: translateX(-30px); }
```

---

## Récapitulatif — États d'erreur globaux

| Situation | Comportement |
|-----------|-------------|
| Perte de connexion | Bandeau orange fixe en haut : "Connexion perdue. Vos données sont sauvegardées." |
| Erreur serveur 500 | Toast rouge "Une erreur est survenue. Réessayez." + bouton "Réessayer" |
| Session expirée (étape 3-4) | Modal : "Votre session a expiré. Reconnectez-vous." → redirect `/login` |
| Retour arrière navigateur | Le stepper revient à l'étape précédente (état conservé dans le store) |
| Refresh page | Le store `useRegistrationStore` est persisté en `sessionStorage` → reprise à l'étape en cours |

---

> **Cultivia — UX Inscription — v1.0**
> Réf: UX_PHASE0_1.md §1-3, 01_IDENTITE_VISUELLE.md, 03_IDENTITE_CULTIVIA.md §2-3
> Prochaine étape : implémentation des composants `src/client/components/auth/`
