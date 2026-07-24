with user_union_raider as (
    select * from {{ source('nexon', 'user_union_raider') }}
),

-- One row per (date, ocid): the scalar spine every list section hangs off.
spine as (
    select
        date,
        ocid,
        use_preset_no::integer,
        union_max_point::integer
    from user_union_raider
),

-- Section 1: active inner stats + their 5 presets, kept WIDE.
-- Array of {stat_field_id, stat_field_effect}. stat_field_id is the natural key
-- shared with every preset, so it drives the grain (FULL JOIN, presets never stacked).
union_inner_stat__active as (
    select
        date,
        ocid,
        el ->> 'stat_field_id'     as union_inner_stat__stat_field_id,
        el ->> 'stat_field_effect' as union_inner_stat__stat_field_effect
    from user_union_raider,
        lateral jsonb_array_elements(union_inner_stat) as el
),

union_raider_preset_1__union_inner_stat as (
    select
        date,
        ocid,
        el ->> 'stat_field_id'     as union_inner_stat__stat_field_id,
        el ->> 'stat_field_effect' as union_raider_preset_1__union_inner_stat__stat_field_effect
    from user_union_raider,
        lateral jsonb_array_elements(union_raider_preset_1 -> 'union_inner_stat') as el
),

union_raider_preset_2__union_inner_stat as (
    select
        date,
        ocid,
        el ->> 'stat_field_id'     as union_inner_stat__stat_field_id,
        el ->> 'stat_field_effect' as union_raider_preset_2__union_inner_stat__stat_field_effect
    from user_union_raider,
        lateral jsonb_array_elements(union_raider_preset_2 -> 'union_inner_stat') as el
),

union_raider_preset_3__union_inner_stat as (
    select
        date,
        ocid,
        el ->> 'stat_field_id'     as union_inner_stat__stat_field_id,
        el ->> 'stat_field_effect' as union_raider_preset_3__union_inner_stat__stat_field_effect
    from user_union_raider,
        lateral jsonb_array_elements(union_raider_preset_3 -> 'union_inner_stat') as el
),

union_raider_preset_4__union_inner_stat as (
    select
        date,
        ocid,
        el ->> 'stat_field_id'     as union_inner_stat__stat_field_id,
        el ->> 'stat_field_effect' as union_raider_preset_4__union_inner_stat__stat_field_effect
    from user_union_raider,
        lateral jsonb_array_elements(union_raider_preset_4 -> 'union_inner_stat') as el
),

union_raider_preset_5__union_inner_stat as (
    select
        date,
        ocid,
        el ->> 'stat_field_id'     as union_inner_stat__stat_field_id,
        el ->> 'stat_field_effect' as union_raider_preset_5__union_inner_stat__stat_field_effect
    from user_union_raider,
        lateral jsonb_array_elements(union_raider_preset_5 -> 'union_inner_stat') as el
),

union_inner_stat as (
    select
        date,
        ocid,
        union_inner_stat__stat_field_id,
        union_inner_stat__stat_field_effect,
        union_raider_preset_1__union_inner_stat__stat_field_effect,
        union_raider_preset_2__union_inner_stat__stat_field_effect,
        union_raider_preset_3__union_inner_stat__stat_field_effect,
        union_raider_preset_4__union_inner_stat__stat_field_effect,
        union_raider_preset_5__union_inner_stat__stat_field_effect
    from union_inner_stat__active
    full join union_raider_preset_1__union_inner_stat using (date, ocid, union_inner_stat__stat_field_id)
    full join union_raider_preset_2__union_inner_stat using (date, ocid, union_inner_stat__stat_field_id)
    full join union_raider_preset_3__union_inner_stat using (date, ocid, union_inner_stat__stat_field_id)
    full join union_raider_preset_4__union_inner_stat using (date, ocid, union_inner_stat__stat_field_id)
    full join union_raider_preset_5__union_inner_stat using (date, ocid, union_inner_stat__stat_field_id)
),

-- Section 2: active raider stats, array of scalar effect strings.
union_raider_stat as (
    select
        date,
        ocid,
        stat.ordinality as union_raider_stat__index,
        stat.value      as union_raider_stat__value
    from user_union_raider,
        lateral jsonb_array_elements_text(union_raider_stat) with ordinality as stat(value, ordinality)
),

-- Section 3: active state stats, array of scalar effect strings.
union_state_stat as (
    select
        date,
        ocid,
        stat.ordinality as union_state_stat__index,
        stat.value      as union_state_stat__value
    from user_union_raider,
        lateral jsonb_array_elements_text(union_state_stat) with ordinality as stat(value, ordinality)
),

-- Section 4: state stat presets, outer array of {preset_no, union_state_stat:[scalar strings]}.
-- Double unnest: outer preset array, then the inner scalar-string array.
union_state_stat_preset as (
    select
        date,
        ocid,
        (preset.value ->> 'preset_no')::integer as union_state_stat_preset__preset_no,
        stat.ordinality                         as union_state_stat_preset__union_state_stat__index,
        stat.value                              as union_state_stat_preset__union_state_stat__value
    from user_union_raider,
        lateral jsonb_array_elements(union_state_stat_preset) as preset,
        lateral jsonb_array_elements_text(preset.value -> 'union_state_stat')
            with ordinality as stat(value, ordinality)
),

-- Section 5: union blocks -- schema inferred, empty in current data.
-- Array of blocks per Nexon OpenAPI schema; block_position is a nested {x, y} array.
union_block as (
    select
        date,
        ocid,
        block.value ->> 'block_type'                  as union_block__block_type,
        block.value ->> 'block_class'                 as union_block__block_class,
        (block.value ->> 'block_level')::integer      as union_block__block_level,
        block.value -> 'block_control_point' ->> 'x'  as union_block__block_control_point__x,
        block.value -> 'block_control_point' ->> 'y'  as union_block__block_control_point__y,
        pos.ordinality                                as union_block__block_position__index,
        pos.value ->> 'x'                             as union_block__block_position__x,
        pos.value ->> 'y'                             as union_block__block_position__y
    from user_union_raider,
        lateral jsonb_array_elements(union_block) as block,
        lateral jsonb_array_elements(block.value -> 'block_position')
            with ordinality as pos(value, ordinality)
),

-- Section 6: occupied stats, array of scalar effect strings -- empty in current data.
union_occupied_stat as (
    select
        date,
        ocid,
        stat.ordinality as union_occupied_stat__index,
        stat.value      as union_occupied_stat__value
    from user_union_raider,
        lateral jsonb_array_elements_text(union_occupied_stat) with ordinality as stat(value, ordinality)
),

-- Stack every list section into one shared column superset, tagged by source list.
all_lists as (
    select
        date,
        ocid,
        'union_inner_stat' as raider__source,
        union_inner_stat__stat_field_id,
        union_inner_stat__stat_field_effect,
        union_raider_preset_1__union_inner_stat__stat_field_effect,
        union_raider_preset_2__union_inner_stat__stat_field_effect,
        union_raider_preset_3__union_inner_stat__stat_field_effect,
        union_raider_preset_4__union_inner_stat__stat_field_effect,
        union_raider_preset_5__union_inner_stat__stat_field_effect,
        null::bigint  as union_raider_stat__index,
        null::text    as union_raider_stat__value,
        null::bigint  as union_state_stat__index,
        null::text    as union_state_stat__value,
        null::integer as union_state_stat_preset__preset_no,
        null::bigint  as union_state_stat_preset__union_state_stat__index,
        null::text    as union_state_stat_preset__union_state_stat__value,
        null::text    as union_block__block_type,
        null::text    as union_block__block_class,
        null::integer as union_block__block_level,
        null::text    as union_block__block_control_point__x,
        null::text    as union_block__block_control_point__y,
        null::bigint  as union_block__block_position__index,
        null::text    as union_block__block_position__x,
        null::text    as union_block__block_position__y,
        null::bigint  as union_occupied_stat__index,
        null::text    as union_occupied_stat__value
    from union_inner_stat

    union all

    select
        date,
        ocid,
        'union_raider_stat' as raider__source,
        null::text as union_inner_stat__stat_field_id,
        null::text as union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_1__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_2__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_3__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_4__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_5__union_inner_stat__stat_field_effect,
        union_raider_stat__index,
        union_raider_stat__value,
        null::bigint  as union_state_stat__index,
        null::text    as union_state_stat__value,
        null::integer as union_state_stat_preset__preset_no,
        null::bigint  as union_state_stat_preset__union_state_stat__index,
        null::text    as union_state_stat_preset__union_state_stat__value,
        null::text    as union_block__block_type,
        null::text    as union_block__block_class,
        null::integer as union_block__block_level,
        null::text    as union_block__block_control_point__x,
        null::text    as union_block__block_control_point__y,
        null::bigint  as union_block__block_position__index,
        null::text    as union_block__block_position__x,
        null::text    as union_block__block_position__y,
        null::bigint  as union_occupied_stat__index,
        null::text    as union_occupied_stat__value
    from union_raider_stat

    union all

    select
        date,
        ocid,
        'union_state_stat' as raider__source,
        null::text as union_inner_stat__stat_field_id,
        null::text as union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_1__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_2__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_3__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_4__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_5__union_inner_stat__stat_field_effect,
        null::bigint as union_raider_stat__index,
        null::text   as union_raider_stat__value,
        union_state_stat__index,
        union_state_stat__value,
        null::integer as union_state_stat_preset__preset_no,
        null::bigint  as union_state_stat_preset__union_state_stat__index,
        null::text    as union_state_stat_preset__union_state_stat__value,
        null::text    as union_block__block_type,
        null::text    as union_block__block_class,
        null::integer as union_block__block_level,
        null::text    as union_block__block_control_point__x,
        null::text    as union_block__block_control_point__y,
        null::bigint  as union_block__block_position__index,
        null::text    as union_block__block_position__x,
        null::text    as union_block__block_position__y,
        null::bigint  as union_occupied_stat__index,
        null::text    as union_occupied_stat__value
    from union_state_stat

    union all

    select
        date,
        ocid,
        'union_state_stat_preset' as raider__source,
        null::text as union_inner_stat__stat_field_id,
        null::text as union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_1__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_2__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_3__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_4__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_5__union_inner_stat__stat_field_effect,
        null::bigint as union_raider_stat__index,
        null::text   as union_raider_stat__value,
        null::bigint as union_state_stat__index,
        null::text   as union_state_stat__value,
        union_state_stat_preset__preset_no,
        union_state_stat_preset__union_state_stat__index,
        union_state_stat_preset__union_state_stat__value,
        null::text    as union_block__block_type,
        null::text    as union_block__block_class,
        null::integer as union_block__block_level,
        null::text    as union_block__block_control_point__x,
        null::text    as union_block__block_control_point__y,
        null::bigint  as union_block__block_position__index,
        null::text    as union_block__block_position__x,
        null::text    as union_block__block_position__y,
        null::bigint  as union_occupied_stat__index,
        null::text    as union_occupied_stat__value
    from union_state_stat_preset

    union all

    select
        date,
        ocid,
        'union_block' as raider__source,
        null::text as union_inner_stat__stat_field_id,
        null::text as union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_1__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_2__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_3__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_4__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_5__union_inner_stat__stat_field_effect,
        null::bigint as union_raider_stat__index,
        null::text   as union_raider_stat__value,
        null::bigint as union_state_stat__index,
        null::text   as union_state_stat__value,
        null::integer as union_state_stat_preset__preset_no,
        null::bigint  as union_state_stat_preset__union_state_stat__index,
        null::text    as union_state_stat_preset__union_state_stat__value,
        union_block__block_type,
        union_block__block_class,
        union_block__block_level,
        union_block__block_control_point__x,
        union_block__block_control_point__y,
        union_block__block_position__index,
        union_block__block_position__x,
        union_block__block_position__y,
        null::bigint as union_occupied_stat__index,
        null::text   as union_occupied_stat__value
    from union_block

    union all

    select
        date,
        ocid,
        'union_occupied_stat' as raider__source,
        null::text as union_inner_stat__stat_field_id,
        null::text as union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_1__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_2__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_3__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_4__union_inner_stat__stat_field_effect,
        null::text as union_raider_preset_5__union_inner_stat__stat_field_effect,
        null::bigint as union_raider_stat__index,
        null::text   as union_raider_stat__value,
        null::bigint as union_state_stat__index,
        null::text   as union_state_stat__value,
        null::integer as union_state_stat_preset__preset_no,
        null::bigint  as union_state_stat_preset__union_state_stat__index,
        null::text    as union_state_stat_preset__union_state_stat__value,
        null::text    as union_block__block_type,
        null::text    as union_block__block_class,
        null::integer as union_block__block_level,
        null::text    as union_block__block_control_point__x,
        null::text    as union_block__block_control_point__y,
        null::bigint  as union_block__block_position__index,
        null::text    as union_block__block_position__x,
        null::text    as union_block__block_position__y,
        union_occupied_stat__index,
        union_occupied_stat__value
    from union_occupied_stat
),

stg_nexon__user_union_raider as (
    select
        date,
        ocid,
        use_preset_no,
        union_max_point,
        raider__source,
        union_inner_stat__stat_field_id,
        union_inner_stat__stat_field_effect,
        union_raider_preset_1__union_inner_stat__stat_field_effect,
        union_raider_preset_2__union_inner_stat__stat_field_effect,
        union_raider_preset_3__union_inner_stat__stat_field_effect,
        union_raider_preset_4__union_inner_stat__stat_field_effect,
        union_raider_preset_5__union_inner_stat__stat_field_effect,
        union_raider_stat__index,
        union_raider_stat__value,
        union_state_stat__index,
        union_state_stat__value,
        union_state_stat_preset__preset_no,
        union_state_stat_preset__union_state_stat__index,
        union_state_stat_preset__union_state_stat__value,
        union_block__block_type,
        union_block__block_class,
        union_block__block_level,
        union_block__block_control_point__x,
        union_block__block_control_point__y,
        union_block__block_position__index,
        union_block__block_position__x,
        union_block__block_position__y,
        union_occupied_stat__index,
        union_occupied_stat__value
    from spine
    left join all_lists using (date, ocid)
)

select * from stg_nexon__user_union_raider
