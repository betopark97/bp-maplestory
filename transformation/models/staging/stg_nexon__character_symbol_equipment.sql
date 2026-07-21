with character_symbol_equipment as (
    select * from {{ source('nexon', 'character_symbol_equipment') }}
),

stg_nexon__character_symbol_equipment as (
    select
        date,
        ocid,
        s ->> 'symbol_name' as symbol_name,
        character_class,
        (s ->> 'symbol_hp')::integer as symbol_hp,
        (s ->> 'symbol_dex')::integer as symbol_dex,
        (s ->> 'symbol_int')::integer as symbol_int,
        (s ->> 'symbol_luk')::integer as symbol_luk,
        (s ->> 'symbol_str')::integer as symbol_str,
        s ->> 'symbol_icon' as symbol_icon,
        (s ->> 'symbol_force')::integer as symbol_force,
        (s ->> 'symbol_level')::integer as symbol_level,
        s ->> 'symbol_exp_rate' as symbol_exp_rate,
        s ->> 'symbol_drop_rate' as symbol_drop_rate,
        s ->> 'symbol_meso_rate' as symbol_meso_rate,
        s ->> 'symbol_description' as symbol_description,
        (s ->> 'symbol_growth_count')::integer as symbol_growth_count,
        (s ->> 'symbol_require_growth_count')::integer as symbol_require_growth_count,
        s ->> 'symbol_other_effect_description' as symbol_other_effect_description
    from character_symbol_equipment,
        lateral jsonb_array_elements(symbol) as s
)

select * from stg_nexon__character_symbol_equipment
