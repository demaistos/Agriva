# Corrections appliquées — Audit de cohérence GDD

> Date : 2026-08-04
> Agent : fix_gdd_core
> Source de vérité : `docs/design/GDD-SOURCE-VERITE.md`
> Rapport d'audit : `docs/design/AUDIT-FINAL-COHERENCE.md`

---

## Résumé

**12 incohérences CRITIQUES corrigées** dans 3 fichiers :
- `GDD-core-temporalite.md` — 4 critiques + 2 mineures
- `GDD-gouvernance-serveur.md` — 3 critiques
- `etude-economique-profils-joueurs.md` — 5 critiques + 3 mineures

---

## Corrections détaillées

### `GDD-core-temporalite.md`

| # Audit | Correction | Détail |
|:-------:|-----------|--------|
| 6 | Heure du tick | `06:00 UTC` → `00:00 heure française` (23:00 UTC hiver / 22:00 UTC été). Corrigé dans : diagramme gameplay loop, §5.2 tableau, §5.5 rattrapage indisponibilité, Annexe A.1, mockup interface. |
| 7 | Budget d'heures | Harmonisé employé à **7h/jour** partout (texte et annexe). Ajouté note renvoyant à SdV §4 (~40-50 HT/jour de base). Corrigé formule `capacité_jour`. |
| 8 | Protection hors-ligne — mort animale | Supprimé « Aucun animal ne meurt » (santé plancher 30). Remplacé par : **animaux meurent en ~2 semaines sans nourriture** (SdV §12), Normal comme Expert. Auto-achat de secours (Normal) retarde mais n'empêche pas la mort. §6.1, §6.2, §6.3, §6.6, Annexe A.3 corrigés. |
| 12 | Tableau Normal/Expert §1.4 — rattrapage absence | Supprimé « Aucune perte pendant 14 jours ». Remplacé par la règle uniforme de mort animale (SdV §12). |
| 15 (mineur) | Incohérence interne 8h vs 7h employé | Harmonisé à 7h/jour partout (texte, formule, annexe A.2). |
| 16 (mineur) | Maximum 5 salariés | Maintenu 5 (déjà dans le texte et l'annexe). Note : la SdV ne fixe pas de maximum. |

### `GDD-gouvernance-serveur.md`

| # Audit | Correction | Détail |
|:-------:|-----------|--------|
| 9 | Dotation Expert | `80 000€` → `150 000€` (SdV §3 : identique pour tous les kits). Corrigé dans l'annexe §9. |
| 10 | Marchés segmentés par ligue | **Supprimé** le §3.5 « Marchés segmentés par ligue » (4 ligues, prix plafonnés). Remplacé par §3.5 « Marché unique — carnet d'ordres » (SdV §3). |
| 11 | Mécanismes de rattrapage artificiel | **Supprimé** : capacité de travail majorée (+2h/j × 90j), réduction intrants (−20% × 180j), accès terres réservées « zone JA ». Remplacé par §3.4 conforme à SdV §19 (« Pas de rattrapage artificiel »). Seuls subsistent : dotation initiale, kit, prêt JA, aide CESA post-formation. Annexe §9 mise à jour. |

### `etude-economique-profils-joueurs.md`

| # Audit | Correction | Détail |
|:-------:|-----------|--------|
| 1 | Capital de départ | `~50 000 €` → `150 000 €` (SdV §3). Corrigé dans hypothèses de base et toutes les projections financières (céréalier, allaitant). |
| 2 | HT par jour | `50-80 HT (modèle SimAgri)` → `~40-50 HT/jour de base` (SdV §4) avec renvoi à l'équilibrage. |
| 3 | PAC / DPB | `~250 €/ha en moyenne` → `150 €/ha (Normal)` (SdV §3). |
| 4 | Investissement initial céréalier | `40 000-80 000 € (matériel d'occasion)` → Référence au Kit Cultivateur (SdV §5) : matériel fourni, pas d'achat initial. |
| 5 | 5 profils → 4 kits | Ajouté référence aux 4 kits SdV §5 dans hypothèses et tableau comparatif §6. Clarifié que Porcin/Allaitant sont des orientations stratégiques, pas des kits séparés. |
| 19 (mineur) | Aviculteur départ | `10 poules + 1 coq` → `20 poules + 2 coqs` (SdV §5 Kit Aviculteur). Corrigé dans config type, loop de multiplication, table de croissance §7.2, et résumé. |
| 20 (mineur) | Monétisation | Ajouté dans hypothèses : `Gratuit (100% mécaniques) + Premium 3,99€/mois (confort/cosmétique, SdV §8)`. |

---

## Bandeaux d'avertissement ajoutés

Les fichiers suivants ont reçu le bandeau :
```
> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.
```

- ✅ `GDD-core-temporalite.md` (ajouté)
- ✅ `GDD-gouvernance-serveur.md` (ajouté)
- ✅ `etude-economique-profils-joueurs.md` (déjà présent, dédupliqué)
- ✅ `GDD-materiel.md` (déjà présent)
- ✅ `GDD-economie-base.md` (déjà présent)

---

## Vérification post-correction

| Terme recherché | Résultat | Statut |
|----------------|----------|--------|
| "Points d'Action" (hors SdV) | 0 occurrence | ✅ |
| "100 000" comme capital de départ | 0 occurrence (les 100 000€ restants = prix bâtiments/équipement) | ✅ |
| "3 kits" | 0 occurrence | ✅ |
| "06:00 UTC" comme heure de tick | 0 occurrence | ✅ |
| "50 000" comme capital de départ | 0 occurrence | ✅ |
| Marchés segmentés / par ligue | 0 occurrence (hors interdiction explicite) | ✅ |
| Rattrapage artificiel autorisé | 0 occurrence (uniquement en ❌ interdit) | ✅ |
| Animaux ne meurent jamais (Normal) | 0 occurrence | ✅ |

---

## Incohérences MINEURES non corrigées (hors scope)

| # | Fichier | Raison |
|:-:|---------|--------|
| 13 | `GDD-economie-base.md` §7.2 | Scénario d'exemple qui mentionne "acheter tracteur" après kit — cohérent si c'est un upgrade post-départ |
| 14 | `GDD-materiel.md` §7.5 | Progression type ANNÉE 1-2 — sera naturellement recadrée par le kit de départ lors de l'implémentation |
| 17 | `GDD-economie-base.md` §5.3 | Prix coop "×0.97" vs "prix fixe" — ambiguïté mineure à clarifier ultérieurement |

---

## Historique

| Date | Action |
|------|--------|
| 2026-08-04 | Corrections appliquées suite à l'audit AUDIT-FINAL-COHERENCE.md |
