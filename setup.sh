#!/usr/bin/env bash
#
# Setup.
set -euo pipefail

# Bootstrap version used only for first install; `alda update` pulls latest afterwards.
readonly ALDA_BOOTSTRAP_VER="2.3.1"

# Use ${BASH_SOURCE[0]} if script is not executed by source, else use $0
SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"

source "$DIR_PATH/sh_utils/index.sh"

# Load environment variables (set -a auto-exports sourced vars)
ENV_FILE="$DIR_PATH/.env"
if check_exist "$ENV_FILE"; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

if check_os $OS_MAC; then
  ALDA_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/client/darwin-amd64/${ALDA}"
  ALDA_PLAYER_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/player/non-windows/${ALDA_PLAYER}"
elif check_os $OS_LINUX; then
  ALDA_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/client/linux-amd64/${ALDA}"
  ALDA_PLAYER_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/player/non-windows/${ALDA_PLAYER}"
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
  ABS_ALDA_HOME="$PWD/${ALDA_HOME}"
  if [[ "$PATH" != *":${ABS_ALDA_HOME}"* ]]; then
    export PATH="$PATH:${ABS_ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}"; then
    mkdir "${ALDA_HOME}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA}"; then
    info "Download alda"
    curl -fL --retry 3 -o "${ALDA_HOME}/${ALDA}" "${ALDA_URL}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA_PLAYER}"; then
    info "Download alda-player"
    curl -fL --retry 3 -o "${ALDA_HOME}/${ALDA_PLAYER}" "${ALDA_PLAYER_URL}"
  fi

  chmod +x "${ALDA_HOME}/"{"${ALDA}","${ALDA_PLAYER}"}

  "${ALDA_HOME}/${ALDA}" update
}

main "$@"