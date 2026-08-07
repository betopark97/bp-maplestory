from collections import Counter
from pathlib import PurePosixPath

import dlt
from dlt.sources.filesystem import filesystem, glob_files, read_parquet


def table_name(file_item):
    """Table name for one object: the file stem, so
    `raw/hexa_skill/hexa_boss.parquet` loads as `hexa_boss`."""
    return PurePosixPath(file_item["file_name"]).stem


def check_unique_table_names(file_items, reserved_name):
    """Guard the flat table namespace. The bucket nests parquet by page namespace
    but the stems become bare table names, so a `growth.parquet` under two
    namespaces would collapse into one table — dlt merges pipes on a name clash
    rather than raising. `reserved_name` is the image listing table, which is
    built by name and so would swallow a parquet stem matching it. Fail here
    instead, naming the objects at fault."""
    counts = Counter(table_name(f) for f in file_items)
    clashes = {name for name, n in counts.items() if n > 1}
    if reserved_name in counts:
        clashes.add(reserved_name)
    if clashes:
        paths = sorted(
            f["relative_path"] for f in file_items if table_name(f) in clashes
        )
        raise ValueError(
            "Parquet objects collide on a table name — with each other, or with the "
            f"`{reserved_name}` image listing table: {', '.join(paths)}. Rename one "
            "in its notebook's export cell."
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


def build_image_resource(
    bucket_url, fs_client, image_glob, image_table_name, write_disposition
):
    """Build the resource behind the image listing table: one row per blob under
    any namespace's `images/` prefix.

    `glob_files` is the listing call, not a read — the blobs stay in MinIO and
    Postgres gets their keys plus the metadata the listing already carries, so
    dbt has one table to join against instead of an `object_key` column on every
    table.
    """

    @dlt.resource(name=image_table_name, write_disposition=write_disposition)
    def image_listing():
        for file_item in glob_files(fs_client, bucket_url, image_glob):
            yield {
                # `file_url` is the fsspec url (`s3://raw/…`); without the scheme it
                # is the key the notebooks write into their own pointer frames and
                # the one any consumer opens the blob with.
                "object_key": file_item["file_url"].split("://", 1)[-1],
                # What dlt globs on, so a consumer can hand it straight back to the
                # filesystem source.
                "relative_path": file_item["relative_path"],
                "file_name": file_item["file_name"],
                "content_type": file_item["mime_type"],
                "size_in_bytes": file_item["size_in_bytes"],
                "modification_date": file_item["modification_date"],
            }

    return image_listing()
