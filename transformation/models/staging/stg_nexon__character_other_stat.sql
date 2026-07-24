with character_other_stat as (
    select * from {{ source('nexon', 'character_other_stat') }}
),

stg_nexon__character_other_stat as (
    select
        date::date,
        ocid,
        o ->> 'other_stat_type' as other_stat__other_stat_type,
        si ->> 'stat_name' as other_stat__stat_info__stat_name,
        si ->> 'stat_value' as other_stat__stat_info__stat_value
    from character_other_stat,
        lateral jsonb_array_elements(other_stat) as o,
        lateral jsonb_array_elements(o -> 'stat_info') as si
)

select * from stg_nexon__character_other_stat
