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
