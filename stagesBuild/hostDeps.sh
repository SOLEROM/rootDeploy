#!/bin/bash
source ./common.sh
ECHO "Running hostDeps.sh :: install deps on host"
RUN  sudo apt-get install -y debootstrap
