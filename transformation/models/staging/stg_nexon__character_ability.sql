with character_ability as (
    select * from {{ source('nexon', 'character_ability') }}
),

ap1 as (
    select
        date,
        ocid,
        (ap1 ->> 'ability_no')::integer as ability_no,
        ap1 ->> 'ability_grade' as ability_grade,
        ap1 ->> 'ability_value' as ability_value
    from character_ability,
        lateral jsonb_array_elements(ability_preset_1 -> 'ability_info') as ap1
),

ap2 as (
    select
        date,
        ocid,
        (ap2 ->> 'ability_no')::integer as ability_no,
        ap2 ->> 'ability_grade' as ability_grade,
        ap2 ->> 'ability_value' as ability_value
    from character_ability,
        lateral jsonb_array_elements(ability_preset_2 -> 'ability_info') as ap2
),

ap3 as (
    select
        date,
        ocid,
        (ap3 ->> 'ability_no')::integer as ability_no,
        ap3 ->> 'ability_grade' as ability_grade,
        ap3 ->> 'ability_value' as ability_value
    from character_ability,
        lateral jsonb_array_elements(ability_preset_3 -> 'ability_info') as ap3
),

ability_presets as (
    select
        date,
        ocid,
        ability_no,
        ap1.ability_grade as ability_preset_1_ability_grade,
        ap1.ability_value as ability_preset_1_ability_value,
        ap2.ability_grade as ability_preset_2_ability_grade,
        ap2.ability_value as ability_preset_2_ability_value,
        ap3.ability_grade as ability_preset_3_ability_grade,
        ap3.ability_value as ability_preset_3_ability_value
    from ap1
    full join ap2 using (ocid, date, ability_no)
    full join ap3 using (ocid, date, ability_no)
),

stg_nexon__character_ability as (
    select
        chs.date,
        chs.ocid,
        chs.ability_grade,
        chs.remain_fame,
        chs.preset_no,
        ap.ability_no,
        chs.ability_preset_1 ->> 'ability_preset_grade' as ability_preset_1_grade,
        ap.ability_preset_1_ability_grade,
        ap.ability_preset_1_ability_value,
        chs.ability_preset_2 ->> 'ability_preset_grade' as ability_preset_2_grade,
        ap.ability_preset_2_ability_grade,
        ap.ability_preset_2_ability_value,
        chs.ability_preset_3 ->> 'ability_preset_grade' as ability_preset_3_grade,
        ap.ability_preset_3_ability_grade,
        ap.ability_preset_3_ability_value
    from character_ability as chs
    left join ability_presets as ap
        on chs.ocid = ap.ocid and chs.date = ap.date
)

select * from stg_nexon__character_ability
