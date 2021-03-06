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
	@echo Missing LICENSE.txt
endif

lint-default:
	@golint ./...

readme-default:
ifeq ($(wildcard README.md),)
	@echo Missing README.md
endif

# Run the same tools as goreportcard.com
reportcard-default: fmt cyclo ineffassign license lint readme simplify vet;

simplify-default:
	@gofmt $(LDFLAGS) $(SRC)

vet-default:
	@go vet ./...
