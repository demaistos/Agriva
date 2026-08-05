# SDD 10 — Monétisation (SimPass, Packs, Options)

## 1. SimPass

### Table
```sql
simpass (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  activated_at DATE,
  expires_at  DATE,  -- +84 jours (1 saison)
  bonus_days  INT DEFAULT 0  -- jours bonus (CFSA, parrainage...)
)
```

### Fonctionnalités débloquées
- Activités annexes (concessionnaire, CIA, CAR...)
- Statistiques avancées
- Options de jeu supplémentaires
- Pas de publicité

### Prix : ~2€ / trimestre (84 jours)

---

## 2. Packs & Options

### Table
```sql
player_options (
  id          UUID PRIMARY KEY,
  player_id   UUID REFERENCES players,
  option_type VARCHAR NOT NULL,
  activated_at DATE,
  expires_at  DATE
)
```

### Types d'options
Bonus cosmétiques ou de confort (pas de pay-to-win agressif).

---

## 3. Parrainage

### Table
```sql
referrals (
  id          UUID PRIMARY KEY,
  referrer_id UUID REFERENCES players,
  referee_id  UUID REFERENCES players,
  bonus_given BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMP DEFAULT NOW()
)
```

Bonus SimPass pour le parrain quand le filleul s'inscrit et active son SimPass.
