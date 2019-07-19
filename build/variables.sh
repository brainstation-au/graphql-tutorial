#!/usr/bin/env bash

set -u

# Get environment variables.
while read LINE; do eval "export $LINE"; done < .env

if [ -z ${ENVIRONMENT+x} ] || [ -z ${ENVIRONMENT} ]; then
  echo "Missing required variable ENVIRONMENT."
  exit 1
fi

if [[ !("$ENVIRONMENT" == "prod" || "$ENVIRONMENT" == "preprod") ]]; then
  echo "Valid values for ENVIRONMENT are: 'prod' and 'preprod'."
  exit 1
fi
