with character_vmatrix as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_vmatrix') }}
),

vce as (
    select
        snapshot_date,
        ocid,
        (vce ->> 'slot_id')::integer as slot_id,
        vce ->> 'v_core_type'        as v_core_type,
        (vce ->> 'slot_level')::integer as slot_level,
        vce ->> 'v_core_name'        as v_core_name,
        (vce ->> 'v_core_level')::integer as v_core_level,
        vce ->> 'v_core_skill_1'     as v_core_skill_1,
        vce ->> 'v_core_skill_2'     as v_core_skill_2,
        vce ->> 'v_core_skill_3'     as v_core_skill_3
    from character_vmatrix,
        lateral jsonb_array_elements(character_v_core_equipment) as vce
),

vcep1 as (
    select
        snapshot_date,
        ocid,
        (vcep1 ->> 'slot_id')::integer as slot_id,
        vcep1 ->> 'v_core_type'        as v_core_type,
        (vcep1 ->> 'slot_level')::integer as slot_level,
        vcep1 ->> 'v_core_name'        as v_core_name,
        (vcep1 ->> 'v_core_level')::integer as v_core_level,
        vcep1 ->> 'v_core_skill_1'     as v_core_skill_1,
        vcep1 ->> 'v_core_skill_2'     as v_core_skill_2,
        vcep1 ->> 'v_core_skill_3'     as v_core_skill_3
    from character_vmatrix,
        lateral jsonb_array_elements(character_v_core_equipment_preset_1) as vcep1
),

vcep2 as (
    select
        snapshot_date,
        ocid,
        (vcep2 ->> 'slot_id')::integer as slot_id,
        vcep2 ->> 'v_core_type'        as v_core_type,
        (vcep2 ->> 'slot_level')::integer as slot_level,
        vcep2 ->> 'v_core_name'        as v_core_name,
        (vcep2 ->> 'v_core_level')::integer as v_core_level,
        vcep2 ->> 'v_core_skill_1'     as v_core_skill_1,
        vcep2 ->> 'v_core_skill_2'     as v_core_skill_2,
        vcep2 ->> 'v_core_skill_3'     as v_core_skill_3
    from character_vmatrix,
        lateral jsonb_array_elements(character_v_core_equipment_preset_2) as vcep2
),

vcep3 as (
    select
        snapshot_date,
        ocid,
        (vcep3 ->> 'slot_id')::integer as slot_id,
        vcep3 ->> 'v_core_type'        as v_core_type,
        (vcep3 ->> 'slot_level')::integer as slot_level,
        vcep3 ->> 'v_core_name'        as v_core_name,
        (vcep3 ->> 'v_core_level')::integer as v_core_level,
        vcep3 ->> 'v_core_skill_1'     as v_core_skill_1,
        vcep3 ->> 'v_core_skill_2'     as v_core_skill_2,
        vcep3 ->> 'v_core_skill_3'     as v_core_skill_3
    from character_vmatrix,
        lateral jsonb_array_elements(character_v_core_equipment_preset_3) as vcep3
),

vcep4 as (
    select
        snapshot_date,
        ocid,
        (vcep4 ->> 'slot_id')::integer as slot_id,
        vcep4 ->> 'v_core_type'        as v_core_type,
        (vcep4 ->> 'slot_level')::integer as slot_level,
        vcep4 ->> 'v_core_name'        as v_core_name,
        (vcep4 ->> 'v_core_level')::integer as v_core_level,
        vcep4 ->> 'v_core_skill_1'     as v_core_skill_1,
        vcep4 ->> 'v_core_skill_2'     as v_core_skill_2,
        vcep4 ->> 'v_core_skill_3'     as v_core_skill_3
    from character_vmatrix,
        lateral jsonb_array_elements(character_v_core_equipment_preset_4) as vcep4
),

vcep5 as (
    select
        snapshot_date,
        ocid,
        (vcep5 ->> 'slot_id')::integer as slot_id,
        vcep5 ->> 'v_core_type'        as v_core_type,
        (vcep5 ->> 'slot_level')::integer as slot_level,
        vcep5 ->> 'v_core_name'        as v_core_name,
        (vcep5 ->> 'v_core_level')::integer as v_core_level,
        vcep5 ->> 'v_core_skill_1'     as v_core_skill_1,
        vcep5 ->> 'v_core_skill_2'     as v_core_skill_2,
        vcep5 ->> 'v_core_skill_3'     as v_core_skill_3
    from character_vmatrix,
        lateral jsonb_array_elements(character_v_core_equipment_preset_5) as vcep5
),

v_core_equipment as (
    select
        snapshot_date,
        ocid,
        slot_id,
        v_core_type,
        vce.slot_level     as character_v_core_equipment__slot_level,
        vce.v_core_name    as character_v_core_equipment__v_core_name,
        vce.v_core_level   as character_v_core_equipment__v_core_level,
        vce.v_core_skill_1 as character_v_core_equipment__v_core_skill_1,
        vce.v_core_skill_2 as character_v_core_equipment__v_core_skill_2,
        vce.v_core_skill_3 as character_v_core_equipment__v_core_skill_3,
        vcep1.slot_level     as character_v_core_equipment_preset_1__slot_level,
        vcep1.v_core_name    as character_v_core_equipment_preset_1__v_core_name,
        vcep1.v_core_level   as character_v_core_equipment_preset_1__v_core_level,
        vcep1.v_core_skill_1 as character_v_core_equipment_preset_1__v_core_skill_1,
        vcep1.v_core_skill_2 as character_v_core_equipment_preset_1__v_core_skill_2,
        vcep1.v_core_skill_3 as character_v_core_equipment_preset_1__v_core_skill_3,
        vcep2.slot_level     as character_v_core_equipment_preset_2__slot_level,
        vcep2.v_core_name    as character_v_core_equipment_preset_2__v_core_name,
        vcep2.v_core_level   as character_v_core_equipment_preset_2__v_core_level,
        vcep2.v_core_skill_1 as character_v_core_equipment_preset_2__v_core_skill_1,
        vcep2.v_core_skill_2 as character_v_core_equipment_preset_2__v_core_skill_2,
        vcep2.v_core_skill_3 as character_v_core_equipment_preset_2__v_core_skill_3,
        vcep3.slot_level     as character_v_core_equipment_preset_3__slot_level,
        vcep3.v_core_name    as character_v_core_equipment_preset_3__v_core_name,
        vcep3.v_core_level   as character_v_core_equipment_preset_3__v_core_level,
        vcep3.v_core_skill_1 as character_v_core_equipment_preset_3__v_core_skill_1,
        vcep3.v_core_skill_2 as character_v_core_equipment_preset_3__v_core_skill_2,
        vcep3.v_core_skill_3 as character_v_core_equipment_preset_3__v_core_skill_3,
        vcep4.slot_level     as character_v_core_equipment_preset_4__slot_level,
        vcep4.v_core_name    as character_v_core_equipment_preset_4__v_core_name,
        vcep4.v_core_level   as character_v_core_equipment_preset_4__v_core_level,
        vcep4.v_core_skill_1 as character_v_core_equipment_preset_4__v_core_skill_1,
        vcep4.v_core_skill_2 as character_v_core_equipment_preset_4__v_core_skill_2,
        vcep4.v_core_skill_3 as character_v_core_equipment_preset_4__v_core_skill_3,
        vcep5.slot_level     as character_v_core_equipment_preset_5__slot_level,
        vcep5.v_core_name    as character_v_core_equipment_preset_5__v_core_name,
        vcep5.v_core_level   as character_v_core_equipment_preset_5__v_core_level,
        vcep5.v_core_skill_1 as character_v_core_equipment_preset_5__v_core_skill_1,
        vcep5.v_core_skill_2 as character_v_core_equipment_preset_5__v_core_skill_2,
        vcep5.v_core_skill_3 as character_v_core_equipment_preset_5__v_core_skill_3
    from vce
    full join vcep1 using (snapshot_date, ocid, slot_id, v_core_type)
    full join vcep2 using (snapshot_date, ocid, slot_id, v_core_type)
    full join vcep3 using (snapshot_date, ocid, slot_id, v_core_type)
    full join vcep4 using (snapshot_date, ocid, slot_id, v_core_type)
    full join vcep5 using (snapshot_date, ocid, slot_id, v_core_type)
),

stg_nexon__character_v_matrix_cores as (
    select
        cvm.snapshot_date,
        cvm.ocid,
        cvm.character_class,
        vce.slot_id,
        vce.v_core_type,
        vce.character_v_core_equipment__slot_level,
        vce.character_v_core_equipment__v_core_name,
        vce.character_v_core_equipment__v_core_level,
        vce.character_v_core_equipment__v_core_skill_1,
        vce.character_v_core_equipment__v_core_skill_2,
        vce.character_v_core_equipment__v_core_skill_3,
        cvm.character_v_matrix_remain_slot_upgrade_point::integer,
        vce.character_v_core_equipment_preset_1__slot_level,
        vce.character_v_core_equipment_preset_1__v_core_name,
        vce.character_v_core_equipment_preset_1__v_core_level,
        vce.character_v_core_equipment_preset_1__v_core_skill_1,
        vce.character_v_core_equipment_preset_1__v_core_skill_2,
        vce.character_v_core_equipment_preset_1__v_core_skill_3,
        vce.character_v_core_equipment_preset_2__slot_level,
        vce.character_v_core_equipment_preset_2__v_core_name,
        vce.character_v_core_equipment_preset_2__v_core_level,
        vce.character_v_core_equipment_preset_2__v_core_skill_1,
        vce.character_v_core_equipment_preset_2__v_core_skill_2,
        vce.character_v_core_equipment_preset_2__v_core_skill_3,
        vce.character_v_core_equipment_preset_3__slot_level,
        vce.character_v_core_equipment_preset_3__v_core_name,
        vce.character_v_core_equipment_preset_3__v_core_level,
        vce.character_v_core_equipment_preset_3__v_core_skill_1,
        vce.character_v_core_equipment_preset_3__v_core_skill_2,
        vce.character_v_core_equipment_preset_3__v_core_skill_3,
        vce.character_v_core_equipment_preset_4__slot_level,
        vce.character_v_core_equipment_preset_4__v_core_name,
        vce.character_v_core_equipment_preset_4__v_core_level,
        vce.character_v_core_equipment_preset_4__v_core_skill_1,
        vce.character_v_core_equipment_preset_4__v_core_skill_2,
        vce.character_v_core_equipment_preset_4__v_core_skill_3,
        vce.character_v_core_equipment_preset_5__slot_level,
        vce.character_v_core_equipment_preset_5__v_core_name,
        vce.character_v_core_equipment_preset_5__v_core_level,
        vce.character_v_core_equipment_preset_5__v_core_skill_1,
        vce.character_v_core_equipment_preset_5__v_core_skill_2,
        vce.character_v_core_equipment_preset_5__v_core_skill_3
    from character_vmatrix as cvm
    left join v_core_equipment as vce
        on cvm.ocid = vce.ocid and cvm.snapshot_date = vce.snapshot_date
)

select * from stg_nexon__character_v_matrix_cores
