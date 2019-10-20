#!/bin/bash -e

_user=amakeenk
_cur_dir=$(pwd)

[ $(whoami) != "root" ] && exit 1

echo "${_user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ln -sv /sbin/reboot /usr/bin/reboot
ln -sv /sbin/poweroff /usr/bin/poweroff

apt-get update
apt-get install $(cat pkglist)
apt-get remove `apt-cache list-nodeps | grep '^lib[^-]*$'`
apt-get remove `apt-cache list-nodeps | grep python`

mkdir -p /local_repo/x86_64/RPMS.dir
chown -R ${_user}:${_user} /local_repo
apt-repo add 'rpm-dir file:/local_repo x86_64 dir'

sed -i "/set backup/d" /etc/vim/vimrc

hasher-useradd ${_user}
usermod ${_user} -aG docker

sed -i "/#tmpfs/s/#//" /etc/fstab
sed -i "/home\/tmp/d" /etc/fstab

plymouth-set-default-theme bgrt
make-initrd

echo "Reboot now? (y/n)"
read answer
[ ${answer} == y ] && reboot
