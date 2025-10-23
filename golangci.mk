golangci-default:
ifeq ($(wildcard .golangci.yml),)
	@cp gomk/golangci.yml .golangci.yml
endif
	@echo "Linting GOOS=$(GOOS)"
	@golangci-lint fmt
	@golangci-lint run

installgolangci-default:
	@go install --buildvcs=false --ldflags="-s -w" --trimpath github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif
