#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local version=0.24.0
    local tarball=bat-v${version}-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/sharkdp/bat/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        cd /tmp
        tar xvf /tmp/${tarball}
        find /tmp/${tarball%.tar.gz} -name "bat" -type f -exec mv {} ~/.local/bin/ \;
        rm -rf /tmp/${tarball}
    popd &> /dev/null

}

function uninstall_package() {
    echo -n
}

function init_package() {
    echo -n
}
