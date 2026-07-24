with user_union as (
    select * from {{ source('nexon', 'user_union') }}
),

stg_nexon__user_union as (
    select
        date::date,
        ocid,
        union_level::integer,
        union_grade,
        union_artifact_level::integer,
        union_artifact_exp::bigint,
        union_artifact_point::integer
    from user_union
)

select * from stg_nexon__user_union
