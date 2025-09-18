-- Table beatmap
create table if not exists beatmap (
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    osu_id integer unique,
    beatmapset_id integer NULL references beatmapset(id) on delete cascade,
    difficulty varchar(255) not null,
    count_circles integer not null,
    count_sliders integer not null,
    count_spinners integer not null,
    max_combo integer not null,
    main_pattern jsonb not null,
    cs decimal(3,1) not null,
    ar decimal(3,1) not null,
    od decimal(3,1) not null,
    hp decimal(3,1) not null,
    mode integer not null default 0,
    status varchar(20) not null default 'pending',
    created_at timestamp default now(),
    updated_at timestamp default now(),
    constraint valid_main_pattern check (main_pattern is not null),
    constraint valid_mode check (mode in (0, 1, 2, 3)),
    constraint valid_status check (status in ('pending', 'ranked', 'qualified', 'loved', 'graveyard'))
);

create index if not exists idx_beatmap_beatmapset_id on beatmap(beatmapset_id);
create index if not exists idx_beatmap_difficulty on beatmap(difficulty);
create index if not exists idx_beatmap_mode on beatmap(mode);
create index if not exists idx_beatmap_status on beatmap(status);

