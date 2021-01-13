build-default: reportcard dir
	@go build --ldflags "$(LDFLAGS)" -o "$(OUT)" --trimpath ./cmd/*

debug-default: reportcard dir
	@go build --gcflags all="-l -N" -o "$(OUT)" --trimpath ./cmd/*

install-default: reportcard
	@mkdir -p "$(HOME)/.local/bin"
	@go build --ldflags "$(LDFLAGS)" -o "$(HOME)/.local/bin" \
	    --trimpath ./cmd/*

shrink-default: build
	@which upx >/dev/null 2>&1
	@find build -type f -exec upx {} \;

uninstall-default:
	@for cmd in $(shell ls cmd); do \
	    rm -f "$(HOME)/.local/bin/$$cmd"; \
	done
