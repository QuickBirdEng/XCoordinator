#!/bin/sh

# Preparation

set -o pipefail

# Constants

TARGET_PLATFORM="iphoneos"
TARGET_SDK="arm64-apple-ios16.4"

# Execution

swift package \
    -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk $TARGET_PLATFORM --show-sdk-path`" \
    -Xswiftc "-target" -Xswiftc $TARGET_SDK \
    --allow-writing-to-directory Documentation \
    generate-documentation \
    --output-path Documentation \
    --transform-for-static-hosting \
    --target "XCoordinator"
