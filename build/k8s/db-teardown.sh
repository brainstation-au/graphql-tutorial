#!/usr/bin/env bash

set -u

hash ktmpl || ( echo "ktmpl is missing, install with `brew install ktmpl`." >&2; exit 1; )
hash kubectl || ( echo "kubectl is missing, install with `brew install kubectl`." >&2; exit 1; )

# Check that required variables are set.
source build/variables.sh

ktmpl build/k8s/db.yml \
  -p APP_NAME $APP_NAME \
  -p NAMESPACE $NAMESPACE \
  | kubectl delete -f -

kubectl delete secret "$APP_NAME-admin" -n $NAMESPACE
