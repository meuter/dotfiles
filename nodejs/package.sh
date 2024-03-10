#!/bin/false "This script should be sourced in a shell, not executed directly"

function install_package() {
    local version=20.11.0
    local tarball=node-v${version}-linux-x64.tar.gz
    curl -L https://nodejs.org/download/release/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ${DOTFILES_PREFIX}
        tar xvf /tmp/${tarball} --strip-components=1 --exclude="*/CHANGELOG.md" --exclude="*/README.md" --exclude="*/LICENSE"
        rm -rf /tmp/${tarball}
    popd
    npm config set prefix "${DOTFILES_PREFIX}"
}

function uninstall_package() {
    # TODO
    :;
}

function init_package() {
    :;
}
