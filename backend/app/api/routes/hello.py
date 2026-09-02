from fastapi import APIRouter

from app.schemas.hello import HelloResponse

router = APIRouter(tags=["hello"])


@router.get("/hello", response_model=HelloResponse)
async def hello() -> HelloResponse:
    """Return a greeting."""
    return HelloResponse(message="Hello, world!")
