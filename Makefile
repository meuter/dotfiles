DISTRO   ?= ubuntu/20.04


DOCKER_BUILD_TAG = \
	$(shell id -un)/dotfiles/$(DISTRO)

DOCKER_BUILD_ARGS = \
	--build-arg USER_ID=$(shell id -u) \
	--build-arg USER_NAME=$(shell id -un) \
	--build-arg GROUP_ID=$(shell id -g) \
	--build-arg GROUP_NAME=$(shell id -gn) \
	--progress plain \
	-t $(DOCKER_BUILD_TAG)

DOCKER_RUN_ARGS = \
	-h dotfiles \
	-ti --rm \
	$(DOCKER_BUILD_TAG)

build: docker/$(DISTRO)/Dockerfile
	docker build . $(DOCKER_BUILD_ARGS) -f $<

run:
	docker run $(DOCKER_RUN_ARGS) || true
