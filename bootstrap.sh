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

function __dotfiles_info() {
    local white_on_green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    printf "${white_on_green}-- %-57s${normal}\n" "${1}"
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    echo
}

function __dotfiles_error() {
    local white_on_red="\e[97m\e[101m"
    local normal="\e[0m"
    echo
    printf "${white_on_red}------------------------------------------------------------${normal}\n"
    printf "${white_on_red}-- %-57s${normal}\n" "${1}"
    printf "${white_on_red}------------------------------------------------------------${normal}\n"
    echo
}

function __dotfiles_install() {
    # resolve dependencies
    local pending_packages=$(echo "${@}" | xargs -n1 | awk '!a[$0]++' | xargs)
    for package in ${pending_packages}; do
        local package_script="${DOTFILES_ROOT}/${package}/package.sh"
        if [ ! -f "${package_script}" ]; then
            __dotfiles_error "Unknown Package: '${package}'"
            return 1
        fi
        local additional_package=$(set -eou pipefail && source ${package_script} && dependencies)
        pending_packages="${additional_package} ${pending_packages}"
    done
    local pending_packages=$(echo "${pending_packages}" | xargs -n1 | awk '!a[$0]++' | xargs)

    # check what needs to be installed
    local packages_to_install=""
    for package in ${pending_packages}; do
        local package_script="${DOTFILES_INSTALLED}/${package}/package.sh"
        if [ ! -f "${package_script}" ]; then
            packages_to_install="${packages_to_install} ${package}"
        fi
    done

    # perform installation
    for package in ${packages_to_install}; do
        __dotfiles_info "Installing '${package}'..."
        local package_script="${DOTFILES_ROOT}/${package}/package.sh"
        (set -eou pipefail && source ${package_script} && set -x && install_package)
        if [ "$?" -ne 0 ]; then
            __dotfiles_error "Could not install '${package}'"
            return 1
        fi
        (set -eou pipefail && source ${package_script} && set -x init_package)
        if [ "$?" -ne 0 ]; then
            __dotfiles_error "Could initialize '${package}'"
            return 1
        fi
        source ${package_script}
        init_package
	ln -fv -s ${DOTFILES_ROOT}/${package}/ ${DOTFILES_INSTALLED}/
    done

    __dotfiles_info "All Done!"
}

function __dotfiles_uninstall_in_subprocess() {
    if ! dotfiles_is_installed ${1}; then
        return 0
    fi
    __dotfiles_info "Uninstalling ${1}..."
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
            __dotfiles_error "ERROR: ${package}"
            cat ${output}
            return 1
        fi
        rm -f ${output}
    done
    __dotfiles_info "All Good!"
}

###################################################################################################
## Public Functions
###################################################################################################

function dotfiles {
    case ${1} in
        list)               __dotfiles_list;;
        list_installed)     __dotfiles_list_installed;;
        initrc)             __dotfiles_initrc;;
        check)              __dotfiles_check;;
        install)            __dotfiles_install "${@:2}"
    esac
}

###################################################################################################
## Bootstrap Packages
###################################################################################################

dotfiles_bootstrap

