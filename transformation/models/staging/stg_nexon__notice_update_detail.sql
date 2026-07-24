with notice_update_detail as (
    select * from {{ source('nexon', 'notice_update_detail') }}
),

stg_nexon__notice_update_detail as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        date::timestamptz
    from notice_update_detail
)

select * from stg_nexon__notice_update_detail
