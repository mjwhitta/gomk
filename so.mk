SO := $(notdir $(PKG))

build-default: reportcard dir
	@go build --ldflags "$(LDFLAGS)" -o "$(OUT)/$(SO).a" --trimpath

debug-default: reportcard dir
	@go build --gcflags all="-l -N" -o "$(OUT)/$(SO).a" --trimpath
