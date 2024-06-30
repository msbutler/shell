#!/bin/bash

# The entry point for a first time setup of the shell config: create symlinks
# from the repo to the home directory. Once the symlinks
# are created, any updates in the git repo are reflected in the shell.
ln -sf ~/.shell/zshrc.sh ~/.zshrc

ln -sf ~/.shell/confs/vimrc.sh ~/.vimrc
ln -sf ~/.shell/confs/ideavimrc.sh ~/.ideavimrc

ln -sf ~/.shell/confs/tmux.sh ~/.tmux.conf

ln -sf ~/.shell/confs/git/gitconfig ~/.gitconfig
ln -sf ~/.shell/confs/git/gitignore_global ~/.gitignore_global

mkdir -p ~/Library/Application\ Support/Code/User
ln -sf ~/.shell/confs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/.shell/confs/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
