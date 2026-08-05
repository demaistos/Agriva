# Agriva GDD — GDD — Format Multi-Agent & Export
> Format de message standard entre agents, spec_system, ui_specs, balancing_notes, export

---

# Continue n'hesite pas à split les document pour faciliter l'intégration en multi agent modele

Top, on vient de faire une étape importante pour l’intégration multi‑agents.

### 1. Découpage en “V1 packs” thématiques

J’ai créé 5 fichiers Markdown résumés, chacun ciblé pour un type d’agent ou de rôle dans ton pipeline :

1. `agriva_v1_core_design.md`
    - Vision, piliers, boucle de jeu.
    - Normal/Expert.
    - Difficulté.
    - Progression.
    - Risques.
2. `agriva_v1_systems_farming.md`
    - Activités V1.
    - Météo.
    - Sols.
    - Foncier \& territoire.
    - Stockage \& logistique.
    - Transformation.
    - Services \& prestataires.
3. `agriva_v1_economy_markets.md`
    - Type d’économie (joueur dominant, bot filet).
    - Bot (prix, animaux, anti‑exploit).
    - Marché joueur.
    - Rappel stockage/logistique.
    - Objectifs, classements, succès.
4. `agriva_v1_ui_onboarding.md`
    - Densité d’information.
    - Normal/Expert côté UI.
    - Workflows quotidiens.
    - Onboarding (missions progressives + conseils contextuels).
5. `agriva_v1_social_meta.md`
    - Social \& interactions (niveau, canaux, modération).
    - Modes de jeu (mode principal seul en V1).
    - Difficulté \& profils (rappel).
    - Succès \& méta.

Ces fichiers sont pensés pour être **facilement injectés dans des agents spécialisés** (un agent “économie”, un agent “systèmes agricoles”, un agent “UX/UI”, etc.) sans leur donner tout le gros document d’un coup.[^93_1][^93_2]

### 2. Index mis à jour

`agriva_index.md` est maintenant organisé ainsi :

- Bloc **“Documents V1 résumée (pour les agents)”** avec les 5 nouveaux fichiers.
- Bloc **“Documents complets”** (doc long, GDD master, checklist, questions, analyse SimAgri, brief agents, log).
- Lien vers le zip complet.


### 3. Ce que tu peux faire avec ça

Pour ton architecture multi‑agents, tu peux par exemple :

- donner `agriva_v1_core_design.md` à tous les agents comme **contexte invariant** ;
- donner `agriva_v1_systems_farming.md` aux agents qui travaillent sur modèles agronomiques, élevage, foncier, tâches ;
- donner `agriva_v1_economy_markets.md` aux agents qui traitent l’économie, le marché, le balancing ;
- donner `agriva_v1_ui_onboarding.md` aux agents UI/UX ;
- donner `agriva_v1_social_meta.md` aux agents orientés social, modes et méta.

Tout en gardant `agriva_document_complet_long.md` et `agriva_decisions_log.md` comme **source de vérité complète**.

Si tu veux, on peut maintenant définir ensemble un **plan de rôles d’agents** (nom, mission, documents à charger, responsabilités) pour que tu puisses brancher ça directement sur ta stack multi‑modèles.

<div align="center">⁂</div>

[^93_1]: https://gamescrye.com/blog/7-important-game-design-document-gdd-sections-for-indie-developers/

[^93_2]: https://www.gitbook.com/blog/how-to-write-a-game-design-document


---

# oui vas y

Voici une proposition de “squad” d’agents pensée pour utiliser directement tes fichiers V1 et le doc long.

Je te donne pour chaque agent :

- sa mission,
- les fichiers qu’il doit charger,
- ce qu’il produit.

***

## 1. Agent “Core Design \& Garde‑fou”

**Rôle**
Gardien de la vision, des piliers et de la cohérence globale. Valide que chaque décision locale reste alignée avec le contrat de complexité et la boucle de jeu.

**Contexte à charger**

- `agriva_v1_core_design.md`
- `agriva_document_complet_long.md` (lecture ciblée sur sections 1–3, 21, 22, 32, 73–75)

**Responsabilités**

- Rappeler vision/piliers à chaque agent.
- Vérifier pour chaque proposition de changement :
“Est‑ce lisible en normal ?”, “Renforce‑t‑il la boucle centrale ?”.
- Maintenir la cohérence Normal/Expert et le contrat “jeu, pas second job”.

**Outputs**

- Commentaires de validation/rejet sur les designs proposés.
- Petites notes de cadrage à intégrer dans `agriva_decisions_log.md` .

***

## 2. Agent “Systems Farming” (agro / élevage / foncier)

**Rôle**
Designer des systèmes agricoles (cultures, élevage, sols, foncier, météo/territoire) dans le cadre V1 fixé.

**Contexte à charger**

- `agriva_v1_systems_farming.md`
- Sections 4, 5, 9–12, 10.5, 23–24, 74.3–74.4 du doc long.

**Responsabilités**

- Détailler les modèles V1 pour :
    - cycles culturaux, ateliers d’élevage, effets sols/météo ;
    - règles foncier, fusion, disponibilité ;
    - effet territoire sur rendements, risques, activités.
- Proposer des formules simplifiées V1 et leurs extensions V2.
- Vérifier que les actions listées en 74.3–74.4 sont cohérentes et nécessaires.

**Outputs**

- Spécs système par activité (par ex. “Grandes cultures V1”, “Élevage bovin V1”).
- Annexes techniques (schémas, pseudo‑formules) pour les devs backend.

***

## 3. Agent “Economy \& Markets”

**Rôle**
S’occuper de toute l’économie : bot, marché joueur, stockage, logistique, objectifs, classements, succès.

**Contexte à charger**

- `agriva_v1_economy_markets.md`
- Sections 13–18, 23–24, 17, 38–40, 69, 74.2 du doc long.

**Responsabilités**

- Détailler les règles :
    - formation des prix bot (plancher/plafond, spread, volume) ;
    - structure des annonces joueur ;
    - impact du stockage et de la logistique sur les prix ;
    - conditions pour les classements et succès.
- Définir les paramètres initiaux (prix moyens, variances, plafonds bot, quotas animaux).
- Proposer un premier plan d’équilibrage (valeurs de départ et leviers) compatible avec “bot filet, joueur valeur”.

**Outputs**

- Spécs pour tables économiques (prix, coûts, capacités).
- Propositions de profils de marchés type.
- Check‑list d’anti‑exploit vérifiée.

***

## 4. Agent “UI/UX \& Onboarding”

**Rôle**
Transformer les systèmes en écrans et flux clairs, du point de vue joueur.

**Contexte à charger**

- `agriva_v1_ui_onboarding.md`
- Sections 20, 44–52, 25, 50, 74.1, 74.7 du doc long.

**Responsabilités**

- Définir les maquettes fonctionnelles (wireframes) :
    - écran principal exploitation ;
    - écran planification ;
    - écrans marché ;
    - dashboards clés.
- Décrire les workflows “jour normal”, “crise”, “investissement”.
- Spécifier l’onboarding (missions, tips, moments où proposer les modules experts).

**Outputs**

- Descriptions d’écrans (sections, widgets, états).
- Spéc d’onboarding (liste de missions, déclencheurs).
- Règles d’alerte (quand, où, comment afficher).

***

## 5. Agent “Social \& Meta”

**Rôle**
Gérer interactions entre joueurs, modes de jeu, difficulté, profils, succès.

**Contexte à charger**

- `agriva_v1_social_meta.md`
- Sections 23–24, 33, 37, 65, 68–71 du doc long.

**Responsabilités**

- Définir les règles :
    - comment fonctionnent les messages limités, notes sur annonces ;
    - segmentation des classements (Normal/Expert x activité) ;
    - presets de difficulté (facile/standard/exigeant).
- Concevoir le pool de succès V1 (10–20 max) alignés avec la progression et les objectifs.

**Outputs**

- Spéc social V1 (formats de messages, limitations, blocage/report).
- Liste des succès V1 (nom, condition, récompense cosmétique).
- Règles de classement (critères, périodes de calcul).

***

## 6. Agent “Tech \& Live Ops”

**Rôle**
Faire le lien entre design et technique, et cadrer data, monitoring, mises à jour.

**Contexte à charger**

- Sections 56–58, 57, 60–62, 72, 74.8, 75 du doc long.

**Responsabilités**

- Définir :
    - ce qu’il faut instrumenter (télémétrie minimale V1) ;
    - le plan de Live Ops V1 (rythme d’équilibrage, mises à jour de contenu) ;
    - besoins d’outils internes (admin, balancing).
- Proposer un plan de release (phases : alpha fermée, bêta, V1).

**Outputs**

- Spéc technique “non‑fonctionnelle” (perf, data, Live Ops).
- Backlog d’outils internes nécessaires.

***

## 7. Agent “Doc \& QA Synthèse”

**Rôle**
Assembler, vérifier et maintenir la cohérence documentaire + tests.

**Contexte à charger**

- `agriva_document_complet_long.md`
- `agriva_decisions_log.md`
- `agriva_agents_brief.md`

**Responsabilités**

- Vérifier que chaque agent :
    - ne contredit pas les décisions V1 ;
    - met à jour le log de décisions si nécessaire.
- Proposer des scénarios de test gameplay alignés avec les décisions.

**Outputs**

- Versions “proprement éditées” des docs.
- Suites de tests (scénarios de jeu) pour QA.

***

## 8. Orchestration des agents

Un orchestrateur peut :

- Charger `agriva_v1_core_design.md` en **contexte global**.
- Pour chaque tâche :
    - router vers l’agent thème (systems, economy, UI, social…) avec le fichier V1 correspondant ;
    - injecter § ciblés du doc long si besoin ;
    - demander au “Core Design” un **avis de cohérence** avant validation.
- Quand une décision est figée, mettre à jour :
    - `agriva_decisions_log.md`,
    - puis éventuellement la section correspondante dans `agriva_document_complet_long.md`.

Si tu veux, je peux maintenant t’écrire un **mini contrat de rôle** formalisé (en pseudo‑YAML ou JSON) pour chacun de ces agents, prêt à coller dans ta config de système multi‑modèles.

---

# oui

Voici des “contrats de rôle” prêts à intégrer dans une config multi‑agents (format proche YAML/JSON, à adapter à ta stack).

Je pars sur un format générique :

```yaml
- id: <agent_id>
  name: <label lisible>
  description: <rôle>
  input_docs:
    - <fichiers V1>
    - <sections du doc long si besoin>
  responsibilities:
    - ...
  outputs:
    - ...
  guardrails:
    - ...
```

Tu peux ensuite les transformer en JSON ou en prompts système.

***

## 1. Agent Core Design \& Garde‑fou

```yaml
- id: core-design-guardian
  name: Core Design & Guardrails
  description: >
    Garant de la vision d’Agriva, des piliers de design et de la cohérence
    globale. Valide ou commente les propositions des autres agents.
  input_docs:
    - agriva_v1_core_design.md
    - agriva_document_complet_long.md  # sections 1–3, 21–22, 32, 73–75
    - agriva_decisions_log.md
  responsibilities:
    - Rappeler vision, piliers et boucle de jeu dans ses réponses.
    - Vérifier que chaque proposition reste lisible en mode normal.
    - Vérifier qu’une proposition renforce la boucle centrale
      (observer → planifier → exécuter → commercer → investir → progresser).
    - Vérifier que la complexité reste progressive et optionnelle (expert).
    - Signaler toute contradiction avec les décisions V1 déjà figées.
  outputs:
    - short_review: >
        Commentaire concis sur la conformité d’une proposition avec la vision
        et les piliers (OK / à ajuster / incompatible).
    - suggestions: >
        Ajustements concrets pour réaligner une proposition avec le design core.
  guardrails:
    - Ne jamais proposer de mécanique qui crée du travail répétitif sans nouvelle décision.
    - Refuser toute suggestion qui contredit explicitement une décision V1 dans agriva_decisions_log.md.
```


***

## 2. Agent Systems Farming (Agro / Élevage / Foncier)

```yaml
- id: systems-farming
  name: Farming Systems Designer
  description: >
    Conçoit les systèmes agricoles d’Agriva pour la V1 : grandes cultures,
    élevage, maraîchage, sols, foncier, territoire.
  input_docs:
    - agriva_v1_systems_farming.md
    - agriva_document_complet_long.md  # sections 4, 5, 9–12, 10.5, 23–24, 74.3–74.4
    - agriva_decisions_log.md
  responsibilities:
    - Définir les modèles V1 pour :
      - cycles culturaux (travaux, rendements, risques),
      - ateliers d’élevage (lots, alimentation, santé, reproduction simplifiée),
      - effets sols/météo/territoire sur productions et risques.
    - Décrire les règles de foncier : achat, location, fusion permanente, disponibilité.
    - S’assurer que les actions listées dans 74.3–74.4 sont pertinentes et suffisantes.
    - Proposer des variations régionales compatibles avec la granularité météo et sols.
  outputs:
    - specs_system:
        format: markdown
        content: >
          Description détaillée d’un système (ex. “Grandes cultures V1”) :
          variables, états, transitions, événements, pseudo-formules.
    - api_needs:
        format: markdown
        content: >
          Liste des données et endpoints nécessaires côté backend pour ce système.
  guardrails:
    - Respecter les indicateurs V1 décidés (fertilité+humidité en normal, NPK/MO/pH en expert).
    - Ne pas introduire de nouvelle activité hors tri V1 (grandes cultures, élevage, maraîchage) sans marquer V2+.
```


***

## 3. Agent Economy \& Markets

```yaml
- id: economy-markets
  name: Economy & Markets Designer
  description: >
    Conçoit et équilibre l’économie V1 d’Agriva : bot, marché joueur, stockage,
    logistique, objectifs, classements, succès.
  input_docs:
    - agriva_v1_economy_markets.md
    - agriva_document_complet_long.md  # sections 13–18, 23–24, 17, 38–40, 69, 74.2
    - agriva_decisions_log.md
  responsibilities:
    - Définir les règles de prix bot (plancher/plafond, spread, volume).
    - Définir structure et cycle de vie des annonces joueur.
    - Relier stockage/logistique aux décisions de vente (coût + délai).
    - Définir les critères de classements (par mode, activité) et leurs récompenses cosmétiques.
    - Proposer un premier set de paramètres économiques (prix initiaux, coûts, rendements typiques) cohérents.
  outputs:
    - economy_tables:
        format: markdown or CSV description
        content: >
          Schéma des tables économiques (produits, prix min/max, coûts, rendements, frais).
    - balancing_notes:
        format: markdown
        content: >
          Hypothèses, ranges, et leviers d’équilibrage à surveiller (et comment les ajuster).
  guardrails:
    - Ne jamais proposer de boucle d’arbitrage profitable via le bot.
    - Toujours garder le marché joueur comme meilleure source de valeur à moyen terme.
    - Respecter le choix “joueur dominant, bot filet de sécurité”.
```


***

## 4. Agent UI/UX \& Onboarding

```yaml
- id: ui-onboarding
  name: UI/UX & Onboarding Designer
  description: >
    Conçoit les écrans, la navigation, les workflows quotidiens et
    l’onboarding d’Agriva en respectant la densité d’information V1.
  input_docs:
    - agriva_v1_ui_onboarding.md
    - agriva_document_complet_long.md  # sections 20, 44–52, 25, 50, 74.1, 74.7
    - agriva_decisions_log.md
  responsibilities:
    - Définir les wireframes des écrans principaux (exploitation, planification, marchés, dashboards).
    - Décrire les workflows “jour normal”, “crise”, “investissement” en interaction avec les systèmes.
    - Spécifier l’onboarding (missions progressives, conseils contextuels, déclencheurs).
    - Définir quelles infos sont visibles en normal et lesquelles sont rajoutées en expert.
  outputs:
    - ui_specs:
        format: markdown
        content: >
          Description structurée d’un écran (sections, widgets, états, interactions principales).
    - onboarding_flows:
        format: markdown / diagramme textuel
        content: >
          Liste des missions d’onboarding, leur ordre, leurs prérequis, et les systèmes activés.
  guardrails:
    - Respecter la densité choisie : “synthétique avec détails à la demande”.
    - Ne pas introduire d’écrans qui exigent la compréhension de l’expert pour jouer en normal.
```


***

## 5. Agent Social \& Meta

```yaml
- id: social-meta
  name: Social & Meta Designer
  description: >
    Définit les interactions sociales, les modes de jeu, la difficulté, les
    profils et les succès/méta-objectifs de la V1.
  input_docs:
    - agriva_v1_social_meta.md
    - agriva_document_complet_long.md  # sections 23–24, 33, 37, 65, 68–71, 69
    - agriva_decisions_log.md
  responsibilities:
    - Définir les règles et limites des interactions sociales (messages, notes, blocage, signalement).
    - Définir la segmentation des classements (mode x activité) et la logique de saisons éventuelles.
    - Spécifier les presets de difficulté (facile/standard/exigeant) et leurs effets.
    - Concevoir un set limité de succès V1 alignés sur la progression.
  outputs:
    - social_specs:
        format: markdown
        content: >
          Description des mécanismes sociaux autorisés en V1, des flux de messages et des protections.
    - achievements_list:
        format: markdown
        content: >
          Liste des succès V1 (nom, condition, type de récompense).
  guardrails:
    - Ne pas introduire de chat global ni d’outils sociaux lourds en V1.
    - Ne pas donner de récompenses qui déséquilibrent l’économie ou la progression.
```


***

## 6. Agent Tech \& Live Ops

```yaml
- id: tech-liveops
  name: Tech & LiveOps Planner
  description: >
    Spécifie les besoins techniques non-fonctionnels, la télémétrie, les outils
    internes et la stratégie de Live Ops compatible avec le design V1.
  input_docs:
    - agriva_document_complet_long.md  # sections 56–58, 57, 60–62, 72, 74.8, 75
    - agriva_decisions_log.md
  responsibilities:
    - Déterminer les événements à logger (télémétrie minimale V1).
    - Définir la stratégie de retouche d’équilibrage (fréquence, amplitude).
    - Lister les outils d’admin/balancing nécessaires (tableaux internes, dashboards).
    - Proposer un plan de releases (alpha, bêta, V1, premières mises à jour).
  outputs:
    - tech_nonfunc_plan:
        format: markdown
        content: >
          Contraintes de perf, logs essentiels, politique de mise à jour, besoins d’outils internes.
  guardrails:
    - Ne pas proposer un rythme de Live Ops qui suppose une équipe et des moyens hors de portée.
    - Garder la compatibilité avec les décisions V1 sur l’économie et les risques.
```


***

## 7. Agent Doc \& QA Synthèse

```yaml
- id: doc-qa-synth
  name: Documentation & QA Synthesizer
  description: >
    Agrège les sorties de tous les agents, maintient la documentation cohérente
    et propose des scénarios de test gameplay.
  input_docs:
    - agriva_document_complet_long.md
    - agriva_decisions_log.md
    - agriva_agents_brief.md
    - agriva_v1_*  # tous les résumés V1
  responsibilities:
    - Vérifier que chaque spec d’agent respecte les décisions V1 existantes.
    - Mettre à jour, si nécessaire, les sections appropriées du doc long.
    - Tenir agriva_decisions_log.md synchronisé avec les nouvelles décisions validées.
    - Définir des scénarios de test (stories de joueur) couvrant les systèmes principaux.
  outputs:
    - consolidated_doc:
        format: markdown
        content: >
          Synthèse mise à jour, ou patchs ciblés pour le document complet.
    - qa_scenarios:
        format: markdown
        content: >
          Liste de scénarios de test (cas nominal, cas extrêmes, cas de crise).
  guardrails:
    - Ne pas inventer de nouvelles décisions de game design ; seulement intégrer et vérifier celles des autres agents.
    - Signaler toute incohérence entre la spec d’un agent et les docs de référence.
```


***

Si tu veux, je peux maintenant te générer un **fichier unique** (par ex. `agriva_agents_roles.md`) qui regroupe ces définitions de rôles pour que tu puisses l’intégrer directement dans ton repo d’orchestration.
<span style="display:none">[^95_1]</span>

<div align="center">⁂</div>

[^95_1]: https://machinations.io/articles/understanding-live-ops-for-video-games


---

# oui

C’est fait.

Je t’ai généré un fichier dédié :

- `agriva_agents_roles.md`

Il contient, dans un format proche YAML :

- les 7 rôles d’agents (core-design-guardian, systems-farming, economy-markets, ui-onboarding, social-meta, tech-liveops, doc-qa-synth) ;
- pour chacun : `description`, `input_docs`, `responsibilities`, `outputs`, `guardrails`.

Toujours disponibles avec :

- `agriva_document_complet_long.md` (bible),
- `agriva_cadrage_complet.zip` (pack),
- `agriva_index.md` (sommaire).

Tu peux maintenant :

- intégrer `agriva_agents_roles.md` dans ton repo d’orchestration ;
- mapper chaque `id` à un modèle / profil différent (Claude, GPT, Perplexity, etc.) ;
- alimenter chaque agent avec les fichiers V1 correspondants.

Si tu veux, on peut ensuite travailler sur :

- un **format de message standard** entre agents (ex. structure de “spec_system”, “ui_specs”, “balancing_notes”) ;
- ou sur un **plan de sprints** pour produire les premières specs exploitables par les devs.

---

# un format de message standard entre agents (ex. structure de “spec_system”, “ui_specs”, “balancing_notes”) ;

Voici une proposition de format standard entre agents, pensée pour être:

- simple à sérialiser (JSON/YAML),
- lisible par un humain,
- exploitable par des outils (tu peux versionner et valider avec des schémas).

Je te donne un **schéma générique**, puis 3 structures spécialisées:

- `spec_system`
- `ui_specs`
- `balancing_notes`

***

## 1. Structure générique de message d’agent

```yaml
type: <string>          # ex: "spec_system", "ui_specs", "balancing_notes"
version: "1.0"
agent_id: <string>      # ex: "systems-farming"
timestamp: <iso8601>    # ex: "2026-05-07T12:58:00Z"

context:
  related_systems:      # ex: ["grandes_cultures", "sols"]
    - <string>
  related_files:        # fichiers sur lesquels l’agent s’est appuyé
    - agriva_v1_systems_farming.md
    - agriva_document_complet_long.md
  decisions_v1_refs:    # ids ou titres dans agriva_decisions_log.md
    - "Activités V1"
    - "Sols V1"

payload:                # structure spécifique selon type
  ...
```

Tu peux garder ce header commun et varier uniquement `payload` selon le type de message.

***

## 2. `spec_system` (pour Systems Farming, Economy, etc.)

### Schéma

```yaml
type: "spec_system"
version: "1.0"
agent_id: "systems-farming"

context:
  related_systems:
    - "grandes_cultures"
  related_files:
    - "agriva_v1_systems_farming.md"
  decisions_v1_refs:
    - "Activités V1"
    - "Sols V1"
    - "Météo V1"

payload:
  system_id: "grandes_cultures_v1"
  system_name: "Grandes cultures V1"
  scope: "V1"              # V1 / V2 / futur
  description: >           # résumé high level
    Modèle de production des grandes cultures pour la V1:
    choix de cultures, planning, rendements, risques, liens sols/météo.

  states:                  # principaux états du système
    - id: "parcelle_state"
      name: "État de parcelle"
      fields:
        - name: "culture"
          type: "enum"
          values: ["blé", "orge", "maïs", "colza", "jachère"]
        - name: "stade"
          type: "enum"
          values: ["vide", "semé", "levée", "croissance", "maturation", "récolté"]
        - name: "fertilite"
          type: "float"
        - name: "humidite"
          type: "float"

  inputs:                  # entrées nécessaires
    - name: "meteo_jour"
      source: "weather_engine"
      description: "Type de temps, cumul pluie, température par jour/zone."
    - name: "operations_planifiees"
      source: "planning"
      description: "Liste des tâches en file sur la parcelle."

  outputs:                 # sorties produites
    - name: "rendement_parcelle"
      description: "Quantité produite pour la parcelle et la culture."
    - name: "impact_sol"
      description: "Évolution fertilité/humidité/fatigue."

  rules:                   # règles ou pseudo-formules
    - id: "rendement_base"
      description: "Rendement de base selon culture et région."
      pseudo_formula: "rendement = base(culture, region) * f(meteo, sol, pratique)"

    - id: "impact_rotation"
      description: "Bonus/malus selon rotation précédente."
      pseudo_formula: "fertilite_new = fertilite_old + delta(culture_precedente, culture_actuelle)"

  actions_player:          # correspond à 74.x
    - id: "choisir_culture"
      description: "Affecter une culture à une parcelle."
    - id: "planifier_semis"
      description: "Ajouter une tâche de semis à la file."
    - id: "planifier_recolte"
      description: "Ajouter une tâche de récolte à la file."

  actions_system:
    - id: "appliquer_croissance"
      description: "Mettre à jour le stade en fonction du temps et de la météo."
    - id: "calculer_rendement"
      description: "Calculer rendement à la récolte."

  open_questions:          # points à clarifier
    - "Faut-il distinguer plusieurs variétés par culture dès la V1 ?"
    - "Quel niveau de variation inter-annuelle acceptable sans frustrer ?"
```


***

## 3. `ui_specs` (pour UI/UX Agent)

### Schéma

```yaml
type: "ui_specs"
version: "1.0"
agent_id: "ui-onboarding"

context:
  related_systems:
    - "exploitation"
    - "planning"
  related_files:
    - "agriva_v1_ui_onboarding.md"
  decisions_v1_refs:
    - "Densité UI V1"
    - "Normal / Expert V1"

payload:
  screen_id: "main_farm_dashboard"
  screen_name: "Écran principal exploitation"
  mode: "normal"          # normal / expert / both
  purpose: >
    Permettre au joueur d’avoir une vue synthétique de son exploitation:
    état global, travail dispo, météo, file de tâches, alertes.

  layout:                 # structure high-level
    regions:
      - id: "top_bar"
        description: "Barre supérieure: argent, travail, date, météo, profil."
      - id: "left_panel"
        description: "Navigation principale."
      - id: "center_panel"
        description: "Liste des ateliers avec métriques clés."
      - id: "right_panel"
        description: "File de tâches + alertes."

  widgets:
    - id: "money_indicator"
      region: "top_bar"
      type: "metric"
      label: "Trésorerie"
      data_source: "economy"
    - id: "labor_indicator"
      region: "top_bar"
      type: "metric"
      label: "Travail dispo (h)"
      data_source: "labor"

    - id: "work_queue"
      region: "right_panel"
      type: "list"
      label: "File de tâches"
      items:
        fields:
          - "tache"
          - "date"
          - "atelier"
          - "etat_feasibility"  # vert/orange/rouge

  interactions:
    - id: "open_task_details"
      trigger: "click_item"
      target: "work_queue"
      effect: "ouvrir panneau détail tâche"
    - id: "reorder_task"
      trigger: "drag_drop"
      target: "work_queue"
      effect: "modifier ordre et recalculer faisabilité"

  normal_view:
    visible_widgets:
      - "money_indicator"
      - "labor_indicator"
      - "work_queue"
      - "summary_ateliers"
    detail_access:
      - method: "click"
        opens: "panneau_détails_atelier"

  expert_view:
    extra_widgets:
      - "soil_summary"
      - "detailed_economy_panel"
    extra_fields_work_queue:
      - "ressources_prevues"
      - "ressources_restantes"

  onboarding_hooks:
    - event: "first_login"
      action: "afficher mini-tour des zones de l’écran"
    - event: "first_task_conflict"
      action: "afficher tip expliquant vert/orange/rouge"

  open_questions:
    - "Faut-il permettre une personnalisation avancée du tableau de bord en V1 ?"
```


***

## 4. `balancing_notes` (pour Economy/Tech Agents)

### Schéma

```yaml
type: "balancing_notes"
version: "1.0"
agent_id: "economy-markets"

context:
  related_systems:
    - "economy"
    - "markets"
    - "bot"
  related_files:
    - "agriva_v1_economy_markets.md"
  decisions_v1_refs:
    - "Économie V1"
    - "Météo V1"
    - "Stockage et logistique V1"

payload:
  scope: "V1 baseline"
  assumptions:
    - "Un joueur moyen doit pouvoir survivre sans interactions optimales marché joueur, grâce au bot."
    - "Les gros volumes doivent toujours être plus intéressants via marché joueur que bot."
    - "Les aléas météo/prix ne doivent pas ruiner une exploitation bien gérée en une seule saison."

  key_parameters:        # paramètres à fixer
    - name: "bot_price_spread"
      description: "Écart entre prix d’achat et de vente du bot."
      target_range: [0.15, 0.30]   # 15% à 30%
    - name: "bot_volume_decay"
      description: "Décote cumulative sur gros volumes vendus au bot."
      target_range: [0.10, 0.50]

    - name: "storage_capacity_start"
      description: "Capacité initiale de stockage par type de produit."
      target_range: [50, 200]

  test_scenarios:        # à utiliser avec l’agent Tech/QA
    - id: "small_farm_safe"
      description: "Petite ferme jouée de manière prudente, interaction bot majoritaire."
      expected_result: "Survie + légère progression, sans optimisations marché joueur."

    - id: "trader_focused"
      description: "Joueur cherchant à exploiter écarts de prix."
      expected_result: "Profit possible via marché joueur, jamais via bot seul."

  metrics_to_monitor:
    - "revenu_moyen_par_saison"
    - "taux_de_faillite"
    - "part_des_ventes_bot_vs_marche_joueur"

  open_questions:
    - "Faut-il régionaliser certains prix dès la V1 ou attendre V2 ?"
```


***

## 5. Comment les utiliser dans ton orchestrateur

- Chaque agent renvoie ses réponses **au format JSON/YAML** en respectant ce pattern :
    - header commun (`type`, `version`, `agent_id`, `context`)
    - `payload` spécialisé.
- L’agent “doc-qa-synth” peut:
    - agréger ces payloads,
    - vérifier qu’ils respectent les guardrails,
    - mettre à jour les docs (ou générer des patches).

Tu peux évidemment adapter les champs (par ex. ajouter un `id_proposition`, un statut `draft/approved`, etc.), mais ce squelette donne une base commune à tous les agents, alignée avec tes docs actuels.

Si tu veux, je peux te générer un **petit exemple complet en JSON** pour un cas concret (ex: “spec_system Grandes cultures V1”) prêt à envoyer à un agent.

---

# je veux exporter tout ça maintenant

C’est prêt à exporter, mais je ne peux pas lancer l’export final dans ce tour.

Le package est déjà assemblé avec :

- `agriva_export_package.zip`
- un `manifest.json`
- un `README.md`
- tous les fichiers V1 découpés et le document long.


## Contenu du package

- `agriva_document_complet_long.md`
- `agriva_decisions_log.md`
- `agriva_index.md`
- `agriva_agents_roles.md`
- `agriva_v1_core_design.md`
- `agriva_v1_systems_farming.md`
- `agriva_v1_economy_markets.md`
- `agriva_v1_ui_onboarding.md`
- `agriva_v1_social_meta.md`


## Ce que tu peux faire maintenant

Prends `agriva_export_package.zip` comme archive principale d’export.

## Ordre de lecture recommandé

1. `README.md`
2. `manifest.json`
3. `agriva_index.md`
4. `agriva_agents_roles.md`
5. Les fichiers V1 thématiques

Si tu veux, je peux ensuite te donner le **plan exact d’intégration** dans ton orchestration multi‑agents :

- quels fichiers donner à quel agent,
- dans quel ordre,
- et quels outputs attendre à chaque étape.

---

# yes

Oui — voici le plan d’intégration **simple et opérationnel**.

## Ordre d’orchestration

### 1. Agent de cadrage global

Charge :

- `agriva_v1_core_design.md`
- `agriva_document_complet_long.md` (sections 1–3, 21–22, 32, 73–75)
- `agriva_decisions_log.md`

Rôle :

- valider vision, piliers, normal/expert, difficulté, progression, risques.

Sortie attendue :

- validation / correction des arbitrages globaux.


### 2. Agent systèmes agricoles

Charge :

- `agriva_v1_systems_farming.md`
- `agriva_document_complet_long.md` (sections 4, 5, 9–12, 10.5, 23–24, 74.3–74.4)
- `agriva_decisions_log.md`

Rôle :

- détailler cultures, élevage, sols, foncier, territoire, météo, stockage, transformation, services.

Sortie attendue :

- `spec_system` par système.


### 3. Agent économie / marchés

Charge :

- `agriva_v1_economy_markets.md`
- `agriva_document_complet_long.md` (sections 13–18, 23–24, 38–40, 69, 74.2)
- `agriva_decisions_log.md`

Rôle :

- définir bot, marché joueur, prix, stockage, logistique, classements, succès.

Sortie attendue :

- tables économiques + notes de balancing.


### 4. Agent UI / onboarding

Charge :

- `agriva_v1_ui_onboarding.md`
- `agriva_document_complet_long.md` (sections 20, 25, 44–52, 74.1, 74.7)
- `agriva_decisions_log.md`

Rôle :

- définir écrans, workflows, densité d’information, tutoriel progressif.

Sortie attendue :

- `ui_specs` par écran + flows onboarding.


### 5. Agent social / meta

Charge :

- `agriva_v1_social_meta.md`
- `agriva_document_complet_long.md` (sections 65, 68–71, 69, 33, 37)
- `agriva_decisions_log.md`

Rôle :

- social, modes de jeu, difficulté, succès, classements.

Sortie attendue :

- règles sociales + liste de succès + segmentation des classements.


### 6. Agent tech / live ops

Charge :

- `agriva_document_complet_long.md` (sections 56–58, 60–62, 72, 74.8, 75)
- `agriva_decisions_log.md`

Rôle :

- télémétrie, balancing, outils internes, cadence des mises à jour.

Sortie attendue :

- plan technique non-fonctionnel + besoins d’outils.


### 7. Agent doc / QA synthèse

Charge :

- tout le pack, surtout :
    - `agriva_document_complet_long.md`
    - `agriva_decisions_log.md`
    - tous les fichiers `agriva_v1_*.md`
    - `agriva_agents_roles.md`

Rôle :

- vérifier la cohérence globale, fusionner les apports, générer les scénarios de test.

Sortie attendue :

- synthèse consolidée + patchs doc + scénarios QA.

***

## Flux de travail recommandé

1. **Core Design** fixe les garde-fous.
2. **Systems Farming** produit les systèmes de base.
3. **Economy/Markets** équilibre tout ce qui touche aux flux.
4. **UI/UX** transforme ça en écrans et parcours.
5. **Social/Meta** ajoute les couches transverses.
6. **Tech/LiveOps** verrouille la faisabilité technique.
7. **Doc/QA** contrôle et consolide.

***

## Format standard de sortie attendu

Je te recommande de faire produire par chaque agent une sortie avec cette structure :

```yaml
type: <spec_system | ui_specs | balancing_notes | social_specs | tech_nonfunc_plan>
agent_id: <id>
status: draft|reviewed|approved
context_refs:
  - fichier1
  - fichier2
summary: >
  Résumé court du choix principal.
details:
  ...
open_questions:
  - ...
decision_refs:
  - ...
```


***

## Règles d’intégration

- Une seule source de vérité pour les décisions : `agriva_decisions_log.md`.
- Le document long sert de base de référence complète.
- Les fichiers `agriva_v1_*.md` servent de contextes courts par agent.
- Chaque agent ne doit modifier qu’un périmètre précis.
- Le validateur final doit refuser toute contradiction avec les choix V1 déjà figés.

***

## Implémentation pratique

Si tu veux industrialiser ça, la séquence minimale est :

1. Charger `manifest.json`.
2. Charger `agriva_agents_roles.md`.
3. Mapper chaque `agent_id` à un modèle.
4. Envoyer les docs de contexte propres à chaque agent.
5. Récupérer les sorties JSON/YAML.
6. Passer toutes les sorties dans `doc-qa-synth`.
7. Si validé, écrire dans :
    - `agriva_decisions_log.md`
    - `agriva_document_complet_long.md`

***

## Recommandation d’ordre réel

Pour aller vite sans te disperser :

- **Round 1** : core-design + economy-markets + systems-farming.
- **Round 2** : ui-onboarding + social-meta.
- **Round 3** : tech-liveops + doc-qa-synth.

C’est l’ordre le plus efficace pour un premier cycle de production.

Souhaites-tu maintenant un **exemple concret de message standard rempli** pour un cas réel, par exemple `spec_system` sur **Grandes cultures V1** ?