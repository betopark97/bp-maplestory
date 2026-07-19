{#
  Schema naming: <target>_<layer>, e.g. dev_staging, prod_mart.

  dbt's default prefixes the custom schema with target.schema (the profile's
  `schema:`, i.e. `public`) -> public_staging. We instead prefix with
  target.name (the environment: dev / prod) so environments stay isolated
  while layer names stay clean.

  - model with +schema: staging, target dev  -> dev_staging
  - model with no +schema,      target dev  -> dev
  Sources are unaffected (this macro only names model-built schemas).
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.name | trim }}
    {%- else -%}
        {{ target.name | trim }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
