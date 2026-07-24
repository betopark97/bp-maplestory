with notice_cashshop as (
    select * from {{ source('nexon', 'notice_cashshop') }}
),

stg_nexon__notice_cashshop as (
    select
        title,
        url,
        thumbnail_url,
        notice_id::bigint,
        date::timestamptz,
        date_sale_start::timestamptz,
        date_sale_end::timestamptz,
        ongoing_flag::boolean
    from notice_cashshop
)

select * from stg_nexon__notice_cashshop
