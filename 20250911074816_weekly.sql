create table weekly( 
    id integer generated always as identity primary key,
    name varchar(255) not null,
    end_at timestamp,
    start_at timestamp,
    constraint valid_end_at check (end_at is null or end_at > start_at),
    constraint valid_start_at check (start_at is null or start_at > created_at),
    created_at timestamp default now()
);

create table weekly_pool(
    id integer generated always as identity primary key,
    beatmap_id integer not null references beatmap(id) on delete cascade,
    weekly_id integer not null references weekly(id) on delete cascade,
    vote_count integer not null default 0,
    created_at timestamp default now(),
    constraint unique_weekly_pool unique (weekly_id, beatmap_id)
);

create table weekly_maps(
    id integer generated always as identity primary key,
    beatmap_id integer not null references beatmap(id) on delete cascade,
    weekly_id integer not null references weekly(id) on delete cascade,
    max_rate decimal(4,2) not null default 2.5,
    created_at timestamp default now(),
    constraint unique_weekly_maps unique (weekly_id, beatmap_id)
);

create table weekly_scores(
    id integer generated always as identity primary key,
    user_id bigint not null references users(discord_id) on delete cascade,
    weekly_id integer not null references weekly(id) on delete cascade,
    score_id integer not null references score(id) on delete cascade,
    op decimal(7,2) not null,
    created_at timestamp default now(),
    constraint unique_weekly_score unique (weekly_id, user_id, score_id)
);

create table weekly_participants (
    id integer generated always as identity primary key,
    user_id bigint not null references users(discord_id) on delete cascade,
    weekly_id integer not null references weekly(id) on delete cascade,
    op decimal(7,2) not null,
    final_rank integer, -- computed at the end
    created_at timestamp default now(),
    constraint unique_weekly_participant unique (weekly_id, user_id),
    constraint valid_rank check (final_rank is null or final_rank > 0)
);

-- Indexes for performance
create index idx_weekly_pool_weekly on weekly_pool(weekly_id);
create index idx_weekly_maps_weekly on weekly_maps(weekly_id);
create index idx_weekly_scores_weekly on weekly_scores(weekly_id);
create index idx_weekly_scores_user on weekly_scores(user_id, weekly_id);
create index idx_weekly_participants_weekly on weekly_participants(weekly_id);
create index idx_weekly_participants_rank on weekly_participants(weekly_id, final_rank);
