.PHONY: update

update:
	dpkg-scanpackages --multiversion . > Packages
	gzip -k -f Packages
	apt-ftparchive release . > Release
	echo ${PPA_GPG_PASSPHRASE} | gpg --batch --no-tty --pinentry-mode=loopback --yes --passphrase-fd 0 --default-key "${EMAIL}" -abs -o - Release > Release.gpg
	echo ${PPA_GPG_PASSPHRASE} | gpg --batch --no-tty --pinentry-mode=loopback --yes --passphrase-fd 0 --default-key "${EMAIL}" --clearsign -o - Release > InRelease
