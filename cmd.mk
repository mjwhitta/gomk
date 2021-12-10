build-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),@go build --ldflags "$(LDFLAGS)" -o "$(OUT)" --trimpath $c)

debug-default: dir fmt
	$(foreach c,$(wildcard ./cmd/*),@go build --gcflags all="-l -N" -o "$(OUT)" --trimpath $c)
