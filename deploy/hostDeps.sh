#!/bin/bash
source ./common.sh
ECHO install deps on host
RUN  sudo apt-get install -y debootstrap
