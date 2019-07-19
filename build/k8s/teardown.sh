#!/usr/bin/env bash

set -u

hash ktmpl || ( echo "ktmpl is missing, install with `brew install ktmpl`." >&2; exit 1; )
hash kubectl || ( echo "kubectl is missing, install with `brew install kubectl`." >&2; exit 1; )

die () { echo "$1" >&2; exit 1; }

# Check that required variables are set.
source $(dirname "$0")/../variables.sh

ktmpl build/k8s/ktmpl.yml \
  -f build/k8s/params/default.yml \
  -f "build/k8s/params/$ENVIRONMENT.yml" \
  | kubectl delete -f -
