.PHONY: help check-env clean pre-commit up down drop-schema backend-run ingestion-run dlt-pipeline-show transformation-run transformation-test

COMPOSE = docker compose -f infra/docker-compose.yml

# Which environment every target acts on: `make ingestion-run ENV=prod`.
# The default is dev so that no bare command can reach another environment.
ENV ?= dev

# The environment lives in the database name; the schemas inside are identical
# in all of them. dlt takes it as a workspace profile, dbt as a target.
DB = $(ENV)_maplestory

# dbt Core does not read a .env, so credentials are sourced before it runs.
DBT = set -a; . ./.env; set +a; uv run dbt

.DEFAULT_GOAL := help

help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "  ENV=$(ENV) -> database $(DB). Override per invocation: make <target> ENV=prod"

# prod_maplestory does not exist yet -- prod is deferred until there is an MVP and
# a Dagster schedule behind it. Failing here beats failing halfway through a load
# with a connection error that reads like a broken config.
check-env:
	@case "$(ENV)" in \
		dev|tests) ;; \
		prod) echo "ENV=prod: prod_maplestory is not stood up yet -- see the 'Stand up the prod database' ticket."; exit 1 ;; \
		*) echo "ENV=$(ENV) is not an environment. Use dev or tests."; exit 1 ;; \
	esac

clean:  ## Remove python caches, dbt artifacts, and dangling docker images
	find . -type d -name '__pycache__' -not -path '*/.venv/*' -exec rm -rf {} + 2>/dev/null || true
	find . -type d \( -name '.ruff_cache' -o -name '.pytest_cache' \) -not -path '*/.venv/*' -exec rm -rf {} + 2>/dev/null || true
	rm -rf transformation/target transformation/logs transformation/dbt_packages
	docker image prune -f

pre-commit:  ## Preview pre-commit hooks against all files (are we clean to commit?)
	pre-commit run --all-files

up:  ## Start the local dev postgres (detached)
	$(COMPOSE) up -d --build

down:  ## Stop the local dev postgres (keeps data)
	$(COMPOSE) down

# Only dlt's raw schemas have a companion _staging (its staging_dataset_name_layout
# is "%s_staging"). dbt's staging/intermediate/marts do not, and dropping
# "staging_staging" would be a no-op that reads like it did something.
drop-schema: check-env  ## Drop a schema, plus its dlt staging if it is a raw_ one (requires SCHEMA=<name>)
	@test -n "$(SCHEMA)" || { echo "SCHEMA is required, e.g. make drop-schema SCHEMA=raw_nexon"; exit 1; }
	@echo "Dropping schema '$(SCHEMA)' from $(DB)..."
	$(COMPOSE) exec -T postgres sh -c 'psql -U "$$POSTGRES_USER" -d "$(DB)" \
		-c "DROP SCHEMA IF EXISTS $(SCHEMA) CASCADE;"'
	@case "$(SCHEMA)" in raw_*) \
		echo "Dropping its dlt staging schema '$(SCHEMA)_staging' from $(DB)..."; \
		$(COMPOSE) exec -T postgres sh -c 'psql -U "$$POSTGRES_USER" -d "$(DB)" \
			-c "DROP SCHEMA IF EXISTS $(SCHEMA)_staging CASCADE;"' ;; \
	esac

backend-run:  ## Run the backend API (dev, auto-reload)
	cd backend && uv run uvicorn app.main:app --reload

# yoyo only ever touches the app-owned schema; dbt owns staging/intermediate/marts.
# The backend picks its own database from backend/.env (POSTGRES_DB), not from ENV,
# because it is a running service rather than a job you point at an environment.
MIGRATE = cd backend && uv run python -m app.db.migrate

backend-migrate:  ## Apply pending backend migrations to the app schema
	$(MIGRATE) apply

backend-migrate-rollback:  ## Roll back the most recent backend migration
	$(MIGRATE) rollback

backend-migrate-list:  ## Show backend migration status
	$(MIGRATE) list

ingestion-run: check-env  ## Run the dlt pipeline (ENV picks the workspace profile)
	cd ingestion && WORKSPACE__PROFILE=$(ENV) uv run python -m pipelines.nexon_pipeline

dlt-pipeline-show: check-env  ## Launch the dlt pipeline dashboard (marimo)
	cd ingestion && WORKSPACE__PROFILE=$(ENV) uv run dlt pipeline nexon show

transformation-run: check-env  ## Run dbt models (ENV picks the dbt target)
	cd transformation && $(DBT) run --profiles-dir . -t $(ENV)

transformation-test: check-env  ## Run dbt data tests
	cd transformation && $(DBT) test --profiles-dir . -t $(ENV)
