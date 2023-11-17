ifeq ($(unameS),windows)
	ENVSETUP := set-item env:GOARCH "$(GOARCH)";
	ENVSETUP += set-item env:GOOS "$(GOOS)";
	ENVSETUP += set-item env:GOPATH "$(GOPATH)";
else
	ENVSETUP := GOARCH="$(GOARCH)" GOOS="$(GOOS)" GOPATH="$(GOPATH)"
endif

build-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell $(ENVSETUP) $(CC) build $(VCS) --ldflags="$(LDFLAGS)" -o "$(OUT)" $(TRIM) $c))

debug-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell $(ENVSETUP) $(CC) build --gcflags all="-l -N" -o "$(OUT)" $c))
