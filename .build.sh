#!/bin/sh

set -o pipefail
swift build test \
    -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" \
    -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator" \
    -Xswiftc "-lswiftUIKit"
