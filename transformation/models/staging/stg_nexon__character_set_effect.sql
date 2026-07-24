with character_set_effect as (
    select * from {{ source('nexon', 'character_set_effect') }}
),

sets as (
    select
        date,
        ocid,
        se ->> 'set_name' as set_effect__set_name,
        se -> 'set_effect_info' as set_effect_info,
        se -> 'set_option_full' as set_option_full,
        (se ->> 'total_set_count')::integer as set_effect__total_set_count
    from character_set_effect,
        lateral jsonb_array_elements(set_effect) as se
),

set_effect_info as (
    select
        date,
        ocid,
        set_effect__set_name,
        (i ->> 'set_count')::integer as set_effect__set_count,
        i ->> 'set_option' as set_effect__set_effect_info__set_option
    from sets,
        lateral jsonb_array_elements(set_effect_info) as i
),

set_option_full as (
    select
        date,
        ocid,
        set_effect__set_name,
        set_effect__total_set_count,
        (f ->> 'set_count')::integer as set_effect__set_count,
        f ->> 'set_option' as set_effect__set_option_full__set_option
    from sets,
        lateral jsonb_array_elements(set_option_full) as f
),

stg_nexon__character_set_effect as (
    select
        date,
        ocid,
        set_effect__set_name,
        set_effect__set_count,
        sei.set_effect__set_effect_info__set_option,
        sof.set_effect__set_option_full__set_option,
        sof.set_effect__total_set_count
    from set_option_full as sof
    full join set_effect_info as sei using (date, ocid, set_effect__set_name, set_effect__set_count)
)

select * from stg_nexon__character_set_effect
