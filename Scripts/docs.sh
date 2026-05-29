#!/bin/sh

# Generates static-hosting DocC output into ./Documentation.
#
# Builds the DocC archive against the iOS SDK via `xcodebuild docbuild` (the
# package depends on UIKit, so a plain SwiftPM host build fails with
# "no such module 'UIKit'"), then transforms it for static hosting.
#
# Pass an optional hosting base path as the first argument (used when publishing
# to GitHub Pages):
#
#   Scripts/docs.sh              # local / CI validation build
#   Scripts/docs.sh XCoordinator # Pages build served under /XCoordinator

set -e -o pipefail

cd "$(dirname "$0")/.."

DERIVED_DATA=".build/docs-derived-data"

HOSTING_BASE_PATH_ARG=""
if [ -n "$1" ]; then
    HOSTING_BASE_PATH_ARG="--hosting-base-path $1"
fi

rm -rf "$DERIVED_DATA"

xcodebuild docbuild \
    -scheme XCoordinator \
    -destination 'generic/platform=iOS' \
    -derivedDataPath "$DERIVED_DATA" \
    ONLY_ACTIVE_ARCH=YES \
    CODE_SIGNING_ALLOWED=NO \
    OTHER_DOCC_FLAGS="--warnings-as-errors" \
    -quiet

ARCHIVE=$(find "$DERIVED_DATA" -type d -name 'XCoordinator.doccarchive' | head -n 1)
if [ -z "$ARCHIVE" ]; then
    echo "error: could not find XCoordinator.doccarchive under $DERIVED_DATA" >&2
    exit 1
fi

rm -rf ./Documentation

"$(xcrun --find docc)" process-archive transform-for-static-hosting "$ARCHIVE" \
    --output-path ./Documentation \
    $HOSTING_BASE_PATH_ARG
