with character_propensity as (
    select * from {{ source('nexon', 'character_propensity') }}
),

stg_nexon__character_propensity as (
    select
        date::date,
        ocid,
        charisma_level::integer,
        sensibility_level::integer,
        insight_level::integer,
        willingness_level::integer,
        handicraft_level::integer,
        charm_level::integer
    from character_propensity
)

select * from stg_nexon__character_propensity
