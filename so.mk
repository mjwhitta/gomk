SO := $(notdir $(PKG))

build-default: dir fmt
	@go build --ldflags "$(LDFLAGS)" -o "$(OUT)/$(SO).a" --trimpath

debug-default: dir fmt
	@go build --gcflags all="-l -N" -o "$(OUT)/$(SO).a" --trimpath
