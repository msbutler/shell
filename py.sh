
# install python3 via `sudo apt-get install python-is-python3`
# to ensure that python3 is in the default path
if [[ -e /usr/bin/python ]]; then
  export PATH="/usr/bin/python:$PATH"
elif [[ -e /usr/local/bin/python3 ]]; then
  # brew version
  export PATH="/usr/local/bin/python3:$PATH"
  alias python=/usr/local/bin/python3
fi
