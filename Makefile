DOCKER_BUILD_ARGS=\
	--build-arg USER_ID=$(shell id -u) \
	--build-arg USER_NAME=$(shell id -un) \
	--build-arg GROUP_ID=$(shell id -g) \
	--build-arg GROUP_NAME=$(shell id -gn) \

build: docker/Dockerfile
	docker build $(DOCKER_BUILD_ARGS) . -f$< -t dev

dev: build
	docker run -ti --rm dev || true
