with character_popularity as (
    select * from {{ source('nexon', 'character_popularity') }}
),

stg_nexon__character_popularity as (
    select
        date::date,
        ocid,
        popularity::integer
    from character_popularity
)

select * from stg_nexon__character_popularity
