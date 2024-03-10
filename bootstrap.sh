#!/bin/false "This script should be sourced in a shell, not executed directly"

###################################################################################################
## Environment Variables
###################################################################################################

export DOTFILES_ROOT=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
export DOTFILES_PREFIX=${HOME}/.local
export DOTFILES_BIN=${DOTFILES_PREFIX}/bin
export DOTFILES_LIB=${DOTFILES_PREFIX}/lib
export DOTFILES_MAN=${DOTFILES_PREFIX}/man
export DOTFILES_SRC=${DOTFILES_PREFIX}/src
export DOTFILES_MAN1=${DOTFILES_MAN}/man1
export DOTFILES_MAN5=${DOTFILES_MAN}/man5
export DOTFILES_INCLUDE=${DOTFILES_PREFIX}/include
export DOTFILES_SHARE=${DOTFILES_PREFIX}/share
export DOTFILES_COMPLETION=${DOTFILES_SHARE}/completion
export DOTFILES_INSTALLED=${DOTFILES_SHARE}/dotfiles
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

function __dotfiles_list {
    (cd ${DOTFILES_ROOT} && find . -maxdepth 2 -name package.sh | awk '{split($0,a,"/"); print a[2]}')
}

function __dotfiles_list_installed {
    (cd ${DOTFILES_INSTALLED} && find -L . -maxdepth 2 -name package.sh | awk '{split($0,a,"/"); print a[2]}')
}

function __dotfiles_check {
    local green="\e[32m"
    local red="\e[31m"
    local normal="\e[0m"

    for package in $(__dotfiles_list); do
        printf "%-30s" "checking '${package}'..."
        local package_script=${DOTFILES_ROOT}/${package}/package.sh
        local output=$(mktemp -t dotfiles.XXXXX)
        (set -eou pipefail && trap "__dotfiles_error ${package_script}:${LINENO}" ERR && source "${package_script}" &> ${output})
        if [ "$?" -ne 0 ]; then
            printf "${red}KO${normal}\n\n"
            cat ${output}
            rm -f ${output}
            return 1
        fi
        rm -f ${output}
        printf "${green}OK${normal}\n"
    done
    __dotfiles_info "All Good!"
}


function __dotfiles_install() {
    # resolve dependencies
    local pending_packages=$(echo "${@}" | xargs -n1 | awk '!a[$0]++' | xargs)
    for package in ${pending_packages}; do
        local package_script="${DOTFILES_ROOT}/${package}/package.sh"

        # verify package exists
        if [ ! -f "${package_script}" ]; then
            __dotfiles_error "Unknown Package: '${package}'"
            return 1
        fi

        # verify that dependencies function exists
        local exists=$( \
            set -eou pipefail;
            unset -f dependencies;
            source ${package_script};
            [[ $(type -t dependencies) == function ]] && echo "yes" || echo "no" \
        )

        if [ "${exists}" == "yes" ]; then
            # damn bash, why is it so hard to catch errors in subshells and capture output...
            local output=$(mktemp -t dotfiles.XXXXX)
            (set -eou pipefail && trap "__dotfiles_error ${package_script}:${LINENO}" ERR && source "${package_script}" && dependencies &> ${output})
            if [ "$?" -ne 0 ]; then
                cat ${output}
                rm -f ${output}
                __dotfiles_error "could not get dependencies"
                return 1
            fi
            local additional_package=$(cat ${output})
            rm -f ${output}
            pending_packages="${additional_package} ${pending_packages}"
        fi
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

        # verify if the package has an init function
        local exists=$( \
            set -eou pipefail;
            unset -f init_package;
            source ${package_script};
            [[ $(type -t init_package) == function ]] && echo "yes" || echo "no" \
        )

        # if so execute the function
        if [ "${exists}" == "yes" ]; then
            source ${package_script} && init_package --installed
            if [ "$?" -ne 0 ]; then
                __dotfiles_error "Could initialize '${package}'"
                return 1
            fi
        fi

        ln -fv -s ${DOTFILES_ROOT}/${package}/ ${DOTFILES_INSTALLED}/
    done
    return 0
}

function __dotfiles_uninstall() {
    local pending_packages=$(echo "${@}" | xargs -n1 | awk '!a[$0]++' | xargs)
    for package in ${pending_packages}; do
        __dotfiles_info "Uninstalling '${package}'..."
        local package_script="${DOTFILES_INSTALLED}/${package}/package.sh"
        if [ -f "${package_script}" ]; then
            (set -eou pipefail && source ${package_script} && set -x && uninstall_package)
            if [ "$?" -ne 0 ]; then
                __dotfiles_error "Could uninstall '${package}'"
                return 1
            fi

            # verify if the package has an uninit function
            local exists=$( \
                set -eou pipefail;
                unset -f uninit_package;
                source ${package_script};
                [[ $(type -t uninit_package) == function ]] && echo "yes" || echo "no" \
            )

            # if so execute the function
            if [ "${exists}" == "yes" ]; then
                source ${package_script} && uninit_package
                if [ "$?" -ne 0 ]; then
                    __dotfiles_error "Could uninitialize '${package}'"
                    return 1
                fi
            fi

            rm -vf ${DOTFILES_INSTALLED}/${1}
        fi
    done
    return 0
}

function __dotfiles_reinstall() {
    __dotfiles_uninstall "${@}"
    if [ "$?" -ne 0 ]; then return 1; fi;
    __dotfiles_install   "${@}"
}

function __dotfiles_init() {
    export PATH=${DOTFILES_BIN}:${PATH}
    export LD_LIBRARY_PATH=${DOTFILES_LIB}
    export MANPATH=${DOTFILES_MAN}:${MANPATH}

    for installed_package in $(find -L ${DOTFILES_INSTALLED} -maxdepth 2 -name package.sh); do
        source ${installed_package}
        init_package
    done
}

function __dotfiles_bootstrap() {
    mkdir -p \
        ${DOTFILES_BIN}\
        ${DOTFILES_SRC}\
        ${DOTFILES_SHARE}\
        ${DOTFILES_INSTALLED}\
	${DOTFILES_COMPLETION} \
	${DOTFILES_MAN1} \
	${DOTFILES_MAN5} \
        ${DOTFILES_CONFIG}
    __dotfiles_init
}


function __dotfiles_help {
    echo "Usage:"
    echo "    dotfiles <command>"
    echo
    echo "Available Commands:"
    echo "    list                  list available packages"
    echo "    list_installed        list installed packages"
    echo "    check                 check all packages"
    echo "    install               install packages"
    echo "    uninstall             uninstall packages"
    echo "    help                  print this help message"
    echo ""
    echo
    echo "Examples:"
    echo "    dotfiles install neovim tmux"
}

###################################################################################################
## Public Functions
###################################################################################################

function dotfiles {
    case ${1} in
        list)               __dotfiles_list;;
        list_installed)     __dotfiles_list_installed;;
        check)              __dotfiles_check;;
        install)            __dotfiles_install   "${@:2}";;
        uninstall)          __dotfiles_uninstall "${@:2}";;
        reinstall)          __dotfiles_reinstall "${@:2}";;
        *)                  __dotfiles_help;;
    esac

    case ${1} in
        install|uninstall|reinstall)
            if [ "$?" -eq 0 ]; then
                __dotfiles_info "All Done!"
                __dotfiles_init
            fi
            ;;
    esac
}

###################################################################################################
## Bootstrap Packages
###################################################################################################

__dotfiles_bootstrap

