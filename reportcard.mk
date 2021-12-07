SRC := $(call uniq,$(dir $(call find,.,*.go)))

cyclo-default:
	@gocyclo -over 15 $(SRC)

ineffassign-default:
	@ineffassign ./...

installreportcard-default:
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/fzipp/gocyclo/cmd/gocyclo@latest
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/gordonklaus/ineffassign@latest
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    golang.org/x/lint/golint@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

license-default:
ifeq ($(wildcard LICENSE.txt),)
	@echo Missing license
endif

lint-default:
	@golint ./...

# Run the same tools as goreportcard.com
reportcard-default: fmt cyclo ineffassign license lint simplify vet;

simplify-default:
	@gofmt $(LDFLAGS) $(SRC)

vet-default:
	@go vet ./...
