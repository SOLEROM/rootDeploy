#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
cd ../stagesBuild && source common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET

##clean build log
cd ../stagesBuild && rm ./lastLog

#deploy basic ubu:
##build clean init rootfs with debootstrap
cd ../stagesBuild && ./stage01.sh -r $newRoot -v $ubuVer 
##add and patch basic common files to all rootfs
cd ../stagesBuild && ./stage02.sh -r $newRoot -v $ubuVer
##install basic common staff for all rootfs
cd ../stagesBuild && ./stage03.sh -r $newRoot -v $ubuVer
##add newer python
cd ../stagesBuild && ./stage_newerPython.sh -r $newRoot -v $ubuVer
