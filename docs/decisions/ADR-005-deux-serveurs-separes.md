# ADR-005 : Deux serveurs séparés — Normal et Expert

> Date : 2026-08-04
> Statut : Accepté
> Auteur : humain + agent:game-designer
> **Remplace** : la décision d'implantation de l'ADR-001 (option B « deux modes dans le même serveur »)
> **Conserve** : toutes les définitions de paramètres Normal/Expert de l'ADR-001 et des 23 GDD
> **Impacte** : ADR-003 (devient largement obsolète), GDD-onboarding, GDD-social-multijoueur, GDD-gouvernance-serveur

## Contexte

L'ADR-001 avait examiné trois options et retenu l'**option B** : deux modes de jeu cohabitant dans le même serveur, avec la même économie et le même marché. L'option A (serveurs séparés, modèle SimAgri) avait été rejetée au motif qu'elle « fragmente la population ».

**Décision révisée** : Agriva proposera **deux serveurs distincts**, un Normal et un Expert.

## Ce qui motive la révision

| Argument | Détail |
|----------|--------|
| **Cohérence économique** | Deux populations avec des charges sociales différentes (12% vs 28%) et des règles différentes ne peuvent pas partager honnêtement un marché. Le joueur Normal, moins taxé, aurait un avantage structurel de prix. |
| **Lisibilité** | Un serveur = un ensemble de règles. Le joueur sait exactement dans quel jeu il est, sans avoir à se demander ce que son voisin a le droit de faire. |
| **Simplicité de régulation** | Chaque serveur a sa masse monétaire, ses prix, ses indicateurs. Le stabilisateur économique du `GDD-gouvernance-serveur` régule deux économies simples au lieu d'une économie hybride. |
| **Précédent validé** | SimAgri fonctionne ainsi depuis 2005 avec 8 serveurs de difficultés variées. |

## Décision

### 1. Deux serveurs, deux règlements

| | Serveur **Normal** | Serveur **Expert** |
|--|-------------------|-------------------|
| Public visé | Découverte, jeu détendu, progression fluide | Simulation réaliste, optimisation, technicité |
| Charges sociales | 12% du bénéfice | 28% du revenu professionnel |
| Économie | Indépendante | Indépendante |
| Marché | Propre au serveur | Propre au serveur |
| Classements | Propres au serveur | Propres au serveur |
| Paramètres | Colonne « Normal » des 23 GDD | Colonne « Expert » des 23 GDD |

**Les 23 GDD restent valides sans réécriture de fond.** Leurs tableaux « Normal / Expert » décrivent désormais deux **configurations de serveur** au lieu de deux modes de joueur.

### 2. Un joueur peut avoir une exploitation sur chaque serveur

Aligné sur SimAgri (« un seul compte par personne physique **et par serveur** »).

```
Compte joueur (identité unique)
  ├── Exploitation sur le serveur Normal   (optionnelle)
  └── Exploitation sur le serveur Expert   (optionnelle)
```

**Conséquences** :
- Un joueur peut découvrir en Normal puis essayer Expert **sans perdre sa première ferme**
- Il n'y a pas de « passage » de Normal à Expert : on crée une nouvelle exploitation sur l'autre serveur
- Son temps de jeu se répartit entre les deux (auto-régulation naturelle)
- Interdiction stricte des transferts entre serveurs : ni argent, ni matériel, ni animaux, ni terres

### 3. Ce qui est partagé entre les serveurs

| Élément | Partagé ? | Justification |
|---------|:---------:|---------------|
| Identité de compte | ✅ Oui | Un seul login |
| Liste d'amis | ✅ Oui | La relation sociale précède le serveur |
| Messagerie privée | ✅ Oui | On discute avec un joueur, pas avec une ferme |
| Forum | ✅ Oui | Catégories par serveur, mais communauté commune |
| Encyclopédie / aide | ✅ Oui | Contenu de référence identique |
| Abonnement premium | ✅ Oui | Souscrit une fois, actif sur les deux serveurs |
| **Économie, marché, prix** | ❌ Non | Cloisonnement strict |
| **Classements** | ❌ Non | Comparer un Normal et un Expert n'a pas de sens |
| **Coopératives, CUMA, ETA** | ❌ Non | Structures locales à un serveur |
| **Génétique, cheptel, terres** | ❌ Non | Aucun transfert |

### 4. Stratégie d'ouverture — le serveur Normal d'abord

Le risque principal de cette décision est la **fragmentation de la population**. Pour un jeu économique multijoueur, un serveur peu peuplé est un serveur mort : pas de marché, pas de prestataires, pas de coopératives.

**Mesure de mitigation** :

```
PHASE 1 — Lancement : serveur Normal uniquement
  Objectif : concentrer toute la population, valider l'équilibrage,
             faire vivre le marché et les métiers de service.

PHASE 2 — Ouverture du serveur Expert
  Condition : le serveur Normal compte au moins 800 joueurs actifs
  Justification : il faut qu'environ 250-300 joueurs puissent migrer
                  vers Expert sans vider le Normal.

PHASE 3 — Serveurs supplémentaires (si la population le justifie)
  Un second serveur Normal si le premier dépasse 3 000 joueurs actifs.
```

**Seuils de viabilité d'un serveur** (à surveiller, cf. `GDD-gouvernance-serveur`) :

| Population active | Viabilité | Ce qui fonctionne / ne fonctionne pas |
|:-----------------:|-----------|---------------------------------------|
| < 100 | ❌ Non viable | Marché atone, aucun métier de service rentable |
| 100-250 | ⚠️ Fragile | Marché fonctionnel, 1-2 concessionnaires possibles, pas de CUMA |
| 250-800 | ✅ Viable | Tous les métiers viables, CUMA et CAR possibles |
| 800-3 000 | ✅ Optimal | Concurrence saine entre prestataires, marché profond |
| > 3 000 | ⚠️ Saturation | Ouvrir un second serveur |

**Filets de sécurité déjà prévus dans les GDD** (qui protègent un serveur peu peuplé) :
- ETA PNJ toujours disponible (`GDD-metiers-eta-concession` §2)
- Coopérative PNJ pour acheter et vendre (`GDD-marche` §3)
- Concessionnaire PNJ de secours (`GDD-metiers-eta-concession` §7)

### 5. Le choix du serveur à l'inscription

L'écran de choix devient déterminant. Il doit être **honnête sur l'exigence** sans dissuader.

```
┌─ Choisir votre serveur ─────────────────────────────────────────┐
│                                                                  │
│  🌾 NORMAL — « Je veux gérer ma ferme »                           │
│     👥 1 247 exploitants actifs                                   │
│                                                                  │
│     • Progression fluide, décisions claires                      │
│     • Charges allégées (12%)                                     │
│     • La météo influence, elle ne bloque pas                     │
│     • Faillite impossible                                        │
│     • Un oubli coûte du temps, jamais votre ferme                │
│                                                                  │
│     → Recommandé pour découvrir Agriva                           │
│                              [ Créer ma ferme ici ]              │
│                                                                  │
│  ─────────────────────────────────────────────────────────────   │
│                                                                  │
│  🔬 EXPERT — « Je veux comprendre et optimiser »                  │
│     👥 386 exploitants actifs                                     │
│                                                                  │
│     • Simulation agronomique et économique réaliste              │
│     • Charges réelles (28%), risques réels                       │
│     • La météo bloque les travaux                                │
│     • Maladies, pannes, crises à gérer                           │
│     • Une mauvaise gestion peut mener au redressement            │
│                                                                  │
│     ⚠️ Plus exigeant. Prévoyez d'y consacrer plus d'attention.    │
│                                                                  │
│     → Recommandé si vous aimez la technique agricole             │
│                              [ Créer ma ferme ici ]              │
│                                                                  │
│  💡 Vous pouvez avoir une exploitation sur CHAQUE serveur.        │
│     Rien n'est transférable de l'un à l'autre.                   │
└──────────────────────────────────────────────────────────────────┘
```

## Conséquence majeure : l'ADR-003 devient largement obsolète

L'ADR-003 avait établi qu'**« Expert n'est pas plus rentable que Normal »**. Cette contrainte existait parce que les deux populations partageaient un monde : si Expert avait rapporté davantage, Normal aurait été « le mauvais choix », et inversement.

**Avec deux serveurs séparés, cette contrainte tombe.** Les joueurs ne partagent ni marché ni classement. Il n'y a plus d'arbitrage possible entre les deux.

### La nouvelle règle d'équilibrage

```
❌ ANCIENNE CONTRAINTE (ADR-003)
   Le revenu Expert doit rester comparable au revenu Normal,
   sinon un mode devient objectivement supérieur.

✅ NOUVELLE CONTRAINTE
   Chaque serveur doit être INTERNEMENT équilibré et plaisant.
   Aucune comparaison de rentabilité entre serveurs n'est nécessaire.
```

**Ce que cela libère** :
- Le serveur Expert peut être franchement plus exigeant **et** mieux récompenser la maîtrise
- Le serveur Normal peut rester généreux sans qu'on lui reproche d'être « trop facile »
- Les scénarios chiffrés des GDD n'ont plus besoin de converger vers un revenu commun

**Ce que cela ne change pas** :
- L'ADR-002 reste pleinement en vigueur : le serveur Normal préserve la recette SimAgri
- Chaque filière doit rester viable **sur son serveur** (cible 38-50 k€ en Normal)
- Le mode Expert reste conçu pour la profondeur, pas pour la performance affichée

**Statut de l'ADR-003** : conservé comme référence historique, mais sa contrainte principale est levée. Les tableaux de comparaison Normal/Expert des GDD restent utiles à titre informatif.

## Conséquences sur les documents existants

### À réviser
| Document | Ce qui change |
|----------|---------------|
| `ADR-001` | Marquer la décision d'implantation comme remplacée par cet ADR |
| `ADR-003` | Marquer la contrainte principale comme levée |
| `GDD-onboarding` §2 et §7 | Le choix de mode devient un choix de serveur ; le « passage Normal → Expert » devient la création d'une seconde exploitation |
| `GDD-social-multijoueur` §7 | Classements par serveur ; préciser ce qui est inter-serveurs (amis, MP, forum) |
| `GDD-gouvernance-serveur` §6 | Intégrer la stratégie d'ouverture en 3 phases et les seuils de viabilité |
| Les 23 GDD | Remplacer « mode Normal / mode Expert » par « serveur Normal / serveur Expert » là où l'expression désigne l'univers de jeu (et non un paramètre) |

### Ce qui ne change pas
- Les 24 valeurs de paramètres partagées (charges, aides, prix, capacités de travail)
- Toutes les mécaniques décrites dans les 23 GDD
- L'exigence d'un **moteur unique** avec paramètres verrouillés par configuration de serveur (contrainte d'architecture inchangée)
- La couverture fonctionnelle des 119 systèmes

## Contrainte d'architecture (inchangée mais renforcée)

```
La configuration de serveur devient une entité de premier ordre :

ServerConfig {
  id, name, type: 'normal' | 'expert',
  socialChargeRate: 0.12 | 0.28,
  weatherBlocking: false | true,
  diseasesEnabled: false | true,
  ... (tous les paramètres des annexes des 23 GDD)
}

Toute règle métier lit ses paramètres depuis la ServerConfig du joueur.
Aucune valeur en dur, aucun `if (mode === 'expert')` dispersé dans le code.
```

C'est exactement l'exigence qui existait déjà pour les modes. Elle devient plus naturelle : un serveur = une configuration chargée au démarrage.

## Risque résiduel assumé

**La fragmentation de la population reste le risque principal.** Il est mitigé par l'ouverture séquentielle (Normal d'abord) et par les PNJ de secours, mais pas éliminé.

**Indicateur à surveiller après l'ouverture d'Expert** : si le serveur Expert descend sous 150 joueurs actifs pendant 3 mois consécutifs, envisager sa fusion avec Normal (les exploitations Expert basculent en configuration Normal, avec compensation).
