#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

./deploy_basic16X.sh $newRoot
##add dev end
./stage_buildENV.sh $newRoot
