#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_NEWROOT_SET   
CHECK_VERSION_SET

./deploy_basic_x.sh -r $newRoot -v $ubuVer
##add dev end
../stagesBuild/stage_buildENV.sh -r $newRoot -v $ubuVer
