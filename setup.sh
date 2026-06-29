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

mkdir -p ~/.claude
ln -sf ~/.shell/confs/claude/settings.json ~/.claude/settings.json

ln -sf ~/.shell/confs/cursorignore ~/.cursorignore

mkdir -p ~/Library/Application\ Support/Code/User
ln -sf ~/.shell/confs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/.shell/confs/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

# --- Plugin Installation ---

ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"

if [ ! -d "$ZSH_DIR" ]; then
  echo "Installing oh-my-zsh..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR" || echo "Warning: failed to install oh-my-zsh"
fi

if [ -d "$ZSH_DIR" ]; then
  if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" \
      || echo "Warning: failed to install powerlevel10k"
  fi

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
      || echo "Warning: failed to install zsh-autosuggestions"
  fi

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
      || echo "Warning: failed to install zsh-syntax-highlighting"
  fi

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    echo "Installing zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZSH_CUSTOM/plugins/zsh-history-substring-search" \
      || echo "Warning: failed to install zsh-history-substring-search"
  fi
fi

if ! command -v autojump > /dev/null 2>&1; then
  if [ "$(uname)" = "Darwin" ]; then
    echo "Installing autojump via brew..."
    brew install autojump || echo "Warning: failed to install autojump"
  else
    echo "Installing autojump via apt-get..."
    sudo apt-get install -y autojump || echo "Warning: failed to install autojump"
  fi
fi
