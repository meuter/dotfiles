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
	$(call nix_install, zip unzip curl wget htop tree bfs)

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

install_gcc: 
	$(call nix_install, gcc11)
	nix-env --set-flag priority 0 $$(nix-env -q | grep gcc)

install_clang: 
	$(call nix_install, clang_14)
	nix-env --set-flag priority 1 $$(nix-env -q | grep clang)

install_rust: install_stow configure_bash
	$(call nix_install, rustc cargo)
	stow rust
	nix-env --set-flag priority 1 $$(nix-env -q | grep rustc)
	nix-env --set-flag priority 1 $$(nix-env -q | grep cargo)
	$(call nix_install, rustup)

install_all: \
	install_essentials \
	install_stow \
	install_git \
	install_starship \
	install_exa \
	install_fzf \
	install_gcc \
	install_clang \
	install_rust

deepclean:
	nix-env -e '*'
	sed -i -e '/^for.*bashrc\.d/d' ~/.bashrc
	rm -rf ~/.local ~/.gitconfig ~/.config ~/.inputrc ~/.bashrc.d
