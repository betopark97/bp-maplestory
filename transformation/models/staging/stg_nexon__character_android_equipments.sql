with character_android_equipment as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_android_equipment') }}
),

spine as (
    select
        snapshot_date,
        ocid,
        android_name,
        android_nickname,
        android_icon,
        android_description,
        android_hair ->> 'hair_name' as android_hair__hair_name,
        android_hair ->> 'base_color' as android_hair__base_color,
        android_hair ->> 'mix_color' as android_hair__mix_color,
        (android_hair ->> 'mix_rate')::integer as android_hair__mix_rate,
        (android_hair ->> 'freestyle_flag')::boolean as is_android_hair__freestyle,
        android_face ->> 'face_name' as android_face__face_name,
        android_face ->> 'base_color' as android_face__base_color,
        android_face ->> 'mix_color' as android_face__mix_color,
        (android_face ->> 'mix_rate')::integer as android_face__mix_rate,
        (android_face ->> 'freestyle_flag')::boolean as is_android_face__freestyle,
        android_skin ->> 'skin_name' as android_skin__skin_name,
        android_skin ->> 'color_style' as android_skin__color_style,
        (android_skin ->> 'hue')::integer as android_skin__hue,
        (android_skin ->> 'saturation')::integer as android_skin__saturation,
        (android_skin ->> 'brightness')::integer as android_skin__brightness,
        case
            when android_ear_sensor_clip_flag is null then null
            when android_ear_sensor_clip_flag = '미적용' then false
            else true
        end as has_android_ear_sensor_clip,
        android_gender,
        android_grade,
        case
            when android_non_humanoid_flag is null then null
            when android_non_humanoid_flag = '비인간형' then true
            else false
        end as is_android_non_humanoid,
        case
            when android_shop_usable_flag is null then null
            when android_shop_usable_flag = '가능' then true
            else false
        end as is_android_shop_usable,
        preset_no,
        android_preset_1 ->> 'android_name' as android_preset_1__android_name,
        android_preset_1 ->> 'android_nickname' as android_preset_1__android_nickname,
        android_preset_1 ->> 'android_icon' as android_preset_1__android_icon,
        android_preset_1 ->> 'android_description' as android_preset_1__android_description,
        android_preset_1 -> 'android_hair' ->> 'hair_name' as android_preset_1__android_hair__hair_name,
        android_preset_1 -> 'android_hair' ->> 'base_color' as android_preset_1__android_hair__base_color,
        android_preset_1 -> 'android_hair' ->> 'mix_color' as android_preset_1__android_hair__mix_color,
        (android_preset_1 -> 'android_hair' ->> 'mix_rate')::integer as android_preset_1__android_hair__mix_rate,
        (android_preset_1 -> 'android_hair' ->> 'freestyle_flag')::boolean as is_android_preset_1__android_hair__freestyle,
        android_preset_1 -> 'android_face' ->> 'face_name' as android_preset_1__android_face__face_name,
        android_preset_1 -> 'android_face' ->> 'base_color' as android_preset_1__android_face__base_color,
        android_preset_1 -> 'android_face' ->> 'mix_color' as android_preset_1__android_face__mix_color,
        (android_preset_1 -> 'android_face' ->> 'mix_rate')::integer as android_preset_1__android_face__mix_rate,
        (android_preset_1 -> 'android_face' ->> 'freestyle_flag')::boolean as is_android_preset_1__android_face__freestyle,
        android_preset_1 -> 'android_skin' ->> 'skin_name' as android_preset_1__android_skin__skin_name,
        android_preset_1 -> 'android_skin' ->> 'color_style' as android_preset_1__android_skin__color_style,
        (android_preset_1 -> 'android_skin' ->> 'hue')::integer as android_preset_1__android_skin__hue,
        (android_preset_1 -> 'android_skin' ->> 'saturation')::integer as android_preset_1__android_skin__saturation,
        (android_preset_1 -> 'android_skin' ->> 'brightness')::integer as android_preset_1__android_skin__brightness,
        case
            when android_preset_1 ->> 'android_ear_sensor_clip_flag' is null then null
            when android_preset_1 ->> 'android_ear_sensor_clip_flag' = '미적용' then false
            else true
        end as has_android_preset_1__android_ear_sensor_clip,
        android_preset_1 ->> 'android_gender' as android_preset_1__android_gender,
        android_preset_1 ->> 'android_grade' as android_preset_1__android_grade,
        case
            when android_preset_1 ->> 'android_non_humanoid_flag' is null then null
            when android_preset_1 ->> 'android_non_humanoid_flag' = '비인간형' then true
            else false
        end as is_android_preset_1__android_non_humanoid,
        case
            when android_preset_1 ->> 'android_shop_usable_flag' is null then null
            when android_preset_1 ->> 'android_shop_usable_flag' = '가능' then true
            else false
        end as is_android_preset_1__android_shop_usable
    from character_android_equipment
),

-- schema inferred; android_cash_item_equipment empty in current data.
-- Element key set mirrors stg_nexon__character_cash_item_equipments; contributes 0 rows.
android_cash_item_equipment_list as (
    select
        snapshot_date,
        ocid,
        el ->> 'cash_item_equipment_slot' as android_cash_item_equipment__cash_item_equipment_slot,
        el ->> 'cash_item_equipment_part' as android_cash_item_equipment__cash_item_equipment_part,
        el -> 'skills' as android_cash_item_equipment__skills,
        el ->> 'date_expire' as android_cash_item_equipment__date_expire,
        el ->> 'item_gender' as android_cash_item_equipment__item_gender,
        el ->> 'emotion_name' as android_cash_item_equipment__emotion_name,
        el ->> 'cash_item_icon' as android_cash_item_equipment__cash_item_icon,
        el ->> 'cash_item_name' as android_cash_item_equipment__cash_item_name,
        (el ->> 'freestyle_flag')::boolean as is_android_cash_item_equipment__freestyle,
        el ->> 'cash_item_label' as android_cash_item_equipment__cash_item_label,
        el -> 'cash_item_option' as android_cash_item_equipment__cash_item_option,
        el ->> 'date_option_expire' as android_cash_item_equipment__date_option_expire,
        el ->> 'cash_item_description' as android_cash_item_equipment__cash_item_description,
        el -> 'cash_item_effect_prism' as android_cash_item_equipment__cash_item_effect_prism,
        el -> 'cash_item_coloring_prism' as android_cash_item_equipment__cash_item_coloring_prism
    from character_android_equipment,
        lateral jsonb_array_elements(android_cash_item_equipment) as el
),

all_lists as (
    select * from android_cash_item_equipment_list
),

stg_nexon__character_android_equipments as (
    select *
    from spine
    left join all_lists using (snapshot_date, ocid)
)

select * from stg_nexon__character_android_equipments
