#!/usr/bin/env bash

set -u

if [ -z ${ENVIRONMENT+x} ] || [ -z ${ENVIRONMENT} ]; then
  echo "Missing required variable ENVIRONMENT."
  exit 1
fi

if [[ !("$ENVIRONMENT" == "prod" || "$ENVIRONMENT" == "preprod") ]]; then
  echo "Valid values for ENVIRONMENT are: 'test' and 'preprod'."
  exit 1
fi

# Application name.
export AppName="graphql-lab"
