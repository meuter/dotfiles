#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "sdkman"
}

function install_package() {
    sdk install kotlin 1.8.20
}

function uninstall_package() {
    sdk uninstall kotlin 1.8.20
}

function init_package() {
    echo -n
}
