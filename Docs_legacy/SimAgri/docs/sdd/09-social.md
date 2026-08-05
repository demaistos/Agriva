# SDD 09 — Module Social (Forum, Messagerie, CFSA, Classements)

## 1. Amis

### Table
```sql
friendships (
  id          UUID PRIMARY KEY,
  player_a    UUID REFERENCES players,
  player_b    UUID REFERENCES players,
  is_privileged BOOLEAN DEFAULT FALSE,  -- ami privilégié (vente directe)
  created_at  TIMESTAMP DEFAULT NOW(),
  UNIQUE(player_a, player_b)
)
```

---

## 2. Messagerie

### Tables
```sql
messages (
  id          UUID PRIMARY KEY,
  from_id     UUID REFERENCES players,
  to_id       UUID REFERENCES players,
  subject     VARCHAR,
  body        TEXT,
  is_read     BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMP DEFAULT NOW()
)
```

### MP-Live (temps réel via WebSocket)
- Chat en direct entre joueurs connectés
- Canaux : privé (1-1), régional, serveur

---

## 3. Forum

### Tables
```sql
forum_categories (
  id    SERIAL PRIMARY KEY,
  name  VARCHAR NOT NULL,
  server_id INT REFERENCES servers
)

forum_topics (
  id          UUID PRIMARY KEY,
  category_id INT REFERENCES forum_categories,
  author_id   UUID REFERENCES players,
  title       VARCHAR NOT NULL,
  is_pinned   BOOLEAN DEFAULT FALSE,
  created_at  TIMESTAMP DEFAULT NOW()
)

forum_posts (
  id        UUID PRIMARY KEY,
  topic_id  UUID REFERENCES forum_topics,
  author_id UUID REFERENCES players,
  body      TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
)
```

---

## 4. CFSA (Centre de Formation)

### Table
```sql
cfsa_formations (
  id              UUID PRIMARY KEY,
  trainee_id      UUID REFERENCES players,  -- stagiaire (< 14 jours ancienneté)
  mentor_id       UUID REFERENCES players,  -- maître-exploitant (168+ jours)
  started_at      DATE,
  ends_at         DATE,  -- +42 jours
  status          VARCHAR DEFAULT 'active',  -- 'active','completed','cancelled'
  trainee_bonus   BOOLEAN DEFAULT FALSE,  -- +4 jours SimPass + 25000€ aide
  mentor_bonus    BOOLEAN DEFAULT FALSE   -- +4 jours SimPass
)
```

### Règles
- Stagiaire : demande dans les 14 premiers jours
- Maître : ancienneté min 168 jours, max stagiaires selon ancienneté (1-5)
- Durée : 42 jours
- Bonus si SimPass activé avant fin formation

---

## 5. Classements

### Vue calculée
```sql
CREATE VIEW rankings AS
SELECT
  p.id,
  p.name,
  p.server_id,
  p.balance + p.savings as wealth,
  (SELECT COUNT(*) FROM animals WHERE player_id = p.id) as animal_count,
  (SELECT SUM(size_ha) FROM parcels WHERE player_id = p.id) as total_ha,
  (SELECT COUNT(*) FROM buildings WHERE player_id = p.id) as building_count
FROM players p
ORDER BY wealth DESC;
```

### Types de classements
- Richesse (balance + épargne + valeur patrimoine)
- Surface cultivée
- Nombre d'animaux
- Production lait
- Génétique (meilleurs indices)

---

## 6. Concours animaux / GénétiSim

### Table
```sql
animal_contests (
  id          UUID PRIMARY KEY,
  server_id   INT REFERENCES servers,
  species     VARCHAR NOT NULL,
  race        VARCHAR,
  game_day    INT,
  status      VARCHAR DEFAULT 'open'  -- 'open','judging','closed'
)

contest_entries (
  id          UUID PRIMARY KEY,
  contest_id  UUID REFERENCES animal_contests,
  animal_id   UUID REFERENCES animals,
  player_id   UUID REFERENCES players,
  score       DECIMAL(8,2),
  rank        INT
)
```

### Scoring
Basé sur indices génétiques, poids, morphologie, production lait.

---

## 7. CESA (Conseil Économique)

Organe de régulation du serveur :
- Fixe certains prix (miscanthus, luzerne...)
- Aide financière aux nouveaux joueurs (25 000€ post-formation)
- Arbitrage litiges

---

## 8. Salons et événements

### Salons
- **GénétiSim** : salon génétique animale, concours
- **VitiSim** : salon viticole
- **GénétiVRAD** : salon IVRAD

### Événements in-game
```sql
events (
  id          UUID PRIMARY KEY,
  server_id   INT REFERENCES servers,
  type        VARCHAR NOT NULL,
  title       VARCHAR,
  start_date  DATE,
  end_date    DATE,
  rewards     JSONB
)
```

---

## 9. Badges

```sql
badges (
  id          SERIAL PRIMARY KEY,
  slug        VARCHAR UNIQUE NOT NULL,
  name        VARCHAR NOT NULL,
  description TEXT,
  icon        VARCHAR
)

player_badges (
  player_id   UUID REFERENCES players,
  badge_id    INT REFERENCES badges,
  earned_at   TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (player_id, badge_id)
)
```

---

## 10. Sondages

```sql
polls (
  id          UUID PRIMARY KEY,
  server_id   INT REFERENCES servers,
  question    TEXT NOT NULL,
  options     JSONB NOT NULL,
  created_at  TIMESTAMP DEFAULT NOW(),
  closes_at   TIMESTAMP
)

poll_votes (
  poll_id     UUID REFERENCES polls,
  player_id   UUID REFERENCES players,
  option_idx  INT NOT NULL,
  PRIMARY KEY (poll_id, player_id)
)
```

---

## 11. Profil joueur

- **Fiche présentation** : texte libre, photo, statistiques publiques
- **Carte ISO** : carte d'identité virtuelle du joueur
- **Disponibilité** : statut en ligne/hors ligne/occupé
- **Favoris** : joueurs, animaux, matériels favoris
- **Préférences notifications** : configurable par type d'événement
- **Préférences activité** : choix des activités principales affichées

---

## 12. Challenges

```sql
challenges (
  id          UUID PRIMARY KEY,
  server_id   INT REFERENCES servers,
  title       VARCHAR NOT NULL,
  description TEXT,
  criteria    JSONB,
  start_date  DATE,
  end_date    DATE,
  rewards     JSONB
)

challenge_participants (
  challenge_id UUID REFERENCES challenges,
  player_id    UUID REFERENCES players,
  score        DECIMAL(12,2) DEFAULT 0,
  rank         INT,
  PRIMARY KEY (challenge_id, player_id)
)
```
