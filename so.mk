SO := $(notdir $(PKG))

build-default: dir fmt
	@$(CC) build --ldflags "$(LDFLAGS)" -o "$(OUT)/$(SO).a" $(TRIM)

debug-default: dir fmt
	@$(CC) build --gcflags all="-l -N" -o "$(OUT)/$(SO).a" $(TRIM)
