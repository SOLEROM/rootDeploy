###################################################################################
################################  params  #########################################
###################################################################################
TAR_FILE=my_docker_env.tar
TAR_PATH := $(shell pwd)
IMAGE_NAME=my_docker_image:latest
CONTAINER_NAME=my_docker_container
DOCKERFILE_COMMON=Dockerfile.common
DOCKERFILE_PATH=./Dockerfile # Specify the path to your external Dockerfile

###################################################################################
############################# save docker script ##################################
###################################################################################
define SAVE_CHANGES_SCRIPT
#!/bin/bash
# This script commits the container and saves it to a tar file.
# It is intended to be run from within the Docker container.
docker commit $$(hostname) $(IMAGE_NAME)
docker save -o /save/$(TAR_FILE) $(IMAGE_NAME)
endef
export SAVE_CHANGES_SCRIPT

###################################################################################
###################################  help #########################################
###################################################################################
.PHONY: all build run run-gpu save clean help
help:
	@echo "Usage:"
	@echo "  make [target] [VOLUME_PATH=] [DOCKERFILE_PATH=]"
	@echo ""
	@echo "Targets:"
	@echo "  help       - Display this help message (default target)."
	@echo "  build      - Build the Docker image and save it to a tar file."
	@echo "  run        - Run the Docker container with GUI support but no GPU. Optionally specify VOLUME_PATH."
	@echo "  run-gpu    - Run the Docker container with GUI and GPU support. Optionally specify VOLUME_PATH."
	@echo "  save       - Save changes made in the container back to the Docker image and tar file."
	@echo "  load       - load Docker image."
	@echo "  clean      - Clean up the Docker environment by removing the container, image, and tar file."

all: help

###################################################################################
###################################  build ########################################
###################################################################################
build: setup_scripts
	@echo "Building Docker image: $(IMAGE_NAME) with Dockerfile: $(DOCKERFILE_PATH)"
	@docker build -t common-base -f $(DOCKERFILE_COMMON) .
	@docker build -t $(IMAGE_NAME) -f $(DOCKERFILE_PATH) .
	@echo "Saving Docker image to tar file: $(TAR_FILE)"
	@docker save -o $(TAR_FILE) $(IMAGE_NAME)
	@rm save_changes.sh


load:
	@echo "Loading Docker image from tar file: $(TAR_FILE)"
	@if [ -f $(TAR_FILE) ]; then \
		docker load -i $(TAR_FILE); \
		echo "Docker image $(IMAGE_NAME) loaded successfully."; \
	else \
		echo "Error: Tar file $(TAR_FILE) not found."; \
		exit 1; \
	fi


setup_scripts:
	@echo "$$SAVE_CHANGES_SCRIPT" > save_changes.sh

###################################################################################
###################################  run ##########################################
###################################################################################
connect:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		docker exec -it $(CONTAINER_NAME) /bin/bash; \
	else \
		echo "Container $(CONTAINER_NAME) is not running."; \
	fi

run:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		$(MAKE) connect; \
	else \
		echo "Running Docker container with GUI support: $(CONTAINER_NAME)"; \
		docker run --name $(CONTAINER_NAME) --rm -d \
			--user $(shell id -u):$(shell id -g) \
			-v /var/run/docker.sock:/var/run/docker.sock \
			-v /tmp/.X11-unix:/tmp/.X11-unix \
			-v $(TAR_PATH):/save/ \
			-e DISPLAY=$(DISPLAY) \
			$(if $(VOLUME_PATH),-v $(VOLUME_PATH):/home/user/shared:rw) \
			$(IMAGE_NAME) sleep infinity; \
		$(MAKE) connect; \
	fi

stop:
	@if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then \
		echo "Stopping Docker container: $(CONTAINER_NAME)"; \
		docker stop $(CONTAINER_NAME); \
		exit 0; \
	fi
	@echo "Container $(CONTAINER_NAME) is not running."




run-gpu:
	@echo "Running Docker container with GUI and GPU support: $(CONTAINER_NAME)"
	@docker run --name $(CONTAINER_NAME) --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=$(DISPLAY) \
		--gpus all \
		$(if $(VOLUME_PATH),-v $(VOLUME_PATH):/home/user/shared:rw) \
		$(IMAGE_NAME)

###################################################################################
###################################  save  ########################################
###################################################################################

save:
	@echo "Saving container changes to new image..."
	@docker commit $(CONTAINER_NAME) $(IMAGE_NAME)
	@echo "Saving new image to tar file: $(TAR_FILE)"
	@docker save -o $(TAR_FILE) $(IMAGE_NAME)
	@echo "Done."

###################################################################################
###################################  clean ########################################
###################################################################################
clean:
	@echo "Cleaning up Docker environment..."
	@docker rm -f $(CONTAINER_NAME) || true
	@docker rmi $(IMAGE_NAME) || true
	@echo "Basic clean complete."


fullclean: clean
	@echo "Removing the build tar..."
	@rm -f $(TAR_FILE)
	@echo "Full cleanup complete."
