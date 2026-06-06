UPSTREAM_URL := https://github.com/lophtious/pki.git
UPSTREAM_BRANCH := main
TAG := v1.0.0.0
EXCLUDED_FILE := attributes.toml

.PHONY: all setup fetch merge

all: merge

setup:
	@git remote get-url upstream >/dev/null 2>&1 || git remote add upstream $(UPSTREAM_URL)

fetch: setup
	git fetch upstream $(UPSTREAM_BRANCH)
	git fetch upstream tag $(TAG)

merge: fetch
	@echo "Merging $(TAG) from upstream..."
	-git merge $(TAG) --no-commit --no-ff
	@echo "Restoring local $(EXCLUDED_FILE)..."
	-git checkout HEAD -- $(EXCLUDED_FILE)
	-git add $(EXCLUDED_FILE)
	@echo "========================================================================"
	@echo "Merge staged! $(EXCLUDED_FILE) has been reverted to your local version."
	@echo "If 'git merge' reported any conflicts in other files, resolve them now."
	@echo "Once ready, complete the merge by running:"
	@echo "    git commit"
	@echo "========================================================================"
