#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "sdkman"
}

function install_package() {
    sdk install gradle 7.5.1
}

function uninstall_package() {
    sdk uninstall gradle 7.5.1
}

function init_package() {
    echo -n
}

