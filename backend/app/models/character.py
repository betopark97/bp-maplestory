from datetime import datetime

from pydantic import BaseModel


class Character(BaseModel):
    """One row of the dbt mart ``dim_maplestory__characters``.

    Field order mirrors the mart's select list. dbt owns this schema, so
    changes here follow the model, never the other way round.
    """

    character_id: str
    account_id: str | None = None
    ocid: str
    character_name: str | None = None
    world_name: str | None = None
    character_gender: str | None = None
    character_date_create: datetime | None = None
