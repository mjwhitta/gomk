installvscode-default:
	@go install --buildvcs=false --ldflags="-s -w" --trimpath github.com/go-delve/delve/cmd/dlv@latest
ifeq ($(unameS),windows)
	@powershell -c copy-item -force $(GOPATH)/bin/dlv $(GOPATH)/bin/dlv-dap
else
	@cp -f $(GOPATH)/bin/dlv $(GOPATH)/bin/dlv-dap
endif
	@go install --buildvcs=false --ldflags="-s -w" --trimpath github.com/ramya-rao-a/go-outline@latest
	@go install --buildvcs=false --ldflags="-s -w" --trimpath github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
	@go install --buildvcs=false --ldflags="-s -w" --trimpath golang.org/x/tools/gopls@latest
	@go install --buildvcs=false --ldflags="-s -w" --trimpath honnef.co/go/tools/cmd/staticcheck@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

staticcheck-default:
	@staticcheck ./...

# Run the same tools as VSCode
vslint-default: fmt staticcheck;
