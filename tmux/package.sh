#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "clang libevent ncurses"
}

function install_package() {
    local version=3.3
    local dirname=tmux-${version}
    local tarball=${dirname}.tar.gz
    curl -L https://github.com/tmux/tmux/releases/download/${version}/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_SRC}/${dirname}
        PKG_CONFIG_PATH=${DOTFILES_LIB}/pkgconfig CC=clang ./configure --prefix=${DOTFILES_PREFIX}
        make -j && make install
    popd &> /dev/null

    mkdir -p ${DOTFILES_CONFIG}/tmux
    ln -fs ${DOTFILES_ROOT}/tmux/tmux.conf ${DOTFILES_CONFIG}/tmux/

    # install and bootstrap tpm
    export TMUX_PLUGIN_MANAGER_PATH=${DOTFILES_CONFIG}/tmux/plugins
    mkdir -p ${TMUX_PLUGIN_MANAGER_PATH}
    rm -rf ${TMUX_PLUGIN_MANAGER_PATH}/tpm
    git clone https://github.com/tmux-plugins/tpm ${TMUX_PLUGIN_MANAGER_PATH}/tpm
    tmux start-server
    tmux new-session -d
    ${TMUX_PLUGIN_MANAGER_PATH}/tpm/scripts/install_plugins.sh
    tmux kill-server
}

function uninstall_package() {
    # TODO
    echo -n
}

function init_package() {
    if which tmux >/dev/null 2>&1; then
        if [[ -z "${TMUX-}" ]]; then
            tmux new-session -A -s main
        fi
    fi
}
