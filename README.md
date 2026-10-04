# Setup on a new host
`git clone https://github.com/msbutler/shell.git ~/.shell && ~/.shell/setup.sh`

A poor man's https://github.com/dt/shell

## Mac apps and tools
Install via [Homebrew](https://brew.sh):

```
brew install neovim ripgrep fd
brew install --cask iterm2 rectangle alfred
```

- neovim: config is cloned from https://github.com/msbutler/kickstart.nvim by
  setup.sh; ripgrep and fd back its Telescope search.
- iterm2: terminal.
- rectangle: window snapping.
- alfred: launcher.

Other parts of setup to note:
- use iterm2
- in iterm, configure infinite scrollback, natural text editor, block cursor
  (more natural for vim).
- in non-insert mode, change the iterm font color to black to make the
  highlighted characters clearer.
- in os, map caps lock to esc for easier return to normal mode
