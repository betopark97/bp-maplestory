with notice_update_detail as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_update_detail') }}
),

stg_nexon__update_notice_details as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        posted_at::timestamptz
    from notice_update_detail
)

select * from stg_nexon__update_notice_details
