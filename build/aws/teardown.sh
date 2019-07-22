#!/usr/bin/env bash

set -u

hash aws || ( echo "AWS cli is missing, install with `brew install awscli`." >&2; exit 1; )

die () { echo "$1" >&2; exit 1; }

# Check that required variables are set.
source build/variables.sh

ImageIds=$(aws ecr list-images --repository-name $APP_NAME | jq ".imageIds[].imageDigest" | while read line; do echo "imageDigest=$line"; done)
if ! aws ecr batch-delete-image --repository-name "$APP_NAME" --image-ids $ImageIds; then
  die "Unable to delete images from repository $APP_NAME"
fi

echo "Starting teardown"
aws cloudformation delete-stack \
  --stack-name $APP_NAME
aws cloudformation wait stack-delete-complete \
  --stack-name $APP_NAME
