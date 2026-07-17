import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.auth import APIKeyAuth

from .helpers import build_ocid_child, is_ocid_child
from .settings import BASE_URL, ENDPOINTS, MIN_TRACK_LEVEL


@dlt.source(name="nexon", max_table_nesting=0)
def nexon(api_key: str = dlt.secrets.value):
    client = RESTClient(
        base_url=BASE_URL,
        auth=APIKeyAuth(name="x-nxopen-api-key", api_key=api_key, location="header"),
    )

    @dlt.resource(name="character_list", write_disposition="replace")
    def character_list():
        yield client.get(path=ENDPOINTS["character_list"]["path"]).json()

    @dlt.resource(name="user_achievement", write_disposition="replace")
    def user_achievement():
        yield client.get(path=ENDPOINTS["user_achievement"]["path"]).json()

    @dlt.transformer(data_from=character_list, selected=False)
    def filter_characters(character_list):
        for account in character_list["account_list"]:
            for character in account["character_list"]:
                if character["character_level"] > MIN_TRACK_LEVEL:
                    yield character

    ocid_children = [
        build_ocid_child(name, spec, filter_characters, client)
        for name, spec in ENDPOINTS.items()
        if is_ocid_child(spec)
    ]

    return [character_list, filter_characters, user_achievement, *ocid_children]
