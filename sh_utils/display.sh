#!/bin/sh
#
# Display message.

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
  printf "\r${CLEAR}  [ ${BLUE}..${NC} ] $1\n"
}

ok() {
  printf "\r${CLEAR}  [ ${GREEN}OK${NC} ] $1\n"
}

warn() {
  printf "\r${CLEAR}  [ ${YELLOW}!!${NC} ] $1\n"
}

err() {
  printf "\r${CLEAR}  [ ${RED}ERR${NC} ] $1\n"
  exit
}