installgarble-default:
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    mvdan.cc/garble@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif
