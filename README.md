# Ansible Playbook Based Dotfiles

This repo contains an ansible playbook that can be used to 
install all the necessary tools and config that I use on a daily 
basis, including, but not limited to:

- rust
- clang
- go
- nodejs
- neovim
- staship
- fzf
- ripgrep

## Prerequisite

Install Ansible

  ```bash
  pip install ansible
  ```

## Installation

To install everyting on localhost:

```bash
./playbook -t user
```

To install everything on a distant machine:

```bash
./playbook -i some.distant.machine.com -t user
```

To install only one packages:

```bash
./playbook -t neovim 
```

To install only one package including its custon config:

```bash
./playboot -t neovim_config
```



