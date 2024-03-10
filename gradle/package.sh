function dependencies() {
    echo "sdkman"
}

function install_package() {
    # sdkman is weird...
    set +euxo pipefail
    sdk install gradle 7.5.1
}

function uninstall_package() {
    # sdkman is weird...
    set +euxo pipefail
    sdk uninstall --force gradle 7.5.1
}

function uninit_package() {
    unset GRADLE_HOME
}

