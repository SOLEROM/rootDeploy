#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_xEnable
source ./common.sh
##check inputs:
CHECK_NEWROOT_SET
CHECK_VERSION_SET


##=================================================================================##
##=================================================================================##

if [ "$ubuVer" -eq 16 ]; then
ECHO "Running stage_newerPython :: install python 3.6 "
RUN_IN_CHROOT $newRoot "add-apt-repository -y ppa:deadsnakes/ppa"
RUN_IN_CHROOT $newRoot "apt-get update"
RUN_IN_CHROOT $newRoot "apt-get install -y python3.6"
RUN_IN_CHROOT $newRoot "update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1"
RUN_IN_CHROOT $newRoot "update-alternatives --config python3"
RUN_IN_CHROOT $newRoot "python3 --version"
RUN_IN_CHROOT $newRoot "ln -s /usr/bin/python3.6 /usr/bin/python"
fi

if [ "$ubuVer" -eq 18 ]; then
ECHO "ubu18 came with Python 3.6.9 ; no need to update yet"
fi
