set dotenv-load
alias s := setup
alias t := test
alias r := run
alias u := update

alda_home := env_var_or_default('ALDA_HOME', './bin')
alda_bin := justfile_directory() / alda_home / 'alda'

export PATH := env_var('PATH') + ":" + justfile_directory() / alda_home

_default:
    @just --list

# Skip if alda is already installed; use setup-force to reinstall.
setup:
    @if [ -x "{{alda_bin}}" ]; then \
        echo "alda already installed (use 'just setup-force' to reinstall)"; \
    else \
        bash ./setup.sh; \
    fi

setup-force:
    @bash ./setup.sh

update:
    @alda update

soundfont:
    @bash ./scripts/install-soundfont.sh

test: setup
    alda version
    alda doctor
    alda --help
    alda play -c "(tempo! 160) trumpet: (quant 60) f12 b- > d f6 d12 f1"

run FILE: setup
    alda play --file {{FILE}}
