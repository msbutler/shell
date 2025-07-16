# Entry point for setting up the zsh shell, after symlinks are created.
# Only source this script from the home directory, not the git repo.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Check for updates to the shell scripts, but send stdout and stderr errors to dev/null
if [[ -d ~/.shell/.git ]]; then
   (( cd ~/.shell && git pull && ./setup.sh ) > /dev/null 2>/dev/null >/dev/null) || echo "cannot update ~/.shell automatically"
fi

# Ensure python path is set before setting up zsh
# TODO: add languages to zsh_profile 
source ~/.shell/py.sh
source ~/.shell/go.sh

if [[ "$(uname)" == "Darwin" ]]; then
   
   export ZSH="/Users/butler/.oh-my-zsh"                                          
   
   # a couple helpers on my mac that haven't gotten checked in yet
   # source ~/bin/helpers.sh

   # mac make path
   export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

   # for substring search
   bindkey '^[[B' history-substring-search-down
   bindkey '^[[A' history-substring-search-up
else
   # for gce worker
   export ZSH="$HOME/.oh-my-zsh"                                          
 
  [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

	autoload -U compinit && compinit -u
fi        
  
ZSH_THEME="powerlevel10k/powerlevel10k"

# install all of these except autojump via cloning into oh my zsh repo
# sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(git vi-mode autojump zsh-history-substring-search  
zsh-autosuggestions zsh-syntax-highlighting)

# Enter vi mode on cli with ctrl j
bindkey -M viins 'jk' vi-cmd-mode

# Fo vi cli, no other key mappings are present! careful!

# Ensure insert mode is a cursor
VI_MODE_SET_CURSOR=true

# Set threshold to 20seconds
# Auto notify no longer enabled
# export AUTO_NOTIFY_THRESHOLD=20

# AUTO_NOTIFY_IGNORE+=("docker","vim","git commit","less","ssh")

# add glean quicksearch
# ZSH_WEB_SEARCH_ENGINES=(glean "https://app.glean.com/?q=")

source $ZSH/oh-my-zsh.sh

source ~/.shell/p10k.zsh

for i in ~/.shell/setups/*; do
  source $i
done



# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

# Add Visual Studio Code (code)
export PATH="$PATH:$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Set vscode as default editor
export EDITOR="code -w"

# Add Node Path
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# Experiment with SH claude
export CLAUDE_CODE_USE_VERTEX=1                              
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=vertex-model-runners 
