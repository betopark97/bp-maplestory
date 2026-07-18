import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.auth import APIKeyAuth

from .helpers import (
    default_date,
    is_ocid_child,
    build_ocid_child,
    build_notice_id_child,
)
from .settings import BASE_URL, ENDPOINTS, MIN_TRACK_LEVEL


@dlt.source(name="nexon", max_table_nesting=0)
def nexon(api_key: str = dlt.secrets.value):
    client = RESTClient(
        base_url=BASE_URL,
        auth=APIKeyAuth(name="x-nxopen-api-key", api_key=api_key, location="header"),
    )

    # This is a default date value for optional date parameters. It defaults to latest - 1 day.
    date = default_date()

    # User Endpoints
    @dlt.resource(name="character_list", write_disposition="replace")
    def character_list():
        yield client.get(path=ENDPOINTS["character_list"]["path"]).json()

    @dlt.resource(name="user_achievement", write_disposition="replace")
    def user_achievement():
        yield client.get(path=ENDPOINTS["user_achievement"]["path"]).json()

    # Character Endpoints
    @dlt.transformer(data_from=character_list, selected=False)
    def filter_characters(character_list):
        for account in character_list["account_list"]:
            for character in account["character_list"]:
                if character["character_level"] > MIN_TRACK_LEVEL:
                    yield character

    ocid_children = [
        build_ocid_child(
            endpoint_name, endpoint_config, filter_characters, client, date
        )
        for endpoint_name, endpoint_config in ENDPOINTS.items()
        if is_ocid_child(endpoint_config)
    ]

    # Notice Endpoints
    # Notice List type endpoints will be parsed because these return
    # the latest 20 notices when called, meaning that we can't control the date.
    @dlt.resource(
        name="notice",
        write_disposition="merge",
        primary_key="notice_id",
    )
    def notice():
        response = client.get(path=ENDPOINTS["notice"]["path"]).json()
        yield from response["notice"]

    @dlt.resource(
        name="notice_update",
        write_disposition="merge",
        primary_key="notice_id",
    )
    def notice_update():
        response = client.get(path=ENDPOINTS["notice_update"]["path"]).json()
        yield from response["update_notice"]

    @dlt.resource(
        name="notice_event",
        write_disposition="merge",
        primary_key="notice_id",
    )
    def notice_event():
        response = client.get(path=ENDPOINTS["notice_event"]["path"]).json()
        yield from response["event_notice"]

    @dlt.resource(
        name="notice_cashshop",
        write_disposition="merge",
        primary_key="notice_id",
    )
    def notice_cashshop():
        response = client.get(path=ENDPOINTS["notice_cashshop"]["path"]).json()
        yield from response["cashshop_notice"]

    # Each *_detail fans over the notice_ids from its matching list parent.
    notice_detail = build_notice_id_child(
        "notice_detail", ENDPOINTS["notice_detail"], notice, client
    )
    notice_update_detail = build_notice_id_child(
        "notice_update_detail", ENDPOINTS["notice_update_detail"], notice_update, client
    )
    notice_event_detail = build_notice_id_child(
        "notice_event_detail", ENDPOINTS["notice_event_detail"], notice_event, client
    )
    notice_cashshop_detail = build_notice_id_child(
        "notice_cashshop_detail",
        ENDPOINTS["notice_cashshop_detail"],
        notice_cashshop,
        client,
    )

    return [
        character_list,
        user_achievement,
        filter_characters,
        *ocid_children,
        notice,
        notice_update,
        notice_event,
        notice_cashshop,
        notice_detail,
        notice_update_detail,
        notice_event_detail,
        notice_cashshop_detail,
    ]
