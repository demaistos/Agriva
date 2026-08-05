# Agriva — Source de Vérité Game Design

> Date dernière mise à jour : 2026-08-04
> Statut : ACTIF — Ce document prime sur TOUT autre GDD en cas de conflit.
> Règle : Tout agent IA DOIT lire ce fichier avant de travailler sur le game design.

---

## 1. Identité du jeu

Agriva est un jeu de gestion d'exploitation agricole en ligne, successeur spirituel direct de SimAgri. Il vise les joueurs passionnés d'agriculture et de gestion (casual à hardcore). L'objectif est de reproduire l'intégralité de la profondeur de SimAgri (cultures, élevage 13 espèces, matériel, économie joueur, social) sur une stack moderne (TypeScript, PostgreSQL) avec une UX contemporaine et responsive. Même formule, exécution modernisée.

---

## 2. Temporalité

- **1 semaine réelle = 1 mois in-game.**
- **1 tick par jour réel**, exécuté à **minuit** (00:00 heure française), identique pour tous les joueurs du serveur.
- Le tick fait avancer : croissance cultures, production animale (lait/œufs), consommation aliment, usure matériel, météo du jour, gestation, santé.
- Les actions du joueur (semer, récolter, acheter, vendre) sont **instantanées** hors tick, exécutées quand il se connecte.
- 1 semaine réelle ≈ 7 ticks ≈ 1 mois IG (~4 jours IG par tick).

---

## 3. Économie

- **Capital de départ** : 150 000 € (identique pour tous les kits).
- **Coopérative (bot)** : achète et vend à **prix fixe** — filet de sécurité, vente garantie.
- **Marché joueurs** : **carnet d'ordres** (order book) avec matching automatique (offre/demande libre, historique de prix visible).
- **Puits d'argent** : charges d'entretien (matériel, bâtiments) + charges fixes (fermage, cotisations, assurance) + investissements endgame.
- **Pas de taxes sur les transactions.**
- Objectifs long terme : classements patrimoine, rendement/ha, génétique, diversification, efficience (marge/ha).

---

## 4. Heures de Travail (HT)

- L'unité est la **HT (Heure de Travail)**. **PAS de PA (Points d'Action).**
- Le coût en HT est **variable** et dépend de : type d'action × surface/volume × matériel utilisé (largeur de travail, puissance, GPS).
- Budget quotidien de base : ~40-50 HT/jour (calibrage exact en phase d'équilibrage).
- **Employés** = HT supplémentaires : un employé fournit des heures au joueur (polyvalent, salaire mensuel IG).
- Un employé exécute les ordres mais ne décide rien — le joueur planifie et affecte les tâches.

---

## 5. Profils de départ

4 kits au choix (définitif, non changeable) :

| Kit | Contenu principal |
|-----|-------------------|
| 🌾 **Cultivateur** | Tracteur 120CV, charrue, herse, semoir, moissonneuse 280CV, benne 12T, hangar 200m², silo 100T |
| 🐄 **Éleveur** | 10 vaches Holstein en lactation, tracteur 80CV, charrue, benne 12T, hangar 200m², stabulation 300m² |
| 🐔 **Aviculteur** | 20 poules + 2 coqs, tracteur 50CV, poulailler 50m², hangar 100m² |
| ⚖️ **Polyvalent** | Tracteur 100CV, charrue, herse, benne 12T, remorque 8T, hangar 200m², silo 50T |

Tout le matériel de départ est usé (50-60%) et non-revendable pendant 7 jours réels.

---

## 6. Foncier

- **10 parcelles/joueur/mois IG** apparaissent dans la zone du joueur.
- **Taille aléatoire** (3-5-8-10-15-20 ha…) — le joueur ne choisit pas.
- **Prix fixe par taille**, identique partout (pas de variation par zone).
- **Réservées 5 jours IG** exclusivement au joueur, puis ouvertes à tous.
- **Achat hors zone** possible avec **frais de distance** croissants.
- Terrain infini : le jeu génère toujours de nouvelles parcelles — pas de pénurie.

---

## 7. Serveurs

2 serveurs au lancement :

| Serveur | Description |
|---------|-------------|
| 🇫🇷 **France Normal** | Assistanat, suggestions, tooltips — accessible à tous |
| 🇫🇷 **France Expert** | Pas d'aide in-game, plus réaliste et punitif |

Même carte de France, mêmes mécaniques de base. Choix à l'inscription, définitif. Possibilité d'ouvrir d'autres serveurs plus tard (Phase 10).

---

## 8. Monétisation

- **Gratuit** : 100% des mécaniques, **aucune publicité**, jouable intégralement.
- **Premium** : **3,99 €/mois** — confort et cosmétique uniquement.
- Avantages Premium : stats avancées (historiques, graphiques), thèmes visuels, notifications push/email temps réel, badge profil, fiche personnalisée.
- **Seul skip temporel autorisé** : construction de bâtiment (instantanée au lieu du délai normal).
- Joueur gratuit = notifications à la connexion uniquement.

---

## 9. Lignes rouges Premium

**INTERDIT en Premium — liste exhaustive :**

- ❌ Plus de HT / Heures de Travail
- ❌ Boost de production (rendement, lait, reproduction)
- ❌ Prix préférentiels à la coop
- ❌ Accès exclusif à des cultures/animaux/matériel
- ❌ Skip de gestation, croissance culture, engraissement
- ❌ Toute accélération biologique ou productive
- ❌ Avantage compétitif quelconque dans les classements

**Principe absolu** : le Premium est du confort et du cosmétique, jamais de la puissance.

---

## 10. Météo

- **Simulation statistique réaliste** par zone, basée sur données historiques (Météo-France).
- Paramètres : température, pluviométrie, ensoleillement, vent, gel, événements extrêmes (canicule, grêle, sécheresse).
- Chaque mois IG, le système génère la météo de la zone avec un aléa (années plus/moins favorables).
- **Pas de météo temps réel** — simulation cohérente avec la localisation du joueur.
- Impact : rendement, fenêtres de travail, maladies, pâturage, irrigation.
- Différences régionales effectives (Bretagne ≠ Beauce ≠ Méditerranée).

---

## 11. Saisons

4 saisons visuelles ET mécaniques :

| Saison | Mois IG | Mécanique clé |
|--------|---------|---------------|
| 🌸 Printemps | Mars-Mai | Semis printemps, mise à l'herbe, 1er apport N |
| ☀️ Été | Juin-Août | Récoltes céréales, fenaison, irrigation |
| 🍂 Automne | Sept-Nov | Semis d'hiver, rentrée bâtiment, vente broutards |
| ❄️ Hiver | Déc-Fév | Repos végétatif, travaux bâtiment, planning, vêlages |

L'interface change visuellement (palette, illustrations). La météo est cohérente avec la saison.

---

## 12. Animaux

- **Reproduction** disponible pour toutes les espèces (bovins, volaille, etc.).
- **Mort** par négligence : dégradation progressive sur ~2 semaines IG sans nourriture, puis décès.
  - J1-3 : production baisse, perte de poids.
  - J4-10 : production arrêtée, santé décline.
  - J10-14 : risque de mort élevé → **mort**.
- Alerte dès le premier jour de sous-alimentation.
- Mortalité naturelle : vieillesse (durée de vie par espèce), maladies non soignées.
- Cycles spécifiques par espèce (gestation, lactation, ponte, engraissement).
- Vente entre joueurs via annonces (chaque animal est unique : âge, génétique, état). Prix minimum obligatoire.

---

## 13. Automatisation

- L'automatisation est un **gameplay**, pas un paywall.
- **Employés** : embauche contre salaire mensuel, fournit des HT supplémentaires, polyvalent.
- **Robots** (traite, alimentation) : investissement lourd (150-180k€), coût d'entretien.
- **Ordres permanents** : "Vendre à la coop quand le silo est plein" — gameplay natif.
- Progression naturelle : début = tout à la main → milieu = premiers employés → endgame = ferme largement automatisée.
- Toute automatisation nécessite investissement financier + entretien + progression.

---

## 14. Bâtiments

- **Construction avec délai** : variable selon taille (quelques jours IG à 1-2 mois IG).
- **Premium = skip du délai de construction** (construction instantanée). Seul avantage temporel du Premium.
- Coût : prix fixe selon type + taille.
- Destruction possible (terrain redevient libre). Pas de revente de bâtiment.
- Agrandissement possible pour certains bâtiments (ajouter des places).
- Le joueur gratuit obtient le même bâtiment, juste quelques jours plus tard.

---

## 15. Anti-abus

- **Prix minimum** sur toute transaction joueur→joueur (~70-80% du prix coop) — empêche le transfert de richesse déguisé.
- **Anti-multicompte** : fingerprint navigateur, patterns IP, alertes sur transferts répétés, rate limit 3 comptes/IP/24h.
- **Bots bannis** : CGU interdit explicitement scripts, bots, automation externe. Détection par rate limiting API + patterns anormaux.
- **Sanction** : ban permanent, pas de warning. Appel possible via support.
- Matériel de départ non-revendable 7 jours (anti-exploitation d'inscription).

---

## 16. Communication

- **Chat global** : canal serveur, tous les joueurs. Modération auto (filtres) + signalement.
- **Chat privé** : messages directs entre joueurs. Signalement disponible.
- **Forum intégré** : catégories, topics, posts (coopératives, aide, marché). Modération auto + modérateurs joueurs.
- Pas de dépendance à un service externe (Discord = complémentaire, pas obligatoire).
- Filtres mots interdits, anti-spam, liens suspects.

---

## 17. Progression

- **Niveaux** : niveau global du joueur (XP gagnée via les actions).
- **Objectifs in-game** : quêtes/missions ("Récoltez votre premier blé", "Atteignez 50 vaches").
- **Badges** : accomplissements débloqués, affichables sur le profil (Premier semis, Millionnaire, Vétéran…).
- **Classements** : rendement, génétique, patrimoine, ancienneté, efficience.
- Déblocage fonctionnel par le niveau (à calibrer en phase d'équilibrage).

---

## 18. Matériel

- **Occasion** : vente exclusivement via un **concessionnaire-joueur** (métier de joueur, Phase 8). Dépôt-vente + commission.
- Avant Phase 8 : achat/vente via la coop uniquement.
- **Achat neuf** : via le concessionnaire (licences de marques).
- **Catalogue** : ~200 matériels, **45+ marques réelles**.
- **Argus** : valeur estimée basée sur âge + usure (transparent).
- Usure progressive (+0.1%/jour, ×1.5 si pas sous hangar), pannes aléatoires si usure > 50%.

---

## 19. Late joiner

- **Pas de rattrapage artificiel.** Pas de bonus, pas de protection, pas de catch-up mécanique.
- Un joueur tard venu rattrape **s'il joue bien**, naturellement, avec le temps.
- Les **parcelles réservées** (10/mois, 5j exclusivité) suffisent — le foncier n'est jamais monopolisé.
- Le jeu génère toujours de nouvelles parcelles : terrain infini, pas de pénurie.

---

## 20. Mode Normal vs Expert

Même jeu, **niveau d'assistanat différent** :

| Aspect | Normal | Expert |
|--------|--------|--------|
| Météo | Simplifiée (3 niveaux) | Complète (température, pluvio, vent, gel) |
| Fertilisation | Dose recommandée auto-calculée | Calcul N-P-K manuel |
| Maladies | Alertes + traitement suggéré | Détection manuelle (scouting) |
| Rotation | Suggestions, pénalité visible | Pas de suggestion, effet masqué |
| Génétique | Index simplifiés (bon/moyen/faible) | 14 index détaillés |
| Aide | Tutoriels intégrés, tooltips | Documentation wiki, pas d'aide in-game |
| HT | Coûts fixes visibles | Coûts variables selon conditions |

Les deux serveurs partagent les mêmes systèmes techniques. Seul le niveau de transparence et d'assistanat change.

---

---

## 21. Politique monétaire

- **Trois puits légers** : entretien matériel/bâtiment (proportionnel patrimoine), charges fixes progressives, commission marché 5%.
- **Puits early-game** (actifs dès le jour 1) : fermage mensuel (90-250€/ha/an), aliment acheté à la coop (destruction monétaire car achat au bot), cotisations sociales mensuelles (pas annuelles).
- **Puits late-game récurrents** : entretien annuel viticulture (30k€/an), maintenance méthaniseur (15k€/an), projets communautaires coopératives joueurs (infrastructure collective = gouffre récurrent), investissements prestige (manoir, parc, collection vintage).
- **Prix plancher** : la coop rachète toujours à 80% du prix de référence.
- **Prix plafond** : marché joueur↔joueur plafonné à 200% du prix de référence. Decay temporel : sans transaction en 7 jours IG, plafond -= 5%/tick (mean reversion).
- **Variation max** : ±15%/semaine (Normal), ±25%/semaine (Expert).
- **Anti-manipulation** : volume maximum détenu par joueur = 10× sa production mensuelle par produit. Au-delà = taxe de stockage 2%/semaine.
- Objectif : masse monétaire stable, croissance < 2%/mois IG après 12 mois serveur.
- Référence : ADR-007.

---

## 22. Abonnement (2 tiers)

- **AgriPass** : 3,99 €/mois — stats avancées, notifications push/email, badge profil, thème visuel.
- **AgriPass+** : 7,99 €/mois — tout AgriPass + cosmétiques exclusifs mensuels, 2ème ferme sandbox (même serveur, patrimoine plafonné 50k€, pas de marché joueur = bac à sable pour tester des stratégies sans avantage transférable), concours cosmétiques, fiche personnalisée avancée.
- **Robot de traite** : achat in-game pour TOUS les joueurs (150-180k€). AgriPass réduit le coût d'entretien du robot de 20% (cosmétique économique, pas productif). Le robot ne produit PAS plus de lait, il libère des HT.
- **Construction instantanée** : skip du délai de construction (seul avantage temporel).
- **Battle Pass cosmétique** : 4,99€/trimestre — skins saisonniers, décorations, avatars. Contenu frais rotatif.
- Référence : ADR-014.

---

## 23. Règle anti-P2W (testable)

> « Un joueur F2P avec le même temps de jeu ET les mêmes décisions doit atteindre ±5% des résultats économiques d'un abonné. Si ce n'est pas le cas, la feature est P2W et doit être retirée. »

- Charte complète : `docs/design/CHARTE-MONETISATION.md`
- Référence : ADR-008.

---

## 24. Équilibrage ROI par profil

- **Cible** : chaque profil entre ×2 et ×10 de ROI sur 4 ans IG.
- **Poule** : plafonnée à ×8-10 (nerf HT, bâtiment coûteux, reproduction limitée 1 couvée/2 mois).
- **Allaitant** : relevé à ×2-3 (aides PAC 200€/VA, prime extensivité 80€, prime bio 120€).
- **Laitier** : ×3-5 (inchangé, équilibré naturellement).
- **Céréalier** : ×2-3 (inchangé, base du jeu).
- Référence : ADR-012.

---

## 25. Feedback mid-cycle et rétention

- **Milestones visuels** : notification + changement visuel à chaque stade de culture (levée J+3, tallage J+7, épiaison J+14, maturation J+21).
- **Décisions intermédiaires optionnelles** : fongicide en montaison, désherbage en début tallage — le joueur revient pour agir, pas juste observer.
- **Micro-événements quotidiens** : 15-20 événements rotatifs (prime qualité, demande acheteur, bruit moteur suspect, proposition échange voisin). 2-3 par semaine par joueur.
- **Session express** : batch action « Plan du jour » en 1 tap — dépense les HT disponibles selon priorité auto-déterminée.

---

## 26. Mobile-first (5 écrans)

Écrans mobile-first prioritaires (design pouce d'abord, desktop ensuite) :
1. **Dashboard** — synthèse, budget HT, alertes, micro-événements
2. **Parcelle** — action sur une parcelle individuelle (semer, récolter, traiter)
3. **Marché** — acheter/vendre (coop + joueur)
4. **Élevage** — vue troupeau, nourrir, soigner, déplacer
5. **Récap Connexion** — ce qui s'est passé depuis la dernière visite

Le reste est responsive classique (desktop-first, adapté mobile).

---

## 27. Dimension sociale dès Phase 3

- **Coopératives joueurs** (Phase 3) : création, cotisation, achat groupé, projets communs (infrastructure = money sink collectif).
- **ETA simplifié** (Phase 4) : un joueur peut offrir des prestations de travail aux voisins (labour, moisson, transport). Prix libre + commission 5%.
- **CESA / CFSA** (Phase 5) : institutions politiques joueurs avec élections, budgets, votes sur règles serveur.
- Les métiers complets (concessionnaire, transporteur, CIA) restent en Phase 8 mais le **tissu social de base est actif dès Phase 3**.

---

## Historique des modifications

| Date | Modification |
|------|-------------|
| 2026-08-05 | Ajout §25-27 : feedback mid-cycle, mobile-first 5 écrans, social dès Phase 3. Corrections panel d'experts (robot F2P, sinks récurrents, anti-manipulation, 2ème ferme sandbox, Battle Pass) |
| 2026-08-05 | Ajout §21-24 : politique monétaire, abonnement 2 tiers, règle anti-P2W, équilibrage ROI — suite résolution de 17 décisions ouvertes (ADR-007 à ADR-017) |
| 2026-08-04 | Création du document — consolidation de toutes les décisions GD validées (session 2026-08-04) |
