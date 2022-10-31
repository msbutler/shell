
if [[ -d /usr/bin/python ]]; then
  export PATH="/usr/bin/python:$PATH"
elif [[ -d /usr/local/bin/python ]]; then
  export PATH="/usr/local/bin/python:$PATH"
fi
