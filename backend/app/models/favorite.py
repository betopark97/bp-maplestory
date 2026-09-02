from datetime import datetime

from pydantic import BaseModel


class FavoriteCharacter(BaseModel):
    """One row of ``app.favorite_character``.

    App-owned state: it cannot be rebuilt from source the way a mart can, so
    the table is versioned by the migrations in ``backend/migrations``.
    """

    id: int
    ocid: str
    label: str | None = None
    created_at: datetime
