
if [ -f ~/.aws-access-key ]; then
  export AWS_ACCESS_KEY="$(cat ~/.aws-access-key)"
fi

if [ -f ~/.aws-secret-key ]; then
  export AWS_SECRET_KEY="$(cat ~/.aws-secret-key)"
fi
