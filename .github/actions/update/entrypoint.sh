#!/usr/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # pipeline returns last non-zero status

# For debugging
echo Contents of working directory ${PWD}:
ls -la


# 'Unpack' deb file for PPA purposes
apt-ftparchive packages . > Packages
gzip -k -f Packages
apt-ftparchive release . > Release

# Set-up GPG
mkdir -p ~/.gnupg
chmod u=rwx,g=,o= ~/.gnupg
echo "use-agent" >> ~/.gnupg/gpg.conf
echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
echo RELOADAGENT | gpg-connect-agent
gpg --batch --import <(echo -n "${GPG_PRIVATE_KEY}" | base64 -d)

# Sign repo artifacts
echo ${GPG_PASSPHRASE} | gpg --batch --no-tty --pinentry-mode=loopback --yes --passphrase-fd 0 --default-key "aura@nav.no" -abs -o - Release > Release.gpg
echo ${GPG_PASSPHRASE} | gpg --batch --no-tty --pinentry-mode=loopback --yes --passphrase-fd 0 --default-key "aura@nav.no" --clearsign -o - Release > InRelease

# Commit and push changes
git config user.email "aura@nav.no"
git config user.name "nais-ppa update action"
git add .
git --no-pager diff --cached
git commit -a -m "Update metadata"
