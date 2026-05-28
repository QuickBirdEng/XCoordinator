#!/bin/sh

# Previews DocC documentation in a local web server.
# Runs unchanged on Apple Silicon and Intel Macs.

set -e -o pipefail

cd "$(dirname "$0")/.."

swift package \
    --disable-sandbox \
    preview-documentation \
    --product XCoordinator
