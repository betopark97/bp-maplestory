{#
  Schema naming: the bare layer name, e.g. staging, intermediate, marts.

  The environment lives in the database (dev_maplestory, prod_maplestory), not
  in the schema, so the schema name is identical in every environment. That is
  what keeps every source, ref and hand-written query byte-identical across
  environments -- switching environment is a change of connection only.

  dbt's own default would prefix the custom schema with target.schema (the
  profile's `schema:`, i.e. `public`) -> public_staging, so the override is
  still needed; it just has nothing to add to the name.

  Only models raise on a missing +schema: dbt resolves a schema for every node
  it parses, and tests carry none of their own, so raising would break dbt test.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
    {%- elif node is not none and node.resource_type == 'model' -%}
        {{ exceptions.raise_compiler_error(
            "No +schema configured for model '" ~ node.name ~ "' ("
            ~ node.original_file_path ~ "). Add a `+schema:` to the `models:` block "
            ~ "in dbt_project.yml that covers its directory -- check that the block "
            ~ "name matches the directory name exactly."
        ) }}
    {%- else -%}
        {{ target.schema | trim }}
    {%- endif -%}
{%- endmacro %}
