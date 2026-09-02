"""Raw-SQL data access.

One module per table or mart. Functions take an ``AsyncConnection`` supplied by
``app.api.deps`` and return `app.models` row models. Transaction control belongs
to the request-scoped dependency, so nothing here commits.

Two kinds of module live side by side:

* ``crud_*`` over the app schema  -- read and write, migration-versioned.
* ``crud_*`` over the marts schema -- read only, dbt owns the DDL.
"""
