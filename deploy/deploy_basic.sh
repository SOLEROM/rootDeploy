#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET

#deploy basic ubu:
##build clean init rootfs with debootstrap
../stagesBuild/stage01.sh -r $newRoot -v $ubuVer 
##add and patch basic common files to all rootfs
../stagesBuild/stage02.sh -r $newRoot -v $ubuVer
##install basic common staff for all rootfs
../stagesBuild/stage03.sh -r $newRoot -v $ubuVer


