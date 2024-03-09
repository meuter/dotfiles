#!/bin/false "This script should be sourced in a shell, not executed directly"

export DOTFILES_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export DOTFILES_PREFIX=${HOME}/.local
export DOTFILES_BIN=${DOTFILES_PREFIX}/bin
export DOTFILES_LIB=${DOTFILES_PREFIX}/lib
export DOTFILES_MAN=${DOTFILES_PREFIX}/man
export DOTFILES_SRC=${DOTFILES_PREFIX}/src
export DOTFILES_INCLUDE=${DOTFILES_PREFIX}/include
export DOTFILES_SHARE=${DOTFILES_PREFIX}/share
export DOTFILES_INSTALLED=${DOTFILES_PREFIX}/etc/pkg/installed
export DOTFILES_CONFIG=${HOME}/.config

function info() {
    local white_on_green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    printf "${white_on_green}-- %-57s${normal}\n" "${1}"
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
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
        return 0
    fi

    local to_install=${1}
    pushd . &> /dev/null
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        to_install="$(dependencies) ${to_install}"
    popd &> /dev/null


    for package in ${to_install}; do
        if ! is_installed ${package}; then
            info "Installing ${package}..."
            pushd . &> /dev/null
                cd ${DOTFILES_ROOT}/${package}/
                source package.sh
                install_package
                init_package
                ln -fv -s ${DOTFILES_ROOT}/${package}/ ${DOTFILES_INSTALLED}/
            popd &> /dev/null
        fi
    done
    info "All Done!"
}

function uninstall() {
    if ! is_installed ${1}; then
        return 0
    fi
    info "Uninstalling ${1}..."
    pushd . &> /dev/null
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        uninstall_package
        rm -vf ${DOTFILES_INSTALLED}/${1}
    popd &> /dev/null
    info "All Done!"
}

function bootstrap() {
    mkdir -p \
        ${DOTFILES_BIN}\
        ${DOTFILES_SRC}\
        ${DOTFILES_SHARE}\
        ${DOTFILES_INSTALLED}\
        ${DOTFILES_CONFIG}

    export PATH=${DOTFILES_BIN}:${PATH}
    export LD_LIBRARY_PATH=${DOTFILES_LIB}

    for installed_package in $(find -L ${DOTFILES_INSTALLED} -name package.sh); do
        source ${installed_package}
        init_package
    done
}

bootstrap

