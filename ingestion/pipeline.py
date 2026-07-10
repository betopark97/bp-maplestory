"""Starter dlt pipeline: extract + load.

Template only — replace the example resource with a real source.
Credentials for the postgres destination live in .dlt/secrets.toml
(copy from .dlt/secrets.toml.example). Run with:

    uv run python pipeline.py
"""

import dlt


@dlt.resource(name="example", write_disposition="replace")
def example_source():
    """Placeholder resource. Swap for a real API/DB/file extractor."""
    yield {"id": 1, "name": "placeholder"}


def run() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="maplestory",
        destination="postgres",
        dataset_name="raw",
    )
    load_info = pipeline.run(example_source())
    print(load_info)


if __name__ == "__main__":
    run()
