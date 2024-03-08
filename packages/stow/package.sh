#!/bin/false "This script should be sourced in a shell, not executed directly"

STOW_VERSION=2.3.1

function dependencies() {
    echo ""
}

function install_package() {
    local tarball=stow-${STOW_VERSION}.tar.gz
    curl -L http://ftp.gnu.org/gnu/stow/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    pushd . &> /dev/null
        cd ${DOTFILES_SRC}/stow-${STOW_VERSION}/
        ./configure --prefix ~/.local/ && make install
        rm -rvf /tmp/${tarball} 
    popd &> /dev/null
}

function uninstall_package() {
    pushd . &> /dev/null
        cd ${DOTFILES_SRC}/stow-${STOW_VERSION}/
        make uninstall
	cd /tmp && rm -rvf ${DOTFILES_SRC}/stow-${STOW_VERSION}/
    popd &> /dev/null
}

function init_package() {
    export PERL5LIB=${SHARE}/perl/
}
