with character_pet_equipment as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_pet_equipment') }}
),

spine as (
    select
        snapshot_date,
        ocid,
        pet_activate_flag::boolean as is_pet_activated,

        pet_1_name,
        pet_1_nickname,
        pet_1_icon,
        pet_1_description,
        pet_1_equipment ->> 'item_icon' as pet_1_equipment__item_icon,
        pet_1_equipment ->> 'item_name' as pet_1_equipment__item_name,
        pet_1_equipment ->> 'item_shape' as pet_1_equipment__item_shape,
        (pet_1_equipment ->> 'scroll_upgrade')::integer as pet_1_equipment__scroll_upgrade,
        pet_1_equipment ->> 'item_shape_icon' as pet_1_equipment__item_shape_icon,
        pet_1_equipment ->> 'item_date_expire' as pet_1_equipment__item_date_expire,
        pet_1_equipment ->> 'item_description' as pet_1_equipment__item_description,
        (pet_1_equipment ->> 'scroll_upgradable')::integer as pet_1_equipment__scroll_upgradable,
        pet_1_auto_skill ->> 'skill_1' as pet_1_auto_skill__skill_1,
        pet_1_auto_skill ->> 'skill_1_icon' as pet_1_auto_skill__skill_1_icon,
        pet_1_auto_skill ->> 'skill_2' as pet_1_auto_skill__skill_2,
        pet_1_auto_skill ->> 'skill_2_icon' as pet_1_auto_skill__skill_2_icon,
        pet_1_pet_type,
        pet_1_date_expire,
        pet_1_appearance,
        pet_1_appearance_icon,

        pet_2_name,
        pet_2_nickname,
        pet_2_icon,
        pet_2_description,
        pet_2_equipment ->> 'item_icon' as pet_2_equipment__item_icon,
        pet_2_equipment ->> 'item_name' as pet_2_equipment__item_name,
        pet_2_equipment ->> 'item_shape' as pet_2_equipment__item_shape,
        (pet_2_equipment ->> 'scroll_upgrade')::integer as pet_2_equipment__scroll_upgrade,
        pet_2_equipment ->> 'item_shape_icon' as pet_2_equipment__item_shape_icon,
        pet_2_equipment ->> 'item_date_expire' as pet_2_equipment__item_date_expire,
        pet_2_equipment ->> 'item_description' as pet_2_equipment__item_description,
        (pet_2_equipment ->> 'scroll_upgradable')::integer as pet_2_equipment__scroll_upgradable,
        pet_2_auto_skill ->> 'skill_1' as pet_2_auto_skill__skill_1,
        pet_2_auto_skill ->> 'skill_1_icon' as pet_2_auto_skill__skill_1_icon,
        pet_2_auto_skill ->> 'skill_2' as pet_2_auto_skill__skill_2,
        pet_2_auto_skill ->> 'skill_2_icon' as pet_2_auto_skill__skill_2_icon,
        pet_2_pet_type,
        pet_2_date_expire,
        pet_2_appearance,
        pet_2_appearance_icon,

        pet_3_name,
        pet_3_nickname,
        pet_3_icon,
        pet_3_description,
        pet_3_equipment ->> 'item_icon' as pet_3_equipment__item_icon,
        pet_3_equipment ->> 'item_name' as pet_3_equipment__item_name,
        pet_3_equipment ->> 'item_shape' as pet_3_equipment__item_shape,
        (pet_3_equipment ->> 'scroll_upgrade')::integer as pet_3_equipment__scroll_upgrade,
        pet_3_equipment ->> 'item_shape_icon' as pet_3_equipment__item_shape_icon,
        pet_3_equipment ->> 'item_date_expire' as pet_3_equipment__item_date_expire,
        pet_3_equipment ->> 'item_description' as pet_3_equipment__item_description,
        (pet_3_equipment ->> 'scroll_upgradable')::integer as pet_3_equipment__scroll_upgradable,
        pet_3_auto_skill ->> 'skill_1' as pet_3_auto_skill__skill_1,
        pet_3_auto_skill ->> 'skill_1_icon' as pet_3_auto_skill__skill_1_icon,
        pet_3_auto_skill ->> 'skill_2' as pet_3_auto_skill__skill_2,
        pet_3_auto_skill ->> 'skill_2_icon' as pet_3_auto_skill__skill_2_icon,
        pet_3_pet_type,
        pet_3_date_expire,
        pet_3_appearance,
        pet_3_appearance_icon,

        world_share_pet_1_name,
        world_share_pet_1_nickname,
        world_share_pet_1_icon,
        world_share_pet_1_description,
        world_share_pet_1_pet_type,
        world_share_pet_1_equipment ->> 'item_icon' as world_share_pet_1_equipment__item_icon,
        world_share_pet_1_equipment ->> 'item_name' as world_share_pet_1_equipment__item_name,
        world_share_pet_1_equipment ->> 'item_shape' as world_share_pet_1_equipment__item_shape,
        (world_share_pet_1_equipment ->> 'scroll_upgrade')::integer as world_share_pet_1_equipment__scroll_upgrade,
        world_share_pet_1_equipment ->> 'item_shape_icon' as world_share_pet_1_equipment__item_shape_icon,
        world_share_pet_1_equipment ->> 'item_date_expire' as world_share_pet_1_equipment__item_date_expire,
        world_share_pet_1_equipment ->> 'item_description' as world_share_pet_1_equipment__item_description,
        (world_share_pet_1_equipment ->> 'scroll_upgradable')::integer as world_share_pet_1_equipment__scroll_upgradable,
        world_share_pet_1_auto_skill ->> 'skill_1' as world_share_pet_1_auto_skill__skill_1,
        world_share_pet_1_auto_skill ->> 'skill_1_icon' as world_share_pet_1_auto_skill__skill_1_icon,
        world_share_pet_1_auto_skill ->> 'skill_2' as world_share_pet_1_auto_skill__skill_2,
        world_share_pet_1_auto_skill ->> 'skill_2_icon' as world_share_pet_1_auto_skill__skill_2_icon,
        world_share_pet_1_date_expire,
        world_share_pet_1_appearance,
        world_share_pet_1_appearance_icon,

        world_share_pet_2_name,
        world_share_pet_2_nickname,
        world_share_pet_2_icon,
        world_share_pet_2_description,
        world_share_pet_2_pet_type,
        world_share_pet_2_equipment ->> 'item_icon' as world_share_pet_2_equipment__item_icon,
        world_share_pet_2_equipment ->> 'item_name' as world_share_pet_2_equipment__item_name,
        world_share_pet_2_equipment ->> 'item_shape' as world_share_pet_2_equipment__item_shape,
        (world_share_pet_2_equipment ->> 'scroll_upgrade')::integer as world_share_pet_2_equipment__scroll_upgrade,
        world_share_pet_2_equipment ->> 'item_shape_icon' as world_share_pet_2_equipment__item_shape_icon,
        world_share_pet_2_equipment ->> 'item_date_expire' as world_share_pet_2_equipment__item_date_expire,
        world_share_pet_2_equipment ->> 'item_description' as world_share_pet_2_equipment__item_description,
        (world_share_pet_2_equipment ->> 'scroll_upgradable')::integer as world_share_pet_2_equipment__scroll_upgradable,
        world_share_pet_2_auto_skill ->> 'skill_1' as world_share_pet_2_auto_skill__skill_1,
        world_share_pet_2_auto_skill ->> 'skill_1_icon' as world_share_pet_2_auto_skill__skill_1_icon,
        world_share_pet_2_auto_skill ->> 'skill_2' as world_share_pet_2_auto_skill__skill_2,
        world_share_pet_2_auto_skill ->> 'skill_2_icon' as world_share_pet_2_auto_skill__skill_2_icon,
        world_share_pet_2_date_expire,
        world_share_pet_2_appearance,
        world_share_pet_2_appearance_icon,

        world_share_pet_3_name,
        world_share_pet_3_nickname,
        world_share_pet_3_icon,
        world_share_pet_3_description,
        world_share_pet_3_pet_type,
        world_share_pet_3_equipment ->> 'item_icon' as world_share_pet_3_equipment__item_icon,
        world_share_pet_3_equipment ->> 'item_name' as world_share_pet_3_equipment__item_name,
        world_share_pet_3_equipment ->> 'item_shape' as world_share_pet_3_equipment__item_shape,
        (world_share_pet_3_equipment ->> 'scroll_upgrade')::integer as world_share_pet_3_equipment__scroll_upgrade,
        world_share_pet_3_equipment ->> 'item_shape_icon' as world_share_pet_3_equipment__item_shape_icon,
        world_share_pet_3_equipment ->> 'item_date_expire' as world_share_pet_3_equipment__item_date_expire,
        world_share_pet_3_equipment ->> 'item_description' as world_share_pet_3_equipment__item_description,
        (world_share_pet_3_equipment ->> 'scroll_upgradable')::integer as world_share_pet_3_equipment__scroll_upgradable,
        world_share_pet_3_auto_skill ->> 'skill_1' as world_share_pet_3_auto_skill__skill_1,
        world_share_pet_3_auto_skill ->> 'skill_1_icon' as world_share_pet_3_auto_skill__skill_1_icon,
        world_share_pet_3_auto_skill ->> 'skill_2' as world_share_pet_3_auto_skill__skill_2,
        world_share_pet_3_auto_skill ->> 'skill_2_icon' as world_share_pet_3_auto_skill__skill_2_icon,
        world_share_pet_3_date_expire,
        world_share_pet_3_appearance,
        world_share_pet_3_appearance_icon
    from character_pet_equipment
),

-- Scalar skill lists (pet_N_skill, world_share_pet_N_skill, petite_luna_pet_skill)
-- share one schema; stacked here with pet_group / pet_no discriminators.
pet_skill_list as (
    select
        snapshot_date,
        ocid,
        'pet' as pet_group,
        1 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(pet_1_skill) with ordinality as s(val, ord)

    union all

    select
        snapshot_date,
        ocid,
        'pet' as pet_group,
        2 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(pet_2_skill) with ordinality as s(val, ord)

    union all

    select
        snapshot_date,
        ocid,
        'pet' as pet_group,
        3 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(pet_3_skill) with ordinality as s(val, ord)

    union all

    select
        snapshot_date,
        ocid,
        'world_share' as pet_group,
        1 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(world_share_pet_1_skill) with ordinality as s(val, ord)

    union all

    select
        snapshot_date,
        ocid,
        'world_share' as pet_group,
        2 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(world_share_pet_2_skill) with ordinality as s(val, ord)

    union all

    select
        snapshot_date,
        ocid,
        'world_share' as pet_group,
        3 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(world_share_pet_3_skill) with ordinality as s(val, ord)

    union all

    -- petite_luna_pet_skill is always an empty array in current data; contributes 0 rows.
    select
        snapshot_date,
        ocid,
        'petite_luna' as pet_group,
        1 as pet_no,
        s.ord::integer as pet_skill__index,
        s.val #>> '{}' as pet_skill__value
    from character_pet_equipment,
        lateral jsonb_array_elements(petite_luna_pet_skill) with ordinality as s(val, ord)
),

-- item_option lists nested inside each *_equipment object share one schema.
-- schema inferred; item_option is empty in current data (option keys mirror
-- cash_item_option in stg_nexon__character_cash_item_equipments).
equipment_item_option_list as (
    select
        snapshot_date,
        ocid,
        'pet' as pet_group,
        1 as pet_no,
        o.ord::integer as equipment_item_option__index,
        o.opt ->> 'option_type' as equipment_item_option__option_type,
        o.opt ->> 'option_value' as equipment_item_option__option_value
    from character_pet_equipment,
        lateral jsonb_array_elements(pet_1_equipment -> 'item_option') with ordinality as o(opt, ord)

    union all

    select
        snapshot_date,
        ocid,
        'pet' as pet_group,
        2 as pet_no,
        o.ord::integer as equipment_item_option__index,
        o.opt ->> 'option_type' as equipment_item_option__option_type,
        o.opt ->> 'option_value' as equipment_item_option__option_value
    from character_pet_equipment,
        lateral jsonb_array_elements(pet_2_equipment -> 'item_option') with ordinality as o(opt, ord)

    union all

    select
        snapshot_date,
        ocid,
        'pet' as pet_group,
        3 as pet_no,
        o.ord::integer as equipment_item_option__index,
        o.opt ->> 'option_type' as equipment_item_option__option_type,
        o.opt ->> 'option_value' as equipment_item_option__option_value
    from character_pet_equipment,
        lateral jsonb_array_elements(pet_3_equipment -> 'item_option') with ordinality as o(opt, ord)

    union all

    select
        snapshot_date,
        ocid,
        'world_share' as pet_group,
        1 as pet_no,
        o.ord::integer as equipment_item_option__index,
        o.opt ->> 'option_type' as equipment_item_option__option_type,
        o.opt ->> 'option_value' as equipment_item_option__option_value
    from character_pet_equipment,
        lateral jsonb_array_elements(world_share_pet_1_equipment -> 'item_option') with ordinality as o(opt, ord)

    union all

    select
        snapshot_date,
        ocid,
        'world_share' as pet_group,
        2 as pet_no,
        o.ord::integer as equipment_item_option__index,
        o.opt ->> 'option_type' as equipment_item_option__option_type,
        o.opt ->> 'option_value' as equipment_item_option__option_value
    from character_pet_equipment,
        lateral jsonb_array_elements(world_share_pet_2_equipment -> 'item_option') with ordinality as o(opt, ord)

    union all

    select
        snapshot_date,
        ocid,
        'world_share' as pet_group,
        3 as pet_no,
        o.ord::integer as equipment_item_option__index,
        o.opt ->> 'option_type' as equipment_item_option__option_type,
        o.opt ->> 'option_value' as equipment_item_option__option_value
    from character_pet_equipment,
        lateral jsonb_array_elements(world_share_pet_3_equipment -> 'item_option') with ordinality as o(opt, ord)
),

all_lists as (
    select
        snapshot_date,
        ocid,
        pet_group,
        pet_no,
        pet_skill__index,
        pet_skill__value,
        null::integer as equipment_item_option__index,
        null::text as equipment_item_option__option_type,
        null::text as equipment_item_option__option_value
    from pet_skill_list

    union all

    select
        snapshot_date,
        ocid,
        pet_group,
        pet_no,
        null::integer as pet_skill__index,
        null::text as pet_skill__value,
        equipment_item_option__index,
        equipment_item_option__option_type,
        equipment_item_option__option_value
    from equipment_item_option_list
),

stg_nexon__character_pet_equipments as (
    select *
    from spine
    left join all_lists using (snapshot_date, ocid)
)

select * from stg_nexon__character_pet_equipments
