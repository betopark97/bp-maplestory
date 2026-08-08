with stg_nexon__scheduler_character_state as (
    select
        date,
        ocid,
        case
            when boss_contents__difficulty = 'chaos' then '카오스'
            when boss_contents__difficulty = 'easy' then '이지'
            when boss_contents__difficulty = 'extreme' then '익스트림'
            when boss_contents__difficulty = 'hard' then '하드'
            when boss_contents__difficulty = 'normal' then '노멀'
            else boss_contents__difficulty
        end as boss_difficulty,
        boss_contents__content_name as boss_name,
        is_boss_contents__complete_flag
    from {{ ref('stg_nexon__scheduler_character_state') }}
    where contents__source = 'boss_contents'
        and is_boss_contents__registration_flag = true
),

dim_boss__details as (
    select
        boss__details_key,
        boss_difficulty,
        boss_name
    from {{ ref('dim_boss__details') }}
),

dim_character__details as (
    select
        character__details_key,
        ocid
    from {{ ref('dim_character__details') }}
),

fct_character__boss_rewards as (
    select
        scs.date,
        dc.character__details_key,
        db.boss__details_key,
        scs.is_boss_contents__complete_flag
    from stg_nexon__scheduler_character_state as scs
    left join dim_character__details as dc
        on scs.ocid = dc.ocid
    left join dim_boss__details as db
        on scs.boss_difficulty = db.boss_difficulty
        and scs.boss_name = db.boss_name
)

select * from fct_character__boss_rewards
