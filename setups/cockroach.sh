if [[ -d "${GOPATH}/src/github.com/cockroachdb/cockroach/bin" ]]; then
  export PATH=${PATH}:${GOPATH}/src/github.com/cockroachdb/cockroach/bin
fi

if [ -f ~/.cockroach.lic ]; then
  export COCKROACH_DEV_LICENSE="$(cat ~/.cockroach.lic)"
fi

if [ -f ~/.github_token ]; then                                                
   export GITHUB_TOKEN="$(cat ~/.github_token)"                        
fi  

# gceworker
export GCEWORKER_NAME=gceworker-butler

# roachprod
export CLUSTER=butler-test
ROACHPROD_USER=butler

# bazel configs
export ALWAYS_RUN_GAZELLE=1

# deals with a strange mac bug for crdb
export MACOSX_DEPLOYMENT_TARGET=12.0


if [[ -d "${GOPATH}/src/github.com/cockroachlabs/managed-service" ]]; then
  export PATH=${PATH}:${GOPATH}/src/github.com/cockroachlabs/managed-service/bin
fi


function cla() {
  curl -H "Authorization: token $GITHUB_TOKEN" \
    -d '{"state": "success", "context":"license/cla", "description": "curl"}' \
    https://api.github.com/repos/cockroachdb/cockroach/statuses/$1
}

# Specify  master, sha, or release (e.g. v22.1.5) and pull the cockroach binary
# to the current directory. If master or sha is specified, the workload binary 
# also gets pulled.
# 
# binaries master; binaries sha [sha]; binaries release [release]
function binaries() {
 roachprod destroy local 
 roachprod create -n 1 local
 
 os="linux"
 if [[ "$3" == "darwin" ]]; then
   os="darwin"
 fi
 
 if [[ "$1" == "master" ]]; then
   roachprod stage local cockroach --os linux
   roachprod stage local workload --os linux
   mv ~/local/1/workload workload
 elif [[ "$1" == "sha" ]]; then
   roachprod stage local cockroach $2 --os $os
   roachprod stage local workload $2 --os $os
   mv ~/local/1/workload workload
 
 elif [[ "$1" == "release" ]]; then
   roachprod stage local release $2 --os $os
 else
   echo "invalid args: kind $1; target $2"
   return 1
 fi 

 mv ~/local/1/cockroach cockroach
 
 roachprod destroy local
 pwd
}

function mbfmt() {                                                              
    echo crlfmt                                                              
    git diff-tree --no-commit-id --name-only -r HEAD | grep '.go' | xargs -n1 crlfmt  -tab 2 -w
  }

function user() {
  roachprod list | grep \'$CLUSTER\'
  roachprod sql $1 --secure -- -e "CREATE ROLE \"michael\" WITH LOGIN PASSWORD 'butler'"
}

function gce_clean() {
 cd .
 echo "Before"
 du -h | sort -hr | head -10
 # TODO add docker removal
 echo "remove docker images manually for now"
 sudo du -hs /var/lib/docker
 cd $GOPATH/src/github.com/cockroachdb/cockroach
 ./dev cache --down
 ./dev cache --clean
 bazel clean --expunge
 cd .
 echo "After"
 du -h | sort -hr | head -10
}   
