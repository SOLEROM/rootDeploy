#!/bin/bash
source ./common.sh

# help
function HELP_PRINT {
echo "==================================================="
echo "Help Menu:"
echo "stage_xEnable.sh will make the rootfs abale to run X Gui staff"
echo "Flags:"
echo "./stage_xEnable.sh -h|-help|--help             Show this menu"
echo "Usage:"
echo "./stage04.sh  <FolderPath for newRootfs> "
echo "==================================================="
exit 1
}

# check input
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
newRoot=$1
ubu16add=./ubu16Additions

##=================================================================================##
##=================================================================================##

##fix:Gtk-Message: Failed to load module "canberra-gtk-module"
RUN_IN_CHROOT $newRoot "apt install libcanberra-gtk-module libcanberra-gtk3-module"

