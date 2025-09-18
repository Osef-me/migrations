-- Migration: Create beatmapset and beatmap tables
-- Created: 2025-08-26
-- Author: Osef
-- Description: Tables for stocking beatmaps
-- Version: 1.0.0

-- Table beatmapset
create table if not exists beatmapset (
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    osu_id integer unique,
    artist varchar(255) not null,
    artist_unicode varchar(255),
    title varchar(255) not null,
    title_unicode varchar(255),
    creator varchar(255) not null,
    source varchar(255),
    tags text[],
    has_video boolean not null default false,
    has_storyboard boolean not null default false,
    is_explicit boolean not null default false,
    is_featured boolean not null default false,
    cover_url varchar(255),
    preview_url varchar(255),
    osu_file_url varchar(255),
    created_at timestamp default now(),
    updated_at timestamp default now()
);

create index if not exists idx_beatmapset_artist on beatmapset(artist);
create index if not exists idx_beatmapset_title on beatmapset(title);
create index if not exists idx_beatmapset_creator on beatmapset(creator);
create index if not exists idx_beatmapset_created_at on beatmapset(created_at);
