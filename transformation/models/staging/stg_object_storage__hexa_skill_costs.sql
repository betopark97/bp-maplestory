with hexa_skill_cost as (
    select * from {{ source('object_storage', 'hexa_skill_cost') }}
),

stg_object_storage__hexa_skill_costs as (
    select
        "레벨" as level_up,
        "스킬_코어__솔_에르다" as skill_core__sol_erda,
        "스킬_코어__솔_에르다_조각" as skill_core__sol_erda_fragment,
        "3rd_스킬_코어__솔_에르다" as third_skill_core__sol_erda,
        "3rd_스킬_코어__솔_에르다_조각" as third_skill_core__sol_erda_fragment,
        "마스터리_코어__솔_에르다" as mastery_core__sol_erda,
        "마스터리_코어__솔_에르다_조각" as mastery_core__sol_erda_fragment,
        "강화_코어__솔_에르다" as enhancement_core__sol_erda,
        "강화_코어__솔_에르다_조각" as enhancement_core__sol_erda_fragment,
        "공용_코어__솔_에르다" as common_core__sol_erda,
        "공용_코어__솔_에르다_조각" as common_core__sol_erda_fragment,
        "직업군_공용_코어__솔_에르다" as class_common_core__sol_erda,
        "직업군_공용_코어__솔_에르다_조각" as class_common_core__sol_erda_fragment,
        content_hash,
        fetched_at
    from hexa_skill_cost
)

select * from stg_object_storage__hexa_skill_costs
