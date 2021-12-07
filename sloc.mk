installsloc-default:
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/bytbox/sloc/sloc@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

sloc-default:
	@sloc .
