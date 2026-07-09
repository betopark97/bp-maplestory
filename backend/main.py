from fastapi import FastAPI

from api.router import api_router
from core.config import get_settings


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(title=settings.project_name, debug=settings.debug)
    app.include_router(api_router, prefix=settings.api_v1_prefix)
    return app


app = create_app()


def main() -> None:
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)


if __name__ == "__main__":
    main()
