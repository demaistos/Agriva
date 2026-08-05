# Sprint 01 — Auth + Shell UI — End to End

> Objectif : Un joueur s'inscrit, se connecte, voit un shell d'application vide.

---

## Flows couverts

Aucun flow du registry (les flows commencent au sprint 03). Ce sprint pose les fondations techniques.

---

## Backend

### Routes API

| Méthode | Route | Body | Réponse | Sécurité |
|---------|-------|------|---------|----------|
| POST | /api/auth/register | `{ email, password, username }` | 201 `{ player_id }` | Rate limit 5/min IP, bcrypt 12 |
| POST | /api/auth/login | `{ email, password }` | 200 `{ access_token, player }` | JWT 15min, refresh 7j httpOnly |
| POST | /api/auth/refresh | Cookie refresh_token | 200 `{ access_token }` | Rotation token |
| POST | /api/auth/logout | — | 204 | Révoque refresh |
| GET | /api/player/me | — | 200 `{ id, username, email, created_at }` | Auth JWT |

### Middleware

- `authMiddleware` : vérifie JWT, injecte `req.player`
- `idempotencyMiddleware` : check `X-Idempotency-Key` header, cache Redis 24h
- `rateLimitMiddleware` : 100/min IP, 30/min user
- `ownershipMiddleware` : vérifie que la ressource appartient au joueur

### DB — Migrations

```sql
-- Tables : account, player, server, refresh_token, idempotency_key
-- Voir DATA_MODEL §1.1, §1.2, §1.3
```

### Validation

- Email : format valide, unique par serveur
- Password : min 8 chars, 1 majuscule, 1 chiffre
- Username : 3-20 chars, alphanumérique + tirets

---

## Frontend

### Pages

| Route | Composant | Description |
|-------|-----------|-------------|
| /register | RegisterPage | Formulaire inscription (email, username, password, confirm) |
| /login | LoginPage | Formulaire connexion (email, password) |
| /dashboard | DashboardPage | Shell vide avec message bienvenue |

### Layout

- Header : logo Cultivia, pseudo joueur, bouton déconnexion
- Sidebar : vide (liens ajoutés sprint par sprint)
- Contenu : zone principale

### Store Pinia

- `useAuthStore` : token, player, login(), logout(), refresh()

### Router Guard

- Routes protégées → redirect `/login` si pas de token
- `/register` et `/login` → redirect `/dashboard` si déjà connecté

---

## Testable UI

1. Le joueur ouvre `/register`
2. Il saisit email, username, mot de passe
3. Il clique « S'inscrire » → toast « Compte créé ! »
4. Il est redirigé vers `/login`
5. Il saisit email + mot de passe → toast « Bienvenue {username} ! »
6. Il voit le dashboard vide avec « Bienvenue sur Cultivia ! »
7. Il clique « Déconnexion » → retour `/login`

---

## Tests

- GIVEN valid email+password WHEN register THEN 201 + player created
- GIVEN existing email WHEN register THEN 409 AUTH_EMAIL_EXISTS
- GIVEN valid credentials WHEN login THEN 200 + JWT + refresh cookie
- GIVEN wrong password WHEN login THEN 401 AUTH_INVALID_CREDENTIALS
- GIVEN expired JWT WHEN /api/player/me THEN 401 AUTH_TOKEN_EXPIRED
- GIVEN valid refresh WHEN /api/auth/refresh THEN 200 + new JWT
- GIVEN revoked refresh WHEN /api/auth/refresh THEN 401 AUTH_REFRESH_REVOKED
