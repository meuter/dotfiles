#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail

STOW_VERSION=2.3.1

function install_package() {
    local tarball=stow-${STOW_VERSION}.tar.gz
    curl -L http://ftp.gnu.org/gnu/stow/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    pushd .
        cd ${DOTFILES_SRC}/stow-${STOW_VERSION}/
        ./configure --prefix ~/.local/ && make install
        rm -rvf /tmp/${tarball} 
    popd
}

function uninstall_package() {
    pushd .
        cd ${DOTFILES_SRC}/stow-${STOW_VERSION}/
        make uninstall
	cd /tmp && rm -rvf ${DOTFILES_SRC}/stow-${STOW_VERSION}/
    popd
}

function init_package() {
    export PATH=${DOTFILES_BIN}:$PATH
    export PERL5LIB=${SHARE}/perl/
}
