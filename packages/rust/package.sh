#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail

function dependencies() {
    echo ""
}

function install_package() {
    local script="/tmp/rust_bootstrap.sh"
    curl -L https://sh.rustup.rs --output ${script}
    chmod u+x ${script}
    CARGO_HOME=${DOTFILES_PREFIX}/cargo RUSTUP_HOME=${DOTFILES_PREFIX}/rustup ${script} -y
}

function uninstall_package() {
    rustup self uninstall -y
    rm -rvf ${DOTFILES_PREFIX}/cargo ${DOTFILES_PREFIX}/rustup
}

function init_package() {
    export CARGO_HOME=${DOTFILES_PREFIX}/cargo
    export RUSTUP_HOME=${DOTFILES_PREFIX}/rustup
    source ${CARGO_HOME}/env
}
