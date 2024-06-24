ifneq ($(unameS),windows)
DKR := -e DKR_GID=$(shell id -g) -e DKR_GNAME=$(shell id -gn)
DKR += -e DKR_UID=$(shell id -u) -e DKR_UNAME=$(shell id -nu)

libc_2.39: phony_dummy
	@go mod vendor
	@docker tag libc:2.39 libc:delete &>/dev/null || true
	@docker build -f gomk/docker/libc_2.39 --pull -t libc:2.39 . || docker tag libc:delete libc:2.39 &>/dev/null || true
	@docker buildx prune -f &>/dev/null || true
	@docker rmi libc:delete &>/dev/null || true
	@docker rmi ubuntu:20.04 &>/dev/null || true
	@docker run $(DKR) -i --rm -t -v "$(shell go env GOROOT)":/go:ro -v "$(shell pwd)":/pwd:Z -w /pwd libc:2.39
ifeq ($(unameS),windows)
	@remove-item -force -recurse vendor
else
	@rm -f -r vendor
endif

libc_2.38: phony_dummy
	@go mod vendor
	@docker tag libc:2.38 libc:delete &>/dev/null || true
	@docker build -f gomk/docker/libc_2.38 --pull -t libc:2.38 . || docker tag libc:delete libc:2.38 &>/dev/null || true
	@docker buildx prune -f &>/dev/null || true
	@docker rmi libc:delete &>/dev/null || true
	@docker rmi ubuntu:20.04 &>/dev/null || true
	@docker run $(DKR) -i --rm -t -v "$(shell go env GOROOT)":/go:ro -v "$(shell pwd)":/pwd:Z -w /pwd libc:2.38
ifeq ($(unameS),windows)
	@remove-item -force -recurse vendor
else
	@rm -f -r vendor
endif

libc_2.35: phony_dummy
	@go mod vendor
	@docker tag libc:2.35 libc:delete &>/dev/null || true
	@docker build -f gomk/docker/libc_2.35 --pull -t libc:2.35 . || docker tag libc:delete libc:2.35 &>/dev/null || true
	@docker buildx prune -f &>/dev/null || true
	@docker rmi libc:delete &>/dev/null || true
	@docker rmi ubuntu:20.04 &>/dev/null || true
	@docker run $(DKR) -i --rm -t -v "$(shell go env GOROOT)":/go:ro -v "$(shell pwd)":/pwd:Z -w /pwd libc:2.35
ifeq ($(unameS),windows)
	@remove-item -force -recurse vendor
else
	@rm -f -r vendor
endif

libc_2.31: phony_dummy
	@go mod vendor
	@docker tag libc:2.31 libc:delete &>/dev/null || true
	@docker build -f gomk/docker/libc_2.31 --pull -t libc:2.31 . || docker tag libc:delete libc:2.31 &>/dev/null || true
	@docker buildx prune -f &>/dev/null || true
	@docker rmi libc:delete &>/dev/null || true
	@docker rmi ubuntu:20.04 &>/dev/null || true
	@docker run $(DKR) -i --rm -t -v "$(shell go env GOROOT)":/go:ro -v "$(shell pwd)":/pwd:Z -w /pwd libc:2.31
ifeq ($(unameS),windows)
	@remove-item -force -recurse vendor
else
	@rm -f -r vendor
endif

.PHONY: phony_dummy
phony_dummy: ;
endif
