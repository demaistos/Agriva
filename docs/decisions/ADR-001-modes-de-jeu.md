# ADR-001 : Deux modes de jeu — Normal et Expert

> Date : 2026-08-04
> Statut : **Partiellement remplacé par ADR-005**
> Auteur : humain + agent:game-designer

> ⚠️ **AVERTISSEMENT — décision d'implantation révisée**
>
> Cet ADR avait retenu l'**option B** : deux modes cohabitant dans le même serveur.
> **L'ADR-005 a révisé ce choix** : Agriva aura **deux serveurs séparés**, un Normal et un Expert.
>
> **Ce qui reste valide dans ce document** : toutes les définitions de paramètres Normal et Expert
> ci-dessous. Elles décrivent désormais deux **configurations de serveur** au lieu de deux modes
> de joueur.
>
> **Ce qui est obsolète** : la section « Décision », le tableau d'options, et les principes de
> design n°1 (« même monde, mêmes prix ») et n°3 (« changement possible en cours de partie »).
>
> Voir `ADR-005-deux-serveurs-separes.md`.

## Contexte

SimAgri gère la difficulté via des multiplicateurs par serveur (facile ×0.7 à expert ×1.5 sur les heures/revenus/pénalités). Tous les joueurs du même serveur ont la même difficulté.

Agriva veut proposer une expérience différenciée sans fragmenter la base de joueurs sur des serveurs séparés. La question est : comment offrir un jeu accessible ET profond ?

## Options

| Option | Avantages | Inconvénients |
|--------|-----------|---------------|
| A. Serveurs par difficulté (SimAgri) | Simple, testé | Fragmente la population, pas de progression |
| B. Deux modes dans le même serveur (Normal/Expert) | Même monde, deux niveaux de lecture | Plus complexe à équilibrer |
| C. Difficulté continue (slider) | Très flexible | Impossible à équilibrer, pas de communauté |

## Décision

**Option B** — Deux modes de jeu : **Normal** et **Expert**, dans le même univers.

## Définition des modes

### Mode Normal
**Philosophie** : accessible, fun, progression rapide. Le joueur apprend les fondamentaux sans être submergé.

| Aspect | Comportement Normal |
|--------|-------------------|
| Charges sociales | Forfait léger (12% du bénéfice) — cf. ADR-002 |
| Aides PAC | Automatiques, pas de conditionnalité |
| Météo | Indicative (pas de blocage travaux, juste bonus/malus rendement) |
| Maladies animales | Jauge santé simple, pas de maladie nommée |
| Alimentation | 1 ration par espèce, pas de formulation |
| Prix marché | Variation modérée (±15%), pas de crash |
| Fertilisation | N global (pas de P-K-Ca-Mg-S séparés) |
| Rotations | Recommandées (bonus) mais pas obligatoires |
| Récolte | Fenêtre large, pas de perte si retard modéré |
| Comptabilité | Solde + historique simple |
| Effluents | Automatique (pas de plafond N à gérer) |
| Transport | Coût forfaitaire, pas de logistique détaillée |
| Qualité fourrage | Pas d'impact (tout fourrage = même valeur) |
| Labels | Bio seulement (+20% prix, contraintes simples) |

### Mode Expert
**Philosophie** : simulation réaliste, optimisation poussée, chaque décision compte. Le joueur gère une vraie exploitation.

| Aspect | Comportement Expert |
|--------|-------------------|
| Charges sociales | MSA réaliste (~35-40% du revenu) |
| Aides PAC | Conditionnalité (BCAE, éco-régime à respecter) |
| Météo | Bloquante (pas de labour si sol gorgé, pas de pulvé si vent) |
| Maladies animales | Maladies spécifiques, contagion, biosécurité |
| Alimentation | Multiphase (porc), qualité fourrage, IC |
| Prix marché | Volatilité forte (±30-50%), cycles pluriannuels, saisonnalité |
| Fertilisation | N-P-K séparés + oligo-éléments, analyse de sol |
| Rotations | Obligatoires avec effet précédent (+/- rendement) |
| Récolte | Fenêtre serrée, pertes si retard, humidité à gérer |
| Comptabilité | EBE, bilan, amortissement, ratios de gestion |
| Effluents | Plafond 170 kg N/ha, calendrier épandage, stockage |
| Transport | Distance variable, coût/km, logistique charroi |
| Qualité fourrage | Date de fauche → valeur alimentaire → production lait |
| Labels | AOP, Label Rouge, IGP (cahiers des charges détaillés) |

## Principes de design

1. **Même monde, mêmes prix** — les joueurs Normal et Expert sont sur le même serveur, échangent entre eux
2. **Le mode Expert ne punit pas** — il récompense l'optimisation (meilleures marges si bien géré)
3. **Changement possible** — un joueur peut passer de Normal à Expert (pas l'inverse facilement)
4. **UI adaptée** — en Normal, les interfaces sont épurées. En Expert, les détails sont visibles
5. **Le jeu est complet en Normal** — Expert ajoute de la profondeur, pas du contenu bloqué

## Impact sur la conception

Chaque système doit être conçu avec deux niveaux :
- **Couche de base** (Normal) : mécanique simple, résultat lisible
- **Couche détaillée** (Expert) : paramètres additionnels qui s'empilent sur la base

Exemple concret — **Fertilisation** :
- Normal : "Engrais" = 1 produit, 1 passage, coût €/ha → bonus rendement
- Expert : N en 2-3 apports (tallage, montaison), P-K à l'automne, analyse de sol, modulation GPS

## Conséquences

- Les documents de game design doivent toujours spécifier les deux comportements
- L'architecture doit supporter les deux modes (flags, conditions)
- Les tests couvrent les deux modes
- L'équilibrage économique doit être vérifié dans les deux modes
- Le mode Normal doit être fun et viable même sans optimisation
- Le mode Expert doit récompenser la connaissance agronomique réelle
