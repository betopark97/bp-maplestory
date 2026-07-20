.PHONY: up down backend-run ingestion-run dlt-pipeline-show transformation-run clean pre-commit drop-schema

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

drop-schema:  ## Drop a schema + its dlt staging from the maplestory db (requires SCHEMA=<name>)
	@test -n "$(SCHEMA)" || { echo "SCHEMA is required, e.g. make drop-schema SCHEMA=nexon"; exit 1; }
	@echo "Dropping schema '$(SCHEMA)' and '$(SCHEMA)_staging' from maplestory db..."
	$(COMPOSE) exec -T postgres sh -c 'psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB" \
		-c "DROP SCHEMA IF EXISTS $(SCHEMA) CASCADE;" \
		-c "DROP SCHEMA IF EXISTS $(SCHEMA)_staging CASCADE;"'

backend-run:  ## Run the backend API (dev, auto-reload)
	cd backend && uv run uvicorn main:app --reload

ingestion-run:  ## Run the dlt pipeline
	cd ingestion && uv run python -m pipelines.nexon_pipeline

dlt-pipeline-show:  ## Launch the dlt pipeline dashboard (marimo)
	cd ingestion && uv run dlt pipeline nexon show

transformation-run:  ## Run dbt models
	cd transformation && uv run dbt run --profiles-dir .
