#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail

export DOTFILES_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export DOTFILES_PREFIX=${HOME}/.local
export DOTFILES_BIN=${DOTFILES_PREFIX}/bin
export DOTFILES_SRC=${DOTFILES_PREFIX}/src
export DOTFILES_SHARE=${DOTFILES_PREFIX}/share
export DOTFILES_INSTALLED=${DOTFILES_PREFIX}/etc/pkg/installed

function banner() {
    local green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${green}------------------------------------------------------------${normal}\n"
    printf "${green}-- %-57s${normal}\n" "${1}"
    printf "${green}------------------------------------------------------------${normal}\n"
    echo
}

function install() {
    banner "Installing ${1}..."
    pushd .
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        install_package
        init_package
	ln -fv -s ${DOTFILES_ROOT}/${1}/ ${DOTFILES_INSTALLED}/
    popd 
}

function uninstall() {
    banner "Uninstalling ${1}..."
    pushd .
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        uninstall_package
        rm -vf ${DOTFILES_INSTALLED}/${1}
    popd
}

function bootstrap() {
    mkdir -pv ${DOTFILES_BIN} ${DOTFILES_SRC} ${DOTFILES_SHARE} ${DOTFILES_INSTALLED}
    for installed_package in $(find -L ${DOTFILES_INSTALLED} -name package.sh); do
	source ${installed_package}
	init_package
    done 
}

bootstrap

