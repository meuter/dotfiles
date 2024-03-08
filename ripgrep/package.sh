#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "rust"
}

function install_package() {
    cargo install ripgrep
}

function uninstall_package() {
    cargo uninstall ripgrep
}

function init_package() {
    echo -n
}
