"""Shared FastAPI dependencies."""

from collections.abc import AsyncIterator
from typing import Annotated

from fastapi import Depends, Request
from psycopg import AsyncConnection
from psycopg_pool import AsyncConnectionPool


def get_pool(request: Request) -> AsyncConnectionPool:
    """Return the process-wide pool opened by the lifespan."""
    return request.app.state.pool


async def get_conn(
    pool: Annotated[AsyncConnectionPool, Depends(get_pool)],
) -> AsyncIterator[AsyncConnection]:
    """Yield a connection scoped to the request.

    ``pool.connection()`` wraps the block in a transaction: it commits when the
    handler returns and rolls back if it raises, so crud functions never call
    commit themselves.
    """
    async with pool.connection() as conn:
        yield conn


# Route signatures read as `conn: Conn` instead of repeating the Depends chain.
Conn = Annotated[AsyncConnection, Depends(get_conn)]
