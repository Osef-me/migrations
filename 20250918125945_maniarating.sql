-- Add migration script here
-- Add migration script here
create table if not exists beatmap_mania_rating
(
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    rating_id integer references beatmap_rating(id) on delete cascade,
    stream decimal(6,2),
    jumpstream decimal(6,2),
    handstream decimal(6,2),
    stamina decimal(6,2),
    jackspeed decimal(6,2),
    chordjack decimal(6,2),
    technical decimal(6,2),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    constraint valid_stream check (stream >= 0),
    constraint valid_jumpstream check (jumpstream >= 0),
    constraint valid_handstream check (handstream >= 0),
    constraint valid_stamina check (stamina >= 0),
    constraint valid_jackspeed check (jackspeed >= 0),
    constraint valid_chordjack check (chordjack >= 0),
    constraint valid_technical check (technical >= 0)
);