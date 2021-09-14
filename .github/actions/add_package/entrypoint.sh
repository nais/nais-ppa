#!/usr/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # pipeline returns last non-zero status

eval "$(ssh-agent -s)"
ssh-add - <<< "${REPO_KEY}"
cd "$(mktemp --directory)"
git clone git@github.com:nais/nais-ppa.git
cd nais-ppa

# 'Unpack' deb file for PPA purposes
sudo apt update
sudo apt install dpkg-dev apt-utils
wget ${URL} -O ${BASENAME}
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
apt-ftparchive release . > Release

# Set-up GPG
mkdir -p ~/.gnupg
echo "use-agent" >> ~/.gnupg/gpg.conf
echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
echo RELOADAGENT | gpg-connect-agent
gpg --batch --import <(echo -n "${GPG_PRIVATE_KEY}" | base64 -d)

# Sign repo artifacts
echo ${GPG_PASSPHRASE} | gpg --batch --no-tty --pinentry-mode=loopback --yes --passphrase-fd 0 --default-key "${EMAIL}" -abs -o - Release > Release.gpg
echo ${GPG_PASSPHRASE} | gpg --batch --no-tty --pinentry-mode=loopback --yes --passphrase-fd 0 --default-key "${EMAIL}" --clearsign -o - Release > InRelease

# Commit and push changes
git config user.email "${EMAIL}"
git config user.name "nais-ppa add_package action"
git add .
git --no-pager diff --cached
git commit -a -m "Add ${BASENAME}"
git push
