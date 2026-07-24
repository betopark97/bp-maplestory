with character_beauty_equipment as (
    select * from {{ source('nexon', 'character_beauty_equipment') }}
),

stg_nexon__character_beauty_equipment as (
    select
        date,
        ocid,
        character_gender,
        character_class,
        character_hair ->> 'hair_name' as character_hair__hair_name,
        character_hair ->> 'base_color' as character_hair__base_color,
        character_hair ->> 'mix_color' as character_hair__mix_color,
        (character_hair ->> 'mix_rate')::integer as character_hair__mix_rate,
        character_hair ->> 'freestyle_flag' as character_hair__freestyle_flag,
        character_face ->> 'face_name' as character_face__face_name,
        character_face ->> 'base_color' as character_face__base_color,
        character_face ->> 'mix_color' as character_face__mix_color,
        (character_face ->> 'mix_rate')::integer as character_face__mix_rate,
        character_face ->> 'freestyle_flag' as character_face__freestyle_flag,
        character_skin ->> 'skin_name' as character_skin__skin_name,
        character_skin ->> 'color_style' as character_skin__color_style,
        (character_skin ->> 'hue')::integer as character_skin__hue,
        (character_skin ->> 'saturation')::integer as character_skin__saturation,
        (character_skin ->> 'brightness')::integer as character_skin__brightness
    from character_beauty_equipment
)

select * from stg_nexon__character_beauty_equipment
