# Catalogue composants UI — Cultivia Design System

> Chaque composant avec ses props, états, et exemple d'utilisation.
> Servira de base pour le Storybook (Sprint 03).

---

## Base

### CButton
```vue
<CButton label="Acheter 500€" :loading="false" :disabled="true" tooltip="Solde insuffisant" variant="primary|danger|ghost" />
```
| Prop | Type | Description |
|------|------|-------------|
| label | string | Texte du bouton (supporte {variables}) |
| loading | boolean | Spinner + disabled pendant l'appel API |
| disabled | boolean | Grisé |
| tooltip | string | Affiché au survol si disabled |
| variant | string | primary (vert), danger (rouge), ghost (transparent) |

### CModal
```vue
<CModal :open="show" title="Confirmer" @confirm="onConfirm" @cancel="show=false">
  <p>⚠️ Action irréversible</p>
</CModal>
```

### CToast
```vue
// Appelé via composable useToast()
const { toast } = useToast()
toast.success('🐄 Marguerite achetée !', { duration: 5000 })
toast.error('Solde insuffisant')
```
- Durée : 5s par défaut, clic pour fermer
- Position : bas-droite
- Historique dans /notifications

### CInput / CSelect / CToggle
Composants formulaire standard avec validation, aria-labels, états erreur.

---

## Données

### CDataTable
```vue
<CDataTable :columns="cols" :data="rows" :filters="filters" :pagination="{ page: 1, perPage: 20 }" sortable exportCsv customizableColumns>
  <template #cell-health="{ value }">
    <CGauge :value="value" :max="100" />
  </template>
</CDataTable>
```
| Prop | Type | Description |
|------|------|-------------|
| columns | Column[] | { key, label, sortable, width, defaultVisible } |
| data | any[] | Données |
| filters | Filter[] | { key, type: 'select'\|'text', options } |
| pagination | object | { page, perPage: 20\|50\|100 } |
| sortable | boolean | Tri par colonne |
| exportCsv | boolean | Bouton 📥 (Licence Pro) |
| customizableColumns | boolean | Bouton ⚙️ Colonnes (choix + ordre, sauvé localStorage) |
| groupBy | string? | Clé de groupement (ex: 'lot_name') → sections repliables |

Mode responsive : tableau > 1024px, cartes < 1024px.

**Format âge :** `Xa Ym Zs` (années, mois Cultivia, semaines). Ex: `1a 2m 3s` = 1 an 2 mois 3 semaines Cultivia.

### CGauge
```vue
<CGauge :value="72" :max="100" :thresholds="[30, 70]" label="Usure" />
```
Vert < 30%, orange 30-70%, rouge > 70%.

### CProgressBar
```vue
<CProgressBar :value="32" :max="40" label="HT" />
```

---

## Jeu

### CHTBar
Barre HT dans le header. Animée quand HT change.
```vue
<CHTBar :current="32" :max="40" />
```

### CBalanceDisplay
Solde animé (défilement chiffres).
```vue
<CBalanceDisplay :value="97811" :previous="98000" />
```

### CWeatherWidget
Météo 3 jours + alerte.
```vue
<CWeatherWidget :forecast="[{day, temp, rain, sun}]" :alert="'gel'" />
```

### CSeasonIndicator
Couleur + texte saison.
```vue
<CSeasonIndicator season="spring" />
```
Printemps=vert, Été=orange, Automne=rouge, Hiver=bleu. Texte toujours affiché (a11y).

### CAnimalCard / CParcelCard / CBuildingCard / CVehicleCard
Cartes résumé pour le mode responsive (< 1024px).

### CBreadcrumb
```vue
<CBreadcrumb :items="[{label:'Dashboard',to:'/'},{label:'Animaux',to:'/animals'},{label:'Marguerite'}]" />
```

### CFranceMap
Carte SVG interactive pour l'inscription. Régions cliquables → zoom départements → liste préfectures.

### CYieldBreakdown
Breakdown 9 facteurs rendement (UX-01).
```vue
<CYieldBreakdown :factors="[{name:'Base',value:7,unit:'T/ha'},{name:'Semence certifiée',bonus:'+10%'},...]" />
```

### CLotSelector
Sélection multiple d'animaux pour créer/gérer des lots.

---

## Composables (hooks)

| Composable | Usage |
|-----------|-------|
| `useToast()` | `toast.success(msg)`, `toast.error(msg)` |
| `useAuth()` | `login()`, `logout()`, `player`, `isAuthenticated` |
| `useIdempotency()` | `generateKey()` → UUID v4 pour X-Idempotency-Key |
| `useWebSocket()` | `on('balance_update', cb)`, auto-reconnect |
| `useConfirm()` | `confirm({ title, message, warnings })` → Promise<boolean> |


### CFeedCalculator
Calculateur consommation aliments sur la page achat.
```vue
<CFeedCalculator :animals="10" :species="'bovins'" :ration="currentRation" />
```
Affiche : "10 vaches × 25kg/jour = 250kg/jour = 1.75T/semaine = 7T/mois"

### CHTHistory
Tooltip sur la barre HT montrant l'historique du jour.
```vue
<CHTHistory :actions="[{name:'Nourrir',cost:1.5},{name:'Traire',cost:1.0}]" />
```
Affiche : "Nourrir -1.5 | Traire -1.0 | Transport -2.8 | Reste 34.7/40"

### CMilkingClock
Horloge visuelle des 4 créneaux de traite.
```vue
<CMilkingClock :currentSlot="2" :lastMilkedSlot="1" />
```
Barre 4 segments : [✅ fait] [🟢 en cours] [⬜ à venir] [⬜ à venir]

### CProductionDiagnostic
Diagnostic production en baisse sur fiche animal.
```vue
<CProductionDiagnostic :animal="animal" :trend="-12%" />
```
Affiche : "📉 Production en baisse (-12%). Cause probable : ration ★2 (recommandé ★4)"
