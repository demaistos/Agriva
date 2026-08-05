# 🌾 Scripts de Seed — Cultivia

> Peuplement initial de la base de données au premier lancement.

## Ordre d'exécution

Les fichiers doivent être exécutés **dans l'ordre numérique** (dépendances FK) :

| # | Fichier | Description | Lignes estimées |
|---|---------|-------------|-----------------|
| 01 | `01_server.sql` | Serveur France unique (paramètres économiques) | 1 |
| 02 | `02_regions_departments.sql` | 13 régions métropolitaines + 96 départements | ~110 |
| 03 | `03_prefectures.sql` | ~340 préfectures et sous-préfectures (GPS réel) | ~340 |
| 04 | `04_building_types.sql` | Types de bâtiments et accessoires | ~30 |
| 05 | `05_vehicle_types.sql` | Catalogue matériels agricoles (marques réelles) | ~60 |
| 06 | `06_crop_types.sql` | Cultures avec dates, prix, rotations | ~25 |
| 07 | `07_crop_yields.sql` | Rendements par culture × région | ~500 |
| 08 | `08_crop_nutrients.sql` | Besoins NPK par culture | ~30 |
| 09 | `09_animal_breeds.sql` | Races réelles par espèce | ~130 |
| 10 | `10_animal_rations.sql` | Rations INRAE par espèce × âge | ~100 |
| 11 | `11_base_prices.sql` | Prix de référence Marché Central | ~50 |
| 12 | `12_starter_kits.sql` | 3 kits de démarrage (matériel réel) | ~40 |

## Exécution

```bash
# Exécution complète (dans l'ordre)
for f in scripts/seed/[0-9]*.sql; do
  echo "→ $f"
  psql "$DATABASE_URL" -f "$f"
done

# Ou via Docker
docker compose exec postgres psql -U cultivia -d cultivia -f /seed/01_server.sql
```

## Conventions

- **Prix calibrés** pour l'économie Cultivia (solde initial 100k€, 40 HT/jour)
- **Marques réelles** de matériels agricoles (John Deere, Claas, New Holland, etc.)
- **Races réelles** d'animaux (sources INRAE, Institut de l'Élevage)
- **Rendements réels** par région (sources Agreste/FranceAgriMer)
- **Coordonnées GPS** arrondies à 2 décimales (sources INSEE/IGN)
- Chaque fichier est idempotent (`INSERT ... ON CONFLICT DO NOTHING` ou `TRUNCATE` préalable)

## Sources

- Agreste (Ministère de l'Agriculture) — rendements régionaux
- FranceAgriMer — prix de référence
- INRAE — rations animales
- INSEE/IGN — coordonnées préfectures
- SAFER — prix foncier par département
- Institut de l'Élevage — races et performances
