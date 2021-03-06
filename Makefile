all: clean format golint

include Makefile.common

TARGET   ?= logstash_exporter
GOLINTER ?= $(GOPATH)/bin/golangci-lint

vendor:
	@echo ">> installing dependencies on vendor"
	@$(GO) mod vendor

test:
	@echo ">> running tests"
	@$(GO) test -short $(pkgs)

format:
	@echo ">> formatting code"
	@$(GO) fmt $(pkgs)

golint:
	@echo ">> linting code"
	@$(GOLINTER) run

build: promu vendor
	@echo ">> building binaries"
	GO111MODULE=$(GO111MODULE) $(PROMU) build --prefix $(PREFIX)

crossbuild: promu vendor
	@echo ">> cross-building binaries"
	@$(PROMU) crossbuild

tarball: promu vendor
	@echo ">> building release tarball"
	@$(PROMU) tarball --prefix $(PREFIX) $(BIN_DIR)

tarballs: promu vendor
	@echo ">> building release tarballs"
	@$(PROMU) crossbuild tarballs $(BIN_DIR)

clean:
	@echo ">> Cleaning up"
	@find . -type f -name '*~' -exec rm -fv {} \;
	@rm -fv $(TARGET)

.PHONY: all clean format golint build test
