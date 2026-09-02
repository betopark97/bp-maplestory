with stg_nexon__character_daily_states as (
    select
        snapshot_date,
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
        is_boss_contents__completed
    from {{ ref('stg_nexon__character_daily_states') }}
    where contents__source = 'boss_contents'
        and is_boss_contents__registered = true
),

dim_maplestory__bosses as (
    select
        boss_id,
        boss_difficulty,
        boss_name
    from {{ ref('dim_maplestory__bosses') }}
),

dim_maplestory__characters as (
    select
        character_id,
        ocid
    from {{ ref('dim_maplestory__characters') }}
),

fct_maplestory__boss_clears_daily as (
    select
        scs.snapshot_date,
        dc.character_id,
        db.boss_id,
        scs.is_boss_contents__completed
    from stg_nexon__character_daily_states as scs
    left join dim_maplestory__characters as dc
        on scs.ocid = dc.ocid
    left join dim_maplestory__bosses as db
        on scs.boss_difficulty = db.boss_difficulty
        and scs.boss_name = db.boss_name
)

select * from fct_maplestory__boss_clears_daily
