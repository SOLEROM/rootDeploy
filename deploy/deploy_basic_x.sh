#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET

./deploy_basic.sh -r $newRoot -v $ubuVer
##add X staff
../stagesBuild/stage_xEnable.sh -r $newRoot -v $ubuVer
