#!/usr/bin/env bash

set -u

die () { echo "$1" >&2; exit 1; }

# Check that BUILDTAG is set or that we are running in BuildKite
if [ ! -z ${BUILDTAG+x} ] && [ ! -z ${BUILDTAG} ]; then
  :
elif [ ! -z ${BUILDKITE_BUILD_NUMBER+x} ] && [ ! -z ${BUILDKITE_BUILD_NUMBER} ]; then
  export BUILDTAG="bk-${BUILDKITE_BUILD_NUMBER}"
else
  die "BUILDTAG or BUILDKITE_BUILD_NUMBER are required env variables"
fi
