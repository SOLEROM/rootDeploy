#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_STAGE03
source ./common.sh
##check inputs:
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

##=================================================================================##
##=================================================================================##
ubu16add=./ubu16Additions
ECHO "Running stage03.sh :: basic install "

RUN_IN_CHROOT $newRoot "apt-get update"
## basic tools
RUN_IN_CHROOT $newRoot "apt-get install -y vim wget curl"
## ubuntu basic
RUN_IN_CHROOT $newRoot "apt-get install -y software-properties-common"


echo "choose UTF-8 UTF-8"
RUN_IN_CHROOT $newRoot "apt-get install -y locales"
##RUN_IN_CHROOT $newRoot "dpkg-reconfigure locales"

RUN_IN_CHROOT $newRoot "apt-get install -y  git"
RUN_IN_CHROOT $newRoot 'git config --global user.name "user"'
RUN_IN_CHROOT $newRoot 'git config --global user.email "user@user.com"'
