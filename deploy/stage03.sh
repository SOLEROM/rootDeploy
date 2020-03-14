#!/bin/bash
source ./common.sh

# help
function HELP_PRINT {
echo "==================================================="
echo "stage03.sh Help Menu:"
echo "Usage:"
echo "./stage03.sh  -h|-help|--help             Show this menu"
echo "Run:"
echo "./stage03.sh  <newFolderPath for newRootfs> "
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

RUN_IN_CHROOT $newRoot "apt-get update"

echo "choose UTF-8 UTF-8"
RUN_IN_CHROOT $newRoot "apt-get install -y locales"
##RUN_IN_CHROOT $newRoot "dpkg-reconfigure locales" 	

RUN_IN_CHROOT $newRoot "apt-get install -y  git"


