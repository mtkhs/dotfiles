#!/bin/bash

source ./XX_common.bash

echo "Install dependencies"
case ${OSTYPE} in
  linux*)
    case $OS_NAME in
      Debian | Ubuntu | Raspbian )
        sudo apt update
        # Ubuntu 18.04
        # golang-go # direnv
        # libncurses5-dev # tig
        # libncurses5-dev libevent-dev # tmux
        sudo apt install -y software-properties-common cargo rustc language-pack-en \
        build-essential autoconf golang-go libncurses5-dev libevent-dev \
        zlib1g-dev libffi-dev libbz2-dev libreadline-dev unzip libssl-dev libsqlite3-dev \
        bison # for tmux build
        ;;
      CentOS )
        ;;
    esac
    ;;
  darwin*)
    echo "Hello, darwin!"
    ;;
  *)
    echo "Unexpected system! Nothing to do!"
    ;;
esac

