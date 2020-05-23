#!/bin/bash
cd ../stagesBuild
helpFunc=HELP_PRINT_STAGE01
source common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET

##clean build log
rm ./lastLog

#deploy basic ubu:
##build clean init rootfs with debootstrap
./stage01.sh -r $newRoot -v $ubuVer 
##add and patch basic common files to all rootfs
./stage02.sh -r $newRoot -v $ubuVer
##install basic common staff for all rootfs
./stage03.sh -r $newRoot -v $ubuVer
##add newer python
./stage_newerPython.sh -r $newRoot -v $ubuVer
