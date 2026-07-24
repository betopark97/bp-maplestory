with notice_detail as (
    select * from {{ source('nexon', 'notice_detail') }}
),

stg_nexon__notice_detail as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        date::timestamptz
    from notice_detail
)

select * from stg_nexon__notice_detail
