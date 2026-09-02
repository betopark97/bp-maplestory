"""Migration entrypoint for the app-owned schema.

Wraps yoyo's Python API rather than its CLI so the DSN comes from Settings.
That keeps the password out of argv (and out of make's command echo), and
avoids shell-sourcing a .env whose values may contain spaces or quotes.

Only ``settings.app_schema`` is in scope here. The staging / intermediate /
marts schemas are dbt's; they are rebuilt from source, not migrated.

Usage:
    uv run python -m app.db.migrate [apply|rollback|list]
"""

import sys
from pathlib import Path

from yoyo import get_backend, read_migrations

from app.core.config import get_settings

MIGRATIONS_DIR = Path(__file__).resolve().parents[2] / "migrations"


def _backend():
    dsn = get_settings().postgres_dsn
    # yoyo picks its driver from the scheme; route it at psycopg3.
    return get_backend(dsn.replace("postgresql://", "postgresql+psycopg://", 1))


def main() -> int:
    command = sys.argv[1] if len(sys.argv) > 1 else "apply"
    backend = _backend()
    migrations = read_migrations(str(MIGRATIONS_DIR))

    with backend.lock():
        if command == "apply":
            pending = backend.to_apply(migrations)
            if not pending:
                print("No pending migrations.")
                return 0
            backend.apply_migrations(pending)
            for migration in pending:
                print(f"applied  {migration.id}")
        elif command == "rollback":
            latest = backend.to_rollback(migrations)[:1]
            if not latest:
                print("Nothing to roll back.")
                return 0
            backend.rollback_migrations(latest)
            for migration in latest:
                print(f"rolled back  {migration.id}")
        elif command == "list":
            for migration in migrations:
                state = "applied" if backend.is_applied(migration) else "pending"
                print(f"{state:>8}  {migration.id}")
        else:
            print(f"unknown command: {command!r} (apply|rollback|list)")
            return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
