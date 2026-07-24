with notice_event_detail as (
    select * from {{ source('nexon', 'notice_event_detail') }}
),

stg_nexon__notice_event_detail as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        date::timestamptz,
        date_event_start::timestamptz,
        date_event_end::timestamptz
    from notice_event_detail
)

select * from stg_nexon__notice_event_detail
