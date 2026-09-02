with image as (
    select * from {{ source('object_storage', 'image') }}
),

stg_object_storage__images as (
    select
        object_key,
        relative_path,
        file_name,
        content_type,
        size_in_bytes::bigint,
        modification_date::timestamptz
    from image
)

select * from stg_object_storage__images
