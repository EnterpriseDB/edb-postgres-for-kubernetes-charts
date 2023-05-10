## Update chart's Docs and Schemas

docs:
ifeq (, $(shell which helm-docs))
	$(error "Please, install https://github.com/norwoodj/helm-docs first")
endif
	helm-docs

SCHEMA-GEN := $(shell helm plugin ls | grep schema-gen 2>/dev/null)

schema:
ifndef SCHEMA-GEN
	$(error "Please, run: helm plugin install https://github.com/karuppiah7890/helm-schema-gen.git first")
endif
	helm schema-gen charts/edb-postgres-for-kubernetes/values.yaml > charts/edb-postgres-for-kubernetes/values.schema.json
	helm schema-gen charts/edb-postgres-distributed-for-kubernetes/values.yaml > charts/edb-postgres-distributed-for-kubernetes/values.schema.json
