#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_ProjRPI

## build dep
../deploy/deploy_basic_x_dev.sh
../stagesBuild/stage_newerPython.sh

##=================================================================================##
##=================================================================================##
ECHO "Running rpiZero build env "
#deps:
RUN_IN_CHROOT $newRoot " apt-get install -y gettext"
#project
RUN_IN_CHROOT $newRoot "mkdir -p /rpi/zero"
## get rpi os: https://www.raspberrypi.org/software/operating-systems/
RUN_IN_CHROOT $newRoot "cd /rpi/zero && wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip"
RUN_IN_CHROOT $newRoot "cd /rpi/zero && wget https://downloads.raspberrypi.org/raspios_full_armhf/images/raspios_full_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-full.zip"
## rebuild form src to customize : https://github.com/asb/spindle
## qemu : https://github.com/dhruvvyas90/qemu-rpi-kernel
## docker: https://github.com/lukechilds/dockerpi

## burn img tool : https://www.balena.io/etcher/
wget https://github.com/balena-io/etcher/releases/download/v1.5.120/balena-etcher-electron-1.5.120-linux-x64.zip?d_id=990bf989-ccd9-480a-b30e-1e11e4921b5aR
## or use dd:
##  sudo dd bs=1m if=./2020-02-13-raspbian-buster-lite.img of=/dev/diskX


