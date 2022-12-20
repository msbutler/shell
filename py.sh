
# install python3 via `sudo apt-get install python-is-python3`
# to ensure that python3 is in the default path
if [[ -e /usr/bin/python ]]; then
  export PATH="/usr/bin/python:$PATH"
elif [[ -e /usr/local/bin/python3 ]]; then
  # brew version which contains all sorts of nice unversioned symlinks
  # run 'brew info python' to get path
  export PATH="/usr/local/opt/python@3.10/libexec/bin:$PATH"
  
fi
