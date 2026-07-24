with user_union_champion as (
    select * from {{ source('nexon', 'user_union_champion') }}
),

-- Scalars + single-object (error) columns, 1:1 per (date, ocid). No list columns.
-- error is populated only when the API call failed (union_champion is then null).
spine as (
    select
        date,
        ocid,
        error ->> 'name'      as error__name,
        error ->> 'message'   as error__message
    from user_union_champion
),

-- List 1: union_champion {champion_name, champion_slot, champion_class, champion_grade,
-- champion_badge_info:[]}. One row per champion.
union_champion as (
    select
        uuc.date,
        uuc.ocid,
        champion.el ->> 'champion_name'              as union_champion__champion_name,
        (champion.el ->> 'champion_slot')::integer   as union_champion__champion_slot,
        champion.el ->> 'champion_class'             as union_champion__champion_class,
        champion.el ->> 'champion_grade'             as union_champion__champion_grade
    from user_union_champion as uuc,
        lateral jsonb_array_elements(uuc.union_champion) as champion(el)
),

-- List 2: union_champion[].champion_badge_info {stat}, nested per champion. Always empty
-- in observed data (0 rows); schema inferred from the Nexon OpenAPI definition. Carries
-- the champion_slot identity so a badge can be traced back to its champion.
union_champion__champion_badge_info as (
    select
        uuc.date,
        uuc.ocid,
        (champion.el ->> 'champion_slot')::integer   as union_champion__champion_slot,
        badge.ordinality::integer                    as union_champion__champion_badge_info__index,
        badge.el ->> 'stat'                          as union_champion__champion_badge_info__stat  -- schema inferred
    from user_union_champion as uuc,
        lateral jsonb_array_elements(uuc.union_champion) as champion(el),
        lateral jsonb_array_elements(champion.el -> 'champion_badge_info')
            with ordinality as badge(el, ordinality)
),

-- List 3: champion_badge_total_info {stat}, top-level. Always empty in observed data
-- (0 rows); schema inferred from the Nexon OpenAPI definition.
champion_badge_total_info as (
    select
        uuc.date,
        uuc.ocid,
        total_badge.ordinality::integer      as champion_badge_total_info__index,
        total_badge.el ->> 'stat'            as champion_badge_total_info__stat  -- schema inferred
    from user_union_champion as uuc,
        lateral jsonb_array_elements(uuc.champion_badge_total_info)
            with ordinality as total_badge(el, ordinality)
),

-- Stack the three list sections into one column set (null-filled), discriminated by
-- source list column.
all_lists as (
    select
        date,
        ocid,
        union_champion__champion_name,
        union_champion__champion_slot,
        union_champion__champion_class,
        union_champion__champion_grade,
        null::integer   as union_champion__champion_badge_info__index,
        null::text      as union_champion__champion_badge_info__stat,
        null::integer   as champion_badge_total_info__index,
        null::text      as champion_badge_total_info__stat,
        'union_champion' as champion__source
    from union_champion

    union all

    select
        date,
        ocid,
        null::text      as union_champion__champion_name,
        union_champion__champion_slot,
        null::text      as union_champion__champion_class,
        null::text      as union_champion__champion_grade,
        union_champion__champion_badge_info__index,
        union_champion__champion_badge_info__stat,
        null::integer   as champion_badge_total_info__index,
        null::text      as champion_badge_total_info__stat,
        'champion_badge_info' as champion__source
    from union_champion__champion_badge_info

    union all

    select
        date,
        ocid,
        null::text      as union_champion__champion_name,
        null::integer   as union_champion__champion_slot,
        null::text      as union_champion__champion_class,
        null::text      as union_champion__champion_grade,
        null::integer   as union_champion__champion_badge_info__index,
        null::text      as union_champion__champion_badge_info__stat,
        champion_badge_total_info__index,
        champion_badge_total_info__stat,
        'champion_badge_total_info' as champion__source
    from champion_badge_total_info
),

stg_nexon__user_union_champion as (
    select
        spine.date,
        spine.ocid,
        spine.error__name,
        spine.error__message,
        all_lists.union_champion__champion_name,
        all_lists.union_champion__champion_slot,
        all_lists.union_champion__champion_class,
        all_lists.union_champion__champion_grade,
        all_lists.union_champion__champion_badge_info__index,
        all_lists.union_champion__champion_badge_info__stat,
        all_lists.champion_badge_total_info__index,
        all_lists.champion_badge_total_info__stat,
        all_lists.champion__source
    from spine
    left join all_lists using (date, ocid)
)

select * from stg_nexon__user_union_champion
