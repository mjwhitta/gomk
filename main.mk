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
GOPATH := $(firstword $(subst :, ,$(shell go env GOPATH)))
LDFLAGS := -s -w
OUT := $(BUILD)/$(GOOS)/$(GOARCH)
PKG := $(shell go list -m)
SRCDEPS := $(patsubst v%,,$(shell go list -m all))
ifeq ($(unameS),Windows)
    VERS := $(subst ",,$(lastword $(shell findstr /R "const +Version" *.go)))
else
    VERS := $(subst ",,$(lastword $(shell grep -Es "const +Version" *.go)))
endif

all: build;

%: %-default;

ifeq ($(wildcard cmd/*),)
    include gomk/so.mk
else
    include gomk/cmd.mk
endif
include gomk/reportcard.mk
include gomk/sloc.mk
include gomk/vscode.mk

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

dir-default:
ifeq ($(unameS),Windows)
ifeq ($(wildcard $(OUT)),)
	@powershell -c "New-Item -ItemType Directory \"$(OUT)\" | Out-Null"
endif
else
	@mkdir -p "$(OUT)"
endif

fmt-default:
	@go fmt ./...

gen-default:
	@go generate ./...

push-default:
	@git tag "v$(VERS)"
	@git push
	@git push --tags

superclean-default: clean;

test-default:
	@go clean --testcache
	@go test ./...

updatedeps-default:
	$(foreach d,$(SRCDEPS),$(shell go get --ldflags="$(LDFLAGS)" --trimpath -u -v $d))
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

yank-default:
	@git tag -d "v$(VERS)"
	@git push -d origin "v$(VERS)"
