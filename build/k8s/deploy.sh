#!/usr/bin/env bash

set -u

hash ktmpl || ( echo "ktmpl is missing, install with `brew install ktmpl`." >&2; exit 1; )
hash kubectl || ( echo "kubectl is missing, install with `brew install kubectl`." >&2; exit 1; )

die () { echo "$1" >&2; exit 1; }

# Check that required variables are set.
source build/variables.sh

# Deploy the db first.
source build/k8s/deploy-db.sh

# Deploy application.
ktmpl build/k8s/graphql-js.yml \
  -p APP_NAME $APP_NAME \
  -p NAMESPACE $NAMESPACE \
  -p REPLICA_COUNT $REPLICA_COUNT \
  -p IMAGE_URI $IMAGE_URI \
  | kubectl apply -f -
