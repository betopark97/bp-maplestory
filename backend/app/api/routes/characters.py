from fastapi import APIRouter, HTTPException, Query, status

from app.api.deps import Conn
from app.crud import crud_character
from app.schemas.character import CharacterResponse

router = APIRouter(prefix="/characters", tags=["characters"])


@router.get("/{ocid}", response_model=CharacterResponse)
async def get_character(ocid: str, conn: Conn) -> CharacterResponse:
    """Return one character from the dbt mart."""
    character = await crud_character.get_by_ocid(conn, ocid)
    if character is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, detail="Character not found")
    return CharacterResponse.model_validate(character, from_attributes=True)


@router.get("", response_model=list[CharacterResponse])
async def list_characters(
    conn: Conn,
    world_name: str,
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
) -> list[CharacterResponse]:
    """Return characters on a world."""
    characters = await crud_character.list_by_world(conn, world_name, limit, offset)
    return [
        CharacterResponse.model_validate(c, from_attributes=True) for c in characters
    ]
