function install_package() {
    # version info
    local version=0.10.1
    local zipfile=exa-linux-x86_64-v${version}.zip
    local checksum=f0b321494944fee3d15a37b69f51a82f
    local manifest=${DOTFILES_SHARE}/exa/manifest.txt

    # grab archive
    curl -L https://github.com/ogham/exa/releases/download/v${version}/${zipfile} --output /tmp/${zipfile}

    # check archive
    if [ "${checksum}" != $(md5sum /tmp/${zipfile} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract archive and create manifest
    mkdir -p $(dirname ${manifest})
    unzip -o /tmp/${zipfile} -d ${DOTFILES_PREFIX} | tee ${manifest}
    sed -i "s#\s*inflating:\ ##" ${manifest}
    sed -i "/^Archive/d"         ${manifest}

    # removing archive
    rm -rf /tmp/${zipfile}
}

function uninstall_package() {
    local manifest=${DOTFILES_SHARE}/exa/manifest.txt

    # remove installed files
    set +x
    for file in $(cat ${manifest}); do rm -fv ${file}; done
    set -x

    # remove manifest
    rm -fv ${manifest}
}

function init_package() {
    alias ls=exa
}

function uninit_package() {
    unalias ls
}
