#!/bin/sh

# Preparation

cd "$( dirname "$0" )"

# Constants

jazzy_file_url="tmp_jazzy.json"

# Execution

cd ..
sourcekitten doc --spm-module XCoordinator -- \
    -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" \
    -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator" \
    > $jazzy_file_url
jazzy --sourcekitten-sourcefile $jazzy_file_url

# Cleanup

rm $jazzy_file_url
