##########################################################################################
####################################### USAGE  ###########################################
# docker build -t buildroot .
# docker run --dns 8.8.8.8 -it --name buildroot_container buildroot
# docker exec -it buildroot_container /bin/bash
##########################################################################################


# Use an official Ubuntu as a base image
FROM ubuntu:20.04
#FROM ubuntu:18.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Buildroot
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc gcc-multilib \
    g++ \
    bzip2 \
    cpio \
    unzip \
    rsync \
    file \
    wget \
    git \
    bc \
    make \
    python3 python3-distutils \
    python3-pip \
    libncurses5-dev \
    libssl-dev \
    libelf-dev \
    gettext \
    gawk \
    flex \
    texinfo \
    ncurses-dev \
    kmod \
    u-boot-tools \
    xz-utils \
    ccache \
    vim \
    sudo \
    python \
    subversion \ 
    iputils-ping \
    automake autoconf libtool \
    qemu-system-arm \ 
    qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

##    python-is-python3 \

# Create the sudoers directory if it doesn't exist
RUN mkdir -p /etc/sudoers.d

# network
RUN echo "Acquire::ForceIPv4 \"true\";" > /etc/apt/apt.conf.d/99force-ipv4

# Set up a user (optional) to avoid running as root inside the container
ARG USERNAME=user
RUN useradd -m ${USERNAME} && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}

# Switch to the non-root user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# buildroot
#RUN git clone git://git.buildroot.net/buildroot
RUN git clone https://gitlab.com/buildroot.org/buildroot.git
# make list-defconfigs
# make qemu_arm_versatile_defconfig
# make menuconfig ; make -j 8 ; 
# cd  ~/buildroot/output/images ;  ./start-qemu.sh


## openwrt
RUN git clone https://github.com/Gateworks/openwrt 
## git checkout XX
# ./scripts/feeds update -a
# ./scripts/feeds install -a
# make menuconfig  	// change arch
# make -j8
# tar xf bin/targets/imx/cortexa7/openwrt-imx-cortexa7-default-rootfs.tar.gz -C bin/targets/imx/cortexa7/untar/
# sudo chroot bin/targets/imx/cortexa7/untar/ /bin/sh


WORKDIR /home/${USERNAME}

# Set up an entrypoint to start a bash session in the container
CMD ["/bin/bash"]

