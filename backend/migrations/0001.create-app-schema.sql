-- Create the app-owned schema and its first table.
--
-- Only tables this service writes belong here. dbt owns the staging /
-- intermediate / marts schemas and rebuilds them from source; these rows
-- cannot be rebuilt, which is why they are migrated instead.

create schema if not exists app;

create table app.favorite_character (
    id bigint generated always as identity primary key,
    ocid text not null,
    label text,
    created_at timestamptz not null default now()
);

-- One favorite per character.
create unique index favorite_character_ocid_key on app.favorite_character (ocid);
