#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "sdkman"
}

function install_package() {
    set +u
    sdk install kotlin 1.8.20
}

function uninstall_package() {
    set +u
    sdk uninstall kotlin 1.8.20
}

function init_package() {
    echo -n
}
