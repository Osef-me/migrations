create table if not exists rates (
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    beatmap_id integer not null references beatmap(id) on delete cascade,
    osu_hash varchar(128) not null,
    centirate integer not null, -- rate but in centi so no 1.1 but 110
    drain_time integer not null,
    total_time integer not null,
    bpm decimal(10,2) not null,
    created_at timestamp default now(),
    constraint valid_centirate check (centirate between 70 and 200)
);