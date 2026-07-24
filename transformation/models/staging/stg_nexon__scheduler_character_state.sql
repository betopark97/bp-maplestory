with scheduler_character_state as (
    select * from {{ source('nexon', 'scheduler_character_state') }}
),

spine as (
    select
        date,
        ocid,
        character_name,
        world_name,
        character_level::integer,
        character_class,
        weekly_boss_clear_count::integer,
        weekly_boss_clear_limit_count::integer
    from scheduler_character_state
),

daily_contents as (
    select
        date,
        ocid,
        'daily_contents' as contents__source,
        content ->> 'type' as daily_contents__type,
        (content ->> 'max_count')::integer as daily_contents__max_count,
        (content ->> 'now_count')::integer as daily_contents__now_count,
        content ->> 'quest_state' as daily_contents__quest_state,
        content ->> 'content_name' as daily_contents__content_name,
        content ->> 'registration_flag' as daily_contents__registration_flag,
        cast(null as text) as weekly_contents__type,
        cast(null as integer) as weekly_contents__max_count,
        cast(null as integer) as weekly_contents__now_count,
        cast(null as text) as weekly_contents__quest_state,
        cast(null as text) as weekly_contents__content_name,
        cast(null as text) as weekly_contents__registration_flag,
        cast(null as text) as boss_contents__cycle,
        cast(null as text) as boss_contents__difficulty,
        cast(null as text) as boss_contents__content_name,
        cast(null as text) as boss_contents__complete_flag,
        cast(null as integer) as boss_contents__list_order_no,
        cast(null as text) as boss_contents__registration_flag
    from scheduler_character_state,
        lateral jsonb_array_elements(daily_contents) as content
),

weekly_contents as (
    select
        date,
        ocid,
        'weekly_contents' as contents__source,
        cast(null as text) as daily_contents__type,
        cast(null as integer) as daily_contents__max_count,
        cast(null as integer) as daily_contents__now_count,
        cast(null as text) as daily_contents__quest_state,
        cast(null as text) as daily_contents__content_name,
        cast(null as text) as daily_contents__registration_flag,
        content ->> 'type' as weekly_contents__type,
        (content ->> 'max_count')::integer as weekly_contents__max_count,
        (content ->> 'now_count')::integer as weekly_contents__now_count,
        content ->> 'quest_state' as weekly_contents__quest_state,
        content ->> 'content_name' as weekly_contents__content_name,
        content ->> 'registration_flag' as weekly_contents__registration_flag,
        cast(null as text) as boss_contents__cycle,
        cast(null as text) as boss_contents__difficulty,
        cast(null as text) as boss_contents__content_name,
        cast(null as text) as boss_contents__complete_flag,
        cast(null as integer) as boss_contents__list_order_no,
        cast(null as text) as boss_contents__registration_flag
    from scheduler_character_state,
        lateral jsonb_array_elements(weekly_contents) as content
),

boss_contents as (
    select
        date,
        ocid,
        'boss_contents' as contents__source,
        cast(null as text) as daily_contents__type,
        cast(null as integer) as daily_contents__max_count,
        cast(null as integer) as daily_contents__now_count,
        cast(null as text) as daily_contents__quest_state,
        cast(null as text) as daily_contents__content_name,
        cast(null as text) as daily_contents__registration_flag,
        cast(null as text) as weekly_contents__type,
        cast(null as integer) as weekly_contents__max_count,
        cast(null as integer) as weekly_contents__now_count,
        cast(null as text) as weekly_contents__quest_state,
        cast(null as text) as weekly_contents__content_name,
        cast(null as text) as weekly_contents__registration_flag,
        content ->> 'cycle' as boss_contents__cycle,
        content ->> 'difficulty' as boss_contents__difficulty,
        content ->> 'content_name' as boss_contents__content_name,
        content ->> 'complete_flag' as boss_contents__complete_flag,
        (content ->> 'list_order_no')::integer as boss_contents__list_order_no,
        content ->> 'registration_flag' as boss_contents__registration_flag
    from scheduler_character_state,
        lateral jsonb_array_elements(boss_contents) as content
),

all_lists as (
    select * from daily_contents
    union all
    select * from weekly_contents
    union all
    select * from boss_contents
),

stg_nexon__scheduler_character_state as (
    select
        spine.date,
        spine.ocid,
        spine.character_name,
        spine.world_name,
        spine.character_level,
        spine.character_class,
        spine.weekly_boss_clear_count,
        spine.weekly_boss_clear_limit_count,
        all_lists.contents__source,
        all_lists.daily_contents__type,
        all_lists.daily_contents__max_count,
        all_lists.daily_contents__now_count,
        all_lists.daily_contents__quest_state,
        all_lists.daily_contents__content_name,
        all_lists.daily_contents__registration_flag,
        all_lists.weekly_contents__type,
        all_lists.weekly_contents__max_count,
        all_lists.weekly_contents__now_count,
        all_lists.weekly_contents__quest_state,
        all_lists.weekly_contents__content_name,
        all_lists.weekly_contents__registration_flag,
        all_lists.boss_contents__cycle,
        all_lists.boss_contents__difficulty,
        all_lists.boss_contents__content_name,
        all_lists.boss_contents__complete_flag,
        all_lists.boss_contents__list_order_no,
        all_lists.boss_contents__registration_flag
    from spine
    left join all_lists using (date, ocid)
)

select * from stg_nexon__scheduler_character_state
