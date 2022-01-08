#! /bin/bash
set -euo pipefail

BIN=~/.local/bin
SRC=~/.local/src
SHARE=~/.local/share
mkdir -p ${BIN} ${SRC} ${SHARE}

function banner() {
    local white_on_green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    printf "${white_on_green}------------------------------------------------------------${normal}\r"
    printf "${white_on_green}-- ${1} ${normal}\n"
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    echo
}

function add_line_to_file() {
    local file=${1}
    local line=${*:2}
    if ! grep "${line}" "${file}" &>/dev/null; then
        echo "${line}" >>${file}
    fi
}

function initrc() {
    local initrc=~/.bashrc
    add_line_to_file ${initrc} ${1}
    source ${initrc}
}

function install_gnu_stow() {
    banner "Installing GNU/Stow"
    local version=${1-2.3.1}
    local tarball=stow-${version}.tar.gz
    curl -L http://ftp.gnu.org/gnu/stow/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${SRC}/
    pushd .
        cd ${SRC}/stow-${version}/
        ./configure --prefix ~/.local/ && make install
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PERL5LIB=~/.local/share/perl/'
    initrc 'export PATH=~/.local/bin:$PATH'
    export PATH=~/.local/bin:$PATH
    export PERL5LIB=~/.local/share/perl/
}

function configure_git() {
    banner "Configuring git"
    if [ -f ~/.gitconfig ]; then
        mv -v ~/.gitconfig ~/.gitconfig.bak
    fi
    stow git
    initrc 'alias w="git status -s"'
    initrc 'alias d="git diff"'
    initrc 'alias l="git lol"'
    initrc 'alias g="git lolg"'
}

function configure_bash() {
    banner "Configuring bash"
    if [ -f ~/.inputrc ]; then
        mv -v ~/.inputrc ~/.inputrc.bak
    fi
    stow bash
    initrc 'export EDITOR=$([ "$TERM_PROGRAM" == "vscode" ] && echo "code --wait" || echo "vim")'
    initrc 'export VISUAL="$EDITOR"'
}

function install_libtree() {
    banner "Installing libtree"
    local version=${1-v2.0.0}
    curl -L https://github.com/haampie/libtree/releases/download/${version}/libtree_x86_64 --output ${BIN}/libtree
    chmod u+x ${BIN}/libtree
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_starship() {
    banner "Installing starship"
    local version=${1-v1.1.1}
    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/starship/starship/releases/download/${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd
    stow starship
    initrc 'eval "$(starship init bash)"'
}


function install_exa() {
    banner "Installing exa"
    local version=${1-v0.10.1}
    local zipfile=exa-linux-x86_64-${version}.zip
    curl -L https://github.com/ogham/exa/releases/download/${version}/${zipfile} --output /tmp/${zipfile}
    pushd .
        cd ~/.local
        unzip -o /tmp/${zipfile}
        rm -rf /tmp/${zipfile}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias ls=exa'
}

function install_bat() {
    banner "Installing bat"
    local version=${1-v0.18.3}
    local tarball=bat-${version}-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/sharkdp/bat/releases/download/${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd /tmp
        tar xvf /tmp/${tarball}
        find /tmp/${tarball%.tar.gz} -name "bat" -type f -exec mv {} ~/.local/bin/ \;
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_bfs() {
    banner "Installing bfs"
    stow bfs
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias find=bfs'
}

function install_fzf() {
    banner "Installing fzf"
    local version=${1-0.29.0}
    local tarball=fzf-${version}-linux_amd64.tar.gz
    curl -L https://github.com/junegunn/fzf/releases/download/${version}/${tarball} --output /tmp/${tarball}
    mkdir -pv ${SHARE}/fzf
    curl -L https://raw.githubusercontent.com/junegunn/fzf/${version}/shell/key-bindings.bash --output ${SHARE}/fzf/key-bindings.bash
    ls -la ${SHARE}/fzf/
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'FZF_ALT_C_COMMAND="bfs ~/ -type d"'
    initrc 'source ~/.local/share/fzf/key-bindings.bash'
}

function install_lazygit() {
    banner "Installing lazygit"
    local version=${1-0.31.4}
    local tarball=lazygit_${version}_Linux_x86_64.tar.gz
    curl -L https://github.com/jesseduffield/lazygit/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball} lazygit
        rm -rf /tmp/${tarball}
    popd
    stow lazygit
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_nodejs() {
    banner "Installing nodejs"
    local version=${1-v16.13.1}
    local tarball=node-${version}-linux-x64.tar.gz
    curl -L https://nodejs.org/download/release/${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ~/.local
        tar xvf /tmp/${tarball} --strip-components=1 --exclude="*/CHANGELOG.md" --exclude="*/README.md" --exclude="*/LICENSE"
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_neovim() {
    banner "Installing NeoVIM"
    local version=${1-v0.6.1}
    curl -L https://github.com/neovim/neovim/releases/download/${version}/nvim.appimage --output ${BIN}/nvim
    chmod u+x ${BIN}/nvim
    stow neovim
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias vim=nvim'

    banner "Installing packer"
    local packer=~/.local/share/nvim/site/pack/packer/start/packer.nvim
    rm -rf ${packer}
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ${packer}

    banner "Installer NeoVIM packages"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c "PackerCompile" -c 'PackerSync'

    banner "Installer NeoVIM LSP servers"
    nvim --headless -c "LspInstall --sync sumneko_lua" +qa
    nvim --headless -c "LspInstall --sync tsserver" +qa
    nvim --headless -c "LspInstall --sync eslint" +qa
    nvim --headless -c "LspInstall --sync jsonls" +qa
    nvim --headless -c "LspInstall --sync htmljsonls" +qa
    nvim --headless -c "LspInstall --sync yamlls" +qa
    nvim --headless -c "LspInstall --sync pyright" +qa
    nvim --headless -c "LspInstall --sync clangd" +qa
    nvim --headless -c "LspInstall --sync cmake" +qa
}

install_gnu_stow
configure_bash
configure_git
install_libtree
install_starship
install_exa
install_bat
install_bfs
install_fzf
install_lazygit
install_nodejs
install_neovim
