# Create the GOPATH env var which points to all go repos and and executables
export GOPATH="$HOME/go"

# Add $GOPATH/bin to PATH env var to make executables easy to call
export PATH=$PATH:$GOPATH/bin

if [[ -d /usr/local/opt/go@1.20/libexec ]]; then
    # brew install
    export GOROOT="/usr/local/opt/go@1.20/libexec"
    export PATH="/usr/local/opt/go@1.20/libexec/bin:$PATH"
elif [[ -d /usr/local/go/bin ]]; then
    #on gce worker
    export GOROOT="/usr/local/go"
    export PATH="/usr/local/go/bin:$PATH"
fi
