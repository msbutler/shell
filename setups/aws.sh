
if [ -d ~/.aws ]; then
  # commenting out to see if that allows aws cmds to by default use the aws profile
  #export AWS_ACCESS_KEY_ID="$(aws configure get aws_access_key_id)"
  #export AWS_SECRET_ACCESS_KEY="$(aws configure get aws_secret_access_key)"
  export AWS_PROFILE=CRLShared-541263489771 
fi
