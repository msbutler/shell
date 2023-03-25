#git

alias g="git"

# quickly add working tree to previous commit
alias gam="git add .; git commit --amend --no-edit"

# add, commit, and push current branch to butler remote
alias gp="gam; git push -u butler HEAD"
alias gpf="gam; git push -u butler HEAD -f"

# view branches that regex match
function gbv() {
  git for-each-ref --sort=committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)' | grep "$1" | sort -r
}

# switch branch
function gs(){
 git switch $1
}

# delete branches that regex match
unalias gbd
function gbd() {
  gbv $1
  echo "Press y to delete these branches"
  read ans
  if [[ $ans == "y" ]]; then
    git branch | grep "$1" | xargs git branch -D
  fi
}

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
