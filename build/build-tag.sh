#!/usr/bin/env bash

set -u

# Check that BUILDTAG is set or that we are running in BuildKite
if [ ! -z ${BUILDTAG+x} ] && [ ! -z ${BUILDTAG} ]; then
  echo "BUILDTAG is available in the environment."
elif [ ! -z ${BUILDKITE_BUILD_NUMBER+x} ] && [ ! -z ${BUILDKITE_BUILD_NUMBER} ]; then
  export BUILDTAG="bk-${BUILDKITE_BUILD_NUMBER}"
else
  echo "BUILDTAG or BUILDKITE_BUILD_NUMBER are required env variables" >&2
  exit 1
fi
