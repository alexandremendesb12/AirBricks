###### OS Detection ######
ifeq ($(OS), Windows_NT)
    DETECTED_OS := Windows
    PYTHON_SETUP := python
    PYTHON_BIN := .env/Scripts
else
    DETECTED_OS := $(shell uname)
    PYTHON_SETUP := python3
    PYTHON_BIN := .env/bin
endif

# Detect actual git branch
ACTUAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)


.PHONY: update-setup clean-env rebase-origin
update-setup: ## - [Setup the local development environment with python3 venv and project dependencies]
	@echo "Detected OS: $(DETECTED_OS)"
	@echo "Current Git Branch: $(ACTUAL_BRANCH)"

	@echo "Fetching the latest changes from the remote repository..."
	git fetch --all

	$(MAKE) rebase-origin

ifeq ($(DETECTED_OS), Linux)
	sudo apt-get update
	sudo apt-get install -y libpq-dev python3-dev python3-venv openjdk-8-jre
endif
	apt install python3-poetry
	( \
		. $(PYTHON_BIN)/activate; \
		python -m ensurepip; \
		python -m pip install --upgrade pip; \
		pip install poetry; \
		poetry install --no-root; \
	)

clean-env: ## - [Remove the existing Python virtual environment]
	@echo "Removing existing virtual environment..."
	@if [ -d ".env" ]; then rm -rf .env; fi

rebase-origin: ## - [Rebase with origin/main if not on main branch]
	@if [ "$(ACTUAL_BRANCH)" != "main" ]; then \
		echo "Rebasing $(ACTUAL_BRANCH) with origin/main..."; \
		git rebase origin/main; \
	else \
		echo "Already on main branch, no rebase needed."; \
	fi

