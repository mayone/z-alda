set dotenv-load
alias s := setup
alias t := test
alias r := run

export PATH := env_var('PATH') + ":" + justfile_directory() / env_var_or_default('ALDA_HOME', './bin')

_default:
    @just --list

setup:
    @source ./setup.sh

test: setup
    alda version
    alda doctor
    alda --help
    alda play -c "(tempo! 160) trumpet: (quant 60) f12 b- > d f6 d12 f1"

run FILE: setup
    alda play --file {{FILE}}