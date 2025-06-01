function install_package() {
    local version=0.11.2
    local tarball=nvim-linux-x86_64.tar.gz
    local checksum=c800a7f591da60c4dc492a17381051af

    curl --fail -L https://github.com/neovim/neovim/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    tar xvf /tmp/${tarball} --strip-components=1 -C ${DOTFILES_PREFIX}
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    rm -rvf \
        ${DOTFILES_SHARE}/nvim/ \
        ${DOTFILES_BIN}/nvim \
        ${DOTFILES_LIB}/nvim \
        ${DOTFILES_MAN}/man1/nvim.1
    rm -vf \
        $(find ${DOTFILES_SHARE} -name "*nvim*")
    unalias vim
}

function init_package() {
    alias vim=nvim
    export EDITOR=nvim
}

function uninit_package() {
    unalias vim
    unset EDITOR
}
