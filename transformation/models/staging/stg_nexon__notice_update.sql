with notice_update as (
    select * from {{ source('nexon', 'notice_update') }}
),

stg_nexon__notice_update as (
    select
        title,
        url,
        notice_id::bigint,
        date::timestamptz
    from notice_update
)

select * from stg_nexon__notice_update
