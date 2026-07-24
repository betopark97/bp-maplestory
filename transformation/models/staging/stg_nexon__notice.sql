with notice as (
    select * from {{ source('nexon', 'notice') }}
),

stg_nexon__notice as (
    select
        title,
        url,
        notice_id::bigint,
        date::timestamptz
    from notice
)

select * from stg_nexon__notice
