with user_achievement as (
    select * from {{ source('nexon', 'user_achievement') }}
),

stg_nexon__user_achievements as (
    select
        al ->> 'account_id' as account_list__account_id,
        aa ->> 'achievement_name' as account_list__achievement_achieve__achievement_name,
        aa ->> 'achievement_description' as account_list__achievement_achieve__achievement_description
    from user_achievement,
        lateral jsonb_array_elements(account_list) as al,
        lateral jsonb_array_elements(al -> 'achievement_achieve') as aa
)

select * from stg_nexon__user_achievements
