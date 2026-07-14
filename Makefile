.PHONY: up down db-logs db-psql backend-sync backend-run ingestion-sync ingestion-run transformation-sync transformation-debug transformation-run

COMPOSE = docker compose -f infra/docker-compose.yml

up:  ## Start the local dev postgres (detached)
	$(COMPOSE) up -d --build

down:  ## Stop the local dev postgres (keeps data)
	$(COMPOSE) down

db-logs:  ## Tail postgres logs
	$(COMPOSE) logs -f postgres

db-psql:  ## Open a psql shell in the container
	$(COMPOSE) exec postgres psql -U $${POSTGRES_USER:-postgres} -d $${POSTGRES_DB:-maplestory}

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
