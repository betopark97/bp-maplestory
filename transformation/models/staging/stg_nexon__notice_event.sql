with notice_event as (
    select * from {{ source('nexon', 'notice_event') }}
),

stg_nexon__notice_event as (
    select
        title,
        url,
        thumbnail_url,
        notice_id::bigint,
        date::timestamptz,
        date_event_start::timestamptz,
        date_event_end::timestamptz
    from notice_event
)

select * from stg_nexon__notice_event
