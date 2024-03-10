function dependencies() {
    echo "sdkman"
}

function install_package() {
    set +euxo pipefail
    sdk install gradle 7.5.1
}

function uninstall_package() {
    set +euxo pipefail
    sdk uninstall --force gradle 7.5.1
}

function uninit_package() {
    unset GRADLE_HOME
}

