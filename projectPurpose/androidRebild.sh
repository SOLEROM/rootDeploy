#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_ProjAndroid
source ../deploy/common.sh
##check inputs:
CHECK_INPUT_PARAMS_NUM_ONLY_ONE $#
newRoot=$1

##=================================================================================##
##=================================================================================##

#deps:
RUN_IN_CHROOT $newRoot " apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python-mako"
##java
RUN_IN_CHROOT $newRoot "apt-get install default-jre"
RUN_IN_CHROOT $newRoot "apt-get install default-jdk"
##add repo tool
RUN_IN_CHROOT $newRoot "curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo"
RUN_IN_CHROOT $newRoot "chmod +x /bin/repo"
##config git
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
#cp buildInst
RUN_IN_CHROOT $newRoot "mkdir /andr/"
cp androidBuild.log $newRoot/andr/


