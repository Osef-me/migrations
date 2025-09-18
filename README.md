# Database Migrations

This directory contains database migration files for the osu! backend rewrite project. This is a **git submodule** that manages the database schema and structure.

## Overview

The migrations are organized chronologically and cover the following main areas:

- **User Management**: Users, device tokens, bans, and registration validation
- **Beatmap System**: Beatmapsets, beatmaps, and difficulty rates
- **Scoring System**: Scores, replays, and score metadata
- **Rating System**: Performance ratings and mania-specific ratings
- **Weekly Events**: Weekly competitions, pools, and participant tracking

## Migration Files

| File | Description | Tables Created |
|------|-------------|----------------|
| `20250918124221_failed_query.sql` | Failed query tracking | `failed_query` |
| `20250918124247_beatmapset.sql` | Beatmap collections | `beatmapset` |
| `20250918124259_beatmap.sql` | Individual beatmaps | `beatmap` |
| `20250918124404_rates.sql` | Beatmap difficulty rates | `rates` |
| `20250918125942_rating.sql` | Performance ratings | `beatmap_rating`, `score_rating` |
| `20250918125945_maniarating.sql` | Mania-specific ratings | `beatmap_mania_rating`, `score_mania_rating` |
| `20250918133203_pendingbeatmap.sql` | Pending beatmap submissions | `pending_beatmap` |
| `20250918133522_users.sql` | User management system | `users`, `device_tokens`, `bans`, `new_users` |
| `20250918133629_scores.sql` | Scoring system | `score`, `score_metadata`, `replays` |
| `20250918133924_scores_ratings.sql` | Score rating relationships | Rating associations |
| `20250918134308_weekly.sql` | Weekly competition system | `weekly`, `weekly_pool`, `weekly_maps`, `weekly_scores`, `weekly_participants` |

## Database Schema Diagram

```plantuml
@startuml
!define TABLE(name,desc) class name as "desc" <<table>>
!define PK(x) <b><color:#b8861b><&key></color> x</b>
!define FK(x) <color:#aaaaaa><&arrow-right></color> x

skinparam linetype ortho
skinparam linetype polyline

' Core User System
TABLE(users, "users\n---\nPK(discord_id)\nusername\ncreated_at\nroles")
TABLE(device_tokens, "device_tokens\n---\nPK(token)\nFK(discord_id)\ndevice_name\nhwid\ncreated_at")
TABLE(bans, "bans\n---\nPK(id)\nFK(discord_id)\nreason\nbanned_at")
TABLE(new_users, "new_users\n---\nPK(discord_id)\nusername\ntoken\ncreated_at")

' Beatmap System
TABLE(beatmapset, "beatmapset\n---\nPK(id)\nosu_id\nartist\ntitle\ncreator\nsource\ntags\nhas_video\nhas_storyboard\nis_explicit\nis_featured\ncover_url\npreview_url\nosu_file_url\ncreated_at\nupdated_at")
TABLE(beatmap, "beatmap\n---\nPK(id)\nosu_id\nFK(beatmapset_id)\ndifficulty\ncount_circles\ncount_sliders\ncount_spinners\nmax_combo\nmain_pattern\ncs\nar\nod\nhp\nmode\nstatus\ncreated_at\nupdated_at")
TABLE(rates, "rates\n---\nPK(id)\nFK(beatmap_id)\nosu_hash\ncentirate\ndrain_time\ntotal_time\nbpm\ncreated_at")
TABLE(pending_beatmap, "pending_beatmap\n---\nPK(id)\nFK(beatmap_id)\nsubmitted_by\nstatus\ncreated_at")

' Scoring System
TABLE(score, "score\n---\nPK(id)\nFK(user_id)\nFK(rates_id)\nFK(score_metadata_id)\nFK(replay_id)\nhwid\nmods\nrank\nstatus\ncreated_at")
TABLE(score_metadata, "score_metadata\n---\nPK(id)\nskin\npause_count\nstarted_at\nended_at\ntime_paused\nscore\naccuracy\nmax_combo\nperfect\ncount_300\ncount_100\ncount_50\ncount_miss\ncount_katu\ncount_geki\ncreated_at")
TABLE(replays, "replays\n---\nPK(id)\nreplay_hash\nreplay_available\nreplay_path\ncreated_at")

' Rating System
TABLE(beatmap_rating, "beatmap_rating\n---\nPK(id)\nFK(beatmap_id)\nrating\ncreated_at")
TABLE(score_rating, "score_rating\n---\nPK(id)\nFK(score_id)\nrating\ncreated_at")
TABLE(beatmap_mania_rating, "beatmap_mania_rating\n---\nPK(id)\nFK(beatmap_id)\nrating\ncreated_at")
TABLE(score_mania_rating, "score_mania_rating\n---\nPK(id)\nFK(score_id)\nrating\ncreated_at")

' Weekly System
TABLE(weekly, "weekly\n---\nPK(id)\nname\nend_at\nstart_at\ncreated_at")
TABLE(weekly_pool, "weekly_pool\n---\nPK(id)\nFK(beatmap_id)\nFK(weekly_id)\nvote_count\ncreated_at")
TABLE(weekly_maps, "weekly_maps\n---\nPK(id)\nFK(beatmap_id)\nFK(weekly_id)\nmax_rate\ncreated_at")
TABLE(weekly_scores, "weekly_scores\n---\nPK(id)\nFK(user_id)\nFK(weekly_id)\nFK(score_id)\nop\ncreated_at")
TABLE(weekly_participants, "weekly_participants\n---\nPK(id)\nFK(user_id)\nFK(weekly_id)\nop\nfinal_rank\ncreated_at")

' Error Tracking
TABLE(failed_query, "failed_query\n---\nPK(id)\nquery\nerror_message\ncreated_at")

' User System Relationships
users ||--o{ device_tokens : "has"
users ||--o{ bans : "can have"
users ||--o{ score : "submits"
users ||--o{ weekly_scores : "participates"
users ||--o{ weekly_participants : "joins"

' Beatmap System Relationships
beatmapset ||--o{ beatmap : "contains"
beatmap ||--o{ rates : "has"
beatmap ||--o{ pending_beatmap : "can be"
beatmap ||--o{ beatmap_rating : "rated"
beatmap ||--o{ beatmap_mania_rating : "mania rated"
beatmap ||--o{ weekly_pool : "voted for"
beatmap ||--o{ weekly_maps : "featured in"

' Scoring System Relationships
rates ||--o{ score : "played on"
score_metadata ||--o{ score : "contains data"
replays ||--o{ score : "stored as"
score ||--o{ score_rating : "rated"
score ||--o{ score_mania_rating : "mania rated"
score ||--o{ weekly_scores : "submitted to"

' Weekly System Relationships
weekly ||--o{ weekly_pool : "has pool"
weekly ||--o{ weekly_maps : "features maps"
weekly ||--o{ weekly_scores : "receives scores"
weekly ||--o{ weekly_participants : "has participants"

@enduml
```

## Usage

### Running Migrations

To apply these migrations to your database, use your preferred migration tool (e.g., `sqlx migrate run` or similar):

```bash
# Navigate to the migrations directory
cd migrations

# Run all pending migrations
sqlx migrate run

# Or run a specific migration
sqlx migrate run --source . --target 20250918134308_weekly.sql
```

### Git Submodule Management

Since this is a git submodule, you can manage it independently:

```bash
# Initialize and update the submodule
git submodule init
git submodule update

# Update to the latest version
git submodule update --remote

# Commit changes in the submodule
cd migrations
git add .
git commit -m "Update migrations"
git push

# Update the parent repository to reference the new submodule commit
cd ..
git add migrations
git commit -m "Update migrations submodule"
```

## Database Features

### Key Features

- **Identity Columns**: Uses PostgreSQL's `GENERATED ALWAYS AS IDENTITY` for auto-incrementing primary keys
- **JSONB Support**: Stores complex data like user roles and beatmap patterns as JSON
- **Comprehensive Indexing**: Optimized indexes for common query patterns
- **Data Validation**: Check constraints ensure data integrity
- **Cascade Deletes**: Proper foreign key relationships with appropriate cascade behaviors
- **Timestamps**: Automatic creation and update timestamps on relevant tables

### Performance Considerations

- Indexes are created on frequently queried columns
- Composite indexes for multi-column queries
- Partial indexes for filtered queries (e.g., pending scores)
- JSONB columns for flexible schema evolution

## Contributing

When adding new migrations:

1. Follow the naming convention: `YYYYMMDDHHMMSS_description.sql`
2. Include proper comments with author, description, and version
3. Add appropriate indexes for new tables
4. Update this README with the new migration information
5. Test migrations on a development database before committing

## Notes

- All timestamps use `timestamp default now()`
- Foreign key constraints include appropriate `ON DELETE` actions
- The schema supports both standard osu! modes and mania-specific features
- Weekly competitions include voting, map pools, and ranking systems
- Anti-cheat measures include hardware ID tracking and replay validation
