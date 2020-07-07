#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_STAGE03
source ./common.sh
##check inputs:
CHECK_NEWROOT_SET
CHECK_VERSION_SET


##=================================================================================##
##=================================================================================##
ECHO "Running stage03.sh :: basic install "

RUN_IN_CHROOT $newRoot "apt-get update"
## basic tools
RUN_IN_CHROOT $newRoot "apt-get install -y vim wget curl bc"
## ubuntu basic
RUN_IN_CHROOT $newRoot "apt-get install -y software-properties-common"


echo "choose UTF-8 UTF-8"
RUN_IN_CHROOT $newRoot "apt-get install -y language-pack-en-base"
RUN_IN_CHROOT $newRoot "apt-get install -y locales"
RUN_IN_CHROOT $newRoot "locale-gen en_US.UTF-8"
RUN_IN_CHROOT $newRoot "update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en"


RUN_IN_CHROOT $newRoot "apt-get install -y  git"
RUN_IN_CHROOT $newRoot "HOME=/home/user  git config --global user.name user"
RUN_IN_CHROOT $newRoot "HOME=/home/user  git config --global user.email user@user.com"

RUN_IN_CHROOT $newRoot "mkdir /proj"
