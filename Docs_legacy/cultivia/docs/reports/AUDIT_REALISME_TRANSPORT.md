# Cultivia — Audit Réalisme Transport & Matériel

> **Date** : 2026-04-06
> **Source d'inspiration** : Règles SimAgri (docs/00-reference/regle sim.txt)
> **Impact** : 50 flows (25 corrigés + 2 nouveaux ticks)

## Principe directeur

Dans Cultivia, **toute action physique impliquant un déplacement de biens, d'animaux ou de matériel** doit respecter la chaîne réaliste :

1. **Véhicule requis** — tracteur + outil adapté (benne, bétaillère, plateau, citerne...)
2. **Véhicule fonctionnel** — non en panne (`is_broken = false`)
3. **Carburant HVC** — consommé proportionnellement à la distance
4. **Distance calculée** — haversine entre préfectures (joueur ↔ destination)
5. **Coût de transport** — proportionnel à la distance (€/km variable selon type)
6. **Usure véhicule** — augmentée à chaque utilisation
7. **Risque de panne** — si usure > 80%, 15% de chance de panne
8. **Temps de travail (HT)** — consommé pour le trajet
9. **Délai de transit** — les biens/animaux ne sont pas instantanément disponibles
10. **Écriture ledger** — toute opération financière est tracée

## Résumé des corrections par flow

### Sprint 3 — Bâtiments + Premier animal

| Flow | Correction | Détail |
|------|-----------|--------|
| F002 | ✅ Transport complet | Tracteur + bétaillère + HVC + distance + usure + panne + transit + ledger |
| F048 | ✅ Nouveau | Tick arrivée animaux en transit |

### Sprint 4 — Nourrir + Abreuver

| Flow | Correction | Détail |
|------|-----------|--------|
| F006 | ✅ Transport complet | Tracteur + benne + HVC + distance + usure + panne + idempotency + ledger |
| F008 | ✅ Idempotency | Protection double-clic |
| F009 | ✅ Idempotency | Protection double-clic |
| F010 | ✅ Idempotency | Protection double-clic |
| F050 | ✅ Nouveau | Tick livraison marchandises en transit |

### Sprint 5 — Soins + Vaccins

| Flow | Correction | Détail |
|------|-----------|--------|
| F012 | ✅ Idempotency + ledger | |
| F013 | ✅ Idempotency | |
| F014 | ✅ Idempotency + ledger | |
| F015 | ✅ Idempotency | |
| F016 | ✅ HVC + usure + panne + idempotency | Tracteur + épandeur pour sortir le fumier |

### Sprint 7 — Traite + Vente

| Flow | Correction | Détail |
|------|-----------|--------|
| F024 | ✅ Transport complet | Tracteur + citerne_lait + HVC + distance + usure + panne + idempotency + ledger |
| F025 | ✅ Transport complet | Tracteur + bétaillère + HVC + distance + usure + panne + idempotency + ledger |

### Sprint 8 — Déplacements + Employés

| Flow | Correction | Détail |
|------|-----------|--------|
| F027 | ✅ Ledger | Embauche = opération financière |
| F029 | ✅ HVC + usure + panne | Déplacement au pré = tracteur + bétaillère |

### Sprint 10 — Cultures

| Flow | Correction | Détail |
|------|-----------|--------|
| F035 | ✅ Idempotency | Achat parcelle (pas de transport physique) |
| F036 | ✅ Ledger | Analyse sol = coût financier |
| F037 | ✅ Panne check | Tracteur + outil sol |
| F038 | ✅ Usure + panne + idempotency + ledger | Tracteur + semoir |

### Sprint 11 — Engrais + Récolte + Vente

| Flow | Correction | Détail |
|------|-----------|--------|
| F039 | ✅ HVC + usure + panne | Tracteur + épandeur engrais |
| F040 | ✅ HVC + usure + panne + idempotency | Tracteur + pulvérisateur |
| F041 | ✅ Usure + panne | Moissonneuse + benne |
| F042 | ✅ Transport complet | Tracteur + benne + HVC + distance + usure + panne + idempotency + ledger |

### Sprint 12 — Matériels

| Flow | Correction | Détail |
|------|-----------|--------|
| F043 | ✅ Livraison concessionnaire | Délai basé sur distance, pas de véhicule joueur requis |
| F044 | ✅ Ledger | Entretien annuel = coût financier |
| F047 | ✅ Idempotency + ledger | Concessionnaire vient chercher, pas de transport joueur |
| F049 | ✅ Nouveau | Tick livraison matériel en delivery |

## Micro-dépendances (requires) — Catégories

```
vehicle:tractor        — tracteur fonctionnel
vehicle:trailer        — bétaillère fonctionnelle
vehicle:benne          — benne fonctionnelle
vehicle:moissonneuse   — moissonneuse fonctionnelle
vehicle:citerne_lait   — citerne à lait fonctionnelle
vehicle:epandeur       — épandeur fumier fonctionnel
vehicle:outil_sol      — charrue/herse/cultivateur
vehicle:semoir         — semoir fonctionnel
vehicle:epandeur_engrais — épandeur engrais
vehicle:pulverisateur  — pulvérisateur
vehicle:any            — au moins 1 véhicule (pour maintenance/vente)
fuel:hvc               — carburant HVC en stock
building:stabulation   — bâtiment d'élevage
building:silo          — silo de stockage
infra:salle_traite     — salle de traite
infra:cuve_lait        — cuve à lait
infra:cuve_eau         — cuve à eau
infra:fosse_fumier     — fosse à fumier
infra:fosse_lisier     — fosse à lisier
stock:aliments         — aliments en stock
stock:paille           — paille en stock
stock:lait             — lait en stock
stock:semences         — semences en stock
stock:engrais          — engrais en stock
stock:traitement       — produit phytosanitaire
stock:recolte          — récolte en stock
stock:piece_detachee   — pièce détachée
animal:any             — au moins 1 animal
animal:male            — mâle reproducteur
animal:female          — femelle
animal:gestante        — femelle gestante
animal:vache_laitiere  — vache en lactation
parcel                 — au moins 1 parcelle
parcel:pre             — parcelle de type pré
employee               — au moins 1 employé
kit:eleveur|polyvalent — kit de démarrage incluant bétaillère
```

## Formules de transport

| Type | Coût €/km | HVC L/km | HT/100km | Vitesse km/h |
|------|-----------|----------|----------|---------------|
| Animal (bétaillère) | 0.50 | 0.15 | 1.0 | 50 |
| Marchandise (benne) | 0.30 | 0.20 | 1.0 | 50 |
| Lait (citerne) | 0.30 | 0.20 | 1.0 | 50 |
| Livraison concessionnaire | 0.80 | — | — | 60 |

## Usure véhicule

- Chaque utilisation : `wear += distance_km × 0.02%` (transport) ou `wear += surface_ha × 0.5%` (travail parcelle)
- Si `wear > 80%` : 15% de chance de panne à chaque utilisation
- Panne : `is_broken = true`, nécessite réparation (F045)
- Entretien mensuel : `wear -= 5%` (F044)
- Entretien annuel : `wear -= 15%`, coût 500€ (F044)

## Décisions de design

1. **Acheter parcelle (F035)** — achat administratif, pas de transport physique
2. **Acheter matériel (F043)** — livré par concessionnaire avec délai, pas de véhicule joueur
3. **Vendre matériel (F047)** — concessionnaire vient chercher, pas de transport joueur
4. **Vendre lait/récolte (F024/F042)** — joueur transporte à la coopérative
5. **Vendre animal (F025)** — joueur transporte à l'abattoir avec bétaillère
6. **Entretenir/Réparer (F044/F045)** — le véhicule est la cible, pas l'outil (pas de check panne)
7. **Idempotency** — sur toutes les mutations POST qui modifient balance/ht/stock
8. **Kit de démarrage** — le kit Éleveur/Polyvalent inclut bétaillère, le Cultivateur non
