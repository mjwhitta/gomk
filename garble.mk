installgarble-default:
	@go install --buildvcs=false --ldflags="-s -w" --trimpath \
	    mvdan.cc/garble@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif
