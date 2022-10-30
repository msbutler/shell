
# Path to your oh-my-zsh installation.                                        

if [[ "$(uname)" == "Darwin" ]]; then
   
   export ZSH="/Users/michaelbutler/.oh-my-zsh"                                          
   
   # a couple helpers on my mac that haven't gotten checked in yet
   source ~/bin/helpers.sh

   # haven't migrated go things yet to the repo

   # proper go paths
   export GOPATH=~/go
   export GOROOT="$(brew --prefix go)/libexec"
   export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


   export PATH="/usr/local/opt/python@3.7/bin:$PATH" 


   #mac make path
   export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
else
   # for gce worker
   export ZSH="/home/michaelbutler/.oh-my-zsh"                                          
 fi        

ZSH_THEME="robbyrussell"


#for substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

plugins=(git autojump auto-notify zsh-history-substring-search  
zsh-autosuggestions zsh-syntax-highlighting)

# Set threshold to 20seconds
export AUTO_NOTIFY_THRESHOLD=20

# Add docker to list of ignored commands
AUTO_NOTIFY_IGNORE+=("docker","vim","git commit","less","ssh")

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

for i in ~/.shell/aliases/*; do
  source $i
done

for i in ~/.shell/tools.d/*; do
  source $i
done


export PATH="/usr/local/opt/go@1.17/bin:$PATH"
export PATH="/usr/local/opt/go@1.19/bin:$PATH"

