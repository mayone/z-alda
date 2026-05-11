#!/usr/bin/env bash
#
# Install a FluidR3-style soundfont so Alda's MIDI playback sounds good.
# Java's bundled default is poor; pointing Java at a proper .sf2 is the
# recommended fix.
# See: https://github.com/alda-lang/alda/blob/master/doc/installing-a-good-soundfont.md
set -euo pipefail

SOURCE="${BASH_SOURCE[0]:-$0}"
DIR_PATH="$( cd -- "$( dirname -- "$SOURCE" )" >/dev/null 2>&1 && pwd -P )"
source "$DIR_PATH/../sh_utils/index.sh"

install_soundfont_mac() {
  check_cmd brew || err "brew not found; install Homebrew first"

  info "Installing fluid-synth (bundles a default soundfont)"
  brew install fluid-synth

  # Probe known locations for the bundled .sf2.
  local sf2_src=""
  for candidate in \
    "$(brew --prefix fluid-synth)/share/soundfonts/default.sf2" \
    "$(brew --prefix)/share/soundfonts/default.sf2" \
    "$(brew --prefix)/share/sounds/sf2/FluidR3_GM.sf2"; do
    if [ -f "$candidate" ]; then
      sf2_src="$candidate"
      break
    fi
  done
  [ -n "$sf2_src" ] || err "Could not locate the bundled .sf2 after install"

  local sf2_dest="$HOME/Library/Audio/Sounds/Banks/default.sf2"
  mkdir -p "$(dirname "$sf2_dest")"
  ln -sf "$sf2_src" "$sf2_dest"
  ok "Linked $sf2_src -> $sf2_dest"
}

install_soundfont_linux() {
  check_cmd apt-get || err "apt-get not found; Debian/Ubuntu only for now"

  info "Installing fluid-soundfont-gm"
  sudo apt-get install -y fluid-soundfont-gm

  local sf2_src="/usr/share/sounds/sf2/FluidR3_GM.sf2"
  [ -f "$sf2_src" ] || err "Expected $sf2_src after install but it is missing"

  local sf2_dest="$HOME/.gervill/soundbank-emg.sf2"
  mkdir -p "$(dirname "$sf2_dest")"
  ln -sf "$sf2_src" "$sf2_dest"
  ok "Linked $sf2_src -> $sf2_dest"
}

main() {
  local os
  os="$(detect_os)"
  case "$os" in
    darwin)  install_soundfont_mac ;;
    linux)   install_soundfont_linux ;;
    windows) err "Windows: please install manually per Alda's soundfont guide" ;;
  esac
}

main "$@"
