# Brew dependencies

```bash
  brew install \
  stow\
  openssl\
  cmake\
  kitty\
  fish\
  nushell\
  zoxide\
  carapace\
  starship\
  --cask font-fira-code-nerd-font

```

## Make nushell default macOS shell

step 1: add nu to /etc/shells

```bash
  sudo sh -c 'echo | which nu >> /etc/shells'
```

step 2:

```bash
  chsh -s which nu
```
