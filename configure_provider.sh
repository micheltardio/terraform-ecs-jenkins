#!/usr/bin/env sh

# This scripts generates terraform provider and s3 backend configuration
# Usage: ./add_service.sh [service_name] [container port]

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: basename $0 [aws_cred_profile_name] [aws_region] [aws_s3_state_file_bucket_name] [key] [path]"
  exit 0
fi

# Non prod - ./configure_provider.sh 

TF_AWS_ACCESS_KEY_ID=`cat ~/.aws/credentials | grep aws_access_key_id | cut -d "=" -f 2- | tr -d '"'`
TF_AWS_SECRET_ACCESS_KEY=`cat ~/.aws/credentials | grep aws_secret_access_key | cut -d "=" -f 2- | tr -d '"'`
TF_AWS_DEFAULT_REGION=`cat ~/.aws/credentials | grep region | cut -d "=" -f 2- | tr -d '"' | head -1`
TF_AWS_PROFILE=${1?Error: no profile given}
TF_AWS_REGION=${2?Error: no region given}
TF_AWS_S3_BUCKET=${3?Error: no S3 bucket name given}
TF_WORKSPACE_PREFIX=${4?Eerror: no terraform workspace prefix given}
TF_AWS_STATE_FILE_KEY=${5?Error: no terraform key given}

echo
echo TF_AWS_PROFILE: $TF_AWS_PROFILE
echo TF_AWS_REGION: $TF_AWS_REGION
echo TF_AWS_S3_BUCKET: $TF_AWS_S3_BUCKET
echo TF_WORKSPACE_PREFIX: $TF_WORKSPACE_PREFIX
echo TF_AWS_STATE_FILE_KEY: $TF_AWS_STATE_FILE_KEY
echo


 sed -e "s;%TF_AWS_PROFILE%;${TF_AWS_PROFILE};g" \
      -e "s;%TF_AWS_REGION%;${TF_AWS_REGION};g" \
      -e "s;%TF_AWS_S3_BUCKET%;${TF_AWS_S3_BUCKET};g" \
      -e "s;%TF_AWS_STATE_FILE_KEY%;${TF_AWS_STATE_FILE_KEY};g" \
      provider.tf.template > provider.tf \


