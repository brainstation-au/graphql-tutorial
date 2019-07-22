#!/usr/bin/env bash

set -u

die () { echo "$1" >&2; exit 1; }

if [ -z ${ENVIRONMENT+x} ] || [ -z ${ENVIRONMENT} ]; then
  die "Missing required variable ENVIRONMENT."
fi

if [[ !("$ENVIRONMENT" == "prod" || "$ENVIRONMENT" == "preprod") ]]; then
  die "Valid values for ENVIRONMENT are: 'prod' and 'preprod'."
fi

# Make sure the client is logged in to correct environment.
if [[ $(kubectl config view -o json | jq ".clusters[0].name") != *"europa-$ENVIRONMENT"* ]]; then
  die "Client is not logged in to europa-$ENVIRONMENT."
fi

# Get environment variables.
while read LINE; do eval "export $LINE"; done < .env

if [ -z ${APP_NAME+x} ] || [ -z ${APP_NAME} ]; then
  die "Missing required variable APP_NAME."
fi

if [ -z ${NAMESPACE+x} ] || [ -z ${NAMESPACE} ]; then
  die "Missing required variable NAMESPACE."
fi

if [ -z ${REPLICA_COUNT+x} ] || [ -z ${REPLICA_COUNT} ]; then
  die "Missing required variable REPLICA_COUNT."
fi

# Get environment variables for current environment.
while read LINE; do eval "export $LINE"; done < ".env-$ENVIRONMENT"

if [ -z ${AWS_REGION+x} ] || [ -z ${AWS_REGION} ]; then
  die "Missing required variable AWS_REGION."
fi

if [ -z ${ACCOUNT_ID+x} ] || [ -z ${ACCOUNT_ID} ]; then
  die "Missing required variable ACCOUNT_ID."
fi

# Get unique tag for current build.
source build/build-tag.sh

export REPO_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME"
export IMAGE_URI="$REPO_URI:$BUILDTAG"
