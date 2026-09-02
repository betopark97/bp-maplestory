with character_stat as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_stat') }}
),

stg_nexon__character_stats as (
    select
        snapshot_date::date,
        ocid,
        character_class,
        fs ->> 'stat_name' as final_stat__stat_name,
        (fs ->> 'stat_value')::float as final_stat__stat_value,
        remain_ap::integer
    from character_stat,
    lateral jsonb_array_elements(final_stat) as fs
)

select * from stg_nexon__character_stats
