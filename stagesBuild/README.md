# Deploy Scripts

* container deploy scripts

## basic build:
* [stage01](stage01.sh) - build clean init rootfs with debootstrap
* [stage02](stage02.sh) - add and patch basic common files to all rootfs
* [stage03](stage03.sh) - install basic common staff for all rootfs
* [stage04](stage04.sh) - git init the new roofFs for later compare when needed

## byPurpose Build
* [stage_xEnable](stage_xEnable.sh) - enable to run X gui staff in container

# Basic build logic:

## stage01

* stage01 build the basic rootfs with debootstrap

## stage02

* add the enter command to the rootfs:
  - enter mounts the pseudo folder
  - then chroot with su - xxx //xxx is the desired user
    - this calls the /etc/profile for all users which run /local/init
    - each user calls its .bashrc which loads the /local/bashrc
      - load aliases / colors/ PS1
  - on exit it umount folders;

* add users with passwords
* set default common patches

## stage03
* install basic common packages
