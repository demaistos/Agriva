> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


> ⚠️ **Note** : Ce document de review est antérieur aux décisions validées dans `GDD-SOURCE-VERITE.md`. Certains points soulevés ici ont été tranchés depuis.


# Review GDD Agriva — Point de vue d'un Joueur Vétéran SimAgri (5+ ans)

> Date : 2026-08-04
> Statut : Review critique
> Auteur : Joueur vétéran SimAgri (profil multi-filières, 5+ ans d'expérience)
> Base : FOUNDATION.md, étude économique profils joueurs, GAME_DESIGN.md legacy

---

## Préambule

J'ai joué à SimAgri de 2008 à 2015. Polyculture-élevage, 200+ ha, coopérative active, concessionnaire, participation GénétiSim. Je connais le méta, les exploits, et les frustrations qui faisaient rage dans la communauté. Voici ma lecture critique du design d'Agriva.

---

## 1. Mes 10 QUESTIONS CRITIQUES

### Q1 — Le système de HT : vous gardez 35 HT/jour ou vous changez ?

Le doc FOUNDATION mentionne 50-80 HT dans l'étude économique, mais SimAgri c'était **35 HT/jour**. C'est THE question. 35 HT c'était un corset volontaire qui forçait les choix. C'est ce qui faisait la profondeur stratégique : tu ne peux PAS tout faire, donc tu dois prioriser. Si vous passez à 80 HT, vous détruisez la tension fondamentale du jeu. Les joueurs vétérans veulent un jeu de **gestion de la rareté**, pas un idle game.

**Recommandation** : garder un HT limité (35-45 max) et que l'extension se fasse via l'embauche d'employés (comme dans SimAgri).

### Q2 — L'employé et le multi-compte : comment vous gérez ?

Dans SimAgri, le vrai "exploit" n'était pas un bug — c'était le multi-compte. Un joueur avec 3 comptes avait 3×35 HT par jour + pouvait faire des échanges internes sous prix. Le système d'employé était censé résoudre ça (ajouter des HT légitimement) mais c'était trop cher pour les petits joueurs.

**Question** : Comment détectez-vous le multi-compte ? IP seule ne suffit pas (VPN). Limitez-vous les échanges entre comptes récents ?

### Q3 — L'économie joueur : marché libre ou prix plancher ?

Le marché SimAgri était le cœur du jeu. MAIS il avait un problème fondamental : les monopoles. Un joueur riche pouvait racheter tout le stock d'un produit et fixer le prix. Les coops organisées contrôlaient des pans entiers de l'économie.

**Question** : Y a-t-il un mécanisme anti-monopole ? Des prix plancher/plafond ? Ou faites-vous confiance au marché libre total comme SimAgri ?

### Q4 — Le temps avant le premier revenu pour les céréaliers : c'est fatal pour la rétention

Votre étude dit 6-9 mois in-game avant le premier €. C'est **1-2 mois réels** de jeu sans rien gagner. Dans SimAgri, les nouveaux céréaliers décrochaient massivement. C'est la cause n°1 de churn.

**Question** : Comment garantissez-vous un revenu précoce pour les profils "lents" ? Le CFSA (mentorat) ne suffit pas — il faut un revenu mécanique dès la première semaine.

### Q5 — La volaille "broken" : vous la laissez ou vous la nerf ?

Je lis votre étude économique : vous avez parfaitement identifié que la poule est Tier S. Dans SimAgri, TOUT le monde faisait des poules au départ. C'était le méta obligatoire. Et c'est à la fois un problème (déséquilibre) et une qualité (gratification rapide).

**Question** : Allez-vous limiter la reproduction avicole ? Si oui, par quel mécanisme (HT, maladies, coût bâtiment) ? Si non, comment évitez-vous que le marché aux poules s'effondre en permanence ?

### Q6 — Le système de déplacement (0.25 HT/zone) : c'est un money sink ou un gameplay ?

Dans SimAgri, le déplacement consommait des HT. C'était logique mais frustrant — traverser le pays pour livrer un tracteur coûtait plus cher que le bénéfice. Les joueurs en bout de map étaient pénalisés injustement.

**Question** : Gardez-vous ce système ? Si oui, comment compensez-vous l'inégalité géographique ? Si non, par quoi le remplacez-vous ?

### Q7 — Les concessionnaires et CIA : comment évitez-vous les cartels ?

Les activités annexes (concessionnaire, CIA, transporteur) étaient les vraies machines à cash dans SimAgri endgame. MAIS elles créaient des oligopoles : 2-3 concessionnaires par serveur contrôlaient tout le marché du matériel. Même chose pour les CIA (insémination).

**Question** : Y a-t-il une limite au nombre de concessionnaires ? Des mécanismes de concurrence forcée ? Des prix régulés pour certaines activités ?

### Q8 — GénétiSim et les concours : quel est le plan endgame ?

Pour un vétéran, le vrai endgame de SimAgri c'était la génétique. Sélectionner, croiser, optimiser les indices génétiques. Les concours GénétiSim étaient l'événement social majeur. Sans ça, le jeu perd son sel à long terme.

**Question** : Les concours sont-ils dans la roadmap proche ou lointaine ? La génétique sera-t-elle aussi profonde (indices multiples, OG par race, IVRAD) ? C'est non-négociable pour la rétention des vétérans.

### Q9 — Le ratio matériel neuf/occasion : comment ne pas tuer l'occasion ?

SimAgri avait un marché de l'occasion vivant. MAIS le problème : les concessionnaires vendaient du neuf avec une marge si faible que l'occasion n'était intéressante que sous 60% du prix neuf. Résultat : l'occasion était morte sauf pour les tout petits joueurs.

**Question** : Comment équilibrez-vous la filière neuf (concession) vs occasion (joueur à joueur) pour que les deux aient un rôle économique réel ?

### Q10 — Le F2P + abo confort : où mettez-vous la frontière ?

SimAgri avait le SimPass. Sans lui, tu ne pouvais pas être concessionnaire, ni accéder à certaines features. C'était un mur. Vous dites "F2P + abo QoL, jamais P2W". Très bien. Mais la frontière est floue.

**Question** : Quelles features exactes sont derrière l'abo ? Si c'est cosmétique seulement, c'est insuffisant pour monétiser. Si ça touche le gameplay (HT bonus, file d'attente, automatisation), c'est du P2W déguisé. Où est la ligne ?

---

## 2. Mes 5 FRUSTRATIONS de SimAgri à ne SURTOUT PAS reproduire

### F1 — L'interface à 47 clics pour une action simple

Déplacer un animal du bâtiment au pré : sélectionner le bâtiment → cliquer l'animal → choisir "déplacer" → choisir la destination → confirmer. **Par animal.** Avec 40 vaches à sortir au printemps, c'était 200+ clics. Même chose pour le matériel : chaque passage de cultivateur = sélectionner tracteur + outil + parcelle + confirmer + attendre le rechargement de page.

**Ce qu'il faut** : actions en masse, sélection multiple, "sortir tout le troupeau", ordres permanents (ex: "toujours sortir au pré du 1er avril au 31 octobre").

### F2 — Le temps réel mal géré : tu manques ta fenêtre de récolte = tu perds ta saison

Le blé est mûr entre le 1er et le 15 juillet SimAgri. Si tu pars en vacances IRL pendant ces 2 jours réels, ta récolte est perdue. C'est INACCEPTABLE pour un jeu qui prétend être casual-friendly. Les joueurs les plus hardcore étaient les seuls à ne jamais rater une fenêtre.

**Ce qu'il faut** : fenêtres de récolte plus larges, système d'automatisation basique (ETA auto si le joueur ne récolte pas à temps), ou au minimum un système de notification push sérieux avec possibilité d'action mobile rapide.

### F3 — Le nouveau joueur lâché dans un serveur mature = mort assurée

Arriver sur un serveur où les vétérans ont 500 ha, des coops de 50 joueurs, et contrôlent tous les prix... c'est décourageant. Tu ne peux rien acheter (les terres sont prises), rien vendre à bon prix (les gros fixent les cours), et personne ne te prête attention.

**Ce qu'il faut** : des serveurs à ouverture régulière (saisons), ou un système de handicap/boost pour les nouveaux entrants, ou des zones protégées pour les 3 premiers mois réels.

### F4 — Les pannes matériel = punition aléatoire sans contrepartie fun

Ta moissonneuse tombe en panne le jour de la récolte. Tu ne peux rien faire. Tu attends 2 jours IRL (= 2 mois in-game = ta récolte est fichue). L'aléa punitif sans possibilité de réaction est la définition de la frustration anti-fun.

**Ce qu'il faut** : soit supprimer les pannes bloquantes (juste un malus de rendement/coût), soit donner une réaction immédiate (appeler le dépanneur = coût mais pas de blocage), soit un système d'assurance qui fonctionne vraiment (pas juste un remboursement partiel après coup).

### F5 — La non-communication des mécaniques cachées

SimAgri ne documentait RIEN clairement. Les formules de rendement, les coefficients génétiques, les seuils d'alimentation — tout était deviné par la communauté via trial-and-error sur des mois. C'est fun pour 5% de théorycrafters. C'est une barrière insurmontable pour 95% des joueurs.

**Ce qu'il faut** : transparence totale sur les mécaniques. Un joueur doit pouvoir comprendre POURQUOI il obtient tel rendement, POURQUOI sa vache produit tant de lait. Aide contextuelle, formules affichées, historique des facteurs. Pas de boîte noire.

---

## 3. Mes 5 FEATURES que j'attends ABSOLUMENT

### Feature 1 — Automatisation programmable (ordres permanents)

Le gros manque de SimAgri. Je veux pouvoir dire : "Chaque mois, acheter automatiquement 2T d'aliment si le stock descend sous 5T". "Sortir les vaches au pré le 1er avril, les rentrer le 31 octobre". "Vendre les œufs automatiquement si le prix dépasse X€".

C'est le QoL qui sépare un jeu de gestion moderne d'un jeu à clics de 2005. Les HT restent la limite stratégique — mais les actions RÉPÉTITIVES doivent être automatisables.

### Feature 2 — Dashboard synthétique en temps réel

SimAgri c'était 15 pages différentes pour avoir une vue d'ensemble. Je veux UN dashboard qui me dit : état de mes parcelles, état de mes troupeaux, trésorerie, alertes, et actions recommandées. En un coup d'œil. Sur mobile. C'est la promesse du FOUNDATION.md ("information par couches") — tenez-la.

### Feature 3 — Système social moderne (coopérative ≠ galère)

Les coopératives SimAgri c'était du management de Google Sheets. Pas d'outils intégrés pour coordonner les achats, les livraisons, la répartition des bénéfices. Tout se faisait "à la main" via forum.

Je veux : un vrai système coop avec gestion des rôles, partage de ressources, objectifs communs, classement inter-coops, et surtout **des outils qui rendent la coordination triviale** (pas un deuxième travail).

### Feature 4 — Progression visible et milestones

SimAgri n'avait aucun sens de la progression. Pas de "level up", pas de déverrouillage satisfaisant. Tu grandissais... et c'est tout. Le seul feedback c'était le classement global (qui ne bougeait plus après 2 ans).

Je veux : des milestones (première récolte, premier veau, 100 ha, première transformation), des déblocages progressifs de complexité (viticulture après 6 mois, concessionnaire après 1 an), des achievements qui ont du sens et une timeline personnelle qui montre l'évolution de ma ferme.

### Feature 5 — Économie transparente avec historique

Les prix du marché dans SimAgri : tu voyais le prix actuel. Point. Pas d'historique, pas de tendance, pas de volume échangé. Tu ne pouvais pas faire de décision éclairée.

Je veux : graphiques de prix sur 3/6/12 mois, volumes échangés par jour, alertes prix, et idéalement un "carnet d'ordres" simplifié. Le jeu prétend simuler l'économie agricole — donnez-nous les outils pour y jouer intelligemment.

---

## 4. Mes 3 EXPLOITS/ABUS connus qu'il faut PRÉVENIR

### Exploit 1 — Le "Poule Rush" avec multi-comptes coordonnés

**Le mécanisme** : Un joueur crée 3 comptes. Chacun démarre en poules. Après 3 mois réels, chaque compte a 100+ poules. Les comptes secondaires vendent leurs poules/œufs sous le prix marché au compte principal, qui accumule un capital monstrueux sans effort réel.

**Pourquoi c'est broken** : Le multi-compte transforme le jeu en "celui qui a le plus de comptes gagne". La poule amplifie l'effet car le ROI est massif avec un investissement nul.

**Prévention recommandée** :
- Détection multi-compte (fingerprinting navigateur + patterns comportementaux + timing des échanges)
- Cooldown sur les échanges entre comptes ayant des patterns similaires
- Limite de transactions entrantes pour les comptes de moins de 2 mois réels
- Taxe de transaction progressive (les échanges très en-dessous du prix marché sont taxés lourdement)

### Exploit 2 — Le "Monopole concessionnaire" avec prix prédateurs

**Le mécanisme** : Un concessionnaire riche baisse ses prix sous le coût de revient pendant 2-3 mois. Les autres concessionnaires font faillite (pas assez de trésorerie pour tenir). Une fois seul, il remonte les prix à +40%. Le serveur est otage.

**Pourquoi c'est broken** : C'est du dumping IRL et c'est aussi toxique en jeu. Les joueurs qui se faisaient évincer quittaient le jeu.

**Prévention recommandée** :
- Prix plancher calculé sur le coût de revient (impossible de vendre à perte durablement)
- Limite de parts de marché par concessionnaire (max 40-50% des ventes d'une zone)
- Système d'enchères/appels d'offres pour les gros marchés (empêche le lock-in)
- Possibilité pour les joueurs de commander directement "hors zone" avec surcoût transport (= toujours une alternative)

### Exploit 3 — Le "Farm de HT" via ETA/transport fictif

**Le mécanisme** : Un joueur crée une ETA. Son multi-compte commande des travaux. Le compte ETA effectue les travaux, consomme ses HT, mais génère de l'argent depuis le multi-compte. En pratique, c'est un transfert déguisé de capital entre comptes via des "services" fictifs.

**Variante transport** : Le même principe avec le transport. Le joueur A demande un transport fictif (déplacer 1T de blé d'un silo à l'autre), le joueur B (multi-compte) est payé pour un service inutile.

**Pourquoi c'est broken** : Ça contourne toute régulation économique. Les "services entre joueurs" sont impossibles à distinguer des transferts déguisés si on ne regarde pas le pattern.

**Prévention recommandée** :
- Analyse des patterns : si 2 comptes échangent >80% de leur volume entre eux, flag automatique
- Les ETA/transporteurs doivent avoir un minimum de clients distincts (ex: 5 clients différents/mois) pour maintenir leur licence
- Ratio prix/volume réaliste : un transport de 1T sur 1 zone ne peut pas coûter 10 000€
- Plafond de prix pour les services, indexé sur des barèmes objectifs (distance × tonnage × coefficient)

---

## Conclusion — Mon verdict global

Le FOUNDATION.md me rassure : la vision est claire, fidèle, et ambitieuse. L'étude économique montre que l'équipe comprend les mécaniques profondes et les déséquilibres historiques.

**Ce qui me rend optimiste :**
- La volonté de moderniser l'UX sans changer la formule
- L'identification claire du problème "poule Tier S"
- L'approche F2P vs l'ancien SimPass
- Le responsive/mobile (game changer pour la rétention)

**Ce qui m'inquiète :**
- Le HT à 50-80 (trop généreux → perte de tension stratégique)
- L'absence de discussion sur le multi-compte (LE problème #1 de SimAgri)
- Le manque de détail sur l'endgame (génétique, concours, activités annexes avancées)
- La promesse de "119 sous-systèmes" — attention à l'effect scope creep vs polish

**Mon conseil final** : Lancez avec un core loop serré (cultures + 2-3 élevages + marché joueur). Polissez-le à mort. Le reste viendra. SimAgri est mort parce qu'il a arrêté de se développer, pas parce qu'il manquait de features au lancement.

---

> *"SimAgri c'était 80% de frustration d'interface et 20% de pur génie de game design. Gardez le génie, tuez la frustration."*
