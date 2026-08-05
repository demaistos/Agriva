# AUDIT FINAL DE COHÉRENCE — GDD vs Source de Vérité

> Date : 2026-08-04
> Auditeur : agent:audit_coherence
> Source de vérité : `docs/design/GDD-SOURCE-VERITE.md`
> Statut : **TERMINÉ — incohérences identifiées**

---

## Résumé

| Sévérité | Nombre |
|----------|:------:|
| 🔴 CRITIQUE (contredit la source de vérité) | 12 |
| 🟡 MINEUR (formulation ambiguë ou imprécise) | 8 |
| **TOTAL** | **20** |

---

## Tableau des incohérences

### 🔴 CRITIQUE — Contredit directement la Source de Vérité

| # | Fichier | Section / Zone | Problème | Correction nécessaire |
|:-:|---------|---------------|----------|----------------------|
| 1 | `etude-economique-profils-joueurs.md` | §Hypothèses de base — "Capital départ joueur" | Indique **~50 000 €** (estimation SimAgri-like, à confirmer) | Corriger en **150 000 €** (SdV §3) |
| 2 | `etude-economique-profils-joueurs.md` | §Hypothèses de base — "HT par jour" | Indique **50-80 HT** (modèle SimAgri) — utilise le terme "HT" comme unité de points, pas d'heures réelles | Clarifier que le système est en **Heures de Travail calculées** (budget ~40-50 HT/jour de base mais dépendant du matériel). Le concept de "50-80 HT (modèle SimAgri)" est obsolète ; renvoyer au GDD-core-temporalite §4 |
| 3 | `etude-economique-profils-joueurs.md` | §Hypothèses de base — "PAC" | Indique **~250 €/ha en moyenne** | La SdV §3 donne le DPB à **150 €/ha** (Normal). Le 250 €/ha ne correspond à aucun paramètre validé |
| 4 | `etude-economique-profils-joueurs.md` | §1 Céréalier — "Investissement initial" | Indique **40 000-80 000 €** de matériel d'occasion pour le départ céréalier | Incohérent avec le **Kit Cultivateur** de la SdV §5 qui donne un kit complet (tracteur 120CV, charrue, herse, semoir, moissonneuse 280CV, benne, hangar, silo). Le joueur reçoit un kit, il n'achète pas son matériel de départ. |
| 5 | `etude-economique-profils-joueurs.md` | §Tableau comparatif 6 — profils de départ | Ne mentionne que les profils Céréalier, Laitier, Allaitant, Volaille, Porcin. Pas de profil **Polyvalent** | La SdV §5 définit **4 kits** : Cultivateur, Éleveur, Aviculteur, Polyvalent. L'étude doit être alignée sur ces 4 kits |
| 6 | `GDD-core-temporalite.md` | §5.2 — Heure du tick | Indique **06:00 UTC** (08:00 Paris) | La SdV §2 spécifie le tick à **minuit (00:00 heure française)**. Incohérence directe. |
| 7 | `GDD-core-temporalite.md` | §4.2 — Budget d'heures par tick | Indique "budget quotidien" de 6-12h/jour selon saison (exploitant variable) et employé à **7h/jour** | La SdV §4 indique un budget de **~40-50 HT/jour** (calibrage en phase d'équilibrage). Le GDD temporalité utilise 12h/jour × 7 = 84h/tick et employé à 8h (§4.2 texte) mais 7h (annexe A.2). Incohérence interne ET avec la SdV. |
| 8 | `GDD-core-temporalite.md` | §6.1 + §6.2 — Protection hors-ligne (Normal) | Indique qu'en Normal **les animaux ne meurent JAMAIS** (santé plancher 30) | La SdV §12 spécifie clairement : **animaux meurent en ~2 semaines sans nourriture** (J10-14 → mort). La protection absolue du Normal contredit la SdV qui ne différencie pas Normal/Expert sur la mort. |
| 9 | `GDD-gouvernance-serveur.md` | §9 Annexe — "Dotation initiale Expert" | Indique **80 000 €** pour le serveur Expert | La SdV §3 dit **150 000 € identique pour tous les kits**. Ne mentionne aucune différence entre serveurs sur le capital de départ. |
| 10 | `GDD-gouvernance-serveur.md` | §3.4 — "Marchés segmentés par ligue" | Introduit un système de marchés segmentés (Découverte, Développement, Confirmé, Expert) avec prix plafonnés | La SdV §3 définit le marché joueurs comme un **carnet d'ordres** unique (order book avec matching automatique). Pas de segmentation par ancienneté. Contradicts aussi SdV §19 : **Pas de rattrapage artificiel** |
| 11 | `GDD-gouvernance-serveur.md` | §3.4 — "Mécanismes de rattrapage pour les nouveaux" | Introduit : capacité de travail majorée (+2h/j × 90j), réduction intrants (-20% × 180j), accès terres réservées, etc. | La SdV §19 est explicite : **« Pas de rattrapage artificiel. Pas de bonus, pas de protection, pas de catch-up mécanique. »** Tous ces mécanismes violent cette règle. |
| 12 | `GDD-core-temporalite.md` | §1.4 — Différence Normal/Expert — "Rattrapage absence" | Indique en Normal : **"Aucune perte pendant 14 jours"** et en Expert : "Dégradation lente après 7 jours" | La SdV §12 ne fait AUCUNE distinction Normal/Expert sur la mort des animaux : 2 semaines sans nourriture = mort, point. Le GDD temporalité crée une protection qui n'existe pas dans la SdV. |

---

### 🟡 MINEUR — Formulation ambiguë ou extension non validée

| # | Fichier | Section / Zone | Problème | Correction suggérée |
|:-:|---------|---------------|----------|---------------------|
| 13 | `GDD-economie-base.md` | §7.2 Scénario A — "Solde initial : 150 000 €" | Correct (150 000 €) mais indique que le joueur achète ensuite "tracteur 120 CV d'occasion (45 000 €) + outils de base (25 000 €)" | Clarifier que le joueur reçoit un **kit** (SdV §5) et ne commence pas avec 150k€ cash à tout acheter. Le scénario devrait partir du kit. |
| 14 | `GDD-materiel.md` | §7.5 — Progression matérielle type | Indique "ANNÉE 1-2 : tracteur 110 CV d'occasion (35 000 €) + outils de base (25 000 €) → Investissement : 60 000 €" | Ambiguïté : le joueur commence avec un Kit (SdV §5), pas de zéro. La progression devrait partir de l'état du kit. |
| 15 | `GDD-core-temporalite.md` | §4.2 — "Salarié : 8 h/jour" (texte) vs "7 h" (annexe A.2) | Incohérence **interne** au document. Le texte principal dit 8h, l'annexe dit 7h | Harmoniser. La SdV §4 parle d'employés qui « fournissent des heures » sans préciser le montant exact — renvoyer à l'équilibrage. |
| 16 | `GDD-core-temporalite.md` | §4.2 — "Maximum 5 salariés" | Le GDD gouvernance (§9 annexe) indique un plafond de **10 employés** (Normal) / **8** (Expert) | Aligner : la SdV ne précise pas de maximum d'employés. Si le GDD gouvernance fixe 10/8, le GDD temporalité doit être mis à jour. |
| 17 | `GDD-economie-base.md` | §5.3 — Canaux de vente — "Coopérative : prix_marché × 0.97" | Ambiguïté : la SdV §3 dit que la coopérative achète/vend à **prix fixe** (filet de sécurité). "prix_marché × 0.97" implique un prix variable. | Clarifier : la coop vend à prix FIXE (SdV), pas à un discount du prix marché. |
| 18 | `GDD-materiel.md` | §1 — "~200 matériels, 45+ marques réelles" | Non mentionné dans le GDD matériel lui-même, mais cohérent avec la SdV §18 | OK mais à vérifier que le catalogue du GDD-materiel est bien compatible avec ce volume. Pas d'incohérence directe mais formulation absente. |
| 19 | `etude-economique-profils-joueurs.md` | §4 — Profil Aviculteur | Indique "10 poules + 1 coq" comme départ | La SdV §5 spécifie le Kit Aviculteur avec **20 poules + 2 coqs** + tracteur 50CV + poulailler 50m² + hangar 100m². L'étude sous-estime le kit de départ. |
| 20 | `etude-economique-profils-joueurs.md` | Toute l'étude | L'étude ignore la monétisation **Gratuit + Premium 3,99€** et ne mentionne jamais que l'automatisation (robots, employés) est du gameplay pur | Ajouter une note de cohérence avec SdV §8, §13 : aucun avantage économique Premium, l'automatisation est un investissement in-game. |

---

## Synthèse par document

| Document | 🔴 Critiques | 🟡 Mineurs | Évaluation |
|----------|:---:|:---:|:---|
| `GDD-core-temporalite.md` | 4 | 2 | ⚠️ Heure du tick fausse, protection hors-ligne contredit la SdV sur mort animaux |
| `GDD-economie-base.md` | 0 | 2 | ✅ Globalement cohérent, quelques ambiguïtés sur prix coop et scénarios |
| `GDD-materiel.md` | 0 | 1 | ✅ Très cohérent avec la SdV |
| `GDD-gouvernance-serveur.md` | 3 | 0 | ⚠️ Marchés segmentés et mécanismes de rattrapage violent la SdV |
| `etude-economique-profils-joueurs.md` | 5 | 3 | 🔴 Document le plus incohérent : capital de départ faux, kits ignorés, PAC fausse |

---

## Paramètres vérifiés — Conformes ✅

| Paramètre SdV | Statut dans les GDD |
|----------------|:---:|
| 1 semaine réelle = 1 mois IG | ✅ Correct partout |
| Système = HT / Heures de Travail (pas PA) | ✅ Tous les GDD utilisent HT (sauf étude éco qui mélange) |
| Monétisation = Gratuit sans pub + Premium 3,99€ | ✅ Non contredit (peu mentionné) |
| Marché = carnet d'ordres | ✅ GDD-economie §5 conforme |
| 2 serveurs (Normal + Expert) | ✅ GDD-gouvernance conforme |
| Météo = simulation statistique | ✅ GDD-core-temporalite conforme |
| Automatisation = gameplay (employés/robots) | ✅ GDD-materiel et temporalite conformes |
| Construction bâtiment = seul skip Premium autorisé | ✅ Non contredit |
| 10 parcelles/mois IG, réservées 5j, taille aléatoire, prix fixe | ✅ Non contredit |
| Coop = prix fixe | ⚠️ Ambigu dans GDD-economie (voir #17) |

---

## Recommandations prioritaires

1. **URGENT** — Corriger l'heure du tick dans `GDD-core-temporalite.md` : 06:00 UTC → minuit heure française (23:00 UTC hiver / 22:00 UTC été)
2. **URGENT** — Supprimer tous les mécanismes de rattrapage artificiel dans `GDD-gouvernance-serveur.md` (§3.4) ou les re-qualifier comme mécanismes qui ne sont PAS du rattrapage au sens de la SdV
3. **URGENT** — Aligner la protection hors-ligne (Normal) avec la SdV : les animaux PEUVENT mourir en 2 semaines même en Normal
4. **URGENT** — Réécrire `etude-economique-profils-joueurs.md` en partant des 4 kits à 150 000 € de la SdV
5. **MOYEN** — Supprimer les marchés segmentés par ligue (§3.5 gouvernance) — incompatible avec le carnet d'ordres unique
6. **MOYEN** — Harmoniser les heures employé (7h vs 8h) dans le GDD temporalité
7. **MOYEN** — Clarifier le prix coop (fixe vs % du marché) dans le GDD économie

---

## Historique

| Date | Action |
|------|--------|
| 2026-08-04 | Audit initial — 20 incohérences identifiées (12 critiques, 8 mineures) |
