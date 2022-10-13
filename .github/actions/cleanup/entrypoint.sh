#!/usr/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # pipeline returns last non-zero status

NUMBER_TO_KEEP=10

echo --- Make ${PWD} safe for git
git config --global --add safe.directory /github/workspace

echo --- Removing old files
for name in 'naisdevice-*-*-*-*.deb' 'naisdevice-tenant-*-*-*-*.deb' 'nais_*.deb'; do
  printf "%s\n" ${name} | head -n "-${NUMBER_TO_KEEP}" | xargs --no-run-if-empty --verbose git rm
done

echo --- Check for changes to commit
if ! git diff --staged --quiet; then
  echo --- Commit and push changes
  git config --global user.email "aura@nav.no"
  git config --global user.name "nais-ppa cleanup action"
  git add .
  git --no-pager diff --cached
  git commit -a -m "Remove old versions"
  git push
else
  echo --- No changes to commit
fi
