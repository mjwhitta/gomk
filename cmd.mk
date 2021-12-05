build-default: dir
	$(foreach c,$(wildcard ./cmd/*),$(shell go build --ldflags "$(LDFLAGS)" -o "$(OUT)" --trimpath $c))

debug-default: dir
	$(foreach c,$(wildcard ./cmd/*),$(shell go build --gcflags all="-l -N" -o "$(OUT)" --trimpath $c))
