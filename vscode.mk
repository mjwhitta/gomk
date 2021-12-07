installvscode-default:
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/go-delve/delve/cmd/dlv@latest
	@cp -f $(GOPATH)/bin/dlv $(GOPATH)/bin/dlv-dap
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/ramya-rao-a/go-outline@latest
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    golang.org/x/tools/gopls@latest
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    honnef.co/go/tools/cmd/staticcheck@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

staticcheck-default:
	@staticcheck ./...

# Run the same tools as VSCode
vslint-default: fmt staticcheck
