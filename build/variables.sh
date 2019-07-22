#!/usr/bin/env bash

set -u

if [ -z ${ENVIRONMENT+x} ] || [ -z ${ENVIRONMENT} ]; then
  echo "Missing required variable ENVIRONMENT."
  exit 1
fi

if [[ !("$ENVIRONMENT" == "prod" || "$ENVIRONMENT" == "preprod") ]]; then
  echo "Valid values for ENVIRONMENT are: 'prod' and 'preprod'."
  exit 1
fi

# Get environment variables.
while read LINE; do eval "export $LINE"; done < .env

if [ -z ${APP_NAME+x} ] || [ -z ${APP_NAME} ]; then
  echo "Missing required variable APP_NAME."
  exit 1
fi

if [ -z ${NAMESPACE+x} ] || [ -z ${NAMESPACE} ]; then
  echo "Missing required variable NAMESPACE."
  exit 1
fi

if [ -z ${REPLICA_COUNT+x} ] || [ -z ${REPLICA_COUNT} ]; then
  echo "Missing required variable REPLICA_COUNT."
  exit 1
fi

# Get environment variables for current environment.
while read LINE; do eval "export $LINE"; done < ".env-$ENVIRONMENT"

if [ -z ${AWS_REGION+x} ] || [ -z ${AWS_REGION} ]; then
  echo "Missing required variable AWS_REGION."
  exit 1
fi

if [ -z ${ACCOUNT_ID+x} ] || [ -z ${ACCOUNT_ID} ]; then
  echo "Missing required variable ACCOUNT_ID."
  exit 1
fi

# Get unique tag for current build.
source build/build-tag.sh

export REPO_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME"
export IMAGE_URI="$REPO_URI:$BUILDTAG"
