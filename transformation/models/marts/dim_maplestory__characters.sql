with stg_nexon__characters as (
    select
        account_list__account_id as account_id,
        ocid
    from {{ ref('stg_nexon__characters') }}
),

stg_nexon__character_profiles as (
    select
        snapshot_date,
        ocid,
        character_name,
        world_name,
        character_gender,
        character_date_create
    from {{ ref('stg_nexon__character_profiles') }}
),

dim_maplestory__characters as (
    select
        distinct on (cb.ocid)
        {{ dbt_utils.generate_surrogate_key(['cb.ocid']) }} AS character_id,
        cl.account_id,
        cb.ocid,
        cb.character_name,
        cb.world_name,
        cb.character_gender,
        cb.character_date_create
    from stg_nexon__characters as cl
    left join stg_nexon__character_profiles as cb
        on cl.ocid = cb.ocid
    order by cb.ocid, cb.snapshot_date
)

select * from dim_maplestory__characters
