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
ECHO "Running stage_buildENV :: install build tools "

RUN_IN_CHROOT $newRoot "apt install -y build-essential"
