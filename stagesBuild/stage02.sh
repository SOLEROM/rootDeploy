#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_STAGE02
source ./common.sh
##check inputs:
CHECK_NEWROOT_SET
CHECK_VERSION_SET

##=================================================================================##
##=================================================================================##
ECHO "Running stage02.sh :: basic config "
# enter script
RUN sudo cp $ubuAdd/enter $newRoot/enter
# apt sources
RUN sudo cp $newRoot/etc/apt/sources.list  $newRoot/etc/apt/sources.list_ORIG
RUN sudo cp $ubuAdd/etc/apt/sources.list  $newRoot/etc/apt/sources.list
# local scripts
RUN sudo cp -ar $ubuAdd/local  $newRoot/

## first enter operations
# add users:
RUN_IN_CHROOT $newRoot "useradd -m -s /bin/bash user"
RUN_IN_CHROOT $newRoot "usermod -aG sudo user"
# set passwords:
RUN_IN_CHROOT $newRoot "echo root:root | chpasswd"
RUN_IN_CHROOT $newRoot "echo user:user | chpasswd"



## patches
## create pathces using: diff -Naur old new > patch.txt
PATCH $newRoot/etc/profile $ubuAdd/pathces/patch01_etc_profile
PATCH $newRoot/home/user/.bashrc $ubuAdd/pathces/patch02_home_user_bashrc
PATCH $newRoot/root/.bashrc $ubuAdd/pathces/patch02_root_bashrc
