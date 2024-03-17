function dependencies() {
    echo "git-delta git-config"
    echo "inputrc starship bash-history"
    echo "bat exa fzf zoxide ripgrep starship"
}

function install_package() {
    echo "Nothing to install"
}

function uninstall_package() {
    echo "Nothing to uninstall"
}

function init_package() {
    # unlimited history
    export HISTSIZE=
    export HISTFILESIZE=
}

function uninit_package() {
    unset HISTSIZE
    unset HISTFILESIZE
}


