with character_hexamatrix as (
    select * from {{ source('nexon', 'character_hexamatrix') }}
),

stg_nexon__character_hexamatrix as (
    select
        date,
        ocid,
        core ->> 'hexa_core_name' as character_hexa_core_equipment__hexa_core_name,
        core ->> 'hexa_core_type' as character_hexa_core_equipment__hexa_core_type,
        (core ->> 'hexa_core_level')::integer as character_hexa_core_equipment__hexa_core_level,
        (core ->> 'hexa_core_event_level')::integer as character_hexa_core_equipment__hexa_core_event_level,
        skill ->> 'hexa_skill_id' as character_hexa_core_equipment__linked_skill__hexa_skill_id
    from character_hexamatrix,
        lateral jsonb_array_elements(character_hexa_core_equipment) as core,
        lateral jsonb_array_elements(core -> 'linked_skill') as skill
)

select * from stg_nexon__character_hexamatrix
