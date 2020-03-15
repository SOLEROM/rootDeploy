#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_xEnable
source ./common.sh
##check inputs:
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

##=================================================================================##
##=================================================================================##
ubu16add=./ubu16Additions

RUN_IN_CHROOT $newRoot "add-apt-repository -y ppa:deadsnakes/ppa"
RUN_IN_CHROOT $newRoot "apt-get update"
RUN_IN_CHROOT $newRoot "apt-get install -y python3.6"
RUN_IN_CHROOT $newRoot "update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1"
RUN_IN_CHROOT $newRoot "update-alternatives --config python3"
RUN_IN_CHROOT $newRoot "python3 --version"
RUN_IN_CHROOT $newRoot "ln -s /usr/bin/python3.6 /usr/bin/python"
