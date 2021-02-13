#!/usr/bin/env bash

CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then
    echo "\n${RED}👉 $1${CLEAR}\n";
  fi
  echo "Usage: $0 [-c config]"
  echo "  -c, --config    beta or prod"
  echo "\nExample:\n$0 --config beta\n"
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -c|--config) BUILD_CONFIG="$2"; shift;shift;;
  -v|--verbose) VERBOSE=1;shift;;
  *) usage "Unknown parameter passed: $1"; shift;shift;;
esac; done

# verify params
if [ -z "${BUILD_CONFIG}" ]; then usage "Please specify a build config"; fi;

cd $(dirname $0)/..

# Git secret
echo "🔓 Unlocking secrets..."
brew install git-secret
echo $GPG_PRIVATE_KEY | tr ',' '\n' > ./private_key.gpg
gpg --import ./private_key.gpg
git secret reveal

# Fastlane
bundle install
bundle update fastlane
bundle exec fastlane build_and_distribute config:${BUILD_CONFIG}