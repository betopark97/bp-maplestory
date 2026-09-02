import dlt

from sources.google_sheets import google_sheets


def run() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="google_sheets",
        destination="postgres",
        dataset_name="raw_google_sheets",
    )
    load_info = pipeline.run(google_sheets())
    print(load_info)


if __name__ == "__main__":
    run()
