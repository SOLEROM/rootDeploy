#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET


##run host deps install
./hostDeps.sh

##=================================================================================##
##=================================================================================##
ECHO "Running stage01.sh :: debootstrap "
##make sure to have the targer folder
RUN mkdir -p $newRoot
if [ "$ubuVer" -eq 16 ]; then
RUN sudo debootstrap --arch=amd64 xenial $newRoot http://archive.ubuntu.com/ubuntu/
fi
if [ "$ubuVer" -eq 18 ]; then
RUN sudo debootstrap --arch=amd64 bionic $newRoot http://archive.ubuntu.com/ubuntu/
fi
