include .env
export

export PROJECT_ROOT=$(shell pwd)
export MSYS_NO_PATHCONV=1

env-up:
	@docker compose up -d todo-app-postgres

env-down:
	@docker compose down todo-app-postgres

env-cleanup:
	@read -p "Do you want to clean all environment files? DANGEROUS [y/n]: " answer; \
	if [ "$$answer" = "y" ]; then \
		docker compose down todo-app-postgres && \
		rm -rf out/pgdata && \
		echo "Environment files is cleaned"; \
	else \
		echo "Cleaning of environment files is cancelled"; \
	fi

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "No pass require params seq. Ex: make migrate-create seq=init"; \
		exit 1; \
	fi; \
	docker compose run --rm todo-app-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "No pass require params action. Ex: make migrate-action action=up"; \
		exit 1; \
	fi; \
	docker compose run --rm todo-app-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todo-app-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		"$(action)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down