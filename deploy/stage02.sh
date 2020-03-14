#!/bin/bash
source ./common.sh

# help
function HELP_PRINT {
echo "==================================================="
echo "stage02.sh Help Menu:"
echo "Usage:"
echo "./stage02.sh  -h|-help|--help     	Show this menu"
echo "Run:"
echo "./stage02.sh  <newFolderPath for newRootfs> "
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

###  ubu1604
# enter script
sudo cp $ubu16add/enter $newRoot/enter
# apt sources
sudo cp $newRoot/etc/apt/sources.list  $newRoot/etc/apt/sources.list_ORIG
sudo cp $ubu16add/etc/apt/sources.list  $newRoot/etc/apt/sources.list
# local scripts
sudo cp -ar $ubu16add/local  $newRoot/

## first enter operations
# add users:
RUN_IN_CHROOT $newRoot "useradd -m -s /bin/bash user"
RUN_IN_CHROOT $newRoot "usermod -aG sudo user"
# set passwords:
RUN_IN_CHROOT $newRoot "echo root:root | chpasswd"
RUN_IN_CHROOT $newRoot "echo user:user | chpasswd"



## patches
PATCH $newRoot/etc/profile $ubu16add/pathces/patch01_etc_profile 
PATCH $newRoot/home/user/.bashrc $ubu16add/pathces/patch02_home_user_bashrc
PATCH $newRoot/root/.bashrc $ubu16add/pathces/patch02_root_bashrc
