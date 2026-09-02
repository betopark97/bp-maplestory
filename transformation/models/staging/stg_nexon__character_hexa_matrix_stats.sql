with character_hexamatrix_stat as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_hexamatrix_stat') }}
),

spine as (
    select
        snapshot_date,
        ocid,
        character_class
    from character_hexamatrix_stat
),

character_hexa_stat_core as (
    select
        snapshot_date,
        ocid,
        'character_hexa_stat_core' as hexa_stat_core__source,
        core ->> 'slot_id' as hexa_stat_core__slot_id,
        core ->> 'stat_grade' as hexa_stat_core__stat_grade,
        core ->> 'main_stat_name' as hexa_stat_core__main_stat_name,
        (core ->> 'main_stat_level')::integer as hexa_stat_core__main_stat_level,
        core ->> 'sub_stat_name_1' as hexa_stat_core__sub_stat_name_1,
        (core ->> 'sub_stat_level_1')::integer as hexa_stat_core__sub_stat_level_1,
        core ->> 'sub_stat_name_2' as hexa_stat_core__sub_stat_name_2,
        (core ->> 'sub_stat_level_2')::integer as hexa_stat_core__sub_stat_level_2
    from character_hexamatrix_stat,
        lateral jsonb_array_elements(character_hexa_stat_core) as core
),

character_hexa_stat_core_2 as (
    select
        snapshot_date,
        ocid,
        'character_hexa_stat_core_2' as hexa_stat_core__source,
        core ->> 'slot_id' as hexa_stat_core__slot_id,
        core ->> 'stat_grade' as hexa_stat_core__stat_grade,
        core ->> 'main_stat_name' as hexa_stat_core__main_stat_name,
        (core ->> 'main_stat_level')::integer as hexa_stat_core__main_stat_level,
        core ->> 'sub_stat_name_1' as hexa_stat_core__sub_stat_name_1,
        (core ->> 'sub_stat_level_1')::integer as hexa_stat_core__sub_stat_level_1,
        core ->> 'sub_stat_name_2' as hexa_stat_core__sub_stat_name_2,
        (core ->> 'sub_stat_level_2')::integer as hexa_stat_core__sub_stat_level_2
    from character_hexamatrix_stat,
        lateral jsonb_array_elements(character_hexa_stat_core_2) as core
),

character_hexa_stat_core_3 as (
    select
        snapshot_date,
        ocid,
        'character_hexa_stat_core_3' as hexa_stat_core__source,
        core ->> 'slot_id' as hexa_stat_core__slot_id,
        core ->> 'stat_grade' as hexa_stat_core__stat_grade,
        core ->> 'main_stat_name' as hexa_stat_core__main_stat_name,
        (core ->> 'main_stat_level')::integer as hexa_stat_core__main_stat_level,
        core ->> 'sub_stat_name_1' as hexa_stat_core__sub_stat_name_1,
        (core ->> 'sub_stat_level_1')::integer as hexa_stat_core__sub_stat_level_1,
        core ->> 'sub_stat_name_2' as hexa_stat_core__sub_stat_name_2,
        (core ->> 'sub_stat_level_2')::integer as hexa_stat_core__sub_stat_level_2
    from character_hexamatrix_stat,
        lateral jsonb_array_elements(character_hexa_stat_core_3) as core
),

preset_hexa_stat_core as (
    select
        snapshot_date,
        ocid,
        'preset_hexa_stat_core' as hexa_stat_core__source,
        core ->> 'slot_id' as hexa_stat_core__slot_id,
        core ->> 'stat_grade' as hexa_stat_core__stat_grade,
        core ->> 'main_stat_name' as hexa_stat_core__main_stat_name,
        (core ->> 'main_stat_level')::integer as hexa_stat_core__main_stat_level,
        core ->> 'sub_stat_name_1' as hexa_stat_core__sub_stat_name_1,
        (core ->> 'sub_stat_level_1')::integer as hexa_stat_core__sub_stat_level_1,
        core ->> 'sub_stat_name_2' as hexa_stat_core__sub_stat_name_2,
        (core ->> 'sub_stat_level_2')::integer as hexa_stat_core__sub_stat_level_2
    from character_hexamatrix_stat,
        lateral jsonb_array_elements(preset_hexa_stat_core) as core
),

preset_hexa_stat_core_2 as (
    select
        snapshot_date,
        ocid,
        'preset_hexa_stat_core_2' as hexa_stat_core__source,
        core ->> 'slot_id' as hexa_stat_core__slot_id,
        core ->> 'stat_grade' as hexa_stat_core__stat_grade,
        core ->> 'main_stat_name' as hexa_stat_core__main_stat_name,
        (core ->> 'main_stat_level')::integer as hexa_stat_core__main_stat_level,
        core ->> 'sub_stat_name_1' as hexa_stat_core__sub_stat_name_1,
        (core ->> 'sub_stat_level_1')::integer as hexa_stat_core__sub_stat_level_1,
        core ->> 'sub_stat_name_2' as hexa_stat_core__sub_stat_name_2,
        (core ->> 'sub_stat_level_2')::integer as hexa_stat_core__sub_stat_level_2
    from character_hexamatrix_stat,
        lateral jsonb_array_elements(preset_hexa_stat_core_2) as core
),

preset_hexa_stat_core_3 as (
    select
        snapshot_date,
        ocid,
        'preset_hexa_stat_core_3' as hexa_stat_core__source,
        core ->> 'slot_id' as hexa_stat_core__slot_id,
        core ->> 'stat_grade' as hexa_stat_core__stat_grade,
        core ->> 'main_stat_name' as hexa_stat_core__main_stat_name,
        (core ->> 'main_stat_level')::integer as hexa_stat_core__main_stat_level,
        core ->> 'sub_stat_name_1' as hexa_stat_core__sub_stat_name_1,
        (core ->> 'sub_stat_level_1')::integer as hexa_stat_core__sub_stat_level_1,
        core ->> 'sub_stat_name_2' as hexa_stat_core__sub_stat_name_2,
        (core ->> 'sub_stat_level_2')::integer as hexa_stat_core__sub_stat_level_2
    from character_hexamatrix_stat,
        lateral jsonb_array_elements(preset_hexa_stat_core_3) as core
),

all_lists as (
    select * from character_hexa_stat_core
    union all
    select * from character_hexa_stat_core_2
    union all
    select * from character_hexa_stat_core_3
    union all
    select * from preset_hexa_stat_core
    union all
    select * from preset_hexa_stat_core_2
    union all
    select * from preset_hexa_stat_core_3
),

stg_nexon__character_hexa_matrix_stats as (
    select
        spine.snapshot_date,
        spine.ocid,
        spine.character_class,
        all_lists.hexa_stat_core__source,
        all_lists.hexa_stat_core__slot_id,
        all_lists.hexa_stat_core__stat_grade,
        all_lists.hexa_stat_core__main_stat_name,
        all_lists.hexa_stat_core__main_stat_level,
        all_lists.hexa_stat_core__sub_stat_name_1,
        all_lists.hexa_stat_core__sub_stat_level_1,
        all_lists.hexa_stat_core__sub_stat_name_2,
        all_lists.hexa_stat_core__sub_stat_level_2
    from spine
    left join all_lists using (snapshot_date, ocid)
)

select * from stg_nexon__character_hexa_matrix_stats
