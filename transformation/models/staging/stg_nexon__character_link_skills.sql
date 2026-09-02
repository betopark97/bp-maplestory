with character_link_skill as (
    select
        *,
        date as snapshot_date
    from {{ source('nexon', 'character_link_skill') }}
),

cls as (
    select
        snapshot_date,
        ocid,
        cls ->> 'skill_name'        as skill_name,
        cls ->> 'skill_icon'        as skill_icon,
        (cls ->> 'skill_level')::integer as skill_level,
        cls ->> 'skill_effect'      as skill_effect,
        cls ->> 'skill_effect_next' as skill_effect_next,
        cls ->> 'skill_description' as skill_description
    from character_link_skill,
        lateral jsonb_array_elements(character_link_skill) as cls
),

clsp1 as (
    select
        snapshot_date,
        ocid,
        clsp1 ->> 'skill_name'        as skill_name,
        clsp1 ->> 'skill_icon'        as skill_icon,
        (clsp1 ->> 'skill_level')::integer as skill_level,
        clsp1 ->> 'skill_effect'      as skill_effect,
        clsp1 ->> 'skill_description' as skill_description
    from character_link_skill,
        lateral jsonb_array_elements(character_link_skill_preset_1) as clsp1
),

clsp2 as (
    select
        snapshot_date,
        ocid,
        clsp2 ->> 'skill_name'        as skill_name,
        clsp2 ->> 'skill_icon'        as skill_icon,
        (clsp2 ->> 'skill_level')::integer as skill_level,
        clsp2 ->> 'skill_effect'      as skill_effect,
        clsp2 ->> 'skill_description' as skill_description
    from character_link_skill,
        lateral jsonb_array_elements(character_link_skill_preset_2) as clsp2
),

clsp3 as (
    select
        snapshot_date,
        ocid,
        clsp3 ->> 'skill_name'        as skill_name,
        clsp3 ->> 'skill_icon'        as skill_icon,
        (clsp3 ->> 'skill_level')::integer as skill_level,
        clsp3 ->> 'skill_effect'      as skill_effect,
        clsp3 ->> 'skill_description' as skill_description
    from character_link_skill,
        lateral jsonb_array_elements(character_link_skill_preset_3) as clsp3
),

ols as (
    select
        snapshot_date,
        ocid,
        character_owned_link_skill ->> 'skill_name'        as skill_name,
        character_owned_link_skill ->> 'skill_icon'        as skill_icon,
        (character_owned_link_skill ->> 'skill_level')::integer as skill_level,
        character_owned_link_skill ->> 'skill_effect'      as skill_effect,
        character_owned_link_skill ->> 'skill_description' as skill_description
    from character_link_skill
    where character_owned_link_skill is not null
),

olsp1 as (
    select
        snapshot_date,
        ocid,
        character_owned_link_skill_preset_1 ->> 'skill_name'        as skill_name,
        character_owned_link_skill_preset_1 ->> 'skill_icon'        as skill_icon,
        (character_owned_link_skill_preset_1 ->> 'skill_level')::integer as skill_level,
        character_owned_link_skill_preset_1 ->> 'skill_effect'      as skill_effect,
        character_owned_link_skill_preset_1 ->> 'skill_description' as skill_description
    from character_link_skill
    where character_owned_link_skill_preset_1 is not null
),

olsp2 as (
    select
        snapshot_date,
        ocid,
        character_owned_link_skill_preset_2 ->> 'skill_name'        as skill_name,
        character_owned_link_skill_preset_2 ->> 'skill_icon'        as skill_icon,
        (character_owned_link_skill_preset_2 ->> 'skill_level')::integer as skill_level,
        character_owned_link_skill_preset_2 ->> 'skill_effect'      as skill_effect,
        character_owned_link_skill_preset_2 ->> 'skill_description' as skill_description
    from character_link_skill
    where character_owned_link_skill_preset_2 is not null
),

olsp3 as (
    select
        snapshot_date,
        ocid,
        character_owned_link_skill_preset_3 ->> 'skill_name'        as skill_name,
        character_owned_link_skill_preset_3 ->> 'skill_icon'        as skill_icon,
        (character_owned_link_skill_preset_3 ->> 'skill_level')::integer as skill_level,
        character_owned_link_skill_preset_3 ->> 'skill_effect'      as skill_effect,
        character_owned_link_skill_preset_3 ->> 'skill_description' as skill_description
    from character_link_skill
    where character_owned_link_skill_preset_3 is not null
),

link_skills as (
    select
        snapshot_date,
        ocid,
        skill_name,
        cls.skill_icon        as character_link_skill__skill_icon,
        cls.skill_level       as character_link_skill__skill_level,
        cls.skill_effect      as character_link_skill__skill_effect,
        cls.skill_effect_next as character_link_skill__skill_effect_next,
        cls.skill_description as character_link_skill__skill_description,
        clsp1.skill_icon        as character_link_skill_preset_1__skill_icon,
        clsp1.skill_level       as character_link_skill_preset_1__skill_level,
        clsp1.skill_effect      as character_link_skill_preset_1__skill_effect,
        clsp1.skill_description as character_link_skill_preset_1__skill_description,
        clsp2.skill_icon        as character_link_skill_preset_2__skill_icon,
        clsp2.skill_level       as character_link_skill_preset_2__skill_level,
        clsp2.skill_effect      as character_link_skill_preset_2__skill_effect,
        clsp2.skill_description as character_link_skill_preset_2__skill_description,
        clsp3.skill_icon        as character_link_skill_preset_3__skill_icon,
        clsp3.skill_level       as character_link_skill_preset_3__skill_level,
        clsp3.skill_effect      as character_link_skill_preset_3__skill_effect,
        clsp3.skill_description as character_link_skill_preset_3__skill_description,
        ols.skill_icon        as character_owned_link_skill__skill_icon,
        ols.skill_level       as character_owned_link_skill__skill_level,
        ols.skill_effect      as character_owned_link_skill__skill_effect,
        ols.skill_description as character_owned_link_skill__skill_description,
        olsp1.skill_icon        as character_owned_link_skill_preset_1__skill_icon,
        olsp1.skill_level       as character_owned_link_skill_preset_1__skill_level,
        olsp1.skill_effect      as character_owned_link_skill_preset_1__skill_effect,
        olsp1.skill_description as character_owned_link_skill_preset_1__skill_description,
        olsp2.skill_icon        as character_owned_link_skill_preset_2__skill_icon,
        olsp2.skill_level       as character_owned_link_skill_preset_2__skill_level,
        olsp2.skill_effect      as character_owned_link_skill_preset_2__skill_effect,
        olsp2.skill_description as character_owned_link_skill_preset_2__skill_description,
        olsp3.skill_icon        as character_owned_link_skill_preset_3__skill_icon,
        olsp3.skill_level       as character_owned_link_skill_preset_3__skill_level,
        olsp3.skill_effect      as character_owned_link_skill_preset_3__skill_effect,
        olsp3.skill_description as character_owned_link_skill_preset_3__skill_description
    from cls
    full join clsp1 using (snapshot_date, ocid, skill_name)
    full join clsp2 using (snapshot_date, ocid, skill_name)
    full join clsp3 using (snapshot_date, ocid, skill_name)
    full join ols   using (snapshot_date, ocid, skill_name)
    full join olsp1 using (snapshot_date, ocid, skill_name)
    full join olsp2 using (snapshot_date, ocid, skill_name)
    full join olsp3 using (snapshot_date, ocid, skill_name)
),

stg_nexon__character_link_skills as (
    select
        cls.snapshot_date,
        cls.ocid,
        cls.character_class,
        ls.skill_name,
        ls.character_link_skill__skill_icon,
        ls.character_link_skill__skill_level,
        ls.character_link_skill__skill_effect,
        ls.character_link_skill__skill_effect_next,
        ls.character_link_skill__skill_description,
        ls.character_link_skill_preset_1__skill_icon,
        ls.character_link_skill_preset_1__skill_level,
        ls.character_link_skill_preset_1__skill_effect,
        ls.character_link_skill_preset_1__skill_description,
        ls.character_link_skill_preset_2__skill_icon,
        ls.character_link_skill_preset_2__skill_level,
        ls.character_link_skill_preset_2__skill_effect,
        ls.character_link_skill_preset_2__skill_description,
        ls.character_link_skill_preset_3__skill_icon,
        ls.character_link_skill_preset_3__skill_level,
        ls.character_link_skill_preset_3__skill_effect,
        ls.character_link_skill_preset_3__skill_description,
        ls.character_owned_link_skill__skill_icon,
        ls.character_owned_link_skill__skill_level,
        ls.character_owned_link_skill__skill_effect,
        ls.character_owned_link_skill__skill_description,
        ls.character_owned_link_skill_preset_1__skill_icon,
        ls.character_owned_link_skill_preset_1__skill_level,
        ls.character_owned_link_skill_preset_1__skill_effect,
        ls.character_owned_link_skill_preset_1__skill_description,
        ls.character_owned_link_skill_preset_2__skill_icon,
        ls.character_owned_link_skill_preset_2__skill_level,
        ls.character_owned_link_skill_preset_2__skill_effect,
        ls.character_owned_link_skill_preset_2__skill_description,
        ls.character_owned_link_skill_preset_3__skill_icon,
        ls.character_owned_link_skill_preset_3__skill_level,
        ls.character_owned_link_skill_preset_3__skill_effect,
        ls.character_owned_link_skill_preset_3__skill_description
    from character_link_skill as cls
    left join link_skills as ls
        on cls.ocid = ls.ocid and cls.snapshot_date = ls.snapshot_date
)

select * from stg_nexon__character_link_skills
