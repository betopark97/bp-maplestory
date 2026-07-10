.PHONY: backend-sync backend-run ingestion-sync ingestion-run

backend-sync:  ## Install/refresh backend deps into backend/.venv
	cd backend && uv sync

backend-run: backend-sync  ## Start the backend (dev, auto-reload)
	cd backend && uv run uvicorn main:app --reload

ingestion-sync:  ## Install/refresh ingestion deps into ingestion/.venv
	cd ingestion && uv sync

ingestion-run: ingestion-sync  ## Run the dlt pipeline
	cd ingestion && uv run python pipeline.py
