#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail

REPO_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTALL_PREFIX=${HOME}/.local
BIN=${INSTALL_PREFIX}/bin
SRC=${INSTALL_PREFIX}/src
SHARE=${INSTALL_PREFIX}/share
PKG_INSTALLED=${INSTALL_PREFIX}/etc/pkg/installed

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
        cd ${REPO_ROOT}/${1}/
        source package.sh
        install_package
        init_package
	ln -fv -s ${REPO_ROOT}/${1}/ ${PKG_INSTALLED}/
    popd 
}

function uninstall() {
    banner "Uninstalling ${1}..."
    pushd .
        cd ${REPO_ROOT}/${1}/
        source package.sh
        uninstall_package
        rm -vf ${PKG_INSTALLED}/${1}
    popd
}

function bootstrap() {
    mkdir -pv ${BIN} ${SRC} ${SHARE} ${PKG_INSTALLED}
    for installed_package in $(find -L ${PKG_INSTALLED} -name package.sh); do
	source ${installed_package}
	init_package
    done 
}

bootstrap

