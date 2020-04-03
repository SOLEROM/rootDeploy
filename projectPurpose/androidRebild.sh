#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_ProjAndroid
source ../deploy/common.sh
##check inputs:
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

##=================================================================================##
##=================================================================================##
ECHO "Running androidENV :: install android build tools "
#deps:
RUN_IN_CHROOT $newRoot " apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python-mako"
RUN_IN_CHROOT $newRoot " apt-get install -y gettext"
RUN_IN_CHROOT $newRoot " apt-get install -y gcc-arm-linux-gnueabihf python-mako"
##java
RUN_IN_CHROOT $newRoot "apt-get install -y default-jre"
RUN_IN_CHROOT $newRoot "apt-get install -y default-jdk"
##add repo tool
RUN_IN_CHROOT $newRoot "curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo"
RUN_IN_CHROOT $newRoot "chmod +x /bin/repo"
##config git
RUN_IN_CHROOT $newRoot git config --global user.name "Your Name"
RUN_IN_CHROOT $newRoot git config --global user.email "you@example.com"
##tools:
RUN_IN_CHROOT $newRoot "apt-get install -y adb"
#cp buildInst
RUN_IN_CHROOT $newRoot "mkdir /andr/"
RUN cp androidBuild.log $newRoot/andr/
