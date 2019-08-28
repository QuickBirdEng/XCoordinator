swift build \
	-Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" \
	-Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator"
jazzy_file_url="tmp_jazzy.json"
sourcekitten doc --spm-module XCoordinator > $jazzy_file_url
jazzy --sourcekitten-sourcefile $jazzy_file_url
rm $jazzy_file_url
