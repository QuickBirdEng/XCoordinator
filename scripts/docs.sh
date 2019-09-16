#!/bin/sh

# Preparation

cd "$( dirname "$0" )"

# Constants

jazzy_file_url="tmp_jazzy.json"

# Execution

./build.sh
cd ..
sourcekitten doc --spm-module XCoordinator > $jazzy_file_url
jazzy --sourcekitten-sourcefile $jazzy_file_url

# Cleanup

rm $jazzy_file_url
