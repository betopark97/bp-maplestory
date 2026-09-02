"""Read-only access to the dbt-owned character marts.

``dbt run`` rebuilds these relations; the API must never write to them.
"""

from psycopg import AsyncConnection, sql

from app.core.config import get_settings
from app.models.character import Character

# Schema is configuration, not user input, but it is still an identifier rather
# than a bind parameter -- compose it with sql.Identifier instead of f-strings.
_TABLE = sql.Identifier(get_settings().marts_schema, "dim_maplestory__characters")

_COLUMNS = sql.SQL(", ").join(sql.Identifier(n) for n in Character.model_fields)


async def get_by_ocid(conn: AsyncConnection, ocid: str) -> Character | None:
    """Return one character by its Nexon ocid, or None if the mart has no row."""
    query = sql.SQL("select {columns} from {table} where ocid = %(ocid)s").format(
        columns=_COLUMNS, table=_TABLE
    )
    async with conn.cursor() as cur:
        await cur.execute(query, {"ocid": ocid})
        row = await cur.fetchone()
    return Character.model_validate(row) if row else None


async def list_by_world(
    conn: AsyncConnection,
    world_name: str,
    limit: int = 50,
    offset: int = 0,
) -> list[Character]:
    """Return characters on a world, newest-created first."""
    query = sql.SQL(
        """
        select {columns}
        from {table}
        where world_name = %(world_name)s
        order by character_date_create desc nulls last, ocid
        limit %(limit)s offset %(offset)s
        """
    ).format(columns=_COLUMNS, table=_TABLE)
    async with conn.cursor() as cur:
        await cur.execute(
            query, {"world_name": world_name, "limit": limit, "offset": offset}
        )
        rows = await cur.fetchall()
    return [Character.model_validate(row) for row in rows]
