-- Add migration script here
create table score_rating(
    id integer generated always as identity primary key,
    score_id integer not null references score(id) on delete cascade,
    rating decimal(6,2) not null,
    rating_type varchar(30) not null,
    created_at timestamp default now(),
    constraint valid_type check (rating_type in ('etterna', 'osu', 'quaver', 'malody'))
);

create index idx_score_rating_score_id on score_rating(score_id);

