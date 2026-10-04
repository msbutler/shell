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

# --- Zsh Installation ---

if ! command -v zsh > /dev/null 2>&1; then
  if [ "$(uname)" = "Darwin" ]; then
    echo "Installing zsh via brew..."
    brew install zsh || echo "Warning: failed to install zsh"
  else
    echo "Installing zsh via apt-get..."
    sudo apt-get install -y zsh || echo "Warning: failed to install zsh"
  fi
fi

# --- Plugin Installation ---

ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"
NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# The gitconfig rewrites https://github.com/ to ssh, so every clone below needs
# a working GitHub ssh key. Check once, and only if something needs cloning, so
# the automatic setup.sh run on each new shell doesn't pay for an ssh round trip.
if [ ! -d "$ZSH_DIR" ] \
  || [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] \
  || [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] \
  || [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] \
  || [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ] \
  || [ ! -e "$NVIM_DIR" ]; then
  # GitHub's ssh endpoint exits 1 even on success, so match on its greeting.
  if ! ssh -T -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new \
      git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "Error: cannot authenticate to GitHub over ssh, so oh-my-zsh and plugins can't be cloned."
    echo "Add an ssh key for this machine to https://github.com/settings/keys, check it with"
    echo "'ssh -T git@github.com', then rerun ~/.shell/setup.sh."
    exit 1
  fi
fi

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

# --- Neovim Config ---

# Clone kickstart.nvim on first run; afterwards fast-forward it only when the
# remote has new commits. A non-fast-forward (local commits or edits) is left
# alone with a warning rather than clobbered.
if [ ! -e "$NVIM_DIR" ]; then
  echo "Installing nvim config..."
  mkdir -p "$(dirname "$NVIM_DIR")"
  git clone https://github.com/msbutler/kickstart.nvim.git "$NVIM_DIR" \
    || echo "Warning: failed to install nvim config"
elif [ -d "$NVIM_DIR/.git" ]; then
  if git -C "$NVIM_DIR" fetch -q 2>/dev/null; then
    if [ "$(git -C "$NVIM_DIR" rev-parse HEAD)" != "$(git -C "$NVIM_DIR" rev-parse @{u})" ]; then
      echo "Updating nvim config..."
      git -C "$NVIM_DIR" merge -q --ff-only @{u} 2>/dev/null \
        || echo "Warning: $NVIM_DIR has diverged from its remote; update it by hand"
    fi
  else
    echo "Warning: failed to fetch nvim config updates"
  fi
else
  echo "Warning: $NVIM_DIR exists but isn't a git checkout; skipping nvim config"
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
