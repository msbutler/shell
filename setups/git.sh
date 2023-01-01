#git

alias g="git"

# push current branch to butler remote
alias gp="git push -u butler HEAD"
alias gpf="git push -u butler HEAD -f"

# create a new branch off the current one and switch to it
unalias gbs
function gbs() {
  git branch $1
  git switch $1
  git log --oneline | head -n 3
}


# force sync local branch to remote (git reset remote)
function grr(){
  branch=$(git rev-parse --abbrev-ref HEAD)
  # TODO: consider making a backup of the local branch
  git fetch
  git reset --hard @{u}
}
