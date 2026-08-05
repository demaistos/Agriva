# Audit 10 profils diversifiés — Angles inédits

---

## 1. 🧑‍🌾 Jean-Pierre — Agriculteur bio réel (Aveyron, 50 brebis Lacaune)

"Je lis vos specs et je compare avec mon quotidien réel."

**Ce qui est bien :**
- La traite, le nourrissage, la litière, le fumier — c'est mon quotidien. Réaliste.
- Le transport par espèce (bétaillère/utilitaire) c'est correct.
- Les rations par espèce sont cohérentes.

**Ce qui manque :**
- ❌ **Pas de gestion de l'herbe au pré.** En vrai, l'herbe pousse, on la fauche, elle repousse. Dans le jeu, le pré est juste un "lieu" sans gestion de la pousse. Les animaux au pré devraient consommer l'herbe et il faut la laisser repousser.
- ❌ **Pas de saison de mise au pré.** On met les brebis au pré en avril et on les rentre en novembre. Le jeu devrait forcer la rentrée en hiver (sauf allaitantes).
- ❌ **Pas de gestion du parasitisme.** Les animaux au pré attrapent des parasites. Il faut les vermifuger 2×/an.
- ❌ **Le prix du lait ovin (0.90€/L) est trop élevé.** En Roquefort c'est 1.10€/L mais en standard c'est 0.70€/L. Votre prix est entre les deux, acceptable.

> **Actions :** F138 Vermifuger animal. Tick pousse herbe au pré (enrichir F053).

---

## 2. 🎮 Yuki — Game designer (a travaillé sur Stardew Valley)

"Je regarde la boucle de gameplay et la rétention."

**Ce qui est bien :**
- 8 boucles interconnectées. La boucle fumier→compost→sol est élégante.
- Les tooltips sur boutons grisés = excellent game feel.
- Le breakdown rendement 9 facteurs = transparence rare dans un jeu.

**Ce qui manque :**
- ❌ **Pas de progression visible.** Pas de niveau joueur, pas de XP, pas de barre de progression globale. Le joueur ne sait pas "où il en est" dans le jeu. SimAgri a les classements mais pas de sentiment de progression personnelle.
- ❌ **Pas de tutoriel contextuel.** Le tutoriel F112 est linéaire (5 étapes). Il devrait être contextuel : quand le joueur fait sa première traite, un popup "Bravo ! Première traite ! 🥛". Quand il fait sa première récolte, "Première récolte ! 🌾".
- ❌ **Pas de "daily login reward".** SimAgri n'en a pas mais tous les jeux modernes en ont. Même un simple "Bienvenue ! Voici vos 2 HT bonus" fidélise.

> **Actions :** Système achievements/milestones (post-MVP). Tutoriel contextuel (enrichir F112). Daily bonus = non (anti-game design pour un simulateur réaliste).

---

## 3. 👩‍💻 Sarah — Dev backend (va coder Sprint 01 demain)

"Je lis les specs et je note ce qui me bloque pour coder."

**Ce qui est bien :**
- Le SQL est exact dans chaque flow. Je peux copier-coller.
- Les codes erreur sont listés. Je sais quoi retourner.
- L'architecture (Fastify + PgBouncer + Redis) est claire.

**Ce qui manque :**
- ❌ **Pas de schéma JSON pour les body API.** Le registry dit `body: '{ breed_id: int, sex: string }'` mais c'est du pseudo-code. Il me faut un JSON Schema formel pour la validation Fastify.
- ❌ **Pas de spec pour les réponses API.** Le registry dit ce que le backend FAIT mais pas ce qu'il RETOURNE. Quel est le format de la réponse de `POST /api/animals/buy` ? `{ animal: {...}, cost: {...}, transport: {...} }` ?
- ❌ **Pas de convention pour les erreurs.** Le SDD liste les codes mais pas le format. `{ error: { code: 'ANIMAL_DEAD', message: '...', httpStatus: 400 } }` ?

> **Actions :** Ajouter format réponse API standard + format erreur dans le SDD. Les JSON Schema seront générés depuis les types TypeScript (Sprint 01).

---

## 4. 🧒 Léo — 14 ans, jamais joué à SimAgri

"C'est quoi ce jeu ? Je comprends rien."

- ❌ **C'est quoi HT ?** Le glossaire aide mais le terme est bizarre. "Énergie" serait plus intuitif.
- ❌ **Pourquoi je peux pas jouer sur mon téléphone ?** Tous mes jeux sont sur mobile.
- ❌ **C'est trop lent.** Il faut attendre 49 jours réels pour récolter du blé ? Je vais m'ennuyer.
- ❌ **Pas de personnage.** Je vois des tableaux et des chiffres. Où est mon avatar ?

> **Verdict :** Le jeu n'est PAS pour les 14 ans. C'est un simulateur de gestion pour adultes passionnés d'agriculture. C'est OK — le public cible est 25-55 ans. Pas d'action nécessaire.

---

## 5. 📊 Emma — Data analyst (cherche les failles économiques)

"Je modélise l'économie sur 5 ans."

**Faille trouvée :**
- ❌ **Inflation des classements.** Après 2 ans, les joueurs anciens ont 500 vaches et 500ha. Les nouveaux ne peuvent jamais les rattraper. Il faut un **classement par ancienneté** (joueurs < 6 mois, 6-12 mois, > 1 an) ou un **reset saisonnier** des classements.
- ❌ **Accumulation infinie de matériel.** Un joueur riche peut acheter 50 tracteurs et les stocker. Pas de taxe de possession. Ajouter une **taxe de stationnement** pour le matériel non utilisé ?
- ❌ **Le prêt 150k€ est remboursable en 1 an par un cultivateur 50ha.** Trop facile. Augmenter le taux d'intérêt ou réduire le plafond ?

> **Actions :** Classement par ancienneté (enrichir F095). Taxe matériel = non (trop punitif). Prêt = OK (le risque est sur l'éleveur, pas le cultivateur).

---

## 6. 🇫🇷 M. Dupont — Professeur lycée agricole

"Je veux utiliser ce jeu comme outil pédagogique."

**Ce qui est bien :**
- Les 9 facteurs de rendement = exactement ce que j'enseigne.
- La rotation des cultures = programme de BTS.
- Le transport par espèce = réaliste.
- Le breakdown rendement = outil pédagogique parfait.

**Ce qui manque :**
- ❌ **Pas de mode "classe".** Je voudrais créer 30 comptes élèves, les mettre sur le même serveur, et voir leurs résultats. Un mode professeur avec tableau de bord classe.
- ❌ **Pas d'export des données pour analyse.** Les élèves devraient pouvoir exporter leur P&L en CSV pour l'analyser en cours.

> **Actions :** Mode classe = post-MVP (extension éducation). Export CSV = déjà dans le backlog (D-11, Sprint 14).

---

## 7. 🏢 Marc — Investisseur

"Quel est le modèle économique ?"

- ❌ **Pas de monétisation documentée.** La Licence Pro est mentionnée mais pas spécifiée. Qu'est-ce qu'elle donne ? Combien ça coûte ? Freemium ? Abonnement ?
- ❌ **Pas de métriques business.** CAC, LTV, ARPU, churn — rien.
- ❌ **Pas de plan marketing.** Comment acquérir les premiers joueurs ?

> **Verdict :** Normal pour un pré-MVP. La monétisation sera spécifiée au Sprint 14. Le focus actuel est le gameplay.

---

## 8. 🔍 Thomas — Testeur QA obsessionnel

"Je cherche les cas limites que personne n'a testés."

- ❌ **Que se passe-t-il si un joueur supprime son compte (RGPD) pendant qu'il a des annonces P2P actives ?** Les annonces restent visibles avec un vendeur anonymisé ?
- ❌ **Que se passe-t-il si un animal meurt pendant le transit (F048) ?** Le tick santé (F011) s'applique-t-il aux animaux in_transit ?
- ❌ **Que se passe-t-il si le joueur a 0€ et -30k€ plancher et que le tick mensuel veut débiter l'énergie ?** L'énergie est coupée ? Les bâtiments s'arrêtent ?
- ❌ **Que se passe-t-il si 2 joueurs achètent le même animal P2P en même temps ?** SELECT FOR UPDATE documenté mais pas testé.

> **Actions :** Documenter ces edge cases dans le SDD. Suppression compte → annonces supprimées. Transit → pas de tick santé (animal protégé). Plancher → énergie impayée = dette, pas de coupure.

---

## 9. 🌍 Akiko — Joueuse japonaise

"Je ne connais pas l'agriculture française."

- ❌ **Les préfectures françaises ne me disent rien.** Une mini-carte avec les régions agricoles (Beauce = céréales, Auvergne = élevage) aiderait.
- ❌ **Les marques de matériel (John Deere, Claas) sont connues mondialement.** OK.
- ❌ **Les races animales françaises (Montbéliarde, Charolaise) sont inconnues.** Ajouter une description courte par race.
- ❌ **Le jeu est en français uniquement ?** Pas de traduction ?

> **Actions :** Description races = enrichir les seeds. i18n = post-MVP (le jeu est français d'abord). Mini-carte régions agricoles = nice-to-have.

---

## 10. ♿ Sophie — Malvoyante (utilise un lecteur d'écran)

"Je teste l'accessibilité."

- ✅ La checklist WCAG AA est dans le design system §12. Contrastes vérifiés.
- ✅ Aria-labels prévus sur les boutons icône, les jauges, les emojis.
- ❌ **Les DataTables sont complexes pour un lecteur d'écran.** Il faut des `<caption>`, `<th scope>`, et un résumé textuel avant chaque tableau.
- ❌ **La carte SVG France (inscription) est inaccessible.** Alternative : les 3 selects déroulants (région → département → préfecture) doivent être le mode par défaut, la carte SVG est un bonus visuel.
- ❌ **Les couleurs de saison (vert/orange/rouge/bleu) ne suffisent pas.** Ajouter un texte "Printemps" à côté de la couleur.

> **Actions :** DataTable accessible (caption + th scope). Carte SVG = bonus, selects = défaut. Texte saison à côté de la couleur.

---

## SYNTHÈSE — Nouveaux problèmes par profil

| Profil | Problèmes trouvés | MVP | Post-MVP |
|--------|-------------------|-----|----------|
| 🧑‍🌾 Agriculteur bio | Pousse herbe, vermifuge, parasitisme | 1 (vermifuge) | 2 |
| 🎮 Game designer | Progression, tutoriel contextuel | 1 (tuto contextuel) | 1 |
| 👩‍💻 Dev backend | Format réponse API, JSON Schema | 2 (format API) | 0 |
| 🧒 Ado 14 ans | Hors cible | 0 | 0 |
| 📊 Data analyst | Classement ancienneté, inflation | 1 | 0 |
| 🇫🇷 Prof lycée | Mode classe, export CSV | 0 (CSV déjà prévu) | 1 |
| 🏢 Investisseur | Monétisation | 0 | 1 |
| 🔍 QA obsessionnel | 4 edge cases | 4 (documenter) | 0 |
| 🌍 Joueuse étrangère | Descriptions races, i18n | 1 | 1 |
| ♿ Malvoyante | DataTable a11y, carte SVG, texte saison | 3 | 0 |

### Flows à ajouter

| Flow | Nom | Sprint |
|------|-----|--------|
| F138 | Vermifuger un animal | 5 |

### Modifications à faire

| Quoi | Détail |
|------|--------|
| SDD | Format réponse API standard : `{ data, meta? }` + format erreur `{ error: { code, message } }` |
| SDD | Edge cases : suppression compte, transit+santé, plancher+énergie, concurrence P2P |
| F095 | Classement par ancienneté (< 6m, 6-12m, > 1an) |
| F112 | Tutoriel contextuel (popup "Première traite !" etc.) |
| Seeds | Description courte par race animale |
| Design §12 | DataTable : caption + th scope. Carte SVG = bonus, selects = défaut. Texte saison. |
