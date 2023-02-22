build-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell GOARCH=$(GOARCH) GOOS=$(GOOS) GOPATH=$(GOPATH) $(CC) build --buildvcs=false --ldflags="$(LDFLAGS)" -o "$(OUT)" $(TRIM) $c))

debug-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell GOARCH=$(GOARCH) GOOS=$(GOOS) GOPATH=$(GOPATH) $(CC) build --gcflags all="-l -N" -o "$(OUT)" $(TRIM) $c))
