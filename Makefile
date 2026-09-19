.PHONY: analyze format clean tag tag-% push-tags run-dev run-prod push-dev-to-main-force

# Default rule
all: analyze format

# Run the example app in DEV flavor from the example/ directory
run-dev:
	$(MAKE) -C example run-dev

# Run the example app in PROD flavor from the example/ directory
run-prod:
	$(MAKE) -C example run-prod

# Run Dart analyzer across the project
analyze:
	@echo "Running dart analyze..."
	@dart analyze lib

# Format Dart code
format:
	@echo "Formatting Dart code..."
	@dart format lib

# Clean Flutter build cache
clean:
	@echo "Cleaning project..."
	@flutter clean

# Dynamic pattern rule: matches `make tag-1.0.0`, `make tag-1.0.1`, `make tag-2.0.0`, etc.
# Automatically creates git tag, pushes code & tag to GitHub, and creates GitHub Release via gh CLI.
tag-%:
	@VERSION="v$*"; \
	echo "Checking git status..."; \
	git status --porcelain | grep . && (echo "Error: Working directory dirty. Please commit or stash changes first." && exit 1) || true; \
	echo "Creating git tag $$VERSION..."; \
	git tag -a $$VERSION -m "Release $$VERSION" || exit 1; \
	echo "Pushing commits to origin main..."; \
	git push origin main; \
	echo "Pushing tag $$VERSION to origin..."; \
	git push origin $$VERSION; \
	echo "Creating GitHub Release for $$VERSION..."; \
	if command -v gh >/dev/null 2>&1; then \
		gh release create $$VERSION --title "$$VERSION" --notes "Release $$VERSION - Enterprise Multi-App Core Engine & Framework" || echo "GitHub release creation skipped or already exists."; \
	else \
		echo "Warning: GitHub CLI ('gh') not found. Tag pushed to GitHub, but GitHub Release was not automatically created."; \
	fi

# Generic tag target: usage `make tag TAG=v1.0.0 [MSG="Release v1.0.0"]`
tag:
	@if [ -z "$(TAG)" ]; then \
		echo "Error: TAG is required. Usage: make tag TAG=v1.0.0 [MSG=\"Release v1.0.0\"]"; \
		exit 1; \
	fi; \
	MSG_VAL="$(MSG)"; \
	if [ -z "$$MSG_VAL" ]; then MSG_VAL="Release $(TAG)"; fi; \
	echo "Creating git tag $(TAG)..."; \
	git tag -a $(TAG) -m "$$MSG_VAL"; \
	echo "Pushing commits and tag $(TAG) to origin..."; \
	git push origin main; \
	git push origin $(TAG); \
	if command -v gh >/dev/null 2>&1; then \
		gh release create $(TAG) --title "$(TAG)" --notes "$$MSG_VAL" || true; \
	fi

# Force push local dev branch to remote main branch
push-dev-to-main-force:
	@echo "Force-pushing local dev branch to remote main..."
	git push origin dev:main --force