from fastapi import APIRouter

from app.api.routes import characters, favorites, health, hello

api_router = APIRouter()
api_router.include_router(health.router)
api_router.include_router(hello.router)
api_router.include_router(characters.router)
api_router.include_router(favorites.router)
