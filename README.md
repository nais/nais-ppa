nais-ppa
========

A PPA with our user tools.

How to use
----------

```bash
NAIS_GPG_KEY="/usr/local/share/keyrings/nav_nais.gpg"
sudo mkdir -p "$(dirname "$NAIS_GPG_KEY")"
curl -sfSL "https://ppa.nais.io/KEY.gpg" | gpg --dearmor | sudo dd of="$NAIS_GPG_KEY"
sudo add-apt-repository "deb [signed-by=$NAIS_GPG_KEY] https://ppa.nais.io/ ./"
sudo apt update
```

When you have done this, you are able to install our tools using apt:

```bash
sudo apt install <tool>
```
