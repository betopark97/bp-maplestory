with notice_detail as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_detail') }}
),

stg_nexon__notice_details as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        posted_at::timestamptz
    from notice_detail
)

select * from stg_nexon__notice_details
