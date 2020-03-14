#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
##check inputs:
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1


##=================================================================================##
##=================================================================================##
##make sure to have the targer folder
mkdir -p $newRoot
##ubu1604
sudo debootstrap --arch=amd64 xenial $newRoot http://archive.ubuntu.com/ubuntu/
