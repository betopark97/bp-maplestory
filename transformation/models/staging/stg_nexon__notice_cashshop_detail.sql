with notice_cashshop_detail as (
    select * from {{ source('nexon', 'notice_cashshop_detail') }}
),

stg_nexon__notice_cashshop_detail as (
    select
        notice_id::bigint,
        title,
        url,
        contents,
        date::timestamptz,
        date_sale_start::timestamptz,
        date_sale_end::timestamptz,
        ongoing_flag::boolean
    from notice_cashshop_detail
)

select * from stg_nexon__notice_cashshop_detail
