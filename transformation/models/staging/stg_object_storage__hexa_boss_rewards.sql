with hexa_boss_reward as (
    select * from {{ source('object_storage', 'hexa_boss_reward') }}
),

stg_object_storage__hexa_boss_rewards as (
    select
        "보스" as boss_name,
        "난이도" as boss_difficulty,
        regexp_replace("솔_에르다의_기운", '[^0-9]', '', 'g')::integer as sol_erda_energy,
        content_hash,
        fetched_at
    from hexa_boss_reward
)

select * from stg_object_storage__hexa_boss_rewards
