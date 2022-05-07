#!/usr/bin/env bash
set -euo pipefail

GIT_ROOT=$(git rev-parse --show-toplevel)

### Emacs
# Ensure emacs config dir exists
mkdir -p ~/.emacs.d
# Add symlink (replacing existing links)
ln -svf "${GIT_ROOT}/emacs/init.el" ~/.emacs.d/init.el
ln -svf "${GIT_ROOT}/emacs/.custom.el" ~/.emacs.d/.custom.el
ln -svf "${GIT_ROOT}/emacs/elisp" ~/.emacs.d
ln -svf "${GIT_ROOT}/emacs/snippets" ~/.emacs.d

### Git
ln -svf "${GIT_ROOT}/config/git/gitconfig" ~/.gitconfig
ln -svf "${GIT_ROOT}/config/git/gitignore" ~/.gitignore
ln -svf "${GIT_ROOT}/config/git/gitmessage" ~/.gitmessage

### Conky
# Run on startup
# Config
# Graphics (Fedora, but could be platform-dependent)

### Gnome
# Disable indexing
touch ~/.nomedia
