-- Databases this platform expects, for a machine that does not have them yet.
--
-- Postgres runs everything in /docker-entrypoint-initdb.d exactly once, against
-- an empty data directory, and ignores it on every later start. So this file is
-- what a fresh volume gets -- an existing volume needs the same statements run
-- by hand.
--
-- No OWNER clause: these run as POSTGRES_USER, and a database's default owner is
-- the role that creates it, so the owner follows infra/.env without repeating it.
--
-- dev_maplestory is not here. It is POSTGRES_DB in infra/.env, which the entrypoint
-- creates before this script runs.

-- Written only by the dlt `tests` profile, so a test run cannot touch the data
-- you are working against.
CREATE DATABASE test_maplestory;

-- prod_maplestory is deliberately absent. Prod is deferred until there is an MVP
-- and a Dagster schedule to keep it current; the line gets added when prod is
-- actually stood up, so this file keeps describing what exists.
