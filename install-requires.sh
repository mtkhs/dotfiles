#!/bin/bash

OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)

#echo $OSTYPE
#echo $OS
#echo $ARCH
#echo $VER

echo "Install dependencies"
case ${OSTYPE} in
  linux*)
    case $OS in
      Debian | Ubuntu | Raspbian )
        # Ubuntu 18.04
        sudo apt install -y zlib1g-dev libffi-dev libbz2-dev libreadline-dev libssl-dev libsqlite3-dev
        sudo apt install -y golang-go # direnv
        ;;
      CentOS )
    esac
    ;;
esac

if builtin command -v fzy > /dev/null ; then
  echo "fzy is already installed."
else
  echo "Install fzy"
  case ${OSTYPE} in
    linux*)
      case $OS in
        Debian | Ubuntu | Raspbian )
            wget -P /tmp https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-1.0.tar.gz
            tar xzvf /tmp/fzy-1.0.tar.gz -C /tmp
            cd /tmp/fzy-1.0
            make
            sudo make install
          ;;
        CentOS )
      esac
      ;;
  esac
fi

