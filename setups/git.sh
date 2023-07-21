#git
unalias gbs
unalias gbd
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

# push an experimental version of the current branch, avoiding 
function gpe() {
  gam
  branch=$(git branch --show-current)
  exp="e-$branch"
  echo "deleting old experimental branch, if necessary"
  gbd $exp
  gbs $exp
  gpf 
  g switch $branch
}

# switch branch
function gs(){
 git switch $1
}

# delete branches that regex match
function gbd() {
  gbv $1
  echo "Press y to delete these branches"
  read ans
  if [[ $ans == "y" ]]; then
    git branch | grep "$1" | xargs git branch -D
  fi
}

# create a new branch off the current one and switch to it
function gbs() {
  git branch $1
  git switch $1
  git log --oneline | head -n 3
}

# force sync local branch to remote (git reset remote)
function grr(){
  branch=$(git rev-parse --abbrev-ref HEAD)
  
  if [[ "$(uname)" == "Darwin" ]]; then
echo "\n On mac. Really want to force pull? If so, press y"
   read ans
   if [[ $ans != "y" ]]; then
      exit 0
   fi
  fi

  # TODO: consider making a backup of the local branch
  git fetch butler

  # First reset branch so all commits match remote
  git reset --hard @{u}
  
  # Then get rid of untracked stuff
  gdd
}

# discard uncommitted stuff, but NOT .gitignored stuff.
function gdd(){
 
 # first check if there any uncommitted files
 if [[ -n $(git diff HEAD --name-only) ]] || [[ -n $(git clean -dfn) ]]; then
   echo "added files"
   git diff HEAD --name-only
   echo "\nuntracked files:"
   git clean -dfn
   echo "\nPress y to delete uncommited stuff"
   read ans
   if [[ $ans == "y" ]]; then
     # removes files that have been git added
     git reset --hard @{u}

     # removes files that have not been git added
     git clean -dfq
     fi
  fi
}



# git bisect helper
function gbi(){
 # gbi(bad_sha,good_sha,bash_script)
 chmod +x $3
 git bisect start $1 $2
 git bisect good
 git bisect bad
 git bisect run ./$3
 git bisect log
 git bisect reset
}
