function install_package() {
    local version=20.11.0
    local tarball=node-v${version}-linux-x64.tar.gz
    local checksum=2b2f26b9ed7f1a7c093269a8080ed093
    local manifest=${DOTFILES_SHARE}/nodejs/manifest.txt

    curl -L https://nodejs.org/download/release/v${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p $(dirname ${manifest})
    tar xvf /tmp/${tarball} \
        --strip-components=1 \
        --exclude="*/CHANGELOG.md" \
        --exclude="*/README.md" \
        --exclude="*/LICENSE" \
        -C ${DOTFILES_PREFIX} | tee ${manifest}
    sed -i "s#${tarball%.*.*}#${DOTFILES_PREFIX}#" ${manifest}
    sed -i "/.*\/$/d"                              ${manifest}

    npm config set prefix "${DOTFILES_PREFIX}"

    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    local manifest=${DOTFILES_SHARE}/nodejs/manifest.txt

    set +x
    for file in $(cat ${manifest}); do rm -fv ${file}; done
    set -x

    rm -fv ${manifest}
}
