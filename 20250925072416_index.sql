-- Add migration script here
CREATE INDEX idx_main_pattern ON beatmap USING GIN (main_pattern jsonb_path_ops);
CREATE INDEX idx_base_beatmapset_id ON beatmap (beatmapset_id);