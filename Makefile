-include .env

help: ## Display all commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

init: ## Project configuration initialization
	@echo "${BLUE}Project configuration initialization:${NC}"
	@cp .env.dist .env

docker-start: ## Launch all containers
	@echo "${BLUE}Launch all containers${NC}"
	@docker-compose up -d

install: ## Init the project
	@echo "${BLUE}Install the project${NC}"
	docker-start
	@docker-compose run --rm nodejs yarn init -y
	@docker-compose run --rm nodejs yarn add webiny-cli --dev
	@docker-compose run --rm nodejs node_modules/.bin/webiny init
	@docker-compose run --rm nodejs node_modules/.bin/webiny install-functions

start-functions: ## Start functions api
	@echo "${BLUE}Start functions api ${NC}"
	@docker-compose run -p 9000:9000 --rm nodejs node_modules/.bin/webiny start-functions

start-admin: ## Start Admin
	@docker-compose run -p 3001:3001 --rm nodejs node_modules/.bin/webiny start-app admin

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


.SILENT:
.PHONY: