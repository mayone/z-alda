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

# Platform detection (override via ALDA_OS / ALDA_ARCH in .env if needed).
: "${ALDA_OS:=$(detect_os)}"
: "${ALDA_ARCH:=$(detect_arch)}"

# Windows uses a different CDN layout and .exe-suffixed binaries.
if [ "$ALDA_OS" = "windows" ]; then
  ALDA="${ALDA}.exe"
  ALDA_PLAYER="${ALDA_PLAYER}.exe"
  ALDA_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/client/windows-amd64/${ALDA}"
  ALDA_PLAYER_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/player/windows/${ALDA_PLAYER}"
else
  ALDA_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/client/${ALDA_OS}-${ALDA_ARCH}/${ALDA}"
  ALDA_PLAYER_URL="${ALDA_RELEASES_URL}/${ALDA_BOOTSTRAP_VER}/player/non-windows/${ALDA_PLAYER}"
fi

main() {
  preflight_check
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
  else
    err "Please install Java (Temurin/OpenJDK) manually, then re-run setup."
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
    download_file "${ALDA_URL}" "${ALDA_HOME}/${ALDA}"
  fi

  if ! check_exist "${ALDA_HOME}/${ALDA_PLAYER}"; then
    info "Download alda-player"
    download_file "${ALDA_PLAYER_URL}" "${ALDA_HOME}/${ALDA_PLAYER}"
  fi

  # chmod is a no-op for .exe binaries on Windows filesystems.
  if [ "$ALDA_OS" != "windows" ]; then
    chmod +x "${ALDA_HOME}/${ALDA}"
    chmod +x "${ALDA_HOME}/${ALDA_PLAYER}"
  fi

  "${ALDA_HOME}/${ALDA}" update
}

main "$@"