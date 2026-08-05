> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


> ⚠️ **Note** : Ce document de review est antérieur aux décisions validées dans `GDD-SOURCE-VERITE.md`. Certains points soulevés ici ont été tranchés depuis.


# Review Économique du Game Design — Agriva

> Date : 2026-08-04
> Auteur : agent:game-economist
> Statut : Review critique
> Base d'analyse : FOUNDATION.md, ROADMAP.md, etude-economique-profils-joueurs.md

---

## Préambule

En tant qu'économiste de jeu spécialisé dans les titres F2P de simulation/gestion à progression longue, cette review analyse la viabilité et la cohérence du système économique d'Agriva. Le jeu présente un design ambitieux — reproduire la profondeur de SimAgri sur une stack moderne avec un modèle F2P + abonnement confort. L'étude économique des profils joueurs est remarquablement détaillée, mais soulève des questions fondamentales sur la santé à long terme de l'économie.

---

## 1. Les 10 Questions Critiques

### Q1 — Où sont vos puits monétaires (money sinks) ?

L'étude détaille abondamment les **sources** de revenus (cultures, lait, œufs, viande), mais je ne vois **aucune description systématique des puits** qui absorbent l'argent. Les charges fixes (fermage, cotisations, assurance à 380 €/ha) et l'alimentation animale sont mentionnées, mais dans un jeu à progression sur 4+ années in-game :

- Qu'arrive-t-il à l'inflation quand un joueur à 500 000 € de patrimoine injecte du cash dans le marché joueur ?
- Quels mécanismes détruisent la monnaie de manière scalable (proportionnelle à la richesse) ?
- L'usure du matériel et les pannes sont-elles des puits suffisants à l'endgame ?

**Sans puits proportionnels à la création de richesse, l'hyperinflation est mathématiquement inévitable.**

---

### Q2 — D'où vient l'argent frais injecté dans le serveur ?

Quand un joueur vend à la coopérative (bot), c'est le système qui crée de l'argent *ex nihilo*. Si 200 joueurs actifs vendent tous à la coop simultanément, c'est une source d'inflation pure.

- Quel est le ratio de transactions joueur↔joueur vs joueur↔système (coop) ?
- La coopérative a-t-elle un budget limité ou crée-t-elle de l'argent à l'infini ?
- Existe-t-il un plafond d'injection monétaire par tick/jour/mois ?

**Dans SimAgri, la masse monétaire était probablement contrôlée par la faible base de joueurs et l'attrition naturelle. Avec un F2P moderne attirant potentiellement 10× plus de joueurs, ce levier disparaît.**

---

### Q3 — Comment éviter le syndrome "poule = méta obligatoire" ?

L'étude elle-même identifie la poule comme TIER S avec un ROI de ×50-100. C'est **un red flag majeur**. Si la stratégie optimale est connue et accessible à tous (investissement nul), alors :

- Pourquoi un joueur rationnel ferait-il AUTRE CHOSE que des poules au départ ?
- Comment le jeu reste-t-il intéressant si 80% des joueurs convergent vers le même build ?
- Le marché joueur peut-il réellement réguler quand l'offre est quasi-infinie (reproduction exponentielle) ?

**La "diversité de gameplay" est un objectif de design, mais l'économie actuelle punit activement la diversification précoce.**

---

### Q4 — Quelle est votre politique de prix plancher/plafond sur le marché dynamique ?

Le document mentionne des "prix dynamiques offre/demande" mais ne décrit pas :

- Y a-t-il un prix plancher garanti par la coopérative (filet de sécurité) ?
- Y a-t-il un prix plafond pour éviter la spéculation abusive ?
- Que se passe-t-il si un groupe de joueurs riches achète TOUT le stock d'un produit pour manipuler le cours ?
- Quelle est la vitesse d'ajustement des prix ? (Trop rapide = flash crashes, trop lent = exploitation)

**Un marché dynamique sans garde-fous détruit la confiance des joueurs et favorise les exploiteurs.**

---

### Q5 — Comment gérez-vous le "late joiner problem" ?

Un joueur qui rejoint le serveur 6 mois après l'ouverture fait face à :
- Des joueurs établis à 200 000+ € de patrimoine
- Un marché dont les prix ont été établis par des joueurs riches
- Des terres peut-être déjà toutes achetées (si offre limitée)
- Un sentiment immédiat d'être "en retard"

- Existe-t-il un mécanisme de catch-up ?
- Les nouveaux serveurs sont-ils la seule réponse (fragmentant la communauté) ?
- Le modèle F2P/abo offre-t-il des accélérateurs de rattrapage sans être P2W ?

**Ce problème a tué des jeux de gestion MMO. Sans réponse claire, la rétention des nouveaux joueurs après les 3 premiers mois du serveur sera catastrophique.**

---

### Q6 — Quel est le modèle de rétention économique à 12+ mois ?

L'étude montre qu'un joueur volaille atteint ~500 000 € en 12 mois réels. Ensuite ?

- Quels sont les objectifs financiers de l'endgame ?
- Quel est le "prestige sink" qui motive un joueur riche à continuer ? (Concours ? Classements ? Items cosmétiques ?)
- La viticulture/foresterie/foie gras (Phase 10) sont-ils suffisamment coûteux pour être des gouffres aspirationnels ?

**Un jeu de gestion F2P meurt quand les joueurs n'ont plus rien à acheter. La courbe "capital vs objectifs de dépense" doit être soigneusement calibrée.**

---

### Q7 — Comment fonctionne la banque et quel est son impact systémique ?

Le document mentionne "Banque : Épargne, emprunts (simplifié, sans CAR)" en Phase 5. Mais :

- Le taux d'intérêt est-il fixe ou dynamique ?
- Y a-t-il un risque de défaut (perte du prêt) → puit monétaire ?
- Un joueur peut-il emprunter massivement pour acheter 200 truies et rembourser en 3 mois grâce au rendement exponentiel ?
- L'emprunt est-il plafonné ? Si oui, proportionnellement à quoi ?

**L'emprunt mal calibré est le #1 exploit dans les jeux de gestion. Il transforme la progression "4 ans" en "4 mois" et tue le long terme.**

---

### Q8 — Quel est le rôle économique des HT (Heures de Travail) comme régulateur ?

Les HT sont mentionnés comme limitant naturel (50-80 HT/jour). C'est potentiellement votre meilleur levier d'équilibrage, mais :

- Le coût en HT de chaque action est-il défini ? (ramasser 1000 œufs = combien de HT ?)
- Les HT scalent-ils avec la taille de l'exploitation ou restent-ils fixes ?
- L'abonnement confort augmente-t-il les HT ? (Si oui = P2W déguisé)
- Les employés (Phase 5) donnent-ils des HT supplémentaires ? À quel coût ?

**Si les HT sont le principal bottleneck de la croissance exponentielle (poule/porc), leur calibrage EST l'équilibrage du jeu.**

---

### Q9 — Comment le modèle F2P + abo confort se monétise-t-il sans briser l'économie ?

Le document dit "F2P + abo confort (QoL), jamais P2W". Mais :

- Qu'est-ce qui est QoL et qu'est-ce qui est P2W ? La frontière est souvent floue.
- L'abo confort donne-t-il accès à l'automatisation (robots ramassage, alimentation auto) ?
- Si oui, un joueur F2P est-il compétitivement désavantagé sur les classements ?
- Quel est le revenu cible par joueur (ARPPU) pour la viabilité commerciale ?
- Y a-t-il des achats ponctuels (cosmétiques, décorations de ferme) ?

**Un F2P de niche (simulation agricole) a besoin d'un taux de conversion élevé (~5-10%) pour survivre. La proposition de valeur de l'abo doit être irrésistible sans être compétitivement nécessaire.**

---

### Q10 — Quelle est la stratégie anti-multicompte et anti-bot ?

Avec un jeu navigateur F2P où la poule rapporte ×50-100 de ROI :

- Qu'empêche un joueur de créer 10 comptes gratuits, faire des poules sur chacun, et transférer la richesse via le marché ?
- Les transactions entre joueurs sont-elles surveillées (pattern detection) ?
- Y a-t-il un délai minimum avant de pouvoir échanger sur le marché (anti-mule) ?
- Le modèle "1 semaine = 1 mois" facilite-t-il le botting (actions prévisibles) ?

**Dans un jeu où le temps est le seul frein à la richesse, le multicompte est la première exploitation que les joueurs trouveront.**

---

## 2. Les 5 Risques Économiques Majeurs

### RISQUE 1 — Hyperinflation serveur (Probabilité : ÉLEVÉE, Impact : CRITIQUE)

**Description** : La coopérative (bot) crée de l'argent ex nihilo à chaque vente. Avec la croissance exponentielle des cheptels (poule, porc), la production de biens augmente exponentiellement → les ventes à la coop augmentent exponentiellement → la masse monétaire du serveur explose.

**Mécanisme** :
```
Mois 1  : 100 joueurs × 200 €/jour vendus à la coop = 20 000 €/jour créés
Mois 6  : 100 joueurs × 2 000 €/jour (cheptels multipliés) = 200 000 €/jour créés
Mois 12 : 100 joueurs × 10 000 €/jour = 1 000 000 €/jour créés
```

**Conséquence** : Les prix du marché joueur montent, les nouveaux joueurs ne peuvent plus rien acheter, le capital de départ (50 000 €) devient insignifiant, le jeu perd tout sens économique.

**Mitigation nécessaire** :
- Taxes sur les transactions (5-10% détruites)
- Coopérative à budget limité (prix baisse si trop d'offre)
- Charges progressives (impôts sur le patrimoine, entretien croissant)
- Decay sur le matériel et les bâtiments proportionnel à la richesse

---

### RISQUE 2 — Convergence méta → mort de la diversité (Probabilité : ÉLEVÉE, Impact : MAJEUR)

**Description** : Si la stratégie "poules → cash → diversification" est objectivement 10-50× plus efficace que tout autre départ, alors le "choix" de profil est une illusion. Les joueurs informés feront tous la même chose, et les joueurs non-informés seront frustrés en découvrant qu'ils ont "perdu" 3 mois.

**Conséquence** :
- Guides/wikis montrent la méta → homogénéisation
- Le marché des œufs/poules s'effondre (offre massive)
- Les filières "lentes" (allaitant, céréalier débutant) sont perçues comme des pièges
- La diversité visible sur le serveur diminue (tout le monde a 3000 poules)

**Mitigation nécessaire** :
- Réduire l'écart de ROI entre profils (max 3-5× entre le meilleur et le pire, pas 50×)
- Mécaniques de saturation de marché agressives (prix des œufs → 0 si surproduction)
- Bonus de diversification (synergies fumier/culture, avantages multi-filière)
- Avantages exclusifs par filière (labels, concours spécifiques, déblocage de contenu)

---

### RISQUE 3 — Mur du late joiner → churn des nouveaux (Probabilité : ÉLEVÉE, Impact : MAJEUR)

**Description** : Dans un jeu à progression permanente sans reset, l'écart entre vétérans et nouveaux se creuse indéfiniment. Après 6 mois de serveur, un nouveau joueur fait face à un marché dominé par des joueurs 10-100× plus riches.

**Conséquence** :
- Les terres sont prises (si offre finie)
- Les prix du marché sont calibrés pour des joueurs riches
- Le sentiment d'impuissance pousse au churn en <2 semaines
- La communauté vieillit et ne se renouvelle pas → mort lente

**Mitigation nécessaire** :
- Offre de terrain infinie (ou régénérante) — ne pas limiter géographiquement
- Mécanisme de mentorat économique (joueurs riches subventionnent les nouveaux via CFSA)
- Serveurs saisonniers ou "nouvelles régions" périodiques
- Protection économique des <3 mois (prix coop garantis, terres réservées, marché protégé)

---

### RISQUE 4 — L'emprunt comme exploit de progression (Probabilité : MOYENNE, Impact : MAJEUR)

**Description** : Si un joueur peut emprunter 200 000 € à la banque pour acheter 20 truies + porcherie, les revenus du porc (ROI ×4-5 en 12 mois) remboursent l'emprunt en 3-4 mois réels et génèrent un profit massif. L'emprunt compresse la timeline de 4 ans en 6 mois.

**Mécanisme** :
```
Joueur jour 1 : emprunt 200k€ → 20 truies + porcherie
Mois 3 réel  : revenus porc → emprunt remboursé + profit
Mois 6 réel  : expansion à 100 truies → revenus > 500k€/an
```

**Conséquence** : La progression "patiente" (cœur du gameplay) est court-circuitée. Les joueurs qui comprennent la boucle emprunt→ROI élevé→remboursement dominent immédiatement.

**Mitigation nécessaire** :
- Emprunt plafonné proportionnellement aux actifs existants (max 50% du patrimoine)
- Taux d'intérêt dissuasifs pour les gros montants (progressif)
- Conditions de remboursement contraignantes (saisie si défaut)
- Collatéral requis (hypothèque sur les actifs)

---

### RISQUE 5 — Monétisation insuffisante → non-viabilité commerciale (Probabilité : MOYENNE, Impact : EXISTENTIEL)

**Description** : Un jeu F2P de niche (simulation agricole) avec un modèle "abo confort QoL uniquement" a un marché adressable limité. Si l'abo ne donne pas un avantage perçu suffisant, le taux de conversion sera <2%, insuffisant pour un jeu indépendant.

**Calcul de viabilité approximatif** :
```
Hypothèse : 5 000 joueurs actifs (niche FR)
Conversion abo : 5% = 250 abonnés
Prix abo : 5 €/mois
Revenu mensuel : 1 250 €/mois = 15 000 €/an

→ Ne couvre pas les serveurs + maintenance + développement
```

**Conséquence** : Le jeu est techniquement excellent mais financièrement mort. Le développement s'arrête.

**Mitigation nécessaire** :
- Élargir les sources de revenus : cosmétiques, décoration de ferme, personnalisation
- Abo premium à paliers (5€/10€/15€) avec avantages croissants
- Packs ponctuels non-P2W (accélérateurs cosmétiques de construction, skins matériel)
- Viser l'international dès la conception (EN/DE/ES) pour élargir le TAM
- Objectif réaliste : 500+ abonnés ou modèle de revenu alternatif

---

## 3. Les 3 Recommandations Prioritaires

### RECOMMANDATION 1 — Concevoir le système monétaire AVANT les contenus

**Priorité : CRITIQUE — À faire en Phase 1**

Le document ROADMAP place "Économie base : Balance, transactions, journal financier" en Phase 1 mais ne détaille pas le modèle macro-économique. Avant de coder une seule mécanique de production, il faut :

**Livrable attendu** : un document "Politique Monétaire Serveur" qui définit :

1. **Sources d'argent** (faucets) :
   - Ventes à la coopérative (bot) : avec quel budget/limite ?
   - Aides PAC : montant fixe ou proportionnel ?
   - Quêtes/tutoriels de départ : one-shot ?

2. **Puits d'argent** (sinks) :
   - Taxes sur transactions marché (quel %) 
   - Charges fixes (fermage, assurances, cotisations)
   - Entretien matériel et bâtiments (proportionnel à la valeur)
   - Frais vétérinaires
   - Impôts sur le patrimoine (si nécessaire)
   - Coût des employés (scaling avec la taille)

3. **Régulateurs** :
   - Formule de prix coop dynamique (baisse si surproduction serveur)
   - Plafond d'injection monétaire quotidienne par la coop
   - Vélocité monétaire cible (combien de fois 1€ change de mains/mois)

4. **Métriques de monitoring** :
   - Masse monétaire totale du serveur (M)
   - PIB du serveur (somme des transactions)
   - Indice des prix (panier moyen)
   - Coefficient de Gini (inégalité entre joueurs)
   - Alerte si inflation > 5%/mois in-game

**Pourquoi c'est #1** : Tout le reste du game design dépend de cet équilibre. Ajouter des puits après coup (post-launch) frustre les joueurs existants. Les concevoir dès le début les intègre naturellement au gameplay.

---

### RECOMMANDATION 2 — Rééquilibrer les profils pour réduire l'écart de ROI à max ×5

**Priorité : HAUTE — À faire avant le calibrage des valeurs numériques**

L'écart actuel (poule ×50-100 ROI vs allaitant ×0,7-0,9) est un problème de game design, pas un problème de réalisme. Un jeu n'est pas un simulateur — il faut que chaque choix soit **viable et intéressant**.

**Actions concrètes** :

| Profil | Ajustement proposé | Justification |
|--------|-------------------|---------------|
| 🐔 Volaille | Limiter reproduction (1 couvée/poule/2 mois IG), augmenter coût bâtiment (normes sanitaires), HT élevés pour gestion manuelle | Réduire de ×50 à ×8-10 ROI |
| 🐷 Porcin | Augmenter mortalité néonatale (15-20%), maladies fréquentes, régulation prix | Réduire de ×4-5 à ×3 ROI |
| 🐂 Allaitant | Augmenter aides PAC (+200 €/VA), prime à l'herbe, bonus biodiversité, coûts HT très faibles | Augmenter de ×0,8 à ×2 ROI |
| 🐑 Ovin | Ajouter prime ovin + filière laine valorisée | Augmenter de ×2-3 à ×3-4 ROI |
| 🌾 Céréalier | Garder tel quel (benchmark) | ROI ×2-3, bon référentiel |
| 🐄 Laitier | Garder tel quel, ajouter bonus fidélité (prime qualité si traite régulière) | ROI ×1,5-2, cash-flow compense |

**Cible** : chaque profil entre ×2 et ×10 de ROI sur 4 ans IG, avec des forces différentes :
- Volaille : rapide mais plafonne vite (saturation)
- Porcin : volume mais risqué (prix + maladies)
- Laitier : régulier mais lent à scaler
- Céréalier : linéaire mais prévisible
- Allaitant : extensif, peu de travail, lifestyle choice
- Ovin : intermédiaire, bon compromis

**Pourquoi c'est #2** : Si le joueur n'a pas de vrai choix au départ, l'onboarding échoue. La diversité des playstyles est ce qui fait la richesse d'un jeu multijoueur de niche — c'est votre rétention.

---

### RECOMMANDATION 3 — Modéliser la monétisation comme un système de jeu à part entière

**Priorité : HAUTE — À designer en Phase 1, implémenter progressivement**

Le document fondateur dit "F2P + abo confort (QoL), jamais P2W" — c'est un bon principe mais pas un business model. Un jeu qui coûte 1-2 ans de développement doit avoir un plan de revenus crédible.

**Proposition de modèle de monétisation multicouche** :

| Source | Type | Revenu estimé | P2W ? |
|--------|------|:---:|:---:|
| Abo Confort (5€/mois) | QoL : notifications, graphiques avancés, historique étendu, thèmes | Base | ❌ |
| Abo Premium (10€/mois) | QoL+ : automatisations cosmétiques (graphiques de suivi auto, alertes push, slots de sauvegarde marché) | Principal | ❌ |
| Cosmétiques | Skins tracteurs, décos ferme, portraits, badges | Variable | ❌ |
| Packs saisonniers | Thèmes de ferme (Noël, Halloween, été...) | Ponctuel | ❌ |
| Expansion pass | Accès anticipé aux nouvelles filières (2 semaines avant F2P) | Événementiel | ⚠️ (à doser) |

**Ce qui ne doit PAS être monétisé** (lignes rouges) :
- ❌ HT supplémentaires (= P2W direct)
- ❌ Boost de rendement/production
- ❌ Accès exclusif à des filières
- ❌ Avantages sur le marché (priorité d'achat, visibilité)
- ❌ Skip de timers (contraire au rythme 1 sem = 1 mois)

**Objectif financier réaliste** :
```
Cible : 3 000 joueurs actifs mensuels (niche FR+BE+CH+CA)
Conversion abo : 8% = 240 abonnés
ARPPU (abo + cosmétiques) : 8 €/mois moyen
Revenu : 240 × 8 = 1 920 €/mois ≈ 23 000 €/an (minimum viable indie)

Scénario croissance (12 mois post-launch, + international) :
10 000 MAU × 8% × 10€ = 8 000 €/mois = 96 000 €/an
```

**Pourquoi c'est #3** : Sans viabilité financière, le jeu meurt quelle que soit sa qualité. Le plan de monétisation doit être conçu comme un système de jeu (satisfaisant, non-intrusif, généreux dans sa version gratuite) et non comme une afterthought en Phase 10.

---

## Conclusion

Agriva a un design ambitieux et une connaissance impressionnante du domaine (les études économiques par profil sont d'excellente qualité). Mais le projet souffre d'un angle mort classique des simulations réalistes : **le réalisme économique n'est pas l'équilibre ludique**.

Le plus grand danger est de reproduire fidèlement SimAgri (y compris ses déséquilibres connus — la poule Tier S) sans les corriger. SimAgri survivait grâce à sa petite communauté et l'absence de concurrence. Agriva opère dans un contexte différent : joueurs plus informés (wikis, Discord, méta connue en 48h), attentes F2P modernes, et besoin de revenus pour survivre.

**Les trois batailles à gagner** :
1. **Stabilité monétaire** — sans elle, rien ne tient au-delà de 6 mois
2. **Diversité viable** — sans elle, le jeu est un puzzle à solution unique
3. **Revenus suffisants** — sans eux, le jeu n'existe tout simplement plus

---

*Ce document est une review externe. Toutes les recommandations sont discutables et doivent être confrontées à la vision des fondateurs et aux tests de gameplay.*
