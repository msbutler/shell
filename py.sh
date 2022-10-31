
# install python3 via `sudo apt-get install python-is-python3`
# to ensure that python3 is in the default path
if [[ -d /usr/bin/python ]]; then
  export PATH="/usr/bin/python:$PATH"
elif [[ -d /usr/local/bin/python ]]; then
  export PATH="/usr/local/bin/python:$PATH"
fi
