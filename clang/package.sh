function install_package() {
    # version info
    local version=15.0.6
    local tarball=clang+llvm-${version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    local checksum=a48464533ddabc180d830df7e13e82ae
    local manifest=${DOTFILES_SHARE}/clang/manifest.txt

    # download tarball
    curl -L https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball directly in destibation
    mkdir -p $(dirname ${manifest})
    tar xvf /tmp/${tarball} --strip-components=1 -C ${DOTFILES_PREFIX} | tee ${manifest}
    sed -i "s#${tarball%.*.*}#${DOTFILES_PREFIX}#" ${manifest}
    sed -i "/.*\/$/d"                              ${manifest}

    # cleanup tarball
    rm -v /tmp/${tarball}
}

function uninstall_package() {
    local manifest=${DOTFILES_SHARE}/clang/manifest.txt

    set +x
    for file in $(cat ${manifest}); do rm -fv ${file}; done
    set -x

    rm -fv ${manifest}
}

