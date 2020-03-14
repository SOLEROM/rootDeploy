#!/bin/bash
source ./common.sh

# help
function HELP_PRINT {
echo "==================================================="
echo "stage04.sh Help Menu:"
echo "Usage:"
echo "./stage04.sh  -h|-help|--help             Show this menu"
echo "Run:"
echo "./stage04.sh  <newFolderPath for newRootfs> "
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

