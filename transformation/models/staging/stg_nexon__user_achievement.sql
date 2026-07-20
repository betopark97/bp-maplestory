with source as (
    select * from {{ source('nexon', 'user_achievement') }}
),

renamed as (
    select
        account_list
    from source
)

select * from renamed
