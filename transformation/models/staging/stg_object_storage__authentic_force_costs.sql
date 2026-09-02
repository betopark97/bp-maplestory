with authentic_force_cost as (
    select * from {{ source('object_storage', 'authentic_force_cost') }}
),

stg_object_storage__authentic_force_costs as (
    select
        "지역" as region,
        "레벨"::integer as symbol_level,
        aut::integer as authentic_force,
        "스탯_일반"::integer as main_stat,
        "스탯_제논"::integer as main_stat_xenon,
        "스탯_데몬어벤져"::integer as main_stat_demon_avenger,
        "필요_성장치"::integer as required_growth,
        "필요_메소"::bigint as required_meso,
        "누적_성장치"::integer as cumulative_growth,
        "누적_메소"::bigint as cumulative_meso,
        "누적_성장치_원문"::integer as cumulative_growth_as_printed,
        "누적_메소_원문"::bigint as cumulative_meso_as_printed,
        content_hash,
        fetched_at
    from authentic_force_cost
)

select * from stg_object_storage__authentic_force_costs
