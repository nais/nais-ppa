FROM ubuntu:latest

RUN apt-get --assume-yes update && \
    apt-get --assume-yes install apt-utils gnupg git

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
