with notice_event as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_event') }}
),

stg_nexon__event_notices as (
    select
        title,
        url,
        thumbnail_url,
        notice_id::bigint,
        posted_at::timestamptz,
        date_event_start::timestamptz,
        date_event_end::timestamptz
    from notice_event
)

select * from stg_nexon__event_notices
