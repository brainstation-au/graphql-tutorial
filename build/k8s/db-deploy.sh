#!/usr/bin/env bash

set -u

hash ktmpl || ( echo "ktmpl is missing, install with `brew install ktmpl`." >&2; exit 1; )
hash kubectl || ( echo "kubectl is missing, install with `brew install kubectl`." >&2; exit 1; )

# Check that required variables are set.
# Doesn't care about correct IMAGE_URI, ignore BUILDTAG.
source build/variables.sh

ktmpl build/k8s/db.yml \
  -p APP_NAME $APP_NAME \
  -p NAMESPACE $NAMESPACE \
  | kubectl apply -f -

ITER_COUNT=0
ITER_MAX=60

while [ $ITER_COUNT -lt $ITER_MAX ]
do
	if kubectl get secret "$APP_NAME-admin" -n $NAMESPACE; then
		break
	fi
	(( ITER_COUNT++ ))
	sleep 30
done

if [ $ITER_COUNT -eq $ITER_MAX ]; then
	echo "Unable to find required secrets.";
	exit 1
fi
