# Dotfiles

GNU Stow manages these dotfiles by symlinking package contents into `$HOME`.

## Layout

Each top-level directory is a Stow package and mirrors the destination paths
relative to `$HOME`.

```text
ghostty/
  .config/
    ghostty/
      config.ghostty
nvim/
  .config/
    nvim/
      init.lua
      lua/
      lsp/
      plugin/
zsh/
  .zshenv
  .config/
    zsh/
      .zshenv
      .zshrc
      .p10k.zsh
```

## Install

Preview changes:

```sh
./setup-dotfiles.sh --dry-run
```

Install every package:

```sh
./setup-dotfiles.sh
```

Install selected packages:

```sh
./setup-dotfiles.sh nvim ghostty
```

Uninstall selected packages:

```sh
./setup-dotfiles.sh --delete nvim ghostty
```

## Existing Files

Stow refuses to overwrite real files in `$HOME`. If a file already exists, move
or merge it first.

To intentionally import existing target files into this repo, preview and then
run with `--adopt`:

```sh
./setup-dotfiles.sh --dry-run --adopt zsh
./setup-dotfiles.sh --adopt zsh
```

Review adopted files afterwards before committing changes.
