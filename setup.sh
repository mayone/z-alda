#!/bin/sh
#
# Update.

# Variables
ALDA_HOME="./bin"
ALDA="alda"
ALDA_PLAYER="alda-player"

export PATH="$PATH:${ALDA_HOME}"

main() {
  install_java
  download_alda
}

install_java() {
  # Install OpenJDK
  if ! check_cmd java; then
    info "Installing OpenJDK"
    brew install --cask adoptopenjdk
  fi
}

download_alda() {
  if ! check_exist "${ALDA_HOME}"; then
    mkdir "${ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA}"; then
    info "Downloading alda"
    wget https://alda-releases.nyc3.digitaloceanspaces.com/2.0.5/client/darwin-amd64/alda -P "${ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA_PLAYER}"; then
    info "Downloading alda-player"
    wget https://alda-releases.nyc3.digitaloceanspaces.com/2.0.5/player/non-windows/alda-player -P "${ALDA_HOME}"
  fi

  chmod +x "${ALDA_HOME}/"{"${ALDA}","${ALDA_PLAYER}"}

  "${ALDA_HOME}/${ALDA}" update
}

#
# Utils
#

# Colors
CLEAR='\033[2K'
NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

info() {
  printf "\r  [ ${BLUE}..${NC} ] $1\n"
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_exist() {
  command ls "$1" >/dev/null 2>&1
}

main "$@"