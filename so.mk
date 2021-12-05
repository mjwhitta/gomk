SO := $(notdir $(PKG))

build-default: dir
	@go build --ldflags "$(LDFLAGS)" -o "$(OUT)/$(SO).a" --trimpath

debug-default: dir
	@go build --gcflags all="-l -N" -o "$(OUT)/$(SO).a" --trimpath
