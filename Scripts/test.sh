#!/bin/sh

# Runs the XCoordinator tests on an iOS Simulator.
#
# The tests exercise real UIKit view-controller transitions, which only work when a
# UIWindowScene exists — something a bare SwiftPM test bundle does not provide. They
# therefore run through the TestHost application (TestHost/XCoordinatorTestHost.xcodeproj),
# which references this package and hosts the tests in Tests/XCoordinatorTests.
#
# An available iPhone simulator is resolved at runtime so this works across Xcode
# versions (which ship different device names) on both local machines and CI.

set -e -o pipefail

cd "$(dirname "$0")/.."

DEVICE_ID=$(xcrun simctl list devices available -j | python3 -c '
import json, sys
devices = json.load(sys.stdin)["devices"]
candidates = [
    dev["udid"]
    for runtime, devs in devices.items() if "iOS" in runtime
    for dev in devs if "iPhone" in dev["name"]
]
print(candidates[0] if candidates else "")
')

if [ -z "$DEVICE_ID" ]; then
    echo "error: no available iPhone simulator found" >&2
    exit 1
fi

xcodebuild test \
    -project TestHost/XCoordinatorTestHost.xcodeproj \
    -scheme XCoordinatorTestHost \
    -destination "id=$DEVICE_ID" \
    -skipPackagePluginValidation \
    CODE_SIGNING_ALLOWED=NO
