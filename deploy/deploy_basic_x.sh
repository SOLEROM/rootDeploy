#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
cd ../stagesBuild && source common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET

./deploy_basic.sh -r $newRoot -v $ubuVer
##add X staff
cd ../stagesBuild && ./stage_xEnable.sh -r $newRoot -v $ubuVer
