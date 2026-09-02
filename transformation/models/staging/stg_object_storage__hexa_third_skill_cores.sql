with hexa_third_skill_core as (
    select * from {{ source('object_storage', 'hexa_third_skill_core') }}
),

stg_object_storage__hexa_third_skill_cores as (
    select
        character_class,
        third_skill_core_name,
        content_hash,
        fetched_at
    from hexa_third_skill_core
)

select * from stg_object_storage__hexa_third_skill_cores
