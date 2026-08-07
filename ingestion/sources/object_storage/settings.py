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
# namespace directory. The HTML archives are left where they are; the image blobs get
# the listing table below rather than a table each.
FILE_GLOB = "**/*.parquet"

# The notebooks overwrite each object in place, so every table reloads whole. The
# history that matters is the history of loads, which `_dlt_loads` keeps.
WRITE_DISPOSITION = "replace"

# -------------------------------------------------------------------------------------
# Image blobs to index
# -------------------------------------------------------------------------------------
# Every image the notebooks archive sits under its namespace's `images/` prefix, at
# whatever depth that page's keying needs — `images/{이름}.webp` (hexa_skill),
# `images/{group}/{이름}.webp` (boss_card, field_boss_icon), and
# `images/sprite/{섹션}/{이름}.gif` (names repeat across sections). `**/images/**`
# matches all three.
#
# The blobs stay in MinIO: this is a listing, so only keys and object metadata land in
# Postgres, as one lookup table to join against — not an `object_key` column repeated
# across the individual tables. Splitting a key into its namespace / group / section /
# name is the staging layer's job, same as renaming.
IMAGE_GLOB = "**/images/**"

# Built by name rather than discovered from a file stem, so it is also the one table
# name a parquet object may not take (see `check_unique_table_names`).
IMAGE_TABLE_NAME = "image"

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
