#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "sdkman"
}

function install_package() {
    set +u
    sdk install java 17.0.10-amzn
}

function uninstall_package() {
    set +u
    sdk uninstall java 17.0.10-amzn
}

function init_package() {
    echo -n
}
