define nix_install
	nix-env -iA $(addprefix nixpkgs.,$(1))
endef

install_nix:
	sh <(curl -L https://nixos.org/nix/install) --daemon

configure_bash:
	mkdir -p ~/.bashrc.d
	if ! grep -e ^for.*bashrc.d ~/.bashrc > /dev/null; then \
		echo 'for file in ~/.bashrc.d/*.bashrc; do source $$file; done' >> ~/.bashrc; \
	fi

install_essentials:
	$(call nix_install, zip unzip curl wget htop tree bfs xclip)

install_stow:
	$(call nix_install, stow)

install_git: install_stow configure_bash
	$(call nix_install, git delta)
	stow git

install_starship: install_stow configure_bash
	$(call nix_install, starship)
	stow starship

install_exa: install_stow configure_bash
	$(call nix_install, exa)
	stow exa

install_fzf: install_stow configure_bash
	$(call nix_install, fzf)
	stow fzf

install_tmux: install_stow configure_bash
	$(call nix_install, tmux)
	stow tmux

install_gcc:
	$(call nix_install, gcc11)
	nix-env --set-flag priority 0 $$(nix-env -q | grep gcc)

install_clang:
	$(call nix_install, clang_14 clang-tools_14)
	nix-env --set-flag priority 1 $$(nix-env -q | grep clang)

install_rust: install_stow configure_bash
	$(call nix_install, rustc cargo)
	stow rust
	nix-env --set-flag priority 1 $$(nix-env -q | grep rustc)
	nix-env --set-flag priority 1 $$(nix-env -q | grep cargo)
	$(call nix_install, rustup)

install_nodejs:
	$(call nix_install, nodejs-18_x)

install_python:
	$(call nix_install, python310 python310Packages.pip python310Packages.virtualenv python310Packages.pytest python310Packages.pycryptodome)

install_go: install_stow configure_bash
	$(call nix_install, go)
	mkdir -p ~/.local/go
	stow go

install_ripgrep:
	$(call nix_install, ripgrep)

install_fd:
	$(call nix_install, fd)

install_neovim: install_stow configure_bash \
	install_fzf install_fd install_ripgrep install_essentials \
	install_nodejs install_python install_git install_gcc \
	install_go install_rust 
	$(call nix_install, neovim)
	stow neovim 
	make -f ~/.config/nvim/Makefile install

install_all: \
	install_essentials \
	install_stow \
	install_git \
	install_starship \
	install_exa \
	install_fzf \
	install_tmux \
	install_gcc \
	install_clang \
	install_rust \
	install_nodejs \
	install_python \
	install_go \
	install_fd \
	install_ripgrep \
	install_neovim

deepclean:
	nix-env -e '*'
	sed -i -e '/^for.*bashrc\.d/d' ~/.bashrc
	chmod u+w -Rf ~/.local/go || true
	rm -rf ~/.local ~/.gitconfig ~/.config ~/.inputrc ~/.bashrc.d ~/.cache ~/.nix-defexpr
	rm -f ~/.nix-profile
