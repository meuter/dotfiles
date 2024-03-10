function install_package() {
    local version=0.9.4
    local tarball=zoxide-${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=7ca4e6c5ceb98bd1d5d8efb8460b640e

    curl -L https://github.com/ajeetdsouza/zoxide/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p /tmp/zoxide-${version}
    tar xvf /tmp/${tarball} -C /tmp/zoxide-${version}

    mv -vf /tmp/zoxide-${version}/zoxide                    ${DOTFILES_BIN}/
    mv -vf /tmp/zoxide-${version}/completions/zoxide.bash   ${DOTFILES_COMPLETION}/
    mv -vf /tmp/zoxide-${version}/man/man1/*                ${DOTFILES_MAN1}/

    rm -v /tmp/${tarball}
    rm -rv /tmp/zoxide-${version}
}

function uninstall_package() {
    rm -vf \
        ${DOTFILES_BIN}/zoxide \
        ${DOTFILES_COMPLETION}/zoxide.bash \
        ${DOTFILES_MAN1}/zoxide*.1
}

function init_package() {
    source ${DOTFILES_COMPLETION}/zoxide.bash
    eval "$(zoxide init --cmd cd bash)"
}
