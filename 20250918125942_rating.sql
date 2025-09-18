-- Add migration script here
create table if not exists beatmap_rating
(
    id integer GENERATED ALWAYS AS IDENTITY primary key,
    rates_id integer references rates(id) on delete cascade,
    rating decimal(6,2) not null,
    rating_type varchar(30) not null,
    created_at timestamp default now(),
    constraint valid_type check (rating_type in ('osu', 'etterna', 'quaver', 'malody', 'interlude'))
);

create index if not exists idx_rating_rate_id on beatmap_rating(rates_id);
create index if not exists idx_rating_rating_type on beatmap_rating(rating_type);
create index if not exists idx_rating_created_at on beatmap_rating(created_at);