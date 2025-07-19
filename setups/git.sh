#git
unalias gbs
unalias gbd
unalias grb
alias g="git"

# quickly add working tree to previous commit
alias gam_nofmt="git add .; git commit --amend --no-edit"
alias gam="mbfmt; gam_nofmt"

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

# delete merged branches on master
function gdm() {
  git switch master
  grb
  git branch --merged | grep -Ev "master" | xargs git branch -d
  git switch -
}

# delete branches that regex match, and old and merged stuff.
function gbd() {
  gdm
  gdo
  if [ -z "$1" ]; then
    echo "No regex argument provided."
    return
  fi
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
  local remote
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD)
  remote=$(git config branch.$(git rev-parse --abbrev-ref HEAD).remote)  

  if [[ "$(uname)" == "Darwin" && "$remote" == "butler" ]]; then
echo "\n On mac. Really want to force pull? If so, press y"
   read ans
   if [[ $ans != "y" ]]; then
      return
   fi
  fi

  # TODO: consider making a backup of the local branch
  git fetch $remote $branch

  # First reset branch so all commits match remote
  git reset --hard "$remote/$branch"
  
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
# note the bash script could just contain a `./dev test blah`
# note2: if several commits merge as one (i.e. bors) check the surrounding commits
# that bisect finds.
#
# because of bors nonlinear history, you gotta search around the commit that
# this returns.
#
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

# git rebase helper
function grb(){
 # grb release-24.1 will rebase on release-24.1. grb will rebase on master
 
 branch="master" 
 if [ -n "$1" ]; then
  branch="$1"
  fi
 git fetch origin "$branch"
 git rebase origin/"$branch"
 git log -5 --format="%cd %s" --date=format:"%Y-%m-%d %H:%M:%S"
}

# get most recent commit not authored by Michael Butler
function gnotmb(){
  git log --perl-regexp --author='^((?!Michael Butler).*)$' -n 1 --format="%H"
}

# get commit right after passed in commit
function gnext(){
  git log --reverse --ancestry-path $1..HEAD  --format="%H" | head -n 1
}

# fetch branch from remote and switch to it
function gfs() {
  git fetch $1 $2
  git switch $2
}

# delete branches that have not been touched in 6 months
function gdo() {
  local threshold_days=180  # 6 months ≈ 180 days
  local current_branch
  local filter="${1:-}"  # optional pattern to narrow the branch list
  local stale_branches=()

  current_branch=$(git rev-parse --abbrev-ref HEAD)

  while IFS= read -r line; do
    branch_date=$(echo "$line" | awk '{print $1}')
    branch_name=$(echo "$line" | cut -d' ' -f2-)

    # Skip current branch
    if [[ "$branch_name" == "$current_branch" ]]; then
      continue
    fi

    # Convert dates to seconds since epoch
    branch_seconds=$(date -j -f "%Y-%m-%d" "$branch_date" "+%s" 2>/dev/null || date -d "$branch_date" "+%s")
    now_seconds=$(date "+%s")

    age_days=$(( (now_seconds - branch_seconds) / 86400 ))

    if (( age_days >= threshold_days )); then
      stale_branches+=("$branch_name")
    fi
  done < <(gbv "$filter")

  if [[ ${#stale_branches[@]} -eq 0 ]]; then
    echo "✅ No branches older than 6 months found matching '${filter}'."
    return
  fi

  echo "🗑️ The following branches are older than 6 months and will be deleted:"
  printf '  - %s\n' "${stale_branches[@]}"

  echo -e "\nPress y to confirm deletion:"
  read -r ans
  if [[ "$ans" == "y" ]]; then
    for branch in "${stale_branches[@]}"; do
      git branch -D "$branch"
    done
  else
    echo "❎ Aborted. No branches were deleted."
  fi
}
