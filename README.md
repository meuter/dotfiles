# Introduction

Here lies my _dotfiles_. But these are not ordinary dotfiles. It is more like
an artisanal package manager of sorts. Each "package" is a script that will
install a component locally (in `~/.local`) as well as the corresponding config
`~/.config`.

But Why, you may ask? 🤔
1. Because I can 🤓.
2. Because I often work remotely on servers where I do not have root access.
   And this package manager is a way to gain back control.
3. Because I always get the exact version I want regardless of the underlying
   distribution / package manager.
4. Because I can restart from scratch by removing `~/.local` and `~/.config`
   and rerun one command in mimutes.

# Installation

Just clone, source `bootstrap.sh` in your `~/.bashrc` and you have access to
additional commands:
- `install` to install a package
- `uninstall` to uninstall a package
- `is_installed` that will return with exit 
  code 0 if and only if a package is installed

```bash
git clone https://github.com/meuter/dotfiles ~/.dotfiles/
echo ". ~/.dotfiles/bootstrap.sh" >> ~/.bashrc
. ~/.dotfiles/bootstrap.sh
dotfiles_install all

```

# Packages 

## Structure

```bash
#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    # function used to indicate the list of packages on 
    # which this package depends.
    # NOTE: no transitive package dependencies, you need to 
    #       specify *ALL* packages including their dependencies
    #       and their dependencies, etc.
    echo ""
}

function install_package() {
    # function used to install the package
    echo -n
}

function uninstall_package() {
    # function used to uninstall the package
    echo -n
}

function init_package() {
    # function used to initialize the package 
    # (will be called from ~/.bashrc via bootstrap.sh)
    echo -n
}

```

## Example

This is a package file to install neovim

```bash
#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "golang rust ripgrep nodejs"
}

function install_package() {
    local version=0.9.5
    local tarball=nvim-linux64.tar.gz
    curl -L https://github.com/neovim/neovim/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_PREFIX}
        tar xvf /tmp/${tarball} --strip-components=1
        rm -rf /tmp/${tarball}
    popd &> /dev/null
    git clone https://github.com/meuter/nvim ${DOTFILES_CONFIG}/nvim
}

function uninstall_package() {
    rm -rvf \
    	${DOTFILES_CONFIG}/nvim/ \
	    ${DOTFILES_SHARE}/nvim/ \
        ${DOTFILES_BIN}/nvim \
        ${DOTFILES_LIB}/nvim \
        ${DOTFILES_MAN}/man1/nvim.1
    rm -vf \
        $(find ${DOTFILES_SHARE} -name "*nvim*")
    unalias vim
}

function init_package() {
    alias vim=nvim
}

```

