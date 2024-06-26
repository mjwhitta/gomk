SO := $(notdir $(PKG))

build-default: dir fmt
	@$(GO) build $(VCS) --ldflags="$(LDFLAGS)" -o "$(OUT)/$(SO).a" $(TRIM)

debug-default: dir fmt
	@$(GO) build --gcflags all="-l -N" -o "$(OUT)/$(SO).a"
