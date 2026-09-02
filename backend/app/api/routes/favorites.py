from fastapi import APIRouter, HTTPException, Query, status

from app.api.deps import Conn
from app.crud import crud_favorite
from app.schemas.favorite import FavoriteCharacterCreate, FavoriteCharacterResponse

router = APIRouter(prefix="/favorites", tags=["favorites"])


@router.post(
    "", response_model=FavoriteCharacterResponse, status_code=status.HTTP_201_CREATED
)
async def create_favorite(
    data: FavoriteCharacterCreate, conn: Conn
) -> FavoriteCharacterResponse:
    """Save a character as a favorite."""
    favorite = await crud_favorite.create(conn, data)
    return FavoriteCharacterResponse.model_validate(favorite, from_attributes=True)


@router.get("", response_model=list[FavoriteCharacterResponse])
async def list_favorites(
    conn: Conn,
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
) -> list[FavoriteCharacterResponse]:
    """Return saved favorites, newest first."""
    favorites = await crud_favorite.list_all(conn, limit, offset)
    return [
        FavoriteCharacterResponse.model_validate(f, from_attributes=True)
        for f in favorites
    ]


@router.delete("/{favorite_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_favorite(favorite_id: int, conn: Conn) -> None:
    """Remove a favorite."""
    if not await crud_favorite.delete(conn, favorite_id):
        raise HTTPException(status.HTTP_404_NOT_FOUND, detail="Favorite not found")
