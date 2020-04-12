#!/bin/bash
helpFunc=HELP_PRINT_STAGE01
source ./common.sh
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

./deploy_basic16.sh $newRoot
##add X staff
./stage_xEnable.sh $newRoot
