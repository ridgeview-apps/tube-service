#!/bin/zsh
# Generates the App Store screenshots locally, for checking before an upload.
# Uploading runs on CI, so this needs no App Store Connect key.
#
#   Scripts/screenshots.sh                       # into /tmp/tube-service-screenshots
#   Scripts/screenshots.sh --output-dir ~/Desktop/shots

set -e

output_dir=/tmp/tube-service-screenshots

while [[ $# -gt 0 ]]; do
  case $1 in
    --output-dir) output_dir=$2; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

mkdir -p "$output_dir"
output_dir=$(cd "$output_dir" && pwd)

cd $(dirname $0)/..
bundle install
bundle exec fastlane screenshots output_directory:"$output_dir"
echo "Screenshots: $output_dir"
