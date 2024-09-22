function install_package() {
    local version=18.1.8
    local tarball=clang+llvm-${version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    local checksum=aeb379a5688b8d7b7d3c0d8353d30265
    local manifest=${DOTFILES_SHARE}/clang/manifest.txt

    curl -L https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p $(dirname ${manifest})
    tar xvf /tmp/${tarball} \
        --strip-components=1 \
        -C ${DOTFILES_PREFIX} | tee ${manifest}
    sed -i "s#${tarball%.*.*}#${DOTFILES_PREFIX}#" ${manifest}
    sed -i "/.*\/$/d"                              ${manifest}

    rm -v /tmp/${tarball}
}

function uninstall_package() {
    local manifest=${DOTFILES_SHARE}/clang/manifest.txt

    set +x
    for file in $(cat ${manifest}); do rm -fv ${file}; done
    set -x

    rm -fv ${manifest}
}

