if [[ -d "${GOPATH}/src/github.com/cockroachdb/cockroach/bin" ]]; then
  export PATH=${PATH}:${GOPATH}/src/github.com/cockroachdb/cockroach/bin
fi

if [ -f ~/.cockroach.lic ]; then
  export COCKROACH_DEV_LICENSE="$(cat ~/.cockroach.lic)"
fi

if [ -f ~/.github_token ]; then                                                
   export GITHUB_TOKEN="$(cat ~/.github_token)"                        
fi  

# roachprod
export CLUSTER=butler-test
ROACHPROD_USER=butler

# bazel configs
export ALWAYS_RUN_GAZELLE=1

# deals with a strange mac bug for crdb
export MACOSX_DEPLOYMENT_TARGET=12.0


function cla() {
  curl -H "Authorization: token $GITHUB_TOKEN" \
    -d '{"state": "success", "context":"license/cla", "description": "curl"}' \
    https://api.github.com/repos/cockroachdb/cockroach/statuses/$1
}

# Specify  master or a release (e.g. v22.1.5) and pull binary to /bin
# If master is specified, the workload binary also gets pulled.
function binaries() {
 roachprod destroy local 
 roachprod create -n 1 local
 
 mkdir bin

 if [[ "$1" == "master" ]]; then
  roachprod stage local cockroach --os linux
  
  # Automatically get and copy workload to /bin directory
  roachprod stage local workload --os linux
  mv ~/local/1/workload bin/workload
 else
  roachprod stage local release $1 --os linux
 fi
 

 # Copy it from (local) node 1 to the current directory
 mv ~/local/1/cockroach bin/cockroach
 
 roachprod destroy local
 echo "Binaries in /bin" 
}
