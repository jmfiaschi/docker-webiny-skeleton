-include .env

.SILENT:
.PHONY: install start stop restart logs help

help: ## Display all commands.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install: ## Install the project.
	@echo "${BLUE}Install the project${NC}"
	@cp .env.dist .env
	@docker-compose up -d
	@docker-compose run --rm nodejs yarn init -y
	@docker-compose run --rm nodejs yarn add webiny-cli --dev -W
	@docker-compose run --rm nodejs node_modules/.bin/webiny init
	@docker-compose run --rm nodejs node_modules/.bin/webiny install-functions

start: ## Launch all containers.
	@echo "${BLUE}Launch all containers if they are not running${NC}"
	@docker-compose up -d
	@echo "${BLUE}Start functions api : http://localhost:9000/function/api${NC}"
	@docker-compose run -p 9000:9000 -d --rm nodejs node_modules/.bin/webiny start-functions
	@echo "${BLUE}Start Admin Interface : http://localhost:3001${NC}"
	@echo "${GREEN}Default login => admin@webiny.com / 12345678${NC}"
	@docker-compose run -p 3001:3001 -d --rm nodejs node_modules/.bin/webiny start-app admin
	@echo "${BLUE}Start Site Interface : http://localhost:3002${NC}"
	@docker-compose run -p 3002:3002 -d --rm nodejs node_modules/.bin/webiny start-app site

stop: ## Stop all containers.
	@echo "${BLUE}stop all containers if they are running${NC}"
	@docker-compose down

restart: ## Restart all containers.
restart: stop start

logs: ## Display logs.
	@docker-compose logs -f

# Shell colors.
RED=\033[0;31m
LIGHT_RED=\033[1;31m
GREEN=\033[0;32m
LIGHT_GREEN=\033[1;32m
ORANGE=\033[0;33m
YELLOW=\033[1;33m
BLUE=\033[0;34m
LIGHT_BLUE=\033[1;34m
PURPLE=\033[0;35m
LIGHT_PURPLE=\033[1;35m
CYAN=\033[0;36m
LIGHT_CYAN=\033[1;36m
NC=\033[0m