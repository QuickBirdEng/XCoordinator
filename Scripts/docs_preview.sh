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
    --disable-sandbox \
    preview-documentation \
    --product XCoordinator
