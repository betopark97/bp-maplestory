from fastapi import APIRouter

from core.config import get_settings
from schemas.health import HealthResponse

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
async def health_check() -> HealthResponse:
    """Liveness probe."""
    return HealthResponse(service=get_settings().project_name)
