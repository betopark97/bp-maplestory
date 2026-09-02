with notice_cashshop_detail as (
    select
        *,
        date as posted_at
    from {{ source('nexon', 'notice_cashshop_detail') }}
),

stg_nexon__cashshop_notice_details as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        posted_at::timestamptz,
        date_sale_start::timestamptz,
        date_sale_end::timestamptz,
        ongoing_flag::boolean as is_ongoing
    from notice_cashshop_detail
)

select * from stg_nexon__cashshop_notice_details
