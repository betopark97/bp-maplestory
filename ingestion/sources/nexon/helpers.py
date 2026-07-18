import time
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

import dlt

from .settings import REQUEST_DELAY


def default_date():
    """Latest available Nexon data date: the previous day in KST (YYYY-MM-DD)."""
    return (datetime.now(ZoneInfo("Asia/Seoul")) - timedelta(days=1)).strftime(
        "%Y-%m-%d"
    )


def is_ocid_child(endpoint_config):
    """True if the endpoint's only required param is ocid, i.e. it fits the
    uniform 'call with the character's ocid' shape the factory builds."""
    required = [
        p for p, v in endpoint_config.get("params", {}).items() if v == "required"
    ]
    return required == ["ocid"]


def build_ocid_child(endpoint_name, endpoint_config, parent, client, date):
    """Build a transformer that makes one detail call per upstream character,
    passing its ocid (and date, if the endpoint is date-scoped). The same
    identity is stamped onto each row so it is attributable and dated.
    Writes to its own table named `endpoint_name`.

    Date-scoped endpoints keep history: merge on (ocid, date) so re-running a
    date updates in place while new dates accumulate. Others are current-state
    snapshots: replace on every run."""
    has_date = "date" in endpoint_config.get("params", {})
    if has_date:
        write_disposition = "merge"
        primary_key = ["ocid", "date"]
        columns = {"date": {"data_type": "date"}}
    else:
        write_disposition = "replace"
        primary_key = None
        columns = None

    @dlt.transformer(
        data_from=parent,
        name=endpoint_name,
        write_disposition=write_disposition,
        primary_key=primary_key,
        columns=columns,
    )
    def _resource(character):
        time.sleep(REQUEST_DELAY)

        # Stamp query parameters.
        identity = {}
        if has_date:
            identity["date"] = date
        identity["ocid"] = character["ocid"]

        # Actual endpoint response.
        response = client.get(path=endpoint_config["path"], params=identity).json()

        yield {**identity, **response}

    return _resource


def build_notice_id_child(endpoint_name, endpoint_config, parent, client):
    """Build a transformer that makes one detail call per upstream notice,
    passing its notice_id. The same identity is stamped onto each row so
    it is attributable.
    Writes to its own table named `endpoint_name`.

    These are merged on notice_id so re-running a updates in place while new
    notice accumulate."""

    @dlt.transformer(
        data_from=parent,
        name=endpoint_name,
        write_disposition="merge",
        primary_key="notice_id",
    )
    def _resource(notice):
        time.sleep(REQUEST_DELAY)

        # Stamp query parameters.
        identity = {"notice_id": notice["notice_id"]}

        # Actual endpoint response.
        response = client.get(path=endpoint_config["path"], params=identity).json()

        yield {**identity, **response}

    return _resource
