with character_ring_reserve_skill_equipment as (
    select * from {{ source('nexon', 'character_ring_reserve_skill_equipment') }}
),

stg_nexon__character_ring_reserve_skill_equipment as (
    select
        date::date,
        ocid,
        character_class,
        special_ring_reserve_name,
        special_ring_reserve_level::integer,
        special_ring_reserve_icon,
        special_ring_reserve_description
    from character_ring_reserve_skill_equipment
)

select * from stg_nexon__character_ring_reserve_skill_equipment
