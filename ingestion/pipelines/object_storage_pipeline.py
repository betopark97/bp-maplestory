import dlt

from sources.object_storage import object_storage


def run() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="object_storage",
        destination="postgres",
        dataset_name="object_storage",
    )
    load_info = pipeline.run(object_storage())
    print(load_info)


if __name__ == "__main__":
    run()
