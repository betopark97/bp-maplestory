with notice_event_detail as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_event_detail') }}
),

stg_nexon__event_notice_details as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        posted_at::timestamptz,
        date_event_start::timestamptz,
        date_event_end::timestamptz
    from notice_event_detail
)

select * from stg_nexon__event_notice_details
