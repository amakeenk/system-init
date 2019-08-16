#!/bin/bash -e

_user="$1"

mkdir /home/${_user}/{scripts,apps,alt,docker}

cd /home/${_user}/scripts
for repo in system-init my-scripts conky-config hsh-build-scripts my-kde-themes updater my-bashrc
do
    git clone git@github.com:amakeenk/${repo}.git
done

cd /home/${_user}/docker
git clone git@github.com:amakeenk/my-dockerfiles.git
