#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_xEnable
source ./common.sh
##check inputs:
CHECK_NEWROOT_SET
CHECK_VERSION_SET


##=================================================================================##
##=================================================================================##
ECHO "Running stage_xEN :: install x support tools "

##fix:Gtk-Message: Failed to load module "canberra-gtk-module"
RUN_IN_CHROOT $newRoot "apt install -y libcanberra-gtk-module libcanberra-gtk3-module"
