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

# Detect the current git branch
ACTUAL_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: setup clean-env rebase-origin
setup: ## - [Set up the local development environment with Python venv and project dependencies]
	@echo "Detected OS: $(DETECTED_OS)"
	@echo "Current Git Branch: $(ACTUAL_BRANCH)"

	# Check if the user is on Windows and recommend using WSL
ifeq ($(DETECTED_OS), Windows)
	@echo "========================================================================================"
	@echo "🚨 WARNING: Detected operating system is Windows."
	@echo "To set up the development environment, it is recommended to use a Linux environment."
	@echo "This can be done using WSL (Windows Subsystem for Linux)."
	@echo "Refer to the official documentation for installing WSL:"
	@echo "https://docs.microsoft.com/en-us/windows/wsl/install"
	@echo "========================================================================================"
	exit 1
endif

	@echo "Fetching the latest changes from the remote repository..."
	git fetch --all

	$(MAKE) rebase-origin
	# $(MAKE) clean-env

ifeq ($(DETECTED_OS), Linux)
	sudo apt-get update
	sudo apt-get install -y libpq-dev python3-dev python3-venv openjdk-8-jre
endif
	apt install -y pre-commit
	( \
		. $(PYTHON_BIN)/activate; \
		python -m ensurepip; \
		python -m pip install --upgrade pip; \
		poetry install --no-root; \
		python -m pip install pre-commit; \
	)
	pre-commit clean
	pre-commit install

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
