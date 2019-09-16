./build.sh
jazzy_file_url="tmp_jazzy.json"
sourcekitten doc --spm-module XCoordinator > $jazzy_file_url
jazzy --sourcekitten-sourcefile $jazzy_file_url
rm $jazzy_file_url
