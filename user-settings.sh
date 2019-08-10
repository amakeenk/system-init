#!/bin/bash -e

_user="$1"

mkdir /home/${_user}/{scripts,apps,alt,docker}

cd /home/${_user}/scripts
git clone git@github.com:amakeenk/system-init.git
git clone git@github.com:amakeenk/my-scripts.git
git clone git@github.com:amakeenk/conky-config.git
git clone git@github.com:amakeenk/hsh-build-scripts.git
git clone git@github.com:amakeenk/my-kde-themes.git
git clone git@github.com:amakeenk/updater.git
git clone git@github.com:amakeenk/my-bashrc.git

cd /home/${_user}/docker
git clone git@github.com:amakeenk/my-dockerfiles.git
