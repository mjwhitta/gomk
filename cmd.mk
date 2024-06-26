ifeq ($(unameS),windows)
	ENVSETUP = set-item env:CC "$(CC)";
	ENVSETUP += set-item env:CGO_ENABLED "$(CGO_ENABLED)";
	ENVSETUP += set-item env:GOARCH "$(GOARCH)";
	ENVSETUP += set-item env:GOOS "$(GOOS)";
	ENVSETUP += set-item env:GOPATH "$(GOPATH)";
else
	ENVSETUP = CC="$(CC)"
	ENVSETUP += CGO_ENABLED="$(CGO_ENABLED)"
	ENVSETUP += GOARCH="$(GOARCH)"
	ENVSETUP += GOOS="$(GOOS)"
	ENVSETUP += GOPATH="$(GOPATH)"
endif

build-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell $(ENVSETUP) $(GO) build $(VCS) --ldflags="$(LDFLAGS)" -o "$(OUT)" $(TRIM) $c))

debug-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),$(shell $(ENVSETUP) $(GO) build --gcflags all="-l -N" -o "$(OUT)" $c))
