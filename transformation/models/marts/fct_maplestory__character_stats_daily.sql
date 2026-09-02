with stg_nexon__character_profiles as (
    select
        snapshot_date,
        ocid,
        character_class,
        character_class_level,
        character_level,
        character_exp,
        character_exp_rate,
        character_image,
        is_accessed,
        liberation_quest_stage
    from {{ ref('stg_nexon__character_profiles') }}
),

stg_nexon__character_popularities as (
    select
        snapshot_date,
        ocid,
        popularity
    from {{ ref('stg_nexon__character_popularities') }}
),

dim_maplestory__characters as (
    select
        character_id,
        ocid
    from {{ ref('dim_maplestory__characters') }}
),

fct_maplestory__character_stats_daily as (
    select
        cb.snapshot_date,
        dc.character_id,
        cb.character_class,
        cb.character_class_level,
        cb.character_level,
        cb.character_exp,
        cb.character_exp_rate,
        cb.character_image,
        cb.is_accessed,
        cb.liberation_quest_stage,
        cp.popularity
    from stg_nexon__character_profiles as cb
    left join stg_nexon__character_popularities as cp
        on cb.snapshot_date = cp.snapshot_date
        and cb.ocid = cp.ocid
    left join dim_maplestory__characters as dc
        on cb.ocid = dc.ocid
)

select * from fct_maplestory__character_stats_daily
