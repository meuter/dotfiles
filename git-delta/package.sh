#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "rust"
}

function install_package() {
    cargo install git-delta
}

function uninstall_package() {
    cargo uninstall git-delta
}

function init_package() {
    echo -n
}
