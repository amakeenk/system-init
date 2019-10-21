#!/bin/bash -e

_user=$1
_cur_dir=$(pwd)

[ -z ${_user} ] && echo "usage: $0 [user]" && exit 1
[ $(whoami) != "root" ] && echo "This script must be run under root user" && exit 1

echo "${_user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ln -sv /sbin/reboot /usr/bin/reboot
ln -sv /sbin/poweroff /usr/bin/poweroff

apt-get update
apt-get dist-upgrade
update-kernel
apt-get install $(cat pkglist)
while true
do
    _pkglist=$(apt-cache list-nodeps | egrep "devel|'^lib[^-]*$'|python")
    if [ -z ${_pkglist} ]; then
        break
    else
        apt-get remove ${_pkglist}
    fi
done

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
