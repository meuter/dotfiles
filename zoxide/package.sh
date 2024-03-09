#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "rust"
}

function install_package() {
    cargo install zoxide
}

function uninstall_package() {
    cargo uninstall zoxide
}

function init_package() {
    eval "$(zoxide init --cmd cd bash)"
}
