# Utility functions
find=$(foreach d,$(wildcard $(1:=/*)),$(call find,$d,$2) $(filter $(subst *,%,$2),$d))
lower = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
uniq=$(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

# Determine OS
ifeq ($(OS),Windows_NT)
    unameS := windows
else
    unameS := $(call lower,$(shell uname -s))
endif

# Helper variables
comma := ,
null :=
space := $(null) $(null)

# Set some variables
BUILD := build
CC := go
GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)
ifeq ($(unameS),windows)
    GOPATH := $(shell go env GOPATH)
else
    GOPATH := $(firstword $(subst :, ,$(shell go env GOPATH)))
endif
LDFLAGS := -s -w
OUT := $(BUILD)/$(GOOS)/$(GOARCH)
PKG := $(shell go list -m)
TRIM := --trimpath
VCS := --buildvcs=false
ifeq ($(unameS),windows)
    VERS := $(subst ",,$(lastword $(shell findstr /R "const +Version" *.go)))
else
    VERS := $(subst ",,$(lastword $(shell grep -E -s "const +Version" *.go)))
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
ifeq ($(unameS),windows)
ifneq ($(wildcard $(BUILD)),)
	@powershell -c Remove-Item -Force -Recurse "$(BUILD)"
endif
ifneq ($(wildcard cover.out),)
	@powershell -c Remove-Item -Force cover.out
endif
else
	@rm -f -r "$(BUILD)" cover.out
endif
ifeq ($(wildcard vendor),)
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif
endif

clena-default: clean;

cover-default: fmt
	@go clean --testcache
	@go test --coverprofile=cover.out ./...
	@go tool cover --func=cover.out

dir-default:
ifeq ($(unameS),windows)
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

gitlab-cover-default: clean
ifneq ($(unameS),windows)
	@useradd -m user
	@chown -R user:user .
	@go clean --testcache
	@su -c "go test --coverprofile=cover.out ./..." user
	@go tool cover --func=cover.out
endif

mr-default: fmt
	@make GOOS=darwin reportcard spellcheck vslint
	@make GOOS=linux reportcard spellcheck vslint
	@make GOOS=windows reportcard spellcheck vslint
	@make test

pr-default: mr;

push-default:
	@git tag "v$(VERS)"
	@git push
	@git push --tags

superclean-default: clean;

superclena-default: superclean;

test-default: fmt
	@go clean --testcache
	@go test ./...

updatedeps-default:
	@go get $(VCS) --ldflags="$(LDFLAGS)" $(TRIM) -u -v all
ifeq ($(wildcard vendor),)
ifneq ($(wildcard go.mod),)
	@go mod tidy
endif
endif

visualcover-default: cover
	@go tool cover --html=./cover.out

yank-default:
	@git tag -d "v$(VERS)" || true
	@git push -d origin "v$(VERS)"
