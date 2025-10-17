-- Performance indexes for beatmapset listings and filters

-- Enable pg_trgm for faster ILIKE searches
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- beatmapset text search (artist/title/creator)
CREATE INDEX IF NOT EXISTS idx_beatmapset_artist_trgm ON beatmapset USING GIN (artist gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_beatmapset_title_trgm ON beatmapset USING GIN (title gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_beatmapset_creator_trgm ON beatmapset USING GIN (creator gin_trgm_ops);

-- beatmap filters
CREATE INDEX IF NOT EXISTS idx_beatmap_status ON beatmap (status);
CREATE INDEX IF NOT EXISTS idx_beatmap_od ON beatmap (od);
-- JSONB containment on main_pattern
CREATE INDEX IF NOT EXISTS idx_beatmap_main_pattern_gin ON beatmap USING GIN (main_pattern);

-- rates filters (always filtered by centirate = 100)
CREATE INDEX IF NOT EXISTS idx_rates_centirate_beatmap ON rates (centirate, beatmap_id);
-- Partial indexes to accelerate range filters when centirate = 100
CREATE INDEX IF NOT EXISTS idx_rates_total_time_100 ON rates (total_time) WHERE centirate = 100;
CREATE INDEX IF NOT EXISTS idx_rates_bpm_100 ON rates (bpm) WHERE centirate = 100;

-- beatmap_rating filters
CREATE INDEX IF NOT EXISTS idx_beatmap_rating_type_rating ON beatmap_rating (rating_type, rating);
CREATE INDEX IF NOT EXISTS idx_beatmap_rating_rates_id ON beatmap_rating (rates_id);

-- beatmap_mania_rating skill filters (range queries)
CREATE INDEX IF NOT EXISTS idx_bmr_stream ON beatmap_mania_rating (stream);
CREATE INDEX IF NOT EXISTS idx_bmr_jumpstream ON beatmap_mania_rating (jumpstream);
CREATE INDEX IF NOT EXISTS idx_bmr_handstream ON beatmap_mania_rating (handstream);
CREATE INDEX IF NOT EXISTS idx_bmr_stamina ON beatmap_mania_rating (stamina);
CREATE INDEX IF NOT EXISTS idx_bmr_jackspeed ON beatmap_mania_rating (jackspeed);
CREATE INDEX IF NOT EXISTS idx_bmr_chordjack ON beatmap_mania_rating (chordjack);
CREATE INDEX IF NOT EXISTS idx_bmr_technical ON beatmap_mania_rating (technical);

-- Helpful join indexes (if not already created via FKs)
CREATE INDEX IF NOT EXISTS idx_beatmap_beatmapset_id ON beatmap (beatmapset_id);
CREATE INDEX IF NOT EXISTS idx_rates_beatmap_id ON rates (beatmap_id);
CREATE INDEX IF NOT EXISTS idx_br_id ON beatmap_rating (id);

