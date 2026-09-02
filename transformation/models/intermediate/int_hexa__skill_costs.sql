with stg_object_storage__hexa_skill_costs as (

    select
        level_up,
        skill_core__sol_erda,
        skill_core__sol_erda_fragment,
        third_skill_core__sol_erda,
        third_skill_core__sol_erda_fragment,
        mastery_core__sol_erda,
        mastery_core__sol_erda_fragment,
        enhancement_core__sol_erda,
        enhancement_core__sol_erda_fragment,
        common_core__sol_erda,
        common_core__sol_erda_fragment,
        class_common_core__sol_erda,
        class_common_core__sol_erda_fragment

    from {{ ref('stg_object_storage__hexa_skill_costs') }}

),

int_hexa__skill_costs as (

    select
        unpivoted.core_type,
        stg_object_storage__hexa_skill_costs.level_up,
        unpivoted.sol_erda,
        unpivoted.sol_erda_fragment

    from stg_object_storage__hexa_skill_costs
    cross join lateral (
        values
            (
                'skill_core',
                skill_core__sol_erda,
                skill_core__sol_erda_fragment
            ),
            (
                'third_skill_core',
                third_skill_core__sol_erda,
                third_skill_core__sol_erda_fragment
            ),
            (
                'mastery_core',
                mastery_core__sol_erda,
                mastery_core__sol_erda_fragment
            ),
            (
                'enhancement_core',
                enhancement_core__sol_erda,
                enhancement_core__sol_erda_fragment
            ),
            (
                'common_core',
                common_core__sol_erda,
                common_core__sol_erda_fragment
            ),
            (
                'class_common_core',
                class_common_core__sol_erda,
                class_common_core__sol_erda_fragment
            )
    ) as unpivoted (core_type, sol_erda, sol_erda_fragment)

)

select * from int_hexa__skill_costs
