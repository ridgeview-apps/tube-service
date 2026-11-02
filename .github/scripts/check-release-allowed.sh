#!/bin/bash
#
# Checks that a release of <version> can start from the checked-out main, or
# fails with a GitHub Actions error saying why. Run by the Start release
# workflow. It only reads, so it's also safe to run locally on main.
#
#   .github/scripts/check-release-allowed.sh 2.2.0

set -euo pipefail

version="$1"

fail() {
    echo "::error::$1" >&2
    exit 1
}

# On CI, the branch and commit the run was started on
started_on="${GITHUB_SHA:-$(git rev-parse HEAD)}"
ref="${GITHUB_REF:-refs/heads/$(git branch --show-current)}"

[ "$ref" = refs/heads/main ] || fail "Run this from main, not ${ref#refs/heads/}"

# Releases exactly the commit the run was started on. A queued run fails here
# once an earlier one has bumped main
main=$(git ls-remote origin refs/heads/main | cut -f1)
if [ "$(git rev-parse HEAD)" != "$started_on" ] || [ "$main" != "$started_on" ]; then
    fail "main has moved from ${started_on:0:7} to ${main:0:7} since this run started. Check what's on main, then run it again"
fi

tags=$(git ls-remote --tags --refs origin | sed 's|.*refs/tags/||')

# A release is in progress until it's submitted for review, which tags it
in_progress=()
for branch in $(git ls-remote --heads origin 'refs/heads/release/*' | sed 's|.*refs/heads/||'); do
    grep -qxF "${branch#release/}" <<< "$tags" || in_progress+=("$branch")
done
if [ ${#in_progress[@]} -gt 0 ]; then
    fail "A release is in progress (branches with no tag yet): ${in_progress[*]}"
fi

latest=$(grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' <<< "$tags" | sort -V | tail -n 1 || true)
if [ -n "$latest" ]; then
    newest=$(printf '%s\n%s\n' "$latest" "$version" | sort -V | tail -n 1)
    if [ "$version" = "$latest" ] || [ "$newest" != "$version" ]; then
        fail "$version isn't newer than the latest release, $latest. Has main been bumped?"
    fi
fi

echo "Release $version can start from ${started_on:0:7}"
