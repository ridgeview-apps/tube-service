#!/bin/bash
#
# Starts a release from main: pushes release/<version> for the version in
# Config/Base.xcconfig (which starts the Prod workflow), then bumps main to the
# next minor version. Shows the release notes and asks before pushing anything.
#
#   Scripts/start-release.sh            # e.g. release/2.2.0, main -> 2.3.0
#   Scripts/start-release.sh --major    # main -> 3.0.0 instead
#   Scripts/start-release.sh --dry-run  # show what would happen, change nothing

set -eo pipefail

lane_options=()
for arg in "$@"; do
    case "$arg" in
        --major) lane_options+=("bump:major") ;;
        --dry-run) lane_options+=("dry_run:true") ;;
        *)
            echo "Unknown option '$arg'. Use --major and/or --dry-run" >&2
            exit 1
            ;;
    esac
done

cd "$(dirname "$0")/.."
bundle install --quiet
bundle exec fastlane start_release "${lane_options[@]}"
