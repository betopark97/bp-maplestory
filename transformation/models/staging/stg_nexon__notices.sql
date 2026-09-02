with notice as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice') }}
),

stg_nexon__notices as (
    select
        title,
        url,
        notice_id::bigint,
        posted_at::timestamptz
    from notice
)

select * from stg_nexon__notices
