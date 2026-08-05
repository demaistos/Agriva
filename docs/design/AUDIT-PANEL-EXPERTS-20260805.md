# Audit GDD par Panel d'Experts — Synthèse et Corrections

> Date : 2026-08-05
> Statut : Validé — corrections appliquées
> Panel : 5 experts (économie MMO, architecture backend, UX/rétention, vétéran SimAgri, monétisation F2P)

---

## Notes globales du panel

| Expert | Note | Spécialité |
|--------|:----:|------------|
| Game Economy Designer | 6/10 | Économie persistante (EVE, Albion, RuneScape) |
| Lead Backend Architect | 7/10 | Gaming backend, PostgreSQL à l'échelle |
| UX/Product Designer | 6.5/10 | Jeux de gestion mobile-first, rétention D7/D30 |
| Joueur vétéran SimAgri | 8/10 nostalgie | 8 ans, top 10 serveur, exploits connus |
| Consultant Monétisation F2P | 6/10 | Jeux de niche européens, modèles d'abonnement |

**Note moyenne : 6.7/10** — Base solide, 6 problèmes critiques identifiés et corrigés.

---

## Findings CRITIQUES — Corrigés

### C1. Robot de traite dans l'abonnement = P2W perçu

**Problème** : Le robot libère 17-31 HT/tick. Un abonné peut diversifier plus qu'un F2P. Viole la règle ±5%.

**Correction appliquée** :
- ✅ Robot de traite accessible à TOUS (achat IG 150-180k€, pas de prérequis abo)
- ✅ AgriPass donne seulement -20% sur l'entretien du robot (cosmétique économique, pas productif)
- ✅ Mis à jour dans `GDD-SOURCE-VERITE.md` §22

### C2. Manque de sinks late-game (tout acheté en 12-18 mois)

**Problème** : Viticulture (500k) + méthaniseur (400k) = achetés en 12-18 mois. Plus rien à viser.

**Correction appliquée** :
- ✅ Ajout sinks récurrents : entretien annuel viticulture 30k€, maintenance méthaniseur 15k€
- ✅ Ajout sinks sociaux : projets communautaires coopérative joueurs (infrastructure collective à millions)
- ✅ Ajout sinks prestige : manoir, parc paysager, collection vintage (cosmétique-endgame)
- ✅ Mis à jour dans `GDD-SOURCE-VERITE.md` §21

### C3. Silence mid-cycle culture (3 semaines sans feedback)

**Problème** : Entre semis et récolte, le joueur n'a rien à faire sur ses parcelles pendant 3 semaines réelles.

**Correction appliquée** :
- ✅ Ajout dans `GDD-SOURCE-VERITE.md` §25 : milestones visuels (levée J+3, tallage J+7, épiaison J+14)
- ✅ Décisions intermédiaires optionnelles (fongicide, désherbage, observation)
- ✅ Encouragement multi-parcelles à cycles décalés dans l'onboarding

### C4. Mobile : 3 écrans insuffisants

**Problème** : 50% des joueurs (éleveurs/aviculteurs) n'ont pas leur écran principal en mobile-first.

**Correction appliquée** :
- ✅ Extension à Top 5 mobile-first : Dashboard, Parcelle, Marché, Élevage, Récap Connexion
- ✅ Mis à jour dans `GDD-SOURCE-VERITE.md` §26

### C5. Incohérences numériques entre documents

**Problème** : Prix plancher 60% vs 80% selon les documents. Plafond 200% vs 250%.

**Correction appliquée** :
- ✅ Valeur canonique fixée dans `GDD-SOURCE-VERITE.md` : plancher = 80%, plafond = 200%
- ✅ Ajout anti-manipulation : volume max détenu = 10× production mensuelle, taxe stockage 2%/semaine au-delà
- ✅ Decay temporel plafond : -5%/tick sans transaction en 7j IG

### C6. Dimension sociale absente au lancement

**Problème** : Pas d'ETA, pas de coops joueurs, pas d'institutions → « SimAgri solo amélioré ».

**Correction appliquée** :
- ✅ Ajout dans `GDD-SOURCE-VERITE.md` §27 : coopératives joueurs dès Phase 3 (achat groupé, projets communs)
- ✅ ETA simplifié dès Phase 4 (pas Phase 8) : un joueur peut offrir des prestations à ses voisins
- ✅ CESA/CFSA formalisés : institutions politiques joueurs avec budgets et votes

---

## Findings MAJEURS — Corrigés

| # | Problème | Correction |
|---|----------|------------|
| M1 | Puits early-game insuffisants (ratio 15%) | Fermage mensuel + aliment coop = destruction monétaire + cotisations mensuelles (pas annuelles) |
| M2 | Mode Expert = habillage | À renforcer en Phase 2 : maladies cryptiques, météo stochastique, mortalité accrue. Note pour la roadmap. |
| M3 | Pas de Battle Pass | Ajouté : BP cosmétique saisonnier 4,99€/trimestre dans §22 |
| M4 | Session 5 min sans batch actions | À documenter dans GDD-ui-ux : « Plan express » 1-tap, batch actions groupées |
| M5 | 2ème ferme = P2W informatif | Corrigé : sandbox avec patrimoine plafonné 50k€, pas de marché joueur |

---

## Findings MAJEURS — Non corrigés (à traiter en phase Architecture/roadmap)

| # | Problème | Action | Phase |
|---|----------|--------|:-----:|
| M6 | Transaction WRITE monolithique dans le tick | Batch par 50-100 joueurs | Architecture |
| M7 | Scaling mémoire Phase 10 (92 sous-systèmes) | Streaming READ avec cursors | Phase 5+ |
| M8 | Drizzle + Prisma = dual schema | Script CI de synchronisation | Architecture |
| M9 | Pas de micro-événements quotidiens (boucle sans surprise) | Système 15-20 événements rotatifs | Phase 3 |
| M10 | Forum intégré obsolète en 2026 | Remplacer par API Discord + liens in-game | Phase 4 |
| M11 | Saisonnalité prix coop absente | Variation ±10% du prix coop selon saison | Phase 2 |

---

## Findings du vétéran — Exploits anticipés

| Exploit | Mécanisme | Contre-mesure ajoutée |
|---------|-----------|----------------------|
| « Usine à employés » (alts mûris) | Alt vend au main sous le prix marché | Volume max détenu + pattern detection Phase 5 |
| « Mur poule social » (coalition 3 joueurs) | Contournement du cap individuel | Le HT coûte par poule quel que soit le propriétaire — la coalition ne réduit PAS le coût HT global |
| « Market maker patient » (cornering stock) | Achat coop illimité → stockage → revente au plafond | Volume max détenu (10× prod mensuelle) + taxe stockage 2%/semaine |

---

## Estimation technique (architecte)

| Phase | Scope | Durée |
|-------|-------|:-----:|
| Tick Engine MVP (5 systèmes, 100 joueurs) | Pipeline + WorkDurationService + tick window | 3-4 semaines |
| Production-ready (tous systèmes, 1000 joueurs) | Parallélisme + monitoring + tous calculs | 10-14 semaines |

---

## Viabilité financière (consultant)

| Scénario | DAU | Revenu/mois | Viable ? |
|----------|:---:|:-----------:|:--------:|
| Pessimiste | 800 | 774€ | ❌ Survie infra seule |
| **Breakeven** | **3 000** | **~2 200€** | ✅ 1 dev mi-temps |
| Moyen | 5 000 | 3 400€ | ✅ Confort |
| Optimiste (+ i18n) | 15 000+ | 8 500€+ | ✅ Petit studio |

**Go conditionnel** : viable en projet passion à 3000+ DAU. Professionnalisation nécessite internationalisation (EN/DE/ES).

---

## Corrections appliquées aux documents

| Document | Modification |
|----------|-------------|
| `GDD-SOURCE-VERITE.md` §21 | Puits early-game + late-game récurrents + anti-manipulation |
| `GDD-SOURCE-VERITE.md` §22 | Robot F2P + 2ème ferme sandbox + Battle Pass |
| `GDD-SOURCE-VERITE.md` §25-27 | Nouvelles sections (ci-dessous) |
| `CHARTE-MONETISATION.md` | Robot de traite retiré des prérequis AgriPass |

---

## Nouvelles sections ajoutées à GDD-SOURCE-VERITE

### §25. Feedback mid-cycle et rétention

- **Milestones visuels** : notifications et changement visuel à chaque stade culture (levée J+3, tallage J+7, épiaison J+14, maturation J+21)
- **Décisions intermédiaires** : fongicide optionnel en montaison, désherbage en début tallage
- **Micro-événements quotidiens** : 15-20 événements rotatifs (prime qualité, demande acheteur, bruit moteur suspect, proposition échange voisin) — 2-3 par semaine
- **Session express** : batch actions « Plan du jour » en 1 tap (dépense toutes les HT disponibles selon priorité auto)

### §26. Mobile-first (5 écrans)

Écrans mobile-first prioritaires :
1. Dashboard (synthèse, budget HT, alertes)
2. Parcelle (action sur parcelle individuelle)
3. Marché (acheter/vendre)
4. Élevage (vue troupeau, nourrir, soigner)
5. Récap Connexion (ce qui s'est passé depuis la dernière visite)

### §27. Dimension sociale dès Phase 3

- **Coopératives joueurs** (Phase 3) : création, cotisation, achat groupé, projets communs
- **ETA simplifié** (Phase 4) : un joueur offre des prestations aux voisins (labour, moisson)
- **CESA/CFSA** (Phase 5) : institutions politiques joueurs, élections, budgets, votes sur règles serveur
- Les métiers complets (concessionnaire, transporteur) restent en Phase 8 mais le tissu social de base est actif dès Phase 3
