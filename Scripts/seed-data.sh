#!/bin/zsh
# Regenerates the app's bundled station files from live TfL data.
#
#   Scripts/seed-data.sh                        # regenerate every file
#   Scripts/seed-data.sh --only national-rail   # regenerate one file
#   Scripts/seed-data.sh --dry-run              # check the new data without writing it
#   Scripts/seed-data.sh --allow-shrink         # write even if a file lost more than 5% of its entries
#   Scripts/seed-data.sh --summary changes.md   # also write a Markdown summary of what changed
#   Scripts/seed-data.sh --help

set -e

cd $(dirname $0)/..
swift run --quiet --package-path Scripts/SeedData seed-data "$@"
