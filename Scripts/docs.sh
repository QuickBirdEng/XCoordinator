#!/bin/sh

# Generates static-hosting DocC output into ./Documentation.
# Uses the iOS Simulator SDK and lets the toolchain pick the matching target triple,
# so it runs unchanged on Apple Silicon and Intel Macs and on whatever Xcode is current.

set -e -o pipefail

cd "$(dirname "$0")/.."

swift package \
    --allow-writing-to-directory Documentation \
    generate-documentation \
    --target XCoordinator \
    --output-path Documentation \
    --transform-for-static-hosting
