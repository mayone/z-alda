#!/usr/bin/env bash
#
# Preflight: verify required tools are available before running setup.
# Exits via err() with a clear message when something is missing.

#######################################
# Verify required commands are available on PATH.
# Always-required: curl.
# Required only when java is missing: a package manager that can install it
# (brew on macOS, apt-get on Linux).
#######################################
preflight_check() {
  local missing=()

  check_cmd curl || missing+=("curl")

  if ! check_cmd java; then
    info "java not found; will install via package manager"
    if check_os "$OS_MAC" && ! check_cmd brew; then
      missing+=("brew (needed to install java on macOS)")
    elif check_os "$OS_LINUX" && ! check_cmd apt-get; then
      missing+=("apt-get (needed to install java on Linux)")
    elif check_os "$OS_WINDOWS"; then
      missing+=("java (please install Temurin/OpenJDK manually on Windows)")
    fi
  fi

  if [ ${#missing[@]} -gt 0 ]; then
    err "Missing required tool(s): ${missing[*]}"
  fi
  ok "Preflight check passed"
}
