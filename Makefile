.PHONY: help dev-up dev-down dev-logs dev-build prod-up prod-down prod-logs prod-build clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Development commands
dev-build: ## Build development images
	docker compose -f docker-compose.dev.yml build

dev-up: ## Start development environment
	docker compose -f docker-compose.dev.yml up -d

dev-down: ## Stop development environment
	docker compose -f docker-compose.dev.yml down

dev-restart: ## Restart development environment
	docker compose -f docker-compose.dev.yml restart

dev-logs: ## View development logs (follow)
	docker compose -f docker-compose.dev.yml logs -f

dev-shell: ## Access app container shell in development
	docker compose -f docker-compose.dev.yml exec app sh

dev-ps: ## Show running development containers
	docker compose -f docker-compose.dev.yml ps

# Production commands
prod-build: ## Build production images
	docker compose -f docker-compose.prod.yml build

prod-up: ## Start production environment
	docker compose -f docker-compose.prod.yml up -d

prod-down: ## Stop production environment
	docker compose -f docker-compose.prod.yml down

prod-restart: ## Restart production environment
	docker compose -f docker-compose.prod.yml restart

prod-logs: ## View production logs (follow)
	docker compose -f docker-compose.prod.yml logs -f

prod-shell: ## Access app container shell in production
	docker compose -f docker-compose.prod.yml exec app sh

prod-ps: ## Show running production containers
	docker compose -f docker-compose.prod.yml ps

# Database commands
db-shell-dev: ## Access PostgreSQL shell in development
	docker compose -f docker-compose.dev.yml exec postgres psql -U devuser -d devdb

db-shell-prod: ## Access PostgreSQL shell in production
	docker compose -f docker-compose.prod.yml exec postgres psql -U $$POSTGRES_USER -d $$POSTGRES_DB

db-backup-prod: ## Backup production database
	@mkdir -p ./backups
	docker compose -f docker-compose.prod.yml exec -T postgres pg_dump -U $$POSTGRES_USER $$POSTGRES_DB > ./backups/backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backup created in ./backups/"

db-restore-prod: ## Restore production database from backup (set BACKUP_FILE=path/to/backup.sql)
	@if [ -z "$(BACKUP_FILE)" ]; then echo "Usage: make db-restore-prod BACKUP_FILE=./backups/backup.sql"; exit 1; fi
	docker compose -f docker-compose.prod.yml exec -T postgres psql -U $$POSTGRES_USER $$POSTGRES_DB < $(BACKUP_FILE)

# Redis commands
redis-cli-dev: ## Access Redis CLI in development
	docker compose -f docker-compose.dev.yml exec redis redis-cli

redis-cli-prod: ## Access Redis CLI in production
	docker compose -f docker-compose.prod.yml exec redis redis-cli -a $$REDIS_PASSWORD

# Cleanup commands
clean-dev: ## Remove development containers and volumes
	docker compose -f docker-compose.dev.yml down -v

clean-prod: ## Remove production containers and volumes (DANGEROUS!)
	@echo "⚠️  WARNING: This will delete all production data!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		docker compose -f docker-compose.prod.yml down -v; \
		echo "✓ Production environment cleaned"; \
	else \
		echo "✗ Cancelled"; \
	fi

clean: ## Remove all containers, volumes, and orphaned images
	docker compose -f docker-compose.dev.yml down -v 2>/dev/null || true
	docker compose -f docker-compose.prod.yml down -v 2>/dev/null || true
	docker system prune -f

# Environment setup
setup-dev: ## Create .env.dev from example (if it doesn't exist)
	@if [ ! -f .env.dev ]; then \
		echo "Creating .env.dev from example..."; \
		grep -A 20 "^# .env.dev" .env.example | tail -n +2 > .env.dev; \
		echo "✓ .env.dev created. Please review and update as needed."; \
	else \
		echo "✗ .env.dev already exists"; \
	fi

setup-prod: ## Create .env.prod from example (if it doesn't exist)
	@if [ ! -f .env.prod ]; then \
		echo "Creating .env.prod from example..."; \
		grep -A 30 "^# .env.prod" .env.example | tail -n +2 > .env.prod; \
		echo "⚠️  .env.prod created. IMPORTANT: Update all passwords and secrets!"; \
	else \
		echo "✗ .env.prod already exists"; \
	fi

# Quick start
dev: setup-dev dev-build dev-up ## Quick start development environment
	@echo ""
	@echo "✓ Development environment is running!"
	@echo "  App: http://localhost:8080"
	@echo "  Adminer: http://localhost:8081"
	@echo ""
	@echo "View logs: make dev-logs"

prod: setup-prod prod-build prod-up ## Quick start production environment
	@echo ""
	@echo "✓ Production environment is running!"
	@echo "  App: http://localhost:8080"
	@echo ""
	@echo "View logs: make prod-logs"