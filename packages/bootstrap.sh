#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail

export DOTFILES_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export DOTFILES_PREFIX=${HOME}/.local
export DOTFILES_BIN=${DOTFILES_PREFIX}/bin
export DOTFILES_SRC=${DOTFILES_PREFIX}/src
export DOTFILES_SHARE=${DOTFILES_PREFIX}/share
export DOTFILES_INSTALLED=${DOTFILES_PREFIX}/etc/pkg/installed

function info() {
    local green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${green}INFO${normal} ${1}"
    echo
}

function is_installed() {
    local install_dir=${DOTFILES_INSTALLED}/${1}
    if [ -d "${install_dir}" ]; then
       return 0 
    else
       return 1
    fi
}

function install() {
    if is_installed ${1}; then
        info "${1} is already installed"
        return 0
    fi

    info "Collecting dependencies for ${1}..."
    local to_install=${1}
    pushd .
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        to_install="$(dependencies) ${to_install}"
    popd

    echo ${to_install}

    for package in ${to_install}; do
        info "Installing ${package}..."
        pushd .
            cd ${DOTFILES_ROOT}/${package}/
            source package.sh
            install_package
            init_package
            ln -fv -s ${DOTFILES_ROOT}/${package}/ ${DOTFILES_INSTALLED}/
        popd
    done  
    info "All Done!"
}

function uninstall() {
    if ! is_installed ${1}; then
        info "${1} is not installed"
        return 0
    fi

    info "Uninstalling ${1}..."
    pushd .
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        uninstall_package
        rm -vf ${DOTFILES_INSTALLED}/${1}
    popd
    info "All Done!"
}

function bootstrap() {
    mkdir -pv ${DOTFILES_BIN} ${DOTFILES_SRC} ${DOTFILES_SHARE} ${DOTFILES_INSTALLED}
    for installed_package in $(find -L ${DOTFILES_INSTALLED} -name package.sh); do
    source ${installed_package}
    init_package
    done 
}

bootstrap

