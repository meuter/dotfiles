#!/bin/false "This script should be sourced in a shell, not executed directly"

###################################################################################################
## Environment Variables
###################################################################################################

export DOTFILES_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export DOTFILES_PREFIX=${HOME}/.local
export DOTFILES_BIN=${DOTFILES_PREFIX}/bin
export DOTFILES_LIB=${DOTFILES_PREFIX}/lib
export DOTFILES_MAN=${DOTFILES_PREFIX}/man
export DOTFILES_SRC=${DOTFILES_PREFIX}/src
export DOTFILES_INCLUDE=${DOTFILES_PREFIX}/include
export DOTFILES_SHARE=${DOTFILES_PREFIX}/share
export DOTFILES_INSTALLED=${DOTFILES_PREFIX}/etc/dotfiles
export DOTFILES_CONFIG=${HOME}/.config

###################################################################################################
## Private Functions
###################################################################################################

function info() {
    local white_on_green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    printf "${white_on_green}-- %-57s${normal}\n" "${1}"
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    echo
}

function error() {
    local white_on_red="\e[97m\e[101m"
    local normal="\e[0m"
    echo
    printf "${white_on_red}------------------------------------------------------------${normal}\n"
    printf "${white_on_red}-- %-57s${normal}\n" "${1}"
    printf "${white_on_red}------------------------------------------------------------${normal}\n"
    echo
}

function __dotfiles_install_many_packages() {
    # resolve dependencies
    local pending_packages=$(echo "${@}" | xargs -n1 | awk '!a[$0]++' | xargs)
    for package in ${pending_packages}; do
        local package_script="${DOTFILES_ROOT}/${package}/package.sh"
        if [ ! -f "${package_script}" ]; then
            error "Unknown Package: '${package}'"
            return 1
        fi
    done
    echo ${pending_packages}
    return 0


    if dotfiles_is_installed ${1}; then
        return 0
    fi

    local to_install=${1}
    pushd . &> /dev/null
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        to_install="$(dependencies) ${to_install}"
    popd &> /dev/null

    for package in ${to_install}; do
        if ! dotfiles_is_installed ${package}; then
            info "Installing ${package}..."
            pushd . &> /dev/null
                cd ${DOTFILES_ROOT}/${package}/
                source package.sh
                set -x
                install_package
                init_package
                set +x
                ln -fv -s ${DOTFILES_ROOT}/${package}/ ${DOTFILES_INSTALLED}/
            popd &> /dev/null
        fi
    done
}

function __dotfiles_uninstall_in_subprocess() {
    if ! dotfiles_is_installed ${1}; then
        return 0
    fi
    info "Uninstalling ${1}..."
    pushd . &> /dev/null
        cd ${DOTFILES_ROOT}/${1}/
        source package.sh
        uninstall_package
        rm -vf ${DOTFILES_INSTALLED}/${1}
    popd &> /dev/null
}

function __dotfiles_create_folders() {
    mkdir -p \
        ${DOTFILES_BIN}\
        ${DOTFILES_SRC}\
        ${DOTFILES_SHARE}\
        ${DOTFILES_INSTALLED}\
        ${DOTFILES_CONFIG}
}

function __dotfiles_init() {
    export PATH=${DOTFILES_BIN}:${PATH}
    export LD_LIBRARY_PATH=${DOTFILES_LIB}

    for installed_package in $(find -L ${DOTFILES_INSTALLED} -maxdepth 2 -name package.sh); do
        source ${installed_package}
        init_package
    done
}


###################################################################################################
## Public Functions
###################################################################################################

function dotfiles_is_installed() {
    local install_dir=${DOTFILES_INSTALLED}/${1}
    if [ -d "${install_dir}" ]; then
       return 0
    else
       return 1
    fi
}

function dotfiles_install() {
    ( \
        set -eou pipefail && \
        __dotfiles_install_many_packages ${@} && \
        __dotfiles_init && \
        __dotfiles_create_folders \
    ) && \
        info "All Done!" || \
        error "Error"
}

function dotfiles_uninstall() {
    ( \
        set -eou pipefail && \
        __dotfiles_uninstall_in_subprocess ${1} && \
        __dotfiles_init && \
        __dotfiles_create_folders \
    ) && \
        info "All Done!" || \
        error "Error"
}

function dotfiles_bootstrap() {
    __dotfiles_create_folders
    __dotfiles_init
}


function __dotfiles_list_installed {
    (cd ${DOTFILES_INSTALLED} && find -L . -maxdepth 2 -name package.sh | awk '{split($0,a,"/"); print a[2]}')
}

function __dotfiles_list {
    (cd ${DOTFILES_ROOT} && find . -maxdepth 2 -name package.sh | awk '{split($0,a,"/"); print a[2]}')
}

function __dotfiles_test {
    echo "${@}"
}

function __dotfiles_initrc {
    export PATH=${DOTFILES_BIN}:${PATH}
    export LD_LIBRARY_PATH=${DOTFILES_LIB}

    for installed_package in $(find -L ${DOTFILES_INSTALLED} -maxdepth 2 -name package.sh); do
        source ${installed_package}
        init_package
    done
}

function __dotfiles_check {
    for package in $(find ${DOTFILES_ROOT} -maxdepth 2 -name package.sh); do
        local output=$(mktemp -t dotfiles.XXXXX)
        (set -eou pipefail; source "${package}" &> ${output})
        if [ "$?" -ne 0 ]; then
            error "ERROR: ${package}"
            cat ${output}
            return 1
        fi
        rm -f ${output}
    done
    info "All Good!"
}

function dotfiles {
    case ${1} in
        list)               __dotfiles_list;;
        list_installed)     __dotfiles_list_installed;;
        initrc)             __dotfiles_initrc;;
        check)              __dotfiles_check;;
    esac
}

###################################################################################################
## Bootstrap Packages
###################################################################################################

dotfiles_bootstrap

