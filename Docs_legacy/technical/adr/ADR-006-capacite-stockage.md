# ADR-006 — Capacité de stockage et contrainte structurante

**Date** : 2026-05-07  
**Statut** : Accepté  
**Décideurs** : Lead, Tech

## Contexte

Le stockage est une contrainte V1 figée (decisions log : "Contrainte moyenne structurante"). Le joueur récolte des produits (céréales, lait, légumes, viande) et doit les stocker avant de les vendre ou de les transformer. La capacité de stockage doit être une vraie contrainte de décision — pas un détail technique transparent.

Trois approches ont été évaluées pour modéliser cette contrainte.

## Options considérées

### Option A — Capacité par type (sec / froid / vrac / bétail) avec limites dures

Chaque ferme dispose de silos distincts par catégorie de produit. Un stock de céréales plein ne bloque pas le stockage de légumes. Les bâtiments de stockage sont typés.

- ✅ Réaliste agronomiquement
- ✅ Crée des décisions d'investissement différenciées (construire un frigo vs un silo)
- ✅ Cohérent avec les 3 chaînes de transformation (lait→laiterie, céréales→meunerie, légumes→conserverie)
- ❌ Complexité de modélisation et d'UI plus élevée
- ❌ Risque de frustration si le joueur ne comprend pas pourquoi il ne peut pas stocker

### Option B — Système de slots flexible

Chaque ferme a un nombre de slots génériques. Chaque produit occupe N slots selon son volume. Le joueur peut stocker n'importe quoi tant qu'il a des slots libres.

- ✅ Simple à implémenter et à comprendre
- ✅ Flexible pour les nouvelles activités V2+
- ❌ Pas réaliste (on ne stocke pas du lait et du blé dans le même espace)
- ❌ Efface une vraie décision de jeu (spécialisation du stockage)
- ❌ Contradictoire avec la logique de transformation par bâtiment

### Option C — Capacité globale avec multiplicateurs

Une capacité totale en unités abstraites, avec des multiplicateurs par type de produit (ex. : le lait compte double car il est périssable et volumineux).

- ✅ Simple à modéliser
- ❌ Opaque pour le joueur (pourquoi le lait compte-t-il double ?)
- ❌ Crée des comportements contre-intuitifs
- ❌ Ne reflète pas les investissements réels en bâtiments

## Décision

**Option A — Capacité par type avec limites dures.**

Quatre catégories de stockage, chacune avec une `capacity_max` indépendante :

| Catégorie | Produits concernés | Bâtiment associé |
|-----------|-------------------|-----------------|
| `sec` | Céréales, graines, farine | Silo / grange |
| `froid` | Lait, légumes frais, œufs | Chambre froide |
| `vrac` | Betterave, pomme de terre, fourrage | Hangar vrac |
| `betail` | Animaux vivants (comptés en têtes) | Bâtiment d'élevage |

Le modèle `Stock` existant est étendu avec un champ `storage_type: enum(sec|froid|vrac|betail)`. La `capacity_max` est portée par le bâtiment de stockage associé à la ferme, pas par la ferme elle-même.

En mode Normal, l'UI affiche une jauge par catégorie. En mode Expert, le détail par produit est accessible.

## Conséquences

**Positives :**
- Crée de vraies décisions d'investissement (construire un frigo pour se lancer dans le maraîchage)
- Cohérent avec les chaînes de transformation existantes
- La contrainte est lisible et prévisible pour le joueur
- Facilite l'équilibrage : on peut ajuster la capacité par type indépendamment

**Négatives / points de vigilance :**
- L'UI doit afficher clairement quelle catégorie est pleine lors d'un blocage de récolte
- Les migrations BDD doivent ajouter `storage_type` à la table `Stock` et créer une table `StorageBuilding`
- Les activités V2+ (viticulture, arboriculture) devront définir leur catégorie de stockage dès leur conception

**Règle de blocage** : si `quantity + récolte_entrante > capacity_max` pour la catégorie concernée, la récolte est bloquée avec un message d'erreur explicite. Pas de dépassement silencieux.

## Références

- `agriva_decisions_log_compact.md` — "Stockage : Contrainte moyenne structurante"
- `2026-05-07-plan-implementation-v1.md` — §1.3 entité `Stock`, §Sprint 3 livrables
- `2026-05-07-tech-liveops-v1.md` — §1 tick séquence 5 (dégradation stocks)
