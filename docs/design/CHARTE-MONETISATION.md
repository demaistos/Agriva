# Charte de Monétisation — Agriva

> Date : 2026-08-05
> Statut : Validé
> Auteur : agent:game-designer
> Référence : `docs/design/GDD-SOURCE-VERITE.md` §8-9

---

## Engagement fondateur

**Agriva est un jeu gratuit, complet, sans publicité.** 100 % des mécaniques de gameplay sont accessibles à tout joueur sans dépenser un centime. La monétisation repose exclusivement sur du confort et du cosmétique. Ce document est la loi — toute feature qui le viole est un bug à corriger immédiatement.

---

## 1. LIGNES ROUGES — Ce qui n'est JAMAIS monétisé

Liste exhaustive et définitive. Aucune exception, aucun contournement, aucune « offre limitée ».

| # | Catégorie | Détail |
|---|-----------|--------|
| 1 | **Heures de Travail** | Pas de HT bonus, pas de recharge anticipée, pas de tick supplémentaire. Le budget de 84 h/tick (exploitant) est identique pour tous. |
| 2 | **Rendement & production** | Aucun boost de rendement cultures, production laitière, taux de ponte, vitesse d'engraissement, qualité génétique, reproduction. |
| 3 | **Prix préférentiels** | Pas de prix coop réduits, pas de tarif ETA remisé, pas de commission marché réduite. |
| 4 | **Accès exclusif au gameplay** | Aucune culture, race animale, matériel, bâtiment, technologie ou mécanique réservé aux abonnés. |
| 5 | **Timers biologiques** | Pas de skip de gestation, croissance de culture, lactation, engraissement, ponte, maturité. Le temps biologique est sacré. |
| 6 | **Avantage de marché** | Pas de visibilité anticipée des offres, pas de position prioritaire dans le carnet d'ordres, pas de commission réduite. |
| 7 | **Main d'œuvre** | Pas d'employés bonus, pas d'ordres permanents supplémentaires, pas de slot d'ouvrier exclusif. |
| 8 | **Foncier** | Pas de parcelles bonus, pas de priorité d'achat, pas de parcelles plus grandes, pas de réduction sur les frais de distance. |
| 9 | **Classements** | Aucun avantage compétitif dans les classements (patrimoine, rendement, génétique, efficience). Un F2P et un abonné sont jugés à armes égales. |

---

## 2. CE QUI EST MONÉTISÉ

### 2.1 AgriPass — 3,99 €/mois

| Feature | Détail |
|---------|--------|
| **Stats avancées** | Historiques de rendement, graphiques d'évolution, comparaisons inter-saisons, bilans consolidés |
| **Notifications temps réel** | Push et email instantanés (vente conclue, tick terminé, animal malade). Le F2P voit les notifications à la connexion uniquement. |
| **Badge profil** | Indicateur visuel « AgriPass » sur le profil joueur |
| **Thème visuel** | Palette de couleurs alternative pour l'interface (purement cosmétique) |

### 2.2 AgriPass+ — 7,99 €/mois

Inclut tout l'AgriPass, plus :

| Feature | Détail |
|---------|--------|
| **Cosmétiques exclusifs mensuels** | Skin de tracteur, décor de ferme, avatar — rotatifs chaque mois, purement visuels |
| **2ème ferme** | Possibilité de jouer une seconde exploitation sur un serveur différent (même compte) |
| **Concours cosmétiques** | Participation aux concours de « plus belle ferme » (jugement visuel uniquement) |
| **Profil personnalisé avancé** | Description étendue, galerie photos, bannière personnalisée |

### 2.3 Robot de traite — Accessible à TOUS (achat in-game)

**Correction suite audit panel d'experts (2026-08-05)** : le robot de traite n'est plus lié à l'abonnement. Il est achetable par tout joueur.

- **Achat** : 150 000–180 000 € in-game. Tout joueur, F2P ou abonné, peut l'acheter.
- **Sans robot** : la traite consomme des HT (nb_vaches / cadence_salle). Le joueur trait manuellement (via la salle de traite).
- **Avec robot** : la traite ne consomme plus de HT. Les vaches sont traites automatiquement.
- **Production identique** : le robot ne produit PAS plus de lait. Même rendement, même qualité. Il libère du temps, c'est tout.
- **Avantage AgriPass** : réduction de 20% sur le coût d'entretien mensuel du robot (économie cosmétique, pas productive).
- **Pourquoi ce changement** : la libération de 17-31 HT/tick constitue un avantage indirect permettant de diversifier plus. Pour respecter la règle ±5% (§3), le robot doit être accessible à tous.

### 2.4 Construction instantanée

- **Skip du délai de construction uniquement** (quelques jours à 2 mois IG selon le bâtiment).
- Le bâtiment obtenu est **strictement identique** (même capacité, même coût, mêmes fonctions).
- Le joueur F2P construit le même bâtiment — il attend juste le délai normal.
- **Aucun avantage productif** : pendant la construction, le joueur n'a de toute façon pas encore le bâtiment. Le skip ne génère pas de production supplémentaire mesurable sur la durée.

---

## 3. RÈGLE DE TEST — Le critère P2W

> **Un joueur F2P avec le même temps de jeu ET les mêmes décisions doit obtenir des résultats économiques à ±5 % d'un abonné.**

### Application concrète

```
Scénario de test :
  Joueur A (F2P)       : 100 ha blé, 40 VL, même matériel, mêmes décisions
  Joueur B (AgriPass+) : 100 ha blé, 40 VL, même matériel, mêmes décisions

  Après 1 an IG (84 ticks) :
    Chiffre d'affaires A  ≈  Chiffre d'affaires B  (écart < 5%)
    Patrimoine A          ≈  Patrimoine B           (écart < 5%)
    Classement A          ≈  Classement B           (écart < 5%)

  Si l'écart dépasse 5% → la feature est P2W → ROLLBACK IMMÉDIAT.
```

### Ce que le test ne mesure PAS (et c'est voulu)

- Le confort de jeu (notifications, stats) — c'est le service rendu par l'abonnement.
- L'esthétique (cosmétiques) — aucun impact économique.
- La 2ème ferme — c'est une expérience parallèle sur un autre serveur, pas un avantage sur le serveur principal.

---

## 4. ENGAGEMENT PUBLIC

### Publication

Cette charte est publiée **intégralement** sur le site officiel au lancement. Elle est accessible à tout moment depuis le jeu (menu Aide → Monétisation).

### En cas de violation

1. **Constat** : tout joueur peut signaler une suspicion de P2W via le support.
2. **Audit** : l'équipe applique la règle de test (§3) avec les données serveur.
3. **Si confirmé** :
   - Rollback immédiat de la feature incriminée.
   - Compensation à tous les joueurs F2P affectés (crédits IG, matériel, jours de jeu).
   - Communication publique transparente (blog + in-game).
4. **Délai** : 72 h maximum entre le constat et le rollback.

### Évolution de la charte

- Les lignes rouges (§1) sont **définitives et immuables**.
- Les features monétisées (§2) peuvent être **enrichies** (ajout de cosmétiques, nouvelles options de confort) tant qu'elles respectent les lignes rouges.
- Toute modification est annoncée 30 jours avant application.

---

## Résumé en une phrase

> **Dans Agriva, l'argent réel achète du confort et de la beauté — jamais de la puissance.**
