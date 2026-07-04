#!/bin/bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SWIFT_FORMAT="$(xcrun --find swift-format 2>/dev/null || true)"

if [[ ! -x "$SWIFT_FORMAT" ]]; then
    echo "warning: swift-format not found in the active Xcode toolchain"
    exit 0
fi

cd "$REPO_ROOT"

find TubeService Packages TubeServiceTests TubeServiceUITests \
    -path "*/.build" -prune -o \
    -name "*.swift" \
    ! -path "TubeServiceUITests/SnapshotHelper.swift" \
    -print0 | xargs -0 "$SWIFT_FORMAT" lint --configuration "$REPO_ROOT/.swift-format" --parallel
