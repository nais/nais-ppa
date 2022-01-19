#!/usr/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # pipeline returns last non-zero status

NUMBER_TO_KEEP=10

for name in 'naisdevice-*.deb' 'nais_*.deb'; do
  printf "%s\n" ${name} | head -n "-${NUMBER_TO_KEEP}" | xargs --no-run-if-empty --verbose rm
done

# Commit and push changes
git config user.email "aura@nav.no"
git config user.name "nais-ppa cleanup action"
git add .
git --no-pager diff --cached
git commit -a -m "Update metadata"
