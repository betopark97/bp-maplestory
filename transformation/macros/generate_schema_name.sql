{#
  Schema naming: <target>_<layer>, e.g. dev_staging, prod_marts.

  dbt's default prefixes the custom schema with target.schema (the profile's
  `schema:`, i.e. `public`) -> public_staging. We prefix with target.name
  instead, so environments stay isolated while layer names stay clean.

  Only models raise on a missing +schema: dbt resolves a schema for every node
  it parses, and tests carry none of their own, so raising would break dbt test.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is not none -%}
        {{ target.name | trim }}_{{ custom_schema_name | trim }}
    {%- elif node is not none and node.resource_type == 'model' -%}
        {{ exceptions.raise_compiler_error(
            "No +schema configured for model '" ~ node.name ~ "' ("
            ~ node.original_file_path ~ "). Add a `+schema:` to the `models:` block "
            ~ "in dbt_project.yml that covers its directory -- check that the block "
            ~ "name matches the directory name exactly."
        ) }}
    {%- else -%}
        {{ target.name | trim }}
    {%- endif -%}
{%- endmacro %}
