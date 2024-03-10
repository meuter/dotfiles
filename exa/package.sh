function install_package() {
    # version info
    local version=0.10.1
    local zipfile=exa-linux-x86_64-musl-v${version}.zip
    local checksum=9d8dd5b43138737f5cedc4f16ee4d9fc

    # grab archive
    curl -L https://github.com/ogham/exa/releases/download/v${version}/${zipfile} --output /tmp/${zipfile}

    # check archive
    if [ "${checksum}" != $(md5sum /tmp/${zipfile} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract archive 
    mkdir -p /tmp/exa-${version}/
    unzip -o /tmp/${zipfile} -d /tmp/exa-${version}/

    # install content
    find /tmp/exa-${version} -name "exa" -type f -exec mv {} ${DOTFILES_BIN}/ \;
    find /tmp/exa-${version} -name "exa.bash" -type f -exec mv {} ${DOTFILES_COMPLETION}/ \;
    find /tmp/exa-${version} -name "exa.1" -type f -exec mv {} ${DOTFILES_MAN1} \;
    find /tmp/exa-${version} -name "exa_colors.5" -type f -exec mv {} ${DOTFILES_MAN5} \;

    # removing archive
    rm -fv /tmp/${zipfile}
    rm -rvf /tmp/exa-${version}/
}

function uninstall_package() {
    rm -fv \
        ${DOTFILES_BIN}/exa \
        ${DOTFILES_COMPLETION}/exa.bash \
        ${DOTFILES_MAN1}/exa.1 \
        ${DOTFILES_MAN5}/exa_colors.5
}

function init_package() {
    source ${DOTFILES_COMPLETION}/exa.bash
    alias ls=exa
}

function uninit_package() {
    unalias ls
}
