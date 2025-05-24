# Makefile for building and running Jetson-compatible ONNX camera Docker image

# Configurable parameters (override with: make build DOCKERFILE=CustomDockerfile)
TAR_FILE ?= jetson_onnx_cam.tar
IMAGE_NAME ?= jetson-onnx-cam:latest
CONTAINER_NAME ?= jetson_onnx_cam
TAR_PATH := $(shell pwd)
DOCKERFILE ?= Dockerfile

.PHONY: all build connect stop save load clean fullclean help run_pc run_jetson

all: help

## Help target
help:
	@echo "Usage: make [target] [optional VAR=...]"
	@echo ""
	@echo "Targets:"
	@echo "  help       - Show this message."
	@echo "  build      - Build image ; > make DOCKERFILE=<XXX> "
	@echo "  run_pc        - Run container ; options:  GPU=1 VIDEO=1"
	@echo "  run_jetson    - Run on jetson"
	@echo "  connect    - Attach to running container shell."
	@echo "  stop       - Stop the running container."
	@echo "  save       - Commit container to image and export to tar."
	@echo "  load       - Load image from TAR_FILE."
	@echo "  clean      - Remove container and image."
	@echo "  fullclean  - clean + remove TAR_FILE."

## Build Docker image and save to tar
build:
	@if [ ! -f $(DOCKERFILE) ]; then \
		echo "Error: Dockerfile not found at path: $(DOCKERFILE)"; \
		exit 1; \
	fi
	@echo "Building Docker image: $(IMAGE_NAME) from $(DOCKERFILE)"
	@docker build -t $(IMAGE_NAME) -f $(DOCKERFILE) .
	@echo "Saving Docker image to tar: $(TAR_FILE)"
	@docker save -o $(TAR_FILE) $(IMAGE_NAME)

## Load image from tar
load:
	@if [ -f $(TAR_FILE) ]; then \
		echo "Loading image from: $(TAR_FILE)"; \
		docker load -i $(TAR_FILE); \
	else \
		echo "Error: $(TAR_FILE) not found"; \
		exit 1; \
	fi

run_pc:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		echo "Container already running. Connecting..."; \
		$(MAKE) connect; \
	else \
		echo "Starting container on PC: $(CONTAINER_NAME)"; \
		CMD="docker run --rm -it --name $(CONTAINER_NAME)"; \
		[ "$(GPU)" = "1" ] && CMD="$$CMD --gpus all"; \
		[ "$(VIDEO)" = "1" ] && CMD="$$CMD --device=/dev/video0"; \
		CMD="$$CMD -v $$(pwd):/app $(IMAGE_NAME) bash"; \
		echo "Running: $$CMD"; \
		sudo bash -c "$$CMD"; \
	fi

run_jetson:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		echo "Container already running. Connecting..."; \
		$(MAKE) connect; \
	else \
		echo "Starting container on Jetson: $(CONTAINER_NAME)"; \
		sudo docker run --rm -it --name $(CONTAINER_NAME) \
			--runtime=nvidia --gpus all \
			--device=/dev/video0 \
			-v $$(pwd):/app \
			$(IMAGE_NAME) bash; \
	fi


## Connect to running container
connect:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		docker exec -it $(CONTAINER_NAME) /bin/bash; \
	else \
		echo "Container $(CONTAINER_NAME) is not running."; \
	fi

## Stop container
stop:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		docker stop $(CONTAINER_NAME); \
	else \
		echo "Container $(CONTAINER_NAME) is not running."; \
	fi

## Save container state to image and tar
save:
	@echo "Committing container: $(CONTAINER_NAME) -> image: $(IMAGE_NAME)"
	@docker commit $(CONTAINER_NAME) $(IMAGE_NAME)
	@echo "Saving image to tar: $(TAR_FILE)"
	@docker save -o $(TAR_FILE) $(IMAGE_NAME)

## Cleanup container/image
clean:
	@docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@docker rmi $(IMAGE_NAME) 2>/dev/null || true
	@echo "Cleaned container and image."

## Cleanup + tar
fullclean: clean
	@rm -f $(TAR_FILE)
	@echo "Also removed tar file."
