with character_popularity as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_popularity') }}
),

stg_nexon__character_popularities as (
    select
        snapshot_date::date,
        ocid,
        popularity::integer
    from character_popularity
)

select * from stg_nexon__character_popularities
