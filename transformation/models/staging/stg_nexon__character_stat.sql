with character_stat as (
    select * from {{ source('nexon', 'character_stat') }}
),

stg_nexon__character_stat as (
    select
        date::date,
        ocid,
        character_class,
        fs ->> 'stat_name' as stat_name,
        (fs ->> 'stat_value')::float as stat_value,
        remain_ap::integer
    from character_stat,
    lateral jsonb_array_elements(final_stat) as fs
)

select * from stg_nexon__character_stat
