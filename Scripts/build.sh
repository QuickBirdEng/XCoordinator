#!/bin/sh

# Builds the XCoordinator package against the iOS Simulator SDK.
# Works on both Apple Silicon and Intel Macs — the toolchain selects the appropriate arch.

set -e -o pipefail

cd "$(dirname "$0")/.."

xcodebuild build \
    -scheme XCoordinator \
    -destination 'generic/platform=iOS Simulator' \
    -skipPackagePluginValidation \
    CODE_SIGNING_ALLOWED=NO
