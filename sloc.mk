installsloc-default:
	@go install --buildvcs=false --ldflags="-s -w" --trimpath \
	    github.com/bytbox/sloc/sloc@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

sloc-default:
	@sloc .
