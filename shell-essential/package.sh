function dependencies() {
    echo "git-delta git-config"
    echo "inputrc starship"
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
    alias watch="CLICOLOR_FORCE=1 watch -n1 --color"
}

function uninit_package() {
    unset HISTSIZE
    unset HISTFILESIZE
    unalias watch
}


