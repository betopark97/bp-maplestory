"""Postgres connection pool.

One pool per process, opened in the FastAPI lifespan and stashed on
``app.state``. Handlers borrow connections from it via ``app.api.deps``.

There is no ORM here by design: ``app.crud`` writes SQL directly and
``app.models`` maps the rows. Connections use ``dict_row`` so results arrive
as mappings that Pydantic row models can validate without an adapter layer.
"""

from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from psycopg.rows import dict_row
from psycopg_pool import AsyncConnectionPool

from app.core.config import get_settings


def build_pool() -> AsyncConnectionPool:
    """Create the pool without connecting; callers open it."""
    settings = get_settings()
    return AsyncConnectionPool(
        conninfo=settings.postgres_dsn,
        min_size=settings.postgres_pool_min_size,
        max_size=settings.postgres_pool_max_size,
        kwargs={"row_factory": dict_row},
        open=False,
    )


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Open the pool for the lifetime of the application."""
    pool = build_pool()
    # wait=True fails fast at boot rather than on the first request.
    await pool.open(wait=True, timeout=10)
    app.state.pool = pool
    try:
        yield
    finally:
        await pool.close()
