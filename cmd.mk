build-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell $(CC) build --ldflags "$(LDFLAGS)" -o "$(OUT)" $(TRIM) $c))

debug-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell $(CC) build --gcflags all="-l -N" -o "$(OUT)" $(TRIM) $c))
