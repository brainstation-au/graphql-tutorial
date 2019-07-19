#!/usr/bin/env bash

set -u

hash aws || ( echo "AWS cli is missing" >&2; exit 1; )
hash kubectl || ( echo "kubectl is missing" >&2; exit 1; )

die () { echo "$1" >&2; exit 1; }

# Check that required variables are set.
source $(dirname "$0")/variables.sh

# Deploy aws stack.
echo "Deploy AWS"
docker-compose -f build/docker-compose.yml build deploy
if ! docker-compose -f build/docker-compose.yml run --rm deploy; then
  die "Failed to deploy AWS resources in $ENVIRONMENT"
fi

# Create and upload docker container for ECR.
RepositoryUri=$(aws ecr describe-repositories --repository-names $AppName | jq -r ".repositories[0].repositoryUri")

if [[ $RepositoryUri == "" ]]; then
  die "Couldn't find repository '$AppName'."
fi

# ImageTag=$(date +%s)
ImageTag="latest"

# Build the application image and upload to ECR.
docker-compose -f docker-build.yaml build server
docker tag graphql-tutorial_server:latest $RepositoryUri:$ImageTag
$(aws ecr get-login --no-include-email --region ap-southeast-2)
export ImageUri=$RepositoryUri:$ImageTag
docker push $ImageUri || { die "Failed to build and push application image"; }

kubectl apply -f build/k8s/
