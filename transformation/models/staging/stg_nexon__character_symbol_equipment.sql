with character_symbol_equipment as (
    select * from {{ source('nexon', 'character_symbol_equipment') }}
),

stg_nexon__character_symbol_equipment as (
    select
        date,
        ocid,
        s ->> 'symbol_name' as symbol__symbol_name,
        character_class,
        (s ->> 'symbol_hp')::integer as symbol__symbol_hp,
        (s ->> 'symbol_dex')::integer as symbol__symbol_dex,
        (s ->> 'symbol_int')::integer as symbol__symbol_int,
        (s ->> 'symbol_luk')::integer as symbol__symbol_luk,
        (s ->> 'symbol_str')::integer as symbol__symbol_str,
        s ->> 'symbol_icon' as symbol__symbol_icon,
        (s ->> 'symbol_force')::integer as symbol__symbol_force,
        (s ->> 'symbol_level')::integer as symbol__symbol_level,
        s ->> 'symbol_exp_rate' as symbol__symbol_exp_rate,
        s ->> 'symbol_drop_rate' as symbol__symbol_drop_rate,
        s ->> 'symbol_meso_rate' as symbol__symbol_meso_rate,
        s ->> 'symbol_description' as symbol__symbol_description,
        (s ->> 'symbol_growth_count')::integer as symbol__symbol_growth_count,
        (s ->> 'symbol_require_growth_count')::integer as symbol__symbol_require_growth_count,
        s ->> 'symbol_other_effect_description' as symbol__symbol_other_effect_description
    from character_symbol_equipment,
        lateral jsonb_array_elements(symbol) as s
)

select * from stg_nexon__character_symbol_equipment
