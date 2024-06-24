installversioninfo-default:
	@go install --buildvcs=false --ldflags="-s -w" --trimpath \
	    github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

versioninfo-default: installversioninfo
ifeq ($(wildcard versioninfo.json),)
	@goversioninfo --example >versioninfo.json
endif
	@goversioninfo --platform-specific
