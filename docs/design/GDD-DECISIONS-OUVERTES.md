> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


> ⚠️ **Note** : Ce document de review est antérieur aux décisions validées dans `GDD-SOURCE-VERITE.md`. Certains points soulevés ici ont été tranchés depuis.


# GDD Review — Décisions Ouvertes à Trancher

> Date : 2026-08-04
> Consolidation : Directeur Créatif
> Sources : Reviews économiste, UX designer, joueur vétéran, architecte technique, expert monétisation
> Statut : ✅ **TOUTES TRANCHÉES** (2026-08-05)

---

> ## ✅ RÉSOLUTION COMPLÈTE — 2026-08-05
>
> Les 25 décisions de ce document ont été tranchées et formalisées en ADR :
>
> | Décisions | ADR correspondant |
> |-----------|-------------------|
> | #01, #03 | ADR-007 — Politique monétaire serveur |
> | #08 | ADR-008 — Définition opérationnelle "pas P2W" |
> | #09 | ADR-009 — Viabilité financière et stratégie MVP |
> | #13 | ADR-010 — Mobile-first top 3 écrans |
> | #17, #18, #19, #20 | ADR-011 — Architecture Tick Engine |
> | #02 | ADR-012 — Équilibrage ROI par profil |
> | #03 (détail prix) | ADR-013 — Mécanisme de prix dynamiques |
> | #07 | ADR-014 — Structure d'abonnement 2 tiers |
> | #12 | ADR-015 — Stratégie d'onboarding |
> | #14, #15 | ADR-016 — Boucles de feedback et rétention |
> | #23, #25 | ADR-017 — Anti-multicompte et anti-exploit |
> | #22 | ADR-004 (existant) + CALIBRAGE-HT-ACTIVITES.md |
> | #04, #05, #06, #10, #11, #16, #24 | Décisions "IMPORTANT avant beta" — tranchées dans les ADR ci-dessus (couvertes en cascade) |
>
> **Livrables produits** :
> - `docs/design/CHARTE-MONETISATION.md` — Charte publique des lignes rouges
> - `docs/design/CALIBRAGE-HT-ACTIVITES.md` — Calibrage HT par activité
>
> Ce document reste en lecture seule comme archive de la réflexion.

---

## 1. Économie & Équilibrage

### Décision #01 — Système de puits monétaires (money sinks)

**Contexte** : La coopérative (bot) crée de l'argent ex nihilo à chaque vente joueur. Avec la croissance exponentielle des cheptels, la masse monétaire explose mécaniquement. Aucun puits proportionnel à la richesse n'est documenté. L'hyperinflation est mathématiquement inévitable sans intervention.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Taxes progressives | Taxe sur transactions marché (5-10%) + impôt patrimoine + charges croissantes | Détruit la monnaie proportionnellement, réaliste | Peut frustrer les joueurs riches, complexe à calibrer |
| B — Coop à budget limité | La coopérative a un budget quotidien fini, prix baisse si surproduction serveur | Régulation naturelle offre/demande, simple | Pénalise les joueurs connectés en dernier, sentiment d'injustice |
| C — Usure/decay agressif | Matériel et bâtiments se dégradent proportionnellement à la valeur, entretien croissant | Sink gameplay intégré, pas artificiel | Punitif si mal calibré, anti-fun potentiel |
| D — Hybride (A+B+C dosés) | Combinaison légère de chaque mécanisme | Pas de point de friction unique, résilience | Plus complexe à implémenter et équilibrer |

**Qui l'a soulevé** : Économiste (Q1, Q2, Risque 1)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option D (hybride). L'économiste et le vétéran convergent : il faut plusieurs puits légers plutôt qu'un seul puits lourd. Livrable requis : document "Politique Monétaire Serveur" avant le premier commit économie.

---

### Décision #02 — Rééquilibrage ROI des profils (problème poule Tier S)

**Contexte** : La poule a un ROI de ×50-100 avec investissement quasi-nul. L'allaitant est à ×0,7-0,9. L'écart est si massif que tout joueur rationnel fait des poules. La diversité de gameplay est une illusion si l'économie punit la diversification.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Nerf poule fort | Limiter reproduction (1 couvée/2 mois IG), HT élevés, coût bâtiment ×3 | Écart réduit à ×8-10 max, diversité forcée | Les vétérans SimAgri s'y attendent, risque de frustration nostalgie |
| B — Buff profils faibles | Augmenter aides PAC, primes extensives, bonus biodiversité pour allaitant/ovin | Pas de nerf = pas de frustration, plus réaliste (aides) | L'écart reste large, poule toujours dominante |
| C — Saturation marché agressive | Prix des œufs → 0 si surproduction, marché auto-régulateur | Mécanisme naturel, pas de règle artificielle | Le premier arrivé gagne, late joiners pénalisés |
| D — Cible ×2 à ×10 pour tous | Combinaison nerf poule + buff allaitant + saturation | Chaque profil viable et intéressant | Gros travail de calibrage, besoin de simulation |

**Qui l'a soulevé** : Économiste (Q3, Risque 2), Vétéran (Q5)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option D. Consensus fort entre économiste et vétéran. Le vétéran confirme que la poule méta était un problème connu de SimAgri. Cible : chaque profil entre ×2 et ×10 ROI sur 4 ans IG.

---

### Décision #03 — Mécanisme de prix marché dynamique (plancher/plafond)

**Contexte** : Un marché dynamique sans garde-fous permet la manipulation de cours (achat massif de stock), les flash crashes, et la spéculation abusive. Les joueurs riches peuvent contrôler des pans entiers de l'économie.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Marché 100% libre | Aucune régulation, confiance au marché | Simplicité, émergence naturelle | Monopoles, manipulation, frustration nouveaux |
| B — Plancher coop + plafond anti-spéc | La coop rachète toujours à un prix plancher, plafond à +200% du prix moyen | Filet de sécurité, anti-manipulation | Moins de liberté économique, mécanique visible |
| C — Vitesse d'ajustement contrôlée | Prix ne peut varier que de ±X%/jour, lissage temporel | Pas de crash brutal, prédictible | Empêche la réaction rapide à la rareté réelle |

**Qui l'a soulevé** : Économiste (Q4), Vétéran (Q3, Q7)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option B. Le plancher coop est un filet de sécurité non-négociable pour la rétention des nouveaux.

---

### Décision #04 — Stratégie "late joiner" (joueur arrivant 6 mois après ouverture)

**Contexte** : Un joueur rejoignant un serveur mature fait face à des vétérans 10-100× plus riches, un marché calibré pour les riches, et potentiellement des terres épuisées. Ce problème a tué des jeux de gestion MMO.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Serveurs saisonniers | Nouveau serveur tous les 3-6 mois, reset complet | Égalité parfaite au départ | Fragmente la communauté, perte de progression |
| B — Protection temporaire | Joueurs <3 mois : prix coop garantis, terres réservées, marché protégé | Intégration douce, pas de fragmentation | Complexe, transition brutal à la fin de la protection |
| C — Catch-up mécanique | Bonus XP/revenus dégressif basé sur l'âge du serveur | Rattrapage naturel, invisible | Frustre les vétérans ("j'ai farmé 6 mois pour rien") |
| D — Offre infinie + mentorat | Terrain toujours disponible + CFSA économique (vétérans subventionnent nouveaux) | Pas de mur, social | Dépend de la bonne volonté des vétérans |

**Qui l'a soulevé** : Économiste (Q5, Risque 3), Vétéran (F3), UX (Risque 4)

**Priorité** : 🟠 IMPORTANT avant beta

**Recommandation équipe** : Combinaison B+D. Terrain infini (pas de limitation géographique) + protection des 3 premiers mois + mentorat CFSA incité économiquement.

---

### Décision #05 — Calibrage de l'emprunt bancaire (Phase 5)

**Contexte** : L'emprunt mal calibré compresse la timeline de 4 ans en 6 mois. Un joueur empruntant 200k€ pour acheter 20 truies rembourse en 3 mois grâce au ROI élevé. C'est l'exploit #1 des jeux de gestion.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Plafond patrimoine | Max emprunt = 50% du patrimoine existant | Simple, progressif | Le riche emprunte plus → creuse l'écart |
| B — Taux progressif dissuasif | Intérêt ×2 au-delà de 100k€, ×4 au-delà de 500k€ | Limite naturelle des gros emprunts | Complexe à expliquer, arbitraire |
| C — Collatéral + risque de saisie | Hypothèque sur les actifs, saisie si défaut | Réaliste, puit monétaire (intérêts) | Punitif, peut décourager l'emprunt utile |
| D — Pas d'emprunt (retirer la feature) | Suppression pure et simple | Élimine l'exploit, simplifie | Perte de gameplay, moins réaliste |

**Qui l'a soulevé** : Économiste (Q7, Risque 4)

**Priorité** : 🟠 IMPORTANT avant beta (Phase 5)

**Recommandation équipe** : Option A+C combinées. Emprunt plafonné + collatéral requis + taux progressif léger.

---

### Décision #06 — Rétention économique endgame (12+ mois)

**Contexte** : Un joueur volaille atteint ~500 000€ en 12 mois réels. Ensuite ? Sans objectifs de dépense aspirationnels, le jeu meurt quand les joueurs n'ont plus rien à acheter.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Prestige sinks | Concours, classements, items cosmétiques exclusifs très chers | Motivation sociale, pas d'inflation | Suffisant pour les compétitifs, pas les casuals |
| B — Filières gouffres | Viticulture/foresterie coûtent 500k+ pour démarrer | Aspiration claire, contenu endgame | Dépend de Phase 10, très lointain |
| C — Expansion géographique | Acheter des fermes dans d'autres régions/pays | Objectif clair, rejouabilité | Scaling technique, complexité |
| D — Système de legs/héritage | Transmettre sa ferme à un "héritier" avec bonus, recommencer | Rejouabilité infinie | Concept inhabituel, peut rebuter |

**Qui l'a soulevé** : Économiste (Q6), Vétéran (Q8)

**Priorité** : 🟡 NICE TO HAVE (mais à designer maintenant)

**Recommandation équipe** : Option A+B. Prévoir les sinks aspirationnels dès la conception même si l'implémentation est tardive.



---

## 2. Monétisation & Business

### Décision #07 — Structure de l'abonnement (1 tier vs multi-tiers)

**Contexte** : Un tier unique laisse de l'argent sur la table. Les petits payeurs veulent un prix d'entrée bas, les "dolphins" veulent plus de valeur. Le SimPass original était ~2,50€/mois. Le marché actuel (OSRS, EVE) va jusqu'à 15€/mois.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — 1 tier unique (5€/mois) | Simple, tout-en-un | Clarté, pas de FOMO entre tiers | Plafonne les revenus, ne capture pas les whales |
| B — 2 tiers (4€ Confort / 8€ Premium) | Confort = QoL base, Premium = cosmétiques avancés + 2e ferme | Capture plus de valeur, prix d'entrée bas | Complexité, risque de P2W perçu sur tier 2 |
| C — 3 tiers (4€ / 8€ / 15€) | Ajout d'un tier "Mécène" (support prioritaire, accès bêta, crédits) | Revenue maximum, satisfait tous les profils | Trop de choix pour une niche, maintenance |

**Qui l'a soulevé** : Monétisation (Q6), Économiste (Q9)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option B. L'expert monétisation propose 2 tiers (3,99€/7,99€) + boutique cosmétique. Le vétéran valide que le SimPass était perçu comme raisonnable à ~30€/an.

---

### Décision #08 — Définition opérationnelle du "pas Pay-to-Win"

**Contexte** : "Jamais P2W" est un engagement marketing fort mais sans définition testable, c'est un vœu pieux. Un seul thread Reddit "Agriva is P2W" peut tuer la croissance. La frontière entre QoL et avantage compétitif est floue.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Règle du ±10% | "Un F2P avec le même temps de jeu atteint ±10% des résultats d'un abonné" | Testable, objectif, communicable | Difficile à mesurer en pratique sur 119 systèmes |
| B — Liste rouge/verte explicite | Publication d'une charte : ce qui est JAMAIS monétisé (HT, rendement, vitesse, accès) vs ce qui l'est (cosmétique, UX) | Transparent, communauté valide | Rigide, empêche des pivots futurs |
| C — Comité communautaire | Les joueurs votent sur chaque ajout monétisé | Adhésion maximale, trust | Lent, risque de blocage, joueurs votent toujours "tout gratuit" |

**Qui l'a soulevé** : Monétisation (Q1, Q10, Risque 3), Vétéran (Q10), Économiste (Q9)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option B. Consensus fort. Publier une charte "Lignes rouges de monétisation" dès le lancement. Lignes rouges non-négociables : ❌ HT bonus, ❌ boost rendement, ❌ accès exclusif gameplay, ❌ avantage marché, ❌ skip timers.

---

### Décision #09 — Viabilité financière minimum et seuil de rentabilité

**Contexte** : Avec 5 000 joueurs actifs (optimiste pour une niche FR) et 5% de conversion, on parle de 250 abonnés × 5€ = 1 250€/mois. Ça ne couvre pas les serveurs + maintenance. Le projet risque la mort financière.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Internationalisation dès le design | EN/DE/ES/PT dès la V1 pour élargir le TAM ×5-10 | Marché beaucoup plus large | Coût de localisation, support multi-langue, communauté fragmentée |
| B — Diversification revenus | Abo + cosmétiques + packs fondateur + dons | Plusieurs sources, résilience | Plus de dev, boutique à maintenir |
| C — MVP minimal puis validation | Lancer avec 20-30 systèmes, mesurer conversion, puis itérer | Risque financier réduit, validation rapide | Peut décevoir les vétérans qui attendent "le vrai SimAgri" |
| D — Modèle passion/hobby | Accepter que le jeu ne soit pas rentable, financer par passion + dons | Pas de pression commerciale, liberté créative | Non-pérenne, épuisement motivationnel |

**Qui l'a soulevé** : Monétisation (Q2, Q5, Risque 1, Risque 4), Économiste (Risque 5)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option B+C. Valider le modèle économique avec un MVP monétisable AVANT de développer les 119 systèmes. Objectif minimum : 500 abonnés ou revenu alternatif identifié.

---

### Décision #10 — Stratégie anti-churn abonnement

**Contexte** : Sans contenu saisonnier ou injection de valeur régulière, les abonnés décrochent après 3-6 mois. Un jeu sandbox persistant n'a pas de "fin de saison" qui force le renouvellement.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Avantages rotatifs mensuels | Chaque mois, un bonus cosmétique exclusif (skin saisonnier, badge, déco) | Raison de rester abonné, collectionnisme | Création de contenu régulier nécessaire |
| B — Réduction fidélité | -10% après 6 mois, -20% après 1 an | Récompense la loyauté, réduit le churn | Réduit le revenu par abonné fidèle |
| C — Engagement annuel avec bonus | Abo annuel -27% + bonus exclusif (badge fondateur, skin rare) | Verrouille le revenu, prévisibilité | Barrière d'entrée plus haute |

**Qui l'a soulevé** : Monétisation (Q3, Risque 2)

**Priorité** : 🟠 IMPORTANT avant beta

**Recommandation équipe** : Option A+C. Engagement annuel avec réduction + contenu cosmétique rotatif mensuel pour les abonnés.

---

### Décision #11 — Offre de lancement (Founder's Pack)

**Contexte** : Au lancement, la base de joueurs sera minuscule. Il faut financer le développement continu entre le lancement et le seuil de rentabilité, tout en créant une communauté investie.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Pack Fondateur 49,99€ | 1 an de Premium + badge permanent + skin exclusif + accès Discord privé | Finance le lancement, crée une élite investie | Prix élevé pour une niche, risque si le jeu déçoit |
| B — Early access gratuit | Tout gratuit pendant la beta, monétisation post-launch | Maximise l'adoption, pas de barrière | Pas de revenus pendant des mois, habitue au gratuit |
| C — Crowdfunding (KS/Ulule) | Campagne avec paliers et rewards | Validation marché + financement | Effort marketing massif, engagement de livraison |

**Qui l'a soulevé** : Monétisation (Q7)

**Priorité** : 🟠 IMPORTANT avant beta

**Recommandation équipe** : Option A. Le pack fondateur finance ET crée une communauté d'ambassadeurs. L'accès Discord privé est clé pour le feedback early.



---

## 3. UX & Accessibilité

### Décision #12 — Stratégie d'onboarding (First Meaningful Action)

**Contexte** : Le jeu a 119 sous-systèmes. Même la Phase 3 demande de comprendre sols, météo, matériel, HT, bâtiments, stockage ET cultures = 7 systèmes interconnectés. Un joueur qui ne comprend pas quoi faire dans les 5 premières minutes ne reviendra jamais. 40%+ d'abandon avant la première récolte est le scénario probable sans onboarding structuré.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Mode guidé obligatoire | Première session = parcelle pré-préparée, mission simple ("semez du blé"), 2-3 décisions max | Gratification en 5 min, accessible | Les vétérans SimAgri veulent skip, peut paraître condescendant |
| B — Déblocage progressif | Systèmes verrouillés, débloqués par milestones (comme un RPG) | Complexité maîtrisée, dopamine | Anti-sandbox, frustrant pour ceux qui savent |
| C — Exploration libre + aide contextuelle | Tout ouvert, mais aide contextuelle intelligente quand le joueur semble bloqué | Liberté SimAgri préservée, pas de rails | Mur cognitif intact pour les casuals, coûteux en contenu |
| D — Hybride (A pour 30 min puis C) | Tutoriel guidé optionnel (skip pour vétérans) puis monde ouvert avec aide | Best of both worlds | Plus de dev, deux expériences à maintenir |

**Qui l'a soulevé** : UX (Q1, Q6, Risque 1, Rec 1), Vétéran (F5)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option D. Le tutoriel guidé doit être skippable (vétérans) mais transformatif pour les nouveaux. Livrable : wireframes "First 5 Minutes" validés par 5 tests utilisateurs AVANT Phase 3.

---

### Décision #13 — Design mobile-first vs responsive-after

**Contexte** : Le jeu repose sur des tableaux (catalogues matériel, annonces marché, lots d'animaux, parcelles). Un tableau 8+ colonnes est illisible sur 375px. Le responsive seul ne suffit pas. Promettre "jouable sur mobile" sans design mobile-first = promesse marketing non tenue.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Mobile-first intégral | Toutes les interfaces conçues pour le pouce d'abord, adaptées ensuite au desktop | Mobile excellent, desktop aussi bien | Coût de design ×2, ralentit le dev, desktop peut sembler vide |
| B — Mobile-first pour le top 3 écrans | Dashboard + action parcelle + marché en mobile-first, le reste en responsive classique | 80% du mobile couvert avec 20% de l'effort | Expérience incohérente entre écrans |
| C — Desktop-first + responsive | Design desktop classique, adaptation technique mobile | Dev rapide, desktop optimal | Mobile sera un citoyen de 2nde classe |
| D — App compagnon mobile simplifiée | Desktop = jeu complet, mobile = dashboard + actions rapides uniquement | Chaque plateforme optimisée pour son usage | Deux interfaces à maintenir, fragmentation |

**Qui l'a soulevé** : UX (Q4, Risque 2, Rec 2)

**Priorité** : 🔴 BLOQUANT Phase 1 (choix structurant)

**Recommandation équipe** : Option B. Pragmatique. Les 3 écrans les plus fréquents en mobile-first, le reste en responsive. Livrable : prototypes Figma mobile des 3 écrans prioritaires.

---

### Décision #14 — Durée de session cible et micro-feedback loops

**Contexte** : 1 semaine réelle = 1 mois en jeu. Un cycle culture complet = plusieurs semaines réelles. Le joueur casual ne verra pas le fruit de ses actions avant 2-3 semaines. La rétention moderne exige un feedback en 48h max. Rétention J7 < 20% sans récompense intermédiaire.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Session 5 min productive | Chaque connexion de 5 min permet au moins 1 action productive avec feedback | Casual-friendly, rétention haute | Nécessite un design UX très serré, actions rapides |
| B — Micro-rewards quotidiennes | Récapitulatif d'absence + tâches optionnelles + XP/badges + événements positifs aléatoires | Dopamine régulière, engagement quotidien | Risque de gamification artificielle, "daily chores" |
| C — Bilan hebdomadaire célébratoire | Chaque "fin de mois IG" = récap avec progression visible, comparaison, graphiques | Feedback rythme naturel du jeu | 1 semaine c'est long pour accrocher un nouveau |
| D — Combinaison (A+B+C par couche) | 5 min = 1 action, quotidien = micro-reward, hebdo = bilan | Feedback à toutes les échelles | Complexité de design et d'implémentation |

**Qui l'a soulevé** : UX (Q3, Q5, Risque 4, Rec 3), Vétéran (Feature 2, Feature 4)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option D. Les boucles de feedback doivent exister à 3 échelles (5 min / quotidien / hebdo). C'est non-négociable pour la rétention.

---

### Décision #15 — Politique d'absence et protection hors-ligne

**Contexte** : Le GDD mentionne "gel des jauges si absent" mais ne précise pas le contrat exact. Si un joueur part 2 semaines (= 2 mois IG), que se passe-t-il ? Cultures pourrissent ? Animaux meurent ? Le vétéran SimAgri rapporte que rater une fenêtre de récolte (2 jours réels) = perte de saison entière. C'est inacceptable pour un jeu casual.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Gel total | Tout est gelé si absent >48h, reprise exacte au retour | Zéro punition, casual max | Irréaliste, exploitable (pause stratégique), économie gelée |
| B — Dégradation lente sans mort | Animaux ne meurent pas mais perdent condition, cultures se dégradent mais récoltables (malus) | Pas de perte catastrophique, incitation à revenir | Toujours une pénalité, pas "pas de punition" |
| C — Automatisation d'urgence | Après 48h d'absence, un "voisin" NPC gère le minimum (nourrir, récolter à -30% rendement) | Réaliste, pas de catastrophe, coût | Magic solution, immersion questionnable |
| D — Notification + action mobile rapide | Push "votre blé est mûr", action en 1 tap depuis mobile pour lancer la récolte | Pas de perte si le joueur a un smartphone | Dépend du mobile, FOMO potentiel |

**Qui l'a soulevé** : UX (Q7), Vétéran (F2)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option B+D. Dégradation lente (jamais de perte catastrophique) + notifications actionnables sur mobile. Le contrat joueur : "Tu ne perdras jamais tout, mais tu progresseras moins vite."

---

### Décision #16 — Complexité cognitive et assistance décisionnelle

**Contexte** : Les cultures seules = sol (6 éléments) × météo × rotation × techniques × traitements × engrais × matériel × HT × timing = 9+ variables simultanées. Le vétéran demande la transparence totale des mécaniques. Le casual a besoin d'assistance. Ces deux besoins sont contradictoires.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Mode expert/casual toggle | Deux niveaux d'affichage : simplifié (recommandations auto) et détaillé (toutes les formules) | Satisfait les deux profils | Deux UX à maintenir, risque d'incohérence |
| B — Recommandations intelligentes | IA/algorithme suggère la meilleure action ("Semez du blé maintenant, votre sol est idéal") | Accessible sans être limitant | Dev IA, risque de "jouer à la place du joueur" |
| C — Transparence progressive | Formules cachées au début, dévoilées par progression/milestones | Onboarding doux, profondeur earned | Frustrant pour les théorycrafters impatients |
| D — Tout transparent + templates | Toutes les formules visibles + templates d'actions pré-configurées pour les casuals | Honnête, les templates simplifient | Information overload pour les nouveaux |

**Qui l'a soulevé** : UX (Q6, Risque 3), Vétéran (F5, Feature 2)

**Priorité** : 🟠 IMPORTANT avant beta

**Recommandation équipe** : Option A+D. Toggle expert/casual avec transparence des formules pour les experts et recommandations pour les casuals. Le vétéran insiste : "Pas de boîte noire."



---

## 4. Architecture & Performance

### Décision #17 — Architecture du Tick Engine (séquentiel vs pipeline parallèle)

**Contexte** : Le tick quotidien traite TOUS les joueurs et assets en une seule passe. À 1000 joueurs avec fermes matures (50 parcelles, 200 animaux, 30 équipements chacun), c'est des centaines de milliers d'entités. Un seul worker Node.js single-threaded ne tiendra pas. Le temps de tick croît linéairement avec les joueurs ET la complexité des phases (Phase 10 = 92+ sous-systèmes par joueur).

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Tick séquentiel simple | 1 worker itère sur tous les joueurs séquentiellement | Simple à dev et debug, pas de concurrence | Ne scale pas au-delà de ~200 joueurs matures, single point of failure |
| B — Pipeline READ→COMPUTE→WRITE parallèle | Snapshot global → partition par joueur → N workers parallèles → bulk write | Scale linéairement avec les workers, budget de perf contrôlable | Plus complexe, nécessite partitionnement dès le début |
| C — Tick distribué par sous-système | Chaque sous-système (cultures, animaux, usure...) est un job indépendant | Max parallélisme, isolation des pannes | Dépendances inter-systèmes complexes (cultures → paille → élevage), ordering critique |
| D — Tick événementiel (pas de batch) | Pas de tick global, chaque entité "tick" indépendamment (lazy eval quand consultée) | Pas de pic de charge, scale naturellement | Complexe à raisonner, cohérence temporelle difficile, bugs subtils |

**Qui l'a soulevé** : Architecte (Q1, Q2, Risque 1, Rec 1)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option B. L'architecte est formel : la structure pipeline (READ→COMPUTE→WRITE) doit être posée dès le jour 1 même si le parallélisme n'est activé qu'à Phase 5. Budget cible : tick < 5 min pour 1000 joueurs.

---

### Décision #18 — Couche d'accès données pour le tick (Prisma vs SQL brut vs hybride)

**Contexte** : Prisma est excellent pour les CRUD mais génère des requêtes N+1, pas de bulk update natif efficace, pas de streaming, overhead de sérialisation. Le tick doit lire/écrire des dizaines de milliers d'entités avec des jointures complexes (culture + parcelle + sol + météo + matériel + rotation + traitements). Dès Phase 3, Prisma sera un goulot.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Prisma partout | Prisma pour l'API ET le tick | DX unifiée, type-safety partout | Performance dégradée dès Phase 3, refactoring inévitable |
| B — Prisma API + SQL brut tick | Prisma pour les endpoints REST, SQL natif (pg + pgtyped) pour le tick | Chaque couche optimisée pour son usage | Deux "mondes" à maintenir, duplication possible |
| C — Prisma API + vues matérialisées | Prisma partout mais vues PostgreSQL pré-joignent les données du tick | Performance améliorée, DX Prisma conservée | Vues à maintenir, refresh coûteux, limites sur les writes |
| D — Abandon Prisma → Kysely/Drizzle | Remplacer Prisma par un query builder plus léger (Kysely, Drizzle) | Performance + type-safety, pas de dual layer | Migration coûteuse si Prisma déjà intégré |

**Qui l'a soulevé** : Architecte (Q4, Q10, Risque 2, Rec 2)

**Priorité** : 🔴 BLOQUANT Phase 1 (choix structurant)

**Recommandation équipe** : Option B. Prisma pour 90% du code (endpoints API), SimulationDataLayer en SQL brut pour le tick (10% du code, 90% de la charge). Poser l'interface `PlayerSimState` / `GlobalSimState` dès Phase 1.

---

### Décision #19 — Mécanisme de verrouillage tick/actions joueur

**Contexte** : Le joueur agit à tout moment (acheter, vendre, semer) via l'API REST. Le tick se déclenche à 06:00 UTC. Si un joueur transacte pendant le tick, l'état est incohérent : animal vendu mais tick le nourrit, culture semée mais tick ne la voit pas. Bugs de simulation garantis.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Tick Window (blocage global) | 1 min avant le tick : refus des mutations (API 503 + Retry-After), déblocage après | Simple, robuste, pas d'incohérence | Fenêtre d'indisponibilité (même courte), frustrant si joueur actif à 6h |
| B — Lock par joueur (granulaire) | Chaque joueur est locké uniquement pendant le traitement de SA ferme | Pas de blocage global, parallélisable | Plus complexe, risque de deadlock inter-joueurs (marché) |
| C — Snapshot + replay | Snapshot de l'état au début du tick, actions pendant le tick sont queued et rejouées après | Zéro blocage perçu par le joueur | Complexe (replay), conflits possibles (action invalide après tick) |
| D — Optimistic + conflict resolution | Pas de lock, détection de conflit post-tick, résolution automatique | Performance maximale | Très complexe, edge cases difficiles |

**Qui l'a soulevé** : Architecte (Q3, Risque 3, Rec 3)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option A pour le MVP. Simple et robuste. Tick window < 2 min = acceptable. Évoluer vers B en Phase 5 si le tick devient assez rapide.

---

### Décision #20 — Mapping serveur de jeu → infrastructure technique

**Contexte** : Le concept de "serveur de jeu" (France, Belgique, Expert...) n'est pas mappé à l'infrastructure technique. 1 BDD par serveur ? Schéma multi-tenant ? VPS séparé ? Ce choix impacte le scaling, les coûts, et la complexité opérationnelle.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — 1 BDD par serveur de jeu | Chaque serveur = PostgreSQL séparé (même VPS ou VPS différent) | Isolation parfaite, scaling horizontal simple, pas de cross-contamination | Maintenance ×N, migrations ×N, pas de cross-server features |
| B — Schéma multi-tenant | 1 PostgreSQL, 1 schéma par serveur (ou colonne `server_id` partout) | 1 seule BDD à gérer, économie de ressources | Requêtes plus complexes, risque de fuite cross-server, index lourds |
| C — Hybride (1 BDD pour auth + N BDD pour jeu) | Auth/joueur centralisé, données de jeu shardées par serveur | Best of both : SSO + isolation de jeu | Plus de config, jointures cross-DB impossibles |

**Qui l'a soulevé** : Architecte (Q7, Risque 4)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option A (1 BDD par serveur). Le plus simple au démarrage. L'isolation permet de scaler en ajoutant un VPS par serveur de jeu si besoin. Le multi-tenant est une optimisation prématurée.

---

### Décision #21 — Stratégie de test de charge et simulation long-terme

**Contexte** : Les formules de rendement ont ~15 multiplicateurs. La génétique a 14 indices. Ces calculs sont le cœur du jeu. Sans simulation à l'échelle (1000 fermes × 84 ticks = 1 an de jeu), impossible de détecter les déséquilibres (soldes négatifs infinis, rendements impossibles, hyperinflation).

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Simulation headless pré-alpha | Script qui simule 1000 joueurs pendant 1 an IG, analyse les métriques économiques | Détection précoce des déséquilibres, chiffrable | Coûteux en dev, les bots ne jouent pas comme des humains |
| B — Tests unitaires + intégration | Chaque formule testée en isolation, scénarios d'intégration ciblés | Rapide, CI-friendly, détecte les régressions | Ne détecte pas les effets émergents (inflation systémique) |
| C — Alpha fermée avec métriques | Lancer l'alpha rapidement, monitorer les métriques macro (Gini, inflation, rétention) | Données réelles, feedback humain | Détection tardive, les joueurs alpha voient les bugs |
| D — A + C (simulation puis validation alpha) | Simulation headless pour les gros déséquilibres, alpha pour les effets humains | Couverture maximale | Effort double |

**Qui l'a soulevé** : Architecte (Q8), Économiste (Rec 1)

**Priorité** : 🟠 IMPORTANT avant beta

**Recommandation équipe** : Option D. Simulation headless dès Phase 3 (économie + cultures) pour valider les paramètres macro. Alpha fermée Phase 5 pour les interactions humaines.



---

## 5. Gameplay & Anti-exploit

### Décision #22 — Calibrage des Heures de Travail (HT) et scaling

**Contexte** : SimAgri = 35 HT/jour. L'étude économique mentionne 50-80 HT. Le vétéran dit que 35 HT est THE tension stratégique du jeu ("tu ne peux pas tout faire"). Si les HT sont le principal bottleneck de la croissance exponentielle (poule/porc), leur calibrage EST l'équilibrage du jeu. L'abo confort qui donne des HT supplémentaires = P2W direct.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — 35 HT fixes (fidélité SimAgri) | 35 HT/jour, extension uniquement via employés | Tension stratégique maximale, choix = profondeur | Sessions très limitées, frustrant pour les casuals, anti-mobile |
| B — 50 HT base | 50 HT/jour, scaling léger (+5 HT/employé) | Plus accessible, sessions de 15-20 min productives | Moins de tension, poule rush facilité |
| C — HT dynamiques par activité | Base 40, mais coûts HT variables (poule = 3 HT/action, vache = 0.5 HT) | Équilibrage fin par filière, régulateur anti-poule | Complexe à calibrer, opaque pour le joueur |
| D — Pas de HT (temps réel) | Remplacer HT par des timers (chaque action prend X heures réelles) | Moderne, idle-game friendly | Perte de la tension SimAgri, jeu fondamentalement différent |

**Qui l'a soulevé** : Vétéran (Q1), Économiste (Q8)

**Priorité** : 🔴 BLOQUANT Phase 1

**Recommandation équipe** : Option C. Consensus : base 40 HT avec coûts variables par activité. La poule coûte BEAUCOUP de HT (gestion manuelle intensive) tandis que l'allaitant en coûte peu (extensif). Les HT deviennent un levier d'équilibrage, pas juste un compteur.

---

### Décision #23 — Stratégie anti-multicompte

**Contexte** : Avec un jeu F2P navigateur où la poule rapporte ×50+ de ROI, rien n'empêche un joueur de créer 10 comptes gratuits, faire des poules sur chacun, et transférer la richesse via le marché. Le multi-compte était L'exploit #1 de SimAgri. Le vétéran le confirme et détaille 3 patterns connus (poule rush, monopole concessionnaire, farm de HT via ETA fictive).

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Détection technique | Fingerprinting navigateur + IP + timing des échanges + pattern analysis | Détection automatique, scalable | Faux positifs (même foyer), VPN contourne l'IP, course aux armes |
| B — Friction économique | Taxe progressive sur échanges sous le prix marché, cooldown sur transferts entre comptes récents, limite transactions entrantes <2 mois | Prévention par le design, pas de ban injuste | Le joueur légitime peut être impacté (cadeaux entre amis) |
| C — Limite de bénéfice social | ETA/transporteur doivent avoir 5+ clients distincts/mois, ratio prix/volume plafonné | Anti-farm de HT, anti-transfert déguisé | Complexe à monitorer, règles arbitraires |
| D — Combinaison A+B+C | Detection + friction + limites structurelles | Couverture maximale | Plus de dev, plus de faux positifs potentiels |

**Qui l'a soulevé** : Vétéran (Q2, Exploit 1, Exploit 3), Économiste (Q10)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option D mais déployé progressivement. Phase 1 : Option B (friction économique intégrée au design). Phase 5 : ajout de A (détection) et C (limites sociales). Le multi-compte doit être non-rentable BY DESIGN, pas juste détecté.

---

### Décision #24 — Mécanismes anti-monopole (concessionnaires, marché)

**Contexte** : Le vétéran rapporte que dans SimAgri, 2-3 concessionnaires par serveur contrôlaient tout le matériel. Un concessionnaire riche pratiquait le dumping (prix sous coût de revient pendant 3 mois → concurrents coulent → remontée des prix à +40%). Même risque pour les CIA et ETA.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Prix plancher (coût de revient) | Impossible de vendre durablement à perte | Anti-dumping simple | Limite la compétition légitime (perte temporaire pour conquérir un marché) |
| B — Limite de parts de marché | Max 40-50% des ventes par zone par concessionnaire | Force la diversité | Artificiel, frustrant pour le joueur dominant, complexe à implémenter |
| C — Accès alternatif garanti | Tout joueur peut commander "hors zone" avec surcoût transport | Toujours une alternative, pas d'otage | Réduit l'intérêt de la localisation géographique |
| D — Licence temporaire renouvelable | Concessionnaire = licence annuelle avec conditions (prix moyen, satisfaction client) | Régulation naturelle, pas de monopole permanent | Bureaucratique, peut décourager l'activité |

**Qui l'a soulevé** : Vétéran (Q7, Exploit 2)

**Priorité** : 🟠 IMPORTANT avant beta (Phase 8)

**Recommandation équipe** : Option A+C. Prix plancher simple + alternative hors-zone garantie. Pas besoin de régulation complexe si le joueur a toujours un recours.

---

### Décision #25 — Automatisation et ordres permanents (QoL vs gameplay)

**Contexte** : Le vétéran demande des "ordres permanents" (acheter auto aliment si stock < seuil, vendre auto si prix > X, sortir vaches au pré le 1er avril). C'est le QoL qui sépare un jeu 2026 d'un jeu 2005. MAIS l'automatisation peut transformer le jeu en idle game si elle va trop loin. Et si elle est dans l'abo payant, c'est du P2W déguisé.

**Options** :

| Option | Description | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| A — Automatisation gratuite limitée | 3 ordres permanents gratuits, illimités dans l'abo | QoL de base pour tous, monétisation douce | Peut être perçu P2W ("les riches ont plus d'ordres") |
| B — Automatisation gratuite complète | Ordres permanents illimités pour tous, l'abo ajoute des cosmétiques/UX seulement | Zéro P2W perçu, QoL maximal | Perd un levier de monétisation majeur, risque d'idle-game |
| C — Automatisation via employés (gameplay) | L'automatisation passe par l'embauche d'employés (coût en-game) | Intégré au gameplay, progression naturelle, pas d'abo | Nouveau joueur n'a rien, gap avec les riches |
| D — Automatisation progressive (milestones) | Débloquée par progression : 1 ordre après 1 mois, 3 après 3 mois, illimité après 6 mois | Récompense la fidélité, pas de P2W | Frustrant au début, le vétéran veut ça dès le jour 1 |

**Qui l'a soulevé** : Vétéran (Feature 1, F1), UX (Q3), Économiste (Q9), Monétisation (Q1)

**Priorité** : 🔴 CRITIQUE avant alpha

**Recommandation équipe** : Option C. L'automatisation est un GAMEPLAY (employés, investissement en-game) et non une feature d'abo. L'abo donne du cosmétique sur l'automatisation (notifications push, graphiques de suivi) mais pas l'automatisation elle-même. Aligné avec la charte "pas P2W".

---

## Récapitulatif des priorités

### 🔴 BLOQUANT Phase 1 (à trancher AVANT de coder)

| # | Décision | Thème |
|---|----------|-------|
| 01 | Système de puits monétaires | Économie |
| 08 | Définition opérationnelle "pas P2W" | Monétisation |
| 09 | Viabilité financière minimum | Monétisation |
| 13 | Design mobile-first vs responsive | UX |
| 17 | Architecture Tick Engine | Architecture |
| 18 | Couche données tick (Prisma vs SQL) | Architecture |
| 19 | Verrouillage tick/actions | Architecture |
| 20 | Mapping serveur → infra | Architecture |
| 22 | Calibrage des HT | Gameplay |

### 🔴 CRITIQUE avant alpha

| # | Décision | Thème |
|---|----------|-------|
| 02 | Rééquilibrage ROI profils | Économie |
| 03 | Prix marché plancher/plafond | Économie |
| 07 | Structure abonnement multi-tiers | Monétisation |
| 12 | Stratégie d'onboarding | UX |
| 14 | Micro-feedback loops | UX |
| 15 | Politique d'absence | UX |
| 23 | Stratégie anti-multicompte | Gameplay |
| 25 | Automatisation et ordres permanents | Gameplay |

### 🟠 IMPORTANT avant beta

| # | Décision | Thème |
|---|----------|-------|
| 04 | Stratégie late joiner | Économie |
| 05 | Calibrage emprunt bancaire | Économie |
| 10 | Stratégie anti-churn abo | Monétisation |
| 11 | Offre de lancement Founder's Pack | Monétisation |
| 16 | Complexité cognitive et assistance | UX |
| 21 | Test de charge et simulation | Architecture |
| 24 | Mécanismes anti-monopole | Gameplay |

### 🟡 NICE TO HAVE

| # | Décision | Thème |
|---|----------|-------|
| 06 | Rétention endgame 12+ mois | Économie |

---

## Prochaines étapes

1. **Réunion de triage** : Trancher les 9 décisions BLOQUANT Phase 1 en une session de 2-3h
2. **Livrables immédiats** :
   - Document "Politique Monétaire Serveur" (Décisions #01, #03)
   - ADR Tick Engine (Décisions #17, #18, #19)
   - Charte "Lignes Rouges Monétisation" (Décision #08)
   - Prototype HT × coûts par activité (Décision #22)
3. **Wireframes** : First 5 Minutes + 3 écrans mobile-first (Décisions #12, #13)
4. **Simulation** : Tableur de validation ROI par profil avec cible ×2-×10 (Décision #02)

---

*Ce document est vivant. Chaque décision tranchée doit être documentée dans un ADR (Architecture Decision Record) avec la justification du choix.*
