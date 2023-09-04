
.PHONY: build blank

blank:
	@bash contrib/blank.sh

build:
	bash build.sh

update:
	bash contrib/update.sh $(tag)


## =====
## Tests
## =====

test-blank-branch:
	@bash tests/blank-branch-test.sh

test-update:
	@bash contrib/update.sh 7.1.0

test-docker:
	@docker compose build vtiger
	@docker compose run --rm vtiger bash /usr/local/bin/vtiger-install.sh --install-mysql --assert-mysql --wizard --dump
	@docker compose up -d
	@docker compose logs -f vtiger
