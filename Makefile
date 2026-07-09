.PHONY: backend-sync backend-run

backend-sync:  ## Install/refresh backend deps into backend/.venv
	cd backend && uv sync

backend-run: backend-sync  ## Start the backend (dev, auto-reload)
	cd backend && uv run uvicorn main:app --reload
