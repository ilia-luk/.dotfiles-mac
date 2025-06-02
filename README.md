# .dotfiles for the modern macOS ninja

## Brew dependencies

```bash
  brew install stow \
  openssl \
  cmake \
  kitty \
  fish \
  nushell \
  zoxide \
  carapace \
  starship \
  bat \
  bat-extras \
  fd \
  onefetch \
  fastfetch \
  bottom \
  htop \
  zellij \
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

step 1: make any changes in `~/.dotfiles` configs and run the following to sync to system

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

```nushell
  chsh -s (which nu | get path | first)
```

step 4: close current terminal and re/open kitty.
