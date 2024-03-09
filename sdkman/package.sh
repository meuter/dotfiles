#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local script="/tmp/sdkman_bootstrap.sh"
    curl -L https://get.sdkman.io/ --output ${script}
    chmod u+x ${script}
    SDKMAN_DIR=~/.local/sdkman SDKMAN_DIR_RAW=$SDKMAN_DIR ${script}
}

function uninstall_package() {
    # TODO
    echo ""
}

function init_package() {
    export SDKMAN_DIR=~/.local/sdkman
    export SDKMAN_DIR_RAW=~/.local/sdkman
    source ~/.local/sdkman/bin/sdkman-init.sh
}
