with character_basic as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_basic') }}
),

stg_nexon__character_profiles as (
    select
        snapshot_date::date,
        ocid,
        character_name,
        world_name,
        character_gender,
        character_class,
        character_class_level::integer,
        character_level::integer,
        character_exp::bigint,
        character_exp_rate::float,
        character_image,
        character_date_create::timestamptz,
        access_flag::boolean as is_accessed,
        liberation_quest_clear::integer as liberation_quest_stage
    from character_basic
)

select * from stg_nexon__character_profiles
