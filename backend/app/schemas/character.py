from datetime import datetime

from pydantic import BaseModel


class CharacterResponse(BaseModel):
    """Wire shape of a character.

    Drops the mart's surrogate key and account_id: both are warehouse
    internals with no meaning to an API client.
    """

    ocid: str
    character_name: str | None = None
    world_name: str | None = None
    character_gender: str | None = None
    character_date_create: datetime | None = None
