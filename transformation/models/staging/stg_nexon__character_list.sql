{% set character_list = source('nexon', 'character_list') %}

with stg_nexon__character_list as (
    select
        al ->> 'account_id' as account_id,
        cl ->> 'ocid' as ocid,
        cl ->> 'world_name' as world_name,
        cl ->> 'character_name' as character_name,
        cl ->> 'character_class' as character_class,
        (cl ->> 'character_level')::int as character_level
    from {{ character_list }},
        lateral jsonb_array_elements(account_list) as al,
        lateral jsonb_array_elements(account_list -> 'character_list') as cl
)

select * from stg_nexon__character_list
