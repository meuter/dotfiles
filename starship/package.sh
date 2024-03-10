function install_package() {
    # version info
    local version=1.17.1
    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    local checksum=479e406e882e875280d85f4d68294278

    # grab tarball
    curl -L https://github.com/starship/starship/releases/download/v${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # install tarball
    tar xvf /tmp/${tarball} -C ${DOTFILES_BIN}

    # remove tarball
    rm -fv /tmp/${tarball}

    # install config
    ln -fs ${DOTFILES_ROOT}/starship/starship.toml ${DOTFILES_CONFIG}/
}

function uninstall_package() {
    # remove installed files
    rm -fv \
        ${DOTFILES_CONFIG}/starship.toml \
        ${DOTFILES_BIN}/starship
}

function init_package() {
    # set prompt
    set +u
    eval "$(starship init bash)"
}

function uninit_package() {
    # restore original prompt
    unset PROMPT_COMMAND
    unset PS1
    unset PS2
    source ${HOME}/.bashrc
}

