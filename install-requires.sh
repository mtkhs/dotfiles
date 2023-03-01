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
        sudo apt update
        # Ubuntu 18.04
        # golang-go # direnv
        # libncurses5-dev # tig
        # libncurses5-dev libevent-dev # tmux
        sudo apt install -y software-properties-common cargo rustc \
        build-essential autoconf golang-go libncurses5-dev libevent-dev \
        zlib1g-dev libffi-dev libbz2-dev libreadline-dev libssl-dev libsqlite3-dev \
        exa
        ;;
      CentOS )
        ;;
    esac
    ;;
  darwin*)
    echo Hello, darwin!
    ;;
esac

<< COMMENTOUT
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
COMMENTOUT

