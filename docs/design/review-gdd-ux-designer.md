> ⚠️ **Note** : En cas de conflit avec ce document, référez-vous à `docs/design/GDD-SOURCE-VERITE.md` qui fait autorité.


> ⚠️ **Note** : Ce document de review est antérieur aux décisions validées dans `GDD-SOURCE-VERITE.md`. Certains points soulevés ici ont été tranchés depuis.


# Review UX — Game Design Document Agriva

> Auteur : UX Designer (review critique)
> Date : 2026-08-04
> Documents analysés : FOUNDATION.md, ROADMAP.md, product.md

---

## Contexte de la review

Agriva vise à recréer SimAgri (2005) avec une UX moderne, responsive, jouable sur mobile, pour des adultes disposant de peu de temps. Le jeu couvre 119 sous-systèmes répartis en 10 phases. Cette review examine la faisabilité UX de cette ambition.

---

## 1. Questions critiques (UX / Accessibilité)

### Q1 — Onboarding : comment exposer 119 systèmes sans noyer le joueur ?

Le GDD mentionne un « onboarding progressif, tutoriel intégré » mais ne décrit aucun mécanisme concret. Comment le joueur découvre-t-il les systèmes ? Par déblocage progressif ? Par missions guidées ? Par exploration libre avec aide contextuelle ? Un jeu de cette densité NÉCESSITE un plan d'onboarding détaillé dès la Phase 1 — pas un ajout cosmétique en fin de projet.

### Q2 — Information par couches : quel est le modèle de navigation concret ?

Le document mentionne « information par couches (synthèse → détail) » comme modernisation clé. Mais quels sont les niveaux ? Combien de clics/taps pour atteindre un détail ? Sur SimAgri, tout était visible d'un coup — c'était dense mais prévisible. Un système en couches mal conçu crée de la frustration (« où est cette info ? »). Quel est le modèle de navigation prévu ?

### Q3 — Sessions courtes : combien de temps dure une session type ?

La cible est « adultes avec peu de temps ». Or, une boucle culture complète (semer → récolter → vendre → racheter) implique de multiples interactions avec parcelles, matériel, sol, stockage, marché. Quelle est la durée de session visée ? 5 min ? 15 min ? 30 min ? Les mécaniques de HT/heures permettent-elles réellement des sessions de 5 minutes productives ?

### Q4 — Mobile : comment gérer les DataTables complexes sur un écran 375px ?

Le jeu repose massivement sur des tableaux (catalogues matériel, annonces marché, lots d'animaux, parcelles). Un tableau de 8+ colonnes est illisible sur mobile. Quelle stratégie est prévue ? Cards ? Filtres contextuels ? Vues simplifiées ? Le responsive seul ne suffit pas — il faut un design mobile-first pour les interactions fréquentes.

### Q5 — Feedback loops : comment le joueur sait-il qu'il progresse ?

SimAgri était un sandbox sans objectifs explicites. La rétention venait de la communauté et de l'économie. Agriva cible des joueurs modernes habitués aux feedback loops (notifications de progression, milestones, récompenses). Quels sont les mécanismes de feedback prévus ? Les classements seuls ne suffisent pas pour un joueur qui démarre seul.

### Q6 — Complexité cognitive : combien de variables le joueur doit-il gérer simultanément ?

Cultures seules = sol (6 éléments) × météo × rotation × techniques × traitements × engrais × matériel × HT × timing saisonnier. C'est 9+ variables simultanées. Pour un joueur casual avec peu de temps, c'est un mur cognitif. Quels mécanismes de simplification ou d'assistance sont prévus ? (Recommandations automatiques ? Alertes ? Templates ?)

### Q7 — Absence sans punition : quel est le coût réel de l'absence ?

Le GDD mentionne « gel des jauges si absent » et « protection hors-ligne ». Mais jusqu'où ? Si un joueur part 2 semaines (= 2 mois in-game), que se passe-t-il ? Les cultures pourrissent ? Les animaux meurent ? Le marché a évolué ? « Pas de punition » est un spectre — quel est le contrat exact avec le joueur ?

### Q8 — Aide contextuelle : quel volume de contenu et quelle maintenance ?

119 sous-systèmes × aides contextuelles = un volume massif de contenu éducatif à rédiger, maintenir et localiser. Qui rédige ce contenu ? Comment est-il testé avec de vrais utilisateurs ? L'aide contextuelle mal calibrée (trop intrusive ou trop cachée) est pire que pas d'aide du tout.

### Q9 — Accessibilité (a11y) : quelle conformité est visée ?

Aucune mention d'accessibilité dans les documents. Un jeu par navigateur ciblant des adultes doit considérer : contraste, taille de texte, navigation clavier, lecteurs d'écran (au moins pour les menus), daltonisme (important pour des jauges/indicateurs de couleur). Quel niveau WCAG est visé ? Même un AA partiel serait un différenciateur.

### Q10 — Notifications et rappels : comment maintenir l'engagement sans être intrusif ?

Le jeu avance en temps réel (1 semaine = 1 mois). Des événements importants surviennent quand le joueur n'est pas connecté (récolte prête, animal malade, annonce intéressante). Quels canaux de notification sont prévus (email, push, in-game) ? Comment éviter le spam ou l'anxiété FOMO tout en maintenant l'engagement ?

---

## 2. Risques UX majeurs

### Risque 1 — Mur de complexité au démarrage (CRITIQUE)

**Description** : même avec un onboarding progressif, la Phase 3 (cultures) demande déjà au joueur de comprendre sols, météo, matériel, HT, bâtiments, stockage ET les cultures elles-mêmes. C'est 7 systèmes interconnectés minimum pour faire la première action productive.

**Impact** : abandon massif avant la première récolte. Le joueur ne comprend pas pourquoi son rendement est mauvais (trop de variables cachées).

**Indicateur** : si plus de 40% des joueurs quittent avant leur première récolte réussie, ce risque est matérialisé.

### Risque 2 — Mobile comme citoyen de seconde classe

**Description** : le GDD dit « responsive, jouable sur mobile » mais la complexité des interfaces (tableaux, multiples jauges, carte géographique, attelage de matériel) rend un vrai gameplay mobile extrêmement difficile. Le risque est de livrer une version mobile techniquement fonctionnelle mais pratiquement injouable.

**Impact** : promesse marketing non tenue. Frustration des joueurs mobiles. Mauvaises reviews.

**Indicateur** : si les sessions mobiles durent <2 min en moyenne ou si le taux de conversion mobile→inscription est <50% du desktop.

### Risque 3 — Surcharge informationnelle (Information Overload)

**Description** : SimAgri assumait d'afficher toutes les données. La « modernisation » par couches risque de créer un problème inverse : trop de clics pour trouver l'info, ou des résumés qui masquent des détails critiques. Le joueur expert veut la densité ; le joueur casual veut la simplicité. Servir les deux est un défi de design majeur.

**Impact** : les experts trouvent le jeu frustrant (« trop de clics »), les casuals le trouvent opaque (« je ne comprends pas mes résultats »).

**Indicateur** : divergence forte dans les retours qualitatifs entre joueurs experts SimAgri et nouveaux joueurs.

### Risque 4 — Feedback loop trop long

**Description** : 1 semaine réelle = 1 mois en jeu. Un cycle culture complet = plusieurs mois in-game = plusieurs semaines réelles. Le joueur casual ne verra pas le fruit de ses actions avant 2-3 semaines. C'est une éternité pour la rétention moderne (les joueurs décident en 48h s'ils restent).

**Impact** : fort churn dans les 2 premières semaines. Le joueur ne « sent » pas l'impact de ses décisions assez vite.

**Indicateur** : rétention J7 < 20% sans mécanismes de récompense intermédiaire.

### Risque 5 — Onboarding impossible à tester en isolation

**Description** : l'onboarding ne peut être testé correctement qu'à partir de la Phase 3 (quand le jeu est jouable). Mais les Phases 1 et 2 construisent les fondations UX (navigation, modales, DataTable). Si ces patterns sont mal définis, l'onboarding de Phase 3 hérite de choix structurels déjà figés.

**Impact** : refonte coûteuse de l'UX post-Phase 3 quand les tests utilisateurs révèlent des problèmes structurels.

**Indicateur** : si les retours de playtest Alpha nécessitent des changements de navigation/structure (pas juste de contenu).

---

## 3. Recommandations prioritaires

### Recommandation 1 — Définir le « First Meaningful Action » en 5 minutes

**Quoi** : concevoir l'expérience des 5 premières minutes MAINTENANT, avant de coder. Le joueur doit accomplir une action productive avec feedback positif en ≤5 minutes après la création de compte.

**Pourquoi** : c'est le facteur #1 de rétention sur les jeux par navigateur. Un joueur qui ne comprend pas quoi faire dans les 5 premières minutes ne reviendra jamais.

**Comment** :
- Créer un « mode guidé » pour la première session : le joueur reçoit une parcelle pré-préparée, un tracteur, et une mission simple (« semez du blé »)
- Réduire le nombre de décisions initiales à 2-3 (pas 15)
- Afficher un feedback immédiat et célébratoire à chaque étape complétée
- Permettre de skip pour les vétérans SimAgri

**Livrable concret** : wireframes de l'onboarding + user flow des 5 premières minutes, validés par 5 tests utilisateurs AVANT le développement de la Phase 3.

### Recommandation 2 — Concevoir mobile-first les 3 écrans les plus fréquents

**Quoi** : identifier les 3 actions les plus fréquentes (probablement : check dashboard, lancer une action sur parcelle, consulter le marché) et les designer MOBILE-FIRST avant de les adapter au desktop.

**Pourquoi** : le responsive est une propriété technique, pas un design. Si on conçoit desktop puis on « adapte », le mobile sera toujours un compromis. Les 3 écrans les plus utilisés doivent être pensés pour le pouce d'abord.

**Comment** :
- Wireframes mobile (375px) des 3 écrans prioritaires
- Interactions par swipe/tap plutôt que hover/clic-droit
- Actions rapides accessibles en ≤2 taps depuis le dashboard
- Tester sur de vrais appareils (pas juste le mode responsive du navigateur)

**Livrable concret** : prototypes interactifs (Figma) des 3 écrans mobile, testés sur 3 appareils différents.

### Recommandation 3 — Implémenter des « micro-feedback loops » dès la Phase 2

**Quoi** : ne pas attendre que le cycle complet de culture soit fonctionnel pour donner du feedback au joueur. Créer des boucles de gratification courtes (quotidiennes) en parallèle de la boucle longue (hebdomadaire/mensuelle).

**Pourquoi** : la rétention des 48 premières heures dépend de récompenses fréquentes. Le cycle naturel du jeu (semaines) est trop long pour maintenir l'engagement initial.

**Comment** :
- **Quotidien** : récapitulatif « ce qui s'est passé pendant votre absence » avec éléments positifs mis en avant
- **Quotidien** : petites tâches optionnelles (« vérifiez votre sol », « consultez la météo ») avec XP ou badges
- **Hebdomadaire** : bilan de ferme avec progression visible (graphiques, comparaison semaine précédente)
- **Ponctuel** : événements aléatoires positifs (« un voisin vous offre un conseil », « prime de marché sur le blé »)

**Livrable concret** : spécification du système de feedback loops avec fréquences, triggers, et maquettes des notifications/récapitulatifs.

---

## Conclusion

Le Game Design d'Agriva est ambitieux et cohérent dans sa vision technique. Cependant, la documentation est actuellement centrée sur le QUOI (systèmes à implémenter) et pas assez sur le COMMENT (comment le joueur interagit avec ces systèmes). Les 119 sous-systèmes sont une force pour la profondeur, mais un risque majeur pour l'accessibilité.

La réussite UX d'Agriva dépendra de sa capacité à rendre la complexité OPTIONNELLE — le joueur casual doit pouvoir jouer sans comprendre tous les multiplicateurs, tandis que le joueur expert doit pouvoir les maîtriser tous. C'est un défi de design qui mérite autant d'attention que l'architecture technique.

**Prochaine étape suggérée** : atelier de design « First 5 Minutes » avant le début du développement Phase 3.
