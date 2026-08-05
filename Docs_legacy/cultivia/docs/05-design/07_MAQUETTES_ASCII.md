# Maquettes ASCII — Pages clés

---

## Dashboard `/dashboard`

```
┌──────────────────────────────────────────────────────────────────────┐
│ 🌾 Cultivia    Animaux  Parcelles  Matériel  Marché  Finances       │
│                                    7 Avril — Printemps Année 1       │
│                                    ☀️ 18°C   💰 97 811€   ██████░ 32/40 HT │
├──────────┬───────────────────────────────────────────────────────────┤
│ 🏠 Dash  │  Bienvenue, Marcel !                                     │
│ ─ Élevage│                                                           │
│  🐄 Anim │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │
│  🏗️ Bâtim│  │ 💰 97 811€  │ │ ⏱️ 32/40 HT │ │ ☁️ 18°C     │        │
│  👷 Empl │  │ ↓ -189€     │ │ ████████░░  │ │ Demain: 🌧️  │        │
│ ─ Culture│  └─────────────┘ └─────────────┘ └─────────────┘        │
│  🌾 Parc │                                                           │
│  ☁️ Météo│  ┌─────────────────────────────┐ ┌─────────────────────┐ │
│ ─ Économ │  │ ⚠️ Alertes (3)              │ │ 📰 Actualités       │ │
│  💰 Finan│  │ 🍽️ 2 animaux pas nourris   │ │ Sophie a récolté    │ │
│  🛒 March│  │ ⚠️ HVC bas (30L)           │ │ 120T de blé !       │ │
│  🤝 Coop │  │ 🔴 Pailleuse en panne      │ │ Cours colza +8%     │ │
│ ─ Matéri │  └─────────────────────────────┘ └─────────────────────┘ │
│  🚜 Matér│                                                           │
│ ─ Social │  ┌──────────────────────────────────────────────────────┐ │
│  ✉️ Msg  │  │ 📊 Bilan du mois                                    │ │
│  🏆 Class│  │ Revenus: 2 240€  Charges: 1 850€  Marge: +390€     │ │
│  🔔 Notif│  └──────────────────────────────────────────────────────┘ │
└──────────┴───────────────────────────────────────────────────────────┘
```

---

## Inscription `/setup-farm`

```
┌──────────────────────────────────────────────────────────────────────┐
│ 🌾 Cultivia — Créez votre ferme                                     │
│                                                                      │
│  Étape 1 ──── Étape 2 ──── Étape 3 ──── Étape 4                    │
│  Compte ✅    Localisation  Kit          Confirmation                │
│                                                                      │
├──────────────────────────┬───────────────────────────────────────────┤
│                          │                                           │
│   ┌──────────────────┐   │  Région : Auvergne-Rhône-Alpes           │
│   │                  │   │  Département : Puy-de-Dôme               │
│   │   CARTE FRANCE   │   │                                           │
│   │   SVG interactive│   │  Préfecture :                             │
│   │                  │   │  ○ Clermont-Ferrand (23 joueurs)          │
│   │   [Auvergne]     │   │  ○ Riom (8 joueurs)                      │
│   │   sélectionné    │   │  ● Thiers (3 joueurs) ← sélectionné     │
│   │                  │   │  ○ Ambert (1 joueur)                      │
│   └──────────────────┘   │  ○ Issoire (5 joueurs)                    │
│                          │                                           │
│  Ou sélectionnez :       │  Distance au Marché Central : 420km      │
│  [Région        ▼]      │  Coût transport moyen : 210€              │
│  [Département   ▼]      │                                           │
│  [Préfecture    ▼]      │  [Suivant →]                              │
│                          │                                           │
└──────────────────────────┴───────────────────────────────────────────┘
```

---

## Fiche animal `/animals/:id`

```
┌──────────────────────────────────────────────────────────────────────┐
│ Dashboard > Animaux > Marguerite                                     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Marguerite ✏️              Montbéliarde    Femelle    14 mois       │
│  Poids: 650 kg              Lieu: Stabulation Nord     Lot: Laitières│
│                                                                      │
│  ┌─ Génétique ──────────┐  ┌─ Santé ───────────────────────────┐   │
│  │ Lait    ████████░░ 82│  │ ████████░░ 90/100                 │   │
│  │ Viande  ██████░░░░ 58│  │ Vaccinée ✅ (expire 42j)          │   │
│  │ Fertil. ███████░░░ 72│  │ Vermifugée ✅ (expire 30j)        │   │
│  │ Robust. ████████░░ 78│  │ Nourrie ✅  Abreuvée ✅            │   │
│  │ Morpho. ███████░░░ 74│  │ [Voir carnet santé →]             │   │
│  └───────────────────────┘  └───────────────────────────────────┘   │
│                                                                      │
│  ┌─ Production lait 🥛 ─┐  ┌─ Reproduction ────────────────────┐   │
│  │ Aujourd'hui: 28L     │  │ Période: ████████░░░░ Avr-Oct ✅  │   │
│  │ Moyenne 7j: 26L/jour │  │ Gestante: Non                     │   │
│  │ Qualité: ⭐⭐⭐⭐      │  │ Dernière mise bas: il y a 84j     │   │
│  │ [Voir historique →]   │  │ [Inséminer 1.0 HT]               │   │
│  └───────────────────────┘  │ [Inséminer CIA 200€]              │   │
│                              │ [Tarir] (grisé: pas gestante)     │   │
│  ┌─ Actions ─────────────┐  └───────────────────────────────────┘   │
│  │ [Peser ⚖️] [Soigner 100€] [Vacciner 50€] [Vermifuger 30€]  │   │
│  │ [Vendre abattoir 🔪 ~1512€] [Vendre P2P 📢] [Réformer 🏷️] │   │
│  └───────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Parcelle `/parcels/:id`

```
┌──────────────────────────────────────────────────────────────────────┐
│ Dashboard > Parcelles > Parcelle Nord (10ha)                         │
├──────────────────────────────────────────────────────────────────────┤
│ [Sol] [Culture] [Paille] [Fertilisation] [Gestion] [Historique]     │
├──────────────────────────────────────────────────────────────────────┤
│ Onglet: Culture                                                      │
│                                                                      │
│  État: 🌾 Blé en croissance (72%)  ████████████████░░░░░░           │
│  Semé le: 15 Oct    Maturité estimée: 8 Juil    Technique: Trad.   │
│                                                                      │
│  ┌─ Rendement estimé (UX-01) ──────────────────────────────────┐    │
│  │ Base blé                    7.0 T/ha                        │    │
│  │ × Semence certifiée         +10%  → 7.7  🟢                │    │
│  │ × Sol fertilité ★3          -5%   → 7.3  🔴                │    │
│  │ × Engrais NPK               OK    → 7.3  🟢                │    │
│  │ × Traitement fongicide       OK    → 7.3  🟢                │    │
│  │ × Traitement herbicide       ❌    → 6.6  🔴 (-10%)        │    │
│  │ × Irrigation                 OK    → 6.6  🟢                │    │
│  │ × Météo saison              -3%   → 6.4  🟡                │    │
│  │ × Roulage                   +4%   → 6.7  🟢                │    │
│  │ × Fatigue sol                OK    → 6.7  🟢                │    │
│  │ × Santé sol (indice 82)     +25%  → 8.4  🟢                │    │
│  │ ═══════════════════════════════════════════                  │    │
│  │ Estimé: 8.4 T/ha × 10ha = 84T (~16 800€ au cours actuel)   │    │
│  └──────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  Actions:                                                            │
│  [Traiter herbicide 450€] [Irriguer 12h] [Récolter] (grisé: 72%)   │
│  [Commander ETA ▸]                                                   │
└──────────────────────────────────────────────────────────────────────┘
```


---

## Liste animaux `/animals`

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ Dashboard > 🐄 Mes Animaux                                                  │
├──────────────────────────────────────────────────────────────────────────────┤
│ 📊 48 animaux │ 2 malades │ 3 non nourris │ 1 en transit │ 200🥚 à ramasser│
├──────────────────────────────────────────────────────────────────────────────┤
│ Espèce [Tous▼] Lot [Tous▼] Bâtiment [Tous▼] ⚠️ Action req. │ Grouper: [Lot▼]│
│                                                        [⚙️ Colonnes]       │
├────┬────────┬────────┬────┬─────────┬──────┬──────┬──────┬────────────────┬────────┬───────┤
│ ☐  │ Nom    │ Race   │Sexe│ Âge     │ Santé│Malade│Nourri│ Génétique      │ Prod.  │ Lot   │
├────┼────────┼────────┼────┼─────────┼──────┼──────┼──────┼────────────────┼────────┼───────┤
│    │ ▼ Lot: Laitières Nord (12)     │         │      │      │      │moy: L82 V58 F72│ 320L/j│       │
├────┼────────┼────────┼────┼─────────┼──────┼──────┼──────┼────────────────┼────────┼───────┤
│ ☐  │Marguer.│Montbél.│ F  │1a 2m 3s │██░90 │  —   │ ✅   │ L82 V58 F72 R78│ 28L/j  │Lait.N │
│ ☐  │Rosalie │Montbél.│ F  │1a 0m 1s │█░ 30 │ 🏥   │ ❌   │ L75 V62 F68 R70│ 0L/j   │Lait.N │
│ ☐  │Brutus  │Montbél.│ M  │3a 0m 0s │██100 │  —   │ ✅   │ L— V85 F90 R82 │ —      │Lait.N │
├────┼────────┼────────┼────┼─────────┼──────┼──────┼──────┼────────────────┼────────┼───────┤
│    │ ▼ Lot: Pondeuses (50)          │         │      │      │      │moy: P82 R78 F65│ 200🥚 │       │
├────┼────────┼────────┼────┼─────────┼──────┼──────┼──────┼────────────────┼────────┼───────┤
│ ☐  │#12     │Leghorn │ F  │1a 2m 0s │██100 │  —   │ ✅   │ P82 R78 F65 C60│ 4🥚/j  │Pond.  │
│ ☐  │#13     │Leghorn │ F  │0a 8m 2s │██ 95 │  —   │ ✅   │ P88 R72 F70 C55│ 5🥚/j  │Pond.  │
├────┼────────┼────────┼────┼─────────┼──────┼──────┼──────┼────────────────┼────────┼───────┤
│    │ ▼ Sans lot (3)                 │         │      │      │      │                │        │       │
├────┼────────┼────────┼────┼─────────┼──────┼──────┼──────┼────────────────┼────────┼───────┤
│ ☐  │Bella   │Charol. │ F  │2a 0m 0s │██100 │  —   │ ✅   │ L— V92 F80 R85 │+1.2kg/j│ —     │
├────┴────────┴────────┴────┴──────┴──────┴──────────────────┴────────┴───────┤
│ Actions: [Créer lot 📦] [Déplacer 🚜] [Nourrir batch 🍽️] [Fusionner lots]  │
│ Lot sélectionné: [Dissocier] [Renommer lot]                                 │
│ [20▼] par page │ ← 1 2 3 → │ 📥 CSV                                        │
└──────────────────────────────────────────────────────────────────────────────┘

Légende génétique : L=Lait V=Viande F=Fertilité R=Robustesse P=Ponte C=Croissance
Les colonnes génétique sont triables (clic header → trier par indice lait desc)
```

> **Règle UX :** Une seule page `/animals` avec groupement par lot (repliable). Pas de page `/animals/lots` séparée. Le dropdown "Grouper par" permet : Lot / Bâtiment / Espèce / Aucun. Les actions lot (fusionner, dissocier, renommer) apparaissent quand un lot est sélectionné.

## Bâtiments `/buildings`

```
┌──────────────────────────────────────────────────────────────────┐
│ Dashboard > 🏗️ Mes Bâtiments                                    │
├──────────────────────────────────────────────────────────────────┤
│ Catégorie [Tous▼]  ⚠️ Action requise  │ Vue: [Liste●] [Cartes○] │
├──────────────┬──────┬─────┬────────────────┬────────────────────┤
│ Bâtiment     │Taille│ Niv │ Occupé         │ Usure              │
├──────────────┼──────┼─────┼────────────────┼────────────────────┤
│ Stabulation N│100m² │  1  │ 15/33 🟡🛏️ 💩▓░│ ██░ 8%             │
│ Poulailler   │ 50m² │  1  │ 48/500 🟢🛏️    │ █░ 4%              │
│ Silo blé     │ 20T  │  1  │ 8/20T          │ —                  │
│ Cuve eau     │10 kL │  —  │ 7.2/10k 💧     │ —                  │
│ Cuve HVC     │ 2 kL │  —  │ 450/2k ⚠️ bas  │ —                  │
│ Fosse fumier │ 20T  │  —  │ 8/20T          │ —                  │
│ Salle traite │4 post│  1  │ —              │ —                  │
│ Cuve lait    │500L  │  —  │ 320/500        │ —                  │
│ Hangar       │ 50m² │  1  │ 6/8 🚜         │ —                  │
├──────────────┴──────┴─────┴────────────────┴────────────────────┤
│ [20▼] par page │ [⚙️ Colonnes] │ [Construire un bâtiment →]     │
└──────────────────────────────────────────────────────────────────┘
```

> **Règle UX :** Liste par défaut. Toggle cartes disponible pour les joueurs qui préfèrent (mémorisé localStorage). La liste est plus efficace dès 5+ bâtiments.

## Matériel `/equipment`

```
┌──────────────────────────────────────────────────────────────────┐
│ Dashboard > 🚜 Mon Matériel                                      │
├──────────────────────────────────────────────────────────────────┤
│ Catégorie [Tous▼]  ⚠️ Action requise  │ [⚙️ Colonnes]            │
├──────────────────────┬──────────┬──────────────┬────────────────┤
│ Matériel             │ Marque   │ Usure        │ Argus          │
├──────────────────────┼──────────┼──────────────┼────────────────┤
│ Tracteur 100CV       │N.Holland │ ██░░ 52%     │ 14 875€        │
│ Moissonneuse 280 ⚠️🌧️│ Claas    │ ████ 72% ⚠️  │ 51 000€        │
│ Pailleuse 🔴         │ Kuhn     │ █████ 85%    │  2 550€        │
│ Citerne lait         │ Joskin   │ █░░░ 40%     │  4 800€        │
├──────────────────────┴──────────┴──────────────┴────────────────┤
│ [Acheter neuf →] [Marché occasion →]                             │
└──────────────────────────────────────────────────────────────────┘
```

## Finances `/finances`

```
┌──────────────────────────────────────────────────────────────────┐
│ Dashboard > 💰 Finances                                          │
├──────────────────────────────────────────────────────────────────┤
│ Solde: 97 811€  │  Plancher: -30 000€  │  Prêt en cours: 50 000€│
├──────────────────────────────────────────────────────────────────┤
│ [Relevé] [P&L mensuel] [Épargne] [Prêts]                        │
├──────────────────────────────────────────────────────────────────┤
│ Onglet: P&L mensuel                                              │
│ ┌────────────┬──────────┬──────────┬──────────┐                  │
│ │ Mois       │ Revenus  │ Charges  │ Marge    │                  │
│ ├────────────┼──────────┼──────────┼──────────┤                  │
│ │ Avril      │  2 240€  │  1 850€  │  +390€   │                  │
│ │ Mai        │  2 480€  │  1 920€  │  +560€   │                  │
│ │ Juin       │  2 680€  │  2 100€  │  +580€   │                  │
│ └────────────┴──────────┴──────────┴──────────┘                  │
│ 📊 [Graphique barres empilées revenus vs charges]                │
│                                                                  │
│ 📊 Prélèvements prévus lundi :                                   │
│   Salaires 1 600€ + Prêt 850€ + Énergie 120€ = 2 570€          │
│   Solde après: 95 241€ ✅                                        │
└──────────────────────────────────────────────────────────────────┘
```

## Marché `/market/prices`

```
┌──────────────────────────────────────────────────────────────────┐
│ Dashboard > 🛒 Cours du Marché                                   │
├──────────────────────────────────────────────────────────────────┤
│ Catégorie [Tous▼]  Tendance [Tous▼]                              │
├──────────────┬────────┬──────────┬──────────┬───────────────────┤
│ Produit      │ Prix   │ Var. 7j  │ Tendance │ Sparkline 30j     │
├──────────────┼────────┼──────────┼──────────┼───────────────────┤
│ Blé          │ 210€/T │ 📈 +5%  │ Vendre ! │ ╱╲╱──╱╲╱╱        │
│ Colza        │ 385€/T │ 📉 -3%  │ Attendre │ ╲╱╲──╲╱╲╲        │
│ Lait bovin   │ 0.33€/L│ 📈 +2%  │ Stable   │ ──╱──╱──         │
│ Œufs         │ 0.14€  │ ── 0%   │ Stable   │ ────────         │
│ Viande bovine│ 4.60€/k│ 📈 +4%  │ Vendre ! │ ╱╱╱──╱╱          │
└──────────────┴────────┴──────────┴──────────┴───────────────────┘
```

## Météo `/weather`

```
┌──────────────────────────────────────────────────────────────────┐
│ Dashboard > ☁️ Météo — Clermont-Ferrand                          │
├──────────────────────────────────────────────────────────────────┤
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐              │
│ │ Aujourd'hui  │ │ Demain       │ │ Après-demain │              │
│ │ ☀️ 18°C      │ │ 🌧️ 14°C      │ │ ⛅ 16°C      │              │
│ │ Pluie: 0mm   │ │ Pluie: 12mm  │ │ Pluie: 3mm   │              │
│ │ Vent: faible │ │ Vent: modéré │ │ Vent: faible │              │
│ └──────────────┘ └──────────────┘ └──────────────┘              │
│                                                                  │
│ ⚠️ Demain: pluie forte — pas de pulvérisation possible           │
└──────────────────────────────────────────────────────────────────┘
```

## Classements `/rankings`

```
┌──────────────────────────────────────────────────────────────────┐
│ Dashboard > 🏆 Classements                                       │
├──────────────────────────────────────────────────────────────────┤
│ [Général] [Élevage] [Cultures] [Finances] [Génétique]           │
│ Filtre: [National▼] [Tous niveaux▼]                              │
├──────┬────────────┬──────────────┬───────────┬──────────────────┤
│ Rang │ Joueur     │ Préfecture   │ Score     │ Spécialité       │
├──────┼────────────┼──────────────┼───────────┼──────────────────┤
│ 🥇 1 │ Sophie     │ Chartres     │ 12 450    │ Cultivateur      │
│ 🥈 2 │ Marcel     │ Clermont-Fd  │ 11 200    │ Éleveur          │
│ 🥉 3 │ Karim      │ Lyon         │ 10 800    │ Polyvalent       │
│   4  │ Lucie      │ Rennes       │  9 500    │ Éleveur          │
└──────┴────────────┴──────────────┴───────────┴──────────────────┘
```
