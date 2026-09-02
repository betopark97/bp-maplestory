with notice_update as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_update') }}
),

stg_nexon__update_notices as (
    select
        title,
        url,
        notice_id::bigint,
        posted_at::timestamptz
    from notice_update
)

select * from stg_nexon__update_notices
