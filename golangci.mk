define GOLANGCI-LINT
	@echo "Linting GOOS=$(GOOS)"
	@golangci-lint run
endef

golangci-fmt-default:
ifeq ($(wildcard .golangci.yml),)
ifeq ($(unameS),windows)
	@powershell -c copy-item gomk/golangci.yml .golangci.yml
else
	@cp gomk/golangci.yml .golangci.yml
endif
endif
	@golangci-lint fmt

golangci-darwin-default: GOOS := darwin
golangci-darwin-default: golangci-fmt
	$(GOLANGCI-LINT)

golangci-default: golangci-darwin golangci-linux golangci-windows;

golangci-linux-default: GOOS := linux
golangci-linux-default: golangci-fmt
	$(GOLANGCI-LINT)

golangci-windows-default: GOOS := windows
golangci-windows-default: golangci-fmt
	$(GOLANGCI-LINT)

installgolangci-default:
	@go install --buildvcs=false --ldflags="-s -w" --trimpath github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif
