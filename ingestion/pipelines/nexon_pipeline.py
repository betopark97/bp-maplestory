import dlt

from sources.nexon import nexon


def run() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="nexon",
        destination="postgres",
        dataset_name="nexon",
    )
    load_info = pipeline.run(nexon())
    print(load_info)


if __name__ == "__main__":
    run()
