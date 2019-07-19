#!/usr/bin/env bash

set -u

build/aws/deploy.sh
build/k8s/deploy.sh
