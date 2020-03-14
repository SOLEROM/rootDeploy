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

##fix:Gtk-Message: Failed to load module "canberra-gtk-module"
RUN_IN_CHROOT $newRoot "apt install libcanberra-gtk-module libcanberra-gtk3-module"
