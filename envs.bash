#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="${NAME}"
    OS_VERSION="${VERSION_ID}"
elif type lsb_release >/dev/null 2>&1; then
    OS_NAME=$(lsb_release -si)
    OS_VERSION=$(lsb_release -sr)
else
    OS_NAME="Unknown"
    OS_VERSION="Unknown"
fi

if [ -z $HOSTTYPE ]; then
    HOSTTYPE=$(uname -m)
fi
OS_ARCH=$(echo $HOSTTYPE | sed 's/x86_//;s/i[3-6]86/32/')

