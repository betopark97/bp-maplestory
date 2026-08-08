with stg_object_storage__boss_intense_crystal_reward as (
    select
        reset_cycle,
        boss_difficulty,
        boss_name,
        coalesce(crystal_price, 0) as crystal_price
    from {{ ref('stg_object_storage__boss_intense_crystal_reward') }}
),

stg_object_storage__hexa_boss_reward as (
    select
        boss_difficulty,
        boss_name,
        coalesce(sol_erda_energy, 0) as sol_erda_energy
    from {{ ref('stg_object_storage__hexa_boss_reward') }}
),

stg_object_storage__image as (
    select
        object_key as image_full_path,
        replace(
            replace(file_name, '.webp', ''), '_', ' '
        ) as boss_name
    from {{ ref('stg_object_storage__image') }}
    where relative_path like '%/boss_card/%'
),

dim_boss__details as (
    select
        {{ dbt_utils.generate_surrogate_key(
            ['crystal.boss_difficulty', 'crystal.boss_name']
        )}} as boss__details_key,
        crystal.reset_cycle,
        crystal.boss_difficulty,
        crystal.boss_name,
        crystal.crystal_price,
        coalesce(hexa.sol_erda_energy, 0) as sol_erda_energy,
        image.image_full_path
    from stg_object_storage__boss_intense_crystal_reward crystal
    left join stg_object_storage__hexa_boss_reward hexa
        on crystal.boss_difficulty = hexa.boss_difficulty
        and crystal.boss_name = hexa.boss_name
    left join stg_object_storage__image image
        on regexp_replace(crystal.boss_name, '\s+', '', 'g') = regexp_replace(image.boss_name, '\s+', '', 'g')
)

select * from dim_boss__details
