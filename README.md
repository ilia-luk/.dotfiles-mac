# .dotfiles for the modern macOS ninja

## Brew dependencies

```bash
  brew install stow \
  openssl \
  cmake \
  kitty \
  fish \
  nushell \
  carapace \
  starship \
  asdf \
  bat \
  bat-extras \
  onefetch \
  fastfetch \
  bottom \
  htop \
  zellij \
  yazi \
  ffmpeg \
  sevenzip \
  jq \
  poppler \
  fd \
  ripgrep \
  fzf \
  zoxide \
  resvg \
  imagemagick \
  font-symbols-only-nerd-font \
  gpg \
  gawk \
  --cask font-fira-code-nerd-font

```

## Installation

step 1: create `~/.dotfiles` path on your machine by running the following

```bash
  mkdir ~/.dotfiles
```

step 2: clone this repository into ~/.dotfiles

```bash
  git clone <repo-url> ~/.dotfiles
```

step 3: delete .git

```bash
 cd ~/.dotfiles && rm-rf .git && git init
```

step 4: symlink all files (you might need to backup/remove existing config files)

```bash
 stow .
```

step 5: give execute permissions for `sync-dotfiles` script

```bash
  chmod +x ~/bin/sync-dotfiles
```

## Making changes in config files

step 1: make any changes in `~/.dotfiles` configs and run the following to sync the system

```bash
  sync-dotfiles
```

## Make nushell default macOS shell

step 1: add nu to /etc/shells

```bash
  sudo sh -c 'echo | which nu >> /etc/shells'
```

step 2: make sure you are inside nu shell.

```bash
  nu
```

step 3: define nu as default shell

```nu
  chsh -s (which nu | get path | first)
```

step 4: close current terminal and re/open kitty.

## Change default editor

step: 1: In `Library/Application Support/nushell/config.nu` change the following to the editor of your choice

```nu
  $env.EDITOR = 'nvim'
```

## NodeJS and Python version manager

step 1: run the following in a shell to install the NodeJS plugin

```nu
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

step 2: install a NodeJS latest version (or specific one using `asdf list all nodejs` and then changing `latest` to version number)

```nu
  asdf install nodejs latest
```

step 3: run the following in a shell to install the Python plugin

```nu
  asdf plugin add python
```

step 4: install a Python latest version (or specific one using `asdf list all python` and then changing `latest` to version number)

```nu
  asdf install python latest
```

step 5: change `.tool-version` to include the versions you selected to serve as global versions
