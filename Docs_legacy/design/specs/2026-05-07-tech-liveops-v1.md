# Agriva — Plan Technique & LiveOps V1

> Date : 2026-05-07  
> Statut : Draft V1  
> Sources : `agriva_split_tech_liveops.md` (§56–62, 72), `agriva_decisions_log_compact.md`  
> Contexte : Petit studio. Pragmatisme avant exhaustivité. Tout ce qui dépasse V1 est marqué **V2+**.

---

## 1. Télémétrie minimale

Niveau retenu : **moyen** (§57.1-B) — rétention, progression, points de friction, économie.  
Utilisation : ajustements réguliers d'équilibrage (§57.2-B).

### Événements à logger

| Événement | Payload minimal | Fréquence |
|-----------|----------------|-----------|
| `session_start` | `user_id`, `platform`, `game_day`, `timestamp` | Chaque connexion |
| `session_end` | `user_id`, `duration_s`, `game_day` | Chaque déconnexion |
| `tick_completed` | `game_day`, `server_ms`, `player_count_active` | 1×/jour (tick quotidien) |
| `transaction_market` | `user_id`, `product`, `qty`, `price`, `side` (buy/sell), `counterpart` (bot/player) | Chaque transaction |
| `price_bot_updated` | `product`, `old_price`, `new_price`, `trigger` (admin/auto) | À chaque changement |
| `activity_started` | `user_id`, `activity_type`, `parcel_id`, `game_day` | Chaque démarrage d'activité |
| `activity_completed` | `user_id`, `activity_type`, `yield_actual`, `yield_expected`, `game_day` | Chaque fin d'activité |
| `progression_unlock` | `user_id`, `unlock_type` (agrandissement/spécialisation/diversification), `game_day` | À chaque déblocage |
| `onboarding_step` | `user_id`, `step_id`, `completed` (bool), `time_on_step_s` | Chaque étape onboarding |
| `friction_event` | `user_id`, `screen`, `action_attempted`, `error_code` | Sur erreur/blocage |
| `aid_received` | `user_id`, `aid_type`, `amount`, `trigger` | Chaque aide déclenchée |
| `difficulty_changed` | `user_id`, `preset_from`, `preset_to`, `game_day` | À chaque changement |
| `mode_toggle` | `user_id`, `system`, `mode` (normal/expert) | À chaque bascule |

**Non loggé en V1** (V2+) : parcours détaillés par écran, comportements par profil, A/B testing, replay de sessions.

### Stockage & rétention

- Logs bruts : rétention 90 jours, puis agrégats mensuels conservés.
- Volume estimé : ~50 événements/joueur actif/jour → négligeable jusqu'à ~10 000 joueurs actifs.
- Format : JSON structuré, envoi batch toutes les 5 min ou à `session_end`.

---

## 2. Contraintes de performance

Décisions retenues : plateforme B (navigateur + mobile responsive, §56.1), machines modestes (§56.2-A), résolutions batch uniquement (§56.3-A), latence modérée tolérée (§56.4-A).

### Tick quotidien

- **1 tick/jour de jeu** = 1 résolution batch côté serveur.
- Déclenché à heure fixe (ex. 02h00 UTC) ou à la connexion du joueur si le jour est écoulé (mode asynchrone).
- Contenu du tick : calcul météo, rendements, prix bots, dégradation stocks, progression des activités en cours, déclenchement des aides automatiques.
- **Durée cible** : < 500 ms par joueur traité ; traitement séquentiel par batch de 100 joueurs.

### Charge serveur estimée

| Phase | Joueurs actifs | Tick (pic) | Requêtes/s (hors tick) |
|-------|---------------|------------|------------------------|
| Alpha interne | < 50 | < 1 s total | < 5 req/s |
| Bêta fermée | 200–500 | < 10 s total | < 50 req/s |
| V1 launch | 1 000–3 000 | < 60 s total | < 200 req/s |

→ Un seul serveur applicatif suffit jusqu'à ~3 000 joueurs actifs simultanés avec ce modèle asynchrone.  
→ Mise à l'échelle horizontale : **V2+**.

### Latences cibles (hors tick)

| Action | Cible P95 |
|--------|-----------|
| Chargement écran principal | < 2 s |
| Action marché (achat/vente) | < 500 ms |
| Consultation prix/stats | < 300 ms |
| Sauvegarde d'une décision | < 200 ms |

### Cible matérielle joueur

- Navigateur desktop : Chrome/Firefox/Edge, 2 ans d'ancienneté minimum.
- Mobile : responsive, pas d'app native. Résolution minimale 375 px.
- Pas de WebGL requis, pas de client lourd.

---

## 3. Outils d'admin

Niveau retenu : tableurs + simulateurs dédiés (§57.3-B), avec un dashboard interne léger.

### Dashboard d'équilibrage (interne)

Interface web admin (accès restreint équipe), couvrant :

**Vue économie en temps réel**
- Prix bots actuels par produit vs. prix joueurs (spread visible)
- Volume de transactions des 7 derniers jours par produit
- Taux d'utilisation du bot (% transactions bot vs. joueur)
- Alerte si un produit dépasse le seuil de dominance bot (> 60 % des transactions)

**Vue joueurs**
- DAU / WAU / MAU
- Distribution des joueurs par stade de progression
- Taux de complétion onboarding
- Joueurs ayant reçu une aide dans les 7 derniers jours (%)

**Vue santé serveur**
- Durée du dernier tick
- Erreurs applicatives (count/heure)
- Latence P95 des 24 dernières heures

### Paramètres ajustables à chaud (sans redéploiement)

Stockés en base de données, modifiables via le dashboard admin :

| Paramètre | Type | Plage V1 | Description |
|-----------|------|----------|-------------|
| `bot_price[product]` | float | ±30 % du prix de référence | Prix d'achat/vente du bot par produit |
| `bot_spread[product]` | float | 15–25 % | Écart bid/ask du bot |
| `risk_intensity[region]` | float | 0.5–1.5 | Multiplicateur d'intensité des événements météo/risques par région |
| `aid_threshold_cash` | float | 0–500 | Seuil de trésorerie déclenchant l'aide automatique |
| `aid_amount_cash` | float | 0–200 | Montant de l'aide d'urgence |
| `aid_threshold_yield` | float | 0–0.5 | Seuil de rendement (ratio réel/attendu) déclenchant l'aide automatique en mode Facile. Ex. : 0.4 = aide si rendement < 40 % du potentiel. Documenté dans social-meta-v1.md §3.2 (modificateurs difficulté). |
| `event_calendar_active` | bool | — | Active/désactive les événements saisonniers |
| `onboarding_enabled` | bool | — | Active/désactive les missions d'onboarding |
| `difficulty_preset_default` | enum | facile/standard/exigeant | Preset par défaut pour les nouveaux joueurs |

**Règle de sécurité** : tout changement de paramètre est loggé avec `admin_id`, `timestamp`, `old_value`, `new_value`. Pas de rollback automatique en V1 — rollback manuel via le dashboard.

**V2+** : historique des changements avec graphe d'impact, rollback en 1 clic, paramètres par segment de joueurs.

---

## 4. Stratégie d'équilibrage

Rythme retenu : régulier par mise à jour majeure (§57.4-B), changements modérés avec phases de test (§58.4-B).

### Fréquence

| Type d'ajustement | Fréquence | Déclencheur |
|-------------------|-----------|-------------|
| Prix bots (micro) | Hebdomadaire max | Dashboard : spread anormal ou volume bot > 60 % |
| Paramètres de risque | Par patch (2–4 semaines) | Retours bêta + métriques friction |
| Niveaux d'aide | Par patch | Taux de joueurs en difficulté > 20 % ou < 5 % |
| Équilibrage systémique | Par mise à jour majeure (trimestriel) | Analyse complète économie + progression |

### Amplitude maximale des ajustements

- **Prix bots** : ±10 % par semaine, ±30 % cumulé entre deux mises à jour majeures.
- **Risk intensity** : ±0.2 par patch (plage 0.5–1.5).
- **Seuils d'aide** : ±20 % par patch.
- Règle : aucun ajustement ne doit rendre une stratégie précédemment viable soudainement non viable sans préavis.

### Processus de décision

1. **Observation** : dashboard hebdomadaire, lecture des métriques clés (prix, volumes, progression, aides).
2. **Diagnostic** : identifier si le problème est systémique (règle) ou paramétrique (valeur).
3. **Proposition** : changement de paramètre à chaud (si mineur) ou patch planifié (si structurel).
4. **Test** : sur environnement de staging avec simulation de 100 joueurs-types (tableur).
5. **Déploiement** : changement à chaud via dashboard ou déploiement de patch.
6. **Suivi** : vérification des métriques 48h après le changement.

**Principe directeur** : le bot est un filet de sécurité, jamais une source d'arbitrage profitable pour le joueur. Tout ajustement qui crée un arbitrage bot/joueur est bloquant.

---

## 5. Plan de releases

Stratégie QA retenue : tests internes + petit groupe de bêta (§61.1-B). Rythme de test à chaque jalon majeur (§61.3-B).

### Jalons

#### Alpha interne — Critères d'entrée : build jouable de bout en bout
- **Durée** : 4–6 semaines
- **Périmètre** : boucle principale (Observer→Vendre), grandes cultures uniquement, 1 région, bot fonctionnel, tick quotidien, UI desktop uniquement
- **Équipe** : studio uniquement (< 10 personnes)
- **Critères de passage** :
  - Tick s'exécute sans erreur 7 jours consécutifs
  - Boucle complète jouable sans bug bloquant
  - Aucun arbitrage bot détecté
  - Dashboard admin opérationnel

#### Bêta fermée — Critères d'entrée : alpha validée
- **Durée** : 6–8 semaines
- **Périmètre** : grandes cultures + élevage + maraîchage, 3 régions, mobile responsive, onboarding, tous les presets de difficulté, télémétrie active
- **Équipe** : studio + 50–150 joueurs invités
- **Critères de passage** :
  - Rétention J7 ≥ 30 %
  - Taux de complétion onboarding ≥ 60 % (définition : joueur ayant complété les missions 1 à 4 de la séquence d'onboarding (jusqu'à "Première vente" incluse — mission 4 selon ui-onboarding-v1.md §7))
  - Aucun bug bloquant ouvert
  - Latence P95 dans les cibles (§2)
  - Au moins 1 cycle d'équilibrage effectué sur données réelles

#### V1 — Critères d'entrée : bêta fermée validée
- **Durée** : release publique
- **Périmètre** : toutes les activités V1 (§decisions log), 6 régions, classements saisonniers, succès, messagerie limitée, monétisation cosmétiques
- **Critères de passage** :
  - Rétention J30 ≥ 20 %
  - Aucun bug critique ouvert depuis 2 semaines
  - Infrastructure tient 1 000 joueurs actifs simultanés
  - Documentation GDD + docs par système à jour (§62.1-B)

#### Premières mises à jour post-V1
- **Patch 1.1** (2–3 semaines post-launch) : corrections bugs, premiers ajustements d'équilibrage sur données réelles
- **Patch 1.2** (6 semaines post-launch) : contenu événementiel (calendrier fixe), ajustements économie
- **Mise à jour 1.x trimestrielle** : nouvelles activités mineures, équilibrage systémique, contenu cosmétique

**V2+** : saisons structurées, nouveaux modes, prestataires joueurs, viticulture/arboriculture/forêt, API lecture seule.

---

## 6. Compatibilité

Décision retenue : navigateur + mobile responsive (§56.1-B), pas de client lourd en V1.

### Navigateurs supportés (V1)

| Navigateur | Version minimale | Priorité |
|------------|-----------------|----------|
| Chrome / Chromium | N-2 | Principale |
| Firefox | N-2 | Principale |
| Edge | N-2 | Principale |
| Safari (iOS/macOS) | N-1 | Secondaire |
| Samsung Internet | N-1 | Secondaire |

### Mobile responsive

- Breakpoints : 375 px (mobile), 768 px (tablette), 1024 px+ (desktop).
- UI synthétique avec détails sur demande (§decisions log) : particulièrement important sur mobile.
- Pas d'app native en V1. Pas de PWA obligatoire (V2+).
- Touch targets ≥ 44 px.
- Pas de hover-only interactions sur les éléments critiques.

### Ce qui n'est pas supporté en V1

- Client lourd (Electron, Unity WebGL, etc.)
- WebGL / Canvas avancé
- Notifications push natives
- Mode hors-ligne
- App stores (V2+)

---

## Récapitulatif des décisions V2+

| Sujet | Reporté à V2+ |
|-------|--------------|
| Télémétrie | Parcours détaillés, A/B testing, replay sessions |
| Infrastructure | Mise à l'échelle horizontale automatique |
| Admin | Rollback en 1 clic, paramètres par segment |
| Activités | Viticulture, arboriculture, forêt |
| Services | Prestataires joueurs |
| Logistique | Flux fins |
| Modding | API lecture seule, sandbox |
| Social | Chat global, classements publics |
| Mobile | App native, PWA, notifications push |
| Modes | Modes alternatifs (multijoueur structuré, etc.) |
