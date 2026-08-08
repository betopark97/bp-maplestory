with stg_nexon__character_basic as (
    select
        date,
        ocid,
        character_class,
        character_class_level,
        character_level,
        character_exp,
        character_exp_rate,
        character_image,
        is_access_flag,
        liberation_quest_clear
    from {{ ref('stg_nexon__character_basic') }}
),

stg_nexon__character_popularity as (
    select
        date,
        ocid,
        popularity
    from {{ ref('stg_nexon__character_popularity') }}
),

dim_character__details as (
    select
        character__details_key,
        ocid
    from {{ ref('dim_character__details') }}
),

fct_character__details as (
    select
        cb.date,
        dc.character__details_key,
        cb.character_class,
        cb.character_class_level,
        cb.character_level,
        cb.character_exp,
        cb.character_exp_rate,
        cb.character_image,
        cb.is_access_flag,
        cb.liberation_quest_clear,
        cp.popularity
    from stg_nexon__character_basic as cb
    left join stg_nexon__character_popularity as cp
        on cb.date = cp.date
        and cb.ocid = cp.ocid
    left join dim_character__details as dc
        on cb.ocid = dc.ocid
)

select * from fct_character__details
