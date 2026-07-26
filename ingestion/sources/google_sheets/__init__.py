from urllib.parse import quote

import dlt
from dlt.sources.credentials import GcpServiceAccountCredentials
from dlt.sources.helpers.rest_client import RESTClient

from .helpers import bearer_auth, rows_from_values
from .settings import BASE_URL, SPREADSHEET_ID, TABS


@dlt.source(name="google_sheets", max_table_nesting=0)
def google_sheets(credentials: GcpServiceAccountCredentials = dlt.secrets.value):
    client = RESTClient(base_url=BASE_URL, auth=bearer_auth(credentials))

    def build_tab_resource(tab):
        @dlt.resource(
            name=tab,
            write_disposition="merge",
            primary_key=["boss_name", "difficulty"],
        )
        def _resource():
            # `tab` alone as the range means "the whole tab". quote() escapes
            # spaces/special chars in the tab name for the URL path.
            path = f"/v4/spreadsheets/{SPREADSHEET_ID}/values/{quote(tab)}"
            response = client.get(path=path).json()
            yield from rows_from_values(response.get("values", []))

        return _resource

    return [build_tab_resource(tab) for tab in TABS]
