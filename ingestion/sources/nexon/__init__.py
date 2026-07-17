import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.auth import APIKeyAuth

from .settings import BASE_URL, ENDPOINTS, MIN_TRACK_LEVEL


@dlt.source(name="nexon", max_table_nesting=0)
def nexon(api_key: str = dlt.secrets.value):
    client = RESTClient(
        base_url=BASE_URL,
        auth=APIKeyAuth(name="x-nxopen-api-key", api_key=api_key, location="header"),
    )

    @dlt.resource(name="character_list", write_disposition="replace")
    def character_list():
        yield client.get(ENDPOINTS["character_list"]).json()

    @dlt.transformer(data_from=character_list, selected=False)
    def filter_characters(character_list):
        for account in character_list["account_list"]:
            for character in account["character_list"]:
                if character["character_level"] > MIN_TRACK_LEVEL:
                    yield character

    @dlt.transformer(
        data_from=filter_characters, name="character_basic", write_disposition="replace"
    )
    def character_basic(character):
        yield client.get(
            ENDPOINTS["character_basic"],
            params={"ocid": character["ocid"]},
        ).json()

    @dlt.resource(name="user_achievement", write_disposition="replace")
    def user_achievement():
        yield client.get(ENDPOINTS["user_achievement"]).json()

    return [character_list, filter_characters, character_basic, user_achievement]
