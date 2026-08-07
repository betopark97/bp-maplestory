import dlt
from dlt.common.schema import Schema
from dlt.sources.credentials import FileSystemCredentials
from dlt.sources.filesystem import fsspec_filesystem, glob_files

from .helpers import (
    build_image_resource,
    build_object_resource,
    check_unique_table_names,
)
from .settings import (
    BUCKET_URL,
    FILE_GLOB,
    IMAGE_GLOB,
    IMAGE_TABLE_NAME,
    NAMING_CONVENTION,
    WRITE_DISPOSITION,
)


@dlt.source(
    max_table_nesting=0,
    # The schema names the source, so `name=` is not passed alongside it. Scoping the
    # naming convention here leaves nexon and google_sheets on snake_case.
    schema=Schema("object_storage", normalizers={"names": NAMING_CONVENTION}),
)
def object_storage(
    bucket_url: str = BUCKET_URL,
    credentials: FileSystemCredentials = dlt.secrets.value,
):
    # One fsspec client, built once and handed to every file resource, so the
    # credentials resolve a single time instead of once per object.
    fs_client = fsspec_filesystem(bucket_url, credentials)[0]

    # The same listing call `filesystem()` makes internally, so discovery and
    # reading agree on what is in the bucket.
    file_items = list(glob_files(fs_client, bucket_url, FILE_GLOB))
    check_unique_table_names(file_items, IMAGE_TABLE_NAME)

    return [
        build_object_resource(bucket_url, fs_client, file_item, WRITE_DISPOSITION)
        for file_item in file_items
    ] + [
        build_image_resource(
            bucket_url, fs_client, IMAGE_GLOB, IMAGE_TABLE_NAME, WRITE_DISPOSITION
        )
    ]
