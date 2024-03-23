function dependencies() {
    echo "ripgrep rust clang nodejs golang neovim"
}

function install_package() {
    local branch=catppuccin

    git clone https://github.com/meuter/nvim -b ${branch} ${DOTFILES_CONFIG}/nvim
}

function uninstall_package() {
    rm -rvf ${DOTFILES_CONFIG}/nvim
}


