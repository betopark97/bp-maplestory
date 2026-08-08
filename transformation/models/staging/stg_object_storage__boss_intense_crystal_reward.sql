with boss_intense_crystal_reward as (
    select * from {{ source('object_storage', 'boss_intense_crystal_reward') }}
),

stg_object_storage__boss_intense_crystal_reward as (
    select
        "주기" as reset_cycle,
        "난이도" as boss_difficulty,
        "보스" as boss_name,
        nullif(replace("가격", ',', ''), '')::bigint as crystal_price,
        nullif(replace("최하_난이도_대비", ' 배', ''), '?')::float as price_ratio_to_lowest_difficulty
    from boss_intense_crystal_reward
)

select * from stg_object_storage__boss_intense_crystal_reward
