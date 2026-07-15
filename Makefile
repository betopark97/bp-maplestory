.PHONY: up down backend-run ingestion-run transformation-run clean pre-commit

COMPOSE = docker compose -f infra/docker-compose.yml

up:  ## Start the local dev postgres (detached)
	$(COMPOSE) up -d --build

down:  ## Stop the local dev postgres (keeps data)
	$(COMPOSE) down

clean:  ## Remove python caches, dbt artifacts, and dangling docker images
	find . -type d -name '__pycache__' -not -path '*/.venv/*' -exec rm -rf {} + 2>/dev/null || true
	find . -type d \( -name '.ruff_cache' -o -name '.pytest_cache' \) -not -path '*/.venv/*' -exec rm -rf {} + 2>/dev/null || true
	rm -rf transformation/target transformation/logs transformation/dbt_packages
	docker image prune -f

pre-commit:  ## Preview pre-commit hooks against all files (are we clean to commit?)
	pre-commit run --all-files

backend-run:  ## Run the backend API (dev, auto-reload)
	cd backend && uv run uvicorn main:app --reload

ingestion-run:  ## Run the dlt pipeline
	cd ingestion && uv run python -m pipelines.nexon_pipeline

transformation-run:  ## Run dbt models
	cd transformation && uv run dbt run --profiles-dir .
