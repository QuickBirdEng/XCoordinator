
# Preparation

cd "$( dirname "$0" )"
undocumented_file_url="../docs/undocumented.json"

# Execution

./docs.sh

if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
    if [[ $(wc -l <$undocumented_file_url) -ge 2 ]]; then
        echo "$(cat $undocumented_file_url)"
        exit 1
    else
        exit 0
    fi
else
    echo "$(git status)\n$(git diff)"
    exit 1
fi
