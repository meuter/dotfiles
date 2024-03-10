function install_package() {
    local version=1.17.1
    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    local checksum=479e406e882e875280d85f4d68294278

    curl -L https://github.com/starship/starship/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    tar xvf /tmp/${tarball} -C ${DOTFILES_BIN}
    rm -fv /tmp/${tarball}
    ln -fs ${DOTFILES_ROOT}/starship/starship.toml ${DOTFILES_CONFIG}/
}

function uninstall_package() {
    rm -fv \
        ${DOTFILES_CONFIG}/starship.toml \
        ${DOTFILES_BIN}/starship
}

function init_package() {
    set +u
    eval "$(starship init bash)"
}

function uninit_package() {
    unset PROMPT_COMMAND
    unset PS1
    unset PS2
    source ${HOME}/.bashrc
}

