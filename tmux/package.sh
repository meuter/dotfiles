function dependencies() {
    echo "clang libevent ncurses"
}

function install_package() {
    local version=3.3
    local dirname=tmux-${version}
    local tarball=${dirname}.tar.gz
    local checksum=6366f02cbad6a3d03de532aa8583ea22

    curl -L https://github.com/tmux/tmux/releases/download/${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/

    cd ${DOTFILES_SRC}/${dirname}
    PKG_CONFIG_PATH=${DOTFILES_LIB}/pkgconfig CC=clang ./configure --prefix=${DOTFILES_PREFIX}
    make -j && make install

    mkdir -p ${DOTFILES_CONFIG}/tmux
    ln -fs ${DOTFILES_ROOT}/tmux/tmux.conf ${DOTFILES_CONFIG}/tmux/

    export TMUX_PLUGIN_MANAGER_PATH=${DOTFILES_CONFIG}/tmux/plugins
    mkdir -p ${TMUX_PLUGIN_MANAGER_PATH}
    rm -rf ${TMUX_PLUGIN_MANAGER_PATH}/tpm
    git clone https://github.com/tmux-plugins/tpm ${TMUX_PLUGIN_MANAGER_PATH}/tpm
    tmux start-server
    tmux new-session -d
    ${TMUX_PLUGIN_MANAGER_PATH}/tpm/scripts/install_plugins.sh
    tmux kill-server

    rm -fv /tmp/${tarball}
}

function uninstall_package() {
    local version=3.3
    local dirname=tmux-${version}

    make -C ${DOTFILES_SRC}/${dirname} uninstall
    rm -rvf ${DOTFILES_SRC}/${dirname}
}

function init_package() {
    # prevent from launching tmux during the installation
    if [ "${1}" == "--installed" ]; then
        return 0
    fi

    # start when login to the terminal
    if [ -z "${TMUX-}" ]; then
        tmux new-session -A -s main
    fi
}
