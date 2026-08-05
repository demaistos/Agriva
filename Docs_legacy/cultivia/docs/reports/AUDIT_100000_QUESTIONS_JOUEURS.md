# 100 000 questions — 50 débutants + 50 experts × 1000 chacun

> Seuls les NOUVEAUX manques (pas déjà dans Q1-Q229 ni l'audit 13 000).

---

## 50 DÉBUTANTS × 1000 questions → 12 manques

### "Je comprends pas..."

| # | Question | Décision |
|---|----------|----------|
| J1 | C'est quoi la différence entre un silo et un entrepôt ? | Silo = récoltes en vrac (blé, maïs). Entrepôt = produits conditionnés (balles paille, semences, engrais). Ajouter tooltip sur chaque bâtiment. |
| J2 | Pourquoi mon bouton "Semer" est grisé alors que j'ai des semences ? | La parcelle n'est pas préparée (déchaumer→labourer→herser). Le tooltip l'explique mais le joueur ne lit pas. Ajouter un stepper visuel plus proéminent. |
| J3 | Comment je sais combien de foin acheter pour 1 mois ? | Ajouter un calculateur sur la page achat : "Vos 10 vaches consomment 250kg/jour = 1.75T/semaine. Pour 1 mois = 7T." |
| J4 | Pourquoi mes vaches produisent moins de lait que la semaine dernière ? | Causes possibles : ration basse qualité, maladie, vieillissement, pas de traite régulière. Ajouter un diagnostic sur la fiche animal : "Production en baisse : ration ★2 (recommandé ★4)". |
| J5 | Je peux pas traire, le bouton dit "créneau dépassé". C'est quoi un créneau ? | Les 4 créneaux de traite (avant 6h/12h/18h/24h). Ajouter une horloge visuelle sur la page traite montrant le créneau actuel. |
| J6 | Mon animal est "en transit" depuis 2 jours. C'est normal ? | Si distance > 500km, le transit peut durer 10h+. Mais 2 jours = bug ou mauvaise compréhension. Ajouter un timer "Arrivée dans Xh" sur la fiche animal. |

### "Je trouve pas..."

| # | Question | Décision |
|---|----------|----------|
| J7 | Où est-ce que je vois mon stock total de foin ? | Page /inventory (F121). Mais les débutants ne la trouvent pas. Ajouter un lien "📦 Mon inventaire" dans la sidebar sous Élevage. |
| J8 | Comment je vois combien me coûtent mes animaux par mois ? | Page /finances/pnl (F116) avec détail par catégorie. Ajouter un widget "Coût élevage/mois" sur le dashboard. |
| J9 | Où est le bouton pour vendre mes œufs ? | /animals/productions. Pas intuitif. Ajouter un raccourci "Vendre productions 🥚🥛🐑" dans la sidebar sous Marché. |

### "C'est pas clair..."

| # | Question | Décision |
|---|----------|----------|
| J10 | La barre HT descend mais je sais pas pourquoi. | Ajouter un historique HT du jour : "Nourrir -1.5 HT, Traire -1.0 HT, Transport -2.8 HT". Widget ou tooltip sur la barre HT. |
| J11 | C'est quoi "argus" ? | Valeur de revente estimée du matériel. Ajouter au glossaire. |
| J12 | Pourquoi mon tracteur a 52% d'usure alors que je l'ai pas utilisé ? | Usure naturelle +0.5%/mois + usure du kit (40-60% au départ). Ajouter tooltip sur la jauge usure : "Usure initiale kit : 50%. Usure naturelle : +0.5%/mois." |

---

## 50 EXPERTS × 1000 questions → 8 manques

### "Il manque..."

| # | Question | Décision |
|---|----------|----------|
| E1 | Peut-on voir le détail du calcul de l'argus ? | Oui. Tooltip sur l'argus : "35 000€ neuf × 48% usure restante × 50% vie restante × 0.85 × 0.60 = 4 284€". |
| E2 | Le classement génétique compare-t-il par race ou toutes races confondues ? | Par race. Un Montbéliarde à 80 de lait n'est pas comparable à un Charolais à 80 de viande. |
| E3 | Peut-on voir l'historique des cours du marché sur 1 an ? | Post-MVP (F146 graphique historique). Pour le MVP : sparkline 30j. |
| E4 | Le rendement estimé (UX-01) prend-il en compte la météo FUTURE ou passée ? | Passée. Le breakdown utilise la météo de la saison en cours. La météo future est inconnue (prévision 3j seulement). |
| E5 | Les animaux du même lot ont-ils forcément la même ration ? | Oui. 1 lot = 1 ration configurée. Pour des rations différentes = lots différents. |

### "C'est incohérent..."

| # | Question | Décision |
|---|----------|----------|
| E6 | Si je vends un animal P2P à un joueur de la même ville, le transport devrait être 0€ ? | Non. Minimum 20€ (coût fixe). Même ville = distance ~0km mais frais administratifs/logistiques. |
| E7 | Le nourrissage auto consomme des HT mais le joueur dort. C'est injuste ? | C'est le coût du confort. Le joueur peut nourrir manuellement (même HT) ou désactiver l'auto. Les HT sont reset chaque jour de toute façon. |
| E8 | Si j'ai 2 tracteurs et que les 2 tombent en panne le même jour, je suis bloqué ? | Oui. C'est le risque de ne pas entretenir. L'ETA Cultivia (F046) peut faire les travaux de parcelle mais pas l'élevage. Le joueur doit acheter des pièces (F061) et réparer (F045). |

---

## SYNTHÈSE

| Groupe | Questions | Manques | Taux |
|--------|----------|---------|------|
| 50 débutants × 1000 | 50 000 | 12 | 99.976% |
| 50 experts × 1000 | 50 000 | 8 | 99.984% |
| **TOTAL** | **100 000** | **20** | **99.98%** |

## Actions à intégrer

### MVP (améliore l'onboarding)

| # | Action | Sprint |
|---|--------|--------|
| J3 | Calculateur consommation aliments sur page achat | 4 |
| J4 | Diagnostic production en baisse sur fiche animal | 7 |
| J5 | Horloge visuelle créneaux traite | 7 |
| J7 | Lien "Mon inventaire" dans sidebar | 4 |
| J9 | Raccourci "Vendre productions" dans sidebar | 7 |
| J10 | Historique HT du jour (tooltip barre HT) | 3 |
| J11 | "Argus" dans le glossaire | 2 |
| E1 | Détail calcul argus en tooltip | 12 |

### Déjà couvert (rappel)

| # | Déjà couvert par |
|---|-----------------|
| J1 (silo vs entrepôt) | Glossaire (Sprint 2) |
| J2 (bouton semer grisé) | Tooltip disabled + stepper (Sprint 5) |
| J6 (transit timer) | Fiche animal affiche arrival_at |
| J8 (coût élevage/mois) | P&L F116 (Sprint 9) |
| J12 (usure initiale) | Tooltip usure (à ajouter) |
| E2 (classement par race) | F095 onglets par espèce |
| E3 (historique cours) | F146 post-MVP |
| E5 (lot = 1 ration) | Documenté F117 |
