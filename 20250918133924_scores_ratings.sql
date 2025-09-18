-- Add migration script here
create table if not exists score_rating
(
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    score_id integer not null references score(id) on delete cascade,
    rating decimal(6,2) not null,
    rating_type varchar(30) not null,
    created_at timestamp default now(),
    constraint valid_type check (rating_type in ('osu', 'etterna', 'quaver', 'malody', 'interlude'))
);

create table if not exists score_mania_rating
(
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    rating_id integer references score_rating(id) on delete cascade,
    stream decimal(6,2),
    jumpstream decimal(6,2),
    handstream decimal(6,2),
    stamina decimal(6,2),
    jackspeed decimal(6,2),
    chordjack decimal(6,2),
    technical decimal(6,2),
    created_at timestamp default now(),
    constraint valid_stream check (stream >= 0),
    constraint valid_jumpstream check (jumpstream >= 0),
    constraint valid_handstream check (handstream >= 0),
    constraint valid_stamina check (stamina >= 0),
    constraint valid_jackspeed check (jackspeed >= 0),
    constraint valid_chordjack check (chordjack >= 0),
    constraint valid_technical check (technical >= 0)
);
create index if not exists idx_rating_score_id on score_mania_rating(rating_id);
create index if not exists idx_mania_rating_created_at on score_mania_rating(created_at);

create index if not exists idx_score_rating_score_id on score_rating(score_id);
create index if not exists idx_score_rating_rating_type on score_rating(rating_type);
create index if not exists idx_score_rating_created_at on score_rating(created_at);