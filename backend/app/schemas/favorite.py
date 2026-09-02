from datetime import datetime

from pydantic import BaseModel, Field


class FavoriteCharacterCreate(BaseModel):
    """Request body for creating a favorite."""

    ocid: str = Field(min_length=1)
    label: str | None = Field(default=None, max_length=100)


class FavoriteCharacterResponse(BaseModel):
    """Wire shape of a favorite.

    Identical to the ``FavoriteCharacter`` row model today. Kept separate on
    purpose: the seam is what lets a column rename stay invisible to clients.
    """

    id: int
    ocid: str
    label: str | None = None
    created_at: datetime
