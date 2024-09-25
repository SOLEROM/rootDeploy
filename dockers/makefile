###################################################################################
################################  params  #########################################
###################################################################################
TAR_FILE=my_docker_env.tar
TAR_PATH := $(shell pwd)
IMAGE_NAME=my_docker_image:latest
CONTAINER_NAME=my_docker_container

###################################################################################
#############################  docker file build ##################################
###################################################################################
define DOCKERFILE_CONTENT
# Use a base image
FROM ubuntu:20.04

# Install basic dependencies (modify as needed)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    vim \
    python3 \
    python3-pip \
    sudo \
    docker.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up a user with no password sudo
RUN useradd -m user -s /bin/bash && \
    echo "user:user" | chpasswd && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user

# Ensure the shared directory exists
RUN mkdir -p /home/user/shared && \
    chown -R user:user /home/user/shared

# Copy and setup the save_changes script
COPY save_changes.sh /usr/local/bin/save_changes
RUN chmod +x /usr/local/bin/save_changes

USER user
WORKDIR /home/user

# Set the default shell to bash
CMD ["/bin/bash"]
endef
export DOCKERFILE_CONTENT

###################################################################################
############################# save docker script ##################################
###################################################################################
define SAVE_CHANGES_SCRIPT
#!/bin/bash
# This script commits the container and saves it to a tar file.
# It is intended to be run from within the Docker container.
docker commit $$(hostname) $(IMAGE_NAME)
docker save -o $(TAR_FILE) $(IMAGE_NAME)
endef
export SAVE_CHANGES_SCRIPT

###################################################################################
###################################  help #########################################
###################################################################################
.PHONY: all build run run-gpu save clean help
help:
	@echo "Usage:"
	@echo "  make [target] [VOLUME_PATH=]"
	@echo ""
	@echo "Targets:"
	@echo "  help     - Display this help message (default target)."
	@echo "  build    - Build the Docker image and save it to a tar file."
	@echo "  run      - Run the Docker container with GUI support but no GPU. Optionally specify VOLUME_PATH."
	@echo "  run-gpu  - Run the Docker container with GUI and GPU support. Optionally specify VOLUME_PATH."
	@echo "  save     - Save changes made in the container back to the Docker image and tar file."
	@echo "  clean    - Clean up the Docker environment by removing the container, image, and tar file."

all: help

###################################################################################
###################################  build ########################################
###################################################################################
build: setup_scripts
	@echo "Building Docker image: $(IMAGE_NAME)"
	@echo "$$DOCKERFILE_CONTENT" | docker build -t $(IMAGE_NAME) -f- .
	@echo "Saving Docker image to tar file: $(TAR_FILE)"
	@docker save -o $(TAR_FILE) $(IMAGE_NAME)
	@rm save_changes.sh

setup_scripts:
	@echo "$$SAVE_CHANGES_SCRIPT" > save_changes.sh

###################################################################################
###################################  run ##########################################
###################################################################################
run:
	@echo "Running Docker container with GUI support: $(CONTAINER_NAME)"
	docker run --name $(CONTAINER_NAME) --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $(TAR_PATH):/save/ \
		-e DISPLAY=$(DISPLAY) \
		$(if $(VOLUME_PATH),-v $(VOLUME_PATH):/home/user/shared:rw) \
		$(IMAGE_NAME)

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
	@rm -f $(TAR_FILE)
	@echo "Cleanup complete."

