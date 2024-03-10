function install_package() {
    # version info
    local version=0.9.4
    local tarball=zoxide-${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=7ca4e6c5ceb98bd1d5d8efb8460b640e

    # grab tarball
    curl -L https://github.com/ajeetdsouza/zoxide/releases/download/v${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball
    mkdir -p /tmp/zoxide-${version}
    tar xvf /tmp/${tarball} -C /tmp/zoxide-${version}

    # install binary
    mv -vf /tmp/zoxide-${version}/zoxide ${DOTFILES_BIN}/

    # install bash completion
    mkdir -p ${DOTFILES_SHARE}/zoxide/completion/
    mv -vf /tmp/zoxide-${version}/completions/zoxide.bash ${DOTFILES_SHARE}/zoxide/completion/

    # install manpage
    mkdir -p ${DOTFILES_MAN}/man1/
    mv -vf /tmp/zoxide-${version}/man/man1/* ${DOTFILES_MAN}/man1/

    # cleanup tarball and extracted archive
    rm -v /tmp/${tarball}
    rm -rv /tmp/zoxide-${version}
}

function uninstall_package() {
    rm -vf \
        ${DOTFILES_BIN}/zoxide \
        ${DOTFILES_SHARE}/zoxide/completion/zoxide.bash \
        ${DOTFILES_MAN}/man1/zoxide*.1
}

function init_package() {
    source ${DOTFILES_SHARE}/zoxide/completion/zoxide.bash
    eval "$(zoxide init --cmd cd bash)"
}
