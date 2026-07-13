## Update chart's Docs and Schemas

SPELL_CHECK_VERSION = 0.63.0

docs:
ifeq (, $(shell which helm-docs))
	$(error "Please, install https://github.com/norwoodj/helm-docs first")
endif
	helm-docs --skip-version-footer

SCHEMA-GEN := $(shell helm plugin ls | grep schema-gen 2>/dev/null)

schema:
ifndef SCHEMA-GEN
	$(error "Please, run: helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git first")
endif
	helm schema-gen charts/edb-postgres-for-kubernetes/values.yaml > charts/edb-postgres-for-kubernetes/values.schema.json
	helm schema-gen charts/edb-postgres-distributed-for-kubernetes/values.yaml > charts/edb-postgres-distributed-for-kubernetes/values.schema.json
	helm schema-gen charts/edb-cloudnativepg-global-cluster/values.yaml \
		> charts/edb-cloudnativepg-global-cluster/values.schema.json
	helm schema-gen charts/edb-postgres-for-kubernetes-lts-1-28/values.yaml \
		> charts/edb-postgres-for-kubernetes-lts-1-28/values.schema.json

spellcheck: ## Runs the spellcheck on the project.
	docker run --rm -v $(PWD):/tmp jonasbn/github-action-spellcheck:$(SPELL_CHECK_VERSION)
wordlist-ordered: ## Order the wordlist using sort
	LANG=C LC_ALL=C sort -u .wordlist-en-custom.txt > .wordlist-en-custom.txt.new && \
	mv -f .wordlist-en-custom.txt.new .wordlist-en-custom.txt
