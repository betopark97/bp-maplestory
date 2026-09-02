from functools import lru_cache
from pathlib import Path

from pydantic import PostgresDsn, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

BACKEND_DIR = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    """Application settings, loaded from environment / .env file."""

    model_config = SettingsConfigDict(
        # Anchored to backend/ so the app resolves the same .env regardless of cwd.
        env_file=BACKEND_DIR / ".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    project_name: str = "bp-maplestory"
    api_v1_prefix: str = "/api/v1"
    debug: bool = False

    postgres_host: str = "localhost"
    postgres_port: int = 5432
    postgres_user: str = "bp_maplestory"
    postgres_password: SecretStr = SecretStr("")
    # The database carries the environment: dev_maplestory, prod_maplestory.
    # Schema names are identical in every one of them, so this is the only
    # setting that changes when this service moves environment.
    postgres_db: str = "dev_maplestory"

    # Schema owned by this service: mutable state, migrated by yoyo.
    app_schema: str = "app"
    # Schema owned by dbt: rebuilt by `dbt run`, read-only from here.
    marts_schema: str = "marts"

    postgres_pool_min_size: int = 1
    postgres_pool_max_size: int = 10

    @property
    def postgres_dsn(self) -> str:
        """libpq connection string for psycopg.

        Deliberately a plain property, not a computed_field: it must not show
        up in model_dump(), which would put the password in any settings echo.
        """
        return str(
            PostgresDsn.build(
                scheme="postgresql",
                username=self.postgres_user,
                password=self.postgres_password.get_secret_value(),
                host=self.postgres_host,
                port=self.postgres_port,
                path=self.postgres_db,
            )
        )


@lru_cache
def get_settings() -> Settings:
    """Return a cached Settings instance."""
    return Settings()
