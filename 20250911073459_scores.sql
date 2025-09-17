create table replays (
    id integer generated always as identity primary key,
    hash char(64) not null,
    replay_available boolean not null default false,
    replay_path text not null,
    created_at timestamp default now()
);

create table score_metadata (
    id integer generated always as identity primary key,
    skin varchar(100),
    pause_count integer not null default 0,
    started_at timestamp not null, -- check if cheater is smart :) computer timestamp
    ended_at timestamp not null, -- check if cheater is smart :) computer timestamp
    time_paused integer not null default 0, -- used for anticheat in seconds
    score integer not null,
    accuracy decimal(5,2) not null check (accuracy >= 0 and accuracy <= 100),
    max_combo integer not null,
    perfect boolean not null default false,
    count_300 integer not null default 0,
    count_100 integer not null default 0,
    count_50 integer not null default 0,
    count_miss integer not null default 0,
    count_katu integer not null default 0,
    count_geki integer not null default 0,
    created_at timestamp default now()
);

create table if not exists score (
    id integer generated always as identity primary key,
    user_id bigint not null references users(discord_id) on delete cascade,
    beatmap_id integer not null references beatmap(id) on delete cascade,
    score_metadata_id integer not null references score_metadata(id) on delete cascade,
    replay_id integer references replays(id) on delete set null,
    rate decimal(4,2) not null default 1.0, -- rate used for the beatmap
    hwid text, -- hardware id of the computer used to play the score (prevent cheating)
    mods bigint not null default 0,
    hash char(64) not null unique,
    rank varchar(2) not null check (rank in ('XH','X','SH','SS','S','A','B','C','D','E','F','G')),
    status varchar(20) not null default 'pending' check (status in ('pending', 'processing', 'validated', 'cheated', 'unsubmitted')),
    created_at timestamp default now(),
    check (mods >= 0)
);

create index idx_score_user_id on score(user_id);
create index idx_score_beatmap_id on score(beatmap_id);
create index idx_score_hash on score(hash);
create index idx_score_user_beatmap on score(user_id, beatmap_id);
create index idx_score_status on score(status);
create index idx_score_status_pending on score(status) where status = 'pending';