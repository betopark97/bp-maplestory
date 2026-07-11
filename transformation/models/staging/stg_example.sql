-- Starter staging model. Replace with real transformations.
select
    id,
    name
from {{ source('raw', 'example') }}
