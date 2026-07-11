.PHONY: backend-sync backend-run ingestion-sync ingestion-run transformation-sync transformation-debug transformation-run

backend-sync:  ## Install/refresh backend deps into backend/.venv
	cd backend && uv sync

backend-run: backend-sync  ## Start the backend (dev, auto-reload)
	cd backend && uv run uvicorn main:app --reload

ingestion-sync:  ## Install/refresh ingestion deps into ingestion/.venv
	cd ingestion && uv sync

ingestion-run: ingestion-sync  ## Run the dlt pipeline
	cd ingestion && uv run python pipeline.py

transformation-sync:  ## Install/refresh transformation deps into transformation/.venv
	cd transformation && uv sync

transformation-debug: transformation-sync  ## Verify dbt config + DB connection
	cd transformation && uv run dbt debug --profiles-dir .

transformation-run: transformation-sync  ## Run dbt models
	cd transformation && uv run dbt run --profiles-dir .
