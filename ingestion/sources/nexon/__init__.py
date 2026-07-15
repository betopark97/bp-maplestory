import dlt
from dlt.sources.rest_api import rest_api_resources

from .settings import BASE_URL, ENDPOINTS


@dlt.source(name="nexon", max_table_nesting=0)
def nexon(api_key: str = dlt.secrets.value):
    config = {
        "client": {
            "base_url": BASE_URL,
            "auth": {
                "type": "api_key",
                "name": "x-nxopen-api-key",
                "api_key": api_key,
                "location": "header",
            },
        },
        "resources": [
            {
                "name": "character_list",
                "endpoint": {"path": ENDPOINTS["character_list"]},
                "write_disposition": "replace",
            },
            {
                "name": "user_achievement",
                "endpoint": {"path": ENDPOINTS["user_achievement"]},
                "write_disposition": "replace",
            },
        ],
    }

    return rest_api_resources(config)
