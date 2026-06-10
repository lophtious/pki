UPSTREAM_URL := https://github.com/lophtious/pki.git
UPSTREAM_BRANCH := main
UPSTREAM_TAG := v1.0.0
EXCLUDED_FILE := attributes.toml

.PHONY: all fetch merge

all: merge

fetch:
	git fetch $(UPSTREAM_URL) tag $(UPSTREAM_TAG)

merge: fetch
	@echo "Merging $(UPSTREAM_TAG) from upstream, preserving $(EXCLUDED_FILE)..."
	git merge --no-commit --no-ff $(UPSTREAM_TAG)
	@echo "Restoring excluded file: $(EXCLUDED_FILE)"
	git checkout --ours -- "$(EXCLUDED_FILE)"
	git add "$(EXCLUDED_FILE)"
