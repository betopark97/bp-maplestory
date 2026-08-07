# -------------------------------------------------------------------------------------
# Bucket holding the extraction workbench output
# -------------------------------------------------------------------------------------
# The marimo notebooks in notebooks/ archive each source page under
# `raw/{namespace}/`: the page HTML as `{namespace}.jsonl.gz`, image blobs under
# `images/`, and the frames they persist as `{table}.parquet` beside them.
BUCKET_URL = "s3://raw"

# -------------------------------------------------------------------------------------
# Objects to ingest
# -------------------------------------------------------------------------------------
# Every parquet under the bucket becomes its own table, named after the file stem —
# `raw/hexa_skill/hexa_boss.parquet` loads as `hexa_boss`. `**` recurses into every
# namespace directory. The HTML archives and image blobs are left where they are;
# Postgres reaches the blobs through the pointer tables' `object_key` column.
FILE_GLOB = "**/*.parquet"

# The notebooks overwrite each object in place, so every table reloads whole. The
# history that matters is the history of loads, which `_dlt_loads` keeps.
WRITE_DISPOSITION = "replace"

# -------------------------------------------------------------------------------------
# Identifier naming
# -------------------------------------------------------------------------------------
# The frames carry the page's own Korean column names (지역, 레벨, 필요 성장치). dlt's
# default `snake_case` strips every non-ascii character and then collapses what is
# left, so those all normalize to `x` and overwrite each other — as do `sql_cs_v1`
# and `sql_ci_v1`. `direct` passes identifiers through untouched, keeping the raw
# layer a mirror of the page; the renaming belongs in the staging models.
#
# Postgres caps identifiers at 63 *bytes* while dlt shortens by *characters*, so
# Hangul (3 bytes each) has an effective ceiling of 21 characters that dlt will not
# catch for you. Current names are well under it.
NAMING_CONVENTION = "direct"
