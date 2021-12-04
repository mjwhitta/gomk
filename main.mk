# Determine OS
ifeq ($(OS),Windows_NT)
	unameS := Windows
else
	unameS := $(shell uname -s)
endif

# Utility functions
find=$(foreach d,$(wildcard $(1:=/*)),$(call find,$d,$2) $(filter $(subst *,%,$2),$d))
uniq=$(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

# Set some variables
BUILD := build
GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)
LDFLAGS := -s -w
OUT := $(BUILD)/$(GOOS)/$(GOARCH)
PKG := $(shell go list -m)
SRC := $(call uniq,$(dir $(call find,.,*.go)))
SRCDEPS := $(patsubst v%,,$(shell go list -m all))
TST := $(call uniq,$(dir $(call find,.,*_test.go)))
ifeq ($(unameS),Windows)
    VERS := $(subst ",,$(lastword $(shell findstr /R "const +Version" *.go)))
else
    VERS := $(subst ",,$(lastword $(shell grep -Es "const +Version" *.go)))
endif

all: build

%: %-default;

ifeq ($(wildcard cmd/*),)
    include gomk/so.mk
else
    include gomk/cmd.mk
endif

clean-default: fmt
ifeq ($(unameS),Windows)
ifneq ($(wildcard $(BUILD)),)
	@powershell -c Remove-Item -Force -Recurse "$(BUILD)"
endif
else
	@rm -fr "$(BUILD)"
endif
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

clena-default: clean

cyclo-default:
	@gocyclo -over 15 $(SRC)

dir-default:
ifeq ($(unameS),Windows)
ifeq ($(wildcard $(OUT)),)
	@powershell -c "New-Item -ItemType Directory \"$(OUT)\" | Out-Null"
endif
else
	@mkdir -p "$(OUT)"
endif

fmt-default:
	@go fmt $(SRC)

gen-default:
ifneq ($(unameS),Windows)
	@go generate $(SRC)
endif

ineffassign-default:
	@ineffassign $(SRC)

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

installsloc-default:
	@go install --ldflags="$(LDFLAGS)" --trimpath \
	    github.com/bytbox/sloc/sloc@latest
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

license-default:
ifeq ($(wildcard LICENSE.txt),)
	@echo Missing license
endif

lint-default:
	@golint $(SRC)

push-default:
	@git tag "v$(VERS)"
	@git push
	@git push --tags

reportcard-default: fmt cyclo ineffassign license lint simplify vet

simplify-default:
	@gofmt $(LDFLAGS) $(SRC)

sloc-default:
	@sloc .

strip-default:
ifneq ($(unameS),Windows)
	@find "$(OUT)" -type f -exec ./gomk/tools/strip {} \;
endif

test-default:
	@go clean --testcache
ifneq ($(TST),)
	@go test -v $(TST)
endif

updatedeps-default:
	$(foreach d,$(SRCDEPS),$(shell go get --ldflags="$(LDFLAGS)" --trimpath -u -v $d))
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

vet-default:
	@go vet $(SRC)

yank-default:
	@git tag -d "v$(VERS)"
	@git push -d origin "v$(VERS)"
