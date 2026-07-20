with character_basic as (
    select * from {{ source('nexon', 'character_basic') }}
),

stg_nexon__character_basic as (
    select
        date::date,
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
        access_flag::boolean,
        liberation_quest_clear::integer
    from character_basic
)

select * from stg_nexon__character_basic
