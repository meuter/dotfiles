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
	$(call nix_install, zip unzip curl wget htop tree)

install_stow:
	$(call nix_install, stow)

install_git: install_stow configure_bash
	$(call nix_install, git delta)
	stow git

install_starship: install_stow configure_bash
	$(call nix_install, starship)
	stow starship

install_all: \
	configure_bash \
	install_essentials \
	install_stow \
	install_git \
	install_starship 

deepclean:
	nix-env -e '*'
	sed -i -e '/^for.*bashrc\.d/d' ~/.bashrc
	rm -rf ~/.local ~/.gitconfig ~/.config ~/.inputrc ~/.bashrc.d
