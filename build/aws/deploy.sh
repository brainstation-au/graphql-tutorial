#!/usr/bin/env bash

set -u

hash aws || ( echo "AWS cli is missing, install with `brew install awscli`." >&2; exit 1; )

die () { echo "$1" >&2; exit 1; }

# Check that required variables are set.
source build/variables.sh

# Confirm current account id.
if [[ $(aws sts get-caller-identity | jq -r ".Account") != "$ACCOUNT_ID" ]]; then
  die "Your logged in aws account id doesn't match with $ENVIRONMENT account id."
fi

# Deploy aws stack.
echo "Deploy AWS"
docker-compose -f build/aws/docker-compose.yml build deploy
if ! docker-compose -f build/aws/docker-compose.yml run --rm deploy; then
  die "Failed to deploy AWS resources in $ENVIRONMENT"
fi

# Confirm repository availablity.
if aws ecr describe-repositories --repository-names $APP_NAME; then
  echo "$REPO_URI exists."
else
  exit 1
fi

# Build the application image and upload to ECR.
docker-compose -f docker-build.yml build app
docker build --tag $IMAGE_URI .
$(aws ecr get-login --no-include-email --region ap-southeast-2)
docker push $IMAGE_URI || { die "Failed to build and push application image"; }
