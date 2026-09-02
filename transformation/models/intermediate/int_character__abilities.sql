with stg_nexon__character_abilities as (
    select * from {{ ref('stg_nexon__character_abilities') }}
),

int_character__abilities as (
    select
        snapshot_date,
        ocid,
        ability_no,
        ability_preset_1__ability_info__ability_grade as preset_1_grade,
        ability_preset_1__ability_info__ability_value as preset_1_value,
        ability_preset_2__ability_info__ability_grade as preset_2_grade,
        ability_preset_2__ability_info__ability_value as preset_2_value,
        ability_preset_3__ability_info__ability_grade as preset_3_grade,
        ability_preset_3__ability_info__ability_value as preset_3_value,
        remain_fame
    from stg_nexon__character_abilities
)

select * from int_character__abilities
