#!/bin/bash

OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)

#echo $OSTYPE
#echo $OS
#echo $ARCH
#echo $VER

if builtin command -v fzy > /dev/null ; then
  echo "fzy is already installed."
else
  echo "Install fzy"
  case ${OSTYPE} in
    linux*)
      case $OS in
        Debian | Ubuntu )
          wget -P /tmp https://github.com/jhawthorn/fzy/releases/download/0.7/fzy_0.7-1_amd64.deb
          sudo dpkg -i /tmp/fzy_0.7-1_amd64.deb
          ;;
        CentOS )
          sudo yum install https://github.com/jhawthorn/fzy/releases/download/0.7/fzy-0.7-1.x86_64.rpm
      esac
      ;;
  esac
fi

