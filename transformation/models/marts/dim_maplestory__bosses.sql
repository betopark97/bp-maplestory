with stg_object_storage__boss_intense_crystal_rewards as (
    select
        reset_cycle,
        boss_difficulty,
        boss_name,
        coalesce(crystal_price, 0) as crystal_price
    from {{ ref('stg_object_storage__boss_intense_crystal_rewards') }}
),

stg_object_storage__hexa_boss_rewards as (
    select
        boss_difficulty,
        boss_name,
        coalesce(sol_erda_energy, 0) as sol_erda_energy
    from {{ ref('stg_object_storage__hexa_boss_rewards') }}
),

stg_object_storage__images as (
    select
        object_key as image_full_path,
        replace(
            replace(file_name, '.webp', ''), '_', ' '
        ) as boss_name
    from {{ ref('stg_object_storage__images') }}
    where relative_path like '%/boss_card/%'
),

dim_maplestory__bosses as (
    select
        {{ dbt_utils.generate_surrogate_key(
            ['crystal.boss_difficulty', 'crystal.boss_name']
        )}} as boss_id,
        crystal.reset_cycle,
        crystal.boss_difficulty,
        crystal.boss_name,
        crystal.crystal_price,
        coalesce(hexa.sol_erda_energy, 0) as sol_erda_energy,
        image.image_full_path
    from stg_object_storage__boss_intense_crystal_rewards crystal
    left join stg_object_storage__hexa_boss_rewards hexa
        on crystal.boss_difficulty = hexa.boss_difficulty
        and crystal.boss_name = hexa.boss_name
    left join stg_object_storage__images image
        on regexp_replace(crystal.boss_name, '\s+', '', 'g') = regexp_replace(image.boss_name, '\s+', '', 'g')
)

select * from dim_maplestory__bosses
