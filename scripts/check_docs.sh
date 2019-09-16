./docs.sh
if [ -z "$(git status --untracked-files=no --porcelain)" ]; then 
   exit 0
else
   exit 1
fi
