#!/usr/bin/env bash
#
# Download utilities.

#######################################
# Download a URL to a destination path with retry.
# Fails (non-zero) on HTTP errors thanks to curl -f.
# Arguments:
#   $1 - source URL
#   $2 - destination file path
#######################################
download_file() {
  local url="$1"
  local dest="$2"
  curl -fL --retry 3 -o "$dest" "$url"
}
