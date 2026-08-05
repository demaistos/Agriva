# Agriva — Economy & Markets
> Sections : 13-18, 23-24, 38-40

---

## 13. Économie générale

### 13.1 Type d’économie
Le jeu doit utiliser une économie hybride : bot + joueur.

### 13.2 Rôle du bot
Le bot garantit la jouabilité, la liquidité et le démarrage.

### 13.3 Rôle du joueur
Le marché joueur doit rester plus intéressant, plus stratégique et plus vivant.

### 13.4 Anti-arbitrage
Le bot ne doit pas devenir une machine à profit.

### 13.5 Question d’économie

### 13.6 Recommandation V1 — Économie
- Option retenue pour la V1 : **B. Joueur dominant avec bot de secours**.
- Justification : le marché joueur doit être le principal lieu de création de valeur et de stratégie, tandis que le bot sert de filet de sécurité pour garantir la liquidité et éviter les situations de blocage économiques.
- Rôle du bot : **C. Bot = filet de sécurité**, garantissant des prix bornés, une possibilité de vendre/acheter en dernier recours et l’amortissement des erreurs, sans jamais être plus rentable que le marché joueur.
- Conséquences design :
  - tous les flux critiques doivent être faisables via marché joueur ;
  - les prix bot sont toujours moins intéressants que les meilleurs prix joueurs, à volume comparable ;
  - les boucles de jeu les plus rentables doivent impliquer d’autres joueurs, pas le bot ;
  - les systèmes d’anti-arbitrage (spread, décotes, rendements décroissants) sont obligatoires côté bot.
- À reporter et maintenir dans agriva_decisions_log.md comme décision structurante de l’économie.

- Préciser ici le type d’économie retenu pour la V1 (A/B/C) et le rôle exact du bot.
- Reporter la décision dans agriva_decisions_log.md.

- A. Hybride joueur + bot.
- B. Joueur dominant avec bot de secours.
- C. Bot dominant au départ puis progressivement secondaire.

### 13.6 Rôle du bot
- A. Liquidité.
- B. Amortisseur.
- C. Filet de sécurité.

---

## 14. Coopératives bot

### 14.1 Structure
Chaque département possède une coopérative bot centrale.

### 14.2 Rôle
Acheter, vendre, sécuriser les flux, amortir les déséquilibres.

### 14.3 Limites
Le joueur ne doit pas pouvoir construire durablement son exploitation sur le bot.

### 14.4 Question de localisation
- A. Préfecture / capitale départementale.
- B. Pôle logistique local.
- C. Préfecture en V1 + autres nœuds plus tard.

---

## 15. Marché joueur

### 15.1 Portée
*(Voir aussi section 74.2 pour le catalogue d’actions de marché bot/joueur.)*

Le marché joueur doit être national.

### 15.2 Filtres
Type, quantité, prix, qualité, origine, disponibilité, vendeur joueur / coopérative.

### 15.3 Logistique
Le marché national doit être compensé par coûts, délais et choix de livraison / retrait.

### 15.4 Question de structure
- A. Petites annonces.
- B. Ordres d’achat / vente.
- C. Système hybride.

---

## 16. Animaux

### 16.1 Achat au bot
Le bot doit permettre l’achat d’animaux de base pour lancer une activité.

### 16.2 Limites
Le bot ne doit pas permettre de bâtir de manière optimale de grandes exploitations d’élevage.

### 16.3 Mécanique recommandée
- quota par période ;
- qualité plafonnée ;
- prix croissant par tranche ;
- reproduction plus importante à long terme.

### 16.4 Question de rôle du bot
- A. Lancer l’atelier.
- B. Lancer + dépanner.
- C. Lancer + dépanner + fournir une base, pas la croissance.

---

## 17. Prix et anti-exploit

### 17.1 Spread permanent
Acheter et revendre au bot ne doit jamais être rentable.

### 17.2 Diminution de rentabilité
Les ventes massives au bot doivent devenir moins rentables.

### 17.3 Règle fondatrice
Le bot sécurise la liquidité, pas la rentabilité.

### 17.4 Question anti-arbitrage
- A. Spread simple.
- B. Spread + décote rapide.
- C. Spread + tag d’origine + rendements décroissants.

---

## 18. Stockage et logistique

### 18.1 Stockage
Permettre d’attendre le bon prix, lisser les pics et différer la vente.

### 18.2 Logistique
Peut rester abstraite en V1, puis devenir plus structurante plus tard.

### 18.3 Dépendance au territoire
Les coûts et délais logistiques doivent renforcer le territoire.

---


---

## 23. Objectifs et classements

### 23.1 Classements
Peuvent être segmentés par mode, activité, saison, région et profil de jeu.

### 23.2 Objectifs
Peuvent être personnels, saisonniers, de ligue, de maîtrise ou d’expertise.

### 23.3 Question de segmentation
- A. Par mode.
- B. Par mode + activité.
- C. Par mode + activité + saison + région.

---

## 24. Risques

### 24.1 Types de risques
- météo ;
- maladie ;
- panne ;
- dette ;
- prix ;
- logistique ;
- disponibilité du travail.

### 24.2 Lisibilité
Les risques doivent être annoncés avant d’être punis.

### 24.3 Question d’intensité
- A. Faibles.
- B. Présents mais lisibles.
- C. Structurants.

### 24.4 Recommandation V1 — Risques
- Option retenue pour la V1 : **B. Présents mais lisibles**.
- Justification :
  - il faut qu’il y ait de vrais risques (météo, prix, pannes, maladies, etc.) pour que les décisions aient du poids ;
  - mais ils doivent rester anticipables et compréhensibles, avec des signaux avant-coureurs et des moyens d’atténuation ;
  - les risques véritablement “structurants” (crises majeures, événements rares violents) pourront être introduits plus tard.
- Conséquences design :
  - la plupart des risques doivent être annoncés via les alertes et les dashboards (tension météo, tension de trésorerie, tension logistique) ;
  - les solutions (assurance, diversification, stockage, contrats) doivent être vraisemblables et accessibles ;
  - les punitions surprises et arbitraires doivent être évitées en V1.

---


---

## 38. Concurrence et marchés

### 38.1 Le marché joueur doit-il être asymétrique ?
- A. Non.
- B. Oui, un peu.
- C. Oui, fortement selon les filières.

### 38.2 La concurrence se joue sur ?
- A. Le prix.
- B. Le prix + le temps.
- C. Le prix + le temps + la qualité + la réputation.

### 38.3 Peut-on créer des niches ?
- A. Non.
- B. Oui, partiellement.
- C. Oui, c’est un objectif central.

## 39. Données territoriales

### 39.1 Quel niveau de détail territorial ?
- A. Très abstrait.
- B. Département + indicateurs clés.
- C. Département + localité + tendances fines.

### 39.2 Quels indicateurs territoriaux ?
- A. Météo et population.
- B. Météo, prix, sols.
- C. Météo, prix, sols, logistique, densité d’activité.

### 39.3 Les différences territoriales sont-elles ?
- A. Faibles.
- B. Modérées.
- C. Forte identité de gameplay.

## 40. Objectifs long terme

### 40.1 Quelle structure d’objectifs ?
- A. Objectifs personnels simples.
- B. Objectifs personnels + saisonniers.
- C. Objectifs personnels + saisonniers + ligues + prestige.

### 40.2 La victoire existe-t-elle ?
- A. Non.
- B. Oui, partiellement.
- C. Oui, mais multiple selon le style de jeu.

### 40.3 L’échec existe-t-il ?
- A. Non, seulement ralentissement.
- B. Oui, faillite partielle.
- C. Oui, mais avec redressement et second souffle.
