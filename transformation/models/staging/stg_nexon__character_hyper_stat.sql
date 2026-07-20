with character_hyper_stat as (
    select * from {{ source('nexon', 'character_hyper_stat') }}
),

hsp1 as (
    select
        ocid,
        date,
        hsp1 ->> 'stat_type' as stat_type,
        (hsp1 ->> 'stat_level')::integer as stat_level,
        (hsp1 ->> 'stat_point')::integer as stat_point,
        hsp1 ->> 'stat_increase' as stat_increase
    from character_hyper_stat,
        lateral jsonb_array_elements(hyper_stat_preset_1) as hsp1
),

hsp2 as (
    select
        ocid,
        date,
        hsp2 ->> 'stat_type' as stat_type,
        (hsp2 ->> 'stat_level')::integer as stat_level,
        (hsp2 ->> 'stat_point')::integer as stat_point,
        hsp2 ->> 'stat_increase' as stat_increase
    from character_hyper_stat,
        lateral jsonb_array_elements(hyper_stat_preset_2) as hsp2
),

hsp3 as (
    select
        ocid,
        date,
        hsp3 ->> 'stat_type' as stat_type,
        (hsp3 ->> 'stat_level')::integer as stat_level,
        (hsp3 ->> 'stat_point')::integer as stat_point,
        hsp3 ->> 'stat_increase' as stat_increase
    from character_hyper_stat,
        lateral jsonb_array_elements(hyper_stat_preset_3) as hsp3
),

hyper_stat_presets as (
    select
        ocid,
        date,
        stat_type,
        hsp1.stat_level    as hyper_stat_preset_1_stat_level,
        hsp1.stat_point    as hyper_stat_preset_1_stat_point,
        hsp1.stat_increase as hyper_stat_preset_1_stat_increase,
        hsp2.stat_level    as hyper_stat_preset_2_stat_level,
        hsp2.stat_point    as hyper_stat_preset_2_stat_point,
        hsp2.stat_increase as hyper_stat_preset_2_stat_increase,
        hsp3.stat_level    as hyper_stat_preset_3_stat_level,
        hsp3.stat_point    as hyper_stat_preset_3_stat_point,
        hsp3.stat_increase as hyper_stat_preset_3_stat_increase
    from hsp1
    full join hsp2 using (ocid, date, stat_type)
    full join hsp3 using (ocid, date, stat_type)
),

stg_nexon__character_hyper_stat as (
    select
        chs.date,
        chs.ocid,
        chs.character_class,
        chs.use_preset_no::integer,
        chs.use_available_hyper_stat::integer,
        hsp.stat_type,
        hsp.hyper_stat_preset_1_stat_level,
        hsp.hyper_stat_preset_1_stat_point,
        hsp.hyper_stat_preset_1_stat_increase,
        chs.hyper_stat_preset_1_remain_point::integer,
        hsp.hyper_stat_preset_2_stat_level,
        hsp.hyper_stat_preset_2_stat_point,
        hsp.hyper_stat_preset_2_stat_increase,
        chs.hyper_stat_preset_2_remain_point::integer,
        hsp.hyper_stat_preset_3_stat_level,
        hsp.hyper_stat_preset_3_stat_point,
        hsp.hyper_stat_preset_3_stat_increase,
        chs.hyper_stat_preset_3_remain_point::integer
    from character_hyper_stat as chs
    left join hyper_stat_presets as hsp
        on chs.ocid = hsp.ocid and chs.date = hsp.date
)

select * from stg_nexon__character_hyper_stat
