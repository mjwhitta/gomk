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
CC := go
GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)
GOPATH := $(firstword $(subst :, ,$(shell go env GOPATH)))
LDFLAGS := -s -w
OUT := $(BUILD)/$(GOOS)/$(GOARCH)
PKG := $(shell go list -m)
SRCDEPS := $(patsubst v%,,$(shell go list -m all))
TRIM := --trimpath
ifeq ($(unameS),Windows)
    VERS := $(subst ",,$(lastword $(shell findstr /R "const +Version" *.go)))
else
    VERS := $(subst ",,$(lastword $(shell grep -Es "const +Version" *.go)))
endif

ifneq ($(GARBLE),)
	CC := garble
	TRIM :=
endif

all: build;

%: %-default;

ifeq ($(wildcard cmd/*),)
    include gomk/so.mk
else
    include gomk/cmd.mk
endif
include gomk/garble.mk
include gomk/reportcard.mk
include gomk/sloc.mk
include gomk/vscode.mk

clean-default: fmt
ifeq ($(unameS),Windows)
ifneq ($(wildcard $(BUILD)),)
	@powershell -c Remove-Item -Force -Recurse "$(BUILD)"
endif
ifneq ($(wildcard cover.out),)
	@powershell -c Remove-Item -Force cover.out 
endif
else
	@rm -fr "$(BUILD)" cover.out
endif
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

cover-default: fmt
	@go clean --testcache
	@go test --coverprofile=cover.out ./...
	@go tool cover --func=cover.out

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

test-default: fmt
	@go clean --testcache
	@go test ./...

updatedeps-default:
	$(foreach d,$(SRCDEPS),$(shell go get --ldflags="$(LDFLAGS)" --trimpath -u -v $d))
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif

visualcover-default: cover
	@go tool cover --html=./cover.out

yank-default:
	@git tag -d "v$(VERS)"
	@git push -d origin "v$(VERS)"
