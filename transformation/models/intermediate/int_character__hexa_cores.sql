with stg_nexon__character_hexa_cores as (
    select * from {{ ref('stg_nexon__character_hexa_cores') }}
),

int_character__hexa_cores as (
    select distinct on (snapshot_date, ocid, hexa_core_name)
        snapshot_date,
        ocid,
        character_hexa_core_equipment__hexa_core_name as hexa_core_name,
        character_hexa_core_equipment__hexa_core_type as hexa_core_type,
        case
            when character_hexa_core_equipment__hexa_core_level = 0 then character_hexa_core_equipment__hexa_core_event_level
            else character_hexa_core_equipment__hexa_core_level
        end as hexa_core_level
    from stg_nexon__character_hexa_cores
)

select * from int_character__hexa_cores
