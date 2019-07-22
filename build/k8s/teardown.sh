#!/usr/bin/env bash

set -u

hash ktmpl || ( echo "ktmpl is missing, install with `brew install ktmpl`." >&2; exit 1; )
hash kubectl || ( echo "kubectl is missing, install with `brew install kubectl`." >&2; exit 1; )

die () { echo "$1" >&2; exit 1; }

# Check that required variables are set.
source build/variables.sh

ktmpl build/k8s/ktmpl.yml \
  -p APP_NAME $APP_NAME \
  -p NAMESPACE $NAMESPACE \
  -p REPLICA_COUNT $REPLICA_COUNT \
  -f "build/k8s/params/$ENVIRONMENT.yml" \
  | kubectl delete -f -
