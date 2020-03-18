#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_STAGE02
source ./common.sh
##check inputs:
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1


##=================================================================================##
##=================================================================================##
ECHO "Running stage02.sh :: basic config "
###  ubu1604
ubu16add=./ubu16Additions
# enter script
RUN sudo cp $ubu16add/enter $newRoot/enter
# apt sources
RUN sudo cp $newRoot/etc/apt/sources.list  $newRoot/etc/apt/sources.list_ORIG
RUN sudo cp $ubu16add/etc/apt/sources.list  $newRoot/etc/apt/sources.list
# local scripts
RUN sudo cp -ar $ubu16add/local  $newRoot/

## first enter operations
# add users:
RUN_IN_CHROOT $newRoot "useradd -m -s /bin/bash user"
RUN_IN_CHROOT $newRoot "usermod -aG sudo user"
# set passwords:
RUN_IN_CHROOT $newRoot "echo root:root | chpasswd"
RUN_IN_CHROOT $newRoot "echo user:user | chpasswd"



## patches
PATCH $newRoot/etc/profile $ubu16add/pathces/patch01_etc_profile
PATCH $newRoot/home/user/.bashrc $ubu16add/pathces/patch02_home_user_bashrc
PATCH $newRoot/root/.bashrc $ubu16add/pathces/patch02_root_bashrc
