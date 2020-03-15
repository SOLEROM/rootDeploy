#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

#deploy basic ubu16_x86:
##build clean init rootfs with debootstrap
./stage01.sh $newRoot
##add and patch basic common files to all rootfs
./stage02.sh $newRoot
##install basic common staff for all rootfs
./stage03.sh $newRoot
##add X staff
./stage_xEnable.sh $newRoot
##add dev end
./stage_buildENV.sh $newRoot
