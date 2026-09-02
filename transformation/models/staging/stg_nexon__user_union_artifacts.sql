with user_union_artifact as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'user_union_artifact') }}
),

-- Scalars + single-object columns, 1:1 per (snapshot_date, ocid). No list columns.
spine as (
    select
        snapshot_date,
        ocid,
        union_artifact_remain_ap::integer
    from user_union_artifact
),

-- List 1: union_artifact_effect {name, level}. One row per effect.
union_artifact_effect as (
    select
        uua.snapshot_date,
        uua.ocid,
        effect.el ->> 'name'                as union_artifact_effect__name,
        (effect.el ->> 'level')::integer    as union_artifact_effect__level
    from user_union_artifact as uua,
        lateral jsonb_array_elements(uua.union_artifact_effect) as effect(el)
),

-- List 2: union_artifact_crystal {name, is_valid, date_expire, level,
-- crystal_option_name_1/2/3}. One row per crystal.
union_artifact_crystal as (
    select
        uua.snapshot_date,
        uua.ocid,
        crystal.el ->> 'name'                          as union_artifact_crystal__name,
        (crystal.el ->> 'validity_flag')::boolean as is_union_artifact_crystal__valid,
        (crystal.el ->> 'date_expire')::timestamptz    as union_artifact_crystal__date_expire,
        (crystal.el ->> 'level')::integer              as union_artifact_crystal__level,
        crystal.el ->> 'crystal_option_name_1'         as union_artifact_crystal__crystal_option_name_1,
        crystal.el ->> 'crystal_option_name_2'         as union_artifact_crystal__crystal_option_name_2,
        crystal.el ->> 'crystal_option_name_3'         as union_artifact_crystal__crystal_option_name_3
    from user_union_artifact as uua,
        lateral jsonb_array_elements(uua.union_artifact_crystal) as crystal(el)
),

-- Stack both lists into one column set (null-filled), discriminated by source list column.
all_lists as (
    select
        snapshot_date,
        ocid,
        union_artifact_effect__name,
        union_artifact_effect__level,
        null::text          as union_artifact_crystal__name,
        null::boolean as is_union_artifact_crystal__valid,
        null::timestamptz   as union_artifact_crystal__date_expire,
        null::integer       as union_artifact_crystal__level,
        null::text          as union_artifact_crystal__crystal_option_name_1,
        null::text          as union_artifact_crystal__crystal_option_name_2,
        null::text          as union_artifact_crystal__crystal_option_name_3,
        'union_artifact_effect' as artifact__source
    from union_artifact_effect

    union all

    select
        snapshot_date,
        ocid,
        null::text          as union_artifact_effect__name,
        null::integer       as union_artifact_effect__level,
        union_artifact_crystal__name,
        is_union_artifact_crystal__valid,
        union_artifact_crystal__date_expire,
        union_artifact_crystal__level,
        union_artifact_crystal__crystal_option_name_1,
        union_artifact_crystal__crystal_option_name_2,
        union_artifact_crystal__crystal_option_name_3,
        'union_artifact_crystal' as artifact__source
    from union_artifact_crystal
),

stg_nexon__user_union_artifacts as (
    select
        spine.snapshot_date,
        spine.ocid,
        spine.union_artifact_remain_ap,
        all_lists.union_artifact_effect__name,
        all_lists.union_artifact_effect__level,
        all_lists.union_artifact_crystal__name,
        all_lists.is_union_artifact_crystal__valid,
        all_lists.union_artifact_crystal__date_expire,
        all_lists.union_artifact_crystal__level,
        all_lists.union_artifact_crystal__crystal_option_name_1,
        all_lists.union_artifact_crystal__crystal_option_name_2,
        all_lists.union_artifact_crystal__crystal_option_name_3,
        all_lists.artifact__source
    from spine
    left join all_lists using (snapshot_date, ocid)
)

select * from stg_nexon__user_union_artifacts
