import dlt
from dlt.sources.rest_api import rest_api_resources

from .settings import (
    BASE_URL,
    CHARACTER_LIST,
    USER_ACHIEVEMENT,
    ID,
    CHARACTER_BASIC,
    CHARACTER_POPULARITY,
    CHARACTER_STAT,
    CHARACTER_HYPER_STAT,
    CHARACTER_PROPENSITY,
    CHARACTER_ABILITY,
    CHARACTER_ITEM_EQUIPMENT,
    CHARACTER_CASH_ITEM_EQUIPMENT,
    CHARACTER_SYMBOL_EQUIPMENT,
    CHARACTER_SET_EFFECT,
    CHARACTER_BEAUTY_EQUIPMENT,
    CHARACTER_ANDROID_EQUIPMENT,
    CHARACTER_PET_EQUIPMENT,
    CHARACTER_SKILL,
    CHARACTER_LINK_SKILL,
    CHARACTER_VMATRIX,
    CHARACTER_HEXAMATRIX,
    CHARACTER_HEXAMATRIX_STAT,
    CHARACTER_DOJANG,
    CHARACTER_OTHER_STAT,
    CHARACTER_RING_EXCHANGE_SKILL_EQUIPMENT,
    CHARACTER_RING_RESERVE_SKILL_EQUIPMENT
)


@dlt.source(name="nexon")
def nexon(api_key: str = dlt.secrets.value):
    config = {
        "client": {
            "base_url": BASE_URL,
            "auth": {
                "type": "api_key",
                "name": "x-nxopen-api-key",
                "api_key": api_key,
                "location": "header"
            },
        },
        "resources": [
            {
                "name": "character_list",
                "endpoint": {"path": CHARACTER_LIST},
                "write_disposition": "replace",
            }
        ],
    }

    return rest_api_resources(config)
