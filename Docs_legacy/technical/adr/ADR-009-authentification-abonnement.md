# ADR-009 — Authentification (JWT)
> **Note** : La partie abonnement Stripe est reportée en POST-V1. Cet ADR couvre uniquement l'authentification JWT pour Sprint 1.



**Date** : 2026-05-07  
**Statut** : Accepté
**Environnement** : Dev local Docker Compose  
**Décideurs** : Lead, Tech

## Contexte

Le jeu propose un abonnement confort mensuel/annuel via Stripe (Sprint 6). Les features abonnés (tableaux de bord avancés, alertes personnalisées, historique complet) doivent être vérifiées à chaque requête pertinente. La stack retenue dans le plan d'implémentation est JWT + Stripe, mais le mécanisme de vérification du statut d'abonnement n'est pas encore tranché.

## Options considérées

### Option A — JWT stateless + webhook Stripe (`stripe listen --forward-to localhost:3000/webhooks/stripe` en dev local)

Le JWT contient le `user_id` et le `subscription_status` (claim). Stripe envoie des webhooks (`customer.subscription.updated`, `invoice.payment_failed`) qui mettent à jour le flag `subscription_status` en base. Le JWT est re-signé à chaque refresh (toutes les 15 min) avec le statut à jour.

- ✅ Stateless : pas de lookup BDD à chaque requête
- ✅ Simple à implémenter avec la stack JWT déjà retenue (ADR implicite Sprint 1)
- ✅ Le refresh token force la mise à jour du statut toutes les 15 min maximum
- ❌ Fenêtre de désynchronisation de 15 min max (abonnement annulé mais JWT encore valide)
- ❌ Le claim `subscription_status` dans le JWT doit être vérifié côté serveur pour les actions sensibles

### Option B — Session serveur + Stripe Customer Portal

Sessions stockées en Redis. Le statut d'abonnement est vérifié en base à chaque requête sur les endpoints abonnés.

- ✅ Statut toujours à jour (lookup Redis synchrone)
- ✅ Révocation immédiate possible
- ❌ Dépendance Redis pour chaque requête authentifiée (déjà présent dans la stack, mais couplage fort)
- ❌ Abandonne le JWT déjà décidé pour Sprint 1 — refactoring coûteux
- ❌ Scalabilité horizontale plus complexe (sessions partagées)

### Option C — OAuth2 tiers (Auth0) — **écarté** : dépendance externe inutile en dev local + Stripe

Délégation de l'auth à Auth0. Le statut Stripe est synchronisé via webhook dans les métadonnées Auth0.

- ✅ Auth robuste et maintenue par un tiers
- ❌ Coût mensuel (Auth0 : gratuit jusqu'à 7 500 MAU, puis $23+/mois)
- ❌ Dépendance externe critique pour l'auth — si Auth0 est indisponible, le jeu est inaccessible
- ❌ Complexité d'intégration disproportionnée pour un petit studio
- ❌ Données d'authentification chez un tiers (RGPD)

## Décision

**Option A — JWT stateless + webhook Stripe (`stripe listen --forward-to localhost:3000/webhooks/stripe` en dev local)**, avec un flag `subscription_status` en base mis à jour par les webhooks.

### Mécanisme retenu

**JWT** : access token (15 min) + refresh token (30 jours, stocké en base pour révocation). Le JWT contient uniquement `user_id` et `role` — pas le `subscription_status` (évite la désynchronisation).

**Vérification abonnement** : le `subscription_status` est lu depuis **Redis** (TTL 5 min, invalidé par webhook). Si absent du cache, lookup en base PostgreSQL. Ce n'est pas un lookup à chaque requête — uniquement sur les endpoints qui exposent des features abonnés.

```
Requête → Middleware JWT (vérifie signature) → Si endpoint abonné : Redis.get(sub_status:user_id) → Autoriser/Refuser
```

**Webhooks Stripe** à gérer :
| Événement | Action |
|-----------|--------|
| `customer.subscription.created` | `subscription_status = active`, invalider cache Redis |
| `customer.subscription.updated` | Mettre à jour statut + dates, invalider cache |
| `invoice.payment_succeeded` | Confirmer renouvellement |
| `invoice.payment_failed` | `subscription_status = past_due`, invalider cache |
| `customer.subscription.deleted` | `subscription_status = expired`, invalider cache |

**Idempotence** : chaque webhook est traité une seule fois (vérification `stripe_event_id` en base).

**Sécurité webhook** : vérification de la signature Stripe (`stripe-signature` header) avant tout traitement.

## Conséquences

**Positives :**
- Cohérent avec la stack JWT déjà décidée pour Sprint 1 — pas de refactoring
- La fenêtre de désynchronisation est ≤ 5 min (TTL Redis) — acceptable pour un abonnement confort non critique
- Redis est déjà dans la stack (cache, sessions) — pas de nouvelle dépendance
- Révocation possible en supprimant le refresh token de la base

**Négatives / points de vigilance :**
- Si un webhook Stripe (`stripe listen --forward-to localhost:3000/webhooks/stripe` en dev local) est manqué (réseau), le statut peut rester incorrect. Mitigation : job de réconciliation quotidien qui appelle l'API Stripe pour vérifier les abonnements actifs.
- Le Stripe Customer Portal (gestion des abonnements côté joueur) doit être intégré en Sprint 6 — générer une session portal via `stripe.billingPortal.sessions.create()`.
- Ne pas stocker le `subscription_status` dans le JWT — le claim serait trop long à invalider en cas d'annulation.

## Références

- `2026-05-07-plan-implementation-v1.md` — §1.1 stack (Auth : JWT, Paiement : Stripe), §Sprint 6 (abonnement Stripe)
- `2026-05-07-tech-liveops-v1.md` — §3 paramètres admin (log des changements avec `admin_id`)
- `agriva_decisions_log_compact.md` — "Monétisation : abonnement confort (Stripe)"
