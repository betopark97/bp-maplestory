with notice_cashshop as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_cashshop') }}
),

stg_nexon__cashshop_notices as (
    select
        title,
        url,
        thumbnail_url,
        notice_id::bigint,
        posted_at::timestamptz,
        date_sale_start::timestamptz,
        date_sale_end::timestamptz,
        ongoing_flag::boolean as is_ongoing
    from notice_cashshop
)

select * from stg_nexon__cashshop_notices
