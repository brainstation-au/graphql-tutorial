#!/usr/bin/env bash

set -u

# Confirm current account id.
if aws sts get-caller-identity; then
  echo "You have a valid AWS token."
  CURRENT_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r ".Account")
  if [ "$ACCOUNT_ID" != "$CURRENT_ACCOUNT_ID" ]; then
    echo "Your logged in aws account id doesn't match with $ENVIRONMENT account id."
    exit 1
  fi
else
  exit 1
fi
