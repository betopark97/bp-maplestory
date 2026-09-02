import argparse
from datetime import datetime

import dlt

from sources.nexon import nexon
from sources.nexon.helpers import default_date
from sources.nexon.settings import MIN_DATE

REFRESH_MODES = ("drop_sources", "drop_resources", "drop_data")


def query_date(value: str) -> str:
    """Validate --date up front, before any API calls are spent: it must parse
    as YYYY-MM-DD and fall inside the window the API actually serves."""
    try:
        parsed = datetime.strptime(value, "%Y-%m-%d").date()
    except ValueError:
        raise argparse.ArgumentTypeError(f"{value!r} is not a YYYY-MM-DD date")

    floor = datetime.strptime(MIN_DATE, "%Y-%m-%d").date()
    latest = datetime.strptime(default_date(), "%Y-%m-%d").date()
    if not floor <= parsed <= latest:
        raise argparse.ArgumentTypeError(
            f"{value} is outside the available window {floor}..{latest}"
        )
    return value


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Load the Nexon MapleStory OpenAPI into Postgres."
    )
    parser.add_argument(
        "--date",
        type=query_date,
        help=(
            "Query date for date-scoped endpoints (YYYY-MM-DD, KST). Defaults to "
            "yesterday. Date-scoped tables merge on (ocid, date), so re-running a "
            "past date updates it in place."
        ),
    )
    parser.add_argument(
        "--refresh",
        choices=REFRESH_MODES,
        help=(
            "Reset before loading. drop_sources drops every table in the source, "
            "drop_resources only the selected ones, drop_data truncates rows but "
            "leaves the schema. Either drop fails while dbt views still reference "
            "the tables."
        ),
    )
    return parser.parse_args()


def run(date: str | None = None, refresh: str | None = None) -> None:
    pipeline = dlt.pipeline(
        pipeline_name="nexon",
        destination="postgres",
        dataset_name="raw_nexon",
    )
    load_info = pipeline.run(nexon(date=date), refresh=refresh)
    print(load_info)


if __name__ == "__main__":
    args = parse_args()
    run(date=args.date, refresh=args.refresh)
