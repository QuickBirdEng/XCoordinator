#!/bin/sh

# Previews DocC documentation in a local web server.
# Runs unchanged on Apple Silicon and Intel Macs.

set -e -o pipefail

cd "$(dirname "$0")/.."

echo "1. Building documentation archive for iOS..."
(./Scripts/docs.sh)

# Locate the generated archive (docs.sh builds into .build/docs-derived-data)
DOCC_ARCHIVE=$(find .build/docs-derived-data -type d -name "XCoordinator.doccarchive" | head -n 1)

if [ -z "$DOCC_ARCHIVE" ]; then
  echo "Error: Could not find the generated XCoordinator.doccarchive artifact."
  exit 1
fi

echo "2. Transforming archive for local static web hosting..."
STATIC_OUT=".build/Documentation/static"
rm -rf "$STATIC_OUT"

xcrun docc process-archive transform-for-static-hosting "$DOCC_ARCHIVE" \
  --output-path "$STATIC_OUT"
  
DOCC_URL=http://localhost:8000/documentation/xcoordinator

echo "--------------------------------------------------------"
echo "Documentation server running!"
echo "$DOCC_URL"
echo "--------------------------------------------------------"

# 3. Serve the interactive documentation site
python3 -m http.server --directory "$STATIC_OUT" 8000
