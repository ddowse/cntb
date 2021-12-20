JAVAOPT = '-Dio.swagger.parser.util.RemoteUrl.trustAll=true -Dio.swagger.v3.parser.util.RemoteUrl.trustAll=true'
ifndef OUTPUTLOCATION
	OUTPUTLOCATION = ${PWD}/openapi/
endif
ifndef OPENAPIURL
	OPENAPIURL = https://api.contabo.com/api-v1.yaml
endif

ifndef OPENAPIVOLUME
	OPENAPIVOLUME = "$(CURDIR):/local"
endif
.PHONY: build
build: generate-api-clients build-only unittest

.PHONY: generate-api-clients
generate-api-clients:
	npm install @openapitools/openapi-generator-cli
	export JAVA_OPTS=$(JAVAOPT)
	${PWD}/node_modules/.bin/openapi-generator-cli version-manager set 5.2.1
	${PWD}/node_modules/.bin/openapi-generator-cli generate \
	--skip-validate-spec \
	--input-spec $(OPENAPIURL) \
	--generator-name  go \
	--output $(OUTPUTLOCATION)

.PHONY: build-only
build-only:
	go mod tidy
	go mod download
	export VERSION=$$(git rev-list --tags --max-count=1 | xargs -I {} git describe --tags {}); 
	export COMMIT=$$(git rev-parse HEAD); 
	export TIMESTAMP=$$(date -u +"%Y-%m-%dT%H:%M:%SZ"); 
	go build -ldflags="-w -s -X \"contabo.com/cli/cntb/cmd.version=$$VERSION\" -X \"contabo.com/cli/cntb/cmd.commit=$$COMMIT\" -X \"contabo.com/cli/cntb/cmd.date=$$TIMESTAMP\""

.PHONY: unittest
unittest:
	go test ./...

.PHONY: bats
bats: build bats-only

.PHONY: bats-only
bats-only:
	rm -f ~/.cache/cntb/token
	bats -rt --timing  bats/*.bats

.PHONY: install
install: bats
	go install

.PHONY: release
release: build
	go install github.com/mitchellh/gox@latest
	mkdir -p dist/
	rm -rf dist/*
	export VERSION=$$(git rev-list --tags --max-count=1 | xargs -I {} git describe --tags {}); export COMMIT=$$(git rev-parse HEAD); export TIMESTAMP=$$(date -u +"%Y-%m-%dT%H:%M:%SZ"); $$HOME/go/bin/gox -osarch="freebsd/amd64" -ldflags="-w -s -X \"contabo.com/cli/cntb/cmd.version=$$VERSION\" -X \"contabo.com/cli/cntb/cmd.commit=$$COMMIT\" -X \"contabo.com/cli/cntb/cmd.date=$$TIMESTAMP\"" -output="dist/{{.OS}}_{{.Arch}}/{{.Dir}}"
