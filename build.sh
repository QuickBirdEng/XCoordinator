#!/bin/sh

set -o pipefail
xcodebuild test -project XCoordinator.xcodeproj -scheme XCoordinatorTests -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest'

