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
./playbook -K
```

To install everything on a distant machine (pay attention to the `,`!):

```bash
./playbook -i some.distant.machine.com,
```

To install one the packages and config that do not require sudo privileges

```bash
./playbook -t user
```

To install only one packages:

```bash
./playbook -t neovim 
```

To install only one package including its custon config:

```bash
./playboot -t neovim_config
```

These options can be combined: e.g. to install docker (which requires sudo privileges) and 
a fully configured neovim on a distant machine:

```bash
./playbook -i some.distant.machine.com, -t neovim_config,docker -K
```

