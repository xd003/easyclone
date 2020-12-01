#!/usr/bin/env bash
#=============================================================
# https://github.com/xd003/clone
# File Name: setup.sh
# Author: xd003
# Description: Installing prerequisites for clone script
# System Required: Any Linux based distribution
#=============================================================

version=v0.4.1
arch="$(uname -m)"

if [ "$arch" == "arm64" ] || [ "$arch" == "aarch64" ] ; then
  arch=arm64
elif [ "$arch" == "x86_64" ] ; then
  arch=amd64
fi

dl=https://github.com/mawaya/rclone/releases/download/fclone-$version/fclone-$version-linux-$arch.zip
