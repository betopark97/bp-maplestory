with stg_nexon__character_list as (
    select
        account_list__account_id as account_id,
        ocid
    from {{ ref('stg_nexon__character_list') }}
),

stg_nexon__character_basic as (
    select
        date,
        ocid,
        character_name,
        world_name,
        character_gender,
        character_date_create
    from {{ ref('stg_nexon__character_basic') }}
),

dim_character__details as (
    select
        distinct on (cb.ocid)
        {{ dbt_utils.generate_surrogate_key(['cb.ocid']) }} AS character__details_key,
        cl.account_id,
        cb.ocid,
        cb.character_name,
        cb.world_name,
        cb.character_gender,
        cb.character_date_create
    from stg_nexon__character_list as cl
    left join stg_nexon__character_basic as cb
        on cl.ocid = cb.ocid
    order by cb.ocid, cb.date
)

select * from dim_character__details
