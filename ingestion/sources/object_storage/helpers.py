from collections import Counter
from pathlib import PurePosixPath

from dlt.sources.filesystem import filesystem, read_parquet


def table_name(file_item):
    """Table name for one object: the file stem, so
    `raw/hexa_skill/hexa_boss.parquet` loads as `hexa_boss`."""
    return PurePosixPath(file_item["file_name"]).stem


def check_unique_table_names(file_items):
    """Guard the flat table namespace. The bucket nests parquet by page namespace
    but the stems become bare table names, so a `growth.parquet` under two
    namespaces would collapse into one table — dlt merges pipes on a name clash
    rather than raising. Fail here instead, naming both objects."""
    counts = Counter(table_name(f) for f in file_items)
    clashes = {name for name, n in counts.items() if n > 1}
    if clashes:
        paths = sorted(
            f["relative_path"] for f in file_items if table_name(f) in clashes
        )
        raise ValueError(
            "Parquet objects share a table name, so they would load into the same "
            f"table: {', '.join(paths)}. Rename one in its notebook's export cell."
        )


def build_object_resource(bucket_url, fs_client, file_item, write_disposition):
    """Build the resource that loads one parquet object into its own table.

    `filesystem` lists just that object — an exact relative path is a valid glob —
    and `read_parquet` reads it. The pipe is renamed so the table is the file stem
    rather than the transformer's own name, `read_parquet`.

    `use_pyarrow=True` keeps the rows as arrow batches end to end, which is the
    path `.dlt/config.toml`'s [normalize.parquet_normalizer] configures — without
    it the batches become Python dicts and take the JSON normalizer instead.
    """
    reader = filesystem(
        bucket_url=bucket_url,
        credentials=fs_client,
        file_glob=file_item["relative_path"],
    ) | read_parquet(use_pyarrow=True)
    return reader.with_name(table_name(file_item)).apply_hints(
        write_disposition=write_disposition
    )
