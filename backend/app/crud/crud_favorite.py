"""Read/write access to the app-owned ``favorite_character`` table.

This is the service's own mutable state. Its DDL lives in
``backend/migrations``, not in dbt.
"""

from psycopg import AsyncConnection, sql

from app.core.config import get_settings
from app.models.favorite import FavoriteCharacter
from app.schemas.favorite import FavoriteCharacterCreate

_TABLE = sql.Identifier(get_settings().app_schema, "favorite_character")

_COLUMNS = sql.SQL(", ").join(
    sql.Identifier(name) for name in FavoriteCharacter.model_fields
)


async def create(
    conn: AsyncConnection, data: FavoriteCharacterCreate
) -> FavoriteCharacter:
    """Insert a favorite and return the stored row."""
    query = sql.SQL(
        """
        insert into {table} (ocid, label)
        values (%(ocid)s, %(label)s)
        returning {columns}
        """
    ).format(table=_TABLE, columns=_COLUMNS)
    async with conn.cursor() as cur:
        await cur.execute(query, data.model_dump())
        row = await cur.fetchone()
    return FavoriteCharacter.model_validate(row)


async def list_all(
    conn: AsyncConnection, limit: int = 50, offset: int = 0
) -> list[FavoriteCharacter]:
    """Return favorites, newest first."""
    query = sql.SQL(
        """
        select {columns}
        from {table}
        order by created_at desc, id desc
        limit %(limit)s offset %(offset)s
        """
    ).format(columns=_COLUMNS, table=_TABLE)
    async with conn.cursor() as cur:
        await cur.execute(query, {"limit": limit, "offset": offset})
        rows = await cur.fetchall()
    return [FavoriteCharacter.model_validate(row) for row in rows]


async def delete(conn: AsyncConnection, favorite_id: int) -> bool:
    """Delete a favorite. Returns False if it was already gone."""
    query = sql.SQL("delete from {table} where id = %(id)s").format(table=_TABLE)
    async with conn.cursor() as cur:
        await cur.execute(query, {"id": favorite_id})
        return cur.rowcount > 0
