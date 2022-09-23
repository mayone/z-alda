#!/bin/bash
#
# Setup.

# Use ${BASH_SOURCE[0]} if script is not executed by source, else use $0
SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"

source $DIR_PATH/sh_utils/index.sh

# Variables
ENV=".env"
# Load environment variables
if check_exist $ENV; then
  export $(cat $ENV | xargs)
fi

if check_os $OS_MAC; then
  ALDA_URL="${ALDA_RELEASES_URL}/${ALDA_VER}/client/darwin-amd64/${ALDA}"
  ALDA_PLAYER_URL="${ALDA_RELEASES_URL}/${ALDA_VER}/player/non-windows/${ALDA_PLAYER}"
elif check_os $OS_LINUX; then
  ALDA_URL="${ALDA_RELEASES_URL}/${ALDA_VER}/client/linux-amd64/${ALDA}"
  ALDA_PLAYER_URL="${ALDA_RELEASES_URL}/${ALDA_VER}/player/non-windows/${ALDA_PLAYER}"
fi

main() {
  install_java
  download_alda
}

install_java() {
  if check_cmd java; then
    return
  fi

  info "Install OpenJDK"
  if check_os $OS_MAC; then
    brew install --cask temurin
  elif check_os $OS_LINUX; then
    sudo apt-get install default-jdk
  fi
}

download_alda() {
  if [[ "$PATH" != *":${ALDA_HOME}"* ]]; then
    export PATH="$PATH:${ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}"; then
    mkdir "${ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA}"; then
    info "Download alda"
    wget ${ALDA_URL} -P "${ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA_PLAYER}"; then
    info "Download alda-player"
    wget ${ALDA_PLAYER_URL} -P "${ALDA_HOME}"
  fi

  chmod +x "${ALDA_HOME}/"{"${ALDA}","${ALDA_PLAYER}"}

  "${ALDA_HOME}/${ALDA}" update
}

main "$@"