# Use a base image
FROM common-base

# Install basic dependencies (modify as needed)
RUN sudo apt-get update && sudo apt-get install -y \
    vim \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*


# Copy project-specific files
# COPY project_files /home/user/project_files
# Set the work directory for the project
# WORKDIR /home/user/project_files