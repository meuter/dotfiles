function install_package() {
    # version info
    local version=14.1.0
    local tarball=ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=ed206f245868d3df58d37599a811bf54

    # grab tarball
    curl -L https://github.com/BurntSushi/ripgrep/releases/download/${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball
    tar xvf /tmp/${tarball} -C /tmp

    # install binary
    find /tmp/${tarball%.tar.gz} -name "rg" -type f -exec mv {} ${DOTFILES_BIN}/ \;

    # install bash completion
    mkdir -p ${DOTFILES_SHARE}/rg/completion/
    find /tmp/${tarball%.tar.gz} -name "rg.bash" -type f -exec mv {} ${DOTFILES_SHARE}/rg/completion/ \;

    # install manpage
    mkdir -p ${DOTFILES_MAN}/man1/
    find /tmp/${tarball%.tar.gz} -name "rg.1" -type f -exec mv {} ${DOTFILES_MAN}/man1/ \;

    # cleanup tarball and extracted archive
    rm -v /tmp/${tarball}
    rm -rv /tmp/${tarball%.tar.gz}


}

function uninstall_package() {
    echo -n
}

function init_package() {
    source ${DOTFILES_SHARE}/rg/completion/rg.bash
}
