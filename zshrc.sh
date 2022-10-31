# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure python path is set before setting up zsh
# TODO: add languages to zsh_profile
source ~/.shell/py.sh

if [[ "$(uname)" == "Darwin" ]]; then
   
   export ZSH="/Users/michaelbutler/.oh-my-zsh"                                          
   
   # a couple helpers on my mac that haven't gotten checked in yet
   source ~/bin/helpers.sh

   # haven't migrated go things yet to the repo

   # proper go paths
   export GOPATH=~/go
   export GOROOT="$(brew --prefix go)/libexec"
   export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

   # mac make path
   export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"

   # for substring search
   bindkey '^[[B' history-substring-search-down
   bindkey '^[[A' history-substring-search-up
else
   # for gce worker
   export ZSH="/home/michaelbutler/.oh-my-zsh"                                          
 
  [[ -s /home/michaelbutler/.autojump/etc/profile.d/autojump.sh ]] && source /home/michaelbutler/.autojump/etc/profile.d/autojump.sh

	autoload -U compinit && compinit -u
  fi        

ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(git autojump auto-notify zsh-history-substring-search  
zsh-autosuggestions zsh-syntax-highlighting)

# Set threshold to 20seconds
export AUTO_NOTIFY_THRESHOLD=20

AUTO_NOTIFY_IGNORE+=("docker","vim","git commit","less","ssh")

source $ZSH/oh-my-zsh.sh

source ~/.shell/p10k.zsh

for i in ~/.shell/setups/*; do
  source $i
done


export PATH="/usr/local/opt/go@1.17/bin:$PATH"
export PATH="/usr/local/opt/go@1.19/bin:$PATH"
